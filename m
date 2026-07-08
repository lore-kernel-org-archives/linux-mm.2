Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4778C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093B46B00A6; Wed,  8 Jul 2026 07:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F126F6B00A7; Wed,  8 Jul 2026 07:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E283E6B00A9; Wed,  8 Jul 2026 07:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5366B00A6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EE761691C9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:53 +0000 (UTC)
X-FDA: 84965352066.06.3FA0E33
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A77EC0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=j+Nhfl9T;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y Mv1tHa";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC2/97vBNOCPlsdXikZHg4T62TuNpeRdug7Z5jbgk+A=;
	b=ASCN5cNJk2qO+TFOR4xcqAnx/xjHnCxNcLfNgZEHfs+DGPdjmRmJkIK+6dQO3RAmJesSlP
	iLP7HAS/F/PrPJ1Tnh47dgNlwQNy+I4hBoInVFp5jgAEM99aIH4PFVVmYavqPX5bO13qyn
	7vhEzNedhEWKivHppOEw+x5OM7EV1n0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=j+Nhfl9T;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y Mv1tHa";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509291;
	b=T0S35cWH8dQwMsDF38XKCEsUjTNAZGfMot9pQvvspwmTFQ7y89orC2xIbshZBPkrncoBlM
	BiofK44VMoCyzA0tW+8v2Vg2hRPbIJ7Yqb1/9KJC5Q7XKdagTieh/3iXFdPZkrQoOrUKtI
	xYzeGzbQ0n83R/0drrWeJAWtZ+1YKn8=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 1E86C1D00128;
	Wed,  8 Jul 2026 07:14:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 08 Jul 2026 07:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783509289; x=1783595689; bh=IC2/97vBNOCPlsdXikZHg4T62TuNpeRd
	ug7Z5jbgk+A=; b=j+Nhfl9TWfmFCOBApJw6gWGgAXljI0xcTYKWy5t2N2POsTfc
	yAy/2tCzlb5vdPBx16fThm0M+9dvn4O9oFZmht8NW1a2z3FEZdEz0yWkJJhaE8wT
	xqnLyAoteRw4C2bNqHAtLTqMABlrzJmLali/DyMWiT1HIUXs36t5WaG+X/Is2JuR
	YViGhuo8ekeqEdyvDD33/aHGYUiWo/kZ8H926uacorAY8rsg2KTZjVJGckC+iXku
	Am9scw+AnbNculucUhC47u2i5AMkoXLRc1cW25iO79UCGZvRWtLbSwzkLfG2zubU
	jwVvQZkbsrBCWDFW/4Sv+rEN7h8C6bjKpO49og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783509289; x=
	1783595689; bh=IC2/97vBNOCPlsdXikZHg4T62TuNpeRdug7Z5jbgk+A=; b=Y
	Mv1tHaqKgCJpxzqogKncoQLFr8GpdGJMUNhOCizfy8zOewJRg5OMXpJWBoAFNxPR
	LkOqflyiwRIuYChBd8XNOr/66wFYTJZLvbXuCYINOLhLESFzTvm6uHxbPjkv6Ptx
	EviVfmE8Q2a0quUquRdes1PckXkWB475eAT3e/2qZND/fsdOKoeLGYybh1JMkwsh
	vH2SPKXnLS8e70QRKp3efCaTNGjx61CGiLB6oXwhXDrWu9iIaSdLKdb/iaLoIRoR
	D0VwyOV5MQVFgaI8yryItWk9Fb+3eMY8XxB+qitLJnaq20/jEQjMFVxhzI7JnOu0
	oq/fP5kvwnl7wYftbg86w==
X-ME-Sender: <xms:KTFOajWrT8doc2DNJRYFtjREBC820V4DtgKXjJD84NcSMLlzVl6Cdw>
    <xme:KTFOavjKwwl3mqhA66jVzDW5aytBd3z2xT4qFtIrE8OQTiUVb3pZN8gRYWPq-K-Rj
    GxFdtp8oextoQ2h6d_0MhNf9xpzTkIpk053Ca5tG6z1uOUAfbkIlw>
X-ME-Received: <xmr:KTFOan57FYY9Py2Ol3sX2c3tyCw89RiGKXe9Yi_zOnu3ytjvm0H2uMCXQM4PQw>
X-ME-Proxy-Cause: dmFkZTFUNIYXC0Q5t8iqxsk5x/ZZMsEDxIoZnWAQZPTQe2TvhnM3yGqaiQbzxnqs+7JIiR
    Yq5XhJlRG8HRcn4TzRiv2EKww24qGo2vzTE+dwYEALdjzUu9fkyEySz6S/StK8W84OHvkq
    W9bJFACiywJM+FHRWARKJSxsj/OIv5i/+BUkO9YHMo8DRu+y4pegyGixo+73/KOUD27j6H
    5pOE/wzQGFm6/nPC8g/bDVffg3JUC2YP/n7l/I6zXixgasab/b3ztmwGVl8QyMOBshJvPS
    ED/XZSrmnCYJ6UGjCdjgdYCVYCbIESChWLzOeM4GIrKC6PPK50eSw/FV+ttn4eLfWIUOKj
    1QFEVLnsZ9nmD2tZnmoUjNe6hnOITSbYjEtGGnNXBjdU08ohLfOHuIktOJUHR2fzhOkbpb
    s+5qwb+N+rrkdUFAOFSmZY9pfjhOLqBp9zf8EBG+UHr3yk7RmhZAl7dB2eqETHS392W/Mz
    EV7j6Hlgx+eBnqWXVg8/wfMBRle15oymKaqG1IkHjUdiTy1T4cBdMJb007D0pbGF7/AqSB
    hQr1yh5Mn3r6ORkPn31MI2H063uQo/a6MZoL1O44JUWYqFcA0ahu0xs937jYckqXVn+EJf
    W4l6qBkcjvUZDwBfv9YOMSQ61tH9+PwIhnooeSAL6v6dXt+KwwPqhtp9CBSA
X-ME-Proxy: <xmx:KTFOan7ZHPKyZ59InW2tWPhNSJB4UVtarGoW57nl_XC3CEWDxuV2dw>
    <xmx:KTFOalEhoJR-N4R21fqud-V67xdqnUq0IEe_hg3QcmjaI3k4e6urFw>
    <xmx:KTFOalwHEhr-xfnltqGCeR6Fk6hbGuZ1Q-s4iuJBoiR83Un-x8Ts7A>
    <xmx:KTFOal3wCi3fl_DZ4bx8f6XrWwmGDbGH9RgxkOEkXZsK0E1651Jtug>
    <xmx:KTFOaq1i1P0RwLQHPnX2tSFKvS6ORZjl87NiJGzWSuWriagjrDksNT8M>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:49 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v10 12/15] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Wed,  8 Jul 2026 12:14:13 +0100
Message-ID: <20260708111417.173443-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h5jdzs8s45pezrb59c84pn95esmsyk8g
X-Rspamd-Queue-Id: 4A77EC0006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783509291-411800
X-HE-Meta: U2FsdGVkX1+AFuQWSduOnPj7kZlf51bg4ln10zF4LK/MTzDoWM2SbEpzG1IxvUId7wTmQ7gtGQz0f0LpY7KUt3cF18nYhbdeOfpwPUf2Je4WCmAgv2xSAOJF1ZNWwpntGgixXR6+4O5ixkId99yF8bC1RIhWPi1bhkC9AnBdcgfRXW7cz0jAgSbeQmhe4VTX5IzjfryW9cRVjrAFGKmyv46zAEwEn0YYBeVMbWjrnrOPAnYvtH/q7Eqr+sfVCmxkMnEL51LdS6bQoLywZkitT/C3ZuqxM4flroXQvGBB1MFejO8A2kLC07Deq5PwyASmKtmCZOlxNXbNwtwBRGOEJe+LhPPn4wM3X28dCbnHPKHFufpCCcbd/r9nYZ62lpxMR6jEiiVRYx/Nsr5XYQPihk+opPnBcOTzer47lC0UWUzEl98WgD/NyAxyduWn19vqxnc73xJ4Bct7j2wECojwNXJQbKE1MkOZptULwqzUeVOXz8/E0hTsb1JyTZzyMTjWdizcgvgidtfDAj1DysA0EItDTMceHnVQ66XbOlse6i0If7XDyN/LCusYXC9CNWBKP4QEE9D4dw+1y4bIXXljnfuzWF1pw4jQFq7CaJ9zYwef+/SjOwYfrhccFvnHUqyZD2FpE+/xReUc917aw4S572n8rTY0ZShDDBX6j5A5jDZFOfuXkG0xufNscHCz52mInEeQsgF2QHyz6FdtxgqP4GFLusTPX+XB2VJL6oEBK3xZqr/h+21OQRA5cxTTkUZLyZZtmG8CG4ZSKz8vnYaTtit4+k66l5Con8KpomfcslTkukZaprCBn1TS68gogzcQSI4if/fZSoG8pxvk+9mGtHTA6n9RPvzKiNvSL0vGvNU3i5uAkQvki7QLAIvCSDdYaUKoYEzMqrT0pBC9Y0h/S3oNCBBVgnmgL52y7cQ4srZOzrVnmoisWPb1sajvTCVk5W6ecb9wIK02Kjy/SpJ
 bDMvW7pF
 VgGP1ScEmlTkLIoiMCBhiuqlwV5M88nwf0EyxqZlT/d5BJuaYicknpfpWM0ruD+d0rtpvmQ9lD/6gDtZY0qbRUYZG+li46qV/zLLpemSM+dm2KPnDEMuh/C9sgyzLxJ9Suhs4i4QjMDYJNCZbryaXdfKlgLnKiGI95wCTpOVZCF2trRo7lhCeJyrVoVfWaYaqYaQCbmudOJ2abs4pMKpbAadRYdcMjT/tnozjRwZcjjxzTfTagk6yi3m6rkHhbUx6x03xVzcKi6hPuThNUlEqm1wB9izziHBSzd23r3MrCjhrMjLnil64HZ+AgQu+6O/oRjIzbW46k7Y5QVrZ7khFOw1bfD6es+VIcvCRFEdC9uBSi16vqpbio5wyP9HZyL9C/Qqk6/WQzILHkzMdscpbxALmX6N1jBGUls3pzCBPib/sLqiXVR6oGlhrsL0LtU5MItXW7I1jKV2OZcgYIdl7HGjxGx11943E+a84dZqF354lSLdIuMSq1TmW0eT0vZnPIBVmCVSJf/OD4TxXbhGqtTonT6YzJEELy89uKIex7IwqiZeVMqgsNp/BmqvVKpancdL0VoFpV3EjxPJkFY//3QW4drIHpY3Y4iIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Sync RWP delivers a message and blocks the faulting thread until the
handler resolves the fault. For working-set tracking the VMM does not
need the message: it just needs to know, at scan time, which pages
were touched. Async RWP serves that use case — the kernel restores
access in-place and the faulting thread continues without blocking.

The VMM reconstructs the access pattern after the fact via
PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.

Worth calling out: async resolution upgrades writable private anon
PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
do_numa_page(). Without it, every re-access of an RWP'd writable page
would COW-fault a second time.

UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h    |  6 ++++++
 include/uapi/linux/userfaultfd.h | 11 ++++++++++-
 mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
 mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
 mm/memory.c                      | 27 +++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 19 ++++++++++++++++++-
 6 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 6f7245609bd4..bfbd6a59909f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -286,6 +286,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -464,6 +465,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d803e76d47ad..c10f08f8a618 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -44,7 +44,8 @@
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
 			   UFFD_FEATURE_MOVE |			\
-			   UFFD_FEATURE_RWP)
+			   UFFD_FEATURE_RWP |			\
+			   UFFD_FEATURE_RWP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -243,6 +244,13 @@ struct uffdio_api {
 	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
 	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
 	 * are delivered when the pages are re-accessed.
+	 *
+	 * UFFD_FEATURE_RWP_ASYNC indicates asynchronous mode for
+	 * UFFDIO_REGISTER_MODE_RWP.  When set, faults on read-write
+	 * protected pages are auto-resolved by the kernel (PTE
+	 * permissions restored immediately) without delivering a message
+	 * to the userfaultfd handler.  Use PAGEMAP_SCAN with inverted
+	 * PAGE_IS_ACCESSED to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -262,6 +270,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
 #define UFFD_FEATURE_RWP			(1<<17)
+#define UFFD_FEATURE_RWP_ASYNC			(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5dc9654ed030..25612af72dca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2204,7 +2204,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
 vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 {
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd;
+
+	if (!userfaultfd_rwp_async(vma))
+		return handle_userfault(vmf, VM_UFFD_RWP);
+
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
+	pmd = pmd_modify(vmf->orig_pmd, vma->vm_page_prot);
+	/* pmd_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pmd = pmd_clear_uffd(pmd);
+	pmd = pmd_mkyoung(pmd);
+	if (!pmd_write(pmd) &&
+	    vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		pmd = pmd_mkwrite(pmd, vma);
+	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
+		   vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	return 0;
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 546e23d7a8af..3a75f159b3bc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6113,7 +6113,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
 	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
-		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+		spinlock_t *ptl;
+		pte_t pte;
+
+		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
+		if (!userfaultfd_rwp_async(vma))
+			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+
+		ptl = huge_pte_lock(h, mm, vmf.pte);
+		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+			unsigned int shift = huge_page_shift(h);
+
+			pte = huge_pte_modify(pte, vma->vm_page_prot);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			pte = huge_pte_clear_uffd(pte);
+			pte = pte_mkyoung(pte);
+			/*
+			 * Unlike do_uffd_rwp(), do not upgrade to writable
+			 * here. Hugetlb lacks a can_change_huge_pte_writable()
+			 * equivalent, so a write access will take a separate
+			 * COW fault — acceptable for the rare private hugetlb
+			 * case.
+			 */
+			set_huge_pte_at(mm, vmf.address, vmf.pte, pte,
+					huge_page_size(h));
+			update_mmu_cache(vma, vmf.address, vmf.pte);
+		}
+		spin_unlock(ptl);
+		ret = 0;
+		goto out_mutex;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index f668e47f8575..39bb6bd3e44d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6146,8 +6146,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
 static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
 {
-	pte_unmap(vmf->pte);
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	pte_t pte;
+
+	if (!userfaultfd_rwp_async(vmf->vma)) {
+		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
+		pte_unmap(vmf->pte);
+		return handle_userfault(vmf, VM_UFFD_RWP);
+	}
+
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(vmf->orig_pte, vmf->vma->vm_page_prot);
+	/* pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pte = pte_clear_uffd(pte);
+	pte = pte_mkyoung(pte);
+	if (!pte_write(pte) &&
+	    vma_wants_manual_pte_write_upgrade(vmf->vma) &&
+	    can_change_pte_writable(vmf->vma, vmf->address, pte))
+		pte = pte_mkwrite(pte, vmf->vma);
+	set_pte_at(vmf->vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 994de4c09d2b..3c887aaa1056 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2496,6 +2496,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
 }
 
+static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
+{
+	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+}
+
 /*
  * Whether WP_UNPOPULATED is enabled on the uffd context.  It is only
  * meaningful when userfaultfd_wp()==true on the vma and when it's
@@ -4428,6 +4433,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
 }
 
+bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -4531,6 +4541,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (features & UFFD_FEATURE_WP_ASYNC)
 		features |= UFFD_FEATURE_WP_UNPOPULATED;
 
+	ret = -EINVAL;
+	/* RWP_ASYNC requires RWP */
+	if ((features & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(features & UFFD_FEATURE_RWP))
+		goto err_out;
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
@@ -4553,7 +4569,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	 * but not actually usable.
 	 */
 	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_RWP;
+		uffdio_api.features &=
+			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


