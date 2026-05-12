Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEEADCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9426B008A; Tue, 12 May 2026 08:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9F56B008C; Tue, 12 May 2026 08:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0356B0092; Tue, 12 May 2026 08:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D74B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:06:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 927BB40494
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:06:31 +0000 (UTC)
X-FDA: 84758640582.23.47F06DC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5ACA414000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:06:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="HfJ0/TXF";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778587589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=he20vJhXuk16wvij8k8XvtMItmz4w87BGjWhCU027KM=;
	b=MKzayvEyEA1tINdQXGCrYdyOQC0eYKhhJ12NXk3r+XURZteXXFMnyoNKxoQkSy41xLRCH+
	jFCY0UOOpiWsLxjpNzDaVDmG4nk6YoexHdyy/3fYTcxAfkuGUg+aRJkIPNO2623CrzFv1w
	mN/vcJjQ7Pf7tpJmJPvlD3GrRAO4/0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778587589; a=rsa-sha256;
	cv=none;
	b=J6kNRYkz+rlGu+deVHvM0+0t7mqHU9B6lHue1er+vjM07CorH73OhwbhQXED4JKkdnDKQ7
	O30UJ7pnF7NsCDMc3EnMnVMGwL3wlenmuYPa0drXV29J21fbFOyZwHvYfho54uvgQ8zGKa
	tzQg6o6CfyXTHJZN/zfChJjRmVdOh4w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="HfJ0/TXF";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=he
	20vJhXuk16wvij8k8XvtMItmz4w87BGjWhCU027KM=; b=HfJ0/TXFolGO8ZyuCO
	NiyFcwRLLLuaoh+FwqBbZ03eO8/qD6SMe7n1FVbR2sQCixFPkkY8lYI9bWh9JuyR
	+2a38Wa01ZAj1IwLoC9cK6xYOGglhcibChSiqoKMLTeF3K+mbVRLHUPklK60uLON
	2dt0VOhHufZ3U05p6J5hRFL4c=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCncianFwNqsj3nEA--.14956S3;
	Tue, 12 May 2026 20:06:07 +0800 (CST)
From: ranxiaokai627@163.com
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 2/2] mm: huge_memory: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Tue, 12 May 2026 12:05:56 +0000
Message-ID: <20260512120557.49995-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260512120557.49995-1-ranxiaokai627@163.com>
References: <20260512120557.49995-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCncianFwNqsj3nEA--.14956S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4UZryfZryfXFW5Xr4xJFb_yoW8uFyfpF
	yfC3sayrW8JFykt3yxWF48tryYqr4fJw15trW7JayfZwn8Jr1qvF92k34rZa4UA393Ww4a
	gry8WF9rGFWDtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piPfQJUUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7Q9MmGoDF69uKgAA3j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5ACA414000B
X-Stat-Signature: ifw3dakbytxaib1inwzam4kdnubz4jsf
X-Rspam-User: 
X-HE-Tag: 1778587583-846220
X-HE-Meta: U2FsdGVkX19R4jtvVAXUFwsscJJlVgdYh9a6gZjUqj8B/1PBt2t8ZdmmYh8vypall3NuKkZNS6VNEzQ3fV7lNESkmPYB7rol76fuRHnwgMkZkyRSDaaqYORkfvr0qGFEeUScxfqe2arFgDOvP0EgQDbBkwzvfWSDLf9rHGsKeMHP71dsHu9qUWgKQ1+MAzNEgbvOfmLXzc+H/q00lrOd8/hyB/2j9tmPbP1l3BxI2vGgh8ZXKctf2eequ0KtPtIydyMa84hsVxdGolQLXIwBZcqnv4umnY6EfkeYefi8bBci2A9/meqwPk6XDvcjpN7M286PrBnmpO8pCOh4qfCBX+Y2NeG00+SSTcPWsD56JqRHqvd5uO0w08W0KjN4YT0v25/m1NzfoTw8p5An9DC03g8mVrJFC66d8b/MkfXxp7bo4oMDhYfCJ0mMKTVS+rNoN6HjnOU92sdUzcdDes0OknpHc36lxevALA//qtfnCwXq0sMnMhwMOQwPPL/wvEZcgGNylzh7akLUHDOFiOc4nqzZYhriIpHC84BIRDWLtGW0tF5c5AgYMnOG7beXFupSgWzHdOUZpNeRVkjdm5d45y3AFz56qlZKRghuKFa5Qn6LqL9sWIEEjo11WhRixJ4lY7xaCr/1hRofV6boRwty5Yz7DmQaMilsXK163vo0jFU3eW3jvwc/Qjab4X2if5z9cHgEaiduBNM7CIou36EVOoIU5pHEE7C2Qnu+xvNW+ftjWMIYG+SLXKqWNNJ1RYdXR/8kpiYIrvN5s7LFTXf4d50g0jRBeAPxFvq0LAiHKEKrD7x7/hxAj4EQn1Zxp9UCpxmC6/j89ElBENB/O6AVPZEXbr/vbyBPqn0yu+1Bspa1cZ/bw3+uZUKcQdVBr9KJ6tcZp0Bbhri+xeRaBCeE+0IWXEGPkIFbnDorrHsJQdWVyncsBoLmw8OTfRG6FB/VbkZmpqpUhtL8jEpyCoU
 RKS74uEM
 atipsXXrxW6z2VL4aq8Xsgg+cgh3Q+dIyt1wrpHgoSYKBtQ8VW1nXQk5iAoFY1g64/YLgDfHY5oBLVPwAfXRPeveU6t53J0fp4YyDnRHxwsUPIVJrG4zaoO8LDj9QG0QfRuS3ynAm8Xx/cOqw6F4SNEZVUgxilkHF8WLHS5/6A93hGk4SWrC67enTIf2m35iVUBMdk1eVE8g5Z2u3BUzfEZ2PHAAHbsC1yT6TJjHTXBcYjp8aOfkhGO9SkWRuNMmat2jmLI32Qc6b4NAoofhkHBJ+AsRHWRybtZnwaWLoopQN+rCBTyfHEbrZkmusJh0HJv8XB4LgaM7oSN5yqM7jtnRPmkGAk9L5coC7rrZfEk1IJuaibSeZCDTLUpfUP4yxRM3ZMUhrau6+8Z0JIbQDUG+pg/NHXCpgDz6/LUx+n2ApunT6OqC3MvdFn9PKlcL6cztz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Replace the hardcoded if/else chain of test_bit() calls and string
literals in thpsize_shmem_enabled_show() with a loop over
huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.

This makes thpsize_shmem_enabled_show() consistent with
thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/shmem.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0cc7872cc576..93fb0a5dca5c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
 	int order = to_thpsize(kobj)->order;
-	const char *output;
-
-	if (test_bit(order, &huge_shmem_orders_always))
-		output = "[always] inherit within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_inherit))
-		output = "always [inherit] within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_within_size))
-		output = "always inherit [within_size] advise never";
-	else if (test_bit(order, &huge_shmem_orders_madvise))
-		output = "always inherit within_size [advise] never";
-	else
-		output = "always inherit within_size advise [never]";
+	int active = HUGE_SHMEM_ENABLED_NEVER;
+	int len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
+		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
+			active = i;
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+						huge_shmem_enabled_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+						huge_shmem_enabled_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
 
-	return sysfs_emit(buf, "%s\n", output);
+	return len;
 }
 
 static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
-- 
2.25.1



