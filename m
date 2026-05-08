Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF98CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3416B0182; Fri,  8 May 2026 11:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAA96B0183; Fri,  8 May 2026 11:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407B36B0184; Fri,  8 May 2026 11:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 310C56B0182
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:40:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8C38401D1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:12 +0000 (UTC)
X-FDA: 84744663864.14.1A0FC05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A07A100002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBx3ej7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778254811; a=rsa-sha256;
	cv=none;
	b=dqNq2n2shKLDRVLgfQDzCEEvGYq9bWEri6dkcBBmQgzC4EAPA5euu0S5v95Xqw/abCxmyL
	a4HmDfp9iLAwntL3ZNNEL0u5t9UrkUDiO4jEVIkE8oC/NV7bnl7vKCTwLmBSTngyRj0Xxt
	vebCLDuz5iDFSdgnhbgb+J57SlSFK94=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBx3ej7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778254811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slTYglbHx2XKhWgMdtKpXcrlkWTZKIwUAV6j9p618qQ=;
	b=Lf/AS7C+z3DkIoaJFAGILVU5JCWDT1QJVQGrYylcoLH9N7s/0n47SMdsyp7lWIx/5DD/TK
	WCKANQJA6/czOFPI9kxjsa8crz7sGogWKWAe0I0u12Asy6serlHvO2HJfYjhR8QC8P0sBx
	Ssx8KItNW/B4q8szswnWOGTOAh4umr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29F4E4361A;
	Fri,  8 May 2026 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC2DC2BCB0;
	Fri,  8 May 2026 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778254810;
	bh=E8G9MYegRpzWpWVKYNRRCGAxqMbVWlinVx/Om5EhD2c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=EBx3ej7f2CmGFrRVSf/PpZzoO7LFjhpaWV9umAj6rdU1EIONp6mc9AFLNQxSgzNia
	 Rnnb4HUSXO/aHv9MAUdA3Ad1L4OkRqid86QDxfRg5eqNI33FaHuOGv4+zCyb8WloRs
	 3CRWPybgZFfXIgiLtA1WTCZbp4Vm8vGjTGx3bz8ZCfYRSlewzLfu6AFjb7cmH+39tD
	 X56Us7/86EEZNnj0JG7woqgycponkkkul8HGZGfqv0iECDj/51/15D/F1KbtkQbtlp
	 sF6+7fRlRVlCnIPBK+HdA/bpJnydd+bDxVPtgPR9G6oWy5OWlCWGZICmCGFaoRMpwQ
	 MZdSV39sBPtyg==
Content-Type: multipart/mixed; boundary="===============1780306519113491024=="
MIME-Version: 1.0
Message-Id: <c096deaccb513762aa50dbb59ccb0d18e6fb14a772fe37c428fb49fc550d9b1e@mail.kernel.org>
In-Reply-To: <20260508150055.680136-3-vernon2gm@gmail.com>
References: <20260508150055.680136-3-vernon2gm@gmail.com>
Subject: Re: [PATCH v2 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: tz2294@columbia.edu,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,laoar.shao@gmail.com,gutierrez.asier@huawei-partners.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri,  8 May 2026 15:40:09 +0000 (UTC)
X-Stat-Signature: wtw83wbehz6kttk9u4dhciqb8jxqamzc
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A07A100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778254810-1719
X-HE-Meta: U2FsdGVkX19Jf8xYlgbhiLOn+hwRFr0WNf+t5DvnDspTSELFTUJVlVeUlIpyaeanDGrT3FFOKvIg5CZMx9DgCMZB0s9lVlo/XBWWEuJ+m3sOAAog8d6EVCc1PpMTNPu5gjF1pcf/lhTUcFZBQOGz8R5rmPoYgoGJ9IPtcRheaGF4rR42x5PCoKuJ/gzKxs6ex+4ztwdI19QK89gxmGQ8xJnqy3rzPQ06w4Pp+paZv4fsq6zV0UysgxBly444KnZfjW7GJt874XtFA/uCT2oC0FUEbo8brLBIhoeZWVP0/wehWA/mm0JbShkTLixCUgeu1YtGBRR331FEA1yyXzOIcD+GNq6jGaVeoN7iiw+wy9/xok+httthHgrw0T3pL3X+/ZvW5ChmgJDB8tsyDJw2ZJakQyvRjF21Gq3edvX4cnWFE/iDqvMbTGcG8yWEi5QoNDo1kZkR8Aghzv4cltbzdg2V2540evYp8c813IrUO3DYt+1NbDEr2MuTPYEHQeEFlc0GAhepWng09wGNj1cYmE3YrTa2zxfAZ+dp1p7qb+NQu2Nx83WAZ8/WtA43ehAJ7igtOYvPwSP/h56kKeS6dTAahs2Lmal9gRIMeypTfrONbXijwTMRF2aHRsUJhDn3YXb5JKuEe5JaE2xJxFGDI+4b/ybe3rJzO+Csa/HkKUa+JJwfduPv8VyCMkQ2uqZGJAr2cmbxE0VyGAw7HIUpc8lzRXruIzS/ARaJ03Kf02k2O/zg+a0fV/BDH9skR19hoBWBzQ62+6ZrIoj7iG5yNzCsf9TJ5M+lI4EniafDxpBFbsrAHr1QlHen9KOAD2JTaWz9yXO1X1XtcLOGJLbKFsb+cHFIeFH+Yl1WmGqQWCsXDOKXgArbpnyDW29AO5tMlkCePuieO7cA4ukH2DgR0U7mKze18dG40e6HruNcddl52nsm6y/Rbxhk+naeuElMxq0PMQaqXFtwzc2gCEZ
 Bug9wt7T
 8dRZ8HW8IVEDjtyA6VekfA+X6/IJOhX1h4+RbvYptvSG5175jw/61P7Ekb3GoSCUzwlbHe27Oz8477ITJOfx3MjT2QAKj2oC0khuW3MmRHSZw/uI1ZEai3ajnpUWn4kYh+m8uAP7ftdsVoCkFaxRRRwBjF6b617MzNPYZsh5iIL6ZhLQSzYYFMYT1lF3W8i0xaya8j20XP7ZSKtjDaDZ9hFQwr7zt8hmPmoxAXOTyIjk84M7snROBTpnkeN1BfEZSIK55rHMVkfiVYF+fhNj7bZqqNf3EROAJAZt4tV6PJBu5xvD/EqpRKH4DGMJEkyHOJGDhzoFC6LMRSjY8edOYR3ZirIrOjiwxH+/GwgI4V4sqWyMHeFJnnIIHKfhWWQzqCL2MYR5sfGBNMIXdvi58HlDkjBTIuNgeb47R+0tA40cdBSGqW8lGcfhOGUcAMo8ZRDnTq6j87S4FuUq+KxJnEeCAU0td3yIeIkhlLOPKWZm0Wr7Ts25NscwHOtzqkkdnCtxGd6e5gjd34aoDqN3AYx8Mb8fMtPChqJSc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1780306519113491024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index 7b4fd8190810..243dcf97bea4 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -52,6 +52,10 @@ static inline void psi_memstall_enter(unsigned long *flags) {}
>  static inline void psi_memstall_leave(unsigned long *flags) {}
>
>  #ifdef CONFIG_CGROUPS
> +static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
> +{
> +	return NULL;
> +}
>  static inline int psi_cgroup_alloc(struct cgroup *cgrp)
>  {
>  	return 0;

[ ... ]

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index baa12b24bb64..5562a6c9d2f9 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -29,6 +29,7 @@
>  #include <linux/task_work.h>
>  #include <linux/irq_work.h>
>  #include <linux/buildid.h>
> +#include <linux/psi.h>
>
>  #include "../../lib/kstrtox.h"
>

[ ... ]

> @@ -2881,6 +2882,37 @@ bpf_task_get_cgroup1(struct task_struct *task, int hierarchy_id)
>  		return NULL;
>  	return cgrp;
>  }
> +
> +/**
> + * bpf_cgroup_stall - acquire the total stall time of cgroup
> + * @cgrp: cgroup struct
> + * @states: psi states
> + *
> + * Return the total stall time.
> + */
> +__bpf_kfunc u64 bpf_cgroup_stall(struct cgroup *cgrp, enum psi_states states)
> +{
> +	struct psi_group *group = cgroup_psi(cgrp);
> +
> +	if (unlikely(!group || (u32)states >= NR_PSI_STATES - 1))
> +		return (u64)-1;
> +
> +	return div_u64(group->total[PSI_AVGS][states], NSEC_PER_MSEC);
> +}
> +
> +/**
> + * bpf_cgroup_flush_stats - Flush cgroup's statistics
> + * @cgrp: cgroup struct
> + */
> +__bpf_kfunc void bpf_cgroup_flush_stats(struct cgroup *cgrp)
> +{
> +	struct psi_group *group = cgroup_psi(cgrp);
> +
> +	if (unlikely(!group))
> +		return;
> +
> +	psi_group_flush_stats(group);
> +}
>  #endif /* CONFIG_CGROUPS */

Will these functions build when CONFIG_BPF_SYSCALL=y, CONFIG_CGROUPS=y,
but CONFIG_PSI=n?

The functions reference several PSI-only symbols:

In bpf_cgroup_stall():
- enum psi_states (parameter type) only exists in include/linux/psi_types.h
  when CONFIG_PSI=y
- NR_PSI_STATES and PSI_AVGS are enum members only defined when CONFIG_PSI=y
- struct psi_group's total field doesn't exist when CONFIG_PSI=n (psi_types.h
  defines an empty struct in that case)

In bpf_cgroup_flush_stats():
- psi_group_flush_stats() is only declared in include/linux/psi.h when
  CONFIG_PSI=y with no stub for the !CONFIG_PSI case

kernel/bpf/helpers.o is compiled whenever CONFIG_BPF_SYSCALL=y. Since PSI
is an independent config option, the combination CONFIG_BPF_SYSCALL=y &&
CONFIG_CGROUPS=y && CONFIG_PSI=n is valid and would hit undefined symbols.

The cgroup_psi() stub added in include/linux/psi.h only handles the
!CONFIG_PSI case for cgroup_psi() itself, but doesn't solve the unresolved
PSI types and functions. Should these kfuncs be guarded with CONFIG_PSI,
similar to how kernel/cgroup/cgroup.c handles cgroup_pressure_show()?

>
>  /**
> @@ -4734,6 +4766,8 @@ BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
>  BTF_ID_FLAGS(func, bpf_task_get_cgroup1, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_cgroup_stall)
> +BTF_ID_FLAGS(func, bpf_cgroup_flush_stats, KF_SLEEPABLE)
>  #endif

These BTF_ID_FLAGS entries would also need CONFIG_PSI guards if the function
definitions are moved inside CONFIG_PSI.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25563319416
--===============1780306519113491024==--

