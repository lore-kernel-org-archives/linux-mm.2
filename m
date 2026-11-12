Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3EA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=PzZPyzyw
Received: by kanga.kvack.org (Postfix)
	id EBA756B05E1; Thu, 12 Nov 2026 06:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44166B05E2; Thu, 12 Nov 2026 06:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C2E6B05E3; Thu, 12 Nov 2026 06:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06DE6B05E1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:29:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14DB8C031E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:23 +0000 (UTC)
X-FDA: 85426246206.05.8364451
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2D89140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=PzZPyzyw;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482961;
	b=m4v2Izs74sdGR3K2TVwhzCjidu6RbXRnn4PT4J8OcMxYqYBkPeUcx4A7c9p6YPoh6g2JUT
	LQ754xr72yKyfJRHpN/QZp6BQD83+sPlxsL/LYLoUSuHVMKvzMGpuZtYU6FdLcMd77Xu7d
	ODRPIt6pw8OxB68yiIkLmu5bC4tUtrg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=PzZPyzyw;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XQgaEoJJnLvggR7H1uNK8kGybQpdj70HEDcJyuKRAE=;
	b=LeU8z4me1XgVKieDtIS+hxhghphHcoCWuIWE0MJVygP9+N1sl6ufpWHfO4sXrtvddDHVuY
	o0Pgdz1L9x24E4ZKQbk34nzjz+4M/lZrFH9Ntfp1iKIUSxXmqByhu11GSDxbHnIgtroKgO
	/UGjPHsUuTwe08Th7b+tsNT4vfmFyn8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794482956; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0XQgaEoJJnLvggR7H1uNK8kGybQpdj70HEDcJyuKRAE=;
 b=PzZPyzywL6TOPdgFpkUmqHDy6BqKCQHy7MnJ31ySiB3b9bSvXAeFh2RcgFxT+8XygT6tkU
 skqsxQAh+W7mXPdTGoBIChubX6DnaOIUQFVB4npV0j6UWPzVeKCuYAXChngalmTsRSqnga
 yP2aXS9DHuwc6Sn8q31NPiB5SSwHjweu1qxNTptWSJX3COb6SqC8EQCSl6t7X0SsWqTRHw
 KcRX+c8Nlnj8GCUYjhYDQ7tWpqqnoX2q1zOWzwB7pOJjrzZspp7bAcfdKv4bXsTywJ6qS/
 CcDbEGYF77NJ+sdeCgXq4KrJRSAGmxCjBQAeEpeoa8sRQM2XAYcbFFw3zfmgyg==
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26af5a30a+f1216f+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Nov 2026 19:28:16 +0800
Message-Id: <20261112112816.55095-3-lizhe.67@bytedance.com>
In-Reply-To: <20261112112816.55095-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v3 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
References: <20261112112816.55095-1-lizhe.67@bytedance.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2D89140002
X-Stat-Signature: fqrt4xaspucnkneo65fjbg1z7iwmx9rm
X-Rspam-User: 
X-HE-Tag: 1794482960-378598
X-HE-Meta: U2FsdGVkX190Z5iIjcMf/4fjoIEwiRE8ODrhVsW3inVcUxcX3VdpSry9ZTFDbmvVd+f6jDDB83zhVjjaJn5hc+dDpLd0F/d9LJLmYqExZwmkHnMxN7rFUEcWCGWBPFheoVC9/hqWD1qfya0Y4vpYOv68uO3kulSr1hWFDBAZ61l/biEbRWpYJWpZQ9PEP19r5mB7KWKS+3DUKanS5qYIHDqLo18nbzrTqJRgg2y+VjmoygvAJnhUL8+2EB2S41hf+PK7vfYsYVWh2lTkKsFbLwsv75pWP4jPyQLquvm6dQgrny8phb4T8YyOaGOx31t+G+NTRD0bYUhyAvxsMFNgBUHoQlShgDBQjFhJNcfI8z7hl78To6Za0IQrBi6I32xTnl+tRCq4W0cQ3j/EZZQzUaYuXhDvO+MP6S5oHSqMCb4cJu19h6CZGJoSP/AoCk3yJKGVmUd4ebIBnKc7tfmUXisWzCURSy/bXGXVlRxOg8T3xTT+LezdWlphvCgNqIiHvPZ2adQDCWM+RFdBOkc+n3PR238bNbx5wPVMPfCG9603c1BKwzq5SEtHhs+JfCBQmNQwbFfO3bfDwr6FkI2TGKl2YSjf8JOfKa8XBM8NMQ3sg9A7UkOpcOv8t5bpNmePDh2x50SwdbR6aH1a7YYiF/ypYl/ii6pBzk/GhXftzfmk1ehTbOTEiW/AeszNHHJCvtNaVmiB5Ev8OGpIqnxFR3lmXChXUSJreZv78OP1s/3D2ukj7JtHzQFOA/lu7sCzMTsAanzvLkUP5Zggj0FJiXq5VX0uBcpuTh6NZeupBrNg6ph+vIpgOGHZsiv4WsHwa3PnRY8vMPe8JZQC3Zkw7pIeJdlM1DKL+64xDPr7DOZwuE7NMvh1ptejaVWPquhXhp8523Dv8B2m8l0lIGlf519Z1fqbq/GE1M4mtI063EjltTwsvMBMoUTax5wP7yNo86oOR4T5K4YL9qSq1nI
 lxY6Ekfl
 JFGWbyCBJ1XOWg6nfosfQhHxIPYpii4fA08DmDWzDqSp/aOXxvcRJyLIu+uAF89IoS6K8U2kwv0buRWo3F+QAOFwwgN7fExU1oMkR/65ULuMJ63p7x3aZpD6VdgG8cSXtq4dYGdQktBvolHyl8FrOrQZJtWLMNsBBkbrfy8p5fPNwfZPJuaOiub9XA6vgIoEtjkPG+EBtpfKeCNIguZHBkC5YPkM+/xTsqYTeF8P994e7PXUOOaUyzd5OGos5J0JvfByv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time HugeTLB allocation has to initialize tail struct pages itself
when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
gigantic pages, this can cover a large number of tail pages.  Most state
installed by __init_single_page() and prep_compound_tail() is identical
for every tail page in the same huge page; only PFN-dependent fields need
refreshing.

Initialize the first tail page normally, then initialize the remaining
tails with hugetlb_init_tail_page().  This copies the already
initialized first tail page with memcpy() and refreshes only the
PFN-dependent fields in the destination page, while avoiding the full
__init_single_page() and prep_compound_tail() sequence for state that is
identical across tail pages in the same huge page.

The fallback path was measured on a v7.4-rc2 base with a temporary
jiffies-based printk modeled after the existing timing in
memmap_init_zone_device(), using 4K base pages and 64 boot-time 1G
hugepages.  HVO is unavailable on arm64; on x86-64,
hugetlb_free_vmemmap=off was used to exercise the fallback path.

  arch    base      with this patch  reduction
  arm64   360.8 ms  256.0 ms         29.05%
  x86-64  171.0 ms  165.0 ms          3.51%

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 630c96cd1e88..13efadf64023 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3214,6 +3214,14 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
+static void __init hugetlb_init_tail_page(struct page *page, unsigned long pfn,
+					  enum zone_type zone,
+					  const struct page *source)
+{
+	memcpy(page, source, sizeof(*page));
+	memmap_init_refresh_pfn_fields(page, pfn, zone);
+}
+
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 					struct hstate *h,
@@ -3231,11 +3239,16 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
 	 * we must initialize them ourselves here.
 	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
+	if (start_page_number >= end_page_number)
+		return;
+
+	pfn = head_pfn + start_page_number;
+	__init_single_page(page, pfn, zone, nid);
+	prep_compound_tail(page, &folio->page, order);
+	set_page_count(page, 0);
+
+	for (pfn++; pfn < end_pfn; pfn++)
+		hugetlb_init_tail_page(pfn_to_page(pfn), pfn, zone, page);
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-- 
2.20.1

