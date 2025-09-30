Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505CCCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEF78E000B; Tue, 30 Sep 2025 14:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CC58E0002; Tue, 30 Sep 2025 14:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7474D8E000B; Tue, 30 Sep 2025 14:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C53D8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:30:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D522387107
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:30:07 +0000 (UTC)
X-FDA: 83946756054.21.F0A5FDA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0A4E18000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:30:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D2AwmLqn;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759257006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfaJeFTrL0pAv3T6p7vpO4FayTsuANtiW3FF2QeqazQ=;
	b=ukMuMJhYFLHrxzU4nXyRZiZmxEda4UeOmXO6vBnk6RN2sewIex7ofbk4bRrYQWN5hYncfA
	vBr1T699wBPE7C3Z8ioj0jnP7MWL8xpbktesUxDrc81u5R4k5trNzBroI5Dyjgj92DYQFF
	tc2HNwn72AeJ4O/ao2fbtWK121vdh0k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D2AwmLqn;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759257006; a=rsa-sha256;
	cv=none;
	b=Al42nm5NJrZqh7g4BB9iy/Fj3mopgns29SUYhSiPhQGP4zfGsatUbvBoLupPrrl8Y6W7B8
	tilhq1gnVU3hislDSvr7xZwHwnEGs969Gnx5Gf7QBcSiaRJawoy1wOxUj1QMSL0agcyY+8
	8pZwxcsF9n14APAJlyNx9jI3w1Gv1OM=
Date: Tue, 30 Sep 2025 18:29:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759257003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DfaJeFTrL0pAv3T6p7vpO4FayTsuANtiW3FF2QeqazQ=;
	b=D2AwmLqndrAys2IIYNaADN+P+o9vOCZTCnEtwRs8D89uoqdcGZUp70eAiePbRXKjxa2Kpo
	48N1fs158GjMufUyG95CbqYM+USqMnxe5vgeF1bAP9L4F5G8fTYkHLRdO4WX+sGhsTKMIV
	Qvt0784rln9r2rmhKbe9ebFF1zFDRhE=
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
Message-ID: <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D0A4E18000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xwwgutjfxj7pfbxj7n3gjsmzte57dptq
X-HE-Tag: 1759257005-78280
X-HE-Meta: U2FsdGVkX1912wSiTbMuaIwYjOzvu1+p2K7UOAJ3oY8Z9isde/NVjgciBHHCTj+ODi9W3NvHV7PtR9EV7gS+zlSXwj47tCch1a5bL7C9kR+ZPpiTJyjMKIV8niNcJ4e2mghYVSsH6MoIOpdUN6oWVkNIoeInQymIKteix5l5CzDoQioaYobv8C+oywLYd7Z0GFVZeczkBk1fewAG7MBzvvM8ZYY2KqBhzviV2zm+fTFsCOa+rPEwpc8F7+3Js2pGSsKNRCea/kuKDjqLblZa9xV7cqfMexcyC5Z1ckTL/ccmr4kST5BJNGc3+Kc1nVJgd/1JtBT7jntyg/sojGE9UD683nKd2Zn7NgU7X9KsEn4vCJh38rizOM2462+/7e63AfrL4kbwMePeI/1+Up/SZDGl0ZMR4HJ2dr2t4a37U84kPPKhqynOlvd9at6TRZ/oIPcDA0CTLbkMa7UVY7Y/Ea5//cdcqDa9zDKAehZJAEuk3cohUxMMj4mMOY+56jMAT6rdIaKgdcd35o/fyVJhDgdW158kRgUM2U8q2jQ/fGwqE+ndnud3/OA7jjQAS3uErQpqVhTCg2dz/wS37OeR5B2Oy+Q3bOBLm2T/69ILqFvovoBQxNghLnS8xiOC+jgACzrYR5T/Vz6Y69Fw8t9vvY/JQkjHW0jOfQ99VrzJjwvco1vPkA/npIlcZZyK3biNIg0jOjvPXmVDewTI3mjrjbx4qYZNeTe3JvAkIASq5aIrPqOVcoHc1MkhYWnhhJwQ1PI2y8hKtpmp+y+Y/s4001kokIr2D1mIZF3c/yUD+9UiaCpD2mhgVTp0sWTHw2tWrKRFc8jJlBoRDOojZKvfjtAa5TbnRzdeRg2VN1H0OOyWEhx78TbgUydovDQz1qS4P3uN9B4ly43PCI36+Twu8tC6GlGT7us2hDH/FkweTHH9ThIQrGaROTMDqMGiHGfjjSKpRG/ntnoX8KRoKSz
 f5Nt+jbV
 2OBjjAz1hiHN8SF/6uDPLbkgftWBftIdflRFE1hiE1UsFMGHjIz7IkGjtWzVbKZucozyX6Lw+22FFZaKFVnM9+JIcJ4pzEzoPcGdM0y8qOjErSTOJfE55rjqxM/lqrhmxGDyRvrtuH1jzH+j5vb2gh01tkQQLwDgxVVRUQC5rRnMOR/z4V009cAnOnNbLqGt6l9v1veGrez5y8rhM1efgvvEd9J7YQpsjbVf5LsufGjCfvgOhepN9Al/dz13DfD0Jo0c7Ues28+4llc8KuIdomd7uL3zG05Thyo9H8DNBPl481bCdsBqCY3aSOkET6JQGLQX1QfpKW/7cvjnJG0kWNAOFta3qw1Joqq3+/91OsES/kDhronpi7K/4np6lrEoqjokMdp2V/a9vQh/guKaeMn4OXcyK7mlUJA7tn3ateFyyp2elGqUdEcZL7woy337ilxAxGbAQQbNpnfJCBoOvFBce51nhv8xgJI6I+EECe+/1bayhcVEYdJlTXxvHuKLO5gpFtUrgBB1Uc6wt+/iX1wym0PVcH3QWpUZA7wqUNRIcFKraMX+JP1d7recy5u1aFu5GdmoZXYvjuU8RIfjdI1u8otJkcPq7k1UX2tTxnCF//xetTZ7VCe1P7tqmbxWZzQ9V1ZKX6aiYFKXipsZaapnEA+wYPjv/nJFISTmCPCip2cRkuT9LTcskIyAD1WrqiW+IHHBbjJidOe8X1KrIhv+ivGePHmj0+uLe+eO9JoPp/Zc8AfFL1DCW3911Tw5fo+U2sCRFspmuG8nxb7y2xKaZ2uotfwd4PP0SW4VwmxbtIS5/fNpOfeiRgUvazOptnv5mFcfVeg4w4uLwBbsLJH0kXF7FJo+m2VHeBsLbdUf/rC5ZcjagrXRHY6PF+ehczUiu1LOuiXVqOj6plUHxuIYS2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 06:20:13PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, September 30, 2025 8:49 AM
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
> > On Thu, Sep 25, 2025 at 08:34:59PM -0700, Kanchana P Sridhar wrote:
> > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> > > pool creation to pool deletion. These resources will persist through CPU
> > > hotplug operations. The zswap_cpu_comp_dead() teardown callback has
> > been
> > > deleted from the call to
> > > cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result,
> > CPU
> > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > resources are concerned.
> > >
> > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > new function acomp_ctx_dealloc() that preserves the IS_ERR_OR_NULL()
> > > checks on acomp_ctx, req and acomp from the existing mainline
> > > implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is called
> > > to clean up acomp_ctx resources from all these procedures:
> > >
> > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > 2) zswap_pool_create() when an error is encountered, and
> > > 3) from zswap_pool_destroy().
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
> > >     out. zswap_cpu_comp_prepare() will be executed on a control CPU,
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
> > >     subsequent CPU hotplug online-offlines:
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
> > >     To prevent possibility of race conditions between
> > >     acomp_ctx_dealloc() freeing the acomp_ctx resources and the initial
> > >     check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(), we
> > >     need to delete the multi state instance right after it is added, in
> > >     zswap_pool_create().
> > >
> > >  Summary of changes based on the above:
> > >  --------------------------------------
> > >  1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() to
> > >     simplify and share common code for different error handling/cleanup
> > >     related to the acomp_ctx.
> > >
> > >  2) Remove the node list instance right after node list add function
> > >     call in zswap_pool_create(). This prevents race conditions between
> > >     CPU onlining after initial pool creation, and acomp_ctx_dealloc()
> > >     freeing the acomp_ctx resources.
> > >
> > >  3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-allocate
> > >     the per-CPU acomp_ctx resources.
> > >
> > >  4) Changes to zswap_cpu_comp_prepare():
> > >
> > >     a) Check if acomp_ctx->acomp is valid at the beginning and return,
> > >        because the acomp_ctx is already initialized.
> > >     b) Move the mutex_init to happen in this procedure, before it
> > >        returns.
> > >     c) All error conditions handled by calling acomp_ctx_dealloc().
> > >
> > >  5) New procedure acomp_ctx_dealloc() for common error/cleanup code.
> > >
> > >  6) No more multi state instance teardown callback. CPU offlining is a
> > >     no-op as far as acomp_ctx resources are concerned.
> > >
> > >  7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directly
> > >     call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx-
> > >mutex)
> > >     in zswap_[de]compress().
> > >
> > > The per-CPU memory cost of not deleting the acomp_ctx resources upon
> > CPU
> > > offlining, and only deleting them when the pool is destroyed, is as
> > > follows, on x86_64:
> > >
> > >     IAA with 8 dst buffers for batching:    64.34 KB
> > >     Software compressors with 1 dst buffer:  8.28 KB
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > 
> > Please try to make the commit logs a bit more summarized. Details are
> > helpful, but it's easy to lose track of things when it gets too long.
> 
> Thanks Yosry, for the feedback.
> 
> > 
> > > ---
> > >  mm/zswap.c | 194 +++++++++++++++++++++++++----------------------------
> > >  1 file changed, 93 insertions(+), 101 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index c1af782e54ec..27665eaa3f89 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -242,6 +242,30 @@ static inline struct xarray
> > *swap_zswap_tree(swp_entry_t swp)
> > >  **********************************/
> > >  static void __zswap_pool_empty(struct percpu_ref *ref);
> > >
> > > +/*
> > > + * The per-cpu pool->acomp_ctx is zero-initialized on allocation. This
> > makes
> > > + * it easy for different error conditions/cleanup related to the acomp_ctx
> > > + * to be handled by acomp_ctx_dealloc():
> > > + * - Errors during zswap_cpu_comp_prepare().
> > > + * - Partial success/error of cpuhp_state_add_instance() call in
> > > + *   zswap_pool_create(). Only some cores could have executed
> > > + *   zswap_cpu_comp_prepare(), not others.
> > > + * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
> > > + */
> > 
> > Comments describing specific code paths go out of date really fast. The
> > comment is probably unnecessary, it's easy to check the allocation path
> > to figure out that these are zero-initialized.
> > 
> > Also in general, please keep the comments as summarized as possible, and
> > only when the logic is not clear from the code.
> 
> Sure. I have tried to explain the rationale for significant changes, but I can
> look for opportunities to summarize. I was sort of hoping that v12 would
> be it, but I can work on the comments being concise if this is crucial.
> 
> > 
> > > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > > +{
> > > +	if (IS_ERR_OR_NULL(acomp_ctx))
> > > +		return;
> > > +
> > > +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > > +		acomp_request_free(acomp_ctx->req);
> > > +
> > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > +		crypto_free_acomp(acomp_ctx->acomp);
> > > +
> > > +	kfree(acomp_ctx->buffer);
> > > +}
> > > +
> > >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > >  {
> > >  	struct zswap_pool *pool;
> > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > *zswap_pool_create(char *compressor)
> > >
> > >  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> > >
> > > -	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> > > +	/* Many things rely on the zero-initialization. */
> > > +	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
> > > +					   GFP_KERNEL | __GFP_ZERO);
> > >  	if (!pool->acomp_ctx) {
> > >  		pr_err("percpu alloc failed\n");
> > >  		goto error;
> > >  	}
> > >
> > > -	for_each_possible_cpu(cpu)
> > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > -
> > > +	/*
> > > +	 * This is serialized against CPU hotplug operations. Hence, cores
> > > +	 * cannot be offlined until this finishes.
> > > +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> > > +	 * because there is no teardown callback registered anymore, for
> > > +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls
> > back
> > > +	 * state on cores before the CPU on which error was encountered.
> > > +	 */
> > >  	ret =
> > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > >  				       &pool->node);
> > > +
> > > +	/*
> > > +	 * We only needed the multi state instance add operation to invoke
> > the
> > > +	 * startup callback for all cores without cores getting offlined. Since
> > > +	 * the acomp_ctx resources will now only be de-allocated when the
> > pool
> > > +	 * is destroyed, we can safely remove the multi state instance. This
> > > +	 * minimizes (but does not eliminate) the possibility of
> > > +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> > > +	 * offline-online transition. Removing the instance also prevents race
> > > +	 * conditions between CPU onlining after initial pool creation, and
> > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > +	 * Note that we delete the instance before checking the error status
> > of
> > > +	 * the node list add operation because we want the instance removal
> > even
> > > +	 * in case of errors in the former.
> > > +	 */
> > > +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > &pool->node);
> > > +
> > 
> > I don't understand what's wrong with the current flow? We call
> > cpuhp_state_remove_instance() in pool deletion before freeing up the
> > per-CPU resources. Why is this not enough?
> 
> This is because with the changes proposed in this commit, the multi state
> add instance is used during pool creation as a way to create acomp_ctx
> resources correctly with just the offline/online state transitions guaranteed
> by CPU hotplug, without needing additional mutex locking as in the mainline.
> In other words, the consistency wrt safely creating/deleting acomp_ctx
> resources with the changes being proposed is accomplished by the hotplug
> state transitions guarantee. Stated differently, the hotplug framework
> helps enforce the new design during pool creation without relying on the
> mutex and subsequent simplifications during zswap_[de]compress()
> proposed in this commit.
> 
> Once this is done, deleting the CPU hotplug state seems cleaner, and reflects
> the change in policy of the resources' lifetime. It also prevents race conditions
> between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called from
> zswap_pool_destroy().

How is a race with zswap_cpu_comp_prepare() possible if we call
cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the pool
deletion path?

> 
> The only cleaner design I can think of is to not use CPU hotplug callbacks
> at all, instead use a for_each_possible_cpu() to allocate acomp_ctx
> resources. The one benefit of the current design is that it saves memory
> if a considerable number of CPUs are offlined to begin with, for some
> reason.
> 
> Thanks,
> Kanchana

