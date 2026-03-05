Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8212DEEF303
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608BC6B0093; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51EE86B0092; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377BF6B0088; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD3A6B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8594B8C524
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:29 +0000 (UTC)
X-FDA: 84510906858.19.02D307A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE0D514000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF76mekm;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3syspUfLHfxvi/pohRoF3xJgBV0BxTjNwW+7OWRmSA=;
	b=tcZOIaDA9C1EfZ4oangq7Ne6OWU4eDg6BJyAli1NrFyfnO+eBAoVKPQo5FrDI/plJ67UcJ
	0FbMidx4Zf9HrRMZe7z8MVyS4rKMb/xvcJjK33pwiiC9LjzQu5G3GBabkhbUaHHcO2px8O
	3ZWmGnrCS7qZmWa5ze0bPyHCDmG9xXY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF76mekm;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=SPTK4RoOMRK4ujdDl/rOdCqM3K7KDN22hNRqH+b5Gc/Fr182Mtd0U1LUHbTHT/qdkKar+Q
	TuqeukqB/PDzKMOQ6xRMLUuOp3XawGXpY8ZWWovfnhKMgEdAqSEMgnMoIx9gxxwevm1nkA
	fFic2sM7ZVgkvCtslyMOSP0txc/k9lk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7658761420;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346EEC19423;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689167;
	bh=mqrS298EvCt8+EHb5aza5DzJ8VI15nbcF2oVbBOpCLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nF76mekm1OnSpkMCOuLU8n63slrkkELJNnTBBSGi7gyGXGB80cedFl3EHHb8qDAnW
	 nfda3ULhAI9uo1HVhqKDvAPhOlQDtlQcWCuDPOh081E7SKGYV2I0YsEJPRENTryrFk
	 DJoqjYgUc6Sihv9ruypthGx91c3+97PumlSHDPeTNpl3Ay5jjZdMnqPC6fU0Y2D4Ym
	 SLoHuT75vr8tLpPW2sAhoxvQwy96BwePlBFH7qpiuABtv23yuTi61qzAIeSzkkchtS
	 77dI79qAPUnYWOFZJoXUDqTNKpgfA7KA+4tzGciQ73aZYIz5r3BYlwrVkGIvXPTUd3
	 rAFly0PFSizcw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
Date: Wed,  4 Mar 2026 21:39:15 -0800
Message-ID: <20260305053918.83786-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305053918.83786-1-sj@kernel.org>
References: <20260305053918.83786-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE0D514000C
X-Stat-Signature: fbc386xzsn1enbkic9je843ntzyb8jkc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772689167-872509
X-HE-Meta: U2FsdGVkX190iXEEZPEx3Fr5cUTfycaDy+9PweC7CEZ2PfDFwZe+wvRCgEcna/HwzS0msIClGdmqSmhdvOlmX/m7eD5ZCCAdVhGs1HuiISNAeiqm6jpY4ouk9W6P/4gqNvl0LhO2pKKSko8qM0YnlRpKZiTm/0O00gMJSDF6YiE3JS9lE8GpDxMsH7vWXcP3cKwj0jdA4MXc98dGeJvbET2ovcBNdEWNgKEMV5EYnfFBX2jS/qeKjk4fRMbzWt6UPM54ysJm+Zn4sVrCEkgSDrcGI1vtP7PksDbM2RI42VH4LA4rdNiRZPzrXCzwEl4pPi7JaaJ4VB0gujDJTPdWIIF32P6um2rMB+m6hUnJ+tk9ZQZUIJGExXWquB60PK3aVFRHvqhUvF0drmds/df/TK6RHm4pKtpHGq3IVkK0iX3Oa9joIky8TQV6d9I1VcGHaNfhIJeaCT2HxBkh4IaMfC/3Lbd/h+t2FEJ1+11kMQgCRia/5KhKZ6b8/5Q1V6h+Www/VEGVtdUu3MH/PrOPh6NsxavhlHvg197yP7JcBegTOqZXc/IufC4bwk4iqtaY+Hf8MLAZ1+YMk+UA3eG7VejlD7n8TgroZMeAZRsiR4jswX98v7OZk2sDdvYjtPJ6vtMSJYYENMZ64sGhRSG56FAcEv3QEPYayXvNlDLryaX62rzch5h+7Tl6zgupAEQj73DqRmRHZJFKEBqL1Rn39Tn+iiqAf0Fu6u3qhivn6ODui7rmILebigqzTaZy8mIoPBDRnQ2RRA4YO2IpPSNbo0WB3aafBSYWUuyUXNoPo/zpe8zjQESlqD47wY73X8EJTikaY79EdTmVodcOCUhaqwTWDhaG7Cpx5sgE4DGCHuF1j0B5nXlb21bj8AUJjaMWJTEJN4nb7mx8rBpWAS0ERZtn0STK8cCtWUuL70M/xZhEWnsVTd3YuAi7n6ttMsVnUHM6m7NIcPVofFGvj72
 M1t7RAyP
 6JEMn7zTpduHLnp4Qz0mBkaWfByHJ55Rwf4Von6zJh3Gg/DUkGi883JcHNiPSXLMjrXCw5ubPdQFhCabjAGvSsPBJaax86Cc93THBLHZKsvFH0ZvMgs/29uGlEXLb+GkWE1c0HwpQhpp5JgFoyL4ekTUBajrSVLZHwX7+BteX39Ka3dxIIagx2syvzsDbHiDiddE5ko82+GZcLMixGt92tGfVcN44Q/R2A2ACPwOcPKJxN/rOqSWGVLzNI+sugELg1/VmDKi8t/Hcag7jr6Xv/l4FJCw2EjoM1AVhOv2HBDIWyrG7oS5GoHP9nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_find_biggest_system_ram() was not supporting addr_unit in the
past.  Hence, its caller, damon_set_region_biggest_system_ram_default(),
was also not supporting addr_unit.  The previous commit has updated the
inner function to support addr_unit.  There is no reason to support
addr_unit on damon_set_region_biggest_system_ram_default().  Update it
to receive addr_unit and handle it inside.  Update callers of the
function to pass value '1' to addr_unit parameter, though. to avoid
unnecessary behavioral change.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 +
 mm/damon/core.c       | 7 ++++---
 mm/damon/lru_sort.c   | 1 +
 mm/damon/reclaim.c    | 1 +
 mm/damon/stat.c       | 2 +-
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c4095b34f7929..c269b0c93f9df 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -985,6 +985,7 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 38c7a919f9bb2..ce19d751f5102 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3099,6 +3099,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
  * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
@@ -3111,7 +3112,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_region_sz)
+			unsigned long addr_unit, unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -3119,12 +3120,12 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end, 1))
+			!damon_find_biggest_system_ram(start, end, addr_unit))
 		return -EINVAL;
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
 }
 
 /*
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7bc5c0b2aea3e..133ea17e258df 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -345,6 +345,7 @@ static int damon_lru_sort_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 43d76f5bed449..01f2f6cdbcdfe 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -251,6 +251,7 @@ static int damon_reclaim_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 25fb44ccf99d0..f9a2028483b05 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 		goto free_out;
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.47.3

