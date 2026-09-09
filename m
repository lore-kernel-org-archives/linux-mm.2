Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A22C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162816B008A; Wed,  9 Sep 2026 09:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115AC6B008C; Wed,  9 Sep 2026 09:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001CF6B0092; Wed,  9 Sep 2026 09:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C94B16B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:58:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64747401F4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:58:01 +0000 (UTC)
X-FDA: 85194377562.17.9918A06
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F6E840004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:57:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=A1nUe5b0;
	spf=pass (imf07.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDzlPxqZjAat9RI0uZbVqWCVCniwXqMbYrmH3owuOfY=;
	b=2fqT2tk7oZYUB5tm0oV4e2wqa6PQAEWrGNNTDZyYdDYjC5AIyvP33mUhYSdufIRVUOW4wS
	NOPPk2JMDPjoMxHuEDkrFzxY/qcd6gtZv9Sf6j7I1tgmGS1uQbRX0Ba1FIQbRA0lTP9d++
	jObcZhxIENJZ4t6TvZ0HJZBVcHynX6g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=A1nUe5b0;
	spf=pass (imf07.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962279;
	b=dG9nKUeif7geuWcGbDsZjp8nX/W+vAk1Meaoq6qIIIznk9OiRwAoFpBb9GvZcw0JrG4g/f
	Wavgx+8xD21fw5dRu1UYIwnqK7ImLe06ixEw00zv5lU9qQdSUZfstE5y6EfPeqUxResQoF
	aq6gvDdJT1lD0/MGE4CKh3cXWC0Uod8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4956869750eso52268645e9.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 06:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788962278; x=1789567078; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDzlPxqZjAat9RI0uZbVqWCVCniwXqMbYrmH3owuOfY=;
        b=A1nUe5b03iPIcCgy8b1+qxtWU0N8Zj90pN9iCdVmC0EUP9iJUnbCgK7tnXayLkYZBr
         e+63Z5TtMiTPRReUoCzDY7vnS7Zr7sE/K7QjiaYGr52UkRKNMEOnS+697BREQbCxH6xa
         iBRIAxPL6jSE/DndLnGDUWD8VorC6ki9OfD7Y0QdqYdzBDm4+oQYLQamKgJvuW+8sXil
         KhaZfbV2ETux2KM1ZLsxRcLWspbvEEUG2ksBPd7x5CxSJuKBJCtIXPWjN+I427F+T6VR
         M9O8xEP+CMnZ2V0imzGXf+kMHDSX/Hl1vYRZtgJchLRHIX1GaaS9m2zGJ0+LE29TVsI/
         eWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788962278; x=1789567078;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDzlPxqZjAat9RI0uZbVqWCVCniwXqMbYrmH3owuOfY=;
        b=AT/ZVJH5jQFahSKjYGgfLpQ7rAC2z0F5kkr+fGNs3Mh/++r9qB32UFhj23OptZIYgf
         zvlqs+QiGNJbZc1OM/YAXXUAvpXSPkBQ58nvEXRSACnl2eExXuJb9HpOu030MkjcfYge
         NB6J/HWXHj7ST7fLyduOCdBZYXxpa19ALhSKUu7dB1+ed9H2aKccSVWu9Ie8v09ybKem
         YxHP04kAne9vciqCcHRj8EBTD/xHv5/udRR6AlD9hcctl2HQZFHX/p/bBfm7c2mRQU2I
         Kejop2YWhir9anccjlGMWSyV/TIvzq9UGOCJ4UrPJxD5oVvjMhi/wY45ZNF6gf9ZKe5R
         OhtA==
X-Forwarded-Encrypted: i=1; AKwUvByn3X2iqC0aDDoGONsAly34Wxng0Z9t0ZoGJIa0zTVo0XonLKd/EWsHNmHGx1emy/g+vCAhRvgomw==@kvack.org
X-Gm-Message-State: AFuF++kUwrM0ddhceInlo/00YJMVFDQIVOA4EQp6ksDdW97jnZF4dQ+p
	yxcttUxhutw5Yx4o4fQqW1AUh8pH8S8MAuqt3E74OMzFk7Yi3cv3/bSdj+uy5qDwQTI=
X-Gm-Gg: AYBFou0Pnh/YEo63nxPglU3T1mJtGsDJDnZ+e0ZM5Rk37N76N9eKsEc//1TgIcDQXj2
	GighDHb8V8Ew9t46w2O0f7hP940by9+VvBNVONY8YGXGSAcoF0Njjj0wCP05fKx9qG2lWF+BYW9
	BjeJlu5AxtFovlJWCUA0+QtSWEHBx7CJW7pdEAhfCloFr+OdqoTNevClwabNUIVjbHV6ngBeJOc
	2OQkSkURpIcg8RCRj+l8LL03wDHzjk/W6hfUitvRawifJLI1+IUXReRFIuQRhqrurdqPCc6mptf
	/p5/vcPn999XPO4fZ3MQaaJjjsbG/K2ouZvxxjizozMdr6PHw+ibz6oBMAAymXmK51rTK3cdWxd
	VsGpRhixxnT60mAg4Aku0HTTLROjpxa3Bx1lAg+hill/rOHHINTjbJ5bQnXvBjXRmFj/roXhNED
	UxgO/Qrzw9HoSVXe0BbNYQaW9wAVkwBWLi13XP4DXhh9j+Uw5HgWMW3NAqTjFCicOTLnkDNvMi3
	6anwlUR6AnPaMQreL8i71AvBPbdhrsFRs0=
X-Received: by 2002:a05:600c:5247:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-49cf81dadcamr328595095e9.2.1788962277576;
        Wed, 09 Sep 2026 06:57:57 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7736132sm466320805e9.12.2026.09.09.06.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 06:57:56 -0700 (PDT)
Message-ID: <3bd2f451-cbe4-4ef4-a552-81ea227fb15b@suse.com>
Date: Wed, 9 Sep 2026 15:57:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
To: Hao Ge <hao.ge@linux.dev>
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
 <7dbba23e-5530-43c4-9c44-20108cd0cef5@linux.dev>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <7dbba23e-5530-43c4-9c44-20108cd0cef5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F6E840004
X-Stat-Signature: eoba76h19j9xp5mxkx8484fd1ki5eo8e
X-Rspam-User: 
X-HE-Tag: 1788962279-982933
X-HE-Meta: U2FsdGVkX19MOOV3NE/gC0Inz0cEv4BVu6tfW7vbk7Jy1GyGP08Yd1pWkzOob4HOqT3BKrEQXPNIeG+l/uXny6XNiBl0JycHYi4YvQwuzzsrt4nQUxUnvdO3o8HAc5NxDk9FskoU/mClnvAchppiV3ehvJgZdGSExb3bO8SJkTedXk1um/dDZ+PWljvNCjj0HPqXtMnmg4E1MWT6Vry9g7bjCM6lgW1lsBYMhT6goQ7FTvXVeND778KdF+37SihLX8yhrLFA0d6oHQdyp5Ms34d4cGQdi3AuxTTU5fEdbOh7GhXg3XcFp0C+Lr80UejqZblG2+5ziCqgx9faUq1fmSFa58nWDbshzi8hWLr67yP1maip7pTQp473VH7afuS17fJu/UcT3AgX5Nt51EN258v8hpokaQhlfsiaUWq01ciC8qIrv5pIwVavqiXIG8ESUipwKAOPIFBeS/Tw5rksqBzvVtfNr8bQ/+ykPVtki3yJro/rP7+cQGzL0KQE2/IiQZQ54DMer2tcg6CKN2pIf6pTyM55Rf/9/shcf/vyzD0yRxxuCE2WIXw+RLw0KAYPNpU0WpIlrsX3ICafPEhv2L5kSJoOuJ55ozvQL9CXZWOG23iE0UBcovzIqKCroMD5sdeJVOk1O0KJBMtJ1mA2+qxqROkkBMAFloX1y6OzaqWlmC/ayaiLUKFU76kpoGdaM2r3f96IWEeSwPVW9p40XKUp3GucwBjrcHPuPRwFZJrNWPuaFCHArTBe+DMi0JV9STqTIQztvUfEdR9kEYC2VIYKIrziNpvGR97taRf7k5SWmWuhJ9PrI82+daDw1vSVPMy8Qde44yuElOLH3n4+qF6Oo/pFJhshEr2NTgjBZjFtBFKTQevuRN0UsCLgqArpyo7yTl3eeRI7huhrimORuy92fM5e4kRUL7qSDq85Hy9zHLAPG9MoysNNNuxMCzJkcCllAK5kngi4MeJG4eP
 pVkB3uwr
 Dv0G3wa0tHpANWkxzg1+dtS44EYmcZIO/RPNNDmvEGZoKEuNmgiyrYuRCKv7jQ+Ti0QWjRIS6v4rX1Dph8shVtSxiaBoL5pdPIwZtMAS7mPzKsm9Q4v1helM0619d7LIcjKEXcg3nZe+g23Ecws0+ThhW6yY0nmcKPuCbZ6Y7vZqBc3J3zVLWOJsJ9ymxeLw+vuX5gougXV795z1fYtELTFil3EMQAU8waz5QSN4J6j0fkP1Kavve6se08vTdjbKSV7LPoCt67sMzOnVxGCv9rvIy4m0IX2KLxWloira8JwKplpHY06E/IQbyk3/a6Hx2Z8zEWLnJ5YZYgnJL/QNJigTeMmeLCMle0xmIrTMLQk1uGv2aYueVpBlFqf+c2pAMx0AXuhIDFLeWWiZSUpvXkKh2pvNg1OF8JKmRZaxIqy9IRALWr/cWv4QV4nEU/9gUTM3H2wZ4hWJdaxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 3:08 PM, Hao Ge wrote:
> On 9/9/26 20:47, Hao Ge wrote:
>> On 9/9/26 19:30, Petr Pavlu wrote:
>>> On 9/8/26 11:24 AM, Hao Ge wrote:
>>>> SHF_ALLOC means, per the ELF spec, that a section occupies memory
>>>> during process execution. Some module sections occupy memory
>>>> outside the regular module layout, for example the percpu section
>>>> with its per-CPU allocations. The loader currently excludes such
>>>> a section from the layout by clearing its SHF_ALLOC, which
>>>> overloads the flag with a loader-internal meaning.
>>>> apply_relocations() needs a special case for the section, and
>>>> find_sec(".data..percpu") returns different results before and
>>>> after layout_and_allocate().
>>>>
>>>> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
>>>> allocation. The percpu section is its first user. layout_sections()
>>>> and move_module() skip marked sections, and apply_relocations() goes
>>>> back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].
>>>>
>>>> .data..percpu keeps SHF_ALLOC, so it would now show up under
>>>> /sys/module/*/sections/. The section has one instance per CPU and no
>>>> single address to report, and the entry never existed before, so
>>>> skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
>>>> array and skips it too. No functional change otherwise.
>>>>
>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
>>>> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>> ---
>>>> [...]
>>>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>>>> index 0fc11e45df9b..49190deae61e 100644
>>>> --- a/kernel/module/kallsyms.c
>>>> +++ b/kernel/module/kallsyms.c
>>>> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>>>>   }
>>>>     static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>>>> -               unsigned int shnum, unsigned int pcpundx)
>>>> +               unsigned int shnum)
>>>>   {
>>>>       const Elf_Shdr *sec;
>>>>       enum mod_mem_type type;
>>>> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>>>>           !src->st_name)
>>>>           return false;
>>>>   -#ifdef CONFIG_KALLSYMS_ALL
>>>> -    if (src->st_shndx == pcpundx)
>>>> -        return true;
>>>> -#endif
>>>> -
>>>>       sec = sechdrs + src->st_shndx;
>>>>       type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>>>>       if (!(sec->sh_flags & SHF_ALLOC)
>>>> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>>>       /* Compute total space required for the core symbols' strtab. */
>>>>       for (ndst = i = 0; i < nsrc; i++) {
>>>>           if (i == 0 || is_livepatch_module(mod) ||
>>>> -            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>>> -                   info->index.pcpu)) {
>>>> +            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>>>               strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>>>>               ndst++;
>>>>           }
>>>> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>>>       for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>>>>           kallsyms->typetab[i] = elf_type(src + i, info);
>>>>           if (i == 0 || is_livepatch_module(mod) ||
>>>> -            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>>> -                   info->index.pcpu)) {
>>>> +            is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>>>>               ssize_t ret;
>>>>                 mod->core_kallsyms.typetab[ndst] =
>>> FTR These changes in kernel/module/kallsyms.c have a conflict with the
>>> series "Ignore local labels and mapping symbols during module load" [1],
>>> which is currently queued on modules-next, but it should be
>>> straightforward to resolve.
>>>
>>>> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
>>>> index 01c65d608873..f64170344e69 100644
>>>> --- a/kernel/module/sysfs.c
>>>> +++ b/kernel/module/sysfs.c
>>>> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
>>>>       kfree(sect_attrs);
>>>>   }
>>>>   +/*
>>>> + * .data..percpu has a separate allocation per CPU and no single
>>>> + * address to report.
>>>> + */
>>>> +static bool sect_visible(const struct load_info *info, unsigned int i)
>>>> +{
>>>> +    return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
>>>> +}
>>>> +
>>>>   static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>>>   {
>>>>       struct module_sect_attrs *sect_attrs;
>>>> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>>>         /* Count loaded sections and allocate structures */
>>>>       for (i = 0; i < info->hdr->e_shnum; i++)
>>>> -        if (!sect_empty(&info->sechdrs[i]))
>>>> +        if (sect_visible(info, i))
>>>>               nloaded++;
>>>>       sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
>>>>       if (!sect_attrs)
>>>> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>>>>       for (i = 0; i < info->hdr->e_shnum; i++) {
>>>>           Elf_Shdr *sec = &info->sechdrs[i];
>>>>   -        if (sect_empty(sec))
>>>> +        if (!sect_visible(info, i))
>>>>               continue;
>>>>           sysfs_bin_attr_init(sattr);
>>>>           sattr->attr.name =
>>>> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
>>>>         nattr = &notes_attrs->attrs[0];
>>>>       for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
>>>> -        if (sect_empty(&info->sechdrs[i]))
>>>> +        if (!sect_visible(info, i))
>>>>               continue;
>>>>           if (info->sechdrs[i].sh_type == SHT_NOTE) {
>>>>               sysfs_bin_attr_init(nattr);
>>> add_notes_attrs() has two sect_empty() calls. Both should be changed to
>>> sect_visible().
>>
>>
>> I kept this part unmodified to preserve the loop's original intent.
>>
>> This loop counts SHT_NOTE sections.
>>
>> SHT_NOTE refers to ELF note sections, which hold non-executable
>>
>> metadata such as build ID and ABI info.
>>
>> I wonder if we could keep the current implementation.
>>
>> As noted in the comment above, the top part counts SHT_NOTE sections
>>
>> and allocates structures, while the lower logic handles control of node attributes.
>>
>>
>> WDYT?
>>
>>
> 
> Sorry, I've reconsidered this. I think changing it to sect_visible would be better.
> 
> sect_visible stands for the count of externally visible note attributes, so the code
> 
> above and below can align with each other.
> 
> 
> Sorry for the noise.

No worries.

One problem with continuing to use sect_empty() in the first loop is
that it could overallocate the number of required entries if a module
contains an SHT_NOTE section named .data..percpu. That shouldn't happen,
but we can trivially avoid it by using sect_visible() there as well.

Using the same condition in both loops also makes the code generally
simpler to understand.

-- 
Cheers,
Petr

