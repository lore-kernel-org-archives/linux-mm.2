Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD30C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44256B0096; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7276B0098; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAC06B0099; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90E8C6B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1693FC035D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:47 +0000 (UTC)
X-FDA: 85143289014.21.7EA2E79
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D7751C0003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T4ECihFZ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qFwt/irMyfR5ULmWvclkAj2/vGaiBlcUVJujqDai+yg=;
	b=Z8cYfZToqbRSDiNEU2ER7UMRF7JGVj0Dd/bwQU3/yW3DrSba1ST76PHgyGrBul8olrbRla
	Mqkp6/7uCpwxzyAvbFBEuqN/UKQz7SHx6rboSsl2bqTrTSGTnmb9TwUun0bNgcu+9r8sKo
	NN2D4QPa/+pByJCiRpREMAx/XMSqgSY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T4ECihFZ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745885;
	b=3Fn5N/6UTg6TC13gnCVtG78tdCZ8gAKNuwOOJn0mLVkZRrJ0AZfkKv8NbeqGHlXFIvqDm/
	sflsq0JYkcgsl/2QwSM+MvIsQGY5lUNvepH3D+6SNwFHgcyoUkYH6VAPcef1jMlbwwNiUK
	I1AwBw8UrhxtWMQDjZL9g294xCW01bM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=qFwt/irMyfR5ULmWvclkAj2/vGaiBlcUVJujqDai+yg=; b=T4ECihFZoCE09PcK/JRkVVKZb0
	iuoSs5g2mJl8diNZJG9LFBtKgkw/CytBBtl3BGUFXugx4BFEbKSQh4xa0V4LAX4rtHs+YFI+71Opg
	xbSZL+5/PX4HwRxRvJc2NoXhuRWW7OALlqHfWbE05mykHXxCUYlhVB8bawQ2IfXid9BIAznbZjYsa
	hFWfpMN+05F5NXVu99BrG6lkyaoz49vA/eu6hkPWLsqh6B20i6dGC12TekZSJZE9ZxVzTio59icu0
	B3rHSHy04qcGnP1fBvsz1VyMtqck9pkkdGHjguX07LApdodjasx0oxoIbfyP/cfYi3NoKygIdqVWg
	48Ya+08Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCMq-00FCWf-1s;
	Wed, 26 Aug 2026 12:04:33 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/5] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Date: Wed, 26 Aug 2026 05:03:51 -0700
Message-Id: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACfWjmoC/13M0Q6CIBSA4Vdh51oaoAh41Xu0LlCOwdrEQaOa8
 92bdtHs9t/+b4GMKWCGjiyQsIQc4gQdqSsCg7fTDWlw0BEQTLSsFYL65xxDjhO9+0jHwbheWGd
 1b6EiMCccw2vnLteKgA/5EdN71wvf6hdSXB2hwimjZpDorJTcGH122Ac7nWK6wSYV8bu14H+3o
 IxK1dTKcGw0tod7XdcPN30pQecAAAA=
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=9956; i=leitao@debian.org;
 h=from:subject:message-id; bh=WCOJsPp/NC0CGsS/LKREsuX9We14eNeSVrhHInh9OUc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZKXYy6V5NbPLbnx8/fI4m8kehbnkkz2d/eO
 dftu0aMTrCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSgAKCRA1o5Of/Hh3
 bUr8D/9GyjEUbvvfagt8beBTM7QD3weQE5WwkyA+6hy7jigvw8fReIB4TIMND1BunCY7T/Qoeop
 4/BJfzeTqHpILBbX/iyEsjzGotptgUzgHQMM5iihye/Hb+qpeGNsVK2actVoJKu/JS20zu+o1/k
 I9x1wXFwclvIH+Zg35pKwC5vFU7TLN3dPRyJQM/1kRqUfy9oLWjWltANcPsINnRsa2ChOfggOcg
 pEBD8HYA887MXBZBgOoJ+DerczeN5SWI0IdguV//KQXIsZOMdc0uv9pC28iqKpw9rxj1sAbh0gs
 eQXaAXF1/E0ByZlba70+jTtCLk8ARiB8LDnQPgfXFkvFmcNPZQXCQUaeKEyRVmjIVWt4ZRCG3+v
 v/z4dvtBjbkEiQopdXs07wLWQWgTQHMYig4OmIGy3fFH3XNr7FhqBbyDCBKwsAnbxmcCVMOxCJG
 rN+vc+V3aMCIPwlhcX62WfXjCqAnFxdAsdWkmk29DuJXVDn9uhjt+bGEVUIP8+1SIcB+W0Dkkmq
 crGATacmWCyDzOlTPCzQwbPmFBSc0Y1NWH2jugVJH1KObWRPv6xYd9qUQs5ofwJHfo6iNx4f5Y7
 CRUE9KVK4UgN3jFhWYkQBLWwYe0FAdWKC+fyDlTSqgSqz7i/NKCkCmAYGt0wVwcilIs6oKPSa1G
 MSjG9X5J74oa8zA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D7751C0003
X-Stat-Signature: nfg4s4fk5adjudusorgp6n5conxiagu4
X-Rspam-User: 
X-HE-Tag: 1787745885-971003
X-HE-Meta: U2FsdGVkX1/+sQU/BVTY2PG9oBW/6uVwEEYCSrKD4S1bUWIsEnK4/cBib4tkmWAA2KNHYyTfdlstNcJAKMEcaXPV9sgoU2qQ53MxV8WNKrcYWkySGGiFSSoMqp54cB8nNgwS+3TVRnsXhrw9Pw1zUiivjpk7lPDaZB58hsQBxWQdkSxi/v+ZQXdEuHchAgHPsC2mf4X2ag04AZycos0AzZvRWpliJfFdhcJ88WiZGEcwtYVThWx8QT32x746sDcPBQPYHhGFjpSDKspHtg3SYCLio0QUlKdnMvt4IoraSYkWdaHTjVptz8uV/ZXnvwPoqdas11Wpkn1Cz3lrxFx5gxQvTUdpDpWRZkEK7fw3AL8TLuMbFHSOv5FXQsqnoSCmw+zoVx0eCf2IN0tAaVHMdOXY1uWA6DNEUxKqboLqd4XdmpWABxMt+S4EsnHe9ECVRUKqM2fu1mVuWyaZPN6p6Jm1NNb3oky3xw+efYF1W0pf9RYHCFmrPmmLJS68bw7Iqnbmb1pGDrnOq81X+HkFeHPD95FE6HKaz1Con4wG5KRfWZ/8DAeTn/pOJDWSSCjcZw8aoJjswzMoiVMlcIJCfW8sVfvGLH6BcfitW8rH33MltHa3O3uth1KUnvvS8wxC2qDZTgmvXOqxVdvKn63rleIQ3/+gOm5OrHmRvoowz/a6B+MpRO58oXYI+2tIkpH6YWP4HReNPjsk53q3C3QOIbSSx6nKpFZ+NxotL3slRr6J4AdrITw328MqWujcayEX9c0rA/GmnjkPENXhgI6v4rCFh1Vg5zgx/Vte14aYWd+L7GAtNO0weVCVsywyrw4HOI3hX0kQXW0zka4BpvcPbIwojO5GFXaQbyTjNi+5wyEFfOVN5W3LflxOy7Ppd/eRmrT5CBiwHhjnykx/vVXcN0t26BauiUZ+kqrBH60NK8x+s5M8vzBFoEw0qeQTiwojAOGNDy/MTTPlu/XT1DN
 ZaxLkyWO
 fAdfwrOcXcB4wdNj31udT5ltifxBbLYmCkaOkzpvFPnWwb2nP4VBEV2tbOcK5rf+7+pGgyHOxCJD5A4J0JN+gtqlZjgNzt5Zq2IH66lpEQg3rllfe+saCw/Cy+x2a/15vzQHZVG3SZmPutUfs9saqcCcJNYptAw00/AMkxnrb0XNewf06gGU05JdhXy9asK6Zb+F6QDJ2tCpTt9XJyWgEACViyHdBh5pnT86LXoJDdsp3awhU6DCpovd/emQfnoXVDmA3i0cJiPgT/3lpMxycHclBjtYnCZTQR1/nOMw7Glf3f8UWS2+axK7TXmpG6rZEAgYweDXqV//c2tHRG3I5wIfyn22vpEN/o4turFiaD7ERbt0boW960OY0gApbjYCcYIP2erNIQuw3vttttr/c9WtYok2v6bN1TQJGIW4CRdn8Uh5yGUux0B0YsDRKFCzpw0/Ive5GsFZl7oQgZIjEHG5uH7pZfMuL/42xAA3w0oem8DxerpgfrNE2ZYl1Us//xS2E6lHVnxb4cJwaqCkMiX1SQwPgDtEIeq619qM0ythKoCcr8x9AReQ/QmU7myplEKRt/nRJqum/lY2irzJ+BYQlUi7oADqLOHlprOQgoi9xCHbOSqns225S9yvuwqbm6WEqWqOkwwlIgXGyRlCP2tubPpazcNyRQnOqTa8XrReIjD8d9So24Y6zNk9va5X06PwUllpO2U6TqeftFqK0H9gOs9rLpc10VhDVe+lHSQVxTaXTg+kN+fbBOhNq5t+zK8SNj1yaAZZm2V2lA+j7qFu+V4nVx9KEPOnfzVCXq32OjjF0DDzAmURc/RjoJm+eGVLjSccZp62c+bisiVOPXhpqpkLpxeqnU8A6l/u8DhNV3usMt+3F/06unMLdo5WhOT+KxElGnjbuGFan9LgnCs1FPkUBwAdxVKSeDDgantu/gTRLc5G5R0xkcssKieYBHgmZ7EZmzZYQkgblFJakyWA2s/Ho
 JyOzVwel
 WNVglQC5Zm/wXE1fdyZtbeuxXSQAUQF4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem:
========

When a page is hard-offlined due to an uncorrectable memory error (multi
bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
the buddy allocator. This information is not carried to the next kernel
that is kexeced. The new kernel kexecs and trip over that bad memory
bank _again_.

Why now:
========

Several industry trends make this increasingly important:

    1) DRAM is getting more expensive
    2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
       failing part can no longer simply be swapped;
    3) memory is kept in service far longer (at Meta, DRAM lifetime is being
       drastically extended).
    4) It is more and more common to kexec instead of full reboot
    5) Increase of memory per system with CXL

What was done already:
======================

In order make linux deal better with the problem above, I've done
already fixed a bunch of stuff in this area, such as:

1) Panic on unrecoverable errors, instead of "printk and carry over":
https://lore.kernel.org/all/20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org/

2) Respect poisoned memory at kexec time
https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/

Now, the natural follow up is to carry the poisoned memory information
to the next kexec kernel, avoiding tripping over a known "bad page".

Proposed Solution:
==================

Carry the poisoned frames to the next kernel in a new EFI configuration
table, LINUX_EFI_POISONED_MEMORY.

The table is a bitmap with one bit per 2MB of physical memory, modeled
on LINUX_EFI_UNACCEPTED_MEMORY. The stub sizes it from the EFI memory
map and installs it empty while boot services are up -- a running kernel
cannot install a configuration table, it can only flip bits -- and a
table inherited from an earlier boot is reused as-is. That is one
fixed-size allocation, 64KB per TB of RAM, with no list to grow at
runtime and no chain to trust at parse time.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

Each hard offline sets the bit for its unit. Soft-offlined pages are not
recorded: they are still functional, and were offlined predictively.

The next kernel poisons the inherited frames from mm_core_init(), right
after memblock_free_all(), the first point at which they have struct
pages. A frame that is free is taken off the buddy allocator; a frame the
kernel is already using is flagged where it is, and free_pages_prepare()
drops it if the owner ever hands it back. Either way it ends up in the
state a frame poisoned by this kernel would be in, so everything that
already understands PG_hwpoison covers it -- including the kexec segment
placement check from the series linked above, which is what keeps the
next kernel image off these frames.

Nothing is reserved in memblock. An earlier version did that from
efi_config_parse_tables(), but the page flag alone turns out to be
enough, and reserving per unit that early runs into memblock's fixed
region array before memblock_allow_resize().

Granularity is the trade-off: one bad 4KB frame costs a whole 2MB unit in
every later kernel of the chain. In exchange, a row or column fault --
roughly a quarter of the DRAM faults reported in [1], and potentially
thousands of 4KB pages scattered over gigabytes -- collapses into a bit
or two.

A bit is never cleared, which is a known limitation: it stands for a
whole unit, so an unpoison of one frame cannot tell whether the unit as a
whole is good again.

Known limitations:
==================

In order to keep this patchset digestible, I am making some trade-offs,
thus, this feature has the following limitations:

  - Memory hot-added after boot is not covered: the bitmap spans the RAM
    the EFI memory map describes, and a frame above it is not recorded.
    Same gap the unaccepted-memory table has.

  - Memory preserved across a KHO handover is not covered.
    kho_preserved_memory_reserve() marks it MEMBLOCK_RSRV_NOINIT, so
    memmap_init_reserved_pages() leaves those struct pages uninitialised,
    and a frame there is neither free nor PageReserved when the bitmap is
    applied. Its record is dropped, and the frame goes back to the
    allocator once the owner releases it.

  - Without a memblock reservation, early boot can allocate over a
    recorded frame before the flag is applied. The frame does not reach
    the allocator afterwards, but the memmap or page tables may end up
    sitting on it.

  - The per memory block hardware-poison counter does not include
    inherited frames, because memblk_nr_poison_inc() divides by
    sections_per_block and memory_dev_init() has not run yet. A block
    holding an inherited frame can therefore be brought back online, and
    HardwareCorrupted stays high after that memory is removed.

All of the limitations above can be fixed in follow up work. I am trying
to keep this patchset the foundation, with that work done on top.

The series is six patches:

    1) add the LINUX_EFI_POISONED_MEMORY table
    2) size, build and install it from both stub entry paths
    3) record poisoned frames into the table from the memory_failure() path
    4) add the mm helper that poisons one inherited frame
    5) walk the inherited bitmap
    6) apply it from mm_core_init()

This was initially discussed at
https://lore.kernel.org/all/ajut_LDQGYCShApx@gmail.com/

A special thanks to Kiryl Shutsemau, for feedbacks and suggestions.

[1] https://arxiv.org/abs/2408.15302

To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: rmikey@meta.com
To: kas@kernel.org
Cc: riel@surriel.com
To: kexec@lists.infradead.org

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v3:
- Poison the inherited frames from mm_core_init() instead of reserving
  them in memblock, so everything that keys off PG_hwpoison sees them,
  the kexec segment placement check included (Kiryl)
- Reserve nothing in memblock: the page flag is enough, and reserving
  per unit that early runs into the fixed region array (Kiryl)
- Drop the 1MB cap on the table and the unit coarsening that went with
  it (Kiryl)
- Size the table from the memory types arm64 turns into RAM as well, not
  just the set setup_e820() maps to E820_TYPE_RAM (Kiryl)
- Make CONFIG_EFI_POISONED_MEMORY unprompted, so it is on wherever its
  dependencies allow and nobody has to decide (Kiryl, Pratyush)
- Fold the top-of-RAM helper into its only caller and make it static,
  rather than adding a generic libstub API
- Fold the table build and its installation into one patch
- Spell out the known limitations in this cover letter
- Link to v2: https://patch.msgid.link/20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org

Changes in v2:
- Replace the growable linked list of 4KB entries with a fixed-size
  bitmap, one bit per 2MB, modeled on the unaccepted-memory table (Kiryl)
- Record hard offlines only, by hooking action_result() instead of
  num_poisoned_pages_inc(), which also fires for soft offline (Kiryl)
- Allocate the table as EFI_ACPI_RECLAIM_MEMORY, so it is not System RAM
  in the next kernel, and reuse an inherited table instead of installing
  a second one
- Validate the geometry of an inherited table before using it
- Cap the table at 1MB, coarsening the unit instead of growing it
- Restrict to 64-bit, as the unaccepted-memory table effectively is
- Never clear a bit: an unpoison no longer un-records the unit
- Split the table definition and the stub installer into separate patches
- Link to v1: https://patch.msgid.link/20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org

To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

---
Breno Leitao (5):
      mm/memory-failure: efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      mm/memory-failure: libstub: install the poisoned-memory EFI table
      mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-memory table
      mm/memory-failure: add a helper to poison a frame at boot
      mm/memory-failure: efi: replay the poisioned page in the next kernel

 drivers/firmware/efi/Kconfig                   |   8 +
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   6 +
 drivers/firmware/efi/libstub/efi-stub-helper.c | 106 +++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 237 +++++++++++++++++++++++++
 include/linux/efi.h                            |  21 +++
 include/linux/mm.h                             |   6 +
 mm/memory-failure.c                            |  33 ++++
 mm/mm_init.c                                   |   1 +
 12 files changed, 428 insertions(+)
---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>


