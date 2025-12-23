Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC31E6B26B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137766B0088; Mon, 22 Dec 2025 20:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2636B008C; Mon, 22 Dec 2025 20:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010446B0092; Mon, 22 Dec 2025 20:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E00F36B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:42:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79C7AC07E5
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:42:44 +0000 (UTC)
X-FDA: 84249036648.21.A3BF317
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id C531B120012
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:42:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w02fKMEg;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766454163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B1SayI7EOFNqfNNBovUlQHi7a1s5Gt80AtJSL6qhUA=;
	b=zPPeZPdICLSVbtgK9z3lQ9r/jqWEgvx7+It67ykEmkYqoiojuHljcyqiFT/RmICoxCB483
	Sv+AXaTPj6ih2bg0OkihY+CQwpsTPF3k9P+gJ4fcSyO4SkBlz050ZTsImeUpD+pBlExYaa
	0TD2MLmpwjm/jdIGyHx89FQHjcbUgJA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w02fKMEg;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766454163; a=rsa-sha256;
	cv=none;
	b=vuLff7hnuRBSlVQWV5SKO5iFPqgzdwa6w2NsGm4+2GC/ECfKmqcEim+PbNrfNu2fytlm7Q
	EO0n6FouIXPHHNf+rLLRh1MY6WZTayOc91CDePuAfHCPmM7IFfhLWzHAMifXJBMKqsDQaj
	xzGFjQ/y7mDjzm+MKVe7eCBT5MK/2FE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766454160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7B1SayI7EOFNqfNNBovUlQHi7a1s5Gt80AtJSL6qhUA=;
	b=w02fKMEgNlPSc0I+5B5j6Us0z/FVgqCCPvfIPcPJGbnkCDeWj+f7xgPYEwIAB9O8s0V9Ea
	7hTsmMYmoc0yNDL+cYeS8N5Q2zdIKw2gSMNgxzKgYxYV8h/XotN8Nry9URpzDwfUFjVdOg
	pHIiCDGTzShifEIuMeyIUlDNBFyD2OI=
Date: Tue, 23 Dec 2025 01:42:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C531B120012
X-Stat-Signature: sfnus67uedjb9jieybo6h98i45mpmy4o
X-Rspam-User: 
X-HE-Tag: 1766454162-330320
X-HE-Meta: U2FsdGVkX186VhgG/ZuZUwoYyFhJmVHECLS5pGO/EaC5nOX1mK+lldIZm4NdWvelJGNvdv8y4gm5NLCIOIbsetLCMhgp4+4PtmwerwGlD0JwyVZpXI5p9UnsBaMQyu6UtQUqIhXgemwl7epBHnNO15dBWE/wQsgGvPFcferTGpdAokoYl78uMgmqG6hDF5XOcVhcdTnKOxi8jui93tN43M5FBOZmz76jmsbnZZviAw8srZlYm1jv9CcSq9UqeWjkUIH+S3rSssbnILpa782UdIudlENWnf+XgX5KODaCtz4C75wgLHpCDRUEUxdMSLU59vrjUiL1JllL68JIslX5fAmMorJoWR2vdRZPZwKlepppayH1Bz+qtRewGhUyv7qVsRvfQ8CBVWs5PWBdpcMTLsMikAKyBzftmsm9h8kCbdOubD88O4Wgj33DkDq37okTcM7hw0xKqq8zOKIpz7/8j5aesXqdaRMCRUk4TCIm/84Kq2AD2NpuTK+GxMEcRzAzQBB3pcW+C5KsqVmpQ8ymPkoWkhUt5yG2jEq1Or8HfNKeFhFLoRzxLn2WuePKIEuV8h4pLtE6PXRPtKodWHeu7jlNxMPAPuaXAPcYuQCV6EWqkpslT3VYVRUuMue45HsvpNc2df40ExgJTIP5AWQCe9WxIu/z6mG3vfCi3soKs3oOhWbM2/sSAyQ5nu2alXqc1HGvZgEcNLmJs3gxGywWFXX4I+aUwIGnLnqSbsWg0LL1GO+T8/yuYyASdGQa08dx4yjh+tkm6UcrEq67Qoa7pBu+paJNcqlJmu+fYxrFZZYRi4imSSgn99pJ10Uv/XK9gHFkJAH6DbUTz0crqN42m+MXrlg7+GtoQ+cjGtWx0oWKS8/jwEgGG/bgw6cAW+je087HaTNeQ2LthWpOCUmZ3hULtYEzIJl0qYGRS1lg/YY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 23, 2025 at 05:15, "Shakeel Butt" <shakeel.butt@linux.dev mailto=
:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40lin=
ux.dev%3E > wrote:


>=20
>=20On Mon, Dec 22, 2025 at 08:20:21PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> From: Jiayuan Chen <jiayuan.chen@shopee.com>
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
>=20>  However, pods on this machine have memory.high set in their cgroup=
.
> >  Business processes continuously trigger the high limit, causing freq=
uent
> >  direct reclaim that keeps resetting kswapd_failures to 0. This preve=
nts
> >  kswapd from ever stopping.
> >=20=20
>=20>  The result is that kswapd runs endlessly, repeatedly evicting the =
few
> >  remaining file pages which are actually hot. These pages constantly
> >  refault, generating sustained heavy IO READ pressure.
> >=20
>=20I don't think kswapd is an issue here. The system is out of memory an=
d
> most of the memory is unreclaimable. Either change the workload to use
> less memory or enable swap (or zswap) to have more reclaimable memory.


Hi,
Thanks for looking into this.

Sorry, I didn't describe the scenario clearly enough in the original patc=
h. Let me clarify:

This is a multi-NUMA system where the memory pressure is not global but n=
ode-local. The key observation is:

Node 0: Under memory pressure, most memory is anonymous (unreclaimable wi=
thout swap)
Node 1: Has plenty of reclaimable memory (~60GB file cache out of 125GB t=
otal)

Node 0's kswapd runs continuously but cannot reclaim anything
Direct reclaim succeeds by reclaiming from Node 1
Direct reclaim resets kswapd_failures, preventing Node 0's kswapd from st=
opping
The few file pages on Node 0 are hot and keep refaulting, causing heavy I=
/O

From a per-node perspective, Node 0 is truly out of reclaimable memory an=
d its kswapd
should stop. But the global direct reclaim success (from Node 1) incorrec=
tly keeps
Node 0's kswapd alive.


Thanks.

> Other than that we can discuss memcg reclaim resetting the kswapd
> failure count should be changed or not but that is a separate
> discussion.
>

