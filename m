Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FAECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A7B8E010A; Tue, 14 Oct 2025 11:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FADD8E0090; Tue, 14 Oct 2025 11:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2D58E010A; Tue, 14 Oct 2025 11:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAEFA8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:39:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7EC0BC1BD
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:39:52 +0000 (UTC)
X-FDA: 83997130224.20.DA8246A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52AA540010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:39:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OmRZrm27;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760456390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxUrK5mDuQQdcL/1nI7pZ0hwWHZpR3ReXdRPzdYa4nc=;
	b=8fg99jTlMUs8d1GoeCcZJ9jyxEs1jX63Kt+TQQxr4ZoItsUiBjcnJXPveneGXYkSG26K3A
	83rTM46KtA1lYgYITxgtTGD8D0ncRFXCR8cxWzzJaRvYEDvTGbeT8P92GpVqEG6NcTV09v
	nfSPQ02/y3vNuYcD9di5SlAMfuPYePM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OmRZrm27;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760456390; a=rsa-sha256;
	cv=none;
	b=0hGsdDGr4Urt67I//NFQE35PeDRAEecv1xqKJc93ys2u3N7x9ZNZiOHZ/7YXkNN4yHlLTU
	p6ZUGU18TE1myJtK68vP9OdEHOZfyuL1dH/MKjXSw6QIeNV8vz/CN8HcNyneUINzDSBrFI
	vbQXy4HL+OiS0y6DDk8gd+zGHvm75u4=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EAoD53005409;
	Tue, 14 Oct 2025 15:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bxUrK5mDuQQdcL/1n
	I7pZ0hwWHZpR3ReXdRPzdYa4nc=; b=OmRZrm276/AR3tNiz4XMiKPqfTVu376WW
	nGA/d+0o+cixIDkZauIg3nW8VdebckJq9VwuuWoLJ52YysDFIT/kiTAgoWWDN/nc
	IT4/ICgQb4NDaX2ldIPol9vB4d7j6/Js0f9pEa3QQosLgC8ZMdnr9QWVBsfP6L0f
	3hF5+UeuWJZLGv5voNK8FCvbHcVCOR3gv6r1zgC1/Q6aLl/fkZ3TvnTaJienYLwb
	2NNRUBZPFuFHCFi+6alk1f5lzzu/ybpx83HM74nVu2q59YJYLnipZWcAik+i11Ey
	a477Nj4RoxukkJmmT9eP/DIPCczxYyJp6fTgyJmPxlhdkeDihmZtw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewtykk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:42 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59EFSGYX011723;
	Tue, 14 Oct 2025 15:39:41 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewtykk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:41 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECQl1P015466;
	Tue, 14 Oct 2025 15:39:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r3sjbf2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EFdaZF54722868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:39:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A615620063;
	Tue, 14 Oct 2025 15:39:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F280A2004D;
	Tue, 14 Oct 2025 15:39:32 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 15:39:32 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Danilo Krummrich <dakr@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v2 2/2] drivers/base/node: Fold unregister_node() into unregister_one_node()
Date: Tue, 14 Oct 2025 21:09:17 +0530
Message-ID: <32b7d5d8f0f30d313c3e1d8798f591459c8746f9.1760097208.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760097207.git.donettom@linux.ibm.com>
References: <cover.1760097207.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yJIK9-_5djzOKGKQafVnvJ9SS2_gUE_j
X-Authority-Analysis: v=2.4 cv=Kr1AGGWN c=1 sm=1 tr=0 ts=68ee6ebe cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=UcWcCGp8pzElTzXvTKcA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 2bKGYSZSR7SNTxLnOiQcOih4YoU9csj4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfX90Pz/i1QSsh5
 AfisJLb7AkokL6nQ6Gj0GUywwiRKpuU2aL0YxNo8/6IYodrR/g0/1Bme4kSocUIF3q3B++6X74i
 SjeOtl8B6CrHxA9i+tFwHSnJLkTgZsXY/EvnO87PKAm58Sp8PzbkIH7PKz0Gt7f3K3i94coc7B8
 LETkx58NBaBUEaRfLmStLO+MEOQ0DxVxJqmGgUy9a/H+4qJ40WMCpuE9B66sOcvorBw+jJt/3ws
 ME/rLRW4naIhBbLg2NP68j5OL6dQRes6pRPuaJW1eYX4Uxzzf0PfMHq2WOWMrhAtSyCpwIE1b5C
 cFBqmFrEn8c2s49zgWk2lLq4ZNeNtSvDU8//xDjCND4AOhcMZSU2tu3eolkqHcARqmqyzym5yfL
 KVRp4gI3BkWiH6R2HFWFSaaSoBWpEw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014
X-Stat-Signature: q3f3nfbf353i9bssqyzh1y94qjz38yjc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52AA540010
X-HE-Tag: 1760456390-710070
X-HE-Meta: U2FsdGVkX1/7Mn6yZXhDg3i/vCCWypXNcK3Bv82oraUmZRyUjNDcJIX9F2DGuufYnjGQwRTZrkYl4l3w7gl5idnZIC6HV9lnOu6+XIV2D5QIaQZvfs8vDfk+8UvsR842Qw8jmPthS4eXRgi+g7wNPWi3qG+8BYsLZhTJsSEF3Y1PdGTPkUxmqD7BRBSItsAJn+vZA4ibgQqcfJnclAhwkDuuAKN21GGsTh+JLGc5jTVqr4AphweCiN/Y7CeTgZ+HU2/1VxMf/Dm6bpJiXf+jf88ESc07nWdkitu1Jwg16TVEnLwI7PjliyfxG3NDp9T6zMj5HjJL19y6xsg0G2eroNuhPeLgOWHhcKpATtfCzXv+Ba7P7T4ArV6B3YDKgypXBkQX6xNvTOjXegZmRF00cBDaXFGzjgNUXkdGW3Xlz2eS9mj9Rikr2aj9jSmKW0mCt72U5b64S4tdYuP/7gkYoyOJ31oKWJMSGSVEw3ss7w5Wdi4B+4fZMEE4+cp1cVeaBoduK+GCZT5atO2xisXqpkXZhmjwqyEmNC78crlRnWGJKa+x6XWSPFRwgK2ebY8Ddwsj1T3zQxNMcP8/dX//dIWP5zPdufQSTY0glD9B4N5QAIonFjPTdkuCzTYzkHxtmINc9PkOeiwpiKVPXI0HSeDAG9+mhv6qAYiip7NOu+PXGdtYWROEORozWwA92lfWnUym23Ii+ax3okdMJH/ZbQlQKbiUpjB3RICkFEIjyk9G0GdCJVzTjXmuTd4zZT7NPAp9MnyE+jEvE4WiypCyOvXj1zmUL0afMlGE+YMkjInL6+UJMPS00cKzL7fkkOPGfAmHo0nUJfez2EMHBjwRqG6xPODTl1vL2UIJv42N/d7hpj9xlczWoPpew2HA1zu/qsjqIZPUpvZ7hotyJvMIVs928J1Gmu0oPtp+nm8G9t0TzLdV9qFWG2T7sRvvOnUG2XtC7jyBDezoOPnEo7P
 JQUHh0es
 cWzxAHq7i1bPdWAJMWrWP8zhQAbSpOzv5d2ny06jkQWfh9devP49lha0jcrDNXtD43XRQimsvMH1JxN4/BPp12UZl6kQxaATbZDUjPW3lqVC+8l9yDGVWkrOyUEE5sKR3uUYuT3D/3lRBzFC2nav88o6r/o4a15UQDEESmSP4ZpbJyGQC8cY1IhqixpVSLcGodGPOCMu5YnQ2FlBg56eyx7ksK5So5y04huZbLUhKsOtdNv9llF+7yuGDfrNr+CNc/XuGdlhkcUz3IVYdVkC3bU4rJq+772kHfX1+VUCb28GdAl92NAOvNglrx6fTZ7QH8k5yFfNqskAmG1DrmnV41gibEbUt59BiPjMVIf3k3GC1WBqRWbua2iQb9rZP7sq+RxLMu9+Q7yxAhgsXO5qDDy13FftvnnGk/94qwqIowoqq8MQf3ect2kuBH/t+CIuS0mnmiU9H7F8cJITonLeCoyafd74hUMnETKDtRhm+ffgbppc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function unregister_node() is only called from unregister_one_node().
This patch folds unregister_node() into its only caller and renames
unregister_one_node() to unregister_node().

This reduces unnecessary indirection and simplifies the code structure.
No functional changes are introduced.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 drivers/base/node.c  | 38 +++++++++++++++++---------------------
 include/linux/node.h |  6 ++----
 mm/memory_hotplug.c  |  4 ++--
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 4bcaa8006cd6..758b777dec1f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -676,23 +676,6 @@ static void node_device_release(struct device *dev)
 	kfree(to_node(dev));
 }
 
-/**
- * unregister_node - unregister a node device
- * @node: node going away
- *
- * Unregisters a node device @node.  All the devices on the node must be
- * unregistered before calling this function.
- */
-void unregister_node(struct node *node)
-{
-	hugetlb_unregister_node(node);
-	compaction_unregister_node(node);
-	reclaim_unregister_node(node);
-	node_remove_accesses(node);
-	node_remove_caches(node);
-	device_unregister(&node->dev);
-}
-
 struct node *node_devices[MAX_NUMNODES];
 
 /*
@@ -924,13 +907,26 @@ int register_node(int nid)
 
 	return error;
 }
-
-void unregister_one_node(int nid)
+/**
+ * unregister_node - unregister a node device
+ * @nid: nid of the node going away
+ *
+ * Unregisters the node device at node id  @nid.  All the devices on the
+ * node must be unregistered before calling this function.
+ */
+void unregister_node(int nid)
 {
-	if (!node_devices[nid])
+	struct node *node = node_devices[nid];
+
+	if (!node)
 		return;
 
-	unregister_node(node_devices[nid]);
+	hugetlb_unregister_node(node);
+	compaction_unregister_node(node);
+	reclaim_unregister_node(node);
+	node_remove_accesses(node);
+	node_remove_caches(node);
+	device_unregister(&node->dev);
 	node_devices[nid] = NULL;
 }
 
diff --git a/include/linux/node.h b/include/linux/node.h
index b7028d3ec3b4..0269b064ba65 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -132,8 +132,6 @@ static inline void register_memory_blocks_under_nodes(void)
 }
 #endif
 
-extern void unregister_node(struct node *node);
-
 struct node_notify {
 	int nid;
 };
@@ -177,7 +175,7 @@ static inline int hotplug_node_notifier(notifier_fn_t fn, int pri)
 extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
 int register_node(int nid);
-extern void unregister_one_node(int nid);
+void unregister_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern void unregister_memory_block_under_nodes(struct memory_block *mem_blk);
@@ -193,7 +191,7 @@ static inline int register_node(int nid)
 {
 	return 0;
 }
-static inline int unregister_one_node(int nid)
+static inline int unregister_node(int nid)
 {
 	return 0;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6c050d867031..94a8f6e8811a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1596,7 +1596,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 error:
 	if (new_node) {
 		node_set_offline(nid);
-		unregister_one_node(nid);
+		unregister_node(nid);
 	}
 error_memblock_remove:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
@@ -2201,7 +2201,7 @@ void try_offline_node(int nid)
 	 * node now.
 	 */
 	node_set_offline(nid);
-	unregister_one_node(nid);
+	unregister_node(nid);
 }
 EXPORT_SYMBOL(try_offline_node);
 
-- 
2.47.1


