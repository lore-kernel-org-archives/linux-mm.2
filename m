Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2634C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1700C6B00A5; Tue, 11 Aug 2026 14:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148036B00A9; Tue, 11 Aug 2026 14:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FD26B00AC; Tue, 11 Aug 2026 14:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5A556B00A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:23:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6694CC0194
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:23:52 +0000 (UTC)
X-FDA: 85089812304.20.5786A98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EAAC18000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:23:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="iMMsJQ/s";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TBsqf62Gp/AR2GFXLRO9hdGWAqrm6Ge9JO0CHdaHQg=;
	b=fP5rlKE5lyrywGKs+RslEWd3uNCju2Aui/X3/q96z82CnzEnnD0daYtlFf61yrdHhubUgO
	YGAi0aaBT56yj3f691M/9BgwIdnz6kEXQpB2eVOnCPfLEe0sPL2mzEvK0xgNVL9D1cF7h8
	GrbZqdL1mSTU0nLVJctgcpMZzXa99+Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="iMMsJQ/s";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786472630;
	b=ST7urM6oIL2fmAmxAL2/jXeMSLhlbaeUV+Rg/09NTO9OGBRCpFMjGiapmeg4UQcwKP4rvH
	y67z9QPspVnGgg5ohJZhedwFLSQ1fEMtK5jsbeRoehzxbXhQddGOA4UaIAHYD0AX22rpH5
	bWpA9FQHS+e3ZoQOf20XQt+hzd81moM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 031B743D28;
	Tue, 11 Aug 2026 18:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408C81F000E9;
	Tue, 11 Aug 2026 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472628;
	bh=3TBsqf62Gp/AR2GFXLRO9hdGWAqrm6Ge9JO0CHdaHQg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iMMsJQ/sSMP+Es94jqC3ZdHBnJ4v79SkduumOhjoUWhjn4Ej/NxcJLK93f7wccaYL
	 IArkxdEmZWKI+LKvUBEpdPcdnVcqChtXWJzG0BKLFtgyw1zK0YPhTxrBgzbXpwg3vw
	 bpAUFDXsqOFYMVLiCbzPF+g8nTZFJbuo7Gag8HgE=
Date: Tue, 11 Aug 2026 11:23:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 0/7] mm/khugepaged: several cleanups
Message-Id: <20260811112347.aeb004e62daaeeaae98b6502@linux-foundation.org>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3EAAC18000D
X-Stat-Signature: 38fkcxtmgx8dmpmhsmen9zxd617c4yz5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786472630-848425
X-HE-Meta: U2FsdGVkX19cGPvIEXJfLJ15nwNhbtWIjmdEm/z4K8OlCdYfctt+YztKfqTUl2ftbOI9TOwfv3EcyjEG0U6x15pX7t1OqFYMbaXT9cTAraCLxJj6g7865aWzLXChCk87nhyjJ5E21hm1qxwTDWi176aNJuRYn5jSHlbY6/8HY099YDSnOqYGS99qgCYLNPpwEDFXfY2nmQUPcRpE9h2kjsoBdPuXBpVUBhEUcQtv15RvSW9+u0sXP83jERZHitnYtvOA54mibPNAh8QoZMq+txpVHcUsihFRbNJ92TPokvQV+th+l1FuzLFzzdYkWatztw7zPdUJDqJdq0RPxW6/zsmvZ+lIqK/+htVkKTZxamuB/tY2a2aw/U5xpuwAu6JxiiF9ncO4+3L6X9c8Hk0RCLtylMQMymQmJObjVpEDJuLjuHrDiijbpqBjkukUKtd+9IOBEy6mQIn27LihnvmbroocmhZRo774OjPW1UsRwV4dPmXsch7zzTBgM6vVNeE1vNOXGYbVJd9cr3nhzm1e4D7zkqtyi0Yyh/iqqWdyU4llOkkAuNgcamchrXD9QCZluPF6hYclkKiU/UTGlUUn3OCkqkCSS/N5dzrpRBn8TZWa1prbi5vlKkqmVe4WYOnHW/jIZkR5u2YSPy4hz/Xdq2DkrltaXzjsJg0CZQo4P3Y8km+tvu0VT623NG2oiSwgkl5B7Y4Kslb3ESYyMiJ4PN2hYBDRMLaooCbwnoubtUGaVLmMcDJQVwlS0nYrI6AM7dyYWvVUut1B376HYG7RImSZIUk1eTqG4IVyhhqa7mEtiQeHMXa/VfaGbE+xUq4sprVliWplWgXVkA1J10RTVIfySkvog3KblGPzZ3+NMlKfDAPNKLI6cTk3/+nirfpNyZVYogmSo6lh+d6wbAtYohkOg3HYofCDeTxAZVtmMRQYQFE4F8f+SGrevusxO+JZPY4Oy9/ijQF4EyM1hu3
 WwkapXyj
 cH9/BekDrJIfSPpJomF6cI2cpmhcTaQHgwV+DLsu4ICvhgv4LNBqz8SJRhUFBmDRSG9u9vHlbKlNd+XMf/MsaWU05Om+VPl4tFWc55PBmMTUO0HxWhNhb+QTwFn9KB/MN9NzGAkKOuWu9kkV42w1UAgJnTTpa1/qkf/Ettun7t03lt4gq5lDrH6/hoWYpntUig9NvFCpCthJbMkW4Oo0zbXTy39jKo4a53Rakzk4YetzN0IpSfXjAlnlnVBKzWpVuvpCF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 06:48:32 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:

> The following changes stem from a number of reviews during my khugepaged
> mTHP support series [1]. Some of these are minor code cleanups, issues or
> reviews that we decided to deferred to a followup series, or in the case
> of the more major patch of the series, changes [2] Lance Yang attempted
> while my series was in-flight and we decided to wait till later to try.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes in v4:
>  - Add Acks/RB tags
>  - [patch2] rename pte_is_referenced() to folio_pte_referenced()
>  - [patch2] keep cc->is_khugepaged out of the helper gate
>  - [patch2] simplify/clarify the helper comment

Here's how v4 altered mm.git:


 mm/khugepaged.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -693,20 +693,19 @@ static void release_pte_pages(pte_t *pte
 }
 
 /*
- * pte_is_referenced() - Check for enough referenced PTEs to justify collapsing
+ * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
  *
- * If collapse was initiated by khugepaged, check that the page has been
- * recently accessed (young pte) to justify collapsing the page.
- *
- * Return: true if the page has been recently accessed.
+ * Return: true if recent access was observed through either the folio state
+ * or the current PTE mapping.
  */
-static inline bool pte_is_referenced(struct collapse_control *cc, pte_t pteval,
-	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
+static inline bool folio_pte_referenced(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
-	return cc->is_khugepaged &&
-	       (pte_young(pteval) || folio_test_young(folio) ||
-		folio_test_referenced(folio) ||
-		mmu_notifier_test_young(vma->vm_mm, addr));
+	/* The folio was referenced previously ... */
+	if (folio_test_young(folio) || folio_test_referenced(folio))
+		return true;
+	/* ... or the PTE mapping was recently used */
+	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
 }
 
 static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
@@ -910,7 +909,8 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (pte_is_referenced(cc, pteval, folio, vma, addr))
+		if (cc->is_khugepaged &&
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
@@ -1790,7 +1790,8 @@ static enum scan_result collapse_scan_pm
 			goto out_unmap;
 		}
 
-		if (pte_is_referenced(cc, pteval, folio, vma, addr))
+		if (cc->is_khugepaged &&
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
_


