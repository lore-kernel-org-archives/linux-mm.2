Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F137C982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 01:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FDF6B0088; Sat, 19 Sep 2026 21:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37F66B008A; Sat, 19 Sep 2026 21:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D7E6B008C; Sat, 19 Sep 2026 21:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 758526B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:20:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4781A0386
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:20:50 +0000 (UTC)
X-FDA: 85232386260.17.65A2E16
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD4F980007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:20:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Tmx/zWB2";
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789867249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qfxSKa7wjZjlhsggCsX4/+Bxd3JVYK4hZ/iiRjM7Qds=;
	b=S/OpagNA99jAxEVdGcIGqgETHwgKl7k+drsWY1Rf+/HaPwN84/n8zrFCRnVc93qIxRPs1P
	DA7heAoaSsM6q6I3tmZE6FWqvc8Of+n/2TnQ42+odLoqZ3NquOyi+xUXV2j4OBmVnYjvnE
	BwhYX9qNccQuRZA29ZJKiwzqLtLagOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789867249;
	b=zUVMP4NbPXkAqmb1aUJ8dS8FmAIDJJGHyh0+wXdP5XieUa1/xM5f2oD5w7PvORWA2z9JxU
	ldqooE+hymGOIvXw+JIMAf7g2zaQXP9ANrAZzOJD6w2TBS/IXhp/G7PYdgpaNyn0qy7TBY
	dgYEI3IfFO7Un9AG/eO8kDmSgo+10Dw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Tmx/zWB2";
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6JLFnQ2GqjFyzuoWv/rqBbpaJm8GdN8HP1t2XRMoARc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789867247; v=1; x=1790472047;
 b=Tmx/zWB2JeaW7F881TUFnNK3uRqdQWJd5p4PJ82KlOOCFkAx3nEb1n0r4ReYcao6WnRo91/k
 Brydf6CJSPPIxfG7T5eFJZh1vNozEDUUSLowNIYbpVPTrv205N2WeDiE6FSqWwHcU3IrjywCGlp
 LT9bjEBvLEPEgVo4vjeuJMPc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8b0a3ddd2e356c4f;
	Sun, 20 Sep 2026 01:20:46 +0000
X-Mizu-Trace-ID: 8b0a3ddd2e356c4f
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Sun, 20 Sep 2026 09:20:28 +0800
Message-ID: <20260920012028.9565-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD4F980007
X-Stat-Signature: 1hp4ewpk3f68n4turoz1c7iikk7kz6mb
X-Rspam-User: 
X-HE-Tag: 1789867248-970376
X-HE-Meta: U2FsdGVkX1+zCP+Lc3b85uGJOiDzsLuJyXKNkfWxuK7pnTIdYgGMxWDdpu7JJ5Ss9Uzbuup+XyzsixrM7DyrTgeO3ChvP8+ch0u2Dd+/lhCXynEP2uaVZQWS9L0YEOgh9MjYBIlBKWLtOAXMAkJg3lNwLFA+mw9YM9q91nWMaUFm2gQDH81akPmtSLnxcSx7d0MEw+/oWEPH+pn56pCH/+TtTW1FONElgTBnICtkGyvYNw2DQCdacL23fran5FV4ByS0gfWB850IGzBDbXlfGApdpZlkbjdAh2id+oS+m5GMBFupCe6LBEeJLLT25qifFe3c/FW76ICYbr3AY2ew0Pmp0XdELFDiOSvNC++hqeAKUn4mL65TcYA1DF0ac0oPF9Ru9zIjP6cfOh2JH/bFNjhTCtIqK55i3jkEJE+Gb4/8dJ5bOObmBNtb2pTRGk+zPWMBirrF26nDhiYIfw9HHXgIB5sAOjJCOjBR6Qvc6A0mpAxV40pn42P154wflJT0/37Ye6bj2YjUeGoyRcrenuGoFT7VN4/jq/ZbtzNt72kvYZp2iakopfSxhHQ7Ag1D3wVKEuS3yptZHCYbT/EEhyn+NhWnREXkgAcLoYBMdUZ9yK/aIy+ndhik+e0ToQOinE7qSGDlC8KGuhE0B+ysfrHz5lcVt2krKrhIk9mZFHQgZKPI5Cgogs3VkBxgqCfuOsxXL2v1Vh9E2Vzaz7KwUHahldA4nZb1whJ8VMF/buvjzo9/XfDqQuWLq5mZG1UdI7SQCe6kjcSy8AkyYnOTfPmIirAVDDMCFdzkq1Moi+rI4vI3Sm008gP3R+MNtmTpvHvRlXoXdFj2qK11jSOKnIJaSADaRd945EaiafInCjCjEDe7wyTmEyaUap7AVpxiv9A7TnhSOmWrNHw+Q9k4X9HKGvVhhBfD5oIy3CnZxy7mHwF0e9YJjkjFd8flhfhEvG3jJRxwhpyiPCFVVnI
 nlPLJg+u
 NO9hK+/47t24+FR72Hnp8+FYB+gU80zS2HrDpQzTfMvXJU6aYh4JBt8PaI/JP6KObFpaadTERw4TCbdKGjKORzFKE9/DSt/n68Sw2MjwCH/WM81tdsenlgbjrWZFeRbHE5umrwcWxWa2qfj/OqNjC+DfiGUuiZoBRMVOUo9jiPJb4rCa7bMlGa9EskPDBC9NIvfJPzInxROsN4UaLZStA79NhQq1q1f5OH+D6n8RZ+vGakLHI6p7pMzWPZ0y44gRGIEEFbndEdcsF+WtJ71uU0Ivu+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS
are not referenced by any code.  Remove them.

They can be reintroduced if a real user comes up.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 include/linux/damon.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 836353c4ab9a..6258ef8be764 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -117,7 +117,6 @@ struct damon_target {
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
  * @DAMOS_MIGRATE_COLD:	Migrate the regions prioritizing colder regions.
  * @DAMOS_STAT:		Do nothing but count the stat.
- * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  *
  * The support of each action is up to running &struct damon_operations.
  * Refer to 'Operation Action' section of Documentation/mm/damon/design.rst for
@@ -137,7 +136,6 @@ enum damos_action {
 	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
-	NR_DAMOS_ACTIONS,
 };
 
 /**
@@ -154,9 +152,6 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
  * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
- * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
- *
- * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
  */
 enum damos_quota_goal_metric {
 	DAMOS_QUOTA_USER_INPUT,
@@ -169,7 +164,6 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
-	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
 /**
@@ -313,12 +307,10 @@ struct damos_quota {
  *
  * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
  * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
- * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
-	NR_DAMOS_WMARK_METRICS,
 };
 
 /**
-- 
2.53.0


