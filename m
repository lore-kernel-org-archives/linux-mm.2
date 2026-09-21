Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3109EC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4FD6B00D9; Mon, 21 Sep 2026 08:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BC86B00DD; Mon, 21 Sep 2026 08:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2466B00DF; Mon, 21 Sep 2026 08:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E633F6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:07:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB4A3A40B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:10 +0000 (UTC)
X-FDA: 85237643820.07.CEA977C
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34B4A100010
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Njpv8XeK;
	spf=pass (imf05.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYYfPRZ9YElxZosA1zWn6OE24o4j3HFVT3Jg17cOppw=;
	b=pAgXyrrzEhnwdQlnuuQVb6qnQsyluGe5+ZasYDkTCeN658kZCDtDFPEiSaTiDoiDsY8T0b
	3afn2NRnryt0EbdHERL0YzlcscoPuSylqrQgkGbTZ0ssbDlcyLhNmnmW0fg6ZXjcGJz+S5
	eDm/WI5Pxz5IrXYyyuEh8QPeFtd3dEo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Njpv8XeK;
	spf=pass (imf05.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992428;
	b=mr/FSlcNG5jxZfe7UC9TYd2mVBLm+UdofZWyB1qDbhLNyqQLWWCfJL1p4x6nV2++0624+Y
	l1VZZsc/wfxNx6aTOXb8i8EJHYb+UBYiEjwq/KcwnedzMhWDt9Tx985nLexUqUZKEXnEhD
	lKVbAnNhrzHtGJshLdP6+3k13ViFwfI=
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86e6d007703so2383302b3a.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992427; x=1790597227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fYYfPRZ9YElxZosA1zWn6OE24o4j3HFVT3Jg17cOppw=;
        b=Njpv8XeKR8ISQZ53QpoEirVfmMDJPAoJuzeXKU7bJDSVzURo2EaUtaUiWhCq6I9Z7N
         dhVHxnCH8a9ARG0hVz/VgFfft5TS48o+lCOlEU+nJfm8p+gRZLsU+L19AdBaWZwCPMQQ
         jino1ZFV/E+yip0rMZ8ElZLd6yR0GUNbwP1x1ku20aLsu7XlyphCjWNgtoCZo6oD8rbU
         OU91f7UDaxGjx+XOKycw9jFSLGWKitgEIGZn8xj2e+LaolabE8Fh6bBWpTxWRQh8COuG
         X6wAQ8TGj7FUkjnpL/tOB0Dr6OQ3Pj3VoXugahD13oAq/aEELF8lb4ccgFRGcd7KRE5S
         RB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992427; x=1790597227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fYYfPRZ9YElxZosA1zWn6OE24o4j3HFVT3Jg17cOppw=;
        b=Xm3J+w76D2g0/39oVesdQNL4Gmwi5k2doIuWsZ6DcJX1So/XdkzvLgKJYPf9GPy3DM
         ihNT3BvolqoQGhnmQlA8VboY+eAmqzap1p/avXOhQHOhnN7keB8YO0I+8K6CwedUcaIE
         uqYsqPYPNmt8nvCPSP8jp6MfloK1PEMfEhgkkVfUZAbYiTs6HDiYkUYKbhyDx8j7SZln
         hMWUb44Y/3Ge8HP1yxXhvbAmBtgsKpxEvS6UAu84Ra11CMusLgyCyuTyDwN26kl+vumh
         nVJ8ZNpqfSIg/FdDGxQvf+2T1N6+VFdsAmjbxrl78ZUJoOQUmY1AJq9vl/hTid/DLfMx
         WG2g==
X-Forwarded-Encrypted: i=1; AKwUvBz5e+13iVMdKKQWFJCGJNx10g7/+h0wMBrPI2y9N2FItaQm9CMgJsvfG4csfpi7vfghjLnipIm11A==@kvack.org
X-Gm-Message-State: AFuF++niiz00B5w5fmyMOOw+E/zTihwzsGi5L6wy5Li25OqiFP076YPD
	shhwexHQiecO04jnW1dpru4KxrF/hHjduHmem4b/nGy1xTg2UUoEDau/xG81wj05q2U=
X-Gm-Gg: AYBFou29tXm9nZr6lYSoxsU7AebXaeOoUXOzlFu5CzhZ7Ymkbt77s6rj/2CNqnvnKY+
	oGVLdxAd7lPvR/O+ivkJAJUuzdSFrjp0yDlmJajROtKWIdR7KsbBgJBEVlBoSxi8tw0F+qVfO82
	wvOr08BOARjVUa0cNc3Yjey9ghZYr24r68hWwGjP+Qg/oUqjajkGPxV5Jlc5Zac8kvUNm15wGgd
	c7zmkdwomgbq7XIGMEJC7HiKTqseGXobgr6EWngbU2BK1CZ0aElPBPUlpmaZZhwY5hRyznI/2T1
	LGLXrSOS4RM3H2dvqgk410W/KaQXmaEJpGIuBV7vF+hwbZyOXINkJOm+xIDj4m8TZXbMur/jQK8
	mIqQ0UKlGBfL2AaS1FWTx7cdiCMDkM4rU0ptfMT0PPqKDPKK7RLtPAf/zu9gfIUrOTAnAoJEcms
	LtZDtiGYLapi5b5WcoiIB4NIASpMu8QjLMgtOpYSjA3sGkt/ZQr5vH46ncYVQUZf26DfiKmbRY1
	mVgnJhCUY4x
X-Received: by 2002:a05:6a00:44cb:b0:869:2b72:525d with SMTP id d2e1a72fcca58-874db7f1b4bmr15010249b3a.7.1789992426597;
        Mon, 21 Sep 2026 05:07:06 -0700 (PDT)
Received: from localhost ([106.38.226.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa11153dsm3186329b3a.51.2026.09.21.05.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:06 -0700 (PDT)
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
Subject: [PATCH v7 1/3] block: introduce bdev_flush_by_dev()
Date: Mon, 21 Sep 2026 20:06:56 +0800
Message-Id: <20260921120658.1627992-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921120658.1627992-1-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34B4A100010
X-Stat-Signature: n6kbt1xqr6u76u5ixkpffdzwsbimem6j
X-Rspam-User: 
X-HE-Tag: 1789992428-223623
X-HE-Meta: U2FsdGVkX19NvE8Ztrx7vcKqDyqrcTj8tobtc0xJOlCsajDyqoZsf/uSM5woaTdHoRotTkAKfO9smFXz2dBGk7/CZlq1GhaVdzUn8QcbtAY0JLyidylqTL61LbST54nPH/EgrK/LaddqE0AoVOJm8gRg7BMIpi2T2dbnTj23UOj/EcIBO0pp/1ckrcCuribqcxcLEajM5YmLZQHN+Kk63yxePqqQcQs6csnRO8NpHiUOgJ6qLbD+t+UtyXpI8EzcsPWLBDN89Mi2VF34MEWDqxaUxmH9zuK5yn++QfaaLLSxbStFQp/K+W9Kz6j4p9C+JayQHiVIjLLmw0tSuZSFz0gecJqTKI0hJv8pD6TE5UwDli1hw8HxDCDl1j3WY5q4BUd7yqPDAIwqUHSKO48/jBLYE4oCsGwXlxTEx+G+1d3ex9IysdMjewEhhu7bEdFmsoSAS1LAAoXmzxYU8p3KxV+kqC3RfswW/8VYbMrgRDBsDi0XK4L92BEKtfYzkNK2N5UNX/bGvKhThI5nruH6iEfruuxeZKZgC3+MEHmSe8NOVb5FyTDoZKHNaco301ey0uy+s/Q0Tw65Xa2G5b6NlhJPBEjf+p9maTpVvnLcNpuaDzAjuRcG6Fq8iPYiBZpEb3XsLR58AuXhDTKEyDUMeH8jvKxCxAS0m+dB7K+SC+dPDAAuFRxn5QN9tuUTiDC2m7lOifvhqPztEPTPRgNXsNvbajXvClDxYTKEzbQX8ataMObjkQud/gOmUfC2ahgGupuHDfwavWwZJ5D40y01Ps6giVGrOaQM7JFSa57l+Nuzoy9i3p/aflf/IjrQkrVSD+VH7vkrbTmJJhdnUtibOhoT7Ml1W/DYdvuYp9rsQGGatQpPn3vWjBr61ObwwOej1Y51OBBWhyiLdPrGYWWwSyTKEHt9AgXPt1IBo6mslEMRrw2PL07UBdX/sj1Mjg66UGgxQanX0+X19ipOWwf
 8msw4EFg
 BuGXbfKISiWucLV89f2igjWjn3DxBRHeEzq51qcAk8wZT8YW3q354pePC4HsKFiaThCZpqrNeMYFmEsscwP1PX1CBlDcmYeBT06bxPLUmflwMarlUus9ZPOoPe+1/3F2Fs8argOaQcwmonl1UpPs1//A1/woB+57SvU0eFlpiyD9VKeEuIgb8Lj04NVnmJ8doetfMNtBpkI15GGgb6mABvFEsu3mrDEbNDg44tdruh6hekviTpEEcWKACHKXrQz8FvZrBjx4k5E/K6t1nsqs2Oz/+AB6/VUDsHCZKaorxQM+bZ0CWGBQ+yj8LpMaLsZaMv6F0DbBMyj61Q8/DZtYPEUbvCosnLRqEJLzfwxu8Gh4T8Iqoy3cT7bEbxNNqYAE60JzFPrKJPIymHY7ADAeSnhO3gA==
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
index cd8323083740..5cbf01a13a33 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,24 @@ int sync_blockdev_nowait(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
+/**
+ * bdev_flush_by_dev - attempt writeback of a block device's page cache
+ * @dev: target block device number
+ *
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


