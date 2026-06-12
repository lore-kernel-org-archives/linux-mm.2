Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C5CCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F7C6B0088; Thu, 11 Jun 2026 23:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B95C6B008C; Thu, 11 Jun 2026 23:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8826B0092; Thu, 11 Jun 2026 23:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 058B46B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8D27A030C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:19 +0000 (UTC)
X-FDA: 84869905638.25.172C64A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67BC0C0008
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KEnWYJbO;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236757;
	b=yR6CoQamS2cbugkR4zRt//b3kJ3mNb/b72hAkSLDArZa5BeDTvyOmgYz5kjvMgiH1gSHnA
	FHfNQe2Oi1/5Md/btHWHTnuX+qpLZRZOq3lMFJmhydN7tS7COMKFqvnkoyI5EbgmBowFCt
	X9MxfwQcZG/391ueXo93TyDAe2NZ6F4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KEnWYJbO;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGnxBE9ZAaNi/tjsaLR7aR0BPLKcOcY8H1vV/Mvx5Rg=;
	b=uYGZbVgx1r2ktO7WejJFjagctiuKW6x0bwsXfU6TcgRVSnfMflqOBmHS3PsI4PC6aQc/hZ
	efqE1tup6wDcxk6Qxlsamnq9XjFSZl9PLkjYZBjAmjWt87qiWyCymCbQBGMIY7kkAoTfDQ
	/JKTTpvVZE0d+FEg7kmtYdEe6KFwHoM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-842cd900ee0so267509b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236756; x=1781841556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGnxBE9ZAaNi/tjsaLR7aR0BPLKcOcY8H1vV/Mvx5Rg=;
        b=KEnWYJbOaQ8Seufxy3mydEQs1mrA9TfCOk7SP+GnLm7fWLeconQTAk8r5Yy1XxIDuU
         YZcLUQ8Ug/kt2vmnvdIY+AprdfsAVtzGhkQ7vNDwj4JXh/+V/GWeI7aFyp2b9qQ0GVp6
         H4/nxywWuZW02mhHahmcwkf3MZVYUvx1klw40yMs3Lz1vsqPJebnwRQa85n2ca9/90ze
         +yByNsWDLLrNlxhq1UVxnaHttUwzGMav6x/dR0LFYYlRtWh/5vEZmGv53aMLyRNODyZK
         UIDwxOK3E4Kdk/xOwsk3aQhrb9yl9x4RjGw4FczgZA83aVADRD+q2P8rufutjBpbzJX2
         RK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236756; x=1781841556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BGnxBE9ZAaNi/tjsaLR7aR0BPLKcOcY8H1vV/Mvx5Rg=;
        b=FrS7C9Sgm8Mi83x6YOfgZvc7mYK24V7gLqfDaWmrnbb2vttJtbutjO7CHFiRxfWOws
         ShVCltY9AYIaNvWX/9SWr1HtmwUumQR5XHtFohlOCvGzZoVhGA6zK9D2B0t5IfiHO+9R
         8wmNyGE3/x/n6zO19/o831xjSnzl7jbA3Y+AJOVpJUsbHCyLtgl8aaYrphyg6l+p9QXk
         5LB76V5XmLOlLI/3M6JLunBIFtwjisOsyHhR9rUpNu4CP3mH21YMyNjtSWU/goXFZvZn
         UbAYfzdtvxPi+CTGqUuS6kFhqzuuhVl9zc+0K+g0mvV2DFlyjgUzfKe4yN25dr5kDCBZ
         j9JQ==
X-Forwarded-Encrypted: i=1; AFNElJ8v4066PmQzg8D9p+ZZSRO858AMXisRAtYngKEO97bpJWwCAsVfOrxRzph53LJxIs4s45x1XyiKdA==@kvack.org
X-Gm-Message-State: AOJu0Yyib/LJDpJ2lN1OH5HjJb2QeNjLi3kgH8axWaqscXWxvO0SJivr
	jmn0xB7p50xU5B8DYcSaSQLnoNeZHWsRBJz3mymcOGSUv0NaT8JmHIcfqoQzzHcyIiY=
X-Gm-Gg: Acq92OGohS9KJfCadnUwGQRNZL4IQs3vywlhO9rJvZ76vEiV3dpsKqr+Nj1cDL7h72v
	3n7rsIZsVmozQry4yskz+iFVA/4XcA/XtsvpqGWVXkDTWH0GX+bMqifxrlTSPU8KMKpa1OFpVdq
	DzXNPrqYWB1AzLO+s0U1Bn0lPNH7NNRg9mhMQALHU2A/TxWBba28VtrhzwlKBYcaziNqcZTB24Y
	YbTWL8DGVWOQFGu7ed+jqzPPpr0Nj8MUgop8FmFucN3ubfBcBnmoSRJPanJiZSUL4lzidxgYpRK
	f8f7RMy68TvMPQg8OmqKXL9otxcia0PM/i5h27OPI/SfqtLUJp3YehktZlgHRX7lPfJBmO/SFpQ
	bPWmD9il1C1LqdaOekjMSp0W2J1o5M42ENZWWA7USeE1dTi5Cd08HeZhOOdUyS0yxOkCagr9z9H
	pcvdD3PhKPt4gVyo4WF7jrlSTwE4hTQa9PeXszzProFTk24RtLk+70RA==
X-Received: by 2002:a05:6a00:2e82:b0:842:48ae:1d56 with SMTP id d2e1a72fcca58-8434d0cdb37mr1033250b3a.35.1781236756174;
        Thu, 11 Jun 2026 20:59:16 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:15 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 01/19] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
Date: Fri, 12 Jun 2026 11:58:45 +0800
Message-ID: <20260612035903.2468601-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67BC0C0008
X-Rspam-User: 
X-Stat-Signature: 3x1aahk8diihzkxr197jbo45qa49rrek
X-HE-Tag: 1781236757-97263
X-HE-Meta: U2FsdGVkX1+KYf0uh0q6d96T8KJPnjYpUUvXhVpA8CER+C9l2/kw4Sf+M1HzXNiRc/OW812Y9HA1i8krnih4o/hX94YWzJfj/xfkLW4+ILuzqr3Nme7vd/XXqKKf1yqcYoLeXXMYbdgzfLp00A83HRmi6ZdzafyK7XasepIHrW7sOZJbhAA6eiTxel0zOyswEZ1jIZKrLZgOuYJyqySEFv6ARt+zI5NspgTHp4caqI8gkiUMluum6EXfvBpCxBvP0TWa5ndw1BroImUJ9DHRG/YCbhxu9UiD+9s0Y98AfYQRZfGzoz90n746lIDCxFBjtM/VDavyQeLOCZZrmCzEOQi1uRkho5eVTe7mZt3R/z1jjJjLogHk7f+nhWiFJBjlLMfi2CV/DcORvBu+S0sXc9C2TKvefyoWOGuggG0Jcdp1mkkWXATHeZ1TWPG/HvWqGve9SWpXkgC7clwngJu6CpUPGoeqafdFy+uRGZhRye6+MMv1Pk3lVcRnve2iCd8p1AnwDARDyOCa4mju3FQbGclUlTjWIkNp1mNO8R8SesZU7rj7XYU1Ha7EA2TksRBYEfCzNy3LIwQ10/yWfgeBIFh0lsJq7d9mepkCUDTqdxSHNYfpEXusjg4Zpuf1AS+6VjO/ml/zq6pYYXqRVxl1WKn0dlVPUUvwZi1586gbLwvxkk3B+MeGcD2RwBTM497p5X+xi8eIrakbwd7QE2S2glorbmeoCgjhgik7uDME5B3ngUeqNSpJhukCaO1vpVKrY0/ChJ960+IjbxpTTC0ouR08QwIrtMh8+ierMID2v6Zo5kqM3S2gz6/4tO/5Y5cBc/YNHQ5QD54uxthF5AoKtN6SEzqC+1qDEM9qbRuu+0gANKKf7E5OJE3Nwy2FHclEEXOx42DX339rCMLxzXbpk31L80PAZCqvWTqDdncANC62nOTOMsatrV0qW6agM3q1aaSZISuUfoxbC8KI9SO
 12bq3/8a
 dC2S5kCuELkxyC5kb3NaqaPRLUN4fFh6l02a4KHUEZYTMBFQC8vaTa/y91bX1Ww/uWd5aaOms8OXcFw+oceNgrUtNyS9EmQUrOpmTg4cpOpWjTG4AcyDn8kp/CvVDSqMsxU6D6lpP9Pc6E6D0IGyGJvjg60ot17ry4lJ+aSA9Uvhvn7YI93rHLvw65dJaOs4VM3JpdVH5DLYM9VkMhZ8l+xUAkUJx6dplj66Wfs0Z0a3DVCLAbJpee2OhxRdg3N8rcqtCIERzQyigqaIUHIHNuAvDiqAZPLyLrvf66ATXSpvvdhFAu0IiNC1oG5Xja//k1s5aV9Chk8Ur/PEbphaCyiuOc5ssvfGmtlc4gOx0gGfoAMF+01akhS9FBwMEacQxWJqb1SMcXC907sIRsLXSaG/EgoTyKdPS65SSAGqv7nfBoxGZbSupRq0ThLZCjbvoUVKzY46CshDkRSnEtN1/lDIvZnUwPIWgWWbm9mvxMWKm1WEm8FR0kOmIhDNYj8RYZG7+CH9BSQsXgUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].

Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
bootmem HugeTLB folios are prepared earlier from gather_bootmem_prealloc().
With hugetlb_free_vmemmap=on, prep_and_add_bootmem_folios() can access
pageblock flags on bootmem HugeTLB pages whose mirrored tail struct pages
already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
get_pfnblock_bitmap_bitidx() then dereferences the still-uninitialized
shared tail page and can panic during boot.

Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
bootmem HugeTLB folios are processed, and drop the later initialization
from hugetlb_vmemmap_init().

This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
assertion is evaluated.

Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/hugetlb.c         | 25 +++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c | 17 -----------------
 mm/sparse-vmemmap.c  |  2 +-
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..cd55524c7e30 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3365,6 +3365,31 @@ static void __init gather_bootmem_prealloc(void)
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+			struct page *tail, *p;
+			unsigned int order;
+
+			tail = zone->vmemmap_tails[i];
+			if (!tail)
+				continue;
+
+			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			p = page_to_virt(tail);
+			/*
+			 * prep_and_add_bootmem_folios() can access pageblock
+			 * flags on bootmem HugeTLB pages, so initialize the
+			 * shared tail struct pages here before bootmem folios
+			 * start using them.
+			 */
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f..c713c0d2593a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
-	struct zone *zone;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 99e2be39671b..bb23fb3077a3 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -342,7 +342,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
+	 * gather_bootmem_prealloc() will take care of initialization after
 	 * memmap_init().
 	 */
 
-- 
2.54.0


