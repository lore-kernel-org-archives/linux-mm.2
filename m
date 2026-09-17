Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 013C5C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087966B0099; Thu, 17 Sep 2026 02:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0607A6B009B; Thu, 17 Sep 2026 02:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF426B009D; Thu, 17 Sep 2026 02:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD06D6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:58:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B4A5C0259
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:58:18 +0000 (UTC)
X-FDA: 85222350276.14.27FADA2
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id BD9091C0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:58:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Vct/SGqA";
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628296;
	b=Yxdap+X0M9LKWXcaeoYgY+q7F41UsoZPtjq8n3I2Ti1SD/fFyFa79i13IbuyRao2bCpzpx
	pQT0lzgI7JQEISiagOnkVaZDndoMHIcBCheAF6mHPOBIDlgfUtt47LkaBSV1Vc+vA8lELF
	g/RhR0CN2Qv68+w1Bd+tDP0PTo9ZNwU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Vct/SGqA";
	spf=pass (imf21.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
	b=D7+1JLKklWXKLgkR7/waSRW+HeyxXtXf4QIV4/xzZ9BUUi7u5nlxD5h2vFyEGJLeuytDCW
	2M5KceCoMYOF6Xb/ScFUdQD683hxABYY2RI3uPXTsTOqy9bEL9LkI3ycNCpcIaHJfws5QN
	fsNsOJLsTZqF5eojs/S/3tO9I3DSLzw=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d249c4so440631b3a.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628294; x=1790233094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=Vct/SGqAgXN57+VqfNxs7hyzjzGHjtNNhQs98WbLs+qUuYfNMBwaX2vyFjRycMbzN7
         oHG0FQGwTWj2+1O1ZZLJG9x2BZUmJ5GlGukFwoHpeLY0wvtvUScg+oQteao0vZaqkGXp
         z+3koTpSMDYBKTERPunZB6PWVud78A52TzmHTpWBe3rK6u08v/ndCH1K2KzQuKIybEUy
         m1eJpX+gc3jqHr9Cozp1/4mA6POu6ahyIUX1zFqEUjdaVWXvvLC0HiEqs3daytO1YxlC
         K0amLUYwQAqM1RkkKFlR1rQ7pzMyM6qOTngBxvTcBsz1J/qDpALAGXLha6o+7rMFdcMR
         3ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628294; x=1790233094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=NDWvkvchjdPsDS0PuWdLTck85UXy2++unuxFcjz7ASwuahRsrC5+6GvCK6uM1Iw1RC
         ekoSGiFwR152AVA2rRHgxvCCedNYAXHc8fZIbEvdDImoSXVXT2xsWNVGqtwLGGTwyXvq
         859G5nVrTHmPuyL8e85N8PT5FeytP5gir0/vF0qJVCHjXgno8UN1aVZTq+rgTixTXcmQ
         NadSZkwP4Av6adEUfigd/Yy7vN+mVFvCoRu6D55MEYvkMIZ9V3L5G139CdqIaFZk0TtU
         ON9cIN5Oi0Qc5kWEA50BYRJdW1TvTXSL7O6QK3y/vQt2Wt8rOl3mBE/8oBZJ2OTmoxNt
         8yeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFyXtnCKbkEX5ayoJg7gSxbRyMIGbnbjG0ilEQV2WpfRRyTQ27RiMXVgnaudEpwgBIdgGRaNJe7g==@kvack.org
X-Gm-Message-State: AFuF++nAtcgkAE8O1R1+Mn7JhhFYJ/8Ooy7jVtNaVfJXOvVHnBfjKvDO
	IH3x+PkS19zhqsHGtllZs16Plmg/738Fzg3ETSg4BvZN8N95s/MESaA8FeDB8fwrPMBIGGD67Qa
	XAVVI
X-Gm-Gg: AYBFou3ojZzg4oA4QXJ2X0XVCxaAa3n1iA2/WLNU9yHp8u6SGbmW+Bhsjl1ncpMcn5L
	6ZaM+fY3cXdjspJmnEjPIvJkb8hHph48Q0G045WChSwaKQzV2P8ENHVON2y9znRjMD+8phsi6qv
	T0GTf+y9xOypNk32RgLHqju4MMt2FsxQG+r8B1Li0ffMtxv7oQQ+aGS5JzfNbBESXNt41a/YoFm
	5y39hd/lWu9fGF1VMldk+0JcJ+3ALAks8P89cSWF/zgnxknlNkerNJxk+PDYOmy+CqBiPzjOoAd
	kxq7cwY339AwIgZDscDABsIcpMRHOrRfvpHMBMx3J4TSSnAhJs1J/bLmi8KJ9pNOJYu+IJy5CP8
	N4o+Wq7WJz9mj578fn6LQu2LkV0DK3ifCltwBf14RvZM5actnwxeYAmpg16klQWiTsfMSHERyUq
	qcM0wdw7ekMgYxfNnSJyi5K32j5GcWp7GDd5V+Fva5VqFWFMbPtf7wjTQsjANBC2mTwfUXBym+X
	xc=
X-Received: by 2002:a05:6a00:244a:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-872369ec1c8mr11578319b3a.2.1789628294219;
        Wed, 16 Sep 2026 23:58:14 -0700 (PDT)
Received: from localhost ([106.38.226.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8720173842csm2311245b3a.41.2026.09.16.23.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 23:58:13 -0700 (PDT)
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
Subject: [PATCH v6 1/3] block: introduce bdev_flush_by_dev()
Date: Thu, 17 Sep 2026 14:57:57 +0800
Message-Id: <20260917065759.2643940-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD9091C0003
X-Stat-Signature: w811aptug1yxbuw9oyisn17dw7andw7i
X-Rspam-User: 
X-HE-Tag: 1789628295-373769
X-HE-Meta: U2FsdGVkX1+u6YfgiWo09JfUJLSrfIzaS7o7qajGWS+k8oB/NWSH38wQs5DQQVNE3FPb7phUptr+sZTvSUz5h1sueXGOXnIDw5UVc9ws7HpZP4tsIAWIKmQL2usnXEdh/Z7uIWaBY9Sydu7/WWr1+XWJJHqAk7E4tNq7eQyoGM1+v89lvl8al+P6ji31YqrVWL4hvf7NMUsywiSIzVpoMOPJKcwiKSeIpbmuGb5kHJ7c1TvtPvbvYqM+PTFWBXrBh0te5CxVXpGSutvn/uJEaMKnTa+UzsWLpUhIpaeIMppDt4pgDbZFEm9n6zSmHpKocUUYcoQt7lXlbFlGfNwUQVLNj5GwTx/nNHuL+COUT0a2H3aCA5YfNUZWWprTv9BQlgin8LG5zURhGLL/kplxf/fUCVGEGggqwBRXNiIjG5cNNbXDv1WyVzUNZT45RGm0Y2Bhw1WFq05SqeY5oX7knLfJoWcuxuAvj6JyrNlrLYSQgC4DxA0LtiidqkMoQVONBhoDQ+Sg+WgDphx2SFqY79kKyI7UPzU+2ywNo2XOTLOd73d709LRpT/fE2f+WSpT4sd4BPy7leV79oWcY3/voriXBAICnoUwToxNTv713vjJqg0/QEN3tyM7oVuXQ4Vl2nrmAjJXm8bhKz9BQnwWpHq3OIht/hKK5AUBB5CsV55kbITYAu6qorLPNmchf567dI+PJvQaXSCW0FtXCfVHp4ZWtdpnhVoiFvpwdiyi9XBEcSxcF6L4zedlfXyablH/+YMbrdMLWawatEMkOlS0KABr0VNThtKipgD7aPG2udXpb9R4qk6M8EZUUFCqv4S/vzsZV90MGkRdWuNF4oyBayPn/G8owt5t5myV9vu179V/iqWyQv3f1La1GILAXyYe1PoF5lB+HyVNfvq9Md4nROjsjofil4htF64udbjZMGPcrErE39BJflS1SsM1owtxUMXJ4r9xxcHHIEIL37y
 okYWfxt+
 Di6Hc15WVUPKszqfowQxQU2QZew3xVO7hQl7cEg0zqEpPBlOK+IrwDoyTSI/hkDzvp1w2ZYUic3c1Lt8voRI04scg7ECj6A9ofD49eph+3mK6e83UVJbARujmhyLfnrRLtLT2qDGljtNl1yTU5CzWvi/fBXncUkHHwqfa5QpsKUSO1eMSEB88HdSL1eq6bGYsy0E05bFK4Vbp2e4wZxXZAml40kYyk+I0lE7ADlxsbRKur2yWRhtsldprMvSz9PSBo4r7hNDQM1206xVC9pVaVKQmMykrfZX6rx0xaVKwAEs1hyKzisPGOogA6s7C0PtEalPzgOMhi8+erRudpCfieaFKgbab5S6bPZA7GpQpYCNpd4ySSK9HjDm99SAyrXHbM3P/dLZaxetn6WL2t6jEjPMR/w==
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
 block/bdev.c           | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..da1fc56926fd 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,30 @@ int sync_blockdev_nowait(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
+/**
+ * bdev_flush_by_dev - attempt writeback of a block device's page cache
+ * @dev: target block device number
+ *
+ * Skip closed devices or devices whose open_mutex is busy.
+ * May sleep while submitting writeback; does not wait for all I/O to complete.
+ */
+void bdev_flush_by_dev(dev_t dev)
+{
+	struct block_device *bdev;
+
+	bdev = blkdev_get_no_open(dev, false);
+	if (!bdev)
+		return;
+
+	/* Prevent the device from closing between the check and writeback. */
+	if (mutex_trylock(&bdev->bd_disk->open_mutex)) {
+		if (atomic_read(&bdev->bd_openers))
+			sync_blockdev_nowait(bdev);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
+	}
+	blkdev_put_no_open(bdev);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..7a5f3e2f17d6 100644
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
-- 
2.39.5


