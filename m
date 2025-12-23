Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA60E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3A96B0088; Mon, 22 Dec 2025 20:51:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60D96B0089; Mon, 22 Dec 2025 20:51:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942A36B008A; Mon, 22 Dec 2025 20:51:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 826376B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:51:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F140A1A048F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:51:44 +0000 (UTC)
X-FDA: 84249059328.24.C8793A2
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 280391A000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:51:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ky3qDIlv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766454703; a=rsa-sha256;
	cv=none;
	b=Ckzgc+eSbd6/OxFdXqqiA43+u6+oLI4PKRG+tZABpQzeXcPwPybheINyXBM+J7OPOVwrKp
	xdPZUhwpt8xmXOfvrHWU1QO5NyDVrwqPObPdGa2FBat9xkrM9bM8CAYaRkhpIiesqve3YV
	F1t82FlWCgnr9OVwa+oAvH5VbTkXPLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ky3qDIlv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766454703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wl3U3hLdHF75YtYLGaCWAXC8/VXvB6nqMBrU2bvubf0=;
	b=xT18b7hxepEe10oqSbIA37uc27xBLMRwg5RiHfDXqHgql4owRbSkujJPS/zk96EVLoWWzv
	FDCgjs9MZfsfEK9gFsOU8ZfSQqVgwpZJKx/F14+ROCG7TaDnzGOCPJyw2TqPM9UAzNY6Aa
	vN5fOuHNwcnSgsJpD/2X8V4TDIWSqYk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766454699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl3U3hLdHF75YtYLGaCWAXC8/VXvB6nqMBrU2bvubf0=;
	b=ky3qDIlvgqouE7yBeotOuWUFAsgVmaWtBSOecxp7AdXbrJjuDQGohb1Pd95/cIVYoaXJfL
	q/uc4y9D3iwHFbhCTJy/KAPLs1KCPatl1sa3bnY5sfgXE09+hWSqNMHhjmyB8LlGqAqsKx
	05QId8BEvNkv4k44oUNd4fthq43q50Y=
Date: Tue, 23 Dec 2025 01:51:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <42e6103fb07fca398f0942c7c41129ffcce90dc6@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Johannes 
 Weiner" <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>,
 "Michal  Hocko" <mhocko@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Shakeel  Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20251222102900.91eddc815291496eaf60cbf8@linux-foundation.org>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <20251222102900.91eddc815291496eaf60cbf8@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 280391A000C
X-Rspamd-Server: rspam10
X-Stat-Signature: g7o8pgtakqpm3gsha9kmnkbmppu8a1a1
X-HE-Tag: 1766454702-19842
X-HE-Meta: U2FsdGVkX18SDxoPIcm7mue67OdJneEYD4KFK4Ehn3NmnACkBRialCk3t1Ne4a3vxyaRz32Wz6n0bm/dyDtyzmfbxzjo47FcD7imcyB5Vl91dKk314quRRb1apTByvWMw5zVbFH7Sb6P1vX9Gh5hwBATP6tDu9JugAOv+K9JmRT7cjnXdXhErrAcwalELkLhyUXc1nAMUcRcX80sYzeMv+MQPX3k0pozn8EMcxkX2bpoYIenZP/crdbXr+iJE5deRVgbdXrYWKe5D75Z5aLJipWUBI7KQVgUuWT+ooKEJroWoayMi4Vro+R5urAP6DuigWF0RiyjBHBASxITzu6j2Cu3kpNMz5M5wqRQDUt14bBojVD5cBPDG2l62q1lk5IrnZQsHZnPmJVlSZa8THwlUmGEWXmEon2Le6zE67tFcoqJn55G9i1gQgjQVpw40uZYIyUbYe6Xo8Qlaohn7qpoqGX05Iafpvcz1VQHVuD1BknJXKBdv520vZjSPRLXmh4OO7qouPRZsTz1djWGqy4fXcdVVoew1/bmtvYhtYfU9uREvKzO5qZ0F74OO45Sf+chwM6nI08ke8Ki+aBd1bQjI6sl/8+VT+46QnBzwMK98+sxtdWwaAlx1Lb/uXPV6Bblnb/2qrY5eWZAnz6P9gXxUbeDs54fHARzeBoBijn18T57eBD4Pc/9WtYYOfOaOSvj4ogaXLHjRse6Pto+lAFP9cAAvFgo1B7u8TVXyeraHjxPQDm7XvDRtey5a9j9kiNZOUsusFwJWgDGz/YR4HRU/g0FuEE9nADqsLH3kFmkvFHFdmeYvcIQF3dVkkyQQU2m0M7LyHgGOPtv33ibaYkw6sw60XgwdsquychvgxVtAh28J/fStbQs/gTT4gI0pkSJSB+KxTQAqWaPiykRe/U49F5MRpJyTHXlLpxYz0DIP9w3U5tlsPVTl1AQJnN7PjL/ovLilvrSx6FTILQHR86
 zGZxWqyf
 Zlsvkjm6JC9ojeU1V7bHCQruphplR2PK/SNHNuiOej1nsIXAPo0yxE4DNzNb4sERqf2M3gyFIu44EmKJehVokZ0Y/gHJ9LlljLq1L6HIsDR0PJVufdsxAVwkLjzF+i+TyyH5+5gWtsNGX5E3UOcxm4xh2Aef1v4ZdA0hnmP/9cENxnfrgbUWQateETEM7DS7igZrHtL8dFxRn+qU9M3TS7sES/tF2Oda9kp51WcENUr5/xhUHWH231SCCj4///bsP+znAC3D1mqzv/xzHxewQY9c6Wxwdfko2Z1JKdl5DaNb38YE7kSfzTvGdTIafp76aEDa/Gdtp8gOQS53Eqy3fPRTD1jipa60l5amY/PKGEwsl8Y9BF0UufsyzrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 23, 2025 at 02:29, "Andrew Morton" <akpm@linux-foundation.org ma=
ilto:akpm@linux-foundation.org?to=3D%22Andrew%20Morton%22%20%3Cakpm%40lin=
ux-foundation.org%3E > wrote:

Hi Andrew,
Thanks for the review.
>=20
>=20On Mon, 22 Dec 2025 20:20:21 +0800 Jiayuan Chen <jiayuan.chen@linux.d=
ev> wrote:
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
> >=20
>=20What's a "pod"?

A pod is a Kubernetes container. Sorry for the unclear terminology.


> >=20
>=20> Business processes continuously trigger the high limit, causing fre=
quent
> >  direct reclaim that keeps resetting kswapd_failures to 0. This preve=
nts
> >  kswapd from ever stopping.
> >=20=20
>=20>  The result is that kswapd runs endlessly, repeatedly evicting the =
few
> >  remaining file pages which are actually hot. These pages constantly
> >  refault, generating sustained heavy IO READ pressure.
> >=20
>=20Yes, not good.
>=20
>=20>=20
>=20> Fix this by only resetting kswapd_failures from direct reclaim when=
 the
> >  node is actually balanced. This prevents direct reclaim from keeping
> >  kswapd alive when the node cannot be balanced through reclaim alone.
> >=20
>=20>  ...
> >=20
>=20>  --- a/mm/vmscan.c
> >  +++ b/mm/vmscan.c
> >  @@ -2648,6 +2648,15 @@ static bool can_age_anon_pages(struct lruvec =
*lruvec,
> >  lruvec_memcg(lruvec));
> >  }
> >=20=20
>=20>  +static bool pgdat_balanced(pg_data_t *pgdat, int order, int highe=
st_zoneidx);
> >=20
>=20Forward declaration could be avoided by relocating pgdat_balanced(),
> although the patch will get a lot larger.

Thanks for pointing this out.

> >=20
>=20> +static inline void reset_kswapd_failures(struct pglist_data *pgdat=
,
> >  + struct scan_control *sc)
> >=20
>=20It would be nice to have a nice comment explaining why this is here.=
=20
>=20Why are we checking for balanced?

You're right, a comment explaining the rationale would be helpful.


> >=20
>=20> +{
> >  + if (!current_is_kswapd() &&
> >=20
>=20kswapd can no longer clear ->kswapd_failures. What's the thinking her=
e?


Good catch. My original thinking was that kswapd already checks pgdat_bal=
anced()
in its own path after successful reclaim, so I wanted to avoid redundant =
checks.
But looking at the code again, this is indeed a bug - kswapd's reclaim pa=
th does
need to clear kswapd_failures on successful reclaim.

