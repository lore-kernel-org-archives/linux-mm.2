Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1762B606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=AIfcixie
Received: by kanga.kvack.org (Postfix)
	id 1987C6B05B1; Thu, 12 Nov 2026 00:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A1E6B05B2; Thu, 12 Nov 2026 00:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038956B05B3; Thu, 12 Nov 2026 00:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C933C6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:14:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 669DA1A0508
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:14:55 +0000 (UTC)
X-FDA: 85425302550.13.31DD0E6
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 320CE100003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:14:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AIfcixie;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UwNVdcg4hu49pw73uLx9po2gYXpqXbGe+f6RGcd22vk=;
	b=PS5CXgN6w1+fjH2vlTHyf4NcOKNxrbXbk5YzS5y/PTsnam/omIhDG/I6utWqSa2zF9ie6X
	dMUpisuWkDMp2UZIHT6aey370aOBsn3ZrwXy+AYvMRp1xeZjnwjImoOUrZxnAbs6KXO2bZ
	3RIe4doG8s/9T1i2kwqYikTBlnRFoFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460493;
	b=f/0jdLklwYyycvmYQzXb3RtNLYkxVlgd77eN0E5GexCy+qyyWVVfuCiEBwxY1AyqfoXY2z
	Yc9eaCrsZ5HTeUI2ekgpJMKimlqVyZILYcMAuZ6vke+hmGn2amWg/Kuq2/UkIDlxOgVPlS
	dwwU9gSwua38CCJyjZa+z/Cyil8IKmE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AIfcixie;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794460493; x=1825996493;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UwNVdcg4hu49pw73uLx9po2gYXpqXbGe+f6RGcd22vk=;
  b=AIfcixieNWzOojmKk5XQbUwPZuocAvpJGW1zVMdz7csAqM8R6JtVdc8P
   pL7Gq3tkAwBz4mZzJEXfVzO04WMkDjhMVKuqsqdTU+MMYyazMs0FqmfGz
   2D3x4ZSrNQ6OhZls2DiDoC8swCtzl+6SIgGoGOqyIM4f0J5iU04BXJ5Nf
   i3/Q98BA9LNRjTZrNIFnb0EA9cNUsSew99FJ+sVGVWYpt+RzuE9/0SHnW
   jG7AFOlcnz2WoxZCnfq40L2jxv9L7if9Jd4H2cRzxMuGdt88mQe10X3Vb
   so4f73QiN2PImAApoVc07OHusLay7PDYFNO/lx1UQDTSj0uOj7YzdgONv
   g==;
X-CSE-ConnectionGUID: RIQ8jwMwSDC7sVtqv/60sg==
X-CSE-MsgGUID: K4U543RsTumeq+5w07ubFw==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33759943"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:14:49 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:4823]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 49f785c0-b384-4044-b2fd-f34d41a03307; Thu, 12 Nov 2026 05:14:49 +0000 (UTC)
X-Farcaster-Flow-ID: 49f785c0-b384-4044-b2fd-f34d41a03307
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 05:14:49 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 05:14:44 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>,
	"Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, Peter
 Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v2 0/4] mm: fixes for huge PFN mappings
Date: Thu, 12 Nov 2026 05:14:36 +0000
Message-ID: <20261112051440.16140-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: cdkus3c56dn9btu4zcd1rrpm9xtbjquq
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 320CE100003
X-HE-Tag: 1794460492-207574
X-HE-Meta: U2FsdGVkX1+vp6+Ui8525dYPzrVE+QthvoIf6FYSAsFJeEHqe6OLrAkzl8NKpWOxNWp2S1shuen/obTFWJiY0jZpArs/PwMkHJiLpLZQmgDYv3QEwlrbEStd5ycW7JGw5WZ6BOeo7sPuIGf13ErOgTr7Ad1AxBqNFyQr8lZf+JH//u5Fzezmp4OEIU76qd1x3ZD7GUGBEEjqXPE6uaKedtepJpREv4i5quVPY9kArGrDr6XilYgq6DTQvvs6Uoci+q54Ftk15WXfRX1qTrAJR077tCPWLJc1obmk2D8YaKAAqxf01K8RABjaNCCMcuaGCQ7QYjeb30/+Em12eC2e3IOZYD8bhsVRIdFbgPdjlWrPVujLYvk6qaG+hxcl6EXiJMXMLhDZWVniJlBrIfFchaVckVgd27ujynz4TzXDK7mEpmMoVqItmpnoi44Wf2I2IZPUJ528T0S5Yr6Yo6b2DL9i5/PKbJhQ9MTwWiQZVKw27WU+NRO1lAlyU5bYWg74MPhW7YhWkvJ+81g/HgoV7WYtWDmuEDsdVOui+gmQtWfkqb9Yg+PXIXe58GUGBzolvB3RiGtnA3AD3qzWDeyZxlVGjLeKDZgNfLQgBSQq11PWMbSJBYyCQQ66AGukaQ/bz9mJk1QP6v74MuEV/iO2stHi431VAzYfaw01J3DI4zg4BH2OIQZg+h6A7oIzLKwFu6XbdvadWVYq+mJkcLFHByC8XnKogDIjoTcMQITV2aY34Yzwzclz32wN0qBEFbZOjmMexH8CnpB+QSjlbGZd4ZEzYU0A1ifVGQlQH4xC9sW0vfr950tuDBbeeTuaEGVDAt8Clh+1oVTPFqkttLkpv1zhwLEudIGBjlMJRoc5ac3VrYYGbXmwPRYrI0v+OUgVZDJ/EUCweQRol+yYi/ZaGYtG4hWccJB3hS/0tg5taPYQmieVJLj8IgUV2pk0cVmBJwDhQgfp62PVDy3mjZT
 eOj/IJMY
 QNvxMJPoK5QEeumd+JPFJBHRaANczVayG1tA/4Un5xxPKsXzJ5T0OphMEi3V0W2+MQQW5xEhIhmHrQyaXOz9zCHkXRpYgLd+K5w2v+s+05QF/JO+WrAi/Qbrqey11nun2BD2zIdzP33zCbQpeydJ1rzsMSw6u5LwVbhhTx9EbhK6W4iqKz3uyPbasvVDywXtyjpBh1fNXjm3C44A/IFy1dG90IWBlnrumwIvyBWZ4Zwk4DZNLvYjST2nReN+QLpNMBi6lVFbvkBACDfbzjQxN0IoEpH6fKvbuh9WinzzsO8LA/9o71Htv+pAB4yNg67HOj5dXKU+xsRDigYWAFkBcTKVvFLzWej7ur3Q6eqQ8W8rzsHDElIwoktPUNDweGybGb8C7ahLHNR3cW5nJ/oTLcsOIhZDwOHNxsOaEMOnRFFdLEDjwCB/i9vfVqdrabfcaFl1yms8uhlDSXjtatg4QW4WoAbFfgqGAGfUKJGgnfLyhim96mIH5tWqiFqn0nKyp1/z3dGx3azva0xSZxZZElgT1+igHOhxI3BJL3QRyCK8WRR1ibfngIV3DheB+RYa1UK+SoM/0j6PylkT9wYvnMxxic3rL4aL9wO/fVjbRor52P4SlUi38fVGbNhDer8QhLAeEAVvudtWOTxZWQrINH7LH1FhUGzpR0VBhqDyICrwcYvMIn8GdPOoMm91XgwXFR8pLElltoYkt+oJ4oObgCz4OpUK0X3qPz3f1jLar/hIFqwmxqsACgJZeOC7f2GUUi95dKfFfEO09pQnn1Qfp8ZSW6VMHQy8zcoD8JuC04x8QdMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Four independent fixes to the existing huge PFN mapping code. They are
not dependent on each other and can be taken separately.

Patches 1-3 are three symptoms of one race. A VM_PFNMAP mapping that
provides both ->fault and ->huge_fault can take faults of different
orders on the same entry, because the mm's THP policy is read early in
each fault and is not held across it. Flipping it while faults are in
flight, for example with prctl(PR_SET_THP_DISABLE), is enough: one
fault takes the PTE path while another installs a PMD leaf over the
same address, or the reverse.

This is reachable today. vfio-pci has exactly that shape:
vfio_pci_mmap_ops provides .fault, which reaches insert_pfn() for
order 0, and .huge_fault, which reaches insert_pmd(); mshv_vtl_main and
nvgrace-gpu are built the same way.

  1. walk_to_pmd() asserts that the PMD is not a leaf. With
     CONFIG_DEBUG_VM=y the losing fault hits that assertion instead of
     recovering.
  2. insert_pfn() reaches the PTE through get_locked_pte(), which folds
     the table allocation and the mapping into one call and turns a NULL
     from either into VM_FAULT_OOM. The losing fault therefore reports
     OOM for a mapping that is healthy.
  3. insert_pmd() and insert_pud() compare the PFN of a non-empty entry
     without checking that it is a leaf. A page table installed by a
     concurrent order-0 fault makes pmd_pfn()/pud_pfn() report the
     table's own PFN, which never matches, and the mismatch is warned
     about. Under panic_on_warn that is fatal.

Patch 4 is unrelated to the race. insert_pmd() and insert_pud() build a
huge entry from a pgprot laid out for a PTE. On x86 the PAT bit sits at
bit 7 in a PTE and at bit 12 in a large entry, and bit 7 in a large
entry is _PAGE_PSE, so the attribute is silently dropped: write-through
degrades to UC and write-protect degrades to write-combining, which
loses the write protection. Run the pgprot through pgprot_4k_2_large(),
with a generic identity fallback for architectures that encode the
levels alike.

How these were observed, since it differs between them:

Patches 1-3 were reproduced on x86_64 under QEMU with four threads
colliding on one address of each PMD window of a VM_PFNMAP mapping
while another thread flipped PR_SET_THP_DISABLE. With patches 1 and 2
reverted and CONFIG_DEBUG_VM=y, that lands within three seconds:

  kernel BUG at mm/memory.c:2392!
  RIP: 0010:walk_to_pmd+0x188/0x190
  Call Trace:
   get_locked_pte+0x1b/0x70
   insert_pfn+0x40/0x230
   vmf_insert_pfn_prot+0x94/0x100
   __do_fault+0x30/0xb0
   __handle_mm_fault+0xbb2/0x1a90
   handle_mm_fault+0x9b/0x270
   do_user_addr_fault+0x15d/0x630

and BUG() leaves mmap_lock held, so the system then wedges. With those
two applied the race is survived, and patch 3's warning appears
instead:

  WARNING: mm/huge_memory.c:1649 at insert_pmd.isra.0+0x1d3/0x430
  Call Trace:
   vmf_insert_pfn_pmd+0xa6/0xf0
   __handle_mm_fault+0x45b/0x1a90

With all four applied, four runs of the same test made 102656 colliding
touches with no BUG, no warning, no OOM and no incorrect data. Debug
counters placed at each site in a throwaway tree confirm the recovery
path in patch 2 is taken rather than merely not crashing: in three of
the four runs a fault reached the VM_FAULT_NOPAGE return after the page
table had been allocated successfully, which is the path this version
splits out, while the counter for a genuine allocation failure stayed at
zero.

Patch 4 was found by inspection rather than from a failure report. The
in-tree ->huge_fault providers map write-back or uncached memory, and
only write-through and write-protect set _PAGE_PAT, so I have not seen
the dropped attribute in practice. The entry is still built from the
wrong encoding, and a caller asking for write-protect would lose it
silently.

Found while adding huge_fault support for /dev/mem and UIO:
https://lore.kernel.org/all/20261111113045.35368-1-farbere@amazon.com/
That series is not a prerequisite for any of these.

Tested on x86_64 under QEMU with CONFIG_DEBUG_VM=y. The race above needs
a VM_PFNMAP mapping providing both ->fault and ->huge_fault, so the
reproducer ran on these four patches applied on top of the /dev/mem and
UIO series linked above, which gave it one to use; vfio-pci would serve
the same purpose. A 30-check functional suite over /dev/mem and UIO
mappings passes on that kernel, with the same counter totals as v1. This
series on its own boots clean, and mm/ and drivers/uio/ were cross-built
for riscv64 with -Werror W=1, the other architecture selecting
ARCH_SUPPORTS_PUD_PFNMAP, so insert_pud() and pud_leaf() are compiled.
checkpatch --strict is clean on all four.

Changes since v1:

- Patch 2: split pte_alloc_map_lock() into pte_alloc() followed by
  pte_offset_map_lock(), rather than calling it and then re-reading the
  PMD to work out which of the two failures had happened. Only a failed
  allocation now returns VM_FAULT_OOM, and a NULL from the map returns
  VM_FAULT_NOPAGE. That also covers the non-present and bad-PMD cases,
  which v1 still reported as OOM, and it drops the pmd_trans_huge()
  re-read. insert_pages() already builds the PTE the same way.
  Suggested by Jose A. Perez de Azpillaga.
- Patch 4: corrected the commit message. It said a write-through range
  ends up write-back; with the PAT slots Linux programs, write-through
  ends up UC and write-protect ends up write-combining, as the cover
  letter said.
- Patch 4: Fixes: is now 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()"),
  the commit that introduced the unconverted pgprot, instead of
  6857be5fecae. Pointed out by Jose A. Perez de Azpillaga.
- Patches 1 and 3: picked up Reviewed-by tags, otherwise unchanged.

v1: https://lore.kernel.org/all/20261111140655.34281-1-farbere@amazon.com/

Based on v7.4-rc2 (067c5c24cef2).

Eliav Farber (4):
  mm: drop the huge PMD assertion from walk_to_pmd()
  mm: don't report OOM when a huge PMD race blocks a pfn insert
  mm/huge_memory: don't warn when a page table blocks a huge pfn insert
  mm/huge_memory: use the large-page PAT encoding for huge pfn mappings

 arch/x86/include/asm/pgtable_types.h |  2 ++
 include/linux/pgtable.h              |  9 +++++++++
 mm/huge_memory.c                     | 20 ++++++++++++++++++--
 mm/memory.c                          | 19 ++++++++++++++++---
 4 files changed, 45 insertions(+), 5 deletions(-)

-- 
2.47.3


