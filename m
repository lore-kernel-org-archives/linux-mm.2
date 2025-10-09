Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A73CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 00:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4608E000E; Wed,  8 Oct 2025 20:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C5E8E0002; Wed,  8 Oct 2025 20:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9078E000E; Wed,  8 Oct 2025 20:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B12A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:37:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A49F2C087F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:37:36 +0000 (UTC)
X-FDA: 83976712512.23.FF8B68F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D83C1C0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:37:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lU8Vc//i";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759970255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAVEk9ZlINYUZSI/Z+UbjV2R3S7MJO8aGsqUxU36kSM=;
	b=6Qo37KC9ilCP/vClbIwMCGAFcoXKkhRwMON9FWIesp6wlmNRVbPmgz+PLOqEdnuk9T3vvy
	JsbL7lF1RZ9Wndmun8BzGyS3YKW39jJBUIHpiS5JGbMGQcYCPWrp31NXfxjxDaC0faXxcv
	smHgKkckAfBSzSBO2MmXo7+ZVX20Cj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759970255; a=rsa-sha256;
	cv=none;
	b=k2ttqsyltRHEGD/emqzNTMMkHeTluPjp3bTWLRQuourTYITiMsRNESyfAzFu2bvPeF8zWA
	vCit3HR6zD8Je20AFIxy3aLCI6LTQkLE3PW0/EiuqgiFdYTF9T06bSbN4GNuJlyS3ay104
	1Js9A9bIpIS6SjpViKNSpmfqEdxDOYc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lU8Vc//i";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22D6860285;
	Thu,  9 Oct 2025 00:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9590C4CEE7;
	Thu,  9 Oct 2025 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759970253;
	bh=nFcAr73rD+SuRsT7M4DFUoPCwzGKkb7ROVMuAUGKA6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lU8Vc//iypA7RNySYz3PTvHx5w9B82WDq/loSga5PhvX66TLaTlDAvmlWqnlHhqE9
	 pD/curjEAsHaBxGAwKNQXoUlLvXEoTPP5iUBvrcO/pxTz1Kq10Jo19FiT/XNcPeCld
	 YKH77j5UkWkKz0oyrnq7LzPskzT8+l+D4w7E+ElzYIZy/C/+0/MM84sw0h7yljKItu
	 b5dkLLjko6d7/aLTXbTRDRdUDr90YVN5hCjL8O4gJCCAyqRiFH82f2+NuXjOx8Fmfu
	 Cl2GgcXGqkEIwEF+MXGMtW5K7NQGpiFfWLCfts6PjXrB6uRMN0CCJiAtJkOgvJ5/nR
	 +6qrO3pQgpCvA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 02/11] mm/damon: add a new DAMOS quota goal metric for cgroup on node memory usage
Date: Wed,  8 Oct 2025 17:37:29 -0700
Message-Id: <20251009003729.14889-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250619220023.24023-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: gcedjbmsb9ny6dn4ht4qwjda89n3w9q8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D83C1C0002
X-HE-Tag: 1759970254-388454
X-HE-Meta: U2FsdGVkX18n2vVJl4g3z8fl4RC/8hpsrKQ+dYQjw61uO7zCP+yImJBeaySiYUQj79hS7bbMy2hDKVtrY0WlWOAoHeEFnG2ho+xPRH7lkOxw3pVI9Z+qYTN53fdWP9nJfMDH5UaqhUFrMyaFIV3q7Yv0PFOPP56hjr1Ppl/oXGPtejYoGFNQFsNNztv5KCxYWz89i5VCaeLOVXGPcqessFKq+pNFk/YjYvARwhaQmdmYy0nZb9HYeHgmRK3wqVd9rp9+6/PcS96T5A9FCUEym/ekb3bZ+cV7gZoRKamjyb7AhCbCGUMV0IKUaXDCXnrtCfmfl6ChUv/y5lD8VdcOO0UiG7N41P8jSCj7ISmjL2EUgvHlhT/fJeir+zGI12ZywG+FNDveAIP1IjK4/OPf4NeDquY54LXImo2wlJoULOGJENWQ0W1KOhLFB+6Wxk+Rm1M08aQlFbluFwksX2GyFlztt8J/xjuTymjWfqRePpYMlqvqGnV/kbozs/WyjH/7tk3Iipm0VpfN7lRWE2jcVJ7g0miChb3MrwmhMFvNa0zgTbQwS3uRNDa4idfF5jtAXa14gnSfhVP2NO8yegf41ab0rEXK+nXwqnf/AhRJyjFWiLP1e1F/wwdmrZvfNmnWpoM+c41wFxSUESCfeBp5q2q9VVBUEOFQXPUCjCYWWPeD2pvcmWh7szHlxqpZhbnxSLMSAl5mzsTJfuOWmE80NnG6jb67sb1RFPlwwTibJCc7OHYpRGiTdZWUNs3DEe+p14fXR3sUaPbufjF8Uy6C6ht73AAjPoucHWzR+kxYZy2h6+TEPzy6p2ZZtmrjzXQkWcrXq4yOxL0jD2rNOGGnZ2dIcWDxTEhUeaGWNHYauYJxrHz61tflN5wjycXKntLmX11ELL0eaNmzbRvxjFrQkMy0vFzAtiHQaG0t4EIuUtDzkkOYiED1BrsbFKoZ5CyI2f0Y8NRTpmGPv4t1jU5
 OGiT8XVv
 jInS+63JmId/55Y2Mmfqu1bgAhKWh2i85CcyW3rNiUKWAjFJXC4DB5/ePUVNY4ww5pPS5ZUzSEFxg9D91TLhUrjeS4vRwzL4LKBd3TZQOMGadhJTp2fq3F1oQzmlm9NLU/89LMVPSeL6Rv8DgFDdHU3XhAwT+ipOYENv/82F5ygkHLy7r2WKI7iRZyYjkOvj4J7jAC+Z5bEn5SQAkambX6FN5DFLOXVVUkN2rISborPNHH50xw86zgrks3skJziiWQugUGUtWH3ubSCo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Jun 2025 15:00:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> Define a new DAMOS quota auto-tuning target metrics for per-cgroup
> per-node memory usage.  Also extend damos_quota_goal struct to have a
> field for specifying the cgroup of the interest.
> 
> Note that this commit is only for DAMON kernel API extension.  Real
> behavior of the new metric will be implemented by a following commit.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 39b835dd3c4d..43aef959d357 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -175,6 +175,7 @@ enum damos_action {
>   * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
>   * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
>   * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
> + * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
>   * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to inactive memory ratio.
>   * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
>   *
> @@ -185,6 +186,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_SOME_MEM_PSI_US,
>  	DAMOS_QUOTA_NODE_MEM_USED_BP,
>  	DAMOS_QUOTA_NODE_MEM_FREE_BP,
> +	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
> @@ -196,6 +198,7 @@ enum damos_quota_goal_metric {
>   * @current_value:	Current value of @metric.
>   * @last_psi_total:	Last measured total PSI
>   * @nid:		Node id.
> + * @memcg:		Memcg id.

The name of the field is not memcg but memcg_id.  I will fix this in the next
version.

>   * @list:		List head for siblings.
>   *
>   * Data structure for getting the current score of the quota tuning goal.  The
> @@ -209,6 +212,9 @@ enum damos_quota_goal_metric {
>   *
>   * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
>   * id of the target node to account the used/free memory.
> + *
> + * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
> + * the node id and the cgroup to account the used memory for.
>   */
>  struct damos_quota_goal {
>  	enum damos_quota_goal_metric metric;
> @@ -217,7 +223,10 @@ struct damos_quota_goal {
>  	/* metric-dependent fields */
>  	union {
>  		u64 last_psi_total;
> -		int nid;
> +		struct {
> +			int nid;
> +			unsigned short memcg_id;
> +		};
>  	};
>  	struct list_head list;
>  };
> -- 
> 2.39.5
> 


Thanks,
SJ

