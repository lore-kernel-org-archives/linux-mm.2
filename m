Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAF0C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EA96B0096; Tue, 14 Jul 2026 23:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B268C6B0098; Tue, 14 Jul 2026 23:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BA36B0099; Tue, 14 Jul 2026 23:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4C9E6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B32641C053F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:16 +0000 (UTC)
X-FDA: 84989532432.18.4CEA630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 26FF040003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApGedlzt;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5eHq92k38jxsVe2qYUSBxPPKXWBRjXR/oltUI6KEm4=;
	b=GuSUQkjE4eE2PIKKVaYlEQS7q3cIJ2CtMeU83hGsB11OYq1Ash2osAgtFjF0J/IfiazTxN
	fAhs/xKmpYfuN/VOHf90YgKtHLD7I8GTJCogos1bBnVVzdxh1/uaiB7EZ9ECFHYIb4MA3X
	iHt5+N9ppopK7QZonAqorxLw1tEZ02E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApGedlzt;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085015;
	b=THzoI/OZKn4fOD17TQvuGt+yW54eYL9YNcD1rTWMb6fLK5X0ePgTwxSRLMJrf5VgrgyT+w
	fSoQeQ8uvIDHH3MtJRCt8C7WkaWzS1ag7/TxE//OsHMIq6ZQeBp3p2umClTDWzFZ3iOoMT
	Dqr/niQGbkkFAsAhQ/z1++3caZRTHX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B52A43D54;
	Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312081F000E9;
	Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085014;
	bh=r5eHq92k38jxsVe2qYUSBxPPKXWBRjXR/oltUI6KEm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApGedlzt4TB8XMMtRUBW5laM9bbzhhkdz8thJzqOnktxgQs//OWRRMHJ5FgccyqmJ
	 k7/H/bjiH0ndpsKb09xLw9h25j/Rg6BmTsKDAAwLsCJaWdkn3lFo2Arz68emF1zzWK
	 ta3Q9h7L8icauUyQJmW+2XPi8PT8zPIOxqSp9WtPjwHpt3QQxmZogxn9fcxgit5Br9
	 o4WczTRKgDtfGAyVG1D0Sjz0bZGKSvRi13FFlFONO3rmh+olvMNgURIw878AEYi9K8
	 AOIessjPfXioxFtpiFsSnbGhezs+/1XXTQqfHMBvZagOS77+INLoc/Q22y9J4A36UE
	 ixzE/qKTRlp+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 6/6] mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
Date: Tue, 14 Jul 2026 20:10:01 -0700
Message-ID: <20260715031002.108504-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26FF040003
X-Stat-Signature: unj37jhwusync1rnqutxfhxsfqz9c4yw
X-HE-Tag: 1784085014-403335
X-HE-Meta: U2FsdGVkX1+gAeyLWCPCb3+w0FH12V5z81HT/wg1GxuVVTblYAaLeEtCbTDtCtFYy1YapB48MpNf+6z7v7V3xjc0mp5xVyeHMtgiJS4kH7LAhzL3scCVn5UmHkQJrp49ruIkZ1p7Fpi8cYV+gKRrjGw1rSR7XGTuUbx+bbCzQ4rBnJSDQOwvZG17TfGi/h19WXwdSM8YovftiVhPMn2m8A8C2kyNaIdKCCZSYrB94aVGizoEPAGunwBUHZA2mdYvJKFtBgUUMBdgwnYhN8gyuwXBhWozA+neYh1eP52OU5HH5xRQ5XUK6RGENCIazVElM6DvKhserKkBnzDH42oB4TKvOa8/ZjzUm9SicHT1kFIRNxXPleCWoz9gD6jKoKHnES1nTDDbVd9Tup3WU6LskqE6dAXR23vFpSGJjnfUUU/EsnY872QYNzmP7ISEbsjceUK6LuOFs0sr81poZbe4qzzN1ZXF3e3PmDV+jz7eDN25nJYa/RyQH7CKumPIylNSh+QreSGHpT+iiKZHBldwiXl56+HJrPT1JKn9dJ173nPhVke66V3pZAQQXBg34jQeB/yPh+Vi+JWgoOY5NlnxzUWhZrln7OENSkgK4A6k4Y6PNrjFzKwe/dFM3fu6m7GLAXIaM5xZXTUaS4ozvyycplq4eqImAWce2bkqFAoGwYMYu86U8K1RJQesBseDNOq/Wqj/MQXlKmrOe5PlXw2lBEtXIfy1oV+AgFFVI/AS7LkeD9L32sqvRXRTHIBpVsukhxSswiSgDTKMEmqZDPIbaeZ+u1bIVMB/e0cu2fyQbCv/M6YgV7FffD3rEtLwvu+smVQXxIwymdK/0Qy0nNLTAOamgJngLq14B1Ry4iDZ7W4PeIHnxtGkecfxzAoResEE4GUC6BDsQw/e3yL0r8Te0pv3diGBNsMhFEayCrKPic5/qFjw/b6TVPkvw/Rmvtg/rcRARlt/p1ZuFwLgJNn
 H400P3Tx
 sE1rPCP8cuFyTnB9LNPsm29M0gCxgobUcg7eeS1GsAI8c1GI5HDmHK+42Za9j+BpzZdRtQg2ix79YI2bIkAn4U9XXpYPab6Hxa0WC30p28Fe/YdHlR8Ki/2/913STZe9Z0G07WkYU+ipf3/gncsnVJIUHxykjJIJShaCM9pKqfwnLMoiCRHk7/uN6JuBInZJz3xPRDKz7b90wKM7t7kIRIt6CJ+UYA79c8edIyMfjQEhX/DR6c+xEfh88XA7hSGRzPyBpJt3ES5ccmY/2B4PJR4NQng==
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
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org

Fixes: 8d009da32f13 ("mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 65a502c7746c0..d777411f851c8 100644
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
 	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
-- 
2.47.3

