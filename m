Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BB4606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7Iq8gA5
Received: by kanga.kvack.org (Postfix)
	id 8B8526B05B0; Tue, 17 Nov 2026 13:31:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FBF6B05B2; Tue, 17 Nov 2026 13:31:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B7C6B05B3; Tue, 17 Nov 2026 13:31:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5806B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:31:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD81080254
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:31:48 +0000 (UTC)
X-FDA: 85445454696.25.71B4AC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E7FC340014
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:31:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7Iq8gA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794940307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MF6sJUYsF2XNf12BApOVZGbhsY2g7WBXuedDspoOUkQ=;
	b=fy09DcpQmPiRuM5FsseJJ5JeKef519lut0/X5yPg6Tcc3+eSeUy7emaA0OtRMKJMxFk94b
	dPGJkbFHBAxJt1ekYyqUmDuCH6VfDkZmfToB/YHf51vBgg1gfasVHI/t6Gikvh1/Cpg8/g
	oQaozWKG8XrhjqES5G2avvvcusO+NzY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7Iq8gA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794940307;
	b=rtMur7XraIKA4eJW4Z5vYYX7shloDNfsQu3w12Yv+RXk1yso3sVYnTy9o9o/INvNvOFm3A
	zqFCJMLqvxYHePKpya5kLRljnATr8433y9ChpipKCbfYkcisCIxVn8QTAI6+2qacvsM+Dr
	QAiODLGZc9bPijzoQeKZXw07m0CxkIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5771260DE9;
	Tue, 17 Nov 2026 18:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07881F000C8;
	Tue, 17 Nov 2026 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940306;
	bh=MF6sJUYsF2XNf12BApOVZGbhsY2g7WBXuedDspoOUkQ=;
	h=From:Subject:Date:To:Cc;
	b=K7Iq8gA5YcR1AChHEEa+rSjHfNrQ0i3b83shOSO1uvX4Eq2j6Rp0mY//V81RcJwMn
	 nXy/0zTo9ZrBFWx225OJLv3Qu114JHzW4k6/yuVFAYgqJLZ/7PbyVRCE+o/ohtPI6Z
	 GI71KOnULKeLlar6gzhz2C491/4Vpe3IlQqVBQqKEvnWymr5Ghnbc8a7OqZqd1jda1
	 r/160s/TwY7IWxVxnlOdC0rVFm5H8NDQp4kTVUMHBm1ge6UHPInxvxKK6Q8w2QBtrw
	 dmEUVhUBo0LA85UvMMubGim4uWgoE6dNcaNKDtwhBvsWNLocsllzBe+LBybeAvmFhP
	 c6zePBpd+gQxg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 0/4] mm: fix races between huge and non-huge faults in
 PFN mappings
Date: Tue, 17 Nov 2026 18:31:31 +0000
Message-Id: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQ6DIBREr2L+ujSCQpOueg/jguJHaS2aj5o2h
 rsX7AG6fJOZeTsEJIcBrsUOhJsLbvIJxKkAM2jfI3NdYhClUJxzyYY1ZbP1Lz0zq9dxYaQNBia
 rGpVQHUpjIK1nQuvex3PT/jis9weaJd/lxuDCMtHnUG889/5bNs7KpLqoUqq6ssrenkgex/NEP
 bQxxi8B5Xu20QAAAA==
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
 stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3913; i=ljs@kernel.org;
 h=from:subject:message-id; bh=00OYcEgp48TVHPBBwzIuZPpKjP+lTWun/5wvtt7xAnY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+zG1jWLbC2FfasYZLbtX/ALfsiUrmuy+HSRT+fr/9b
 W1457a3HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE9gQLk4BmEj4Joa/kqEf1TTV2Xpk5L3/
 Nr/Xqt/w9PxCNV6Ow6a/BFkPZ8vHMTK05ViFeHk8klJey3jxiI+Z2VLn6WtEJl9wL/76Pjbo3k4
 mAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: E7FC340014
X-Rspam-User: 
X-Stat-Signature: 1c6xznz46uxk6pobpj4upqjcd5ugn3ma
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794940306-40290
X-HE-Meta: U2FsdGVkX1/YOuk+PwXjtg8dnI7sxypagsJ6+7BgAo+AqI0ICS/RkRXwUPKC5HSJxf1qQIWHWSwICiZeg+dBtoiR2Ccfwa235mIZe1XweEAymmM2FDi/JBLpXFM5c5akzYm3nfWlCeWTbI98TeYpaQFXY2sZ/P1VsZksvQwqDfe+D96ckFjjVEbrBAUlPVNV6iiJJMpxBseCiRpLQyFMZMrRqAqPYmJ38fyuOJtPzbexhZRNtNWDB9m4Rh0U5HmzSE5dGsJOiOX/vDZ+evlNq/OAw/iVeflUsaZhNPdXlnafRGLo7m7cIt305xh6edfzl6KffrLa/hkk9ncHhh/I9kgcPe4PAdEkK265RIgprwNaN6CkeshcnAY5Wtw8l0r7zzo3tYPaU36pHfjA84Qo5HjH+GZdTs31lzOk2LLQnTMcxsv1UWHr62yHzKMACFAGRq34kUANN18r5VaSvfSBiaUwxriSNdnHEL3NUipcF2qP7swslR+gCDHWrcy/wOUl/VbIbdlUo3pe+JdZEx2U/9iiWa/D70DJeqpbrWoWOU6A6tJ0ch372SetFL4K/bJp6G5iS7/ye100wVNN2y3/joHxz9J2wYEGJ5YUPqPEOCz5wwlFLh8STAQGpoKGyjVDrzpuupBw3kPCCaCePK0cIDh9tnKJFpiFrBCxABIFGpkmzW2GOU7vIAEu4XKKKYtNwWqaCU2bXy95g0wq78NjEoGG6QeuaixJA+nYuRULVvasH7lYE0ajP9VDNL9VK0QYhPeJCiaae+RIXc7zDLMSr0fYc0qvPOa3MKw2P+wR8YpHDy8lIvtAHi6WyKXSZYmKEA1rIKKVHQ0tbXnIOdFuyl9O+GiCB0Pa+FWU6FLBIWzi5HEe+OX6ktKM2H+Vx6h6y8xT8E8s1ShkLfuHcOW7NwWjUgWbYvPXZH6ufAES+1WtgjP36ewImgUUq5smqdxJyEEhMGpthx/XgCNsNZz
 dQRvCPzk
 zBFC0kgFYncERSh48dbMn7NWGxg9FrTo1ACKA//g6Ux4abqxMIbOGqVSs69BPOVIlZKhDJwqs2wslR6Ovd6fbEAC+YCB2kNn4fb4HsMECxNgBr18QBu/dml+9nRAQt+8dFX8fqQyaMLW80g/kyzYmSSbmOnYh6mVM5xTGxi8fDUzRrxK7ICPvZPPPu+mB5GI6rJ6FuX0Flfc49SH22FkDg1GDRGYZXlxQ0x1oqXzZ4YQAjposiKmlY48jiHwvGbAKn3U+RUu5pIsWJnZSxf8t19GUvPk29DMQxxqKkz3P/LHYu4XP5GBqo9OqeoW5GLvsiqSbGQAmsTwn2Tq0FooWxtRRClrFOSa9grQW
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
 mm/memory.c      | 68 ++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 57 insertions(+), 19 deletions(-)
---
base-commit: 5b99c3309de70337f38bd6e6998ab8335c2758e4
change-id: 20261115-huge-pfnmap-fault-races-534e626de5cc

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


