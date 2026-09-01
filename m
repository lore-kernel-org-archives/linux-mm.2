Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151D8C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD586B00E3; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB196B00E8; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BCB6B00E9; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 000956B00E3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EDD6120344
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
X-FDA: 85163927100.19.C66EBB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C68F840006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1B7fSKm;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiFpyzeeZ8dXbIxeNUm9NHfmBqlBoJ0Y+FG8UIsF09c=;
	b=cVP1glH2MKbFBOdKcgdGFW8T6o/mBodBw9ZaET50bWYkuZWIedcltECGZL+lhDxziVL79x
	weWhtmcdccGpUT52FBeSzC0vJlxV3u1ex7kAEgk3htWT1jJv5uN2TT+5Plc2tkozEOPLMm
	IH6AFllPecfm20FyYtxzBvk9VX5tAJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237268;
	b=mz11rTRl7AiBuYXNs9NXm47Xa4XJv3Bw7M56CSNdHeFc5jSzp0AB9neB6BQrxIW6p+j3QJ
	xs94hCd2dnhiFaiq7pWGr+B6O1JTipYg6kvrRJvrlIu+oMbNoFtwBtPbhov8uYg7qHN/HY
	9bJouSu3YTXPYZIKfu7nOEO6dAKub04=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1B7fSKm;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AA51601DE;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEE1F00A3D;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237268;
	bh=SiFpyzeeZ8dXbIxeNUm9NHfmBqlBoJ0Y+FG8UIsF09c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1B7fSKmTaevM3gSN3pxa/A4LvqYOlnjwJ3SjeADvPcu/2AoBiSvSzwPkeO2u+fRo
	 cAw5M9nKCSc3Pefqdbvhbh8TLwJfUf00f8x6X/aLjJLLtpNGQaOG9OZa9AVr7OjBxy
	 StpjF7+1UWE5niicDG1ZxDWFF2pVwjZgX13EujZROsmqMqy3vaqfvB5uFzB+2lyv/S
	 U+u/6luoPJGFK3cdBg4uMQ8hysWhcv67bq1bf5H/PFVSyxIlSYiFFmkEbzYCllUr6F
	 Ec0VID+YzaYS1vtnxY15Fv0N4O49lhkYrWDTY8lb5wQecxRgYS5xevtRFI0Q/hwHxI
	 17aCoeAfO0dEQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Mon, 31 Aug 2026 21:34:03 -0700
Message-ID: <20260901043417.2165-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C68F840006
X-Stat-Signature: 4rxkdjoojpuq5j5rg8jr3rx6zdoyxj56
X-HE-Tag: 1788237268-678210
X-HE-Meta: U2FsdGVkX1+4EMSgLxcIVdZeIbT1JwBuNmPfjP2F9Z729EqW4V/HG+e0KF02ZFq8Mdpciys9WMybHgWuiUuShgD6KfTxFbJJt2Lf/Fs/aHH/ItVoX8jO0YBxrbVhVjnPrrUi6T97Q3aQRJRsqp28fMsBrl92Bp/tUyhKTQWJUdrMxLwML2Grs3001WTy4f5cunaWSt0IqBhRgVzpQHNylUCevjloCbl5vEUpP3AtwpYoN549ylOcN1BskYeK0aK+pOD45qo4/2H1q9HDjQWoSkUaobgMnTEV9BO45NsKwXBd3Cv+IzpnKzFU+RPUmhUhq1pTBz2P9PcFVHxRjKbM/lXMfxEngMiXE/ZhxE/W4EbNCSsphRQVdsFx1nk7kfLcwoXaJ6MoAp1il0Z/yVEtWEe8/UGvS/c1m6itWj7gOBJv9OkERePk23/3rjQMOM6SYv4U9HhhQ/RespPWY8DZ31UNvr1DBhOxeUMEKpclz/lzd521OIYeiwEkMxtoNn9pv1HZQ7FCB5Qshil/A2TDCFFAkcfNtr/Pxunl+siRnpTI9DvqzzWEFopqM3LBXFZx87AAxHz3/Krphhlf7dDetr4UnTZHobfT1U9tH2fLdfgDB9eplH3i2EBmFT6I5augCG1BalSDYaV/zXTmqCeLnSuaciIsn5YgaELfxOorviJm/SZMvtwvyKbBNGkhXb0WyKYdmURSWLGoyO2q5I+umJoLWOEinf8+i14qxAmaebLM1Q+1MQYjLTdwXHLKRKu6/2XvnKI70PvGrOosgco95qhv7BZ+h/+6dERl2M3lEYMDEcCOfQvEsQDzbNaNU2wdIKZl+v8e+D9y8aEp3sK2EIpoS2VuW3eauDbImwvTT3i1W32hY7TUEhipz1EZ18FNjoFD4VWD5qWhHYuFFLyrbqkU+6OJbF2KdEiKjCYttkRGYZcrOsHDql/jK4a7PpSwpQ+2HjfoBpmW+6AGHFz
 m5tQrcAh
 ArknhM1ixldi7n1ES62Gbuovhi5+clbikQ3CeP1hce2SVujIZ6XfVE9UrsJqFgToO9MAima7HXFBcNERAIOj6nGO+PIifkdqpkkwlRTdjNGAoH7+yOPQnqezUiV5c/0XAzN3hHUPuwqqiaWZHJkV6CQaYvVQS7hR+IVnAb52DpxS9ti/Aj5gltvBBh26b8qwkAo3cOOXqyC1g5hZr9LvqrHoh7Wt5XuDwPBxRc4TG6ip/18zC6dIZP5WMSHyJddYbCVfSuCGBGHZ2V8cTdUsw1Z+EFw==
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

