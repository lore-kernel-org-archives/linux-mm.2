Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DD3C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0D86B00A1; Tue, 22 Sep 2026 08:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9822C6B00A6; Tue, 22 Sep 2026 08:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898796B00A7; Tue, 22 Sep 2026 08:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66DD16B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 693B61C299C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:28 +0000 (UTC)
X-FDA: 85241381736.22.469B86D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2AD271A0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=igJyGgxZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMP+BFq9ZlWmX2QdHDpHEHKHpmhLYaMmTYZYw81jZH8=;
	b=0v8gqVTQagAQxLpcERo/UldyJmijiXed0+4tuU8Z9FPAD3rT1LHdf8DiztnqX5/1Npv0MH
	UlZ8q/nI3+z5ugD6ct7WfQjZpd7TSKewVNyyr3CkS8HjknynYHcORiLFW5cbcor3CJNi+5
	HIZmgT//tAEThKrEt/PDYCi1TsAAQXY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=igJyGgxZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081426;
	b=mbLHBi69LMUzLFdt0CFDaIE7GpjVgsL6xs+dQxXKk97HvcUcQooSR5wv6qWef9WqdT1Air
	AiqrPmfkO1mXn0drcL8w4NYH9hSx/SIjcrlhOvxpdfxqOuBQLmTa06Sf5+tDiXXv4yWFYy
	c2pRzrF8HpiQMD8FZaqJyirhI15wKVA=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb752so3358400a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790081425; x=1790686225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QMP+BFq9ZlWmX2QdHDpHEHKHpmhLYaMmTYZYw81jZH8=;
        b=igJyGgxZpHSQiKkq0jreED+BCQOrAQzlv2wNZuNLzn5ox5jwS/0+jytFW1tCokLLz+
         sy4TkJ13KFQuvb2cpmKJwLYUfrbDs/7Y7WBR87pZjKCLySohL5ntnhWnWK8RaZnrIQBb
         3dONY6L6XFMI3HZAe27WaVbxBS6Y69dGEvQOQj3MPQEPNPwdCcnBj1ORyF5eqWFR+sRu
         iGXkvghncsi+mzpKuqx7EuTyt2KDEv75GHpa7YAAq/VKoh/We9trE96VFYDlRPy13Kk5
         t2gC07Gz9y2MJXurlpu1fFwLkMww2YAjiFEAstdfkn9TTVGyhMGLaSyM3qPYBq3p5hFw
         V9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081425; x=1790686225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QMP+BFq9ZlWmX2QdHDpHEHKHpmhLYaMmTYZYw81jZH8=;
        b=C8TR4ouG3gocVqkkvdIHV73VBot3tCVsmSJKv6FEkweW20/s5q9SOBz8ODdf+/syPz
         neECKYYbzUCK62tZG4bM1mAiaUwkYskd7Y0Mko3PZzbl3qGmxG8yt/GoS3IatEk3RTGz
         n28q6l9V/ma29A8mxKqdaqQOITLxcauU1ibPHQ+EZIdSv9ty6FwkboIJQAkAJZslxSQO
         YUBxqYl8O6c0itGJ0Rpn5/HLK7+WaA5400STq6TNzpisZJDFl+D5ccg54JpruBr26tMu
         buxBrf0MLZRIfWT2dUnbVEq/Q9H85EmKKORsa8rFK5nbCGybss6LsE40fDllq+fY715R
         F5TA==
X-Forwarded-Encrypted: i=1; AKwUvBxMJ1WoLJZgjUwpbIbaXX32EspUST/aEmfBNQ3koJ2/kUTzEmgRWvV6/LlDP91OUxsD+Js0yrGjgQ==@kvack.org
X-Gm-Message-State: AFuF++kYOFEVyJIVDnjFP3GLwThxzLJrDTWoagrVeDkOhr0U8NIRSHMR
	QfGha7iMWMDYxS1Q6rT4gOt9sI0OBInafNB9aavcV9Sjacyhev0E05Mi2+0eAImiYSA=
X-Gm-Gg: AYBFou11Ul2F++XTReZGzssn4jJqHfp3LW0eYNvhhq2oTlo/b7arrd3ZlZzF4l8rT3N
	S+G03xj4fUBMdkAxI6m5IHO5Gx8caTkxHraDcFedbwlOMwLlm4nhm0jMiWxsw+VYUDRTXYmAFmO
	PytZUoLcqsA0gYHxW1oeZATkDuCPw+hKkHMoYlDQy8QoQTcMfjj8r3w0claXzTYEKvhZAjjLoiX
	aNoiDxDSITMzRjd/Zlkb7NWvgo+kaGJppATfxyRlNCclfVKxSA+r9jfPO4gGoSKoip70wyMQhXd
	5sQodI9tnSQ8xOU4/tS8J5ZbiyUz+9rHtfzL5v/Tn8482oUaMsPmwkVFIFX2Cn32rBA88umdLuZ
	RY8cMB4A9wJS0mGml235ccdIJNq85fB+tE/GQMA1cqQyAJufheKyhooib6OLTDNVJcD7TE0enF0
	hsFFtB2I5P3Sb+5uSjKHdUqRob4Xf6+HOmAdSLaqQJLDp0qeOrUTG9lsnqptIENSNCsW6FyT8xm
	Q==
X-Received: by 2002:a17:90b:2e0e:b0:39e:6a7f:eef0 with SMTP id 98e67ed59e1d1-3a0731ef86fmr1186255a91.21.1790081424649;
        Tue, 22 Sep 2026 05:50:24 -0700 (PDT)
Received: from localhost ([106.38.226.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06702167esm4845702a91.1.2026.09.22.05.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:50:24 -0700 (PDT)
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
Subject: [PATCH v8 1/3] block: introduce bdev_flush_by_dev()
Date: Tue, 22 Sep 2026 20:50:13 +0800
Message-Id: <20260922125015.3435215-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdirm3yz88inyuurqywzjdmrbww5bbgm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2AD271A0008
X-HE-Tag: 1790081425-630879
X-HE-Meta: U2FsdGVkX1/Wnb58z+NIDdGsGTgQ/qJXr5S36aG+lS2j6XHHIIIb+E7fPGmPUhMLYr3cocmTJPQ+d++Y5l9G2sYmJg3OE6p2vFlF7GNuDExVxalI6o5sj68ru78au+J+HqRmzXZ92gpRV3XtCHgNp4QZ4Kpe0tiYEsDRQofou8znpXJEJ9b2w72iRiSpOG0/ptrI5Pbi8zkE9RnsczNtmwj+7K7GUdsAXfu/fMQEyitNSl2xYncfbBPTtDGFOVbM3YbrfHMIGiWXuLvxhCP+Gp3JOt4XcmGpEARwrXy3GKZyaPKa8roZgeM76y0U5ILqQ5gTqlZRAXx5zjDBzgSt1RjGBErEcLoj7TS7ignjZxo9EKRFFGmRubPIDH/n+vbf8JsGVxKqSX+krX4nZCOXhov5+0g2BpvUAbTb0sIWi2cz0kZEYN6fLOWaTiTYVOGsp6GVDAQoM4yC2v5JekReGcT9+Z7wxvtAIxrFnqa/t8ru/vQQpgYPhFHW4eHzUIJ0ET9riXIlbiNO2HaJkVYVleB4TorS0/4EG7I37TkKXAy6Gheo4H4K7TCxKoU4X+OFDZ4ysT/bJvdsGCoACIwvj+papaRD7/ItYFCfo004ADcaddYRhDgjl+oZ95hVocjkZutnn7CnjE8bohtw6Gp3a8GwJf8TvfxJQzN0i0W9m71hB+DPBpUZyH+XPTKnywbob/MvOn3kbOIRClfKNPh4Fzdz/fR2GA2ZzrhpIumE8gUYIIvkDWAr9cHSEcBJVVdobDJC6t3GCWSXv8V0coL9RfabAbyXaswtmYFenR+yPy+9wQ+0ns3vD0youWrl6e7yNnBBU83eXOKT4wOPB6+h7G20WhPpMGa8RiETsv9DAP30ci8CbApNOZPIiHBEOvlIFc+18ZW2VU01EEqUP49c9ucv7yDmA/2UdSa7r61pF69byQnP+B81oe5CkMjAqY0DIDCRhEVpFJ8aWJ+sxp3
 bVW+LVAq
 Vqw+TZ8vUoDcT1nJEMTjtyeWvuNKM3sFzu7Qp5fsn7TtVAjkbfOKBu2yXdB8IzM5K7/c8PNADHNKSyW/4CRkXEPszjqOwtTDCT5dpEJklgu/YnRDmCJNFw3KCPVRfIYMJP/2oFpYmw/2QI6l/SzLjJxauHPyDkzyFOCexMQkdz60zYUPko6LH0ycSO2Jra0m3FLG3ffCIhWtarcP3kSgajGSgaNooFDedSyXnUNnEsjYb+Zy3b5f9QUY7CwVXOyrTAhuhTT2TUxdBBtdbNJiG6Z2ShAfIjXVxNWsbZ2fDvoK3Rz73dy2i1g9+B39/dWOSOkspLTr0Du1KhcgiSFwBLWPrjEkLb3cKugI+YJIOMMzkAJwfWpSn+KOOew+mudcN3jShxz60vAZtekJVeO6Ea5M8sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bdev_flush_by_dev() to submit page-cache writeback for a device
identified by dev_t without requiring callers to hold a persistent
device reference.

A subsequent patch will use this helper to flush foreign bdev mappings.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 block/bdev.c           | 18 ++++++++++++++++++
 include/linux/blkdev.h |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..c7c192af6262 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,24 @@ int sync_blockdev_nowait(struct block_device *bdev)
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
+	sync_blockdev_nowait(bdev);
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


