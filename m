Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32F6606EEB1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MaDnbB4Z
Received: by kanga.kvack.org (Postfix)
	id 362A76B05B6; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312826B05B7; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228DD6B05B8; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEABF6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:37:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B209140764
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:01 +0000 (UTC)
X-FDA: 85397839842.26.4BF624E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1BA910000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaDnbB4Z;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeL+DmgE5YyYXsJkdebLi+O+vsds87IrC+NKWQ6kmew=;
	b=rihzMDuqit++XUb8Vxvo5C1kChlm+vD/Tcwn2f32S7StZxx44lTOzjV7+tty6WFyj42zQ6
	ZYORyf5TTI1LhL2Tdv4SpOmWAw8X/ipP2/pgaR8EofH8bBB8ozthszXis9GY1ctoiMhvdE
	TAz+XOiI6k52ajbc9p0baiDh3MSPS40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806619;
	b=FDfu+i5mAre/3GqIoh1ZWCeNC559REoagul5WliWtsdECGFoTK9rFTt1M1zhGKjqYwSZI3
	dPvbexC89w5YNkcjz/3rbECxVeLZ5etSI27ZqVELanSwy8/xBsFSyhelCf+nlFH91IhkHh
	7M5aLHz0RRJfxtJRbnozUihDMifEgto=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaDnbB4Z;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C67C43E5C;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00B01F00A16;
	Wed,  4 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806618;
	bh=JeL+DmgE5YyYXsJkdebLi+O+vsds87IrC+NKWQ6kmew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaDnbB4ZKPEpt6u0RSOjm+lgGWDW7uts+5vIC4xFaTDiY17cIhPmLHgDGLOSYa05Y
	 o+af8jUlzk74/vejpynM/TFOKwcQWaaJU0L1OlYysv40CDEti07OwiLv6w8ClWeAYj
	 78ckUFlYVDGf4PNpURvhfw8SEe/MYP7k5ThDBv0uC2CTCm8v5Gp/ICiFLtC7FIT2Nw
	 Yez7JAJ97l0Qrv5vLAFF8DkkzpPygd/XjXzzJtD+9bsidNJETijLCVkeVLaU2BtzSc
	 JPK54RQJwre2eUG1r7JmGkjXptxpFCSNB/VuWGRhGzIPx1rmRWWcKl3Uv5+wyEsBsp
	 LpGdBp2mkAHpQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 07:36:40 -0800
Message-ID: <20261104153645.82945-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104153645.82945-1-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1BA910000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7gx5uxc8ok13z9sb1dts5xsixt6wxmgo
X-Rspam-User: 
X-HE-Tag: 1793806619-403745
X-HE-Meta: U2FsdGVkX18sH9+DAZkpBVacHupNljXqR3jneyOowHPhgOVhcgSp0M16Sd5NTwEab1j940/mNZyoFQMHSzq0VstneMfDWmM+SjK3W2SfSDEVhJ5zntR2PwfEjzMHg4in/lFVYCVi/EjTGveIyKjAy6NJ0mGNhvYvMEQzwqSkEvL2zVoxMD6lafXsj75DQkXTEi/pLazXBSMzcov9LHtIl/MRG3/PDaUWdGGwvNUJEbfmpOuvqgaYxj1Rc1qpQx4LNLI9T/XMf1ty20LsCjECdfyA34CbULqORu1CcHO1tZQhgDIqZP4ZCIuPpqQmEiDUKDsfC1b4L44btBJSrJJpMUaFfjIrIho49pnDOMa8tIVUON21dcmts5F7u4s9NoKtSFPMC9XJTL3g9rY2XP09dYEasKtWIB+mCZTorbmsl0eag05YXdBgoah2fOiZKD573Ghj3ueQagfwpONed4ippGTTewHDDyeRA5G/1cD1ey/A2tXz8khKvix5Ij0LDryRDe5WXx8jGtqjBoGx80oSi/sbVGRWnI6t0o9U3/SLm0SVpCijTboLL2q0mxwMGW+pK5C275MYHTsoczr48ZK4+rUlrYUynKIJ1pMFTFyxfBf9qjq3T4IPENpcoA05tbPwGWFVwudGHOYzot5q2HuB+EEkCbRY+fpUlS+EW//JzSl+6/acTe1Bx42LJNKofBwHJbT2h49ce4C3DVua/IT81ZjjoDY/an/8DjZc5H1z/XCcitl9t50iO/oDB7CkQ5UOPMPa4P1XrDN6vPigjmxS7/MBDY56CTqIRTKh9DfpgQCo0VM/VxkG9Eyc66JlY3RHVvlc6RiTYNbtD4Q/UgPARZcUxwrIH4KRYTzRd/4Dt0qpf06c6WN5X9+5USoUA+m7NxFlhkbR4Po2IdLw6lVByCtVWlL5b2WR8QJEsSOvlhrVSW1/v1yGj9rbfyj8nMyTsTnqAJkVRBPXeKv5iN2
 rqbVuXH6
 Mk8/XAWpz0mV5G+S/Gtq21mtbMvBQWcE8pKJWjklg+SXtmTJmoG0OQjtmFST+K0Sqkkp3mo2VtiQ/I/gDW1zunb4nS/+y4JNQ8b8vrHRjDqHuGNV7FjSa/owU0Lz/7K01k3hbzT/8G//GGu86WmpCYt2XyOCLaJQvmYodIRLcrxY735T0NaDY1pJNKHjfZNtCkvkZTJqinK1lTmCU/i276fy6Da9gfaVrJxsvT+A3MezvnDTdSftAbmnaDNgpSavjlxxQcaorTxS+KmL4JEAOYdPPpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is no way to specify DAMOS target regions with a deterministic
time based age range.  Extend DAMOS core filter to specify target
regions with age in milliseconds.  Introduce new damos_filter_type,
DAMOS_FILTER_TYPE_AGE_MS in DAMON API, and implement support of the type
in the core layer.

Convert the age in aggregation intervals to milliseconds and use it when
the filter is evaluated.  Reuse damos_filter->range_{min,max} to save
the age range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 16 ++++++++++------
 mm/damon/core.c       |  9 ++++++++-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 380f9cf6ddd82..1302ffb6f0bcb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -394,13 +394,16 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
+ * @DAMOS_FILTER_TYPE_AGE_MS:	Region age range in milliseconds.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
- * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
- * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
- * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
- * before trying of the action, and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS are handled
+ * by the underlying &struct damon_operations as a part of scheme action
+ * trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS filters are
+ * handled by the core layer before trying of the action, and therefore not
+ * accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -415,6 +418,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+	DAMOS_FILTER_TYPE_AGE_MS,
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d36823f4d0928..d631863b034db 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -659,6 +659,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		return false;
 	default:
 		break;
@@ -1336,6 +1337,7 @@ static int damos_commit_filter_arg(
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		if (src->range_max < src->range_min)
 			return -EINVAL;
 		dst->range_min = src->range_min;
@@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end, wsum;
+	unsigned long start, end, wsum, age_ms;
 
 	*err = 0;
 	switch (filter->type) {
@@ -2594,6 +2596,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		matched = filter->range_min <= wsum &&
 			wsum <= filter->range_max;
 		break;
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		age_ms = r->age * ctx->attrs.aggr_interval / USEC_PER_MSEC;
+		matched = filter->range_min <= age_ms &&
+			age_ms <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

