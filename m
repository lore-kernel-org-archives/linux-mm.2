Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27AD606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=imbLV0zb
Received: by kanga.kvack.org (Postfix)
	id 68CA36B05B3; Fri, 30 Oct 2026 04:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635BA6B05B4; Fri, 30 Oct 2026 04:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B526B05B5; Fri, 30 Oct 2026 04:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE2A6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:38:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1B0FC0625
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:23 +0000 (UTC)
X-FDA: 85378640886.20.4104FF2
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E12580002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=imbLV0zb;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793349501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB+bZxSYAyiQD1sxDhADYYDlxsNLMIf5jThUADM0poI=;
	b=G5cwvtz56oEZGrS/iLYMvlOCJKdbE/ooAZc+YEAOmm/pF7F/k1LTNUh8F+WD28ZpgN+itU
	9FkOM6itBEZjJ710fzP8v8zqvUj0FZSe/Hh0PkJLMv3cjEfz7maigwUgh+tBAFQmEHSmi6
	YSmssxFyN9Op8ErbulA0bJJgnVFrzFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793349501;
	b=CeUdh1J+FYW6/Q2v/kM0larv4diRycAO9/BYExgtIFHf6ZP7QszIKaDGsH5gdqhw8u2YCo
	ER/fiOxCoqWA1yVFkKYAIearbKPb0xr4BHCgOf/o0BFgLMdyETILZPT9Ez2tFzRWCzfR3g
	t9ETqdZ8ZnSJ5vJgJKpH9IaJ2xxLWU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=imbLV0zb;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso168311a12.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793349500; x=1793954300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CB+bZxSYAyiQD1sxDhADYYDlxsNLMIf5jThUADM0poI=;
        b=imbLV0zbzgblmhyYNjbTD3rqjxuNBBHXi1ENegPB7jLI58Qql7E6g/ehgTCpIC/ZVH
         AEmBgR1K2yHoIcEujhcu8HeJMdlMsTkD+Sbwg+WCUZHz9u9rfHrY+JL8zR9SVoDZWteF
         AYihf1JIbOAxpymH0TGw3iV2gnaX9wCOhvF5R8NtGhhhYdVLnHGnHUeqyv7uuw/0XnaJ
         idlotny16nXHSct0x2lJYA9BzFQgXS/TLQ0I1oNOUlJZyrv0pLjrXaXpRb+0u9HO4JeL
         VTCeSiio5R77t/NeBbuIU0Z9sZGMtf/pGqTtgk6z3YjJWshUCDKzu1sCv2bAA6g80/7y
         cAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349500; x=1793954300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CB+bZxSYAyiQD1sxDhADYYDlxsNLMIf5jThUADM0poI=;
        b=bwPYdqQW8FjWSYv56ZnSdt2OdDYK6/2sdYOWOLDMjmjXU8a8DDotjO9Qybn/vVT6yg
         7lpWM8mkLK5KVRC828IqeKBDKAvXG/834+ESgp6zuuJ1FsYSAQHADO0prPuduX32/XmH
         yO6NJCy9fqNFKEKnjNyBzCo6Rv5ZkWhjsxcPmYWFT2spNIwLpsIFv6zMXhwbti3WMEbh
         hSDARwJo0opGpByCPWCkn0ktkTgIW3gKAB4uFEW6qOTyHbDO/HxbxiJs5VcvkACZ2B66
         CuAmDTO8BSFTdUO6Av7kS5Y/ObGDUVNj55b62GPkJf9x8u0jjgPGRBRV/qvwmSPElYAn
         4wWg==
X-Forwarded-Encrypted: i=1; AKwUvBwFhvPxNrOeBKDUlbZFK58dpszu3piKJxbsnj5N0Dn4BiEEj03ET8f6m7WmooAhBnxoafagDTIWag==@kvack.org
X-Gm-Message-State: AFq9FYI2npSDQUVQpOVwH+Zh5KiP53VMmlC2sW2+4QJNAaukNWlwop2v
	1JhmUnPxVn9rlHkFnTQA1t5UkLdz4Xv7oXx+WxYmZXojSMFycJQvB8gXzHT1HE8+L0o=
X-Gm-Gg: AYBFou2/aKWYoVn2sH4mx8PGQbMHA8z2h98ZcNRW0sUtIj2+9RmklK2Q/4xv82D8sAG
	qFwUUIjfEyk4anWoCG3T8ua3fd7L/hmrga5oxxfdG5e4zVmHKOmLhSPZlZj7OrKyHY9bjUmJQpA
	H+vmyu5sT6ZInIgxzeNAx89gEH8FVz3oXaBIyE2R8PMrroRXyKaNle8ejS5bkQvthRwe3NVqSd+
	sSe6cOrzUennFS66g9ZQ0hDCXCGZm+nb18AEjGfsx+JMmxCk0dG4Ay4SbP/yHNZJIb/mjs3qvJI
	PDwcGJ8g8ZWEIL+IYjctt7jN4w6QUJKsYK2q+zCCu0RYa7LirnPMKRuvdXVoQey8tmKrUSa47K6
	DJ37aGqWzMZd5ZqexL3zJDjzpmw3DTTmcYuWaXDRy+LIgoViW/5F1XH54eDbSXVcgQJ4fWjBwRE
	045W9vtGfUhY+wjli7YTZWeaczRL8v8vUyRRlGSsuqwM4iv64TdXSCut7NrXuVJ+kjK7UAJeVQh
	QQsOIQOZnukOyPD9bB3bCQoAFsr0w6OuOJPBO3bXOYEnj36TgbQItck3OHqIc8rxNDlFzkxjod4
	1mznPD8oGbKBwHWWePNphyQ0LVDqLdCijP2Ez8K8tYGT73Qvxf9Y
X-Received: by 2002:a17:90b:1d05:b0:3ac:b08a:ed2c with SMTP id 98e67ed59e1d1-3ae898166a4mr1176591a91.40.1793349498929;
        Fri, 30 Oct 2026 01:38:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm7542122a91.15.2026.10.30.01.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:38:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Alistair Popple <apopple@nvidia.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 1/2] mm: remove pagetable_dtor_free()
Date: Fri, 30 Oct 2026 16:37:59 +0800
Message-ID: <20261030083800.599152-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030083800.599152-1-songmuchun@bytedance.com>
References: <20261030083800.599152-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E12580002
X-Stat-Signature: scapuw1x9mz6mzbpizf9imnqougsjwxm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793349501-957965
X-HE-Meta: U2FsdGVkX19L8NrnDeU36NS5WiTrWneaKZZwQFgQyrPZPXs+OHWYYPRlXzIkuVDlGbOY5h2oj8PdVDasvzGPAKaflx4NTDZvdJu4CTTeJdXAhP26h6WKUuTQdGCyoIZhLLWy/eyCi7m2/qkg+ye1zXh3JCrTcWBj/D2RU+DWq+6n54tYM+ZAQqEeZD06PvQWHvp4WtONRPk+9jaLwZQ4lyiLkaPUdAfsodACwDUczOSfmGcVC6tdDjIuMkyVaK1NmX34rLkf4DEIQcqkZqii+7Qb88PIaYmSgE4d9Szjwqz8yp07MjmGsd6IrJDovf50DtorSeFo/nkXlYDgWLsIm4hIYTL18Gr8Gm4Q5x22iTIqz40gYAlf6M7nP89rZ7zICkBYmw8SAgnxsUMo5/AQMiLaRXNeRh08qA7UqKv1j+ch1SjPTSivL0FJrifUeXpeYYP4sZ5KBWU0yD0hpLFge1xG/+JA/YVF49HXiMvKQODDdLP5T34zN0tt1DAUvD2LZFf3fxlQNMiIFIvEzCM19Jidyv0i/UTP8eocebVuu93Ed2Y8AP7IrWYhvd9jBe2NASbKOIh0pCePvlsKQLyHXPJn43ymgEyd7uZruFuSgbqJnON2NVHRL2FxSVvm7gQWDVHgodBQOcwjNfsgJ9fZ6UNvgoDhiiVGcBVz/hZGkkGjt0IkH+U/vC4XEn5aTBLlGiQ5xtjt6jraZ4wRxVE1+SXEFM+0w72DKbe48O3tScv0zrfPZauo8E0DZ4EWd+Dl1JtMnxBKw9iXFlnQT5JEi3lx9o7PC6uLT5dKZF+XOQGDdsXLCed3yygFHS/YDueRHryqIHXtdJtc3YWHAN74n/xjjYT4iANFAXyIqyNp0N8YP4LOfNhLiXTyAUJvO15V1z66yaC7Qxn4y0go+6PtIaLyksjR2UW5IfF+RSuSHwefh8+6U4G639P5z83OIG3RnuZi/lB+H/whepQEaHn
 1Cx0/OMw
 jcHW8KKe4znfrrpu0wh/F7RWp+8up3G/tzrt2cV+/fzMsIg8RrRW+CazOsxOBrZiw15H/XvNNpbtdrJBt268vRfTDg0l4HZJeg27642vLO7zerDhEBvISmZu3jbaUIC7jLddvhTgPobW+NnJTO1A9Wprnq534PcyMOhzqSd+QzIhKKM4/yyjcE7jTGYFOWXVvYBXoxC7ceVO07Gr6C1aeUTF28auaT4uOnjk1PmgN0FbT+Dt1AAlfZTv/MFgxHwKQ6ie1tUtB8OfVR8bn+hF60vU+hNOJsBb236YOjx8VO28lji9GzceBs24ZRzWrD37dV1EVfc/qdbn6UKNo0S1W9ScnInSSfv+YyYqC/N/aVk8wYUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pagetable_free() now runs pagetable_dtor() for pages that have gone
through a page-table constructor, so pagetable_dtor_free() no longer
provides distinct behavior.

Use pagetable_free() directly at the remaining call sites and remove
the redundant helper. This keeps the decision to run the destructor in
the common free path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/m68k/include/asm/mcf_pgalloc.h |  4 ++--
 arch/m68k/mm/motorola.c             |  2 +-
 arch/s390/mm/pgalloc.c              |  4 ++--
 arch/sh/mm/pgtable.c                |  2 +-
 arch/x86/mm/pat/set_memory.c        | 10 +---------
 arch/x86/mm/pgtable.c               |  4 ++--
 include/asm-generic/pgalloc.h       | 12 ++++++------
 include/asm-generic/tlb.h           |  2 +-
 include/linux/mm.h                  |  6 ------
 9 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
index b53ff0950db2..27c3b91ac0b8 100644
--- a/arch/m68k/include/asm/mcf_pgalloc.h
+++ b/arch/m68k/include/asm/mcf_pgalloc.h
@@ -7,7 +7,7 @@
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pte));
+	pagetable_free(virt_to_ptdesc(pte));
 }
 
 extern const char bad_pmd_string[];
@@ -74,7 +74,7 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pgtable)
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pgd));
+	pagetable_free(virt_to_ptdesc(pgd));
 }
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index f3efa0d13963..d4ad3ccb13b6 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -237,7 +237,7 @@ int free_pointer_table(void *table, int type)
 		spin_unlock_bh(&ptable_lock);
 
 		mmu_page_dtor((void *)pt_addr);
-		pagetable_dtor_free(virt_to_ptdesc((void *)pt_addr));
+		pagetable_free(virt_to_ptdesc((void *)pt_addr));
 		return 1;
 	} else if (ptable_list[type].next != dp) {
 		/*
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 4b160eedc5a0..1b7061498adc 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -125,7 +125,7 @@ void page_table_free(struct mm_struct *mm, unsigned long *table)
 
 	if (pagetable_is_reserved(ptdesc))
 		return free_reserved_ptdesc(ptdesc);
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -133,7 +133,7 @@ static void pte_free_now(struct rcu_head *head)
 {
 	struct ptdesc *ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
diff --git a/arch/sh/mm/pgtable.c b/arch/sh/mm/pgtable.c
index f6184b86b89c..810730795358 100644
--- a/arch/sh/mm/pgtable.c
+++ b/arch/sh/mm/pgtable.c
@@ -64,7 +64,7 @@ static void __tlb_remove_table_slab(void *table)
 
 static void __tlb_remove_table_pgtable(void *table)
 {
-	pagetable_dtor_free(table);
+	pagetable_free(table);
 }
 
 void __tlb_remove_table(void *table)
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b1d5c5a0ffb4..98c0a0d29769 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -441,15 +441,7 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		/*
-		 * Only early alloc'd direct map should not be flagged PG_table
-		 * here and those shouldn't be collapsed. However be abundantly
-		 * cautious and handle the !PG_table case too.
-		 */
-		if (PageTable((ptdesc_page(ptdesc))))
-			pagetable_dtor_free(ptdesc);
-		else
-			pagetable_free(ptdesc);
+		pagetable_free(ptdesc);
 	}
 }
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..81b3bb9a197a 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -732,7 +732,7 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd[i])) {
 			pt = page_ptdesc(pmd_page(pmd[i]));
-			pagetable_dtor_free(pt);
+			pagetable_free(pt);
 		}
 	}
 
@@ -759,7 +759,7 @@ int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	pagetable_dtor_free(pt);
+	pagetable_free(pt);
 
 	return 1;
 }
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 051aa1331051..0ba651c1336d 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -54,7 +54,7 @@ static inline pte_t *pte_alloc_one_kernel_noprof(struct mm_struct *mm)
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pte));
+	pagetable_free(virt_to_ptdesc(pte));
 }
 
 /**
@@ -115,7 +115,7 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
 {
 	struct ptdesc *ptdesc = page_ptdesc(pte_page);
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 
@@ -162,7 +162,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 #endif
 
@@ -213,7 +213,7 @@ static inline void __pud_free(struct mm_struct *mm, pud_t *pud)
 	struct ptdesc *ptdesc = virt_to_ptdesc(pud);
 
 	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PUD_FREE
@@ -261,7 +261,7 @@ static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
 
 	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_P4D_FREE
@@ -300,7 +300,7 @@ static inline void __pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
 
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PGD_FREE
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fbe1114e9a44..b38b262bff5f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -202,7 +202,7 @@ static inline void __tlb_remove_table(void *table)
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index cb993a1d0728..26b1ad5998d9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4083,12 +4083,6 @@ static inline void pagetable_free(struct ptdesc *pt)
 	}
 }
 
-static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
-{
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
 static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-- 
2.54.0


