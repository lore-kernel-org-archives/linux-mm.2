Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4B0CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523CD6B0088; Tue, 26 May 2026 02:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBA66B0099; Tue, 26 May 2026 02:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411D56B009B; Tue, 26 May 2026 02:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 327156B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D12A7C150B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:47 +0000 (UTC)
X-FDA: 84808615374.16.53D90F7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E82D40012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Du4jWa36;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QA88n7vOfpIsIEJRCFVXhxAFUaEnu0dRfHmjnigWorY=;
	b=f+kFIcZYQMcVcfVJfXzSbd0VKAVqqwJ6I+C9s9C89TEJ1hc5YbEAOAnyZ+mCRuErrsJzd/
	yVMQ0fZZSCO8Jvjmtee8a++/Xq/Ysqs05d1wWzoNRc1TyM5O+h9g8aO9Tfg53vJFVnipFk
	79dAacDEK8wWpVEiFIP4FvgPRuikzUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Du4jWa36;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777466; a=rsa-sha256;
	cv=none;
	b=nMIx/dRJXbWc7ueJCXXHZ+w7skznTHzv9ywtsjH17gAI8XHIUz4g+fNl+ygvfafyKpzQjW
	AhN594qpWf6fC8/XikARF1st4QnPT/fUFVIIgelDIov3wP90XmbYoP8eRw3E63vcVJf6LM
	9crBTlKaKoPhAtH93i3xX4J1RW5Nd8g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 282DB176B;
	Mon, 25 May 2026 23:37:40 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 84BC33F7D8;
	Mon, 25 May 2026 23:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777465; bh=zI0ZXjJNDDE2exbOQSUMmCQhV1H2PQoQr/8eVWk8agU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du4jWa36TFo6ZfukxGs1dMa72ax9sM52+Jj1iJt0U8pryuzeauPPR5wF5v4tCxP7I
	 X+a0P5222OropDvxeqxuV/0vxOrRAh7U67qf3ZLyvpHp2Mvav20APZrCIvnpumDsuZ
	 /CjS03/SIewtNgerFImmjDNzn7gq7MOsH+WiBSO8=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 05/12] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
Date: Tue, 26 May 2026 12:06:28 +0530
Message-Id: <20260526063635.61721-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u7kmrgi5qi5n31ig3bfa51dg68xjyrp8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E82D40012
X-Rspam-User: 
X-HE-Tag: 1779777465-102454
X-HE-Meta: U2FsdGVkX18ifNuxnzfxH21nlJUk1hjpMIH78X4Dcl2yYt4bJMRPupwquoKWKycsmJQEl96pQPlROhKDDFlMpX8iqH3tsJASghY3NDHGl1Yi21CEF++g016gST9xXdznXPUs70EHJM6rzq28HwiL9LhiAas+yHm1moI/NKoVRjwX8JNeicyD68aegGlxHBEEtSXHAKKACtSZ6KehtZN8nosFHY4MxTrhZUOVZjXyvl1oLKdEJyg1Bdbh8Vs6h1ryCjZ2ILJUdnERvsm+IijinYqNeSvG1V0nadG5dOayyt7wGQx+s9EHooj1FpINzmrP1zLel9KXGnzqzvbDiQjX2wlHZq+rtWCfZqwZ6OB6mezYbmHj7jIf3s81g43ivkQehUuL+/o/VLfGqeKwmIEgVacvO/EtVk8tP6hvthsfcjLEUMZdBbPPBRFQOIve4w8qfaPsFMNOm2Jd1fNVt+CrCsBrc4buXfS3BB4pn4BFATpyv57NCJpQXOUJATz81IMaX+lLdkh+UR1Hd2hJVDkG53znApsdGc+Qd2oIc3tVUyeIzwrrjM8lSX2kJAX4H8UoIvNxWQQrKB+lh3LWdBiyLzqamz99ug4u07NH1Q2D8+8sI2JjbGZGvPja36DI5LoKvKbo/SkSYIYsvWP03LdFt0Urho8zZUxXHXEJ2ccXIlV1i2jmNQ2mWrUknkFtjEh0jPizAQDOAhwjgTKOs/YCbHxkAWjvrZXQP5bdMgWcPbySASrvRFRMyisNmMXnarNhURuFzV/iQNGZ9gKeuOpfuEK1ts8zUmHxCEzdvsjUypSgfB3pVlikkoZwpjgSuxnc2+4u4Kiq+qrhBv9nwUT299SQ2o5/0uhaj7Lm1QKIS87vOd6CXyWqX85SBtoOL+lDASNfGJ7hHtx0pLHTGnOnZpMYv26+YNM4HDPYo4NauvX9eL2UiLHwuL5LEig034eqQpMLwXKRZyD0k/U127B
 sDS3YM7e
 iaaxBz4KqheXCyaMFTQ4eJL84tKPGeiT7dNjtE57wCmAmnPpRz/saK0cytHCnbrH7GOWlUKKj2UMe2Frkp4CM96Z0hBByCNehF3Qu/MBoEVspvySUNZgUniuBk1K3/01yhJtg8FPtkCUwU7+e06S2VKbqhvm33DtbGAf4aGi/B7KV92vWk+R+O/oEVRdG9iCX/oRpGciI8OOQIOLhjQD7JzqTYtpv8gMwGhn8Jl5px2gosOx4kY/JEK4nmGjrCIva6G6VOvJTM7pbusE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a67fe41e214f ("mm: rmap: support batched unmapping for file large folios")
extended batched unmapping for file folios. That also required making
install_uffd_wp_pte_if_needed() support batching, but that was left
out for the time being, and correctness was maintained by stopping
batching in case the VMA the folio belongs to is marked uffd-wp.

Now that we have a batched version called cond_install_uffd_wp_ptes,
simply call that. folio_unmap_pte_batch() ensures that the original state
of the ptes is either all uffd or all non-uffd, so we maintain
correctness.

If uffd-wp bit is there, we have the following transitions of ptes
after unmapping:

1) anon folio: present -> uffd-wp swap
2) file folio: present -> uffd-wp marker

We must ensure that these ptes are not reprocessed by the while loop -
if the batch length is less than the number of pages in the folio, then
we must skip over this batch.

The page_vma_mapped_walk API ensures this - check_pte() will return true
only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
There is no pfn underlying either a uffd-wp swap pte or a uffd-wp marker
pte, so check_pte returns false and we keep skipping until we hit a
present entry, which is where we want to batch from next.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6a0b43856d6c0..ead031361bc61 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1965,9 +1965,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2288,7 +2285,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


