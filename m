Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E5EC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F2B6B0095; Mon,  3 Aug 2026 12:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3279D6B0098; Mon,  3 Aug 2026 12:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E156B0099; Mon,  3 Aug 2026 12:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAD676B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5890980769
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:31 +0000 (UTC)
X-FDA: 85060531542.11.DFCA704
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5BB0F2000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RCnX9DvB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xaIbUspi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=giVnVJGx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KQ3BcFN2;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZBAh6Nw2Wojw1x1c/oIpX3LymyujgAPhMLX7la+5sM=;
	b=3ARTvt4aB9xolHbGf9z/KVSOazA5N8Jb6RIfji0/BMmoc+MtpAkJtehmBFmt6xuxfWX6F2
	ptHjg93/FFrMvgA9sZtGBj8B2QXtnuQStVT41Kv6aT2XCTRi04bIA0g8cNmYQxu4M//A3z
	b1tbFQedRRUNXXKX4hoQmq9HCrM8C5Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775469;
	b=EGfnh+s3OWp4/n0dtTiOpa5cI+scX/aEaBUU5atsWAhdYz6HRzrLdSKV0zzDdkYlUM3j2p
	KdS4K/V/VLR5B+qpoxyUnr9I9lpTXgL6JbO0+da1o2LoA4c+Y8Q7pL49zM/6SBHDkltSG7
	n0+N4A4KAyPjI6PZ+j1zitQ9Wr5domw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RCnX9DvB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xaIbUspi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=giVnVJGx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KQ3BcFN2;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01E9F3FC3;
	Mon,  3 Aug 2026 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZBAh6Nw2Wojw1x1c/oIpX3LymyujgAPhMLX7la+5sM=;
	b=RCnX9DvBdusp51QYUbBf7leNC2m/jnhcVFM5tmPTP/BhTZ3DqFPAqeh33IRpZN6BmPwqoP
	rzIo4y/i0IiJp8To57XQsHwj+IPT7FV5Ll5C7nv8aEmi07CIq112ysW2y06eVZEf2dH6wJ
	r3lk9k8/HQ6YyaSYXdsLZN6KGB8gFDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZBAh6Nw2Wojw1x1c/oIpX3LymyujgAPhMLX7la+5sM=;
	b=xaIbUspi5o6OZc06hALwJZqRpjo9E6iu/FYAsULDovkl6o6a+EctY/7NZl8UBxV14mSYy3
	LqsBwv3e4TeH+9CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZBAh6Nw2Wojw1x1c/oIpX3LymyujgAPhMLX7la+5sM=;
	b=giVnVJGxPhlzAiTUyO5cLvObJ3wJUrZwgTqO2byoJytTwsPx5geUMg3NE+GQojJgRcLFfW
	nGXGK8yEXMPkiUXaTlVnnCK1/idDeaoYBPP9wfBAGdYiKRQ9MMzDN+N8K1AAGzciOFRYLJ
	eZ2eJWx57aPm670VdUoqq6RZMBZewhk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZBAh6Nw2Wojw1x1c/oIpX3LymyujgAPhMLX7la+5sM=;
	b=KQ3BcFN2qLOwnr8xm81Wv2EiUTXMUvdttWl+K12ejsYXnidRcK53HVXpu4yybbDfE5Irjs
	3RgNNZM+XdnbmZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C744779A1;
	Mon,  3 Aug 2026 16:44:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCzPA2LFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:18 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 6/6] mm: constify the pte_offset_map_ro_nolock() return value
Date: Mon,  3 Aug 2026 17:44:00 +0100
Message-ID: <20260803164400.531199-7-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BB0F2000A
X-Stat-Signature: ww58qhtt9hu3s4fmj59uh1c1tad6m3i8
X-Rspam-User: 
X-HE-Tag: 1785775469-99390
X-HE-Meta: U2FsdGVkX189rxQvlhfeayaYa9PwXso8nlDfCr4Bdxf0A1K/IjoXoZ1zqAYU1oMD7RPjbz7TQCqS98wpiLsmBbpyWvgM/sJFzbLbQoJU1bfTb/pGPTN5YjF0D+QHVAIN2I9XtwaxtUXopqYicBXqIFTRwBmmMaIhZNggiz0IMOp6uRr1QbyTJM2CDBdBPwmpUo6rWzUQd2MI5xPr1lvLRzKSSklk6xW+O10F5eLy6YTJW56eT1Cu6GDMkOwaue6freKzslq9d4MwMo/dDZspPVasSO5mZv3xyqdoqOK8+0rpDpNEtuT+25hXxfxNAnDT67PGoh7pdjo6ySxKfv71IlEfe4v+c6I/OVfkIeThP1r+0s9+1KE81LU65Nccup+XAxF/QvgeDY66DJfP+wzaqWks7HhsGQXlzd+bVIFih9Vjq8gEfmMtqrjHGouTUD8gjB4JrOtO1N75CGCEN+zl1vaTQxX1ojbhx8+Crh6okMziyPLgYdujfp5VtcxdvG8afkI1IVqPjSwdpl+zQ0gdL7O0ROpvZwn9yzT27Ssvb8tbfS0SmQAClXB/GjA1TZVFfb8zGOjLTGTHODThsO+4ue0L+h4S7SrmevLiwFrkQWndbwzl93IjCu/XGIbgg1ncDR2ZAZzWX1PPqppxxhNmLK8eeVo+Un1ABfBplV+ZHv3v3zfv1YLgzBJRfgSrYWRM1cNLW3v8zz48HPsYkQAnXzAOlUkfPGMD0E6+/9BG29lp34QJdSrIV3GXHcPuHIXavgXuFKE5qpn3w/WRGB1G9Xj5fBG7h7kleRVa5fgL1U1klXS/ajn0xpYtEmsoIMlyFS8cG5ipzq3YvFkkOtuz5gKUy7M634Q5zBWIRvSif/N2X4PTKwTxXt+/nHBwKCFb543PheuyYDgxjn566gxhCR9OFw5Uin4vF2ZbyQKV9NGSMjCOk0BhHKh8wJV6wntuiex9/1qAZPg+XMX6eQ8
 E6aMIVbI
 0eiJj35S2PYspy3RJC2/6LCJXvp55+cLQdZGn0qsusHHYXCwdvjKTodWp0ClFLOho4fhz6CIelMwS4gpiBMI1nRfBkMFIaXFfGb00t5iiZM/ZJ4W+AYhQK17lml6KFVv8KepjCTKCvE40K8+n8Ehd4SiqDY/ra55ztzM/T3zHppDNZs5szRY09VpSopNjnFvujGcly7speqHBtxXqNtM5m9yv0CA+XDt4I3aqKkmEDM4SD1il5l4FE3NXVoKMorHcqCOfWtV1E8K5vSGlNBBCAncJFVgckFi65Yc7sO0gfXAZ/1wttZppe1DW/ROEJASJZLLT9RmliZSUe8H8fqcKeJzC0rpWutHKp6N0jrQATr9sXVhPs74l7qlee3qqqk2KuBMdiRyIJlQnpd3ZGr73iY9uUA15W+N06mgxGVOLrxCoys5P41tWR8s/16pol0tDaKvaT6v1lVFBQXSoRxTU1d/rt1XJQpdVpOVkj5crtConNDjtBJrelbAyyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Constify the pte_t * retval from pte_offset_map_ro_nolock(), for which it is
already pledged that accesses must be read-only. With it, convert the three
treewide users to use const pte_t *.

khugepaged passes the result right down to fault code (do_swap_page()). This
leads to a complicated set of conditions that, in order to be correct, must
not install anything into *vmf->pte. This is not trivial to work around in
fault code, and as such just trivially cast to non-const pte_t* in the
meantime.

The other users are far more trivial and the conversion is equally
trivially simple.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/powerpc/mm/pgtable.c | 2 +-
 include/linux/mm.h        | 4 ++--
 include/linux/pgtable.h   | 2 +-
 mm/filemap.c              | 2 +-
 mm/khugepaged.c           | 2 +-
 mm/pgtable-generic.c      | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index a9be337be3e4..e29db41b6043 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -390,7 +390,7 @@ void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	const pte_t *pte;
 	spinlock_t *ptl;
 
 	if (mm == &init_mm)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fabe6c66b4b..acf5a5e31d34 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3885,8 +3885,8 @@ static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp);
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long addr, spinlock_t **ptlp);
+const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				      unsigned long addr, spinlock_t **ptlp);
 pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, pmd_t *pmdvalp,
 				spinlock_t **ptlp);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dc418553e57a..dd51e722c535 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -112,7 +112,7 @@ static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
 {
 	return pte_offset_kernel(pmd, address);
 }
-static inline void pte_unmap(pte_t *pte)
+static inline void pte_unmap(const pte_t *pte)
 {
 	rcu_read_unlock();
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..af5d3fcd1b05 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3490,7 +3490,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
-	pte_t *ptep;
+	const pte_t *ptep;
 
 	/*
 	 * We might have COW'ed a pagecache folio and might now have an mlocked
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..09efac93a8c6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1170,7 +1170,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 			 * Here the ptl is only used to check pte_same() in
 			 * do_swap_page(), so readonly version is enough.
 			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
+			pte = (pte_t *) pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_NO_PTE_TABLE;
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..2cfc6e608ef4 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 	return NULL;
 }
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long addr, spinlock_t **ptlp)
+const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				      unsigned long addr, spinlock_t **ptlp)
 {
 	pmd_t pmdval;
 	pte_t *pte;
-- 
2.55.0


