Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A962CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90518E0003; Mon,  8 Sep 2025 21:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40CB8E0002; Mon,  8 Sep 2025 21:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DCB8E0003; Mon,  8 Sep 2025 21:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A8E748E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:36:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5499213A741
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:36:53 +0000 (UTC)
X-FDA: 83867997906.03.5452E78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9316FA000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:36:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fTItJmwp;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757381811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RWMSJDI0AGIuEQlQMddbkjap4URwIV5DOLNEO0/AsY=;
	b=iZey3fXyhC8ajRKdsFR/caOFII0xpnSuF3NjeOtoWJ3qyenUaD3P2b+yr4NGuR/yF20vyT
	oxqfv2NbedIYyQQE+M65BzrctKPNusphrAsrBdJWz4pb+tdXomnroqgEV5SxEZC78unvjq
	UIyFPoMMo8qiXCXADjRlbEJmNPNe9bE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fTItJmwp;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757381811; a=rsa-sha256;
	cv=none;
	b=VeA0LjV3wC45ngV7yEVNgk2b1QeWlrEn+l8MTaEGYG1shraAm1GDNr/LSyx8pLSRgqZDr9
	t36IhCAALPS4FAlJ6RygBcEsUbkP2XlfhKWSkSPMIUf9RJ7FEAd01kR8kiaLczJ/cYf1Hf
	VJHxJkx+h3oovBZynMWmI0S8Xph+kgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3612A409BE;
	Tue,  9 Sep 2025 01:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE12C4CEF1;
	Tue,  9 Sep 2025 01:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757381810;
	bh=Z1rOYyBYisrEgpjxg5axvCiSam4Xo1at+Aqmwaue7MU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fTItJmwphkdiwuwpmzrhAuNOpxlnTraGAELtElgAj72BfU7Ufj/C03C3qzZrcU7rO
	 zO9UrfXTgGE9oucR2CVHiLGDU9bnuU9wrUFhC0oXDyaaiHcTl4fKQKP2pXQcgvMvee
	 pwuj8ycqWx855HfKpZKql8pT5Zdn38r0Rpz6alnc=
Date: Mon, 8 Sep 2025 18:36:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cuishiwei <cuishw@inspur.com>
Cc: <axelrasmussen@google.com>, <yuanchu@google.com>, <hannes@cmpxchg.org>,
 <weixugc@google.com>, <david@redhat.com>, <zhengqi.arch@bytedance.com>,
 <shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] disable demotion during memory reclamation
Message-Id: <20250908183649.da6b77d15c1076e5b69064af@linux-foundation.org>
In-Reply-To: <20250909012141.1467-1-cuishw@inspur.com>
References: <20250909012141.1467-1-cuishw@inspur.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9316FA000E
X-Rspamd-Server: rspam05
X-Stat-Signature: tnhx9qbtj7yiwfyrh5q3jzatd6hosose
X-Rspam-User: 
X-HE-Tag: 1757381811-814289
X-HE-Meta: U2FsdGVkX19+XONghO4TFGKrA34UVcgzyJh0eviJFyo4qgLfmw0uH11b9zxUwgPwjY9apcfQLL6gwjxcBDPaPJZnpcJzJg4v1KNIz+3xmZIm9jtlbXsYpmSwftc5fkHH66LBesbaddvbR7IE3F7hsFJ8O37r3NSPmsu9u/sSMBkxFSZWdMEG4MVYzveN0uWOFCUoTEzZ1MXAXtxXP31OppJFXKvt1jSJvD87Gd+gQ5dXJ8X+kyYKab8a/qlPBtoF5iOaXiAtNuQsFxD88/fHWwaGgZivihMvoLovN5VqBMRbdfE13npUJFfqI3a6UD7HqEwS+A45e91kaCyeNLA5qCPJOLkBXancOZyH7jReVVsMG6tjmKzk3dtlTcdtX1Dxg0KEpiax9jx4r3zj/POiVAycezOMWG7NzTdLWUrnbRPpWRNdTg0p4kXntbldxhoERBokzMdPOhQXX3OTKRVHESQ94dEoFq7KmWQ7rNi3RFIIA72vbObbcGyYWlvWI7Ga4+gb7yZ/8cNbUEzK1DdyD9eEeSZAIiW3y10mXhKO7pimoHUteccWh4Yan1Ba8nO0afGMi9LWZPe4SuBBgtO78NWJhGRAY2LfKUAaCq0SKkhHfhF/i6Ap0pAh2Ssw45df+rhPy1Hdq2chZ3Q3or4vQFWSy3B26uW15dwHnn7ZJfP2H7f/9HCMF2yfuib9eMr2D5dxRBnquuqdSOR1ivmmEg1WFTD2g9GFhphfnIY+gTZmOeNK35ezc37LsP+a4boTzlwDskY2M2N8kCOb/nYi1ijGpRI1yRNCsYuhIwrkaX8iJl2yk0iEsone9wGUqKO+kB9FdQFbrCgAu8s6DmeiKvSHGcyHZeTTXLGLzOMcGLJqJiDgz9gmfiDzV1aczwYa99kfUjIAnIzZI1cBYPJcx5eQ2tpuCDwZxjjqYxdYKo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 09:21:41 +0800 cuishiwei <cuishw@inspur.com> wrote:

> When a memory cgroup exceeds its memory limit, the system reclaims
> its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
> set to 1, memory on fast memory nodes will also be demoted to slow 
> memory nodes.
> 
> This demotion contradicts the goal of reclaiming cold memory within
> the memcg.At this point, demoting cold memory from fast to slow nodes
> is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
> we should set no_demotion when reclaiming memory in a memcg.

Is this from code inspection?  Or is there some workload which benefits
from this change?  If the latter, please tell us all about it.

>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6706,6 +6706,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  		.may_unmap = 1,
>  		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
>  		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
> +		.no_demotion = 1,
>  	};
>  	/*
>  	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
> -- 
> 2.43.0

