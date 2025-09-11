Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276E5CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 14:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F038E000B; Thu, 11 Sep 2025 10:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF828E0001; Thu, 11 Sep 2025 10:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7058F8E000B; Thu, 11 Sep 2025 10:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2F88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:00:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11F30B9B4E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:00:42 +0000 (UTC)
X-FDA: 83877129924.03.9D4416F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AE024000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:00:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iz+8NLEz;
	spf=pass (imf04.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757599239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YDQ7wA0cEaZqnzYnfBrvZGZXbIlM4NJQHZoh3mYMQPQ=;
	b=AYdOfA0U7ha7eM4NAABNncriTQ+PVXcHQBQ+844QxigqHRDCDr2zkZUFJ34oANS8BV/pAO
	yd7knyQP+tcuYT4BUd65YM5qKEYFy1prfc5pc7NsZu5/fBpF4XG7EOS8NAV/3XngV8Xu0l
	JovQIFBdAnf8TIAX2wDiHuZtPB4WifY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iz+8NLEz;
	spf=pass (imf04.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757599239; a=rsa-sha256;
	cv=none;
	b=gUoSmO0HoGRTAGafPmHhRO/niNwm13oG6WSwkV2X8IwKIAyWaqwbVAS/K3GMYHu5uS0hMd
	7mmrK2KmmuWQmujbDIvp6KqLyf3nIGTCohoorjaw/O5O+YhgXmyRl/f6cXJtWdTbctZ1WN
	kIarREWmKpUkh+d5PsZ7ClP5vThKkBs=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B6sHLu018250;
	Thu, 11 Sep 2025 14:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=YDQ7wA0cEaZqnzYnfBrvZGZXbIlM
	4NJQHZoh3mYMQPQ=; b=iz+8NLEzaYJRjZ1C/XtbHeZ1QlspB7BspC863bJv8AiH
	IWVvh/yUlUYwLzzIOblMk2ckp+rHGer+u1L9hXQIKE4n2Ku0WpKDJ0KPac0Knprs
	f/GBH0YAzytGGpS7yc8Dezj0MOZHMHaQ5BoTdMwFocNbHjiRlEu4gVXCaIp2uLTc
	mdv6rRE1yTToMsVdbgSYvmcv7eJub85SBoNkPgfcDFAsXRJ0zavBqO6DQ30wrX6f
	JAXeMXGcXLI4xSIvkd/4yMSpSXLi6xXO+YX1+Nt+tYxpVT6Mt//KrganBb9k2XG9
	qd7O/9V2KISuGy3ptvaNJtuRmvsRbEwpyV9lsVM+xQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffn3je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 14:00:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BAsVFS001156;
	Thu, 11 Sep 2025 14:00:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203nugk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 14:00:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BE0W3P56951234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 14:00:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60D792004D;
	Thu, 11 Sep 2025 14:00:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BC0F20040;
	Thu, 11 Sep 2025 14:00:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 14:00:32 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, sumanthk@linux.ibm.com
Subject: [PATCH] resource: Improve child resource handling in release_mem_region_adjustable()
Date: Thu, 11 Sep 2025 16:00:04 +0200
Message-ID: <20250911140004.2241566-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MTOR_tmAk2RQ8IifHF0B5sMQIvW1KOEQ
X-Proofpoint-GUID: MTOR_tmAk2RQ8IifHF0B5sMQIvW1KOEQ
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c2d605 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=rcggkWAweQVEyhe311wA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX54xaUO/sYe9t
 YhAG2H0V2laqeuC+g3yWvtuo5bXVI2/LeJ/bzbz2eXXQ/biygMTG/wtT22Ht3chgv6zixFc6TRG
 i3J3grDRCy8lObblwKov7b4vn5lYJEkrqNAu8Q4OlSvCjJRm7563RqtMwugAjjoUQtIRjq2liUB
 RE9a9D6zSp2u/PE17+ELITgXST85DgO6RZOgu1k0ZIpcvwLzOpaHy1TrYBrh8KF85f2k8C5DfMe
 aVG87bFNF3hbuRAn4X5g/Bv3rWBlDBe3XfoKMpiy4uRzrw2b4cUt9otKofTRvlGP7K/nuQp7L1g
 uAW+d8+FfybKu9+E4UFla5/RHTCbFsJOmlUFCgdwpFEuTeEfW14TtL8bAkTTdjAvGMfROZn/uvH
 HEhIp3ht
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Rspamd-Queue-Id: 9AE024000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6qzaftx41on78m3iziwt1xyfeewxw19e
X-HE-Tag: 1757599239-437566
X-HE-Meta: U2FsdGVkX1+VL04B5pauejtjSTlEgV8awMgI9unICkCHHa8ng58gimnL6UXqANon8dbo0IbC71fBc76UMFEyn58qo2MD55WqH51xt8BbNy7+3LYRAtiMwK9M2KUVINPjPOvz1+/Ec6bQl0pvwbMqvMYrWhHrW1h7OaK2vIkh/Kwm4oSQtXaLkglW7MfdG/WiF15Lq25PU8tve4yX5iT9B1o9CRIzpUn8Nmr291NTSIWrVjdWXwPyaUBIJj23WFFU2X8w5YNxla0e6fgma+f6aKf2lGiKXHQ7SP3sGkgCj31PnGOy2w8SFI11kulK4ccCZIsUKVxXIYxwEd3XfY7ApyYAKRCBdz74pMkVvTK6TkoENqlLGVQ36xdM1ylWq69KTRisCluDfGCpb0B8vLRftdVeROWVg03i5bluhzEcHkYh7lO+M8adZ+trShjJh3510K2dr1x+cRvKOGJtJGfpB97dt9wdlR/9oZ3A1m6BwA4DOLYOrKucxzxiUr423azEwoEzY46u1+SzqcD3SE1Fwp5zh9hMLzNEo9T8uLgCuG1HVyydlDBVwv1/lxRMOQZhzRUk2fdO5c86x1SnA+OdCXl00zlPTOvfTri2jL8VLHx1lRlfMswX/YzZLMI+tfOvvV2spFs8GjTiltfE9Ophu+sohCYLybwP4TwWaKlbTg3aVbXs6FElz3YyWjvmLYys40lqZTRcMi3vHlYhrOZmCs6uFbuP54S7MgTDyyi+vyzW8bjwSq0Ms6BK59gIJn2rUqCnAUJJwPDgY2qLz8oUgLI4OelWehsCFsNc169cexv9aDNR89iDlp6NcLrTkkr5eAQyf1HWGYy1lcG6Ta5KGSPIjqUyu9bZKiN9WouCcHMoAFpYXo/41MVOvNj+y5nmqRYAdSYASnWd58YmE6IrO4Byljn/Kf7XnLLMsvYkcPLJqzNqpSREeBO+X3+Q7Qpmb4czBUz9RSv/ym6BIvX
 b5XqGR1e
 0bD+/7rOoIrEeeKw8ISDNYQXlXMBxu6IBOT1AJUWmsLDhJ2+O8p04hMR9dfKx8eOPJAhD3EIy3gpMvo8cYskGkg34hPtjPqrtXGMv5+a5AecRqSWapJbiEAYd5o/AzRM9sAfW9lgGwp/8RV8to4ROiPLINIQG48KstQ6tcl6+aA0cPdLgo2PeIkXDNXrqktXRhhe+6gEP1UJZl5cYMXZw7AOy/WfoF5ILMhY6xZImuR5irOK+yxwQM0Qr1P8XmXjyEPyjIIUKe4nYE92DUCqFWwg1499ukl2vavZs69o9Q0vCsqSLXc/ZA4T+fYUBGZPcLIzF6XYvPDLBZ8Rbjj9MkzSLkc6ofXSC6EVq82OX0JZDEtEqg99i35o2KUnM9O5VR2KS704JZVz2SDbUDqRmdRYaUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory block is removed via try_remove_memory(), it eventually
reaches release_mem_region_adjustable(). The current implementation
assumes that when a busy memory resource is split into two, all child
resources remain in the lower address range.

This simplification causes problems when child resources actually belong
to the upper split. For example:

* Initial memory layout:
lsmem
RANGE                                 SIZE   STATE REMOVABLE  BLOCK
0x0000000000000000-0x00000002ffffffff  12G  online       yes   0-95

* /proc/iomem
00000000-2dfefffff : System RAM
  158834000-1597b3fff : Kernel code
  1597b4000-159f50fff : Kernel data
  15a13c000-15a218fff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

* After offlining and removing range
  0x150000000-0x157ffffff
lsmem
RANGE                                  SIZE   STATE REMOVABLE  BLOCK
0x0000000000000000-0x000000014fffffff  5.3G  online       yes   0-41
0x0000000150000000-0x0000000157ffffff  128M offline               42
0x0000000158000000-0x00000002ffffffff  6.6G  online       yes  43-95

The iomem resource gets split into two entries, but kernel code, kernel
data, and kernel bss remain attached to the lower resource [0–5376M]
instead of the correct upper resource [5504M–12288M].

As a result, WARN_ON() triggers in release_mem_region_adjustable()
("Usecase: split into two entries - we need a new resource")
------------[ cut here ]------------
WARNING: CPU: 5 PID: 858 at kernel/resource.c:1486
release_mem_region_adjustable+0x210/0x280
Modules linked in:
CPU: 5 UID: 0 PID: 858 Comm: chmem Not tainted 6.17.0-rc2-11707-g2c36aaf3ba4e
Hardware name: IBM 3906 M04 704 (z/VM 7.3.0)
Krnl PSW : 0704d00180000000 0000024ec0dae0e4
           (release_mem_region_adjustable+0x214/0x280)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000000 00000002ffffafc0 fffffffffffffff0 0000000000000000
           000000014fffffff 0000024ec2257608 0000000000000000 0000024ec2301758
           0000024ec22680d0 00000000902c9140 0000000150000000 00000002ffffafc0
           000003ffa61d8d18 0000024ec21fb478 0000024ec0dae014 000001cec194fbb0
Krnl Code: 0000024ec0dae0d8: af000000            mc      0,0
           0000024ec0dae0dc: a7f4ffc1            brc     15,0000024ec0dae05e
          #0000024ec0dae0e0: af000000            mc      0,0
          >0000024ec0dae0e4: a5defffd            llilh   %r13,65533
           0000024ec0dae0e8: c04000c6064c        larl    %r4,0000024ec266ed80
           0000024ec0dae0ee: eb1d400000f8        laa     %r1,%r13,0(%r4)
           0000024ec0dae0f4: 07e0                bcr     14,%r0
           0000024ec0dae0f6: a7f4ffc0            brc     15,0000024ec0dae076
Call Trace:
 [<0000024ec0dae0e4>] release_mem_region_adjustable+0x214/0x280
([<0000024ec0dadf3c>] release_mem_region_adjustable+0x6c/0x280)
 [<0000024ec10a2130>] try_remove_memory+0x100/0x140
 [<0000024ec10a4052>] __remove_memory+0x22/0x40
 [<0000024ec18890f6>] config_mblock_store+0x326/0x3e0
 [<0000024ec11f7056>] kernfs_fop_write_iter+0x136/0x210
 [<0000024ec1121e86>] vfs_write+0x236/0x3c0
 [<0000024ec11221b8>] ksys_write+0x78/0x110
 [<0000024ec1b6bfbe>] __do_syscall+0x12e/0x350
 [<0000024ec1b782ce>] system_call+0x6e/0x90
Last Breaking-Event-Address:
 [<0000024ec0dae014>] release_mem_region_adjustable+0x144/0x280
---[ end trace 0000000000000000 ]---

Also, resource adjustment doesn't happen and stale resources still cover
[0-12288M].  Later, memory re-add fails in register_memory_resource()
with -EBUSY.

i.e: /proc/iomem is still:
00000000-2dfefffff : System RAM
  158834000-1597b3fff : Kernel code
  1597b4000-159f50fff : Kernel data
  15a13c000-15a218fff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

Enhance release_mem_region_adjustable() to reassign child resources
to the correct parent after a split. Children are now assigned based on
their actual range: If they fall within the lower split, keep them in
the lower parent. If they fall within the upper split, move them to the
upper parent.

Kernel code/data/bss regions are not offlined, so they will always
reside entirely within one parent and never span across both.

Output after the enhancement:
* Initial state /proc/iomem (before removal of memory block):
00000000-2dfefffff : System RAM
  1f94f8000-1fa477fff : Kernel code
  1fa478000-1fac14fff : Kernel data
  1fae00000-1faedcfff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

* Offline and remove 0x1e8000000-0x1efffffff memory range
* /proc/iomem
00000000-1e7ffffff : System RAM
1f0000000-2dfefffff : System RAM
  1f94f8000-1fa477fff : Kernel code
  1fa478000-1fac14fff : Kernel data
  1fae00000-1faedcfff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 kernel/resource.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index f9bb5481501a..c329b8a4aa2f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1388,6 +1388,41 @@ void __release_region(struct resource *parent, resource_size_t start,
 EXPORT_SYMBOL(__release_region);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+static void append_child_to_parent(struct resource *new_parent, struct resource *new_child)
+{
+	struct resource *child;
+
+	child = new_parent->child;
+	if (child) {
+		while (child->sibling)
+			child = child->sibling;
+		child->sibling = new_child;
+	} else {
+		new_parent->child = new_child;
+	}
+	new_child->parent = new_parent;
+	new_child->sibling = NULL;
+}
+
+static void move_children_to_parent(struct resource *old_parent,
+				    struct resource *new_parent,
+				    resource_size_t split_addr)
+{
+	struct resource *child, *next, **p;
+
+	p = &old_parent->child;
+	while ((child = *p)) {
+		next = child->sibling;
+		if (child->start > split_addr) {
+			/* unlink child */
+			*p = next;
+			append_child_to_parent(new_parent, child);
+		} else {
+			p = &child->sibling;
+		}
+	}
+}
+
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
  * @start: resource start address
@@ -1397,15 +1432,13 @@ EXPORT_SYMBOL(__release_region);
  * is released from a currently busy memory resource.  The requested region
  * must either match exactly or fit into a single busy resource entry.  In
  * the latter case, the remaining resource is adjusted accordingly.
- * Existing children of the busy memory resource must be immutable in the
- * request.
  *
  * Note:
  * - Additional release conditions, such as overlapping region, can be
  *   supported after they are confirmed as valid cases.
- * - When a busy memory resource gets split into two entries, the code
- *   assumes that all children remain in the lower address entry for
- *   simplicity.  Enhance this logic when necessary.
+ * - When a busy memory resource gets split into two entries, its children is
+ *   reassigned to the correct parent based on their range. If a child memory
+ *   resource overlaps with more than one parent, enhance the logic as needed.
  */
 void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 {
@@ -1482,6 +1515,7 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 			new_res->parent = res->parent;
 			new_res->sibling = res->sibling;
 			new_res->child = NULL;
+			move_children_to_parent(res, new_res, end);
 
 			if (WARN_ON_ONCE(__adjust_resource(res, res->start,
 							   start - res->start)))
-- 
2.48.1


