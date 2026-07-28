Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD283C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA386B009B; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2246B009D; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E306B009F; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 543906B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4CFBA1295
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
X-FDA: 85036864752.27.BD31184
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3125F40004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bvAy/5wc";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iMGONrTxKF9K4rx67zBl5qGWanzFtUrmQIoQVAkWTA=;
	b=twxwEzee+hDY6Obc0lmdDW2USUX9OQYTHLut17RF5606tBdc/c12JvyZMVo6BhF53y81Vp
	rvA/PvSKNeBo7SDlo87pt0/7T2BC1l/dU9oh9e1MmIxOzQ4c7cdyZj1Yh/GzqCoyGsPzYb
	HMiESU0agjWvAPJW7NBAIEpF4orL2mw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211975;
	b=4yw00n3mydy8580PM4hNFKxI/O+//4iGLbFGelFYY3Q7DkAuyBOZv8g32iFxAI3ynzGdcs
	GQZ99/1zKt0vk7hKVlTH6hGpFEMTOvKBzHmRxUjrnfWoAb5u0PSbT1fVuroyrjf8nui3uY
	BEo/zIc9uOJejH8NraTw9vI1V+0zetU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bvAy/5wc";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C595060A6D;
	Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546771F00A3A;
	Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211974;
	bh=4iMGONrTxKF9K4rx67zBl5qGWanzFtUrmQIoQVAkWTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvAy/5wcxVr+voBw3danpLK2JmlUQsrvMqPswGDDfWY8kWEGsG7CV6cKD9AEnYSUc
	 4GrsWElHOvVtqhv8oxPU8PxpXUdTjMGPZNrUCfYPH2lFL01ygygaUbMx/p+vdPhpjx
	 OMwXmQ2xDmLyX9Y8IjJss+1OoxjOLO2lkDk6y+GVlJjGsbYqThb9X6qfBWIpXCEnoe
	 gnfzJ46PLD5sJ9fVhUKJhami9Ebxu5u79Ewijb/cz0nWvDFxv5MRbzSwl8mNhXJXQd
	 qlaqjDZutdS2ErpplHNW11RSA9jA2n+tUoKXWWAibQKYfrSIr2RHmX+KdeEeugbbqU
	 T9qqA5lrH4+SQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Mon, 27 Jul 2026 21:12:28 -0700
Message-ID: <20260728041242.187380-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3125F40004
X-Stat-Signature: qmm94um3eudzhe667jy37qrdwfz3ywak
X-HE-Tag: 1785211975-482284
X-HE-Meta: U2FsdGVkX1+H5+XSI0+EsHt8IGdp3Mc9zACdWUCyuQxbC/RHBmGp3FkTpuFfsSTaWxRSlDSLOdwODrtduuJuYy7VKQoF7yEbthcKptgHkjAEpTieUI7CX5nldI0ZuR5nGxCDdPDsQaBP/VX6CV5IEH1Nr1gLot+VXswdYnuDviEuoXJfb8bsOLtxyCTDlp9I5S8h355W0CdkG0qw54QP4u0U0S4D+AMSwBneQnAIM+v9QSMZLkyH3fq5DqouAYKjzRix51bGFSWIOEozOY8IftHGDcLVH0u1O2LK7Iwin4JnTEock7N0VT6dRkjOwPvu09aBnyoy2T6+lkEy8+TMIdKjsux38yLI4Rzd3iJszJGnUvxQdrYDG1vrhWyV0c0lyWZpPb1cRvbpUjhyWIzdVQu4mXuMJqJ853+JRln48nV0mi0WPPcbkou31TZCKGQFW6zoJ7DX8A2UQU0TGUH0kcO4pwNp+anpp9lgcnPpzZcQv4Z9li5ny0xasgRAJ5K3HSLnxXQlqeqB+vpKcDO2RvJXX5/cggNaLvSLvPlkMiWUPvwHHcSx6akcCbub30XxiTmiyi4CWroQIPTD86Ko41aia2k8WR82W3juX9KOY9mcLj3Kw7m9aoJ+8Mb7A64OZ4wEHJlkc4rO6krb9vMGj/XkVhexPHRYOBJJ4zk6ywdxCPDWfM2BHvF9Y93dd9pdUkTyCrbxa+gYJxZDLdRnQNfWvnzo5OyMsKZsCooHxdp2NbC/OvZtf//n7KzZpbUfH3Yrq6I/2OmGgLqO/v42gcXUsoXLNRUFXVaaHBCJ2VFyN58AHyMIVmyooV9dfdhXgnl6J2Woezow1Bn5yczPVLZ9c4cBTIg/+xFELoTZMc3zEihiyVvPg9Ky5nYw11U0QGXRLhVVthKRclXWZfNo6frno97dBlnq6tXR9v+/I/rFGJBr2Q3srrewD1l5CXo45M6o7WiLoI1DRzsSkGQ
 y0Z3xqO7
 GChHN4Y7nkokjqXPOAVqcMqCIpQCPoymNUgKw9eMqe6QsUdQs8oDaT2O9ceECKLCNqDsp0YIIi5n+659zx3wUXkTSEHjdy0SsLoE6F+RYB4PtZzknbj7kp695kmp/0r38lJUY14xxGuk/U5Bbj7tx7nT3O7c+E1EWScWCyoXkiHvgqv6ObQ8y7MCwFLdegHyVHrSsI+0Jsoc5zu4BENjui61ig42fdXmHNxsIyZBZLAKVCzGmINmr7zxmgd7zbz19MvLwpE+sn5umAlIm7A9e+GZyjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_prep needs to be executed by the underlying DAMON operation set.
Extend the operation set callback list for the execution of damon_prep
actions.  If the underlying operation set implements the callback, DAMON
core executes it in the monitoring preparation time.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  5 +++++
 mm/damon/core.c       | 20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b86744642c9d3..c6cbf1edf331a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -629,6 +629,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @prep_probes:		Prepare applying probes for each region.
  * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
@@ -656,6 +657,9 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @prep_probes should execute required &struct damon_prep for next &struct
+ * damon_probe applications to each region.  It should also set
+ * &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
  * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
@@ -678,6 +682,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*prep_probes)(struct damon_ctx *context, bool set_samples);
 	unsigned int (*apply_probes)(struct damon_ctx *context,
 			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 01715648f6e0c..f7c9b94b6436b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -156,6 +156,18 @@ static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
 	return NULL;
 }
 
+static bool damon_has_prep(struct damon_ctx *c)
+{
+	struct damon_prep *prep;
+	struct damon_probe *probe;
+
+	damon_for_each_probe(probe, c) {
+		damon_for_each_prep(prep, probe)
+			return true;
+	}
+	return false;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -3870,14 +3882,19 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		bool do_prep;
 		unsigned int max_merge_score = 0, max_wsum;
 		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
+		do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
+
 		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
+		if (do_prep)
+			ctx->ops.prep_probes(ctx, access_check_disabled);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -3892,7 +3909,8 @@ static int kdamond_fn(void *data)
 			else
 				get_max_wsum = false;
 			max_wsum = ctx->ops.apply_probes(ctx,
-					access_check_disabled, get_max_wsum);
+					access_check_disabled && !do_prep,
+					get_max_wsum);
 			if (get_max_wsum)
 				max_merge_score = max_wsum;
 		}
-- 
2.47.3

