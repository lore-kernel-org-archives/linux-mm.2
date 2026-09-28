Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9803C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B626B008A; Mon, 28 Sep 2026 04:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4432E6B008C; Mon, 28 Sep 2026 04:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF2F6B0092; Mon, 28 Sep 2026 04:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F30916B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:40:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76904A0142
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:10 +0000 (UTC)
X-FDA: 85262523780.08.40B5F8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5C7C20004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQundLEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790584808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2+vyI0uwtaGYfGHMp+R06X3EoG+48/p3c3tZsMizMc=;
	b=WJX9KYKp6iguq1mtsdBrPERLtUbJIPdaqfSMhjUgq4Vuo8BIoAkYYDZ+p4khBd2X+fjYAT
	UOJgabd7uGQ8cqEVZnGARBV3i/0VLRPiF039upbqSPeG/YucxNcGC91zNOCxtjMlfO0qgV
	pkXSszWidWRVouBNOC9H9ob11TE2Ptw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQundLEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790584808;
	b=7lJ9fuKsbnr5LhC6xeF+OSAPVMNHrmv/PxkvV4BXgsFkdpcrkvz63XpUxHfzv7e+udaAS5
	mcPyOzO0ztom8TEFoDZMjaFtGu/m3p4/Hi9M+NAI55OXjQeuNYhEY9TYCNJ9HjoUhHapaQ
	Sxziyu8FgJ4eCimtAb0zn2Esf8GbmM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A3AF6022A;
	Mon, 28 Sep 2026 08:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C44C1F00898;
	Mon, 28 Sep 2026 08:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790584808;
	bh=q2+vyI0uwtaGYfGHMp+R06X3EoG+48/p3c3tZsMizMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQundLEGOu6eEO8jgqUlI3iTPgbXb0YJUuVytRyOzpsjHNI3GcMnvJTabitLJbrOI
	 eBCebOAUV/giTUc5XmMurZJuv7k30PCk9SE8MLnr4zfRaj0DlRRvAVL1EKBPoQbaAE
	 UPictBPKmuxz5513dLXvKE01tjijw0lAqGIDQJFvoLJKIOXW3WHWpqPgzfq/Z7EJmv
	 qj23PI/EZd1IaMtYWgslqLxDXrymgWPi2VwM5MKcuLJaX/+aMarEDByVadiBg+gYuo
	 Ys2pvIoq4T6/7LT2K1rNCglE8/DgCCT2EbEpt6pgYEJR9TaBW+8UTsU2yux5J/Ouhm
	 ASxtiPKjHkLlQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Mon, 28 Sep 2026 01:39:55 -0700
Message-ID: <20260928083959.4030-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928083959.4030-1-sj@kernel.org>
References: <20260928083959.4030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5C7C20004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hx9sj9ahfjp34p4x5mcw4cu6ag6psju3
X-HE-Tag: 1790584808-130
X-HE-Meta: U2FsdGVkX199fEV8D9sFtLjXXhf5mOqXrqTLbXva3fSn/zYCuaITo4VddBiWBYd1gfSy3WLrpO3gTlyXlT7Q6o8wCpUUOJnPT8k4qP2BZ3e6huqTuCAIEtE9T/QaGOmiLLY7F4zYq126vTvmWMFcv6QMRIfcXG1YWakWIImIzO1aAmadLO37OYPkKD0RaSpgMn5klnYd7E9Bslc8HxyLloyTD5GHu7WQ4NNttBFQQ07A/JDfP7u7SXaq511PIBpYMzhobjCc/lDz3fGGIlkti+M9D4kUGoe+VuZMjqTRvyhr92yBfsBganRqJe33icRXLWWhfJYA6p37lV2+K0vkCkydsTXiB0FqVKTPioV0IB4Gfg1gav1c6sGkUBlZyV1kRJzsKmNzP4LUqHy1V5Upnl/VqAL+4G/rbZy7L2Zjo0oVcQlJ1oTciANlC1hSC+yI7Ki+BPkk+6mAlgYYNn9a4ducSzIYu/6Wf/AEAIxWaU6DPegfnYqA+BaEPr6F7aVTi8mUyt45LZHf5Osah4EngWM9bZuadB90wsZqIlGmii0DCc4APuSvor7/2tMTpuHa4ynojl02jQ0KB+FXfCEICkqFuYgoEzLP4fc2IvSD0AQIjB0kcEO1qQHTcmSAnz6m3gPLwIJ5T1caXwFNHMya9K2Uyo8Xw/xx+w/gQlfjifQpiqGzU/1H31QJ7yxm6R+SlqM0uAwU3lDD0g/iBSttwbfDFSPxnTttb8KznDZHS268oUnTeXgiht/eWhbVRFqyyn8BVOhvGzmlTk3GMe/j10cFvdU0q3TI2IFDMY9wI2UblT/aF3qXzlka3z9dYqK59MbTmG4L1p16FSGmSObFm9oo5PVKFrWT7aQaw9R+xr8Xe/BDDWGpyLJ3Ip0QJb73UzKFAvO0csmY3Q8uuzXVw6TmlQLwopdTOaLzr+XLi3snGPDvcq0WstaLwiY31LYMJt6fmwYwWvPMAQhu9LD
 5g0VDZ6l
 seHG7qfjdikKdoWSwhpC4V3Qzyfr12m0HLOpN/sIuy1OQuU437S5Dmtud/Lo1GTOiY8VfB/n9/3w3A563uG7xxIfQJr6RmXxGNSTalZgEvF7/DoPlTlzfAhPIq3AzmWOaSLQ/aWRad0coY79MKX24benA3ZfJ4lVKwyKob7Vs1z58CjBfrw145yaSAb2NIS4/vmGRBRbmxtzpYEXm6KT49l0J0N1s1RQTh6f9a7fSHhS71D66RjbVzE7+IdijEOarj/KFjn29i/HuhYvQibkpSYx9Qw==
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
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260920012028.9565-1-zenghui.yu@linux.dev
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 include/linux/damon.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 844b175120f0..6a29dc2ac8db 100644
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
2.47.3

