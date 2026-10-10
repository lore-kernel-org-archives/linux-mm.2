Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252ADCA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F9B6B0088; Sat, 10 Oct 2026 05:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0C96B008A; Sat, 10 Oct 2026 05:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7166B008C; Sat, 10 Oct 2026 05:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7282C6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:24:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4EF480679
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:24:07 +0000 (UTC)
X-FDA: 85306180134.14.8E15DA0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id DDB5F160007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:24:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791624245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CO9waEwqMUpaZPZgtJepKttdFvYPEnFhz4OQCRt/cfI=;
	b=EPrGZRpcJwQdET/9sjkOU2E+z+v01QYXsl5nBB/wy//2FPFPWtVMKnz7Kt1VQrqhl+rpnU
	ZlIf8svbTzFkwpiOArr3ITM4uM/FxdD69IvbRumwBuisCu0WpfZ3PHieru0zCJ8fN6Q6Yw
	uBDcUn7AxlqiNBvwVJScSA5I5iBBvmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791624245;
	b=Ia96UmtaJhfYUwsau1bqYeDxqsw7q/elbdJlGOS10fMySManyy9MBj2qZXmP4x/wrF1s7v
	mkpa1kt15GgSVqKmHtRj78whRiAPZ+f87QctyRW+o5OA8rlC4Ra2l6K1Gso55Fz1VErL+z
	O99YpocPzVsm42h2yckRJDAxRscKSyY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 4f5c0344c48c11f19a56ed5b684f684d-20261010
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ad772735-1f7a-40d0-ad08-0d69d74ccf59,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:ad772735-1f7a-40d0-ad08-0d69d74ccf59,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:c47000b8d394fca402bde1eecf566a7a,BulkI
	D:2610101723583KR7SIN1,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4f5c0344c48c11f19a56ed5b684f684d-20261010
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1535828320; Sat, 10 Oct 2026 17:23:53 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb: prefix log messages via pr_fmt
Date: Sat, 10 Oct 2026 17:23:33 +0800
Message-ID: <20261010092333.137126-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDB5F160007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6gkz81f3ikt9jpy8h9ud1p6yqtfuapne
X-HE-Tag: 1791624243-975336
X-HE-Meta: U2FsdGVkX1+C0c5SpRqw9OLp2O7blgc01VjWjUwUly6k6CKbbJeKBztSO4DZBNkZU4yT8cVoprUkIrEFNdkBAztNF6HLaXMPVkRv4XjfRoaM8V5719OLXGZSwqwsHx6yi5XfZL/R5Iv9nrC61/Qpzj2pM/zx7y569Lz8g7P9j8krQ9fZr57RDXzE1CYLMU3SO1YtcjPH4/UtD/05N3yuhBMzYxD17zDdoMjtCAs+WbYsfUHxaldLPEb9G8IzsbDU0nB+e/ge2ehKi8TGe9fjgLUQFPwxLFrfMV3F2Ks6h8Ia9rxn5ovad9q7oDt1zS6kWxzLoeoSCi1vmj6mCZpi2/M4U3+tqVlgjiXgKoyRwR00JLQfiG3ZnXbqG837LeMxM31w48nV00DpLwxVTAG14r00ZbpPQlTfspeNgL7aO/Cb+8Wn5Y8+xiODzX9CFaQqXVEE7UShrpEa0n72Aby/naMMISV3Q/wtXwyRtn1kkSJ6c9om7VetwUN1zale8FJYU0y7cSs4IXULyQZaMrp27hrKbjirLXlTKdnANesfI+PaCsRn773TdftNQszHMY9XvCrOD/u1wvzzIJq62XCvlJK5H/oZx25HEwX1iOfQ8utRiyzvpc4SjGgRKKKpcikIc2yfDrTYCJ0N/NKLOOE1I5ESD61AldrDXD9gWkP2ghAOLRAhlSNalpzolQG3aT10BXedNHo47cGWE3arzpJxLwkJQIDtsDRrCSKen24X/FMDqMOqi11zdCbyXGnfVsSM4iWqPD+Eq0Og/asTYn6SwcfRJRAKkk1ofzfhm6lkTXAlFaMpK4YEbWLOAy5+1xndNShqa5ZpwPpY4tPvhQKRIxYPBATXAkBwxhlQNnQ7dxm7DPJi2vcypz7qsLDpmIkdCgpvr9peoCj7GFdYy+nn1J208ezxfGzH7gyhTs1Bq3ssH8EM++aPf7uYxoz6n1tD9EHOAdrRkn9P9Fr4GRt
 CgjeCqsK
 3eMoFx3a1ZwHLd6IOU5Bt+JDCNgBxSbYSjHkv0zHfOfQdIw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pretty much every pr_* message in this file starts with "HugeTLB: ",
typed out by hand, and one of them even drifted to lowercase ("hugetlb:").
hugetlb_vmemmap.c already handles this with pr_fmt, so let's do the same
here instead of repeating the prefix over and over.

The output stays the same for almost everything; the only tweaks are that
the lowercase message now matches the others, and the ratelimited "killed
due to inadequate hugepage pool" warning picks up the prefix like
everything else.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb.c | 52 +++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7b7410bc6916..63dc836061c9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3,6 +3,8 @@
  * Generic hugetlb support.
  * (C) Nadia Yvette Chambers, April 2004
  */
+#define pr_fmt(fmt)	"HugeTLB: " fmt
+
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -458,7 +460,7 @@ static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
 		 * until the file is removed.  Warn in the unlikely case of
 		 * allocation failure.
 		 */
-		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
+		pr_warn_once("unable to allocate vma specific lock\n");
 		return;
 	}
 
@@ -987,7 +989,7 @@ void hugetlb_fix_reserve_counts(struct inode *inode)
 	}
 
 	if (!reserved)
-		pr_warn("hugetlb: Huge Page Reserved count may go negative.\n");
+		pr_warn("Huge Page Reserved count may go negative.\n");
 }
 
 /*
@@ -3419,7 +3421,7 @@ static unsigned long __init hugetlb_free_cross_zone_pages(struct hstate *h, int
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
-		pr_warn("HugeTLB: freed %lu cross-zone hugepages of size %s on node %d.\n",
+		pr_warn("freed %lu cross-zone hugepages of size %s on node %d.\n",
 			freed, buf, nid);
 	}
 
@@ -3465,7 +3467,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 		return;
 
 	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-	pr_warn("HugeTLB: allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
+	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
 	h->max_huge_pages_node[nid] = i;
@@ -3492,7 +3494,7 @@ static void __init hugetlb_hstate_alloc_pages_errcheck(unsigned long allocated,
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
+		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
 	}
@@ -3607,7 +3609,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 
 	jiffies_end = jiffies;
 
-	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
+	pr_info("allocation took %dms with hugepage_allocation_threads=%ld\n",
 		jiffies_to_msecs(jiffies_end - jiffies_start),
 		hugepage_allocation_threads);
 
@@ -3635,7 +3637,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 	 */
 	if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
 	    !hugetlb_early_cma(h)) {
-		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
+		pr_warn_once("hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
 	}
 
@@ -3703,9 +3705,9 @@ static void __init report_hugepages(void)
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
+		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
-		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
+		pr_info("%d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
 }
@@ -4045,7 +4047,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 
 	/* We should never get here if no demote order */
 	if (!src->demote_order) {
-		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
+		pr_warn("NULL demote order passed to demote_pool_huge_page.\n");
 		return -EINVAL;		/* internal error */
 	}
 	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
@@ -4190,7 +4192,7 @@ static int __init hugetlb_init(void)
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
-			pr_warn("HugeTLB: huge pages not supported, ignoring associated command-line parameters\n");
+			pr_warn("huge pages not supported, ignoring associated command-line parameters\n");
 		return 0;
 	}
 
@@ -4215,9 +4217,9 @@ static int __init hugetlb_init(void)
 
 				string_get_size(huge_page_size(&default_hstate),
 					1, STRING_UNITS_2, buf, 32);
-				pr_warn("HugeTLB: Ignoring hugepages=%lu associated with %s page size\n",
+				pr_warn("Ignoring hugepages=%lu associated with %s page size\n",
 					default_hstate.max_huge_pages, buf);
-				pr_warn("HugeTLB: Using hugepages=%lu for number of default huge pages\n",
+				pr_warn("Using hugepages=%lu for number of default huge pages\n",
 					default_hstate_max_huge_pages);
 			}
 			default_hstate.max_huge_pages =
@@ -4357,12 +4359,12 @@ static int __init hugepages_setup(char *s)
 	char *p = s;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
+		pr_warn("hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
 		return 0;
 	}
 
 	if (!parsed_valid_hugepagesz) {
-		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
+		pr_warn("hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
 		return -EINVAL;
 	}
@@ -4379,7 +4381,7 @@ static int __init hugepages_setup(char *s)
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
+		pr_warn("hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
 		return 1;
 	}
 
@@ -4390,7 +4392,7 @@ static int __init hugepages_setup(char *s)
 		/* Parameter is node format */
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
-				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
+				pr_warn("architecture can't support node specific alloc, ignoring!\n");
 				return 1;
 			}
 			if (tmp >= MAX_NUMNODES || !node_online(tmp))
@@ -4423,7 +4425,7 @@ static int __init hugepages_setup(char *s)
 	return 0;
 
 invalid:
-	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
+	pr_warn("Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
 	return -EINVAL;
 }
@@ -4442,7 +4444,7 @@ static int __init hugepagesz_setup(char *s)
 	struct hstate *h;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
+		pr_warn("hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
 		return 0;
 	}
 
@@ -4450,7 +4452,7 @@ static int __init hugepagesz_setup(char *s)
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
+		pr_err("unsupported hugepagesz=%s\n", s);
 		return -EINVAL;
 	}
 
@@ -4465,7 +4467,7 @@ static int __init hugepagesz_setup(char *s)
 		 */
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
-			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
+			pr_warn("hugepagesz=%s specified twice, ignoring\n", s);
 			return -EINVAL;
 		}
 
@@ -4495,21 +4497,21 @@ static int __init default_hugepagesz_setup(char *s)
 	int i;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
+		pr_warn("hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
 			s);
 		return 0;
 	}
 
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
-		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
+		pr_err("default_hugepagesz previously specified, ignoring %s\n", s);
 		return -EINVAL;
 	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
+		pr_err("unsupported default_hugepagesz=%s\n", s);
 		return -EINVAL;
 	}
 
@@ -4774,7 +4776,7 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 				vma->vm_private_data = NULL;
 				hugetlb_vma_lock_alloc(vma);
 			} else {
-				pr_warn("HugeTLB: vma_lock already exists in %s.\n", __func__);
+				pr_warn("vma_lock already exists in %s.\n", __func__);
 			}
 		} else {
 			hugetlb_vma_lock_alloc(vma);

base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.55.0


