Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C721C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BB36B00AA; Mon,  6 Jul 2026 04:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334436B00AC; Mon,  6 Jul 2026 04:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249AD6B00AD; Mon,  6 Jul 2026 04:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2E1E6B00AA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DE2C16855C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:19 +0000 (UTC)
X-FDA: 84957715038.17.B4FD3C3
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86A6518000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GSeDPd+d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNFWYR624JFwBh3ljKITvAxXKlpnZsp/crLLuga7jzU=;
	b=4Umroy5SrHIdLOaQTWWJsLVr+AQ+s0RqrCIloxqKuXp2ya/rxGrh5NTK66MgvABH6d1dAR
	oENXT1A8YRAC77IkSqbuiWQMaT8TBuT74E8ZxqXEnLb20zyCNXWSuKU11pqJkx3GscaudY
	fF2HbnZwibnvSqv2LfFLcsYAcYiQCW0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GSeDPd+d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327457;
	b=RONiA9/6McXCSuJrwQFMfXFK/chH8A8FqZr0ePC9nRgRedXzx9vAV71nHFy/lI/WaAorVM
	c0M0ZG2p1gjVMUXHPCAn8TFdiSjGdv+iBeHUo3yzU76bE38WwR2NhyuZSxiZSISzqjFRBO
	LUQNHUWkTL0ONVID4E3hpc4LqFzBX1M=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-382ef647e20so1668105a91.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327456; x=1783932256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNFWYR624JFwBh3ljKITvAxXKlpnZsp/crLLuga7jzU=;
        b=GSeDPd+dVGdP6vL3oyVDS0EcLc4bs3RKHg8cVi/mIew8IJjuVfl+Znxl7PT+n9q/C4
         ANE+QBU7JcIdOgrGOBlx/l6HbJ17xPlRFPhwXctZuKU2nmLjTnaVCbsFYyQxQq0rt/2G
         kOu6bSPhqocI6ombwbCpqxuOOu7Z0xGzPsmrtLY/14LLo2QBiViZQYGy6Ps77ux6HoFM
         fQqEO0I15YwoXWswxJeBH1x85WhgUneECtGNrcLRg188SA+wjxI0USYeznfMIzmDdmz+
         Bn5UIdz/fB38Cl+hsIDWjvAth0poz0FjDWkZLM1dXLiKfXhzlpDR/M9HNERs5mOdligJ
         dXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327456; x=1783932256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CNFWYR624JFwBh3ljKITvAxXKlpnZsp/crLLuga7jzU=;
        b=ctUJmkSmk9co9sxsoUCiaA9/oT8KjG1nW06ZBziPW1h0XSnluJMipjuQtkKUrbXVXw
         YHFJR12iwx/08FZXB+9Naseb4WI/oh6abYM0YRJ/QzCOH94VYMW+EsGQI4OFzWPJvv8D
         l5F3RG1D8MvRSh1F5RW72K508YlFpq1JlhFonkpJJakcW120EXdzYfanysSQp54mMAEf
         FM69z1uFSGWFvoBJVAd/EJ5y3efnDgSHcZNggbBIerrtXga/FfevC0rwYLvzD8E+8izu
         zvAUSotdW3gEb7/1zeNYTkoQeTRKZzygGoTpHm7ksYw2ZprAV4ThVWFlNf7mYrPYMJ/4
         RjPQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHgerOXBhNsZsGN7qGKxG58399kEoSapRiaE8+ftROOCswk2glzolZnEW9LvtCNVX1Sl5oROqbZQ==@kvack.org
X-Gm-Message-State: AOJu0YzAq3vWpChaA/rRnrDGu/aIlyT/8LLqXPhbagUAJJ+Tsp7zWvO7
	GBDAZmY32imYZQmgEw5R52ZZpLXnwMAtvdP6lNX15jRsaPTXmVFVvwfU
X-Gm-Gg: AfdE7cmb5Ff28iB8ANqDVQiD+CN7B2P8OmC17ZZZjYR0pGoG3WxA7XepoK1slWAw9IK
	RzeTw7kk9da9P5AQGow63mVINlTnuGNo1rEBATI0D35Yncc0HeQzUNYCPRnSpMb/Ga3gNYVjF4c
	cP1Q/fh1QzV6mhBy9UN/awk0Px3oc+7mb5t+aj41jT3wBTrWgIGaumJn0qDnJn8KKgxoPO/WkbS
	d4Rsld6c2nYA4zhZDOipL4b2rBB5naY8HIsUDYVbbBtdU0H95lYbn9I7kKFtcMzhGEB3auL3xKs
	X9ocXtIk0Gz/iIVnUXPYzq7Oy+9GiZQXbN0Wm4JDZ6fIEaiFImOK4uwePkhT1yhoOtbSiD4oWNa
	36TrGz3AOYWpW2OpnH4nnDIurTqOyKC3laQwZ706MPFqjgraKeuyQQBjUsWQ6UB/B7B35BBEZMq
	HJTOVMwECePogG9XrWqZVfDdlaOQSPjjdHs/U=
X-Received: by 2002:a17:90b:5790:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38280e98009mr8945925a91.14.1783327456426;
        Mon, 06 Jul 2026 01:44:16 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:44:15 -0700 (PDT)
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
	baohua@kernel.org,
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v5 5/6] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Mon,  6 Jul 2026 16:42:31 +0800
Message-Id: <20260706084232.177786-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86A6518000A
X-Stat-Signature: yzp8cm8u6o6m1p9zumuzrcerp1g5636q
X-HE-Tag: 1783327457-95485
X-HE-Meta: U2FsdGVkX19ah0SXh/+jaPDhthPnxdlnuWtpqsTbE+YNPZ6IjCvB4XpQwavWT2eUOvR2LBCwU+tE4F8Y9c+l2OIq/zMeTnvxzEC0XdG8qAavz4csz2uMo7PMuqRetl9hk0eqA2ytw4RFHVxw3IQe2pJug8PZ05/fRgHOHCjsRRk5qCxFnHWvvGZLi7LvvWG0kdXQu4zFGxfdy1BflVxFN9QUMICDgknxShcRVxIpTIXjuAucznl32MGTvJwPKpzilR1kNV1xWLSQu1W/+mplqWDtRERkU2ZQ4eFXloZYD8u0gpcL/5WrvohySWPs8bRYxuXLP3/cVK6CQ9Hu7KuCrPaRO3G37nS4kL2qAzI1PR7E7x2nKCkvRBx5ekb0f/hlf4SXumgyTTa1Qyy+I8J57N/RuQ7IbcXGvQOWpjRdiBR0kr4eXhzvMo8QtU4OZ5gbuwTu6npWcNM7F3IZk1kO4QZOMIvXjIvhwHvTfwodqV9TsucVXVo/yUdwNjFzfvLCerOfDWTZMR7KyZloY8V72WIFn8iygwWmQHEVjceH0LYOymuovP8Kz49PfnqC84OQgtuaIRDMWitkG3fmwWwoYEUGajNEigmma1AtfapI45EEW53BXD6fWD7pXxEYAKRVXx0AJMu3+VY6aeC8zKHpfrNdFOGGqxjngsNByP+GmrfNMqj5Eta1PVnXoS4g5Pa8TTv2W+AbvvV8U2WhDtloE8YqTGlewJXO9AYkgFPGJ5AWDfy2v+f13AggC3JgId7m4Sp2zgRMzbkWTkdr9if/Kzsxp8EMJnFtpAa1uCaUDQwqnBoD/o/mJR7U1zYLmpMVtlAA5B5wv4m3McghA75CuEj5J9Mg6yUponjQ/y1g0wzWc8TkUBaZALqUq+4hGd8bdL9jmKKclYuxt5WSglOS/bmTuBKoFqcM797smKbBDHOuUglCyBJqTCdYyTpNgdLEQdfMVzhl+gSaEXR54b/
 4PFGPHxb
 /N6R7ibwpBOashTrdl7GGgOkiLA2nKRTyheuomVN56ZuuRcNY0E4ZK9OpE5Kn9RhYxNGTmM9AZ8UqqKHrZAes/lTBkdeYt3k4HsgF89Eo3ppRrc3fsaeLnYsPQbbPP7qu0eMax6VyUrNEW9GMTYoyhHHTnarTn25h1G3bBgcwVLHaakMmlGg03OqOcW4dxYbLrkOUKlSE3ulpamoCvFF+QjhKGpoyG6yOfq+TEDgbLZMf9StRpaEXyVe23VHNVHhFxOqCLhz6z7wPT3FV8g0gWLEBPLQKAHFlfP5a387llSYz8xwDkXSEgmsJvhP89pxCfvxTIyIeV0PLUKxKgITF7ECHqj1Dbcuup8HadQQFHPwcwS0e0EF41Knq7NrBFn0L+5nsUPfYkoYpe+gRt99Vwa0RhK2Hkdhp1zHnEzDpQSf3LP+qZqsoMwh4v9jzilGjBzlFTdHyrFDecPlkPjsh0SN1ba2YmrHKKxVSg9BZByQn7jHjF9NTCivmFZdcK7SLwe1OChQoCyiAshdXmWplIpQnYLLN561zhXQCobVLeq1lj84hjEWddpH+9HfF3oG7AkYiwEQU9kErJw3+dzAMc0xOKw==
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


