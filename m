Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F582CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886BC8E0019; Wed, 17 Sep 2025 08:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8379B8E0013; Wed, 17 Sep 2025 08:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D248E0019; Wed, 17 Sep 2025 08:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64B868E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:57:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10EA3864FC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:57:40 +0000 (UTC)
X-FDA: 83898743880.04.C2919B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 90106180003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:57:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKDCpqxr;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f1DrSt92L0rrSp7vsZbUR3c3nbZ+vkvUSgLPx2Xn96A=;
	b=5G/7pUf3W/D2YYYXTUFpKCemGHWmeIHU83GvaCK0wuPb9moHEiITTbLssSbvB/op+ZO2oJ
	g07Bbyo/AR/N/ooBIkntjgSHx6h5Tp/mt7aZRF97+29EU/WVJDYkUcQv9Or2Xn8hcmeI8C
	fgq8wtTKG0W8q+i1ykP0aNo4X0gbX5o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKDCpqxr;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758113858; a=rsa-sha256;
	cv=none;
	b=mZRpaqvT9OCjf2Rubok1o+u4knjfOWTj6iffExlKiabc2N7I1ykZ08UFpkgibjZglL7tzF
	5RCxdtcxIfnG/s9+7riiSXSTg7jc/Mjkl7LI84BlZJeByOMItJBiPbS/t94ISZKKK+N8By
	e9jnCH7LwhMSKCQMqDnLdISWTJLyEDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40CC344A32;
	Wed, 17 Sep 2025 12:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA04C4CEF0;
	Wed, 17 Sep 2025 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758113857;
	bh=bVQjh4jiUS12TD+kXPcBc3hIfzoE7mbPAz8+HVg3K0U=;
	h=From:To:Cc:Subject:Date:From;
	b=jKDCpqxrnNtPb3D6338CB7uyKFGcRN9WGPbj3Df0XsYjlUo8y+qkSy8lcqNPNeJxg
	 drm0UKWmmE5vcbRMPvNbrbH28B4MgKh2k1A+SW91COElH+SNM9gBOGY0AHR2PEIO/0
	 uXt+OsBA3Gjbv/u2A5d4t9bWpHnLe4aMDrBEV9iWTJylLVIIEISk/J8v8ASFJf4kZe
	 hof3guPEvNve21kEJ8h5hDC/B2BIM1/dUWtYxiMJv5Fwg08HB9R1T9Y6wk8TCOFmez
	 SWqZglHXOb8AfaGhHDznRI1zByLsENoS99NFWM1+6DUtuJd9JKHfeVOzHK7aBmAcbP
	 KC5lPlEjnq1MQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] kho: move sanity checks to kho_restore_page()
Date: Wed, 17 Sep 2025 14:56:53 +0200
Message-ID: <20250917125725.665-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90106180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: uk5enpb5bkaq6atq7s7ttcn6r3tbs4nb
X-HE-Tag: 1758113858-718426
X-HE-Meta: U2FsdGVkX19+cQhM5pUHcs4nj0BqYhVY0O/qBgPVnd/2C+rlvPzopfJat3puk4AoKzPmAXr0ryKilbXPs9TMHJBe7t/YmTtWOEdagOTT8046cK/f2GKwlcYkNzJVteFunvH5zOgCkV7bYbqq541GrAUhJuVawZyqqueIRcGmHIMIn20ytSxNRg3etcRrPS2jl0TGzvk8fzK6kITcWs9rQ746MRWyFt40+yadabLcTXz3HRrTncSLdjPWUhXSAWZZqRs8BCVlUXSI4KN29Kdrn3LoYS5q2w1fbIUgs5HukA71SVnlz1GanBS+a0hPG2jWijZF83Ta2/14KKnwUYbLAfPWfJpxvYh8enjPLBdqzz2mIpgT6K8Bax6gCE62pikvKV4vulpyeNSAlXmfYowZ0QH6QUt9QS5fre9yDoxAvfsTmCj0b5iQ12a3+4yDi0PLikJotR8L4aheiuJ65ykvjqlTbV76paOoCgWFWPQq69b/Ipk2QBn1UHpo57+nPdbvGXSGfNnOqqfptK0kAzM0g8bMcl8VtNJQ00QiIWBlZjUToD5SkvZBb/IT9CgJx+DmTEj14Ayv5F2lIuJD/slibMGpxn+or3LJCl80augHKL+6uI8LiYUghpl1625J0UbYDT18BWGWheSJASRlBe9j1KuJ0DR1U4e5ahr4HywG7B0xG2zNN0dwXm9rBdWg+EC4aBAxlag6QmproTmuk1DPVWYBdFBP8wUpC40NKbLztrtBDEPZwahtPF4iz6k16o4SNrHh6NtQCgPCJTBfvynZtej7pGiKPPj/j/l5MVQwcrmOfsRguGhBLdzPGpi9Udve+/DXWj3aMfuW2zdyBS/Fk8eOc2GTSMkTf2rQCLtqliI/Q1y14RsCJXyA7yz8k+DQPywDa8eC0egL4grligJgp1PltglejFmCGtClUVF4jOzonZ3vtArz8khQHdOP96QC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While KHO exposes folio as the primitive externally, internally its
restoration machinery operates on pages. This can be seen with
kho_restore_folio() for example. It performs some sanity checks and
hands it over to kho_restore_page() to do the heavy lifting of page
restoration. After the work done by kho_restore_page(),
kho_restore_folio() only converts the head page to folio and returns it.
Similarly, deserialize_bitmap() operates on the head page directly to
store the order.

Move the sanity checks for valid phys and order from the public-facing
kho_restore_folio() to the private-facing kho_restore_page(). This makes
the boundary between page and folio clearer from KHO's perspective.

While at it, drop the comment above kho_restore_page(). The comment is
misleading now. The function stopped looking like free_reserved_page()
since 12b9a2c05d1b4 ("kho: initialize tail pages for higher order folios
properly"), and now looks even more different.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Changes in v2:
    
    - New in v2.

 kernel/kexec_handover.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd7..69cab82abaaef 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -183,10 +183,18 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	return 0;
 }
 
-/* almost as free_reserved_page(), just don't free the page */
-static void kho_restore_page(struct page *page, unsigned int order)
+static struct page *kho_restore_page(phys_addr_t phys)
 {
-	unsigned int nr_pages = (1 << order);
+	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, order;
+
+	if (!page)
+		return NULL;
+
+	order = page->private;
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
+	nr_pages = (1 << order);
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
@@ -199,6 +207,7 @@ static void kho_restore_page(struct page *page, unsigned int order)
 		prep_compound_page(page, order);
 
 	adjust_managed_page_count(page, nr_pages);
+	return page;
 }
 
 /**
@@ -209,18 +218,9 @@ static void kho_restore_page(struct page *page, unsigned int order)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned long order;
-
-	if (!page)
-		return NULL;
-
-	order = page->private;
-	if (order > MAX_PAGE_ORDER)
-		return NULL;
+	struct page *page = kho_restore_page(phys);
 
-	kho_restore_page(page, order);
-	return page_folio(page);
+	return page ? page_folio(page) : NULL;
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
-- 
2.47.3


