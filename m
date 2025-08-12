Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534B7C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BC28E0108; Tue, 12 Aug 2025 05:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B268E00E5; Tue, 12 Aug 2025 05:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA2A8E0108; Tue, 12 Aug 2025 05:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76DE18E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:06:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5CAFB7460
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:06:35 +0000 (UTC)
X-FDA: 83767524750.01.76B2C3E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id C451B1A000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:06:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QlGngwFf;
	spf=none (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.11) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754989593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttp3ThUy17wlc/ZYxrHj+nIMaVIFscfzMWnr/Z8PMjQ=;
	b=kzlqmugnolIbsDSDLMoO5jhSKlbjwTTa0xCpQu2iKSp4KwuVVtDxWdvtOg+5gacLow9K5G
	pJ8rrFB+YybmHYqwNFwGoHRWtp4EgtNaAz8e2QRj7rbqjWGRO0gkz22BGTBAY6fmxUOW/z
	Yc8FNOy5Z2tRnVIMN54rmD3YkjhbPJk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QlGngwFf;
	spf=none (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.11) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754989593; a=rsa-sha256;
	cv=none;
	b=XUswXpVrh7z9UQsi9W948b6h3Vh9/D7E+5K5fvbvL5+nq6tYqiqWZXcOlz5BJ5EQ9txIl8
	GDuc2Y+bWt9XHnSVObt8aqzcyYcn/kwqYqj7LwDQEgdXf4hqUZfzY+FCAA0TWE33aPX34i
	uQWiJn+6kcUmxw7RxvrXNKmMvITsR/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754989593; x=1786525593;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8gFne/giBY9PSWZwoXTtzxujLwuZ+hsartMmWykWWk0=;
  b=QlGngwFfH3zvQTfFOqLfF0bevZ13XtWkvXURsr5zXb5n0Y2dxbWQa+VW
   8gsTJhCV3QnAmQUa9T8CStZhidkh2UgDoHH70f2bbcWQfSNH7aOQB3Zvo
   W4bD2Mqeugv4VUZq2etU6p1R9aYb+BJcpDctqe5kYNXmkhVEcIdODNqiX
   RxODb1L4wPz0n/kos3t0oeCgAL5utjL/BjGKNGop270OtqceYQ6HKGYlb
   n/oa7nHfqkASx62LvVC5Ze/8TQDGJkpVONzsFYI+720e/k1vLHpykwJqd
   CwmcSJb64Fg5KsODv4sNqtgExjGjAbzGxmzjp/322obmjvLRNCVigVkrv
   Q==;
X-CSE-ConnectionGUID: o7rPpGF5S5ey38Nhrfa24A==
X-CSE-MsgGUID: pT5sTC7eRb28fUyZbguy/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="67860067"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="67860067"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 02:06:31 -0700
X-CSE-ConnectionGUID: NAHuCiBMSNGpX4wmc77csA==
X-CSE-MsgGUID: NENKvorPTfKN9BlUl1AVIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="197148858"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.245.245.68]) ([10.245.245.68])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 02:06:28 -0700
Message-ID: <f35bafa3c62e5f541c4f5d65f5682a0360496dde.camel@linux.intel.com>
Subject: Re: [RFC PATCH 6/6] drm/xe: Implement two pass MMU notifiers for SVM
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org, Jason
 Gunthorpe	 <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org
Date: Tue, 12 Aug 2025 11:06:26 +0200
In-Reply-To: <aJpWkig5z8tbeQDo@lstrano-desk.jf.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
	 <20250809135137.259427-7-thomas.hellstrom@linux.intel.com>
	 <aJpWkig5z8tbeQDo@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: C451B1A000E
X-Rspamd-Server: rspam06
X-Stat-Signature: m6ni4fu3wayc6uo4r4r7by6tfg4tjnhk
X-HE-Tag: 1754989592-904728
X-HE-Meta: U2FsdGVkX18c45z/oDUm69wg7g+k57XFOs4nRzn9TTjHIXQx/76QauqQNuCXXV8xAwaW53D3n/XK84W1RVAfoBTkH+7AUUWFKta4LTR62wiApqzp3KGMgnJjR+aXZzmcEs+upxlhvwslRw0JEWGYFk0ElTEUkZBhjvhfPcHnjBvD0+P7QlsiXQhs9NntzJYycfvlc08nUTZs1RcNhvedNUPOE5qLzuBm50S/9/Rgi9loShIr2+qNcbnXAmYNi9MDt9VkyQs6txrV+lwQWewqijs70CaIoePTjBZpjy9oPWA3VMXEJhqi7f/uH4q275BwasdlYdrl4so8QWyXrF4RlzChF8fzHNxyM/Zn+rQ5LK8a/8/XGPatbGK3EHGaKrX5TDfmabymaC4s0S4IVoc7Z8Q6Qv4BRBkFeh5TkFlbpDw11ZMelzaBSVJVvBc4tNBFCS1F3yKOwTvbdWhg5RFJboBkGxZpCtMP4YYQCnpClGG6OZLlIovrwCfY4m8xnx6pHtrncvs/y9sre/Lzgyrn2Ii4JrUxf22fp66RoSIUu+m7fEsNo3zysRUuE1OiOpTqKmLc1BjMCLEe9C/nJIgpfHQ1txK2jcTJq/eQ89vd9Yyrxw8YV+B9NekZ87o/1BoGE10sj9nkd3NUKNl38Fm4xoVMR5no9K/ZkGRFF8/R4h7BFYDEoLL+Z8el0qCJRatQwMk8sCRKeYMSkGluav4WvHNFZgAPsiitq7nzW4o/LRAroxIvrxl5rZ6JuC2t1a/u+Q/8wP9qw1n62diY0GsqCgp5tnRKT1SP3liN0vfHzq2yDIL5Z/HK8SjXUhM6uyQ2srR6AKGgiw2CpnCQ7oo2WDizPJOgoGeE/ABuiaY3ktWCyH+aOHIaMIZqwhXFGBVHHwCeWQNEvc22Uu3YD5MHh2IgT5w8JYTjWS9dEmBnIc7JSJExV70yRYp6c+sWuj200dYA30Eb+SsB0A+OoUF
 A7Uz4hhO
 4KdIlMHsOYRDa6w7IKvtgysbh0PvbwcS7N/Uk+7zS9+OMctIdp4g9qPULGmjG6JCAFOF1Ea5LlirIIf5i/aoHiRzHa8EIWm2s8tnmnvudt2nNAIUR/LbgadId2sJ49y6pcfR+cwKC6d/sq1MFyzIdpBU/38/hE/Jlowt0gGt822Hdyxn75cuILv6l/4wcGxQbGXVe0986/NkcTEdQ7yraoA6XBuMtDTwnftyEXH6MIDbXdvg7kuBWI0ULcYiiws7Y3je9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-08-11 at 13:46 -0700, Matthew Brost wrote:
> On Sat, Aug 09, 2025 at 03:51:37PM +0200, Thomas Hellstr=C3=B6m wrote:
> > From: Matthew Brost <matthew.brost@intel.com>
> >=20
> > Implement two-pass MMU notifiers for SVM, enabling multiple VMs or
> > devices with GPU mappings to pipeline costly TLB invalidations by
> > issuing them in the first pass and waiting for completion in the
> > second.
> >=20
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> > =C2=A0drivers/gpu/drm/drm_gpusvm.c |=C2=A0 2 +-
> > =C2=A0drivers/gpu/drm/xe/xe_svm.c=C2=A0 | 74 ++++++++++++++++++++++++++=
++++--
> > ----
> > =C2=A02 files changed, 63 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/drm_gpusvm.c
> > b/drivers/gpu/drm/drm_gpusvm.c
> > index 92dc7d2bd6cf..f153df1bc862 100644
> > --- a/drivers/gpu/drm/drm_gpusvm.c
> > +++ b/drivers/gpu/drm/drm_gpusvm.c
> > @@ -413,7 +413,7 @@ drm_gpusvm_notifier_invalidate_twopass(struct
> > mmu_interval_notifier *mni,
> > =C2=A0 * drm_gpusvm_notifier_ops - MMU interval notifier operations for
> > GPU SVM
> > =C2=A0 */
> > =C2=A0static const struct mmu_interval_notifier_ops
> > drm_gpusvm_notifier_ops =3D {
> > -	.invalidate_twopass =3D
> > drm_gpusvm_notifier_invalidate_twopass,
> > +	.invalidate_multipass =3D
> > drm_gpusvm_notifier_invalidate_twopass,
>=20
> This should be in patch #2.

Yup. My bad fixing up for the interface change in patch 1. Sorry for
that.
/Thomas


>=20
> Matt
>=20
> > =C2=A0};
> > =C2=A0
> > =C2=A0/**
> > diff --git a/drivers/gpu/drm/xe/xe_svm.c
> > b/drivers/gpu/drm/xe/xe_svm.c
> > index 82a598c8d56e..5728394806ca 100644
> > --- a/drivers/gpu/drm/xe/xe_svm.c
> > +++ b/drivers/gpu/drm/xe/xe_svm.c
> > @@ -144,15 +144,8 @@ xe_svm_range_notifier_event_begin(struct xe_vm
> > *vm, struct drm_gpusvm_range *r,
> > =C2=A0	 * invalidations spanning multiple ranges.
> > =C2=A0	 */
> > =C2=A0	for_each_tile(tile, xe, id)
> > -		if (xe_pt_zap_ptes_range(tile, vm, range)) {
> > +		if (xe_pt_zap_ptes_range(tile, vm, range))
> > =C2=A0			tile_mask |=3D BIT(id);
> > -			/*
> > -			 * WRITE_ONCE pairs with READ_ONCE in
> > -			 * xe_vm_has_valid_gpu_mapping()
> > -			 */
> > -			WRITE_ONCE(range->tile_invalidated,
> > -				=C2=A0=C2=A0 range->tile_invalidated |
> > BIT(id));
> > -		}
> > =C2=A0
> > =C2=A0	return tile_mask;
> > =C2=A0}
> > @@ -161,16 +154,60 @@ static void
> > =C2=A0xe_svm_range_notifier_event_end(struct xe_vm *vm, struct
> > drm_gpusvm_range *r,
> > =C2=A0				const struct mmu_notifier_range
> > *mmu_range)
> > =C2=A0{
> > +	struct xe_svm_range *range =3D to_xe_range(r);
> > =C2=A0	struct drm_gpusvm_ctx ctx =3D { .in_notifier =3D true, };
> > =C2=A0
> > =C2=A0	xe_svm_assert_in_notifier(vm);
> > =C2=A0
> > +	/*
> > +	 * WRITE_ONCE pairs with READ_ONCE in
> > xe_vm_has_valid_gpu_mapping()
> > +	 */
> > +	WRITE_ONCE(range->tile_invalidated, range->tile_present);
> > +
> > =C2=A0	drm_gpusvm_range_unmap_pages(&vm->svm.gpusvm, r, &ctx);
> > =C2=A0	if (!xe_vm_is_closed(vm) && mmu_range->event =3D=3D
> > MMU_NOTIFY_UNMAP)
> > =C2=A0		xe_svm_garbage_collector_add_range(vm,
> > to_xe_range(r),
> > =C2=A0						=C2=A0=C2=A0 mmu_range);
> > =C2=A0}
> > =C2=A0
> > +struct xe_svm_invalidate_pass {
> > +	struct drm_gpusvm *gpusvm;
> > +	struct drm_gpusvm_notifier *notifier;
> > +#define XE_SVM_INVALIDATE_FENCE_COUNT	\
> > +	(XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE)
> > +	struct xe_gt_tlb_invalidation_fence
> > fences[XE_SVM_INVALIDATE_FENCE_COUNT];
> > +	struct mmu_interval_notifier_pass p;
> > +};
> > +
> > +static struct mmu_interval_notifier_pass *
> > +xe_svm_invalidate_second(struct mmu_interval_notifier_pass *p,
> > +			 const struct mmu_notifier_range
> > *mmu_range,
> > +			 unsigned long cur_seq)
> > +{
> > +	struct xe_svm_invalidate_pass *pass =3D container_of(p,
> > typeof(*pass), p);
> > +	struct drm_gpusvm *gpusvm =3D pass->gpusvm;
> > +	struct drm_gpusvm_notifier *notifier =3D pass->notifier;
> > +	struct drm_gpusvm_range *r =3D NULL;
> > +	struct xe_vm *vm =3D gpusvm_to_vm(gpusvm);
> > +	u64 adj_start =3D mmu_range->start, adj_end =3D mmu_range-
> > >end;
> > +	int id;
> > +
> > +	/* Adjust invalidation to notifier boundaries */
> > +	adj_start =3D max(drm_gpusvm_notifier_start(notifier),
> > adj_start);
> > +	adj_end =3D min(drm_gpusvm_notifier_end(notifier), adj_end);
> > +
> > +	for (id =3D 0; id < XE_SVM_INVALIDATE_FENCE_COUNT; ++id)
> > +		xe_gt_tlb_invalidation_fence_wait(&pass-
> > >fences[id]);
> > +
> > +	drm_gpusvm_in_notifier_lock(gpusvm);
> > +	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
> > +		xe_svm_range_notifier_event_end(vm, r, mmu_range);
> > +	drm_gpusvm_in_notifier_unlock(gpusvm);
> > +
> > +	kfree(pass);
> > +	return NULL;
> > +}
> > +
> > =C2=A0static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct drm_gpusvm_notifier
> > *notifier,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct
> > mmu_notifier_range *mmu_range,
> > @@ -179,6 +216,8 @@ static void xe_svm_invalidate_twopass(struct
> > drm_gpusvm *gpusvm,
> > =C2=A0	struct xe_vm *vm =3D gpusvm_to_vm(gpusvm);
> > =C2=A0	struct xe_device *xe =3D vm->xe;
> > =C2=A0	struct drm_gpusvm_range *r, *first;
> > +	struct xe_svm_invalidate_pass *pass =3D NULL;
> > +	struct xe_gt_tlb_invalidation_fence *fences =3D NULL;
> > =C2=A0	u64 adj_start =3D mmu_range->start, adj_end =3D mmu_range-
> > >end;
> > =C2=A0	u8 tile_mask =3D 0;
> > =C2=A0	long err;
> > @@ -226,14 +265,25 @@ static void xe_svm_invalidate_twopass(struct
> > drm_gpusvm *gpusvm,
> > =C2=A0
> > =C2=A0	xe_device_wmb(xe);
> > =C2=A0
> > -	err =3D xe_vm_range_tilemask_tlb_invalidation(vm, NULL,
> > adj_start,
> > +	pass =3D kzalloc(sizeof(*pass), GFP_NOWAIT);
> > +	if (pass) {
> > +		pass->gpusvm =3D gpusvm;
> > +		pass->notifier =3D notifier;
> > +		pass->p.pass =3D xe_svm_invalidate_second;
> > +		fences =3D pass->fences;
> > +		*p =3D &pass->p;
> > +	}
> > +
> > +	err =3D xe_vm_range_tilemask_tlb_invalidation(vm, fences,
> > adj_start,
> > =C2=A0						=C2=A0=C2=A0=C2=A0 adj_end,
> > tile_mask);
> > =C2=A0	WARN_ON_ONCE(err);
> > =C2=A0
> > =C2=A0range_notifier_event_end:
> > -	r =3D first;
> > -	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
> > -		xe_svm_range_notifier_event_end(vm, r, mmu_range);
> > +	if (!pass) {
> > +		r =3D first;
> > +		drm_gpusvm_for_each_range(r, notifier, adj_start,
> > adj_end)
> > +			xe_svm_range_notifier_event_end(vm, r,
> > mmu_range);
> > +	}
> > =C2=A0}
> > =C2=A0
> > =C2=A0static int __xe_svm_garbage_collector(struct xe_vm *vm,
> > --=20
> > 2.50.1
> >=20


