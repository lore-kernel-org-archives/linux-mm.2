Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909CDE9129F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5606B008A; Thu,  5 Feb 2026 23:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C967B6B0092; Thu,  5 Feb 2026 23:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3596B0093; Thu,  5 Feb 2026 23:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA4A36B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:13:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67C661B2BE5
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:13:08 +0000 (UTC)
X-FDA: 84412711656.25.CF3E4F1
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78DDE10000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:13:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xspz+Efq;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770351186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2nb7m/lJo+RpXLZ4jqQFzQjiRXw6teH08HYzSdnXqs=;
	b=6wLBjDZRemJxj8oY8hgF6PjpFzMaO8J96skOLU+Nmv29tJ95bLQTuB/Xw6+2ElwOnnOoMT
	TXITrPyQGrJqvfsp/9ctlY0+MXoVqRnI4K330K9Uj+mqutUA04GRdFhb1x0aNUz9VwtIX/
	/dPJAY9ngp1Sm8IlLCdrQO3ewVhWHyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770351186; a=rsa-sha256;
	cv=none;
	b=Zk0e/HxXm4T9SHnZIfYRvBmmFUwQDQtTaycmdbwr66rCHRBY8d7oDTvUoVAUTE2l4QzUTT
	Ix7vIdS6a2F9eHA/DZjr2RjS//dsPTOPmvQdqhpx0hysZWkUs6G+91+emcEqdgJEZPcZRH
	7BF/tG7OSbRFIYn59JP46CmD7BdqjNA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xspz+Efq;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770351184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2nb7m/lJo+RpXLZ4jqQFzQjiRXw6teH08HYzSdnXqs=;
	b=xspz+Efq/TClnHX6aZjGa8how1UeJlibzMvrHFBhNPg3bwRVYPKbGtaSt+RW8hloaLNyE6
	D9Jx3KG2+gvtBFS6wcc7usHkrUMMXkBQI9W1pRHJipcIU6FlLaNfA4VGlhdRQ0e3Sj5KXu
	8XIkPbPxT4jtZ1NwxcXHgLXT7UOLZVE=
Date: Fri, 06 Feb 2026 04:12:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <b40e6e0a63c4303e048ed0dbc61c09788de98e19@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>, "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, linux-mm@kvack.org, "Jiayuan Chen"
 <jiayuan.chen@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Nick Terrell" <terrelln@fb.com>, "David  
 Sterba" <dsterba@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <3179fa38027bdacdd38b4ef34b493bdb5ef7a19a@linux.dev>
References: <20260206022152.67992-1-sj@kernel.org>
 <b0b984be60ffa366929d363ec2b63f5c92187556@linux.dev>
 <3179fa38027bdacdd38b4ef34b493bdb5ef7a19a@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 78DDE10000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: b9atbxtzt863naecwh551zyj6q1hnhxr
X-HE-Tag: 1770351186-426387
X-HE-Meta: U2FsdGVkX1+PtnkApY4t6tK+/hFkDdqAdpC/h0v8cSYPSk18a/IM5xfeXyvZFEk2WH8kYonaymn/tvU+vFSbOWUYKPv6nB5NDRNuZure/AxYUaTS2qtsOww0bIBo+sfvUE4g6FpdkBrOyQTPQfWXrGjfa6JqOIm5gqYsbIt4lQ9kxnPGV5lsIcgUyHfV2k9FApx5Atcyg8EMNcrOJPjU4cybX1p/lzyZ09EfktqH0y37VV1w3hj58Mxs95nLP45RjLK3AAQTBcBmIcEmBEyNflvtVvbOquvcJ6CP4rnrYtKMbl44/MSri+erdTNtBJbAWKNYXwF+V3l8jsXTEyDfujWCoEyYCtPKvWhRRqnqlgT33AqtbpDlShfbNndJkfonZLY0n0S4qq7gZl1qjsWHXGo6xGiIWLWhcA0d71BBfDvha+Lg312p/jBboPFPApXBf53hx7bndMyo9ywmiCoF0MJKDmerbMUH0KQbJV+kSWJrtQ8aLx/fMbIm9cHUdnynkEv6MY9EbeDRp+uvHANQZ83mBGTyyG5yB01yWmQ1TB4DGTOV37gOEyHy11AtCnWpQ7/hGetJq2hWHnqn0CiJwJmwoykXN3lf5QUcYTzEh9SbI7qr45sPZKFGPQkpsMQlLMBZqvSEiAkmkOvJfU2azbWHiLYSTpARLB8t6E3GyVe2+LblIJV6vgA9YhHLVyCySkmoFRl90nA8NpjqpyhiI8ege/gNm3J5EeTtyOX7s7mE70e7adcukkZQRUcQUDmkyc4LgGu82MpHnZ5cRX6QFG9q+iYHe1U1hv/VW9iatNBNKO9MJw6iGRQcgRKxiNL72MWF5/NRd4Qz04XduPKZpnovjDOXhYmt0FsbkexiLdC/ZJtGtPiYhwUozh+HD0CwZ1Z1BTY4l117FYGsyGfYJrCPRMLPhBqtvOWrZm1oOsWSNKc7+8Dw2T4ZCJzkP5AUQhET+jzJb0lsoVT17Qi
 BjCKUXJW
 RM1npvOFFRAeBjwDJGmgW7mXtXziP0+L23TixValeHKs/9q7DNmpT1pX3S6mujFYZ6RTLJGWGjaTb/Wo+nD4gMyyROgs1w4hjk0A/6wzsaaRnbcebC5nrasV5SRQvOA/sGGaOnVvDp80zGzJbC9SLiKXX31K3KHyT5775pe/nj2se3Yf15HaGzwZKYtXHd24lrYaq3ulmGYTl7TzVJwUZnxj7XbDJDrBepVrflcm9/9JSmoxccdlBuLXCu8IiILQmMW2a+n+AOmiyg0dwBIjMu2Zf5F8H5guB1N59LjhQRfH2ixE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >=20
>=20> On Thu, 5 Feb 2026 13:30:12 +0800 Jiayuan Chen <> wrote:
> >=20=20
>=20>=20=20
>=20>  From: Jiayuan Chen <jiayuan.chen@shopee.com>
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
>=20>  As others also mentioned, the documentation of the new stat would =
be needed.
> >=20=20
>=20>=20=20
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
> >  MEMCG_NR_STAT,
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
> >  +{
> >  + return size =3D=3D PAGE_SIZE;
> >  +}
> >  +
> >=20=20
>=20>  No strong opinion, but I'm not really sure if the helper is needed=
, because it
> >  feels quite simple logic:
> >=20=20
>=20>  "If an object is compressed and the size is same to the original o=
ne, the
> >  object is incompressible."
> >=20=20
>=20>  I also feel the function name bit odd, given the type of the param=
eter. Based
> >  on the function name and the comment, I'd expect it to receive a zsw=
ap_entry
> >  object. I understand it is better to receive a size_t, to be called =
from
> >  obj_cgroup_[un]charge_zswap(), though. Even in the case, I think the=
 name can
> >  be better (e.g., zswap_compression_failed() or zswap_was_incompressi=
ble() ?),
> >  or at least the coment can be more kindly explain the fact that the =
parameter
> >  is the size of object after the compression attempt.
> >=20=20
>=20>  I vote to drop the helper.
> >=20
>=20The reason I introduced the helper is that the incompressible check n=
ow lives in two places:
>=20
>=20In zswap.c - for the global zswap_stored_incompressible_pages counter
> In memcontrol.c - for the per-memcg MEMCG_ZSWAP_INCOMP stat
>=20
>=20By extracting a shared helper, both modules use the same logic, which=
 helps with maintainability.
>=20
>=20That said, I'm fine with dropping the helper if preferred. I can add =
a comment in memcontrol.c
> explaining the logic. My only concern is that if the incompressible det=
ection logic in zswap
> ever changes, someone might forget to update the memcg accounting accor=
dingly.
>=20
>=20But perhaps that's an unlikely scenario.

Well, a selftest would be the right way to detect such a problem imo. Eve=
n if we need to have a customer definition for incompressible later, it s=
hould remain in zswap and we should pass it into memcg code.

For now, I think let's keep open-coding the PAGE_SIZE check.

