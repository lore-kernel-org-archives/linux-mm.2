Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B110606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJvV2uWi
Received: by kanga.kvack.org (Postfix)
	id 5FBA16B00EF; Mon, 16 Nov 2026 01:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3A06B05B0; Mon, 16 Nov 2026 01:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511646B05B2; Mon, 16 Nov 2026 01:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22D3B6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8D541C4128
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:20 +0000 (UTC)
X-FDA: 85440050640.07.01FEC44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2369220008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJvV2uWi;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z1Rsc7DC+QVh5qdz58bbVw91gg+izy0lpOLfi/21S74=;
	b=03x+lMlsYeWwt5nRU3fyqFdf5CV8UTqiSxyJMQCUjCDbOfmlgi3rAM6bPxX8T3lCarGBgt
	LGq5Y9e0Sq2z9NetnzMofYKcvKQs4mFGOdlLKZDiXZ2Kx4pvf7U18n1nIWntOUsJIh0c//
	UykkiAWVWZCniF49l10hxwhtC01RDjw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811639;
	b=a16IPTkvI/rmpOfOGIckRSEay+qWaHGTufrzTWjSfs+x+ZRYw4CIbf4as5gGr773WprjXv
	zyVzXaMhqTDkgxKhSN+Ba2n3zBKknBXqKNv63gxzeDrj36fz9ZTc3YE45nCMv/j2kaSnyz
	uiTXYNI2K0xFhfvV46CzLBzA2/ukwBw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJvV2uWi;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B9F661ECC;
	Mon, 16 Nov 2026 06:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197601F000C4;
	Mon, 16 Nov 2026 06:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811638;
	bh=Z1Rsc7DC+QVh5qdz58bbVw91gg+izy0lpOLfi/21S74=;
	h=From:Subject:Date:To:Cc;
	b=JJvV2uWiZqdWbH4MMiSRVO5D7yVWQMFmglhOIgBUqVU7+Ifnvfbc917cQi5vUPhxZ
	 nOi80n4MJIvFR/WG3/DMDvlGvpNVzagi1xaAs842ZJDg8hJ9ijtMz24d7B+OgYPsyS
	 lFqhctbXkIV5NBpuLdyTPYypfh0y3f9tNJL7eGi7XbihdtTSjdAI7DtU2xi1z/EuSB
	 ZZSja+7hQF9L20q9d4XC7UFiGyj7hAiLuFquwmZsr8xglbRuag5So1UOJ0b+cZz7Ch
	 Id3nasevFmOO1zmcrypPMyCK0usMTgpXKCoaPoiWaEp6YPGePjP2JyETHgwrNFwZt0
	 pRqhh37iuu5RQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v4 00/10] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Date: Mon, 16 Nov 2026 07:47:08 +0100
Message-Id: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOym+moC/23NTQrCMBCG4atI1kYy+dO68h4iJWkmGpVWklot0
 rubqiiiyxe+eeZGEsaAiSwnNxKxCyk0dQ45nZBqZ+ot0uByE864ZgUATcezLdtQ92XESxMPdOG
 5FtI5mJs5yWeniD5cH+R68+x0tnus2tEZF7uQ2ib2j58djLsXz8Uv3wFl1DDU2imh0arVAWONx
 1kTt2T0O/4WgHH5R+BZsB4kFMYq792PID4CMPVHEFlgciErVAUaa7+EYRjuX7yFEkcBAAA=
X-Change-ID: 20260911-slub_tiny_rework-8f2634dd17a7
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xhmdiqmqq9nbhi4ocgqfekkyybuwubky
X-Rspamd-Queue-Id: 2369220008
X-Rspam-User: 
X-HE-Tag: 1794811639-292363
X-HE-Meta: U2FsdGVkX1/uIfOxAYGSNruKsFkvLB7gXUGAfwwTgiEThbfvDkg9Hl4FiEeJboSc/AQdG3Sea/NB00WS+EgM5CVyPxz0XzDWNqXU79fxiaBEl3qNiG7D5A7gzByupdL0WUt5D6XHaQ8fIGfulGp8LHojWWFIaCfsrOb2tYi7DiJx9J9mSCxz0J5LD8/MwyWG5kp51KiUWJk1I5/WK1Lypxm/gzdijGRESD/J/E4Wavs6UML2c6sxAU3Bz7W4l45d/fGxPKk9yVjBnG7khIHCpbENRzpk76YwfY8zH4wvsVG+DmPjbvby/bGqtNhC2c1MlvYNGZr3AOwJBVF69nsDKzA7zy+vzMY7WYvq4Xi5UNfTCQf/4OhocddjCzj76FWNUEqBiU+DnFbql9ARJkxZuDYboGbY5lhWrt3delgH5fGpjGxbetcV314H7Ps5Q7hJptNB8FJOo4Pu5TForeD/IvyxqRWWjp+MP/jJUVa/spDph8ZS85KeY6+X2u7QfN32nUwjpptMw7GOmVbUUDlhp5nFNt3NaDwjHFMK/hJVdYDDIj+0h3kMW/dLmGxw4/KqTKeeKf7XFduq2yAHHn0x+z9KuCkhoMGSGEZ0B5jDLV5r4nAt057r363x0tLwGm/HQrlLCktar1gyNoHcw64jtbhAX7SHBC+V2sjsZdwEFpflJfsd6MNnYUcivPkRtjExk5TFgzLeRkaWdIgb3JjjOhyggq0zpqyvN0vbNR6mskHTRBvWBdXk/DPPEZk/SbMxN+7REZUVDAafesmCtPGLhHdvVt3UC3fVWFWYYIwh3mfLXssbpTDV9jcny5URRwMRdrTVLuIZHQp5FvKAUcL2aYkvYBeWlXv75nI5n2ZyC1jV4JB1UXqy+Siu0tlt/Y5SNorMbRjfFARmpKmdgqqVrk9A7Gg/4ozTvZfnlSJrwqusLNAZCrM86J1f9Mlr/UoAA9qZIGurutDU+D+KdJD
 F6jMhjJb
 LR5xn7KE395flXhU5EwJl4NcO3L+A8S9xXjy46ekZ1WiG+1tju9nt57mBNfq1xyamdkwWkqPBMG1mUyGZ0T42Lu5lVdJkni5Da7VauwKZhxZ7EREXhQEwtHTKzVJ1fnOEkRW9j6Xpbs0jgzLqGoo8SdvmV0C1gqnkQTfkx2iX3hvOSXWfdbWMrVALcFaDL15IB9Jds2/d3ew20VIwodxceGVMsxf/OLYyD9FdWH9+VDW0Zz9WgdNCu/X1vLvaagPZYmbe+XNQtYsC9xqHLjQf/xDuQU/lgt/ORXOSJzZPR8+OJgZ2GvUy13srFz2ul8soXnWLAwq/MhmiMIrjwD+cXff++mgUm4sIYanfJuY0aGFBVPjS+fzvzu5dVklYDvXTHBl6756/ZGKY2mcr2d+Lvb1qlVt2Wd07gtWcNKrx5DpteflkcQCc4heBgdvG10mCwj2pQECCdSowr2MXP05fiKHR6bVopfsMojn4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_SLUB_TINY was introduced to help tiny systems migrate away from
the SLOB implementation so it could be removed. Its main purpose has
been to disable all forms of percpu object caching (cpu slabs back then,
now sheaves), and being a compile-time config option, some extra minor
saving were achieved by code elimination or more agressive merging of
caches with reclaimable and non-reclaimable objects (keeping those
separate helps reduce high-order page fragmentation but not memory
footprint).

However being a config option brings issues such as incompatibility with
other options that has caused troubles in the past and Linus argued for
removing it [1]. Moreover, there is a use case for having full-blown
scalable implementation enabled and being able to disable it with a
boot-time rather than compile-time decision. That use case is the kdump
kernel which shares the same vmlinux but wants to minimize the memory
overhead (which has to be pre-reserved from the production kernel) and
does not mind reduced scalability.

Thus this series reworks the CONFIG_SLUB_TINY to be controlled by a
variable set by a boot-time parameter. The config option itself is
deprecated and only sets the default value of the variable, and all its
interactions with other config options are removed.

The conversion builds mainly on the fact that most SLUB_TINY specific
paths to avoiding percpu object caching are shared with slab_debug
handling, except doing any actual debugging checks.

Thus introduce slab_debug=N (for No-op) option to allow using the
slab_debug checks directly, and extract the underlying static key
handling from CONFIG_SLUB_DEBUG only scope. The decision to create
separate kmalloc-rcl caches is also made to be boot-time.

The parts of CONFIG_SLUB_TINY that can't be transformed to a boot-time
decision are related to dead code elimination and fast path inlining,
and ignoring SLAB_NO_MERGE for performance purposes (currently used in
networking). Those lost memory saving should be all relatively minor
compared to the savings from avoiding percpu caching.

To sum up, after this series:

- CONFIG_SLUB_TINY is a deprecated option that has no interaction with
  other options and only controls the default behavior.

- New slab_tiny boot parameter controls the functionality (and can
  override CONFIG_SLUB_TINY in both directions).

- slab_debug=N can effectively achieve most of slab_tiny and on a
  per-cache basis

- the implementation is simpler with many ifdefs removed

To verify, slab usage was measured from /proc/meminfo after a virtme-ng
boot with 16 cpus and CONFIG_SLUB_TINY enabled.

- before the series: 27700 kB

- after the series: 29804 kB

The difference turns out to be due to last patch making CONFIG_SLUB_TINY
stop blocking several options, but real tiny systems can still disable
those.

- SYSFS support can be disabled globally. When manually disabling it for
  slab only:  28992 kB

- Disabling CONFIG_SLUB_DEBUG on top: 28696 kB

- Disabling KVFREE_RCU_BATCHED on top:  27624 kB

Thus it's possible to achieve the same slab memory footprint with
slab_tiny. One caveat is that disabling KVFREE_RCU_BATCHED is now only
possible by selecting tiny rcu which means CONFIG_SMP=n. I attempted to
make rcu batching boot-time as well, but turns out it's not possible
anymore to switch to call_rcu() with kvfree_rcu_cb because struct
kvfree_rcu_head is now reduced compared to the full rcu_head.

In case some small (but SMP) systems notice this as a regression, we can
make KVFREE_RCU_BATCHED configurable, or come up with some other
solution.

[1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v4:
- Collect review tags, thanks!
- Fix missing migrate_enable() in the kasan test (Harry, sashiko)
- Handle create_unique_id() properly (sashiko)
- Drop SLAB_RECLAIM_ACCOUNT on cache creation with slab_tiny_enabled,
  achieving full parity with handling pre-series.
- Add memory footprint measurements to the cover letter (Harry)
- Link to v3: https://patch.msgid.link/20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org

Changes in v3:
- Rebase to v7.4-rc1
- Add SLAB_DEBUG_NOOP to SLAB_MERGE_SAME (sashiko)
- Prevent premature slab free in slab and kasan kunit tests by new
  patches 1 and 2 (sashiko)
- Link to v2: https://patch.msgid.link/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org

Changes in v2:
- Rebase to current mainline (with slab/for-7.4 merged)
- Stop triggering nohash pointers due to slab_debug=N (Harry)
- Stop preventing slab merging dues to SLAB_DEBUG_NOOP (Harry)
- Link to v1: https://patch.msgid.link/20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org

---
Vlastimil Babka (SUSE) (10):
      slab, kunit: pin test slabs by an extra allocation
      kasan, kunit: pin test slabs by an extra allocation
      mm, slab: refactor slab_min/max_order handling
      mm, slab: introduce slab_debug=N
      mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
      mm, slab: make SLUB_TINY handling dynamic for sizing decisions
      mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
      mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
      mm, slab: add slab_tiny boot param
      mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects

 Documentation/admin-guide/kernel-parameters.txt |   4 +
 Documentation/admin-guide/mm/slab.rst           |  18 ++-
 include/linux/slab.h                            |  17 +--
 lib/Kconfig.kasan                               |   2 +-
 lib/tests/slub_kunit.c                          |  36 ++++-
 mm/Kconfig                                      |  16 +--
 mm/Kconfig.debug                                |   2 +-
 mm/kasan/kasan_test_c.c                         |  25 +++-
 mm/slab.h                                       |  32 ++---
 mm/slab_common.c                                |  28 ++--
 mm/slub.c                                       | 176 ++++++++++++------------
 11 files changed, 207 insertions(+), 149 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260911-slub_tiny_rework-8f2634dd17a7


