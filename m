Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9DAC4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 15:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FF76B0088; Sun, 19 Jul 2026 11:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901006B008A; Sun, 19 Jul 2026 11:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8171E6B008C; Sun, 19 Jul 2026 11:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1E36B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 11:54:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4311120658
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:54:53 +0000 (UTC)
X-FDA: 85005974466.17.AE3737A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B51D20005
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:54:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KjNF2/0Q";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784476492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KpBYAIEEhQYYNRww20xUWDkU0MM2Q4yUHB2q9Y6AtAk=;
	b=xTX+fb5YUHD+kgUv/CJnFqHHeA1X6i4LDzQe0FBOLosUBDQcUJ4TN3PlqGPA9w4sU5lsdl
	q3GE+tIXXTspoOdIievjIeZaiWCL91doOFRf9OtM+X1fPgKt/k/vH8cAa8KVLekawM6gqt
	lI/srKfQ6y37+P19GPB9p0xufaHh2IY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784476492;
	b=IKtC3tY9pxtDNqu5dRS5jZ66FgMIw0/VlxNTVcnU1239UV9ScOqfzerT17RFDyeF1rmk/S
	a8pxYCL7EdhCFNvGU5PMnqotde6mJRFGzNSmR1+7d4iwn0HtGVgyulWY8d/BT4F2QzMBcd
	bG/kYnmLCK5yp2upDG9iq6V9mbvCc+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KjNF2/0Q";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA8B060051;
	Sun, 19 Jul 2026 15:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C7D1F000E9;
	Sun, 19 Jul 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784476491;
	bh=KpBYAIEEhQYYNRww20xUWDkU0MM2Q4yUHB2q9Y6AtAk=;
	h=From:To:Cc:Subject:Date;
	b=KjNF2/0QuHjvI11h671X6m2vzeHGh2gybnN2uZLis4mVdkPe43kBLpeXWgH0mPpYS
	 Oa//fnDGaKnC1r07nP9PVfe0DJG5Z7I3iKoYEAoZGZbcbvpcWMCd+7bjJ3H7jpPkq2
	 1U2NZzdudIO7LlnH6vUxSJXZmShAcYES9SnyH7j+6n/Gb487Ul+BYiPWWzosmYQHw2
	 lQ2/DDSC8m7toz/L3DBEXVGkdZfve8IN/8SZl1TxhHzPGkwY/MsOFZ4sr8AQr+kNub
	 rGucIR8bbeLfVRBOvrM+dn/Gf4P8BwghLd6LNgIQdeq1mwxcCUf9P/F3EcWmaUB8G6
	 nXXyTXx4bmyeQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Sun, 19 Jul 2026 08:54:40 -0700
Message-ID: <20260719155442.88794-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B51D20005
X-Stat-Signature: wcio4oi8kw6wdgwk84g1sfyj66dis7ex
X-HE-Tag: 1784476492-511655
X-HE-Meta: U2FsdGVkX1+8J5rlf2OEq5Ig5iw/X4CiT3767c8EPPbgdy844+71G1DwkWfUTGrMJ2ttTwPA4/PXQqdcXK6tiJVolXTF4gvv5UerphA9itGmzlXDn4IhoGsWA/PJFTNklNg9KcQ7AMwihJeeuVJAKwixtBrosCxQRyucybn8R5uJS/CeQOr9e4SDphpPsKycVJX34fzORn5pfjs31pkOdCeKWo1kJS72bKqrwMAmXQPq6Z+JpNVLtDfpu8GMc90OddbVCi5Mv2GBSx6mA4+Ll27ANpjVJ05YwS2hIYIjsEBQp76zcQv9H0Vyrj9R45qdzZrCFsHBSaW8bgtmzwHmvISnSnJbnkLR9l8KKthB7DCJ7y6m3fuaoVQEemt3xQcOklZni+s85PvNImREKTqOzHxcSK85Oxe624gnMBHbQGOJnRAiVtt9OCDq9ENvFkwo5VDNeOLfQFeiyD7JqNHotrJGp2J7JMh3NaxsAvRgXGMwkwaA6uXC5XJ8luHqeW+hZBACpXep85SPiSvgGVPkywEGM5eZAWUfYFM/YgFHvDHFfZV9ZrSjmojDVK1h6jLG6VXvYQH2SFwZXnjZ4JiXpS66BksHLKvjHUyezLX/OKdUyjKImvy+mESNSJBI+1gjqUPm5oY44tRs0AlbX0xwMBF3RXWtftJKE8Y0zb+NKzBoIo11AJNaAvGUgdEBeUcJIAP1/PapuAh9/KsTs+xe/bvC/7a7M/3Z1gSfK5Z0/cwtS6DFfr9+V0Jp+SZoSlU0HiRIQS6DT0uOas2r8s7hYCIGDnUC3K1S9ogMKKl6kgs0ONjXfqCQmXaoyRsUthgVi7ziobshLti9OZT8TIt6BVsTob3DKDN4wdTLbp+iFDLVXwTxQPlTyCJLbwzvRmhJf+z/6mZ/DxaEwuzWw8WxDIAxRIR/sWJHDKPhxT7d6YXd+HEDc/ifMX7bNYvLagt+yTqRKDM1qVyx91TRRJ3
 8scqEAC3
 NDilMbf2fuvCqZSi2kGpmy6OJKzccgaOI7ljnIxmAoAvR3shrPCx5iyc816KFeFXZnI8Aq2eqHOSN8yGucuvUt15q1yesHcGoi2L+5QQfwi3uBFwJjB+ghIfeT33VIvxYi0hjVBhgJCGi7km8GLkd2WOAUVGacX3PwCZw7nUs0U9JpACcUqCi3AijrgAXUVU9zm+6rVgI94DVC9kJUcTCxwtxlczml15u7ReLzka1BFqR6JGqfbSDwsFg3bEMzd9XAOeggQVNhGR3HUVkE6pf4DsWFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_apply_min_nr_regions() repeatedly split each region until its size
becomes small enough to meet the user-defined low limit of the number of
regions.  The loop assumes the split operation (damon_split_region_at())
will always succeed and create the new region.  But the operation could
silently fail for memory allocation failures, for example.

If such failure happens and the region was the last region, the linked
list-based next region fetching returns invalid pointer.  As a result,
invalid memory dereference and corruption could happen.  Even if the
corner case is handled, it imposes stress to the allocator by trying
split regions for other targets.  Fix the issue by breaking all the
loops for any region split failure.

This means there could be a min_nr_regions violation.  It will only
rarely happen since the allocation is arguably too small to fail.  Even
if it happens, it is only temporal.  damon_apply_min_nr_regions() will
be called again after the aggregation interval.

The user impact of the issue should be minor, since the allocation is
arguably too small to fail.  But, it could still theoretically happen,
and the consequence is very bad.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260717011834.120715-1-sj@kernel.org

Fixes: b1029f29eb1d ("mm/damon/core: split regions for min_nr_regions")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260718001442.87129-1-sj@kernel.org
- Break all loops for any allocation failure to reduce allocator stress.
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260718004301.88883-1-sj@kernel.org
- Drop RFC tag.
- Rebase to the latest mm-new.

 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 20d267c615faf..e0122376f43d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1886,7 +1886,7 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 /*
@@ -1912,11 +1912,13 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				damon_split_region_at(t, r, max_region_sz);
+				if (damon_split_region_at(t, r, max_region_sz))
+					goto out;
 				r = damon_next_region(r);
 			}
 		}
 	}
+out:
 	return max_region_sz;
 }
 
@@ -3411,8 +3413,10 @@ static void damon_verify_split_region_at(struct damon_region *r,
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
@@ -3420,7 +3424,7 @@ static void damon_split_region_at(struct damon_target *t,
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -3433,6 +3437,7 @@ static void damon_split_region_at(struct damon_target *t,
 			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */

base-commit: 1111bc7bc679131632fe9f436f4c990e8b86bee5
-- 
2.47.3

