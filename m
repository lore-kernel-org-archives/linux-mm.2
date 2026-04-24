Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C03FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918786B0092; Fri, 24 Apr 2026 15:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1FD6B0095; Fri, 24 Apr 2026 15:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1D06B0096; Fri, 24 Apr 2026 15:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 611F06B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:16:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22F4A12029B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:51 +0000 (UTC)
X-FDA: 84694406622.10.267FD07
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51D521C0004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ipHo+Whf;
	spf=pass (imf18.hostedemail.com: domain of 3n8HraQgKCCgWXIZIRWHKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3n8HraQgKCCgWXIZIRWHKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f9WK6BWUmjOk8kEPBSMznnbLTmjbHc618NOrMFLB7k0=;
	b=Vczngv4X8HBilYS7+RMjka2JuUcUvYGp6fmVuAqIvi2MxSJza/YaIQYRKWJlgxAiUHb72P
	ynEt1ZXuSX0qQhobhI1yrBu5x28HaHsMT5CZ5CmnjyT6Vmt4GTVQdrEJNd1nKZFkndJCYg
	h7ffx6NXaL4cnT5BhhMGT/srVGw0c2Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ipHo+Whf;
	spf=pass (imf18.hostedemail.com: domain of 3n8HraQgKCCgWXIZIRWHKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3n8HraQgKCCgWXIZIRWHKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058209; a=rsa-sha256;
	cv=none;
	b=PE3sETAYlNYOEBI1ONzZbkzf9uf2YDyucwQqccAMZsGyeRQOYkS/GjgWE2esv7L2rzRNeb
	hDO4LrgRTtzdqwBdU6CErUWcAgXvi1eH6VfWnnXSGdArYDgSTN9L2GdlmaZHYZPOfY1gD2
	SRvTuuZr6CYrfjZBqWQYpYJ2lJxnNKg=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso10721212eec.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058208; x=1777663008; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9WK6BWUmjOk8kEPBSMznnbLTmjbHc618NOrMFLB7k0=;
        b=ipHo+WhfPszW8VNakY4Cg8JVBd98Ptwwk1GRotLXuw3r5vbnO7lAYdQYSvU/1cyN9b
         iPm+mlKI9E3irGAtAi00DcrchL3q5R8k3y3erUVL6tRNu/+/8pIN/wAIKDDUXBHReW6r
         YUGUatifKeu3TMFVY9KlmBYysBCHOHVIOBhhlD48DDDFtUzrJFl+kj6i8Rz2cbg3veut
         ky5+sX3cfMoXJnevvCsJ8trDwMGhPitp802Ld4bxNf9p4INSGtObbf+HKW60IiTdUhK9
         UtfJKjJdjcx8i2p3Slu1r18BfG3la96AvO6mnkemp5UJ6jEbF1JFcd8rB8ChXyfTPukS
         ctbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058208; x=1777663008;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9WK6BWUmjOk8kEPBSMznnbLTmjbHc618NOrMFLB7k0=;
        b=iygbZtuW67G98hvN+u6Dfqgr+hctKNkrGuZc3DT65RMl+RfNwma2oR9p9qi2lMOvjQ
         SZoxbN8duHTev37jYnn2g++P9RY8Wj1rABFpdAF6fpBtxrOfb958XuBQU4u0dwsnP8WD
         j39GCfvV/URvYfg1Yr+VRgD/OLHuJwZ1Gn18vQGxDOD/ROGiC/24mXvAN+oQxcOHnmXj
         Ze7jXmDTiBXPeeutw0O2nyTJP9xJCUUEU1pKclb0RPDo0hD1TEnNhL+PNr0ZlBcpQ1g3
         VNVyzuDUFOZWPNscuZOAfHRiZBkSQ/riVSX4qSwIdflaWJAmmy0ereE9hgmVcFwvrnzw
         DQzw==
X-Forwarded-Encrypted: i=1; AFNElJ9OiqrajzqvLtqX+KXuQTEG84NSIDb9TRrpxVp0aSTc6pQkM4szGmy+kr8ZqCVe9KsKiaep3posFw==@kvack.org
X-Gm-Message-State: AOJu0Yz+KF6suo+Tby9j8JfBGm7QuhJLiBJEcwi5oK3gQkqNrQ7dd/+n
	OKxjcoBQbDzHFbBTeC0AEDFyieSBfRsgJeNe2NgxsAG/ulw9FULcY4sCKbWdZric6A2naFzjkvT
	cis+brozpQ/tbjg==
X-Received: from dybbs6.prod.google.com ([2002:a05:7300:a206:b0:2df:75ae:2719])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:230c:b0:2d2:c60d:4fe5 with SMTP id 5a478bee46e88-2e464ea4e10mr16505010eec.6.1777058207512;
 Fri, 24 Apr 2026 12:16:47 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-1-stevensd@google.com>
Subject: [PATCH v2 00/13] Dynamic Kernel Stacks
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 51D521C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: twe64b8titq94jyge6dmc486jkp99ajo
X-HE-Tag: 1777058209-253026
X-HE-Meta: U2FsdGVkX1/m/zxQVI3Ug7tu9HkZFkeX2q4XQMqjjd2+4MTIm4/ZJDhTdIKJEwNMY/TPKnurO22q7tx7+wHngy4jsdt0kkDuq69cX9AdKLP/51INSO0rh6iezqFy9ESUGfvi3O66UnKqQth/iIVFatM37pzW9sQqqAQ+OaTyKXwrwQ7KKZiC/W1eo7G0tq4tVlCFHYWnnBWDD70UuCoXNcFwr+0tR4hK3VW4Gv/nO2mIqhAjloX6vHa66qTEhg2HDsmh4wcDtN0eBL2T5kn1rSj2r9CJn8WSfDbmSnZSPlzB7YmuUiOWXncT/zSonyMm9HwPDxa9aa71BGfLkJGgag8HtVPkNgfWkdM6gRmvW7w4Kx33d9sp9FNv2b3F7P8RF0tQkhNA6z6mfMlMzi8lfn5pcJw1p5jJIf5YyQ1RCZZ1PQqJkK9/uwUeg30JI2S6Mna83b9uA/UcaFwZ3ecZ6YV3ainmd2BvgX5ktA9m+X3YQo6+chITV/9qjdF5fzgJvRjvmbq8SLAkJzeUPCjv0hjPqCOkIANGPvCUWzAt/ld280pCNd+uuh0Gg02Fd881pb9wbX9aG8znmD5cBryv/rQGBCtHTCggQHb5F8PB60/kJI3bVzzQQvApPG3K3pXu73nx8Xlh4NJfN0Bx8vtvIZ8CFPtY4VcNvTxJKhhTlnCkqjfxa8YXpQwmtjAd6NWKN5VjsH3fHSPyDcpZn5OSceseIHIJB7ZL21hgRNFOUn1H3vYrQNi4Jv26QY3X1sUupIiL0Zen8DDwghaXhSPDR3eTVH3DHj6wQoGI4LQYl8OPpM604oa/bUUPpbW2Gvdt9DSdH0T3wgmq9UzZB/6vqgCv8s5NJo3f7VLb6bFWkP48LlCvhC38fgyniKk4IYQZxeMYEodDgn4xGwopjZwp8sanwowY/u4fZRE5KSh3UeW7sKjbGtbwkTDvtf64WUXql5xCYEeT+2ydFEcbXhp
 +zuYn/BT
 uP9hvcuQD8egvDM4UL4XcZQwA6jC+tDCjP+NyvoRFjT3tLAke5P7T25xey4WT7yPY/d/AGheWxjwr4Jo0ji9hSLswXjubu+y4BZbY7r5qIFMc2g5S/L8zTmVPJQhpsQ0oTvqUzCdwyh/7N86LVCAAnlCZKFM8J45LW2ZjPaPzhsyFSq9HuRtvO6JkjFjVuaLP+BDIPNCPtxcdcj65u8hzzQ5b0pMzPr/CsyiZ8qXtEsLJI7z/UoYo5W5CROeNzCWqB18bJztKVqlsg5TwM/SfSsE3RKKS6EJLxkte1qHM87yF58r+BEeLb/HkrGHc0/QRbIU6Az901t9HvjxbBRPGGZdCZJ45VZoHHc7CYnN3czvtBSjlXCaVyK5mYkLvJQ5cyDtibnO2d5r2tcYV1zwJ/WIiZaqxeL8MbPvPNxU7DOaLO2uW2/ckUHpz2WjdYSLBTK3E+ddsa1EtbQbHdZM8x3ZjsDd4iqXiz9IXXn5DN91f8vXLwZS4MDvv0UXf2bhVGy4tq4BvIII0V+l+d4gKqs9pdNjf9zZITB6i9ly1ORI1T2mWDkgY4OEBxNEBPhLpbJvLCTKzmLpz/tlFIzPkt3UOZ3Cb61Px+btE0KSEBkOEYx7zvNWZBEizxdorsoCbtyFDzmTnk++xukUoCf9QPDCSl1IGk0AMC7y55ELZPqLsIPKpHeYKJjPSXBailN/0bilFNAQr7uOLp1tnoZEUh7RT9CAU83QiYW6kOA9hd9us+6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC is a continuation of Pasha Tatashin's original RFC [1], and is
based on Linus Walleij's rebased version of the patches [2]. My focus
was x86_64 devices, so I didn't include his arm64 WIP patches.

The impetus for reviving this RFC is kernel stack usage on Android. On
regular Android (i.e. non-wear/automotive), system processes typically
have 2000-3000 threads. When adding threads from app processes, this
means that systems with 4GB of memory are using 1-2% of total memory for
kernel thread stacks. Dynamic kernel stacks reduce this by 65%-70%.

The main change compared to Pasha's v1 RFC is how x86_64 handles kernel
stack faults. On systems where FRED is available, it handles kernel page
faults on stack level 1. When FRED isn't available, it uses a dedicated
IST stack for page faults. In both cases, page faults which aren't
dynamic stack faults are moved back onto the regular kernel stack. This
does introduce some overhead for page faults on user memory that
originate in the kernel (note that non-FRED systems already needed to
bounce userspace page faults through the entry stack), but such faults
aren't as hot a path as regular user page faults. There are certainly
systems where the memory savings are worth the overhead. That said, the
config could be made optional to give systems the option to pay the
memory cost to avoid the CPU overhead.

The biggest open issue is how to deal with reliability. This series uses
GFP_ATOMIC when refilling the per-CPU magazines during context switch,
which is necessary to avoid deadlock. This of course raises concerns
about allocation failure. If a magazine got depleted, then refilling the
magazine failed due to atomic reserve depletion, and then another thread
triggered a dynamic stack fault, that would trigger a fatal page fault.
There is also a secondary concern about additional pressure on the
memory reserves causing allocation failures at other atomic call sites.

The question is then: is this approach something that is fundamentally
untenable in the kernel, or are there compromises that would allow it to
be merged? One obvious compromise is to make the feature optional. Both
kernel stack faults and running out of memory reserves are rare events.
I've never seen this failure in my testing, although I don't have field
data to back that up at this point. Some sysadmins may view it as low
enough risk to be worth the memory savings. There are also additional
measures that could be taken to reduce the likelihood of failure (e.g.
magazine management on kernel entry/exit, tunable magazine sizes, adding
best-effort trylock reclaim or oom kill).

This series was developed and tested on devices running 6.18 kernels. It
has been rebased onto 7.0, with minimal smoke testing after rebasing.

[1] https://lore.kernel.org/all/20240311164638.2015063-1-pasha.tatashin@soleen.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git/log/?h=b4/aarch64-dynamic-kernel-stacks-v6.18-rc1

David Stevens (7):
  fork: Don't assume fully populated stack during reuse
  fork: Move vm_stack to the beginning of the stack
  fork: Move vmap stack freeing to work queue
  fork: Store task pointer in unpopulated stack ptes
  x86/entry/fred: encode frame pointer on entry
  x86: Add support for dynamic kernel stacks via FRED
  x86: Add support for dynamic kernel stacks via IST

Pasha Tatashin (6):
  fork: Remove assumption that vm_area->nr_pages equals to THREAD_SIZE
  fork: separate vmap stack allocation and free calls
  mm/vmalloc: Add a get_vm_area_node() and vmap_pages_range() public
    functions
  fork: Dynamic Kernel Stacks
  task_stack.h: Add stack_not_used() support for dynamic stack
  fork: Dynamic Kernel Stack accounting

 arch/Kconfig                          |  38 ++
 arch/x86/Kconfig                      |   1 +
 arch/x86/entry/entry_64.S             |  49 ++-
 arch/x86/entry/entry_64_fred.S        |  57 +++
 arch/x86/include/asm/cpu_entry_area.h |  18 +
 arch/x86/include/asm/idtentry.h       |  38 +-
 arch/x86/include/asm/page_64_types.h  |  10 +-
 arch/x86/include/asm/pgtable_64.h     |  36 ++
 arch/x86/include/asm/processor.h      |   6 +
 arch/x86/include/asm/traps.h          |   5 +
 arch/x86/kernel/cpu/common.c          |  11 +
 arch/x86/kernel/dumpstack_64.c        |  10 +-
 arch/x86/kernel/fred.c                |  20 +-
 arch/x86/kernel/idt.c                 |  57 +--
 arch/x86/kernel/nmi.c                 |   9 +
 arch/x86/lib/usercopy.c               |   9 +
 arch/x86/mm/cpu_entry_area.c          |  17 +
 arch/x86/mm/dump_pagetables.c         |  14 +-
 arch/x86/mm/fault.c                   | 101 +++++-
 include/linux/mmzone.h                |   3 +
 include/linux/sched.h                 |  11 +-
 include/linux/sched/task_stack.h      |  48 ++-
 include/linux/vmalloc.h               |  14 +
 init/init_task.c                      |   4 +
 kernel/exit.c                         |  22 ++
 kernel/fork.c                         | 481 ++++++++++++++++++++++++--
 kernel/sched/core.c                   |   1 +
 mm/memcontrol.c                       |  10 +
 mm/vmalloc.c                          |  27 +-
 mm/vmstat.c                           |   3 +
 30 files changed, 1049 insertions(+), 81 deletions(-)


base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


