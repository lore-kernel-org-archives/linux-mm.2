Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3506ACC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D646B0099; Wed, 14 Oct 2026 10:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4956B0095; Wed, 14 Oct 2026 10:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685046B0099; Wed, 14 Oct 2026 10:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC1E6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:54:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD944A80BC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:54:52 +0000 (UTC)
X-FDA: 85321528824.19.28F6E6A
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01CFF120006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:54:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=qJx9Q5tH;
	spf=pass (imf29.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P3u7wh650LQfC5H/99kzz2RW5fV3h9goli82zS1rnFs=;
	b=rOhLVS5nCNz1ZT9dI0tjWC5Z31TRpsKmWl7ZQWhN6jLb3q5cUd3+mWa8raLQX6NQfLB3dp
	PmzOCl5MatN/VISx+5l+EgcVoTOPu/YPUNeEkzDYbg3mJdL+ShJ753KKHQOS/vXBR1lqlo
	dQDNOuPVr9g2UXxYKqrOzLNz0FVEEL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791989691;
	b=DCJcoAHAsb6QfUJW68lssHUz1hTexs1+5HMP6OdVwAsMqyw+9tiw3lu1m0h5ffVOEiOBA9
	iN2xeGYU+5cnGWAwbj2MpmEZDUVMG/upMaoQiIX4BkXv9zvpMHzE4Ty0lkg/2xWT9/x+k9
	MLSXC3K63qM4bjAasTqy5ouxcLZWmeM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=qJx9Q5tH;
	spf=pass (imf29.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=P3u7wh650LQfC5H/99kzz2RW5fV3h9goli82zS1rnFs=; b=qJx9Q5tH7HAmimq0tac
	a1qF2+b1lPhXgXAN+odgQUbZhu0fRyDkrolwub/lJvCqSg2Y/xAhp/9zPXtKWJ+oG3RODqM6+qL+c
	Ulodr9TAdjkzi2363AcTlMnr41nlbH7QEN6aZq/TqsGyp6mM2F18f2vDExdjxoM3m7Hy5HoB0gP+u
	AmSv3ckR6Mj8dRyU2flx6EjWvNosHQqzFG6cNw7gRkCBorrob8m+jjpIcmS53yMs4cSygEYWDGhUr
	zdcMxgj6kCm25aE/K0+M9BXcwjcSMUXmfiuf/soAPLdYoyasiHEYSqYH7hp4p4wB0kXseD5hec0HL
	ZzCG01EnOdIWavg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH0Jx-005Oui-24;
	Wed, 14 Oct 2026 16:54:41 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
Date: Wed, 14 Oct 2026 16:54:36 +0200
Message-Id: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKyXz2oC/6WOQQ6CMBBFr2K6dkxbENSV9zDEFJzKaOyQtlTFc
 HdB4wlcvuTnv/cSAT1hELvFS3hMFIjdBHq5EE1r3BmBThMLLXWhpFJQ59B57CCFyB5UnpdqDYE
 GhNB6clf0R3KWj72jCJHBQMd39MAW4p1hazXKPFNFZqyYJNOXpccn4FB9OfT1BZs4W+dFS7Pp+
 SlMat79YvS/MUmBhLUpC7nJtlldmn0iH3seBl41fBPVOI5vuN/FjiIBAAA=
X-Change-ID: 20261011-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-9f2e043163af
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4231;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=P7bZzj6xenUe0m/5paemzVVbu3YzPqLx/omzZ2oOYjY=;
 b=kA0DAAoBUZYKR/lhXCoByyZiAGrPl6+giO1vNLKnE0JUz6x2xvAw5F7PR9zZPadnJOpiYheQ7
 okCMwQAAQoAHRYhBFYPbcg9xdPQY70ILFGWCkf5YVwqBQJqz5evAAoJEFGWCkf5YVwqNuUP/2bQ
 ZRHFWIngqp3/NabYDeC7TuMQ/rgqDhD8NArNt9RJBVZEMCoMBtJfmS9qxcbo2KxlacGORBY9QaN
 T3187tvugLUdKueY5p5VWl1jvT0mF+KYvSB+oaRWifR43W9e8PHumScNzsg9EC8GXTY+QClUfmw
 +7OTXCHmMpgYGzJ9lQyiRM2H4x1o0kg99ckpyAKtCrgFkOzDoeaG8PwxG0Fe2H3UNR2jo89VjkC
 8wh5pZDrjcE8n69+cBASaN7KrLlLbcT1+oSGj3z0gU7Kv2cK4nIpEBU5zMVn63lBT/8mQ8f3eQ1
 sR+eQktV8aaIZlIF0gtpEAMUGXr8AIdD+2ie6YTq7eSFhzGDu+K0k1ztxyCmgtMKldO1gXSnUG3
 aVWV3PGevrLAjeF+YNOWpc96aEDeG6dKsM4HdT9tTIwrQHbXQCTW3fharhqonUe6lhbwNXyBcxB
 R5SSzMIsGalwZmq3FlZvjz4MacO3Hp6ZnYNqNqoiMGFzBRYMgloG0FOFNu2D1HAAbQoMowUo0U1
 Q3DVk9rITSOHlgokZQjr0edMHEqNP/QeViLvYk/iVSERiMhHa0wRbLjvp55uhY6okU921jZTEJ2
 LE/NCkpIw7hPfxmWvaY/MjZFW3hXlSn1uG0qWSE7Vge8P7o8/IALSmANSp1hUxrb83kOPppeFKt
 S1r8v
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Queue-Id: 01CFF120006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 97m4fgqzd1f9utc5wretj6h1ctbz3tjf
X-HE-Tag: 1791989690-32399
X-HE-Meta: U2FsdGVkX18xRE1L0Ij162SNuYJfZgnlDNNUmqdrdcU1AxarQ+GlOEZ2LoRcl5etOwu4f1OR6O92Fz4orjr0uTmEVDBWlw5gLm3tezknJI3+iAwJPy3Rm6fzlkXQrFPfWMvgM5R2kYDTlpJhBciOpHDlbifjOViCwY7nIaM93E0xs0YaZSo1O32WdkdPPjdh2+04WlnaGs5ePeK96ZNxhpG+xWohtvHmat1NauOmcL7BFmbAMfCv7VoUqJ5BzeT0fgJUZuwKGQU6coXXHt/up8hKLtHZYNcUREsBt0ntwPufZG7BxmCYg22xzC2+e4JQ2KECA/mvCQxJJaZ5o8TcRpgLzbtYYO3JF41gr8QcO+U3SGtCQx37uZz4btwY6YRxfZH1udr38FHxxReYLR6tfOHPsPwowYTiT/2zv5wf/kZU6JTIkq3upl2O3fF9+5I9cg0uBeuDyx4fKKC6waj44/ligkJ5EDbqwWD00Q7VODscRrTXXpaVUNmBeAu9lGq0mOdMMDyMTT/SCNEnm/sYceDRoJrwQ4g6VEAxbZR90ekSdNZui2Ubld766oqeJV+JqFKkq/z1NfM9UTGxfrF2XS81ZkJwSy/mIuiTDdmBty5nLAUIQwo6zi6asaANGJhWeBrdAKx7Es5o7aOjYTaC+/Uu6IjdBedeCCQllj+QCMmntUfNw9QioIrX2wFm1JWEIA2YMPi5Dl+lmWF3MP9UQVzt444s9vYcgy4XkMGNBirFtjT1R9mw16LC1kHbO3L4oqePle1yRjAjvZ7z6Hy+WCKTcuujlCnyRZpspb0LgEb8/px70SD7/ActQ7Bc1Sr0+J7LGz+bJjVfoLllzmDik+LJT+6OqhWUmWmCUuw7l5S5izZvXVLk6RkmqB4sR2u8Gr2qYauRizNEYUnlVavWl7BAH1hNF+JlqKwmHLaP9w68ednpQW01atENt8+MyyChsgomdcVf6oaMfiecF3s
 Q+Rhf4a5
 I/yXOBCN9BDAZh6DuCgMgqOK0N5Dqcc48c4GEVhRzUldSn3KJF0+hRZLo0rdhhKLHXYXqZveL4SUKpIICIsHvkUxs4I1QbxaQUsD6OU+c7PqYJr7MoS6mjJVe3Fz9RGE86uzPIgoIrjI00JKedgLS2oUpKbKwUz6JDYWRZq9lMwNAJ93LeKbatM/THw5SAm+sMDYMyJFbcH/jDt1K424nS8rTAe4bj2LbNa0DufDhYZrxkZ5KFrzpIeChB4zTjOoZLxswZWVjhpMG8gTg1YG7gQRrEsDuCnX15yDolmN8oNvZAHhlGBQgM/6WkN5dSAmLydZiVCcLy+LdlpKkn9SwifVFGbpNbKZYHTtNpfOrhxSv876Aw3UW+XuQyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
ever charges an object to those shrinkers. Every superblock registers
such a shrinker, so the cost is

  memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB

because the unit is 520 bytes and comes from kmalloc-1k.

Page cache reclaim does not make this go away:

- Live cgroups keep their units until they are removed.
- The units are not charged to any memcg, so memory.max does not see
  them and a delegated subtree creates cgroups at the host's expense.
- A dying cgroup keeps its units until the last reference to it is
  dropped, for instance by cgroup writeback, a swap entry or a socket.
  Nothing reclaims it for the sake of the units, and MemAvailable
  counts them as unreclaimable.
- shrinker_nr_max never comes down: after a burst of mounts every new
  cgroup pays for the peak until reboot.
- Both factors grow with the number of workloads on the host.

Patch 1 lets a unit cover BITS_PER_LONG - 1 ids so it fills a 512-byte
slot exactly: half the memory, nothing else changes.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the host.
The units stay uncharged, but how many a cgroup makes the host allocate
is now bounded by the shrinkers it uses. The unit pointer array in
shrinker_info still grows with shrinker_nr_max, at 8 bytes per 63 ids
per node. Patch 2 relies on commit fafaeceb89a5 ("mm: switch deferred
split shrinker to list_lru") and is not meant for stable.

On a host running a few hundred containers (45000 memory cgroups, most
of them dying, shrinker_nr_max 52480, 4 nodes) the units took 145 GB of
377 GB.

Reproducer without containers: 48 CPUs, 4 nodes, v7.3-rc6, fresh boot
per kernel. 8000 tmpfs mounts raise shrinker_nr_max to 8064, then 2000
empty memory cgroups are created. Active objects added to the 512-byte
and 1-KiB kmalloc caches, and slab per cgroup:

                  objects added       slab per cgroup
  base            1011518 x 1024 B    548 KB
  + patch 1       1023787 x  512 B    289 KB
  + patches 1-2       136 x  512 B     42 KB

The 42 KB left is the same on all three: the memcg's own structures and
8 KB of shrinker_info pointer arrays at this shrinker_nr_max. A cgroup
that looks up names on two filesystems gets 8 units (4 KB) with both
patches, and so does each ancestor that had none. Writing a page of a
file in each cgroup and removing the cgroups keeps the same amounts
pinned by the 2000 dying cgroups until the cache is dropped.

Tested with selftests/cgroup test_kmem and test_memcontrol, a check that
memory.reclaim reaches 140 ext4 superblocks with consecutive shrinker
ids, and unit installs from 64 cgroups racing with 3000 mounts that keep
growing shrinker_nr_max. On a kernel with lockdep, KASAN and DEBUG_VM the
same runs leave nothing in dmesg. test_memcg_sock fails there now and
then, with and without the series: memory.stat's sock counter is not
flushed yet when the test compares it with memory.current.

---
Changes in v2:
- Patch 1: check the unit size with BUILD_BUG_ON(!is_power_of_2())
  in shrinker_unit_alloc() instead of an open-coded static_assert()
  in the header (Muchun Song).
- Link to v1: https://patch.msgid.link/20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/shrinker: size shrinker_info_unit to a power of two
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   2 +
 include/linux/shrinker.h   |   6 +-
 mm/list_lru.c              |   6 ++
 mm/shrinker.c              | 163 ++++++++++++++++++++++++++++++++++++---------
 4 files changed, 146 insertions(+), 31 deletions(-)
---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261011-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-9f2e043163af

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>


