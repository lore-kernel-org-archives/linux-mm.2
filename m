Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7279EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D44C6B0098; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CC16B0099; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0066B009B; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C643A6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65DD7A0275
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:28 +0000 (UTC)
X-FDA: 85187609976.11.D2CC841
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D78FF180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9vswf1A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FAT4Syn5OVsshTngq7d1ZSJqiyBWTczvDtXpOYV1m0=;
	b=d8JQqiE+sNZONGz5VgkmGsUtfl+UfZ6xM/ybsny7bBJwQ7hTOn+QfPz/x0aOnkGVAfkSOd
	uVz3bjnYUbAB6AundiF8yeXvtKdTcQ4OVjWgRrihvMBEK6PO7H4DsAWt2rfNA9646VorW0
	3uBKTQppL5sNvZ/FRaIawmOtLIQ5Rl4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9vswf1A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801146;
	b=wnajlktA3yWysIwsp6uD91+5Yryq2aqmeC0RDTRAPWBa4VroY0aCwsh/z0si3BJbrkKjwQ
	Ayzk66RvcAHDz+GdCjCYA77w4fvoHEA1T0tW3+/HEotl5atVnhQRVcejjFVx7OEkygS/Ye
	B5qC7gKXZkAtLQmLz8azj5pSs3Iennw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74F5060213;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041CC1F00A3D;
	Mon,  7 Sep 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801146;
	bh=8FAT4Syn5OVsshTngq7d1ZSJqiyBWTczvDtXpOYV1m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9vswf1ArUYK0kWJ5FlvAxoPeBNnIFtNV6FSVdcGz67Q7wZ9yQZfq9pUQ1A4mMGJe
	 EFgA0GH4+c1ujjefiG+5rTgqP4Iwbd37nQ/utu7ox5ePa05xvZ65Q002IKWLC1sbgu
	 lAOnaqZ+66vKNYkQF+se3Cua6vP9Uxt9QWzDwOFtqexnZMp/1yhM3prkG8p+KKk0ES
	 iVo/dpizr/mSfZ72gpeNWmwc7zaXC1sK5Lk8qQ4+RoAj4Q/uVyP9s4SKNpvOH2ZhtA
	 bb6XGQaGS/bA4Pf6HX+Dffh6Gw60HqIZscSfyg2gkSwY9Ik4YutyeL7cLxo8n+V7mf
	 /V2K2k/tRaasw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Mon,  7 Sep 2026 10:12:11 -0700
Message-ID: <20260907171218.101430-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4149nyaanq5wmy66f81rwwszbehz43i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D78FF180005
X-Rspam-User: 
X-HE-Tag: 1788801146-991154
X-HE-Meta: U2FsdGVkX1+8F3fcVono9Swg7hkA3lwGygc8s+X0sVXXOGbv4vBesGT9bOuixUIZK0gUY1QJd5Q9vS9Zd/EBi6GvdWV613woZ7Ks93BZrBv8HXjaAnNFN8Uz3X6KWyAF801Lcb8iG2dB0rSytUhJDndtkCcHAsRQAM6WetaGYm4/Qf8m2oDxSMjE+BniLk4Z9eb40xc2Rv4onT6ZdU1bqvaB3BGZ0Fe3BbEwMy9IWZj79nVCT/JMV2PoltaxmegQxUrwqg3VTK2OBgsZ+mD28HK2KpKtkyld7XXymSz9PNLBUDKNNcbFCNxG2r/HgtcsYhDe6KQW0lhVotepd/z5R7y6KMc4ZUkr3j8Wyp6etY8HnC9MnFWJD5+id5LznlX/CrasxaxJSSf2dIIrjefzxshszOag7oDgPU20j8zS2du2Al0P5waLhhzAjzNSo/QezLO4IsEMkdW0Mr+JorTiMy2zBpAin35BEKgHNEFyzU60c0q5Rc1NQ057Quv/0fWuLkxC4H9Km/wOtCFQ2NILOvC+FenNx6HWBqnxBWrg/HbYCJYujQYQsflIefvRPoheLkELJiC0xjmmFyOieSkWNC769kW4VtOsdDvpK44KC94SQeE5VNlkIVET/L4bn+yrqh/Y2epgN+w+wUzBKDuuwaD6859grhH5Q2cOjWOBZl4cPH+sbvbDMA14R5/1Samij72k2/XIG2MtbvBmzQK12cOKROCKbg/Ji9vzMixbJZbW+H1cOVLEU3FtT97rTXrPCd+kzpzVrKLcM0FLmwtSSE1FeeIFbg8LI8Hp1xnlJgOkGn3KCCI5C53B2Zgq9DrmVWQocyQf8lBcumycaY0tArbUb6tupDiluxS7RemBEuXVdrVzyVR7LOZgE2W8qas+hfPFR5v8KLvg85C5TmsYbl+xhsFjy3KSnk115I9sZEAizuh6ln6KLzLSfzAbtLLIrZ4+AdX37++xRLbCnF/
 G0jC7VYl
 BCsP3f9jcktN31ilNzjzOdca8MLwxyctbAcfZDpnY3cfx1/nckP44i6kHNE5IP6ptsYye2A/67C2gc2U+FFVtZ/TE08bjrFUudy8Y8rHfGyVr4odydQU4GYqF6yGNiKPelIIsLIv9KGo9x4WQSDDbjGYPiQQR3zOt+V4Pf2z5jA/ZPzGi1hcGGu0NA5Mew5ouaKfdy9wAVi99FTMAGpCIM+V1ab/d+CvI6zW6Pblxlxhv37qwX0ElKQa1BIRj31dbZiteMgmMln3KVvt4S4nNFQUoaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() is being called only in aggregation time.  In
future, it could also be used by DAMOS.  In this case, since DAMOS uses
its own apply_interval, it could be called in sampling time.  Then using
the not yet fully aggregated probe_hits could result in suboptimum
outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based
on moving sum to prepare the DAMOS usage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 8 ++++++--
 mm/damon/paddr.c      | 2 +-
 mm/damon/vaddr.c      | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1deda16bb70b5..9fa99f92a2e94 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1073,7 +1073,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1752afede01e2..30af5bbcc90e7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -469,11 +469,12 @@ static bool damon_is_last_region(struct damon_region *r,
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
  * @last:	if the request is for last-window aggregated probe hits.
+ * @mv:		use moving sum.
  * @ctx:	context of &r.
  *
  * Return: the weighted sum of probe hits of the region.
  */
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx)
 {
 	struct damon_probe *probe;
@@ -483,6 +484,9 @@ unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
 	damon_for_each_probe(probe, ctx) {
 		if (last)
 			sum += r->last_probe_hits[i++] * probe->weight;
+		else if (mv)
+			sum += damon_probe_hits_mvsum(i++, r, ctx) *
+				probe->weight;
 		else
 			sum += r->probe_hits[i++] * probe->weight;
 	}
@@ -3467,7 +3471,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
 		struct damon_ctx *ctx, bool use_probe_hits)
 {
 	if (use_probe_hits)
-		return damon_probe_hits_wsum(r, last, ctx);
+		return damon_probe_hits_wsum(r, last, false, ctx);
 	if (last)
 		return r->last_nr_accesses;
 	return r->nr_accesses;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d7c81829445ba..b8f4d28165dd7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -202,7 +202,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 				folio_put(folio);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 	}
 	return max_wsum;
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 9a38dc89a156e..4aecf34e39be2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -704,7 +704,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 			__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

