Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288B9CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1576B0088; Sun,  3 May 2026 13:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7824B6B008A; Sun,  3 May 2026 13:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6990D6B008C; Sun,  3 May 2026 13:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56E306B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:35:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F21C8140756
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:35:22 +0000 (UTC)
X-FDA: 84726810084.20.68B7C3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 514D44000B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:35:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/qnPCnN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777829721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2zwi3JifuXPfD2FZxW9u0hJ7oeddcShUI1/6+9SL0Q=;
	b=5YDcF89QuPmUYRg+Nfde/E6W9eBQ9486BfGa+O3n0x6PKVfB2uH8DsbgBBGKkWBy/YnS46
	ec0yNsegXQVPr59tMcPhLX77g2GoEO3GGiqDsMYMwCdgquuT0ZY/PYTdXkiXAwPMQI7gv/
	edQN82YFEvFNWynxkJqeBAq6n+MpwGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777829721; a=rsa-sha256;
	cv=none;
	b=D7EtO8pzsGCKrd/b0Fw8G9932Qo5Ps4e0PiJQFwq4sN7EkTMFNGx8wJHE4hRAdKe0qV+MK
	cLeLKMzJ3MTgQiNrQN7Bsq6G8bBx8JT+XZWTP3ataZ/8dFfxozj9rxCARuPo4T5aV3uhfG
	hNj8S6dw/OMzI74Lj0J0MnVoHQxiryA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/qnPCnN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 564D343EEE;
	Sun,  3 May 2026 17:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FABC2BCB4;
	Sun,  3 May 2026 17:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777829720;
	bh=CdlmhbfZE6Tu9vJOU5Y1P7jHBS+VbmaeGREcszsgiNc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=r/qnPCnNeJ+NKDnTJ7j57PzGW896Y7T83OKbIbQf6UnyOnTNsW8ZD1RqqmoikZD0+
	 ZUCzaK8YhhWNN+a+sxtY7K0+9da4zzaKRoMkYf9FN5xX0PYdutbEoznDtDBJBCU36O
	 A7JCXoo9e3w9f3uVolU20piDR053kkYiXYKrjBEB0GEQwCv71TkHRpknUXboJJq+dJ
	 MMixH8bkgBGpjJw2mpdMZVJBlIAk65ij0MhISd9Y2pe0Gc5Fd+UJye+AY71g1nsrvt
	 6dzIzxw+1nrRLcdwu2FKi9yTtjv+WyJFFNegYyzGLfBD+srQFNtorNmQjPhHnitovT
	 Rfyy1oD5APRTw==
Content-Type: multipart/mixed; boundary="===============5550520783914532141=="
MIME-Version: 1.0
Message-Id: <a74b6b1d137439121917216ef386bbab9107afcc89819d1fd94e389b8c54b4f1@mail.kernel.org>
In-Reply-To: <20260503165024.1526680-4-vernon2gm@gmail.com>
References: <20260503165024.1526680-4-vernon2gm@gmail.com>
Subject: Re: [PATCH 3/4] mm: introduce bpf_mthp_ops struct ops
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sun,  3 May 2026 17:35:18 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 514D44000B
X-Stat-Signature: 871uu7wopg11iqd7ddxwi4ipqxrs998a
X-Rspam-User: 
X-HE-Tag: 1777829721-171877
X-HE-Meta: U2FsdGVkX1/6iXloOsXSe1HDsA663jjBUdqdd7gbMjvxdunjED6kyXmQrojFlpDpFKRkkFXQkDSAn1omPl+6xBBXJYD6ZYFceXiaFrpJ52W/MI9MTn7SCpeGSKfQsR1jAiBRxl/sklm+7aMrctUZw0BJB145y/Bcxugiceos9OD6L8B62nH12iQgDvinEgELB7D41m4p7hMnzSISRSPYs0VcLvmfBx3jNqMShM5TVFaoERBTmN7gf7m8bneqltsyoGjtn17xhdlTZHQAP4B3boJzaJrZjnVnaEBCKpO3n+ydviJQmon8tHTF+Nw4lrzYvJZD9ElB3JGnrNFuNXsG+F+V4IAhQDJNVkknwF5XaybA5urEvrA8T4/CN00n990oK2OZ6P0K3JKzRnjWDughhuIi5eGf7KRLb3YPM34B5M3KCKmjhzmoX+AsjVksfkJ/TLPnptKBN1itgBctOSSn5uyXPoU8t/zHremfctgohUWXY+EItC0IPOL2a1vp5Y4jxV225wqQEZ3qGuQnrUzuLYZhtpB84zkjWBFHLgIrcMVuoCg58LauleXBwiVxo2CQeQIuwl9dqhFjC1XnevwnlBfg9vpHMYPKkEBxsqaOupHraOA5/ad/HXvZkf9z+GFnYDTBU+5MGaVLdxL9JvQ1tqNWKpVTq4AIeT3R62fKsMMpCuTXGTB2rPe3ehY9LIi9L9jlYopfwbDVJ5TUi6dn8YN7slTOxVv9jcRl0JVrV0G0ZvD+ET0IrfBq0u3g5AbletOcckSWFoi/FJsZRBq6lMQvXDL12FOrQmUFjYUVFB87zP3r7saZbMHy3b+ekAInk7AdTkN0/+Bhp2ojRM7IwHfyS37+XNNM6VyArzJlw/8omBbLBTcEn0YJ+eU3QTH77VY5u5LBtqFDZYgY79gQD+GdbddyiQijOWeN4SZ4RyqJ7RbocD3UpLTY1v5EN2GD1wX3Qyd7CCWFJwupMOZ
 1qFHcCeS
 n02TXqRb7Mub+ppuvY1u/a4xq/xHb+2ZSUGuRJJkHkrIEvFNgoD332VF0e62yc7NdqZRrz4WG13f2jqN+PLblqsnWERSnyhAZVwLUtKdMoDDWf13n24188GnsRT05NDeeGE04N12Zq9JC4qtdV2fn5780M4cZCpUL24coi1PBlDMWMy4v8mlOIO0I+BQl81+3b+SF7twvXzwTaODGQBw7e8ix4PTW0ZZlWepkObP90t0oagC1N8Cox7dxwfp3ol4rjyiXIlv0XIMP+6ftgtvL94CGWoc2nYSuzIGMC+i0a31Td1uVTzkfCgnY9zDEtMWyJnEGEhZ+aLxKII3XjYH1ukMwn4fBMUkkiWeZnKaMao63WvJQNXApchd9sEzt8y3A5EmCrfwHKJyVNE7PSVtg54qFSAqdDHNTog0AJZ5nJFvjPgqjOTJkVwLLT3T85m0mOWarjA80KLqyai02KGbXsM6TUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5550520783914532141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/bpf_huge_memory.h b/include/linux/bpf_huge_memory.h
> new file mode 100644
> index 000000000000..1c8a6f7ad8f1
> --- /dev/null
> +++ b/include/linux/bpf_huge_memory.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __BPF_HUGE_MEMORY_H
> +#define __BPF_HUGE_MEMORY_H
> +
> +/**
> + * struct bpf_mthp_ops - BPF callbacks for mTHP operations
> + * @mthp_choose: Choose the custom mTHP orders
> + *
> + * This structure defines the interface for BPF programs to customize
> + * mTHP behavior through struct_ops programs.
> + */
> +struct bpf_mthp_ops {
> +	unsigned long (*mthp_choose)(struct cgroup *cgrp, unsigned long orders);
> +};
> +
> +#if defined(CONFIG_BPF_TRANSPARENT_HUGEPAGE) && defined(CONFIG_BPF_SYSCALL)
> +/**
> + * bpf_mthp_choose: Choose the custom mTHP orders using bpf
                      ^
The kernel-doc format for functions uses parentheses followed by a dash, not
a colon. When scripts/kernel-doc processes this file, will it skip this
function documentation?

> + * @mm: task mm_struct
> + * @orders: original orders
> + *
> + * Return suited mTHP orders.
> + */

[ ... ]

> diff --git a/mm/bpf_huge_memory.c b/mm/bpf_huge_memory.c
> new file mode 100644
> index 000000000000..e34e0a35edac
> --- /dev/null
> +++ b/mm/bpf_huge_memory.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Huge memory related BPF code
> + *
> + * Author: Vernon Yang <yanglincheng@kylinos.cn>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/srcu.h>
> +
> +/* Protects cgrp->mthp_ops pointer for read and write. */
> +DEFINE_SRCU(mthp_bpf_srcu);
> +
> +unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orders)
> +{
> +	struct cgroup *cgrp;
> +	struct mem_cgroup *memcg;
> +	struct bpf_mthp_ops *ops;
> +	int idx;
> +
> +	memcg = get_mem_cgroup_from_mm(mm);
> +	if (!memcg)
> +		return orders;
> +
> +	cgrp = memcg->css.cgroup;
> +	ops = READ_ONCE(cgrp->mthp_ops);
                ^^^^^
> +	if (unlikely(ops)) {
> +		idx = srcu_read_lock(&mthp_bpf_srcu);
                      ^^^^^^^^^^^^^^^^^
Could there be a use-after-free here? The pointer is read BEFORE entering
the SRCU read-side critical section. If bpf_mthp_ops_unreg runs on another
CPU between these two lines, synchronize_srcu returns immediately because
no reader holds the lock yet.

Race sequence:
(1) Thread A loads ops (non-NULL) above
(2) Thread A is preempted
(3) Thread B calls bpf_mthp_ops_unreg, clears the pointer, calls
    synchronize_srcu which returns immediately
(4) Thread B frees the backing memory
(5) Thread A resumes, enters SRCU section, then dereferences ops->mthp_choose

For SRCU to protect the pointer across its use, the reader must hold
srcu_read_lock before reading the pointer. Would moving the srcu_read_lock
before the READ_ONCE prevent this race?

> +		if (ops->mthp_choose)
> +			orders = ops->mthp_choose(cgrp, orders);
> +		srcu_read_unlock(&mthp_bpf_srcu, idx);
> +	}
> +
> +	mem_cgroup_put(memcg);
> +
> +	return orders;
> +}

[ ... ]

> +static int bpf_mthp_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
> +	struct bpf_mthp_ops *ops = kdata;
> +	struct cgroup *cgrp = st_link->cgroup;
                                ^^^^^^^^^^^^
Can this dereference NULL? When bpf_struct_ops_map_update_elem calls the
reg callback at kernel/bpf/bpf_struct_ops.c:873, it passes link = NULL for
maps without BPF_F_LINK. When link is NULL, st_link->cgroup dereferences
NULL before the check at the next line runs.

> +	struct cgroup_subsys_state *pos;
> +
> +	/* The link is not yet fully initialized, but cgroup should be set */
> +	if (!link)
> +		return -EOPNOTSUPP;

Does this comment match reality? Looking at bpf_struct_ops_link_create in
kernel/bpf/bpf_struct_ops.c:1397, the link was fully initialized by
bpf_link_init and bpf_link_prime before calling reg. Also, struct
bpf_struct_ops_link does not have a cgroup field in its definition at
kernel/bpf/bpf_struct_ops.c:58.

Also, does struct bpf_struct_ops_link actually have a cgroup field? Its
definition shows only { struct bpf_link link; struct bpf_map __rcu *map;
wait_queue_head_t wait_hup; }. The patch does not add this field to the
struct. Would this cause a compilation error?

> +
> +	cgroup_lock();
> +	css_for_each_descendant_pre(pos, &cgrp->self) {
> +		struct cgroup *child = pos->cgroup;
> +
> +		if (READ_ONCE(child->mthp_ops)) {
> +			/* TODO
                    ^^^^^
This isn't a bug, but per BPF comment style (subsystem/bpf.md), multi-line
comments should have the opening /* on its own line in BPF-related files.

> +			 * Do not destroy the cgroup hierarchy property.
> +			 * If an eBPF program already exists in the sub-cgroup,
> +			 * trigger an error and clear the already set
> +			 * bpf_mthp_ops data.
> +			 */
> +			continue;
> +		}
> +		WRITE_ONCE(child->mthp_ops, ops);
> +	}
> +	cgroup_unlock();
> +
> +	return 0;
> +}
> +
> +static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
> +	struct bpf_mthp_ops *ops = kdata;
> +	struct cgroup *cgrp = st_link->cgroup;
                                ^^^^^^^^^^^^
Can this dereference NULL? Looking at bpf_struct_ops_map_delete_elem in
kernel/bpf/bpf_struct_ops.c:936, it calls unreg with link = NULL. When
link is NULL, st_link->cgroup dereferences NULL.

> +	struct cgroup_subsys_state *pos;
> +
> +	cgroup_lock();
> +	css_for_each_descendant_pre(pos, &cgrp->self) {
> +		struct cgroup *child = pos->cgroup;
> +
> +		if (READ_ONCE(child->mthp_ops) == ops)
> +			WRITE_ONCE(child->mthp_ops, NULL);
> +	}
> +	cgroup_unlock();
> +
> +	synchronize_srcu(&mthp_bpf_srcu);
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25285279315
--===============5550520783914532141==--

