Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17338606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Bu3uU6dv
Received: by kanga.kvack.org (Postfix)
	id 2B6E56B05B0; Wed, 11 Nov 2026 18:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2674A6B05B8; Wed, 11 Nov 2026 18:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BF26B05B0; Wed, 11 Nov 2026 18:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E06A06B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:11:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D973A7F5B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:11:49 +0000 (UTC)
X-FDA: 85424387538.13.1D476CA
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf02.hostedemail.com (Postfix) with ESMTP id 240D780004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:11:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Bu3uU6dv;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rw6//3owvAzMi50fF91ps4G2WAPcINUQLX2klqiClY=;
	b=WfZrFEoaOuyyCvV2ZMljX8dizZ7X/nbXwT7JdYyjHcD9mwX5YzD1BAsvDW0apsViI5/y5T
	owuqQwuYP4tLagVI9FJF7NQAwpUbNxJG7SZQeRTeZ8qn2J0MSfgpkuqcjjmIBPWtGpxGB1
	oSHlfrqNgFaRVsXUyhd4ZiR4Oy/XqWk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Bu3uU6dv;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438707;
	b=F+JZGdImIhTs0ACVVwu+y2arIcA1Zfd+32ZSYFJU9QvgU1EhUz9dWB+uYj+7eIFkm7XWj3
	khhDhgeUPvAsNSxdM86LPsHh/nbxV176SqNkS61dDej15vIejHGSYz644muHQuTRQ8P+cJ
	wDCCIZRzXsa258VuKicH3tgO+RefGq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438707; x=1825974707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4rw6//3owvAzMi50fF91ps4G2WAPcINUQLX2klqiClY=;
  b=Bu3uU6dv0UIprKiYh6B40RmXFsCgZgnSHobrCk8/c25BkB13IoZ+NXLp
   +VYkE0DUWi0FCCJDg54ju1U8AdaVLGV0/8K7eLCf6aqC5XX+yRQ+/I6wj
   FEHhvLbKP+EEOrPpSSH99UYVhgsljcqegtZwfseWDyhvRwYCCvlkRKiDT
   Txhugo92X5ALUPpDhn7TCv60KH6YhqkAKUB5tZqCJb3LCZKWP+zU/SBiS
   ih2z2V6Zab2zZ8+032+L8pGermJsPtyJr1fbDY8GjknADGuAEQOsFrFnP
   Pef3jaLs5mhY9NZ4nSB821d/yiBOPAt3cnNsG6m73S5oAAkTDNO03ac//
   g==;
X-CSE-ConnectionGUID: ehV1khM3R5C3ApiNN9Re+Q==
X-CSE-MsgGUID: E9hUfOB8SvOHk2qgHwwthQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33678994"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:11:45 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:6832]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 37a92cb3-4f6c-49b3-9207-5e742ee3e865; Wed, 11 Nov 2026 23:11:45 +0000 (UTC)
X-Farcaster-Flow-ID: 37a92cb3-4f6c-49b3-9207-5e742ee3e865
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:11:45 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:11:42 +0000
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
Subject: [PATCH 36/40] nitro_enclaves: Add NE_ENCLAVE_PCIE_HOTPLUG_MODE
Date: Wed, 11 Nov 2026 22:59:40 +0000
Message-ID: <61b67a9c8353ce6ad1deddd9bf870e5118dcc313.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 240D780004
X-Stat-Signature: tn87dzpduokomwfncyx8eb91rb96geoz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438706-976106
X-HE-Meta: U2FsdGVkX18cBbcTgInX37LfvLGcpNW/VKdKlfZYP6YstEz2FqvFZMjEvjVqpsMcy/Zpt8bwBykRgfaLOVBLCz2wyQ5ewVLe9zqSnswBovzaW3PqPpEdCeMqJRh4INpTAxFmBH7pW6nvN1d1DqwEiYCdEM7Vj59mv00QOvcKb3aKFQqs7jZe/GDWl3UIfCAqNcC39NSBslMatF4z9XcT+/EEz5Vbhkvj5OZdeOFZS3goepc2Joo7B+WegQZOIy1RtRhNU/af6X7ODuVP9IW9WsJQizXrrCpxUn1klg66/YgxnNzm282kWV1Qe2YH71miKzD60TKCkfX3XtiwwFnn0TKVuIWKOLzwzo6dSewPL4CfSnc+06eVeh/mM2648K3QFiX1ml9aOQUnFkwtUX2dh5rbZaV1fmv44ZeNC+TjsZJux3z7/6x9DKeK5CcEi4vP9FHTWUAmF1YXepzbTbDDGVP8dO8W8uL4VKCL4RGSOb52fIHHtWPfoVSDntZUuJkAyouc1qp6H6ikSHcdbYf2KZs6fg/rLVysiuZAslRuZBqO7Qy+ItKcB4tXUlLAnJQo/y+9++UHUafFKGutWedjpUFsZ3kriid0xeJTkkg/FuTw3jKz4nD8iDaS4uWCqEP+ip1NoM6bEnorObrKiRunOhzGPIHJ+Bkz58rlKC2OSE02vhZ0TYig9Zec5Pa06w1sKeqB0QOp0HNu086gxGflssjId75qONes2VNXTXvSPz3Lb11zXjc1EFigKxDCr9ujjmN7ggGjx/ZzYkt2lhHg+7iQQbKjqjGBOktANmfjDOBKSeAMt7PVqEJPupN/M+3YMwFmOlig1otP7JHuz+9EypePspgPeqmcRq5a+kLL4+dm/RBSOYWBcnL8HBCOlEAWcn7dGoLpdE0EYcaS8c7/ltaxPlBhhv/knpMGonEhXclf+jA9+4Mg5C3Z8IWVpu8tJH8odAP38Z4fyn7mBAK
 BCt6qjzd
 2DZBjCST64V4+A7kR/7Z0gmiokOi+4lBsSdEQx1Vlh0xIjjpIBhN4igW93wOkJhWYzxEkcRojJTqORh1hts9EbaT77WMJgm2Kqq07qoBO/EN0io/hoH7HgkjnoYN1o8oHf3UysyVSbKKsNKIyQdOBvbbGeo6ftCPL/zeX+c0BXIdOYKivOybln82pXi+XN/EMm+MpV/jAP+pWvLkTABdqkCM1gOTxMEEYCggkFT3oXnEy3T/4nuwWFybdQzFy0ae/aaPqJpalmAOpckts43Q9GtPOpkQvlNYgUy7BmOAc48ukOzLvQYgnR/oVhgbrPmgv4bM5ECJWMBB7HsTZjZ4ojBlf5jkymojIzQxvm05XLJ266dio24TnhSVLWqJsklAGIABs9wapID7Mgveh6mqd1XUebJKDRRltPAeop9rmIOLxQsV4FG/XfL71NFDiBLCXIUsgmymMU2aB4MetegpssBOEUV63L1WH+U5SQlE8UFh13PjYb+jUT59RAxQx52D3XmFM1VaPaWW7E9ly9R1nEtPXpsNllzRuET43j3rOuuuBmuWZBNVtzTxvGGe3S6P+tz4hOZpMxQmZ70Id8aZD0H1Eevs+tTg5tZctcUvndwQjveabXwJ19OqV4hPTc1WrSxJ+URl9u3vtOW7FYG5at/pVjGpJaI3A+8SlJ//LGXPfRLAOm5IeeSbHRqY97bL2Xohs7wokceCDr+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users want to add devices to a Nitro Sandbox while it runs. The
hypervisor supports that for a slot it sets up for it when it allocates
the slot.

Add NE_ENCLAVE_PCIE_HOTPLUG_MODE, which asks for such a slot, and let
NE_ADD_DEVICE take a device in the running state for a slot that carries
the flag.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |  9 ++++++++-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  1 +
 include/uapi/linux/nitro_enclaves.h       | 24 ++++++++++++++++++++---
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index cccfceeb575cc..870b3a6368cf9 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -2967,7 +2967,14 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		if (rc)
 			return rc;
 
-		if (ne_enclave->state != NE_STATE_INIT) {
+		/*
+		 * A slot allocated to take a device once its enclave runs
+		 * takes one in the running state as well. An enclave that has
+		 * stopped takes nothing either way.
+		 */
+		if (ne_enclave->state != NE_STATE_INIT &&
+		    !(ne_enclave->state == NE_STATE_RUNNING &&
+		      (ne_enclave->launch_flags & NE_ENCLAVE_PCIE_HOTPLUG_MODE))) {
 			dev_err_ratelimited(ne_misc_dev.this_device,
 					    "Enclave is not in init state\n");
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 1fd93bddf7766..ed1b29997e1bb 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -26,6 +26,7 @@
 					 NE_ENCLAVE_PCIE_MODE | \
 					 NE_ENCLAVE_PCIE_VSOCK_MODE | \
 					 NE_ENCLAVE_PCIE_VIRTIO_MODE | \
+					 NE_ENCLAVE_PCIE_HOTPLUG_MODE | \
 					 NE_ENCLAVE_PCIE_NUMA_MODE)
 
 struct cma;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index b346e0582c5fa..f204d0f6e7efd 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -85,6 +85,17 @@
  */
 #define NE_ENCLAVE_PCIE_VIRTIO_MODE	(1u << 9)
 
+/**
+ * NE_ENCLAVE_PCIE_HOTPLUG_MODE - Allocate a slot whose PCIe bus can take
+ *				  a device once the enclave is running. The
+ *				  hypervisor decides it at SLOT_ALLOC time, and
+ *				  %NE_ADD_DEVICE takes a device in the running
+ *				  state for a slot that carries it. Requires
+ *				  NE_ENCLAVE_PCIE_MODE and excludes
+ *				  NE_ENCLAVE_PCIE_VSOCK_MODE.
+ */
+#define NE_ENCLAVE_PCIE_HOTPLUG_MODE	(1u << 8)
+
 /**
  * NE_ENCLAVE_PCIE_NUMA_MODE - Allocate a slot whose memory and vCPUs may come
  *			       from more than one host NUMA node. Without it the
@@ -701,7 +712,11 @@ struct ne_add_device_args {
  *		   An argument that ends at @vq_info is taken and gets no
  *		   @info_notify_index back.
  *		   The ioctl can be invoked on the enclave fd, before an
- *		   enclave is started.
+ *		   enclave is started, and while it is running if the slot
+ *		   was allocated with %NE_ENCLAVE_PCIE_HOTPLUG_MODE. A
+ *		   started enclave refuses %NE_ALLOC_MEMORY, so a device
+ *		   given to one works from allocations made before it
+ *		   started.
  *
  * Context: Process context.
  * Return:
@@ -738,8 +753,11 @@ struct ne_add_device_args {
  * * EPROTO				- The device replied for a different number of
  *					  virtqueues than it was asked for, or placed
  *					  their entries outside the info page.
- * * NE_ERR_NOT_IN_INIT_STATE		- The enclave is not in init state (init =
- *					  before being started).
+ * * NE_ERR_NOT_IN_INIT_STATE		- The enclave left its init state (init =
+ *					  before being started) and the slot was
+ *					  not allocated with
+ *					  %NE_ENCLAVE_PCIE_HOTPLUG_MODE, or the
+ *					  enclave has stopped.
  * * NE_ERR_INVALID_FLAG_VALUE		- The value of the provided flag is invalid.
  * * NE_ERR_MEM_REGION_ALREADY_USED	- An allocation was already given to the
  *					  enclave, or is its info page, or is the
-- 
2.47.1


