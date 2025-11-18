Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762D4CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E266B0006; Tue, 18 Nov 2025 02:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04E76B0007; Tue, 18 Nov 2025 02:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41566B0008; Tue, 18 Nov 2025 02:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29326B0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:39:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 616ED160412
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:39:33 +0000 (UTC)
X-FDA: 84122927826.06.9535518
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7ECAA0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:39:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=cRBLVMLJ;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf25.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.231 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451571; a=rsa-sha256;
	cv=none;
	b=G12rzwPjYKRxxIs42Fv473DHIARM3UYP6wGx/G0O2qxxa93UsUvB3eIUEV3cbIcvHrC+QI
	+QoSdbYU1KR/f4nQCKkpN7DpW2OdpQFz6IPlW3NZvceVCkNykFvuOg04UCKslc+UjTRRZ7
	ieytZsLss9PNwjGEgpwYbgeqo84YhdE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=cRBLVMLJ;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf25.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.231 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XWMqYs+z3GskzzvBmrAKmgnDeWF6hjh2FG2MoalbIJg=;
	b=t3/jQUDW0591I/hNvvUDKUaRFa3G0DWC0J8Qevpyt+5GGrDYpxZcNl8tVJf0ka1XUOGqWQ
	hgFXn0BxaVCZcTyDMSu6J35JvxrGYpVR2H6o65iW8+bxk6EXh7WXRqSVfKSeFz6ag7ELKs
	cS6szHI2cv0P2YxKzxfNPR1A6PvKs5k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763451565;
	bh=XWMqYs+z3GskzzvBmrAKmgnDeWF6hjh2FG2MoalbIJg=;
	h=From:To:Cc:Subject:Date;
	b=cRBLVMLJlNqwQNbmUdZkSVdl+5XZlQQskFoaOAOtL/eTNwHYzZHiZRY7JNUqk4h5o
	 C100fQey+ZMQannKuPQJrlHzD8gJeedFMSa+Ololt7unHqslKFjRkHHJxyHTgOIEap
	 G7kUBYnWziF14Pzb5d5dEVldnfJw/uVjl+ajwBAI=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 9D70BEA7; Tue, 18 Nov 2025 15:39:23 +0800
X-QQ-mid: xmsmtpt1763451563tvholq72r
Message-ID: <tencent_80150170978D13BAF69D63E57D7F5175F90A@qq.com>
X-QQ-XMAILINFO: Mm8VRyTxzGuAnIMbGpNB7YBJ6dXu8LFvRutC8PX9BL3PSBhQH4wdwNunsZI3EP
	 bQkNBRKBPqJJlTFTJcA0as5jZo7oDGTEdrUohfeVK+cSxg2owbLY2cChKVp94vYeD0exw+sF9Kzd
	 9XoI15/6sa6NTCIghJ7NdmWKNCDsYcQEXjyqZRbFZYKORi/rQs5KQSOU8rkvE31korAOY6fIRNiZ
	 4fBsILKOPumNqFaEDef7qTpwQnUfEE8Ijke+gKlZnxijXkoroasehfSPok3vVdt2jAHAfON5Svfq
	 FyHHHie4iBx8QhNbMJQU80rSWrb45/gB1TTAlWqPIcchztB3ziLEhCLDJLBCH6r7mQX3PKmhFySA
	 50LGgZTSuqocsP/0SaLIrQAq3kAzsCmnO2yGuWIk8QHTEPlSNPWhApDgnUBYuOGaYD0o22Gk9Dnq
	 rTYP2riH0MmHQQ2t/l2j01D/7i15i4gTSn65UW3lsMjPHLttExUJwUzCMtQ8ORG/UGT3ZBpMa/zX
	 0uWuD3J70fBPWrOCFjlsmqubMdRdGE6jePsAT2gisWE0UC6KW0fFcttcl7KTPPgEFzh1PZ6nK6wv
	 Ad8snX4pZ1PqyIsP0bYvTUxMUszmcDJQPCndRzI44WP17LT25f/ycnntj07GX/QPXijKJLmTDd6d
	 iO/HdFq64xUkbWBHCFlxCPr2do9b19pJEvdW8HS69VRC0xM4eExn5vb5VCAzHtAlcnsBD6qw1FX5
	 1L1Er1LP6ixXY2JupnbhsKSZ2V9U2z32BGtnAAuVn68yx4NKGjDWYZJujZLBDEMfDOU64dXkQ/Fp
	 OWLSp+KyuFo4sfyOQ5FQ4wqfZkoMEjeXNTckWLFMu0EiNf7w2jCqwQIKL9FyDHm1qiHgd13Rp9S+
	 KejGJO//dxS3gWvVmthS5tcFjXcGA1X8FUOF1pe6rzC+CxNvddYMG1kb37JrVbcT+K6qSk0IiyMD
	 FRK91ij7sVzwQIrnnK+HarYRxQi1ul2ntYyGyD2DT+BcYMqYART9e7XHn7ko4vmx+8FlA1vSPJWy
	 jYKzVQnU+Igkzhs+5EAAxZ7YdaKL9Sy+vlpsF2utQh8hxzxCovRPCnXRrkbL4poo1YTu9mGsOzEr
	 +P9CCh1GD6lZT8bzVOxbMeMvVgX1TwSoGNypMw+pk/Rwy0k38j2TDQmkuJ5Q==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: [PATCH] zram: Fix the issue that the write - back limits might overflow
Date: Tue, 18 Nov 2025 15:39:20 +0800
X-OQ-MSGID: <20251118073920.2807954-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7ECAA0003
X-Stat-Signature: uy8up7pbghnj4wzn33zb5f6rrnrro547
X-HE-Tag: 1763451568-554742
X-HE-Meta: U2FsdGVkX1/IvOA2INuqCjePkum1tcekzo9WXXB1MYvUiXwUI6EHJGfjrBzQTD6ze5VKflQmSwxI3ajNE3zRt2KPmGAvXchBzbrT//z7MOgJZWCMdoTwIeNFNyHGSmkdBtTgQlGaKDcTFYxxb+f4qws0I4kRMNNhMODr94b0JThMfyRunXeKTRjuluOTRHNWKtrwLep8B1Tq+4ty5l9+/lazyXRmI1/tlHFsAHRqJLwM6m5MZfGlA/9I2kqJ8U24vfZAqDMrqzrrC1dam3iJAPCsCHB6PVhblEHDS87Z7m05gWS/Sh8HDtZVzQ6BLLHTTF2L4XGDg+lCS5S+IKEOzCiOJuwwXmvgeY6oL6/LnuKfvEXpC37lFc7mR3Khn15acelp+6dqJFO19DCLbsAxvo11E8tAsnl6l9295Gx7TGbS+2xCkWbhcHMpow1kfqTFhCPXlG15lyKFMC7iHFEBGfFxcdrVgtT0h7tx4fOyLgVhu2fOzruuvUY1jzsGvnXb/6gCi1K3ylBkcwIOUytSPetH4U7Cn2vNcYrnoUSK38hMtbWxaKuaXZnmYbVd76r96x8GcJoLSYYHCPduBZBryvJ0e2s/sLYAq1T/6KuiY3FVGEtMtGl/882++4q3t9qYM40tGg/eJcawRL6IuIZx1L4qC0SlETPQ/UpTtxcOOU1fMiSMEQ2OqjUQqdxagcsHY9guFKJlc3DGqW7U/1rvxD3LFShxvLArm457ZitVetAABJ4vXfPWT3oGRQwBvKGPk7QWUeyC8+AW5ZkSB4eA26G4tmFanW3T/KFKpk2N0/2jiMMdkhBOiOlXnBUZ8CqiV5F1oZilExxregCJPNtSjs/pPJgGsLE3NleDV7QaHYQFqbBllSsX7vj40zcTQCUQpVOOxgABMTt9HMWVEe/Nhm+gfV2kSoZsimJHrPtowIh2Pb+ytlMHso3dwS20hyXakNaUfBoSnjgIxUu2nw5
 wekFJTTp
 46wPWoZ0RRLyeNea/FeZSu2hrgaFkxlOmpYQcgCj1VrhgvHYG/mb4PhfJlcvj4WTPFOim0DFpQtJ2DC6+z6q5kTGDqjBnLcWIDCw2e93J73ugjtsCyK0saD0Hl/7TV0w1rfq5GYntie+RrILjLdYad/4NjAYyz4ax+SwhsKSAyyNI9hZMlebnpPCO9UrW0JEd6pepU976akcB/1YUaUrNJBGHllaEkMU9g+RISKAwikT4igFyWQSZyxg/XUA/Hou+0PecVulbtXdmbgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the value of bd_wb_limit is an unsigned number, when the
page size is larger than 4 KB, it may cause an out-of-bounds situation.

This patch fixes the issue by limiting bd_wb_limit to be an
integer multiple of PAGE_SIZE / 4096.

Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4f2824a..4ecf2e7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -562,6 +562,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	val = val & (~((1UL << (PAGE_SHIFT - 12)) - 1));
 	down_read(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-- 
2.34.1


