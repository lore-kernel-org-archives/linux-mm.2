Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81159E66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 22:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD90E6B0088; Fri, 19 Dec 2025 17:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86F66B0089; Fri, 19 Dec 2025 17:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992856B008A; Fri, 19 Dec 2025 17:10:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83FE16B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:10:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1389B13AD5C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:10:39 +0000 (UTC)
X-FDA: 84237615798.24.12CE722
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id A334A40013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:10:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5bDiBdx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766182237; a=rsa-sha256;
	cv=none;
	b=TOwfdKAJgmr+qhX2xSuoesxLGevq/NLPilaZ7ZzC/If3E7QcjQxxRaCYlqcN1hv3bj8JX3
	6kDcrACNWcR5Uxcyh1SpNnuYzeZCdOAUUYqo8USK6cJKbbZaz+uv/MwvXG917jwnyBQx1F
	GeCVV6FadnqAOE3WP4usw1swwvkaIJg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5bDiBdx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766182237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPXk3IdBFVNPfpB6UaPYs8EHosCr3z2DGcPu5LvC9fg=;
	b=Vz3TwU9qEtpnlOF/92V6/LciMB6n7Xs2eOIOkiPYgegB2IS9KVv9kQbvSO/2r+qGzK+e28
	CsfxWbuHHaj0ESehERwOHCLm4WFJWxYnvU7UY5uh7BqQ1lQsh4yXTVksfqGa0bqKia5/2k
	U3eZukUhKzT5LZ2V69tmgWmMiQyXKwQ=
Date: Fri, 19 Dec 2025 14:10:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766182229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iPXk3IdBFVNPfpB6UaPYs8EHosCr3z2DGcPu5LvC9fg=;
	b=w5bDiBdxirzcEnWHI3HunN1oh7BCapjBBM4xyKP2eQ7Jfxgw7C/NX0k1fbsIRRTUJdzFzY
	gAPCW/S00jlOqZu5BdnBtyVRtPpJun/sh3fs+Tzz+bVe63DMnk0ZnNd6VLocgsCoETnIvB
	d50MFpz8buezG3+h11eRrY0a2ma3Nc8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <vnlncxcamfe4z66bd6muhljsf7z6i6lizibo4wpaxfs5d45et5@f73plchvytgy>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-4-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-4-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A334A40013
X-Rspamd-Server: rspam03
X-Stat-Signature: b19dpwz9pcdqxh3eapxf13tpcrhyikwy
X-Rspam-User: 
X-HE-Tag: 1766182235-444747
X-HE-Meta: U2FsdGVkX19vuJsmwi/lvSAEz7Y2BJ8Cyfbzkme3+uvmE6poeUJex6R5cwTD1k/FTEZam5ltvRhkACFebcgpfGe5JbcQaLPu5xD4Xk2eI9bQvaNarLeodSrj2IGtUEMvO30VUc+fczusHMLqN4OeRi/WQ2T0zLkCd4k2C3Ld+FK7oEw/wcOKHnQGAKZKsSJ3BgsHcbD5/KZ5cDIMvSQiEpyWCvktavC92CFYhFftwPQ0tdJfd1TSRsvxzFny1Z2oVrGCb/DBOQCkQtzckXpzH4BkY9v/gUSqHDRh9U0ocUvdr+FdBaOS6tsESF5p3O4qq9QEj2aLIMs3GKt+PgZsxVX1hEfQ7sGVWSEy2igKkjwpBA+uT5GL4vVGshNGuvVOZWLQyZay86Of0UhM1CmTufIOqxm3p8wO/REIGLX/Rh44orxQLKqY9RPNmlEX/cvblOt8FzuVa8f/JP33w+166l7YsnStJ0pf6RsmXzR/UblbCUkVGa625bRqkDyzjgITvRJg+fhls+8EzJ6tv7ETm2JEvpvkNGweurnIUYR2qYGPNEdjgcAZbnJykqlCpNTPsvR9jcRoUQODcBkNnz+bd8JGlt9fJMfMrx0/1oh7ToZuoMr/twvJ/zvR4j3SYwq5LO21sa1c7LTIIpfrXuwORurD8EvEq1dTi3s1B4+XtdS9dJEkmg5cvR6EeASAno6PfhAPlhPVbhtbnWFPwi2Eoi+WjC9wzSpyIsGKm1euh7s/QfxK337iKb1lZZlSXtsbddDuckw/KRTseVE/jxPEgio+MC8DQJ+XehbU52mPPIsn0tPbYnvBYANu3k7ioY6UyrS0vw5yPWkHTi/vW3eufOLEUi0dGxa4LuZjGxxOAefTdYBIL/d2S91BdU2SgQSbSuMKQBlCCtRgn17I9+85yYAKwQkhVUF77sF1j0IXqmavGDqWNna3ZSs8FusmRs4unOWibDXEyB3KGV7HBZh
 2w3rHbXl
 sixXGLjlnfUASLFugsrN8tXz96si1j4sXrw2i7kGO2rd/vbay0zZgQKHMAcrD+5OHFMHCbscvy+DMYEV8M32j9lrw807EgqjZJ6bC7A+lp9TfdeLoFtinK/6bRHn61TZRl26Y6wVKrbJEZfsX14BIgIWOWGWj0KhR8d7D1KlaFDQvGkBPQ+y5KKJ7OWE9oGsKnvWciuKaubusMe0zpfcZa7Kl4KkWi6tSpTeqvAdLBLiohWjUJihIpMftpvCpCN6gOB7d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:47PM -0800, Roman Gushchin wrote:
> Introduce a BPF kfunc to get a trusted pointer to the root memory
> cgroup. It's very handy to traverse the full memcg tree, e.g.
> for handling a system-wide OOM.
> 
> It's possible to obtain this pointer by traversing the memcg tree
> up from any known memcg, but it's sub-optimal and makes BPF programs
> more complex and less efficient.
> 
> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> however in reality it's not necessarily

necessary*

> to bump the corresponding
> reference counter - root memory cgroup is immortal, reference counting
> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/bpf_memcontrol.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 8aa842b56817..6d0d73bf0dd1 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -10,6 +10,20 @@
>  
>  __bpf_kfunc_start_defs();
>  
> +/**
> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
> + *
> + * The function has KF_ACQUIRE semantics, even though the root memory
> + * cgroup is never destroyed after being created and doesn't require
> + * reference counting. And it's perfectly safe to pass it to
> + * bpf_put_mem_cgroup()
> + */
> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> +{
> +	/* css_get() is not needed */
> +	return root_mem_cgroup;

I think we need mem_cgroup_disabled() check here as well because I think
root_mem_cgroup can get allocated before memcg can be disabled due to
boot param.

> +}
> +
>  /**
>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>   * @css: pointer to the css structure
> @@ -64,6 +78,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
>  BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
>  
> -- 
> 2.52.0
> 

