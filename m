Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A25D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25F06B008A; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF6E6B0093; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C456B008A; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD606B0092
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FDA61A08D5
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:47 +0000 (UTC)
X-FDA: 84575008854.06.8E0255C
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 571BB40008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=aGrn6C2E;
	spf=pass (imf12.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=;
	b=OGq/RJUyv/hdZwjpvr3C9rWXypYkGKCR3/6eUXgNuzVBQNC6E8wTUb4fcBoBSeqpt2h8a5
	tUcAgo1tjmgwc6z8yuf+QeYnPFKB9fij1ri91+zTKgB0oTSgQNaVJ9hXQuC9wNPGKmKveu
	aKpyfPmBxl21aRKnVmDQHJ4vrIq/h3I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=aGrn6C2E;
	spf=pass (imf12.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215405; a=rsa-sha256;
	cv=pass;
	b=MrCdRdzPUNO8lUdMIMasisqj1/kuv+PcLW0CWNKZdu9wvevOtekc8l/0bRqj9GTbr97NrY
	QnBNmEGH0xMwR2uBdURNHROBbc4y0nJFX9EBou90M1mexz+8TMwhYbyK7v/Svd6jrIT7Lw
	8ILqsqatEO/BVRgyMIsmteQElnYkSG8=
ARC-Seal: i=1; a=rsa-sha256; t=1774215395; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=a8buJwdv0fnyjXPnjSzU0NixJSLF/TzSGGov6xPpZtRpwhYiknP3yA14oCX/xca04ZfzcZcIipC1n6SOe/m/Ta2/4L5q/HfwbprilyrRCEJsPBkYcuSwiIZKmFZWl5rLDXLPJOto/VdyBuoqPo7OI6F1pxu+JQDs32fOwvaBdqw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215395; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=; 
	b=FnaVTlTVD3lyrS8yuBTC76nkhF4UlOuuz5qnWSwf2JpRr9LQl8TDcWvr++N+wqKF/42cbmTo2SECFqMztrS8GhZs1ad402f18jDBv6KmcTlDwdDkYqIPZS2GlMfxkpm+9p5OoJy0sxT7xZ82TszQqyvXRoSzw33atqHt+tUxMF0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215395;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=RHfw9ceLzpOOGcaWO7lr+z8Bam/Q09h2DMbLR9bZIdo=;
	b=aGrn6C2EndXpNqu+CHTyPqGyHeNPRVVl8I/6TRMcZa8VFCFSNcoA/GL5nTKnrjyv
	ZadhJO57jhLeaZNqN7BCi8s0U2qbECC1M8FxakENBmVcRFrjCqJ25rFG9Lc18wcVs7j
	ups7ojkWYNO0m304NQ8X86fnzi6EdhEoLhjfrbTs=
Received: by mx.zoho.eu with SMTPS id 1774215393375234.02038613876493;
	Sun, 22 Mar 2026 22:36:33 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2 2/2] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Sun, 22 Mar 2026 21:36:31 +0000
Message-Id: <20260322213631.259212-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322213631.259212-1-objecting@objecting.org>
References: <20260322213631.259212-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 571BB40008
X-Stat-Signature: 6dk841cf63xu8zm75tcuh14r44hpaasy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774215405-363734
X-HE-Meta: U2FsdGVkX1/7l23z4G1zZ3l+6FOAHrirk6/J/aWgzs5Qg2I2CHJavJomxkfEZpv5Bi6D7FFjIPD/hU6GvjZH1mQqeMPlu1Q29/GlCS0Q8sslwumCrgKEngXLUhaaw+3vQshHME7+3QP7tVf3XK7lC87jmDYpo1MVsKsjiZID0hVWP2gBEUUQG/rrcIVECR+9aE9pXXb3UcoMO5zNmx21XYSy9LSk3OK8bcP6oxz7KW6v2yo9dpu46DGLWVzQ6I9MTomOYYW3yS23e6Zy62/G4tDE6wmHu0J5vejSU2jfGqs5aGbnICiaoD3xfpjOLYfnJTTdBT1sAIpDL+w4LGrPZmf/Ek0KXFuJEOP+PMoeT0kpntCQ8r8WlEyAQNkd1qqKzk7XlTRg63nr9erYKMK/0VwtrMozc+EoXljXSPiOueHe/AqtGQdGAx5P2ocSDeHnrLiABZa7GB5XZMOnCZR/Y5QrQ49kkWpW00aRDhupUaZXgFWot2/DzgK6qaBbgNkRWXMBo4tMx+Sgf7DR9yLymuNm1xXY8KqSXaq+GuBsSr3NIiofRHG4SMYS7Fs3fP2D82M1aXHVCoehAx09oRHAQMrb8suEHp9bX5cC1hOvjp4B81HZVva78mLXiiZl4T7wEuvd6FJ9mjlN8OO4Ynci5WB4As5xunSCh5hmy57PrJouiKFIkTWuxPgB6t1RgZnAqSR7FXGuu5sDOgQpLJeWnR63mT5U2zvfJxL7k4X2hpB0LrREwuXbgd6mXhNCweV0D0pYZXZSJ12dsG+LlD14jvPPwEphL3SR1nWkcMZE8XkulUne53lIU1C7Jjp3mJKl+SpD1caFl0mBy6K5BhOl/Y5OBC/ZUcpz2DoRdefDPJzM1fjfyuwhlFFuR6XcVoigNIH0uGFK7QMqOW8vUAOwrUvNyp8Mp9d3zfj6dZBokEu3xV0mf68FBneOrGKq1Eo5hHdfU5BYUMbmlIioT1P
 Cutm3kYw
 /6DKX4gYGpawLgYGiO9oqRpVttLoHZv/soHp4cMSM6EHGqxGNWkiVqFcJEcfjRgIGJe6BOelalXSlEeYqdIE+Cy7fozGkAJhrC9uKv4QNNMhoz2l3nKr6H/DMOYPRkfCOLkoRqUP/X8tVAiP/tITWa15NR/GP3DcG99qA3foJNFMnMgiD9N7uDBwbD0Odlr+7HEyT00s7q9pPIzKHOeDvbzYOeKVoq6Xf+5aRA3jQXIqj1F2sJNY2NggFeGc5DPFPPf2dqnKF5lIxZ4j8L7T3I8NupFMjOtgGPmm20bEa5jOXyg/JNE/9KDTDiE5SGOxLnmN6DfpIWHLg8pgOnu0JbX4rMNrnZPW+iA7w8HNrhAAtdQIdqqcebood6klrUx0oT8759zB91cM9FxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware integer division is slow. The function damon_max_nr_accesses(),
which is called very frequently (e.g., once per region per sample
interval inside damon_update_region_access_rate), performs an integer
division: attrs->aggr_interval / attrs->sample_interval.

However, the struct damon_attrs already caches this exact ratio in the
internal field aggr_samples (since earlier commits). We can eliminate
the hardware division in the hot path by simply returning aggr_samples.

This significantly reduces the CPU cycle overhead of updating the access
rates for thousands of regions.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 include/linux/damon.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6bd71546f7b2..438fe6f3eab4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
 	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
-			(unsigned long)UINT_MAX);
+	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
 }
 
 
-- 
2.34.1


