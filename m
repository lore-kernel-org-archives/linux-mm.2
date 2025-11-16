Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE72CEBF79
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CA18E0029; Sat, 15 Nov 2025 20:32:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED5F8E0005; Sat, 15 Nov 2025 20:32:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03228E0029; Sat, 15 Nov 2025 20:32:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBC88E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:32:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3555313BE7F
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:30 +0000 (UTC)
X-FDA: 84114745260.02.08ECF14
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7ADB62000C
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eU04kapt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3qykZaQgKCLIbaSiaqSfYggYdW.Ugedafmp-eecnSUc.gjY@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3qykZaQgKCLIbaSiaqSfYggYdW.Ugedafmp-eecnSUc.gjY@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763256748; a=rsa-sha256;
	cv=none;
	b=wqSOn360m7n9JLILgXKDycwDLgm1414TGfTvXTBpQ4Ett+H4vv1MF1F3JwYiAw3sqRIjk0
	c2Zu/1gl1je+DyrzqAVfbhthpC7kvERc6JRcV3arnumVTW4gPdRVsVutIC4A0nLs7NVgQj
	fJtiHpJsVJenq9xU+l+Bzv0oH5xI0dk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eU04kapt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3qykZaQgKCLIbaSiaqSfYggYdW.Ugedafmp-eecnSUc.gjY@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3qykZaQgKCLIbaSiaqSfYggYdW.Ugedafmp-eecnSUc.gjY@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763256748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nIrByt1VZZMaZX/NwbB12ty+E27e+8Fq3BdD+JwCmdE=;
	b=UKvi3UV1YcnK6TLxYlXbAZ41jew2O/XLKYWT7Ni10ywArGFVSf/+9n/gJvUobIcLusv1O7
	87G4FVQBW3l43DVyDGxKurFGnb4uLkwhWO5RSOUAssAS3ArPs94FX3j33moVW9tCDnuNQV
	rq5MT80HSvaMSgM+iVqZP9oLSW2x/kk=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2955555f73dso30402295ad.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763256747; x=1763861547; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nIrByt1VZZMaZX/NwbB12ty+E27e+8Fq3BdD+JwCmdE=;
        b=eU04kaptIy2ZWAImcWUWF7KsqnnoRTnkeQn2m9FpEbGI3eUdaOt9xQMDTVzd4ZCYCI
         5ZS57CM2nSPI1zEI6w29nj9ldnaNYK4p8IGLLysgInyaVx4lxuTPWf8xlei1L8JSZaM/
         Dpl1dh9gJnYZ/B/VNqzKt2TDHlAbWFzyx0GXpKvvfvpBiNa6gsHdAwijf7aOgUkL1GyM
         FKz13aBr1M5fOTedXfSL6eHzbhtsF4oFtznuATzGB+nNvWJNYd9l+P6aVlqq4t+USoIh
         66d1fELHp4Wbq325WV4+XiwPf8YITVfG16FY600U/Ibs/1Xau7mMRqpnrIsjccaiw/VN
         im1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763256747; x=1763861547;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nIrByt1VZZMaZX/NwbB12ty+E27e+8Fq3BdD+JwCmdE=;
        b=TzV8nuy8B/3sqFNL8HnTc4SEnDXpLE7+RhKXA6R1hnTNxR2kG4r3r5dtQgdMCOKlnQ
         UbFp1EmEqSXjoy/E05+ZaaUYjNPpA6uIj66Wst593FciOVxR2rUUXWZSVEDp2MRDMkoA
         bhtcvBx6IzVgnUs0RYAUliDsWVitILrc77L2vKL54G/84f4eCCB0w6WzAS2R3ZsxYTRu
         tXUqQRnBvV684ct8loG6V+2Ii4pHn3rwmSY60jsw7BhjvGAUzfb8EaVYXHwhEPJJ96e2
         JMdJNqLa8DtAyFKTbxTNSaE9FJbw4qIhR1UqaWniHrWvIEWLMPXwNTH/gh63ZzTrGz+3
         IWqg==
X-Forwarded-Encrypted: i=1; AJvYcCVcZLRPa9TC613UanZ3aIUqISFnEYBgKFh908o9Grho0kpHlKzTsm6qBcBFSV/fd8uilhMWMyyftQ==@kvack.org
X-Gm-Message-State: AOJu0YwPetJrnB0IDD+zy3qjBL9C4xZUN2oL8QxBQyXFzHD3pT5qTiSh
	f7IgdLy+p68y1RFH9fmhzIfamVzE9UBffeBWYdgrJodcE/G/c+V6DOUmmnjzHC17lJXaGLEJYVF
	/zHNZ3Q41/h9BkA==
X-Google-Smtp-Source: AGHT+IGEId8VQV6EnjjzjhQ7E7WrfZaNer4Ithw1tScNmlwXQtjYa6DqLZ/MZlXgCrT12Tsa7zKSgYkd8XexwA==
X-Received: from plko5.prod.google.com ([2002:a17:902:6b05:b0:296:18d:ea10])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:17c6:b0:295:1aa7:edf7 with SMTP id d9443c01a7336-2986a73ba63mr89628075ad.30.1763256747026;
 Sat, 15 Nov 2025 17:32:27 -0800 (PST)
Date: Sun, 16 Nov 2025 01:32:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116013223.1557158-1-jiaqiyan@google.com>
Subject: [PATCH v2 0/3] memfd-based Userspace MFR Policy for HugeTLB
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, william.roche@oracle.com, 
	harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ADB62000C
X-Stat-Signature: riymbics49owucqy6sumy8mh9pyg5uym
X-Rspam-User: 
X-HE-Tag: 1763256748-962657
X-HE-Meta: U2FsdGVkX1+Pk4JHNSsFzIRBHkD91UvmBRmHfyLA12FW2+Em5Yk3FJ/G4buqGQBQFay3VkbeLiCGYGMf3bTA6ZQum+QjYcJaCIwTME5mkdzCQXx1qY0HkeBpztg39L8pRyFhFPqw3DBeDzRlX07TUzal2A2XFMos72kdUfT/qaiWeT2uMdB+hGuKa7UsGJ/zjk5XniLYFl41kTlS7jatM+a63LScc0u0Wl3/RZ9gkKksFfRDyMVeGDyMM3AHCTy6u9+hWNn6NYMTBkKAZ275G/qH88ogYio5SxqE3+9zdYrtbOvrnziOX6DR8en8ZsyME7UqpWPQq/rDiz2aXVJKtErOk+l7ZBD9MnvdOnTB7jZBxrFmb/wMlR9Spe7HognDvy13OD0R+eZHjYS8XfBbYyyyn96efMJDH3TENRv2smb3Ls0Xw6QQTQEX0PI+lnXQzdSdM3ZumIRhOVDnVxK2hFnQyXoe1BEdlzk6b8FmhfesYSaRr1UOM4zxfTVzipsMiMaYCu/LXJ0/eHjRFd0hRoCwDp/nOBwdix3UUjaY7HVGJeK4SZejQKNVWt8A1Bke05S3p4bQPyXRe+xiQBVtvUh6ZyptXMIKyHfDxRexHYRUSZ45v47Wj0pX7eq9jfHRnevoV8DxUgxa1MkZQSivczs826gZuLVpVp5HFGmfJBOuJ5sL/TvKsOeMHjEBTFcoPDZdmHdesl68806yzCzNPsoAX+elZ3b8UEG6x8ERn11JBoLTAA2gmFhIQhEpc6oOAzW/H52kBD7Il/8LjEhtjp6Vrd5vHesC6B0qMdnf13oi+pZ01OabnnoochF26IvAhl1WlUA5iO/3QoE5/O/H0STeLhAL0Sh1QVIwAJY5xbtgiTtLTjQtRMFAEuPZEUWgRPcWbpEgQuc7vnkPRkaVHb1YOVfsTMmzvSG8iO8DDJDQ+HLP2QyUsLu/hJaouakabKonExFmrbr4Yg0S2+S
 2UgdHvRy
 oX/xL+xQXqO90MbQm3zMT2eMBQNeSapK1rTjiZJ+feGOUO4oKBGGJGn88VFuPFDviV4+9uqDrxWn3QQFDQI0lwNGfB/tTc3nH2Ga0SnZlceUzhDWb+fZaluRptwjMzO+VgeqwETeBIeLb+/gGPiORkf1r7JfoTqwcWZqnp0RHBS1Ncq7cMomD31qdd5l8Lz4k2qYlrQfMMQjjgC6yJZ8bfxB491qGTTI9FqZty16arHdQ0/k3udIiX687cOSe8p6t67I2He48kNSfrZ/aSObWUkqIjYid4v1JbRLpNvE9Bzb4o0LzBoZa6+u87A1gc71Zdmo9fhUO/3TuiDVmhylV5ueJMG0641pY/JlRw4fFAGHiibA1hEX4nmcMC9gZvBz9ov0zWAnojLLUPqVZWC3ZksHn+fSRRKdE63sScukz1cRB6N+76J6kYvnTvRvhfdZ5iubonwAMoGZPpddWPeL9/0nPKVf6Q/JzuzuiJDGb05jr3sUeDhY2y1JI+dVd4EspqAeVQ7/CJ4oPh6UpLZBqiLVPLRgdAepAVpqoltrL/K0TAYTnF6WE74YrOXeB11qTwDgbpJ9le1wrkLYVkBux2N3ceSHEFrfSEm25eKitLnw5romxHbWNv8KlSEXbHB01ZLj/IrteGPeLQwTVYoBzzjMTW6cqcVxk4rTcirv9cibKOi8j110X7iy6oP3TEkQpf5mmdHTksM3wSciS/ZA8Z8BULg4ECy4IzpKMKZ45voGah0DAF9AJhpmtbbaoJyFcodgHPVaiGlI91rfQGVscarrdlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======

This patchset is a follow-up for the userspace memory failure
recovery (MFR) policy proposed in [1] and [2], but focused on
a smaller scope: HugeTLB.

To recap the problem for HugeTLB discussed in [1] and [2]:
Cloud providers like Google and Oracle usually serve capacity-
and performance-critical guest memory with 1G HugeTLB
hugepages, as this significantly reduces the overhead
associated with managing page tables and TLB misses. However,
the kernel's current MFR behavior for HugeTLB is not ideal.
Once a byte of memory in a hugepage is hardware corrupted, the
kernel discards the whole hugepage, including the healthy
portion, from the HugeTLB system. Customer workload running in
the VM can hardly recover from such a great loss of memory.

[1] and [2] proposed the idea that the decision to keep or
discard a large chunk of contiguous memory exclusively owned
by a userspace process due to a recoverable uncorrected
memory error (UE) should be controlled by userspace. What this
means in the Cloud case is that, since a virtual machine
monitor (VMM) has taken host memory to exclusively back the
guest memory for a VM, the VMM can keep holding the memory
even after memory errors occur.

MFD_MF_KEEP_UE_MAPPED for HugeTLB
=================================

[2] proposed a solution centered around the memfd associated
with the memory exclusively owned by userspace.

A userspace process must opt into the MFD_MF_KEEP_UE_MAPPED
policy when it creates a new HugeTLB-backed memfd:

  #define MFD_MF_KEEP_UE_MAPPED	0x0020U
  int memfd_create(const char *name, unsigned int flags);

For any hugepage associated with the MFD_MF_KEEP_UE_MAPPED
enabled memfd, whenever it runs into a UE, MFR doesn't hard
offline the HWPoison-ed huge folio. In other words, the
HWPoison-ed memory remains accessible via the returned memfd
or the memory mapping created with that memfd. MFR still sends
SIGBUS to the userspace process as required. MFR also still
maintains HWPoison metadata on the hugepage having the UE.

A HWPoison-ed hugepage will be immediately isolated and
prevented from future allocation once userspace truncates it
via the memfd, or the owning memfd is closed.

By default MFD_MF_KEEP_UE_MAPPED is not set, and MFR hard
offlines hugepages having UEs.

Implementation
==============

Implementation is relatively straightforward with two major parts.

Part 1: When hugepages owned by an MFD_MF_KEEP_UE_MAPPED
enabled memfd run into a UE:

* MFR defers hard offline operations, i.e., unmapping and
  dissolving. MFR still sets HWPoison flags and holds a refcount
  for every raw HWPoison-ed page. MFR still sends SIGBUS to the
  consuming thread, but si_addr_lsb will be reduced to PAGE_SHIFT.
* If the memory was not faulted in yet, the fault handler also
  needs to unblock the fault to the HWPoison-ed folio.

Part 2: When an MFD_MF_KEEP_UE_MAPPED enabled memfd is being
released, or when a userspace process truncates a range of
hugepages belonging to an MFD_MF_KEEP_UE_MAPPED enabled memfd:

* When the HugeTLB in-memory file system removes a filemap's
  folios one by one, it asks MFR to deal with HWPoison-ed folios
  on the fly, implemented by filemap_offline_hwpoison_folio().

* MFR drops the refcounts being held for the raw HWPoison-ed
  pages within the folio. Now that the HWPoison-ed folio becomes
  a free HugeTLB folio, MFR dissolves it into a set of raw pages.
  dissolve_free_hugetlb_folio() frees them all to the buddy
  allocator, including the HWPoison-ed raw pages. So MFR also
  needs to take these HWPoison-ed pages off the buddy allocator.

One thing worthy of note, as pointed out by William Roche:
During the time window between freeing to the buddy allocator
and taking off the buddy allocator, a high-order folio with
HWPoison-ed subpages can be allocated. This racing issue already
exists today, after buddy allocator reduced sanity checks [3].
With MFD_MF_KEEP_UE_MAPPED, multiple raw HWPoison-ed pages can
be allocated. Since MFD_MF_KEEP_UE_MAPPED could exaggerate the
issue, I have proposed a solution [4] based on discussion with
Harry Yoo and Miaohe Lin, and will send it out as a separately
formal patchset.

Changelog
=========

v2 -> v1 [2]
- Rebased onto commit 6da43bbeb6918 ("Merge tag 'vfio-v6.18-rc6' of
  https://github.com/awilliam/linux-vfio").
- Removed populate_memfd_hwp_folios and offline_memfd_hwp_folios so
  that no memory allocation is needed during releasing HWPoison-ed
  memfd.
- Inserted filemap_offline_hwpoison_folio into remove_inode_single_folio.
  Now dissolving and offlining HWPoison-ed huge folios is done on the fly.
- Fixed the bug pointed out by William Roche <william.roche@oracle.com>:
  call take_page_off_buddy no matter HWPoison-ed page is buddy page or not.
- Removed update_per_node_mf_stats when dissolve failed.
- Made hugetlb-mfr allocate 4 1G hugepages to cover new code introduced
  in remove_inode_hugepages.
- Made hugetlb-mfr support testing both 1GB and 2MB HugeTLB hugepages.
- Fixed some typos in documentation.

[1] https://lwn.net/Articles/991513
[2] https://lore.kernel.org/lkml/20250118231549.1652825-1-jiaqiyan@google.com
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://lore.kernel.org/lkml/CACw3F51VGxg4q9nM_eQN7OXs7JaZo9K-nvDwxtZgtjFSNyjQaw@mail.gmail.com


Jiaqi Yan (3):
  mm: memfd/hugetlb: introduce memfd-based userspace MFR policy
  selftests/mm: test userspace MFR for HugeTLB hugepage
  Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED

 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/mfd_mfr_policy.rst          |  60 ++++
 fs/hugetlbfs/inode.c                          |  25 +-
 include/linux/hugetlb.h                       |   7 +
 include/linux/pagemap.h                       |  24 ++
 include/uapi/linux/memfd.h                    |   6 +
 mm/hugetlb.c                                  |  20 +-
 mm/memfd.c                                    |  15 +-
 mm/memory-failure.c                           | 124 ++++++-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/hugetlb-mfr.c      | 327 ++++++++++++++++++
 12 files changed, 592 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst
 create mode 100644 tools/testing/selftests/mm/hugetlb-mfr.c

-- 
2.52.0.rc1.455.g30608eb744-goog


