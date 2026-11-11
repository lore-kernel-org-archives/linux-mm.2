Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B30606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=RS7W5QII
Received: by kanga.kvack.org (Postfix)
	id 0D75E6B05C2; Wed, 11 Nov 2026 17:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AEB16B05C3; Wed, 11 Nov 2026 17:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB78A6B05C4; Wed, 11 Nov 2026 17:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C10CD6B05C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:44:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47EA912044A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:09 +0000 (UTC)
X-FDA: 85424317818.10.93BD0AD
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2605140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=RS7W5QII;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8Lc096Oet60aLIy9WQq9zqJJ5FyBT2YGQ3yPJEK0l0=;
	b=CjksLnpE6xRHvHGXlz9XfJDlyqBdqLtBL1wrZO3rulxPFz9bico23clt2ckqinhwCq2cIk
	WUeDVbeb74dBdMrjD6kwDBIBWCDqnB8A75gC2OY1qB9tQOFx8/rv8ZArz4vy8aSsRoCgQh
	hKRLLQKxxgRtijedov2HX3glZpzCRt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437047;
	b=BFC4M1eJjYNUKmKFU7O0el+XdPUhCLKzrpUFlR/DHyqmiG1fgjuHDPBZKfIkjVI9Ws27Zh
	cWqLGLizH6aknWgxnmo2dJiy4gwdqgfBVrGKycjppaKrDH8r+F1vylCm50e0FG31WFvwxd
	E0KTqt3ShP70CVgO9xKG2vUnrUXfzQs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=RS7W5QII;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437047; x=1825973047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n8Lc096Oet60aLIy9WQq9zqJJ5FyBT2YGQ3yPJEK0l0=;
  b=RS7W5QIIkBMLOono1cdCexH6rF4ME2ZU3rdzezEOjwOcP18Y2amkBnW5
   2YASVogKsDkQwovf0KmUUrEbWgkMocR+c0bR0mgNdxq9cFjdWxRbm+LXh
   DlvOs/lHFyaKpKe1y/SX42NMbYT8d+E3WOLRLf2sx9V1XqAqNjcu1d2iH
   FIosM65qMpy+nzGei5P5Ocuf1fKchzuac8XoZb0XgSnhG3xfjRx8LnzfD
   egtqvr/qjPYTlOsPo8frEDGqEpja5YHB5sRi4nVXyQ/9FR3bt6crOBOGz
   GLjbFVJmzx6dfor+trGa/LNYXo64zxo0EwJB81OD0wJ93LK0wY2wJlhrD
   w==;
X-CSE-ConnectionGUID: rACnm+byQrOkc60LRF9f1A==
X-CSE-MsgGUID: pcu9icCDSn+CECtcsEsy0A==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33662130"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:44:03 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:30654]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 57fa7319-0315-4534-8905-169f80a09adf; Wed, 11 Nov 2026 22:44:02 +0000 (UTC)
X-Farcaster-Flow-ID: 57fa7319-0315-4534-8905-169f80a09adf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:44:02 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:59 +0000
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
Subject: [PATCH 11/40] nitro_enclaves: Add NE_ENCLAVE_PCIE_MODE launch flag
Date: Wed, 11 Nov 2026 22:41:56 +0000
Message-ID: <a183902fff38e2e2aab7be409569cdfa3aee4a4a.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: j17xz61g743rfissks71pjr6d94oy8fs
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2605140007
X-HE-Tag: 1794437046-733765
X-HE-Meta: U2FsdGVkX19Z6PSEnmyndQaY+fV2q2BPk3LGKWVqMlvsx1uL7OlVL0xe9S13GXc42NP1ptVAMF0JcWN7HFdqIaC9zrLDiTyvHMETd6D+7UfIvzMdeXBo1IKzKojk1mHGA1Tcldl6s/GE00vSm8XTfbgOurzMtZlSrnr50NAEW9XoClSm6GhvhsanFHwytwujDXBxE6iIPysR93VWZyXchwBcxUpeZIqx/twzKx7mDgwGQFjODwtXnTojPbyDjnwJ5VlYIKC0gneVevsemi/7la5+5juYbGD/JpeePQ8RYuuvNz/3IRQIj87RMsihTwWrIT7ffY4+y2onqaqIEQKUEjL4CD/7Jj1PFUFbUskKayp4qfsI5jUN4uGRr9YmmkU/ynt9EqfijCgwFHiAmkfFxHVI3JWL9L4w80F0DO2PuUyYcB5ej9ak/WT05h56vbh2hlFTSoZpquIimyZN0HQIe+5SmfDnnrqz//zOYhEZe+5jWG7JPdKZIEB8dtW4Yi/Dfr0ArjX3zj6ABIhDMuopi1cCSf/xPuHYMmhWPr8zi/IVob8VUAsRxAuTHt5Ju8JPezROw5gA8go8f3RglCqYJaiKjtmG6Ms3aJHs24KQLcu5i7ntzFg3iMHUFHCiz3E/m52Iapt9j9pX14mrBO1JwHI3bWyIs09UML1gPUBD7czHVJhzGqcX7oaKH490tD9RY5o0qkjgHfd5jChQfO7Kb38TuJP+E+2yrzdEkPA1SoF7rLKcGdrXi+e8JuJKtMAlkOd+4d94HLyBUq8amqh4X9o2K3mw8wnj7YEE1yV3/44AdKHhn/waUD6avEWSqouxiMQiX3ghJI+8M9MJ5q4co9XrwHDzXt/57x5KV1/ze8hNF0bPY8bSnttrU0Tip69delIBM43S8RI3O6LbAZ0NP574YKRThmogO/6Hf5wlrQFaryORm3B+q6UQatw4lP5w9UcRpoP7da0YBU3yaPY
 Q9Wjb89U
 MsegEYDxqY9gZef4rT+sJ2sD++tvQ7s1+1wgqnNOmPBQvOz+9+RaY4Ccyyv1SvPNhzmL8Tr2tzw+CdjmCjy2UlPXArHFm7sZ+80mgjCe+8ddCOehvKCmlDYHowB56juAgqO9/0SpF9xov/FD821AdV/Pnm+gA/agE5xpSxVXf9q9oxuqcMCqfd09U4q0NxakM4SIVkKRsCx9Uee/vtvFLdG1RqdHDYasu//GoQJExzAtYqpGpr+jF4wGRG4nTUmrLDTbNn8/SYvWEJnBgUQ3dgMbz3PBEoH6MlpDqJt6cS4CL3tBr/2iUa/jgnYkR0ZntDgLEHyGnIsx5UC8htGQKogoz2a9cLLNg3khMPWJ9xubAQnosrli5AlBJOqL8Fc4H6BBF6d1G4Xj4HVDWajlvW7hd2x2R+0ZnZgw6FFdVVtszs8z6gme2q6VKDZzGN77b31BsqFLXKEX2ymfBqXAaMCXkRXbD+AkO5+KSnDIMMv6kKPztG9+OJswTXs2fN+ehOZ6Gr6tHsUlKzY/ZVLWBhHDVnwfMybJ1mnMrhjuWCGvIntEPXE209vprn4M2Hth5jrKr4JwI9pqDU7mBuG1m6QP6LM5kc9E7Ckhdn+J3jGuy6YCJ3qXluTMUFq8QTIbu29zKEdMJQIIkqgFX9wQzWRa3VYFPKqOpk9R86VuF2mPXPBRfyOl26q8XF+22vKjtwVDCyeAtAlXS80w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes give their guest virtio devices that the parent
provides, on a PCIe bus. The hypervisor sets up that bus when it
allocates the slot, so user space asks for it with a launch flag.

Define NE_ENCLAVE_PCIE_MODE, the first launch flag, and forward it in
SLOT_ALLOC. struct slot_alloc_req gains a flag word, and at offset 0,
over the unused field, a payload_version byte that tells the device to
read it. We send version 1 when a flag is set, and the all-zero request
of today otherwise.

A device that takes launch flags publishes a vendor-specific PCI
capability. A device that predates them ignores the flag word and
allocates a plain slot, so refuse a launch flag with -EOPNOTSUPP on a
device without the capability.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 19 ++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  | 23 +++++++++++++++++++++--
 include/uapi/linux/nitro_enclaves.h       | 14 ++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 68c497df4f14b..0bf62f703806e 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -2475,13 +2475,30 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	int rc = -EINVAL;
 	struct slot_alloc_req slot_alloc_req = {};
 
-	if (flags) {
+	if (flags & ~(u64)NE_ENCLAVE_PCIE_MODE) {
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Unknown launch flag bit set 0x%llx\n", flags);
 
 		return -NE_ERR_INVALID_FLAG_VALUE;
 	}
 
+	/*
+	 * A device that takes launch flags publishes a vendor-specific
+	 * capability. One without it takes no launch flags and would allocate a
+	 * slot without the properties they ask for.
+	 */
+	if (flags && !pci_find_capability(ne_pci_dev->pdev, PCI_CAP_ID_VNDR)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Device takes no launch flags\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (flags) {
+		slot_alloc_req.payload_version = 1;
+		slot_alloc_req.flags = flags;
+	}
+
 	mutex_lock(&ne_cpu_pool.mutex);
 
 	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 19e129d14a3a0..b0957e2606ec3 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -7,10 +7,12 @@
 #define _NE_PCI_DEV_H_
 
 #include <linux/atomic.h>
+#include <linux/build_bug.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/stddef.h>
 #include <linux/wait.h>
 
 /**
@@ -174,12 +176,29 @@ struct enclave_stop_req {
 
 /**
  * struct slot_alloc_req - SLOT_ALLOC request.
- * @unused:	In order to avoid weird sizeof edge cases.
+ * @payload_version:	Wire version at offset 0. Zero is the value a driver
+ *			without launch flags leaves here, and tells the device
+ *			to disregard @reserved and @flags. 1 means @flags is
+ *			valid.
+ * @reserved:		Alignment padding between @payload_version and
+ *			@flags. Zero.
+ * @flags:		Launch flag word from NE_CREATE_VM2, valid when
+ *			@payload_version >= 1.
  */
 struct slot_alloc_req {
-	u8	unused;
+	u8	payload_version;
+	u8	reserved[3];
+	u32	flags;
 };
 
+/*
+ * The device picks these fields out of the payload by offset, so a change
+ * to the layout here changes the SLOT_ALLOC wire format.
+ */
+static_assert(sizeof(struct slot_alloc_req) == 8);
+static_assert(offsetof(struct slot_alloc_req, reserved) == 1);
+static_assert(offsetof(struct slot_alloc_req, flags) == 4);
+
 /**
  * struct slot_free_req - SLOT_FREE request.
  * @slot_uid:	Slot unique id mapped to the slot to free.
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 8e43be9a0a1fa..8ccf16e9cf5fb 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -46,6 +46,18 @@
  */
 #define NE_CREATE_VM			_IOR(0xAE, 0x20, __u64)
 
+/**
+ * DOC: NE_CREATE_VM2 launch flags
+ */
+
+/**
+ * NE_ENCLAVE_PCIE_MODE - Allocate a slot with a PCIe bus. The
+ *			  hypervisor selects PCIe backing for the slot at
+ *			  SLOT_ALLOC time, so a caller that wants it asks
+ *			  for it here and not at enclave start.
+ */
+#define NE_ENCLAVE_PCIE_MODE		(1u << 6)
+
 /**
  * struct ne_create_vm_args - NE_CREATE_VM2 argument (in / out).
  * @flags:	Launch-time flag word (in). Flags select properties of the
@@ -82,6 +94,8 @@ struct ne_create_vm_args {
  * * EFAULT				- Argument read or write failure.
  * * NE_ERR_INVALID_FLAG_VALUE		- Unknown flag bit set, or
  *					  NE_ENCLAVE_DEBUG_MODE set.
+ * * EOPNOTSUPP			- A launch flag is set and the NE PCI
+ *					  device takes no launch flags.
  * * EINVAL				- The argument stops before @slot_uid.
  * * E2BIG				- The argument carries a field this kernel
  *					  does not know, set to a non-zero value.
-- 
2.47.1


