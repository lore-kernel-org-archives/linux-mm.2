Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F18A606E2B9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=gaCJfFyy
Received: by kanga.kvack.org (Postfix)
	id 98E466B05C1; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911796B05C4; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EBE6B05C2; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE6C6B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAFF3A7FD4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:03 +0000 (UTC)
X-FDA: 85424317566.22.B890FDC
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A46C180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=gaCJfFyy;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf24.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJjMYgz1PxuwUEJMcsvLW+MBhNnHPcTwlN3u7yQ5KPM=;
	b=VpIak9E2DEhzN4fCr6RR8NqnU3iRv8kV1YdLwn2IlQPalZ4ewd1bOVEO73Wp6QPIhopso9
	WrQc9Y/Rv2rRYVnsn7pTDp2hy2bOMMB8YaJdfsD1bAyHZXenRf6JyxxfXpKYsxtjVDNDcs
	GDTNbcsdAaPkj1jDzrZ5pklgXGbK8a8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=gaCJfFyy;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf24.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437041;
	b=VpHyrvzSoxDpmetMM/0ulWNPv/aWOk3GLtnngRLnYbOCFgo4/D2K7fCnBc2h2NRN4CDbgq
	J7gee6tUq9Qeg7l534Upz8G0/uTtkWP2qbJLZjGYQkNsVj8SFCLwfGBJU+/R9sagDYMMvU
	lFpHesaJCgbgfyzhvsA3clIzRzovbyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437041; x=1825973041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wJjMYgz1PxuwUEJMcsvLW+MBhNnHPcTwlN3u7yQ5KPM=;
  b=gaCJfFyy/WPQUcy2iLKGu+88SAG23LfJi4mFTPdWRqbtkoeU92gsi1Fy
   z4ssUMa+i5LNEvBu6hrgygs5xBRjCEB8bYzHPicoH5lbFpCBq5+iQ1lY1
   NKlXE2aF1WPYrgXt7MvPYEgZh8ackAZizQ9Z0MtFTHml2bspmpztWmKhf
   K2yEb9L7I01ckvEqAGaQvaodjec5nxpokLZlS/EpXyC5IU7h92SyAy7cS
   VTiHkd3AU523ieTvmWASwP908QptanfVkDzuEf9B8gcgUFoamvpRUGAPl
   Kz4n1yrzNMFJoqX34bGd3p9G6JmA8gplP5rKSmMDeCviIrdRw2/8w8sAw
   g==;
X-CSE-ConnectionGUID: Cs8OzKSgQCaEFf6lQyWf2Q==
X-CSE-MsgGUID: e9wvUfnWQSiUc9y4a+yklQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33549811"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:58 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:23954]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id d283ee22-8d0d-49a9-81b8-62fd5a464c05; Wed, 11 Nov 2026 22:43:57 +0000 (UTC)
X-Farcaster-Flow-ID: d283ee22-8d0d-49a9-81b8-62fd5a464c05
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:57 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:55 +0000
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
Subject: [PATCH 09/40] nitro_enclaves: Document the memory pool
Date: Wed, 11 Nov 2026 22:41:54 +0000
Message-ID: <1119ca93f65bd771345d9153c8b8c133e951506a.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A46C180004
X-Stat-Signature: bz4x4wfpqbb3roo6ydni4otn3j6phwkz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794437041-483442
X-HE-Meta: U2FsdGVkX1+pJx9Y2iteY8BUzuP58Z7q4gMliu7Jy0KGZFNURbdYD+G0/tCyQumZpun+omhLFrAOAx8VGxJjMKSW0nyKy6jKCwC3eo1ud4w7xa8cjXq3KB/CVEmKKIp2a1fnl9btQNOXsZ6zKI/fLsxiBBLTPxvf6Vsu8B6fgGSuNL29eNBO8sz5yD+Hm53moBLl7kVmJm6Gq6lwO6TxfTcei1rGt5f6IWMSOc4ew5iThaDIeVAfLytBj6li4zTaSDdwEkcM82s0URsBdzUnFfRW59mzVMg8lsN9rokibaB2SNcDzxE+grGEyUgvskjyfBkO3D8+YubrmRi6X66RnwtqebA1lFMoMp+Sea3LrQ1fKIDATzwetanE/of0sIrX/Fbb1zgpYhi/EE9zx4M0TtKpsNjXR7aVojhHzizIQ3U9x7z560vINRxU/B/Q0NvqC1BvfF2KCx5hNBApFMpR47AVR7YtvlUkaoVDZPWI6336g81IgOSwwpweLPkhPpv/hTeWvrsTNGx2mZ3zIY2LjgfkjI08keMgqNPiwNRCg9ozra6PGEvVECytZeui7zIJTTPrpFSrmPsq4C2kykJPOGlJlNdVGEC1lpuDvuSeZHdWNrwDGfR8n8jGAH6r+/vt4G5BhMblpvm/lW8ISCTAshPGLrfAwXhXfaA2s3QHzOzBUcZT6fIkQJCG35a+W1CCN5OyUr0dx38rsACpO+7Jf8dtOgtRy+XhpzlH/bEpcQi/EfyAO9QM75s7+CCO5wl7AuF5UStBl463TsLEhK2M/mMqVeAqi05uwfn+P5OR64poBI7V+yTSyHydBkbslkNPZLH5LS6sL9G2Zz58NsNG0gC47IfX/z/Gcz5uRS3Ew6L8I287dOxB15bx5u6npTuF3LGt4mVX4ZUwX/O7fVLDg6PCOhR8P/vxzkpctCivUndZGBNsmE4O68+leAkngD+lGD+gAKnSBEFeOj9Ujwp
 nDa2lFs5
 um1Zez/VyQI1pTRL2PkW2W80HVWpR7n1pGasFyRGSomhYxlD7KtZeW1BOYDkG0+Gf/3LYJh8cXvUFdYYoc1P8LtfxmBgxok3s1DBSMH/iyms5Kdjzv+6yF/uxwVlVkxxNOEe1pPy1nSfFsW4Rag4tOv8HTvn7wEtDIF4rMdalWiUp1uJeRcGyne6qF7DIRnUbdeCDMcbLS0I9qu/ZWWv9daVWhyXHpuu8AjvUWpJxDX3h8CPczxRdP30orJkIUX275TfWwfPW7cKzGj7bbocbYPG0UqxtnnYwzpH/DXqoy/NLksANTmnbgV6fFvYcHkVXpr4jn5BuW8F/cNPK4T6ykPFrJOYJEOesVuIx3Y7UR93yhm5lvzdGjTcpj6VFOOk4/XhLE4oJYR1HvoXwD6Uge9ZM+RIO6xgCVTFwUf2eMGRjQfQeWfrJBWbISavBGzDLK9wU+ulx7Oh0xKjl6DaL+yZB18MUshAsMHF4sCqslJoAQonv5MmCHRPJKs3tKPMkoIcvF3YwVVeXpfDN02hUWmGCq6UI/Sw5Ttn2NSwo9C58VCCfIph/eZFfRijlUMYZfbbMsbS5GkcAICQQezEAoX2DNRoyaJwb4kpOmg0VPeL9DO+3/1+XXEuFRSvg6JwL3xzEjxUvr5Ji/jn3STCHAbKkeBwFsC1X5B93WBjJ1xrUcTxxtWlxxoO17tFH4kViTPLSps2sbFDcADmadEGqxY/GDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An admin reserving memory for enclaves needs to pick the CMA area and
the kernel parameters that fill it. Document the pool: allocating with
NE_ALLOC_MEMORY, writing the image through the returned descriptor and
adding it with NE_ADD_MEMORY_REGION, the config options a reservation
needs to be reachable, and the difference between private and shared
allocations and how long an allocation lives.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst | 83 ++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 223ee7fdec51b..4c4b7febaff0a 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -113,9 +113,10 @@ each node in turn, and sets numa_node to NE_NUMA_ANY when it does not
 care. Both start from a free thread of a core the enclave already holds,
 and only take a new core once there is none.
 
-The node says where cores come from. An enclave built out of a pool that
-spans nodes has no node of its own, so the rule that its memory be on
-that node does not apply to it and its memory can come from any node.
+The node says where cores come from. NE_ALLOC_MEMORY takes its own node;
+see `Memory pool`_. An enclave built out of a pool that spans
+nodes has no node of its own, so the rule that its memory be on that node
+does not apply to it and its memory can come from any node.
 
 The pool occupancy is readable under
 /sys/devices/virtual/misc/nitro_enclaves/cpu_pool/, and per node under
@@ -124,3 +125,79 @@ online when the device was probed. A node the pool holds nothing on
 reads empty rather than being absent. The driver offlines pool threads,
 so ``nodeN/cpulist`` under /sys/devices/system/node stops listing them
 and answers nothing about the pool.
+
+Memory pool
+-----------
+
+Enclave memory must be physically contiguous, in chunks of at least 2 MiB,
+and, for an enclave whose cores all sit on one node, on that node. It has
+traditionally come from hugetlbfs [2], which provides the hugepage sizes the
+architecture has -- 2 MiB and 1 GiB on x86, and 32 MiB, 512 MiB or 16 GiB on
+arm64 depending on the page size -- and needs the hugepage count managed out
+of band.
+
+The driver can hand that memory out itself, backed per NUMA node by the
+kernel's Contiguous Memory Allocator (CMA). Reserve an area on every node
+you intend to run enclaves on, with the numa_cma= or cma_pernuma= kernel
+parameters documented alongside the rest of them [4]. On a host with one
+online node, cma= reserves the one area there is to reserve and the driver
+uses it.
+
+Reaching a reserved area takes CONFIG_DMA_CMA, which NITRO_ENCLAVES selects,
+so the driver always has it. numa_cma= and cma_pernuma= need
+CONFIG_DMA_NUMA_CMA on top of that, which a host with more than one online
+node enables to name the node a reservation lands on. cma= needs neither, so
+on a host with one online node the driver's own select is the whole
+requirement.
+
+NE_ALLOC_MEMORY on the enclave file descriptor allocates 2 MiB aligned,
+physically contiguous memory from one host NUMA node's CMA area. A request
+that area cannot serve fails with -ENOMEM, so the reservation bounds what the
+enclaves on a node can take between them.
+It returns a file descriptor for the allocation. For an enclave whose cores
+all sit on one node the ioctl refuses any other node, so name the same node
+here and in NE_ADD_ANY_VCPU. An enclave built out of a pool that spans nodes
+has no node of its own and takes memory from any of them.
+
+An allocation is NE_MEMORY_PRIVATE unless the flags say NE_MEMORY_SHARED.
+A private one cannot be mapped, and mmap() on it returns ENODEV. Writing to
+the descriptor places bytes in either kind, which is how an enclave image
+gets into one. There is no read operation on the descriptor.
+
+A shared allocation can also be mapped, at any 2 MiB aligned offset for a
+multiple of 2 MiB, with MAP_SHARED. A caller maps one to keep an address for
+memory it goes on using after handing it over, including after the allocation
+has been donated, which is where writing to the descriptor stops working. Such
+a mapping is readable too, and is the only way to read allocated memory back.
+
+The mapping is VM_PFNMAP, so it holds no struct page references and any DMA pin
+over it returns EFAULT, long-term or not; io_uring buffer registration and RDMA
+memory registration are two that a caller might expect to work and that do not.
+Reaching enclave memory from a device in the primary VM is not something this
+interface offers.
+
+The allocation is accounted against RLIMIT_MEMLOCK. NE_ADD_MEMORY_REGION
+takes the descriptor and gives the enclave the whole allocation, as one
+memory region per contiguous run it is made of, or fewer where runs turn out
+to be physically adjacent. It also ends writing: the memory is the enclave's
+from that point, so an image goes in first. It takes private allocations
+only, since memory the parent can still reach is not memory the enclave has
+to itself.
+
+An enclave's memory is laid out in the order its allocations are given to it,
+and the offset NE_GET_IMAGE_LOAD_INFO returns is an offset into that layout.
+A caller building an enclave out of several allocations therefore picks the
+order first, writes at the offsets that order implies, and gives them away in
+it.
+
+A mapping is populated as it is touched, so it costs page tables for the part
+a caller reaches and not for all of it. It keeps the memory reachable from the
+parent for as long as it lives, so an allocation that is only being handed to
+an enclave stays private.
+
+NE_SET_USER_MEMORY_REGION is unchanged and still takes the address of a
+hugetlbfs region.
+
+The allocation lives until the last of its descriptor, its mappings and the
+regions given from it is gone, so neither closing the descriptor nor
+unmapping takes memory away from a running enclave.
-- 
2.47.1


