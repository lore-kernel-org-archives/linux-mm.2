Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB8CEE7E345
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0884D6B0005; Fri,  3 Apr 2026 05:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0396F6B0089; Fri,  3 Apr 2026 05:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92796B008A; Fri,  3 Apr 2026 05:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D60E66B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:20:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79CFA13B3C1
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:20:36 +0000 (UTC)
X-FDA: 84616699272.23.F2F9F5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id ACB78100009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:20:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZOfZycT;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775208034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlceJCSUtqXlZ5nwczu9ppfDf/yLncZ+KielsoI7YVQ=;
	b=PHE4X5Rn9m2z2kpM7seknXAFvsFyDRA6d6sY61+X7d5yo1P3Nk1bPuxkr8O3XhlFwvfD0G
	1zLugZlBw/b52cSTFuGzVAfszxuOCxe5yOqvkLfabqjILttynYx1QIW7Q7GW1YuC46IWrf
	+ch/z5vcIbUl3769JAmKi1j11dJPi9g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZOfZycT;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775208034; a=rsa-sha256;
	cv=none;
	b=C/IjkjF2lf3iJEKiJEnTEEv36hGnY4LfGrSqDUu3of2GqvWCQP1g+vgdguvltQCmuxXudr
	XhiHHM1CWyWaKanMm+fC0tFWC7s37uIRUHi5iJ8oPYo1Sygepzr9bAi2JLDfckrX50zg+V
	AJuR5P41r9MvGjNVpxz+p4rHK9ex5Yw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF46644177;
	Fri,  3 Apr 2026 09:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AB8C4CEF7;
	Fri,  3 Apr 2026 09:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775208033;
	bh=6yQ3vTenqXPoi+0PWTGukMJaYEPSz03tyljhBa6IByM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZOfZycTXUM3i6iopk6sUfFHNU0/Xqwy/r8HbSQ7CGZvidHZ1Z3vrFRo3K4SCpK22
	 /we6sw2gldNdAVF1lwjBWvDa/GZf/pmNvP3tcFcJMJyu4PI2NmNxfKygepsu5Nlmyd
	 r29qFVbXkGyAWEA6ZQ+r9fqoscaZpyJhPPCBlbpdSKJyk6r/b9EkC7sfyiqKzbGSNp
	 3dMqIBR3UB5nRPZt2U4fQ9PRrKKaUmpHTmfdJ38ZmKRO9U+i3l4nsJXmLqU6M7+UGY
	 CC7h3IPn5r9Dyfjvo7CUEJ1Vg8+EW13P18cgEcIxwbjf+jI/Ihh93Zr9NHd3mOyaXO
	 kWrJy7LRxAjyQ==
From: Barry Song <baohua@kernel.org>
To: urezki@gmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	dri-devel@lists.freedesktop.org,
	jstultz@google.com,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	mripard@kernel.org,
	sumit.semwal@linaro.org,
	xueyuan.chen21@gmail.com
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
Date: Fri,  3 Apr 2026 17:20:28 +0800
Message-Id: <20260403092028.61257-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aVvmxGUp2l0Tavwb@milan>
References: <aVvmxGUp2l0Tavwb@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ACB78100009
X-Stat-Signature: 91cka3w5j9madbssrcb8awwydcp87nss
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775208034-296647
X-HE-Meta: U2FsdGVkX19DKfcIb+nzPKm98paJR/UW483nMp7alrpru1/J1jRAJ3WdOGpX2xC24AQ4IGveouReukdmrWa+LPqOQuCR6LaMa6vScpYJUb0BzVhJ/8HMPpgmzdEjCUItN//l8IZw2he2VffEZy7tFBCoIvqUC2sl84yFg0U5V8J9919y2Q6SS6n9ECbTeHPOCVFn6HiWL9L0iQDqHf23iXvbQOnaxPzzdCShQrP3lFVlhYJM6wipo3uqqCw8PNYKvZB58+8JMeTh55dwBwxcoPl2HQkkXvXoRT/7d1oBF9iAPWcQ5cGnucOoO1VTLx0J3sa8MxwICNToJ5Z75dJNmNLbzrpglQllORrbA+e6YSt63SC5vxVkyvbZSYvU2MmJXKaxozEnGDtIkX59220GEWDnX14EgW4uEuLWU7WyHUKi6WghwZFp6YBJ93hDbyNa2Hl/FWQa3Sp5u/E3NXBcm5K1JlbXrwTlXJdDRYGBbh7CqFxsXaHph98pIp/jUt//GEjv9TCkqXwTiuwmpxYYY3xUiCLxGJDmN/tAHaj2L3Re26NFxBlDwud+6VEEHPZBZ4If/M4BklwERG5PSaawX+64USaDYg4oReNOdCY2uBso8kGSuCpyK0C2oZ4jDQ5cS4HsH6hr4h3PerqP53hAC3dxGrogEA1qLD55Aoy/woD27LWG+w89MotDx4l5VVnRt7ftGtpytRJ8OKeDe2fdDRwQQuGcQlpLH3x4xs4PIBvE5Sww6CSVpCOMS8bUPTAE8BXDC/8TlPJQPVHiuqodKDkC4aCOW8+dkVh9nNSq9qnBU2IcyzNZPb7oBAz+0x84t5iLMcvUw8DwnBSag9ecRgXg2eptx+rPWetQIuWHS8BX5cbokXmHMGWwfDpylGQ+4PFoNRVyaBK2/42bfpdC6hgIXj4/JOi1aH1GjZZ/hmJNArc5At+atVJ9kqOOmGbZXattZ0uwhuOoY/6nO2U
 euT7hWSk
 cJqZCqHY9aC1mSW3vzNLhLmKAwCO5DVd1NATOXQiZyLcOen1A7kc15I453oQbAPoM3U69Ev/kcaeH3/5nG0h44YbkmrGzuIAm0n3O050j18zfzU7TZYU3E8smTEWY/16GUV5onnPvX7bYo11n0vzQrKXReOww2xlL6jBmHIxnc8LHxAqg4Ccq6KSAigTlkb9+VDRL3jvvp1uHAg7n8ReNW+FClQnBs2dwxxG/P8zdCK2XiK1/KG40KqG97yIhYPQxRYWge8q+J5TpPvS6CJyb5gDpRaSqWVrteKteDfQXUj41t9hPUsl2zikU/j8iLz1J7m7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> I think so, at least the place:
> 
> <snip>
> [    2.959030] Oops: Oops: 0000 [#66] SMP NOPTI
> [    2.960004] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.18.0+ #220 PREEMPT(none)
> [    2.961781] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    2.963870] BUG: unable to handle page fault for address: ffffffff3fd68118
> [    2.965383] #PF: supervisor read access in kernel mode
> [    2.966532] #PF: error_code(0x0000) - not-present page
> [    2.967682] BAD
> <snip>
> 
> but it is broken for sure:

> i += 1U << shift - "i" is an index in the page array.
> For example if order-0 you jump 4096 indices ahead.

> Should be: i += 1U << (shift - PAGE_SHIFT)

You’re right! And sorry for the slow response—it’s been
three months since the last discussion.

> vmap_page_range() does flushing and it has instrumented KMSAN inside.
> We should follow same semantic. Also it uses ioremap_max_page_shift as
> maximum page shift policy.

Not quite sure if vmap() should follow ioremap()’s
ioremap_max_page_shift. If needed, it shouldn’t be
difficult to do so.

I have a version queued for testing (Xueyuan is working
hard on it). Meanwhile, if you have any comments, please
feel free to share.

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 57eae99d9909..8d449e78a07a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3513,6 +3513,60 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_pages;
+
+	if (ioremap_max_page_shift == PAGE_SHIFT)
+		return 0;
+
+	nr_pages = compound_nr(pages[idx]);
+	if (nr_pages == 1 || max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+#else
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	return 0;
+}
+#endif
+
+static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						PAGE_SHIFT, GFP_KERNEL);
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT;
+
+		shift += get_vmap_batch_order(pages, count - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << shift),
+				page_to_phys(pages[i]), prot, shift);
+		if (err)
+			goto out;
+
+		addr += 1UL  << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3556,8 +3610,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_contig_pages_range(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.39.3 (Apple Git-146)

