Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD01C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C893A6B009F; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C586B00A5; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3ED16B009F; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 474B56B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB597160269
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.08.B1F980C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC62CC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kr6wGEVE;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGhqvG+S1MrmtwA6XUf40924GaUrOk7QRjxcUzzl0Dg=;
	b=L0FgN2w26d8nRq+nryPfT7JNRHHpJ/Zs58XJhdYbVIbdzvtjJUwjOnp/TTSMbpHQV3oPQB
	XzATt/AItnM1+DPyQYOpEdVdn2GcAGTkJ1z3G0pAZzJJuX6yyrFSovyWMo89KuK+20FOom
	d+ZWCFmQ3CVhoVxBcfNyR4ePmco/VBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=NVC6iqUG/H56G+HrrXKXFHPyB0KBn5bZSvjIScqe6vFR3o6h4al5KZCRrjDs5Q0v+bBg5M
	sJtMKN+GgPw8BAa45pxVFGueehWZANNO0+ot16gnRvB/A0cvmtIvFvQHK8yBt+ViJaYQ5T
	E8ZLPmEb4WRK95jLvWiLrPHVwS9Li3k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kr6wGEVE;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFBAB44791;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0B30C2BD04;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=tVWK3YtWyyptpKhnWj6y5t/GlQNNfc+ftcR4tLibrxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kr6wGEVECmEJrJvPwdah5IS686Rbp0sJcBiUfhIGIYfarDpM5kLB8tM2ulZP13LNS
	 gap/EuUun3lfOtDpaYESOzVeby6z1Cg324WRQW9PKny7DrcAUybRjH0DCnspSo+2jd
	 veIijqfPwtv5QpZflg0IEDfkV4UPS/v49MFQAgbCIPKWw6pnIjY2II942dpqtFnH3+
	 tuFXT1fmIdMjWrWNEhE2Cbu8tEzkmn59/mm603RKwEpurY90sXo0JbJgtiVMv/QaNO
	 INdArTw6WROhPk5Gh09lt/DB4B6wJJjegtFFCafqDsPtgHIquNgH80nN39t6hgjrbr
	 hK1TKWgT8ByBg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA92FC79FA0;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:16 +0800
Subject: [PATCH v4 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=5440;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=X2P4cDrUHVxhy5NF0vdUxXcb6y1qZnECR0W8Rgpwvlc=;
 b=v8Z0yYqIgMrwAWzCPdCTt0cJposY5TVpHL4ti7vOOeL4283+2IhgBZV5PBP5qd6T/i0Ka0kMu
 OjJxe2nKqfyDOQk5+875jZzJVMipNoOkI8v1PlihNqtS3r3ng5Koyc9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: epyfnxrhmdodnn9cp63qxxb3kxta5rfj
X-Rspamd-Queue-Id: CC62CC0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788804739-417739
X-HE-Meta: U2FsdGVkX192kfsbhFRTWq70AA2pvIIANBPkbdOcf1QKjzPQfsIyRS+9LMHb33jlH+tT0h6B6mNdLtwSt3atVwjGLT+m3TEWQZRFbhfY4rpcFG7wSnThOeldlNfeUl8Y7tqkWl+Lzs0egMxjqOjwozOgyfGEWgPr8Mv36+Oe1E6+o2NYBW7RDEaAs0kYgvcIUCJWEDlTyE+2xkBvvBAaNCWxPkBj3vSOwLDN4s42sPcFoUmEPaQ32vYZ80+t8egq6t58emHDgxs/ot6Xp55OXzbni+RuEy0R9XxHyMRfVNg5V81nXOa6g3bFdi84JqSk97G6zVCLR7QGgSEwXhjIMvZ6oI1WKEV5m0u6kS+adi7Nhtd5SN/MS0LuBwnMuqyUjUjtrBiIuaj/uq1iido0cOqiZBYVbxefX52zUgTQIzKLacwYflE9A+CY0AoDwDIoiOHv1RXwRiEb2nAfZMGiOxsFxUvn2tvK6BSa6UT3A7mEI93tNpHP7mTtt2olz3TIU6+f2xLlET4o2rA5Rqin6qo0rPiMDxJn1M8DnLHWdHhA0d+5B91y2UaGISuO1b4Mh3sSxV0CMiW4JVEGxowvVzRY/t8gwPAKszL2x/LMC4mF5BxDYxrTrQgY/rdvP7oxO4p9C9OCLPSBsYHcr2jODe0lMy42TxPRXuiMXvf55ubjObttFMjG6t3SAMcZbU5inkLXGBcSOVjPs+tb2nZ2BsQhsbicieRXtSqopyUyBzk38pFSK8BsKoOvv8Gv+2Wr0Twrsi+oy+sHmjG3CivrQ8C2lpGH6ztcFKYSt+pbudawAYmcS4WBB+Arcw3hBp8fTirBknUbYSJ8lR0qgBPqslXo5JgRuatv2lsrLzLX+VVeGGdDVtpF9kVLZt+UxwsQhhHUUk+Mvmos4T1jo3HARdrH7SN/9z1NUsGh6wCV+JC8DmngzJjpUEJnsUr6SCaCPggwmSVcY7WK2D7HMBp
 +PekfQqE
 kSlDpcDwVptDbmwdORFCqx/Pyx31w5wZbiuXSJALu/pusytmvHyAQQpj+kX2lov4OcmKYIvdg4uvCGGmv1CTqw8fW/LpUxSCuMzeOASjHGymdEImaSbCqAZnF/qji6hmCOIf+UMUzUwLt+J6gRvQFQ0ZpPngbsROsS3yZ+4Hwc/VkALIzMB/yyzdxKBE65f1C4bS5ACakNljz6t19Mt9ykj9/MHdoqXNmQB3VniWDZlhMus1syGrjelfaqSQvBuplCqwlRZro+BepnpH2qx+XnP3ijnf7yK+i7Ai6ZuEyYd1lz2g0jjBP53eDuFwna4cl/sIzIg7kx3cyxN81+uprpt5Xl5XUb9SiJKhjRY+OV3vn/GkGLyLH0L+VDBGU60MBvIxnM7kIUdhZDCoo+LT3qS4dv2SkhsrM2o4WWNUPU/8E5V4/FCbNllFScKlLbokJduQi/4VQO3Otwkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only anon split needs the anon_vma, and it only needs it to unmap and
remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
__folio_split() into the anon helper next to the folio_mapped()
check that already gates unmap_folio().

This makes the anon_vma conditional on folio_mapped(), which is a
behaviour change but should be fine.  folio_get_anon_vma() returns
NULL whenever !folio_mapped(), so an anon folio with
folio_mapcount() == 0 used to get -EBUSY from split_huge_page() and is
now split instead.  The realistic case is a THP that has been fully
swapped out and is still in the swap cache: swap PTEs do not contribute
mapcount, so it is !folio_mapped() but still alive.

That should be safe and right to have because:

- folio_ref_freeze() below still rejects a folio that picked up any
  reference, a mapping or a GUP pin, in the meantime.

- A parallel split is excluded by the folio lock.  The anon_vma
  write lock was added to serialize split in commit 062f1af2170a
  ("mm: thp: acquire the anon_vma rwsem for write during split"), when
  split_huge_page() did not hold the folio lock throughout. commit
  e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
  folio lock a caller requirement and added the folio_ref_freeze()
  scheme, so that has been covered ever since.

- Unmapped path is already exercised by folio_split_unmapped(),
  and the swap cache split already runs well for a partially
  swapped-out mapped THP.

- folio_get_anon_vma() and folio_lock_anon_vma_read() both bail out
  on !folio_mapped() before taking the anon_vma lock, so there is
  nothing to lock against.

For mapped folios the anon_vma write lock is now released before
__folio_split() unlocks the after-split sub-folios, where previously it
was held across that loop, that window is harmless as the sub-folios
stay folio-locked and ref pinned.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c4910c0b6018..53614b875794 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4005,16 +4005,31 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
-	bool need_remap = false;
 	int ret = 0;
 
+	/*
+	 * Unmap/remap needs the anon_vma. The caller does not necessarily
+	 * hold an mmap_lock that would prevent the anon_vma from
+	 * disappearing, so we first take a reference and lock it.
+	 *
+	 * An unmapped folio needs none of this: folio_get_anon_vma() and
+	 * folio_lock_anon_vma_read() both bail out on !folio_mapped()
+	 * before taking the lock, and folio_ref_freeze() below still
+	 * rejects a folio that picked up a reference meanwhile. Note
+	 * a swapped-out THP counts as unmapped here as swap PTEs do
+	 * not contribute mapcount, and they are splittable.
+	 */
 	if (folio_mapped(folio)) {
-		need_remap = true;
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma)
+			return -EBUSY;
+		anon_vma_lock_write(anon_vma);
 		ret = unmap_folio(folio);
 		if (ret)
-			return ret;
+			goto out_unlock;
 	}
 
 	local_irq_disable();
@@ -4076,11 +4091,16 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		swap_cluster_unlock(ci);
 out_no_split:
 	local_irq_enable();
-	if (need_remap) {
+	if (anon_vma) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_folio(folio, 1 << old_order, ttu_flags);
 	}
+out_unlock:
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	return ret;
 }
@@ -4275,7 +4295,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4306,23 +4325,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
-	if (is_anon) {
-		/*
-		 * The caller does not necessarily hold an mmap_lock that would
-		 * prevent the anon_vma disappearing so we first we take a
-		 * reference to it and then lock the anon_vma for write. This
-		 * is similar to folio_lock_anon_vma_read except the write lock
-		 * is taken to serialise against parallel split or collapse
-		 * operations.
-		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
-		}
-		anon_vma_lock_write(anon_vma);
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4349,11 +4351,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	if (anon_vma) {
-		anon_vma_unlock_write(anon_vma);
-		put_anon_vma(anon_vma);
-	}
-out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);

-- 
2.55.0



