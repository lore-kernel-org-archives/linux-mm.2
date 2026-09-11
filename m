Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D069BC88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345646B0092; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD2C6B0093; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BDDC6B0093; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFBDE6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EBAAA5465
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:41 +0000 (UTC)
X-FDA: 85199709042.02.B94DEF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4465160003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZtjLo2Yv;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hmPSIzi4KB41ZqDb3eohWI9E1LBjoQeneU0W0fngWY=;
	b=PxF5+S/VvW0rLBaIweWK24jFFppiez0m/s0DSshytagpPgZr0Utcs3Cxw5dEAQ4XBkPciZ
	rT+kwCgiIP5NUadOJe3Kml74UHXxsqe2dJ3/qcH4Flek29q4rahMl0O5EfUG2/gALsq0g4
	IKYDVVukON8ueWrSy5elTyDbfX5Zbzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089219;
	b=Kl4Q9CEdwY00D7VJIjAPj9lRjqjInqiZHrD3oOTojWpLqRZFtRPcwoXKOUxH6lIUy4xoKk
	m8OtPH/WKs5Tuh8mCqUrGZw+Zrzix0aFoBJf/wRSgJKFFVgfVQu3h7naVnGCBRJDIKFYoF
	Fztntz2Y/6/N3JQnjqtNwPJcNPDKS3E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZtjLo2Yv;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23A9B60209;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B861F00898;
	Fri, 11 Sep 2026 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089218;
	bh=4hmPSIzi4KB41ZqDb3eohWI9E1LBjoQeneU0W0fngWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtjLo2Yv5sV7wQGr9awNaKU+AZoPjMwjjHYtqeQhNhzXwrN0xIkYIGD3jtcjgCwAC
	 0opaAlx60OVRwcV9H48GXgSH/GpKI91OWngLNM8U6dsldwpsCLuZzK6oyfv907zeHj
	 OzRhLdyQ6c6wGVqDTUuHIx2ZAcMOqmYugqQIFjhZfYine0lh9oF3EIlyAKi3oLev8L
	 MDgQkpzc8raayd2SSvq50BiOf0YE3gLoWJVds5QAegHQaixvmrEYwIzyIfBwxbo9aw
	 VF/ijcKzptmlMU2eZIWy6aGygEDKrEkQ8GpGBeD60O23S3CazribL+N8lifcdrLahK
	 erKMkCLIzuVJw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Thu, 10 Sep 2026 18:13:23 -0700
Message-ID: <20260911011330.93678-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrdbt8q5ffpxie9b1u3ujcaufie76czi
X-Rspam-User: 
X-Rspamd-Queue-Id: A4465160003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789089219-312898
X-HE-Meta: U2FsdGVkX19s/v8zDLfmxKMYw67NLv1tnfbglgkGu2cR5dykyKBUBnU/3T/VH1bgR+oKFxQhW0rjWVgRQpt+BJxoKmen93qxWaMiC0DLT+hD4EU4iOZ8S1Jfx0E7VItmccnxtXFRRqKgraeNhQy47go6BAmy22+aP0cxrbAHVwIsxRVt0FPv/wmto5WP2KLzwfrwgXZiJMPQteSes/Il5eh+1Xz0yXnBiJD5lO8jTFWBcujrJYs5c6R53H+RpBALJNPBZgRqRtoZBSjc5/8xi6rSbje5moH1SJGFcAKR4xWOlshr+EVCqWwktxCbgHwVjcYGje3+JM549eHyo+/N4+Iz0HK+CLom2NoRYS4OcsraE45xWK5lxoW4B84BUiJnnc6Eyt7W7zphC7kjei3JTB0TQOY47S8/BG+BkNhdHNP87/LaDjXOJfGByp5iyYFyKwO4jikK/zSnjCU7aMx5B3JWjXAb9LVkL2fVvTQW7WQhHrEQnRzocALAL8CKltDSbmklTmVXSkr8kEJKb5JH3MXbR5gGc5FoEjTmj7Svp6X0YVSZlhfCz1QPV4OdjpJ71QiFPCt/DozJaQGGzAy8cL5YAFa9tJ/pqC+8pNuWOIrvlj1l40ZxO+Zk9PKYu2bBEHMfbtrSW7RXh7lDSNR2G4xnl8wuI+xSkEngg2oV+4znB3DtxgPQa0GNxwe0ed2exRcKkiWM6ft8rc5qq4tzmMFhCByH+be7xHvLv/2LYmguoF3Xz0MQbR+6Dh4xWcsZbtbVYuXaoxKuRtm/6y42QawVE7niAnFdHdyuQY4UghdYLwtT12pPasy68Lmci/BtWrJijDNSXmVgx63GeDc4iQwP9zFY2EHDFi1HqEpsHndJb8CZ5boaWENHNMFXjOLM+BIk0Cy8QM0T5OTYaUdkuZWKzJBC5we+qr3J/NaKXw4kWr8CBsvtzLfJTy5PvO6hvIZ6ZQ8bN7yK6wu736M
 lSKYfKwh
 pnI2/fS9j06YmIKd7jk7Bo4aCbVazXbqcbAtpEqQnIiY/Fn9f1dzM0UuxQiZTqd2LC/gN6OHDEeDfOH5T/Bxvig24stz/hRquKJuGfxJyhB9OUtXBEqlGr/1dYFEGReOJoR4E/njxWt4FeRCGupXIbJNseOaDeH9UKdvvMOJhgM4yjXxUjU17cYcUJp0yvqyXnVE/uJLUujbdPQ+HUgHddfD7+BmSpyGF/bwL5oPy3Q/BygZg57sC7tTc4mWwsJVs66Ho0IUJZHHOgzaHbv4CiyNxhQ==
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
index ef99ff778ae10..4a36f344bbc7c 100644
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
index 06cf2ab7e97d7..50e0f9407db2b 100644
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
@@ -3456,7 +3460,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
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

