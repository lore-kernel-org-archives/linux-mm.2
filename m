Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02403C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD516B00A1; Fri,  4 Sep 2026 06:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DEF6B00A2; Fri,  4 Sep 2026 06:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8586B00A3; Fri,  4 Sep 2026 06:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF2B76B00A1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 482D21C2868
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:43 +0000 (UTC)
X-FDA: 85175748966.15.2932178
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7A46280003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJ07LRTm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URDYUrqbvoFrys39J8mEIELRy5W+29S6/Co77OGahWQ=;
	b=ByC/t7wjkGdEMRJPCbwONwISOwhJAOv51Bju/A6AZDYbw6f02cwy57C3O48EyE6X8ujPHY
	26krZceIWhb4q76MqXF5654jkPLj+tr7Ldz2/6YrosyVJQhvYeWtqJUSZxzRI1bUntYkDD
	XXwWAGRwqNtp86aIpmjNwhIdIjkNktU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJ07LRTm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518741;
	b=dRm/ZjfTmSdJcKUTA/4RjNr7AymfP0WIdnV9Qn0791B3v+vYeX71tkzlbL8fIbanxV2APi
	D5iDOAd4Px8m72u8Z9DOK3gq4/gNTZmL1dwUfeA6m5CcOkzMSmNRqT2GHwmQnVRUElci1b
	owggLPe29MBVPLn9Y72TsbLYb7H/Okg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18D7C600CB;
	Fri,  4 Sep 2026 10:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF31F00A3D;
	Fri,  4 Sep 2026 10:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518740;
	bh=URDYUrqbvoFrys39J8mEIELRy5W+29S6/Co77OGahWQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MJ07LRTmfws8dXur0isr7LB/HULUxkMqgSEAyRbIOmKqouVwpQ60B2f+U8uXM5gcN
	 0e4rmcdkfnZ1f/cgp+89IGLqQeroCxFS7+p8ooIVtBQV/gxf7yM0MorJ/2W3l60ERD
	 SqPP8/rtWDfUGWUZdJEkAnHQEBxvRcWfTbEdpPj1xkmjAEcmQ84sXaM03P15lX2dIN
	 5VIPwRCT2W5u7oHyh+uqVSCN8zxCw71ovjataEu9cUYRGZv4qUUVuiVPd8YliRaimJ
	 8n32Ozp6KtRjSV9ii433WdtqaxYPsEu3Oguidc0Wr4taDVXHAvxPHnJRkbEh+VmmwD
	 jWI3To2QfeVRQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:59 +0200
Subject: [PATCH v6 08/12] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-8-79042cfa8de5@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
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
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3268; i=treding@nvidia.com;
 h=from:subject:message-id; bh=PTbCupvjHWmMcXwEcqCBr5NgDg7Tooca+dUOmGKhZ1w=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6C4dwHTnCbC5FbKmwaT00Do0hU8YNS/+jY
 a0Lv2wvQJmJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 od3iEACHrxrMF5hDeTgSv/upZk6DbDhcOknfUoMDoE7ao2NckqEMBYrL7W4jHqK4OEK7Zz+Dy56
 l74sJCpjbOE+EkqXP/sHP7Dcowfz3/rUTKNLWMrH4GjEGlu7zCzUfqe9PlPOhT/f5oe6tVL3Q+l
 4fnwRm1olqNLtZKAaffoZQDNLjIFBhQaOkiSocS72I+SMAGt3LOPJmfGNW8bruRDtRjbPbhwrFM
 WqgBdknbnk87TQzuuv/Zudx5uvzXPtUuPjijyUjN+8gaRNGNhWwHmP99qSG5d/B5fdFRKj+I5QI
 dTZRvzzxb/PUNF880+qE3wRTxd/6djnnZtAnFfPGRiDbcN12cApJdAYSaVOm5kRCMx0A6V11rQR
 uDMvgB/adcG3P3T5x6/CVrw+KXHOR/VCGHa16YGbjq/ajwJsGyl6NAVG9vtaG5LfS6pcjlH6HRh
 m6VudFk+pfDpMD0nWlqiHyk1i1i3f3N17D3B0rtg2YGGRqWhikWK9gci3YyCRCr21+wBfRL9zMv
 qlj3Zcw1JoK3hGRi76bXm+p0EULU2PMdnR+MA7z83OdT7phjtBsH8aJTKXrKZIGuBDwClD5mp2h
 9YZqhM/c6XIMG0xogYOIiMIxQZuqifr6ZvL2iC3/JdsepRVwO+hgJzwNBTj6zC5KHqX60d1rizd
 XXb+4oFnVut6Zsw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: xrg8t3rccbpcugkocmcuwh7qetb6chwq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7A46280003
X-Rspam-User: 
X-HE-Tag: 1788518741-71125
X-HE-Meta: U2FsdGVkX190oAUlU2m6qmz855TcsGedpxJFEgRgSbl0elX1H5zaDVdi0xcXgGlswM1gAWMYXPPuBho4RRrRt+Yc+SQQHaeQT9KtQZVe9xwOdqMA0wrDxkgWtTe8AAentyCfU7I5AuzidEu9mVhmjVlHBOyaVxFN7bqcTtlKZ9gs+PsGBgD7cBrnC+z09y46MJ4v92vBMX7zE7DeeEWe80nTt79eBfhKGHll0zi6zf7dLxxNYpXpuf+c8OgShfEC5WuZciwS6KB4didfMOxYz9uykP+fNAv0zVmlgtw43NMetHrmynu5nCSUdyxC5Fx3zn29zxoDC3S236AK2DEDK2i60WN5FqDWaxGiOewStJZ6DUpXN0HsH3WR8oHDaqZTlxIY3gFSY7bPbN1hfzhbFksBXdm4Y0U/7v9jOvLdiVU/2GD12ER+YUmZU0BOOWjlmhw17V22IjBfJLovbMovmHg1nedLxZqAo/kV0X2ytG3oTtBPaaqHVZq6dalYJQIYGTowNdQhrl7VuuANQypVY/hkAxn6p0lEpV2sGU/rqj8Lgopd9gDg7fM4IigfIpCmgshuEmWNOHWhidt3IftpU0SlPCPbdeGMaWOV+GBL5BVLAMGbv2qhshqx0EEzEOInZ9q9r9rZ2Bn2d9Cjxm+t/WHf0IlwFndY6z2fL3VZfG5vn5hJFdTnGJzib4p+C3HuuE80SUnZK4WH2tFPwraN92waH+fOqoARa0FYCgg1djeXtW5oo4HqWmikiFOWSj8Yf0TYJnjC9vMg5XJRyZ4Z4U4cqBoRb1tRl7WsWkY8yo3jRvb9lG8TRmsF13DkqW+hfbmDX0XrDKttv4GMksvPIsFCKVrC/drTZTdf88jUCkiutvzGNH6NH0U36Uu6qyyT48/JLdvOWXBOo6JlrsswfgbxsI3OM34B8C8Oald8RaO1qjwTaBkvI0B7/hhnB5etb1o+qmwv8dwHnwyRIy/
 ZnOoRVW1
 cnEKVRmjBFujfRmPANox4VUXRBDi5cpPoOILsDScks1FSyrLg7uPcKwvylmZD+a1ysRldtSZlQER6L68MVFSjwtVz3Kgt8xqwWo/SN5wl3+an0U3Nvd42nsuoxnqUEKyOn3Cw61exfRBNw1qfJL9v1YtNo+UxL7Re41fTHE/632Mhj7ZIOCMRX8gdAuTZD4UTIOG6TFrLK5NrfcUXBrkl4UCuCVrk1Fw6vWlnKY1FEC51AXsYaJ5Db+yniOTyZjHqvTKd0vb8egFKkWDQ15vjhwHcwgLku1LVz1V8IuThofaOSOkHbXJtp9/9FanDjX0KRGa8Z0FaN9QSniA=
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
index 8a6c2b6e0cc6..65c80dac6500 100644
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


