Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953E8F44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5098E6B00AF; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492FE6B00AE; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA6B6B00AE; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C859E6B00AA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69D8B594D3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
X-FDA: 84642857376.13.85D2C50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F7B7140002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KT/qKC1E";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830846; a=rsa-sha256;
	cv=none;
	b=HpvzLv4yhyltXyPoOVZslEkTVmOSUFZ5jWKyOC66CaJwG3mg29xVC5Prn8/1B1LSS5Eq3t
	0JUREPsYGKyCOrRWUHLql5o1kmz/fG2PNZkYICaRj9pOwRF3qrcs1zJcEQdtHXGmxe9/Ln
	235rJqtbHTLgqfBdFRLMMW42CU3Gf7A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd/ccDll4Uy5zX+wZinYLE309bjczw8Xzkcc7OKhJmo=;
	b=dZOO8DnXein/NbDkGLhsZOs/B5mc9tJyXOCbF/W6uVIiP1sdfh2cMH3amHJatNG9hnTFii
	wx1Zm8yjwWfoYEOWw7EUnkvuuvANmzE+Y3YV3YKF7lSVPFNi3An5c58BfnurDSUkvH5V9n
	yH3CBMb1aW5LVqYXGs/w6Xl1RzRMjqE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KT/qKC1E";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E98E444AA;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4841EC19421;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830845;
	bh=UXAPF6g5HmLPcR+NX9wWokbltFyqLM2XHmtP9qYo8uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT/qKC1EdgmNF/OypCa4cBbTyHfxYQKJqufzo2eY9EkfjLj/N9/9UlQrya7Y3Kfjs
	 v1xyTg9phwjD5maLmTnvBDx/w0Z1c+p6xx9LIZdZvUXG7vQT8x/2xUsPdWN5TDAP9u
	 cEHD+meJTxI1VTRC1H1uj9xKorZ/lZg4RyWWwwK6wvQPEDQs2uDLtMU1i7UWCsqtv1
	 HM0tc1idJo1ovlBgDDUAFGEcFdpedpUY6D5SHRmk83DK70Y8pvsURDaVPFf1nh1ZkK
	 MhfysZJ3UqL857JlOLwz9sIydBhNaWPARYYUtKdtUG00iBTPYVzgvrX+IVTq4LJxSy
	 7nSuz0wmY0fkw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Fri, 10 Apr 2026 07:20:24 -0700
Message-ID: <20260410142034.83798-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F7B7140002
X-Stat-Signature: trx646wx6fnauxjzp59uhccmbxndfini
X-HE-Tag: 1775830846-819022
X-HE-Meta: U2FsdGVkX18FREoZnt+CBOsFero7Ue2QGeFUx9YMqbgvcg0+xWgcjT5bEV/ZCFA3FJ4MgPktcF2pO2VeWqgM7pMuQtRbbHSqlZ65N0QsMdZqq4bebbqykESkuZYr3iOAUiNgxy1LBMqSGscko6HqyNxeu+0yQ5tJo100kIbu8ixfq5JDlgIdsgGcFaJgsUPR9g6/oFohlBZ3ukfAuyLqKJugHmxSb9GuFZTTodOiem2LLY6pcrDBqHkv2EVqGLBM/j8ezDS8wX/S4go22aQu0e0t1PhM+98t1oD4dYj5l/qS4r5L3ruA+3PyH6h/ah0fbzzkWuRLq6pnRNYhdTHXmq+Aya0/LSYAtFs43UAUHsaZ0HcpmlPIYGZ7YQYvbHcKO0S0fWgARoIbQ0xmPnlrbuAjaqcGA8UPfURlrwb4ERXpoXZknfb0XSQB1Bf57Lk4gL+ublrMIO4kCfldb3tpgMUZPahhSdfN4fKmvLGlC8dRIAPOO9gE+FkRxsX+fP/1maQ3hzpHw4ZOnVPVRlYJCVTK1kECW1SwOWCXOvaEQJvqVicctlkhCunSgT278t5qWoUQ8R0AcZo9urwgVpmPW8hxaLybtkVM04eo0oHDsuUdyin9y/4B0i15/0KRjAzYlVigZinRT+RQ1aLqWOd6Xbw5zzdVCKASTwfDFFyms/B1dyzfacC8KWOBs2lwi1zH0jph01L4aH36Aa14QjjlT+Pu4lMBiCnL0YysQ79VSR96TurBmbYyOyZNcZRKcVRzb71yEmwQYfAIlJ51XsEHQ8MabZMbS3eMI+7SwwYzk5XDekOwByB0bvmwTGpJIjYvrVvr/0q+UjJo8/rtBz9QVqIstF+ORtuss9Y36vsJBqg0DG4EhEo4Jn1+9DoKbEpcdGOFSMzY9PYv1Lo8uzHUk9SkV5cWVI5lBnWwOFYM+A5P+kO9GvvTO51tWOUOLWBOuN7YfoDQTaBbGP4o3eO
 1LB4QPOG
 LRsvT27DxkWAnsbcX7ezadmESNbRcgypcE7wv7KozZ2tBiJyKvh5T//Nyq0liALQ0WUn/163+Dv7+oEtQ1wsNrL/vE6ad6iZnXzLFcW4+8yICI5zTvFDthRPOKGYE6LZG8e8tD/ItUUVBWXv0gq9hi1JmcQrXXCPzexoCz8Z9s1R5R2I2ZX0uDBRTbhOynyMkE/0pNr5ytB7yPHcuyH5lvDYECINdFKaAv1xx6IQ57tyy23E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota is charged to all DAMOS action application attempted memory,
regardless of how much of the memory the action was successful and
failed.  This makes understanding quota behavior without DAMOS stat but
only with end level metrics (e.g., increased amount of free memory for
DAMOS_PAGEOUT action) difficult.  Also, charging action-failed memory
same as action-successful memory is somewhat unfair, as successful
action application will induce more overhead in most cases.

Introduce DAMON core API for setting the charge ratio for such
action-failed memory.  It allows API callers to specify the ratio in a
flexible way, by setting the numerator and the denominator.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  9 +++++++++
 mm/damon/core.c       | 21 ++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d3054af1d964f..5fb1dc585658b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -235,6 +235,8 @@ enum damos_quota_goal_tuner {
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
+ * @fail_charge_num:	Failed regions charge rate numerator.
+ * @fail_charge_denom:	Failed regions charge rate denominator.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
@@ -264,6 +266,10 @@ enum damos_quota_goal_tuner {
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
+ * For DAMOS action applying failed amount of regions, charging those same to
+ * those that the action has successfully applied may be unfair.  For the
+ * reason, 'the size * @fail_charge_num / @fail_charge_denom' is charged.
+ *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
  * target memory regions using the &struct damon_operations->get_scheme_score.
  * You could customize the prioritization logic by setting &weight_sz,
@@ -278,6 +284,9 @@ struct damos_quota {
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
+
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b0f673efc53c8..f93f107bfb9ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,6 +918,8 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	if (err)
 		return err;
 	dst->goal_tuner = src->goal_tuner;
+	dst->fail_charge_num = src->fail_charge_num;
+	dst->fail_charge_denom = src->fail_charge_denom;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
@@ -2042,6 +2044,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static void damos_charge_quota(struct damos_quota *quota,
+		unsigned long sz_region, unsigned long sz_applied)
+{
+	/*
+	 * sz_applied could be bigger than sz_region, depending on ops
+	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
+	 * the region size in the case.
+	 */
+	if (!quota->fail_charge_denom || sz_applied > sz_region)
+		quota->charged_sz += sz_region;
+	else
+		quota->charged_sz += sz_applied + mult_frac(
+				(sz_region - sz_applied),
+				quota->fail_charge_num,
+				quota->fail_charge_denom);
+}
+
 static bool damos_quota_is_full(struct damos_quota *quota,
 		unsigned long min_region_sz)
 {
@@ -2112,7 +2131,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
-		quota->charged_sz += sz;
+		damos_charge_quota(quota, sz, sz_applied);
 		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
-- 
2.47.3

