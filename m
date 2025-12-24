Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E6FFE74917
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A2D6B0005; Wed, 24 Dec 2025 00:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907F86B0088; Wed, 24 Dec 2025 00:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9FF6B008A; Wed, 24 Dec 2025 00:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CABD6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:21:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 194541A01B7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:21:59 +0000 (UTC)
X-FDA: 84253217958.17.92B985E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6817E40002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:21:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVRlH+oy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766553717; a=rsa-sha256;
	cv=none;
	b=0dM2XvoIe4j3vS1fOKkfZubmVnjRMX9CPskiCowj3ne4T0oWvQ1GFZSGv4Di1SUf9qdZ2m
	CuLfDQ9+oM4SBVRWN/vmMtkLo4wOF0ETEsHQ63Qwg8iUUWoofP/YG5CHEtyaZ+uJoqbxd6
	rNimmW2QbwWcChVucNAJA3ySyQirsoA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVRlH+oy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766553717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RP9/QQKvBwW5MEOApDEMa35jTONp/NmvNh1b2EqvQ90=;
	b=Q5Q9xlAdllQmA4RS491fKuTXsW9YGXaTsV2/56eqyJa+OuSpgkW/iXJcxVqsSxwbm4jBYG
	pkn8sxosfppyTSA3VJnacUKxobjVk39MIEaBORoiXkmb5Cb8g++vx8M+FpnnOH88/6+m9G
	KXwh9oKCpbWePCcK2ieS1PnwjMk58Rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E733441D9;
	Wed, 24 Dec 2025 05:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D318EC4CEFB;
	Wed, 24 Dec 2025 05:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766553716;
	bh=1i0AGvXVVrHdy9xcXcgBlco2Ngv8dnUQED7TtSQCPlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVRlH+oykfekemzk2FwHD+HxDBl/P+HAohM82+BUGVn3Xs2qbZKAzgevGU3mQSa4A
	 bFPC3hkGmyKkS2YKWZIKn5u0FHtrUW1ClsbyboFV/cyFQn/snsEN+c8bN9lvZlq1Kb
	 qo69DA5iAGcoKvAHy2Z4sZkZROgvbNkh7rOkdwjmkxwJ7ZjulRSxC1mqICtfBJnpou
	 yMtW4jiO+qspAv8tFpozGD7E/Pq7M3DPfvFJ6Q/cYG7Mlw0X1Oa3j4DWOQETieS8Nk
	 eUZCrNtHGv8AVtfQ1SGw/flpI0A+AyX1ESZ9syiYQum5luL2nagBZGYOvOfhfF7+C9
	 oRe1bFeQR+KaQ==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: damon: get memcg reference before access
Date: Tue, 23 Dec 2025 21:21:47 -0800
Message-ID: <20251224052148.68796-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224034527.3751306-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6817E40002
X-Stat-Signature: gaujrzdthmk9aoroj11f5uk3njwaaycw
X-Rspam-User: 
X-HE-Tag: 1766553717-760436
X-HE-Meta: U2FsdGVkX19EFcvvno9ySMMvC62J9FitAazHbbm/7MKfirSylD7AiCvxktMWGXlLFQ3zT2PeY+rhjWbQ4+jwxPQ59NVUSXWDtGLFAacqQ1o9iqWnBPHpK560haLVtQyLy8OuybvbbDQx/IITMWnEeKNyAy68nsr7A5Junzz9o2vfQ32jcU4kUfZoeKpKAQt/yltQP+jk1VMa5lW4iXDdhY5dGCGhvvp4WsC/MeHMZ5SlhS+GqUVzcyBo5WXzHKtevYf8P3DZk7u3Gu24KH8DS8iR3KmP0iVCpmR3pp3zFQPhfW9lwEnO4t5muZZjNFA3OuSJmTQySPvDf8QD1NiI+1VodvyF8OANsRNLWc6QMwtqI0nazawT4ZyKOomBDAl0FLb1ign4P6srUhWkdOlah5aYgwm76ILlEpash1n0QZ7hdyZpId1dm/YXRy5vGvG5K/MJQQr2G6hFLajvNuWZGjIkMsJUmfMvK/VKqJNOFrj0/xI26hNDQRLGtDEaFbE70aQCSM5AwZy5kzpI8dLED6K601sENWDw/8DCp/hMSvwuLKk/OJVz2QP4sjyZpbqG96nQvelvHX8XlpNm8d1XUG56fz+JI/Gs77+SJAbQTOFZOEXGDI5n/+e6rikvK9KKAqZi/lzVPM9eVZm1l5Ovz5MmvXamhVvNNUvlifRnzr4ElBJLlctuOpqFsHHzBiXZqW6DOidl1zaq900XvurfDIWaCY4v+t85d56FgR7Wf7Mmf3XrpVRtp1avCHmyPbOOblTOzbzWa6/wDn9vUVqo3H2+5GwE6T0UeSF96cIa1nrVa7yZSCLTtMjIq/I4rle45KHu4YNQ+sfJWWY38mU/XR1tAvn/ukR0xy5NL+cOTAqIipNfkNtd5KL36yH7TvUdNi6JRRU4OSdBj4z0AD3OSHA5hUE1t2Y10Yg5X4YdsHm1pVI3gWe3VSdRysahKD6xNTpHyJ4cvWJJ9EfdRDF
 fQEfkvjO
 urKKmwX2hvDrSamo/wb6PaZOUEyn0vr9yAx6D+Ym0t3xMHLqTymjwGxqbf6yiPN7Ilqtp0+BB/PxxzKtV7Fg1icNKb5eiigLayl5K0Tk/lozr41Ii2cKnWHCXgradslwTArOpK3dnom/U0/zUxeyUPPAEhx5X2UluI/d8uc9J0Oe3urJvp0lBJIvSpmAy9Z3THkU0OupYkNsKMb2X9mPB9KhgRr9OmjIr7QOPuCOJPdKUUvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 19:45:27 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The commit b74a120bcf507 ("mm/damon/core: implement
> DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure
> without getting reference to it. This is unsafe. Let's get the reference
> before accessing the memcg.

Thank you for catching and fixing this!

Nit.  On the subject, could we use 'mm/damon/core:' prefix instead of 'memcg:
damon:' for keeping the file's commit log subjects consistent?

> 
> Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")

I was firsty thinking we might need to Cc: stable@.  But I realized the broken
commit has merged into 6.19-rc1.  So Cc: stable@ is not needed.

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Other than the tirivial subject prefix inconsistency, looks good to me.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 4ad5f290d382..89982e0229f0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memcg_used_bp(
>  
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_id(goal->memcg_id);
> -	rcu_read_unlock();
> -	if (!memcg) {
> +	if (!memcg || !mem_cgroup_tryget(memcg)) {

For this part, I was thinking '!memcg' part seems not technically needed
because mem_cgroup_tryget() does the check.  But I think that's just trivial,
so this also looks good to me.

> +		rcu_read_unlock();
>  		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
>  			return 0;
>  		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
>  			return 10000;
>  	}
> +	rcu_read_unlock();
> +
>  	mem_cgroup_flush_stats(memcg);
>  	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
>  	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
> @@ -2065,6 +2067,8 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
>  	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
>  
> +	mem_cgroup_put(memcg);
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
>  		numerator = used_pages;
> -- 
> 2.47.3


Thanks,
SJ

[...]

