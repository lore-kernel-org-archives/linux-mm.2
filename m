Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCECDD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 05:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C496B0005; Sun, 21 Dec 2025 00:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5676B0089; Sun, 21 Dec 2025 00:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD50B6B008A; Sun, 21 Dec 2025 00:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4636B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 00:37:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3185A140796
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 05:37:17 +0000 (UTC)
X-FDA: 84242370114.22.8605E8A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id F3DE7140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 05:37:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kxRKsLeq;
	spf=pass (imf23.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766295435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cqxenW3eTMrmUzN1izliAYJlLBq9s39JQlwm88uLnZk=;
	b=fNvgYS0b2AIW3oeJ+riIVti/7rYrIjemOXun+dafaAtRQetKg7dpgE0I9PprK7/cy0IwUH
	exU0yMUTdjKCFhAWiL6xal7m2WdTGXJfyHvt8HMPgvA7w8gdshF7vkyteu6IFIX0ERRDPw
	//oO+W8rplKNkd5OqhRr6+b2H4te8NY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kxRKsLeq;
	spf=pass (imf23.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766295435; a=rsa-sha256;
	cv=none;
	b=rmNx5XU0sKqqRRu/wOF/Eii4vkISDg2rnPutgc/chkyXz8k1TEAiQ+eEX+OdxGDwJmVjKz
	A0yqLRKBk25DaMqop9IV/yDUyJETmyIgr0m2klSa5FoKC+afcfsBvg/MxFZHN0zq30kOtT
	34FtSsHXy+F3HRZ2Q+gUfflJE0adgW4=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BKIoPsO022712;
	Sun, 21 Dec 2025 05:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cqxenW3eTMrmUzN1izliAYJlLBq9s39JQlwm88uLn
	Zk=; b=kxRKsLeqBYwyVpQiJXJb1YE3w/yESnjk3yNZ2/mHOxEerz6pNc6+qY8oI
	XyHgS3bROoz+CRBn5hlyDMqzra1fOauqgxnLlMdWMSIo2ZGke/3SpLttWPr4Sl9t
	pY899nwugLs2UO15XlTUoGVDfuuLC2tADQ9vL49dRaLItVwoVojOnEtkHRVKtdH1
	W4gufMX49oqJIz5ZD0+kNwCQ1i+kNM81Tw5pPC+BhcR+MZ2GO7UJ6WBY1Ax9hKuF
	nPYzrgdK0jVXe+wPQzjBI783S+NmevaMBH2vkR1GOfVgxu3TUChHnevEmVtmLZlA
	wR2na8s0RqGwcjqVRvd1mrWxbymJg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketk3h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 21 Dec 2025 05:36:45 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BL5aivp023120;
	Sun, 21 Dec 2025 05:36:44 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketk3gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 21 Dec 2025 05:36:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BL3FPUD032332;
	Sun, 21 Dec 2025 05:36:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b68u0rb3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 21 Dec 2025 05:36:43 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BL5addg53018994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 21 Dec 2025 05:36:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABD3220043;
	Sun, 21 Dec 2025 05:36:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA73D20040;
	Sun, 21 Dec 2025 05:36:35 +0000 (GMT)
Received: from li-4f5ba44c-27d4-11b2-a85c-a08f5b49eada.ibm.com.com (unknown [9.124.223.251])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 21 Dec 2025 05:36:35 +0000 (GMT)
From: Sourabh Jain <sourabhjain@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org, linux-riscv@lists.infradead.org,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
Date: Sun, 21 Dec 2025 11:06:11 +0530
Message-ID: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IkuzYnWWG9IjSp_0Gla-YCTWDZ3vkUNM
X-Authority-Analysis: v=2.4 cv=Qdxrf8bv c=1 sm=1 tr=0 ts=6947876d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Z4Rwk6OoAAAA:8 a=1UX6Do5GAAAA:8 a=20KFwNOVAAAA:8 a=37rDS-QxAAAA:8
 a=voM4FWlXAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=4Gij-p89FXQWKqtjjkgA:9
 a=HkZW87K1Qel5hWWM3VKY:22 a=Et2XPkok5AAZYJIKzHr1:22 a=k1Nq6YrhK2t884LQW06G:22
 a=IC2XNlieTeVoXbcui8wp:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: eQTIUVpUUHp_XrIuF6PTtd0qUoTnYCSL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIxMDA0NiBTYWx0ZWRfXy3ULg6E+ewT8
 X/SzCzVkCaMVY/+7LKrZ53JGDS1u0TNM9ikOkxdJen8eXdRW1MvtlSMUI5e3Q2WNEzbMx3YV/0g
 nEg1fR0u9IXP2kfF9uyiLDOPXM4kEBc/wcCUEe+vqDTXmJD83bEFHIzKjRI9Zyq5OCElK4k7D7L
 1+c6YmzKoHN4nLqCKxO17kYAw0WBVMf93r0XEEy1ynYL28fUSmKUfeXbjVgNc3wMzsSC4NIP2ot
 Uczj8vR4wcIcEqfiAWdmQq4p+1U8t1vaKE0dVjyEePAORKtTAyrx9T7vvdPXRAC9IadlrwY5hct
 +64NMyn/ozJd4AwGa7A3d4LyzwaoZlQu4rxa9bJCDc7cem/uh7cm6KOIW1kkECz2zaoANu5b5+P
 xcR/uZGUMqiT6fTU5TNe2/k9r7Dn5cLJAQcroyZ75eXIIuxTkw3FOUlBMPVwaIrO2wiMTAcJfPM
 UIPNhyzvNFuUINUxGVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-21_02,2025-12-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512210046
X-Rspamd-Server: rspam02
X-Stat-Signature: ptxgguokbjmaqhputh7xjxj3mtdb3hf8
X-Rspam-User: 
X-Rspamd-Queue-Id: F3DE7140003
X-HE-Tag: 1766295433-226482
X-HE-Meta: U2FsdGVkX19790+BDzchoNjsaBJfJbY01+1HE2oNgEAsNsYLL4uCnoSVkhaNCSC2FSNkBJ7vYRBy8Z4vOxS+EOzevZPNDGgaw6F+b+CQwyAiIlZUH5uh9aJGeo8581xOzsnDnECuJ//B3tnqEgAZcDlcIOjipuqS9tYzRmz3t/XLLH6yrZJ/FbWRREEgyDEQ70eCouewJLtmAWn+PXSRq/2xSHA3v5C08tPIB+UOm09Fm635uUdHDnwHniSxjq02ZbSzZBjLADlsYQzMgZ6ZYj+zQwKpxJP6ecUUYjaAICBVILW40wjp/F+rLIezFShIyu0dcev9QIOp+SzXmWxLXgFuAvY0F6lCZQYQgQe9UhCxZzYGMX91RWTej4PxoNgmexR5MBx0D5ehugGjbraKHXR+jp5yxp7WgAMlZImzzbSHIf/PlglM9t/ndaC8q0Bt60+FmBmDx4XvG2ZMJWtBklLs23WZPcc9E91LFcRt6YLqYZdCQ0WYAcVAiGH6muHUSCuIbIJKtf4PGfm8Qlk5rl+gUGX5xb6XHcyjaT5U8T/YV8v8zcpSMmk4paPdODVPzAw/eWPYdX9BDic4nPf9QG2gFGimHQhb3DMmXEQMigK9GKZkAnHVFxSqKsXZUzS2KCaMOCtayjr3pbzEe7NPqBy6t7ySrdaSCdQNXq7KF4DhTnJz+zi8wFb8mP6ufri/Hzv6cnkHoRklQztk1xCaNnk2mTjScCodYyUqMrZNqZVgUx94vWWZD/rlocKeUZwnQIrcA7Qs9kcmrZHuUMlVc93iPXELNRXx2TNpaq173e89IY3SUp16rLwmnPbrAMpa0A3Bzpsq3+gdUO0hMkfsIrZwCsdD0xQk9SC5MKgIe1SbYYuy9/tfRRFbgNVJReKUsRU0HqjJFLA6SLa+Y6guCtbgP3Kw0av5emrfm9JlTGo75f2ngW8QCCekErdFny7VstAs/Q4suLlDKawAwJs
 SjDMAHti
 zI1hay72Ghm5FCgRjJVIvwdsvpPCvAokojYXhBxecVmxOasS64yNVKAiM4Y66O49j3hxl3FzTSaRCWR8EYwGZ7GEORn3S6soXA5cWVCbdDbq5UdzllVMH1VxfOr/Eg+cbaI6lcY6L538mFT1RD9JRxRcA/y1onrLtrOXtgcXCEFchdrMhuFzwOL75VgaKBVvmyweiJSu7UwK4o1p3JkBz6gGbSkKxlXF1EmX5LXiV3mgDTiAWGzMjS+eAcfnfVDF7xi73o3u0+GkyJ/ulBpea22r5TD1gqWq5Chp/C/mAUHvrJBq6qBfhFQhM4BFvEoZatoLdKJ3xcUP1kxXchN+avGoeSz/0WnoQHQYaH4zOA5B9FVZ3zcjepKbJXQV5aQzf93EN7bE/zzVCrGCTvutpCx1yvgN2Ov8wAvXISptRvJKJwR6ewhLrJQP+sS8+Pf1G6ow/pUMR4BTcObd5y8WMdRiILeY6kD17xyN6H6d9RUEt+wABMLiDC0xM1wUsNa+hZ7/VZL5ug3oOhbMtUZX9taIRqpOe3oNTfkzuEXU8GReW76TDw4ScZT14KPmZZIPzc3MmX/vkSL6tQxh63pIQ3FB6JTsvWQE1alI98l4FJAgP6SlyoZoG7cUoDoPtQZWahkbXrf3RDAzPsVXLvxi/gzx+dtomb58hqHzzgj+kmDgSA+f5rht0Er/Jx5Djn7OlZpV2Y16KBuhto0tngWHib+BTrZW58AXcwReF
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

For example, when the fadump kernel boots with the following kernel
arguments:
default_hugepagesz=1GB hugepagesz=1GB hugepages=200

Before this patch, the kernel prints the following logs:

HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
HugeTLB support is disabled!
HugeTLB: huge pages not supported, ignoring associated command-line parameters
hugetlbfs: disabling because there are no supported hugepage sizes

Even though the logs state that HugeTLB support is disabled, gigantic
hugepages are still allocated. This causes the fadump kernel to run out
of memory during boot.

After this patch is applied, the kernel prints the following logs for
the same command line:

HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
HugeTLB support is disabled!
hugetlbfs: disabling because there are no supported hugepage sizes

To fix the issue, gigantic hugepage allocation should be guarded by
hugepages_supported().

Previously, two approaches were proposed to bring gigantic hugepage
allocation under hugepages_supported():

[1] Check hugepages_supported() in the generic code before allocating
gigantic hugepages
[2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes

Approach [2] has two minor issues:
1. It prints misleading logs about invalid hugepage sizes
2. The kernel still processes hugepage kernel arguments unnecessarily

To control gigantic hugepage allocation, skip processing hugepage kernel
arguments (default_hugepagesz, hugepagesz and hugepages) when
hugepages_supported() returns false.

Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-mm@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-riscv@lists.infradead.org
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
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
https://lore.kernel.org/all/20251218114154.228484-1-sourabhjain@linux.ibm.com/
 - Significant change in approach: disable processing of hugepage kernel
   arguments if hugepages_supported() returns false
 - Drop a Reviewed-by tag

v6:
 - Updated commit message with additional logs and tags
 - No functional changes
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


