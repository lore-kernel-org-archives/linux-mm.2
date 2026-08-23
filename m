Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB82C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53EA66B00A1; Sun, 23 Aug 2026 08:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF606B00A2; Sun, 23 Aug 2026 08:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C876B00A3; Sun, 23 Aug 2026 08:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1938A6B00A1
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:18:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B4FA1C0405
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:17:59 +0000 (UTC)
X-FDA: 85132435878.01.4CA6211
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA5A340005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:17:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdB62QeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phtAfk9967tvw5jCZ8EwhMxuR9BV70DOT2vnREg6Av0=;
	b=xEo/mnzXFiJ5boseZls43m4NPyhR6Ry1iD3cSIlf0mrBD18C/QyY8juIxaijhgF16Qsys9
	ao1pZ02VAcWh7heAvQ2l/rNycvxITtHuVLKTaCk25n+0MxXCTf3C87+B7OT5KjnxTzIjxz
	rn3rZRIsekPsJfkXwqU1fzgud2MLIOo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdB62QeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787487478;
	b=uF3nreZuxARMOi5CRKV1uLJXTqx/weoUgqpKMs9ii+Emnq/EKzCqBoINgnYWZOvLVgVr/3
	rJi+v+EDIX5kYYZXKQHzCa/hHbWqI1MjHb4IQqFNdosAjy6v1gkjwvgDSnCu87dqOUEUZF
	x3fRMlH6/kRkEbO7D8e0GGypY/gASqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37D614018A;
	Sun, 23 Aug 2026 12:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9721F00A3A;
	Sun, 23 Aug 2026 12:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787487477;
	bh=phtAfk9967tvw5jCZ8EwhMxuR9BV70DOT2vnREg6Av0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JdB62QeLHfrgk01rU7saumkTHude9O5ljmTk8ojegK2RGvEuN1X6v0+bfsUBT3oC8
	 BrrdKyH8U+RenOUG0fNyJGhL761oH3Uggo6pqg/KnEcJ8gvjVzWNkQd+eUxp3Cy4nK
	 ppxrXNG7PBxHFWlT9GuW0UhWK/ezVtolSz/FTRGF7LcYtPJHhV8w4QvIyFiT59gttD
	 FqaZ/wlxuzjVHlojywG4R7foLh5P3doLWKkw0bKIj+L4G6DeZX6+lX3GRS653oR5vz
	 Kjhrj0tTRMDE2EJm5T0PvMXlQSrTWVyAkH+VBPOJmvZAcUq17e1hyIlMUAmNPEIf1f
	 EGV0bagWOWW5A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 15:17:38 +0300
Subject: [PATCH 1/6] mm/gup: move gup_can_follow_protnone() to gup.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: DA5A340005
X-Rspamd-Server: rspam07
X-Stat-Signature: sd6jtkzh456s6tgdx3g5eqits1fkburd
X-HE-Tag: 1787487477-463618
X-HE-Meta: U2FsdGVkX1/k95iplJq38ddwIH3fBSmku7+bXsrn9RLo8vEOsFrAUYY2BGUv9UcgXzAFOcJ0GyUtwAdoAZQGZ69p8EpDLbQn4A8jYg5gOez8kzuJ0BTWe1sN7doCcAT1bVYxolY0vXaUgad0IXxRqQd8Syl2dATecy3g9Mp5RR51KaJx04gO/GOPo8tkr3W2M1Ru4wsnYzEIPLRJpWkXhXXL45NI2/okB4w/F3Y5z1UpYMLMg/zPIERYPpNmOTOXnCJtHWDfry0Ko1NkBo+Eoi/UY8zvHqDO+ZFtsFNcICp4zGD5q2BU1eqbv5HDI0O6VSFoOGDnb7nW4Ke5D4EMP9zLXqi4+D/l62UKvUbGA+80QhSkhw7OeIsTlESD5IF52SscnvZsgmK207sR+3OcE/9qdcbp4PEcjxdvxg6hD5zWv9BrcrmDYNTO6DHUbYHW1Jnmh2YQi5O/dBh88zI5PFZq9CkUvRwuARO5asCojwNgAEEWTCWalSy4hyhDFp0WV0VsGspWK0ci3AJObRrNc8hvEy2EobROYs6ZtxVgVqMeCMevsjIeFKu6pvxMZe18SrHjBazZ5amcnrBGEXfUIco5tUKiq+or1NLWPafoQiktVD887fsrMNGdkPoHw1/tcWWbiafHTw3cVRXEv3WHlvjbKrziGn2M6Rpy3IV0sOebprpEZdCQcZWKQQ2aw7s6KxedAsuzqmu/GUeXrDDQeBBqctsWOORhUpnpJjV41LCnw72IRkUquw4uBjDfsnypeMDrPXtSyk8G0wjAgvaeYIuzRQtOaqSngAAx6F/7ot8eDyEVVnsDkykUYQqB9WgcbkThl12OFq0E42EGBK+1B/oJX3lF1JiagpX7fqf8XCk/3TVP91ty7sj4yjPogP8eiJTwXLYJfofx79pTgHS2SJcjZgX0EEzBu7JPWjivaM89F1xXQPDJ3RptHHWv3qReJ386ScqFezyx4tcBBwm
 rgUMdMOW
 5j1MQKb3Xq2q3V5lABXrEsRrzeqVRGkI+DNsDV6r2orfBriqyGT9WqbTcuG6qbQRx8RSrIkstn8mH2znck+Gxb5K2UUamlpkupT13AIQRypPaMtZTz9W96VoAndsIOkYu2OpjFfQ7IfbyUTWxjTOPXNLbI5P//lxh6a0U+FE93BqHC8ZODnqVkkZ9K0c7nG+G17srxN4CWq7TRnonuxlJNOvQTYn3WMh6DFUu7QyutZcom5f2EI3BEdCr8udfE4QNvlEdfb0+PGw+nEgOuzykGn8jkxCdMbiE9MESnVK//gScYpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_can_follow_protnone() is defined in include/linux/mm.h but only used
by mm/gup.c.

First, there is no reason to have it in already gigantic header.

Next, the upcoming refactoring of userfaultfd flags will make
gup_can_follow_protnone() depend on userfaultfd_k.h which would cause a
cyclic header dependency.

Move gup_can_follow_protnone() to mm/gup.c.

No functional change.

Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 38 --------------------------------------
 mm/gup.c           | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0829e0d3b2d1..4daf9cd6ae8e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4860,44 +4860,6 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 	return 0;
 }
 
-/*
- * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
- * a (NUMA hinting or userfaultfd RWP) fault is required.
- */
-static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
-					   unsigned int flags)
-{
-	/*
-	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
-	 * NUMA hinting. GUP must always take a fault so the access is
-	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
-	 *
-	 * Only do so while the VMA is accessible. If it has been made
-	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
-	 * below: forcing a fault there would loop, as handle_mm_fault() makes
-	 * no progress on protnone in an inaccessible VMA, and the access is
-	 * denied regardless of RWP anyway.
-	 */
-	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
-		return false;
-
-	/*
-	 * If callers don't want to honor NUMA hinting faults, no need to
-	 * determine if we would actually have to trigger a NUMA hinting fault.
-	 */
-	if (!(flags & FOLL_HONOR_NUMA_FAULT))
-		return true;
-
-	/*
-	 * NUMA hinting faults don't apply in inaccessible (PROT_NONE) VMAs.
-	 *
-	 * Requiring a fault here even for inaccessible VMAs would mean that
-	 * FOLL_FORCE cannot make any progress, because handle_mm_fault()
-	 * refuses to process NUMA hinting faults in inaccessible VMAs.
-	 */
-	return !vma_is_accessible(vma);
-}
-
 typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22..500e2aa99e48 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,6 +633,44 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 	return NULL;
 }
 
+/*
+ * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
+ * a (NUMA hinting or userfaultfd RWP) fault is required.
+ */
+static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
+					   unsigned int flags)
+{
+	/*
+	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * NUMA hinting. GUP must always take a fault so the access is
+	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
+	 *
+	 * Only do so while the VMA is accessible. If it has been made
+	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
+	 * below: forcing a fault there would loop, as handle_mm_fault() makes
+	 * no progress on protnone in an inaccessible VMA, and the access is
+	 * denied regardless of RWP anyway.
+	 */
+	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
+		return false;
+
+	/*
+	 * If callers don't want to honor NUMA hinting faults, no need to
+	 * determine if we would actually have to trigger a NUMA hinting fault.
+	 */
+	if (!(flags & FOLL_HONOR_NUMA_FAULT))
+		return true;
+
+	/*
+	 * NUMA hinting faults don't apply in inaccessible (PROT_NONE) VMAs.
+	 *
+	 * Requiring a fault here even for inaccessible VMAs would mean that
+	 * FOLL_FORCE cannot make any progress, because handle_mm_fault()
+	 * refuses to process NUMA hinting faults in inaccessible VMAs.
+	 */
+	return !vma_is_accessible(vma);
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,

-- 
2.53.0


