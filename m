Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF29CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 02:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A156B008C; Sat, 17 Oct 2026 22:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51A56B0092; Sat, 17 Oct 2026 22:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E3F6B0093; Sat, 17 Oct 2026 22:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6A06B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:47:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6AD41C3AAD
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:47:42 +0000 (UTC)
X-FDA: 85334211564.30.1546793
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF392140004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:47:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AUjG3K+Q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792291660;
	b=EsiVjZKn7084dBRqrR1JOrcE+vG7uMWxELrnR46PxbPOhiRWeyxzL6udzJ9ilmrUkKKjJG
	BjC4DiVRn2Edfa1dKN3b5Z0jb44DxvoZsbDngyk+kJMAb8HqvpLMyItKtYXLqDPJoBw2M1
	Vr5zj0f+nQ0+jku9mwxlCdjjpYXIvhA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AUjG3K+Q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792291660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6vhl9H/bI+MfnZt/1kQc+tu5ODLFIoF8c4dyDq9S+M=;
	b=o1d3c04Cu0OqXhgl5FpkE6Lrbj8exUZJZta/h8reB1pk9SsPOyHNqH2nWfQV+MHBfwxZGf
	TPg2pRM5OcMbrYjsXJgpjNZXLZCHSj8wsHiobdEb9kS7N7s2nKdYiHmXEYn92pm8X7N4V9
	HYO73bbWp4fGLxyv2mWuNPTyO02Qhck=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792291655; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z6vhl9H/bI+MfnZt/1kQc+tu5ODLFIoF8c4dyDq9S+M=;
	b=AUjG3K+Q8z8QJCWy4QkcC8p8F7xau0Is1yDOvCdt407JXoZRO2GEzhX3iHC7qLslEye8lTCaeuVGhsZmT1gkZK2epDSIMIyUeqeddoLF4dKLDUZLQ7zH4fuEP9FFT6BMU3Tv7gg0NFlJcTR6aQmEy+iP966vaia82WUWDPvGSrQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XCyL-xi_1792291651;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCyL-xi_1792291651 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 18 Oct 2026 10:47:32 +0800
Message-ID: <b1b3d8d7-7201-4b75-a0f0-af383d854279@linux.alibaba.com>
Date: Sun, 18 Oct 2026 10:47:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hch@lst.de,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
 <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
 <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
 <cd6637db-7b30-4cbc-b07f-c2a2b32480fa@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <cd6637db-7b30-4cbc-b07f-c2a2b32480fa@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: AF392140004
X-Stat-Signature: fckdyjuo8rdpbupenptrqtdkqn64yagq
X-HE-Tag: 1792291658-380474
X-HE-Meta: U2FsdGVkX1+oLg6ohSJxl78dstEkw7zbhFgoRw200318OjEF4iYl9/9X5EqYHyk14gkPbH2G4VPazhEq2iNEJPIpj9x6ZGjuSlrAw0va0frW1mWMF2/IE5uIx1sO6YojgxvU9qh7gNCWdI1f7DCCZBVAhRXNnI7ptYd9SeX3UXcHkwQV7GH4LXH99BBcS7wDeWOakzawYiVRu21FgiIey6e1rDPbTy/u/hURnBckyFP4ITxS+yUS3Ytes6DV5gdgo5ld63/mj3plpHEOdt5TiOAEjcTUr2H3ToIibHVk6hElkRuTW33IQzCHt339c0n4S11BSc5z+Dog9hlQemue5fEnmYkHJufkjL4GrQZMW8u8oDsdkgO+4dv+AUmw+slmq5Zw8BF6unSgrbjdRhOKx/ozgwOZ7MlH6AvhT+aamh9u59yCA+OWFxNe8d6kadX2c+p12YgbKv9Rb9hD0aOHSM15Wznp4X24yEipxAuyFzLqVk9V6ZtX4nev/HOjhM7VAboNrZLJnFAHbrLANBy7U9swzZg5N9MWfY+oxEFf2cyzNdSFp1VqBShp0apbMDoVfnj9j+b5Ft2T6Bs4esenQQ5Cqp5Z1xFKH6T9ScaUAOqRYKgX9Gzc8EuQImGvi15bxRsDkulgfBQzvaOIGkwGhNqXM37dkwiWQ4rZTf0cwo3YufXYAt9WLnXEcI8YIqBpBf8/RkBnRbjoDP60ws+bcUIG7cBg4H3YagmynC9TZ0+FcttgGZgIHqiQhgHo7JwrqtChQX61fWS3bKqtxhcwukXDkKxeTcc6eTFkQLa9lQT+jHpVhZovxr2JoRvGXUq3qtj1JJfxkW0DU1+Jh6ehiotiBPR1rf0hlMChwHt1Dex94mCIn615dM340cWiFvl3v1i3C+CnzKttfMybXESrIZPLT7m6PJYLhvoFanhFfKx3Nlp0xjCxQkgU+rP1EDVZKMtkFHzEuWjBoew1tZF
 qpTjAxYP
 RqBGi5ZMOfY0f234lWlnPKE0DqiYvvPecQWizst/UE3NwxW8vBIsp+2NFBAFVvZWZfvbUrnxEg2qxm7KvXZ+YSVLB9683am1XYQhwY0A/pOOVjsIDN7qdyE9FlRBl2180lCsmA0q2c0Pq4FtZMJnLycNzfBf/ij/awlCkNUXycJEBnwIiJn4JeHAXyfjDZNI0OlPfwPSgroLuJZ536c918+wKRwn4DmtB1MICsFwV3Hx0bmyzDCZw/ttN+LHi5uNxLgTzaKTC1IONwpMV7geBES9f+wUVnXRLOEOsj4QFbAP0w1iwmnd2nGjHBxFoU20sq9czA9Jqz7G7tXhfcCu+tl2hWh0tmPNbDlrFcOgY4NsLctuyAcdI67pDIRuF8mr0+YAjQZfOQAhrvRi6OjBTvf7AttrcId7RazsQCPwk3Dnxm+xhEzUncptjqiaLdb5wFiYNPZuKEPl9dekS143fxMXhhENfbBV3Vo2uwYIwRv5eBt6T4YYrt3lyDtyIuOGjBVzXHGND3uDb6RJaMpE9egH1JNhRFU5uAe8emC3RKDQlDKTV8yIW0Gqff/1dAx8u/Aq7N9QeoKz5znO/e/mjpjMtTw4qGBcViB/pjRlV7qKFDCkQidCmBAtsMO3A83ena1E+z+BaoPWhSb90D2fnYQC9KmkugQ1Be10ZDjNj9nLUP0qRPqi/bpwaNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/17/26 3:41 PM, Lance Yang wrote:
> 
> 
> On 2026/10/17 13:43, Baolin Wang wrote:
>>
>>
>> On 10/16/26 9:18 PM, Pedro Falcato wrote:
>>> On Fri, Oct 16, 2026 at 12:00:24PM +0100, Pedro Falcato wrote:
>>>> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 10/16/26 2:59 PM, Lance Yang wrote:
>>>>>> collapse_file() can end up calling page_cache_sync_readahead() with
>>>>>> source folios from earlier in the range still locked. If truncate 
>>>>>> already
>>>>>> holds mapping->invalidate_lock exclusively and is waiting for one of
>>>>>> those folios, readahead blocks on the same invalidate_lock and 
>>>>>> neither
>>>>>> side can make progress.
>>>>>>
>>>>>> Do readahead in a separate pass before we start holding source folios
>>>>>> locked for collapse. Keep page_cache_sync_readahead() and its 
>>>>>> existing
>>>>>> policy, and drop each folio's lock and reference after checking 
>>>>>> that it
>>>>>> is uptodate. If truncate or reclaim removes a folio between the two
>>>>>> passes, roll back instead of doing readahead again with source folios
>>>>>> locked.
>>>>>>
>>>>>> Shmem handles swapin and fallocated folios through shmem_get_folio()
>>>>>> without taking mapping->invalidate_lock, so it isn't affected by this
>>>>>> lock inversion.
>>>>>>
>>>>>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>>>>>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>>>>>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page 
>>>>>> cache with invalidate_lock")
>>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>>> ---
>>>>>
>>>>> Thanks for the fix.
>>>>>
>>>>>> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so 
>>>>>> I'm
>>>>>> happy to take this over.
>>>>>>
>>>>>> Some older stable trees lack the folio infrastructure used here, 
>>>>>> and the
>>>>>> code will differ for each stable tree, so each backport will need 
>>>>>> quite a
>>>>>> bit of rework and its own review. I'm not sure whether to Cc 
>>>>>> stable here.
>>>>>> Once we agree on the fix, I'll send a separate backport for each 
>>>>>> maintained
>>>>>> stable tree except 5.10, which isn't affected.
>>>>>>
>>>>>> v2 -> v3:
>>>>>>    - Replace the scan-wide invalidate_lock and 
>>>>>> page_cache_ra_unbounded() with
>>>>>>      a preparation pass using page_cache_sync_readahead().
>>>>>>    - Roll back on a new page cache miss during collapse.
>>>>>>    - https://lore.kernel.org/all/20260913163644.122133-1- 
>>>>>> ngocthang2710.1999@gmail.com/
>>>>>>
>>>>>>    mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>>>>>>    1 file changed, 31 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>> index ef5cd6fda34f..b3f67617caf0 100644
>>>>>> --- a/mm/khugepaged.c
>>>>>> +++ b/mm/khugepaged.c
>>>>>> @@ -2262,6 +2262,34 @@ static enum scan_result 
>>>>>> collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>>        new_folio->index = start;
>>>>>>        new_folio->mapping = mapping;
>>>>>> +    if (!is_shmem) {
>>>>>> +        /*
>>>>>> +         * Populate the range before accumulating locked source 
>>>>>> folios:
>>>>>> +         * readahead may block on invalidate_lock.
>>>>>> +         */
>>>>>> +        for (index = start; index < end;) {
>>>>>
>>>>> why drop xas_unlock_irq()?
>>>>>
>>>>>> +            folio = filemap_lock_folio(mapping, index);
>>>>>> +            if (IS_ERR(folio)) {
>>>>>> +                page_cache_sync_readahead(mapping, &file->f_ra,
>>>>>> +                              file, index, end - index);
>>>>>> +                folio = filemap_lock_folio(mapping, index);
>>>>>> +                if (IS_ERR(folio)) {
>>>>>> +                    result = SCAN_FAIL;
>>>>>> +                    goto rollback;
>>>>>> +                }
>>>>>> +            }
>>>>>> +            if (!folio_test_uptodate(folio))
>>>>>> +                result = SCAN_FAIL;
>>>>>
>>>>> Do we need to check PG_uptodate after locking the folio? If we 
>>>>> successfully
>>>>> lock the folio, doesn't that mean the read I/O has completed? The 
>>>>> following
>>>>
>>>> Yes, you do; a read can "complete" without the IO having completed 
>>>> successfully,
>>>> and in those cases PG_uptodate is not set, but the folio is unlocked.
>>
>> OK.
>>
>>>> Either way, why are we checking for uptodate here? We only care for 
>>>> starting readahead.
>>>> Anyway, I would possibly recommend we do this as post-processing, 
>>>> not pre-processing.
>>>> The current loop is a little overhead-happy.
>>>
>>> To clarify: I would do this kind of RA as an error path if isolation 
>>> failed.
>>
>> Sounds good.
>>
>>> Namely, at the end of rollback, after unlocking folios. It doesn't 
>>> make sense
>>> to me to do this kind of checking upfront. I don't think it's 
>>> particularly
>>> realistic that, starting RA upfront, you'd see uptodate completed 
>>> folio reads
>>> when doing the actual isolation.
>>
>> But why not add RA logic in collapse_pmd(), as we do for 
>> SCAN_PAGE_DIRTY_OR_WRITEBACK? There's already retry logic there, and 
>> this would also simplify the long collapse_file().
> 
> That would be cleaner, yeah. Some older stable trees don't have that
> outer retry loop, though ... I'd prefer to get the fix backported first,
> then move the RA/retry logic out in a follow-up, wdyt?

IIRC, the approach to bug fixes is to fix bugs properly and cleanly for 
upstream, without being constrained by backporting requirements.

Anyway, I don't have a strong opinion on this. Let's also see what David 
prefers.

