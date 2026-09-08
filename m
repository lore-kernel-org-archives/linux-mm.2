Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8E3C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91B96B0098; Tue,  8 Sep 2026 05:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42E76B009D; Tue,  8 Sep 2026 05:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EFB6B00A7; Tue,  8 Sep 2026 05:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A11346B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:20:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D4EBC04A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:20:26 +0000 (UTC)
X-FDA: 85190049252.19.A9AA634
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F9FE40005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:20:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DHSoiI7i;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859224;
	b=Usr9aER3ljXC2WsLqPG31su45Jfw/e3LgfJtVOtJZpJJN9OGRLHlFWTuMRFZ6W3a/upveU
	hSpH4xeqrcfJh6oKl5iVxAew160a0nP3Y0ghThDl7BQi7jsUXbhrSlBL/CmKjo1i4k94iP
	KVUX1+jJbgLyps8SeiYDp6JDFrR67/g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DHSoiI7i;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zjQzRyEeJRjIxmN/yjc9b+g6tX1AMMhanHRn8PYv4Dw=;
	b=Ac09h2cPIcB+GUe0DtFDfYJpMGTS3nGOpNxn+QR5wl36+WJBgWmAfOeOvoPW3DvsfEkxkK
	8M5oLwCMxD5TlmVgtV8F3WpnaI0Hd0EX4Dl6whPRJnhEgnikWNl8EBCOy672CIBT7GjgSe
	lUNbiN4SSJxEviaMWxeCaoSjGYn8zhc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qZoCBZiXzbympZO5SLiimtaqd6GAU+iP1rCRMtmMRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859222; v=1; x=1789464022;
 b=DHSoiI7i9PadDXaHGYYRM7Z6gCga6zhOKAeTrBQ41U24bO7hVSjCsx3DMUO3UO8dAL8I4AUA
 pulanhEvckRq8pi4JFvxiZBxw6QqkEX1BHJaANSc/vDWIhEnYsj7NJ9REgsh4bnqzBwO1lPqsX6
 /wANfbr8//vHAacdRP8xPPDQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e276b89a933e5cd;
	Tue, 08 Sep 2026 09:20:08 +0000
X-Mizu-Trace-ID: 6e276b89a933e5cd
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
Date: Tue,  8 Sep 2026 17:20:51 +0800
Message-Id: <20260908092055.115123-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F9FE40005
X-Stat-Signature: af1xo6ixdrc8g5igpy4dk6yo4fthodkj
X-HE-Tag: 1788859223-750686
X-HE-Meta: U2FsdGVkX1+EftQIiZEuTrNaS7e1eBfHo+4OdY24+m8SqpJaoZi+BqjIauNrP2bs+mQqoVFBPxSAqiDZq7f6oOBs5kCe0PnY5J82fVNROBPyOM9bU+XccBHeCDF1NH7jeGGveS4hSrJcnSRtBoxk1sBMHS5Udf4Qld4WhTSGTXKtrzbeUGOH3pXZ/+1e4vGVkv2BaZtFXqMCOo5te24Ki5/gSLqXyH/8o+wv3uqQYspl4Ip1fM6KjFSTGtwmrvU11hZF6z/N03tM9yr5eEx6cEJTapF31UbvlL0PC3wYY4Ph0jXTLGbKELotgZ7Iy3mEfxnvygLvr1n6QjmsPeLlHF2xkiOjQhTRMF0bSAPA8HfbIx032NUw+FiG+PlCMefO0K1vWl8sWi56FRc9DfEejpewMWlpmID6mNeP+Fqgta8OExMYmArQRK6tgpOihy44oOXzZPI78cYP3NF2B0jYOa7k+Zg9TxeTkTlcp0TB3Sy90vk7NbN0U2FpoTRpCuHR0djlbg42w1vms6Zja3OGT2KPlMVzKzIchzLlYIQ5m3eXTVR4raiOH0BG0d4hPfsrl/Z1JloP9TPQ+ZIPImKDjDqe7nB1Kr+05iC0kciQhrDt3A0hkykQ9+CZKV4I50faPDMayjctKWOiPr/sxN/BbryFm7c7MvOMocBjsi2CkTHeIT37csDlaWdxQdlXLL2yzso20UwczTi/dzZpsv7wN0uDCHLMyVXnBg3yT0kil050g8TJuyKlP+Osv5eNwTA2hQM2IVU6gxZ/GZnlqNuchRp+B3y8yXUQdrlTPdeOIPq9xnEDxS+7MIJ3tagewDGm3beg24HS06yiDoxPyDs5LMNGVyQPyvNv7zbUiETSsl7+g9l47kPhVDVgvKLSQQLzEeV9uKfaQyGATPZQDZSM5lXd71fBfDuJVSfVAqmDNKI5gcjM3tWLRAIHbSFawaAJmuvbztCatmlUMbDAU2B
 XzxauuIn
 mfHZ3Dv2yYhXkUiBGTJZDDE0FR6D6cfwsIZYX+HGFHmH/zxbZXamYMdNUMZwZN1suevgClo3IcourW7o+uc2Gg8hh5mSzbPn+EIw4Wxgv+nEotGUGf8hD8wXZ9VNXhqauNGB+nbBiVfO+SWsI3EH/9sfGIyvlnDsvP6Nqcx300Z/pbaM6OJKqCOt7wSuRI9O3vu07anV0zdtVUZSBqEeeAfpDc3TtI+zWOIExg98rdK+Lqhn1naZej3XXMtki6CC7NwMWUcxeyqRDc+p9idXjihJFlSEV/h+JkT7Qr24tSinmpJFuNleuUYtgLLAngREmOMbshUjNKnhzWkS+lNjFaWsp4srs61lkFtJHMeuGtkRmw1Q=
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


