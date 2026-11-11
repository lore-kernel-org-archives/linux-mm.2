Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5789C606B00A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=C9Edywah
Received: by kanga.kvack.org (Postfix)
	id 67AEF6B05BB; Wed, 11 Nov 2026 17:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652D96B05BC; Wed, 11 Nov 2026 17:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541886B05BD; Wed, 11 Nov 2026 17:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 261796B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:43:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1D5B40453
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:34 +0000 (UTC)
X-FDA: 85424316348.12.D7D9CEE
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B7A6140006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=C9Edywah;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0NFUgTClp3d18kSEyHsJx5jq6m5X4eeY1Bs6n17SMU=;
	b=lsyl5HsRTwCwPb+7XF1GMtqzrlCIT34cfd9ddjysV1S5TLAssLVnVrEzlGzUQ2RbN6U5wq
	B9ixt49ZMyq2ePFdjO1XdZCnu34zJINqXwzESLdFI152JVre0BtQFx62yj6qHwlwfGCfkj
	5V+y8laHF5xBXiyVbvJFR1jedpyRkhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437012;
	b=Dir6zqeRE391mdYEZIBlUV92+jy1JL+n5bF8y4Dn9uFV9F4PnRa40Dsv3dywvpRFe0lFdn
	rOkJ+kFhp/uu5gmn1AspVK7p/s/pEOxGEWCdRmQicdF0CMIqaRUTyHBhc8MQUuYNS6RPTz
	tUP7BeyD22Eb4GIY8RH6Z7GJjeYjlVE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=C9Edywah;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437012; x=1825973012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0NFUgTClp3d18kSEyHsJx5jq6m5X4eeY1Bs6n17SMU=;
  b=C9EdywahNL4hudL1SQKP3XxDPxZWw8jrYdiMxssnB7e1HyGOz42nv2/U
   S/sRKoCVrsjEjhL3f3IUrxY9YcBfpUPEPlx651p35+SZVGRrLlH8V6ts8
   lr+/A6L/zUX5MUIamXx4hcD4jIubqk4c4nz3ImKByVxI5bE/tKMJK4f+P
   GnRjBk5DAUF/w5X/SgDAeZqQSEgiJ1SCzSRP9PLAmeT5djE/Wnm1Il3Za
   k37FwbuJtvUHwn5NLfnLRq1aIEBueZGa2doEoBnHKOA+NyN1fCiElPSIs
   szM30MIg2KeYLkuNUKvlsSI/hSULVwpg+JG6kNVtO24ihI5YH1WUw40qd
   Q==;
X-CSE-ConnectionGUID: LmMCmALARQW8hGPheJ3kBA==
X-CSE-MsgGUID: ptrmnhsbQM2i/kGzd0d73w==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33628577"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:29 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:24628]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 122c2cb3-c2d2-4c31-9d45-68b239b737d7; Wed, 11 Nov 2026 22:43:28 +0000 (UTC)
X-Farcaster-Flow-ID: 122c2cb3-c2d2-4c31-9d45-68b239b737d7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:28 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:25 +0000
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
Subject: [PATCH 06/40] nitro_enclaves: Add NE_ALLOC_MEMORY ioctl
Date: Wed, 11 Nov 2026 22:41:51 +0000
Message-ID: <719b73646c55e03fb324e29f4ba9b079ef1fd969.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: ofznndpwzustyexdz17cu38ui9tse49f
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3B7A6140006
X-Rspam-User: 
X-HE-Tag: 1794437012-466835
X-HE-Meta: U2FsdGVkX1+qiQJOdQtSEZIKPulPVFP0NfNM36t3QM20UH1y2pFlS0ewA4yX8tGvetR7LVAPGzD1vkpDjqw46id2DM2NtKETLA+DXw07ir28Vn/+T9g2uMue6bUQmlII3BIJhef5Sm6wswJgi5ZftjFgczPoFCEKo2z+TtDERS/8735jBNNFAcBZEE1Quk3kreRbl+v9J2S2a2cwYMPIu9W8zpdR3pirBgwMFiKHiHb4ZRHXeW0OpcSvF/1RUfIqhHbH/faGSZyz/3Uvp8Bt6gWb53C8QbFTIfR+BdnT65SM8M1YLVq6rDSApa6isVSb6ZMRSEkSuRGIk2gIHp68r2iGeaA3aEbtJt3Iz406ccyiZnILddsiVmrGMOd2xYwP6jQONjypm/8H2vnUTbtJFoL3yzgYqYv1JdSPucUEoxZnv3EFCVf1IlSJf1MpMFnWBGBT34LWAfK7iJXZELW/DSmRyxn5QSz/6bheVnFmTgp3vt6qM6mmoU/MEsXKwF1aOsEAtjcBie0jeRD9L0kUJ+RaufGxfTNuzLFCA0juI8lJzOFjfXUsfPxfUcMjH9/cd2CokCe0hGr/T8TtL8A+bE7lzmBz7mzVjWnR5T+yCorQb/niBSvH/WEy4t/RUd2N9XJvv2LhusmtGCJO54ukf32RshzsR0RlkXJcN6YecIh7Fj65eTEUSOn4W2MVLP3kfZzawJRTFdBmDMiMpl/3RWCabfpF52kJzZbuL6tdhktL014/F2a5BJh6okO/4yG+3Ep4rDUwwd0M5vXOMwlhxS5rh9AzMJG2/P9ucXpEQ8NIOfxssUwFfTKZoRyUO76YkoMZJ9SRa2z7yePEWmHvJhw6IOKOak5018J4/Yxh07VjZTDCVuamFcOSdKjonYJ7MYXuOro0YJeK5mHSMAKG/K7lvn2LtQlrCGyuD4fYqxfk3eydhr+BPlNy3GkyAbgOlnmyXskgQQXJavkJdpF
 agISpGqr
 a6htONKLP46rogFxBcR90xHebMPyLVSYTnpOyZWWwuowYjT/3XA8uH2CjT+C5i/TqZ+NccOACbHaaPop7lgahKwBwBthKWuhLWeJXPNE0crET+qEpwPVplRu08hLG1B5j80hnJZbFKNwJDBqfa/CzPOzy0N55bQj26wmbFHU6+O3oxRn8VhgjCCNeaaN1K5jn6GIxUYvYSgo+ROdE3Hyyrt4hn7wXtndYJ0INB08bzfTclY7adXjgJjh4Z56MiWuvUSDzH/ah3LveBRrlKhLkqSvujWOVW82fFKZYJ7BVGIGujd2KCX3rh5HUbSxmURJTQx3GdXXvYjDIVK7Uhx3O1rEzGd4t6f3rnXH0J1dcuQ5Ouro6Tu0gWIjomHWE2Wq3YCzL1sFiMkQ1tInkGT8uHmiEHmtyTueONzNmvrjAr7V6bemm758+RqP7m1ghvZezdjFyMIMeGF71y9oIlqmR95t01WWoJfQXfNWHuQ28WCeVcKKKYl2GANKsY+jsRbacSXr4RM4C1CCyBhVqAnrUzSKtXwVvfS4YwAg4XUJ0BE4dV7b6HKTz2eAmudy5c//769+vyMmLBbUrwL96+o6r1F+hpCTsuldna/7MX7ZNabNZWAEZniLvpJKeDJw8F3C4Z6FqJZLfgvRpq0SgbSAxjpvN+91K509UjvQ2mpuwywuJCB6vFMm3nr0UEn9Uy8BPy6K2FfmSuwfJkdO/V6TtatzQx+vWh4+FA1UYi222g8VeOdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When donating memory to the hypervisor for Enclave or Sandbox creation,
the hypervisor only provides a limited number of slots of physically
contiguous memory regions that make up the full slot memory donation.

So far, we used hugetlbfs and mmap based memory donation. But that
scheme has a few issues. It means that user space retains access to
memory that is actually donated. Access to that memory turns into an
exception. It also means that any donating allocation ends up with
page tables that back them, even when nobody really should use them.

So we copy the guest_memfd flow of allocating memory, but not exposing
it as mapping to user space by default. EIF writes are a simple fd write.
Each allocation gets its own fd. And for direct mode, where memory really
is supposed to be accessible to the parent, we still allow mmap.

To reduce the number of separate memory regions these fds span, we use
CMA to allocate very large physically contiguous chunks.

Select CMA and DMA_CMA to always have the foundations available.
DMA_NUMA_CMA stays optional.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/Kconfig       |  18 +
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 730 +++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  61 ++
 include/uapi/linux/nitro_enclaves.h       |  90 ++-
 4 files changed, 895 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
index dc4d25c26256e..7b2456cdbb9fb 100644
--- a/drivers/virt/nitro_enclaves/Kconfig
+++ b/drivers/virt/nitro_enclaves/Kconfig
@@ -8,7 +8,9 @@
 config NITRO_ENCLAVES
 	tristate "Nitro Enclaves Support"
 	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
+	select CMA
+	select DMA_CMA
 	help
 	  This driver consists of support for enclave lifetime management
 	  for Nitro Enclaves (NE).
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 66bcaec8d3199..56ca1a9d99d41 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -9,12 +9,17 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/bsearch.h>
 #include <linux/build_bug.h>
 #include <linux/capability.h>
+#include <linux/cma.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/device.h>
+#include <linux/dma-map-ops.h>
 #include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/highmem.h>
 #include <linux/hugetlb.h>
 #include <linux/ioctl.h>
 #include <linux/kernel.h>
@@ -33,13 +38,16 @@
 #include <linux/numa.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
+#include <linux/preempt.h>
 #include <linux/range.h>
+#include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <uapi/linux/vm_sockets.h>
 
 #include "ne_misc_dev.h"
@@ -86,6 +94,16 @@ static_assert(NE_NUMA_ANY == NUMA_NO_NODE);
  */
 #define NE_MIN_MEM_REGION_SIZE	(2 * 1024UL * 1024UL)
 
+/**
+ * NE_ZERO_SPAN_PAGES - The most one span of the zeroing walk covers.
+ */
+#define NE_ZERO_SPAN_PAGES	(1024UL)
+
+/**
+ * NE_WRITE_SPAN_PAGES - The most one span of the write walk copies.
+ */
+#define NE_WRITE_SPAN_PAGES	(1024UL)
+
 /**
  * NE_PARENT_VM_CID - The CID for the vsock device of the primary / parent VM.
  */
@@ -93,6 +111,16 @@ static_assert(NE_NUMA_ANY == NUMA_NO_NODE);
 
 static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
+/*
+ * Handed to an enclave as ne_enclave.id once it has a slot, so that an
+ * NE_ALLOC_MEMORY allocation names the enclave it was made for without holding
+ * a reference on it. A 64-bit counter does not come round again, so an id names
+ * one enclave for the lifetime of the driver.
+ */
+static atomic64_t ne_enclave_seq = ATOMIC64_INIT(0);
+
+static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
+				 struct ne_alloc_memory_args *args);
 static const struct file_operations ne_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
@@ -1731,7 +1759,7 @@ static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
  * Context: Process context. This function is called with ne_devs.lock held
  *	    for reading, on an enclave that is not detached.
  * Return:
- * * 0 on success.
+ * * Ioctl result (e.g. memory allocation file descriptor) on success.
  * * Negative return value on failure.
  */
 static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -2041,6 +2069,39 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		return 0;
 	}
 
+	case NE_EA_IOCTL(NE_ALLOC_MEMORY): {
+		struct ne_alloc_memory_args __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_alloc_memory_args args;
+		int rc;
+
+		if (usize < offsetofend(struct ne_alloc_memory_args, flags))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
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
+		rc = ne_alloc_memory_ioctl(ne_enclave, &args);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -2427,6 +2488,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 		goto put_file;
 	}
 
+	ne_enclave->id = atomic64_inc_return(&ne_enclave_seq);
+
 	init_waitqueue_head(&ne_enclave->eventq);
 	ne_enclave->has_event = false;
 	mutex_init(&ne_enclave->enclave_info_mutex);
@@ -2516,6 +2579,671 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return 0;
 }
 
+/*
+ * Physically-contiguous memory for enclaves.
+ *
+ * An enclave's memory is handed to the hypervisor in physically contiguous
+ * 2 MiB (or larger) chunks. NE_ALLOC_MEMORY allocates contiguous memory from a
+ * host NUMA node's generic CMA area and returns a file descriptor for it. A
+ * per-node area comes from numa_cma= or cma_pernuma=, or from
+ * CONFIG_CMA_SIZE_PERNUMA, which reserves the cma= default area's size on
+ * every online node on top of that area itself, none of which a kernel has
+ * without CONFIG_DMA_NUMA_CMA. On a host with one online node the accessor
+ * returns the default area, so cma= on its own is enough there, and that much
+ * needs CONFIG_DMA_CMA alone.
+ *
+ * A request the node's area cannot serve fails. Anyone who can open
+ * /dev/nitro_enclaves can create an enclave and ask it for memory, so
+ * serving such a request out of movable memory would take that memory from
+ * the rest of the host and leave the reservation bounding nothing.
+ *
+ * A request larger than one contiguous run is satisfied by several runs, which
+ * the driver keeps on a list of its own so that an enclave can be given every
+ * one of them.
+ *
+ * An allocation is never mapped, and the enclave image reaches it through
+ * write().
+ *
+ * The runs belong to the file the allocation is handed out on. Zeroing a fresh
+ * run and a write into an allocation go through ne_walk_run(), so that neither
+ * can run for as long as the allocation is large; the release path walks the
+ * runs with a preemption point of its own.
+ */
+
+/**
+ * ne_contig_free_run() - Give a contiguous run of pages back.
+ * @cma:	CMA area the run came from.
+ * @page:	First page of the run.
+ * @nr_pages:	Number of pages in the run.
+ */
+void ne_contig_free_run(struct cma *cma, struct page *page,
+			unsigned long nr_pages)
+{
+	cma_release(cma, page, nr_pages);
+}
+
+static void ne_contig_free_alloc(struct ne_contig_alloc *alloc)
+{
+	ne_contig_free_run(alloc->cma, alloc->page, alloc->nr_pages);
+}
+
+/*
+ * Free every run of an allocation. A 512 GiB allocation made of 2 MiB runs is a
+ * quarter of a million entries and cma_release() does not reschedule, so this
+ * walk needs a preemption point of its own. It runs from ->release, which can
+ * land on a workqueue.
+ */
+static void ne_contig_free_allocs(struct ne_contig_mem *mem)
+{
+	unsigned int i;
+
+	for (i = 0; i < mem->nr_allocs; i++) {
+		cond_resched();
+
+		ne_contig_free_alloc(&mem->allocs[i]);
+	}
+
+	mem->nr_allocs = 0;
+	kvfree(mem->allocs);
+	mem->allocs = NULL;
+}
+
+/**
+ * typedef ne_span_fn - What to do with one span of a contiguous run.
+ * @arg:	Context the caller of ne_walk_run() passed.
+ * @page:	Page the span starts in.
+ * @off:	Byte offset of the span inside @page, less than PAGE_SIZE.
+ * @len:	Length of the span in bytes.
+ *
+ * Return: 0 on success, negative return value on failure.
+ */
+typedef int (*ne_span_fn)(void *arg, struct page *page, u64 off, u64 len);
+
+/**
+ * ne_walk_run() - Hand @fn one span of a run at a time.
+ * @page:	First page of the run.
+ * @off:	Byte offset into the run to start at.
+ * @len:	Number of bytes to cover.
+ * @span_pages:	The most one call to @fn covers.
+ * @fn:		What to do with a span.
+ * @arg:	Context for @fn.
+ *
+ * A run can be as large as the whole allocation and none of the things done to
+ * one reschedules on its own, so this is where the driver gets its
+ * preemption points and its bail-out on a fatal signal. @fn gets at most
+ * @span_pages worth of bytes at a time and nothing else bounds it, which is
+ * what keeps the work between two cond_resched() calls from growing with the
+ * allocation. An unaligned @off spreads those bytes over one page more.
+ *
+ * Return: 0 on success, -EINTR when a fatal signal arrived, or whatever @fn
+ *	   returned.
+ */
+static int ne_walk_run(struct page *page, u64 off, u64 len,
+		       unsigned long span_pages, ne_span_fn fn, void *arg)
+{
+	u64 span = (u64)span_pages << PAGE_SHIFT;
+	u64 done = 0;
+
+	while (done < len) {
+		u64 pos = off + done;
+		u64 this = min(len - done, span);
+		int rc;
+
+		rc = fn(arg, page + (pos >> PAGE_SHIFT), pos & ~PAGE_MASK,
+			this);
+		if (rc)
+			return rc;
+
+		done += this;
+
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		cond_resched();
+	}
+
+	return 0;
+}
+
+/**
+ * ne_contig_alloc_cmp() - Order a byte offset against one run.
+ * @key:	Byte offset into the allocation, as a u64.
+ * @elem:	The run.
+ *
+ * Return: 0 when @key falls inside @elem, negative when it lies before it and
+ *	   positive when it lies after it.
+ */
+static int ne_contig_alloc_cmp(const void *key, const void *elem)
+{
+	const struct ne_contig_alloc *alloc = elem;
+	u64 off = *(const u64 *)key;
+
+	if (off < alloc->off)
+		return -1;
+
+	if (off >= alloc->off + ((u64)alloc->nr_pages << PAGE_SHIFT))
+		return 1;
+
+	return 0;
+}
+
+/**
+ * ne_find_alloc() - The run a byte offset falls in.
+ * @mem:	The allocation.
+ * @off:	Byte offset into the allocation.
+ *
+ * The runs are ordered by offset and cover the allocation back to back, so a
+ * binary search finds one. A 512 GiB allocation made of 2 MiB runs is a quarter
+ * of a million of them and a fault resolves an offset every time it is taken,
+ * which is why this is not a walk. The array is not mutated after the file is
+ * published, so this needs no lock.
+ *
+ * Return: the run, or NULL when @off is past the end of the allocation.
+ */
+static struct ne_contig_alloc *ne_find_alloc(struct ne_contig_mem *mem, u64 off)
+{
+	return bsearch(&off, mem->allocs, mem->nr_allocs, sizeof(*mem->allocs),
+		       ne_contig_alloc_cmp);
+}
+
+/**
+ * ne_walk_allocs() - Hand @fn the part of an allocation at @off, run by run.
+ * @mem:	The allocation.
+ * @off:	Byte offset into the allocation to start at.
+ * @len:	Number of bytes to cover, which has to fit inside the allocation.
+ * @span_pages:	The most one call to @fn covers.
+ * @fn:		What to do with a span.
+ * @arg:	Context for @fn.
+ *
+ * The runs are handed over in order and back to back, so a caller that only
+ * advances an output cursor sees one flat region.
+ *
+ * Return: 0 on success, negative return value on failure.
+ */
+static int ne_walk_allocs(struct ne_contig_mem *mem, u64 off, u64 len,
+			  unsigned long span_pages, ne_span_fn fn, void *arg)
+{
+	struct ne_contig_alloc *end = mem->allocs + mem->nr_allocs;
+	struct ne_contig_alloc *alloc = ne_find_alloc(mem, off);
+	u64 done = 0;
+
+	if (!alloc)
+		return 0;
+
+	for (; done < len && alloc < end; alloc++) {
+		u64 run = (u64)alloc->nr_pages << PAGE_SHIFT;
+		u64 skip = off > alloc->off ? off - alloc->off : 0;
+		u64 this = min(run - skip, len - done);
+		int rc;
+
+		cond_resched();
+
+		rc = ne_walk_run(alloc->page, skip, this, span_pages, fn, arg);
+		if (rc)
+			return rc;
+
+		done += this;
+	}
+
+	return 0;
+}
+
+static struct cma *ne_numa_cma_area(int nid)
+{
+	struct cma *cma = dma_get_numa_cma_area(nid);
+
+	/*
+	 * A node with no area of its own can serve nothing, however much free
+	 * memory it has, and that is a reservation the host was booted without
+	 * rather than one it has used up. Say so once, since the areas are
+	 * reserved at boot and no node acquires one later.
+	 */
+	if (!cma)
+		pr_warn_once("%s: node %d has no CMA area to serve enclave memory from, reserve one with numa_cma=, cma_pernuma= or cma=\n",
+			     ne_misc_dev.name, nid);
+
+	return cma;
+}
+
+static struct page *ne_alloc_contig_node(unsigned long nr_pages, int nid,
+					 struct cma **out_cma)
+{
+	unsigned int align = ilog2(NE_MIN_MEM_REGION_SIZE >> PAGE_SHIFT);
+	struct cma *cma = ne_numa_cma_area(nid);
+	struct page *page;
+
+	if (!cma)
+		return NULL;
+
+	/*
+	 * The chunk loop in ne_alloc_memory_ioctl() walks sizes downwards and
+	 * expects most of these to fail, so keep a failure cheap and quiet.
+	 */
+	page = cma_alloc(cma, nr_pages, align, true);
+	if (page)
+		*out_cma = cma;
+
+	return page;
+}
+
+/*
+ * Zero one span of a freshly allocated run. CMA pages can carry residual data
+ * from earlier movable use, so nothing reaches an enclave until this has run
+ * over all of it.
+ *
+ * The run is on its way to an enclave and may be mapped into the caller, so this
+ * is clear_user_highpages()' job rather than clear_pages()'. It maps a highmem
+ * page before clearing it and falls back to a batched clear_pages() where there
+ * is no highmem, which is every configuration this driver builds for bar i386
+ * with highmem.
+ * The user address it is given is zero. Neither x86 nor arm64 supplies its own
+ * clear_user_page() or clear_user_highpage(), so the generic clear_user_page()
+ * runs and does not read the address.
+ *
+ * @off is zero and @len a multiple of PAGE_SIZE here, because a run is walked
+ * whole and the span size is a page count.
+ */
+static int ne_zero_span(void *arg, struct page *page, u64 off, u64 len)
+{
+	clear_user_highpages(page, 0, len >> PAGE_SHIFT);
+
+	return 0;
+}
+
+/*
+ * How much of a run one span of the zeroing walk covers. clear_user_highpages()
+ * does not reschedule, so under a cooperatively scheduled model a caller has to
+ * keep a batch within PROCESS_PAGES_NON_PREEMPT_BATCH, which is a single page on
+ * every architecture that does not supply its own clear_pages(). Under
+ * PREEMPT_DYNAMIC the model comes from the command line, so this asks at run
+ * time rather than testing a config symbol. Either way NE_ZERO_SPAN_PAGES stays
+ * the upper bound, so a fatal signal is still noticed within a few megabytes of
+ * clearing.
+ */
+static unsigned long ne_zero_span_pages(void)
+{
+	if (preempt_model_preemptible())
+		return NE_ZERO_SPAN_PAGES;
+
+	return min_t(unsigned long, NE_ZERO_SPAN_PAGES,
+		     PROCESS_PAGES_NON_PREEMPT_BATCH);
+}
+
+/**
+ * ne_alloc_contig() - Allocate a physically-contiguous, zeroed run of pages.
+ * @nr_pages:	Number of pages to allocate.
+ * @nid:	NUMA node to allocate from.
+ * @out_cma:	Set to the CMA area the run came from.
+ *
+ * The run is drawn from @nid's generic CMA area and from nowhere else: an
+ * enclave's memory has to sit on the node the caller asked for, so a run from
+ * another node is no more use to it than no run at all, and a run from outside
+ * the reservation is memory the host budgeted for something else.
+ *
+ * Zeroing a large run takes a while, so a fatal signal abandons it rather than
+ * making the task wait to be killed.
+ *
+ * Return: the first page of the run, NULL on allocation failure, or
+ *	   ERR_PTR(-EINTR) when a fatal signal arrived while zeroing.
+ */
+struct page *ne_alloc_contig(unsigned long nr_pages, int nid,
+			     struct cma **out_cma)
+{
+	struct page *page;
+	int rc;
+
+	*out_cma = NULL;
+
+	page = ne_alloc_contig_node(nr_pages, nid, out_cma);
+	if (!page)
+		return NULL;
+
+	rc = ne_walk_run(page, 0, (u64)nr_pages << PAGE_SHIFT,
+			 ne_zero_span_pages(), ne_zero_span, NULL);
+	if (rc) {
+		struct ne_contig_alloc discard = {
+			.page = page,
+			.nr_pages = nr_pages,
+			.cma = *out_cma,
+		};
+
+		ne_contig_free_alloc(&discard);
+
+		return ERR_PTR(rc);
+	}
+
+	return page;
+}
+
+/**
+ * struct ne_write_ctx - Where the write walk has got to.
+ * @iter:	Where the bytes come from.
+ * @copied:	Bytes copied so far.
+ */
+struct ne_write_ctx {
+	struct iov_iter	*iter;
+	size_t		copied;
+};
+
+/*
+ * Copy one span of a run out of the iterator. Where the kernel has no highmem a
+ * run is contiguous in the direct map, so a span goes in one call. Where it may
+ * have some, page_address() is not enough on its own, so every page goes through
+ * copy_page_from_iter(), which maps it for the copy.
+ */
+static int ne_write_span(void *arg, struct page *page, u64 off, u64 len)
+{
+	struct ne_write_ctx *ctx = arg;
+	size_t n = 0;
+
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		n = copy_from_iter(page_address(page) + off, len, ctx->iter);
+	} else {
+		while (n < len) {
+			u64 pos = off + n;
+			size_t this;
+
+			this = min_t(size_t, len - n,
+				     PAGE_SIZE - (pos & ~PAGE_MASK));
+			this = copy_page_from_iter(page + (pos >> PAGE_SHIFT),
+						   pos & ~PAGE_MASK, this,
+						   ctx->iter);
+			if (!this)
+				break;
+
+			n += this;
+		}
+	}
+
+	ctx->copied += n;
+
+	return n < len ? -EFAULT : 0;
+}
+
+/**
+ * ne_contig_write_iter() - Place bytes in an allocation.
+ * @iocb:	Holds the allocation's file and the offset to write at.
+ * @from:	Where the bytes come from.
+ *
+ * An enclave image has to be in enclave memory before the enclave starts, and a
+ * private allocation is never mapped, so this is how it gets there. The write
+ * has to fit inside the allocation: a partly written image is of no use to
+ * anyone, so a write running past the end is refused rather than shortened. The
+ * allocation has a fixed maximum offset and no notion of free space, so that
+ * refusal is -EFBIG, the same as generic_write_check_limits() gives for a write
+ * beyond s_maxbytes. There is no RLIMIT_FSIZE in it, so no SIGXFSZ either.
+ *
+ * Return: the number of bytes written, or a negative return value on failure.
+ */
+static ssize_t ne_contig_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct ne_contig_mem *mem = iocb->ki_filp->private_data;
+	struct ne_write_ctx ctx = { .iter = from };
+	size_t count = iov_iter_count(from);
+	u64 pos = iocb->ki_pos;
+	int rc;
+
+	if (!count)
+		return 0;
+
+	if (pos >= mem->size || count > mem->size - pos)
+		return -EFBIG;
+
+	rc = ne_walk_allocs(mem, pos, count, NE_WRITE_SPAN_PAGES, ne_write_span,
+			    &ctx);
+
+	if (ctx.copied) {
+		iocb->ki_pos = pos + ctx.copied;
+
+		return ctx.copied;
+	}
+
+	return rc;
+}
+
+/**
+ * ne_contig_release() - Free an allocation once nothing holds it any more.
+ * @inode:	The allocation's inode, unused.
+ * @file:	The allocation's file.
+ *
+ * The last reference on the file is what gets here, and a mapping holds one, so
+ * by this point no page table entry points at the runs.
+ *
+ * Return: 0.
+ */
+static int ne_contig_release(struct inode *inode, struct file *file)
+{
+	struct ne_contig_mem *mem = file->private_data;
+
+	ne_contig_free_allocs(mem);
+
+	if (mem->nr_pinned)
+		atomic64_sub(mem->nr_pinned, &mem->mm->pinned_vm);
+
+	mmdrop(mem->mm);
+
+	kfree(mem);
+
+	return 0;
+}
+
+static const struct file_operations ne_contig_fops = {
+	.owner			= THIS_MODULE,
+	.llseek			= generic_file_llseek,
+	.write_iter		= ne_contig_write_iter,
+	.release		= ne_contig_release,
+};
+
+/**
+ * ne_contig_create_file() - Build a file for an allocation.
+ * @mem:	The allocation, whose runs the file takes over on success.
+ *
+ * On success the file owns @mem, and the last fput() runs ne_contig_release()
+ * to free the runs. On failure @mem is left to the caller.
+ *
+ * Return: the new file, or an ERR_PTR.
+ */
+static struct file *ne_contig_create_file(struct ne_contig_mem *mem)
+{
+	struct file *file;
+
+	/*
+	 * An inode of its own is what carries the size, so that fstat() reports
+	 * it and it bounds the offsets a mapping or a write may use. It also
+	 * gets a security label rather than staying S_PRIVATE, which is what
+	 * user space reaching an inode through a descriptor wants.
+	 */
+	file = anon_inode_create_getfile("ne-mem", &ne_contig_fops, mem, O_RDWR,
+					 NULL);
+	if (IS_ERR(file))
+		return file;
+
+	i_size_write(file_inode(file), mem->size);
+	inode_set_bytes(file_inode(file), mem->size);
+
+	/*
+	 * A file that came through open() would have these from
+	 * do_dentry_open(); one built here does not, and FMODE_PWRITE is what
+	 * lets a positional write reach an allocation that is never mapped.
+	 * FMODE_PREAD gates pread() rather than read(), and there is no read
+	 * operation here for either to reach, so all it buys is pread()
+	 * failing with EINVAL like read() does instead of with ESPIPE.
+	 * Nothing else has this file yet, so there is nobody to see the
+	 * intermediate state.
+	 */
+	file->f_mode |= FMODE_PREAD | FMODE_PWRITE;
+	file->f_flags |= O_LARGEFILE;
+
+	return file;
+}
+
+/**
+ * ne_alloc_memory_ioctl() - Allocate contiguous memory for an enclave.
+ * @ne_enclave:	Enclave the allocation is made for.
+ * @args:	Requested size, node and flags.
+ *
+ * Context: Process context. This function is called with the enclave
+ *	    information mutex held.
+ * Return: a file descriptor on success, negative return value on failure.
+ */
+static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
+				 struct ne_alloc_memory_args *args)
+{
+	struct ne_contig_mem *mem;
+	unsigned long remaining;
+	u64 pinned, lock_limit;
+	unsigned long nr_pages;
+	struct file *file;
+	int fd, rc;
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	if (args->flags >= NE_ALLOC_MEMORY_MAX_FLAG_VAL)
+		return -NE_ERR_INVALID_FLAG_VALUE;
+
+	if (!args->size || (args->size & (NE_MIN_MEM_REGION_SIZE - 1)))
+		return -EINVAL;
+
+	if (args->size > ULONG_MAX)
+		return -EINVAL;
+
+	if (args->nid >= MAX_NUMNODES || !node_state(args->nid, N_MEMORY))
+		return -EINVAL;
+
+	/*
+	 * An enclave whose cores all sit on one node takes its memory from that
+	 * node, which is what ne_sanity_check_user_mem_region() asks of a
+	 * hugetlbfs region. An enclave built from a CPU pool that spans nodes
+	 * has no node of its own and may take memory from any of them. Refuse
+	 * here, so that a request naming the wrong node does not spend minutes
+	 * zeroing first.
+	 */
+	if (ne_enclave->numa_node != NUMA_NO_NODE &&
+	    ne_enclave->numa_node != (int)args->nid)
+		return -NE_ERR_MEM_DIFFERENT_NUMA_NODE;
+
+	/*
+	 * A node without an area serves nothing, and no area serves more than
+	 * the host has, so refuse those requests before they are charged and
+	 * before the run array is sized from them.
+	 */
+	if (!ne_numa_cma_area(args->nid) ||
+	    args->size > (u64)totalram_pages() << PAGE_SHIFT)
+		return -ENOMEM;
+
+	nr_pages = args->size >> PAGE_SHIFT;
+
+	/*
+	 * Account the pages against RLIMIT_MEMLOCK, the way a driver that pins
+	 * pages for a device accounts them. pinned_vm is an atomic64, so it can
+	 * be uncharged from ne_contig_release() under whatever locks that path
+	 * happens to hold.
+	 */
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	pinned = atomic64_add_return(nr_pages, &current->mm->pinned_vm);
+	if (pinned > lock_limit && !capable(CAP_IPC_LOCK)) {
+		atomic64_sub(nr_pages, &current->mm->pinned_vm);
+
+		return -ENOMEM;
+	}
+
+	mem = kzalloc_obj(*mem);
+	if (!mem) {
+		atomic64_sub(nr_pages, &current->mm->pinned_vm);
+
+		return -ENOMEM;
+	}
+
+	/*
+	 * A run is at least NE_MIN_MEM_REGION_SIZE, so that bounds how many of
+	 * them an allocation can be made of and the array can be sized for the
+	 * worst case here. At 512 GiB of 2 MiB runs it is 8 MiB, next to nothing
+	 * beside the memory about to be allocated, and it keeps the allocation
+	 * loop from having to grow anything.
+	 */
+	mem->allocs = kvmalloc_array(args->size / NE_MIN_MEM_REGION_SIZE,
+				     sizeof(*mem->allocs),
+				     GFP_KERNEL | __GFP_NOWARN);
+	if (!mem->allocs) {
+		atomic64_sub(nr_pages, &current->mm->pinned_vm);
+		kfree(mem);
+
+		return -ENOMEM;
+	}
+
+	mmgrab(current->mm);
+	mem->mm = current->mm;
+	mem->nr_pinned = nr_pages;
+	mem->size = args->size;
+	mem->enclave_id = ne_enclave->id;
+
+	/*
+	 * Take the runs largest power-of-two chunk first, down to the 2 MiB
+	 * minimum. cma_alloc() is given the 2 MiB alignment the hypervisor asks
+	 * for whatever the size, so every run meets it.
+	 */
+	remaining = args->size;
+	while (remaining) {
+		struct ne_contig_alloc *alloc;
+		struct cma *cma = NULL;
+		struct page *page = NULL;
+		unsigned long chunk;
+
+		for (chunk = remaining; chunk >= NE_MIN_MEM_REGION_SIZE;
+		     chunk >>= 1) {
+			chunk = rounddown_pow_of_two(chunk);
+			page = ne_alloc_contig(chunk >> PAGE_SHIFT, args->nid,
+					       &cma);
+			if (IS_ERR(page)) {
+				rc = PTR_ERR(page);
+				goto err_free;
+			}
+			if (page)
+				break;
+		}
+		if (!page) {
+			rc = -ENOMEM;
+			goto err_free;
+		}
+
+		alloc = &mem->allocs[mem->nr_allocs++];
+		alloc->page = page;
+		alloc->nr_pages = chunk >> PAGE_SHIFT;
+		alloc->cma = cma;
+		alloc->off = args->size - remaining;
+
+		remaining -= chunk;
+		cond_resched();
+	}
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		rc = fd;
+		goto err_free;
+	}
+
+	file = ne_contig_create_file(mem);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		goto err_put_fd;
+	}
+
+	fd_install(fd, file);
+
+	return fd;
+
+err_put_fd:
+	put_unused_fd(fd);
+err_free:
+	ne_contig_free_allocs(mem);
+	atomic64_sub(nr_pages, &mem->mm->pinned_vm);
+	mmdrop(mem->mm);
+	kfree(mem);
+
+	return rc;
+}
+
 #if defined(CONFIG_NITRO_ENCLAVES_MISC_DEV_TEST)
 #include "ne_misc_dev_test.c"
 #endif
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 483037061eafe..1a76c12815298 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -17,6 +17,48 @@
 
 #include "ne_pci_dev.h"
 
+struct cma;
+
+/**
+ * struct ne_contig_alloc - One physically-contiguous run backing a mapping.
+ * @page:	First page of the run.
+ * @nr_pages:	Number of pages in the run.
+ * @off:	Byte offset of the run inside the allocation.
+ * @cma:	CMA area the run came from.
+ */
+struct ne_contig_alloc {
+	struct page		*page;
+	unsigned long		nr_pages;
+	u64			off;
+	struct cma		*cma;
+};
+
+/**
+ * struct ne_contig_mem - Backing state for one contiguous allocation.
+ * @allocs:	Contiguous runs backing the allocation, ordered by offset.
+ * @nr_allocs:	Number of runs in @allocs.
+ * @size:	Size of the allocation in bytes, mirrored in i_size.
+ * @enclave_id:	Id of the enclave the allocation was made for.
+ * @mm:		The mm charged for the pinned pages, held via mmgrab().
+ * @nr_pinned:	Pages charged to @mm->pinned_vm.
+ *
+ * The runs hang off the file, and a mapping's page table entries cannot outlive
+ * them because a VMA holds vm_file for as long as it exists.
+ *
+ * The array is built before the file is published and not mutated afterwards, so
+ * any holder of a reference can read it without a lock of its own, which is what
+ * lets a page fault resolve an offset to a run. @size is set in the same place
+ * and is read the same way.
+ */
+struct ne_contig_mem {
+	struct ne_contig_alloc	*allocs;
+	unsigned int		nr_allocs;
+	u64			size;
+	u64			enclave_id;
+	struct mm_struct	*mm;
+	unsigned long		nr_pinned;
+};
+
 /**
  * struct ne_mem_region - Entry in the enclave user space memory regions list.
  * @mem_region_list_entry:	Entry in the list of enclave memory regions.
@@ -44,6 +86,9 @@ struct ne_mem_region {
  *				the enclave process via the poll function.
  * @has_event:			Variable used to determine if the out-of-band event
  *				was triggered.
+ * @id:				Id of this enclave, unique for the lifetime of the
+ *				driver, recorded in an %NE_ALLOC_MEMORY allocation
+ *				as the enclave it was made for.
  * @max_mem_regions:		The maximum number of memory regions that can be
  *				handled by the hypervisor.
  * @mem_regions_list:		Enclave user space memory regions list.
@@ -72,6 +117,7 @@ struct ne_enclave {
 	struct list_head	enclave_list_entry;
 	wait_queue_head_t	eventq;
 	bool			has_event;
+	u64			id;
 	u64			max_mem_regions;
 	struct list_head	mem_regions_list;
 	u64			mem_size;
@@ -112,6 +158,21 @@ struct ne_devs {
 	struct rw_semaphore	lock;
 };
 
+/**
+ * ne_alloc_contig() - Allocate a physically-contiguous, zeroed run of pages.
+ * @nr_pages:	Number of pages to allocate.
+ * @nid:	NUMA node to allocate from.
+ * @out_cma:	Set to the CMA area the run came from.
+ *
+ * Return: the first page of the run, NULL on allocation failure, or
+ *	   ERR_PTR(-EINTR) when a fatal signal arrived while zeroing.
+ */
+struct page *ne_alloc_contig(unsigned long nr_pages, int nid,
+			     struct cma **out_cma);
+
+void ne_contig_free_run(struct cma *cma, struct page *page,
+			unsigned long nr_pages);
+
 /* Nitro Enclaves (NE) data structure for keeping refs to the NE misc and PCI devices. */
 extern struct ne_devs ne_devs;
 
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index e266b8a611c92..a2919565bc883 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -209,6 +209,76 @@ struct ne_add_any_vcpu_args {
  */
 #define NE_SET_USER_MEMORY_REGION	_IOW(0xAE, 0x23, struct ne_user_memory_region)
 
+/**
+ * struct ne_alloc_memory_args - Request for physically contiguous enclave
+ *				 memory (in).
+ * @size:	Number of bytes to allocate, a multiple of 2 MiB.
+ * @nid:	Host NUMA node to allocate from. One node, named; unlike
+ *		%NE_ADD_ANY_VCPU it does not take %NE_NUMA_ANY.
+ * @flags:	%NE_MEMORY_PRIVATE.
+ */
+struct ne_alloc_memory_args {
+	__u64	size;
+	__u32	nid;
+	__u32	flags;
+};
+
+/**
+ * NE_ALLOC_MEMORY - The command is used to allocate physically contiguous
+ *		     memory to give to an enclave, drawn from one host NUMA
+ *		     node. The argument is input only; on success the return
+ *		     value is a file descriptor for the allocation.
+ *		     Writing to the descriptor places bytes in the allocation,
+ *		     which is how an enclave image gets there.
+ *		     O_APPEND has no effect. There is no read operation, so
+ *		     read() and pread() both fail with EINVAL and a caller that
+ *		     wants to check what it wrote keeps its own copy.
+ *		     A private allocation is never mapped, so an enclave image
+ *		     goes into one through write() or pwrite() and not through
+ *		     a copy into a mapping, and every write is a call the
+ *		     kernel handles and can act on or refuse.
+ *		     The allocation lives until the descriptor is gone.
+ *		     The ioctl can be invoked on the enclave fd, before an
+ *		     enclave is started.
+ *
+ * Context: Process context.
+ * Return:
+ * * >= 0			- File descriptor for the allocation.
+ * * -1				- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * EFAULT			- Argument read failure.
+ * * EINVAL			- The argument is shorter than @flags, or @size
+ *				  is zero, not a multiple of 2 MiB or larger than
+ *				  this kernel can represent, or @nid is not a node
+ *				  with memory.
+ * * EIO			- Current task mm is not the same as the one
+ *				  that created the enclave.
+ * * E2BIG			- The argument is longer than this kernel knows
+ *				  about and the excess is not all zero.
+ * * EINTR			- A fatal signal arrived while zeroing.
+ * * ENODEV			- The kernel has no contiguous allocator.
+ * * ENOMEM			- No contiguous run of the requested size is
+ *				  available on that node, or %RLIMIT_MEMLOCK
+ *				  would be exceeded.
+ * * NE_ERR_NOT_IN_INIT_STATE	- The enclave is not in init state (init =
+ *				  before being started).
+ * * NE_ERR_INVALID_FLAG_VALUE	- The value of the provided flag is invalid.
+ * * NE_ERR_MEM_DIFFERENT_NUMA_NODE
+ *				- @nid is not the node the enclave's CPUs are on.
+ *				  Not returned for an enclave whose CPU pool spans
+ *				  nodes.
+ * * Error codes from get_unused_fd_flags() and anon_inode_create_getfile().
+ *
+ * Writing to the descriptor sets errno to:
+ * * EFBIG			- The write does not fit inside the allocation.
+ * * EFAULT			- Part of the buffer is not readable. Any bytes
+ *				  copied before that are reported as a short
+ *				  write, so a caller that has to know how far it
+ *				  got looks at the return value. A fatal signal
+ *				  part way through is reported the same way.
+ */
+#define NE_ALLOC_MEMORY			_IOW(0xAE, 0x2E, struct ne_alloc_memory_args)
+
 /**
  * NE_START_ENCLAVE - The command is used to trigger enclave start after the
  *		      enclave resources, such as memory and CPU, have been set.
@@ -282,9 +352,10 @@ struct ne_add_any_vcpu_args {
 #define NE_ERR_MEM_NOT_HUGE_PAGE		(263)
 /**
  * NE_ERR_MEM_DIFFERENT_NUMA_NODE - The user space memory region is backed by
- *				    pages from different NUMA nodes than the CPUs.
- *				    Not returned for an enclave whose CPU pool
- *				    spans nodes.
+ *				    pages from different NUMA nodes than the CPUs,
+ *				    or a requested node is not the one the CPUs
+ *				    are on. Not returned for an enclave whose CPU
+ *				    pool spans nodes.
  */
 #define NE_ERR_MEM_DIFFERENT_NUMA_NODE		(264)
 /**
@@ -391,6 +462,19 @@ struct ne_user_memory_region {
 	__u64	userspace_addr;
 };
 
+/**
+ * DOC: Enclave memory allocation flags
+ */
+
+/**
+ * NE_MEMORY_PRIVATE - An allocation the parent has no address for, because it
+ *		       cannot be mapped. Writing to the descriptor is the only
+ *		       way to put an enclave image in one.
+ */
+#define NE_MEMORY_PRIVATE		(0x00)
+
+#define NE_ALLOC_MEMORY_MAX_FLAG_VAL	(0x01)
+
 /**
  * DOC: Enclave start info flags
  */
-- 
2.47.1


