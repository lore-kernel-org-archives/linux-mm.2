Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49170ECD9BC
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89A46B0092; Thu,  5 Feb 2026 21:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37F96B0093; Thu,  5 Feb 2026 21:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A066B0096; Thu,  5 Feb 2026 21:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85FC26B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:54:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 082745A76C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:53:59 +0000 (UTC)
X-FDA: 84412512198.06.402112A
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 300261C000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:53:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YYh+RTqw;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770346437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kl9ABNqAlIP37pttYDfGhjd/d6eepItkd6PhmTOS3dg=;
	b=1DTwacbzI8zPAps/LJrCj+UiKd7wITB8O2MSiT/KfM/7/x54SLq8ePE0EE7o5H57SYxo1p
	IUT3KF4MHcu6E4oxctlR0kI+b48GYhjYiwPvYfy8NOiBen+D1J2jlKvR5JVdFgeAz7w9DB
	n+8O/fBOth+Huz/tP3Jh0mBj6cLcsM4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YYh+RTqw;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770346437; a=rsa-sha256;
	cv=none;
	b=1XXDvj2e2VxBoUp9BRLTKgg9hLJWw9MIJ4WuHB2+JP5UAXtk9HfwvhIt3vPcAyXa0qKfwx
	d/A14NFzS1cQFgq344YPpTNc7rD3wWXoDrfTGD2J2pK6lMyRKH7KIJpSWbbtj8EmKQJyDg
	5b7XeDNt/y7NJqG+KJAqMGEthxFD8YY=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770346434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kl9ABNqAlIP37pttYDfGhjd/d6eepItkd6PhmTOS3dg=;
	b=YYh+RTqwwONx2rQgKhQpqNIq8/TXI9Xlz9xZCA1xyELrT6+0RpTXYnmCeU/thQSURgvqL4
	PG7eqo5WflFalJGaR+lY14UjOtXHjOsYqL/B/VveREiAoh+1Dti+m3mdk+gTPCPWLwnoVq
	UKxX48kFYmh5suHUnGeLsGnAVL5hfo0=
Date: Fri, 06 Feb 2026 02:53:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <3179fa38027bdacdd38b4ef34b493bdb5ef7a19a@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Yosry Ahmed" <yosry.ahmed@linux.dev>, "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, linux-mm@kvack.org, "Jiayuan Chen"
 <jiayuan.chen@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Nick Terrell" <terrelln@fb.com>, "David 
 Sterba" <dsterba@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <b0b984be60ffa366929d363ec2b63f5c92187556@linux.dev>
References: <20260206022152.67992-1-sj@kernel.org>
 <b0b984be60ffa366929d363ec2b63f5c92187556@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 300261C000D
X-Stat-Signature: pf38q1tuihhfyuuje4yt5kb8ubih9fpn
X-Rspam-User: 
X-HE-Tag: 1770346436-80498
X-HE-Meta: U2FsdGVkX1+QpsiClmXrYvXniDGkFeoWPKZpJ9MjvYudSzXRu41g2elJZXRpN/ipeW5b5pKKbfFv3KHWZ2HSimpmXuPZ80iJDKMLMCGoT8htJufqDRBcTMC3DS0GdxlQnQabJpBrz0wS6vzZ1iqChiPnBlqbhrxWGRCAZUSJfDCSlrDSuN2C9ZszUt5vg68bkJpsgBEMySpRe9/qCgY2h02LpZ+AB3bCpT8F5QFUn3sFr7KJg5Ci0JtKi7YQIt8mgvKlcksbBtpYrVOpMp7MnlbzBgBNQq+KYbh66IipKJ3uaIh+E+KyEtYxwwfFTc83g8aRbKA7vJnLCy4x1hE8jTTYBjxkIJan5Jx/4E3+GQcXnoO+HanR2OcMkp8AR4G0MwHxsOTgQfkz3gd0nRTJqg7zwfpU6F7CUazUAznzu6hbTq64LbZBFK6NZZBK8SfGF2UvdRmZi3XfUmes5EBYp50WyKJmnWC2chXTI0xQjztGUjz6aoISYNALaA2S8plnvinUEV51yoHxkdzKTvVuHyVtWKZA2sHNlK704Wyk67uJDdTlTgQoflVIVw0syb1I5w4kQeQQOBQyzISkmAL0Ap+cYA0WQBp1zRUAElYtw/1vPxo6LOWeaHEhdMTvhSrU+hhR1zQRTVWZGBttI9KI37Cgd9v1faLXEW77SpQYWHkCaewom2NXT0DADkYefh8cAYVepyXgTe3RW5AYSa90eTY/Dh+eiNVqK3QYSr8QMinjf3GWaoyBa7hiucoexOhb9Fuk3WZLCfa09IhDbFYkPD3/dzG6k7mAi/2GBB99uOd7Z/lfRga8bK5Zp/qJsfmd6csat6zAF3WkRz/JKFmyCxrX8nDi47+jDznN1RxlvVEvBn14FFjJIgRInZ6AcinFEelHiQMIozb+xkKL7n1rfNzbE3TYDJACEZQ00av7GALOr+UMp5JqbfhCLJQKWCC5ntOfnOU+oMSynmaHQPh
 nnLW/vU4
 YX6Uom3CIyxTqDFlbPRouhPW7pwVbA/i+85cuL5+M33r3cuYKzOHjYmmie/r7jOobWJCCqTCfhE3rI0H81XtBqIYagPAizJMOkjpzkFRgiHemloJiayg12uEWUuu0Q8JEwz4GuKGwvXWSm0pwPNgpQBuwXJ+HNnw1e2nLhkipPgVA3JKKvd11kBHrJ4h/d5LtwOkQ8Hq0n6Zm044aV2ZV9CB0tOjQA4v+Dc0tTK81j7PwEdCsMJ1cL/+svl4uamJEwfd90QzgE65CIBLYeeNT4LaAVyqlRxqtuRLjVFNK5pCcgc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

February 6, 2026 at 10:33, "Yosry Ahmed" <yosry.ahmed@linux.dev mailto:yo=
sry.ahmed@linux.dev?to=3D%22Yosry%20Ahmed%22%20%3Cyosry.ahmed%40linux.dev=
%3E > wrote:


>=20
>=20>=20
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
> >=20
>=20I vote to drop the helper.
>

The reason I introduced the helper is that the incompressible check now l=
ives in two places:

In zswap.c - for the global zswap_stored_incompressible_pages counter
In memcontrol.c - for the per-memcg MEMCG_ZSWAP_INCOMP stat

By extracting a shared helper, both modules use the same logic, which hel=
ps with maintainability.

That said, I'm fine with dropping the helper if preferred. I can add a co=
mment in memcontrol.c
explaining the logic. My only concern is that if the incompressible detec=
tion logic in zswap
ever changes, someone might forget to update the memcg accounting accordi=
ngly.

But perhaps that's an unlikely scenario.

