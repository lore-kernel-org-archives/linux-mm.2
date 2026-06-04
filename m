Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36048CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDE96B0092; Thu,  4 Jun 2026 02:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AEE56B0093; Thu,  4 Jun 2026 02:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4706B0095; Thu,  4 Jun 2026 02:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5716B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:46:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 118CF8EAC2
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:46:01 +0000 (UTC)
X-FDA: 84841295322.03.B54DEFC
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B0F04000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:45:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FNRZSfnc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780555559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhIU+QoUu5iwz8e1xyKoqpvvqNCKUWZqivCuhNU2rC0=;
	b=PgFVTkFXQcve8buiHzspSI+6pqdsAmwYaexeK/L+W+irFwEA8zB5jPvFLuko5YWSERxkGE
	wnjS/QpaXa3IsSCH/p9zC+Ujowl949KreMmkHQfQUInEE58Fx9coVvNKCwWLWv2bVLsbXj
	kb/XysnqwedNI9al6ENXlSJxmy0qpsE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FNRZSfnc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780555559;
	b=2eB7UO9iwwmt1bxhe+L+Mh5w23nE/SlhWaT4FyQQFLtjuTtALNPbuv2ubhF5UnV70YXklq
	WEn+WfaH8BIrAYCrmNRvuiGiTIsvhmJZfFiZJd83dQFzYsoWLvLne6fTMavE13kJBvcFy3
	n8qIYgH89WoeRBhbXOguAO0Ay3aoh4Q=
Message-ID: <02ae706c-0fa2-488a-8530-b6da8daf39ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780555555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KhIU+QoUu5iwz8e1xyKoqpvvqNCKUWZqivCuhNU2rC0=;
	b=FNRZSfncCTtCtDhmojfDOjkb8DdFyeYZDPH0LX4m3b/8ClYV4sV5MHLh4fiy4pPptsGnpV
	505Acmfftk3PWAv2uXjs6PV1qSa3gPcI2Cyan+ZlNdkauR3pagZkKtP5wxZwOC/PxTdw1R
	AwRfff08EjJaLC2wHdVeq2catRUkZTQ=
Date: Thu, 4 Jun 2026 14:45:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] alloc_tag: fix use-after-free in /proc/allocinfo after
 module unload
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525072117.112779-1-hao.ge@linux.dev>
 <CAJuCfpG7YCRYWHUn6JM+nFp0eeZz1RSxp620BQUJA8GKKay0uw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpG7YCRYWHUn6JM+nFp0eeZz1RSxp620BQUJA8GKKay0uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B0F04000A
X-Stat-Signature: swuout1ocrqjpcuqqo7ayzewnzshxzy3
X-HE-Tag: 1780555558-227339
X-HE-Meta: U2FsdGVkX18s1T1EAcKn7vTp9eg3ChyrFFB8qCCrIqpVjgPORwUYRoUY7AvPdrXgBMvc68w2FzMcqV3gykxL38d8bwstKFgvy280VPmcm9ZGPnqs3pIFvvnN42UJHioNaJ6nU5UXlj8nflF3unTuQAZ/kvvcBQOn00YJWxYBHB49UsaqiU2cwovUWi4DIQNx6cKWI6eCiOlGa3VnHoVfxr4VVLkSUVZZyTOsYWV4OtomDp8VYl28Nut1PJABRxzAd43nrUnaBjhniPdbt3+SZMr19bqYLfS6VhtAFg5CdIukyLM0V78gDRdpiwpSXdZcj66jjIKu4+PQ3lV3QS3TmNb0m1H4SuF72u6XrgfBuFkPuIPqKkhikMFJo7DYdRdow6MWyb4Jy1Y5RJ00VP7nlEdqHxeLYWZfmd3qa4AEAnvrtoYgINokpmlLse13002WBOQAZ6BQjQGRlrHiWYowXML+4/89Wggv9tAXdm0wcfUN3cG7IkGEw/J4eEsPpxoHcYICGH2+hhf0iSUJXKS+I8wG4MV1Y8KeeZ/4XTFLNc6nzLV+No2yQtu/PKU1CQWNXdzkDRxxuvy4ILIxqLjVCJLKc6aq2LbNLbyDwkBWjnqPBpAMuoz1DAAQTZHvx+2SobL0L+TchvYzpQr3yzcvogECTYVJJRJYU7bxiT7x9AOL0S05V5IyPF3poZmg31TaWagsR881kxVCbXnihRGK6Mg3+dBrtFHkaqvPTzCl2Z0SJBs/9Z/F+0YtL4EkmGFOCX+qR/BsIyNnv+ZB1a1PwbvykE0SA/L+u76/umfDzIxZtEbat6IjoT0MeofIcL1CaN2Gf2ihlhbgTr+MSqkJzu/aDP7/tXdOZlAjnMX9UW2gMHrEmeX09BGWVZ00Gfg0iCQJY3npHDxqxCqjUigZJ4mJXtrSD173IT0I/E2BbrEzZqEP3tFb0hZz1Xfhyz/TW0LPpLTmm63NTUas9KH
 dyaXW+Ud
 nN7Lm8QQ2/mkj18nx+jhkLK2MPf214Uomt4aZOtLeX/9IdibU9yNSsdo2iomvhPr6koK3fovxWJpBdqtHgWlsvNeQsMEobIyCUaaN98L6GjZvriInoOBLBW0VKsgMlRdjgOjTdhdQTkH84+2HjAbH2vWIMdXxbYUsKT24tVBMYX5ZlJxrsAhWbbEOAuRhDN8u1eLywlgR3WdFrA6Hx2uwkWncnPNfEavjGWb+3PgZuktrHmOituWeYTCHrkbdxjT++cfK7FASflePNI2NZXbEL0PBcC4Jj3jMRpWrftXSzs63L2OjwxLkidM3O0+rLYkUH9YB8GJbGTIdvveZaVJQjDgAPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/4 02:59, Suren Baghdasaryan wrote:
> On Mon, May 25, 2026 at 12:22 AM Hao Ge <hao.ge@linux.dev> wrote:
>> allocinfo_start() only reinitializes the codetag iterator at position 0.
>> For subsequent reads (position > 0), it reuses cached iterator state from
>> the previous batch.  allocinfo_stop() drops mod_lock between read batches,
>> which allows module unload to complete and free the module memory that the
>> cached iterator still references:
>>
>>    CPU0 (read)                        CPU1 (rmmod)
>>    ----                               ----
>>    allocinfo_start(pos=0)
>>      down_read(mod_lock)
>>      allocinfo_show()
>>      ...
>>    allocinfo_stop()
>>      up_read(mod_lock)
>>                                       codetag_unload_module()
>>                                         kfree(cmod)
>>                                         release_module_tags()
>>                                       ...
>>                                       free_mod_mem()
>>    allocinfo_start(pos=N)
>>      down_read(mod_lock)
>>      // reuses cached iter, skips re-init
>>    allocinfo_show()
>>      ct->filename   <-- UAF
>>
>> After free_mod_mem() frees the module's .rodata, allocinfo_show()
>> dereferences ct->filename, ct->function which point there.
>>
>> Fix by always reinitializing the iterator in allocinfo_start().
> Thanks for the fix!
> Yeah, unfortunately with the way seq_read_iter() is implemented, the
> op->next() fetches the next element and then seq_has_overflowed()
> might cause op->stop() without printing that element. So, in the
> op->start() that follows we can't just call codetag_next_ct(), which
> would handle the module unloading case (see
> https://elixir.bootlin.com/linux/v7.0.1/source/lib/codetag.c#L93).
>
>> Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>   lib/alloc_tag.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index ed1bdcf1f8ab..2b2d1580c714 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -51,16 +51,19 @@ struct allocinfo_private {
>>   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>>   {
>>          struct allocinfo_private *priv;
>> +       struct codetag *ct;
>>          loff_t node = *pos;
>>
>>          priv = (struct allocinfo_private *)m->private;
>>          codetag_lock_module_list(alloc_tag_cttype, true);
>> -       if (node == 0) {
>> +       if (node == 0)
>>                  priv->print_header = true;
>> -               priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
>> -               codetag_next_ct(&priv->iter);
>> -       }
>> -       return priv->iter.ct ? priv : NULL;
>> +
>> +       priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
>> +       while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
>> +               node--;
> I don't quite like this fix because if a module that we already passed
> gets unloaded too, then skipping "node" count of elements might skip
> some extra valid lines that we did not report yet. That's why
> codetag_next_ct() directly goes to the next module using
> idr_get_next_ul(). I would rather store the last codetag reported
> using allocinfo_show() (last_reported) and use
> codetag_next_ct(last_reported) in the allocinfo_start() to go to the
> next one (or possibly skip to the next module). Does that make sense?

Hi Suren

Thanks for the suggestion, I completely agree.

My patch has exactly the problem you described - reinitializing from 
scratch on every

start() also has an O(n) performance problem: each start(pos=N) needs to 
skip N

elements from the beginning, regardless of whether any module was unloaded.

One small difference from your suggestion: I save the iterator state in 
allocinfo_next() rather than allocinfo_show().

Since seq_read_iter() may roll back show()'s output on overflow

https://elixir.bootlin.com/linux/v7.1-rc6/source/fs/seq_file.c#L276

saving in show() could capture an element whose output was discarded, 
causing it to be skipped on the next start().

In the Fill loop, next() is not called again after a show() overflow 
since seq_read_iter() breaks out immediately.

Will send a v2 shortly.


Thanks

Best Regards

Hao

>> +
>> +       return ct ? priv : NULL;
>>   }
>>
>>   static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
>> --
>> 2.25.1
>>

