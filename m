Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71250CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34176B00B1; Mon, 22 Jun 2026 10:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE48D6B00BD; Mon, 22 Jun 2026 10:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB296B00BE; Mon, 22 Jun 2026 10:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA4F6B00B1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8163A88BD9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:07 +0000 (UTC)
X-FDA: 84907763094.20.9A1FB4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D382C180008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVGWVwdo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQDP+fLezsfpK2Udw4OPbczVKLHgO20AD8woKXU9dAc=;
	b=6FxsS9YmSWdOcM4edIFqrpy7IOgsxUlylCw4Ao8Vv6o5Kv8xGxa1pHQxFWSjxUkPY5ZAug
	LjQv53Msm1OlocU+MuJh4Bi42FjqgNVX08li8CfPOjZORozZ1WctodBMVNRg+HdaaaEMe6
	xWO+6yTKHGcLvjFU3SMygawT1vedlN8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138125;
	b=r0eLO4LZKcvUusY7QQA/MByQ4ft9nDVK/wjWMkxEtqnXTXp+EMEKWmaH/AB4Co3DSp2bPY
	2bZEA2YB72cc9AvqD5CoaDr+aNNQ5EaAkm6cb+X3IRlfl1RNitV/4dWM2ASATt3bmPxan8
	qk3//7zu2/x1dguzWFU06lSamYVWdUU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVGWVwdo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 738E6601F9;
	Mon, 22 Jun 2026 14:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828461F00A3F;
	Mon, 22 Jun 2026 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138125;
	bh=jQDP+fLezsfpK2Udw4OPbczVKLHgO20AD8woKXU9dAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVGWVwdofdbv9/P5rtpzV11I0NbBetnrmSb4rdvw1zVHFFo1SZhMbG8jkARFtcknW
	 Dej/pc88igKEkbyYJ40P1pUKFF6MUx4zGq0RS7mzEKHh06tKjI46t0+SKBfqOFxunF
	 I6f6mw7R/I9tjKJk7ulcpaIZANpz8552HPFlSe+j1HL+ygFRpMukoBvHSh3xtk2S8Y
	 MrXVW7HHLPwndEyi8qxvUy/tat0Ua4nCEZcujSPt1rOgJrIRAAw9VysdCPFyyfnWMz
	 WpzpF3MTYc2DPMxLG30bckQ37rjb4cC9ZSKWQq5Rr7jeOFHifGvr5+ctBaoZ3YiX7O
	 kU8iPdHYQTjEA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 14/18] mm/damon/core: remove attrs param from damon_update_region_access_rate()
Date: Mon, 22 Jun 2026 07:21:34 -0700
Message-ID: <20260622142139.30269-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D382C180008
X-Rspam-User: 
X-Stat-Signature: tcdgsejykiimcyrfsp5sgjbxeiyp1dx5
X-HE-Tag: 1782138125-31622
X-HE-Meta: U2FsdGVkX18DSe7DqxDNPnIG9j0ptzavriJdM3e4uwCwfUenipCW6n06+A9yUvw25a3fMXv/a/8tSwsq05bYlDklurJEt4sClHLXqFZiaTZVCNk4kutXwKltdpeQjideahTKPJguWuXDaIxi1o7rthyJpaI/ZutG06z1oKDYNo8AHcWUHZPEnNpQAvG3hTAIZQngJjjWRqZxElxIKOjztgnl9dE/KUwcYHak9l3xIrQ5JADXBIkRRaINCUfi/ZV0OneKv0E/WomkzeiWh9DaRbkKUsUSVs2n43Q0VedyQKduyrQ13ERNfOYeE0ahmmzZbnNCDn9k2fNS6CAiZS+CoLEqL8PQyMZIPheahIIm62DplFlajCKwiYzwar0cfZi/0mSGM2OoGeEkZxw5bNvf3rDjGSqH4NAYNq6NyPwhHCGcOk0O7Caq7HQx2I4rE0TonZRb3aA76J0HJhtdbhKBBMm06BBz5QyWcNWIFmSGJnryxEhEo06PN7YklsSqtfK8bN7Qmcv9fwPXhjsGe2umMO4416GQRxTl6zjdE6Qj5HzG6xg4/vGf4bEijtQNt5t3d+wwzslQZdSKeh00MTArJcYfkPMMHYEeMuDvJRVk9fFNLHlvMhXiltbXTFzyTYG7BQkJRIhwai10RyRXckJll1j+LTisZ7ee/ZcFtskCsDhpHHhFmtvRRiV9vrpF9zAxWkUkL4wR9EG6RTDgT9aejfBPIuTYjS7yvTtnb1o7mcQz4L7u3ZjPFZhy3fkOVMonvWlUXie7IHyQLL5oQEdDFG+l4idNZCyTI3sOjTsthWACPIyvikIY81rOeiU+QB/RgH1ar6cY+ObJySQIhipTjT3oq4UWIEUFjYRPPJYbD3Z2fmvtZMACAV9OeX0LfKHJsaoLofYRIOXh4qr6z3H26u6BXSjp4IXe4iGcNfzymC9Hq/3fAxaXHB4qvpXGub/EuqzlP8HWXz+1AZ91d+q
 cc+QoowR
 /tTSVswny0Wz/bjNBO/LSNb3ERTMg4YAnONJxLAbSe0NImKHRjsjafkd0LGkmlPiASkud5k+9zIxYEdoC2xaG8AqRn9HW64k66eQseQWou2LDluKAjx3kE1RRC5yN4tovee1y2ScWJ3MKtwFi07/6+CLX6ucq5TQ5TEz9FXaa/4AMZtLhfxhZbSwLMZnBt0bmtiBReOLd2ATSUBWsk3q87eE4K2FMZ2YyNbsxfbgI11u74JqNIteMpOygbnGSDSKeYWLv4wAelauhQgqURVMZ5aJMpg==
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
index b095f053c6fa6..560e1aca5ee22 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3771,15 +3771,13 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
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

