Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608D3CEACEF
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3F78E0031; Fri, 14 Nov 2025 21:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB208E0005; Fri, 14 Nov 2025 21:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7EC8E0031; Fri, 14 Nov 2025 21:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2D68E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:35:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69B6413B76A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:22 +0000 (UTC)
X-FDA: 84111274884.20.679510C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F80240007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P8VtsIp0;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4c/dqlofQQ1Cq0Pw+ZOefCVsG4PeXoReJklWLO52f0=;
	b=M5F9Jkq4eJqJPWSQUH9a+mE/aOB3zi+neNiF4CJyUKLArew01302KbTSu4ADWIobwxPTmZ
	wyTMMiSu3pKlIP40aj1MiAf3/vRD+x6a0/gpk4k4k/8mOipE+qAPsBw5pAMDkbi/QxsJUd
	JMcijZQiYQFPmpW+/N8TmTFj0TYBwj4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P8VtsIp0;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174120; a=rsa-sha256;
	cv=none;
	b=eqt5jb51G7lAILJKNkoSi3D577qPmeIsxsXd2BYL3FyENActJGjsVXzwKh3vtPRisCp2fM
	oVHz8AhLqIINx0lKGYUZVvakFB9q+RLdDC8dgxRvzTyFKEwIgRbP5FuzncI4sRfoXfuXIA
	v2IrQdPH1Jc1u3Bp5ZOPbOQMO5KoJyw=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297e239baecso33800495ad.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763174119; x=1763778919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4c/dqlofQQ1Cq0Pw+ZOefCVsG4PeXoReJklWLO52f0=;
        b=P8VtsIp0dr9KSanJH1REq3alZirCG7hNJKodCvhmcP4cgL/Vh9oO9wxXT66JDcmUoX
         uljTd+DiSRS+piOBx6wdM4AfB47jFho4KujJf73hpOha7KSlz6gCakk8jXhNWOw+BVSc
         kKtKw4NlQ+jDbYbjtzbsNkL6qsLWWV1bzDNyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174119; x=1763778919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b4c/dqlofQQ1Cq0Pw+ZOefCVsG4PeXoReJklWLO52f0=;
        b=VuJdMMBUkC7/Vsygl80ewIAsrSndaC+rNF5GXa263pOm+4CeSgTtgXtLdkecESxL84
         VAByRvDJphSmOVZxCfiotAk55PDp1soegTOiGnFPMAEAX8bitl9baoKCSVAmKM+OT+Ms
         YASuIYrWj1bufYVsWHReILmOaGt3H+59Qzi5KiwfyXgDBmfr7ivYhsIOI/zd5k+VGdSf
         vr7KqJrw+gU5vkngE1aWbnImods1bjRtDv4/HlJPlVqnWneiD9QstAIOxs5R7NpUlDIN
         oAZsBN8vvZ+OOIN+Yydt/cFK2vRRVbmvj82djYCRa5qJ/Kx0vkW9/TIfRilq7mtiQ6PZ
         /e+g==
X-Forwarded-Encrypted: i=1; AJvYcCUhkOJDFxtDfDxJ7CKQ75yYv0sE0/1CFvRp0Lbj0eglIJ+FJigYGl17NvjzoUO2LsG36jWHBr84cg==@kvack.org
X-Gm-Message-State: AOJu0Ywhkgn19PnF36Jh1pDkJC7v2/ugUuaD5vTjpwUxew0YK1GYeuoN
	Ye7KOQMjoswLzqHcGqBTFE3jZTKWwR7NfeYjGnRpXigyx7usnvTh2Pq675NmYdTHrA==
X-Gm-Gg: ASbGncuYtkCgywYXVKer9N90FMKJp+n5kh5tb9AIlMGr9P5khyYnQKmQrAK7Fk4mgdS
	GPpyY/SdGGjQYUDArCCyvUPPAl7tardr0eJUg4aiw6pTL2jJmicH2JwGR2/Y3FPw6wTE7f2gN67
	yuxDypTrSS0LS/b1UTGredfjrYqTx5DlZXQJw4a4clKqULDT+qYjyZaZ+NaHPBieLkcDAWOpQb9
	JzBkevmyzlYomf+PpDy86T3dg4kD/JyddDqgcm35fFEr83tPrevRkVqU0H9HNJaZ0fZxlSOYQ00
	xYizkQDc3esDfPshGYq6wvxQ0xv9yokEPk+9AupRxLm4zcxoxF3LekvfuyTqR9QO3+gdwFJbqhj
	ZHDOr60ieGAeDFRO2dtmLicy1XcsNe3WeqgKfwsuivcSnrJaG6VWcT6w+1w6uTAEF9fBUMdyj2K
	1fgbFhyWXiKVHRvn88VMBMiDaRfzy/Wi2J+g+spw==
X-Google-Smtp-Source: AGHT+IErO2AnZLN2sgTOQ83bbSpiNbBMpGFTea0Uu0P8ZBl3yHBz5eWOR7rGBCRpubc/taMzYWS5Lg==
X-Received: by 2002:a17:903:11c7:b0:281:fd60:807d with SMTP id d9443c01a7336-29867ec97d1mr58658215ad.2.1763174119552;
        Fri, 14 Nov 2025 18:35:19 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm68641555ad.57.2025.11.14.18.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:35:19 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv3 4/4] zram: drop wb_limit_lock
Date: Sat, 15 Nov 2025 11:34:47 +0900
Message-ID: <20251115023447.495417-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115023447.495417-1-senozhatsky@chromium.org>
References: <20251115023447.495417-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F80240007
X-Stat-Signature: nxni361gw47i9b3yxkjjphwm9m8d7gur
X-Rspam-User: 
X-HE-Tag: 1763174120-229132
X-HE-Meta: U2FsdGVkX18pDsIcb5kbn+N/kMcjY8B7hl/TKWuFrdk44SFQFZkLn/i73s2N0/Mx09cWG5F+huv3S6jDkRJMetwflwT4rf8m9z7iRML3iWhwqaSFQmTzGMuhuqsCpph0VDoPmZa8eVfDJZ1egYx4AZ0jWCCuj6TkZeF6nZSsMyZ+OQMMD8855ruBbDhmMuvhuM2Xsvl1RvT8lRdyeJ4f3/nEFu6YAxHTZnnYUgiN4aT+2gYyNfTXU5Ha47KdLQh1k0ns97Z/BtZWzI07QAkDU7zFG1+z4Rde8kgpzfbvuDiHppRNQJpEhtr/nkUDHw4TrGE/gKmBsNGaRiwknwwlxFcmkcoDHfK8d0ntZWOeCxs/8BltA021NukDNuhu8V17Hdeh1Ox79LUKSEU7JxKJ/O3233rUX8q5DIiHqvWzBDmHAhdy5NCeD1BBo76dHF3j1Wxf6CfbBuP3ug4BXb7+eaO97zq555yzQ/ycl0OWkGT/llnoGp73kuVuv/gNjrAgLzpdYSzqjgAowxKIMjU0xEYSlaDFE6bWrw/j+WuFGw6Rb1R36lqtR2twTDKdBRYLmWqDn37qObhek8hYDxiG/WYO+tKADRiNWX8k6Pf5rCjUV5iVO4Ckdr8XTWcyhFgUqCQzMC+atRSN/yCHpOqTGZBD5OxvC+FkWb/FaenNaf5FGLg+1Teuvemis5ECJMb1CP2vi/N+mGK2XGmsox9a4fL692P/hVW5yPxpnLuYLTBwKQQDPZZaPxAxKZOgGZT5/jYYfqkd/XCHGNNZOcUnFJEnIu6Kl2Fkz5tfZd5dyTbqxTliPcCR0vzRP0QJFur5THst0AU2JX2Sw5+Dj+kv9Tdj92JeudQ6e4onGrBMWen51jkM5aKExKzuFXDlE+/jpRblbadzlWvoQJCSQMazq9aUPxqkMYoZh0G3L4JEjHZEpWmOXNa8NYZcy1gxyJHLjZYWrc0xHl9tpNfQ5kX
 g8mzE7+I
 lFIHlV+9UTCgDsheGgT7rtLa9HM92aYgNZkPgmU4jghxhdMmc3KXmzFFf1inFF/uH3remDgIKAR6bMnp19Y++o7TWAIta7aKUB3gVt4wmTAmi8YU/MksTdUHIR76EFryq+krMBdlcBSlt6VbhDxNy492yMYQ9RyWeZdKiE3Gy9WMk7Kdz3y+39aSaOLZuTLguLJEcUirg/YwMfsspiIHJqTLRPenA+7mwHBRy49yFpOgvGYtJ/shQmkrDKnjNB/NoXJ1+RdRgmWpft+sMewMKt/ef5ZsJySZByDlfuW+HyxkFpA3N8hreHO62ibByap/Xz20TjxUIwgNNNEZpKgRXzL3qQUkEs6rSTJ+q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need wb_limit_lock.  Writeback limit setters take an
exclusive write zram init_lock, while wb_limit modifications
happen only from a single task and under zram read init_lock.
No concurrent wb_limit modifications are possible (we permit
only one post-processing task at a time).  Add lockdep
assertions to wb_limit mutators.

While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 22 +++++-----------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 76daf1e53859..bc268670f852 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -530,9 +530,7 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -547,9 +545,7 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -567,9 +563,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -577,15 +571,13 @@ static ssize_t writeback_limit_store(struct device *dev,
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->bd_wb_limit;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -864,18 +856,18 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
@@ -990,13 +982,10 @@ static int zram_writeback_slots(struct zram *zram,
 
 	blk_start_plug(&io_plug);
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = select_idle_req(wb_ctl);
@@ -2942,7 +2931,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
-	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
 	/* gendisk structure */
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1a647f42c1a4..c6d94501376c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -127,7 +127,6 @@ struct zram {
 	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
-	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
-- 
2.52.0.rc1.455.g30608eb744-goog


