Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E1AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C75C6B009E; Thu,  9 Jul 2026 03:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478196B009F; Thu,  9 Jul 2026 03:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DF16B00A0; Thu,  9 Jul 2026 03:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA716B009E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:39:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD25EC21F9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:05 +0000 (UTC)
X-FDA: 84968437050.28.9059890
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id B82FDC0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kr3Rl/yX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8Oygze3XzRb05aYksCWsf/9oFhF4JAfcwkhh/Ls9Y4=;
	b=Jl0CNc5828Yhf87YtQ1p+dDsvsE7Af3ydn/KXHM3KolLTU+eahh6+qmVyoDt6SdGuPKwUn
	VTkcxdtjz2uJQuuoGiRjdG/x/PftOA5sh/EGJDmBfA0LYLQ1ZUbdTtsSjm+uTnPAbakfam
	wMPPo7HGTllV+KJ8kLt5sTa1a6tmluM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kr3Rl/yX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582743;
	b=zuDCqF4zN5vJ78i9xE1ScEDGow6wB27g62ZJVGMgfA2PXEdANAzjvAYW+ytPFhNZ0TglQz
	VvulKhUwW8GNlKKz3VfpNKHsNHCntsz8CntSvUYmKFdqPIJavGuqMKkmTZOMqMDXa/hz5p
	PSFn4mxMUt+owXGnzZ8GfTUAVYIU4eU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c9bd2f8bf7so8880005ad.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582743; x=1784187543; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X8Oygze3XzRb05aYksCWsf/9oFhF4JAfcwkhh/Ls9Y4=;
        b=Kr3Rl/yXjUAwJLrX3Tb38C+tHe4KY051d+jztgOdglznpNldTupK+ODkhBo/9dJnqi
         cIsvsMNhdH4GGpBmB/iVqM1oXVe5CSj8c0/1P4oMEJhOuOmU77B3t6rphtM8Vb7FyCUM
         +EXtXsIMujgbE1LBdftLQx6MLWgrj7XJYSZz0KEPtqn6E9ejfn4U3xJuk7Ykm0fKsM7F
         K54w51A1mxk2cYCq/ysvjKrOtRyXqRavzyh0pU7yATZDpvpxJc+FlT+JtaKN/NikUfcC
         LqarOsD9pnZfnr4uosWYIDoDYAEerqQLqNJiFAevwGOadBKEf2310z9xxQ7knd+iFQoX
         MdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582743; x=1784187543;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8Oygze3XzRb05aYksCWsf/9oFhF4JAfcwkhh/Ls9Y4=;
        b=KIY0QnUGImM4lxvK4eCsV1JtVsq7CQWYp7fnd0VOm+Rz3o8ZeFiHC5oBVi5bqs8ZOt
         yMoq3EuXJwAsifHPd7igHTEmc3p5DZLz7oodBImvuBbNbCqklGKQQPmf0CtA0XZkBOln
         EElCxTJcMTDmFAZ9vnpuqVleMlaoyBXfBnbE+DU4Sc7dpjLlXjFL59NSDrLAIHBID/2C
         8/NqGgNj+PnG1Mk4aZg1cNoTpc5UvSmpKrgEcctUInZzSj48AfHn9Z/01VP5DdnTc5FS
         PW2HLzCantlrD2aM4uk+7f2xKX8Cc5LzttHpM6Wi9wwE/lBakAW3uDVPb87eoZmU6Dny
         ayBA==
X-Forwarded-Encrypted: i=1; AHgh+Rpux0tMraTeOZrrIM3aW2VlKJUg6/I1OMAeP/pg/XQX6WZZ2sK8+TS52/cpnY2RzSuynBc+BxON6w==@kvack.org
X-Gm-Message-State: AOJu0YybpBnJXaYtcvn5oAsYJWI6r6YKQgSqif7FDmaIkXxOdM66TipW
	xJJh2mhkO/n1CXTuW8757Fhtu80rSsdtDZG20SiInWPhi2abRIBporAm
X-Gm-Gg: AfdE7cnZs7PmyCkGGVVhRII6Joj7bOP5Jg6CAtwy9D02Q3Cu3pxubkAg/s/XzXrGPSm
	SFPdviVurbbUbd6jE4PEwWt1HOGUUvlDCY80DgS0hCDOnpq6/kmec7y/yPY0sZrnssTShkZz8xH
	h/FguGGXO5vz14Kk1smBtvvMOQmWAFPR+P8jT1v5FkNDUAciCwE8v9elYkoLCCO931zAtaZ/zg3
	km16gx8qtlC3PCwxLJtuZNK0wuSLuXa1RDLtUALGkIpl/Seb3XSsMu8MG9/xxzFjHmiT5Qgs1Kc
	74qKQWFQx/P05/2WoOYcTO5ASqsTTN/nV2J4hfMxqMqe6vzW2JziV06x/m6ESoMI1r05ynVJJvo
	XwVlIlKRtW7MHht8O76KtcP7aOqLqjdqmTDUrq/xaPchTajuItqc64Z431VtAWow14IRaU/WIrY
	7FoWzZ5iOHZlqUSuA2QkXKRMiTn8nZzYzzTV2wOwgDqwLTmQ==
X-Received: by 2002:a05:6300:2189:b0:3bf:98d3:f185 with SMTP id adf61e73a8af0-3c0d67a2905mr1940598637.14.1783582742678;
        Thu, 09 Jul 2026 00:39:02 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:39:02 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v6 5/6] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Thu,  9 Jul 2026 15:38:22 +0800
Message-Id: <20260709073823.6643-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B82FDC0006
X-Stat-Signature: 69pg4sr7wygmr1xu4qyof8esu38i9zmq
X-Rspam-User: 
X-HE-Tag: 1783582743-680928
X-HE-Meta: U2FsdGVkX18c36L7b73tSZjxkqA/Z6edGbDxvLhTfN6UjsP0OKkR9uw2QbDgQ3azXeIxiRRo/5YHm9Qwh17ShsAN88HrDqVEMHXA1IF4iYPUFml6SqhmDsTo81eO01kfuwMxcjiy8hqCBAigd4fT4srORDIxPMRL/IE6QBbz9FSe0KR93y2nE0f4s0QUFd2oB2UHcH8w1iUn+5E5zBvsji7qu5TGnnn7/Zfw/YIhwPbrWTCt298yru3sl7zRM0SlINPMzVR+ZVNjBRfGhkQR8rsDqn6csLZ2+AXKuuIhBN3KXXh9b9maQDyBrB+/A83zOTStUcFDnq/47s0Zm/pHVnNK8YN518I3hGuuyH1lCF3DpMPGL/bhkuvFGscNpmZGSEY4fYnlaAfIiUSqe6JLBFp4MFduUyvpfGcirSap1sPSLM/YJtY+MYO/0E9Vq36kH/Vrdd0qPQvY4Rrcss53/uVeCxnnM6u1+CA7O+vYkWSDd6qgaIrHic0DjsQKNtNd88KubzhDHrijyvbOv3fDy1KTbLJc+mIi25eoCNDMq2G9HUG8kBKYJWd8CE1W5d50tGVq2gM8BuoiQtSCwoUgP1iqnT65IPauszHBeUXdiA6WNiy5AI2xYi+ubyFItTGDCWL4hq3SHcGcWK45oM5lmTr6A9SxuNuO/h9sZbe6WvelwjvGBp138grwY+bqPGIKrgIlxOBa9nhhMI7vwaJc7FH7LA1XMU0dKLtVjdmqMhgdlsH4fH5Hc5QbE2HBxR8NDTpjIfkK6HrVOn/kns+VV+yKnoXV3YoZH7Gp/WSzzj8xXPq9UnsFHbAyO0IwkGH+9RfPWX5IoQXzWWZZZqUEtxYbyGy8Unxeo4Km9bb9ileKCbIn22gNMTGUQ3KOH+tr2Nx/pKwXkcAw8n0RE407K98LP4NhI6fIcyswPnHRKIdsZtJ9tlzJ+/GF1O2nLQYQ07TW1uy6qeozK0FvhQW
 u4ZSrISa
 uhvLhFtizHKvCVU4DZMxDWiyh85f/DLUmwL6qMiNXcOTb0zDXMQKjWSz0cCJ1acKniFGPUfpClMXu/OYF5lstNcZ1LLpL9oxwila0hiAJT0Y7oGpvogo3AHhS2qgCxVvKIgsCd59yv6P9kkB83loMrTihZSytUCVeAbac/fiH9DrWFgBJS1C078gYw+33qM9jwb62gqmDB37Sw41cQkvZ4+QIkv7oXLpiS3dQjrBJbud3EVi6GCjvQ5hw3zdyZ7Hzc1nXVGsoRPJMeYV6jiRosJ+1+JBj7Bzd7/jFo6LzX5kz38QSZdF1QX+mkVoR8dBxGroXyi8Jf4Cbje1KKP1sjqK1sHnz5iwABU9UQ/fd/RvlAyjtpw0j1tBUgro/0RLZU4i7DlrXkjx3y6FR6p4z3+8StauwVCxHgoAIf65xCkassn4djdoQlptHrgPLjIFoEegz3dV2txDLXcGQ0u/WrqU4TAqdaA2KHoRfkPJ9v6voxUUAiTj9SeDQNp8EkhKfDTpEf3Nx4lHXRPGI7PY5YCXrjROPFBY0z7GcRDd+CsVoEGvuM/V41+nTHAw5LPZ10pj8hRCUh9QsAADrK7/2XSIkoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d2a4d649af549..db0492151ad08 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3543,6 +3543,89 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
+static inline int get_vmap_batch_order(struct page **pages,
+		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+
+	/* Limit order by pfn alignment */
+	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long map_addr = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						PAGE_SHIFT, GFP_KERNEL);
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_batch_order(pages, prot, count - i, i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
+					prot, pages + idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			map_addr = batch_end;
+			idx = i;
+		}
+
+		/*
+		 * Once small pages are encountered, the remaining pages
+		 * are likely small as well.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (map_addr < end)
+		err = vmap_pages_range_noflush_walk(map_addr, end,
+				prot, pages + idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3586,8 +3669,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


