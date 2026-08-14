Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B38C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779CD6B06D9; Fri, 14 Aug 2026 11:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752236B06DB; Fri, 14 Aug 2026 11:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667BD6B06DC; Fri, 14 Aug 2026 11:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4A06B06D9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:29:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94F34160178
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:51 +0000 (UTC)
X-FDA: 85100260182.08.34CA185
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BADBB40005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ln9neMLZ;
	spf=pass (imf01.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721389;
	b=Cbn0cwzGlhU/buG8wWpEqjkO8v1WDhCZFDltlcBfP9PovAeuh81fg1RZpMucydPNsTtH3L
	WdwEZ5EG3PdoTR35bmAU3NPIxUcQazY252PKzjyMWrMBcKQYfESV0/kWn1A3MegpJqmRBo
	/7vlWKR9oR9JfIK8nSTCaNUKSyrc/ks=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ln9neMLZ;
	spf=pass (imf01.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BzkMYY6PcCnjt83f3h4QxpYa7pa6qO3m5eLZk1ygvA=;
	b=k4r7Q2dFtp4dMetRUTwdi6ic1+hzO9GnZCRtEd0YA8+F8MYh9zTR4eBGNs4xqFjNnCvSqB
	Z2zqYYZQ6eSY6h43WLMizTQEzj1adra0xqWa3h5wK+wIEcWn/vWTtbc4DgrxewxxBtBsUu
	4ZpUKmvzrL5I83n0eThjdxbcS/54Wgk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 153EE440BA;
	Fri, 14 Aug 2026 15:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D21F00A3A;
	Fri, 14 Aug 2026 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721389;
	bh=2BzkMYY6PcCnjt83f3h4QxpYa7pa6qO3m5eLZk1ygvA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ln9neMLZiNxLoktO8600yFMf9c696Sy2dR+14AC2Hs2g+Xi89Txg/bSadDBOpbwcv
	 BjvkAaOqDRQNOHgRnewOmAypSnsKE+p2FrMqlmZ2f8C+cVq58bhg6cssdS3UQxJfKI
	 4FYONwhecSKXCZPQ+MF/0p1j/7vXqbFHU902HXezxWfV29DnYWXw43Mql6vCbCX0Uw
	 PUFhHldktEKV7l/kU0JqP1PDRyq2wf7e8rQap5YtVkKbAoJJVLBtknA4AFMTdxu7VN
	 0tsKp78ANWAq5hhJVzfZBWQfwVhmQXBNALrKFZv6gzQIZaf9k6CQ9cYKzWTXlCcb82
	 T/Ew0aZzK5jXA==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:14 +0200
Subject: [PATCH v5 06/10] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-6-71832b5d0246@nvidia.com>
References: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
In-Reply-To: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
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
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3268; i=treding@nvidia.com;
 h=from:subject:message-id; bh=HQOwe346eKLILGUmI6Jj24mMizqBZC+UN1JuTqxPA6o=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRYmBB73yTjIp5WYf1lpDC/x5XoUQVQFUBsE
 No/1I1LYFCJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80WAAKCRDdI6zXfz6z
 oZWhD/4hADdFVVuUvAoZK8vnwfXJ/xRPQxPYCgpzlO8eC/xBPUIs2BUZCanYUlRY/Z96oGX7ivB
 u+VLQ/yymD2KtVUK1Cr5+MZNleFgmE6dONc2BdeToY3RfHjQq1apoi+paNZvQeZIhMH77FHFGbc
 kpgO9CLRwB+2rMDRspKHQoxXt3Iz3v3DvXJsZQvKTEwlrDGntDF+kLyrihrF6zLL/8aXexV1aX9
 UAqqpn/zR04SbLtYQT08gdMQ2N9fuxXs5V+DEKW10Pq7UmbnEp0YzH9bRFAs0X99ULNLbggnRPh
 ikGbklpZPQkphOWasX007jnCYHoPGGfVannQFtE+lCH5KgVA7yRqjaYyF0/GEpZtIJBYBVBu6TN
 78xWK9CyM6mluHtF4kr3sF0b3zNf/ElnTuqgCVRrq5WIqG4CF4mb3yuubfvDkPAUL//ToIfmVD1
 +JnhzKzBJqKSyxC959QmwhelV/tls+oASyCVKUMSf1vwc+1PdNV+9ViaCDF5gXT+4SrVbXAXoPA
 fzKUZ2FmUvkjCxr+6BMxmnZLmRhFs5ge/h+xS4FDsZLGdgtT7bQJqLCL+oZFoM2A79WT+tP5cmt
 52I38IluSVfOTmhe4upYRzOlQUw0hLB4XcPa2mI8dPQWD0/iwaaZGaTIoQg+c9qj3TiWs8Q9/p1
 3YgAjy39e97CSgA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: BADBB40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: csy7q417dtra5qikp1b84pyg3tk7fx9y
X-HE-Tag: 1786721389-132055
X-HE-Meta: U2FsdGVkX181sAZA3QOER51eDOYr/JSK47Tzfk7MPCiAnQJ9ERpc/nl0CbrJ20BYAkfzvUV8M5wsaBsEzI/rZgJoQbhn1Z6gatwWtS+Qdd2caHOsDd8yGEPZpjAch8DNwiCIvvjNrKcJxgkDb9nsZjwUiylOqKKcl7JaDUeV4S5hpTrn6TOuimTf/vIFnHxh/PIzSckaUH2nNGrR/vNHcjeux9rKr4s8Z/YiMCvZ8dMZlIBghYhg+Iq5Ru9j06vxHcLZNlnA2BFt/PrNkom0tywlSDHDz7EgLnGlRnhPCRrRHj+sKLEiiwn1U2lH0qTmSknghF2P8n8IkiH/SVXnwAkmV9JLBa7SjYJ+7KelzFUF48I/RtTc27Yh9ZCjZSQT8ztCCgQ3xinb6y00Fo2vCy6Bvaynl7eU7RrOmn/yaE9OxdrJGKV275bDEM7NMDlbR/zzV5IXyRx3dydtYv+cG587jqdoszxCCTN2bmssL6vs4Lb3AEdG6O/B2WXexQ4hoR5DYt4tSXXraLDhIbAjDNuuG/6tRdr4YIBynwFdm1FkzG1tg3qKQibft5awehMhXbVn1qJ+L+3GhZozImNqAxYBkT42Mgeah2m/fKOqgPVi7IUDd05qDRLrPOwehVvwlwVXOZ+hFj14S7o62puZCsVTd096hl4wuU7EnSaxp35wzanrCwPP3++a+7KTppTG9X5rWDUyTkunlSaLh87IMenjhbUzTkfEFXuC9wzqhJTQgQoc2VTpiOkvQ0IxgIuSPM1BvJkVqYGdLcgjx6IWt2PIDk2WT9Mp13Wd/3HLTCvalYPahNR6n7X1lHH+7HtZE/ZLJGQdgcTmCEw6DDfaMolCj4d/xkEcJ5SBxJ7SaGAMD+wuxPDk46eKi7HwgFbSjElwklWgTBo6Ki1KlJrrGIf8V19c6oamgvHV8ZCN6EHvT+l8DelYxxQbWyfggGCkJpZI3ekCL0bVhSjwafr
 uZ/9J6VZ
 kv8nb1MOU+ij2iy7a/NFfnGzwyGZJdfY5CVhM9GhHgm+ihCumgmb36rrsvKvOcf/gIWdpvj3oxsJ5kmxm/Zu6RspN0Blu6BxzN3vKTMFg1A+5Hz88X+A7UnXrr3vSIk4B8Arr87fKwvH5SvwSAkE9nkRis0Z7EmbJ9MNRasSXQfMv6fJU0w/MXhYL9FE/ojbL7yzSAoKi4fCEQ8LkLkFOtAd/U6iR4PfYltijuAUI1zDPVBCL9sxiGQt4WEEq1b8j2PW8/1j1nu7F0gMREGj81ESlPIBhRNpkCc7ms+A2ynZoPpAHykR8PhlJ+ToroH9Fc3McSZhoA035sFo=
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

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v5:
- fix failure handling during debugfs root directory creation
- add more cleanup to the newly introduced dma_heap_exit()
---
 drivers/dma-buf/dma-heap.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-heap.h   |  2 ++
 2 files changed, 54 insertions(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 3937dd41bb0f..f279b8fdd3ce 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
@@ -225,6 +226,40 @@ const char *dma_heap_get_name(struct dma_heap *heap)
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
+	dma_heap_debugfs_dir = debugfs_create_dir("dma_heap", NULL);
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
@@ -299,6 +334,13 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 
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
@@ -335,6 +377,16 @@ static int dma_heap_init(void)
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
+	class_destroy(dma_heap_class);
+	unregister_chrdev_region(dma_heap_devt, NUM_HEAP_MINORS);
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
2.55.0


