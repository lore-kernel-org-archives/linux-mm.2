Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEC1CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847416B009B; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F73C6B009F; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB4E6B009D; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 177306B0096
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6E071601BF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
X-FDA: 85295641620.11.9491409
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7BC8780008
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I3rht98W;
	spf=pass (imf02.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ImW1A7hT47WEjadoboSV9gbd1tHTZSMML/etS4sLZo=;
	b=jdaN6YYqxAHdn/ObHZR/smuX11J9OY4RszGycSHwnkvRL9vNR9TJ0sJCg4J/UZvXBiYjom
	XHpZtccP5H4OYNRVD2DkuU0KRpdK4OQTDjHrA7PLcDzjsstntl9sQRULBzuVLuSEuvdxCn
	I77ejZJnT0l0jInttGSoEmd2Z57KU60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373328;
	b=Wd44wAQLqFLZKUUF2jQhHMYbtac6cbszU55Kg+HHMFADLHqyotqOrLZCOSbBFThAM/XNDd
	59t+745UHAux64b+C1N20BllDcT43E91zIlSFK+OWClyIu4zAxTOBaaEhr6lKAyy4wkTvI
	e8Hi3PfNN5jOXIq6AsfbH12SaOd6eSE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I3rht98W;
	spf=pass (imf02.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZuAC596963;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+ImW1A7hT47WEjado
	boSV9gbd1tHTZSMML/etS4sLZo=; b=I3rht98Wm2kUjwTmjPaDlm1x452qEvI6b
	fcNG3iqD+6fZCEVqqTeYNmCBsaVbR1QotzVMZOhce6c8AjbVIRqFtXvRZbnzJ+QP
	60v1q8WK7XJzo9BROcwPK4blHBV4reZL7EkSXWXfNAcVbTMFu6cEWbBdXHgveoNz
	x3zeQPjM70wGkL5s/iG7pNYNl2PUXk+F+XnSYsp+hSqSRHiiI1UzI6ZnIViJmlG6
	G90fxdOleHTX62ciYjO7dEKb7uF2pOVllcG8O5Efuy5wmpFnupE7psXBfOU6NsBN
	F4FfcWcowxc6GirOO0cI5hlpHo6lHx4W+oRB7QV/oQVwW5mG1naVw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2scrn5kh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWf0f1841543;
	Wed, 7 Oct 2026 11:42:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dj8vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfwZB40763880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E019B20040;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C2222004B;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 79E691608C2; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: [PATCH v8 01/15] mm: introduce hw_pte_t for PTE table storage
Date: Wed,  7 Oct 2026 13:41:44 +0200
Message-ID: <b904864873389b1efb75d84896113e867d8aca69.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXxtd2FC2+qyo4
 omD1NLhP2N1XXsDIU1jk0OBelsQSSwwX0EyxLlhtJyDRpJfDAiH5fxsXwMU/efieOYXxTNLl73B
 mhIQ8JA++RfRZmRbNNkw2u6bDE/9Wn4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX/KvxGPxgjJh0
 EiiRkI9Oo1vG6V2i++flNqkbz+jWQlKQU9mD+F8S8Mnrbo8E/csCkbxtBvgijaVwQOkyEel0xQQ
 jkSeLJNVxDGADwEUHbjj9vw9aEuEik2Yar4814ung23UBs7GIgxKL/6XdUNO+QlP0vvPQwt9TNc
 YCMEngN1hL1vaH+zyVQiy/JbnjT0Irru8QxOUSxZbODHtCk/kr9+sBEkHpl9P1nlrAg9I4UIOZ0
 5xOE0uCDHhEK1OapWp9COapC+ekM/0+CrNLRiRa+EmPnecj4E9gBkU0xAxKN8l4XUBD0th8tFNM
 l2+77f2ZCy7Kw0UG9lxpSFzLEwLKKKWEWAJwY7js0NZ9WC3Wqn7L53CgeHR8mOWl+swcwVPsKya
 u3718my08dN7M6lVeKbzTpPOByLupXs8H8Q1egI5x2drrjWHPmWkzPpwmRqSOu8skzHVVf5T9Tn
 u/B+Ac0QrCtB/SaNZNQ==
X-Proofpoint-GUID: EpdZKbeWXbagxsT_DdqzTGowsdnQpLF8
X-Proofpoint-ORIG-GUID: ijA72TZK8-lnNO48OOnWugP-lwLbQvCI
X-Authority-Analysis: v=2.4 cv=B7osQ+tM c=1 sm=1 tr=0 ts=6ac6300b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8
 a=jvpwQjTEV3ZLedkYkM8A:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7BC8780008
X-Stat-Signature: 3txzp7ex1nowadcfj31wdhce6agrfant
X-HE-Tag: 1791373328-445407
X-HE-Meta: U2FsdGVkX1/1ucJe/pqVfnpIRN2EkIylL1BtHKbBsfJ7gj4O6eXAXy1fl2hYOneVgkBwVo6/SuFJYu2FeBJuhHv3aWw90jir+PCgYOpmgpqrb74w1B7j/LakLxy7jYjgiQJtlQo7ialIpumclcSJsMyvf08P98dDCfil8mR4sZUNOIUwu+gnDfhYGAX4fyafO0nSfW2MbAK2c2s4RVeW/EamOFF5QgONsGQ02W8/Z9nYGN/otGqK8veb0602QYZoAknR3jol4feJSNIRO3WU498kPsjIDo5sGkk/2QCUPYRUlz69sbxc+G5zMfZP1KTyutzTgoQZmqoZF0oMcf5WIgSZRezwd3Wf5FVW9aFcLwws+lIJUpfRCgNJckCXyN6bgBQtoAW4qEcIEJByra+GVmnRNrXgSqZyPiy1bZcbF4fnvKHVcWbRWl292rniW0eGtreOlfiJeNqhGfV15eP1+O16dDC4bvwqRA9/pvOW2Z1lnt9u9C4NVYgvuFTBe6kjweqfkEG0Hv+xjhhOANM/Qo/WIgPR2s1a2pkTisa93KvOjP+hONw3YnZ48z0Kdp6Er947U6dxlqjHTvM8Pxp4L152iS4z0o1L4a7acC2DuiuASoON3ghN3jL6+kfhbjBKb6cvqxW0JUjEOcFBZzQBQlCzJuyiBW5ZVtFjqcE31wZRMDqhxtXcPDqU/KmaVq9E+vFtAgPPhvAsbOzYCl+imInPKu4km3uf9BR2fuTcEPq26sB7WdRjme/v+WvNCxfgXVMK0zYXe8Jp9eVb+oOQaXaEhR+tDzN+mDxv+KvAtAlxQyvT952z55dq7ysTPT4TTRKzM9ch8qZCwGyUn3OdCymZsMTar9sXXXWqmLMbDpTXh+lNmGCzJ4lUMS9gV5nRjnFshnjPGSr9p+PlnvKYRVobCkyjo7XOO7RESKGesPNsepzLVxJu1fxW/5OkNye+szcM05i5wQKWUpg5eVg
 iMeAFIvg
 dS5W/3HTPB7LtxATT5oCYL1g0CEEVG2NzRb2X3L2xB6QYzxC5JSxU+GrRvgISrkP2459JA2GCUfCRmeRo4+m+oUpzB0sxl+xuhgeRpAW6+bbsC+kQ4rmrzPMUgwEkDAGqlGV3JkHu4yAC9VRv7E8vUO0ugrKBG4TinmefmczaepIOfnTa8wGuhS9vzjSz/cNcB2dgRT0rIbyi3pg/3nRPj4kGnCKKl9ZSJIMRb/m8h1yLPqtQ0bM9j62ROG94qiSZoTU7BzMdMA3vwxe3uS+vXxo/eITTdP1OEgyXw4U8wa26BAXPYBZ7hF9ZgsE9qYqBgXHvEy24Brvk188DzWXv/PGMp3tsUCoviPyukKg8Cz9+JHDy5g7FtnfK8nPmGFfr2Qi63y55HtnpnA9qQmXhQml8FTYF4IlClMHxdwrpsVpLuxjSVfyxVrKRsvIIIvgwYkTOizLlfy39Z5bHZ0FXrWgTLO2RPihXvQer
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

pte_t is used both for software PTE values and for entries stored in a PT=
E
table, so pte_t * does not distinguish a pointer to a software PTE
value from a pointer to table storage.

Introduce hw_pte_t as the generic name for a PTE table element. Define it
as a macro alias of pte_t by default. When an architecture selects
ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
This preserves the representation while allowing converted architectures
to enforce the distinction at compile time.

Name the generic wrapper structure __hw_pte_t so architectures can
forward-declare it when pgtable_t must be defined before the generic
hw_pte_t typedef is visible. This avoids header-order dependencies.

Keep the C type definitions behind an __ASSEMBLY__ check because
architecture assembly sources can include this header indirectly. Include
asm/page.h so consumers such as linux/vmalloc.h retain the page definitio=
ns
they previously obtained from that header.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 MAINTAINERS                   |  1 +
 include/linux/pgtable_types.h | 17 +++++++++++++++++
 mm/Kconfig                    |  3 +++
 3 files changed, 21 insertions(+)
 create mode 100644 include/linux/pgtable_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 65e8a4b5c90b..76f809c607ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17142,6 +17142,7 @@ F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgtable_types.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.=
h
new file mode 100644
index 000000000000..07da05d375c2
--- /dev/null
+++ b/include/linux/pgtable_types.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGTABLE_TYPES_H
+#define _LINUX_PGTABLE_TYPES_H
+
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARCH_HAS_HW_PTE_T
+typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#else
+#define hw_pte_t pte_t
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _LINUX_PGTABLE_TYPES_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..2e65b93b133d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1317,6 +1317,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
 config GUP_GET_PXX_LOW_HIGH
 	bool
=20
+config ARCH_HAS_HW_PTE_T
+	bool
+
 config DMAPOOL_TEST
 	tristate "Enable a module to run time tests on dma_pool"
 	depends on HAS_DMA
--=20
2.53.0


