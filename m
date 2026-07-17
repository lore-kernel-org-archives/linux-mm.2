Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF07C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6096B00D0; Fri, 17 Jul 2026 13:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BC66B00D2; Fri, 17 Jul 2026 13:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9756B00D3; Fri, 17 Jul 2026 13:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8287C6B00D0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:30:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 148C01401CF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:30:51 +0000 (UTC)
X-FDA: 84998958702.30.971E990
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B3E4160006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:30:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+fatTfH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wY6QUhrQhDzSQAZjxHyiyWnuSRVxpYdGoInIwaX4suY=;
	b=WcJsvAXrxie70RNRnpUxhEho2+dY1DZXenkczCvb8pwaYepsnxefTgPEfDLNQDTEGxMog8
	YNBOygc6k5SfR3QMdhsgQMQhX54Rvv6DnK3VKMVIaOqN1Bn/rgnR5ccZJL4iwLKrY7sKRH
	hokY4/706XrDYB2JVAe7lnhOvc2IfzI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+fatTfH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309449;
	b=Mq3ZLYufSOOrhZtv652Fc1+z2WwSQIL6iPX1o+1vMkAzjCD7l1xeOuWBskzQM5dpTpipz2
	v+6wN+zj2d8J8/zE3nE0mJmv+EhO5attNdfipBBpQi6qFuFFY9R6uaH/jo/UNDluibV5MN
	ogc9jb73WjiKpO16wf7x5pPmSDFp5as=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1DE600DA;
	Fri, 17 Jul 2026 17:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57CA1F000E9;
	Fri, 17 Jul 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309448;
	bh=wY6QUhrQhDzSQAZjxHyiyWnuSRVxpYdGoInIwaX4suY=;
	h=From:Subject:Date:To:Cc;
	b=P+fatTfHkyZ8PVMn/q11PVhx2HWXrgHBgF4rveGi8OulKI91SS3YVOvax+FdVKIYl
	 aInNlOHz7DoTZoB6XbdZ/VRwEqOsRoQIpPhpWN9LnRveZYIG4hu7slEsbwyUrYw1Eu
	 EzrDedDY55w0YQQPFGFIcdm7R8QNVYTzxyTkVFeBvBb87BwnM5wkB573z//+XDQaXJ
	 QbaKU8GzZ37Rj4Ab4YP3h3SH6nk/qQ08rJQQwWeNwwKv7NX99E5MvHExUGTygMX4OY
	 xW8RDZlJDaRdfaHwKAgac6MfZ2ymwo7njiI1ajw8ZBijEVTrkjTttyPNf7ol5oTcnc
	 DjDdFIK2JSsGA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH mm-hotfixes v5 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Date: Fri, 17 Jul 2026 18:30:06 +0100
Message-Id: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ5mWmoC/33OzU7DMAwH8FeZcsYoTrI13Yn3QBxS11kDtJ2SE
 oGmvjtZeymayvHvj599E4lj4CTOh5uInEMK41DC8ekgqHPDhSG0JQsl1UlWKGGdh9y7K0RHDD5
 8g3KGHNXW1tqKsnqNXMoL+yr6HrpxWvPb2kxfzTvTdIfv411I0xh/licyLkv/38sIEo6NrmpDi
 NrzywfHgT+fx3hZbmS1VdSOooriWtSGSDtU7kHRW8XsKLoojUXFRN5JXz8oZqucdhRTFEsoLRm
 NVev/KPM8/wKVvrqqqgEAAA==
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
 stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8612; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Vl2DeNmZvUsPifcDZmp2eUptrFlUVAtjBOFjjxW83Yw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0ra5BannFLw1emnFoVDWJHH//MdN1buuzmO3zl6yw
 /frAn/ujlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkgiojw/ssnjf3fzT3GfnN
 vqZwf7Zt+bcLfQtm/jx/ivX4jqgHJzQZGZYfbTVLUM3dbi2jt+rH47gqDT+xdL17gREKWSvzO/g
 9mAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B3E4160006
X-Stat-Signature: qg841wohr9hscu186paxkdc54ct3ee3i
X-HE-Tag: 1784309449-537751
X-HE-Meta: U2FsdGVkX1+JGKgRvHlSeeHNEOGFacdXagBCJuuyfD7viO6Pb7Nijohae1ZftDfGid15G3U1YaFBDlw+c9q5jzTQteqdXGFLsUfG0s0hsfZnh7IvqOS/RxEBotRVSggizssaoDQtDCXASzPyozItu9/RqMc6PhVKtsre8JgixFK9eH2xhYUGYg0jEsF2NVsQLiGKcOdms3sn3gnk71Q6eIS1OZtSAvUQgjsil6TVfcKrTAn3so7Lvn6dl4/fDYmUT/qW1FixLrTR/k9eaKk13JDAy+etjZrMHItmNd1XZjZYHh4D22M8VM6kR1Xl0ZktR6sIUTx4UXhia32rsj80zVjXhDXK8SYYfHaBmkV4ao29NhuhZ4WFaYq0uPmm+wmbi4SlLzNYmqH7z/ONKimYrxgIPHaBndafOdXWrQDcoH+J5aMBRroq68MN3bbkrVzvPiBoLTFgHqeszEx/KJwzcEQk6Y5P/8ckt/t8yxYC3J0HkhQ31L61wG8nmv6lIY9QMmjEqWlNjtGxdnUJEwCguG49pr3SPiqvvmN8h26nFhsTiXzg6Y1rrmKyz3eeLg1tI9TbMn94vSvRIluJnkxa5fghVi9favipcSxMOcUJ2aLbF3KMqaiE+TZKLb0nGiR4F05GrPdFYEyjE/iEq7G3IV/hT2Kh2j13XrPLzTxFH7lLaiG5GhSW3Tm6lT/7QH68RciGwv6NFI9kbg2l471R2ArKaSQ/eh/Afr/6KvupEpoWktogidN22PpvWexHsr5j9o62v2y1OYl7617t36u1E2VvCJEwfqah87YFeTkAzL21Sh/nsGCdxl+QuQBXpx6ZDpT56OiNEmoyB6UMW3ZAhzUBEnrcLyQ8BL7Du9fbsYbiQL0OYbgCNMs2mxvDVAdQkSyUDA279Doh/IrtYyJe60OA4/Y9YZfJ7agPURrZreMX7n4036Fori5ONyXFoGbkudcb5e7lBs6xdBC2mXg
 y+jO/Iy2
 HCttGSqVIIGH07AF+qlmO6WYqk8vcHHIh5DSD9HtNtTvkK/dVxErVEiWw9kXVj4ONBIp+Fgy8O5wwLjKlpPlF+O9/vNS/vZsLoYd3l22bb28ffYevXCNWFpUS8xK4ZiPIMrcY1whjDHfX1OryPVNATSg9zQhtxKq4eRlG9FYSRWSfIJr6msQ8SBirGl0Yxw0F+mjgd7UDiVrRMmtDvMUxkDxAClrdi3pUBcKrUgVIPen9kOFTm7S9HsyFG2gL/weXQRhMpfEQEQPNytdvZzy/laWcf9sfG77ZMJfoe1dC342kOhovGferlDktQ7314Ocx0gyFb0ippaebw5V6fE2ILcAXtrJStqUsPKjlsp/UMRfcnwqkkvShBCNNpnj1JR03JKVQhhpp8SbvR1BME78zrL0SR64mkAOf1vmSvhENjHX41zCltecjvlNOWyChpPYba9F8juRs12xLUws/SFHj7E2LhCCTDsgxjzPCFLrTtWPXtm1ht1tsDct6PTW48UkasXvT/FCB80IghHMx/Y5IVRBuyiQW8TnIeY0e4zG9fqXsjr8+YgIM0LFFRprToDGTAi50z4s48Ij31wsKUp21lX4vWHbk54jrfK2DSr4tHwPUvHH1Rvr490zow9Tf6eRhu33r+W2VXYugh7i20Ttn2rwVesuKwg2tU8B4kJSrsKcNXR688iXrasPXo/ZRcasg8AFSgc5xAbYzxaSMWcRFaDQCFPtGNJVBKahHcqR/NlUZZphZ80lCbT59c5lxxgtFaR5pl7I/gnEskdArlX8AN7ONwp9iXjzuFZzR7cC6GvEcUehDn5bN4Ke31oe7mfQgXQO6S3+daKtgP1USCdRl7CJUL5ciZf1J41j8mbcT3rqskdOrR6XzGgrz4NoVW429NYQfstMD/rVxya4qtcLoxAzBpsxYKDakKGsTHMYIaLF7MOfs+WSGTFXCs/kG5RbbVeFInJZ9uuX7ErCc+UzmUiuFswT1
 jvyrRzVO
 k+iFQOB0m0k=
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

There are related issues that we also address in this series:

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
  walks, and in intel's case arbitrary mm's), so we ensure kernel mappings
  remain stable by locking the init_mm as well as the mm being walked.

The ordering of patches is established for both strict dependencies (the
arm64 partial revert in particular has to be done after the vmap changes)
and logical ones (the non-kernel mm fix only makes sense once the vmap/CPA
fixes are in place).

---
v5:
* Rebased on latest master of Linus's tree.
* Accumulated tags, thanks everybody!
* Added additional commit to fix race between CPA collapse/attribute set.
* Slight commit message tweaks.

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
 arch/x86/mm/pat/set_memory.c    | 19 ++++++++++++++++--
 include/linux/mmap_lock.h       |  3 +++
 mm/pagewalk.c                   | 36 ++++++++++++++++++++--------------
 mm/ptdump.c                     |  7 +++++++
 mm/vmalloc.c                    | 40 +++++++++++++++++++++++++++++---------
 8 files changed, 85 insertions(+), 76 deletions(-)
---
base-commit: fce2dfa773ced15f27dd27cd0b482a7473cdcf2a
change-id: 20260710-series-vmap-race-fix-2a4cac988938

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


