Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA54D6AAF5
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 17:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625F76B0088; Thu,  2 Apr 2026 13:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7556B0089; Thu,  2 Apr 2026 13:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECA76B008A; Thu,  2 Apr 2026 13:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6646B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:16:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA4071B8A5F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:16:49 +0000 (UTC)
X-FDA: 84614270538.17.52982F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 34BCB100016
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:16:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dl+Qup7z;
	spf=pass (imf14.hostedemail.com: domain of achender@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=achender@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775150208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dAbs0ViIKuDeeQa6jBcHG1zPdpX/3dWwyVeXPvC4F8=;
	b=x9TMwsyXn+9bv6H+AuZTuIRHH4OAS1DY1hxbFggFjkomJVaCT3LQPjnSqjOXQOFNg0dXPM
	yLntveKd9Gtds+raWaDAE/OOlP0qMZVCMZ2xVBFazXyB8MqkJAuhGqC6JTkc1uBShqUx67
	Tqrig77CHUM8H8kLUGksvfM/zsKaZZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775150208; a=rsa-sha256;
	cv=none;
	b=f6eI6Rl54Yb7jS8fhvT6JF0lA0sJ7WePGnYjkmYzTLH0Yb8OxLy+xUAHG9yqH3NSRQb/am
	EIkaDHHEZq88WuhrNF1AGViQs5cgMFHM/Ee034BupL12zgoVza7HV9qlCDGIrnPbh5EUZx
	a5zcDXFAjROAzFM/q3e1AQgHMAyZpeo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dl+Qup7z;
	spf=pass (imf14.hostedemail.com: domain of achender@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=achender@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 476D2600C4;
	Thu,  2 Apr 2026 17:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A08C116C6;
	Thu,  2 Apr 2026 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775150207;
	bh=q2ENSVdXL9UKqPBougkuIFpXYN+LGvwxDJpSdkRe9Ns=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=dl+Qup7z7Tc98Ztt+iWlXK/Q8X0gMUKI5vMwrgSYk4vNr979EgAfJr5jvFWvwUdqn
	 X9V+qmPQH/nINq3CbMK1/+Y738cooTCq0nNRl9eH4HW+iwPh6y9mcltfM8iBZsQbT3
	 0rVdOJrAg1YsnLP+/e3meuUO59+avboDyLEUV+HX4K7xLar4idJ2sBtwyFAaJ1z13z
	 t6YIdZZzynhs4JQqEDmJGAEXLntj/kxIaw+XKH/Q2rFKKAAKVsd+ONUFw/9UDpBreD
	 PxpG69RsW24/OtKUzY5pPtbtJ9zIx5eE2jblWv/sTpmLU9Cg/R+i1hPv/s83mthrsq
	 TiSi2wZQOQoTg==
Message-ID: <ef82c1e910558e82ac228c9dcf9ae79e9f78a238.camel@kernel.org>
Subject: Re: [PATCH v2 4/4] net/rds: Use special gfp_t format specifier
From: Allison Henderson <achender@kernel.org>
To: Brendan Jackman <jackmanb@google.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,  Stanislaw Gruszka <stf_xl@wp.pl>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org,  netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com
Date: Thu, 02 Apr 2026 10:16:44 -0700
In-Reply-To: <20260326-gfp64-v2-4-d916021cecdf@google.com>
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
	 <20260326-gfp64-v2-4-d916021cecdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 34BCB100016
X-Stat-Signature: x1ndc5hhk15mwdazw1e96qyg7wu5qz3p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775150208-943623
X-HE-Meta: U2FsdGVkX19/4cWTswRW6MoadrgzPhRq5gS2WDVfxVId4VneAOUSDR9+AbQDaHqUXtFOtpgWHzF4rEWHPtdCenlGiBLkEOWwLltJq/7lQMWV0mljYZ1mmCEI0/dgMrV67oc4xi3eGo8fj6BoVBkmxAxP4LXIEjwf+AJJYjmmgyZef4UA2UBLk6HDiPvdCZ3nZN8o+M7CevZ4Z2fViPiCDFA9hGe+GwR0zl5j3/ZIL0IFZUCwledyvB7cbmwkmwNQFij1e0ytJqSQDK+KN5x1WQxrRDhiuRMjfnw29GttCgseR+rZfAb3GRoPPr6S76mocaGQ4bOmjuCz2aAqGNb19+F9DxE7gy13HXjIudvV9HEAsZ9CHUKHgamOyasodcyRQdPdFntSCCY39LxK9jCojFYMVg4paqwSJQ9FdsigpRmV5Ma0lgYK6VDX9kH1IiUD0zC8HnXqiU+sdNGrnedYS3Rzj2A5BO4UlUGP+V/2bMv42f8AOXz9eul87gbdxJK+pYLjE2Irja/PeGQxoFgov+VEJPsGXcRbaCj+qJwKFcIz5lmUK+KRIR4ksAhc9GONCncurMTfXGn9t9ku+/fWycHcnveTeTJwJ0NoB9/K17w8M2IIzhwJN+BJtl1fZe7U29BD0YyEcgjto7IEi0ltUi6Z9yHeNMUMKZyodHZ94moQzOy8/yhH10chThaNHdo1gubS7C/XZ8jfEm+YmIEWNpGDq29w4SfzG7h3YFwFjBVVNFe5jnzHx3XQxQIQ0ky04Bx6eTqQCZcyzwtl7sOty1ty1AKPgXAuI+xuEDU04DtT8its0RXmqdMwfvCuTkbnrYSsUoTVavviMU8RcFsKskTSuB7d4vm2eIXYkyamxy3NkwEMKKK8oXWsMkdJ9Ue01ThBGtu6v5eCe8pZWTH+sBJDmgdtNWNoLQlYy/S+uyEFLA8VD2Rj2kyNwVQ2m0e4QedD2eK7OJD8XAiZTmm
 gqufhzfF
 RhbkG72vWoaog1T9r7AY6oUjSTnZcJ1gN70bI6b977h/4tWUUFdPgCtS8RW6VHkB9JaHiEdqvwZ+8+A5PDkmcuW6QddDJLW/YxBaUzD2/DjDhrnkF5ehmL9Cp8nvJ+Zz4O3rodNod4GCCk3cEwmlFSFYlPDU6Stnmt0etppznHNqg6QEKaKaoJVIs4SX2IEA/4OMW2QRRV6yE1DlD5TB5qll1gc+Wa276zah+X2N+NFWgqCngIOBDyKWkl9p32n1qEtAuxzJsdBa1XZTI6lH4KoJnM1dXgDUg7TReF/7xI2vMwErvKWpKVDrueg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-03-26 at 12:32 +0000, Brendan Jackman wrote:
> %pGg produces nice readable output and decouples the format string from
> the size of gfp_t.
>=20
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  net/rds/tcp_recv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index 49f96ee0c40f6..ffe843ca219c7 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_conn_path *cp=
, gfp_t gfp)
>  	desc.count =3D 1; /* give more than one skb per call */
> =20
>  	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
> -	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
> +	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
>  		 desc.error);
> =20
>  	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&
>=20
This looks fine to me. Thanks Brendan!

Acked-by: Allison Henderson <achender@kernel.org>

