Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B45606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=aWY30qci
Received: by kanga.kvack.org (Postfix)
	id F014D6B05B1; Wed, 11 Nov 2026 18:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8A06B05B9; Wed, 11 Nov 2026 18:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE656B05BA; Wed, 11 Nov 2026 18:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B07A86B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:02:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DB3E1603A1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:02:11 +0000 (UTC)
X-FDA: 85424363262.22.938AC5F
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA1AF140006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:02:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aWY30qci;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxeX7TnOeQeidfd0VzWFsebTuPycm/niS4h2cZ5wwxA=;
	b=zlJ6FFH6TdLEVRcO7QytPsbyulQCE/2TT0vppoAAxAyTepUl7mzsK8hp545khkksca9/fp
	JaXQVVnvR9zlRyClVjkgXDDM/rmxbV6HnTZiDgdC9c7VMGuNkDCZIZ5gVIr7r9k9487EjS
	DJqLX1CLRJs0rK2Jl7p7DTKRThZPXvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438129;
	b=HQjWlGZqrkjHH65mBpKrZuJgsTcxpuMgAWTdqT0PxcK63X6wA/LDWoy6BgUHrcsfUg5qtt
	2J60iGHphCgaOd9YBlPbBgS5ER63FSMp4coJaLAmu5x6IjRWcZVKIgA5jmz/FwQEiuFmBJ
	mKDxPjocqvBK20lZlppeHgN5J5PBOkY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aWY30qci;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438129; x=1825974129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fxeX7TnOeQeidfd0VzWFsebTuPycm/niS4h2cZ5wwxA=;
  b=aWY30qcib5JHvEAAGOOT2wvU6bI5ugtobTJJHjSdKi63ROiI5wyErnKK
   ZKFShQVXzWPS18b6Yr048NEsLnjgUbPBLBRZyQlmj79FNlJlAki24JNqc
   014X20+2l3cmRWmzSqtYDV0Z4AAhmnj1VNIeBSzwctprW4h1H0HaWsAbs
   uQEgH6Wpnon4na+opqcR9PAChG9GVqUJKkX6jRfxHkjT38IN56g1ZocHl
   waxgPf1HSAaU4dNjKXYjiamNczfjHE4D0OWGpCmgXyH7tEhVMp1ELJUvI
   3fwFbt2HHC2lEQitRQC/no9oCM1ppCPgwbHvq9j+Bu8wEweSiOzNIewwZ
   g==;
X-CSE-ConnectionGUID: zbfFMcWfRSuQ2BSmPHMGzw==
X-CSE-MsgGUID: LlLoQtmVR6aIOnk6axVbmw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33797024"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:02:05 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:27716]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 60a5f721-d9ab-4ef8-8e59-27d90924e641; Wed, 11 Nov 2026 23:02:05 +0000 (UTC)
X-Farcaster-Flow-ID: 60a5f721-d9ab-4ef8-8e59-27d90924e641
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:02:04 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:02:02 +0000
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
Subject: [PATCH 19/40] nitro_enclaves: Add the slot pool growth commands
Date: Wed, 11 Nov 2026 22:59:23 +0000
Message-ID: <b16f6669871f64b97cea9ec50baf3462a44054a9.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pxof51wrd5osgtibanozzudj4faqem7s
X-Rspamd-Queue-Id: DA1AF140006
X-Rspam-User: 
X-HE-Tag: 1794438128-66180
X-HE-Meta: U2FsdGVkX1/qOa29I5e/VdXFYeh6IZMoHVXUqvWF/GbKoZ4ZSMWQzJ41a6WglLkjxb9DrwSMDnkXNAR+ONAg6J6kapt61pT/bnblTlcU3TkUgmJ8ATQ9F4NGcxNl1KQYFGPQJshlmpASaw55A7GwnHNZs+G+TH/oCm09D5FzEzikn1OogfhIgcKfayQ/pc7dfkxtC8Z6p8LC5604SiN0ZNd2Tfz2qsqcla+F03syefdi5o//xsrx4MxT7+fe2dYqGf1zYv2WZt7qShWvoiSBXrAd5vrVAnfNGuBe3mFYOSfT9ks5i84vykQYzbSegjagPfeSRw4uPc85hXaailhIiENuYh1Q/hj68hRZOsKN21Sv4TlSaZwht1SxmU0Uc8QG6oEfMyF/ROKQvETJxDQXiFGH1QjIY4U9wsetIrw3J9sCY5iSL4MxxisBpOGGEY1IJc0VT2+aE+oUGVXJ2/rD7D1OSPq79NK32agw5kgx67Vke7bi6Hwe9Ohcgt0J6ZHf1cHne1/tMrPU9N+6KhEqQRFRd1H0iuU2dA+SjyDm/3PL7b3OTtmq7YzSFGwfEzcm11LzKF9bX0DRAB3A0UvWyhzcF8UIRp/mXCwPCcTJaTVbp6Lmkk9IRpGLvyVfqaozCLO+w2hMSX+cSge9wi4EEcd4y58rQXbki1tqAAKtuDOFNTPCw9ESDNlrnbvPLIC2XKjvxNq2CE6DrD3L3c7p7j4PmKE3Fq/bslHn+cpFEB4AfNrOGYsYQRrQlS/RFHzi/rJmC7iGj6ijJaj1v67z6OEO9RtbvLqBVgoo2URhkNUs7kSUjwioJ3LbirInwSn8Ve88Uyg7KyTV0ZJKNvm74BPjy0c18ifRWKMevzIxJRtQvSrmblbmt987ho1S9G2TE8K3/78PcNHl159yHohqrkG0NZzB4MOhXTUKCIaMOGvntgu2rXVo4j4Isq4xtH8KKxPAHpRWkdip5UOg4C8
 4/L8pqv3
 geFi9mYJ41VydcuNTm8Un9QdAfvTvH/NsqQ8hjFLF+T2AiITuGdpQpdRlhhodCr0IH+ZSiFlq3Od7rg9N1UV4q6bDqNOhT3UtY1LPdRSH3ZaM4RQnHcppQXBo/7Pba0NMSFuBZOPlUB7AaTVcS/5S0vy0w7zs5lR/sKCaAd9EUIgOA3mKtn/Oo/7VNDHBfw6cNBUER1wqL+zIvrzQ67kq+uvYl/1PLzThsDheuqHzvxeLKQkraJzlhNWXksJBx+OxaM35UXQPrYnlCKWkTbvw7LrsXOsjivEjmvDSezUCyhP5szV66kNq2geqhCLvXCJeBiGiZARhaHr1rl0K/8JGFUdJTGPdNURfs0s3H06HgeckHNSDGtgockDNo45bjVCJlbG7rShUYTqL3fAP7z1qhfIJaM2SB84BjJId5i46Mkg/x/7pv87PP5ZCmSdQtGwvH5jmfKmNL2kCJ47JzL+4UJCEGRHy83qa3uzK/gL/TuTawzQOBfOjgoNz2bymSGhTAm4bvE/v4M5nPl9cH9Sm2pSGArNSoI6nSBad0B5SQ2IZ4w1jO94dOfJbU1yG7DgmGdB3sd6jgZgg6Xg5K9rZwv33DtOBx8KzjPDoOaCSCrV+MCr4oUiuQq8ToYwS/j0FrnpEh66qjupUawI1maU9Gv9fnZSPG8GdnvYSNloZ6cY3As4DKiXKJijEnHnIoR5RzWnaAxXKwI65IJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to grow the slot pool at runtime, add
SLOT_POOL_MEM_DONATE and SLOT_POOL_GET_LIMITS.

The slot pool has two halves: the slot descriptors, which
SLOT_POOL_DONATE grows, and the memory the device runs slots out of,
which SLOT_POOL_MEM_DONATE grows. Its reply names the part of the
offered run that the device took. A slot needs room in both halves.
SLOT_POOL_GET_LIMITS reports both counts, along with how many slots one
memory donation adds, so that the parent knows which half to grow next.
Both replies get an arm of the reply union.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 50 ++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 4e991c4b0e70f..3718f893e4f65 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -164,6 +164,10 @@
  * @SLOT_POOL_DONATE:		Donate one page of parent memory to the slot
  *				pool.
  * @SLOT_POOL_SHUTDOWN:		Give the whole slot pool back.
+ * @SLOT_POOL_MEM_DONATE:	Donate a run of parent memory to the memory the
+ *				device runs a slot out of.
+ * @SLOT_POOL_GET_LIMITS:	Report how many slots each half of the pool has
+ *				room for.
  * @SLOT_POOL_BASE_DONATE:	Donate the base run of the slot pool.
  * @MAX_CMD:			A gatekeeper for max possible command type.
  */
@@ -185,6 +189,8 @@ enum ne_pci_dev_cmd_type {
 	SLOT_POOL_DONATE	= 16,
 	SLOT_POOL_SHUTDOWN	= 17,
 	SLOT_POOL_BASE_DONATE	= 25,
+	SLOT_POOL_MEM_DONATE	= 26,
+	SLOT_POOL_GET_LIMITS	= 27,
 	MAX_CMD,
 };
 
@@ -344,6 +350,16 @@ struct slot_pool_shutdown_req {
 	u8	unused;
 };
 
+/**
+ * struct slot_pool_mem_donate_req - SLOT_POOL_MEM_DONATE request.
+ * @paddr:	Physical address of the donated run of memory.
+ * @size:	Size, in bytes, of the donated run.
+ */
+struct slot_pool_mem_donate_req {
+	u64	paddr;
+	u64	size;
+};
+
 /**
  * struct ne_pci_dev_cmd_reply - NE PCI device command reply.
  *
@@ -377,6 +393,21 @@ struct slot_pool_shutdown_req {
  * @info.state:			SLOT_INFO. Slot state.
  * @info.padding1:		SLOT_INFO. Padding for the overall data
  *				structure.
+ * @mem_donate:			Fields SLOT_POOL_MEM_DONATE fills.
+ * @mem_donate.consumed_paddr:	SLOT_POOL_MEM_DONATE. Physical address of the
+ *				run the device took out of the donation.
+ * @mem_donate.consumed_size:	SLOT_POOL_MEM_DONATE. Size, in bytes, of the
+ *				run the device took, zero where it took none.
+ * @limits:			Fields SLOT_POOL_GET_LIMITS fills.
+ * @limits.meta_limit:		SLOT_POOL_GET_LIMITS. Slots the descriptors
+ *				donated so far have room for.
+ * @limits.mem_limit:		SLOT_POOL_GET_LIMITS. Slots the memory donated
+ *				so far has room to run.
+ * @limits.slots_per_donation:	SLOT_POOL_GET_LIMITS. Slots one donation of
+ *				memory adds to the memory the device runs a
+ *				slot out of.
+ * @limits.reserved14:		SLOT_POOL_GET_LIMITS. Bytes the device writes as
+ *				zero.
  */
 struct ne_pci_dev_cmd_reply {
 	s32	rc;
@@ -402,6 +433,16 @@ struct ne_pci_dev_cmd_reply {
 			u16	state;
 			u8	padding1[6];
 		} info;
+		struct {
+			u64	consumed_paddr;
+			u64	consumed_size;
+		} mem_donate;
+		struct {
+			u16	meta_limit;
+			u16	mem_limit;
+			u16	slots_per_donation;
+			u16	reserved14;
+		} limits;
 	};
 };
 
@@ -417,6 +458,15 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.mem_size) == 40);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.nr_vcpus) == 48);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.flags) == 56);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.state) == 64);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       mem_donate.consumed_paddr) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       mem_donate.consumed_size) == 16);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, limits.meta_limit) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, limits.mem_limit) == 10);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       limits.slots_per_donation) == 12);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, limits.reserved14) == 14);
 
 /**
  * struct ne_pci_dev - Nitro Enclaves (NE) PCI device.
-- 
2.47.1


