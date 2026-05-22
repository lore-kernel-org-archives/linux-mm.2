Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCC3CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9FF6B009F; Fri, 22 May 2026 01:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB14A6B00A0; Fri, 22 May 2026 01:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7DE6B00A1; Fri, 22 May 2026 01:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAC266B009F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40508C2B75
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:19 +0000 (UTC)
X-FDA: 84793935198.08.30CFCB5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6533B4000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U8Sre8CO;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4nDVPNvDGaaEdnxQatYVMpRpD4mqtQtLPJNe5AMUKI=;
	b=kFd8OMUggj52Rz9pzgty02YSWhrb2grmNtR+8mhpDQlBY5t1JG19fhStEq1ETZmZZLIcZJ
	9UCuIu9a6Rl50VSzP1au5pzjfT8adgu0xKr682/kVL1PPi9y6vR6Crw9rLhdPTJI2U5HaI
	vE6l/PnZlY5rBrmh6JYkfiEvFWUpEl8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U8Sre8CO;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427937; a=rsa-sha256;
	cv=none;
	b=4xxypsIpbJ4wfrWtLIksv95PdJ7mnxeaJu/nSCWgAO79Z5B47mhUulNIGTUwZXKc8w0JPQ
	qox2D6Pqq3WcFtJgWNSPL84D9gSvTP6pofwvf/vlrH5F+6A3O0h6Ypm3iypOuaD5FMECLF
	LbQcVE8uBXwT+SD3iGODlfC8lTpVrs8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba21d32776so50575115ad.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427936; x=1780032736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4nDVPNvDGaaEdnxQatYVMpRpD4mqtQtLPJNe5AMUKI=;
        b=U8Sre8CORjtM8b5hDe/B5BahobKkOwAUg9tQNxOI7LEKh+2VKa90pszGMKOrRzXuy1
         TFPE5A8b96U3zYMkLEpbBdAVMvzOJvXmAlz7cGQqfxtqwM+4MORuHmAFp3CWVdDYJj89
         DDLeNE32jv7UYElQ9HhcjqcO1Vte+5deZufwgfFoqOVXeqVHiJnNUejnjOEJ+9aVVxFr
         zwzFQVWFcoaIid5MbkDDFJOUHP6ML61PHPcAhiZaiMrHH0x7TBnR2vBf8wcbcbq3+xdP
         kboFDyY+pxseJrU97VGY1sx1vYr4daaZFFN7yA4VjQbG0uTOnIV0dLuVz8Ov1E1rlhJi
         8yvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427936; x=1780032736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G4nDVPNvDGaaEdnxQatYVMpRpD4mqtQtLPJNe5AMUKI=;
        b=h0hJXv5zDe40GkLjE/pcZLYpANcecuC3MbbLos8gre7A5yQgk1nS/bmoP/zz3oKxXE
         75ihWdyS5G2vpUXR0BPQwcatmCNrgtmBOzmhQB/e2A++eP8BV+Dyx3AQVY+PJr6jG/pD
         JPZxQGMmGrzN1OjrrYyTPv26dcUsbUimdFLE1JKHhHZ0z1kRJDjdqt/TTJtLq/bsBwgO
         c/qHMLpx3YYl/bZZhhfFkMxOygzTXMavgRnvl1cpZ20vUrrUjAjpTWS2+iML05rfpadb
         CzUMuRvYAHz2QcHOuETEPKBLcO8rq45kW1Vkn9suSQRHVcAkbL3AyZ3bcmC0vWcnKaR8
         /rbA==
X-Gm-Message-State: AOJu0YxA2y+dnaXIGAmXGuhEgzN6T/FpCgQpcGv5HkeRFEiRfzH+RBy6
	5Zi24ApD6slpvPn+LfuPAgixidZf2AqPDXrDcypihgg8QoXjorT3RqiTSzwkndee
X-Gm-Gg: Acq92OEO/GuTlNZkbSKJPEyPi/agwcx85oUoPqcS7yGyJv9TTQtxpemSccVfDnXb0LR
	TAO7yB+n+Aruzvgv2Im56KVVj/Tsh6Un24wbJkEKGh9LbeLji7/uG2Q3+jQzgLB4l656WB+mraC
	zWMBlJyDxR4Dt0Dmvmp6oiazjQSkXrLzPd3m1MRRROvAWOQOY5yO32RRHa8XkHaSFOBm/CGksVR
	1MpHRTqMjwKKTdlbxUcb9X5laOlHTQwhLUV2huE5yqW7AcWNf5ZJRMg7eq0trCCL3RJbgHfMVQj
	TlItGjuFzmxfdvzH4cPzz6mR0KtlOXPfl4es2K52AgchOHnyxACXSTaFaZB5Utn2ADnq2r52nku
	kd672HxFyPQxDPXKhLX5rB6e3rrBUx08TGNz7keEEqWsF13rAl4WL+yHIea6MBoxDnzdP7F5Ul2
	MWDISBziVwRvC3x/FmGKHT0OXN8Hz7UvSQ3XgS2sapmT0lAQK5dShlMAvti9m4PA==
X-Received: by 2002:a17:903:2c04:b0:2b4:61cc:37a8 with SMTP id d9443c01a7336-2beb037a5ebmr22161795ad.17.1779427936265;
        Thu, 21 May 2026 22:32:16 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:32:15 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com
Subject: [PATCH v3 5/6] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Fri, 22 May 2026 13:31:45 +0800
Message-Id: <20260522053146.83209-6-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hhhxcuhq1cowh58iuggbssrko3awdnwx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6533B4000E
X-HE-Tag: 1779427937-832293
X-HE-Meta: U2FsdGVkX1/BNjOR7yK75xomfwHa5hJgTp2c5ZIpKlKha/QH0iv2f4Of1OZ3jC1sKY7qLcspxGLS9W/YF3cg4NjDUxnUCwITZvZ8a+nwv3F3qXvc4xp81oOPGjrO6tO7ZNsu7LpUOsq4+FrzBgDv1ECw3CNMkD4YYpmU60JZJ/akLQZ8L7dnl45H5Ud3LTNN3V14Ectgp5g5bR1PtfejGmCXt5QGsI3Cc0qvWDv4+wBiu8ydqOxL0GbRxDkQe0ua4JAyj84mhBpx7nPDHo/SjwQkPpgJI9cej3pKajJew5A4i43Fg9Jx6ZbzRT4FqIMiZBpAw6djvp1DbG6dbdoa5QWUEHoPJcnItHLDXSGW7W3xoJLMEhyW1qCWuwmRl+IOyhvsIsLEwOSVu+Nf7nBy8eRbuQ1Cw65K7SKaeSDCDQjcnKmTfc16W20xNr9b7OTCnF9YRrbfp8dZIACC3lAEo7mgALTcozWjGHLkdj13F0b2ZaViuIS8BFgYWQAoZk4T+8FILbwqtoESevsE4+N6osnBAdcwjWgkLVmySqeJlB54eLNbxH5cd/tDDfCW7XCfWtR6Cma0qWrrO6JvUoxGUfW16JnNzUtpg7BhGxV3xROukMTBKP6SGnvK2dOn0GIxgx5X+XsblFehzbmoUesFMURwdLvQ11wgRIZzfP73fXpTf4OjlGP4+ZOCZ8QLSOX6lG1yIxdrca3o+c48SHcixwM9ZhvwMBf3c7U8TUQCnGXu3E+Qcx5I2LMQGMl4zOr2yn6yAS5crx5iWRy4SuVn5E/+YlCxlagqFrRICyOhYHB192ivUH9+BgT7vZhj5U8odNolmeCVHwY7loX6Fhhv8KlhxVKFkVpyZd9lB8tKRH/5cGI+lcY22C1rp0/SsnjBfZ7Rad2L+/XHqRIFl5Cq1pLZHoBQ/Z0Rz35GrFKxnYVgHucZAhIgHXYhWiQnWL9gn9yPIVSxd6850B7Hu7L
 mEN65l8Z
 XM/OiafGBvNpG+i2PohfwnYkZbnaJsRa6baaXtVQQ1IJgbi/BEw5iv69PRGTHEN47RK265WJpLiQ9KJA7fUcwyvcm4GEkoBmF2Grd89qctG6UkYuPjY1D4tC/sNA9Pb8RE+N1OAglMhuK/E2byJibMoJtRigXdOUUGnMT6cIrH1CRDcuHRaiTLNxHIPPB+1JSFCB01cDyzTnf5DkVFy70rfPqRJvL4cI6edprts0k9r+n6ITelI1plYCROp/V8VAcN2qkoiPk63AWYRZbDbN0WxaDZliH3N0b+jDMgc+0ozFcPvHxsPBvbgfOYGAQBKXXsQPbJYJ/tkpmSTh5OhqoK/LYLpi9Yl2KGWxQ3mSovhPLqpQ4hywphEKuZOPYl2ZJoE6owqPD4pWM9Jw4F5Hv0Eh8gz30hGF+gw+mZGAGnDP7NHIJcKEl1jjUeRxGsAwMyUaz9WoOk7f97swsPyT/EJzf2b7U5ysQ7F3q3D4Yu7qZ1e2nJvLSaTE8rVS9xx8QScn3eYSBwVkzP0HK3vD4kBC/0T+9bbGjANpHRRfvdSve7OXhLpDi3zHANEWKb/s9rNyiKHZNVYLhB0pNIiaBLsqrdXOxj+odZIAHlkxTXlDLcaYgrE+X4SQeiA==
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
whenever possible. The first page's pfn must be aligned to the
mapping order for the batched mapping to be used.

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
 mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index deb764abc0571..50642246f4d40 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3542,6 +3542,84 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
+			ioremap_max_page_shift == PAGE_SHIFT)
+		return 0;
+
+	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
+	if (nr_contig < 2)
+		return 0;
+
+	order = fls(nr_contig) - 1;
+
+	if (arch_vmap_pte_supported_shift(PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	/* Ensure the first page's pfn is aligned to the order */
+	if (!IS_ALIGNED(page_to_pfn(pages[idx]), 1 << order))
+		return 0;
+
+	return order;
+}
+
+static int vmap_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long start = addr, map_addr = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						PAGE_SHIFT, GFP_KERNEL);
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_batch_order(pages, count - i, i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(map_addr, addr,
+					prot, pages + idx,
+					min(prev_shift, PMD_SHIFT));
+			if (err)
+				goto out;
+			prev_shift = shift;
+			map_addr = addr;
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
+		addr += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (map_addr < end)
+		err = vmap_pages_range_noflush_walk(map_addr, end,
+				prot, pages + idx, min(prev_shift, PMD_SHIFT));
+
+out:
+	flush_cache_vmap(start, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3585,8 +3663,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_batched(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


