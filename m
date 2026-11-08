Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA14606A32A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NIr3NXWU
Received: by kanga.kvack.org (Postfix)
	id AE6596B05B5; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCB46B05B6; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9382F6B05B7; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD026B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA5311404CB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:56 +0000 (UTC)
X-FDA: 85412997432.08.04F612E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 541CC180009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIr3NXWU;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167515;
	b=tJ9bfQHeElY+Z1i+OOFk5wau+vSw1MfPGULJOaa1rRxVQA7JMU1rYUhQZUZ3oKLx09nBCW
	oV4QkZDOxHeAPwBGjtfom9jLkBH6c3zT1vs7OoBfq/FOByDbKeJOhVGYonYgARTF9VN1B9
	Q/6xxxmaPnB/Vq4m5/Yf1o4BiBUABHk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIr3NXWU;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOx4qL3rBGLSIPXxU4NuO61z7Gu3DhBSLmuQAAlPYBc=;
	b=Vy6a2s3EGESadRcrAH0S4IdBUIdE3r5PsQB4XFyItZCHe02IIUjwu//FNYZRvKaF8kwdjl
	AsCuzev8Xb9kk3Kng/HSMGyzxIFvPzHVfNleASVPxuJwQCg6VIiuXsuRchJUsIv/FIH76a
	lxeT5AYGEv6aqOxcPy69ywwZnYiedR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F172C611FD;
	Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCE41F008A7;
	Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167514;
	bh=vOx4qL3rBGLSIPXxU4NuO61z7Gu3DhBSLmuQAAlPYBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIr3NXWUDIdw/+SRCAsv7EOx4DwRXcDU8pn2MgfKWuJYGlWoulDCBI3EwsRNI8Yc/
	 zYgvJ61JemS+pT7jxFxDClBaG8obLC8ff2gScdPW0OEwsORpvKJOGY66S+NsQUeQr0
	 ZYI5C6YtFFOopdUEQrAeJk1IwJRRe+UAgShJ6gJ6UplJbj2Y0U7IjNqgii2IgUfCN3
	 N2jN/8XBZ0nOfh0j/LAST7lSAK02ZjYGE+hTyxVLGNof3lFzpgwPIW28E2SMRd/pFc
	 m1J0KO+9Kyg8sehCsZPu6fbZ67MMN5sbAtFu/OIfgMC0ewWxDuibcCEyKiQTLDMR7E
	 8zMl15LR7qCCg==
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
Subject: [PATCH 6.12.y 3/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 11:51:42 -0800
Message-ID: <20261108195145.115792-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108195145.115792-1-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xjgrf5ds8mju8howad14nxn17mp63ix7
X-Rspamd-Queue-Id: 541CC180009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794167515-293825
X-HE-Meta: U2FsdGVkX19RLKCbig9zHXUqXo7cR9eSCO+909+FoYRchaWFadG7VqLnuFOTLI4zAqpEHLTbav2q6ghHU2LB3at3ugEkOeZRFaYq4ClK8u5OcMYjixWqZsy1l48JOmxKYVFHDtMPFDRAlbQdsxeewgx/xAnepjG0oCfRVPMUOOGPIuAinm/FV/D0fR+F7LfzlzFzn5KMwVbgFq3N9hyHqJ6Wjfq/l/E5apz0AMWR/yS7rvVJp11G1XzacbJ8VwCF6H2GjolYvrj2a9VhEQ4auiwAupjx9+6Clc/uQjMUfHvo0DIPCPwFRlXy+WbASiplJNuZ3VLc2nCC5ftGS5E7mpi0cNHgwqVJsd35PA+p+b3fuanJenBTll4Sh3iJr7VA5PTR3+NNxlLTysing4sWci5iuViZ7TMf2MLjODOgJzYdwD9pL82X+IpXAV4iLNoxF3KES/GtKHN9zNGBFeK6hJ0XmLdzhFErpruiFsTaiQ0r+11yJlZUBPqsBKOwMisyZ73SQ8rx/XkZoxw+Rpo+U66PNxsLXoObCCu0tH+1WaYrNzWdRaEkQKX8OHs8l8CIJ0OSSvJLUT210LlIXTsMaIgPJZeJHnmPAaUSh4SoeqgDmXnuE544xXROXh40QIIiULT5BKGUvd/yV+vDUWN1QEyUC6VycaoCDftzFZePLH5zYhVJjy9cttqU/KvP498Qh65X3kKTyHoUs/eXIhqLJgkZevDjMW+guUEXKbRZAEQVNBZayMf656CS/lF0NRxvTuq4aeoKHisfV/FYyUg+hsnLK3J6DOSTCwCEJytWMClE99py8FyjOOyh5RZyJQcjSnNAw9hSBTXZiSRdLkk+2BGeXjuWGZKB0Ic3SmyLwmTAlCr00ysqmu2b0JB4/kilJQE7MqlxUTGJQD9HO4Iu7t56F8Jmxv+bqFXMyq0fO6keQYCeHjbsdBi0ngDADbe4BfpOk/ILZLih6Ycffg3
 wbu0KbBG
 ZakzQUGQENeyrAIQpbfytBMYCUwwWqbSxhEs0deWSSDU0QCSswP0x0YmofR60kKA1pclephKFWY5RyiDQftzgoRA+MmxC92zC5bEzAX0COHXUU9n+HtQWnMW2rjxDtG7OaJwLrf7utEiq0CgGMH+pUBORtw9JQRXZuEIELcyfnpJlP//KV/iUTJwaQzgQkhqW517GK/y+AhaaPWASWZ0bgfgkr5i8swWgOBZ3Bl4Nswn5+kDSRpprF9HrRjDFYOaz27asuGnyaNlc5fuGvU96L73hN24/aOeETjVfBt+Jru845IWnGxAzRj+Oyl2Qg+jy9KaymHamdKNCsO9KCJlWFIpD1jfvRfo8pCTZ1S2Ye/r2OzIvZm8S4K6d67TIB+JSx9/oBH4PVcZXgDDJPOH46o5BuD3BzsHM6MqK7omH/M6DHH0vDDafv+yPsgVPoyPKC44/rG8esvykCG0eVdy1QGCXwoSq7f6u5J9X/qsBgTOSKG3z7C0oe21O12OgEnUouXxGbtXRnkNFfqg=
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
 mm/damon/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6ef77741b783b..52f01a6508b66 100644
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
@@ -705,7 +707,8 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
+	else if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		dst->last_psi_total = U64_MAX;
 }
 
 /**
@@ -1608,7 +1611,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
-- 
2.47.3

