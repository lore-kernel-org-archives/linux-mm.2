Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8BEC624D6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3D06B017D; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC156B017E; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9743A6B0180; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60ABD6B017D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4A4A41EB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:39 +0000 (UTC)
X-FDA: 85165235358.20.D528345
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E68091C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e7aBuYx/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/E3Oie88We+VUNBoQinHbEvxciAXpLnuOmC5tKc4/XE=;
	b=Ie8y0QGxTELLTXosuP6BhQvWmD0CDMOH/nWKBopYLWTgPk1GJrmEgN4/TmNBooOKzxC4Xq
	DB/171E2XjMQfn4HnL+4IOEG43TAUJPdukxeA/iHRc2+7xANNsWo+Kiacb9VcfvgIGTu6J
	yCL+l6GC0cKBETWoZXwjNSOcxlGGnQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268418;
	b=O67oQX69NKGl/BJ2viTzOnPipyqSFeFr7MJHYKFF6wZTZ2mX01hX8deBZDN3ZoI57lmCaj
	fetm8e5h3A6eBNrVdC+EzleGLZ5fS2Pqa+fJj2a93+U0qB7S5aDD1rEbK7AJ81PLsNE3K7
	c1dgSbz3dyU/PnxnQ2VLfoLFaxenBOI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e7aBuYx/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DBE042E78;
	Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A4F1F00A3D;
	Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268417;
	bh=/E3Oie88We+VUNBoQinHbEvxciAXpLnuOmC5tKc4/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7aBuYx/zoaNFKLfyEi3UwnDYq4cH2lGtZXVK8S2AnTXEpjIkTxPvQPvbnSKGBfCE
	 n+3ROEh/GlRyDbtHcq8cp9T2dv9o+stRSkAbb9/rXv1D02xuuuaRI3FjNcDA63olqM
	 +f9pWQPDebd/5u3QrrvNqgVNHMvS/aGO+8a6Bnt6f5wBvuFy3QoKbraB8D/HcNnQMd
	 uE3raa2cOTxCpXZDsVTb90cy+Wqql3A8KH42Q1xeIFfoIGLwnubw/p37bcVoUiMKf0
	 hbcuRernukzJBG6qSveIbRz9sujbYxISeQMTsBRVr1JQPkhXSGrVH+DWGztzhJ/Ozn
	 umezALzzlzjwA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Tue,  1 Sep 2026 06:13:23 -0700
Message-ID: <20260901131326.97615-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E68091C0005
X-Stat-Signature: rkia8daxb3ig98xuswmp4q6tq8crzsub
X-HE-Tag: 1788268417-654760
X-HE-Meta: U2FsdGVkX19nMYP45MS4MzNyntX318u8WwZwXeMF4vbEZHo8A+1+UquHNQez+PzkDevPQMMp9iC4A4mp2p47GuercRcZY/ajAO+BinupEiuEbP7Vzk7rv4MGtEDr6HCc5wzj3ofM/gkXwEiFEoagh/Tu9884IbtH8EafqJXypa00UDI8v1xMWDCR4lL567D7ZpFx7yL7q0so08xTjgF+pVkDCv0fIKYZURau4OJFXPWCua0CaO/HNc4aH59WOqp72sugAue3Abtf04V/MXXQ3NucXcuqeomif1jxOZ9YISI+nAtOeHYVZz4guv1OHsC6B2WpVpfYl6HEQ64yfVpFhZqgVT7KeZ5eod/OHIe9lv1CBk5lhlK3gwV5jrrhnrQXPG8a2DyiF9PaVp8tvFE3j7sO787r2UOPgWYYEd+oNwgnpsyuN4AQk+QKYVPdhoNm1AJWHVisvpB3bEpqW5GwgNErSHyZxNpx4vjAy/+YqsKq8/QTTvOySP11ZLQa3ay4AXip9cDyXDr5BFHex92YlWINvkNomu023FxO/ZnhpMRnruxbMN1HOAp501u0sU3kM64Mz/Don62jUhC8r9btY1FJwhOPIWINhJjQ9v+PO/bvBVPVjgTKS7o89f2yO1HMFjs87s14j9RXfcJOMRWf9117m39hSKHiORbhBB0NC1Nel3W/WXbQTrProgOOKJ7DA6X6s/6S81E69c+0ZLWBZaarZpcdD34LspJntuSz7yCkKS0moJWu/I6PeDDiNwC9UQ0mW/r59Nnu0eqSaBeJyBDkx3j1H2Mfe14KNNnXhdAsz4kXctVYs9k3jj2rpf3uXlahCMlfk1rsBfn1yEpQqLAdd6iCfZdnb0dMtPSyIUsun0/8x/f9E5U/eTEGb8W87wYhgKyP9dit03i4H8EVTNlC0F4J2Nhud/Hvxhoi503ZQrUyz2UT0cft07KS26IIlr/wF4HnYnpcqYKRapZ
 F2p/Hj1b
 BglXpBMxW8zcpjinm1slFAk/nT9YhfOJvXeNb1HNrj7Fn0pVM+QaWItdS24PRdslqu4Zbax0ExlPmUQ7n0BVdgGGTBrbRmZRcIMkYGFtyjawGKNmcraHp/P6DDEgLOAZ73q64MI1H0K277z+midLiLnd+P0H/sfFrq5iUlNOADoVhfezRgGtOjPzonOe7UvtZh1YzHvQS+ZkmyCLiDLgWDW6PKqSjIumq4H40ege0rbT1blaMwkU+PA4Bx1wZ0bFJpot3YSPxvPL30bKjv64eUzAkqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero,
or return underflowed value, respectively.  Handle the cases by
respectively returning 100% and 0% for used and free memory queries in
the corner cases.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ad3657d356fbc..3060edf5e4fa6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2854,6 +2854,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < used_pages) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 0;
+	}
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
-- 
2.47.3

