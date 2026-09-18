Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 799ADC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5586B008C; Thu, 17 Sep 2026 22:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895ED6B0092; Thu, 17 Sep 2026 22:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787BF6B0093; Thu, 17 Sep 2026 22:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5128E6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:50:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA956C0506
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:50:37 +0000 (UTC)
X-FDA: 85225354914.10.4F0AC61
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 338781C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:50:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8L+LzCh;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789699836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K17Mevd06rppU+QI/QjJ/0CTqnOrJMyC6HzuXs2pnk=;
	b=pKdtal5poesPe5KgBux8oJL0QNIeuGhK4/xsFNpezyfYuYIU44Yf495u7U/IhuiT5kEbJg
	zFJ7yOZCOHd2qUkH8sCOLuagJzSblfvtVNW5PxMK/aSIuZ9tQPtlrWyMQ/yZlf1BxOe0Pf
	k1fdv1nC4+197PN8uaB4DYbOgMnB1zw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789699836;
	b=b9BLwz88QjKfcd4qHjw9sDvLZVXCyr+B5VX/TWJY25yOo5fjoOClzSm46KHazQ1sklyG9D
	fFcw3BjXlrWyy5SksR2EOYsjubxAtc15mBJmG3oCmFV+HMC1K/v/98KEXdXRGB6FA1zA5q
	WnJmEuoyxMn9KgZW3ssAzNcBabuNfug=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8L+LzCh;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N6CEd0l0gJW6eAjQ3ySm2d8Yd/dkGeFlWotcwVS5SyY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789699832; v=1; x=1790304632;
 b=q8L+LzChO5BJ4zN/c+/2DaJ/1RGJ8LSa8XmeBKkXK9Y3/ees52CMnAbfwvYH6EP/oxh/quPU
 vLr0ldVTl6kib3XrtDxoqBVQTeJ7NV8dfPT1xrWAA/54XuhOOQsNqcswzNpU8g61oSv/rqkvYbv
 Ul2ToTd5G9rOUsAnk23E8rTI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9d9f438652b75181;
	Fri, 18 Sep 2026 02:50:12 +0000
X-Mizu-Trace-ID: 9d9f438652b75181
X-Migadu-Flow: FLOW_OUT
Message-ID: <887bab46-1959-4e1b-acba-082f91294055@linux.dev>
Date: Fri, 18 Sep 2026 10:51:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
To: Suren Baghdasaryan <surenb@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-4-hao.ge@linux.dev>
 <CAJuCfpHz6V0zT5+QkYdQsBzG9kWCFhP+gris2XRrvSu4hHD6Hw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHz6V0zT5+QkYdQsBzG9kWCFhP+gris2XRrvSu4hHD6Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 338781C0002
X-Stat-Signature: u9egw1i3gpakebhkj7m964kjabd3oxzb
X-Rspam-User: 
X-HE-Tag: 1789699833-780911
X-HE-Meta: U2FsdGVkX18tp5EvOHwd+u1lRuneabKxYugCTjjIkV76LEz0TEXQ6e7bkcfCHsVR+CMJ3wefjEzbf2+xBvm4oph1d49T3fy6fox6oLwh5hfhLQPaNhSA7MKLPED8OPGHDVOY2gR3UXHY1x7YyA2ctvcNuZuz0vsk4gxBsNBaRPaE5//sJOsX1gzIn6O2FdFEwp7No3Rt5MYA+gRZEp5nhefnW3Zd/CMCFUZ0kWrWiaPH5Mkpto2SONibMm8bmBNHtVIMUZlzheELhv66flCY4I4w2Yazyg9vRK+NtpAza0eBsxajGwTt20QpiyBEwaiPw3BE52w6NpIV/J/EluRJ8qIs/9vobfpCSABtONSvJC/9OwnKL3b6vGLQ4q226whDdb5OEsEsgXvsYTU3xzi+KDFbfi51seIjd4TDiLN+LFbrzULHMlFuvy2diOMbIz0CzIlm4S6DsAAYO17g4SPcfmWkbdhHciZrfjqAb7m7wnP2x5+sXQTa4vINhseMVXue2VS9Vy7T1ZPA4n23D2Uzo0FTRRYLdf3/xgUrHIzovE4Q7cCFAf0l8bcHn12BBG9e3kAkLB9E2Qq4lfbbPZ/rqicAordDyMDP6VWl2ShNmeHYyrDYdECNa+FcRlOMlwZjXj1TXwvxFORz3jeT27oWz34lEEWYXwUhvuLcfLWPGarEX6yK45FfIh4rA7TxluX+B8/TieSA00Ro04zF55oAi8e/hB+TeFIzcQAk9a5dPr4C3XnsJMrvDIUmRCqtnQrH2WS0aYYLU0MsYbqfUZgIiS1T3BagXJ/OV3bQb8hLMn5CDWU3htLfQUIGseHBKpuL/uVMAqwvid/Wkq4fNTZO5/XZy5LTuIbmZbm50QIitE8yTeaTT2sn8vNBGsqfCbE65ACBbnz1LvFxkgejoVJLBtgSgTgJ/xPkgWVQi+JCY1W4t6wgORosDX+UGcwF8zU3kAOv6oGQjM6wyd8A5xV
 jIO6kfIS
 sh4qO6BfjhWCHjuwQzvB35QkpHAkZ76yDsq1gE2gvWHvDixGV/SY0anhmdqTH/4sDIQ9PUV2VClddTmVJAMcQ4Jvm527tXCWvyTj5DWXOkKuRJPG9mJWYhTPPGOPpltbLRq3LFVQlNkkJSsCptMbdJJ7uTLRxnb+Ge5MfoPXE8ojtLWFswCr+8FW+M4/IyiBA128xoqyrlGQh0AXeGiQW5m5VNvOGq1wo54FuKY+iLrWloJMso6nXb9MzCK6l3fjnHZhkkZF+zwsWm0HWKcLRGc69dt/E2iPUqFuLMiN8QIE+oz87WPDXwru0dgWtCvCnxhNgTEZauDtWHMIolqYUciMRLDl9FNcHpYszE6F9MCdpwmH2OR1EcmDMoopgYs16Duaw1hv+DPZbhZ+7ERfCWHdHXHyBf4eXV9ZUUw1/2zy+R6KOQ/Lwh0/px0U09vFWeMU+mHMM8aA0MAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/9/18 01:25, Suren Baghdasaryan wrote:
> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> SHF_ALLOC means, per the ELF spec, that a section occupies memory
>> during process execution. Some module sections occupy memory
>> outside the regular module layout, for example the percpu section
>> with its per-CPU allocations. The loader currently excludes such
>> a section from the layout by clearing its SHF_ALLOC, which
>> overloads the flag with a loader-internal meaning.
>> apply_relocations() needs a special case for the section, and
>> find_sec(".data..percpu") returns different results before and
>> after layout_and_allocate().
>>
>> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
>> allocation. The percpu section is its first user. layout_sections()
>> and move_module() skip marked sections, and apply_relocations() goes
>> back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].
>>
>> .data..percpu keeps SHF_ALLOC, so it would now show up under
>> /sys/module/*/sections/. The section has one instance per CPU and no
>> single address to report, and the entry never existed before, so
>> skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
>> array and skips it too. No functional change otherwise.
> 
> And IIUC no userspace-visible changes too, right?
>

Right, I'll fold this into the commit message for the next version:
"No functional or userspace-visible changes otherwise."

>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
>> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
>> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>

Thanks.

Best Regards
Hao

>> ---
>>  include/linux/module.h   |  2 ++
>>  kernel/module/internal.h |  8 ++++++++
>>  kernel/module/kallsyms.c | 13 +++----------
>>  kernel/module/main.c     | 32 +++++++++++++++++---------------
>>  kernel/module/sysfs.c    | 17 +++++++++++++----
>>  5 files changed, 43 insertions(+), 29 deletions(-)
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
>> index 061161cc79d9..4c738074a27b 100644
>> --- a/kernel/module/internal.h
>> +++ b/kernel/module/internal.h
>> @@ -29,6 +29,14 @@
>>  #define SH_ENTSIZE_TYPE_MASK   ((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
>>  #define SH_ENTSIZE_OFFSET_MASK ((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE_BITS)) - 1)
>>
>> +/*
>> + * Marker for sections with a separate allocation, which are not placed
>> + * into mod->mem[].
>> + */
>> +#define SH_ENTSIZE_STANDALONE                                  \
>> +       (((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK) \
>> +        << SH_ENTSIZE_TYPE_SHIFT)
>> +
>>  /* Maximum number of characters written by module_flags() */
>>  #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
>>
>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>> index f23126d804b2..0dca6d40160e 100644
>> --- a/kernel/module/kallsyms.c
>> +++ b/kernel/module/kallsyms.c
>> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>>  }
>>
>>  static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>> -                          unsigned int shnum, unsigned int pcpundx)
>> +                          unsigned int shnum)
>>  {
>>         const Elf_Shdr *sec;
>>         enum mod_mem_type type;
>> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>>             !src->st_name)
>>                 return false;
>>
>> -#ifdef CONFIG_KALLSYMS_ALL
>> -       if (src->st_shndx == pcpundx)
>> -               return true;
>> -#endif
>> -
>>         sec = sechdrs + src->st_shndx;
>>         type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>>         if (!(sec->sh_flags & SHF_ALLOC)
>> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>         /* Compute total space required for the core symbols' strtab. */
>>         for (ndst = i = 0; i < nsrc; i++) {
>>                 if (i == 0 || is_livepatch_module(mod) ||
>> -                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>> -                                  info->index.pcpu)) {
>> +                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>                         strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>>                         ndst++;
>>                 }
>> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>         for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>>                 kallsyms->typetab[i] = elf_type(src + i, info);
>>                 if (i == 0 || is_livepatch_module(mod) ||
>> -                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>> -                                  info->index.pcpu)) {
>> +                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>                         ssize_t ret;
>>
>>                         mod->core_kallsyms.typetab[ndst] =
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index c1b34dc1e89a..ae2678ac7840 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -1619,12 +1619,13 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>>
>>                 /*
>>                  * Don't bother with non-allocated sections.
>> -                * An exception is the percpu section, which has separate allocations
>> -                * for individual CPUs. We relocate the percpu section in the initial
>> -                * ELF template and subsequently copy it to the per-CPU destinations.
>> +                *
>> +                * Note that .data..percpu has separate allocations for
>> +                * individual CPUs. We relocate the section in the
>> +                * initial ELF template and subsequently copy it to the
>> +                * per-CPU destinations.
>>                  */
>> -               if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
>> -                   (!infosec || infosec != info->index.pcpu))
>> +               if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>>                         continue;
>>
>>                 if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
>> @@ -1715,7 +1716,7 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
>>
>>                         if ((s->sh_flags & masks[m][0]) != masks[m][0]
>>                             || (s->sh_flags & masks[m][1])
>> -                           || s->sh_entsize != ~0UL
>> +                           || s->sh_entsize != ~0UL /* offset or standalone */
>>                             || is_init != module_init_layout_section(sname))
>>                                 continue;
>>
>> @@ -1745,16 +1746,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
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
>> @@ -2822,7 +2817,8 @@ static int move_module(struct module *mod, struct load_info *info)
>>                 Elf_Shdr *shdr = &info->sechdrs[i];
>>                 const char *sname;
>>
>> -               if (!(shdr->sh_flags & SHF_ALLOC))
>> +               if (!(shdr->sh_flags & SHF_ALLOC)
>> +                   || shdr->sh_entsize == SH_ENTSIZE_STANDALONE)
>>                         continue;
>>
>>                 sname = info->secstrings + shdr->sh_name;
>> @@ -2954,6 +2950,7 @@ core_param(module_blacklist, module_blacklist, charp, 0400);
>>  static struct module *layout_and_allocate(struct load_info *info, int flags)
>>  {
>>         struct module *mod;
>> +       unsigned int i;
>>         int err;
>>
>>         /* Allow arches to frob section contents and sizes.  */
>> @@ -2967,8 +2964,13 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>         if (err < 0)
>>                 return ERR_PTR(err);
>>
>> +       /* Repurpose sh_entsize to track where each section is allocated. */
>> +       for (i = 0; i < info->hdr->e_shnum; i++)
>> +               info->sechdrs[i].sh_entsize = ~0UL;
>> +
>>         /* We will do a special allocation for per-cpu sections later. */
>> -       info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>> +       if (info->index.pcpu)
>> +               info->sechdrs[info->index.pcpu].sh_entsize = SH_ENTSIZE_STANDALONE;
>>
>>         /*
>>          * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections() can
>> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
>> index 01c65d608873..15c6baeb39c4 100644
>> --- a/kernel/module/sysfs.c
>> +++ b/kernel/module/sysfs.c
>> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
>>         kfree(sect_attrs);
>>  }
>>
>> +/*
>> + * .data..percpu has a separate allocation per CPU and no single
>> + * address to report.
>> + */
>> +static bool sect_visible(const struct load_info *info, unsigned int i)
>> +{
>> +       return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
>> +}
>> +
>>  static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>  {
>>         struct module_sect_attrs *sect_attrs;
>> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>
>>         /* Count loaded sections and allocate structures */
>>         for (i = 0; i < info->hdr->e_shnum; i++)
>> -               if (!sect_empty(&info->sechdrs[i]))
>> +               if (sect_visible(info, i))
>>                         nloaded++;
>>         sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
>>         if (!sect_attrs)
>> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>         for (i = 0; i < info->hdr->e_shnum; i++) {
>>                 Elf_Shdr *sec = &info->sechdrs[i];
>>
>> -               if (sect_empty(sec))
>> +               if (!sect_visible(info, i))
>>                         continue;
>>                 sysfs_bin_attr_init(sattr);
>>                 sattr->attr.name =
>> @@ -159,7 +168,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
>>         /* Count notes sections and allocate structures.  */
>>         notes = 0;
>>         for (i = 0; i < info->hdr->e_shnum; i++)
>> -               if (!sect_empty(&info->sechdrs[i]) &&
>> +               if (sect_visible(info, i) &&
>>                     info->sechdrs[i].sh_type == SHT_NOTE)
>>                         ++notes;
>>
>> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
>>
>>         nattr = &notes_attrs->attrs[0];
>>         for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
>> -               if (sect_empty(&info->sechdrs[i]))
>> +               if (!sect_visible(info, i))
>>                         continue;
>>                 if (info->sechdrs[i].sh_type == SHT_NOTE) {
>>                         sysfs_bin_attr_init(nattr);
>> --
>> 2.25.1
>>

