Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E049EE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1596B0005; Mon,  9 Feb 2026 23:35:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E9A6B0088; Mon,  9 Feb 2026 23:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663AC6B0089; Mon,  9 Feb 2026 23:35:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 531EF6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:35:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 047391C130
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:35:27 +0000 (UTC)
X-FDA: 84427283136.04.06BF7E4
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4398DA0003
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:35:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgnZAO8N;
	spf=pass (imf15.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zk5udZmeLlvColjrGc71yG3tENWgemEd1spLI7Qf+eQ=;
	b=Uv9R2dqnI4IT3DCW7vF8S7ML7XC/1Rs2mKS4+2/DOwDqmIfyhv+hAgo1LGWRnX8pXdmoOF
	rhoe6NcyVbdo3ErSd/PLT8ZFWyYiEoahuJx1RroW59ZMtdHiS0lggGRTDB3zX3buAKXkZL
	NnSDU8vtLgdYygl93W14Motx164TjK4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgnZAO8N;
	spf=pass (imf15.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770698126; a=rsa-sha256;
	cv=none;
	b=xLODjizUfRssPoypC+BbRng7Nv+zwWL7fQfn1TqEv7xmc4jTWOAMbxDbaOW4Flb6OMGDR3
	5XGyXgAFtD4tWEDNrZyrw3rajsh3E7od95iSkukm92Om/6+pWMzfXnc90VlkdHouwyvThZ
	McrtT6JVNOMa6mOoML+9CwRIJjbnMz0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a9057b2ec3so1746685ad.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 20:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770698125; x=1771302925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zk5udZmeLlvColjrGc71yG3tENWgemEd1spLI7Qf+eQ=;
        b=KgnZAO8NmkSzNioytf74NvzX+MpXiVBcuZF+4lDkGjmaegFzdOLGS07f6EXd0oL5gR
         ivCmjqWyoya024qUm+mNSXaCnj9cRbvAYAMllWrx1trMWt5mLj3zjpSy2oF86403R2wv
         +GCDE1EZ/l6C5vx/y3HSO9sr03V3y0cMnpUxuNgRiKgZ4AGOnw3fnOTQz3po/VTeb5RG
         pU6fOSpd5GZbgnVItZLkcPJJ6Xv7RwoAQoSYCp/lt0Iqkh71OpK0sr1UyJE4IsTg1s0g
         5HPLW6vvjD7/TE7HcuJoi11pZ4y80YF0z2oQoELVYQv+d/ozoCc6Mz3GYXXxFyRVJBpc
         CgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770698125; x=1771302925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zk5udZmeLlvColjrGc71yG3tENWgemEd1spLI7Qf+eQ=;
        b=AjlloD02eImcJWqTzGbwRM7rbq8GhOHiegCsGLIOoVGIv8ABtEsBZzRiTuGRfv3uE/
         DnAfR/sTpv1Wo09p4hi1u8Ibozxr1qam5SW9YpJamw2qvizWVojzAyrf1Xn4CyflK/R8
         1jh/beRz822nG1z8uLSrrBxP6CGqlh1l4xaJ/vHT+n/0/WaSamPPn5cge28heX4Dlbam
         LX3bvD2NynsCpQw1cay6XyRF8wR/ACmsSBRRbWpVyTLqGTr07QN/3NMR446LR7yFcyIr
         CsSOG5544OyFhUIAMAbIWctumn5F/R3DMOtnsW4VXfbKdLmWDRp53S3UA4wi8p8U0eFJ
         GLDg==
X-Forwarded-Encrypted: i=1; AJvYcCX1aPw3DpX4xnVuR5dzgKJ7uzPS78snawJw0fj0XQnC+ek9dyNF01A28hmXAAnJZkJ/6CkBG4pbwQ==@kvack.org
X-Gm-Message-State: AOJu0YyzRRn31rkrQFPBifVeLejg6+1QAOdeAby3VDwZThHC/OJs+o13
	sypGrE9U9Uj1h3f/CCTta+z0XXIXNcBZZrUUCpVC+n0VLevMADbD2TZg
X-Gm-Gg: AZuq6aLQHVQMSuz4uxkduDNRN6y+mymuXzZqBvVWRlsmI7Rm5rxHBgTgaKvoF/IiZm+
	d6u6vGIo5CtNrBjt8WSL0Aji3UzuxKjr5SLv/24eYhBn/J7D5i3pSkQTaHPUYs1xhtOrJtSLXiI
	9LTuPjJXBK0YSGnbfgwAouxdgaQNVWaQhN5Tx8EmeC4s3m5Y9TWv6Wo7med02kIKLqwmxv7IHMt
	K1MiAT9hlAGrdfUl7Gz2tXyDpD9/dzcW1LSpKu0/V5YCn7QA9Ns1rvbDljeXGiLeyIxeg+5Pqyk
	4QpXAU+GJcW0kpUcvGkCD+jjbOJZipOae0QOeaVnqtQeR1oeBVI0vOPNeuS9x1EbhgEueRttI6r
	iWIe4jDTWzzYAC3j3J3XrQNfP8NwTALwTElOVQxjqVyDLEd7lBYBECbEiLm5nKBCAHbRhjfuvhO
	iFUT3JUUDD12oSNaf0EcF/
X-Received: by 2002:a17:903:32c2:b0:2a8:fc90:c8b7 with SMTP id d9443c01a7336-2a9516299a0mr127392405ad.19.1770698124897;
        Mon, 09 Feb 2026 20:35:24 -0800 (PST)
Received: from localhost ([240e:3a5:3184:2a50:fc86:2a4b:6ee6:4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82457ef1000sm8441957b3a.34.2026.02.09.20.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 20:35:24 -0800 (PST)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
Date: Tue, 10 Feb 2026 12:34:56 +0800
Message-ID: <20260210043456.2137482-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 14oinmb19gxbtis9mnaujotmmrbf5inw
X-Rspamd-Queue-Id: 4398DA0003
X-Rspam-User: 
X-HE-Tag: 1770698126-554846
X-HE-Meta: U2FsdGVkX18w6wk+E2bwyRgXDN51gPget20ItFgxwkvyoWOp6gh4Q18K9zMyLvJX+4vr7ypo3W4qIykvyTPQQhfvvOeXJBau3/iJaXBAj6EvlFcfZUCINy5G3ONgmbXaFgiIu83MhGdVD7ePN5LqWrNMJrhcNoHuy2w6rrCWEve0MoEkaZJemceJdLkYIkGNFmP+AJhQyqNBL6QMULQoTgP5wFf+vFq9yS9oMzewU+saySwIWE59fbaKSWIJEUg5lDSb/ZBCH+VW3Cvazbn1/ZE4lL0WKacuTmHl/Rfx7XbiC93YqJN5NFsVABdLQ3VWHKC8BUILgAZp+K0/1Gbtow84LvFnvvapjRfbhESmzO5Wdru5yuVE83MAYfKjgvfMum0ct4vHVhYehxttUmXZ4waEk8OJEE4LU6C49kB4BuM8xIl7f6lKARQEfStEdUgJxHRU2u9NajG6n8EqCIAzeWOTMh+N6JPiKgZkAN8ev9wgWMxhyGzirN8/10EDoiWOiLsjMs1eexetzfHwpQxBJXoeUGPZmmNZ4ugJiY7nlGlmZ0TxjSZp7rJgXEK3llgr0aIW5AIkBJ4mtwpn4YC5fWRNLx1meFMOqDhSiF60gFgHWK7J0P31KYaCgJAU4BuNeMm8QnG9Hx7JwxZ42lv8hL5F9GbtiN8nMi6wo33fvZN2pEupeHnB+WAj+PfM0pT5dYmSjzGJXut0sclNv4TFu6eYDlQnoAx72tYnNbrLfgeUPjiQoYjBQpOX40TMfpDPeKK++Y3YyljgtU0m8zdC8TGZC3vrP5SbBg/CNa+EqOU+9WM/UM0L1R93xhHq8padLbR6EOmLSy+KeAabEkM6N83+Qgf8v6J5//TR5hp0VrT5hwxe5COwNm76yPl6+twuh0B+FaHeqSDcyGg1/GBrtPvY4VdHJiA1HaSuSPGjGFqKcR5mrAfagTJ3z7VadA2Ta3RhBcn5/d0ZL0olBep
 oTzOIZ5F
 xQc/AOKfUDHlQ/BWfoibp55vbFkQo1HHntgw3GA3G2u0B3olBT8xFW1JXjyWXSZtlXGuf5YU/idcc3fnWjpEBNFEFLgt3NDbiJBOkbgZC+FfNAN+XLyuddrQYxIgDI8nZV/qzfAoOBRt5zd0ykfC1jaGFMeg05x4gPw0DBR/v2l2A1uM91dxehIVF9ITD6efuHXWmOm0EnlIsmZZ+90qD9rP1xREzXUsxjHtn+qbT3DD7673E6RdVYHBURNczlyVSkoctwn+zWZC9ZmcaInSyKSJVRVjpQb60DjzhSNYOc0TMtfUIMSdYoWw8Roq6+Qrjmr+1v58+zjVx7BG3BJkuwa57QI48/yRdr7dwVQf8y3jrviuEIAwRdyO65XQnV8e1aJ+aCqql6mYlJUAZLXkPC7WGx5EAs92RSRLqGW84ruNmlshbMwkE+WkJlCLQzcrvUkbW/Us+7rWn6BWHWRp4ejFxCxpdKe4NyqYKKdLBHPR2aRUq+EdsaCcGb8LzDc2zVp/lbxP/gFbvtxpk8lZBdqIg5+exRalVV/16QR4ZAMB+oBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When do_anonymous_page() creates mappings for huge pages, it currently sets
the access bit for all mapped PTEs (Page Table Entries) by default.

This causes an issue where the Referenced field in /proc/pid/smaps cannot
distinguish whether a page was actually accessed.

So here introduces a new interface, set_anon_ptes(), which only sets the
access bit for the PTE corresponding to the faulting address. This allows
accurate tracking of page access status in /proc/pid/smaps before memory
reclaim scan the folios.

During memory reclaim: folio_referenced() checks and clears the access bits
of PTEs, rmap verifies all PTEs under a folio. If any PTE mapped subpage of
folio has access bit set, the folio is retained during reclaim. So only
set the access bit for the faulting PTE in do_anonymous_page() is safe, as
it does not interfere with reclaim decisions.

The patch only supports architectures without custom set_ptes()
implementations (e.g., x86). ARM64 and other architectures are not yet
supported.

Additionally, I have some questions regarding the contiguous page tables
for 64K huge pages on the ARM64 architecture.

'commit 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")'
described as following:

> Since a contpte block only has a single access and dirty bit, the semantic
> here changes slightly; when getting a pte (e.g.  ptep_get()) that is part
> of a contpte mapping, the access and dirty information are pulled from the
> block (so all ptes in the block return the same access/dirty info).

While the ARM64 manual states:

> If hardware updates a translation table entry, and if the Contiguous bit in
> that entry is 1, then the members in a group of contiguous translation table
> entries can have different AF, AP[2], and S2AP[1] values.

Does this mean the 16 PTEs are not necessary to share same AF for ARM?

Currently, for ARM64 huge pages with contiguous page tables enabled, the access
and dirty bits for 64K huge pages are actually folded in software.

However, I haven't found whether these access and dirty bits affect the TLB
coalescing of contiguous page tables. If they do not affect it, I think ARM64
can also set the access bit only for the PTE corresponding to the actual fault
address in do_anonymous_page().

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 include/linux/pgtable.h | 28 ++++++++++++++++++++++++++++
 mm/memory.c             |  2 +-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..e2f3c932d672 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -302,6 +302,34 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #endif
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
 
+#ifndef set_ptes
+static inline void set_anon_ptes(struct mm_struct *mm, unsigned long addr,
+		unsigned long fault_addr, pte_t *ptep, pte_t pte, unsigned int nr)
+{
+	bool young = pte_young(pte);
+
+	page_table_check_ptes_set(mm, ptep, pte, nr);
+
+	for (;;) {
+		if (young && addr == fault_addr)
+			pte = pte_mkyoung(pte);
+		else
+			pte = pte_mkold(pte);
+
+		set_pte(ptep, pte);
+		if (--nr == 0)
+			break;
+
+		addr += PAGE_SIZE;
+		ptep++;
+		pte = pte_next_pfn(pte);
+	}
+}
+#else
+#define set_anon_ptes(mm, addr, fault_addr, ptep, pte, nr) \
+		set_ptes(mm, addr, ptep, pte, nr)
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..65c69c7116a7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5273,7 +5273,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 setpte:
 	if (vmf_orig_pte_uffd_wp(vmf))
 		entry = pte_mkuffd_wp(entry);
-	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
+	set_anon_ptes(vma->vm_mm, addr, vmf->address, vmf->pte, entry, nr_pages);
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
-- 
2.45.0


