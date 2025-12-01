Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20E6D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BF06B0093; Mon,  1 Dec 2025 04:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D386B0095; Mon,  1 Dec 2025 04:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D01E6B0096; Mon,  1 Dec 2025 04:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFF886B0093
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4B6EC06C9
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:14 +0000 (UTC)
X-FDA: 84170426508.02.32FD4D3
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id E40314000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZOlTMJAA;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqN6IsMp+xic4hsBD/TTSEY4e1QCsNoi7vBlxa2loK0=;
	b=kbjklS06wiZvK9Gw6tby/3hGAWefo+UsZcydesXzFmMNL57CrE2tomd8hOlebvKKJ/LkHe
	W3peqn3T0qTy9IgPeI9GWkxybbLorMbasH1TIa6TpodPaYhyipB/39j0Q5w/01u5owZCFw
	hfOOVDI8onrLr1oI5rsUhR3VLhzO2Uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582493; a=rsa-sha256;
	cv=none;
	b=xb4CEOnQGGTZQGqNGhff79JxgE9zCKBS6Wtb0RbTcrOe8TJEeIoMC6JShx5+YRbKChbqk+
	ZdliQEoIOKGUW1WOySoqxL0qVRY+v661OYHVd29b0hdi5Z8e0Y8OYspFeh3LiB2TyOlDzo
	7trbfJxR3npfSCzHjbC3LTWHY5LFJ1U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZOlTMJAA;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so4026849b3a.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582492; x=1765187292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqN6IsMp+xic4hsBD/TTSEY4e1QCsNoi7vBlxa2loK0=;
        b=ZOlTMJAASatw8CqBpDTZFyfAPAtc0eCKAqsljpNnWMsXySWJtHr4gT9w9f9Ft/vX43
         zKW1UtWSHXoIuP+2d4y4Cu23hujwuQF0D21igV7q114vieXilte9cJrlB6MwJkY+RbhN
         KSVm8gtH1hoOsdSomhx1eP5rggDhR+YmK2u/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582492; x=1765187292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BqN6IsMp+xic4hsBD/TTSEY4e1QCsNoi7vBlxa2loK0=;
        b=cCh2tPsDBr9v4S3gzH/VQW++WTD+0C/umtCw3K/GaZz2oEk9JM/fbvRsWCZ+3OLlcp
         wgknaHohdyikbhmjRzPjH2VeautZtZ7u0YX4Dd1QoqaZmNJfxfT9afGQYnOYZLUYXe9G
         vX7mMYsHkYUJCf97zXCQxkp1r5uXtTiTxPFFeMiuogCEbteFOFuz5dj7060n7CvaSJPI
         L8nECcyxgoeJtDntkFEIfGUJgHrryunYgnWpZKIII93O1TxPKB2w64Rx5Cy93s7LwqXm
         j1ylrW8uL2RN9RpKBU7kRj5OItwOtLBtTir66EuGfuzN/S8de1XWLo4kDpI2WcFdDdsF
         9BVA==
X-Forwarded-Encrypted: i=1; AJvYcCV95tmGaFMCTYpRJBdxmMZ+sCKuIkS4NYHRFnTWH4723RorpE2SstCtjaCcVu2SWcANVYJXZHvp/w==@kvack.org
X-Gm-Message-State: AOJu0YwZhQvzRn4+q946rx6jrtVbnROreRT6JmtTrjpA/VWdW3ZQ6qwe
	AlPIHV0jk3sL7NTNp3NN6YbmSi+RdhkFwQbYAJvi/yNkw83V6GyP9wXYW/XOGpryJg==
X-Gm-Gg: ASbGncsfSNLCnFIH/QUCByKksspfsSdRnqcLMjg9rJYrKlVH5eOTSeBRO6TxcJuMEXm
	lBV9eQDTg7gZT6uu74hwnSN1slqOOSWHeogUKoJQR7x5wBdnIp1YCco8YS6dtpI6tDZgMif+4ny
	kSLdNVdB71Cn2JUpECQ9RW30loBk17YiII8YRyFaQViwQQGwhPC/19bwYH0JrrKKUa0ynNicYA1
	C9T5wrxV/0DkUM711jf67iN1i/mTNtCno9LxCxaJESZu/8ZZLi099q909qXNL81DKuKDls5+yzt
	c9ySamnGgWdHzdJJSb5XiIQAmDDwCbd/IRa08qDOiwt/+j0oKhhyZhrjjDBDem3MAVyv+1DfDc0
	o2n3FJHVHq7UHEOMz1DYzLJ8u4r+48q0H2iJD4Dk0K6xzBz/5jlHNTT+lKp5v74jgN1FWY70ic9
	35BJYPoqQ42uEzOpYU2haAjx1j8ldwPrLwHekTpjSNM6ck59jZA9AEdJ7GGQlHqR/oMJXhZopDU
	Q==
X-Google-Smtp-Source: AGHT+IFPOKXBPxIWlb2N5bOWQcJ4Qpt2yM3sF83+3IIpZZQ0LRK1r32xVMYgoCct611DyaOc2sndNw==
X-Received: by 2002:a05:6a20:9184:b0:340:d065:c8b3 with SMTP id adf61e73a8af0-3614ed971edmr40400894637.36.1764582491688;
        Mon, 01 Dec 2025 01:48:11 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:11 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 2/7] zram: introduce writeback_compressed device attribute
Date: Mon,  1 Dec 2025 18:47:49 +0900
Message-ID: <20251201094754.4149975-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E40314000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: nsz79jpjbzrq8a79drnzbdceipwo63bp
X-HE-Tag: 1764582492-241086
X-HE-Meta: U2FsdGVkX18j2PfC4XZZf2DEPCK/DfhTzoU+wqPDsWT6xNpbiJs+16Ha4yz1hulkOrpEIL46xLP+MMDl+UD8Fe30p3AxxleTOnBZsyKOw2An010b6qo2aFErywi2u/rQkauZQi+uJiTX/4i82RLbPuNh9GeV4rq+diSAWJGBfmosZW9qE+ndiB5kFLweWfUiFbV2V66uUxGlufV2Qy7KXs2RyW7Wj4yvYlTTBzsdBrTRR8ha8spTg0G9nKZ+38s8+nRCKayypQxLi45INyX2CRxjNrGp0kmY/UH0AaRZsbkEmOQwNgt9KbZAoMx5LhO8SaWYNcRUqmTNpx3qZjHBqAXnS+WGQDxkNTXf7wKQcrdj3Hrfi3Wq9GB732tBq7GKeRMLbTK+SFvgZkAvvMCQ9pJQeOl/ojSeZ/kL5tAFJ4VSsOYB5fG/IagBwwEN9Xyq8MXYd0kJj5nMtFihWLghy3RHi+U/3oqNEO3iMrccwO9XRdcvP+QoLhannlyVSsvJIih8ucmJw8bPc7Vuv90oDPowPOaIA4604jdu2Wzn7m4ZI27WMczhTE2/t6UWXXvvrNP6Ox8nk65R+BJTsg3gdpD9uYHqMPrn15R3H1m5wrot993baYxuuR4A3ed+vbLC2m04nisDOWllQz4KRLTpmSZFXeDskg5WirGrBMyCq794z4IWO8Bdi0WcPv8VSBy8y+wHyveN40Nvht0dDK0AQ5mFtZWOQa6LE2GNTAS/VpOKjNFM5mdLaMLNK3HJy4j3cr3hpLcYN3gTWxj5EIcrbENxTanPEZ51sRCxsoEVdt0bF25dbYE41tNnqiNjEUAi/IvhvxIoYWSeJFBt7kWcubsCipUuFxX5GWIaSffHDYSVmmGAOUxAsmMp166DB1nVZgA8vOjwpbcswcRikAlhRQNPBUuQASPpyxy9fFZ6XqIk6g8S2Ey2g77scSCIkGeL3nUpCh1lRA3z2oav1A1
 2TGx8ho6
 68iqrOjbQ7LSWy4Rgz3TJq0dfkf7max1G3RDripZuOOuD/cyScnyR2jIpb/seYf+mHB/LBF0LBQGOXswnG1HbhSHwHMgyU7LF3ZNdwGqH3XLjdS5ocEvqliEOidp5ejw2oMjunnSiHfmziuUBJDHw/0wSxh22PZ/mK3IqqTHTcguzXcCuhXuFzbZLZmNqN+U++UVwkfJV7h2azr+tutSmjR6nzE0pHFNARa0ST8zcTOlEJaS1TJqNijLH3MJmJGYUdgGgGZCBhK94z04DI7IBlD3HiyC4gwTfidB+tLPEEpOCHOO80ZQIoXsCrVQe7tgDCJqq8jLq7deh1AV8GVcrNUQPqzb8dGqGWfYWF7/q7cAKRfABTZuga15MSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Richard Chang <richardycc@google.com>

Introduce witeback_compressed device attribute to toggle
compressed writeback (decompression on demand) feature.

[senozhatsky: rewrote original patch, added documentation]
Signed-off-by: Richard Chang <richardycc@google.com>
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/ABI/testing/sysfs-block-zram  |  7 ++++
 Documentation/admin-guide/blockdev/zram.rst | 13 +++++++
 drivers/block/zram/zram_drv.c               | 38 +++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index 36c57de0a10a..ed10c2e4b5c2 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -150,3 +150,10 @@ Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
 Description:
 		The algorithm_params file is write-only and is used to setup
 		compression algorithm parameters.
+
+What:		/sys/block/zram<id>/writeback_compressed
+Date:		Decemeber 2025
+Contact:	Richard Chang <richardycc@google.com>
+Description:
+		The writeback_compressed device atrribute toggles compressed
+		writeback feature.
diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 3e273c1bb749..9547e4e95979 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -214,6 +214,7 @@ mem_limit         	WO	specifies the maximum amount of memory ZRAM can
 writeback_limit   	WO	specifies the maximum amount of write IO zram
 				can write out to backing device as 4KB unit
 writeback_limit_enable  RW	show and set writeback_limit feature
+writeback_compressed	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
 compact           	WO	trigger memory compaction
@@ -434,6 +435,18 @@ system reboot, echo 1 > /sys/block/zramX/reset) so keeping how many of
 writeback happened until you reset the zram to allocate extra writeback
 budget in next setting is user's job.
 
+By default zram stores written back pages in decompressed (raw) form, which
+means that writeback operation involves decompression of the page before
+writing it to the backing device.  This behavior can be changed by enabling
+`writeback_compressed` feature, which causes zram to write compressed pages
+to the backing device, thus avoiding decompression overhead.  To enable
+this feature, execute::
+
+	$ echo yes > /sys/block/zramX/writeback_compressed
+
+Note that this feature should be configured before the `zramX` device is
+initialized.
+
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6263d300312e..3cc03c3f7389 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -539,6 +539,42 @@ struct zram_rb_req {
 	u32 index;
 };
 
+static ssize_t writeback_compressed_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	bool val;
+
+	if (kstrtobool(buf, &val))
+		return -EINVAL;
+
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		return -EBUSY;
+	}
+
+	zram->wb_compressed = val;
+	up_write(&zram->init_lock);
+
+	return len;
+}
+
+static ssize_t writeback_compressed_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	bool val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->wb_compressed;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%d\n", val);
+}
+
 static ssize_t writeback_limit_enable_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t len)
@@ -3048,6 +3084,7 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 static DEVICE_ATTR_RW(writeback_batch_size);
+static DEVICE_ATTR_RW(writeback_compressed);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -3070,6 +3107,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
 	&dev_attr_writeback_batch_size.attr,
+	&dev_attr_writeback_compressed.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
-- 
2.52.0.487.g5c8c507ade-goog


