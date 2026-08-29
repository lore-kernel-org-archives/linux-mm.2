Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5475DC61DD7
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3256B008C; Sat, 29 Aug 2026 03:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6645F6B0092; Sat, 29 Aug 2026 03:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5043F6B0095; Sat, 29 Aug 2026 03:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D91A6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:42:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 960CFA4121
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:21 +0000 (UTC)
X-FDA: 85153514082.03.A76FF51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0A1640003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln6IGQ3W;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ae9c4vZDXmNsxI4AdcLQro9NNVm5MPBZzf84/REbvA8=;
	b=0vhZlflajTVQx1lmF1Y7UD4DOdszyCIfyZTmQwKkyiotmAKWAvYlG8COHT0UkTPlZ7Us0k
	dsdvGjGh1/7+NKcA19Km7iup89W3YZWfBJ0+4DIs4DopmWO/EZK/yqsz9C59zd90gzudu9
	o8g4JEfIMMVN7aQ1SCzVBIPdXrytMWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989340;
	b=fWqhsQvzi+XHl4M3i9m9yGQHYVD/ba/lTH8Ec85rz2vnt/CqeOSt9BIfTpbNP/4MQJ6eU7
	jjTczvn/59oEDenFuuZYkiVWXsBm82cx4SgTAKKUak68zE/JqxBGcTqeaEwH4E7nCJHGgq
	6JX9YbeMahcH26NO2g55Dmhq55FKb7k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln6IGQ3W;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2451E42AF7;
	Sat, 29 Aug 2026 07:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851F71F00A3E;
	Sat, 29 Aug 2026 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787989339;
	bh=Ae9c4vZDXmNsxI4AdcLQro9NNVm5MPBZzf84/REbvA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln6IGQ3WV6IeHmrg10U5ceIy56PEPVtGtpAAax24IdWmKpTzpp+86hL3xcu3AaJqL
	 INTubcliazpz9aoUI1sdyqJJ0+gULgCpcq07nzu5PWTc9rXbONFKfOPoeBVmuoi6nP
	 jSoI+bKv0JTaeppyswbN02SjOZFC9N0FKhd7zXmHJchIjeWpLOgnlCxhkS2FFKJQfy
	 i4x10maRQcYmjeY6+3JqjMvB2aKeIv0Q4FCgaGVoy0W/1cm4c9TZLl8wZLS5AxINJ3
	 r8ttq56E1GZfaWlBBezM0HVFmf2iZC83RSqOu1nKBfbbdONpI+bT7O4icpvyrgt0kh
	 fzmmEZFuN3ZVQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v2 1/2] mm/mglru: make type fallback logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:03 +0800
Message-Id: <20260829074204.45304-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260829074204.45304-1-baohua@kernel.org>
References: <20260829074204.45304-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0A1640003
X-Stat-Signature: tqq4sdt6qpqd8dye6xf7796aag8uzqgf
X-HE-Tag: 1787989339-326671
X-HE-Meta: U2FsdGVkX18IoYsVwpYM3Gxtbi2KCbHm9kqHVi1l10D2b5E8AUlS0Pv1AXCQdf2hM0houP3BJ4sn8nvfCETs54CosheB3HIEQebZRu7cJwPHsIzWONKFEqJ5GhQHMhiIuTslGtGFdZHxpzgB1RDn7cjQc0MJ7IYabP/4/MmTq+PCvGoGvBOupd/3mROqw+M7C3uJfN3hVuY6DNSnhFkVj7CT4f07lR91VcWQ8trv00C3emXXqlok2WJ7/CLpGEjFZFs6kSrOMB8CqIrP+PrYyFpGUahEwgrP2mv8KtZZWPrKUj7gMCGdNXZbBHtKBg0LXA7WkzaEC3t5q8IQYy1mv4oplCJVXno5snvjed1Tp81vpPmkNMx+gl3GbBO5V6mhizbPVTxvh4sR0lUEzTmLJ8fG65XPvrUztZyCM55hoq083w2FbF8fA8YX8ij+yRAbKQtuZctsJcDWZJhMdSRYiFVhxDiU/o3K8pFH9m33iYh4v1IfWsTQrcLvr9UU4JAWUm1Z2Gt1glhnlvEWHf0+HypXJ06wWYJWz4MNThEVR53Z/QA/6kWP+onwCaJMKSYuvN01doPoMAZWGATT/U6nJ6XVNadYoy5oYB2W3Uh1jrZOtGtMwwzdee6yfoc8hj9reY96QpM2UsoCc2KDfm/f5Leky+n68hIm1Q47gCqI0pfs4cf6MINDY/+Y6XapyZ+kDjIz+hJ4TwwYzF0VXtdfLfZ2AQKwOYkXSLw+V92UvfkkpORiUmJpa+TogdRq9hAw+LurER3n7fKUaWzf7peyWBmDa4oyalsuYp2UTkagUbkVpA9K5Mx3RkcoyJyu1l9FtU+RXWix7y1S4HGRD0CX8zbI1Gk4cEB5plX5gyOP5r7YaeDk7AUsYWenbhGl4r4oDbc9u+liTMs6x4xQprfqvAnd/aIx1b+WoBtSBPmfBzyhaEuOA7uo0CGifbidFQBAQywoIm+d1dwfv9baYj5
 3DW/zJKK
 4mmrgVA/42uH+6auO63cMi6s0IG7nlOSL9feYUUtYy6f9hATfeaeemJ3OCoB2bb31SIdujAExfP3ccS3Tsf9kB0AoscIOqWM8+Dv2FBwT4TyvwSi72GeNWveuyqVX50vKx173D92JEuUGqJ6+oklT1CD33xUoWctFI32Cx3PcRuWcMQX09tojC5XkGS4E0NE5bb183bm7avX6/EWC/2PQhHD2lmTrWPBz0TsGIDGTuaifKKk3d6AthrpxvvmC/W/IQOIXS3loJ5Wyk1G3s/wppRsinFWrFve/WYKgaU4yvNpV6l7etpHfzTRPoyBTuZWtIGFR4BjJ51ZEj9telV5Q3/L1s8TuTsZhJrgRea2x54Qqw0uhdFHNu2RoSmUHQRyFeIEx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The for_each_evictable_type() loop in isolate_folios()
is misleading: it does not actually iterate over each
evictable type. Instead, get_type_to_scan() selects the
type to scan, while the iterator `i` merely bounds the
number of attempts.

Make the fallback behavior explicit in the code and remove the
opaque for_each_evictable_type(i, swappiness).

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fdd13299a04a..35a233623368 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4838,35 +4838,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	return positive_ctrl_err(&sp, &pv);
 }
 
+static inline bool is_single_type_reclaim(int swappiness)
+{
+	return swappiness == MIN_SWAPPINESS ||
+	       swappiness == SWAPPINESS_ANON_ONLY;
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
 			  struct list_head *list, int *isolated,
 			  int *isolate_type, int *isolate_scanned)
 {
-	int i;
-	int total_scanned = 0;
+	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
+	int total_scanned = 0, scanned, tier;
 
-	for_each_evictable_type(i, swappiness) {
-		int scanned;
-		int tier = get_tier_idx(lruvec, type);
+retry:
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
+	total_scanned += scanned;
+	if (*isolated) {
+		*isolate_type = type;
+		*isolate_scanned = scanned;
+		return total_scanned;
+	}
 
-		total_scanned += scanned;
-		if (*isolated) {
-			*isolate_type = type;
-			*isolate_scanned = scanned;
-			break;
-		}
-		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
-		 */
-		if (!scanned)
-			type = !type;
+	/*
+	 * We are running out of the current reclaim type. Fall back to
+	 * the other type if allowed.
+	 */
+	if (!scanned && type_fallback_allowed) {
+		type = !type;
+		type_fallback_allowed = false;
+		goto retry;
 	}
 
 	return total_scanned;
-- 
2.34.1


