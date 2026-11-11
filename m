Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F38A606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=aS+68Mqh
Received: by kanga.kvack.org (Postfix)
	id 6C9AB6B05B8; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B906B05B6; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2606B05B7; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2566B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:42:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C30701603A1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:38 +0000 (UTC)
X-FDA: 85424313996.24.AEDE573
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8158180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aS+68Mqh;
	spf=pass (imf30.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436956;
	b=vUL1Go2Nj+fj+PIV+lPw4/PXdhYo7hGeWSjTWEVuarJi6shxFnTNSRgFzmoif7sr3wQJyJ
	QlHMTxUuIx3Qszg9nahCtoItPRaVp5aJNV6nEe3chO3g2t9QHgH3vpXWwxF/8bTaWpLTkx
	GzSxZXSivlfXEWdSjljHsfHPO9gj/b0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aS+68Mqh;
	spf=pass (imf30.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxYweRxm1jxmevq4ssKlYUqBx3+MSGqJMKtXpG6cMZs=;
	b=JHZ6aIdwQIlp0Krky9moVUSSPVb24Gbn9zHBWxIozmdhSE1HW9w01k/jSXPQCfgUTi+kaJ
	GLk47uMuPvxfyjr9lj1nSzjVlYYmC5Eyk1G3qOrMN+kryp4mWnXv+9gFuy/mDlAJesAMJG
	XrXtefu7U8EILkc9q3o0HHqpJgjFlJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794436956; x=1825972956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UxYweRxm1jxmevq4ssKlYUqBx3+MSGqJMKtXpG6cMZs=;
  b=aS+68Mqhus+7PFhb4Af+ihLVjWRwCH6C33PdLvMf1Po0AW0w4nQigjwH
   CTHpMAN5JqfsMIjmu8URipG317wN/GWl0gllMPDm+nDa4LJQmBH28vW/L
   cMTq7CL2f+TXaCRTCUxPN8x9xsULHurY6rjI8QbS6OTD3c00vlUukgX0f
   rapNVDlzCKrK5HETSWP/nPl6VyJknjV9/AcS8G41Js4ZQc/zjVnTivFPX
   ySwet6/Id268ZcIBfNrHWuasRM3gA0QYrb2rJVJe0XVQakwhQdfLbH6ml
   ksD5+/ETeUxaGsLYi9BTUxxDA2KhN0+5wKHVAkujnbNRiy3wfXGFlOYEk
   Q==;
X-CSE-ConnectionGUID: rXovG/BETqmn+vbmyNsKtQ==
X-CSE-MsgGUID: RqVgO+5rQaKtb0DX5vPaTA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33756177"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:42:35 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:20493]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id fc83ea97-8a60-4672-82e4-94100366064e; Wed, 11 Nov 2026 22:42:35 +0000 (UTC)
X-Farcaster-Flow-ID: fc83ea97-8a60-4672-82e4-94100366064e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:34 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:32 +0000
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
Subject: [PATCH 02/40] nitro_enclaves: Add NE_ADD_ANY_VCPU
Date: Wed, 11 Nov 2026 22:41:47 +0000
Message-ID: <205db2f63e5458098d7d147a28efa04af2d4930d.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: hw8ekgepzur61bhnz1xdzy3usmp5nh3x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8158180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794436956-877211
X-HE-Meta: U2FsdGVkX1/94QD6JrNelKhkyJuJXqa6OBdUykiXG5Yf51lkw33M6o84ode/mwhJbF7pOPy2LDGUu/6h7CYqZiqZzmLrc7KCPUcX50qkZYxDoLl7v/JxKW/Ak1Wh+tM4J2/EkB95PiBtKL0a9V+bhhvtCbDvbYVwJVCAZVTpG5cKM7v3KGZO3Bv4AF7ymKlkDo6E4aMEMGDErmBn7QEd0rwT7JeSy6Ceh2H0UjA+t3fcIRmTBfVtO0eqy2D8LUi2AchhMn3i55BzTq6S3eQMpMf4L/Ovcpl3wgRFRE4ntAGB6SfX8A7mD85Gu8UHcO4xeoWqQD6g/DlPdQ9tuH38ovz2kp81AIhTdL0qARhptrO1jTllVvBKG9DZ8YM0UNhBaziYlcAb62Ke5JpnscZoT77cLBh9lSZS9Uf9ZPVM3b5umC74BQKxqtalGVDU3iL/XnhV2gcGU+sL/LNnUBD6BuGYYeohRshaHfDc9/whIsJ1n8DFNE4956Oj7TnWcm2xWpjBQ/vWCLaoLBfjhaMgzJ9pmID7JQWkdKwA59WgaE4EJziBuDAVX3QXNqLO+5czNYLzUCteZXTyystWU/z7I3/SpAZqzJKaHC3bMv6Rh+ECGPnfrX0WUegD7E+p0ShCBNVRR4s415G2rejkvT/ff0fd5lGDE2tP4k6867wSxy3W5H3rUgYSZfLDlqo84bvGC+QVWTBtfpBGi6+7kEJUU64/83DHY+rrmrjgAE/kYWeRZX+iUFG7X9PVT4KcjkqdqaI0/WUqSkIAUFVJ+1FFWhn1/SHCkZe3uXWFVfYdI/vN0bx5b8M2cDlcEItUjHZ8vItnKTNXBlh00yTtWXUhQb/3kZzhbt5bQOoRHwsf3JtB8aUZ2AOhpfFwFxohLDDyl1tPGkL0rK3BONd/3JthZ39NQcQooU98/J94OFPBo+8ZZFGIWHJnGM/sU9VlfPkRhlFOQc0ONyI3vbmAErf
 pgFpaVC7
 letuvLVZZvI/dh0jq0eUDgWI9RkWfihj8ubmzlyUcHdIk8u1wadYLBOJK/b4rVwOdXV+snNbiGKujv0/DQOtK4RoAnQH/waR11IDouU7vIqqqt1bGjC84N61kUCPtjS15bT8C2NWqmYNEtiDBD5o3NpH6fKIIAlgwi4UOQUsYg14+HuReXpI/S89UdEMEX0+NNH2KQ165tFogqH9z1eArDOpKoDpeU4Jb3TJFeaezltGpmO3AhD3HbT9N6ukhLY/Xb6/j0wQexD5vrlBuBXNciUh3rzDOOVI/wyJNzhItUJxYqLqZPDgK3tnW7EpIz0bQhwmM0740ZxqCtxA3LDQASXTXJLhDIQYshH9Ij6qL0UDokIEXRdqbcjfr5IxORKkeQmuvKxInh+v9tL9F4GR2ZcixFoFFsLA4dk5OWf/cS1Nb6egJsdBrMXPknUshe3utTvwD1Vvva/Sc71faxueUFf+CBV770XstPekfeqboQtRMFKhjtJKFIbdel0al/p7ClnHt0hiVil/fspnfxOQsxul17nd0Q3cELhpn+Ruzc9DRTvGTZv6O03/4gVw6kzMp6rvJVa4kHWU6C+j99oYYZSPInkOv0XlSfy90/bzS/+AvJ6rHnGkuQzzxg9yo8tEUeOh0S9mmrhTSXX5rN/65OsvjDeRcmt8Gn2agCJGeQOEAQDcV85AKDa9+VGzhcGnTJR+DYc33DlX7viQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A Nitro Sandbox can span multiple NUMA nodes. The current NE_ADD_VCPU ioctl
only takes a target CPU id as input or a special ANY id. With NUMA, we want
to be able to take any CPU from a specific NUMA node. Add a new
NE_ADD_ANY_VCPU ioctl with nid parameter to select the target node. The new
ioctl returns the selected CPU id or NE_ERR_NO_CPUS_AVAIL_IN_POOL.

To already prepare for later argument extension, filter out the size field
of the ioctl and handle the fields we know about.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 92 ++++++++++++++++++++++-
 include/uapi/linux/nitro_enclaves.h       | 54 +++++++++++++
 2 files changed, 145 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 6e36abeff01a2..576f1909c7304 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -9,11 +9,13 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/build_bug.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/file.h>
 #include <linux/hugetlb.h>
+#include <linux/ioctl.h>
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/list.h>
@@ -24,12 +26,15 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/nitro_enclaves.h>
+#include <linux/nodemask.h>
 #include <linux/numa.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/range.h>
 #include <linux/slab.h>
+#include <linux/stddef.h>
 #include <linux/types.h>
+#include <linux/uaccess.h>
 #include <uapi/linux/vm_sockets.h>
 
 #include "ne_misc_dev.h"
@@ -42,6 +47,23 @@
  */
 #define NE_CPUS_SIZE		(512)
 
+/**
+ * NE_EA_IOCTL() - Mask the size and direction bits out of an ioctl command, so
+ *		   that an Extensible Argument ioctl matches whatever size of
+ *		   argument the caller passed. The direction bits go with them,
+ *		   so a caller that spells the command _IOW(), _IOR() or
+ *		   _IOWR() reaches the same handler, and the handler decides
+ *		   what it reads and writes.
+ * @cmd:	The ioctl command to mask.
+ */
+#define NE_EA_IOCTL(cmd)	((cmd) & ~(IOC_INOUT | IOCSIZE_MASK))
+
+/*
+ * NE_NUMA_ANY reaches the core allocator as a node id, so the uapi spelling
+ * and the kernel one have to agree.
+ */
+static_assert(NE_NUMA_ANY == NUMA_NO_NODE);
+
 /**
  * NE_EIF_LOAD_OFFSET - The offset where to copy the Enclave Image Format (EIF)
  *			image in enclave memory.
@@ -334,7 +356,8 @@ static int ne_setup_cpu_pool(const struct cpumask *cpu_pool)
 	 * multiple NUMA nodes, set numa_node to NUMA_NO_NODE; the pool is then
 	 * treated as node-agnostic for placement and memory-locality checks.
 	 * A CPU that reports no node at all is refused, because otherwise such
-	 * a CPU would join a single-node pool and turn it into a spanning one.
+	 * a CPU would join a single-node pool and turn it into a spanning one,
+	 * and its core would be unreachable through a node-named pick.
 	 */
 	for_each_cpu(cpu, cpu_pool) {
 		int nid = cpu_to_node(cpu);
@@ -1592,6 +1615,73 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 
 		return 0;
 	}
+	}
+
+	/* Extensible Argument ioctls */
+	switch (NE_EA_IOCTL(cmd)) {
+	case NE_EA_IOCTL(NE_ADD_ANY_VCPU): {
+		struct ne_add_any_vcpu_args __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_add_any_vcpu_args args;
+		u32 vcpu_id = 0;
+		int rc;
+
+		if (usize < offsetofend(struct ne_add_any_vcpu_args, vcpu_id))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
+
+		if (args.numa_node != NE_NUMA_ANY &&
+		    (args.numa_node < 0 || args.numa_node >= nr_node_ids ||
+		     !node_state(args.numa_node, N_POSSIBLE))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Invalid NUMA node %d\n", args.numa_node);
+
+			return -EINVAL;
+		}
+
+		rc = mutex_lock_killable(&ne_enclave->enclave_info_mutex);
+		if (rc)
+			return rc;
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_INIT_STATE;
+		}
+
+		rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id, args.numa_node);
+		if (rc < 0) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in get CPU from pool [rc=%d node=%d]\n",
+					    rc, args.numa_node);
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		rc = ne_add_vcpu_ioctl(ne_enclave, vcpu_id);
+		if (rc < 0) {
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		args.vcpu_id = vcpu_id;
+
+		if (copy_to_user(uargs, &args, min_t(size_t, usize, sizeof(args))))
+			return -EFAULT;
+
+		return 0;
+	}
 
 	default:
 		return -ENOTTY;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 206546f24748e..e266b8a611c92 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -83,6 +83,60 @@
  */
 #define NE_ADD_VCPU			_IOWR(0xAE, 0x21, __u32)
 
+/**
+ * struct ne_add_any_vcpu_args - Argument for %NE_ADD_ANY_VCPU.
+ * @numa_node:	The NUMA node the vCPU has to come from, or %NE_NUMA_ANY for
+ *		any node.
+ * @vcpu_id:	The vCPU id the kernel chose, set on success. Ignored on
+ *		input.
+ */
+struct ne_add_any_vcpu_args {
+	__s32	numa_node;
+	__u32	vcpu_id;
+};
+
+/**
+ * NE_NUMA_ANY - Value for &struct ne_add_any_vcpu_args.numa_node that asks for
+ *		 a vCPU from any NUMA node.
+ */
+#define NE_NUMA_ANY			(-1)
+
+/**
+ * NE_ADD_ANY_VCPU - The command is used to set a vCPU for an enclave, chosen
+ *		     from the NE CPU pool. @numa_node confines the choice to
+ *		     one NUMA node; %NE_NUMA_ANY leaves it unconstrained. A
+ *		     caller that spreads an enclave over several nodes asks
+ *		     for each node in turn and stops when a node runs out.
+ *		     @vcpu_id carries back the vCPU id the kernel chose, so
+ *		     a caller collects the enclave's vCPU set as it builds
+ *		     it.
+ *		     The ioctl can be invoked on the enclave fd, before an
+ *		     enclave is started.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0				- Logic successfully completed.
+ * * -1				- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV			- The NE PCI device is not available.
+ * * EFAULT			- Argument read or write-back failure.
+ * * EINVAL			- The argument is shorter than @vcpu_id, or
+ *				  @numa_node is neither %NE_NUMA_ANY nor a
+ *				  possible NUMA node.
+ * * EIO			- Current task mm is not the same as the one
+ *				  that created the enclave.
+ * * E2BIG			- The argument is longer than this kernel knows
+ *				  about and the excess is not all zero.
+ * * NE_ERR_NOT_IN_INIT_STATE	- The enclave is not in init state (init =
+ *				  before being started).
+ * * NE_ERR_NO_CPUS_AVAIL_IN_POOL - No CPUs available in the NE CPU pool on
+ *				  @numa_node.
+ * * NE_ERR_VCPU_INVALID_CPU_CORE - The core the pool handed back is outside
+ *				  the enclave's core slots.
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_ADD_ANY_VCPU			_IOWR(0xAE, 0x2D, struct ne_add_any_vcpu_args)
+
 /**
  * NE_GET_IMAGE_LOAD_INFO - The command is used to get information needed for
  *			    in-memory enclave image loading e.g. offset in
-- 
2.47.1


