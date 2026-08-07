Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD99EC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 01:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB5E6B007B; Thu,  6 Aug 2026 21:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C326B0088; Thu,  6 Aug 2026 21:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B2C6B008A; Thu,  6 Aug 2026 21:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3148E6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:47:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82D3A4030F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:46:59 +0000 (UTC)
X-FDA: 85072784958.12.F7FBE4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C677A80008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:46:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSdJXIlN;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786067218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nU96lq1f0kDCoNVyF2FTgpj4D/KM7NZNlYwGJegVXyg=;
	b=PKz5zGKrjwufOGeycrb9argYu1TzQDiQB901vJyPrCw2Kph3mn7EVhiG7Q4nhxI6jzDmvA
	oOzthDLWDuMtkcxNbVLv0iFWxf84lMPFO+RHLXONZdOHhUJSlvbiciFE/vKALKJv5x/+sF
	VRmOUgYRxDPiC0OMNG4Qlh7Ku8XRkaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786067218;
	b=27FIV7fQ0Uug761uBe2UQLvDcXPV1rhY4RO/BfHwEWgN1oiNWDDtqlENOuWOyP/YsNI9nn
	9HjWahJWCIcUXyLipyRHhuU8baEaNpXF3z9IW8HMyAmrDYFE86aZ34gyXwsa0rLTazdFDV
	l1+VUSDPMZ3RgVVbe/7n8rV57E4Aibc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSdJXIlN;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 299256004E;
	Fri,  7 Aug 2026 01:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2021F000E9;
	Fri,  7 Aug 2026 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786067216;
	bh=nU96lq1f0kDCoNVyF2FTgpj4D/KM7NZNlYwGJegVXyg=;
	h=Date:From:To:Cc:Subject;
	b=ZSdJXIlNawxFYLQLTsxSUzdaFo4X+voxe4vLGHUs27DDyYJvmVVrAQd8YbA82RR6C
	 fJRFIJ5eMmYeTKxXCl+oAc8gp8dJQ+fPKA61p55573vHURRkZjN7ne6eCzzVOG7YaQ
	 bk5fK2XMk0aLbekL45+sem/DLWWdjvJc3hEt6tCg=
Date: Thu, 6 Aug 2026 18:46:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc7
Message-Id: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C677A80008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ess8guhsog3anicncbj5kniamoptdfkr
X-HE-Tag: 1786067217-573452
X-HE-Meta: U2FsdGVkX19kJ8zpc37GlmEE187P6JQSC9BHr+lHDGwjlTWhTZexxsrAXTy/TmzcKapiEYHNJeOSwUnuaCgy5xtyKEmwFsCJiPE2Xm8nXl0ABJ8dNdyohs5bzbyB26uGkpuF5GGWupKgWvVvH/g3YhP0UDYwpVytwV+AfPH7M3yzFoSJCaOj38Mi0BU13t8py3zess/twpdY7DaQit02Tglx2YcdQBnq008h2Pv5VVpa03zre9pMf2YObxqnDylD1TY8ntbsCDhKDRUVLN7z2SYQ9OW9JeE8JxjQduH/HF4TtjeYIImqw75wGJjzQneYHopD1+kjcngcdurQ4vuU9L74bMUzq71jr7tavKtH8Am/bqP4MvwVNiXCi1qGFaySHmzFKOi2D8tGNCAzUZjFJXg7qMNsqKxeJH+j9znk+LtBU97tF/KYXrwo4YYlEpmgEcAW479Q3MJGeB7NVKurm/TOaA4cM4+ArwpdIj83EdVFjLdVyT1TwONxSIZHv3Gg43oakgs96E//pJ9piVFpyIaJNgRbmfcRyLpc/w4BTGemJQDRQu81DW2lWBCfQJgReb6f1lV29yhtW++G3zjlM3xejfMkSzbh+Hutw/5i7TgVsN2vMUdiyaoJ+rCSBhv4yWke3/gW2ug6j7PGj7uuTNPrnDddTyDyXfUSRgh8YH3jM1pyIzgksWaTuZzDosxAs/iVj8fCdiXSyzI47RUYse62uYifNP2il3adqdH9czMmc2vxMQ3NFeJArJl6Ce7xyj78AFsqSPwVwah551uCQtC3Zr5ALvhJ13McOoXqSegC8mwflF+3Ut6P75Labu+7XjsiqPDVkLVJuFyNSTVRrgrFb5oIYVtIEDzaGWtxc6vqC7pzXYuHLw+xHlGI6pB8sTWtBZ05BHMuUX22AHqJiTAnwB0ZS2WwObfpqwTpJJIyvNgUXetpyphHXS1Y3Yt8HabCBDv1/Iorm5KhsYu
 HL5DmV7b
 mMKSX+xavkqA9iF5FJAP7E/l2aMpNMIaNHw9HRhvzkoDlv7f6eIcT/1nCnblW5PR1XxSasaq3X9QMLMbzRAdJgXLps6BGrmtBI3gjndlMUUx6KIuVejE2OWUZvM0OxR5ysVIZGCZ29eCDTeriAISlqdyYaLdkOKCh/BvP1/0fJ3aN0YAp49TKxq8RqOlIoNkPjmmEs1gKhpqkj3VXq71y2enqvnfES5WqlwPTkhgJRPJGAA6rfSOwMQUUHK+W5fJPTu52ireKP9Jb1P5k9TlbSQ4TfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 9f1d75a4ce04095afdb63d8e540092ff8151dacf:

  selftests/mm: fix potential wild pointer access of getline due to missing init (2026-07-28 17:37:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44

for you to fetch changes up to 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63:

  mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD} (2026-08-04 20:02:04 -0700)

----------------------------------------------------------------
17 hotfixes.  15 are cc:stable.  16 are for MM.

There's a 3 patch series from Lorenzo "mm: fix UAF caused by race between
ptdump and vmap pgtable freeing" which addresses a quite old bug in the
ptdump code.

And a 2 patch series also from Lorenzo which fixes a four year old bug in
the huge_zero_folio handling.

A 3 patch series from SJ fixes a few possible divide-by-zero issues which
Sashiko sniffed out.  And a 2 patch series which fixes handling of the
commit_inputs parameters.

The remainder are singletons, please see their changelogs for details.

----------------------------------------------------------------
Brendan Jackman (1):
      MAINTAINERS: update address for Brendan Jackman

Danila Tikhonov (1):
      mailmap: map old addresses to Danila Tikhonov

Hugh Dickins (1):
      mm/filemap: __filemap_add_folio() restore index before retrying

Lorenzo Stoakes (ARM) (5):
      mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
      mm/ptdump: always stabilise against page table freeing using init_mm
      arm64: remove redundant concurrent ptdump UAF mitigation
      mm/huge_memory: fix huge_zero_pfn race
      mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic

Matt Fleming (1):
      mm/huge_memory: initialise workingset state before folio split

Ramin Moussavi (1):
      microblaze: restore the page alignment of swapper_pg_dir

SJ Park (5):
      samples/damon/mtier: error out for zero quota goal target values
      mm/damon/lru_sort: error out for >10000 active_mem_bp
      mm/damon/reclaim: skip damon_call() if ctx has not started
      mm/damon/lru_sort: skip damon_call() if ctx has not started
      mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}

Zhiling Zou (1):
      mm/page_table_check: skip special zero mappings

liyouhong (1):
      mm/damon/ops-common: putback folios on invalid migrate nid

 .mailmap                        |   3 +
 MAINTAINERS                     |   2 +-
 arch/arm64/include/asm/ptdump.h |   2 -
 arch/arm64/mm/mmu.c             |  43 +--------
 arch/arm64/mm/ptdump.c          |  11 +--
 arch/microblaze/kernel/head.S   |   2 +
 include/linux/mmap_lock.h       |   1 +
 mm/damon/lru_sort.c             |  13 +--
 mm/damon/ops-common.c           |  13 ++-
 mm/damon/paddr.c                |   2 +
 mm/damon/reclaim.c              |  11 +--
 mm/damon/vaddr.c                |   3 +-
 mm/filemap.c                    |   6 ++
 mm/huge_memory.c                | 193 +++++++++++++++++++++++++---------------
 mm/page_table_check.c           |  20 ++++-
 mm/pagewalk.c                   |  36 ++++----
 mm/ptdump.c                     |   7 ++
 mm/vmalloc.c                    |  40 +++++++--
 samples/damon/mtier.c           |   3 +
 19 files changed, 246 insertions(+), 165 deletions(-)


