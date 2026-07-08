Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB639C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B836B0092; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AB06B0098; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9EA6B0092; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE6B6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC28D1C68D0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
X-FDA: 84965753334.26.4668415
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35D7F1A0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6x65DGG;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	b=r1NP4Or7nbx1NPICBslPHBcMTRxHMk6kUlwnHF1KWxnWJq3Rj8HiR5Zy19ErNuWjtM0jin
	Hw87hBIySZHO4ktvhKE1Si83Jpxia70jBgYC3lFkh3nu1+XN862PXdA6j4kEgB40cBK+yS
	FEZLf5kSzD/YPF5Afhde1FYnmwXwlTQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6x65DGG;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518846;
	b=diCgB96p9SKHgZnX9Qh9v7L2kSDESeuc0X09utpxJScnpwSzhtbq7EbEQ2UgtY5uG6DxQF
	GtBiGEFoHhoCi+MH07RHGcUypwuF0GqHnRrkPhnD9W45YZwNZh0YIl4nudAGTaq542nxpI
	91tnXvSnmjQi3VANARhOW4dStWkuYWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEB8460054;
	Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E62E1F00A3F;
	Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518845;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6x65DGGS/tT6/Mr0Okk5JH2CAITGHDYDHvuxBbfA3kmXINy8o+mGjeJJmasjB8gp
	 Do+wtskX4G/pOhLsLcqHp51pdiM/yRYowoRWo1BKNZyjQdbxJn11d8jW5uziae65Xj
	 4eF3b3mcj5oRxBosUCH76bQxk8gqlk64faCW182pdyjcKrIbd5pSloRgzFkIEbElZc
	 up2FBYRCNi+Qb+p33smhvk6w/A/GIp1jrqb8SKqFjmHO9tP4xqZ0z0B+Q0rf1jR9Fa
	 y3nPmCl/Jz1edwvT8xhJVwlMnDtyjuBvId+WKxjYKFqeLQK5wX6p41d4MxRPbN6E9t
	 SlYLSd3mFwmkg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Wed,  8 Jul 2026 06:53:53 -0700
Message-ID: <20260708135359.122587-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: br34ufg6x5a1i8ek1jjstnfwxgppmsx7
X-Rspamd-Queue-Id: 35D7F1A0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783518846-790818
X-HE-Meta: U2FsdGVkX19S21gzKBUCdPSxIGxyhQifNTe+MCIE7jW6C3uOzY6ov+KK5RvTvk9uoOtt65mIfgyR+zfTlhXn7cOlc/zdcrEV4OGa9JKZP5OtRpli+8HHPK2s4OUL70Lgw00vsqs+ys9Mqrju8OYKF9/Z1ZpIgiDxoxnv3v1GYmkPn453iw8dC6dhrhxI8OCrad+TfSgdJCsb/rcVxtQh5JtsYRCsbtVulxHsc0DYVap0lQnRb5dMDemKDKS0Yb4oT+hZm3er+pSY1/JCg/buT76cowFYEY84b/wQD/LuLXPLzeBv4hkxNoFAk/ScH9roKu2g4fIyIKsp7giCuTLn8JB6h1YaYc9XKJaSwG5neGdy6MfzxzW5nNRLlvT3jjc3OvJLds93EH5WHQ8LtfrJRFOteOINPnHdqC6I0Q7caDrygVPYoWAsMi52rWzZ8VAxq8mOK8lx17o/81pZf7MD8ohDOKJKB7iE87myKx3N//7sK1bo0uXqyANAY9Jk3b4K1c3T93xahKjyJB2D1/pyiBnVYtABvz4lMsG5+H5zuHjDJLg9Mr7m6yAqoXMgQDrPNF3laatepMyojWQAdMr4Es92WoCfL7y0xjO5X6vsD084U0yK+g8dKLBbBODbejcOD4ynBihcn0NyOku+itBBqVpU5b6sbnNfllNQuOTMGyQBw4iemCbVLxfJBOVoW4fAVjobqPZwYF89gFMPGtTsStblUHzjRFHjWOoWpo1Vs9GfnTyTjgSo8HzOgsnsWNn9eHSmk7UInPqY6D4KXBTPIWVUTvQFNmBUwvzdXzfVO4/KB7TaWNm+zeTFq+3gOkOcAfNwdsTFqEiq08C79/plGCW3+viyfj2Am5aJp87EhbolM/CRXu7+SWW+gkyDh8WMREWRLyH90+egLyVxgZJFlmRJ6WRPQWhPUQU3Mgz9F9Z55+QXI+VLuGYWSJO5pt938WcmM4SdJ856O/ytxgX
 GRlYNKkG
 +RljQbiDtdlYk7PwHIDoMds16hg+3f+DK8WX9+66PEhPhx18tf+G3dpPtQIm9VFmsnJA7lO+vLH4v00VKZFRpR0DyxD80MP5rK6AS4M/Ht+e0+KRpzfIzYTofTDYd5nDnLgjss7m7TWe6WcH5c0f2W+lbVAgIT/wx1iI+Kzfz9BbXHzNx3qPJepSXi1s+8mLzxM0//ymjovCCpIsuUrnkS2kk4IAUeV35N+i7+8xBa8QUIK9aHWgEyBoofIcYw6zXpLVKtGr8VXBs6qbnuEXT/hWRnBybJYNjHpxNBZA75vQyOR+11oE7PafKzoyels9fhb4h7XIocs8O+M9au7zcOWTC1jzoocZlL5oLtiDSV+XlxMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

accesses_bp_to_nr_accesses() actually converts a positive samples ratio
to the count.  Rename it to better describe what it really does and not
confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 177e5abc981ef..dea63083917b0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -876,11 +876,11 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
 }
 
-/* convert access ratio in bp (per 10,000) to nr_accesses */
-static unsigned int damon_accesses_bp_to_nr_accesses(
-		unsigned int accesses_bp, struct damon_attrs *attrs)
+/* convert sample ratio in bp (per 10,000) to count */
+static unsigned int damon_sample_bp_to_count(
+		unsigned int bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
@@ -893,7 +893,7 @@ static unsigned int damon_nr_accesses_to_accesses_bp(
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return damon_accesses_bp_to_nr_accesses(
+	return damon_sample_bp_to_count(
 			damon_nr_accesses_to_accesses_bp(
 				nr_accesses, old_attrs),
 			new_attrs);
-- 
2.47.3

