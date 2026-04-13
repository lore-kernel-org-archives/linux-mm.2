Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BC8F34C51
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505CD6B0089; Mon, 13 Apr 2026 09:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD9C6B008A; Mon, 13 Apr 2026 09:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A986B0092; Mon, 13 Apr 2026 09:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 317286B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:03:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE7035643C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:03:07 +0000 (UTC)
X-FDA: 84653548014.23.D0A4F43
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf27.hostedemail.com (Postfix) with ESMTP id C6C8240017
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:03:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776085385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Q6hbO5VXAAEYtqFBS/tjKRelFU1z4l+PdprfQ8isB4=;
	b=WTWQA3U+F8GhAjT9CIqYfsVO2+BcxrbaRbwondAlYKQiDeJfiC85sWT7N3c/VOOhmOAu3j
	PwJofUBT7y2ZBvpseIS4jW1pTzzL6TBo7qsFSFQgIryN9kbw/7qoN3RjTLD4Ub12WAevpE
	Gj7bNCiMRrlWR0+UOlgw/QGQBm+9two=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776085385; a=rsa-sha256;
	cv=none;
	b=1u3Ss/lpsVd8Ly+p7HNqtN0J12axT3cU9O5JgUs2o783rZSAO42AWNWkXwI5jzAXadROdX
	JYqzGTz7MQCXdeg0Peg5s9Z3dr1f1AzT3cHMV5vX3WAEYRO9TAxcKAK/DwKAUzAwo9CYHO
	ljUSCBOO1fLXq0HRvX+RCwASjxhV/ao=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fvSJ26Vzyz8Xs70;
	Mon, 13 Apr 2026 21:02:58 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 63DD2n3P010875;
	Mon, 13 Apr 2026 21:02:49 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Apr 2026 21:02:52 +0800 (CST)
X-Zmail-TransId: 2af969dce97c49e-2c715
X-Mailer: Zmail v1.0
Message-ID: <20260413210252672ZfdcegJLJtyvlYdFAUBlr@zte.com.cn>
In-Reply-To: <adyyNeVTkXQlnh_2@hyeyoo>
References: 20260410120044.031381086@kernel.org,20260410120318.525653921@kernel.org,adyyNeVTkXQlnh_2@hyeyoo
Date: Mon, 13 Apr 2026 21:02:52 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <tglx@kernel.org>, <linux-kernel@vger.kernel.org>, <vbabka@kernel.org>,
        <linux-mm@kvack.org>, <arnd@arndb.de>, <x86@kernel.org>,
        <baolu.lu@linux.intel.com>, <iommu@lists.linux.dev>,
        <m.grzeschik@pengutronix.de>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <dwmw2@infradead.org>,
        <bernie@plugable.com>, <linux-fbdev@vger.kernel.org>, <tytso@mit.edu>,
        <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
        <urezki@gmail.com>, <elver@google.com>, <dvyukov@google.com>,
        <kasan-dev@googlegroups.com>, <ryabinin.a.a@gmail.com>,
        <t.sailer@alumni.ethz.ch>, <linux-hams@vger.kernel.org>,
        <Jason@zx2c4.com>, <richard.henderson@linaro.org>,
        <linux-alpha@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        <chenhuacai@kernel.org>, <loongarch@lists.linux.dev>,
        <geert@linux-m68k.org>, <linux-m68k@lists.linux-m68k.org>,
        <dinguyen@kernel.org>, <jonas@southpole.se>,
        <linux-openrisc@vger.kernel.org>, <deller@gmx.de>,
        <linux-parisc@vger.kernel.org>, <mpe@ellerman.id.au>,
        <linuxppc-dev@lists.ozlabs.org>, <pjw@kernel.org>,
        <linux-riscv@lists.infradead.org>, <hca@linux.ibm.com>,
        <linux-s390@vger.kernel.org>, <davem@davemloft.net>,
        <sparclinux@vger.kernel.org>, <hao.li@linux.dev>, <cl@gentwo.org>,
        <rientjes@google.com>, <roman.gushchin@linux.dev>
Subject: =?UTF-8?B?UmU6IFtwYXRjaCAxNC8zOF0gc2x1YjogVXNlIHByYW5kb20gaW5zdGVhZCBvZiBnZXRfY3ljbGVzKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 63DD2n3P010875
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Apr 2026 21:02:58 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DCE982.001/4fvSJ26Vzyz8Xs70
X-Rspam-User: 
X-Stat-Signature: pdeiuzj86k4twxoxpznyaqerd5qci4hr
X-Rspamd-Queue-Id: C6C8240017
X-Rspamd-Server: rspam09
X-HE-Tag: 1776085384-281516
X-HE-Meta: U2FsdGVkX18ugmCChENvgxROyqJqcGRDRxJJxnnejxz11HqEEWt4WcLxyxSdIq17D1s8b/BucvAO+wLOR81MQbz8nWql64NURBJRitzgywl6mKXcI8A7dk9z3jL2AoXG0RIZvdlBluF17EkwhCsYvt9CdhqR4DHeTNG2McEy8v5ZU1Sk+EcWrTqxtz8f3fd5TWg5mJj9TXOGIiMFWb68N+JaPeVoJlppk5tS3oHslek+XyvIvAfXJcXBASo9JI3PGEVVYrrvl0AuflZx3jKWYenyXub4xcImzNdi2cvHE6RoVUH2e4rwiWUgH/KRJaZHYH+uHq8mkNRY099bUEKPmamGAG6wHEWQImXJsMRWna00l9H1QegPIfgFL1angt+1T63rkXMI7C5yWCByJV+us3Z61ZsLnAYTrSjyz7uVkdK/MhPwf9do2P2PxmiG1trpoQtRUiTKOIOqsM6sQlhNswqAZ0GBkHFZObUKXgg3TKvnb86qzj4NYOs93YYbp86+NpR4nm6lamVVOw4KOLCloELOUpgkPKTcsbOzlf1Z2MTilGS2iY4R7ofXMzp2qRll3p+M7sIykChYAycP3bkB0PstsQy7pWuW2LGu45LKHCim5J5PPOElHfr0jhdHCPf4eQyB4un9/WsU/++KlFfTu9PzBWFlZoaGwzu+L/zM6k0x89Oq9vwcHfvw/8/Xtta12+CBMa8pU94UYeYzPPo2YJibyAvrUAQDPnCT3IBttJ91w0FfccYGat2JhmtaKpwhDQ/90cEoYAxFcOpev+xfrM/K4ydz/3XwvTYPFEoBCHTh/VhM82GbmNHlBHZRTLuVyrT6fIx81uv3PpzxXvW4UWge/J7pl7lN0xENxWBwZIjPBXjWzBFCQH/c0yB3sOD0FBN89P5jwzXv/bpgbkWpj9g1gybRKmMUdx8YivPwftBMVn24Rdevk9Vh2a0Rk9Kr7AMFo5j9DZv4Xou6DEh
 hpDGTi2n
 HV+ShZyxeX+zx35rPHQgb7Hir5hPt0B9+jUfERS9saEPw4tuDBjWnCAcXyQK1IHoecBaD2Jo4OdUwrkROI8+RKnoKLKNMHXFd9gNUjxtoS3zA4QLgGujTv56naMeWlKCNLPUVPOmtRKxTyAoS4BiRhwMTypbtf0xhDMhq8RCs8RPXVs5B6c+RQnXlMXo7k0HbBv1FEjBdUWmNVu6wNqmy9tiqKMi1/YmDIaRB7P/HYQUQEH9QRrKHya4f5iewEUUnurYv/7ec4gNldL4iIXuz5rXfmw5O1kNBhRXNlEGQRwrp9nkullLyDawlACK0IEoQM2RzOvCKDY+rgpJVOU2sTTxe6z/VY+QqHNhkq+OLFdQ41l7y1575+Ukp1yngNoObbUwDTELw+XgdmAO7VcKTiEzoS0fLZbePbKC3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> [Resending after fixing broken email headers]
> 
> On Fri, Apr 10, 2026 at 02:19:37PM +0200, Thomas Gleixner wrote:
> > The decision whether to scan remote nodes is based on a 'random' number
> > retrieved via get_cycles(). get_cycles() is about to be removed.
> > 
> > There is already prandom state in the code, so use that instead.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: linux-mm@kvack.org
> > ---
> 
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Is this for this merge window?
> 
> This may conflict with upcoming changes on freelist shuffling [1]
> (not queued for slab/for-next yet though), but it should be easy to
> resolve.
> 

Hi Harry,

Would you like me to wait for this patch to land linux-next and then
rebase and send v6 on top?

Thanks,

--
With Best Regards,
Shengming

> [Cc'ing Shengming and SLAB ALLOCATOR folks]
> [1] https://lore.kernel.org/linux-mm/20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn
> 
> -- 
> Cheers,
> Harry / Hyeonggon
> 
> >  mm/slub.c |   37 +++++++++++++++++++++++--------------
> >  1 file changed, 23 insertions(+), 14 deletions(-)
> > 
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3302,6 +3302,25 @@ static inline struct slab *alloc_slab_pa
> >      return slab;
> >  }
> >  
> > +#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
> > +static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> > +
> > +static unsigned int slab_get_prandom_state(unsigned int limit)
> > +{
> > +    struct rnd_state *state;
> > +    unsigned int res;
> > +
> > +    /*
> > +     * An interrupt or NMI handler might interrupt and change
> > +     * the state in the middle, but that's safe.
> > +     */
> > +    state = &get_cpu_var(slab_rnd_state);
> > +    res = prandom_u32_state(state) % limit;
> > +    put_cpu_var(slab_rnd_state);
> > +    return res;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_SLAB_FREELIST_RANDOM
> >  /* Pre-initialize the random sequence cache */
> >  static int init_cache_random_seq(struct kmem_cache *s)
> > @@ -3365,8 +3384,6 @@ static void *next_freelist_entry(struct
> >      return (char *)start + idx;
> >  }
> >  
> > -static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> > -
> >  /* Shuffle the single linked freelist based on a random pre-computed sequence */
> >  static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> >                   bool allow_spin)
> > @@ -3383,15 +3400,7 @@ static bool shuffle_freelist(struct kmem
> >      if (allow_spin) {
> >          pos = get_random_u32_below(freelist_count);
> >      } else {
> > -        struct rnd_state *state;
> > -
> > -        /*
> > -         * An interrupt or NMI handler might interrupt and change
> > -         * the state in the middle, but that's safe.
> > -         */
> > -        state = &get_cpu_var(slab_rnd_state);
> > -        pos = prandom_u32_state(state) % freelist_count;
> > -        put_cpu_var(slab_rnd_state);
> > +        pos = slab_get_prandom_state(freelist_count);
> >      }
> >  
> >      page_limit = slab->objects * s->size;
> > @@ -3882,7 +3891,7 @@ static void *get_from_any_partial(struct
> >       * with available objects.
> >       */
> >      if (!s->remote_node_defrag_ratio ||
> > -            get_cycles() % 1024 > s->remote_node_defrag_ratio)
> > +        slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
> >          return NULL;
> >  
> >      do {
> > @@ -7102,7 +7111,7 @@ static unsigned int
> >  
> >      /* see get_from_any_partial() for the defrag ratio description */
> >      if (!s->remote_node_defrag_ratio ||
> > -            get_cycles() % 1024 > s->remote_node_defrag_ratio)
> > +        slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
> >          return 0;
> >  
> >      do {
> > @@ -8421,7 +8430,7 @@ void __init kmem_cache_init_late(void)
> >      flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
> >                    0);
> >      WARN_ON(!flushwq);
> > -#ifdef CONFIG_SLAB_FREELIST_RANDOM
> > +#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
> >      prandom_init_once(&slab_rnd_state);
> >  #endif
> >  }
> > 
> >

