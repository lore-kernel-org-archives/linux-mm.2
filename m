Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA7ACA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553E58E0029; Tue,  2 Sep 2025 11:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503C88E0002; Tue,  2 Sep 2025 11:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4AD8E0029; Tue,  2 Sep 2025 11:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29F218E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2E4E160288
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:59 +0000 (UTC)
X-FDA: 83844738558.23.31FE9AC
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB933A0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e2X177eP;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90kZ9DvIdtL4dz9/qc/WVjEQ+mFVkPoHnP8T9TIhe7A=;
	b=kDRCioUiS2NnsUMyMJYomdccPcSi79AskLmCy9Lihkg3Kf2zlDREGu7S+Hu/J5qK1KVVEs
	2N5+qu2Io/EmPGheDHdZYSVyLEycXgW4rNs1XfOWJLEfLHv5heS2Kqwh9vK+nlW1rTokze
	LWQZbfPQ0nugZ3fAkVciXcGUoilYoYs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e2X177eP;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828017; a=rsa-sha256;
	cv=none;
	b=XoO8qyqvn/2Vk13w8Yb8yauY/XFNrYp8s1qhqvtbR+0z5rdadNhpBMvT1kUfVcWoqeVo/D
	NFFDIIfHi+nT97h5HRWwc1uD9wyvUiqEM/lel9jLiaNA8Ud4G9eVVoSwba2Vv1wu3CEhB0
	m0X6py7BwuEzjt/xLMtyQ049lAKbUq8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ceb9c3d98cso2464431f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828016; x=1757432816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90kZ9DvIdtL4dz9/qc/WVjEQ+mFVkPoHnP8T9TIhe7A=;
        b=e2X177ePSxEqFhHiTC10Xb47p3mYUPb/aaXJfwyEJXBfPYZPUxh5B6OU+iggTkS4dP
         vs1l7axiOMkhffE9gGdC0ZVkL/PGTRVhJRb+Ts+QpmmlBtgfbPA3HUoyW/pl0QYW+av8
         kxhUxZEyzfhTwpxZhrI3vl7I64xzGBURH3KLBPEG4EF1Q3F9DGJ9N+k1wrPcCeMZrvQl
         2J/l5So91aYPfKFpa+tBNq7z332N/GatqSZJIEd9h3syhb03/rO/CGi6guH0TxTQqsVi
         lngLvf3keUnyf/CguxP734Eid2AHs3A0A1zK4V5zf2ipBMxaI/erFS1guPs8nrCx6B/r
         /JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828016; x=1757432816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=90kZ9DvIdtL4dz9/qc/WVjEQ+mFVkPoHnP8T9TIhe7A=;
        b=QiWyENa1ATec++IO0dSp8SOzL0UH4zR6zeF1iSxd23zF9TyCLUYBfPXns+g0nFszxl
         JK8JhUnTwxsUSWnp2HG+gGN/+9Yo8z166FYStFfgGA3q8UiXpIYvd3k8mV/uMZ4l4XQx
         F5nzy4Rg8okJ8QkawgX8CPQLt/bVQpJDz+r0wfxbmXzw+HsRiEW8qmYIb3M6K6JNXNV7
         xlh4WE1cUCNv+/454L1eY3uYzc/YUUFfduy056znvpenr2fWec59cJVXvNFsewl03SsD
         VpAEppHLQ8wbSeMTPZIRnWKvj5EVS3P5KudkqFnZHkPjbmNP0turtdIJILHOtJ5mA6Uc
         +4jA==
X-Forwarded-Encrypted: i=1; AJvYcCU3tsCQezG1ObkH7DINbaC5FnFOn4BATgG1Z0K5/AzT/gg2YqWeWYud66fOqUvwFRqIoivon6Rllg==@kvack.org
X-Gm-Message-State: AOJu0YzyXsPnaaJctqEWvo+15X967jtRvaualUjv0TZiXaBkbrGe1FSg
	sGdV0XxBc4dWNBldD0pDLIXVpALht4dDQefBrw0sdyi+qrp+jXxyBa7E
X-Gm-Gg: ASbGncutdaBEXNZxBuNX/P3rVvN94J4cVCnPd8hYES8GAm3Z5MZq5pZRSGkPU1pVqwP
	Ux4L86s5/qXysuK9umqZG3p0kN0Gd2G9MSnNwuBkXiUnwOMW1WihB3Fkb/zV9IuqWP1xWIDxzvp
	jE3YZqtQjNJYjii4VamH4OuEHlsZZojhhb3pve/v/qPCzcb3HNi8wTZwtAxSurvXCtn4lUuqhBe
	BfLgBuNm74nBfBvjZl+7gCsP0ULmTNhv2Tqv9q2CGxGQAf7Kb721MeqaSBVG1Rh7hmVzqxVE3mv
	IN34phY27kC9P0nYrN+8YodnfQZmvxBRV4LeIz9CUJ8MO/fkURLYYoDC2kHCQ5X8OJOKNWNevKr
	kO6ucDT+Y8SKhgIR6LCRMmZvJgfslXXTom50B19MjraHGIzjjtGGafZ13heGY16gRGNXlKyqUu5
	MNgX3StKZGAh7+dwETaS8nliF2
X-Google-Smtp-Source: AGHT+IGEFJ9YebDpQzKgxpYDB/nK1gBHr48wi1ywTJ9aVMyk17MTQGdJjc1ZEGueQXcFUAhwJrBA9A==
X-Received: by 2002:a05:6000:2f86:b0:3d0:64c1:1a39 with SMTP id ffacd0b85a97d-3d1dea894eamr9700405f8f.35.1756828016192;
        Tue, 02 Sep 2025 08:46:56 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d95df59e50sm4845738f8f.23.2025.09.02.08.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:53 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 4/9] dma-buf: heaps: Add debugfs support
Date: Tue,  2 Sep 2025 17:46:24 +0200
Message-ID: <20250902154630.4032984-5-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87fyzkd97gzgozjbf1x83f9e9cmm8x9j
X-Rspam-User: 
X-Rspamd-Queue-Id: AB933A0016
X-Rspamd-Server: rspam05
X-HE-Tag: 1756828017-889211
X-HE-Meta: U2FsdGVkX1+NcyayX64NrIFU5NKCV0GM/1pkeMCRVQ4Sy3pJ+AegWA71NCOQQ774UnnXdOKlVxvh3pvPK54hZsLf9FChfQ2qnYQNM2Dh0qwj4E4BQgp+mZI2oVSda0pnYHJ57Eu5uoKaZ8eHcog3sn/3uEJQQ8OKkJEC2dHH/Mg1FA3uS+tdwa1QCWPxuzC9T+lfD7Tj9pxsQTaK6xCF7E31mmPcwJ7ON5yjl4XTWX70bn4CUsAuzD8cCJ4FYFeqZ88GLHr/NwfH9zDt8+0jAlXV2DhxBxuNnK70XoIlKEHV/nHxI0cdasZ8n7YX0a2OfVhHAa42s76ZPY8LZSdIzPGEiEYfT+P2ygxoXLaeqgHaFGq/KunSqg6xIPhFENvJweFqY2Wgr8QwgT/Brg4SYgPvgOrLdMsfvK9vv/lL3DwKIJudmfg1tqTsfFBzRiM3cuH/QNBVTGpJeTWUsvEmD2oLzNaJEAM7ouB9/b+bAGj456QTnH2MBlscM19vFf3iiIDr4bnHgMhu4XW1Q2pP0s/vLCZ1l06JCsk85WQjyoiXSKT4u8MbIGtd0O95AHH3KJWqYRfq+uXmG+oOFDu5X8O/gtjgepML6Lj91O4Jbv+UfrRA/Sskw9bfyBfzIw5OQEumszhFucdpR/WBPJSOIfhvq2ecAvz6MX/YoIO8wBwLj79QYrkMMf97vMzfplPMegCT/EV2vdaT+JaWBf+Qgbbxvk/gHcB5pArK4aYZkTWIpoScOs4qCsP6n7AIG5JBUJY/rYDtk3/UbyyJcUzey0cljGlsZxw4nFJpcdi2jPzPjCmSP3bKteD8hNXJqnbbwNu7hSBSH13JI8ZMBgmDsEmRqjvUfs47Tlg50fXDJTOcqeRdjUKD4LiqQIT8Kme5YAXhzBNCPbwvDr/mu1A0xiSvg/tPQfBUpyMU/NngaSoZ/jdQf1v9gJuCYdgLiYbifWlzdWIY+34unhaZuCK
 8RRUCNMe
 z9JGHvOTGm+qr9ER8Z6k6TsbQUa0LYEqzPaSlVerJQJEaUsPsjXU2M9mFEqmRTZJM1dmqfuVToDoFQDQh9p+D+1+sckD2gLJ9+Nb/T8EuHisMopY+6BQuukpL3sn43AmOPM585R1Myqbjxb97sH1Whf4AuTcBCGDTQBT6hUfhY0ClIKmRpsBcmE7XASisWjZlAnFWrfUDMKl/kypB0aOvjY5CS5ucNe253ansL8jEcDOFSq6LaL0rreDfVPGGWGdOnuH5b0xnciY4cphDRyHTlOiP5uHE12im7fX1pCPLlEZsDDJ/Q/9dlsifHeq9YFZg7ZiPtrWZeJHME17gu/O9q81DQLS0vQc/QJD7NV6w4AZhl3paFPFpE4p+305VoWi4monHKSmEYShf6dKqkXJbYd6Rd3p7ZRKj8NI1olDKbLYDqxkjstVUXiIi0HzP7BemLh7IiPua3rqfD925ng873qNCD3I8tGGA/s7/UyU2f73VL2VPbCiNl/khBgW7ZYNA+FNF+2jj+LS2Q0C7qh0udg1400RlKPeQyKkhH/s+yLNS98ZuhRau+pNXftyCu4G0exLFG/IkeJ9ZxxwH1UGibSfR4TIYtckxpPqcYBJtCQ7iyoxXoAOyNiZlvBjLFG42gGaFTFtpn570fdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Add a callback to struct dma_heap_ops that heap providers can implement
to show information about the state of the heap in debugfs. A top-level
directory named "dma_heap" is created in debugfs and individual files
will be named after the heaps.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/dma-buf/dma-heap.c | 56 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-heap.h   |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index cdddf0e24dce..f062f88365a5 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
@@ -217,6 +218,46 @@ const char *dma_heap_get_name(struct dma_heap *heap)
 }
 EXPORT_SYMBOL(dma_heap_get_name);
 
+#ifdef CONFIG_DEBUG_FS
+static int dma_heap_debug_show(struct seq_file *s, void *unused)
+{
+	struct dma_heap *heap = s->private;
+	int err = 0;
+
+	if (heap->ops && heap->ops->show)
+		err = heap->ops->show(s, heap);
+
+	return err;
+}
+DEFINE_SHOW_ATTRIBUTE(dma_heap_debug);
+
+static struct dentry *dma_heap_debugfs_dir;
+
+static void dma_heap_init_debugfs(void)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("dma_heap", NULL);
+	if (IS_ERR(dir))
+		return;
+
+	dma_heap_debugfs_dir = dir;
+}
+
+static void dma_heap_exit_debugfs(void)
+{
+	debugfs_remove_recursive(dma_heap_debugfs_dir);
+}
+#else
+static void dma_heap_init_debugfs(void)
+{
+}
+
+static void dma_heap_exit_debugfs(void)
+{
+}
+#endif
+
 /**
  * dma_heap_add - adds a heap to dmabuf heaps
  * @exp_info: information needed to register this heap
@@ -291,6 +332,13 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 
 	/* Add heap to the list */
 	list_add(&heap->list, &heap_list);
+
+#ifdef CONFIG_DEBUG_FS
+	if (heap->ops && heap->ops->show)
+		debugfs_create_file(heap->name, 0444, dma_heap_debugfs_dir,
+				    heap, &dma_heap_debug_fops);
+#endif
+
 	mutex_unlock(&heap_list_lock);
 
 	return heap;
@@ -327,6 +375,14 @@ static int dma_heap_init(void)
 	}
 	dma_heap_class->devnode = dma_heap_devnode;
 
+	dma_heap_init_debugfs();
+
 	return 0;
 }
 subsys_initcall(dma_heap_init);
+
+static void __exit dma_heap_exit(void)
+{
+	dma_heap_exit_debugfs();
+}
+__exitcall(dma_heap_exit);
diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
index 27d15f60950a..065f537177af 100644
--- a/include/linux/dma-heap.h
+++ b/include/linux/dma-heap.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 
 struct dma_heap;
+struct seq_file;
 
 /**
  * struct dma_heap_ops - ops to operate on a given heap
@@ -24,6 +25,7 @@ struct dma_heap_ops {
 				    unsigned long len,
 				    u32 fd_flags,
 				    u64 heap_flags);
+	int (*show)(struct seq_file *s, struct dma_heap *heap);
 };
 
 /**
-- 
2.50.0


