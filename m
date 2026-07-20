Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF69C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9586B00A0; Mon, 20 Jul 2026 08:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9756B00A2; Mon, 20 Jul 2026 08:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998A46B00A3; Mon, 20 Jul 2026 08:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53FBC6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:03:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0C641A0162
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:03:46 +0000 (UTC)
X-FDA: 85009020852.03.B8AB0C5
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E454120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:03:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gkCwPRf5;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549024;
	b=CGFKyT6ZFtqrtUPwmIA+CE8vDw553R1dsKxjK0Im3FsPrtBe7UgiemoG+5/OHHlbn2JC2L
	53RtsUjRM0Czyok8J/J1tWHy47IIqHOPsCVGqFEa0O2oiNQvWrZ52LQF9HHpB39sQ3SWOe
	NhLVPC5GeFOZFV7Ai8HTAtgDNQI90ns=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gkCwPRf5;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YZqNbH2if8hUjJ9Tg0ji4lns0q8vnGSCzJjMbirHpIY=;
	b=vZkpAp65HwLcErlodUAZYDv9I6sD3pjXAVZBaTwLSYKgztqfS3nQZogsiAHy8cdgv+2J6s
	zBLCnJouC3TmP6SBEmy23iAyZXbZRPlQymY52FwBIm0kSlbE5Sr9TqEpDKsiVjm4e2oVl1
	sqW9z+Rg34nelSlbwBBZBFoL5Kj8LDk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549017; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YZqNbH2if8hUjJ9Tg0ji4lns0q8vnGSCzJjMbirHpIY=;
 b=gkCwPRf5OYelaxFVRtKt2pX6aAr6564lfQVdWzI/8u1zpF+AsHXRRIKPToXgWn98sN+/DA
 iYK5wbbtKeSe5lSuHiD5cUWQ1Vh/ojJmqoOoZTrfQXppfYLWjYf5fwQnIK3jmB61mLdZhF
 PnhLSlRBoVW/dt19LEKrvQPlDz3qOez/E1DYr1E2fbkwBW+B8ZbXcXQQj+G+VFNBSr/jHn
 b96y96OxdjRHVwUDBAcmnFB0pUq8hPCEsbRQfXVZ2BHUfDnmrS/ou/qz+oTIpU/2YYFyRN
 47TyiJOUkhXGqT8FS2hNb08QIoB4r9RQea4uhn0GgAZ3I4JN5UsgTwArRfKDAA==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5e0e98+9b7e7e+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
Date: Mon, 20 Jul 2026 20:02:49 +0800
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E454120002
X-Stat-Signature: p1e5xhjzn7t7aq13i4ym8so3nm34w3br
X-Rspam-User: 
X-HE-Tag: 1784549023-783991
X-HE-Meta: U2FsdGVkX192GynAbS3B1yqNO/TWCfJj637PLIb6CFHJTuX/4IU1n9N/i+5OtQa7HfqE5sjh+raX0E+xWiBPDAm9tYo4r2Fr3gPIuppi0qvyqu8ALywmM2vfi48ydZgmuUVaLuu8/rEjfnVewaKShXae0eyEIZA31+NfpFA/zfOmrx9jrNqbp6eFRqpEwvJ3yW4aZG0P79t+XYR1E2XVgjgF/GRqZzJacWEKQEoRzDdPWPdxtbrgEqzMozAAwuoMjtKEkHmUvQMG6Wm92Y9mxlEtKoRP1cJhQ704an4y5NHCfhKpmSYkFxyMQz7PvycWHRIjAj9tQcd+pX4FafTJD+dqvJxQGS0xv2sEy37Be4HQExOYZLROb+b85AWM55LjrBgl45We4bShvKTylSAcMcvafapuwtuqmU9c7JVa7M8q83fv8HJiufgbViQJhUc+oALDDsN7NJirG/eqEqYp2HpVQxFQqxwVmFKwN0OgZusJoNoAh1v4vC5ua3VwD3Fwn8f8mINWbC+i+laE6J8BUYIYtxot1E1rVRY8w5jfGfB3+hF4m17S73Ggn1lXgVL7TzAf8zeml8v81pSQqUg0+xTAble4lG4iMO9yelkX/CTxT6jOBIkYTIbbDaCAXkdMTmCjeqNHx7ghUUygr9zP4WX64Qls3Xo5cHy5+qcSwrfcNHitZZSXqq/B37Qde9mn8G6nNvdkmuAEWA2DI+ILE95M7y8p81guU8sNYzpWOe6UpePqtSZ6YX9xLKVGUhTuVWMEfxy53bzeC8mQNksBBlw1x1HCMveJy1FH33+PlKAgVgHd+c/mweh9meQYUaXkJKBDV3OzFn6n9PGeuGAJh2WCUpV7YP3p3oycfm6RChT2uFqRO4869EcZuhE5Q8scFsG2lGr0DwKtdYOIy3DRzL4zG/GAJif4jVnyBtHYnY+KB/5nx9HFHcSP3pOQRd3eQ9jq8Znzq8E+k8cSA7u
 t0NZwyCa
 wgbo5ZXzo+IKhMhmZv05tqCmHpUqmGcvRyk2ZN7s6csX3cTqynJxQPxsitjFDAuxtTqKbulRBLV+H0Su8KppXsai4A+LwbAV5QOOJ6yk+EGHChi0nctg+SBiMvr/9EIpLO59QLxUadddUswRuAE6G3jpCcagKSAFUPGhn0yNXsC0fmzMa//5LOf8ySx9WUJxt9yXyGAi2rHQtAY2zBF6M62zmeSP+/ujN8N6k497SaTJ3fLiaC8aFEeqHpMz+HPdL/0MpKwW+uFisb7uFYu3M6JQj/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can take a noticeable amount of time when large
pmem namespaces are bound or rebound, because it initializes nearly
identical struct page descriptors one PFN at a time. This series reduces
that ZONE_DEVICE memmap initialization overhead by reusing prepared
struct page templates and, on x86, using memcpy_nontemporal() for the
template copy path.

The main target is large fsdax/devdax pmem configurations, where the
cost of initializing the memmap shows up directly in nd_pmem/dax_pmem
bind and rebind latency.

Patches 1-3 are preparatory cleanups and helper extraction. Patches 4-5
add the template-copy path for head pages and compound tails. Patches
6-8 introduce memcpy_nontemporal(), extend the x86 fixed-size
memcpy_flushcache() inline cases used by that helper, and switch the
template-copy path over to memcpy_nontemporal(). Patch 9 removes the
remaining local opt-out predicate and always uses the template path after
the first real page seeds the reusable template.

Architectures without a specialized memcpy_nontemporal() backend fall
back to memcpy(), so the template-copy optimization remains available
without arch-specific support. On x86, memcpy_nontemporal() maps to the
existing memcpy_flushcache() backend and can use the fixed-size MOVNTI
paths added by this series for struct page sized copies.

This version also incorporates a round of review comments from Sashiko
on patches 6-8.

For patch 6, the generic memcpy_nontemporal() fallback is a macro alias
to memcpy(), rather than an inline wrapper, so architectures without a
specialized backend keep the usual memcpy() FORTIFY coverage when object
sizes remain visible at the original call site.

For patch 7, I re-checked whether the new 32/48/64/80/96-byte MOVNTI
cases should add a separate alignment check before staying on the inline
fast path. I re-checked the Intel SDM together with the existing
memcpy_flushcache() behavior, and I did not find an architectural
statement that would make those new cases require a different
correctness rule from the long-standing 4/8/16-byte fast paths. This
series therefore keeps the new fixed-size cases inline without adding a
separate alignment check.

For patch 8, I re-checked whether the template-copy path needs a
helper-level drain after the MOVNTI-based copies. This series keeps
memcpy_nontemporal() as a copy primitive only. Callers that use it for a
producer-consumer or device-visible handoff must provide the required
ordering. The ZONE_DEVICE template-copy path uses it only while
initializing struct page metadata, so the copy primitive itself does not
grow a separate drain contract.

The numbers below measure the time spent in memmap_init_zone_device()
during driver bind/rebind. They are not measurements of the full
nd_pmem or dax_pmem bind/rebind operation.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series applied:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average memmap initialization time measured during
rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.

As an additional data point, I also ran a smaller set of measurements on
the same physical x86_64 host with a 100 GB PMEM region created via the
memmap= kernel command line, configured as fsdax and devdax namespaces
with map=dev and 2 MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series. The physical-host numbers below are included only as
supplemental evidence that the same optimization also provides a similar
benefit on a non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
once, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.2-rc1):
  nd_pmem / fsdax: 179 ms
  dax_pmem / devdax: 264 ms

With this series applied:
  nd_pmem / fsdax: 82 ms
  dax_pmem / devdax: 113 ms

This reduces the measured memmap initialization time during rebind by
about 54.2% for nd_pmem and 57.2% for dax_pmem on that setup, which is
broadly consistent with the VM results above.

As another supplemental data point, I also measured the test_hmm.ko
module on the same physical x86_64 host, using the test_hmm.ko setup
from the previous discussion that times ten 64 GB
memremap_pages()/memunmap_pages() iterations during module insertion[1].
By default, module insertion initializes two DEVICE_PRIVATE dmirror
devices, so two avg memremap values are reported; each value is the
average for one 64 GB chunk.

This is not the primary target workload of the series, but it exercises
the same large ZONE_DEVICE memmap initialization path and shows the same
direction of improvement.

Base (v7.2-rc1):
  avg memremap reported during module insertion: 116689362 ns, 116539263 ns

With this series applied:
  avg memremap reported during module insertion: 54607108 ns, 54458236 ns

This corresponds to about a 53.2% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.

[1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/

Li Zhe (9):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_nontemporal()
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_nontemporal() in zone-device template copies
  mm: always use the zone-device template init path

 arch/x86/include/asm/string_64.h |  68 +++++++++++++++-
 include/linux/mm.h               |  15 +++-
 include/linux/string.h           |  12 +++
 mm/mm_init.c                     | 131 +++++++++++++++++++++++++------
 4 files changed, 198 insertions(+), 28 deletions(-)

---
v6: https://lore.kernel.org/all/20260709112520.24857-1-lizhe.67@bytedance.com/
v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v6->v7:
- Rename memcpy_nt() to memcpy_nontemporal() so the generic helper name
  is explicit rather than abbreviated. Suggested by Muchun Song.
- Drop the separate memcpy_nt_drain() helper and remove the drain calls
  from the ZONE_DEVICE template-copy path. Suggested by Muchun Song.
- Rework patch 6 so the generic memcpy_nontemporal() fallback uses
  '#define memcpy_nontemporal memcpy', preserving the usual memcpy()
  FORTIFY coverage when object sizes remain visible at the original call
  site.
- Summarize the off-list Sashiko review comments relayed by Andrew on
  the memcpy helper and x86 memcpy_flushcache() pieces.
- Add patch 9 to remove the local template-enable predicate and the
  remaining non-template fallback path, as suggested by Muchun. This
  also means KASAN/KMSAN builds no longer force the per-page
  initialization path, and page_ref_set no longer observes every
  initialization-time refcount assignment.
- Re-ran the VM performance test for v7. The results were close to the
  previously reported v5 numbers, so keep the existing performance data
  unchanged.
- Rename pagemap_resets_refcount() to pagemap_requires_refcount_reset()
  and invert the predicate accordingly. Suggested by Balbir Singh.

For changelogs of earlier revisions, please refer to the v6 cover letter.

-- 
2.20.1

