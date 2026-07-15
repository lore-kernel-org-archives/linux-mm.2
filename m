Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6E8C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040296B00D0; Wed, 15 Jul 2026 09:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017966B00DB; Wed, 15 Jul 2026 09:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E975A6B00DC; Wed, 15 Jul 2026 09:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1FA6B00D0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:44:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7113E8013C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:19:14 +0000 (UTC)
X-FDA: 84990764628.13.22977B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id D0EC6C0006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:19:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cMFHUiae;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114352;
	b=YrccoXMlWJLg58UKpzcqazWQk6CQ3obcgGVMwrPVuQzQUDqQpCUnA1WrJHdPPdJ7AqUyGM
	EV44kygfabvGaoBgfxWqr62udnSpcSWa/oOnm28j3C+dIytE4A9EUePlyCCndMKXblJJEn
	SJmcbP/1yOA0lvf+8PD1/ojtfg3i+kI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cMFHUiae;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8HQK3j+hj9rSYQBF4yJj28ze8bkepKp+VZQL5j+x+Q=;
	b=KUAaoeDPSdoD/+/HgBUowRSArmDPlfGOKnaPyctpo87p21MzGiJSuu6xJsu2HSkSlgXewJ
	rL90mCN3zBsZ2FDNy5+F0qzbJh94+3IkuGO0lqv5/dWxg3kdJ8aTD3iU5tbCBuYmCUXXM7
	kGwcfNPUAmgSyBrlmC4WcTuoB0w38io=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9139153B;
	Wed, 15 Jul 2026 04:19:07 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EBA483F915;
	Wed, 15 Jul 2026 04:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784114352; bh=+o9DpSGseXucY8pTcFbS+W9IBHMvf3AT4jdAayQBJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMFHUiaeqiLmMlN8BYlKnh6OjgLR9tKyb3ltisY+8hUHTgVbih7101lm/gflcV05s
	 aK+QLl9e+84ArIvxO/iHsUkLoj8mfp9CmE7xTuFSSUpzMRuCkkprSSvhYSYcCuxIMl
	 yoBAn5gFAkv7F+upQWY0lmCysJeHP6wuXfi+kueM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	liam@infradead.org,
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 3/3] mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
Date: Wed, 15 Jul 2026 11:18:36 +0000
Message-ID: <20260715111839.1667914-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715111839.1667914-1-dev.jain@arm.com>
References: <20260715111839.1667914-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0EC6C0006
X-Stat-Signature: 4u4zwnmexx59k5mgs3pfcd9mu5ts4df7
X-HE-Tag: 1784114352-745454
X-HE-Meta: U2FsdGVkX1/BqzubXnWbjbpfK7jSXbnblyy2Ow2j52adn9tIxR6rtDZcC1I+54ZDQv1N/IF+cECGw1ysTCyWq0aW9XPVe/h3sgXtgKmP1YSXxy2cHd7nd0xmnaVdcftvr4DoJz6MIsm2rFpJMQ0uYTB0MzX5d0OZ2twb69hI+gEN+N4wXbRB6rCtQG4S4ob3F8XFzSmLBZXAwMkf85GAj5NaZ/2o/Yab9egKA3ym4iX30B5e7gFUmkZwcgoWwiO59pD3zgX8u7OMp7JEpxdJJ7CxNiSxqJs0Gt/E7ulkZMqkGgZ62hXY65LkL0qdzq5Uck3bcONprER5ApP8PvE5xV5bZRMIlthtsXtSW7ZbuteFZHd4Q6UQTTyL7K5LPodxlnCPQPISv1oB2g3gixCKNxm4CcT29TB28VAHcrP0lsoq4yPH0Bu8atcxrqOBJiJvP1XrE4+KRbh083Ib6pOB2tUYbeUV9ZMuqsMiVSdwJQX5UoEnw3ud4fJkbRXXPCKzm0NYjIgsw+RN0q4Y8fWWsON5UnkrPAVc2nbO/f2HgEQzF97UsQsxIy+L3ZsO1NTN/p53ADL6UMFzKIgSzaBIKYeCbDyfK92UgXFGlQ6InnDZ3CC3AeUN2+9bL8ZkWErOPlvZTTmb4BqXtOt/SeDHMq7y3P2khmrfc8VT5+RkayrJ6VjwUZZfIGl28TrVUihu5xQLZBY2w6LPLvKYPdm8qqZI1NnwRnE4dw1HKaPeKYNptF0P5xFU5T56Xu+vnsihneYdChzIeq25UXE0/aLRH2imNzQZr3mv3vP8Ylu7jtSOShfDfGoxsB3dBzw4wPbiWN4zZYcKhkfWh0Bxe+Whe8hp4E0gpIguUkUiWirl64jzMa2I6yi4kaBv25xgkJDib699k9pkcBlf6xW02hX0MPMYnxr+WZuJoK2ZzfUkr/XSNkC00eru04mVL6UluPwdnH+kEiyFF/4WxNCnw0W
 os7HFCya
 wrAu+PKSS/ckn/PlLuOzPk6J1cFmxCjyXOV3sC5MQ5mQ5LuhjsGdebFiq2Xl2IvnZPuAICcGRV+io0YiPMflE5wbplynChf/D0j316dHDKYwbOKkfT9WAZ6+wZaKlb293GS1gW+I3z6xRoUoAT1P/ddKLDx7XBfiIV1GCZPi9MwdXuAkn1GjaV3EuqfL5u09cz1j3B+o/hPAF5RKHUcqUpFeltu8/PqyPtCYlWY7YuENe66uNmX0v2J9h/fy+mySm8dd14beXg5ZXAha0EhTfgc23u7ra4ALb5KTvMDr2AcH72ZE=
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
after unmapping, for a file folio:

present -> uffd-wp marker

We must ensure that these ptes are not reprocessed by the while loop -
if the batch length is less than the number of pages in the folio, then
we must skip over this batch.

The page_vma_mapped_walk API ensures this - check_pte() will return true
only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
There is no pfn underlying a uffd-wp marker pte, so check_pte returns
false and we keep skipping until we hit a present entry, which is where
we want to batch from next.

Note that for the uffd-rwp case, we already do not make a uffd marker in
cond_install_uffd_wp_ptes.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Dropped David's ACK due to the uffd-rwp changes.

 mm/rmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 2f938d0ac6953..ac88673600fa0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1965,9 +1965,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_protected(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2345,7 +2342,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval,
+					  nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.43.0


