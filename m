Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DC9C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101E66B0093; Wed,  9 Sep 2026 08:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9306B0095; Wed,  9 Sep 2026 08:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0163A6B0096; Wed,  9 Sep 2026 08:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBE9D6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:48:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D31E01401CE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:48:06 +0000 (UTC)
X-FDA: 85194201372.15.E438A5B
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id 29AFE180005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:48:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0yCmiDX;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958085;
	b=bzKyu+4XQPbfIGt+iAVDLovoWzOZJWupRI2Vk9RMColhXXZ5zSALeQX5if4GAemwnLsC/2
	fwRtayvY9gg+LUFpZN0p1KWtLBfE6gPODBnHidGqu8triQ2KH0xjHGyg4GNq7YAvbDCkJ8
	APv01vB45yJ4McM0Bo6+pqmXbI0f+hw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0yCmiDX;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eaXNOP3sa2P65zATx1RbdQNQ8ekR7kCiWonE5nTkMQM=;
	b=UBCdvf6JSrPaxvNeJRMeMPDWvOqCwlcSGvYaLmQCt3mljveRwKfBuPIOeFM4MpBXl9QAhL
	Nv1ZTO7tZV0uP+bhazKJ+oohpbhXA5t+BtnFWhAWZsCttxgs5UGDBZW6xaH0mGYhML0+Ym
	rq1/Zr3ZfkpQ2079zkAOi8TKNB2SaMY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y53Xk9bhjBTIXj1qHAyuohp/PrZA0avTM6UpmR+cniQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788958081; v=1; x=1789562881;
 b=W0yCmiDX9lZ45zMFQBltGBMWSA+Wryts6ERBRLO/S6rNbILU07JYXG0mSScxOEwveWmFUXWl
 h2FLXjkSnA5y7uOzHkU6zU4pG9zylucwtXGALfVv4BNWXlGUoykT3rkGEihrVyZHi3zpJESRE+w
 /ESESswo9dN7Mf3vU/iLB38A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cd2dbaa2e085f090;
	Wed, 09 Sep 2026 12:48:01 +0000
X-Mizu-Trace-ID: cd2dbaa2e085f090
X-Migadu-Flow: FLOW_OUT
Message-ID: <ec3f14f0-cebe-460f-9df7-537f49d70afd@linux.dev>
Date: Wed, 9 Sep 2026 20:47:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
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
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <76b5edbb-8231-41d0-9e7b-f965af13c324@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29AFE180005
X-Stat-Signature: ct6gn335zic945rdn1t1zzkux7a5jnon
X-Rspam-User: 
X-HE-Tag: 1788958082-557418
X-HE-Meta: U2FsdGVkX19c5pheBbf3t9SOddiJeNL4bPEWtMVqVDc7/e7h98+04v53IMBY58Uv3Fq8RV3YvadkoRexAetZV/K/+8PFwhtvngjZm8IQbC3VmNFfmWE+TxuvgI/MFvLsXino72fV5ps3MeohAoFXSuDAjdOmga9dvOdpJhwDk7EnVKde8/zPs8lajt3lsBuYF9eUzuJOLbDj78CpGIQqj7QR6QAcPg2YPy+Uz10l7p8CHLCvfRQDkfhc78Gj/vrMddFokcXHSWSXiAB9nKzAzCRR8T/YL58HayP0n3HR5tWv1rhfg8o8fy/WXlt9GhPIcolH9mkjcXSC9ulJKmuBOhauiV5iVdD6nI++LaJiJjY1N7mGE8qWH0peuKBs+2vhHHVFh2DPcYXw2IF8XgmJRE3jLg7k/uN2TUaaPvP/vIsimLrVJfQOXrRSKK060zzN1MqPYeh3a6QSOdKnGV31oug5ESV4tX+yVIOb+RM9MncsZNUmIkP7f/a6nZpd/VOqHbDCyuklteV0ogyage31PQI0pCXalLhSoG5FuBfZi6vwGjfrgBBJFRA57u2Cqt0ShZd7zB6vYZe4RqQxsiC+cJ4z/AZEYo2m0JPUhtWeh7K1MyTfrfKt83AJ13BoyKHZyB2UxbNKBKcQIPU5syjp/NPRue+MY5hlterPlG1P/dcJPTnedwrCMYWtMLXpdfzWKIhPSxb6bIqb5YLre0o7cJQlGNk5LyDdlMA0m8oT04vab6a8YuTsSV+VQD0kjuBHZaFpmf+Ktx8oiOEmHiGsq2CXzmpbZDFe770xjFjYnxLZxodYJXTMhsitALD6dujRyD4K1fahocQWPrARwQQHgY8AeT49n1edGH6tZyoR1AJ9358N1JbVfrRN7ue1YUezASfz1hDXul3JSkN7AAYEt/kVnm+ZL3yVzhCbRgLN5EewwQse+ZrIFy2rhMijBHBYA5dIYQuCEudBy24vKZV
 GkED9e0T
 wVa+6oQTehUwvVkII2wJCC9PWK4RbfJy5BXEXgLKIYlspSnJdB7YhEhXnMIgaO0QFApV9U7Ld02GpU71DSldKM3D3MLbu3j4SeUOa1wTCYa85YrMFDM27gwnY1kMBFc1rEfE8AFuQSY+F8sCXjwknU0ryGrCy0n5/NZ7KRp0AyXg8OOQwcciqc5+XvRc3dIaiclQZYcBWYBtCS0ZXssYCSMCxFYL1rL/bTURyNQDGHcA1Q97zhxSvYXoIIqr187WlJoxxcz+S1k1KhQ8//BHk8mxDhofiaMB+Q5en9ZRgsDm54kd7NJtifsvTBC0B6rGjzdEAxokXsEheRmauYlZby75Uxq8GD4x5Sg08E1+co62uI3JufOwbElKEeR/HgjOq4LbPOW9h6874ReiMYTJ3uPDz0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Petr


On 9/9/26 19:30, Petr Pavlu wrote:
> On 9/8/26 11:24 AM, Hao Ge wrote:
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
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
>> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>> [...]
>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>> index 0fc11e45df9b..49190deae61e 100644
>> --- a/kernel/module/kallsyms.c
>> +++ b/kernel/module/kallsyms.c
>> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>>   }
>>   
>>   static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>> -			   unsigned int shnum, unsigned int pcpundx)
>> +			   unsigned int shnum)
>>   {
>>   	const Elf_Shdr *sec;
>>   	enum mod_mem_type type;
>> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>>   	    !src->st_name)
>>   		return false;
>>   
>> -#ifdef CONFIG_KALLSYMS_ALL
>> -	if (src->st_shndx == pcpundx)
>> -		return true;
>> -#endif
>> -
>>   	sec = sechdrs + src->st_shndx;
>>   	type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>>   	if (!(sec->sh_flags & SHF_ALLOC)
>> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>   	/* Compute total space required for the core symbols' strtab. */
>>   	for (ndst = i = 0; i < nsrc; i++) {
>>   		if (i == 0 || is_livepatch_module(mod) ||
>> -		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>> -				   info->index.pcpu)) {
>> +		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>   			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>>   			ndst++;
>>   		}
>> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>   	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>>   		kallsyms->typetab[i] = elf_type(src + i, info);
>>   		if (i == 0 || is_livepatch_module(mod) ||
>> -		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>> -				   info->index.pcpu)) {
>> +		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>   			ssize_t ret;
>>   
>>   			mod->core_kallsyms.typetab[ndst] =
> FTR These changes in kernel/module/kallsyms.c have a conflict with the
> series "Ignore local labels and mapping symbols during module load" [1],
> which is currently queued on modules-next, but it should be
> straightforward to resolve.
>
>> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
>> index 01c65d608873..f64170344e69 100644
>> --- a/kernel/module/sysfs.c
>> +++ b/kernel/module/sysfs.c
>> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
>>   	kfree(sect_attrs);
>>   }
>>   
>> +/*
>> + * .data..percpu has a separate allocation per CPU and no single
>> + * address to report.
>> + */
>> +static bool sect_visible(const struct load_info *info, unsigned int i)
>> +{
>> +	return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
>> +}
>> +
>>   static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>   {
>>   	struct module_sect_attrs *sect_attrs;
>> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>   
>>   	/* Count loaded sections and allocate structures */
>>   	for (i = 0; i < info->hdr->e_shnum; i++)
>> -		if (!sect_empty(&info->sechdrs[i]))
>> +		if (sect_visible(info, i))
>>   			nloaded++;
>>   	sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
>>   	if (!sect_attrs)
>> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>   	for (i = 0; i < info->hdr->e_shnum; i++) {
>>   		Elf_Shdr *sec = &info->sechdrs[i];
>>   
>> -		if (sect_empty(sec))
>> +		if (!sect_visible(info, i))
>>   			continue;
>>   		sysfs_bin_attr_init(sattr);
>>   		sattr->attr.name =
>> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
>>   
>>   	nattr = &notes_attrs->attrs[0];
>>   	for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
>> -		if (sect_empty(&info->sechdrs[i]))
>> +		if (!sect_visible(info, i))
>>   			continue;
>>   		if (info->sechdrs[i].sh_type == SHT_NOTE) {
>>   			sysfs_bin_attr_init(nattr);
> add_notes_attrs() has two sect_empty() calls. Both should be changed to
> sect_visible().


I kept this part unmodified to preserve the loop's original intent.

This loop counts SHT_NOTE sections.

SHT_NOTE refers to ELF note sections, which hold non-executable

metadata such as build ID and ABI info.

I wonder if we could keep the current implementation.

As noted in the comment above, the top part counts SHT_NOTE sections

and allocates structures, while the lower logic handles control of node 
attributes.


WDYT?


Thanks

Best Regards

Hao

>
> With this fixed, the patch looks ok to me. Feel free to add:
>
> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
>
> [1] https://lore.kernel.org/linux-modules/20260820125007.22943-1-yangtiezhu@loongson.cn/
>

