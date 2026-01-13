Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95959D2D0E6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4906B0005; Tue, 13 Jan 2026 07:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E1D6B008C; Tue, 13 Jan 2026 07:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A626B0092; Tue, 13 Jan 2026 07:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1FBC6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:29:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54748585A4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:29:45 +0000 (UTC)
X-FDA: 84326871930.03.F88AB8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AAB2818000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:29:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGTlrd6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768307383; a=rsa-sha256;
	cv=none;
	b=8K6ZZj6wu7jk1Hxw24oXBflE88OBmYrTR5Ndso2bYxB98ZMPPFfLySZEEvoGbgAzIT1H2Z
	mVfl+RnDsUFzaPXRFoFHDugZ8F8zqhwxF42aYtSzKRMEQ6isePtWqnXZd93XUdU7lEQ8Q5
	tw4Y5J8OpZfdkmjNlj8F/cF5q67Fx+g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGTlrd6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768307383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz+dQ9jMi3/ZVcK2pKZ7XRKXGAluH09KnppIO+cKKdk=;
	b=2s8ZoVllKyk9mr6D6Zf9H4igTMDuBG/L4nxf5u89EwAeFtlMWi0V9GQ1AcvtglPt8jUvBc
	aQOcnIU9KhxtU4Ge5OrURAeo8tmy0/mEGGehG4SrEazlWgG1O9D5vX2JCIm7Hb0+RiLUar
	Cqgmx8R7nK3H+KnMVWucWIcgagRoZVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 771164384C;
	Tue, 13 Jan 2026 12:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B1EC116C6;
	Tue, 13 Jan 2026 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768307382;
	bh=kC3MjEISpEzsYvzzprWTIDLtUFgYrWXfBkjrFKiQZYM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=FGTlrd6AiRMNXJkJkMRvDLXsTAbNJr/+rq1Wkd9hb7Ood0dmsmk97ZsSEgl+A+V60
	 pyBLKtgSYTZuz6b2yatgVMN9tvckhhs4ayGsONVHEhEdgbNQW7AjigIJk3dc1RVdId
	 r027mPsspOoHHacKxwrPr58tAEJGBm/QMMVKFTs4Mnxs+DV3xpfL/fW2Ukg5SwGlBg
	 CR3E0gX1DIJiSuXytU7+f13iYZZBdqw5Xs2c6V2MVSkMoqTTdmg8tcDvdNNgxxgfeQ
	 mvFGGOsSQNEurEa8rTI6hVvRtkkNEmDvG2Lhgg/Ms/mzapuDtKg5ggoLiWJtWGhwnz
	 XDWTtqGn6VLwA==
Content-Type: multipart/mixed; boundary="===============8699615455370949168=="
MIME-Version: 1.0
Message-Id: <be08950549a97cf3a2efd077cffc767395c208807f5f65af081db9a9a9623944@mail.kernel.org>
In-Reply-To: <20260113121238.11300-3-laoar.shao@gmail.com>
References: <20260113121238.11300-3-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,mkoutny@suse.com,yu.c.chen@intel.com,zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 13 Jan 2026 12:29:42 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AAB2818000D
X-Stat-Signature: ez3bik5p84gpf9iegypqg498mq6q6wmy
X-Rspam-User: 
X-HE-Tag: 1768307383-742579
X-HE-Meta: U2FsdGVkX19vYDEqsg8ZARNdWpRoUC39b+/Sot+hL40O72l8Rt61PVlaxz5966dgGHUGd3Cgzv6+k9lwep/vayO96QEZPteUfqhxVyQ61NAFf1PW5Y6PGyXpiVxt3+F9Bfav6dSELJihT/Ds4M8OkBpV4W0sActkGFZJmVnKrosaddhVyCXnQBiIJ+2fg+p520NTQREwikgLMDDKhvNZo8EGFN8eCh6cRUQzh6KIncoCrO9yCG7czY2tcpNeG4bJSQ72/u2fn/eT+4FCF/bnSad+5LPeRG7sDSguy6iVq6XL1ydV8lnwFUmzXob7GKxLzBzbAlQ+kbIQzSHa9efwJVwacQqdIM+c6bDDZPEcsl9V4fi1Gw5+iEoquMR550BMtggUuRB+7wAUJkmaVBNkYPQXLTZG/3DaL8N6wjfdh1Bx0/+3ZXDonAQKJ0g4Sz2uXidiPHlKnQF3dr63Qc34PyX78aBEy9Ial9sHl2EZF8iZPbwy/fnZ4wNiRRhlyN1oayuF/ODGR10BgZIj3tcGXRqpeaUAw4QKCKEU3EwKq7x2t4osBu864DFx1WfQALHlTWtKPaayxZowJehonuAJNSm2IG7ijQpRsobT5sD3a0L97IXSVavDIDkCu+B/cV+TkKR2j9+fd++UJhDH2N6tcU8GOdfx0ce1iF4huDxooj+lIxAob9Wnq5Q8cus+PHHENYVXyQklfmjoQevUD6dCrrtODjufbTPS+3vPm0GVJ0Vs3DxvuSBx3AyBoM4dF7JRdkmFWFGQmgyUiGpewxRMEmzyYaB3TIoejLvxL3yoL5HJ80Jnib2iIcCJeT//d6B+pc8x8yjja7nenB1p6/BDSD3rPjGL2brgSk6UxfNVlHuK0EveSex+7TTPoog+d2aIt4kIFfQ4SAIOS2UElqG5bbkXJsI3eR0ATsU3RpzoOxM18xxcWgM8oiknCZ6BbyABzaIVFR/mViH6dpmDBTH
 k5lHFSIr
 ZQY3nMDZj3uNvFazkrcb4WPpTE+SeVPMzWcaxVc6IuiqeHj/YxNpjSIohuNmLkfcJIR6sTXfSAmQdx/ELBGZbxU+mekJ2HGviiiBNZOLkoasoLKWBUtIhHu7+j6Rg95p6rf8eT1FCIq19a4jQWwZ44Dx4Lykcr8xSWtX9hqdf6TeVyI+mwW9BCueZn82+pNlCiF0XjT7xHItq40E0Zqv74bB9ux7q1RTQaYjcZBlOUPDqVcs0wP9e7+7+ix9drwf8FN1End0RzoFQ2gUSvpEOv852x5risV10aSHDQrdkBGTIThVzVkGjsV+1JW6ry7+0zRd49+orBmruklCV6Z7gGGjpFLFkCzpzWzc+T+6M6SYS0jMFNxPvxrv7DUrFRM5EvKCjT6UwKrvAKy3Wo/VqooGeQzSkxtIsL1QIW82O7dDkQ/znMDkIc98bKcR8mRQgXRqqWvmisFpmfzgJ/w6AS/NRMzWCEr5L4WaiYjG+dErjE5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8699615455370949168==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/Makefile b/mm/Makefile
> index bf46fe31dc14..c2b887491f09 100644

[ ... ]

> @@ -107,8 +107,13 @@ ifdef CONFIG_SWAP
>  obj-$(CONFIG_MEMCG) += swap_cgroup.o
>  endif
>  ifdef CONFIG_BPF_SYSCALL
> +ifdef CONFIG_NUMA_BALANCING
>  obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>  endif
> +endif
> +ifdef CONFIG_BPF_SYSCALL
> +obj-$(CONFIG_MEMCG) += bpf_numa_balancing.o
> +endif

Should bpf_numa_balancing.o also require CONFIG_SHRINKER_DEBUG? The code
calls mem_cgroup_get_from_ino() which is only defined when
CONFIG_SHRINKER_DEBUG is enabled. Without it, compilation will fail due to
an undefined reference.

Also, should it require CONFIG_NUMA_BALANCING? Without that config option,
task_numab_enabled() returns false unconditionally, so the BPF hook would
never be invoked even if a program is attached.

> diff --git a/mm/bpf_numa_balancing.c b/mm/bpf_numa_balancing.c
> new file mode 100644
> index 000000000000..aac4eec7c6ba
> --- /dev/null
> +++ b/mm/bpf_numa_balancing.c

[ ... ]

> +static int bpf_numab_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_numab_ops *ops = kdata;
> +	struct mem_cgroup *memcg;
> +	int err = 0;
> +
> +	/* Only the link mode is supported. */
> +	if (!link)
> +		return -EOPNOTSUPP;
> +
> +	/* Depends on CONFIG_SHRINKER_DEBUG */
> +	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
> +	if (!memcg || IS_ERR(memcg))
> +		return -ENOENT;
> +
> +	spin_lock(&numab_ops_lock);
> +	/* Each memory cgroup can have at most one attached BPF program to ensure
> +	 * exclusive control and avoid interference between different BPF policies.
> +	 */
> +	if (rcu_access_pointer(memcg->bpf_numab)) {
> +		err = -EBUSY;
> +		goto out;
> +	}
> +	rcu_assign_pointer(memcg->bpf_numab, ops);
> +	spin_unlock(&numab_ops_lock);
> +	static_branch_inc(&bpf_numab_enabled_key);
> +
> +out:
> +	mem_cgroup_put(memcg);
> +	return err;
> +}

When rcu_access_pointer(memcg->bpf_numab) is non-NULL, the code sets err
to -EBUSY and jumps to out:, but this bypasses the spin_unlock(). Is the
spinlock left held when returning -EBUSY?

> +static void bpf_numab_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_numab_ops *ops = kdata;
> +	struct mem_cgroup *memcg;
> +
> +	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
> +	if (!memcg)
> +		return;

mem_cgroup_get_from_ino() returns ERR_PTR() on failure, not NULL. If the
cgroup was deleted between reg and unreg, this function would get an
ERR_PTR value, the if (!memcg) check would pass, and then
rcu_access_pointer(memcg->bpf_numab) would dereference an invalid pointer.
Should this check be if (!memcg || IS_ERR(memcg)) like in bpf_numab_reg()?

Also, mem_cgroup_get_from_ino() takes a reference on the memcg via
cgroup_get_e_css(). Where is the corresponding mem_cgroup_put() call?
The function appears to leak the memcg reference on all paths.

> +	spin_lock(&numab_ops_lock);
> +	if (!rcu_access_pointer(memcg->bpf_numab)) {
> +		spin_unlock(&numab_ops_lock);
> +		return;
> +	}
> +	rcu_replace_pointer(memcg->bpf_numab, NULL, lockdep_is_held(&numab_ops_lock));
> +	spin_unlock(&numab_ops_lock);
> +	static_branch_dec(&bpf_numab_enabled_key);
> +	synchronize_rcu();
> +}
> +
> +static int bpf_numab_update(void *kdata, void *old_kdata, struct bpf_link *link)
> +{
> +	struct bpf_numab_ops *ops = kdata;
> +	struct mem_cgroup *memcg;
> +
> +	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
> +	if (!memcg)
> +		return -EINVAL;

Same two issues as bpf_numab_unreg(): the check should handle ERR_PTR()
values, and there appears to be no mem_cgroup_put() to release the
reference taken by mem_cgroup_get_from_ino().

> +	spin_lock(&numab_ops_lock);
> +	/* The update can proceed regardless of whether memcg->bpf_numab has been previously set. */
> +	rcu_replace_pointer(memcg->bpf_numab, ops, lockdep_is_held(&numab_ops_lock));
> +	spin_unlock(&numab_ops_lock);
> +	synchronize_rcu();
> +	return 0;
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20956455529

--===============8699615455370949168==--

