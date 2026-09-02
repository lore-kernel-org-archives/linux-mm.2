Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C93C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506986B0088; Wed,  2 Sep 2026 04:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B76F6B00A3; Wed,  2 Sep 2026 04:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4756B00AD; Wed,  2 Sep 2026 04:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6056B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:17:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88144C010C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:33 +0000 (UTC)
X-FDA: 85168117986.23.1BFCAAF
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA6F41C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kAfoEyAV;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=28dCxSdhkR/tlUFksmErbIT1Xfkyo68Yuayoig9ajto=;
	b=VBdPM5TuXQFLUbFsujgjPovINQL2P7HTnlVQNIRbZpZ4uUF25KbWxmsc8sc24tVYYJtl1D
	7MIajWgDGmpEYpALAPfeq2UrPageTy+a0YxEfow0ESnTVdr5XqvtddQBA6pmECkIz6QAH/
	bJgPqgnyHLASmA3n95JGXZjmdKHZLt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337051;
	b=WdrrCq8MqCevxUEZzQzgFq0vgiBijeQtg7hyQtLqDvh9JCZ9LtvcKrKzqtSW1xyVPZnVzA
	NVWEh53Er22RwBAATx5NbgEw1S1B4lYTFXKsSQNF4WEE02uOv9X9qc5+ueRpjZ1pyQKz5J
	VXOYdZCqpu7X+bEAgnXekbcJVTTJb1I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kAfoEyAV;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AHq5uwpwna5WtqCl9L8/HfyXXSRhiGwW726UtUgZVvo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337047; v=1; x=1788941847;
 b=kAfoEyAVjzB4KN/GUdF3rKbxCIAgcoNS54Jk8fRfM+qiB7/uuwPRuJS7n81HQx3f3jo3D7Is
 GG9CVnWir8o1HIIYpRNk2ZLuIPjRvvT10b8DbRUrLthASWf5ejfXBksXoZ09JGXqJ8Fekr3QDSc
 He1YnRzcR/3lriLJFk5HGwK0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3113f6cdaea4f218;
	Wed, 02 Sep 2026 08:17:27 +0000
X-Mizu-Trace-ID: 3113f6cdaea4f218
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
Subject: [PATCH v7 0/4] alloc_tag and module codetag section fixes
Date: Wed,  2 Sep 2026 16:17:58 +0800
Message-Id: <20260902081802.146145-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA6F41C0003
X-Stat-Signature: id41ss7hrm3gtue6johb3tmxoiio87ud
X-HE-Tag: 1788337049-623796
X-HE-Meta: U2FsdGVkX19hiH/xTLAjFBRUQN2fDQfufpdBd6PZN6SpxdgdVlDWBOAUTMjlVK2cG8mhpyqwl9JtoJMSneL/LwDzOOz8D6m8ENISN5A/d/VpSnrZxwnY/YRnQ9fn11JHux48pN26MW7EFu3TKPdpsj+6XRoebt8Xw1KhMWWIaS/hDm2oiARr2gJTMwAEeL1CHDAnbZry+KwVx+8nC6jmMxNbePGjqWbyHSBEAPeDOl9yKK/pbePnGI7gQcSYLTGfd86xxYhPJQyy/M+6E8FqxGpkOPm7/fFjPnxKEmFNi5gxK6tfqiFEjL2rj1EiDpjSvbnyBarfrWAqNTWmjZyQFJx/ngCRKoMXhqR9SZpV49jL84C3pgU3s8V2osgapPkrAR7YxCQJ3X77YXJau3jLupnHGbP8DvE/dxiJmge/FkdHVES5oES/XrC2GFCpwDG/MGFr51HUbynw0fjLGViXshnI3D4YgA2bTcfQe1Qqw/KgU3qBiEDVgjWGoEa5DrGA22pc7/68pQn9C514VXMGcxwK/LnGWtorYUlz6R3+lZRCcSPy3wOg4bkeoecfPYid4pVn++UFY/lqjoxkKo7yLTCy8wB4ojL3nSY1WUnO09fSdHa2MTxCWlFPxT6uMr8Hf/0HPLQ/Ux/NEFTA+OPFkqQ21vOfNvaOrsD6mZDpVMTKDdnqlu+7LZd3yWmR2JY2YNTlzkGE7zTQZjpv33WMToqaG2eUmoXoh9BiQn7bzSMtzHBIk68hwtbBFz/lWO/fSCBGM5hX1O4wo58hL1ys/C0EE/wpWrpqRoNqAghlTiMpXS1+SIFCyizGXCW1O0LkZnooSXGmIXV4g+mCFQYouDPqffbW7wDrnz6tglW4kiIQCA6lyeDqNr36B3hUyR/tkSJG/TImCvMgD/HjL1h6IY8LMhKEdhlsdoWh/DZNISTbq74TAXXydz30KZBuxaVIbYD1cfCbSStmsuPvrpZ
 jAPXzZp8
 d4BErdOR6FsbfLUjfE96pFLE+fc4nqmlMRVbBGf5R6nIWkWY/w829fF2dtadr7uhMkeYxlTwb18kBo5BKT2OaCt6g/9oL1+ACEErfel5jN1PcFsFoV2E2LYikSAkUWKHwJhrqEW8W+TNLMBHfTgOJndNBYPrFrI9G3zwn8cYCeJl+S2+cbp1M4AzYc1QGXGy0dYzjTFY4mpvpYIrxNjNiZJnqXWdS3xM+OfNif7alBQDozRoBPS814eh+Np/RpKLomX9BkkWeJYlQV1SXigRYt38JpxrzWyaYzsX25iD77zlPpAM=
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

Following review feedback from Petr and Suren the series is now
split into four patches.

Patch 1 moves release_module_tags() above reserve_module_tags(),
since the failure paths now have to call it.

Patch 2 introduces SH_ENTSIZE_STANDALONE to mark sections with a
separate allocation, per the ELF spec SHF_ALLOC means a section
occupies memory during execution, and the percpu section does, only
outside the regular module layout. It was previously excluded from
the layout by clearing its SHF_ALLOC, overloading the flag with a
loader-internal meaning. The mark lives in sh_entsize now,
find_sec(".data..percpu") gives stable results again and
apply_relocations() goes back to testing only SHF_ALLOC.

Patch 3 moves the codetag allocation out of move_module() in front
of layout_sections(). On overflow reserve_module_tags() shuts
profiling down, releases the reservation and returns -EAGAIN, and
the section is laid out as regular module data, so the module loads
without profiling instead of failing. Any other error fails the
load. The release and the fallback belong together, without the
release rmmod hits the stale entry and panics.

Patch 4, split out per Suren's suggestion, releases the reservation
when vm_module_tags_populate() fails, so that path stops leaking on
its own.

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

Hao Ge (4):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  module: introduce SH_ENTSIZE_STANDALONE for separately allocated
    sections
  module: allocate codetag sections before the regular module layout
  alloc_tag: release the reservation when populate fails

 include/linux/module.h   |   2 +
 kernel/module/internal.h |   8 +++
 kernel/module/main.c     | 130 +++++++++++++++++++--------------------
 mm/alloc_tag.c           | 101 +++++++++++++++---------------
 4 files changed, 127 insertions(+), 114 deletions(-)

-- 
2.25.1


