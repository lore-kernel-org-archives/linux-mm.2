Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D06DC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CB06B00A1; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A822A6B00A2; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DD76B00A3; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62DEB6B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8CB8A330A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:37 +0000 (UTC)
X-FDA: 85186957674.14.71FE0D7
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf23.hostedemail.com (Postfix) with ESMTP id E4F1514000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I02PVFum;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGrVH9fy9UpA9AZ9KqQ2/KMZNSavqkxTbq8AljurNpM=;
	b=AggehqLxdMW3dueqd+wPxCOBEZAOIAdvgPFagI14k1JkIx2mWY+DtVWw7307Jk0AbhnrkP
	WzIUUjDdmBfHkwbn0+b0QlheCW86nNearezdQw2se5p91VqWl3stoGZjH4mrkqnvzH6uuO
	1hBnLDHRdjtKDiJCxjEMho7/yZpzWdU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I02PVFum;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785616;
	b=BSL3oVmvmfbEQhmaCXNKqhTMdvd5oX0+yompKRsjFS9oFozdLUQSkcgt4+SSK4lbYca2eT
	iWo3rl1+catlmYR6A7LvTwl4gOn1QTYFL3tvcdRvohE0r+gaQsZgLA2i7Go+mT3ZvzNEQs
	D672PDNe/YfP3uxOL/dynJ7ddMzDnQ0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SGrVH9fy9UpA9AZ9KqQ2/KMZNSavqkxTbq8AljurNpM=;
	b=I02PVFum72dTcDXMhI9WUpJrz0v2WqVX9mLsi+aYnsnReEY5+0g7815dtcGX7tW+5TLfeK5Bg
	zZm0gaClGUiOsE+lGyF4G4TTJ13ukxkzTmRDdkeufxXBA1NtKi7hNk1dp1dWkOQrn5wqgaZLE9f
	wYJPqvbo9HJ19S7IEe2HdgU=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtb2xHVz1prLc;
	Mon,  7 Sep 2026 20:42:31 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 314DA40538;
	Mon,  7 Sep 2026 20:53:26 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:24 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 02/12] kexec: Extract kexec_free_segment_cma() from kimage_free_cma()
Date: Mon, 7 Sep 2026 20:53:54 +0800
Message-ID: <20260907125404.922123-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4F1514000A
X-Stat-Signature: b8b3prat9eypc7nxnb3hf85uyqw7owib
X-Rspam-User: 
X-HE-Tag: 1788785614-361935
X-HE-Meta: U2FsdGVkX19SVBXRHw+6Jvs6nN/L7k/P6skW6Ttk8VBAN8Hxfbu3AKrhWm+kvGnGfNYRIVAR++a50v5XYpF2+Uaoh05jWDBpCIQu+oQapKuxE+y29wkdO/YgoeD9SyjmAtKrNMz83X3reNQeM764YUEiHml5JqE+bfV6XYaGeaI4Kai3hvhWlOcUBSEvGLDmZ4JQGIE8nTJ6TMAM97W7kLXoHcYHGqMYGQOv3+Nv1hdaDvjbtvvfVwXu50Kj3OM+akSEpbc1tL4EqClnOgbAZFEkAKjDL0brLd28pE7r0LNEimGouiImddhCC9cGQD4TYtxmWMWcO7c+k9SkBVoa7XzBNRgBaO6QNXMCizcJX72HUv5ibnUEKH2+EEUVublnbXCf59iC2VytVkjzkaK94+EZp2p/JFqQVwcLCqFLJFew52Ov1OwhV5Ovcz3vE+RjCsXPvBDw6rNqx6lDOOLemQTc+F1p+FMXMkjnhi+jdrwCCBaLrmMGtE+VDBcPVy2OVKQMYf3r6vh5V43ZW8BYPAQPVUlvkg/zGIfrm/OhR09huDzUItlfUkeE+fJgo7ATgHUDafJn1chNeYEMPkybLtAANfDB9haqONnQebbUCB4lXStPf8g9jjd9ZAc7b3CjppdhfFZuUvJ/9ah/S8l6grY2x2OKJKoca9nRZ65dknjQMM/MKUwkaVgE7Vrd+j1FEMHATZOEhpsNxEtdpIfomcpgZaQGuemFgnoXVtP/YQdiiPV2QqzYIseve5DmRnJ1eid9xqQsz4vo1r1p5ylKPv+YweMY+AbXUbq4UVb9h2NINxJ/smAVBJxoUzp51w+OpYFWX4/A2D4u5qwuo/UvBhsCxPWVv0cJJlpG3hadAaa8r1Hp07fcht4OW2o+rE8BZfQ+aS5AT/dB9sNo6x4UKSFsmOgUJoCK18WYuNvRCSEcLtufQKceKFt4ZxR7x0+9+ZZn19TfDhiTUWkpgni
 g5NveIk0
 f6XzKdmJBX2SKgOHtMNIgPSu3tZ2RdlOtL95yaHZmnvLUBLHkACorZcCh38DQeZyGiFN9RCo/OECqzzvjAlZz2B2WJOzGBO5EJs+V/RDEMnkQ4AKcS2OA8qqvsGelqoyvPnhgNE2qLJJGn5o78wGa5DebPiuuaA3tBloeqzD86lKF9lZjdZSeuxDud5PkHAloY3Eb15gLY3jES4WjGDwZhlwjTgmNfzHkbW0MEMS1x9f9yhGrtn4TMgJCD3XuL373skd9x5qZJ2RlVmO/vQyrNNWMTKrbuOt8IcVdx4hBPVrE9rsfIvVu6ErweVbtdDkx4efjbd/P/2tphUWBaWrYx/OzMAYh/B6JxeKGThu1m1fO6c3pRHRtRx30ZYCfWxO/gj2o26kIIrOTK+/bj4vUAAsY6YCWlTDcQhxSIUQHzXalMUrAPqfg49akW7A1UeX9sQHJxZoFvxILEMYcSR4mk6hgg7jrCUlKUg0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kimage_free_cma() relies on image->nr_segments to iterate over segments.
When an architecture loader (e.g., arm64) truncates nr_segments on a
mid-way failure, CMA pages allocated beyond the new boundary become
unreachable, causing silent memory leaks.

Extract the per-segment freeing logic into the exported helper
kexec_free_segment_cma(), so that architecture loaders can release
individual segments before nr_segments is truncated. Refactor
kimage_free_cma() to loop over the new helper, preserving existing
behavior.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/kexec.h |  2 ++
 kernel/kexec_core.c   | 27 +++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 6b1df80524bf..72258d813301 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -533,6 +533,7 @@ extern bool kexec_file_dbg_print;
 
 extern void *kimage_map_segment(struct kimage *image, int idx);
 extern void kimage_unmap_segment(void *buffer);
+void kexec_free_segment_cma(struct kimage *image, unsigned long idx);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
@@ -544,6 +545,7 @@ static inline int kexec_crash_loaded(void) { return 0; }
 static inline void *kimage_map_segment(struct kimage *image, int idx)
 { return NULL; }
 static inline void kimage_unmap_segment(void *buffer) { }
+static inline void kexec_free_segment_cma(struct kimage *image, unsigned long idx) { }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index c6bb9e48c590..5ed8e70dd03e 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -554,23 +554,26 @@ static void kimage_free_entry(kimage_entry_t entry)
 	kimage_free_pages(page);
 }
 
-static void kimage_free_cma(struct kimage *image)
+void kexec_free_segment_cma(struct kimage *image, unsigned long idx)
 {
-	unsigned long i;
+	unsigned long nr_pages = image->segment_cma_pages[idx];
+	struct page *cma = image->segment_cma[idx];
 
-	for (i = 0; i < image->nr_segments; i++) {
-		struct page *cma = image->segment_cma[i];
-		unsigned long nr_pages = image->segment_cma_pages[i];
+	if (!cma)
+		return;
 
-		if (!cma)
-			continue;
+	arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
+	dma_release_from_contiguous(NULL, cma, (int)nr_pages);
+	image->segment_cma[idx] = NULL;
+	image->segment_cma_pages[idx] = 0;
+}
 
-		arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
-		dma_release_from_contiguous(NULL, cma, (int)nr_pages);
-		image->segment_cma[i] = NULL;
-		image->segment_cma_pages[i] = 0;
-	}
+static void kimage_free_cma(struct kimage *image)
+{
+	unsigned long i;
 
+	for (i = 0; i < image->nr_segments; i++)
+		kexec_free_segment_cma(image, i);
 }
 
 void kimage_free(struct kimage *image)
-- 
2.34.1


