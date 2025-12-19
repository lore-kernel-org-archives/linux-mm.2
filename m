Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D679D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644166B008A; Fri, 19 Dec 2025 13:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5556C6B008C; Fri, 19 Dec 2025 13:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F34E6B0092; Fri, 19 Dec 2025 13:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1FD6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:34:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB1121601AA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:03 +0000 (UTC)
X-FDA: 84237069966.29.8669B42
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C5C814000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i7lVjHHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3mJpFaQgKCDUaZRhZpReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3mJpFaQgKCDUaZRhZpReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766169242; a=rsa-sha256;
	cv=none;
	b=hI/WmS0jc1U7XaM0uOAeA+tMabxiCAwIsyUEW6+dWWfTpNmZcfmwcdTTKbggKMIiJdqKLE
	/dpSuduunxoBIGs+EqK+Mz8/QafsvA7EUYpXZyaCbsi/Vz0GqKrEJGXTwMH9PQzD3UU5fH
	BbXmY7mkeDhDIcv4PzlpblHZrg8UFr0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i7lVjHHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3mJpFaQgKCDUaZRhZpReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3mJpFaQgKCDUaZRhZpReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766169242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRw5dUG+XR6beJWQo32i4j651BpzChIFWVHC68FGfqc=;
	b=xwnFAkMwYSApmCKIZnNy4C5XlmQhZ1YkFZllLFpvX1QZe4WhvqAYOE7q67wsoHNccBzM7a
	wLmpYIUQINIUvxq442cQ5VVaDkNguVGf4M5DPSlXPD+tvY+yJPuiO8PFAlb/gnmJCSFhcv
	fZ8OL0wqvmlKCf/Td1YHyxs6j6ZfdmE=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f27176aa7so37862725ad.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169241; x=1766774041; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRw5dUG+XR6beJWQo32i4j651BpzChIFWVHC68FGfqc=;
        b=i7lVjHHbxU3nvGrbAYN4rxAJVjqB/16BahVZfYrafhOjQYUP6SRfMYhXQLfXAthSkT
         jgB5AwuSvXLZpd+pEJ42ZFCCRPrCpu6+QDLWoEe8yTwuaHxnTOaaC0510Ah6f2EcUc6T
         pJXHuH0d3/IaTvFzuBAFsZfvVwTIlTS7gOXSXg7sWrYtZD/zlWg8qwVy6TcK2ddCu5Oq
         2cSlzmL/uKtEicHNCtZzqiBb/EMgEf5TRbL3TcGzugmn1lxYQ5T8hUlOpPWMHl8fiExP
         agCyqY2JFwEVXPp5e1xe3J14FLV9Y191OCJQRp/uLkXz0RSRU3xmCeyi+2mvKu6DxHr/
         TSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169241; x=1766774041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRw5dUG+XR6beJWQo32i4j651BpzChIFWVHC68FGfqc=;
        b=QbOrnquvvy7FsJu9eScfY6iwpiXJ7PJGbyDfPJ/bRG+22KGnD8esJvMlNezxjPJRgL
         ram0TVN9CW2lJMUdXPRVKkO3r9AU8Y4Kqv9Lxde/jFYl8OVeCYaziOBYp5ZLrY9J8Yc6
         m2m2/ECRA0ZNaTs2Z2Eu1zlBdalM9V14tOD2tsPWLlr3rPTnNUvPm2drfcIuVLPyzpKM
         ZhTEXTbLp19xuK7afY3L90YUVp60yReoaEWLT3499s6LIV2KCd0+b4ua81f7VubGbQsx
         NCz3yoYo75lTgfILcowyMK2697sSKYZEI837Wux7mTwJ11x0vtv7HSzuV0AcwNPS/Dj2
         GSlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOY4y8rYbFs16+rRHb5q4hxaxFWcZ/VMjlzGad8Le4MHwbhMQeXvrv10laY23Yi5jWzWTb4ZlDBA==@kvack.org
X-Gm-Message-State: AOJu0YxlUKkihH8dEuDRyYRMci/bcZ6+HDgv6p6ztIAKWGd5Pe7Q5UxI
	j9wIo1fjf3EbvSqRPgdH+Zr7KfKzmXwI2xxadNwB59P1aYz4viAMeWXO1p27NPBv2d/Lu6FbpM/
	xsjr4Lc0Ew2XDjg==
X-Google-Smtp-Source: AGHT+IH20Rlx/YPAgSS/M8SOXQ64kJgEZYeGfthUqW4VqFVoXAcaf4KGIs5xUGj8Yiw5+hGunRG8Qe3zb+OVlQ==
X-Received: from plbkp8.prod.google.com ([2002:a17:903:2808:b0:2a0:9afe:8253])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4405:b0:295:565b:c691 with SMTP id d9443c01a7336-2a2f22292e6mr41848565ad.17.1766169240908;
 Fri, 19 Dec 2025 10:34:00 -0800 (PST)
Date: Fri, 19 Dec 2025 18:33:45 +0000
In-Reply-To: <20251219183346.3627510-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219183346.3627510-3-jiaqiyan@google.com>
Subject: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in high-order
 HWPoison folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0C5C814000D
X-Stat-Signature: xmeb9e98p58biojy47u69e6ywud8d148
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766169241-821516
X-HE-Meta: U2FsdGVkX1/ra8KJSVkKLCatqKHM76lwTEKdHj+RLItPQyasx2TrkXo39FKpUwlj82GoqHleV529CbEZw+3pRvSgOJZljBIH4zeUaD6D9vLCKq5JxEJzVgvBH1S2bAfEe/VAheAk6PA9GCzKhOXK9iPdcruMR/hYUidqCBVjghfFpFCaVL/fioBpPX/7pvI87V7T9msFI1vtrhJxznVHlFDZazbgqgNKeNp9duYBsY1Ghwy8dNZGQ1asPe94GkaI/63ODwSlukqnmEXxNbOv4l3RzX7s5ErEdrWpgyaASdlYQdpjzlcApCN80VxHwaAN/KJqJo8t0jLPUsO+Lhhc+wQfZfyWxXJH84ZK5ikGpidcWnEo5XgYd13QqZokwBkxUheJ5/hMMcVB5sdKjRpqIPt/DYykEPunTpZTVpTe/Do5IBtoJGsQ+ETG1K6YGL3tVS2nB5VRrqIu/iRrx8SvkgkgollKvzqysaNRacyorUUeNaZmm8Ujp7Ojf+fZf6JUxJvjbJnVHLNpAugWyjNqSviPUuhOL5fgJOi1RU/upwErDW6xWFp2J3Tbi6CtDXTVVrGl8X/PwxCmw5px0fcvBIFe663eiJCXOccI0kSU7qNwK/eDU4RKwJBmzPjgpkTHoI9SXRD5BNKrwcztkaq1YAjLTiawgH28jBzFDsxND4lqjFuV0MS3GiUpNVda22VU0GblixNf7iBaCE03C6Gt9cWszje/hN8gev1MByfNnw5YVYi0n1vM9P955qmGoSj6LWLSWWsafJ4KiI1ftVG5cfxAvqUdRQFHfGPKpmKUEUtJKhch03m6WoV3ES2WZqcx465uwFpbKNsvFzZxDvPPZ6eEG7xJh9HcqBgolK4isMZKH6w5le5VhqSz9yjMXOcdqAM9NVH/bhUD/Ayn9OVqONVX9xlgZThC4jILAx+FqKMEU7WfCyJ44rzOHZzdKmfd4Fqh7Bov8M9kCiWr8z6
 EgEESfZN
 AAtEL//WaUnSK3Zoryn6cjZfge2OxqBGNb2nAv8Tuy1Iy+FuAhJv+uy+/ZotZRCH9j6JXSiR4bWvuwoppnHYStppm5Ve0N7/ysAGs00jUn87LOK7MMMPQ6AR0cIB+9Yj0rwx0/Mr+cjUIlEvhwvGvP16f7ITuJwzsooMu4gSy6f7YLKrxdnB+/jl0c7knXyBVJnh4OCpeXdEqbaVNbEoZ+zScHVWYUIqX3qC98Xo6XLx7Ic9yKj/f91xU7kPw93ZOXRasL2/rrn/acEWvaQWbx/zFNLqKj4qquLtJ3ujgLJVB1BUwJ+j315o4lBvfMVcoBuZMIheeCD0LVj8NTfOL+VKeY4qp46ykbG4IkZSTQOXtPrUqUdkl92Su0WBc0BHcWBQpT1tGos4I8Af1gDlG/dsJLnwUrpAqejBDWnteYhByOMeOqXUBrNs+SG/sMCGSyDkZjyvrIIOtD3t1vW5laNLDsc/tjEN+LZ51cYa2EpoFptqPeClvc/0k5VnzsTzs6OXMTyaOH/WvC82NkrzPfly2jZBUNO9eHaPdyTXNS4XVeg9M188P5vaTnWjWOT+Q4fssQDVqRmp+y5dVD751o9QwhB2p7j0HzqxmjQFlDWkIfducaxPUEkSs4Rl/EEm39rJDDlVBAVb3lZvXUqNNo8zZYnC6T+MiDYrfo3hmM7vKub47wiwjZaHUO99HO2DOPk/cj7ybkhqhOHD80Vt+qgMbpKjsYHeKV4ju4DXccQ0x0WeU6pQhCr4ciToaF0JWTZ8s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio that a free HugeTLB
folio becomes non-HugeTLB, it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio. However, there is always a time
window between dissolve_free_hugetlb_folio frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoison_pages to only free the healthy
pages and excludes the HWPoison ones in the high-order folio.
The idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, decompose healthy ranges into the largest
possible blocks. Each block meets the requirements to be freed
to buddy allocator (__free_frozen_pages).

free_has_hwpoison_pages has linear time complexity O(N) wrt the
number of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison defines the
overall time complexity.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a9646..20c8862ce594e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	}
 }
 
+static void prepare_compound_page_to_free(struct page *new_head,
+					  unsigned int order,
+					  unsigned long flags)
+{
+	new_head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
+	new_head->mapping = NULL;
+	new_head->private = 0;
+
+	clear_compound_head(new_head);
+	if (order)
+		prep_compound_page(new_head, order);
+}
+
+/*
+ * Given a range of pages physically contiguous physical, efficiently
+ * free them in blocks that meet __free_frozen_pages's requirements.
+ */
+static void free_contiguous_pages(struct page *curr, struct page *next,
+				  unsigned long flags)
+{
+	unsigned int order;
+	unsigned int align_order;
+	unsigned int size_order;
+	unsigned long pfn;
+	unsigned long end_pfn = page_to_pfn(next);
+	unsigned long remaining;
+
+	/*
+	 * This decomposition algorithm at every iteration chooses the
+	 * order to be the minimum of two constraints:
+	 * - Alignment: the largest power-of-two that divides current pfn.
+	 * - Size: the largest power-of-two that fits in the
+	 *   current remaining number of pages.
+	 */
+	while (curr < next) {
+		pfn = page_to_pfn(curr);
+		remaining = end_pfn - pfn;
+
+		align_order = ffs(pfn) - 1;
+		size_order = fls_long(remaining) - 1;
+		order = min(align_order, size_order);
+
+		prepare_compound_page_to_free(curr, order, flags);
+		__free_frozen_pages(curr, order, FPI_NONE);
+		curr += (1UL << order);
+	}
+
+	VM_WARN_ON(curr != next);
+}
+
+/*
+ * Given a high-order compound page containing certain number of HWPoison
+ * pages, free only the healthy ones to buddy allocator.
+ *
+ * It calls __free_frozen_pages O(2^order) times and cause nontrivial
+ * overhead. So only use this when compound page really contains HWPoison.
+ *
+ * This implementation doesn't work in memdesc world.
+ */
+static void free_has_hwpoison_pages(struct page *page, unsigned int order)
+{
+	struct page *curr = page;
+	struct page *end = page + (1 << order);
+	struct page *next;
+	unsigned long flags = page->flags.f;
+	unsigned long nr_pages;
+	unsigned long total_freed = 0;
+	unsigned long total_hwp = 0;
+
+	VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
+
+	while (curr < end) {
+		next = curr;
+		nr_pages = 0;
+
+		while (next < end && !PageHWPoison(next)) {
+			++next;
+			++nr_pages;
+		}
+
+		if (PageHWPoison(next))
+			++total_hwp;
+
+		free_contiguous_pages(curr, next, flags);
+
+		total_freed += nr_pages;
+		curr = PageHWPoison(next) ? next + 1 : next;
+	}
+
+	pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
+	pr_info("Freed %#lx pages from folio\n", total_freed);
+}
+
 void free_frozen_pages(struct page *page, unsigned int order)
 {
+	struct folio *folio = page_folio(page);
+
+	if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
+		folio_clear_has_hwpoisoned(folio);
+		free_has_hwpoison_pages(page, order);
+		return;
+	}
+
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
-- 
2.52.0.322.g1dd061c0dc-goog


