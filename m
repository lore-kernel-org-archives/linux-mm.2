Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D030ECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFE06B00B1; Mon, 11 May 2026 10:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0FC6B00C1; Mon, 11 May 2026 10:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B65B6B00C5; Mon, 11 May 2026 10:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF5576B00B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:05:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B55140140
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:41 +0000 (UTC)
X-FDA: 84755312082.18.EA16A83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE58A4000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pk8OvGhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lQXqTgBue7HDYNHZQ87/hoDlL53avAm6YNApkaUe7pc=;
	b=zL1DG7RNr9NZOBX4xzmw21UtNN5La9Le/9ZW10wO8XHf5RNBtWIFuKYkqNWVmvG5vZ2gIi
	w3nB4smEAt3w6zzYrx6BNuqmLvrHnlab41DBtDf51wDjv24DTzsOEB9/oKPOIDFdTvJvA9
	5yH4So7uw5N8EtvYEQCA6uuKN+oitc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508340; a=rsa-sha256;
	cv=none;
	b=Fju+Ts82o3tltzCBdFsk67zl7CkG33+5eR0oTAjxixGjy6mQ0A9mLNR7ByADMU4ATIb+3K
	WhhPVP73oF62Ow3jCdZP0OXUN/pZA0grq+qvjCkU5RSF5fqlbmxgZcsCADFPW9j5bqs4TC
	QD4rN68vuyoKnM5lgp0mAJhtXS9V9Uo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pk8OvGhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 037A4444E8;
	Mon, 11 May 2026 14:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6323FC2BCB0;
	Mon, 11 May 2026 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508338;
	bh=Pm3OKX4tz/hPsvUcluc/wv11pQMYSvwTXUM7a7WxgtA=;
	h=From:Subject:Date:To:Cc:From;
	b=pk8OvGhJq7glmUYSBkvjdGMP8W1PwVrj/Ni3Vl6ybhzKWT6REW5dAxr3KJL8Qww30
	 E588cfZ6DoBozhyhGn/5G6YQ/IWBF4Ds5JmK12mdtVf7FtP+6eg2pqtKxcgjkhacEt
	 7XoKR6PdHITxP1Lz63lzWXchEtWTiDthd8atbcP2GojB3NkRaoidqNmLH0XqLjqQt5
	 /xaOsOTS2ojBPwKvIW2lNWBCpaI3QT00m1Z5Rh5VuZKvNEnIcaO8wH3zOE3YvebS4z
	 Wjw3Jmmdw/vmHqR3GEnYlW3qe3zPpguwb7OJlJ2b4ie1RJEWM0QSsUDcjsm1zHmNUd
	 K+7av9Ttx/5rw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/8] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)
Date: Mon, 11 May 2026 16:05:28 +0200
Message-Id: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACniAWoC/x2MQQqAIBAAvyJ7TlChjL4SIWpr7SEVjQiivycdZ
 2DmgYqFsMLEHih4UaUUG8iOgd9t3JDT2hiUUIPopeQupfPAw1AMyeSCmbvgBWrbu1EjtK7JQPf
 /nJf3/QA9mHRTYwAAAA==
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE58A4000B
X-Stat-Signature: gw79g14uxysyqscipyw9d3mnx4a9qab8
X-Rspam-User: 
X-HE-Tag: 1778508339-980550
X-HE-Meta: U2FsdGVkX1+0oNukMZ9xq+sMYczfstpTBLYtQsBLL3cofWM6LAjuPB5sMlw9vhq217BnLhfIdxhL6QiN0nb92YrUbgpwD/nDvfFIds2iBt19luauzmBYsMLfJmuWwYrsT8OU1RLkLD7q3oSf0OwVPkPN09poOMjSyDi6LciDD3KzrFnOnuW368jsVZVA75M6jRVhLaN+/ZpH/na7WSZvby6lFINM4hMVkynYZjpmmQIEIxABzTRg76SJp7vto8sVRRfKqfBx4FzHZXSBtS2TjEqVC+OHZ4kZ4DrmhyTaFOMyz+LY5zwHIWHZjhayO/6uup+rhUBgpVo66MQTH9F4EUKCXnlJpX+fQbBP03IN7L4/Vqrnqyi0BKvVsNYECdPODmwfUcqjJ8ATC1mkzeCyXxCeCVgIDAvdICdsCqEWYjcnmKsLzQqjyYPDBBVDq2sSjjoQvjKLYoo0V8hhfp8qsZTbTLaATa5OR6bZH/CZXOaOESx0ieDDFn2wYlZEFJiLukXip43q9L8PIrP/4eUaBmoTZ1OktjXePcXAaEOtgFx0KbIT9SlWbxZNRQIpP0VEbldmorKVOEYRdznrXjdV/TrmPfBGVaJL+B2vLDqyQtjci6a9iw7Dfv/53rbW8cpXjgMe56Je4S3LrMqYTGiwRJXO67cQOgaZJhVcAZ90Tq9hWgHJsmPsMBP0BHgJsH6XM125sVJmLVdLari2rL3aIEdQTp/fkAw/z2oG9dV/CMoZiyLmuw/cVm9QsJIR9JdZtYs6hk3Eh5IEuI45IzVxKJEph3GF96bbv+5b38dkxJ2l9VHqYDrtuAu03pjZBsrg8kfM19gL6jS87dIVYJ4ffS+rU+ixZrXhd801i0vNHtUt5XYoCv/PbEZ3FOPVtvJ953Yqrc60Iq4D3CCAbeKaV1xVcQymmK0mk0Pdd1y/XDGpff7ANHdpoWMrM9cNFYi43bJbK6/8t02i/7sDbJe
 e2m4CL5h
 S3Lg9IJWzvS/AdoUWlocECjqn8gmxxi5/zJBUZtP/AnnVRsY/hm/ipZf0XeWU1r/Vf4MOXGeRMqMrGIPUgkVlzspIqqE27PBtCUlXxxNp5uui7l1uuzq+NEQTM0o41bBQMVpjthOxmkdpZMUUCnT2iuRB0aNfvddffPv6jneM2xWIQXL+XYTLVISYxh4DssppOj2YVITQ2IXA/S8XF436CJgzuuCD65SO1h8xzLRbfuY0Gj9hXRjE/hERWmWzgw43fVtnbaJelRlFsSxgC4RPUpdKxBHWfqLQZgUT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE. As a first step,
let's limit the remaining harm to x86 and core code, removing
sparc, ppc and s390 leftovers, starting the stepwise removal by removing
and simplifying some code.

Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.

Tested on x86-64 with hugetlb vmemmap optimization in combination with
KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
remove the vmemmap pages from kmemleak in put_page_bootmem") does not
reappear -- hoping I managed to trigger the original problem.

Heavily cross-compiled, but let's let build bots run on it for a bit.

[1] https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org 

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (8):
      sparc/mm: remove register_page_bootmem_info()
      mm/bootmem_info: drop initialization of page->lru
      mm/bootmem_info: stop using PG_private
      mm/bootmem_info: remove call to kmemleak_free_part_phys()
      mm/bootmem_info: stop marking the pgdat as NODE_INFO
      mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
      s390/mm: use free_reserved_page() in vmem_free_pages()
      powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE

 arch/powerpc/mm/init_64.c    |  8 --------
 arch/s390/mm/vmem.c          |  3 +--
 arch/sparc/mm/init_64.c      | 20 --------------------
 include/linux/bootmem_info.h |  1 -
 mm/Kconfig                   |  2 +-
 mm/bootmem_info.c            | 25 ++-----------------------
 6 files changed, 4 insertions(+), 55 deletions(-)

---

base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153

change-id: 20260511-bootmem_info_prep-bfc0e7a5b87e

--

Cheers,

David


