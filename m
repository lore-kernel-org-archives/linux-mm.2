Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83188606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 18:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=XrsGCPuM
Received: by kanga.kvack.org (Postfix)
	id 85F506B00EF; Sat, 31 Oct 2026 14:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8102B6B05B1; Sat, 31 Oct 2026 14:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726076B05B2; Sat, 31 Oct 2026 14:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5238C6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:23:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D09071C4426
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:23:23 +0000 (UTC)
X-FDA: 85383743886.01.7DD3B79
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id 08BA120003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:23:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XrsGCPuM;
	spf=pass (imf13.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793471001;
	b=PS7nP7XAdhUlhmORfwCyMkweH48DAAc90wn8FSxZL6lCne6xRGVoPTuAkM6bAXXA9bBUlc
	j3VZ+h2jdgtSGJfRmu3cio70INbUAuh1IAX+kbWT3T9i0DX04R9jdWgjzyjvnbQPTWLSoA
	kObxFQBo9CzYa1wWFUxrVJsrnFdcaYM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XrsGCPuM;
	spf=pass (imf13.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793471001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vXDRVZFCX5eXPv5+rEujKnF1AW3QkNUi2OD2EgtvPTE=;
	b=5OkqwLeB99Ctju/TJoWvzqF/wjpqftLJx+owzZoY+c3kVSTR49S61pN2qBdvWKp+aKzNxF
	Bf2CddFQeHdoFsBDUFwcKR8S5ngGZxbvI05WHUpOk236R26FtQgX+k5dxH/lIuBFG0UJbr
	ml0/W4wVxt6/MNm4SNht3Hk+dKtoOJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793470996; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vXDRVZFCX5eXPv5+rEujKnF1AW3QkNUi2OD2EgtvPTE=;
 b=XrsGCPuM38VRdyljtUfiHBIpNl0ymbf1a8Q2dBGVEEaEWpP9LN1kYcgnJMUAS4EzVEDQy1
 8AIECxw/zZwtl5GAkeZEDkkQFKgdzepJpIMMesZ3fuw4kf2kK+v7K9jQVDavHp4PT+34GI
 okUDMSsDKqJwlcC+A93kB9/J3vrg6D01FlzJw1mj/OlA6/9m130RnaE3S5Z/r+F71X3XY2
 nqe8TmGusSbF5PBI7rQtH+jDhmjVYZ7MtoorjmE0xbCmsLvJ7ELQOHuEivPUQdUn8Tu262
 r7+wrtswUWj8nlbwZL9K320ZDti+TftYw/lK0SUOZrWQPi+stENfnEt39e3JYg==
To: <akpm@linux-foundation.org>, <david@kernel.org>
Date: Sun,  1 Nov 2026 02:22:56 +0800
Cc: <xu.xin@linux.dev>, <chengming.zhou@linux.dev>, <aarcange@redhat.com>, 
	<riel@redhat.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Subject: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
Message-Id: <20261031182256.40205-1-zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26ae63212+b58a0f+kvack.org+zhaogongyi@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 08BA120003
X-Stat-Signature: gm36rgj8c13i91no5cmuo346ox48twx6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793471000-221991
X-HE-Meta: U2FsdGVkX19FLMdn4m1KOKZDziC2O0EVVPde+hlW2nk8a7WNG8VcW1wdErU/Hb0Cl1sLnSC4N6EwVjeVNEtIRFH3SCsh5L63eD/sLm0dLQR/0Ud/IeMDQNiGC2pi0kGsjPvDNorEAvbD9eaOtQkOknZQdLbEiznWDtcvaWEAop6tYEwFh3Lpjksw1LVUqk8URof/vO76ieJJeouOmTYOQbfv4i5f7fwUZwOPlG11N5aCwAqFMs+MKz+VyylwZbeUWdsAoHqVHcHIQp/g/14Mcp+nu34ynkBFgndKBDPTJGvNda8BkfqCRu3+5WJXY5h8ar2SwmRw0USFqzSraWdxL7uDlj+iTIlieQCqakINJ22VieogQB6bsTLbeOIlrNYDY2sHQnU8zRrVCoo5RwcKmN9hFrW8FTPxUWBVdjGkT+C0z9zQ88/y5Xp34fZ+TlRU1miCxKNvDzYgAcHzQdHCcZAQtPvUgqAjn61aFRHrGDh/sEJdMgWnbpGYnYccH+LfmgpdcKKCq2GpCI6nuN741+MWe0nZHhsY8ilLJA8n4qB1LeqS8w07J1rfJnN2J/QH336NpSTMmxMLzCg/cNTtZa7QS/NeODH17dyKtI6QaNBzGI8D+G3HuX1RlVknivDPMq7mltCNhR5E/3vFGOH6jVxZ3wyTyHgn8bw1bxMOEHyaL8CCDMhEERw07dh4JIDqc+Tzfk67MAxp4JY/OCi7AckLAilveOmU6HhjPqdoK897ofSuV7R8dy+rzsYwaoq3zNPeFglJe4d4JyGUjW82nxOrrb6UFyfUjxeEy6r9+H461wVVn44AAtfCTkzigZK9hA0zaky/+Ucpo5gxdLwWrxvTYtq8WlHLpBUX/UrkRANzyl0giptL5nIOowRhPYAMSkqxQG8idpZYvg/e0dFNs9v9lGNpWhILeYPZNjvBrLhJjZvKJ6yrWK/LnhECGU+AiPKpFNOiyqq8zu635Bp
 x3XFOXR3
 rja8j5Pyg+u1aTytdHp5QF35Rw0hHM98b8vPNZ1mzN88K+Sw8pq6FeccFeDbmHAXi1vyCa4q5TOSLJINs8KVAg6/q3Zc+89egDMQU4OY2llTT4mkhwoCNfmsXrj9JdphWGOsX4aU/wBLycEwifxbdo7Zo24qk4mPhnaQjiflqJ48AE+GUvA+sVtJKNQNE/iuHevQ1lAjdDf4Vs4J2k9jmEOO4TMpvo0rJRtV0D4Vl+X1wo8LJignsXHgPDPKRkhlxgKiMc95jEE1L3WbnuXMM/ZrHDwChWW+mhDWq5ZWyjh8juyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KASAN reports a use-after-free in page_address_in_vma() while ksmd
merges pages. ksmd keeps a folio reference across an mmap_lock drop,
during which mremap() can remove its last mapping and free its
anon_vma. page_address_in_vma() then dereferences the stale pointer
from folio->mapping.

KSM needs only a candidate address. write_protect_page() checks that
the PTE maps the folio, and replace_page() verifies the saved PTE
before replacing it. Compute the candidate from the folio index and
VMA instead of dereferencing the folio-side anon_vma. Reject KSM
folios because their page index is not meaningful.

Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
Testing:
  Unpatched mm-new: fixed-pool KSM/mremap reproduced the KASAN UAF.
  Patched mm-new: the same workload ran for 12 minutes without KASAN,
  BUG or WARNING; fork/COW KSM smoke passed.

 mm/ksm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d6f736a..f8af5ee 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1307,7 +1307,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	if (WARN_ON_ONCE(folio_test_large(folio)))
 		return err;
 
-	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
+	pvmw.address = vma_anon_address(vma, folio_pgoff(folio), 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 
@@ -1408,7 +1408,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
 
-	addr = page_address_in_vma(folio, page, vma);
+	addr = vma_anon_address(vma, page_pgoff(folio, page), 1);
 	if (addr == -EFAULT)
 		goto out;
 
@@ -1515,7 +1515,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (!folio_test_anon(folio))
+	if (!folio_test_anon(folio) || folio_test_ksm(folio))
 		goto out;
 
 	/*
base-commit: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1
-- 
2.39.5 (Apple Git-154)

