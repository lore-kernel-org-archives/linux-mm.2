Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD97A1039880
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBDA6B00DB; Fri, 27 Feb 2026 14:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A57F6B00DD; Fri, 27 Feb 2026 14:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDE56B00DE; Fri, 27 Feb 2026 14:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C44C66B00DB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85C7013BBF2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:38 +0000 (UTC)
X-FDA: 84491261316.24.D69ED64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3C2AC000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNNORTbs;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=na/s6YTvx3ACmWYUOvZzc1E1/1rh7evlZu1iZranVi0=;
	b=20hDBanAE4Nl4UJgOrObmuR1fYRmqeVRE0lCksCvDXT6dNU3gzDrS5KsxhSp7DF5IshAM5
	sJMXZ1gBV6YVmTZTYezJCyr0zCvPWavEPF1cu5VtKpz3f6970Xke6gdgdX5lIfMd41Cs1C
	2DAjpnM15DBUd+h9ASS51rlAvDwdFUA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNNORTbs;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221416; a=rsa-sha256;
	cv=none;
	b=HU1rhmcfd0CkIKzjstUMjM5lp1utWfAelK6VJ+TBQHf17OUUTo0+tSp63xYsY3c5N52PG/
	4PGdCIJH0FFjA9ndbi3fgRjPG9hFCB7PnYK1qsCvvqOEbtyK8rNfYWbBEO0W2a/MK7H/5G
	/LuL74acKBMta29mONSFuJSfTurZaVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3955360137;
	Fri, 27 Feb 2026 19:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA91AC2BC86;
	Fri, 27 Feb 2026 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221415;
	bh=A/jdrFN99nKynIb0vG8N4R+NM5G2b3V4kufeAPBCD60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNNORTbsE4d2hC2pbaHL8AkpLnvcgb1amZ6+icnrFjUDC4blmwVs4NTqUlsuvSQ0V
	 +kBmHqrBBF+yDfYlAWwW6D+tDsk1bM6WIhfzE6tP00lGjNO4F8jpcMKjcD6eYYNkcx
	 DijegqQyq/brx0LqZPjfcu2/rExRyIvvYjBqWi+WZ7WA9/sp/51rBcY3H97LpJLaoZ
	 IXIELzhyMwyqbV7fytW8ZsjauncwC6B9iSeBjz7zs3exIQ2iUyoat9QBaf/KHx9YvF
	 aqSZ4+KoqtSs4EGI3Cl3RKZMz2MpnVzm21kF9+HFjINfx8swIQwnJW6rGJJQ53/Gfd
	 dNTEnNTaeXNaw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 11EE7F40069;
	Fri, 27 Feb 2026 14:43:34 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:43:34 -0500
X-ME-Sender: <xms:5vOhaRKZdSEY4qp-bawwyOJz6PWxDbfWTPlD4RpfV6yvnuj6da3DSw>
    <xme:5vOhaWVi4e5jALXqvLWKug4QP2sEScKL2OFQXZ9f6oSm2KKA6HNxB2T4dJavmrFk8
    RRhTvPNzA0Ofoi0yIB3J0DS75QltIfOS2XvpnKmniylPojvw5ojAJ0>
X-ME-Received: <xmr:5vOhaT2EJ32m3pfJs5MGRSua0fE7xkNRsEgIPwOEyIDhD0n6brGDSmu8sYcUIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:5vOhaTRvAdaXT-hbAI0Y-R2KqqM_FjGLa-fyM7EbNW_EiCsR7An1Jg>
    <xmx:5vOhaUX7L-llzthoggGG-TkIdLz6WpCfxfpC2MfCzSJUFGP0VWKlYQ>
    <xmx:5vOhaSN-FVvycu8BO7HaTj4h1S2li_UAtLPmiOH3ONsmH2MFKjMVEg>
    <xmx:5vOhab2OI-Zb68ovl9yxCteea3WL6bEILl-Lmld-xiSYCDC4uksHMA>
    <xmx:5vOhaaN0pdmDr2-C4iC0zqsEt2mxd8F82lA-A0Q6cN9LS1lPyJTtl0pc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:33 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 15/18] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Fri, 27 Feb 2026 19:42:53 +0000
Message-ID: <20260227194302.274384-16-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3C2AC000F
X-Rspamd-Server: rspam07
X-Stat-Signature: ct7f11wkjabcqaewe4t955k35bhteq7w
X-Rspam-User: 
X-HE-Tag: 1772221416-571367
X-HE-Meta: U2FsdGVkX19M3dhJWdBPFnMFDmQjJWG6AnN3QnnlXJacAct19ikQUepbqNl/6/HSGLenOr6exQNv3+S/KlM062yD/74otuhyd45gKh3OJFPzDB0+RNhkSZ8H0641UjrqyfJI1TdfJhSM9uOpwR6h/XWWE3FPTgydkVAb3EgIKBOAjlejEO8lNCU2t/OxKysiIDOD4NEN/ekL76nJHkyz508HNwN35AT0o0XsEtMSv2CF1k1OvYojzUJXxW8osUj/Iv8sTu+J5gIsZVoWHOAJDmW0GUnOdH3Drlm+MsxmAbciBPuN5L1Yi79jwnzugQezdPizBIuPgBlDvwVPkHq4mDVTAb7XFbS5VbBw/3oQw+/wP1gBibaEjBh4J3mCvGzPSJBj+nGwJHwVnhdL/wZQZqDqQkc1thKD5ZigGOnxLnqM4kiaAddqpnYHRt24MBxeIoOrJaBvkxkGpGt2w7w2jGLBDaCs0eRucEwPzMCvq5CopJ8WmFZYuDxlnF7CPjJxCXgBInRBotBbvecEd67nUJwetYY00gKL7AZczVT0lsDEVt9JkT3o9f9wTapq3B3UdYUPQr3fw9zAUSVG8s1FQjEits5x4qvpo5/0xc8Q5dJ6ATR6IIF4L6MKKobR5gBNbhbpr3mC9IoQ6PO1F/XruLzCwvpuB4ZtbqF0YpHUh5+FkphBf6n3jjABgE1iWcXCO0cXbzNNGrHQ1HQZony9S29jicb2xqi7BtCfZJfhSOuxKEbSApsksiauJEsBv8LemNvuIDocDwcXFTjrHJz9C5W88MH7+FgZHo29He9cRd+qIJB6VuI3Nm5vWLK6Z+WqtFhk3oFI9HRoJKVc9E0p5bTQ/mc12s85ylrRVwYB+ZSlFHK4opmW1Q5GTb2v/6IbgUNXKreFx+gpFKxDx24fPUmQbLJX2JY3BJuj3WjMZXZtdz4TOFLR97i07KYXdXGnPtN0OnKwaBtwAFy6uGO
 IEE4S5TJ
 oI62EBqxCw1y1UhM661ni8jE+qMmadZX59RKTw9kLMj8ATkH26WX8ZPDGUHBj3Ef/00zh18mL7Ryo8HTOMLioxp+VtiAb6mGavlZVGJlthmpJ1C8d53oRwMgScvWoD7S7GRbneLbYqBa8lVJ76V0upXLb2stUjLS9lrM87rUtU2f80yupW4yEkar/Xpo63TnX4kGzfxTToPqkT7F9XkNzStC/vs858NDlU5mQhh/I1/0wr6vX+G0pPO0MB+yF/uHtyez2f4AXkj7olRVxAUcVlD/HE4ev46VcjlLBKJIGXtYQgxMJDCkofqkzZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The hugetlb_optimize_vmemmap_key static key was used to guard fake head
detection in compound_head() and related functions. It allowed skipping
the fake head checks entirely when HVO was not in use.

With fake heads eliminated and the detection code removed, the static
key serves no purpose. Remove its definition and all increment/decrement
calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9f22e4f4ef9f..8716a27ef347 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,8 +221,6 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fd1d5d5d12b4..4a077d231d3a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -385,9 +385,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -419,10 +416,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -544,8 +539,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -581,10 +574,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -650,7 +641,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


