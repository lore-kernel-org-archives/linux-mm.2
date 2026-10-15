Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D213CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AED6B00A1; Thu, 15 Oct 2026 12:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAF16B00A2; Thu, 15 Oct 2026 12:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082B56B00A3; Thu, 15 Oct 2026 12:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDCE66B00A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:08:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3A5D160A1F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:22 +0000 (UTC)
X-FDA: 85325342844.17.E9E419C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F31B080016
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpWmW2p0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080501;
	b=ac/2XWuVVSA7sUqZt3Qi5sUwCECi6bqwfK5swp/4BgjhI7rnaancNHz+4frR5SzqKqppA4
	4uoV6QLPfmHU/8GVxxGeXjO4+TE28VYFHv8/1IbC+v0IXI2oOtEnLU2ETf4HZVG5Etf1YC
	WflUHpBQIJeGXj87Y7LlQ4gcyh/YzA0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpWmW2p0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luu9zceebiAM3DcgabjNhnEA73HFyTTMwHsaVP8GP7s=;
	b=qfny1jVmirl/AZp8n6XxLF8w5ndxQmy+zvRv7xivUJzHmV7B9gILfhzw2zVc0Unfj08Q7A
	dRwFKiY/zFIvLnB4bwqtPbTIv6dNgmJFXgMOqwlptSMaxEuQrGC4QFpJe/k/WNdHKySXst
	l+vfLldmK2OxoxSlZ070dTSRcMN2590=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DCF960A64;
	Thu, 15 Oct 2026 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020211F000C5;
	Thu, 15 Oct 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080500;
	bh=luu9zceebiAM3DcgabjNhnEA73HFyTTMwHsaVP8GP7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IpWmW2p0cOKas78pJQq1fPzYf4OjZG1D5/E4uGVb/sSKqnGO8zzcFpOAMCj8r8Y/j
	 0fwISAtT3NHdyUMidHHvUFlN1Ohz3zEfITaeqcVWXSZ9700SpEyGIoPz4xLl9I0pHu
	 VZBaNezmk6pDEjLmgMsWOoTiGpsG8WEdR5ClhfEbOexU1Ev8s3wlE3q9Tkl81ZXpoG
	 0YtuMfNIq2fs5QkozUjwOKDOzPEL6e/QBoeaBm+P4umBvL3e//p62h/ezUx6VvuyNp
	 8LnNu/FcW0+Joug79ZWYKFiCnW7+t/ZW068LrHoTdTP/sWaR//pp2AGA7dByV03Atv
	 4GfSjSlq9VMRg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:15 +0200
Subject: [PATCH 09/10] mm/hugetlb: don't leave a uffd-wp marker when
 zapping an RWP entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2705; i=david@kernel.org;
 h=from:subject:message-id; bh=jDtJa/vbrcghzS+kebnll5J1z6JL9nvmr5+IgGhx8P8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DI5dFov+la3mt9qM5ODbX/Yn6erNG2ukU4xN+8vP
 uv78NunjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZycwkjw6O/8w7p9l0VffTL
 brFP0ttta0IMbO++/Gm6LHSF1dSsoisM/93Ut/a3rmRmX2n/dGrndpWZgcG1Tx9VnVFPu6yx3Ke
 ekx8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: qrssqotcdnaxzx3x4s3eg8dkmzz6qm5g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F31B080016
X-HE-Tag: 1792080500-565607
X-HE-Meta: U2FsdGVkX181m8WFjiEjfQ3FYut4UMJneR2e2Izki4hnpUsL30cxfEMxTcpMM4N4JR3SlqnqBzASufDzU0cGqG1rZJ34XBeUMjFa1VRuAE6CNEqd465cVVqWefLJC1ycVzOw70iNutPDRhcnf+zA/M08Y3V9UAGesTg5h9jhxpDTFWxLARbdbiFNA5nh6/LX0M7Rryj55qvuDm/byOdaInuEtw/oOU6eB5HaG21e43F5xPyk0kcjqeqwttrX7FjpbmaOr7USKbZ+gVv86TSUvTS8HTo3ZbkJnDw1PaA6NUtrAkK1xQNQmfBIUjBLYHEPZIEnMpOpR2WdzbZZJRllVyjIDUJ+bCL25ZX/L4nNC/6O3tR3z7xdNjFNkmpqXmiqHAgARdGDluMdg4o/7uoqaDE98IjGy+4Z2oeYWrs1bkbqYk4kxdOQw/mUH2gWy+OrsePUPJHOWeESEGOGv8A/KmtUT2ijSYbHOeIBst2h56bxrR4RUn9ZDsjv+/GC9/REO6iKhsS9TslzzmL9NWdkAcMEBp/tCrJHPoayWCTWO3RfTP+kMAsKYSuc3Xw9sRjvTKnc+7kclwxE9SdpC4mwm/zH4MEIzUOaU3xHfUUKRLOgY/cxG9Pq1zLwPEukz8UMTiGgvo0BvOGdd3JFElVizN29P8iru+z7OjUIe3IqP429OMUMEkYu+QiIzcVZhZNE1dHM8B0kYZ6p+GAZ8kdti2g0AW/gfI4tDpyPL7Sf5cc6xQkMiP1HyPh590k8QLVA5iEGukFADmGzUfUFH0qbIGI0hvm0YtkPd5bacE6ERGroA75yX8pm0/73b/wRU1enO7Xlql3lJsCG5dBNKq44SO8x1NllFTZukWhxNKw2/BkZtC27l2sdioGyzsbW9eVFZ1lsa1zTzHmRSua51JBTb5bw1iCLU2GK0vl1HxZDVgCyTGeFX1/xzMcNSSqSUTmAMQKqnfnGZoVJOsdLuR9
 8dfxyxy3
 Zy3qOgvUnzTLqKwHW/fpQW8g88smhAhXLcfeMOUBwv5M7QVGCa/1PPiWpTFJKBMZd/5BFmBXX31V+yOF6qTQ1EHKqY846Eo1O1sAgud7fkXanF/WFGD+gYPRgvf/w7Vr7wURDQ1jhzBMx13zU8KUze4v7N4FCEidmHGyfqJ9gV2ylmG7JYbvmIhOYK2k6Tc3dMdTgvbdFD/fBdOwhL16/JylHhodDyIW1MNdyaFSm4HSfHQqvlL/dT+a+HWj+4vEzdNdn4bpqGvjm6ZrMLc+WzYKP0OajtBILAyMBY4BWvR/8SsI1+izB6zkIDdkYC3Qq7HKCeXjJ1XFtx7zeIwx2V0IWRrjbBGf+HB1ntAEny+p9T6qTxDFONXBppiDkvvLIEHv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josef Bacik <josef@toxicpanda.com>

An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
uffd bit set, the bit that userfaultfd write protection uses too.  When
__unmap_hugepage_range() zaps an entry with that bit it leaves a
PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.

In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
nothing.  The next fault has hugetlb_no_page() turn it into a present,
read-only entry with the uffd bit.  That is not an RWP entry, since it is
not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
registered together).  An earlier fix solved some side effects, now just
stop the zap from wrongly installing a marker.

Leave a marker only if the VMA is registered for write protection, both
for present and for non-present entries.  The zap of ordinary page
tables has the same test, in cond_install_uffd_wp_ptes(), and
hugetlb_change_protection() says that "uffd_rwp does not install markers".

After a zap the range of an RWP VMA is simply empty, as it is for
anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
a VMA that is not registered at all a leftover uffd bit or marker is now
dropped by the zap and no longer kept alive.

Original fix generated by an LLM and sent in private by Josef.

Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: a bit of description overhaul+simplification ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1548a6156206b..fb51f7d02cebf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5267,7 +5267,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			 * drop the uffd-wp bit in this zap, then replace the
 			 * pte with a marker.
 			 */
-			if (pte_swp_uffd_any(pte) &&
+			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5303,7 +5303,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (huge_pte_dirty(pte))
 			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
-		if (huge_pte_uffd(pte) &&
+		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP),

-- 
2.43.0


