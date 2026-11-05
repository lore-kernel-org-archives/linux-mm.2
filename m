Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C2E606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=lWOC+ru8
Received: by kanga.kvack.org (Postfix)
	id 97F4E6B05B0; Thu,  5 Nov 2026 12:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956EF6B05CC; Thu,  5 Nov 2026 12:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EBE6B05CD; Thu,  5 Nov 2026 12:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D71B6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD4CB160B67
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:12 +0000 (UTC)
X-FDA: 85401680784.05.50F8376
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1B7B18000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=lWOC+ru8;
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=imn662agbdX5zP5xBLIUgWlwgaext2h6zc6JhEY5gWY=;
	b=5PnqL1YD6gvdzmgcguUqO5zBSm9GWgE6R0G+tnEcQ0f9UxZtnqZ7gJpcvwm0H257ar0Cmw
	hCGXBJiVFpbIU7E+4fk/KtCZE+BzseXOqXpk+035+OmS29X+sG11lXyYCJFD4oLMNB/h36
	VxxTZZUrILA1f/igI8zfhI8IEZel+AQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898070;
	b=oy4j2KWNV7Y33kBC72riN1zkwwfEqAAS8PY5DqvQe6OfBP6DebHuyH1dKDYGWYVUbrWHBm
	csdc6LJfWZej8dtnuvQg8PiZmQQbFVZxm6Q9IQNLfSGyOoMHSjiUEXZw7vmfAjib4iVQh6
	wTeozJNL4fuGZ0F9Un1wK5ZM5wxTCEE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=lWOC+ru8;
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=imn662agbdX5zP5xBLIUgWlwgaext2h6zc6JhEY5gWY=; b=lWOC+ru8GzAs4Oeudsz
	C/hktTnNK4iW1AiktlGT4mPASk69DX1djvErs/V4C+AjCGcJQvNuQHPpYGbvs1pbzLzE8Lt0spjrJ
	Ar5tiI42W2PxRQIr7pgJbobKxB8m1jGtceCk2KxoAXA0ziCNFRgEi+jmaNNrm/rXn115XLMj2uOkl
	AOKWkoGDUgzxlL1aUc6yYlNpt3tMhzYapthmCXioRAg8qqQ9LpEWTKVqeUJXdHOj7KBxzNkk2ipGy
	mPTRvH/KcJz8PSccRVu+WvbM/hyrGTwclutvLzerbQg2vDECIsQdJZPCvFiSx6zvou1n1wJFbclCi
	ZMqHkpDXCJs37/Q==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xP0li-005CiT-0E;
	Thu, 05 Nov 2026 18:00:58 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] mm/huge_memory: take a reference on a device DAX
 PUD copied by fork
Date: Thu, 05 Nov 2026 18:00:54 +0100
Message-Id: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEa27GoC/52OQQ6CMBREr2K69pu2ChZX3sMQAuUDNconLW0Ew
 t2leAOXLzOZNwtzaA06djsszGIwzlC/gTwemO7KvkUw9cZMcpkKLgUEN5IFkXBxOYOmYSo632I
 x+BoaehkCi40m34+ApUwzTFMlr5xte8OWmM/ueuQ/dr56oh6jIDY6E8en/UwQsfePNwjgoKpaq
 SQRTVbhPRg7eppnOml6s3xd1y//lHuB+AAAAA==
X-Change-ID: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3904;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=hqQriZN4cRnxi6WxgUqzU1/jjFn9IHmUhJ5AFoUsixc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7LZLdsf/zRRI4qD3Olsg7Qy3mRGp8u4UGzafb
 xnv0bqOryGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauy2SwAKCRBRlgpH+WFc
 KmIEEAC3HeGbT/5CXaKDpF9nFXNwlWDV0OSm7UtzheK5642SvASEByaFcqWTFtUCT0V+q+ldtdb
 MPKMsqSm/m+O73Y+zdNrKG14t4qWmK6FUPSKJT0qqRegz88xdOJD7RIFORpT7LxYCsTsZIWpcxl
 V8hwMEI82rNY9tGEM6vSYfKRAWshb9vMd00vU60Gcn6HCF9AcISvbnQfCHF7qntlFT1o1+kvSSS
 cfAsvJslcehDJ3ZfuoSwTB1N33L2uI2D2ZR9FufknEOx5v/cK6g98PxrShIAPWXPhBABJHZL4Iw
 BjB6U9V3VuQG2ZG9bl8LGgP6V3qd2/Ka6XYr+hA4lvPrhgiGJIwaq0yuVWXx+dwCcqmWPPQJSqk
 2bxwvsivb9k9A+Y5DCJIIrH6zGXuMxYVHQscBI9VTquNQrKYrz1BWfHrP6qTWHI0u/WoR7oLrWk
 Pu/EPVGbn75OjNVHw8U91HDlPMRskwRkvlcBvxa1VUUyeTAfsTbxotHfq3UWMFjzIic24G0ul71
 gQh+YQV5pGp8xsU3+zUOU8GuHUoMAM+UtcMKND07e6+Qobrj+5ME6fjsSRVDlbbOLIj9dcTNye9
 oSeiHQbmq3uxYtXmNumJgCgWh0ZKb7Ld3s9fdz1ju2K9BtaMuMje7o9fr+TPRABW1nkcSTCSBXK
 IL76YdHSFA3Y4Fw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6fgj1rrhedp9hac4xb5ifmh6gs1rhbip
X-Rspamd-Queue-Id: C1B7B18000A
X-Rspam-User: 
X-HE-Tag: 1793898070-166021
X-HE-Meta: U2FsdGVkX18JnKSq/ton4VRc9vtcxpILnjo8o9LF7HO0wpZCQ1y1vWRHKquywLnKjJtKnHJxgNXz5zf8bFZ/q38whHmj8jeUi0VCPGqTP8WqYeVwN8Vb95T42HMeW2e+9LgzwjVpT6HUhBsiau3HrqUueM9W4eXJ8baELhYutXzLmm/P0ayvdSWNx0c8zAcNtFpiA6ycmMSrEeh84G4mTpwj1c9XiagUVK7AT4UYo4jjrJ0izBwpu2v+HS8ShbEpWWpKvy/8pje1WWuwRHKQqZ8GgLz73oYsbbzdnGhEwfQ60MBBfp4KVSfem0wTXyyRKu6v7+rm8/E8XmHFnSwoOfTCgC//ECgjWaWKmsUgTJ5XEVjgRIbAcDlR8hJ3JdGpc46kJIqB12fr2Vq76CqcGTtWX6tqHF7aJBRFbbrsYrx2tMSXyPUgZbpGFlenofxjL5V+8vIB21aNZAFFg+A2v1UY238Tl+AuAm26Qu8W5GpdWX2CH+fDkSIU/gJdNjEstfzgMBeJGtrja+SSYD8zcFI6EB490t20puPhqPmn5WYxwLuEy5Td+ymxqTaV8ZGjsClO5HCg3Q6qaXwvaVQxWIPnf/TllMprjVrqwBEeXYNevbcDsZwfCngD6eYS1a8MldBuSZ8B4GZt0OBm4BdlxbukC3elgep9FYy8+VMg0Ac9dkvuJqn413T84opKeAZ4kui/XIb1pUG4kkpSGnGVb+rokWF8ghDkZhrb+NFTcBzpTD7u/L2PJf2fISfmNp9ZkV1K1T3/lqyvgtpCkkvCOGPvnQmjk7soZC3AY8OL3GLDdL8WGNYy89BaiJegO/WGk6Q52/TgqiXK3nmqJDX+QWBQZx/M8pDE0urU6R0SG0dxrUMs6lCk3ic0cOpYBNlUlTBkFbxYhBfGPZXUjW2PTLAEmp+v6jVZV8VjWUNCQICGUeRQZ8Ze9nEzOCtKJtkTsh7SuWuCqPkVQ/Z71UR
 KYEVMwA6
 p9jf6Jj3a3G3Q3KU873fh8wRuA8nSTo3ZREJy5gY5PlMCd+p+C0wm8YStWZoWnCR3/7FO5W6j4wjjM9R0pUMjNAg/gDisdEZiSSMA+LyH3cm0Jaxd5TjuqTMPXuxZnK6YYlj9JerKMU2yA4qkCmunAMcIR5/7SAizG9Nl+DSBMViGXgSFT7eF+XcS3pocqTWLetadJL9/Obo9Vy6sUIwIUPShFFiqZKaR8PqOJ2P1k0lcIvl9QEjogDx9dAJjRli152z1Fzfi5pCrNc7903r36XjLO3tEwwMwgL5aSMM4l08CavaAXQ/3Dhfr5O8IamWwY6/AA1LLZxjF9fq/WwVCp6M/fZZ1j9ewfo6tQ05KX2+H1yFWLv/a6YwrtQX0hoh18CJ+XTIPQZqQkQM+vk64SWFGB8uZFcaPVj3blkWUtLbsj6VK4nutJ4ea9z/fymd9lujj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pud() copies a device DAX PUD into the child without the
reference, rmap and counter that vmf_insert_folio_pud() took, so the
child's unmap takes them from the parent. fork copies a device DAX VMA
once it has a guard region, so it takes no more than:

1. map a devdax instance with 1 GiB alignment and fault in a PUD;
2. MADV_GUARD_INSTALL a page elsewhere in the VMA;
3. fork, and let the child exit.

Patch 1 is the fix, patch 2 a selftest for it. I found it while
reworking copy_huge_pmd() for fork after David's review [1]; it is
independent of that series.

v2 is based on mm-hotfixes-unstable, as patch 1 is a fix for stable.

Testing
=======

 * mm-hotfixes-unstable x86_64 KVM guest with CONFIG_DEBUG_VM
 * pmem from memmap=3G!4G
 * devdax made with "ndctl create-namespace -m devdax -a 1G":

  +----------------------+--------------+------------------------------+
  | kernel               | fork_dax_pud | log                          |
  +----------------------+--------------+------------------------------+
  | mm-hotfixes-unstable | not ok       | BUG: Bad rss-counter state   |
  |                      |              | mm:... type:MM_FILEPAGES     |
  |                      |              | val:-262144                  |
  +----------------------+--------------+------------------------------+
  | + this series        | ok           | clean                        |
  +----------------------+--------------+------------------------------+

A variant that writes to the device and forks three times also hit,
on mm-hotfixes-unstable:

  WARNING: ./include/linux/rmap.h:159 at
  __folio_large_mapcount_sanity_checks+0x90/0x150

With the series it is clean, and the guard-regions selftest passes.

The selftest only runs on a device given in FORK_DAX_PUD_DEVICE or
argv[1], as on an unfixed kernel it leaves that device's folio with a
mapcount below zero. On pmem emulated in RAM, with
CONFIG_X86_PMEM_LEGACY and CONFIG_DEV_DAX_PMEM:

  boot with memmap=3G!4G
  ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
  FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud

[1] https://lore.kernel.org/linux-mm/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com/

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
Changes in v2:
- Patch 1: copy_huge_pud() takes only the VMAs, and the TODO moves next
  to the rmap duplication, as in David's fix for the same bug:
  https://lore.kernel.org/all/26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org/
- Patch 2: read_sysfs() and a new rss_file() in vm_util instead of local
  helpers (Sashiko).
- Assisted-by moved from the patches to this cover letter.
- Rebased onto mm-hotfixes-unstable.
- Link to v1: https://patch.msgid.link/20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/huge_memory: take a reference on a folio PUD copied by fork
      selftests/mm: test fork of a device DAX PUD

 MAINTAINERS                               |   1 +
 include/linux/huge_mm.h                   |   5 +-
 include/linux/rmap.h                      |  22 ++++++
 mm/huge_memory.c                          |  27 ++++---
 mm/memory.c                               |   4 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 114 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 tools/testing/selftests/mm/vm_util.c      |  21 ++++++
 tools/testing/selftests/mm/vm_util.h      |   1 +
 10 files changed, 183 insertions(+), 14 deletions(-)
---
base-commit: af05d765a4476d2e48099148c80f9b13f462e309
change-id: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


