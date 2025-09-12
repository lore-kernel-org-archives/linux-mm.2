Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C083BCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C868E0007; Fri, 12 Sep 2025 08:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174818E0003; Fri, 12 Sep 2025 08:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064E18E0007; Fri, 12 Sep 2025 08:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB3908E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:30:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73F35BB4D3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:30:39 +0000 (UTC)
X-FDA: 83880531798.05.59675A4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E5C740013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:30:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Qw+89lj/";
	spf=pass (imf12.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Urv9ho9Iqt11s8undguJ4H22kdSFOgvvZ5cOGTJ+/eU=;
	b=b/F8lxVC37W1ZMKSQ4h9XrPK7FVklWfV+M1mzqwIebwZZ6Qn3ub0B8W4HQAcV8RYIQ+Q/A
	zw7UvHqJbdHWUh3yZxTvTEKEuMKLW66XGGqds2Td1ln9YnWsyq7qMsq0r0/LWQF8QF9qaY
	hKT8yff8VFJ8oa8uWMHZEETNwB7DYow=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Qw+89lj/";
	spf=pass (imf12.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680237; a=rsa-sha256;
	cv=none;
	b=ynYQev8pIW0/3bWw8eppbsG6ATewt25IQuLnJQAx60xrs2TgLEAk0fSgZLc6UVpIPRQrzs
	h7AsRG5pVbAn/SVdbCMdths57nN7CXdPvGeSpfaoF05Xeuh2O5dobxp98aTx1W2uB5xV6h
	tknmKnWUpkkANGoW1sbl+d0xk2SSI8Y=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1frKi028317;
	Fri, 12 Sep 2025 12:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=Urv9ho9Iqt11s8undguJ4H22kdSF
	OgvvZ5cOGTJ+/eU=; b=Qw+89lj/Q0CKqoICJCtHvas+tx39zFmDc5hj9Gicq9lz
	gahHb+u+ZL/e/plfOtI8C7rk5irquzQLmpyuArl2Jb0J6Q83h7cWWK8kzqNgJ/Qj
	CTtRmu78Ow8FtpXKWj4RXMv8sxWysdr54B8Tdj+pl1PoKsiSXyeS+tWJWA8uPqn6
	SYjHLUkVc+ap0WmOzaUmM+lfDJZ7dWYN4ptRKNUziXo0quANDRvPnQAV+AnzRb+2
	Gq+SGnSEi4IiS0SKSz8DvCa13a0iO4FrEIs2kpv8v2Y/8M+5J8TtzvW6dj2AfGs8
	nE3y2qPxWPuZcIwhSj2/nF/yl/n9cxKDobh8+g+pmA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmxbf7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:30:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58CAwWAW017181;
	Fri, 12 Sep 2025 12:30:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmtqww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:30:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58CCUU1S21955026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 12:30:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DE4120040;
	Fri, 12 Sep 2025 12:30:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FA882004B;
	Fri, 12 Sep 2025 12:30:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 12:30:30 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        David Hildenbrand <david@redhat.com>
Cc: linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, sumanthk@linux.ibm.com
Subject: [PATCH v2] resource: Improve child resource handling in release_mem_region_adjustable()
Date: Fri, 12 Sep 2025 14:30:21 +0200
Message-ID: <20250912123021.3219980-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uMoYrLT0iW4OQ1UgOgoxU0W3PO5nWRMp
X-Proofpoint-ORIG-GUID: uMoYrLT0iW4OQ1UgOgoxU0W3PO5nWRMp
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c4126a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=9XsctY_nk5j_wR6wWCgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX7WFU4E+yg89y
 8oIGbv5n7CV5IentjEmKS5isO6fkcOz3nx5Rvr23eYf+2UBpK5JSEHskZaU3AkkN1gs9UcHaPa9
 ZsjGGjIP19i/SLodLlXo0taXSkQurYIgahy6OPHXcEGwrFV5hu1D12Uz95bJMtq36HL0WYwx/iC
 hKl18wMEXQxHDjhr1MDGNoBCaYqMmdhX0+IAriCP76j0wGKWTitSLqKDFjrtumtAdB0SlCV2f9Y
 uIuWnjaKCa12jxBRwedeE9OdLnN9e8Pkczajk3hmaucgD9kCCJ74NvpssAU6076eW/HC+L2TY1e
 QMqztLZMRjMxa0DLmI4xCdwjw4yVmZkaLg+hu9FO0OafFKg7mKZc+e/ddkl0PuJnhrQerQU5EGF
 t1Xkzpf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025
X-Rspamd-Queue-Id: 1E5C740013
X-Stat-Signature: iers6jjmkootb9856uzy36eqourpbtei
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757680236-238506
X-HE-Meta: U2FsdGVkX1/0WaRWQb9+UyBRh8L6HpP1fQHU/bxGuPcVBjhWk8l1DDjS8VjYPk0i/TZaT48BgqJLZ9ZSUhFyi0O/jKc42JBuBHMxm7BY94CrTQDfs3WoTmrl0+FoAim2YJLHqxNnObszg4I7l7w4u818gP4k1ZkHGgbUDddXDHlhgbjPumhOpiTI3jEpx8YOkwU/W15tuAtoZVeOj40S8W9cmy5ihfI9MnTsajWSnIdXEjpS40hR8Kwylv2xson8w9nEFGf1zJlC0gB3VkhKtVK4NRvaMTQOM9hVSa8JJM2Jdr/XrR0eIKqDPcGQ/3UFRD+EBbzirXOQdKn7E+i88tmOS3dv5cdNrzkGtWPeoL5BYjDD5VJbDHoVyem6VX8d+uwm5v/F1+ALQ5BhUum2jL/aF6lTTdrKtwlwPLSQnc5CUab0xhePqFHtk3FJkJwbX294p+rgraSZt7TbYGYrjfZ1vMcQI/NDgjWgVkU9Bx4GWX9y9igmfvUN4kIRrIA2w0Hi0KiXUWKdf4JwYy4W1ROZ2ngTqOmxg1+Z0N2TuUxrDn/7mM4Fcrr1SeDj1d76r2P2hNXtCPd2cTMDhAEnOHB0ZhuNlaW7fdW64AWLUekra81MiRz3HlEhtPGXpFsviqQkeZfBEqiKRQxjZF7XDJQhc793ko7drTa6WVfMnvzyPqdqfIGd38jacnTdGCnsEa2INBltuXncmijME/K7EM3zC4dQBXxZqwt9iB2Qh9pWSGCVqsasbwyoTCoaniO7nYU0AclXSN1n++wyEelzJKmoH7wawIOxUHvWN2nrxIHmJFXiNO3kc0qnq0+QWY6CEm5+wrWFV/e2L6ZO18kcqVMZbSXEeC2ayuRguqnWgOiNb93QYAUI8xVS0FIxwGyRia6PnQE7F+jWaqHIOPIO1leW5VcW/zWCzgcYpmfjx+f8ajvCsqLVH+6AH6mXFXZIjZkQU+yIe8SYpBrdozP
 sxdKpG3Z
 cnH5Su2WaWEjuHhJebU4O4mA1OAaDihM43qFX/7RCI4g7j4318oGicmpZQ6NAoyUacAawvwyUBoUNdz/fCpWScoPamRrc/gkHCi+hOaH3K90LgjaNLMaeOYE++WSzFQrAp/ZLJt5hwsrdROVZiAv+uVI8Umg9JP0ibTTOKmQnJod3qe4l1AvVO3i0cruWoUqqARdynA+s6hKdHo/dJInNiFVhK++313QmrXiUY4i6fWQR5C/hUypp2CUcYPY74pakOeO21DWNcKKAUwGxKibPXd/snd3o45nXBxWXKuYrfNFfAIg8rBd4bqTBeBibal2zO2D1uJ2p+7y1R51DqpxGmSV9Xw0K6rF2t6he3+FPG+XPDGXLrcA+Vyb43jiqEj5BkdOr+DZTi8QFcoTuNCqiEzXw19AIhZqsfW4f
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
lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED
(output according to upcoming lsmem changes with the configured column:
s390)
RANGE                                  SIZE   STATE  BLOCK  CONFIGURED
0x0000000000000000-0x000000014fffffff  5.3G  online   0-41  yes
0x0000000150000000-0x0000000157ffffff  128M offline     42  no
0x0000000158000000-0x00000002ffffffff  6.6G  online  43-95  yes

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
Add review suggestions from David. Thank you
* Rename move_children_to_parent() to reparent_children_after_split()
  and add comment.
* Replace "is" with "are" in release_mem_region_adjustable() comment
  section.

 kernel/resource.c | 50 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index f9bb5481501a..b9fa2a4ce089 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1388,6 +1388,47 @@ void __release_region(struct resource *parent, resource_size_t start,
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
+/*
+ * Reparent all child resources that no longer belong to "low" after a split to
+ * "high". Note that "high" does not have any children, because "low" is the
+ * original resource and "high" is a new resource. Treat "low" as the original
+ * resource being split and defer its range adjustment to __adjust_resource().
+ */
+static void reparent_children_after_split(struct resource *low,
+					  struct resource *high,
+					  resource_size_t split_addr)
+{
+	struct resource *child, *next, **p;
+
+	p = &low->child;
+	while ((child = *p)) {
+		next = child->sibling;
+		if (child->start > split_addr) {
+			/* unlink child */
+			*p = next;
+			append_child_to_parent(high, child);
+		} else {
+			p = &child->sibling;
+		}
+	}
+}
+
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
  * @start: resource start address
@@ -1397,15 +1438,13 @@ EXPORT_SYMBOL(__release_region);
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
+ * - When a busy memory resource gets split into two entries, its children are
+ *   reassigned to the correct parent based on their range. If a child memory
+ *   resource overlaps with more than one parent, enhance the logic as needed.
  */
 void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 {
@@ -1482,6 +1521,7 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 			new_res->parent = res->parent;
 			new_res->sibling = res->sibling;
 			new_res->child = NULL;
+			reparent_children_after_split(res, new_res, end);
 
 			if (WARN_ON_ONCE(__adjust_resource(res, res->start,
 							   start - res->start)))
-- 
2.48.1


