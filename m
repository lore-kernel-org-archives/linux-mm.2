Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7439C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9816B0099; Thu,  6 Aug 2026 04:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81CC6B009D; Thu,  6 Aug 2026 04:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDBA6B00A1; Thu,  6 Aug 2026 04:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACCE06B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:36:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CC4B1C12CD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:36:26 +0000 (UTC)
X-FDA: 85070187972.02.D7B9D90
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id A12DF18000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:36:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VW9Y4Eh3;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqP6xIom5z/JgiZxChLOxSoV7HfcbtYKbXpcpVaVwyc=;
	b=hVvd/WoF1OOWZLDCy8SSrdfRZ3i10teyq9R2o/29E0yA0KoMpS/FxMM/iXamVuwmj8jefk
	ku1ZaN6EUu9Qz+0dCa3hvyAcjL4dfJZkIDuYD9fxuN2AL9GyAbbomj7u0ZAMe0gSA5kmeT
	sFjQrH3gziXlwEN4/R2LSBBSrPhKivY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005384;
	b=kcfCns9KD+Y5KN8PWVfrPKKFh3UuZ+4mExMf6JJE9+qbJ6J8tlad2BkreSyfXWFtuSP9HF
	qz45ft8vaBNxm06f155Q8SrPOznhoEvQx2eRh9Hm3GJmjBrHAW3Z5qclVw8wWvVEUsINsC
	gT5wlCT0RBuW1ejN+1NwLnL9v0vy4FM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VW9Y4Eh3;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e96d8a13-8f9a-49f4-ae4c-a14c6de5ae66@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786005378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MqP6xIom5z/JgiZxChLOxSoV7HfcbtYKbXpcpVaVwyc=;
	b=VW9Y4Eh30Usq0AUvRj8F7W5tWArsdtGcXuE4NlQ/gwarc4Ss1n/U9lWUWMW/mV6adBM/mA
	xZId21sQz4oBvADexAu6EenYmDG1syopmi+C737znb0+epHUVAaAbW9ffH9HqnUn8sReju
	WOFWQ9kNfPunFLYqXgIh7C2Ea60N6OM=
Date: Thu, 6 Aug 2026 16:35:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Abhishek Bapat <abhishekbapat@google.com>, stable@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260805090633.141001-1-hao.ge@linux.dev>
 <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
 <CAJuCfpG_XX-Hwy=TCrJ+g6yiMxGXLB=LvnPN_WLP3WQktNZMbA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpG_XX-Hwy=TCrJ+g6yiMxGXLB=LvnPN_WLP3WQktNZMbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A12DF18000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f5zqqimucrj7gqj61k5n3dbfz4udp4if
X-HE-Tag: 1786005382-569435
X-HE-Meta: U2FsdGVkX18srMS4cvADBQwPoWrMea5KFIEunYBHDe8EhfsNeH2q4asE7cKViiwYvbTMg6n2iVus47+5SiwdWtkwzATSYZAiWdRjgz2Rofqvg4h4k7+zHS0/qW//qfl7aVDUvpoPY3UveHztnPCxkZF2hkFk7pAqgpONix/XRYwf6x9XxxRW9+OvET9NrQZvbOzFH/A/CvBzuzhMpxPzghgCiR/mRvKE7Om9vS0d1bUH6xS97pbyOk+MaD5k1Uqn0LHHZwqVFghlzdUFfPIu1kPtc3ZItNOsopvGNO/0CYhkwp7FlpPK5k08K7ZdaCTPcSTXs5P/nStQT6gWigZCXtlp6xXDEyzkx47XwytnOMA+SavaNjqqPQrIqp3FCHchf6tRELWB4oKT7YekFLD7AoLrfk9bCT7FIhovCh/L07FtZK3fSvyIU25OvkGFLEi97B94FSquxWvWyekcXsCOwEWmaIOy0R64D+M/HNxGGvFuTzXxEAjRgJ+GxJeU3qFHq03QuNe3Z2sRI5/jT+t4O865zcx2DAXxDAwW3SVAOKS/mj7L4Jg7iRbs9mvZ4ZG/vSw/Mvd2urr3EZSWeXz2dmXr6yTe2jA76tyrw7HxP3LdBtCiZd3NPqKx9SDv9RbztWxKKdWCFNrZDYSUU27k9D/j+Q/kOQ1v8uh04WsTp+y31iksrGCmFahQPGgKfxy6R1S6OtliO4Ypu6dnlJfmEWjhyzBxWo/RNf9Jx9Oz5xhMI2aXHX8T/fjez2tF2iN+riUeDHUCugvdD0dMXh0cAxLXBb/TflwNCXbFQDzIMmWYxtig1AUXlbjdC2jmrUIsVYJAICYo6TnsLGpL3Avg3RlB4QjAylAvknehDmFPjE19rZu19usfLtwwr5uNXNuQ2CITvPC05bY4TOzlvSrbbDMB1wS4Pk38fbBl2krBSZtoBdVHOwIKJ8T6ziMvf9jPuMgrswMF67RrySMcv9D
 hsy/D2ZI
 eWFti9vw2d/2T/fpwkVKMypMNcpjWTMMkQtPQJ6LbZWzwCOLqCQ8LnAJgmGDojX2lv6SI0cAAejR/JRYSWR0glEvq1uR/GIA/6twkNwcUOCjNNKZcLDF4Vf2lFL+rQ190G+5M+F9MEJDOeU6dpPf+zMQGOoxhxYHLXiZ0Fhioh+S4lt8pVp1X+c9M/DYUQrta6H/iSnqPOdFN//oYqVxjnJrTuSU7/HoW9TVFS5ZhpAKiFq6mepT9haNp2m6xFc9pUaDlO0xkixXjj1ezWktFQ2P1VqQtbhjWKQI5V3GVEbmJrXF6h/zPZg5NvzRA1MC24+73hILdibcwEQaZsXJ1pqKKMLg6I6xpBd/OBfaSqhSKhByOMRd/R+Nt/FPj3O8zhZbR3T3IW2qmjSCwOsY1SpKxgdkxM2nmuXXTOii0eExLUlyyHgj9hyXdeuuXNoP5v4Ff8sTl2iY/e8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/8/6 01:47, Suren Baghdasaryan wrote:
> On Wed, Aug 5, 2026 at 9:55 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Wed,  5 Aug 2026 17:06:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>
>>> In reserve_module_tags(), the tag overflow check is gated on
>>> mem_alloc_profiling_enabled():
>>>
>>>      if (mem_alloc_profiling_enabled() && !tags_addressable())
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
>>> This silently corrupts /proc/allocinfo: allocated pages get attributed
>>> to the wrong call sites, so the statistics it reports are wrong.
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
>>
>> Thanks.
>>
>> AI review points at a cpuple of possible things, one pre-existing:
>>          https://sashiko.dev/#/patchset/20260805090633.141001-1-hao.ge@linux.dev
> 
> Yes, pre-existing issue can be handled separately, it's not directly
> related to this change.
> 
>>
>> "Does this unintentionally result in a denial of service for module
>> loading, preventing critical drivers from loading when they otherwise
>> could have just disabled profiling and gracefully continued?" sounds
>> pretty obscure and I doubt if we care?
> 
> Hmm, I think Hao considered that in his previous version

Yes, I did look into this.

but now I'm
> thinking we might be able to handle this more gracefully and not fail
> the module loading. When profiling is disabled
> codetag_needs_module_section() returns false here:
> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822,
> so if we had to disable profiling, we could return NULL instead of
> ENOMEM and change the condition here:
> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2825
> to act as if codetag_needs_module_section() was false from the
> beginning. IOW code at
> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822
> becomes:
> 
> if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
>      (dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>        arch_mod_section_prepend(mod, i), shdr->sh_addralign)) != NULL) {
> ...

The primary blocker is __layout_sections.

https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L1730

This is because __layout_sections controls whether we reserve space for 
the codetag section inside EXECMEM_MODULE_DATA, the same way we handle 
regular sections.

When codetag_needs_module_section() returns true during layout, 
module_get_offset_and_type() is skipped, so sh_entsize only gets the 
type bits with offset = 0 - no space is reserved.

If we bail out with NULL when compressed tags overflow and add a dest != 
NULL check here, we'll end up hitting the later else block.

if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
     (dest = codetag_alloc_module_section(mod, sname, shdr->sh_size, 
arch_mod_section_prepend(mod, i), shdr->sh_addralign)) != NULL) {
	......
} else {
	enum mod_mem_type type = shdr->sh_entsize  >> SH_ENTSIZE_TYPE_SHIFT;
	unsigned long offset = shdr->sh_entsize  & SH_ENTSIZE_OFFSET_MASK;
	dest = mod->mem[type].base + offset;
}

That'll cause the following memcpy to clobber the leading data.

If we really need to fix this, we can use dest's return value, with a 
check like:
if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
	dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
		arch_mod_section_prepend(mod, i), shdr->sh_addralign);
	if ( dest == sentinel_val )
		continue;

But that would also mean extra work on our end - for instance, we’d need 
to stop the per-cpu allocations inside codetag_load_module.

https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L3571

Could there be a simpler solution for this?

Thanks
Best Regards

Hao

> 
> I think this would result in a better handling of this situation: if
> we can't fit the tags anymore, we issue a warning, disable profiling
> but continue loading the module. Hao, WDYT?







