Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB91606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byhLqDIe
Received: by kanga.kvack.org (Postfix)
	id DA8996B05B1; Sun, 15 Nov 2026 15:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58C76B05B2; Sun, 15 Nov 2026 15:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F506B05B5; Sun, 15 Nov 2026 15:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965266B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:59:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDECE140811
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:59:53 +0000 (UTC)
X-FDA: 85438570266.29.44B4F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24505C0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:59:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byhLqDIe;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VA2364/cpCnUggdKro+8A6hQCGEzXM/toJ6MBqEOOtA=;
	b=1FqJCyViTqnnaZZc51YOFYQPa5qpLWVgdTaBP3Jhdu1LzjZnsaqCDs+aI45Y9d9mMj8Uh1
	r7xgd+2mL3ZY/jqFtVuAjdCBb5SEJFpUm7tn/PNHcD/MGAgBofx0AMZzcPNh/sW/0pX0sE
	8pOGedye/1NoRgz11tOk+yTFE9VfTkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776392;
	b=UbExWhsmkoDApHVcHRBWa03mSB6oAtjwYCewmDEYsxjAUBUecEMOp1nzlZ+TM/tQv9oER6
	kga3qNnPH3+iND1EdUGSN5Zi5NQmndkYmpJsBNDaJOQ0cz41uq4S57XeZTHb1VfFe7vaWT
	UhCJ6zvzCEvsxoTBGz2DHNvVsJd0XWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byhLqDIe;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5067F406F2;
	Sun, 15 Nov 2026 20:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74EB1F000C4;
	Sun, 15 Nov 2026 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776391;
	bh=VA2364/cpCnUggdKro+8A6hQCGEzXM/toJ6MBqEOOtA=;
	h=From:Subject:Date:To:Cc;
	b=byhLqDIegiQVqxAucl9Glj1PrPu917T1FZTNs3DV7p9HnAejAgQAbynrsCmrw7/Mm
	 JaTzPT1MXtu7jaYqDZ1s+W3fOGw3iixNVGPUZl9yHz6YHU164bYdk7NeETPpJHqUd+
	 I9nfdjFneqbnxYmYlKRzO9ioGQ2GRNJw8Y1h2vI3eX8IkXNz7Y5u4OJzWzCcln5Qg+
	 +tAMDmEkriNqw40FVMLziHs8KxCSDHLlzB79Jnv6vgPeDDxXkzlhcuJyRv6PwjQH2L
	 DXLZdPxf68lxWwnHXLohGwnnPkSn/LQI8dPlgRuZNMFM+hO6PZf5a1oqJHflx9oLcW
	 4UW+BE6Dle7uQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/3] mm: fix races between huge and non-huge faults in PFN
 mappings
Date: Sun, 15 Nov 2026 20:58:19 +0000
Message-Id: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOsc+moC/yXMQQrCMBCF4auUWTtgosnCqxQX6XRiRzQNmaYUS
 u9u1OX34P07KBdhhVu3Q+FVVObUYE4d0BTSg1HGZrBn640xDqfathzTO2SMob4WLIFY0V2u7K0
 f2RFBe+fCUbZfub//rXV4Mi3fHBzHBzCyPk97AAAA
X-Change-ID: 20261115-huge-pfnmap-fault-races-534e626de5cc
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3985; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xSqJJkNSDKsyFei27utb2c8SL/5Rn98AsgyN1JAUJu4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ+yTpFLf67/xKjee/RnzUbFI9ee7q1Xc1liUrb8eJ7q
 xl2KPuXdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi+5cz/K98tov5J8OUtd5r
 xNJ1p/LeKVpV75Ux1y6/7ZDLO2PDyU6MDJ+rxPeGbtcxrnjlevhKpfP5mhPVYc8U5UJv7XIwn8v
 DxgMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: qhdmmkcrhhgjruw8qinbkgq7317fa1yq
X-Rspamd-Queue-Id: 24505C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794776391-530035
X-HE-Meta: U2FsdGVkX18gESCsTfvaV/KQf53mCoUS/JkzK7if67q+nSl7j0QhtuF2plQd4ySAW2rAycJOdPrQua70bUs6QcI3Qehdq7WaDWzeogacqOU8jvCvY7GQeNupmF5tHAcZuQRte0A7ivYEHNtkbPoDVQ8RlY1NgOldU0hkc8JVNNVmjl6BW2td+BrNKqYQE+dxJsvovLmgo+rFY+szIZBgaMnaaqyemujUC0RxpV9bwyFZYC2iC+TAmrY0S7Yrk9opNdXMxeonhRz2X20skq0ODWAut1jMxeT2VZrhq0QcVz6E8+Q1P9bX4IsnMnoVSWN5JGMcZkuHWj9kOyu9KMiQglRUBIelcyuwOnwvj2Ph3ne1GtST9wesDsanYTUdAtzC4ao4aUSVK6X2f4YhMd3/wpKw3Y5cye2L9uecKS4B+ruNO+B6mBOk/mRw1ayEN/kQZpQKanvXR7ogxbhkUch0WoFBmWstY6MVpdrdB2AXi7h3iO5bVU1G11iQWTiIIXXrPbX7SJ9xD86oXh9GDpchd2GCdWFEzIanaj+9Z3AyAHX4dB45M+7yd28nw3RiJSAulsODh2EFtYUCMU6ax8Q9fJm35naWxdFoXotJ+7j26g1aCkDD8gkuXxLxLr4cOkjvR82bM2QQ+3L4s+UmUwsk6GiDi9ZeZ+iHkfNlnk1deVWKooqbpZhGTyd1fINezgpNiQFtUvvGEv6zwME1DqRvuHyfuyoaKihSh17CgJjM8GlV5joRhoyZmhsami2Kac87H/QNxUjrvEtZi6U5Llb7T6qnUdHxCFouKtWX2yBBvrftNurVA1x/nyFnWHKVF6uu5t6tQHVNaJ+uU77IXlN+G4NSvTkkd6yhVKe54SnZly2oSXJETkKK+PXVzURW+tsBZe7XOS1Y7eHPHTXJ12zE1R9ei+6h18XA5ZI7ab1if8JFvCefWhn3lf9By5cljAV9HD+LxcyLUwQrF37Wwcz
 dxPrJ4ap
 Ou26AreKDzr2HAwA/NwXjwbz+/S1CJHuEn/ADF1OT/k78cUUBJwLRQvFJR3p3xg484DfavVwyx6qyf3lpfvhWlWntCmeXFyaW0oFkr5Ncx2dti5kSbe8urilrW1iZXmxqq88sJDbmQCI7QXgRlWKoTvFvK8xUy9d0H0LSzLv8zI/QfYgLppkGoksXWq8jNfnndYAM1N5PCbxxOoUfIuf3LGfi1S6UnKftIawWIbTaOxyCrdxSmtb7QZMl7zAC0UbDBAIqze5qgnidKyG+PA2Htngo77raVU+bmNzoQ02F8+1OMmhS6WbPKRdBpcTJ3J3XmJc7nUVvl1bsOlJn/8F1h5IyzkcgKE1bHWlYI96m/aEJg9jJ2bXQIn7ys1mJvsHJUavmnPjdma6zrXKUtfiFGFlVfzXBbIUm02YC58AiiPaykb0ECeK2o958bSl4eQkzbOfQGkeLpq5tPk084dLZUjz576xy+RtNAaCcOdT0VgXeXsZE/rgCghPA/nc72rp7cDRVpyXae8ZmLAEt9AJ6HrjekFyzPr212PQMgmUxRdBKzZjYhvfuft6oTOUEOugbLZ1gkI71zavWn0dg+LQBi1zTXyvu7iqMwK0dD9YfvMar2tA7wCrJaaBV5gilYAx/xuzgnTrWrqM1kCP5dYe18jptNvQWH0YjFsY7vHdymIi7mp5ObZI6o+46gP+LKxSC66MUQkbmggs2ipVo7T3Tb7JhWdpyBtJSKZXqqb5zjAowkSqzytVzCUVMO7qTbGhDUdV0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A driver that implements both ->fault and ->huge_fault must anticipate
concurrent use of both.

This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
concurrent with faulting, as that only holds the mmap write lock and thus
does not exclude faulting threads stabilised by VMA lock.

A number of places in the code that implements huge PFN support fails to
take this into account correctly, which this series aims to address.

Generally the shape of the issue is that faulting the same empty page table
entry can result in the ->fault and ->huge_fault handlers racing and the
loser finding something they didn't expect.

The fault code must tolerate this, but fails to in 3 places:

1. walk_to_pmd() asserts, without the PMD lock, that the PMD entry is not
   huge, so a VM_BUG_ON() triggers. [ vfio-pci, nvgrace-gpu ]

2. insert_pfn() treats a failure to map the PTE table as an allocation
   failure and reports OOM, causing kernel accesses to the range to
   spuriously fail with -EFAULT. [ vfio-pci, nvgrace-gpu ]

3. insert_pmd() and insert_pud() assume a populated entry is huge and
   compare its PFN on write fault, warning when that of a page table does
   not match. [ mshv_vtl, drm_gem_syhmem, panthor ]

This was originally reported and fixed by Eliav Farber in [0], this series
reworks patches 1-3 of that one.

Patch 4 of that series (x86 PAT encoding of huge PFN mappings) is dropped -
it is unrelated to the above, no in-tree driver is affected by it, and it
needs a different approach which is better pursued separately with the x86
maintainers.

All three issues were reproduced on x86-64 under QEMU using vfio-pci in
no-IOMMU mode on an ivshmem BAR, with 6 threads faulting the same address
in each PMD or PUD aligned range of the mapping while another toggles
PR_SET_THP_DISABLE (note that vfio-pci had to be modified to pass the write
flag to reproduce the third issue.)

Without this series the BUG is hit immediately, with only patch 1 applied
tens of thousands of -EFAULTs are observed within seconds, and with patches
1 and 2 (and the vfio-pci modification) both warnings fire immediately.

With the series applied 30 second runs at each of PMD and PUD size complete
with none of the above, with or without the vfio-pci modification.

[0]: https://lore.kernel.org/all/20261112051440.16140-1-farbere@amazon.com/

---
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Alex Williamson <alex@shazbot.org>
To: Peter Xu <peterx@redhat.com>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <nico.pache@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
To: Wei Liu <wei.liu@kernel.org>
To: Roman Kisel <romank@linux.microsoft.com>
To: Saurabh Sengar <ssengar@linux.microsoft.com>
To: Naman Jain <namjain@linux.microsoft.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Eliav Farber (2):
      mm/memory: remove racy huge PMD assertion from walk_to_pmd()
      mm/memory: do not report OOM if insert_pfn() races a huge fault

Lorenzo Stoakes (ARM) (1):
      mm/huge_memory: only compare PFNs of huge entries on huge fault insert

 mm/huge_memory.c |  8 ++++++++
 mm/memory.c      | 12 +++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)
---
base-commit: 5b99c3309de70337f38bd6e6998ab8335c2758e4
change-id: 20261115-huge-pfnmap-fault-races-534e626de5cc

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


