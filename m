Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8360606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Z5n5f62e
Received: by kanga.kvack.org (Postfix)
	id BDD216B05B4; Wed, 11 Nov 2026 18:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D4C6B05B7; Wed, 11 Nov 2026 18:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C9F6B05C9; Wed, 11 Nov 2026 18:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5F26B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:10:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AEA9A7EBD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:10:41 +0000 (UTC)
X-FDA: 85424384682.09.190BF9F
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id E32B7A0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:10:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z5n5f62e;
	spf=pass (imf25.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCnIXJwEIeew7GeEdm/L9dlF07S94PYfaBGXUGwdBts=;
	b=iD3hj6GBCopEZluHvrASMj4EZkHy1bCR7saw0BmXrkc3xwL1X6JB7M//JzzZfGx01RVcrW
	Ve+HnEB7hHjTsbzlpsDXyFNUQyMyaGNdAWZgP+Y8Oz6fmi9ge3MfPaDK1AIiKPrsNK/0ee
	D+zmH2LIGOuW1lV3H1UcWDADVrQX4O0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z5n5f62e;
	spf=pass (imf25.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438639;
	b=T0WNiBMh8GbBGsTZONOSrPX8M4/9Jlkgbi4iCh7lpOhtAqrh2uC8oEiqf6qXfP9oIpvSTd
	njZbjtFSZgF6vNFucl9O840XLl7wUUb9mLwilSI5aSJLjiXt3+qR6Hl57CM0seiYeTGjQk
	9OVB/ibXJ2RC7lz4Do2YWTOVEBQi2e0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438639; x=1825974639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NCnIXJwEIeew7GeEdm/L9dlF07S94PYfaBGXUGwdBts=;
  b=Z5n5f62eQcYIczGsPC/g3aEa7pTRfkXr1bCOacDoxvwK6h4ibrnHHgum
   mD20G62FCo+vKm2ldnyMQ+5Pi/RvX6ZV5i/oP49hP5nUmEQWErrF9zDsq
   rIPCXFfZTLN5g/kLFku7G4BtfaAmckEPwdOtaJCIUXq3naZll0gPX787u
   RMX5OuqgnoiGKXK16/pMYZbi26xGSSBFZBAyl7xmsEP/fzdgQdw1zL6TH
   eUh6BvSEqqndW+eXSJ+G9oERyh8cinXe6husHG2dT64U+OLUpylnJx8j/
   ef2bF27KcHH6pMq1CcoFZOTUwe9cc0FgOWVoc8uNE8QZn67/jBT9ybQTn
   A==;
X-CSE-ConnectionGUID: /fgMkoezTtGxeD4JZ0Tswg==
X-CSE-MsgGUID: Hu4Um1q4ReSCGa71KDbHFw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33739627"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:10:37 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:28980]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 0791c7fc-c29d-4b30-b989-231e12d448a5; Wed, 11 Nov 2026 23:10:37 +0000 (UTC)
X-Farcaster-Flow-ID: 0791c7fc-c29d-4b30-b989-231e12d448a5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:10:37 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:10:34 +0000
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
Subject: [PATCH 34/40] nitro_enclaves: Pass on the Nitro Sandbox launch flags
Date: Wed, 11 Nov 2026 22:59:38 +0000
Message-ID: <70da7aa106af963deb9eb197fcd1c63453e63087.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: h7in5okasp9i9nh7w8tgwn9sjhxzjbyq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E32B7A0008
X-HE-Tag: 1794438638-565674
X-HE-Meta: U2FsdGVkX18HzZ86YQmmgTxwXTegodCq9qQxbuSHyW0naxI6pUnggcVnBqkZVkkjP+Cv4o0wm9o/xmkkzgB8LjSo5DHRi3FDq8AsR5D7QmGIvEYkQb0jd4y3YCI7MyAogTx7KmtKeDLi9ueqx5aMPRguHlwXAW7JyaYdga837clC69+/4JU90UiPbKOkTNMqbd9Dybouk9lTm2SH9UhUWEWq9h8z8cVK7VoLabH2Ah73bzEv1zTDWMvtf8EPdDu4Dk9fIPnmnjIZotUQInXmNegfJPDO7A4ck4UGvpeGFL0UFlzHqzQXax6vnzgfEmth64oJh/Y9FPK6SEKrVyaSm00f2zaeG/x8RgJEefDtmZ6gTfoPicgohgClODuJkPMk8utx4+8EiIKhCTxbWNlMQ+r339RaFbf6mUvQbab24EYirx4XV4hMO29/zxLlxZj/C4kQWqRlIqN3RJK23MeWqH/MzEZ4pB3eIOM88e9eSr0fPylnYWPQnlW9JPJjGTIXn2fIqmkXM/uVR3yUHZBDLugPWRlqAblSwak1yQZ3GVeXWjoYQpS1IUtCarIBzXBIwDGCJSmrjbwwfD73OJKY5IPzCfhYPNRG7rLYE2XOHZf+rP8Zt7I0UbLrtpDBOUraRWc4cf3b1k3oeapfWTDr8uePVgTN9ymc94kbz95HI8o6dJVR/QmnCEgVhaMCJNbDsuePU7pVEIL3zqlggEM6MVjgU96pSKw5+aM1DHAAFlodPFjihX916a+91vSpxZx1a+IBoC4RTfl9CL0AlVWJeahtl/Jk+gJcb/QCSTsShJ2nq7UvfSGDw0t2YRJmFmn/lUMvG6aAX9+pXtwbCG6qsVAp5WsReR3oaz29qUur+mtf0QLZRpk9ogqy6mwe5PGhG1o9c3YVBrGHg+CIMpe08kmTAZL0GtsieniFtCDueJVjVidrglnIUFOc/VdP+5XIXSZ34J7SvaQLlS9jpe8
 EKjkcWOC
 szWZVVZm+7BNWv9gG4gF4TbQtx/OnN5HZNBLuBI/NHExuUDacYaIULBfp9JcDxdB9zOxbW2g/SLhJX7/vqrs7nBUQdT8fkBInX9RDT0CLLtuIStx+dM/f6+Oev1mU9/EfboBBRKAQQpoiL+LoIpumQkv7aYVE20ZldXEptdrCv/z2flJYu3RlcIitO9xQ7vZ7riPH8Map/UL81vHQHoHzjwy9GdAIe6wqGuzkQs9m1TaY22x7zFD6pjsEoMNFWlfpkEkeqW0oHdECzyWExF883RkGfwlcQn/KVv8NSv7cyuVbobaMwdNHYmjNaNcNMG7oZKFdBuK5YHzejACyWy0fcfLZVx8j4U2cRxrur8PzHXcF3/kN6A3MH2gPHfASQM6aD5ZVNlsVSN/bT+YbrCY+Igg15Z715EXSNSuQcobbdFegnJHDOuBqqBCRgvd52efZ/+na2/MYGXnqBIk7nq5VcQKzT35BaxrDw/Z1xQbBZ6p4/bp7bbZwvjSPRBJ/aZEfk7mrslP/uiFX6jRPfCq2wXGg3J3gIn/WKQ9W6qn3KrNleZzBrYo6Rj4hp+/NCAbpWhXWFAlxvA6TJPQ6fxFBd16HCnwMtOWemDgCTgNU4CjmfasR31Tz/sOtFTUiUbA+kzGEHtqLaXuUn2P5ELCuyLd/7/dOtXxSpuYDI0voB7MlA4By2k8ks8lYqRihtIj0GVkOJ66RblKaDVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes support multiple flags to enable or disable particular
bits of functionality. These bits are typically in sync with the EIF file
and need to get set already on slot creation, not only when we start the
sandbox.

Add definitions for the first batch of launch flags and make sure user
space can only set known flags:

NE_ENCLAVE_PCIE_VSOCK_MODE - Parent may add one single vsock device
NE_ENCLAVE_PCIE_VIRTIO_MODE - Parent may add (almost) any virtio device
NE_ENCLAVE_PCIE_NUMA_MODE - Slot may span multiple NUMA nodes

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |  2 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  8 +++++
 include/uapi/linux/nitro_enclaves.h       | 38 +++++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f3ad8ddc31e5b..961b821d6038b 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -3402,7 +3402,7 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	int rc = -EINVAL;
 	struct slot_alloc_req slot_alloc_req = {};
 
-	if (flags & ~(u64)NE_ENCLAVE_PCIE_MODE) {
+	if (flags & ~(u64)NE_ENCLAVE_FLAG_VALID_MASK) {
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Unknown launch flag bit set 0x%llx\n", flags);
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index f9ef79fafa2be..b0d0438157260 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -19,6 +19,14 @@
 
 #include "ne_pci_dev.h"
 
+/*
+ * NE_ENCLAVE_FLAG_VALID_MASK - Every launch flag this kernel passes on.
+ */
+#define NE_ENCLAVE_FLAG_VALID_MASK	(NE_ENCLAVE_PCIE_MODE | \
+					 NE_ENCLAVE_PCIE_VSOCK_MODE | \
+					 NE_ENCLAVE_PCIE_VIRTIO_MODE | \
+					 NE_ENCLAVE_PCIE_NUMA_MODE)
+
 struct cma;
 
 /**
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 01bec4d072d6a..67be5c383c54b 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -58,6 +58,44 @@
  */
 #define NE_ENCLAVE_PCIE_MODE		(1u << 6)
 
+/**
+ * NE_ENCLAVE_PCIE_VSOCK_MODE - Allocate a slot whose PCIe bus holds one
+ *				virtio-vsock device, attached before the enclave
+ *				starts. Requires NE_ENCLAVE_PCIE_MODE and
+ *				excludes NE_ENCLAVE_PCIE_VIRTIO_MODE.
+ */
+#define NE_ENCLAVE_PCIE_VSOCK_MODE	(1u << 7)
+
+/**
+ * NE_ENCLAVE_PCIE_VIRTIO_MODE - Allocate a slot whose PCIe bus takes any
+ *				 virtio device type %NE_ADD_DEVICE offers it.
+ *				 Requires NE_ENCLAVE_PCIE_MODE and excludes
+ *				 NE_ENCLAVE_PCIE_VSOCK_MODE.
+ */
+#define NE_ENCLAVE_PCIE_VIRTIO_MODE	(1u << 9)
+
+/**
+ * NE_ENCLAVE_PCIE_NUMA_MODE - Allocate a slot whose memory and vCPUs may come
+ *			       from more than one host NUMA node. Without it the
+ *			       hypervisor refuses a slot that would straddle a
+ *			       node boundary. Requires NE_ENCLAVE_PCIE_MODE.
+ */
+#define NE_ENCLAVE_PCIE_NUMA_MODE	(1u << 13)
+
+/**
+ * NE_ENCLAVE_FLAG_UNMATCHED_MASK - The launch flags the hypervisor does not
+ *				    enumerate. It answers for them when a slot is
+ *				    allocated with them and not before.
+ */
+#define NE_ENCLAVE_FLAG_UNMATCHED_MASK	(0x003fu)
+
+/**
+ * NE_ENCLAVE_FLAG_MATCHED_MASK - The launch flags the hypervisor enumerates.
+ *				  It answers for them before a slot is
+ *				  allocated with them.
+ */
+#define NE_ENCLAVE_FLAG_MATCHED_MASK	(0xffc0u)
+
 /**
  * struct ne_create_vm_args - NE_CREATE_VM2 argument (in / out).
  * @flags:	Launch-time flag word (in). Flags select properties of the
-- 
2.47.1


