Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCBD606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4GWITxy
Received: by kanga.kvack.org (Postfix)
	id B8F936B0933; Thu, 22 Oct 2026 09:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40896B0934; Thu, 22 Oct 2026 09:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55EC6B0935; Thu, 22 Oct 2026 09:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86DE96B0933
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:10:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0A0FA0842
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:10:17 +0000 (UTC)
X-FDA: 85350295674.07.0AE625F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69BF718000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:10:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4GWITxy;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792674616;
	b=5LaZz2Q9avNnHeCknxbR9dotlfby6Yf9OwTejFnvaW2VBs+1waDMFMjYUKfRMGXv4O5fpH
	0KwTQHlcAPQiE7wbtyzbInm+E8krqf4AvsmJOWgvBtY/CfcC3hwfE51EMd1+pgJnbqaoYX
	McOCqTiyeeLlXyESFsr6PWHPOU0OQig=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4GWITxy;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792674616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2lH8hAhqZyAccI4aZoGUInK6A5k9Wj1b9MbWKOEQc64=;
	b=R1xluSJyIC8fel2KJ/1uYS43GGJbopnXsUKvFToQK9Je3YFaz27Qo42wyyEhchoUOPvpik
	/uvJQAncYu45pbRJ5AVKyN8TLNfpA3WaUXslFFWZZj1qNkmUeRHx3qA/K4q9c9+/NQyFRA
	VlLhXrUFYup60b4nvkUYmqK7m2mJY3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 995B3601F1;
	Thu, 22 Oct 2026 13:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97EE1F000C1;
	Thu, 22 Oct 2026 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792674615;
	bh=2lH8hAhqZyAccI4aZoGUInK6A5k9Wj1b9MbWKOEQc64=;
	h=Date:From:To:Cc:Subject;
	b=W4GWITxyfysJH4O1c1wifcIOkhTUB9v+TBMFMiuxj+WC7mk/Q1kjg9H27fGPdhIP3
	 +QHOw53aLm6s/2jlwZjMLhzDBZxVAlS6LPtq58OYbwVII+vHefRL2POcYY+EZJDVD2
	 iovdJbTSAZjD8JM13ZjkA9Foj4oQQiKPpLV+j87FDbr/5HfB5ZoPgasY1JG7BzoSAz
	 bCgDb3+Ouk5RpYsxT5CvtwlBnoi41n1f3fef1cPxJHsA92/eNWq4jezAN8ym1kgcAj
	 btezOgdi9nUGVMb7KihlmECcthvb92JqIpTcr4EqeoYlsyZ4FuZnnQFoM7fG3ZuPn5
	 xg8EBZa90dv1g==
Date: Thu, 22 Oct 2026 14:10:13 +0100
From: Harry Yoo <harry@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@kernel.org>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Kees Cook <kees@kernel.org>, 
	Longlong Xia <xialonglong@kylinos.cn>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Subject: [GIT PULL] slab updates for 7.4
Message-ID: <atoJsKNb5KiE44jl@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 69BF718000D
X-Stat-Signature: 74q8bg1tx5tfmr1qkt4pxg3x6uhrpoc7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792674616-654132
X-HE-Meta: U2FsdGVkX1+73//7ZPyM3ilH3a2cjY/0DMJhgL0AX4ONVQH3xDoDqYliR4TDCXWUx/fn9atsCOUHjQhPgug+Y/E0Fd8Koh/t+DGUGnRMnUB9fwpxzg4ZjlS24nWVA5woyIMzPNBkEBccJA/H83CuqY3KYxyrIH0jv/gCsEgGI+2FsePiiDCxQ4Ms35fikRmXEaIstk2WPUDJtZ0Os3LkHPj3dFW5JXoTvANVuuNCbanyyEiXyzJr1bbTGW4X1MYlpCpSFJ13Wsfn7nFJBEEmhPMCujE24fvuT9TXCHnksy4afMjQ18F2/jg6z7sLWA6QZMH7okwfP27pMPnHPuCmp+CWmwq6DW81mif0Jxd6sddY5LNFeD9PxXhStX/48tJLArCaSuf6fUyxfg4fB5HS7Mfd4oryFYH6BdWtaB4rRFgRA2i8Odn4bfkt877N2UxgFcRoZwVkeZsAYOLv00cCJSIhaqE8HNvOIhdkpSAguq3uq+N7zN6zxRuniaEHTIKBnyOFD8UoMHz37jHRRuAqQ20BDGidF3/2+YtYa7rBwQ9vfw8cNWp98/L2wOnQnFCHA2pu9FL+G/6Qgmgv+l9rZ3kQM66UJZXYi+JxhhUv8jvdVr/yuox6JwEtEqA4oJkHoILE/F4Oon5jUslEmLxYyeskdVhr+EMgNKJND51W1gZe3ECYuaAtY05+Vwglk5wyz0L1b7wrimYti1WMFRaupplrhzNGTLPOvwII4lkU31+oimDcwFSBShfpxlgtzrswGg1LcOuC9hmJ7mgtAM9stWLGDFc641eMuwKEDfNtluwW6dvgGuNEnTp6UpL7QgKStaoH41kPXv7bJrxMOodw2RfPOy8v5DNFAPJm/NjiWa7pxxUrXb7Brcs47YqCi1QEQzBJ9pB8mliaQc18q8PywQjFrXawOTn8eNF5/Mb8aUvqsi3zEro+YmTVb0bqfge49X1vdLVMXVzeZ114ZeU
 Onz9p/kc
 ucFlHenfAyAFsZeJ7TzKEtPwIXnbsUuy+lakZlyIKtJ1yJuyu3uYjOAN5FNmIrrfjYdpvu4mwmZBp4AfEnHXkXMtECy2K3RRpL2norHjuDGsothZK/e0HfeUDlRuKw+tEoN33y6th/iCqYbYSds7Ui5j6s10pKHIRl5A5vMhwLK3opc7nMkkxRjVaVSQXwiVukAuiRHZhu51Zz1Y0btfxeHA883jbk5dXQWeKPT43HPWDIhZVSWmIio7a7GM42FmPHLAKRsux4Brf+cb+A9mAUQW8kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.4

There are no known conflicts with other trees.

Thanks,
Harry

======================================

- Performance improvement of the sheaf prefill API, by allowing the
  barn to hold a partial sheaf and refilling sheaves from the barn.
  This improves will-it-scale mmap1 throughput by 24% on the
  maple_node cache. (Hao Li)

- Restore memcg accounting of ipc msg_msg allocations, lost with
  e.g. CONFIG_SLAB_BUCKETS=n where the allocations fall back to the
  general kmalloc caches. (Kees Cook)

- Fix an old race between kmem_cache_destroy() and slab_late_init(),
  where a cache destroyed late in the boot process tries to release a
  kobject that was never initialized. (Imre Kaloz)

- Remove slab_folio(), the last use of struct folio in slab code.
  (Matthew Wilcox)

- Reject kmalloc() requests above KMALLOC_MAX_SIZE explicitly with a
  warning and NULL return instead of relying on the page allocator's
  order check. (Zi Yan)

- Various minor fixes and cleanups. (Hao Li, Karl Mehltretter,
  Kees Cook, Longlong Xia)

----------------------------------------------------------------
The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.4

for you to fetch changes up to d15d7703166daf7bd62c844a3cb1b3a6279adb4c:

  mm/slub: initialize the free pointer of the bootstrap kmem_cache_node (2026-10-19 11:57:03 +0100)

----------------------------------------------------------------
slab changes for 7.4

----------------------------------------------------------------
Hao Li (3):
      mm/slub: unify slub stat definitions to simplify metric additions
      mm/slub: make the case handling in __slab_free() easier to follow
      mm/slub: refill prefilled sheaves from the barn

Imre Kaloz (1):
      mm/slab: sample slab_state once in kmem_cache_destroy()

Karl Mehltretter (1):
      mm/slub: initialize the free pointer of the bootstrap kmem_cache_node

Kees Cook (2):
      mm/slab: Mark the kmem_buckets_create() context as a Context: section
      ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again

Longlong Xia (1):
      mm/slab_common: reject zero object_size before calculate_alignment

Matthew Wilcox (Oracle) (1):
      slab: Remove slab_folio()

Zi Yan (1):
      mm/slab: reject unsupported kmalloc() sizes

 ipc/msgutil.c    |   3 +-
 mm/slab.h        |  28 ++---
 mm/slab_common.c |  23 ++--
 mm/slub.c        | 329 ++++++++++++++++++++++++++++++++++---------------------
 4 files changed, 228 insertions(+), 155 deletions(-)

-- 
Cheers,
Harry / Hyeonggon

