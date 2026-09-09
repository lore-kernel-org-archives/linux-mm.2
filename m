Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E96C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DFD6B0092; Wed,  9 Sep 2026 09:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E856B0098; Wed,  9 Sep 2026 09:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D3F6B00A3; Wed,  9 Sep 2026 09:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 201C96B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:08:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C6DA1201E4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:08:30 +0000 (UTC)
X-FDA: 85194252780.14.BC86F8D
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6969040009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:08:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SqpWv98C;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7y4HH2VRe/FSmMF01NlsAvlf7d1cnUj9I2kV2MHWYw=;
	b=fRNfR9O5Rrgw+NdLVJKBYxMy5d84UkNn0gm6eVvG3lEb3BHBotDXw+/87pHsHCkD7fYvGN
	1Pgk4BBQmPYR85KzboYRV6ieTBA4X6Xd51PbYn+DKYG6lHIFegKgJeycP3H9BQmMWGbnDw
	WHMiPZUS+0+F9+zHojUPTkvQORmDcXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959308;
	b=rZhSzT2zLwF8MLOxl7SKaZ8mAHrzo5vva3P04CGBIFY5UHrObJGorQLpXM6Yhqjhc6ySeT
	aZGTWKATln0m6q35PulukkJ6rxzK+jkwnbDrLRZb20szvPguxvOlaQ73G8VLve271cm6N+
	t3q9SheuT7ul/7mXiLFYNu0vVDXCDvU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SqpWv98C;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VhlFjNAgQI2Jtqxdp11XUFniGZMKsYGwyqeIsjbkGdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788959301; v=1; x=1789564101;
 b=SqpWv98C61R76bJ0zUrMa/dUYoDYli14Cu7Sz2NGtXopPX3r0MU39mdYsfsxVAcN0nIXkHZB
 iDpYgU6xxC+1nMXUk9M4EJPCHIPpCUSVYrqxdZ4RPhIqRh0+meNClDCpRd33JuUrmJn0ZAzk0IJ
 KsweRhAgxCuHVDoM9FQKa/ME=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 25b253702b94a6c9;
	Wed, 09 Sep 2026 13:08:21 +0000
X-Mizu-Trace-ID: 25b253702b94a6c9
X-Migadu-Flow: FLOW_OUT
Message-ID: <7dbba23e-5530-43c4-9c44-20108cd0cef5@linux.dev>
Date: Wed, 9 Sep 2026 21:08:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
From: Hao Ge <hao.ge@linux.dev>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260908092412.115953-1-hao.ge@linux.dev>
 <20260908092412.115953-4-hao.ge@linux.dev>
 <76b5edbb-8231-41d0-9e7b-f965af13c324@suse.com>
 <ec3f14f0-cebe-460f-9df7-537f49d70afd@linux.dev>
Content-Language: en-US
In-Reply-To: <ec3f14f0-cebe-460f-9df7-537f49d70afd@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qmwamsag5ibjnf4epu3rwm898z37crum
X-Rspamd-Queue-Id: 6969040009
X-HE-Tag: 1788959306-129091
X-HE-Meta: U2FsdGVkX1+OxubWeKftlqG0y3Pl5H1ARmFhv2A1djwuGC+0DdJrYTC3vvRqtPqA2uhu3oKFok4yyE6EyNj+ncmSOMnIio+Ng5a1XpdhKi/KeZvuWITsNvu7yCd+htwZwk2QJHxBBOwSkEgbSq0z4xz7m7UnmKiLflmDPmswQYw93QfwVGvQCZFCxE/Jm9ilBzgJDdv7Jr7qMOk6saGWVRnzWcFdVaI1Pl+jvj0DRAkrUIUkYDN6TP93BOvogkjo1TfXe2LPKgn4D/c5mBLgf7UrZibxiBGkfi8tJy3AXKR3SWyIl2OtcjnHGalrviyRzmCSwyPCZlDT2P3aSfLEapIsFuVYowpJmh3fQZ78G6uT7x8nAPmQEBA+9sA5oVGQNlvT00s8p9bOllDuJ/XYxobQR5A6KzsSn3O/mhOcZqiF5Hy2z8XWtGXTkd67Mcn4TyXAjDB1j1hqxc+R2YiC7kAROAIeoeeC77C6uW7iIsRJ68vPwy9NnOX2g/tDN5JkHKvV8EFpX855Cm4lOyWQarCoOZ04UGJYHLiMbCA4ZIPKcsZUg8qiNFyCmHRUnd0pldg1U215dzDhF1w9qeTFoXvXNHfKEGi9BP9tYbrEBkJAtcytLDio6cXJhQu/vvi/+ZjYDi11r51ojh1IcZ89Y/++l9IF+LH8CL3CR8Qsl3xVg8R520yZx5rqtdveKHQGPLT7+D+9MhglayExUAyxe66TpzcNbaiM7jcHyDfJdXlUKXyfOMNjGdseFRoGKohFkmPCfZL0hgfyukcd9jSpzNHiD5y2vkGNMLdCqQ/airw4XBAKyq3MkXJDlCmNnIE8OvVfCCNyweAC1mSVlpASogxysg0ngnWmBPbPhKdG07aABK1dTtOFiNb1QsGiblGAGwRz8i56Z5xS+qMNWAdQzYgS32RrUf+Ru5/1G7r03GqSXn2gk0QRXunamDuIerX8ItR5ict7HMJ4rmKA9nv
 jzh6gwps
 H1iVZoxFG7LnAKUicq9gzasD1wLs8O91IYfUXkwr/cEJew5Pr0jD24JwQM+4tdEL7KqBupb0IMVRKpMbuu1efcxiKCmwh576dDkV+yG0aAPW9LIFCmIqxmNq/b18vPnYjR1Hlf2sehRYS7KrCFpPo9F4GwVfhTSUB9Az3uVLhwfWQBJd3nn8rwgFbVyu1PzhyjluJpbNEDXuqlJhtmxBvCXNCvxHG45mszRo8qfqc4xP1P7bG/UEUxTeueGTRdoxcC17OL2y2ZKeezcl/wakUTzJd9tcBVOAjoKsWuJ4QfysI5Tah0NHVMf+p5Q7X5oQ35LAkYA3saJh0abUMNadAW4j+aNXE/In6Jw/eVP0G2KOpbk4w7GbXCjIyp1KQ8pFvvhZcpjFcHJmU+muHuy2wgJn527z06tYvEkLmhG2o0GnKrwXcp8hn5RKA1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/26 20:47, Hao Ge wrote:
> Hi Petr
>
>
> On 9/9/26 19:30, Petr Pavlu wrote:
>> On 9/8/26 11:24 AM, Hao Ge wrote:
>>> SHF_ALLOC means, per the ELF spec, that a section occupies memory
>>> during process execution. Some module sections occupy memory
>>> outside the regular module layout, for example the percpu section
>>> with its per-CPU allocations. The loader currently excludes such
>>> a section from the layout by clearing its SHF_ALLOC, which
>>> overloads the flag with a loader-internal meaning.
>>> apply_relocations() needs a special case for the section, and
>>> find_sec(".data..percpu") returns different results before and
>>> after layout_and_allocate().
>>>
>>> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
>>> allocation. The percpu section is its first user. layout_sections()
>>> and move_module() skip marked sections, and apply_relocations() goes
>>> back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].
>>>
>>> .data..percpu keeps SHF_ALLOC, so it would now show up under
>>> /sys/module/*/sections/. The section has one instance per CPU and no
>>> single address to report, and the entry never existed before, so
>>> skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
>>> array and skips it too. No functional change otherwise.
>>>
>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag 
>>> compression")
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Link: 
>>> https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ 
>>> [1]
>>> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>> [...]
>>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>>> index 0fc11e45df9b..49190deae61e 100644
>>> --- a/kernel/module/kallsyms.c
>>> +++ b/kernel/module/kallsyms.c
>>> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const 
>>> struct load_info *info)
>>>   }
>>>     static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr 
>>> *sechdrs,
>>> -               unsigned int shnum, unsigned int pcpundx)
>>> +               unsigned int shnum)
>>>   {
>>>       const Elf_Shdr *sec;
>>>       enum mod_mem_type type;
>>> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, 
>>> const Elf_Shdr *sechdrs,
>>>           !src->st_name)
>>>           return false;
>>>   -#ifdef CONFIG_KALLSYMS_ALL
>>> -    if (src->st_shndx == pcpundx)
>>> -        return true;
>>> -#endif
>>> -
>>>       sec = sechdrs + src->st_shndx;
>>>       type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>>>       if (!(sec->sh_flags & SHF_ALLOC)
>>> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct 
>>> load_info *info)
>>>       /* Compute total space required for the core symbols' strtab. */
>>>       for (ndst = i = 0; i < nsrc; i++) {
>>>           if (i == 0 || is_livepatch_module(mod) ||
>>> -            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>> -                   info->index.pcpu)) {
>>> +            is_core_symbol(src + i, info->sechdrs, 
>>> info->hdr->e_shnum)) {
>>>               strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>>>               ndst++;
>>>           }
>>> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const 
>>> struct load_info *info)
>>>       for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>>>           kallsyms->typetab[i] = elf_type(src + i, info);
>>>           if (i == 0 || is_livepatch_module(mod) ||
>>> -            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>> -                   info->index.pcpu)) {
>>> +            is_core_symbol(src + i, info->sechdrs, 
>>> info->hdr->e_shnum)) {
>>>               ssize_t ret;
>>>                 mod->core_kallsyms.typetab[ndst] =
>> FTR These changes in kernel/module/kallsyms.c have a conflict with the
>> series "Ignore local labels and mapping symbols during module load" [1],
>> which is currently queued on modules-next, but it should be
>> straightforward to resolve.
>>
>>> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
>>> index 01c65d608873..f64170344e69 100644
>>> --- a/kernel/module/sysfs.c
>>> +++ b/kernel/module/sysfs.c
>>> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct 
>>> module_sect_attrs *sect_attrs)
>>>       kfree(sect_attrs);
>>>   }
>>>   +/*
>>> + * .data..percpu has a separate allocation per CPU and no single
>>> + * address to report.
>>> + */
>>> +static bool sect_visible(const struct load_info *info, unsigned int i)
>>> +{
>>> +    return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
>>> +}
>>> +
>>>   static int add_sect_attrs(struct module *mod, const struct 
>>> load_info *info)
>>>   {
>>>       struct module_sect_attrs *sect_attrs;
>>> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, 
>>> const struct load_info *info)
>>>         /* Count loaded sections and allocate structures */
>>>       for (i = 0; i < info->hdr->e_shnum; i++)
>>> -        if (!sect_empty(&info->sechdrs[i]))
>>> +        if (sect_visible(info, i))
>>>               nloaded++;
>>>       sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
>>>       if (!sect_attrs)
>>> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, 
>>> const struct load_info *info)
>>>       for (i = 0; i < info->hdr->e_shnum; i++) {
>>>           Elf_Shdr *sec = &info->sechdrs[i];
>>>   -        if (sect_empty(sec))
>>> +        if (!sect_visible(info, i))
>>>               continue;
>>>           sysfs_bin_attr_init(sattr);
>>>           sattr->attr.name =
>>> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, 
>>> const struct load_info *info)
>>>         nattr = &notes_attrs->attrs[0];
>>>       for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
>>> -        if (sect_empty(&info->sechdrs[i]))
>>> +        if (!sect_visible(info, i))
>>>               continue;
>>>           if (info->sechdrs[i].sh_type == SHT_NOTE) {
>>>               sysfs_bin_attr_init(nattr);
>> add_notes_attrs() has two sect_empty() calls. Both should be changed to
>> sect_visible().
>
>
> I kept this part unmodified to preserve the loop's original intent.
>
> This loop counts SHT_NOTE sections.
>
> SHT_NOTE refers to ELF note sections, which hold non-executable
>
> metadata such as build ID and ABI info.
>
> I wonder if we could keep the current implementation.
>
> As noted in the comment above, the top part counts SHT_NOTE sections
>
> and allocates structures, while the lower logic handles control of 
> node attributes.
>
>
> WDYT?
>
>

Sorry, I've reconsidered this. I think changing it to sect_visible would 
be better.

sect_visible stands for the count of externally visible note attributes, 
so the code

above and below can align with each other.


Sorry for the noise.


I'll rebase onto modules-next, apply this change and push a new revision.

I'll also add your Reviewed-by tag.


Thanks

Best Regards

Hao


> Thanks
>
> Best Regards
>
> Hao
>
>>
>> With this fixed, the patch looks ok to me. Feel free to add:
>>
>> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
>>
>> [1] 
>> https://lore.kernel.org/linux-modules/20260820125007.22943-1-yangtiezhu@loongson.cn/
>>

