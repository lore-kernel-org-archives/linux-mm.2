Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7FF4ECD9B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15ABD6B008A; Thu,  5 Feb 2026 21:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C306B0092; Thu,  5 Feb 2026 21:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066006B0093; Thu,  5 Feb 2026 21:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E81356B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:34:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9134C16076F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:34:10 +0000 (UTC)
X-FDA: 84412462260.12.A6C7E21
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 992DA1C000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:34:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uc4tZYfg;
	spf=pass (imf18.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770345248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfSoJqHnivlDlIr4yD3u1C63GloDhp3Ya4gt8AF33eo=;
	b=MwZVmipLXQtGPOmG5tOEblMNw05tb22HHh4+/wd0uIZ8uW//fCZ0/YU6A2rtc+bf3TmVg7
	wATjx4fcExKvjXVmORPDRXDk1zdwtW5McdT/J6dQjIxltWnBv+gGnR9E4wxLX/EgvWJs3k
	DxxVWWjZzocBomnyucXealtcIcuxZ+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770345248; a=rsa-sha256;
	cv=none;
	b=zqKOILE4cxOvy4vdNJXm29yzy9HaXMVdTtuQBriuWLWnFRX+v+haHhOyr/O14DOVcpDDFR
	xs5TQQtlCR0eolZ5pwClWnaaEDbAngiqQaYloxEbGqt8TJrfkOqt9yz6BFNH2fPfP5m14r
	E75re5c7llyum4fhrHlTQrzj6wz7HEE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uc4tZYfg;
	spf=pass (imf18.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770345240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nfSoJqHnivlDlIr4yD3u1C63GloDhp3Ya4gt8AF33eo=;
	b=uc4tZYfgXOFC9nl3sMdCd8ww5lBF9as+h8Tr/TPvCORF5ZGC9gnanhVyAnGYvKEtbaUJ6e
	e0qEDmu+YBBQDstR3JTGS+89oEObfLj4NJirsCcaKqe4SYWihr0bxHxy83dWlZyrCt+qnC
	ml5vU7D6qSV1SsfRrE8y4cV3V9Qhb7Y=
Date: Fri, 06 Feb 2026 02:33:56 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <b0b984be60ffa366929d363ec2b63f5c92187556@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "SeongJae Park" <sj@kernel.org>, "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: "SeongJae Park" <sj@kernel.org>, linux-mm@kvack.org, "Jiayuan Chen"
 <jiayuan.chen@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Nick Terrell" <terrelln@fb.com>, "David
 Sterba" <dsterba@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <20260206022152.67992-1-sj@kernel.org>
References: <20260206022152.67992-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 992DA1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1qgy4ccnrbsemr3apc6zdbzrgmhsrcbf
X-HE-Tag: 1770345244-256194
X-HE-Meta: U2FsdGVkX19e95RaqEGzS9V9fJ1riDCka3aBYQ8hvdY1nPhMoucd93MZztD1mu1VSy+1E03QlfgEEHdBSlrMcQurKTOnOWs17qXijMEpk8z+OhXEaHLgxlUkcUIMHp2JPV0v0RyCVudvwIjKf/2CKuWIh9Cuk4/gZWlpO8XHBP7tDqagVItejpBkFIOd+W00WQRxQzRFSavxaJIaav5/+dCzaHhN+xVJSKCe6wWRedqqCXaDrqWfD1p22xMkwE+E+2Lui2m8Dqe6t4F9vyxncGgGCX42L3s/w//cI88NYaT+zPhct1pg3QSdIEt1poKnzAnqmzoSfkFbma9ahHF7Fvz3J9+tkSIX88YX4Cs5DgFnaBjeYTvAjV2APbP2FOdyYk4CkAUGY3XdlS8lDo82N8HHGlyVPofqgh6l7agdnYke8WY5Q4BghWWQQjl0Rrz14Oea1eSP9/ziUjLcnsfxOhxCIYKoN+pzd0rARyqXE3UlsTBMHSFWm2gJHLXNE0NISWtXTYJofi6tzWX4ORt2GnR6CUAumkJW1GnsgpVUdnj3ShLhw35jiBCDked9Uc56Yh6TsI+CxIuZ+WYU/LOsxVX+3EUAY3qJkB5vbnkAV9BOSE1rPi/czeILcQcWtaoUpzCNEfHZN1j40crLTrtYg7QrFvgz3xzujV6cNj5TCD+j8wSwdVrLjhsGbCY23AdJdepHv9rvOBBpnThSR5ePVW0dEQcNBHhtBJedMrRdXr/fSItqEjqDNIU0pKvlSuilAldQVVlsxiSeHFS/oLSu0p+XNKdzPhkP6bPTpP6R1fkFO4u9T0Za/tGZ013gaTd1QB+ZoSPEaXiv9WxHFKzk1onQComlaMXiOadXMccKtoKyO5/JHa13YIq7WlMk3pWGkp7/z9pvBHjLevC4tHriLsDnu6nsUaciQdTNmFW2C1kF5IG/4szPYurcOak2B2i0jaAwlOPlIJyk7j9Yu8n
 GMaW5GrZ
 xGUEatGTTfZ0sK+aoGzho9G3nK0V1UhGC9Vb7x3kNVEtDnJdXEUglFrLcUJon1rf2At0RHK0l+3kRG0BIty3likzbfx9xk/dX7f/aZPi1s0cnbR20HMGlQbO8BgtxFtZTKkwT80EKgJnIjVfdt3bPpwE35ETL8h3Jw3jHAph7NId8NrlqY7sRrs4JgdWd5FKz3kMOiPzsW13mmFhROWTe5q9d8ZMtsGFFYBsA31n3MpA1wNFPN6Z2pBGzCEe6iJ2WLmDJfVxeP1Hqe9bt/zjwyJtaKSOr+a/+TS/XvOND/rc1Fw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Thu, 5 Feb 2026 13:30:12 +0800 Jiayuan Chen <> wrote:
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
> >=20
>=20As others also mentioned, the documentation of the new stat would be =
needed.
>=20
>=20>=20
>=20> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.=
h
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
> >=20
>=20No strong opinion, but I'm not really sure if the helper is needed, b=
ecause it
> feels quite simple logic:
>=20
>=20 "If an object is compressed and the size is same to the original one=
, the
>  object is incompressible."
>=20
>=20I also feel the function name bit odd, given the type of the paramete=
r. Based
> on the function name and the comment, I'd expect it to receive a zswap_=
entry
> object. I understand it is better to receive a size_t, to be called fro=
m
> obj_cgroup_[un]charge_zswap(), though. Even in the case, I think the na=
me can
> be better (e.g., zswap_compression_failed() or zswap_was_incompressible=
() ?),
> or at least the coment can be more kindly explain the fact that the par=
ameter
> is the size of object after the compression attempt.

I vote to drop the helper.

