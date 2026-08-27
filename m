Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F95C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4766B0088; Thu, 27 Aug 2026 15:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B706B008A; Thu, 27 Aug 2026 15:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5686B008C; Thu, 27 Aug 2026 15:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB5C46B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:56:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7335B4018A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:56:16 +0000 (UTC)
X-FDA: 85148105952.02.C906019
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B304B100007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:56:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CqvpX0jc;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787860574;
	b=7ktFA21/s7Ju2KS45OO7HYSwIEm8CU0Cy7AQhdiwjXoPzjiHrB6B3mqnng98olm55kuvpK
	GCvhOfxE5VVw4rgXuI7vEAjsIzqU1xLDl2BT8qsk3iXVkNdEp1oUbL8f6v2Siv9b9Igrpm
	wjsdrgSrll+HQj7wHp61PpLCfiBB2uc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CqvpX0jc;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787860574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yXmT+LEQ61WRjbUCLimpBHndS1SBsTfjBnnvx00VCQw=;
	b=Duoh1EdS0GU5YcBbb5sZh6qW9Gmt/2vAAjWPxPAmjq4gePRi4cJ2+rlqRccyYpU+IW+4JJ
	MTIDZhiwiszOQ3u3MOkRIYQJxTnWgh0xQHAg1EBCRz391GwuxQtMsf0fHUeBDomEPo3cXl
	cwTaNroYCyDDqtWK8sSFvqE97yqHrfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 307B4601F5;
	Thu, 27 Aug 2026 19:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085971F000E9;
	Thu, 27 Aug 2026 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787860573;
	bh=yXmT+LEQ61WRjbUCLimpBHndS1SBsTfjBnnvx00VCQw=;
	h=From:Date:Subject:To:Cc;
	b=CqvpX0jc2vi3EeZtwyvsdALHmWqfFBu9TPA54ePXXCKBye6bDmz608MGBIBKYgAea
	 De8XOGagcpUghO118Jj9V2yMEVxL8+IQ5ZNqxci8Nziv1q4a41XWqFgph53l6G1N7k
	 fMJKr0xl78xlHmyChj/90LdR1VE6rY64PV9OpdDOFl6AJTPKVuNf7aIQaO6vtFXOaM
	 thIj631uIBq4fE3s9yfK/y4uEylczFepyStGQZKY5ldBIW1rqYC+Rb8cl/GQjYodf7
	 0CZTMe3mJskgA6MAxIbO5GlqZs4lMIjkoZV3lQs1jpszzFm05Q83jtbDzYMqpXlG8+
	 ST1sDQ74gWVrA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 27 Aug 2026 20:55:57 +0100
Subject: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MSQqAMAxA0atI1ga04oBXERdVEw2UVlIcQLy7x
 eVb/P9AJBWK0GcPKJ0SJfiEMs9g3qxfCWVJBlOYpuhMi9ux0s4erXPhspMjDLqQRmSuTMVdzXP
 dQsp3JZb7Xw/j+36QQrp/agAAAA==
X-Change-ID: 20260827-hugepfn-allowable-orders-ff323f85fc57
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5776; i=ljs@kernel.org;
 h=from:subject:message-id; bh=h4rmM/F/oNz34A4BdZhkckrXP4Zm0dW0AF2/rRuAMLo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLImTAuz/G8TaGmjtc9Fcv2ptndfEyxcpJdNqlnWvOqg4
 E6Lq63rO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR8+WMDK9q7bq0zwk+mLRt
 Scm07w4XfIN0g6Lru75HX1r/bFFhby0jw65tKb5bfFQO3lnZZvpMdyfz532iBSL+WdrhHqc2T3q
 awA8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B304B100007
X-Stat-Signature: 1umc3oy53jd9ri3zm6fcegcin4kd6uj9
X-HE-Tag: 1787860574-959263
X-HE-Meta: U2FsdGVkX196chwmnLUl8HkVIvezV1CS/SFSC6S/OXqwOgMSDuxoBq1+tK7coIHrutV4zb/vB1E58oXpdZac4sYdTLRW0B5F7HfDPPSaVxR6svQpBDeSg2LoXXi3PGYHeYxAsFFPUTNS5hzSnxGEcc577IW2R51Q9GkRMTknRYMbTcSPfOKORr3LWKHgo0l14/+tiOvjYXWEY7NMpjFyZfP0l/6qz82m+94zIBJlVcqo4y/fcRkDMNUSt6NepW4E5k7fDWxt7QrCLt30Z7o+w/cfwfur771LxOsfhAqtbSX6yr+dT1pclkh1nZd47lanJE1VUVdKxtoOrz7yikw9aaGjbVeUpiYMrECbRK3MTSVNoN1t/WK31UI0RtdtSTA5e7WoiH21J+ToIJ/geeCCreR77EndVoZF0ikbwKplgpcWKHLGqVUJSE6Vpti+nmoPj+YnZnQa9Xm368YUpyKqL8u3ufUZwqSVOsXf9lsgPJvX6v1ftfxRRTMySz+PYGKOb7jA9L3MU78EhRqrbkvAPaVCmjDUn9a669nB7/CiS6OiRxWOCFWEX8TLk491eVZE1iUqI1BVlcnXnEbFRJaXLeYjfWyBDPHDMT8jWZtKbSajmn+QHLEHZ0dhjY/asRiU6Uz10uP20l18T4Tbt8gjiqeAFpUK9wFIJT8IusvCzmWdR3FDg42sw87maCiRIvWj6M5TthX7DdLU5qMDxNphN/1wqbIeCY/dW6bOEDFwzQw8w17EEhjJWTEblqz+R5wo+vIoR8PwOidCYf5SDgxcf11wKoYDjiZrIb2YQStJAiST1TYU3VUdKI5gzP5Ab92KeaDkgQn0Bpg5/qVArfCDXWZ7A7B3qrwBnPfz5ocQ0igMGuYXdMHs+uekJgYbVY6ff9ymaZMcBjzgsbKUedohx/y35IUnEopvqNt4koRVc6TdupXXj7K03qIgY64j4g+lFwa5XyeUkvJU3OmIFAX
 7YsSTUTj
 6S/StDcyl5OS4CN23rESbgHc7h2/gN/VZr7SWPx88fNuS1eKw8KuOGGp48lQmGMU7DZiXOpNpONTBrpgzAIsrAhCqyYbrOrp15/0f4VjZnXk+u8FJjsHkduHcJDsPSUv6bZQLPg5khh0YuTQbU5UV5xNllLkBzV3THB2RdDgS9YH6wtVztk5EbIk5ECAQYF2xBZtLf94eFRWVXtIsWcKS1UfNT8QbNreMyinQDIXpEHe3XJNBoaXjkkMvzSjb2sN3KZX22NZlWO4f6hzsVrUgA+NcB7sM97r8OChE9KYL6zOEXco0k3b5Rs+TBDsbIgp4B5iO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
confusingly only control the behaviour of THP in some instances.

They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.

Long-term, THP is predicated upon compaction being able to obtain large
folios to populate THP ranges.

However, vm_normal_folio() returns NULL for PFN map mappings, thus their
reference count is maintained by the driver, not core mm.

As a consequence, the folios are not subject to reclaim nor compaction, so
are not truly part of the THP mechanism at all.

However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
introduced the ability to establish huge PFN maps, they have been subject
to THP tuneables.

This is incorrect - if a huge PFN map is available (defined by
vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
should be mapped huge upon fault-in.

Correct this by explicitly checking for this while ensuring that smaps
continues to accurately report THPeligible statistics.

While here, abstract the entire file-backed THP check in
vma_can_map_huge_file(), with sensible separation of logic into helper
functions.

Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
maps of shmem folios, however they are marked unevictable in
drm_gem_get_pages(), and in any case would fail the reference check in
__remove_mapping() even if they weren't.

Failing to map huge PFN maps has resulted in significant real-world
performance degradation, see links for details.

Reported-by: Cedric Le Goater <clg@redhat.com>
Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
Reported-by: Saravanan D <saravanand@crusoe.ai>
Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 86 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..4bf7b670586d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
@@ -118,6 +118,67 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
+static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma,
+		enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/* MADV_COLLAPSE ignores tuneables. */
+	if (type == TVA_FORCED_COLLAPSE)
+		return true;
+	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
+	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
+		return true;
+	return false;
+}
+
+static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
+{
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise and marked MADV_HUGEPAGE? */
+	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
+		return true;
+	return false;
+}
+
+static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	return vma_bypass_thp_tuneables_file(vma, type) ||
+		vma_thp_tuneables_allow_file(vm_flags);
+}
+
+static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+		return false;
+
+	switch (type) {
+	case TVA_PAGEFAULT:
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		return has_huge_fault;
+	case TVA_SMAPS:
+		if (has_huge_fault)
+			return true;
+		fallthrough;
+	default:
+		/* Only regular file is valid in collapse path. */
+		return file_thp_enabled(vma);
+	}
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -190,27 +251,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 						   vma, vma_start_pgoff(vma), 0,
 						   forced_collapse);
 
-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
-			return 0;
-
-		/*
-		 * Trust that ->huge_fault() handlers know what they are doing
-		 * in fault path.
-		 */
-		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
-			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
-		return 0;
-	}
+	if (!vma_is_anonymous(vma))
+		return vma_can_map_huge_file(vma, vm_flags, type) ? orders : 0;
 
 	if (vma_is_temporary_stack(vma))
 		return 0;

---
base-commit: 234e77148199ae43b83a0a03a3f481e03460a286
change-id: 20260827-hugepfn-allowable-orders-ff323f85fc57

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


