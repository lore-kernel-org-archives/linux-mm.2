Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B04CCD195
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79408E0008; Thu, 16 Oct 2025 11:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A248E0002; Thu, 16 Oct 2025 11:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18318E0008; Thu, 16 Oct 2025 11:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E81C8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:10:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AC801A031D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:10:39 +0000 (UTC)
X-FDA: 84004314198.24.213D988
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB73C12000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:10:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OE9uEDAz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760627437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Rbje5syNIXzuMkCbsb/LVpw2Q98dHUG/YI0JY1KZoI=;
	b=eCjhkK9qHlspZhccwShEAZPyR1QexPCFkqyTzwRWXJnbKZa9m9RDBx9nndgjaxHpXBQ1CP
	305BdQBdD/7/GWbI0Ibx40KONCwY5dW0YVlf2FurzksPFNTxMPKWhaVz54S6zTmhTwH3SB
	ail80g+rMJuT/6WNT1rxNvssseBLiao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760627437; a=rsa-sha256;
	cv=none;
	b=H1m0nYZSrfAoJZYpWOnMizKCbQKteNzEdVjanlczKCrBHMXLu28Ibx2+ZGV7Pz0cTRcSXX
	UMywG8EdHyxv446HwcqbZxxjl7Xiw4ghDfv8ovE0id0ZdD7wELKaDlLfghb+0N47C9YQyL
	pB8+m7Mery6RLruF0QrkVF4Z6jC8tJQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OE9uEDAz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760627434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Rbje5syNIXzuMkCbsb/LVpw2Q98dHUG/YI0JY1KZoI=;
	b=OE9uEDAzCUn91z/a7mgLOA5W0yKF8eYNp31jtjS2Dsm51tmeu0kbQvHjf3pt7IOvUbS4Lg
	yzhK/BlaIQDY7YAjZiGISs9JXUxA9QNQcj3hVGuAvM9UUm6VNNfxeMOfGfzeJbx8hy5WAX
	/MrNQrHjgIB0ao0rifAMmZYD2EJ1ZFQ=
Date: Thu, 16 Oct 2025 15:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
To: "Michal Hocko" <mhocko@suse.com>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie"
 <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@redhat.com>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org
In-Reply-To: <aPEGDwiA_LhuLZmX@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
 <aPEGDwiA_LhuLZmX@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: w1ym9dm986wy3n98ugbc6pgraaa7cy4r
X-Rspam-User: 
X-Rspamd-Queue-Id: DB73C12000A
X-HE-Tag: 1760627436-64852
X-HE-Meta: U2FsdGVkX18m6bDIqozDX5EhFtQwRJ8h0kqDUbhG8OXclGB0q7MMNlmUcLgWtXiOc8Ynbd1OYXzBE/1DYGaqmISN3LMKLazTHpXFOVw26ggGsYZKdMl/ixb+BFaFwXHFxy01MJzjiwVCMezfGdrefYek9fmCDcB4jj3cbYIjqxlKPSY4fuFJlcBHqYyU+5dMT9UitZPpAI6xMk+Groyo1vrO168LIfHpyHDJ8aj0325LKTeMUzPWqsEO+Zpi13iXmS2Gx90eMj/4o9hlDuWoTgVNL1AC579t/r1aRS/XieMVTp8HOsM4c4VjHYfnAB0KIHPymoYOk4aOzIjGmdA0l2B1WQ213ilWolrOG8nxScR+rNBIE+a64CpJWVONnctzUHmytCYKbrqCKukeG4abYiUxeMJkMBjGlY0GvUfEBckToi4camth25+7FbBBs4b04negrnn7Ucz8Vg7iZ9JJw8F2zVvJflOIn/9RA4CAp1izOJ93w9T+DDWMA1du1MCpcUzAcSA4XBb3piDd7++iZ1wD1KKlsSvVNmUjm3hTfJItGe+DNSav6+W9aVZlebYFbMav8pqpneJN1WYOIxIHhSjBoac7dguWjPs3FO4mhUosU2sGcydGkLg3OfJ8W+9Ox1AkYHZHq1Dz7yntWZg6FmLR6p/LVBqmoYurITH1sKcthC2Kj+T53PZM/Tr1RpRgzM67n6+SfzoBe5PVi9UNJwXGZw4U2nx6FAxHBQeSZO0bjElpIuSySWAL7dV+FIIjxoK+nY0aYbtT1OI7FolH5xbWK1IPVjbt1xIRwnnHDKpnXWwhpD34JXd0T2OC2HCABOQKzkk1j9dvyu8+hz+hSK9C5Gz6rxccnbLWsDKZ/CiEEbQ4N/5ZB3krOqs7ZC/Y5Iw7TSsCggsgGGtBz7p9n1FasIpZ0ALUc0NLOMYxSlv3JV7RBJAz725WYMPJwNtjd5puhI5BlQZMmCXMPc/
 n+AMQc70
 JBcWaYyYECPPPZ9kvgRsL6M6YHqJX0KEuYOzk0sS52so1OgHqF1y/96nKm9J6ZS+8zf885XVyOBOqzANjq87SRJGZ650XFQfrZNPkoYKq4EXleMZm65yVyyPaE0YRtD59YlDkrYxp4494duFypCBF89vPEw58t5ZyzpRESH/yoF8JVf4nyNkdZYFmBhIUM/S5A3mBeY5uveAui4sMR9UwU8pdryqUcUDdxaRDlEeTapLiVVwbLfQGnNT6G57gKIqotqPaxvzL5eS+20jV33TkWBsAL9HZm/q5RRxootMi/Xldb+nEgGBRop2hkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

October 16, 2025 at 22:49, "Michal Hocko" <mhocko@suse.com mailto:mhocko@=
suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:


> >=20=20
>=20>  Thanks Michal, let me explain the issue I encountered:
> >=20=20
>=20>  1. When kswapd is triggered and there's no reclaimable memory (sc.=
nr_reclaimed =3D=3D 0),
> >  this causes kswapd_failures counter to continuously accumulate until=
 it reaches
> >  MAX_RECLAIM_RETRIES. This makes the kswapd thread stop running until=
 a direct memory
> >  reclaim is triggered.
> >=20
>=20While the definition of low limit is rather vague:
>  Best-effort memory protection. If the memory usage of a
>  cgroup is within its effective low boundary, the cgroup's
>  memory won't be reclaimed unless there is no reclaimable
>  memory available in unprotected cgroups.
>  Above the effective low boundary (or
>  effective min boundary if it is higher), pages are reclaimed
>  proportionally to the overage, reducing reclaim pressure for
>  smaller overages.
> which doesn't explicitly rule out reclaim from the kswapd context but
> historically we relied on the direct reclaim to detect the "no
> reclaimable memory" situation as it is much easier to achieve in that
> context. Also you do not really explain why backing off kswapd when all
> the reclaimable memory is low limit protected is bad.

Thanks for providing this context.


> >=20
>=20> 2. We observed a phenomenon where kswapd is triggered by watermark_=
boost rather
> >  than by actual memory watermarks being insufficient. For boost-trigg=
ered
> >  reclamation, the maximum priority can only be DEF_PRIORITY - 2, maki=
ng memory
> >  reclamation more difficult compared to when priority is 1.
> >=20
>=20Do I get it right that you would like to break low limits on
> watermark_boost reclaim? I am not sure I follow your priority argument.
>=20
>=20--=20
>=20Michal Hocko
> SUSE Labs
>

The issue we encountered is that since the watermark_boost parameter is e=
nabled by
default, it causes kswapd to be woken up even when memory watermarks are =
still relatively
high. Due to rapid consecutive wake-ups, kswapd_failures eventually reach=
es MAX_RECLAIM_RETRIES,
causing kswapd to stop running, which ultimately triggers direct memory r=
eclaim.

I believe we should choose another approach that avoids breaking the memo=
ry.low semantics.
Specifically, in cases where kswapd is woken up due to watermark_boost, w=
e should bypass the
logic that increments kswapd_failures.

