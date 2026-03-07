Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9DFF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6681B6B008C; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612136B0095; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF866B0098; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25CD76B008C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D10281B882F
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
X-FDA: 84520318218.17.90A4B36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B395180002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KvI/3slL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjPXi43vqpWqMtXI/ZK+eBlk9M7w52ybQlK65T8dPIM=;
	b=raNglbWyl18pEPFR/TijxMQakonKnubjlKfapO25Tjmwb6eZtGbbkCiyj7ZatYJGlglPsX
	n6XWVWOyG9YWXFgXCBhgQaQlvNszbDVDeufwZgYjgGmSg0xkClc8AbeTWqJ9M0yPXuMfIG
	vcOKDhHHUC69RVIYbv/asltgP/1kzQA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KvI/3slL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913248; a=rsa-sha256;
	cv=none;
	b=nZqlC61YL0GVeKz8Tc3jizSJFDv5H/Btiy+enrPml9KQVRKeEdgdV/LHjsehBN6nO8ZOOZ
	zoMEk4z+yOsqDBDUbgBgmVuiJ+9DYQ/6kQLgM/vnLDslwPzjfc8qJEMT9HyE30e5+b4JZv
	R34PyR8notZIKpgCOTI+ChidlIRlGoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD44260123;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42748C2BCB2;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913247;
	bh=JAJpE6K1OeR9GVQIfwKv0nXxU/6wR4CIuDdh8NIuA0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvI/3slLTixTWJPuy8wRgOO7cNbeRJ12UJMkkQu4o6PX9jqH5pgpLj1u5hXria7XV
	 HA16d7/8v+ycDnzUleKLRhdztkVi/mjdmyPnLBmjWEi9T71/8P7MsOb1KqA5fxX3jF
	 9ec4n7LyCq2DJI882zt8zstCfyRmShCocp7SmfjWy0DGW6OALxOqk3gE7Gu5dUlLyF
	 wVLV2AAlFe39YCEm+TfNs8eK9QrS3DTNi7tkoPoy0yJYvUdjyoX1qjL+m9kubIV5Dw
	 Fd4kfCQ7zKWBNMvGhR4a7tuGEhVi8occ9UK4G4IKK+7sYwmE9EgQSowLHpSXTvxC0V
	 H9FLAC4L+lVrQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: use mult_frac()
Date: Sat,  7 Mar 2026 11:53:49 -0800
Message-ID: <20260307195356.203753-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B395180002
X-Stat-Signature: b8rrg5rcjstgxs8h4nrz95jr6qunhmrn
X-Rspam-User: 
X-HE-Tag: 1772913248-408388
X-HE-Meta: U2FsdGVkX1+ZUwYK7DXjom/1c3iJnZ/N0fQ/yRwwR4AL4sw8E1lDfMbHUySrm9C2aXgXFOFFXRlLnCYtEnTGtaHpUxLf48WWztrGAxqXybtehlN1NzpMvPtIlfdYOqlHy9UZzfPwesOlKLeFlPW6ufHWs5OjSy8fGp9VYLcOPF/qxiUxfdhdbN+tbDiZS6xUxCBlQd6Pp807b1bQfro/YZvyxBl8NdflHo3j+iu34w1J4467RWWlvzjd+AA/ZROasOR9moAwwtKDUstwiiqoic6FdBmm8KqaLZSJgaoXqQWMxAGBR3UKZb2Mri4KXP6M0W9QOnAD/XqCVI9s6Tr+3vdipc5E1es2rQq4O/jR0UavCtCExJo40bNEXqQPvxCa/eMbqMI1ftymewJxudrX/4tdwmGB+H9OoEap8WTprBCT2ELOrvcQo5ynnmId/7x35v6Pi5zDT3B9hmVkCvWUXf8WiMBTEcXpjeL1bTI8wa2CkRJIx6x86ugnAVIxlRucxCQCpHKPwxiOCmonPRmHLRECsOakbMorhL3JIncGW8QSXMGQv/rQVcIbLcesFoH3XEu4T3tcufjvenzRi1iNuibx+NYOVFe+MajtACzqw46ndIcDqSadMUcSTxsyKbMN66QNSKprT6iWxTrlUPrNISLxd51QeicWlMenoliSfpQDPMvItQQ8qUcuqmuNdnVxn3vROKbEsnBy0Jtg6TzPhnVK490dzC9L0O3TBEIdQoY5gyfMv+M4xqT2YnGR2V6ndb2XXsdcxfNxJwQRFM4axwyc+zisFPP4UyU6BVuOQAo8wWXEn7GqYCFipVYkV2Fjt6y7rOYvKtNT3ZGsoKBCaOoytftb2En8JWacrO3Ykgz1ormGU4m7x8ghUqKxtE9I7KdiY3+Jk6tazSshDV6KC4wr80hlCByCHAFT4slgTFA9QlIk9VT90IVJ6yq5O5g2Wx3NVHbs5Uega/mUmA6
 oHyoQ6bf
 rtfAcXLg5hOLPdw+Eee9EETZusGpbyadpuYzW+WGSWsmvPMirvJ+GGqzcmAozzOCQ4S8B89l0ADroD0x3v41t4j6lxVZaKENiFswkKDy3WMGC4TTOvb048M2LRZD3MNq/ynLuqU+zARF5JwWo9RJqnrfkpSVXYdXc+g28HFuFZzu2dm9N3GxstOhUSt2NgK/6P5835JqIPX+8lHhraZBEfKS72orBVmuirmFkRcrxXxnOgtK+Os3TfKvU30D+W+F9pf8KxrRe7yFJpiQiZvaagr7p4e8XWM2BATxxBtyCo2ewNaH4obOJVsoLk8WabqhCCbhn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are multiple places in core code that do open-code rate
calculations.  Use mult_frac(), which is developed for doing that in a
way more safe from overflow and precision loss.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cd2d7a8e3fe92..4e931f7380477 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -665,7 +665,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return nr_accesses * 10000 / damon_max_nr_accesses(attrs);
+	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
@@ -1722,7 +1722,7 @@ static unsigned long damon_get_intervals_score(struct damon_ctx *c)
 	}
 	target_access_events = max_access_events * goal_bp / 10000;
 	target_access_events = target_access_events ? : 1;
-	return access_events * 10000 / target_access_events;
+	return mult_frac(access_events, 10000, target_access_events);
 }
 
 static unsigned long damon_feed_loop_next_input(unsigned long last_input,
@@ -2202,7 +2202,7 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
 		numerator = i.freeram;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 
 static unsigned long damos_get_node_memcg_used_bp(
@@ -2235,7 +2235,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 		numerator = i.totalram - used_pages;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2265,8 +2265,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
 	total = active + inactive;
 	if (active_ratio)
-		return active * 10000 / total;
-	return inactive * 10000 / total;
+		return mult_frac(active, 10000, total);
+	return mult_frac(inactive, 10000, total);
 }
 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
@@ -2309,8 +2309,8 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 	damos_for_each_quota_goal(goal, quota) {
 		damos_set_quota_goal_current_value(goal);
 		highest_score = max(highest_score,
-				goal->current_value * 10000 /
-				goal->target_value);
+				mult_frac(goal->current_value, 10000,
+					goal->target_value));
 	}
 
 	return highest_score;
@@ -2340,8 +2340,8 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = mult_frac(quota->total_charged_sz, 1000000,
-							quota->total_charged_ns);
+			throughput = mult_frac(quota->total_charged_sz,
+					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-- 
2.47.3

