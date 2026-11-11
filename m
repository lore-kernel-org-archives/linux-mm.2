Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAF960A2601
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=HYBe+NyF
Received: by kanga.kvack.org (Postfix)
	id 25A126B05B3; Wed, 11 Nov 2026 17:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B4B6B05B4; Wed, 11 Nov 2026 17:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122406B05B5; Wed, 11 Nov 2026 17:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA3FD6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:42:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77C8F1603A1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:36 +0000 (UTC)
X-FDA: 85424313912.30.8956C0A
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf05.hostedemail.com (Postfix) with ESMTP id 53E3F100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:42:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HYBe+NyF;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf05.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Nf/e7h6zi5zw9Vu4WfB0GEyN8EmLcf8HjHUMJ9G9oow=;
	b=AsoTtbCk3A3s4If4f1W3bBKCo7mJW4G0Z6r2c4YK5mXV8cTz2GIXCP3X4jVlX7w6jzv7Gd
	Ha3eC4EzxnIzfx1cfu4ngIj0Q0wC7a1mAP4V9Apt3Z5x1INBFJz8TuKP2hIA/jerwZl0K7
	RivbF670N7QbzUmQORVLSf+FCtjqvng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HYBe+NyF;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf05.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436954;
	b=jOtW32zc3Z1sGkHv07zQ+GZ8K+f/CPCxotA7v+lOgqErajZiTNFZ+/YmMQzP8OanjnIwHG
	ey2fjIcyaI/aGG24qKsqeq35VKBtfZXBKi0QR2lA97erM/714Vx22PaGNMZ5+kgdzGnZ0F
	b0hiZ3M3TilsGeAVji/614EiVg3+dXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794436954; x=1825972954;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nf/e7h6zi5zw9Vu4WfB0GEyN8EmLcf8HjHUMJ9G9oow=;
  b=HYBe+NyFnPN6siPz9k2PKGhfLBAbEwxZ6l1JQMuZAbzAPKc+IrCgjTh1
   GSaoTdCS95w6WR1fHtiOznDaNBA3zVnpP//qQKAAMlPdiSZXBMniQyNRE
   xUtEs3+zDF0HVqElWBxGpzCOiZsqDynoIcMUJNJNT9ZkVmlGLy91YIAE/
   q1R5Umbm1mbaDZks+FtZxwZPHYfJ1Kz0UbrQ5ZW74WYrhbed3GqBVNuRy
   fkw1EcRD2hgnB4lluCNsqUYClNehW2cF83wY+hoE/VaA5VjAAL+ITrZqw
   R6uKKPucVII9EgYulc1053QhVqFpP6skhYZRaCZTwz8fjG/P3TlW6puvp
   Q==;
X-CSE-ConnectionGUID: G7TPEGiWQRSBLwmwzCQc/A==
X-CSE-MsgGUID: DDSJSqkBS+O+gJ5y7ySdsA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33756163"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:42:30 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31849]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 152a9830-b7c4-42e9-a68c-30a0443400c8; Wed, 11 Nov 2026 22:42:30 +0000 (UTC)
X-Farcaster-Flow-ID: 152a9830-b7c4-42e9-a68c-30a0443400c8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:29 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:27 +0000
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
Subject: [PATCH 00/40] nitro_enclaves: Add support for Nitro Sandboxes
Date: Wed, 11 Nov 2026 22:41:45 +0000
Message-ID: <cover.1794300002.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53E3F100005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: pmn3tg7s31bsnghy4zyqs5csmo8duiab
X-HE-Tag: 1794436954-907465
X-HE-Meta: U2FsdGVkX18bh6ikd1hi57Z9Oelx7ophv7/fJD3YVx0b/dNOuaz7Ot6nVFFRj7h7BiZqMDnCRh0iOP0yfbh7ysEHsjjESQmSOkVCGeuoCrgMZOleaHv5GUbwDK4ByafSwWa9lQU0gTdvm9WgD4eEwHYdyq2B2qsCVC3Oh1jRzfME/5xbrI/zLxWbOxx5iN8lpzjcJh8nDMtBZqq5qT3CIp3+w4Il+QmO7F009fCB5/nUb8ojttWjOCz1VeG7KtjgwPdcMnxvHDFIVKe2SBhr0qKEnVZxQ+5MJBVZGNxKRqsP2yE8AtHNnzYCGcZjS+kRy2p6ak6WmwhbAsWeOQUK3D8xp1mcTArJ+zQn8NZa59Fe7KGosOwtFKcFglnsZnsoTeigpZO8G6XbOxRbXDJTCNGeZc3y2ACjpPhbulWJAetuDWp4QXfhI9cVFSyLjcpTtacrXj0RuogVw7E5gJR0q0foZChQqZFSZ8xpfIv8MOSg9JpOzBvjz02Ts2XGXLxL8j1omBF/xAWhltVnPLlsUUCNTsxYHHoJsuUeQWFnOpUzUcoV72RBbCFVdfxhFfkWV2oY4ly7ZTFXAsmh+BlpK0H3eZiyPfbsDyf0449IvwzGnFgvTtuM0uZBPA5g8Ecs8z77TxX7HNg1U4qgw1efy0L/lHstyf5MIVcAOwI6GehAq+ZGGjsaEdGFMxUBYoJ4RqDvH4cJmTeYxa5s4Xlb7YlHZjSlTrZnxDNE/5+6jp1khUNqPcG2Z5hzErAPQZe/Kuukczg+zbCG3uGwJ03kFyjBanP/9ICT4Vg6AO9dfIklKyr2DmiBf/96KdCTqd/SlG/TrTrRZOi+CxJxnyc0cg2AvG65xCMr5i0w/aXIiSoRO46I97SKUJdHc+6TMTH/s7RJyUw5gNsOjzQhpJcrlyPH//+LbjP3nvbaUrHOqM1PuLnlX/vdHy7TRvzJw1FSyHvVuTuDkG7aipUYNo3
 OhF5/kkI
 Kuk2ANhOtetwufaAP6jkFCfkwMFm1VJrqZomfm2d9x7qJK65tWVxbaX+4eF4MrbD8L7+N7TMTNXUzFzHJa9QLXjU/ldmv16a6frAnFwPdXA/KhBXw07PnCcaiE89e629wpHnIq/AM44Vj+yfBCO6z2WerQF2QahSoL/hYE053VWUK9w1wYkfldEt8iRu37STByuGOPutEND+pOaHa24txKNhWQaICzYkslIRgVc/AadW3esAEsHe8+7H3ULhJwO7skNS2OkTJhql7qPvUV0H8Ahd3EVVOy94P6hAQs8rh4r7z5SNUlJ2NdN8rfp8sCxETdd3jtF29CjfyReElyuvm/hUb41wz2uNfSJPnFrCjq5TPsd0yjdtC8Iw+o116TNCro51eiq4p1j7pzzFFhdnnOa9FHxWC2ZmWfYfsYIlTGeWJ6q7Co7OWeOmnpendjCvGzEz1T7Vw0bUFj+7sdQhWcSYfmcgrc75FvcHpYUu7iKTb+J14M8zff030kNxbFnI6atZxDrbDL9XNJ8NOxddJv8E1ooVED+KTRtItmvFZEpP8BhWm09x658rNlVwT4NcASc6HU+IuQIrgdVvgz6UEA73r3TdUKTIwi9jPihwEXfD9hi9bbz62m+KLYwTRSJqScbzF/F/1WrakRI9l952+6BVh0bAyxxgPsn1PjI6lsGmj85Q7xhDTsyzCaJaCGY9N35JE0BIRGOlceSgpwpSTjtxT4fahM9pW1AGL7zDMmp8orn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes [1] are a new EC2 feature that build on top of the
technical foundations of Nitro Enclaves - an EC2 feature that allows
you to spawn a virtio-vsock-only VM sibling constructed out of resources
donated by the VM you execute in.

Nitro Sandboxes build on that concept and the same hypervisor interface,
but add the ability to implement virtio devices in the parent, run vCPUs
oversubscribed, add device hotplug support and allow to spawn a sandbox
without attestation, but shared memory. They also boot a full EC2-like VM
that runs with a UEFI stack and executes the EIF-wrapped kernel as UEFI
executable.

In combination, Nitro Sandboxes provide a way to create a confidential
compute VM for almost all workloads, but without the biggest gaps that
other confidential compute offerings have: The parent has no timing
control and the parent also has no control over the base device model,
such as timers, PCIe, UART, etc. All base devices are implemented in
Nitro.

This series adds parent-side support for Nitro Sandboxes to the
nitro_enclaves driver.

This supports adds a few non-obvious technical foundations:

guest_memfd like CMA allocator - With Nitro Enclaves, memory came from
hugetlbfs and user space maintained visibility into it. That led to a
few problems. With this new enablement, we add a guest_memfd like
allocator that seeds from CMA, allows the parent to seed the EIF before
hand-over and then loses any mechanism to access donated memory. Thanks
to CMA, it also provides much larger contiguous chunks than 2M huge pages.

Virtio notifications - To implement virtio in the parent, we need to
handle notifications in both directions. Parent to sandbox goes through
a BAR write; sandbox to parent through multiplexed IRQs. We provide
eventfd support in both directions, which also enables vhost support.

NUMA - With Nitro Sandboxes, NUMA became a first class citizen and all
APIs now support NUMA targeting.

Memory Donations - Every sandbox requires hypervisor memory. To allow
for a larger scale of sandboxes you can run, we add a way to donate
memory from the parent to the hypervisor. The user visible effect of
that is that there is a slot limit sysfs file which you can increase.
On write, we allocate physically contiguous CMA memory and donate it.

This series depends on "nitro_enclaves: Fix enclave release, command
retries and the CPU pool", which I posted earlier today.

I used Kiro, an AI coding assistant running Claude Opus and GPT models,
to draft the initial code and patch descritptions.

I validated all new functionality on x86_64 and arm64 as well as ensured
that Nitro Enclaves are still fully functional after this patch series.

[1] https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-ec2-nitro-sandboxes.html

Alex

Alexander Graf (40):
  nitro_enclaves: Allow the CPU pool to span NUMA nodes
  nitro_enclaves: Add NE_ADD_ANY_VCPU
  nitro_enclaves: Expose CPU pool state under sysfs
  nitro_enclaves: Document multi-NUMA CPU pools
  dma-contiguous: add dma_get_numa_cma_area() accessor
  nitro_enclaves: Allocate physically contiguous enclave memory
  nitro_enclaves: Add NE_MEMORY_SHARED
  nitro_enclaves: Add NE_ADD_MEMORY_REGION
  nitro_enclaves: Document the memory pool
  nitro_enclaves: Add NE_CREATE_VM2 with a launch flag word
  nitro_enclaves: Add NE_ENCLAVE_PCIE_MODE launch flag
  nitro_enclaves: Name the device's error codes in the UAPI header
  nitro_enclaves: Log a reached device limit at info level
  nitro_enclaves: Add NE_SET_INFO_PAGE
  nitro_enclaves: Document the info page in the memory pool
  nitro_enclaves: Turn the command reply into a per-command union
  nitro_enclaves: Add the slot pool donation commands
  nitro_enclaves: Donate memory for the slot pool
  nitro_enclaves: Add the slot pool growth commands
  nitro_enclaves: Add a helper to grow the slot pool
  nitro_enclaves: Document the slot pool
  nitro_enclaves: Expose slot pool state under sysfs
  nitro_enclaves: Add the device add command
  nitro_enclaves: Add NE_ADD_DEVICE
  nitro_enclaves: Read the interrupt multiplexer geometry at probe
  nitro_enclaves: Donate a bitmap page per multiplexed vector
  nitro_enclaves: Dispatch multiplexed interrupts to per-queue bindings
  nitro_enclaves: Add NE_SET_NOTIFY_EVENTFD
  nitro_enclaves: Report the device's info notification
  nitro_enclaves: Count multiplexed interrupts under debugfs
  nitro_enclaves: Map the doorbell window at probe
  nitro_enclaves: Add NE_SET_VRING_CALL
  nitro_enclaves: Assert the layout of the ioctl argument structs
  nitro_enclaves: Pass on the Nitro Sandbox launch flags
  nitro_enclaves: Add NE_ENCLAVE_DIRECT_MODE
  nitro_enclaves: Add NE_ENCLAVE_PCIE_HOTPLUG_MODE
  nitro_enclaves: Add NE_ENCLAVE_CPU_OVERCOMMIT_MODE
  nitro_enclaves: Add NE_GET_CAPS
  nitro_enclaves: Add NE_UPDATE_DEVICE_CONFIG
  nitro_enclaves: Document the driver side of Nitro Sandboxes

 .../sysfs-devices-virtual-misc-nitro_enclaves |  232 +
 Documentation/virt/ne_overview.rst            |  256 +-
 MAINTAINERS                                   |    1 +
 drivers/virt/nitro_enclaves/Kconfig           |   19 +
 drivers/virt/nitro_enclaves/ne_misc_dev.c     | 4832 +++++++++++++++--
 drivers/virt/nitro_enclaves/ne_misc_dev.h     |  206 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.c      | 1568 +++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h      |  599 +-
 include/linux/dma-map-ops.h                   |    7 +
 include/uapi/linux/nitro_enclaves.h           | 1182 +++-
 kernel/dma/contiguous.c                       |   36 +
 samples/nitro_enclaves/ne_ioctl_sample.c      |   10 +-
 12 files changed, 8282 insertions(+), 666 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
prerequisite-patch-id: 542b3d78fda912095b75a49becd1b93109befdbc
prerequisite-patch-id: 318368e966c1925652b7976948f435d42b87c72f
prerequisite-patch-id: eb35b5d713e7f50f6d1d02310c9afe10b1628fc6
prerequisite-patch-id: 223bf6e60620ca8fe72f3ff6f3bd3f5839cdd6d5
prerequisite-patch-id: e5305ce0515a02f7f88e72adf02c6a2bee2fd2e0
prerequisite-patch-id: 759b5920f842d70e675770608d9088639c10559e
prerequisite-patch-id: e1837df37663da3d3ce53afa4594828b2d602152
prerequisite-patch-id: f0d4302bd36f94de95951a0db1ae9eb9747076aa
prerequisite-patch-id: 41159b92e250fef705be52f714b6e2761a2cd1f7
prerequisite-patch-id: a0c3a56907acac2297c800209faa2849a8df0e48
prerequisite-patch-id: a80a95bd682b540be5760e8fdf7044379fe32d61
prerequisite-patch-id: 9c01e0fecd6810f3448582715c87cd3dd7a6cdf1
prerequisite-patch-id: b94dfc8bb1039740d88a30535445bb7b3dd1fe74
prerequisite-patch-id: bd76f15728dc0ee2ca3417cd95a6b23a7d63e91f
prerequisite-patch-id: 0c60f1574b590f68885a25760017e9ff87752f66
prerequisite-patch-id: 63dff43da52934a6e6f5e65c3e235a7114b6b4dc
prerequisite-patch-id: af52cf938525874cadd6d879aa76495e563876d2
prerequisite-patch-id: f53ee22764b5f13708cacd3e48a59a82d71a270c
prerequisite-patch-id: 258b8c18168db49aacbda5156e33978b539666ab
-- 
2.47.1


