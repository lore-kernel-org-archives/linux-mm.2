Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0022BC88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 04:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41446B0088; Mon, 14 Sep 2026 00:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19446B008C; Mon, 14 Sep 2026 00:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55846B0092; Mon, 14 Sep 2026 00:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9100E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:52:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 960D7A65F1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:52:45 +0000 (UTC)
X-FDA: 85211147490.15.2D2DBB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D75441C0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:52:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jmEysL+g;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789361564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3Wt5ocwzEWGnNlYZNryMwTicaVcgg2/IRrlxzOXxn+c=;
	b=wd+U3FQfG03+9UXMCGLXlrvu2k8ehyBBu8Zocunq6LFx6CudIo9/zJ7UHY+cpQbLlfOLid
	WvqczhKWIX/TsUeSH/Io/wV3SMx8cNcGiJyDItp/mN+I6U/Rk+x3HA0qsocerpPcZlT8Gw
	T9SruaSooQgs+mZASkZ6kH875llcJ6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789361564;
	b=0FPRLNupE7xg1nC4SUWlqeFJtu/eAaXNeqTUZXAjpUeeBxDisn03Madu+2C62dPJcQqxtL
	wF4Lay1oeblcwaUWBylhzj+xJA3UixYk2rkfz0Jdo1tNutRPsOwB4BzQN3bsW+V6TBLfJU
	G911rpCqmypXHo5dJIlEoJgDtnHwAow=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jmEysL+g;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD70414E7;
	Mon, 14 Sep 2026 04:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DA71F000FF;
	Mon, 14 Sep 2026 04:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789361562;
	bh=3Wt5ocwzEWGnNlYZNryMwTicaVcgg2/IRrlxzOXxn+c=;
	h=Date:From:To:Cc:Subject;
	b=jmEysL+gdBRXJvJ5wGy4PM7XFeiQowuZ8f4CnHxs55WYuJ7Swv6ro4Vjz8CbHJbaz
	 k2DgKnvO/hrEIkvnexjb//nMkqxlb6b7yAWiw1ut/wiDInTaY7isxSWl0oE3BdoNVP
	 UJSDGSFi70HHNsS9QVJMfIUXRaD/fRdc9fH/ud9Q=
Date: Sun, 13 Sep 2026 21:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc4
Message-Id: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D75441C0004
X-Stat-Signature: d5s94rgzhw95pb3yk37tbtrb5pxexfd3
X-HE-Tag: 1789361563-593382
X-HE-Meta: U2FsdGVkX1/PEf0XpNmumrEWyyU+rj1Qeglylw3/nas9+jAQPsi9a5Z6PcZi9LQj89oeI/PEX+Cv1rN/EA5cKWYALyirNqLcc1cL/2jVAqRg7ezbFkzq+JYIHyvOUHb711Cxx+1du+3BQQbHeV4lqgsg1GOKJixMAuQ6PJvUsd2w4E6u8vKI5FTkDz6JIAr1sI1WSP/A/SQ6mrwbpN31Ar2Sv6o0F/EBJ5zgYEqjHmwFfdO+dVaO6vn6ppT7o7pOyh43/6Hr43LVUa51R1WZHdFk6PPzLIOdoQFQhzdYG5x/4Sjjzg2CL3/TTykexkUjPR+vg2dQEhmaCCiNf9stVOFQZEw6+Scs00Zqwgnr/s0OQGTK2hhW9MN0qp9VY4trvk/TQhLt4mhL4caS8pRDUMb3lasEYdW3+LRMtjG7naF21stw5rsngEsedQ8kKy8xm6zZRH7IRp7z1JphASCc/FzlKfrgkgS/5DeQ64LuY6S3XSUYdAk2kwGfy1X1UE4ogUuKCIRU1ZzuMO9MMhKBqQlvdP0jkB0UObZEMk2jv0BtZBf/7nqHf4EfVIMMgctgIMeXTiQo4/rfi/wk2ccSYA2gcgCmEUudDeeKKjPz/lNyIzcz9eteNiddzXfIV/Tj7cddrB/9v9/mC3g3YSIaIOrZdTfZ+kw7hwt7+yuZbgNp9Vep0s6ia36IPlNy24ea1yiZDXgIEgp2X7GQvXoQycz4Jpk7FSoDGiiqVlCEASK/1WJrf1UhVQYWQisygH0gzIIUP9lQg4hLSG1HFwHYTbhskHPTw9UcW8hes8C17zDIqsrGzDk7ra2K8rOGXz+QXiFpvVBL0ziP7F4HE0b2dKaes6l0iPS+g1v60JMRjtnR7finrHDIq6WQC4IMFwHunqjm83u+ycm8fpTWMvFzsx01wsovuhGvKwJ/DY/uBn0tvpL1ijoyaQga7CDOxpur5MSFiWbcHrGxGJDY8gI
 13vlJXvy
 oxLDteQjPf6SAUVazdZHN/axO02lhCJped5qEA2+NrsN5CeYqC63UlTlhByQjzQg+1nnEGiV5RxwWGS1KVcUo4W9nJy83vrhJswWKGuaGj7Da2N/0Vh8WnQZvP76hZTePV1EbURbZrnqelpBuO6BjO/iVrm+4Bz4/eL1pydzjWUDPMXGYVdgCQfdkswSEsL7G/B7a3XzIaCxAhvyYRv0LEMwqMGsd5b+6KobVSJ75UQ4nO+6Yp2xOyUmHF1egeK+wyu6UMyE5OHkFwe9HYktPOV9akg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 0d9ff90a5422cc7509258aaaba1e7481df4d332a:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2026-09-05 09:25:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50

for you to fetch changes up to 7891fbb9512f127826e1d5dbf380ee212bd15eb0:

  mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio) (2026-09-08 23:28:06 -0700)

----------------------------------------------------------------
14 hotfixes.  10 are cc:stable.  11 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Ackerley Tng (1):
      mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)

Andrew Morton (1):
      remove old lib/alloc_tag.c

Christopher Obbard (1):
      mailmap: update entry for Christopher Obbard

Coiby Xu (1):
      mailmap: map Coiby Xu's address

Jiayuan Chen (1):
      mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem

Lorenzo Stoakes (ARM) (3):
      mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
      mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
      mm/vma: correctly unaccount on mmap_prepare() failure

Nhat Pham (1):
      mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count

Qi Zheng (1):
      fs: fix missed removal of super_fs_objects_eligible()

Seunguk Shin (1):
      fs/dax: check zero or empty entry before converting xarray entry

Shakeel Butt (2):
      memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
      mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()

Wenjie Qi (1):
      mm: filemap: retain mapped dropbehind folios

 .mailmap         |    4 +-
 fs/dax.c         |    9 +-
 fs/super.c       |   18 +-
 lib/alloc_tag.c  | 1029 ------------------------------------------------------
 mm/filemap.c     |    2 +-
 mm/folio.c       |    2 +
 mm/huge_memory.c |   86 +++--
 mm/memcontrol.c  |    2 +-
 mm/mlock.c       |    2 +-
 mm/mremap.c      |    9 +-
 mm/shrinker.c    |    2 +
 mm/swapfile.c    |    2 +-
 mm/vma.c         |    6 +-
 13 files changed, 91 insertions(+), 1082 deletions(-)
 delete mode 100644 lib/alloc_tag.c


