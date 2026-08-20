Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A6FAC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36256B0092; Thu, 20 Aug 2026 00:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6FC6B0095; Thu, 20 Aug 2026 00:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5926B0098; Thu, 20 Aug 2026 00:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6986B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C270D160266
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:05 +0000 (UTC)
X-FDA: 85120438410.06.FD0CE5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3862BC000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sz5NyFbw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787201824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=migX9AimFf4wvpqfBtI4GwlSnq6tIejoAluPFOiC/J4=;
	b=Neefyy/vV0n3kbLSzz+GFUiXVjn6MYXp1EOq8eJ+6Euef2Ra4cZmRLHhfylVborSwYUYd8
	3qMwrqUekmR6j7/Hp0hhHt0/rV+4P3Trxq23kCEIwYJmM4UOWRKVy5nyruwxEMYxy4LiYZ
	Kq0gqRmzZVibJo7YtDcxOxYmYxTNfTk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sz5NyFbw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787201824;
	b=yMIbTgIxtQ+lQrJ+0EtNyLv4YCNd3zW5J4a25sVw38O8XAdijhUV42zXgSCqMn0v7PRjtu
	+zCBQi2HeHLGxCgoCceXl17ccbi4pvjABvVl97P6D9Xr4LVxAg4kYI+Qr5l53dfD0qqF8/
	n6nFl57FXtJmyTfDTYLo/8S+wVqvlPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C828F61887;
	Thu, 20 Aug 2026 04:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42331F00A3A;
	Thu, 20 Aug 2026 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787201823;
	bh=migX9AimFf4wvpqfBtI4GwlSnq6tIejoAluPFOiC/J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz5NyFbwN2J4MMhQTyIvIxHNG8WSaelqyeR9V2UqarMofhJfHfpA0yGE/5BYbjgN6
	 /Sf6OYsPdEFbl8s5wk+cZkll9yhKUfYCQfAFV3dY8AqkhZZJt8cq9ED/MluPOatJmf
	 j1i7BRj76XWTMzulyczJjbuwxND4gRMhH15HUKznwBXH2ceV0E6NRWteBIlhE23fs0
	 tl/CY+BZ3nfJF8ujtVZT3oQ6cuZrJXLC6bpfzs/fyl1EW5Fdp6bljzEZhU4NwEK/LT
	 rEkzIkO74KJwivg7V97pP0luoGdP4lA+UPfWdOmgRET8RnrW0nyxVPrEE/vWI21EKS
	 sz92nkve/+HAA==
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
Subject: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
Date: Thu, 20 Aug 2026 12:56:01 +0800
Message-Id: <20260820045603.68809-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260820045603.68809-1-baohua@kernel.org>
References: <20260820045603.68809-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wo8rccdggk46s6m4ho71x4rsn8f6kq1q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3862BC000A
X-HE-Tag: 1787201824-782430
X-HE-Meta: U2FsdGVkX194pZtH8imtFZC3bjoA3a5osRmZcQ4wgLvgddNW+m8rcw/faqGlBTwWO7LhUCx4Xo25U3Aj0EFnLXHOjPNdstXUA3Wy25ACfei5qR+4PbJPDWYmHeXd7YaDf+avV35xpNKiSXzxn/0vqotO0/oIbD+x7tO1qTEZVWlc2rV+NZPBBq0ofJuK1aIv6DyrnAGXS8cWhWFvcBozK8uVfxTzyNFPGNvSN2PyKpDbbWyyHBxykC1UfhPeD3eTX0Ge2anZOOYVU8DAI/auuly5N3jim+4SfBWjThP7Dtb5FzQJLhpPIcKDri8ZRFVVueUvWfmxuyvuTP2A3n6oFjUsKfEHBeaqdLRollWnW3RAvZD1uSEJHy6o2e49hFH0XCcdarctpMf0RmuhXXJGujEhoqVx+QzGZmF41FSPwq8tOv2SLQIk2NmiwkAdp/oyTlrEzdNINq7Dw8sm31+i1euNl4zxTFCIJVWQq7rJXNyvrtaMVKr1TLmgkwkeU7XxKGQo3l1ROTWW697/nQCf7WZfbMeacZvwkdNh3mDEj7umr0YRqBu29oXfEVOtOIMopWPUkPUYPlTQvpDrDK/gSBjv1tSX3KFgqKytlATkyWJERyZA9uALUNCoTr1NQbXaoFtwCG6popvAeF+XacoHBA5fBZ1KNJJqTJpdIeltjOyam3bX+bR2QrcNSFmrWq998xJBDnhzQtesiYcgz6GE1HO8x6q33p1xu6ADaX7uy7NvI+IGAjs8G8vxubnpwzQ44hFbDc1j0tigBQ6sY4uRI/W+cV5A+oK1XnzhmAOMausiwmpbvaJFsjQA8GyWpOBifVzxdKpas6FavsYzEIjChkmAAC9G2SdM+26sakzwMqQ3pW5mzD3L09Bu2Z3MN4kGvjnS8tRj4XRDDCnFt0f6ordKphL/9x/2PNdkuY5gnRZ/FGi+XE8gpWZpXVELXNmN1VlJHoyh4gJSRnpk5Qr
 xWgYvOF5
 y6mDw5H0sIq4PHnYYnGI7GZ67JD/XsJ8maEC0SjWMfSTQoWfXc9/f7q+UQNvd/Yvu3jiV/PDObDddtlq0qJnTnv4D5f7rPzqyCFGPtgIZmIm9pzolmuqXOfz56eCELzMsf+seGJ+BAizCQwsYNthGxiHd/8pL3u8nwKZkTX3Qy0Jbag3nQw0S5NDcuB3Elk5fe1qQTH7LBuCjS3pdJ0DC7kK7yPUthF5T9fkwYjSfEuihSsv7kqpx57y+oGKg9tDEWH1eYnDhiNAU59xPixXtDW525qEN4bY2KqCGzZyDxh14AMU/ORcq3T8mxOFxjgWHnUPL/rT78d34P3liE+4OJnhfLAwzZF8tDrs9U8Lrg0+vazb3utJgEhVpwcYsL4cmjsGL
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
index c1404a59523d..d5cc30b667ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4833,35 +4833,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
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


