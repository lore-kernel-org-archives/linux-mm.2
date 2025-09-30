Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895AECAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 21:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6728E0005; Tue, 30 Sep 2025 17:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9891D8E0002; Tue, 30 Sep 2025 17:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5448E0005; Tue, 30 Sep 2025 17:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7803D8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 17:20:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AE9E13BDF3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:20:15 +0000 (UTC)
X-FDA: 83947184790.11.503EDFA
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17CE140005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:20:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FY0PNyHq;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759267213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mzu326cqpYeO7fWTGs5mPCqPumIlFr85HHArv1knXAc=;
	b=16y63Hy5C4Xd7aWhaZeMs3t5Cp6k3ibZskJxVEz+p4ymllysrdYl0lfeo1IbNPbElZtkSX
	pRJD3f+54em28xI/pCcTVvRSHbAOtd0BIMZU77ovcAAxt9nHGH/z22XrKCzpmpzW8oErLi
	pfaQKkqvD5bD5o8h+9en93IZZdBhRbI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FY0PNyHq;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759267213; a=rsa-sha256;
	cv=none;
	b=hHEBKus0ChJsEzOSoneLweZRJIcGG1Fhi2h59R7ZryXNQATdhTDwMZxPT72qSV1iv12P6w
	dzH72tZqOZAmzWBIjjnAGyDGKjGt1pbbzGNEz6FxSXBG5fBljiMlZXaLHPn3agtl2xx/N+
	xgTXOiKFihpQSzRdqhUOt++br15dEI0=
Date: Tue, 30 Sep 2025 21:20:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759267209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mzu326cqpYeO7fWTGs5mPCqPumIlFr85HHArv1knXAc=;
	b=FY0PNyHqk4kCMExHmQ4DRajuSV7mgjXP/hgcZ3e5aVQEJ81fqX5XBJTMFcji+kCkkjKjNq
	98hHbBacOuhF48l+YLxv9yKqUdY1Umz8Iia/aCdhKN2b8lN+RqIJ0oijcl5R9880D6PAvm
	T6JenFCqUNnju4FYX5sJlU7M/xRLdTY=
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
Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <6xb7feds424kfld4udwmbtccftwnnx6vmbpvmjcwlionfdlmuj@vz4uzh6tog5g>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
 <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 17CE140005
X-Stat-Signature: wfpfg8qrmy9gciqkkrmx6fuxwgd5u4kj
X-HE-Tag: 1759267212-538761
X-HE-Meta: U2FsdGVkX1+0NNTBCceYvneyXgMt7q+Zw2B4Fru+2ggRk1kugUIdtq5hswnWmqFrTGA8nkaM4RC9ggkVREoTBJAWX8TZZyz0nk0ERnvNv6rZbh1C+/7jompxbT+CJ/2kQOrn62ehNmq4AYAH33JFEcLAjAFCEmrLsf4Rz4CWH/vrwoVgOhgtKargPMeQddB9yE3WVhrN/9C65Q57lKTYXkZ9pWwrSAY4X5k/Im5AgMFQyZ/YR2hYDWHznuFWVCxq0r7f/0vyinmmSGuqOZsipAU0Qs2xPVrcmQd6ZAdOfyspaQ4ocPUzb3t5l9WjQy4kOjk4IJipfhinpiBG0EFLi0vmN8etKrpQpUPgBNgIdM3yf5spOKf/Y+IAyhxp8wdBQKrXeSZV3dSvxqZmIq8t5tcnzR/DuDgIMv+TDZOmWvikaF5poJLm6lWt+UGPlOvWlLtA95YfzNN9t72TsuL3e/n1l+PseomkHqZ9/bWrjCiRKhBWO9GFVWd8EhoKo4OUXuhYwKfj8kskV0KVVsAvr+ZcCckXnjatz9EhZOGNWk+22XmGM2O9a71YcO8PX8tb7E31rSsaeIznCw17RAAQUyq+yMSIr9VEiUEgq92eDBXFLQRtAhd/jsK3x9xxp4f5FZiWe0BD2+DpCjoYa095DpIz8tTDd2p4NuN0V0dIKwiJgWIeGj8s4Wwi56C6xtbHEPqXnvVJpLwavlLThmkMD4U/aWcZYMdc2jbll6l8t2O8gIyg9+w26EU/5K28kcum8BekDGcvFWhEX/g6cPOKnffDvKhcCqwVlKXEyUyek70pFHppZhZA4NM8a+P229YT/heUTCjn6Va/m2cH+yi9iBv8u9ZEsVQ2JRUnFHwpmfStFXhINBq+exxDw6jhd7QCvKoe3yEU6KFadAGYTZ6HD8IExEH2xNxZUN2d7TnnfvOb58XkLrzpZPV1dmxS/WaO1BJXYUJiYzAG2wkvbO2
 viiwq2FL
 8LIxixMGAYLH1ENYPbBoBG+rJtJicfL64gyi15jMf820PznAFc5RaUAxn5WYLfq/FZ/9fTmhPRyX7xQiAY+sxZwfwWxWoDlX49e9f4TM01alcET+X1muTZwMbz0GZ2gw059vXFkVenot3Syuhp7KPFJRbuWRROGG7rLogwmHzuntJP0NF55T1M4ONaz/fUS/W58+8BUK+xQducs3PT6IuiXIiA2jGh2U8qM3M9WBtyxYHLJ9nzdi1eIqyxT371kl9AhPWuPowR8xley3rS9O2NLgnRA8HXcN6mVVGzWGFWzhscgKA0juiEZ2yzB6XMR8ZVninx7aWBRYKX/k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > > > >  {
> > > > >  	struct zswap_pool *pool;
> > > > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > > > *zswap_pool_create(char *compressor)
> > > > >
> > > > >  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> > > > >
> > > > > -	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> > > > > +	/* Many things rely on the zero-initialization. */
> > > > > +	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
> > > > > +					   GFP_KERNEL | __GFP_ZERO);
> > > > >  	if (!pool->acomp_ctx) {
> > > > >  		pr_err("percpu alloc failed\n");
> > > > >  		goto error;
> > > > >  	}
> > > > >
> > > > > -	for_each_possible_cpu(cpu)
> > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > > > -
> > > > > +	/*
> > > > > +	 * This is serialized against CPU hotplug operations. Hence, cores
> > > > > +	 * cannot be offlined until this finishes.
> > > > > +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> > > > > +	 * because there is no teardown callback registered anymore, for
> > > > > +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls
> > > > back
> > > > > +	 * state on cores before the CPU on which error was encountered.
> > > > > +	 */
> > > > >  	ret =
> > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > >  				       &pool->node);
> > > > > +
> > > > > +	/*
> > > > > +	 * We only needed the multi state instance add operation to invoke
> > > > the
> > > > > +	 * startup callback for all cores without cores getting offlined. Since
> > > > > +	 * the acomp_ctx resources will now only be de-allocated when the
> > > > pool
> > > > > +	 * is destroyed, we can safely remove the multi state instance. This
> > > > > +	 * minimizes (but does not eliminate) the possibility of
> > > > > +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> > > > > +	 * offline-online transition. Removing the instance also prevents race
> > > > > +	 * conditions between CPU onlining after initial pool creation, and
> > > > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > > > +	 * Note that we delete the instance before checking the error status
> > > > of
> > > > > +	 * the node list add operation because we want the instance removal
> > > > even
> > > > > +	 * in case of errors in the former.
> > > > > +	 */
> > > > > +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > &pool->node);
> > > > > +
> > > >
> > > > I don't understand what's wrong with the current flow? We call
> > > > cpuhp_state_remove_instance() in pool deletion before freeing up the
> > > > per-CPU resources. Why is this not enough?
> > >
> > > This is because with the changes proposed in this commit, the multi state
> > > add instance is used during pool creation as a way to create acomp_ctx
> > > resources correctly with just the offline/online state transitions guaranteed
> > > by CPU hotplug, without needing additional mutex locking as in the
> > mainline.
> > > In other words, the consistency wrt safely creating/deleting acomp_ctx
> > > resources with the changes being proposed is accomplished by the hotplug
> > > state transitions guarantee. Stated differently, the hotplug framework
> > > helps enforce the new design during pool creation without relying on the
> > > mutex and subsequent simplifications during zswap_[de]compress()
> > > proposed in this commit.
> > >
> > > Once this is done, deleting the CPU hotplug state seems cleaner, and
> > reflects
> > > the change in policy of the resources' lifetime. It also prevents race
> > conditions
> > > between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called from
> > > zswap_pool_destroy().
> > 
> > How is a race with zswap_cpu_comp_prepare() possible if we call
> > cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the pool
> > deletion path?
> 
> Good point. I agree, calling cpuhp_state_remove_instance() before
> acomp_ctx_dealloc() will not cause a race. However, if we consider the
> time from pool creation to deletion: if there is an online-offline-online
> transition, can zswap_cpu_comp_prepare() race with the call to
> cpuhp_state_remove_instance()? If so, wouldn't this cause unpredictable
> behavior?

How will this race happen?

cpuhp_state_remove_instance() is called while a pool is being destroyed,
while zswap_cpu_comp_prepare() while the pool is being created or during
CPU onlining.

The former cannot race, and the latter should be synchronized by hotplug
code.

> 
> I agree, this can occur even with the code in this commit, but there is
> less risk of things going wrong because we remove the CPU hotplug
> instance before the pool is added to zswap_pools.
> 
> Further, removing the CPU hotplug instance directly codifies the
> intent of this commit, i.e., to use this as a facilitator and manage memory
> allotted to acomp_ctx, but not to manage those resources' lifetime
> thereafter.
> 
> Do you see any advantage of keeping the call to cpuhp_state_remove_instance()
> occur before acomp_ctx_dealloc() in zswap_pool_destroy()? Please let me know
> if I am missing something.

What about more CPUs going online? Without the hotplug instance we don't
get per-CPU resources for those. We are not using the hotplug mechanism
just to facilitate per-CPU resource allocation, we use it to
automatically allocate resources for newly onlined CPUs without having
to preallocate for all possible CPUs.

Also, this makes the code more difficult to reason about, and is an
unncessary change from the current behavior.

The only change needed is to drop the teardown callback and do the
freeing in the pool destruction path instead.

