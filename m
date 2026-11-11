Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23BE606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=EfV4Lksv
Received: by kanga.kvack.org (Postfix)
	id C52ED6B05B9; Wed, 11 Nov 2026 18:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03046B05C9; Wed, 11 Nov 2026 18:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB616B05CA; Wed, 11 Nov 2026 18:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85B3A6B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:11:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DB481A043A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:11:15 +0000 (UTC)
X-FDA: 85424386110.05.7A3F5EA
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9873160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:11:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EfV4Lksv;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWy7BP4ZrwP8pEFVqTn9HpToBI15x6F3H7BoABp2EPI=;
	b=X2lS3pqkYogjtjCHXpNUbpRJPeiJrl/qGsgwFviOI9rDDaVtwbmwQ2PxiOSbuROQAFjliR
	ul/3pD35uPfHmTyGvaLdnFOqL7LpQtK5Hesq1iN2vDq80rHc++REgBcssMCG2yby+aYApr
	kDVVCQOTikFsu6JBvmkl4Nrq6U8rXd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438673;
	b=vC9sixsvuGkS6upE3Tky2fcf+zKwJo2ZMkQLg37PmSByFGh5YDBHCb5OuSl7EE1A+eegbA
	GE7Tb7EW4zi45GSj9DYkK3327P78SegwO+RjFlM8arU8jDmhQrVJq8vBiVPrEtMRNVOZU/
	fan1xX0MehIUaMWigCbniKgFH59lbYA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EfV4Lksv;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438673; x=1825974673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fWy7BP4ZrwP8pEFVqTn9HpToBI15x6F3H7BoABp2EPI=;
  b=EfV4LksvX+TEADRp6E3PeHPH3iQsdlhmRX6Wm59E+vwlHezD7zkk8DtC
   0o/HDDDBnJOSc+ioBcArn+1Eu0UCuSSqq4yKDVU3WOlbtN4z5lppdJmXg
   pK5B5CRdDL6Ezwow/w3u2DnBJoR13Dq9FEz5enPBHFSCl9UGhAjbfH32R
   zjn/b6hzlEenTs9jdltxqq6twGzGVwGfbmSlupukliJCnn5DmBXRbFKiu
   uwAKjLh8OTr1SEI/YIfF336afFi/6U/79C10FHCGpDTY37iYEZnPTOV8I
   cyQTcp/dZM/dtHZ6SJ6m5YZYg+dGxhgs4bn+Y68dWC5gGZBW5WLsQlnGs
   A==;
X-CSE-ConnectionGUID: RQ9PyuNdQue3OfBlvbzVWQ==
X-CSE-MsgGUID: pzf0JfnxTuOsJb/W1g02Bg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33630361"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:11:11 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:23343]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id 7d76ce78-6b44-4386-afba-122728c2c947; Wed, 11 Nov 2026 23:11:11 +0000 (UTC)
X-Farcaster-Flow-ID: 7d76ce78-6b44-4386-afba-122728c2c947
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:11:11 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:11:08 +0000
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
Subject: [PATCH 35/40] nitro_enclaves: Add NE_ENCLAVE_DIRECT_MODE
Date: Wed, 11 Nov 2026 22:59:39 +0000
Message-ID: <af6ee68b7edf080cfac1552f3a31a8ffdf42cbf6.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: hkemgm87wznnf5k77zcrsptnu79bsmdi
X-Rspamd-Queue-Id: D9873160003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438672-594020
X-HE-Meta: U2FsdGVkX19AdTaa7xNvhys+CRIfTRETEsezRfUsGHryl0d91pROiyiYkRmn78NKasJQgDW0OVKOaiGj0NVFwsZ0J5tB7oC3l4rWSFJrq33shkiWEXXkXqWzOi/BppXEHg6eTXUPihyscEiP9BBPQVe1qzQKDFIjID01LZRg63AHzNlceug3piEwu4gj/QEhjBlBscY3L8pLYnZsK37mbWgyrjkGLTZZQLN07Ei47AB2fcijTL0YUV7pDrDIOxIUTiWlY7TFRtoKfdp1PIdDv2lK6FibiDGLKJudyk1NcekMMd12IevyX/owAqbUfa9103AvgcPzbbz0/6nHosuHUzVHKX+jd5nIbdjfjPbZMdPPkyYPNJ0zl4bBovCGtq3Gnr9TZO96mgPQmLxJoWgSue9pPm0mSPoWgaefeKKBw+//wZ37vIHtN7RipSBp7duYSKbiVZyEfRW7e9fjvQY2WxttKL7M+ebZMd2+IDE6102gggR4LszxcdxgjJQ+6TpbGum6btqy/Mtx77ZIDHx7AIIys22Ry/ao0D/PJJKp1dI75EwMVuLn6JjiZWPTsUS0xyaqltYV/BbJMjqLnmlroxke7OcGw2IJx7947L7eIk0xJiGmI2fnGoj9hdI2WDPXM88uLivFxQhb1bwtQF/6Ny8QrSNRl8yyyxZoPWdVJdKECiiWmYqk1Fkt33eDcv22tsus9hBbF4FBrqraFN1zMOlM0vSOojIddgdPa+DYLSODl4N3eLAiwUWY779048tmZDIEVJYlLG4QoEYRVezBBSQ9cLXeRdS5OyA73653KrR2/0lVj6/6A23BeYxVaJbj8LA5NkN0wns5ukjZpLx+3UW2bV8RzqyxBqOl+bbLIeNSespFH4Fl5kpVM61nbRIsMXvYvN3oLv+fRfP3g7im3hp/II0wpr+iyEnX8u1/6WIFhSRNX/CPdqilCQUyWSIbDLqpoqackbUjmmPXNDN
 GEqYoJkW
 wIdbAZzuLErLG+hOEtoU3mH/qJZ4L4/6pCw80dKoYrQ3nnv/ZMoHlsMKq8Il9njWShiLFgogXveiAaHVTW3G4yj+uR7pl36g86zixJC5rtbrbb1rasSD6vGZuWqIPKKehegoCrVLgWRDSVejVgcrm3A7rTHr7e/UKkAhzbpr1ibzxLkUjnq4jymFLNYEH8rNIMhhWdYHe/2D0OVufrKyVEZrg4tfKLQE+WwVb6wpT4dykZBVKoSp6XO+RhTXBlNe2TlIBchzvvmuI8Z+/S2wdXKqGQYRczb1npR4phW+JmXJtX/6SweTt2lr5WF8vDDmzKsIPKeRatTnU+uCXW+fzUITw2hE/NLvK+fU9dLGCEgQBaBykDB1OiZb4eXEvhXPrqAD8PH+ZQqLoJOLYPDngNDVIuHjqOUQlZ3pV9TyTeTk4IhUHBGVn2eziFqr3K07d/Ax6UO+nIcPPAKGNm9NldagErulXFUaIXwrEcs5L1v5wD1HrCI5qt5KYoWpt5PhRa2Fdrr1EVdfmYVgyiyvvTk4uSk+aLB0NRugC5BbzopqZC6psJTqgT2vZpr2Y2DzH2Xqb3HNEOL/34Gljg/Y7v5sCOFZwdfhDCoXy/O9tNwoLT3IxakSgRoewkC9XOHicXlpj9ST71OYGsDpXpLllV/wg7UaYCmS7+LkfzPoH9dnD1Vhk3PiCn9pxla+VzCminWJolk6wg1mWw6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes introduce a mode called direct mode, in which the parent
keeps access to most of the memory it donates to the sandbox. This mode
disables any attestation, but enables guest kernels that are not aware
of the Device Memory Buffer (DMB) to work. A DMB-aware guest kernel
places its virtqueues and buffers in memory the device provides, so the
parent needs access to that memory only.

Add NE_ENCLAVE_DIRECT_MODE, which asks the hypervisor for a direct-mode
slot. Remember the flags a slot was allocated with in
ne_enclave->launch_flags. Allow NE_ADD_MEMORY_REGION to use an
NE_MEMORY_SHARED allocation for a slot that carries this flag.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst        |  4 +++-
 drivers/virt/nitro_enclaves/ne_misc_dev.c |  9 +++++++--
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  7 ++++++-
 include/uapi/linux/nitro_enclaves.h       | 19 +++++++++++++++++--
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 012fcb394a2ef..5984fd32ec07a 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -183,7 +183,9 @@ memory region per contiguous run it is made of, or fewer where runs turn out
 to be physically adjacent. It also ends writing: the memory is the enclave's
 from that point, so an image goes in first. It takes private allocations
 only, since memory the parent can still reach is not memory the enclave has
-to itself.
+to itself. A slot allocated with NE_ENCLAVE_DIRECT_MODE asks for an enclave
+whose memory the parent keeps access to, and takes a shared allocation as a
+memory region.
 
 An enclave's memory is laid out in the order its allocations are given to it,
 and the offset NE_GET_IMAGE_LOAD_INFO returns is an offset into that layout.
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 961b821d6038b..cccfceeb575cc 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -3447,6 +3447,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	if (!ne_enclave)
 		return -ENOMEM;
 
+	ne_enclave->launch_flags = flags;
+
 	mutex_lock(&ne_cpu_pool.mutex);
 
 	ne_enclave->nr_parent_vm_cores = ne_cpu_pool.nr_parent_vm_cores;
@@ -4603,9 +4605,12 @@ static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	/*
 	 * The parent may map a shared allocation and keeps any mapping it has
 	 * for as long as the allocation lives. Memory a region is made of is
-	 * the enclave's alone.
+	 * the enclave's alone, unless the slot was allocated for an enclave
+	 * whose memory the parent keeps access to, which is what
+	 * NE_ENCLAVE_DIRECT_MODE asks for.
 	 */
-	if (mem->shared) {
+	if (mem->shared &&
+	    !(ne_enclave->launch_flags & NE_ENCLAVE_DIRECT_MODE)) {
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "The memory region allocation is shared\n");
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index b0d0438157260..1fd93bddf7766 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -22,7 +22,8 @@
 /*
  * NE_ENCLAVE_FLAG_VALID_MASK - Every launch flag this kernel passes on.
  */
-#define NE_ENCLAVE_FLAG_VALID_MASK	(NE_ENCLAVE_PCIE_MODE | \
+#define NE_ENCLAVE_FLAG_VALID_MASK	(NE_ENCLAVE_DIRECT_MODE | \
+					 NE_ENCLAVE_PCIE_MODE | \
 					 NE_ENCLAVE_PCIE_VSOCK_MODE | \
 					 NE_ENCLAVE_PCIE_VIRTIO_MODE | \
 					 NE_ENCLAVE_PCIE_NUMA_MODE)
@@ -203,6 +204,9 @@ struct ne_doorbell_binding {
  *				so that the device keeps the page after user space
  *				has closed the descriptor. NULL until
  *				%NE_SET_INFO_PAGE is called.
+ * @launch_flags:		The launch flag word the slot was allocated with,
+ *				as %NE_CREATE_VM2 received it. Read to answer a
+ *				later call the way the slot was asked for.
  * @notify_bindings:		List of the notifications this enclave has bound
  *				an eventfd to.
  * @devices:			List of struct ne_device_wiring, one for each device
@@ -243,6 +247,7 @@ struct ne_enclave {
 	bool			has_event;
 	u64			id;
 	struct file		*info_file;
+	u64			launch_flags;
 	struct list_head	notify_bindings;
 	struct list_head	devices;
 	u64			max_mem_regions;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 67be5c383c54b..b346e0582c5fa 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -58,6 +58,17 @@
  */
 #define NE_ENCLAVE_PCIE_MODE		(1u << 6)
 
+/**
+ * NE_ENCLAVE_DIRECT_MODE - Allocate a slot whose memory the parent keeps
+ *			    access to. The enclave produces no attestation,
+ *			    since nothing separates its memory from the VM that
+ *			    launched it. An %NE_MEMORY_SHARED allocation can be
+ *			    given to such a slot as a memory region, which a
+ *			    slot without this flag refuses. Requires
+ *			    NE_ENCLAVE_PCIE_MODE.
+ */
+#define NE_ENCLAVE_DIRECT_MODE		(1u << 1)
+
 /**
  * NE_ENCLAVE_PCIE_VSOCK_MODE - Allocate a slot whose PCIe bus holds one
  *				virtio-vsock device, attached before the enclave
@@ -440,7 +451,9 @@ struct ne_add_memory_region_args {
  *			  enclave image goes in before this call. The allocation
  *			  has to be %NE_MEMORY_PRIVATE, since memory the parent
  *			  can still reach is not memory the enclave has to
- *			  itself.
+ *			  itself, unless the slot was allocated with
+ *			  %NE_ENCLAVE_DIRECT_MODE, which asks for an enclave
+ *			  whose memory the parent keeps access to.
  *			  An enclave's memory is laid out in the order its
  *			  allocations are given to it, and the offset from
  *			  %NE_GET_IMAGE_LOAD_INFO is an offset into that layout,
@@ -461,7 +474,9 @@ struct ne_add_memory_region_args {
  * * EINVAL				- The argument is shorter than @flags, or @fd
  *					  is not a descriptor from %NE_ALLOC_MEMORY, or
  *					  the allocation was made for another enclave,
- *					  or the allocation is %NE_MEMORY_SHARED.
+ *					  or the allocation is %NE_MEMORY_SHARED
+ *					  and the slot was not allocated with
+ *					  %NE_ENCLAVE_DIRECT_MODE.
  * * EIO				- Current task mm is not the same as the one
  *					  that created the enclave.
  * * E2BIG				- The argument is longer than this kernel knows
-- 
2.47.1


