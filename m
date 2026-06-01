Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3526DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F016B01F3; Sun, 31 May 2026 22:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9766B01F4; Sun, 31 May 2026 22:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7766B01F5; Sun, 31 May 2026 22:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39CC86B01F3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:20:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE4991C07E1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:19:59 +0000 (UTC)
X-FDA: 84829738518.25.1DE87CC
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 042CB140005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:19:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLftl0Gl;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780280398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nefyT5OBxsTCuKDlG/KjCrlTz0zZS2F3Z2D5SQfViTU=;
	b=JER/Pr6vZIAXBltOIa6NYwNaet4yqVV8KOaYe2HDSA+PrW3P1gejpOTsXavmvtymrmpQuk
	0Auxb03mtDgXbwglpmvc8TbfAqiOSYZZrCe89ECEE4gMyjBdSUZbW3/8tCLMBGcSCqzhvX
	bDSnfGDqWk+5eGvkyrqT9uQCE5+O9xA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLftl0Gl;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780280398; a=rsa-sha256;
	cv=none;
	b=tyY2t3Hix8R5EENZpJun9x8xxh77NS1rqI0/vCIF25cuG7dHzp0ef/PwUwHfLCKebs8yXr
	yE9hxBg6fDp9a5TVFVOZJfh1IBrsEYkjLyHQVYqh04FSKx6ZV88Eei49cxUQ4+eamghfH9
	SSbRdQdfW7GX/H31AzN/fa/sf09NZvI=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780280394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nefyT5OBxsTCuKDlG/KjCrlTz0zZS2F3Z2D5SQfViTU=;
	b=hLftl0GlB63Jiph1E4xmIkxrKeqSb360RDRyLjAJRYHNGnc8hWoRkYA4tqsQZEx2eWaRgM
	e3PcRH2+Apep+uxasvb31jPHo7l3tr4KVaGSkIZiO0TmUkgm1RuITE0QASkL1FAMkjPtqX
	QG1WOYawC+iijEAXY55OMsSLMFrEnrE=
Date: Mon, 01 Jun 2026 02:19:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <075c80f2482b358705292a2557defdf384c94f7c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 2/5] selftests/damon: fix memcg filter path handling
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <kunwu.chan@gmail.com>, "Wang Lian"
 <lianux.mm@gmail.com>, "Kunwu Chan" <chentao@kylinos.cn>, "Cheng Nie"
 <niecheng1@uniontech.com>
In-Reply-To: <20260531163607.99063-1-sj@kernel.org>
References: <20260531163607.99063-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: iqug73f6haokr7hs5az41qo3bfzejcka
X-Rspam-User: 
X-Rspamd-Queue-Id: 042CB140005
X-HE-Tag: 1780280397-827412
X-HE-Meta: U2FsdGVkX18fzdXOA2XP1d1BO7uGgNEh90IIA7n05Twwt8Lmj7MUTN8b4a4UnhOwUwcH/AQTeQX3WRjUspRiwNH7VG2tOy2qv2+qePZdgBVdiY5j1qJJc5ZBuEq6GT/Ym6Jtz29/AQiR9iAL0Qd14oh0T8ZwJd0kcaYGlxii7pxn6b4rN8CTqpceKViJyZ4GY14Dd0EMenlMAHQTGUxqQ+LrGBHedCxIXKODDiYRMjy5c4DWENhdStRCXGoYCHag5rgjH3r9K4yVp6sIb/Aym0jaqyXKLpbEasRKTnx6pfFeGl7vhfiL2k5YuG6YeIzt8qPX8rMhgllNyio150OLy6OHbFbM9DLhoAkE9J7IYdufAYFN3yp2vFCKUN7gq4w0SoA6C1KpXjWAJZLdWiQ5nWqaYqzoPuWTUS0GKKEIjfqhFNgI3tIRIdA3yCGGPlvM10zUreleghfXBmyamlpdfsYlav4oA9TsnwKdXyLBHsGr0Usy3FD6MrJ00Ws+hpNgQdbEPedaAtowKYhAxNMQpdbFyDlcpymM/9jNw9gJEVYOrZf9hdEhKQjGMwBHqAsZGkv8/e90KkMDuqFsD7/ecIi6bVhaHPjGrhBoYqRRcU8OXpDPokJ4NGZ/dJWfPEie2Y6cT9IKs6ziVndHDsLH/q9UxVS5OyiPw0/Ln8mhCYk1m0IjKyb42Lzss0Ym1N5ZVQQ+X+GFpaGgktj9fAGw8/2HlkKiw8rMIt+w99RsJS90MOzpArIT/dXo1vImU/wNV4plS5U+ZkLJhZWLQCMrGDiUyZy06zk0gUpcGWis4rqFAbimJBpWTusmZP1grznifiw8ClN6/rLjNHx9hWsJaRlDp3tEIxwuj7jYXKvd7iG114DuNESxp4Nh8M2UajeZ32Lk7Nrv+9E33XcIoPyTafb+ii48n7ykCnnWqW2heeYC8KF1lLZKKM5OTye1S4U5s5FbR74S8fqhNiICDSH
 g5Qm/uM7
 fbOccgVyphrsrE/anp7r6jk4P6XZQLM8r0NuL9o1LtrHF3KLlo9sLDS0iOMoeQ0yA8EPSuwqBw8RLmw0ubAay9BYswF5kADg9FkqVssvuNCvVm6xuZeznmlILyIK4rzq+FW8/RsEYyhGmZuSfe1GVrgHw/GVijEucHUpraPLQmrBnxP6ddRAVUGZCaw09kVj6jJ+VIqn4AQz6PBwvTiXsDAw/GJl/gohc+hOlLZED2YFXBKLXLPOxpFgv9KKHxNSrRKwOKAIRlAcEJHEi07MgaaFEpW0YZK5Od28ppsV3fC+g2OpAQHqbtsYIdB1/5SPjz4/9tJJZpMIpTYhFnj74RTWQir27XZB+CKXjVn347EGgsTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 1, 2026 at 12:36 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel=
.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:


>=20
>=20Conventionally, this mail should be sent as a direct reply to the cov=
erletter.
> But somehow this was sent as a reply to the first patch of the series. =
Please
> send all patches of a series as a direct reply to the coverletter from =
the next
> time.
>=20
Thanks,=20SJ.

Sorry about that. I'll make sure future revisions are sent as direct
replies to the cover letter.

> On Sun, 31 May 2026 17:17:21 +0800 Kunwu Chan <kunwu.chan@linux.dev> wr=
ote:
>=20
>=20>=20
>=20> From: Kunwu Chan <kunwu.chan@gmail.com>
> >=20=20
>=20>  A trailing comma in the memcg_path assignment makes
> >  memcg_path a single-element tuple instead of a string.
> >=20=20
>=20>  As a result, an invalid value is written to sysfs and memcg
> >  filter configuration fails.
> >=20=20
>=20>  Remove the comma.
> >=20
>=20Good findinng! But, Cheng sent [1] a same patch earlier. I believe Ch=
eng is
> working on revisioning it. I think we should give Cheng more time for t=
hat.
>=20
Yes,=20I noticed that after sending the series and saw that Cheng had
already posted the same fix.

I'll drop this patch from v2 and let Cheng continue with his version.

Thanks,
Kunwu

> [1] https://lore.kernel.org/20260529145248.84593-1-sj@kernel.org
>=20
>=20Thanks,
> SJ
>=20
>=20[...]
>

