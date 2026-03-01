Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9B2FD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8396B009E; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6CB6B00A1; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D737B6B00A2; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADC886B009E
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CE5113B912
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.19.BB77E55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB2364000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awD+wgeY;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvN4Jfj3z//9NPzBmcPPm+BAzS1gyEqEJKzXFsTsaUY=;
	b=hQKU2CdhKc+EFiKUSpWoNUmGMQJBKUxFdEExVG/yLPDVcyOA36JsTbPcHy8YCkr7cKNi9E
	Z6E5fDd0vg45RtIgjOR1QGTD+hfto69YqgFuQgiEJB3qNTfndjIFWJsMYC6GE8HXeFhaOc
	SAjtcrtFdchlspKLmuFzT18rOLqajDI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awD+wgeY;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387012; a=rsa-sha256;
	cv=none;
	b=0CktRsE7LsDuQ4dyKcbRFJ/SPkuAxcsijMn/AOZnooXH3s4iU/rJbddJI1ISYFTAcKd1EP
	GohZP34SmilU4RrlayKjFH1oUvapexo/sJoHGWtvAyq1skSa/Dp/60zX9Ijz/7EdYGaLWB
	ibQpI5fH8r1HC4UQGIxstJ/PMpP3ogQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A916E44477;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EABC2BCAF;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387011;
	bh=mPwVqtgK5FXF6rtx4eARff1DBvg92YGlSMSnRp8dVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awD+wgeY2fdQRhwsH8LJvXvq7v/Lq9nU+S08wkPrKt6smF7TQafJiLWcLfBmKWjPu
	 AVLaVLzmq3IXbsfioes75WoiTrIWkdkkT94bsal5ZqejbVdK/WB7kWDL+ykLOsXvH/
	 r4QXI5wQCF9fwfYDqBLAPxwKJIwjbpYEcgdQegVxGbmE/a19c6xGggJ5OdxiodE+VN
	 zaWc5qn934v35fVidvaoQT7TBVFFJXrJAST2QeNB6oPiV8Z5XbkOsc6sztFwNECyzg
	 T1OgDj9LoMyInlvSFG3QI42Clv83YPUs+XDnbZdkG0QwQ6Ek07LLhY23nKVAAdZXm6
	 uYw+M6XFuBCjw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/10] mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Sun,  1 Mar 2026 09:43:16 -0800
Message-ID: <20260301174327.76849-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB2364000B
X-Rspamd-Server: rspam07
X-Stat-Signature: os8snciqxbh36fhwfr6dqfa4t46rtzd8
X-Rspam-User: 
X-HE-Tag: 1772387012-384638
X-HE-Meta: U2FsdGVkX18YkIfk7KKddWEAEst2VwRM592we39U8w0RipRq63GBQo32zx9wGmeyyB/TBozq9HG+a8h+uQCOOTdQQo2uDqK1PAYiUyVwjUrpoW7vrpZxPqSxmRvhdgjR+z97dwcmn+sF7u5GgZPku8bwCosA4uNfTaxWbt8iO7av8tB0PeIhlsSVo3y2mpINSYZQvAofvXkhmQvvRse4MXhWoLZHwfR7Rsf20pAYFOv2YUo4g7LBuL+zv+Z5R09mn4xMy8tsmy1KSenyNDcXJ8ghbj2A+lZTRRs7SZlcxWjp33EB8kE4shbYYNJCiCLLHyPuDSgZmK1fSyPRKVZfF4J9bxmwdJDz5loAuKODC/PojokqDxE107qnA78C/w94mlphqlf75Fx5KG91WxOmqwWaT9FN3o6SArVfJhtp5c6byiqHqHjVmY/+XZNVwAO5Je3Q2fHILJlRyTftC5S+0/wpSQmuiHjSkbV2KBrjGJY5NqAzwcvICJybYyLhdp5lukBfWrNAmZ+cA5L3LEWsFcCoDxPGhLMgamas2LsJF3VGZXF+7JKpUhxgDoVAAQPGgSUIOylUt2HSQ2TtvQ+aCd2FLjdzQJe1jnT5KcXvuW+FzybOywL7lPW6mt7W5P944HF68Gkip9ZLcRcaGYYYE3RH0xxxIpAbq3rfuLhv7cLr1SJwFcmZdZnUXuFsggYg4zedMfWhp0iGfh8nGAZjI69Qdd24/2iwuF4BG3xu4p37P30uHZNmkfzSQkusMDWHi/9kbG7qH56a4fdd4KN5Nqyv7xEJ0yj/nyP89FQIJuOqvp/GcUm6BzTAggcDqBYFvoQTMZOVfSA3ohki58cGsS+8MFMALFWyrJi4ENadzSMGdofF3H/GRlL0lf7dEMN5SnuguHpThsWISV0ccH1SWqaoA8HnJ2oC05cGdFTPznYNGORqdB3FP59xMxv8nclPQEe8aiiUkZGyWqknegb
 hkFfO0ku
 t1o747XAI8MFSb2ca+6cITJLatYcy3yv4hsaA1G4aGdfSF2nOFmvqWhskHwcDE3U6RJplWYLLh7jbydILhVQMnWVjxRXOCLnJJWYdX1lwAyeEObaOnhkURGhoJXi6fu75KYlxsPDDGz9MSPvW14UlDGQS8wwDmytb1cQdlD7r2Esm6QSsrYIae03SsRu2t3j9t/MZZhCvl74w/P+NmmSBKGYr7HxPoKuBo5aps88Npn1z30c44QwUqZIqcNn347nt+b9agy888GOFtkj2nCO6lRSahQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new build config that will enable additional DAMON sanity checks.
It is recommended to be enabled on only development and test setups,
since it can impose additional overhead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fce..34631a44cdecb 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_DEBUG_SANITY
+	bool "Check sanity of DAMON code"
+	depends on DAMON
+	help
+	  This enables additional DAMON debugging-purpose sanity checks in
+	  DAMON code.  This can be useful for finding bugs, but impose
+	  additional overhead.  This is therefore recommended to be enabled on
+	  only development and test setups.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
-- 
2.47.3

