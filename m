Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAED606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=srubXlqN
Received: by kanga.kvack.org (Postfix)
	id 65CFD6B05C3; Wed, 11 Nov 2026 18:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6346B6B05C8; Wed, 11 Nov 2026 18:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523B06B05C9; Wed, 11 Nov 2026 18:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC1E6B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:10:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B91B1A7EBD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:10:09 +0000 (UTC)
X-FDA: 85424383338.18.79E73DE
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80DD1140006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:10:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=srubXlqN;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDZYAyEwFLEPoM8ArVh+BkqBnqmxQ1pXMx5+/HtnG0M=;
	b=IS/tYPdP9JFwPlk43DvCYO1/ZuInijo9jNPO3gjVVsjUhWQ5Q/8EV+FDiWwbk8d0djdO0i
	FdblaMnbxcMWM1D4ZcrIBwko+Ri5x5q3jkGa1tJBggrRQCcVfol8dZvuwDHOm1HJVJ1vi2
	sBEYmtcZ2SvEkPiUPQDTQwm+zAPHTgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438607;
	b=4V0VtLAqRgEaPzWsLVfnHPniopHl1qbkjxoQPmTvtO3AQaytj4DnK5FiL0oelRylToMEMT
	fJ1pME09w4B9d/sm0rXUh8b2OsBL60oAS3FM1H/vVUHcfCarp4w0TiUnVExMd6nEh5ARb8
	qRdTvWtNHrjAzmEwCGzfCqxDCHAJ83k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=srubXlqN;
	spf=pass (imf09.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438607; x=1825974607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDZYAyEwFLEPoM8ArVh+BkqBnqmxQ1pXMx5+/HtnG0M=;
  b=srubXlqNoRXIk+kLzWoXkJqp2JDoN5dHbXssiK3wCzEpr4MYfwiH5vSg
   bnu6lmt9RqlBysCB2LhT10vG6lh067php+lCHh2b9QRvKycN+6Cew17mP
   Uvso4z8HchQrmFMjJX5WFd4vSJ3dbzSNtY93vQ4vC5mEDzD1DuSjBKPw3
   OHC0JtrdeZcz2yoX8L4LReHuZwLkbx6zpIn/4MxSBKyeYv5xH/Get/xDy
   wpK3KJQlmcwSJutQfvgmV+xKOliQBrs6kpCgFd23jHmjfCAo30oCZHQXr
   PS1HW7Swn9TULB9U56YiXC9PUxVQIAkUL8GAMTs/jmHii4rAfL/1hW4NM
   g==;
X-CSE-ConnectionGUID: 05YxnUY0RjaUPxUvLr7Giw==
X-CSE-MsgGUID: iWVjtOBTSOSHBGZc5sNcHA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33763365"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:10:03 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:29794]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 5a9ebbb9-a45f-4faf-9201-9772ae59d94b; Wed, 11 Nov 2026 23:10:03 +0000 (UTC)
X-Farcaster-Flow-ID: 5a9ebbb9-a45f-4faf-9201-9772ae59d94b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:10:03 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:10:00 +0000
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
Subject: [PATCH 33/40] nitro_enclaves: Assert the layout of the ioctl argument structs
Date: Wed, 11 Nov 2026 22:59:37 +0000
Message-ID: <32240c96b9b5ce841c6a71fb519e0047f01db097.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80DD1140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zk96734u1mhajudpzgsrdfa8wjrz63oy
X-Rspam-User: 
X-HE-Tag: 1794438607-639937
X-HE-Meta: U2FsdGVkX19KDiX6LAQuEZK253OE4hw98Gck8yTqTrWjRmsiNZxOfyeEjLTxvc6LcSZnBDUNV0O9ns3rFqKYxRksI5irSrqg7obquMgZouGxU1CinZxZxIKktDuXvnVx046NSupa51Br5k93eWsCBCLiwJ8mXVeEyGCpgQrLWNLwytAcjukREkueD1J0xKKlkn4kdY/+54TONo4PTxavCj0IVju7g677OEh5vS8a5O4fPUoyxb7uqP2GDSU4AeebOjNRIijq8K3u0vljH2KIe2EjLX08vgwUpkzc95OfcGC6Z9KFbAKNZZPrF2TXhSEp8L98MQ/uDk6OTK7ZlzLo/CJ37aq6sOpt7vcOCqbDI8qGTFa69d+/UDCAX7rabGj9hF2Ndq6GCjx44eJHwbNgJvz93tzy0xxOUksiCADvJOpbT82BwlXgnK93IaxLDaRMAaBU+ESkOIElFgcXrNrbABNQIuKQDVmu6G+iOMR9ud7ImFiBzAsQa4dqpMuzXps5SjoT43PIBTvWizmMiAVwU33l2Ldc2Ys64PedK8o/7ror6dx05EyR+m8BVT8X+hZOXNtECP0mofqvDoNuksQ01RJ3/4BfL7LtuMWNPGjVZw+SE9tFZQCPOtTWfDuhJqse6icf/WT0JwrFloLKjMbpjaVh7e6PA7Dyb4jYIHk2hy9OsazflSZKp2lC0TS4AU90adpg8kFdr0bT+BLXudjU3P1Z23V1vnhqo66545GHbSUKoxw0eSOZ80Csy9MmVN+5VgM1xGw/Y7dKF04uuOAwwVgc4yqBR6MTTuFW1lGuBbEC5h7k477uvnjdTRrozC6QMBV4oX9AkLm6pultLNGkQsAkkyy88p+hAsuqwXo9bgpyi4YxE6wsynDllJlsvmNtxvZ7Bfef6NY1YrUFneRAMQNgimF2hIef2qBqyi58rARrZySLdqzNLt2Asd8gIxUytzWo2GQvLY6rwQKJk5u
 hk4ialvc
 zZftNvx6LAPvjXVIq6+ZzVjRPfWVNywPt6AxsPwyn5BfqhCBQu3rZNfZVrpp9X0YJlFg9vS5EGb0fXA2FqW85Cp6J8Fb96O/JLslRBt3c9JJCs1kK7KX4I0qsgpO+JtVFjkTapRX5tUufo+bWAryJThLNfknhK/f+eJcMT/Zzs/r6Fo4FWfZiINT2oSvLCzG+JBFmA0SoK2XUEHS4fM8/vTNaWQl3MnIFZWgovQUCSO2BB9CKloReJD0MbrGGRB1veDEkEiLugCWnktAs9i7aIf16gNutYTT5e2fXZwzLK896E71/1mCuPvMSFQICYKccNTtNRtcxrVV8fwhOjytUJuk5MBcKuMKyuLZHh+hz8nKunJ4ap2D3ZifmST2LE+bNb/m/EdC0+Rx088q4ZtEY0dpCMPEOmdedyWkTSUIlKQNvmpYLLB4I4/9ILmCmDFq0pKRIPEp8Ndly5baRJ6mcPCC/iA0T375XrFzX4qW8HymDuC90rT+pbkLEH4j+fgtN5xmp9aB+0aqYpvv7aDMoa/rhf2WvR1lKurrsnZzHJxEcBnXAOMLrEmVmIvFld4xf1auX6pjQzPSaLDss1CtOxByh9e2s19mUBvks9zMXbgy6EliGMJ3rDr42npGUR+6XNtTHQUhaL9iQiNSrIAvWyZVdp27pXvpzjGGIw0kg8s1Ukx9RlxgveSrQf8wGZmrBRIfVR8MOEojHeyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The structs the ioctls carry are the interface user space compiles
against, and a member that changes width or place breaks every caller
built before the change. Two members of the same width swapped for each
other leave sizeof alone, so a size check does not see it.

Assert the size of every struct in the uapi header along with the offset
of every one of its members. A transposition now stops the build at the
line that encodes the old layout.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 74 +++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index e2ff807ec673e..f3ad8ddc31e5b 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -80,6 +80,80 @@
  */
 static_assert(NE_NUMA_ANY == NUMA_NO_NODE);
 
+/*
+ * User space and the driver have to lay the ioctl interface structs out the
+ * same way. A size assert does not catch two members of the same width swapped
+ * for each other, so assert the offsets as well.
+ */
+static_assert(sizeof(struct ne_vq_info) == 8);
+static_assert(offsetof(struct ne_vq_info, msix_vector) == 0);
+static_assert(offsetof(struct ne_vq_info, notify_index) == 2);
+static_assert(offsetof(struct ne_vq_info, msix_entry) == 4);
+static_assert(offsetof(struct ne_vq_info, doorbell_offset) == 6);
+
+static_assert(sizeof(struct ne_shm_region) == 8);
+static_assert(offsetof(struct ne_shm_region, fd) == 0);
+static_assert(offsetof(struct ne_shm_region, shm_id) == 4);
+static_assert(offsetof(struct ne_shm_region, reserved) == 5);
+
+static_assert(sizeof(struct ne_add_device_args) == 688);
+static_assert(offsetof(struct ne_add_device_args, flags) == 0);
+static_assert(offsetof(struct ne_add_device_args, device_type) == 4);
+static_assert(offsetof(struct ne_add_device_args, num_vqs) == 8);
+static_assert(offsetof(struct ne_add_device_args, config_size) == 12);
+static_assert(offsetof(struct ne_add_device_args, num_shm_regions) == 16);
+static_assert(offsetof(struct ne_add_device_args, padding) == 20);
+static_assert(offsetof(struct ne_add_device_args, device_features) == 24);
+static_assert(offsetof(struct ne_add_device_args, device_config) == 88);
+static_assert(offsetof(struct ne_add_device_args, shm_regions_ptr) == 152);
+static_assert(offsetof(struct ne_add_device_args, device_uid) == 160);
+static_assert(offsetof(struct ne_add_device_args, vq_info) == 168);
+static_assert(offsetof(struct ne_add_device_args, info_notify_index) == 680);
+static_assert(offsetof(struct ne_add_device_args, padding2) == 684);
+
+static_assert(sizeof(struct ne_notify_eventfd) == 8);
+static_assert(offsetof(struct ne_notify_eventfd, fd) == 0);
+static_assert(offsetof(struct ne_notify_eventfd, notify_index) == 4);
+
+static_assert(sizeof(struct ne_vring_call) == 8);
+static_assert(offsetof(struct ne_vring_call, fd) == 0);
+static_assert(offsetof(struct ne_vring_call, doorbell_offset) == 4);
+static_assert(offsetof(struct ne_vring_call, reserved) == 6);
+
+static_assert(sizeof(struct ne_create_vm_args) == 16);
+static_assert(offsetof(struct ne_create_vm_args, flags) == 0);
+static_assert(offsetof(struct ne_create_vm_args, slot_uid) == 8);
+
+static_assert(sizeof(struct ne_add_any_vcpu_args) == 8);
+static_assert(offsetof(struct ne_add_any_vcpu_args, numa_node) == 0);
+static_assert(offsetof(struct ne_add_any_vcpu_args, vcpu_id) == 4);
+
+static_assert(sizeof(struct ne_alloc_memory_args) == 16);
+static_assert(offsetof(struct ne_alloc_memory_args, size) == 0);
+static_assert(offsetof(struct ne_alloc_memory_args, nid) == 8);
+static_assert(offsetof(struct ne_alloc_memory_args, flags) == 12);
+
+static_assert(sizeof(struct ne_add_memory_region_args) == 8);
+static_assert(offsetof(struct ne_add_memory_region_args, fd) == 0);
+static_assert(offsetof(struct ne_add_memory_region_args, flags) == 4);
+
+static_assert(sizeof(struct ne_set_info_page_args) == 8);
+static_assert(offsetof(struct ne_set_info_page_args, fd) == 0);
+static_assert(offsetof(struct ne_set_info_page_args, flags) == 4);
+
+static_assert(sizeof(struct ne_image_load_info) == 16);
+static_assert(offsetof(struct ne_image_load_info, flags) == 0);
+static_assert(offsetof(struct ne_image_load_info, memory_offset) == 8);
+
+static_assert(sizeof(struct ne_user_memory_region) == 24);
+static_assert(offsetof(struct ne_user_memory_region, flags) == 0);
+static_assert(offsetof(struct ne_user_memory_region, memory_size) == 8);
+static_assert(offsetof(struct ne_user_memory_region, userspace_addr) == 16);
+
+static_assert(sizeof(struct ne_enclave_start_info) == 16);
+static_assert(offsetof(struct ne_enclave_start_info, flags) == 0);
+static_assert(offsetof(struct ne_enclave_start_info, enclave_cid) == 8);
+
 /**
  * NE_EIF_LOAD_OFFSET - The offset where to copy the Enclave Image Format (EIF)
  *			image in enclave memory.
-- 
2.47.1


