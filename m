Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10775CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5147B6B01F6; Sun, 31 May 2026 22:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5286B01F8; Sun, 31 May 2026 22:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB686B01F9; Sun, 31 May 2026 22:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 311886B01F6
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:34:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB3F9A0571
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:34:00 +0000 (UTC)
X-FDA: 84829773840.15.8B89951
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id CBAE480006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:33:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USGIKcbS;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780281239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMHgRM2VgLCMfYV/Kx1tsJefCoHRzu2kO6ZVF0TG+Ng=;
	b=J9xipigp030rts6iD1yJlYzQwIhv3F3XVJlEeD7fkpQvSKl/+xBZfUnqQagKYzWAqJEMx0
	f58D3uFm4hbD2wJjpEABmvQyfNbAedO6piXg+Y6XkT+gVo1TVkSEqxOqsi7fQa6FAfF6wY
	rDiaouBv/Q6MbcVh7rqF5IKOlTTPXSM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USGIKcbS;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780281239; a=rsa-sha256;
	cv=none;
	b=SjdnrkZjoPNYuUst9ZyRPOJc2sfJYRXPDdbI8ycuHJwX3aUAMdJ0dorYvdW7YCxwJ80vOT
	eEPK+83XnFzxNUvz52TDB/PBB4/QHZcT7Eb1Rfb5xT3jumcgUSfRrjwiP7Gq1+a6Lb0+Fi
	z1T65azrI/MDbY31B/XL2aWv9cZQnUQ=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780281236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TMHgRM2VgLCMfYV/Kx1tsJefCoHRzu2kO6ZVF0TG+Ng=;
	b=USGIKcbS9nOCEqYdBNcQ0LJXZKLix/4zkNsDQi4I/bTsjwkJ15Jjc1l9ouC84+s+uKAKQx
	peltIFP+3sBipJu0MValVmndBCloOGVXp684I5NEdj9O7B438dTOT+Xa87xcFq25H6G3bX
	eOWzpOa7XvD1Dae3zeJmayev2iA3IrQ=
Date: Mon, 01 Jun 2026 02:33:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <4915dbdd42711403f1781e3c7a71a11a53b0249d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 4/5] selftests/damon/damos_tried_regions: handle empty
 tried regions in early cycles
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <kunwu.chan@gmail.com>, "Wang Lian"
 <lianux.mm@gmail.com>, "Kunwu Chan" <chentao@kylinos.cn>
In-Reply-To: <20260531165437.99410-1-sj@kernel.org>
References: <20260531165437.99410-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cnc3b64e4spmnitjph4hx5pkkkkzk6w5
X-Rspamd-Queue-Id: CBAE480006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780281238-707625
X-HE-Meta: U2FsdGVkX1/Ej0wzAgH4qU7D2iPcSdIsTVFJGtdqIBKJKEuSlUo3kTLPI2Z7hvXQ4wMA8tGsxATjHdEPF9xOek5hLqVr6ULMz7yqIZyAzgdBCuImmGM8/IxkDXuZ6yNgyihZD/O52NdcG+hkyJy9BB8NQzK2PswbKtO+JTzYxRKuHLlGR1UECxnelmI6r28zabTsZiA4zf3eWovuwNDsJIbJ3H1e2htrkJ4NQFCN+pdKvQkZ5r2CasCsB6q1a2IwJvxPhgxBrfJd28tyPQUE7pqtySKNedUvZdKFpz6HyGQepqvIBXrRSMgjMoi1z96sqSERTiZTbd/fRS+syHBhINVVXXjtuCTLTrOvPPniAVpA5wCrN4Yy98GbTarLnxtUWbIOMlCSYF3tbtNqzIWO9ViupL3zUzhX362v4azZoNe36GL7wPnYRlJPxTZJV9U+/SUhDZ9rVNMu9NLT0a3ItlYTwvc9DVOc4q+aUH43nq7TUFHs97cfZEx2aLlv/9bnC6FO+OeqQMWKJ1Mzz9LalDQn6ePfYdxgS1hnA+THTozpLaW8AS+UYBrzk3ubFR4wHjRKQUK342yTU9Bj2YT3knginorhq8MSWO7vxnrzDLzZKOFcuwUC7bkWMZV6qc0fMQnzAyG9+lre+NNT2shJZ+MPIInuKEx2PJm1z1dZ574v5nn1ccHqT5cZTqKCj8EpGLgi3yZoaWFM7JnXEuyP/uqKIIauEFG0TniouW6O/pY8LStv/fxu9oE85oQafywbzlFJ6Xua8qQiuhupkYlJg87UsnPmrE/mloY7RvYd8+gLXqgwqJhSZTHVoCNnr1puCWkOl5LDB5L5z2E7EXEott9TLLQrPaJw0SdzQ65XTxlw6tYtfmL2Bbc+2eLExLB99Cc5uQScpyQSrKhedtQmV32cAuhyiw1P8W6Kw4u4n1mbUhRMys41nL9wZvJ+rDyuBRRNTmSAdXlx6e+TGqf
 /6RLeDoq
 /4VmsPmt0b36oToT7uBHRIXQr+1cE70f/UrjXyOKbggnje6d9BNlJIfoAMvU5X7tUZP1gY6jjut77MdDMFBC2q80cgFXopXSk1LszFNy4ZSl8UFID+nJ4I/FWPZWUbheLp6vgHcCa8b6JVxhZmJOehiCHM9BTg8nbdeHLs2f79uAovxKGRpymDs1LhcWyy515SgnrQxCZk2ktEFjbUNXrd9Y5BNm0bgavzR70BUsHUlgUxadAv4ZigVrthVI29x90dBKqVZFygVIjbwTpyYKhSAhcFhOiWuZIyHpEKrq1dLXpnEoR1yyUouUThE9D0awENlMUTaxAcFj6L8p24yqp+DQS/qxEGT09KdH+dCb7RjYiN8T9t18ZOJXPUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 1, 2026 at 12:54 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel=
.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:


>=20
>=20On Sun, 31 May 2026 17:17:23 +0800 Kunwu Chan <kunwu.chan@linux.dev> =
wrote:
>=20
>=20>=20
>=20> From: Kunwu Chan <kunwu.chan@gmail.com>
> >=20=20
>=20>  The test aborts if the initial aggregation cycles produce zero
> >  tried regions. This can happen on slow machines, causing false
> >  failures. Skip empty cycles and retry up to 200 times before
> >  giving up. Also check that enough samples were collected before
> >  computing the 50th percentile.
> >=20
>=20I agree this will make the test be more reliable. I'm bit concerned i=
f 200
> times retry can make the test run too long, though.
>=20
>=20Also, could you further elaborate why this can fail on slow machines?=
 That is,
> DAMON will check the access of 'access_memory_even' process every 5ms. =
Are you
> thinking the 5ms is too short for 'access_memory_event' to make the exp=
ected
> access (accessing the 7 regins of 10 MiB size) within? If so, should we
> increase the sampling interval before retrying?
>=20
>=20I also suspect if the unreliable results you seen is due to the fact =
that DAMON
> is not flushing TLB, like we discussed before. If that's the case, coul=
d we
> increase the working set size of this test, similar to the wss_estimati=
on test?
>=20
Thanks,=20SJ.

Good points.

I don't yet have enough evidence to say whether this is primarily due to
scheduling delays, a too-short sampling interval, or effects from not
flushing TLB.

I'll investigate the root cause and see if increasing the working set
size or adjusting the test configuration may be a cleaner solution than
adding retries.

I'll drop this patch from v2 for now and revisit it once I better
understand the root cause.

Thanks,
Kunwu

> [1] https://lore.kernel.org/20260525144846.604907-1-kunwu.chan@linux.de=
v
>=20
>=20Thanks,
> SJ
>=20
>=20[...]
>

