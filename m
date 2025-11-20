Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC33ACF8875
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266606B00BC; Thu, 20 Nov 2025 10:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D986B00BE; Thu, 20 Nov 2025 10:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D306B00C0; Thu, 20 Nov 2025 10:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00DFD6B00BC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F036140155
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:35:08 +0000 (UTC)
X-FDA: 84131383896.21.49015AA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52A0318001A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:35:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=auaK871h;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11esoKSgE8g1amitmv74A8N+MN8ZcrR64u90u3R6V54=;
	b=V6P/rIuSZ/Zwa+dvr7IP+bi4HuFhi363OmF1vXHl/OKm22P1JzS8yEhkNrU/6CEEv21sbk
	U18+rMuNn45VOOfq7bXIpCS8ygT+kFV4M1FXBMe84zdSr1w+96rq+NUbVVOcaqNQrpm6tA
	i6VAIaOQOK6L60OjAH0belVpimRX5ys=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=auaK871h;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652906; a=rsa-sha256;
	cv=none;
	b=m9t8yvHPIEsnuOWhi7i5uiT9tCqlu3uWlasLCk2xBbNecIs8XTIHKf9DpEQMIam5NVX5zf
	SAF7neTNeUiODtUlZ7aJIs/lx578oyihnRcTP7xsGsaep9ElyWrZsRMCEoQddLekLeEWDF
	UaNXcJG8t+alSYuJyx+XSf40fvJta/I=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso10100085e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763652905; x=1764257705; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=11esoKSgE8g1amitmv74A8N+MN8ZcrR64u90u3R6V54=;
        b=auaK871hi0fjzkvcOD8pnQ59E2O+d/sc9SQ8kFP8Xb0SDZ0lBNtWLsy1EMQCNLo2tX
         d+8kO8TDRPA2aromGOGZf7U/yY56Vzo/vMj1UJSD8fqEay3LjwnV2nZiJkkLbji/SAVe
         WalcPdu5uX1C54Sn1oEQ8RX/PWNuOGf04Qn3seWrzzFjTbB7Hkf3E5Yanr8MB+ugZi5x
         S9cPzUsVTHYknBxnbmEQjXWHWDtjyxGtIJ2Pz0Ya+DnYuyrkZuMCgYe4w5v9UUbidgdj
         1/BnKwqColehJ4ZnN606Y0P77f4QYDPen50Bh8GRH1TI4q8ZlsSPe0dpQE+SwAoKKEEU
         dyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652905; x=1764257705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11esoKSgE8g1amitmv74A8N+MN8ZcrR64u90u3R6V54=;
        b=W0IIVii3JEKxo2Nlrda5nacnq8lZ5rTPKhTp6g4FiESGuN4564fJ0AeEniju4aDY1o
         19JCodS/+GfzfubzwTrW7qM5+93csuOeR9EsuyHqzKKCsZlZ045jmZjwi0qMAtCiRNnk
         Wa1fOuFVQJ28DRPBXUp+uf+O4NklqajcGykV+YXYAEWE60nUt8G7xcQyUgZUa6FOexEZ
         ggujK2RBbSGM3CfTv3AUcmsE91eoJjhUyARkIuI1S1a+yrnUJt5peDLGefGbLRfwl+cm
         h6bmTU4RKLlR0Nq/xyDcF6KdFf98N2q587hhYeKliz3E0R8rLk18b7iUHHMzU4W3kCG4
         nVrA==
X-Forwarded-Encrypted: i=1; AJvYcCWi1SMAQSBQwtRUUsKGfaZMib3Dh+FJWXkA+1UrLJLY584feG/JUqp21Ae3Wd5uqyTQdcFrbQfJdQ==@kvack.org
X-Gm-Message-State: AOJu0YxQF6s2dHByxLtaq+7Y+2cI3+wonTmMn1BlXg7av/c22d0q7tCE
	A2Ev2tqzF1SZph91qgfJDAKLAQPyKZhQiMZqWMUimFk/skld135KCkb+8MGI2+2QPgpnGwrY+bT
	QPW21
X-Gm-Gg: ASbGncvbxrYvq4qeo2+nrdcdLKNqeVMHBDQz1q9oFKe80Mv/4txqowBAkoBsGDdFSwl
	f1GIKuGtM1LzvJyZDvIxy57IIisdfkOpxiqfiEFj5OCMwNfMz0mvHhuft30NPk7nFaLa7SQUDYd
	z52nsQWJmDN1r4qbKZUjo8jQrzF0I/2BFg80/iPt5LdvI5j/2mMvgDggal9LVnYAWp1ZpSImzvs
	emTbLUZQjo9vI7kn/wgvNZHIRoRZE3HkPd0Oqu67H2AvN/U4XkyGclkG0jBZk6+rzudA3CYrvch
	zFtpkBa9kDCCoIRsoRpFxyNj5z/1LN4CZFdFcEk/hkOwvRzOziEu8XQnOwmntS9vXRA43KRcY9U
	wEQR+cUazPmpkEIGNgKf1/IKDZA7HQrgawJimHkzUdnZFeO7W+ZIFEoguNvXdjLaFaWNHPBJQVx
	g0YCauge8Y83HBWA+J9hKWyWHXr7zfeWMT
X-Google-Smtp-Source: AGHT+IEPAYYqmLfa62VPjHRp0h443J6MQXeseMV1CiVvWJMFtArLSISsoWd97XXXD7e7TlfONuWvEA==
X-Received: by 2002:a05:600c:3b08:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-477b9dd6e39mr32508755e9.10.1763652904777;
        Thu, 20 Nov 2025 07:35:04 -0800 (PST)
Received: from blackbook2 (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b82d8251sm53046445e9.6.2025.11.20.07.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:35:04 -0800 (PST)
Date: Thu, 20 Nov 2025 16:35:02 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
Message-ID: <p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2>
References: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ai47sd76qnrx3mju"
Content-Disposition: inline
In-Reply-To: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52A0318001A
X-Stat-Signature: 7mx77xbj4rehofjfczxn5ynmrayks4wm
X-Rspam-User: 
X-HE-Tag: 1763652906-552243
X-HE-Meta: U2FsdGVkX1+eqPXrRro7X1VwNs/AWfEz1r+x48hNnDLyPozreBvbJCtVNM+ZHy7BqvwKUZIQ16GYtGSNwRCcB6PuUFVS2iH6AyAvZyzA6BmgkXMAK5F/GEaENAJYafoO8EXSAY4xt9BSgejVp17wSaxiJ2u0Wtg8qXAVd237bqGJM82rKo3oksY1OVm1EAVfavFiqld5DeSsDa2QexF8aQKMxjbp0BYeeJgKg1szuwZGHji4kW1DpbBOHl+Uiw8DEMVA/dDSC4MReLeiRTKxlRYSbpi+dkbuTjfBFeH44TyTgot6HFeyZ5XWhl/8nPHCiwRX27Py+5jKzeUC1CkOO0PQt8ej3clsKaXjQk38QK+8qdQFOF5wtt9j/s/wHxZ01QPiSutX/Lqaccgfhlgkhb612+0e7mAkRP7MPI7azgQL7aoJxz68NQ+0IqhGSMzoa9kd8dRGHi/DJy41nDLEwSiGcVp9xFTY09sl7VbREZY8XfhlzmOQXGVwSDp7CnWpAFO4cOgPTVOdoylWLzFgbOmE9wn1i097SRStBCwLklq019B1QPSlLJiy0Q1RgbzECQsHMHqkDlP4X/f8Qtl7FLArEqB/AnP5oZeWclS/yGM7qoLuvUSWb8cl95jnd1t7Bh6xz8GM9NAIWhSty6mQevs/CqWzka1XnphGmKo0O47fbx3fuBIzPfopN0mBCij+0Z6tw0yFtSAvO0EZaGEzogGQW29vtXOzYgNBR15UZeksHUFvR2vBEsXcP5Fwo7KV+1RWUpWsm6r18CO0hAse8JdWvC5HTiFsjD+wSvJudr1reE5IqKHDm36ZocLODAyoW52gvnEbZ4P2svLI2CamdwnuYJZs/knkoCtThgKGesmbkuqEWFVSYTzYQYNoc2MjeuMGAfzN9WtarWG5Hu/3L/6oK5QiAm+1jRDOJTtLXwZH6NUhg9fMwE6SRA7n9RxYk7nXjPeKdHWjkHpEGts
 WoL3yker
 0k3+2plg78ZEL1GbdVyQpgf35e+gSQu5wP7jDLMuuuuoNQ1ENkLf4bznp/q+q3/51RQkIHWH1KGosbxPDcI6V39yTsglZ/ll5m/3eQ0NG/lYfxvQ6DpOBOjy5PxG1n1iVbvuiaZULOBDuow3xais8FjrpLtLJvsKfMk6svPIQxRJzs+iFEHrVZQJxXg7wo2JyyKrOUIwZV2s0Wx91w3DbXfOUESDKB1mtnRH6OzelPlLprzdWzUD+0vlOv22V9l1MxnQ7bjAXC2AJcp7n8oXUomkqfPCps8vPPXMujOWhfrNjhdDAc0oTaOf+S+Fejw7PDuEt9X7agE1GgyVMx++Vl/DPFlNOO4+1kwWAmRMEPmp0VZGMkpHvnbgIqpqITxfk4/ykmo6ttGwJSMDRUj/zFzZJd9Du1TnwensUcBCCQPJxMQheXl4sjWo3vP/IvVvYv5QpaB1Dw1IVbJnyzPoDrxC0mBF3Typ5QB26hOIAQTMJZU9YMgbsULoTS9pItLQ4ONyeOGfp1T+/uqwErUqFxRswYgEKSPcD2Jta
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ai47sd76qnrx3mju
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
MIME-Version: 1.0

Hello Guopeng.

+Cc Leon Huang Fu <leon.huangfu@shopee.com>  =20

On Thu, Nov 20, 2025 at 02:04:06PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
>=20
>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).

(FTR, I remember there is `echo 1 > /sys/module/rcutree/parameters/do_rcu_b=
arrier`,
however, I'm not sure it works always as expected (a reader may actually
wait for multi-stage RCU pipeline), so plain timeout is more reliable.)

>   - memcg statistics are updated asynchronously via the rstat flushing
>     worker, so the "sock " value in memory.stat can stay non-zero for a
>     short period of time even after all socket memory has been uncharged.
>=20
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
>=20
> Make the test more robust by polling memory.stat for the "sock "
> counter and allowing it some time to drop to zero instead of checking
> it only once.

I like the approach of adaptive waiting to settle in such tests.

> The timeout is set to 3 seconds to cover the periodic rstat flush
> interval (FLUSH_TIME =3D 2*HZ by default) plus some scheduling slack. If
> the counter does not become zero within the timeout, the test still
> fails as before.
>
> On my test system, running test_memcontrol 50 times produced:
>=20
>   - Before this patch:  6/50 runs passed.
>   - After this patch:  50/50 runs passed.

BTW Have you looked into the number of retries until success?
Was it in accordance with the flushing interval?

>=20
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> v3:
>  - Move MEMCG_SOCKSTAT_WAIT_* defines after the #include block as
>    suggested.
> v2:
>  - Mention the periodic rstat flush interval (FLUSH_TIME =3D 2*HZ) in
>    the comment and clarify the rationale for the 3s timeout.
>  - Replace the hard-coded retry count and wait interval with macros
>    to avoid magic numbers and make the 3s timeout calculation explicit.
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 4e1647568c5b..8ff7286fc80b 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -21,6 +21,9 @@
>  #include "kselftest.h"
>  #include "cgroup_util.h"
> =20
> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
> +#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
> +
>  static bool has_localevents;
>  static bool has_recursiveprot;
> =20
> @@ -1384,6 +1387,8 @@ static int test_memcg_sock(const char *root)
>  	int bind_retries =3D 5, ret =3D KSFT_FAIL, pid, err;
>  	unsigned short port;
>  	char *memcg;
> +	long sock_post =3D -1;
> +	int i;
> =20
>  	memcg =3D cg_name(root, "memcg_test");
>  	if (!memcg)
> @@ -1432,7 +1437,30 @@ static int test_memcg_sock(const char *root)
>  	if (cg_read_long(memcg, "memory.current") < 0)
>  		goto cleanup;
> =20
> -	if (cg_read_key_long(memcg, "memory.stat", "sock "))
> +	/*
> +	 * memory.stat is updated asynchronously via the memcg rstat
> +	 * flushing worker, which runs periodically (every 2 seconds,
> +	 * see FLUSH_TIME). On a busy system, the "sock " counter may
> +	 * stay non-zero for a short period of time after the TCP
> +	 * connection is closed and all socket memory has been
> +	 * uncharged.
> +	 *
> +	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
> +	 * scheduling slack) and require that the "sock " counter
> +	 * eventually drops to zero.
> +	 */
> +	for (i =3D 0; i < MEMCG_SOCKSTAT_WAIT_RETRIES; i++) {
> +		sock_post =3D cg_read_key_long(memcg, "memory.stat", "sock ");
> +		if (sock_post < 0)
> +			goto cleanup;
> +
> +		if (!sock_post)
> +			break;
> +
> +		usleep(MEMCG_SOCKSTAT_WAIT_INTERVAL_US);
> +	}

I think this may be useful also for othe tests (at least other
memory.stat checks), so some encapsulated implementation like a macro
with parameters
	cg_read_assert_gt_with_retries(cg, file, field, exp, timeout, retries)
WDYT?

Michal

--ai47sd76qnrx3mju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaR81HRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AikgQD+P75H+Zk6KLQv5jtwZR2/
lc6k9NlLyZw80qeoVGUId3MA/3Xf79tB9qS682uIdC73LCKqrsTyqHG1PFRf/s6U
uGgJ
=oeRR
-----END PGP SIGNATURE-----

--ai47sd76qnrx3mju--

