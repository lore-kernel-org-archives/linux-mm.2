Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B0B2CF2579
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 04:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C356B0023; Tue, 18 Nov 2025 23:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853DD6B0029; Tue, 18 Nov 2025 23:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7693E6B009D; Tue, 18 Nov 2025 23:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61F726B0023
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:14:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B79F1A02CC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:14:00 +0000 (UTC)
X-FDA: 84126038640.21.B4B14BF
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf20.hostedemail.com (Postfix) with ESMTP id 82FD51C000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:13:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=yfCwUj7v;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763525637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UeJqLPZDGzdEpayI7suMAMrtOsQOR+JKs4REoOpH2fc=;
	b=kV4pCmQrE9PIMnFyTrEz+zq8RHBROGJYhAOwX44lnpz06jX1yr5ZY3sXobcn+i173Bgk/O
	2TgAHpvKymOUvNJ5QbNxf8iJawftbrErp1jZGI5rg3Smpq4TslkJTbdCPJTNnbEjzqzzh6
	RFdaXvO1/Qoy+NXVoMSIudu1sII401Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=yfCwUj7v;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763525637; a=rsa-sha256;
	cv=none;
	b=AZAnCXYAUNufwc4uOOqt6zKroeuatdD2iLDFV/SGKkChQOPvKMkSeCMubqm+jcgzsuqzT+
	XMBcsZ8RryDqhCZvSOxWP35Is/Q8vt1XfhctPvqxSTCvetiA4Z5WMsnUHa6ObLxi/y2GS4
	xOrTpgLAlMY8DKhswMRvtnJu7xhdVVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763525630;
	bh=UeJqLPZDGzdEpayI7suMAMrtOsQOR+JKs4REoOpH2fc=;
	h=From:To:Cc:Subject:Date;
	b=yfCwUj7v0jjgcAuf3kN8Hlv3XeNmG69OdQNtqygXKOclgwYQCI3ByxTLKwIKT8+gC
	 NepEi/6guVEUP31z4rx4yPRfVwyR3qzlzl1I2E7XHuXoaOJjKx5T/a1ao6DZ1xQvdO
	 pLoVvMme2dQx6NVJxsIqezITJB5EDC9JkKj1tMCc=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 36F25C09; Wed, 19 Nov 2025 12:13:47 +0800
X-QQ-mid: xmsmtpt1763525627tjjwglk73
Message-ID: <tencent_5936CFE72BAB2BA76887BB69DCC1B5E67C05@qq.com>
X-QQ-XMAILINFO: MRb64KOzELYukeQckwkBal9dMl4t0BS+3Q/txMdjgF39/72XeChq29b1g+KMZ1
	 pp/Omm1+yBlsN8vTKxvqml9EBOXcEwiCSa+ZXAs5amhY4MfeCJhKRrCH/PFcH2SuWqMaSKi1ZZW8
	 G/Mp+XY8Iqyp8mUr+4LUVXtpklyuGlUOjSV7mluM5zjIlwE96Igz3gFUYAaZC+eA9eOIXcePGPR3
	 qhXmrxJi9ZER7PnXVRfrf27OMmUoolv04mEmAnSuntUrWMzsRrOcwNWO+SM3LkizQ+pChZO7gu1r
	 rmU6fp+wpMacezrcCUtaGuUt3ld1OC5+M5ZJ9vAZxBK8sQpnxnmx0a7FJO7Xndr9qnCW2b9KSP9C
	 FoyrrYfGi6httgijv3EZRrBfCmYbvN589BMqtlUMhIxnJof05R1Do4v97vPsQA5eGc93PWcgfltC
	 cu4nLEZCNU7MhWrREFo/uLrDuTmvJbTgRVDWC4ECEXUFrRmxRfp2HTTyczP/2VAY/9GWyx6kyBUc
	 jl+Zc67eo5ti+PRY6puXM/UJgdtXuTpsjjI+vop6Vd8TkoGxvd9LUc4LeCjy6gGzP3vYk5+RT/ng
	 4mGoMboXg2A25LL20y9XG20q/LGzHU2pFPdfJGmZ0MkoVBu7FkVRy0PmuFbuPsc6bjwrscVWz+gJ
	 BC4NdqGxj2lZ1M/FdDi4fUjkjVmzh+lWH9A4g89yEp7ZgBlZbgHSqLCDhqhtckaDFUub6zS+hsx9
	 djdJHVOnZ8zcrXr7dQh4BEVyu5+ZJi1xlucJczjsxnHp1adT/rqt06zupR+2Q5HVRy4eVrAPWb7Z
	 BPKCVyL5mx7zyZm9cvorySE5UtAP4zeAZD2dW1xNs6H/IpRS3R+dGJxiOZ9tiMQWdEmEnF7Y3PTJ
	 5Xi0+bbs8p/QnLe8ibs9ULDK7gW0ylXTxRUEeIuaP9efeHIZRZB6mVx0aO2exjYfCdJFLy4D0PWT
	 9hNUc/14biB0cPO08yeEywrRLVCrOLs7Tze9ozHPvnIPaA16FLjisEUKQLQYlU7ENS0G4x3a0sPB
	 Ydv72dbqeGZQblAOxY6HrJLQb37FrbVpWmp+jTUuuRcGCqxJAdozx1gMykq3XD1m9tvo3N20Xn3N
	 f+Mnlor95rttyD6EBfkOjf25ZBwtl8MsCTHiMn
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	minchan@kernel.org
Cc: bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: [PATCH v4] zram: Fix the issue that the write - back limits might overflow
Date: Wed, 19 Nov 2025 12:13:45 +0800
X-OQ-MSGID: <20251119041345.2875599-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82FD51C000A
X-Stat-Signature: 89w4zsi7bc7zsyr6jkfrrm5zwokyrb4u
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763525636-813967
X-HE-Meta: U2FsdGVkX18lLjjN+oR3srIBv6KCRMunuUcnsX5lJuPsOqmK0Sok+BtWGnhzoxWBQctX5qK0slCxQ/yoLdVz9Nc+HA4c1NetzcgjP2vHG+fYs1pOvaGiOLTkEWuSu5LUbQg0Yo8u+Wf2oyBOk7HpOWqRos7SuN8l0lUySUSw2WTl7OPucB+tEdFZLZj+jcivTNCLlRyRjqb+x9BUcG5tUZiAmzv/jgLwBV7HF+feQJO6k8TTqx3UNuwtO7UdL4a7httDQXR7SH7oqbvKdAiWIQmshi5ii/rlIrNANrLuV3omRnY1PtAEj/V2avBswavIyQtO2FlTccuvQNWCYsX/aEFABxfWDgtwiwySVCotNUhlVE1jB+KERR9AwITTOTDS8Jc6Fy1BZsd5NZS8n67x8cq+llBAwtdNmkbO/l7j4SDpQhBKBuJc//NTHyv8q+HOTrkhl0+Rpq/nY1kYl3jjwEqpJgM0GAwr5R9LL/n9jQGcY4Gk7npbnhrFXsQnBoq3PK+ql+ggABmsoo2I92l6W9Lk3dbkB15pzoL0Fwe0PCxjBG51lUXnGkDHc0nZVAUZO8FUK6OldXvC+Hk+abndiwF4ig8wj4EHjJ/2SCg6sb4UYrKNfq+mczhm4C3C0WtShJCy9+WGdlERi9uKD78VG3JWh0kKUfFtsdDTLeFv2nA/lORRZvzxPVT/9d9Q7bzuvueTIhaF0Zu8REE/pZUnmWT/piKysAXERQLHtQXN6/T2GbJGWEW8egIrhj8duWBXHvBscorVD7osvYiQG3bwWUol0E+2MXCnfK18EaFY2viP5YlHGj0QHdV7GGEop1elvnzYnNMKqCA6GPkp8B8J24CD15flHtFMMU5ju0710Gk6c9cvWNMCs8wTpxB3IDESCpZerWzEoB0YjXtsMM6484v47tMWtgjzzMozlc9tbe+/aCTrsfPcT7sCUf5rWphIDefYYooEu0spiXxDEGD
 myani6xn
 QhIWTXzgn5IErpjipqZYBw2nA6O/QJ1J4Yv/pwkf1m6bDhAIr2/YUBMxT4BNbRiRtIvsRzqgEy6ke89UVRrVedwVh/CwUmQw4Qdl3lmQvS/e7AzSI0EV1aV3wbsrnrsKUn2NPaBdDJoSC+3tweaUs2PNqb7t8/h5uKT81DGdSf/I9QTWiQZ2hU0XNF0OUegM2D1rphNYYcmmut9qXBtO8JLjftP8BPFqzmb56
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the page size exceeds 4KB, if bd_wb_limit is set to a value
that is not aligned with the page size, it will cause a numerical
wrap-around issue for bd_wb_limit. For example, when the page
size is set to 16KB and bd_wb_limit is set to 3, after one
write-back operation, the value of bd_wb_limit will become -1.
More seriously, since bd_wb_limit is an unsigned number, its
value may become as large as 2^64 - 1.

The core reason for this problem is that the unit of bd_wb_limit
is 4KB. For example, when a write-back occurs on a system with a
page size of 16KB, 4 needs to be subtracted from bd_wb_limit.
This operation takes place in the zram_account_writeback_submit
function.

This patch fixes the issue by limiting bd_wb_limit to be an
integer multiple of PAGE_SIZE / 4096.

Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
---
Changes in v4:
  - Fix the code format issue.
Changes in v3:
  - Simplify the code using rounddown.
Changes in v2:
  - Rebase the patch to adapt to the latest version.

 drivers/block/zram/zram_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8a13729..fff9e45 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -579,6 +579,16 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	/*
+	 * When the page size is greater than 4KB, if bd_wb_limit is set to
+	 * a value that is not page - size aligned, it will cause value
+	 * wrapping. For example, when the page size is set to 16KB and
+	 * bd_wb_limit is set to 3, a single write - back operation will
+	 * cause bd_wb_limit to become -1. Even more terrifying is that
+	 * bd_wb_limit is an unsigned number.
+	 */
+	val = rounddown(val, PAGE_SIZE / 4096);
+
 	down_write(&zram->init_lock);
 	zram->bd_wb_limit = val;
 	up_write(&zram->init_lock);
-- 
2.34.1


