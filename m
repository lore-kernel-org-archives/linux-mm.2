Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812C4606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=M0alNAce
Received: by kanga.kvack.org (Postfix)
	id 9477A6B05B1; Sat, 14 Nov 2026 06:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F85B6B05B2; Sat, 14 Nov 2026 06:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E87F6B05B3; Sat, 14 Nov 2026 06:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA2E6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:26:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C890140387
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:03 +0000 (UTC)
X-FDA: 85433495406.19.4BF4931
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B369140007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M0alNAce;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794655562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ik3cMVEgluWCZTmAy6XC89hjzBK/NOOgQFoYH5sRUdQ=;
	b=QgMYz5+pT/kH2uVKb+jCt+30hvZZBlmV8SVirL8ozjlRXumLVif4XeVeq9YgrYn6fHl+wP
	qjp1QXFl5/6b5UmtP9d+J9rgRmkAgAuDgbVO/K+eeiI2kKx3JDYdeocxLNmR0FJhisgg/i
	NYVW1uXJtoCr5pnDqTEX5kTS3EWKlDU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M0alNAce;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794655562;
	b=MFVhtWqnOME2tCASb1Aqgp+7DsRIfqQk3nLSfyxXH1553qU+L9sdaW1P/abo58xxNPq+eA
	5ojF1VdxwLc0zFnhlXstQAyt73m9ir9Y4jrIsOtHaWhpOe0IouY49ypppFAyJK4lDjeDMB
	rlJNDnhuuqoXejMJFwaXEotytyZdlhM=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2374374eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794655560; x=1795260360; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ik3cMVEgluWCZTmAy6XC89hjzBK/NOOgQFoYH5sRUdQ=;
        b=M0alNAcezi9eMiQRCMzjiTEnSklGmRBb1Jfo0QcAzOPQM9TxROU9eR6r8IzNCv6dOP
         ChDxbR60MVkHBomfrUzacmT6o8VBCTNDqupuybjDI0SsWdZPBlV0D/Fus9ZMBolf6h0R
         gTb8G+4R9bS0YNd4pTO/TENA3J4qCz+/QCvIhjw4vkNpdbgKh/xskZgvBTYYgL1uB1IM
         Pw7RAKlZNb09ZBo0QFd6iw1pPtFi0yORXJI0cQ7+uIcI1a7U2BJrcTb2GuIqate1htdg
         yJFDt17uWGYrEMWesLnaFou4lWcbor1xgvHpxn4P6n8+AuvMq6qdLU10o9baFXb6j39k
         BgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794655560; x=1795260360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ik3cMVEgluWCZTmAy6XC89hjzBK/NOOgQFoYH5sRUdQ=;
        b=Lo5fEDaRG55EGVRsTJNdSEa1sjAzWlcB6iyDePARz3irqfx9Q8yOu4g6jFma8cTF4O
         oBhULjftn57CwET5cgCnmgrGmgZHnDW7gsI8DShtQPSIVu6lo0f7efA+zo0UFGZMV+N7
         tQLdn9b1X+DPrNbVOzPZW7Bcsjz+2QWrwXSOtZ/8vCvp2zEOviUcXAeZZeaILGC3phgK
         fdCHoZovIDtAuekNqEQdicLNsuvEZDi1lxTyrRnGB7lgBZ/dC+MRy/5bLCbeaDsxb4Yx
         oBJW2ccfh1MTeoL+WTsegvzlu2g+cD5ks+YJlTC0j+ILLifvE2Aj/c5TrlM8JElFpBHz
         1IMw==
X-Forwarded-Encrypted: i=1; AL+hErEPbLVaW8wgzdP+PGE3Je1NdvEebE5kfB6d4fNW4dkUeUr7HRjv3vzNLDg69cGl1APHoEK8vGbtxQ==@kvack.org
X-Gm-Message-State: APuU4Z9Fisno9O4dR9EJinuRIHcupT5E90KjrfGUsCFLITHqQT67zDhU
	nRf7UexkoBxnAQwBjyLerdynE0sldSr5ocuOuE/D6poHCvpASh6c/PWDIzSS7SwzjVY=
X-Gm-Gg: AYBFou0zArzBSNq5IvRXANtJ/J1p38UyYkdbYLxTeaaph9zavxfE9oPPCQwSn+Dacj+
	dZiVvDZukqQnDoP3fT/ZASeHmjCS4h8AZlyp5bSKy+outRyXSU6DdqSS/QMeMcuiSOYeh8Pe67d
	6bdDYfPl8FCrzc2meGx43fcSp6OFayf2IN+wfxO8NjMYdiCpsR8lMp1o9LhXlnmTd763j89b1lI
	UazPikVL27loElhghNoOHNEI77ycm2fO/huSlEZ+yY31lyB6brXHK8dhO3DY6Y1Oix2fYWnoi+W
	y1lqbKKpyYccntzVBJ/G8adDKB37DbQdOqqKnAA3xgT/47ew8Old/L4mwRcsn9k3ekq85isNkCT
	k24OvbfFF8QsORdoH7tJFBKMRrEnQWuPYCagipaN9zQBKzBAtYpoBzP4uEeNcyXv25d+RTe0Yhp
	2j0IlujqJX7EJTRBdnZbOa5NBrO2wrMWJ+G6EZ7lM/xt71kk75sORJZjm/ewu5QqrelQqfsB3iZ
	GtEqFJk58FRFSJCaVqV5jRFMqb4NYYzIcfHRbZmVs9J8bhqLEi2H4MysQ/Kln9C3yr8Qo54+2Di
	QnJ1yLs4x8T1CkJEzopv1Zc9dxrmpAt/tuaBK5wuPm+r+PSgMpxaOdKZWPOD
X-Received: by 2002:a05:7301:713:b0:376:ce6a:a499 with SMTP id 5a478bee46e88-379684ae563mr4808021eec.36.1794655559588;
        Sat, 14 Nov 2026 03:25:59 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316fdsm16190627eec.5.2026.11.14.03.25.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 03:25:59 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 1/3] mm/hugetlb_vmemmap: fix HWPoison state races during optimization
Date: Sat, 14 Nov 2026 19:25:21 +0800
Message-ID: <20261114112523.75208-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114112523.75208-1-songmuchun@bytedance.com>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B369140007
X-Stat-Signature: h1bjjeg9wf3grchr9pjx5wujfy1m3ddz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794655561-587248
X-HE-Meta: U2FsdGVkX1/OUFpae7iTZLEahtJNJKofRRldgwIjjoVDW5354e7EPz/qMJqIIQCEELk6u6Ylv1epRpmxDhkVX/EMF4AB6MZ4V9eWT2jY3OTpzZ10d/qBIEEViHy1+SLvoLjk9Tm14dwVK23cxBt8gRZtkz2m8ou4bx7wjQUFP7GOGcYwyn+OhKLhhTYlC+nJ7HFTqHJqYB44H4OnF+YqjzRqFL5DXKHLI6vTkf7NCWAUCsqE4THSNpvE8pQepv4HSUaqGxBpDj4g0Oy8w+4yfX0Oiu46c9p0Qbr3mjoNBQXMHu/Skx/T5hyHBprfF9BxgPgt8p9jICdLWSfuGTnsRBpWVQwr9PTJP/q6Q5kpcdtUDwDJ5qR+r6U0gXWH8hClKTXPypotXElJLiZk7svBZ2l5g7mRfGYfuLY2utJIPPrM/43jolja4mKYEuRzyOOp7exq90dqothvb0RnMa0YUIPIfExbsvuyY1UwP0s7n6VitYIwguHTcXFWP1/Q32nYhjiRPPzGYWc7rZL7nX0VOSGidytnjHbkd8bSkyzCNphwsI7FiSB+iqo8Xw/8fz15LzMASQceUcGedwSp7fZcFbySR5H54Fo91WkYNY0EUQibNfNGBk+jMuF86w+UrnSSsaf8U4g4/mWaOWnL1nBXZdL50+yWsGHy2UtyPGFu0S6UZ1d7eSWFXxJL5k23zs5GX+uSvxwmSQG/uiT2Yz6D/J9eiNcBEK2lWSz3p3Td8D9FYy9yvWHMNzDXO8gz+3jnK2f9joc5nlAOKNIDWPcZPDtL1/gSlrZkPCX16fcPyDwR12hHgCymsVo8CPEQZVPw72QyaoL2j13EslgyfJOMpTpUct02zt5W6wzhWWYBXizg0aIwbV22t7aY/08KZyefLiCIoyGwu9wZYqr89G3ImQmic/vpZLnepqSOpNoTkGIATa9gv/YY5DBP4HONuyMs9N+CLDZluOe9QfAVPP0
 2qKdU86Q
 tHpJG6axpJdX5PBfCACH79b9O4C71QAxq+aBSSubFw0KQACHAMUhuh11hZ8JTQeVKAMsn7uv7gk6CIJZdCQtHolUSZwaoUIP+uLvzzLCdoZjCeCq1s2d5xEjgP+L08y5FdYbbLliqvl+c+eSskVwt3zjl5100qazEs8aFwJvVCRKDTwTwSik3bONEPZMhtF2y4RH46eoqf44VwQwsxxMCVJXPq3fugwpXbnWME4DqTqXxghTV8FqBF3QwNw8+tvLFsHWYt0+zDDb2vGlqTegvHexmPXNE92y3mCeKvXfsYjoNQFaORZuv6/Pq026aOCysQPuZ2P4F1wtPldQXFG7Gkj6iSnHk6s1oJ+XkFIS492gEy6QSqDoR444kMXt9uGQfetTjHFPPvC0ZN0kZWt2Q1b8HOjxnSKJMqkhOSZ02xf9aIXUiGJb56yKyN0TERjAb3c8YIgZ1Y3dMoD8naw8X6/cddVaFyY7mPPLyraJq3UsUYDRf75gKhbdzeBb59heKT9SApg4nswZMYpES9dli1xvff4UvyEEmcNoCTm3uXAZD3WA5cjgOivGNUcnayeRsN7er
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HVO copies the vmemmap head page before remapping it to a newly allocated
backing page. Memory failure can update the old head page after the copy
but before the remap's TLB invalidation completes:

CPU 0                            CPU 1
init_new_hugetlb_folio()
__hugetlb_vmemmap_optimize_folio()
  vmemmap_optimize_pte()
    copy_page(old_head, new_head)
                                 try_memory_failure_hugetlb()
                                   get_huge_page_for_hwpoison()
                                     hugetlb_update_hwpoison(old_head)
  set_pte_at(..., new_head)
  flush_tlb_all()
free_vmemmap_page_list(old_head)

The raw_hwp_page linked to the old head is then leaked and the folio's
HWPoison state is lost when the obsolete backing page is freed, allowing
the poisoned huge page to be allocated later.

Unpoisoning has a similar race: unpoison_memory() can free the
raw_hwp_page and clear PG_hwpoison from the old head after it is copied,
leaving the new head with stale HWPoison state and a freed pointer.

Serialize HVO remapping against HWPoison updates and removal. This
ensures that an update is either copied to the new vmemmap head page or
applied after HVO installs the new mapping and completes the TLB flush,
and prevents unpoisoning from modifying the old head while HVO installs
its replacement.

Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v3:
- Serialize unpoison_memory() against HVO head remapping (suggested by
  Sashiko)
- Reword the subject and commit message for the extended race coverage
- Collect Reviewed-by from Jiaqi Yan and Jose A. Perez de Azpillaga
---
 mm/hugetlb_vmemmap.c | 10 ++++++++++
 mm/hugetlb_vmemmap.h | 24 ++++++++++++++++++++++++
 mm/memory-failure.c  |  3 +++
 3 files changed, 37 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba8e11e399b2..79ca68dff635 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,6 +15,7 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #include <asm/tlbflush.h>
@@ -41,6 +42,8 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
+DECLARE_RWSEM(vmemmap_remap_rwsem);
+
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
@@ -333,6 +336,9 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
  * responsible for freeing the pages left on the @vmemmap_pages list, even on
  * failure.
  *
+ * Note: The caller must hold vmemmap_remap_rwsem. If TLB flushing is deferred,
+ * the lock must remain held until the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_optimize_folio(const struct folio *folio,
@@ -348,6 +354,8 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		.flags		= flags,
 	};
 
+	rwsem_assert_held(&vmemmap_remap_rwsem);
+
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_optimizable_order(folio_order(folio)))
@@ -536,6 +544,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
@@ -588,6 +597,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 	flush_tlb_all();
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index d057e8b12bf1..8b28063d78cc 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,9 +9,12 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+extern struct rw_semaphore vmemmap_remap_rwsem;
+
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -20,6 +23,16 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+	down_write(&vmemmap_remap_rwsem);
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+	up_write(&vmemmap_remap_rwsem);
+}
+
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
 	return pages_per_huge_page(h) * sizeof(struct page);
@@ -59,6 +72,14 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+}
+
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
@@ -69,6 +90,9 @@ static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsi
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
+DEFINE_LOCK_GUARD_0(vmemmap_remap,
+		    hugetlb_vmemmap_write_lock(), hugetlb_vmemmap_write_unlock())
+
 static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
 	return hugetlb_vmemmap_optimizable_size(h) != 0;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 78f0a13349cb..6a7b7be9928d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -69,6 +69,7 @@
 #include "page_alloc.h"
 #include "internal.h"
 #include "memory-failure.h"
+#include "hugetlb_vmemmap.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
@@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	bool count_increased = false;
 	int ret, rc;
 
+	guard(vmemmap_remap)();
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
@@ -2812,6 +2814,7 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		guard(vmemmap_remap)();
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
-- 
2.54.0


