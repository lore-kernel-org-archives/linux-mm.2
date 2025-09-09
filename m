Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5333CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5D46B0022; Tue,  9 Sep 2025 05:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27E836B0023; Tue,  9 Sep 2025 05:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FC06B0024; Tue,  9 Sep 2025 05:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86BD6B0022
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B808613AFAC
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:32 +0000 (UTC)
X-FDA: 83869151184.13.10E1FBC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 82B9140003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TJ3muQkJ;
	spf=pass (imf17.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Duj4pjxFvbmk0v6rahK8RMiOEFgq0tWnKjVK3kbNkd4=;
	b=J+KB8VvmIqWUuI8RXxpdJDlfp6z2+HkJao7X6nFWom3vJkX86AsOAH2PdiL+9xCP9AQ4S1
	DpodL0IxyAglJ5eN7iNasXV4kkRA9fOi66B6rYyZK2vDLtIqoWx4jSSP/SUfSUN1hbsxBB
	5mzjtXB+XhzAQuEzHQejnoT/hNehnsI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TJ3muQkJ;
	spf=pass (imf17.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409270; a=rsa-sha256;
	cv=none;
	b=agGWTaqfhVAkCRlMR1J/iq+fAzCNMtXtWSij4LOdWimVgSlEi6jBu9F9RyPWVbPrR9JUj4
	12HJxabw8tWS4FkthOPwnYMvK3h0zFL33tyYiH/Mx0crYpiz99+XLfY3K6QxO6Ef3l4djr
	NNGndYx+MoT3d70wofWofaPas7VgIu8=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588KHS8w031928;
	Tue, 9 Sep 2025 09:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Duj4pjxFvbmk0v6rahK8RMiOEFgq0tWnKjVK3kbNk
	d4=; b=TJ3muQkJnxc/BloT/Cg+szQp9mxxWBMx8DOMkbnlH/m4S6tkJm3hyfrcO
	YxpsYIYrP81ToKNS9SpFeNo0jOZlQ1PHQb8m0PbuAlhfA0xT1kkF02yORW5dLh+d
	aQXAIIfvdgWJ73zd5tsrt71OaKwYpAsZvO0kyQW9zxnl0N+hUSeTWsTI5/8jhK4l
	Wdy7CoSKCg+rE3+jucrCwSRzdiA99okixeNfOMEVlZeUmHv8EPhT5g4iR6pPUvTs
	SVFIgIY3yQehc73Jq6AvyQFyAJiMXphSUk39WQL69fkm86zuDz6QLiIUV//3OrnZ
	kNg66tKSMhqazXcO8BnY5NfhdtLDw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcspgt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5895h3si020700;
	Tue, 9 Sep 2025 09:14:23 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0tg2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:23 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899ENoV33096302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:23 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04AFC5805D;
	Tue,  9 Sep 2025 09:14:23 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEC5658043;
	Tue,  9 Sep 2025 09:14:17 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:17 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com
Subject: [PATCH v17 00/12] Support page table check on PowerPC
Date: Tue,  9 Sep 2025 19:13:23 +1000
Message-ID: <20250909091335.183439-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX/M9TtCej7RLe
 SMCNFDggWrCycH8AZjkdkr75NBwHykB3TnoAkDigTz4L/h8FwdtKhAco3FdtFI0e/Qnoh+Mxi+y
 YDe11GybDHYovvKAXnqGQuIcjXHvbGtXj85LOrHirgF4njXXlimtbI2GgPzEsFd7NEjH6+lWNLJ
 Dez5XsNLJ4m3YsBAlAc4ZdB76Z9XmQPAjeXzspOOuk/fs5BH0qLo+uatgq8rSIcXKT3FaSlTWlz
 HqrrVjBICagWuTDpD1+12dJMxWai8d2zaHNsaFDIzjDstpBHl6ruaw2SI73fweaB+OZKJqUtrpK
 FtYCd6kpvUShHkKdxrQVAf5r73li8BoXgU/nV8ufGDhqcCnZqf82tnIrE2WeW0x8L4SSWR3Klv1
 ktr+5QBx
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68bfeff0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=1UX6Do5GAAAA:8 a=VnNF1IyMAAAA:8
 a=rRHG20brLvp9ZhHRRGIA:9 a=Et2XPkok5AAZYJIKzHr1:22
X-Proofpoint-GUID: DdQYcCI9RD8AAiJvj0PlAb_lUvaC9h1n
X-Proofpoint-ORIG-GUID: DdQYcCI9RD8AAiJvj0PlAb_lUvaC9h1n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82B9140003
X-Stat-Signature: ydueqs378uze8das47scd5qa3nj4orbe
X-HE-Tag: 1757409270-139553
X-HE-Meta: U2FsdGVkX1+2ZaRmUXs3eoFFz9ivz5TDNaeIiPkrX5ubjs3s5gOvbbus/CcPxlM+1Cv8kPbT5g6givoo4hzn2W3a7l9RuSn0c6UI2Ov5OnYY7zaLPVyMMaDjCwRS3dZquMfcMYHEuHg1JHqK+vX8o6fdGmvHN/da9Vvl9GstOjXMIRq4xwjdwJDDZWb8U0KFgLCcK/PZaVypMuuk1EPKXPbkNIXkG40wnF9MWr5zxn7fiR41+HUDQrbErfd2RtCTlXkfTLsWUCaO1t5xctcGipVN1fn2NqNDiwlqSil+EjXSV9EAtzEVozXigasqBrSUNgkiL9Giz1jq64C5fTRIJjqarkq8paMx5AEZMiopcxpxSPKgosPjmb9JAn4GZvoBoRL2KCOibgZp/yNSlJX93jiDi6yqv8bkUJtsXzi3Qqtfh+Ntpmiur74/OUC/w6I2ENFEZiA5msnV9ESiRrffGHnpsaHIz4kDbSvTRYdasonm5apusjzZf9xHh3cn+BOZ99dCefxXAr96TuEG6qJ22BfIbsT1twKlAjdPDJEd3aVuaEM+LNNiMgJ5KDKZjw4wEnGp9tgibNjjeWRqNuYZZv04eqiPQpvbGtA+v5eEQ5bKAikLcRW7zBn/gKcjACKr4NW52daIbbCKIaapKZNF+3A49yvRIbzOv0jfmFKqBXuiLdU+Qz3Dr8maiQluGBpf7/AI6j1opYbjqvf36iDAF/qpevzTxF6gwHPAL4f4KZQa+SUDq0bXHTcCp8rJT2oAd55uvqgein00mkI6dF+6xfFYe2pgENFnNMtcKKDZz9XsltOWak5Jwi3jtfVjPIVZqDHird22FW2lrKBTyscvnNIPKd0CqYLyJVQisXqQpQkgHdgUK9Y72GJY6xTBC5J2W38gwg10GSZxqqG527Uy6tubHyhB5jCe8Of/IOppH3Or8W+WQhmltLvarHxFO8M7i13nnX2st4GAmrR3P/N
 3d/kYqkL
 i6Y3FkDk+eTlOv6deqqDYhzxkBATL+W17Eiv1QzCiIqrSF+Fo3r95AMDB8tDnkIQQ5eeO2iORsq5zonQY0g+3nZfHuU44V6Z48kOfoVOsKNnK8A4/MZJACG4S8UQdDal6GBRgIriPnFTddc3Zk356HILs227eGI5EZo9QUkxlUVJCPa5K7Tkf2kfEdUdox3p3OaW9qjpSPWCZYuplb7Vx7P0oQZ3LpxLlcu53wBtSDA0X3TCXcKZ3Ynzh7+EI7IAiokxo62eaGRvnee3YBdtVI08TOVKAVdvV+SHk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support page table check on all PowerPC platforms. This works by serialising
assignments, reassignments and clears of page table entries at each level in
order to ensure that anonymous mappings have at most one writable consumer,
and likewise that file-backed mappings are not simultaneously also anonymous
mappings.

In order to support this infrastructure, a number of helpers or stubs must be
defined or updated for all powerpc platforms. Additionally, we separate
set_pte_at() and set_pte_at_unchecked(), to allow for internal, uninstrumented
mappings.

On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible_page()
requires the address. We revert previous changes that removed the address
parameter from various interfaces, and add it to some other interfaces,
in order to allow this.

Note that on 32 bit systems with CONFIG_KFENCE=y, you need [0] to avoid
possible failures in init code (this is a code patching/static keys issue,
which was discovered by a user testing this series but isn't a bug in page
table check).

(This series was initially written by Rohan McLure, who has left IBM and
is no longer working on powerpc.)

[0] https://lore.kernel.org/linuxppc-dev/4b5e6eb281d7b1ea77619bee17095f905a125168.1757003584.git.christophe.leroy@csgroup.eu/

v17:
 * Rebase on mm-new to fix build failure on commit 3f3806eff23f ("riscv: use an
   atomic xchg in pudp_huge_get_and_clear()")
 * Remove patch 10 ("powerpc: mm: Add pud_pfn() stub"), as the original
   reasoning for the stub is now wrong (pud_pfn() is now used more broadly in
   generic code, and commit 35a76f5c0863 ("mm/arch: provide pud_pfn()
   fallback") now provides a generic fallback. This fixes the build failure on
   some powerpc platforms (0day)

v16:
 * Rebase on mainline
Link: https://lore.kernel.org/all/20250813062614.51759-1-ajd@linux.ibm.com/

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

Rohan McLure (10):
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
  powerpc: mm: Implement *_user_accessible_page() for ptes
  powerpc: mm: Use set_pte_at_unchecked() for internal usages
  powerpc: mm: Support page table check

 arch/arm64/include/asm/pgtable.h             | 46 ++++++-------
 arch/arm64/mm/hugetlbpage.c                  | 17 ++---
 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/32/pgtable.h | 12 +++-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 62 +++++++++++++++---
 arch/powerpc/include/asm/nohash/pgtable.h    | 13 +++-
 arch/powerpc/include/asm/pgtable.h           | 10 +++
 arch/powerpc/mm/book3s64/hash_pgtable.c      |  4 ++
 arch/powerpc/mm/book3s64/pgtable.c           | 17 +++--
 arch/powerpc/mm/book3s64/radix_pgtable.c     |  9 ++-
 arch/powerpc/mm/pgtable.c                    | 12 ++++
 arch/riscv/include/asm/pgtable.h             | 22 +++----
 arch/x86/include/asm/pgtable.h               | 22 +++----
 include/linux/page_table_check.h             | 69 ++++++++++++--------
 include/linux/pgtable.h                      | 10 +--
 mm/page_table_check.c                        | 41 ++++++------
 16 files changed, 240 insertions(+), 127 deletions(-)

-- 
2.51.0

