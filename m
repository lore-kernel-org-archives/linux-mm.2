Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9EE6CCA476
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 00:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF94F8E0016; Tue,  7 Oct 2025 20:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0AB8E0005; Tue,  7 Oct 2025 20:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E308E0016; Tue,  7 Oct 2025 20:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFC6D8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:00:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88528B8A64
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:00:21 +0000 (UTC)
X-FDA: 83972989842.10.B9A9877
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E080214000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:00:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LkT/Y1g8";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759881619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWmLOLAMJI+oqnSCIm//JaBVbYEaEXBJmr1f5F68L40=;
	b=KUIlO+IN7OfIp9TueGrW9RhYyyckGlI14xH9Jk9g8OxNKP2BJf537z2t5/Vw6MRCN/9N77
	faTErxjWUvKLNAWowsUtf63aiaGH1iyAE1Z0owf2zMOMEI6X+avkm9nhVFblm6g/j3eu4x
	N+DDWJeNlazLLV57nOzyNJV4yMJ5WTQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LkT/Y1g8";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759881619; a=rsa-sha256;
	cv=none;
	b=PLQ2Hh2eurZOjIxUIcy8QzWfOWZYNC/1zmV8cd5s6PaXzA6qJOvt4x3aHWrSvaQL5dh0P4
	xBJ2bY30SzNvo0RyW7wgKPolGB70+BZ5OubYddd9Fi6z0s70+/KoyJFGqmn8U6TaNIRV5C
	Axe9AfZAyKBBei/Aeci8eUCK+ZKw3wc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6540600AE;
	Wed,  8 Oct 2025 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7425BC4CEF1;
	Wed,  8 Oct 2025 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759881618;
	bh=XJBMwUPakCIENOJ5JGM6h6npOfSqG5BKOSRQWEqhaWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkT/Y1g8sW+oeGcLJAYTuRKgha8oR+0vHhIYAkMnM/ilfxGTXWXxZ5EM23ntytBIz
	 vGe6WnBWm3S209VzN6FRC7thPPFPe6NsFMSmj8rF6dPa8xDX/pilKIa1WnoGBzHHfv
	 5Xw42YfvsCJkTLQvVhJeXM6cRl8j3ippxyUdrXkoCjt8TG+CWL42VX8ZnHBmb0Ue9u
	 qCQcTqRLI3gavlc4WWgcUdFMRjzNdHjxi+cyNb78GpNTPoBoE9eCYgF5aJ2wVZmeMB
	 7St8oTWhkrLjLh2n4ohruEHP2soTgKccT3fMOOzHMNH5KfHuSpRogI4ssf2n9GcG/z
	 rmOW68YW8kreA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 03/11] mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Tue,  7 Oct 2025 17:00:14 -0700
Message-Id: <20251008000014.2845-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250619220023.24023-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E080214000B
X-Stat-Signature: qwfwbagdnq1qx9smatkkj6uugqbbqhzr
X-Rspam-User: 
X-HE-Tag: 1759881619-405435
X-HE-Meta: U2FsdGVkX18Mz+bF27PrEFbGEP1KgkboJ3fqJGn0PeILFn+Jz5ooBFBWW0z1g54a9JBx+wj1TJ3HIzzBMX35qNkM3koeo9OEDO9bUvrr+lNozQOqc45SZluny+Oe5cqqgFZ9hZP6b5kZE5a+lb5fiRLd9uLNnjJwY0d9N+nZ6mC0l+saQ8kXdlcCI+qtSe4eF3KkDiD6sspIyZdPgHTvW7mzgyoZ7a8YL2mayHtyxLcPOOAyo46JYls8cis9iJE2ckW2F1FVXDhHPwW+50sgHW9+nG2sz2dUnFt6sw8XL1JRe9uUTHm2TmKnmQ1oPxzKFRTfbcOe9aHTeuOxB+PaEJ4dMzCIi3tmsyqytEBdb81dEH4AygsxmqIjkG2yTKxl5D18yj5nLZP80J0fYzOs4DgnpMnsi8fbTnX9N5dKRLStqV3BTpu5IaGhQxH2XHDlGzCMWIrkQxGtaPKK/iAsdrkzyYCnxRoz6rumAaJZ+hbwUDcj3CTssgtm7qQ9SCzJSG0PfrZaHT5S+kWm+2SDgBQsSOf2UHrV9cAcpiiAiiZ2SbJt7PFhCZghZV5Tsz9TS/05lwgSTEC/DPPL+HF9ReuOzZupW47KPQHJVwQdmagCIbBl6x9grVgTuVVhXdViVs0LtfRnHIDARO6HJGKvXEf+qLfFtXK70E8S1IKdsKNzAVUuvHysVcyf/lhCs0j0D2B4fDwJceTrQpMhcTDtAl2TEg+/V6m7/O6WEKyKeh2PIix4WxsXHgR92AAOnEh04DnbnKDVrJ3EOOp/FirYTtZVkxrFCZAeTR0YmJaaoHSKVH10Ilq+CG1blicJiwxmb923ajEXCqpnq/gQUQdOtk0D02rk5CleFPWdEYhsKBlgHDPlgnPwasrJtiaMSyeBghEMt0SC+J/0Ougck1TA4Q9M5ubRhZ4B3PnsBBGCJrMtEX/uvSpieMa28H4UYSrDrcVNVvGCMu49LRDQ9+3
 qeKLzaCO
 O9wLaq+b9ZyXdKl6m7HqPRpm+claLVytrK8is+X0PBCjUHVnCboEoEQhJZIoOjU8gomvRifDpYSm6r5Pq+3pEi/H1ayopsjn4IGwVgMcXcat/JH2tvmlHKAVc+hcG7ykis3O3gD+8+lPzlBYkXHlmNsUR8pLQEhRlmxguw2oSi2oV53Gnl1/EDCzGsoEoLy5rrOLPFm3/X6oqPRx5zPA8y35qVrtX+xbsYXlQyv92fVjWRuW2mYmS4VmBWomcwGhL6UWm6RKLE1h1MHn1OVpzdwpaCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Jun 2025 15:00:15 -0700 SeongJae Park <sj@kernel.org> wrote:

> Implement the behavior of DAMOS_QUOTA_NODE_MEMCG_USED_BP.  It uses sum
> of active/inactive anon/file pages of a given cgroup on a given NUMA
> node as the value of the metric.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index d675dd932a23..1481b43f2710 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[...]
> +static unsigned long damos_get_node_memcg_used_bp(
> +		struct damos_quota_goal *goal)
> +{
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +	unsigned long used_pages;
> +	struct sysinfo i;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_id(goal->memcg_id);
> +	mem_cgroup_flush_stats(memcg);
> +	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
> +	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
> +	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
> +	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
> +	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
> +	rcu_read_unlock();

mem_cgroup_flush_stats() calls css_rstat_flush() which may block.  But the
above diff is putting it inside an RCU read-side critical section.  Actually
only mem_cgroup_from_id() needs to be called inside an RCU read-side critical
section.  I will revise the next version to call rcu_read_unlock() right after
mem_cgroup_from_id().

Also, mem_cgroup_from_id() could return NULL if the memcg is removeed while
DAMON is running, but this diff is not checking the NULL return case.  I will
add the handling in the next version.

> +
> +	si_meminfo_node(&i, goal->nid);
> +	return used_pages * PAGE_SIZE * 10000 / i.totalram;

i.totalram is in number of pages unit, but the above code is assuming it is in
bytes unit.  This makes the result significantly wrong.  I will fix this in the
next version.


Thanks,
SJ

[...]

