Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EB9C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E8A6B00E7; Wed, 26 Aug 2026 05:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFA26B00E8; Wed, 26 Aug 2026 05:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515C76B00E9; Wed, 26 Aug 2026 05:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24B636B00E7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64973C02DC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:21 +0000 (UTC)
X-FDA: 85142887242.06.F6BA3AC
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id CCC49180006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PPmdK3kJ;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6U6CPPAT7oq2s1cbcD6b76t+xbaZUc0osrokVU5xyX0=;
	b=jsAJar0mAgudPzrjpqENVbHjp58464FstmLxe+8Gw3ak4PO301lq4gReSkC0a/vp2hQbYU
	yP5YNWdxPNaIM2yIN43Nl776Mw+mi436x6X7foamnerrEMN2r68qBRD2Er+JCN28Vwiw38
	O2pXNlh7MEqm62D9CfUBqLeUl5eRIQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736319;
	b=VYo55rwTRU3KdJA7LftIf7sF8nYI8aSJgGK1bZTgXFdxO7wiydraRg1xzYKdGifMsJh12F
	cXG4fVqoorBwZhaWgSPyK9gIpPLfe9Yt/Pki2Daysv4w1sXHypuJc6sF84NZjtvMEyXn+/
	fFQ/O2OXHzx8VKcplwJiDiYkDChBNmA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PPmdK3kJ;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6U6CPPAT7oq2s1cbcD6b76t+xbaZUc0osrokVU5xyX0=;
	b=PPmdK3kJEMBO9dLIkD+9RHj9K6ETQ7E3tZgwSwg33u+8Apv5S6QInyvdcPqW0uOeefZfFNifs
	avI2H1N0SMkKMKxRlaBr3B6rKK1J201kwoZ5XBWxgys2j83mYzT2hMzLuCu5ieeFkde+xyuGeWc
	2zoCN5E9bV1d+v7S1XueOJc=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrd1dDrznTVd;
	Wed, 26 Aug 2026 17:14:57 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A4F4340586;
	Wed, 26 Aug 2026 17:25:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:09 +0800
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
Subject: [PATCH v3 01/17] kexec: Record allocated CMA pages to fix release size mismatch
Date: Wed, 26 Aug 2026 17:25:25 +0800
Message-ID: <20260826092541.3905933-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: ghy7iy1j1y94wduqt459wqnt51hh5qfa
X-Rspamd-Queue-Id: CCC49180006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787736318-601375
X-HE-Meta: U2FsdGVkX18TFAqpzCstFU2aWoB3cCr75EJd9J0IAwAG1t/T8D0OvbQ0c5ywH3YSsiKMGsMtCLrX9HRQ+HsrXCqSLVcC3+GXN1cBD2PQwR7BYze/gGp+5QB+yux0gWQaN7tTQp//NcT7ueuWgHjCDuIbD0p8k7JZ8umlRKf6dn4wNUpY7gXVQQGQyzk12cx3GSgAetXI1A6fOni8AvllbGahij1ies7OfIf7abswz0ANbTwAoRsQtDEUJlHmDfp5oIu79AGd1mnPmFUXuFpboV0i22q7gYISIEpA29YMzAQaL3My7lr7Hx3HaO9NtL6z7P06HCnJDOmTpXP1yiF/mRDOYtkslnmVEyH/rBie5TCrciBajKP+ga2FA8ScRYOTUhUP9spSwSiBWhPUCYY3FQ5R/r6XJecaLm1Il8JouReouDUWo5qHLHKqUc5QUyUYtE5TjtVZh75Q4DGEtpIjallyCX2JenYFEp+rb9EH+YVgbccdQZwOP3sffA5WUduOkYWhHxeftUbo2HbyJ3v4RHDhk2KxD63bIJK9Ew12nYwgxkESmzelYi5JL623eLuXIFWcY8qRfWdeKW4Ig7A1SD68JqMPR9ARcLaEg3p+bDAmfenH9JSLvouVsR1u64IO3CloMurDYdFKb+51P2lXsj0FvwTAUQyuIIEkRuc3P6tlrCabEMW6vfSvqv4wmpVZ693mKA4UwxwL9lTaD6DeiVls6CGAmPkJhxzNRzJS+omhm2Hq/ev21J5EIKd0UkZ4JRCnYa8L5GGqYTdQ513P4wgN0LBHJehsYHRjyuDodXeQMpriO6un4FLntzz/CPW4GsjtFTbCuiW4Kmlt4Mt9x6BWyr/VvwItR6bdnBvu/jpSL8fxY7yMPTAodiLIoEOC5dwrRZ2HI0KzcgIq1ubXUq6jhaIqIg6YBr+L2BjUHgKc14YbSf4N6uxnysw7TionEq7rogRnH/moIspuYZ4
 cvkL8MjT
 NRbacMlpLjNtCbuIE1mA9PmsTY4W5ixtpnfwwc/6/sKKUqN/3Ka2kH7eZLDC16qHE7LrMzIRJwNyKFKWwXjn1TglasvruPXtsXFMWioSHUm1BO4x9x2UmAgbEWVIEVSSiKSHgCziMW/Dm2sfNDBoGlMtl/wsqrZglKc1fHB3VnZnsLmdKXvpexTtDkN2n/M/ey2pfyUGswQVT+DqSF6/qUvEazUDWl8JREcTdplNdI9WmrLmw4em8ObeDOjjRckuyixCnsKj0a5QiOt6EXCbV/u7ZdfJxteq+p+ttuFCxZSc1BpduF+Y0in2SbdSZ9aeji5JbxUmskneOIrkadl6pykYtL7HJtLerG7Cksu0ryyN7FYrwzTwJv4+MQdgmyLGwBjdYFrZtZHVC5rus2OyZU7rGvtHQphIXzml3AQ/Bwah/AYp8NQB8PWYNeyvbrsfdZwO8+aeaFbToBMzy6iVBMtglesPBU7XPPvnbvcQJoQxgIA3OZzE1xkwVsE7s9vy5dKErrxMlRkZ84kotlE4zU7djqz4LP03nWS/6Eqzdef2G3bWACvX++HUO7VuiQa+QbQI9yZLteJPakNl9wze/TkiDHDxbDiK//T95wYUKMjGobUGNYcqgap2HeQ==
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
 kernel/kexec_core.c   |  3 ++-
 kernel/kexec_file.c   | 16 ++++++++++++----
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0af8ae4fdd08..83c296c0eb6c 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -349,6 +349,7 @@ struct kimage {
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
 	struct page *segment_cma[KEXEC_SEGMENT_MAX];
+	unsigned int segment_cma_pages[KEXEC_SEGMENT_MAX];
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..611b15bb1369 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -560,7 +560,7 @@ static void kimage_free_cma(struct kimage *image)
 
 	for (i = 0; i < image->nr_segments; i++) {
 		struct page *cma = image->segment_cma[i];
-		u32 nr_pages = image->segment[i].memsz >> PAGE_SHIFT;
+		unsigned int nr_pages = image->segment_cma_pages[i];
 
 		if (!cma)
 			continue;
@@ -568,6 +568,7 @@ static void kimage_free_cma(struct kimage *image)
 		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
 		dma_release_from_contiguous(NULL, cma, nr_pages);
 		image->segment_cma[i] = NULL;
+		image->segment_cma_pages[i] = 0;
 	}
 
 }
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d8..bfae3fee7f2f 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -670,7 +670,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
 
 static int kexec_alloc_contig(struct kexec_buf *kbuf)
 {
-	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
+	size_t nr_pages = PFN_DOWN(kbuf->memsz);
 	unsigned long mem;
 	struct page *p;
 
@@ -756,6 +756,8 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
  */
 int kexec_add_buffer(struct kexec_buf *kbuf)
 {
+	unsigned long nr_segments = kbuf->image->nr_segments;
+	size_t nr_pages;
 	struct kexec_segment *ksegment;
 	int ret;
 
@@ -763,7 +765,7 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
 	if (!kbuf->image->file_mode)
 		return -EINVAL;
 
-	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
+	if (nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -789,12 +791,18 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
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
+	if (kbuf->cma) {
+		nr_pages = (unsigned int)(PFN_DOWN(kbuf->memsz));
+		kbuf->image->segment_cma_pages[nr_segments] = nr_pages;
+	} else {
+		kbuf->image->segment_cma_pages[nr_segments] = 0;
+	}
 	kbuf->image->nr_segments++;
 	return 0;
 }
-- 
2.34.1


