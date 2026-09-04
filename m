Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056C8C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE156B009E; Fri,  4 Sep 2026 11:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6006B009F; Fri,  4 Sep 2026 11:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB9E6B00A0; Fri,  4 Sep 2026 11:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2235A6B009E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B063E160166
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:45 +0000 (UTC)
X-FDA: 85176416850.07.8CA73BA
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf10.hostedemail.com (Postfix) with ESMTP id BBD34C0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a iNRlLY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iZKeYrJv;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqDmzPS8A0heXGsnD3SSNRWbRweyoQUnesWHCHkvF4Y=;
	b=L+vVdi/9ZIOmt5mJ8gO6C9s2qf/MVc8nHrAR2csW8DjAQyW0lTwBpZlVv/XrqZ40tVCrPz
	8juGCSOKnR9pDtNf3MbbBoNdXLLHHIiWne6wx2TtJJ5RpGDWgCmjFhpDlBVUHXy2uGJrwr
	JheSRm0FDzvHccDNwg+w2vsmkTe0fkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534643;
	b=IHDU97hbwaTiWJcmbPV+KkXS/pShSb3sLha67AA6hZTU6HbzmPr65Ah873Kqwm2x3e27Y5
	+rutDPCEmS1CHtfOV/OhIMbO2b+7k2URS+DmnRge/3xg0Hrp4WM2Fe5y1sheVS2+x/4p+q
	FclvfC8WLZgjXlWxlwB/HKt6DKqRB74=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a iNRlLY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iZKeYrJv;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4ED2F1400122;
	Fri,  4 Sep 2026 11:10:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 04 Sep 2026 11:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534643; x=
	1788621043; bh=DqDmzPS8A0heXGsnD3SSNRWbRweyoQUnesWHCHkvF4Y=; b=a
	iNRlLY0yFkRuNBNoMOTbkSBg1NEQpfcBCqEzNvxZ35G8wJh8ENf5lzdLKFY5qew3
	ecSkTJS8YSzk9BF9e/xqXFOSW7We+/WvuO4qYCj2AoIuR+dh+jr/czK199UXzRmc
	FEO+dJ2Cb1QgDKLHsT4aibC+HGfUvqjoIMz64fC9vA0rEfDvuQYHd+Jx9Q7WzYoD
	EqAw62HLDm0esEgxpS+t1ghUMey/kzKjRNBvgH2z2fgX5aLDt3C+iVVnARV37AbQ
	4BceyOe6EyHyHWxcT+9AtiwmdiCo/C+JoaMRJX9cpBQhzZ96AKTZ4bSwKWRJQ1dX
	cdmaIQgPBRlhFTYEvpiEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534643; x=1788621043; bh=D
	qDmzPS8A0heXGsnD3SSNRWbRweyoQUnesWHCHkvF4Y=; b=iZKeYrJvpGiY/Nr47
	wz76ETjHnIlha350S2w8hadghwZQBPIe8uQpDqpCQiA/sGnFZjhyTvUuiXlhVhuA
	vEkKcRk6EvY5Q8FezNEu/h65F1nmO0IcWZOyM7ifgmeyFUHUEwH+zy9d5A2zQ2O5
	EPwjHoM06+cGOrDhOe7XmbMSM/VkYZGg170wG/MVOl0UDoQepb5MDY2v196Z4K/n
	GQc2zHWlSquhNKXpgcMBpeJMTzvWxHCy5WTAuiZfo8MSgJgbSrS7ISzjN1uwfGva
	aj60SUzvEf73AsP3T2xlge9SO2eBd5xmjCIezKe1leJFqZ536kM6yIzXqjSeMSd2
	Od4gw==
X-ME-Sender: <xms:c9-aahALs0SsFLMW-iUtuWCG3pO4nNBN-49gc2e1M7V8orKYh8xW2A>
    <xme:c9-aarfUMHhl9FPhyNcznwCuXURoomBNhBzvbJ8cvIcNsry2K97U-UeYW5W20GA5b
    IuDRZMBQ90qgn_ts4NRUvzXQ8b3K-1V_v1uVWZMB2bS-aAfv0qoKZQ0>
X-ME-Received: <xmr:c9-aaiuYfJlZuZa82g4blGgMBSF6BQ27ugmycf4m6lVBT7wlptKFqK4U_jU>
X-ME-Proxy-Cause: dmFkZTET6cjphBfz4H8Wg4Mwj3Q2fsO4rbzY0RZa6uwdK6ABZ7pEhWaf3DWE0Wh23XozXl
    YXqBYYUtwtfZ1qQ9wX2bCqZqo/yq027VrzWqESBcvph06bOS8vyiOGOCS0fh2RY7A/kSFI
    L9MElk4eZ3HddGFY9A2GQHzM4/P7C4mhUDQ1iVikEtpcmuF5W8uFTm0u0CjZbROqFnINk4
    xO1zzX/Hj74YRRcHjJyG4ygWf0Hx5RhGZptpxeuVNBh7kD8dz0lfmQnwRvV5yZ57YM54K9
    KH8vVIjAAxpTayQfOZqnAJ2Uka0rmt6zQ0IYLz8TzxO+2W2OgPHZMW2lenfH2WoNpxg3WD
    kFoVBGZvgOEe88v5nMnx07Cy+ZRyXffepGnIEKsGa7dZWyUYqFYxlmHpu/pujCOsKJzCP2
    G18G4R9ED1zc3xEMfxQd1aA5krFgZzp0SnlDTDaiszQev8U+2LtqTwJNgLFIxDCoe4a3XF
    6ju9R760FF98GTSg3YFQhFvgpzntzkCc1enEyfOroI+8l8scsQ7cXGkotwLuub8q3xzRh3
    qP/KCxPHSRHdftib7Az3yS8wv2Cec5t0zf45Weo4/GQ8LlIODtgWu+Fjgo8hyfRskTHX/T
    YZbFGnP/OYDfQs6JjgDvfI2B+wbeptAoGCnnJluV5+xLZHUd36GfWHdI3Log
X-ME-Proxy: <xmx:c9-aaiJFDf88E5BiwfO5E0D02-zlu5E1WgiVYQQJjvmpMbSpPpnPYg>
    <xmx:c9-aakau2siB0seeLVNuifDhSVu3EloVHKt5v2k43_rHmNi5W7FlRw>
    <xmx:c9-aaoKzX_dzD9tGbTU4Lqy2amciJ3dN5Bpper-sl9Gnum4Uemb7fQ>
    <xmx:c9-aatpZfdG2WlRXbDWmNUOMW6DSK_HNv5QTBECxw4Z-svml8t1SMw>
    <xmx:c9-aai5pfguVhU9zArI3gk4BNBysVBLt4FIxV2BYAMPEGv6dyqTNiiq9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:42 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 07/12] mm/collapse: name the per-table scan reset for what it resets
Date: Fri,  4 Sep 2026 16:10:21 +0100
Message-ID: <ec3d193817dfa5d0e4fa2f31642c066ebfdd3151.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBD34C0008
X-Stat-Signature: ffh71ta1cmrcqgogc91zqzofw3ec6yqj
X-HE-Tag: 1788534643-507760
X-HE-Meta: U2FsdGVkX1++TzdENB7rBmDeWaYpQt/ri2ZXS3+TZc/nc+oZz8noOohwQvRvuAmDgtD2lPtuf8IYIotrP6orOcV3AL7ZuRsSYZfoZfLyi3+vycIVL5p6msrK2y0ZSJ36W7uB+q6PQiV7yfxLVK+YDsbxmTxlXjgGDlw0hUzBUfn8zeiGNevJ8+YZMMNKrHl/j855bO/aGbYUPC0W4f4JHwo+b5u6hZW8aV69NuY+S24Ar6YllUGMHmUK71twHIWcrCaE9lrTRG1AGvGYvauAIXzR98gpYbfxouD1SH1VA8Zwt3HKszqZLBllUrfeTEvbxpu0Q3QutTD12XG3EWxRzFxiA9cDEflRM+F9eq9rSbWFWz9dYtBu3lndJjWoMfc/T0YyQa9iLkX5UXNqav6umktUeIjOcGg+DHFXEg/p+xykyj/aV/+SadEkjpgwd0qQsWSw8SG7CMb89Ae80krEljeuCSfheFjMtp1DSpaL9PC0KNKwRV2ktwX9EeMg6DfsCAvB1l3jvLugU1ncJxI0QeqcXsMnT2XY8mjIKt1WDV+WXj4ypVAzFk8fZ+NVuw0/jg0YkqC7x4mkPcBJnZGM/LRxkMGwto6tuzFiOLyfqM8dvecGV9wC0HBCw8tUhsSBFIEVaTZA9Z/6O/NIMGfIakrtfusrmvHqV7F3pZFSmgmg5k3hD6Fpm6LWxN8Qkhtf01YILJnDsf3V+pKNa5VsDomtpcbnKqWYeaHndPvjYovtnqSpBOXxiace4q/eI0U0Zq5cumuoS5gUXFDuORpv0BWHZDMbf6W0LlQIBfVnGspZbufWcGUBGDoYVQYjxR9A6fYu8AvU1uRi7CsYjv7EqZ523F7ztbAKkGQbyBO7LDtGzw/Y5LZdMgc6rN5F6c9b/tZoZyYmqJrBw3Q52saCjoSSR7Evlzi3cXmSUyTshU04CHgXqdxw5K0h2Bxs7Pt6+RsCTIUtVEoAWMoJdKj
 PYwKcjzo
 B4osiyztese5hJ0ZeQjV1R8fYaBGFzFT54wC6+rykINs4Wh7GXXSTBgCFGv7tb3od5fPOimBAJ2pbcjNtGFqPp00yNa9bjTWVBO0UbHHxWAkdeGTZhUifgefkIiAYWlXGOEfeFH4dlyRF6tPE8TyBAEiubIGRsBHM1DxSNs2R627DfDQaVVWYmWGx6t8w6ZVqVaJSDuTDI5p4MjsL873FfTu24v6lJ+SBIFnaZBp/tDxf/y7Xit2E3z1pj7XNRNfT1fsmf42Sn8tCc6J9gDE0XcVuBdfqg9h8TGaE4A3tzoJPmRK73yrYm4S7fGBrJIVRoHOSigs0coYBrkptllNEwe1rZ3xO93Dm/gjzLJ64i9XpI/r++g7ST6Rc0zYuWFfM9Bkv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 22272cfe97e6..511ffb381fe9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -550,7 +550,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1579,7 +1579,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2660,7 +2660,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


