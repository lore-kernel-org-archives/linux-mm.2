Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A958F3D605
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7B46B0092; Sun, 29 Mar 2026 11:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F586B0095; Sun, 29 Mar 2026 11:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5B36B0096; Sun, 29 Mar 2026 11:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4066B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:48:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF85513AD6F
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:48:17 +0000 (UTC)
X-FDA: 84599532234.10.1739852
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1675C40008
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:48:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MC2hb9ZN;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Adu9Bnl9wia0GckqzTvSgYzKkF4KCbfP7VvRCjB34Ak=;
	b=3+0CrBupCz0GkmJmNYQTUWrA2pdxqcyswy8w5fr0yoXeWz2Z2kpi2uh9GfocKf+T0TWbsU
	ZL1c3yAyxdkvpmni+KCSr+8kmyFaKllm3nc2322gZbWJa99ZOY07g1NRQeya2wg134rPrJ
	stMbeA5SdMv4AkleDzrqQFKiCmn+wfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799296; a=rsa-sha256;
	cv=none;
	b=DP9udm9hYZFzEYEboqFD5ovq7CC6D2SfHnHelqfbBD7hIMRbOThTuc3gM/8ssaOex3QYVl
	45Fnz5JpAecIrSMpAPi9mmMsgjDHa3qVrxhb2Yh9pKQirnO7MUmi4VFBdvk3EH19KPGvW1
	rdpsioKhx0Zm6KO6WNyWJqr+NCISsgg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MC2hb9ZN;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8328660054;
	Sun, 29 Mar 2026 15:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1914AC116C6;
	Sun, 29 Mar 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799295;
	bh=55VTZBw7H4SGXn+vmc4Bbc36KWSHYKT83EK8dDSS/qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MC2hb9ZNhG0CXroRC0oawyiUw/ltfcRn1Bq9ZZFlErZLMIE9WDaJ3BrEAo0EdNsS3
	 8OjI5gEQy+v8UadyoS+gdANYvFuMWIkP+IBcEakK0ieDNXD+/wXkgUxA/IPg0ZiNJC
	 etx5oIGzqtEj3Cwp1hFEeOloG9sgYr97CuIc/i/FXJ3KHbmLQpNXvmmSrpMphy8up6
	 SUfAA8pSXub0AczqA/bj2cwABS8uv80/QhSIHFm2nxnvyNYJW0qQ4XWuvnJGaR2iBC
	 rAnv5nXh/096KLNfOIGUUey0CTEo6PMRxU6EbIpyCmlrzCo3IWR+8zN0MgfOmW0UIC
	 QvDLpxZ3MAX2A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Sun, 29 Mar 2026 08:48:13 -0700
Message-ID: <20260329154813.47382-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153425.47097-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: r98uiy5jummnfis1menxncgo3hb8ggaf
X-Rspamd-Queue-Id: 1675C40008
X-Rspam-User: 
X-HE-Tag: 1774799295-513963
X-HE-Meta: U2FsdGVkX1+8JkdK31hCrXDlzJo1DUs17siLl7q455moYP/aeQBTko2rkoqckzcjE+ire0Y22pLNzO0NE/aizy29mru0ah62HQl2jsjagrwSG3Y9As3MgOPqrl+upsV45easuQdb8ZRwcU82AkHTQrQKtLhrneTeZqW4GZOE4/q4gLpAoUfvi+3WTDTGTECKQQOEPyjicqTjnmCXBFTlu33m70KZuOhuWnJ2Wh+yfTORy4Jc1a3X6SOM0u4Uec9Bl5AuES8oCXIZ0s0+L6o17TjOHq7RwdnmR01YU2Yy3f72+9gJfPQ5p4mgpDZOmV6ZsKBStx30XXiEcZTkOd3Y/tvSdUoq/D0K4LEzX6gp9s6S556BtZxe9IReXRh/3pfR0ab5DTkyAxBiVNx4WSiiogyT+4dj1vcM7v0FRUg4+BMhF/dvP2gvxzwLmXKgFfnFGOxMQ0LhKwUDXLLteM2DTR/mFSOixT1uMJ8aJBHC7yCzU449uDUWQVlEdT5k5k5vQaAqGwceZNwOSnk+K0Z84pWypr2ugT3Q/jSg7dsaPr8sFNxb0ftjd4pVQuakBWaOkWvAYIP29eZmW9tlgHzF29fFbTOUEUMLUMQKigs65v2n8YAmNyO+LQTA6uEusjTE39J/TSnKbAvORJPMILaFqnwY59vYStYxq3Dwv6M+5tQ4jOAOfLoDh57YFZ6YQ7Jk6X6flmNcn6Vc1oYhtob33pAOMRJkNyasTFl+ITDf+77ATENbbo28e1d05UVukU8yneH2Ma5Wrc0APLGSXYmVjBW2xa06jjjglnwjXZ92BUlm4jL4VMUyMnhkxL0E2g5NZRNHaPl2FeNCi/sqDgNrQjxJpUfnpL8v5/TQbpQ/JHlZgsfVs95LKKLpDN2LjCK4e3Oj0quc8+/M7RMRVZLh9PsKBm+NQjJxqNVpaclDj4IoBhEiHDF79WWFtby1W1gev6LnBoohyJe+yXGThz9
 L4SHsnEW
 VD7tH4GEyICdmRl9oXmp+trklm/6AaTtt7dksaxkAy2jaCm2cNpsAinoo+Lawv9lddAt5ZibsgE+OLhmbswCZj8heImQMFflFAJB4+RlSPciXIsQO+9dbrQXE4QFHM8lKhSBhLLWjzD/JH5U3mbwd6sE4oCRXk/ZSxzl0C8NasuNHpgygpIJDSLAhB52vW63WcqrwaQITNHRgkgpr/twyB2TB0bOcg1JCTUK+9qWuLaJR+dW1E7s7QXQsH4On872Mo66qy6bC4LyVctCGVpMy3M9OHW9DOXBKSw3sgB/tVk3IarpG/jYPSe6rJ5HK4yx6lZapDuS7CBvCoJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko findings are good points but not directly related to this
patch.  I will separately work on sashiko's findings.

On Sun, 29 Mar 2026 08:34:24 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260329043902.46163-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit 1ede2d837f5cbf8e8d96fe4c6eab34aeaa071d56
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
> 
> This commit adds validation for the node id in damos_get_node_memcg_used_bp()
> to prevent out-of-bounds memory access. If an invalid node id is provided, it
> now safely returns 0% for used memory and 100% for free memory.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 26bdeb658799..c45c62f8449d 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2273,6 +2273,13 @@ static unsigned long damos_get_node_memcg_used_bp(
> >  	unsigned long used_pages, numerator;
> >  	struct sysinfo i;
> >  
> > +	if (invalid_mem_node(goal->nid)) {
> > +		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> > +			return 0;
> > +		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
> > +			return 10000;
> > +	}
> > +
> >  	memcg = mem_cgroup_get_from_id(goal->memcg_id);
> >  	if (!memcg) {
> >  		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> 
> This isn't a bug introduced by this patch, but can the subtraction later in
> this function underflow?
> 
> damos_get_node_memcg_used_bp() {
>     ...
>     else    /* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
>         numerator = i.totalram - used_pages;
>     ...
> }
> 
> Since used_pages is fetched locklessly and i.totalram is the global managed
> pages count, could asynchronous rstat accounting lag or concurrent memory
> hot-remove operations cause used_pages to transiently exceed i.totalram?

As sashiko also mentions, this is not related to this patch.  I will separately
work on this.

> 
> Also regarding the end of this function, is it possible for i.totalram to
> evaluate to 0 here?
> 
> damos_get_node_memcg_used_bp() {
>     ...
>     return mult_frac(numerator, 10000, i.totalram);
> }
> 
> If a node's memory is entirely reserved or concurrently offlined,
> si_meminfo_node() might set i.totalram to 0. If that happens, does
> mult_frac() execute an unchecked division by zero internally?

Again, not related to this patch.  I will separately work on this.

> 
> Finally, does the mult_frac() macro overflow unsigned long on 32-bit
> architectures?
> 
> The macro evaluates to q * n_ + r * n_ / d_, where r is
> numerator % i.totalram. On 32-bit systems, r is a 32-bit unsigned long.
> 
> For nodes with more than ~1.7GB of RAM (where i.totalram exceeds ~429,496
> pages), could r * 10000 silently overflow the 32-bit boundary and return a
> severely truncated value?

Good catch, but again, not related to this patch.  I will separtely work on
this.


Thanks,
SJ

[...]

