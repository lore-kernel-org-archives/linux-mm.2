Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4037E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656B76B00A2; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62DF86B00A3; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6D66B00A5; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 392A26B00A2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7F3813C05C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
X-FDA: 84624844122.15.B75E24F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4744916000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvmM9ifR;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvmM9ifR;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401960; a=rsa-sha256;
	cv=none;
	b=uH/D58SAVkP/9f9oyIuVeQgvt3Sv8+QE3XLtNLPv0YKK8uSoH33fy6XyXGb5HUIDsVpOre
	5LZbnn4yFOXWB7Wb0LYLnZU52ZK1L35OxQBGcy0gHxqMPK82VAqd+0AyqBg88Z97sQCgCc
	ZWXS8gwc91ZjwZpSl4JQDdT/wdFHqyY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=nR894MpdkEKoERy1pH7dLeBoF9C2GtuVruryOftKHIy07V/W2aDqs5tSzk2C3ukCwrGifg
	egWvRtocSzorcZyCgAyUWEJSKs0rmebXFg9CrUrHUzjefnyNDCNQRZcGhdPkvAgEK6BzTl
	5AXwG0leBbhPT34FUFr43x0aJBQzCE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6121E44521
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E84AC116C6;
	Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401959;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvmM9ifRdqTUlbXZYONJVHYmVCM4l2anuYGYIg+r2Pviuj0/hKVDWOlJGIOcqIG9k
	 vI4PTFaOH3/jsI2TQMiIqX01w60c8fAhKHQLAKftkWzSS3q5+uZnMuxTa8FGn7ZBzB
	 Btd3uLanbnFzBXAIdusN+gZNVIdpI7bOkdBIAgITYVoiT6aYlg74KxroWgm5wCY+UW
	 faP86iiDJA2elH6BylyItD6jnqXtJQmE9kbt1mHC37RI9swAoYm42ZXtAUgZxtT89M
	 xy6nJE7GMlRC0GQBQX9wjOQH4kyw+Vq9XtmpKp4svvWRVGu5A0l46YUbfTqvmZh4bM
	 o5jjGIjPyMm5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 5/9] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Sun,  5 Apr 2026 08:12:23 -0700
Message-ID: <20260405151232.102690-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4744916000C
X-Stat-Signature: kjszxx91gruyjg7sq7eqtbyj7o6ksk1t
X-Rspam-User: 
X-HE-Tag: 1775401960-162391
X-HE-Meta: U2FsdGVkX1/PQXiHsuoQ7I1TeBCfEh8yq3qvkDVv59PIiuWpFVfznw2Gu4L01EMAoEtLqZDLCNYmxaPlIsAAcmHUAxz74aSJZqpSFhvZbDXiGlPaynW6oRhJ5wN4PA0Ls7P/axuyCHJdRL8THu6/bgnFeRrIdberadv3Tip8hK0CbB7eRrtsrscVF73HjDhryFDFVK2+XcVI1usUz8Fcd5M6yHqdl9VVQh8fF8BNBNsLOR+Sp12dPRAffb7uCDfnEqUEWf8RmTBH5VArdNmfgEK+5IQyfZ7/CclFgeODdieTzE8gAHpZEoxXN9Jf8cIjoA7uwN2SEkmbDt6nX9CD8QtGIHAlgaygINWoUzSrtQ2Ir1M18diQbOB5cqdbl5Jlc3q1UBPVUcODT4HAUu8bB42KseyebNjaDHLIpUBZx5Fd4Nx6hs0wp05SlBhif7dXP6iz+xmV9mgv5HEHiOIYHEcY5sBgoWFAdiPVjcmiMuE26RV5NBhPr+AkqlRgDV95ovQVh9cTb15ea09/sx0csLx5oJp59WF8dnYz9NS1p/WVPA4LRWR5onh13xLT31D8I2CnVzqX6NMXXgNoN/Ys4CIcMPPp4seM0X/R51ZJS62tjKJXLORjfKq5p4FaiDu3wYiPhEAHcmYkKi6Ld0768qadsj2gVtDrjytq9n+J6Xa8BSyv7QZ92UB0ZLTpPB2pmexLhA11I9GxkPlj+j9ToY6PVcXtbqlJR2L4pe/zOg2XzLJK5b0OaDFp7IaI0/vSjHv5D4QragEuzJbwlr5+5Kpdy8m8rfBwn0F6NiTrjyzzwKGaVIAdK1ibWjxe3S1DCigt5T+qiLGHWyDsOmwia0Hg3s2oPiwp2lxcw3cgu9LAFiwYlIDY444DDp3ryyf/didhM7cyLvIQ0bQeePWxCAVTLfpbtZZYf0Ss9vuQm8LwQVW7exOwFT5VeATzU0sEM5fc8qQljJ0HmF22P9p
 SwxasV1s
 Ry+gaFgLNivlbvIk2Qtb6J2ktk/W4hzsLQepjPi4kUPhX3hrvgMr6Jmzffbhj9MHfVZPyDSiiD2TMnfWQr8eVGkiL2yymFvvgunYB0XBKGOlEJKBN/Wrwnfh3rxlq7/OSvGAKg6YDEP0LZRxSQUXRKR8RluPzQKA9oK4zw3xm5vnkhom2qEPY/eLRd0vZffa/xHn1AUk+JTxvf1bg35quKa74z0aP1TCKNyUsMQExp748BHhGfB8plSZ1BLZFFYETL5AKh2qUn92fz1eygNMzhINKMkBQiI1ZmE5UMcXz8hhIJaPQ+7cwS2u29nPKngog44EddhAGcnILOB7PybY2+m6u5bGGCJNkSCl9lL/FpszPwpwzcgIBLfuRRXnaQjIWlmgu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

