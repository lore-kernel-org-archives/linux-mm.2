Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF90C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577596B009F; Mon,  7 Sep 2026 08:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528716B00A1; Mon,  7 Sep 2026 08:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0106B00A2; Mon,  7 Sep 2026 08:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CACA6B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A6D0160145
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:35 +0000 (UTC)
X-FDA: 85186957590.21.F1DA2EB
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C043A000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M8PU2NdI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D68n+wUdEbntE086Q5RdH+EDW2kWPbBp5NhhOu0Olck=;
	b=GTfHiAqkP1Qc054uhG2OHbCua2qTyvuDCbt6Tdy6pzuK4JPRgqoGfc9mDglybzP6qYK5Ow
	D2KTaPeNgGMPDAks/xiW4RK0yb+Xi1wFiO1xw/7lSgkt5NZoOKxVNCNFLXXNmyNgmf3i3e
	4aEBp80aXJkZdjUJUViBY19+KDXz89o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785613;
	b=A4MHrj4B6iglsRsjDSd5AW2xkrZkdSwGHme2s9/WQHrDjizA2Qpzv2GjKeUgI++nUMaIaJ
	kxebkdpuR4dftN88O3gCxcpj0BDGDCwZmLKRrnukPYpMbj3+Ps/aqMC96NffTC3Bbrf2z8
	VDtLvxj9rLLOGVQaxCTXmE8OVLsH8Wg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M8PU2NdI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D68n+wUdEbntE086Q5RdH+EDW2kWPbBp5NhhOu0Olck=;
	b=M8PU2NdIC027E4JrCQXMAmov8OZoHKhQEBVSptcR7Ocinuw+G4faRupGnjIG9F125KFAOhr8A
	qROaICB7DVUIdNWXUVLpb1D5y2L33L8PHpKccuKfkYxCvmOn0PSRfgEPHDlnYPNCtnosyOcuOAT
	vVekiY9TLevHinTwQt6dzCI=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hdmst5KdszpT1C;
	Mon,  7 Sep 2026 20:41:54 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 9737C203B8;
	Mon,  7 Sep 2026 20:53:24 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:22 +0800
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
Subject: [PATCH v4 01/12] kexec: Record allocated CMA pages to fix release size mismatch
Date: Mon, 7 Sep 2026 20:53:53 +0800
Message-ID: <20260907125404.922123-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C043A000C
X-Stat-Signature: eypfta6ic5fzqf6pypcguugb6qu9xyw6
X-Rspam-User: 
X-HE-Tag: 1788785612-787129
X-HE-Meta: U2FsdGVkX1/CGNJzFlwtrnjcM9iuJ/Qyy+5sP/c4l9k61UyDF+4Vx8IJFHA03h+M5LSIjuGCixY+Ihwdxs48k8GLrs3lPiZeo1l0aq6lc/BJtuAKMCzEIV0URftNGaqvCaT07ES9NukvCG2v7c2zCPaqo31CqJOz/rl4TVOi64CuTpIkvFzHqYiL1DrdxkbrWr8CGXq5jmvk79lIrvLVC4WCzz/FVpYBmD+9vqveb1z0F8EcIzZGohKGrTX5rFH0DnhbDEqFN/dvlaDW/qIyZkBper82EqWm0utbiUgD+oCm/uNGEAzC2FEJH4IdDS/oY5MaFIrg+Ard3HJykcmcavY1f3ZQ0dSRZHDgC6llhySzkeILZkAjaHvqXQ4qGtARXzS6R4GkClv2Qw7Mfimwntl+xK3n8UAcI4KvmQHzvMoB/VDZgrlow2WgzuhIFB8WuxF5ePXsUx8rWngBnCENYNhMf9wPQki4+nKCuMJZivQx23YQDwqmMVw6yuhTdHaO3O1hNSj3a5GUlGfhdYiExGnDOJg+rcPuHHY+rbJFWT6DJh38m5rKmLchzbBlv15DrHDZu79LrgfLyl5stmS/QSDjg3I6v0OzPjl2hmB9mjr6Nbv+0pzIuqNerju0KHJhJ9a7tCLfopRaMi/Z778OmblDrR9LwUWY8AfzOT/5hHBfpgQHeMF2c3Xlqxl5/VP2DGCZpEE7aujstjt7izmjfyinBpqXB30thGBM3rdJZcDna+N+dXGUj+bur00AfMWC8iE9M5othWaSNjsQuja4ZhxRs/AgLggVe/aBd50orudqDEiPTChdpPJAUY9ohtj61aeB3/HdxyddRt10G16ERlJcvdWObFJxpj2bNLUQ22eZiRDaOxhaJhRsPUk26NVMDm9iplC941A4DrasnCcdxgyMFDHcO9drMbcm+pvRklGAzNeEqefwM/zJhnURg6br3n6xaBeLX9JxpgVd1QJ
 ub/VfFgD
 hjG4XmRYdN0+TOz1jBe0H1mjmWFdUDGnRpyV/j9x+/sB6PFjybnFV6bJPX6xsz/hqDUkpah+fGIhEB/Ud7y/i5NrjiUasVmKOqQRSaBq9dsgBCg0XEy7iD5uZDqYFmFuNfgkqIVbPirYIrm+JGmEHFwk6oE/OssILJWYySXLY8DT1Ibo1VuLAq6wPo5mX2zp74pLkVOJQU9+IGIWlBhU27uPNMbPg4azWpORvvKdbNJ6TDgSds5sitQ22ujcsEQ+79SmXPUQbRrksic1ZUJP7ohLQRLuIicwpc4VoEc0KFWlSlsnfJQY9+3aZFJ3n+D1RifWrxG9r2LlsUIpjqaCghtLH6pM0oyvMn4nffyfDgquPvHrvGNvWkxiLufr8L0PHUy9MLls1Gjb9J1ILHP2ZESowuCC7H1qqEOycv/we4r7oIIiGbVxf0qJKzbBX3Hmbb5Bj9jRiuJs3esEWEDY1nx3es75uXA03JYUi5cpEnHg47k64cIHDnXxR1cxDHB/NFtr8k6rrAgz0ohK7wDlnqRtX0bsZ7Azf4xvdYxIC2GT5hxhVtT6XzvtktIxdAedaFe/hf7wHc9CaBO5cXne4hzamQmJjcvgVk5LvWw8NSy9hmTMOELnKdFLKXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA pages allocated for a kexec segment are released using the
segment's memsz to calculate the number of pages. However, some
architecture loaders modify the segment's memsz after allocation
(e.g. arm64 subtracts text_offset), causing the release function to
free fewer pages than were originally allocated, leaking the remaining
CMA pages.

Add a per-segment `segment_cma_pages` array to store the number of
pages actually allocated from CMA. Populate it during
kexec_add_buffer() using the aligned memsz, and use it in
kimage_free_cma() to accurately release all allocated pages.

This avoids relying on the potentially modified segment->memsz and
prevents silent CMA memory leaks.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Brian Mak <makb@juniper.net>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Justinien Bouron <jbouron@amazon.com>
Cc: Li Chen <me@linux.beauty>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/kexec.h |  1 +
 kernel/kexec_core.c   |  7 ++++---
 kernel/kexec_file.c   | 13 +++++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0af8ae4fdd08..6b1df80524bf 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -349,6 +349,7 @@ struct kimage {
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
 	struct page *segment_cma[KEXEC_SEGMENT_MAX];
+	unsigned long segment_cma_pages[KEXEC_SEGMENT_MAX];
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..c6bb9e48c590 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -560,14 +560,15 @@ static void kimage_free_cma(struct kimage *image)
 
 	for (i = 0; i < image->nr_segments; i++) {
 		struct page *cma = image->segment_cma[i];
-		u32 nr_pages = image->segment[i].memsz >> PAGE_SHIFT;
+		unsigned long nr_pages = image->segment_cma_pages[i];
 
 		if (!cma)
 			continue;
 
-		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
-		dma_release_from_contiguous(NULL, cma, nr_pages);
+		arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
+		dma_release_from_contiguous(NULL, cma, (int)nr_pages);
 		image->segment_cma[i] = NULL;
+		image->segment_cma_pages[i] = 0;
 	}
 
 }
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d8..67d6df9824e6 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -670,7 +670,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
 
 static int kexec_alloc_contig(struct kexec_buf *kbuf)
 {
-	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
+	size_t nr_pages = PFN_DOWN(kbuf->memsz);
 	unsigned long mem;
 	struct page *p;
 
@@ -756,14 +756,16 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
  */
 int kexec_add_buffer(struct kexec_buf *kbuf)
 {
+	unsigned long nr_segments = kbuf->image->nr_segments;
 	struct kexec_segment *ksegment;
+	size_t nr_cma_pages = 0;
 	int ret;
 
 	/* Currently adding segment this way is allowed only in file mode */
 	if (!kbuf->image->file_mode)
 		return -EINVAL;
 
-	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
+	if (nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -789,12 +791,15 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
 		return ret;
 
 	/* Found a suitable memory range */
-	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
+	ksegment = &kbuf->image->segment[nr_segments];
 	ksegment->kbuf = kbuf->buffer;
 	ksegment->bufsz = kbuf->bufsz;
 	ksegment->mem = kbuf->mem;
 	ksegment->memsz = kbuf->memsz;
-	kbuf->image->segment_cma[kbuf->image->nr_segments] = kbuf->cma;
+	kbuf->image->segment_cma[nr_segments] = kbuf->cma;
+	if (kbuf->cma)
+		nr_cma_pages = PFN_DOWN(kbuf->memsz);
+	kbuf->image->segment_cma_pages[nr_segments] = nr_cma_pages;
 	kbuf->image->nr_segments++;
 	return 0;
 }
-- 
2.34.1


