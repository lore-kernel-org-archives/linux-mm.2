Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B879606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=kEFJij1x
Received: by kanga.kvack.org (Postfix)
	id 735486B00EF; Wed, 11 Nov 2026 17:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5E56B05B5; Wed, 11 Nov 2026 17:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF9F6B05B6; Wed, 11 Nov 2026 17:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE006B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:59:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49C22120310
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:59:52 +0000 (UTC)
X-FDA: 85424357424.16.49F2C53
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C3AB40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:59:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kEFJij1x;
	spf=pass (imf04.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxlZ3d0PBPnk05nrYhRlkiXhE+5MZd2ltaw+yg5jqDs=;
	b=mzpBOqjkxE3RnntWgmTEPlTOJG8iP5fS3EN9y+muQtOb2O/vRLrLDRvmzIkfdwUDlWKHe+
	/bFNdIxZM7hpq5MfeAG/L7sc8MF1TR00XG/MYsbbFLq64fhYg8usJqs+ZxjiSxR6ZVKKL4
	rYoJqDx3F4ES06F/jBK5Naf7QcnTPlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437990;
	b=qSFCDjkAh5VLOzIrLeJHXxZU5KYq7LMZeiDePIB/d80P2JHxUOpZ12mErNRgqnbm40MbVo
	s/QPqSccAwFfVwTJDhL7UN7IqaRuWLKlHjmT81ms4qEG2e06INjWLAexnegXMYNpcJs60/
	XVFBD7sqjYulUUJDOt7uNcwUO+g4I88=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kEFJij1x;
	spf=pass (imf04.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437990; x=1825973990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NxlZ3d0PBPnk05nrYhRlkiXhE+5MZd2ltaw+yg5jqDs=;
  b=kEFJij1xpYHce3ZNxHGHIRA922CrcEMohkIzcXg4bJcbMau65HDeHtrk
   KirARkF5JTj3ZlzaqGxfK/HH5okayOdWJGKfVqime7Yzl4q6KE5Ryft3H
   Fs0YSUGeFd6jQHZA+svD5BgT6bknvro7PQEI28E3yeePqhjHQ/EzJdopm
   +MUKt30xFgK61hfC0DwsB9ARV3qfllpjl2zTNkE57LCsZybdBeVatxmIR
   9C+Z4QibwEpyPGfByJdV6nzscRX/TaSpg6PFB125AdksmFItCdJA4eRds
   /+h+KlsdP3MhPoKlewqNVqwaQ7g7lttsI7TUzOIh119M4GA8fwzNcTDMK
   w==;
X-CSE-ConnectionGUID: tfAma2DzRFOFb8bdIGIDVw==
X-CSE-MsgGUID: iyTsTEHxS0uD4j25ZbIutg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33573114"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:59:49 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:10977]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id f883803e-6c22-4425-9ce0-85931add301b; Wed, 11 Nov 2026 22:59:48 +0000 (UTC)
X-Farcaster-Flow-ID: f883803e-6c22-4425-9ce0-85931add301b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:59:48 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:59:45 +0000
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
Subject: [PATCH 15/40] nitro_enclaves: Document the info page in the memory pool
Date: Wed, 11 Nov 2026 22:59:19 +0000
Message-ID: <e7f196dd3055426734dc363f9a75a45e442d3eec.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: aebud98uocyb4tyxpkytqjh3nckahabe
X-Rspamd-Queue-Id: 2C3AB40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794437989-234765
X-HE-Meta: U2FsdGVkX18dEU7flezzxUlSC2j41X/Lwv0hnr9u5Tbo7qHPwnWChrj55QFXaRU5h3/5+5VOamN3IKvhj2iayL4hGg6rKuvJYG52DAjDzNBs1dWxzqqDf2njhFAxIVUbWuxFKLHOHfCEfLYWtYjMathixiecJdfsEDLoXcWAxRDQeWZHfYENGxvUsf/+iz3Wv+sCNDP4RKEDnBZFWAJveJGJjFvesxzrXe21gnka5eUUuaHtnRnxyUTJCckXkE9ejkPH7TMYw2wBoQD06AQ3j9nnr7qMu5WBfaj3OPw0wyTYiAa1fHEy3qFmfOnjRD6n9M0IKpEDbj9JiXoI2NxWCFA0Zy+4YUpjkJn1hpCK1+vnUzK3j8fQKQYDEEdfJYYrDmYgIRGj7YS0HK23R1ZEBpeDw19oZ4NrgyVTCC0FfHoSIL67Khn4M+zGQDzw3209xMZFjvxP8kXFX84jsERPopSHVITH8eMsId6n6QrNssYmB9p4wsIbgKtmeufVAccwP+mKtH3937qrDrN2mxPwvKiGjoSD8SVTQch+cTEBnMYiVTgn8Jt2U//pZmr4Yp1j4QtN6Gtq283ZXrQEoImzRBITDk0o0z+6uk9tYxZc4z+1Ht7yQIeFfyLI0NzaWap4EZuTKe6RXDxP6D6jHQId6Tnux5IkpXYiDC/Zjjzq2XY2l80ylzLOYvWnyDqRe68dlONmatnjD8ejEijYWjzDPerv/kyNNyBc8mxM/7cMEMtP/Djm6q5DDR+uIhpGvka2xsfmv+iZqbe5ah3glCVoI3vi3oKpdFsShvoceDsl3Pc/3+J2J6/g1MRgPlGSc6G0v4oUD3oMO6GLAfBxIYW0aq6iTEcXDZZFNA+xsRVBebqdzEt1CeHMzwJI5euhfWuFurxRk+7eiEmvgu5MxrptqkOrIvzWQqpUnS/zDHxdZTLbdzVKsxLWVeoR9HGVDsiSZ+PCNb46ccoDEUJpZQc
 Fa5FUV7/
 mYxGbz/3Ow0CeMxqTahOsRTikaOXUw9V4ACEsTwC7FxjlM0R5o/xcBlzY6EZXJdVw2jlobmH1QrQg3fL2v6uE0NIPc0MJl0pQc9/gRbtehhuN//lXQfQALttNEJwiZ0S8RPwBtrV3lgpCNXANNmi9ZLUzypacRG8oL+jAt23oZJ/3MiV3uAdAA97xD/lxHxGHM1GiNIfVWUDyINrtkMiB/XaEp45X3Zdh9pIgpuJtlfxeO0bMeu3VxakuIXoCOAlmr7+vGkkxB8ov1imh1WQnL6Oa/XfP027njsK4eWrlEte/yJMCP3dpMxtZvWc7U7TtfTJbDOe4Kxmt5JlNm4uAYXL8lcMloroTirjZ55pTZOwbK0JmWkoNic1OuAU1GrrQxtuiiyvpyNv8OQr09o8NrgFCmpgOLQXxvyO+Gpx94oh+HUgfBqZQmcpnycSV+pxXTaPE4qr6P49nMg/IrSQW5veD/NhtHs1chMzXr1LdXAhcLa0BFjkymHQWdTUQwMForaPqEAdpxyhlL3zT6AZZH8yw0aoqb0EE5txBtq0HoHfal9FNH9guctj9nSg6lOhvpqcHF14FdL1d0Vjb/zYWlbpSuFX5pxrsFiF7UlurCzsKCQs2cbGAXGExcG0rUxOHGZFImakLUsIaVVxGUDmx0PaPbwTUrZUoZpZrRYrl+tK6c9vmI04RahZxCalxUGlQ7LFG7iys7AyX7P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An info page takes one contiguous allocation from the same CMA
reservation as enclave memory, so an admin reserving the pool needs to
leave room for it. Document its size, that it is registered before it is
mapped and is read-only to user space from then on, and that it keeps
its allocation alive like a memory region does. Also say that a larger
NE_ALLOC_MEMORY request comes back in several runs where it has to.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 4c4b7febaff0a..3cfc50f788433 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -150,10 +150,11 @@ node enables to name the node a reservation lands on. cma= needs neither, so
 on a host with one online node the driver's own select is the whole
 requirement.
 
-NE_ALLOC_MEMORY on the enclave file descriptor allocates 2 MiB aligned,
-physically contiguous memory from one host NUMA node's CMA area. A request
-that area cannot serve fails with -ENOMEM, so the reservation bounds what the
-enclaves on a node can take between them.
+NE_ALLOC_MEMORY on the enclave file descriptor allocates 2 MiB aligned memory
+from one host NUMA node's CMA area, in one physically contiguous run where it
+can and several where it cannot. A request that area cannot serve fails with
+-ENOMEM, so the reservation bounds what the enclaves on a node can take
+between them.
 It returns a file descriptor for the allocation. For an enclave whose cores
 all sit on one node the ioctl refuses any other node, so name the same node
 here and in NE_ADD_ANY_VCPU. An enclave built out of a pool that spans nodes
@@ -195,9 +196,22 @@ a caller reaches and not for all of it. It keeps the memory reachable from the
 parent for as long as it lives, so an allocation that is only being handed to
 an enclave stays private.
 
+An enclave can also have an info page: an allocation the NE PCI device writes,
+provided to the device by NE_SET_INFO_PAGE. It does not become the enclave's
+memory. Only the device writes it, so from NE_SET_INFO_PAGE on it is read-only
+to user space: write() on the descriptor fails and a mapping has no write
+access. The call fails while a mapping made before it exists, so a caller
+maps the page after it. It is asked for as NE_MEMORY_SHARED, since a mapping is
+the only way for the parent to read back what the device wrote. The device is
+given one address and one length for it, so it has to be one contiguous run,
+and 2 MiB is the only size that cannot come back split. Ask for 2 MiB per
+enclave that will have one, on the node its cores sit on, or on every node it
+may draw from where the pool spans nodes.
+
 NE_SET_USER_MEMORY_REGION is unchanged and still takes the address of a
 hugetlbfs region.
 
-The allocation lives until the last of its descriptor, its mappings and the
-regions given from it is gone, so neither closing the descriptor nor
-unmapping takes memory away from a running enclave.
+An allocation lives until the last of the things holding it is gone: its
+descriptor, its mappings, the regions given from it and the enclave it is the
+info page of. So neither closing the descriptor nor unmapping takes memory away
+from a running enclave.
-- 
2.47.1


