Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E923BD2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42BE36B0098; Thu,  4 Dec 2025 14:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4040F6B00B6; Thu,  4 Dec 2025 14:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EE76B00B7; Thu,  4 Dec 2025 14:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF536B0098
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCC93567F0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:00 +0000 (UTC)
X-FDA: 84182778960.13.283E40E
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id E739A100009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZ32d+71;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
	b=ARzUnnWNXHG1lnjWftgOe97EQhBE6kpNufIP7ZuQtDLgpQOOMiagyqlTOeZIQOCvsRpFLY
	O84howa0ZtuKzHT4jtqi0MzAh0hLh0msg7K5BJhhWjxLkPJBxpC/qwi8a9aSdDkREPIfct
	0uaqikX0P39of1cqHdUKPvf1KTaRzxc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZ32d+71;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876599; a=rsa-sha256;
	cv=none;
	b=ZIMHf9KgIukFQzmQPANfm7I/aOR9Bm5H/P5nAoxRHoN3Hfd8XpNSrr3f7dLbbe2J43pZrY
	bQKXHlYL4wk+aSrEr5lgQMxNdI2Y84I9fuyZfJJpTYMzB7NJZTdy0wlKkdLpxlK9YVDLLu
	kctMKL4iaRxGVk3HZ5OLtKeEINp1RoY=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b9387df58cso2046366b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876598; x=1765481398; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
        b=KZ32d+71kuHehN8k41FPX6KZLCkbXKhMqawzFjU7LCb7u75qx3/bDBMu1aunoCIuQ7
         VWCXt1Cwrl+9hAHdkrI6DQ8wIlY4i50hkwMe42bsMBknrAWlI2SCecg5myr3V/Jr9akL
         baNVlP3tH8bp9Lfe/gxY3uQs3JxUhPXr7CP/NpA47ResTP2C25cRSr3YMb4IzNonSm1v
         lUb+hX/B7UltNHue4JLVKnTp2Srx+kXLnmMBe4xL/bVqmOxGCQzhuDfcyN3BHdUF8bUM
         TCt8SeSebqlo99ZaVWnL3ZL8ep/GejwxnU57tKSvTDG1NgCZXocKuBDS/leJBAizAYXf
         kU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876598; x=1765481398;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
        b=lB825a/dczr1/aSPXWzP+cUiQGNpA9Naj6i8WcKLKzf2uesvAT30gGfGv+EYfFIpER
         cRB0pBFZjm0O06gQu52HsUacMwub5+11YqAFT4Uy20BUGxwoLFdxrwqRyf//xQ0S8sLV
         fqmTzsdU+TBaPXSXYGFbiqZmFaMsISf9D/cs36JHmzxFpEv8CHGNFUUgRh+Ep0zM2giv
         kkBns06qBbaJVCTd8R9vZXcE+XH4GxCYzhsQ0smyDC9WUyShxNjSXN1JLZkH0XBomAWY
         QsXUE2lJ0DF9uVV3kQRO/Y8ZbKxiDWkWJ2SgV+hbalsyWux9QuiNBiqgxTJRWg5IfqDH
         hoSw==
X-Gm-Message-State: AOJu0YyDh+z/I93PNzueAtvWQu88qDJFpe9JZgMFPlA1qbBbwpzDVHYK
	0U24OgxynYwJW0SL4WdfnmBvRbrwLRaiFnqhvvtfxLKUxWTTkHAEMC2L
X-Gm-Gg: ASbGnct/nydw0j0hfSyPb/O02InYQDpTlJbUhYUk8PjgIq8Zb0lf3najVvtHmdtfLBB
	UQE4qVaz0x+3NxdyrQfcG8IFlLrr0BVai6TmUvntfOsHAp1sbix6VYib6UbMeMk6d3PVEO8TavK
	gjhmMR2Rao9iF6oIqCFoi17mStIBI6XjCBaFWJ7yRUyV2CuxKCNh/8YDCaRzAoU2OFHHJbshnjU
	lADlPJC2TWMRWyW29BrozGY+Yekd8TOODHNEE2bVbGvFWg2i1PGEZbQpMetEMoOPnkBKhi5eXkf
	nZasNiB3uMnp5sOocRMP8Cf4G5UmZNAXBdExJ7oa3l3+TwZVnaAcDYgckd3pmcNMhUyea5WA/nx
	0pJYJjc6Q6w3jmA5jTspgM8JcCit7k1MDvUhAAHSTkSsB0fxQrAsDrQCHgHJNarwvGt1n2Bmjkz
	tmpJWeq3YxFtxNqYzBcSs79kxoyuRqJ6SXR/o0AwS3VYoeTSUe
X-Google-Smtp-Source: AGHT+IGUfhOlcR84uG12iYI/zNuEssxSqcyplxyda4eDjMXB57WJfsD0fAS+avxYa45OMzapngs8TQ==
X-Received: by 2002:a05:6300:210f:b0:35e:fce6:46e7 with SMTP id adf61e73a8af0-36403764175mr5059537637.5.1764876597809;
        Thu, 04 Dec 2025 11:29:57 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:29:57 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:12 +0800
Subject: [PATCH v4 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-4-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=3125;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CI2m/8pPC1xTUXTV6AisxBkS+TKo9XryUKDABctQipg=;
 b=quttK8TYZdUR/zrStiXrO4jwsevsIWI+I1WKBXImPjLu5Sq7sQDCY06WCy3Is/O4LS0NkNspQ
 DZpdnsNeLpNCJ8dg65sILknSf2LjXHZKMF56JzYz1W3QZxKGGIMrW6G
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: E739A100009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1cbenqo3hw5u8fpfjjk5oubg1z4j8mjs
X-HE-Tag: 1764876598-940843
X-HE-Meta: U2FsdGVkX19nKYxF6N0pw/yNTM4OPKy0laC0osCl/NAtUv1noACRMisZ/xb0qRJa0fi6CeAgjK2WXCGmgrTer/DK6A9dlWAFvgHKjREz4Y2sFiRHcU3z3QmvBZafkNY69U9hKFbiLNXQvQzqlsivGIBe8pXIouWhs9ocbjcu2eTVF8JCdPhjPpeTrYcmJ/qymWNPK4UKcE4AxppYhYhsfYrGEQoUJ7Qv5vXPLXY25XIOMhJNLlCuU9OwvJ/6Q+cfzBZWVizwAWhqZrPrR8ML3/d4vTxDqoDyPHfZVz+YwC3Sucat5TZ+vcjuIWZyQDg9TVH4u0vNpRbBXCJuWscbphT8avZPTvHwfzpuqXwa0d4aDx88pE+0F+YEJI09BqWRaEm93UeoyOdFo/6yNL1QLf65HenLPXnZ4eHaP80SGEtohPEII+J9/xOvGUrf2wPDkNs9MLJkko2RKwBQisPibp1jezuDyR4H4UlfgY70DdLV/hd5lqo68yI7faN3dwBg3x0KSTu99i7ecWsW/TDI6+JHe8Byij7t7UQCC4TwzxHuZvMCCoVJG+TdE60+JQb16Gbg27NMd2klplD3KxcR87b3iLnkdddaug/jIfjRqJBD4Whfer+dCHBSt11xBgqGkCvV97UFYDD5zNuPd8CcGPID2b2bBVx/0GpR+zi4FSIMTRDPEnqMEZcr6b02sRyjFtfraXk8bntd/f1Xtf86u2lurfV4svRCzD1dxgZLbbqPUAROJOZrSGeclJtEA1ZfteMLEL5TIRbOldPnf5aGjBsQHz6pF4BOVfvOzHITMc1QrGIq/AWA62qX74//ZjOfjPV7S2a3FFn1FAx6nr6Qm6BR2sFpMg6swnKmqy1aDH4IgJ8xD2HY5POtITjO0HOjpOwQsbwHDg5OSMfNz/KTpRZpwfV3taU2uUzJ+CaOlsO76P9LMld6ir0YqQAjVXz2AQGwi0Oap8tgeaWMvIr
 cXdU+OPp
 9b5i+5uo+NLSwTm6bowL1MqnlQ7dtjK/4O5Y9bDzuI3Ty5+PLqaCDOThFwMNXIOf9yyb1ZReTXgiiIFFqMRoKFT9JoyVjMccc55RgFfyYXldhU1Wy+JKETuZnXiW5AWMVghmdCEKp19l5ZRgLC5Jx9r2+eIGsu802iasWHDH/G85NEN6OcX6qas2sMBdRLDInKRUp2V38Zp2CRlCiCOHo3HYWX6PkGrdmLTc/ZgoYZPwKE0ETPSz0PxrOAzBI0xwNBPsfDrIOLgx9xKJgWfcmhulgI9RUGRJRK+pXfNkGCyNYCM9sLOhRbZhGBAB++3xNips/pYcPF7SElklnLNfXBdrtrZ+xRi+p3wTmVReoI+linr0AUtx2P8QY3Iqm6urIJeDGnJiAs0nVJpQH21Y7sYwr9DLMy7QRxSbQcmVztkBBLW/7SCbX+e6v4vkPeVIi8T83tGG4RLsxltTgGngtg20nZDW+Gu3Gd6H2fPa1VusvXFH0gnVyjaHySHvr5bOjEh+t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
effect is that a folio may stay in swap cache for a longer time due to
lazy freeing (vm_swap_full()). This can help save some CPU / IO if folios
are being swapped out very frequently right after swapin, hence improving
the performance. But the long pinning of swap slots also increases the
fragmentation rate of the swap device significantly, and currently,
all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
causes the backing memory to be pinned, increasing the memory pressure.

So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices after
swapin finishes. Swap cache has served its role as a synchronization
layer to prevent any parallel swap-in from wasting CPU or memory
allocation, and the redundant IO is not a major concern for
SWP_SYNCHRONOUS_IO devices.

Worth noting, without this patch, this series so far can provide a ~30%
performance gain for certain workloads like MySQL or kernel compilation,
but causes significant regression or OOM when under extreme global
pressure. With this patch, we still have a nice performance gain for
most workloads, and without introducing any observable regressions. This
is a hint that further optimization can be done based on the new unified
swapin with swap cache, but for now, just keep the behaviour consistent
with before.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 41b690eb8c00..9fb2032772f2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4354,12 +4354,26 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	return 0;
 }
 
-static inline bool should_try_to_free_swap(struct folio *folio,
+/*
+ * Check if we should call folio_free_swap to free the swap cache.
+ * folio_free_swap only frees the swap cache to release the slot if swap
+ * count is zero, so we don't need to check the swap count here.
+ */
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
 					   struct vm_area_struct *vma,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
 		return false;
+	/*
+	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * cache can help save some IO or memory overhead, but these devices
+	 * are fast, and meanwhile, swap cache pinning the slot deferring the
+	 * release of metadata or fragmentation is a more critical issue.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4931,7 +4945,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);

-- 
2.52.0


