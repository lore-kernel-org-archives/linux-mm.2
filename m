Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6505CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294058E0009; Wed, 10 Sep 2025 02:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2448C8E0001; Wed, 10 Sep 2025 02:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C518E0009; Wed, 10 Sep 2025 02:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED8118E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:25:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 700351A07AF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:25:57 +0000 (UTC)
X-FDA: 83872355154.21.BE6D61E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 25CCF2000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:25:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cg7m3Cy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iOV1+cKr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cg7m3Cy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iOV1+cKr;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757485555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07qaGY/DCprN/vlEhdxbAzLAPCiV8BYCMlpKQ+Zpf6c=;
	b=q2e+yFO1gBuIL62etBjK1rDecOVc+A8Rm6s8xD+rrSZhd5bCVFIpwpvZJDpYShLPu/JVvF
	+Z9totviqocP7hal16zHCBpnR4dqRLuLQlL+Vu/NfNZquAHM5dOGFnJtkfDkBMSQpXyyAt
	qWfj7J7aCkbAAPzpb1pfdU6nl/brNzQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cg7m3Cy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iOV1+cKr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cg7m3Cy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iOV1+cKr;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757485555; a=rsa-sha256;
	cv=none;
	b=5C+oU8oG/hNvnAaRuXVcF3XBY+wqMqKPdukbxdCGnf420tAeeM9POvEQoyvUR+7V+7bHpN
	ApUAvCcpNoDA18EQ/u19h2xLIGe0ebwKSsvDr2VkxnOfsYLdrJ1/M/FCtzi7o6MmKa2iOB
	o103/wyBu6Vk0grVjBWhZB/tx9MG6Xs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EE6A1FB3D;
	Wed, 10 Sep 2025 06:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757485553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=07qaGY/DCprN/vlEhdxbAzLAPCiV8BYCMlpKQ+Zpf6c=;
	b=cg7m3Cy9lqcSL8KvQHQDQh9GETomFJf8ewZhJtCCeIl/vac/IzeKQ+ddS+/G2ZWz+DTaWP
	yBXW8vQNyxTU6zOOjblCyvamhMyhcE8jzspe1ZEjz2j9tCgMnXp79P38bSxNDifAQziIvQ
	UgnOhog1eJRHUlmPjdF5mZWsMaxxVGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757485553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=07qaGY/DCprN/vlEhdxbAzLAPCiV8BYCMlpKQ+Zpf6c=;
	b=iOV1+cKrWknLvHXnlI/NH9f2BFgS0Z3SHytLtfGbf6GL8NIliBSHK3z9Ri1k1WOWqrjoIH
	3RT3PKSYQYMaLJCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757485553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=07qaGY/DCprN/vlEhdxbAzLAPCiV8BYCMlpKQ+Zpf6c=;
	b=cg7m3Cy9lqcSL8KvQHQDQh9GETomFJf8ewZhJtCCeIl/vac/IzeKQ+ddS+/G2ZWz+DTaWP
	yBXW8vQNyxTU6zOOjblCyvamhMyhcE8jzspe1ZEjz2j9tCgMnXp79P38bSxNDifAQziIvQ
	UgnOhog1eJRHUlmPjdF5mZWsMaxxVGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757485553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=07qaGY/DCprN/vlEhdxbAzLAPCiV8BYCMlpKQ+Zpf6c=;
	b=iOV1+cKrWknLvHXnlI/NH9f2BFgS0Z3SHytLtfGbf6GL8NIliBSHK3z9Ri1k1WOWqrjoIH
	3RT3PKSYQYMaLJCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24FF713310;
	Wed, 10 Sep 2025 06:25:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ovcxB/EZwWiYBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 06:25:53 +0000
Message-ID: <ff28f071-f448-4f25-bea0-17db946e0acf@suse.cz>
Date: Wed, 10 Sep 2025 08:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, hannes@cmpxchg.org, usamaarif642@gmail.com,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909234942.1104356-1-surenb@google.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250909234942.1104356-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 25CCF2000E
X-Stat-Signature: hgw8bwne4u86gcw97w84k58scwf9raob
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757485554-864267
X-HE-Meta: U2FsdGVkX194VXeAjTSbLOwr3xM4ZSYseIN2XeoMaL9u9vLRoF+zTiH422Mszd4q/PVqsjPLeegEMCiZqYxfbEaS/GLWHV6p0PA2Xvl0T9xlOXd4Xu1WOc1B3kANUNQtCQl+ZsxhHBVRqrUoc9vmCEYS3WrpSj+GV6CkhXn8haXjbHZr6kKcAHWpFO4it44pbwjY4YCvGBLGbXIE7Du3GF1wfecepD/8RFm9OJa8WtPuyTxfGEx/K6L42TUzwenwl8jw/piISYFPH8snHejW1NwhRwYkCOIkyEPeUXJsU1ZE6gtfv5Aark7WARfrBWLJUVMEOyG2FzCQGrRxG85dP4rsczRnpu//e1WaVQaSJEu/1/UhAP2EMyQ7IovEf0obwAOkSvAoULWSFfKlW1QvaOfnjPwwCW0e6Uw9IDHckOAKJouDAQkJedM/nFY1riKKQF6pdrd9HpvLsAmg3dnxaMwuc9skicCtFT3LeRgvgpqtX3PuujoWMCUKvrCCK9mHbfEJ37RcoPhCdB8d8HftUsfqLTpj87Cpl+/0D25ug2i2ceyRvaNl3VnAwce9xpQF5bo4SqFzBJq8mh4WVbhnICNkmXcEauwn7Qk2lNEa8ayvw3gwLo4Tg8gN/9KPm4XrKn8PLY2rqHhV4zfgPdBpBhiRU0HoU0smb8kNQo1ZyCCx5xccZQ6Lc4NpGm97TyNuMwkyZzmjJc85TzT/d+/JI17rPZBNyKZq4pyJ3zAnivqSHDkKzmIwLhXclQq+hyXXvgFGLd5+y/VsT4opcE5jgwElnovMbSgQQVb0l4YO8qO4lcWJNcbKenL+H01w8JQCpZFUgDtdh6ZsD4r0f25elN5rMhvQS5GnU+XFc3Q57BFcpDMWMqLvN2RlKRLreM3UQc04zhzNyM9FxIRqK6CNYsM4jkVpB85F82Gx5oMFMrfxr0/Dv2x1KJTVbWU/AhMxuZNhRTwzUAdV4CdOD9z
 hFQQ+5iM
 uZSGyo3XVmIfJWOOW0qZ2EEcKA9sSnKArgVDfqfwVUtTeJbRswJceA62/9uAwfmxgYNID5LqklmyDwQ0mLJ9kU4BtvwqwrqUWScasHfQOC+bLDxkVBQL+FmcO+fHxtnAM73UJ/UYJYqs8H4LlB5xOkfZquRfPfMqEAny3ozHWh88Bxr+O1n0bw+iRaDmHeZjleQfCbswci/ZeGQ/R45i36MgcHEQBKmF5i72kkZgw4eSI4N3CWkb6E6tjgwsFBYr4TIl5oc8DLnnxZLnuVKMy7iLGOJ0Crj+bPY7Xh1XJC5/lQZzu8SgKs0T63g6EAve3TdCrURuN8yqilMby8kBfROM54bG6By+N7vuaI1RJIrQ94Bv5PPiUP/+BoMz92HxrtMtoGfIfy9L2eagLJ4+4IrK6hdgxte2hMEyd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 01:49, Suren Baghdasaryan wrote:
> While rare, memory allocation profiling can contain inaccurate counters
> if slab object extension vector allocation fails. That allocation might
> succeed later but prior to that, slab allocations that would have used
> that object extension vector will not be accounted for. To indicate
> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> output.
> Bump up /proc/allocinfo version to reflect change in the file format.

Since it's rare, is it worth the trouble?

> Example output with invalid counters:
> allocinfo - version: 2.0
>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>           0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

Here a link might have been helpful :)

> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
> Patch is based on mm-new.
> 
>  include/linux/alloc_tag.h | 12 ++++++++++++
>  include/linux/codetag.h   |  5 ++++-
>  lib/alloc_tag.c           |  7 +++++--
>  mm/slub.c                 |  2 ++
>  4 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 9ef2633e2c08..d40ac39bfbe8 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>  	ref->ct = NULL;
>  }
>  
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> +{
> +	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
> +}
> +
> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> +{
> +	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> +}
> +
>  #define alloc_tag_record(p)	((p) = current->alloc_tag)
>  
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
> @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) { return false; }
>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>  				 size_t bytes) {}
>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
>  #define alloc_tag_record(p)	do {} while (0)
>  
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index 457ed8fd3214..8ea2a5f7c98a 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -16,13 +16,16 @@ struct module;
>  #define CODETAG_SECTION_START_PREFIX	"__start_"
>  #define CODETAG_SECTION_STOP_PREFIX	"__stop_"
>  
> +/* codetag flags */
> +#define CODETAG_FLAG_INACCURATE	(1 << 0)
> +
>  /*
>   * An instance of this structure is created in a special ELF section at every
>   * code location being tagged.  At runtime, the special section is treated as
>   * an array of these.
>   */
>  struct codetag {
> -	unsigned int flags; /* used in later patches */
> +	unsigned int flags;
>  	unsigned int lineno;
>  	const char *modname;
>  	const char *function;
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index e9b33848700a..a7f15117c759 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
>  static void print_allocinfo_header(struct seq_buf *buf)
>  {
>  	/* Output format version, so we can change it. */
> -	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
> +	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
>  	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
>  }
>  
> @@ -90,7 +90,10 @@ static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
>  	struct alloc_tag_counters counter = alloc_tag_read(tag);
>  	s64 bytes = counter.bytes;
>  
> -	seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
> +	if (unlikely(alloc_tag_is_inaccurate(tag)))
> +		seq_buf_printf(out, "%11lli* %7llu* ", bytes, counter.calls);
> +	else
> +		seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
>  	codetag_to_text(out, ct);
>  	seq_buf_putc(out, ' ');
>  	seq_buf_putc(out, '\n');
> diff --git a/mm/slub.c b/mm/slub.c
> index af343ca570b5..9c04f29ee8de 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>  	 */
>  	if (likely(obj_exts))
>  		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
> +	else
> +		alloc_tag_set_inaccurate(current->alloc_tag);
>  }
>  
>  static inline void
> 
> base-commit: f4e8f46973fe0c0f579944a37e96ba9efbe00cca


