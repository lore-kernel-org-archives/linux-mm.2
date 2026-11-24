Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA0606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=iAyV/4iX
Received: by kanga.kvack.org (Postfix)
	id 8617D6B06D2; Tue, 24 Nov 2026 08:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B6F6B06D5; Tue, 24 Nov 2026 08:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728C06B06D6; Tue, 24 Nov 2026 08:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B49A6B06D2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:15:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE14AA7EAF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:40 +0000 (UTC)
X-FDA: 85470059640.15.4ABB982
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E1CD4000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="iAyV/4iX";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf17.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526138;
	b=0hJ8yD8/RW32Y1P+L0El+7M4uAHfJza50TiowmhD+jSi2cNKgfPqBsyqjok0VN2tjtQ7Si
	eZ3L+k4QP1B1IGpqAh2CEmeANiHJut/k24Ku2z44z1ywh9Uz3wiGgnjvUNJ27QFln3kWfc
	9sVSgTakEd2drcccVu2MbLUFliecaXc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgurLvvvr384y9MTeNkWPXzxaojRL6Dxy37I+cewcWs=;
	b=gpI4jTfi8uDXyEWM6ISRc3We3sliWvSbMat2H/gMghfqPECO3baxbzxZcNxdkPJSFZtLra
	EcQrwt2vbvOa4Ha7HiAF+LsgNt1C+saMAPecpscMzP8ai+Mapxzf6fqn6LPJlmrmeMxwo0
	oZmJTtEYUdQ40e4K718txnDGkoFtut4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="iAyV/4iX";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf17.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526138; x=1827062138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VgurLvvvr384y9MTeNkWPXzxaojRL6Dxy37I+cewcWs=;
  b=iAyV/4iXC3FclnAGjSNkNxdgrtTRqlA7lBDPcWpnKEQbSHIp5qvpITLS
   rGD39hnYlWOBtgW5JTysmi3w3gSeuda3YQvIX8hxYQlJBBOk05zh6GUHp
   LHsaq+20Xgqq7Smh81M98E+yuswJT4aN7abh1bB2ERMT9nJfXanotJP2d
   u/q4nWkxsnI4ouckhzU8iVkpjtBS3ci8PbhFpmyk3GM/HUGnV7iLcfso6
   N2QfqB3wfVub31JW3u3hbWrfT7Ovi/FGcO4EVnTA6lsv485xz1VXlJPOH
   P/bCcQi91swSaxkway7A3C5ES3m0J07d5xKtCQ0zzXBXItqVVZNloklxa
   Q==;
X-CSE-ConnectionGUID: kRW0/GftRmmhwwxUhQIPtg==
X-CSE-MsgGUID: +akRYXerQSiy5hQixpRXGQ==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="34958837"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:15:28 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:9651]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.27.99:2525] with esmtp (Farcaster)
 id e3a81d02-342e-46b8-bf3e-664c775bc11f; Tue, 24 Nov 2026 13:15:28 +0000 (UTC)
X-Farcaster-Flow-ID: e3a81d02-342e-46b8-bf3e-664c775bc11f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:15:27 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:15:24 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 3/5] mm: add vmf_insert_pfn_order()
Date: Tue, 24 Nov 2026 13:15:08 +0000
Message-ID: <20261124131510.38745-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ajxgjjcuofrsqfwtmpdgdha8gsykw8w4
X-Rspamd-Queue-Id: 5E1CD4000B
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795526138-101527
X-HE-Meta: U2FsdGVkX19GrnmNV3vcFGX14Si6DzGfLG9l7AwgOQUvD5YyA1p83QmcpsZacu8tm79eWSaYVefrDpqQ6nN0Y60sN9zpfgv40Hew/ocmVJxolLrtfjaKxFS/hDcGrWWvz3LBYWi9xhVw2xUlDsENUCm2yzlmaZRwp9JQTZHsb5BYga5oUqLIpvDyleU0+H67BGpGKPuSzOZlqPBXqnTd0f/pywQU783+E2rS5gIENWmhFCqXO1A7d/mfQAuJFybCaDgCjkiROpngSUCsse6R/AAf+ZHyCUnJrEDKHnXBlrjd1oPCxPiNj96Oct0FEi6znWseceso0Yjc0kDyEF6PFAJCGn2pJKh5/Vwj3TxpyDWjnP+O9+Q/tOd1ROdLv1gfei8qTMU2m+Ddr2BrUea5EU/FLE3/cfmoq1CEXWwl6TEtHzQooTgzAkjPO9s+SmyGvlK7YWzbV+SR6VeW0kl395M/8E1e0oeoF4FNw5/NlaoPwQfiMWZ0YIPdLLZdB5v+wx8ca1zmkgihltyKJqHK764vYPtMIhZXbgJOeHt7zlSJtu+JgFLs6bk3POES2tc7py2c40jWmrDpCLiuDKcW7nVCiNUfxXjBId1p6ZL5MJOOdkd5DCn/2nYV9ojn3eGPy5btxRva7S9Oq9QRwNdB45UZmTfd06c04jZi0n6sxAuol4IHMZSmV1l5vnvtLqErVN+othS3mEyTM/GFF+MTRemtQ11u09mrM1CWNCT3J+MesaHhoc5UCbqZw4dppgN+8cJbDkgNGzMPEuwh1f9f1oAxJ3HfH6algRDu5D5+v1u4KWu5jvFkP99O6nNQIZKGfAiMk9G1JQ50cOE/Oig13OjmHCJ5s8Uo5z1D3o4yF+/9iDo9BX5e+0bEqsRuQhQnfmoq9G6sAcsI0BnzAQ7sJkTYm3upXR9bkjJsUnIytCG35qgiDLnOZV8FB9KrxTGeWBwh9Y6IwPIjLUq98lr
 gP3HSd3F
 3YYNwxMymKdG73W2JgX+RQmmOSD1MkRtbQuW2r6E+iAkIfIBY211jmGr5hJgA7Qe89kpe/M4mP47fsJVM2rk7bJWHm/OI7CBivtDmJ/COL6dKBhofWzP1HX3lpdBhJHBcz3cKAHTWvtX1Z9MXEELADryd+d/2mSUDq4AKZjvoN3NBAffm++g4Z9LO14uTQs7BiA8wzq45AZmOyL98dEmI/BuiDlpLhm9CYxFXcK8vRSusXI3UJDbueI4jz42NeClIUdk1LkgylC/9SJ2GzOPJuw5vaapiNMjTrcKoc4xm9zBtHKziLnL3V7WyqUk1LpRywGyuE18GhOrdEFIvDFnJa2ChBpK77J/LRFnWy3blY30U7/BC6ofZJ3ugIfxLQWJpKQXIZd8ZfMdfqEpQGwTP+22hI02GBYcF9/+s96sLRzPvmOLiStL84UUNfQvkHQ/dEG2DE0zKgRot1nK3YDy2kW8wRXrNUyB7ZhChJFxJpVuy20ko8OfWF0l1Rw4o5vmxyXaOFonSIa44vteggvdt5wN9LUsZ5DqnAQ5m983GlbsTFcbM1p8Q7lQThTsKcOGFaoLwjF7OwWRqiEb3HFeYuIcReN7wT1QjCG7A+gMsKzb2UroPlcc0/KvhWSHrF1QMpR9iW9kPI7blyhukojI3bcdNc8gIurdCUTCBXv/EkMUUkv30sAx8ZEnHlFxhXtNmtK2TNrWHsw8yJQ47uG87W7iVhx5lLEkihGEnL57xe98Zrb3VjetvsOs5rzUj/k+ZnomfMrYLg04lQ9Oevqrmt020OCw8QIs6a1xc4lcdhP5ZuT/nywndrHUFEYRoeNUvvigsAHfnnp/fhmxc9iVCJtKQRxv80mv4rxGl8QJ6FvxsycEnRhtfvrBJcuD0tS3dFqARA/IMkOBXwvG4k2RybAsIWCesXt46QVF57Wnvm4GccxLGNU/q9sbGU8tFCkMcoQ3z+GTlqDy6/9pCLtaOUrH+y1Md
 oC7bCtr1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mm offers a ->huge_fault handler a PUD first, then a PMD, then ->fault
for a PTE. A VM_PFNMAP handler wanting huge mappings therefore dispatches
on the order itself, guarding the huge two with
CONFIG_ARCH_SUPPORTS_{PMD,PUD}_PFNMAP. vfio-pci open-codes that dispatch.

Add vmf_insert_pfn_order() to do the dispatch instead.

It maps a write fault writable at every order, as the huge DAX and DRM
handlers do; vfio-pci passes false. No order-0 PFNMAP insert took a write
flag before. vmf_insert_pfn_prot() keeps its signature, with its body
moved to a static helper that takes the write flag.

/dev/mem and UIO, later in this series, are the first users.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---

Changes in v3:
- Dropped vmf_pfn_order_ok(). Patch 2 checks the window and the pfn now,
  so this helper only dispatches on the order.

Changes in v2:
- Pass the write flag at order 0 too. An ->access caller that does not
  retry the fault was left with a read-only pte.
- vmf_insert_pfn_prot() keeps its signature; its body moved to a static
  helper that takes the flag.
- Dropped the claim that uffd-wp can write-protect such a mapping.

 include/linux/mm.h |   2 +
 mm/memory.c        | 102 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 80 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cab58a403a3d..263689ded155 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5069,6 +5069,8 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn);
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 3d5706f8a7bf..7deff9c18acb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2931,6 +2931,36 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	return VM_FAULT_NOPAGE;
 }
 
+static vm_fault_t __vmf_insert_pfn_prot(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long pfn,
+					pgprot_t pgprot, bool mkwrite)
+{
+	/*
+	 * Technically, architectures with pte_special can avoid all these
+	 * restrictions (same for remap_pfn_range).  However we would like
+	 * consistency in testing and feature parity among all, so we should
+	 * try to keep these invariants in place for everybody.
+	 */
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
+						(VM_PFNMAP|VM_MIXEDMAP));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
+	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
+
+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	if (!pfn_modify_allowed(pfn, pgprot))
+		return VM_FAULT_SIGBUS;
+
+	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
+
+	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+}
+
 /**
  * vmf_insert_pfn_prot - insert single pfn into user vma with specified pgprot
  * @vma: user vma to map to
@@ -2967,30 +2997,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t pgprot)
 {
-	/*
-	 * Technically, architectures with pte_special can avoid all these
-	 * restrictions (same for remap_pfn_range).  However we would like
-	 * consistency in testing and feature parity among all, so we should
-	 * try to keep these invariants in place for everybody.
-	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
-	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
-						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
-	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
-
-	if (unlikely(is_zero_pfn(pfn)))
-		return VM_FAULT_SIGBUS;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
-	if (!pfn_modify_allowed(pfn, pgprot))
-		return VM_FAULT_SIGBUS;
-
-	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
-
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return __vmf_insert_pfn_prot(vma, addr, pfn, pgprot, false);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -3021,6 +3028,53 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
+/**
+ * vmf_insert_pfn_order - insert a pfn mapping at a given fault order
+ * @vmf: The fault being handled.
+ * @pfn: The pfn to map at the start of the order-aligned fault window.
+ * @order: The fault order, as passed to ->huge_fault (0 for ->fault).
+ *
+ * For ->fault and ->huge_fault handlers of VM_PFNMAP mappings, which must not
+ * be COW. Maps @pfn with a PTE, PMD or PUD as @order and the architecture
+ * allow. A write fault is mapped writable, so the first write does not call
+ * ->pfn_mkwrite.
+ *
+ * Return: vm_fault_t value; %VM_FAULT_FALLBACK if the fault cannot be mapped
+ * at @order, so that it is retried at a smaller order. @order 0 never returns
+ * %VM_FAULT_FALLBACK.
+ */
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	/*
+	 * Pass write at order 0 too: vm_page_prot is read-only while soft-dirty
+	 * is armed, and .access has no second fault to upgrade the pte.
+	 */
+	if (!order)
+		return __vmf_insert_pfn_prot(vma, vmf->address, pfn,
+					     vma->vm_page_prot, write);
+
+	/* vmf_insert_pfn_pmd() rejects the huge zero pfn; order 0 does not */
+	if (is_huge_zero_pfn(pfn))
+		return VM_FAULT_FALLBACK;
+
+	/* vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() do not check L1TF */
+	if (!pfn_modify_allowed(pfn, vma->vm_page_prot))
+		return VM_FAULT_FALLBACK;
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
+		return vmf_insert_pfn_pmd(vmf, pfn, write);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
+		return vmf_insert_pfn_pud(vmf, pfn, write);
+
+	return VM_FAULT_FALLBACK;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_order);
+
 static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 			bool mkwrite)
 {
-- 
2.47.3


