Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCD4C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0396B00B2; Wed, 15 Jul 2026 09:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED286B00B0; Wed, 15 Jul 2026 09:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49B56B00B4; Wed, 15 Jul 2026 09:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A087B6B00B0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7983A1A016A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:59 +0000 (UTC)
X-FDA: 84990889998.09.62BF9C7
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id A150E180010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YhpBIxfC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93J8dJ31kBsJOKH3R1rbCLn8YwyTsJsj4AeCzglR+bg=;
	b=pMq2qRENl+F5Z6OBc8vLMBeMe6wcCixieGV1YJA7AyxGF2ev7dQ2kC1iC6rsl/3tPkHrAo
	ghyurFvjkOBd8XHHo510sr5KptiuJN6nEEMo3b9vV1hbk5wlPJJM/NadBqHpxRZhrbErUn
	0o+V0CWZ42uKNNCQYtdawBxLHh/Ja9Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YhpBIxfC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117337;
	b=kNfxN7hoQE3aVIYNLwE7S7027D+6UeaMTzHdHaX9WzABbMGywXvpZizRXASrNTBQJqaN/S
	zFPgYNw+dg77KiwKvE5P7DaubcPWl3z6NUNU7YoAfa6DO3qkhftZQZXEmWOAjA0uCLQGRj
	UEPAvv14+WSloFE+0Djl6zs8KSOUWXA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cee9b74ee1so19310345ad.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117336; x=1784722136; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=93J8dJ31kBsJOKH3R1rbCLn8YwyTsJsj4AeCzglR+bg=;
        b=YhpBIxfCFTwdOg7Ro7gizjIouUfjZkomvoZKh7PZDbsTEJm87uX40HCPtqryTouvcy
         TlJEjYcWEGmU8u7UTWBWSjc5jzxskWCeXNoS3mn5VuU6XFs1Y5HLhVoBZvKuQQAVefvH
         b853U9qSrhd6U5rhRYIIhRlrisFY1I4G8HoU7LGjwOq6IcHBHBlAhlZT9Xi+hTjUYVXE
         eLuReSYkUGhqOnZH+0iLLBotelaqErE/VV94JYVZep1BqQYz0YNHTZZk+wYopMvujSfA
         SEmI+MVQxmSlBLba/HEEYkfqjG4yKZKH+jCporHJPPirCH2Z5QgVhv9YimxmsibsSvfJ
         uUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117336; x=1784722136;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=93J8dJ31kBsJOKH3R1rbCLn8YwyTsJsj4AeCzglR+bg=;
        b=YafM2Y2H/J+XngV6WaYuyltlOcVeM1NrrsCahJslerFiyHB9F+RPPX6HnU4snbTxc1
         SOPDz/Fvs/FFUkI1da9vDy/pixocKk7CYrOECa9ZDNBNXGN6G5tHVsiws4VyuhFC6sy+
         0ZDEVe69yHP+1+Lq5yjFM04OAeA8ZUcoJrGwyVz5bqmsZiuhC5XVSbnA981TmRIDB2oZ
         RgaZjPEPlWfOJAMhbD1r/q1IImC3uVpHeKuaWZQY2yGWYmGoksPiPni+90NvMkzX+guf
         RqxHMxZLS0OvDs76aswDoDvnT2A8n0bDDE2uQqjdk15AsBGIDZnAvffYIN/pdum2nfL7
         Vtww==
X-Forwarded-Encrypted: i=1; AHgh+Rpq4SD97ez0/65zGWw+IPd4YxRvs0ebfPYjJ9DcM/owv5fhfdh4/Dzy2eWfAHoOx99AD6348MOV3w==@kvack.org
X-Gm-Message-State: AOJu0YxB9EPMQJqwoa1ZkLK+yZ95Gdhg81h+OQxeOdnrunumKI3Oaiep
	UimpxLfRjtBQmswkN+1wkmMUIkm2ClKpR7SK9C6Pd7swLyTAH39bDl4d
X-Gm-Gg: AfdE7ckS/4LmCy4vLI4YeUwJHwuuiGPklkeJlPwFgBmhbnXNfQW3vJMNKMNCzCsohy5
	R2o5YktSa8/JKNPwaQ+EGRmjLKxY/UtVun0+h7ayWBOISC450XxkezhECHQufarwqX5s3jDCe8Y
	uBHvAouiytOH7c9+h7gxOJnwakNGFIhzPlVCynIgI0xWAy1nzk2KU2PN8WpS3jWM3F3FccU19Pc
	qwd8bG1Mcw01E12pQtg8tMFyRr+SLSrCZ+63M4V58nRk/sHvyEtWFYX7MBAJrl5Wj6BCB4ijLMF
	x3CKKJ06bqrXzhDU64LiKuPVw6vnbHO4CyGFsqWoy4oNy8BKeUbns6FIj2/WIGWGUOynwaY6avF
	XMwZQPx2+gzUiYkkH8cKKucmiCNZ5Rr954BTsnvo/JChy971OAIiUXh1T4lsmdPzKcN9qWRk7eh
	tJk+hLJ4Y78TBsO0f2SognOTtnvsoWg3pMEww=
X-Received: by 2002:a17:902:f686:b0:2ca:3df2:919a with SMTP id d9443c01a7336-2cf03dca19fmr22554225ad.33.1784117336405;
        Wed, 15 Jul 2026 05:08:56 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:56 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 6/7] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Wed, 15 Jul 2026 20:08:12 +0800
Message-Id: <20260715120813.3609949-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A150E180010
X-Stat-Signature: rn5jp6zf9b67jse3gqee9s4rscccs386
X-HE-Tag: 1784117337-105181
X-HE-Meta: U2FsdGVkX19TtTI+OvkRXafv2nIJprSvOe2SUC/geuH5+GWMo1Sr4tX5F6hNKP4H45MLkvOlV6lB0YLXbwjqr8LgAYMzxB49j6F+W1FGzd3S8gxVhQanQh6siIPM85JjInQpbI7T4tTXA3okrkgtwQ5rieoknVKQB3x/rafGldp/mw7N0Zi2cVUW21V2RWvLzdd20T8dRUL3ts24w4AlShKWFN1FVqjYdpynTvE8nMZ7FLZvxW7feQRvCK3pUEoVZNIQTdI+qmjLonprZABs0nq+yl4cfZ/x9aMFYbLeJKmeTublHPT2GTYwzDLaCh/C6IGW+NReyCQXPZ+UYQl0cE2rKbXhb7wlztm5+m2/XfGkb0ABBykuDgKbBYlytNFiI1gtuAW02A0Z896wHptoU3RvydJz6BXmaBG3KWfGR5YOW6u/S1AmGseABFROAUCvk2jRzo3zP4P0ITXqSHPsHJ1crBljubBHezAWzG3qsycRnSZVKENKHgU+YKaPKavW/ZZjTzkVtmqRtGz+mGwqaiTE1NA7qguzR9GvktvzXG+ZZ9kj0RBOiqLJ6rRgpfxl/F6bZ3z3c39RycAtJW+f4yn3kGKEvGCcMQ+Wmfd7c+Zb9AmdvefyP8MAA9bsiiqMyD0sNQGUJaNrEYfdats8b2++B9964zScspxczPC6jhY3tdm7RusaaAfgtwhcuek9Ej8cwqc9yLBHev+9vUEctkwP1LEhEq1k3/N4xXuZCoo6XPED+zOnx4Dn21emSsOKkNH5joZqDoVhgvhXuiRy6Z+83k8nSvnadSpWm/xfcri5z/ICqS0EaEdbD5+jlehzmnePCW3iMaQ9iwo+6BzGU5+njOMTA6JYCJ4UXKtNXBrCGDzp4mhOIYkaHFS3nii/tzB8oPT6dp8c0SkR86Oon05LCHKzWW5bz0c+GJGOtOlGxNtpF173nHQs9kMxSsL3rk/xF+Mu1fHUgxZ28Oi
 ScFyzFnv
 iXKY0rOzv4cnd3xwhgYLZNE6GiI84eN8LHywY5defxs/FzeDCXnfHJ+X7zotjCrKJyshRz7dv/dWhVtGvQBgo8URrTsmyEzwn2hkp/FTur0lWn5/vnAF7K0OqPhlrKkI3FNZUVzirfR/074WW3hOBNHdNkv8+XnwRvF5q/xjaDq6ll2cDVgqAqyYiuyMyiByGsS5kuhmMoKEAcVSMM1KCtKt+HXJI2SdRvnxddAYrTr+BFOPZHM0bRfJIgAkw8PaiTIqBVHMvUPxNMRVW9NIT1dNRPcGfnb6fiVzoxC77WJ6c1aJIl+RXA5JNMe8+o4mRJpIMdIpLxwpfXJoQr6xwIIyVKbzxKVCQBDpeIEuUhbAzj6xyQnHi0tI3tx2CamdBjZTbViCwNjomXP91x4b1aWxFv7uXlwPvuyMHnZIRae3tkVQtX3n3JZm9PV3Y/+p3XslVbYiaB5gyaphK1Qe5VviJ25X1cSdE/KX9JJmW330g3Z1L6cpAxV6fZDiutp33huoeI0T5tMmEi6jhLdB4TqX9wGxx6vHpZcjtE2tLln+BoDoyLOYY5NMIIzDRbg+3lu9jtLA960RfzVd2qaLn8TVQDQ==
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a1e025120e9df..92f9cd5e9def5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3557,6 +3557,84 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 	return arch_vmap_pte_supported_shift(size);
 }

+static inline int get_vmap_batch_order(struct page **pages,
+		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+{
+	unsigned long pfn;
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
+	pfn = page_to_pfn(pages[idx]);
+
+	/* Limit order by pfn alignment */
+	if (pfn > 0)
+		order = min_t(int, order, __ffs(pfn));
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
+					     PAGE_SHIFT, GFP_KERNEL);
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
@@ -3600,8 +3678,8 @@ void *vmap(struct page **pages, unsigned int count,
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


