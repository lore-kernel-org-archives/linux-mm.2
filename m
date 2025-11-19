Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDF4CF2573
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 04:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466B46B0093; Tue, 18 Nov 2025 23:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417386B0098; Tue, 18 Nov 2025 23:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CC66B0099; Tue, 18 Nov 2025 23:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 231716B0093
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:02:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 957CA140302
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:02:08 +0000 (UTC)
X-FDA: 84126008736.06.2B9FAE2
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CDCD14000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:02:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=agx3Vztr;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763524926; a=rsa-sha256;
	cv=none;
	b=1t/idkTmUNAtQiFQn7rEb1LQeoaAKx/v/SyrJLScajJek29U5ez/00AceTwhnd0zyQzmB9
	SFd2XTshSNO5lgDgAn3ESPuu6Ef7pDs8QbWq1DlMCnQVDJbLHSK4dMiJCraqxhu1B4JlC/
	rku/zW/jbmR5WUSdrRI40TeEvLYj8Jc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=agx3Vztr;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763524926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bclAGtoqR+J0YE9UMEx2BjcAWkKekT/9z3C0zxu6rZw=;
	b=ptIiGFL0DNXJBtK02XqMr9CIPMEaTMrYaTlgLtwn3uReIIDSHs8kEw4LRe8/e53PaUm+HN
	ylajyYlubf8Yr6ZcZLL83Vvu7dv6y41/4gCTKCYkgtDbdpU6J21eZ5mWb/f5Je6jOC4MGj
	bN32KQSnYJBIvMvaXbQLAgl0uPc4oSY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763524921;
	bh=bclAGtoqR+J0YE9UMEx2BjcAWkKekT/9z3C0zxu6rZw=;
	h=From:To:Cc:Subject:Date;
	b=agx3Vztr41R2ITpOaRH8CWACnrN5WVcmdFiadUigsyydpGjzVBjbViiFMa3fao036
	 qNd/zoGCeDz5sOzgOKFuX2DtKr06pxhphtaBnbHU9tTGA0baIe6GSlD1xetnyMKug0
	 /PfOyVSSvWWqW0P5mKwGJ5Fi7tyZXb2MxgQremgg=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 7A90C4E; Wed, 19 Nov 2025 12:01:58 +0800
X-QQ-mid: xmsmtpt1763524918tauejn0qo
Message-ID: <tencent_C9BC3F2FE38BB1EBA44887FB683CD195E705@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNPQ7mS3fQDG9QXuXn4UBK3U90mB/MBj5VcXJfrwIDftjdrBAmoBU
	 7DXQ9tyKAwZ/vpBRawP0M50nDRmtpS198FtoE954fjT/3n0kmUY+ABEpSbsJWuBzdPwFxAWQQTq/
	 Li1fPQyFks5gTAcJ2i/o3ThHi3vkJ3HzNOW6lzY4K1MrY65e6ZhAPU6l+Y/WCA6Nwc9rn7l7Ueg9
	 O5x6UJXwI+xCDR7pSL1wfzjkDtbx1Cv3rCBDBaebELxUMz4WA+sMdfKniMcVtPb9PfEBLct0t9ST
	 eXaoxw/kUamLg7zRrvOiGbcUj7VJvG0Xj/fNNEIss3+MCCnt7T/2tUd9K3fHvM89V8m7AjsyhC9X
	 vHz8mLvKMa0rVeldZpQD1947x9MRmJvGXKaR0vKPivWRMUqiP5tv/Rf5KlwOz1IQSItfje5oxhHc
	 cMnELoAWwMZQtGdejQqUYOC/UWod4tDgco9JL0G4g7Wpcwe6VEjyox+tFOj0Nk9fCRBNoZfiu+Cp
	 oHDPwHPmUrUcPh6f4O+yxGfeYsfhTt/gZv+fnyX+6TsLoBIznUiAyByZDdYhTW9P/sfPgLwGz+eM
	 eY6BxVhBbao2jDMWbg9RKWCj8BN2ML/pH1sKC/N76Sjl6qFkXlo3ucbHs8l+NwPGwTWBfnvV3k/s
	 qzALgSeTR099jfZ4Ynd+Yw4tWLYz5ixR4BQqvTbJUvYt6Y2t7g9rw5jUlV14S8fesSoJGvtZLR4T
	 A1/GGS05Fby55IMBMq7DR0ru9w028yiCcU7cxIwR1vzurRJ3xEhSAlK+rHJBnnzbD3XrCtrHoT0u
	 z57Erhk8b1sULPi1bNYANHchfWQOBn9l+UmxFJtk9AlyKqtApI0JKOYMc8x7Uv/Ya1E0M1dhw2jo
	 Aq/uYL7J1NESwEg7sUGgr9yUOYXqOxX/k9UNfFqvdvkJ/xNKrvMlpj2L3U4RCa6v4hhbg8mGWScF
	 FSdBj5Nb2GO/DOmtatIYO+/GS4Cy0Qe/MxNDHfUpEY6oN2dW2b3+SBmd+n8JIDnFEqRJobNOp72A
	 57Df3bZR5sOMftnbSJc+rwTCcHquYU5uH6Tz/VDJ47FS69BFI3
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
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
Subject: [PATCH v3] zram: Fix the issue that the write - back limits might overflow
Date: Wed, 19 Nov 2025 12:01:57 +0800
X-OQ-MSGID: <20251119040157.2874911-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CDCD14000E
X-Stat-Signature: ktdmjubao4e3z7t96f8nfyx7znrr4n6t
X-HE-Tag: 1763524925-643753
X-HE-Meta: U2FsdGVkX18wtgscSBtQR9jKGlCc1oQbc4wWuRNRFl/bEpw3zto4d4ikGIrGd5WPRqNWyNFtGwr/arCyaJ6sCZoQHed5iYozZWMmreg0pmb7qGqlc5pEeZ3dKy6ti/I6JoO38DyDAzOnOCc2T5/PyT/0hNgqzx7DI+Fg8rsB+GZn27dha1c6CFW2Guq8qHsjsTmPwGxGO6LMjq22xEkK4kaBZyOzTz/fbgwpoBxaomTxyfuH10w9V7uCDPT8OroydV242uoEhcC6J8RCmmCrPUjwHAilFUwTVVno+4X3wgq9LQ3/ijjJGbIuUNhgZN68YU5fVsKrrCsE7K1uVsHbLLBH5kZy1QH0hmLyZFSs7aiuvhNyooFS1QEscku0OrhHN+5AWPiEaUO5FIT0mSRuSoJe+O8KQyZhzQqeekReD87Vpgb25sVIcWPULPgrfWRxpNn2KHeAp0khAbBQBD+/TQ3DqUErFViEg1Vbd2gf2D/9MzXI3Kcj3GBIjGZ5BTIbx9MKMovzJ5IDrb8nm9qD7ltTbm1DA6bR5lbZ5vjuTgXHFrDPH0QuZ36zW+SUsbu91wlGkeqwWUI7Ig0kEb+EWeIJ1WQ2sUMPW0hDjY0/XsLqP7sReqaIqS/4XXfuTeYV8aHuA0HOnemu/ij1Im6ZsZi39mriSUDjZw0+lZpbByTt7r80jVT0Dd31Qzu+AiM+RolCzK2gdwEorG+gIenkbIURyXqQXmakgImZMO6w5b8Wq1E3fiy6qct26aeVlEY+Gn32dfGVY2XYuEEAIcPOJ/5xVjtJHyVMtWc6G2n7zSsIlAJVYd5B6psHaptSsqyU5eqVBZ+KE0fUPngfFziyBuz39LoAln6idHKkLZz78hHG/fcGnQ8vJVr1D/qi5/8UQORzH+SPjY2YNesT8NRjeK52JdMifxx+NqOXdG4FkzFH870PyCwDhFnTRg0AKsMtAQYsj4jLVFB7c1n1bQ0
 8OX3XIQ6
 H5jMVs0Obnmx69k9JxWa5I4Vbv+3SZ6kmQPzCQ3HoZVz16NL/NZ6vC95ndJYZc6on7xaA5ThFNiWc27dpoyQ9wRlHCn4ndezpNq/iL3WOGlFFJojc/tmDbXdGRWGqNoRIwI/CVDP4Pv1KLxCt7x+3aM4G8yAa9Z3DgArXckcVrhdaP6ALjtjIKVGs7PT+UPRT0yuiKfko2VxKg25jkHIxM2IT0iLYG9nHLpR8
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
Changes in v3:
  - Simplify the code using rounddown.
Changes in v2:
  - Rebase the patch to adapt to the latest version.

 drivers/block/zram/zram_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8a13729..681f4ff 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -579,6 +579,16 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	/*
+         * When the page size is greater than 4KB, if bd_wb_limit is set to
+         * a value that is not page - size aligned, it will cause value
+         * wrapping. For example, when the page size is set to 16KB and
+         * bd_wb_limit is set to 3, a single write - back operation will
+         * cause bd_wb_limit to become -1. Even more terrifying is that
+         * bd_wb_limit is an unsigned number.
+         */
+	val = rounddown(val, PAGE_SIZE / 4096);
+
 	down_write(&zram->init_lock);
 	zram->bd_wb_limit = val;
 	up_write(&zram->init_lock);
-- 
2.34.1


