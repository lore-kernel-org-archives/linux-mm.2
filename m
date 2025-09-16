Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEDACAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7910C8E001C; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742608E0001; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658928E001C; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D21F8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C75E1A07FB
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:25 +0000 (UTC)
X-FDA: 83893698210.20.E2559B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6474C1C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGZfcUg7;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gUxWuvt7VkbTVwQb57v8Jcz3w98hUW0TAOpVZItUfk=;
	b=Wx+Y2UsGgxq376DCphej2EDekNrB4ZyeF7PZ68ViuOlpfJ8cxtGDstEIqPPc6PwKAor/sA
	rAJhuXeFK/gBT9VvJTNq+ppwTwuzI0kxwZPOTNpaSu6n5BDQvoAuEuB2tbv02PbCFX7h2Y
	2+kDscxa2IlVRugAbi5wDYyRJBKGKjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993723; a=rsa-sha256;
	cv=none;
	b=HEQvNQ5vGIW+AgnYhQVMRc5Lnc74P5brPuOPX+YJRBaAkNiKLAfN1lTGy/kk+U6r8L4JXQ
	pENLOxbSVLWPCHDuySMA3jShSZlPGTggHyknAbvyzDiSsr1GoSXWKGNlybDpj/pmUvpnXT
	4swnX25Do8Hkwp22Q0hCtARBdMMP91g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGZfcUg7;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49E63438B4;
	Tue, 16 Sep 2025 03:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0846CC4CEF7;
	Tue, 16 Sep 2025 03:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993722;
	bh=2demp7SZfocNtJOdY3h9yRpOtgZXlewJOxyAe06bXV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGZfcUg7EYIo0PMGPLm0zQMT++5sADBSnFLPvKL/Xi2D9s8FjnUMCJZ93k3AwBbUN
	 CTiePydCLnUhLempDvgCh7ZKz+gs55peHtUSLOLR39RM0HEcDxJbCsWlHnANqGXmvm
	 TP56I41Myk/vI7UsifpnKAi4Yl8T0i3gGwtkGoV5JW5PabKlafetYlWe05pNa9GNPo
	 2W2+P0Jl3cHihLfzuLCNbCraB6DgnDTlNcfda12wR7ve8vW4xDksqYWLKK3NLD379/
	 1zRtVoBZJVkI0KPvNSjb3nJTDoyCzv/xJZmroq1uzljEq6h/VmmcubJ57FnghDbvOe
	 sEpknD+Vbb8hA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] samples/damon/wsse: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:09 -0700
Message-Id: <20250916033511.116366-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c8og63jtzt6944qsnjma1tesrh9pkn3e
X-Rspamd-Queue-Id: 6474C1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757993723-779972
X-HE-Meta: U2FsdGVkX19xlnrf9f8DUKytYNXwCugfpu8y7wC0If1+40cKDuwQ5maDH8r5ZBZSQlP+GGy+sPJxEYWgxtQqsrqv0x+5Mq2AkbmS7+3hDuZ1uZs2RmBtgavbuXKVqx+9iL9FggU68eQBIaNOUwdOL5D82AeijC6znN0tamk7OisuEthb7CuR/H7vfXphzJhUAOsjBl5SOKLlpsc+oNRbn3dMNmrAs+fjn9tR4L4pPppYn9NI7Q6ntpNc979ed6Zy90YwsNRkLrn0Y4YtpwTtpUr14fQxvxBKIhP6J1cFPn+QPgiPAzIayEi1josdd07jGgKhWPlwbSE9FCmZv/tP5LqtsFdaNUviMH+dt2tq/6XK8GCng9hLwNSaDk4M0+Z5+2xdYCDwvnSUVQOEzfeEVBwClvlTaGpR1cElVuzGEbwnQR3Sg4WisfqQnNEAmSpd2mCmVwHCbLJEtKI6HRNByDvsGubHaZ2gF9qnEhgiXUUyTZm2SupODRA26eJREWjM+o4ODzYnmx+8McJMmMY17Y18onpxyPnZAZGnctG/0YhxuWorVTsZziTPIbCeXCDEuhCHTEdBJHzfNDxCN5vhNWmoHNIxdM9rTeJKEppFf/WkmFzCHUy3S0Ghe4UNoDxwtZRdzY1GlIcwC400gaVBRzHhZOWVjV2dWSACc2GJjhChbH0jAu/rHsNEa18ExGmKtkBatJWStcuajLm8gNRqDhfbggzAP3+aIkXZwtoNwe4eWEeo0puGrEcjd8eVdCfG7zvUnzl/3/1hfdD0d1vag24RIO/DiDTjoXeQsq1uUVCeNXft7RNBhCQVn4RxmcdJSVbhATuZtiJH2rnqJNhrGNkSdViyyeqCDXXcVlUp/xmAkpfrnZL5Kwqa3HI4c+aW7FemT8T2Bxe0zl725B64X178CQBIvH9/vhh0Z1fTLr9aeeCoTuDpag3dk3hSCtqbG9E+Eh8eKsiuT/pMEiy
 0flICwpU
 27agyU/EmYneWB9FWjdEmr/IgT5Zua8xwsI1fD1HOf/8iOEmgMMwdIFODhcc0GTfnfQQ0fQKqk3PZhk3XynViDuC4MWynqhyQrc6o7ZvLG5vbORdmWbcrkEd0U3DxbfSNhBhs8S2J7surE+hVrtu9KS7i7TnXsF7VYIBmyOcDViy+2j5mIGxsB2C2TM/IQFXVt3F+eOzwsdOF4fVkhGmebAZ5J5DWZh5dtZ3Gqb+hFnnTLQx0zP4weu8kYyeHxkf8q58MKwm2ff0vgkSqhhyCPw2qMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/wsse.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 21eaf15f987d..799ad4443943 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -102,8 +102,6 @@ static void damon_sample_wsse_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -117,10 +115,10 @@ static int damon_sample_wsse_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (enabled) {
-		if (!init_called)
-			return 0;
+	if (!damon_initialized())
+		return 0;
 
+	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
@@ -134,7 +132,12 @@ static int __init damon_sample_wsse_init(void)
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		if (enabled)
+			enabled = false;
+	}
+
 	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
-- 
2.39.5

