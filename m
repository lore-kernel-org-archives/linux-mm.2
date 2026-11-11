Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F1C60A3833
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDIVWdWa
Received: by kanga.kvack.org (Postfix)
	id 876CB6B05B8; Wed, 11 Nov 2026 17:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F0B6B05B9; Wed, 11 Nov 2026 17:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7646A6B05BA; Wed, 11 Nov 2026 17:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 500036B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:00:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C40C41C3BC4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:22 +0000 (UTC)
X-FDA: 85424207484.29.27DB859
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E98F8A0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDIVWdWa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434421;
	b=lGqBGO8MTaHd+ZojZ3R+UJk7QkP0e3S4ofAKRwJ/5Xc2d1mULPnili1i5kRpjarQx2v+Rn
	kKslXZkjnCO1g1zvbHD0vZnpVWOv9R3FvM/kQvXFnG8AXE6zkfAPGcYlimnSHtgX9cbesE
	DnbSMZTmj/EO25un7PF1YGtogZcG1JU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsExlSronX8FZ2ybTbfKUty77l62irOlolHhcJPSkxw=;
	b=nFW+jsJCJ6vv8loykyFde3kxbZAWI/fb76PXsVOYcgPWi2sdRywC1fjj6cFoPndVoYC3Gu
	129akyRfhTBapOJwv1zaH4dnk/GVxImyeVSv1o2XVKr3BicaiQ5w8n/NNnL/DJlGNo008V
	OXflZ/NtwAVSCl4u5ye1BIkvXtSxM7o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDIVWdWa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E64B141809;
	Wed, 11 Nov 2026 22:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6884E1F00A07;
	Wed, 11 Nov 2026 22:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434419;
	bh=dsExlSronX8FZ2ybTbfKUty77l62irOlolHhcJPSkxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YDIVWdWavpLnnBM/PFAhd6PZr/mwm7ExUTFbVqWP5Ajf+PUDNv3s2IdtQhOTxpBe8
	 aPFJA4v1lMdr6S/XNQiknu+li2y8nXgZvpzj+1kpwTZT5bnGRJnymA60DoVgQZu7kv
	 inKony10gi/xVZAHVoAacAuibhztE/uJzhPWaaGIYI6FLeyzVFRsI4LUzuj2V+EsMp
	 SNVRhLKFkwWclKwXMBM48JiYIZPCKpwxIQw5mpS+nkvsA/TGR9IizyqbWdbs6Mea5q
	 rVyKST/Axw6CqnU68kKHo5LfMht1VWevDU6mmcq/f0yf+kc7dAvMtBE1ctSAYTWVzz
	 LT29YrgRgxWYQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 11 Nov 2026 23:00:00 +0100
Subject: [PATCH 2/3] mm/rmap: fix PTE table overruns during batched unmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-pte_table_clamped_end-v1-2-2dbe339c487a@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
In-Reply-To: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Peter Xu <peterx@redhat.com>, Lokesh Gidra <lokeshgidra@google.com>, 
 Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1207; i=david@kernel.org;
 h=from:subject:message-id; bh=NCRqXSs2UWcZHc60tsEtuDGoKWTuIDJIrKjK6A4XeBY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+PE2deoJdQX9NVHVyydSpX9bPvrvqK1Pl5/I3s9mNg
 vdt9DI41FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEFrAwMvxln3TllKr3j0OT
 vWbI6X3n6Djgs7tRwsI/8b2hRt7E9fMY/me2SHBI+D210wyfE8j8y0L28wwHTbVZa+7wuuxlDjd
 R4wYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: E98F8A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: k4xu7mjzghhum8hwttrbk4wmh18irdr7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794434420-608446
X-HE-Meta: U2FsdGVkX184oM5miPDU6JUZMSy4zw6cl7PSRWxYg5nderrnLupdhcSY553i2VrEgaIWfUJceBY8rAZCw/Qewty00GdutZJFbLQhW5oU+ZJ/vAEH1p+P53vpQkRaS6+ZL+nPyril00cYveWoMtc32+CINQ3oObfl0VA6w0Vebw2PDP51/xQrx1Mkrq+z6Vk3zx9dxRd4dL6HSO2OzGtXzLiGq4NO3BMOq92XY7DOpADddW5MfBmwVCb2UAdGr/ua6F65QNKbOgJU/jFfbCnIGA8XVCmuC8zR/BDvFUbFJ/7PFK5CkdOUid7R8iZZjNWtZiFfBUppWdLTnt5UtK3OubJvEsL7+q6nk/SJWy9r/v/MouIwG8wPMwunnjpeLIcDO1r28Nj3EqLRmfPS1RVhgB+E3dxBmEg5nc2aE1EXYYr5WyejEKhDu4UQR1FA26k/X6l4EgogqjY7f+3RLXWf0imQSvk9nsN/cEJDubTk4N2qakWcd1J5Ezz551ly79ydU0aFw0BkwalsZYl9bPMgNNQ5aTc0FjBYPCawZ8XB5YJeZDySRftoAHkPZ8r5EWDr8vbq3Rc64IBDIIxqfaI3iRipUWBNHCB0YWRxfFnbni9dIOu3IPgdV7pPD1NBwM+5Kb3XVcWV64ENM23AOCbCP1blawAIyHvpTEc4d9QY6bZHqyLpzPSkWdPNMh111zKExsDQ6MHUzmG5bhRhtZ+s9x5Pb+rri3BUavJzX9yxOZM7hA1BPNDcERhdhSqbcOJSUcnGJGkcZoHNOv6dZEVFsPkYtD/LZ1Jeew4ji/YIQgF1RXsGL7oZfi86I6lGYCVW3dbnVySx2olMQfhmaRjDshfoKI38kj31Btfq9tJdqhr/bK6AoABq+Tko9Xs+6W92MfhI6zmScyZ/gzbTIGaI9AT3Lp7Buw7yXr6WrYK0VRnZUrPbguBzue+0gpqJqLYfoVgHvqZ36d2vcWYQEXg
 DJLky5YX
 32mTN0Br0rkMAFN+24nPs4BH8diz8QnFxbkGcG6qcYe4DeU4CeeLnave6EJ34YcRrkFfy3czLmVKsz+vuUBytFfjrSj9FNHPqbzLHCB6y4UqCbk7OeP2Ep9d+H/f2aP8f1quGTQ2pL9Pn6+2M6vUEHYaxzLZcrMwQeLAr387WKHj8G5Uxux8hrgOYbkRBEeESm68B3TWgYEY7qes6ma6FViDijaa+h+w68gzsUScLh2JzkecL1gTNK2QdmnJE4CJQXBSAaYVAMzqh6eFNoOccOSrwputDKGZSlkJ5ANNbo5SPeUSoAePoWXlfe/PddAg2IVFaIcsz0e4uh2DIHzO05/qof73a/XuQ6sQ8ET527r5fVPUx3Q5nJ7c0ZFLjDfJrBzRmZITK6no2ANA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With a folded PMD, pmd_addr_end() simply returns the supplied end.
folio_unmap_pte_batch() can therefore walk past the PTE table when
unmapping a large folio.

Folded PMDs are uncommon, but can occur even on arm64, for example
with 64K pages and a 42-bit virtual address space.

Use pte_table_clamped_end() to clamp the range to the PTE table and
VMA boundaries.

Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0faef46806e5c..491a954b7fa44 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,7 +1978,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 		return 1;
 
 	/* We may only batch within a single VMA and a single page table. */
-	end_addr = pmd_addr_end(addr, vma->vm_end);
+	end_addr = pte_table_clamped_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
 	/* We only support lazyfree or file folios batching for now ... */

-- 
2.43.0


