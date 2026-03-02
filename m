Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7654CEB3637
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71C86B0167; Mon,  2 Mar 2026 16:33:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25036B0168; Mon,  2 Mar 2026 16:33:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49476B0169; Mon,  2 Mar 2026 16:33:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 966406B0167
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AE8A16034C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:33:33 +0000 (UTC)
X-FDA: 84502424706.18.3ACC5A6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDF70140004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:33:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNzUEljE;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tc8tYrPfP2gVPnv1hf0d7SBZVCbJrs3su/IEuIjWmD4=;
	b=pHh7+u6Vq5alrQI8ZIYXneS7DW9JDU6QGboEQ0z+W4S9z4EYZ8sHpDNrJmFg91mkyWaze6
	TRJabCijCusguDozyr+XLwWG3GLjOu8sY2q6427UTStMlC6obI1kQhWlC29q0cpr1XeO5Q
	w83nr5dSCzKroPr354tya9+p9bOeHYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772487211; a=rsa-sha256;
	cv=none;
	b=52FyTEzpvpuTEDQ8v1M+bbGx7l6rBvGMF78nv7uKFGaNdMsY2z7alEOpI6zBDwKneKLSgQ
	BFuIqyt8eJ+C87shZ9vAQGJjUBhAbirclocEKxmtjQB7CLYYYfXPuOWT42x8XKgPN3s7cg
	unRCJRkcVLq36UbU1G1ujQLNWbYIQBQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNzUEljE;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772487211; x=1804023211;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LZxIosRq4lQs18rEB7ozia74wMHgUHayh9CXSZmnCV4=;
  b=GNzUEljEKBb4WOq4G+v2CPvOrW3bHlDHk11JxvOLWOiygPaiQdan6GWm
   R7TNJeWktbjsGHBxf++EwzkFFI8yH5OUEqgJAx5c0vLKc/oPrGUOe9qXd
   +p66O2BnYLf1UTaT0W8GWILNphm2VBOhXXWkWiHnvU9H3Le21i7B9vlpY
   YjLV6yTUOzmVyjGTrGGJbAgJ+3lfJnDHACvBfmfhubBnZOnKfVXV202hc
   xWgTNc50GxCuPTlED8/mJdXD8++4um4srYLPpVtXQ6vm38xSvFy3ZtLWa
   bayb86YfES54wFk6OuVvs2kkEkWx3cgfVMNaG+PCMmoSMZiYi7926kC87
   g==;
X-CSE-ConnectionGUID: h/gOEzpUQkCU/mFwT1Vmng==
X-CSE-MsgGUID: /oxi3TrkSpuOVSt2s9Cb/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73212877"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73212877"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:33:28 -0800
X-CSE-ConnectionGUID: hDgtmLUoS5WeedhE79/wEw==
X-CSE-MsgGUID: e4P3ROA6SbiU7uStVtFT0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="215370415"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.183]) ([10.245.244.183])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:33:25 -0800
Message-ID: <3419e00ff2278a63bea5b175894646174dff2ec5.camel@linux.intel.com>
Subject: Re: [PATCH v2 4/4] drm/xe/userptr: Defer Waiting for TLB
 invalidation to the second pass if possible
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org, Jason
 Gunthorpe	 <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 Alistair Popple	 <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Mon, 02 Mar 2026 22:33:23 +0100
In-Reply-To: <aaXhp1EhwE275kla@lstrano-desk.jf.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
	 <20260302163248.105454-5-thomas.hellstrom@linux.intel.com>
	 <aaXhp1EhwE275kla@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: jw6ed6j7hhq44zb9wo7jq31gx3u61hn7
X-Rspam-User: 
X-Rspamd-Queue-Id: BDF70140004
X-Rspamd-Server: rspam12
X-HE-Tag: 1772487210-725957
X-HE-Meta: U2FsdGVkX1+E6cscq+JW/sN1QtkvEkK0Uv585jM41uQefv3tK7E2giB9rhb7Hv8jfRWkaQLf4zCnx5BCuW6EIBMiokPJktDpaBceclhC3Vj4XqXVL++n84zGYIFP8wVjtU5IAvyXDg3FsI4FZcs99YBXQrkHHwN34h6T9FEbEGkjRCW0tuvRXOPBlAnvNJuDtowG93alZUvvI7z6Nm6X6K07r5GjnFI4u+EszuLE19NwUx/i23i5ZK/rrjfqkyxz41vbNMp78gJx562unDP8zw0owvnfTRyZM5g3cI1vUa4KKkN+xolBe0F/06z7i4uaLwa7H//0K9/EAxLF1khdQJ4Ct4Iyamud3L2uYUcJTMJy68TA45/2OztLyWYX30rVcZzvn8461pdgCrIJUb2q5cLJgvDmq/niDfGURwB77cVJDjr9Wio3Js2alI2kjodBewEmjg3d/4DuFeaTI1rclDZhrXHSojeR6oNS25JJ4tmKqgVny6rasQAhrxnd5WgTSVs+ucHKIpdrVC8VWYXdIGFAo/+RQ+cgAyzUL92OJREiu20RPTrGEZCGhHE03suYVYk/IouXH7e0E3zTRapUSQAssmKrn/ZAWwF5Jc4iYp6mwvTLGIELuCK+Kn6S2DYT9WkqwKK6Dzl57bXbNtSDrVOjsFrdwewAG1w/ToZfv+YSZys5uTwogxu5eamTYEexWA7eBd5+FS0xVVowrBDHK8LYOxZdAByRF38i9P8yz3dVLTeI0Mi9sALlg3ZSQXWyQmBDP11zwLKd1sP/KEO0O0vnsahSoZ7+RzyGZXoqfaSck1YjUTzKxESEh99bDH9tVPpD5N6/Q+qtTupGiuVPsC0/iIV1Ke20BNM9TfYLodD4BHmWLMUTezOMqXpepsQw6RZwWPWUPjCRAObkod/pbKAyWxaqNppOv/ARYCqOo3jMawR4MwL4y9t3WWJEyAtv3mbjkM7KRGOj1juBKvZ
 J1cGi05z
 snkP/RoMbIiVwPx9DRo+hWQ4uFmzFnj6kP/NsguNZ6BcC4R8y8zcXxFRZs8ziRoR0pqBx6OkvBAoI4bsHVj/qtUy/Cn1HQxspBJ8xY4Dxo33rUavSa8nsWkbZgKbFOoEpgCUXyQt6Zz2cbQrZyOWDffhrCbKmsnBtRI08s6oWl9ICCcyfvsib8kKjmm+nLHd6ToCZ2dbDBBNU5S23+wa1HoqDL7iKFpoEPCHxWnIyu7Qf/3uO3jKOy5Y+59VulM9oseA9YxP8vqR1SiXmUHOyAI53gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-03-02 at 11:14 -0800, Matthew Brost wrote:
> On Mon, Mar 02, 2026 at 05:32:48PM +0100, Thomas Hellstr=C3=B6m wrote:
> > Now that the two-pass notifier flow uses xe_vma_userptr_do_inval()
> > for
> > the fence-wait + TLB-invalidate work, extend it to support a
> > further
> > deferred TLB wait:
> >=20
> > - xe_vma_userptr_do_inval(): when the embedded finish handle is
> > free,
> > =C2=A0 submit the TLB invalidation asynchronously
> > (xe_vm_invalidate_vma_submit)
> > =C2=A0 and return &userptr->finish so the mmu_notifier core schedules a
> > third
> > =C2=A0 pass.=C2=A0 When the handle is occupied by a concurrent invalida=
tion,
> > fall
> > =C2=A0 back to the synchronous xe_vm_invalidate_vma() path.
> >=20
> > - xe_vma_userptr_complete_tlb_inval(): new helper called from
> > =C2=A0 invalidate_finish when tlb_inval_submitted is set.=C2=A0 Waits f=
or the
> > =C2=A0 previously submitted batch and unmaps the gpusvm pages.
> >=20
> > xe_vma_userptr_invalidate_finish() dispatches between the two
> > helpers
> > via tlb_inval_submitted, making the three possible flows explicit:
> >=20
> > =C2=A0 pass1 (fences pending)=C2=A0 -> invalidate_finish -> do_inval (s=
ync
> > TLB)
> > =C2=A0 pass1 (fences done)=C2=A0=C2=A0=C2=A0=C2=A0 -> do_inval -> inval=
idate_finish
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 -> complete_tlb_inval (deferred TLB)
> > =C2=A0 pass1 (finish occupied) -> do_inval (sync TLB, inline)
> >=20
> > In multi-GPU scenarios this allows TLB flushes to be submitted on
> > all
> > GPUs in one pass before any of them are waited on.
> >=20
> > Also adds xe_vm_invalidate_vma_submit() which submits the TLB range
> > invalidation without blocking, populating a xe_tlb_inval_batch that
> > the caller waits on separately.
> >=20
>=20
> As suggested in patch #2, maybe squash this into patch #2 as some of
> patch #2 is immediately tweaked / rewritten here.=20
>=20
> A couple nits.
>=20
> > Assisted-by: GitHub Copilot:claude-sonnet-4.6
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > ---
> > =C2=A0drivers/gpu/drm/xe/xe_userptr.c | 60 +++++++++++++++++++++++++++-=
-
> > ----
> > =C2=A0drivers/gpu/drm/xe/xe_userptr.h | 18 ++++++++++
> > =C2=A0drivers/gpu/drm/xe/xe_vm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 38 +++=
+++++++++++++-----
> > =C2=A0drivers/gpu/drm/xe/xe_vm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
2 ++
> > =C2=A04 files changed, 99 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/xe/xe_userptr.c
> > b/drivers/gpu/drm/xe/xe_userptr.c
> > index 440b0a79d16f..a62b796afb93 100644
> > --- a/drivers/gpu/drm/xe/xe_userptr.c
> > +++ b/drivers/gpu/drm/xe/xe_userptr.c
> > @@ -8,6 +8,7 @@
> > =C2=A0
> > =C2=A0#include <linux/mm.h>
> > =C2=A0
> > +#include "xe_tlb_inval.h"
> > =C2=A0#include "xe_trace_bo.h"
> > =C2=A0
> > =C2=A0/**
> > @@ -73,8 +74,8 @@ int xe_vma_userptr_pin_pages(struct
> > xe_userptr_vma *uvma)
> > =C2=A0				=C2=A0=C2=A0=C2=A0 &ctx);
> > =C2=A0}
> > =C2=A0
> > -static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct
> > xe_userptr_vma *uvma,
> > -				=C2=A0=C2=A0=C2=A0 bool is_deferred)
> > +static struct mmu_interval_notifier_finish *
> > +xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma
> > *uvma, bool is_deferred)
> > =C2=A0{
> > =C2=A0	struct xe_userptr *userptr =3D &uvma->userptr;
> > =C2=A0	struct xe_vma *vma =3D &uvma->vma;
> > @@ -84,12 +85,23 @@ static void xe_vma_userptr_do_inval(struct
> > xe_vm *vm, struct xe_userptr_vma *uvm
> > =C2=A0	};
> > =C2=A0	long err;
> > =C2=A0
> > -	err =3D dma_resv_wait_timeout(xe_vm_resv(vm),
> > -				=C2=A0=C2=A0=C2=A0 DMA_RESV_USAGE_BOOKKEEP,
> > +	err =3D dma_resv_wait_timeout(xe_vm_resv(vm),
> > DMA_RESV_USAGE_BOOKKEEP,
> > =C2=A0				=C2=A0=C2=A0=C2=A0 false, MAX_SCHEDULE_TIMEOUT);
>=20
> Unrelated.

Right, will fix.

>=20
> > =C2=A0	XE_WARN_ON(err <=3D 0);
> > =C2=A0
> > =C2=A0	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> > +		if (!userptr->finish_inuse) {
>=20
> Since this is state machiney - should we have asserts on state? That
> typically the approach I take when I write stae machiney code. Self
> documenting plus immediatelt catches misuse.
>=20
> So here an example would be:
>=20
> xe_assert(.., !userptr->tlb_inval_submitted);

Sure. Can take a look at that to see how it turns out.


> =C2=A0
> > +			/*
> > +			 * Defer the TLB wait to an extra pass so
> > the caller
> > +			 * can pipeline TLB flushes across GPUs
> > before waiting
> > +			 * on any of them.
> > +			 */
> > +			userptr->finish_inuse =3D true;
> > +			userptr->tlb_inval_submitted =3D true;
> > +			err =3D xe_vm_invalidate_vma_submit(vma,
> > &userptr->inval_batch);
> > +			XE_WARN_ON(err);
> > +			return &userptr->finish;
> > +		}
> > =C2=A0		err =3D xe_vm_invalidate_vma(vma);
> > =C2=A0		XE_WARN_ON(err);
> > =C2=A0	}
> > @@ -98,6 +110,24 @@ static void xe_vma_userptr_do_inval(struct
> > xe_vm *vm, struct xe_userptr_vma *uvm
> > =C2=A0		userptr->finish_inuse =3D false;
> > =C2=A0	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > >userptr.pages,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe_vma_size(vma) >> PAGE_=
SHIFT,
> > &ctx);
> > +	return NULL;
> > +}
> > +
> > +static void
> > +xe_vma_userptr_complete_tlb_inval(struct xe_vm *vm, struct
> > xe_userptr_vma *uvma)
> > +{
> > +	struct xe_userptr *userptr =3D &uvma->userptr;
> > +	struct xe_vma *vma =3D &uvma->vma;
> > +	struct drm_gpusvm_ctx ctx =3D {
> > +		.in_notifier =3D true,
> > +		.read_only =3D xe_vma_read_only(vma),
> > +	};
> > +
>=20
> xe_svm_assert_in_notifier();

See previous comment on this.

>=20
> State machine asserts could be:
>=20
> xe_assert(..., userptr->tlb_inval_submitted);
> xe_assert(..., userptr->finish_inuse);

Will take a look at this as well.

>=20
> > +	xe_tlb_inval_batch_wait(&userptr->inval_batch);
> > +	userptr->tlb_inval_submitted =3D false;
> > +	userptr->finish_inuse =3D false;
> > +	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > >userptr.pages,
> > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe_vma_size(vma) >> PAGE_SHIFT=
,
> > &ctx);
> > =C2=A0}
> > =C2=A0
> > =C2=A0static struct mmu_interval_notifier_finish *
> > @@ -141,13 +171,11 @@ xe_vma_userptr_invalidate_pass1(struct xe_vm
> > *vm, struct xe_userptr_vma *uvma)
> > =C2=A0	 * If it's already in use, or all fences are already
> > signaled,
> > =C2=A0	 * proceed directly to invalidation without deferring.
> > =C2=A0	 */
> > -	if (signaled || userptr->finish_inuse) {
> > -		xe_vma_userptr_do_inval(vm, uvma, false);
> > -		return NULL;
> > -	}
> > +	if (signaled || userptr->finish_inuse)
> > +		return xe_vma_userptr_do_inval(vm, uvma, false);
> > =C2=A0
> > +	/* Defer: the notifier core will call invalidate_finish
> > once done. */
> > =C2=A0	userptr->finish_inuse =3D true;
> > -
>=20
> Unrelated.

Will fix.

>=20
> > =C2=A0	return &userptr->finish;
> > =C2=A0}
> > =C2=A0
> > @@ -193,7 +221,15 @@ static void
> > xe_vma_userptr_invalidate_finish(struct
> > mmu_interval_notifier_finish
> > =C2=A0		xe_vma_start(vma), xe_vma_size(vma));
> > =C2=A0
> > =C2=A0	down_write(&vm->svm.gpusvm.notifier_lock);
> > -	xe_vma_userptr_do_inval(vm, uvma, true);
> > +	/*
> > +	 * If a TLB invalidation was previously submitted
> > (deferred from the
> > +	 * synchronous pass1 fallback), wait for it and unmap
> > pages.
> > +	 * Otherwise, fences have now completed: invalidate the
> > TLB and unmap.
> > +	 */
> > +	if (uvma->userptr.tlb_inval_submitted)
> > +		xe_vma_userptr_complete_tlb_inval(vm, uvma);
> > +	else
> > +		xe_vma_userptr_do_inval(vm, uvma, true);
> > =C2=A0	up_write(&vm->svm.gpusvm.notifier_lock);
> > =C2=A0	trace_xe_vma_userptr_invalidate_complete(vma);
> > =C2=A0}
> > @@ -231,7 +267,9 @@ void xe_vma_userptr_force_invalidate(struct
> > xe_userptr_vma *uvma)
> > =C2=A0
> > =C2=A0	finish =3D xe_vma_userptr_invalidate_pass1(vm, uvma);
> > =C2=A0	if (finish)
> > -		xe_vma_userptr_do_inval(vm, uvma, true);
> > +		finish =3D xe_vma_userptr_do_inval(vm, uvma, true);
> > +	if (finish)
> > +		xe_vma_userptr_complete_tlb_inval(vm, uvma);
> > =C2=A0}
> > =C2=A0#endif
> > =C2=A0
> > diff --git a/drivers/gpu/drm/xe/xe_userptr.h
> > b/drivers/gpu/drm/xe/xe_userptr.h
> > index 4f42db61fd62..7477009651c2 100644
> > --- a/drivers/gpu/drm/xe/xe_userptr.h
> > +++ b/drivers/gpu/drm/xe/xe_userptr.h
> > @@ -14,6 +14,8 @@
> > =C2=A0
> > =C2=A0#include <drm/drm_gpusvm.h>
> > =C2=A0
> > +#include "xe_tlb_inval_types.h"
> > +
> > =C2=A0struct xe_vm;
> > =C2=A0struct xe_vma;
> > =C2=A0struct xe_userptr_vma;
> > @@ -63,6 +65,15 @@ struct xe_userptr {
> > =C2=A0	 * Protected by @vm::svm.gpusvm.notifier_lock.
> > =C2=A0	 */
> > =C2=A0	struct mmu_interval_notifier_finish finish;
> > +
> > +	/**
> > +	 * @inval_batch: TLB invalidation batch for deferred
> > completion.
> > +	 * Stores an in-flight TLB invalidation submitted during a
> > two-pass
> > +	 * notifier so the wait can be deferred to a subsequent
> > pass, allowing
> > +	 * multiple GPUs to be signalled before any of them are
> > waited on.
> > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
>=20
> In write mode?

Yeah, This one and the one below will look a bit more complicated if we
want to keep the invalidation injection. Will update.

>=20
> > +	 */
> > +	struct xe_tlb_inval_batch inval_batch;
> > =C2=A0	/**
> > =C2=A0	 * @finish_inuse: Whether @finish is currently in use by
> > an in-progress
> > =C2=A0	 * two-pass invalidation.
> > @@ -70,6 +81,13 @@ struct xe_userptr {
> > =C2=A0	 */
> > =C2=A0	bool finish_inuse;
> > =C2=A0
> > +	/**
> > +	 * @tlb_inval_submitted: Whether a TLB invalidation has
> > been submitted
> > +	 * via @inval_batch and is pending completion.=C2=A0 When set,
> > the next pass
> > +	 * must call xe_tlb_inval_batch_wait() before reusing
> > @inval_batch.
> > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
>=20
> In write mode?
>=20
> Matt

Thanks,
Thomas


>=20
> > +	 */
> > +	bool tlb_inval_submitted;
> > =C2=A0	/**
> > =C2=A0	 * @initial_bind: user pointer has been bound at least
> > once.
> > =C2=A0	 * write: vm->svm.gpusvm.notifier_lock in read mode and
> > vm->resv held.
> > diff --git a/drivers/gpu/drm/xe/xe_vm.c
> > b/drivers/gpu/drm/xe/xe_vm.c
> > index 7f29d2b2972d..fdad9329dfb4 100644
> > --- a/drivers/gpu/drm/xe/xe_vm.c
> > +++ b/drivers/gpu/drm/xe/xe_vm.c
> > @@ -3967,20 +3967,23 @@ void xe_vm_unlock(struct xe_vm *vm)
> > =C2=A0}
> > =C2=A0
> > =C2=A0/**
> > - * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without
> > a lock
> > + * xe_vm_invalidate_vma_submit - Submit a job to invalidate GPU
> > mappings for
> > + * VMA.
> > =C2=A0 * @vma: VMA to invalidate
> > + * @batch: TLB invalidation batch to populate; caller must later
> > call
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe_tlb_inval_batch_=
wait() on it to wait for completion
> > =C2=A0 *
> > =C2=A0 * Walks a list of page tables leaves which it memset the entries
> > owned by this
> > - * VMA to zero, invalidates the TLBs, and block until TLBs
> > invalidation is
> > - * complete.
> > + * VMA to zero, invalidates the TLBs, but doesn't block waiting
> > for TLB flush
> > + * to complete, but instead populates @batch which can be waited
> > on using
> > + * xe_tlb_inval_batch_wait().
> > =C2=A0 *
> > =C2=A0 * Returns 0 for success, negative error code otherwise.
> > =C2=A0 */
> > -int xe_vm_invalidate_vma(struct xe_vma *vma)
> > +int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct
> > xe_tlb_inval_batch *batch)
> > =C2=A0{
> > =C2=A0	struct xe_device *xe =3D xe_vma_vm(vma)->xe;
> > =C2=A0	struct xe_vm *vm =3D xe_vma_vm(vma);
> > -	struct xe_tlb_inval_batch _batch;
> > =C2=A0	struct xe_tile *tile;
> > =C2=A0	u8 tile_mask =3D 0;
> > =C2=A0	int ret =3D 0;
> > @@ -4023,14 +4026,33 @@ int xe_vm_invalidate_vma(struct xe_vma
> > *vma)
> > =C2=A0
> > =C2=A0	ret =3D xe_tlb_inval_range_tilemask_submit(xe,
> > xe_vma_vm(vma)->usm.asid,
> > =C2=A0					=09
> > xe_vma_start(vma), xe_vma_end(vma),
> > -						 tile_mask,
> > &_batch);
> > +						 tile_mask,
> > batch);
> > =C2=A0
> > =C2=A0	/* WRITE_ONCE pairs with READ_ONCE in
> > xe_vm_has_valid_gpu_mapping() */
> > =C2=A0	WRITE_ONCE(vma->tile_invalidated, vma->tile_mask);
> > +	return ret;
> > +}
> > +
> > +/**
> > + * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without
> > a lock
> > + * @vma: VMA to invalidate
> > + *
> > + * Walks a list of page tables leaves which it memset the entries
> > owned by this
> > + * VMA to zero, invalidates the TLBs, and block until TLBs
> > invalidation is
> > + * complete.
> > + *
> > + * Returns 0 for success, negative error code otherwise.
> > + */
> > +int xe_vm_invalidate_vma(struct xe_vma *vma)
> > +{
> > +	struct xe_tlb_inval_batch batch;
> > +	int ret;
> > =C2=A0
> > -	if (!ret)
> > -		xe_tlb_inval_batch_wait(&_batch);
> > +	ret =3D xe_vm_invalidate_vma_submit(vma, &batch);
> > +	if (ret)
> > +		return ret;
> > =C2=A0
> > +	xe_tlb_inval_batch_wait(&batch);
> > =C2=A0	return ret;
> > =C2=A0}
> > =C2=A0
> > diff --git a/drivers/gpu/drm/xe/xe_vm.h
> > b/drivers/gpu/drm/xe/xe_vm.h
> > index 62f4b6fec0bc..0bc7ed23eeae 100644
> > --- a/drivers/gpu/drm/xe/xe_vm.h
> > +++ b/drivers/gpu/drm/xe/xe_vm.h
> > @@ -242,6 +242,8 @@ struct dma_fence *xe_vm_range_unbind(struct
> > xe_vm *vm,
> > =C2=A0
> > =C2=A0int xe_vm_invalidate_vma(struct xe_vma *vma);
> > =C2=A0
> > +int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct
> > xe_tlb_inval_batch *batch);
> > +
> > =C2=A0int xe_vm_validate_protected(struct xe_vm *vm);
> > =C2=A0
> > =C2=A0static inline void xe_vm_queue_rebind_worker(struct xe_vm *vm)
> > --=20
> > 2.53.0
> >=20

