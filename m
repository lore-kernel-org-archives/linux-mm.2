Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8D9CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91C88E000C; Wed, 24 Sep 2025 14:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70398E0001; Wed, 24 Sep 2025 14:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC1B8E000C; Wed, 24 Sep 2025 14:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB2E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:41:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B5791DA553
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:41:27 +0000 (UTC)
X-FDA: 83925011814.03.4BB5677
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B5454000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:41:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ROqbQPZT;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758739285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7NMKG3P1GnVF83n8IqcwD90suKkIINheAGyUF6sOvw=;
	b=h+Vgkp77qTQJ61bvoHezLQL3b9UVSexvst7NXke4Hx5ayzAim7m3TOiiurmbMVOkHbyv67
	LiTC65Ali49cWyvx/wDbypaBnJomHSkLmHFRsIiOH/fYDg5O1CB/MX1mw/bR0n3OW8uR2M
	bk/qD2tbSeicl0i9Yaq/dvbfh0+/O88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758739285; a=rsa-sha256;
	cv=none;
	b=fBUoi/V515DJZPqLOntvzrcgss1/12sgmPUOt7+vNyi1+4kWUlSqCt8AZglAI3HLlz2uH5
	lLBiHCzC1oeQecEuGyiXGCJe0lq3liwJZlbO/5HEUGFMJ9UYuuUSelCub3fEKNaMD9xh0x
	1ZV8Qs7CmhP/MMeSOxpegj9hZPRz+xU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ROqbQPZT;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OBedJF003988;
	Wed, 24 Sep 2025 18:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=g7NMKG3P1GnVF83n8
	IqcwD90suKkIINheAGyUF6sOvw=; b=ROqbQPZTh262h7/H0tv+LjTNuTtAv/rbA
	bPfyKQZ/5LjZyvyJn5bC1mCUl9s7snF0SFoJ1vcxNVTKiEW1P9yDZDoJKdMYoxEo
	nW7yb6VG+NxQfoS3TdiTjQ7PfAW1O4S8v43+Peh/xoZpvgpXs4BsCQCB8MFScQRN
	27Ioe2OMl/srIS5Kk96X33Z3POCQtyfE6kEHyymUUbI7bNbxOC0CV7NQ34pgLQJ5
	jplnFNxcJ3XhfyIvi8cwXaZEpOmcab5/REgmJdWbJ9NyFzce/k7inSi5N8irQKyW
	jgLex2ODbrb4dTsiKxjboB/fnQWIfJX6AATFVdAdxsEgvEE8+6qqA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyrjxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:16 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OIfBNZ031885;
	Wed, 24 Sep 2025 18:41:15 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyrjx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OHWvBa030356;
	Wed, 24 Sep 2025 18:41:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a9a19u1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OIfBmf18285018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 18:41:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1498E20043;
	Wed, 24 Sep 2025 18:41:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7C1920040;
	Wed, 24 Sep 2025 18:41:06 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.ibm.com.com (unknown [9.39.28.85])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 18:41:06 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 1/2] drivers/base/node: merge register_one_node() and register_node() to a single function.
Date: Thu, 25 Sep 2025 00:10:50 +0530
Message-ID: <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758736423.git.donettom@linux.ibm.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d43b4c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=TH3b8Etr9zJLuk16028A:9
X-Proofpoint-GUID: GtqF5kG7jmuG2jGJ2XQ8Rrmxy_do6971
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfX6lEmAfAwOPjx
 Np6gukIrwu29sEdWzBwjcXj/jrK/3v+PmXgylMBmQ58aTgOI5vcjya0Rxyn7nVMoGP0Q+qRJXy4
 Pdok1avT99xuu80srjiW/DL6nEsRxoYt1qrBP/qcr6ch2R9dUPqBRO1IZo3ifGG+rchFsSvJfQc
 vcGNkX0FX20lh/o6/0gbbCkn7bo3+eZbnUeFRuyWoIVX4JAgo6eZEjknMKptT+6Ka+Mq+M15nHa
 sc5bpkh3SVFUU3m5Bpz32bGIbiggU93e/6spAvZ2xQaL/FVkUA2tDsaSmB5X5nAMmmT7zb/39lR
 LcpTzo8i6fD8QW5VgTgqjstlMuP+YiqfUml6DSiXqDaDGPmm3PSVdndg3dZLOZ22gcAqGoRt1iv
 E0BNtbg6
X-Proofpoint-ORIG-GUID: AdG4ppAxKg-qqXelHyT3riJZz9eaUe29
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1011 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B5454000B
X-Stat-Signature: f3r6juxrnwr5hpnd3mz9hrhao7as5aio
X-Rspam-User: 
X-HE-Tag: 1758739284-337152
X-HE-Meta: U2FsdGVkX1/VTuJd6DF1T/emmowzoFExRitEkdsbd6ARuab+sFqkw0Pg7beS5h8Jjr7UeiAP2U/R4OhUpdQY/ri31s/19Qfbd9c/iC1fztxvpf4RKrFcwiCsVoxCTASNQgsWicJ7r+dldRxo/8x8Cknmlrl/xMG098I/vXfKiQyuFEYYK9liwgT405SNXCWR9UyxcOZ6sJoFqZaSxwWs45QV0+EY2O7O1MPR7tYvqPSck+8d2PEIK31t5wKX/8GiEEk5uivn9pWyK3EgrorIT5zfzOZV7dShbVMiSo/EeT5NndEBii4uok3Y6Dzwq4uygL4aR8LkUZsEBKdu1UIXGCNo0Wqp2MJTQYonEAGaeqNIHK/NoDIf/f/Npi4T1Vqy1bjElUk9mt4DG7/KnyLfnvBLpCyUvgEfufitoXRBfQGeS/Nr5fP+A3JJM5XykbbFm7atUhqFL4NvGQ1Iv7kINbcpVcjAjS857fu0GVT0nf1/RmjTexmRA1qSXJEBPJ2HUU+8rzaYslmyScuIrgPbSJp0dbInemC8ldqWrWfPA3ONR+tdZYbDfoaw4lGyNni/pOpEd0Ww6dEcmGMMWRgX2VHsXJFONR7nnYy+Wq/6iuRjNU0d8c3m5DJGONGVpT2SQPDj3NrDtObz+PZLrOC8V/HYvAZqsn6/jOpPEoqDRYjeDQVacUOPryhMz2m0eXSrNQHS+kuSxBFeeGIkH5vHqoxba6PtfgBfYgv8FVaU3hdesJHGExrKDIYx5mA9YXgWGHIzlhSzkE95HQNOkx/3q+7cnDGXonYTZCvKddfZ6wdezer5R85IBY76ZHGUCqvBz1K0MMBRbH4w4W3DLlbKqs/OSi7yXSc2FuxE78Rfxmh3UWX8nOV10sTGyZB7PeG2QnChdHETks+QfG1ej/rM9rWorybehSsLfa3qT+8I4rgLMk/LSYBQeVXCgo6HQRHfKbQtZCziZT8wF+3y8s5
 2iqkM3Xq
 TDskhBV+xW+WXOuZGU3vN4aAyZz1epnFBGaaSAK/IB5wHyFI7rSzJnMx92sccDGxxMrCGOg69XUvGg6QZrRuPhhb1pqUwEB6G9VUoHKElwJVXXuf1ipfpFbfz13R39Rv8VHlsaLpQpvK+g7piaBjom3W95qpRcNykb8fJlDftUHP13N3I50gYGai+PaFho5gvfF2a3JSS6ojyyL50+IKr7AY98fXoJZEQDM9Wrn3AY71pVR3ry56n11vvs0iuP9OIvU76v2Ygx0i+AzQr3XITwC+IQ2f1JIrGT+t7tZpm37swCepTb9eHWIKdRdkVjpOowIe48Mx8da6wdi8WIBIuCkqof1voSjqLPAb2Lg88QAuQBh8Z1hvbjBIgq3/vy6zrJkySXhD+Gci5IDyuflK91TbuCTU0tfwUpdF5/3gXfwSP8lIszEkOkoafUWKEHFTJ0RzP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

register_one_node() and register_node() are small functions.
This patch merges them into a single function named register_node()
to improve code readability.

No functional changes are introduced.

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/pci_dlpar.c |  2 +-
 arch/x86/mm/numa.c                         |  4 +-
 drivers/base/node.c                        | 52 +++++++++-------------
 include/linux/node.h                       |  4 +-
 mm/memory_hotplug.c                        |  4 +-
 mm/mm_init.c                               |  2 +-
 6 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index aeb8633a3d00..8c77ec7980de 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -29,7 +29,7 @@ struct pci_controller *init_phb_dynamic(struct device_node *dn)
 	nid = of_node_to_nid(dn);
 	if (likely((nid) >= 0)) {
 		if (!node_online(nid)) {
-			if (register_one_node(nid)) {
+			if (register_node(nid)) {
 				pr_err("PCI: Failed to register node %d\n", nid);
 			} else {
 				update_numa_distance(dn);
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index c24890c40138..7a97327140df 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -262,7 +262,7 @@ void __init init_gi_nodes(void)
 	 * bringup_nonboot_cpus
 	 *  cpu_up
 	 *   __try_online_node
-	 *    register_one_node
+	 *    register_node
 	 * because node_subsys is not initialized yet.
 	 * TODO remove dependency on node_online
 	 */
@@ -303,7 +303,7 @@ void __init init_cpu_to_node(void)
 		 * bringup_nonboot_cpus
 		 *  cpu_up
 		 *   __try_online_node
-		 *    register_one_node
+		 *    register_node
 		 * because node_subsys is not initialized yet.
 		 * TODO remove dependency on node_online
 		 */
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 6b6e55a98b79..eab620e29c78 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -638,33 +638,6 @@ static void node_device_release(struct device *dev)
 	kfree(to_node(dev));
 }
 
-/*
- * register_node - Setup a sysfs device for a node.
- * @num - Node number to use when creating the device.
- *
- * Initialize and register the node device.
- */
-static int register_node(struct node *node, int num)
-{
-	int error;
-
-	node->dev.id = num;
-	node->dev.bus = &node_subsys;
-	node->dev.release = node_device_release;
-	node->dev.groups = node_dev_groups;
-	error = device_register(&node->dev);
-
-	if (error) {
-		put_device(&node->dev);
-	} else {
-		hugetlb_register_node(node);
-		compaction_register_node(node);
-		reclaim_register_node(node);
-	}
-
-	return error;
-}
-
 /**
  * unregister_node - unregister a node device
  * @node: node going away
@@ -869,7 +842,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-int register_one_node(int nid)
+/*
+ * register_node - Setup a sysfs device for a node.
+ * @nid - Node number to use when creating the device.
+ *
+ * Initialize and register the node device.
+ */
+int register_node(int nid)
 {
 	int error;
 	int cpu;
@@ -880,14 +859,23 @@ int register_one_node(int nid)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&node->access_list);
-	node_devices[nid] = node;
 
-	error = register_node(node_devices[nid], nid);
+	node->dev.id = nid;
+	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
+	node->dev.groups = node_dev_groups;
+
+	error = device_register(&node->dev);
 	if (error) {
-		node_devices[nid] = NULL;
+		put_device(&node->dev);
 		return error;
 	}
 
+	node_devices[nid] = node;
+	hugetlb_register_node(node);
+	compaction_register_node(node);
+	reclaim_register_node(node);
+
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
 		if (cpu_to_node(cpu) == nid)
@@ -980,7 +968,7 @@ void __init node_dev_init(void)
 	 * to already created cpu devices.
 	 */
 	for_each_online_node(i) {
-		ret =  register_one_node(i);
+		ret =  register_node(i);
 		if (ret)
 			panic("%s() failed to add node: %d\n", __func__, ret);
 	}
diff --git a/include/linux/node.h b/include/linux/node.h
index 2c7529335b21..4dcf876cd0b4 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -168,7 +168,7 @@ static inline int hotplug_node_notifier(notifier_fn_t fn, int pri)
 #ifdef CONFIG_NUMA
 extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
-extern int register_one_node(int nid);
+extern int register_node(int nid);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
@@ -181,7 +181,7 @@ extern int register_memory_node_under_compute_node(unsigned int mem_nid,
 static inline void node_dev_init(void)
 {
 }
-static inline int register_one_node(int nid)
+static inline int register_node(int nid)
 {
 	return 0;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..6c050d867031 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1311,7 +1311,7 @@ static int __try_online_node(int nid, bool set_node_online)
 
 	if (set_node_online) {
 		node_set_online(nid);
-		ret = register_one_node(nid);
+		ret = register_node(nid);
 		BUG_ON(ret);
 	}
 out:
@@ -1542,7 +1542,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		goto error_memblock_remove;
 	if (ret) {
 		node_set_online(nid);
-		ret = register_one_node(nid);
+		ret = register_node(nid);
 		if (WARN_ON(ret)) {
 			node_set_offline(nid);
 			goto error_memblock_remove;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df614556741a..e1a19a3dadd7 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1909,7 +1909,7 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 		free_area_init_node(nid);
 
 		/*
-		 * No sysfs hierarchy will be created via register_one_node()
+		 * No sysfs hierarchy will be created via register_node()
 		 *for memory-less node because here it's not marked as N_MEMORY
 		 *and won't be set online later. The benefit is userspace
 		 *program won't be confused by sysfs files/directories of
-- 
2.51.0


