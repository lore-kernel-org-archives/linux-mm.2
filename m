Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398D7C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110F56B009F; Mon, 27 Jul 2026 10:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9346B0095; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA40F6B00B8; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17F86B00B6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46FA540764
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
X-FDA: 85034812674.21.78484D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF91020006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqB0cPiK;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2xw8bC2vVf9MaZ8O0u93KQ3u/CCkmohSX4z61KPWG0=;
	b=yQbX9QlcwBrGzd0ys3b9ohXxt7ALst1VwUGc6AwDsZFvuewQSxYgJVp3UGPOhvb2G/vptr
	FvfWoqCnm737fcOr2RYWx3WHKV6LbhqXwVEU2u4XNny/9ojv5IyAOxAKmMLEtvnkmE3z+A
	HYf1ngbnjI/jA3F09i3voEj7PR2wboc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqB0cPiK;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163115;
	b=KfxtsVg4Ekvanrfa/7GDbMoFp/2EgHh2zACH2F4i561pcnw+n8XeDSawImytW8dxX8fT+X
	kXh8vmKsW5+UDn+dJSizC9SU14T2D5y7c0aSc0MKrpHLQRrmwZm+4ikj+6w/JhZXm3lXc3
	vp7SOu6LaRBhDeLZAXqt4ZV4NCV2ebw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A418601E0;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4131F00A3F;
	Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163115;
	bh=F2xw8bC2vVf9MaZ8O0u93KQ3u/CCkmohSX4z61KPWG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqB0cPiKPEmEPWSVQ3CLsXgMvPtiQ1+QSen7fg3W2jM3/OfnXESVTcexHCRXHLJsX
	 JYCNlsks43cwrNhs8TkSmyLJagqhrNOBWzQ4baNPSEMQJooCGkzFrUISsDN3rYz5u9
	 eNp9gEmRErMeOmyB4r/qRypOevxUgElKpwnQ2jLIXiJzXRrbPcY1L4q7iVnaYvA6qg
	 750ZHoQtiAoUMhpLC4nmKl+PeBAxXP0qm+LwHwXQWVRZnucOT5/SOTusd6PLeXjRto
	 GMaHK6OL7ZMd5+rMbLc6TWNcVXFEBRfeJgihLUAUx9ckad+RrgFm/EXtWIZfKm3Fs8
	 hEFqIyYHDUnMw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 07/17] mm/damon/core: introduce damon_operations->prep_probes()
Date: Mon, 27 Jul 2026 07:38:16 -0700
Message-ID: <20260727143829.86236-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF91020006
X-Rspam-User: 
X-Stat-Signature: rbqqgc654njccxcwja7azarsf3mfrepn
X-Rspamd-Server: rspam04
X-HE-Tag: 1785163115-87966
X-HE-Meta: U2FsdGVkX1/z9Z9kp7OIhoVMmOA2krPNLdeA3B1FfKDPVRWtyzdzL+MM2qUp+agNpAr+ygMeoL2FqN5yFX2Gr7oxFdk/ZQkSdHBiTykyx3lRAbW5Mzuzg+mvqSrZj00dofd0CTznlsqIpPVQLzmavhbhVpPiBxXvX0W5X1888UhQM56I7qKnJHlm4d1xIYYqnb/BEysAMvK7/6INGVFMso7rFFzG7ZPWmnPtrHcEMu5omr2ql85JTX11QpAV9wlV8y+1EaJaRafngT14yPzkIfyXvmEpOYQcb/eK0oIs6w+A/tATxsAp1H321a1jdvhSwTe0tpejQ+vdznh6VQcFPQR7vsLSEVltmnLhB6bZA6gxGJ5I6bj9y9V/X2MIb4iRfGD3G4LAO3t8K5oHQa2+Ze32ruJi9qRBbqJurHn8p5A4zTxyJLaQB28Ispkn7/3Py1ftvPz6SUIP4J6brBeH4o6ORK6vU1T1MaycphP/RSa2PxgozIJfCxdl0qGDu27wvz0y6Kw5JPFGRIcM2mb85FBPLmA+T3OEgj9aqPry7545S0wbRtT4TNTwO/s0YMndF60V2BdJpsxT0XG1toNw7R1bONO6V0hHbUkqzpyX43KTBhw1kGAadi7BMnvyJtArzfunOS0SsO7DaDFbYyYucfk8hOsbe4Z8+J3NiraDzhRKZEuqx7a4VbIE30mZq/KfAQ0zISFewbkXeB1fZXWwHFwsX353cq9eg3QqxuObJPa+YmKHmL60/vZZKIemb3VBhutYoj9/V6nB2Q3JAO1sI3DRzUCzXSh6IXnGN6ughl9wUyky2CtXavzjl6FJ0NFSdHlm6FTCLfgJDNebUtcjuKvru2GPpYARofnoGTaswl8hTdCnykvJ6fcISVMoFd8Q22K7g+2fkv+iUl7BVXbjiFtJHFk1RVTBsaykRHgqNUHW1RappLy9o/d+ewD8v4dVQuil09TbrXotfz4+510
 ZplQiaJb
 vtroz+qkYS11dIw6MQibmue3hMgrym7vNwAlLZNK/L7L3ofr/bu8QSyXfcPg8IRy7V2DjHNuBQ+tQgKO5JtGg5eJZcg2rUnVCf6IRRgx7lgl0kVLashwsywQIMBFAIciGbLoyxK0lwpn6vN05FIwAHVPhlfAMw5Y4P2QRwq38YaHjuWERxNPLaoOBFqjhqMUL7fs761caYRrOpUxeVM+UPfVyg68AQbaXWqo6mS6OZ+mieLKIsavi4zY9dyVLNAOCNg8mQdGdOxVhVAcIOhAax/SxRw==
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
index c74dee56efee8..bbc3f231c1616 100644
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
@@ -3868,14 +3880,19 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		bool do_prep;
 		unsigned int max_merge_score = 0, max_wsum;
 		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
+		do_prep = damon_has_prep(ctx) && ctx->ops.prep_probes;
+
 		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
+		if (do_prep)
+			ctx->ops.prep_probes(ctx, access_check_disabled);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -3890,7 +3907,8 @@ static int kdamond_fn(void *data)
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

