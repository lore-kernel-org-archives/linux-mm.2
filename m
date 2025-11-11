Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4ADACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB488E0011; Mon, 10 Nov 2025 22:32:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABA18E0002; Mon, 10 Nov 2025 22:32:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9288E0011; Mon, 10 Nov 2025 22:32:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8B38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:32:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDFCFB8978
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:32:51 +0000 (UTC)
X-FDA: 84096904542.30.13F8308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3AC911C0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:32:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SeG3sfe2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qekY9DkrV6vQPW/88IbczlrjP8WfGqfrMNqCgcrs38w=;
	b=XyduVZ97rUAEQh0VhG6gRAfJ6rFXP2aQ2tz4tZlhovU+otRjZNBWBbjD8ntB6nGShQv1om
	mlgulmGUBjxmRM7YaNhwExjCQAoitNroKFkrQ4SkvIklZToRCL4n6Zw4fa5jlDDMfIa0tS
	jRZdTYAYwegim9Tz43WmG6wWp4iRV98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831970; a=rsa-sha256;
	cv=none;
	b=yZbJ737PAN54gNjJ9k5LBJrKVZ79E6aKgFaUInyofs5u+L6daQLRYacdTmW+wJ6fwnR57l
	FgwcOx9+9vK1a/yKT4IMufRkgsu6KT6Eme2odtT9HwBCuRvVb3OU2O258QiGUb+yxtZvM0
	r1KJIcbAcX8nXvc6Knk496hWBqkSLes=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SeG3sfe2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C82DC4416B;
	Tue, 11 Nov 2025 03:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D0C16AAE;
	Tue, 11 Nov 2025 03:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762831968;
	bh=LKFIiVEm2jCQZUOC18eb6X046/5tk4c9dtMUB9mF9Ls=;
	h=Date:From:To:Cc:Subject:From;
	b=SeG3sfe2DH3jhwil5eCv5W1yEK1utNf2CywgT7n+h0R0RZbPrAjDUXMO/vMGGgvoK
	 fA0VHZ+1nkLvR6DcaWVZkLXOcOz/zgZa0d5iHi9wQ00/7+5gPelLIJOPw6FhGjXH5J
	 Uh6Be8m9W6raK3sYxcT45WV2l1y1soOYfX90gi2I=
Date: Mon, 10 Nov 2025 19:32:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.18-rc6
Message-Id: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3uf8ogwegcz1k8mk51hgroqjmqyfqopi
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AC911C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762831969-463742
X-HE-Meta: U2FsdGVkX1/ud5HAePS3NELFDgVb0lTKZR+9wtfhQLx9K2PY6z3sKZ+inwt6nVHwG1Ib8ie3iRXHwONmUl00tMMlkwMD3hqR0VM0eiwQWJehmVL/VPgrqgG5/qFXlrLMPG/Q6cClcKLubq6azorri/Gff079+YVYa1girzILMnJiHqQPqH4diWoBOWq4m40ghCvf6enH7vKJYej1wYvtuk+LYCvEKSBkNDKq/Fdjp4iFUMAz82i7Z2Hpvf4Hh7+gB7lhGFFEJEIshysRCRKHarQ5iZT4sF5MQOPI2TsKJAuyK/xCxvZ7CRx9+1MPYc6J9nhA4VtPlWEI4XDJr7JsFiC4hIHHnvVbO0uafaT0GrSJL54eUBl5PE48kdU+FQ4YCoUELWRVjvWMJpvZgU6eSDBCaP53Mv57MtHost6s3EE1muNXG5Xw33a/JLZQcX3MLtqsps1HwfIOr02xnR+u3E95SlxXrG9EKVJN/ow4MD3u8iNe0J73IV1tLnGdufIeEiE+f+Hp9zFEpzB2MpKWv5J/lTtbEFHPNxao+ZWsgqt4ZoP+e0BaR8aMkH9w/yEnvyq19Y2NSar/7Ad25Nlc6duc+I3sHW5nS27MViE2aer/2mtGSaLrxvhgNO/hCGnDcRFXi9fns06Y+jehf0+zadwlib/6YMZsZFCA1tyRf7cNgmr/4foXFpTdtonQ67nHNgYS3uBbDTgiMis2fah+J54L2D10hQbRLn8R24PaNaK7NZ6znDgqir+ewnf6s+EBGoe3w0xGd9xz71qQ4Lk7Xi7D5CPqq0SRbjLRkgtKfrza9wNK36hpZaf2XJcunR+KNqsqDIacvrwPHGlwkCXAg47/YZRoVPJ3eN2uFLEvcpEQvEVwdigaiN6E8pY21feBinWG+ApsyZZSAQ4+azc7WcgzPCLA85xzEpCCvhv63y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30

for you to fetch changes up to b05addf6f0596edb1f82ab4059438c7ef2d2686d:

  kho: warn and exit when unpreserved page wasn't preserved (2025-11-09 21:19:47 -0800)

----------------------------------------------------------------
26 hotfixes.  22(!) are cc:stable, 22 are MM.

- a three patch series from Pasha Tatashin which addresses some Kexec
  Handover issues

- a two patch series from Kiryl Shutsemau which fixes handling of large
  folios which are mapped outside i_size

- a two patch series from Quanmin Yan which fixes some DAMON time issues
  on 32-bit machines

Plus the usual shower of singletome.

----------------------------------------------------------------
Aleksei Nikiforov (1):
      mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet

Carlos Llamas (1):
      scripts/decode_stacktrace.sh: fix build ID and PC source parsing

Catalin Marinas (1):
      mm/huge_memory: initialise the tags of the huge zero folio

Chris Li (1):
      MAINTAINERS: add Chris and Kairui as the swap maintainer

Dev Jain (1):
      mm/mremap: honour writable bit in mremap pte batching

Edward Adam Davis (1):
      nilfs2: avoid having an active sc_timer before freeing sci

Hao Ge (1):
      codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext

Isaac J. Manjarres (1):
      mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Kairui Song (1):
      mm/shmem: fix THP allocation and fallback loop

Kiryl Shutsemau (2):
      mm/memory: do not populate page table entries beyond i_size
      mm/truncate: unmap large folio on split failure

Lance Yang (1):
      mm/secretmem: fix use-after-free race in fault handler

Martin Kaiser (1):
      maple_tree: fix tracepoint string pointers

Pasha Tatashin (3):
      kho: warn and fail on metadata or preserved memory in scratch area
      kho: increase metadata bitmap size to PAGE_SIZE
      kho: allocate metadata directly from the buddy allocator

Pedro Demarchi Gomes (1):
      ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

Peter Oberparleiter (1):
      gcov: add support for GCC 15

Pratyush Yadav (3):
      kho: fix out-of-bounds access of vmalloc chunk
      kho: fix unpreservation of higher-order vmalloc preservations
      kho: warn and exit when unpreserved page wasn't preserved

Quanmin Yan (2):
      mm/damon/stat: change last_refresh_jiffies to a global variable
      mm/damon/sysfs: change next_update_jiffies to a global variable

Wei Yang (1):
      fs/proc: fix uaf in proc_readdir_de()

Zi Yan (2):
      mm/huge_memory: do not change split_huge_page*() target order silently
      mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order

 MAINTAINERS                      |   4 +-
 arch/arm64/kernel/mte.c          |   3 +-
 arch/arm64/mm/fault.c            |  10 ++++
 fs/nilfs2/segment.c              |   7 ++-
 fs/proc/generic.c                |  12 +++--
 include/linux/gfp.h              |   3 ++
 include/linux/huge_mm.h          |  55 ++++++++-----------
 kernel/Kconfig.kexec             |   9 ++++
 kernel/Makefile                  |   1 +
 kernel/gcov/gcc_4_7.c            |   4 +-
 kernel/kexec_handover.c          |  95 +++++++++++++++++++-------------
 kernel/kexec_handover_debug.c    |  25 +++++++++
 kernel/kexec_handover_internal.h |  20 +++++++
 lib/maple_tree.c                 |  30 ++++++-----
 mm/damon/stat.c                  |   9 ++--
 mm/damon/sysfs.c                 |  10 ++--
 mm/filemap.c                     |  28 +++++++---
 mm/huge_memory.c                 |  35 +++++++-----
 mm/kmsan/core.c                  |   3 --
 mm/kmsan/hooks.c                 |   6 ++-
 mm/kmsan/shadow.c                |   2 +-
 mm/ksm.c                         | 113 +++++++++++++++++++++++++++++++++++----
 mm/memory.c                      |  20 ++++++-
 mm/mm_init.c                     |   2 +-
 mm/mremap.c                      |   2 +-
 mm/secretmem.c                   |   2 +-
 mm/shmem.c                       |   9 ++--
 mm/slub.c                        |   6 ++-
 mm/truncate.c                    |  37 ++++++++++---
 scripts/decode_stacktrace.sh     |  14 ++---
 30 files changed, 424 insertions(+), 152 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h


