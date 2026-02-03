Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620AAE7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309146B0088; Tue,  3 Feb 2026 14:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7576B0089; Tue,  3 Feb 2026 14:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B62E6B008A; Tue,  3 Feb 2026 14:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 024086B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:23:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81E80596E8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:23:58 +0000 (UTC)
X-FDA: 84404120556.24.9CD28DE
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id E610A180004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:23:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bp8kfByU;
	spf=pass (imf24.hostedemail.com: domain of 3S0uCaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3S0uCaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770146637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=95Pw2DdmywMK3Koth7G2RTcpT3ER5Cfb3Bey9F5Hbow=;
	b=P82hiavk/lX9xJmdntjy3l6pUj7gQz9T6ujNTXHxXXA7G2yHd6r2PavOdrDbNAmAEt6Wxj
	/4yrMumdQ30TBC9PYorIZMZSReaZViznopYoLp6WXn/wktSMwkvwtTrflNJamfUUYVDljo
	A1Y9bX+31+nBHwgD1dCMi17G9nfueJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770146637; a=rsa-sha256;
	cv=none;
	b=m+k/9SwvI1+zuTyQ19CR4peq1t01SmUtCq9Pe42uAfa42M/jWF1BuvLNN8079ugKLOtA09
	MHr6l49PvNmrkrcrQqpjg+fDcUeXhK5N80aOB2FSS7fuZINhMbPHk2TZP7DO6YLNR3L3w4
	cI/2ydyGa10hmL0Gn+yhkwJ06TecHJ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bp8kfByU;
	spf=pass (imf24.hostedemail.com: domain of 3S0uCaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3S0uCaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337cde7e40so3783517a12.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 11:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770146636; x=1770751436; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=95Pw2DdmywMK3Koth7G2RTcpT3ER5Cfb3Bey9F5Hbow=;
        b=bp8kfByUFEDziDZcYOrJTEV0x8qjt0+gvcyEpqj0lwqyir233IY7NgzofuNYPn+5gz
         J4i7xVnPMNoZNjX6MVsEixrvA5J7A7rIgzhy2bwqnL81MOHgAO7nYNGxB2KRqT44UnZp
         O+Q4CzmZKnok/nOAjMf/5am4yox9ZJDiP3jG4FprbZSL1/1jZxMKnh7D3XFjx/hZZYif
         rfI+TYsvyHFX6PcWlvkyplM2xyAO4NQENdSx3uqnHz0YUYMn7duEWfe5+T+5NuGf+HGH
         z4zaZt7NI4Uo5jxw21eNtwyjAAAjNA7rWNfECh8LA9kAr9GO5inBJR0I6ayC32RVKJwg
         BcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770146636; x=1770751436;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=95Pw2DdmywMK3Koth7G2RTcpT3ER5Cfb3Bey9F5Hbow=;
        b=apbm4ccnfMqU2ejcMoK2vzqiOMpO+59YAsMsU0h7EGFkhGTS4WkM9jVTFGuyxBDOD8
         QFrbCb2CS36ekSp/w4uj6ytxVQDTlFqwHjASgQwgGkl9HSIJINukEHKoxyod3RhsTE53
         pEHymEGUvrefNubmD0tpOKHo/0ZTajB99Xk0kwKsj+QSIZP17BX/yrhGcre0bejTxneV
         1n+YA3VIkNyuQzDMgDpsVdKAdjzB47aMGXa/OtzoVZ5sywpmMMmNSxETG42Fa44kPDQO
         VVs5oIMrah9mu1nvQjKW4yquLj9ZE81Y3VOMfsLNewePBJp0QCa/qOrvHobG1GQzEE3n
         eRtg==
X-Forwarded-Encrypted: i=1; AJvYcCWkfqHmt8PIjDUYEeCN9ct7GnienFUx3u9jxrJ9oYi7bVni+1gs50oT7Th+aNYbi9kxpmFk2StB1Q==@kvack.org
X-Gm-Message-State: AOJu0Ywaz5OS/3AYHXwHKsxb81nkCO+s6UcBvOxdE+TVMoQ/qDYFsI4u
	H+zNP3LFjQUFv24Bctidb+ud1xQmMOeOPLp3ztVL8H4K3Q2qZ+kYh/4/DdpuIMU00PeYEXJkMyB
	x/S+s6tp8Q5lcJg==
X-Received: from pgce17.prod.google.com ([2002:a05:6a02:1d1:b0:c66:bca:633d])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d9e:b0:35d:f625:7e87 with SMTP id adf61e73a8af0-393720d0461mr520709637.22.1770146635467;
 Tue, 03 Feb 2026 11:23:55 -0800 (PST)
Date: Tue,  3 Feb 2026 19:23:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203192352.2674184-1-jiaqiyan@google.com>
Subject: [PATCH v3 0/3] memfd-based Userspace MFR Policy for HugeTLB
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E610A180004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: grpb3hinkwmxawnb3ic6i1eujhoqrqhw
X-HE-Tag: 1770146636-327350
X-HE-Meta: U2FsdGVkX19UvXCd05/qi2SAFXeUrNcNn43lVr9Rs2tLXex2isT9BBz1dVGXY0VJG7dLgRg8kNkwbgeA4G5ILmeIfKtHPcIO/ey5gqt/LBAw835nok01NCnQ6xoyQWYqswignhes9WEIgugEO+RJHxStq8NGHnH0RITpE+LtJWk/4oDvp8vPcUYk2vwLGgRoYvwRE+X1q0RIrNSvr3BDFuMrbUvkQ4pCEF9dM/OkA77Y//RzN7TxA8+80zHmVJUP+foieYy3Loe8/OLA65b5tECKYM90Ow26v9C0BEADFPF+hKnv2QWPCdJ979V5B3qd1KlNDarqIfZatnqVIpj5jEuzvK1JHgg3Saee+f7yxxuq9fwx2Cxfd92iQivd/Vg/Ucwzxk7FlBpVT4aaxqmB9uwZkuLm4XjVe8EublI6C2Nf3qim5wVueVza+nrYN7NSJ450aDRk2Elz5cyvgQ825CbCNwkzeSVXkiD4p/jkRyWrh3zvcH2U1qNRSq7rLhDm2UrQjoACzpNk8Gov9LsYx+YvqziqOfRBurmwokoZuQatRp7+6PCqZorxR0rxZYvHHngMk14OKisbvsoFzJKJHBccBX7DYMolRIZ9ipSvTB+IHtPq5OxtfopRfZZMlfn1F1hYivxXcQH01d1jB5u3+fzXojU66ya442KlJbil7ZtPlZJ6M4tSJVUTq7Jul2QtD4PnHiqGExQ/FawqhAxcgXUERFw4SnyKfcPhUEPN6cFhL23ScaPMKo7b0BBm3TnGypLYFMads4+Esucy8W1pXz3XAJq0P51SAO64KYEziNZL3BWHum7StIKk9x2l8BeU401cQujV2J0nj9IO1sHoSt2HK6BAIb0bMC9FJgoNVjkfE6x8vXuWhcx4ayBEY3iBI2wZBY1jvan9fqVmuY96o5aUdSfTU3PwZyuW94lry//m4zRgsnz1N+fgfhdbodMgZQJk68sJUQL1tA9hLhl
 2jgVWAst
 ZX9jC9IymNVgrWSLE4bPCn6MPhzcFH0O1k1E1cveSdiKP8eNpZ+ssARUSqEhpLxCzdiGhSnakSVNrlQpoaBm4w9qHlWHmEU2bt+Uj5qr8/nas159XMqbG2Xo2hEYbdq6dY7Kv2xyOiPlVT0mDhwjaw8cArjHg4LH055iO0SQ/KwHNcUD1jOJpeVDgCu8Viy1ufivI2J+6bREOZaEFOIb/zl1L29P+oGqKy1JMor0wB5mrr7PCkUishrPprefMqJqFoSWj93By452uMSU7iozelqh/R9x6krZ3eums4tnGKtygL4kZvA4NH0OAfErNglMp2zkDpU/H7P8xI+XHUjsmN1HdpPM8Pq0cb9JYwQ8h5OFio3sJTDGZ/vixsn0vGAOqB2VOMJkBkYYypW8rLgC0TwdO4D2NBOTjDI9yhbESUBDNuM3qYT3t915hmA==
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
offline the HWPoison huge folio. In other words, the
HWPoison memory remains accessible via the returned memfd
or the memory mapping created with that memfd. MFR still sends
SIGBUS to the userspace process as required. MFR also still
maintains HWPoison metadata on the hugepage having the UE.

A HWPoison hugepage will be immediately isolated and
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
  for every raw HWPoison page. MFR still sends SIGBUS to the
  consuming thread, but si_addr_lsb will be reduced to PAGE_SHIFT.
* If the memory was not faulted in yet, the fault handler also
  needs to unblock the fault to the HWPoison folio.

Part 2: When an MFD_MF_KEEP_UE_MAPPED enabled memfd is being
released, or when a userspace process truncates a range of
hugepages belonging to an MFD_MF_KEEP_UE_MAPPED enabled memfd:

* When the HugeTLB in-memory file system removes a filemap's
  folios one by one, it asks MFR to deal with HWPoison folios
  on the fly, implemented by filemap_offline_hwpoison_folio().

* MFR drops the refcounts being held for the raw HWPoison
  pages within the folio. Now that the HWPoison folio becomes
  a free HugeTLB folio, MFR dissolves it into a set of raw pages.

Changelog
=========

v3 -> v2 [3]

- Rebase onto [4] to simplify filemap_offline_hwpoison_folio_hugetlb().
  With free_has_hwpoisoned() rejecting HWPoison subpages in a HugeTLB
  folio, there is no need to take_page_off_buddy() after
  dissolve_free_hugetlb_folio().

- Address comments from William Roche <william.roche@oracle.com> and
  Jane Chu <jane.chu@oracle.com>.

- Update size_shift in kill_accessing_process() if MFD_MF_KEEP_UE_MAPPED
  is enabled. Thanks William Roche <william.roche@oracle.com> for providing
  his patch on this.

- Add a new tunable to hugetlb-mfr to control the number of pages within
  the 1st hugepage to MADV_HWPOISON.

v2 -> v1 [2]

- Rebase onto commit 6da43bbeb6918 ("Merge tag 'vfio-v6.18-rc6' of
  https://github.com/awilliam/linux-vfio").

- Remove populate_memfd_hwp_folios() and offline_memfd_hwp_folios() so
  that no memory allocation is needed during releasing HWPoison memfd.

- Insert filemap_offline_hwpoison_folio() into remove_inode_single_folio().
  Now dissolving and offlining HWPoison huge folios is done on the fly.

- Fix the bug pointed out by William Roche <william.roche@oracle.com>:
  call take_page_off_buddy() no matter HWPoison page is buddy page or not.

- Remove update_per_node_mf_stats() when dissolve failed.

- Make hugetlb-mfr allocate 4 1G hugepages to cover new code introduced
  in remove_inode_hugepages().

- Make hugetlb-mfr support testing both 1GB and 2MB HugeTLB hugepages.

- Fix some typos in documentation.

[1] https://lwn.net/Articles/991513
[2] https://lore.kernel.org/lkml/20250118231549.1652825-1-jiaqiyan@google.com
[3] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
[4] https://lore.kernel.org/linux-mm/20260202194125.2191216-1-jiaqiyan@google.com

Jiaqi Yan (3):
  mm: memfd/hugetlb: introduce memfd-based userspace MFR policy
  selftests/mm: test userspace MFR for HugeTLB hugepage
  Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED

 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/mfd_mfr_policy.rst          |  60 +++
 fs/hugetlbfs/inode.c                          |  25 +-
 include/linux/hugetlb.h                       |   7 +
 include/linux/pagemap.h                       |  23 ++
 include/uapi/linux/memfd.h                    |   6 +
 mm/hugetlb.c                                  |   8 +-
 mm/memfd.c                                    |  15 +-
 mm/memory-failure.c                           | 124 +++++-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   3 +
 tools/testing/selftests/mm/hugetlb-mfr.c      | 369 ++++++++++++++++++
 12 files changed, 627 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst
 create mode 100644 tools/testing/selftests/mm/hugetlb-mfr.c

-- 
2.53.0.rc2.204.g2597b5adb4-goog


