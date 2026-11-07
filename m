Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DC1606A33C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eK3SGUJ+
Received: by kanga.kvack.org (Postfix)
	id 0CA1F6B05B4; Sat,  7 Nov 2026 17:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A556B05B5; Sat,  7 Nov 2026 17:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8206B05B6; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C30EC6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BD6AA03F6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:13 +0000 (UTC)
X-FDA: 85409747346.13.C05BC2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C256E40006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK3SGUJ+;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQA9Oy9D6eu6KxEgI1EDIZ+uJxOBHu6oOt+CM7JsTKU=;
	b=q+QJEqyaG+KadEDYGco4LdlWz9M8+4W/yA0lCchSULGHQTh7E7n+2mzsqZ6W0LM8H4kL46
	2sugAxjtFJO2JAZr8NdFLZZHG1VcQjgks0zKjefCnMIiRSwITjts0D5basNCYb2jgEsTm1
	W0Non05sWAdzASuZECiLnrHBl8u9heg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK3SGUJ+;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090131;
	b=HtuuAMmRsxrcTyti3XEbTQTGxTJq26w6LpvofGY/dK7KuWDEG04/9NKudJi8dEK620htaF
	TQFoDwbbBZvWlv31J1DNOBlYVam/hRlwPp67+E0Dx3eE804y1cnUyBou7U4Ts8bRHIB61e
	Pow2/QzGSvUex/IKt5LG8Dqz64mqE3M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6028B61213;
	Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FF21F008A2;
	Sat,  7 Nov 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090131;
	bh=uQA9Oy9D6eu6KxEgI1EDIZ+uJxOBHu6oOt+CM7JsTKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eK3SGUJ+hTk9RnrDzTsbm96CvUxA/sAAt8z0vcM6y9l/SBkeINJBgcSzXp9fH1j3q
	 W25eqed/DbIyDITqOmP9iTtfsULpID2zTxYENVem0TxmJsSIMDPr4xoXC85jjtX/Y1
	 RCgHLAh2bCWAeC6gmXKYRA1S8gXo0ckQWKLYmZ2Ayg2sou6KERpZnQmQD8a6qZgIxe
	 aM9aHExtmGc28U1E4j4xUCi9MNfwkZ/MgsJEkn8P87MWP3gMQGgmNAM8HekMQgpHgd
	 JDMsEplXJ/AbGP479I4gXqooPHgglC78AnNsCukDe/fRu+ZL4xXQAhGw50SCfyCUqm
	 4oCgQ6cjQSZZw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 14:21:59 -0800
Message-ID: <20261107222202.331476-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107222202.331476-1-sj@kernel.org>
References: <20261107222202.331476-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjyx9317uk9ye1q8ipq6m4qaou7pspos
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C256E40006
X-HE-Tag: 1794090131-799273
X-HE-Meta: U2FsdGVkX1+tkbHhny9N/eduCzhZuLwrZBd5HoHvyHKl9SaTOuh7Eh8hp/V51c8N/GmhHhuJfQed6/jSP6oDULl7Wm0lN/BlmsN9J6TDfJjKIHkfDbkLf1IoQwNsGVAosQw8ArN1gzlb6FJyMTkaZ6PJKgcxPqw8aCIzo3ClKnirCGizhF6XyCcpE3V2qD+ochkuijHemBdpKJrVp5RJVTqcObRxzwLPqc76VkD8idVGOjBrHdUzLIjpXZlLZKofEdOIr9/1abhnqE78siCxrlINiicdRYv5bk6X2+VkHxMJl3tLRW2GVfLSHNyLUiN2rEmG/vhD74e1R0SfE/e0xxWcroD3Pjhg9u5d7HKSgYXLcGibW6GR7v4Op4DyMWplde98Nt9VbL7ZlDeHLoYew4bdxDjT/hQeXkR6QqdWuzdK+dBXgUbCTrFJLw9cVS9N1VXrKninTUcJ7Yk9Eiz/5sSeqYHTJ+RZhqg6qScdJ8wfOaSJKSsssSOTEMSf3vk72v7CmW9hHLKSDH/n9SCJschBdQcz13Ly7QAH2BkxPAm57aGdCtC0zHFMo0NtnstSW1cFSJWfeLh2pU9ma9xCkKp0Y0P5uxWh0lrEeQaRLghdprZwj+P3oGxkx0jIWTIG3RwPsvXHNRPrZ/4GmwNWSJEyF9F4d8WbtPz3GZ9YM4TAR+oD2p5B8djSnBEPiU/UpDl70/OAc+/kPFFYe6oToHu+9aLIk+C86Vv4EyQACdPgNdKdYii0eTa2e9ZNVNbXqY89UqPP8jSR73dfwSSRi/K+g9V7loQl82I3Oaibc8Aov3Wbjn243L7/R0Hv5pPomvaoalvhbXSo6lX5hXvgT0WgNMdBl9uzn/TJAn7e6agY5/TI+p3Y3+pVzzO67KPV07RohDtLn6Wf3+zmLNdPpQsJoxfg93C5fgokiqirPiMe44VWCgDAVMwK52ylccgPfyzwakq1dRnpVTs4Diw
 DVcjDrlL
 EeKnY7HGRDbrFn19xDOoxhijYm7hl5/tfaW82sKITQJEu5YyLXh2S+vJamfGZrTH1pfjcHY3csg89GQjGCYTnE9RFdXDIMlp5B0PFg1osfJudlpzXimrCuTu5L1iaFRTaUoVRMuTXWOHEfOSPnbu6NLO/s2K6oSKkbyGZ42w5WCHKAvFW/nzUET1PXXxodZv62cNDIGUnLdfhCkONSDi2uBYNkzfO+IDcovG1MZ9Cr9/46cccdm2P1EStpkw+lh/8yMPpntITSPrTwlegNrO70wt3AKyKcNMOmoVUMvWA/McPuVMRJlTnxFO+nA==
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

