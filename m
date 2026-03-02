Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B26EB3636
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7CE6B015E; Mon,  2 Mar 2026 16:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8B26B010A; Mon,  2 Mar 2026 16:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250196B0165; Mon,  2 Mar 2026 16:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 095296B015E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:22:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96A44140328
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:22:23 +0000 (UTC)
X-FDA: 84502396566.23.2B5C056
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf20.hostedemail.com (Postfix) with ESMTP id 204951C000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:22:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=el+pUelk;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772486541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyBDyEmhoUChWV+Oc0BDRMniuTZ+yA7BMsw+sSt7M0g=;
	b=SKyAAeyG4p2vTiOB2l1EImH41Iq1yuo9nzDJh1RkgY04Mu+qs6B60KoPA/dUTlC8YQVICP
	00R8skxLsApfDtcaL3kAlWVA+5VnoQSmOyJ6TghgvIPDdYUYCNjNhpI2DRZvF7fGOTxcKC
	+e42foMo8KJxh127XvnPco4FE1sqA0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772486541; a=rsa-sha256;
	cv=none;
	b=2y38w0kx5QH/k/YWoWIAAJ5DNMUtfC7U7SYTWkPuCZS+DAboKyxPcZbaEOkiDKWRuRTg7P
	Z6iK7zYra9DK3rrEhOi2ucPn1oHeo5N3CGaZySXfI08dbcp4vGMgLhBi1EgFtX4qqKbccW
	dCbvBm5ZlOSzvg2Qxp/YmwR6pBS0N+o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=el+pUelk;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772486541; x=1804022541;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=f/e5Tehw6eA5fElB8GaO/rxQQYRpEl9y+pGXhsCpQ1g=;
  b=el+pUelkldPRQzWxhu8sF8M+zn5pH9APIt76si1ZkEibqYCXsVTtnbTT
   hMvBqAdT1rgDiavWDnuBAUspV+7IP7SLQWojLCymLC88s149jpbKPcago
   jkhshwRNsY06gSl2hBlwmxWOPo9bKs2+gFIdfW7xHfuyruUKgznbb3pol
   shIpSZPOAfS/xLqLiwUtfEUlvy6p6BFil6Z5ZN0Ik6UhOIw5vpnWa45ul
   J1QhgLu7c6SIeDj8qkl9QJKaWopejnwbKS6YPm3oXTT+8FU4+FjeCA+al
   zJjJmpdDi6tQ6x74f5N7TOln7Oi4ixncAt/SFRX/+Ogs018bUBJKI6fM1
   Q==;
X-CSE-ConnectionGUID: J6B1Co+KSV2l8B+CmlH80w==
X-CSE-MsgGUID: L70jljzlQGinZeAslYtcXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="98979970"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="98979970"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:22:18 -0800
X-CSE-ConnectionGUID: 3vqktu9iSuaSf1gkT18xTA==
X-CSE-MsgGUID: uBWSnj6mTPadCZlUFrcNlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="214188708"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.183]) ([10.245.244.183])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:22:16 -0800
Message-ID: <1722945c1b8a99bd9386b82a109e3308197fe914.camel@linux.intel.com>
Subject: Re: [PATCH v2 2/4] drm/xe/userptr: Convert invalidation to two-pass
 MMU notifier
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org, Jason
 Gunthorpe	 <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 Alistair Popple	 <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Mon, 02 Mar 2026 22:22:13 +0100
In-Reply-To: <aaXdsiRlux/cZ6WC@lstrano-desk.jf.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
	 <20260302163248.105454-3-thomas.hellstrom@linux.intel.com>
	 <aaXdsiRlux/cZ6WC@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 204951C000E
X-Stat-Signature: hoq4obgfjgpq4jp1bu3gt35bjbni8ay3
X-Rspam-User: 
X-HE-Tag: 1772486540-451
X-HE-Meta: U2FsdGVkX19hbcQZxLlk/1poNqlEp/+CMASAuuQWuD8hG00XTl3emk899napojcIZyM7HOGmQKOtbylJoVxe2PvdBXENTjU90KF7zoYDxsPTsz3KJksS7T8fd9zH18uYdR4XH4nwQt4u1vqlp3OzBfcXDaL7b0Vp28URGEyhzG343TOUuIyA9FX0bhU3CTqXfkAn3Tjp6VGf0xYY9Ds5CBhQGiksxwp/X29li9Q/2bgZIqpeXvfXKICigVvb9y6k7TkjIXiUQw7+zZbqb55dP4RHJTmw/4nEGSzz4jStzFXvpXRa9vkvfQidm+EopS3u7p3ZjM+AsYyuGhZKHaO7kLqkEDyraPyTkYTv69m60ofhOxaEF+RQa5BO/FX8E4jfZqcvQORMTPAVmDS8Bd0phTzju2xLXxp/3X9E/k7dLWponMm1zdS5qdM2Es401imjpAKldDASZqmeXaHN+bjGPKIXSZQIxg6BJJkS1i3bG9VEvfTQpD81UuTY5g3e5kCXBLj+b0V1ajcS8yw+3dZPYGkze4Bss49VKDFs6J6sQA9RcXakqX8f1eKWS70aGijbTsJGyhVMtucGJAm89WIwGILeBdNJ8Unl1DOuw3CCcEYQ698v5jzyjlv4ESLoUbNMx89hHpVeqODcyTspOjbXUqJi/qGxR+HoP2BP9W08kR/I4lN01COnw7BmpE7C3dfjVQV/eqYxg/bXiQSsOrje0NO483whDMAWDb7GePF7hRvi74sIEVjZGi9flwlgJ/U5QjPXHV4b2x0zStoko2aBv9KbTnnNMh6Ky3ltB4KCjAQ6d4+vnaK/+/IOkV+eRQ6HnAKitvzrpr3EhIjih9pNA1VrbXOKW49rUWak+FblFHpcTyMCtwc+gPlvN7ro+D9cihAGwRI47Lpl68VMVGdJhXu0eTJwmMkU7I44wjzgl7Mc3F98DNVTmfib0xzC8tM98Ka1e62dalUUv8uM8D3
 AaEXuPiC
 IN8XxULoLm8rN5foV2MVD6+nt286u9J/rhwFsICbBlkxMIF0607HLd2IekkrK8ZEdBvZStWe2+deU9Uf6V8zJoOliubml4F5FDvx8SUdqVnMVcqYyvOGiVEvatQyGM48CEghp/FdPTLdejwSqRJqHGJtxjLWOB2PL3MaA/wzZHl85katQ+T/qoWD1NDOMHExPoEe7djV690+2xWom40hM+Agm5gUsECLLBSUDZ08OLvvpeGr6wJ6gn7i7YnXl1UBIe513Ed40a0j+NF2+v0vYe+8eog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, 2026-03-02 at 10:57 -0800, Matthew Brost wrote:

Thanks for reviewing,

> On Mon, Mar 02, 2026 at 05:32:46PM +0100, Thomas Hellstr=C3=B6m wrote:
> > In multi-GPU scenarios, asynchronous GPU job latency is a
> > bottleneck if
> > each notifier waits for its own GPU before returning. The two-pass
> > mmu_interval_notifier infrastructure allows deferring the wait to a
> > second pass, so all GPUs can be signalled in the first pass before
> > any of them are waited on.
> >=20
> > Convert the userptr invalidation to use the two-pass model:
> >=20
> > Use invalidate_start as the first pass to mark the VMA for repin
> > and
> > enable software signalling on the VM reservation fences to start
> > any
> > gpu work needed for signaling. Fall back to completing the work
> > synchronously if all fences are already signalled, or if a
> > concurrent
> > invalidation is already using the embedded finish structure.
> >=20
> > Use invalidate_finish as the second pass to wait for the
> > reservation
> > fences to complete, invalidate the GPU TLB in fault mode, and unmap
> > the gpusvm pages.
> >=20
> > Embed a struct mmu_interval_notifier_finish in struct xe_userptr to
> > avoid dynamic allocation in the notifier callback. Use a
> > finish_inuse
> > flag to prevent two concurrent invalidations from using it
> > simultaneously; fall back to the synchronous path for the second
> > caller.
> >=20
>=20
> A couple nits below. Also for clarity, I'd probably rework this
> series...
>=20
> =C2=A0- Move patch #3 to 2nd to patch
> =C2=A0- Squash patch #2, #4 into a single patch, make thia the last patch
>=20
> Let me know what you think on the reordering. I'm looking with the
> series applied and aside from nits below everything in xe_userptr.c
> looks good to me.

We could do that, but unless you insist, I'd like to keep the current
ordering since patch #2 is a very simple example on how to convert and
also since #4 makes the notifier rather complex so it'd be good to
be able to bisect in between those two.

> =C2=A0
> > Assisted-by: GitHub Copilot:claude-sonnet-4.6
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > ---
> > =C2=A0drivers/gpu/drm/xe/xe_userptr.c | 96 +++++++++++++++++++++++++---=
-
> > ----
> > =C2=A0drivers/gpu/drm/xe/xe_userptr.h | 14 +++++
> > =C2=A02 files changed, 88 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/xe/xe_userptr.c
> > b/drivers/gpu/drm/xe/xe_userptr.c
> > index e120323c43bc..440b0a79d16f 100644
> > --- a/drivers/gpu/drm/xe/xe_userptr.c
> > +++ b/drivers/gpu/drm/xe/xe_userptr.c
> > @@ -73,18 +73,42 @@ int xe_vma_userptr_pin_pages(struct
> > xe_userptr_vma *uvma)
> > =C2=A0				=C2=A0=C2=A0=C2=A0 &ctx);
> > =C2=A0}
> > =C2=A0
> > -static void __vma_userptr_invalidate(struct xe_vm *vm, struct
> > xe_userptr_vma *uvma)
> > +static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct
> > xe_userptr_vma *uvma,
> > +				=C2=A0=C2=A0=C2=A0 bool is_deferred)
> > =C2=A0{
> > =C2=A0	struct xe_userptr *userptr =3D &uvma->userptr;
> > =C2=A0	struct xe_vma *vma =3D &uvma->vma;
> > -	struct dma_resv_iter cursor;
> > -	struct dma_fence *fence;
> > =C2=A0	struct drm_gpusvm_ctx ctx =3D {
> > =C2=A0		.in_notifier =3D true,
> > =C2=A0		.read_only =3D xe_vma_read_only(vma),
> > =C2=A0	};
> > =C2=A0	long err;
> > =C2=A0
>=20
> xe_svm_assert_in_notifier(vm);

This actually reveals a pre-existing bug. Since this code
is called with the notifier lock held in read mode, and
the vm resv held in the userptr invalidation injection.
That assert would hit.


Also drm_gpusvm_unmap_pages() below will assert the same thing, (also
affected by the bug)
but for clarity I agree we might want to have an assert here, but then
it would need to include the other mode as well, and I'd need to update
the locking docs for the two-pass state.

>=20
> > +	err =3D dma_resv_wait_timeout(xe_vm_resv(vm),
> > +				=C2=A0=C2=A0=C2=A0 DMA_RESV_USAGE_BOOKKEEP,
> > +				=C2=A0=C2=A0=C2=A0 false, MAX_SCHEDULE_TIMEOUT);
> > +	XE_WARN_ON(err <=3D 0);
> > +
> > +	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> > +		err =3D xe_vm_invalidate_vma(vma);
> > +		XE_WARN_ON(err);
> > +	}
> > +
> > +	if (is_deferred)
> > +		userptr->finish_inuse =3D false;
> > +	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > >userptr.pages,
> > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe_vma_size(vma) >> PAGE_SHIFT=
,
> > &ctx);
> > +}
> > +
> > +static struct mmu_interval_notifier_finish *
> > +xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct
> > xe_userptr_vma *uvma)
> > +{
> > +	struct xe_userptr *userptr =3D &uvma->userptr;
> > +	struct xe_vma *vma =3D &uvma->vma;
> > +	struct dma_resv_iter cursor;
> > +	struct dma_fence *fence;
> > +	bool signaled =3D true;
> > +
>=20
> xe_svm_assert_in_notifier(vm);

Same here.

>=20
> > =C2=A0	/*
> > =C2=A0	 * Tell exec and rebind worker they need to repin and
> > rebind this
> > =C2=A0	 * userptr.
> > @@ -105,27 +129,32 @@ static void __vma_userptr_invalidate(struct
> > xe_vm *vm, struct xe_userptr_vma *uv
> > =C2=A0	 */
> > =C2=A0	dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
> > =C2=A0			=C2=A0=C2=A0=C2=A0 DMA_RESV_USAGE_BOOKKEEP);
> > -	dma_resv_for_each_fence_unlocked(&cursor, fence)
> > +	dma_resv_for_each_fence_unlocked(&cursor, fence) {
> > =C2=A0		dma_fence_enable_sw_signaling(fence);
> > +		if (signaled && !dma_fence_is_signaled(fence))
> > +			signaled =3D false;
> > +	}
> > =C2=A0	dma_resv_iter_end(&cursor);
> > =C2=A0
> > -	err =3D dma_resv_wait_timeout(xe_vm_resv(vm),
> > -				=C2=A0=C2=A0=C2=A0 DMA_RESV_USAGE_BOOKKEEP,
> > -				=C2=A0=C2=A0=C2=A0 false, MAX_SCHEDULE_TIMEOUT);
> > -	XE_WARN_ON(err <=3D 0);
> > -
> > -	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> > -		err =3D xe_vm_invalidate_vma(vma);
> > -		XE_WARN_ON(err);
> > +	/*
> > +	 * Only one caller at a time can use the multi-pass state.
> > +	 * If it's already in use, or all fences are already
> > signaled,
> > +	 * proceed directly to invalidation without deferring.
> > +	 */
> > +	if (signaled || userptr->finish_inuse) {
> > +		xe_vma_userptr_do_inval(vm, uvma, false);
> > +		return NULL;
> > =C2=A0	}
> > =C2=A0
> > -	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > >userptr.pages,
> > -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe_vma_size(vma) >> PAGE_SHIFT=
,
> > &ctx);
> > +	userptr->finish_inuse =3D true;
> > +
> > +	return &userptr->finish;
> > =C2=A0}
> > =C2=A0
> > -static bool vma_userptr_invalidate(struct mmu_interval_notifier
> > *mni,
> > -				=C2=A0=C2=A0 const struct mmu_notifier_range
> > *range,
> > -				=C2=A0=C2=A0 unsigned long cur_seq)
> > +static bool xe_vma_userptr_invalidate_start(struct
> > mmu_interval_notifier *mni,
> > +					=C2=A0=C2=A0=C2=A0 const struct
> > mmu_notifier_range *range,
> > +					=C2=A0=C2=A0=C2=A0 unsigned long cur_seq,
> > +					=C2=A0=C2=A0=C2=A0 struct
> > mmu_interval_notifier_finish **p_finish)
> > =C2=A0{
> > =C2=A0	struct xe_userptr_vma *uvma =3D container_of(mni,
> > typeof(*uvma), userptr.notifier);
> > =C2=A0	struct xe_vma *vma =3D &uvma->vma;
> > @@ -138,21 +167,40 @@ static bool vma_userptr_invalidate(struct
> > mmu_interval_notifier *mni,
> > =C2=A0		return false;
> > =C2=A0
> > =C2=A0	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> > -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "NOTIFIER: addr=3D0x%016llx, ran=
ge=3D0x%016llx",
> > +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "NOTIFIER PASS1: addr=3D0x%016ll=
x, range=3D0x%016llx",
> > =C2=A0		xe_vma_start(vma), xe_vma_size(vma));
> > =C2=A0
> > =C2=A0	down_write(&vm->svm.gpusvm.notifier_lock);
> > =C2=A0	mmu_interval_set_seq(mni, cur_seq);
> > =C2=A0
> > -	__vma_userptr_invalidate(vm, uvma);
> > +	*p_finish =3D xe_vma_userptr_invalidate_pass1(vm, uvma);
> > +
> > =C2=A0	up_write(&vm->svm.gpusvm.notifier_lock);
> > -	trace_xe_vma_userptr_invalidate_complete(vma);
> > +	if (!*p_finish)
> > +		trace_xe_vma_userptr_invalidate_complete(vma);
> > =C2=A0
> > =C2=A0	return true;
> > =C2=A0}
> > =C2=A0
> > +static void xe_vma_userptr_invalidate_finish(struct
> > mmu_interval_notifier_finish *finish)
> > +{
> > +	struct xe_userptr_vma *uvma =3D container_of(finish,
> > typeof(*uvma), userptr.finish);
> > +	struct xe_vma *vma =3D &uvma->vma;
> > +	struct xe_vm *vm =3D xe_vma_vm(vma);
> > +
> > +	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> > +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "NOTIFIER PASS2: addr=3D0x%016ll=
x, range=3D0x%016llx",
> > +		xe_vma_start(vma), xe_vma_size(vma));
> > +
> > +	down_write(&vm->svm.gpusvm.notifier_lock);
> > +	xe_vma_userptr_do_inval(vm, uvma, true);
> > +	up_write(&vm->svm.gpusvm.notifier_lock);
> > +	trace_xe_vma_userptr_invalidate_complete(vma);
> > +}
> > +
> > =C2=A0static const struct mmu_interval_notifier_ops
> > vma_userptr_notifier_ops =3D {
> > -	.invalidate =3D vma_userptr_invalidate,
> > +	.invalidate_start =3D xe_vma_userptr_invalidate_start,
> > +	.invalidate_finish =3D xe_vma_userptr_invalidate_finish,
> > =C2=A0};
> > =C2=A0
> > =C2=A0#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
> > @@ -164,6 +212,7 @@ static const struct mmu_interval_notifier_ops
> > vma_userptr_notifier_ops =3D {
> > =C2=A0 */
> > =C2=A0void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
> > =C2=A0{
> > +	static struct mmu_interval_notifier_finish *finish;
> > =C2=A0	struct xe_vm *vm =3D xe_vma_vm(&uvma->vma);
> > =C2=A0
> > =C2=A0	/* Protect against concurrent userptr pinning */
> > @@ -179,7 +228,10 @@ void xe_vma_userptr_force_invalidate(struct
> > xe_userptr_vma *uvma)
> > =C2=A0	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 uvma-
> > >userptr.pages.notifier_seq))
> > =C2=A0		uvma->userptr.pages.notifier_seq -=3D 2;
> > -	__vma_userptr_invalidate(vm, uvma);
> > +
> > +	finish =3D xe_vma_userptr_invalidate_pass1(vm, uvma);
> > +	if (finish)
> > +		xe_vma_userptr_do_inval(vm, uvma, true);
> > =C2=A0}
> > =C2=A0#endif
> > =C2=A0
> > diff --git a/drivers/gpu/drm/xe/xe_userptr.h
> > b/drivers/gpu/drm/xe/xe_userptr.h
> > index ef801234991e..4f42db61fd62 100644
> > --- a/drivers/gpu/drm/xe/xe_userptr.h
> > +++ b/drivers/gpu/drm/xe/xe_userptr.h
> > @@ -57,12 +57,26 @@ struct xe_userptr {
> > =C2=A0	 */
> > =C2=A0	struct mmu_interval_notifier notifier;
> > =C2=A0
> > +	/**
> > +	 * @finish: MMU notifier finish structure for two-pass
> > invalidation.
> > +	 * Embedded here to avoid allocation in the notifier
> > callback.
> > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
> > +	 */
> > +	struct mmu_interval_notifier_finish finish;
> > +	/**
> > +	 * @finish_inuse: Whether @finish is currently in use by
> > an in-progress
> > +	 * two-pass invalidation.
> > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
> > +	 */
> > +	bool finish_inuse;
> > +
> > =C2=A0	/**
> > =C2=A0	 * @initial_bind: user pointer has been bound at least
> > once.
> > =C2=A0	 * write: vm->svm.gpusvm.notifier_lock in read mode and
> > vm->resv held.
> > =C2=A0	 * read: vm->svm.gpusvm.notifier_lock in write mode or vm-
> > >resv held.
> > =C2=A0	 */
> > =C2=A0	bool initial_bind;
> > +
>=20
> Unrelated.

Sure. Will fix.

Thanks,
Thomas



>=20
> Matt
>=20
> > =C2=A0#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
> > =C2=A0	u32 divisor;
> > =C2=A0#endif
> > --=20
> > 2.53.0
> >=20

