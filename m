Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E12D59D84
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1686B0006; Fri, 12 Dec 2025 13:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51736B0007; Fri, 12 Dec 2025 13:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40766B0008; Fri, 12 Dec 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABC786B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:43:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AE071A0297
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:43:47 +0000 (UTC)
X-FDA: 84211692894.19.0557C4F
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F43D1C0002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1ADOYHl;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765565025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkoC9XWWPULzArIPL3U+sa96HBni49Kt2rCzkNlq5t8=;
	b=8I5rF1jO+JDI4iOIEW0nqxFafy/BDPaOyFcbPRv3EQMziiCAt8y5iPJJEZgfPd2vzzNQpX
	WzsNHI51Ubc9g63DqOVz7meTTCxK4yLKfR1YcELz8Y1NQSfnoxYmmCMd+8g/sEowc8CA00
	gHViBsyl1mNgFhiLt9fyplnyVv6A9xM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765565025; a=rsa-sha256;
	cv=none;
	b=reqp7Hb6/EdaSr/CHAThjUz9+7UsEi1ZZ3XSDjnfYsTHuP610ooX/afq/ADhqqu/dHGYlI
	9vCUoW95TbyP6lHjQvb69fHIF2powUvfljE55cZp4MFDSxNWtutT1tKSGj+de+63Xa4LH2
	zxxcUk88YgEWCnei7T1A6bSFXu98SN4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1ADOYHl;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Dec 2025 18:43:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765565022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkoC9XWWPULzArIPL3U+sa96HBni49Kt2rCzkNlq5t8=;
	b=R1ADOYHlub0M/KbSRdIhf2T3VCcTZxmsBlp3fmVIgDnB7ES/8Mw38pY+Qt+KmtpqY3IO5x
	BOFAg1tfc8BxdsoGt4SpVEMUFCTU1MABXowIbbwvKUI579zeH9UthNlKEF4BCi1FzBxZrT
	l51kTl7BM5XwHYt5sC9AUzJz2YyjWzw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ridipsyqf9q5n9196on1gytwpqz14q7r
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F43D1C0002
X-Rspam-User: 
X-HE-Tag: 1765565025-24389
X-HE-Meta: U2FsdGVkX1/FU7R1/pcaKjhxTGiZCdZLYoh4LIRloxaGllKOQ4Q2a8i2YWiX4+WixaH/L7IQrj1WyiCU6QMwJOEQFs96ayrT3de8nowviLC1asSs1byCfq2oykoFGu3ULgoBEyvqzkBPnbuC2x0Y6n2ebb0yTK3aUP2GT2dgj3wGDbPqS8tEpaNZqExdnLDUh67FsWS9Cs1oke9R6Z9UfFmT/ebG2aIv6zNEYxbIJA17kRIBGbc8rQBgorThd9XpL5EsZY5qE8h6rou38kvPyVZjKU8/p1vS478yop9jmCOY6dPC+II1ytjNENDn79gI9QU2GHAXx7eS5tbxZAyJY+jpfJyM9avfY3lbN6ngte/mmIgvLwSxslShbr15wVUzTapoal1+pdBveW4A3Us1QG3XG3x8T3YUV1NWWoX5c74MbrLVktzCb7NuQcTkqEGWI9WpybbrcjNfADVJ6Z6xLTLmpyGFzEwq2+07L7UfUHHFHqm5TwAsUHlFFfPFh8CgRiRkrfB9CwCVoA8ftPm03Ni4GcYNJEn9rjaa2D2rC4hP8SWIjsb0UKrzJ7uRP0OsU6DrLgABuh3uS5Rj6Vly1qOkbkVywS0rARam89ZjyuqL0hvc2YI0FOtUW2eMUU/9lji/UNJsp1qZe7ntiXAuZPelbk14GIbrUcoxIm3IDzHBDoqIKxdYClBUTc18p6qXYUGbrkw3jb6KcUy+ZHa2am0ktEHWbzCDx7ZoWK4tqs9C5aG+8Rf/lGFh1rJKVlBhFDuEPXoL7HYvIIkbNgN6aJ+yNFfi0y7i4Xqoywkdm6vu7dcpvmSG+6Fw+bwziwMQpOtf1IFtNzfuDgDbIQMVletJP1aP7NopG8e0So5rDFIVsMsU+CLxvezQ2doPSVbZYHTzcNXiuWEUzwMPVoSxKKqZDuQtbHk/JGNAVsJ9mw6raUUIYZymWC9x6zfuAYNSpNRQB+y5vYicLlJ0wf4
 aidMlKJ7
 Xo3mE8UwY+6zcno4fWueR2vuFkHKmOXLx0uTO6wjJHZiWdnKvNTCYN2Em955t5oBjEvICUi3gPLkkwvn+Ar0HRENWpDhhySIDBUZRDkG5sG+F+AHMpoGo/Jpe69ut7jBWKAZMSIXaNKkqa7rFyv2LzG5nutodmQkvKnmNJKrkb9vk/XyBTBEcSSJnrwkSEXeQmyAEowImYaOEWO8JXPHdU9suqmmxenqITH3SLQPqRTClDbco8owmIEvcPg17MGT4AX7hzUwQ0dcKExTE+ZqYZigu/oX7ZidTRWE6+QTGHOj+h+Edg3UC3o/JS7vZz0e+gfoDsINg/RQmNWY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > 
> > >  	ret =
> > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > >  				       &pool->node);
> > >  	if (ret)
> > > -		goto error;
> > > +		goto ref_fail;
> > 
> > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> > probably should add a new label.
> 
> In this case we should because it is part of the pool creation failure
> handling flow, at the end of which, the pool will be deleted.

What I mean is, when cpuhp_state_add_instance() fails we goto ref_fail
which will call cpuhp_state_remove_instance(). But the current code does
not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
fails.

> 
> > 
> > >
> > >  	/* being the current pool takes 1 ref; this func expects the
> > >  	 * caller to always add the new pool as the current pool
> > > @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char
> > *compressor)
> > >
> > >  ref_fail:
> > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > &pool->node);
> > > +
> > > +	for_each_possible_cpu(cpu)
> > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > >  error:
> > >  	if (pool->acomp_ctx)
> > >  		free_percpu(pool->acomp_ctx);
> > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > *__zswap_pool_create_fallback(void)
> > >
> > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > >  {
> > > +	int cpu;
> > > +
> > >  	zswap_pool_debug("destroying", pool);
> > >
> > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > &pool->node);
> > > +
> > > +	for_each_possible_cpu(cpu)
> > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > +
> > >  	free_percpu(pool->acomp_ctx);
> > >
> > >  	zs_destroy_pool(pool->zs_pool);
> > > @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int
> > cpu, struct hlist_node *node)
> > >  {
> > >  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool,
> > node);
> > >  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > > -	struct crypto_acomp *acomp = NULL;
> > > -	struct acomp_req *req = NULL;
> > > -	u8 *buffer = NULL;
> > > -	int ret;
> > > +	int ret = -ENOMEM;
> > >
> > > -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > > -	if (!buffer) {
> > > -		ret = -ENOMEM;
> > > -		goto fail;
> > > -	}
> > > +	/*
> > > +	 * To handle cases where the CPU goes through online-offline-online
> > > +	 * transitions, we return if the acomp_ctx has already been initialized.
> > > +	 */
> > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > +		return 0;
> > 
> > Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> > then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> > that case?
> 
> This is checking for a valid acomp_ctx->acomp using the same criteria
> being uniformly used in acomp_ctx_dealloc(). This check is necessary to
> handle the case where the CPU goes through online-offline-online state
> transitions.

I think I am confused. I thought now we don't free this on CPU offline,
so either it's NULL because this is the first time we initialize it on
this CPU, or it is allocated. If it is an ERR value, then the pool
creation should have failed and we wouldn't be calling this again on CPU
online.

In other words, what scenario do we expect to legitimately see an ERR
value here?

