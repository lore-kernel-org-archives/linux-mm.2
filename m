Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1CDC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81ADB6B007B; Mon, 10 Aug 2026 23:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC226B008A; Mon, 10 Aug 2026 23:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7996B008C; Mon, 10 Aug 2026 23:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 478E26B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB44C1C0DC5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:10 +0000 (UTC)
X-FDA: 85087502220.22.FEFBA21
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31B06140005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=motWnnzm;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6D600qISDM+QQRVU2p7DCVxL1IDlJvuL+ELgqy5iEU=;
	b=t1+dKwiZRg3E7NUi2hlRw5Xw449cUz28H+fkQekNGLBZLCAQkYkxcIVRrHhueupbvrxixt
	RNtPWfxc+c8GdxTIlDkG2EyL0JcL/FeGPHY4ejJq5d/0lePpy1zFr/wyy+ILoh0ypm340Y
	4Fg9R/y86106U3ARNABLqST0oAPKV6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417629;
	b=dzxDnmPplyYWAXk9lw+agviJt8qKDGfBdigRuxYgRwNslWTkWFcaiQaxl5ONtXzPpHWZlP
	F3aOGxL9teQj11UMdlTWEr/XE4MjLuY83OG3thOAObs9df16gn/esHwPAahT8fIjrmsATG
	aI8PgrSMfU0+QM1Yeb4JC3SnShdb1EI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=motWnnzm;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r6D600qISDM+QQRVU2p7DCVxL1IDlJvuL+ELgqy5iEU=; b=motWnnzmr2o6TRv+iCXEnjqKHX
	HLOaQ8VhFNTgoIunHfm4W00/hOSLu5hCbKq1ic/tDm/sPKI8TDIIVhnDfCaMwCTmb+RiXkyDv6N6b
	pwouy4q9lCveHsVrBNToskkxLIEnnvsX/4KZ4NDKlQYzBT1FoZOOKtpWvVr4hzeIm/0v3I1RUYPL3
	YYuVBkxyry2g1AWm0cRqgiCLnMHG+z7QqYdpwesaGR3fojqLcc99SxUcvuzAca5VPQq7ihx82eblv
	3ljsk9hAz4sJjNMIPOs7AsxBFpZS2Z5uzXUpYoVDzXKarvQbgdTlvC+hnwgXgqlXID/+zhTHaCEv7
	ggh58I3Q==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2ixu;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 5/8] mm/gup: fill the pages array outside the pud/pmd lock
Date: Mon, 10 Aug 2026 22:51:54 -0400
Message-ID: <20260811025157.1632867-6-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31B06140005
X-Stat-Signature: 9mufyfhcjwsjy133wjybok7axezcaaqd
X-Rspam-User: 
X-HE-Tag: 1786417629-813088
X-HE-Meta: U2FsdGVkX18k1lHwNzV1cKFY+cfV6UMRl1vUymcf914t25DWbGlJvPPG1D4goORB0XHSue2T43mtRjqeOb7ZebhwSBHiPpaRw0ahC+70ZZCWxMt6dQbCqgELyfzQYh+GjsUgeBR6toyO5gaiaiwtfVoY5VhxPfy6/uGwNe2lQ6LqNckykeOenkoowjMzvzikSIfULsZNtFox3kc9HUm5uU31di7p4W4S/+icfT0qe2cF9QaCEUZ0PyHg/0ESJApzNCiFTg/1bbyRV/xahvyjevsOF1llsOnfIVXMmePaEHZJiwsz6+XVo431tQM8u4+XwluGKHIR42YHvuKmLOaP0emr6X49v/6f1HscqFYuBcyXl9X00AI32Ed2zd18ECPA0l6KWbjFZhOaGAR8XcFU7KjXlKDMDjPcZ5c5grNIhZAwFk2CpDPNjZCEpYjqRzm9RFvXr/TQ9PBUew8xnGz5MnvhiHs82zwy17SRckKlwwCbKXKoGJVZQNSexAsu8zn3IR+FtsQpGzDOxMS/mhA5Gvmn3aENXakbLyOtwbc1geXNaS02Hdepv01xel7/dSlJSJkWhRiGRjJYUS0Fki7a1+PtROFPEU9XpYsNR8TH/ve8f9GXgpLHxhLq5F1YvSmrU938cFcACA8BXo3JXVN5wDrbpDh/t/XTXN99pSxcZv++qKPll8lx4yDRXQj2UBhbrtlWUzHEtQrVHY0a+wEdom5SeDGg7k4AxxJzxtfcMV0uYQATX8h924oq6QJOl0k9wkPi3jQJ7Up4v6TfgKqKNI02wuEADHH3DhlowiVTeqsaZqOW7ivEe1lmckDsRh2S3QPWGxiHarhqYYcftqAnp9rNoukdp6Qvps7rUX9EJ/+FlZVvhxnUrlkSom1tbH9iWPBG3ReGQf3n7wiZOQQjqGR1EYhjA80eyDwGJKduoc6BM4BxGyMMXijhWE4Y3G/UAZyi7o7+VRePEtfyCNd
 bp/JfaOv
 7kymmEKq8alNRoTkpI2Ic1ya5Z+Zp+75Q58VI9K3WFXZNwrVl4HB18gCcdmry9XCinEuYJhnWPoFjguMmELRgVapgaBwy8q86A7Xg7Nzd9AxQFqwRvSKf4Et33wfMIkN4MOnH9z6YhNKz00HJ5Klo62Zi+NwO9eIW9hI9Y2K9+PqNjO4loAUoXSGi7A166toojMk0/NFYUEDKL7n70lBCMLhr1opqbjgW7eF9eSYVvOetMBGpLvOCbL8TrgYCp6RABJLD1CzK6QZetRJWkc03jmIKKuf4WwP77ntMysodCRj2PYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_huge_pud() and follow_huge_pmd() fill pages[] and flush the page's
caches while still holding the pud or pmd lock. Neither flush_anon_page()
nor flush_dcache_page() needs that lock.

Have the huge paths store the page and let follow_pud_mask() and
follow_pmd_mask() do the fill after they unlock, so the flushes happen
outside the critical section.

This should be safe because try_grab_folio() has already taken a folio
reference before the unlock, so nothing can free the page while the fill
runs, and the fill itself touches neither the page tables nor the pud or
pmd entry it was reached through.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 5af6a23285de..4036d3dc27df 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -695,7 +695,8 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 
 	*page_mask = HPAGE_PUD_NR - 1;
 
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
 	return 1;
 }
@@ -760,7 +761,8 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
 
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
 	return 1;
 }
@@ -991,6 +993,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
 	spin_unlock(ptl);
+
+	/*
+	 * The ref is already held, so the page cannot go away: fill the
+	 * array and flush caches without the pmd lock.
+	 */
+	if (ret > 0 && pages)
+		gup_fill_pages(vma, address, pages[0], ret, pages);
+
 	return ret;
 }
 
@@ -1012,6 +1022,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 		ptl = pud_lock(mm, pudp);
 		ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
 		spin_unlock(ptl);
+		/*
+		 * The ref is already held, so the page cannot go away: fill
+		 * the array and flush caches without the lock.
+		 */
+		if (ret > 0 && pages)
+			gup_fill_pages(vma, address, pages[0], ret, pages);
 		if (ret)
 			return ret;
 		return no_page_table(vma, flags, address);
-- 
2.55.0


