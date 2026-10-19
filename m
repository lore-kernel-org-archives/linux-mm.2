Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA5BCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3096B0182; Mon, 19 Oct 2026 05:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354426B0184; Mon, 19 Oct 2026 05:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242E06B0185; Mon, 19 Oct 2026 05:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF0FF6B0182
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:09:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 864EA1C3DE9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:09:01 +0000 (UTC)
X-FDA: 85338801282.09.0BE12E2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69F701C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fm+9Tbvk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+7LPi5HRPOOcdUC/D4c64YzsREdoI+6xRf4WfL2Y6c=;
	b=uvA5/6NKB/awxuMVQzVQnBufBwe4l2AOXEHDSpKFaPM9Is+mTNNFcU1PPnK7GcC6YZrD2z
	s4HTbT3gPmuKX56TiuV3q11YpBrcv3ypB9gLGU0fjedCUfF521FyWuYjx/yqP0xJ8xVufM
	+lLggNkQFARqiDFkUwJl8+KE+vaT/lw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fm+9Tbvk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400939;
	b=Ghk+arAjRGeiNDZeiOUQlU8lcnHf+Xdkv3lZIb9wITsgFIoSGRJzCv/9/Rdr1n+rHBibJy
	nTMKfLzjngmcPxKD4sU+JbBOgF9/nmYy6ouPLY4D0RsPi/KF8wbTBJeIUf7yASXld050Ao
	jn9NdvFXhD8b8jjxLV6YXjeumxC/d0w=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e9cf928dc9so5417505ad.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792400938; x=1793005738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P+7LPi5HRPOOcdUC/D4c64YzsREdoI+6xRf4WfL2Y6c=;
        b=Fm+9TbvkJ8SDgO53aW6W9ijexGAomnREdcvsO4GjeivJztwi94mhfNkJo+v7AQLWsy
         VDBNLvzXXMK3F0vfKZUQ1uQgmwdgglse4HyG2hIZzi/SNuIzqxxNa3DaAbMbJGK8QX1K
         WI+X/W0SAUu54OJgq3DDfnaABoc/08pZMcRtegq+emPtWMQYVoaBC1w2iUu9dsKSYZDu
         PAYCTDDAh4puBZeDbiMuodvncKyIYnHk/kmc2Adcf54O23dzMX1wgkm2QVD5Tjy4TAvW
         0FNTZtUYLRRe+EanVuX5F6LvEOcIfQ8Am19RGmBHGXQJpLxM5nm/LxG4h2P6I5Xt60rU
         27Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400938; x=1793005738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P+7LPi5HRPOOcdUC/D4c64YzsREdoI+6xRf4WfL2Y6c=;
        b=yI6cttchbvFGZJcW7snKKcrLl5RAudyIcb1XA/bDAc5Zv/WADEDNf1FcXuEwjNkMa0
         eUDoa8lPYz1kDDr612zb7zw/R4Smri2WlO1D+07VqSW+pbh9lQjR713zx1goxkEcl1jv
         38ZNzyT9xFzoHbkcIDqXLYsNiMRIvKS+wUcKPtH5RdiQfC4LHzajep/zo2wHM6Jafmil
         NKAQ0f+7leB6YvSXNaNUkwRpl6B8St0Vr5u6SgADkJM5usso46+jODWH3dZl4eNDRndZ
         TXjmKLLtlTiwkSO20yqpKtqqV2sRu6xgTg3GkmIyhtmnv3HxqY+VMYc28blUPYxqy7+h
         WulA==
X-Forwarded-Encrypted: i=1; AKwUvBx//55G7JF37DmQ/MmgEG9GlISkPZjOSf+FC51Uu6TRD7IEj7cT9gBGJw7mLCy7PM9QrEGSzd40eg==@kvack.org
X-Gm-Message-State: AFq9FYLi5gjj/d+Z72Jy16AIYIkazNh0bfjFoQHmfXz5ube37PEcL3sF
	aMnoiCYHPh/9xKXyQKIR1Dr3G9+mEPxCHFOOxcYuSXtL5W44DiZVg+8FLgunmPLY6nc=
X-Gm-Gg: AYBFou3GJ7oSckuFRsp/YbcqTXWqDJHot3Rf8NssIClzUHUMJMqEJ292iypUX2wEul/
	d//CfMDSdBB5y/O6nkHcPxJ5FlKIp1qm7hFMIGxWXCQSbRiz4TlCW5yfxLGITKcrHJ8Tj34yY6P
	TjlMZghNB1nTMVfuD39BEtD2inNY7pWPy9OuXTJjgpfFo1kBk7DvFuS4YmSLdeur0zg7GHFQZGs
	tTZhRhJWdkBkJ80o0V7leLHy6pPpdujkMjREnIfMa7A+Q3Ga+M3cCE/IxaG46ZEM+IyhQ0DUoke
	eTtyJGcV1+aMC838f0jGjgJCl8TZ/0u5awwUHkfiyh9PKRrxdlmTDBTmfnQ2G23K0ZIvSiojtpK
	2kcGm158K2HL77/SMf8zGO7ifkaD4fTSBD6WqLV5qUsnECwSfRD+IZU2IqWnaQsHWkpLpAiEmda
	Ax6kMNa/7kKRmM/5JKyeHUj8GeAWDipPS5/2U02tO0MCVyGUVliFK6WXBUreXjM68PJcdZTrxP8
	Jzd1PA+C9gIk3AlPSs=
X-Received: by 2002:a17:902:f603:b0:2e8:6540:11b6 with SMTP id d9443c01a7336-2e9a6e3c596mr43244805ad.37.1792400938093;
        Mon, 19 Oct 2026 02:08:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm36707595ad.0.2026.10.19.02.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:08:57 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 3/4] mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo()
Date: Mon, 19 Oct 2026 17:08:29 +0800
Message-ID: <20261019090830.1917657-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69F701C0004
X-Stat-Signature: qfb87yrtt1zamsnwo3dydbp7ag9tp9bc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792400939-342697
X-HE-Meta: U2FsdGVkX19tigw93VrEO+a86QtIZ3+j6hXBCDB2o/KlK50350ktwduZ0IH3zgwLhQQV6mh5z2k3qyJxb9zvUh6KKyg4shsSJud0UPzpz7KLXSeni4gHHjgxrmaYoyLnoF5vr+YoIFYDomBHZ2iDfYzzhpFF7u7CnfxTl0E30U5axVB6aN5WqIrcOj2IqlndNULBOYBF07nvlPTUc/378BetXewmYQskA9jo5OsiGs9Dx22u3F+u+QUujhdJwLs1CF/Mu9XHirmMiNRhldh2yNzSt6CAyLY0U8SFuD34liCzvOs8CIUE0oceQy1+2VGvXT1LN4ibSasvt7xbA+1+URQxunOP5+vOWLV0YzLoRhpI2vM/EIiAPAGhYZDiFacL9eNR2/+CZuuA/Me60dmAQBbSY8hVoKyrvCiFKiu4qydOsVS7ZjX3gzTkHxdyb9N+MWWeeJLfupsFsq9OBqS+mbqCzQeM81+q3H4YLlwbLrGJ7GHiD4WFYbGv33saC1pZAbFzMWXioOyqEFKCZmvB37ZG9sMQJ8B4TC1+bsPEaDNb3TJw+Z6UEGP8qf60R2h+xQfT3IPVy6So07u6m6BkZhimap2iETXw+BtY8dJnxU6lIoD1XLLBTLOQtFuRcb8IlOca1zy6wj5B9h4cligVOF7+3tJ22RFR+aJ/tMdZq0kGksz/FCYA89V9LLy0AtjZ4iVCWHfbjeEZKU9bYWzt37xOMU/bkTccwm/d91WqpRvCkncoEtnzawMHP1UPqO4nH0ah+UdGIrZ9XaaOPy3ZasE83n1/hE4YL4VN9pYjPcqEJ6by2vTAXNNF2H9WLIb3OCIblZCivTsXVh/waif3hkfPKg+C8CL3h7CCIm2lUHsfDS8Ommli0l3xX5iFZvgxeBfmw8xpTtAwDgFl2Gu41bEr1JmYgms/yKS2orMiUfhQzGr4IX/RIMTL0LjNYg1safTr0odZkz+B8mTGXAZ
 L0B7ArWj
 EFE2ERv7vOvw4/1dra5Evg8qNXKe1viFUZDnNzMyO1CT/5MK8sD2Xyg4+WzPcfebiFIEp10KvirMMAy7db7/TA3CQz563APmyLgvVGkOARg3tU5cPM3TtnOL4JTnycYdXBI/XtEohismzWmXgQI1XI72MCsrIB+ueHmb0dpckJLg/7q/S1vMQWFXmbYaAaVBMwxSo3Diqh0zQIxoswCdeKyomH0h8KStauDQ7BOFSd1+cNX7xj0t64tX3SoBLIxN6X/V+1hENfH5/XaJOqOwA7USIuD97ZDsSFlbMXppGkocME71xfuCL4EUQnd+NxNRcFVG2ss7ZPdzfO7jXcPYE43mtrqT+uagwAMl2eMRAKK/e4K34nlCkCcqoEYBo1aT7qv5bKWElnBIVSg5hQ29pyn7aYBpGdwDh2BS02dEq0b8l10K2K5dqrlCazQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shared vmemmap tail pages are now mapped read-only during initial
population, so already optimized HugeTLB bootmem folios no longer need a
separate write-protection pass.

Remove vmemmap_wrprotect_hvo() and skip these folios during boot-time
optimization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h   |  2 --
 mm/hugetlb_vmemmap.c | 18 ++++++------------
 mm/sparse-vmemmap.c  | 23 -----------------------
 3 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 35f5fc43861a..6f5affe54946 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5359,8 +5359,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
-			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(unsigned long start, unsigned long end,
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0057fa2a16a8..3d72346c2ca2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -603,19 +603,13 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-		unsigned long spfn, epfn;
-
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * Already optimized by pre-HVO, just map the
-			 * mirrored tail page structs RO.
-			 */
-			spfn = (unsigned long)&folio->page;
-			epfn = spfn + hugetlb_vmemmap_size(h);
-			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+
+		/*
+		 * Bootmem gigantic folios may already be marked optimized when
+		 * their vmemmap layout was prepared earlier, so skip them here.
+		 */
+		if (boot && folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
-		}
 
 		nr_to_optimize++;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ba0496daf4de..0af4b9e791b2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -386,29 +386,6 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-/*
- * Write protect the mirrored tail page structs for HVO. This will be
- * called from the hugetlb code when gathering and initializing the
- * memblock allocated gigantic pages. The write protect can't be
- * done earlier, since it can't be guaranteed that the reserved
- * page structures will not be written to during initialization,
- * even if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.
- *
- * The PTEs are known to exist, and nothing else should be touching
- * these pages. The caller is responsible for any TLB flushing.
- */
-void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
-				    int node, unsigned long headsize)
-{
-	unsigned long maddr;
-	pte_t *pte;
-
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		ptep_set_wrprotect(&init_mm, maddr, pte);
-	}
-}
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
-- 
2.54.0


