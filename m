Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74630C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCAF6B0098; Mon, 31 Aug 2026 06:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D0E6B0099; Mon, 31 Aug 2026 06:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C106B009B; Mon, 31 Aug 2026 06:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1CDD6B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:43:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 420B41A046F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:25 +0000 (UTC)
X-FDA: 85161227970.08.8A6FD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9D0C920005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDvpYveJ;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788173003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4A6rVmZ4kXsT9r+WYDtkSaIU7jzFhtTA68G3dKhDy+8=;
	b=DUBscwjiN5mbNYX/epd2SeVO6NabvM5EPQdUWqaivxD7/arkSUAPbk4CichY0S0svXOB7u
	daUWLyc+2XmhYrntxj7cwGxGsBUwigaEWHjIuutdiUov4DRxLkzmeCPuvqm6klAtOZTbHZ
	kwMJEtMtlesMoeZdmrA+BquInhs9Y1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788173003;
	b=wM2WCcZMJSWBNJAewTp9Lhlvf3lj0WtF64JBcl73T8HWQC/plbmwW1BFgKjYP9AHHo21V5
	kyEzHnpHFWJ0Sonnj0e5Tq92hvV/uzaIrCWFQ9YTYIVL8GA0ofYJDOo/HQmSFjQnLHBhBj
	G6WUsVb/Q9ZUibzmU13y3xlvGr/vlUs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDvpYveJ;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C605443D94;
	Mon, 31 Aug 2026 10:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2281F00A3F;
	Mon, 31 Aug 2026 10:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788173002;
	bh=4A6rVmZ4kXsT9r+WYDtkSaIU7jzFhtTA68G3dKhDy+8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=CDvpYveJfDwfFRCpZc0xZE3uPNrncqqnDF+aPMZ1MpImzzLt27PEl+xWCpfTgW5FK
	 0bKquH9D+eT0uYVUnDPXvSyRM6vrrMNLaUS86g4gYACm1Gw+ZWylB6CDSYt70JiKGz
	 GOJemDTTlkmp0S8EFPQW+En11jImLCVVsbK9hXCU71WquGUP2vUDn5JgUufYDPfpxq
	 +l3wGWbDoo8DCZevAvk+0nHbHREph9aBi4lK9gItHpuXbDy1tfkmfOu9DPIaU/gmbu
	 yrZj/TWy19LEmlT+yDrGKI37MUEEFlpS36XLlnRFqVVWUwN0x5bbZjL1iNLUQs/B75
	 yqVvssCw1UEDQ==
Content-Type: multipart/mixed; boundary="===============8374567278503569975=="
MIME-Version: 1.0
Message-Id: <9e411feb9558d5759bd8927b9b2e95751f19b11981be87e6cb9757c2e9f65852@mail.kernel.org>
In-Reply-To: <20260831092305.42062-6-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-6-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v3 5/7] selftests/bpf: Cover trusted-or-null BTF pointer reads
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 31 Aug 2026 10:43:21 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D0C920005
X-Stat-Signature: 1rq7mtim9r3hhc73t1j1tzw33aygadh1
X-HE-Tag: 1788173003-907262
X-HE-Meta: U2FsdGVkX19Tt7+4KX4GfmVsXLZqKQHty7OsujA4TdiPWNg6+tXe940p7D33IzYhrQmCVWLGycntqygnS2grcc+V7jjppht8BWWg+CelGmo1OwNDPbA3FWzqdNSSbv59OCTipMWap/DT1BD3uWmp4GZMclpEEuDNMd2k4Wa+kd13UPoPxh+Q0Q36JMmdAwgZ3CZ02VBF0/XJiLLLwkc3OVtr18GX1dm7HKuqUc8YwCBoptQxF2n8wqPsThRhrWPBsLqhlMBUIoXjgRIC/ChakC0RMgQel0wZpz9KdpuibfJS/6dPC/QBN/JazKXJX5BbaYHA1MhDYj1cbcrzlmYDVI3K/Q0nLXq9Nb2aCV18sBVHV2CfcIHrjLpDMeexpOjMpO7ud3W7aoU/WZzh+tjR3y0z+yj3GGklACRYq8aLFr2gRA8ULgWFShBFGte0i8FP9jl+b3zWVtWiY05NKFJQfO15iczlZJjuVXH7tqbfkgvAFlW7e79Lwo/3/DOuGPt5d1E+sxP3VMzZGQ4I2urRsENXJXW5cD70QodEmbGsR33YQTzOj2iUT7b6iCR2Zr89+cN7AnxA0tH2zrqk8I7F3PYiv4kw7EwYW/g6f6BSusn6mD2GAJOVw1mZRQRJ3CnWrTwOl4/C/aO1MEDi1DUira1nzNV8844rV7/ZDqAjiDuatLsExUIeYYzdHsCFKcoHQ0Lgh2e1I2qHb1NtHPnmZE2NibWp/pSm8TMkLEru8iS/5l61b0ngwuObWhVx5ANbdABnDJfZ/Pt9RD+OKJif8og+J5ajQuC33et1ap+iPFRk/9S9S+iDiCWmpVpF47DsyyNqkYteqUJWJ4AU0fR2zHrY1LVIZbBMAn7Z8P1P1Gur1MFYUIKWdgWcyvZqnzJi+Hhmq8M/iDnsAfh4mN2ERLPf20gBeKrrlCMT1NG1qdKVv1o+s/fDgXbg6nUMHktsnd0vQVwlGirRSno9OKg
 +eA1DtlC
 hBxBgE8SyX4LiqFgwkLw9toOodlAeoWk5bPmb/9a86tky014msdbCtknOxJ6DU/roIj41UZw9C9T/vfY1znKcW+NuYt/VGx9SZaGihAvIxFS7qmrUHZ2XAoSMkRRJkYwVz58fvy2SPvTL3iatbnXytEATQnuw6dbaCkih0oYym01m4yviWGf+kqIiVS7PpxFOVuOpHQV4JOP7xDb/zN2ZkTUc6YksbYDe/ojXlCGVW0hGZ/s6ryeq4ZJnRQMNu6I85OpqjP18PsT3YPVdmg3ZnVd4LjwJSuESbgZSdj2LO8GHVlPvZbAivdVm1UolC0lYzryApSEpV2ooUJwVtXWbJE+nRUqbNX5+HyiNnL8Ygr4YF6igQO+Ynv+slJ/1av6Qjaq+GxR/skOiVgYFA9CbbWvlov3qI9K1+F6DdUxz0pJnul5VPQyOKrMyv2KvTLRJ9AQbAhQtEzD/E/C3E2j2QfWQjIOVlTSnrnOQvtpwIqd+zqdKIs3e3dnyEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8374567278503569975==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> Verify that pointer arithmetic, stores, atomic RMW operations, and
> BPF_LOAD_ACQ accesses remain prohibited. Assert that a BTF pointer
> derived from an unchecked trusted-or-null load is PTR_UNTRUSTED.

Does the patch actually verify atomic RMW operations and BPF_LOAD_ACQ
accesses?

Looking at the diff, pointer arithmetic is covered by
handle_tp_btf_nullable_arith in progs/test_tp_btf_nullable.c with the
expected verifier message "pointer arithmetic on trusted_ptr_or_null_
prohibited". Stores are covered by store_through_trusted_or_null_bprm_mm
in progs/verifier_lsm.c.

But there is no test for an atomic RMW operation (such as
__sync_fetch_and_add through a trusted-or-null pointer) or for a
BPF_LOAD_ACQ access (such as __atomic_load_n with __ATOMIC_ACQUIRE).
Running grep over the diff for "atomic", "load_acq", or "__sync_fetch"
only matches the commit message text itself.

The underlying kernel behaviour is correct: is_load_acq_unsafe() rejects
BPF_LOAD_ACQ on a may-fault pointer, and an atomic RMW is rejected by
the BPF_WRITE pass of check_mem_access(). So this is a coverage gap
rather than a functional bug.

> diff --git a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
> index 0d58114a4955c..45df28c0a25ed 100644
> --- a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
> +++ b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
> @@ -2,14 +2,18 @@
>  /* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
>
>  #include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
>  #include <bpf/bpf_tracing.h>
>  #include "bpf_misc.h"
>
>  char _license[] SEC("license") = "GPL";
>
> +extern struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
> +extern void bpf_task_release(struct task_struct *p) __ksym;
> +
>  /* Ensure module parameter has PTR_MAYBE_NULL */
>  SEC("tp_btf/bpf_testmod_test_raw_tp_null_tp")
> -__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
> +__success
>  int test_raw_tp_null_bpf_testmod_test_raw_tp_null_arg_1(void *ctx) {
>      asm volatile("r1 = *(u64 *)(r1 +0); r1 = *(u64 *)(r1 +0);" ::: __clobber_all);
>      return 0;

Flipping these two tests from __failure to __success leaves their
comments describing an assertion that no longer exists, and drops the
only compile-time proof of nullability marking for these tracepoint
arguments.

Both programs now load whether or not the argument carries
PTR_MAYBE_NULL: after this series a read through a trusted-or-null
pointer is allowed, and a read through a plain trusted pointer was
always allowed. So if a future change accidentally stopped marking the
module tracepoint argument or the sched_pi_setprio argument as
maybe-null, these __success tests would keep passing while the comments
still claim otherwise. The file name raw_tp_null_fail.c is likewise now
inaccurate for the two leading tests.

Mitigating factors: progs/raw_tp_null.c plus prog_tests/raw_tp_null.c
still prove the module tracepoint argument is maybe-null at runtime via
ASSERT_EQ(skel->bss->i, 3), and the new trusted_or_null_walk_is_untrusted
test indirectly proves the marking for sched_pi_setprio because its
expected verifier message only holds if the argument was trusted-or-null.

Would retaining an explicit assertion (such as __log_level(2) plus
__msg("trusted_ptr_or_null_")) or updating the comments to reflect the
new test semantics preserve the intent?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/verifier_lsm.c b/tools/testing/selftests/bpf/progs/verifier_lsm.c
> index c724bf389f5c6..c912215579c92 100644
> --- a/tools/testing/selftests/bpf/progs/verifier_lsm.c
> +++ b/tools/testing/selftests/bpf/progs/verifier_lsm.c

[ ... ]

> @@ -188,6 +188,17 @@ int BPF_PROG(null_check, struct file *file)
>  	return 0;
>  }
>
> +SEC("lsm.s/bprm_check_security")
> +__description("store through trusted-or-null bprm->mm is rejected")
> +__failure
> +__msg("R{{[0-9]+}} invalid mem access 'trusted_ptr_or_null_'")
> +int BPF_PROG(store_through_trusted_or_null_bprm_mm,
> +	     struct linux_binprm *bprm)
> +{
> +	bprm->mm->task_size = 0;
> +	return 0;
> +}

Can this new negative test actually pass at this commit?

The test relies on bprm->mm being loaded as a trusted-or-null pointer.
But struct linux_binprm is not in the BTF_TYPE_SAFE_TRUSTED_OR_NULL()
allow-list at this commit.

Looking at the list in kernel/bpf/verifier.c (around line 5957), at
146a2bd it contains only struct dentry {d_inode}, struct socket {sk},
and struct vm_area_struct {vm_mm, vm_file}.
BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm {struct mm_struct *mm;})
is only added two commits later, by 83008d7d1f94b ("bpf: Mark
linux_binprm->mm as trusted-or-null") which is outside this commit.

Consequently, in this sleepable (lsm.s) program in_rcu_cs() is false and
neither type_is_trusted() nor type_is_trusted_or_null() matches, so
bprm->mm is walked as PTR_TO_BTF_ID | PTR_UNTRUSTED. The store then hits
the earlier guard in check_ptr_to_btf_access():

    if (atype != BPF_READ && bpf_may_fault_on_deref(reg->type)) {
        verbose(env, "only read is supported\n");
        return -EACCES;
    }

The program is still rejected, so __failure holds, but the log says
"only read is supported" instead of "R<n> invalid mem access
'trusted_ptr_or_null_'". test_loader's __msg match therefore fails and
the verifier_lsm subtest reports failure at this commit and at the
immediately following commit; it only starts passing at 83008d7d1f94b.

Either the linux_binprm marking must be ordered before this selftest
commit, or the test must use a type that is already trusted-or-null here
(such as struct socket {sk} or struct vm_area_struct {vm_mm}).

> diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
> index 55398c04290a8..2827a16507274 100644
> --- a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
> +++ b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
> index 8f0c45421f893..2a0813258183e 100644
> --- a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
> +++ b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
> @@ -159,18 +159,4 @@ int BPF_PROG(path_d_path_kfunc_non_lsm, struct path *path, struct file *f)
>  	return 0;
>  }
>
> -SEC("lsm.s/inode_rename")
> -__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
> -int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
> -	     struct inode *new_dir, struct dentry *new_dentry,
> -	     unsigned int flags)
> -{
> -	struct inode *inode = new_dentry->d_inode;
> -	ino_t ino;
> -
> -	ino = inode->i_ino;
> -	if (ino == 0)
> -		return -EACCES;
> -	return 0;
> -}
>  char _license[] SEC("license") = "GPL";

Does the deletion of this test leave struct dentry's d_inode field
without a type assertion?

The deleted test was the only place in the tree that asserted struct
dentry's d_inode field is typed PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL.
Its __msg("invalid mem access 'trusted_ptr_or_null_'") named the reg
type explicitly, so it failed if d_inode ever stopped being listed in
BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) in kernel/bpf/verifier.c.

The replacement in verifier_vfs_accept.c is a bare __success program:

    SEC("lsm.s/inode_rename")
    __success
    int BPF_PROG(inode_rename_no_null_check, ...)
    {
            ino_t ino = new_dentry->d_inode->i_ino;
            ...
    }

This program loads identically whether d_inode is
PTR_TRUSTED|PTR_MAYBE_NULL (the intended marking, read via BPF_PROBE_MEM),
plain PTR_TRUSTED (normal load), or plain PTR_TO_BTF_ID. The other
d_inode test in the same file (inode_rename at line 88, which
NULL-checks first) is also __success and equally indiscriminate.

A grep of tools/testing/selftests/bpf/progs for d_inode finds no other
type assertion (only local_storage.c and profiler.inc.h, neither of which
checks reg types). So after this patch nothing detects a regression in
the trusted-or-null marking of dentry->d_inode.

Would adding __log_level(2) __msg("R{{[0-9]+}}=trusted_ptr_or_null_inode")
to the new accept test (the style already used by raw_tp_null_fail.c and
verifier_global_ptr_args.c), or keeping a __failure store/arithmetic case
on new_dentry->d_inode, restore the lost discrimination?

[ ... ]

> diff --git a/tools/testing/selftests/sched_ext/maybe_null.c b/tools/testing/selftests/sched_ext/maybe_null.c
> index aacf0c58ca4fa..8fec296c31bd3 100644
> --- a/tools/testing/selftests/sched_ext/maybe_null.c
> +++ b/tools/testing/selftests/sched_ext/maybe_null.c
> @@ -25,11 +25,11 @@ static enum scx_test_status run(void *ctx)
>  	maybe_null__destroy(skel);
>
>  	fail_dsp = maybe_null_fail_dsp__open_and_load();
> -	if (fail_dsp) {
> -		maybe_null_fail_dsp__destroy(fail_dsp);
> -		SCX_ERR("Should failed to open and load maybe_null_fail_dsp skel");
> +	if (!fail_dsp) {
> +		SCX_ERR("Failed to open and load maybe_null_fail_dsp skel");
>  		return SCX_TEST_FAIL;
>  	}
> +	maybe_null_fail_dsp__destroy(fail_dsp);

Flipping the maybe_null_fail_dsp arm from expected-failure to
expected-success removes the only check that .dispatch's second argument
is nullable.

The program under test is:

    void BPF_STRUCT_OPS(maybe_null_fail_dispatch, s32 cpu,
                        struct task_struct *p)
    {
            vtime_test = p->scx.dsq_vtime;
    }

That is a single scalar BPF_READ, which now loads regardless of whether
p carries PTR_MAYBE_NULL. In other words, it loads identically if
kernel/sched/ext/ext.c ever loses the prev__nullable suffix on
sched_ext_ops__dispatch(). The sibling positive test
(maybe_null.bpf.c maybe_null_success_dispatch, which does if (p != NULL))
also loads either way, so the .dispatch nullability marking becomes
entirely untested.

Only the .yield arm still discriminates, and it does so incidentally,
because bpf_printk("... %s ...", to->comm, ...) performs pointer
arithmetic on to (rejected), not because of a null-check requirement.

Consequently the test's own description is now inaccurate:

    struct scx_test maybe_null = {
            .name = "maybe_null",
            .description = "Verify if PTR_MAYBE_NULL works for .dispatch",

Making maybe_null_fail_dsp.bpf.c do something that is still prohibited
through a trusted-or-null pointer (pointer arithmetic on p, or a store
such as p->scx.dsq_vtime = 0) would keep the arm a real negative test.
The fail_dsp file/struct_ops names (maybe_null_fail, .name =
"maybe_null_fail_dispatch") and the description also need updating if it
stays a success case.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33379004067
--===============8374567278503569975==--

