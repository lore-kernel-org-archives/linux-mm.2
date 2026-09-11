Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7B1C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988FA6B0093; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2826B0095; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6CE6B0096; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 289DD6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EE60C0696
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:41 +0000 (UTC)
X-FDA: 85199709042.18.F086AAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53C25C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MA8n1J11;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089219;
	b=d1Ebg9jOOnYvCebG+w01qa5ouCdaZd9xc8diCAkMt1hWAqn+px2q3hOYdYLdPbuaKa4hlI
	/0JkTJMdmqTuw2DkYwqgHk+caclyeqjmPcqE+CXChgx81XJYZsVWqDwVu3BLDVv0IuCdmT
	STctbX0UpwH1BwDn1+zJ+kBdto61h4w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MA8n1J11;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8SWQuWvWu2mDr3ZPa1cO5y8fbw9Oppo9ANwQ11kECE=;
	b=qt3KXgF8I2QIwdYjs+mchhkEoqCvj6/XGARhTLManlxsxhZV5Nf5K7jChWZhMOS5h9SiKK
	oClvZaXdCj/NTY3ZJIvCsUZ5vheAtEQqK5lI2e3qwbjBxQNzEySAiNEQiCrNomgx5vpB5r
	X6Yfpp7Tk6P2SCGjAOm8YmGYUzzXAyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB4CE60204
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A6D1F00893;
	Fri, 11 Sep 2026 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089218;
	bh=j8SWQuWvWu2mDr3ZPa1cO5y8fbw9Oppo9ANwQ11kECE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA8n1J11Q+N453pKNit7qsK5N8m3xsD/WiHIm1bYiUNfAtBL9TJl+eMtw24ru5EL1
	 cakIWDwPlXCptF4UsAX7P5KTwmIqBh8OFy8A+bZZqFTdCvXZWWe70HoAOQ5Iv0EvZy
	 jlMOBWy17LWZDIYp93GDUXP1Y4oRawKlOVvORwqK+JzNm+JA2VpM53CLmpsUTpKY2h
	 y6GND+wLVryqKyy2rzfGkY2Mx9s6y/n3mJny+1vKjLQTFVZfl+//WovOqdLPeKnD0z
	 6iNCX/b2scJnYCJTW/DDxobJBZ/Qx5/4Dvs6eMLiPC9xtzxyt1TexVX+zKMGC5tJ5k
	 GT8FS3GM9Huiw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Thu, 10 Sep 2026 18:13:22 -0700
Message-ID: <20260911011330.93678-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53C25C0008
X-Stat-Signature: fwp4fgpa4amcqfnymhm6da3f8ejz7fwp
X-Rspam-User: 
X-HE-Tag: 1789089219-174590
X-HE-Meta: U2FsdGVkX19tS/cbvXGLJinxwylL7ws9wvpAh2M6z/Mm4zT5tq9T3ta5vz95or0matjqfIMaQdcdqgyapFwU68RtJbM1zu6nUGkMjHhJP3Oo/H5l5XRfX3WtpS4Gx5AH+3B2FYSrX/6nLEZg7mGML0/4jSNpNFMfZumafjQmCulOUAvQxE/MW2Z+gWEZcEwt2ZnCiIBaEhhsL6C224xgvFregIs/5adGHyRoLwV9YVSQzz8gXAikuFKOJW1TeQx9J9zNV5AlD9s+tHpszE3ToqJggucTgXlGdPB6GtiIaJvO1gr4fDeVG8Glk1uNoef0DIWB/MEu5Ny49P0oOYMCgK7fTayPlYkQAtjdwXSkGbwRWzYgMaGZEgTnxgcwAA7J9DFxULuznkXP4ndahxjpYLPPDFOK42mkN9SMEAlAO9vk1gJj+JXZtpvyYqqMpDYBUKmIkA3UtJD/i7RmGmA4Z+eOpHzD+Wfq+G7cCdIzYS3L1WqJ30tg7kcO4zfkznrTha/mJ+Xqryz4pHJMuQLUu2NwY1DCEzBAMGVIPUfZBKZNtChil85umTP+yxb626ajrauT9f7jLjqR17GJbdhQJ1s6kHOdhdvermOobiWotqgWWTZ0eNIVcXYo4zYVwQ0mxN12sKQHrfLJconrWCHiAb796WVPi6iAwDdkKAVjMJdgo3RQTim3LpC85KQTjM1Au3ZrR8MCDLm6d3HocC5+b1aOw8tUY1qtiXEAUTN7B4U8KwOCxe1YJha9oWObdIHKHPXxmFc11uLTt0pTxm8ekho0BTVX4ic/rl5WXYgokJG8kC2wWQn/hC8UyNwqOjxK7yvhMhyij/OF2eL1nAt4OvXJJfTxqJ2ka84hJiLc1eApE+ouvoWEAYiJVbYBD5/k7LOmFbQGprYCE/VH2yZj9LsHaX3Ng/xRFz1OJw4oltoxd8ZrliRu2V6JOhJa5azClPq+ZmfHlzVZ7y5x2kP
 13WyMaR2
 yHjrO0T4UPoFledAHGGb2sO9OnfFzhz4Foy4nwy/6/f8voBOmMZyf7mo0gECplxLC3THphdyMrA3DsEhbI0gCI/+6Zl/VqrFAP7YrwUm0coH7Dz24PBEqj4W6Iiy0+ZmN8NSH2GamAHqe5kfBp+JdL4gAJPomMCKQYEQ+aoYTsBB1O0UdrhnEhdEbK91jP/H0gVHt77+uZuEDnV+nXxPn4PPUNq4w0ZFiMvUk3HUu4NqA/8sq8cag0fFbyAPUC006BwPgW57SLzNygm31RKOELwlLefhODZdKtqZTMrTeRlWHRZ4EHpwD8BvKN26P1+DXDahqTcdHemQph2AoKIKfrhwM+L2zYvtvDpLt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON kernel API to introduce new DAMOS core filter type,
PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
target regions based on their probe_hits weighted sum.  For describing
the filtering target weighted sum range, add two type-dependent union
fields to damos_filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 871d26adf6ae5..ef99ff778ae10 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -399,14 +399,15 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
+ * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
- * are handled by the underlying &struct damon_operations as a part of scheme
- * action trying, and therefore accounted as 'tried'.  In contrast,
- * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
- * by the core layer before trying of the action, and therefore not accounted
- * as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
+ * damon_operations as a part of scheme action trying, and therefore accounted
+ * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR and
+ * &DAMOS_FILTER_TYPE_TARGET filters are handled by the core layer before
+ * trying of the action, and therefore not accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -420,6 +421,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
+	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -434,6 +436,8 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +454,10 @@ struct damos_filter {
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* List head for siblings. */
-- 
2.47.3

