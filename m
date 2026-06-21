Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A974CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0E66B00A1; Sun, 21 Jun 2026 11:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C976B00A2; Sun, 21 Jun 2026 11:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC8A6B00A3; Sun, 21 Jun 2026 11:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 984C46B00A1
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 187CE1C2215
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
X-FDA: 84904375248.17.B21C0C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77843140006
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iniIxnCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvLgUJHE1vEAag5JmbsfYlxb2tTaH8mInR0sbbJDVgE=;
	b=uCmqGKIGynHiQsMimEeFvlL+m4DPmVBjSVwaC2R4AVZN1d9vfqoNieKUYNlBxjjILLK8al
	Ad+B0kT6iEsuIGnvXqLQMW0AA1GdabhDZlM2C88aDjXBvMvGxwFFAdcnrXmRsn2OKR1GmJ
	7Asj4ML5ZgevHqrEkekndIcQWg42x+Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iniIxnCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057462;
	b=S7OK8vk4rFYR2l5p3FUOILPYrC0rUF/Yq7u7d4x6WhzQBLfnnmOXHmCiu22qCMp/q7AnB6
	fxK+kxV0RFN3E/eGyJmhCVUQTEusxkF/WeQVgbyVnacwBYLiszTqJVIC4ktSUIY3aiuAKs
	57wshYl1vhBl9CjbRuQg8PfgW36ImFU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C551D44501;
	Sun, 21 Jun 2026 15:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A81F00A3D;
	Sun, 21 Jun 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057461;
	bh=uvLgUJHE1vEAag5JmbsfYlxb2tTaH8mInR0sbbJDVgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iniIxnCW7I2cg/mgubwoOLxmr7ujOTiYB0L00EXm00LtS/jdGIwYf2fjMPi+yEQwO
	 15kmNcYavkDLntpqyI8wOH+VdEcMMf0zSzFfe+g89Rn2XlYz8U5viJzAxuMrzPTEV9
	 g9uZh1ZjPeZcxiXm8X3lQplJvxn45Pd3HY/aqqZRewId5/bYx0obLt+SEV3u5M8czn
	 cFbfg7bnxvCrNDnyBNgNc6VejnLTQAKTZcXaEusvq/rSEYL1CeqdiEEt3Q8tHndQKJ
	 Q8gZ8Wl+3ww99i95tOc6/NhvQ7cKjXQ6zJHIvFpzVew4uVb1djZZpXgZ5JtasioM5L
	 eAFNj6wXGNd6w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 13/17] mm/damon/core: remove attrs param from damon_update_region_access_rate()
Date: Sun, 21 Jun 2026 08:57:09 -0700
Message-ID: <20260621155715.87932-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77843140006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ndgj7c4o1r7i98uqif47uz3b3em7gswa
X-HE-Tag: 1782057462-601574
X-HE-Meta: U2FsdGVkX1+8AFMIwjOsDcpqbIcnee9qZme1jD/kw4UgQA1uULVNwBjZPlIQHsG+198B6XTnqQ/CBzZErzDmFDdNNF7toxIqgs1PTEYTFHfwpkx4N/V9N/08gj4IkoxRskQnWSgzRSp5j4wEGGxrXllXaznEGkRPl7LCDIDc5lGkO5Yjb/dn+DzIHPKg0OwfgiymM6OM0rzNSYRo6OVYkyj6kcqjoKbrvLniKnrh2d1/TrXRUKbtuGilhaAfoGGOICTQcmrdb0U8Nkd8mYWiBhJBKTs8TFkXETFxP59lys95VTKUppJyQnr+Ik/7TQZve53qyEggIpdxKWM+WCKvccQrEuXy8kqHfpGTi1m1jAUu8SEC7RqYmEXFZtnX2ecQ8FDbOyR0fgFuWwLE5pWWAwLq6rE4K/roNIoAW4HcMWgMAk2x+FQ921zkbg4Cl35jRsR/JREZDxeQkea+7F0XpgXFYg9n6cdhuVGP0MoBLo2pC9J89RMl1SkFbgZfmhY5BcZ66XO5WzSFXCc7Ry+ZgYB+ej3RRCJiMDtzCshut9KW7GX5usPI32BnVMV7rnswcUbEfzjNPxjME/Cl/plKNj1Jn5nqeqqv/7Kc59FdWRZmPRy7v54cDh4pPSPoq4b4movOW9lQg0Rt0RsoguK3IVfWWnLM1dNFB3gEpVwnL5fhpkzlniIoaUelnpdKNGnzIQhrIG0ZZf5NRWDkogd9zpneiN5l2CueBF6EyCzqpQsJVBRWYg8DwwX3fZdlnfi1SO53RPrqSqPs4mFSXy//ARqcQp/1QeVyRR/w3k67zRtAB8aWJIDHHMYz3EAILTUcH7UM87ufXDCm+Di5t+SlIC2f9ON6swVqedKkV2iZ5Nwpl6eOBoelevJl89xKsLPbo+1e1uK4JzSFRSuIAj/jSrDjVeTImKyvkHu/PlqKdzuXW0739p3paZEC7S/vMz5P6zNX6na95d0p7sfLQnI
 fbbJ/wko
 W5CiBtK4aINoUu43QCog+f0tPzt75S06qA6UIizDxI5ozAxX++lVb/TmkbyHsy9kEVzxh7OG1hXX+jm5gDESYcUJF84KSmb+/k7rNA4IZ4e+CtT82oJk+SHcoMbTUNVKjytCxTrZ6gXooYn2WYJYIs7Lj9m2KJRAIlQ7EjgD0QovuDRUybdCCLgwtb2riN1TzJoexLgnZyuoNg7VXj9RbXL44k/Da2DQEMeNXosOFlonpHG45iYlZ+QYjuL5mN2m1D0F2qouYbUQAGULcSiX+gKT/vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_region_access_rate() is not using attrs parameter.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 +--
 mm/damon/core.c       | 4 +---
 mm/damon/paddr.c      | 4 ++--
 mm/damon/vaddr.c      | 6 +++---
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 55a743d99b567..a09ee8a09b5af 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1018,8 +1018,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs);
+void damon_update_region_access_rate(struct damon_region *r, bool accessed);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching, bool allow);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index c3c8e83234011..6b36e17660c05 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3768,15 +3768,13 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
  * @accessed:	Whether the region has accessed during last sampling interval.
- * @attrs:	The damon_attrs of the DAMON context.
  *
  * Update the access rate of a region with the region's last sampling interval
  * access check result.
  *
  * Usually this will be called by &damon_operations->check_accesses callback.
  */
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs)
+void damon_update_region_access_rate(struct damon_region *r, bool accessed)
 {
 	if (accessed)
 		r->nr_accesses++;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d0598f5f26882..db48ad274b078 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -93,12 +93,12 @@ static void __damon_pa_check_access(struct damon_region *r,
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = sampling_addr;
 }
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d271476035641..2e12cc628fea0 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -503,19 +503,19 @@ static void __damon_va_check_access(struct mm_struct *mm,
 	static bool last_accessed;
 
 	if (!mm) {
-		damon_update_region_access_rate(r, false, attrs);
+		damon_update_region_access_rate(r, false);
 		return;
 	}
 
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = r->sampling_addr;
 }
-- 
2.47.3

