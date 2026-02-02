Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76535E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBADC6B00C7; Mon,  2 Feb 2026 12:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D855E6B00C8; Mon,  2 Feb 2026 12:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC096B00CB; Mon,  2 Feb 2026 12:20:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5A306B00C7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:20:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87B24140234
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:26 +0000 (UTC)
X-FDA: 84400180452.27.D3D5741
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A96EB40013
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgaVGUjm;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sq16mep/iYQaFBvDSBoeA6lrsbFpK2J8G4JVLIYDXE=;
	b=DaQjIV2AK5fuBq+nDj82+4u+ONlKuzoKkoWeSLj1YOU8guuoAxDpMyoeUnYzBqHcpoxTxC
	zreGI5saR7jPFwrsKQFm/zogybvvagwVcYpSTeIvGzYGxsCaY5NA5slWasIvBO0G9LX1v1
	K3hN0VRBvYUqKfCfUFcY1UlsJOHt9ME=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgaVGUjm;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770052824; a=rsa-sha256;
	cv=none;
	b=CLnCzAiWVrq2cUI5QF+u70ZeeayclYGcrjf/++5J6M7LcSnWeOgBXim1lxU8Bju6pK/Rcl
	hD9f+mnmlE0TyCOfGMocP0tE6u0b/myFdp7pJ5wKTbq97EMwPMxtgJGFWWB471sFuXcFDD
	GpQ9kGOVuYoj9S2BHdXpvW0+tF5SvZQ=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b740872a01so282644eec.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770052823; x=1770657623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sq16mep/iYQaFBvDSBoeA6lrsbFpK2J8G4JVLIYDXE=;
        b=EgaVGUjm7mB/Uj3XNgjrbYo28k05rnfpiABHFNd6Vc5qvNMg0PbyM2JENBOidkQwBN
         xk5ZvNGhxsb5uvPC8KP8OPrIMluvrNpAPvMypErNYwpLkQ5MOBemygEc8eK4O2DBGP0k
         ftDEnCqiomHd7NvXWtYYEb4ljJH7lOsKgWbDN+86QrqZfKODFZAqh4z/NSXHdeRPMJ9a
         uwMi46KnyYonzzme4iBWS5BNnlF32WHL13T11DgGR78HQYtSAGHMFLg5fw690b+j9stk
         CWKNdJa2RRqFgSUSTi1a+eEyqf1q4/c7cIhfXKuBgStmfwWco78x0jgvpqu8GuzYuWvD
         Xcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770052823; x=1770657623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3sq16mep/iYQaFBvDSBoeA6lrsbFpK2J8G4JVLIYDXE=;
        b=Q/XSYdX7WLhTzGHf2Y8jZogp33dgU6fDjF6jLxvryoGutXW39CJoaF2tzpnHAyg93o
         pZc+pV0itchgoWFS+wXONsXL3mLS2/yjU5RNbpv8IUOqCvFTlCyarFHDo+8vz+3o9nBF
         3/wI3nuL6xuHgTz9U7mUoTyn3NCKxXsDivxADdJkVFpOypb3S7s3QnHcGLrwDR+60JTC
         1yv0GDYUsaZ8SFMrkjJtlt6zkiozfiPgg9bLdJEx71HzAIXmBR3BydafeSJmseZD6w2W
         xfRXl3LHS1ppOvvRwoVrdVWKSS+V7e6LnuBcH8Eq/f+xaIZ8rkzM5t2pNLbXvvu8l4wS
         ySeg==
X-Forwarded-Encrypted: i=1; AJvYcCWBFLGck8tFA3j3T6HpLVLP7OyCZVaULiU5uuwjjxvGHX606tyDFduiT8tNH0jGmNEkpt0/AxPxnA==@kvack.org
X-Gm-Message-State: AOJu0YxJpvPsS5EMO+mZ56FbmtQ4H9qpu0rpDMz6USMuw99ypP7bi7gH
	0OnxjyhtT0LYvkQWnFHfUSVVzx/G4Usl2mLFSRpoQgfUohVP11KSoKpX
X-Gm-Gg: AZuq6aIvFXtiB6jFG6Q8dASti3eOaOMvAuSRdU6Gj3wCUa6jVa7vLdW+IfivQ2xBdJB
	FI2OjwN6rYouY3bcFJyhRlV1WWgdmtRrPusdfRtrsl5hOvrfbDD5O2k8IBaURwN1HjIVyMruel5
	Op+nEs5GIFw+/Oli1pQWZYdQGuuC3GSLDj86yE+G0rUsRJXAWGySd3F4bifLyYZNuz3TeCWKQgC
	Uq2Bx1Su8iE9l0V8vWBVM7ktDtynOAcXy8jUkIYCYujkTATVHOQzrGzdNSKfYQ3ahMXSnyGbu1A
	CHSsaPLr4sJAi8THLvxru4GRBTF26c1GMnyUPPcb4pkQKnjBk/lW5tZW7hch/UthnAgr9kkNxjz
	hG/PcGHEEgf+1JKQoySpw+fgz0c0qIElnGl78W0oFjnVCX2KQuqLDVH/FibkMAXpMVMiIV7diJg
	m1stBh1h/pM38VY50CwhO5GhYw4Rz+MQh9wRRD0jqWGE0kn+fpqgAKpTNhEf0=
X-Received: by 2002:a05:7301:1f0b:b0:2b7:17c4:be22 with SMTP id 5a478bee46e88-2b7c8632fd9mr5191644eec.1.1770052821832;
        Mon, 02 Feb 2026 09:20:21 -0800 (PST)
Received: from fedora (104-57-70-139.lightspeed.sntcca.sbcglobal.net. [104.57.70.139])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1adef97sm20129902eec.29.2026.02.02.09.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:20:21 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 2/3] x86/mm/pat: Convert pmd code to use ptdescs
Date: Mon,  2 Feb 2026 09:20:04 -0800
Message-ID: <20260202172005.683870-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202172005.683870-1-vishal.moola@gmail.com>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A96EB40013
X-Stat-Signature: 3nctfejqgk4a5try94esk43dzz9bzesh
X-Rspam-User: 
X-HE-Tag: 1770052824-56479
X-HE-Meta: U2FsdGVkX1/aGHP355T7ThcNflA3Hs1aQV9A1E5QqSSZLs3aYEeS+F+Iy7Tv9b2OOGXxGQ1Jurg160Yg8p19MxxVYDIc5mWmomR6TVYEJVQKryteyB7PHIWQfBkx9HDEnR0keszT90MD9aWcRGtTzUCkFCUJOMlOleHYBwhQBD3fdwpqEZr3Y8zJptJBYSnz3WsN63Ttm7GwYpAz+WTyz7s5rKwW6vRcMUmKKjlyONTXQT5RiDqv/GteDty37za6HYfK5vxJYMCvE9n9EUwHEy7PfGMO1yboO3ngJptcwKc1JkCnDV9ILIch9TYLeTk0E3atHAXOkUfWOGrtHmr3Bjd6O5MZFZzIEX4qyonRdPY0dbtGf0YKzSB+zZ9lotf6+cBuLfMj7Dmk3JvRqZznBszgmXCJzKUqJ5uN4AU+aVAJp1XP0s0rbFgj0QS+ktT67ehWqnY23abPF1TgtDLBM55zGbFzAIdoGPP2wVEgg4zBIH0X5G0FiEoQl3+Kx1ir8tIOeN3/31PB7ZYBzFmcv+PcXdxKOqc+lXAcYQ1AKBccXpZiGKtK2wjf2oV1F1Xnlv8qyuOLSnFOTE8KlZ/gXODE6yCzp/aGyTIkBx9Xiqv1hoZguMIPzm26f/8gl9OpJwTDcO7sT6zW9zZ78rNs3I8DCC/Z3fh202UCOUw0YeZ8y/H+SfxLHKaZSJrbuzja7zVzf7dPZ7saZZZQCDsBupnO9ZOdYkxFJ8RnzIgVR3bnwgs+tv6dT2qgovwRQrlHjEZrdhljvhYWxppfNJOno6QSuwEaoUbEkDR0YtoyBk1pJOmNNREY0ZpYPgeVaDAXDc2CjKGCV01rvO0w29VyyijAXA2bRfkG2/ABUumX6ly/sr0R/7NvmPFyXDDUPzBhuohIorYAq3t08yUqEGBoDrokVVe/5/vO3y9UFrxH/7XPS/fiQ5z1Wuh+xkOehAsS4ec8PDu6eG1ic3Jk1JS
 JRAohnQw
 gZXTF3bTv3BoCWu7kd+ZkBEnmiJesNY4DaQhpmjomMCyLAmMuIK/Z7u33nF3in5hWVt6m+FR+heaLTA3t5Hg/KlkTbQTQzlZ4Lw0AF+lqBnWCQTaCqaLcUXYo30XNKwSOlBtvPMAuK+XP2zErdVOg+/RhCaEInY6OuhyR9gJd6cPZpc7+PeE2cwlyafU/TCVdlwpUGhXQtbWkJJ9B5gkhRvi70Nq97Ctx2vuL/bRMic2/CiJUnYGdSkor978cPzCCB9bTcnr1pqyCiY2ZpW3+lNKJXE/2rEH0mb+c6AEAH6lPtxir7ptE0JHB3mLya+khfyNkYtd12qvAzk5HAwdR3Z+c3Z3pCr2c3OMTSyHPjXxb/hacyVF5rkyxEFOe6UdoOt8k4/8xAxsWBaHzYxxnMicZ86HDrJl3NRwDaP3AOo4gC3VA8N5kpdxoUBQmrXHBFGTO1WUYj4+NOV/3r76mAL2GffHEruWsb//SHB2b/cAa+F2qPmVBLe9VIbywuEAXN6fd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pmd
allocation/free sites to use ptdescs.

populate_pgd() also allocates pagetables that may later be freed by
try_to_free_pmd_page(), so allocate ptdescs there as well.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index f9f9d4ca8e71..9f531c87531b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pagetable_free(virt_to_ptdesc((void *)pmd));
 	return true;
 }
 
@@ -1550,12 +1550,15 @@ static int alloc_pte_ptdesc(pmd_t *pmd)
 	return 0;
 }
 
-static int alloc_pmd_page(pud_t *pud)
+static int alloc_pmd_ptdesc(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
-	if (!pmd)
+	pmd_t *pmd;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!ptdesc)
 		return -1;
 
+	pmd = (pmd_t *) ptdesc_address(ptdesc);
 	set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	return 0;
 }
@@ -1625,7 +1628,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 * We cannot use a 1G page so allocate a PMD page if needed.
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		pmd = pmd_offset(pud, start);
@@ -1681,7 +1684,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 		 * Need a PMD page?
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
@@ -1718,7 +1721,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 
 		pud = pud_offset(p4d, start);
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
@@ -1742,14 +1745,16 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	p4d_t *p4d;
 	pgd_t *pgd_entry;
 	long ret;
+	struct ptdesc *ptdesc;
 
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
-		if (!p4d)
+		ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+		if (!ptdesc)
 			return -1;
 
+		p4d = (p4d_t *) ptdesc_address(ptdesc);
 		set_pgd(pgd_entry, __pgd(__pa(p4d) | _KERNPG_TABLE));
 	}
 
@@ -1758,10 +1763,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
-		if (!pud)
+		ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+		if (!ptdesc)
 			return -1;
 
+		pud = (pud_t *) ptdesc_address(ptdesc);
 		set_p4d(p4d, __p4d(__pa(pud) | _KERNPG_TABLE));
 	}
 
-- 
2.52.0


