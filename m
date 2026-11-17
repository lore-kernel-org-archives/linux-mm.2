Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23395606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b2Eja1XU
Received: by kanga.kvack.org (Postfix)
	id CDC9D6B00EF; Tue, 17 Nov 2026 07:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D166B05B0; Tue, 17 Nov 2026 07:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2ED6B05B1; Tue, 17 Nov 2026 07:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92C126B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:37:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23CF840409
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:37:25 +0000 (UTC)
X-FDA: 85444561650.04.9E877C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8620FC0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:37:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2Eja1XU;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hXSEIu+BwV1S8tPxayHCJW+kRFznr7QmQ/f2L6iJRlQ=;
	b=Nmy3RzIR564hrG+EtzlS+CZVOKeuImAyDH6XHRpePPfgU+/rGCcR2f/vWUnBA5GPblkXR2
	V4yJZBYCC0LzrLXQPhf6e3e7D8igGpKJTrm3eWD0XcCea/IJ8zjHu4AjSOEs8bLY3vkPJW
	5vlWxLR28UGwqJ1O4QBF4IaydSZCnM8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919043;
	b=he8C8YaOxmLt9FT7oeNNzcB+qD0DLnTBIJz7z/IuSOQj9j49eSPND+RpcX3+yWdQQZPJJc
	QyvmIknnWlN4mdCPku6w+Z9q9uMbbku1DwTElBylYKQKBd1Jew+1s5nmrLs5V3/ItTtPix
	nfQgMCjdD6BuXvdjh6Z77lCacYlS0lY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2Eja1XU;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E80643AA5;
	Tue, 17 Nov 2026 12:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD021F000C6;
	Tue, 17 Nov 2026 12:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919042;
	bh=hXSEIu+BwV1S8tPxayHCJW+kRFznr7QmQ/f2L6iJRlQ=;
	h=From:To:Cc:Subject:Date;
	b=b2Eja1XUJTUdCidd1n03CptFLQI3lvHVjocRxQIwnkHozMgc6D/fvjlERtAHfMQRH
	 XODOczW2lLykerwRiSiDVXMfQezSmOb1HLWOuopYuCDfdatFHK9/94p5kcgmV4wNJg
	 qX1JKG/Qzy/ELcvHgqbRgIeL7dL09AUnsX/Y9AQLwh9Rg5kNLLYB+S9fU9l8Vl1UDU
	 54PVq5+BXNDp4+3p2I141BJtXtqgnuXB+9+CyMlCz6OmC5pcS2bOi+rzl+rkEX8Sfw
	 FtRio08+KyXt5MxU9lfR1dWZeOL75gomPf/bvDsXk/PExOM7WnGWN69Tg+A0oQOjjw
	 L2mnsW1eBvyfw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [GIT PULL] Core MM fixes for 7.4-rc4
Date: Tue, 17 Nov 2026 13:37:14 +0100
Message-ID: <20261117123716.7567-1-david@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8620FC0006
X-Spam-Status: No, score=-28.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gng99ctggnqho3fae86okfkxida1mgo3
X-HE-Tag: 1794919043-839988
X-HE-Meta: U2FsdGVkX19K75zcgDi/rwuRB3H/xkuWMcIZEquXExA4VrthChtaX4LfNDCZbWel/SGlrWGo9hBBH1nRor5VReG/0jymu2zIY33tu0LtuH/DEfh7cvQX9kFgTMRQodtGuZk4oEFrzbZcwpvS391aWsNXxGWE77Mqa9FWuQflxROWJ4udy9mxMN6DxCVm9gDVE7qxs3al2uI7E6yJuy+x92qtti1dIDU2rjh4Mm1xlJ2iS2Ww7HdkQBr54aHXgh4B0hY43BPuqmov7SZOtBw5l/UuRFDtpFJLBAKPnH/RfaVQXMUwyyyIBc8QTBgSjGpbOzLA06HIVklBM7o4nSqTQ6nPRHIASlFKzw8wEj+A9aYqDUsuj/y8eFq7Lng7Kg959qjcOwXy/GFMVCAbT+YaLj6krzCM2arpzZaN/4IByjd/OJNW7D+B+3G/Msi+lz9N7C2JEZNn0fqJuJJC0lxez7JAsxFNB3Gy48+3VBYKyyZJO7ICau8miXJZHVfM+ehWzHxzdDl/Aqdk3IDcPNwJ5eLfPRGpFdU5PnE21FqhOR6PE5i7fUcvDiluCJtZpxcNw03GPB7T8ZJpc8HXOWWdZeD0qRw7bjyu6e5v4k5JTtU5HypIs95FVlJtyt162stEVvj+zfmcdQEDK0icMBji1nyUIz6YA+vdjcET3PmHFY2fJPthZy0u8VYPJD9BvsFQoJvHMLCRd2GaLbRETsIuNuIr7X4fwzCrgfhfmT0n3gWiv2yGbiHn1kuJm39VBfaYyHmEQyNy4OEAGQSZfePs9VE8TQ+HQh0Vp0RLY4MMNqzLazzjj9Mx3TmlppsqoZx3oi8VW2Fjk+sxHbm1kHSEhN6EjjgIe+dlgEDuOTkpUytxO3DO3IrwA44sHMUQU3MCMuJJ8gtsgDKMNweIoSQ6wLO6nNAByUBN+XKR662pK54fu9a8n05WbXLCJImbpQ0cDj+9/I/upjAt0IHCawe
 rNqeXTLa
 mrnP8O06qz2I2kdqfzTwOgXq0oBxi+CKL1EdObYZvYyJJ26M28gkX2oC+VxdMONt2jxkgZ2jJINdn6r+YRagdzX7oUCbvFc7ygpEktz2q4DB0K0f6EZx5B1MH9TcmRNL+zDE3oIcyl7xSwKLIdQ2wqiiXgP/4ICGezRbDYGUuu6xzFKOZGuyTjaZsa68BCfqb72ITK1h5ixTLufCbMeIjnU9IMbxx1U59+rs0pgPDLJn4EEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

please pull these core-MM fixes for 7.4-rc4.

I wanted to have them ready for -rc3, but decided to give some of them
a bit more soaking time in -next. These are all urgent fixes; non-urgent
fixes are getting piled up for the next merge window.

The biggest piece is the folio refcount overflow prevention, which you
should be aware of and which I want to have fixed ASAP. What's missing from
that work are the net patches.

I'll try getting more attention from net maintainers on the net changes
next, so they can go through the net tree.

Cheers,

David

----------------------------------------------------------------

The following changes since commit f66469d9905b39d2c260a15d7d6db450f4db67c1:

  Merge tag 'net-7.4-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-11-05 18:00:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc4

for you to fetch changes up to 25f5c92e1ac06496679ea229e5c825aa88968efd:

  Merge patch series "mm: limit pagecache folio refcount" (2026-11-14 16:36:05 +0100)

----------------------------------------------------------------
Core memory management fixes for 7.4-rc4

This includes fixes to:

 - THP (Transparent Huge Pages)
 - GUP (Get User Pages)
 - USERFAULTFD
 - SHARED MEMORY (memfd)
 - Core MM

The main changes are:

 - Prevent folio refcount overflows with pagecache folios, mostly
   relevant for large folios today. The networking changes for this will
   go through the net tree.

 - Fix out-of-bounds page table accesses with folded PMDs in 3
   scenarios.

 - Fix write-sealing of memfd to detect GUP pins with concurrent
   (un)mapping more reliably, preventing writes through GUP pins after
   write-sealing.

 - Fix lost wakeups when splitting large folios.

 - Fix exposing uninitialized data through MADV_COLLAPSE to user space.

The refcount changes also include a related iommufd fix for properly
cleaning up when pinning memfd folios fails, which is now easier to
trigger.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

----------------------------------------------------------------
David Hildenbrand (Arm) (11):
      mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
      mm/memfd: handle GUP pins more reliably when write-sealing
      mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
      mm/rmap: fix PTE table overruns during batched unmap
      mm/rmap: fix PTE table overruns during batched reference checks
      mm: limit pagecache folio refcount when mapping pages
      mm: limit pagecache folio refcount when splicing into pipes
      mm/mmu_gather: flush pending references early before the folio limit
      iommufd: fix cleanup when adding memfd folio pins fails
      mm/gup: limit pagecache folio refcount when grabbing references
      Merge patch series "mm: limit pagecache folio refcount"

Zi Yan (1):
      mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()

 drivers/iommu/iommufd/pages.c | 15 ++++++--
 fs/fuse/dev.c                 |  4 +-
 include/asm-generic/tlb.h     |  4 +-
 include/linux/mm.h            | 89 ++++++++++++++++++++++++++++++++++++-------
 include/linux/pgtable.h       | 24 ++++++++++++
 mm/filemap.c                  | 28 +++++++++-----
 mm/folio.c                    | 26 +++++++++++++
 mm/gup.c                      | 32 ++++++++++------
 mm/huge_memory.c              | 64 ++++++++++++++++++++++++++++---
 mm/internal.h                 |  6 ++-
 mm/khugepaged.c               |  6 +++
 mm/memfd.c                    |  7 ++++
 mm/memory.c                   | 48 +++++++++++++++++------
 mm/migrate.c                  | 11 ++++++
 mm/mmu_gather.c               | 10 +++--
 mm/page_alloc.c               | 17 ++++++++-
 mm/rmap.c                     |  4 +-
 mm/shmem.c                    |  7 +++-
 mm/userfaultfd.c              |  8 +++-
 19 files changed, 336 insertions(+), 74 deletions(-)

