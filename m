Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAAB606D831
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwVMtEuT
Received: by kanga.kvack.org (Postfix)
	id 865526B05B4; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835A56B05B5; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B066B05B6; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 431F56B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 347E81A0405
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:12 +0000 (UTC)
X-FDA: 85409414664.04.DED1788
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 927971C0009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwVMtEuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082210;
	b=XCLBOS2Zn/R/zmg7oNtOiR2aSTkbajJAjE+9pjz3h3eckhB6DLsI00ZRUTgbvR9kRSVAnm
	G+guRWsGWOlt9w1idKJdafwEe6odSOzky9PAJZ8u5h8SF5twGvF1Pz6g5Om3KLF0zrB1Qb
	X01jrLCLKAovZ2bQFwIxBppGCrkNH04=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xZ+n0JvDN3hrYenLHVXLkTjZ+lK0ATIB/YUR73+pmo=;
	b=TIzOd5X5k7VL5iEyelE6cD40RXK0yXd4HMLh4mT6LCveTATfAXpCNfjHYEL22LpvpalrTw
	OyVMX0ymiap72+ls+XyCk3qf7B+OEpJ4z8qt5EZ79Xwj6AJyyXCd3Zqg03i3AiIhDVqQE+
	4v/Qqdua7CdwulLkxToNK6tWOGkBYH4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwVMtEuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E71D61189;
	Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A3C1F008A1;
	Sat,  7 Nov 2026 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082209;
	bh=7xZ+n0JvDN3hrYenLHVXLkTjZ+lK0ATIB/YUR73+pmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwVMtEuTJ5rlYV9k6tS2s3XV+LH54GnadV1bpKatYsQ+cshaJXCCBerN9baepeb+i
	 wMKX5dVtJPWcf2yX5XEg4h4t0n8tOY/PP+OXUq/EmQ+BxboSqKLE/PxSHwuN1x+sil
	 x4n0XaRVduvJ8XXL+krw+cxz9SLpfcoFMuZC811hIgIRawy16PKW2cc2XZC2JiQUJ3
	 hzufchlNNtYqx2IMLNd87r6PIT93UNTkgXOQDg1h7xoXdim5+0H5VwOsuZyom4B409
	 hRFoO+IG1Fn3DrdJ8+QPRh3yKLwxsVep5QBaEetxWt9zJI0ab4XYJEHIS9C9zKu5Pj
	 KSsmLYfwO4Wrw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 12:09:57 -0800
Message-ID: <20261107201001.206120-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107201001.206120-1-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 927971C0009
X-Rspamd-Server: rspam12
X-Stat-Signature: 95y45m6chmtmmjqeg1x7wbiq88q8gmg3
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794082210-809488
X-HE-Meta: U2FsdGVkX1/fB8ZBYt2gyAdJP+FCFXQUGiUKsGTgbwDTosF2F0Ai6Godd2vbiWwcBqFMJj/YDs/IWlzmahgg5fqZ3cY+WPcuE5HiDKgua8mRIp8Jnms9YXXyRNIP9cftNaX3EFgQ53jwTyRFmS3REgV2aAXCnWhWXcpEpiaCew/Xldj6aIXG1WmkWvEC5jci837NDvJKKsqQmagNECjTM1IZEMsbV4NKh6YPpSIp6o6aQIZMiSV4NYjx4P2UdZu9s4WRiDo1nACBLhLK5E5jTXhmuv3iZFKk23qBkqoXBDkZUdD2H+PEUJFtPFyoxnET6m3jsTuI9kQNq1Q1Xg+Rb9O6gvw1AGEwMH9X/HNySR7en4w51wlXcEjQZNbh4EJAckVV3fZiO4Hp61hzUVcblbqa4leKS6s/EK7hvRQee1Q78TLXST0R1cTUvip1QUDE02RtX4UMUCKaQhZ6gUMtw7IGEYTCB+Z+N9FZVbZodDbCQAOaYRxFuPvLIWYSjja9LbLz6qz7aWshVB3beWaIfT9GIAUyYR6+FA4yU+xyEQbUbJp+FHt2U0qgMxxELyozXLd/MZDsd4FiEpnd8OPKW1YTmIn3eF1/LNGzpB4DJUlLiiADQthACnReGI9hDODgsxqiZ/tKI6MGxji97gRt6qz6+0660Em7EVsPxgvrSTVvyXyYNJVBe2jh/r0cZVQg6xuRzmnrvlL+hBLVdtoE1BeD7BnkdARjYH7F0PEZ5KNuYpsqQhmWixjEfT/MJ2tX6ifKnq0ksty2N8mikqYXA0jHD+6fjlLUKYARdPJq1dLJwRE840mNz9X57gFZtFG9S7P7x5aJeSPoZKKs1mR0huFpxbIKF50NN7zXeNqcJRyWV/bAWcpydZ2aFU8SMPnAYMmETtTtUTN5bacMi33JOocPN2bd13jqVhxJywiL3Ssar/M2gcntMMa9VznwVlSL6JH6TddDCSYgX+q6i6t
 wlwvLkSM
 QfphNuIm1FD9OEsw/5exRFfkshYRuDFFW4/wBKFIE66oAET6FUEpSDhDGSICoaZVI7TE8UQdZDVAoXbvu7+WgKYzpJqW1Gbai2aEIICFRwmECmKFBaAbMXGFy1i0wnZ/0aJD5PeX03RBZMu4/kbWrPvvoBP24RU6hQXOg8A834hq8azWqebSgNQLm6qTHhpafhW5HrUJuvpiY/dN4NUAUEyzEI5y5GRerFJR28kt4FtpzCt47a8lCdeoppqnmfcqpjCXnq8MIeIcqt9S5DWI9zGnSlDs/Kit2hQ/HEsImS+MJ1f14rxwQ7WT7P7XT0kxRBNXqNDAWbLUc6/aQaUvRWJ0RVHMs+QFpTWqG80/49TGUGXNDYGLViyWqaqs/5wUBe8j5xuTO4C/gn58wfBi2TTeQqoLECrTe7AU1Oi2TASX5SUk=
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

6.18.y porting notes.  Modify damon_split_region_at() to return
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
index 8fa788b0d709c..4c536a9b958e4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1700,7 +1700,7 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_sz_region);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -2454,15 +2455,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
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
 
@@ -2472,6 +2475,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

