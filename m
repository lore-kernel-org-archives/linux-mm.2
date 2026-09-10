Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3384FC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247F46B0093; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7D76B00A6; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0998E6B00A7; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7A9C6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C06A4130
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:27 +0000 (UTC)
X-FDA: 85196523174.17.83ABED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A901820003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPoKLjX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2ojgP+YWZIQpYhSbuiMhxpjYN+Q61j7jKyFOHSqFg0=;
	b=kRvX+JDVhAgb4fDMkzsf+j+WxZD+STB3ECIya8y44Kc6BcKRS09RrvV7aw2wqRZ0VWvI5E
	7hqAVPlch1uzpMMYnZrOy3nuB+q24Q+x0Cfeziq2lK0pFUauBNb+kyZtESQgE2cGOPfDar
	reVe3n1onnwMp2giettOKfmy8LDVZLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013365;
	b=iviykFq2wgZyQqzLBQdr3CJetKIFO13XIks1zEzfiMLIpcgpXPbDQE/JLU7oWLbkrOl5Tw
	KyOhQK5fbr8bQtXsOd70EUzFtNjfXIFCNvQB+NpwyKWPoMEE6C03PTknFtVM0ST0X8k1Lc
	grFP623hca3/OX18Zl/4XYaQeMI5zcM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPoKLjX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAD17438F2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9351D1F00893;
	Thu, 10 Sep 2026 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013364;
	bh=i2ojgP+YWZIQpYhSbuiMhxpjYN+Q61j7jKyFOHSqFg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPoKLjX+ZcSlwt52QHYcV91tQAe1h4R68xOCna+AzW9rW7CYKz9EPUiT2mkjvDx9P
	 gC8I5YJCf+0Ng7NrdtO2vA25p6kXfQndZ39kXqloMVSlDEp4ZYmcloVt7byG2u01Gt
	 H7EChV8Bn/EXfSpdqffqsGiGKstsSumn9af69c8RdpotOTtpxW9Jg7CQS4aVFMv26W
	 Qavqw/rByypBJCGzoLgdxveFQYFT0pg1ALsfA43Yw3uZz+MeAHmffT4jvDB/fUwuQr
	 jMXY3YZnZssfySxQAayfsHtBFqt3WJGwZA+kRwj4CokTyTOiIiJMmWAoR6b/VGrYhy
	 wAWv0wf2ESBmQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/5] mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
Date: Wed,  9 Sep 2026 21:09:03 -0700
Message-ID: <20260910040911.148273-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040911.148273-1-sj@kernel.org>
References: <20260910040911.148273-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A901820003
X-Stat-Signature: bygiori3rs5ihs4i1pa1g46z3m8jo38o
X-HE-Tag: 1789013365-346337
X-HE-Meta: U2FsdGVkX1+2IyKs0qx26jkvoTGMKhyin5B5mxs0V5e4d347FJj5JODe+L3Kq12iadB+9XWUjMOUbrxiq10vLTuYO7LIBg1ECrEhr/dUXC+UDruLhEvRJJ0OmrSQ24hmcFIvh9pA+N0rczxpXxr5V/2zpXNZG+gZjxTm6H+oFDo8wXGo/a6ZUXhXu+aUKTG0arWUBk5V1QlnZERqJxTXBFzsDbrejlJbCxm4Na66xB/qAQZUjvmt6bxtn274re0L6tK0G9t34GAPnb7kGVkJK3LtgFrvGCIy+1HumpobJ+GbcaS/yWXK5gdt/SSx8zOCBSmpR8l8Re1SRdGX8fJwB7FDnw4sUedme+eef1smKGqcR0jpYC15TwSho6v7mswr8J5VNFFU2BSAsMZ6FPLYCjH/5/UY5U7nOVwH98lobicW19Gzhrz3LvaHshwkXrbkHGB3g+fH7Ne6yEBM/ZN+04sEzPUAvtb/gEU5iQJ8IDSNk01rHdAL3M/99DnD9pVKvRYwXdrecOZ5JvQg/H8dmQNKfaXfaqxyHr8wa/DVfr/QSgd0Smtmb5ppkv+tthGg17Pr7MKZmdB3UmXcK1b+7zXORSLar6by0IWZsSIOJ5yPWqEO6KXSYH9+UzGyUzj7G9vbNyAsaBVOGCMMzPBTK4okccXfcBFw51BsY4+oxw+8ttPkjJSjMsdg2yLEict+eJFBCsgXD5WLqQOaceeE3aK6rGszRb+b5w8y4MWrgq7ZB3unpv8lhK3bauMstICJ1+fxGwcFi/1ZN578paHj+iU9KfPDCRbZNxjZnTzEPs8mGFZFxOCzDWc+SYjl5I3KuZbL07B+N7fFjI1cosJSeCS0wt9Ametp9ZsKZcSQOZJz0emcyr6IfvJRMu2egGos+xIbuRyyl+j9IEf7Kt+Iz2+geNWNzx813XBKkephxMAfGl3tUszLdfsVzqA75sJxoWF47GQlzjHZbwJ6Txc
 Wi1l2sRh
 oazlBPPnXB744wmAjyqGywanJlQQ/Ov974niuzmQDOOHf8d8BbtWMMUxPRT9lHKNUC4t9HC8S4iFSX25mRDKCZ3G1Kzu5SscVoLTwwdQDlJWvnNMW1Jl4t/oeVsfhTKCLmxZmgcwn0P5vigZTJLhN2ExoofMdyMscp/goI1XAYXh06AJMYrAKTfyt9gJBAz33IwEHhHbK2JBdwLZ6CDeSC44DF5kUWuhikITt2wpMbOGU3s3m9OJke8XWQcBRn5Y9XNkkyQb448h/b7UfCZ03EaTa4c5bEFlFKAKT4nb+kxwkMUBtB6GsUcto0diHTktKefeIVmwT/4GdvFL/HNujF0JY3q8lrlt42z4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_FILTER_TYPE_PGIDLE_UNSET matches only memory that was able to
confirm if it is marked as idle.  If the memory cannot be marked as
idle, it simply doesn't match.  Hence, finding memory that was marked as
idle with only DAMON_FILTER_TYPE_PGIDLE_UNSET is impossible.  Introduce
a new filter for the purpose, DAMON_FILTER_TYPE_PGIDLE_SET.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9fa99f92a2e94..ec6bfc292a7cf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -782,11 +782,13 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
+ * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
+	DAMON_FILTER_TYPE_PGIDLE_SET,
 };
 
 /**
-- 
2.47.3

