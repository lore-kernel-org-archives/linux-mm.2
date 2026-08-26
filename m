Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAFCC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E650D6B0096; Wed, 26 Aug 2026 05:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16756B0098; Wed, 26 Aug 2026 05:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05146B00E7; Wed, 26 Aug 2026 05:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA97E6B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CC74A3675
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:20 +0000 (UTC)
X-FDA: 85142887200.06.F6F5C94
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CF7E40006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=T8c8+n0h;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbSk8OJq/l2XFTPb3OtwS42B6HB337pYFx+UhYhprQM=;
	b=10CcjsRJnsTBoVdoF6eHsUJyLWiSGGlqRBqYLC3IOqvVGt1o/WW7OhYplwONa7R5yN9grq
	JqaaSzM+ahaUjtnnfChvfIl9+h3+XnA+uTtck3yYBj8jH2ZjWmBOUz4NT0O9p9XBSiNFE3
	XN2us9k/liR+8HTtnfIssc+BKzwQ5T0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736318;
	b=h62dU7sJTr9qdDFV+rSRFMGRMEAJf+heKcN0ud0LdqO4h6U1e+T7qFdPgCA3LnNTjHr5gZ
	QefXqHiMfmd2mlJFcnqFXu/dmC3j485ZVFZqow5cz8zuDWscV/570MO/AcmF79KNTrXTyI
	n2jLOIhIay5qWWkizIOOLf4EIyiPufs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=T8c8+n0h;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sbSk8OJq/l2XFTPb3OtwS42B6HB337pYFx+UhYhprQM=;
	b=T8c8+n0h22Tq1zVVtz7DjXb5w6+R1aGD/V9ecKTeM2uRCAgFmOcuoeWtKKBKTJhTcoEYufilU
	nHB7WJmb9Tl9N5EMS7H+1vNtHc3odCNbsM4CaphmYV0tEmTGQs3nEvlZcBkVf3LqODgbGw8yImD
	nGFusQhKqhqcQ5RieTuHGsg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVJr62H8VzRhR0;
	Wed, 26 Aug 2026 17:14:30 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id ECA5540561;
	Wed, 26 Aug 2026 17:25:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:11 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 02/17] kexec: Extract kexec_free_segment_cma() from kimage_free_cma()
Date: Wed, 26 Aug 2026 17:25:26 +0800
Message-ID: <20260826092541.3905933-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CF7E40006
X-Stat-Signature: aapbhixmaohany1ww5k8xi477kmxdi88
X-HE-Tag: 1787736317-123600
X-HE-Meta: U2FsdGVkX19bJ3DrZRLJNy5wpl58KjBEEgCsvFO7JZSSG8KGDVPF7HoRdU9J7F+7aQbDXyiRJeaekCcYfiieTT+CWTwKcgLhqImkDdiUSdKw6bqzfOW3f1krmCPy42muUNnO9FOQZ3OhPVCbj9DesLbVAMNdgxkBdF15QprmPHq8gLI5paKhifYs53g1tnG3+nTLIfFhA6HXZXrrFPruOv4qGQ1RvRhV/RvRc/0VL+Q/n06gtaGMLcgeywkPurUigjMTWgCO2o43oYaAYREqx8W5whhq77D6S7B+WKMZ2eHcP2act2lbx3pJ+VJpT3vJVkjJOt1ZK7x2F1cvOOMhJ3pOpYoEJggbalrxwa+sbvkyjtHZ9gC6MwbRSZRHrRgfaLFNLNfdvxo3nYrH3UxVW5DymY9IGtRFsS5CQ+8zys33lK8CMOQVjxBApWDYEtgHCbpIXZNEvpzB8/TDXKIXz/7/MuZq/rNyLv5ofSmS7yxiOdYNwzcA4M9cWGy+JIvZumOrwZoC7tBpAj2ofcrmo5thXKsHqGS6qlA8l7BdVKelYTtu/+nyEWFFIxMmOmybmvBd444S1yJ2I/hoENyLYcEBfgc7fvAxri58FvfXHPFcCfn1RdLIvN0FVJWoZfKdU3HtwlN968jksl2IbmMrA/rIi5WEhrG7bcW+ILbZYbDNzvyVYGenL4/svMysgt2tlt0qxONS4paFsliANXjJUC16b+jc3U1RXktWak4EWODssbxHLr207JfyPYghOaRtpcmUFvXkWNDmgzazWqzFoAJxFbOFS+WhkYbFqlWxUT1nIvpHlqCZfQB3tCI3zG9u4wGJRN0Xfx0uIvRkI02Pw42HmEzpP+cmvSD5xWI80d+czZU/9mlmt7UYf7W59QLwK+2WtJeq1qDmjOzcshmawiaK6Xgf486bU0xrDn01Qb3pdAXNO8yO2QD04W5yjG7+/L2R4855hxbIM/rM3ZD
 YeJjPXJM
 Waen6Cq2EzNaQQjYKPmsnZwQFr7UDNti9sG7I89GpmlOukVOnwcHuK+MI9mebV5RxLsNZB4gjCTgJk+tuQLURkOcnXzFSItHOs36TAfIjwMPR3akKi78D8PKjHO/z8baNyVh8NPlE/4ecymPfRbxJYbhCFX+ncGEHr0Hx1aIax6fEv7AI0HOfGqLW484s43V8zrALquObL2Y2E1u6K8NzfY+pvC+YGrxhPIaYMH0OA74u6vgvlbVjSr2Q3wp6ZZKCxrXcXxkTxuBjMXTQGfzeELLGm9auFVedI/u5Gs2NQ9ftsps8Qz35sCCkAxGPgmA8G/uhGyS+NM5J0I+Ch78NPtuyD11KVG7SpjFay4bZ7WEJj+4/Vyw04y4a7zd1q5WmFNC2+/h/kmzYhZZwAXWEITdQdiB8HuIg7+p2ps6JiiXIuOAIfKjp7Lc8/CuliWg3/t0SpcUQDhqxnMIzZ0F3lSarQQ6QE/PUMv7R
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
index 83c296c0eb6c..d7c83938dfd3 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -533,6 +533,7 @@ extern bool kexec_file_dbg_print;
 
 extern void *kimage_map_segment(struct kimage *image, int idx);
 extern void kimage_unmap_segment(void *buffer);
+extern void kexec_free_segment_cma(struct kimage *image, unsigned long idx);
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
index 611b15bb1369..ee66e8ffd358 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -554,23 +554,26 @@ static void kimage_free_entry(kimage_entry_t entry)
 	kimage_free_pages(page);
 }
 
-static void kimage_free_cma(struct kimage *image)
+void kexec_free_segment_cma(struct kimage *image, unsigned long idx)
 {
-	unsigned long i;
+	unsigned int nr_pages = image->segment_cma_pages[idx];
+	struct page *cma = image->segment_cma[idx];
 
-	for (i = 0; i < image->nr_segments; i++) {
-		struct page *cma = image->segment_cma[i];
-		unsigned int nr_pages = image->segment_cma_pages[i];
+	if (!cma)
+		return;
 
-		if (!cma)
-			continue;
+	arch_kexec_pre_free_pages(page_address(cma), nr_pages);
+	dma_release_from_contiguous(NULL, cma, nr_pages);
+	image->segment_cma[idx] = NULL;
+	image->segment_cma_pages[idx] = 0;
+}
 
-		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
-		dma_release_from_contiguous(NULL, cma, nr_pages);
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


