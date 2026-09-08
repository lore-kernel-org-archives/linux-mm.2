Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C727CC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD6A6B0092; Tue,  8 Sep 2026 09:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E846B0093; Tue,  8 Sep 2026 09:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A504A6B0098; Tue,  8 Sep 2026 09:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7936D6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:47:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15795C06C4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:47:51 +0000 (UTC)
X-FDA: 85190723142.05.3C975BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6643C40009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:47:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEm1mdvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875269;
	b=CR9v1qY/MucD6+pEgn2rulI8GjMlwkgH5aj73rv/XVm0cKXVb+PRLRVSuKhyFtzBQ2hQsn
	vZxAmCEf1y9qpkP1NhKRGPspKw9N0t+8O6dVTj5ih0YNkro0YsMxKRioN5ojIUZLuZXi7i
	v0gnzqO/JT8cUy1yUOzO/3//DeeqVeo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEm1mdvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A0+1vx5ssYACbosB5yRUtT7K9nBFjhQE+WMx9lniBm8=;
	b=qvLtoNsOfoImuD4B3mLmoSRn8NxtUw+5WQSD5oUgqdwP4VM5CB1aAkLSNNkDYfdpPZ0uFL
	qt6V5pdkxC9OPYICqk5gq6GehO7lPDZuf58sexBD6XYSOpDWVc1fIb7mz8Xxulcyp6lN5C
	Q9lvW8Zg7+mogx4V907sdqfbfNWaDUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CE4A4195F;
	Tue,  8 Sep 2026 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7C51F00A3A;
	Tue,  8 Sep 2026 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875268;
	bh=A0+1vx5ssYACbosB5yRUtT7K9nBFjhQE+WMx9lniBm8=;
	h=From:To:Cc:Subject:Date;
	b=FEm1mdvUsgl8JbaTjjjXn4ngQWgIsDJ3WlnaMSAqxVKqgSnG7Zq2/bhxpaSfntSxh
	 DXisyx9vnI26ygC2pzU0jYMrWh1Y5CAljaY7Fg7FWr7YUC56AmYoL7AqguQluP/0EH
	 Tz6W2kk2AvP2uxMTz1dbgqsgK98Pvb71PEp3id/q/8ix53CNS+oz3BtzMTKVB3PiTv
	 KXi/ecHyHZKN+aBMxAMTMiqqS6Lg2e0tBhY8Oglm9I10opPeGcQaTCxSe8CQhoCVIB
	 XXu8TiHbpx/4rwgdyf2qhb9iLhYSBSUj5MzRXg28dMljsBkKHCY114h17Qx0YMuDfm
	 ZgetKviUSsrtA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] mm/damon/core: fix unconditionally skip last region
Date: Tue,  8 Sep 2026 06:47:38 -0700
Message-ID: <20260908134739.96919-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6643C40009
X-Stat-Signature: 4exwcnimfsk59bcjx8c5znm7n653z887
X-HE-Tag: 1788875269-37660
X-HE-Meta: U2FsdGVkX18O3gxuBdZ3lIZjdAnsL110i11F+UP5AI70wlxuaiP+SFqdZo/4c42d6rZWuTSIhuM/BYegS2CVICywb2hwcwdnhIfdM4HTlOazwTJw5EkdQ/uzQOuQMq9ko8uewzxVdAFHHa4/GNguJRSzcPRwaLcZBpi9Qo9sSJWIUSlv75YdquxzboCagHnSMIDyX4CwcPgOGAZPUobszvtS423bSOkY/YhPxNNwnYxIgUU6vbYfbMObwPbFI4w6pSvgjrWDwUj08LChAcaN1PRSko/4orgXF2EohbkWzIWj4838h21b5EHKyn90m4XCzrdYMf2DJcaDJBIsS3xjjLwTX+YnMaI7/tnzbiixD6Yn35y8r2twhlDQ3J5Na6B99ubgj4zZf1ezXgPqIBvMV5DE+3A5YGVZxU+bxlT0mkF5tz5AujEfMzW+zEsqW0RpV+wRjNBXziRbsZ9J+MZ7ToT+k4t0fy8L/5RVGtQ1GXkOdJIjcor1+5H7tpFCKb7g3m06zb0ixCcnQi2jL3oCnt2Jgb/HstYs8tFmH3EFGNgY9JSLYHsmhbFvOCdkmbQMtkgILk058sufbPSCJf2VbVfX4RmuA6tzuYNsTP1uO+4s1AWSit/dlea4eJNbwIQNBR2Fxcxoc2kkOoLrUrxDROGcLuVBpxpJyDQdKr+Be6PCkLTI9cGtaiklE7vJMZUkM2G+FaDWqCilLnxDrOkz8afX5fEbhMw2pbecH0lR7uRgJGmIHZuTmGEt09x6u7J7rs7AZEa0BSRIYSc9XSrhJ/QAvm240kWg7s7dIuqVHdUP4p/M0MqJhLEYRkaZKLByXMv7oWyqY4AudvkkswSA1lLRdz9lCL8pwtm/shbu9qvutfAldS9v5GhY2i0WipG4uTGy4hVtfNGH7TZNx52jP8XQLt9K1qJYep9wmhtDIfdGGy5hMS1RO15LBVz0cgFIFPcnhM1NCNquxjS3S8V
 amSKy+16
 dF/fCpzzJmcrYpxuJXoP8W6bQym/Pl0o0iEL6ednDIMv4KtGwM57iPYS5ibWKohVcYXVEHvDwU1Rv/WZol+K9u0pN+//7HPWc9RyBvjT+e/ZxIgV1W6AsONIkvZL/gH8Gy5016RyWRfaWCM5O7BVBlwNZDzdG+qh2e8rd0b5L6zq3Hcj3iJbTGKT7tgy9j0/FeV84B5hUh1cP6WVyPf2/747MnuixF7+C9/kVvqPsBPoz1kjUg37VRbOGjtUKHxg8DrNszOybXcyl3VWHVIKB5KRkBGBEwVc4cuaS0GA3wIW2bwn8QpzMpDlJ/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can
be skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This
is because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except
the last region were skipped by damos_skip_charged_region().

Fix this by only resets the charge_{target,addr}_from when last region
is reached, only skips when it applied or cannot split.

Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Cc: <stable@vger.kernel.org> # v5.16.x
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2:
- v2: https://lore.kernel.org/20260830063159.6347-1-aethernet65535@gmail.com
- Collect R-b: from SJ.

Changes from v1:
- Simplify example in commit message.
- Add clarification regarding the severity of the bug to avoid causing
  users unnecessary afraid.
- Modify the patch code, each time the last region is reached, only
  charge_{target,addr}_from is reset, but the return value depends on
  the situation.
- Modify patch's title from 'mm/damon' to 'mm/damon/core', since it only
  changes core.c.
- v1: https://lore.kernel.org/damon/20260828084737.290024-1-aethernet65535@gmail.com

Changes from RFC v1:
- Minimal fix, only fixes the issue where the last-region is skipped.
- Add an example to the commit message to demonstrate that this error
  occurs very rarely.
- RFC v1: https://lore.kernel.org/damon/20260825124616.5129-1-aethernet65535@gmail.com

 mm/damon/core.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a360c41cda89c..7e6cd405161d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2452,36 +2452,39 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
+	bool skip = false;
 
 	/* Skip previously charged regions */
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
-			return true;
+				r->ar.end <= quota->charge_addr_from) {
+			skip = true;
+			goto out;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
 					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_region_sz)
-					return true;
+				if (damon_sz_region(r) <= min_region_sz) {
+					skip = true;
+					goto out;
+				}
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			return true;
+			skip = true;
 		}
+	}
+out:
+	if (r == damon_last_region(t)) {
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
 	}
-	return false;
+	return skip;
 }
 
 static void damos_update_stat(struct damos *s,

base-commit: ab263dd200a7a9101ce3c1374fd23139f29cdac4
-- 
2.47.3

