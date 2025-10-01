Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D9FCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5A88E0005; Wed,  1 Oct 2025 11:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD448E0002; Wed,  1 Oct 2025 11:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9C58E0005; Wed,  1 Oct 2025 11:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E10D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:33:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AF90C0152
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:33:23 +0000 (UTC)
X-FDA: 83949939486.23.9853112
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3DC2720007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:33:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVaCowwg;
	spf=pass (imf03.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759332801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Yv0CwkielXUFY13Tke9yDHu46iA3m89ltKb+trU33A=;
	b=bhTEJn0E557THpffbtbYNysn/C9iVWap59ub7jEY82lHsMhdiarIFllHD619qVfPBSMPxm
	O+438+1Ote7bUio3Z00btjj78kDMDZyI6M+0Hd7GHoWzR+VXAbL2jrGhiilYTEjf5vFgr0
	HE8RDaLK91jNieD+ZxMjW+ugO7SnfFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVaCowwg;
	spf=pass (imf03.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759332801; a=rsa-sha256;
	cv=none;
	b=aAoWX0557OHDiF6Hfg+hh1l9VLCbnpQC++nNIkt4pJsM6gv0Fw2LGIctty5i6B59kYJW1r
	g/JY5oTtboFyhg1kOnwqD5HcaWi+HJ8unPIwMFJ0btvr0zpnoFoXZrON3EpMUFmgYNl+al
	MC4WHC7WiNfyIpIgstdMWbkytk476zU=
Date: Wed, 1 Oct 2025 15:33:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759332798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Yv0CwkielXUFY13Tke9yDHu46iA3m89ltKb+trU33A=;
	b=fVaCowwgrrW4wG/jzU1zmwNJvtpZ07/RFYUBwwSe7afqIXdgVgQ6tU9Dg2PNGvbgbNN7Lk
	Rj1UQFZNqlWPIqjrPgfeiO1Pl4SDn+QbT9yuD1DHae6U0TMP/nBSeq//qx3HWFpK2iYLsC
	SvEgMc2jmmmwjAWhsAAvOYVu+W2Y/Gk=
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
Message-ID: <6frwacvukeaqrmtja43ab3nkldkrupczmhelrgjljvtk5eh4km@4pebysubl3dl>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
 <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <6xb7feds424kfld4udwmbtccftwnnx6vmbpvmjcwlionfdlmuj@vz4uzh6tog5g>
 <SA3PR11MB8120D4BDA8A6980A4BC5447FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB8120D4BDA8A6980A4BC5447FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3DC2720007
X-Stat-Signature: caqdm7zkmm6tnjsoqxyzj6xtmyk1nsyq
X-HE-Tag: 1759332801-438838
X-HE-Meta: U2FsdGVkX19aru/BqktxK0WEMq3W6ue8I/PJ/6KNL3RlAM580CtOywLcUkbut5qSemjsnFNKW7FBGhx9yk6kmThua1qBgwr2BNDzk6cYzhzFN6JGlyBR0Y8OZWUht5/PGj9Rv9xq99atJHCFU7MjcOraTFl0qLfglypn7IgxEXeSyxBslEf3EcPbAN1GlxlOaxdBu2cxvb4gQYoobGxv1ARVZg9Gsy4KCabg248cSP5VZaSFP9kfm5z3kjvzWY1Ip9RcUMWo5GQe9BMfj5CFOh45WRL3W+TojRihHZXEElY+d4K0eT+uUjmA2O5m8FL2yMXbBaQr1jUwejf1BNSHqXIaDZ/sY1mNU1R6iAUhXunMc0uiANDf1FvtgdSlEFbVQ9j99RF7HVlhJE/HM+kdabQczZhT5kLkpUZrWjU5gUwSsruRkHlCq443da6ZWZdOS/dNbOGBz2khtw3crElrzcRf0Ugl0dM5GjaMeuEVbp7KhCdinJW/g2cokDBMB+cHrId3KHjZF5yeYMK/Thi1dtLURMD1A6pSEz0XlCAlA/N84xwDWZpma3nD4E/Yo4xmXFI2WhYzePHWLSk7TkuJOHO/gS24diR9S20t5dEcyMMz29t0wt7+V5NzzNXaW0SyB38RfXxM57AGTy76v64+JOI9UcMRrT0vTOc5T5Cu/Ul7EXFXGzgVxOA4M+ACAM+slLlrmujP4eGgjznhAa/FEoVh70ILXfnuVjZ4v6gwqD66q4wvNJdeLWuoTSKYfjFRdhHR56GR5VFq3aGOghC4HiVykP9617GLJHnd4eDWOUp7yc4wTvVLd7uQ1yzebF7gCfWSzg5GrLPuQ0+y/LIeCnIvZTTCgmPoR5lbDfRETFKJhqJOBLX7NzysNkeqIQdkpT4BKshAIwx9AtXMr9KLZ2+EfaWVv5JPK7+QXxodHjCBhJFFhYf5yndWQbOmPxJGTElewS99R0KhjjaMZy9
 1s5wTMx/
 dU9fbNIzlPVP7Y8nsDcMv8w6jctbJ22aNsp4DM/D92VI0x7alHEMO8S7qqJvXELp5U9sHAWNxJ9j6/3cUCtOGIHUseCqIa2ygb1Qw1XUciOYNhp6Pc9VIi8Gxpw+nA7FCvJwcV5+U7NKzVMyeuXkK9EcYWrcfQSEz+5+1KaS4L1PsIV9HBRTHMNmikFZo3qYQY+4Alhofm2gpnHrZ7KhT5tHno942ePNXOMStD2E7ugm6H7A00H/zpCwCVCKIkTITRxRmdLfDvL2rl4NXTwiePpcdpvGjrFO9FbyEZypehuUNgm2Kd9h12bbz6DY4a61xssQfjzM4Iv+Aig300eCWPWUmyaG36UcF5mNYV2+J/4BoGfT3/WK4KyAFjYpGHbTEewRPbnCEiA6VO2P/WbK8PR88B5v9S+3/9ws9VZfvmUZOyN4XqKG/+1jnbG6FKHUdbWmSU5s7aQWQjaDUHxh/gQOnGpyuYVv5YXa5ug7ebHFmgSMzbVm1GBNeySCktpLXG4FtDWZpd0fd8Xq+TXOEehT9rqNdqoUcp03JUhcgyy/JkwHYO3mQAqrEzcl4ohITpRWqz1EPjdO4UlIfj4OG2uBdKUYEabuvK9lY0CF3/bpd/AO2YvCKJnAJ+9F41tDkU3igQKGQEOX7vcgf3Qq7+pH3XjJWFkzPVp6xXoSj0AJT+dQ/Jxmr3/Rf1gHAmm8+RFbKzZbwpZpGdigUM9Bv4Ix3/MfmuK474LBHBiEjNK68E9XI7fgl/Vv3gR8bgznIlWgXZGyATT0Vn7KrpIqyUTVahWSxHA1Zy2huf9U9aafvM62u2K71OW25HTUSrv/pSYQFnRD9MC23Bm9fNJHtl8+MSJXgoHcw6Dwr1rW1GglvyM0RdE9uQSXUbRWW5U9LiXJnUezXhUK4AiDo3PfuHQNawQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 09:56:33PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, September 30, 2025 2:20 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources
> > exist from pool creation to deletion.
> > 
> > > > > > >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > > > > > >  {
> > > > > > >  	struct zswap_pool *pool;
> > > > > > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > > > > > *zswap_pool_create(char *compressor)
> > > > > > >
> > > > > > >  	strscpy(pool->tfm_name, compressor, sizeof(pool-
> > >tfm_name));
> > > > > > >
> > > > > > > -	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> > > > > > > +	/* Many things rely on the zero-initialization. */
> > > > > > > +	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
> > > > > > > +					   GFP_KERNEL |
> > __GFP_ZERO);
> > > > > > >  	if (!pool->acomp_ctx) {
> > > > > > >  		pr_err("percpu alloc failed\n");
> > > > > > >  		goto error;
> > > > > > >  	}
> > > > > > >
> > > > > > > -	for_each_possible_cpu(cpu)
> > > > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)-
> > >mutex);
> > > > > > > -
> > > > > > > +	/*
> > > > > > > +	 * This is serialized against CPU hotplug operations. Hence,
> > cores
> > > > > > > +	 * cannot be offlined until this finishes.
> > > > > > > +	 * In case of errors, we need to goto "ref_fail" instead of
> > "error"
> > > > > > > +	 * because there is no teardown callback registered anymore,
> > for
> > > > > > > +	 * cpuhp_state_add_instance() to de-allocate resources as it
> > rolls
> > > > > > back
> > > > > > > +	 * state on cores before the CPU on which error was
> > encountered.
> > > > > > > +	 */
> > > > > > >  	ret =
> > > > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > > >  				       &pool->node);
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * We only needed the multi state instance add operation to
> > invoke
> > > > > > the
> > > > > > > +	 * startup callback for all cores without cores getting offlined.
> > Since
> > > > > > > +	 * the acomp_ctx resources will now only be de-allocated
> > when the
> > > > > > pool
> > > > > > > +	 * is destroyed, we can safely remove the multi state
> > instance. This
> > > > > > > +	 * minimizes (but does not eliminate) the possibility of
> > > > > > > +	 * zswap_cpu_comp_prepare() being invoked again due to a
> > CPU
> > > > > > > +	 * offline-online transition. Removing the instance also
> > prevents race
> > > > > > > +	 * conditions between CPU onlining after initial pool creation,
> > and
> > > > > > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > > > > > +	 * Note that we delete the instance before checking the error
> > status
> > > > > > of
> > > > > > > +	 * the node list add operation because we want the instance
> > removal
> > > > > > even
> > > > > > > +	 * in case of errors in the former.
> > > > > > > +	 */
> > > > > > > +
> > 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > > &pool->node);
> > > > > > > +
> > > > > >
> > > > > > I don't understand what's wrong with the current flow? We call
> > > > > > cpuhp_state_remove_instance() in pool deletion before freeing up the
> > > > > > per-CPU resources. Why is this not enough?
> > > > >
> > > > > This is because with the changes proposed in this commit, the multi
> > state
> > > > > add instance is used during pool creation as a way to create acomp_ctx
> > > > > resources correctly with just the offline/online state transitions
> > guaranteed
> > > > > by CPU hotplug, without needing additional mutex locking as in the
> > > > mainline.
> > > > > In other words, the consistency wrt safely creating/deleting acomp_ctx
> > > > > resources with the changes being proposed is accomplished by the
> > hotplug
> > > > > state transitions guarantee. Stated differently, the hotplug framework
> > > > > helps enforce the new design during pool creation without relying on the
> > > > > mutex and subsequent simplifications during zswap_[de]compress()
> > > > > proposed in this commit.
> > > > >
> > > > > Once this is done, deleting the CPU hotplug state seems cleaner, and
> > > > reflects
> > > > > the change in policy of the resources' lifetime. It also prevents race
> > > > conditions
> > > > > between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called
> > from
> > > > > zswap_pool_destroy().
> > > >
> > > > How is a race with zswap_cpu_comp_prepare() possible if we call
> > > > cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the pool
> > > > deletion path?
> > >
> > > Good point. I agree, calling cpuhp_state_remove_instance() before
> > > acomp_ctx_dealloc() will not cause a race. However, if we consider the
> > > time from pool creation to deletion: if there is an online-offline-online
> > > transition, can zswap_cpu_comp_prepare() race with the call to
> > > cpuhp_state_remove_instance()? If so, wouldn't this cause unpredictable
> > > behavior?
> > 
> > How will this race happen?
> > 
> > cpuhp_state_remove_instance() is called while a pool is being destroyed,
> > while zswap_cpu_comp_prepare() while the pool is being created or during
> > CPU onlining.
> > 
> > The former cannot race, and the latter should be synchronized by hotplug
> > code.
> > 
> > >
> > > I agree, this can occur even with the code in this commit, but there is
> > > less risk of things going wrong because we remove the CPU hotplug
> > > instance before the pool is added to zswap_pools.
> > >
> > > Further, removing the CPU hotplug instance directly codifies the
> > > intent of this commit, i.e., to use this as a facilitator and manage memory
> > > allotted to acomp_ctx, but not to manage those resources' lifetime
> > > thereafter.
> > >
> > > Do you see any advantage of keeping the call to
> > cpuhp_state_remove_instance()
> > > occur before acomp_ctx_dealloc() in zswap_pool_destroy()? Please let me
> > know
> > > if I am missing something.
> > 
> > What about more CPUs going online? Without the hotplug instance we don't
> > get per-CPU resources for those. We are not using the hotplug mechanism
> > just to facilitate per-CPU resource allocation, we use it to
> > automatically allocate resources for newly onlined CPUs without having
> > to preallocate for all possible CPUs.
> 
> This is an excellent point! It makes sense, I will move the call to
> cpuhp_state_remove_instance() to be before the call to
> acomp_ctx_dealloc() in zswap_pool_destroy(). Thanks for catching this.
> 
> > 
> > Also, this makes the code more difficult to reason about, and is an
> > unncessary change from the current behavior.
> 
> Ok.
> 
> > 
> > The only change needed is to drop the teardown callback and do the
> > freeing in the pool destruction path instead.
> 
> Just to summarize: besides moving the call to cpuhp_state_remove_instance()
> to zswap_pool_destroy() and more concise comments/commit logs, are there
> other changes to be made in patch 20?

I don't believe so. Thanks!

