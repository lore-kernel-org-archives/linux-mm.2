Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C163BC5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35156B008C; Thu, 27 Aug 2026 02:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D0D6B0092; Thu, 27 Aug 2026 02:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923116B0095; Thu, 27 Aug 2026 02:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69EE56B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:02:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC161A3AF0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:02:45 +0000 (UTC)
X-FDA: 85146005490.12.2FA704B
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACF31160003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:02:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioWp1ebU;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787810564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NvbZQcRc9tf+mt0pLoc3aigTKFaUPAETqc0ScVHZ1s=;
	b=NaH/Lcu7eYlRzf8FTipaZ95QZiAQdYav+Zi0zrb/JoKK2+53gkE0UpQeY2tRqZJZImchiz
	dlhanF3WhUx+m/fw7Bk9HlXL1Bd5M9HwdDoXmjVMIe1jYhRsQI0cmlkHfL3I7p/w5v8i/I
	WcuXloTnUY7Q+Uo1gryqgEe9jzuPd+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787810564;
	b=zU/Tm0xfM4RSOh9ENzKWJCVLqxqqcJv2aQUkHNrkRMajTVbKSbGoBu51V3W7xDUrAgvD0m
	tc7XNXPXYxd0fSJ1vN0lc/eRMAtzmaFE1solq9QcYeWMU7xlIdo8ZULxHj/rOPAJAqhJwU
	m3NZc6UqMH5jxeD4+bAOBLIbSUafQ2w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioWp1ebU;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yhxcRELlgWj4COAPXicgdgehfkV/GFyP3V9GQ5gVbkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787810562; v=1; x=1788415362;
 b=ioWp1ebUArJD+WOc6BeIPa1+a9ITkANn4wfphP1T1yNbAu8dHTvLaBKwTIWbqGwr9iSMlI20
 cPepAVmz/0jU415aOKVKl75fwZYLvYh/BASacgBUno3ptZMN/nDCCCjSRvnl/3OLM3KxpoWAs2s
 z+4QYEYUC1LN4MsyRgyh1cyA=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.42.12.33] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id a237b388cb56e0f6;
	Thu, 27 Aug 2026 06:02:42 +0000
X-Mizu-Trace-ID: a237b388cb56e0f6
X-Migadu-Flow: FLOW_OUT
Message-ID: <1f5fdb4d-29a7-4466-80a5-aa828bea78ff@linux.dev>
Date: Thu, 27 Aug 2026 14:03:18 +0800
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
 <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
 <CAJuCfpE7tSXOOfDVUpOp-jKyyw0vXUk6Q7MFxOVoYULXmh8GjA@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpE7tSXOOfDVUpOp-jKyyw0vXUk6Q7MFxOVoYULXmh8GjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ACF31160003
X-Stat-Signature: fzoidne7badrs7yfqxhoqbbt3sjtaq14
X-HE-Tag: 1787810563-365046
X-HE-Meta: U2FsdGVkX18hynjpwi710A1LTyCNYkMAK4R7fDxs3izIJG86GPPyunj5Z7p/4AUdT07VFWTIb5IjJFvc0WH+9CNkMZGo8767SiVnu1x4dckaqDaj1YiRteiVXuUOo6rEU4HJQlD4/D2fMU54LF3hJ/E5FW7axkbCKr9zf2YwX5A/5I3xqy3eaIjkF9IvRJWGuIf39cOuBGNgGbxG7cJQenG93LgyXT1eonmVI3HjmPSrX2/NZhP+Kzs+9EKnpNVzcTF+ZSQWaFxCw3mflHeh/buXjhCUDJu9hLhAUXA+8Pli+VvkJ9seFtq+OE8YdjLJpYmH0A7zf7jsCCKiFLRKjGwBkXdq8cQmS1ddoNqCTl/cZ59ds/ocY9JeaqtxGu+/zDM9A9PWe2/CX5xbfKMj1VQgUTF43eJa99Idb3zSC0tE1BMIN2p5vohOaqj/SZKERBKL3kdyeDsSqOLa2qgKdDxFdrvTQtaB0vokg3Fr3pzYnL3ndM78qkenOk5gfOFT4o8HTqyLAdtHVQYFETCi/Bwu+YLa4oyOCFEvB4AQSbaHfcT7hff8tYQKnSONEcfaxIJbwD7x+GP+d9+yWEk+sD/mY/Df4UJ/ZdLHK9n7fv6BbJR5xfRLhjjVNXmUng8lZdqPPxDoPGqsyMmsQa8ciuQUb0lI7cVmRtCI7kC+js4oSTnhIsR+7dlL0+ejnrL0iHxvCFsWVKhaOfyCTEOzqDVJ+KIkb1Zb9jcd9ROdm/rAI4CqJF9MAQZzK9RpMnVy/RRmD22NKrtxDM3+MQ08VxBFUrHMwEEyH4j1GMNov9c5/Q9HiXievFjAEEbmUODHBbEDFoO6TKiwDwfb/LLG9eAIWJMW0/KJnV1OWR/3SA+VvE175oz0EwNXsv1jHI4fFT8pDYE2CqRQVHmPy+6/8BbUGqPe3jP+k1Jx42DqbR2qj/kHEbjWKRQmc/LBHMWFEKdzQlSQczY/2GEeeVf
 SnTaGlaF
 x+7ZQPxkvXttIExDuxo2wBcVGQolK6vnVwDAffYscnSFvWyC9S2rx9a026LCsmb3fksJlPRkt91MeI7a0puUe/borjDFUTfOV6S29UkvTPRZV6QtLlyIE5HFeWU4hzjGhV87fvTDdWVLvtpYAkruQwmPYKpM3lDTdZsmZ9SeSgRsAWsoH1b8E3Mo3z1eaUiG+ugPGi9OjzpGG1vyhQZNEJufKgDp/LqQmB+B8Scn/avT5LEe7Rwp5Qy8iexYgoQywhkil+Nu4t62f7vdWEYhlu0o0Kj5cRShIZSDA7z3knm4YuqfXfuDb4K1UJ2N3F8m0NPAMQ9JUT90h77e9wHaytG/JS7WMEJRmcmEN6ZQk7zUo1cYsG2ihZ6ukFmOoiefdPxU4Tml4nUz12G/y/I3VcW1MmWgIMQfFg+rLVzI8UHQfG3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren and Petr


On 2026/8/27 08:47, Suren Baghdasaryan wrote:
> On Wed, Aug 26, 2026 at 1:32 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>>
>> On 8/16/26 5:16 PM, Suren Baghdasaryan wrote:
>>> On Sat, Aug 15, 2026 at 3:45 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>>>> On 8/12/26 7:41 AM, Hao Ge wrote:
>>>>> In reserve_module_tags(), the tag overflow check is gated on
>>>>> mem_alloc_profiling_enabled():
>>>>>
>>>>>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>>>>>
>>>>> If profiling is toggled off at runtime and a module is loaded whose
>>>>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>>>>> skipped. vm_module_tags_populate() still maps memory for the tags and
>>>>> the module loads successfully, but the total tag count now exceeds what
>>>>> NR_UNUSED_PAGEFLAG_BITS can address.
>>>>>
>>>>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>>>>> as its position in the alloc_tag array. update_page_tag_ref() masks
>>>>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>>>>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>>>>> tags.
>>>>>
>>>>> This silently corrupts /proc/allocinfo: allocated pages get attributed
>>>>> to the wrong call sites, so the statistics it reports are wrong.
>>>>>
>>>>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>>>>> independent. Once compressed mode is established at boot, it stays
>>>>> active regardless of runtime toggles of mem_profiling.
>>>>>
>>>>> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
>>>>> profiling, release the reservation, and return -EAGAIN so that
>>>>> layout_and_allocate() retries with profiling disabled: codetag sections
>>>>> are then placed as regular module data and the module loads without
>>>>> profiling rather than being rejected entirely.
>>>>
>>>> When the described overflow occurs, why should codetag sections be
>>>> placed as regular module data? Will the codetag support use them in any
>>>> way, or do they simply waste space? Is the issue that alloc_hooks()
>>>> creates relocations pointing into .codetag.alloc_tags?
>>>
>>> Correct, alloc_hooks() will have references into .codetag.alloc_tags.
>>> With mem_profiling_support=false they should technically never be used
>>> but I don't think it's a good idea to skip .codetag.alloc_tags section
>>> allocation and to leave dangling pointers. Also the case described
>>> here is an outlier, so optimizing it would not yield much benefit.
>>>
>> [...]
>>>> I'm not sure this is the best approach. It's complex logic for what
>>>> appears to be an edge case related to a debugging facility. It will have
>>>> the usual problem of error paths not getting enough testing and breaking
>>>> subtly over time.
>>>>
>>>> An alternative could be to reset SHF_ALLOC on the codetag section to
>>>> remove it from further processing and have relocations that point to
>>>> this section resolve to something else. It seems that alloc_hooks_tag()
>>>> could tolerate this, since it only needs to reference the associated
>>>> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
>>>> disabled by reserve_module_tags() on the overflow.
>>>
>>> Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
>>> would be much better.
>>>
>>>>
>>>> It is also not an ideal approach, but I feel it could be less intrusive
>>>> to the module loader. I can put together a prototype if needed.
>>>
>>> If your approach does not cause module loading to fail when we disable
>>> profiling, then that sounds like a good idea. If it's not too much
>>> trouble, could you please send an RFC?
>>
>> The alternative approach I mentioned unfortunately doesn't work well,
>> since redirecting all relocations against .codetag.alloc_tag to
>> a different destination is nontrivial. It would require introducing
>> something like frob_relocation() that is called from each
>> architecture-specific apply_relocate()/apply_relocate_add() after the
>> addend has been decoded.
>>
>> Another option I realized is to change the order in which module
>> sections are allocated. Rather than interleaving the allocation of
>> codetag and regular sections, the module loader could first try to
>> allocate codetag sections and then allocate regular sections. If
>> allocation of a codetag section fails, it can naturally fall back to
>> being treated as a regular section. This avoids retrying the allocation
>> process, which I would prefer to avoid.
>>
>> A prototype is below.
> 
> Thanks for following up on this, Petr!

+1

> At first glance, this seems like a much cleaner approach. But it's
> also a sizable change, so it will need some testing. I'll try to run
> some test scenarios over the weekend.

I believe Petr's approach can also address the race problem pointed out by this patch:
https://lore.kernel.org/all/20260813093421.135230-3-hao.ge@linux.dev/
I will also go through this patch and run some local tests as soon as possible.

Thanks
Best Regards
Hao

> 
>>
>> --
>> Thanks,
>> Petr
>>
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 96cc98568eea..0c6f32ddcbf2 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -325,6 +325,8 @@ enum mod_mem_type {
>>         MOD_INIT_RODATA,
>>
>>         MOD_MEM_NUM_TYPES,
>> +
>> +       MOD_STANDALONE = -2,
>>         MOD_INVALID = -1,
>>  };
>>
>> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
>> index 061161cc79d9..217bb540e361 100644
>> --- a/kernel/module/internal.h
>> +++ b/kernel/module/internal.h
>> @@ -29,6 +29,10 @@
>>  #define SH_ENTSIZE_TYPE_MASK   ((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
>>  #define SH_ENTSIZE_OFFSET_MASK ((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE_BITS)) - 1)
>>
>> +#define SH_ENTSIZE_STANDALONE                                  \
>> +       (((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK) \
>> +        << SH_ENTSIZE_TYPE_SHIFT)
>> +
>>  /* Maximum number of characters written by module_flags() */
>>  #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
>>
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index d0e1e0bd2ad0..a86ae8774cd0 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -1624,7 +1624,7 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>>                  * ELF template and subsequently copy it to the per-CPU destinations.
>>                  */
>>                 if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
>> -                   (!infosec || infosec != info->index.pcpu))
>> +                   info->sechdrs[infosec].sh_entsize != SH_ENTSIZE_STANDALONE)
>>                         continue;
>>
>>                 if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
>> @@ -1722,20 +1722,6 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
>>                         if (WARN_ON_ONCE(type == MOD_INVALID))
>>                                 continue;
>>
>> -                       /*
>> -                        * Do not allocate codetag memory as we load it into
>> -                        * preallocated contiguous memory.
>> -                        */
>> -                       if (codetag_needs_module_section(mod, sname, s->sh_size)) {
>> -                               /*
>> -                                * s->sh_entsize won't be used but populate the
>> -                                * type field to avoid confusion.
>> -                                */
>> -                               s->sh_entsize = ((unsigned long)(type) & SH_ENTSIZE_TYPE_MASK)
>> -                                               << SH_ENTSIZE_TYPE_SHIFT;
>> -                               continue;
>> -                       }
>> -
>>                         s->sh_entsize = module_get_offset_and_type(mod, type, s, i);
>>                         pr_debug("\t%s\n", sname);
>>                 }
>> @@ -1745,16 +1731,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
>>  /*
>>   * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
>>   * might -- code, read-only data, read-write data, small data.  Tally
>> - * sizes, and place the offsets into sh_entsize fields: high bit means it
>> - * belongs in init.
>> + * sizes, and place the offsets into sh_entsize fields.
>>   */
>>  static void layout_sections(struct module *mod, struct load_info *info)
>>  {
>> -       unsigned int i;
>> -
>> -       for (i = 0; i < info->hdr->e_shnum; i++)
>> -               info->sechdrs[i].sh_entsize = ~0UL;
>> -
>>         pr_debug("Core section allocation order for %s:\n", mod->name);
>>         __layout_sections(mod, info, false);
>>
>> @@ -2800,7 +2780,6 @@ static int move_module(struct module *mod, struct load_info *info)
>>  {
>>         int i, ret;
>>         enum mod_mem_type t = MOD_MEM_NUM_TYPES;
>> -       bool codetag_section_found = false;
>>
>>         for_each_mod_mem_type(type) {
>>                 if (!mod->mem[type].size) {
>> @@ -2818,36 +2797,14 @@ static int move_module(struct module *mod, struct load_info *info)
>>         /* Transfer each section which specifies SHF_ALLOC */
>>         pr_debug("Final section addresses for %s:\n", mod->name);
>>         for (i = 0; i < info->hdr->e_shnum; i++) {
>> -               void *dest;
>>                 Elf_Shdr *shdr = &info->sechdrs[i];
>> -               const char *sname;
>> +               void *dest;
>>
>>                 if (!(shdr->sh_flags & SHF_ALLOC))
>>                         continue;
>>
>> -               sname = info->secstrings + shdr->sh_name;
>> -               /*
>> -                * Load codetag sections separately as they might still be used
>> -                * after module unload.
>> -                */
>> -               if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
>> -                       dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>> -                                       arch_mod_section_prepend(mod, i), shdr->sh_addralign);
>> -                       if (WARN_ON(!dest)) {
>> -                               ret = -EINVAL;
>> -                               goto out_err;
>> -                       }
>> -                       if (IS_ERR(dest)) {
>> -                               ret = PTR_ERR(dest);
>> -                               goto out_err;
>> -                       }
>> -                       codetag_section_found = true;
>> -               } else {
>> -                       enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>> -                       unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
>> -
>> -                       dest = mod->mem[type].base + offset;
>> -               }
>> +               dest = mod->mem[shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT].base +
>> +                      (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
>>
>>                 if (shdr->sh_type != SHT_NOBITS) {
>>                         /*
>> @@ -2879,8 +2836,6 @@ static int move_module(struct module *mod, struct load_info *info)
>>         module_memory_restore_rox(mod);
>>         while (t--)
>>                 module_memory_free(mod, t);
>> -       if (codetag_section_found)
>> -               codetag_free_module_sections(mod);
>>
>>         return ret;
>>  }
>> @@ -2951,9 +2906,47 @@ static bool blacklisted(const char *module_name)
>>  }
>>  core_param(module_blacklist, module_blacklist, charp, 0400);
>>
>> +/*
>> + * Allocate codetag sections separately. They are loaded into preallocated
>> + * contiguous memory because they may still be used after the module is
>> + * unloaded.
>> + *
>> + * If the separate allocation overflows and fails, allocate the section normally
>> + * so that the module can still be loaded.
>> + */
>> +static void allocate_codetag_sections(struct load_info *info)
>> +{
>> +       for (unsigned int i = 1; i < info->hdr->e_shnum; i++) {
>> +               Elf_Shdr *shdr = &info->sechdrs[i];
>> +               const char *sname = info->secstrings + shdr->sh_name;
>> +               void *dest;
>> +
>> +               if (!(shdr->sh_flags & SHF_ALLOC) ||
>> +                   !codetag_needs_module_section(info->mod, sname,
>> +                                                 shdr->sh_size))
>> +                       continue;
>> +
>> +               dest = codetag_alloc_module_section(
>> +                       info->mod, sname, shdr->sh_size,
>> +                       arch_mod_section_prepend(info->mod, i),
>> +                       shdr->sh_addralign);
>> +               if (WARN_ON(!dest) || IS_ERR(dest)) {
>> +                       /* Allocate the section as a regular section. */
>> +                       continue;
>> +               }
>> +
>> +               if (shdr->sh_type != SHT_NOBITS)
>> +                       memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
>> +               shdr->sh_addr = (unsigned long)dest;
>> +               shdr->sh_flags &= ~(unsigned long)SHF_ALLOC;
>> +               shdr->sh_entsize = SH_ENTSIZE_STANDALONE;
>> +       }
>> +}
>> +
>>  static struct module *layout_and_allocate(struct load_info *info, int flags)
>>  {
>>         struct module *mod;
>> +       unsigned int i;
>>         int err;
>>
>>         /* Allow arches to frob section contents and sizes.  */
>> @@ -2967,9 +2960,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>         if (err < 0)
>>                 return ERR_PTR(err);
>>
>> -       /* We will do a special allocation for per-cpu sections later. */
>> -       info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>> -
>>         /*
>>          * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections() can
>>          * put them in the right place.
>> @@ -2977,18 +2967,27 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>          */
>>         module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
>>
>> -       /*
>> -        * Determine total sizes, and put offsets in sh_entsize.  For now
>> -        * this is done generically; there doesn't appear to be any
>> -        * special cases for the architectures.
>> -        */
>> +       /* Repurpose sh_entsize to track where each section is allocated. */
>> +       for (i = 0; i < info->hdr->e_shnum; i++)
>> +               info->sechdrs[i].sh_entsize = ~0UL;
>> +
>> +       /* We will do a special allocation for per-cpu sections later. */
>> +       info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>> +       info->sechdrs[info->index.pcpu].sh_entsize = SH_ENTSIZE_STANDALONE;
>> +
>> +       /* Allow codetag sections to be allocated separately first. */
>> +       allocate_codetag_sections(info);
>> +
>> +       /* Determine total sizes and put offsets in sh_entsize. */
>>         layout_sections(info->mod, info);
>>         layout_symtab(info->mod, info);
>>
>>         /* Allocate and move to the final place */
>>         err = move_module(info->mod, info);
>> -       if (err)
>> +       if (err) {
>> +               codetag_free_module_sections(mod);
>>                 return ERR_PTR(err);
>> +       }
>>
>>         /* Module has been copied to its final place now: return it. */
>>         mod = (void *)info->sechdrs[info->index.mod].sh_addr;
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 2070e682fe10..112a014d4b89 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>                 int grow_res;
>>
>>                 module_tags.size = offset + size;
>> -               if (mem_alloc_profiling_enabled() && !tags_addressable()) {
>> +               if (!tags_addressable()) {
>>                         shutdown_mem_profiling(true);
>> -                       pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>> -                               mod->name, NR_UNUSED_PAGEFLAG_BITS);
>> +                       pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>> +                                    mod->name, NR_UNUSED_PAGEFLAG_BITS);
>> +                       release_module_tags(mod, false);
>> +                       return ERR_PTR(-EAGAIN);
>>                 }
>>
>>                 grow_res = vm_module_tags_populate();

