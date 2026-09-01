Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618DFC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C686B0187; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3BD6B0188; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAD46B019E; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C32C6B0187
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FB63140416
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
X-FDA: 85165264800.11.1B9CF45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E69D40006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPmxm92b;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiFpyzeeZ8dXbIxeNUm9NHfmBqlBoJ0Y+FG8UIsF09c=;
	b=A4AJsGEc7RrzYNqpSbkg8iGJ5eZghjLmbKqq/B0UwKpbmJd8NNUbHjv89SxqbLIcVH8iex
	KSmSKFS3N+G9alzALm2LHsiHVYJnx4MrAj2fGzbeu7QZvXYF6KSyngqsSrXKFE918jTiiK
	JKFglPkmoHHpUEDzQtwb/XivBiTp1BU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269118;
	b=i9OkTDpKwwA7WiwNg1xnYtLyJmwsul5O51Wd/2QiksVv0t5IQmMsh1D1srxf+BWq/jk8Eu
	7AGX3rFbbR6VTir87WKF+7L9lNy5T/zzxK35sRfH1dRA+zATgZHKP1/Vnfu4qGcOVYPyYJ
	Lj4e31jWMCpuDbtpckCNcdrper/S+gA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPmxm92b;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC4F42E91;
	Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0D41F000E9;
	Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269117;
	bh=SiFpyzeeZ8dXbIxeNUm9NHfmBqlBoJ0Y+FG8UIsF09c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPmxm92bXxmEWPYKR2yygRYwRMYLP1oZneWz4EyJVxtKpYyuvsNwMtL9Ak37oquKl
	 tL9PkkCNZKBIIdVpm5OoRP2/4igWlZDouWx5PchABxKMETnJN7+eLEJ+GozAIh4sL6
	 wvInedonXzZoMEG0A7arJfiL1+wRPPHJqaaEuZkvF8f495aVULlzWxh/Tm6yPjjJYh
	 HN1LREfZumaHW/Z/vp3oYpHo9WYeuCO3J6tO/F3kreODG3gljIteMATs5p9lvCJocq
	 Ofww8eLJWsMorZbpzu3s0PfwpIQpuuAFkxAmXnZiEHky6GqkH5Yil20ybR4uQ/gbxO
	 Rk9u/oPzhiR+Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Tue,  1 Sep 2026 06:24:54 -0700
Message-ID: <20260901132506.99243-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E69D40006
X-Stat-Signature: p7h7kakmbtp1ucp8r8ap68maqr1ia6gp
X-HE-Tag: 1788269118-946964
X-HE-Meta: U2FsdGVkX19Weu7CvM3MtZC4d1VQ5cA5fFf5n06EvRmtj2Hnp9sPAzaK4KpDDWy1BA4xZSJsanvH7G3UPPQswyt0dXS4KiIOMnDdj4+15stnAmMA02Q9yHEYwec0JsZIUxbUt7mcExvgq4+BV3Z9a4MpohRzSWJCoeTDVUiXUDwSxyYX75XZ+FcD0qr8M4r4rb+vskrD5pyaPV9JxYURM5/EMmDZ7wrKbQ4hbjNtSPfczelyn3ySMHjODljrK+OYqu7epORGe3eC7PTaox3j44U1LHZkm5pNhu3uSCbkP7jQyLQQ+rDzlnQJ2PVNDbarfNr1+vbtn4SjuiJF2kZr9Jz5ahenkk2DScQWwCTxo1N7A5KLS9KQ9g+zP4+KZ49VZvwK96fJ/jvJZAe9U/ML8AP9JehaVS7kS6DR1EJTq53oZu/Jw0BRlOD0ZmhPXuopFXSrNc6d7y1ME8f3HBNujOPwUPpEsws0UyXPO+Q9mUej73k8hgjoGuMTXYFsg80RNUniBDgHKrEQaKu31soAXl6VrrQT3YWaHMn5IDielgSFtB2p3mQcShdbpzMlcumsQr5xw98URiPe0ExRw5ftB2qdwmgQcIMhQE5UtD9+nCasFJmBUt+EfDkd8c5i3fvIa4rLXciY2tvHMZ47kMsHPOuTVkVwSgRJeIiZbMlKNbPP/0ywliMu59U4m7v6P5KkA//CK+HMJURQiyx4dYSgeiiPPPYT4jQ6GNAteSGpdAoKou8LVZ0tPWwQjLSp4L0pwQsatYjL0BQ3VNEDPycBSXI+S7vYrgG1BpPd1pmeSwQlweAGm5WYGWDqk7hvnlBuFA2muVB+Qx2LX75asylTTWs1fsTyAbD7akgduywlN4h+3s4RJpOUzG2Sfm/9qWD9G/Lj6OgSqPZm+jc8HKDoJJQNauX1IItM26Vvfi+TC/XV6Ju8wvICpIC1ASWS25JkZ8o22VTFd7jIMNsOdhc
 TWZ9Xcv4
 qR6K10DlUGfj3j+3z275nDwichzLUgo7kXFAxZEBXmU0kIg4Ab140f5U2l1LPDLkUsx1qD9/LnuJeZHair25O/sLPGpzTbbpTkOSHakIt7Ubb69L+dJVeA6rMV/3HNpXLishTnIKfy/vUiEFAPWLi4xQFbPiNrkdBp58roaJ0zvTm2c+6MQ+mYwEcfCbzMsSfTywdDRaBeWI3Lz7Am7IwQR0Ijf00GlwoRUflSzlS5R1dajhkkovBSJh7YBGh+LYX/0RYbgUef5uPEgdG6Y1itgXUKw==
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
index 1780c14942e63..871d26adf6ae5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @prep_probes:		Prepare applying probes for each region.
  * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
@@ -657,6 +658,9 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @prep_probes should execute required &struct damon_prep for next &struct
+ * damon_probe applications to each region.  It should also set
+ * &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
  * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
@@ -679,6 +683,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*prep_probes)(struct damon_ctx *context, bool set_samples);
 	unsigned int (*apply_probes)(struct damon_ctx *context,
 			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 87ac428358ec0..df22621765911 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -157,6 +157,18 @@ static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
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
@@ -3906,14 +3918,19 @@ static int kdamond_fn(void *data)
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
@@ -3928,7 +3945,8 @@ static int kdamond_fn(void *data)
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

