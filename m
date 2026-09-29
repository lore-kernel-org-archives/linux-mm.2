Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20672C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB976B009F; Tue, 29 Sep 2026 04:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2886B00A0; Tue, 29 Sep 2026 04:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFC16B00A1; Tue, 29 Sep 2026 04:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E96246B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:19:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7716A8043D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:35 +0000 (UTC)
X-FDA: 85266100710.15.5A4DF61
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf08.hostedemail.com (Postfix) with ESMTP id D92DB160008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o4wwXDmF;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6+LZpfCaXp+w9bNKONqZz/tUIOa/7JuK9YWWQ3xcNXk=;
	b=T7JeqxeXCNDT/i79Bq+WiKSsQwumhlkxOrR58eWiGVxdv/t+WhoYKMKENR6v8Cjz8FMUA3
	ORmtvQ7O1KhDzrGcThOO8PfG5doPPxQIgyan8gxsFdFUU2YjESuUXizVLClHGoQk7K3hwv
	jtyRI7AWPEcpfGkjLucfYYnmGXzoxxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669973;
	b=m7TbMG8gTIwFyFR1D5BC0+9cNI/l2KhcNGSVwVwH54wl1EJvMINsChhDyZeuzggAjDAtBn
	OqHgmTntVKVBRHhCXCmcd811wCXrI81LGwFLQ0NfCb0CKdm3/xFsfFUJp9vJ55GhrqHXAq
	nh2P4MgcJopSc8Ypg5OUbf6yQP2Ucuk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o4wwXDmF;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k6FOq8X8FbjxI404guB6fTZveypsixaCcmX0PMkNLA8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790669970; v=1; x=1791274770;
 b=o4wwXDmFMY11woSsszqjC8qE4ilBo2e+p7EmdYSzRWA6mpds+ehEy0/Oes9tyIBv3GHiQvyV
 OHmY9ZWBFWi6mfIK/4EH3tcCoI/2YrXPi4HnieW7f6IqryA3ecswwJ9gAZnECd3uKk/gniD/Ase
 qPBDep4z8QRjpzkZ2qutXM98=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 323ae503de3222bc;
	Tue, 29 Sep 2026 08:19:30 +0000
X-Mizu-Trace-ID: 323ae503de3222bc
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v11 0/7] alloc_tag and module codetag section fixes
Date: Tue, 29 Sep 2026 16:20:07 +0800
Message-Id: <20260929082014.160587-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4txrro8o3z8if7a944dfd5cyxuxanord
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D92DB160008
X-HE-Tag: 1790669971-518471
X-HE-Meta: U2FsdGVkX18FNVQ2uGng03oZTfzRNeB2PwdfF31Wp6KnUtKlMyici0IGZRq/IhSXA+1h3BZ1SuqwpvnNMkL6anYKRSoK79Ac5C3GUuOtof7gxs5g3qootSsoV0MtAraa31kVfptEaqMglnvyBYv4N/cyzTHfRFoYBv86znYLStXZmfww+HRgLoXZi0ZCS02nxumufPD+Gxgqedbw5U9U05/q9FZX6YMz2Q72MgqlkLytF9+7IxaAA4uqu/IdWgmoRBFGHVvTvRWLe9cOTWmLKfY/l9EOqgaQZDF3z/wf07M5/COjPg9mEJvGAA2ILd+irOD6rIGNQVjwWRV+/O8BgzFioZ2ElWD2+zQc1KKTzEE4CVI8aRIBZhTZdQMIbyoG6UwsfBAxXoZOw0HSlZ2/92OfhMPA7e3JYDJnHuWWONhKXkhjLg3bOOIIoWDBsjgHBcDkEUrB0HE3tgzdeJV+ezHio75h2cVDVFHWAAzPOAw3mTftSN5iPMG7ljCdToKcN57Dv07/FDJbxSxleovT9Jd/7Fw3AWoKOZ7ciMW+CSEDqyEmzLdTQp5lcB3PLl1z9vMWlyG6rG+J2XQ5Fy362ewwAyCLjZUVnKDE+XhGwQnyw1/EBcNVbNqNZ1MZ6i8MVPI0z/a6KFgp+KKUo6D2T+u3hmy7MvfAz5IqMd9BAZAhHSRSZpYUd2ewc3NnWe4zeuhDWCbb4KQ8pH/2kUK6UPMbLnfKXG1UEmJlv9xyr2G14Vp2W3wRuNmY24oG8JKneJ8llz/m0tgTwVflos0Hs1vxHfxV+RXlatg5DE+Kft5AVDw9qeKVKhts2Ji1KpGiNWEUs+RSpvv3akh8BSOhPLVss7x9h5kpH9o/FF6FoCWms5S86tnSsV/Xd8OTvTkvEOxI1PZngOv1LVrn5xpExMbr7Usag7fsHHvDvAt6CRpIAV1uJ8CnBUqnwWSFEPs5GX2a/R19MlLZspJtcee
 6AR4MZx2
 IvejByFNKKgNAWd6k0Qm8DzSAQUy1/Zi0UvHluAvTW6WVfqklWQqLVTVQjTFSwvc/NgkQGiMaicaF55sVduiYfiRcfRT+KniYhAN8Pk1UB132xlZO4lWWfWly3r1w1jd/NW+Sx/5mdXAN776vv1b0E4Oo/s5UbDllwxHM9gzfaThbJUAgkdSJPIeFA+Va/L+6JT3ETDau8Vy5uFuHA2EMqjomX6UWqkNmUUxNkSYhn/4FUhex0br8k6fYLhrqWkCqBbU5E4F7HhfZi4pzMja454uNp6Bxv3rQ4uQ6ZHZn51imLEqLmoNbRfsPDK/AvEIj7rqpLYUjXFU5e7UvlW3zl31GcKtCS7ulEAKt4P2WbQPw0kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With profiling toggled off, the overflow check in
reserve_module_tags() did not run, a module could load with more
tags than the page flags can address, and re-enabling profiling
then silently corrupted /proc/allocinfo. On overflow the fix shuts
profiling down, releases the reservation and returns -EAGAIN, and
the codetag section lands as regular module data in the same load,
so the module loads without profiling.

Review of the earlier series by Sashiko turned up more problems.

One is a race. layout_sections() and move_module() both asked
codetag_needs_module_section() where a codetag section goes, and
mem_profiling_support can change between the two calls, for instance
when another module load overflows the tag index and shuts profiling
down. move_module() then copied the codetag section to offset 0 of
its regular destination and clobbered the first section placed in
that region.

v7 reworks where codetag sections are allocated, on a prototype by
Petr Pavlu [1]. The allocation runs before layout_sections() and the
placement is decided in one step, so nothing re-asks the question
and the race is gone. The retry is gone too, on -EAGAIN the section
is laid out as regular module data right in the same load.

[1] https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/

Patch 1 moves release_module_tags() above reserve_module_tags(),
since the failure paths now have to call it.

Patch 2 is new. __vmap_pages_range_noflush() and friends leave the
PTEs they installed when they fail, and the callers do not agree on
who cleans them up. Per the discussion with Suren and Ulad [2] each
mapping function now undoes its own partial work, the __GFP_NOFAIL
retry loop in __vmalloc_area_node() and pci_remap_iospace() stop
tripping over the leftovers of a previous attempt, and
vm_module_tags_populate() no longer needs its own undo, patch 3
drops it.

[2] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

Patch 3 cleans up the populate failure path: the reservation is
released and module_tags.size rolled back, so a concurrent load
which already passed needs_section_mem() does not skip populate for
the freed gap. The PTEs a failed vmap_pages_range() left behind are
undone by patch 2 now. It carries both Fixes tags so it backports
wherever patch 5 goes, which uses its prev_size.

Patch 4 introduces SH_ENTSIZE_STANDALONE to mark sections with a
separate allocation. The percpu section was previously excluded
from the layout by clearing its SHF_ALLOC, which per the ELF spec
says the section occupies memory during execution, and percpu does,
only outside the regular module layout. The mark lives in sh_entsize
now, find_sec(".data..percpu") gives stable results again and
apply_relocations() goes back to testing only SHF_ALLOC. The
section would show up under /sys/module/*/sections/, but it has one
instance per CPU and no single address, and the entry never
existed, so add_sect_attrs() and add_notes_attrs() skip it.

Patch 5 moves the codetag allocation out of move_module() in front
of layout_sections(), so the placement is decided in one step and
the race is gone. On overflow profiling is shut down, the
reservation released, module_tags.size rolled back and -EAGAIN
returned, the section is laid out as regular module data and the
module loads without profiling instead of failing. Any other error
fails the load. The release and the fallback belong together,
without the release rmmod hits the stale entry and panics.

Patch 6 skips the percpu counter allocation when profiling is off.
After the shutdown modules load their codetag section as regular
data, load_module() still allocated counters for every tag and
release_module_tags() cannot find them on unload, so they leaked
(Suggested by Suren).

Patch 7 fixes the /proc/allocinfo lifecycle. shutdown_mem_profiling()
runs under mod_lock, and the synchronous remove_proc_entry()
deadlocks with a reader taking mod_lock for read in
allocinfo_start(), so the removal goes to a workqueue. The file is
created at the end of alloc_tag_init(), a leftover file after a
failed init would panic its readers (Found by Sashiko). When
proc_create() itself fails the codetag type and the module tags
memory are released with the new codetag_unregister_type(), and the
lockless alloc_tag_cttype reader in alloc_tag_top_users() is
guarded with RCU.

Tested on an x86_64 virtual machine:

Booted without sysctl.vm.mem_profiling=1,compressed:
# cat /proc/allocinfo is fine

Booted with sysctl.vm.mem_profiling=1,compressed:
# cat /proc/allocinfo is fine
# insmod overflow_tag.ko
# dmesg
  With module overflow_tag there are too many tags to fit in 13 page
  flag bits. Memory allocation profiling is disabled!
# rmmod overflow_tag
The module loads without profiling and unloads cleanly.

Also ran continuous LTP stress for a few days, nothing abnormal
so far.

Changes in v11:
- new patch 2 makes the vmap functions undo their partial mappings
  on failure, per the discussion with Suren and Ulad [2]; patch 3
  drops its own vmap undo accordingly
- patch 7 is renamed to "fix the /proc/allocinfo lifecycle", it now
  also unwinds the codetag type with the new codetag_unregister_type()
  when proc_create() fails and guards the lockless alloc_tag_cttype
  reader in alloc_tag_top_users() with RCU
- collected Reviewed-by tags from Suren Baghdasaryan (patches 4, 5)

Changes in v10:
- fold in the two alloc_tag fixes from
  https://lore.kernel.org/all/20260817062726.106511-1-hao.ge@linux.dev/
  as patches 5 and 6, they replace the versions in the mm tree and
  fix the percpu leak Sashiko keeps flagging
  https://lore.kernel.org/all/20260908094736.2B1A61F00A3A@smtp.kernel.org/
- create /proc/allocinfo at the end of alloc_tag_init(), a
  leftover file after a failed init would panic its readers
  (Found by Sashiko)
- count note sections with sect_visible() in add_notes_attrs() too,
  the count has to match the fill loop

Changes in v9:
- do not export .data..percpu under /sys/module/*/sections/ (Petr
  Pavlu).
- move the populate failure cleanup in front of the rework, v8 patch
  4 is patch 2 now. It declares prev_size itself, which the overflow
  path of the rework also uses, so it carries both Fixes tags and the
  two patches backport together

Changes in v8:
- roll back module_tags.size when the reservation is released, so a
  concurrent load which already passed needs_section_mem() does not
  skip populate for the freed gap (Sashiko)
- unmap the PTEs a failed vmap_pages_range() installed, a retry to
  populate the same range would BUG on them
- zero the separately allocated codetag memory for an SHT_NOBITS
  section, the tag area pages are not zeroed on allocation (Sashiko)
- .data..percpu is exported under /sys/module/*/sections/ with the
  boot CPU instance of the per-cpu area, and the interface is
  documented in the ABI docs (Petr Pavlu)
- keep a comment in apply_relocations() on how .data..percpu is
  relocated (Petr Pavlu)
- replace the "Based-on-a-patch-by:" tag with an in-body
  attribution and a numbered Link: (Andrew Morton)

Changes in v7:
- split the rework following review feedback (Petr Pavlu, Suren
  Baghdasaryan)
- new patch 2 marks separately allocated sections with
  SH_ENTSIZE_STANDALONE instead of clearing SHF_ALLOC
  (suggested by Petr Pavlu)
- split the populate failure release into its own patch (suggested
  by Suren Baghdasaryan)

Changes in v6:
- rework on Petr's prototype and allocate codetag sections before
  layout_sections(), the retry and its state resets are gone
- fix the layout_sections()/move_module() race (Found by Sashiko)
- release the reservation on populate failure as well (Found by
  Sashiko)
- only -EAGAIN keeps the fallback, other errors fail the load

Changes in v5:
- add Fixes: and Cc: stable to patch 1/2 as well, since 2/2 does not
  compile without it (Andrew Morton)
- restore frob-adjusted mem[type].size on retry instead of zeroing,
  as s390 and parisc add GOT/PLT space there in
  module_frob_arch_sections() (Reported by Sashiko)
- drop the load_module() mem_profiling_support check; the percpu
  counter leak is pre-existing and orthogonal to this fix

Changes in v4:
- add a new patch (1/2) to move release_module_tags() above
  reserve_module_tags(); the overflow fix is 2/2
- release the reservation on the -EAGAIN path
- return -EAGAIN instead of -ENOMEM so the module can still load
  without profiling (Suren)
- reset sh_addr, mem[type].size and sym/str SHF_ALLOC before retry
- skip percpu counters in load_module() when profiling is off

Changes in v3:
- use pr_warn_once() instead of pr_warn()
- return -ENOMEM instead of -ENOSPC (Suren)
- expand the commit message to describe the /proc/allocinfo impact
  (Andrew)

Changes in v2:
- return an error after shutdown_mem_profiling() to skip
  vm_module_tags_populate()

v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
v3: https://lore.kernel.org/all/20260805090633.141001-1-hao.ge@linux.dev/
v4: https://lore.kernel.org/all/20260810093955.153015-1-hao.ge@linux.dev/
v5: https://lore.kernel.org/all/20260812054105.102637-1-hao.ge@linux.dev/
v6: https://lore.kernel.org/all/20260831072104.120197-1-hao.ge@linux.dev/
v7: https://lore.kernel.org/all/20260902081802.146145-1-hao.ge@linux.dev/
v8: https://lore.kernel.org/all/20260907062414.106873-1-hao.ge@linux.dev/
v9: https://lore.kernel.org/all/20260908092412.115953-1-hao.ge@linux.dev/
v10: https://lore.kernel.org/all/20260915070001.113559-1-hao.ge@linux.dev/

Hao Ge (7):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  mm/vmalloc: undo partial mappings inside the mapping functions
  alloc_tag: clean up the populate failure path
  module: introduce SH_ENTSIZE_STANDALONE for separately allocated
    sections
  module: allocate codetag sections before the regular module layout
  alloc_tag: skip percpu counter allocation when profiling is disabled
  alloc_tag: fix the /proc/allocinfo lifecycle

 include/linux/alloc_tag.h |   2 +-
 include/linux/codetag.h   |   2 +
 include/linux/module.h    |   2 +
 kernel/module/internal.h  |   8 ++
 kernel/module/kallsyms.c  |  13 +---
 kernel/module/main.c      | 133 ++++++++++++++++---------------
 kernel/module/sysfs.c     |  17 +++-
 lib/codetag.c             |  36 ++++++++-
 mm/alloc_tag.c            | 160 ++++++++++++++++++++++----------------
 mm/kmsan/shadow.c         |   4 +
 mm/show_mem.c             |   2 +-
 mm/vmalloc.c              |  31 +++++++-
 12 files changed, 263 insertions(+), 147 deletions(-)

-- 
2.25.1


