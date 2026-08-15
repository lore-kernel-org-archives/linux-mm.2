Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F9CC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DD96B036A; Sat, 15 Aug 2026 06:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7F96B036B; Sat, 15 Aug 2026 06:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE50F6B036D; Sat, 15 Aug 2026 06:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7724E6B036A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:45:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E68AF40334
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:45:57 +0000 (UTC)
X-FDA: 85103173554.16.C8F287B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFB94A0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:45:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HcmZKoJ2;
	spf=pass (imf25.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786790756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i8sSuNGd6mmLHE2UfzLIflavVjmbyhwZK+DDdZURwg=;
	b=Y3HXJc7++ndGO9lBZjcE4r0fBl/73X8IJZsR2DEPHNoS0SoCeXlExzxMjKoUyVoBhqAmUg
	afPpFOJCqwQMj4ovHB4qCBwuslX2vwsjP+0JEDZB7swyfOXz1ciTfNJqOnITE0xB5zi+G4
	gCCg0ubVFTb7jOVOkGscwi2Du2S6uoY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HcmZKoJ2;
	spf=pass (imf25.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786790756;
	b=ybhk6ICSzqtwXRIPeCUq2GeOH2zPs/zgQ09npqJp45jAC+k0mTG32ySk53Ct2Om4kJQ9Cw
	h3Hsscs9YmQAXABIjU+FFk8jMGNSH/uFXpo42mUn0CJ5H0RES1x9CaeB6nJxoEJLUXfeQR
	z45bo6KDXNhEw+5s8Z6OVJUWLoIXasY=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f703a9d05so1265630f8f.0
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786790754; x=1787395554; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+i8sSuNGd6mmLHE2UfzLIflavVjmbyhwZK+DDdZURwg=;
        b=HcmZKoJ2xZQWoS4S52SQUrXxrsIojum1PROgOd524krur5hLLTv8uF/QZwZirmgjMd
         Cwj4RnuMTHmvtX0eoroEJRUAUeLARmbqbD+YCmqpeSs5rViDamxYonI/Yboj+543dP8+
         TEyfAg9XsTdp6XHvIE1237yNcwd0yzXR6JED7aY+qVICA3njUhhjIT0ol5+vZHtOchdh
         JmwOaMnXF7oAleB408MeXCCia19ySiyqyiBaSxNma0JJZcgK0GSecLPwFHujl6AxCAmh
         hrNikmweXMdKMQPEYgvnEa+JD/Way8W0eSRPHPiB2gz6M+aKBQUEuhnr4pjDhlEI2OFY
         oBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786790754; x=1787395554;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+i8sSuNGd6mmLHE2UfzLIflavVjmbyhwZK+DDdZURwg=;
        b=p3OK+0mMl4WnmWOpiqxU1tHxzk0dOsZvSqR2Yvg+0zbRNRcWodYQ15pgmlqAkwQU5L
         TV/A1K743ei0U/IOjL1GjQOjhZWmCMCOY62sS7DGtmc49vAi6lvw+tkfzpTVwENnAP/I
         glUtbtL5cNs/Jo4+k7qnqx6m7Jd7XQ7aA++j8/sf9cGmertLsAbP5UWKuhRhi9aS98lZ
         8Pf1LCVpYcLBeTAZzf2tnNhrJon2N1v6jh2RDRVXMTz42pQGhgjMvBrd7ClU7wAxUSMc
         4iyM13ZubBkR5/8qxyHHEfgSz4fw2itbl29EI8OzvK8rBjRzxfALQEHq5KLhDK2Nc1Dx
         iTyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr1dF7umKUWFfC75PbjI0l2+wOls8JREs7jd4EXI8NL3JfYi+0sgfJeY66NZSqvtaYuktbPj9zb8g==@kvack.org
X-Gm-Message-State: AOJu0YyDzci04XckelSi/nhURcsgGpkmpfZq9rj0JDQkCMB0EdZ03xHF
	JgAOgPc2pmRHCTmCiTwOhoAf0UgEFU8rbJDuUS3fg6luhe03RkR9AknDT0O80LjFiNQ=
X-Gm-Gg: AR+sD104vPATD5VFCJ/yEaMvnfHPnxsC6A4OVN26YMAyN3QNQ1I4tqg2yXQcEp3Qvtu
	ad1s6ZC47opw8r+tx08xKLOwDrTDxGdKWQpyYs4ZfKM7a/J7RyBPywU/9fFrgKignN1OMhYTDaY
	jVnGdQqhTplqF8Dkl/RgmbyHwXWCqOnl046sLb7+yMnEWTm5nt/UOmd0J+WmPfn7QMHOBB7YlX7
	NJGPOasad0OqgpMYGkBPX1OuICnNNEBGH0Vw5eFSP9VetAEKeXu8EDNXgvZ4zWi8xCG3mDraY1C
	KiqPZlWO9q3bn4wlETtVlvLbdrmBFMFmXLbQnaUWxfTzsQH/b9y6Oc4AhXmjTCmeUcb6axTC4op
	KDsJLbT2BdhMPc8veWlsNaYe3ILxuDyM14Z6suM8qk0ubZTuIly4pyIKNMXuUKe2sx47YDnlo2j
	Ye2yG7AJ/SiH2Tscvn240DjLHNp9QRKu7kvTbizYeqjLyPzc95BubqosIRHJvRg4aDtz/x07yiM
	FCsCjnt8Zp6Ez0b9wqHWG+e
X-Received: by 2002:a05:6000:29c2:b0:481:44e5:160c with SMTP id ffacd0b85a97d-48160723ca6mr13951544f8f.2.1786790754104;
        Sat, 15 Aug 2026 03:45:54 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2ccc00sm15346737f8f.35.2026.08.15.03.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 03:45:53 -0700 (PDT)
Message-ID: <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
Date: Sat, 15 Aug 2026 12:45:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260812054105.102637-1-hao.ge@linux.dev>
 <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFB94A0003
X-Stat-Signature: h4d3wczd8k596icbsx8wkm8rcnyepcpi
X-Rspam-User: 
X-HE-Tag: 1786790755-793395
X-HE-Meta: U2FsdGVkX192sKBGPz8iTlyJXHWnewdZhRx7/iQHY5zBws1Lixx38EqQ3jh2f2Jnm2rdyh7rm4UOfALYLomTgT2uwmEU9eRa3CodzzlTWewyAb4shl0xSYtzjEPw3Q5O/SjfVP74jK0vN/TIMJmu6hAv11BGfaUvkjAUxq5wvDAN3bce8eZ0+ZBUG98eAkO2RKPG37dqTMfmY+4QZ6SUe9goQR8G+G0P7xzvBI60MdjDcWNwgo4BzEUkygIT4wBfKqbL7b/ysM5X31BixhEHCAKvxbWrfLooao8fXrnZs3clcmlEc7Esm4RBl0uuS40n6DRjxwOXI5gnOv58tMXx7X82b5nlPb0NLkoTIgcR5/8G779e0KRbBSYqVytKJznrzXy98squKe8xb6US43rXKLy/BXqDjhG0o3N64OMSkPCo/I/Xfiwcen/ZY+11oeqBJz2OJtdDTjtkc8QaWRN2gVZ9pwsi/QHRlaRLOVGqZQHgYmjUcVi/tsezkdLgU7XHTyCvQ3/lcFWK7MTjIjO+xQYM4RdWBBEtIneLCXizm1g59roGNJKv/W4ibukEa31UWLaZZhMf+dwxycM1w50iZTXniTGLFn7ga0liWPviWjEZoxcDMU2BpmDTOdlhG7MqP0wgfMcqBim9mNQygPgwgUAnJu9kmHssTlHcT18gzKSMyry8PY0Odge1tVVRKBLjcxNpF4F5+hzMlayCqNYdNFHlCWZ9tusRvggcuLgEEB7pEDmYRFPMMcrDGY3mFLvnZcKmvl1hyxz3DFC1fW/OWwNvIsq3jz1i9MarLTAFiGvEWkldY4ct02eGj/UZnpynaSguzsUbVw0pVQqU0S4y33Zeq/V41uskewCKojD8DnwXiqNiDTcOEBmnkqUNspk/7AA/WMiXSHCksCpvekTWzIo7NWythkE7+SciY9v2Z8m7uq4QNz9GReBKuwZEqD4CYFNfowgDLsW+m8EmQsk
 F9L4Gz7K
 br4ktRgvMDmQCmYTOGdVLQBNsVQfv6D/aMizjTa6mcOl6F8xxyuF94DOFFPYzwi4mujUoEic8VHFFSSEhFPZUxGmcVrDosNPGHXYB/u4ZMeSxgymUhWIgqHwkwDhtDlVfCwJpJ5iUCaxSE0LwXZ30pZ+w1FvoDOcEWiGeyt76kBzy52iWaxbDHAYalwsA+64wUcxlpAbx/YiYVe/Cc6+A5d/RRpEBD4q5lgmjpSY+sc5r+vDkFEuxdyElmP1TWTHH+r3JN0/ZTh63yahY2/Y5JTsGeVLrIyL2uv600XMtYxrFd/eX/ZckTBI4HHV6CzcNb8yD6WlPsKHchmRW37b2tG8bmLJI4R6g/a9t4wAiglJ+mc9YZB+avhHabocOqRX/rzDhp/ii6SitTLDjz0mrq92zqYimLTw9DhueQSdTyDqbFFQYbFKyYWIkGDo5zGbRaVN7O1xvZqvFi54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 7:41 AM, Hao Ge wrote:
> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
> 
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
> 
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
> 
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
> 
> This silently corrupts /proc/allocinfo: allocated pages get attributed
> to the wrong call sites, so the statistics it reports are wrong.
> 
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
> 
> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
> profiling, release the reservation, and return -EAGAIN so that
> layout_and_allocate() retries with profiling disabled: codetag sections
> are then placed as regular module data and the module loads without
> profiling rather than being rejected entirely.

When the described overflow occurs, why should codetag sections be
placed as regular module data? Will the codetag support use them in any
way, or do they simply waste space? Is the issue that alloc_hooks()
creates relocations pointing into .codetag.alloc_tags?

> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  kernel/module/main.c | 25 +++++++++++++++++++++++--
>  mm/alloc_tag.c       |  8 +++++---
>  2 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 46dd8d25a605..ed26f167be84 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2944,6 +2944,7 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>  {
>  	struct module *mod;
>  	int err;
> +	unsigned long frob_size[MOD_MEM_NUM_TYPES];

frob_size is used to store values of module_memory::size, which has type
`unsigned int`. The types should match.

>  
>  	/* Allow arches to frob section contents and sizes.  */
>  	err = module_frob_arch_sections(info->hdr, info->sechdrs,
> @@ -2966,18 +2967,38 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>  	 */
>  	module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
>  
> +	/*
> +	 * Save the sizes reserved by module_frob_arch_sections() so they can
> +	 * be restored if we retry below.
> +	 */
> +	for_each_mod_mem_type(type)
> +		frob_size[type] = info->mod->mem[type].size;
> +
>  	/*
>  	 * Determine total sizes, and put offsets in sh_entsize.  For now
>  	 * this is done generically; there doesn't appear to be any
>  	 * special cases for the architectures.
>  	 */
> +retry:
>  	layout_sections(info->mod, info);
>  	layout_symtab(info->mod, info);
>  
>  	/* Allocate and move to the final place */
>  	err = move_module(info->mod, info);
> -	if (err)
> -		return ERR_PTR(err);
> +	if (err) {
> +		if (err != -EAGAIN)
> +			return ERR_PTR(err);

The move_module() logic is non-trivial. -EAGAIN could be returned by
other code, now or in the future.

> +		/*
> +		 * -EAGAIN means profiling was disabled but the module
> +		 * can still load without it. Reset state and retry.
> +		 */
> +		rewrite_section_headers(info, flags);
> +		for_each_mod_mem_type(type)
> +			info->mod->mem[type].size = frob_size[type];
> +		info->sechdrs[info->index.sym].sh_flags &= ~(unsigned long)SHF_ALLOC;
> +		info->sechdrs[info->index.str].sh_flags &= ~(unsigned long)SHF_ALLOC;

Why is it necessary to reset SHF_ALLOC for .symtab and .strtab here?

> +		goto retry;
> +	}
>  
>  	/* Module has been copied to its final place now: return it. */
>  	mod = (void *)info->sechdrs[info->index.mod].sh_addr;

I'm not sure this is the best approach. It's complex logic for what
appears to be an edge case related to a debugging facility. It will have
the usual problem of error paths not getting enough testing and breaking
subtly over time.

An alternative could be to reset SHF_ALLOC on the codetag section to
remove it from further processing and have relocations that point to
this section resolve to something else. It seems that alloc_hooks_tag()
could tolerate this, since it only needs to reference the associated
alloc_tag when mem_alloc_profiling_enabled() is true and that gets
disabled by reserve_module_tags() on the overflow.

It is also not an ideal approach, but I feel it could be less intrusive
to the module loader. I can put together a prototype if needed.

-- 
Thanks,
Petr

