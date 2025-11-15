Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709E0CE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA73A8E002D; Fri, 14 Nov 2025 21:35:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C573B8E0005; Fri, 14 Nov 2025 21:35:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EC48E002D; Fri, 14 Nov 2025 21:35:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2558E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:35:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50F6E13B6FD
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:15 +0000 (UTC)
X-FDA: 84111274590.27.06DF7FB
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 752FD8000B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=anpk0y1n;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174113; a=rsa-sha256;
	cv=none;
	b=KFvGECHf+9S9ZOclvZrjLJApOAbV6vDSCJYw+mhgUezknSmhPnSJXFcvmo3VYZI5B1wvMs
	XWudQKu/GOh3t3mqEBlkVYtQd2mBjaUdCJ7i4WXxoA1ULsE1J3g21ZzAJ4cu8INOuJsqiH
	7qhO/jkmaaCTme+b0oAsXPxUfnA7j7M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=anpk0y1n;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOd9p1bhE9EtjpjaBLy8H5nHDKfUvKLk4XDOygNo1pE=;
	b=w3ttWoquoutG+cgJJqnr7ne/EIxZvgzFXgnU2ZKBw/rsyRLDnbxfadE7GwitIlGaqzrfal
	zlCj20H8hZBdXw8zLZ/g/yLlHr8VXykaFmsW0NHuBGmLG8/D8AgTbxH4mk167+2qrxAyAs
	XHaObxjGR+UlSUUGQPH7eA6xvvR2YcQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2953e415b27so24986895ad.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763174112; x=1763778912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOd9p1bhE9EtjpjaBLy8H5nHDKfUvKLk4XDOygNo1pE=;
        b=anpk0y1nD08BowHgZcpWGHTkpdNvGZe8KfuqKZCPmHseYT02iO32Sdgxomqut4yfAZ
         UyE4RCvPJCewCZbPqhvJ95TSefn0fSM5d1J5op73jvd1rTWqYzsgd+WIjfV0oPBxkuTO
         YuFFIk6aromaHr7hr43skW0oYjPSwziO1QFVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174112; x=1763778912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOd9p1bhE9EtjpjaBLy8H5nHDKfUvKLk4XDOygNo1pE=;
        b=gw10tBc4+ZdU9pgPy/xsmN6MfIhTKVQFdCVsqVC/H9lZPv1z9nJfSMCMJ07AObP84T
         pGN5UY4c5o36KGv7qJTbrIo3TCtq0DRp0RdYUmhIs5lKSKrcjtUyMgQIkwYLhAXuDmZx
         QL19nMsSdpvrzCx//fSIgSS7SoPunkgCDpmvlgbNTkrhCriL+0hAOP87T9UBuUWrUljH
         0sHsQat91cV80mB0CfCNLwWNpgD0OOtSlIEiIqUucujzl0NLBgItjFXNAp5UapCWo3Ti
         QLto2jnRUL1lzrCzHUuiuz6ye7658CR6bX8kXYJHvWUlj+sAqwx0ls99bSgkZhYGu3OE
         pkGw==
X-Forwarded-Encrypted: i=1; AJvYcCWWxda/g7xCQXC5G0SUjs5wcNuIu/r5pX4BiXl81bKNZ6EtAYps93o1PeDI5cfnxycET9MmMP54AQ==@kvack.org
X-Gm-Message-State: AOJu0YzAVjdYYg3VcD5RFtcVYNvWLtMfZPMeJsGQ3IfgmdO78u/M2jxu
	8Kqx9gU2NIe9YRO/KfVacmwK8B2fUI3OmvKhlhq732PpX+fbYtrXg9mntFibH7GZ5g==
X-Gm-Gg: ASbGnctAL5jNGYvjzVU8mFnrAU2FRZJJqjatZ9hS2izqmRNUaqmMP+bvo1Z5Gx6RScD
	Uj4W+GrTujTSieVp5ii/eiB8Gz37OqNRkZsW+3y/BdVXUH94VJ0g0pOLHgsmnnQy3p9FHsM5Hcb
	yLbFw95vrIyMRfU55W+zSKQfwOHokHx+iVdlBSoPV5Uko4XMHh1arQBoHsx+jyP/c13RrrdAJrD
	iLfReQh0u0ftskjmM9bAcF6joMORQ1tOl4L0cuMAiLKT6elrs30yq3/NSyKBSgdCnamQXJqRqFc
	VKM9Aj7L7V16k1ow02j4FJgGeoP8x4EpttEXe74I7jtL/urt233U5WMpfoF/0rRuZ+Kz81cjvyZ
	feE+H2dGO1GNAWsGS1oAA+nWMOFpSv72OjoXnltWMKr7RE4kfESehj/hfsCYRj7XipU7pyBxgJD
	bxER583ROojtg9Vt+o3i/tgNiz2P0=
X-Google-Smtp-Source: AGHT+IHzkpY6gZM/cY3aeRPppAXw311i5GjcubtsX0WPOoLgk2KhW+0UonihGhlFXEg97h5sI/EG9A==
X-Received: by 2002:a17:903:2f86:b0:295:ed0:f7bf with SMTP id d9443c01a7336-2986a76b5b8mr60561225ad.58.1763174112371;
        Fri, 14 Nov 2025 18:35:12 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm68641555ad.57.2025.11.14.18.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:35:12 -0800 (PST)
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
Subject: [PATCHv3 2/4] zram: add writeback batch size device attr
Date: Sat, 15 Nov 2025 11:34:45 +0900
Message-ID: <20251115023447.495417-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115023447.495417-1-senozhatsky@chromium.org>
References: <20251115023447.495417-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 752FD8000B
X-Stat-Signature: qz798cdzfdubfn37f6owmjjqiw48ndxw
X-Rspam-User: 
X-HE-Tag: 1763174113-796635
X-HE-Meta: U2FsdGVkX18OFYrf4EX1F0rJvoTMDWk2GYCP01q/+nyC8u5kr7IqUpqosnX9fYEnenn7WhusUVJ5XCQREtdC8Tj5WOKs5L8HnMVfmps0hwXsOgeqQz+NI8zU6TI0I0Wv4qVB4MN8DrnnPyT820NxT2y8utsKkcL4jyFHM2HPwFphexKSenrjaUDkmDXu5Lwxbg4ZwCfsxaprKIrwQha1P4L5qpEdWzVCowAaO+l7jzW5JC1RT7o5dQxdktYE4RTnwAOORMmp/N4A8AhvcVJ9V3IIp58gHgpFEedQBOHunIuFSsJX3oMXjWBfDPeo400hGRfzUW0h0WG9/6IzyWbL1e3w5ugiuvqV6rtRZ+xu6iyEbQsffDRVFppmC2NM5f1TmXtjEgFId29XZs6uvr2taP8qqwmu5bELXiQCun1nz3hP8B+1HvYSr4svrkWKdm8CV7WGeaS3KcZQhN8QxfwEvW4vp/bB3lRA7CpToMA/Pf1MWE9xaZ8FKEahHbeJqNqsUCAexgK0+TH4l/ttfvB8TKUlUFg+QyQ9mfU+ywYA6yQNIpTvmLNu+lVt7Z6x+CL4BYcJ7SzoBkLS5C7RfZ6K0kEUguQB0H5J2bLAsgJb19aMB+bAFdCPV0I6M30UGVCP05kCCYyzoEo6ViPYzmMO5LeKfgIv0C0/fHy2AojWA+gRxKsdP2IdxM9SHqLc5vxGnqAIhSYr3ydgxUdwVR/CcGrejBDhKDnd9oFwHGlmHjQvC36WW69c78A4z+ncW5ihqG8r22yn4upxXH8Cw4JTUYuWpeQPdZaeTryCdzq1Qs6eXtcuMOZe4mjlX7DSriS6II3SNDGEanYZnltT5YJ7PbujCh6+HBAhv1uUJ8myBRkqzrBDCwHJTHnECdA/HHpKy8IKd6gVTx6f+nXRW35kx7Awpn2cyT3H99pz+MhORh7JJKx17upwEnTMC3MA1McUeQKLfJYLP7KFk6NVjav
 iZiP6YWX
 CZkHRyLUtW96wg1WW6MkB6hFnAFyn6FRSagP8YQTY/ynGtG4BxdOvx1fKZKLN+3r4Ic2s7Q6aasA/Uz7Pu2H0ETm5diDJGe0O7AZ9FR+0yBdVvWkZsqo1iVKSi+KOYVf86xvYEEjcaCQBgps0Ss33nIcgkfmURSP+aHv0ngS48+HK1UCv2B5DlJuLNeftZt+F/Bg534zdeFdpGFgOaFnQ3ll6yFojLf3BkA7Ux3G6N+3XcQdhgcI/ZKNYz9TvX2wsrPzjBG9eOMYtF/Dtq87DLRv4DtsqZDkZN5ofI/j+diJDx/MUByuH0YGVXA==
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
index 84e72c3bb280..e6fecea2e3bf 100644
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
@@ -1180,7 +1213,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2821,6 +2854,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2842,6 +2876,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2903,6 +2938,7 @@ static int zram_add(void)
 
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


