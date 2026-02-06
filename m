Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34E6E9129F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BE76B008A; Thu,  5 Feb 2026 23:11:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D726B0092; Thu,  5 Feb 2026 23:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF19B6B0093; Thu,  5 Feb 2026 23:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5816B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:11:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFC801C613
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:11:19 +0000 (UTC)
X-FDA: 84412707078.17.038D5D7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB87E20010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:11:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAYmCD3c;
	spf=pass (imf03.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770351078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4OW4s3gaXFmm9q/2xsnJJrtYlj7SsdGtTDJwGZIMW4=;
	b=FhuJ9sdgtHNDG69x1WTMJUmAljs2xbrunSq4QYQvP+JxbxAp4vSKn7EWJrRO+yjp65hPkx
	7Ux7lOWoCdiSENZcXXadS8TjSCNED8LO5nCP9T6lhiyo2ckWCEjwU6nd2KKo5aBeWnbu0p
	SneOCUdAAzcDne6kEaK1FswscHpY4Kc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAYmCD3c;
	spf=pass (imf03.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770351078; a=rsa-sha256;
	cv=none;
	b=ILyGNJf8g9HkxAiCWXYt/k1kpnhQhkbJoa45eG8ziKF2q7Vj/YeZrF5b7K9pt7vDr8sNyI
	dhFPpSUlCX7P2RupYMRDRpRBdihfAwA4qGY9I272ueQCJRYUj7+Y9a4OlTQ7iFTdFPH+rn
	5q2QM6iaoi0ZF47eJ2bR2hQXdHmdI5E=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770351075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D4OW4s3gaXFmm9q/2xsnJJrtYlj7SsdGtTDJwGZIMW4=;
	b=SAYmCD3ck4yK/hM3itvbD9mKLpxMrdxT7KMxmCG+XVOUfQqmmfWUuy/3IXH3+BGCaiBm+V
	WhkktKZ4S+fh8PHguT3q0WI69nVlHNFCW7haNtCqkmqAeLIkqzScx/ZKjhGsArRtZ0iwcR
	ujfDG5W9eyXs/3fFOA+Q6sXz8kDiFTE=
Date: Fri, 06 Feb 2026 04:11:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <75c6f71f794c04e6c6fc90e6ac0a3d4656651362@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>, "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, linux-mm@kvack.org, "Jiayuan Chen"
 <jiayuan.chen@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 "Chengming  Zhou" <chengming.zhou@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Nick Terrell" <terrelln@fb.com>, "David 
 Sterba" <dsterba@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <e155ad8af874f10baaed91f1d12fde222b82036b@linux.dev>
References: <20260206022152.67992-1-sj@kernel.org>
 <e155ad8af874f10baaed91f1d12fde222b82036b@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB87E20010
X-Stat-Signature: j8759ddaft9r4ak8p8jt1m59nndfo1z3
X-Rspam-User: 
X-HE-Tag: 1770351077-228467
X-HE-Meta: U2FsdGVkX18ZtMnihYDts0Mi8JRAJFfqRAKQVk50ctst3xXPzQKPXzvoqlB3A9WfvN1RgnhqYf49LWGbsaFJRLIDyteCqsqdxMsUiqMZhFhwb4rTkAppzXl2+sCCc1Y0yqMCTosn/0wQMIXFKNN28+G6Gq4/4uZyuqA2pGGO7GdsfQruywt2seHrOdlxTjz0vQE3xA6MZ1/RhgjJYfCLyWNcDM8xgk7A90UihLl4E+AO8XCyhosvSdvnojEZiNh2NzWcpNlXkjX5CSxTlcw8VGQuBk8x3BN0qBBC3vsOiZjw9UZ8tlJ5a776B1rlBuMIb4K6WDU8XiaxYDA8bWv7toVbsRoRkitCtgYxr4/AB1rUt76x934/hVDOJjBfHXNWDiiQajydn4ieAu0P4kpsiKa3A67HE8nktAazXul4xG3XlCVPMzk7dikLb/FklQ/Xg7bzZ5chbx7HcH78nycdis+aDRfYqwTxs7fd9EAIBBNrO+iYg9+9tyJF2S7zPUJp+0rmKTqeE69nLGe+vrBcFxUkHCcD+DQe0G1rsPT8sO2hExoQbX2W2/9kQ97+CYV8XaFv6PmlWxLkEA5YrEHGZ0tvJfT1C5wwWmpuggyxG6phrnybDT5mn1/62rnbxSkUSLh8fGp5f0a9OGgxiclu16516jBYLEJgYStC7d2j5OnrAxYQpB2itbLZC+y9ThjnJSMK1HessUmsDlIrsKEuq5TdvHw3cqZYk4i+Z8kXkxqcC2tq1sXtS2B0oKFIaLcht1Fip0BuT8fZZjF//AlPN/92k2CThRHbxmXnPpNhw/PABA9Bg1m889hX+eewbO+JXI6bzI2LID4F2mhhCUwqf9SOyAch7Xvzkf/nR6yOclCgNlsAU1cobsEaM69ALoD8LnuFZx68Ms0mcz35bts9nNX2MDZAm2hRRoXDwIK4BxR3aS2X0rse6dXz+fGxPNKbgDRrpUwQ/oYwZMSQnEV
 RTMKEPF6
 u87ChoeuCEax14dHVS+RT06kQwY218jZCXVeEs2Pufx7xVGESpEuHDj0vmH4yljcwOqxY0PJIJ1MVsCMiWkxWZgFfYWnNaCmKz/dgnS77vSQQjQ/9V3n0kHkhDSkpuieOTA98MzpwlcTqQxL/UMlu9icvioptrHbKcOu9c4LLrQW62lGkXdXI132zO/ClKU5cV1PJUdRCbWimZUTAbC1biR9NwfV66FddmVJL7yczif6plsjzXTfe1lFFySfBcbjHFHkskIiW7u7xmj9s10YugztNRclJ1NH7giobSnh4lLuoBBg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Feb 2026 13:30:12 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> w=
rote:
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
>=20>=20=20
>=20>  extern atomic_long_t zswap_stored_pages;
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
>=20>  No strong opinion, but I think Shakeel's suggestion of other names=
 is
> >  reasonable.
> >=20=20
>=20>=20=20
>=20>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> >  @@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[]=
 =3D {
> >  #ifdef CONFIG_ZSWAP
> >  { "zswap", MEMCG_ZSWAP_B },
> >  { "zswapped", MEMCG_ZSWAPPED },
> >  + { "zswpraw", MEMCG_ZSWAP_RAW },
> >=20=20
>=20>  Ditto.
> >=20=20
>=20>=20=20
>=20>  #endif
> >  { "file_mapped", NR_FILE_MAPPED },
> >  { "file_dirty", NR_FILE_DIRTY },
> >  @@ -5458,6 +5460,8 @@ void obj_cgroup_charge_zswap(struct obj_cgroup=
 *objcg, size_t size)
> >  memcg =3D obj_cgroup_memcg(objcg);
> >  mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> >  mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> >  + if (zswap_is_raw(size))
> >  + mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, 1);
> >=20=20
>=20>  I understand the helper function is better to receive size_t rathe=
r than
> >  zswap_entry for this.
> >=20=20
>=20>=20=20
>=20>  rcu_read_unlock();
> >  }
> >=20=20
>=20>  @@ -5481,6 +5485,8 @@ void obj_cgroup_uncharge_zswap(struct obj_cg=
roup *objcg, size_t size)
> >  memcg =3D obj_cgroup_memcg(objcg);
> >  mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
> >  mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
> >  + if (zswap_is_raw(size))
> >  + mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, -1);
> >  rcu_read_unlock();
> >  }
> >=20=20
>=20>  diff --git a/mm/zswap.c b/mm/zswap.c
> >  index 3d2d59ac3f9c..54ab4d126f64 100644
> >  --- a/mm/zswap.c
> >  +++ b/mm/zswap.c
> >  @@ -723,7 +723,7 @@ static void zswap_entry_free(struct zswap_entry =
*entry)
> >  obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
> >  obj_cgroup_put(entry->objcg);
> >  }
> >  - if (entry->length =3D=3D PAGE_SIZE)
> >  + if (zswap_is_raw(entry->length))
> >  atomic_long_dec(&zswap_stored_incompressible_pages);
> >  zswap_entry_cache_free(entry);
> >  atomic_long_dec(&zswap_stored_pages);
> >  @@ -941,7 +941,7 @@ static bool zswap_decompress(struct zswap_entry =
*entry, struct folio *folio)
> >  zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->len=
gth);
> >=20=20
>=20>  /* zswap entries of length PAGE_SIZE are not compressed. */
> >  - if (entry->length =3D=3D PAGE_SIZE) {
> >  + if (zswap_is_raw(entry->length)) {
> >  WARN_ON_ONCE(input->length !=3D PAGE_SIZE);
> >  memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
> >  dlen =3D PAGE_SIZE;
> >=20=20
>=20>  Below this part, I show 'dlen =3D=3D PAGE_SIZE'. Should it also be=
 converted to
> >  use the helper function?
> >=20
>=20The dlen variable represents the decompressed (plaintext) size.
> Since we compress individual pages, the decompressed output should
> always be PAGE_SIZE in normal cases.
>=20
>=20This check validates whether decompression produced the expected resu=
lt, not whether the entry is incompressible.
>=20
>=20Using zswap_is_incomp() here would be semantically incorrect - the he=
lper is meant to check if an
> entry was stored without compression (i.e., compression failed to reduc=
e size), while dlen =3D=3D PAGE_SIZE
> verifies the output of decompression is valid.


This confusion is exactly why we should drop the helper.

