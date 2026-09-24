Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289D1C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040A06B0088; Thu, 24 Sep 2026 08:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35006B008A; Thu, 24 Sep 2026 08:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49CC6B008C; Thu, 24 Sep 2026 08:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78406B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:52:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D6171C26FA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:52:51 +0000 (UTC)
X-FDA: 85248645342.30.CF23285
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf24.hostedemail.com (Postfix) with ESMTP id 517E2180004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:52:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790254369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CSnAjhoDwvWnEW74al7mKjH1DVylJwe0Kh4/FdK8xpE=;
	b=iL8N6afaWRtQoj7MoY/Z1Bpakzwe/AP9oihPZuw5U7QHZSeLl9bA/YWB4K5ds1+fQLXJL1
	7uChl3VDAGSLHIi63dNMw4bUFGlwGm8CZeH6xpLkBIUFt+iiLSPVUx3chVIzDPBDqh6Ueh
	jZYSkBA2HYOpvmWv2Vttj8GPyjvrSB0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790254369;
	b=3kzh6ploD6AlvkttSCrwYYaQziBGgcDZHDjJ07itfdBXf5gZya1UVasCEATlcPBzIm88PQ
	OLAct6f/VfG5LXXZWEZvdQSUz4jfDlpo6MvqoxZJV467IqWqHo92F9E0pVTLOsmqpYaH/P
	K3anUsrmClx90y076sSoJobMRVPXqC4=
Received: from 8bytes.org (p200300f6af404a00e4ccc4fdbbd66590.dip0.t-ipconnect.de [IPv6:2003:f6:af40:4a00:e4cc:c4fd:bbd6:6590])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id C66711C7465;
	Thu, 24 Sep 2026 14:52:46 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:52:45 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, will@kernel.org, 
	robin.murphy@arm.com, iommu@lists.linux.dev, liam@infradead.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, ashok.raj@oss.qualcomm.com, jgg@ziepe.ca, 
	kyle@mcmartin.ca
Subject: Re: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
Message-ID: <arUZwesREX05SZ0J@8bytes.org>
References: <20260818152505.1057922-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818152505.1057922-1-riel@surriel.com>
X-Stat-Signature: hobmpd71yrgjqhbaeq1ttiy9a5xu7co8
X-Rspamd-Queue-Id: 517E2180004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790254369-512207
X-HE-Meta: U2FsdGVkX18RRWd6w+8NI8QcxnOEj5cLS+/Jr9NHWhdVkfzW0whhRVGEboZLcJ1xMmTgc6qufJdYi1fPGp4y2ftABvyp/bG4o6h/9uab2v7CcyA18HPCuDfRRM+36/YQGbM5DZfLwyOaLlRv01AClFOgfdRVYFj9eAe68tAK4rFGPaB6FiCGcIe/3Ld3nuqriGIzcLp4mPEgVnGrf8f9ZE101gaGW+oORMLgBL9wfPwpNIdU00Rh2r92VPXxAqmnSV3bNvGZPLh7FS8VRorKZhmiSC597wD7dnPg6FaBQtac0Ct1AyH466bpBYLb/9CrcinIvlm5jhIoykVpgvMFv/mV3hwKdNq2mxVv1gk/2x/p4rBn6hZZ1OHUAik24bu4BvbDbx3QQPUeuj6Te7eRc5TY3cHrjttI9bNyOhWJT46/JQVHaLr4PVgyD3ttEDZCFTeMFBjC2LxBBblf0LJwtnUInqPWuVtogNCAV0jCfAWjpCti4wVeMr/+byVkqJZB2tRXdbz2w/Izij1mOac/5FPzApqk9obBi6rcsPAsFpALQU/FKCWAjECs3MFH4Q3K6dbEmrtlOTFp2tVwFSJ42Lq7kk0glIFfrnF03ggODbyfYTN8JCw79PnPOkbEtX3ELIvfI8fmQryfkv5ReCpP8gTvbySBWaiof0//FQfVfZz9phJ+wTXLWMnPoOR6vEuHyWU8Ush1O3eo2J3peA/dcXGJiyTFohdeG0pD54rWIue0Lhs42uGxDodVHlaem1Uxq7FoGf7Hp7Sf01YNeRyiZNgcN8N6UzsMOw1pTSZxdtbcqDNqQ5Ufhh0fQiyUr+6Egz/Vy+6++uRy/1pUIW6/4r/mN+BuIiHCUXXmYAkRuM7HcL79O/rtWbrW65PzZmYXad0nMoMS0e5pOz1QGxnY262ZXg/3h5tdjnIBS2hC4GAckRhunWAtd7CK/7EfGD6Vq7+/zTTdfr45A6/f7Hp
 Hhd63H0f
 RMN8MrPGZ+xuHnmV8oM5slXdfPLIW5Bz7HBHzYRdkmkO6+yljhDvc6QSEsILPA1Mfq30Mpo63IwCWPqeM4nOyZXzHzH9U4LHxOqrHO/qopQl26hZqJA+N6SayhRni3zur2Nux3wTVsN89f0dxZbDs6lI68L9znCPUT841
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rik,

On Tue, Aug 18, 2026 at 11:25:00AM -0400, Rik van Riel wrote:
> Occasionally production workloads at Meta run into the linear search in
> alloc_iova() in ways that cause real issues. For example, when enough
> CPUs at a time fall into the linear search trap, systems have been known
> to get stuck for so long that it causes soft lockups.
> 
> This series indexes the iova ranges in a maple tree instead. Its gap
> search makes alloc_iova() O(log n).

Thanks for working on this, I really love the idea and more efficient
allocation complexity. For long-term maintainability a few things need to be
sorted out, though.

First, I will ask AMDs IOMMU driver team to do some performance and regression
tests with this series.

> struct iova loses its rb_node and shrinks from 40 to 16 bytes.
> The maple tree keeps its nodes outside the entries, so total memory
> use ends up about the same as before.
> 
> Patch 2 handles the one thing the maple tree does that an rbtree does
> not: erasing an entry can result in the need to rebalance a tree, and
> allocation of maple tree nodes.
> 
> iovas are freed from atomic context, and GFP_ATOMIC allocations mean
> the erase can fail. When it does, the entry is marked IOVA_DEFERRED
> in place and the struct iova is freed. The marker keeps the range
> reserved until iova_drain_deferred() retries the erase.
> 
> Ashok Raj asked on v4 whether the marker store can fail in turn, since
> the WARN_ON_ONCE there reads like error handling for a case the comment
> claims cannot happen.
> 
> Code examination shows that, with the current maple tree code, the
> IOVA_DEFERRED maple tree store will never result in an allocation,
> and cannot fail. This series adds a test case which allows us to verify
> that maple tree property continues to be true.
> 
> Only a corrupted tree, one no longer holding the iova at its own range,
> can reach a store type that allocates. The WARN_ON_ONCE is more of an
> assertion than a recovery path.

This is a lot for the interface contract between the IOVA code and the Maple
tree. We need a way to test and enforce that the maple tree implementation
adheres to the requirements of the IOMMU code going forward. You mention that
there is a test included, not sure if it covers all expectations this code has
(especially when the expectations are different from the ones in core MM code).

The last thing we want is regressions in one of the IOMMU-layers core
componentents because of changes to core MM code.


-Joerg

