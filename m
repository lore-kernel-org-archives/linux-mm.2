Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC33606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGRpdpNS
Received: by kanga.kvack.org (Postfix)
	id EDF746B05B3; Sun,  8 Nov 2026 14:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90376B05B4; Sun,  8 Nov 2026 14:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F616B05B5; Sun,  8 Nov 2026 14:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40786B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E1BAA04C8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:56 +0000 (UTC)
X-FDA: 85412997432.02.6B8556E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 885EC20003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGRpdpNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jg6uYRNhV7mTrgb91kiVKd41vY7ff4cg96iZM39MthE=;
	b=x4t+fEXvXJyvvoWqoMVmLsNkentGt1OikBXF8o4ckjLAKmda4LD5mtYm8D2iTpCNMGN88/
	w6UaqA+8uSbPWG0dJLxxmMdNEQKLAPGLGbrzeH3iHev2dTyXK7J01e3HRhx3+UHKQaJekq
	FybzQGx6nlLz2QkwoECa8qIZl4SOoE0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGRpdpNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167514;
	b=QFBW0iyBwfSCwNnMw7DF8x/Af9D0XQqlWXRrQVfkBczFi06XvjrdpgmFF8cjqg6A1vvQ1m
	w6OWMSOIobS3QdCO9tiFzw6AE4DvsIrtcA3SBozkGBaOSLRLxi1Ns+J0q5fHtXYsZTBMnj
	WoPUJmJZwWmp50GCMcFOCvXQ1VzE8Rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D469D447D6;
	Sun,  8 Nov 2026 19:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD5F1F008A2;
	Sun,  8 Nov 2026 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167513;
	bh=Jg6uYRNhV7mTrgb91kiVKd41vY7ff4cg96iZM39MthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGRpdpNSlnixmFRcxOam5Xr9cd4WIg9InJNq8/OEj6XM7D6OI8m6OGoMVXRRg6d5Q
	 JaTM6vuG1Wx2S1p9lUf9Y6HBlmfEylhOhS0iFsdfTEpKL+yHtBAv4ASDR+eReHbMHc
	 8kWd6sXcQ9n/swYGctvmFS8jEYRo+H83apV7rYX8E8PhUah/rFi9AJqO+3KW4AqBdd
	 JIdrquJRl7TiGijHsuffQlopjjL0vjDTrrLEcYN9ClKFex0f6LWl751J87XIRP73Vy
	 oaixSZhwq+EXWCTyeNylOmasbCETMRiQwtiSsWRX4UYFiQxWPRMIrIatlCTZPs12o2
	 YXzU8b2nH6GaA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 11:51:40 -0800
Message-ID: <20261108195145.115792-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108195145.115792-1-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 885EC20003
X-Stat-Signature: dm97zqr8cc5zpodx4t5rxrc7esa6w7cg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794167514-813413
X-HE-Meta: U2FsdGVkX1/DxKh7tQLOtxrcA3UnDSY9piZR+Ti/7V6kezebcq3HJ+VrBnApRGaUi7hRuF9Tk/61zvcReYT2Fy/xgHsYBJy2aM372/KNacdSdyIFTVuUyot2iWvVw6/QEyCMPpiqofs+K/IBB4DkvM5bcNGNojS3zVNh3EQdXHXgU2NQAeHazRjXeJeHzNjZrZnz3P11jUOOquOejrn0dSOmw8mhfraeVgITEDMgPHuHfodgjpY7VjmdB7xWBcr/cV1mLjmgja3COGR7CpraJQWr3fBj4T8lvu9vBdZgCAuUgVniZfXpMaBsdU2tvwehUFJfMdmaWZJ4luLH/Zsa4hg7wl3EUuiUzRGozpMarFpvppUlVFif7ktHqJvIlY3t2rgNMy8NQR+6PjAlo+2MWpkbYmRdBJLg5QQ2V0nYeIjc74s4JpyKNRc0DRltr0cUzSovYM8X2qbEyV2i/Qzw8MxdoRXe4k4UU7hk56RtIE2rpJteM1V/aKI0If/JG0eKVAPW/zLFNRsnTZjk6Hg/Lp5QgsaJxYJzq/aOWAwY8y7KuZDnL652whhs6LoCxS+HDT4D4gfEoyjqRrLIv+ahutlALSK207nFQS2dC09/6FVlgwuCehanFBnDaVuIugY8aiC2BWn9jdp4K9cEXvC+1wz/gufC50ayXTu4V1nz2crzzGQMJIYL9k4l5TT+8OfmpoYbGdbV3cnih7AGHC8vpZ3JaDPIGuphfIaFjKC9nFTLYJCPb7XGImZQw/nt0mVdO6TmTJ+YimixQGDn7gblSRXncPKC+mZQXUg7p2B5ECqLtnLAHlJSn/ivW3fhHInM849VErJ6nrikSGCjmnr6eiaM2VnuBV0tNCyb4U99gGPCGydw7vCjbvCXnsPah0dv/jIGtAdcv8WUOlq1pKFnMnMM3c8q6wqSv6we0r5k6p+knJi5jQIdMSjGYyjUG2jR5hk5v/EzHEyLaWpRuVY
 XsexGI5f
 lHLjZBzF/Been0RRC5WbkSpS3spe81Knhfc8vxL3eDgCXPnmWhseEKSs4FEK1x2l7NcvtpMFt1iJ0QadDbWlaJ5ACd3FMVY/MvHpd2V5SWKC0EC14szTpbcbPsQ9ofrsyOsKpnRs7sp61ib0QKCBUd80WenwDEJAMR4anGJdDvQu0J5FFis+NqdiHP+L1u0aqf3vKE7xmHstGJ4z4+u0Flk1UPyotMZdRxvgvDHEWOOCgCar6CHFnhnaN13s5lljbXMztmnaNcaVexGftW1XQYYhSSfFp9jTbA4/6PSybY2UFKJMoK9gu27O1+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Patch series "mm/damon: fix DAMOS bugs in core, paddr and vaddr".

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory allocator
under extreme situation.  Patches 2 and 3 fix wrong folios walking in
DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in DAMON_VADDR.
Patches 6-8 handle extreme and unlikely memory situations that can cause
divide by zero and underflow.

All bugs are discovered by Sashiko.

This patch (of 8):

damos_apply_scheme() splits a region and apply the action to the subregion
if it is needed for not violating the quota.  The split operation
(damon_split_region_at()) could fail for allocation failure.  In the case,
the quota could be violated.  From the user's perspective, DAMOS becomes
more aggressive than expected under the extreme situation.  Handle the
failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set min_nr_regions
to set the maximum size of each region.  If it is reasonably set, the
transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

6.12.y porting notes.  Modify damon_split_region_at() to return
failures.  It is a part of commit c60874860762 ("mm/damon/core: handle
region split failure in apply_min_nr_regions()").  Without it, build
fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 5.16.x
(cherry picked from commit 90c2fa6adfed7abe0935506a43cdff3a05c1fff0)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 81d44e41de210..6ef77741b783b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1266,7 +1266,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -1470,7 +1470,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					DAMON_MIN_REGION);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -1861,15 +1862,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
 
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -1879,6 +1882,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

