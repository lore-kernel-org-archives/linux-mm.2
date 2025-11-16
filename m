Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99CDCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1543B8E0019; Sun, 16 Nov 2025 13:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C3B8E0005; Sun, 16 Nov 2025 13:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042028E0019; Sun, 16 Nov 2025 13:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E27038E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C112140A58
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:26 +0000 (UTC)
X-FDA: 84117265092.05.A3BF23E
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91D6320014
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DFUDQCIp;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPlKpDo9gotjMa7idR5+EmYa4a/7gtSNuBeBwlWj2sc=;
	b=qu9l1LxnKN1UPFOCdl0Tn2tr3xU91/WGCDHM1w5lcYn1NhPqlWfGl4xhG+rojOgMJ/xYuF
	0GN4c7lfHTXWsxxuBgPsWZLkI3jhJTorxt862aiFy3HNxy+4LsFxsFh/Wo/muHAYgTDKPN
	2y3tD9CL5TQ5PdxcwC2evKscYZv/sEw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DFUDQCIp;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316744; a=rsa-sha256;
	cv=none;
	b=rv/fGg15ZaGqR9LmnszEm9Hb/kNZpmQZqrSQc8M1ceJe7qcyBMU7sMTDa9ZHoFR6m1+hHs
	0Z6gBi6vjhgnvAMat7QQ51ccydco9qFJHWGlV7u93DDIeIKxYhuMlnzYfU7QGy2JoUPld9
	HSJnXaZhHl4kigqcsmxx7uMChYvpeCc=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2ea2b9631so38586685a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316743; x=1763921543; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZPlKpDo9gotjMa7idR5+EmYa4a/7gtSNuBeBwlWj2sc=;
        b=DFUDQCIpWbfvCl/XIBOjaRdgTX2aW/eJh54pQngh02SauQlZQdqE9OdpAWb0vYu/FO
         oOKAlZIpcudtFqrFTbB7L2SMDQHyfPRePUGeVFLdvgcXUv/pU9bagaUrXUHkK9YNMFfW
         JG7VBdICEdA2mECxJj+H2gJcehtNbIuCLU0rVtTPF8KnsH3ddk2VKsNUuDhoj4M7pqHL
         +Bg7xRbKXKC/mkNwg3ixspP2s+kTx7DqOchKri1/rTxh0M+mM8MvE1vhxIJq3+zHEbuj
         7fDuxSH9Mh4A9GKkGRaalaxIwAbiB8ou59wlLeVxRRKXwt9eYz6+vxfPOJRdTlaSAB5n
         bucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316743; x=1763921543;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZPlKpDo9gotjMa7idR5+EmYa4a/7gtSNuBeBwlWj2sc=;
        b=RY7j4n5+BrRi6fCm6oLfzlEvw5Drtw9Gu9wddL3kA0jPdXwnse1wrTH17EuKmAwRvx
         AKP1Ig81Hy4GZQ63LWbHbJ3DG/67v3jgMBQiR44XoRAtl+RL3x2SGceSyvy+WZ/sTrct
         8iJ5zIkd/OqbnDksCVKOqH9WZdrhLrl4nDNDgI7mybo4sTfwfdpVyUCM9Mi3NyqE70AN
         E3xDqq0FkNpOVz1+x28lUXPzIXcVq9eMcBbjrLJ9stbkE74YLSwcETqBElgYLu33JMlO
         McI1pGUNmnRKeU5f8x42C8Hb9cg2eLH6iLUHw2qL5PrfF2K1o/c0/ajz+h/tG3ygTY/H
         twBw==
X-Gm-Message-State: AOJu0YzXdX6xEtIz1b65TE50eZrMOu7q/XWnFHGT2vDPmYzlNTfVX9c1
	70WvQrcgBZvdoGzKIL6RyfTZxs7oPFnpxMLLoCSkugFD3EyGAaYrR8cD
X-Gm-Gg: ASbGncuA8l0s2tUlrEYwO2kebw2YMwsxjurdtqK/8n8oxd+1zupA0ajN9lLyMF/D9ah
	NK8BJed2TFk8lbZfs572DRyG3F6sYEIIP4kYZJUnTh7Rx25Pru1SFfJGqzGcqoVJqo8rRksiosf
	FBbRx6bJ+5/3T2UFLmVUrOud9oOInInxXTSc3czKziE59QnLGrCN13yZjKrs7RWKwHdrUu7yLyI
	K4O0VFAI/IYxiPDxWksLNlgSAVcxPpVZ23pLn1B0njCzcW0V2O14xUSz2wKSMx0sAWC75BFqUFw
	ck8l38w/ZMGNUnBZAcaKVQHtKftZRU3/3qufZd+Jdbkl9fK1MGXlVbTAMfzwN08s29n/aDhkixt
	7LhLx2OatE2hJ9pqygQg0sLRccLNr7vFRg9taFE3991c9JmFtUdnjjo158dil1M/l01yPGTqI9D
	+ubYJXxwXUDRXgq26EBPjD3WcZCYyVxY3MRrM50roGsSypRjdSZN4GShlXH5iH72w=
X-Google-Smtp-Source: AGHT+IGkbTJU2oHCVXdPX8fPVA4HU5P92X5uQ8K3KICJSntE3qu2/JqofRMQqk1a6qpQAjGSkmVGEw==
X-Received: by 2002:a05:620a:284b:b0:8b1:ac18:acce with SMTP id af79cd13be357-8b2c31597bamr1131656285a.28.1763316743439;
        Sun, 16 Nov 2025 10:12:23 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:23 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:45 +0800
Subject: [PATCH v2 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-4-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=3125;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dC0xGmdnooLJYCyKsR/Xnrwvtqrz0t3aztFZKkG5Dw8=;
 b=pflnVKkaKIxmedAM1ePGW6UrPehZ5NknpGxCbuxr1z7BnS4l8okau0y9BWPAFi5zLB13h5p+a
 6iZq12lUcfHDIhzKgQQsEbjORT7j6GAx47J65++9w/LtL/+uj0NoWf9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91D6320014
X-Stat-Signature: x3oqqi11edj4bfurdysn1kmp3offxypd
X-Rspam-User: 
X-HE-Tag: 1763316744-969364
X-HE-Meta: U2FsdGVkX1+WD0sw0O2ROq/r07HsR0I23XhYPD45r1kqEwwHHbrcWi4dUntplL32fK0j/NVNs8/ewj7C52BGhTLRWbAS3za9U5mdpbOxk0rxMxxrBT/CVVdsVbFCYTYRi13ILqh0RYyLOM3pBBVs3y9q0wXFCgXGs/IYPoKEy4fq8JtJS0eqLrskvLTPGUtfnbtiXNa1Krasgfl/D+C/YMmC7YoLHFibNdEvc/BOVxCRVASYOSZv0MGabR7LwdLF2r5u2JrP74DEnym86piEAI6duJEu9d3Y6JnE9ZGU+v4v6iB3mM1pB8TDnX4PT98X0J1Ch7B2Jdkjf44lJFwjO08Rf5wJRkMlc077/0eo3O0hBrdyJvvqr2KMyuKZ6ntmgxBHm+XuO9H/9pXvr7s3BBMND7DLMrCbKnjYctd4pADFVtksTVsWrN4jX50vKYSyRWSydzr3iFpXbDfyzNyVd4DXMI9vHPRYgruU3qjBsuhc8+/ozcsKye7MVbXt4fiCeOPpaf8/eJXc4OeA81nDJe+1T6078z+rWggiqr6+HBDV2iCp7j70O8fz4b2mh7K5KZkChDxf9SNYrfEuw9D1FAYOgI3/wLusfCr20nBXHAEWuKhXVaKAxJuTYqegq1qIqR47Wp98LP98DL2YqU3+yv486cYytXPzfhXNjQEzpVWC9CBDYZ61qAaI4IRjy08Gpl7F1LdHcl0JzqEhFilvqNPNexExam6UCDJ+To4Okszq95vhDLKA7Nwl6ZJvhqB8WSuwl5PEmHl5Njm5xXmtUYdydBlE2h/SGWiswd5cr3xDj6Ry6Xk0TvMk5TprTartZBYMbKOpfwYuz9vA+DtsxlrCaWNKVPoB6BvcC8ysuQ8iuNKgH+7dq2E99JPZXFgspXiff/EF5YG7CHAHzn7NkbQPh+vU7TxWicWqmUGNvVqFwIRLZ/nV5BwjSpw2tbuQlxg0LQHeOiIyfPOCFvO
 YE6jq7P9
 fHE2fgIxdz5WjvK/3MJp5ji0PBzVnHF/Zj9e7TU2NRx1SkCsQNfkiToV9KsFc2WqhBb9etYJ2eTCoxzqXLVvFXGUU6I/95YwPFzSZFsjYdEJY+rMhB/AW3uY/Eeb/7QKyVT9fXwd3KI4goWHxui3AiFiKu04Ys6AgHtkz1EqFpD3fLDckqc1EI/rQnJtXMlphfrWuPETs/26SPUPEaNyp5tLPq3iohq6j3XSgz9yaO2xIBevvVXUqVcI068qwibY80oRYj8ZBg6n8YHP1R7ETkk7FEUevwiQG40re9QmzWYFUgDSnHBfjCoqYVXTTZuLLHlWBWIWlw5lwJdZ78UsOVYyUDz2+ho6A74Mdaktbao9Hlv4M3FC/WaVt5AKbvN600DcVIyPVQe3Tehc/EhUxBLepQ5wan5PUaDbfd3Brox2Vw7S+TaM4II3KZeFUHeUPb5C2yDvdF8azwWJV5mF3vn9+Pf5ezgSWSmI1HPoLNwknSf5mCLXYCKB+m2QMNSyG/RS0
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
index c95c36efc26a..806becd6bad5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4352,12 +4352,26 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
@@ -4928,7 +4942,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);

-- 
2.51.2


