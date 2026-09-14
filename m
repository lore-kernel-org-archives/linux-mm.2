Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7B4C88E65
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679936B0098; Mon, 14 Sep 2026 06:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B246B0099; Mon, 14 Sep 2026 06:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DB76B009B; Mon, 14 Sep 2026 06:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2997F6B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:45:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91658140286
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:15 +0000 (UTC)
X-FDA: 85212035790.11.8F08CE2
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id D124F180005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fjl8E77D;
	spf=pass (imf16.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3m3SP6e9NrbIRaMkWtj1uZEt6uHgAf5jXfUplg45r+k=;
	b=QyuIu4+qQZqLlQrAQlBTo6JUjMXd5rUJ6awqevl0NY5wniKrV9gbQP/SN+Ju6l/MSqgrho
	EkQH6iW3YYIklV9M2Iiy2Nj3UQTs06LnWSqwBG56qDPPeYRIrTRByFLnuWd5KfmyxmE/nQ
	XDcLZD49lA05vc7D0Rc9Fgs3TWTYu1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382713;
	b=KhVcwiILHC0LA+8fgdBFnhH2D6LFxu3Kkf8fr1hdqDiDo8hDZ9t66FWMp8Y4BsM2OXv/J9
	s759cNGFbdDO8aSrYgaig3lj1Y7apH/m+mvBAYghn2XgTOqZUhxEI20VaNQFGLPNaMioPG
	PeBUSlIgKeEqbhVbKcItN4MihQ/qwyw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fjl8E77D;
	spf=pass (imf16.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e25400so1350642b3a.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789382712; x=1789987512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3m3SP6e9NrbIRaMkWtj1uZEt6uHgAf5jXfUplg45r+k=;
        b=Fjl8E77DvG8wZiomMdaQhorYZZ0In4Ch7RO0qHridgTZ917FZHVOduqyO0BdXQGtS3
         WBJ3E/2Hfbj79mnBEKh+5uDuCJJpPz+73jBhK47n6eL2c+rF5CvhiLXEuYXbULYCXM5I
         LjRXKJKtfxonseSD9Gx3t9z9lhqvFXG1lX+PJrLQNcgkM0B/UWiPYRNNFmJ+FsknUZqO
         wqlh+bndS0gY9qQp7+5USHYTO7p8nhT2/3QWUjPAXszXRV63LEHs/5JqTuHe7m42zA2Z
         H43HO4FrELu1YZgYE4pAI7KvyBHisCkSreUGCrjV5mvq1DOqffSbTnv5ibu6FZ8reO3J
         jH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789382712; x=1789987512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3m3SP6e9NrbIRaMkWtj1uZEt6uHgAf5jXfUplg45r+k=;
        b=eW+kUDBqcMtYGVSr/KuWDP1mxRSVV5WhRQZQB5Y7KHui2sCUPXlnOqvCbDWnnpW5Hr
         byI1ht+YG0dQt3MserLV9DSitnEVumH69UOPa+AzV3kboFCg+blOm3FlMUDkNFmmplZl
         Hd+uEjDt54OnlHsnnT9K8W9pUUooHdn2nljUHikZZKWXka03TSnfneSG1dTKJd36HjBq
         lVcjJ/E3pqIgOD6B4Wgb86nG1a8JkL5sS9DbPgZikK/WSOeAQpf2o5ZjLSEtiiBntyHq
         pAd6xz/8ZWSaFo8dPhp8nmjZmxXT1y95/BFWMXJqqgYzaJxwR/7OOy4naVmKUyCXzY/d
         KTUg==
X-Forwarded-Encrypted: i=1; AKwUvBwtXEBTDzXOS0flSs5LY9LRtEdBsyQOOSa0iLDabLT9I+RoS0CwGYeHmou2TYsy3nBm+QMZhC076g==@kvack.org
X-Gm-Message-State: AFuF++mvIUNEvuB2WeK3ZNuH+Tehed2jL4nm1CRRR9FxYATIPTQLH/QQ
	wSW+YbmR5OO+pGw6VI0EWvzNudgidGcoI4tVnnLWsIB+XLPfFlKIbY06
X-Gm-Gg: AYBFou3ZWGwykCAopVCYot//iMOCeGaNQboGaBdsfF4xFnjonjA9tftQt0EndkN+cTh
	2dtM8gGFJAvXTrI6O//smsdV4G/+6EVQH/Y4d9QV4iRq0bzJceWqPXTFoZkYzd3udumt+acngCf
	tuL0hBelGoFOAJhZAUv/fh7AX7RfzDcrFFTZHS9+6LkrdRUz5iCaObxJ2pFTbJawk1P+wfhYYcd
	3QynuZqLR8AIcKzaPFZnhvzOdHfvNDN8Had2r3qX3Q8fqfu78+uPHC4FD7vaDozFTE31bsOaZW1
	DH8akBkiIUI5D+wO9gAjI5kxFVAg/PWqKW3SRBPE6Lku4kIxRffRPptR7dn7+zWiD0JJYNaNufm
	1FoWbVDoGzAiR/HGsTMmhNM7c1h9e75325Gl7PeC9Tv5iB71XO075Iio/VDZlqqr/HincLZ6NvB
	lkaBtFuui70O5UuaHRAkqonds48QN2+INhiIYICA2OagoO/M5ZPg44wDrfSme93Kz7pLtHAKDK4
	0H6VYGgRh/XnPtO+/2jd5RfZOGBINXnasmvstj/45XwVcIcC57rUlrI2Ja5CTp7xx6yP1ukeZRC
	PqvCZQnirWAgC0I1CuoVwpTB25S1ZMq1ALFhTFWaF5ux8ImiruP5jIyFfxUm0jo=
X-Received: by 2002:a05:6a00:21c2:b0:857:7384:b5fd with SMTP id d2e1a72fcca58-86f8737ced2mr3809414b3a.25.1789382712304;
        Mon, 14 Sep 2026 03:45:12 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm4234386b3a.26.2026.09.14.03.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:45:11 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/3] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 14 Sep 2026 18:44:58 +0800
Message-ID: <20260914104501.3960616-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D124F180005
X-Stat-Signature: s7bdz36xe3uh1y4ockq5eafw8tui6k1d
X-Rspam-User: 
X-HE-Tag: 1789382713-947068
X-HE-Meta: U2FsdGVkX18JjXYfKlo2A6GxPJHkzTtl7YFm11NRK/FIROuBSRqNTcv3HOOjiEK9mzHCWBf1Yarjie+OpkxsPhHZsZN8m1yCBN6/6i6Mw++Fg6e6Bqa/TnYCdfRWRdDDv5YqXALVfFskCQtCAwHXfyin9jBQa/kC0BBh7DP2uGicZJLGRMIFJ3IRoAmaD61ny86XbW5H94qPkoNUMmySp45PE+zFwCj0ubK0APHbzI+MSZJzwDJT2HV4TaWzPuRs1LgMYYOmOSvJhrjljsRtZg+3hI2HfFF7xyXAVc+Lki2PZMQ8gDKTg115HOYjYOMFARvDF/Ti4CyRA9aSAjOyC4CW844x10jJ/VlzMMJOFDNX3oyOPK03XPWxzjsIPjXc1F8YnKALQg2+fTgCXTZ16Jo3JMcnTYksVd3GPlu96NWgNgbM1BZyYjhdBbIhN4y3KrwAT6hMSruPODxdmvUAwV1SvwVWVZEeuWTubL63OnNQbuwZmLQPwnn5TT1YnydD9jWZ3MLPPFKAY5xUiVDsbfqfRQ6pM9jkeR9nPI+abq88tc/thmJWoqXBxNpDnjm5kF6Pzu1Cd6UW+I49S59NF6jxBtEaHpSNo0yIJ8AxSkbF98n62vjs00yWYFxdz05IJGl8iNBlkILtuvnyRK+6uO3vzx3PShwTF9ttExu7tnd+FDoKTj1Fpjb1t03J9zoPQVY3xkHVDNDqdsqGE8VjFHNbltpgMzLrT1lvz2A0Ygn8l9IGjTskMzpGKfOiWeJ6FW9O/ORhX5jhPRTIMrtEYO+yNomJDzSzqh2yZE2dxHFt8Nip3Te7EvN4qUEFYfv+N9RUq+UaHWPW0ILxGpxWKSExGwRjr3hmro1zz7+4KHfONvKYI+ylzBabhlZiBdsLq5RDr76qK8PmL3iq6eUEqapo5j55M2GxTg9Nc7HCeObHGISW/xl1Ic6wcZTrRoxldtWPqvsaOsM3iqZDThz
 NZBkbHdT
 2pzcPMJW67Xy6LZzIy1ixWsdniSfZ9V7ydRCvXjuGaMYMd7BvcB0c3gB+pM4ZOqHtZckR3q3upQFsCceaY9V7l5U5i9lGbnSqdtoS1ILG72zFa2f8IedRAXJcNSc4Fl56rbgiVfUdbCGfVy7aUFb7BwGXSAcFkePuCiwDXNl7BPTEiuu/VXYD7qHZnA536aVtxAuVJ3k2TG6/MBLdzGAeJAE3OmC05o+ni8q3DSD41kPr9/UAJNoRCVNNxszjJr4GXrdYSxI9OsahKSNh+eECOcmIIaAKAhbm0fFCXjz5qHBphsmMcKe3AZ30xHynxV49ANOhQXtWd+C/znPMLVwQUkv6hAW1gQg1HofyGd2itLETFD2RnRcp6qGMFT1OnDBCp3X9dv9lyNbs5LhICwSU4loGsDwYGguL3uTrY3HhN10wSjxkhfuNQmeoi2mFUpgzy2w+epcaCspZ0K9cHI8ze2xbTcpH7UcqZ5QgYyIYMWo4Z/yQfksdc6VzWvgkxuJ/PMFf1hQJXqE9BhJXxc0nXVYOJaQFODuRrZf4Jk0T4XpOI4K7N5gPODxvn2ArdAT5M0lYkJpJNnsFdNo2modqb9MSmwymNyOCTXd6QHcIBL+5CzigRqCEGmqcF4wJkOSlyAHeQdzO58BYBg1hU7l/wE+gO/TcDEML1qLBCFnOlR6Dxr1jfiZvWxyL/UNgQ4Uz42hO1vYpf9eFyV2IPMZ3G4IhNM47ifBcj9/ap8uAcHhgUclv+SzsPiKdg+blI2nF2pzMBdq9zApMDT1KJAj0qwWVMXyJ3K1kUj0I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some swap backends are useful for deliberate cold-page offload but are poor
dependencies for ordinary reclaim under acute memory pressure. Swap on ZFS
zvols is an existing example, with documented deadlocks under memory
pressure [3]. Compressed swap is another attractive target: accepting a
write may require memory for compression or storage even when logical swap
slots remain free.

This series adds an offload-only swap-area policy for such deployments,
alongside a conventional swap reserve for pressure reclaim.

Proactive offloading is already established by TMO/Senpai [4], which uses
pressure feedback to offload cold pages to compressed memory or SSDs.
DAMON_RECLAIM [5] also uses free-memory watermarks to suspend proactive
reclaim under severe pressure. These control when reclaim runs; this RFC
restricts which swap areas ordinary reclaim may write, including through
retained swap entries. The existing memory.zswap.writeback control [6]
restricts backing-swap writes per cgroup, rather than reserving individual
swap areas for explicitly admitted offload.

The minimum contract is that ordinary reclaim must not initiate a new,
non-zero backend write to an offload-only area. Reads, swapoff, zero-page
metadata, architecture preparation, and I/O that was already admitted remain
valid. If no eligible swap remains, existing reclaim and OOM behaviour applies.
This RFC does not promise a performance result or define a new workload policy.

Cgroup v2 memory.reclaim and per-node reclaim establish admission. Manual
MGLRU eviction currently does too, but its debugfs interface is not stable
ABI. Ordinary direct reclaim, kswapd, MADV_PAGEOUT and DAMON reclaim do not
gain access. This is an explicit operator policy; the kernel does not measure
physical headroom or automatically classify backends.

The three patches are based on mm-new as refreshed on 11 September, at
995829088503:

1. The complete swap-area policy, including eligible-capacity accounting and
   recovery of eligible cache entries.
2. zram03/zram04 coverage for reclaim routing, zswap bypass, discard policy
   and file workingset activation.
3. zram05 coverage for retained swap entries, including ordinary-write
   refusal, proactive recovery, data integrity and checked teardown.

The implementation is intended to make these questions reviewable:

1. Should pressure eligibility be a durable property activated with the
   physical swap area, or should it be selected late during backend migration?
2. Do provenance, allocation filtering, eligible capacity, and retained-entry
   refusal provide a useful minimum contract for userspace and controllers?
3. Is redirtying or activating a retained dirty folio, with possible churn or
   OOM, acceptable, or is backend migration a prerequisite?
4. How should persistent activation fail closed and remain auditable when
   /proc/swaps and swapon --show do not expose the policy?
5. Should an ineligible fast-path cluster be invalidated immediately, and
   should an offload-only area recover its own cache entries based on eligible
   fullness rather than global swap fullness?
6. Should the workingset activation heuristic continue to count offload-only
   capacity when pressure reclaim cannot allocate from it?

Build checks passed on x86 with i915 built-in or modular, and with swap or
memory cgroups disabled. The affected arm64 MTE objects also compiled.

The routing and workingset tests passed in x86 QEMU guests. In the
retained-entry test, ordinary reclaim wrote nothing to offload-only swap;
proactive reclaim then wrote the dirty folio, and all data verified
correctly. With the write guard removed, the same test failed because
ordinary reclaim wrote to the offload-only area.

Persistent fstab encoding remains unsettled. When hibernation is about to
save an image, an active offload-only area named by resume= is rejected as
the image target with -ENODEV. Virtual Swap Space v4 [1] separates swap
entries from their physical backing, while swap tiers v10 [2] proposes
per-cgroup backend selection. These raise the question of whether offload
eligibility belongs to physical swap areas or a later placement decision;
this RFC does not assume those interfaces are settled.

An explicit-only util-linux companion implementing swapon --offload-only
is prepared for separate submission.

Feedback on the eligibility contract, its placement in the swap stack,
and the unresolved ABI and reclaim-policy questions would be welcome.

[1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
[2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.com/
[3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#using-a-zvol-for-a-swap-device-on-linux
[4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
[5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.html
[6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html

Matthias Goergens (3):
  mm: restrict offload-only swap to proactive reclaim
  selftests: zram: cover offload-only swap policy
  selftests: zram: cover retained offload-only entries

 Documentation/mm/swap.rst                     |  87 ++++
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
 drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
 drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
 include/linux/swap.h                          |  29 +-
 include/linux/vm_event_item.h                 |   1 +
 mm/memcontrol.c                               |  20 +-
 mm/page_io.c                                  |  24 +-
 mm/swapfile.c                                 | 126 +++++-
 mm/vmscan.c                                   |  31 +-
 mm/vmstat.c                                   |   1 +
 tools/testing/selftests/zram/.gitignore       |   2 +
 tools/testing/selftests/zram/Makefile         |   4 +-
 tools/testing/selftests/zram/config           |  10 +-
 tools/testing/selftests/zram/swap_offload.c   | 402 ++++++++++++++++++
 .../selftests/zram/workingset_offload.c       | 206 +++++++++
 tools/testing/selftests/zram/zram03.sh        | 166 ++++++++
 tools/testing/selftests/zram/zram04.sh        | 149 +++++++
 tools/testing/selftests/zram/zram05.sh        | 360 ++++++++++++++++
 tools/testing/selftests/zram/zram_lib.sh      |  28 ++
 23 files changed, 1620 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/zram/swap_offload.c
 create mode 100644 tools/testing/selftests/zram/workingset_offload.c
 create mode 100755 tools/testing/selftests/zram/zram03.sh
 create mode 100755 tools/testing/selftests/zram/zram04.sh
 create mode 100755 tools/testing/selftests/zram/zram05.sh


base-commit: 9958290885035431e2494159f555e332c3c14906
-- 
2.55.0


