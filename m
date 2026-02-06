Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1B1ECD99D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A589E6B0092; Thu,  5 Feb 2026 21:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A026B6B0093; Thu,  5 Feb 2026 21:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FAE6B0096; Thu,  5 Feb 2026 21:04:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81D216B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:04:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 210AF13B5E2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:04:57 +0000 (UTC)
X-FDA: 84412388634.14.5477179
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4237D180005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:04:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlAE56nq;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770343495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHhqE0rOIIDTJy2nyKWhxSadph1tZYrS67Y+CtxUbZs=;
	b=LRvx3EgRsX9+IO3vbgfq2K+R6eZf8/zAT4Wg81Ec7B6fiyOFHqm1KcT8ZUp+0XUsRShLED
	sCqJaNyQBjdNzEy/SiW3+fYSFYCLyiQjObqZuHVXXu74moWcax9h3FdBuGeDxcYTJ2X1ib
	EgVR7KNXuChY7QLPCUOm6gZbqWH9/wk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlAE56nq;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770343495; a=rsa-sha256;
	cv=none;
	b=SRoyw0FPJODw7f1BGia7Za9qKARx9Cljr0Sh0P75hanDw/UQuCt2uBjZ6AR11MPq2DmlCM
	Du5blcM9/FyYQ812+yua7blZ2nAjL3LkGA4qTId/SaPPvYsaSN64ZOPKGYiJU4Ipq6OyGB
	VpRkoPZGu7BChBZJCLAwG0fR/aR2oPQ=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770343493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KHhqE0rOIIDTJy2nyKWhxSadph1tZYrS67Y+CtxUbZs=;
	b=jlAE56nqDyr8ycjmwzpiymb4QVVFR6bSgAp9gD80ZSI1/ne0mOItgHiXX5u48ZNylqneq3
	wbEYS5W6Lr3y0iMe76oN5s0Q5MlCqxFlXefLDnVBOPVb5OsSWGgW0AzRM5Sh2UmxzxlgIS
	PA1o5Yktbs+orOSpBF6lcDNKd507PKg=
Date: Fri, 06 Feb 2026 02:04:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <b9f07aca60c49a85a52c4eab4ed271ad29e04b5e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Nhat
 Pham" <nphamcs@gmail.com>, "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Nick Terrell"
 <terrelln@fb.com>, "David Sterba" <dsterba@suse.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <aYUKpZ8nCB6MTQGY@linux.dev>
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
 <aYUKpZ8nCB6MTQGY@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4237D180005
X-Stat-Signature: h4j6jibpash9rg36x8s3k69737sxpb6o
X-Rspam-User: 
X-HE-Tag: 1770343495-806847
X-HE-Meta: U2FsdGVkX1/T1DbcLICA3bUwbNj9KkiEp0tcopLYDheXuOPbsFq6ZOMcx76oWaFReX8BSkv6KO6Hh3ayCB1JQb9dabV4O7eVmeTY3EDNWZMnnUcX3mlPyzbubEcvtRloyMP24jF1kyN+pPBfvdtsDTaJmti1Jzzj3oB2NSBuoaOjevkFe8dy8m4eflz5fhytDoPdpBiVtSFUihFg/ez0BTqi4NS8dkA5iPJA+lTCwZagtIKkXkDsN4ZUql034XxaabhytUPqFRqom3MQKkbyMPuAKECJMMB0fZmgbMnTFqjTnnp+JHbb/HYAN1SrYwZ68gJx7Xf3Qga4yBwVEtwlpH5IxCHZTaHYIP29LsoQ/TETz36glTfCxuvK6ISQ6S7ePq09YFwoSjbb1S7FQxp8a+K+MvcMhOquG0oOc7B9v+UVwEMGfu4KF5CZ/50yosC2RRPGzeGDzlEjvaAR8bPJ9LmqPRv0zlsCSQrQREdJcdGeXgkmRLQUjBiD6RtVovIIx6XoibI5tR4Pbnx/vpCx/0G7tSLkcSsTelW8sUl5VnAcA5D9kJqU5QZBqGeu/7T1f1pVUG0mx2Qzuxp4n4INDhiuyi+q1CQKJ4VKR54RbaUVjzFR1GzASQ2S4bHt/emUJjpCQMpiJjYxTfmZUZFXY1yoKnwwY2MEIHZKD545yg8G+97oxKNu0JD/jNgGEhnjT16G03B59u5m2GrsbEvw/oyTu2ci3qDfBdmc1Wk5uPh8BM+qsBsL4N+Crpt1Jj/T53NUL5khTRYxrTYsPM6DY90e9no7v2yJIYH+IMPrN0PnExfl3YsSjLxOqOvXk67HdB+6xZgGp8AXVY2WmVmRWkKC0GcUIu+KxBpHTzDE5L1FxnH3Lg+VgegjxJr7w4KawMnGbc1KXoteLQ5BriQBMMN+BLh1gzoTpbMlJXgXzFCuZN7dJoq4gSbzBT6li/dvZ5CoS+du1fNnIkVqly6
 GKJcA6Md
 CyRulOZxVbAUtjylQE7Kk6LUCFYVbraxX6UFfvrzwTJ6d+Z3iEITpn4ZI9Osk40GWPW13efTo7eGNGgoLgCDQ9nxH8CXxsceyZaoCWu938bgoiAAEyOgkkWDef9yLCR080E2zliyeC1+ecKQbxfXDQ70USNv46xFdQZ5OC3JeNYtP4L+1WdLMLuPJB9UfHmZDZbYNMdpHM4eLx/v/USxBWkJ2UPLOaZNuk88qVo99le3SnhI7L2F6YGQXrKJFY7Qv0VCWaQeGfVWiU5Drc1LKzNeeFKeW89pqRiPMTgo5GdEkqfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

February 6, 2026 at 05:33, "Shakeel Butt" <shakeel.butt@linux.dev mailto:=
shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linu=
x.dev%3E > wrote:


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
> >=20
>=20Overall looks good but as Nhat suggested please update v2
> documentation.
>=20
>=20>=20
>=20> ---
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
>=20Hmm I don't like the name though. How about INCOMPRESSIBLE or INCOMP =
for
> short?
>

Thanks Shakeel! I'll rename it to INCOMP and update the documentation in =
v2.

