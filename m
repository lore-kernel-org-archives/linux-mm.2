Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FADEC4453D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 04:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78776B007B; Fri, 24 Jul 2026 00:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01986B0088; Fri, 24 Jul 2026 00:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9DE6B008A; Fri, 24 Jul 2026 00:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9BF6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:18:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4978140219
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:18:48 +0000 (UTC)
X-FDA: 85022364336.14.36C0112
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F903C0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:18:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dk9VntJM;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784866727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEgGWeL+yTrVdbZEiIfi87cvm6YPXdswgArk5B9kdpk=;
	b=PZm8G9NT00L5DTwh3W1b2nRegfcTibeIfnuqHgzxsX2uho5Y6khCd9rwiEpJPw4hY6GAni
	/UI06YQQmE3JWHOB9owsSIYeEeQidYBTndfpPMO/MFP0iKktPMDFCpI/LWLetIIpXk3hXO
	SJ7mpHmDvc3f9THT519VDZTzF8/e/hc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784866727;
	b=moZjktzHoBh8AXqRXYA0ymAy9HGntby8el4EfXpwBucrFyRLmXxu0DvgjfQFMoV0oAYGSO
	nHsKlyCrLTxSzQHmt0TvP949dCF/cYfrPEbFLbLs1q+y7nBIq3rGZodJDgJauiy8Rcyrp+
	B7gNMDL44qIQnJwMqOv7C/ejA3RbxaQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dk9VntJM;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 21:18:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784866724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEgGWeL+yTrVdbZEiIfi87cvm6YPXdswgArk5B9kdpk=;
	b=dk9VntJMllXGY/FMdSbMLmOHXGaJ5tdm5EZ6K5s2gXFTlUptT+TtQM8NCnJuG4DjvlTSB3
	wfRJY+VFZySmpCnZ0LEe8WF26TsE3TCd2b3Op79O2Bm0Qu5RkpdD1ju4uvl7/nCrklqV6F
	myak+3FNHqp8vyohdJnxiCmZ+rUxG4k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
Message-ID: <amLniSIh-6Bc9mld@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723032434.2016749-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723032434.2016749-2-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F903C0003
X-Stat-Signature: ho88ir17f6n449g5pzw4xjxu7wd6ei7q
X-Rspam-User: 
X-HE-Tag: 1784866726-407087
X-HE-Meta: U2FsdGVkX1/5ywL+sE78OOHip5z4yfhr5mkUCy+7C/79C1SlFuPE4a4lFz3VeNwfFlEGgOeRUo8X6UH3s4fZKZvuvQvTlARF1w3tnXWqI0Xve+VdJ9jxZFmOc3DVpdz1iQHYgnuMFHx0cwcEpHajWRXpYwAzo6w0lj0Yq6pZ9GBYzYgjdiaa8Y7EbNqX1jlku8CVOhlWRGQKF0AbF4A1So5trZDB/HY9Wt2dPq985NdPRvs8/jzqXn3ZMqbt7wCb19wehTzlmFo1Xe7+MQDxa/gvPgmSvNQ5OS0oquLZaK91K+fmlpPPsEprky757B3EtI11CBJuay1WW/yz4qLJn+8r8vvabAwNgvhctIEVe34N3eMxemmR7Jwnwsp4JpDmmTYnbnd0795R9WEWWSFYCNNGmcSBsSOggoDrytVFiDQmn6a/9ZA/GDAQORLsLzkJMrqKo9YUU+s80ehksP0DnzxzJiYe5LDSvGGt+trCRNyIC/HwYPI1p9hGjh3c/rqrkSJre+pCcf/vP/lFHw+nLP4rPZF9TwGGuvde47Ykf+wnP0VwQAPPg5fk7ApIhKyl45IuH+3UP4bGTRUDg8ES19WJqdM1FDxfSLY0ZHY1mQM+1UAcSuW1/ZjRcxRLdhrkpjD1lT/1lIyNbbvAquPRXSSuL8fOoMweGhUTi/R6kUoso6rI30n5E3iZSB8yvq8HIGPyAas9QHE1+rOXWI9fy5l6oYdc2xqumW9smaRxEw8ZitJV/tWhWOOwnGGBYY/xmhQAeN+9q0xS1etYt/weCOxmRElm0kwqHGjJNv6DdyWBOSx2BsDvKBLrDPjtsqhpfh29V31KPR/hS3OvNg2aOqUKoXUrSsQna8iFGsjxFZ3Qm1S6mrSGOp9vyVpWTlnmHvGKpfxSwv+RMrQBxwZGD13VDs+lRKIbqLbz86L6U2JGidpM96TKGnIvHKMlmMQvxTS4GJC48dyArIt6pVA
 DXXQ8L+y
 1jaIlKCFWbeMM4QbPXNJxpGv84b7dN92SfJAOAve/ol7gPlqgJTBaOGbRtkZMHiTkC9q2/h7LInFGTUBldj8MFykoIfXrxVRBNzMlUwUpyMj/BvKa30gsxSlZkbUcLmBGF5WNZTpFmrzoW3FL1aY0wlWS9kVDuHCW1MMWX4fNFjujeSUjlSkoDOL12DUvL8AWqGMDTZNySyhYXhLJRwE/KYDNz2z9kHmMRg07n8Fzd9QpCxD1SerPZF+fKfMndxxOdlGDpgA+IoZVXOqEXGEMd+fIZXc1PdKJGi5GQhhD9o3/uYhIUAZtwcdyH+GAYsvP5HuAXytv8qF86/h9NdN01rosLj6Dsp1vXaa6J799X6HJrhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:24:33AM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
> 
> Both mem_cgroup_swappiness() and vm_swappiness are only used within
> mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
> public include/linux/swap.h into the mm-private mm/swap.h. This keeps
> unrelated declarations out of include/linux/swap.h.
> 
> Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
> kernels drop the unused field.
> 
> No functional change for v1; v2-only kernels drop the unused field.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Song Hu <husong@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

