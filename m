Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96B5CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5B26B0095; Thu, 14 May 2026 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D126B0096; Thu, 14 May 2026 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C196B0098; Thu, 14 May 2026 05:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09F6F6B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:42:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC7D1C016F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:06 +0000 (UTC)
X-FDA: 84765534252.14.E712352
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3A0240009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S5O86SiC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751724; a=rsa-sha256;
	cv=none;
	b=ItMMs17bizNbJxHEOpzx7ycweMJ3dz3wgvUUPaiJOf28hdD3OCbNm6WS//3hm7m48gB4B+
	WHnynAcwmqFbwr5lIEpKQ2Af7OWyCHz3+Cyzj2skudZWvlfYZJlwnFH87WAMJdldZP0wc2
	Q/pgEHN8gKPCK4TJeSFvHQxkFJEXF0A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S5O86SiC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ug5dkzDgJ2Vn9RO/6uwBXc0123ip/xCq3qTJ4G4/vnU=;
	b=rE72GtZMJ7g1NZyl1YUgvTzL1ZeUZOagT3PoNa0uDmJqmNjjrY9G8vl5WkS5PZoUKlwHpD
	bQwoX0tlMuUZWdfYfj/iyHBZy+RT4rdcGwaalqWa2+y/+v2wj3WjXQIkEyGdc2Qpmn6cVv
	FQCuiAaSxGPw/P9gCkqvNlx/VbDU2Fs=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c80167f56cdso3250660a12.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751724; x=1779356524; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ug5dkzDgJ2Vn9RO/6uwBXc0123ip/xCq3qTJ4G4/vnU=;
        b=S5O86SiC2tdT+IFWpNOyYoQYuKsqDoXbhWvvHGlB/QBB0okcQrfr4CZPDCoyjTK1ZI
         ldu3hynjPODEnK24vjfeDBAHx881Iy03Q8fniBSZYm09MmWK0fNfM81ObIpyEkw38IBX
         g0cqb/j8NZWqe/8Dq2caERlVpgNaubH+zR0PUFZTDjCj76OntFDr8qccRpumzIi2UE66
         /AajyWO9ezlGKY/roxeUbTyFuWZy+as1+0dEd/VAv8Lf/1aZZiu922yYwmNnv0FfiKKn
         FtfwjtgnjyTxmRslZQ7/8VSlARvAxWIYRZZ2lrpFn+bDXbIyj5HriFkkddTgoARhz3u+
         BIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751724; x=1779356524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ug5dkzDgJ2Vn9RO/6uwBXc0123ip/xCq3qTJ4G4/vnU=;
        b=IM1oSvOh+zj0ulrUcXwHJ3vUHPHpLnceRzvvW6W9xYmpJLhpUCfUU/rnDFDj+Al0+b
         9J4Udo4d8pYKYLw88jUu4/DhvwijXwqtgHG2alC4lquwZ7hAsGMtBv47ZGy0v7k5LZhy
         VWNmbX6XIsIEp7c9V7mqJQJNGkAi+S3nuFzr4uEKeHeo3Cc86e1py33/B79dsb6yjltW
         9JxNl5zKZ2igkWIlSo1h0B9R13x6KIEByFgfd1Zpu0jY4oK5cwHxaAZ/NaNT5xfb5clp
         QEzhmowmfPUsOdXcJU4+EpC/qa+F/no3dUJmWXAenzLOIQytxKW/+a8O4H9iDD9KjH2E
         axMA==
X-Gm-Message-State: AOJu0YxlTM6IoUYzNoJOXhqch24KZjZ7TCOio728C2qv73gNM9HuqTUu
	4VkdWQAjyRl9gdlW21uHWoJA+fzuRz0upOEK0HehwVxNLDKZAO/Rmgt38Cc/cGE9joI=
X-Gm-Gg: Acq92OGajKDAOa8/MbWhXNEA/4raBBGSWfniCFpBsuS5HQ2PF84y59eE8tscuZ+hd/p
	OjR+uDNpJfTywLvSTOsp3qrqZLqRwYZSW6j7+AWow0HNgdYxqSQq2ag8g/E+o9GvdFd+h6X4fEg
	CjfO7jUZ3KhRYvDjvKOnZ6zsjt4A5EyIeNcrN7QSLi41/mAaKzPtsq+bgDLnNYm959Cfb7T1xZ8
	VV9rfPC3bR/iaqtiQuNVWlYWiHBKqZN8ibtc1OLVv+Py108kMkLC+PuCrjb7ug0oqbyEuG5eNny
	ppA66ZKjUdJC15cPubxLKcBE3DYHBLk4zSJVcq+9aGaqD5S6jlO3ntXv1/WQOL1/WnHx8mUCeKW
	cCVQbAIk/7ZlRyXUDFIc0YzoVNoStqm64rZ2isV2ZN8Y12DAHC6GMIQQb+JX5ihUKq7RocWpK1X
	ZNdqBEAwYyPtMX24SbOxn2eQcGM/Uiw22w9xHSKS+lE04TMw==
X-Received: by 2002:a05:6a20:3c8e:b0:39b:da83:91aa with SMTP id adf61e73a8af0-3afb2342a48mr7860002637.51.1778751723547;
        Thu, 14 May 2026 02:42:03 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:42:03 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 5/7] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Thu, 14 May 2026 17:41:06 +0800
Message-Id: <20260514094108.2016201-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yz4dg9rjoik4m6rodkjfrxdyqwtksxow
X-Rspam-User: 
X-Rspamd-Queue-Id: D3A0240009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778751724-880227
X-HE-Meta: U2FsdGVkX19LdLGsjho5zEPa8tSMddVhKOgRRJ6bCR8+MPqBO1xCM30hinbYJMQfmf7ZSyQ1YOSn4K1VLDh1Moeo2wx9cromNAX5uVt7WjvW9/rOjYQMmrekjd1E/Il0tRZPGb3hL4yB5G7klIZN41ySQLpv4o/DKEJX3Jt9EC9eije9QLwggj3SMYoAnje6uy4ILY5j7/aeCcPKrZAXqoB7X/L2FVnrMo2IO/mNTOzOB9AQ3DhX4i+Z1HeZLSgDLgqynQIOVZFIOXWDwtN+o5klldCFfsP1X3u4tm3Ezih9TdfZRQL3xowfsjK6K6yanoY+Xe4kY3EkNGmFENTyYCAToyP/TUIHWx8VmqOoD7VatKQCtzUd+OJ+GPAWBkZvgstGZqeMjaVRXUSvbDBbFWsAiRt4A9RUrgCwWH+1+hol5yyqbwbKFln2BOpEP359MrXW/ZkqSuMIpOrp3FFf28QcQ7f6zJSeugbelIe0V3h6TE5MZSSBuZSryF4NT88b3JotLT72tLe1m04SFGetg+0InrM83AHOOKV6qRKmFLaLiWTUKDjn4mvDh5/ZwByVQiHtPD/n6D/KQ7JHC4oIMeFm1uNijyAE9imVgJDWJPaIK4Re7uEV/Ln5tKjwIVjZRALJcR+4xqJSiKSQE1btdiW85YnsF71F3ZBf7a6VQC8PkYmKnpOFAdI7vl3Z5atbwWILUjo9EV12/sJ79d1zMZJkGkFqVVKiZ589vXFvVHxR9Qt0iglaOATNA4mqGGdW0hm82E2KYC8FI0UL2sNzOtPtTa0OLm5d0W3Hk0Hx8pmTuiMy0FEIJswboJ/ZSi24xM1YvOh9W52OBqgL3kcjJPNKAoJUPVycSFt4A/Zaj00bN33f0k7PGdFhf7NYmuaPqTIv4hTYClxEqqG8RNNHEYbDPgo3aaeL3KgMleU8YSMXItQ6GqtVmyGtIHqCkDFmLC0QHN+DRlmIqSBDRkS
 AHZfRwj8
 +VZw3YSiECBgM4Rsc5j4H92uHgfSku05V9fNl2NtLMEiDe6+N8v1wfF0sXY0fUZnjAhY0/LdXIn9O6XEf1WfkB/MsVVw6jDSoXyGH6QlQG5xJZq6FiPHiGY+ONHLbcFKa/mtuvh7Dzm44dcsWQfgHsIqlt8sOHW9SqiHH5cYhbVmTOploCqMev15ZVEGoZ58ouE2OzVpFZ8/ftiIIOcWT3bRooQ4vTEivMnX5dizb9OhE9OT4zZBVGyZu2NweDLZc0ZLgegFhWx3ZRVhwxpgZDJ/11w8FmUj+OOuwoxajRpXtnkn4TsLrwGIVuTNRZO7N2WRXaEk155cVM21ilP1aC8UlFYJJdpLq1ktbSZt2g+fUXLrbsTtLsErj0IDwwnzgz5Xb9y/cdmJvvug5aLlUsXe0UL9BdS8uY4O77/WfkhtNnyPIn/qu95dgo3vNaw6z4RLmK2SPdbhuMk58e84vrlIKm6DAHdidhkCVzD5tYKq38ZJPmHU6TsFt1oj7DBdqBvtLqRLF/IULOL9Ldxg95ZgIszDhEQrkkdgATbDtl7f/w08yTiIYyJYOskF2DR/wI8MnVGEE5BxmTfynOiZlnEuQ6c60ldd9C2hx+X4/WPPwhYa1NCbQlNnWy2UFEGJryXc4zL4wTTYdfcK6ZJWg3pn+efABaGJgxG3gWsz4USfX5RE=
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

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 516d40650..c30a7673e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3520,6 +3520,77 @@ void vunmap(const void *addr)
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
+static int __vmap_huge(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long map_addr = addr;
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
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3563,8 +3634,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (__vmap_huge(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


