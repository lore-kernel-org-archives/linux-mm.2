Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C76CAC5BE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 12:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDD98E0005; Fri, 26 Sep 2025 08:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E798E0001; Fri, 26 Sep 2025 08:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435E38E0005; Fri, 26 Sep 2025 08:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED9F8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:48:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3454BAAC5
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:48:19 +0000 (UTC)
X-FDA: 83931379518.04.D338E1F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3FC18140007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:48:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W7XDtirT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zPVE3V0R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W7XDtirT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zPVE3V0R;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758890897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jnr4Kn8GWP5TG3It+qgp1kqMyJPwqj/59ydFZ9RfHEA=;
	b=K4GXOTsjnMX0dg5F41gREcgNOwtyWtabHIPqLWwuB4ST+i72hmofVWy9LD2mG2idUGDKfl
	oEU93DSQYKAmRFmefMW1cEFb9lXkeROO+FNqy3RaPWkR1nvLotr4x2K6eVOgZaRH4STJMY
	PMmVOEl11CpN18c3fHCu+EsV8cjftJc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W7XDtirT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zPVE3V0R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W7XDtirT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zPVE3V0R;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758890897; a=rsa-sha256;
	cv=none;
	b=J9cTMblkX21kkXYIuX7HX1h886agM5S07pRAakCl0Is48ElJjAL4GGdGdOtzJMx18EgKCg
	l4TEx7T5q4TSxP5aejS3TDc8AwJfRP0sKSYtwLHrhnLwHnRuHRp6nQvVfuG/OjFY3VWnFI
	gocEtXZoFaR4E0kbTTNclL8NRXmTUmU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4BF9225A58;
	Fri, 26 Sep 2025 12:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758890894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jnr4Kn8GWP5TG3It+qgp1kqMyJPwqj/59ydFZ9RfHEA=;
	b=W7XDtirTEal0lLHBXekgCOhjOvVh2Gy4Sw38JnDjLek/8kOXspyn+yJvGSrUKN6vFSWXP+
	7FD/24u+Z8MhyfOoEQ72KOyisudi87ACrzQlzS5jOl/Enk91Dyauyc72/BtSXpG4RspesF
	8WxPQvsP1VSKW7oGLMEalGFM98YYqoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758890894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jnr4Kn8GWP5TG3It+qgp1kqMyJPwqj/59ydFZ9RfHEA=;
	b=zPVE3V0RuAFATmAp+zqCpuCYxHVFCyflTiq4KJEY2hZXL2c43UdngPbuofutxafa4JeUAM
	4f5G0mRWxydManDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758890894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jnr4Kn8GWP5TG3It+qgp1kqMyJPwqj/59ydFZ9RfHEA=;
	b=W7XDtirTEal0lLHBXekgCOhjOvVh2Gy4Sw38JnDjLek/8kOXspyn+yJvGSrUKN6vFSWXP+
	7FD/24u+Z8MhyfOoEQ72KOyisudi87ACrzQlzS5jOl/Enk91Dyauyc72/BtSXpG4RspesF
	8WxPQvsP1VSKW7oGLMEalGFM98YYqoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758890894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jnr4Kn8GWP5TG3It+qgp1kqMyJPwqj/59ydFZ9RfHEA=;
	b=zPVE3V0RuAFATmAp+zqCpuCYxHVFCyflTiq4KJEY2hZXL2c43UdngPbuofutxafa4JeUAM
	4f5G0mRWxydManDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3420D1386E;
	Fri, 26 Sep 2025 12:48:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5eFoDI6L1mhjSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 12:48:14 +0000
Message-ID: <96d00a94-1a4b-4378-8d89-0554f89778e1@suse.cz>
Date: Fri, 26 Sep 2025 14:48:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next] alloc_tag: Fix boot failure due to NULL
 pointer dereference
Content-Language: en-US
To: ranxiaokai627@163.com, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 usamaarif642@gmail.com, surenb@google.com, shakeel.butt@linux.dev,
 hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ran.xiaokai@zte.com.cn
References: <20250926080659.741991-1-ranxiaokai627@163.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250926080659.741991-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FC18140007
X-Stat-Signature: jfjoz1jgbqhd9kuggas6w41edpr58ger
X-HE-Tag: 1758890896-247768
X-HE-Meta: U2FsdGVkX1/r7WjPYT9EfJQKSkHEg8qd58rXyMWmt/wttwXANjmDE3tlzHm0QyEULyFU1AkIZT3gEcO6ZUng3oW4NBMfooxgJswUX0qWpx5ONvERepM+qx7cD/3Vvl1NM3kqiGJoNndfQRYr52/BboNjaRZikpDlLFKOlAP+E6pe2EMn+0cKUNOQal5htZPuFwGugP7HzdzVEn6o6Ut2j1+HBocSEXIieOQCOg5/blMH8oBCYbQK5FR5rlvUBZoOQDQ8BOffRd7k/3UTXqVmNS1Fo0LILfWYZNyBVSpXKpvPLBY+9dJxAMwIUYMxPS/hDVe51izzNduHyQJnqpLBP241eJElQREuQkEfRv0JDXaFvGawLhn2EzDKr04ZteCgM/QQ82TDSNmdYLqcb8x/fhnuS1/7Ej33emxTySgujLcHjE1AfU6zHOvM7mkZnrabOD+XYxVLnc1FQ7AkO6I4h0J4C6dPqRnEZih3K6MgfI1u/x62IWqAazoKK+TXLlCSRvpYwQmwnYg6iJyxkRipnFEdZWemOI1zpFiZHZ/vLNkk/DKfjzsDGP7az5QJI/tR1Q256RZ/5DHChrXTPhvAh+opYLcbURSvYeoR94RjWjDOvzEYNFi3txeLhFTML+SNj9EI0xm5neXuphymOUE/jovgfwf7u63Az3RN0SxZG3MCTL1kmH6nvig8fQPGo/9mBXJ7iX8baun9rtivpeuUlimjMfHhbrsEtGbe329CfTmJ3NJ3m7JvtdfetMYebjKHMJbgY4EnJCdQj03cgCCnCvURa9OXfDQv0/ZLo/px2ztppbRvDVR/0NnULyY/FOmwNJqE66n/JtF6AHtDYHwodL2N9XI1iTfy2qWx2yp/L2H9bMkdkL8MpAz3+QSr92P0VnO+Iqo3UFsEG4t+AL92WgzNdsTS8GY1hwTOvEcVxYDUrEr0QpUwGZWeJLNNC/i5+KFSub9o3VvyaF1OuU4
 gM6yQqI1
 JMjGhUEFVTkXFeqL0Q5f5sDOahuPJB8Z541qFLjbbRYSdK2xDRBLBukBGsq8YiA4JolRNIgHPPkv2M9CqrjAiS+54NRx8kt1anu6gO8qvx40C62c2C515QAjkRarxhwCBgn85NiPWJsSL5D3YJirFS9ZiRxRaXavewVJvBkTMWq/TrUKOTwLFEy1jZ2bJoquF8xlmgCdYt6Vm8BbAWQu+CInyqAFyy+1TkPS3Jv2X+zgdJ5agdVDP/GjQzsGq6z57GVEJ1Ors7Tm0N8AYgBIvg6eNMjH00MWhzrWxM3O1iPma+KPJp7sHLydQYkbnKaLT7qZSAPiSO3soBLF76lM5rLkC64FutEgnbDSSpZax662Bk17zFqcEderEZTS+Y78GtFZD43wJgrPQYITiHsuyHVGlZb8T/FG7rc0n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 10:06, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> There is a boot failure when both CONFIG_DEBUG_KMEMLEAK and
> CONFIG_MEM_ALLOC_PROFILING are enabled.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> RIP: 0010:__alloc_tagging_slab_alloc_hook+0x181/0x2f0
> Call Trace:
>  kmem_cache_alloc_noprof+0x1c8/0x5c0
>  __alloc_object+0x2f/0x290
>  __create_object+0x22/0x80
>  kmemleak_init+0x122/0x190
>  mm_core_init+0xb6/0x160
>  start_kernel+0x39f/0x920
>  x86_64_start_reservations+0x18/0x30
>  x86_64_start_kernel+0x104/0x120
>  common_startup_64+0x12c/0x138
> 
> In kmemleak, mem_pool_alloc() directly calls kmem_cache_alloc_noprof(),
> as a result, the alloc_tag structure associated with object_cache is not
> defined neither initialized. So current->alloc_tag is NULL,
> leading to a null pointer dereference.

Agree with Harry. This should be enough:

"as a result, current->alloc_tag is NULL, leading to a null pointer
dereference."

> Move the checks for SLAB_NO_OBJ_EXT, SLAB_NOLEAKTRACE, and
> __GFP_NO_OBJ_EXT to the parent function __alloc_tagging_slab_alloc_hook()
> to fix this.
> 
> Also this distinguishes the SLAB_NOLEAKTRACE case between the actual memory
> allocation failures case, make CODETAG_FLAG_INACCURATE more accurate.

Good point.

> Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")

That's in mm-stable so the fix should go there (probably too late to fold
now) if it's to be in the merge window PR.

> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/slub.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 867a07260acf..09cbe580842c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2197,15 +2197,6 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
>  {
>  	struct slab *slab;
>  
> -	if (!p)
> -		return NULL;
> -
> -	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> -		return NULL;
> -
> -	if (flags & __GFP_NO_OBJ_EXT)
> -		return NULL;
> -
>  	slab = virt_to_slab(p);
>  	if (!slab_obj_exts(slab) &&
>  	    alloc_slab_obj_exts(slab, s, flags, false)) {
> @@ -2223,6 +2214,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>  {
>  	struct slabobj_ext *obj_exts;
>  
> +	if (!object)
> +		return;
> +
> +	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> +		return;
> +
> +	if (flags & __GFP_NO_OBJ_EXT)
> +		return;
> +
>  	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
>  	/*
>  	 * Currently obj_exts is used only for allocation profiling.


