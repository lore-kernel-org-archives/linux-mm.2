Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC24C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5B06B009F; Wed, 23 Sep 2026 02:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65736B00A0; Wed, 23 Sep 2026 02:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E0B6B00A1; Wed, 23 Sep 2026 02:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A99DD6B009F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F372A6A92
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:18 +0000 (UTC)
X-FDA: 85244049996.24.2E88749
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 654AA1C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVdr6EMD;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMhtuKKM9junrQcHfwBMD2RoOkQktkfIp1wjOSUMcpY=;
	b=cdpB5Hvl9p2KaiXm0taWqfQN3AinWPVN9GATtlsZnJj7d/5Q0BoR+NXlzI7pfemygbWKms
	xl7Yo5fNe4UPmUIbkaxIZojFF5PB/AITePchDOHLVcCj7oXM1WiavHH+nxevMpFHCn0NSS
	hqIO9vpbirBnfA7JkumrBZIibgc+VfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144956;
	b=NSGkHgG9PJSm+zrurfAJZFszQdiVBto4HGfEgrmNtLTegYQeZuzei+iuI0ekuNFySInsbc
	3yly0jA6YOwQaipkKGmM+L2P57uEr7R8ovjYR9IpNF3Hgw6sU2K6r5zOJaRvfEdj76iPHx
	v0nfBMGedKMKajgzULg/KUQt5HuJqkc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVdr6EMD;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd88a115ebso3228975ad.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144955; x=1790749755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XMhtuKKM9junrQcHfwBMD2RoOkQktkfIp1wjOSUMcpY=;
        b=rVdr6EMDVQP3+YYk2CEF2BpQyB21kLKvTRUqXtwkogOi+O7Tj1qcd3qQpr25Y1yyQg
         SMkwEUu8M7BEJvdLAJjSbhRUs5HwnfjO7qKDlRNdkiIzKKeVLsKUBYv+aoAbPvpLhwcS
         KRtj1biJG3j+AWrg0L5vc2DtFlAzdM3O/vMG1a2FDHApYRqQoyxATOXX1YjAfRie54l4
         hYHHkXcimF3RjxBj8DGY/GuU+FSi5E1NpSzkpq/c4EJKos8tA4Jpgrk23mntbQaY4+LZ
         oIP9vutAkgvtJFN7dVgj/oe5soL0pVFMVwCowGdrCp1CeIzbrKLoi4xFHmVFCGwGM7EL
         HdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144955; x=1790749755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XMhtuKKM9junrQcHfwBMD2RoOkQktkfIp1wjOSUMcpY=;
        b=vjqIRA/mPschRDlarLyuTeLuHxvr/iv0DsnY0Il24WdJvRfG8oTOfE+C6cHcYGR2vo
         lQQNdsoSqmQGQKA1VAcURoJgjvjH596iSoJGIIn/FeaxQ8gyvb6WAQ8GmikEjPKvgveE
         8Z/fPCWz6f2nF/IsPr3p1eoQZYZ9zvrlJUEVWUBPh4fXjEeJkiZkvOcIEu5OalrR+4O/
         yu9x8XAyOx6En5FAEvgLAqYlui/Dc84jiqhTXBRm7a9F+5S+HdXi/nDBnuQEEdX+PAL9
         Km7mwAwWEOoHpp9i9u7C8EblXSKnJAn+F9yJUUs8UufbsG6Bw20p+kYy/B5Es8So+twy
         3Sbg==
X-Forwarded-Encrypted: i=1; AKwUvBznN2vRJfntqBPYHVNyCu3G9ogkTOanpd4PeN5M9rN9ceyu/JUnam7lv9B3jbYd2p89ZoP/CdsVpA==@kvack.org
X-Gm-Message-State: AFuF++mKx2wllxHxLojjT8KhPOb50ranMkqNXMg2DoePErdvet5EwBKD
	6hsYvBnhM/ZKM4ZOfgSKjdKMSY++jOApoFjbUfUTAg5Su+c8Z6KukJYy
X-Gm-Gg: AYBFou1GaR3q+1cVyumGpj0R2XnXO7EDTJjyjqiklfDFuZdwoOwmSjAhakCyXxn7Eey
	39EiPx1Ogo8YSv5RpFZPolx3rcSuvc6svgpoC5iKIftsyEeGpA8qM4frE53ovHg1Qh2UjIlYPBc
	3Uz/zbttRLar6E+3+/eyrCCaXoLyI+Zlm5P/Nl/rPHH5fB8XZxBxhxiw2MTTEnM9MAFf+oihgB4
	6IkmacSXEnSCMisdL0eke1YUrRf+VL2uyzikF6pDdxkJSHnTLderJ0eNayrrkjLsZDH/6vjDJq8
	CHr1rz9bdTQZnC0ZU6c8t3tfopv91uuaw8Epv9w44hh6VW9vEXtViDQdYJyAIybGKZlOkjVp+sb
	6p8ygWQFrYE901Zn5O1aGGVeKP/mbVPfv/N3FE0tOB68ecLYSuiasKMBkyHyO63k+s7fdZ3P6BF
	UOL3dZY6dNRZttxPJMC7NGP7Gw7L9YmACcvxd0z7lLjVlfyh2juHscW76QF0wSocOeY5jn+6QUT
	66hcfhNXp7E35Gm2y0n7Q==
X-Received: by 2002:a17:902:ccc2:b0:2dd:c100:4249 with SMTP id d9443c01a7336-2df69de978fmr13493295ad.45.1790144955081;
        Tue, 22 Sep 2026 23:29:15 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:14 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	ryan.roberts@arm.com
Subject: [PATCH v9 06/10] mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Wed, 23 Sep 2026 14:28:28 +0800
Message-Id: <20260923062832.479455-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 654AA1C0006
X-Stat-Signature: 868eas3rdc3tyur13eg4d9ys71pbxj4x
X-HE-Tag: 1790144956-926993
X-HE-Meta: U2FsdGVkX19FQtoMed2qdzC++SDCnL2AAgmSgECEV3yL9UzeZugh+NyGMPg/RVgPIuUYwTZhDiT08/eIQgdWb/PuVRT5ZBFahZXTJbiCdKE0HeLB5Emk3n+p/VnPFL14uNMQLoIBeOKqSzBrLV38yZilyu1a7hwEkUTMJhnRj5CuaEtPyFb8AIcAeO0D1+luuzUdGVeUw3zGJmf/t2slDc5KKZ7elZ29+z75HkM1Yuq4Knz1lQyZe8GZxV2XFpMRqm/02QxUfNt2O/wIxb54EMAFXeoebIGKhsdN39raUjN+0OSyYzEUTEkLdRDVkVG2Fxhd7WvFkGgrij9GNED2qCN3OIh6+q5P80eZlllCF1P8yT2hXbtxQ8fgfiRGI+6+dhtSSCzFneoHWpICa0DQUUhjJXusBnXaiId6ZUI2/MbRmmv3zuoXMrljtSOFNnrxXKGgsT008hQ9/76OtOfMXchzJpBPjVmLZPHsPmyIXFlZEIiY6qBCM4mNvVea4iLKzkjsHwhhTrDKEyn1NiQhOUGBIzTR+xMIHcJzrjEqk1MjLq34XQjPpjAFTGc2h5e3f2Dh4/NiOrsbMTUWSxNnxBKmERQNVsVC5sOgMlC3cc0k9IxoMX9D2Pq7eLQj0bCimeA5P/BDADcvHg4unMwma5MiKD8pAqwk4dGF+/yEv3ONEhEzOJqYFiNkfnHHgvGHaQm2xucdtmOFHV9bvDx3CD1pTIB3NbjdRhNrYEa4gK/aUmIXuoGcIyAqdc5NGoyu1kfDQuOUOAF7MsvZvMi+JG+7gGnbk0mVCpAfvS2BytKssG0khtJUmiofGIQR1vcpRtPKsmwZ2Glt2y4Sur7jb5HC+Yos2ENYF6BEkNuunCYRh47s3lvHAiNE9raasELXJF9u4NIfB97DG890WgrsyVT3JT754iQtHiCQglhWfUoB4vZ4WT0Ko2pkFCq6lTDYt/yCh3hBWgRRZXCR1Pm
 6+y0I08Y
 ntdWHYq7Z3pzX79fGRcFFhSi4OOoKOBLmlN7edDw/wbZ7yy3dIqcGtVmKXGEaVf1kV989jKN7qqofpPdWOo6wI1ra61M/7AuaqSHDDO3zcspTfCZKFzs4FV34bK6t4QlnrowfRG+CSj8sCKxBpKMSJ/OpU/S8FqqEwbp1bp5MBHUaqu0CJfTgAYY+1LYgxwO6e10NI477Cl6UqFLlWwqPWQqtC7gFFu9NoRLVRfsxwEvehs95EwWMXXGyzwML+rm5VdnkH9OTe8wDv6GS1j/I1YtrAg+QbvIxa+IdTFxLgAm6XTZvnppFix3i4cRKaOY6bCNuj/kW76U0P9Vw4PJiEqHdGQKudpwjHdO/Zg1rgsL1Dl4qSZMiEa8/tjx/IXBl29SrBlKmIhNw2+oTouGLE8e9RfHR7KlJoNuvmz8eMYK9PgQNPZDNdNexHBLa338q1hnsHj1qgkIpq8mERBI/kQpGTxY9dMIyREEEq8GWlK2a0fTLDG37YDR+NxfxKDIm9Ghl2KwaVplkGtTckqMvyEBrpFUeqFMb7exBfRV2iVawleusbqBxcji7nN7JAysrkH5g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fb757d95bde25..d475e52110e4a 100644
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
+		pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
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
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


