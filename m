Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2E5CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FB46B002F; Mon, 24 Nov 2025 14:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400146B0030; Mon, 24 Nov 2025 14:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF626B0031; Mon, 24 Nov 2025 14:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 196E76B002F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD9B059577
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:00 +0000 (UTC)
X-FDA: 84146455680.02.836C34F
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8DE0140013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=agtBRGn+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011758; a=rsa-sha256;
	cv=none;
	b=w49aOQpGRpWmO7oD59RIHD+IftQDl+p+3HzPW4uTKk1YDf1wB2+KxVBK9uI7re19f601+7
	8BLj48Cpx+COor+6tFMs5CBt/7jQ+f/oY3Y/vhSOGv6WBwK9JNIdywYph3qE/QNhznuXvv
	xXmigLMn1CjhIvdrxffUyYJEEAXsQDg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=agtBRGn+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
	b=knzVU3uFrO/6QsIibu1wFwQxSsLuBYm8T/1TWYfehpnmrCyTYoCwdzS8U8ipew8iRhwB4c
	ZdM+8ziHFMTJ97tlsDz1jMecMFN6l82NFMQW5oTU4Hx0BQ5PsNYnD2Nokxmd8CGJoV4/FX
	QgVv7xK+SPAGuNhNv1dS6R7q91Vpq9U=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso2885697b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011757; x=1764616557; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
        b=agtBRGn+hnz1iM7E5pjafja46iqDwROx8AitAqCg9Ulucz2kcdr2dscoGWsVdxRjDZ
         fceDb3TQMoqMaCYenDO4WiEnWPgn2H6HNqtKqksbkvdzHepshrvZwrk8NeX1EvB3xQPz
         k5vwApMwcU0/GW31ZWYG1Y8L6H5wschrEAyo5UdTJ6ZqTKu7uZgc4E/6I27otkhHY2F4
         QkB5i4RIrMd5yurKcwds0LrImzJBlqoC6vEcK9V6pEBAw+j97NZfg72yCmSbA881wnP0
         l9a7WsvPVHX990nJKTgteY0j9Spf38NwWQzpjE5z1X6vXfsxmRKYq2aNPwxMkeVajP4b
         xhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011757; x=1764616557;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z74RzNdfSl8VMAwJnh85EBGE2QwwEumphH4Ky//xWjU=;
        b=HBAuUFRVoPUUdZ4yxfinJU4UMZGDX9914UuD+oOOe6Duqft6pOBK+CLokWH9E6vYmz
         u/CBxAAUsMSxynjw6ULEp9GsG694EGjM6rlEK1gsJjlsoie0A19AMUoWcVcFAtWZvu0A
         juMXBAqDVy7zZXbGyOnhxH7YkHX5SmSdkxTsDGUglOtD/8P7KkH2achE++mcWYTFG/6h
         6ppdvWI1IwUSPpV84prk1j5EXdproH5Yn3Wo+0HNAP/5Q14EA/mK778J3WsAjuqejNV9
         cjAujfuR6PAIv0JSVPT7bI/594G8DQpQ0LtN4wNTzksU3G4PjMnptHKwya5X9WgEtl6D
         8TZQ==
X-Gm-Message-State: AOJu0YzWgFVsdtL3jTiOxfviaIeZ9YYL7SEz7V0y6OpwU+xxCEkCs4rA
	lzZemMn3Z0luRDVyeH/5VBs3EunXKLsL+Snhq/Wm1rMyFHj5h7Qjl924
X-Gm-Gg: ASbGnctp7zbCVVBqdh6SrSOCIEVZlcsRr73oibOdLZD5aeIwn+cKFA7TBm/e/CYV7c7
	wdzsAzv+qcpJodOj122Zbmpad9vMugO5pj2NDvsyXdld9piQ9gabgvPjBkeqZWzZtM6lq8T66KE
	0qSf8ExHraPBrbPtUaDWGSHftveoU49Njnt/K8qXZP8RqXSA1jnA0JjQzGFnLlrp1nJMzXck0D3
	lLV/uZyWGuN2NtnubV/NeQuWx4iPKj4Ci2HBiXENoFHaO7wYCWbhzKQY/6eTYByAyu7pxt5OJW+
	oCwhjhMSaIy6bcum9WBV5gJb+ribeUzdERmwowjPjWcnwAPdiVfo+69dFg8FSR6WpvbM200ONYY
	ELBXvMxAsHiJAzTEhymYQrOJFBr3SUxqeR4/CapB+Xfe6lwps9TntL4qcxzBtl07/BaTckGBV4X
	Ag0XSJ6PZ3cJmUk+PEHXsh/16+F8MU+aaBLcI0o1W1N8Y0eJYh
X-Google-Smtp-Source: AGHT+IGePS0KpOixf04O0GPHrPDOTyvQ+JK5iIOfL4RCRH+wqcyx+HJrz5BODSKqd55md+TCGGnUFg==
X-Received: by 2002:a05:6a21:339a:b0:35e:86c3:af0a with SMTP id adf61e73a8af0-3613e56c0femr16023692637.22.1764011756938;
        Mon, 24 Nov 2025 11:15:56 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:15:56 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:47 +0800
Subject: [PATCH v3 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-4-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=3125;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CI2m/8pPC1xTUXTV6AisxBkS+TKo9XryUKDABctQipg=;
 b=1fBW1wrl1FdUcEqOwfoSs2tA5fBJlSZoQd/l5dSSLoz+ti6Fy2iBwItbC578HMHFO77guf/7B
 wYVXFaNjKC+Bd4iNACTNobyn7D0+ubSqDpVeQl9ZX01YuoM5frK6QXW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DE0140013
X-Stat-Signature: p5ek8cfnmfix3kaxzonccuz8cd95xk8x
X-HE-Tag: 1764011758-865347
X-HE-Meta: U2FsdGVkX1/V2KGVbRPf3o0HLuhvq87eXxWIrFmnkIUt6iJj81RIwrqQNVRjnX94zmzNu1h0RD5ciKIAV8BMJq6iQV2SdYrHYyV8jxyHxmYACRNydIym/WuiifSqTuCpWhkJznjmf22GM9J1J568ugnr1F6ERkGITi4oXErZhsTahCgmY7u+r5stRhChfocU3PGFYJaiaJagZR4osg/nRHBlgjaCiXqvcGFNN0iadVEyQW8iONLGFeOs3dhYUihezn3VFgp46HJcRLNhu/9v7r10NfhgREGmbm0MEtMXGLbjG+utJF4xDu7mR57JOiygLUJgLfbkzOXvRJmGeZoSMsi/crbrVAGjgRgJ2hMPTp0zIUlCDOyK8pA2DGdKmRR32oYMlGSrS1cXut+FuuOVOjEEPBojf7j6E1RbNBBgDayfAY0dVMMDxCBtdWqb5Q4Rg1JDB9m9dGh95FQ5jNQGalY4qtyQk3FyofMk+KVpSVO4rC7lINpEE1Qr9LdlonSXPlZQx9VOc4r98XL9yirFYVwyCC5GgrXOsmALHywzXHmaGBivPA+nv9cXwows1UMRTTkbpyNKZt6kZK9SVHmjT6eBmVLmKRTKn2gR+zmAQMh+FM7QkwPW3h+/igkuSYruMGPix5rfP5uYOS4AAieU8bX6bttYbZswbYyuRTXauo3IqJTJHVWH+GpDJkRpTEU76RaBeU8Fvqc33BSc/toQJh669iwnChasPwDwIu48qcq7s/peWxSte3mK6MMYi0WEtgkKY++IPlzyL94nHJw+Qe3TBNm60CEjPtcyO7OmPXACzOBPzi0iSyKA0fQeDn/ZSPm8GY51Ad+KxmBelUso8AxRf38NvfKAYDg+Nis3XVitmMCvBtj1RGZ6MgjMBaZJtrcTevoE27EuUSvh1cak2CqHj3pKX0vq9vsfEKoDHtPWXc4BpQvlUPfJT+H1CVng5yr/zxXeK7FuKwfRt0L
 1LTUotTZ
 R+y3oCnoaq9FO60Xi816WZBAiYUAYxhCfiUJGG/+C7yy4rWvpmGnyMwNCbm6/Dd1pFbbvWxowWqA8H9COP4Enk4BHc8DQQcW4cgftJgfWhYXlNpdi9HjJNlysMc2mBOjPfzOqRX/qPLTab36SUXCYBzcuGOzyLAlWKZiyW0ZloGYGMDr7tzaj5RRy7Z98Q+vUn8VGkmDHzJ40Lst+Og/EfrJroBPiZxPrtryTZMbFCdK0PN415qI4dpBQbtTVlyIEMx1RgEh8MQFoxaUljWiEfAC+/dD2+EtB1WfC8iOXJtncxfWwK73jg4jRTdxI8KHMKkXlUw3PyBcv/hFX0MnVsKgqx/fV2/YF+qMocw9ZGj53IEvPncmWMcCyZG8WeqCAhDEBZCxRToiURE8zYyhIe08p2+GiutBA7nUyvNlWh+CHpfLTatDS++qfsxTYhpFGOn40QqNaBIXNki/3TFOiK2ONjluszC1pZp67xHaeoUyxB3FZViQEdMc5B3xEgDsn1/19
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


