Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88782C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586A06B015A; Wed, 29 Jul 2026 10:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DE46B015C; Wed, 29 Jul 2026 10:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F626B015D; Wed, 29 Jul 2026 10:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9E76B015A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 994941206CE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:35 +0000 (UTC)
X-FDA: 85042115550.13.301C1C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1DB8140002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VDX7Guv/";
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URUZhhyk9GJSCPvpDkxOhTJZJrRdQj3QnZX2BRofioY=;
	b=5YzkjJwhxhdOOQ/ACC5+6hc91U3evnH9NZtbY3yeLG/hme2o4s8znNBmrwwPYh2z29hw7D
	XsScbgXVuKYghGlcgL7XLnXCu1B3CtdQ1PuOZyYnF/bbN+d6e5OlEp0EeehldP/sUShIZ6
	EH2CPjp+pMciwAzags18kb3FkxkJRW8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VDX7Guv/";
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336994;
	b=bJ7sXCvnXxvo0v65gULdYrZdP4E5AuDVWxKNKaVShNgaEPqQPLr3n78PpLeIyVotNn7vrR
	gLT/6bpLKsguRcQNKYxujlPQcl3OwI+XS28wmLyV8/PT3x8GCH2RlOkIDC4l5KSj6su7z2
	9jHf81az1kU8BbUf3Bv8uku9ygT5xIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 175B243FAD;
	Wed, 29 Jul 2026 14:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E821F00A3A;
	Wed, 29 Jul 2026 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336993;
	bh=URUZhhyk9GJSCPvpDkxOhTJZJrRdQj3QnZX2BRofioY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDX7Guv/RSc9zTFHdXr/EBRF1MFHptXJSjdg5B0zd/T2N/+vIibUpoOWl+1LCiPBg
	 i3NOrFuyCkDBCnuZuSuaNeNdVpqTUs+cMCf40jway8yW/VNXrfeXKSKRklHLnWwETN
	 n01K906XSS2hQ9o4B5mkr6yeA51LtH/FEOUo/RDH93Crasm0pjeVCdybz9+lMWv+3Q
	 IhQioV/AgZWNI6aza5IDxxMDTXcdag0+jiIYIlWiuN7Wj0lzYuvrmtqkszK3+m05Pz
	 kBhqTMXrzZdCL26S64rFf5R5rOFkBCejRvIrddhGTwHMuzvImr2Acsgv2u3Hc3Kq0A
	 fxg6H6umLDy2w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/22] kho: return virtual address of mem_map from kho_get_mem_map()
Date: Wed, 29 Jul 2026 16:55:49 +0200
Message-ID: <20260729145610.2827231-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E1DB8140002
X-Rspamd-Server: rspam01
X-Stat-Signature: bq7tx34bgdssqm8d3gq1665gfhn5jmjw
X-HE-Tag: 1785336993-445750
X-HE-Meta: U2FsdGVkX1+/Py1zP4PO2nJZwzAwxwAzK8DNjL36PI59IVHnK9u+Y6NAEvkwpctZrtzONRbKxMIWTA71OhNMCNbFfgrYWW2I5l3BloD6RC2wpVBezFI7m8Clm9iAHC+wZelJRiz0X8pQjfdsS1KXY1Xjsp/Omqa6U9uW0QZ6HgxYBkeNqXbFZhW0sX66u4g7VIxQn3x9v+9LwHBuzIBXxd8IoVrBap8Gn8zCv88U+ugwtuMzMIxRsxi+6Nq1zoZY3BbE83TTJU9dl1ujcjQrcR5kBUBDMj8DmSvBzugl5wW9qc4R4VG3rJf4xXsK+MB3pfFY9xJUx9bLM07LTpmPIrHEnaVNMcMq9vz3ylyR8j2lhqjOCEjrD5190q7sC/guNyi/3wNTx3x1HU6GnmwzHqcasTnd/rhXKFMkvaWnn7XQrQWEIEv7Cfc/1nx1Jla4s6pvUMd2rPyDF0hDVtebvt5910EFsP7WpLwNEAzeAZlQXFMkqQF8glnlLZpID++7EyKa7XL3VRDA8MnHr3OalAh3oTVhfO68BBS9ddaasr5dRz1faIJUxMp/rSqTtsT++Lg7Ux3UCmEu359S793JYB2pAaNheJEHp8h4X2SsWkCWNrpTcz1D0NKkzHfa0dM2igjpSHvQJpQaOV4mLB5rPd36MTZ7FcabVwuVn6D1Z6JhjTk2e1/J1sT2o+KeG/WmjosE56HhmukDTyDQDacf6gdRcWPA4xTpX1HwQN4/RalWlnQ+xt7CGq2aw/zj7loj24va6GRGmwwkJ66Ah20nQ5c72YDgrZsUnwIPBhEn7tYcqQq+f//RqsOIxQX2oAUvL11Do902JCUiQlKn/ZfMgVGra1Gal6lsmVVG6hjHFIocX4a/5TMFdmc/LtJaqHTEHAcqFdtOrlZD57vXBa8KTf4+pnAAfUysc8r80c99G1Ck9C1eGGQhSqKFXqLCb7gkqD7s+fAjLBtD3Af+lPm
 EZ/DC3Rs
 2WKzdohjz/YCYhXCSNLs7EVMp6LrRTLFznYBPfrE+5Bj+gcDs5DRYVkEjkCJut/9mWy4v7jYbGQuBjwFTtCgj0kyncyzfb3AAA+7ZqJvt1/cQeEe1MqEb8ZuUiM334bc3EGeph6fw+ebtIUmTDyltROOpsAMb9+fgNdNsiRuVaLq8Hf5xus0JXfCy3JgX3w/loiwBwkCieYA+B9PtJYAx1D2/cP66Mnohx/q13/j6pNHgGrrrMdbJwlq7Aqo0Sv9Nfi6qTRNjPqL5l7FiRsfuTlQgG1+/JHfMwcn6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory map address is returned by
kho_get_mem_map_phys(). It is only used by kho_populate().
kho_populate() doesn't use the actual value. It only cares that the
address exists and is valid.

In coming patches, more callers will be added, all of which will need
the virtual address of the preserved memory map. Since kho_populate()
doesn't care about the actual value and only cares about validity, it
can also use the virtual address returned by kho_get_mem_map(). It only
needs to make sure the returned value is not NULL.

Rename kho_get_mem_map_phys() to kho_get_mem_map() and return the
virtual address of the preserved memory map.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e7451743b87e..5c35c11c273b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -512,19 +512,24 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory map\n");
-		return 0;
+		return NULL;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -1647,9 +1652,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
 	bool populated = false;
+	void *fdt = NULL;
 	int err;
 
 	/* Validate the input FDT */
@@ -1671,8 +1675,13 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	/*
+	 * At this point phys_to_virt() doesn't work properly and so
+	 * kho_get_mem_map() can return a pre-KASLR virtual address. But here we
+	 * only want to make sure the mem_map is valid so the actual value
+	 * doesn't matter as long as it isn't NULL.
+	 */
+	if (!kho_get_mem_map(fdt))
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.55.0.508.g3f0d502094-goog


