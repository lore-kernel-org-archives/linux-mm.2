Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DCFC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91666B008A; Tue, 11 Aug 2026 08:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49026B008C; Tue, 11 Aug 2026 08:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09E76B0092; Tue, 11 Aug 2026 08:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8490A6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:40:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14210160417
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:14 +0000 (UTC)
X-FDA: 85088946348.28.5C6C1EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7AAA3C0004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ce8Hn+YN;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0tZSTnKs2BtcMVfQ5nw/+/GWpAWReRo2gArGUALO5I=;
	b=pTiJdfmN7umaZd5pCO5idyF8gkT4uSA0gNyhSy3f1j+v4N/zn9y4aAXF2YU/yrygCFntb1
	KidNZLzc8k5Kmo9XerNkCFXZwRJy7E5mTk3uyeEIIrU2FzOOA1kYvKInAvtEJIQ55RtJil
	u7e3j75Cz6Afhqs96zw24iJZNMrqSck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452012;
	b=XUrCbQioeY57WmO+qj7UGhRJEKzVGzA4W1hOylMBdAbn6qIlmT8yKQtG0AbbUfPD2+XSHY
	jYF0Y+dK52cK36obzhVEDZ4MEbWH3k0ZHWwkzc4KCEg99kaQvr+wJDH/8B3cv/6dQo5Gie
	u6PX130EtpZ1XQyXIlU2kI+vwMVC6Tk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ce8Hn+YN;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D08E60120;
	Tue, 11 Aug 2026 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CFF1F00A3A;
	Tue, 11 Aug 2026 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786452011;
	bh=J0tZSTnKs2BtcMVfQ5nw/+/GWpAWReRo2gArGUALO5I=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ce8Hn+YN8KW+67LVYZqbXHYHtaffjIzUa5S0+w4ACQH6/KstGWEpSbj/eEzdgbxH2
	 rkIMpmB6XZvq2b3rfaGTFWUD23VcntdohZI1bV2p8mogs+RyYsxmu/zIxLUWAB5xoI
	 mw76YHfqYINXo+NTgo1QGlKbE2wdp3P7O7qh2GmA1Sd3jOyHao7BK4ftcX5CqMSZgN
	 WYRTkZ730b8+WivpsgtjUdY14cZ0iU8vB9C7VSFz8MKGVxhR/CAQ4u9/5rCf7hRYE/
	 DPLnHkIaCWmi+T5nNdTdtVYHG71jF3wdyPfPi3dK2OKL6Q3CNYEsbKz5pAAjsyWDMd
	 BepAKDR1fmEjQ==
Content-Type: multipart/mixed; boundary="===============2459636574471727467=="
MIME-Version: 1.0
Message-Id: <2cd0c943fb35dab000f00272d28669dffa60007c9e1c939e2f2b77bd0f4dc81f@mail.kernel.org>
In-Reply-To: <20260811112154.94053-4-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-4-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 3/5] bpf: Mark linux_binprm->mm as trusted-or-null
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 11 Aug 2026 12:40:10 +0000 (UTC)
X-Rspamd-Queue-Id: 7AAA3C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tcx7u4a1m8dkquk6hgc9gcfjtu6zzrif
X-HE-Tag: 1786452012-621658
X-HE-Meta: U2FsdGVkX1/rfXGgwGkUs4qinMA5xvK7KB2eOI2RBzuefkoaoRsBgvHUiAJ0sw7tkzZHjIjVgQj0V9RO89TnRCKGcSaeLIvXkmfmXd+E3ztrvR+dZcpshzOYatyDH5Z3b2hOT9yNjBgP1RSzBJEkQnyaUq09ApEPNsrYrL/eEXzHBXrqywocS+rKylV1AN+AT+H05kDx7T9fUhc4O3R7tQn5FFEHViZ9EQKmBCuIU8Sial9+bG2nxgqt0UqtoR9a3r/d/r+WeyFiCkxY/rq2jgDMawSccBx8VgYQ/ihNcP9cv8zw2Zq44vjI9upI+JrT7Jbyr/o8w2in0UR1xycI0QoIhkDEOwvFthTHZFrSLWo35FnsaXgWkY5jWH6RmiqqNciqw3C5ii0mAeUP1t0+vnYW275/A8HXIl6DkNhXGunGcMSnaDVwFgnOfko1DEPo+zMyGxAF+9LXtMqeqJq7tkj2caoDWMczOxnRWMfGLupj4yFMPH4Ef3yzKDxyzMnPYu4B7ppXkN4bity0A1yDQvDBSPtrfSZRIJVfBjX4QWIvgjjtQL169P/Dud/5y/tgFUIiqNlMmU121bg5vtHbKuaybTcGXPhCFeAs1/rwT7jkP6s2HY2H/9WNUgBwt+FBE6Sibob95F0KyycTADz8CS/okjrZulXPXoaVkJMe8t64ZH7Kzo66rWcaVFJFajCM7F3OqHw8r728VUCpvs8+fv+CsMZdFsHi+rOBrLui38KBrgZHMkpSNPOYAbBcNWX/1yq18rCaKG2xBaWHxoW8D37Q1OLjdBivNbY47yp4ZjfDvBCBkfALnKn87ryEH/sQR4OFyIhQDM2TSnHSTzZA5dgOFDfKtzqwCAxeRlPFxCTBjAAIQnEsatYwUaG9NL3nd69HReCSx8M3h5ymGMHIbGt9IGeaaAKDKSsn2Y0GHFbHsG1Kd4e7W5QRnYaQorVh5aJECUQSF1y5Dlq/SUs
 XlvJvsEf
 mxlTwkTdLHdcF86yxFvoPHZnUr/ouz06zqV31CYumlg+mw2+OJ5hDPvp6J9NgY0qc48D1OFxRSMKabS0CBl9g5zyavCG2HSkEQ9w91z0rtscihV9DdJbcZsypmfxIsDzSGc9pFwQkkwISiQT/0bgMzUraS855D/UAJ84sCQu58ZiFXLQUOfuAf4BqTFlnpkEZa0ZpMuhRIM/G16e3sAL0VhFu4wSP5s+4W0hoJcTqQrXo7pywJcW4YD9vfgjXj2Yf/p7bx3cl1mOdlNNs/DSPVVAE7qhqoMNF3Scy2YH2OjGP0/zmx7uPrmiEymdy7ivu2VqgYVK5L4GHPDJCPJ51cttpLgHac5VXpaYRB3NigF3ycZKkn0RzhgezqmtDoz7cB2VBM2yutJjxa6cixwBNHzh6uodLrWdeeWkHox6JwIIv21w64H2RdPn1bbydnypm+/cX4nQ7LwMRmGWn+E1vkQWEdnJ/Y+GOPDn1OxCiUVyiS0yTIyMXHuBusBuTqm2rH7bZwLAmNpIgiqBxp59DKgxcw7Lcgw2FChUUoBW7vIg5wGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2459636574471727467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index add3affc57035..8bdcb65618d01 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5682,6 +5682,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
>  	struct inode *d_inode;
>  };
>
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
> +	struct mm_struct *mm;
> +};
> +

Does this break the BPF load-compatibility guarantee documented in
Documentation/bpf/bpf_design_QA.rst?

Before this patch, walking bprm->mm produced a dereferenceable register
in every program type. In sleepable programs, in_rcu_cs() is false, so
check_ptr_to_btf_access() sets flag = PTR_UNTRUSTED. In non-sleepable
programs, in_rcu_cs() is true but mm is not in any __safe_rcu* list, so
clear_trusted_flags() produces a plain PTR_TO_BTF_ID.

Both PTR_TO_BTF_ID and PTR_TO_BTF_ID|PTR_UNTRUSTED satisfy the guard in
check_mem_access():

  } else if (base_type(reg->type) == PTR_TO_BTF_ID &&
             !type_may_be_null(reg->type)) {
          err = check_ptr_to_btf_access(env, regs, reg, argno, off, size, t,
                                        value_regno);

so bprm->mm->arg_start loads with no NULL check.

After this patch, btf_nested_type_is_trusted() matches
linux_binprm__safe_trusted_or_null.mm, so check_ptr_to_btf_access() sets
flag |= PTR_TRUSTED | PTR_MAYBE_NULL. Now type_may_be_null() is true, the
arm above is skipped, and control falls to the final else:

  } else {
          verbose(env, "%s invalid mem access '%s'\n", reg_arg_name(env, argno),
                  reg_type_str(env, reg->type));
          return -EACCES;
  }

Any existing program that reads through bprm->mm without an explicit NULL
check now fails bpf_prog_load() with -EACCES.

> @@ -5732,6 +5736,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
>  {
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
>
>  	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
> diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
> index 7de173daf27b6..7441d66c080c9 100644
> --- a/tools/testing/selftests/bpf/progs/lsm.c
> +++ b/tools/testing/selftests/bpf/progs/lsm.c
> @@ -113,6 +113,7 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
>  {
>  	__u32 pid = bpf_get_current_pid_tgid() >> 32;
>  	struct inner_map *inner_map;
> +	struct mm_struct *mm;
>  	char args[64];
>  	__u32 key = 0;
>  	__u64 *value;
> @@ -121,7 +122,9 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
>  		bprm_count++;
>
>  	bpf_copy_from_user(args, sizeof(args), (void *)bprm->vma->vm_mm->arg_start);
> -	bpf_copy_from_user(args, sizeof(args), (void *)bprm->mm->arg_start);
> +	mm = bprm->mm;
> +	if (mm)
> +		bpf_copy_from_user(args, sizeof(args), (void *)mm->arg_start);
>
>  	value = bpf_map_lookup_elem(&array, &key);
>  	if (value)

The selftest rewrite above shows the problem: the old form
bpf_copy_from_user(args, sizeof(args), (void *)bprm->mm->arg_start) now
requires a NULL check. Out-of-tree BPF LSM and tracing programs that read
bprm->mm the same way will stop loading on kernel upgrade with no source
change on their side.

The bpf_design_QA.rst compatibility guarantee states: "The bpf development
process guarantees that the future kernel versions will accept all bpf
programs that were accepted by the earlier versions."

The tracing-program exception in that document does not cover this case:
struct linux_binprm's layout is unchanged, the program source is unchanged,
and the in-tree casualty is a BPF LSM program, not a bpf_probe_read()-based
tracing program.

Should the changelog mention the compatibility impact and document that
programs dereferencing bprm->mm now need a NULL check?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31488001112
--===============2459636574471727467==--

