Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DFFCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B5C8E000A; Sun, 21 Sep 2025 23:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143128E0001; Sun, 21 Sep 2025 23:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0589B8E000A; Sun, 21 Sep 2025 23:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E64678E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:31:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7525C86FC6
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:31:21 +0000 (UTC)
X-FDA: 83915460762.22.143B62A
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71B84140008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:31:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=SjR8O3W0;
	spf=pass (imf23.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758511879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=naUubTQs4cvxZpd+FKA4m3TL3kOY3UI3T0jr+Hxcg5I=;
	b=wq2cZuUGfFYIbHnDdA07jHYr2/NJy/3D5cVB+5KM6GMA6HGezwttnvs/hx9bckgxdTTJd2
	vEQZ1KduV9OlYrQyBPPVOL3/LIWXijbXR80rJMNXgCZatOxuHh2PRsaY3tGB+kmKjYA/nt
	/krFSm/2bxpehsNj3muzYyEuV/25VcQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=SjR8O3W0;
	spf=pass (imf23.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758511879; a=rsa-sha256;
	cv=none;
	b=tq9rANjTM0Ufd+5MS9+skraPOaPqgqLqiq+Zc4B1y1E/7q61QqOmJ3hFfnD42sSyyrgwj8
	vc+vi6wyyNGrkUdpn9JswgII0OIaeJjg7I6InlFJXt3k7FPwXcnlRo6Om3JscANEscrnoj
	aPv5PHqvJgcRc7pzV5SnwB/S/Xt3rPE=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 58M3TPM1052899;
	Mon, 22 Sep 2025 11:29:25 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4cVT843LdHz2K5NS5;
	Mon, 22 Sep 2025 11:27:48 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Mon, 22 Sep 2025 11:29:22 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        <linux-mm@kvack.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [RFC PATCH] driver: loop: introduce synchronized read for loop driver
Date: Mon, 22 Sep 2025 11:29:15 +0800
Message-ID: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 58M3TPM1052899
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1758511777;
	bh=naUubTQs4cvxZpd+FKA4m3TL3kOY3UI3T0jr+Hxcg5I=;
	h=From:To:Subject:Date;
	b=SjR8O3W0D4m5YndAEf7zM3GPQVmmpYj21lEwZrJZ7XACQ+Y31SzAZDa0e+B/0orgs
	 729F8t91BdmliWox18tjrRJsRpUuyEDiEWVSTAwKmLnq8c9huZNxPXBRsAyUlToH2O
	 hkPGPS5hPBUfw9+x0DJIxEsMjFjduiq+cMW/hcOk+WA+XPp1ZIk1RQRUf83XCArroa
	 8u5zlu4vi2FcjjR6uiU1d8F0lhKBq7uzFDgLt+MBENgkweYUKJaB8/qveMdln6ARAg
	 luOwbYA1X3eWo8MFF+2e6tAzAv1XP/2GKuxZVqfDJ+oSJH5+GM54whnUz+JMa8uH4V
	 uh2wC5Rn/oUoA==
X-Rspamd-Queue-Id: 71B84140008
X-Rspamd-Server: rspam05
X-Stat-Signature: f59a7o8zga7nfmrdrnrm3j7ze76fzq1a
X-Rspam-User: 
X-HE-Tag: 1758511878-790535
X-HE-Meta: U2FsdGVkX1/9r0dX5h3ga7JvfkePur5ZULVALgBCKYUfphifRyZ2bi5d4iaNEcoFPRMIPBCrEZJ+mUzr1HcoZd7q96s+b+rcMTtM126ih7Qd6ITh6cIM/ZmhuzpJ3X1Q20WL1ixu8+qvj9H28oW7ir9sfAIX1/pQ/WvQ5nugay1da2hjJ9LmtsdOwLkuTUUPD0PWvxtBP/j5R221y6cuc5X8U5d00UTJhFXrsCH1yIKwO6GYKdwM26OOSL/bdsn9X/bL1e9cdFmXDi6uRO4afFGGj3iZQBktVyFMI6Np21A8TYihRYlO0IhiIC+qLKPPChH1UNACrytx9GXB6vgHxAO74bENdNb0FDCJcUVy5AdlJroD2YUh8UjVBs+r+99Zkp2BeE1a6FEmX885hm6lWbsjAPqIGOZYXdCLgB0JUZYeMFlgMk8sd6zeDZG0LoIsLADl3sQUqEzdW7Tqvk9dX+aDdlyWknsBbanWjbg1S0ZRIK9P1WnwLNoH4EVQwFzq6F6m+4BiAGSkou/Ix3e/SVOFfyBmNXuR4ovRs4tY2L7+5WSLdIiFbPvxKWki4Qv50s56hs2rHY3raTqybaFlLNUUI5wd0I8YMD/Mjp5Db3KpnGeGrpteds53CVFEYhGny+1F35K2sNt8enDSrImrO1sfAzqidMUcuo8moga1yWC1Q1MB1Vj8cxl6InzVdrvXmEg6gjB6A6Af0DZY9h7q81+p0kGjXoUgINR+vjPO8BUuJ4CkqQY8xUarMIuwhEBXOoHDgmPWwJO2022bEvg27gFMgF82iEric1432OYfM6l5EF6S4//jwxb/oExBXsC5H5M/18BgR1RDARGTjFtqVh3YkcZhBp1A2ffuXA+xyl35TknaD6B7ztZv+7+hLTOEZ/H0G+L+PgP3P36NdyXjN4Np6ZKgoh4dIXUr8frT/QThdW2jkBjwfdRaY2KcIlONPnIp4Lz8tkugUvxEUt/
 VAoS/n8y
 tlkrgWOgqm6a9Vt8CTW49Rfscv8wx0p9wx7uo/n/pt08f0LAsH7fntUqZlCr4DjEEfaKDlS2+ZBVCRzv3B7zqTR7wE0i2YpHi0t4HTReMx0pIT0Ta6GsdFPPpWXsBZyEwgyMkr1bI7hfg7+F9rnqbKtAKZrQuBObY0Q+S2CD6G4V51X00KsR6mFrMndbZv0skydYCiwlnVifwWXYqD/zHVGhYwh8JxzFmFOlZTCvY6N9yXWR0LVSUAMoAmyDir2r54iixcttbR0OrtxnDvLonfor7c8S1ZVlgPrptSk+lS9IN4Rv210LHKVRV4q3Q14naYPfZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

For now, my android system with per pid memcgv2 setup are suffering
high block_rq_issue to block_rq_complete latency which is actually
introduced by schedule latency of too many kworker threads. By further
investigation, we found that the EAS scheduler which will pack small
load tasks into one CPU core will make this scenario worse. This commit
would like to introduce a way of synchronized read to be helpful on
this scenario. The I2C of loop device's request reduced from 14ms to
2.1ms under fio test.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 drivers/block/Kconfig | 10 ++++++++++
 drivers/block/loop.c  | 22 +++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index df38fb364904..a30d6c5f466e 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -383,4 +383,14 @@ config BLK_DEV_ZONED_LOOP
 
 	  If unsure, say N.
 
+config LOOP_SYNC_READ
+	bool "enable synchronized read for loop device"
+	default n
+	help
+	  provide a way of synchronized read for loop device which could be
+	  helpful when you are concerned with the schedule latency affection
+	  over the requests of loop device especially when plenty of blkcgs
+	  setup within the system. The loop device should be configured as
+	  LO_FLAGS_DIRECT_IO when applying this config.
+
 endif # BLK_DEV
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 053a086d547e..1e18abe48d2b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1884,7 +1884,27 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 #endif
 	}
 #endif
-	loop_queue_work(lo, cmd);
+#ifdef CONFIG_LOOP_SYNC_READ
+	if (req_op(rq) == REQ_OP_READ && cmd->use_aio && current->plug) {
+		struct blk_plug *plug = current->plug;
+
+		current->plug = NULL;
+		/* iterate through the plug->mq_list and launch the requests to real device */
+		while (rq) {
+			loff_t pos;
+
+			cmd = blk_mq_rq_to_pdu(rq);
+			pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
+			lo_rw_aio(lo, cmd, pos, ITER_DEST);
+			rq = rq_list_pop(&plug->mq_list);
+		}
+		plug->rq_count = 0;
+		current->plug = plug;
+	} else
+		loop_queue_work(lo, cmd);
+#else
+		loop_queue_work(lo, cmd);
+#endif
 
 	return BLK_STS_OK;
 }
-- 
2.25.1


