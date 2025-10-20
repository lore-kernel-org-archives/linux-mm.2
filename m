Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD44BCCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B878E0008; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE588E0009; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC338E0008; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 716D98E0005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F73A8710C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:04 +0000 (UTC)
X-FDA: 84016577568.12.CFEDC30
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D14720003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sMRhuMPt
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEApLyQP/b3KWylzRVCY886fGhUNpEUKEq+AzuyUBmU=;
	b=V8q4NJUtjsTnfgDZxzvmcse2ncj22NQlluwEHEXpygsq5DQNcWiZGGMUHQNe7u57SErOZf
	r0IemzCWEwGzI3X9zB7prD9mX9Aj34Uf5WYTOAHir4T2DMFYO/9m3IYilrI/zSRiJK4mtB
	ofo4Y8rEP8Xlez0sdikh/PuAsGnjHQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919422; a=rsa-sha256;
	cv=none;
	b=SEeDu/uVxGeOQGJOKpNW9AJkNrJWHQLUEi19bhEr7wEDVD1jIacftpnz3I5d0rh1F+FQf9
	zEBg+014HUZPaz6MYQUycB1hQ4Nrpe5pX7kK7Ag3dSf0v+1U3AqCmu9HP+JDjKjrphOGA0
	HYnx0rY1Eog3i27GVAX1bf/7upoVjes=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sMRhuMPt;
	dmarc=none;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=AEApLyQP/b3KWylzRVCY886fGhUNpEUKEq+AzuyUBmU=; b=sMRhuMPtBd99Fstr6ealDP6E27
	4DmeJ11xuYlvsEvnip2EyJrUQyshGco7faS8SIH8dIUjgbWlORPrH9GveSTqxCavf3AV3Sda7VGji
	te70L+aOgzcOG4dXzEDBofD2RLfiirCMKskKfdX29Ahcy43Vo8oOhalDSxtRp8vWtkLVE5Rj2XJom
	UpUPBiGmgpL471NooHBRp5rGAR5Kuv5/MRAlRFbuuODNXFuSwVyRI5YhJ+L7H0LBe2jVMrqp7aECA
	k60WqotHCSGGf2w83Z0lm9zv3gPaUgwc4LSURK9+qDZsF8Tmpn5iNg1mxUTi9X9HBsbiRcq4pBdKd
	SsjWE7KA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda7-00000008tAc-0ZeH;
	Mon, 20 Oct 2025 00:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
Date: Mon, 20 Oct 2025 01:16:40 +0100
Message-ID: <20251020001652.2116669-6-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: paifozasqizntzn4hjf1cs9si6x5sqg4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D14720003
X-HE-Tag: 1760919421-892980
X-HE-Meta: U2FsdGVkX18l5N/0efiUWYtmDPobGsUE41n8zID556see3zKICerDDjY9YfNBjEB5g8eMIOMqiIq0fajq7E5vnvzEuwglbRwaZYcoDMDbu96brCq9kaRWvyY55zTN0iWir0boP4fi3CinqdH/ZqNC+5vT7WJXzkegl+F47vJtSCOD8VHL+zHeNkWJtkcjLvoANS2ZY0PvfbduOqjyoEfdXoSiMY/7PkdwFmzZVACkHVnMQx2tp+vjjtnWpyYRP2Li5SV9GW8am0gRkwz9QMSRcM8L0WmGz3/UqEM3fof39Q7xN4AWWoC4ACi/5IDInEzVF2mg0EWsOQ4xhZieomNnqKsZhe9vsLSSyAolpKZxomRd+0MTjFcv3nPyaIyfXVxEFpQGOU/9vKV/TeXMFQfG57BzDUY0ogCdnLDDAlAUvfCxmJx6hVGjipkqAA7i0nYlOSLSpE4fFU8RZMQo+vuE/O74rZfo3Lx5nln8xxkC08CANcBaIK216zsQS0/ZcXl4OAqTrogVgQuUJya4whx0d7hsaTBfWFf5hWyijJFNREYSZgHCumadrfjgI2Ptnw2/zb0KSzFwJcZ3lh6XhpKGZAERD86gmymzXvsxbKCtpRnyPuSt9+KMaFCnLOc7XdRQOkEJIFB4iIJKLdffsN7xhHE8PDz6OI8L2j45erMHNGcRk7PXgpdXzCNmhbGDgu5UXHI7dsO0gsY6Mueils7ohV4zEDElFOlWdKL7xU9D992DM5jGJCfUzoaDJAl3YP21gbqCymMdy8zF0YkEorEm1awlEwlZHsFl0rBOobYKIgmNHYBpr9sv0UxRDfwjk0kEkxXqykPBjZowqgrW882zO7Ft8qs2bY8IciFWwolllaYr1jae78PRUAHc7hpzg5C7mIPlJNHanquJpkDbjKsSCSba2nLcvqx4+PMFhaY9VqEWi727WoARUH+Lktpvo4z5OpUifpYAtrN9gn3/St
 iQL/nuCz
 pWSrvtDLG3WZjYTLHtogZ/GLyjd/9wNy3XFUqI2vC2wKY6a1DNDArxLhxMjiFlU1sOCS0Fha+AX2kewBfXdFi/aH8vLORgHDEJE/7P7PJNxq/QnOrJiqsljMbu333Z/hSTaqc0W5gQ0iPmzJTl8aR05XVcZCfF4Or7OcBZMzUwu9aW58KUxgGVwyyYlXGFPvAY9kkcN9u+kCFP0IzhKdGkcBDKs2CnmiWDdTDQ4WV3bUz6D1IZ1j8y834utc5pE/MxNIVozK6Uf7Gko6DnOD4pDCG/bUSEewj/gRcMDJEdkamJmHKi9Rm19LYrxeZg1r1qQ77Y6A3z9C6ICJJL6a917NCuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When separately allocating ptdesc from struct page, calling
preallocate_vmalloc_pages() from mem_init() is too early as the slab
allocator hasn't been set up yet.  Move preallocate_vmalloc_pages() to
vmalloc_init() which is called after the slab allocator has been set up.

Honestly, this patch is a bit bobbins and I'm sure it'll be reworked
before it goes upstream.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/x86/mm/init_64.c |  4 +---
 include/linux/mm.h    | 33 +++++++++++++++++++++++++++++++--
 mm/vmalloc.c          |  2 ++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fad..5270fc24f6f6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1322,7 +1322,7 @@ static void __init register_page_bootmem_info(void)
  * Only the level which needs to be synchronized between all page-tables is
  * allocated because the synchronization can be expensive.
  */
-static void __init preallocate_vmalloc_pages(void)
+void __init preallocate_vmalloc_pages(void)
 {
 	unsigned long addr;
 	const char *lvl;
@@ -1390,8 +1390,6 @@ void __init mem_init(void)
 	/* Register memory areas for /proc/kcore */
 	if (get_gate_vma(&init_mm))
 		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
-
-	preallocate_vmalloc_pages();
 }
 
 int kernel_set_to_readonly;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index edcb7d75542f..e60b181da3df 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1160,6 +1160,12 @@ static inline int is_vmalloc_or_module_addr(const void *x)
 }
 #endif
 
+#ifdef CONFIG_X86
+void __init preallocate_vmalloc_pages(void);
+#else
+static inline void preallocate_vmalloc_pages(void) { }
+#endif
+
 /*
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
@@ -2939,9 +2945,32 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 }
 #endif /* CONFIG_MMU */
 
+static inline struct page *ptdesc_page(const struct ptdesc *pt)
+{
+	return pt->pt_page;
+}
+
+static inline struct ptdesc *page_ptdesc(const struct page *page)
+{
+	memdesc_t memdesc = READ_ONCE(page->memdesc);
+
+	if (memdesc_type(memdesc) != MEMDESC_TYPE_PAGE_TABLE) {
+		printk(KERN_EMERG "memdesc %lx index %lx\n", memdesc.v, page->__folio_index);
+		VM_BUG_ON_PAGE(1, page);
+		return NULL;
+	}
+	return (void *)(memdesc.v - MEMDESC_TYPE_PAGE_TABLE);
+}
+
+/**
+ * enum pt_flags = How the ptdesc flags bits are used.
+ * @PT_reserved: Used by PowerPC
+ *
+ * The pt flags are stored in a memdesc_flags_t.
+ * The high bits are used for information like zone/node/section.
+ */
 enum pt_flags {
 	PT_reserved = PG_reserved,
-	/* High bits are used for zone/node/section */
 };
 
 static inline struct ptdesc *virt_to_ptdesc(const void *x)
@@ -2957,7 +2986,7 @@ static inline struct ptdesc *virt_to_ptdesc(const void *x)
  */
 static inline void *ptdesc_address(const struct ptdesc *pt)
 {
-	return folio_address(ptdesc_folio(pt));
+	return page_address(pt->pt_page);
 }
 
 static inline bool pagetable_is_reserved(struct ptdesc *pt)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..9b349051a83a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5264,6 +5264,8 @@ void __init vmalloc_init(void)
 	struct vm_struct *tmp;
 	int i;
 
+	preallocate_vmalloc_pages();
+
 	/*
 	 * Create the cache for vmap_area objects.
 	 */
-- 
2.47.2


