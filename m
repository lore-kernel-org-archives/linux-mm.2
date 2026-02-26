Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36786FD460A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E2B6B0089; Wed, 25 Feb 2026 22:11:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B6C6B008A; Wed, 25 Feb 2026 22:11:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436E96B008C; Wed, 25 Feb 2026 22:11:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301306B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:11:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D02371CA48
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:11:16 +0000 (UTC)
X-FDA: 84485131752.01.F851542
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9386F80004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:11:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=XWNWopPR;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.181 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772075474; a=rsa-sha256;
	cv=none;
	b=E9LHQiXaesAOeGfSwqC6tT7dNEYt0gW/kX78+cQSXzxQekZbUUAx+4ISMl1IGoYprokseT
	17yXGCLCqwNdoiENYTqTn79RFPY7RKzutJQSsjNTLugCA0NGOPwqD+v7hHweJL+Wu+qknf
	FxFRCUdRqS2eMU2wBc0zEQp5ossdBLw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=XWNWopPR;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.181 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aeYTgjykkTytqAP0zVL+KvrFyKRcfVgTb0o5/+caF4=;
	b=SsPFs8SRNZzVq/g43GuZLfMxtOLmNzC8g75HltUAg9ZippRRZprZYt6MxMHAU1IoKQ3UsR
	WGRRY/LDyjGOYkyO7Co9IsnLly6uIELZQE4K2LxHreRHhU4AQMvbJL/sUdfkYpXNOBxfDN
	uvIMraHF2W6Cy/vWk/cOBFKs6G3OQm8=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4638fe85a7eso160023b6e.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772075473; x=1772680273; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2aeYTgjykkTytqAP0zVL+KvrFyKRcfVgTb0o5/+caF4=;
        b=XWNWopPR0diWntttR6QUQ4SJ9ROfDJqcuLeCxXH9JaQkGdCbmCIqG+Eh/oLrmGfn8L
         7uLwdM3ZZT3meWVledn7uARsHUzsf2NhG3B36WnUYOwJmttBc3fNj3PE27gnEUsrZ+rq
         mYw4HR+3tlt6/NKQUbttBciRJO1KtgYlkG81mNKUI5gay4Jcl0XrPc8cFoF6l0LDTJhQ
         od0wzbevA75gTVJtQnzjHsA308RXkfBl/hKFRvdSQmhxuRGjwN8puu7F1IYKQju7rRzM
         gty/yP5Jzt/lsD4ytYJ+vHizLAKym2ipY6Pcm8vblcvC+2d9Su0PN4N9S28D+EPrZEhb
         WTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772075473; x=1772680273;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2aeYTgjykkTytqAP0zVL+KvrFyKRcfVgTb0o5/+caF4=;
        b=vTAsJwuIsS52+aE4hIg+NcFa3HkDfjWt3RxEB0vNR+in6zpSbcPs5/aXr5BnPTBF4e
         60YkA0yzjp+E1nH0Ilv5CQSd6Plb/PkVVTJ10uX4zty29izvw3j9VYXDh74kOrCNp9Ms
         5lCxoiJPwvakDkV6muKgXGMO2RFseTmpvEBkhXk0qX3R5pcZL304c4bO9TsdzVnttREy
         oOboncu9q/Qz3pkPmVoT2hHvhnajTeYmwmEk1kHq5RL4nFAUE4c0Kw529J6YtAxqoaEa
         rfqr3PEtG0HdQDtx0Ui7bhcs4ueWBCdAbilcRgJ4lLJiV317+uYJtP/WhNuae7ZX0jsp
         hloA==
X-Forwarded-Encrypted: i=1; AJvYcCXp7pPwq9oYlcBFS4HAjAEDYwt4jEXCtLA3mVAinKJ59Bjr4qwg1Pp1ZC6Zzm4ZkkF6PEMjkrVfVg==@kvack.org
X-Gm-Message-State: AOJu0YwEtYVYTdWDCjAapaXCtXCLXL1Icxic5UAjCaNqaKKi5+F4UjqX
	4au/SnHKUVB4w99T3Qh3CRey2ea5M4HgdpDK/ITrpPinlWEUKgjPBGYXUD5F8K30yfY=
X-Gm-Gg: ATEYQzzy6oooYVIgE9hetaf7RYawAuFmd4D+22lk+9fZ96HVFXup1q7PRTaMFq9OGWT
	H3wpyPripw/vaFoSIAveyHm2MrgZy4bYNvSHjW0zffNfAX2J4sABDDCp4pAQiAhRI2xBlwmL/au
	5dOow43Ktuq6WCYPKta5mGrFdGu5ZqwYwhtiZ1FV5LuxMTfO03zyGM8aIPe5+qsAhpRBPQ6L1Bg
	ykaKorQgsLymTJX8I6M+ZTl0vP/e0ZFbb4t9E4AtTzH/qbQ17RSeLJmLXDtbiTY0UW0PFPAPTUq
	HDkuaKOJnOLAG2qYuTfw2djvUcXYFXWhEeAHHroHema/h5x1liDMTmVQwLKE91JgESnuDz+3MA7
	ISMyMG3ohRznybElVjJJin9FwV3RKpy2XSLxAX8N6GK6bkPWRqciErMcm/veP0uULAYl2gzFgoI
	lSQqsiuWC7LQhtvvlGQIJHiZol2KIg+LGssfWleOLl6YsG+VJt2i+HRGB3HmvOij6TWtQ6RZikM
	E/SkjvU8g==
X-Received: by 2002:a05:6808:4fd4:b0:45e:dbda:add6 with SMTP id 5614622812f47-464463e38fbmr8708984b6e.57.1772075473379;
        Wed, 25 Feb 2026 19:11:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4644a1f6333sm10281996b6e.19.2026.02.25.19.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 19:11:12 -0800 (PST)
Message-ID: <2e919e7b-1e75-4e57-b6f1-cdf3da4c0424@kernel.dk>
Date: Wed, 25 Feb 2026 20:11:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Bob Copeland <me@bobcopeland.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
 <CAKha_srSdS46FM8K-RKaiinP0y6kx_MhxnHjZ0KKP1NOAL+STA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAKha_srSdS46FM8K-RKaiinP0y6kx_MhxnHjZ0KKP1NOAL+STA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9386F80004
X-Stat-Signature: ojhzxujjwao5prnu1on4inp9xosg35mb
X-HE-Tag: 1772075474-525096
X-HE-Meta: U2FsdGVkX19UrzoTaBZaqy0vad60TDPtpty0piwFddg9c/IC0EaNUhp3ARr71TrMI5LHU88sUc366f9PScFgl2GJCYwsf7JSl4GBoQeT9+1bDt1T0ETeI7QJzD+WEYN66ByVx/F7Lorzhq8UZQXA1WCySlbaUS2xtCMgg+RA0uH32xt1tOBxxWARJDZRoUgk+4f8zXUPz7Wd5ZUW2g0KUqcg3Sba2dM76+IjKgwYg4mOBBn08qr98wfc6xcAL3GT12/MUNyjZNpGHerKOeoAYeVzkhRK9uIbe4idM1xP7xESiWIghtaQMFsdcyx6g1pC4X13vTeMrjHqM9NCcrtu+bsVQdYxBB6dyHTWlULRvDpuwoNdG03BcOwGt+BDL1YZg0/9opzX7kMRKbdP0YujMTlT08b+36+zHjgh26B1N5aQdk7tlWKv6b7TMIBQnzxh36CJLzjD+8+SMiaml44TQa/nuAHmK7qjzH35JrOMB4PyIfz4vcTGr8yAMUWqFXlYuH/d7mpv0Hmvxa6lFqiLIBEcdPVB3yg1nBqJoIIhUfcq/EOt5IUwW57AT3eeawljmCOjUDTZms260b+a+SymuhOBples8NaG8+53iRZ5pZ/u9dcVc8UkfP0ls/7oGI3zdVaxu9lCDUDwy3kdF4vFX3aidHT4D6ZC3sDrr4unM301vkE/cyD2Uvx0qKiAmOozZiu73k6oHlkIiDpcFVQlruRDhaY1dNN3NLu6b1X3vFdWnf8WloAuQuHmEra7Y5wHRB17q2aMEAc8SinwmJ0mpJe+66J/7fihaidIzBLYwOMTH88arAnQ45RMv78aq4I0fuMupB2SBhU+HzCidrT1M51cJTnPjOzEt81rPl8OfpDwW/ZYF5VhyyeVMklFL9t588C9qMBFSxWbthtydh/Aww1Cq5aIHETzDu/H953Yyt7phl3Bl8qgtZL7kgvvGKi2qlabSuKH9W4UXFDWppR
 pXg4lJ90
 tQzuwOD/4qJE8CjTFdcylH6rQc9p6Eo2pvOd78Wb1A6+RnetREVppgAF0b5a0161qVZxV0bwO3ajpdBcN+j5aqOxMnI4ImtWRC51UiKif1VvdABUE6u9sl6cEoouSPkU3ogpcWLhxjr7ZriJzC3Q/E6PzWUiTBic6pCmmTENRbU1dkfHNzYwGo9YkWVIZu2BboOJ4z/3Mnru6/ysKLsveM5i8Dy0VTLEbyfBw/4MMjTLOi8CS6O9eYbyDDpD0AgNkGWRn1L7DuwbPlUhtvkeGlYdZgUM6pZzQuAK9bPZI5DdCpbicxIwKM+ajS3ti+Xs/pCcY794QpS1qcMVfo/3+6hAsjsp2SUBXKKcb8owyMeFU/NQXjO39mvWBF3TVwm7QNa4sQUprh7f05JBcWUHF2x+yK08upxgRLWLh/EAFVrqXSmmwgA0yz2eeWqjVq7ugVzcIVR2entSP1Sc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 6:38 PM, Tal Zussman wrote:
> On Wed, Feb 25, 2026 at 5:52?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/25/26 3:40 PM, Tal Zussman wrote:
>>> folio_end_dropbehind() is called from folio_end_writeback(), which can
>>> run in IRQ context through buffer_head completion.
>>>
>>> Previously, when folio_end_dropbehind() detected !in_task(), it skipped
>>> the invalidation entirely. This meant that folios marked for dropbehind
>>> via RWF_DONTCACHE would remain in the page cache after writeback when
>>> completed from IRQ context, defeating the purpose of using it.
>>>
>>> Fix this by deferring the dropbehind invalidation to a work item.  When
>>> folio_end_dropbehind() is called from IRQ context, the folio is added to
>>> a global folio_batch and the work item is scheduled. The worker drains
>>> the batch, locking each folio and calling filemap_end_dropbehind(), and
>>> re-drains if new folios arrived while processing.
>>>
>>> This unblocks enabling RWF_UNCACHED for block devices and other
>>> buffer_head-based I/O.
>>>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>  mm/filemap.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>>  1 file changed, 79 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index ebd75684cb0a..6263f35c5d13 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -1085,6 +1085,8 @@ static const struct ctl_table filemap_sysctl_table[] = {
>>>   }
>>>  };
>>>
>>> +static void __init dropbehind_init(void);
>>> +
>>>  void __init pagecache_init(void)
>>>  {
>>>   int i;
>>> @@ -1092,6 +1094,7 @@ void __init pagecache_init(void)
>>>   for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
>>>   init_waitqueue_head(&folio_wait_table[i]);
>>>
>>> + dropbehind_init();
>>>   page_writeback_init();
>>>   register_sysctl_init("vm", filemap_sysctl_table);
>>>  }
>>> @@ -1613,23 +1616,94 @@ static void filemap_end_dropbehind(struct folio *folio)
>>>   * If folio was marked as dropbehind, then pages should be dropped when writeback
>>>   * completes. Do that now. If we fail, it's likely because of a big folio -
>>>   * just reset dropbehind for that case and latter completions should invalidate.
>>> + *
>>> + * When called from IRQ context (e.g. buffer_head completion), we cannot lock
>>> + * the folio and invalidate. Defer to a workqueue so that callers like
>>> + * end_buffer_async_write() that complete in IRQ context still get their folios
>>> + * pruned.
>>>   */
>>> +static DEFINE_SPINLOCK(dropbehind_lock);
>>> +static struct folio_batch dropbehind_fbatch;
>>> +static struct work_struct dropbehind_work;
>>> +
>>> +static void dropbehind_work_fn(struct work_struct *w)
>>> +{
>>> + struct folio_batch fbatch;
>>> +
>>> +again:
>>> + spin_lock_irq(&dropbehind_lock);
>>> + fbatch = dropbehind_fbatch;
>>> + folio_batch_reinit(&dropbehind_fbatch);
>>> + spin_unlock_irq(&dropbehind_lock);
>>> +
>>> + for (int i = 0; i < folio_batch_count(&fbatch); i++) {
>>> + struct folio *folio = fbatch.folios[i];
>>> +
>>> + if (folio_trylock(folio)) {
>>> + filemap_end_dropbehind(folio);
>>> + folio_unlock(folio);
>>> + }
>>> + folio_put(folio);
>>> + }
>>> +
>>> + /* Drain folios that were added while we were processing. */
>>> + spin_lock_irq(&dropbehind_lock);
>>> + if (folio_batch_count(&dropbehind_fbatch)) {
>>> + spin_unlock_irq(&dropbehind_lock);
>>> + goto again;
>>> + }
>>> + spin_unlock_irq(&dropbehind_lock);
>>> +}
>>> +
>>> +static void __init dropbehind_init(void)
>>> +{
>>> + folio_batch_init(&dropbehind_fbatch);
>>> + INIT_WORK(&dropbehind_work, dropbehind_work_fn);
>>> +}
>>> +
>>> +static void folio_end_dropbehind_irq(struct folio *folio)
>>> +{
>>> + unsigned long flags;
>>> +
>>> + spin_lock_irqsave(&dropbehind_lock, flags);
>>> +
>>> + /* If there is no space in the folio_batch, skip the invalidation. */
>>> + if (!folio_batch_space(&dropbehind_fbatch)) {
>>> + spin_unlock_irqrestore(&dropbehind_lock, flags);
>>> + return;
>>> + }
>>> +
>>> + folio_get(folio);
>>> + folio_batch_add(&dropbehind_fbatch, folio);
>>> + spin_unlock_irqrestore(&dropbehind_lock, flags);
>>> +
>>> + schedule_work(&dropbehind_work);
>>> +}
>>
>> How well does this scale? I did a patch basically the same as this, but
>> not using a folio batch though. But the main sticking point was
>> dropbehind_lock contention, to the point where I left it alone and
>> thought "ok maybe we just do this when we're done with the awful
>> buffer_head stuff". What happens if you have N threads doing IO at the
>> same time to N block devices? I suspect it'll look absolutely terrible,
>> as each thread will be banging on that dropbehind_lock.
>>
>> One solution could potentially be to use per-cpu lists for this. If you
>> have N threads working on separate block devices, they will tend to be
>> sticky to their CPU anyway.
>>
>> tldr - I don't believe the above will work well enough to scale
>> appropriately.
>>
>> Let me know if you want me to test this on my big box, it's got a bunch
>> of drives and CPUs to match.
>>
>> I did a patch exactly matching this, youc an probably find it
> 
> Yep, that makes sense. I think a per-cpu folio_batch, spinlock, and
> work_struct would solve this (assuming that's what you meant by
> per-cpu lists) and would be simple enough to implement. I can put that
> together and send it tomorrow. I'll see if I can find your patch too.

Was just looking for my patch as well... I don't think I ever posted it,
because I didn't like it very much. It's probably sitting in my git tree
somewhere.

But it looks very much the same as yours, modulo the folio batching.

One thing to keep in mind with per-cpu lists and then a per-cpu work
item is that you will potentially have all of them running. Hopefully
they can do that without burning too much CPU. However, might be more
useful to have one per node or something like that, provided it can keep
up, and just have that worker iterate the lists in that node. But we can
experiment with that, I'd say just do the naive version first which is
basically this patch but turned into a per-cpu collection of
lock/list/work_item.

> Any testing you can do on that version would be very appreciated! I'm
> unfortunately disk-limited for the moment...

No problem - I've got 32 drives in that box, and can hit about
230-240GB/sec of bandwidth off those drives. It'll certainly spot any
issues with scaling this and having many threads running uncached IO.

-- 
Jens Axboe

