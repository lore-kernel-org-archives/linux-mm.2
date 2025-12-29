Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B734AD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7526B00A1; Mon, 29 Dec 2025 00:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288756B00A2; Mon, 29 Dec 2025 00:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153356B00A3; Mon, 29 Dec 2025 00:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3BE46B00A1
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1EEDC3563
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:47 +0000 (UTC)
X-FDA: 84271439574.07.5E69A31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3027D160004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sn2tvNPJ;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j0jd1cBLkGi6iww+RLrfDA4cviJE8BMPue7dlfne20s=;
	b=S6DDvonEhtuncr3JugJYuvgJVCcR653SNik+2xUtkxv6oRdfKBQK6n50khuRZgHQ8+ONsi
	z+KOKvtvseu22pQ27BHPF6g0v0jG9EbSdj6sKGFWM9a8lK2LLkSHRzl5AodB/NFyA9eKkC
	fAEidr2C7KKarPJMfCpO8agNbYMf/No=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sn2tvNPJ;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987566; a=rsa-sha256;
	cv=none;
	b=vLGQOkp9QiSewRri513l6fL8ne6Hp+jRes1fGmlThJFk4NUm00r4cvGGppJ3FOsW2D61Pf
	KyXW2C2+Cut0ovAPljDzDgHjGolwNbX5sUg9FjjdElfFyh42Q+1PZll05Y4J81B1I2b0Qs
	3ujvP4vhWu7toqPqg0kpgRTH7UIt2NQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 712C16000A;
	Mon, 29 Dec 2025 05:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09064C4CEF7;
	Mon, 29 Dec 2025 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766987565;
	bh=IP8O/3R0xQrKZ7hzXFyKNUrmFs/ElScw+GMdLuR2NLc=;
	h=Date:From:To:Cc:Subject:From;
	b=sn2tvNPJ8FUY96at4KCMkSusHjrdWHZxmSzppGJOCyPGa7Av9eu1JQcjg5GBQrxDz
	 Sin8enhNTm3oPVCgahN9IzMWOg7P4TcvfW9L3Hpo6pcG+y5vZwIpGyNSeJc3jkpOrC
	 famVX/C8LfKAKSZ4x2PXEJswuXX70f6LzjWfNSqM=
Date: Sun, 28 Dec 2025 21:52:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc4
Message-Id: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3027D160004
X-Stat-Signature: ifssynk4i8wpzeiakx8j9ey3tbuyg5sh
X-Rspam-User: 
X-HE-Tag: 1766987566-134643
X-HE-Meta: U2FsdGVkX1+jjDQNK8ojXNdQao9FlS/fp28ZgyBSGqpr4JuEsHFjjkxRqxDViV/EhFQiCOGKJcjyaiXZx5n9eHsefhVrpj3uufCzv7xyW4P33MNdEKyXlKWGc4Cxusb0f8Z4yQk7AhHROEyAmssP3o2nELxPnsAFffOj+Jxt9kZWSIpU//sxSA7RkdZG+A6M3NE9wOyQ73/I9rul76vPn3+W7SE6jeh0PjbLGRo/2s1iiQb+6MF482bwipK6SsklZHb6E1o7/o5KMA16rNmHQi/LWuyBr3Ld+pa9ACv3NiRtZhKXNZzZ+Xkl3ls6o0htBgFHsl1SpGil7I8s0Zfi4qAGhGZDgPU3adCBQ23c5LUZLQuVqcRO9EFBtaRilWZqoWilu20hvdNXkvnzYS1dsKSPsJTwWM+VZY7zCWRjLZ4QzlIM+sxSfcGzyoAInoN2YTT/o/fIPDZgSkVcKWmM2CFYMLMmJLK19khjrRLh8nhT0z2WnqMjMV/sTnF4CC6Kysg9fbbEpM+PJJmKYD69ShLYRFMCGG2YnNlLKC4pze6fNigpIq7PnDjtyYvWYlNYtZql4uOx2bR4WKr5v0Fk2Dl1O4DFzhFQMHUZImOHp5HUSsbfG4GUTTQwZG7vBiUK6/hiSq7x1+T5rAmW6670OOQF94JSjh9rGOIZe92Vv1nl1mgCG33cLU0Cr3NKxq5Qey/BwvC5/N5TH6Bvv0yzxPcBT31yjPRvU6eDSfXXycnQJrN5n6Ji+G8jBb3oO0cBroujHH+yMErL3v9StSkHwqmPOwJzKzdMpY88RokQR8v/7VyAeYL4atk+94TFvK3Nhpr0sGsFTnvXk9z2sb9fwx8MYhyV43tyPpYp4I6P/2cWgDeVprYiNNPRHLZMgYAXVZ9zK9kzUM+LDm56MNJT5A0D9JjvEGHWIJOzjON5boVcSu5r3RJL9nQ776SyAylWMGrJWUN1v1WUmysVRNe
 YUo7twsX
 MO2R0z3vVcXjkR8BeWx/xaSZvEKb7WYJ6hXa2GHRR+Cij4Hq3yWyfCBjR45RpQ/VBR0/HWJaC4bTQrE8Gi3We+27Xkz2X+ZIVOOJS72do1IrH2LPr4HlfE96I1t5lZsRbB4UG5Tx6AnSkZglOKSHD0uzeSRq7z4CRqtYpYe/g1vqW09o5stH9S1aIlZJC5OMV/pQOEDBBEMajZWq9wOJSR9tfb4Sm78XreI9bWqR+L4my3GauW0/2TdM5Cv68NU300psiDTpUlHFQ+ZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50

for you to fetch changes up to d6b5a8d6f142ad0a8e45181f06e70b4746c4abc3:

  mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry (2025-12-23 11:23:17 -0800)

----------------------------------------------------------------
27 hotfixes.  12 are cc:stable, 18 are MM.

There's a three patch series from Jiayuan Chen which fixes some issues
with KASAN and vmalloc.  Apart from that it's the usual shower of
singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Akinobu Mita (1):
      mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()

Alexander Gordeev (1):
      mm/page_alloc: change all pageblocks migrate type on coalescing

Alice Ryhl (1):
      rust: maple_tree: rcu_read_lock() in destructor to silence lockdep

Andrew Morton (1):
      genalloc.h: fix htmldocs warning

Ankit Agrawal (1):
      mm: fixup pfnmap memory failure handling to use pgoff

Bartosz Golaszewski (2):
      mailmap: update entry for Bartosz Golaszewski
      MAINTAINERS: update one straggling entry for Bartosz Golaszewski

Bijan Tabatabai (1):
      mm: consider non-anon swap cache folios in folio_expected_ref_count()

Dan Williams (1):
      MAINTAINERS: notify the "Device Memory" community of memory hotplug changes

Jiayuan Chen (1):
      mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN

John Groves (1):
      mm/memremap: fix spurious large folio warning for FS-DAX

Joshua Hahn (1):
      mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU

Kaushlendra Kumar (1):
      tools/mm/page_owner_sort: fix timestamp comparison for stable sorting

Maciej Wieczor-Retman (2):
      kasan: refactor pcpu kasan vmalloc unpoison
      kasan: unpoison vms[area] addresses with a common tag

Matthew Wilcox (Oracle) (1):
      idr: fix idr_alloc() returning an ID out of range

Mike Rapoport (Microsoft) (1):
      MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd

Pingfan Liu (2):
      kernel/kexec: change the prototype of kimage_map_segment()
      kernel/kexec: fix IMA when allocation happens in CMA area

Pratyush Yadav (1):
      MAINTAINERS: add ABI headers to KHO and LIVE UPDATE

Ran Xiaokai (1):
      mm/page_owner: fix memory leak in page_owner_stack_fops->release()

Randy Dunlap (2):
      mm: leafops.h: correct kernel-doc function param. names
      sparse: update MAINTAINERS info

Sasha Levin (1):
      mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry

Shakeel Butt (1):
      mm: memcg: fix unit conversion for K() macro in OOM log

Wake Liu (1):
      selftests/mm: fix thread state check in uffd-unit-tests

WangYuli (1):
      .mailmap: remove one of the entries for WangYuli

 .mailmap                                     |  4 ++--
 MAINTAINERS                                  |  8 +++++--
 include/linux/genalloc.h                     |  1 +
 include/linux/kasan.h                        | 16 ++++++++++++++
 include/linux/kexec.h                        |  4 ++--
 include/linux/leafops.h                      |  4 ++--
 include/linux/memory-failure.h               |  2 ++
 include/linux/mm.h                           |  8 +++----
 kernel/kexec_core.c                          | 16 ++++++++++----
 lib/idr.c                                    |  2 ++
 mm/damon/vaddr.c                             |  2 +-
 mm/kasan/common.c                            | 32 ++++++++++++++++++++++++++++
 mm/kasan/hw_tags.c                           |  2 +-
 mm/kasan/shadow.c                            |  4 +++-
 mm/ksm.c                                     |  2 +-
 mm/memcontrol.c                              |  4 ++--
 mm/memory-failure.c                          | 29 +++++++++++++++----------
 mm/memremap.c                                |  2 --
 mm/page_alloc.c                              | 26 +++++++++++-----------
 mm/page_owner.c                              |  2 +-
 mm/vmalloc.c                                 |  8 +++----
 rust/kernel/maple_tree.rs                    | 11 +++++++++-
 security/integrity/ima/ima_kexec.c           |  4 +---
 tools/mm/page_owner_sort.c                   |  6 +++++-
 tools/testing/radix-tree/idr-test.c          | 21 ++++++++++++++++++
 tools/testing/selftests/mm/uffd-unit-tests.c |  2 +-
 26 files changed, 163 insertions(+), 59 deletions(-)


