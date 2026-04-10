Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE53DE9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45ADA6B0096; Fri, 10 Apr 2026 06:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404B46B0098; Fri, 10 Apr 2026 06:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F36B6B0099; Fri, 10 Apr 2026 06:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE676B0096
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:33:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAB3E8BAA6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:06 +0000 (UTC)
X-FDA: 84642283572.29.3B609CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 33778180010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEparMsG;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817185; a=rsa-sha256;
	cv=none;
	b=COBybE9yyuXkPhjss7r4aoJak5Ck0J03WLQgEx2CVGMw0dsbf8WOMfI4W8pS8CmRYVsRis
	QR9nWZfGGVuUy2AQ8aPgKPLsMW9xe3g87N8cmEcD5EKfMTBOKiSONSlteuF8nEFZfuC03K
	ZPy9SXMEVZJyqO98qSQE7yjHnPgt8KY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEMG6kW5VJrEayT2sX9FZrPJd3EfWrzdeGeqz3QKyH8=;
	b=Lld7q2y6BCvq1gABPdW3FpV5+I7jnbqy8NeP5zQLMJ0BE4qRzVnESseYFrLkFCbAodqIH5
	AZ+SoVvNPQbEVVPFOj528yAMkhRj3NgAigCbsDL5eQ7cUjh00IDns33Nt2Qt2N1UeAhHbE
	UPud6GicMMDMUMbbvFsHBQUt/Xc2k8g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEparMsG;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C74E92696;
	Fri, 10 Apr 2026 03:32:58 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5339A3FAF5;
	Fri, 10 Apr 2026 03:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817184; bh=nznb2888N9JDa3zHHM9+wuulyWdFYl45pOUn7o59yFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEparMsGcO02O+o0tOuEdJ9CGG67+dAO90ssHctZ5f6vH9drv5WHMtg8RGsfYurCr
	 HYjyTkZI62cLthPoG6x/jpOjNc2ekYXuQ1GS1fcYlTTa6cz84BHBrNAGnI11W/MxQy
	 fDyhOmC5zVX9X81xgpqRslqHvf4Lbz3M27sSp3eo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
Date: Fri, 10 Apr 2026 16:02:00 +0530
Message-Id: <20260410103204.120409-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33778180010
X-Stat-Signature: ohjcz963iiguk1ga18wx1w73o6su8c4b
X-HE-Tag: 1775817185-302678
X-HE-Meta: U2FsdGVkX1/MJan9cxwj5NJUD9wNOjLtZD7KF++5XyucYEnnLkToYDTukY+fd4NcAKCjI46RVc9vlEaM1RcVqvGq3qX7lh62JV3UhFvgAePnPPw1V9QqALCPLK87Rv71y8x/OcVCJwZqWP3i4eGdZ04dqGRzQSuMfAAerkvWF9b6Yfe5/RK1i+LCjdyXuDg7SH+BYacOhpRgCXPUtNbu2HCug+aXW1CI/38z1a2c9BSdEWcttkRWblojRrjuJw+ZmDAQbCCwwuwwXpOzJgImk07/VsuT+uFWz6ZncZ+Vf7/XH3wJIbO9m9fKZb2kzjkkMLa3oKxi7DZM6QUcAlIXxYbgboppRnDCqtRCzETC2QwJ8KG29PhnngSYaPjjovVN1Cl8WYjnLXMxpzDdDI1Lr16pLvAi0ek3f0R7SAlzKlWgaLESCnAG70l7eZwT+eCu+R1YT3llJ48nSNf6g2KqByJqxpHnfXMOUQhneTkpLW5EKtZ/0QvmQscOEbYIWQG2rS7wPd5hcCoWuj0oFM3UEU12+IxEBdSZmrHM+TQmM6Gz1NPGoAhKE+5rtH/K1P1ZNHLLTnQt9VxzV2BZXF5bYn7JtOY6xTHkjk1YeZPn9f+vaagb9TQf20v+ERm7xDRedjFmgPy54XhZ9spNG05BZDC5H4TnopVnpMFwcq4rcxNN70Idpqz4IBjg6WzYIiwHcpUuQ6ysA9vGCDP2vxHC1fGEaZT5qOcgwAkXc8ypkd/MST3KOXTNpZGnOfz1bMNmX0dbFCXwyidic6Fow2SFugs7eVhp5HOqgFbQGojFls1eN+Wgsv7T3MXdTb8bMZv3DONOBEvzzwYo0+LRgWRdAalTcSP24kPQe3OWSzr5tPVdPNsJGKaGqZ/qAUsK1S6cn4r3q1PMN9PilXFTDapfFwVABxs+m8RV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a67fe41e214f ("mm: rmap: support batched unmapping for file large folios")
extended batched unmapping for file folios. That also required making
install_uffd_wp_ptes_if_needed() support batching, but that was left
out for the time being, and correctness was maintained by stopping
batching in case the VMA the folio belongs to is marked uffd-wp.

Now that we have a batched version called install_uffd_wp_ptes_if_needed,
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

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 20e1fb81c33fc..7a150edd96819 100644
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
@@ -2263,7 +2260,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


