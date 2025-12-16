Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3FDD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0365A6B0005; Tue, 16 Dec 2025 01:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0182F6B0089; Tue, 16 Dec 2025 01:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A466B008A; Tue, 16 Dec 2025 01:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3C976B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:22:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 766611A0518
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:22:40 +0000 (UTC)
X-FDA: 84224340480.13.5ECE68C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8D58D10000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:22:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GhaIk9ep;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zu/aPcKxXc3G/+SG7emrL7RZpvxEzm7psqqNr+dNYaY=;
	b=Qw6pOGFj90L85VGEwOsEr//W261IGWpDv+JPmzhWGSPQzsogTDFMFU7mAdSP1o4RSCdPRT
	q1rWius3zPdqBe2hzhI02hJnRCF84RaeiEISaYsn7cWGihNl3S2/R1nZIpI3i56HCNutC8
	EfBoAv5AQkSj7bstFbmorDlaU1ld320=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866158; a=rsa-sha256;
	cv=none;
	b=ojvT3guWGcmCr8TdqeFjT3IMpRF+08SejkzVB0qfBmZwXm1+GtOywmJ1vVrFnpIWjB9uL4
	6WzdMVolcxJUfDz51GfhqkcXVK/tbc6rqUyYn/Jgp4Wq2zBej1KWGi3qvRek9i7xfUurtF
	DXuv6hX171f80sHACrWANQow6pWqH18=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GhaIk9ep;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c708702dfso2129249a91.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765866157; x=1766470957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zu/aPcKxXc3G/+SG7emrL7RZpvxEzm7psqqNr+dNYaY=;
        b=GhaIk9epubIPVyYP8uMSU+DCFxsXkBIKIJVt+9NZdlWIqkjeHCydzaWXQoMN0II9y/
         BWHNM+IBDd8K2Yqvqc6bo1rO9GlOIPGzTHix8tAovG0CA5sMitKSHS57Nqkt5b+HPJuo
         h3FLhUzOg1aB/fffXlPaZzNjIoi1l7roOPCPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765866157; x=1766470957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zu/aPcKxXc3G/+SG7emrL7RZpvxEzm7psqqNr+dNYaY=;
        b=YGzkTANup5XS1BLE6uVHRI9zjgAC7PVrMZO+it3Xw5HK8BDJKS1YH1I93ppQKn2+H7
         eD72uP8AI4gEeOKNzsmVFxYnZ13sco2Y6DqvlZkpXR6dAyP33cJkhQoiWdh4oTjIb6Ci
         TmdejQN7Qlf4aQY/P7F+sBHdzUlqKTdfP96J7cNRr1annKq2n089wLDM03I9hKQmXFjb
         1UdzxUZ7hj3lsUE7dVu90RMcA7uMFVqSrlfLdHpcu44pMy4vqV4JYN2SEpY7ZqODjgee
         eWq8ud2rZIJ5MziKeOnqjfDemNDFS0ZRs09JkIPAnP3gGZ+AOxOjvQY40ENYAk19ajtz
         5gLg==
X-Forwarded-Encrypted: i=1; AJvYcCWdGuJ4iggyYv0MGp6TTfz4nmsi8zc/jraeOuhmEZMgMeOiEPp67dgOkvczl4Oh6DpB+p4NxYWbJw==@kvack.org
X-Gm-Message-State: AOJu0Yyp10dLk+czhg7AEr8lU+wcaeu/xsFdl5o/mafsmsKUAoRoaPuS
	OnUgNpcsEtKd60OwepOxJ3YKqT+IgSskovDZ3Ed2kuebxstG7kcGPqiwmFRxenXAXA==
X-Gm-Gg: AY/fxX6zM+zeXvA9Zx8OGKRE0+bfoqYbhu3IP/wSZ/aeMDCs1udkxE1xJZxD1cvjqyp
	u74DwlzyURWQlewtI0mjGAq21p5fxhEc1Q4EfHJQDJTEelkqsJFAWSfXCOrO+nrfRKjxuBYQA0D
	L3WwM0etSb38rVEUeIwpfIX1KzyxWrAsFs49uMwWIbMAsodeXPc5uIDBkxMMMDWaMYT3VeBwgOA
	hRsuKzoyQ9ZXPQdFMH+IOS7jM9p4WHBXwmSva9IxUzkHyLjqaAOUnHbbGjUxplIaqrv8s8nmMWg
	6yuOEnKtUeMUECO8i3aC3mBZirkCtcTmE47e/ID0Am/hFaiyDBCm4wHvDgz71P5/DznfI0W1Z6y
	p9/kROOVapNNFFOvBfTzQ7HNj4h+fX4lOzo7+3WoC+QV8AEjgXxviMQ+AsmnJqsUJD1X+4AQn6f
	65DNXbB4Zq//DzwkGP8jcIa6iORWdUC8twEx2pint6ytjPRf2gTycFuKSqCUE9N5vMmRG9GLgCm
	g==
X-Google-Smtp-Source: AGHT+IGJrR7OtPtBhGm+9cDWg3KKBC6FnmouGC8vC5VDtsqiXV8EEGO4Aj1PKtsQ0CNxkvAqtSYZ9g==
X-Received: by 2002:a17:90b:180c:b0:340:ec6f:5ac5 with SMTP id 98e67ed59e1d1-34abd6c0312mr9010865a91.2.1765866157264;
        Mon, 15 Dec 2025 22:22:37 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:a48f:6b66:399d:86cc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe3dea94sm11038126a91.11.2025.12.15.22.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 22:22:36 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] zram: drop pp_in_progress
Date: Tue, 16 Dec 2025 15:22:23 +0900
Message-ID: <20251216062223.647520-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uc9id4uxopnh993oue5k9496nyepefnr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D58D10000B
X-Rspam-User: 
X-HE-Tag: 1765866158-870583
X-HE-Meta: U2FsdGVkX18Bgh9PMc5wz3q+9JfHikAHAGDr72u7ou57IMa6r+fxC7vQ//m8tY+RSR4b/3e2PBjA8AlPr3Nmbd0tvAMbF7+7n8oEs6NOy6Vo6O3nPZ+jobm3NWaXm/M38pfc5ONkXOx3gUNENfhy2YmE0MV0w0NrwSsBXCUOC0uko9FAi578AXuqjDcxWDTugATtbCu+cg5V9mNQpBy6sgIkTyRlkh7q+lyJDkbOvx51KG66ZPeY2Iiljkx/MDDqB5YZFQ2gDXCQdIttCoekYjEFy//s1ffUqQB4M6MLLiFd3CtNMTm19q1LciIh6a3Xhwu/EZLGGQOhGS+8Ro2YV5cSXDngo7SuJCUGbgMAkIZ0nXEzi/g6PstJ4d6tlT3BQ4pn2bFK6si4OloCoDiXqJD4zOR72wvdL4GQDkWC3KVM52pP+IofBZX3F5UlRM2YOsVvvOCSBkpUgHNkCQ7NWp9re5qPotHqFbWPrzEQ1b3TAVi7qxSVwobtCVpc+LozaB9ek3pnO3FrSFyu2dwbybcfB6WjpWbgCRPKs4eXyr8ViWdrFnyQfTbiPjUf96/kzjmW689kDfqgxFVMle/sbIXQUOr+w71OS0JEde2mf8Fze17C/mvUHFKGB8R1Cv/S+nJIJHX10ChlMaA7C3mEa9u3gXFrfrx372u3w5hnMXv4N703IFTESwh9E59LVB30/1BYoUl/Dh45ZoPQov8cfjKOjzeIviuBoVW8kRuxoecUl9C5etWJR1nzRCcUYWlmzsBP/XbCckrQSgvf3b1Q7XUz3rhRCz+3e9q8symwuR8ePgdz9df3pfIvtUmGUyAIG2G4CyjGrlzry39jdvIiewGN8z0QJnvpqJSTdEiFeZcuZGZFqL7M/IEFkJu8lOd9CNmH8IKnucO7SDVxe3uCrcqC6WyfVYAGGg3SEAIWVPEOuAAwuAVAlACwR6749brK2Vcxo0sU9HWTpYdn4CA
 2T7CqoCS
 2i5inJzvYqC1vu53Br9akyV+IqtMxD7wgitNh6o8i2WiPBQQVT/tmYkW1mxxsTe6DEuRph69thXpjS9LakybAIYMnysNVgXZnlAciVwB2bi6FkKfowM8+7lObqjNfcAxRp3Ao5xxu2ti21WxbAPq0K6/u8L8t6m8d6/LRgOL+S+0QDPlK/oSKogRlRB1PSgJSFnx+pQbaX1u7ZDsyl0cVFazLAiHEKMJOppDrvcuYAx19q/nMDzD86GUmb0WwOZDPGohrKqt3sj1EhVT9RniAjXTaza4SCbFlxUTwUQcqF2gYTwTmm/zOOz/TYtSDp8ugFdQa952gpKUMkTqPPvdGe3vxgSObrwNjfxHNtofur8s+0UU+Sd+nwOBaC40cvb4WUBTWx8QH8k13kPDTSiVHe+w38A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pp_in_progress makes sure that only one post-processing
(writeback or recomrpession) is active at any given time.
Functionality wise it, basically, shadows zram init_lock,
when init_lock is acquired in writer mode.

Switch recompress_store() and writeback_store() to take
zram init_lock in writer mode, like all store() sysfs
handlers should do, so that we can drop pp_in_progress.
Recompression and writeback can be somewhat slow, so
holding init_lock in writer mode can block zram attrs
reads, but in reality the only zram attrs reads that
take place are mm_stat reads, and usually it's the same
process that reads mm_stat and does recompression or
writeback.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 28 ++++++----------------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 634848f45e9b..47826d8ed376 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1264,24 +1264,16 @@ static ssize_t writeback_store(struct device *dev,
 	ssize_t ret = len;
 	int err, mode = 0;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
-	if (!zram->backing_dev) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!zram->backing_dev)
+		return -ENODEV;
 
 	pp_ctl = init_pp_ctl();
-	if (!pp_ctl) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!pp_ctl)
+		return -ENOMEM;
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
@@ -1358,7 +1350,6 @@ static ssize_t writeback_store(struct device *dev,
 out:
 	release_pp_ctl(zram, pp_ctl);
 	release_wb_ctl(wb_ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 
 	return ret;
 }
@@ -2622,14 +2613,10 @@ static ssize_t recompress_store(struct device *dev,
 	if (threshold >= huge_class_size)
 		return -EINVAL;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
 	if (algo) {
 		bool found = false;
 
@@ -2700,7 +2687,6 @@ static ssize_t recompress_store(struct device *dev,
 	if (page)
 		__free_page(page);
 	release_pp_ctl(zram, ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 	return ret;
 }
 #endif
@@ -2891,7 +2877,6 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -3127,7 +3112,6 @@ static int zram_add(void)
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
-	atomic_set(&zram->pp_in_progress, 0);
 	zram_comp_params_reset(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 48d6861c6647..469a3dab44ad 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -143,6 +143,5 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
-	atomic_t pp_in_progress;
 };
 #endif
-- 
2.52.0.239.gd5f0c6e74e-goog


