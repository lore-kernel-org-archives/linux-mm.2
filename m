Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EAF606A338
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzEpqPcP
Received: by kanga.kvack.org (Postfix)
	id 640CD6B0A54; Wed, 25 Nov 2026 10:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0596B0A58; Wed, 25 Nov 2026 10:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0886B0A5A; Wed, 25 Nov 2026 10:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2333C6B0A54
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:49:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B53FFA0FB0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:08 +0000 (UTC)
X-FDA: 85474075176.29.F07D74F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBB4B40015
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzEpqPcP;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621747;
	b=6jSwdTL6zHpI2Aj1wIGuyiHlceZDhhrgL/BE/tRs/qo3OA5g15xLPUoDQRyACkCOLZp0iy
	Wd+BA1w0e/1W0EjigXBTejuqgnQNC3IGv7YLCgUaRTGMzFj/TYTqtbe2UPSSzWNXT/8jN9
	WZ53PjbG3fwNoIYWBL5v2xKcw6YX1sw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f4E9fqa7EjT34/pouEYgQMVfRSlwer9Fxd7blOSlVs0=;
	b=UU79C/UEMD/m7hlaxejKHmktZPFljh9IU5lsQ8pYxk2g2ja0a212O5IeqCrH6L6OO7dszz
	ieN3uXRJhVh1PQK9KVdMEQq4QHEcPP2M5gYu+/Ukdk31OGZdFn/scEbJBuhzmyh0HZRgyO
	VvlVYTcdQ4VMAyVLtMxN4d/dCAGQo9A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzEpqPcP;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B563C632DE;
	Wed, 25 Nov 2026 15:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D5C1F000E6;
	Wed, 25 Nov 2026 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621745;
	bh=f4E9fqa7EjT34/pouEYgQMVfRSlwer9Fxd7blOSlVs0=;
	h=From:Subject:Date:To:Cc;
	b=jzEpqPcPKJl35HJnMb6btHGNnboqsxn2LLtp3CiO3gs8EwuRvcCpl8cNZxXbE0Bpx
	 MZrdOn9ufSNMSQopTzSQLWdCfqg5kGmeJuCH65BtmASREu970zUL4CFkuLtrOPSiSi
	 rkbJh8AHapnJCS9g3ZELVYyzhs9UPXBpfhS4dW22hw+8R7Lwexu6lIvPqbpejLzNiO
	 ltTjVyTpvpCxL4ukQAHxwoEHHxPAR4DJFeBNBdVmAb3duepteGgpHXrxvo4gfruVzg
	 c0WWUsv0I8KuAjFumZgNAeQ73OFtSF+mCp1osDEXh23UrkR3A2kiN6NP34dfpTlfYA
	 FLw+pGFqhAl7w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 0/4] mm: fix races between huge and non-huge faults in
 PFN mappings
Date: Wed, 25 Nov 2026 15:48:48 +0000
Message-Id: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/4XNSw6CMBSF4a00d+w1fdA2YeQ+jAMot1BFIC0QD
 WHvBpzowDg8ycn3L5AoBkqQswUizSGFvoOcqQMD1xRdTRgqyBlILo0QQmMz1YSD7+7FgL6Y2hF
 j4SihVhkZaSrSzsGBwRDJh8cuny/vnabySm7cuO3RhDT28bmnZ7H9/ldmgRy1soZrkylv/OlGs
 aP22McatswsPyH7G5LIUVrDuSWrSld+Qeu6vgDBJnW4GgEAAA==
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
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "T.J. Mercier" <tjmercier@google.com>, Eliav Farber <farbere@amazon.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4496; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Z4LO9d2vnfeRNb+fw6qh0PkH0/UA2FTNFPb1bDNeV6Q=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLZmdOK5/z9oxXgpmdRH8+6Xej6Uu7/3yNyimKNtjVzH
 lwX6iLeUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgImc62H4H5a6tEHhzYy8sk9F
 i1v28UzfdDyHucj+36zLOp/W+Ivv+sbwh3NzfHpVwGLvu3ECq4L83TdbNU87vfXNz4m8aV+OVMc
 V8wMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBB4B40015
X-Rspam-User:
X-Stat-Signature: 7brdwy7wrsg39wp9c3w1zusg1xwyaadz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795621746-80297
X-HE-Meta: U2FsdGVkX1/ip0XNhoacKw7RcJFjNfFsRd6Ayfjf4kC/ncBv1tZRCZiyBijgyxm6FmoaBv6vHitM7+k8OohtPXUxYv5L9jRJDIrZiyO278XqRANF20irI/q8xRQAVVhqWYUodyeDY2lOeLiWqapAziv60XDel2vrIYA9iG0kbSthwC2SYHGMohptzCav4Jzxq1YmPfXyj8PL8Vnhf3Sh3EqKHu24OcqoT07+fLJUSQFuwPTgloS0E8C0yYGl+XilPMAJz6FZ9vm+CKFMjmmdCP5mQjE3WeOMzCqYc4475YZ/UnoNfBgBPtX2R5ggfgAsyWxC+G1f5o0QTVmOG55rxjQ/CT4vgX3nPEE+L6ZyNzaOZPFEzXKlHcah833JU3B3yHpXHaHgeIpQLeM3ahUv5VkpwdOILIfNoPCdd2ByslALCh/6nJVWI0cnpXlrLl0yRyawoYB1lEbVK7UUOw3JNIRKj1ddo0wh/brGlCFpEqTXmIPscBysE6CljWg0WFOFEXn1MSYKMpMqaUNhsyxARzgTvrxJmJKH+fC/G/3KY6r2LptMSGQnlWw58LlzNN/6RLWqdhQPUCRkmn/YJLjpsP83CtgrsXcI9ZnJvk4y73xSkdUV+pNbGBoxKqjT+W5h/BwEWa1SaT92q3+zCHrfU+wLS5MQafy0DTivSzfrO8b/TW+hCrq/0AHCiZAfWZxv3B/soqhPM9J8FRhwdy0w60J0h5Xor1fdCzO78OWh67UtS68Ggt8/fyQdjkyUfiJWOHHIwwX6JmnbsVZpzk6rGy09fcZWJOTe+I15jVjmC1OXn+Wm60KJ0TJuJ8jJAHK42vTPP5jfI6xAjN01rRcdtbQbVSmV4vcT+oqhiuJO3vwn5RmPLD2tCPs0EWFznR02FwV5nEvJGzidN3hYgKpibn67GCLkjJKcGO1MHwgfL2fW24z+7Z5Is93lL1Jbe/sGVZtnTstIT1VkJ2JOr8z
 XIg55+Da
 iSafXh49yPU7pYK+7figXySg4H5MuOgHvDFP/PMi0vhUtlrFZKL2r6VxgZNREqlc/H7+HNFGBdK4pWa/vHz0wtHDdUq1uR2fOWZH9TkA9H3y0fLJyEg+hShcujFQ7H1jE7kfAu4Lz6kUqMvWjpPGWfHwmG3GrjctVmUtlWLPXjpaFMJ9Z2jttVqtuwAuyOTkKsOoBvcWTU2uRAIOzKfF6C5ZToymoW8sP2FwaYy97pxMg3G3tMq6UjmTyTybCkh+c5LxaSk/COav0cEN1y9QrNzdfLd/11gysjLMsLPGpnzNMfli72/nhggNoWa9V9RGa8W/tLkfw+YdxjRXC8BdTG/L4lWuJout1pCHCSiRzZ0LFzuTEyTZTHXHTajZs6qZkASB2P9pfX3ovkETMkIq+P3KjdOs/UYCrg+6yC4QgLVYdZ6h/rSQM84H1Ss4SRYi1wVFsbRea9AfeEpe/rXIW75bsHyB1spQ2lE6QlWXvRdxxizPaYF8Bpf53mKrS7iL0FY47q2RyJesHXfWF79GpMuPFSxZfaw25z3EhrCFn4x6OnPfFnq4HUwmtF5mgqQJRLh6U
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

A number of places in the code that implements huge PFN support fail to
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
   not match. [ mshv_vtl, drm_gem_shmem, panthor ]

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
flag to reproduce the third issue).

Without this series the BUG is hit immediately, with only patches 1 and 2
applied tens of thousands of -EFAULTs are observed within seconds, and with
patches 1-3 (and the vfio-pci modification) both warnings fire immediately.

With the series applied 30 second runs at each of PMD and PUD size complete
with none of the above, with or without the vfio-pci modification.

[0]: https://lore.kernel.org/all/20261112051440.16140-1-farbere@amazon.com/

---
v3:
* Propagated tags, thanks everybody!
* Fix issue with 3/4 returning -EFAULT, which resulted in a SIGBUS. Fix
  this by returning -EBUSY so the fault is retried. As reported by the
  kernel test robot.
* Updated 3/4 comments and commit message to reflect this + also that
  MADV_DONTNEED can result in a missing page table.
* Updated 3/4 to also have insert_pages() return -EBUSY under the same
  circumstances as insert_page() for consistency.
* Fixed 'Reivewed-by' tag in 3/4.

v2:
* Added 1/4 to have walk_to_pmd() return an error code. This is marked for
  stable as it is a prerequisite of 3/4.
* Updated 3/4 (was 2/3) to add __get_locked_pte(), which differentiates a
  failed page table allocation from racing a huge entry, and to use it in
  both insert_pfn() and insert_page(), as per David.
* Updated 3/4 (was 2/3) to have walk_to_pmd() return -EFAULT if it
  encounters a huge PUD entry, as per David.
* Updated 3/4 (was 2/3) to be authored by me as it is substantially
  reworked, retaining Eliav as reporter.
* Updated 4/4 (was 3/3) to use [pmd, pud]_leaf() rather than
  [pmd, pud]_trans_huge(), as per David.
* Propagated tags, other than to 3/4 (was 2/3) as changed significantly.
https://lore.kernel.org/r/20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org

v1:
https://patch.msgid.link/20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org

---
Eliav Farber (1):
      mm/memory: remove racy huge PMD assertion from walk_to_pmd()

Lorenzo Stoakes (ARM) (3):
      mm: update walk_to_pmd() to explicitly return an error
      mm/memory: do not report OOM if insert_pfn() races a huge fault
      mm/huge_memory: only compare PFNs of huge entries on huge fault insert

 mm/huge_memory.c |  8 +++++++
 mm/memory.c      | 70 ++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 58 insertions(+), 20 deletions(-)
---
base-commit: 5b99c3309de70337f38bd6e6998ab8335c2758e4
change-id: 20261115-huge-pfnmap-fault-races-534e626de5cc

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


