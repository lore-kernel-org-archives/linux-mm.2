Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA39CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15166B00B6; Thu, 18 Jun 2026 04:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E276B00B8; Thu, 18 Jun 2026 04:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E236B00B9; Thu, 18 Jun 2026 04:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90DBA6B00B6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:48:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 083EA90952
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:48:03 +0000 (UTC)
X-FDA: 84892406046.29.A3A6E49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E156C0002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:48:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o2I8b5UX;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaoSxKyClWE3jnYRtJaf7Jb5FKch1UvGKeE4Hl6seUo=;
	b=izSAmY6mpp5KXuLe6+HfqvLNSE54KQ5vtkx/nSxEKNOoHSjCBjsxI9MtwV+rnEYJv/jltM
	pTNguG8ROs0ID//qfCAli3VBx+LpFWySGcVFhoiAzQXhblWfhyAopNreNH3kLBbMuv7Z5u
	oIs5SKUNFvy4zEno3yGIxooSjGeZtXo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o2I8b5UX;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772481;
	b=AtgrOXVxAbMCNNT9bYNrvZlwDAD3YDne3rZ3oAUvNPmWqEoX2tnZ1q1zQv82O+xXh1HtbT
	9m3Nw2Ea7TjMCMCpwVMIuAksOoHTYEZldShIHpxkCwQL+m/XF+j/hOQfzIln+wtAo8TqO2
	9to5rtZdTr7WKj4dp9WFoRqFtb3remY=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-37ce68a54f8so251727a91.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772480; x=1782377280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OaoSxKyClWE3jnYRtJaf7Jb5FKch1UvGKeE4Hl6seUo=;
        b=o2I8b5UXRrGP4G0YPpq8ssyg3k0Zl+/J478TUkciKhmtwiPG6+mi+myxcl/0GgB8ar
         bMrA29iHUXMwbg2ALTKzQwN4++wRUusjDLils3SBVrEo0S5D2+k7bH06JOuMiLbalGE/
         nYVncTejGH910zTcafT8T+6/uZHoFkZc+dQndrAPwx6TuAKj+UWbL0lN3Ianyi/bYWxo
         f5WY6yy/OwUvfIXB8a/YsxRlGTcqpfdKpNhx5K6QgbKJhtBX/nuBoqEsQtgZK3Lrk34O
         Gl/cq51gYLm1lsSKNMpzKBUjcM8WrQznK7cLqkcY7Zvq97nxlPAXbhJSxyDlAdUhC2/k
         kaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772480; x=1782377280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OaoSxKyClWE3jnYRtJaf7Jb5FKch1UvGKeE4Hl6seUo=;
        b=P7TtdFKrYSlmbz3zfdcCUicY6p2Ozn25uMqMMM+nsteAuYJajBCym0B2l460sxu8Gm
         9YNGqR3RGg7nV7HfvIUzUzwNYMhIGY+u4wvemnhgAImeMZbHm4enXZMKahBNHkmF7o1+
         Dy2PoC77V/S/45m9WMKnQWyY6hSuo9AvgFI9nWjQQ49dfkhm4HVnDbGwcpedbPL29B87
         vwElxPeAY5cYLFi7bNGW4BI7+jwpX2Zd1MvXLEMtbUVuYnDQSz5rUR926tnlxUTIIjgN
         UlgUYMNxB9Js3SxRKreeqGkqT6OH9D8j6O/kNKUM3Hk/iNvOwKF9kHjJVPQB995VvLzR
         2c1w==
X-Gm-Message-State: AOJu0Yy5+1Dzj7INi+Ynv09yWBBUxsGxNziu+c+ci9dY9v/0JU+TOnAO
	SOZyZbHAg4uCOxDYPF6cDqchVdVaHcMOjncoPyJY3SvAxglVgLL3yDDhKDu2uw==
X-Gm-Gg: AfdE7cmNr/vzyiZqyAU5qg02q8HvQSWu5SC6LDLCUqEQHGgEiY+xAttSWuBRHN9tlOK
	THHo2GMFWGp30aw+OFLa+fB0t1/EUOKzekCJVGHGjJmmWaKVIOcjkzCMf4wtzjyP1EzIHyw+tz/
	9U+llKkhbrRTrWPevAnmXUmkmKuCsWib0TuNnUKB+1w7/uHewid/4Eydiq7fYf9iVq64vvqv0Xm
	BRV304msePf+xo+7BfODGJl7B5LMW9nHwR9HN5YdzDpy5RNDUo+6qaMhq5n7l6tiYeLRRBAEOc4
	O4i+HwfwaacS1tiNonzyTcpgfU0rD/MNaDKGXu0OYGJnCXOuXNMAVv9IYhx5dYXK4Mdz+0+MpUg
	/uUhTPSKhb1zwt11ufkRpPkmywfTxzlaLbunmZJ3p6vxSP5g/TKKi84USvEdACU/NTj9Pb29Rkn
	R+FkiHqwgxZkSgE3UlXjbBLE7U5fBztfx1MyY=
X-Received: by 2002:a17:90b:1dcd:b0:36d:f28a:c5ee with SMTP id 98e67ed59e1d1-37c9ed08579mr7793228a91.25.1781772479946;
        Thu, 18 Jun 2026 01:47:59 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:59 -0700 (PDT)
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
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 5/6] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Thu, 18 Jun 2026 16:47:25 +0800
Message-Id: <20260618084726.1070022-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E156C0002
X-Stat-Signature: 3q8pbekbiycp8pfxdias66o9md96ds4d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781772480-804096
X-HE-Meta: U2FsdGVkX19Pug4LGDnvywpLpvbxAIE9l6PFIe7jeC/z4QepjArHCV3uJW+h1BV9ZZdoupIaIdhBw+wBPpit5b+lz6Lk9dPSM2uWa7RVxGTky+fsGEfW5Ut3I9JMbMHSynoQacn8TjfG5zbqrJDp8sSKfGq5BH0iXtvjRfa0gEvzPLAyROMJK/R69OqvdXwp0sBC+ZqTVfUG7yjtJse71gYp/UB35kZ83sndjMAYXUqAbbN2yx5vJdrlBqcrwg1AwFD1ooGD/dzU3c0TkbHSH3NXrgD1TICoeBAVjzTZTRpHu50p2xadceYW+79UCVbmKvAIK+xL7eX2gye9OXEjAaKKWnBrF6TkuZJuyYvbh0ESN+MwXlnuG6FSLm7u9yDR9sU5OxBgzMJEm6byLtI7SJFWJCAgUTZ95NZxctMFldXcwB6arbDI0s0zO3lQuCU/fELDljZsPI4anzgw+tE0j4oPbBpxmPsSaiMIzmhQIXVBplbNELEMXu1pV/jXEGLqomsoIFB/ZDmzf8qWrS09mWJrGmDdQpTGh/zK0+2+4Vd2v8/tIDorqkv0zc/Qwdqru0/IZDDHRAt0kmPRxefN85rJT/MQnwDFtThuRE3s3nm2sjYcw/MAGavu+ZGBjIDFXk64EMO8gQpAodoMhkAn7m1Bqkj74ob4Vy3BvTyimWPsYYPLjdEiY+BFsML0zRwSSUHdSg/p8k0r1pP+vCVw1z+DXr8jcwG4/tvLFHfkvDYdRkR4aTcRsYJlFvJOzruQOyVQWtNpaBbPwlM+sOYlfkZNRkHRWYkai44xNPaCMx5Ex0L++neQ3N7mHWAFY0GoBb61duOa2aVtq+qrvPAEzL1E35gdF9lOGACf5WI5N7wJFdvwf2p/2lHfryH1Kpfrfj4brjYHqIiPgpHJ3mzi8NxaEy9kNp4aiPaEorYLD0iPWEz7kfRU4pt1G7GtnVV4ty1qCe8NL4thFefQe02
 DK6QuCND
 rj64caGBHreQdRGQ84SvsxKcoOmVXqkfy6eDr1hUzqFRD6GuwVeJk6eMXy7bfqqkPMbgizIbjgYGBtMLZCzjN4d7KsXXF40N/FESvMJTKC4yW20UF9gxbXZKeIOShxsZ9MV9ZnY+HMpHikoxDo4QaPuAIt5ZTtUsfj/tKh0s45kGmXnAqIOTcAlpmkjKdy4dldO8gof4xGaK7FB/20HbGNO/HfM6lcO600B5JOBkpAMLsnFciD9DsG0fiyHv4kUlFSkSzv333x1Is7karf+HR2sZMgVXkTAEkGPu6GRST9mpy0bile/4Wfq8/54P0R0sC8D9jLzPp82tmNbGoq3c1Ka6b6iF5+94FaW9CwOiob5fBW6uBHjIkb4AP7uaVQUepibJUMREkXUwnMiJK/nhg76ZXLm/ErbSlw0uwRYQFriYQQzxUt35pc6Rryv0sn5NbyytxPyyMKoCsPncWyO8qQbjVe79gmeIbjVerul5P0HDZ/HaajG/jHNvlgGLvP/NXXAhph6FWdRgKWjcAaUF/ocozmb09355PbkHgrnQ3UzpmFnG8BH4ZdmHC7CvoL60YC73MdG8FuB1pTugnwdd+45liKw==
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
index 253e017130e09..fffb885cb2158 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3545,6 +3545,89 @@ void vunmap(const void *addr)
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
+			get_vmap_batch_order(pages, prot, count - i, i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(map_addr, addr,
+					prot, pages + idx, prev_shift);
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
+				prot, pages + idx, prev_shift);
+
+out:
+	flush_cache_vmap(start, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3588,8 +3671,8 @@ void *vmap(struct page **pages, unsigned int count,
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


