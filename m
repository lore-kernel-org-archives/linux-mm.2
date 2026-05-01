Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D74CCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D126B6B009E; Fri,  1 May 2026 15:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3366B009F; Fri,  1 May 2026 15:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C004D6B00A0; Fri,  1 May 2026 15:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B303B6B009E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A98187E95
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:35 +0000 (UTC)
X-FDA: 84719817630.27.DB3DF92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78C12C0010
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dCNYKW/r";
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIFo0ncNVscrQBUDwO88EyFcNSwZmzv9OtuTCZgG/qA=;
	b=0Y3xE7JxoRF6jK4MFMovS1hix4Rm2IdRFdAhzKg9OyumP4gBag94oyFD7QgH8I0Q872WvV
	LW0ehlVBT5bgMYxh/OAs3V4/NVRahu0JWvaKG2P9CTSwte5mQOx9QvWL1B7cidsrjO8+eZ
	5ZF5olzh9E3pBA1gyAOaI+qUbxl1hCE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dCNYKW/r";
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663233; a=rsa-sha256;
	cv=none;
	b=CorhaN59tmZjnrTfdA7c+K4rUzPZuUXJ5MPRGjqhyxQrqFlwf+tD+9KlaUqycRMMSDLxCF
	SNyvzP+K5WXlo+Q1EqxFAQdkRIb4OYe6l7zxbIxfnxzfHnIzbst0oCz0TXHa1zvLPxmLcn
	IwJWtNkt6B5HaKVctMlHH+YizeXWlS4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIFo0ncNVscrQBUDwO88EyFcNSwZmzv9OtuTCZgG/qA=;
	b=dCNYKW/rpXzb0D0bf6CC3Yt6r7Ml5PRao37t+7gmACvI6oRemOExdH49sQrTxX+N/LqW/j
	nuLgn2CgYtM8WgDC4YTm5dsgeZOTMBDRbjvd+ZClELONG0eUWsm4YZ8DOtbXb5rz9T9lO/
	VIyQMA3fOj5x870fFo/Ob+tDmEp/EAY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-10OX0OkDPp6iQ2ERQs7qFA-1; Fri,
 01 May 2026 15:20:26 -0400
X-MC-Unique: 10OX0OkDPp6iQ2ERQs7qFA-1
X-Mimecast-MFC-AGG-ID: 10OX0OkDPp6iQ2ERQs7qFA_1777663223
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B80B8180034B;
	Fri,  1 May 2026 19:20:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E481D1800906;
	Fri,  1 May 2026 19:20:20 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 8/9] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:50 -0400
Message-ID: <d4fbc41a51f8fe9ab55cc6792d60c6c2c504b4d4.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: H3I-NUAlnhZBcWaX9kvbuV7MYKaVXi8PC0w-Hv6VoDw_1777663223
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78C12C0010
X-Stat-Signature: 8odgezmwop7wt5kx3yf6sdjkk5szxggk
X-HE-Tag: 1777663233-487084
X-HE-Meta: U2FsdGVkX18owgrnNhapKmCSMPvxeMGILADR0BkLM8f/BXfcng/l/HjMzMpYfq8cjsluiBSAY51lsYPgu1FzgGW4qtzgXlVjCWvi9wYZeAm57wkRqk7ZSaEA/0GV7RFnQbPFF3k7i5OhE1j/Ij4hpQyB3vWWfRSHkKm7vtvDUwQJ9rHilGCMPpQ4SA9dlU2ZMbeK6qbk7kU7WSwYsyBkKONEEPsKmC9LvqRqL5xiKh26qiRFr4bmJo9A9SbxHPfYRyx5+5sgkh9ZChhY04yhqvx5cOzKRvxKHCrgeKsWWmnXKyPkG8bjlA+62UM4qHekY+Y/HdrIMrycDPbk3Qthh4pxhWKd5w6F6727sUWFBx9GMKT8branROcHKhrqfPdKITpgbZ1xIFF9X3fR/lbaG6x+F2HmkL5cnm9HI4wvRdFM4TmKhtAVAQDiXK50m3hJkP7PMZ8nXxMjnxZl1BZ51dbi8VdaRCXGBmXlltL6IvaVutHoFq86Kbrq0YHzXd43ps6axqExpptOLokQMAsKK2BdO6GZkI6vwTRO7BAUbtIHFhbD33JsVAZQUJFwOkD7aC0YzSo6vtf9070/C6F00TNSixHz4063pf+cb2DnoUi5mGZ01BPFgBPZbs04+bCvfLaYL4BhLXmWF35F9Tk8ekjXYFLJ2YF4ywbacCiTvv2BKJYCmSvQRihpJS9vts6+D0szTEWxyhC0d4zvgOnn7G/BuO4buZlLOmhoAic12KGOyC5cIMdljf5JksyNi8AMAjZa6QDzUsKJ5wQVziYmT0IPzc6oNJ/zZozb/qejdGlhd4CFgnHW2/ChqgWoRvh6f9jgzVhHQ1qlooSo02oBJsr+aEYJcnuawXuXQ4RdEG/NeOFRt3ktRwVrMVHVhgNN/lPAV5z18ecZzLzFh6O8wnk2WjucSovet49Yj4A5UiNdJ51CJ7CFrsBXZPPKRUlLul1uSGsni7LdS6GVd4r
 aT/Hd7lo
 JHTo0HL8Kv47/kvd+sJrrcOKrmIBgLOc8SKxWWqCS+vYgJ5aWBy2wNSZOKv18Gsc+Vs8fuOign/ccUWUrCUhKZUz28oVMiCGZO1oqRHt7RIH2PxUcREQjzPtxqge5gtuAItv40o62Oe4pGGFjV6k3XW0vLQrdPRXDEeJk/oy3mt2tt2iL0Yyu943uLLyT58q8+dZxxUBejYRPmP098cgK+VoxXifAPvmCCHa0H1B6Ut7/RPbfaeJtrFY2/xp0ISP4gX80TrP2yafEQ7DA+j41HZrb7eyoUaL7tooUOO7MAkrFQzjrLFOxPJXKy3zRtsdRR17p7HpNXkaPn3t8GbBcteThoPaBPk4inSL5HQxBFy9H6l6uCu7A79zp6icgwM5YzwFUCBLu5XFILDKnQ7ycfwmNsbNLMkAqQK1wdRlbjuBTC7OjyEfKL7feCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite its name, thp_disabled_by_hw() just checks whether the
architecture supports PMD-sized pages. It returns true when
TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
this only occurs if the architecture implements arch_has_pmd_leaves()
and that function returns false.

Since pgtable_has_pmd_leaves() provides the same semantics, use it
instead.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..da048aa06761 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -352,12 +351,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
-static inline bool thp_disabled_by_hw(void)
-{
-	/* If the hardware/firmware marked hugepage support disabled. */
-	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
-}
-
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4da10e94bbb6..32254febe097 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -133,7 +133,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -969,10 +969,8 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!arch_has_pmd_leaves()) {
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
+	if (!pgtable_has_pmd_leaves())
 		return -EINVAL;
-	}
 
 	/*
 	 * hugepages can't be allocated by the buddy allocator
diff --git a/mm/memory.c b/mm/memory.c
index c62fce83b8d0..483af476d9b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5522,7 +5522,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 1948d73fb1e3..a48f034830cd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1842,7 +1842,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.53.0


