Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7F1C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE076B008A; Fri, 25 Sep 2026 02:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F2D6B0092; Fri, 25 Sep 2026 02:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE956B0093; Fri, 25 Sep 2026 02:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8D926B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:44:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21B55A56C2
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:55 +0000 (UTC)
X-FDA: 85251346950.16.2448434
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id AE0301C0003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kPlKjomX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790318693;
	b=RaOKxefOwmnmtlze2pdJwPFgOroz7O5ZsGLtRXpZx5ryr6TqDtUEdIzYI2CmFMDTUWa8DP
	2xTtViZslU52urSi4YwRxxqrdZ6YEFWejrEjHfsDHAI+Eb2A6GoYMUFQtrOvznIBj+zFQE
	QE1Ztgmwt6Jn5cslPsNRPzWs8xUIHJw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kPlKjomX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790318693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E4G3HrBDA8sokqzu1SybUYi7yZEI+oyuX+vXgEAK1M=;
	b=Ydix1t6S0Asgv2lovxBXhWoAYG9+A0/jeQ2tJmxt17h5ydOqkVTAj3Yxr2QQcTAKN/8nd6
	x8xQdkKImMFQAfezEO0Kfm3S5dIDe0luSQ0tNjztNnM021hmspzrAc6geA+97CigL5AkBo
	RhhXUwhu/pN2s/KtJp59Xqt43PsWn9w=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0abca97c0so334388a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318691; x=1790923491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9E4G3HrBDA8sokqzu1SybUYi7yZEI+oyuX+vXgEAK1M=;
        b=kPlKjomX/JmvRC9YCAlY5YtekYRcFm4u15C3LrojNfDFuS41Cf0xi/Wn/Ika0/622T
         LgYz/AEDnDtkllJA5tbb31N05xqxwRqgGPsaPhODWcfd8atuXCxljw8RDkpJWZVeHkvG
         GoOoqgB6TXZtOsRE+dL9sTKZ+kkp1ZuXqMPGBf2MZLLrFn6rgxJV24GdSg7KW5s7g1Zj
         Evu3bAMAMCi3KUKQI+7b/ig/AdygNTinVAS1h0iOn37gGP6bI2NzhwppUuakziHGM6BV
         pkyKILOQHunXvg72aRSKns/0C61sUxwg4W2qYbdqih1oBYFSmpEGUpvha7aEALull6tP
         k4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318691; x=1790923491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9E4G3HrBDA8sokqzu1SybUYi7yZEI+oyuX+vXgEAK1M=;
        b=Hyn4dgXKWUcAlgJPgYHJB1JXsKy6PSEVL2aGgclfcUsni14G9LNJrO6KzmW8WkoncE
         G9JogkRzJ/7Hl7lQtucXK7vwvlZksB903Omlj2EoAbtSzl1g2YOvByaN9oUVlWko1KWc
         Mpg0amdHzXdWOgkIwzfic9dAnN068YZ15bYgQYQPwoicccZ5gVX5x4IpjlG0w9s1ojaI
         6MG4Z2vwjbTHMIzJspi4IhfraXQx2tNyFwHpRhZ01fb7wu+fezk0JuyEdPYLyRnPuABG
         f8mFlVMxsfQ6sjV0Grq2gtaTRVu9CFvwv65mD1cnUOFBebdW/87OwDrxkrS9Izqb3SlF
         wZ+g==
X-Forwarded-Encrypted: i=1; AKwUvBwCp1iietAq0hSbba+z6ARjmB5wGc2kWQIk4QDAHCtZzctjFPTMy3mZ4fm9DNMW6xqaS+H549i44Q==@kvack.org
X-Gm-Message-State: AFuF++mzP0eXCrDbjTCogXDA/UZYDawV6XV/q9ThYdTQYH9L59RaimSD
	1l2URXuGcOAkI8ClfcMFXZ69qUL/8feucDFHbuGQUbWmRVMbiF8WEZbMw27c0K2StPA=
X-Gm-Gg: AYBFou3MlVpoco9d57QD4Aq5qaodrI1SvAZ1foiFJ3ECMpB5TT3voCEgp3Li78014kU
	mjqQ68c28dW633EuVSyOYuzeDRFWqi5wq30Z6zyzAzxChg9Rqm8tknnKiu0PMzrvpUPWlMzRKBm
	wI8PYoB6vig2Fwinrm8Fb5hZUzJUdgTLkhjhu+2QoLXk6ogzrscIsgciNqx4oKjLr1+tnR+neho
	9/zdtajyagLhG1Zy0WgHV0gdiIctGLY7LP4ylnmdiqXs2Z0c0ZKRCXjdUhFy1bl9P1b06K1CJ2Q
	QesD6/MMDk0JzKABf+5BNL905OtOHXenkhaBz5qSwJtlGqlNx6SqHzt54IrkLtx9wmBQc6Xkflz
	nV1S0RJBZGJ6jn89QjkxWgqnoS80YWIlsItKA+xYVF4Xwm8vrDGy/Kthr7FimOkLj03PR9Ah3Zj
	OG6ST5ZPiUY0EqqfARpA2JmlRj8AyuE0BUYU1C3Ka8wJyrM27SyUIpUsktEbfPGt1MItiCkNy0p
	Oo=
X-Received: by 2002:a17:90b:48d0:b0:3a0:bbbc:6857 with SMTP id 98e67ed59e1d1-3a0bbbc6ddfmr1068552a91.13.1790318691065;
        Thu, 24 Sep 2026 23:44:51 -0700 (PDT)
Received: from localhost ([106.38.226.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b94936ddsm2594150a91.7.2026.09.24.23.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:50 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Date: Fri, 25 Sep 2026 14:44:42 +0800
Message-Id: <20260925064444.3944820-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925064444.3944820-1-sunjunchao@bytedance.com>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 7cdpw6dno5zr8ty9mj3qp9u47uy9uqd6
X-Rspam-User: 
X-Rspamd-Queue-Id: AE0301C0003
X-HE-Tag: 1790318692-989496
X-HE-Meta: U2FsdGVkX1/1pGABA4Js5RnKV2lI6TpKRclkyukcxgLipfYPMHHEjjrMeeKKhW9bxwoURoZlJjZgty15pPpUMvaQac41BkW35FdXZNpTaane79FvfujGDYYLWel6liQUy5NPOLup/W4+uVvGN5krCc/gnOzUxDNl78sIZw2TtgybdSGhKZ84dLp+NToGSSNUWj5SFmfmZY3Gj/QWkcryRQY6cbXSSSeaVMD7nSev0G/EMI9DgxZvKhMjStrc+nc8j49Dyw3XiBdKhU1zWMevmu9bJcoVgWnJyHXom9u4cAXLEbUVWWQQJZR6j+lUdfYM2UPUsL/XmeA5Q+nCsF+nHMLa+uXpipMYZQZi1a/h/susCfriXjx0VNcZ5wqGivexzz74hlqxgjzrHH2F+jrxZjBAQ8ayXUEqSa1OTIE0d0MLRNF0vnDdi9/ZnMiPL/IovGd6gavkNh82SQQyqFwMfrLQ43Esx/7f95coHW8WqeiGrqD/wqgQLjqAcwtKJuXX3TN3X0SrZVW1J7l2OWjcSRa8aveqmQXhxOnTQGSbgeRty+uFb6cyNJizC8+ea52h18pcRkOCLoE3ZylJW5A1DZoZAGf5FnLz6ml3fBPcMFnBiMiz+igMKsvbUEsMwdHaF5aw0wTcyaV0GLq51p3yLqkTa6PkwG/ZLpQtVg74wFEu71xufr0tMJ4h69tFzGnc0IJp/mrTpJKMYWTnSGMDJUs0hqP6dhDDBKjQKRX8KLLXFwggzF2ST+mTaZuW4STXw7i0/xfs5XqiN7J1vLtgDZ2GV24YfcjqOyt43pWPEm+98XoZQz2GCzZap8mdITsk0CAhzqGfLCg0sHVObEx0AOiR4GJzn2gRE+BPd7F7FcYSh0phQj3YZ30RokC+uul3s8m/0QGDaNOhVOGElqWDyqnbdKSR6kqDPTV3F4qWSg1bhP6wy2tLkTdppItJIwBU4x9+t5Cx7+EwI8ds92g
 Ec/gFX5g
 2ffq9KFK6SuxyS+b1J0xPviJK0TcR2Nx6I9Fo6CykLwGd5ksilMQhgIKG65BAh528KXTu1e5uJo1dPrzOXnBVONxJ+ogIRZhbBjarXREIpK0kfI/X/Ndv26oFrjKg+j1VdxoAZg0zTKcgL9WCTZNq9tcaQwmbe9H4nJEA6zCdWGjgnxiZggj511kt3ForoGbZOfWAAQSeFZ4AqH9mKqtn++C0NllH3AlS4uqG4TcI70kTqz0nm2eOHhw5XVNwBEuG6pZYU4Fu7qULYW1MKF2026ufrzmHYNKNtio5VXFZSiHTv1KfcXFlrAAANm/IqTG0dmmJfwJxgUQxnGZP3t44JCP5Xi5ch1qRfwjq9W9sh5/FqYG3HrFmBXz34Z43d4s0Kjx/smv7ZdFN6K4S/18TGG0h2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bdev_flush_by_dev() to submit page-cache writeback for a device
identified by dev_t without requiring callers to hold a persistent
device reference.

Use write_inode_now() with WB_SYNC_NONE to skip inodes already under
writeback, avoiding competing writeback passes from multiple callers.

A subsequent patch will use this helper to flush foreign bdev mappings.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 block/bdev.c           | 19 +++++++++++++++++++
 include/linux/blkdev.h |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..8925f81f16ae 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,25 @@ int sync_blockdev_nowait(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
+/**
+ * bdev_flush_by_dev - attempt writeback of a block device's page cache
+ * @dev: target block device number
+ *
+ * May sleep while submitting writeback; does not wait for I/O completion.
+ */
+void bdev_flush_by_dev(dev_t dev)
+{
+	struct block_device *bdev;
+
+	bdev = blkdev_get_no_open(dev, false);
+	if (!bdev)
+		return;
+
+	/* Use the I_SYNC check to avoid concurrent writeback. */
+	write_inode_now(BD_INODE(bdev), 0);
+	blkdev_put_no_open(bdev);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..27afe3ff6fb5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1710,6 +1710,7 @@ void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
+void bdev_flush_by_dev(dev_t dev);
 void sync_bdevs(bool wait);
 void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
 void printk_all_partitions(void);
@@ -1726,6 +1727,9 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 {
 	return 0;
 }
+static inline void bdev_flush_by_dev(dev_t dev)
+{
+}
 static inline void sync_bdevs(bool wait)
 {
 }
-- 
2.39.5


