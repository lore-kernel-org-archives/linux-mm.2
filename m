Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8316ECD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC03F6B0092; Wed,  6 May 2026 05:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97FC6B009E; Wed,  6 May 2026 05:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4736B009F; Wed,  6 May 2026 05:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDDE86B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BA541C1381
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:04 +0000 (UTC)
X-FDA: 84736513848.25.28AC52C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE9FB1A0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DiPGPZeL;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lx+nBxaKvZusy88l5ShbaFcVFRBPUDYDYMzz6iq/GnI=;
	b=VDskiKMrzQhkN1KhQevGil8kiJOzj8bs04sZoS+n2fiTM2C6s98WYYaKJ7kpecH2SmYTua
	eqx2tkfhLs4tpq8H3ewN4rtJVJodYSvlUa2vZ4NS+BFIjg/vEcWwHly8FsloehavpW1zAm
	bI3h3WNVMoMklz4YXnWdkyBrEW+trWg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DiPGPZeL;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060763; a=rsa-sha256;
	cv=none;
	b=S1ZwK+5LRGvg5R2QrdgwV/p4mFFzTEAPsY8thvY/ZAT+94bfCx7a2QJSkIXuNw1wJgchCb
	P71z3zVeNzgUxbFAqhygBNNmLKIYoX8Gi3dNKpNc/gfniCHZa6Z+2Phixb/jWZjpRoai6O
	pO9NVSQJgeFaD0hJJ9Q0FjPOBUblJcg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A82BF331A;
	Wed,  6 May 2026 02:45:56 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 22AF03F7B4;
	Wed,  6 May 2026 02:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060762; bh=5UvkyfIWSiH9Se1fWO1+prSHIFh4WaKl2h9l04UZKME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiPGPZeLFr6KMG8ted+Z+UsyEGMycs7zcIFrDVALzOZMUF/rnqvzLNjKXU82OjXNB
	 JnkmmgPephEDbCnUf2tA0uLRAtVr41Ft5dBIAh0gsYDeZ7YiYX+FbrGEj8MKpD29yc
	 14q33w3pSD8nwfEgSBzmsOWZ5Nvhbj/qkI3UjjyE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
Date: Wed,  6 May 2026 15:15:00 +0530
Message-Id: <20260506094504.2588857-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d3fnu8e9orpuj3cx58wu45nm13qa7yoo
X-Rspamd-Queue-Id: CE9FB1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778060762-638108
X-HE-Meta: U2FsdGVkX18gSq4ZrW/ZuYAyHZ/+OXgccMqvRMpAlTgH1M11tUxpCaeUJdzojrS6sfgwcvuhnUCPwDNcyhKuuj8tqO3JfbXYa7yRTglVNlbpPGBY0dhz7viF501uf+uhn9insLSa8P8FhoG5iut99J7a0Og6iYl79UFWyom4cGN43/6ZR2NbQxNwdjXiOKpyIDQAo4koSWoC/PUkWbKwUGiuelg6E9dOLlIkvSCHocWkQMGZMtyekJmSAhN881FE7w6h8ITZFWA4Fv1cyCU3XILxbEy+0gfI5AQnB98RLFD1CV9z3eom3DDu2EIhS7tiyis8UPbKB59/Xo+yb99tuiXA3D92uS/KG4RjUYnlhdlz3zhAOTnfumR+E8dXu5o4YbT2wYKioiK74oCIsQjxTkjJQQqbyQKVG0bKa2rAcP+6CRAZQeUqk2kZuyfO+S9La/YzAse82TpFM08dfd6FmmaQ+CZgFncnvsOunN13zjwPCjby3cN3TybKfUL3pio2rEffze4Lf0RjgeWfo9sTpjGIFkgi1BkXuC9DPsnY+kpQgLj1q26unpBatnJlcjFOjR3qIK6oWCaUk1nmhsmBI3JV7TCCaz6K8iB+XPPuUBmjAS1LjwENLKi+886gcfPYtHW/QII3HhcsTvx1tlJmXvWKCbLGB23M94/2LIHGVJIwp4zqw29m9wMmBInR6NtZ8L0MqLyOtOBPh31Ydf9MaqUD/dQcvqa0V8Io/MIs/8pUji3TCP4oEwbW9xDqrCubzaM/Zz1PyEQUdF2qeKtsbhMEdv6zYZ19sK3QlYIQlzbNnm7u1M0wbCOSzTm6zG3G2kZvNtx3oDync5NffNvr+KMtRNSv5Cz+USs9vtKK6DEFriMybfcOXESFFYXHBB3fGrfEipiFjQZMd35V/DQX2lYR8b61aQ8gaocw/NrcXT54k1acisqKpvLMZg3/XcB2HXfujvacAa5YHBYlslA
 E2/U3gMS
 TSagpxqKYktHrBhpMod2mhHK1TGcsxI57XZDpUUUu42isCzPV1NkpbFxm9D+E/pko3q16g6jtSSBm41FKl655Bbbs5q85x5jom6eBQNNaE0nCVVILbd0xp+trY2azEK8zZPeR9Bcm854aggGtmzVrO21SLGH0ijI6OEWxc/C6Oy86fa6+csxUC3pSwAPVbvPW41vmVIXs1HMMfgtCt7HQYbwjnILe4WsWxcGDRYF24p8yKzbASnB5EeAv9A==
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
index b17dce752a1ea..25813e3605991 100644
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
@@ -2266,7 +2263,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


