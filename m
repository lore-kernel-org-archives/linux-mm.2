Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC40CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5A96B009B; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655706B009D; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5463F6B009E; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25CC06B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68DA41C1149
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
X-FDA: 84969412458.14.B767EDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D30D4C0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cOTkeH/f";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605967;
	b=j8GzHq6+B+Slrv6cF9izZsoQkQnwYMPu/33pGUkA4wiY/q01xzmR0/Sj0oG9vYJDBgQ2p+
	c9gjiLVrV85A/IOI48zd5n+E2TRXmX+RBN351bIad0BPnjx9Wtf4p87n3GOf0XtQo5XZjx
	ujWfY+ED4pxJKNe7bu5T+NhOZzDr5AQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cOTkeH/f";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7X699AHd2yvS5SlnZ9pQaDNVWM6Hfq6tYMt+CDq9Tc=;
	b=GOTvq58X8s7XBMPgxYGMRV+nYU+F0qEeu1+SbN+vJstNCtlp5XQkbb8ei7qqGcDEERRX8h
	r2TxsnajpgH1XBHdClfwqpvnaBsbi5BVVBUGGc33SPo8W2JDiMdWvQtQb29wo+yVt7m6bJ
	QQuQr7eQw5S2QlgZ6nTOAbs0RaP5HiM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76FD561382;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA5F1F000E9;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605967;
	bh=f7X699AHd2yvS5SlnZ9pQaDNVWM6Hfq6tYMt+CDq9Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOTkeH/fz2U74GAMLYWPYTDTNtvX7NVYSU/t3paid/5xYNcgQTkUpTDSRHvmukEDF
	 wFzfOMW4sYRVKIWlXtqa9EnUe5wT0Du+zKjtz1ALCNhqwdZj/XCJnuuZaS/ZsWLG+/
	 w2qLgBQE3qt79Y6lmcqkTs5W1xfxawY841zKpf35e8x8ylzqILUTE/1Vai+3QAKJht
	 cOTlOp1PA0vgSvyV2TG8cX4Y7mQ28u6iESfSRsBuYMYTMf8dxjNATumrPZYoREbQn1
	 yMDcwlFYdm1Ge8c1LBTvbk+15aOFyjz9zeK9dgQ4JcKvmNdHtRtZ2rp1mHRtuFafP8
	 2sxT1dnn01Hxg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/19] mm/damon/core: validate params for probe hits weighted sum overflow
Date: Thu,  9 Jul 2026 07:05:48 -0700
Message-ID: <20260709140600.90950-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D30D4C0006
X-Stat-Signature: jf7uxjimhres94h9yeayg97c81pwy79g
X-HE-Tag: 1783605967-244556
X-HE-Meta: U2FsdGVkX1+3YjTocN9Txsr70X/OcZhqfbUUybzZ9pT4T+VBB9mCXizGN3osdMdh0ClezNrre8hrytkeoERsQHlFNTs1ScS7m9rL85foTWg/u5TY5oxmEZA9xfXsE8XkAE2oBZM5zkWbvyopKbwC2xJrvxm9uzaW7ZjHS/87cLa7hLBG+nw4TQKePr6vpiQ6W6YojljUgMKMHt+1QHBqVKwfGrR1IMby9ykX317ncNkdNMowMSHXzyKJmtx2Yxs6V9TbHJUSi68WRlldZYKOmAx6UeWfDLJ0k5AcFw0aBQAI5fxgCuuN7fXtbnj8sEgUmgzxSSbejk+ZvD+Ytd+4DoXV7OwKA0BzsYNcK8/abGs/skira9NQ1fQ5haIdbFJQmuUyyMd+VXzMGqcsXp1uk26VLSe7qGoE7fVOPL3x/7YXDEqLfdDsqT/FJyrjUyva8u8Q4GvueT1ppHxuOmI17E1FjAauRiTYTrU1rPhiYy+ornNUTIw80Uq5CVH1+P9NbWhzSlypbxKBfwwaPhXOfp8ZQjyLoEs2JRy5CgA4LFZoiLYnA32wD4bHVIsHibpN0Q/IZm1yzj3Whv7OuARBJpJNXD7vraCKFRfwcgnbSFJmidOuFXa0/xXqf6ZGzAZOXcbtA9fwCjmbzHsdAIFTL9j1zpsc6VaEEf6fdCVReD6fGnujGuJ+tdn4LLV+t80qSdBa3ePCaFyQcZ5+ELaO4Um71NoA2aEr6Xl9NFzBgU6Ep1JOM2Eoxee+sAgjDCgnvPUoXDuuqepavEcpapaS0SxvNCWUM4+BvfKoJcgI+Ar67N+szp71thvAmAF5sRGn9BwGZh4DKM4l5plQrQyQv7L1f0PWZSQP8XEOP88ZoImRrwDYEtUX8Suvj2w+aW3/2TXyv35wmur/01WzEThvV9ab6rZMvBPunbCinQziPnJufm3rO+Elq+6za/tsqvq8zjh4FGIkjL8s5F6uNkK
 xuM83s56
 xdUvtv+6JYGSxJNZKpvSMELXiWdEyWbk72hZzqEcu3jCTXdOM1URgwx8B+gAWDD2J7Xha+Ba6yOA06bHUEXnQHIllQvyKCK29b1IE/7b2t3QsqYHNxvcSz/L7YxG8i/7p7wG2Jw4P/4KOrV01cRBdU/QGVGkwLlAEC2uVeKi3v7BX6eO7gcUsWOsH6KUxm08KbqBONxczbqkPrI43ZwAHCvmZVsGiDFruX6M9Dp4DkJbxLm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() could overflow in weird setups.  Users could set
the weight unreasonably high.  They could also set the aggregation
interval unreasonably high compared to the sampling interval.  Such user
setup is unlikely.  Even if such setup is used,
damon_has_probe_weights() always returns false, so the overflow cannot
happen.  The function may be completed in future, though.  Even if the
overflow happens, the consequence is degraded monitoring results for the
unreasonable setup. It is just a trivial user experience issue.

It is still better to be prevented unless the cost is expensive.  Avoid
the overflow by adding the parameter validation in the core layer
parameters validation function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4f1425e56950b..b585e4bf035f1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1335,6 +1335,9 @@ static void damos_set_filters_default_reject(struct damos *s)
 static bool damon_valid_probe_params(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval;
+	unsigned char max_probe_hits;
+	struct damon_probe *probe;
+	unsigned int wsum, wsum_to_add;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
@@ -1342,6 +1345,18 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
 	sample_interval = ctx->attrs.sample_interval ? : 1;
 	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
 		return false;
+
+	/* invlaid if probe hits weighted sum can overflow */
+	max_probe_hits = damon_nr_samples_per_aggr(&ctx->attrs);
+	wsum = 0;
+	damon_for_each_probe(probe, ctx) {
+		if (probe->weight > UINT_MAX / max_probe_hits)
+			return false;
+		wsum_to_add = probe->weight * max_probe_hits;
+		if (UINT_MAX - wsum < wsum_to_add)
+			return false;
+		wsum += wsum_to_add;
+	}
 	return true;
 }
 
-- 
2.47.3

