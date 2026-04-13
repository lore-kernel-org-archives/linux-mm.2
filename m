Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBABEBFD1C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D83B6B0089; Mon, 13 Apr 2026 05:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFA96B008A; Mon, 13 Apr 2026 05:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F176B0092; Mon, 13 Apr 2026 05:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49F106B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:07:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0F66140D28
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:07:06 +0000 (UTC)
X-FDA: 84652953252.27.B440F58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 36F3E1C0002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:07:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3inY+8J;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfV+dBU9VPBYhioDWJ+nyjtSrTDypvBAP7vxHXh2p4I=;
	b=MhY2X2cVdHJE5GNlroKStwIrez4/wPtc7DFVGH+R5+w2nmBmBa4Px5/B0qc3zji2cELxci
	PMtrsalSs4sZLy7xkzNE41rXwZCVX+BA79DhkIme3mQpqyVNQ48EF+MDjFx0bjO09kGedJ
	uOeBbOQDramiyeGX3r4VahpqPfLKs2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071225; a=rsa-sha256;
	cv=none;
	b=2NEzg+o/Ow+sl6VT71RqK+vlLRKP3/ZrIVbZsri1MQVkHq/rDJ6W4nHNQo6WXJLNuZe/Ys
	yU5Zgl8Une8+3Kor9zaVJpYcKNimsI7GKVXjB0Av16p3Ho4WQgrQXHrbkjTvXaihG8hjVT
	lXbQzbnTW2WI/fg2aSOxZPqzPme2NKY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3inY+8J;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21BFF43A69;
	Mon, 13 Apr 2026 09:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C51C116C6;
	Mon, 13 Apr 2026 09:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776071224;
	bh=cS2/Y+fD/C6Fj1LtxcJRcP0gMiu198023wVz+PX5eN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G3inY+8JxkEibVwYUFszuCWlat+2WMkdb9cxQNukGQ5jOO4YosRVw/teIPjzkykJe
	 VBaoK4GWe1nSvdZccXGItvVBbCBawDxBQYXoSn8ku3lctCl78nWa1bXrv8Cz5ii5WC
	 gS594pXSn/PDkAlQW1x8pf1/M/IPGL/2AZ9s3tUP2y+EEht32F5HbttQfHidlVLFR9
	 SB3RrQSSOyCGHY83n0fRRZdud5Xcyx9d8MmEOZogxSk4gxdYZjmVHZxvo/hzD3ige5
	 KqFGmCdWJVKzfE5LlEz9DNkdZh7AXZJZD7MdmFDUG+6QJAH+W76oJ0Vl3ycqghmmEe
	 IWEm9rwhj2q9g==
Date: Mon, 13 Apr 2026 18:07:01 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>,
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
	linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	sparclinux@vger.kernel.org, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shengming Hu <hu.shengming@zte.com.cn>
Subject: Re: [patch 14/38] slub: Use prandom instead of get_cycles()
Message-ID: <adyyNeVTkXQlnh_2@hyeyoo>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.525653921@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120318.525653921@kernel.org>
X-Rspamd-Queue-Id: 36F3E1C0002
X-Stat-Signature: ctkzhase4zybshntqxsqquw5ym4mejmc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776071224-922411
X-HE-Meta: U2FsdGVkX1/z3F059TUKGTK1oCU4461RB7TPl/9cQDgKLHxRybCsNsL7uBxVQR+ykOKhymkmke9vpKzsMJ960mwJAGZXQxEefQr0azWX4KlmhLlpM0Jyc/ybSWzcz7Ah+1SpZ2cqq031wlCnQOUkPl6rIh4p/Nt9ly9T/dtCly9vPdD3VOqH6v4t+/a30+c4f4dIxmyQcilbiNXiEYZ0FGBRbA1YJNQn3Jc96k+fnbtP3zxavy1fGYyjbKlNLpDgNj70f3VTSEXiw+n6YLUzP+dwvFh4a2uud1mkuv6V4MUBJp4/woUEuSBEoXW+4hzPXfoQaF56SUvq3hTjkdqHE1x/a61OPyxQA/55PedV8TzKtSYQ/F8wYIDvQ4PH2FNGtun06rfGt0tYyAT6U1X2Kkx6XpG0Rq6UfCN78lNR2ylrW/V+iYmRPOyLEkxiWysVDAniOIQ7Hy1cMYVQuhVAhuPPoVcSEG61UN+yL1EyXhwQ6BdYHAUaaDsGmMmkyti942Lct6hcRH8zsXV87uezHIfvylQeWT/m7PKPtuADul9PvnFwLnTD92qYfqwUIvEy0BIWGBZFfanLrHJpnawOZfKu5arSpKL7zoL4H1O4lvQcITglE5aGZ1CVVnscOx5YONk+qjy4tnVlKo2eJDpM5rMdPVJLjKqHGPlCSzJ7y7PPCNCX56bG+k8bQSF3wjp+Yf38leIPiTmET35ZbSRuSJOUYVMI2hItwk+TO3ehgEk32AolxuwBjvEAia1awoNmcGslY3MJlZLsGQFmS4ATCjGkwo5Hsds227airCwv+8nH77SB+KTLLnh6rqtljMuoxflvIoLgNsrs/i4fTuOMzsnFNvGJqyjfTqrU5FapXN8QnVhp1yqDFdwa/ElnAUdnBa1FNkJIS06YgXhat4ThCXEo9kd5YeeEuF4DQeR3zELJQ8dE7kPvWerHKVXrTfNDkkU1etihIMr0K7B7x3Q
 0Q4dh4ne
 RDF/bRtFCYBrgypzNhgIwFZNFEvJ9OEf2W5zUPB9WwaiQtUmgzCIt7FM4TldCmTgzoP6zWiLZ9HvHb0+zDgHlzykfQPP8xSohMS8fwA4bI7roHECUCjaoiL2N5xViCNdKISDZmdChnZ/M77G0b+HlIpT1KkisweotQI+bpke62Sj4HL0VARJJUsVb88PR96ti97Fm7fkHgcalWTK3vq8z5sM4Ldac7768p+kVIGZKqgBXKzNeRQVyUVO6O3QuAeYLb1mBZVgdSk2tXlK7LxoLzDVgkzp90UWcJv/GW++0EdaFZ+0VxA8+tWpU/4zsTMxlqYvYlQv3C8/u//NKbFb1go/1gF66lYF9XECghldWnsO4Vbclovrfqt1T0AQRKtGvD9cIGEoFtc9lspnpy+lsaItrr0ppfwB29/dFFYhJx2NGoPb+PK8zC5UhwFaXCSUn30owZQKF9BFmdfpcPj+booKaLwIfLnFWy+w0Ky0y7EQPJHWux4emN7OC5pqNc86ikW20
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Resending after fixing broken email headers]

On Fri, Apr 10, 2026 at 02:19:37PM +0200, Thomas Gleixner wrote:
> The decision whether to scan remote nodes is based on a 'random' number
> retrieved via get_cycles(). get_cycles() is about to be removed.
> 
> There is already prandom state in the code, so use that instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: linux-mm@kvack.org
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Is this for this merge window?

This may conflict with upcoming changes on freelist shuffling [1]
(not queued for slab/for-next yet though), but it should be easy to
resolve.

[Cc'ing Shengming and SLAB ALLOCATOR folks]
[1] https://lore.kernel.org/linux-mm/20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn

-- 
Cheers,
Harry / Hyeonggon

>  mm/slub.c |   37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
> 
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3302,6 +3302,25 @@ static inline struct slab *alloc_slab_pa
>  	return slab;
>  }
>  
> +#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
> +static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> +
> +static unsigned int slab_get_prandom_state(unsigned int limit)
> +{
> +	struct rnd_state *state;
> +	unsigned int res;
> +
> +	/*
> +	 * An interrupt or NMI handler might interrupt and change
> +	 * the state in the middle, but that's safe.
> +	 */
> +	state = &get_cpu_var(slab_rnd_state);
> +	res = prandom_u32_state(state) % limit;
> +	put_cpu_var(slab_rnd_state);
> +	return res;
> +}
> +#endif
> +
>  #ifdef CONFIG_SLAB_FREELIST_RANDOM
>  /* Pre-initialize the random sequence cache */
>  static int init_cache_random_seq(struct kmem_cache *s)
> @@ -3365,8 +3384,6 @@ static void *next_freelist_entry(struct
>  	return (char *)start + idx;
>  }
>  
> -static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> -
>  /* Shuffle the single linked freelist based on a random pre-computed sequence */
>  static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
>  			     bool allow_spin)
> @@ -3383,15 +3400,7 @@ static bool shuffle_freelist(struct kmem
>  	if (allow_spin) {
>  		pos = get_random_u32_below(freelist_count);
>  	} else {
> -		struct rnd_state *state;
> -
> -		/*
> -		 * An interrupt or NMI handler might interrupt and change
> -		 * the state in the middle, but that's safe.
> -		 */
> -		state = &get_cpu_var(slab_rnd_state);
> -		pos = prandom_u32_state(state) % freelist_count;
> -		put_cpu_var(slab_rnd_state);
> +		pos = slab_get_prandom_state(freelist_count);
>  	}
>  
>  	page_limit = slab->objects * s->size;
> @@ -3882,7 +3891,7 @@ static void *get_from_any_partial(struct
>  	 * with available objects.
>  	 */
>  	if (!s->remote_node_defrag_ratio ||
> -			get_cycles() % 1024 > s->remote_node_defrag_ratio)
> +	    slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
>  		return NULL;
>  
>  	do {
> @@ -7102,7 +7111,7 @@ static unsigned int
>  
>  	/* see get_from_any_partial() for the defrag ratio description */
>  	if (!s->remote_node_defrag_ratio ||
> -			get_cycles() % 1024 > s->remote_node_defrag_ratio)
> +	    slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
>  		return 0;
>  
>  	do {
> @@ -8421,7 +8430,7 @@ void __init kmem_cache_init_late(void)
>  	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
>  				  0);
>  	WARN_ON(!flushwq);
> -#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
>  	prandom_init_once(&slab_rnd_state);
>  #endif
>  }
> 
> 

