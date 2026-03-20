Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591D91099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6B36B010F; Fri, 20 Mar 2026 14:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D0D6B0112; Fri, 20 Mar 2026 14:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BDD6B010F; Fri, 20 Mar 2026 14:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45F226B010F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 194E4C1332
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:15 +0000 (UTC)
X-FDA: 84567266070.27.FE25120
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 52B8718000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/bMC9Rd";
	spf=pass (imf24.hostedemail.com: domain of 3y5C9aQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3y5C9aQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3viNkbbm/Ogpf4SwfNVEvvs3dd1BOlP3cpMjUOPerME=;
	b=GM4MsQevEb5ybFwLNRJcyWjs2Pt3/PXFBhCzY4yENH5GKHqncP3pMCWdKkhQ2vfee/D+B6
	R03n7O36A8eaHS7XzvaCO6wKPfDAB40KHSJwJ4N+3P5C1MWBWdp17KsoJDIv9VxMgLpUrz
	M+qel3XaH6OE21+YhzZzRsPg+q03JbA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/bMC9Rd";
	spf=pass (imf24.hostedemail.com: domain of 3y5C9aQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3y5C9aQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031053; a=rsa-sha256;
	cv=none;
	b=vTDirVetLjjo6E4uLYI3igjoMkDUEQkptmIwYAJoNM6G7itogQJV/P9hVDYNNpBOnsiTYW
	HW0nCygE6JKJMJWbfJrn2BDaOSdZwYNqPq2OWR9GgBYZyg53pXSsYhSuyYLuvkjSHzTwB7
	OxLsz/Y+TEoD3b350NUqAdZSXCVHeyU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485397788b3so17376635e9.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031052; x=1774635852; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3viNkbbm/Ogpf4SwfNVEvvs3dd1BOlP3cpMjUOPerME=;
        b=S/bMC9RdpOzE8ct8mLHxrgH04Zk7LUTDPkxqvEVaqcdVq49OEkSfgrWmMv/FdtWE9n
         goH7I+mmdMQ8SkkF401hgfkfisP9UY4BXVLri0ZHxjDNFZbFWdstpH2tSfo97JXqOMqj
         z9E9Xy7ydpRZ4EyDdlJpE+bOEHrdppPSZ/o/xYx8I8pPMeVWgLYt7fG3WsxJJ+c20b6o
         v2HS3EytiOiBNzG4sJOzPa79lpAKSlx/UF1Jv9HFRtPzQJWMUE+5JXr6nX3w0ndeBs6W
         JKu1PZrxCoEQmyYbRsT7WBUXi0RabCPJ+mRKg8cKC7nvd6yKIR/FDRnygSdS1N28JjJj
         WPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031052; x=1774635852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3viNkbbm/Ogpf4SwfNVEvvs3dd1BOlP3cpMjUOPerME=;
        b=kgqk+KoZEyEcngFNpwPDBX/ZUTdQGAEb2YUjmL3ymcpt2Xv5NgxxnuIrSVQjlOA3hx
         TpfILpfhY0dsaWNprX+p3PYh/TGD1nQK60crdyOslKILAXeIhLIa9Bl5cgPpcwffol7w
         SBzoSLx671RNvGINoncWH807kmS12DOq8MFdeOeTSlaL0LssIMlirQyRzI9dVynRZL1w
         3gDx7gn5zA5NJEnWMtzuhnQtfMk4p1BroQHo843od2+9gpFsLoUJaaCygYNVnbIBXBeZ
         UrkfwttkuNk+fg+ZlDGCTdfMWuDi/+PMKUDL00gqo+FDCirQFG6E1WbqPZAg+ok+HArF
         RhXg==
X-Gm-Message-State: AOJu0YzOmaIUoG9geRX/dr2QW8sp68ETrjLjfbmfs+T66OJBELxsHt0r
	apWb8+ODbjLQ1KpjOEOqg3Xs228/EApYVKTK4FwfEbhm1KXASe9syCkKw2Thk9/4uOmFO737bL/
	jhN1X1kk7W+Q1FA==
X-Received: from wmpo40.prod.google.com ([2002:a05:600c:33a8:b0:486:fe68:2045])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3486:b0:485:41c4:e2e5 with SMTP id 5b1f17b1804b1-486fee1ac62mr67392805e9.27.1774031051839;
 Fri, 20 Mar 2026 11:24:11 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:46 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-22-28bf1bd54f41@google.com>
Subject: [PATCH v2 22/22] mm/secretmem: Use __GFP_UNMAPPED when available
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 52B8718000A
X-Rspamd-Server: rspam08
X-Stat-Signature: n49z756d18fozsptmwerw8zwnr9ftd3a
X-HE-Tag: 1774031053-369588
X-HE-Meta: U2FsdGVkX1+EY5an+pPobZ7xLL5UNXtOGeMRDttFC/bpRG1Cy31G1Y+ZLfmU+QFmXV9XbBrfk0FrRkcRX2TS2a0UE0/zSY0uvX6Pan12WErG3/gY++bV/fgfOSk9KYVrGtFVZUES9iJEnGuBRiPieBf4PooUE9vzzeiG5zTdqRc94MrllgscJQrQEn0EhURt/axyX42vCIYeImkwAUeT4AEEyisDG1RBb/emP4MV5FU4EdIt8Rt71m8miBp4JmMeokFM4Awp+ASmFgwGF2g8P7IyxicAJZgcrQ/170i93KOprktOLfv66aZj82FJYfJja0gTXutLtOjeP6vZKVCWGmh7LJcSIQGF1YOxF0Mwp3CVzz9tUJ6jH21cjRfsIq6bhOpnQuFxZSIzIxyTxfmF83HYy3AmLkDQzESNyaSh/XIxUhHhv2+NsLKcKz+2QNt6+u47ME3xHy5jVUaJUCglXrhtcVSxyFaOnFapOdlqiA8YKftCTbhm2SWIhnU5GsCtvlcsvB4lDMFpxkW0UPM9kCjqTG3/tueyRaj03oQKmanmoV8S2BuuXJPqCMz7is//n97OTSz2yHXagpENmjq8BJu3TlVCFdPXZ1Yrow6nvPcQvQIosKpHVFTiNaA9Mwbda+XhkmgjRr+w+bNCPAavySAVWq3qskXgGvQaP+2xX1j5zg9Ca8plJU5cgWu1JlX5ljWjdMWSPkIgnDY3vDrPFaGNnvRbZw2bgaMlfTQ7axGqsLCgHG1rATIBu29xvoFtAJ2s9FdEZzVlBEO5WT2mZUDUI+8FIPfdSv6P/5JQ6KX2QqbJqBVu3IL0+u/v5FO6BJyTnjxMSmsKLcms4OH5w+GO5+0kU6b2/rSE3WuD4RBwvCktPsipbWUkmAOfDaMwue74Kseu4ILIagVtYgW546DIOpC2shCJmwhL60BjTPMG1QJnPuGifB+27ENu+8EemhyNZah9jqngPZDS1Jz
 uh5JUElj
 IF2F0Wr+t5eu59dlbBzRK0lYkJlXBTdOnz104I41DhTjLD9/KBxdbxmp/ihucVvZgFkPJWRpvqqK800S+pgBb6As8zsngxqMZEOuTlNWJcOjmztixv03UkxRBDxIKWWskZb3bvNsRkdCoEkdw3Bmpza+tGilnm+TA6ZI8RuyQbn6N8+imZSDjkTIY7lezrNwfI5/zQ7Jjzm/bD4VPgqZ1p9KzoMmNqtmOYYXocTpgvqmdTcoDs1LKxRSUn1YnoLWAIE+eafj5zhLxY9GEQgZ1rsEJtUm48ZDAo+CYmF/Azxh6Ls6xj19KrMIn1MXmYxCMyD1nHKPBs9SwH7d5tgEdO2YSUJi65cYgA05os2TU1n1HubQ8IIrlP/FffCqzRSnogrOtayyu6SFgd52CmTIdLXPbS0l+vMQ5oRU3YBGwBpQhFPvAqRSnEC3QINzjV5fj/CcfAQcHfV4yQN5vRTHardhCqttiLYcO0zjHnxnYeZDixIqPFmzivzvjjgIeBq131E6E6OI762Y+JZZWxz7d/P8nX3edwEUhFGVtT/lwDJrPlqI/KNGDDffr6yDWjLeVnhn4KxD5bXpGgKdBLUfepAeVIcimQw9asPCXR0c8TewBrJh1fEP48mP7Y6hc/59ecp3sczzNzNt2IT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the simplest possible way to adopt __GFP_UNMAPPED. Use it to
allocate pages when it's available, meaning the
set_direct_map_invalid_noflush() call is no longer needed.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/secretmem.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 13 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 5f57ac4720d32..9fef91237358a 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/mermap.h>
 #include <linux/fs.h>
 #include <linux/swap.h>
 #include <linux/mount.h>
@@ -47,13 +48,78 @@ bool secretmem_active(void)
 	return !!atomic_read(&secretmem_users);
 }
 
+/*
+ * If it's supported, allocate using __GFP_UNMAPPED. This lets the page
+ * allocator amortize TLB flushes and avoids direct map fragmentation.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+static inline struct folio *secretmem_folio_alloc(gfp_t gfp, unsigned int order)
+{
+	int err;
+
+	/* Required for __GFP_UNMAPPED|__GFP_ZERO. */
+	err = mermap_mm_prepare(current->mm);
+	if (err)
+		return ERR_PTR(err);
+
+	return folio_alloc(gfp | __GFP_UNMAPPED, order);
+}
+
+static inline void secretmem_vma_close(struct vm_area_struct *area)
+{
+	/*
+	 * Because the folio was allocated with __GFP_UNMAPPED|__GFP_ZERO, a TLB
+	 * shootdown is required for the mermap in order to prevent CPU attacks
+	 * from leaking the content. This is the simplest possible way to
+	 * achieve that, but obviously it's inefficient - it should really be
+	 * amortized against the normal flushing that happened during the VMA
+	 * teardown.
+	 */
+	flush_tlb_mm(area->vm_mm);
+}
+
+/* Used __GFP_UNMAPPED so no need to restore direct map or flush TLB. */
+static inline void secretmem_folio_restore(struct folio *folio) { }
+static inline void secretmem_folio_flush(struct folio *folio) { }
+
+#else
+static inline struct folio *secretmem_folio_alloc(gfp_t gfp, unsigned int order)
+{
+	struct folio *folio;
+	int err;
+
+	folio = folio_alloc(gfp, order);
+	if (!folio)
+		return NULL;
+
+	err = set_direct_map_invalid_noflush(folio_page(folio, 0));
+	if (err) {
+		folio_put(folio);
+		return ERR_PTR(err);
+	}
+
+	return folio;
+}
+
+static inline void secretmem_folio_restore(struct folio *folio)
+{
+	set_direct_map_default_noflush(folio_page(folio, 0));
+}
+
+static inline void secretmem_folio_flush(struct folio *folio)
+{
+	unsigned long addr = (unsigned long)folio_address(folio);
+
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+}
+#endif
+
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	pgoff_t offset = vmf->pgoff;
 	gfp_t gfp = vmf->gfp_mask;
-	unsigned long addr;
 	struct folio *folio;
 	vm_fault_t ret;
 	int err;
@@ -66,16 +132,9 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 retry:
 	folio = filemap_lock_folio(mapping, offset);
 	if (IS_ERR(folio)) {
-		folio = folio_alloc(gfp | __GFP_ZERO, 0);
-		if (!folio) {
-			ret = VM_FAULT_OOM;
-			goto out;
-		}
-
-		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
-		if (err) {
-			folio_put(folio);
-			ret = vmf_error(err);
+		folio = secretmem_folio_alloc(gfp | __GFP_ZERO, 0);
+		if (IS_ERR_OR_NULL(folio)) {
+			ret = folio ? vmf_error(PTR_ERR(folio)) : VM_FAULT_OOM;
 			goto out;
 		}
 
@@ -96,8 +155,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			goto out;
 		}
 
-		addr = (unsigned long)folio_address(folio);
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+		secretmem_folio_flush(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -110,6 +168,9 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 
 static const struct vm_operations_struct secretmem_vm_ops = {
 	.fault = secretmem_fault,
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	.close = secretmem_vma_close,
+#endif
 };
 
 static int secretmem_release(struct inode *inode, struct file *file)

-- 
2.51.2


