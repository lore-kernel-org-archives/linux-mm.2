Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F837C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814166B009E; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FA36B009D; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D84F6B0098; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0D96B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D55FB14098C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:22:22 +0000 (UTC)
X-FDA: 85045204524.09.431A31A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B3B18000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:22:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OvZ8YvEL;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKND6MQhitky6AK8I8URBuiLbKqrzysrMataDDQjVEA=;
	b=rYR/KWk9CQv9qqXpb1CQ/J/IrVhOn5YUt/qKB7LZVJYAwFMmxHS0+1cVNcvnwO2CBj7QA3
	6mj2LbQ7TsqRXIM09tP48ZZRlKvT9GIsz9+2uNw9mv4dUJByVnv6zXSApRSqMds3i0Gu65
	oj476FeenuwJJKdaNTCEuhvGFGH8kR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785410541;
	b=mg2XuVVHH1hW9eCJCbKpNv7S/6QB+E1mhfi/ugpRaBDlQeJ/A7thPgQCcSjjOZvs+Q449B
	bioc6eRIl9WM/BjLD5iRdB3+MoB0oo8uLBSjHv+tSOQWjDAWfHJUE9DbWUuwZkiAhUuoj7
	Nhr3EmCXXUfMHALdElFVwFCW21p/rnQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OvZ8YvEL;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 30 Jul 2026 19:22:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785410536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TKND6MQhitky6AK8I8URBuiLbKqrzysrMataDDQjVEA=;
	b=OvZ8YvELSC6kq5gZn5UmKYrOkmnr2uti1utheoSblTZ9jCzUsfwb0W/GG5WGKVHatpCuIq
	1CHPTXQ08w3MMgkQ9JsFHANRvDL3XH5dN3fBMpXzUPDQJcqgqpS5ve81v11fVmo5q1HHyG
	fAKp4Odt0FfNCBSm4GYC4qgBOm3GR5I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/13] mm/slab: remove objs_per_slab()
Message-ID: <amszNthftz0OVxxA@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B3B18000C
X-Stat-Signature: gpr58hhf14umoz9bgwfuyx4b7khibmca
X-Rspam-User: 
X-HE-Tag: 1785410539-408594
X-HE-Meta: U2FsdGVkX189MyCB1Tdml3qRqkuxxTGUY7MkTzS7E43NbC1DcZMX1e105mYsWpAmKQh4s7Wp5Vl6EdshOA4QVv5Vepn8lzBbNoBTagL6uzPt5xlxZt9xe6uFVZ7Ca/Zdp02QHwb+WPTkCnD/HgY+4tj/ykM0Bq3CuhioSGi1j5k98KDUkwZy83YjTXkpjv8xoDN9EL8O90ZHI+gDBA6lg6VG5caCO5VXcShDeN6sEeFLDcH3SMIe5xx8AUFOpNk3pkG6onswGod1xeUuOR6XeNO2uEWBYmXqfGgMy/UWmXcz8LlVDuXuZ6S2VRx1NiDoxRKpcDjcZuw7skzm2CzMdXQ5dXs/TZvzTZ/b66VFkK1zSchLHdrl1hwBD+XZabEcfB0bp1f4H16/xSCppMHTxCSUrUvS4wLP74RNGnoW0jIDRkKRGIQDwZanhZWsax4/jDzB3JbPGJH2X+CXbFVZYUtEalKka0ofc0Kswx27dxtmpRv3uk+Xhw1OBXHTcXnjz0LYq29JL7DhyM8O30BdBXhhoN4Prr2zmAG6/5uXqmZM609IpBxhxNuqSjbLHU0vIFQUnt351OtWvxj+EftY6BXfFkRq7eHofMzNpyvqRkW2YddpqfcQL2MBES4lgrGKbv3JYk1CCHI2cYKp1kcbK4n2Q/V1DfzEGo8ah0G7t1V5hxTOaeJxeSyijgMHVlqCRxjD/ch2jt9jpgRxpjSsVMtWK/m/Bg6Q2tC/ptxeGkM4xKcfQx5ET0QmmAU+uZp+HJlhsuqiVyvmIqaE55gs3MIbnYfTeo3DE5kzwaAcRmNVXV8yu1MHXkEAYK+ZJfCKQj6jhqV3CGftEKXjeuel+58mcDcohbyA7X9aKuDeScO8OVZbrOebSlt+ZbXEJoFkEXS9/rtbrrjqkkFsQ8zBT720RxFJGLe4m6VX8B7PNGFIkfSl39r8ZsZrW68gGv9JokmKsd8nGHFedugU8LF
 RlEO/yZf
 +XC6ts1njb48fzSE8wjD8zzzjsqq0uNum+HB6FzBZCbxzOyZSiAZGs1su+aJ4Jmz935Cov3DLsg7Ebm4fKKqEVbhhSArKMYMPcBCb+I0etv+TY+71OUk+eA2AgifhHVdDMes0gzH8uVzOdo8e1Gd801Jjge8Aj8Kp6sFk+Iy3B/w8VX4tqCh0BqlWLFReh21rsgMmp62SsKKDPkp7oZZObBi3zb/ZGR/uDWdhsGQHTY+ibKJ2T9ednULdd2OslF2Abn2Rug00ViEESrKpsO1rvsWv/dC+ljVwwKcGk6sc8y4I7IVIF0/1eNVnsIGgVRA+bdBmRbvM/gDHSgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:53:56PM +0200, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
> to a bit-field" but we don't need to keep a wrapper just for that.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasayan <surenb@google.com>

Oops, the r-b tag got duplicated :)

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index de2d0f7d62b1..9867c03ef0ae 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
>  			 * memcg accounting works correctly.
>  			 */
>  			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
> -			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
> +			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
>  
>  			if (policy == ALLOCATE_ANY)
>  				return alloc;
> diff --git a/mm/slab.h b/mm/slab.h
> index f5e336b6b6b0..01535e1e2d3c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
>  	return __obj_to_index(cache, slab_address(slab), obj);
>  }
>  
> -static inline int objs_per_slab(const struct kmem_cache *cache,
> -				const struct slab *slab)
> -{
> -	return slab->objects;
> -}
> -
>  /*
>   * State of the slab allocator.
>   *
> diff --git a/mm/slub.c b/mm/slub.c
> index d702d273253c..b94482830637 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2130,7 +2130,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  			gfp_t gfp, unsigned int alloc_flags)
>  {
>  	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
> -	unsigned int objects = objs_per_slab(s, slab);
>  	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
>  	unsigned long new_exts;
>  	unsigned long old_exts;
> @@ -2186,7 +2185,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  #endif
>  retry:
>  	old_exts = READ_ONCE(slab->obj_exts);
> -	handle_failed_objexts_alloc(old_exts, vec, objects);
> +	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
>  
>  	if (new_slab) {
>  		/*
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao

