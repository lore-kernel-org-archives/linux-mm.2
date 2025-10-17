Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70264CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 18:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FE98E0009; Fri, 17 Oct 2025 14:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A1C8E0006; Fri, 17 Oct 2025 14:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F5E8E0009; Fri, 17 Oct 2025 14:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3D38E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:23:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 318EC1190BD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:23:19 +0000 (UTC)
X-FDA: 84008428518.02.36BF10A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 934F780002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:23:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NiTtH/NM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760725397; a=rsa-sha256;
	cv=none;
	b=nMGER+n8ZunG9SjURgiK7Toxpp04tyaEzXB3koeZx0NsX1mKUFUNF4xevxebcWovyRrg1V
	uVPaSrRz9JBLEcBZgfMT5uVNd+R0NaxOxh/qZExMQCw76G0yQ2IeoI4QPqYizAMlq7387k
	aQhcmHXehF7FaxtFHQEPLpmDPedpUi8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NiTtH/NM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760725397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9D138k6BmKmfIaMfOCaoDNtzs1ScrJQc6/3mcUUFmss=;
	b=DWqFDKewjLCfULcOFKE3tITItQCRbsYick5a1pIMspiu58TYzJWSb+Y6Uu7RE/ym7ViDm5
	41OeyurDpR/yR/JWjXnTqCm7iwEXS3LUbT81zmrC1RooODZr/BMYD0zZPVy+4WqPe51NDm
	3SdzsIpiRs46FFD47mxTle34VgOIVeU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07C696483F;
	Fri, 17 Oct 2025 18:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FBDC4CEE7;
	Fri, 17 Oct 2025 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760725396;
	bh=S46XaZclhcxXbcJdWjNUfPnuzr9HjUARlDUOAUroKTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiTtH/NMd7b5WSERP3F1DvIifA1SxqgGtCVD+HzfAC9rq4Rm5cC39HEnAXS+Ww8eu
	 HwLZXyqELYPbcHPeo069rgenaWcq7nb/gIX3Jm3WlykVSBoP9Kp59sj/8ujAgK5RjK
	 +zXfqO227jnawL/KiWdFb5iKmuoTUh8hmkKgpcXV78AjV2LJhHL6dHRkKOimKOA5/s
	 bFfHkzIo9M+3laZugBJL4y4Zs0c/1hwLN4xZatUaG+uRlch8GIQilb2tiu3FgEGB9s
	 M3IP9eti2nxCT1+Cg2VT17/9Ylsspp7LUJRRUPturDrOl7MKVWhWGBF+Kk3PjEPsH5
	 6OwDNW9Oq7RNg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 06/10] mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
Date: Fri, 17 Oct 2025 11:23:08 -0700
Message-ID: <20251017182309.124449-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009212042.60084-7-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8tbrdum9pcm68xwi5zc1hers4m1yy7j5
X-Rspamd-Queue-Id: 934F780002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760725397-190105
X-HE-Meta: U2FsdGVkX18aJFnY5aFg7RcSUybDActaR4P6QKMAIu1nx9zEgO5Sbfazzm8R1h9qT2C8swb6psxfopKl+EroWyLczfbNdlQlt3OS2zcV0hSVM36lWVcSn8zpQ6r7cqBjZ1mXtA/i0DXDJS6MPwCQ9TMo2GdMA1KuIuVIkKod8OsxcEWB4huHJ8uMNzM5yJg68dhaYYDj/XjAhCfQeRoJtuX1w1vzcaFg8WAw/l7vfGpOOscgBsIpZceQieLrD2kQHifzT8URfkpi01axUMDtWvG990R4Ym6G1Mfvhle8q43aJE1ohSZG3AxxaSWGkU/RLfRP+195zQkQC/XAO6v8Keqwm9AIAyy23RfLx5r5xByUKl7k858j7d3md9Wh0bsiRjFKlrMT2ICe38kxfHnbwosdVAziLK99htEw/CsB0Qw1FLtx+wafxbaM32So9MIq4COO55An0c6pu92mf/9NOGLwJMySgRDCQYIrnXdabxNwuswE8AIf37inPxDJ5ee8w72Oq0KyFLGdRDd7QHYZjv9ysvLXhsS6eR4be2OMlJf+FmtI5W4xlL8eIRXT4WLN85b5v+2kHK9vtPvYYJDYdklIJAPG7Cu+xAa1NFxcB9rZoRjpLEPBCuUu0z3ZhBmWqX3gu7vHUfHM0T+IjZ2/ufL9nZr1tw/I8ccjvNVXsFeceJ+Q4KXAUvsPwxeOl0uU1U1orHiGVa2JZSOF2QRAG8igmkKDm7xxgRvEcK6jZBx8eLhQq8r+ditCaw3c4YjV6eZ7wf0mWbwErC99YQLAfqwxVqVOi0I7s6OCI2OG7LCKLvjDu4XJxdY/5ZV3HcKFvJcrE5IoWPk7i1Cvbl2YXaefT/7DGUwlVs9dwqsGKTAnFvFh36HrdNlDw44S/klPrsrQ7cRO/vmAd51933dXOFpmbZSK93QVxRPg1uyHWHdprNNvguUZziOcr6qk4vtQ7+FWO1CBH1iuEFgGTxw
 K1403fO4
 kS/LuDDhtz59TQPLH/HUZdu/mWVameQPqgRM4WJ9UQwVspCaI900XPYKpuP1P2v14s6MCEv0XtAR07+TGwJL641+kmWrBDJaV5qmABiov+Tx3eSJJmMKmS1gMV3xtFRCQyG4Am2xJ1lsYriHoAP1F8hBXpb3I76sJAZRkO4lYp+jsJ1FC56aY6JJephhQjDhEi16pifi5y7KvIEY2tIVpGrM3VfgYnxfZ3uSP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 14:20:38 -0700 SeongJae Park <sj@kernel.org> wrote:

> Add a variant of DAMOS_QUOTA_NODE_MEMCG_USED_BP, for the free memory
> portion.  The value of the metric is implemented as the entire memory of
> the given NUMA node subtracted by the given cgroup's usage.  So from a
> perspective, "unused" could be a better term than "free".  But arguably
> it is not very clear what is better, so use the term "free".
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 6 ++++--
>  mm/damon/core.c       | 9 +++++++--
>  2 files changed, 11 insertions(+), 4 deletions(-)
[...]
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2039,7 +2039,7 @@ static unsigned long damos_get_node_memcg_used_bp(
>  {
>  	struct mem_cgroup *memcg;
>  	struct lruvec *lruvec;
> -	unsigned long used_pages;
> +	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
>  	rcu_read_lock();
> @@ -2059,7 +2059,11 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
>  
>  	si_meminfo_node(&i, goal->nid);
> -	return used_pages * 10000 / i.totalram;
> +	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> +		numerator = used_pages;
> +	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
> +		numerator = i.totalram - used_pages;
> +	return numerator * 10000 / i.totalram;
>  }
>  #else
>  static __kernel_ulong_t damos_get_node_mem_bp(
> @@ -2094,6 +2098,7 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  		goal->current_value = damos_get_node_mem_bp(goal);
>  		break;
>  	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
> +	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
>  		goal->current_value = damos_get_node_memcg_used_bp(goal);
>  		break;
>  	default:
> -- 
> 2.39.5

Like the DAMOS_QUOTA_NODE_MEMCG_USED_BP case, this patch should also update
damos_commit_quota_goal_union(), like below.  I will add that on the next spin.

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -826,6 +826,7 @@ static void damos_commit_quota_goal_union(
                dst->nid = src->nid;
                break;
        case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+       case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
                dst->nid = src->nid;
                dst->memcg_id = src->memcg_id;
                break;


Thanks,
SJ

