Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB87C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB016B037C; Sun, 16 Aug 2026 22:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274366B08D8; Sun, 16 Aug 2026 22:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BF16B08D9; Sun, 16 Aug 2026 22:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE1076B037C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:24:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DD9A1C19A0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:24:39 +0000 (UTC)
X-FDA: 85109167878.22.7F7BEF3
Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id E04091C0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:24:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOmAen5C;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786933477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcTUToU/dfT863E5xaL1RU99l1QmzFxDwDM8f4TNFSM=;
	b=MpTpTAABGzjBFq3pLrMLp8CRNzRYJSdYC6462M8UcEKS8VD9gR1Xn9B1QNhstJ6qWZ6Tj6
	fp1ahM+ux4d/98jk1s4FtSYcmdxoDmthPhAZjCc92U5hdsjcmM+LVJqgLni/64yXgcfi4M
	h0DXgnBwxOyvwNDIgrvjAbrXTSHIGbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786933477;
	b=4jPLuUzMCK30Iqj81ajAUU41U6AUaUwQIxr8t4tCwfMGueVqP9NHj+ShBJmgU0Y9Rx79LN
	Oi6tHFfFCxdE03SAY3LcGtrdtFdhq/tj0p7qaMoMV/JtglZqYOlRejxc5lPogN5Ufrni5W
	rZgMKs2fC8ylsOG3qRo1GheiX8tIH+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOmAen5C;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+n2cYNTTF7OlLHShJxkMX6+SCU1R/80rB+hgg30keQ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786933475; v=1; x=1787538275;
 b=nOmAen5C58d50IQ4M/X7YSE5Kc7RvfUnNMB1aZ1fBzhWKq0rWKVfViIN02mMIAUzgY/MyExO
 rg4KsJPhpFXMC9zyG1nw34xHKThQBTV2mxEAudhQgFbkyxsl3UyEew+5F/H4dgNPGxqDjWhAt+i
 mty7ihe7icH1OnWKeImxPsu8=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.42.12.33] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 5ca538b453ddbf4b;
	Mon, 17 Aug 2026 02:24:25 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <c67716f6-a478-492a-b086-39f2c7da132d@linux.dev>
Date: Mon, 17 Aug 2026 10:24:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>, Petr Pavlu <petr.pavlu@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260812054105.102637-1-hao.ge@linux.dev>
 <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
 <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
 <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1qhiuakirhqnu7dqnseeaky4o5nk7syt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E04091C0002
X-HE-Tag: 1786933476-357339
X-HE-Meta: U2FsdGVkX18b52no3gUwf/PuDeeZ1bhuB6XRZa1Eannue5bW2gYOWUerMPTwiURSaMcMKZANCa1jQhJ2fI6pwnO0qybM3HE/vkekXVSgS15wDy+/E8CQvDnd4TSB90Bb3G1ZMfhg14if0enD5fa9a2g7LldMTloyy3U+OR1zgfivHDUNNxRvcIwM/LF5f1/s7+EKL6nWxuN+J7RZRFX+awYVL3KTtYWvzHFdGFXOyvzn7G/Yz04RMNHgf9e9dBuLrUyUkVWCTuo0o60rBNK5hC4p3Zi7XFE3FdGLEDdNenkeYYuuK3yMKb1GBi6w2n8fiyGYi/PdJbeaNskD5301M33KJg1YSIdpMAj6mznno5MVl/UtWZJUJQrDkgTGTsPrNzcqOAxKwkj+eseCAQiJaTJVxQ9lBpoBlzA+HgDRHO9cuACOHfGu9xmDJfbEy02zu1t9wxDZOFqY0PNsR/CzdAXiJUWO1nE4nbgXUvxcR3ztGDjX8vtEsUbDwcBpnBrV2Gb3ycnSGI+vBDTsQWA4+6W6TtX6llNPOtyf/mFhunhmqrx7zpHU7k9Qd9IJvUCZZc6ImG8i5/mk+kBsl9hGwvViTGaCPfA0YS6N53Xj0eS4SFf6V0a3hUauW2m8KN0WFSmAv4UCadtBldAcL7zPQw3cX4J+nWh88yXyJGJL8Z3geJXnIXFjCO/0EBMta52psvdpYGyRP6quwQjYD03WadyfoqdewdaryxixcqcTFnro9fYJBlFu1Q2BfBbwDGf4/k5nx5u5+0yfH+GGvtT/Dax+LimqUgPH7w7rrNGO0K4VgbIcPIpDGR6izbo89OriE2tqHJzTCtpdiI3QXNbss6Vd8HlyOKoItBG0yiYdw3ROkYjqFzXxr2LlNcVIeiO+aCfWnEvK/FI4b1DLklzwlaWQBwyBgiCk+gxaRqxW9kgCt1Cuf5ESIPFRJeb77p1MBqS3Mz65BXxLTw+gTGt
 1ljyGDad
 URAj1yh9VtHHtt8wWhrpg/AiRx5vqMAzVFw/0BeL5ktrl2kp3kDURYqa2O+37CL7m1GZnriLq0mA8bWmnSGD+dP8fe4Srs6oHaPGn9uY4UQ/69AWg3x4cqSGwTQCgA1r4Sg8Ly31q2NRpCaFQs8lwLptQmxz70M/bFHRbToacHbl8Kml/Z/gnjNeQA3mxW7Wr8dOPEVnaZAMfj3CoyQo4jLCw23+naq14V0cBe6FnoY/ar0HtxKX/6s/OoWWiCn7lLbtqFgr6zx/XmluWYG1EHhZmgB94a1mbt5MJ+pC/lh0mngtDmqaWXimptlVpYt7JixM305QGr4wfK3NgjKeKqHftSgqCKlNtWQlKrRAI3iLboBhGj4Hrl7uGATTr+AibwWzB9a3PyBsUozF/b/v1P1LxQ9FVirE6Pifz2bPlm/kzDMxnAdRIa3KDtvngwzpHT0W4xQmh+WbZHAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/16 23:16, Suren Baghdasaryan wrote:
> On Sat, Aug 15, 2026 at 3:45 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>>
>> On 8/12/26 7:41 AM, Hao Ge wrote:
>>> In reserve_module_tags(), the tag overflow check is gated on
>>> mem_alloc_profiling_enabled():
>>>
>>>     if (mem_alloc_profiling_enabled() && !tags_addressable())
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
>>> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
>>> profiling, release the reservation, and return -EAGAIN so that
>>> layout_and_allocate() retries with profiling disabled: codetag sections
>>> are then placed as regular module data and the module loads without
>>> profiling rather than being rejected entirely.
>>
>> When the described overflow occurs, why should codetag sections be
>> placed as regular module data? Will the codetag support use them in any
>> way, or do they simply waste space? Is the issue that alloc_hooks()
>> creates relocations pointing into .codetag.alloc_tags?
> 
> Correct, alloc_hooks() will have references into .codetag.alloc_tags.
> With mem_profiling_support=false they should technically never be used
> but I don't think it's a good idea to skip .codetag.alloc_tags section
> allocation and to leave dangling pointers. Also the case described
> here is an outlier, so optimizing it would not yield much benefit.
> 
>>
>>>
>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  kernel/module/main.c | 25 +++++++++++++++++++++++--
>>>  mm/alloc_tag.c       |  8 +++++---
>>>  2 files changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>>> index 46dd8d25a605..ed26f167be84 100644
>>> --- a/kernel/module/main.c
>>> +++ b/kernel/module/main.c
>>> @@ -2944,6 +2944,7 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>>  {
>>>       struct module *mod;
>>>       int err;
>>> +     unsigned long frob_size[MOD_MEM_NUM_TYPES];
>>
>> frob_size is used to store values of module_memory::size, which has type
>> `unsigned int`. The types should match.
>>
>>>
>>>       /* Allow arches to frob section contents and sizes.  */
>>>       err = module_frob_arch_sections(info->hdr, info->sechdrs,
>>> @@ -2966,18 +2967,38 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>>        */
>>>       module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
>>>
>>> +     /*
>>> +      * Save the sizes reserved by module_frob_arch_sections() so they can
>>> +      * be restored if we retry below.
>>> +      */
>>> +     for_each_mod_mem_type(type)
>>> +             frob_size[type] = info->mod->mem[type].size;
>>> +
>>>       /*
>>>        * Determine total sizes, and put offsets in sh_entsize.  For now
>>>        * this is done generically; there doesn't appear to be any
>>>        * special cases for the architectures.
>>>        */
>>> +retry:
>>>       layout_sections(info->mod, info);
>>>       layout_symtab(info->mod, info);
>>>
>>>       /* Allocate and move to the final place */
>>>       err = move_module(info->mod, info);
>>> -     if (err)
>>> -             return ERR_PTR(err);
>>> +     if (err) {
>>> +             if (err != -EAGAIN)
>>> +                     return ERR_PTR(err);
>>
>> The move_module() logic is non-trivial. -EAGAIN could be returned by
>> other code, now or in the future.
> 
> That's a good point.
> 
>>
>>> +             /*
>>> +              * -EAGAIN means profiling was disabled but the module
>>> +              * can still load without it. Reset state and retry.
>>> +              */
>>> +             rewrite_section_headers(info, flags);
>>> +             for_each_mod_mem_type(type)
>>> +                     info->mod->mem[type].size = frob_size[type];
>>> +             info->sechdrs[info->index.sym].sh_flags &= ~(unsigned long)SHF_ALLOC;
>>> +             info->sechdrs[info->index.str].sh_flags &= ~(unsigned long)SHF_ALLOC;
>>
>> Why is it necessary to reset SHF_ALLOC for .symtab and .strtab here?
> 
> I believe layout_symtab() sets that bit and to retry we need to reset
> it. But I might be wrong here.
> 

Thanks Suren.

And yes, IMHO layout_symtab() is the reason. In the module ELF, .symtab and.strtab
carry no flags at all. layout_symtab() sets SHF_ALLOC on them so that move_module()
will copy them, and it places them itself at the end of MOD_INIT_DATA.

Without the clearing, __layout_sections() on the second pass would pick the two
sections up again: SHF_ALLOC set, no SHF_WRITE, so they match its RODATA mask and get
some of MOD_RODATA reserved. Then layout_symtab() runs anyway, overwrites sh_entsize
and puts them into MOD_INIT_DATA, same as the first pass. The reserved MOD_RODATA is
never used by anything, so the module would just carry that dead space for no reason.
Hence the clearing.

Or am I missing any details?

>>
>>> +             goto retry;
>>> +     }
>>>
>>>       /* Module has been copied to its final place now: return it. */
>>>       mod = (void *)info->sechdrs[info->index.mod].sh_addr;
>>
>> I'm not sure this is the best approach. It's complex logic for what
>> appears to be an edge case related to a debugging facility. It will have
>> the usual problem of error paths not getting enough testing and breaking
>> subtly over time.
>>
>> An alternative could be to reset SHF_ALLOC on the codetag section to
>> remove it from further processing and have relocations that point to
>> this section resolve to something else. It seems that alloc_hooks_tag()
>> could tolerate this, since it only needs to reference the associated
>> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
>> disabled by reserve_module_tags() on the overflow.
> 
> Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
> would be much better.
> 
>>
>> It is also not an ideal approach, but I feel it could be less intrusive
>> to the module loader. I can put together a prototype if needed.
> 
> If your approach does not cause module loading to fail when we disable
> profiling, then that sounds like a good idea. If it's not too much
> trouble, could you please send an RFC?
> 
>>
>> --
>> Thanks,
>> Petr

