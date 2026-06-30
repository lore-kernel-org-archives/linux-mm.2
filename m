Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981D2C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9266B00BD; Tue, 30 Jun 2026 15:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37546B00BE; Tue, 30 Jun 2026 15:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD71E6B00BF; Tue, 30 Jun 2026 15:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF9806B00BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46043A05B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:25 +0000 (UTC)
X-FDA: 84937517490.14.7905EFB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id AEAE8C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=evAwrmmJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846563;
	b=WDl4ltEQluHz9P/6u58HHvdM1c06+rk0fJby1u2kJR7qyGMsD0sIkDZIyklJdmDwPD1ift
	djKSKoemFlGolGcDUVFPoJdCArLYWmGlXINBHICC3Z5vwuYFbMxANgDircGHk7Rg2feF65
	Q2Bfgtp01+SQRleBtwK2i3545CHnFHc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oefyTdRYkFTzp7WNDrEG46XjgxfzRa9VZQuKV2Obrl4=;
	b=y1yzC6jiiBrJaPqm/lUKcfWzO/WbP9LDXwLCxEzs7hbXYSeyaGkX+rktYOdA+lckmax2er
	exfUcA3YdTzEgsI6h4l3tgJyNhxN342oDpqPKKuzojT56Nwjur//zvGXib1hthZIdzcPaB
	ouXNxo1nf6D1bdzlLdWqF3KGf4j+7Qk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=evAwrmmJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oefyTdRYkFTzp7WNDrEG46XjgxfzRa9VZQuKV2Obrl4=; b=evAwrmmJU69p6QrsY4DlVv6Pr+
	ccVtz+TxMmHVXjTzAj7QIj0U+O5Ic9JvGbEEPow6/IMsIM+35nu1AB8ayxmCryGn9+CsZ0hLbx5ZI
	55Z4lleCnoiSyp6hbQ7LrVOpMrLKhdj/PH/Eq5TRz83y90Q2dhPbfoWgwZOyE+OLytH2WNiYBvPfi
	2fZwpRnIReOglNaPUsA3Cl6MNpW1bGxyKDUiORpkO3vQvzGgT8A7ihxrVBw0MQWoUdR1nKmTmOtL7
	Ji9xUwASUCMnz/nJAOi5sMfLp+FXCNaSDiN+C2pi7P+30uiZYlbxftcxLiAoUwjRFwdutHDJhIa7N
	YwSZ3LZg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpi-00000000657-2Rod;
	Tue, 30 Jun 2026 19:09:22 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 19/19] maple_tree: Add helper mas_make_walkable()
Date: Tue, 30 Jun 2026 15:08:43 -0400
Message-ID: <20260630190843.3563858-20-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEAE8C000C
X-Rspam-User: 
X-Stat-Signature: nkhxja74h7r1xbm484qsygp4n1q3zo3d
X-HE-Tag: 1782846563-25465
X-HE-Meta: U2FsdGVkX1/vYdtJnzusQHZT7FD8WU2o4Nv5og0MbtqgDFBNseZIXF2604cj0ato/f0YzQD+4ucFQr2teT7KinuLKzL7FozoseZkW4KN5bnWbakw2EEYuQavfU+2C75hrb0ZcOxN0AG1tOf/nDc9agKwg3UPKp7x6oRIob1I/6fqAy0nY1DKKbnGuG8+2kjwO+lVW8ueMUbQhPUtAY6dhFzShJvgHZp6h2d9g39cEBXcnHf9aK7/HuMcWSSKE7NoazQk3wv0YPra9H25gSUH5KgqjoASQVjPYGNY+p5XUwcv93MuXzS0x3NzMQc5qYOlu+3J9xDF8imwipAI5meQe/4kCJeStA9r7Skbz/Hynbx1V4g+OiC5p3ObXshJ7o/mGZpROCYiQW0vIUJRrkUtu2ZV3Bf+5GYDA5I+lNKsr7b26F3HtYjMpnd+xBHl0W0bIaXDxPOSHdfoR4yC5FqYy2Rb3i6UkDU6NcNnUA/EoQkYqqAp2va0kNmb4Z33R+n1sgTJ7lg828kiZkDAg6Bcq64+rVbm+t8xpp7E+JkD6H1M9IsuIjS+Bv6LfNcR6l84+qQk9m6Le8GRneFvb3h8g8ibqrVuwEM6O0hFTJ//xdFm+9G/ys62WmUnisIVNgEsZlNauuRcP5nHq0t+HhEZflxVv7IXFIZbZ08bzUnpEVkCYuzvKTjqv4mi7ip9EaXytp5EUiTg1Gnub/DN/3WbkVBl5VgoXJ/Dn0PXIK2TADaz2HGfm55VsayAQfJ5fYRAYbxVp48N3LK5lpJIKg6mR6nDrQ5pAyU8ATEOXRmpWJVF34DWsO5wy24D/lLl3WRAkgu0c7zR7tDaEkpW4Rc1X8ZVoEyvnY5j4uZeLLpFegZx/IsVWVnHhEFyYs1wSc5Oza8IRJ0CuCw9joqe2RBMPfdj0asB5LksNO4pTEj+TgevWHFHEmnyuRRhuNO5EGF7eI7T/lcyPxtNfGjHeuH
 kNrzYh4D
 YzUDJPJnoabJ+ml//49HjoTXv7wBTxYO6daDW+3BzC3PTLZPKXBB2JMYd4zgYI+fTTn7QyMK6H0DV1LwHzqZYRAQtFbQ1UqJu9HGxcr6fGHKpCMyG491wFL8/Z9EMbtbdjNCy5gQ1KKwFVEomsBeL+SzzYmuefHLj8RwWG2MjcZZojvHtj0kdAR7Py0txB5zSZO00BSWnVPi28OMY5vD4Bm/Pbyo/7Z9U5lSHvdg0xWBWdDK/5t73BVooeXj24IBJXCZlO0/Xkug+zlvaD8P2HezVmPnQvgGTMLBsUHbWqAKCBLGqmzEA5ZWJioepbyjKv17E30ixk+8LrUsWpv49s3BbvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A check in mas_walk() was incorrect and caused inefficient use of the
maple state.  The same issue existed in mas_erase(), but was left
unfixed.  Making a helper function is the obvious answer.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4336a98763984..06cc05b79fbdc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -261,6 +261,12 @@ static inline bool mas_is_underflow(struct ma_state *mas)
 	return mas->status == ma_underflow;
 }
 
+static inline void mas_make_walkable(struct ma_state *mas)
+{
+	if (!mas_is_active(mas) && !mas_is_start(mas))
+		mas->status = ma_start;
+}
+
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -4446,8 +4452,7 @@ void *mas_walk(struct ma_state *mas)
 	void *entry;
 
 	mas_may_init_lock_check(mas);
-	if (!mas_is_active(mas) && !mas_is_start(mas))
-		mas->status = ma_start;
+	mas_make_walkable(mas);
 retry:
 	entry = mas_state_walk(mas);
 	if (mas_is_start(mas)) {
@@ -5683,9 +5688,7 @@ void *mas_erase(struct ma_state *mas)
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
-		mas->status = ma_start;
-
+	mas_make_walkable(mas);
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-- 
2.47.3


