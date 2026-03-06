Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C40CFCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A64A6B0089; Fri,  6 Mar 2026 10:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F9A6B0092; Fri,  6 Mar 2026 10:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F56D6B0089; Fri,  6 Mar 2026 10:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFBF46B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB21559844
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
X-FDA: 84516022248.23.C567EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DD5BC0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDEspnsk;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKevFbhkOf8A9ZeT0pK0WDaeKElkKXGjpfqciF9rJBg=;
	b=EkyQUGDqEJV82iXbuGTSq/Wz97QbV5THXPW/Xnb97h2Ll7N2cHNFxpeigjSDeA5A46Gmk/
	jUGJTY5VpeEsmZEUmkp1A3xRo2MJaxmaYEuraWbrdxwUZ2jER48wqQcOSYzsKXSY3TouMb
	ToKWTVmmEcw//wwuwfcCou24WLiUUxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810963; a=rsa-sha256;
	cv=none;
	b=cGAOpRasfmZY05PtyGPRvfRoStnTS/f9BWQd4aS8xU3LOyuBQeMI+r6EdPU++WjFbpIjTJ
	VoZtqNoNRirkTRsjsP1fW4TcLWKvJsNrTI+F37y7D/QvRdscWIjDXcfMpmjbQx2DsTggfk
	9IwbQeOrRAXHjTTVAXKrRV5HpFSj15w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDEspnsk;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B878360134;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576B0C2BCAF;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810962;
	bh=BNmBp855yDuZHxGokx46EelosP2pYBbR2PhSTdYtR0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDEspnskaNEi9nA0EiGpws7eiJ4ZKcOygic65UXT0LnFrQTn3lBb6SH6fraYsS3mv
	 0WFYE4+sedwEG7jybwDPXo/ta3KY7kGYO/X5RJEVMlSqsbDh0X81GvkbewH6Ycv4fB
	 ENyIDVPA7gBCOnsI1X4kaA5StvU/XR2i3q7G+V8RCzTPeR5ertDm0HJ0u9fjkQzOF8
	 80jhLQgmROa1oz4tIHOkQjlTA8dxZzosw9XYeOxjyeGZT7h/rBpwhdTx4Go1lEf8Vb
	 f1rVcaQasQLhQ3PGIFBoCwO+lMg23DH7zixHH4JVollqyr2f3mxhfQXG6zXkqZLNTQ
	 ZjercEiL6RlmQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:05 -0800
Message-ID: <20260306152914.86303-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x6e5irrx5iosq8h94s3jbyfq8n54qp6k
X-Rspamd-Queue-Id: 4DD5BC0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772810963-175970
X-HE-Meta: U2FsdGVkX190xVLZf288b9iBYoUCtZgt4bCPYw9ZYMs59BQnbO2RlFWWRl7anslwmw6DR6fVIuda1iSieIsL4iWs3hTP5xHHMU9FFX5Uvcqkk+VgVWVg4JTrpi2q/QYVSOWP94QMm+LOpAzEcOBerd6qTVrrtbntwaTYnHorEAqMf8O2tR40/InK63FmWN3FkNmkavCrgJu9GJKq3Refz5c3Rx5vmDP+2CQMNVvdxLL783kCWs/QgUQfcVskebslTVf9qFyfKk/jDlLpvEN2wUbjinpNrDLvxPYRPr1hWdRZMS7BqrN5QLm0kzGmGhbqOB6RRNG2qVPDkHC/AlBMbANMinhQIrqgCmi+zhySlqmbiem97nkIg3Wz5QWOU1qGyVMBiaKx4spLPAXOwRTnvRHPF7ch/sPU3IJRyegmGQMZcMEbGCD9D4E0kNBm367vn3kZ7wc9RN5Oaqwcpt9OJIINmiehUaVxgiV+VbYyTHNfhpl03tDJzvMwHex7ooXzlR4vr0TJYN2sd9tdDc0ShTNoq+URz8g47IXgUgYK9bs2jmSO7mZRyN7X+b28/fdD9MWzdSi+TQyAcJIZyFIg5euGWWMPGG3OZQMFqDu12V70cE4sFxFCp1ugEyFU1FTuMXqgHTs5djzM5mDvMe3CFj1anzZD4hVrdIHw+4Inq3KDBKfi3KF/5OTDjhOaU68k9RT9iBE/X1dAk65mz33voLYY4eNT73TzlK/5OiDDuZzA9O4KsBBm5a1KxPuhV0JHFG5wbmyXA5v6G/SqI3+tB4s+F52+GM2pGIPf3SpUcL2MXr1eD/Dh+BCuVBk6lqMM6nkbuFQ1QjDxZHwz6SIaAIcGMdLoU7Ureb6w/8xHalCXqbc2khfsYZ3Z4pk3xDLGfWzYDgH6MXHa4Pc+V5yGoKhxLhrRtd6afEFLeOFafqBOk4/SuVg3tf7Gt5hdY5L10XClFOg9nbbFiv5ErZO
 Sirb13tr
 uQDS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_region() is supposed to be called with only valid address
range arguments.  Do the check under DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f1a97e85824ac..0c1353164ec81 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
+}
+#else
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 /*
  * Construct a damon_region struct
  *
@@ -118,6 +129,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
 
+	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
 	if (!region)
 		return NULL;
-- 
2.47.3

