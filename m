Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99529606A33D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wehaffyx
Received: by kanga.kvack.org (Postfix)
	id 3B97A6B05CF; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369F16B05D1; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C156B05D0; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDE106B05CE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:48:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB82E1203EB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:15 +0000 (UTC)
X-FDA: 85409812950.16.CFD4B8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5C6B12000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wehaffyx;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794091694;
	b=7UF+3k8pgTcg9GS0n6KyYbyKd+cNuNE1//V0kcyIXkhpcaSdcRYYXfr/b/x9THBqVY/TyF
	8tOfE0tvtZBBXi2A9WYq26fbBsTfa8C6mOhkmo+oSAHGWoNB23qOqFJG+aw3Q8z6RsQn6r
	+kY3usO7kMmkGxtd63HpaDmlaVoKb8c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wehaffyx;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794091694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YaiTR6YvNrjuQTrS8BnXcbgh9AurDD3C2wJRI/aBVM=;
	b=sgLzfITB57buaPVpJq8gtS4Ou6I9fN4UsSxRBdc+p4RigV3OY/4sCXbQx8j0bb5o801GLh
	2k2dA8RwhrMwX4tebFivpBt15TEnqP1V9FvzMtaVKyvqAratxs7wgZxqVBUCbEJH5lfOx/
	TbJfR702hl11lMOoHEOgWx/9wg+Gn40=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04D9061268;
	Sat,  7 Nov 2026 22:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EBB1F008A2;
	Sat,  7 Nov 2026 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091693;
	bh=5YaiTR6YvNrjuQTrS8BnXcbgh9AurDD3C2wJRI/aBVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WehaffyxMILU6DpPeAvh1jF4YN8KxbD9iSnKdW95fZkZZpmkvLvFXjQnmf4gQu/Lu
	 efR+vL+pRUU/RAubos6dBanSyx1pj8R270IxKYY+XxBWT+iV4AcAz+vsMxUKMCYuCA
	 lKY147zy26BJrGh3Dq6u1GxFUETuXaJH7UhBhrmi48wsYBWA22lsWslrveA9lAdTn9
	 2CmMflEsTPVg5ybkA8DnYvogxpJ7VLPNBHei8yadzU5NSeTxSVJirZ4qf8syGOTaU2
	 OUoJFou0DWndoS709NDUNkEehZWMTz47Y73VQknW74dGFtgnbYUqwZ8PhLi+yiDVHb
	 1uLtUNBui3EyQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 14:47:58 -0800
Message-ID: <20261107224800.340250-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107224800.340250-1-sj@kernel.org>
References: <20261107224800.340250-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yff8jpuuyzmspjxczhy8gawmgmcrh8oc
X-Rspamd-Queue-Id: 5C6B12000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794091694-646526
X-HE-Meta: U2FsdGVkX1+983LlQeuYbw0id0k3ih/NG4rqF/FM3J2q03B2O05NJMAAKfPMu36YEchMbIFxgMIgG42F94OZgOId03WIsQz5vlxSHDiY06U/FGlJTtk9K+iWYYsIxp17583aYOUAuqlcVXCXCTcWRLygLzGJOpTZO+5rJwO0HdukidgJsTtsoQtxJFZrOCvkHkd2BEyEQQiXMUnvb94Q+0/djvhpeIOELCWXAiHu/0lmRraqxJTgXO/fr6basfP/T9RVKD/uARF5pg4yn0x5zzj6b1TjXZ/j23dUuNeheSnkEE2j+sXmAzchC/ofl7IozMuBfAoqgtvY9fNLKFMCrasSnOxEJOBmjpl+wf4cKMd52vJeO6+BPTvaIgvAzXvDha8hMMpLfoTdRqKtb91pDvLnu1+iS7FEAo5dk7RFx27Fd5PKkjmnMeHpprJDuz3pj7fjGXHOpT4e9DEchmyIu7tqaUcm6tshfh3xQ6h4bfzSbT64WXoIS/2EzWyGdYVjDCT5jjVe2J0He2MbXgtPWm32ALPq9M4i0BWYMv9Y7MJ/FCJaIGD3KbKBRztwd/dI64pGRcYiudLIZO34GzhUnqWhbDfyc32ygUbc+eO2gUqC8JGzgk+V3nz/kCTo7CWH5f7AaZ2EbT9dAIMJPS3R1Dvj7kznCqjq5nMKWadouW/+cyZF8/X75QHFHWprLjNidpMH9G457ZU5lGcWqxlFsvrYoHVUMswJTbAaFQ/8tii8SMD2fWR4q7hy2fNdAXpxRJBEOqIeLJH7KQ1h20fOirrOcRFeM1p81xC22krsaX55z6d0vv9eHxDaoT9Y6jxmeGZHlf2ix5a4sREfITViVDr+IMwARfKCbPYQgXga0zFmYbso5Dr5kpTB+PJunrWcV6ZeItu6BmBRuPE1dN4RvhuPV4VhF/43Nt/U3PtL63Y8T+T1Rr77iUtJaSB4yn74Z3qdRploV53n1qYJOgT
 Igf9p+7Q
 5JItKbkVhTHwBF/DlCT9KwdiSMA8592iL2GDIDvGS657tvZ5RSLjg1c+slCPuUZPUaDgA7gjXto84EyET+lPDtiP5V6wniWpd3dncmJ3KW05TaSCvL8cWWE1pyQQcKO8DdSUVA96nZRmgpZl/Je674UC+CyvvqZcjzK1yTkuo37DgbZ2Vhevl56MDB/wjDYvdd9XB+X0ReyfhDqowtlKkzvMQwE87a1RLtgwaGsGhyWJLpUdD1cF5omJXX1JmJ+aqjThxGkeTS3PqcYtf7ZCI8PAzg0A39jCA+tsau/3s1xrALpmWesHsDsJRyw==
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

6.1.y porting notes.  Modify damon_split_region_at() to return failures.
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
index f0da5cb2b88a0..9206737d05ae7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -718,7 +718,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 						DAMON_MIN_REGION);
 				if (!sz)
 					goto update_stat;
-				damon_split_region_at(t, r, sz);
+				if (damon_split_region_at(t, r, sz))
+					goto update_stat;
 			}
 			ktime_get_coarse_ts64(&begin);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
@@ -1015,15 +1016,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
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
 
@@ -1031,6 +1034,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->last_nr_accesses = r->last_nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.47.3

