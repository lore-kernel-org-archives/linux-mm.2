Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3AC606B034
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=YqoKQAFT
Received: by kanga.kvack.org (Postfix)
	id E6A9B6B05BE; Wed, 11 Nov 2026 17:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E410A6B05C0; Wed, 11 Nov 2026 17:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36D86B05BE; Wed, 11 Nov 2026 17:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5666B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:43:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 182F7C0467
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:40 +0000 (UTC)
X-FDA: 85424316600.08.758A6E5
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id D28C7C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YqoKQAFT;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0y7qBOyIzOkXG7aIGXVPV38d7P5GLpJdpDg66u1RGU=;
	b=JZsfpnD+hF7mv9ECpDbYaNKqEmaUuGxCRfyrQINhNMins5vwzomnr565ebZLd9P2VRMHxe
	sSuf8VmQQPQ3yNoMdOTTMNub7zOR0lobr4pcY6sm/fsPaKImDnrUV/lwvDaxIA1GDAQ4bQ
	0VfVoE7XNcxnmpgIuy5oWYYIWiFBGYw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YqoKQAFT;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437018;
	b=VxeTZZmbtGPGeFIXCG5lDWS5+7eBdL1M2rENFXk8cqu1EECDPRZAXHtdkAqBvhCc7GA+u/
	A/2mhlepdbgwLoo6ZNhtt//z9kUisVG3xjUXS5WVWH4ryfvVlFU/mOSxx5XXHHT8yG/yfF
	y/RK3TloaY4moSkwFmD6zxcxqdhjiLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437017; x=1825973017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0y7qBOyIzOkXG7aIGXVPV38d7P5GLpJdpDg66u1RGU=;
  b=YqoKQAFTk1/jODH0Ft6mIhD2CKwrFxL1GILL2wt7NHk52Qub25vDOHkl
   7GwhpHYcsT/VAv5+tJbfxl8o65tJ4a555gmeiCPZuVzdGVZ0iFOEdaonz
   g/1cYMFA2TxM3GoxK29UsyzOBrnTf05gD6xM3VNNFNKVYl/4iHCMm34C/
   2emhgxRChIynVnrPA+m5FN1dJqRghdE7WHVi03SvpIQkP0chUJqGBzK79
   J+RvWoP1Yd9xMWK7g7VZf92oRrtCPyTO3ttFpQ5cG/IqjpCEN1IwxYQj+
   ZKBL6WNMDQkYzx2Y7BGjJnZ2ZkFPDwONDXc3oI3KjzsHOIYgh556bXzYP
   g==;
X-CSE-ConnectionGUID: +EoT31uvSvy7esM3Xb6w+g==
X-CSE-MsgGUID: /yI5qGejSdqaEST2erIg3A==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33532185"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:34 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:26726]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id 7d040489-dc19-4c72-8a20-0f1ba5fd1d3b; Wed, 11 Nov 2026 22:43:33 +0000 (UTC)
X-Farcaster-Flow-ID: 7d040489-dc19-4c72-8a20-0f1ba5fd1d3b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:33 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:30 +0000
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
Subject: [PATCH 08/40] nitro_enclaves: Add NE_ADD_MEMORY_REGION
Date: Wed, 11 Nov 2026 22:41:53 +0000
Message-ID: <b64e2f7d73bbbbd3573c3d3b111a39fa0537f307.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: y7eok9km5ccbnuskpc46y7aczajetipa
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D28C7C0008
X-HE-Tag: 1794437017-343772
X-HE-Meta: U2FsdGVkX18oW9dPaaBwkZHwF5q5Uwsc4XSvH0t9pHo7qYP0DCNpqt5HLQnWpDh8stDwdIorSetXkkH/A994no3yfxZIC5Ag358BTf3M9xLo2IfUIYRRUQcyUqM/Nl+owxX/G2DsY0d3u4+PqVs1O3g/upv9NZbOV50KLVrAAJMy9YFJebMi4Q7MxmtjU4gEkcEmVl0dDCvBBIBw24sCbeFvIA2YKlAyN1DZJPvWI8Y1uYb4dstePlS776zQMI38DAtPmX08JFIbbx1FqlUbjtOhiu+PsU0yi2YBl9BSPmI8bzIZbgz1TLS27bsRtp4lXZcFUQDQz3m4laVxIFvn4gfRRUEmDzPAmryNt9VABSXgLDXCDWtTcupmX7KnWlC+JzdaHKnJrQ7lwsM/pz28dyZKUu6HL7sJVm12vJyg4KNk2kE5AjRUpF7BJtq7VEqhr4KCfvexYQMgeGfKKdGe9FNuqAYyYlPHgYlFL/1ndE15/CQhwuC7Wv3FxB1DYPDmp97LZKPhgpuNh03vIC35qABR+OxVSz/YSziL0n7E7sctUAS7qOmwn0B4RYiKuQTAb0N50bi17awyow5k2oavMiNogJvcOOJOt/SiMDlQPqzRMlljSd2u50i/0JYlgs+2r7Xg9FOPkg+nNwunJEoAaNHktttB60ymqoYvE8Hvzdyhvz4TpItd+YvlNjtD0iG3b+pUDaqeKpzw9mBh+jL3qm1Dk6quj7vsqWdWm9vaAosuzlo0o5mA9AeqZ8T+AHXvrJoFfUiMgM0mECln90lrq0Va185RxMgrctUJYKWJcNvzLRp72H4SIFNho7r9fM2hjPjhUxFDM+xz7mCLNjw4MACh0zUcObd5EksDg+hILtx6786XIUL+IamBWcTyQ0BJhPgAJz/klRkGW23GvNd3/BaJ0iDbDFBwJEO8ZhVr0+7irZTNGJZPXDEJoy0MhiE2C+n7nyIhsh5QDjHxUtS
 LvMOKUuZ
 +poA64RJ//EUa0BtTQWqCniTOvc6eGS3DLHAI7OW+25liOyN59Fn2LS1STaIuIlz+m2Npf1lsmTbQ3av6cuhcA3ehXHZJuo0ISNXCPzxvmMi0auhHjsgRsyIx3LyCKvxeiB+ciVN5zOW9T3KMt5Et+VG4UVMvPZNIxCSGb+A/SoIys6BbydAzXkvWnUX4Ndmy71QCWmyX1NPhwnQ5aQDAOG48bbLr0pOOg2hsKy0K3ERrLaBK/XYenC/URY0xPx1lmq1cmV2E/5oomh2c3znFH0FaKfgj39VXzP5b/WGYgsIufm0kYP+A22oW7ZalBk9tUXDMIzKINBBRN2zc5Ps/4KjXoUf9eXKG1vGqyA4tCGbIKzqjk4wwDkdT8Z6y6qUO2Hqa/M2vseKvEXYZBcy83yN6zT6CBwTAR3IBUuTJE88wBpwifK+QUZcHGdr/sNn9YdtKXWsFXyL+Ox+GFUaY2vxu3100C/hgP57Dm9GQF8fr6EmadeBg/B1CszsLXhdIlmkXVg9sQz4/tHDtfYMGB0NSfC4iwj1SInOuXaBm2NotknrPEkLMhmgo5VoZXN+J8bKAJdlJ7fe/4yxp1tI+8jSMwVPm+y0BL9g6II+jpn0fdpFjyOqJ7yWyB9vNmhUv9MrHPr5b04+3j2Vy6nFlbh17O3Sk6KJ9h3vnKxn2ZFZup8Rd4tGpGmmmRLUTudfZ8u8WDMbUQViqaBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The new allocation scheme also requires a new memory add ioctl. Introduce
NE_ADD_MEMORY_REGION which uses the fd that NE_ALLOC_MEMORY returns to
back a slot's memory.

Once memory is donated using this mechanism, disable the ability for user
space to write() into it. It is fully considered donated at this point.

For now, consider slot memory donation as mandatorily donated. You can
not use a SHARED mapping to back it until we introduce DIRECT mode later.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 262 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  32 ++-
 include/uapi/linux/nitro_enclaves.h       | 104 +++++++--
 3 files changed, 379 insertions(+), 19 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 55dbeb5b14d29..38345ad7c7985 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -119,6 +119,8 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
  */
 static atomic64_t ne_enclave_seq = ATOMIC64_INIT(0);
 
+static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
+				      struct ne_add_memory_region_args *args);
 static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
 				 struct ne_alloc_memory_args *args);
 static const struct file_operations ne_fops = {
@@ -2069,6 +2071,39 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		return 0;
 	}
 
+	case NE_EA_IOCTL(NE_ADD_MEMORY_REGION): {
+		struct ne_add_memory_region_args __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_add_memory_region_args args;
+		int rc;
+
+		if (usize < offsetofend(struct ne_add_memory_region_args, flags))
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
+		rc = ne_add_memory_region_ioctl(ne_enclave, &args);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	case NE_EA_IOCTL(NE_ALLOC_MEMORY): {
 		struct ne_alloc_memory_args __user *uargs = (void __user *)arg;
 		unsigned int usize = _IOC_SIZE(cmd);
@@ -2139,6 +2174,33 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 	return rc;
 }
 
+/**
+ * ne_enclave_remove_all_contig_regions() - Drop the enclave's references to the
+ *					    allocations it was given.
+ * @ne_enclave :	Private data associated with the current enclave.
+ *
+ * The last reference on an allocation's file frees its runs and gives back its
+ * %RLIMIT_MEMLOCK charge, so an allocation whose descriptor and mappings are
+ * already gone is freed here.
+ *
+ * Context: Process context. This function is called on an enclave that is on
+ *	    no list and has no file left.
+ */
+static void ne_enclave_remove_all_contig_regions(struct ne_enclave *ne_enclave)
+{
+	struct ne_contig_region *ne_contig_region = NULL;
+	struct ne_contig_region *tmp = NULL;
+
+	list_for_each_entry_safe(ne_contig_region, tmp,
+				 &ne_enclave->contig_regions_list, list) {
+		list_del(&ne_contig_region->list);
+
+		fput(ne_contig_region->file);
+
+		kfree(ne_contig_region);
+	}
+}
+
 /**
  * ne_enclave_remove_all_mem_region_entries() - Remove all memory region entries
  *						from the enclave data structure.
@@ -2278,6 +2340,7 @@ static int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
  */
 static void ne_enclave_free(struct ne_enclave *ne_enclave)
 {
+	ne_enclave_remove_all_contig_regions(ne_enclave);
 	ne_enclave_remove_all_mem_region_entries(ne_enclave);
 	ne_enclave_remove_all_vcpu_id_entries(ne_enclave);
 
@@ -2494,6 +2557,7 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 	ne_enclave->has_event = false;
 	mutex_init(&ne_enclave->enclave_info_mutex);
 	ne_enclave->max_mem_regions = cmd_reply.mem_regions;
+	INIT_LIST_HEAD(&ne_enclave->contig_regions_list);
 	INIT_LIST_HEAD(&ne_enclave->mem_regions_list);
 	ne_enclave->mm = current->mm;
 	ne_enclave->slot_uid = cmd_reply.slot_uid;
@@ -3116,6 +3180,12 @@ static int ne_write_span(void *arg, struct page *page, u64 off, u64 len)
  * refusal is -EFBIG, the same as generic_write_check_limits() gives for a write
  * beyond s_maxbytes. There is no RLIMIT_FSIZE in it, so no SIGXFSZ either.
  *
+ * Donating an allocation closes this path, and @lock is what makes the two
+ * orderly. It is taken here and in ne_add_memory_region_ioctl() and nowhere
+ * else; setting a mapping up and faulting one in both read only fields that
+ * never change, so nothing takes it under mmap_write_lock or in a fault, and
+ * copying from user space under it cannot invert against the fault path.
+ *
  * Return: the number of bytes written, or a negative return value on failure.
  */
 static ssize_t ne_contig_write_iter(struct kiocb *iocb, struct iov_iter *from)
@@ -3132,6 +3202,11 @@ static ssize_t ne_contig_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (pos >= mem->size || count > mem->size - pos)
 		return -EFBIG;
 
+	guard(mutex)(&mem->lock);
+
+	if (mem->donated)
+		return -EPERM;
+
 	rc = ne_walk_allocs(mem, pos, count, NE_WRITE_SPAN_PAGES, ne_write_span,
 			    &ctx);
 
@@ -3165,6 +3240,8 @@ static int ne_contig_release(struct inode *inode, struct file *file)
 
 	mmdrop(mem->mm);
 
+	mutex_destroy(&mem->lock);
+
 	kfree(mem);
 
 	return 0;
@@ -3317,6 +3394,7 @@ static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
 		return -ENOMEM;
 	}
 
+	mutex_init(&mem->lock);
 	mmgrab(current->mm);
 	mem->mm = current->mm;
 	mem->nr_pinned = nr_pages;
@@ -3385,11 +3463,195 @@ static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
 	ne_contig_free_allocs(mem);
 	atomic64_sub(nr_pages, &mem->mm->pinned_vm);
 	mmdrop(mem->mm);
+	mutex_destroy(&mem->lock);
 	kfree(mem);
 
 	return rc;
 }
 
+/**
+ * ne_add_memory_region_ioctl() - Give the slot associated with the current
+ *				  enclave a whole allocation.
+ * @ne_enclave:	Private data associated with the current enclave.
+ * @args:	Descriptor for the allocation, and flags.
+ *
+ * Every run the allocation is made of becomes a memory region, except that runs
+ * which turn out to be physically adjacent are merged into one, so a request
+ * that took several runs takes up several of the enclave's regions or fewer.
+ * The runs are 2 MiB aligned and a multiple of 2 MiB long as they come out of
+ * NE_ALLOC_MEMORY, which is what the hypervisor asks of a region, and no
+ * virtual address is involved on this path at all.
+ *
+ * The reference on the file is what keeps the runs and their %RLIMIT_MEMLOCK
+ * charge alive for as long as the enclave has them, whatever user space does
+ * with the descriptor and its mappings afterwards.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
+				      struct ne_add_memory_region_args *args)
+{
+	struct ne_phys_contig_mem_regions phys_contig_mem_regions = {};
+	struct pci_dev *pdev = ne_devs.ne_pci_dev->pdev;
+	struct ne_contig_region *ne_contig_region = NULL;
+	struct ne_contig_region *held = NULL;
+	struct ne_contig_mem *mem = NULL;
+	unsigned long i = 0;
+	int rc = -EINVAL;
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	if (args->flags) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Incorrect flag for memory region\n");
+
+		return -NE_ERR_INVALID_FLAG_VALUE;
+	}
+
+	CLASS(fd, f)(args->fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+
+	if (fd_file(f)->f_op != &ne_contig_fops) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Not an enclave memory allocation\n");
+
+		return -EINVAL;
+	}
+
+	/*
+	 * Every file with these operations came from ne_contig_create_file(),
+	 * which hands the allocation to anon_inode_create_getfile() before there
+	 * is a descriptor to pass in here, so it is there to be read.
+	 */
+	mem = fd_file(f)->private_data;
+
+	if (mem->enclave_id != ne_enclave->id) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Allocation was made for another enclave\n");
+
+		return -EINVAL;
+	}
+
+	/*
+	 * The parent may map a shared allocation and keeps any mapping it has
+	 * for as long as the allocation lives. Memory a region is made of is
+	 * the enclave's alone.
+	 */
+	if (mem->shared) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The memory region allocation is shared\n");
+
+		return -EINVAL;
+	}
+
+	list_for_each_entry(held, &ne_enclave->contig_regions_list, list) {
+		if (held->file == fd_file(f)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "The memory region is already used\n");
+
+			return -NE_ERR_MEM_REGION_ALREADY_USED;
+		}
+	}
+
+	ne_contig_region = kzalloc_obj(*ne_contig_region);
+	if (!ne_contig_region)
+		return -ENOMEM;
+
+	/*
+	 * One entry per run is the worst case, since merging only ever reduces
+	 * the count. That is 4 MiB of entries for a 512 GiB allocation the
+	 * allocator had to satisfy in 2 MiB runs, so this uses kvmalloc like
+	 * the run array.
+	 */
+	phys_contig_mem_regions.regions = kvzalloc_objs(*phys_contig_mem_regions.regions,
+							mem->nr_allocs);
+	if (!phys_contig_mem_regions.regions) {
+		rc = -ENOMEM;
+
+		goto free_contig_region;
+	}
+
+	for (i = 0; i < mem->nr_allocs; i++) {
+		struct ne_contig_alloc *alloc = &mem->allocs[i];
+
+		rc = ne_merge_phys_contig_memory_regions(&phys_contig_mem_regions,
+							 page_to_phys(alloc->page),
+							 (u64)alloc->nr_pages << PAGE_SHIFT);
+		if (rc < 0)
+			goto free_regions;
+	}
+
+	if ((ne_enclave->nr_mem_regions + phys_contig_mem_regions.num) >
+	    ne_enclave->max_mem_regions) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Reached max memory regions %lld\n",
+				    ne_enclave->max_mem_regions);
+
+		rc = -NE_ERR_MEM_MAX_REGIONS;
+
+		goto free_regions;
+	}
+
+	/*
+	 * From here the allocation is the enclave's. Closing the write path under
+	 * the same lock a write holds means a write either finished before this
+	 * point or is refused after it, so a donation cannot land in the middle of
+	 * one. Whether the whole image got there is the caller's to check: a write
+	 * cut short by an unreadable buffer reports how far it got.
+	 */
+	scoped_guard(mutex, &mem->lock)
+		mem->donated = true;
+
+	ne_contig_region->file = get_file(fd_file(f));
+
+	list_add(&ne_contig_region->list, &ne_enclave->contig_regions_list);
+
+	for (i = 0; i < phys_contig_mem_regions.num; i++) {
+		struct ne_pci_dev_cmd_reply cmd_reply = {};
+		struct slot_add_mem_req slot_add_mem_req = {};
+
+		slot_add_mem_req.slot_uid = ne_enclave->slot_uid;
+		slot_add_mem_req.paddr = phys_contig_mem_regions.regions[i].start;
+		slot_add_mem_req.size = range_len(&phys_contig_mem_regions.regions[i]);
+
+		rc = ne_do_request(pdev, SLOT_ADD_MEM,
+				   &slot_add_mem_req, sizeof(slot_add_mem_req),
+				   &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in slot add mem [rc=%d]\n", rc);
+
+			kvfree(phys_contig_mem_regions.regions);
+
+			/*
+			 * Exit here without dropping the reference on the file
+			 * as memory regions may already been added.
+			 */
+			return rc;
+		}
+
+		ne_enclave->mem_size += slot_add_mem_req.size;
+		ne_enclave->nr_mem_regions++;
+	}
+
+	kvfree(phys_contig_mem_regions.regions);
+
+	return 0;
+
+free_regions:
+	kvfree(phys_contig_mem_regions.regions);
+free_contig_region:
+	kfree(ne_contig_region);
+
+	return rc;
+}
+
 #if defined(CONFIG_NITRO_ENCLAVES_MISC_DEV_TEST)
 #include "ne_misc_dev_test.c"
 #endif
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index fcdf457af5800..2502cca3f3f64 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -42,14 +42,23 @@ struct ne_contig_alloc {
  * @enclave_id:	Id of the enclave the allocation was made for.
  * @mm:		The mm charged for the pinned pages, held via mmgrab().
  * @nr_pinned:	Pages charged to @mm->pinned_vm.
+ * @lock:	Serialises a write against the donation that ends writing.
+ * @donated:	Whether the allocation has been given to its enclave.
  *
- * The runs hang off the file, and a mapping's page table entries cannot outlive
- * them because a VMA holds vm_file for as long as it exists.
+ * The runs hang off the file, so that closing the last descriptor does not free
+ * memory an enclave is still using: a donated region holds the file with
+ * get_file(). That is also what keeps a mapping's page table entries from
+ * outliving the runs, since a VMA holds vm_file for as long as it exists.
  *
  * The array is built before the file is published and not mutated afterwards, so
  * any holder of a reference can read it without a lock of its own, which is what
  * lets a page fault resolve an offset to a run. @shared and @size are set in the
- * same place and are read the same way.
+ * same place and are read the same way. @donated is the one field that changes
+ * after publication, and @lock covers it.
+ *
+ * @enclave_id is compared, never dereferenced, and the counter it comes from is
+ * 64 bits wide, so an allocation cannot be donated to a later enclave that
+ * happens to have been placed at the address of the one it was made for.
  */
 struct ne_contig_mem {
 	struct ne_contig_alloc	*allocs;
@@ -59,6 +68,20 @@ struct ne_contig_mem {
 	u64			enclave_id;
 	struct mm_struct	*mm;
 	unsigned long		nr_pinned;
+	/* Serialises a write against the donation that ends writing. */
+	struct mutex		lock;
+	bool			donated;
+};
+
+/**
+ * struct ne_contig_region - Enclave memory given from one allocation.
+ * @list:	Entry in the enclave's list of allocations given to it.
+ * @file:	File holding the runs, held with get_file() so that they outlive the
+ *		descriptor the allocation was handed out on and its mappings.
+ */
+struct ne_contig_region {
+	struct list_head	list;
+	struct file		*file;
 };
 
 /**
@@ -82,6 +105,8 @@ struct ne_mem_region {
  * @enclave_info_mutex :	Mutex for accessing this internal state.
  * @detached:			The NE PCI device the enclave was created on is
  *				gone. Written with ne_devs.lock held for writing.
+ * @contig_regions_list:	List of %NE_ALLOC_MEMORY allocations given to the
+ *				enclave with %NE_ADD_MEMORY_REGION.
  * @enclave_list_entry :	Entry in the list of created enclaves.
  * @eventq:			Wait queue used for out-of-band event notifications
  *				triggered from the PCI device event handler to
@@ -116,6 +141,7 @@ struct ne_mem_region {
 struct ne_enclave {
 	struct mutex		enclave_info_mutex;
 	bool			detached;
+	struct list_head	contig_regions_list;
 	struct list_head	enclave_list_entry;
 	wait_queue_head_t	eventq;
 	bool			has_event;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index f1315c9c876de..16515fe27b692 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -225,11 +225,13 @@ struct ne_alloc_memory_args {
 
 /**
  * NE_ALLOC_MEMORY - The command is used to allocate physically contiguous
- *		     memory to give to an enclave, drawn from one host NUMA
- *		     node. The argument is input only; on success the return
- *		     value is a file descriptor for the allocation.
+ *		     memory to give to an enclave with %NE_ADD_MEMORY_REGION,
+ *		     drawn from one host NUMA node. The argument is input only;
+ *		     on success the return value is a file descriptor for the
+ *		     allocation.
  *		     Writing to the descriptor places bytes in the allocation,
- *		     which is how an enclave image gets there.
+ *		     which is how an enclave image gets there, and stops
+ *		     working once the allocation has been donated.
  *		     O_APPEND has no effect. There is no read operation, so
  *		     read() and pread() both fail with EINVAL and a caller that
  *		     wants to check what it wrote keeps its own copy.
@@ -241,12 +243,19 @@ struct ne_alloc_memory_args {
  *		     offset 0 or at any other multiple of 2 MiB, for a multiple
  *		     of 2 MiB, with %MAP_SHARED. A caller maps one to keep an
  *		     address for memory it goes on using after it has handed the
- *		     allocation over. Such a mapping is readable too, which is
- *		     the only way to read allocated memory back. The mapping is
- *		     not inherited across fork(); a child that needs one maps
- *		     the descriptor itself.
- *		     The allocation lives until the last of the descriptor and
- *		     its mappings is gone.
+ *		     allocation over, including once the allocation has been
+ *		     donated and writing to the descriptor has stopped working.
+ *		     Such a mapping is readable too, which is the only way to
+ *		     read allocated memory back. The mapping is not inherited
+ *		     across fork(); a child that needs one maps the descriptor
+ *		     itself.
+ *		     Donating does not take a mapping away, so a parent that
+ *		     mapped a shared allocation can still write to it through
+ *		     that mapping afterwards.
+ *		     The allocation lives until the last of the descriptor, its
+ *		     mappings and the enclave regions donated from it is gone,
+ *		     so a caller can close the descriptor as soon as it has
+ *		     donated.
  *		     The ioctl can be invoked on the enclave fd, before an
  *		     enclave is started.
  *
@@ -279,6 +288,8 @@ struct ne_alloc_memory_args {
  * * Error codes from get_unused_fd_flags() and anon_inode_create_getfile().
  *
  * Writing to the descriptor sets errno to:
+ * * EPERM			- The allocation has been donated with
+ *				  %NE_ADD_MEMORY_REGION.
  * * EFBIG			- The write does not fit inside the allocation.
  * * EFAULT			- Part of the buffer is not readable. Any bytes
  *				  copied before that are reported as a short
@@ -299,6 +310,66 @@ struct ne_alloc_memory_args {
  */
 #define NE_ALLOC_MEMORY			_IOW(0xAE, 0x2E, struct ne_alloc_memory_args)
 
+/**
+ * struct ne_add_memory_region_args - Allocation to give to an enclave (in).
+ * @fd:		Descriptor from %NE_ALLOC_MEMORY.
+ * @flags:	Must be zero.
+ */
+struct ne_add_memory_region_args {
+	__s32	fd;
+	__u32	flags;
+};
+
+/**
+ * NE_ADD_MEMORY_REGION - The command is used to give an enclave the whole of an
+ *			  %NE_ALLOC_MEMORY allocation, as one memory region per
+ *			  contiguous run it is made of, or fewer where runs turn
+ *			  out to be physically adjacent. The argument is input
+ *			  only. The allocation has to have been made for this
+ *			  enclave, and can be given away once.
+ *			  Writing to the descriptor stops working here, so an
+ *			  enclave image goes in before this call. The allocation
+ *			  has to be %NE_MEMORY_PRIVATE, since memory the parent
+ *			  can still reach is not memory the enclave has to
+ *			  itself.
+ *			  An enclave's memory is laid out in the order its
+ *			  allocations are given to it, and the offset from
+ *			  %NE_GET_IMAGE_LOAD_INFO is an offset into that layout,
+ *			  so a caller building an enclave out of several
+ *			  allocations picks the order first, writes at the
+ *			  offsets that order implies, and gives them away in it.
+ *			  The ioctl can be invoked on the enclave fd, before an
+ *			  enclave is started.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0					- Logic successfully completed.
+ * * -1					- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV				- The NE PCI device is not available.
+ * * EFAULT				- Argument read failure.
+ * * EBADF				- @fd is not an open file descriptor.
+ * * EINVAL				- The argument is shorter than @flags, or @fd
+ *					  is not a descriptor from %NE_ALLOC_MEMORY, or
+ *					  the allocation was made for another enclave,
+ *					  or the allocation is %NE_MEMORY_SHARED.
+ * * EIO				- Current task mm is not the same as the one
+ *					  that created the enclave.
+ * * E2BIG				- The argument is longer than this kernel knows
+ *					  about and the excess is not all zero.
+ * * ENOMEM				- Memory allocation failure for internal
+ *					  bookkeeping variables.
+ * * NE_ERR_NOT_IN_INIT_STATE		- The enclave is not in init state (init =
+ *					  before being started).
+ * * NE_ERR_INVALID_FLAG_VALUE		- The value of the provided flag is invalid.
+ * * NE_ERR_MEM_REGION_ALREADY_USED	- The allocation was already given to the
+ *					  enclave.
+ * * NE_ERR_MEM_MAX_REGIONS		- The number of memory regions set for the
+ *					  enclave reached maximum.
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_ADD_MEMORY_REGION		_IOW(0xAE, 0x2F, struct ne_add_memory_region_args)
+
 /**
  * NE_START_ENCLAVE - The command is used to trigger enclave start after the
  *		      enclave resources, such as memory and CPU, have been set.
@@ -362,7 +433,8 @@ struct ne_alloc_memory_args {
  */
 #define NE_ERR_UNALIGNED_MEM_REGION_ADDR	(261)
 /**
- * NE_ERR_MEM_REGION_ALREADY_USED - The user space memory region is already used.
+ * NE_ERR_MEM_REGION_ALREADY_USED - The user space memory region, or the
+ *				      %NE_ALLOC_MEMORY allocation, is already used.
  */
 #define NE_ERR_MEM_REGION_ALREADY_USED		(262)
 /**
@@ -495,11 +567,11 @@ struct ne_user_memory_region {
 /**
  * NE_MEMORY_SHARED - An allocation the parent may also map. A mapping is what a
  *		      caller wants for memory it goes on reading or writing
- *		      after it has handed the allocation over. It costs page
- *		      tables for the part of it a caller touches, and it leaves
- *		      the memory reachable from the parent for as long as it
- *		      lives, so an allocation that is only being handed over
- *		      does not ask for one.
+ *		      after it has handed the allocation over, including after
+ *		      it has been donated. It costs page tables for the part of
+ *		      it a caller touches, and it leaves the memory reachable
+ *		      from the parent for as long as it lives, so an allocation
+ *		      that is only being handed over does not ask for one.
  */
 #define NE_MEMORY_SHARED		(0x01)
 
-- 
2.47.1


