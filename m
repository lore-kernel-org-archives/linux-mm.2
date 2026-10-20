Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E0E606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Br31H+Qh
Received: by kanga.kvack.org (Postfix)
	id F3BC66B04EB; Tue, 20 Oct 2026 10:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97646B04EC; Tue, 20 Oct 2026 10:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD44A6B04ED; Tue, 20 Oct 2026 10:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBE946B04EB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:56:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F9141A021C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:56:16 +0000 (UTC)
X-FDA: 85343305152.29.97A096B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D219140004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:56:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br31H+Qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YPJwaVZNA7XKvLKxSJHwt8AND996P5FWcqMfwW7J6O8=;
	b=n8wQ7ZpppFF/QEZjttik6vu43s6TwXUd+4vQ23p/sUNRkmFKEYVgKAVAO8McYK1UDXAo3F
	AthuLutvvml/yOFyjyiBO6JexQWgC5zUZ8yp1Hjby3ipC3psGgYmjEWQEEZNMO/hPgpe8P
	yziuld6KT04/Y9CvZ48t6ezKRboQSPU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br31H+Qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508174;
	b=nvYvh8r9LE6dpee7xrqa0FOSK5OVrNWubc9Lzgk8lT386hkofxYX0g0nvPVkit+cia6Uif
	ldGOIFvlMlmmgnMhupsk3AGgWOg0BBiZjkDXXgpC8TNKXFmect6UZy77PBQUOAfytB2Pfg
	j+9hiHxx+19lf+aT6RFb/3iVir0MtcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDB5F4076A;
	Tue, 20 Oct 2026 14:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918F31F000C4;
	Tue, 20 Oct 2026 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508173;
	bh=YPJwaVZNA7XKvLKxSJHwt8AND996P5FWcqMfwW7J6O8=;
	h=From:Date:Subject:To:Cc;
	b=Br31H+Qh0kx6ex2p34z1bcfok8kj+ZeG4llZ75BUvFAo1Dq1oPIxoCeoO6p099xDz
	 B1wVy9dJMNDsufbp48mbsveiXBnHWXzouJ2SZR18uI60w+/rYgyR12elBi5JKs+kSv
	 tJNFoBdiDltvan4+zjzPLiRRlFGYh1nuA1ow+lXudu04U2EPrBg5DqrSrNJxtYqVhZ
	 Rbbr2NYOqf8bZeChGqW6uCbepAEJJ5VGDKkbO/h0ytPeIKRPxM+ivmh4DjT3fIABJj
	 yUGQyIgf6H4bPp5IRLW+NdAItwvsBLXzNwErHvQjRHby106yriXO/hY2eiQw45B43C
	 fpN2VdGoZJcAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 20 Oct 2026 15:55:30 +0100
Subject: [PATCH] mm/vma: avoid broken uffd merge on mremap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvyJ7bsGMtPpKdDBbaw+VKEUg/T3pO
 AMzGRJFpgSDyBDp5sTnUaCuBLjNHishL4VBSaVrqSRe3i8YabcBPT/YG610Z5q5dQZKFCIV/Q/
 H6X0/AQvrAmAAAAA=
X-Change-ID: 20261020-uffd-remap-fix-97626873b5c7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, ljs@kernel.org, shaos <shawnq1@163.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2794; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rkxTHg5wm6NIA3xJt/qMKzEyYMHeWzpVxMG0VaLooEw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKuN7JNvNWf1Vdy3yLzNEfs+l7e7qnXpQ5tX6m0fbnpS
 hbltxv5O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRRZqMDOs3JJY+k65a7/LB
 xMfJYNOLhWrzYsMOz2d7ueDLhDX/2hcy/PeoU1p0Vn3f/eZJcSmsP9+Fcstv0d8ey2MlUOnGuET
 +FicA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 8D219140004
X-Stat-Signature: fypwhxuer1h7atqaxs7npdubwxjy68iy
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792508174-208150
X-HE-Meta: U2FsdGVkX1+Hk1VfQUccPLXEHaEnys7kLea0XzkqGF8DFECZGiFv7Snu9ZqXPI5I4pVO4h790vjLFCHijexE8sQ8jl/94x8dZ66trzOYy9YfUxBoT8gDxMf5vHU7kNkv2s0H0viskOiVBaswd98Q3CFGtr7yUNQ1kY0aXpgKLkiAnnGeQs4NLw7z0Lj+ItZUOj1x76DC9X/jnvSEq+jCHmgtpoUF2TBzHbkYdv10q4oLskabcNgN7n8++2bX7PkhyVtnYgJi4WdI8dHG22KnieOROQRP6IDo9O9yqsRTglYu1Juj53LRVaGuT0i2RpXOTBLzC5hgnuFQHfYbBd+yC3eQz/HoXpj4QfEZ6swoBIcOdevhPNYTpQIqCR8gE5AvFrFzdJcJNsol3xFpXhOsWcLn6uO+cjSYDJsvo8eCiWm3JPK5FQ31VjayAfkHAHNEJapojcF+vTmF26rHJbbBGqr7GmOZZlHN2AMmlvY0lZQAXqF6GsNs6i90hfhsBQesEsiuMZPtMHijeJ/wZadyNv9wluIcir/b+Jkhql3NT8WNVqmhybtnZPU6BKPAkr3yXwXN0APW0IZN8WBD3tMe8Om0bHZDboMVqg6gqT5FLfhvwBavbbRLFJyIoy7ZZs04ydxXlXOL20PMYXHCC5fW9h+GCfk/lHYkf2ooqLPdzlltVAaEn47OrniDfFDQBdmz1jVntPeMe5lBawxWQPlJlGmdS/arS77R8+jWkecsdLGEGhoebAzoQUpqMFjeJi1IqGT+jfPj0OSN/wcmLzwX+Gp/ew9Gw8c9dSFdgrEUAm8blHkCZ/KnMJkq9ZwyOwEIDUz/xQxmJCybyLM9JZhUFAPcRqjnZqYKa4Kt7hXI62BvI3kgadN09FeVedruDlx/TVlTTgS7Mtv0twMRxipyL3Q13bG8dyXavzPxX89EW1MxYvhaoJQ1t7zvk/TwLglIAVI953udRsvbGnVS/lH
 gmqRtj5f
 0W0RbhRGR1Skhj+Rj7O29dqaGD+l90pyEQ6dmFfaFQ+0/hgL2GdSiX4vzpq+uz8llCKYSIBUem+wUgnKWJ3LTI2IUPpzgIfngaVkDe6JB2vZQZXhquTnLTaPb295rFWjBwqq0QPFGswjgR3TblD9Ey9fcNtCXXz68uqFsfOMQW4OTQN0pcV+UGcbhk6WY6Sxr6CdSJxsoV+wYRXw3k2/bfWBtpb+27xcjmbv5iy56fEE5WFGVWdREBcOtxQnkxXmGzMrXWrE+aBVeZKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userfaultfd often causes unexpected interactions within mm, and does so at
the intersection of uffd, mremap() and VMA merging.

When an mremap of a VMA occurs, copy_vma_and_data() calls
mremap_userfaultfd_prep() to notify uffd of this.

However, mremap_userfaultfd_prep() simply drops the UFFD context for the
VMA if the user did not register it for remap, i.e. didn't specify the
UFFD_FEATURE_EVENT_REMAP flag.

This is OK for the VMA itself, as upon page table move, move_ptes() clears
UFFD page table flags, using vma_has_uffd_without_event_remap() to
determine whether to do so.

However, this doesn't account for merging with adjacent VMAs, whose page
tables won't have received this treatment, and thus latent UFFD markers
will be left around.

Worse, it'll break UFFD for any VMAs it is merged with. This is very
surprising behaviour for a user, who will then simply not receive UFFD
events for VMAs they ought to.

Resolve the issue by explicitly checking for this case via
vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
function explicitly designated for mremap() operations.

Also update the userland VMA tests accordingly.

Reported-by: shaos <shawnq1@163.com>
Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c                          | 5 +++++
 tools/testing/vma/include/stubs.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index de5ebc57e7a5..1be613044b4a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1211,6 +1211,11 @@ static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vm
 
 	vmg->copied_from = vmg->middle;
 	vmg->middle = NULL;
+
+	/* If not registered for remap, uffd context will be cleared. */
+	if (vma_has_uffd_without_event_remap(vmg->copied_from))
+		return NULL;
+
 	return vma_merge_new_range(vmg);
 }
 
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index be8f5161f92a..f786a585caf0 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -386,6 +386,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 	return true;
 }
 
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
 				    struct anon_vma_name *anon_name2)
 {

---
base-commit: 3eb3e848d72cde2156447cc960ca321bb2ac41a9
change-id: 20261020-uffd-remap-fix-97626873b5c7

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


