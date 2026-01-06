Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE6BC47BE6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6194F6B008A; Tue,  6 Jan 2026 06:19:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F11F6B0093; Tue,  6 Jan 2026 06:19:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5285F6B0095; Tue,  6 Jan 2026 06:19:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6726B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:19:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7C84B9C3A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:19:35 +0000 (UTC)
X-FDA: 84301293510.19.08230B0
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 721F7C0010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:19:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhCh+yZX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767698374; a=rsa-sha256;
	cv=none;
	b=RphfmVowI1DHeWFoSkDHQi5Igqv+CCYW+PKYfP3XsukuHqssF28d0NhVgsDKDWSUWm/Mkv
	fXzK4HVUweZXOdWNfo9mlJiiUd8kV98pT3XZMpQd81quD1gaekhofid7lnVj2XN412uIdk
	tSMkEosXiFBWUKySFhwB8QOSoMokU3g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhCh+yZX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767698374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxmNw8YNH8htTjmTZyblWLK2VY0PjffdH8VXCg/kWWw=;
	b=14d19IYy6eFIctlLw9eUTm4aMSlBHMMeANu6wKv1TcizbsDw+1z/KNgrw0mb0+s83NnRfS
	1/h7FguKX27j8A1QLgTvy6/CoUDSW34BdAyEzIN7D7EOzwU7JMAVmFzGVYbII7q+Y4O3W9
	j4XW203x9UNduaHKNmgm5HXe37KVNQ0=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767698370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxmNw8YNH8htTjmTZyblWLK2VY0PjffdH8VXCg/kWWw=;
	b=OhCh+yZXjeB2LCOKtLfiYL+Mx4h4GgbDe4uyuaYuMcx5T1fo00IchJECKN/BEs9uymqrZe
	Ou4AECQg8/aBayX+XNa6Z5vGDbCkRODIc4+bB+AAhJ8tNUFyVHqirrZ7V/P2w2LQKDTINV
	Os7hlgr+28HxQEN6VKd4iBsW/Z+Pmo4=
Date: Tue, 06 Jan 2026 11:19:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <52cc0b2671b068903c6580b7431db0f22982ae86@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
To: "Michal Hocko" <mhocko@suse.com>
Cc: "Shakeel Butt" <shakeel.butt@linux.dev>, linux-mm@kvack.org, "Jiayuan
 Chen" <jiayuan.chen@shopee.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "David Hildenbrand" <david@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <aVzaqAZ5Wagh5cDQ@tiehlicka>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
 <aVzaqAZ5Wagh5cDQ@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 721F7C0010
X-Stat-Signature: 7dumu4amb1xcqwsqgutusjpgdrn9y3km
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767698372-701245
X-HE-Meta: U2FsdGVkX18on5fDVSgANYSwNRrzebnnj3aqh5GKbxdBncMGBbEsFdvVXOarLMjKy/IvfpzMt7Qb8FJav/qMrhWNfO72kF6AaDZHK6qIkO6jGKzMCNxE+EIgJL9qPPpf0rEcALE/ehiJsTVyXe9Ev/ybYpp7iy6tC7jTlRk9AZGLjV32wZS0w2VXfh/pJJoZ3cebxhQWHQEqgvj5NuosfqnSzgjNnATzZEhltXZqD1JIu3pnO8+oGg6xbaJNfP8IWXSFYvOrB6Yq+KCgRVrYj6loK2wikBX8jk8bE0nXq1qwFYnB3R7T4NRDkEhqwGGHktwFirdsv4liBw09tp7N4QQVDteukIkXnx/oOkcgFfAiuWGrdOfKOWPQtRFWodTRQHhoAnNpvJZ20KGmgcCPryN53vYea7nrNbp+FS+EHoKxTFjoHJoM6NZkEwsmEQPPEoU9ZDlvEW9WRemiV/aAo+dKsi4zib+QfpnEH5h9yDck72KUsmUugyhzIZh2vafFXrORwz6cquh1or/Up85RFyGoCrzxjrV+PHZOHluglglUEvsITLPA5S4UrJUViR8ifKS74x6mGjplvVeZwIupSdiqxImlaNOkw+biMx1mM4440i06br4rY0ZDmJwsIBiuLUtNCN+52+E5pbMWufphYtof6j//b5k8zp+b49BwRwhSxEaJKQgzcifM8+VwLZhEz/xeGavF8OANcPT98RPDIjv7LDHI4Shq9OLeoUqcwBIZ4/SVq53xTzATJVlIMUjTQNCf50an3IPdtSiUhIcU+4PSIOvq2PROcYvv7b2RdYkXAygVP94eI8rCQ9QhSs3Sr8PLc07+eVkqbGuk70RnSv1okANfekH5/Ki2QdM4JdHkUyCjL6wWdOfNuJuWov/ulbvWHrTeOHQHiIDBmNBQHsh0UahTQ1+THDCUfufI17cyJ7jz7lybHsLuMcRBCNXLr3wKXP1SRtRXZZcKrLb
 CsOG48dS
 RlVmhi3OZjCiZhgQRfYY4+FC3u4PS3w/GWK5Fa15YmDgpFmjdV4VhGP2hmK0vi+PZnyKLdz0d/rOoarXgwR9mBXAJZH4J2BAIZ/iaAl2kXokYtCaTZp2cxp5rvp91RJyJpEFOrfvTW6YD8toUUgMBBZd6rM5yk7bLm35+BN42K/GnjkW4q0gMj3/RQsvSYF2ykM+DZgLaBE4QbVnuwzC1jkvUfYtOOkL+/VQKczAmTQVc8C5w4/ArhsJZMRCYX738zFltNhSBh0VJ6UlQb/QroyUDBLwcfcRkmwv7TYI0uVnV5R9jtVvJ46JUkwHc1YYqcqG55fQd8Eh42fHNAmniCJ7PM9LXpjHSfXKQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 6, 2026 at 17:49, "Michal Hocko" <mhocko@suse.com mailto:mhocko@s=
use.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:


>=20
>=20On Tue 06-01-26 05:25:42, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> That said, I believe this patch is still a valid fix on its own - r=
esetting kswapd_failures
> >  when the node is not actually balanced doesn't seem like correct beh=
avior regardless of the
> >  broader context.
> >=20
>=20Originally I was more inclined to opt out memcg reclaim from reseting
> kswapd retry counter but the more I am thiking about that the more your
> patch makes sense to me.=20
>=20
> The reason being that it handles both memcg and global direct reclaims
> in the same way which makes the logic easier to follow. Afterall the
> primary purpose is to resurrect kswapd after we can see there is a
> better chance to reclaim something for kswapd. Until that moment direct
> reclaim is the only reclaim mechanism.
>=20
>=20Relying on pgdat_balanced might lead to re-enabling kswapd way much
> later while memory reclaim would be still mostly direct reclaim bound -
> thus increase allocation latencies.
> If we wanted to do better we would need to evaluate recent
> refaults/thrashing behavior but even then I am not sure we can make a
> good cut off.
>=20
>=20So in the end pgdat_balanced approach seems worth trying and see whet=
her
> this could cause any corner cases.

Thanks Michal.

Regarding the allocation latency concern - we are already
in the direct reclaim slowpath, so a little extra overhead
from the pgdat_balanced check should be negligible.

> --=20
>=20Michal Hocko
> SUSE Labs
>

