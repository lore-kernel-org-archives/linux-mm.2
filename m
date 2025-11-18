Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6ACCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B417A8E001E; Tue, 18 Nov 2025 02:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3248E0010; Tue, 18 Nov 2025 02:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96CC48E001E; Tue, 18 Nov 2025 02:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82A4A8E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3895412E418
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:27 +0000 (UTC)
X-FDA: 84122904894.04.245C867
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54E0BA001D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mr+d1CDr;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451025; a=rsa-sha256;
	cv=none;
	b=Fpkizf9caEkHGea+fqzYwIsQcdukxQp3skJq8+rsZ/n2Wd9lLqswKxXkxOowrrMH5zsCtP
	HNQEn//5KWjALdT0Y4G92D4pGU7L1oTWRY9DccjLYi16MTxfOkhvR5kXhZTz9N4RvM0Mwi
	hmbfuzCL6PV6MuVdAihqMy9Fb786M0Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mr+d1CDr;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5s1n8emEbRVEeKrAhj4AgcEk08attFm4KUuCDQvhIk=;
	b=goAH/BYK9fZbgeW1xtlcgh7oXoDKNyFpwHFLAp47ghRVdtIZ4XiRQn27LOUAbqhD4DIoqJ
	QXKhG82epOHbrXnd2j6tlb1RPUYEJ+Zb/DOeopEQjUipwoddDb0FA5JotV5Ik3Q/unrzMF
	wsOAt7lsKNMi23Wy8C7LVEkic6NdJlU=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29558061c68so60717555ad.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451024; x=1764055824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5s1n8emEbRVEeKrAhj4AgcEk08attFm4KUuCDQvhIk=;
        b=mr+d1CDrvZ5IXsa1ER0ub2mMwgRlAZPy1FuWmGm8R/m5EFYx7+GkuNGWzQDPVtJMSM
         Hq8ZBGkP73ZQOhg4SRVSBWnG4EP5CttXlVPhgSXtXjKhpIHXeqG/j8vFfQNPJqQIvn2E
         5lLPIS9e8Z1KW3s2bSTcpPsKCQPDBDpBHHyvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451024; x=1764055824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y5s1n8emEbRVEeKrAhj4AgcEk08attFm4KUuCDQvhIk=;
        b=gi6XK0wIJWUY9wcm6bmxQWFhjPbfNBN5hw04aFKUuv8dqK5iQ+kYcIGq3CAjT0pXle
         oQJiM2PLjy8tmIkxE2TsG7U1s9mvz0Ds4kbPLJbX+OUiIe3KTKWX1l7ONUk0QWD9WLma
         cJRzWugrqybnhSiaHjxBdnSeYlj0JU5ViRX1CMv+2oE3N0H+InkzekBv30E723LfusfW
         xnhE01aELOF//ZjtjFvNOFP4+ip8ry7Q5PkW0ZZaWIofqWfhSvLw8l78a3bAs1uqMKmP
         MUQnSIRfCc+oje9RAvYzCt6kp5LRT2MD3jbyvYTSKIOwF9f69jBg7qTLFYr/xk4RdXN1
         pp9A==
X-Forwarded-Encrypted: i=1; AJvYcCXP2UVvt4AeK1jFsr+dd4nVHgSAbI154IuA7fdr0yfbTsR2DyGBPDdvNJWe4XB2TKqUuVMlD5oMHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6Dsw9pNRAMZOUJBWxic5gfRqEj8FbrZqOKpxzG9XJG4jS9GJs
	93rkvt5Yq0EoxGnEuxneCBi4aaMcuF/+20JTOtuvOLI9jjOD5xIfPNs34pM+kTM79g==
X-Gm-Gg: ASbGncvZVmLwNt12R1ch/hzo2jJS4jags3R7Q+BHwEqNpSXFTbnZVum07hZszsMr1jj
	YLaHyV83Vi0LDIGPkfrCDNJ9GROlGbQMsL3t1slQSmlxXo4KGTVyW/GH5PgqTfZc0nxheF8Xihe
	NPH6unmV2ih4yWoCRePyzSVYv4vC1Fw6O4P7t8NSGi6q3AUIR/OeWin8OCJ+qNmGPG5gwqsTHVR
	wArN6FhlHNIQeNQDx+l9EKOKrLA+ydTBn7vCEZ2ncM6e5kT5F+6H4mLcK81Ju2puC0t94G0hoEL
	41Tf6ypvLDwLYEDlqeaoLpm0bCau6fTI16phj6T8LkazIXGblKRrOWtbiTxh7SkczlQKPXZfn4P
	0d2SyBQhSpOsmW3UXH/KF7aQWYZhqVbboBRfLlrdmOjGXH0JhWu0djG2zYOII1G919flDjlYJAu
	zJHaX2BYtZMX2RM9w7C7UrCtugjMk=
X-Google-Smtp-Source: AGHT+IEFUxpDM4RZB/8QnapGp2d+TGrwoXbvzGp7l35DJ9jW3FWtnGNox8kM6z3lPxn7O64J6J5u/w==
X-Received: by 2002:a17:902:f64b:b0:297:c638:d7ca with SMTP id d9443c01a7336-2986a6bf2damr172314225ad.14.1763451024123;
        Mon, 17 Nov 2025 23:30:24 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:23 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv4 4/6] zram: drop wb_limit_lock
Date: Tue, 18 Nov 2025 16:29:58 +0900
Message-ID: <20251118073000.1928107-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54E0BA001D
X-Rspamd-Server: rspam07
X-Stat-Signature: wunywu1cej8ahmrhf3krci8di9bweqq3
X-Rspam-User: 
X-HE-Tag: 1763451025-553085
X-HE-Meta: U2FsdGVkX19qK4zeMQpyU+dYdU2nYW6UItKHVMpQtO/qaXDMYHBCsmKZy010QOZuVLb7YaIPRWmmhCtTD6pbnJEI0Mp2QRGkXR6jjTh34Okjj1+AmR7Xfli/NBZMROlX8Wbv59IWZk1NUWGFhX4XQbGm8vGNilejAmHgE/f8avSrvCtx1+7m7+dd+oERb8tXPobwVYZ+ky7QPgT3anTl240BXriNt2i1iOCLJUM3zf2PT0AUQPIdeY0q15eEhNKasDH1nzw/QnGwipEj6hs4FekTqDAJF8C49KAhnafofN8+ZIfAW1vz3ou2Mhks5fg3jORgky2P6ZYWApZgWEXUfkUlxnTTKn9EqCU7EZTmVP697gWeZNphEXglAWVMELm8lHZ2+b4ssTW365g8/CQ3VecgDVJ2fsVBidWqlvFLthoMYk0NFXcDKuyIkMnG7oQrFIOUKqyWHlRabBoO19sM04OChO5xRMv15LfKabgwJ9D3k6oB6cyfKP0ebEMkKjGumi7OJaGFgDkuuJSmRUoD/io6DsqCa4JXlm8RkgwAUwo8DmWde6zDSxGBNODDpjUOf8mcgcDhPc4GQdyK+9GLHflOaDUrGOi2nS3MZjSCw+ttkWcU2edZOxu4VtEkwt2hZETiJirXKP26GCCiNARqqPO6mpf/Zgd1/XglyIoy4eCipFLNduRjRuFSu1o3eNpAES5ylUWqY2Uzd7lGyARbOPlaryOGEzoAWFvD9ay9T/nscoIv8ZqRw5aO04nJVvtXCdl/vPtFcficpkaVhSxQ57JOnqSI4CK7qcJiCJioYmm/lQXdhiKTZjoiEbyaGt6iSGnjvsoDvkHCPYzjxtMVfMzRyhc8FDUco4GL71ed6F5yYs5y5y6tri6QjtpO5rf1m3XPXiiBKjLLWUBjrdN1OGupbukVpXSY3q9bB3I3c1dOwNX7avuL6AV35Bu48qnRi4QdqTWMgvFbkrwGBvT
 NFNAIMz/
 X1Y7tnjySgdRqPNmQs9kOaUBUHvw4MMQcaEhwzR2HAVWxK/NcPKFvpTm5I4GHjCdr5yBd37Sv9/1xqx5cilsmxiyqVAXzUqO7dwaJAIXzek9C/vawsIcf9sNvao7HiGHZFAPLfJR7jB4e1AGHV8tq10UBSLFThXWRUo2PUP1bEgh4PuK6G/pa24PHro5sd1npck+SLLDiye4fBOLnVnkb1jWtO4K2MX0uNTjyu4sDj9BkmmYaHIWPh6VE5Fio5kwRGDYUmZbmrmRQcjLjkz2cD0YP9UBe/z1Rt51V2kxsnHTtm6i5FPZrReryGzyaMJZRs5yeaiKqcJZVfg7Sun/XbriitKHK5irvucrh
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
index 073a12132cb3..1cfb58516a8e 100644
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
@@ -992,13 +984,10 @@ static int zram_writeback_slots(struct zram *zram,
 
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
@@ -2947,7 +2936,6 @@ static int zram_add(void)
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


