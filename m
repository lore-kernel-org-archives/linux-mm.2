Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23980606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZGTGAoS
Received: by kanga.kvack.org (Postfix)
	id CBEEC6B05B8; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C498C6B05BA; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37F26B05B9; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87ED66B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19751A8118
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:11 +0000 (UTC)
X-FDA: 85413056022.04.95093E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B86E40002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZGTGAoS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQA9Oy9D6eu6KxEgI1EDIZ+uJxOBHu6oOt+CM7JsTKU=;
	b=jf0lbpaKPvQQACBe3jP+arpwFX+KJpPMAl10sQp63ccTbsFKH2c3slBm//qPwzwh478Mo+
	SPctyBLidZh+CtgBk3DDPpe+AFcE2aii/McUmlaH5BX/NjZt7vULwmY9I/Edbq8YwUC6fs
	aZ5gmgg3EDSAFS37GdRvzGVYmJSxKEA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZGTGAoS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168909;
	b=Edoy8JXddZVLSb6iZ8gwZiqug8CS9AYju1Id6I3GfeZVYkMVbjDZ4BvUNK3haVPzTz078x
	BDcBXW4NcLSTnAc4YKyu382f5e1Vxs/oXMf1HFr0cAIZHFOrnMiVhhTpvWoCMYfWBAehB5
	QD1jwvXjmirwzl6AzTa3TiX6KlGnLWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85B0243685;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339741F008A1;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168908;
	bh=uQA9Oy9D6eu6KxEgI1EDIZ+uJxOBHu6oOt+CM7JsTKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZGTGAoSnxPWLIuE6uo4I9+ALy76x261/kivftWKEy78SkHTjJDypwqsxHLAekK/D
	 Y6rUL1pbvzRfbkI4ucKZujclvkVBOlXYLDzyEcWrjBwNSh31LjynpwipS+L6vDHTr3
	 /rIQlowp9fXr0yKTk/Rk+Md5qR69ujJGJtdI8McQy9XBn0fdKux43BsjEV1IJzuI1K
	 nKVs5rTQabk7j1EbHPw9X1nQrP0o6Dj40e/Fwx7VVA/gGGajQNY7pozXe9nLK0blIj
	 tgbSuw5pEATop+IRLHGTSmnst52qu5zEMy00r8JJMLATRXguHoS9QJpWIHrHVzr0t9
	 jLUfoQME7suPw==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 12:14:53 -0800
Message-ID: <20261108201456.116824-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108201456.116824-1-sj@kernel.org>
References: <20261108201456.116824-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B86E40002
X-Stat-Signature: ukudgr8pog14b4sby6iuxtt589zinctb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794168909-555119
X-HE-Meta: U2FsdGVkX1+Yls+7vKwBNNfVmAOAgcVjGJHeOuyowwBgjIQ5hQLP2R/4EZj7XgvwltLacGRNL4ancBzGxzTpQDPIUoXrN7y9ZXdIcgoZgzvlXk18UidD5kKMgZQYzI9I/Pd1kCqjgNwbojUhYQQIGpo6fhKTsYoVEuQUoGfb6qGtOUYxxDlmmcGG+OiEuqGvEfTwBaiFvXPsr1QtwzSV01iBskihqjWKzAuPX+daVSsaTfPua2V/gtXRRmstIWOSEA4mr0MMT+tQ8SpzbURKZ3Rx/5a5/q3k6BdNn30oM7TMMt8p7xjDRAtC94Vn3I9C8pNkLgAjN40PKSm49hxonQbnMx9Ds2Sr8XkD1I9lEzQ2IJeMgeZHvT63UXuew1Ajy21a281VHBcvQ0ZUvKu2eyp8uX7XgmqNpmiQ4MXZQMTLYVYXmH8bJyD1bjWrxLAkYjDY8a6TtcOGHVNZxuD4upTfw0XkdqsLd+ReTkHkrhzIkTtSySEoB1Tzg0RTzdgWu4Jp+wrd5ZNbNVL4OVbzqRuRG75fsMqlx2L3jCCIVDrItuYa3WYcOp0BpefXqFeAsKVrmUcmpow3oW0l/6xRH3KhrLsAEc873iJI+MjHBo4mVzWetv/vU6sKu3a4cYhUq54veJaIu1nPUzWKUbG/ZyNfZa/lmX9xSTMCiZGnVBkSccqQW9O80NgNQivKVJ1kFT3m0sFWvBJYdELx8prbntEFnoAihfpVgb5VZU4s545Efob9AYREFeccnoGlJ2XROyYI0ns6og9CvZtf07HTezlkUumGujaYizXnkAC5WmzHsutHzKKAnjH68KFZJEcwN51DFPyUOnltTqHPp1jHspn3TYgcgYpvMVzwYrftJr54fCcEn7hSdbDuDJEHXxA2e+AWweQwdahWvPcMcyr6DJKtcfpq+aUFQPruv9RTWrwgkTcSalNUEtXB7ueNzuqPt43SsLLdUq6qyB8lGKp
 UBEkBq5i
 5E6Yn+qJawL2ucXxZSnjoBqEkW3A586mAWCZyM5uDElOqDmo5qcNSd/37Bkz/6RMEXf4MW2QAnAyu70fAiXgwwq6YN6tJSqHlYvOLw5gJq4ijcXH/icUTuoukwYmjaZiEzYHmySRNYBMYiEBwmKc1MUgyRFjgCHlutw9QUnshQ3aVqnkh71S94UFgeX2oQ80NZ2WH0fiJupV2egU/hIQ73JjqOowS6em7/AOdxt+iAu0LnqjCBO86c5VdDg7lhfOEoOkBFVWYbZ3S27As1SNKjSt7N7t3bb23G8RmcVkajC6iZ05t57S4E3FtOg==
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

6.6.y porting notes.  Modify damon_split_region_at() to return failures.
It is a part of commit c60874860762 ("mm/damon/core: handle region split
failure in apply_min_nr_regions()").  Without it, build fails.

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
index b5b6d00d7a3b5..9d4a78deaa06a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -828,7 +828,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -1004,7 +1004,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					DAMON_MIN_REGION);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -1266,15 +1267,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
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
 
@@ -1283,6 +1286,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

