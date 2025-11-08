Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E372ACCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 19:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF958E000F; Sat,  8 Nov 2025 14:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFA08E0003; Sat,  8 Nov 2025 14:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09EE48E000F; Sat,  8 Nov 2025 14:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E60658E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 14:20:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8001A12D22A
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:20:56 +0000 (UTC)
X-FDA: 84088407312.10.14785AE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7381AC0005
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:20:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gy0DfapY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762629654; a=rsa-sha256;
	cv=none;
	b=Tq3TBLMBaqbXn+9HLRe3zC76O/zTJeNIg3PuRpf5c6wZuJKCOVCg+Esh/u90tgHdxWFqWR
	/Wp6qAO+k+bY0ZDHBR95pym0wzjSMVhB9lP6jiBHs2mtob9AIY5wyCr4OwVnSuXKxSNM29
	3111ra2WF/HuJ/q0XCniq0YGLGnMnvw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gy0DfapY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762629654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6aeQb1DWwKh9q0A988WnunX6ASTyvLF65eSlmDdPkY=;
	b=c9A8jwdz8N9jzvr3cv600cGJujj1U9IvWh2PZzNdGmuv2HueRM0H+qo7odtOjWmOhFHRGg
	YX2sDuXCP+ue9pmcZfI2OBIZFJh8aqauQ6FYewHPBG0RAwFNLbu9pTo0rpVjrlDZzEJqJm
	LQprQksQxYKbNFFIyxYM66IBMoU1SWY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8CN5sv021288;
	Sat, 8 Nov 2025 19:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=R6aeQb1DWwKh9q0A9
	88WnunX6ASTyvLF65eSlmDdPkY=; b=Gy0DfapYgtDTuRypTCHrLjflWhgUSwbd7
	7nzMpOIwXwLC8shQih48AucxK1cP0YGsHyL8XY5n6MztEMY2noCPiPuh49ZbadzW
	4uWwAxtHLuUJuSw6PZwY6BsAtzOw+hhryeVoQS/St7aEfbdhnVQZzyNCzzdqnOeN
	5J8CyAQDB/++rkq9fJJUXA4eYnqfdYEuhieEbyh6utvZmi6XwSU9SrSewQ5ue9XX
	aKWRTooBtrvbsQR1jtDKyZVlIKmnMD+3y303Y4FQBzzFm9nIk1gz+WcuNHTsRNHo
	fZp/cq0Bg8Go1fWQMm1OGqWW0iPczhjA6IhHH6rmY2cpi3pm7QnwA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjgv62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 08 Nov 2025 19:20:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8I41sp021491;
	Sat, 8 Nov 2025 19:20:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrk802x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 08 Nov 2025 19:20:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A8JKkPE54395318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 8 Nov 2025 19:20:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4833D20043;
	Sat,  8 Nov 2025 19:20:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2986A20040;
	Sat,  8 Nov 2025 19:20:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat,  8 Nov 2025 19:20:46 +0000 (GMT)
From: Jan Polensky <japo@linux.ibm.com>
To: catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, david@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        will@kernel.org
Subject: [PATCH] mm/huge_memory: initialise the tags of the huge zero folio
Date: Sat,  8 Nov 2025 20:19:47 +0100
Message-ID: <20251108191948.684586-1-japo@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031170133.280742-1-catalin.marinas@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b3mCt8QQvAzP0MnNqKgGftHnBTK4IgMm
X-Proofpoint-ORIG-GUID: b3mCt8QQvAzP0MnNqKgGftHnBTK4IgMm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX5KEPNLD2szB6
 QM6UCsOSYijGIiQr4dlgLq4yblKBNNKg7xH3Y3k/r7vf5XWzP73UnBZYpe4vjUcVRaEW7Jsd5YJ
 xTW90ptfJKiyoqOYhQHvFcSXhD8hE0iXqA0PQuk4+I0JXsJJaSMgOlDWsYFGkjf/U5GbWQBXgjF
 iNooh/WCBa3V3Y3saw8NtMQw1IIddvhVIna85ntbjbtqBofikwoqejqtO1eK+oSz5x0yr18nmiR
 GNCwUOTbEe6fRIfu45al4Vr0Td6kDCKMmtUdp2ni8YfSXxcokrGRT7+2p4iqMV1ruI3e782YAqP
 G4O+jUIDJ88VEm/M12M1D/gEGqKPdtGJA3UHIpA1iM7CglcdPDBvRP0l8UUgDh6QvojwoPupe6h
 xwaP3VqH4hB2NB9qt1kNGUco01uRZw==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=690f9810 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=VnNF1IyMAAAA:8 a=GRmcs_4ORcCTOOSj304A:9
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7381AC0005
X-Stat-Signature: xb78eat9opgci47oamdw8pdtchuo8rox
X-Rspam-User: 
X-HE-Tag: 1762629654-609283
X-HE-Meta: U2FsdGVkX19erkZfQOX23Z2i4YONbA5zkQTWPQgnZitTW3jaVyWZsECxIxTdCe+WD0/Y3z7Bo7YDixGyZ/cfNRxb44bMyhtAw8fF2U4PTjVH0ViuszTLHO/nawQcQNNWB5upMwF0Z6gRJMFQSvdYllwd3zJse8lVdZsnCjI3Z9yfmRvkW3rUmJsZ6yZ1u8CUQzjWJF+rI3mjQ6BvmR5CVK4o9MqRZWAX4OsJOgCxSWsB2FCx+PcurECS8JsDgC/m8bvqz9NFSCCDa0X7Zye+m7D4vMjZ2WCuM30xfG9mBUUQmF+I0BfZdqQJBN44Egaxvxb4dDQQ5uE7YHNvfMipFsQ2RzI4wswQLsFOBbQZJ6C4/mm4PX1rjkD7l7tVya5huSgkDDGhgoS9L45VJONidglvI8UqGRgqaRnkaP65K+btx9D7hMzNQc6DkW8KiGRjT/sFQdiwVw126KQEqe/U/H6DTBAaodZguEdFRoklnb2sra6uI4TMvfUIY54/5RGl4P3pdr169y6xZFeRfdl4MWHxb8IjXlj/oY3f1Q/2jUatu1t0JHCCoYmWbVY3sUcNRmzNRbq0usFVu43gUbzSIeKQjXu/9abI/hoefX4SsCYrSd1G40kka3/7xszvJDjWkKsPMOcCaRxWYtCBuqHzjfVtkPRY2SQRAcai4gm9BwrVxoeKlH+aOyPGk9F26jDfkxJdz9SOJ+37DHov6PoGkP8FQNj+JWAjxJENV30CggrkZcoWdPP/EcYY5xc9Kk/unvamlyDdBxcu3fZoC6pIQcGkbh0wn/SwuvrD0OCdTFKDofzgg7MBx6PYDgqZSJYyv/CjzQVlg5BV6YHvFUz9efMVYpXPiBUtFZIRJMZMc/sx4l0Gegi8iYYI2SOs5Ma9sY1t4tOdE2IoCkv9QXlALwpHI4YpaFmZSbDy+5saplI6hrGSyjG8J1Yh+XH6bObANtqLZvxH+RDIy/jz2Ak
 DVKw/T9F
 7GgS69rHXdKMqnfjAMAhEoMkax5GvRdmVM8Jt7MnKFIgxGu8YzPm+mGImTyxGndsiCBYm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Catalin Marinas <catalin.marinas@arm.com>

On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
user space will need to have its allocation tags initialised.  This is
normally done in the arm64 set_pte_at() after checking the memory
attributes.  Such page is also marked with the PG_mte_tagged flag to avoid
subsequent clearing.  Since this relies on having a struct page,
pte_special() mappings are ignored.

Commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
folio special") maps the huge zero folio special and the arm64
set_pmd_at() will no longer zero the tags.  There is no guarantee that the
tags are zero, especially if parts of this huge page have been previously
tagged.

It's fairly easy to detect this by regularly dropping the caches to
force the reallocation of the huge zero folio.

Allocate the huge zero folio with the __GFP_ZEROTAGS flag.  In addition,
do not warn in the arm64 __access_remote_tags() when reading tags from the
huge zero page.

I bundled the arm64 change in here as well since they are both related to
the commit mapping the huge zero folio as special.

Link: https://lkml.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Polensky <japo@linux.ibm.com>
---
 arch/arm64/kernel/mte.c | 3 ++-
 mm/huge_memory.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 43f7a2f39403..32148bf09c1d 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -476,7 +476,8 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 
 		folio = page_folio(page);
 		if (folio_test_hugetlb(folio))
-			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio));
+			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio) &&
+				     !is_huge_zero_folio(folio));
 		else
 			WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b4ff49d96501..323654fb4f8c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -214,7 +214,8 @@ static bool get_huge_zero_folio(void)
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
-	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
+				 ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
-- 
2.48.1


