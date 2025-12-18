Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4C1D6ACED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBDD36B0088; Thu, 18 Dec 2025 06:43:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68496B0089; Thu, 18 Dec 2025 06:43:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D346B008A; Thu, 18 Dec 2025 06:43:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B500D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:43:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F6A0C09C6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:43:00 +0000 (UTC)
X-FDA: 84232405320.28.7B558A5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16F81C0007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:42:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sktPT0k2;
	spf=pass (imf28.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ueBZn+45O9kIeB4OEnwiBfwaPe0oC7Tc2RNIDRGPvmM=;
	b=XTGWl8cXV1YgWngEhAzcIeT+ac49IJY3JLHbbry5RexnHTAS7zoV/C08gmOJa4WUCVHZDZ
	YoCHcS8j9dvs/MeC47dmnCb8AqLw9YyEPXNOFKButYW/vynyO+FrVRueuzxXIcpS7CAt8t
	oWttmLWnma2zeZEDxnb//FtdQqBJXgk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sktPT0k2;
	spf=pass (imf28.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058178; a=rsa-sha256;
	cv=none;
	b=6Z+coJ5lq+9gqUW+ZPw65VM5YDUUUfVqJlgRAGKL8dJdQHnzIwcZMpUvCiiK1pT+hRYxk7
	VRL4v0DNWqdRUKyGE/ebaGaT/ncpr7Ab9lac6DTQ+AQh3dZeRAhTYXIuJgT8LcvQ2HnDGH
	9DZTP/YrIWxhBjOvO2ATes8FvvOVv9o=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI9iiAE031618;
	Thu, 18 Dec 2025 11:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ueBZn+45O9kIeB4OEnwiBfwaPe0oC7Tc2RNIDRGPv
	mM=; b=sktPT0k23Oe0OXh0ci50UBmNSNS/m8VR2vCW3mCRaSU71tS88+onrlb+Y
	UkNdC4MyzFUXshvaN+0gDbHAZuEHcbZ/Hveuem6pqYbM+Il9+OdPdIETab8xA/pl
	zpcCOL/NoGMbmW9qJEH5xKMjW0kYenwfdBJbTLy4ZcqqZvHvA3hYUHnh0Xgc0Ho9
	G3iIM/oZGWlipExwJAgXfJfLQs4jYhWf1I2h7MSX6Bhx9qZsLRvyqsmlVxg3WBwR
	97PAfJuPDEg/Qb5kN7dFYxQtacB1WZm7VQt7TrlpCnE7R/qpqV23TD8abVlcdr3G
	NjiLQGgaCvWpxr20tq2t8xMH6Ioow==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjq9pjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 11:42:36 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIBcEub005538;
	Thu, 18 Dec 2025 11:42:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjq9pjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 11:42:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI992IM026786;
	Thu, 18 Dec 2025 11:42:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1jfsrc49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 11:42:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIBgVRd58393012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 11:42:31 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1FF72004B;
	Thu, 18 Dec 2025 11:42:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A55820040;
	Thu, 18 Dec 2025 11:42:26 +0000 (GMT)
Received: from li-4f5ba44c-27d4-11b2-a85c-a08f5b49eada.ibm.com.com (unknown [9.39.19.14])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 11:42:26 +0000 (GMT)
From: Sourabh Jain <sourabhjain@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        David Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org, linux-arm64@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
Date: Thu, 18 Dec 2025 17:11:54 +0530
Message-ID: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfX2ylNDjE6qF8M
 Wvb71AqPND/tyTSz/4Ytx1TX4ByRQ7QD1mz2iDcyWbhOUHqzd4l3OdtAH4F+ro4vS7LrVHz8eHF
 rZgRlq0mXGrzkikrlT9k5OkiZP/cyjBRDJSmHzwctlb2AXK/3Fsm16RycFVS60CROYA1Q54Vpty
 B1cx033Z3dVKBwBINWYKYurwB8cnJctF8armXqmLaL0jy+V7hiZgT0+I3Zr7mXABvarhVW2KkHX
 IoysNWvoY49vxA/fAMv2W/Z9HskNwvdPlQ9iLQhaqgdZxNIbtQGB3MpDmM/wBfOYjFhIqRa6pb4
 h1Eanrfvb5T8B+x3xEU/1DyIt9IfxNfZDaBdzW9Pv9m725wiy82/fzYIqjwvkpn7QSegbvANnhS
 e+fdzjYGsmf2hjDbJRujqbnmvDQ7lg==
X-Proofpoint-GUID: O0qyFaF33IY24Q_lUnei8zetuKTMIwbv
X-Proofpoint-ORIG-GUID: QflVMWAlGoroFrRjbVQrZbjsNP3JgSGl
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=6943e8ac cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Z4Rwk6OoAAAA:8 a=1UX6Do5GAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=37rDS-QxAAAA:8 a=voM4FWlXAAAA:8 a=JfrnYn6hAAAA:8 a=v1Mu38Z0himUwxGqKPgA:9
 a=HkZW87K1Qel5hWWM3VKY:22 a=Et2XPkok5AAZYJIKzHr1:22 a=k1Nq6YrhK2t884LQW06G:22
 a=IC2XNlieTeVoXbcui8wp:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Rspamd-Server: rspam02
X-Stat-Signature: rkpfneh76myi85ex5pqbkipt8634mnno
X-Rspam-User: 
X-Rspamd-Queue-Id: 16F81C0007
X-HE-Tag: 1766058177-809410
X-HE-Meta: U2FsdGVkX18BIMJxiwleGEyUpM5dvGl9OEIn3DUFvcPeOvWU5Y0AmWT5cfs26D/WdYbjigSIB92q2pULchMCh/F3tyHtb9y9/IuPlL7QDH9ePwDFgX+cJby7QeC2pGagA0XZ/qpJaWEgeDXMCyQkE3NTGZvN21XJgh4LJHFp+ZPU+Io+usS3HPfHQc+lwa/v/75uNySrF6btHW+QzGD1u1c3OaVB6fH5gqgfW4opt2piUGl02HQ2aX4O6kTlTsnJWRoLApoT1KnkWcbPIrKCJYZOGmLMVT/fCyZWci0QTD1lFJXaBc85CVbKFrdBJNHPhAmKG8WJUruf7SWf86qjvkaz+cv8oKaq3xqRXlkoVFZeNG/9I4hoKiWrFoQhufKjGmUt95Kook6CgLbcJ4Qf+iAHkmLsRtHaYJKLTepY+qkUgsVpScWTflPwuCfMAlpKjwLxSzZQizc2sabQyK3V3PyRkFuOBkJU5kxnuqMX5U4zBvmxiL9x34JFKRrC4d+r9hElT1tTThpypw1d1jnfxyC0cf6ErBGKGLuqKhdUinnFEN/Ix8nxfmYaS6z+gwyYdN5ZIDPaj2Kg4RLeGBUlfhB2UDkEUqM7lYGzP1BMUOpyor8kjPkPkzrmA+OJxBzD3RTWXM1dKqMV45pbq8UGBmsLVZNUGHyjY7yhj9OzpEZq4z69LcrFTQKuMCARt6IcvvpuXPjS2uYAmEYtCA31uIcvjSUZwrwQUjxy6iGM3lRHNyQA7zxRFT+o10pFvdloX4eksN/ks9aDywvn3ECqcnHgUFZvZ7Gap7qE6yQ4BjCK5NvUUJLVPlruKA6eO8dAJ2qrSbaTmy68Alt6uhXDvzWyOdPOboIuDxdARNI/+vZGYi8fnjYAYTyWmqVhjaNKtXAYVV4Xr2utompRXZ9oTH4hlNR10pNCffcDCdM8J7vbopwfUa4TT8dVx9uvFshTfLOmbhGakCDrYIcNvrm
 EK5dVz95
 LTL+9Qkpk9D5saU2xBccflrrXZ2WtyNA1X9fv0ZY4l8HMiiH5EybQht6IZ9v3TAcsK4b7Iym77ePN1Csz7HryeGfsZOm2j2EPVYXrdaJlXwH+3Mggu8mYVScgKDPpSHWN48EzNddYQ0KVYf6zllqIbXaI7ZX4dMCgWQ5neR99QOHQAzBZoeLOS4gc/YbvOZMYqx/joWIxZ2U6T8KUlhvKScIEN8AIMNGbmb0Y2P0LvVnKIt31IVHJ5dQHcP7xaymiLy4bqYPftSh5YzSgiJn4CHRWIsFyrb7wD5tUbACW5yIZ+D81sw2wtbEKUVAF2eGxdGFVwltw5QSr0Te7edXQ0TSvpGgyo6uiH+K9e1yQIjnFqKCed4GyUblbU5IPSmd5JvNbQ0/iLNjxdU1A+XMllPQJUOzcsjEuQZOK/E1KmSBwyU9ljQFb5Cg4JaCeJ4baX853PjOor8O7dEdC78SHkbFJdlgxdTdlrSXz8blHgvhpGdYsnaM6jlZ3+nAo/Hi+0Eb/ZRguCeneCQmeKQQSdl7YTtq72PHYS5sEScH/Nu+peF2PXSnU8yHeJAZaFcwgrijBInMTzcGsJbfrasCUTqKvQaS7e6wWTvd0rFtdomRkjdaL8tCs88+kpR4+o6hoI6i7VDJnKDYY5/ju6OpxnOIqT3ASEJFOnjroUP29BuEkm0rsnbj/Ujz7NQvya17wi8saRJUnAZZXx6ODlgg0OLhPOh54u6r1OmMa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
default_hugepagesz) when hugepages are not supported by the
architecture.

Some architectures may need to disable hugepages based on conditions
discovered during kernel boot. The hugepages_supported() helper allows
architecture code to advertise whether hugepages are supported.

Currently, normal hugepage allocation is guarded by
hugepages_supported(), but gigantic hugepages are allocated regardless
of this check. This causes problems on powerpc for fadump (firmware-
assisted dump).

In the fadump (firmware-assisted dump) scenario, a production kernel
crash causes the system to boot into a special kernel whose sole
purpose is to collect the memory dump and reboot. Features such as
hugepages are not required in this environment and should be
disabled.

For example, fadump kernel booting with the kernel arguments
default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
following logs:

HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
HugeTLB support is disabled!
HugeTLB: huge pages not supported, ignoring associated command-line parameters
hugetlbfs: disabling because there are no supported hugepage sizes

Even though the logs say that hugetlb support is disabled, gigantic
hugepages are still getting allocated, which causes the fadump kernel
to run out of memory during boot.

To fix this, the gigantic hugepage allocation should come under
hugepages_supported().

To bring gigantic hugepage allocation under hugepages_supported(), two
approaches were previously proposed:
[1] Check hugepages_supported() in the generic code before allocating
gigantic hugepages.
[2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.

Approach [2] has two minor issues:
1. It prints misleading logs about invalid hugepage sizes
2. The kernel still processes hugepage kernel arguments unnecessarily

To control gigantic hugepage allocation, it is proposed to skip
processing the hugepage kernel arguments (hugepagesz, hugepages, and
default_hugepagesz) when hugepages_support() returns false.

Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-mm@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-arm64@lists.infradead.org
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
---

Changelog:

v1:
https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/

v2:
https://lore.kernel.org/all/20250124103220.111303-1-sourabhjain@linux.ibm.com/
 - disable gigantic hugepage in arch code, arch_hugetlb_valid_size()

v3:
https://lore.kernel.org/all/20250125104928.88881-1-sourabhjain@linux.ibm.com/
 - Do not modify the initialization of the shift variable

v4:
https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/
 - Update commit message to include how hugepages_supported() detects
   hugepages support when fadump is active
 - Add Reviewed-by tag
 - NO functional change

v5:
 - Significant change in approach: disable processing of hugepage kernel
   arguments if hugepages_supported() returns false
 - Drop a Reviewed-by tag

---
 mm/hugetlb.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..e0ab14020513 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4286,6 +4286,11 @@ static int __init hugepages_setup(char *s)
 	unsigned long tmp;
 	char *p = s;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
+		return 0;
+	}
+
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
@@ -4366,6 +4371,11 @@ static int __init hugepagesz_setup(char *s)
 	unsigned long size;
 	struct hstate *h;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
+		return 0;
+	}
+
 	parsed_valid_hugepagesz = false;
 	size = (unsigned long)memparse(s, NULL);
 
@@ -4414,6 +4424,12 @@ static int __init default_hugepagesz_setup(char *s)
 	unsigned long size;
 	int i;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
+			s);
+		return 0;
+	}
+
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
 		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
-- 
2.51.1


