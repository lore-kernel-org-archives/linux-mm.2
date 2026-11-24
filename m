Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0CE606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ci2tuqIW
Received: by kanga.kvack.org (Postfix)
	id DB8D06B06CB; Tue, 24 Nov 2026 08:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91936B06CD; Tue, 24 Nov 2026 08:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD4A6B06CE; Tue, 24 Nov 2026 08:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66006B06CB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:15:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 190F11A03BE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:25 +0000 (UTC)
X-FDA: 85470059010.12.571E07C
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3195940011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ci2tuqIW;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526122;
	b=KqJEbGrJWDfFe/Yt8g9cCWWARSf6GIFZ4eFEZjn6JBUVsj5Di2WgLwrlNnOIHomJdOy4Do
	q/q9P2F6I/zWrMsL/ZSmIK3xmLu6QBqtxRviAOtEl5OfELu6Mh4YDKvmYBdpOk0TWVyQvd
	PMSHyHIhdTcWDVGnS1QtHm0I3sDUNf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DTrZBE5iwQP7I4LvpTnicbF/Quy7tKQDU+r9P+z282U=;
	b=0wHhZpDoL3yuZMpb0eH7EXrgVSds/f5+OX1z3QCdrDf3E9Bw2JS2srATMbL1lEnCck7+l8
	9hzhVh2w74MEwB8PGr/JTXshj+LP9ykeaAWuG33cNDSt474mzXX+om8f5L997g+/gg1zed
	IB2xV5NTSOscbH2B4PYGtJkQD44ZX4Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ci2tuqIW;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526122; x=1827062122;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DTrZBE5iwQP7I4LvpTnicbF/Quy7tKQDU+r9P+z282U=;
  b=ci2tuqIWSFmSd/Nxt/q0yXZB21eDXF1sqc5jBE7Ah9d/yPGgh81mPtes
   7TVbIUMMU9AEM4WZpER4yNlsl7xXWw8Ab18Ht/Jgd+JmjyOoyxtxanDCk
   Y1GTL5/wFzE4NY20+B/iWXhQPnqNWLOmJ99clcXs//3ATVyXKUTHL6+zc
   ePtdLNsghHaatZMIMPmnRENuKqoc60m/oJGGz5RbtlIzvhKEr3o21YiUV
   71mOPeuukzTdX8oqts9vSbiuE8KJFZKu8mJzfX6Z2MZvza12ZAMO1+oup
   JtFXiO5wy3PDpOylTZbWlcuFVS3Tnc57/gM2Khcj1FP3+xEg+Ur4wgehR
   g==;
X-CSE-ConnectionGUID: k5+cpGyEStifwrwTSbZhVw==
X-CSE-MsgGUID: yDnHAcOURESy4kc4+c6tgA==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="35027412"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:15:18 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:31496]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.204:2525] with esmtp (Farcaster)
 id eae5476b-1d01-47a1-9a21-c023e39954fc; Tue, 24 Nov 2026 13:15:18 +0000 (UTC)
X-Farcaster-Flow-ID: eae5476b-1d01-47a1-9a21-c023e39954fc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:15:17 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:15:14 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 0/5] mm, uio: huge PFN mappings for /dev/mem and UIO
Date: Tue, 24 Nov 2026 13:15:05 +0000
Message-ID: <20261124131510.38745-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: qucdznhrgqohqyrn7m5c5ozte4ir8a5r
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 3195940011
X-Rspamd-Server: rspam03
X-HE-Tag: 1795526121-21042
X-HE-Meta: U2FsdGVkX1+Dv3g3VumjfBSBYzmMbw2+TX61qjNKLkfAlFBmlnxSJuMwhQKz50QngrRbaU9EtCniScg2OE97FFbGgOE3Kenof/Eb8rkWewTO+3Rg4O5D0VYUwHFTHklspm5ZrPEPJ+kot+6acU/cZnN3JkEKqFhFCi66lAJLUkuzuIvHHtSy2PJ055ZVU2VD5upCuUEg+t4KRw3NbeEKMRcd72ASRw6Acerys4cAKmB+hbbjyq7S9kj3C14K3qz4yXm2ZmH9DaNQvCp/Kv4pjClr24NrvaiEKodmcblKjhzgcOyZpTkBDvhB07kgrPr6boRPA5iQxzl9gAt4HQYaLypvYEkoMVyQYCwhZoUT8+nFKiOoic01R1gT6N+VPHCfXfnp4SjoYPLlFg5NyK3BFbm3pe710F4VKFyx3a6tJfQVt4bJfHK687QrR/21zpdWLg6g8/OJ0mmo5tjozt41OuK5bprfC1XcPPz/SSLg1u1wd78JY6IKeNcXuMAnpMZaxrn0vMx2jBcqyu3OkxhDlLSGX182PtqWIZxbQLgZR5PAWxv6NJI5YCucIh8NMfUS8LxvwI2lfzhoQD3fard+565He3X1NIB6bYyrBMfcweWOKm0ZaB8QGRgjFM3wTnMRuz/X/ZRyDXqVcsQ5/IsByyJb06BEtEaThAPmNZKwWHGQvZvEpmHGYzBIsQsk1MQl3dZocXjNwSD7Bog7hQDdElWtkdKPMphBFbdmrrrXTeS9Z++ygbi8zdclJ44KuZsNOFDmW7AfjpWxHPvBpgmZTw4aeKcVTceSrarQiHGb+pc0C+cFa/xriTMInZnQ0tcMzxOyTQjcC4k7xFf1GmX/p5+Rdu1Wf/BA1iXXViuGH2b9NfLmhs67hv8yUH5lELFlMvOoAosiWsumaWuuR+vKHYtqxDIvFq5jn2wPZLyL/cDEBHAZ6rVoEYWNsMZi4P6wtgQQP6NSQ7BtgtGRtSx
 6kjGKvHO
 XR/yU3t9DX35r70u/I4doQQqA5Qnh53EYM/+r4W7bWCA7Y8N5+8eSKYkQet7VWlgrsyvipwyeEAiFD7zwp1mwEiR1AEBChsgP3pcC1fRD0wuPUg5DrTvKGAob+zOs54CC3bxHLiz8oXTmW4tJis1Y1B8QD8/MQw3gzamGH3SnGlyr/Wgm4RDj0eJCsl4dNON6nkZyjd0xoolWo15SGIPKFaMaku905gneeIBnoUequVufQ2TgJhmR6Sh8pkALbU0RwxB61wANASUvi8FEnAa9rX3zGRif9er6KG7jsleoLI9KoUIhq8ba9rKERwJ9+l/drwv7xfmX4mpcwpcetSqiStJ+FZRDuqMuUBelIHKXRFhiWas868stjGCLXQERSpy7ImGUB8XOZ9wSJtJXw88QnYO7cc0/Nyz44wC7+fNv20sjYhVvmAwuNyL0hfj7wR9qXegeCDJb3kRW6nQ7HmXUmMYezYbCSAtzGce1VGGfs0MnRgzmD7VrcNKiCOw2lvlaD1TL3p5AkhFr4ZKaSxg+wL+AXGDjrnSzGqMqc+ltpGwCWyqKCGxVS3kOeaCnpSIEoV7W3X+cG/DAzYXavwW6ORccHyMrHlSxay28uzFx8tp3GOdCJEu3TheQsTDMTKN+TcZssLD4Pnsw6ewYQJz7hyKOC5Zgr8iDCfzKuKO8UwXReKhI2roD1UoOiTbksp1gaxRD3PPIr0xTNjMyDaPq/D3FrAvbnXgljRFIrICdYkH6fwno+jGj80VdtDCEa41bNcumzN4iXDRN1jzMS39EUHyHuP45C3MSmQJJGorMin4c7FQUHMhYTfHj6sDmgrQxy46YUmmVTdBH+4Src/xtIpPoW018INkwdGoUtomCtwzN9rhkysG8dvOviz1efx5dJcCVbhcbMQ2NrlhqtqpZtw2qKyuJ79Oa9oA9iIerm1Ar9LQvofaw8HmIruJ38L4ofykqyxiOMrkXJvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/dev/mem and UIO map large physical regions with 4KiB PTEs, even where a
2MiB or 1GiB entry would do. vfio-pci fixed that in commit f9e54c3a2f5b
("vfio/pci: implement huge_fault support") by populating on fault. This
series does the same for /dev/mem and UIO.

Patches 1 and 3 add the two things a driver needs outside vfio-pci: a way
to reserve a range's memory type without populating it, and the order
dispatch vfio-pci open-codes. Patch 2 fixes a window and pfn check in
huge_memory that the new callers reach. Patches 4 and 5 are the users.

Applies on top of Lorenzo Stoakes' fixes for races between huge and
non-huge faults in PFN mappings, queued in mm for 7.5:
https://lore.kernel.org/all/20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org/

Changes in v3:

- Patch 2 is new: the window and pfn checks moved into mm, where every
  caller gets them.
- /dev/mem keeps the eager mapping under CONFIG_IO_STRICT_DEVMEM.
- Renamed pfn_range_track() to track_pfn_range(), and dropped its addr
  and size arguments.
- Shorter commit messages and comments.

Changes in v2:

- vmf_insert_pfn_order() maps a write fault writable at every
  order. (Sashiko)
- COW mappings get their own vm_operations_struct, instead of a COW test
  inside the fault handler. (Sashiko)
- Corrected the L1TF claim in the /dev/mem and UIO patches, and dropped
  the claim that uffd-wp can write-protect such a mapping.

An LLM helped me find corner cases and fix them in the code, write tests
and run them under QEMU. The runs on real hardware are mine.

v1: https://lore.kernel.org/all/20261111113045.35368-1-farbere@amazon.com/
v2: https://lore.kernel.org/all/20261112125638.12209-1-farbere@amazon.com/

Eliav Farber (5):
  mm: add MMAP_TRACK_PFN action and track_pfn_range() for lazy PFN maps
  mm/huge_memory: check the window and the pfn alignment before
    inserting
  mm: add vmf_insert_pfn_order()
  mm/char-mem: implement huge_fault support for /dev/mem
  uio: implement huge_fault support for physical mappings

 drivers/uio/uio.c               |  99 +++++++++++++++--
 include/linux/mm.h              |  18 ++++
 include/linux/mm_types.h        |   1 +
 mm/char-mem.c                   |  81 +++++++++++++-
 mm/huge_memory.c                |  18 +++-
 mm/internal.h                   |   3 +
 mm/memory.c                     | 182 +++++++++++++++++++++++++++-----
 mm/util.c                       |   7 ++
 tools/testing/vma/include/dup.h |   1 +
 9 files changed, 369 insertions(+), 41 deletions(-)


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.47.3


