Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D230C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517846B0092; Sun, 13 Sep 2026 13:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C80C6B0093; Sun, 13 Sep 2026 13:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE4F6B0095; Sun, 13 Sep 2026 13:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFCE76B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D2F6140889
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
X-FDA: 85209380970.20.3CE3386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5C9D1C0004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vp4KZOl3;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	b=02Shq/BPknfZr9mk67l7jhceDIO+VCqoUkzNz+UNYs9VVRstCC4Bj6dY/OcrduOaFEtFcC
	xZhFl3NxxeaLFbZ3oyPnzCkAGG/dAXVvNxYxnsq02Q9Qrpq0i+48QDYsu+oQxr7VVet1PE
	ZbEPbZ7X2nzeMCyN0qzP/PKalWbuhiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319503;
	b=1hs2j1JegEVD74E4kSh2HYnjS1yDVgTrjtQjUSI5s5ZeZu4LX/xmHntaN7bp3SYT5ac79z
	PHwuF7HrVQGfqoFU1oys8HoAauXls+EF8XGl+/O9FfrDYzLy1PDUfdIws66d6MG45cWTkm
	TPJ1byMxMGTWKfoX8p7hcYVxUDz4HIw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vp4KZOl3;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAADF60E8E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D24F1F0089C;
	Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319502;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp4KZOl31dlS71Xlig/awbyEcGBsaOfBoJ+8S6UPztXW16Vw4bjbpuqrkKntVm8ss
	 T8nGpBDS3+/5j9dkRdcMqgMO6s7KBndqZWWDcpWg/ZwDY3aq3TCBYUI+hF5X+BWxxM
	 b9mnYwiDxLRZ0NrfxrZXw3Vf07NoBazywfbkNtH/dYOKuMlkTZm5aThKBvGIrM1r+K
	 J0saQ5JhTpBXPyExoHEdo/nccOYpzLdWCYva1ntd5sVhiWhlDA/2NiilpDqzk8onrh
	 X/S71liwj/HGPJJuaGxwMWGSgzVtOGrL/ZqQI8mmRzU+IhpoXqrylo08U4IYOQhsN0
	 CgyF/vHt3r4Tw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/8] mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
Date: Sun, 13 Sep 2026 10:11:23 -0700
Message-ID: <20260913171133.102366-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wbzs7n4tngajhhti68ix49d9psrms63n
X-Rspamd-Queue-Id: D5C9D1C0004
X-HE-Tag: 1789319503-770553
X-HE-Meta: U2FsdGVkX1+l+q0BvjLdM0ZtrUbF5r42/Nphh9mQRcmF4kLza50Y18nM0IFj2b7Qme9yZ/CMnB8KF/elZF6rMRnP/Ys6M0EeOKHTKbqmIuUqHP3Hl/Ve+Cn408g1dQAjavy2AYktX/7jdzrK4sWHYNEXIVk7xY3tBRsWzKcu5AuzrcTn/wdmVv5FROhx9EQqw+LzYRLa+Tyh8sOxr7VEhl71eu2xFmhHKUboO24f1VfbJ07kJfl2kFsPLkrejPaXX1YSrhhq98W22NqkBVKUUL30JKNhop+HgdT2ZxRo4c8Rxj8ByDrZYe2Dxf+MTvX5a/f4nEUMvJWvWouVVFdV1NkENQrbXj2R23ugAU34E+NhVAcJcmDr/GTBOL85MyFEncBq6lr6BImYe0z/3B5N/ZuB1LubweWsPrE/qPHXtqw21VXfTFmMHhL3WQa+ujfaBV5rpE+AxRNXVM80CkFyjcfjxFAcHvmL1SJptO6892IjfEpF1WduXOOrGffpv/lVpPAaw2TAhbwDKFdmScAahWxocVm0IOdMg4lMaQYvZSlGkRNNI901FTKGQlaXQCtkEBCHLl2UJP7utQlC8c5zvREWUZj+IfHz5Ar+juSAU/KrrrMMD9sgYzHnr9fHqm9yL86hkAE3Pe+ZpwkelVf3W42U9+yLAQoa6YQojLTP0h4907HqYswMjQVZWa/EfLsIO2PqNpiF+Xn5AnTuctDn72+iXsQc+UdrskLO5ByVqPILbCD6fwWJ5zz7bnzjPX5yY+sCVcOvScrXYbOvx18Af8Dl+ghjPi2+Cihx3cwOX3CYp3j53H73E3J8gKjTr2mmE/XMer/PD5rCtDrCUfWKKpdOhe5Nh2tcOPyRXWJn1yL3khvLpVwTU3m9dFTwahggZETnZURqgWzmtKafFhcnd8+oWk5ZKUVy+N2GKI01oHkGEOYe3oKjIg8rrlKAeZOQx+aLLrxB5UKYuE5vEtY
 LEupsLG2
 ren2VdVOSvhLyffOLw9tib++ACORFKnAd90mlFgLgn27SjJJSdmlDzQHqgG9t4n1q96dQVSwfcgnKuf3D1yOGbaVQ4CkLaIq9fzwMDRp0J+9525/dMU8fl5MQRqj1sWxFZfDJQP9A4Ix9248QuRPd3srBZZ52y4atg6hYrum5QWhmvBMrY/6Wlu6TdKdcj61cT9EOwhzAjH7N0gIcF9uhE/Wxn0jLinGW+I6eBTYYgb2hphjaF4Dp9SeNXmItt6Ru8FP9IDw0ggxpq+z9qWqKHPYjmAxZSc3XaWdLwBC1PL/mECJjpfEeiTeQAOt2nin9mSBK/algASdDtphiFVWd5A2ffFTjTGTX4y5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new data attribute probe filter type, hugepage_size.  It
will work for memory that is backed by a hugepage of a given size range.
Add a new damon_filter_type enum DAMON_FILTER_TYPE_HUGEPAGE_SIZE to
identify the type.  Add two new fields in the damon_filter struct for
saving the size range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4be7d1df8e71f..bbb190b474015 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -783,12 +783,14 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
+ * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
+	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 };
 
 /**
@@ -798,6 +800,8 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -805,6 +809,10 @@ struct damon_filter {
 	bool allow;
 	union {
 		u64 memcg_id;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* Siblings list. */
-- 
2.47.3

