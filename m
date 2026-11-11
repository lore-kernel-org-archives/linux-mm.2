Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FFF60A263F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Hn+KTOtx
Received: by kanga.kvack.org (Postfix)
	id 827186B05B7; Wed, 11 Nov 2026 17:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7B86B05B9; Wed, 11 Nov 2026 17:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6793E6B05BA; Wed, 11 Nov 2026 17:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39B206B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:43:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C70A6A7F88
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:07 +0000 (UTC)
X-FDA: 85424315214.05.ED43390
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88DC3C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Hn+KTOtx;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZMJ4Q9G7ZD0Yoa+if1GcEy8XdPuoEVuvEiFupJeQYU=;
	b=lJcu/81UqLxJxYjfa7tSOMfLqYPf1y/dEGQqQX9l+B5Lxy623KnBvv7zIBhTiLDIzvXF17
	cnCzApmIhcnjIBmYWBk0dG/OrZmH0VjFRoQ4AE9PMdqxYAoynvP6NLoPuTngOOfYeEKNRJ
	WfxLOhIgZ4M4bVhwj4ntSI0Ccs+PrrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436985;
	b=1gumBJHGWEANEtwAdG5G+YJ46aD3I0cXDbr7NwAS3xD0clIl9fjqyhIO5/8KysHUy+KTIV
	GIZSoJ2cicHyKtltqvdK9QTw5rYr+VRmn7I4+sRTguiVz+43jGl1EWd0CPR+PJ7MrYjX4g
	tUoaM43h9E56LrJm7hv8zLpyX4oW+bM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Hn+KTOtx;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794436985; x=1825972985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ZMJ4Q9G7ZD0Yoa+if1GcEy8XdPuoEVuvEiFupJeQYU=;
  b=Hn+KTOtxf6tW5B76ABMvwrWjyKMJqmujjQay32IKMFXaki6Qv6rDyqfc
   kpmKl8CSE8rGwYaHi97MCeZxRytTNnyvgllrNg7RChTiPX6pF86r36T+V
   X/UXujW47tBVfk0EWFGnwHeQcaWOFDf6GyBTi7Pl5yeB4qFLAWAo38mgt
   R/mDjIajTiO7SaJhgYMPs3sQ9lboaNvUW3HyMmf3zpH+yMbNCa7WRSDpo
   MZvi/FdrlKaG15b/B47fyLrMiSJQS9T+WQcccxekgpwBv/DLMc/qseang
   QdUh40tkF9eoylJGbZAkx4HGoUyzkQ8VRoIp4u+X3cgGYF32gnVVOA3bZ
   w==;
X-CSE-ConnectionGUID: rpSiq75CQAqScimJ/gHWxA==
X-CSE-MsgGUID: 8T3304PqSW2LHdQaya1Irg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33537522"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:02 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:18606]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 9c406460-bb57-4d22-9e2b-7eaa8f7d1579; Wed, 11 Nov 2026 22:43:01 +0000 (UTC)
X-Farcaster-Flow-ID: 9c406460-bb57-4d22-9e2b-7eaa8f7d1579
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:01 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:42:59 +0000
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
Subject: [PATCH 04/40] nitro_enclaves: Document multi-NUMA CPU pools
Date: Wed, 11 Nov 2026 22:41:49 +0000
Message-ID: <72f6664721ada7bcde0b185a7fc7c13e5efcc479.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: kjfdzygnytnehhifjq1qw8ofzwmgrnyf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88DC3C0005
X-HE-Tag: 1794436985-498164
X-HE-Meta: U2FsdGVkX1+DZoPTzl4+ZTcfsCctaimOvFMf3ajVCM9OXwVga05qasU4xK3+0DL+OAutEEalacnlhtPtk9RLouWDkZdfko1vtA37YGWt+MDCo0A1yM4IuqXkuTqJF4vUp5xoiUT92lO5SZuEHnVIdZiDrR3v72UeEN6AwKDPKKHFlOab2GTbIYZBBWoZBxMljxYdfwMG7hD68Wkw3lFeLQHOI+cHKOew/+iPtZAjid4yVx0x7KN4T9bGY5ieCEt98DnfgBdMKD78wKOSUah9WVbiVTX1OPurhwyrM/ZyZDz708/VAHP0flafy2xMaaPn1rLBO18IsPq+JTZXt9CJtieLc/opAP+wvQjSaGV1GZbKUBuolAUvXnOuXmPgN6z+1YdPPNdQ+kpRpdTPVzZxouhjc+wZRKKmwk3Ua7pWyXiNeI0ieghS+S3W6mDrSwYPbytv+lvp5k4S3WbCpISb7FOF/qBGU9GEAHd70XxfHIomeBkXkPBZapsjJvndKeho3i1h+kmpbA2bzaqQKshObmTMoaR7tJfcqudRy0UQlXsR2BRj+a4ElNNk2CSThXEYCTDuv4o/jImjN09AQkCAnE3Xk3AhtVuOPdgiJY+9zJyxsCAg7OvM6ZCMCp9qlHcYBL58pk35vfB8tpgh5N421hsfCTdp/9WAsQW0jpHNmrOaEaan6JQLoB65gDWRhS4dPKOfyJnZUbGBSMExcgUQ897IcCqzdjIF+3EPDcqic61yoq/N1pNvGRDftsf6rfRxlrMrEoP+kjL6yJHHFX97Q4Fo9l0KQm8u1CLlCC4bAGEpgVcd3haVI6wWFe7Jwk25XIsXtoO3xdkwmS6zTz3BwRhkCtVxa13QTCLjIW0h4jNF/4iyQ179E2svkwdv7QwfE81zvh00svKna78vwEVZoTfL135IESKc6US0D2C7d+nw7wWhBs1QOuVTqeHRWAeCJlqNp7fghZA9d1070zd
 PZ0JbvQC
 WVkx2RbUwD1OVWEzkK6MKbwHLO+DQsaWMum7/wxqxv9VNUZRecqWNy8U/JOeHIHCEO0KaVpFLWuOYGV8uQvVCOm2vS+3Ej7pyg/mHKV63P8y/eKrdg3o0uzPPly/JSjOEnEbopuHX+8aQoSc34n0Rz8WVjjbt6q2riNz+VmvgntDeRKP8LwGUHdNMlShqS8ZmPGYFlwa7KNSdUIDh8yiYZ/57nCnc3mIZuCUUVW8Q3XwoEmDVU53VUAfWuydkVrpYsfRwlGrqnV43UTiQsUacjhIDUNC6kDlfi1n2qspRms9Kr3MSydwm0UhNWN6iWTcl90E7h+2pAwvGUTzNWr2nrX37gTC56RigvLirQBpOgwBS4uqi1mQJgSa8v/kDMtM6vFZj4ZsyoEDaMjUqjELnn1URlOsAvxJ/Qy4BCodl3qWuCjDlyz7NpIzx/5IhRsu5FtVeP3UOHKdkDkrr6aLMx4cH+NyN7u87ZN+0MAa7Vbv6I67ZGqZQEP0tamkW+fUM/VCz79KcJ+t4ICBpz7WAaaOWvXzNtCSLdW/onXQdQT8cuBedS7Qsm/SpbruBEH6vAUTd9LDPTzIDSPzjVVbu9v2iapnSFKlHLdZVs2DmAGd5GwAmi4+boxMEgrO/zljSAZ/+cjjQeugzdCHNowsna/oGSQQTEsVeCSS/XlB9VafGKwtNVItYUfaN9Pq58CsITmrk7OIoofJEjEznKIp/XQPsVOqsMO0q1iYE6wRmdL2gNQP7CgRIpubxpj/huKpV3pq6aDAMMjLRXx9uZtQOWKS6mNfhWUNEjaV0bn9oVRW+61DeEH/CIO12Rman6enxrQqWWuXlUP8f177ap/x+B8/UONOUc5lgPq/4xe6sSyceEHzPYxBxVHTjo4ajs1mCUvN9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An admin placing enclaves or sandboxes across NUMA nodes needs to know
how the CPU pool, automatic CPU selection and the memory-locality check
interact.

Document those rules in ne_overview.rst, together with the per-node
sysfs directories, and point the cpu_pool ABI file at that section.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 .../sysfs-devices-virtual-misc-nitro_enclaves |  3 ++-
 Documentation/virt/ne_overview.rst            | 27 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves b/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
index 596054b75e0cf..c549364353186 100644
--- a/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
+++ b/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
@@ -39,7 +39,8 @@ Description:
 		avail does not list.
 
 		A read takes the pool lock, so it can wait for a write to
-		ne_cpus to finish.
+		ne_cpus to finish. For how an enclave is given cores from a
+		particular node, see Documentation/virt/ne_overview.rst.
 
 What:		/sys/devices/virtual/misc/nitro_enclaves/cpu_pool/nodeX/total
 What:		/sys/devices/virtual/misc/nitro_enclaves/cpu_pool/nodeX/used
diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index aecd3704acaf5..223ee7fdec51b 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -48,7 +48,7 @@ be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
 this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
 user space [2][3][7]. The memory size for an enclave needs to be at least
 64 MiB. The enclave memory and CPUs need to be from the same NUMA node,
-unless the CPU pool spans several of them.
+unless the CPU pool spans several of them; see `Multi-NUMA CPU pools`_.
 
 An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
 available for the primary VM. A CPU pool has to be set for NE purposes by an
@@ -99,3 +99,28 @@ enclave process can exit.
 [6] https://www.kernel.org/doc/html/latest/x86/boot.html
 [7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
 [8] https://www.kernel.org/doc/html/latest/arm64/booting.html
+
+Multi-NUMA CPU pools
+--------------------
+
+The CPU pool may span multiple NUMA nodes. NE_ADD_VCPU with vcpu_id == 0
+takes the first free core in the pool whatever node it sits on, so an
+enclave built that way can end up holding cores on several nodes.
+NE_ADD_ANY_VCPU names the node instead: the kernel takes a free core on
+that node, and fails rather than crossing to another node once that node
+has none left. User space builds an enclave across nodes by asking for
+each node in turn, and sets numa_node to NE_NUMA_ANY when it does not
+care. Both start from a free thread of a core the enclave already holds,
+and only take a new core once there is none.
+
+The node says where cores come from. An enclave built out of a pool that
+spans nodes has no node of its own, so the rule that its memory be on
+that node does not apply to it and its memory can come from any node.
+
+The pool occupancy is readable under
+/sys/devices/virtual/misc/nitro_enclaves/cpu_pool/, and per node under
+its ``node0``, ``node1``, ... subdirectories, one for each node that was
+online when the device was probed. A node the pool holds nothing on
+reads empty rather than being absent. The driver offlines pool threads,
+so ``nodeN/cpulist`` under /sys/devices/system/node stops listing them
+and answers nothing about the pool.
-- 
2.47.1


