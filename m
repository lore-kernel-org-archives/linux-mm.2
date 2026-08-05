Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0440CC2A09B
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C946B007B; Tue,  4 Aug 2026 22:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED266B0088; Tue,  4 Aug 2026 22:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02C46B008A; Tue,  4 Aug 2026 22:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8370F6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:51:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01C3CA187E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:51:26 +0000 (UTC)
X-FDA: 85065689814.26.92D5301
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 05DD2180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:51:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g7uaV1pk;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785898285;
	b=PNW/uuiNxP26zowMNB81j//NNm96DDzE6KFG4ac2tCNS0iiPUgeUPAtITU9WZbcTYUNFqt
	uK6qoCr3CswRB/t/gn8IfNFa9D49/UIkYe5dGRMb6eYh0zu+C2ZtW2S3NbWKOyvso42joi
	kbqTFRRNH94rsrefQffZYua2YEIgArU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g7uaV1pk;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785898285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw6b4Ud9QmLN26rSrpMEOzWnoOiUv/ZPRwVZ5pminvo=;
	b=8SGdgGSxRqhkn09JPgFWZZUzOuY4xe5VCYaaGLnH5gYkPd1U92D/6YqjaM0QZWaIYGAOmB
	L+eukQ3LAL1j5l5BaxQhJZ/zXWZlKsdNiy118n9zXOhEc5GJVGm4ljFEPfRXnlw8RkSAa/
	d0rm2lF/TuTAucLbE8Ehkju9w3leXNw=
Message-ID: <b2684958-5c39-4a9f-ab83-2e665406c0c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785898282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mw6b4Ud9QmLN26rSrpMEOzWnoOiUv/ZPRwVZ5pminvo=;
	b=g7uaV1pkzDfMhgrhziX3dxUuLUXbulybuyscS1M2Ap4htsEufpY/v7TbT7oYrep113eUS8
	DWBlHCqiZxBDe7TBxzyPYF8qz1U/u/LuNBkxxihC61zSwN9khhyn6QcM1GIKBlBpMDOf5c
	BPT1VqXjzwybh2e8WMqHWNa+QTLa2sg=
Date: Wed, 5 Aug 2026 10:51:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
References: <20260804122038.190270-1-hao.ge@linux.dev>
 <CAJuCfpGit7zcNPGAB9D2A5+718NY-qdksxt7gUaN_eRcB_5+Ug@mail.gmail.com>
 <bd95f8c6-33e2-4fda-bd4b-ebc37ee7c0fb@linux.dev>
Content-Language: en-US
In-Reply-To: <bd95f8c6-33e2-4fda-bd4b-ebc37ee7c0fb@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 05DD2180008
X-Stat-Signature: wa4wtccqgds3gxoohquzburu1stbnj1r
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785898284-533970
X-HE-Meta: U2FsdGVkX19RI/CgWb6dJ3O1AuGpA63C+h2wlXfKw9Jy/agz1pYxCwAvHnln9c7Bb2exwhFdtLXo91KNGcajyMFYAWRWh76GGoVVz03FF10YkGrlgeJy5u7PTLhiMpC1nprZUOT57LVtxRy+FrXKqLv0M7QFuBqWLdEj0Ho+4O3ApC+hpvHkr8Cyt+D9Pn1Ytp8DlTehpTNznHKQd84QZj+qBBYY4qSa5n2DGSk4zBH10FwDRqfulCTdBw97CKaYg83YSHtQ0O4SPwoI9DYbMoS8w5yhnAjoRMoHBeT/PSwex2JYF3TXoZBR35dppvLvj6xlvtZwzeekHHVuxRISxeoyy2LgjRZNYiAjLRj7m3uSIAgLOWY13EeBrigVDg+R9AGHK5jY8+w+mQsfNlDW74Sj0uqcQBTFBIY2W2RY/9MW7haCyGM94taW9ZiaJnk0PkTKc8l5+Wo/uR0q5hhuN7i61ClBpg4K5QcWNBIPkJwJwn3CJRPgSYjht1Z9fNs5b8EQ3Pa2+zp0KjqRnNOLbfRelKo1+q8zYt5bvN9E/xSsYpAF5zd5hqpmB9IUgcebagayYQx69CdfsJnM+yN62FO8ByS9ByBhdCFM6NoW5kIVDpQ573baqWD9HnK0o0rdIO25wq/jTxtdqWjPIBQA50kbluIMpsBnGJkVfRDOLICiCF5KMnh2t6Ny+VOckEnCUOWEv8CBzslVMJFH9toiXiXcjc+YLsbRHf0Uqzu2HYnOAzyyHxkStBIuZ/S87UDk0maweNe47YwhYCJw/vOIpzoDHBv+rtKzsMp4xY/LbxEdTgIxK3TRxJ7TSLNw/PWp5bj+BxRsjYhDdcBvtVvOjd+2XUQ2eWUv/YZF+8ZDyvO9Ok+dU42CUp/1gZaEjUvPjwjYWCi2LJ7DzUnu+FJq5ZJDHfHXDgUs4uaHoh4IJJ5C5h5Fu3s91rbkN+APQZKBXVNVGWoL3OuAfpDvQJX
 1tF+nhlg
 sDhs47lVYioaeCfxeNYFfHetbQhKw7sC6+gnbgZUbuKvxMpBPQVO3vkJCfy7P0y+nwqiDS4ajLiwhWC4kwheFF8suqDw/3EDCy13TbJxbZzsjPawnc4YxS1J4Tt22E+M3CjaDPErarj9MIhHV04D4bt/qIQUC5UmBzh0EOTXDgF6SpJ9IS6HMQIge8m+134cw7CGwdu8JZinM6X7pez8euazA7JcILwqRx1Ao9V+d9I5MEitbrTSuDrGH7U1h0cnG+zC3BwCG7XfOgsytLWzFmD7Q1aFvkGf6PypZ6rXVZZcWIWud1ONxgFR7xqXN8RZUXjbkNPIRRvE4W6Ibq9O/bh3zmdQqTcUS4a5psvt6nieeBb/uegCTluyU4xQ01pvAbwCZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/8/5 10:26, Hao Ge wrote:
> Hi Suren
>
>
> Thanks a lot for your review.
>
>
> On 2026/8/5 04:08, Suren Baghdasaryan wrote:
>> On Tue, Aug 4, 2026 at 5:21 AM Hao Ge <hao.ge@linux.dev> wrote:
>>> In reserve_module_tags(), the tag overflow check is gated on
>>> mem_alloc_profiling_enabled():
>>>
>>>      if (mem_alloc_profiling_enabled() && !tags_addressable())
>>>
>>> If profiling is toggled off at runtime and a module is loaded whose
>>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>>> skipped. vm_module_tags_populate() still maps memory for the tags and
>>> the module loads successfully, but the total tag count now exceeds what
>>> NR_UNUSED_PAGEFLAG_BITS can address.
>>>
>>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>>> as its position in the alloc_tag array. update_page_tag_ref() masks
>>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>>> tags.
>>>
>>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>>> independent. Once compressed mode is established at boot, it stays
>>> active regardless of runtime toggles of mem_profiling.
>>>
>>> Remove the mem_alloc_profiling_enabled() guard. Also return an error
>>> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
>>> the mapped pages would never be reused - shutdown_mem_profiling() sets
>>> mem_profiling_support to false, so no future module load enters the
>>> codetag path.
>>>
>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag 
>>> compression")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> Thanks for the fix, Hao!
>>
>>> ---
>>> Changes in v2:
>>> - Return error after shutdown_mem_profiling() to skip unnecessary
>>>    vm_module_tags_populate()
>>>    v1 link: 
>>> https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
>>> ---
>>>   mm/alloc_tag.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>> index 52aece27b00e..d8c36430f1c0 100644
>>> --- a/mm/alloc_tag.c
>>> +++ b/mm/alloc_tag.c
>>> @@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module 
>>> *mod, unsigned long size,
>>>                  int grow_res;
>>>
>>>                  module_tags.size = offset + size;
>>> -               if (mem_alloc_profiling_enabled() && 
>>> !tags_addressable()) {
>> Makes sense but how about replacing mem_alloc_profiling_enabled() with
>> mem_profiling_support? Otherwise this warning will be issued multiple
>> times if we are loading multiple modules.
>
>
> That's a really good point, this duplicate warning issue will indeed 
> happen.
>
> When I thought over your point, I realized using mem_profiling_support 
> creates a small race window.
>
>
> Thread A（insmod A）                      Thread B (insmod B)
>
> --------- ---------
>
> needs_section_mem() -> true
>
>     needs_section_mem() -> true
>
>     (profiling still supported)
>
> reserve_module_tags()
>
>     overflow -> shutdown
>
>     mem_profiling_support=false
>
>     return -ENOSPC
>
>     reserve_module_tags()
>
>         mem_profiling_support==false
>
>         -> overflow check skipped
>
>         -> vm_module_tags_populate()
>
>             maps unused tag pages


Sorry, my mail client messed up the race diagram, resend it.

Thread A (insmod A)                   Thread B (insmod B)
---------------------                 ---------------------
needs_section_mem() -> true
                                       needs_section_mem() -> true
                                       (profiling still supported)
reserve_module_tags()
   overflow -> shutdown_mem_profiling()
   mem_profiling_support = false
   return -ENOMEM
                                       reserve_module_tags()
                                         mem_profiling_support == false
                                         -> overflow check skipped
                                         -> vm_module_tags_populate()
                                            maps unused tag pages

>
> So I'd rather go with pr_warn_once here.
>
>
>>> +               if (!tags_addressable()) {
>>>                          shutdown_mem_profiling(true);
>>>                          pr_warn("With module %s there are too many 
>>> tags to fit in %d page flag bits. Memory allocation profiling is 
>>> disabled!\n",
>>>                                  mod->name, NR_UNUSED_PAGEFLAG_BITS);
>>> +                       return ERR_PTR(-ENOSPC);
>> This ENOSPC error will be propagated all the way up to the init_module
>> syscall and it's not among the error codes currently expected (see:
>> https://man7.org/linux/man-pages/man2/init_module.2.html). I suggest
>> returning ENOMEM instead.
>
>
> Agree, will change
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>>>                  }
>>>
>>>                  grow_res = vm_module_tags_populate();
>>> -- 
>>> 2.25.1
>>>

