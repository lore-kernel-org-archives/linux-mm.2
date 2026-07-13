Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96632C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2971C6B0105; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2675D6B010D; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C946B0105; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A65C56B010B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A0AC168B94
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:50 +0000 (UTC)
X-FDA: 84983909220.22.65C052C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C114140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="euZHtD/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	b=Ee9YA/Edd38+yoeLjwChIk1zmylAcvBDYQYxr6c4vdgw3kuzYQJDFwzvtfNgesOZUYLgEC
	r2sQx3HZ27onVgOkPMrofPuzDnZToEWrVTl3ZpWctQLpCs5hVt4vqEtsNC8p7lF+db6FJj
	ylfseyeoRJ8854kcoC86Mz4CuX8lcm8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="euZHtD/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951128;
	b=TyBTIL6n6wBxdIuOTd8KB0/O5RjOOlPolsc97pBMNd2MQ5XhDPXX4QOcdRbxRuPVAmG+Od
	emB6MqsPyGdFEFgnuYMGl+z56AMwYinKThRmVyQ1IggUSMn7EZrzAryp3AOWo4k6VGP4k6
	tAgnoKwGk3HwUdeTfPPlohktTwxQMZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F1B46132C;
	Mon, 13 Jul 2026 13:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A566E1F00AC4;
	Mon, 13 Jul 2026 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951127;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euZHtD/aDvIZBDQjpyKLp0lEEVw3YHagyScpG6RM09WNsMcQ/ypT/C9GcVouODud+
	 8p5nPr2a84cQB1FrIzkdjnfj1SNgF6FfBFCRN/6/DUUCJcZqg06eeKx0pgLwhVFsAr
	 dXkjFMa3AYDXtLwtk0Ryh6Dvfw1KtBQcIzXUiEedRoAInwPVDYv+U+bsyRJUbX2rzc
	 t4aIw4thGprKvXHV/Wz+NL9338m7P/vHz7Q9nFG2eVUctNjPMVqjMkKvAbsp8aPn1a
	 93oyYPQkCN2QrwjSBR6/heoQ+mS1s0LprpOUeKW4L/tqjCvl731WSr0tEXZHCww9ju
	 METmJcFrUwk5g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 5/5] mm/damon/sysfs: read ops_id only once
Date: Mon, 13 Jul 2026 06:58:36 -0700
Message-ID: <20260713135838.32730-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713135838.32730-1-sj@kernel.org>
References: <20260713135838.32730-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C114140009
X-Stat-Signature: mr99sixo1isqanibp88d5bm8w353i4gy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783951128-836417
X-HE-Meta: U2FsdGVkX18I16JDLy5DeQN36BskGcBzJC5M20UfxBpzluUJ78T5rSIFnvTQ8hWkOW1nL0QLQ0/vxeN4MwX2xaHaoIUiFtxX4yQ2q9/UuiWqx02JyE+IIwK6XEMrEvj2DZt5bwuju9y86VzkNl0n9tROJyUQjEulW/mby4Op91qwX8Ic0agLMBD8+kHmWiCyrW/AY1SQWfd9oqR6bM2x4TGIqQ93Oj2ltK44+nYraiGyYk7vRRJUB6ZrpWF3mc5G/BGkjx6RMl9CZnUIIPTM33KjYmHpgTz7/M2lV2+iA7WM3OOw5HP4upBkbKIu52q8d3M/sEIwp2Cq0xvcNc2x6brQ/2mKs6Qwt9XTjEFfjBfBXQM+OiMEnaQdV1FH/ZGnodLTYa3Uty9igVzg3AzACub8gBeoZnpDdyIhOPuCdQZvqTXMWzf942oNlm4s/piQJjDYUi1RFI3HHSfGzAAbvZESg+m0ipBcMq2SSen6wo3luToOGnDoj8Ora8TBSlDj9YN2EuU2wAe/C3xuwo/sKURXwjrysvdilbQV8oxamtmhTvUImgPE+SZ8eNNw7yUwrGyJ/f2udtftblSvRO0Y9AP5A0RLO/r2rjoT1NqlKntnq2W7T/t52fSLxtveOVrSHbG6Ajmx7WMu/0n14MJGkwy53sImaLbvFACyoRSaagmOJX270I+Qetr2tliQ2g2JA4ATxUzN+pgFBqV5OOAWwFq1x99m4UaiPRS0HEETTPa3gxbg6GPmETpflz+V2HDLxfK4+kVjuAZXA3NlT7nW7jhclT2jaGnTxubCY+6k19w9Rwy6R1qXMl7V2Ij4YQNfAs0d0KD0i3saOqrQb6tOO+srh4RqY3VhfsdG/tuNykDEIMroY5m1hdDi4RcZO3wcwR+QAp7Ktrd5ZUw34zHbY8gzKcroWN6qFvp4JiviMoxAtRrmL2tg4W6tU5VyeTpUvoRv+iDEZhUyYkt7Jti
 RSG1C1s6
 Z29VoZkT2jBvDOfGDHmAK4exROmlX7f2ZaG4cKlWIkEsCOUuB0ISx1j6nmASghWCR+99wvLfFocfc5oBX7RNSMZ93klC1H2TCYrxCZti+zIZip8uS4630qQ3Yj1MyKxwzMIclI3d2INDTkt0/TyV3Xy4hqRkKKWNXvDzjDzstmY7yzN7oe4hHYqlnMr0cesHX7CMyKE+8F5pJva7PXXz73x33MmFWDgIkTcAWS2hSaUy8iyFTWLoncIC5CZCjJ69k9yLQYnGXW1uPp2LFTCwAbjYKdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_apply_inputs() reads ops_id twice.  It could race with
ops_id_store().  As a result, the min_region_sz could wrongly be set up.
Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, only monitoring itself runs differently
than expected.  No critical consequences like kernel panic or memory
corruption happen.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b5fe036f78015..60a1a9e4ada34 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2094,14 +2094,16 @@ static inline bool damon_sysfs_kdamond_running(
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
+	enum damon_ops_id ops_id;
 	int err;
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	ops_id = READ_ONCE(sys_ctx->ops_id);
+	err = damon_select_ops(ctx, ops_id);
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
-- 
2.47.3

