Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63EEC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8016B009D; Thu,  6 Aug 2026 06:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B356B009F; Thu,  6 Aug 2026 06:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747FD6B00A0; Thu,  6 Aug 2026 06:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445126B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:30:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BAFC806D7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:28 +0000 (UTC)
X-FDA: 85070475336.08.094A6B9
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id B89A84000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PSMUkKIv;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXV8HYuCBUPg+q3wbYaT1cuC+gp82t+zV4yuiekj2LM=;
	b=hzSSLBsfcC48KPCwazbCNwyxOsvEh4SX0mroYUtVQjWwlu/2eSC3VZdrRqs1USzvC660QM
	B9wym+zSO2rnNfs0stJWbW16nSyDHWAzrKKw2YH4krs+FHCn1Ixcn1W8BnAl+jUMWOAD8C
	PFjwOEwN1SyCc4spaAc/PdCwHiMgV0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012227;
	b=3z6sieW+XpFtlgTnsKwJYA8K46yfpP/Rnydck81TA8tFviDxObHl+/qITLBlCGtIFEX0op
	LbUVEWbF6Ek1AEpF5MHOCCB4PbLHGYidPNgL9PWHYkHD4gtevgDhCxqmP8pZhW+xby35Hs
	kwhVYvcVLi5n6y5TSABKBpndKnC7qnE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PSMUkKIv;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXV8HYuCBUPg+q3wbYaT1cuC+gp82t+zV4yuiekj2LM=;
	b=PSMUkKIvX9HN2SMBmFVefzeaGq7fLlfRKfWErEUvvnngxXBpJjegsxOJPuggMUbpIC6QNB
	OTqG+3e9S2uB4MEyk1rYjBGvsfjx7CCLBOdYkUuaM68zslTf/1YRitg6cRGbj8r10XfG8Q
	4Q9+cxhyYjdwSxYmeD0paT+bBWd7NII=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 1/6] mm/mglru: add PUD-level Bloom filter state
Date: Thu,  6 Aug 2026 18:29:55 +0800
Message-ID: <20260806103003.3924438-2-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B89A84000C
X-Stat-Signature: ypnrxpo49aqqcnmwbuuhs4ebahg4ncoy
X-Rspam-User: 
X-HE-Tag: 1786012226-985026
X-HE-Meta: U2FsdGVkX18LV+TZIJtW4GKSNzoWrl/uJ5b0grXVWuvT+zPAVQDAgode/v9L9NkCrG81TebeDV6IAM68t76mkmh/OCQjQrYkkHD6o4k7E1dwxOaUomnXnfTyuGsub6QjcqH2prx5OQuv9fyF6fByMSyUZttFYMrqAeNcHrqvjIIcOjxwTngjs5wUIMuZp/QIn9ocDtj38dqpw+BdxpU/+zoZ4CBx/ZqPnFsd4cs9ogf78lQy0qqB3AK85F5qniqmGilynOrN0Ij4LrXbVB29neaLGuGZFoHRNe3tkqyjidBDin7y9U2W+9aGsF4Z7pgPcUQInvdXmTh6dcoar42sMLhaeSjM03ErQX07otqRb8sf10V+tE4WKQwXVTO4drzQUkICM5ARpMk0/PSpvXvofF6QlcmPcXpH5S/dqizNpvIeSIYTNmbcdDHg//E/9HlI3vRHGs5TFrsDJYdCjnbU3gs1e9mKNceUb9CfY36pB0F+OsluI5+w2YMPtO910rRDlOnQ+WWqzlrBxVSDKyarRTIeur29IEa9ubX8u1JWVhkC8gK4lHJ/OebRRmrXFpjgvBQrQOx4WhCOaTVfRDBgeRHsc4MCyxWK9Rqi6I+EytOr51EBgAPj6XA6sSrVJk4a4dXUZDGQ86uiXqm3KeB5p3wvABKt8bcG7M6Nkklkwga7p/GbqGUbCjbHe9sxLnbihRxHoIXAJFChrKQJRSLzh6IwOgtCzra1mQ2r19jWyonfc6Wq+wpl91aO2lIfmIeBAOWLHBaU0zwyf4GzSYWlyI9mo9RW9MmL/DcoktvJFCjrX9B1MkKqhP6mbQ3p26VYwZgTeZ53pGrChnH1nwRHRFA+oXl1jk7RQ75gyP2Viv0uP+Y7K57U4GxfcqVTAQ/zSKXMIVNFDsnAtZ6o8mv44vcWb5s09IzGRkLGySC5EnvDI7TUUrXmDYXNUHODydZtXWIR3fpqObSE4zjkrs7
 8R9IMQDQ
 h5JU/W5YXDjA3gYCgY2wKwIwkF5yg2lA1UIjps9JFwhwvdAo/NsaVhcDcz70RtfOelgMNp9GRJATanqRtXah4hvDXD2v8QZQxM3HnoAGynOfwBcuq76ImXS+E1OmGSRX1JtmXQmDlBs4DTIZSN/qdAwHJAFjWiMJLqyl666ItxWJbqD4ekWXAqvfXHHMF96ghBYD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a second, coarser pair of double-buffered Bloom filters to
struct lru_gen_mm_state. Like the PMD-level filters, they flip
each generation, but they operate at 1GB (PUD) granularity so the
page table walker can skip whole PUD subtrees whose 512 PMDs would
all fail the PMD-level filter. This mainly targets the page tables
of processes whose memory lives only on other NUMA nodes
(cross-node empty walks).

No behavior change yet; the filters are populated and consumed by
follow-up patches.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..2bda24522d9f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -608,8 +608,16 @@ struct lru_gen_mm_state {
 	struct list_head *head;
 	/* where the last iteration ended before */
 	struct list_head *tail;
-	/* Bloom filters flip after each iteration */
+	/* PMD-level Bloom filters flip after each iteration */
 	unsigned long *filters[NR_BLOOM_FILTERS];
+	/*
+	 * PUD-level Bloom filters flip after each iteration. Same double
+	 * buffering as the PMD-level filters, but coarser: they remember
+	 * which 1GB PUD subtrees had young leaf entries last generation,
+	 * so walk_pud_range() can skip whole subtrees whose PMD iteration
+	 * would find nothing worth scanning (e.g. cross-node empty walks).
+	 */
+	unsigned long *pud_filters[NR_BLOOM_FILTERS];
 	/* the mm stats for debugging */
 	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
 };
-- 
2.54.0


