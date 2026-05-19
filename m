Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C54CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077386B0088; Tue, 19 May 2026 00:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028016B008C; Tue, 19 May 2026 00:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E803E6B0093; Tue, 19 May 2026 00:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4E276B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:10:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 786AA1C00BD
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:10:14 +0000 (UTC)
X-FDA: 84782841948.27.EC20A42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B560E180005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:10:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bGiwBjeY;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9gBszOXPcQwjwTTiD03Zr3E4br6VznDmwNYE5cbx5aM=;
	b=iR8X/k7rnIuhCSJhsbBNfifJMXNP9m0FUiHb7vafWc+I7sCd+jevrYsPIh6IPwhZK8lKk0
	E27nYDPBBJAZ7ZtBZu435iSQh9+AwcEiKnBUk6uaejJ3TvqEEAqrpJWlzpl+GkOoeXv//K
	LlJtGeTRzDyATu3LKluVlMRb/k8p3G0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163812; a=rsa-sha256;
	cv=none;
	b=NIO+xRZ1qakA1Yqy7t8Pmdm5C9QlwumoyOj0iiocVOX6KOqX4z/V7WXiQ6OTzIVicswiiQ
	hbihcSezJQmWD2TiMC0hiT4YpcDVe24hMvwZCsJaxbTDsKEbiYO+ZW886y6uA772Ar6PSI
	ixA1sUciTDNiHbS53QZ4TXUQJ3hRFt0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bGiwBjeY;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 996F643929;
	Tue, 19 May 2026 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F6C2BCB3;
	Tue, 19 May 2026 04:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779163811;
	bh=jKPUDmc9d1mUFqAQVaoaLRkscbcLeeodQ9MrqHblJxo=;
	h=Date:From:To:Cc:Subject:From;
	b=bGiwBjeYjAAQZt7zdfBbep2p8SpFYaHti0qkxt4p+QbdjUObgOZMLEfHH0CvoYl2x
	 2TNlv2zwXexxFNZsnXPH4UmtNEd5VeKf/vRRhiYl107bIV5yeqIWzn5D/MRsKGAVe4
	 7GTtTewKiau5wCR9MJKjlD7bgIysFAVrJxGIH17o=
Date: Mon, 18 May 2026 21:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc5
Message-Id: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B560E180005
X-Stat-Signature: pxqe7d3nwyj8s7gioq536szxiqx4mn84
X-Rspam-User: 
X-HE-Tag: 1779163812-142559
X-HE-Meta: U2FsdGVkX19o9ZQ7vpjiS57dQyFLv4XfI/oHOpAkFEU6zFNp9C1AubHy708QETHaf/WdbZ0W9yJ1xRwi2GMGmmSBxnfc4Td8ys/SrNQO4uOeZ8inQtgQLutbZThsWJLJz2yzgGsbDueL4TAFQVljC6oMRu/4WMRd8jyUL3LtjfmB28FswcV0e2KWZp0xEPfnlecb+mGpUpC8fzwuopurxADVVjuK+VVUBAE3zU8klsVotKOLHhUNCdWF/bcFyVpKc8Ihe/2XL0mXff0D9BkwYo1xXVF7ZL2tR00hRQtxnN6zM4YrnO0wQFKrcdfK4yBy+mp6HAyeVew/3GT383gutIRQMPTlpOSDmKyUuG4dvJ+vJMPWpBFZhI2xVSKC2QaUt7NMNE6i6vdzKdvHKQzwK/58Z2Eh0I2kAn6m1mQ01plqce9enF8Wng3zoPzZIGWp8uRylch8jMV4CqHElVMm/B1gpgEY4Bz3OteeFt8Zn4zxGIlJUov5Be6wmjTaArgfA5fI7z7pfhQUffGCoKI5TKtyjlA5ON+x6mfGzmlzzT0aIAb+GNGeBAWNuIiGCg2eD9XoZA0PTlu8e6+0GyPkGCHrvUFG6fefRwz4mkEt8OfclpYDPZEoXByiejOZXNL/944g9QOvqw8C2ezo20bUjKgCT7l3UjV01alWxGWmz8JzIyagTBkSJPhoQSHUgwfp3kuwmTiGaPWgZWFesXQ8DfFCkD1Y7tRehJsFztYdQKK5UDqpOsWDbexXGsdG4slcpq0psdYl1JiyL8rV+2RFXDjiPigo97L0lhM49bfPug/Iad6rJCATFP1h89uONj9JYcEqKx7iWTn6q/9KUNlhOvyX3doIMhrWF6QHBQk6X+MncTIVNVE4hrf4nMU7FTl09UyxlLzwnX+6mBZ565TDBbc6wflWhd9nH2yir5CJVfSkvp4OFKYeKyQAXwhTiVBB4bfzgiyroAT5aIXQpGV
 oSsvcWm9
 UOJW+3XPEVQYDRD+IQHgeoY2o8kFmpIhGrKrMweNkwbfmfgds89Fede/UdRxwXXsEvTbt8eKyEQirqI4gPgGus9dbZ3I5iyzHP7FeNJx5Cc5Dv0IKfNXrPOKRZ4PbWMC39hT//FjdoU6ug7CoRq/ho1bkDSrFmvbdGRgegQg3c8gkuhocjk6S9TCaTl6n7Nuxcn9VgqvODxZPJN/eShDtqn55ka/ALAkgrMYNTUxxgtm5BLS9FJceyjGczM3xPll6ZDIVqZaWjxXBFs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07

for you to fetch changes up to be3f38d05cc5a7c3f13e51994c5dd043ab604d28:

  mm/memory: fix spurious warning when unmapping device-private/exclusive pages (2026-05-13 17:40:03 -0700)

----------------------------------------------------------------
14 hotfixes.  9 are for MM.  10 are cc:stable and the remainder are for
post-7.1 issues or aren't deemed suitable for backporting.

There's a 2 patch MAINTAINERS series from Mike Rapoport which updates us
for the new KEXEC/KDUMP/crash/LUO/etc arrangements.  And a 2 patch series
from Muchun Song to fix a couple of memory-hotplug issues.  Otherwise
singletons, please see the changelogs for details.

----------------------------------------------------------------
Alistair Popple (1):
      mm/memory: fix spurious warning when unmapping device-private/exclusive pages

Christian A. Ehrhardt (1):
      lib: kunit_iov_iter: fix test fail on powerpc

David Hildenbrand (Arm) (2):
      mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
      mm: fix __vm_normal_page() to handle missing support for pmd_special()/pud_special()

Illia Ostapyshyn (2):
      scripts/gdb: mm: cast untyped symbols in x86_page_ops
      scripts/gdb: slab: update field names of struct kmem_cache

Luiz Capitulino (1):
      selftests/mm: run_vmtests.sh: fix destructive tests invocation

Mike Rapoport (Microsoft) (2):
      MAINTAINERS: add tree for KDUMP and KEXEC
      MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY

Muchun Song (2):
      mm/memory_hotplug: fix memory block reference leak on remove
      drivers/base/memory: fix memory block reference leak in poison accounting

SeongJae Park (2):
      mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
      mm/damon: fix damos_stat tracepoint format for sz_applied

Sunny Patel (1):
      mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page

 MAINTAINERS                               |  3 ++
 arch/arm64/include/asm/page.h             |  2 +-
 arch/arm64/mm/fault.c                     | 11 ++++---
 drivers/base/memory.c                     |  8 +++--
 include/linux/gfp_types.h                 | 10 +++----
 include/linux/highmem.h                   |  7 +++--
 include/trace/events/damon.h              |  2 +-
 lib/tests/kunit_iov_iter.c                | 10 +++----
 mm/damon/sysfs-schemes.c                  |  1 +
 mm/memory.c                               | 24 ++++++++++++---
 mm/memory_hotplug.c                       |  2 ++
 mm/migrate_device.c                       |  2 +-
 mm/page_alloc.c                           |  8 ++---
 scripts/gdb/linux/mm.py                   |  6 ++--
 scripts/gdb/linux/slab.py                 |  4 +--
 tools/testing/selftests/mm/hmm-tests.c    | 50 +++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |  2 +-
 17 files changed, 116 insertions(+), 36 deletions(-)


