Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7220C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C6D6B0005; Sun, 12 Jul 2026 06:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CD36B0088; Sun, 12 Jul 2026 06:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B286B008A; Sun, 12 Jul 2026 06:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13C476B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:44:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66B65C570D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:18 +0000 (UTC)
X-FDA: 84979790196.14.7B6DBA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A057940003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaYc6nFA;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853056;
	b=0m6A5bUgiUJ8kN5OAisWsk/uhcQc1fTTCRyhhFXixLdiotmI84Nb42BYH+/zLC7uJJjMcY
	r6/51I0pvgxET6lhPoBF48XNlV3AhaBxSYGiqlS1JBuwPIUaHaQVVaFnTHzKlcSPQitdcm
	MRIVbzpSks5OmcO9U/WI5C4rdtECSxU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaYc6nFA;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=n5Y4kSef/beYZfYsug/ValOYyvl5bXs5MyYCHxnTyIU=;
	b=tMREkUyKK8qcGpGsw8HEw7BA1eVWcbtJHyyxOYyKi5Wu08jxBTklKMC0lgiZ5QbZqngIQu
	pLiIHjEdu5tVk26giNcvE0+/8RvF9BUBiGWW2TlVrektLxPrYd5kX1eh5xRLRU23zXaNXE
	xWV4FSOGekAqWqVFtME9rGURiKxgSOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA1D76004E;
	Sun, 12 Jul 2026 10:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A801F000E9;
	Sun, 12 Jul 2026 10:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853055;
	bh=n5Y4kSef/beYZfYsug/ValOYyvl5bXs5MyYCHxnTyIU=;
	h=From:Subject:Date:To:Cc;
	b=OaYc6nFAMKMaV/JnB4SRlLS0mhdgISliANj6s7xPbY7ZhsbNGp5lcfhnQknzmBdTP
	 Pygl5zOgh+i/GhnXd3ObgnikSBdScNxBpePj4iR++ribG9Y2zFgdXwOu4pxoUKWo6M
	 TZydcxNAiVOAWLDSDfqd7UN17lXm1fzBp59hne5n35B7K3IhmZpoTZFR4ghHsd/UN6
	 eCVxW7GDo6XS/YrhsgRPAWmJcWT139kDgrl9trHrV1AxEwzqnM/8gURGoaZ6T3QaVB
	 BXJZVZJXhQfiRbPEtyqTWN9W79YbOBJTGxlRUGmMcAziz6/xk6AChbIP0eSj/5EhOR
	 nQYWUwcnrjNBg==
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH mm-hotfixes v2 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Date: Sun, 12 Jul 2026 11:42:23 +0100
Message-Id: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI9vU2oC/32OSw6CMBCGr0Jm7Zi2oIAr72FYlDpAVSiZYqMh3
 N0Ce5ff/K+ZwRNb8nBJZmAK1ls3RFCHBEynh5bQ3iODEuoscilw92Po9YisDWFjP6h0ZrQpi6J
 MC4jRkSmet9ob9D12btq52kX/rh9kprV4tXfWT46/2xNBbqH/e0GiwFOd5mVmpEwbuj6JB3odH
 bdQLcvyA3plZjrYAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7382; i=ljs@kernel.org;
 h=from:subject:message-id; bh=94ohPt19KBXdpXV0tk2uctqp6WqGAL7X+3ddUv8veLk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC8z9E9Gf/vGlxmXUOh99F3YI/Nd/4vrF0fX6eNe3o6
 YWyP3YwdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAisRGMDHPcXlTGzHbscfwp
 /lw4T/u9zfUXVw+6vTM+vM/37T/WO5wMf3ivLRX9oL1bYuM5KekAdoEPW95v/G/ScdypOiC1glu
 EmQEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A057940003
X-Stat-Signature: 7549wiin1n81jm6a6pikas37ch753tka
X-HE-Tag: 1783853056-842398
X-HE-Meta: U2FsdGVkX1+jLMwb1JAJZ7Nn0yUGn3oeA8we5fu1Hz/O6Sj1miMY1ldFlCTdyHTi6UFlENHxXm8mVcx3RAbqwqfs+N66gzkR23SMdzuluSkhUD0k80wSLYaymjKpp3/jBdA6T+PxBoa7PKUUxzy87nHZB+clSeIKs8C2XgKyBgfbyGsMISHlZZKUKk9xY7MejK9pEy07YEI1VIqTAfvq7uY+qrLBP3oy8rXictASGuzHYHakFq+LudzxAhOUQhKLHd+0jpN/Q3z1OuGQYjNp0qzKl+viaXMYE2OA33OkscjVKScVVDvdMFM0/GvuBwEnvMHMbI90uq1/5z5F1thpg/pLdvTZxZQFxdeAwwIKfIOZ43Xq+9FFGa+ktRvmvbgoCRoBHHhMP72CtA+UB2XJ43qyy10DkX0zH+aoNxMXj7PoEhaOYLNTy/PRa7mLmYgx7QChXhfzwsqsKy1qHwjvZWPO/3vOORid1Cufe7AVF9KGgMGtU6WbT/cboWEs/QHijqlgQo0fDdLHFkJUyHfzEQo4vZUDGpT+eaDrIY+3R6svnpaAM8rIr7mOHrI1cYsWDjtL572H5RVevyI/yS0r8AQ6pfAePcUj6/rOObK48RWqNELyiGZ1GoALhr1k0Q/04xKpRujz+OJKbRlnVf+s90C66Cn3PJdUyC8EOjHai+C2i1CX/nOgzxrkLCOYlffC/v27PjrhncLBrPIGZeqXwOIlVaCalNRVWu9ELi50IkVx1ejFZOHGbxN4wCGoQ6qLQb64JT3GLvBMBWtrDk5ZyTYxK6EJFfCw4Gy0O0RHqWxMSL7L2itwSO9LA9QxeB3ftN0vlfCQhTnfj4tu6EADHgEAa+DMMjGXFf6xpsjn0kF9FwHgySF2JP0V5nuSzHmlopSWIFBsuXeYguTse/614vny6nBywtxNmYvalkUcEWqk41aijLxmx1ZssWCb8c2v6zd8NGrNUZ0VGGCEM0j
 ucesc8LR
 a0gYKVuXTTuBsr+o97ZBt8wPZ/hVUqRGBOR7rrruKosayuTlZbXnHIbjsLSY2/jOrfsHCFgrHj89TIv2lfipVsN2uxlH/xWxbUA/uny04EKAetrVmyHe37rocgT1mdqxDXMMpZCv/V949J2POF6v16HFv1x3Awlj0+iKIjBII03ZICa2GRgXFB+9gP2TvRmKUPCIR2teW2kkr306eE3v/dkswGpoBhQakLM90pnKksGbaYD2Eu5s34NsrjOwd3o/129jOk3LE44RL8sdbRYy6QUi9hlcPByIYkk3V8V9yMmJiN6XGBm5MDsUKcdKXXEqrHR54s0UJ+FduSpuV7uhuXXBZEvZ3Q5SDT14lTgWBZ+92AmRFj3BBaUWe1k8d8tfvvD2G4AzeeUF+rzTSM1dU/ImYz8iHzIHb6lVWbegmGo8JuKoOz0i/rW6LCY4heJKRxJ7LpJiO59dIio7Iytl+9DTvkf+kVWL+W95AkvjHzeZALwiJlLjdJEaGAQXERwjKkaOs1khNGq7R9qAn0Spw33UNPUqq/pLUklkEL3mSIlXG1mFgbGbsg908f7tyw7V7q1T6Mb6zE10N5ZfwbtBMAQ7BzirFfLo3c73Cl77dKUoyvnCTQtaxe0ubv28xAs7s5RAU0zaf0hK8QAmZi2VfSXg4bXL6PwT/rKJh5Gqs+GUUwZGLeGerZPx5K2gLcMsv41hq3vmVNEGHGCqBfBgI5ZgQTsCU2rDfcxeEjXqY9Ei+CuE8G2S3/1+f06pfDq6PaO1lzFIONohp3nmln/M2isps7895dKRx50b/tAoaOAkyHgTe4I2PMExXztAoPEIbFpIT0Kitb2fJriO2EJJWrqiW0Wdb3uSoMarmPPVTKmEaYDvHhy+6Qm3NlD6ptCLahXLoD9FMK1bcajkUldec/WPQjEHpqwmGqDGn8/tw5ijWl8ndiY8g0nA2Ew==
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
base-commit: 44696aa3a489d2baf58efa61b37833f100072bee
change-id: 20260710-series-vmap-race-fix-2a4cac988938

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


