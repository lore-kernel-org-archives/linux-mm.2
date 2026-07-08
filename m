Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA9BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAF46B009B; Wed,  8 Jul 2026 10:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691936B009D; Wed,  8 Jul 2026 10:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7676B009E; Wed,  8 Jul 2026 10:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38C886B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2C4A1C0DC6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:32 +0000 (UTC)
X-FDA: 84965797224.19.53E065F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 131A010000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8L481O8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5aEZlWJMk1RITDuZR/wsK7LI5ceGlZUSm3ZY2ggjRs=;
	b=rC9dsjoXr+OAGsvKIf7XD4Ub9DazEelJzxdtNvVekKidtd914emspGN6ci1mDmb51a56WE
	051AqNO965YBDgiJHbhj002pzOETCsBqXAg0X1WgmagXJvEbbPwB9sUH9qT2AwPXFV8D/c
	f3plFy9cnXEC/rzZIHlRJ9Bu6N8UPyY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8L481O8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519891;
	b=k5p1p7cAHqpn18s/4IRS1RxxV1oWDU7+g0TIn1cCqwd0kOt8Pp93kqpLYXR7HcbyrRfiDZ
	tK6n1F27TyYXEVKqc37K5dPGaAlNCjAINhRdb32eqnIFneoR4Gjn7kRynBmcrucqpIhTtj
	4JqMfwwwErxraxF9EwhOt9Yq228aWMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A88A6001A;
	Wed,  8 Jul 2026 14:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AC01F000E9;
	Wed,  8 Jul 2026 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519890;
	bh=O5aEZlWJMk1RITDuZR/wsK7LI5ceGlZUSm3ZY2ggjRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q8L481O8cXlYqYV856wc5MZ0cmUzvzCU62QcD+EXEiG6tvRKWeyXBkZyUlxRZyYvW
	 Q0aLFDuk9B2+VSLd9IuiOUW3VSlwPQ8rYpn2I1PaQNsR9AEFZ4RAH2FpqvZ1PFuCZD
	 Cn+2Yfr2JsonOLpyX1laA8yFfFm4c3IWrzmit1ThomLc+oIA6dGzwVAEjnxFld5GSc
	 BmaKvwB8NrlJeVhCGZVv7AY2Y7zTx1TTKvB+uHazm8LFhd+J5XWy6LBrvgts2Ne+Zl
	 AaT3280R7y+kfYQKoe9TQXC4F8i8jbteoI/4Rm5oc6P3Rd+picOdZ/VAYBjvOHFslD
	 rFfL8hAn4MsBA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:10:58 +0200
Subject: [PATCH 03/10] s390/mm: use free_reserved_pages() in
 vmem_free_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: g99oc9cp86uj7e6f59363rfpc87q9ast
X-Rspamd-Queue-Id: 131A010000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783519890-450296
X-HE-Meta: U2FsdGVkX18zJeQX3qoujJ+IlRoJmQXZY2auoAxiB+/uiIkGPtbfMXdIWhQLM9+RCQ2hEF9j1y18JgY/S5jVcJ/iVriBFBtMMaqsWrQAJb60GN5omNSb32H/sYWHJinyj6VniCzMgm7GY2RJ3d0jDkR6zRn1A+wEUwaCqta6HL+nrLbyTR332jvtEA3qcA+936I9vjUaCb9e3HTtz6IwyqM7JIweGT4UOMWmJCVCq/j3QdSf4LoR41gHl+tJz3ommjVEFeJRw62+s+hV2e5Tm8xkMq+sUUIPpYS2ZanYRVYAfL+mgVP1n3qQ6zBIQfTstY1h41eLLMByhigxyyNIyywlqy3m9VV/GHAZGxr49E1giwaYze3DtSc95YjH39FUpOAqdE410TT+aup84DlD8YrjOGxOSwih1L3Aj98+dpINszVHEs8uOvrwZuHWZldaYwtWYu/1D7d+HD7sM/gvtY8hDIPvwvECV6GTYwo1+xt58dj52vdT/0G4P2Ad2LsYGpALOxUeTzFSIfnFgeEmxKfaHKg+GKcINijDtiRFl0ow2PtUnHICxgBKoqJYZbSFK/WNwjhnB/rsjUbXeQ8UXSq7scJUK6D6/AxZbt2c5db+t/gGbLeeXDHfjvDUKLrB3SkW+F7AzpQ5PKbcK6uuwv+WlqEn5i2cYBvQHmGHCwirAFDtPYXh4koeHAKW1Oid9rt92ON3VVu/FvgzCl5v2nYXqlFISZQiczmmGdMQyoI2RIVjjLJyGkBHaLVHDjZnz93/B7iYn98Fu876e1uLw7lUllDB9NiWsAkKCnPiQOHG4zdSbY8cSi9so3OfrHtSfThApDMBnpEaRAQp2Y68xO7mq1fB66kJ0Iul6D43JvrrLU8HRGIj7iZCJ/THqauYErsVbIJcbdTKU2cRkpCpri7yL3POxkpQU7yoM4a4Th71DjRq4E/ZISA2odhqolPBu8gn+nZnw9l483bM0cc
 DfuCX0Wm
 qL8RasipK7wNbIc16KqKpQw/MeaJP14uW7I1OJkQ0fAQEQkTppaOQdymis8943t3TvvOIGltmRbusGtK4BtEu0z61IeyiNgcqJr8JXOYOWmVj9+ywYssEiDVvPIfG48Ztf41ZE/4FXtLdTz1Dnw+sPbmIwpFgYj5yp04l//DMKPCqeI0tjgB6LCPp72h0WoxN9ic6m8MK2Rqe1g2DRp0RRfMoJJ0C05fy+deRVK6y+lfhMm/YQEsH8Vv2hy8edEodm2AvSxrxUe+DeLR2nN81scBIZY/RuR8xEXOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's use our new generic helper.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/s390/mm/vmem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 94ee06ae89134..d2879ce860a13 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -39,7 +39,6 @@ static void __ref *vmem_alloc_pages(unsigned int order)
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page *page;
 
 	if (altmap) {
@@ -49,8 +48,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
 	page = virt_to_page((void *)addr);
 	if (PageReserved(page)) {
 		/* allocated from memblock */
-		while (nr_pages--)
-			free_reserved_page(page++);
+		free_reserved_pages(page, order);
 	} else {
 		free_pages(addr, order);
 	}

-- 
2.43.0


