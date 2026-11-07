Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E664606D82E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oL/zu0XQ
Received: by kanga.kvack.org (Postfix)
	id C92D26B05B1; Sat,  7 Nov 2026 16:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43B76B05B2; Sat,  7 Nov 2026 16:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31C86B05B3; Sat,  7 Nov 2026 16:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 895B86B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:45:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A8BD16037D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:37 +0000 (UTC)
X-FDA: 85409655114.09.E2FAAAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 73275120004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oL/zu0XQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jg6uYRNhV7mTrgb91kiVKd41vY7ff4cg96iZM39MthE=;
	b=srlhUUTKSjLJF6x9Su5qiO6CrOThNAuHD+EaP3Zgk+cWHJz9QndQ7SjRoJ3PrFUkArZbOt
	hgP26ec8+Dx8TfZZCjeeVw2ovw4KFriQotvQ04EfPRpHbulgyTBpsTZXe8MJOzPOTs8h/l
	3JAROHJ+DQXJ5vPPnyqaCkcF7ZdOr7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087935;
	b=WyNhYPhPHzm+MEWahq2b0yn91v3JNF6zt02vUFM4b+JBAFtkvkyhvdOxzfAhw3G87HytVC
	miNmSfD7X9dm9mnxDUExAlsDoXWho3v95Tpm//ov44tVd5zVeVkxOt2LEetuvSZJdlcVr6
	WHgRB1gO9ldwGmEmohLJ2kWEPEXEAlM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oL/zu0XQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C56CD43DFD;
	Sat,  7 Nov 2026 21:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A641F008A2;
	Sat,  7 Nov 2026 21:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087934;
	bh=Jg6uYRNhV7mTrgb91kiVKd41vY7ff4cg96iZM39MthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oL/zu0XQFZaVfByvORZm31uzlL1kH9iZIQ5kdPtCh6MIXLDcb95w1Y8QfuHey5/fQ
	 WfhE2Uv3CrpUZO+yBgilHI+A9zN2eQu0oO+XijYO+CkTsztVUvrk1IphCLlJMRhJAl
	 2vaqWMhpdt0KQGtAmmC9hAjskXzZmnJWJQfE2OYLBCEIklZff4LKXlmY3T3NlnyEbd
	 Ow3TNupoUfoJNfTIYk6CfPqgZibk4yk5G3uXFZax64L8sS8i7UvdGok6ElA5k8L8So
	 g4cKAtJ4K7aIaKIvNjizyxxL8V6ArKR6vfrs1oyxLsRcEBNdS6qsvabpy2Ni4MTslt
	 PlTVyKZIQO6KQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 13:45:20 -0800
Message-ID: <20261107214525.304638-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107214525.304638-1-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ueeucoqsjiomzkmxnawd3kpfokzt5haf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73275120004
X-HE-Tag: 1794087935-524418
X-HE-Meta: U2FsdGVkX1/GuuDSWL6HIyj/jiVNVdZSR2UGdwbmf+Q2p2FAvUJZp3d17BGNQelrfgz1LpAZuonwn47yIEUpJJeFk9v00TMUrj+t+7kgpgrswv7UnH2QR1JoTu63e2NsJVAxOtKAAjRCVq92lMxOBaa26fvrIpKhpMeiPpaExX9mIs+23v0jY7dSB3gPQUd4YuTtvHATsHFeiwDstY3OCkpI1lH9tbLGifRF6V3gA1jYXRNhObp0/5ysJQfxwly47dEWZRY9yc4+vaZSjGc3+GLLdND5P80r5ICCvV0HnYDWC7UoFx/npf9N3jmtJcDneFxu4Civu/5uX061c59jwedvFMLjp+ZQqIFfN5nhpZ4xAsKQ9f5D25naVX7Fn9iaWl/1Y5uwz4yt+8raE/Sqvs1r7XS1bsbXCx+RTgE02KwQqp0K+xSt5gGNigbqTHw3JpBNdHMkhh7y9meXnhjmOH8asshPQ2QvEVjvK1dABGKjy/nJcMb7aTQY10kMcmXjEFd+aXUou+pgCsuoapoLCE7+8TWRgkE9G3ILPdkez7aPbcPU8DjNWxaHj/puoP1eKHKuhctvmIsj1oDEPG/ILEi4xxUMW+7sCw8WR2CZ/mVCtx3wVrY5XBsVwYicAp01YoGfj+aQ72VpvDJiTZoVxTeGyYpGx4f4SRoTCzA8xygts6341w4YV8gTdA8CP6u0fnZZOS4e0NXfBUtZF8rF8Cmgx0F6PYJD0MB/AjYhXLwIB7sns2BcRpaNIBkQqnkwBy/jdX3jJuIyJWJ0ew3cOjSl/x3JcSpAQqGTOGdbWowaagAt44qzLIkG9dwBGbFkIRKjjVg+Nst01QkhXg2NBJY644rxWZZ+sKcRINcTE0vUPVJAhxdf0pc5SaS8bzi2fsy0S/GgeN9lumVZ3i/Tso4M+DZSF1E27FPGjSmioenuZJ2t6hpbYxaymjvZqDss92XYA0ULrg7q/xaZkc3
 NYftjxdq
 rxFhIKgyeK1Ynb0ANY5K3QDMinG5r0riYRDIk4Kem+fr0DSPUQ4CwTn5UMExbKRlucoaxZkTdPTaipCBYchIE/74G+QYjtOXM/obzhCW+kD1VRMlhqHEkClL9fPXj9qvzoBIgrupFc29Z70zoie4pvorp3maSSxl7xh06ksREUkJnl+lIuE46uzTLHBUQaW+atVKZ9CSA8We0hdjL+NNeE7VPGR6ohAkrVAmeM/N1/f/NjeqgT3RlVXth/EgMRw8O2BSxflbvU1Av9zkyLtXrbXpTIKqrY/F77hUjvZ1ESucz3NgotSKo3lLpWg==
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

