Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B9E606A8A1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YHIvjNVU
Received: by kanga.kvack.org (Postfix)
	id 731206B05B3; Tue, 17 Nov 2026 13:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708F26B05B4; Tue, 17 Nov 2026 13:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F5D6B05B5; Tue, 17 Nov 2026 13:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 305276B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:31:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0D51C0562
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:31:55 +0000 (UTC)
X-FDA: 85445454990.16.C3A0C3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C397F4000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:31:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YHIvjNVU;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794940313;
	b=PjWn/VFAGdn7szJMtWdoitNQN5i2q3/Dzp20pB8+OayB7PPqrQh/e4bamyVMBbGTXYF9GM
	Ruf0tt/9wcnzBdBZ+MIQo7mbzgONPT5p69AoQnKZUAh5UcqQfkpbWpEKLZuJMBQ4kq1PEH
	ouLHc0Qs7CGR1z9N2aiGkHa6dlMmXsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794940313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROYhJnwskLbtUSLFDNTgyxYJZVqH7Mi1D1ofZwYsCgE=;
	b=ywS7CoIhCoYeL7EM9PGcmX/MENNO2t5KhzqKS5dTTl+6u7qWoFGGjZxkrS1eKi0xf9O1cH
	XyBtAJiIjADg7uYn/BEfF3UVnOnApOdL0+tgku82s1Tv362XYSwehc5RSiaAnIO2cPACo6
	zBwUDszxAjNaf6YQTq+z/cLsSQIRLjI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YHIvjNVU;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CD3E43714;
	Tue, 17 Nov 2026 18:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863E31F000C8;
	Tue, 17 Nov 2026 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940312;
	bh=ROYhJnwskLbtUSLFDNTgyxYJZVqH7Mi1D1ofZwYsCgE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YHIvjNVU5ROPBZy/6H9B5IyIvqiqgxp90L+jGjs/45bsODcDHwCD29V1FYs4IjhiR
	 TLeChVrR1kvX+6ot8EtR7QKZSCRtStS+sj6qdaXp7gED+xDKYOGSRehn82Ve0aA4Q4
	 c2rerzv6GHHeHbPa1qbFK3g7lCGC/XkAgzS5UiJ92Jh4s1jZAGF/d4mmC+GwMmTXXQ
	 tRSEY09WEHk21sa9r+QD+O/+VzcFkgVWL8edk+ZRxDh5tUsjEkgozcnUrelqeaH+et
	 gTsNL/88JJByMEsgfyavlaKp2gdN8DU3OX6eX1slhcsTbHZS//osSVLamEzPW2fN9u
	 oYQo919LW8/Bw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 17 Nov 2026 18:31:32 +0000
Subject: [PATCH v2 1/4] mm: update walk_to_pmd() to explicitly return an
 error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2403; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vNl3Zl3ZMfO6x8wWrH4TBXRKhY+lxi4UMdolsZxZ5/4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+zO0ytvM4bDzj6fNHtzeuarWYVLv0yJTToU2LfiwNt
 k4VKPna3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJFNgw/A++HRST1Xxz46y7
 0w6GtXOJ7Xj1h7Ppe8HUmun2aZs/S61hZPi6eMVVxvQdvPmGqx4mKDYcqnL+q71tr/DLWVdvPd5
 U480IAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: C397F4000F
X-Rspam-User:
X-Stat-Signature: y6jcqprk67xdnru1pr6fiuqcexq6huat
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794940313-80349
X-HE-Meta: U2FsdGVkX1/9sxeuxsehhyZ3veDwkZk3DJm2WPuQUQuQDFA3Fvo9Nl1tJoPfmiGYZhzVuEKomQpLe9f2nCnH/BCR+1TWGKy8xw0z2ebkKBSkzLbAO34ijNYWYH2qhJtc1EAcu3Zfc0SfU3uFdZKDhqMtMpD5yXoLLC7s+QYxgsO3+VWQjpmU5at35+gQemlpHLu9KlhUpKl3IlJivqPJqC3XI/XYEi7M3enQGM6AIkOpe/aW4dbdIU0nW/7OoKlpaAJTEDdMUwCVibV701DoyrgXakD5VjqjxCxNaBU8L0YLHjEz6KBFH6GtUAavpZv2aepq+w97c/KPXw5TdF5DNh8ti9YDQ5Jb41pZPSxbN/zKUA20dT9A8RL4sZrbL26d+25RCOlrzI0An04kcsdzfqzxobYKTklI8WMxyS85UnsMEEwHCMOZceLMX2Cgn4LC+jB06f6jP+VIN/EPV5Aa4BLDrC8RzeTuOTeRWNvKrSwWA5y99/907gxkgqdbrjaTYbQWYl88OiS3SxwRcXl9wEYzYI183WwCoPd8cpbONbQmnvh5+VZIXooeUM0JcT5BsNfTb6UoHsXLJhGz3x43iSCdcUGFkO0MKBHT+CKN7/W2WMK3Nyz9VnPFbIcKB2OKsPxn+jt1ZTF8LJlzQHjVLG6cuR4Yi3hGTOLw7fygVm5h/mH/k4keZvHU9NGAiW3dXail/9neKMyUoAO3wlHgAgqc+ckEYFKKRrSLCWZNKzzw9oWBL6Gwd0EkpbNDxKNPkmmaI42GM84G3lNthJjIZdhfKFg8OSENQANcBax9s9ilt32N1uCRXYisES4r7yCzWMrmmWaNYLq7mPsA8eJ7Gi63yNcdqaiqLEBYqD9saCTnSz4Da2YmndZKxgTKIgGLxSnn2IzrhrFRbM7bJI2OWvl9zkZzqBfBHWQ6OPUe+52b0jdy/Q88PPAF0IuYXcYych6Fx0ye6EufV8EVc7F
 V1Hj0dZe
 lP4IOxNnO8urIkvaahM1LwjidQxgRuj3Vs5zTh/qTE5j27B99g6DYGYG/KCPs4IVo5CrHa5S3oOFcq3/mjpkwPDHXDkCY/IBhYO3xIYk8gf1rOs3E4GEV1oOPy6yiAD6ZceGNmQTIb9ii8vAqcOT3r3/izBWqylRIKgmmuVTZ2ja+zhCg8d9D2bg06Ve2qjHRsHPW3PMKK+woR9MKQ/Dba/3npuo9Vj0OtVuhM/XzRNnx9zpACzaA8m65hhhvu698UM6rS559z8EXgHTTNcgsDapV+7myb5xRVttiwOWSVloh7zZPg3chgj/X34OYDE4TDfIVcBUNYJvCgP1PVKoSXaWP2itw8GYDXbQAUvaEDAidvuuslQGwAQA/eLwFiHsYSqILwNOhUyw2EkAK76t4iSUiQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rather than callers inferring an error from a NULL pmd return, explicitly
return error codes.

This allows different error codes to be returned for different failure
conditions.

No functional change intended.

This is a prerequisite for the fix to insert_pfn() which follows, as that
needs to be able to tell a failure to allocate a page table apart from a
race with a huge fault, so mark it for stable alongside that fix.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3a20d64fd276..67ee25215ca5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2366,7 +2366,7 @@ void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
-static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
+static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -2376,24 +2376,25 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	pgd = pgd_offset(mm, addr);
 	p4d = p4d_alloc(mm, pgd, addr);
 	if (!p4d)
-		return NULL;
+		return -ENOMEM;
 	pud = pud_alloc(mm, p4d, addr);
 	if (!pud)
-		return NULL;
+		return -ENOMEM;
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
-		return NULL;
+		return -ENOMEM;
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
-	return pmd;
+	*pmdp = pmd;
+	return 0;
 }
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
-	pmd_t *pmd = walk_to_pmd(mm, addr);
+	pmd_t *pmd;
 
-	if (!pmd)
+	if (walk_to_pmd(mm, addr, &pmd))
 		return NULL;
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
@@ -2532,13 +2533,11 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int err = 0;
+	int err;
 more:
-	pmd = walk_to_pmd(mm, addr);
-	if (!pmd) {
-		err = -ENOMEM;
+	err = walk_to_pmd(mm, addr, &pmd);
+	if (err)
 		goto out;
-	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));

-- 
2.56.0


