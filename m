Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277C1606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=cCSq+FIV
Received: by kanga.kvack.org (Postfix)
	id 0E5176B00EF; Mon,  2 Nov 2026 18:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0931A6B05B2; Mon,  2 Nov 2026 18:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9406B00EF; Mon,  2 Nov 2026 18:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A31AA6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:13:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 364E21C32CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:13:46 +0000 (UTC)
X-FDA: 85391733252.25.E14160F
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F248C0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:13:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=cCSq+FIV;
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793661224;
	b=nkjSlnXkhFkg1ftS2yCs5y5zmg7VEyrFpJ7Fzm9ebjotkMy/SYXsPGAVQcV5Uj2kUg2/WN
	TsOGfrl/v5p21VJZBr/POefXmZDlG30LIdOdC/qGP16YxO1p8ocHSIvRrMplqM0U7H6Gbz
	GfocUDmFIewkj0nQEvM3DoqObT31gCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793661224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JcLuFHhw27HERXH0ZkmjvjZMMAATxckS1b23zRHt1ec=;
	b=5byvSZsh9ED+0Ol4GCHbQTRKiGPvcd84jVEItSCY+6wj4+wCjoGcOQ5VijqF5rIcpcbqZ7
	RwehPqyr7iNPDmDBXV3tTl2SAmZg0PiqX5eVOK88KbdeFUUNQfenxImruN3gT1CImLC2z9
	io5AbFJLLggoSXq2mgsY2UKJK+N+Amw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=cCSq+FIV;
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=JcLuFHhw27HERXH0ZkmjvjZMMAATxckS1b23zRHt1ec=; b=cCSq+FIVgztQBXGHjc9
	J9lqFaU8kg3aabGctw6VG7NG5JiSSxsm2XYNGP8fvKH63780VAZ0XjU6SyqlnZQRqHnZsFkWRLJsL
	RoXP9dQtwG2HcCnCAOX3ZdB5Bh1m0uA6OmrKRGpzz7UJBd+jGRDWW9jMogZpn/8i+NIRbbxmSFERq
	3KBr5C2msJoCS9jPYECF0kbvyf6RKZqu7NnTzBsIO7BWIgmdWAPjiBQiiiEBBi2R2lmKuXsoLfMVS
	+UtEMnPKjxqXcnht/5i9O/qpPA+kbGi18pAjZXePg5C3oS7m+flNBeHP4T9zCUsusOda+yJLtUIth
	/0Jw4RC3GsTkydw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xO19a-00Ael5-1j;
	Tue, 03 Nov 2026 00:13:20 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Date: Tue, 03 Nov 2026 00:13:18 +0100
Message-Id: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-0-cf9b836859c5@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA4Z6WoC/62OTY7CMAxGr4KyxqipOg1lxT1GXaSJSw1q0nHSi
 B/17pMCEhdg+axPfu8hAjJhEIfNQzAmCuRdhnK7EWbQ7oRANrMoi7KWhWygq2BinCCF6BlkVSm
 pYEKGEUdzgjAwuUvG2VEM4B1YHLWzcNXM+gZ919tS6b2xdSOyJP/q6foM+G1fHObujCau1veC8
 W/OZfEzG2jV357ZSa7XrxUmCQXUFVrZq+ZHmeaYiOPs73e/M34U7bIs/3vX36M3AQAA
X-Change-ID: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5869;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=l8oqwuaUy7RuuxR06b/KSffJSmt0GAqvDJ19zrGD2Kc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq6RkWkXk3KAf4GavsGrXJmY1UgmJ0GLNDPQP9B
 PCANs4KYGeJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCaukZFgAKCRBRlgpH+WFc
 KgOSEAC82HYdytAXrqmBD615/PSf8PNEze9HKxSnwyzlVEyDEilcP2Pa4RVnPinQuw1Rqn3kQCI
 byPWe6nwXf12rHz979r8RI6nU9N9Sx/JWzsCvhiSvcT/q2yID/caPXTyMB3fd4wiA2at0earxf/
 zYrvMQZKVLeKyxgilZUDhquqrCNAs2isudeH/PWTaGO82ViPt//NECLOsnwOVDCY20t8hAoNaLj
 jTwec53ZsZZCli2ZmEb1cTwnu4S4hgK/ex1Ks/9YugwOILZZGbF8rKSJfaEQjpoG5a74EKRLldC
 5k95cCdP/FmaFyfoCx3Duo1vZDpiKhGhvXEMaLDtZjhd9xyz/cMYdDH2vbFdu2Sl7/CLAdCkuG0
 6zHtwF8a9KBbHg1vlQlp+Q+tUQiBij1UTYW9PJOp0ah2lzfxkK8gL1akncLfEoYyytMuOwfRF4i
 qydd8M82C3Y5XzCvBE4rRxAIXm4erzqXFx5OnSPkfYUm3afI08rwjfGiFiy7N4vLjdlc26MKoNA
 CArAnDvpfhumNiVqLkvszGpWiaevEYsP9S7Cy0sDN2SdPj8kW//bR1RKYtGdhZvUN37qXT1g9rR
 +32JPxr/QhA0baKJ8MwsZmvg2H6lvMAI+LyOal6CFTInnH28Nx5vn/UjguU/LPojdgbnRGfrtdu
 w2skggCI4yRoIUg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: q3191jff1fq1fpfubo1s4qrxk1wr7qz1
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4F248C0003
X-HE-Tag: 1793661224-997490
X-HE-Meta: U2FsdGVkX19cyfWHgaS+WRVc1WRI94XHI9X0S2OIyOR8XG+i5oGK65CI8QzVd8PtmO3JrtO2JWSV51RVPujsmXiZpym7vQ25TbPBi1F359+2VdYmO3G7mjXxNmqri3mmJLlmppDBbFujH1Ha2dtqWC9J/Qhp2szV6CZquS9RLCdy3VarMshYOmBXjcYWeYfs+YLVcv53l5D/pLpHDhO9plPG82SVxWGrHtgE+HMzpVJJ5WCxhk3E62KHl9y089QhHfDa2RYpN07+9uR8BzhkbNNcpJS0Jgp8LXj96zZbQwwnNaSaDpjNFs7PSEwEqQ1s2duYlWrwvrkN7tnQuD0pfoQP9JISw8dz6EZ6XiIwiBbQi334eCVr7ybHbrIqL0eK1odW6CP2hcr4OtTLpYNuBocT2om0g9e75TDlrOSGLROPzkj4Ml6vSeDADy/TwLbSfUjHXDYdvBZ+Fc4KoEJVLvVqxZYZQxsPNJHA37HHHKrGYMhKvkzmYnypxorETQgfn5G3zU6j1/NRM5olojueQ4pTlOY10d5qmYOVFQ0QnPGGWEjBlli9KprszoJLYcQG+8EQCTLQl9/AefaKGE3PWvvAcii8Ir12/2RhUXfTvrB+wlYOEseQzO5zzmfn8oC+hPCtDvug9N93LBHy+4mDeqFeDPdFwCIez/FPWMsMZ9TsW5UQuqUc8vmdy1DOThLxuAePw15CK5R5k2GU2rSxSo1FiRhatfVlstaDPPJ7tADzBWcAUbl4kYIbRjDRPVQfuKxYLwVg47cD3/1rPLIgh7ExPsVyDNSc2zsEZW2TwPoD2GHAwdRqczPajV2e8cXOAn/Ywvjt4Tuq8sOIj0Otiw7g5m4ycwo0cxUETcWGDKSM6i56TvpzTX6mvWoV0fd5zhGssYr9C2vawMVPf74OTRvmpAla8L2srIoX7iReXCtU7CoDl/3hedmtdevyXrcGxWd49ini8tHJPRPABks
 jXRKD2Rf
 9HSunyytNLCr2Yfy43qDLWeUZ8eX+UK2cVy/MdgVNXclIHS4iDD9yWP1247Gouel/wEMf3EkW0uDJJZ9jTnipGCm0qWK9i/p4QRhfiFHP2h5zB2fwMf4+aRcvMB+0SOuOkPB/nLIa5vS7ejsyaqAH5A7avW0bNBHVRke/ZRFn8Psg9shLkJc/TxOKSnFBXJm4sU/HgEFZlcMWxx4ERH6KwlsMPZHxuUJJejMrQ1ulOw9cR5tnJwqg9DuTggvylQtdf32bGXpwE4B0dNQFZJkG5zSMmwzr8CE8nAqQ9EVepigl/OFxKrL9nUFw5Zd6rf6KVy5mClcfGuJ3uSaUU2N+TexVOzhN9XV1HHBF82mBWEhN8V2MmP9It0bj6XaPayvXIuZxEFJXOCmZlo9CxwX6OXkZ0SQ3r/cxVPaJ
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

Patch 1 keeps the units in an xarray per memcg and node instead of the
pointer array. A new unit is inserted where it belongs: nothing is
reallocated, copied or published under RCU when shrinker_nr_max grows,
and the readers find a unit with xa_load() or walk the present ones
with xa_for_each(). The units are still allocated up front, so this
patch changes no behaviour.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the host.
The install is an xarray insert with the gfp of the list allocation;
there is no array to race with, so no lock beyond the xarray's. The root
memcg keeps its units for the deferred work of global reclaim and is the
only memcg a shrinker registration still visits.

Why an xarray and not the on-demand array
-----------------------------------------

Allocating the units on demand removes most of their memory with either
container. The pointer array keeps three costs that scale with
shrinker_nr_max x cgroups x nodes instead of with what a cgroup uses:

- the array itself, per cgroup and node, also in cgroups that hold
  nothing;
- a registration that crosses a unit boundary reallocates and copies
  the array of every cgroup on every node under shrinker_mutex, which
  every other mount and umount waits for;
- shrink_slab_memcg() walks shrinker_nr_max / 64 indexes per cgroup
  and node on every reclaim pass, whether the cgroup has objects or
  not.

The xarray holds only the units a cgroup has, so none of the three
grows with the number of mounts. It is also less code: mm/shrinker.c
ends up shorter than before the series.

Measured on a 48-CPU, 4-node host with 50000 tmpfs mounts
(shrinker_nr_max 50112) and 20000 live, empty memory cgroups. base is
v7.3-rc7 with the kmem_cache patch, where every cgroup has every unit;
both on-demand variants sit on top of it. "old array on demand" is
patch 2/2 of "mm/shrinker: make per-memcg shrinker units cheaper" v2:

+--------------------------------------+-----------+-----------+--------+
|                                      | base      | old array | xarray |
|                                      |           | on demand |        |
+--------------------------------------+-----------+-----------+--------+
| unreclaimable slab per empty cgroup  | 1.6 MB    | 65 KB     | 34 KB  |
|   of it, the per-cgroup array        | 32 KB     | 32 KB     | 0      |
+--------------------------------------+-----------+-----------+--------+
| 640 mounts crossing 10 unit          |           |           |        |
| boundaries, 20000 cgroups alive      | 1.41 s    | 1.31 s    | 0.10 s |
|   the same 640 mounts, no cgroups    | 0.08 s    | 0.08 s    | 0.07 s |
+--------------------------------------+-----------+-----------+--------+
| echo 2 > drop_caches: shrink_slab()  |           |           |        |
| for every online cgroup, the walk    |           |           |        |
| kswapd does on every pass            | 23 s      | 11.3 s    | 1.3 s  |
|   of it, shrink_slab_memcg() per     |           |           |        |
|   cgroup and node                    | 22.8 us   | 10.7 us   | 0.5 us |
+--------------------------------------+-----------+-----------+--------+

This v2 on v7.4-rc1 gives the same xarray numbers on the same host.

Assisted-by: LLM
---
This replaces patch 2/2 of "mm/shrinker: make per-memcg shrinker units
cheaper" v2 with an xarray variant. Patch 1/2 of that series is in
v7.4-rc1 as commit faaf8b406c517 ("mm/shrinker: allocate
shrinker_info_unit from a dedicated kmem_cache").

Changes in v2:
- Rebased on v7.4-rc1, which has the kmem_cache patch this series was
  built on.
- Patch 1: memcg_struct_check() asserts shrinker_units in the
  read-mostly group, where shrinker_info was.
- Patch 2: free_shrinker_info() no longer takes shrinker_mutex, as a
  registration only visits the root memcg.
- Patch 2: __list_lru_init() keeps the SHRINKER_MEMCG_AWARE check of
  commit 6a100811c7c5f ("mm/list_lru: don't copy stale shrinker id from
  non-memcg-aware shrinkers") next to its own check for a per-memcg
  list.
- Cover letter: why an xarray and not the on-demand array, measured on
  a 48-CPU host, from the v1 thread (Harry Yoo, Andrew Morton).
- Move Assisted-by from the patches to the cover letter, after commit
  1e035297ffdad ("docs: remove Assisted-by references").
- Link to v1: https://patch.msgid.link/20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/shrinker: keep the per-memcg shrinker units in an xarray
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   7 +-
 include/linux/shrinker.h   |   6 -
 mm/list_lru.c              |  20 ++-
 mm/memcontrol.c            |   8 +-
 mm/shrinker.c              | 377 +++++++++++++++++----------------------------
 5 files changed, 164 insertions(+), 254 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-fbfd27a8cd69

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


