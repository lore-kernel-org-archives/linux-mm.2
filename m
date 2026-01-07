Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5281CD585A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA676B0095; Wed,  7 Jan 2026 06:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1588C6B0099; Wed,  7 Jan 2026 06:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A156B009D; Wed,  7 Jan 2026 06:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5AE36B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:39:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83CE31402EA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:39:44 +0000 (UTC)
X-FDA: 84304973088.19.35B9FF1
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D08240007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:39:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rl4yebr1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785982; a=rsa-sha256;
	cv=none;
	b=h7pZ+utYB0UQQnZS1XQqpfEgq0rKe/3g7MwB2guKdV/QtNzQulw53XlGdtV4LuzOKTyXTv
	qm3jOKVSB5MftCGH3VzBotG6jb1H7EUCvehRllkb2fPwijDp9KQlIxdWjob3RKiK0dOxQK
	eSB7oVO4/Iu0XFirrgu3MsgiI0Fk144=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rl4yebr1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5I7EN12qa/zxPyxnS8OTAcJMh+jISKVq561o3m/BAgg=;
	b=e17o3XQjeCgD35F3rYL55TCqepERSrcO0eWUwWcuNawfeeqBED7l5pvuqpIYHubkEvOsuK
	vDzi1u1Yl3Ifki8tUaM1Ya+XoSB+6cIHRxP5XxlACtOXpUkYCzVrwRAbaQD7pw92HWwGBZ
	lph1aZ3BNu49SolpPwEX5uSxn9UUJ0U=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767785979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5I7EN12qa/zxPyxnS8OTAcJMh+jISKVq561o3m/BAgg=;
	b=Rl4yebr1thnCWcSva95GejrDoUuH5uZ5JcxY6WPrMyIJeNoIEhH73d1llS1Dy8GtKRSvl1
	5eybioGzbG6aRToz09tHR6FPtqrxhUYyx2eDf4Wrgrga1d/ezoGZwSlec6mpO11t61ypKS
	hjxLAgdovcJmJevjNnD8mqTYzONn1eU=
Date: Wed, 07 Jan 2026 11:39:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <61b4f3ba49016e68e8d6bfe6543150a7de0bac79@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Michal Hocko" <mhocko@suse.com>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <gxrh27cynibsmexsb6gahs2gd2wkicoiumzfyljbxt5mdleium@5rmx6bljxj3c>
References: <20251226080042.291657-1-jiayuan.chen@linux.dev>
 <gxrh27cynibsmexsb6gahs2gd2wkicoiumzfyljbxt5mdleium@5rmx6bljxj3c>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D08240007
X-Stat-Signature: wx563m74qfa9o5zx9pdgct55xmgsfc1d
X-Rspam-User: 
X-HE-Tag: 1767785982-868843
X-HE-Meta: U2FsdGVkX1+lyIKUJxk+QAoIr4sWiUgf0TmJdx8nCVcYK2ZCGL7hekSHUNM/rO6sdxA+XgdASJ1Z2vhs9MxG6eBgo3oNMCljzYLWmvt1fF/YA4tP6fS0T84h7i0oo/fc/P5qWJae9EBs//sLzXOcQQcPxX+480yN47moeDusqaTcozVBTlo7/K9WzohzqFHcaKG+aFBgFQUjIDTfgmm7dBaBFgK1g2zhSCRkceAR4qmumKtYjck7HlV3CUrP0AxgKL3Tx7aYTQ2i3IdowHy4zvlresvASZ/jwAZGhnVMCUt8NY/4Jxe2aymu0yR1xSavJFOzXSazEcv3YoKFfd6acp8vmhVsziKNXCUElz0pe7jkfKnfpxBQ3ECf6rPgckWe6N1T82XnEoYa0TmvpOUgnhJ7o04yVqNtE6ReHzWQ/qfeuimQ+4B7fR/vs48N1EW5DKf9Se2sT8M5rThQQyqGmedW6pwyTfaeFNgBDd0xMDw/hRkvQ+KYjPw3Fx2C58sgPQHLR1X20mpzJ0clhd3mtkD3KJ2+Piwy4b3JCkSzRJE5ORreb3vv56Ab3bIzCtCClUAvgGvoAqfuA2lBHJQ89AmSWRCJXuz+4ggCKC7+ktVJLW3Zk6fFlUHdCf6pXHO+ypGr039WhFuJXxCxy+gnLG1SQRF7TIzX1lCHNJ4YvE7X3TrgVBzYTu2pfkVUAn5VTNSA7ndpniVda542FI4WDDZeQi7fpjMs8SEc8Qcm3ILnNJ+hFvApF61E65Ufq5Sey8pfAMqdQC8xID4oA6LTrAPR0glqP1T2NyFs1KbWRYXoUTTzgAwCL0W/UjrAXW2sytUsQ1HlHNC+aXcjRCiC+VF2M28mff7QfkjWD+E0BaGq+UuVoL0RUpbI/cwogHKpyHMI0120w0lKtN5I5GXKKbQK9DtW9VhrVqKsjZEEkt+VUnc9+PJ8rdK/WEuIMDc4ZgBCVtsIgkxigj/gOY8
 9cwRGMoY
 VU5rzQc6BwpXiWTskyK508dDh+BzkieuVDyMmVp6/5T1LoMguPYp49FBwhdmUBfe3Vi7PIVlVrhGXNF68aT+4jBE7JaQ+P6x7SZLL2+QAWsajMoP4n0Ep7rO1XHP/RPCz6td+CxVPFs9owdhmjwjiD1ykkbl0tzsEVHhSN4/npUwrXZ3IwW+M7O+yGzhkuMvmmPuhoMo3jHF5OB2m7KuJpJ8E4PBF5lpAoKqlET5r3GXg1aV/9Eq6kYU/zru0EZEKHdG3wcb4BjZh274xB1B3Y5iRGmI/EOYDZyC8edmdbyBvGb4nHpUDSjuLFOmrtbpSQOwogifJVNyIv6gppsg9j9POuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 7, 2026 at 06:06, "Shakeel Butt" <shakeel.butt@linux.dev mailto:s=
hakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux=
.dev%3E > wrote:


>=20
>=20On Fri, Dec 26, 2025 at 04:00:42PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20=20
>=20>  This is v2 of this patch series. For v1, see [1].
> >=20=20
>=20>  When kswapd fails to reclaim memory, kswapd_failures is incremente=
d.
> >  Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
> >  futile reclaim attempts. However, any successful direct reclaim
> >  unconditionally resets kswapd_failures to 0, which can cause problem=
s.
> >=20=20
>=20>  We observed an issue in production on a multi-NUMA system where a
> >  process allocated large amounts of anonymous pages on a single NUMA
> >  node, causing its watermark to drop below high and evicting most fil=
e
> >  pages:
> >=20=20
>=20>  $ numastat -m
> >  Per-node system memory usage (in MBs):
> >  Node 0 Node 1 Total
> >  --------------- --------------- ---------------
> >  MemTotal 128222.19 127983.91 256206.11
> >  MemFree 1414.48 1432.80 2847.29
> >  MemUsed 126807.71 126551.11 252358.82
> >  SwapCached 0.00 0.00 0.00
> >  Active 29017.91 25554.57 54572.48
> >  Inactive 92749.06 95377.00 188126.06
> >  Active(anon) 28998.96 23356.47 52355.43
> >  Inactive(anon) 92685.27 87466.11 180151.39
> >  Active(file) 18.95 2198.10 2217.05
> >  Inactive(file) 63.79 7910.89 7974.68
> >=20=20
>=20>  With swap disabled, only file pages can be reclaimed. When kswapd =
is
> >  woken (e.g., via wake_all_kswapds()), it runs continuously but canno=
t
> >  raise free memory above the high watermark since reclaimable file pa=
ges
> >  are insufficient. Normally, kswapd would eventually stop after
> >  kswapd_failures reaches MAX_RECLAIM_RETRIES.
> >=20=20
>=20>  However, containers on this machine have memory.high set in their
> >  cgroup. Business processes continuously trigger the high limit, caus=
ing
> >  frequent direct reclaim that keeps resetting kswapd_failures to 0. T=
his
> >  prevents kswapd from ever stopping.
> >=20=20
>=20>  The key insight is that direct reclaim triggered by cgroup memory.=
high
> >  performs aggressive scanning to throttle the allocating process. Wit=
h
> >  sufficiently aggressive scanning, even hot pages will eventually be
> >  reclaimed, making direct reclaim "successful" at freeing some memory=
.
> >  However, this success does not mean the node has reached a balanced
> >  state - the freed memory may still be insufficient to bring free pag=
es
> >  above the high watermark. Unconditionally resetting kswapd_failures =
in
> >  this case keeps kswapd alive indefinitely.
> >=20=20
>=20>  The result is that kswapd runs endlessly. Unlike direct reclaim wh=
ich
> >  only reclaims from the allocating cgroup, kswapd scans the entire no=
de's
> >  memory. This causes hot file pages from all workloads on the node to=
 be
> >  evicted, not just those from the cgroup triggering memory.high. Thes=
e
> >  pages constantly refault, generating sustained heavy IO READ pressur=
e
> >  across the entire system.
> >=20=20
>=20>  Fix this by only resetting kswapd_failures when the node is actual=
ly
> >  balanced. This allows both kswapd and direct reclaim to clear
> >  kswapd_failures upon successful reclaim, but only when the reclaim
> >  actually resolves the memory pressure (i.e., the node becomes balanc=
ed).
> >=20=20
>=20>  [1] https://lore.kernel.org/all/20251222122022.254268-1-jiayuan.ch=
en@linux.dev/
> >  Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20
>=20Hi Jiayuan, can you please send v3 of this patch with the following
> additional information:
>=20
>=201. Impact of the patch on your production jobs i.e. does it really
> solves the issue?
>=20
>=202. Memory reclaim stats or cpu usage of kswapd with and without patch=
.
>=20
>=20thanks,
> Shakeel
>


Hi Shakeel,

Thanks for the feedback.

To be honest, the issue is difficult to reproduce because the boundary co=
nditions are quite complex.
We also haven't deployed this patch in production yet. I discovered the r=
elationship between
kswapd_failures and direct reclaim through the following bpftrace script:

'''bash

bpftrace -e '
#include <linux/mmzone.h>
#include <linux/shrinker.h>
kprobe:balance_pgdat {
	$pgdat =3D (struct pglist_data *)arg0;
	if ($pgdat->kswapd_failures > 0) {
		printf("[node %d] [%lu] kswapd end, kswapd_failures %d\n", $pgdat->node=
_id, jiffies, $pgdat->kswapd_failures);
	}
}
tracepoint:vmscan:mm_vmscan_direct_reclaim_end {
	printf("[cpu %d] [%ul] reset kswapd_failures %d \n", cpu, jiffies, args.=
nr_reclaimed)
}
'

'''

The trace results showed that when kswapd_failures reaches 15, continuous=
 direct reclaim keeps
resetting it to 0. This was accompanied by a flood of kswapd_failures log=
 entries, and shortly
after, we observed massive refaults occurring.
(Note that I can only observe up to 15 in the trace due to a kprobe limit=
ation:
the kprobe on balance_pgdat fires at function entry, but kswapd_failures =
is incremented to 16 only
when balance_pgdat fails to reclaim any pages - at which point kswapd goe=
s to sleep and there's no
suitable hook point to capture it.)


Before I send v3, I'd like to continue the discussion to make sure we're =
aligned on the approach:

    Do you think the bpftrace evidence above is sufficient?


If you and Michal are okay with the current approach, I'll prepare v3 wit=
h mote detailed comments addressed.

By the way, this tracing limitation makes me wonder: would it be appropri=
ate to add two tracepoints for
kswapd_failures? One for when kswapd_failures reaches MAX_RECLAIM_RETRIES=
 (16), and another for when it
gets reset to 0. Currently, the only way to detect this is by polling nod=
e_unreclaimable from /proc/zoneinfo,
but the sampling interval is usually too coarse to catch these events.

Thanks

