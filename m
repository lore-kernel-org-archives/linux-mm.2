Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE4EC2A09B
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1796B0088; Tue,  4 Aug 2026 22:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181F26B008A; Tue,  4 Aug 2026 22:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEBC6B0092; Tue,  4 Aug 2026 22:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC41D6B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:26:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EE8EA1439
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:26:48 +0000 (UTC)
X-FDA: 85065627696.20.C09F2CC
Received: from out-163.mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	by imf18.hostedemail.com (Postfix) with ESMTP id 92FBC1C0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:26:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dApTgvPb;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785896806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxhPyeCLidu0a6r7PQAlsqHOIelpm7O7iJDL5zwrXtA=;
	b=pPo5U64ZvnMf2loAZ+CYI+Kbfy/xbKYHMScSFyg4egfpK/LRYUczdKCg/ii73/yQv/H0ce
	7+g2z7a9yCpgCeMBxsG8Wv6V9oqsvFE3Nyi+m11sRuaFuYe7pe10YSzKt7/mgB/ZAH6XGh
	x2GnP6Updtzr5eDT3SPv1spFzbnDMKY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dApTgvPb;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785896806;
	b=cmB/rgGgmTaSlTj5FcVJ7GOYpTQKJ+fQ0qSY9q1zfHWv0Qj66+L86cyH5dpTSxgVJCy3Ay
	xQtcKdj+nHj9ImA/XFeX0C2kM2kwiOA84hfspOapucraBTQ30Xq/lNpYyVsYixnlzeqot+
	jyEV8k160vQaFzIwprECgjGkiX08oKY=
Message-ID: <bd95f8c6-33e2-4fda-bd4b-ebc37ee7c0fb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785896801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qxhPyeCLidu0a6r7PQAlsqHOIelpm7O7iJDL5zwrXtA=;
	b=dApTgvPbD40Jr9rJ8xg6bqSqA7DUkvdQNhYWYk+bmQWF+T+z3t3L3vb9NdAYXNWg+jNXM9
	QNGrayoiJN2wymZ6QXooX+GxxcZe9eXFQpLIL+9T5n39E4XFV14xlTXYsAUlw1G7JGJwxr
	Sl9E4w1frMLhSsDezKkitaXhkzt6uWg=
Date: Wed, 5 Aug 2026 10:26:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
References: <20260804122038.190270-1-hao.ge@linux.dev>
 <CAJuCfpGit7zcNPGAB9D2A5+718NY-qdksxt7gUaN_eRcB_5+Ug@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGit7zcNPGAB9D2A5+718NY-qdksxt7gUaN_eRcB_5+Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jd3gz7n7f7ro8b64355s8x6ppnsag6oy
X-Rspamd-Queue-Id: 92FBC1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785896803-665264
X-HE-Meta: U2FsdGVkX1+ahrzmDCXmHsMYkoNSpaTPSxfXd36q3rywFUMB/YQQGJk/LOCmrveVKxcYM2pziJkMVknWDK56zoVzvlONE87HxQVmBDqWGkBP0j0Ern4LgcCuoI2ALvCwD2lqYDxoyDz/BU4grLOCOyPUH6z8DbQc5VGI4hpyRq08AIaLBRLl7jOcvEu5PEHH0EhMTqXktykPBUo8IxtC+rvoYV/cHkCTXbpRcI1u0IYefNlbd+4/ThQ3QK3McaqmE812SHCRZXIKs5MoaTEulNOiGbGBpzh6UdMjroWILXzT65rlrXIMbrlJQoI2ckvtIEZ7q+T4RK/5H6dmTELQTUkSHovu0KpVC0qMUayWM9rYwkPJt0Oov/AS3JoUgsYbmDfdGngVSDIgtauAIKeAyE/TewcVdbdFnX2rUCszud9iNWSOGwqQSJ6EVP6jFDop37wpmaTuZbsLzKfCKS5ic29SwbT1E0ltlPGmqf0Lbwpwr+nbfCrThykyu28lRODzKj6Xd541Jl1Wspm4bEsTLvbkLFB3tx9QzgADT5GblBcAmH2exSffWwcA4yUefLNoV8YvJXr9isw7VWZofNtIEMh/sOTWKup/ljI1ti0UzGL5UrheIPlNxffweF2X4EsG5V0P7Bw8YQDd9mETHB5yT+9Mz+W37dWG9hSRg7x2wtjpIIhYxD/2Z7O4yR29UJ6DrLCZP9m7xduj+qlBMXYfX6cAkgOt+cW1uMsgZuVmrnyRnhxey65R1RMFNXZfsOLnImvNVCPyvltTz3GqwxYOdlhtsaum5MP+37T5b9HGZ39QgpjpAJ8t38hVVzg33kaxLMVcX9SwxzxVMnhh42fdW4k2RXlytdAApDY7MRvo0SIyUgqPFKBd1r5zlZwNqJimew195ghSmeZsYeVBzM69sCiLncIuJghgpC7RqhCpr0qHWBykKKiEGqvcnIiV+B9wlF9w+iq7othN0p86wfb
 UzT/4ASf
 +rsqQV3GuKTb0iIRpwemMq+BB4S8ejJorDCx2pTuZCd6/a88MtNjCTjMNFgpra4xvJC0vUC8V8E+cyXye+Pt520d9AAPwODlgmhugg0qLW9abscXPrQjMe9uvuuiCmYMLMFzMaXMT3kEVwiOv09FN7fbI2dnbqnXqECiTcwLZ0PvegMc4dTQL6Xh51BI6sag8BDp4R7H6ZaFw7B6wEk93SDIZzibsguLU1J81LybluvxijCOXPTcYmerwGtAjDxCMlbI9a9mSTIBC2QqfGuhD9d/ynSu30GWktWaYZnlYXTJs1FMLRZwSHnO+mE1l/ZBBhM2rdfgRU8UOAEm3+Bx/qcQBqj7J1/kzLDQeNlLA/V3ceTv34N4oCSjppsZGPWjQgGuD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


Thanks a lot for your review.


On 2026/8/5 04:08, Suren Baghdasaryan wrote:
> On Tue, Aug 4, 2026 at 5:21 AM Hao Ge <hao.ge@linux.dev> wrote:
>> In reserve_module_tags(), the tag overflow check is gated on
>> mem_alloc_profiling_enabled():
>>
>>      if (mem_alloc_profiling_enabled() && !tags_addressable())
>>
>> If profiling is toggled off at runtime and a module is loaded whose
>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>> skipped. vm_module_tags_populate() still maps memory for the tags and
>> the module loads successfully, but the total tag count now exceeds what
>> NR_UNUSED_PAGEFLAG_BITS can address.
>>
>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>> as its position in the alloc_tag array. update_page_tag_ref() masks
>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>> tags.
>>
>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>> independent. Once compressed mode is established at boot, it stays
>> active regardless of runtime toggles of mem_profiling.
>>
>> Remove the mem_alloc_profiling_enabled() guard. Also return an error
>> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
>> the mapped pages would never be reused - shutdown_mem_profiling() sets
>> mem_profiling_support to false, so no future module load enters the
>> codetag path.
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> Thanks for the fix, Hao!
>
>> ---
>> Changes in v2:
>> - Return error after shutdown_mem_profiling() to skip unnecessary
>>    vm_module_tags_populate()
>>    v1 link: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
>> ---
>>   mm/alloc_tag.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 52aece27b00e..d8c36430f1c0 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>                  int grow_res;
>>
>>                  module_tags.size = offset + size;
>> -               if (mem_alloc_profiling_enabled() && !tags_addressable()) {
> Makes sense but how about replacing mem_alloc_profiling_enabled() with
> mem_profiling_support? Otherwise this warning will be issued multiple
> times if we are loading multiple modules.


That's a really good point, this duplicate warning issue will indeed happen.

When I thought over your point, I realized using mem_profiling_support 
creates a small race window.


Thread A（insmod A）                      Thread B (insmod B)

--------- ---------

needs_section_mem() -> true

     needs_section_mem() -> true

     (profiling still supported)

reserve_module_tags()

     overflow -> shutdown

     mem_profiling_support=false

     return -ENOSPC

     reserve_module_tags()

         mem_profiling_support==false

         -> overflow check skipped

         -> vm_module_tags_populate()

             maps unused tag pages

So I'd rather go with pr_warn_once here.


>> +               if (!tags_addressable()) {
>>                          shutdown_mem_profiling(true);
>>                          pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>>                                  mod->name, NR_UNUSED_PAGEFLAG_BITS);
>> +                       return ERR_PTR(-ENOSPC);
> This ENOSPC error will be propagated all the way up to the init_module
> syscall and it's not among the error codes currently expected (see:
> https://man7.org/linux/man-pages/man2/init_module.2.html). I suggest
> returning ENOMEM instead.


Agree, will change


Thanks

Best Regards

Hao

>>                  }
>>
>>                  grow_res = vm_module_tags_populate();
>> --
>> 2.25.1
>>

