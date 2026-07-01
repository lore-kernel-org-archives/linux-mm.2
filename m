Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5E0C44500
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7BD46B00B2; Wed,  1 Jul 2026 12:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52EC6B00B4; Wed,  1 Jul 2026 12:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBCB6B00B5; Wed,  1 Jul 2026 12:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3C36B00B2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BC851683FD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:04 +0000 (UTC)
X-FDA: 84940691808.24.444DCA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 523481C0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmKqxCAW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922142;
	b=F6Avabduu0SOs6mPDOsBGO7oS1m0v7RYD21uMkxITrkmtTNyX+IvVkxZjVAAsJ1MO7gwlr
	bRDA8SU0cA2wQaNwrfiK5TsZ2Wr85qGF6els/8z/gnxrSrhuwbu+hU4DBk1wmB0qV0ck33
	Bm4/otTBX9XfAkqDhUpCc6kJug6zJ4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYZqazgdSolQpQy+2sB7A95oPlBKAYAbvYuR6Jmn1N8=;
	b=Y7I+lFIMJV84yl0tIpDo82fE/Zw5YbxXaXooxV0KafRexNHZke5DdiZnIme/eR4OPC7Uzm
	DiIClycPc1TsILbbbhD9nwXDKI8gdsn6yymXjJzAPSEPMC9KI/T8t5EiyTaRb33+KbkFWq
	1yCvUrEvh/xUE7P6JNEFxMZoXY6AuzA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmKqxCAW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D2614362D;
	Wed,  1 Jul 2026 16:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E331F00A3D;
	Wed,  1 Jul 2026 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922141;
	bh=iYZqazgdSolQpQy+2sB7A95oPlBKAYAbvYuR6Jmn1N8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fmKqxCAW9ZQw2ij76EHSisJlZt7PILYObqadJGxOimfQFEaoyLw+Lww86/xhDz60/
	 mu4xeYfSGkyL/CLFsLSGFJCl1wgA+kGQvEA+7zMjlQRW/jowerVR3ydGOkHCC9uDVb
	 3vGfLhdbIFJyvp4Hl6XXXCHnOxNGYf1Bg86Shtku9U3u3lSf/EjyKB2uynKynHTAN2
	 SxnF1/t94D9lpIshIGAvJXaf3PZ9520rGqzeHDETNAtAs759d3zd9R6KkVrOrrjflN
	 Z7A2b2DvDJXsuIR/ONvBvZwEvsmeM+R9BFQitZv4mqyZ0MAl7d9+Jelh+/f3q0a3e1
	 PhB8Q5GD87lkQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:18 +0200
Subject: [PATCH v3 07/11] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-7-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
In-Reply-To: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3055; i=treding@nvidia.com;
 h=from:subject:message-id; bh=QlmXWpcpy6Y0NBVntHIBMLvS9FZD2uUVsJ4SeVpIf+Y=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuGp+zb11y66T9UFttG10WqjASBRaNLa3apL
 UC8kjL7aY6JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hgAKCRDdI6zXfz6z
 oZenEACSZnZGdi9oDEskVtAmQ7Iq+Z1zDTxEt4m8vq8x+Tdli9Lp8CM6EoNlpa2chjq78Z1BkY8
 CI6atjAQw1htYZJT5hVMoDluRn3EXAdH/T6z3JGodHS+bX+6rd7FBEkDKZLkTo81tv7tr2T+ATw
 eKO4g+DAwcexRYKeRnrr8cRAnlhEHSeUCb+byIYHYMqtqDnBSZR3kR/4nHrzorvikJF2ifD/sKQ
 gcVLkfBN2Zb4pr3FxtEdKzlTNlOmKITsRZ+sZEBtO7opp3NwJFImhGPzBAjWs6h21kPinPhFab4
 ZDG6iwuDXGegKGLwJ8rE2eShFeikOV5yXp4ZTPfi3CUD19I39n48nh9j3MgbM7JdmPZkj9aZrHw
 ncVZ2/xWFWw4zxwr6fkrHmXOEDg9M+68wn7+O72Pz/YndLVyOBq6DvsDmTHvSIz02AMeqlIQFB1
 A43oxA9Wvk7q7PHXWCUzu2UEOjrJp4MVrsm4z7YI0RgTy23l4dxRKDGO1C6LZBIGkP+Mvgby6NK
 FVZBFENxayPwfxHZzHXTJS8vIt3pZHrzwteSy+jGS0s6uO2NJoa3lBHLfbq0iE9xLpoUSu7wW/B
 G3r78fDqHtQft7uMHo+16WCcD1trjs8KbP+fQBJCuS5/GEKvjnxIgj7YhRHnHN3CTFKk/pn7rna
 LanK40WLvws7xzw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 523481C0004
X-Stat-Signature: ukad7bmgot7usxxqm4b9hw5hf9xk4q6t
X-HE-Tag: 1782922142-756527
X-HE-Meta: U2FsdGVkX1/x4NRw8/+hy1GnnCu/6ZnTZ5MohubG8ZGtqHvxqqxcLRYw9QXb/LXpHRFUjtkkyktjtocWlFpKvJMgjPdjrEVI0P5rhZ48Cbe5/JP5o9Uh1trFCu1DzSQO8hl87iUa3XsXF0DnSM0APVIDkbQ6oUOj9LDsCavaLO2ktwOFgFojIK9R/X9pClDDlEyzBjey+xLd6VyOAySEn4mrHiUru6lDp7F8J0ok+XaLkJO8sJi0vY5rGllRJuVHlVyXYI/X3PD1ab4GjFa2oEeZJrA+ghYszGERwHHM7mBO+6Z0hOoyF8xt+qbJK9aIzwzlwvtlI+/4pHj2+KhjTXQajiQe+Xzk+6J0eJ2zGYiEwK6jT7u8YFsv8XbIuB2YZ1KUO2z3/3izLk10RPzSVfE8CPdZCArZcjN+SLeVCet/wSiUnb2QBiJ5NvHIhL1Mc+xKZVN9fyLuZfvDomnoFw9HiIdFJNQEdyOWpbbaAcWXCfbGRzFpozlZKHBNwD8ykqsEXFYE9T9EOBmnm78or0XhYwcPMyfZHxmmRAlsNXDqOdwimfXyRNtgJcvTw1jzJ2to86lmY5yB9DGxnXXseShmX/CLVKVtdBnh4Qllb7G3e4jWNvZw2xvb1oUGgE9/tuWO7JqMWo2esVi6IYYqM6APhs26hksigk2y9uqlA9/3TTCfjqPv1PAw7b1LPzz2nyDOyfPbmQc1fVjP1yiPSmtKf/ECbc0wTSkp8hjSl7K6tUuu0g+csdS09p9wp8I3K7N1j0n1gpz174PY1Kfa4ODiJtQJNOpxd1wX2EtAvAv8Ci4QTngfheZzv9iRHogv1wMTu6DJtKDZspy37KQDU8KobCCDpatB+Hu5tHJw2SCjngyVd41XdrNszc+CHGe1M1I3aZSG/H2Dbcklka75QKE2RXsF+vF7p3oo+PtXtxzDB9GYtlj/lIwBy4ptdErlAWQ16sRXMvHECBMU4/Y
 i2fS5QR5
 Hnh/nJfnWyD+i9zfJKZgpStN5ugS78HEw2GJIZNkiXUrF1fRYeokJku+jwummOcrJ3aZDMLVpne4TyD5pPXhC673dG8KjwUp4RsN58SGr2wlNaLVTDjCpeR+QZ/U5oO/4eOWLPqiCLwMSPvbh5XiEMSjn+Woaf61E5+czp3YMo4rEan+7AaSYyqs83i7glR0yqXjNlQ+jowvtK2RDTOoQXDCuWkx4thQQnWIUzpO3yWA3wYTuZMAKBKODU+f8DbkLXFjR3+6LRksW3y2c5rCo94WbQRJO/fNUcGTHhbXQ3MQ+uSe18faIJ6bXM1UFxCpDUuNkhuob/6SYzFQ7btRcHU14fti0I6BkYd1V
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
 drivers/dma-buf/dma-heap.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-heap.h   |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index a76bf3f8b071..1ceb6ee8c05a 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
@@ -224,6 +225,46 @@ const char *dma_heap_get_name(struct dma_heap *heap)
 }
 EXPORT_SYMBOL_NS_GPL(dma_heap_get_name, "DMA_BUF_HEAP");
 
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
@@ -298,6 +339,13 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 
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
@@ -334,6 +382,14 @@ static int dma_heap_init(void)
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
index 648328a64b27..1c9bed1f4dde 100644
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
2.54.0


