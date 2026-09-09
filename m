Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3781C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B218B6B0092; Wed,  9 Sep 2026 07:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83CB6B0093; Wed,  9 Sep 2026 07:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999E36B0096; Wed,  9 Sep 2026 07:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 661BB6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:31:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 088661201A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:30:59 +0000 (UTC)
X-FDA: 85194007038.22.1BC6CC1
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id E05E01C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:30:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XgKCuKjH;
	spf=pass (imf18.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788953457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3GAQaN4MUpmSo4Q7ZsJl4/HQ5mDsQes7kEJFp9ImSA=;
	b=1k3NpvUNa8B4Uw/8nilQf9KQOqIqAQxBPhJeX1YF2Q+5iWLsvlDW20OInXb9nYgyXLEjsK
	3Z/8EWZsQNAA71ezk61A5y5z4F2IYWlDpJFIY0jlqqZXFGzfEVvf4XzPrlEz+6hMJM9LG+
	0M294a8D/A4awWpQKIqqWvw11TTLsPo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XgKCuKjH;
	spf=pass (imf18.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788953457;
	b=dGrsrAXDXrxsp/I+IwMgD7uhZr2a987W672lkeZXvbjWVa7+4cbfqXOY4bQRdqhSgYmaRh
	P5ejDJ0iPN/8XsIyn+A4M8ZguqquHygmBz/g3MID1vrboKXLy70JMRU1WDkV2BULa2FhUW
	ptWaA07G2vvYB4/cYyPAhZ6vpH3L4RY=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4843e397f74so5926800f8f.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 04:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788953455; x=1789558255; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S3GAQaN4MUpmSo4Q7ZsJl4/HQ5mDsQes7kEJFp9ImSA=;
        b=XgKCuKjH6s8FzrBIAb58cJqBMDMlygkOyQwqImcJYYbIz8cvdn0j3oBsv9D48qh3TC
         jum4R2R8Cw+cZUVWujvKTC5CpBjHrBmJp8FlV92iDi4eUKn9Or2uGgTe0ShCiSyvBtLQ
         /50iLctTBEK134z9GME+pe7cKps2NwwhAgRS1JMhFvZPHsuLjNghNGziiWbVtzu9P/1N
         M4dj8n17gYKdiumkRy/gDzG9g38fwvSTQyXHZhszdgZ/gcp2j48dg9kUFAN+4IdkZMyB
         c5rDFyWt0qwIPOiSKCd9wFlsebQdot+b8bHjWkdyPzAsyd4L1wtVylxfTiBka5GedHlX
         HvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788953455; x=1789558255;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S3GAQaN4MUpmSo4Q7ZsJl4/HQ5mDsQes7kEJFp9ImSA=;
        b=DIMlnC/bNG3uHlViWDfjERbG2Z14/5L/J+FDQEfq7qdUrEPK+4tYIHS32d2ZOZdc43
         zsHTcFcDHOZ5Sh7ywIf9Khe/HRfAKr6xU88Yk0zUf9FyQNVmXVWomndnOSiz3NJB3MEX
         dk9BhscQ0SBohabKjz1C/1splmpUQxrkzDx0Dz1ySDpBp56azNGDTimkcuzvbLm7zJaZ
         gpOW0ZMGli50yGZb4xzDSUsuP6nu8rlZYuOOzWHC6nbtbXvOOvcYEX/fpLVSqH9TEJGH
         4r5DMj0Ypj+P3gJCqs6Ly1hYLmEcbZ9TEAwy85lfUKg7heA8rgAI19bUZxiGSjO4x0WW
         rjpQ==
X-Forwarded-Encrypted: i=1; AKwUvBykm2PkX+UJwQ/aJvJcGHCyhlo5PJVSt9hdi7jFMb+pL+9q4t/r7L7bYyZl3k77TIFzG0D0HKccNA==@kvack.org
X-Gm-Message-State: AFuF++modQe3g1yJ7c4mi+SSyLYQ8eK0cQvtFrIr5lxWjzur6+CmsmN1
	u7iDX6IEisXYKr0XxmkBQr2/r38J1PV7HLZGwpWqnUUI+bBdewsBR9cF/OMC+khsqzA=
X-Gm-Gg: AYBFou21JbGbtIPfJ3EOLgvjBfw0SacUSYXiDr2B/iisCVwZbXjAVNdP1Fb0YzvFwtz
	XaQJEFcH6XA6xU1my2oDuVr1UfKqv4VIXzvngSLY8fFsVVlKOAjiT+Ah607RqJqw7CbhAa1EWjW
	bwJKykZkD+oXO1wtXY8opDZc8UY1mWz2ugDJa96Z5WFYsdERVcYFhPem1gKHanFxO5OW5R83m1A
	Q3HZM+gsjrJauc4fMyjhoepj7wPW3bpt24k2i8SYdWCFiL3d6hqd2QzxLE59OEL5LjfSkVU+miQ
	2foPT2pN/NmxSH1jz+zuIv02TF728tNUuLR0yziyb5OSIkoilyhYxfABEymD3Y/m9UMTyI/XLFa
	k938x1PCWEWjJjaAIpPG9WRRV+XPUEpvnYG2Ohspf9ORhwgZ7dBKbsNSC6H+mCHJ7wjZMju3dZY
	poW2BTAiMTBFNVbRWuSozMIpAHE/UoT5owFJjNVm7CjMIi5VF4NXx2g9nsCbOvsbLO2QZbQukNA
	VbPQM+wfG+LYVmuNVsatLlHgIPNSop/mBo=
X-Received: by 2002:a05:6000:25c8:b0:485:caa9:87f5 with SMTP id ffacd0b85a97d-485caa98937mr892423f8f.14.1788953455145;
        Wed, 09 Sep 2026 04:30:55 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883927a3sm33609875f8f.11.2026.09.09.04.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 04:30:54 -0700 (PDT)
Message-ID: <76b5edbb-8231-41d0-9e7b-f965af13c324@suse.com>
Date: Wed, 9 Sep 2026 13:30:53 +0200
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
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260908092412.115953-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E05E01C0002
X-Stat-Signature: a73rkgazgnd4gnik7bgzfkkqsa4uegmj
X-Rspam-User: 
X-HE-Tag: 1788953456-354649
X-HE-Meta: U2FsdGVkX1+BrGlVsfl0I+GMnl3PAnOeMsZN2VtIf9PpSTDwh8ZSKxvT7wHza1Kr05AwoqsA9BmeSXVxZG2bvi3iltal8wqjwocD7K9u/A/Iu/IjSEjhZ7745UlFIRma9uv0fp1bjICWlwWTEO+qtMGKjlqGo0SqgizFUoEskE7yyaPk0A7RSxWt6impyuIzs6a2S7lo1T7G37iFGV+N5jOMnQWsJXOaOz+KI+EHi7HIHRan0RvDEom9QGHQrLxrFvOjbiZKEvkvo74iA/fiu+R/2AhrugVFH3Huds96gMztTAVgpcj/3YRkNcsanv1R8ITbg+EkW2h/+ZBNVeZatbC3+rxvk4nJmMNudU6mD/F73Ewhx1ZoLcd0C7Qf+JTWJUvFaOK0G9J9L1i9HRbV30EJsfaPYPX6CwI4rUjMhkadhDu6tQYa0s+I3ybLUPuzF+CCRvLhiIb/JfiuFHzKvTuAHt4qQhHo6YxIvbyweA9xw0Ntu5xXhIeKGxqe3l4hOX3DlnqncNrVXSDip3co1R0pTvxUzR4XwgRgxC1mDATd9/bATtWTidBwUS46aw329795jF8MFu2KPJ1Cff5AUXY7W2hjlYJN8bAwyLoxRp2/Q+ZSX3O9mLRPi5rHK6lrOhR3YGm0f+YRmsWYk4GhLwlTKz9viJwQD5+9HifzBvIdWMWMXd7/ebOsPRMd/1im4dIHMXBlUaOxTDN4iXRNsVlUHntNuMOGMHYxE5T+J0UHlouIwnWC8WSIBu1qAaXDXxi7tsAJZx85L1x3QYAv7ZslqL1HwNZE2AfMe+A8h7J1BAweWvL2Jlv5053JHBjXpghwbf0cG1O3urcWZRzdP0NKrfhpHmS+D/t7+XI2MDnqpPScM83Sm1vpZUwS+x7u2e5f8bcdyUJ0bUyBwuBwJ26pR+Kw2H7JBYQDsK/R314Q+/8hpvKc4IEQq2njgJOwYsKFoFHmaSi/2+B2ESP
 QluvZDmp
 XtWOihg+mcv1qVaYO7PddKfWCyadbFlj/EnZN+gab8lw7OaPP7a2eQ7Jk8wC4lAIdUbXEh9CMfm6qaCrmYvOX5pvZJTiM+UxoAveK96VMT6W42WjJeC75tBYv8DGw8ON0SxN+sX+ul+koK3jaq6NfOTYXEqcW5nBIaiRiEfXjkjkT5+lxUfhMVTQQoJzi/1CBx5gWXd4+e6M94sbrjZLhNO1hpb6QoE9lUm8Bky0w/b/FkHVfKemWACwUmwMZv09uqi5sh1flz7GA517VWaVJwfDugKunYzBjBNRyliQ1aa64Enh67D4W2DcsThCPIS72C5g1zfj6AA5r29L+OACMz81uR09ilTpSdnMoKhdlSqpUsrfBeCxUbAKKlWKnfkvdwH5TsePBATcqQDKyfc1vryxRUecv93EaNFBivn3BliC51UuolRTSU668wl3n9uAa7EwXBS1QmGHajtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:24 AM, Hao Ge wrote:
> SHF_ALLOC means, per the ELF spec, that a section occupies memory
> during process execution. Some module sections occupy memory
> outside the regular module layout, for example the percpu section
> with its per-CPU allocations. The loader currently excludes such
> a section from the layout by clearing its SHF_ALLOC, which
> overloads the flag with a loader-internal meaning.
> apply_relocations() needs a special case for the section, and
> find_sec(".data..percpu") returns different results before and
> after layout_and_allocate().
> 
> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
> allocation. The percpu section is its first user. layout_sections()
> and move_module() skip marked sections, and apply_relocations() goes
> back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].
> 
> .data..percpu keeps SHF_ALLOC, so it would now show up under
> /sys/module/*/sections/. The section has one instance per CPU and no
> single address to report, and the entry never existed before, so
> skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
> array and skips it too. No functional change otherwise.
> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> [...]
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index 0fc11e45df9b..49190deae61e 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>  }
>  
>  static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
> -			   unsigned int shnum, unsigned int pcpundx)
> +			   unsigned int shnum)
>  {
>  	const Elf_Shdr *sec;
>  	enum mod_mem_type type;
> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>  	    !src->st_name)
>  		return false;
>  
> -#ifdef CONFIG_KALLSYMS_ALL
> -	if (src->st_shndx == pcpundx)
> -		return true;
> -#endif
> -
>  	sec = sechdrs + src->st_shndx;
>  	type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>  	if (!(sec->sh_flags & SHF_ALLOC)
> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>  	/* Compute total space required for the core symbols' strtab. */
>  	for (ndst = i = 0; i < nsrc; i++) {
>  		if (i == 0 || is_livepatch_module(mod) ||
> -		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
> -				   info->index.pcpu)) {
> +		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>  			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>  			ndst++;
>  		}
> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>  	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>  		kallsyms->typetab[i] = elf_type(src + i, info);
>  		if (i == 0 || is_livepatch_module(mod) ||
> -		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
> -				   info->index.pcpu)) {
> +		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
>  			ssize_t ret;
>  
>  			mod->core_kallsyms.typetab[ndst] =

FTR These changes in kernel/module/kallsyms.c have a conflict with the
series "Ignore local labels and mapping symbols during module load" [1],
which is currently queued on modules-next, but it should be
straightforward to resolve.

> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
> index 01c65d608873..f64170344e69 100644
> --- a/kernel/module/sysfs.c
> +++ b/kernel/module/sysfs.c
> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
>  	kfree(sect_attrs);
>  }
>  
> +/*
> + * .data..percpu has a separate allocation per CPU and no single
> + * address to report.
> + */
> +static bool sect_visible(const struct load_info *info, unsigned int i)
> +{
> +	return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
> +}
> +
>  static int add_sect_attrs(struct module *mod, const struct load_info *info)
>  {
>  	struct module_sect_attrs *sect_attrs;
> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>  
>  	/* Count loaded sections and allocate structures */
>  	for (i = 0; i < info->hdr->e_shnum; i++)
> -		if (!sect_empty(&info->sechdrs[i]))
> +		if (sect_visible(info, i))
>  			nloaded++;
>  	sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
>  	if (!sect_attrs)
> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
>  	for (i = 0; i < info->hdr->e_shnum; i++) {
>  		Elf_Shdr *sec = &info->sechdrs[i];
>  
> -		if (sect_empty(sec))
> +		if (!sect_visible(info, i))
>  			continue;
>  		sysfs_bin_attr_init(sattr);
>  		sattr->attr.name =
> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
>  
>  	nattr = &notes_attrs->attrs[0];
>  	for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
> -		if (sect_empty(&info->sechdrs[i]))
> +		if (!sect_visible(info, i))
>  			continue;
>  		if (info->sechdrs[i].sh_type == SHT_NOTE) {
>  			sysfs_bin_attr_init(nattr);

add_notes_attrs() has two sect_empty() calls. Both should be changed to
sect_visible().

With this fixed, the patch looks ok to me. Feel free to add:

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

[1] https://lore.kernel.org/linux-modules/20260820125007.22943-1-yangtiezhu@loongson.cn/

-- 
Thanks,
Petr

