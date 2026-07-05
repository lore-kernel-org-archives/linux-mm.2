Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995BFC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B856B009E; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E546B00A1; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4033D6B00A2; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18F146B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A9AB1A0140
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
X-FDA: 84955174374.26.E9B8FC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B4AA140005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ak7sUkQ4;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqypLn7HBMPm5n3CjY0saNzxrJSnEmu/vZcmx6jzwgo=;
	b=GtkgPnZZoXTQw4PL3xlBXqJhk0Ypwm4N/v56s7OrfVNey67r1hMCSbCk3YJ/fdjsVCdDL+
	ufA+GPumKzMijGMDXloa7ttam0fEl2SB3sVgDbgdRS+bXDjmgqLAd3biSkhvYD1Yjst571
	N35vyDUFJ6Q12yT8/0UViTsbSKYuxG8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ak7sUkQ4;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266966;
	b=o/P9jeEX/drTw4tcDoUu2r9fYTLVogi/CJBDO1qRU5VTlGADtRDvSXPlBrO7w9xgFfyQwi
	Mh/EVG+C78iyuD+Q/SFuAlHDkHAOpE9uUVgfjkH+rpGcEHVOgzQc2PjTIDMUxeGUGkADzM
	KtsbItueGIRn4NppGhqR4sS85xKZUcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 758CA61389;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066F81F00A3D;
	Sun,  5 Jul 2026 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266965;
	bh=AqypLn7HBMPm5n3CjY0saNzxrJSnEmu/vZcmx6jzwgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ak7sUkQ4wVZTIBJmrbqmax34EK515ywicFzFT5Y4soPvpvK0OuLm4agWT4ReH0wl6
	 oVlzrPRqYWsZ8cIMEYvnYdHYAdL+EUpW4YSPFPoiX/8IJRGHngwipqq0Lw5wi2ECxP
	 pwD64fmLs8oFOC7pY7jPFcZ9ela8TAf8IOnSfr0j+eFKzQwEFlENJ7nJe2Lcu7C4gw
	 jw2wpeWqpnM9gYC5i0afcb7Lqtfw9cCYXvzhpbLARU0mi6pJiPCRQkXs87Ro60Ohk/
	 dOs9EejTTyn+w4hhpU8qfk5vRY/c0Y7pxMce4ajHU0U+xLEzjSre9n+q/5yd/mJdTq
	 hJDiOvDmG8lHA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/core: safely validate src on damon_commit_ctx()
Date: Sun,  5 Jul 2026 08:55:52 -0700
Message-ID: <20260705155600.96555-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B4AA140005
X-Stat-Signature: zeyg4bj9efuxkwqwriq87wxzjmnfxwp1
X-HE-Tag: 1783266965-84186
X-HE-Meta: U2FsdGVkX18g8+Xgl2G03Hhv1rZQyK6R9ANlmgdxirlnOgj9PFPqa7uEC3QYjTsu0nuFueCuAUEdxBZQiBUZZkBRVZjUrQmrd7CEUP13CEDA3bgkqbWP7OtdMir6UTgUBs8r8VR1zK7jEOVt2stUo/FUcCh6WYIZUIlGiYzlA4peHp3oH28BWxGg5HhjJNeiHFNM3wZ+Co0FxCHrsawXTPRkEvgbHfLqqWmlMq0CTXANCXx05zccwBfye0CgjIH7S84O4KKcck9MUEbbwLGEOoOFaRbWF6LbLfx1KsKRr5Az1MeQO8aCTDicngIxJgCn7UhMYtgwq3bBxVDNPjJcA7hLx9tz6zwWKowUhgZ/SoGtv4NknCgJ0rVB7mUkP9Xke+znDn8KMpNODJrat45lDNUDM2XobhsLd4qQGSjc54RvKtbMMKghqqq91V5r5sbCUOv4cEB35GYry9y9gZweeGAnIsSAid3/8o9o6WZqNLqi5s4hXHiXtul3d4iH6MgK/3B8Vi2G37p1E7H2qqXhTo60PxzAYYmpPmSVwM6B6Ub8zoNetO4pK+p0bgxL73I/eMngLzlG3/oZfvP+350tIsMMaqBaugPx6f+2gvzfFg2QGFiCmlUcYv/R+BeJlImhGPopDh9zjDlbpP98TmOLJGh4R2injUlR65vbAkRSzZ04lvg+xjlOygIm52gPgjRJ67sbfuimx28gXbHVwpnJ+STnKenExUBvyGDjYi0DgsBVkydcePaVMq6iuPgW4ZlLEDFRrn24C4YGVl/SrgwxKsZ87UtCPX1napXuAbHboX8mQBtqbniOhaQDpW5FQnms6ShKEics+qkFSq4POq+65RxhEQHfDR3oyLNyipnd54CBSqjhZBG4eJQOupnMChVN9q6Feex4JYH2hrnp/s5v7rIp7KVQf1uURbhEGs6p2MTJkv/9tBxJwOcO7OnfiIh/+31Y5Uksc29vNBkgimL
 rk9MIkfL
 oPBbHDnvVDORSYkshdhDTvy4fJydAd1l0koEjEFhFID/d55UNbLFmFVw8iCZyo5agooQGhYBcqOCYTPDmOsupdZcpwGlId5Lejqpi3WPc8GlnipoM2321lEr+ZkTHT1OQEzFrCBQTuvNKAG1eCkq86Yb8pk07LSpcmVRF/6rqJR8pQ/20uxA412a97TI2bmYH8Y7/waniKDqv/j6lKqP9D7/icnJLDdwMSAdowj4fq/ymoXUAdrYYuWNvsig2MMWKCnbJWinlWYmiyATfRBh0izYtMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_ctx() does its holistic parameter set validation while
applying the new parameter in the set one by one.  If it finds a
parameter is invalid, because some invalid parameters may already be
committed (it is called "commit" but not atomic and irreversable), it
stops the running DAMON context.

The callers of the function therefore have to validate the parameters
before calling it.  Because the function already embeds holistic
validation, DAMON_SYSFS reuses it in a safe way.  It creates a
test-purpose context that is not running but mimics the running one, and
calls damon_commit_ctx() against the test purpose context.  If it
succeeds, the parameters are considered valid, and a real
damon_commit_ctx() call against the running context is made with those.

Other callers such as DAMON_RECLAIM and DAMON_LRU_SORT do not expose
full parameters to users.  For efficiency, they validate only the known
set of parameters.  The efficiency gain is arguably small and doubtful,
though.  Meanwhile the maintenance overhead of the multiple different
validations is clearly high.  We actually found and fixed a few bugs in
the class.

Update damon_commit_ctx() to embed DAMON_SYSFS' safe and holistic
validation approach.  Callers can simply call damon_commit_ctx() without
worrying if their parameters are invalid.

Note that damon_commit_ctx() can still cause an unexpected stop of the
running context, if internal memory allocation fails.  It is arguably
unlikely since those internal allocations are too small to fail, but
theoretically possible.  It should also be better addressed, but not
necessarily a blocker of this small and incremental improvement effort.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 61 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 871c6f5257c9e..018dd5ff80324 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1664,20 +1664,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
-/**
- * damon_commit_ctx() - Commit parameters of a DAMON context to another.
- * @dst:	The commit destination DAMON context.
- * @src:	The commit source DAMON context.
- *
- * This function copies user-specified parameters from @src to @dst and update
- * the internal status and results accordingly.  Users should use this function
- * for context-level parameters update of running context, instead of manual
- * in-place updates.
- *
- * This function should be called from parameters-update safe context, like
- * damon_call().
- */
-int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 	struct damos *scheme;
@@ -1732,6 +1719,52 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
+static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = __damon_commit_ctx(test_ctx, dst);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/**
+ * damon_commit_ctx() - Commit parameters of a DAMON context to another.
+ * @dst:	The commit destination DAMON context.
+ * @src:	The commit source DAMON context.
+ *
+ * This function copies user-specified parameters from @src to @dst and update
+ * the internal status and results accordingly.  Users should use this function
+ * for context-level parameters update of running context, instead of manual
+ * in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * damon_call().
+ */
+int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_test_ctx(dst);
+	if (!test_ctx)
+		return -ENOMEM;
+	err = __damon_commit_ctx(test_ctx, src);
+	if (err)
+		goto out;
+	err = __damon_commit_ctx(dst, src);
+out:
+	damon_destroy_ctx(test_ctx);
+	return err;
+}
+
 /**
  * damon_nr_running_ctxs() - Return number of currently running contexts.
  */
-- 
2.47.3

