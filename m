Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03C4606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpWp30tP
Received: by kanga.kvack.org (Postfix)
	id 0CFA26B05BD; Thu,  5 Nov 2026 08:11:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080036B05BF; Thu,  5 Nov 2026 08:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB16F6B05C0; Thu,  5 Nov 2026 08:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6F2A6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:11:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66C21A7D66
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:11:00 +0000 (UTC)
X-FDA: 85401100680.23.5E0F7D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C0A2A20013
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpWp30tP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptRwXs+qFV9fEGNsWtKWJXuC1Otq2C/mie9e+Nydci0=;
	b=b/QEdzDHwJLO19/Euwu4/rh/ipI7sqqsldOUBPhlZMA4WXjEZYYfkp4peqGeeNZ1wPyG4c
	AOC2DIUke3FrfB1iS7fxsjKV2F+t/ZOdpq3JTu10n7Z4/LxzXXlh6+uhZY2y6jUrt5CFyt
	2gzPT4OBDEGK0nVhfNBrS+Di9CWhMAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884258;
	b=kC+mQrqkKan4U82hMIXxunw48z3QQ7sMxPxTpZTl4foSJowtQjOmv8Bzkce6XFkO0Bt8b1
	hXF3/ukTaluEjxY/wEWl+pSkthQ6hdLb/EgPsvlla4EqS8O5XH7GOeGrowxn84vL80zN6b
	8qxzNCTYdDQpTLmB9L5kpwlAkXZgmWw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpWp30tP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C15DA409A1;
	Thu,  5 Nov 2026 13:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1031F00919;
	Thu,  5 Nov 2026 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884257;
	bh=ptRwXs+qFV9fEGNsWtKWJXuC1Otq2C/mie9e+Nydci0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JpWp30tPOH2G0O7Q+53HnI7DrsDN+ie7Vbv6Rj4tMlqFaLM9bmEK1T6UnAYe0T+n8
	 Lxhg1fmeREyo7PFhObfrNFMBDkFQr3eiPTRGEeU404BRNBFNY5Hfs6OvoyfiGElW61
	 k0gcU7S6Q60oMBRO5n2xqYTFyCyPBWSfG9pQWC7w2hRzaF4dWRjLtNStY6CXae/TRp
	 1zPwa3WISiVXwWwEs5LpLTmc4UZfgiLPJEj+RAh3a4oOTZ9PRFhkvhYuC7RII3w1L6
	 QcT3qA2M3XbyI2uYA7meu5Nz83wgTYHVmiExh5WvyJs8Wm25X+0HOrz4YH5JGyk/yP
	 zVUURe72g+LBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 14:10:12 +0100
Subject: [PATCH 3/5] mm/mmu_gather: flush pending references early before
 the folio limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-refcount_overflow_stable-v1-3-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
In-Reply-To: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2738; i=david@kernel.org;
 h=from:subject:message-id; bh=MIAUtxrNu7UMyrPfJ9US1972uvFhMmrdah8Cfagy62k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNFiq3/mjLcK9MvXw3uXbsj6veW5f4bigbqJ15pvXZ
 8PfzbY36ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi6zcwMry2UqzpjmZuylT/
 eeLMYuYd3u2qtYsWsJuvPMy68MCnoAagiuD10075KxZt8v7A+kxYMkBt1qGF6xXVD+26n75zafd
 iFgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 4a5zb597mosgktdmpsmnzbrc8uiny31d
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0A2A20013
X-HE-Tag: 1793884259-459651
X-HE-Meta: U2FsdGVkX1+56YGidrPGSyZfTyBznoX+5Ou11uPQPws3OyvajaLXKpJW2awX0bKUFyhjzlXP193op4QkS6zdVez3JO8kYdwPioTDnzoKf5TbmZnyXgn4wlUtn9nRk58VyV5GDYNC934WzHaiLnkFK+A3CvGDv1+KMZqmSteJKn6COy2lOdzN605aO5gFpudCNf9MgI8uhCuKVevSPjQkv6AnZ4HdyOePl5MroTBLQ0WP8aWVB+DR1kVj1c+NwroBNVLV5ieA+ATC8Btmzy+hZZxjx9GEP7lEzXOOQYAlQSdVW7sVy9ccGmPz263HdZlALmLdQo+RqRh9P/5jFQp1JHtIXymCJGI9Qu7mDI2MNxZX1E9S0i1xK4HJY/Jz1Byqu8BvLQPElg+juWW1NcJWgggPnSkjs8yLcIzdsXAjzacb/7pdCTye4kK4b6JAyafkl2orU+0RArwSuoH74j+YYxspoyKrViXXtUopKZgUKkOb/hL/o9lzWMPn9536l7XDFCcMMDbYdI07V5asJY1xDHgAvssd2lIPk7y8NO/k0hVwPCK6t3pdVDn5RTW5ldIbUS3xy6hFA60so3/TWKlsRQfUB1W/VJWufeKdnrw+7z8NqJ8/Ts8crtSgBKv0zUeIOMg2YwbPROi4ztDvMcHLf7vxGmTjZBd9MFLwfo6B4egE7Bm9B5cuvoOkDRqDUuLYeVvO4MFWS98HRz3sf377hf/i9g/eJF537VqxppueG9FRX6FBH9hX7JydR/nmv1HHMAqDZMZOYgZPP86jmiaxoIe6WyT8+jMCl+nowJ+4ByG6uewKG+OPuV2G8Rz9OA40Ao3lAshMs9VN2leZjRtXwC4+hTVRt4jK9b6p4sAn772v+9y50dkhj5buNRcizpAnhG7ELZfjybEdZgvalusLN8fdOSXXldcsQx+nOFlXQVuotstB4PFMVCN49edKoZZYjZvzquduae2/t9Z8PZD
 fnp9ff0o
 2vVBEOvkodr4+67qwOWTw20R1Ql2inGUurBNcpCx3njfmJK1wFcnwyM1nqkxqtrDdPberppthZweYMoVT6/A1BI3uvAXy9WyW2m8ntnzcYKWovZGUo2nea1sf3uvLey5z/epQIhbZmIJICI0MV9kUPbyUUSPDWklHphAN27bnfwecwl9cGXMI2xCSsyuNjrW/0gTLsxl9vsnqwEOR0jEXaUjgR79nRdlPkWP8QTioklwnE72Q2T3DA25SR1v79ErsZ3wwKeQ06R0Jt++2MDlQB8hSNUl/WrYdogm9LBZj+eT9oFXzc7rLahOQuA5PTmuzUETevNVoPLA6Nwk2Bii6OaWFBy1M3tT6J96nk3B0XBBb1WjpHS0LYPP0yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a task zaps mappings (e.g., MADV_DONTNEED), it can drop the PT lock
and defer dropping the folio references. In the meantime, page faults
can refault pagecache folios, creating more references for the same
folios.

Let's just request a flush after enqueueing a pagecache folio whose
refcount reached a certain threshold. Start flushing well before new
references are refused, regardless of the caller's privileges.

This is a temporary measure until we have something better.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 10ebac4f95e7 ("mm/memory: optimize unmap/zap with PTE-mapped THP")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 1 +
 mm/memory.c        | 4 ++--
 mm/mmu_gather.c    | 5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a82cfbce18215..87f7646a7f3ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2232,6 +2232,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 /* Leave separate reserves for administrators and concurrent reference gains. */
 #define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
 #define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+#define FOLIO_REF_COUNT_FLUSH_LIMIT	(INT_MAX - (1U << 27))
 
 /**
  * folio_ref_count_over_limit - Check whether to refuse more folio references.
diff --git a/mm/memory.c b/mm/memory.c
index 4800a0da14a32..d2eb313832559 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2061,8 +2061,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
-	 * If we forced a TLB flush (either due to running out of
-	 * batch buffers or because we needed to flush dirty TLB
+	 * If we forced a TLB flush (either to release batched
+	 * references or because we needed to flush dirty TLB
 	 * entries before releasing the ptl), free the batched
 	 * memory too. Come back again if we didn't do everything.
 	 */
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 9f353f0e2ef4d..5988c42cc5144 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -190,6 +190,11 @@ static bool __tlb_remove_folio_pages_size(struct mmu_gather *tlb,
 		batch->encoded_pages[batch->nr++] = encode_page(page, flags);
 		batch->encoded_pages[batch->nr++] = encode_nr_pages(nr_pages);
 	}
+	/* Flush pending references well before new references are refused. */
+	if (unlikely((unsigned int)folio_ref_count(page_folio(page)) >=
+		     FOLIO_REF_COUNT_FLUSH_LIMIT))
+		return true;
+
 	/*
 	 * Make sure that we can always add another "page" + "nr_pages",
 	 * requiring two entries instead of only a single one.

-- 
2.43.0


