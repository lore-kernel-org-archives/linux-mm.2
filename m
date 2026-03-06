Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BFCFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5E36B009B; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16346B0095; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65BCE6B0099; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49B366B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05727C23B2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
X-FDA: 84516022332.12.85BB0A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6691040010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aTwBZS3Y;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT3wkQ+yDZgUkiEO2oUROt9UUUJDhDzzxTnyoV1IZrI=;
	b=5LCR5xegblejVxkKDSaIyPUFSi1661gPIhH0nDlZDg8xWEvOnC3sE2qh9XbLN+wU2R4q88
	UetCFHdmUoN3FKLoeLSlk31mj2/nediDpS9byYv29YTyVKfIMSi986MKq1z1QT1pJRfoqM
	pjc8EzcU3R3uHlG3XzPzbs8tRdo/Ke8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aTwBZS3Y;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810964; a=rsa-sha256;
	cv=none;
	b=hI5zJ3fMaIHm9Bt3CxE07+R/ajT/V6v9J+XFQ8Euxnd8xKlwsnMK8ZW3daIDTOjmR0TSuG
	ZCShJp52QaGYCwrVvBveeGdSlf7zmqH3BtVzYyoQ125EQEOnqBYPOndB00Tbv+LLJIKpx7
	F9t6EJFv3sW5F93QnoUdIU01+lMAgMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61C5644560;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE2DC2BCFC;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810963;
	bh=nkxfWGkCfA0dtqbKfL4Ap5CeLN1/sVBbqbCyhGOAcDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTwBZS3Ywjwpqlqnr8nhk08L75SfMhDHB4WzT16M7NuYTrQJIlaUTKZfBDOiS+pw2
	 fDwtv8mmP2D7r1Gou5jHf2qSpNnywfOIrhc+qV39j/smT78jJmZ5GP6JN2OkvvMg9a
	 MhSVsWx2x8lXbnKH1yactJ5jKHF9JPCTBAEvbbo/N2soBg4JMToN8dfzXqbfyS+uhb
	 K1gOBXizUYdI+3uoXPA82y0eZ/a5vuXls/fj4YeHucWcJ+4R9emUb3uj3OleMaZnZw
	 lHxNbETjbsa6RDapvwxLwIi3sqOwV/+ItxDiYIETwvmssFOvlRCvzWdJorGaMh4PSX
	 K714SKVWryJOA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] mm/damon/core: add damon_merge_two_regions() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:08 -0800
Message-ID: <20260306152914.86303-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6691040010
X-Stat-Signature: rem4795rj9b1ed3zspw1mzhfanuigbap
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772810964-102289
X-HE-Meta: U2FsdGVkX1+WZAG8Kgw6/zg+2wZ9SpiI33p+GVLVSBfazI/f7j2i7ZOqQk6VpJO4c/mAuZzMPRx54STcGFilCdDZ+4l/NUkgRQsxPrK0IiRST5SN1ItPeg9TUH1NecVHj6sghmrNb6RB7Ypt/9gGSlU9nqsJVtftRnwSCh3aIwnHdgTP0OlQrd64jdWFABiLumPA5QU4w6a3/vtgI4ewlTlWganFTjG6eeB0stYhFn6Tcz1f2pkf9jmtYlhbfeWBqOMhQ+HAVco0cemTCY5jSPo1CmzSxlkzVu3LY+T5G8lP3rc8UByN0JA9kbi0LWxKsEZGmluGw1amMA6jvTYfT1T1/D3RstGh1lxecWyaYZvRSrCyk32bw4FUvbTsgnWm6PKZ/w6ykv8Gh9Bi84E9gWWmTkR7JYdlMNY6Ma89EHvrxmCRJf1fOmz9oCAJKfBZbHOdpb8/sPR/aPBlVPbzO+dgvE7UmcyJqaRTLnBBpecqvf+pNNtNrN+iN3S7DGIdMBe/I1KdfMmnAxkQkvoFRzDrvA98ZuACbwQxCabF6mZwT4Lby+5mCqCot489rYMtxhKwf4b5M0zq+PqLeor0KKqPTbc6Z+oWsluCagH/J0eF2YlHeeYNVIuQOX91nJRdUoK/Nw9sOYhcGZpb5lfp6bbpYGy/VCDLrczhip7ZEQFzXlhcCe2747BqjMEjq8vI60jHSQPKIw+MaLKgc7vwmzW4G/6PxGpXrpU1LnF7qfOlEm9XT3XudXhnsYB2xe5rk8A/a3/RA9Ox/GN0skiER+2/YQq8M9MJpVA2BI97ARncnRMiS1EYjMKupzlTxypSl/nxCyR017cVNo5cvXH1WEAOhPMsKbSBdgy2QNesgUs+97APqprf+F054IvCLdfVKmd43SruuqjJE/9niBeW6CIfefkzD9JqVGdCYux8h4tyUqqhfyjifTCrpDeCk2H9fjtOY/u8zUq05z3GQDh
 /Cu8a/1j
 NnQemoeDclNZqwCaGBLP0T1GptE6/FwHAt9gQL1GrnjlBoFb6j46pkaQBu0h9yU4r6XtafvLuhVWYLrVPEVb2lRQkO2dwXCYMDBzuN94YfmXDTv87kJCRL2hC3it1ZsdHmnAOFHkXTK7PzpctJ1AqaYu8acnL0qUOoldcFLENlQmRig4nZ4jMFRgvv3h3rThGVyG2pC8gkKpvVGskSSw50/tbxyJpcuOAgvtMLxM0z/XAWyjIcQPdN2umYd+LoOGg/Auz66J2zIqNci/Xs84sS1EaYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A data corruption could cause damon_merge_two_regions() creating zero
length DAMON regions.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2b5aed89d449d..8a3738a17cdd9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2473,6 +2473,21 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	mutex_unlock(&c->walk_control_lock);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+	/* damon_merge_two_regions() may created incorrect left region */
+	WARN_ONCE(l->ar.start >= l->ar.end, "l: %lu-%lu, r: %lu-%lu\n",
+			l->ar.start, l->ar.end, r->ar.start, r->ar.end);
+}
+#else
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+}
+#endif
+
 /*
  * Merge two adjacent regions into one region
  */
@@ -2486,6 +2501,7 @@ static void damon_merge_two_regions(struct damon_target *t,
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
 
-- 
2.47.3

