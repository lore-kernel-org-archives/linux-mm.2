Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A359C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A176B0093; Tue, 14 Jul 2026 23:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0014D6B0098; Tue, 14 Jul 2026 23:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81B46B0099; Tue, 14 Jul 2026 23:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD3096B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4EC514051F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:15 +0000 (UTC)
X-FDA: 84989532390.17.4571901
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5AD6F100002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YudR2/bT";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	b=jiTyb9rcIM0M/WwgOLcWQyfaUTb499L6pDTrHg/dhj2vx+wT7BP6XhKLutqN0aG3/tbsfk
	oWKLImTBq5Yuk+AXVDnE2gDJ3RsDbauFCVga8TKi/LDLhLkZpjX4xaSlW7BqJ8uXa4MC5H
	0jifGjB1vNLTO9SMryteIjq3iLjDWBg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YudR2/bT";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085014;
	b=zAqPJUBzJYLDPrEEpN+f7tTcjbzYQUSffaK9+ywhtIkz1avXTsxo++hIB9Ba0WCQEOjN9S
	tBPGstCmA895ENSYFqwlzyQeR85AoJNohWak5nDowxW+ZYUl5Ryp2TJFZ4Q4e3ZndoUsOj
	WG+eY+xNtEb21Ohv4ZYvZErVjo4/D4o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA7866132C;
	Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E8A1F00AC4;
	Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085013;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YudR2/bTwWI1q0jPRkBPsypksgdoLG99nsOcGAc2rvgKmzRrDGJ8Y4vCjweAbYhfF
	 71mbB3KVaTx8nG5+eejlb3GQMK7sUXBkQz7gHem0imzFpOVUI2qOldKO6sGBqlqjbv
	 zFhaqe0Yv/FDxWZnPNK9/cpvNQ1xD0HKEm/EwQ+9RSJTadu1WvkKCq+vL1Nh+2P1F2
	 bCyKySHFh6RhNV35zRnTe8tQ4yXA0pXbR8Mg3Tf4xam45pTE52UV2F75sDwjJjPqsR
	 dr6FprrgXxA3NDVFBpFg+/DSYhSANBXjxIChDE/gueZNE+uVu+dVf63UkqdU32R/LE
	 mUte1/XW+dS9w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 4/6] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Tue, 14 Jul 2026 20:09:59 -0700
Message-ID: <20260715031002.108504-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5AD6F100002
X-Stat-Signature: mg46j4n5jemigsxeumpukr4x8a869tny
X-HE-Tag: 1784085014-776090
X-HE-Meta: U2FsdGVkX18NlO/749ZF6yUwzuC0C7+9bUFDn/kdKR2cwyaDXUFimIur8O7codLYQsTs/5XMMrAF1VPzbCVGKl/+btqRo5f8X+3n8ISAmRGsRUSQ1s894jhN8i84PONjonZXXMm4Yskz+af1ls4SqegCl4nVD9gULTscSz4ZmjEprHhFTe/6sSJMiaV6GjwbiRRZWET3sESC8zmfZhtE/swhyXa/l8wOBtEe+f2ERjKwgarWU/xFUitQHAqhR+j4IlcpVf/VuBe42JlXQxnqwkWhxYq6uzdkt9jxYDa/ZKyxaLQ1jWvwYbz/ou2o9Dmd5RpcaKM1XDdL92lsqSVqSI4q5CD2Zet+ASS0fzBqq2C8z5xKWboZy2YaAqlTwFD6x+mfmXcsX/8+IMTG/hWuQ6pNTuhcvF3gHbX12koXS4OjmpBIBg9V+vBMqVZZtH+POMghPLalbAblquJyy7VOoEd2nC+86Ar3hpzE8wcUt4+Zes3KKv0qMqyCuAKhl8XouYH4CrzbvSDn4y2Ec0tvsG2jUiqG1/mLAN/VSgtbR8HyDO4x335pKd6e0sTqtE3Cj7oFf4T1joks7ujcs11mmIO/VLAjq9z9603kLJXVEW3SAzHGzGlqbuLV2IMoCi3KJuGFFb0gqGcyERaIK28lj+ooKtxWQ3FOOrXiglxwioVLSLZVJyZLcY6XQ+JHuY1Txb80MxCBtrCm3VITVUknO/5odwNXGPSGjwR0ftstjvvxIcsDtldQyFkeZcHcwaAu2lO/Ghy3PN6aw3rs+R/g4PjsCFNf+9HCpN+pVO5ujxqYvv3KN+/dQ2DVr5KpBOs6Ykl2ziDTY0dFEvxaFbcNge9nShiHrZoFEGOjL93nY2y0Q9cy8LHjIQ5eweEDtXLvoIhUoucz50kxR4t51gKelqv53AuVenuGiNckZmOqDj0pw/5n5AJ9E0Nt8sNWziHSiAsF32KHXbdkWgt990e
 pE8z1Y02
 Mn7d21yFn4fccSTan97mx3yFBU0KnddI1aoyScdeUI0I3iZQpbkPfeixp18RHdoQon12EksFNa73wNluPXezgbkgkh6G4+6Vcz5JJwiteCG/7Rt9seuA8yEBFfOVtidorHCGlDq5dn4DWgIuPdh5BkNnKCbp8WDUDEeZHwtfiv/SeAZk7bZFLLVLZF/COvx+vekkQbx3NQsx13nH3+4DARxBS1uLaB1zKJRSA1C63rK8+ETDPFmhQm2PKFQ+WTcpSq0a0/XhCuIzfadz/d85xqYAKLh0hMs0HOl/wpzDGPR5LcJHpQHfHWrgRwXWzR7IkN3ef
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b85f88a7a38f4..e4f98d67461f5 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -65,7 +65,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 	}
 }
 
-static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -74,7 +74,6 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -82,23 +81,12 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 static void __damon_pa_check_access(struct damon_region *r,
 		unsigned long addr_unit)
 {
-	static phys_addr_t last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 	phys_addr_t sampling_addr = damon_pa_phys_addr(
 			r->sampling_addr, addr_unit);
 
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = sampling_addr;
+	accessed = damon_pa_young(sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.47.3

