Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE11CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B8C900037; Wed, 13 Aug 2025 02:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACA08E01B6; Wed, 13 Aug 2025 02:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28AA900037; Wed, 13 Aug 2025 02:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A69108E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DE941DBDDC
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:14 +0000 (UTC)
X-FDA: 83770751988.23.FFC6668
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31670C0007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HWTX8eZ6;
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qdcq5ZcPgQ2wmd4+LkAjaTVNVpquUFZSKJxd9KBdzyQ=;
	b=aVlBz+5gbjYx12GW0CDpQ0jX93WDQELCtX53tEP1XL5w784eX8ycWGt1AgYPAvUgC0g6Dj
	9yF58m4Ude6iTpVaSTDiUmvJufRTVB0JezrA3QRSgoo4RUWNXUQyapdO/SA/oeHogJKgFG
	y9hPjeXiSsOcWU6V4UTqSTdJtMAwSMs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HWTX8eZ6;
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066432; a=rsa-sha256;
	cv=none;
	b=kS3uVbWqP4y3c9Xu5biS2QNwIKd/q/PSfp0SBDkqYkLz3Lztp0zytLixf+fEkrETZnq4gk
	xjwbzYKV3oiQ2yh+2RgH/nXP10SKYc+Nn0PEJ/vztZR92k3495gLuUhIqQnIxedgue1Z+N
	NGTDpa7tHrmUJnZqHPHt5sy16Xmgz/Q=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQNon015965;
	Wed, 13 Aug 2025 06:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=qdcq5ZcPgQ2wmd4+LkAjaTVNVpquUFZSKJxd9KBdz
	yQ=; b=HWTX8eZ6EMtyJRT63BpRKAp0W6VhYFr+lTfVjP3VLKmi7x1tLgFc9r91K
	2TgCsPpfNxtQzGVjVELYDqgctsTOV1J20VQUEpRl2HIcR0MRvonb9W8oGZhJapLm
	nmOuQ8gMmu+NGfwOkQeB/mOcOHpalXkCTT4uV04PwdMm5+SAm1nMslGAY8zKyFhQ
	E0NpL1Yq2m1UqMoDrlJn9LHcS7iNmB/tl/kuhel5gzE2qfdLQs32k+f+NF81vwZT
	JujFvjNUxpGbIXlDhKBQBjBdgTP7ZEiRADuDc/lOlxiZJKWQSY7KCfoMUMb5Euai
	+Bq7UBZfdYSdgJFfcfHszpTtY3yEQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp2nks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:26:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D4b4Ko017612;
	Wed, 13 Aug 2025 06:26:48 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3np0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:26:48 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6QlqB29885118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:26:47 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2F4058058;
	Wed, 13 Aug 2025 06:26:47 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A13858059;
	Wed, 13 Aug 2025 06:26:42 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:26:41 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu
Subject: [PATCH v16 00/13] Support page table check on PowerPC
Date: Wed, 13 Aug 2025 16:26:01 +1000
Message-ID: <20250813062614.51759-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIxOSBTYWx0ZWRfXxJ4h26eRsNEg
 jgmwyYuWumWKpAav/eruIyU9OcsAnnDIk2Q2Sqivf1sTCFt6ezY7Ud8dqqtj/h198Hufi6Y2wRC
 iycpf2ezWZgsNWWc06Fq8mMaU89aeB0BmWSHo9INkOnhwchCohWguk2qfMSW1WNPz1pE2Rer82d
 n98W4DjkPI2kLCgpcRzDsJSLwTqDc3rcsp10cnqxcumxeJwbqBR46HWUpwH+ccBnSXQ9b8PNdjt
 yrl2yb90IoqAYe3qtEn4YJDmgQllaScTYNaS9fWCN84vTbbiPWW9LeHgB6T9CPXft6ZH8uAh1Iv
 4gFIgd9b3ybIvbaoI8I44Lrl8MrzZyEvxRYOmSrucz5YTqOzopd7ITDauGZ8Ws1X3dcHQhLXwKD
 Rl5qw2DR
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=689c3029 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=c5s30AdFp4CnpOY87z8A:9
X-Proofpoint-GUID: neQMZGXBZF_zH6QiKHO7m0NapX97GL8G
X-Proofpoint-ORIG-GUID: neQMZGXBZF_zH6QiKHO7m0NapX97GL8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120219
X-Rspamd-Queue-Id: 31670C0007
X-Rspam-User: 
X-Stat-Signature: ri1snc5nx9cpiftikweoi9gmrw5cj4a8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755066432-94762
X-HE-Meta: U2FsdGVkX19HdOvsV6osGe8+VYjnsJJRNoKcZClguqbuFXhJDLDVTC5SEGj/DbP4+cq03TfA5GusrbmyVzN/Qc9PiWppqSwIsm2WRyphUwbH+Gx+nA/ppH42LUt1DupuJsONlEmOFJW5y1CaKDT8W0ut2SXiJz47FnWvQJDSChjn7DyRauVhKST2GFChFDq9o8TtjiOJDs78SX1As6kOdLl+alIPuRg6f2NxwFPJDa+kQMTSuyHY/21YEbn6k5OsK94FfolaTdJquSpdzo0aHiZNtyNSNZvUfCZTpUlxy3G2qy9PILUUfAzeSPY13oJC0fulygD8Vy0S7GRZSyW/XMjfaoSo+sDfOKpUGqb9saT/cI+/GT3jwUgA+im7v2HXIAmrfHjP14YK/kmLrEkppPJqpMIisrRAajSVrcEVAPu1QyUqfFjJPgZQqIRKTsbT6kNS52CbHvjRDeR/todEoh78uNpJ/Qho26oSEFHUuru4wFDbTzbiJAyQk7zOrv84/5TFYUavRTzKc23M2t6k6bYMldku54/yh3Qn4VtPYFk+VDUczsoM9J15wT4YZz6Shn875qFzTFvRfr8SZV2zw+VhsbmIndVKYUpr+9+xpJaXQmcHlkETb/09Nz7iL0On/M8gWTEE9VqwH3bTpocNoS046vA6V2aDO3AYHTB488pS/EnxF8zBAz8hViOpcebBIyWePj2gNEzvnVN5ZQBOxNcybtsUXvgVsJitXht+AWxZ/++1S1j0SpDp82bJXKtUuNWwnF3+L+tQEcyGUZ5oyhfPMdGuaAuGNwyE2Nj3GatPIna1enathMKMNtQRb1cvWHSY6tr/oHUNNCTGYlA9aBjrZ6F1CapZ17t9V+Ju+X/FajY0QBmC8/8QisOo/v1B5IvSWLQy9TqWYT75dzeVd6qojBqbyrAWkjnfNK4Eg/0wTmEXu+xe7VLQcTmZUkK7jRnSYrY37OKE6oZv+1h
 4tPXNe3B
 YhYJQ0YzFBTAW+HZtPL+S1KKvLkMsyMzmIIjzSA9be5pjlOWvci7COe+WTnfLb71G8VeiI/hXYxRlMLItYAJRpS5BJmGH3q07Fft9+39E+H1zgC8CiXZQe8CPJouGHQex02U8dxb6vqd4HAfLoOFusTW4pvaKV6WmE0ppyJRsHDvM//fEI2++GFbBBjpXfxmn8X+OTXnW2ATaye0ZdSTzcsbW3mUfy5bikVb2ImUETxJuHvMzQ7rhLBxmcLZ8AmWJYXkG6fl/Rwl0p6+9wyl0Gt/CIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Andrew: as previously discussed, are we still happy to take this via mm?
Maddy has acked the powerpc changes.]

Support page table check on all PowerPC platforms. This works by
serialising assignments, reassignments and clears of page table
entries at each level in order to ensure that anonymous mappings
have at most one writable consumer, and likewise that file-backed
mappings are not simultaneously also anonymous mappings.

In order to support this infrastructure, a number of stubs must be
defined for all powerpc platforms. Additionally, separate set_pte_at()
and set_pte_at_unchecked(), to allow for internal, uninstrumented mappings.

On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible_page()
requires the address. We revert previous changes that removed the address
parameter from various interfaces, and add it to some other interfaces,
in order to allow this.

(This series was initially written by Rohan McLure, who has left IBM and
is no longer working on powerpc.)

v16:
 * Rebase on mainline

v15:
 * Rebase on mainline, including commit 91e40668e70a
   ("mm/page_table_check: Batch-check pmds/puds just like ptes") and
   associated arm64 changes
 * Clarify/fix some commit messages
 * Fix handling of address in a loop in __page_table_check_ptes_set()
Link: https://lore.kernel.org/all/20250625063753.77511-1-ajd@linux.ibm.com/

v14:
 * Fix a call to page_table_check_pud_set() that was missed (akpm)
Link: https://lore.kernel.org/all/20250411054354.511145-1-ajd@linux.ibm.com/

v13:
 * Rebase on mainline
 * Don't use set_pte_at_unchecked() for early boot purposes (Pasha)
Link: https://lore.kernel.org/linuxppc-dev/20250211161404.850215-1-ajd@linux.ibm.com/

v12:
 * Rename commits that revert changes to instead reflect that we are
   reinstating old behaviour due to it providing more flexibility
 * Add return line to pud_pfn() stub
 * Instrument ptep_get_and_clear() for nohash
Link: https://lore.kernel.org/linuxppc-dev/20240402051154.476244-1-rmclure@linux.ibm.com/

v11:
 * The pud_pfn() stub, which previously had no legitimate users on any
   powerpc platform, now has users in Book3s64 with transparent pages.
   Include a stub of the same name for each platform that does not
   define their own.
 * Drop patch that standardised use of p*d_leaf(), as already included
   upstream in v6.9.
 * Provide fallback definitions of p{m,u}d_user_accessible_page() that
   do not reference p*d_leaf(), p*d_pte(), as they are defined after
   powerpc/mm headers by linux/mm headers.
 * Ensure that set_pte_at_unchecked() has the same checks as
   set_pte_at().
Link: https://lore.kernel.org/linuxppc-dev/20240328045535.194800-14-rmclure@linux.ibm.com/ 

v10:
 * Revert patches that removed address and mm parameters from page table
   check routines, including consuming code from arm64, x86_64 and
   riscv.
 * Implement *_user_accessible_page() routines in terms of pte_user()
   where available (64-bit, book3s) but otherwise by checking the
   address (on platforms where the pte does not imply whether the
   mapping is for user or kernel)
 * Internal set_pte_at() calls replaced with set_pte_at_unchecked(), which
   is identical, but prevents double instrumentation.
Link: https://lore.kernel.org/linuxppc-dev/20240313042118.230397-9-rmclure@linux.ibm.com/T/

v9:
 * Adapt to using the set_ptes() API, using __set_pte_at() where we need
   must avoid instrumentation.
 * Use the logic of *_access_permitted() for implementing
   *_user_accessible_page(), which are required routines for page table
   check.
 * Even though we no longer need p{m,u,4}d_leaf(), still default
   implement these to assist in refactoring out extant
   p{m,u,4}_is_leaf().
 * Add p{m,u}_pte() stubs where asm-generic does not provide them, as
   page table check wants all *user_accessible_page() variants, and we
   would like to default implement the variants in terms of
   pte_user_accessible_page().
 * Avoid the ugly pmdp_collapse_flush() macro nonsense! Just instrument
   its constituent calls instead for radix and hash.
Link: https://lore.kernel.org/linuxppc-dev/20231130025404.37179-2-rmclure@linux.ibm.com/

v8:
 * Fix linux/page_table_check.h include in asm/pgtable.h breaking
   32-bit.
Link: https://lore.kernel.org/linuxppc-dev/20230215231153.2147454-1-rmclure@linux.ibm.com/

v7:
 * Remove use of extern in set_pte prototypes
 * Clean up pmdp_collapse_flush macro
 * Replace set_pte_at with static inline function
 * Fix commit message for patch 7
Link: https://lore.kernel.org/linuxppc-dev/20230215020155.1969194-1-rmclure@linux.ibm.com/

v6:
 * Support huge pages and p{m,u}d accounting.
 * Remove instrumentation from set_pte from kernel internal pages.
 * 64s: Implement pmdp_collapse_flush in terms of __pmdp_collapse_flush
   as access to the mm_struct * is required.
Link: https://lore.kernel.org/linuxppc-dev/20230214015939.1853438-1-rmclure@linux.ibm.com/

v5:
Link: https://lore.kernel.org/linuxppc-dev/20221118002146.25979-1-rmclure@linux.ibm.com/

Andrew Donnellan (2):
  arm64/mm: Add addr parameter to __set_ptes_anysz()
  arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()

Rohan McLure (11):
  mm/page_table_check: Reinstate address parameter in
    [__]page_table_check_pud[s]_set()
  mm/page_table_check: Reinstate address parameter in
    [__]page_table_check_pmd[s]_set()
  mm/page_table_check: Provide addr parameter to
    page_table_check_ptes_set()
  mm/page_table_check: Reinstate address parameter in
    [__]page_table_check_pud_clear()
  mm/page_table_check: Reinstate address parameter in
    [__]page_table_check_pmd_clear()
  mm/page_table_check: Reinstate address parameter in
    [__]page_table_check_pte_clear()
  mm: Provide address parameter to p{te,md,ud}_user_accessible_page()
  powerpc: mm: Add pud_pfn() stub
  powerpc: mm: Implement *_user_accessible_page() for ptes
  powerpc: mm: Use set_pte_at_unchecked() for internal usages
  powerpc: mm: Support page table check

 arch/arm64/include/asm/pgtable.h             | 46 ++++++-------
 arch/arm64/mm/hugetlbpage.c                  | 17 ++---
 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/32/pgtable.h | 12 +++-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 62 +++++++++++++++---
 arch/powerpc/include/asm/nohash/pgtable.h    | 13 +++-
 arch/powerpc/include/asm/pgtable.h           | 19 ++++++
 arch/powerpc/mm/book3s64/hash_pgtable.c      |  4 ++
 arch/powerpc/mm/book3s64/pgtable.c           | 17 +++--
 arch/powerpc/mm/book3s64/radix_pgtable.c     |  9 ++-
 arch/powerpc/mm/pgtable.c                    | 12 ++++
 arch/riscv/include/asm/pgtable.h             | 20 +++---
 arch/x86/include/asm/pgtable.h               | 22 +++----
 include/linux/page_table_check.h             | 69 ++++++++++++--------
 include/linux/pgtable.h                      | 10 +--
 mm/page_table_check.c                        | 41 ++++++------
 16 files changed, 248 insertions(+), 126 deletions(-)

-- 
2.50.1

