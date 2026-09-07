Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D99F0C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5EA6B009D; Mon,  7 Sep 2026 02:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EB56B009E; Mon,  7 Sep 2026 02:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4346B009F; Mon,  7 Sep 2026 02:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A646F6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:23:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 419B4A0675
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:37 +0000 (UTC)
X-FDA: 85185974874.21.3F343B7
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CCF040002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nDLhsGpA;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=geglvbbKoxcI3pvCiwON0HSzEd65XDlxoDvDHYk7ay4=;
	b=nxFG+TogfbNxJjRyFUEgMKx6f5IRvIUGS8GbcowJE6P2PD1MiaUWt5GAGWCPFtozq9xS0p
	cLVSKjT0zdKN7LAYQax64gXXoo4BuV+qYppnhgbBSD8BTMjz08/cXjQRIT6/pe+y7q/7wl
	jMrAgIZ7uIIzkA2HSk6v/tJtl9r3b+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762215;
	b=YYuOsZQrYLn70iWiJFrylRw0ECuiSDBcx2oO2WRLNhOVvLErsnttLdAdr5lkD3CWel7gM+
	kIa+3pPOv3/LaQNG9tYNH2UibztTLy32Sx9JL1P1dytAsMY1NVh3C75zDzl71YA2bDrt+L
	JCL2w5Ymb92k5RqmvR8K2xANF1xfoA0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nDLhsGpA;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iofJ836+YzEQs/Tw/w+NzYdOjwVMo/HxstvPWWekF3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788762213; v=1; x=1789367013;
 b=nDLhsGpAJDRxQxbY8JjBKz89ZrN8SHRdwjOseOtAo2/xg1uPFiSwrsahjqvONlf4HHcwjhw7
 4LlqiDOU8R4Pxj3zFKdho8m6JVP+ry9f3RzO7EdnNJPTAbiS4qleQZmfeUTvFTPk1SGGWtgSlMW
 Qg1vuFwZ/7irm5NkTEaO2bVY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ed2dd9e98d084ace;
	Mon, 07 Sep 2026 06:23:23 +0000
X-Mizu-Trace-ID: ed2dd9e98d084ace
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
Subject: [PATCH v8 0/4] alloc_tag and module codetag section fixes
Date: Mon,  7 Sep 2026 14:24:09 +0800
Message-Id: <20260907062414.106873-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CCF040002
X-Stat-Signature: qkymt95rknjupmi7bci67k9oabb6j3sq
X-HE-Tag: 1788762215-739541
X-HE-Meta: U2FsdGVkX1/7ZgOE0ZCK6weL9ffeT/NZwugqfeVzY20D7eDbv/FOz17szXQODnq1apAhK1IPyIDtNCn69F+H//zdD2kaCbi/bWdarG6fxw37LCjJeFSpFmQqolfv1qMN26pEfAdMEIorq6Y6INXEmrScGS6cw3f7yHJujQ0rffHrpfMecJJ7sC35J9ytuqV8YV820Qs90AfOySeranXt5X5JwFfPgvgR3h7r5mLdb98u6PGKe4nEvX3T7bgXUc+ynfmJhYbkB6eF0BQ/CGTDZkxHGNhGnzHJKBt2iv2vGrg8yA12lseXUqXBgdG7HGrME2G+kCtyDNmHNWm9PBL8JFvadKfSu1HC5mIJprIatX75+6gnJGwuXtJI5d574DU/qPzAD1uLfT22g+w97MQvgAKD9QNwkZg7HGEDi0HZBAyDeIoIljSPnCcBwFrRTCIlOlO6pwvf9Y7kU2mNe0D0iI/5GKDpdr69HH5tGiobduBz/6mcaTU5fKXK1AQMEkHl3DTisXGPzNkVvqrt6APIYhnv+KwPdL43nFYus7duqfWV5FtyOMW+tONCpLXb+ULRgUBY4eU1LKF5p7MUCcnX7755AxeJjsTLXBgi/KKMDDivBbLYxJwPNrfU1NNnsYKKcIFl69B3oZDOXXE2VNu5Q25rXtDd3fXGkRFbvoiYnGj3AoK5VvtAdn0yiK0WLm5JyPQQRL0PJnG4PDobi0ZBlg/pu44PujSzezWe++g70EU4nktYiMaa+v5SBiD8xqysoxZVliS6CuOB2nzM+ndnah/FGGv6Qm7o7lifd57EUgS58aU2EMfFqbIz84FMD8vCHNomjbXOGCDcNcoshucSYzeO948Dz2F1qV5sGNHfPwu6NA64jnJpcrT+C98UKp0fG0/gf9l83fc0/uFV9Ru/obWenPDc7meVEMjUj7i8f+DN6VH9FDJ8o9iauzpetheNPXet6Gi91j7B8mNYqHQ
 WnMh5fay
 8FIgy/AwEHwbc2j90KEyiPHYvNjSUppsQpuN2ECcocKngi8aWK+XpRWy07/KPPb/UiPklhWQnTVvTRrDi04lx6AXjlTyzkkIwyd1lmjZbZmnL1cPuI1k4dDD3QbaLu09FqSiI4ksVnjulE4tH5bl/TVfxoDB2l18PzCCnDSl9UL4jKyEmC4nbJh4ky2cSIbjoKD05ENcG0Yb9PivmiKwvsZ3zhfFafmq0qb9TfESxlzuzZMYOMJ7RVUvzQx4n3CT8OfeQZLUri2+e9fYlBal69n3au42wrQwARs9RX6omO4cYEnlx58Q5aFlGpFl4Hm7u/v0HSVdWF99D5soL2XD2/HjgeOuFADcyxcZBOgCV5GW2+v8=
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

Patch 2 introduces SH_ENTSIZE_STANDALONE to mark sections with a
separate allocation, per the ELF spec SHF_ALLOC means a section
occupies memory during execution, and the percpu section does, only
outside the regular module layout. It was previously excluded from
the layout by clearing its SHF_ALLOC, overloading the flag with a
loader-internal meaning. The mark lives in sh_entsize now,
find_sec(".data..percpu") gives stable results again and
apply_relocations() goes back to testing only SHF_ALLOC. The
section becomes visible under /sys/module/*/sections/, reporting
the boot CPU instance of the per-cpu area, and the interface is
documented in the ABI docs.

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

Changes in v8:
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


Hao Ge (4):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  module: introduce SH_ENTSIZE_STANDALONE for separately allocated
    sections
  module: allocate codetag sections before the regular module layout
  alloc_tag: release the reservation when populate fails

 Documentation/ABI/testing/sysfs-module |   8 ++
 include/linux/module.h                 |   2 +
 kernel/module/internal.h               |   8 ++
 kernel/module/kallsyms.c               |  13 +--
 kernel/module/main.c                   | 138 ++++++++++++++-----------
 mm/alloc_tag.c                         | 101 +++++++++---------
 6 files changed, 149 insertions(+), 121 deletions(-)

-- 
2.25.1


