Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FC5C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953626B00D6; Mon, 31 Aug 2026 23:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCB06B00D8; Mon, 31 Aug 2026 23:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E7E6B00D9; Mon, 31 Aug 2026 23:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0866B00D6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0D7FA3851
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:42 +0000 (UTC)
X-FDA: 85163723484.23.61C5FEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id CEE5516000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IparpftD;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232420;
	b=3ajRUnQoduzVbQJw4LFDR5hsqOGtXmRpVOw0+bXQRStj2bFN/XiSCPeqdcLrbC8+7XZmfK
	rXirtcMQYUoDM/85mfKdieY++B5mhBUM3rX4iLuj6L75pyEoIXbE+IcfQB5poykhwx4oHo
	QGG3ikUYAtVAysvAzaB+qlYxwnR8wTI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IparpftD;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfgDDE8CEmW1Q+z8UseKVnUMAM5pqEP/DOHTfkRU7Ug=;
	b=rtue8tmiIINReWwRWMA6ZY3eSokClSxXIHpX5KTEv/97JAB334o6n/sR/BMgSHB3A2vSDQ
	tUFBvQCsjLilCCWAda67XOXXGp81eTKO4vCrJsF67vwnCRF+nC5KKxyXm2+RNAJ15LGjq4
	9pYYh4No1MjFQjU8xwydfdShwmXtpq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfgDDE8CEmW1Q+z8UseKVnUMAM5pqEP/DOHTfkRU7Ug=;
	b=IparpftDRcfLS5Y9CINNx59O/ZK1Tz4KY4NX9PMmGfJSu/tLptTd0+V58E6bThr3qwvE2s
	tbvB1QnJseqU8ogwkHNU8SxxYWFpzWp8gNqGRwa12fbbvDZImcw7F+SvmdII4Y0bDzICqJ
	RLMtK63BaRJ5bCTvo3H/voNtowUVrq0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-6imlDJqgPaWD4O50xf4G0g-1; Mon,
 31 Aug 2026 23:13:36 -0400
X-MC-Unique: 6imlDJqgPaWD4O50xf4G0g-1
X-Mimecast-MFC-AGG-ID: 6imlDJqgPaWD4O50xf4G0g_1788232412
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75CD218345AD;
	Tue,  1 Sep 2026 03:13:32 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF52518005B8;
	Tue,  1 Sep 2026 03:13:28 +0000 (UTC)
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
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 13/14] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:17 -0400
Message-ID: <aff69c99f6679c4933103b86c0e3dbe19dc6ce05.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: YTyKP_HRdjEEg1yVJadvBQHMKLWkEGAiEAuEvrz66rY_1788232412
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEE5516000B
X-Stat-Signature: io7ksrc175pche1unjxfedmox1g93xxk
X-HE-Tag: 1788232420-985625
X-HE-Meta: U2FsdGVkX18i/ITfgShMUA6pPQ94mFt7ksfD8O0dreyG3HAzRbPULttIDGBUX4FLedFwzp/YOJXoUKXvZh1xBRgejejv0FosvNZeRzzn6PsBCSM9lKEVQ8LnhhqfsEzL8HBWerkuuCXTG46A/9VxeSxsNK/yJ5T/dAsng4xZ/aSBYyagIss+6U9O+dXxWB0IktnbO47lHtd5n8DPpANtd375XjazuRrcTwi8aqUSJC5WYpLisut89YQ97cbPs5nLRVB65OQkYuyeN5SPC2FtFaEZ6nj7IkuorEP3EkfYUBLYJgclMZXJND4MB2oTc7ArhAkDu9WkKefG7rMXx6UV7nbbKv3D2L74UAy+/lBXgGXZsjCdbiYVwJkwIkvyl2l+yta2/JCHfxmBg1aQpYa2aQM2q86SG///odOLcnS2l1/l7jMJaFoMsPVMuPAFUGAJARmdXzv5s20pL93FOkKOBw1sJnDfGFWr3iVEWkw3JpEERfHSk1nWP01aNa+YRSrpXV9cFsEwiOWCgPe3bfo3lF/Bv+0OmcEJ119YqsNR43vJCqlnfdTo0nXMwXt7/oNBk1JW7+j4HFtYTMOgo1cyPG8xoeyQL4XDfu3b66a0dGssJPp2fAip6KIaKjZgRuZAZWyszHz1WAMzS9jiN8WcAeGZjKX5CM9mlabKszHHGZ37WQhAIsy0+1hfA7FLcK5ZtepG005qYab7ku/R5c0bP5yqUj8N4E///o1v2FGLb/wVVRR3FlsZYW+SLyGX2SRF/u1URdHnLUWg2Q3cxs90zJ1QjJ5/5D/JbqrtsTd3/lisTywIxUOMdO/Y7R9xF4b4V3S7q4EARDdaobpEX133qpphOSMkuAIEcrClL2233zddLUNFa1nC//vr4B6ChUtxExidXrLPIOoDc4XicO3bZeNpgo06Y1E4o2QJ/ljRESrkiqLh5ltS2aa3Ayjl+fMasgAnlpxazNtDJEJB534
 KZptt7Pj
 o2oMElmA4CfJAe/Sj/xTRVyjHzKjLqNZcxqICm9WIoZyCvl4T1S/IJTQiyq4I6mlEm6VTGXbAwYoFvODK9vFqdtVwyh16ucwu614J7trwboCZEDc5QSxRbUjUGZteRq3ueJs9/88JlmjswJbyO0zQapu1SD7rMc6qdoVbS2EKNkwU254iO4mGadAaNiIxbo4KU/3NTtIb/JZOxtAdcvXrec70l+hrM1Gkcer5TZrXZtXRb1FdORsDKM8fE0JhPXOTSQ/rEblGoqcc4KuS7CwdmhIcDDIYzo6wyDqNDv3ol4gLFqcsjjVIyzMozwbwdZwqF2QqBFfdn8n42XnUKGxADHWyPoqjFKPeFZlJLl9DwR95wDkFPr9KVO31RwyxeaA7KjG98V5W8pkBQjNdt3NZkZyAOsjlLKx3zcnd4MlpJLldyI44dG2tesfe8e/vyaCX9mKo9xWYCmtsvhP7CCVGMy2/nA==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..525acea2eb59 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -383,12 +382,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
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
 unsigned long thp_get_unmapped_area_vmaflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 469d98e01b5f..d5e65cac6a16 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -204,7 +204,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -1095,10 +1095,8 @@ static int __init hugepage_init(void)
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
index ed5029745dfb..6be55fc39383 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5611,7 +5611,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index c285cb7fd32e..73281fa060ed 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2047,7 +2047,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.55.0


