Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99444F4BB9E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068F06B00A8; Wed, 25 Feb 2026 06:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38776B00A9; Wed, 25 Feb 2026 06:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58476B00AB; Wed, 25 Feb 2026 06:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D41916B00A8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:04:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67CD88BFC6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:56 +0000 (UTC)
X-FDA: 84482696592.13.5021C39
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9BA9A40003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f1W43m2p;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J868TVnPJgR7LCa7+/bcaLOytmiRzF7462XYcNyDyzw=;
	b=S0asjtXk3vt2sN+Wmhp4BkNfCIfiArkjRGQgsHzH5/PrhXecbR+d0iSVmfXFhyiOmNMAkD
	To/rjKuXS1EGXswB/ZS2hSfWz/khzc3mKAptEK88IIitkHTEDUb2qCaqRvCi169D+B621o
	WOcMf5dq6vdGkLC9Y3ONhvEJqhfkfRE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f1W43m2p;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017494; a=rsa-sha256;
	cv=none;
	b=YuPr/P4sybQcTMw69/5BVS5QojgUxnvqFiNOIPpS0y3XlFhjEk9dp+WNj+dK90FPBZb+QM
	As7ffCTBtITPTr2GmklhW0leD3nqPReJTRJ4TKGZMQLWlWzYk429B0EuDzNVqILoro3VR5
	qb3VOPiTXeJprgKNTE6r0CvU/hV44us=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ada721eda1so7936625ad.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017493; x=1772622293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J868TVnPJgR7LCa7+/bcaLOytmiRzF7462XYcNyDyzw=;
        b=f1W43m2pDbeucyfVsObSXmtC62AIefwkv3VouDnVKgOE+9evw8ifPxQMjZijVoQvse
         BJprrndDzQi5nbCBNZVhX+OJkS5ZADmexg03MDz/DOPWkhS4iRssBqxa0cJPuTbGQgn6
         aAmDJbxZYa4IrnmqeACB/Q7gFIBI8TSwG+o6SDO6JyD75Gtxt8tKsjZEI0LHwofvkq/U
         Vz4BQcAwIUb/FGhUXees4ylTYBa+HCjNEoHE0wF+O+acf1Xdg4kpxpD1WRLdlq/eUa3M
         eXyqdSN/wr0lXJ41zN7hgCHUMdG8MfWuhbkfUmZfrNTC9ZqD2jTKRiAUizMTV0MHkE6o
         QKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017493; x=1772622293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J868TVnPJgR7LCa7+/bcaLOytmiRzF7462XYcNyDyzw=;
        b=hqASa9lner7OgkTTdvKftYJz9UY8aLijtN24YFk9WIf6fBluf1+eJ4GLjsqnTVkvYW
         Nh6a7IvKQOXKNlF1S0np0Ipw1vp588Ow98vZCG4hqt3p7anPw/LPZD6ehhHKVzXgPpc4
         FwuAiQqpqN5sOVs5RyAqGaJePfH5TwRft6f/um/rpRrCgPx5yKnEK/szP0rMhfnj43Bk
         jtToFohFQNBYD+Pj4upSqlB3ChOYI0yB8bbnLWSi4e5kaxqzzGTbPK+9LkN2vWp7ur0J
         F9NEm6TC6n47C+4eD/XjCQw2WeKkdUAiFJ/ov6w8ddCZm+g2mmn87n8ILTQw7+sU1/Ga
         hFXw==
X-Gm-Message-State: AOJu0YxsQy7WfbwabK9E8tjmZGXyme16RQ9HgBj7G7Afkj+SNV5k8q4w
	Qg4OohzYMMy3GyH3V/3Ddu5wbAscgQI/Z/rYyHFD4cpgOyhQTNGX2zDs
X-Gm-Gg: ATEYQzzxxJwdzG5iRh2W18C/AtKTsyXirWazkH9Mw388creLUOL+PBcblxllcbjXKbp
	xrDRWRBx4iI4278GDEDRX9iwt4YbuAaigxQGRYRou2QIbg6o3uxTydWxB2FDIvbNMzynnlxEaT/
	KUjJy5m6Xp5cCF7cYz9xA8JXYB75Q6q+icJGf1/q4HQBnHwDS3ygnnoduqfY1PQF0ck/eroCZpu
	KQAfmC0tuycD7v2JnwUEsYSp7ngiRQK1sGsQ5cde8hVgafvcWh0FsOXeJIUhEgHXELG2cgWQ8EF
	le5ghN1VnhdP/mEh+FFl+WbtnANYOdzLRDavLHH28GdTHoUfdeInDOmDNsO9B0G8CDaXIj53NIP
	V5/S9CXoKbsGRv9gtihU8AW5Nz5IvqlY5MRZsmeVnmrw82MvIe5QyqoDd7i9Q7SUhuUmSGTlTn8
	ztCFDqQaV+pXEKC1HtQt8meLezvJGTSaU=
X-Received: by 2002:a17:902:cecc:b0:2a0:c58b:ed6 with SMTP id d9443c01a7336-2add1382e8amr25909715ad.29.1772017493421;
        Wed, 25 Feb 2026 03:04:53 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:04:52 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Pavithra Prakash <pavrampu@linux.vnet.ibm.com>
Subject: [RFC v1 02/10] powerpc: book3s64: Fix unmap race with PMD THP migration entry
Date: Wed, 25 Feb 2026 16:34:23 +0530
Message-ID: <6a1d3d5992307e181082b35ba238d7e09acc77a6.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BA9A40003
X-Rspamd-Server: rspam02
X-Stat-Signature: ya9jqopz6mfn7ctessdzzb396ugotos4
X-HE-Tag: 1772017494-89552
X-HE-Meta: U2FsdGVkX1+8IHqoEI8Rm1ZBWafJkAcnAxjBEKVZkjwHInQTK4Hl4SAhX/PLHMNfToe7iyotSnjslZPW3CvRuw7umCjCIOauSAVVdx84sEoRnD/igwf4Y2HwKmSDU/N+6HLurl4Ilt22o+fsN/bTwCwmngpBeMKk8KUYBP+0x0sEur6l/lqXEgggElgLiirHzf97njvQ2JiBY0bm7eZ5gw07W/yMNbFAcLvMrRka88F2aOD+mpiB+KEAAp0SlrJzKi5bPgW4cksKouPTSJryuFdKztYLLBHay2juE6UrZSm6u04+oBpyxZoZ5J1qmIDpWX6MtHMQARG1x9xq6ERNb4TpMoazhLXaeNSZaDLgEJYUb3+wrj54JDp0pvhK6q68/GuJ8uH0780023aksBHfjbxfmnPmCEuitapSB5fVJYBzvKzsOPmwrIYCkzfq8eowM2dwmf/p+W6ow5K/UpXor9hZ9AEkHbf6hTv6iwBVQsNEdG1MtavOJVUlIGB1YwaoyU4vB09crEXqfz0L4cZblNkDnJg1R1oCv8ahvE6jxMD337vyutGzvoocb9tQ4ZEhZ7bbTB7Vc/2ml6exuXmwpVjRaTYyJ5M4KPqrxiYux0HZyfdmFAZmnOLUiCwv8S4m9c1/T0s8ENXhI/6h/YsB29oEz5eHUvImuwhbc1rjBigbrx8KaDtg64bsiSh2HK+vKq3fzI7svTxvQXF/eEMQwCv6asRGrEf6K9T9R+7Ge633yex78FWftEtoyPEEtEh4nNAYEqPz+aPrVLbE+L3n8f5uvjK2SsrI76LZFJnt5IQ7zNYmJvfBX9HLibb4BYYbfhifoUmDZr+vRXi7IYx0B/WW2afL3HBTCwxFMycikOOIJxOr+Sk0oYRLW6Qnitf6WcHq0BNTxUzfY2RTsKt3ShlRB40lrvOlFsShcW5cckDzh1/exJNzLWKojGE7tSqRquJ7eBft5buWvbjspwP
 iv1v4raF
 Uq5QHUSlz72JHjtKcstah5bY9GA21H39xVRp6iTmQgMo/54YrHFbHF6E+MWBglwU5IK0/toe0lpgVkeOVZuVmctfzXjeNnP62mBNtEP4FMTQeD0kAHucnvVzbu/d6tRb/jjhIOK1D5okJaxCh9gU1OR3aqXa///l1aUCgJQQfBpNO3zH5ovoGflku9pyKhBHIaqp1m2xE5Oo+K5c5Y0M/TQNgTwGrDPvsBYamzIUWQsBP34XpcqNs4Uyf1vL11eo7ShC5qguO7brDCwue2mqCVZL2cdEsdrOiu7sUfj0MPRJjTtxI0bAgnj6odVsR5sNnzVEdwe2wllaPEPdqSFLd9yb7ZRYrJjydvIkdC+knl2HdR1UujywAoUTKzMuD5QbFyOeA0T2xmYPsX3jUxqTiuV0ljiKEjdFXQySgOzMJw7jnIxQMSVCPveFXNhosHDuiFAWOzC4gPO+zagLeyln7VthY1NcZjOzsWmPkjUVkqDQFmVAclbvhhVaB2jFfB0Kvp6LzOqXMLGaCNY1tC1D+VZ5Bg8eyPLxyqEMx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following race is possible with migration swap entries or
device-private THP entries. e.g. when move_pages is called on a PMD THP
page, then there maybe an intermediate state, where PMD entry acts as
a migration swap entry (pmd_present() is true). Then if an munmap
happens at the same time, then this VM_BUG_ON() can happen in
pmdp_huge_get_and_clear_full().

This patch fixes that.

Thread A: move_pages() syscall
  add_folio_for_migration()
    mmap_read_lock(mm)
    folio_isolate_lru(folio)
    mmap_read_unlock(mm)

  do_move_pages_to_node()
    migrate_pages()
      try_to_migrate_one()
        spin_lock(ptl)
        set_pmd_migration_entry()
          pmdp_invalidate()     # PMD: _PAGE_INVALID | _PAGE_PTE | pfn
          set_pmd_at()          # PMD: migration swap entry (pmd_present=0)
        spin_unlock(ptl)
        [page copy phase]       # <--- RACE WINDOW -->

Thread B: munmap()
  mmap_write_downgrade(mm)
  unmap_vmas() -> zap_pmd_range()
    zap_huge_pmd()
      __pmd_trans_huge_lock()
        pmd_is_huge():          # !pmd_present && !pmd_none -> TRUE (swap entry)
        pmd_lock() -> 		# spin_lock(ptl), waits for Thread A to release ptl
      pmdp_huge_get_and_clear_full()
        VM_BUG_ON(!pmd_present(*pmdp))  # HITS!

[  287.738700][ T1867] ------------[ cut here ]------------
[  287.743843][ T1867] kernel BUG at arch/powerpc/mm/book3s64/pgtable.c:187!
cpu 0x0: Vector: 700 (Program Check) at [c00000044037f4f0]
    pc: c000000000094ca4: pmdp_huge_get_and_clear_full+0x6c/0x23c
    lr: c000000000645dec: zap_huge_pmd+0xb0/0x868
    sp: c00000044037f790
   msr: 800000000282b033
  current = 0xc0000004032c1a00
  paca    = 0xc000000004fe0000   irqmask: 0x03   irq_happened: 0x09
    pid   = 1867, comm = a.out
kernel BUG at :187!
Linux version 6.19.0-12136-g14360d4f917c-dirty (powerpc64le-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #27 SMP PREEMPT Sun Feb 22 10:38:56 IST 2026
enter ? for help
[link register   ] c000000000645dec zap_huge_pmd+0xb0/0x868
[c00000044037f790] c00000044037f7d0 (unreliable)
[c00000044037f7d0] c000000000645dcc zap_huge_pmd+0x90/0x868
[c00000044037f840] c0000000005724cc unmap_page_range+0x176c/0x1f40
[c00000044037fa00] c000000000572ea0 unmap_vmas+0xb0/0x1d8
[c00000044037fa90] c0000000005af254 unmap_region+0xb4/0x128
[c00000044037fb50] c0000000005af400 vms_complete_munmap_vmas+0x138/0x310
[c00000044037fbe0] c0000000005b0f1c do_vmi_align_munmap+0x1ec/0x238
[c00000044037fd30] c0000000005b3688 __vm_munmap+0x170/0x1f8
[c00000044037fdf0] c000000000587f74 sys_munmap+0x2c/0x40
[c00000044037fe10] c000000000032668 system_call_exception+0x128/0x350
[c00000044037fe50] c00000000000d05c system_call_vectored_common+0x15c/0x2ec
---- Exception: 3000 (System Call Vectored) at 0000000010064a2c
SP (7fff9b1ee9c0) is in userspace
0:mon> zh

Fixes: 75358ea359e7c ("powerpc/mm/book3s64: Fix MADV_DONTNEED and parallel page fault race")
Reported-by: Pavithra Prakash <pavrampu@linux.vnet.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/pgtable.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 4b09c04654a8..359092001670 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -210,8 +210,23 @@ pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
 {
 	pmd_t pmd;
 	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp)) ||
-		   !pmd_present(*pmdp));
+	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp)));
+
+	if (!pmd_present(*pmdp)) {
+		/*
+		 * Non-present PMDs can be migration entries or device-private
+		 * THP entries. Since these are non-present, so there is no TLB
+		 * backing. This happens when the address space is being
+		 * unmapped zap_huge_pmd(), and we encounter non-present pmds.
+		 * So it is safe to just clear the PMDs here. zap_huge_pmd(),
+		 * will take care of withdraw of the deposited table.
+		 */
+		pmd = pmdp_get(pmdp);
+		pmd_clear(pmdp);
+		page_table_check_pmd_clear(vma->vm_mm, addr, pmd);
+		return pmd;
+	}
+
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, addr, pmdp);
 	/*
 	 * if it not a fullmm flush, then we can possibly end up converting
--
2.53.0


