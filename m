Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A978606A320
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ctSI5Wg8
Received: by kanga.kvack.org (Postfix)
	id B63AC6B05B1; Sun,  8 Nov 2026 20:13:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECDA6B05B2; Sun,  8 Nov 2026 20:13:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB8B6B05B3; Sun,  8 Nov 2026 20:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749246B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:13:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBD1540532
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:13:57 +0000 (UTC)
X-FDA: 85413808914.06.081A1B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5BA3240003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:13:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctSI5Wg8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794186836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fEP0Wfy3b8UPkAa4H8VbKGMy0BEcET/8qvo41zJg5uc=;
	b=jHZSiTox6v18NugL4g4QPBVqaqViyp93E6FpepCDwIFtG+kpYlo1API32CEbJ6dlcTYWku
	npDfsD1QjYcCGt/b0VBI4c/HpH/c9BPTSqx1iivHsbfshizeAOl6ZBU/vzfj7gpyxtpq+w
	Mlm/l6/9Z46J1GYr1bhviqb4wm126W8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794186836;
	b=u5KrwDEA5VGwz34P5aB8BXyv+ofLesNThOERFoAsFEC4qxhtFj3HtuCZU6j+yZqOWyYqwy
	WZ8FpWBK+Ow3TAIOe7f3Ml9TPiKh5gVnY9Fe6og6pKHOmyAsB/NtnMR05fWIyMDqWjdEK+
	NGkn74VCIEOy2l/44rMoEXyvtyGtwWg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctSI5Wg8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 909D143AF9;
	Mon,  9 Nov 2026 01:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8E31F008A2;
	Mon,  9 Nov 2026 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794186835;
	bh=fEP0Wfy3b8UPkAa4H8VbKGMy0BEcET/8qvo41zJg5uc=;
	h=From:To:Cc:Subject:Date;
	b=ctSI5Wg8d7MagOKSJaei+kuz/u3rcYDU1pvSkuqcEw2j1If8b+KWGhjrZMMofIlv5
	 Nrh3/vjcF3aqMsX2wprkQnRt/SlsYomQKhFxF0U5tyt18Co4qNgumzL+ylNk0G56Qt
	 PLg0iwI9aStPnjrZGdvmzHlHMclCb6NB01Rcn0ypBxJXNXNdSivtXtjjBtG1sNQFfF
	 Sd4J++xwyUnsgneCfRROmlc2OwbfoxH07sAGa8Kt20VPeJkuWp0x6YK01dvN6oPJ4M
	 M2FKu0k31aGuPYRRR2HedjY9VNcoCC7l2N+vL9uubS6JecbNJTPyg2xwJueuq7CDf7
	 bOvYBLV9sIYyg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH 6.12.y v2] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 17:13:46 -0800
Message-ID: <20261109011347.92467-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yy4yubby9iispuqgd7a6zqshxnn1ui47
X-Rspamd-Queue-Id: 5BA3240003
X-Rspam-User: 
X-HE-Tag: 1794186836-368509
X-HE-Meta: U2FsdGVkX18komtB2SXx7iDwLuIzH0PGSV7LGRthBB0OpPwRwXwxKiKGUSgffhBeahN/sESQCn3fjU6TBUmCK0vQA+Toy4Bwc5k57XWXjXC3P/eLwFJG6HD2Vptc0bPTsXOz3I1smtUpMB7SgQdNCZHwr3rIS0ecmNYJosUT7Rs4b3K26WjGrTF9uCw491dayF7SnTGphf/yW/VTj+1Wgw28iclfn95z6acfFwNbf7IFY+8cPA4u6BdMjueeNN3bUW9hZo5jamSBEqnzFUyMtvmVmGyk2kgMJoFt6CdXF7dyiO+jln3ZKBxOSOCYnHZyYvbaLyMeAIav7qcbZLDIjQ898vYhzwOH2wNYZsTo2w67f5eKvSGQV8nrFT5RXHYHUhMHU2WnKAe6kB5V98MEIEe0QkOePfHQTLsxAN4G8VumxC5meYPVRIBL9DK8R6aNALzdmBDIf06YJoIuOyY7aAXQSNidE/gGfL1G7c7DdGaLwH1i6LfqYNOMINr0zxUPLoxH3T0ml6s01AtTKo0FrmngP3FU5S/Y4jNIzTXc6hXOlQm/0xMT1hiz1sor/jsEy7EpRoZ0tYJEM04EjVw8sk0sRwCDaNosJpL2RI/G5/WpcMdF34iqMGD4tssgccILCkikS0BP5IHQdZP5SnfO1NGa3CSsq3eK0+cG0rd5xrI6CaboM91WDWjOawxoPkssdAkL1fKLp5DtItmxByjIOkJS51/nIxbTSljVK/f4Vy04CkyscvfNN7R33SkRhF6drjbXlynMfEcpOT2HIRl+j6OIm7afCTgpCYpGuAA6VYbrMzkCmBHu6bElJ7R/k44zTZEhk+q+7DxMFcPqATTHtgJo4tUSJIOy+T0/L/c71WPPlTHW+4XC2bJqvuuycfF+69BXvv0KkD1W0bce/wDXoMoJdA9sblBOqkOxO/p1XwYj0RU/pU3KCFhzopE4gNtS5iD398rJxFyzoG/AQ4a
 sOCuyzvp
 t4vQdx/8g9RjAkwUlVxg2ePw0JlVbjXI2W1ZkXtL5UDClJfa2NDLQQY5SDg8S8fWdvw9xO4ngxjVGq9tbQixz5wByAsvPhwtgypYUfkru8i9JHCCZ+iIIKNjYhJTMOorJCrErJbPfEKqeKB6YNzjZLMXz/Z9slVootae9lZ6XRZ9b0mn+WV1ZOBydbifZEz77AbvUakmO6Ld1RWVrraEFHy0krCVzf4R3W9J2uSR1glbzUNQYhmj5e1AEU3jKXzHCDAlS4LNVP3kMkMe0jRICwPEyBlylJTINLUokTlrLybDp4Ar0SA7jlcNqOkGu5o7WkhZYnM/5aCrm3FXbXgaZ+yca2Iw4MEarp3cKY7DUNKcFeU4RfrqhLb3yCeE/ZAyfGLb7YS6G0Vx3rnGZqLXU6MDO+gvUiNigHcFdhV9rYLitT40fq/PR7RSoK9P78oKslEq+haJj6Y88NuCJt8J8ndZyutNkF7ycJK2W+K6MZRabb0Kc3kqWB2qYv6/TErSKoU2EMwEd0J3z4UA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked.
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
(cherry picked from commit 29c6084658af41b5b1fefd873d26d441830ced34)
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261108195145.115792-4-sj@kernel.org
- Split out from the series.
- Rebase to lastest stable-rc/linux-6.12.y (commit a100533c838ba).
Changes from RFC
- RFC: https://lore.kernel.org/20261107214525.304638-4-sj@kernel.org
- None.

 mm/damon/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3142776e2e0ee..420ef0adaa7e3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -324,6 +324,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -707,7 +709,8 @@ static int damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
+	else if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		dst->last_psi_total = U64_MAX;
 	return 0;
 }
 
@@ -1616,7 +1619,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	default:

base-commit: a100533c838bab5a555d92e082e38e092f2b4ea6
-- 
2.47.3

