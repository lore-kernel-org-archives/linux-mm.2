Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFD8D4335B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 01:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DE26B0005; Thu, 11 Dec 2025 20:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0776B0006; Thu, 11 Dec 2025 20:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7996B0007; Thu, 11 Dec 2025 20:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44DB66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:06:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3F1B58AE1
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:06:31 +0000 (UTC)
X-FDA: 84209028582.08.4A287DA
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id D008D120012
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:06:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NBASkG/d";
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765501590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mnFhMQvoL3Tbh3eu4uaMeknBOuqdt/beNT596uP9Bc=;
	b=mcobHP5V0YZpL1SUXtcNuAFrysA7skIuTRENJvU0qTIXbfigwDNPGa0VHG7jlLmModEXri
	mrv42w6EhoNb0NtfHDJ4G6IbuWIiak61sfbooLpSLpouvnLJPSKOxkC2dp/PjfpZw+GVIq
	nwM2xrnHXdWiaUKNeyyVaDW54UYh46g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765501590; a=rsa-sha256;
	cv=none;
	b=1KdGbYoCb4/2PzcGmG49UYT9V9FePNTCuo4zSoN1SMJQplDHOf6s2nYBh/9DG+32OtEfov
	jhmCG61qR+36wdCkKnZhlMZz+CYwrH3ZbBbQeGvNLv45KKUubRZYX6JFMRCXwdDvx+7LZL
	+UFqimwvDKeaMotkf7JX5QqxPNN/ltM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NBASkG/d";
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Dec 2025 01:06:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765501587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4mnFhMQvoL3Tbh3eu4uaMeknBOuqdt/beNT596uP9Bc=;
	b=NBASkG/db0xbw3HwkCD4mtCX9qFpvMjvZtpuhF3TvGpepKHCtV4jFXKxWCwSBz7BA1YY+z
	uwEx6J/9ZAFWHsje5Fzsx1uO9E155c5qru/vXJXkfuRQIHB/TYOxmAMXd03EhaiJE8eKiZ
	bldt41pukUOPPRr9yjVJXhmV/BTWAKM=
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
Message-ID: <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9o75rs3oqcprpaaqss87bchpgh3aeqju
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D008D120012
X-Rspam-User: 
X-HE-Tag: 1765501589-207314
X-HE-Meta: U2FsdGVkX18ZldD1Yd3/J8wuTa5pJBf1Ny0zh7KTz46RHMqWx5r+qpY/+5wDJX/9FPLs5x60Ev/bcIizC5xRaHwGhsUJc6MR3g2yzENVdicenS+iwIjc3WBHURyMnp9zHNnMqEnsUPazVTNylmXw8dTW5K+2/dXrXMSTzh/uvnQ2vunDtjAk1B9/Lgk/aEuzefKsjR/qTXw4JydRjXmKLG9g8r72DXEaZWtZl3vSXpsef+gq1XIRdQwy2oQuiKtiv1O7tfoD/d2ZmRDb4KSJ4GVnzLJrFZyw2Vm8MUHUQD1lqir9uMK6WSYtbGcuIlOLv4yqvxoI4opxzq6J4AW6h3Tc6KV+RzLjCdhyUC27mfuCIfI2l7U0bSj52NDvoh/L/zf9/ha54Zsgu8k1LZCfsDAD/cDtIzM+/ZfnH+/DmfnUWzhk1WkDCM6pzNangCewBi4Wznba25IB2/unxiQ16Nk6QxhjfEHqeTl21nzHycMRtB+mvFfCIoZtmYyaaQrP9HgLLxIucVLhA7FgVZSB51izUfDIPtLZgBI5/x9At994+nreUMkCab3KgkKM3SP/ou9ZdqVfeOmI79LNfzD0Vmh94TcbUQzdXzEmZoiZRcxIkkYbokRlWC3FUecy0KEHjIrgsAuPchP+KNxZKnpaVyGa/lLfP2bIVZfiHF7aH7gPjENU0VUakEi6+zgD1a4lgO6qNJvAWdbBFnhPYzjx+szFcY0APZ+KHG6BDlJMTcTZouvcrao/F2pvq8Q1LizSJ5+Of0xu0JXX3m4nfak9654j5hK3DtI862cvfKflAvVIcD+sFaKwgDAYwyHYDJq/3K4AJlEWY26aV968YoIivH5aaDBIIFzrHiyh1Oy9qQTpFQxft5Jq8dn4cqxi1VOc8uw/YjXSVhQUYxHdmAUUhLcTk90mAhWOHds9BL9zinHSXx9hDDbq5jYWB/BYtAUMCc8qpBYv51wkRQPYIas
 Wom1w8R0
 lipmLaXtvPF5b8CLuzSKtu7ZZKmkQyuBUgmtHSD4hWuFWT8R4ADTX8jMnHmUrHaAqR1KfczzIwf04GuKPHB0xNDNIOfl+9c3Zh+EOMLCZ1iqtyP2MBzUBe7ltJCnheCMRFTz8AYMSafOqYLH6sla5eZcPWNuXAgXXW3bRwZxqkhBY8o+ifJvK0MMHwxJwl4ZM2ac/ZQtwRlp/85MHgv5wVk/XObue6Z81Dy15BSppuU/nIXOdzl1+qAgbF0TLetM1+gqq95li+gSJgswB5NhTv0vZBYYhDh7oZVdnMX14Kb6Ngr0kLzfUaufo4u6OBkEWGYtcF3J8zi8bIGwC1QemgDaoWgKqc2cRRR3W1LQBIbnUySgfIsQ+l6BHF7RzPUX61+J1uL1P0QlI3LYQN3DesA2s5mJDmtSar8wU4S5sy11occK5vag8vUs1CmqyfYI3ziRqM68WDGUxc8fXGuCcEznu53UqmOXoInY2WVQfisQ1Ivht/Jnl0w8T0NXtPlapkTAMJhWFYjalqTPz2UN8ssxyxCdmCjXlHaNBVOuJpFvkpr9mQyOMeGevY+KSjgN5LX39MCF2JAqy9pxGfjcwYlT7Hd7LTtb5/CNWTpQljrTmYJygPNLY5vVhHsVHhFbJBui4ml3fjZM/bvi2bWAE61A9n/0VOW66By4hBHeen2PSw5xZmsGQsKIAN6Qbh4z0hYhqfhpsrXNTTQPeKRzYair025f/54tT0HQwVdSMF55kBADjz01eXeou+DaJx1m9996t0jQK6UPS9zjsN3khglkJBTmFUaa4SmjuOCfb45MHwTnbUFVkWKd9DEgt74JTjVjv8CKBDs3sevzQvAnwDG11JNnmVflm+nH7s5dj0eB/wxaGcLdNwT9SkPbjeacqmQdsHaU2xvbN98BYdvj10x5A9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 12:55:10AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 12:24 PM
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
> > Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> > exist from pool creation to deletion.
> > 
> > On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
> > 
> > The subject can be shortened to:
> > 
> > "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
> > 
> > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> > > pool creation to pool deletion. These resources will persist through CPU
> > > hotplug operations instead of being destroyed/recreated. The
> > > zswap_cpu_comp_dead() teardown callback has been deleted from the call
> > > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> > result, CPU
> > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > resources are concerned.
> > 
> > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > complicates the lifetime management to save memory while a CPU is
> > offlined, which is not very common.
> > 
> > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> > allocated until the pool is destroyed.
> > 
> > >
> > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
> > > resources from:
> > >
> > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > 2) zswap_pool_create() when an error is encountered, and
> > > 3) from zswap_pool_destroy().
> > 
> > 
> > Refactor cleanup code from zswap_cpu_comp_dead() into
> > acomp_ctx_dealloc() to be used elsewhere.
> > 
> > >
> > > The main benefit of using the CPU hotplug multi state instance startup
> > > callback to allocate the acomp_ctx resources is that it prevents the
> > > cores from being offlined until the multi state instance addition call
> > > returns.
> > >
> > >   From Documentation/core-api/cpu_hotplug.rst:
> > >
> > >     "The node list add/remove operations and the callback invocations are
> > >      serialized against CPU hotplug operations."
> > >
> > > Furthermore, zswap_[de]compress() cannot contend with
> > > zswap_cpu_comp_prepare() because:
> > >
> > >   - During pool creation/deletion, the pool is not in the zswap_pools
> > >     list.
> > >
> > >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
> > >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
> > >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of
> > "enum
> > >     cpuhp_state". Thanks Yosry for sharing this observation!
> > >
> > >   In both these cases, any recursions into zswap reclaim from
> > >   zswap_cpu_comp_prepare() will be handled by the old pool.
> > >
> > > The above two observations enable the following simplifications:
> > >
> > >  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot
> > use
> > >     the pool. Considerations for mutex init/locking and handling
> > >     subsequent CPU hotplug online-offline-online:
> > >
> > >     Should we lock the mutex of current CPU's acomp_ctx from start to
> > >     end? It doesn't seem like this is required. The CPU hotplug
> > >     operations acquire a "cpuhp_state_mutex" before proceeding, hence
> > >     they are serialized against CPU hotplug operations.
> > >
> > >     If the process gets migrated while zswap_cpu_comp_prepare() is
> > >     running, it will complete on the new CPU. In case of failures, we
> > >     pass the acomp_ctx pointer obtained at the start of
> > >     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
> > >     only undergo migration. There appear to be no contention scenarios
> > >     that might cause inconsistent values of acomp_ctx's members. Hence,
> > >     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> > >     zswap_cpu_comp_prepare().
> > >
> > >     Since the pool is not yet on zswap_pools list, we don't need to
> > >     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
> > >     has been restored to occur in zswap_cpu_comp_prepare().
> > >
> > >     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> > >     valid. If so, it returns success. This should handle any CPU
> > >     hotplug online-offline transitions after pool creation is done.
> > >
> > >  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> > >     migrated to another CPU before the current CPU is dysfunctional. If
> > >     zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
> > >     CPU, that mutex will be released once it completes on the new
> > >     CPU. Since there is no teardown callback, there is no possibility of
> > >     UAF.
> > >
> > >  3) Pool creation/deletion and process migration to another CPU:
> > >
> > >     - During pool creation/deletion, the pool is not in the zswap_pools
> > >       list. Hence it cannot contend with zswap ops on that CPU. However,
> > >       the process can get migrated.
> > >
> > >       Pool creation --> zswap_cpu_comp_prepare()
> > >                                 --> process migrated:
> > >                                     * CPU offline: no-op.
> > >                                     * zswap_cpu_comp_prepare() continues
> > >                                       to run on the new CPU to finish
> > >                                       allocating acomp_ctx resources for
> > >                                       the offlined CPU.
> > >
> > >       Pool deletion --> acomp_ctx_dealloc()
> > >                                 --> process migrated:
> > >                                     * CPU offline: no-op.
> > >                                     * acomp_ctx_dealloc() continues
> > >                                       to run on the new CPU to finish
> > >                                       de-allocating acomp_ctx resources
> > >                                       for the offlined CPU.
> > >
> > >  4) Pool deletion vis-a-vis CPU onlining:
> > >     The call to cpuhp_state_remove_instance() cannot race with
> > >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> > >
> > > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> > > Instead, zswap_[de]compress() directly call
> > > mutex_[un]lock(&acomp_ctx->mutex).
> > 
> > I am not sure why all of this is needed. We should just describe why
> > it's safe to drop holding the mutex while initializing per-CPU
> > acomp_ctx:
> > 
> > It is no longer possible for CPU hotplug to race against allocation or
> > usage of per-CPU acomp_ctx, as they are only allocated once before the
> > pool can be used, and remain allocated as long as the pool is used.
> > Hence, stop holding the lock during acomp_ctx initialization, and drop
> > acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().
> 
> Hi Yosry,
> 
> Thanks for these comments. IIRC, there was quite a bit of technical
> discussion analyzing various what-ifs, that we were able to answer
> adequately. The above is a nice summary of the outcome, however,
> I think it would help the next time this topic is re-visited to have a log
> of the "why" and how races/UAF scenarios are being considered and
> addressed by the solution. Does this sound Ok?

How about using the summarized version in the commit log and linking to
the thread with the discussion?

