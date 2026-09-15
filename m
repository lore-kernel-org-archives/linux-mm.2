Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F5CC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE346B0099; Tue, 15 Sep 2026 02:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80656B009B; Tue, 15 Sep 2026 02:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95756B009D; Tue, 15 Sep 2026 02:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0376B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61C56A015C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:22 +0000 (UTC)
X-FDA: 85215095364.11.B89D976
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61D5CA0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGKjh1Gx;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jd6vDZXp4FQU8Fc34nevbJb0IfdSwbwlOY3RmYCu38A=;
	b=cCmAsIrHDOYdoJ2JQdvwHaaHVAkqauq1+BXp9ssOSsO2oLow/phzMhD7bKZJoxk3AyZ+FW
	LvA1g12/bqx76dNRwqosr1g3zkJb2pN9RVVb8Ij6aWsCg8D08AFVaJ479+pbYWfUl7x7Ai
	zStVfEjq1dH9j6XT1pGmpEHSpPAE0KA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455560;
	b=oF72h2CrhFtTdh8AWb0/CPrNoFBiZvYwTH+vMN+sdCb91kHFywM4OA3H16H0SxdMqmrciK
	ySgGeHQIvobuGY45Sc13QUQ+y+XmJApi1yeZ7cT4WcHEPkcQThAIuyJ939Ke9uxFwUma3N
	GN/zaEsNuDFZdMdlbKWHuHmsCz6nkIo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGKjh1Gx;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TXew7UKxHPC4CJEw9Ku1oOpgdOQ+ip6CfBvxC9mCB6g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455559; v=1; x=1790060359;
 b=HGKjh1GxQzJxIdfm7QULEQj2kfzmr8JqA4d3yS9Zl38R7neag6wnQ3in+G/nBbgFbJbmRfum
 eGxhOTC8EasgZxK/3yR9mWwSR7SsRXXuxArC89VNwt23lcgb42o9UADcfofwAkqnXZ+ZQadXgmv
 JPd9Ee5+u4ai4c8mr9ll3Vts=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1b15e78f739985dd;
	Tue, 15 Sep 2026 06:59:08 +0000
X-Mizu-Trace-ID: 1b15e78f739985dd
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 0/6] alloc_tag and module codetag section fixes
Date: Tue, 15 Sep 2026 14:59:55 +0800
Message-Id: <20260915070001.113559-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61D5CA0008
X-Stat-Signature: sfhbesr5ibysikxustc19jyfw49frtjk
X-Rspam-User: 
X-HE-Tag: 1789455560-689030
X-HE-Meta: U2FsdGVkX19+8z07bFpVFeIvseA+tfYpFE4bg6WAbqwkE3zoUs+RnUqa7K6c6NNqk2BaYUb501bAPZQIsM3JR2p2czgS6TE+mH9MQVd4TbaY6OTVpCF58eA+0lW7y43WwYPMX73GKhcun3YrLp2na1AmO5vQloSEs2ZVFd9e36n9x+hK0s3Yr07209dOrhGOW9o4mzlQiWwt9AKKgFuw6mJ/lxgnNbAX4kQDOMFhDaRnJwd6nZmoTE+KJoEgRU7yk8G5CKGrX9bykg1gskLwOdNNcTCMyv4EJ6tLrO6joGho6rd9dcQMIoVN20kNu0WL66O6ek8rjWbjSPeLFu/lEUcWNOxsaTAVKwvU7xeonw/GJ+ZpG2RptDFizI0Rbr2x+7Qq3y7nQb2K+cVw26d1usp35rmc48qTiIE5rL+oBj1KrbPUmsrg4SVbRtRQGat6z1aNdVv4l9N3lLDxfxPN3tDu3KCqfswTey3byWwB2rlzPkamCumGf8if7r6j7DsuMBIBD88Gwc3rBUdH1j0ZEylFv0oVAkjSDe/5p3YhWUwEKhtM5FOKYSpc+HHbM7bdgzBJ8MnQpLlAII5EGy5en9Y/J3a6QHg8ZgvvP5SQ0G2i1LzHOHNRpAgooSJoMB+tm2v4Vz/ACucqhiP35FwZNV8YKe5f2BGZi4XB7uQzrZiHlGsvFlTDnY7aKe8/ySlVkXtNJcqYljaBrJI+8zuxeCXlcPxBNIEC0dT5GsneAvBSg+yYMGzyc1YLQwypIDHJgsvZ+bFho065EMNvGSSm3FzM0K/SqERvP/R0TiKwQZ3nS93/pAoZKGqD3x57a5SxmmG5RFlXr5TM5bnfpIeEy8xKFwSo+jeWVG1r9swCM51MOldS/fsFUoR2gm/bxcLJdxwOjUQVCFdU6r1zZPo54OUB8dM5B3Glo8I0X0dwsrvcqZnGSEkhJdDuQPNs8/oEgpUjQdt0sgMTyq/zdez
 Nx2OqQDF
 m2jNT0YvXj+5ZRvPr01Q5dUBlCd30QmaqtkDpk5npN+PUy+08MootRcz0xv7Npv4T1dypbOQM24w0CEyDLrtAbvxOvJtQrq55vhMuuyK4iL3+v+WgXBGIjozsIwQ542KRewgFjDAnK184UeQI7CKMT9sUa718X4dM3OlGtgik6hsiGVGB2Kn9E1hDsbqWHilivUcmS94iWcBeiIh065pNSPQwejsk12GML07kWIS3GcRcjnqyfKDrABZqcNFRp85YTlCusvU5Fs4nVWLJzEpo0Kh7VUJVI7z430O9RdZ6+13p4xkjiFpgfYmHo6g8oC0cQdzAOtavBHirra6Cjr7/feQqQtLo5mPBL9i4ZcCODFhSoIQ=
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

Review of the earlier series by Sashiko turned up two more problems.

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

Following review feedback from Petr and Suren the series is now
split into six patches. The two alloc_tag fixes from [2] are folded
in as patches 5 and 6 and replace the versions currently in the mm
tree. Sashiko keeps flagging the percpu counter leak [3], patch 5
fixes it, and now the whole set goes through review again.

[2] https://lore.kernel.org/all/20260817062726.106511-1-hao.ge@linux.dev/
[3] https://lore.kernel.org/all/20260908094736.2B1A61F00A3A@smtp.kernel.org/

Patch 1 moves release_module_tags() above reserve_module_tags(),
since the failure paths now have to call it.

Patch 2 cleans up the populate failure path: the reservation is
released, module_tags.size rolled back and the PTEs a failed
vmap_pages_range() left behind unmapped, so a later populate of the
same range is safe. It carries both Fixes tags so it backports
wherever patch 4 goes, which uses its prev_size.

Patch 3 introduces SH_ENTSIZE_STANDALONE to mark sections with a
separate allocation. The percpu section was previously excluded
from the layout by clearing its SHF_ALLOC, which per the ELF spec
says the section occupies memory during execution, and percpu does,
only outside the regular module layout. The mark lives in sh_entsize
now, find_sec(".data..percpu") gives stable results again and
apply_relocations() goes back to testing only SHF_ALLOC. The
section would show up under /sys/module/*/sections/, but it has one
instance per CPU and no single address, and the entry never
existed, so add_sect_attrs() and add_notes_attrs() skip it.

Patch 4 moves the codetag allocation out of move_module() in front
of layout_sections(), so the placement is decided in one step and
the race is gone. On overflow profiling is shut down, the
reservation released, module_tags.size rolled back and -EAGAIN
returned, the section is laid out as regular module data and the
module loads without profiling instead of failing. Any other error
fails the load. The release and the fallback belong together,
without the release rmmod hits the stale entry and panics.

Patch 5 skips the percpu counter allocation when profiling is off.
After the shutdown modules load their codetag section as regular
data, load_module() still allocated counters for every tag and
release_module_tags() cannot find them on unload, so they leaked
(Suggested by Suren).

Patch 6 defers the /proc/allocinfo removal to a workqueue.
shutdown_mem_profiling() runs under mod_lock, and the synchronous
remove_proc_entry() deadlocks with a reader taking mod_lock for
read in allocinfo_start(). The file is also created at the end of
alloc_tag_init(), a leftover file after a failed init would panic
its readers (Found by Sashiko).

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

Changes in v10:
- fold in the two alloc_tag fixes from [2] as patches 5 and 6, they
  replace the versions in the mm tree and fix the percpu leak
  Sashiko keeps flagging [3]
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

Hao Ge (6):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  alloc_tag: clean up the populate failure path
  module: introduce SH_ENTSIZE_STANDALONE for separately allocated
    sections
  module: allocate codetag sections before the regular module layout
  alloc_tag: skip percpu counter allocation when profiling is disabled
  alloc_tag: Defer /proc/allocinfo removal to a workqueue

 include/linux/module.h   |   2 +
 kernel/module/internal.h |   8 +++
 kernel/module/kallsyms.c |  13 +---
 kernel/module/main.c     | 133 +++++++++++++++++++-----------------
 kernel/module/sysfs.c    |  17 +++--
 lib/codetag.c            |  10 ++-
 mm/alloc_tag.c           | 141 +++++++++++++++++++++++----------------
 7 files changed, 188 insertions(+), 136 deletions(-)

-- 
2.25.1


