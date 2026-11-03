Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A094606A83B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=azCluVBF
Received: by kanga.kvack.org (Postfix)
	id 6BC5D6B05C1; Tue,  3 Nov 2026 05:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672E66B05C2; Tue,  3 Nov 2026 05:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5837D6B05C3; Tue,  3 Nov 2026 05:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 232ED6B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2C4712036B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:54 +0000 (UTC)
X-FDA: 85393406868.24.2711EB7
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23C6D180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=azCluVBF;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701073;
	b=DmN9D+YSTQC/ZyWuYYeBWcJfSQD6zs8uUjMnZc2vk6Otw6aglgCMfg2GaJMG0Yg8Jd80BR
	MAej+2Db3xcVuP5PZ5BYikDL7Ivk7BtBGDDlDcXSzjB59xvdm+3g1CrWYkDrklQztxSckl
	Jx4T1J5OL4tSrZ+JasW67IANMqVpT5A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=azCluVBF;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQZGTVWVxsbky0R5YyDomc+9xqg3NrjJBS/7gn3/iEE=;
	b=5zVWAkq+EdZj9YEwCtCp0vIGydwH6CKj33xBfOynNvY77bS+TCax7VAfk/i4exTGJQOAn3
	uMXS0xJ6R2fa2CZw4VQYObvDBI97BfM5cJmp+R+EtnKhxP5nFi0VKfTnnoJ9kbBKLTQoDZ
	RE88bGufTLswrXHeLU13jDqTz0r9O9E=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a18fc7a38so7564989eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701072; x=1794305872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QQZGTVWVxsbky0R5YyDomc+9xqg3NrjJBS/7gn3/iEE=;
        b=azCluVBFzVY684lU4pKx0s5Pgtf42e7zuLHW7G4qCGTx+PwHhIJ2idzdmlAKygLW/5
         9lZ5094Fdjqs9WB6KnWL2un1aVtdXH64276tz/QRJnsdKGEspqGd8GTqjDsGZmYk/Cej
         hPqWRS7327iNJRID0cGNXJTNL5gr/MWKeQENTMYASg3y0W/OKEI5Mpm69qCRip3TnVoj
         ZtWrtR/3CHnv/5NOWKpH3ljPDf4FR5nhqb0j7QcRGCepeqL4ULUKwn1/fCQHmxomntpO
         XFGH7Wa2ekirMwzCyk/IPA9EqjbwwIR5ui1/dp2EGgV9xkLKi6jNaEBFgjeYSraWA1bH
         nd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701072; x=1794305872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QQZGTVWVxsbky0R5YyDomc+9xqg3NrjJBS/7gn3/iEE=;
        b=Foh+f+wfEehAvQjg6iIbrxUeqUannBqSGtBx6nQG2EPJNAnHjo8XpvlwDmLKRhJND2
         9kDfmoPKT6zsdR9JnfEeR9kZrlbI4UfRnIWDUX5uhIfFI92UvMp5bx3P44G4ValnPUYn
         9pinDxxzCmr3l+nDkWIk7LhQOfSICU4OjM1DWjG5v74fT/BBArocuEq8RSMpA6/tKdoZ
         bYtbVzPdVhGaCpSVZpqnpIBgiU8xl4OdyOE7wY9HNTSotbrn32NLmkUT8I6BO6B6I5Ky
         wS4N2LCMIwSXBJrJrZctvXgFQndsgkmjHvae3v15Rzt84FVBBMLYTA0tAxcyHMb3Knok
         8UVA==
X-Forwarded-Encrypted: i=1; AKwUvBwiDbi8thTk91sn+ppBaO0RKzYzqIDbLyx3fwsuBV/Yf6ceADreYWLkn4Wsb5sVbqcCcI0x3GRQgw==@kvack.org
X-Gm-Message-State: APuU4Z8Vpktqkw1kJvhx7xJlrHOjrjQmcE+NTThMiCw20Lhrzn/tP/hJ
	NmCbtgBdGkCLDasJfEeMOiokKm08cqlht3LydukdKPBZ2+ltDVXq/RoM
X-Gm-Gg: AYBFou0MfA3smgH4BgS0CBZn2Ihxhsj2rajn0kZ43R4qrlzKMpkZIzo29MdVUiF0I4K
	cKQOZSVknT1LruZsUNW84ckNQqWYyz6eLVtDCPwJDgGEAykPEdsVCVL/CP7vUxbmsxV8GDXs9LT
	Ha0pJCh16cDeJexQe+IsimjBf7u/TSOGVY3aZjOV+grDQvIzqU36JPz+Xd3GizUfiInAn7c72i7
	gKdtZq+8hWaK98x3O1fjBulUIaXNHxLh0Jpmo8067rlpxnKzWr34yhYltZ7THlr2vIq6Azq1ajp
	+zX3dzxQPbZMI0rn3dkI5SeSmToP2jNC7h5rEwJwrOCFkKxbSZ5Z544wPN1aqn1B6E0AeHGIgmJ
	0zJ+2F8tJll1YDCskCu6dk9SBTo0yu81G5gW1bAUOEG1nhrUA5YCJ8bfiWAXq5GKiQ5Frc+H1Wo
	yRpKu2gsXoqKoV0I1krWpnFRl5h3xSJ61/IS8vfBjCbYhAqACpR04ugQcReKzFCUGK8akn61FvY
	uqUuHJ+plffnBlxYI07PkH2iNtuZ4D7kf6loz2yxWAd25jJKtuL2enplzGiN2voaI8qoRrGTTC7
	bFG+A27Ihae3Cu/mUUA4P06/st0Z6w==
X-Received: by 2002:a05:7301:2a95:b0:36c:9afe:fcd8 with SMTP id 5a478bee46e88-36c9afefe8dmr518555eec.30.1793701071962;
        Tue, 03 Nov 2026 02:17:51 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:51 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v11 06/10] mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Tue,  3 Nov 2026 18:16:54 +0800
Message-Id: <20261103101658.766905-7-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjarwgqbhwt16dezaapype5mjh8nco9b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23C6D180002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701073-333253
X-HE-Meta: U2FsdGVkX18uvBAk6OIWc9f7QHYi0dqdBrY37NetIqB2Ta6rx1iIplMB7wQ/0QBKsZSOMvms+imjFBFSir8hKdYOVwUpaoEg4GOgPcwILjJLsoABIXBp4/z9njk6kbSbQ9LtynSG+wAI8oEf2+50Af2PSXH/EWpRUsLnFuNBovo10HasVFQvHIJI4ZpfwF/hVTmBhoxxRgm+t7D0Bfi2IIk55t1qVSbQg8F077PHvi4ykWx7e0qWrscsMLIw9oqKB6gjZ6rx9X7ObFpQxDxH1raq8SCdrUwTEBitkdbk7zrKpKajisA9eGbEWHw9WznGj2xPmuwpksrKwm4Jhvwc6Sd77YJBYCA9InmOmwVckHH+8989szJsmHeX8KDPl1ViIJEUa/GzL3P0X1D5fxvcNN3LhA5nQQP0M0Q0XGC5ac6kD9Y2ba5Y6ZjYfobNHrCbUVh8M7nfMvP3G8YhkTqbfKJifL4nOrvIi56pvybqX4NqnqMkxcL3QBsmsQG5goIEdfIaYITXor5gBLAgm7Bg0Vd6epMi6lO/smnycbVjueE/sBWW31ifaoq2ZfsmD3Z2OPnpJCceJDRTxyqDLLi3CYhMX+a5gig0y0IkxK/y2efAbl5bQ6WTZuZudmRBdINdyWdK40/xGngemXGlGe6UXpcz0fmF9gz/Cp6kQPOmQvZL86LQDlnn5lg33CrKGbU9JeApPLOIewzmISYTh0oEHrsEt8IdQK+EZOPEEHowRFmroT9276PU6CGeLGSaABgE21iWCDN+lccim5g73pWxrIFYzkIpn2Lkd3kCPHymxaUg0v2n1dl99Myu/xgl86PV8iK+8uR4nsbhxyk+LM90/8LgRhKkfrTbokjweQWAeaWLQqRL1BBZk8deq8l4fP1bwrey1wT0xunO1xHEuhAfv+xCJfeQwLlwNRrGJhSbPOGI0/V8GyhDy6ponFVc5xPg/jM6mVN5ukCGATyRfx1
 aMYrEUon
 /t9mpVOWSbO9NObxQdLVVRkJO9MdqmMlpfBS+sxnkntOPwiNPAzDBRMuGDyXZF4saoXImQ+6trcYa0WYc98IKPzOpWt2Ziyw4SnN+m5E3j79i+K6/n0l1VlL1ImxzvBDj5kEE3bdvrMYpbU/y9xQIaQ9EPo6XBWbTjQXjm4O+btnAenaVXBzrIVoGvc/OxrtQUm/Cu078nHcs74S0V7SSSwKu6uBIA89C3bhjzZnTfJvU44hSn3Z1oGciMHEWovhircg88BXP4ahxFEZjPq++HjGk+sbCkOqrRJsYjsv+qUi/JJKz6w5jIz8eRbW4Pf3URWYHaiD/L/J7QMfOGxdxdDVKjioEqGUxi+nzN49gmjhc3hNUoGOspcZexW9tWc3zL6wY4nRU5H/EemGszfkg+JgAv75DF077g17oTD1TQO4AjdLZzjPG4do0ExiSxivF0hnR3Xj3UBGQ+7OCt9jxHg/tveplR4xvaOsGAqmanCHH4wAcecwI49SP9TKLGGxvJdHCX+fFBMExOnNMpcjuoc2lEPLkHasT7WARMRNmHK+uNb1SkuPnYnYQ7LslCxr8YCsk6KUV4yPMN8XsuqoklgYDdYCfgIydBb/a5UvAbcG5C9zEYItq6VaTdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index df37c8490ae7..e3ea9581e68d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -92,6 +92,29 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		vmap_pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
+		return size;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	u64 pfn;
 	struct page *page;
 	unsigned long size;
+	unsigned int nr_pages;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			vmap_pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


