Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D897CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B54E800C7; Mon, 27 Oct 2025 19:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D038009B; Mon, 27 Oct 2025 19:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA42800C7; Mon, 27 Oct 2025 19:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57B198009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09EE812A469
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:22 +0000 (UTC)
X-FDA: 84045535644.28.DCE56BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E011C0005
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdfSt+qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608900; a=rsa-sha256;
	cv=none;
	b=oqCMVJ92ZHvT3RfzffHhtH9soQR+T+JToLJF80nGO6/mTHQfzb+UUB3mMhYABfychr8A6x
	aUyYz/xGtN1bjFeeIg00F7uxEMEPG2Tp9N9bv5uuEdU8n3ZI4k2SIE/4nggPeYSmNRwhK6
	uT869ds9EpEyGL3VMGhjMwjyhVNnJsQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdfSt+qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iw6T4DHLzRWInkHABVvuxpDQ+NaeVwYvgrkeMI/m+1E=;
	b=30ecbgP5YaZ8lFV3vnOzZIoTxniaunwih8v/LWxOYFJ/A7mmeFG8K8o5K6pO+vm1LCOYkS
	9Vd8xiAzndkW1N57VN2bFS3Ys1n0SGb2Hh9DCkAMCUpV0hiRqh0EKoqCa1aN+lwYTI7yaj
	IiWYUw/ThXz65OsxxiYE0BpkahXgq9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76ED1456B0;
	Mon, 27 Oct 2025 23:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB21C116C6;
	Mon, 27 Oct 2025 23:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608899;
	bh=MLA2F7QqX/OHamOWtkCHp8EpAAyPqD+AKaVfDclzErY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=LdfSt+qEFuOsqzkDcGpesXghVhkT08jYCM7RP9OwYjDu8goGtG28bHymsIza1f3BE
	 zl+bGqEumbTVhZbCz9Vm7LP0GMoDYhfhKHBm+8P3+/YSE03HJJgZ4xsYw/uLHkfd6r
	 IGoVQDSopFluJExhyOWO4BcEufV9V/kUvn8Orm5WLj5X4y3UYRfkBY7dGA8KvOgK7l
	 D1r5CIlh8U1OofwiyOLa1TW+FwjrHhXPqbQobUVJOd0PSigXtnlG8LdNN9mQVoCHT2
	 Iks6j5+9GVa3GXdk6fcuLA509k+mD5Z+oFUNBfWohSiCIukWUxyCx/NRMkXHUD2JYB
	 GLXAEufzn+/CA==
Content-Type: multipart/mixed; boundary="===============6631180569956951959=="
MIME-Version: 1.0
Message-Id: <9fd0fbd3d6e704d106423a333106d1296c916f288c3c3600ffde0539e8c266ec@mail.kernel.org>
In-Reply-To: <20251027231727.472628-3-roman.gushchin@linux.dev>
References: <20251027231727.472628-3-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:17 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E011C0005
X-Stat-Signature: wzxa9jh56rmdgufzykj36t3nnpe7ou5p
X-HE-Tag: 1761608900-210543
X-HE-Meta: U2FsdGVkX1+ZBVFmq5dSS8XPPszKWdS6O55v8D6co5bjS9yEungCThJVlk7E2xBDGZ7ooKX9PP81YRPmDX5U1CGPGFQZOlBmkEeLAWEM7qSIrHGib8S+fOJ0I33hvhkTwGG8+pS8YouNmLMNvDe+WsLdRKZZpxr6T5rJ39pt0lj/i94RHoIdBG1AhsbgIlmkXH3fwHBt/nWCm4nC7eVPFHRXlj3RbCYUitEJnO3wPK2lz4RAZ3FgbLdQOHKs26bZ8RVVEj+No36/mfNUr2JvCcJDE8p5dp8tkSAWADmlP6G2omch5UxPgB94xqcABB6Or9RqpxZ90gxJBqnF1QdGBP87xkGP4kpvT+fV917xHxHcTv7kO3eY5BMi3iwmRFVSdN87EJ8Zd97yxSd3QKhc3+cyWkOsv+4cDUlmLewmjonWQ8+fDqZf/CqcVNg9y9WxLb1iOaxPuIWh9yG71cpiuMZRQvLwFS4rX8evhSOq5qjer6QTKBL9q6IEiFLQ1O9eGiNSqSV3OI3k7J4kt9Ro81IWITjRuRMr/1U0Jq1CAL7leC76o+j1tjp5KX97EdIKHcdhdMt8j2gJx5Ry70KeBH7PGG6Blt5UkHHL8fekzOL00FKN1blxgs+AwzNOfWB3zyGxn0RcJih+sDuhRhgm2lcy8+1S+PAsV3HdKpJxFE0G88uucMS/ZZBgV+xyH2VFKCNX+eDLnoRkVC0YswUH6WXiV63fHn6wRun0vfqETjXMF496m0xFlhCpUI4bSRTVrPYMmkd2sD1r9Nszo51gqeKitNI1IBlTvrgdxXnb0dtHF5oBSS3N17Arz9/fer4tW9lnDMDk4+pH2Lnc0FAripFRqgL2qXZQVDJBYIE+fHnK6hWeDP7F8grSKfR3SEPW32V/ohrrSoJWOcf8OPWNu0thBT5YdUQSPUEgAPKwXKSkJzzy7UYA4rI7P8tIG+Bf+xCi0IJrgSY1K5EJb/C
 rGLCIoUm
 10+yjZyjPxQ4EcUJMIzllpY57+oMi17jl3FqK7iloS2iiMNXuq4Jmol+G/9Wbule52oYgfvKwAlaAvvW59dqEIKXyZH7YbTtIB07is/sTuh3rjtCUG5vUauluWb8QD5yZj9hFwruGPS9YkaKF78rJKShmnOX9+yPF5wBqIzSPsmtZAZj1Qln6n530BefLLowlZ7PVSr+12GmHe5Olgtx8IWLlAjJrdnntm7rAJt3EBp/RvGE9UAKond3reKbWOT+cZ9ZrzVo5vxUimu6avlJXP96O7F2CN3JLXGrdVclvPELxAh+kbHQlbWpJM8rg3JHs8AybbmsrumD/+QEJ67MV9k1hgGtFYQgY6snxNrXCeK+UYw0O6d7KdmIaMDCj6QIrSeXTqurJHtjADuTiajJIgNM3Topc3/Ti3KGl7bKr9MhQSv4wtQ4CG4WvOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6631180569956951959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 31d238f36a0a6a56efa48c847cb776e67ba2f079
Author: Roman Gushchin <roman.gushchin@linux.dev>

bpf: initial support for attaching struct ops to cgroups

When a struct ops is being attached and a bpf link is created, allow to
pass a cgroup fd using bpf attr, so that struct ops can be attached to a
cgroup instead of globally. Attached struct ops doesn't hold a reference
to the cgroup, only preserves cgroup id.

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index eae907218..7205b813e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
>  	struct bpf_link link;
>  	struct bpf_map __rcu *map;
>  	wait_queue_head_t wait_hup;
> +	u64 cgroup_id;
>  };
>
>  struct bpf_link_primer {
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 45cc5ee19..58664779a 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -13,6 +13,7 @@
>  #include <linux/btf_ids.h>
>  #include <linux/rcupdate_wait.h>
>  #include <linux/poll.h>
> +#include <linux/cgroup.h>
>
>  struct bpf_struct_ops_value {
>  	struct bpf_struct_ops_common_value common;

[ ... ]

> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	}
>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>  		      attr->link_create.attach_type);
> +#ifdef CONFIG_CGROUPS
> +	if (attr->link_create.cgroup.relative_fd) {
> +		struct cgroup *cgrp;
> +
> +		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
> +		if (IS_ERR(cgrp))
> +			return PTR_ERR(cgrp);
                        ^^^^^^^^^^^^^^^^^^^^^^

Can this leak the link and map? In bpf_struct_ops_link_create(), the link
is allocated with kzalloc(GFP_USER) and map is obtained with bpf_map_get()
before this point. If cgroup_get_from_fd() fails, the early return skips
the err_out label which does kfree(link) and bpf_map_put(map).

All other error paths in this function use "err = <error>; goto err_out;"
but this one returns directly.

> +
> +		link->cgroup_id = cgroup_id(cgrp);
> +		cgroup_put(cgrp);
> +	}
> +#endif /* CONFIG_CGROUPS */
> +
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)
>  		goto err_out;


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `bpf: initial support for attaching struct ops to cgroups`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============6631180569956951959==--

