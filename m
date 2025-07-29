Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83A2C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 06:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3076B007B; Tue, 29 Jul 2025 02:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383EA6B0089; Tue, 29 Jul 2025 02:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299C26B008A; Tue, 29 Jul 2025 02:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18EC66B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:46:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65487140476
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:44 +0000 (UTC)
X-FDA: 83716369128.04.2BD289D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA34C40007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aAs+1IWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of hare@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=hare@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753771602; a=rsa-sha256;
	cv=none;
	b=zcj5Yz33O6bfwlGfrjL+Qq1vT178DkuxGlbDlnLixWHa3RaSD8qx3TLLOUSH29OvlF5AQZ
	WLcpSAhuyi46cN6Bn+xm5qvfFvwY2JD7bOWaMsX4mplsDjmjdkqQqCqBPGeEebo2CqfMLs
	b50eKx/OHRR103/M4OD0/ERlksmkwv0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aAs+1IWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of hare@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=hare@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753771602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZrHetyAy5Ci2uCQQNhuJ586nM/7RpZN41JegGpKV7r4=;
	b=GKADb6YWZ5uFQB2QKGYwiKLIW9JRhDpTvlYBCjKKE4H/xvbL7JKE08/U0Mtkt+dlSheTsL
	fGMnblTPkXuOWEbvV31I2kEK3YaVnQA76OlHWLw6q5oAkpjsQzXdsBlODNIJaJp5psmaOu
	ob0Bbj91JW7AmqHycsrc+lXLog+PgRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 2723DA54887;
	Tue, 29 Jul 2025 06:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC17C4CEEF;
	Tue, 29 Jul 2025 06:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753771601;
	bh=fRNlY1tExs4+Nbt5lBNMkcbRHCavDFjC82oLwuscNvU=;
	h=From:To:Cc:Subject:Date:From;
	b=aAs+1IWG8EzTBiQynq80psTkR6goKO8G7+av8/kloUHCE3LzmaWJGeniTl07au+tK
	 MWDIheLlfm1UqL+MbKowatIV4kjglt7B0rXuDIpLv7Ob5St81sszi60COBeGfv3duZ
	 DUCr7H934w4WH7S0s4cwvrDCYfQt1Mqi4XjdKioDM6Mup4vclcaiqBCxaRW3KeZqMv
	 KTqpXbI1AXxg6m5dAJ5jmotvUTM3IC5iYG2HlQLn0mMPrT8P8SldIoH9MptpObPTbt
	 EXD9+GXNXq7Tb55xq6DUl+3m6jHetekdG77G0ztcjSkFEUK54g8oaB2yr7G1dXfFSr
	 QhOCmLgmVKNyQ==
From: Hannes Reinecke <hare@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCHv4 0/3] mm/memory_hotplug: fixup crash during uevent handling
Date: Tue, 29 Jul 2025 08:46:33 +0200
Message-ID: <20250729064637.51662-1-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA34C40007
X-Stat-Signature: akb98mcaum9ds6ghae4qke8hr58yin93
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753771602-629880
X-HE-Meta: U2FsdGVkX1/g6pz379o9fLYR+SMY8pX4oMi22MXHCQuVhEd/CdXIt/4X5oQl4FNwk21ninrU8f9C20UQZ8wQhkdQmH6VsbEyCYYmVrIL9s2AOKDAHdtCoiy7oVXMe7cbyark0H+jqp020RAQTnTM+Rvf/OKFjpZjVxQVWPDCu28jDZ0tu11TuSf0OPI85ApM2QgYo00l0aZR5rVjKLepNfmYCbHexePSTjWDMLbCX5o4QgvqFBFvDJJeffs+2CGvsn+opN9bhskxzhnwkLQUDll+m/Rb6c78tUZen2VPTmTq9G1euNDA7aSoR/YppCrIZQ8Rd8psM0v/hCSAhiG2aNjEhwpHjsItEmM2by2EukbMMT/kgN8ruL2c16JYd4pnDLuKj8uF80hq7yj17VQpZQ5/gatMIgsmPJ31odKAPCDwNOnr+HQX8ANY1+NCGH02TpBSLbt4kPYkK/TZ0edc2u6GcdtPcsji8dqCJoOPehyWpvK70O0yLEdrRbot9OzSRZCnLi+IiQV2Vzvk/2vz0SYHFGu2J8j0oiuwlZVAajWLAPcWmoCu+r3PyLOkTYULCWThwrO/zP4T3ADwatS+mXxYDUEXDx2OFEVPGww3NYkFfHyDm5mYugns4wurvhPWrvKbwYImJbAg4bu0Fk5s/KLnqVxwvDyLHO3VDZEfnhOKLLwW6PmyFvRr1ldvM58vchzFj4QFqD751m+yfS3Gc9CLaxGdYOR82EEIVc8MFU8wSacfAHMmhV8Z/NTprw8Mp7AqW+XWkdmUMwFQp4vCOs0lOpMELrSO7sREw85wP2Kbz00+gYBO5EyS4InfwAnNV8QQiO0Rnx9p3DoXqsUFEQe62bAYR/omK41Jma9Itor7WOE0fA5BYrBUxoY82tntNV89jsoKZzonagPLFpQ9GPNGPZ6mUvlYl1LbkAnRRttjR7nfsnQPxe9C9EgPmQ6przviDVwGy2+rysxQ585
 nmOQYE3q
 V1Y0jNhNb9y5arquqrCMVOvGq0sslQfRgO3nq3h7dBhxZsR95+kWpmgdjETHiZWc6ZUHtaV/F6+jSFTLhei1zLgYmifkXoamRem8P46j5FYeN/QucNs718PJ8e6M8RiJfhfJHAp7kldySGW7nY5ogNRSeqqnhViq3Xu/D3sTMSMSzBrjoJ6Y1OQs1H2gVR68e5NC3FjXI8/jAIKmCSu5qxSmTePVJeR4yJ3uojAUUEFbS6YN22FVvrmS5KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

we have some udev rules trying to read the sysfs attribute 'valid_zones' during
an memory 'add' event, causing a crash in zone_for_pfn_range(). Debugging found
that mem->nid was set to NUMA_NO_NODE, which crashed in NODE_DATA(nid).
Further analysis revealed that we're running into a race with udev event
processing: add_memory_resource() has this function calls:

1) __try_online_node()
2) arch_add_memory()
3) create_memory_block_devices()
  -> calls device_register() -> memory 'add' event
4) node_set_online()/__register_one_node()
  -> calls device_register() -> node 'add' event
5) register_memory_blocks_under_node()
  -> sets mem->nid

Which, to the uninitated, is ... weird ...

Why do we try to online the node in 1), but only register
the node in 4) _after_ we have created the memory blocks in 3) ?
And why do we set the 'nid' value in 5), when the uevent
(which might need to see the correct 'nid' value) is sent out
in 3) ?
There must be a reason, I'm sure ...

So here's a small patchset to fixup uevent ordering.
The first patch adds a 'nid' parameter to add_memory_blocks()
(to avoid mem->nid being initialized with NUMA_NO_NODE), and
the second patch reshuffles the code in add_memory_resource()
to fully initialize the node prior to calling
create_memory_block_devices() so that the node is valid at
that time and uevent processing will see correct values in sysfs.

As usual, comments and reviews are welcome.

Changes to the original submission:
- Add patch to rename memory_block_add_nid()
- Add reviews

Changes to v2:
- Move changes to nid setting into the last patch
- Add reviews from David Hildenbrand

Changes to v3:
- Add reviews
- Rebase to mm-unstable

Hannes Reinecke (3):
  drivers/base/memory: add node id parameter to add_memory_block()
  mm/memory_hotplug: activate node before adding new memory blocks
  drivers/base: move memory_block_add_nid() into the caller

 drivers/base/memory.c  | 53 ++++++++++++++++++------------------------
 drivers/base/node.c    | 10 ++++----
 include/linux/memory.h |  5 ++--
 mm/memory_hotplug.c    | 32 +++++++++++++------------
 4 files changed, 46 insertions(+), 54 deletions(-)

-- 
2.43.0


