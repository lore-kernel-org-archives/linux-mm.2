Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC79C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49B56B009B; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB046B0096; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99CF6B0099; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1D46B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA1BCC0310
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:08 +0000 (UTC)
X-FDA: 84965753376.20.0C89260
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5275F4000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxDAyIRI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518847;
	b=Aui8hOAOsOOtn/R/SJgYNLn5jiTQB+xSemT6fv8Axg+2CP4WlEplOnt6laphmfYo3HzQAV
	jq97++vvjRnRhlJKcjNDF80lI3ac0NkL56o1E9HOqdO7Gd+9xaHzhD2I71o7jYHpiwxcsd
	r2JhRPXZt1SvvCsu0u+61gMdu6sILbE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxDAyIRI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	b=N7wKYtEI0yVuOdDgKg5p2ULOqWXtXCkjrGFdH0WKd7WUvsbbRRVdGUnBOStIiVAyK9VwMH
	1d4ySJQtjVOdEpw4Jk1kQrI7HreXx+/Vf0zkNn+Eu6SikfZA0Qe86EBiQPLLOf0SROYl4t
	+XNy4EMGk8zVdqE0Wk+itvC0AiNu8KU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65870413A6;
	Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA48F1F00AC4;
	Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518846;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxDAyIRIBRlvvQBM8CFCQngny4rEoen3UAXeC8mg1FK5beBFCr3F0OMty+Nk1Jz4D
	 +2+ESGJOPXHhlmzmbGKRNciyC0Bfh3mzmkwS4/qS+OeCNIDa21Vc/gbjJ7XG/vbkGR
	 WxurHfb1JRxYJ5rqNXaDdb5m5FyX8zT9KGQfnWnZ11EXoUh7M3tRkguqx5PSR7vnMK
	 rOee7/97UkSQc6ptKZ4PoNyM2cLAVs//AqTiprBES/xypXmeER8IAJPw6Fn5Yb3ILW
	 9NVeAiztbDRcYY5f9lXCYhQH5sBnJAlTPy1uayfjbql2YOYnQc67/IuFKbK6VMCVTb
	 oRB+kh5aauSgQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Wed,  8 Jul 2026 06:53:54 -0700
Message-ID: <20260708135359.122587-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5275F4000E
X-Stat-Signature: s61ycytiakgytzkqgiiithp9oxgh5n49
X-HE-Tag: 1783518847-793108
X-HE-Meta: U2FsdGVkX1/eEPricbux6aozQgBp6ZIAOHR0+cJtiQPMnrf7wVFnZiD8/ukHG9G2JR6/3YXSCFqADFfY+tdhE7A0wv0yPLsoQj82yHylBFF8TmHWt3fiXGsWb+ogL5OroloN5gSOdwbvFHQ0623yd/92ou6BFC6fM2GvLya/Ua4aZVqzUOUA/xjWmJwr8wfJqnmHnbVjFbQI8mK9r2nHK/c8x+IarNZik3jJk+zf4CQIR8OUzHc5eJRqou3vUGTx1k1MedZNpJ81R63jsi6QbuD6AuYDWVQ3nCvufW0SSKLJ4s8AzdQ4KWIyduAyh4Gy7oeRDvNAtDrO2G1vHMPEfH4AbiNYWYY28+TrQivtE4HkCYnCE9Ii9tbcDcVFY1kln+Rx5CLGr9bj8+RrorHogHesomkqKYA07JKRgAqHSNs2OM9IKP2Frlwtdmy6NcNALNTmmdY7UKdO0stu0SVrsndw+5+qo5QqX9S0f2NFU2/IRKDUwGz4EwiDyGZ0NNVwnSECWLB07a+CcJSuzibsa963thM6xIgeaZq1PF8SDdZIpLe8SmJzeWJhhhJ5z7ZNyo/s2vLtOOc82tbG0jo1ay12Q7gwPqihlmWcloAOYMa3uOlmTYGFCGlDAxW3LMHYhmw/hOyflFYvOAz+CnzSm0VyJ8R8D1nD9hoBCh1j1f5uKP3rslys+CG0nRE4nTx1Hm6eP7ZvfePRoXalAG14xfKL+uZfeuisDVXgc1KQI18QpTagG7qCkhqVqVicc4ihRXHBHFGwGBHvKEVCQeCCRp2e4ScAnYf2FXzjjkLZawSGiHcXHscU5zEk6xynanfbAJJRzONDlGy6/eVi5AMASPMwYuIeAMpOY/7sKAME2QB9rdH6ZbexrvhIivjtaLfUqwzMhWr5VjNz+pvasvWyPTxsDaod7HYBlGDvguugK79lJFsZj23sYr+DUmz5hWOu1cwkmTpYxip/XkoheVd
 kPIl7P2B
 NEZaB6X6g8MFt193GtkOhekXwhgp6rMVLMMt0No4iZ2evBHXizMqaA5ge2ZUe2SQH3yG53AKdckPJXqkyWX5EQRjlLrutVYSlR+Tb6l5dxNRZwQakTCCBibQYJBoYJ+17KwA8s+7T969/Sz7AsAkUwWvFZDoodRlsId6H0xAks98137sXkY27EyIVLtPD3Y0P/nbW8ar1tnEc72Cmme4lxZZ5Q/dRlvjg6tKSmtArDKp+Mhg4DLy7oitBOLxKVIPyFVEBoqRYoAUtdM1xhmKLmnZjPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does
and not confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dea63083917b0..718268df27fa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,19 +883,18 @@ static unsigned int damon_sample_bp_to_count(
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/* Convert nr_accesses to access ratio in bp (per 10,000) */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
 }
 
-- 
2.47.3

