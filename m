Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B721CECD99D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E5D6B008A; Thu,  5 Feb 2026 21:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248726B0093; Thu,  5 Feb 2026 21:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B546B0096; Thu,  5 Feb 2026 21:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 022596B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:05:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3063BAD55
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:31 +0000 (UTC)
X-FDA: 84412390062.17.DA7F874
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id D60DA40012
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbldWILU;
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770343530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=up/dDjrNtGtbs/J4QNKu2FJN7ZuLHi+NXEsM8fpT+Ss=;
	b=W25uj47MekGsKlGhi3SoELYSozBFaGfNrastLZ381GlWBV3+boGRr3YNR4lUpsXHJztXPp
	AD6y5b4HbyRO0Ph1Id824s+wOAulnZh0MEI647l/YUUI8ZW/A1DM6eKmoKqK0O3uFEFYcZ
	ur1yRmQEAX11PdgrgLI1W2927hRo5cA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbldWILU;
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770343530; a=rsa-sha256;
	cv=none;
	b=WR4BsH5t9haZfRddUu2h0fmGDAH7awbDIzAY65U47U0rnu9X1B1elabPJs64ySDvAzYDPS
	G+/heUP2p7z59YMDolvvOmML7UhDbx7wmxOYs7du7ME29UMjZGe3KciEY57p+GHipU1cnQ
	1Xu3YNQN4MgiZG22yu25SW3zaGDo3dg=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770343527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=up/dDjrNtGtbs/J4QNKu2FJN7ZuLHi+NXEsM8fpT+Ss=;
	b=wbldWILUm7i4AbJrg+nbp2QzH/ahNV/2Pq7EwYybJfeROrzg41/mh58FXPdDrKz/mQpvL7
	SZvJQlvyxXO8EX6tq1gOmNYtbvEDv2UAqnW9KZHgZYVUfywuB4aeGmvjuQvhY8gJSfKbrO
	4n2AEQ1R5fKf5Jz1Oau41RMHepOMI3o=
Date: Fri, 06 Feb 2026 02:05:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <2928382d5614d5632e3508c81878c8ad720ccd7e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Nhat
 Pham" <nphamcs@gmail.com>, "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Nick Terrell"
 <terrelln@fb.com>, "David Sterba" <dsterba@suse.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <hevovghpl2udhpof66oz26ulrpqcrtuwjxcakyskoeoil2wo6x@osbrncj7ifwz>
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
 <hevovghpl2udhpof66oz26ulrpqcrtuwjxcakyskoeoil2wo6x@osbrncj7ifwz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: irmri568c7aife8u37m7o1eazgsmo3tz
X-Rspamd-Queue-Id: D60DA40012
X-Rspam-User: 
X-HE-Tag: 1770343529-908145
X-HE-Meta: U2FsdGVkX19nAwvchJRaHi33pmbMCfxnEQbwnvyLOHXoLjGHJ6wVTs5GIZrSb/QXzqyO/3OLl9Jo7Vwg34IMXiByVn8zCf7pDgSrMo4mpE4KrGfdC+enh2kYEHpY3Qsf2EBbJpmX3wGHHoOlB9Nb+FUEkvFDYL5evxisInWcfcPl5FZL1yCfGxWGSTcO/HDERYPFzRTMMPo/kGUS+02krWm0+FpPBdnaYwUQ9qo82ejGjsnucfuzJVuyF+I+5dqQOsAaEM3R4/iZm89vkXRsXUjOtBHdJnLBu/dThnkeY/Fl7PDKvYnc6ABx33vcuIUvDX+MhF3Epq6QBwpoDiqa5AUjOVeYBawifd4VOBSJiAf1LBuiTwdwGIZTDNh2CTY9tNGZLoDNBKErmjo8wO3s/qkf7Vy4Jvrt1EuKYzPzYpcUbif3FahzCVBCs3GcnBkp/SuYLh2rK9IEvcvFOITh1gJevF5Otk87IIgqfmkf/OGhdHz0guDi6tFNhRgqSUlhMlKzX0SSI039odP3lQb8ycSRUpKloqGyrzZFPCKuZPsdqzxVbIzalguhadIwgveGAwohNsh6wT5A3v8Glnz8oS06IC0GowCKUSes8IYeSeJyodYREJ/MEuDT53tHb0UVCiMnAWbGsgTM0nwLCj7IiU62fgzcpmnJj5nCUS+96ZInA7i5ggQj72fOEWe8/XQ/bElIHZxtplXQ2QzDbW+jckrGwdAWaWrWTjhKv0aBP4TNbiNpJaTkFpzIxU7ZFOlohOVzITxD94Cp9MK56f8nEyhNdyB3xt2E1Xo75k85vQGeC5Jfx0Xr/VP38LRq0O9p21QqAU2mPpGUMNZQmpr2VTjNdhLWGLa41XxRzxr+ESIasgpjtCilT36r+XqHbdiwJXMZC2jzkkBhF+OWvDi61GUwyLCt+zGmnZZ7vjP6jpFkwJxTTTm/jcFeg9FDbtQYV+L9bOe9AStY8Uqla9Z
 T2WkdtUb
 oIb03hXKXnEgHYrraEkbMRY2uJuIsr3D/7DOPWM9TSjOKizbkK+LprX30QLWGMqII5CBpzZ1cDGH5zUiooxvXHAX6oNGSJe31UmxuX6BJ6+qNkCfuoN0n2o3cFxf3xq5hIDRGiKvdBDGa2AhYnt5hG9g6gEw89mwYURA6PlNXIgQWoEb7EbHSF7uE314JcxTqvy2zElM+gbbBHaj2lsApDt/vnAC3f2pD1mCgUMKquN0hcvUFdh8ETDZJrZBUdk0oE+Ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

February 6, 2026 at 08:39, "Yosry Ahmed" <yosry.ahmed@linux.dev mailto:yo=
sry.ahmed@linux.dev?to=3D%22Yosry%20Ahmed%22%20%3Cyosry.ahmed%40linux.dev=
%3E > wrote:


>=20
>=20On Thu, Feb 05, 2026 at 01:30:12PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20=20
>=20>  The global zswap_stored_incompressible_pages counter was added in =
commit
> >  dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as=
-is")
> >  to track how many pages are stored in raw (uncompressed) form in zsw=
ap.
> >  However, in containerized environments, knowing which cgroup is
> >  contributing incompressible pages is essential for effective resourc=
e
> >  management.
> >=20=20
>=20>  Add a new memcg stat 'zswpraw' to track incompressible pages per c=
group.
> >  This helps administrators and orchestrators to:
> >=20=20
>=20>  1. Identify workloads that produce incompressible data (e.g., encr=
ypted
> >  data, already-compressed media, random data) and may not benefit fro=
m
> >  zswap.
> >=20=20
>=20>  2. Make informed decisions about workload placement - moving
> >  incompressible workloads to nodes with larger swap backing devices
> >  rather than relying on zswap.
> >=20=20
>=20>  3. Debug zswap efficiency issues at the cgroup level without needi=
ng to
> >  correlate global stats with individual cgroups.
> >=20=20
>=20>  While the compression ratio can be estimated from existing stats
> >  (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> >  "uniformly poor compression" and "a few completely incompressible pa=
ges
> >  mixed with highly compressible ones". The zswpraw stat provides dire=
ct
> >  visibility into the latter case.
> >=20=20
>=20>  Changes
> >  -------
> >=20=20
>=20>  1. Add zswap_is_raw() helper (include/linux/zswap.h)
> >  - Abstract the PAGE_SIZE comparison logic for identifying raw entrie=
s
> >  - Keep the incompressible check in one place for maintainability
> >=20=20
>=20>  2. Add MEMCG_ZSWAP_RAW stat definition (include/linux/memcontrol.h=
,
> >  mm/memcontrol.c)
> >  - Add MEMCG_ZSWAP_RAW to memcg_stat_item enum
> >  - Register in memcg_stat_items[] and memory_stats[] arrays
> >  - Export as "zswpraw" in memory.stat
> >=20=20
>=20>  3. Update statistics accounting (mm/memcontrol.c, mm/zswap.c)
> >  - Track MEMCG_ZSWAP_RAW in obj_cgroup_charge/uncharge_zswap()
> >  - Use zswap_is_raw() helper in zswap.c for consistency
> >=20=20
>=20>  Test
> >  ----
> >=20=20
>=20>  I wrote a simple test program[1] that allocates memory and compres=
ses it
> >  with zstd, so kernel zswap cannot compress further.
> >=20=20
>=20>  $ cgcreate -g memory:test
> >  $ cgexec -g memory:test ./test_zswpraw &
> >  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
> >  zswpraw 0
> >  zswpin 0
> >  zswpout 0
> >  zswpwb 0
> >=20=20
>=20>  $ echo "100M" > /sys/fs/cgroup/test/memory.reclaim
> >  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
> >  zswpraw 104800256
> >  zswpin 0
> >  zswpout 51222
> >  zswpwb 0
> >=20=20
>=20>  $ pkill test_zswpraw
> >  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
> >  zswpraw 0
> >  zswpin 1
> >  zswpout 51222
> >  zswpwb 0
> >=20=20
>=20>  [1] https://gist.github.com/mrpre/00432c6154250326994fbeaf62e0e6f1
> >=20=20
>=20>  Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> >  ---
> >  include/linux/memcontrol.h | 1 +
> >  include/linux/zswap.h | 9 +++++++++
> >  mm/memcontrol.c | 6 ++++++
> >  mm/zswap.c | 6 +++---
> >  4 files changed, 19 insertions(+), 3 deletions(-)
> >=20=20
>=20>  diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol=
.h
> >  index b6c82c8f73e1..83d1328f81d1 100644
> >  --- a/include/linux/memcontrol.h
> >  +++ b/include/linux/memcontrol.h
> >  @@ -39,6 +39,7 @@ enum memcg_stat_item {
> >  MEMCG_KMEM,
> >  MEMCG_ZSWAP_B,
> >  MEMCG_ZSWAPPED,
> >  + MEMCG_ZSWAP_RAW,
> >=20
>=20Please change the name as Shakeel suggested.
>=20
>=20>=20
>=20> MEMCG_NR_STAT,
> >  };
> >=20=20
>=20>  diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> >  index 30c193a1207e..94f84b154b71 100644
> >  --- a/include/linux/zswap.h
> >  +++ b/include/linux/zswap.h
> >  @@ -7,6 +7,15 @@
> >=20=20
>=20>  struct lruvec;
> >=20=20
>=20>  +/*
> >  + * Check if a zswap entry is stored in raw (uncompressed) form.
> >  + * This happens when compression doesn't reduce the size.
> >  + */
> >  +static inline bool zswap_is_raw(size_t size)
> >=20
>=20Internall as well, please rename this to zswap_is_incompressible() or
> zswap_is_incomp(). Not a big fan of the helper because it doesn't add
> much, but I don't feel strongly either way.
>=20
>=20>=20
>=20> +{
> >  + return size =3D=3D PAGE_SIZE;
> >  +}
> >  +
> >  extern atomic_long_t zswap_stored_pages;
> >=20=20
>=20>  #ifdef CONFIG_ZSWAP
> >  diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >  index 007413a53b45..32fb801530a3 100644
> >  --- a/mm/memcontrol.c
> >  +++ b/mm/memcontrol.c
> >  @@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] =3D=
 {
> >  MEMCG_KMEM,
> >  MEMCG_ZSWAP_B,
> >  MEMCG_ZSWAPPED,
> >  + MEMCG_ZSWAP_RAW,
> >  };
> >=20=20
>=20>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> >  @@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[]=
 =3D {
> >  #ifdef CONFIG_ZSWAP
> >  { "zswap", MEMCG_ZSWAP_B },
> >  { "zswapped", MEMCG_ZSWAPPED },
> >  + { "zswpraw", MEMCG_ZSWAP_RAW },
> >=20
>=20Here as well: zswap_incompressible or zswap_incomp?
>=20
>=20Other than the renames and doc, LGTM.
>=20
>=20>=20


Thanks=20Yosry!

I'll rename everything to use "incomp" (MEMCG_ZSWAP_INCOMP, zswap_is_inco=
mp(), "zswap_incomp")
and update the documentation in v2.

