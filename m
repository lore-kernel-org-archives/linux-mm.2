Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64030606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=caIHNtGj
Received: by kanga.kvack.org (Postfix)
	id 6DA286B0864; Wed, 21 Oct 2026 23:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68ADC6B0865; Wed, 21 Oct 2026 23:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C76C6B0866; Wed, 21 Oct 2026 23:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0C66B0864
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:47:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5793C1401E2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:23 +0000 (UTC)
X-FDA: 85348877166.08.C1B1F7E
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21539C0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=caIHNtGj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792640841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvUjiyMCs7JZfFFIwk/bmLJ9gLcg5Lr3+0R1L0w/QTU=;
	b=aXNyNNYGn1wS6WYd7SQluUnQcUUKqAXLOCZQQjRgcz1xVgGbF8Mf+/njxaK2/aZviPmPKK
	NJGX1X5BFbHu6P525+zV0o7k0wFv+9l1DN3nr0GL9FT3tH+Dx1pS5xqI+6J7IYQHckFmwQ
	lktEQWltzW1WmvxDCZB1d5v+Znqwwzg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=caIHNtGj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792640841;
	b=4yz741xuBI1h0Zsdk96muqO1cxX4TLGClYxU0BuPKmsJas5Q9G/DAAKOMqiqgYmb2CuYVC
	rJfEK/R95JbQgTBThILBA1vE8yzoO6ndSAs4EwORtx+r5IEjdEOH/WSt1CBHLuPer+evOI
	BdfW78xD3aXQwRWxUyYVgE6lCBEOxnU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792640836; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xvUjiyMCs7JZfFFIwk/bmLJ9gLcg5Lr3+0R1L0w/QTU=;
 b=caIHNtGj7S+FGLOLM79RoDHND8idRbnusE4dLA2jU7LKZmG6kVzVGkxrxTpdoOtI9Da0B6
 T+15oKGUDzkBUHoawmyU9+R3nmMZJywbSZ46pt3xmiYxCKA++lSBmHaVBusNOqPW0pcUCe
 h+91WnWeTY97+o0xOTtRGBhnx726WPI4mkds6e9zqp/NnzzTcix/whd9k7ZTVAAvMmuvKv
 5TzsBUXtc1FC+al2rurmZo0InAWl4KzsuPoVErJT7IlpNAXWA/Jf3iVqQFwkb+TzuSTFkv
 3SiMTKbFCc0k7GC806g2axwqoa5GeL2OUERdDC215KB+RO58nSa6vKz9iINspA==
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20261022034543.51226-1-lizhe.67@bytedance.com>
Subject: [PATCH v3 2/3] mm/hugetlb: disable PMD sharing for UFFD missing mode
X-Mailer: git-send-email 2.45.2
Date: Thu, 22 Oct 2026 11:45:42 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ad98742+6df546+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <peterx@redhat.com>, <rppt@kernel.org>, 
	<azpijr@gmail.com>
Message-Id: <20261022034543.51226-3-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 21539C0002
X-Stat-Signature: tpbnw3jfwcsodd7pxms9ojfoswxii1f6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792640840-376902
X-HE-Meta: U2FsdGVkX18WZ+jDyBuUcEZeHzNGNfhpvith2RWE83LFv0P+GHr8NUmy0ZtdVKx8iOVu00StvZNpWuylLYbDNaQ0opD2TU9yAyw6agLc1hEw+ugkmiHUsH3bmSSSoitgZHVdk87t4xtGv4OY8Nf9PCtKpAjBrhgVb8KdJRR1PHr45c3wL3L89XrsGFuoHpdqQT7UpLOuPVYN8Ud5Gj/XlUNNieTBOfP3516JgknBNsSUAdTXIsDKAUSNUWd48PtSy+QfC+DcdIca5Ia1cDajOSwv5c8oGP5TkK8ay/aSZRfC84HyKJZ1L4BJxJ6q1F/oP983SOcgIAMr03IrKetzyxj5NFaI0AC+ySQ1mQgONv3H33o1WtqOKF0CzifEGVkw4gQwhkL+bNEKsG4lQoxSh8xWv3fbN+QktfxgBfiedpJJJdxMtRd74A3JTkRT97wAyfRJt87jxAIxaEMRVVtEI0jB2canNpDMleAF5kysZ04/tzSwbCpST6w/4LFn948BB33N15b8jnELo+y9587vlKOkG7T+9CN4kRGi8oxrGMWfj9dOaonVsCJMqRDTuHwsKhYj6SGT7OpZ2Prl+/nLmy1dgMaPQEPLxMQVTmRyapZoMXssYVN84GeX0kF0zSE5aYa59YU2hSW/VKJeFKNmn75NxWXG40KrwwuTyxxRhR6InWpyP5o3R9fWZsRTeiB51IBdRBCkWJL+cnNlJ8Tmub+NlqcJZBQLbqii6vMTRAX4LQnR3i5DMN/RYlkwYPRajg5/UL3atU8NVwOLF5R+5ExDm5wPsLqWxgfRq+lQT2Loo83H8aBUpup4Y9aVdeVyZgE+np1GXQD4Fs5onyV4qClLMfSVQVBvygD4S0S06QInl68NI2ejGkD+eS3pS70hemu5KG/jHfmCi7frqylw3z0eGvBrNVOWGri++2TwtmIyrHIO1Yansbv9gmSNrId5oJTWtpG9/w+eQUSMIUG
 oH2Gmqz3
 /eKC+zXh5Oe2hJETCzb7xTrbTb/8Bzf0HH9KtCS/DDq7tt7zAZfegUsGmaedP6xTqU9nVVXVChP8J6Fum6se9ebFMsnUHhx0NLNvElYPBk0ELpBjjoyDcBAzieEndPqElKlR70qiXasETvoTImskgeC12NX3UWSYE8XXEYGhQMCxjQWsw61k5bx7gotrkH8+/0bzaFn8KT0LNbwFx3KtZPuEjbESnZeyf3zbuYv07/mBaZux7S8a02MXhWS1KPNui3sct/xqqFnUwNMCHkLA6pELNbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
sufficient to have the VMA registered for missing mode.

However, UFFD missing mode does currently not block PMD table sharing, so
installing the marker will be visible to everyone using the shared PMD
table, which is wrong as UFFDIO_POISON must stay local to the process.

To fix it, make uffd_disable_huge_pmd_share() cover VM_UFFD_MISSING as
well. With missing mode covered, hugetlb PMD sharing is disabled for all
userfaultfd registered VMAs, so the helper can simply return whether the
VMA has a userfaultfd context instead of testing individual UFFD mode
flags. Add a debug check on the marker installation path.

The existing registration path will then unshare PMD tables, and
subsequent faults will not share them while the mapping remains
registered.

The alternative would be to unshare PMD tables selectively when
installing poison markers, which results in way more complexity. Or
alternatively, simply failing the marker installation, which might break
some use cases.

This also disables PMD sharing for userfaultfd registrations that never
use UFFDIO_POISON.

Suggested-by: Li Zhe <lizhe.67@bytedance.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/userfaultfd_k.h | 16 +++-------------
 mm/hugetlb.c                  |  1 +
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60ce..224324dae017d 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -169,22 +169,12 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 }
 
 /*
- * Never enable huge pmd sharing on some uffd registered vmas:
- *
- * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
- *   tracking information is per pgtable entry.
- *
- * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
- *   VMAs which share huge pmds. (If you have two mappings to the same
- *   underlying pages, and fault in the non-UFFD-registered one with a write,
- *   with huge pmd sharing this would *also* setup the second UFFD-registered
- *   mapping, and we'd not get minor faults.)
+ * Never enable huge pmd sharing on userfaultfd registered VMAs, because
+ * userfaultfd state can be tracked per VMA or per page table entry.
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
+	return vma->vm_userfaultfd_ctx.ctx;
 }
 
 /*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a70716deaa41..3cc33ac85a15b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6303,6 +6303,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			return -EEXIST;
 		}
 
+		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
 		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
-- 
2.20.1

