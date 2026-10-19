Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27000606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=XfYKDgn5
Received: by kanga.kvack.org (Postfix)
	id 365666B031F; Mon, 19 Oct 2026 13:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DCF6B0320; Mon, 19 Oct 2026 13:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2533E6B0321; Mon, 19 Oct 2026 13:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDB7E6B031F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 909A840707
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:36 +0000 (UTC)
X-FDA: 85340087952.01.05FAFC9
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7AC018000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=XfYKDgn5;
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792431574;
	b=f7p0QAHD+RtnxBwNd+0NWGYnDF40ub9uaQbYiPGaCdeD7zOZQMFZYbJtMgkMlDAN0FKIzA
	1XAu1NqOnSbwlnAUpvrVvizht7eNzTbvpl+MeRLJMPMBYqSOvYpSDDvgJluZu2z7Xr0Z4N
	lC2ELpao3FM0KgMyxBcn5iNA0R+dGJM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=XfYKDgn5;
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792431574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=51ZqUeACXcpZacBrZlRnXybKqIYTaPAWzvKxnKGcX/w=;
	b=fPfxMnjF+hCMhYuBevip0qrInPNBv1ebZS4o5tBFSPCwHHZ3kIId7+Xoy74mNcKVhQ02UH
	XTLqastc0MkwZ9Whfs2TNfZMdfdEw4L9qHDMya7/Gk5RvnCU9a+pxkFX0c7nApHntErDzZ
	KPOvxfusUmu0fkq3aJ0vX3qdPcdIUyg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=51ZqUeACXcpZacBrZlRnXybKqIYTaPAWzvKxnKGcX/w=; b=XfYKDgn5gEgfYoTmKNr
	xHUHTHOszRZBeMzbXeKouUsuzNC88buCs0M3ms7wN4ecL2yOBARp4zhbQwF7LZOTDDvR+BFU2Cn23
	/ElqI0A6Rsc2UCSSzj4wkVkq0yflNp7+hCCpru0v/U8I6JfhqYIwPgI+0RGpq9nqs4zNeqg7Fkm8O
	tLc37NsfpWHgRT3iVNgztf/lY77FgQiU0V9vU7rZcABbAPw+ouoj9o+CVcQeDkUdolBy8AujY9bSs
	ICRN4Ax76QpNqPUd047hSgUse15zm2+lHeCK5zGDFxlnf4qMaY4vf9pZmhIGjU33R/JaUhXU/GS5J
	bbL2LAolfDNbltw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH1-007Chf-0e;
	Mon, 19 Oct 2026 19:39:19 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Date: Mon, 19 Oct 2026 19:39:22 +0200
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpV1moC/02P22rDMBBEf8XouVsk+RaZUvofJZiVvErUYMmVb
 JMm5N8rJyX08cAwM+fKEkVHiXXFlUVaXXLBZxAvBTNH9AcCN2RmkstGcKFAVzBFmmBNc4ggqqo
 VLUwUYaTRHCAdo/OnjIt3c4LgYaAR/QBnjBF/wGo7yBZ3ZmgUyyO5y7rz/cDn/sFp0V9k5m31L
 xHpe8nP5keMaUwEJoyjm7tCViiUVnVJEsuBE9a5vFK1QI56Z0vZSm4Ub7eqkVLCu1JXvD2N/pn
 Uz/+98zb0mwScsllv0BwJ1hIEcKt5I4grbauP1cV5CZdLeM2H3tn+dvsFt9X/T1MBAAA=
X-Change-ID: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3859;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=qX2RYnuIBw7lvnDu9WuIMmC+EJTZiBoSc6ySim5RomA=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXODSiZHrBaM+21Dc0C7nWJidNdICEXrPMvi
 5XzzXEW5viJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzgAKCRBRlgpH+WFc
 Km/5D/4tacnGJojOgnomfU/sBBP418jNm0kvem0FQ50VsNBh71ibkf6X1CRRAeoj4kf8+6XpkbQ
 rpgLsngzSRti+HCJLe0RFWJgswjPMgULiOmoJgOOoUdzr4MQwBL1okWkXT7mtRycnatX4iZcGsf
 2sk5qzxqZw2qJ7nWr6xpYw42QsGmP5UpFMLemP7kXA5a3puOSbbt+M0C/TFTNPUs2LPyBsvkxaQ
 Hv9Ankk6EuSHUgTlcDkxLOMDrGHw/QWkUqr52oex1/fb4qhHwa/6p4PBuu2PMxedzGe6wCAP5WS
 X6xVkBjc07Wo0YxYSG6bcDiRQB3Yvapo1lrmmi+pguD/0ueasmCBkZIxmnUPIvDcHzVQhiuIq3F
 VoJ012jS5b2Zn/qa+llulh24Tgm20c2CKveUNhI7+glhS5So0i+TFwOx/4lwy6UNY+cO99Kyl/z
 k9Dg9cfvrqrsM3jhApeuu3bgp0oYdxyWAfOKdZJ6DGnHDji7D45rOKZzpRySNS0KahEmPVsBZBL
 uExX18fPekMzVF/fUeuGwIhdcOT+X6sWhCJlcMjNT4522ZKOzQP7TkY/Cohg4PheCjjwkV1ttuC
 zPFgpcgh5BcpYsLGaxMSTDV5zKp6JqlK9d/NNt5OdHq97aGskV2dB+7U6NWB6etYKHzCg3rL6Ev
 ZD0FxeckAFFiswQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Queue-Id: C7AC018000B
X-Stat-Signature: qx9q5i51kys9octa87imtzxp1fx3tsbh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792431574-782811
X-HE-Meta: U2FsdGVkX196CuYnDB7TqMxHhVNhPcKclqB3OoXAkcq0iJjyTsssrB/N9dAnSf9LMFDTpUz5zZud19FqtNMoF37ZF4fNeYQOZRIzTRWdDTIRTxJ63Wd3lLOisSFqsEOI5WP3qK9SKRuuZCc8Iwkjx5tRWKgNkkScS9DEOuX0X+IxEV4OZZ/tjmeHW/Vzd7QB0DUcSt0+k3yfyeL9e79lgqQjoiB+5UsxQQ26s+x9EpcGKCUJe5JP7ZaWvjbFwoFN43zuJEyiOpTCv7c27CxnywN4GuodH7+HYhzleWZHYM2KvRCtYz3EiItA6HtYkYLq3KLCUWJcwMrys1KDbjkooRGXPgRKSbJOnVqMgpEyVim19tycs+k2SGH3NsrDNITGvNpKTkjiCMQb80yWlwf4bFl6T/st7o8pR4z3K7v7WpG4MBtw0GJry+Wx5RFLSzKGXbvuuJmsaCGYpIuFhYSoOxLfz/3thnzmuipt62Rd5vcA13MzIuhKjB3R7xp7T/C2mPOtZ51FLJ3K7yQ+42mA+Jp63jd3oP/LBBzM2dsz+i5Z0hAXg8KJ/MaEdyjfTHfBfsLZwhZYjiuV1+O6w4PwF1aazWV9qmElaP5MO/WS9rgVv3tnntHhMBteYTB4mK6e/ZH6zRGWyfpChZ9jOF8CohFmxg5fw2N1iFhESUYcqcPhjN/fi6NgoeOJyB4Jcmgzp0W8/3dEMEq4tTJsnhV88KpFhSpwX6WKLozezwe43fzYPCXGhP3aVpMBD3uD3sSRpA9oe8SOLd383Nvm+yz/JBOzUlHGLvrqMd6wy4oeJLrXV5S7GO89OBvpNr96gtKLBFwyGtkRn19Bsavk1ly/jcUFdu7wHAtjYlAwx5psnfGgNd/ykMWYtakVpe/q4hExPsQm3dPbZ4sG+CbdmZUTnhYXZ5sjCBuZpaO656A8rltJQfgaRBNq1CRgFcFlYCquYYXo7SzXAznP2g/7Ijt
 r51gGNvM
 yRFu7gOIF05b5BNRt6pM/WpWbRgk4dn06gqPfISXjWiCJEFBIVMMoX6MBgNuGHa0G5sOGQZ+wPrrKvR1Iix6U4y1ZUIOJML1FZMpPoyfqJws4BBAoFdFP8Wlz3CmA/4B8RQfDCzn/McaYlOnMTHh0RxQK+BXQ3Pw2yfsse36c0NBEz4RNxrP7AgqjocDkH4MS9rsXl+UsOv3w+uq4AA7uD3bLAUjC/hV0vU1mJYJG2lYd2D76uK6TcdNUVtxOKuNKZ1qwuK56Wb/jnfq4N/BFlZr+NyYCimSr/Pjo3KgqgAYZQ+cRJXoT43loj5A01B8HrO0x8FLCpu4/2kX7dkWgtUl1bkRjGEuvceQbAijgdtxcL20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
it ever charges an object to those shrinkers, plus a pointer array
sized for shrinker_nr_max. Every superblock registers such a shrinker,
and shrinker_nr_max never comes down, so a host that mounts many
filesystems and runs many cgroups pays for every superblock in every
cgroup, live or dying, and keeps paying for new cgroups after the
mounts are gone.

This replaces patch 2/2 of v2, "mm/shrinker: allocate the per-memcg
shrinker units on demand", with the xarray variant discussed in that
thread. It applies on top of "mm/shrinker: allocate shrinker_info_unit
from a dedicated kmem_cache", patch 1/2 of v2 sent on its own as v3:
https://patch.msgid.link/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com

Patch 1 keeps the units in an xarray per memcg and node instead of the
pointer array. A new unit is inserted where it belongs: nothing is
reallocated, copied or published under RCU when shrinker_nr_max grows,
and the readers find a unit with xa_load() or walk the present ones
with xa_for_each(). The units are still allocated up front, so this
patch changes no behaviour.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the
host. The install is an xarray insert with the gfp of the list
allocation; there is no array to race with, so no lock of its own.
The root memcg keeps its units for the deferred work of global reclaim
and is the only memcg a shrinker registration still visits.

Measured on a 4-CPU, single-node VM, 20000 tmpfs mounts (shrinker_nr_max
20096) and 2000 memory cgroups, on three kernels:

  base                 v7.3-rc7 with the kmem_cache patch: every cgroup
                       has every unit, in a pointer array
  xarray               base + this series: units on demand, in an xarray
  old array on demand  base + patch 2/2 of v2, rebased: units on demand,
                       in the pointer array

                                                     old array
                                      base    xarray  on demand
  slab per empty cgroup               185 KB  18 KB   22 KB
  shrink_slab_memcg(), empty cgroup   1.6 us  0.2 us  1.6 us
  same, cgroup with objects on 100 sb 1.9 us  0.9 us  1.7 us
  mkdir/rmdir the cgroups, 4000 more
  mounts with them alive              same within noise

Changes from the v2 patch 2/2:
- The pointer array is replaced by an xarray in a patch of its own, so
  the on-demand patch no longer needs the spinlock that ordered an
  install against the array copy in expand_one_shrinker_info().
- Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/shrinker: keep the per-memcg shrinker units in an xarray
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   5 +-
 include/linux/shrinker.h   |   6 -
 mm/list_lru.c              |  15 +-
 mm/memcontrol.c            |   6 +-
 mm/shrinker.c              | 374 ++++++++++++++++++---------------------------
 5 files changed, 163 insertions(+), 243 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
prerequisite-message-id: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
prerequisite-patch-id: 83371af931f7c67d55b59e51720ebaab143aefb6

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>


