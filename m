Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FB0D59F50
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 22:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2186B0006; Fri, 12 Dec 2025 17:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273076B0007; Fri, 12 Dec 2025 17:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1881A6B0008; Fri, 12 Dec 2025 17:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05E216B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:25:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92B248857B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:25:27 +0000 (UTC)
X-FDA: 84212251494.07.3B5E367
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0165A000C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:25:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P/KZ82Hq";
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765578325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xZuNC1E0nPRDl81t4/ST2owbyreuFV1CYO01fwFdPM=;
	b=snf6rMJgOmulSXeP9ell/ivjSYU3VPnFIufq/lKPk7KqUQwr8n9+FIg5f02MPRmQALCufa
	KSOnR8rhUuqRNQiWnQbp5wn2aYObsWdY6I0Yxz5D4CW7VI3pVSUVEgvUjF1rPqQasl+Rf1
	AO6tnAySdqYFYZc+x/w3pVPKX6jExFI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P/KZ82Hq";
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765578325; a=rsa-sha256;
	cv=none;
	b=2xuL1uJjsL0NA8dqBsufqMKquNRof4tRser9EgowXAYy0w3R1OkAeRjthnE7DesCPiK4OI
	tAigewh2VRp4e7ROir/w3SNdkagkuUX5Z57KY/5y+lTo51DanDbGtZeSeoomTzaI5URVc4
	iSJTuMFA56vq5YEWjnscqqDGj4ogIRQ=
Date: Fri, 12 Dec 2025 22:25:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765578318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8xZuNC1E0nPRDl81t4/ST2owbyreuFV1CYO01fwFdPM=;
	b=P/KZ82Hqr1babxk8ltueZJ3SaxWJ4aQuwLT0FPycxuW432QKkmGwGQfvD2hm7IN7R3Jsxh
	XqhxVesPax45GBPx3p80B3A3htkmGT81fyhA3QEILkpzMzg+iMC+Y1I357GkJk2dLVTZB4
	2IOddnTAXzCQtqT3uWY3/LZqnUf7brw=
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
Message-ID: <qbrym673jqbz4kaqqzhgioh7vhiq55pqdxyvlwgfle5yqlbtln@xjxem4dbwca7>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
 <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0165A000C
X-Stat-Signature: y6rfms4d3y4ccdwi9jq1w6zw6hamje9f
X-HE-Tag: 1765578323-649319
X-HE-Meta: U2FsdGVkX19GVot4ClZNR3Hc2y5wsSe/6WxBkpM8B2KU8mzYpznAwRZENv3s+k9IDmFCoCtCB0KA2crXv1b0sljlckCWZOhm+7cpqKZpeGpERZ1RhQjoFKR/dmhwhxLU3PjlQpiDsCJnB5+MdvAuRrY3S4vb2VMsLr9uDEvps3r30IkNLISG4RVnsP4Q/qMdgUlPNarE/95S0JBoD98NC2qbBpJbRr6IHr3U/w2YLgpDr0KlAKgke6z3XEo47mgeThlJyiNiKdZRMa/KpdOnMbkhsOlSzsPZg2cRedbVz3VJ9n+1G9V/OjgKlzGn+WmWnjl5S/ubBQ+5jbEnG6a6Rb02dgvs1WDqMJk+LvIGCYOViqOY6xzI9kfh2TPI0l4ZFU+oG8dU6tP09gV1h/InW10oA5/C9jQUemdImYjX/uIaG4fwq4nWfMTGOWyfgQxGjMZ7QHs8Fk23XOGNDrHE7yd5whTr9r014Xoouil8bsDjbE8WojzL5gJLx4pYYsi1avRn4FKrLZhWOhXEpPNAd+AC+MgSk726NHTfrnITc0PyBTpg0LdAyAxw+netkkfadbe/U11hapv15GiWrGNwt2OVd+2ilwTMe+DYY5G1hMgJFBoDODW6uVbVCVzauhQ56tPKW2p8j1Nd3sEZx47hKC+KWQTehq71d0wKIe48eyjjeJICnA/qLi7KaplbubZQ7XksQtFdiiDS7BmsZ9WDtS2J0h+X54/R7SVdQydd0Rj0CTm2h4YKK9eVKrgcCE1hxYHP2vvGxZP0+wOjG1IUGXFw4qScPPHncUtTIUstLIuWT+m1+x8kq3Y00pcay2J127NFm250wQrUUiuvCPWb+7Pz8C76a6MJYh8xT/obe0C4BuYN0sAIIRWB4OSoHjsI8TNuGaCi4jWUsSnsj460aCqpSaVuQgYG3qgLlKjK6RjJn3kpO2ZVgjl1Y/r6GhhvsdfcKnomivouM0YsNKV
 /4QMbqhh
 USh2Io4lQpsrfH407/OcPef0OL3i8uZw6gf1fTR4B2XUf9EKHQ5H0IR8fKoVge99D160FR4qJlk3ej18hPClPf+gsxi62Rgx84WGUFwSVE3PhdwfzTCqDNK6/PW8iRlyrrfYqZQwgqF82PYawDVKzgobps7BwXkrI6QePVZMhKjPAn5foPb7IjqDVETQ/c4yXphIkVvhgK5Mn0VsTw8TZ5q7qTRvB6TmPdEge9zNy9R7T8Um6zfp6W/sWz6x1vpPbw4W9HjMxNNWt2fFFZbiXGkmGDkrzKM3z5y6dzFrt7DV0K/0skOCpWiOWPBrQ7ptHb0b8O2hxDfFPxsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 08:53:13PM +0000, Sridhar, Kanchana P wrote:
[..]
> > On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > > >
> > > > >  	ret =
> > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > >  				       &pool->node);
> > > > >  	if (ret)
> > > > > -		goto error;
> > > > > +		goto ref_fail;
> > > >
> > > > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> > > > probably should add a new label.
> > >
> > > In this case we should because it is part of the pool creation failure
> > > handling flow, at the end of which, the pool will be deleted.
> > 
> > What I mean is, when cpuhp_state_add_instance() fails we goto ref_fail
> > which will call cpuhp_state_remove_instance(). But the current code does
> > not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
> > fails.
> 
> I see what you mean. The current mainline code does not call
> cpuhp_state_remove_instance() if cpuhp_state_add_instance() fails, because
> the cpuhotplug code will call the teardown callback in this case.
> 
> In this patch, I do need to call cpuhp_state_remove_instance() and
> acomp_ctx_dealloc() in this case because there is no teardown callback
> being registered.

Hmm looking at cpuhp_state_add_instance(), it seems like it doesn't add
the node to the list on failure. cpuhp_state_remove_instance() only
removes the node from the list when there's no teardown cb, so it will
be a nop in this case.

What we need to do is manual cleanup, since there is no teardown cb,
which is already being done by acomp_ctx_dealloc() IIUC.

So I think calling cpuhp_state_remove_instance() when
cpuhp_state_add_instance() fails is not needed, and I don't see other
callers doing it.

[..]
> > > > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > > > *__zswap_pool_create_fallback(void)
> > > > >
> > > > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > > > >  {
> > > > > +	int cpu;
> > > > > +
> > > > >  	zswap_pool_debug("destroying", pool);
> > > > >
> > > > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > &pool->node);
> > > > > +
> > > > > +	for_each_possible_cpu(cpu)
> > > > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > > > +
> > > > >  	free_percpu(pool->acomp_ctx);
> > > > >
> > > > >  	zs_destroy_pool(pool->zs_pool);
> > > > > @@ -736,39 +766,35 @@ static int
> > zswap_cpu_comp_prepare(unsigned int
> > > > cpu, struct hlist_node *node)
> > > > >  {
> > > > >  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool,
> > > > node);
> > > > >  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool-
> > > > >acomp_ctx, cpu);
> > > > > -	struct crypto_acomp *acomp = NULL;
> > > > > -	struct acomp_req *req = NULL;
> > > > > -	u8 *buffer = NULL;
> > > > > -	int ret;
> > > > > +	int ret = -ENOMEM;
> > > > >
> > > > > -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > > > > -	if (!buffer) {
> > > > > -		ret = -ENOMEM;
> > > > > -		goto fail;
> > > > > -	}
> > > > > +	/*
> > > > > +	 * To handle cases where the CPU goes through online-offline-online
> > > > > +	 * transitions, we return if the acomp_ctx has already been initialized.
> > > > > +	 */
> > > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > > > +		return 0;
> > > >
> > > > Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> > > > then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> > > > that case?
> > >
> > > This is checking for a valid acomp_ctx->acomp using the same criteria
> > > being uniformly used in acomp_ctx_dealloc(). This check is necessary to
> > > handle the case where the CPU goes through online-offline-online state
> > > transitions.
> > 
> > I think I am confused. I thought now we don't free this on CPU offline,
> > so either it's NULL because this is the first time we initialize it on
> > this CPU, or it is allocated.
> 
> Yes, this is correct.
> 
> > If it is an ERR value, then the pool
> > creation should have failed and we wouldn't be calling this again on CPU
> > online.
> > 
> > In other words, what scenario do we expect to legitimately see an ERR
> > value here?
> 
> I am using "(!IS_ERR_OR_NULL(acomp_ctx->acomp)" as a check for the
> acomp being allocated already. I could instead have used "if (acomp_ctx->acomp)",
> but use the former to be consistent with patch 20/22.
> 
> I cannot think of a scenario where we can expect an ERR value here.

Yeah maybe do if (acomp_ctx->acomp) and
WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp))?

