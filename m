Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A52CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C185C6B0005; Mon, 25 May 2026 23:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7AF86B0088; Mon, 25 May 2026 23:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B736B008A; Mon, 25 May 2026 23:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEDB6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:19:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EA0C40279
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:19:34 +0000 (UTC)
X-FDA: 84808115868.02.0D2F805
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BA0A1C0008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:19:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=frFLxUh8;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779765572; a=rsa-sha256;
	cv=none;
	b=cCDjmU7H1Xp3d0q27nscQ+3aHMUx2hwFljUisJDRokMSA4988zLr1SHj+/9vBeByOeMkgf
	KRBoh6vmEP7DxkHU5GSHNDYfAHLR6abS7zqeviSfymg4WyP4O5x/I6HdFHgaRnZLqWZ/YG
	+kBfCa0MTEj5fJgoXa1UZRH5KDiaeZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=frFLxUh8;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779765572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nbBC8vyj2Y+oXRjDt4yU5hJnRR2glUHyIArPgLoD08=;
	b=ywFppqq+xglYWVN/LCVlUNuWdSNmCC+7/Y/7od+XW8E1gijmSa69xH5R8846D6bzXNLc4J
	33MsRtpMruHPNuHgRt42xOu+28uH2X8Mj4C0eW4K+yz81Q1iHJnfP2ms+lcRjew2X7HjeE
	pmw7jrpz0RmGfvgMXa1VfR0YmaTc5N8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFA63403E5;
	Tue, 26 May 2026 03:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D4A1F000E9;
	Tue, 26 May 2026 03:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779765570;
	bh=6nbBC8vyj2Y+oXRjDt4yU5hJnRR2glUHyIArPgLoD08=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=frFLxUh8yMsVt23Y3d60siTdXO4DsUns5PhQ5LTsLBHJ/I/xpfQ2g3I2bh8fOHugA
	 6JYUHl9S0cwQB9tk5dhTS0mS+wUQxz0tYz6t/uTbffgV1o+km1cwpZJeUOpr0znWiS
	 tvanztLgtZc4PdlEVNHqiwvNRSLOvYcy/Kdw0PSK/0D5p9Xw+RSVglDpFaShcK7qbC
	 QsfoFUlj84vYpb5ifwY3RFZiclwUR1yESOzL/Z8C/C+MjdFYhC0WUdApmr1hLfZJJC
	 MqiNDfPDu/KeKcM65s0tj83BnVlEzctCv3LKoBGZO2DDX/b5u6Ha4oS68R2zmO0MsP
	 z9L6Lcal0wQdA==
Content-Type: multipart/mixed; boundary="===============4389585652716092272=="
MIME-Version: 1.0
Message-Id: <a8c67f28d82471f8f6ee6d7d1d8a1385b1a2546d0ef60986ff80a0ea9b436d09@mail.kernel.org>
In-Reply-To: <9e081d01a0708dcdd101af7f7bede07cf43ca21d.1779760876.git.zhuhui@kylinos.cn>
References: <9e081d01a0708dcdd101af7f7bede07cf43ca21d.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 06/11] mm: memcontrol: Add BPF struct_ops for memory controller
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:19:29 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BA0A1C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: etphxuozsoy91com511psyu3yk7jdcxy
X-HE-Tag: 1779765572-481094
X-HE-Meta: U2FsdGVkX18U8nM3+zCPK9psCP/kv974XEehM1CtPFi70lJGACYganPcyCohShMB7CYAcer6BelaUCaqal0UVbQG+0McUGuRc7joSCVNkFj4j8bffxKXYufT81M/94YDJrgTRQJ/A3wNfDINwCAuIWrIND5Qyu2G37hVU7UZrk88TjazLTQbvU8hxI7oZhVqAOQKxfwoBfmOJclc8pH3Hr1fbqIJyANox6s6AOAx6OaApROCWt+7F9eJ5UKk5l/5RHWFT0ogCO/Wh/cCX/A13AJiQLRJ2P67edC7Z0/FKOJjcEwKibqNjLsSXF+GMDAsKFBGyo4xgxNXQkDTOniLn/u9Kuv72mSNhEz83IX5sOIU4efjPSE/xx6RGXLU+etQqgYBASxcj2eo2MxnJG4Nx9hs3WPt/qOOP6BanKSE3BVEIuohw2+r9/fmVW49SSQxjTdIXQWL7GKnpLpmRi/h08AK9ig/gAllKGLL4t7E5DLtBUONxvxqCl7JE96i5Gz/U1Wh07w8OIBmZtQwF3IIkAWf5qJQxyxDKmY6MP9/eOu1Rr7xMh2JxWR4aM4i6bYCnQHKUTnstIeJlp2mk+j/NZbXlf/GfHo06WEksFmw9cULLx7unKhiRpt0qlJRShPD9dh2EiemUrUkeU5FTY78byNGI5IKn0LsAeCCckUhVdBpZRyLyAMKP51xokphZ3x+LiLFIklzEBhvdKNRyZmg+6xU4uQ5V+jy9KrB/8IPNrZW+o69wbUIiWuYoMK7PI3W+/f3lBh+jnsPy2ScVg4ndhrF4jVUqAQRGdDsXwA/tTdxfevYL6vHeDag2wxj+JHzqAH4rr/7uaWi58EMA37Vejkj0/f/w30syJsjhDcAhrZ9Mz/AfFSWij6BRgQKLlyB3DoGkCMToEnFI0D7XuZpWB/ZYiEcTnIp54XPl/8fX+HGE13IChoHG4w4axpWUMriQl8ENq1RUQa3W9ThWck
 OumuBxJ7
 YlLeG9rMLh+8rBO6zJvlTu8EdNrWfg4K4TpDbbBb7e10u3PpSUGcQVzMtDDvyEbLYbE4uMu9B3aCX8lqoRhWwvCaahq7xh/51R8v2XT6jxuxLIK+McbFzLClwQ4547owqrrwbYJIfp+staiBb8SVGDqDBMHh7d1yQsf5LSIEc4ZCxf2LFOU6pc+c+7lH+xmyu/cY2bgY3Uz42mBpIrk5sKT16jRWSlEyUb5aoC+mzFgfQM3Bs8COw7yr2ApBcV0mlyWYEzKS82Vdt+qU2Dw/+9Bwuq/v9cR2UIDQ0+iEzgw+SQ/EIuO8cQHMB+H1+JZ6iUEUL3ZADQcmE11XGBHLI4yaNl7gux0bjz6bV3KA1hCugNcnsu0YP4+/5TkAfNY/w9bT/igDG0hiAzwe//n9hlYpwS3QdCcFRKWkt5GYHCao9EUGqoeWqbvW9QV8ivDmlaGBlXVOZRG10migTS63EhTg0Vf9Pm0aq7CLavhwazE5nFqRDdvrrloXCFe+UfmaFaxOHWTvVLbwwJz+pNbMNbBQUoBIm3p28bGMy/ryG8NYCOYBuebbYoFY1IBBUm6RSuYlfQ6eJYrEDMRB+l23jqvyLRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4389585652716092272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..1f726a7b22e3 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> +/* Unregister the struct ops instance */
> +static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *ops_link;
> +	struct memcg_bpf_ops *ops = kdata;
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +	struct mem_cgroup *iter;
> +	struct memcg_bpf_ops *parent_bpf_ops = NULL;
> +	u32 parent_bpf_ops_flags = 0;
> +
> +	if (!link)
> +		return;
> +	ops_link = container_of(link, struct bpf_struct_ops_link, link);
> +	if (!ops_link->cgroup)
> +		return;

Can this early return skip a required synchronize_srcu(&memcg_bpf_srcu)?

When a cgroup that owns a memcg_bpf_ops link is destroyed,
cgroup_bpf_release() takes cgroup_mutex, splices the struct_ops_links,
sets st_link->cgroup = NULL, drops cgroup_mutex, and then calls
link->ops->detach() outside the mutex.  detach()
(bpf_struct_ops_map_link_detach) invokes unreg() with link->cgroup
already NULL, which hits this early return:

	if (!ops_link->cgroup)
		return;

At that point descendants of the destroyed cgroup still hold
memcg->bpf_ops pointing at the registered ops (kdata).  Memcgs in that
subtree are not freed immediately because folios pin them via
folio->memcg_data after offline, and uncharge paths
(memcg_uncharge() -> bpf_memcg_uncharged()) keep dereferencing those
memcgs.

bpf_memcg_uncharged()/bpf_memcg_charged() use the BPF_MEMCG_CALL macros,
which take srcu_read_lock(&memcg_bpf_srcu), READ_ONCE(memcg->bpf_ops),
and then dereference __ops->op.  After unreg() returns, the
bpf_struct_ops infrastructure eventually frees kdata via
bpf_struct_ops_map_free(), which calls
synchronize_rcu_mult(call_rcu, call_rcu_tasks) and waits only for
classic RCU and RCU-tasks grace periods, not SRCU.

If the unreg() path returns without calling
synchronize_srcu(&memcg_bpf_srcu), can an SRCU reader holding a pointer
into the about-to-be-freed kdata observe a use-after-free when invoking
__ops->op()?

Would moving the synchronize_srcu(&memcg_bpf_srcu) call so it runs on
both early-return paths (or unconditionally before returning) be
appropriate here?  The other early return (link == NULL) looks benign
because reg() returns -EOPNOTSUPP for link == NULL and never writes any
memcg->bpf_ops, so no synchronize is required on that path.

> +	cgroup_lock();
> +
> +	css = cgroup_e_css(ops_link->cgroup, &memory_cgrp_subsys);
> +	if (!css)
> +		goto unlock_out;
> +	memcg = mem_cgroup_from_css(css);
> +
> +	/* Get the parent bpf_ops and bpf_ops_flags */
> +	iter = parent_mem_cgroup(memcg);
> +	if (iter) {
> +		parent_bpf_ops = READ_ONCE(iter->bpf_ops);
> +		parent_bpf_ops_flags = iter->bpf_ops_flags;
> +	}
> +
> +	iter = NULL;
> +	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
> +		if (READ_ONCE(iter->bpf_ops) == ops) {
> +			WRITE_ONCE(iter->bpf_ops, parent_bpf_ops);
> +			iter->bpf_ops_flags = parent_bpf_ops_flags;
> +		}
> +	}
> +
> +unlock_out:
> +	cgroup_unlock();
> +	synchronize_srcu(&memcg_bpf_srcu);
> +}

[ ... ]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 749c128b4fad..3494f36d792d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

[ ... ]

> @@ -2516,11 +2522,15 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  	 * memory.high is breached and reclaim is unable to keep up. Throttle
>  	 * allocators proactively to slow down excessive growth.
>  	 */
> -	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
> -					       mem_find_max_overage(memcg));
> +	if (nr_pages) {
> +		penalty_jiffies = calculate_high_delay(
> +			memcg, nr_pages, mem_find_max_overage(memcg));
>
> -	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> -						swap_find_max_overage(memcg));
> +		penalty_jiffies += calculate_high_delay(
> +			memcg, nr_pages, swap_find_max_overage(memcg));
> +	} else
> +		penalty_jiffies = 0;
> +	penalty_jiffies = max(penalty_jiffies, bpf_high_delay);

This isn't a bug, but the if/else here mixes braced and unbraced
branches.  Documentation/process/coding-style.rst (Placing Braces and
Spaces) asks that when one arm of an if/else uses braces, the other arm
use them too.  Would something like the following be preferable, and
quiet checkpatch.pl?

	if (nr_pages) {
		penalty_jiffies = calculate_high_delay(
			memcg, nr_pages, mem_find_max_overage(memcg));

		penalty_jiffies += calculate_high_delay(
			memcg, nr_pages, swap_find_max_overage(memcg));
	} else {
		penalty_jiffies = 0;
	}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============4389585652716092272==--

