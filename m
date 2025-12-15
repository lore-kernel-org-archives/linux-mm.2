Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EFCD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC706B0006; Mon, 15 Dec 2025 00:31:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD6F6B0007; Mon, 15 Dec 2025 00:31:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C566B0008; Mon, 15 Dec 2025 00:31:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76E0B6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:31:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C95A8B550
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:31:10 +0000 (UTC)
X-FDA: 84220581900.14.BDEAE3A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55B03A000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:31:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FcB8PaS3;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765776668; a=rsa-sha256;
	cv=none;
	b=jbBIEXPcGwQVHbAolzEMmEvP90UNfTzLsLqlVCyCesSrpof74JOAen3o7tlzkHyDeh1Rk8
	MJf/1c8VP/zk7K490/c6VBSdqKSNcuqg+jgKWWDl8Xk6bH8Bj/+tcTsanhkvzTxxmnG7W2
	/mn8+tAOBjOazkIv07ZDp3f9C+FjbO4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FcB8PaS3;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765776668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uz3AkyAC19O+S8FUO5AbqCgspWmgP9i0gngDDNAJrGk=;
	b=MZh3WIpV1/jRwrYAPhQTkgk1IGrcpUuXlpvphuDKRgsnHRVgcgavv6ayk6+DSLIHZI7teJ
	qtMUjYqzVS0OKhJNdhr9clSa1sYxNJ5gDqPZnQzLZcw8e7CGPxeqn6hFHBEI2T5A31XbXn
	oeiOSOCW26+nqCiFOSSRhOhQA1DDIzs=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so3026211b3a.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765776667; x=1766381467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uz3AkyAC19O+S8FUO5AbqCgspWmgP9i0gngDDNAJrGk=;
        b=FcB8PaS3kbmZssjC6/jknHrUS3zL9GieGCcwYatrzavUq/MMMPC/k3nBtEmLwpPxkB
         VMc8U1iAnRikBBvNwRMO3Hd6898vftO4yTvgttANYxqxl7q3HTUANif3d4uh7WvMKoug
         FumCXNWQSIzb0iyeuNK3I+i9gn6jRTzvJtMjlqWuVmHK2s1R1QvofyvZcq6dRpgBCEFK
         mde3laVtSaoZE45p9cU5POP52CU+E3Tpo2jZoFKDGSVBR5qCI4OSGVeou4mC5jYJl5zQ
         9Mu2BecijVuw5mA5wGGcR5OMyOTkEylEyJqEWiA/NwU0bnyxtZLTRTFlFkdKYLKiEG/2
         mlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765776667; x=1766381467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uz3AkyAC19O+S8FUO5AbqCgspWmgP9i0gngDDNAJrGk=;
        b=hW7AMFLbQLIPQwrf7a8RO1Ohf6X/yZVUKf3EvMz+lCqCnBepXQJ9cw0hWxecBd6Myl
         cbU2qKl314/regoUzRrKgt/MTF8vYMbe3zbp6tIS9tNs4vG+KPtcb821sxF2YlkY5tFC
         ONrWK6jbjz6xTnK2FJkZjvI5UjAzme0DOzq1ob8A8yhlcfykCe61e5AteZ+wMlvc4WaS
         soRB5YaBtiUCd3smHlAOQUscKJEYzDQBjR+oG8nBd7CXNq8zqekBlYurSGcf7bLJ9Lk1
         cakSZjKtAKmiCMp2daMdvSyP0A/8OdDDC+L5LzUt+sQ06Ua0w79GuzffUojr3WGGwaOF
         mXWA==
X-Forwarded-Encrypted: i=1; AJvYcCUpGXEcjJPQ9nCefslYOBlDTzU+wbLM6Ej0cRK1AI6ZJZH2ZbEP3RVvYsiLgqXI1e0iWIEshb/ncw==@kvack.org
X-Gm-Message-State: AOJu0YxjY+qRoz7Xu2mL03O0LOvG+SjXELut7ZSzRX+0YL3hcD6WyaYf
	ZwQb9INaB/6NndLc9P58DyZ770kf9ARSYLZkAnO785gFoLbyzBxa6//m
X-Gm-Gg: AY/fxX5XM761uXseLrr9PiWF10iDqo4oOZueAMb4RFLuj9xLdkweiFzqB1o8JTvkqkt
	64w5gstHKi18kQggRDHNQC5l2RCKAgDAhXPEy6usyDFwl9UoLUjZ6dMp71rBS/ws/sekJAqMVKg
	1AZouaKdDwR+tJi2Ysu9RqySA/ZlgDTmgcUI2sC6slNAom6Jg3vrsKyxQgrvoHZv5lQr4TShd6O
	zSYLmF8lZO3Ws/btAEE8dgWQnL3n+1OPNLhyDyyxCVYnKsEzi3qLNcWdqsgndNfNtsODSVSYqdu
	KQZpZCPRuOrCmGAPp3coNZiriZ+rdhmxMdfNrydZ1loMCLE66zxkvzAGX328/mKTw40jSD7j6wU
	7Oqh4DfrAPbK/RWyTGKy3z/eDQZKh5vxpCPzGoU/Yi7q2lJUwYeFWEIEtYgp8AOTLvkigDULwwI
	dHMY14LTsLWwdSwpVrRS+jUelgbw==
X-Google-Smtp-Source: AGHT+IHNaawrkiaB8tEzN2LJvPo55x1qDp7wzj9Mb1MNnfFeFzZwkDr8l2UABw6Bq3fG7Z2E49LeWQ==
X-Received: by 2002:a05:6a00:a381:b0:7e8:4433:8fa1 with SMTP id d2e1a72fcca58-7f6694aa660mr7586764b3a.41.1765776666944;
        Sun, 14 Dec 2025 21:31:06 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c509cb51sm11409151b3a.54.2025.12.14.21.31.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Dec 2025 21:31:06 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	jstultz@google.com,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>
Subject: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
Date: Mon, 15 Dec 2025 13:30:50 +0800
Message-Id: <20251215053050.11599-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B03A000E
X-Rspamd-Server: rspam04
X-Stat-Signature: mnhzrsghbwth9txtefj7hxwn6twf7n6r
X-HE-Tag: 1765776668-439028
X-HE-Meta: U2FsdGVkX1/K81zJj91LbkwQ+QjJnxIMuGofHNyTFVplwoEPrUzSaxHos9ssFNmxmBp3+Hsjk7+56fJndoQsQoV+J8IEmjRkq7oD34ADJJeAkrK8+ttOQLfwZn9Kj+okCGibRz7tJLuYku9vmW7/Tny0XKtaHjDOMk3OxxtM2SNJoNDPMgrYb3aR8IgzdSAkuCiRyeF6EYi84xb/o1PxxvX5HfXhv5vyZZondLkGfsFHuBdK1MLaGrtuwWOGanfNOsYxyrIw+agZ/xh+HObYqQ/YnlMe3lW16Z025/u1CAVNX93Dpl2C+eWt+ZoWkXbb10SNONmluINTLfPRPPAbjyLJ4nPm1bD8LIOSqjd5pbDOFd5hJm52s7ngyUi2fTOpmZQ6pkqYrFA/eNAhbaZXyfuNEF5246Fpk3V/XNEFRTp58Ky6qLQ2Zjwdq0RwdS4ZaRSWYpnWoRHEiTcskByYPAogMpC3ETokcuvUsUBBWjoID/31ZPXcXUb8CjafSZPskBiyYof7WlTIjzNi6LnFT1jvTLTnC+ZED7gWrH7zgEZ32u7viJaxXxRmnjbGotudQnwAHDT9GWnnjo+kVr/PUIdH4D+oBPMbu7yh4yXQo/nfcVuNNt2V8b4k4WY0C6C4cSubY9HKYg3fie6bYnF3qjJargWn+9RnusKTj3GZGOPxhtBTT0Gh7EKB3FSBNXF7AdFdpfReGyaXEOPQKf5QKNOvNHDh6UAYLTmz6ZtctV9sSXVCLD0YVoGpRRlHzASkoD22Fg3Enr3qd2yKhWFKP79R3IHbeeYXvqLD1o5uIC70qd47ZHwYc1opzhfesKVQmzZcYvHfIyFU5eAYsRoCyvL4PA0zugjxqFSTN2/gSGSlMVMUw9vdocY2GgQOEAiLsXxHyAYDTC8F0YjhMPOHCQ4ZsUxaGjujgOpwOcf8dIMeSrFXZv+wdNpZAA5yqteMpr4bxNGKCMfY2RouIl4
 p4b5KE6E
 RaJFbu3ZL0CEQ0+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

In many cases, the pages passed to vmap() may include high-order
pages allocated with __GFP_COMP flags. For example, the systemheap
often allocates pages in descending order: order 8, then 4, then 0.
Currently, vmap() iterates over every page individually—even pages
inside a high-order block are handled one by one.

This patch detects high-order pages and maps them as a single
contiguous block whenever possible.

An alternative would be to implement a new API, vmap_sg(), but that
change seems to be large in scope.

When vmapping a 128MB dma-buf using the systemheap, this patch
makes system_heap_do_vmap() roughly 17× faster.

W/ patch:
[   10.404769] system_heap_do_vmap took 2494000 ns
[   12.525921] system_heap_do_vmap took 2467008 ns
[   14.517348] system_heap_do_vmap took 2471008 ns
[   16.593406] system_heap_do_vmap took 2444000 ns
[   19.501341] system_heap_do_vmap took 2489008 ns

W/o patch:
[    7.413756] system_heap_do_vmap took 42626000 ns
[    9.425610] system_heap_do_vmap took 42500992 ns
[   11.810898] system_heap_do_vmap took 42215008 ns
[   14.336790] system_heap_do_vmap took 42134992 ns
[   16.373890] system_heap_do_vmap took 42750000 ns

Cc: David Hildenbrand <david@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: John Stultz <jstultz@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 * diff with rfc:
 Many code refinements based on David's suggestions, thanks!
 Refine comment and changelog according to Uladzislau, thanks!
 rfc link:
 https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/

 mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..8d577767a9e5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int stride, unsigned int max_steps, unsigned int idx)
+{
+	int nr_pages = 1;
+
+	/*
+	 * Currently, batching is only supported in vmap_pages_range
+	 * when page_shift == PAGE_SHIFT.
+	 */
+	if (stride != 1)
+		return 0;
+
+	nr_pages = compound_nr(pages[idx]);
+	if (nr_pages == 1)
+		return 0;
+	if (max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+
 /*
  * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
  * flush caches.
@@ -655,23 +678,33 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned int stride;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
+	/*
+	 * For vmap(), users may allocate pages from high orders down to
+	 * order 0, while always using PAGE_SHIFT as the page_shift.
+	 * We first check whether the initial page is a compound page. If so,
+	 * there may be an opportunity to batch multiple pages together.
+	 */
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
+			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
+	stride = 1U << (page_shift - PAGE_SHIFT);
+	for (i = 0; i < nr; ) {
+		int err, order;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+		order = get_vmap_batch_order(pages, stride, nr - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << (page_shift + order)),
 					page_to_phys(pages[i]), prot,
-					page_shift);
+					page_shift + order);
 		if (err)
 			return err;
 
-		addr += 1UL << page_shift;
+		addr += 1UL  << (page_shift + order);
+		i += 1U << (order + page_shift - PAGE_SHIFT);
 	}
 
 	return 0;
-- 
2.39.3 (Apple Git-146)


