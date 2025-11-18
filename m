Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0434CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D4D8E0015; Tue, 18 Nov 2025 02:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECFC8E0010; Tue, 18 Nov 2025 02:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4EF8E0015; Tue, 18 Nov 2025 02:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17A7D8E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0A89B90FE
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:21 +0000 (UTC)
X-FDA: 84122904642.11.ED6F63B
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7A7AA0014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jjOEIFnQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451020; a=rsa-sha256;
	cv=none;
	b=WgvDQh8WHwLVQKidx9muu5vxUBPKFwnBVxLIJtZC6k8eFM4ZZlHjb+99IhcWJpk1XunbwY
	9t0yqyy8UmmbmNGbn7tYZ3PIFcQdNxkC9Ei9M2PTTzP/KavIT5XuYMramahgFJC8VQv1yP
	JX6tkHAGdVPNfO0ohqiCZaLABAKo6/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jjOEIFnQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVrPRt4Q28dKav7HserS19FijFvKacb/VGjhgi5CQXo=;
	b=mwvmBnVZCRZ0ZER64erRqiTDaB5SCV6FQn4VPZ4TRHaN0XNApFN/H38Th7/KVu83B/oJhk
	tpF3gtZBdGZD2rpDkzEN3/mie4Wrx1ZqF0pFyM0Eb9sxJ132ktlUz8sTbVNslj22awpJX7
	8iI1Tj5RCLpBFWjJ0RxeZMKBCXq5WP4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-297ec50477aso37271265ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451019; x=1764055819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AVrPRt4Q28dKav7HserS19FijFvKacb/VGjhgi5CQXo=;
        b=jjOEIFnQT1DWsbRpsGe3zhV9D097dVxD1tYgQAuJrbtnHN372xfYr2AgxICbLqRsJO
         +bns0nIMUCVqXqlKWm99/5v/eAYtX2dudgGKj3iR3EjDOTitZHiMoF6VQWact6WLh7eb
         yLfdFApDGGASEQxB0Ko5yF9epm/zRa3zEdpJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451019; x=1764055819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AVrPRt4Q28dKav7HserS19FijFvKacb/VGjhgi5CQXo=;
        b=apM5qVWkU8yD2mesN0J5EKX4Mujgyfm4ksxasCRrL7atjDZKDSELvInvbw+w3dTz8C
         vw1RNYZCVLDKeoGVkjMmUw7u0KwKUX7XgDbdHKsmVY5IOJ0bEmo4JmRIVTl3axBnjDXs
         Pf2bCwpdLMnisl5JbWG+BNEQOgBgI3s1l7CWXIwvoancS8jJBM6s9MxxdLkZfW9e3KkV
         lK+D2tymfwTozzbIVOpU4Ny+Z7UoAMjl3vQwk1DRMD50a8tZGluc2W1PWEE4BD56W5h8
         LTLFUwizRL6OH7nEariT2H5ew2Gtt9/zv2lORIKyG7fuPKNFA+lbxMwHHHI+sjQq4iXw
         B7UA==
X-Forwarded-Encrypted: i=1; AJvYcCXWLm7mIJxZDvNWR3vaFOvs0hyAyYaJXk7qFZWITQG+h6RB0PE4jjyLsq1hhpB60fISc9kYI8Q2jQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1TEqrxqaTlDDGJiw2vOVHjxqiR+tY/pDPWk67eKpC9oH8YxKd
	P1m5nvhWKusJ0bJGBu1z9ivjASDvlnogDB7bC5oyOyTLYyEbqHA2l3gqPQz6cFdh4g==
X-Gm-Gg: ASbGnctiJwaV7Q8NtZdyK97dKLBlkZ9MTOTIDw0U+8lI0nqVwVBN8gt/orV75TMqbrX
	bouoRySsKDLIw7Lh3qGKpQeuoV24++VuGTXQao38UMfotaOmJJNtKTwohmle33uVRwx7lHuMpPH
	50SdAHC7dMI5tGY4yNQMndqN4icOUYlarFzV9c++f6jUYGbLVaGZv5Uh0C1REyrWq04oUDfnRy2
	smWrAep7y6tQaH5nWEfJz2mQhY5zgFH5NvT9X++bkA8E2ksgSmwariNAU1zsWVs58VWpTHUqSz2
	uEdlSe901bQI3vutaUfvJq5ZRXD/XX/UTjVOK3ZK14G6pV++EeYMNn+F5YWQdbVw2tFiuiW9RRm
	9kdKQQslmH38D9tRGkbfowG9CTwBGqCxw4n5PhPBjp49sxM+SNs9sfE5wAR7CmnCv3pJswmh5Fw
	Pb84WTKfGpxLWEOgYsoVzuCR9T6vbGeEC9NS7ffA==
X-Google-Smtp-Source: AGHT+IH8beW/w0lcFBPafVCSixbqD2wiZbB5SYmhJXK7ukSZHGhJTLatf743/ai6p9Zl//4nec99vQ==
X-Received: by 2002:a17:903:38c7:b0:299:dc97:a694 with SMTP id d9443c01a7336-299f55a1d97mr25472885ad.24.1763451018460;
        Mon, 17 Nov 2025 23:30:18 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:18 -0800 (PST)
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
Subject: [PATCHv4 2/6] zram: add writeback batch size device attr
Date: Tue, 18 Nov 2025 16:29:56 +0900
Message-ID: <20251118073000.1928107-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7A7AA0014
X-Stat-Signature: yn5z9ykaxwfsrtprin9gw4s6ftenywee
X-HE-Tag: 1763451019-324666
X-HE-Meta: U2FsdGVkX18n1Gf4aLTEg0UiJPDYbqbAk9FhF+b1RT8CE7ofK+4buJCZvtV8Og0tXAHs+gxQL6MGoJ+XGF8wyeW7K3VpmTZ1M0C1i6VIA0Uo06w91LrIDVb8S50FrTqn7gCSH3EmEmBNpa10dp9olV+VuhLrN1inj1vnXyZAVmvzeKoI8hn3OVjsFKtBUmRwK/GA4qM+2EbArdQTflWDkZwmQmP71KVKOsxaqiXDlCug3EmYLDwCFOPDRZSAUk2CIkV9A9bv02ds0wXpTrUy7E7OruFG9+KFP0gf5lCh/2tbmbt2aYfV1LcB7if2kHHNoXH0zjB0vcbDTdIiNE5CWTwGDZR2Ea8OKq02FKM3f0mL4vrh7hUYnv1hAfn0eak1ihjmF4vK0UzgaZD/21RGwY8tUaBgWiZW7+NSZOx5nTbdQ1X8WOOLbvN1SpC3GUqg77MrxaDn89/rG2l9nysxyslnN+OoeGnphJD8xWX1L3r9hKSPRiRgTfMj9ky5JmBu6GhYzhf2J6SxRdSEEwXoI1Neni0QnZlJEL/25sCyqKwJAouO9segWYPN+ybh2CYOvd4x5j3tBkqaooNrCB2JXWUmcwqIE4zwJvWVV+wPwl4zavmGq56eN/pF6VdfXP/htOBvyvMQ8aqZOVgF4ltpmNSINO9QSdvLOU5h0nGzPqxm3gbm4zd3Z9BAfyDtvP1ceb2qiuRKZy2RoL6GbIdpaD0akKkBZdgoRvN1VwfFaCTIbuG0j8XRaH8pmwUbEa68Zzgcbr878fzOyQLmCksgYcHmiiJTH6HQnysXXKvI+peN7RVtm0cTjVPzBBAe/p4A5yJ3eUeE0MyyA6I1Ee5VIatEt3KziK57jMCmi2qOxyL8oamfURe46H6DvKvTzbxf2kvT9j4TzbN8pUtkym8t20JL9E8sAq6ckUiNiINcuUcFl9vXqWB5dTnm0s6d4qwLqtk33ekW+wJxVhLzdYn
 gket+i8B
 eIuLIbsWLdzs31++dEJ5O4O85e8zNRlgGV0qeNCtRunUWlY4+HAO0ogeUzjO68KoU/peaad8jSR9VDf07SFRAvxQSQTPiEJnR/+s0D8gqe1osSk9l3WyP0QE5Zdhv7TflwSkEvu+eN35CTTiWuhbmzrVlWceQlj4A2MrHAynJmF0x+Baa67pAViNzMkiA5fah3JkYj1OCcbNqsn4PxB9s0VUqWhEmca+vysd7aDZuv/iyC+/Ku8mAVcpJCj7bW+UrLh/rGldapIxBUqN6iOLSHPCysZAe6UJ3iEh4U6jdusPh0olM8m0G9gNLDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce writeback_batch_size device attribute so that
the maximum number of in-flight writeback bio requests
can be configured at run-time per-device.  This essentially
enables batched bio writeback.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 48 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ea06f4d7b623..be39fe04b9b1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(struct device *dev,
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
+static ssize_t writeback_batch_size_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+	ssize_t ret = -EINVAL;
+
+	if (kstrtouint(buf, 10, &val))
+		return ret;
+
+	if (!val)
+		val = 1;
+
+	down_read(&zram->init_lock);
+	zram->wb_batch_size = val;
+	up_read(&zram->init_lock);
+	ret = len;
+
+	return ret;
+}
+
+static ssize_t writeback_batch_size_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	u32 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->wb_batch_size;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+
 static void reset_bdev(struct zram *zram)
 {
 	if (!zram->backing_dev)
@@ -775,10 +811,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 	kfree(wb_ctl);
 }
 
-/* XXX: should be a per-device sysfs attr */
-#define ZRAM_WB_REQ_CNT 32
-
-static struct zram_wb_ctl *init_wb_ctl(void)
+static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
 	int i;
@@ -792,7 +825,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_completion(&wb_ctl->done);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1183,7 +1216,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2826,6 +2859,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2847,6 +2881,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2908,6 +2943,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_batch_size = 32;
 	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 6cee93f9c0d0..1a647f42c1a4 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -129,6 +129,7 @@ struct zram {
 	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
+	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
 	unsigned long *bitmap;
-- 
2.52.0.rc1.455.g30608eb744-goog


