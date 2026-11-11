Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006D7606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=koM+qE9k
Received: by kanga.kvack.org (Postfix)
	id 89CA86B05B4; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEFF6B05B7; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5386B05B4; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 318146B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B792740456
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:38 +0000 (UTC)
X-FDA: 85424313996.04.337F7CA
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 50B5720004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=koM+qE9k;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/elCZSoXLJDWwdqt0XBoC1ZfH26lVl5Bs45VHydWUE=;
	b=A9m9j+fYdzivAtZxRkFvG5LAiXzpXWUfOadzhfOaSG1veJdXpQzuLj/0pci6VWPXvtLx+S
	eQnaD/wVhvfPHisvTs17PHLX7dCwAQ1zmtI5Y2HHbFXNwlITDqNI5M5hTCevmapMSypKvL
	AaREh+clqzhnZjfqEjdtpfS0P0abav0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=koM+qE9k;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436956;
	b=hFbBBCldSn+rNudSVr4QaBN9131KnNYXCgHJin0QjSOENOLJtx5gvXRGy1pS+zu+8tIamg
	ZydzmXzo/lMz/vlovLT/qpjpHVFKN4FUggzfBlXrQot5Ouoje+j7kfyUb3v4ROm8RIZXrm
	O7g0CihRKp5QBVQTffvrOp07pYNdF58=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794436956; x=1825972956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q/elCZSoXLJDWwdqt0XBoC1ZfH26lVl5Bs45VHydWUE=;
  b=koM+qE9kAbn4BznJzYCKup9KBC0RWRAKO4ICVOXggJfIKLQVzsHDfvOi
   CYGL/YS1Xp/CrY0YXFlDjnH7haJbPha0x5jj94H0r3ACikClBMfIVmi/t
   eRsCULA60B2O9k2jSNmQo5JYIKLVy3Mn5fRmQsiU42Y1LMHeZrCvBDnrr
   PHClxJKq69MBXMwPe8kbx0BcRUYO9EFEFhiHCx8mFfRg3CNUxtjPJERsD
   XD9Gq1s1azUqto7HhllHesKW/h6YGUW/ZvVyG9k9HLG7GMKlKIy5cFxER
   geHjOvxjbxwib+Bylt7VX0ko2BE+szXOuqh/Q+e1QfGeZYmHO8JPXlztV
   Q==;
X-CSE-ConnectionGUID: ELWECH3AT4aXJkQnrdwYfA==
X-CSE-MsgGUID: iYfTsDp0ROy9R6LX9GXREQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33677410"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:42:33 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:13794]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 92d871d6-7006-4cf3-91d1-6bc6dafd0698; Wed, 11 Nov 2026 22:42:32 +0000 (UTC)
X-Farcaster-Flow-ID: 92d871d6-7006-4cf3-91d1-6bc6dafd0698
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:32 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:29 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 01/40] nitro_enclaves: Allow the CPU pool to span NUMA nodes
Date: Wed, 11 Nov 2026 22:41:46 +0000
Message-ID: <c1973df40561159c3d6a32e58b22b963bf7fc507.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 50B5720004
X-Stat-Signature: d9xyxp78bxn6xmozm85sycja6rw7xkch
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794436956-854936
X-HE-Meta: U2FsdGVkX1/9bJfE02iY9gipJEgecHIAkKAxM5HJk0pvNTw5LKp1cUAv9wmMsNyF4Kvk8fgqCjKi12UwQzKj+pkB3mdzloulRHp3gKN9tRqeTOt1fOUypxMAGrGoH+78v1d0Nkxacq3aCbIwj4E2V+1fErZy9dZndt79ty7RXdw3QN3z3E6wWRKTyH33v6vJ1ie87gSwxI4Cgn1jSP+Hkxm3dRUy6b7oAL0B+sSmVVltRG7zUfEPYnXmNQpi1B4d6EfFQmkAw9mESqazJZojUdUuKLScTwisfH7lNFo1fEaJyjs2DTZgG86U7IhK9aDfNNZDRfZBLApLGgNQG7SyRLcI8AJ0lnOz/sqQIO+Dt4erL/7YL6xj45eAUawEDGQt45ILH9v3zOeVAd1l1A/l5/t2ws4H2b9VjYGXQpQaKreYJAoe7JgCl5Slp65A7fERSZckbdLN03rtpC4tq1sq6Y5e315H0qPz258g9oeuKXPgr6WW2f5OLIgnVuPCF7mmr9aEYkGtBvFYt/0vJqdI+ofw+atmMJNQ4WOTbxVGhiakuyoNJXS8GtfOzlALp5cmAXW2K7LCqcGeyxJ76aqUl33IzBDt68wNzy9F98jMvngjv90bjxJu8/QooZsIC+Z5wsgjKINqGf32VUX1L59BMdZlTD1k1M5dsh4Jc+yoSTGNlemdqA89vH3k8NUuVpHsRipNs1eTc7MJPEgkx6H3MvqTyaZTyfOBHy/8pAGeKoje4hJVAZC4sNwiubuSsN8nsXdWlUjgECnEQoinr9Wk+IER0rtGGhEa0kCjjTyTxSC4NnnSx++0lkcgnMjWY1Fc16KXZFvZAsmvYlfyb61dojOIkgrXZzmN/8mOiHJJrZGF521hOJ3Q+t8cJwOThYE/Uyn5GbSnmi48qTYTcmA+VbTWksT2A/PmaYID+AMAjEQjDDRs1m9SoCWe1gBv0lH9lBRQLeU5Wi3Cpn1UGky
 +RBGhIIR
 g7mdruOiPo0et8dcUrIxdc7w4usJX39eFC1nhUqwKcDwmOqsIXJF0X4LhkOEhjz4/ft4TsEdtiVFmiRDGAmyVa87pKGh0ykpKn2tr/jcl/npmVTVt268rRwTpCq1m8ziBVwTJw+BKSO+A/Mk++O8K6cajBXWCBbjwLJE/Vcl7SsqONCfyfuw4FpGbUUCJl8deZ51yEO3unGUxHkntOIsH3hT4JTlXs37PqRp7pUf7hmiUA/Kx5m19OeGaboka9efn8Ofe180t2twbuA7bh1pYIh9SCobaEXaTpKOWILC4RYLiKExzlsdEF8R+CVH4fHGFxEg8wPqU9S1mddnG4vvb7fwFFxnWfKv+CfHniQ15AXObQUCn8z7McdsapHCNrvdOMV5SwO+B+aRQeboavqwLwd7Cy1R4lzVm8gpa8LDIqBSfwkR1RWlolpgHTyRoyJXn8sGa44SKiU99A7frxxpNb51KuUSz/Cj918uh3KEHLRR/jMfAcpulKeQNpeThcDH7UWaIFqJ/HCeZKLV90FS+VAQRsto38WFYPPykVkaHOqfjP9dhxFtp9UYNQKIngIuUYO7Bc9iP2lmITAdZcRVNKSKpVrAraLbe9pZt6e2oVtNEZ9bOjXgMdCbLPXQeSyA3Eoj8laVPo8U7aRFvZ31qUNyAXc4mbujNe1rVnh5BOKOcvhhl1poLNZW/b+hn6nNyhtYFfAJINXEjJ8BNJRE2dalpUFaVOKVt7gaAkAZrAWog/gM+DWvlYaRiZdYapF/4ncOPDkGAnnF36LZlFs9dVD470KXTBRsmKxEyd08kCFdsmcNOO6Aiy6Oa1+SWtKUxdatVzfdbJ/TNEco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With Nitro Sandboxes, we allow users to span a sandbox across multiple
NUMA nodes and place their sandbox on a NUMA node different from 0.
Allow the ne_cpus= CPU pool to span NUMA nodes.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst        |   3 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 159 +++++++++++++++-------
 drivers/virt/nitro_enclaves/ne_misc_dev.h |   5 +-
 include/uapi/linux/nitro_enclaves.h       |  22 ++-
 samples/nitro_enclaves/ne_ioctl_sample.c  |  10 +-
 5 files changed, 137 insertions(+), 62 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 74c2f5919c886..aecd3704acaf5 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -47,7 +47,8 @@ The memory regions carved out of the primary VM and given to an enclave need to
 be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
 this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
 user space [2][3][7]. The memory size for an enclave needs to be at least
-64 MiB. The enclave memory and CPUs need to be from the same NUMA node.
+64 MiB. The enclave memory and CPUs need to be from the same NUMA node,
+unless the CPU pool spans several of them.
 
 An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
 available for the primary VM. A CPU pool has to be set for NE purposes by an
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index cb1efc95a7f34..6e36abeff01a2 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/nitro_enclaves.h>
+#include <linux/numa.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/range.h>
@@ -36,8 +37,8 @@
 
 /**
  * NE_CPUS_SIZE - Size for max 128 CPUs, for now, in a cpu-list string, comma
- *		  separated. The NE CPU pool includes CPUs from a single NUMA
- *		  node.
+ *		  separated. The NE CPU pool may include CPUs from more than
+ *		  one NUMA node.
  */
 #define NE_CPUS_SIZE		(512)
 
@@ -126,13 +127,27 @@ static const struct kernel_param *ne_cpus_kp;
  *				from the pool rather than derived from a thread
  *				count, so a machine whose cores do not all have
  *				the same number of threads is sized correctly.
- * @numa_node:			NUMA node of the CPUs in the pool.
+ * @numa_node:			NUMA node of the CPUs in the pool, or
+ *				NUMA_NO_NODE if the pool spans multiple nodes or
+ *				no pool is set up.
+ * @core_nid:			The NUMA node of each core slot, indexed the
+ *				same way as @avail_threads_per_core. Every slot
+ *				holds a core, so every entry names a node. A slot
+ *				keeps its node after its core is handed to an
+ *				enclave, because ne_get_cpu_from_cpu_pool()
+ *				still reads it when it reuses a sibling of that
+ *				core. Read while
+ *				the pool CPUs are still online, before
+ *				ne_setup_cpu_pool() offlines them, because
+ *				cpu_to_node() is not documented to answer for an
+ *				offline CPU.
  */
 struct ne_cpu_pool {
 	cpumask_var_t	*avail_threads_per_core;
 	struct mutex	mutex;
 	unsigned int	nr_parent_vm_cores;
 	int		numa_node;
+	int		*core_nid;
 };
 
 static struct ne_cpu_pool ne_cpu_pool = {
@@ -160,14 +175,16 @@ static void ne_free_core_slots(void)
 {
 	unsigned int i = 0;
 
-	if (!ne_cpu_pool.avail_threads_per_core)
-		return;
+	if (ne_cpu_pool.avail_threads_per_core) {
+		for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+			free_cpumask_var(ne_cpu_pool.avail_threads_per_core[i]);
 
-	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
-		free_cpumask_var(ne_cpu_pool.avail_threads_per_core[i]);
+		kfree(ne_cpu_pool.avail_threads_per_core);
+		ne_cpu_pool.avail_threads_per_core = NULL;
+	}
 
-	kfree(ne_cpu_pool.avail_threads_per_core);
-	ne_cpu_pool.avail_threads_per_core = NULL;
+	kfree(ne_cpu_pool.core_nid);
+	ne_cpu_pool.core_nid = NULL;
 }
 
 /**
@@ -218,6 +235,10 @@ static int ne_build_core_slots(const struct cpumask *cpu_pool)
 
 	ne_cpu_pool.nr_parent_vm_cores = nr_cores;
 
+	ne_cpu_pool.core_nid = kmalloc_objs(*ne_cpu_pool.core_nid, nr_cores);
+	if (!ne_cpu_pool.core_nid)
+		goto free_slots;
+
 	for (i = 0; i < nr_cores; i++)
 		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_threads_per_core[i], GFP_KERNEL))
 			goto free_slots;
@@ -237,6 +258,8 @@ static int ne_build_core_slots(const struct cpumask *cpu_pool)
 			cpumask_set_cpu(cpu_sibling, processed);
 		}
 
+		ne_cpu_pool.core_nid[next_core_idx] = cpu_to_node(cpu);
+
 		next_core_idx++;
 	}
 
@@ -275,7 +298,9 @@ static int ne_setup_cpu_pool(const struct cpumask *cpu_pool)
 {
 	unsigned int cpu = 0;
 	unsigned int cpu_sibling = 0;
-	int numa_node = -1;
+	bool have_node = false;
+	bool multi_node = false;
+	int numa_node = NUMA_NO_NODE;
 	int rc = -EINVAL;
 
 	mutex_lock(&ne_cpu_pool.mutex);
@@ -305,29 +330,34 @@ static int ne_setup_cpu_pool(const struct cpumask *cpu_pool)
 		}
 
 	/*
-	 * Check if the CPUs from the NE CPU pool are from the same NUMA node.
+	 * Determine the NUMA node of the CPUs in the pool. If the pool spans
+	 * multiple NUMA nodes, set numa_node to NUMA_NO_NODE; the pool is then
+	 * treated as node-agnostic for placement and memory-locality checks.
+	 * A CPU that reports no node at all is refused, because otherwise such
+	 * a CPU would join a single-node pool and turn it into a spanning one.
 	 */
-	for_each_cpu(cpu, cpu_pool)
-		if (numa_node < 0) {
-			numa_node = cpu_to_node(cpu);
-			if (numa_node < 0) {
-				pr_err("%s: Invalid NUMA node %d\n",
-				       ne_misc_dev.name, numa_node);
+	for_each_cpu(cpu, cpu_pool) {
+		int nid = cpu_to_node(cpu);
 
-				rc = -EINVAL;
+		if (nid < 0) {
+			pr_err("%s: CPU %d reports no NUMA node\n",
+			       ne_misc_dev.name, cpu);
 
-				goto unlock_hotplug;
-			}
-		} else {
-			if (numa_node != cpu_to_node(cpu)) {
-				pr_err("%s: CPUs with different NUMA nodes\n",
-				       ne_misc_dev.name);
+			rc = -EINVAL;
 
-				rc = -EINVAL;
+			goto unlock_hotplug;
+		}
 
-				goto unlock_hotplug;
-			}
+		if (!have_node) {
+			numa_node = nid;
+			have_node = true;
+		} else if (numa_node != nid) {
+			multi_node = true;
 		}
+	}
+
+	if (multi_node)
+		numa_node = NUMA_NO_NODE;
 
 	/*
 	 * Check if CPU 0 and its siblings are included in the provided CPU pool
@@ -414,7 +444,7 @@ static int ne_setup_cpu_pool(const struct cpumask *cpu_pool)
 	cpus_read_unlock();
 reset_pool:
 	ne_cpu_pool.nr_parent_vm_cores = 0;
-	ne_cpu_pool.numa_node = -1;
+	ne_cpu_pool.numa_node = NUMA_NO_NODE;
 	mutex_unlock(&ne_cpu_pool.mutex);
 
 	return rc;
@@ -452,7 +482,7 @@ static void ne_teardown_cpu_pool(void)
 
 	ne_free_core_slots();
 	ne_cpu_pool.nr_parent_vm_cores = 0;
-	ne_cpu_pool.numa_node = -1;
+	ne_cpu_pool.numa_node = NUMA_NO_NODE;
 
 	mutex_unlock(&ne_cpu_pool.mutex);
 }
@@ -633,7 +663,13 @@ static bool ne_donated_cpu(struct ne_enclave *ne_enclave, unsigned int cpu)
 /**
  * ne_get_unused_core_from_cpu_pool() - Get the id of a full core from the
  *					NE CPU pool.
- * @void:	No parameters provided.
+ * @nid:	Required NUMA node for the core, or NUMA_NO_NODE for no
+ *		node constraint.
+ *
+ * When @nid names a specific node, only a free core whose CPUs are
+ * on that node is returned; if none is available the function returns -1
+ * rather than spilling onto another node. When @nid is NUMA_NO_NODE, any
+ * free core is returned.
  *
  * Context: Process context. This function is called with the ne_enclave and
  *	    ne_cpu_pool mutexes held.
@@ -641,19 +677,19 @@ static bool ne_donated_cpu(struct ne_enclave *ne_enclave, unsigned int cpu)
  * * Core id.
  * * -1 if no CPU core available in the pool.
  */
-static int ne_get_unused_core_from_cpu_pool(void)
+static int ne_get_unused_core_from_cpu_pool(int nid)
 {
-	int core_id = -1;
 	unsigned int i = 0;
 
-	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
-		if (!cpumask_empty(ne_cpu_pool.avail_threads_per_core[i])) {
-			core_id = i;
-
-			break;
-		}
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++) {
+		if (cpumask_empty(ne_cpu_pool.avail_threads_per_core[i]))
+			continue;
+		if (nid != NUMA_NO_NODE && ne_cpu_pool.core_nid[i] != nid)
+			continue;
+		return i;
+	}
 
-	return core_id;
+	return -1;
 }
 
 /**
@@ -710,39 +746,62 @@ static int ne_set_enclave_threads_per_core(struct ne_enclave *ne_enclave,
  *				sibling of a new CPU core.
  * @ne_enclave :	Private data associated with the current enclave.
  * @vcpu_id:		vCPU to get from the NE CPU pool.
+ * @nid:		Required NUMA node for a newly taken core, or
+ *			NUMA_NO_NODE for no node constraint. A core already
+ *			held by the enclave is subject to the same
+ *			constraint, so that a run of requests for one node
+ *			does not hand back a sibling on another.
  *
- * Context: Process context. This function is called with the ne_enclave mutex held.
+ * The sibling walk reads ne_enclave->threads_per_core[] and
+ * ne_cpu_pool.core_nid[] at the same index, and stays below the smaller of
+ * their two lengths.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex
+ *	    held, and takes the ne_cpu_pool mutex over the sibling walk and the
+ *	    new-core path.
  * Return:
  * * 0 on success.
  * * Negative return value on failure.
  */
-static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, u32 *vcpu_id)
+static int ne_get_cpu_from_cpu_pool(struct ne_enclave *ne_enclave, u32 *vcpu_id,
+				    int nid)
 {
+	unsigned int nr_cores = 0;
 	int core_id = -1;
 	unsigned int cpu = 0;
 	unsigned int i = 0;
 	int rc = -EINVAL;
 
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	nr_cores = min(ne_enclave->nr_parent_vm_cores,
+		       ne_cpu_pool.nr_parent_vm_cores);
+
 	/*
 	 * If previously allocated a thread of a core to this enclave, first
 	 * check remaining sibling(s) for new CPU allocations, so that full
-	 * CPU cores are used for the enclave.
+	 * CPU cores are used for the enclave. Cores on a node other than the
+	 * requested one are skipped, so a run of requests for one node does
+	 * not hand back a sibling on another.
 	 */
-	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
+	for (i = 0; i < nr_cores; i++) {
+		if (nid != NUMA_NO_NODE && ne_cpu_pool.core_nid[i] != nid)
+			continue;
+
 		for_each_cpu(cpu, ne_enclave->threads_per_core[i])
 			if (!ne_donated_cpu(ne_enclave, cpu)) {
 				*vcpu_id = cpu;
+				rc = 0;
 
-				return 0;
+				goto unlock_mutex;
 			}
-
-	mutex_lock(&ne_cpu_pool.mutex);
+	}
 
 	/*
 	 * If no remaining siblings, get a core from the NE CPU pool and keep
 	 * track of all the threads in the enclave threads per core data structure.
 	 */
-	core_id = ne_get_unused_core_from_cpu_pool();
+	core_id = ne_get_unused_core_from_cpu_pool(nid);
 
 	rc = ne_set_enclave_threads_per_core(ne_enclave, core_id, *vcpu_id);
 	if (rc < 0)
@@ -970,7 +1029,8 @@ static int ne_sanity_check_user_mem_region_page(struct ne_enclave *ne_enclave,
 		return -NE_ERR_INVALID_PAGE_SIZE;
 	}
 
-	if (ne_enclave->numa_node != page_to_nid(mem_region_page)) {
+	if (ne_enclave->numa_node != NUMA_NO_NODE &&
+	    ne_enclave->numa_node != page_to_nid(mem_region_page)) {
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Page is not from NUMA node %d\n",
 				    ne_enclave->numa_node);
@@ -1329,7 +1389,8 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 
 		if (!vcpu_id) {
 			/* Use the CPU pool for choosing a CPU for the enclave. */
-			rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id);
+			rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id,
+						      NUMA_NO_NODE);
 			if (rc < 0) {
 				dev_err_ratelimited(ne_misc_dev.this_device,
 						    "Error in get CPU from pool [rc=%d]\n",
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 283c17558f2a3..23a783bab3d2f 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -54,7 +54,10 @@ struct ne_mem_region {
  *				per full CPU core in the NE CPU pool the enclave
  *				was created from.
  * @nr_vcpus:			Number of vcpus associated with the enclave.
- * @numa_node:			NUMA node of the enclave memory and CPUs.
+ * @numa_node:			NUMA node of the enclave memory and CPUs, or
+ *				NUMA_NO_NODE if the CPU pool it was created from
+ *				spans nodes, in which case its memory is not held
+ *				to a node.
  * @slot_uid:			Slot unique id mapped to the enclave.
  * @state:			Enclave state, updated during enclave lifetime.
  * @threads_per_core:		Enclave full CPU cores array. Each cpumask in the
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index e808f5ba124d4..206546f24748e 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -26,8 +26,8 @@
  *		  https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
  *		  CPU 0 and its siblings have to remain available for the
  *		  primary / parent VM, so they cannot be set for enclaves. Full
- *		  CPU core(s), from the same NUMA node, need(s) to be included
- *		  in the CPU pool.
+ *		  CPU core(s) need(s) to be included in the CPU pool. The
+ *		  pool may span NUMA nodes.
  *
  * Context: Process context.
  * Return:
@@ -50,8 +50,9 @@
  * NE_ADD_VCPU - The command is used to set a vCPU for an enclave. The vCPU can
  *		 be auto-chosen from the NE CPU pool or it can be set by the
  *		 caller, with the note that it needs to be available in the NE
- *		 CPU pool. Full CPU core(s), from the same NUMA node, need(s) to
- *		 be associated with an enclave.
+ *		 CPU pool. Full CPU core(s) need(s) to be associated with an
+ *		 enclave. When the CPU pool spans NUMA nodes, the cores of
+ *		 one enclave can be from different nodes.
  *		 The vCPU id is an input / output parameter. If its value is 0,
  *		 then a CPU is chosen from the enclave CPU pool and returned via
  *		 this parameter.
@@ -108,8 +109,11 @@
 /**
  * NE_SET_USER_MEMORY_REGION - The command is used to set a memory region for an
  *			       enclave, given the allocated memory from the
- *			       userspace. Enclave memory needs to be from the
- *			       same NUMA node as the enclave CPUs.
+ *			       userspace. When the CPU pool sits on one
+ *			       NUMA node, enclave memory needs to be from
+ *			       that node. An enclave built out of a pool
+ *			       that spans nodes has no node of its own, and
+ *			       its memory can come from any node.
  *			       The user memory region is an input parameter. It
  *			       includes info provided by the caller - flags,
  *			       memory size and userspace address.
@@ -138,7 +142,9 @@
  * * NE_ERR_MEM_NOT_HUGE_PAGE		- The memory region is not backed by
  *					  huge pages.
  * * NE_ERR_MEM_DIFFERENT_NUMA_NODE	- The memory region is not from the same
- *					  NUMA node as the CPUs.
+ *					  NUMA node as the CPUs. Not returned
+ *					  for an enclave whose CPU pool spans
+ *					  nodes.
  * * NE_ERR_MEM_MAX_REGIONS		- The number of memory regions set for
  *					  the enclave reached maximum.
  * * NE_ERR_INVALID_PAGE_SIZE		- The memory region is not backed by
@@ -223,6 +229,8 @@
 /**
  * NE_ERR_MEM_DIFFERENT_NUMA_NODE - The user space memory region is backed by
  *				    pages from different NUMA nodes than the CPUs.
+ *				    Not returned for an enclave whose CPU pool
+ *				    spans nodes.
  */
 #define NE_ERR_MEM_DIFFERENT_NUMA_NODE		(264)
 /**
diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
index 765b131c73190..84caf5e66fcbd 100644
--- a/samples/nitro_enclaves/ne_ioctl_sample.c
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -11,9 +11,10 @@
  * -----
  *
  * Load the nitro_enclaves module, setting also the enclave CPU pool. The
- * enclave CPUs need to be full cores from the same NUMA node. CPU 0 and its
- * siblings have to remain available for the primary / parent VM, so they
- * cannot be included in the enclave CPU pool.
+ * enclave CPUs need to be full cores. They come from the same NUMA node
+ * unless the CPU pool spans several of them. CPU 0 and its siblings have to
+ * remain available for the primary / parent VM, so they cannot be included
+ * in the enclave CPU pool.
  *
  * See the cpu list section from the kernel documentation.
  * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html#cpu-lists
@@ -41,7 +42,8 @@
  *	dmesg
  *
  * Setup hugetlbfs huge pages. The memory needs to be from the same NUMA node as
- * the enclave CPUs.
+ * the enclave CPUs, unless the CPU pool spans nodes, in which case the enclave
+ * is not held to a node and its memory can come from any of them.
  *
  * https://www.kernel.org/doc/html/latest/admin-guide/mm/hugetlbpage.html
  *
-- 
2.47.1


