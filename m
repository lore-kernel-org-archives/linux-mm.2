Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8C3C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407636B00A3; Thu, 23 Jul 2026 11:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF2F6B00A5; Thu, 23 Jul 2026 11:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7CC6B00A7; Thu, 23 Jul 2026 11:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9B46B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:17:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 691411404EF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:07 +0000 (UTC)
X-FDA: 85020394494.11.388F78D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADB4240010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gALUPxMv;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tOkcYp7bq/lm/cKgO5LpqDOGzN7wj+Gq22Vqvq122OQ=;
	b=0HXsXP2wYNzYMyJWq2QRFHFX/J97W6xFBcyflwhsRtegtcu06cyCu1uPQx991o6FYMPkyp
	k9YvULXFLTBJVuMmHl1u5+OVmKFLHB352QbWJ93HNpRgmYX01XDMEX39iDZ+jWhGXUSewq
	QppiC3IQbihtY49LvsbPy87uKQ+6Cm8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gALUPxMv;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819825;
	b=iC+9g2/wKRb3oEb66ji5hd/+GPzzzdG6udHTlG4a7UQMNPka7Jg0FC5qhEhktF3nNIK4A8
	gJcSFGHoQwA4Iej/ocn50oaypcTeZIjlfmTm7soeMQMWSDQWv+RDR+TTaczV6jcf80nzNl
	T1npSFvhwe7MAIkWQRoNsvAmqJtcFFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17B5B60A82;
	Thu, 23 Jul 2026 15:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340191F000E9;
	Thu, 23 Jul 2026 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819824;
	bh=tOkcYp7bq/lm/cKgO5LpqDOGzN7wj+Gq22Vqvq122OQ=;
	h=From:Subject:Date:To:Cc;
	b=gALUPxMvCsolFDharNcYLWcSwWh+mI5iyNAY3oz7Hwj41b7AxeeUx920gygiAMyGs
	 PMxR7XVJDjGmIk713tapgV0SgBEJB4tTRK22BDeYiWo/v/B9q3wFFmq6B1oqQPrY/K
	 nj+kToCaQUN/Rqk2gf/bDx0A54lNkgzskZSBxzadAO92MoxUWo2pGWrGOtHQ9DpIOy
	 oLLb4SQdIkZzKC3ycZ2UsY2CEfsjOMHCvuUWEBBUSiD3SKfwVOiHF7TpaC5yRks+lb
	 z8+AyZOBvv05qWtujJ/Ov238BAwAzm6GKeRo0U1piAopukeqcZZ8WiQLwAgtySuZ9o
	 340xMen1L52Jg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH mm-hotfixes v6 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Date: Thu, 23 Jul 2026 16:16:30 +0100
Message-Id: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE4wYmoC/33OS26DMBAG4KtEXteVXxiTVe9RZTEM4+C2QGQT1
 Cri7nVgQ4Xo8p/HN/NgiWKgxM6nB4s0hRSGPgf7cmLYQn8lHpqcmRLKilIKvs7zqYMbj4DEffj
 mCgwCVs5V2rG8eouUywv7zrqOt8O45svaTPf6g3B8ws/xNqRxiD/LE5Nclv6/N0kueFHrsjIop
 fb09kmxp6/XIV6XG5PaKupAUVmBRmqDqEEq2Cl6q5gDRWeldlIRogfhq51itoo9UExWHErh0Gh
 ZNn6nFFulPFCKrFhhQQDaRlPxR5nn+Rcso2pe8AEAAA==
X-Change-ID: 20260710-series-vmap-race-fix-2a4cac988938
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9066; i=ljs@kernel.org;
 h=from:subject:message-id; bh=oLL0FuAaN0G99BVoKnEwyOx+jeYfUCBiH1tkDh09jxk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKSDKI480wyeR95Hl5y1GHx2/xQq2xPkYlu2zbXJ6le3
 +iUv2BHRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACay+xUjw+ez5ru3sRnIrZ8t
 us/2YpqdWts1w7gfpxyF9//Y/OXvFzeG/+VT/DaILapd4nh6ptvGt3N3dXuEfpJ09q8yaJud4zy
 JlRUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: ADB4240010
X-Rspamd-Server: rspam01
X-Stat-Signature: ngmy3p1cjbfqbft1uqrk3nsjnj7bmm4m
X-HE-Tag: 1784819825-796821
X-HE-Meta: U2FsdGVkX1/5npbGC9+MJFDnYNca3hzONJc090Yhb2CZGkvZP8RHwMv+O7JFJsacYkTkC33ioQ/30Rq/SCeLTaO3Hyi5H0g2A3JSWZRYFaoNnPQTMMSGa27rQt28l7GQkdKWjdX0ZzlIHNENyq1mqwzqf8OsBIxOl2MyJzVDiX9HX/Ym9reTvrnVopuoVGisr++FsABz9WTqGs8hp8j+dF72rUrDdjKAGUwidPjJIWkhX0YcLyobSl1A+C7ivjUuv+LrZxejlm5wPEvdVVIBSPv8JLnfQuqnEL4mhhxcNJw3+vvuQM+rYAS7RlsUj7hD2vOQS9yKmcUoHA9jmDeew0Blbb2xLZRBwN1mC1/sZEJQmpt24paSVf5b9Ay++mbNCgJuXhYGeWD2/NZlGAQeW+O2hwl2pKTIY0KXgw6qhn3mBsGmFCy6mmZOGMj9R/VrgvrWRjlMsKmfEqwKOoDq5nZLNwzfw6D8WiwbemhwsxZjjLuexaIRW0lJlC5OefdTnf7yq4tFXmr+v4kRTVfA+PGsGqIe/gcgkGS1w9296Ph0zLN/MgE+gIMoEzFKRv/00Wrvji0aczyVAvdqGnmZTb/T67lHeupZv9W1bmP4eLh6/m1uj99Y6I6DYQ1Hfm3KZdzQPIuLqYhEaBUICS+G4rNKn3gcJ8KG2oZnwXjMHUcSkabG+XvYhaX6nzzPFiIoQvU2uTEjquMZ+ILeU3VoGSPtz42ObCGPfLpxjnyCB9C8fMq3cxXBuZ/wNjYvsfE4DTPPh4o2WO9EqYXekWGA5GR5oS7IWYo5X+VL9D27mOp3P2lpZroTGRFASixxUXJI4b9jcmzLjMVms0cjJ79eEJT/IjmEU5g6re4QeEnqSteYI+ouEgjlLITCO9k9GeDoY814CnHY5XxqRmMfMm0sdaV82lwz3G7ocjZ8drOxRnrjmU+UGrKRl4KygUdRLH9+cTqoLpBrow5e67dXE3L
 vDv2kBJp
 ywEEzqDqa9Dro7JhF7JQgSj//XeoQLghKR3ZlrIlrv7EmoxNF6CDwxtieqQ9hogGSMgPgNXnTI5ddoAiCLwYhLClD88EfintshqV5+xBkntvdXuHJhJhdFhiqo3MzO3Ip5wvS9zTNCFhrKg67lAN8KUvxAhSMsff4aSV3xN8xD/IULiMqEhHAZjWBjvxAkxVQ18ijoqImKbxGgECK8wwQGOafRCvKMBzsstfx3TTTD02hKygB99aA1vWEgxDhwUq7rRTpth2VSjizXqohPw78LzBeyYESn6EF7FC0qeT583VFFEhaYscjmLrUE0GLE/pK2PE6K/yq/sUkozQDX6ASU7kLmwVqWcHfa7M2mrPwIYm8NWuUe6iIRm9z4bGqmmrFYbFiOqGQdFQASafzkuqVX+y/4YcPOjwXEBRk1RarCUj4j9gc4oWyv+hPBITZLup1VL5zzZwVF5ViZl+j364XDdpkXF8pg+URm+G9fjl3gNpweDIZnR1jV63zxTVDnK6ELdaondUICet5DSBFBjGR2axWti3P7+w8VNyiZKgRLb9o3RxudqyjstciTiFsu0KH/KhZGbreOrN1s60+cFWZ3cCYuDxBxZ7xw4pXGJDVUrG6UvNDLMvuCKvLkVfhGvUXLct6ldyQYkB4IgdACl99OPyW5bbV6z7XBS9A8gJKeSjBbGgf2svM5D4YhVLAhUU68IpGw5TiIS95uZ4cDwraxqQzd5F78msoVsSHJwdAIwFJLSVCNr9ajjlZKBH6Lr/KJ4ttx2V44xRFDhyfGrAfj3CJTYq8kLN82+zbM0YMIxpQ6tQIAZWDcUtGz2Bvv3d5t88GXMAklq4V/W0hv9RRCmWptLl+j/SP+qjxJMHzTP8EBq27qMGuvQfzQsymmlECSe9jzVUQ6nBO5YByt0oL+N4SLzCQQMYgHoWAxMFuc3XXZaIF4xSp+gq31cC0wcdDylKSqls1XGJoHYJ27tCtewKE2N+g
 RVV/jleR
 2V1F90B45/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel page table walkers fall into two broad categories - those ranges
where no exclusion is required via walk_kernel_page_table_range_lockless()
and those where exclusion is required via walk_kernel_page_table_range()
or walk_page_range_debug().

The former category is used only by arm64 arch code operating on ranges it
both wholly owns and does not concurrently write.

The latter category consists of kernel page table walkers operating on
ranges that are wholly owned (but which need exclusion against concurrent
writers).

The lock used for exclusion is the mmap lock, and for kernel ranges this
is the mmap lock on init_mm.

ptdump is a special case being both the only user of
walk_page_range_debug(), and the only case in which it walks ranges it does
not own.

This presents a problem, as page tables may be freed under ptdump. And
indeed there is a use-after-free bug in the kernel as a result, which this
series addresses.

vmap promotes page tables to huge leaf entries where possible, freeing the
lower page table when it does. It does this with no meaningful locks held
against concurrent ptdump walks.

As a result, use-after-free can currently occur. This series addresses the
issue by having the vmap huge promotion logic acquire the mmap read lock
while both setting the huge page table entry and freeing the prior leaf
page table.

The ptdump code already acquires the mmap write lock, so by doing so we
ensure that the ptdump walker only ever observes either the huge page table
entry or the existing page table entry, and nothing is freed underneath it.

A mitigation for this issue was already applied for arm64 in commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
has to deal with carefully.

This mitigation resolves the issue by acquiring the mmap read lock on
init_mm on vmap page table free if a ptdump is in progress.

However the fix in this series would cause a deadlock if we were to simply
apply it for arm64 without also reverting the change.

This is because vmap may acquire the read lock before ptdump attempts to
acquire the write lock, which then gets queued, and rwsem starvation rules
mean that the (unacknowledged) nested mmap read lock in the arm64 code
would also block, meaning the original read lock is never released and thus
deadlock.

This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
support, and removing the ifdeffery with the partial revert patch.

There are related issues that are also addressed in this series:

* x86 page attribute logic, specifically Change Page Attributes (CPA),
  implements a feature whereby huge ranges can be collapsed into huge leaf
  entries. This can similarly cause a UAF when done in parallel with a
  ptdump walk, so similarly acquire the init_mm mmap lock to avoid this.

* The CPA logic allows concurrent page table manipulation and CPA
  collapse, meaning the former risks accessing a page table the latter
  frees. Fix this by acquiring mmap write lock on init_mm across the
  whole CPA collapse operation and read lock on the page table
  manipulation.

* x86 and arm64 permit walks of non-kernel mm's (both allowing efi mm
  walks, and in x86's case arbitrary mm's), so we ensure kernel mappings
  remain stable by locking the init_mm as well as the mm being walked.

The ordering of patches is established for both strict dependencies (the
arm64 partial revert in particular has to be done after the vmap changes)
and logical ones (the non-kernel mm fix only makes sense once the vmap/CPA
fixes are in place).

---
v6:
* Rebased on latest master of Linus's tree.
* Updated: 3/5 to drop the init_mm lock over page table allocation in order
  to avoid deadlocks due to init_mm -> ... -> fs_reclaim -> init_mm
  dependency cycles, as reported by Chaitanya with thanks!
* Small cover letter typo fixes.

v5:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Added additional commit to fix race between CPA collapse/attribute set.
* Slight commit message tweaks.
https://patch.msgid.link/20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org

v4:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Updated commit messages further as per Kiryl.
* Took the mmap write lock across the whole CPA operation as per Will.
https://patch.msgid.link/20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org

v3:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Reworded commit messages as per Kiryl and Boris.
https://patch.msgid.link/20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org

v2:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Fixed cover letter reference to arm64 partial revert as per David C.
* Combined all patches into a 4 patch series for ease of tracking/review
  and updated cover letter to reflect.
* Reordered patches in series logically - fix vmap, fix CPA issue, handle
  mm vs. init_mm then revert arm64 mitigation.
* Reworded first patch to be consistent with x86 wording to clearly
  indicate the intent of the fix is to fix ptdump UAF.
* Reworded arm64 revert patch subject as per Mike, Dev to make clear this
  is only reverting the ptdump mitigation not the vmap huge support.
* Added Fixes: tag to arm64 revert patch so we backport this also for
  neatness. Not strictly necessary, but is a better fix overall applied.
* Added note about stable dependency to arm64 revert patch.
* Updated walk_page_range_debug() to remove pointless !walk.mm check - if
  NULL mm then the mmap lock asserts would NULL pointer deref, and of
  course no caller does this anyway.
* Updated walk_page_range_debug() to always assert init_mm mmap write lock
  is held.
* Updated walk_page_range_debug() to always check for start >= end and that
  it has safe walk ops, and remove the unnecessary
  walk_kernel_page_table_range() invocation which ultimately does the same
  thing.
* Typo fixups as per Mike.
* Some small commit message/comment wording fixups.
https://patch.msgid.link/20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org

v1:
* vmap/arm64 partial revert series:
  https://patch.msgid.link/20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org
* CPA patch:
  https://patch.msgid.link/20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org
* non-init_mm patch:
  https://patch.msgid.link/20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: David Hildenbrand <david@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
To: Toshi Kani <toshi.kani@hpe.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: Andy Lutomirski <luto@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Kiryl Shutsemau <kas@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Dev Jain <dev.jain@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc:  "Denis V. Lunev" <den@virtuozzo.com>
Cc: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>

---
Lorenzo Stoakes (ARM) (5):
      mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
      x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
      x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
      mm/ptdump: always stabilise against page table freeing using init_mm
      arm64: remove redundant concurrent ptdump UAF mitigation

 arch/arm64/include/asm/ptdump.h |  2 --
 arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
 arch/arm64/mm/ptdump.c          | 11 ++---------
 arch/x86/mm/pat/set_memory.c    | 28 ++++++++++++++++++++++++---
 include/linux/mmap_lock.h       |  3 +++
 mm/pagewalk.c                   | 36 ++++++++++++++++++++--------------
 mm/ptdump.c                     |  7 +++++++
 mm/vmalloc.c                    | 40 +++++++++++++++++++++++++++++---------
 8 files changed, 93 insertions(+), 77 deletions(-)
---
base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
change-id: 20260710-series-vmap-race-fix-2a4cac988938

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


