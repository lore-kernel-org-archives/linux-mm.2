Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 442EDF3D605
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8159D6B0092; Sun, 29 Mar 2026 11:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECE86B0095; Sun, 29 Mar 2026 11:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7299F6B0096; Sun, 29 Mar 2026 11:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 642496B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:23:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10564160492
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:23:12 +0000 (UTC)
X-FDA: 84599469024.18.11F36CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 884FE20003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:23:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMqu0lRi;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774797790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qTe8FOeOLcOmupoyY/PA1kwaEYJTjdlKmZYDFnKgmVc=;
	b=mO+Dfalmh2qrxnL5VRK9/mJrmMr+VSkC+5Irbs8pnz5KKQ8cz3K62VRqksSgLWj7Sq5SNo
	hflwTWr/VR7lo6dz5RjtgYGcAZkQTI3rSCC7v1ejGdGfsrJIyR3AYxt1sRSJgJf40vHMJ/
	+EsKptETdctbvpsxaNj+OoVrXoENZH8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMqu0lRi;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774797790; a=rsa-sha256;
	cv=none;
	b=6MsBnVLItacMAboP1++nlz8nTI6jQc2LmPCLsGfUIq9nkcdB36vKaSzOLL4qgWuqNQYPLF
	2LikzECel2wBhsXengzXITand5bxHsNeb4aucLg97/IdrG0MsCZeN/wh9kF2/LWdxQXVG9
	f2g5x40531Sz/zL7JHYbqwZJocHrkFU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB33560054;
	Sun, 29 Mar 2026 15:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03116C116C6;
	Sun, 29 Mar 2026 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774797789;
	bh=4w/+zge2tJUjelQDfdDj5Cll9bwZ8Hgq0JoBvAzgu+M=;
	h=From:To:Cc:Subject:Date:From;
	b=EMqu0lRiZwv9CrgagB5aVGKcDKVfUZrw7cF8pAu3oep/7MsfAMrfkPjwlewN2kOe2
	 qkIiXEjAj6i6Szh4aURhcj/gzASY6N83En2PMJAi9n04tiykVaFM2e76AJ9Ut0e4fP
	 sxk1z20dnWg1g2Oaa32GwKsW2saCFmHE2HDvvYHIh0zKHDmvzx8qA09uJVN7sjUEVU
	 Te6ExZSjyahnvRv3/vIjF/7xAxuLI2Dk4xvispqG7OQ1M2jhvkcVZ4/3mSsT9dncrQ
	 6wX8DV9fOCZ0p6kXwB72Ezr42BDNd6MK3UWEg6yrNMj2UIgGnmQSLKX4gZbpRet+ug
	 o0acVl3XqZy7w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: use time_in_range_open() for damos quota window start
Date: Sun, 29 Mar 2026 08:23:05 -0700
Message-ID: <20260329152306.45796-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 884FE20003
X-Stat-Signature: aqq1mg8ajx177dum6nhmouzbko9kb1fi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774797790-624009
X-HE-Meta: U2FsdGVkX18q7/TFtHXKnxBhjGggvin2XMKenIF/oXzYS+41a7r5eEDDSzJ8ZqmkiNtoqcdA9a9xm3xgKbZaZBxOTo21/1unCItT96ws3J5PTGB9WZmNQGhtqqc7cLR0oECE9Ad82HH28TLqv63FiwVQT5TTDeyteGnD3nw2cnqZfIFbXDp1UdurecWO0LXdNg/YDQOM295+7yp/E3MPhpEa+d6bYmZHKKiQKj1VLCVHA0NJqjh9jkZV+To5spqqJNcMOshOx07CBnVu3t1DMZp+RGT3ZPS32csFUwhX/401qn3cGdu6aCxOq2I59f6lcF/h59slOJli77ysX7uI2vKL1e/5IK1lqw5Xwr59S+ny59EatPmsB/d1FtWAtxUrj7+0lQP1AlAdOgPaxAKJ0aHYn69d/FYoYxsiJ3hO0VJWoS2hYMjyyaLPUO/hv+lCtVzk0x1CHbkZwm7Vaiccqp61p0ZG7jvyiUtRZd5TCdo52NOUyku3P6RabMGAG//k0u6cv07jzvoXgiBATdoebrP8aVToJ0awt6bpHvOm6ugAGRdT77O/qUrh4cEA4GZB4jm2Hu3UhAdJKfshepI/WF4GYHo9BHHhMoc8zYCk0O+hrpQZuDgQP0lA8+mAV52y4e3NUZP5I+ZgT0HsOTqfVKDYijLLYxwObTHGsrtknvv2VTUp4R6MoekNwmke5FK2EQIadMOjPGszsApaXicHSnTYbxyYaQvb5SQapPGfc8urxsV8P0XYZFgmetXHNfzXI1WDOlwGwvDls1jbyuvRkgUweu+Un7BDap0UNwABKrq2KcqLNFJj1QMYs1Oxw8bx4EKp2BiJ1HKQ2hBa3Z2gXwR6vRXoCZP0eeg4b47VEW6uql6XYvAwM05T1yK46TgNBYdLeVgFfKucbKtKIKuuSfqO9WFj/RrwUNlOt7lxov31q/tgY1kQa8AM5dpM/BT+rJytu7jEHvb5algNKgD
 JI3MtcR8
 QvllSmJ6EP7XR4bAA4KKAPf3fDehGOzwSQH73R3ofPyiuGmsO+c5DcmgbxKnb/t3X3AhSVPivmvjSiT2u5R4mXHd7PWRCCguSBbE1uiWhgyPrYBo9LuqGmEFkEBG2uYy5IcZ6vTs/CPiMkwoSmBKmCmYOwiWGQPNGhe7ttob1nK2SBf+J5x3JhzrNtWOKE4j5Fab4i4hYCEihs5i8dasYohUku3/dstWkErQIn79CgBl95wQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_adjust_quota() uses time_after_eq() to show if it is time to start
a new quota charge window, comparing the current jiffies and the
scheduled next charge window start time.  If it is, the next charge
window start time is updated and the new charge window starts.

The time check and next window start time update is skipped while the
scheme is deactivated by the watermarks.  Let's suppose the deactivation
is kept more than LONG_MAX jiffies (assuming CONFIG_HZ of 250, more than
99 days in 32 bit systems and more than one billion years in 64 bit
systems), resulting in having the jiffies larger than the next charge
window start time + LONG_MAX.  Then, the time_after_eq() call can return
false until another LONG_MAX jiffies are passed.

This means the scheme can continue working after being reactivated by
the watermarks.  But, soon, the quota will be exceeded and the scheme
will again effectively stop working until the next charge window starts.
Because the current charge window is extended to up to LONG_MAX jiffies,
however, it will look like it stopped unexpectedly and indefinitely,
from the user's perspective.

Fix this by using !time_in_range_open() instead.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org

Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
(https://lore.kernel.org/20260328163930.47096-1-sj@kernel.org)
- Use time_in_range_open().
- Rebase to latest mm-new.

 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 19642c175568..3bc7a2bbfe7d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2449,7 +2449,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	}
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range_open(jiffies, quota->charged_from,
+				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz)

base-commit: f7657f10211e1fca73ea2bc00d4b5ee938dbaa71
-- 
2.47.3

