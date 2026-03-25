Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DFF8109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3B46B008A; Wed, 25 Mar 2026 11:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BA46B0092; Wed, 25 Mar 2026 11:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C83C6B0098; Wed, 25 Mar 2026 11:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6802F6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:04:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 194F8BBE01
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:04:21 +0000 (UTC)
X-FDA: 84584906322.18.1320C68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BFE6120011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:04:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCOnoye0;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCOnoye0;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451059; a=rsa-sha256;
	cv=none;
	b=GuRzP72hstSiFzKjN8xImgsxU7a3HEogooKooGmvb7BUV7UKi6D2bVyzH73p04qhYBotjw
	XGB94tX3wPr9b+clVrV6oCpuzpbacJZ0kOswkm8oqbh3bZ3KHAjlwa0dhKXZ/tZ700L7Vp
	lqHBU2kHDEPiqpWanySDkkE8m6hBQgo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKea0lohIccY0HdpGx7M03dWoFYAzebgiogvP+wV+ao=;
	b=npDlcQ3TnwsuCSKDJieYvPDSe4PMgSahJO5l/LV3YCNda7R9QR88mJkkwyZB22DApUUMH3
	Xe8Vg1F2pG6AOznO4w1C+BuZH0lzkroSJ5XgEIAD4x0M9/eJSO+ljsk/TvL7Yk9oGIr8cl
	iOhCwbd4N/0PRkEn5S8aWzM5FhpaMw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D20B5600AC;
	Wed, 25 Mar 2026 15:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD1DC4CEF7;
	Wed, 25 Mar 2026 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774451058;
	bh=UD3pMRTQnc7mmQ6/kqhD1kZgF1YPF0ihrkNbU0vkgqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCOnoye0iRgKQ2/Hkv1xCXmCs2iJwfAE1Iz4Pqv08JDL6zWTRDdATiNeJxSkbuLkm
	 W6VhgwYWT7ONxhf84Ljf0iLwP7DW1oQlpPb/jApYhZnkWrc5Fzbi/HNFm+nG6l94QS
	 whi9KTK2GaDC+9dWJbW8oAkDX0oKwUylyZ+4kAkhxhMbToBfPqBKqY2pfjzLTT9+lX
	 qLJnwF9xzMLjTvtYQQa6/bly0eDxYL4BN/oayNeNYxAUfjBwI/t3mnbEJ447sJAmig
	 2oTUoFUJtYXtcEEipxpCK8my4F2x5LBZpqF+aWz57JsAPhc2tP6+K77IJL+ceD2das
	 GqeDo9nQG9e5g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 08:04:10 -0700
Message-ID: <20260325150411.88357-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325143740.87690-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BFE6120011
X-Stat-Signature: 4y6zbwztxne3fpyjaoqgeh64mp44f3an
X-Rspam-User: 
X-HE-Tag: 1774451059-186457
X-HE-Meta: U2FsdGVkX1+IFLInTWWDZSKxyahRS4qAdXCa0xF5ZbgeBVnI2UQ3le3m0XJCMQ0kux3IhW0GD4uQkbh7acJgfEx8CA0IjujOvDS5DmWC3Z6WFbz2yUqPPosPjqhFAulfrM3YzEtnddo5NSWSFk7ER/H++WI427EddvSHx0Fv6pZproAWc5e37l992FUOiIC8hJBf9FTbCYxwn1vDiyi0yPAITrhA3fr+zy/IPN5xe1QMWDU4Bs4oJ0mgOxinB58E7rAmNar41KRcSfqsc4aIVixVy6mMYD/daC+uL9m/v2OkG64j85A2aULCntURVFw32tfXWYWo9MF8wADB0w3nsAfDJMo5OHzV423tCxnoFsQ1Zl3RPU4U+6kIe99O0Nf/bPxZQU+yUuAwc7B8+kKrf/ol4BsY6rxrrehE6uw05uIj6Qh81KE1iyEzz8o1Gv1pjbtHi5ESnz8Jb5Nogasq6/rdzz0OoLVv75YWJPmL/1lDzkAVGIW3n1DSXx8HX25RUMTJSZvHolCUKk+ZKN2Hel9JY3XMb0B+Tne4pPFI8k8WlzL1LGiQHC93M69YKJr1NcgvOi0cwFUztzmHsGS0efucaOwS11wGDHRtmKNNKBWyDoxRCdi3jCANiZMa3PF+GZ+1GKoB0z36uCejZfyL3r8xoPb0N9MWH6p4Y61l546We1TWAJFx9oBgVNUCDffuKB99kwnj+ivoK1GJVn5PEPBFn+MF9LtyTbp9RfKmb90zwdJCQGPj3y5UWRZjJuZ/3uD+3rEaeIYqUJr7hi8bB9pjPGhbmJNs9bTFzx6Yyd7lV3bbyCv0nPlp5RJ2oEvsn503Td4+Gx5u984Mrgd0WbjyFd3sIhDkdBz2YaVVrVUH3fEbJTxJTTGhBwwwUEToRgu5sShWuluz4fSZOJLV3PGTcFo+SHs5ac47rOiEldK7+meCj2HghJeNyX8I9KVJR5By+efYwR2nZIakm4o
 dxWtnmkh
 DsU5tVwUeRIFyjPIh13lHSWwvKo11ej1NG7KuEzhYLDLZx5F18sRvcVDSye4LrnvCSg6Slp1NRkoNPseIlyUjiS0VI1t/9/uf+PRQ8M09W/bL0Oh2AnI6UqSLWfhZebX95oI/IoLI2tgdfBwzH+4BhW40ciUlSHGdNoSYatnxaiGQNKy94fXBBpcfuC+2tepNSS4xiRnS6/5xvuZmNDD+p/FIHO7Ma4osSX6wAo/ffMzpOTwaCiq0sUZXPU9xxjpap87tNnvCSGO01xUG6swvJXAvE8ma/zmy4MJT3Gwc4vLcILk/AAi8FDrDHXBH4g58EXt/VUNo3ZAwSwxjKTxPErY6RwmHh/XJiqpP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 07:37:39 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260325073034.140353-1-objecting@objecting.org
> # start of sashiko.dev inline review
> commit 7e17cbe1dc95a0cd1a1410be38ab6964f78fb15c
> Author: Josh Law <objecting@objecting.org>
> 
> mm/damon/core: validate goal nid before accessing node data
> 
> This commit adds bounds checking and node_online() validation for the
> goal->nid in the DAMON quota metrics. It prevents out-of-bounds accesses
> to NODE_DATA() when an invalid or offline NUMA node is provided by userspace.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..81ce27baa1a1 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2245,6 +2245,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
> >  	struct sysinfo i;
> >  	__kernel_ulong_t numerator;
> >  
> > +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> > +	    !node_online(goal->nid))
> > +		return 0;
> > +
> >  	si_meminfo_node(&i, goal->nid);
> >  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> >  		numerator = i.totalram - i.freeram;
> >  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> >  		numerator = i.freeram;
> >  	return mult_frac(numerator, 10000, i.totalram);
> 
> Could this cause a division by zero if the node is online but memoryless?
> 
> For CPU-only compute nodes or nodes where all memory has been hot-removed,
> node_online(goal->nid) will evaluate to true. When si_meminfo_node() is
> called for these memoryless nodes, it populates the sysinfo struct with
> i.totalram = 0.
> 
> The mult_frac() macro unconditionally performs integer division and modulo
> by the third argument, which could trigger a kernel panic when dividing by
> zero.
> 
> Would it be safer to check if i.totalram is zero before returning, or use
> node_state(goal->nid, N_MEMORY) instead of node_online()?
> 
> [ ... ]
> 
> > @@ -2261,6 +2265,10 @@ static unsigned long damos_get_node_memcg_used_bp(
> >  	unsigned long used_pages, numerator;
> >  	struct sysinfo i;
> >  
> > +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> > +	    !node_online(goal->nid))
> > +		return 0;
> > +
> >  	memcg = mem_cgroup_get_from_id(goal->memcg_id);
> 
> The same division by zero risk exists here when mult_frac() is called at the
> end of this function.

I think sashiko's comments make sense.  I also suggested using
node_state(N_MEMORY).  What do you think, Josh?


Thanks,
SJ

[...]

