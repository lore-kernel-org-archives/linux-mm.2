Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A50A6E748EE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1779E6B008A; Tue, 23 Dec 2025 16:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122D66B008C; Tue, 23 Dec 2025 16:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024A76B0092; Tue, 23 Dec 2025 16:41:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E809D6B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:41:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA83213106
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:41:00 +0000 (UTC)
X-FDA: 84252056280.20.EF0BFE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 378BD40006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:40:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jUIXYIeb;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766526059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AcVn75gfO+YB2QS2FMEcO1WI3ZaIE7NZoPPieahIDI=;
	b=xkRKLVP8sWPmKjX3FhpgApHMBuWhzZrr0daDy7sfnbhJIGJ9ITxs6tRgTeV2Xo8MOM7b/W
	dNqd/L5CguuPJheHfQXqR0/p+6yEoORgIfl+lypqjMTQRBr2/ZDwPTjPJQbuLup5+tF3ei
	95r7NRm7xwHqeCV1rD9H65IKVQiiGGo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jUIXYIeb;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766526059; a=rsa-sha256;
	cv=none;
	b=SScyJN9QC3vRwmfdGqvnx77XIAerVUprM9Ow2QlmpdKuHKUAg9+yw9fW7d8CRDPAJam9h2
	a2fguQqBjnc4ObVouXMqyw++T6SoPCqUpl/rRTQPbnCy0fF2GANwRcLVDNdzoznTo/vrwi
	fTVduNrfpgmSNiGcb211f8kMmCUicMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B466460150;
	Tue, 23 Dec 2025 21:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA7DC116B1;
	Tue, 23 Dec 2025 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766526058;
	bh=33B1NjB8q+KbqoS4RdUZuJYWp5unOxxMAqt5/OJnfDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUIXYIebTCcU7qzG31s1vtUtkIL93DwXQQfDphjUnZS4//aO7cOtjf1CSTBYzWY2e
	 aKSsrhiHn4132dbDLvmKMK/+q573s05LDP1qpMId4FzEQq29sKmxtCT4a6fdthYdyv
	 MQIcH1vXOOeZAObt5YhA4u18sG+Zk2HWg7TXGC0lRAwSxX/SD6sbTZRkTqIvfmYc4l
	 wA1Cm2LAZMwiRebr1nxJgoUZjQqo6YRQFvcBCk6zq8jK619mTm12VjbNldztdHDZCp
	 vEDjLXcsy2RdgIKhknKNXfUOqV6ei8JFSaBvki6RWyPJVwZe6dsguVoJ3rVyceHnWn
	 Y7z6ehGEPH0MQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH RESEND v3 2/4] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 22:40:35 +0100
Message-ID: <20251223214037.580860-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223214037.580860-1-david@kernel.org>
References: <20251223214037.580860-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 378BD40006
X-Stat-Signature: tw1aw5g3hp956yy4g7pxnorxp9thww74
X-Rspam-User: 
X-HE-Tag: 1766526059-210155
X-HE-Meta: U2FsdGVkX1+UuAWq8VIf3Yf6w0C/1DpDJD11Y3Xp8P4UNaBQhwaJ6tm2q4O0BjdfeBaYX4TmUmRkTP8SRrP+VHa0MtfZhCQBi2rVdR/+vbXyUSdRV3I7VgwcUFbf04N8WM2zBINRt2xO4n9WMexd9r9H8aaQ3VHAhBG98Sikr0ghdhhwmQMpx7OygCUoPJcBn+WjcozbDo30RQDqUAYvHuZea/Ect2dFuIrxabUl4mGku7513BpxXstTPQ/soZS2ZgtSfndNy2gYiSWpsInr867mlnCZjiMf0LaZV8qlsBMGgNzrCXFXMwfFvS4UoJJqtTzc4gwr8seyhnmAHp4ggOc/A8hGTZUMH8v6gbaz6i+ewdzRh99feiOIk9alo3k60Z6Tuk0vs1MLqAnCF2jPGvT0Dwl9QbtdBBqEzVDQG2wv4Y1svBDtPE1dU/0n7ixBDFQfyHo855CYyt0UvgF20cDLKK8mG0EA5CMIJ8ziNlDm5TqQoAZppAtEczG4GgsXrdQzVTtzgOe/DxrOsFNpnT/TNcczFBEoeGcdTF3K6tawO0GuouNKSWor8h24+dPl0ZjadwCgUGsF0ulj2S2nYhepictZ+XVxa4mb+uG5Bf4UpC4yR3O5wZMLpEGyyQMFEDAi+WD/P9c4tQQLPhDlY4KlzxTnR3BWbS5Q7P/l/40qBTyoytl5RAwDo7MY0G6mwgaFqApmGhvqvWyIaGl0we1uBPS6nJK/hdHJU/7vlKXvRh8wcb5116GeWQTj8H/MjiYSN8JjQdAl4WPb0bWMVkAVappR6A2p4u7lyWHg2FVZDJiRtTsGusUjZhs5mvxnCs9E5XjIA0WH9wXRO+o63QDw+fze74i43e4ufIMMi0FW6I6bWvCg4GCYZVIrrgMqJvX6XsNCME1bekqJn45/bapKZWWWiLAhedATaCuiVMUsO9Nymg9mXKDYYia+zR0KQtwXUH5EMsqyTvp7fT5
 6nLAII1m
 Ei5k6pRh0GVYKx1Ual7ow9TqgJ4E9W9FWXB7tm6aTsGAm8qPNisuz9XsASH9zovsGX0+Pe309OlpUc3hDw96XpEWvPGMHb8MslvTGigJojVNsSuQ5XwWphXp1UqR6rOtblL6I1XdEF7x5CjXR5POsMQ4+EoZZ3fl+L8Dab5NhqH97fVmLag1SeoC8zPbi4Q1XW/dkfmVKMqEnYdV2aq5zQeZ7Voj51wb8IsFNeYRYEGACNSU1oBXCvfCxoqZ7O/dW0Eok1rEeYRjXF65hR4AjYsLaXQMyH19JoKZOjPd4NRe2bzrZ/yBW5h5Y77+hYSQXjtHlm+04USzUuulMTatH7oHM9s8v02reZ+WwnzGl6Pnw5mtBuJokUbGN4BTtKhLy7ZlK0n0zp2BUlbg2D449CpY8b1bJumPpvbj3YKNxqlX8itvnYvkQ5zMNkOUDYi5/3bs+2Px5fbhBiQf8V6qgKCYFI7wWvbudJgzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since we stopped using the page count to detect shared PMD
page tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop
the i_mmap_rwsem, the previously shared page table could get freed (to
then get reallocated and used for other purpose). So we really have to
flush the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded
in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
anything. So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/hugetlb.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5d..3c77cdef12a32 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -6536,11 +6529,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);
-- 
2.52.0


