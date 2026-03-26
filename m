Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35372109E532
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776316B0089; Wed, 25 Mar 2026 20:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727516B008C; Wed, 25 Mar 2026 20:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D3E6B0092; Wed, 25 Mar 2026 20:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56B6A6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:35:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD02B8CBA5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:35:26 +0000 (UTC)
X-FDA: 84586345452.27.2A31F6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D79B40003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:35:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLnwvxPg;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774485325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZDowMQkOhi6AObyx1RRxhZpFD+yjMtPDc29neBxVzA=;
	b=V83kFzy7r+W0sTnBTgtpP0UtUJUayWf7xopX3EtLzfSWLovrTHz4y+/md4uToI9r8znjfb
	2gUEJ/uEbytIoxQFOMRNucK+28Oxs5Ufq2VLbsCpPO1fcojn3/7C79uGB8aiCdLYyXJVg+
	57HZGXhh+o2F3xDenUhqKswLO0EJjFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLnwvxPg;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774485325; a=rsa-sha256;
	cv=none;
	b=gB8NZQVD5+YYzDGtRbAPek5g9DaLxhUORDwmL4UenQ5aDQJa9gpPpjGl+EuCnJ8CLd3il+
	nFXBbm23/PSo6gUxdJF+wSGO0FesZWpkmPyFJkcz7B+9dlK+FVRfUamH037H0cW9nC0z4k
	pL3IBeKgBFXBwzy3ZTFmPvkYHXK1FCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 307AE43993;
	Thu, 26 Mar 2026 00:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE76AC4CEF7;
	Thu, 26 Mar 2026 00:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774485324;
	bh=JgRgmv19Ob1z5FWl2YmQ9MrKOZCFSCB4WRvOcKg/+90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLnwvxPgM6IFQbMezL9MtZrDzM1hsTBXxvfaI+sjUez3ue0H+ua8UG77/uPyY1Uf+
	 iFRLS6lpqX2hRyDdvECbFSfCFbByNU3SAMqmzR493pyBhuR+RShpC0IGCSdiMW8LVE
	 xiYytcRiQBY//nE6dA9uJ1o9RowTcM8AA3/sUFWEFeSH/q3fzSQntxW7fBVEO+3Yec
	 g2pz0AiRXp5FHCkzoZ6nfOsFW+sYgwFAlxc9FQZ6j2r8r/iO/hTIrchcsWrN2jrfmW
	 qrs/UuCYcNs9xARygbuqWqVVGLbccGLhkZMQ/KpunO5UKhTqEPm6Fqg801C87yyQS5
	 HYeZ8qPSg6TvA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 17:35:14 -0700
Message-ID: <20260326003515.77311-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325155221.202700-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D79B40003
X-Stat-Signature: ii3t6sbhqqiy1xccze3jxznst8tcrw56
X-Rspamd-Server: rspam06
X-HE-Tag: 1774485324-869668
X-HE-Meta: U2FsdGVkX1/7Lr9dlblskJF90h1zU60d1+KEa7kS8NC8+RRhmFosX6S+eKjQ0zbn9/7dR4G4HBebfdCUNAPVw5lJEnPbFewxYLrsc2ABmTogStCKvjWOW86k5d2z0y70GCzwlfCULjzwEREWjJwy1lgCtrrHTGVdSyOoAmfubGLPj8iL99jqgDSveujFMg85j9PvP2qvhdFGQn043ksf/LZI41Dj99fhkU7CB/h0Ygft0yZvVCzqKiLFb+tMnjEWCu098nWmataO2cq+jyiwVswGtSgRFnVwU/0XHasynARft59N2RNL/kCzMO0zJ18GSuwvpKcin0fhaL3IqbSUX8ZDacfcPVgL016HJgQXz5qQftIijcEe7M7+z7jPlsbNtgeYsQ10eTaLZ6AjwtlR9WLSrnC44wTa5azDys5xIQJyrixLYq/UAWsMNaAjD2f3wap0wMc0pW2AAtOSV0IxCTlApkCJnjpA90orWHpnh0mUfoimenotbcMc6NPs2Hwq5vjXmouDarYgZywJb5Ahh3QFfoVV2PZS3tpR6KgB+TX8/BgRr+eNyLcWVtXmxqEm1ULseXQZTI91pKVQEXoEFy+jO/G1Q0cSKs/AjUmwvX+2sJtEYaNlM9cudZxhWz16fo0Yn+/perMEBvrJEHvgn6vRxF1qkqoBPdPt4PUiFBHJP1rEfVpRo3k/m/hTb+LGqf+LOFv6m3CtzvibCRupc9kX9lmCr3m9HMdYcuPpZjVpa9uw3ZQiQVa81pDz5OSDslkwqxgMR819cY3DQp6IF1z47gpwO1xmgWdSAw2fRAQiJK6eDI0mYpMf26msuTAvTFGRHPn6QH+icKAcV+6c6xUvzMrxSHVfpaYMCqwmTy0pnYs5K4tEo0c5HrhEOJpUKe45YqGedwC6Gj7BXg6mXyAoBVicy7MWBthdAX23fC1rVLzozWNCmOANvmXQ3PqWHjt7muJ0i9ULRiHylrK
 antdmNyf
 6i2l0LCsbYUP/5PyC4LGrug4hUClaBEAGwblYZihsjPn8vBHXdmwP8paw5yV57KVlvuGW7K/egaHRWqIP4MgLz5SLQHlRWVgtCspmb14xfIB1Ms7QGNLhgmwkA3gu5qlmtB4mF2n1YoZaen34EcEN4QY7V7WUR/tkQv2aYWAX+SPZTqGzGPs+vxxvti419vMLNx4UiawKrOgBbo/5z+XU2UOPpAg2Pm528m0JWgV8cuG/UIxujrwOljpXZjydJd4YAXYvFQvkVTC213d+Bevvpo/8TtxxHfSVj/dv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 15:52:21 +0000 Josh Law <objecting@objecting.org> wrote:

No rush, Josh.  As I mentioned before, please give about a day after the last
comment on the previous version of the patch, before posting a new version.
That could help giving enough time for others to add their important findings.

> damos_get_node_mem_bp() and damos_get_node_memcg_used_bp() pass
> goal->nid directly to si_meminfo_node() and NODE_DATA() without
> checking that it refers to a valid, online NUMA node.  Since

s/online/memory/ ?

> goal->nid is set from userspace via sysfs with no validation, a
> negative or out-of-range value causes an out-of-bounds access in
> NODE_DATA(), and a valid but offline node gives undefined results.
> 
> Add bounds and node_state(N_MEMORY) checks before using the nid,
> consistent with damon_migrate_pages().
> 
> Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---

As I also previously mentioned, please add changelog here.

>  mm/damon/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 59b709f04975..112125b635d7 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2227,6 +2227,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_state(goal->nid, N_MEMORY))
> +		return 0;
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
> @@ -2243,6 +2247,10 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_state(goal->nid, N_MEMORY))
> +		return 0;
> +
>  	memcg = mem_cgroup_get_from_id(goal->memcg_id);
>  	if (!memcg) {
>  		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> -- 
> 2.34.1

I will add more comments as a reply to sashiko comment.


Thanks,
SJ

[...]

