Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66B3C9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 04:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617A06B0088; Sat, 26 Sep 2026 00:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8CA6B008A; Sat, 26 Sep 2026 00:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490F86B008C; Sat, 26 Sep 2026 00:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 123266B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:55:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D0CC140433
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:32 +0000 (UTC)
X-FDA: 85254700104.11.DAAAB94
Received: from mail-dl2-f16.google.com (mail-dl2-f16.google.com [74.125.229.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1C3F120008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ph8IRUoh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.144 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790398530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lez8Lh9LK2IJV3Lg+4+qOHMKMvDRPEZgp+OMdBxRRpI=;
	b=Sn8ElltbV1MY29EjvPIVu9r4ODNJ70XEldIc8WOuwhdTH+6yk4emS947xq242S83c1yeY+
	cDfWFpuwch3IHpVj5h0PzAFifEu6X6NK190e3zDza+R2L1GRaYk8o2ld5Vw1NzekyDwlSN
	ubIyOKjwlawuvCD7gzfmulHFln9uczo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ph8IRUoh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.144 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790398530;
	b=jlgRd2wJxFVMepq0toXuMVrUJwStEz1PRAaUZKu51CgYxzReqDvQT1Hu6I+Elx2ivuddxD
	23Ifa0RqbDQxeMrOic8c3Zw6BJBm/ovh1srNIlUysQLhdmMKAeVgQeukk2tJ/ALkXJs9Bv
	dbRIYMaKCylgJm6rZKRtNUX+T3TcfiM=
Received: by mail-dl2-f16.google.com with SMTP id a92af1059eb24-1473f265b82so78084c88.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790398529; x=1791003329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lez8Lh9LK2IJV3Lg+4+qOHMKMvDRPEZgp+OMdBxRRpI=;
        b=ph8IRUohH0PASadFBY6UtO497pbkxl55Vl/foXIcbh7lMKkSKbgtXdmyiL7/l6+Eg2
         +ITSPjSRehzwPgvJmbK8EsYyG7izrXJjLIlhzrGeMWY7Y+PALm2zbD1+Bguwb5HsRkbI
         /eMkAVLTX6ZmATyVFZ81PDhRalQCO0FX4L8fKul9TwklUELDLF1Db9kujLcePJ6V6L32
         U4qqaKIjEP93dq0EoynoSzNuXiXn4UWKifs1ogtF9BvTAUx7m4qdOkbpbvAbX2dyWGvx
         dj5C6BJKN4tZmwDELyNA7b10yTZ5LJ+0t8ddp/tfkm/YltDk+HqHKT3kwy07P1q9DSs5
         VELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790398529; x=1791003329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lez8Lh9LK2IJV3Lg+4+qOHMKMvDRPEZgp+OMdBxRRpI=;
        b=y7uF/YfhuLYv+LZVGUeHBzTqJm0bMjtLXocKj79XYgsr5X+lrlxYoSE0D7Q6K08MQT
         DlU8rNJ1UQHmv/BMH1r7vLnp5tMzBMBZzcHroBZtMByKV/8fZ/muiV93+RT2pWQGPzUh
         I/jOzi6v99AFNEHlGwqKBsfjSezz+kZ388MG6Ru8mvY0httDboXnAE9oHsrhsKB//Xfs
         s/Q44mRW/drFEmHZ6ooM+/exMkbObA+Vffvg/RSSMgVJ7dWsecqUBJPh/1nJjmrLdQir
         kI1m4EezEqEpBWxcu8U/VYSQtcnxVElHgKXKDFMlMh41ylxzvI/xCAZSwVuJPV90FdyF
         2E8g==
X-Forwarded-Encrypted: i=1; AKwUvByZ/LHPIhGgxU+L9A9VDl66xSobV2m684PuLBte3uXeGqAdzACMkQxGBTzF2ksT2Bxa1I0xeFYKMQ==@kvack.org
X-Gm-Message-State: AFuF++ldH8HxA8yQFVnhJ9mQWZRzyaWGrGllouO2xkUt36uWUYMC/nv9
	w2RbAHFSp1smNJ2WNAWne6uJ1xSrmAsn3BgEfmYjcIJL8fI0qqW3gUTM
X-Gm-Gg: AYBFou08FY1/j5IjMRBcYxeg/aUaZ6IcB8Z0KnzCSwX9SBdGrto8PxP+9UJ9+GS6Wdi
	rlll9m5tKYJ8UOamf+Pj+edA6nNDCzR5XBqtACqnrDLK2Do09JLDqKzZ6NVQYkMtRMPnS+RghZu
	8n1HYOd4q9iSsjd1d1v6rgF7v3dwlQNXRKXfg5A2vWhFaj95mDtKUGh79+CEqGUdTvOSUTcJhFR
	KwpWgMsHYMLPPIz5ZVkvxDc58gM/C4TSE92AKbigWM8+cpJE0Zp3FpjpPSyxKgBoo6vDIp0ZZal
	HGqXV6EPkR1JHhGRz8GmZ3hrlkL1/cocE0kwXFem9WUPSDCU0EuJAvuZKvdRkBMU/Lcbv1UP3Iw
	XMIc7R2uL9EiVWIL6cRmNty3rukUS0jdaEBcN+dtEOEmw6KWybnl3n3p93tFS5uk0xQslOSj7OE
	nAq25+8LBaFBLkHsfyDg7Jrk8CdamKa5pS5BW7m4hHstD/sNyqgvoEPYVZ+5iqUox9TG0Gx7th/
	FUhSNL4BXsQyIi+KQvHhSxE8Sc0n7KcZDHTUkw7S+t2Pr67BDXtRQZqlYvcj6kASR3WiJPjWSO0
	Z/SrBZlJ1lv9dTjE6eMJffTDyygUJuhsYfRRNb6Iuan83uKdw2lvkjsf/4s=
X-Received: by 2002:a05:701b:4354:b0:143:8865:cca with SMTP id a92af1059eb24-146cfdcf390mr1703579c88.22.1790398527862;
        Fri, 25 Sep 2026 21:55:27 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145adcc5b00sm9334211c88.15.2026.09.25.21.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 21:55:27 -0700 (PDT)
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
Subject: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Sat, 26 Sep 2026 12:55:13 +0800
Message-ID: <20260926045517.3458413-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1C3F120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qtfp13gw8i7di4uy5gfdfetdpkhqnx66
X-HE-Tag: 1790398530-645295
X-HE-Meta: U2FsdGVkX19szmA+gqLqjKknt4CIG15XLPfcoNfu8unPt9a9+2as1G6YnJVk3HNN+F3H0UdOzmfPfy57ZMVIj22/uVxLfKQ/b8GkgaU+f02gt5vpuBasVkNZQW3fuPi5jiU1EVYHyhGOaRxIJlIfAfwgpdORK8dw9hWSMy291N1OTvdS3mYeOubBwNoGW58TyqiWXTcxHNnLny51PUfOzqhUblJK6libfKq9MbJSEaBpasxzIPWUL9huGP7J5y0qGmVnW78OdVMymEr0d8K05ZB8HGSgSBAd85grKeEIT5D++RbYfnLiMu6TJD7QeYo1XJh2zihSOVi2QpI+Z5C70N8NuQ/H8ddToTXnQ5W7F9UWN7juGSY2X84Fe+cN3gu0ykr3Q9RWO7fiwv0q/ZiIUBSvJmO+qSXRIlZb7zsq5bg4N6tHzmiOt8fiQSzk6Y5maX47ouUDIOYiLsgW+oH8SdYi0QLYsPZe50y2LywIvkspxKLuPrbnUVXG4+pb47Wa31Z7C/VFV/YnPBQSzSDlVPm1qWRRXZRCYRTlWq7NJGtG/MwqY1tSfrekxxZ+x6oswGEd2t6MgeL0hV7SM5gBSKBraZ8e7fLVVB7dPNzaLIESqbLzP3tjAQDgwBKFJwN1oialRBa97IU3ECfSqCMUe1okeYFWP9X7XHJmfloYHfSCi8ojxtZx810UaMbEU1+o6LgQDp3Dl5RSxuRLrU7n8tdhkEIuVnREbz+hnZeVDb1u+KmPY9n3I8fH6nrLD0veqtSe8lu3qpF+SKfbgg/fglpItMHjFtZMkUw2f6ArF2SyT5Qd+8YTqaOk684waWnU46tXAlLOrpumniI9XVaDnMhrBzKv6SFLM22r9bg8Kqj0w0u+Fqizc/mWyhNK8oN2aRl/G09ggFrn54+06x4RA2TaM9EvMc43DBSsCDRI49H9mJylneC0LcD7bcZX4bLnAA1eIjoND4DIE41uWFw
 mqEZF+vs
 IQPS5L8JdIQ05blarPriUDkcd3G33fdSDQ7wYAOm7bO33pNqEjpfgv7LZ0VR44zW0Rm2nalXZ+bLyUO8HhGffOadtVDYgDgu0k6NGHyVVzFfiofpQUTqur91r6pu1w+yvbIXRg/Idgd+JqvfuBBn4Z/zSy7jVe655ZyTurcxtyGRDd/wz/C3vO4NFD2Yqf1Po9NXGwonX6Cy+fYai3qgcd1yQlFvkwThlb7B364p8Hz3Er6T2yQcc29+oq9haoKlRPf3PhU+XEWy02OvdkWfxb9lyJRwbvuCpklXn8L6bvaYHafTUXE4+lA8nbzCLzjk+lDbkP1H/cqUVajZMWcvPn9eULVxfQ/O3mg6iAJsUTqvxY0vQA72J+hKSymrdzR5fhhnKMSzF7vLLjnJA2eKlr+IP18twBLYjgGBnJUqlEhDcHgVwgi5XfgEfCop6Ydnxj+1Kf36kb9b0KR+Lpf4jECRcR3mhOnT4Bstq+LKvxG3fEnwjltQAqU4jV0L9XHh8NFJEJ0Z+UZeY0Fk8Q6CEaA6UpOjJIXEi9OBtG6zewUZt+U561iBRavMoqx4bojn4FJ/ad+x2Kac9w68MISx3MDSPzR51bN46U3tSXitn38K/oicRq18OPI+EVQKw6Kpqf6w+smGXNXXV8zV12crJ7N6NisR/UmDhh5Z+PUXXmrCvXT3hMpAOBhgAdUeS0HAIxhBB6m6X+fv7ysO1ZEODRDO4rq9DjMJ6bBoySki/rtpxo49tduWwy9Yx5hwHcYtyUdVwgPdyo0m7t/J8gPDXVgUKRjTeqF/jINKoGhUGQCCq3RfGxROucNUdJMiWBE5NCyZyiV/CkSNm9KUKNApRHAAda1d1Fs2uKOZFMUCeVsvogUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC adds offload-only swap areas for deliberate cold-page offload to
backends unsuitable for pressure reclaim. ZFS zvol swap has documented
deadlocks under memory pressure [3]; compressed swap is another target
because writes may need memory despite free logical slots.

Explicit proactive reclaim can use these areas alongside conventional
swap, ordered by priority. Ordinary reclaim cannot initiate non-zero
writes to them, including through retained swap entries. Conventional
capacity is not reserved for emergencies. Operators choose the policy;
the kernel does not measure headroom or make an allocating backend safe.

TMO/Senpai [4] and DAMON_RECLAIM [5] are related cold-page reclaim
approaches. This RFC admits offload-only swap through memory.reclaim and
per-node reclaim, but not DAMON. Other related work includes per-cgroup
zswap writeback control [6], Virtual Swap Space v4 [1] and swap tiers v10
[2].

The util-linux companion [8] proposes swapon --offload-only and an fstab
option. Older swapon silently ignores the fstab token, so persistent
activation needs discussion. Apply the separate i915 fix [9] first to avoid
a pre-existing folio-lock leak when shmem writeback is skipped.

The series fixes zram selftest device tracking and error reporting, adds
the swap policy with DRM eligibility checks, and tests routing, workingset
activation and retained-entry write refusal. It is based on mm-new at
995829088503.

Feedback is particularly welcome on:

- Activation-time eligibility versus backend placement or migration:
  is retained-entry refusal, with possible reclaim churn or OOM,
  acceptable without migration?
- Eligible-capacity accounting, including overcommit limits and OOM
  scoring; cache recovery, cluster invalidation and workingset activation.
- Persistent activation and visibility: current swap listings do not
  expose the policy.

Validation includes x86 builds, affected arm64 MTE objects and builds
without swap or memory cgroups. QEMU tests covered routing, retained-entry
recovery, data integrity and cleanup, with negative controls for write
refusal and teardown failure.

I have also been using this policy on my own machine with experimental
bcachefs swap support, with no problems observed so far. Deliberate stress
testing is confined to VMs; I do not deliberately stress-test this machine.

Changes since v1, incorporating Sashiko's public review [7]:

- Improve selftest isolation, retained-swap measurement and memlock skips.
- Track allocated zram devices, wait for udev probes and report cleanup
  errors without deleting data through a mount that could not be released.
- Clarify activation, capacity reporting and conventional fallback limits.

[1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
[2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.com/
[3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#using-a-zvol-for-a-swap-device-on-linux
[4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
[5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.html
[6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html
[7] https://sashiko.dev/#/patchset/20260914104501.3960616-1-matthias.goergens@gmail.com
[8] https://github.com/util-linux/util-linux/pull/4633
[9] https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergens@gmail.com/

v1: https://lore.kernel.org/all/20260914104501.3960616-1-matthias.goergens@gmail.com/

Matthias Goergens (4):
  selftests: zram: track owned devices and report cleanup failures
  mm: restrict offload-only swap to proactive reclaim
  selftests: zram: cover offload-only swap policy
  selftests: zram: cover retained offload-only entries

 Documentation/mm/swap.rst                     | 105 ++++
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
 mm/swapfile.c                                 | 123 ++++-
 mm/vmscan.c                                   |  31 +-
 mm/vmstat.c                                   |   1 +
 tools/testing/selftests/zram/.gitignore       |   2 +
 tools/testing/selftests/zram/Makefile         |   4 +-
 tools/testing/selftests/zram/README           |  20 +-
 tools/testing/selftests/zram/config           |  10 +-
 tools/testing/selftests/zram/settings         |   1 +
 tools/testing/selftests/zram/swap_offload.c   | 425 +++++++++++++++++
 .../selftests/zram/workingset_offload.c       | 207 ++++++++
 tools/testing/selftests/zram/zram.sh          |   9 +
 tools/testing/selftests/zram/zram01.sh        |   9 +-
 tools/testing/selftests/zram/zram02.sh        |   9 +-
 tools/testing/selftests/zram/zram03.sh        | 174 +++++++
 tools/testing/selftests/zram/zram04.sh        | 164 +++++++
 tools/testing/selftests/zram/zram05.sh        | 447 ++++++++++++++++++
 tools/testing/selftests/zram/zram_lib.sh      | 189 ++++++--
 28 files changed, 1926 insertions(+), 94 deletions(-)
 create mode 100644 tools/testing/selftests/zram/settings
 create mode 100644 tools/testing/selftests/zram/swap_offload.c
 create mode 100644 tools/testing/selftests/zram/workingset_offload.c
 create mode 100755 tools/testing/selftests/zram/zram03.sh
 create mode 100755 tools/testing/selftests/zram/zram04.sh
 create mode 100755 tools/testing/selftests/zram/zram05.sh

-- 
2.55.0


