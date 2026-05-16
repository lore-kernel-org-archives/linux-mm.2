Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CDECD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C4E6B0098; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915196B009D; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E366B0099; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58FAE6B0099
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED59F403F7
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
X-FDA: 84774141018.10.0351EC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 422C6C0004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SK+xuiP4;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4gETZgRH8IHhb2Tf3cGq0T1Fi3A30Fp0z+5Ps5WC40=;
	b=Dap13JSXjKM/3ztGqqU6xOtvPKza7Vwq9sNlkbnYmdcjGFUGq3vHR+pkNQXMyAVTB/LyJ2
	JTixjK9oGUnyaM4Sr4Q7fEED77bqalTr1nnSPdrg+hUH39WdHtGO9Tn/WuTfhEcfJTHN1t
	cRi7+qTgt1CtgEF5HG2XFDRAMSHFaGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956648; a=rsa-sha256;
	cv=none;
	b=A0JY3QXdR6OYUAqhVlIkJDCeOWoDZfwRVU6jPBF+1FoKn9dgienuMDgk23Ejq9YIy92S7N
	pS9vZE94z63SjgVwzqN1nkcYpALSFR2ASac2WEoNSAHrXmQ4/f5veOresfwL+pXTnK5nNn
	3iyt6pRPxPPDO20rl1nslaVVvb8rIvA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SK+xuiP4;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 571EC44549;
	Sat, 16 May 2026 18:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8A6C2BCC7;
	Sat, 16 May 2026 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956646;
	bh=rRV3S8Zs8/YBc8+5AI5kB/a9fxfrWlXoj5Vu2qtKMvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK+xuiP4C2SaxDcfue3JBq/5hYij+Ee22zfOQ6LlqvqDk9kYdu9pGzHSPQTTBbInH
	 lI8AwtBpUNP8Q0J0pMNJecqfzfme9hlNDukGaab3cU/AbSBtk/PsOJshIpPKMV1ltG
	 s2ZhlE2SkmzDXMuWsK73RblUfd4XVDWJ2KEAfoXutOpRNkNuLXi41DA70efNBhp0BV
	 iJzYi8PjHAh8JJ60zu3DmBB4Is+AkFOaFQ4ml1LfexUKjMQYwM2dqol68KXNHR5Tzd
	 VgYjMPTiiFwo02VZz+uGa9qo51mxjy9tBN5v4HMzinTJGVPZ2AVZr4kLktU/0GuCrF
	 GflR/TeenGipw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 05/28] mm/damon/core: introduce damon_region->probe_hits
Date: Sat, 16 May 2026 11:36:46 -0700
Message-ID: <20260516183712.81393-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 422C6C0004
X-Rspam-User: 
X-Stat-Signature: rfq789en565a915hj5ahnec9fiprrd1u
X-HE-Tag: 1778956648-984597
X-HE-Meta: U2FsdGVkX1/lKPMDzEVn7bTGygy++2DPJnwUmAm9uLhl5ObkLIAhaZy44DxKBqd+6Mfrc+JAayZC2tf91E/BneeJG6K39hR5KAs9RYUttfIzX+JtQiBlJ+ZQs6F5B3dOn8LHpbraSAkMPWRdi44Ymd9q6XiWaaxqQTxsTImMez4RC55grF0yWY0IW+wr9LyF5tSjsNXByTkusGPm0zc7Ts6rPE3ZA0bQqY5eZ7htxqb17NO9tM0LgbFXPwciBs92alCpI1IsHLi3r/HIV0h832xJukC+LkVzoovjfT1LU429/ZtHyMwzui7Q6/RurqsxG7+jpb5fAwg4SYrRSSQB4CXVQPBPYvTX5UjItH5kLXY2oaeIgfboIk23eT4tYhrk9YYeZLiMT9U/na72HVd/3dH24UmRid2kN6NYpFacZNRK45AssftQL8qeoMzpOutSkxyHmC2LDXTt3NPRL2dTtgXqqN2DtfHzkBWssZkN9GTmFo5pQG32/1AXaUSSrTsaTuzs1zRWNnDrbvX8BfUbeh/s4EhkpwkW6AU7N9BPV3GYAdVHUiQncf041Y2l4Yqpgd9fTcC2F3NUSdTPGag/VeMaDwcycE+sJhb/UXnYElVzGiqxIj1mN+J5OvGqgbtM7UxkmBelUwBG2P0uSA/0RPmX6zt7YOAeNBaWagJ8lFxtK6EOcw4juVKn2kLrGKtE0a8FxGq4X94wmLclbMnZDYJW36fDxQWFU3c9aKJEoplgMdRiX6rlSI48LsNjknctesv99uilM6ZDO3xpwv8LRKzBS2mz7LEo1NDjrPLGSRWJFN+iWGfGGCQsovnAdC1p72KQx8jVcZFMn7ztkQCwzX6Zqgs5Kof3YtTJVF/02N7rqYjXJ056XqwUZG8an5SPLMBU9yxgyTyo0gYgli6CEUgXvpDQVXs0HKEd/R3x6ljotEhzoaFJdC08tIV1aBRs9cNg049GywZe9UzaVxL
 neuCi1Nf
 VQJuItV46BalAggQL9HvG/5ALhzZR1GFvNvvX3ufT7REPSotnKmNSsiEsyVq1mpucSJg6qdBjgLcXjiaOWhMlLaiAhv8BxgIczG1eiOnUUKz+cQC5TygwYNzLoIWxGl/QlcV/3IJ+aVRxMVcz/H7+nOYsydQJyUi9/lyAYKpqFsssJoeeWCFsDEVp/7bYBRcaenUeZS8I3kBd0fmqnL2UNn++xYkarT3Bv4fUiS40NpbZStixig0NIkYAmPHRYEuvggaZ7OCAI9zafwtVkqJLf53u/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  4 ++++
 mm/damon/core.c       | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 32005b8b1f8cd..9e70239e5305f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -16,6 +16,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -52,6 +54,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -80,6 +83,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 15f2795a1156f..e5667660b4cd9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -225,6 +225,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -235,6 +236,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2754,12 +2757,17 @@ static void damon_merge_two_regions(struct damon_target *t,
 		struct damon_region *l, struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
+	int i;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	/* todo: do this for only installed probes */
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
+				* sz_r) / (sz_l + sz_r);
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -2882,6 +2890,8 @@ static void damon_split_region_at(struct damon_target *t,
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
+	/* todo: do this for only installed probes */
+	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
-- 
2.47.3

