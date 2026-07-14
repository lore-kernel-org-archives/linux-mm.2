Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D33C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC086B00B7; Tue, 14 Jul 2026 13:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF96B00B8; Tue, 14 Jul 2026 13:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B446B00B9; Tue, 14 Jul 2026 13:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 501B86B00B7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D29D18035F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:24:47 +0000 (UTC)
X-FDA: 84988057014.30.1FD3FBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB322140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:24:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIizjbIK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=25Q0GG3HaiGcVFQs/3bkfUHgoMNdoTtvx40TwqLtl9c=;
	b=Z4UkwpzC933mZePtcnnnwHR6GQvYx2Bn+8msH+ddTv3HI2s95kIn40BUvYXcGyTaLqR+7r
	UZ3CkleIBuvDTFVFnk7vOtX3Z9OcxfLNn7sluaBNo7ETwHZ1LC4DJiUaB+Zh6BiqBxheey
	8Jih8DEjBOkMQBzcB0o36M3x05T90Ac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIizjbIK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049885;
	b=Cygh2PSpeFu5nV3U16AJL/VTw4sEufqz8Z6a5lYYPe48h95/Th0zKyGOz1FiVMxWJN0j4X
	tTToToYNnwiXyETMf3LPusjdJ6NhV5gf23cKAORPuq8AhuhDfCnVt/6auczn/4QBUlmVG4
	TcgGtXYpeXrs4YKBiHPvlQtBnLACRS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBE4842E8F;
	Tue, 14 Jul 2026 17:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002101F000E9;
	Tue, 14 Jul 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049884;
	bh=25Q0GG3HaiGcVFQs/3bkfUHgoMNdoTtvx40TwqLtl9c=;
	h=From:Subject:Date:To:Cc;
	b=NIizjbIKoWyfmE2sFlmh9sEN0DehUCPkCbBYfwovGioLfEvWnSvnCpNNqNmcPQna1
	 +8B9etjzd8OJu9DBMk5S/Za6aw+pKIbw+4jSCppOvceMFuoKhE9K5iNBc8wV4N7ej2
	 77PdfC0f4gs1FIyKH7qkf9OeX8CYBy/TWH2maZn49S+Iqo0IPa3tdkwkgYX2uuiLny
	 BD7PZPgGWNju+2dMD5RfrJAhvv7lsqZzRXjar9Z1jX7kZxvxV6hwXvQEQmBtwTZuLE
	 DHVQm0amwjtj/9Wei2XVZuNF9peRQJv3U5MWGrMpBR2QzX+yu+gM8nes9PUFCRdYgv
	 I5wfVZ4saWDiA==
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH mm-hotfixes v3 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Date: Tue, 14 Jul 2026 18:24:22 +0100
Message-Id: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMZwVmoC/32OwQ6CMBBEf8X07BraooAn/8N4KMsCVaGkxUZD+
 HdLuehBj7M782Ym5shqcuy4mZglr502fRByu2HYqr4h0FXQTCTikGQ8gdUPvlMDWIUEtX6CUCk
 qLPK8kDkL0cFSOEfsmXUdtGZc9WV9ukd5JRwX8GJvtRuNfcURnsfQ/z7PIYF9KbMiRc5lTacb2
 Z7uO2Ob2OHFJ0X8oIhAURWXKaJUXKgvyjzPby+vmBEeAQAA
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
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7616; i=ljs@kernel.org;
 h=from:subject:message-id; bh=E5x2M+pW0x83+rnlsvaoN0nNZ3diw9k6q4cZIdZs9Uk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCCs45x9ddyas3XK6tt227wv076aveG5053pibcGlW/
 gEltrMtHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIrg/D/7LCwOcTVnB5va36
 vXrfUd2XS7f38sd8EO5+bH/nsdWy3+WMDE3T3X4qKUhfz1kUe8pXjjf2gEm429z6r8x2ik1vDja
 k8QMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 57ti6rshcpy8et4yfzssoi7huf7yauz5
X-Rspamd-Queue-Id: CB322140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784049885-434105
X-HE-Meta: U2FsdGVkX18EtBd6jpclF6hccw62mJbBfgqQ/XDte4cvhKHPNv21Yw25lSLtkS+magU5F1NrVW5os9ogoJ/bt7LcWyoXhGB5JkVe2GryOOtxiGKYlsonw5pjDMWBVOSbzRYoGLf/lUI1FFGnpzMgAE1fKGXDbKQ/31S6R9Ea5PbyD44fBEtYLpb4RH2qcHet30ko/sudGFVNXG8PaV/lbIWis9lVzdXuczpdVDuIj/Zky29x9TL5x7B1UIgPv0iG3W3EBObNzu5AdHX9X2e6Ajn58E5BoIpqDLSGat78LbWMCIoArgGfHdT+cSAwNDjz7btLi5ryj3TX8g0hPekxrvaoI14aJ8gzs/QiUvS3mE/hADs3xXc/N+XAf9fr6w9ZZFA098X2jcsI6wLGF89tk79zp3tFb/u3uoQ3caZirFCy6uOyqK1m8C1MqGw5bWOPnvMDSihYwIYMRrkYelKLRu0Q88FQPEEVvR2Da96UGyO+cDpdtUo31+LkWw1tfZeoiq6JrtVwzvFBBTiiPR1jauM9GU+pUB/NwXgHtU2QaS+8q/vIVmC65bfejWP5P26K78w/0aq5Yg2Oi+clOLAoJB4pvlfYJC2aaYt78YzUVTvJ+gB+ZJ11g0d5jyrG+Q21X9TQX7CikzIGwzXLSiz99zGQbPk4jlTCfHhESqQiDZXjSdaZz+WSYhk2BMA48k9ri8BaJflp+PuG/n1f0NmRwkEDLwROSKa6TKaZT/6oFiB1JwG5AHf0Y/GJEqRS3+t57H+i/98vE//TevxVW+olobL/gKDc8aijZzO6OkZRzQrn5dW+UHRiEDTd/rv7BquVQUhgZT+Ev4mLNMmNvtiVWAUd2BD3A+WC4p7C054I0MzQIgx+T1fIWscOeCt27wfnaRaZxxcHyskLRow4JZqfAEQMUcmZd+Ez047AZvqx/NVM4V60pYcyFSONmWXNUrROQVkL6DFQCsl/LOYXEfY
 h4f5umox
 v2IjaEbk59uuJGaPd8HUyRsfvU4bEHrlzbfWHM/pTwSYzENqaAN1A5esdFPPGjJLDlvYhXh3tetnyv9bQlsydAUVHtk6K6t8nvzoz7qr+YTFaH8wf1ZYKqtyaIYfw4mmyRMhz/rBd55r5TkHXw/XG+FDgFvlOxedwUoQHdByFh0Ce9Qbz9TaQJBNdpWB6B9Jo4nzrxdu4L/PLp4wJpJquke66lM9e0zCjslwewS6fLw0PJhnpaMvfgtBGziUj+LD3vU4hLsWwq2r8FVccPojwDrHFB/geMEWZm8SgLDBTyCpzYRPK9268LSRqt0Gfl+oTq5XuoHR/LYXt8j8XlMdhpYG3O74sDRmgL6fYplT1zMKdNLvnOxYOxx66UlTn3mYbwhfH70SEaa5hXEG+kTUILzk+LmJ7PPJAJ+79w8D+a+zAw8j+D+PhDnuHTKR798jX4PwC9/Id8RjdbJ7YPH5n2OYyooeCMaWKx3/DCj+dQ0ktWZxXYknDa5bw8cMhyH2DmZ7Av7O+Ujt/oTiPHVwj4JxDREQorKuS6uaYEOKfcOAghfyGj/7qsec593qg/arnO4AgKcVdvSjZsGOVa1PiTG4yOyCKvSKvYIV3RMJMmsD/ZKy2TU9Y9h1NydSh3kInFCVI0JU08T0FL6WCCgUXNSPFBTwA2i6HEf4BFuO0WdzZI3VlQyFTd65yT/ixi3Aa/NisoiW+OZ2i6FeR93JpVozfPFJQTCo3tcUt5vmDlx/0RazbYvY+dnOTqyyM408W9kQ15Sbk83PywMPDlnVAVJrrDSBFX4ZdTCY1Gln2wxLOQG39+xv2g5kGhVC/6IX0szybSwOO8d3YprO4qpjWR74Z3zJYho9tBEH0M2ENzocoSMnyr23mIqLmYSWVpctagCzfCmCV7IKksqh4FfnCyzOjydHN+DzOPWHlP/o0pheOUD55pkjlQKDrbA==
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
the mmap lock on init_mm.

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

There are two related issues that we also address in this series:

* x86 page attribute logic, specifically Change Page Attributes (CPA),
  implements a feature whereby huge ranges can be collapsed into huge leaf
  entries. This can similarly cause a UAF when done in parallel with a
  ptdump walk, so similarly acquire the init_mm mmap lock to avoid this.

* x86 and arm64 permit walks of non-kernel mm's (both allowing efi mm
  walks, and in intel's case arbitrary mm's), so we ensure kernel mappings
  remain stable by locking the init_mm as well as the mm being walked.

The ordering of patches is established for both strict dependencies (the
arm64 partial revert in particular has to be done after the vmap changes)
and logical ones (the non-kernel mm fix only makes sense once the vmap/CPA
fixes are in place).

---
v3:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Reworded commit messages as per Kiryl and Boris.

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

---
Lorenzo Stoakes (4):
      mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
      x86/mm/pat: acquire mmap lock on page table free to avoid ptdump UAF
      mm/ptdump: always stabilise against page table freeing using init_mm
      arm64: remove redundant concurrent ptdump UAF mitigation

 arch/arm64/include/asm/ptdump.h |  2 --
 arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
 arch/arm64/mm/ptdump.c          | 11 ++---------
 arch/x86/mm/pat/set_memory.c    | 14 +++++++++++---
 include/linux/mmap_lock.h       |  1 +
 mm/pagewalk.c                   | 36 ++++++++++++++++++++--------------
 mm/ptdump.c                     |  7 +++++++
 mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
 8 files changed, 78 insertions(+), 77 deletions(-)
---
base-commit: 7059bdf4f04a3e14f4fafb3ac35fdca913e3e21a
change-id: 20260710-series-vmap-race-fix-2a4cac988938

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


