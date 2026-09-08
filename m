Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A99EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A6B6B009D; Tue,  8 Sep 2026 05:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA906B00AB; Tue,  8 Sep 2026 05:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3D46B00AC; Tue,  8 Sep 2026 05:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37F3B6B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B34C212045F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:00 +0000 (UTC)
X-FDA: 85190060760.04.0C23CF7
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF1ECC0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:24:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=voIjrR+9;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zjQzRyEeJRjIxmN/yjc9b+g6tX1AMMhanHRn8PYv4Dw=;
	b=pTGdutz6SQYyB1WzEMNR9Zl0UlFgLdWvFsYE6gg9mN3h1OiGSfYNI9W8MpAoHJB8/sNEya
	dJQVWiOTAB85BuVeHaFndjBP+/X+4hdCYjDhRbh6d+tt2XSKojyllK+yhYaHdE+ckFkM8r
	fFwXG3JebvYymiVl8MbV91JhkvhNjqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859499;
	b=StBOugD6cRDQNCdFzRAhE7g6lvHEKS9VcfbnKrjuBXJlVeQ7/pwZmC/idf3GA10mzkmp/3
	0GYPDdL76o7WHxlQ7QI7buGkW2Wo8zWhUQtR8iITmN/OM8M1VoSD4UlFps4itKcWVxjIWE
	tQeATJZlBfh/5fOADZDpWdKeASa4BgI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=voIjrR+9;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qZoCBZiXzbympZO5SLiimtaqd6GAU+iP1rCRMtmMRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859497; v=1; x=1789464297;
 b=voIjrR+9XJaqu54GxR6300ZC05hac+AggwGJozFCbwEWFRrXXB0S4OLmyvKOeIiIvjOoKmot
 T9M8evRZutvus/A6pAF+Tga1LVus7qr7I3fJyBaJEkKYrP9B31ToN0FPfn07b3uXLFyqtnQAn6t
 S3vRGoT9iG2+lGrvaJesszs4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c51440bf5b683b70;
	Tue, 08 Sep 2026 09:24:57 +0000
X-Mizu-Trace-ID: c51440bf5b683b70
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v9 0/4] alloc_tag and module codetag section fixes
Date: Tue,  8 Sep 2026 17:24:08 +0800
Message-Id: <20260908092412.115953-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: af1xo6ixdrc8g5igpy4dk6yo4fthodkj
X-Rspamd-Queue-Id: AF1ECC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788859498-730143
X-HE-Meta: U2FsdGVkX18m79OKHe8HTlB1dlEVRTkGscSh8Ry5/8jBsMmqso9E28ZO4RfGQVssm5Z0ddImgq180bO/xu3u69Y80432QQ19HWWLU4LrimBaNtbUqs8r4IgYLXo7eKBKn/1BlqXbXBKE/B25MfF3hzKXMLTiL4u3mBiHCWBAHdi23cHoy3R4dMHl0a5jcM0gSuR8e80Q51vgMh/q0FtZDBm7D0Goi4W8H9K18Zssv+oe3Yx4VLozfSFvINlaQbCBKfVBEH5xVGl8okh+XwIll9gCRR5iQoqKvKSo+Re1jY9O7oP/RRbYPPI+7OlftStcQs5otufrF1R5bM6WA69gt76kY8i21lU3G3/Z8LR4nrtZ97EhBvtD6QCNPlfLrZ920D9HmRXTW88TPKz31tO4CV3aRDEF8ADk+erymThpSuqGm3pT0a0AxfMsV2AYCIOlMQCpUgY1Mk7ppe3uEoot/JJVeVtfak5A7l0Iv5FgwORzbJj/6P3Okgvc4aRVPhg0raCeqxq/zYt5aU3E/mkjEvXW/QfnxFK0q4hkkrjJHmsDNrmCB06kB68kNA1+RSOJf4p72+VcOMiy+ukXH2dQxmgTslWQOFQq7NSLZRU+TCu/ZzsddB30Wmcmm6ZrCj+GD6ya8Tfk3MuIFLw+W6r/qJXM0GXzkVfIA/4D5845RtbE8z4xyfhrb+ctyoiAs0/WWE58deWI2lCCxPR/QBrFgcwaccoEh5tIje3wFZZNNMi7/Kzb+J7FH4gFIdpq/CcnrTUdZwrAslCzr8U7kohN1jeK3g8e4hfVlRhfMa4rWUXV7FcTB0nUson6b2YVLPeNAb0eNCo0iysLq0YEAMT6xTjBwHdjnMUC/ww6X6ZDJ0INPw1PL2xRyqnx57GCEv8ny1waTEm93AP0djsK4IxtVcEQMuQEQTH1hMS/n/bym1YzT5R25wMxuKo3p3e17lbZaAn1FYFRfNZbMDK5Ymv
 VHsq3xIQ
 ojS1M9sn71t92SuWpvSQAt9dENjCZPPMZsskuYd/MVE0ZsYvjUphL1UXCBbz7gOOOz2r2xal8igiErefxXrerL0lwyAPip/XOBy4RR2R9RNz7i9uVVV6QV+Ko3ZqtiFljVkjNJrwG04Ew3qdb3dbyHFhno+SHca5EG4Y3KRx1cFi2KkjfuERYL+rDLawnNAFb2KFXsmjzJ2kwqnki4udQV/2xhqnAd9qysbbbXiJPaamtZ0LHJ0esmfBqEBuzZ9Z7FiMBxRbZrMDqs1KByqVG/khMbiBo6XDiAlQoaA/+KMF6oC+p7GS/V1i354g0kavuF9PB+uNXROxfyEV25LK8fWkRoHReCCzqBdksVANs1EekbbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I ran into an overflow problem in the module tag area. With profiling
toggled off, the overflow check in reserve_module_tags() did not
run, a module could load with more tags than the page flags can
address, and re-enabling profiling then silently corrupted
/proc/allocinfo. On overflow the fix shuts profiling down, releases
the reservation and returns -EAGAIN, and the codetag section lands
as regular module data in the same load, so the module loads without
profiling.

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
split into four patches.

Patch 1 moves release_module_tags() above reserve_module_tags(),
since the failure paths now have to call it.

Patch 2 cleans up the populate failure path: the reservation is
released, module_tags.size rolled back and the PTEs a failed
vmap_pages_range() left behind unmapped, so a later populate of the
same range is safe. It carries both Fixes tags so it backports
wherever patch 4 goes, which uses its prev_size.

Patch 3 introduces SH_ENTSIZE_STANDALONE to mark sections with a
separate allocation, per the ELF spec SHF_ALLOC means a section
occupies memory during execution, and the percpu section does, only
outside the regular module layout. It was previously excluded from
the layout by clearing its SHF_ALLOC, overloading the flag with a
loader-internal meaning. The mark lives in sh_entsize now,
find_sec(".data..percpu") gives stable results again and
apply_relocations() goes back to testing only SHF_ALLOC. The section
would now show up under /sys/module/*/sections/, but it has one
instance per CPU and no single address to report, and the entry
never existed before, so add_sect_attrs() and add_notes_attrs()
skip it.

Patch 4 moves the codetag allocation out of move_module() in front
of layout_sections(). On overflow reserve_module_tags() shuts
profiling down, releases the reservation, rolls module_tags.size
back and returns -EAGAIN, and the section is laid out as regular
module data, so the module loads without profiling instead of
failing. Any other error fails the load. The release and the
fallback belong together, without the release rmmod hits the stale
entry and panics.

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

Hao Ge (4):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  alloc_tag: clean up the populate failure path
  module: introduce SH_ENTSIZE_STANDALONE for separately allocated
    sections
  module: allocate codetag sections before the regular module layout

 include/linux/module.h   |   2 +
 kernel/module/internal.h |   8 +++
 kernel/module/kallsyms.c |  13 +---
 kernel/module/main.c     | 133 +++++++++++++++++++++------------------
 kernel/module/sysfs.c    |  15 ++++-
 mm/alloc_tag.c           | 111 +++++++++++++++++---------------
 6 files changed, 158 insertions(+), 124 deletions(-)

-- 
2.25.1


