Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1958D3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E756B028C; Thu, 22 Jan 2026 11:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CDF6B028E; Thu, 22 Jan 2026 11:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252026B028F; Thu, 22 Jan 2026 11:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8CB6B028C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4AC6D2BC3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:32 +0000 (UTC)
X-FDA: 84360087504.14.FCC3461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32C17100005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SjA/SXGA";
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCPRZzz3AHv5xmCl3Te8t0CDpsPoSTiYh8qlv5mhg+I=;
	b=oMMkcVglHth0qbGQpGzF5n2D76tTHG3/SGRvsyqaioSKggx7vypehZXB70GA3ZFykyPrMa
	Jfhx4oUqyk0uapFaPq3q0DCvRvHdYEXkS94BP02hrxL6PlStJq23BmoKaXl4TP8ZufgaMn
	s/F71aFi3+35YipCqNNmMJ/0rq5nXRY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SjA/SXGA";
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098231; a=rsa-sha256;
	cv=none;
	b=QHsjPkMdOKCgXXGJ7BAKZpRDhEq6w11xzz3jZS4VgV8VKW5tfqG5O2NbXdN3GOZuJsmtOl
	lJC91m0mqKIWEDmLkuepHpGgMntEPj1bO1ayJwEmGNg99h6VGHYMy6seNLmgW3HTWVB31s
	3itPjuWWss7Rg522CzMbj6CG2SU65Vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B58F443DB;
	Thu, 22 Jan 2026 16:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA71CC19423;
	Thu, 22 Jan 2026 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098230;
	bh=WChLhg3S6wnoCNHOPQvw2fNaRZvoZP9tFa/SGNbpoRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjA/SXGAoPl/oGxtfFchmt2fyd8hHR2Ve5tsztXw1f70lpakxmLS1JWoTg+9xYI2y
	 ZGoeArynfQRqd2XutZyB4fhfndIIUSodnWkLqnMQ4D6vnfSGaCDcVy+V4dUvfAvpic
	 JySTdHE/lbnS1le+NU3iD0JDbDw9eNw2NGjj44qfwvanwYS8bydFrf25pQkyeI8qTL
	 z+dK2+Fz9+Gn9KUSEnWIa51ZgNXzK7IkP1LQX6op3JMf2Pm1Q0B9WKxN374mjfpYft
	 xwrzTxBJJcOEJ/K+lXNQCzlEikdHYBGXlSpeIkClqpsphJhABttEDvzb1iz4K0Qkbt
	 CzToYUXkHcH0A==
From: Thierry Reding <thierry.reding@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH v2 05/10] dma-buf: heaps: Add debugfs support
Date: Thu, 22 Jan 2026 17:10:04 +0100
Message-ID: <20260122161009.3865888-6-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 32C17100005
X-Rspamd-Server: rspam07
X-Stat-Signature: 4fub7kijeun69edhj9j3nhwdkw6hib9q
X-HE-Tag: 1769098231-968889
X-HE-Meta: U2FsdGVkX18mQ43tPmBqZR8MQ02wmOCyR8vra/OgtmDm3oGLIIdsHf9Xazkk+aW7dOaVbSaP6pGk/SAZrDsw48qHiVEDHSuXvjKq7wow8326yfDIvbACZWJenCMStA/JNpydgEmjiYeQ6a+n/U1MTqeRDd68quctr6WTjFlbdDuisyj2Aop8k6AdB6zqXfjdB5TJS14muKHFJzXvpqk6bukybwtuSiUhfMagfX8DYTxULsZyDAwf3MAFLZHOSsLruaHIh0qTj2S3foWeU7AgyMtWaFPHI03CRO4Gu5Wzpv0FLga2jE1RzVVLGZyW1meiutLFIHTGN0ACZkZFfmercYEuk4bDmB8lfEGo5jTbF/EI6IAnRCj8E9nLW8BUKJ3K5PRkAwfLAagWiC5kL3ow+S5SPjmS88rPvWFfX/RDXFE4LzdWhwoCaMIGBH1AroiFj5vGXCQSKvakJ0TO8x7MHhznznapUnJ+UDHrAzpqM/p6miwXvYRLUFVV5jjPiovEkUzfl9N6R/PgJaRV79j7gtpHXOAmD83jWCxeerOEd21XwbM1+qLIvKf7FwjcJIS1N3877kiXpzBumYEfKMIvLD343pCgsIF2UNVzT1P1oWsXLM+tGMXS8/sYj3ZQcAz9Fjs1CqkLs/ZX5NQLuISVh5fOAMOfkMddf/s5ymNA3b61d+79Jr+vnspAzFD2ZlvMiGDg6xo/wuOBdcrMCR4/pH3x4qwl7XSoGA5fJYLQ+HbqCIMHeyDZlqNWnKYWDw4kH4fhOZhUfhS4iInVU/8hhk1hE3r6jb6T84G5qffGfQbVtqyWVyiD5LlbqwcO2LKdujhtDsdiellqCahWcreCrj9U80kDQ+sSBYPm5Bs915NaKybX5v/3jmNTcif3pG/tjLyRuXcgXmLApWFsOxtwnenVU52n9rcYCS0FTeaOBpEWEIOicU7Su2/jM10xGGOj5Xo/ndUFH8tWeaIeM3Z
 mhisZIAu
 lsaG+p5UFgUuPgFjXrnTJZNZSepnmAeKTCriAHCbrcD8o0Vujo1umiwpYAebTTUlyZT/vmd8x8B1sWMEuyxP4EtZOLJ9SPjD+bpRRYBWXFq6U7bVtICsIpMRGDpgnLmyjdyOI2LeSFzSN99VtEmmpOfYhxP2YNs0LX8iooZjQT/bX8j9FF6OKAjcYY7iMkLZf9P6my1gJl4RWmAu/Gv7UGuK0ByPZz/hOMnVF2ltml7Jt/5A0YljrItETiZRmfF3pso59ju4/BXS2ks0aO+U05qAt1hLDXiUI+joLumJYr7ehtlyp5xRqj/skfPmIEt9R7Jh4DDtt7ZFM/wMxifhw0pc/CqqMBBzxpDztHNC5VoHuOD/TXhouSDHTRA==
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
index d230ddeb24e0..9784fa74ce53 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
@@ -223,6 +224,46 @@ const char *dma_heap_get_name(struct dma_heap *heap)
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
@@ -297,6 +338,13 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 
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
@@ -333,6 +381,14 @@ static int dma_heap_init(void)
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
2.52.0


