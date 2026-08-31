Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E964C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB96F6B008C; Mon, 31 Aug 2026 06:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69C06B0092; Mon, 31 Aug 2026 06:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FA16B0095; Mon, 31 Aug 2026 06:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A00E6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:43:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 041C816044D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:18 +0000 (UTC)
X-FDA: 85161227718.28.79A28F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6742340004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9qx3Oy+;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788172997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zRiZoEe+cziUvxkvj8KRKsW5kQ9BPFWyKQ48V5U48c=;
	b=kc4OCP2XOj9nRRUymmsl5U0Svyngy5ETD0SnYQQSi77xj9mW9YVctfVXalEOnzrZqPGLsl
	zaFqAsIvmY84i/HQCCiS3UPaMRyOoooO9Zrps+L4eZmBqNpaSowY90kWGth9hnd1hTYSIp
	kOr+MszE1dgoEs6urGAFluq3cDDgfUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788172997;
	b=rf2Hc8jU8qSjESP5LPp1wvuKYlWA3PHq6TiP1Ik2ktUfjz36lviCIs17lSUjqhBeTc9yKu
	QQRyYvKhkEVtzECQ6six1WvBfSObLatGghH1/ox5YVrm9hsNW7c2ZLXRe6pJzDHA6HGXqo
	YsADV3HIQfDqnDq+E0+IKGqGkYBvriI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9qx3Oy+;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C417641A5C;
	Mon, 31 Aug 2026 10:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7AF1F000E9;
	Mon, 31 Aug 2026 10:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788172995;
	bh=1zRiZoEe+cziUvxkvj8KRKsW5kQ9BPFWyKQ48V5U48c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=g9qx3Oy+sEirhBlaPWlATBQb6Wt+QnUbSr1uatSFzBcPbN+Hzm5139c6BIVUd405B
	 hQgDp6gBYQzjJPyxjPW6yEQLBcgIwAI9BY3Dp8HDsSgg9aG/aeiiqzvqU6dgypNN0v
	 +0qsyKBQb5pkem5mHcAPoDc3q0UlDA6jVm92NA5HUjdPbbzcZrvA5oANPXIsfpP18o
	 fRW99ndcB67wuop3tQ+nicsSUvSQxjPUVMk5Ba07fL3XD+iyGVelFq3vA4NJxBEasn
	 Y41838p1p4M4dXkpTI2b+G2zVHOpawy4qFAOrvvqtK8oUFmfeYnLWbU0/6TDjwhKnZ
	 aHrG2wtbCUAwQ==
Content-Type: multipart/mixed; boundary="===============6575441848940488516=="
MIME-Version: 1.0
Message-Id: <2163fb3e4198f7feac29b37aa7c659535eb5d11248f681bb25c3bc97838aa1b0@mail.kernel.org>
In-Reply-To: <20260831092305.42062-7-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-7-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v3 6/7] bpf: Mark linux_binprm->mm as trusted-or-null
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 31 Aug 2026 10:43:14 +0000 (UTC)
X-Stat-Signature: 84h1coybg9jhstoco7toigfzp6szh41u
X-Rspamd-Queue-Id: 6742340004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788172997-632150
X-HE-Meta: U2FsdGVkX1+/7KERBkm5wstwKfRrAelBQCd9zIfDHDDr3p5LbZZl4K2TpUqg4PLAkc9CzVis6shoXq7wyb+v0Stfk2rJA1FS3A6CqGov7js7cdBRSAFLJk1Z7yWp+V3fzyUBzBamCjMTDF4rnYMFaIMgz7mqGAT8+4oJRd+nA3xkWtgR5QOTr1Z6BVVvKjGjuztDsbUNPwKuas+EJm9M9WjV7J83uJsO1fisDO4N0ipvonusC/UCljbDmMBsewnlpugy1stzxFB2rUOPov20mZHCB+KIQjZEaSEe/dxokyEiFAw4XyD1aFoeS5GSFL4LQn9y36KnuGJIo+OyxAe0Zd173K7AiDPpcQokpJE7qghEEqJCdxU19lDc4d34NFF9PFZYtXSVutqRILxtlaBCbPLKlu5I9BHmt1Z8Y8j5lcs770OgupqaBfR090B8R2WaJ80XJWSYXEHKOrkl9VdJ8l+T7gts/o/0d/Unoxug+077CkM7MGede1WUumlLVGW0kEiOBf2MEk7D8mUAkH0tk5FAlnaAIITJOnVJGS5u4scvvpY3R8hAL2sbn3E82JsTF6G7QI+1hk5+APSPyUDPOiZhCBFnLvnwz06hd/1tvPbmWCREsuXWPxKxYIynjbZ2cRGyUaVlDgSTxdzvBLlSVR6a+KpUJ4mAkLEWjyel3H5ea97A7CBJ+NaY/gSHsnd6Fw/ZRgU7piR8OA4lv3Br3WWboVQiB4ZZYCynMilZ0Q0tkIIl19uscB2thPbx/S9P0CW4okFMeB1O40tAWHdDcCd3DMdctNYSR9GIK3BQrBoImyBo+2XB6ADMlX+XWA0QRasQKXnTLdmqDkOlvrLIgaI8gtKBofREVyVsr3LWVzFjm9UxsTsnICbmV5CmRKNqlrGeOzE34vmr9YNYyPiJkQZftsgkLzi7OlwOq+kxHf7D7hrOzOD37J627CqPIWMehckwHNM5H2YCzsuwz0o
 uoWOCgi5
 2i0fE65uxNED/5v3/84A8Wkolm/3eTtT/0F0ut2eejCZnfzcnliC/e90e+yMrm9IGzrtMCRB6duFYdV+25M4hQVFf9MqtANyiU1yqzhciUyyq0sNYhmUWoE81ZTePSAOMgvKViEJBstqnPnr3AMaP2icCdg4kJPvOCR7FZRj8XHuMm52+koM9rrnjANtUJObU+HtC00Qgb1BhvQPGA1ZNrE1hTvK4VKW/+gajGMWNEtgljdwBqHoEGXopd2H2kp9nhRYnWSRhBOSnjVEY4idea4RIjJRV/09/828uFWOVXXpsTVsmQw1pf5prsQPxWZ7C4eaSlf9SDLNyYnTCkEMftmdKoBTWqxwKeCpDe/8Xa1PoxkSc7zC6XULg6/NsKuRDasIQ+aDhGnyjYxdTPiivD+ezpsTkpvKacd1YxOAd8OiiHgrIFW4Czx307rBg5OS8x9+NOUuS3y7RBIX+XOtdy6FLB3NZnCWAbGPJ2ObACSD/ziosjZ753/jdoVDKYGpHyK49DPDrtwf7s01WzQVBvRtRFD6VFt0E9G/hbWsU3OKre1WD1VxR20IvCmEAggnVFiMi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6575441848940488516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Mark linux_binprm->mm as trusted-or-null
>
> Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
> can pass it to kfuncs after a NULL check. The linux_binprm owns this mm
> throughout the bprm_check_security hook and clears the pointer only after
> exec_mmap() installs the new address space.

Is the changelog's description of when bprm->mm is cleared accurate?

Enumerating every write to bprm->mm in the tree shows three places where
the pointer is cleared, not just "after exec_mmap()":

  fs/exec.c:bprm_mm_init()
      bprm->mm = mm = mm_alloc();          /* assign */
      ...
      bprm->mm = NULL;                     /* error path, before mmdrop */

  fs/exec.c:begin_new_exec()
      bprm->mm = NULL;                     /* after successful exec_mmap() */

  fs/exec.c:free_bprm()
      bprm->mm = NULL;                     /* before mmput() */

Two of these three are not accounted for by the changelog. The
bprm_mm_init() error path clears the pointer before mmdrop(), and
free_bprm() clears it before mmput(). The free_bprm() case is actually
load-bearing: it's what commit d3633d366b08f ("exec: Clear bprm->mm
before dropping its reference") in this same series was added for, and
that commit's changelog says it's "required for eBPF kfuncs where
bprm->mm is either NULL or points to a live mm_struct."

The real invariant this verifier change depends on is "bprm->mm is
always either NULL or a live mm," established across all of fs/exec.c.
The changelog instead asserts a narrower property that doesn't hold.

This matters because the marking isn't scoped to bprm_check_security.
Any BPF program with a trusted linux_binprm pointer (all five bprm_*
LSM hooks in include/linux/lsm_hook_defs.h, plus fentry/fexit/tp_btf on
any kernel function taking a linux_binprm) now gets a trusted mm.
Justifying it from one hook leaves a reviewer unable to check the other
attach points.

Could the changelog drop "only" and state the actual invariant, perhaps
something like: "bprm->mm is either NULL or points to a live mm_struct
at every point a BPF program can observe a linux_binprm: exec_mmap()
transfers ownership and begin_new_exec() then clears the field, and
free_bprm() clears it before dropping the reference (see the preceding
patch)"?

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 386401fe051d4..584c79326b9c7 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c

[ ... ]

> @@ -6012,6 +6016,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
>  {
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
                 ^^^^
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
>
>  	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,

Does the patch ordering break bisect here?

The preceding commit in the series, 146a2bd992c3d ("selftests/bpf: Cover
trusted-or-null BTF pointer reads"), adds a test in
tools/testing/selftests/bpf/progs/verifier_lsm.c that expects this
marking to exist:

  SEC("lsm.s/bprm_check_security")
  __description("store through trusted-or-null bprm->mm is rejected")
  __failure
  __msg("R{{[0-9]+}} invalid mem access 'trusted_ptr_or_null_'")
  int BPF_PROG(store_through_trusted_or_null_bprm_mm,
               struct linux_binprm *bprm)
  {
          bprm->mm->task_size = 0;
          return 0;
  }

At commit 146a2bd992c3d, walking bprm->mm in a sleepable LSM program
takes the final else arm of check_ptr_to_btf_access() (flag =
PTR_UNTRUSTED) because in_rcu_cs() is false. The subsequent store fails
at the 'if (atype != BPF_READ && bpf_may_fault_on_deref(reg->type))'
check with "only read is supported" rather than "invalid mem access
'trusted_ptr_or_null_'". The __msg() assertion doesn't match and
'test_progs -t verifier_lsm' fails at that intermediate commit.

Swapping the order makes every commit in the series independently
testable. The ordering issue is present in the posted series as well
(lore message-ids 20260831092305.42062-6 and -7).


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33379004067
--===============6575441848940488516==--

