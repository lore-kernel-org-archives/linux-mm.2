Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C27B606EEBA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bZ2KIOpA
Received: by kanga.kvack.org (Postfix)
	id 35AA66B05B1; Mon,  9 Nov 2026 11:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B7B6B05B2; Mon,  9 Nov 2026 11:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABEF6B05B3; Mon,  9 Nov 2026 11:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5BC76B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DF55C0722
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:38 +0000 (UTC)
X-FDA: 85416043356.11.E5EE95F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0986440007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bZ2KIOpA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240036;
	b=Or2mimy95vkn//KdPrlg8sCe06fi7lH7A7yDPaXQ4KZv9szOwz0vxx1/0sQeDU/hemFNU6
	IL27qdVgVRXqhCEPj5ljGMLhgXLlq5dsN7xAb/ZuhRvBNUoPDgu4FzF42ecuLozSJ6/6Gp
	pfMemTOC2G6C8B9H9R5PfyUjc6BDkzo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j85UUjsOkrxRuMIKLFyPR0PAJBGInqiJo0m4YMdMdsk=;
	b=P40hyPJn+SGhDNTowVZgpJ1IKNeYP5BHdEdo9Kxdc/t8n6SGafLxdZwWqlPPeACROw9FLc
	ukAtaWqtGiiG2ZxT7E0rrTG3RP2Vmb0sqX8oijLepPQn0zAhGm8MzmxhXo0oU6m47o/iuz
	5C76RQeT1xhhPAPeH/WiW3v3Q3+dUIA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bZ2KIOpA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF9BD14BF;
	Mon,  9 Nov 2026 08:00:31 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E23243F632;
	Mon,  9 Nov 2026 08:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240034; bh=pMZFOiz64UQUHSSEEmoSU9xHsynil0yjdgf2voVSnQY=;
	h=From:Subject:Date:To:Cc:From;
	b=bZ2KIOpAd062Ggy86p9HfuiEd3w+/iaEEY0GIc+xkrTWBoD5E2qDQ9al73dN8TjqQ
	 jUsHhyidpfNRGavETpOF7F1WkOhzakyKzqw3UyOBwmeL45jTPhgcdhgoLz1hfZ0xzC
	 KTGxjNUIOvODdRXLYASnXHB2pmzn1KlgM3ewI/gA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH RFC v10 00/22] pkeys-based page table hardening
Date: Mon, 09 Nov 2026 15:58:25 +0000
Message-Id: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1WQwU6FMBBFf+Wla0vagdLiysTED3BrXJR2kD4Cf
 Wmxkbzw7xaMoMu5mXPmZu4kYnAYyePlTgImF52f8sDZw4WYXk8fSJ3NAQEGNatA0eE24BIp8lr
 UleAAhpO8fAvYua/d9EZeX57J+08YP9srmnlTbGtd8COd+4D6tAJILoXgqiglKCYE5XTIXaaiD
 d7GYXnSYSyMHzdB7+Lsw7IXTnK/tksEE7/VkqSMAjOstbaRvJEHv3VK6g8E9QGpDKHW2lhtTC3
 Nf6g5IcWPJ6QmQ7IqtS15C0Z1J7Su6zcZBzToXQEAAA==
X-Change-ID: 20260428-kpkeys-e165645122c1
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=32617;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=pMZFOiz64UQUHSSEEmoSU9xHsynil0yjdgf2voVSnQY=;
 b=ZZvJOyOrTIPdtQBgIpx6AQW7id9cyNpCxl9AecZWHuIuQdV1GBBLcJcTIp8wtrZ8ME41pQqy2
 Px7WQxOnYX3AjMIoaaYimgNG3j6AHLfbP28/2F9NWjlxzrq+ycHcQCF
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 0986440007
X-Rspamd-Server: rspam12
X-Stat-Signature: si5hd6cb3yhsabn1uygd7bpj5wdoia1y
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240035-812833
X-HE-Meta: U2FsdGVkX18+HSFdSu5FckGZ7m7lh2L6qYhRA5d21hOBaYRrwMMspQn7GUPaFZsSFX1iY6/dUQ6cCNZh3b8IFl6uimgDMdauwp6LjaEkVzJyg/K1xzBLbQ+JukGvtx0FLm6hlFp786KuDioUxF6D+A+jTI1Bw62ZupjHqmmHEQvQBpKsqhCnr8ZDJCAOKuBLpwQ3E9DbLHLWUVhCZQ00FruZzHlgm5ZDecdJjlHAA9gfA46QMKch2M0guAAdSdVol+Dn25uAXOvA4weLxYZAbp3HYJk1BYsfnKsXM5sLbStYdoSAgfAHT+BfR5BEP6sv+8PIPxEJ5LWaR+zn3nRWGQHKU3rVoiPXC0rl83O61Z82DEzSIMLnq8E3QwkDL3iPkj+Mooo01ybxfaJ5TuEuPMg+ZUC13/Yg+xDMUDvQQVRQOEp64d5whyHo+hcrWsJjgY4IQQfTJaln+CqPARQjMBzetNvNoQsYeUauVyBBAgeSiUFeYYm8hBlto13ZjU0JGH+iH0Yxe9CzfsO5ePj63gvLW10EXURmgtSyrNzlH4bGg9JRFrDRvTVn2+necw7AzD7kEAaSBYMFBtK2uHKK2LcoEZ+hpgjobmC7SSwFkt+zWpShNDXxB2Oai+ISXnaMBJJg3l3T0QVjiRbdLy8VhdX38hPHs8ejLJA8ZubiaR1g5YDbZEKyPMGx8eh3wrUtGDwTymQ0IESL4kA5/SgVXXnhW+roxWtgVpKW4H4N18lyDxIjp843FciVjLEgeKUEyIDqwkrniFzhv5LWEwdJ27l/VULR2LxgEtVXo6tRyJ9YB9/h6RUuV85lRvQZn5QfW0o1gp9zHoKuuf+MKMtFB2ZTW7XQ6VR4koU8YP0Ywfky1Dlf+cqTL0zD91IGLv3ImtOlInO5JYIGSyVtCuiKzUo5qqSpNjOOMRXijSKgydcqdEViKDlCUP7s6vGO2/xQ0mer3sQOTncekIoG2QX
 r6YYolV/
 4USfk5LfVU9bipcUsgzy8Clof9nC08WOHKEwX0Iho7m+wA7r6G6+mZP3m7qFFHHa/fRxP1TIsQ+J/tGnKzGvDwO/dabDgE/x6Ju/inoNQYVSp9MinZNzp1t/vnnisJXoCI+J/PKYu15CsbBtMDCZzvCXMGA7BDPjFekvNinhU+urZGidRVTN1sy1EHbmpOh/tCMxzdGHG8mwqNzYAUOjfqWTovcGsL5getLhQojXgCxgTMmSDheAOGHXCmuW48bjr94DARPfTs71/zy0Jw7dBOs2mBQjxfY1kLcrdPCxgjj19yNQ/+eSpJT17n8FW9twbxgDJ4poahKH+efjvQezMTaFGYuYSkDTdZNrJ5m6868zU3h31njcZwN3LbglKFPyooT8573lhTSVXpmDknqNXs42k0jCoZK2yllcb1NSWNUtmjwTXq0yRaUrVjW/wqL4AD9Eo/UtwwbgQi4RNRmSbh1BgqLi4paDrQkDklAr5nzVA7RPprUqclKwXhQdxOT3YqdBdOycb6EswDlCikayMhviDr8+MNFayiQ0BrRxX/WHzMr7vQWaR//ImGOQgrGNteasymX30ab7Z3RvosXDtqJ1J9EHcvyqdrJoF6BVa9RYutzdng51jJ7LXIWuTzScA6onMjgRYrfhuaiwHGKoG7kgn2g9nIcn14hnb2D+aPjFMcS+RhPYBa0LL5k1dRaXLgyly0siHxFDkHbxNkJvNK7AM5UnG8Vwpbpf05cyS6c+ez8dyAXRdoCo0asMMoj+Vz1MBkHczxXxXahayET6ZxMWojTugUu5bWC7lYgAmRyEGVtaeohjZey9MaFlNf/VOPInr14bmEYy4q8TBo/IyVgUaY4gPU2rJLLodjosvNoEKJPY3GnOstGhdXsy514uBjRacXQk1q1AViMJvjpF2SF8ySLqQ7XPSgxwou58t96Lr8nXJ3Evk1mu5s3ve4PKGiw+lLPhrO/q6a+CdL6vH4B4ArhJ1
 ZDdALROI
 wQDtR4Ev0ZNOYTkxj35Eq20D6Bzh6dHbQn9zDohnJ+cXd2FAbZCjijIkvGg9xHCnbTHvTDJUIu+mlRSOUx5TENem8zioIRtVcnHD9YW3JxD3FIb95iUBQQ2zsb2PY76Gbhh/QKajnuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NEW in RFC v10: less invasive approach to protect early page tables
(see section "Page table mappings")

This is a proposal to leverage protection keys (pkeys) to harden
critical kernel data, by making it mostly read-only. The series includes
a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
as well as a page table hardening feature based on that framework,
"kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
concept, but they are designed to be compatible with any architecture
that supports pkeys.

The proposed approach is a typical use of pkeys: the data to protect is
mapped with a given pkey P, and the pkeys register is initially
configured to grant read-only access to P. Where the protected data
needs to be written to, the pkeys register is temporarily switched to
grant write access to P on the current CPU.

The key fact this approach relies on is that the target data is
only written to via a limited and well-defined API. This makes it
possible to explicitly switch the pkeys register where needed, without
introducing excessively invasive changes, and only for a small amount of
trusted code.

Page tables are chosen as an initial target because of their especially
critical nature - a single write may result in arbitrary pages becoming
accessible to any context (including userspace). In order to keep the
series digestible for reviewers, this RFC focuses on functionality
rather than performance, making it most suitable as a debug feature.
The key trade-off is the requirement to PTE-map the direct map - see
section "Page table mappings" for details.

This series has similarities with the "PKS write protected page tables"
series posted by Rick Edgecombe a few years ago [1] but it is not
specific to x86/PKS - the approach is meant to be generic.

This proposal (as of RFC v5) was presented at Linux Security Summit
Europe 2025 [2].

[Table of contents]

* kpkeys
  - pkeys register management

* kpkeys_hardened_pgtables
  - Page table mappings
  - kpkeys context switching
  - Performance

* This series
  - Branches

* Threat model

* Further use-cases

* Limitations/Known issues

kpkeys
======

kpkeys is a simple API meant to manage a subset of the protection
keys available to the kernel. It is based on the notion of "kpkeys
context": a simple integer that defines the permissions for every
pkey managed by kpkeys. Other pkeys are unaffected by calls to
the API (i.e. their permissions remain unchanged).

The use of pkeys involves two separate mechanisms: assigning a pkey
to pages, and defining the pkeys -> permissions mapping via the pkey
register. This is implemented through the following interface:

- Pages are assigned a pkey in the direct map using
  set_direct_map_pkey(). This is sufficient for this series, but it
  is also plausible for higher-level allocators to support marking
  allocations with a given pkey.

- The pkeys register is configured when switching to a kpkeys
  context. kpkeys contexts are associated with a permission set for
  every managed pkey, for instance:

  KPKEYS_CTX_DEFAULT:
        RW access to pkey 0
        RO access to any other KPKEYS_PKEY_*

  KPKEYS_CTX_<FEAT>:
        RW access to pkey 0
        RW access to KPKEYS_PKEY_<FEAT>
        RO access to any other KPKEYS_PKEY_*

  Only pkeys that are managed by the kpkeys framework are impacted;
  permissions for other pkeys are left unchanged (this allows for other
  schemes using pkeys to be used in parallel, and arch-specific use of
  certain pkeys).

  The current kpkeys context is changed by calling
  kpkeys_enter_context(), which sets the pkeys register
  accordingly and returns the original state. A
  subsequent call to kpkeys_leave_context() restores the original
  state (and thus the original kpkeys context). The numeric value of
  KPKEYS_CTX_* (kpkeys context) is purely symbolic and thus generic,
  however each architecture is free to define non-default pkeys
  values (KPKEYS_PKEY_*).

Note: the nested use of kpkeys contexts has to be considered
carefully. That is, while running under KPKEYS_CTX_FEAT1, switching
to KPKEYS_CTX_FEAT2 may result in certain pkeys no longer being
accessible. If need be (for a potential future use-case), the
API could be extended to allow certain permissions to be
inherited rather than overwritten on a kpkeys context switch.

pkeys register management
-------------------------

The kpkeys model relies on the kernel pkeys register being set to a
specific value for the duration of a relatively small section of code,
and otherwise to the default value. Two aspects should be considered:

1. Exception entry/return

2. Thread context-switch

Ideally, an implementation would switch the pkeys register in both
cases: 1. reset it to a fixed state on exception entry, and 2.
context-switch it along with the other thread registers.

In this series, the arm64 implementation only performs 2. i.e.
context-switching POR_EL1 per-thread. This ensures that each thread's
pkeys register is preserved no matter how a thread is rescheduled
(voluntarily or not).

Resetting POR_EL1 on exception entry proved problematic for the
kpkeys_hardened_pgtables feature with the lazy MMU optimisation (see
next section), because page table setters may be used immediately
when a thread resumes after being rescheduled on irqexit, before
exception return. If POR_EL1 is reset on exception entry, we may end
up in an inconsistent state where lazy MMU mode may be enabled but
POR_EL1 does not allow writing to page tables until exception
return. For more details, see [3].

Having the entire exception handling inherit the interrupted POR_EL1
is not ideal as it increases the amount of code run with a
potentially privileged kpkeys state. It may be possible to pause the
lazy MMU mode to avoid the issue described above, but it isn't clear
whether this is a general enough solution.

An important assumption is that all kpkeys contexts allow RW access
to the default pkey (0). Context-switching and saving/restoring
POR_EL1 on exception entry/return becomes significantly more complex
otherwise.

kpkeys_hardened_pgtables
========================

The kpkeys_hardened_pgtables feature uses the interface above to make
the (kernel and user) page tables read-only by default, enabling write
access only in helpers such as set_pte().

Page table mappings
-------------------

Kernel page tables are required as soon as the MMU is turned on, i.e.
extremely early. Different allocators are therefore used to obtain
page table pages (PTPs), depending on where we are in the boot sequence.
In chronological order:

1. Static pools (in the kernel image itself). Typically used to map the
   kernel image. By definition these pools have a fixed size.

2. memblock. Mainly used to create the direct map and sparse-vmemmap
   page tables.

3. Buddy allocator, via pagetable_alloc(). Used for everything else,
   including user page tables, once available.

No matter which allocator is used, this feature relies on the direct
map being modified to map PTPs with KPKEYS_PKEY_PGTABLES. If large
block mappings are used to create the direct map, blocks may need to
be split when setting the pkey for individual PTPs, which in turn
requires a new PTP to be allocated. RFC v6 introduced a PTP
allocator that both handles splitting and minimises it. This fairly
complex component was removed in RFC v7 so that reviewers can focus
on the core logic of the feature.

The present series therefore requires the direct map to be fully
PTE-mapped, so that PTPs can be individually protected without worrying
about block splitting.

The different sources of PTPs listed above are protected as follows:

1. and 2. Early page tables: when the feature is turned on, the
   kernel page tables are walked and all backing pages are remapped
   with the appropriate pkey. This ensures that all installed page
   tables (for the kernel image, the direct map itself,
   sparse-vmemmap, etc.) are protected. This simple approach is safe
   because we know the direct map is PTE-mapped (no splitting can
   occur while walking the page tables).

3. Regular page tables: directly obtained from the buddy allocator and
   their pkey set right away.

All this infrastructure is generic. This series only includes the
required plumbing for arm64, but it is meant to be plumbed into x86 in a
similar manner.

kpkeys context switching
------------------------

Page tables are only supposed to be written via a fairly small set of
helpers, so only a few switches to a privileged kpkeys context need to be
introduced.

However, a naive implementation is very inefficient when many PTEs are
changed at once, as the kpkeys context is switched twice for every PTE.
On arm64, this means two barriers (ISBs) per PTE. This is optimised by
making use of the lazy MMU mode to batch those switches: 1. switch to
KPKEYS_CTX_PGTABLES on arch_enter_lazy_mmu_mode(), 2. skip any kpkeys
switch while in that section, and 3. restore the kpkeys context on
arch_leave_lazy_mmu_mode(). When that last function already issues an
ISB (when updating kernel page tables), we get a further optimisation as
we can skip the ISB when restoring the kpkeys context.

The lazy MMU mode may be enabled/disabled in a nested manner. This is
handled thanks to [5] - if nesting occurs, only the outer section will
switch kpkeys context.

Performance
-----------

No arm64 hardware currently implements POE. Benchmarking has however
been performed on a mock implementation, which should be fairly
representative. On a "real-world" and fork-heavy workload like
kernbench, the estimated overhead is around 2% in system time, while the
real time overhead is negligible. Microbenchmarks focused on
creating/destroying mappings yield overheads up to 15%, but typically
much smaller once batching kicks in (when modifying many PTEs at once).

For more details, see this section in RFC v5 and v6 (linked in the
changelog).

This series
===========

The series is composed of two parts:

- The kpkeys framework (patch 1-10). The main API is introduced in
  <linux/kpkeys.h>, and it is implemented on arm64 using the POE
  (Permission Overlay Extension) feature.

- The kpkeys_hardened_pgtables feature (patch 11-22). <linux/kpkeys.h>
  is extended with an API to protect page table pages and a guard object
  to switch kpkeys context accordingly, both gated on a static key. This
  is then used in generic and arm64 pgtable handling code as needed.
  Finally a simple KUnit-based test suite is added to demonstrate the
  page table protection.

Branches
--------

To make reviewing and testing easier, this series is available here:

  https://gitlab.arm.com/linux-arm/linux-kb

The following branches are available:

- kpkeys/rfc-v10 - this series, as posted

Threat model
============

The proposed scheme aims at mitigating data-only attacks (e.g.
use-after-free/cross-cache attacks). In other words, it is assumed that
control flow is not corrupted, and that the attacker does not achieve
arbitrary code execution. Nothing prevents the pkeys register from being
set to its most permissive state - the assumption is that the register
is only modified on legitimate code paths.

A few related notes:

- Functions that set the pkeys register are all implemented inline.
  Besides performance considerations, this is meant to avoid creating
  a function that can be used as a straightforward gadget to set the
  pkeys register to an arbitrary value.

- kpkeys_enter_context() only accepts a compile-time constant as argument,
  as a variable could be manipulated by an attacker. This could be
  relaxed but it seems unlikely that a variable kpkeys context would be
  needed in practice.

Further use-cases
=================

It should be possible to harden various targets using kpkeys, including:

- struct cred - proposal posted as a separate series [6]

- eBPF programs (preventing direct W/X to core kernel code/data) [7]

- SELinux state (e.g. struct selinux_state::initialized)

... and many others.

kpkeys could also be used to strengthen the confidentiality of secret
data by making it completely inaccessible by default, and granting
read-only or read-write access as needed. This requires such data to be
rarely accessed (or via a limited interface only). One example on arm64
is the pointer authentication keys in thread_struct, whose leakage to
userspace would lead to pointer authentication being easily defeated.

Limitations/Known issues
========================

- The direct map is forced to be PTE-mapped; large block support
  requires significantly more logic. See section "Protected page
  table allocation" and RFC v6 for a possible implementation.

- The fixmap page tables are not fully protected. Walking the early
  kernel page tables ensures that their direct map alias is
  protected, but they remain writable in the kernel image. bm_pte is
  normally written via the kimg alias, so we should change its pkey
  as well. See also Ard's series protecting other levels without
  kpkeys. [15]

- This series hasn't been tested with KASAN. When enabled, the
  kernel page table walk in patch 13 becomes very inefficient
  because page table pages get reused by shadow mappings; these
  additional mappings should be skipped (like in ptdump).

- This series has only been tested with 4K pages and 48-bit VAs.
  Other configurations should work just fine, but the tests make too
  many assumptions (as reported by Sashiko).

Any comment or feedback is highly appreciated, be it on the high-level
approach or implementation choices!

An LLM (Codex) was used to generate some portions of the code and
commit messages; I understand and carefully reviewed all generated
contents.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
Changelog

RFC v9..v10:

- Reworked early page table protection: walk the installed kernel
  page tables instead of modifying early allocators. This approach
  has several limitations (especially if block mappings are to be
  supported in the future), but it significantly simplifies the
  series. [David Hildenbrand]
  * Patch 13 implements this approach using the pagewalk API,
    protecting both statically allocated and memblock-allocated
    page tables when enabling kpkeys_hardened_pgtables. (The same
    approach was used until RFC v5, see RFC v5 patch 10.)
  * Dropped RFC v9 patches 10, 13 and 19, which introduced and used
    the dedicated early page table allocator, and patches 15 and 21,
    which introduced and implemented the static page table
    protection hook.
  * Patch 14 no longer handles early-allocated vmemmap page tables,
    as the page table walk handles them too.

- Patch 1, 4: the architecture hooks now only handle struct
  arch_kpkeys_state; enter() returns whether the context was
  actually modified. The generic API manages the generic part of
  struct kpkeys_state (.entered_context). [David Hildenbrand]

- Patch 2: renamed set_memory_pkey() to set_direct_map_pkey(), in
  line with other functions that are restricted to modifying the
  direct map.

- Patch 3: use field_prep() to encode permissions in
  por_elx_set_pkey_perms(). [Linu Cherian]

- Patch 4: added compiler barriers around POR_EL1 writes to prevent
  memory accesses from being reordered across kpkeys context
  switches. [Sashiko]

- Patch 5: check can_set_direct_map() [Sashiko]

- Added patch 6 to disable EL2 trapping of POR_EL1 accesses.

- Patch 11:
  * Call kpkeys_hardened_pgtables_init() directly from
    mm_core_init(), rather than forcing every supported architecture
    to call it from mem_init(). [Mike Rapoport]
  * Require ARCH_HAS_SET_DIRECT_MAP. [Sashiko]

- Patch 18: added missing kpkeys context switch in ptep_try_set().
  [Sashiko]

- Improved the cover letter. [Linu]

- Collected R-b's from Linu and Yeoreum (thanks!).

- Rebased on v7.4-rc2.

RFC v9: https://lore.kernel.org/all/20260818-kpkeys-v9-0-743ad31b2c8f@arm.com/

RFC v8..v9:

- Patch 1 [David Hildenbrand, Linus Walleij]:
  * Abstracted the pkey register using a new struct
    arch_kpkeys_state, itself contained in struct kpkeys_state. The
    main interface is now kpkeys_{enter,leave}_context().
  * A bool in struct kpkeys_state is now used to skip the context
    restore, instead of using a magic pkey register value
    (KPKEYS_PKEY_REG_INVAL).
  * Context values are now defined as enum kpkeys_ctx.
  * All types are defined in a separate kpkeys_types.h to avoid
    circular dependencies. This also replaces
    <asm-generic/kpkeys.h>.
  * Renamed kpkeys_enabled() to kpkeys_supported().
  * Replaced KPKEYS_PKEY_DEFAULT with hardcoded 0 (this is more
    consistent with user pkeys, and that value cannot easily be
    changed).

- Patch 4: changed type of POE permissions to u8, clarified commit
  message. [David H]

- Patch 5:
  * Aligned with new API in patch 1.
  * Added check to skip POR_EL1 updates if we have already entered
    the requested context (no value change).
  * Made prev_por/new_por const. [David H]

- Added patch 20 to make the kernel image alias of init_pg_dir
  read-only. [Sashiko]

- Patch 23:
  * Aligned with patch 1 by storing a full struct kpkeys_state in
    thread_struct.
  * Made kpkeys_lazy_mmu_{enter,exit} static inline. [Sashiko]

- Rebased on v7.2.

RFC v8: https://lore.kernel.org/all/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/

RFC v7..v8:

[Changes below are addressing issues reported by Sashiko [13]]

- Patch 3: do not enable overlays for user memory types in POR_EL1 -
  this breaks the atomic futex uaccess operations. Added some
  comment and test in a separate series [14] to clarify this.

- Patch 5: fix return type of arch_kpkeys_set_context()

- Patch 7: reset POR_EL1 to POR_EL1_INIT when cloning a thread. The
  pkey register value is tied to the context of the original thread
  (e.g. being in lazy MMU mode) and should not be inherited by the
  new thread in the general case.

- Patch 11: make ARCH_HAS_KPKEYS_HARDENED_PGTABLES explicitly depend
  on ARCH_HAS_KPKEYS (not sure why I didn't do that to start with...)

- Patch 14:
  * GFP_PGTABLE_KERNEL is not defined on all arch's, use
    GFP_KERNEL | __GFP_ZERO instead [reported by kernel CI]
  * Amend the arm64 hotplug code to use pagetable_free(), ensuring
    that the pkey is reset when vmemmap page tables are freed (this
    may belong to a separate patch, surprisingly x86 already uses
    pagetable_free() for this purpose)
  * Fix new caller of vmemmap_alloc_block_zero(), call memset()
    directly since that's the only caller left [also reported by
    kernel CI]
  * Added a note to the commit message explaining why
    __GFP_RETRY_MAYFAIL is not used

- Patch 21: reduced scope of guard in __ptep_set_access_flags_anysz()

- Patch 24: write to P4D/PUD if not folded in write_direct_map_pggtables()

- Other minor improvements

RFC v7: https://lore.kernel.org/all/20260505-kpkeys-v7-0-20c0bdd97197@arm.com/

RFC v6..v7:

- Rebased on v7.1-rc2

- Removed large block mapping support to ease reviewing and focus on the
  core changes. [David Hildenbrand] Accordingly, patched 19 was modified
  to force PTE mappings if kpkeys_hardened_pgtables is enabled.

- Added patch 14 to protect the sparse-vmemmap page tables.

- Dropped patch "arm64: Reset POR_EL1 on exception entry" as it may
  cause a crash when a thread with lazy MMU mode enabled is resumed on
  the irqexit path. See [3] and section "pkey register management" for
  details. The POR_EL1_INIT bits were squashed into patch 5 (they are
  still needed for patch 8).

- Renamed "kpkeys level" to "kpkeys context" as there is no longer a
  notion of ordering - each "context" may be given access to any set of
  pkeys. [David H]

- Re-organised *_enabled() functions [partially suggested by David H].
  The interface is now fully generic and defined in <linux/kpkeys.h>:

    - kpkeys_enabled() -> arch_supports_kpkeys()
    - kpkeys_hardened_pgtables_enabled() -> static key
    - kpkeys_hardened_pgtables_early_enabled() -> arch_supports_kpkeys_early()

  Each arch then implements (without #ifdef'ing required):

    - arch_supports_kpkeys()
    - arch_supports_kpkeys_early()

  See patch 1, 5, 11, 16 for details.

- Patch 2: remove KASAN tag when checking if the address falls in the
  linear map [reported by Yeoreum Yun, thanks!]

- Patch 11: export symbol for the lazy MMU KUnit tests (reported by
  build CI)

- Patch 24: added test for the sparse-vmemmap page tables

RFC v6: https://lore.kernel.org/linux-hardening/20260227175518.3728055-1-kevin.brodsky@arm.com/

RFC v5..v6:

- Rebased on v7.0-rc1 (includes support for splitting large block
  mappings with BBML2-noabort [4] and nested lazy MMU sections [5])

- Completely new approach for allocating protected page tables, see
  section "Protected page table allocation". Patch 11-26 are mostly new.

- Patch 6: check arch_kpkeys_enabled() to make sure that page table
  attributes are still changed when using the mock implementation

- Patch 9: new patch (thank you Yeoreum!)

- Patch 28: minor changes following the merging of the nested lazy MMU
  series [5]

- Patch 30:
    * Many tests added to provide better coverage of the various page
      table allocation paths
    * Require that the tests are built-in (many referenced symbols are
      not exported)
    * Some refactoring to reduce duplication and add logging

RFC v5: https://lore.kernel.org/linux-hardening/20250815085512.2182322-1-kevin.brodsky@arm.com/

RFC v4..v5:

- Rebased on v6.17-rc1.

- Cover letter: re-ran benchmarks on top of v6.17-rc1, made various
  small improvements especially to the "Performance" section.

- Patch 18: disable batching while in interrupt, since POR_EL1 is reset
  on exception entry, making the TIF_LAZY_MMU flag meaningless. This
  fixes a crash that may occur when a page table page is freed while in
  interrupt context.

- Patch 17: ensure that the target kernel address is actually
  PTE-mapped. Certain mappings (e.g. code) may be PMD-mapped instead -
  this explains why the change made in v4 was required.

RFC v4: https://lore.kernel.org/linux-mm/20250411091631.954228-1-kevin.brodsky@arm.com/

RFC v3..v4:

- Added appropriate handling of the arm64 pkey register (POR_EL1):
  context-switching between threads and resetting on exception entry
  (patch 7 and 8). See section "pkey register management" above for more
  details. A new POR_EL1_INIT macro is introduced to make the default
  value available to assembly (where POR_EL1 is reset on exception
  entry); it is updated in each patch allocating new keys.

- Added patch 18 making use of the lazy_mmu mode to batch switches to
  KPKEYS_LVL_PGTABLES - just once per lazy_mmu section rather than on
  every pgtable write. See section "Performance" for details.

- Rebased on top of [8]. No direct impact on the patches, but it ensures that
  the ctor/dtor is always called for kernel pgtables. This is an
  important fix as kernel PTEs allocated after boot were not protected
  by kpkeys_hardened_pgtables in v3 - a new test was added to patch 17
  to ensure that pgtables created by vmalloc are protected too.

- Rebased on top of [9]. The batching of kpkeys level switches in patch
  18 relies on the last patch in [9].

- Moved kpkeys guard definitions out of <linux/kpkeys.h> and to a relevant
  header for each subsystem (e.g. <asm/pgtable.h> for the
  kpkeys_hardened_pgtables guard).

- Patch 1,5: marked kpkeys_{set_level,restore_pkey_reg} as
  __always_inline to ensure that no callable gadget is created.
  [Maxwell Bland's suggestion]

- Patch 5: added helper __kpkeys_set_pkey_reg_nosync().

- Patch 10: marked kernel_pgtables_set_pkey() and related helpers as
  __init. [Linus Walleij's suggestion]

- Patch 11: added helper kpkeys_hardened_pgtables_enabled(), renamed the
  static key to kpkeys_hardened_pgtables_key.

- Patch 17: followed the KUnit conventions more closely. [Kees Cook's
  suggestion]

- Patch 17: changed the address used in the write_linear_map_pte()
  test. It seems that the PTEs that map some functions are allocated in
  ZONE_DMA and read-only (unclear why exactly). This doesn't seem to
  occur for global variables.

- Various minor fixes/improvements.

- Rebased on v6.15-rc1. This includes [10], which renames a few POE
  symbols: s/POE_RXW/POE_RWX/ and
  s/por_set_pkey_perms/por_elx_set_pkey_perms/

RFC v3: https://lore.kernel.org/linux-hardening/20250203101839.1223008-1-kevin.brodsky@arm.com/

RFC v2..v3:

- Patch 1: kpkeys_set_level() may now return KPKEYS_PKEY_REG_INVAL to indicate
  that the pkey register wasn't written to, and as a result that
  kpkeys_restore_pkey_reg() should do nothing. This simplifies the conditional
  guard macro and also allows architectures to skip writes to the pkey
  register if the target value is the same as the current one.

- Patch 1: introduced additional KPKEYS_GUARD* macros to cover more use-cases
  and reduce duplication.

- Patch 6: reject pkey value above arch_max_pkey().

- Patch 13: added missing guard(kpkeys_hardened_pgtables) in
  __clear_young_dirty_pte().

- Rebased on v6.14-rc1.

RFC v2: https://lore.kernel.org/linux-hardening/20250108103250.3188419-1-kevin.brodsky@arm.com/

RFC v1..v2:

- A new approach is used to set the pkey of page table pages. Thanks to
  Qi Zheng's and my own series [11][12], pagetable_*_ctor is
  systematically called when a PTP is allocated at any level (PTE to
  PGD), and pagetable_*_dtor when it is freed, on all architectures.
  Patch 11 makes use of this to call kpkeys_{,un}protect_pgtable_memory
  from the common ctor/dtor helper. The arm64 patches from v1 (patch 12
  and 13) are dropped as they are no longer needed. Patch 10 is
  introduced to allow pagetable_*_ctor to fail at all levels, since
  kpkeys_protect_pgtable_memory may itself fail.
  [Original suggestion by Peter Zijlstra]

- Changed the prototype of kpkeys_{,un}protect_pgtable_memory in patch 9
  to take a struct folio * for more convenience, and implemented them
  out-of-line to avoid a circular dependency with <linux/mm.h>.

- Rebased on next-20250107, which includes [11] and [12].

- Added locking in patch 8. [Peter Zijlstra's suggestion]

RFC v1: https://lore.kernel.org/linux-hardening/20241206101110.1646108-1-kevin.brodsky@arm.com/

---
References

[1] https://lore.kernel.org/all/20210830235927.6443-1-rick.p.edgecombe@intel.com/
[2] https://lsseu2025.sched.com/event/25GEE/kernel-hardening-with-protection-keys-kevin-brodsky-arm
[3] https://lore.kernel.org/linux-hardening/7dc9485d-a822-494d-9384-4a973c782c11@arm.com/
[4] https://lore.kernel.org/all/20250917190323.3828347-1-yang@os.amperecomputing.com/
[5] https://lore.kernel.org/all/20251215150323.2218608-1-kevin.brodsky@arm.com/
[6] https://lore.kernel.org/linux-mm/20250815090000.2182450-1-kevin.brodsky@arm.com/
[7] https://lore.kernel.org/all/aY3+Raf8eZqipCd6@e129823.arm.com/
[8] https://lore.kernel.org/linux-mm/20250408095222.860601-1-kevin.brodsky@arm.com/
[9] https://lore.kernel.org/linux-mm/20250304150444.3788920-1-ryan.roberts@arm.com/
[10] https://lore.kernel.org/linux-arm-kernel/20250219164029.2309119-1-kevin.brodsky@arm.com/
[11] https://lore.kernel.org/linux-mm/cover.1736317725.git.zhengqi.arch@bytedance.com/
[12] https://lore.kernel.org/linux-mm/20250103184415.2744423-1-kevin.brodsky@arm.com/
[13] https://sashiko.dev/#/patchset/20260505-kpkeys-v7-0-20c0bdd97197%40arm.com
[14] https://lore.kernel.org/all/20260521-poe_futex-v1-0-1da286b8f9b2@arm.com/
[15] https://lore.kernel.org/all/20260827164409.3421848-6-ardb+git@google.com/

---

To: linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ardb+git@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: Linus Walleij <linusw@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maxwell Bland <mbland@motorola.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Langlois <pierre.langlois@arm.com>
Cc: Pierre-Clément Tosi <ptosi@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org

---
Kevin Brodsky (21):
      mm: Introduce kpkeys
      set_memory: Introduce set_direct_map_pkey() stub
      arm64: Introduce por_elx_set_pkey_perms() helper
      arm64: Implement asm/kpkeys.h using POE
      arm64: set_memory: Implement set_direct_map_pkey()
      arm64: Disable EL2 trapping of POR_EL1
      arm64: Context-switch POR_EL1
      arm64: mm: Enable overlays for all EL1 indirect permissions
      arm64: Enable kpkeys
      mm: kpkeys: Introduce kpkeys_hardened_pgtables feature
      mm: kpkeys: Protect regular page tables
      mm: kpkeys: Protect early kernel page tables
      mm: kpkeys: Protect vmemmap page tables
      arm64: kpkeys: Implement arch_supports_kpkeys_early()
      arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
      arm64: kpkeys: Ensure the linear map can be modified
      arm64: kpkeys: Guard page table writes
      arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches
      arm64: kpkeys: Enable kpkeys_hardened_pgtables support
      arm64: mm: Map kernel image alias of init_pg_dir read-only
      mm: Add basic tests for kpkeys_hardened_pgtables

Yeoreum Yun (1):
      arm64: Initialize POR_EL1 register on cpu_resume()

 arch/arm64/Kconfig                        |   2 +
 arch/arm64/include/asm/cpufeature.h       |  12 ++
 arch/arm64/include/asm/el2_setup.h        |   3 +-
 arch/arm64/include/asm/kpkeys.h           |  83 +++++++++++++
 arch/arm64/include/asm/kpkeys_types.h     |  15 +++
 arch/arm64/include/asm/pgtable-prot.h     |   8 +-
 arch/arm64/include/asm/pgtable.h          |  67 +++++++++-
 arch/arm64/include/asm/por.h              |  11 ++
 arch/arm64/include/asm/processor.h        |   5 +
 arch/arm64/include/asm/sections.h         |   1 +
 arch/arm64/include/asm/set_memory.h       |   4 +
 arch/arm64/kernel/cpufeature.c            |   5 +-
 arch/arm64/kernel/pi/map_kernel.c         |   9 +-
 arch/arm64/kernel/process.c               |  10 ++
 arch/arm64/kernel/sleep.S                 |  12 ++
 arch/arm64/mm/fault.c                     |  17 +--
 arch/arm64/mm/mmu.c                       |  38 +++---
 arch/arm64/mm/pageattr.c                  |  29 ++++-
 include/linux/kpkeys.h                    | 150 ++++++++++++++++++++++
 include/linux/kpkeys_types.h              |  30 +++++
 include/linux/mm.h                        |  14 ++-
 include/linux/set_memory.h                |   7 ++
 mm/Kconfig                                |   5 +
 mm/Makefile                               |   2 +
 mm/kpkeys_hardened_pgtables.c             | 185 +++++++++++++++++++++++++++
 mm/mm_init.c                              |   2 +
 mm/sparse-vmemmap.c                       |  23 ++--
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
 security/Kconfig.hardening                |  24 ++++
 29 files changed, 928 insertions(+), 45 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20260428-kpkeys-e165645122c1


