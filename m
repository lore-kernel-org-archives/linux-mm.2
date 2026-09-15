Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E431C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852C66B009B; Tue, 15 Sep 2026 04:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805096B009D; Tue, 15 Sep 2026 04:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741776B009E; Tue, 15 Sep 2026 04:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E50F6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:34:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFF5F8035E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:19 +0000 (UTC)
X-FDA: 85215334638.23.3D0654C
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F00E40004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h6KTkoJf;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461258;
	b=tclorGZ0sAVq/awoZ3gAWfrZd33CQ/WF5rORzxSb0cLiZBlN8KQBWJRsE0rZ0epV5BZ+wT
	wUcbYZ6xEMQj7WW1ubGnsZu21OMeW1Rr9y6KEO9LFz/uLlYY1b4FfYMa1JeJKMLJZTivsd
	XXQqHCnATA3af8p1RKVyx1bKl+ptOBM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=h6KTkoJf;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
	b=ZcFuGFOyDfwrU2svviW33CMUTG/Mq4jzrr7c+Vp3HC/s/xCESAARUtq7a8cG0E+HHI3PUB
	2NfgX8UG0zqJ+gSvjjpC/fNhl6OpifS77Urp8/Jo+5VhCIuG70aUqSwBZ86yg18dJCcf9r
	2f2qJYY7zHnWCbiHcR/9hyV/+GrTYyM=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccc02279so2737715a91.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461256; x=1790066056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=h6KTkoJfqqiK+mIVFPV92H63Uw2pd+87a4Qu3TnYQWj/YKEOwnet/UeXrpzjHAM3z9
         m1S5JYqcGZkuZStQmODgUHCcVzVp26/7GSHvs+DoCd4unTpQ0gWxO77ziytDdH7FHGxD
         dPeDiOLhP+9XqptzANNvoiOHMLASbarcR0Jc3qsiFck0fVtCsHhAj8lfiCMt/h49wf89
         waBjCrxyDR37MGBKvU7jQK1KQgRXlB2LVSMxSIY76n7ytzrTolDeuRaANVeZxKxJ3+/H
         I8s+gkr9ADhttcpkJi44v+s12shpsVQ4PlCtND9VGqg3uqdfHYBQxzlpfzMc3T00Y2NL
         vIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461256; x=1790066056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=jI7QZ/dao1Ck5eDg54cvCQqe8wupqeY4TAhsablzGqE/is3WjPmCh02nr5XQjJyszI
         sguQRUZcXX7/91mOnhLhmTHS0x1bcj9b1gAjVwX7h9uJgjsiJysVuVEni3A/XUvhZVL6
         2EfPHcmvk3KpGN3vmKhaibXGOdQq/ggkMNUkmSH2Zdef8Fjj1qOQLF80HxgkYnpwemg0
         TkzRmLDEVsz6JBsjCZMUZbPohJ7hxTQcy5lhbWqfBtl4PXlIkN5W0hGFJJ+oZ+xXx2Ep
         VgOI5GSIqRcT2vo6u/ngnt5KQAoObn4kOXj/Ow+p0Jd5c3CxCwDJzyO+dA6OSQUCPTzv
         lwLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLeh+hDhDNZ9CHmIyS7aY772sQf4TG+hGuPGoXlBSMASWM6ibSsUbq2f+HqbqxM9D3pBCe3wsc4Q==@kvack.org
X-Gm-Message-State: AFuF++kgIB2x9xM+NPEWD07m8QDH7VtexyQphvIWNNEXnJXPR5a5Atp1
	Qf6K8nabI/ui3XvBypsk1c8HaKMf+V1NTh6WVpx4bU7OTZLDDukmzzs/lGqDZfg1W2g=
X-Gm-Gg: AYBFou0FvNvD+jAdLRcgJGibcoKmgOZmL5bIIdJ3dHepv+V5aOCshWEjmHu4vtkOiQQ
	3nkQM646XimRs6g3mYv8WvlGvXFIhYmpCJkToRZ0IbLWZlv5xmrnOK6N0Ksu4Ph3hcYGFOK/n82
	KVI7lj5weBXUh561UmefNcuAYtQBFBUHH/F83jIOBQezjO1QiqRhVtP+SpS+H2MPk0hvcyVe8kP
	DDZ2PWqXQ52jD61dX4Ki2gvTNS4aKmKxnfDYD7LmKBOj7YMiCsjYJHAMzYqwIX6FOdAXeK/HfX8
	g3I30emjbZpQ4hZeFisNgEXCn41aAbQaZFTu72J74ZwE2R0JwNxcOUfLWjDKnpvl4YBIXHFB3HX
	FyH5ofWlArUv4Y3nUQ7AfrrQGMwR8AyxyluOv+LodsbHwPqXaF8sJymdvTGb0wgkYFif00fQ7xt
	D86jD9/PC2gXuHBmbI5giJYxYhrgyNkF52YC8o3jCSTSKoKjfO+gmiKDU4RwSGj44VihZ1uOd6r
	A==
X-Received: by 2002:a17:90a:1c8f:b0:39d:ec24:5ffe with SMTP id 98e67ed59e1d1-39dec2460a2mr8002056a91.9.1789461255581;
        Tue, 15 Sep 2026 01:34:15 -0700 (PDT)
Received: from localhost ([106.38.226.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd28acbsm3919641a91.10.2026.09.15.01.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:15 -0700 (PDT)
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
Subject: [PATCH v5 1/3] block: introduce bdev_flush_by_dev()
Date: Tue, 15 Sep 2026 16:34:04 +0800
Message-Id: <20260915083406.3471036-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915083406.3471036-1-sunjunchao@bytedance.com>
References: <20260915083406.3471036-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F00E40004
X-Stat-Signature: k1fpu1qnopww5tsqbzkpmc79dqqb63mc
X-Rspam-User: 
X-HE-Tag: 1789461257-990849
X-HE-Meta: U2FsdGVkX19Zake2Xd/DvO392ILEeT4gGfVK4EX9v9eUcPf0yUbDnUx49yPOjrC8dx2wmk38UoWt8zfZk8OKflA5UFwhIRv4Lzm4w3Pbilgj18RBujl9d17GtPnIolKkxIeIzBEu3/20/3quRUaRSOmShKzJRcrMu/U//AZJLM9oB67ZgbSGCTK99t+ECndPAGGlyE+jfgueO52A1QUB7HkBO1GKoWeYKlOONrichrZ6F5z7140Zoh6E2WfECcTgI2PRaNjFPlamuk9lwmSJgKzramiwOX90Najc6n3rAfQ51/mbSm3+AVEhK03+07mRBDnh0PetP2aj0q+asYk4XWIl4dRM1chw36Fg6j1l6Alycces6gkB6oPxVoZdMeNdrw8tQHfplMLW4B/7zgipQSsa6dtwtgqu9vF++0E7Oc0b9d9qNFbi2rJWU+3D8CQ/HguUh5kE/I8VaOmPdYGuOdvG+pufRTD/30unxZ8O++AJkXORH/7YTppWgqK0MNQz7dTfxhx7otuv937+eWCY6G5UHZWOBzm+uC5nMW3Gj6z/LbkqteGgaHucL9Ch9e/30fnUc8d5YErKV/061wcK7EIJLNjAf47Y53Z3ByZD0vYqWXvQydTvh2tbLwnGfOyg9xOePkJoiQ2G+GBoet0f2RD4rV7eRxk7LztLCougEhgJEj4d41ow0vQmKi4M65yTJ0Uae+ojLVCVFbq7KTL74U7umgwI+NqRbxJYJbMsz47vGm/YuA1aZ3N5LeW6yyyfkV36Iq3/Ram+EvFuUnCaDQ6HIujq0aRodXmGCPtPLPoRFbf1kkIasCm5uj0M2Mn+p9k3uFU81Ku2th1tNOXDgNzfv/EDQFZvgCdOQy+6T/ASfTckUNZymkVRxHr85xPDmt0KjynMV1llrfUDHdbkFZGuykHSfLx7hdyLgiqGv6vVQOg+0CxvdWGEEqg53KD2jnj/GCs1Z/VOVOcj0U1
 jRdV1ucJ
 jPDxIDfdfEI6M2bPlqtwP/OWpkLciGts23vQvGyRes5sOfsJyi7gMFmglXmv7xKyhgriyDxX09IX3gT0J6aBlGEQ/BtJIIa4RDPVfCHvE5uxW/NrYzQMvi5InWZONHKkxaKMCDSICzHX+4wBuZU5BFTvH88f3MlXC8Fn0NnsVP9S0SWBJBbGwSnq32MDfbtIx2K3HI8kzJ7L+ox4ZS5gd6lizZC77/8TnOebKrqSu2h3ZNaa7Vl4CfQ9Kd2xnzLdvw1d6FpPYVjtI103TCxAXGkKVMWninIeakzBRBLLjIu6nfus7YQ6+oJTw52EnmkZdsRc9jbQIOohA6+pa1SSZM/7MCRdV/RmUwa4zcWrX5QJB8NyDI6MQ42Vv0FE32k8h4ZMMFuEZOOzqO0i/W/STqKfUfQ==
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


