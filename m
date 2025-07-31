Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A375AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD536B00A1; Thu, 31 Jul 2025 09:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3852E6B00A2; Thu, 31 Jul 2025 09:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AF26B00A4; Thu, 31 Jul 2025 09:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19AC06B00A1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:39:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B540916065F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:39:03 +0000 (UTC)
X-FDA: 83724665766.30.55150E0
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB2261C000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:39:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TY+lNnE0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753969141; a=rsa-sha256;
	cv=none;
	b=kSTL7fZJMa5+c/4rnZqwU2XuSgy0jeaM5mT2Ew7/T8HcyZbF6/hS4iORwIzxyku9Nlmz2k
	ZthSbfqglGkHqpecvJTIOs+IlvhLT6/IIFf3GDWUbS9FM50pJPgatgIvZsi/enscPQOhLm
	d9uG89lnoG/EtFHKq7lmRHXNkCPuuFY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TY+lNnE0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753969141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnez6DValapR3ZUUqRysmzvL+YRs62blvNyrOJaANrI=;
	b=37oPWOXDcdbEFetA6lNO5VXEDfQc5AECxgMDnJOibSOo8oyxObcj8xzNLtmL3PhXUjQd59
	avcBy5oqH6gSOmG1gY9t6L5svkI5Wb/5hbmYhpu+PvODM1pNMmzrJzT94hk3nLoK5tHteq
	+nh5pM/L6bxdq3x3Ov8h181zeXoESVQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45892deb1dcso4198375e9.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753969140; x=1754573940; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnez6DValapR3ZUUqRysmzvL+YRs62blvNyrOJaANrI=;
        b=TY+lNnE0t/uGkj7NgYhRO0IKRzcgrXp9KMBmJP6LjALgPlKV94YFHTvLsoRcZBpYRX
         GwMrIv7txQnMCYMKeiPJAttmUPdkFIiWZZrRm/S9AsdkBdF2GBp9f5tU0dPdzx6f5iE7
         uELCSNRTC+UEPRoXHfX9c1bdEyBciYBlGz7Hrnrp3JlQ700/tg2r71gEvXgOrU/X/+dw
         n6E4L8dlPPrTpW8opDvDXsRbmjoqFHCGj1oiJc1iubcfQrTIlBXEwTPrkThVAQrJqQHb
         nAnnshvXJ5rgyy29HTX9go5qSweCB9Kf0+L38KrBXMbHL2bxFPuLrSrGpQrl0CFjEs2/
         H3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753969140; x=1754573940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnez6DValapR3ZUUqRysmzvL+YRs62blvNyrOJaANrI=;
        b=RyS3knzUlRTA15IoGA3FV3zL7UxwmdW5va3w/sNFB3Z7TKTf4BAcl6EyQ8WJEWQHMe
         mM3jQ1AzagE9jNY/0G1nqg6xewqTDBOLbm0/mnnLhWsddVfx7+kqtkI1D5PSHnupBXhu
         5H978JGF8Du5drZEL3dwjyAEwn7M8DXUDTNNcT03BCZbH/yzTM9jmfkMmZbtA6XSUP0B
         ytjfa5OoS8fbOWSNc6AcHIwnL0lvd+iXiM1bYjUz0+cj6MlJ9LX7kLBLkyB7N1IGl7Fq
         bn+e7zOszzr2YkPzx0OmsvA48oye3C2TjGqxHr8oDxfYZ2VOaF+w8jBlxtWLmr7dHsk3
         Isyw==
X-Forwarded-Encrypted: i=1; AJvYcCVAydpo5zJRI1UefjjATqV2gRjxJPcIy52L9kFZT8CR4Be0FObaKGBvPW11cHDVCwv91/KJ87ikvw==@kvack.org
X-Gm-Message-State: AOJu0YzUUX6ywXFwTI1XD2c19pZ/R01kKwxWO+WZS+3+zsHyEDLNWBlV
	ISUxvrqW+Y3CtUw/zdIX9lPjZXr6jo977aP/VsKNth0bz0RZA8lTcU1tlZBkZcd3teI=
X-Gm-Gg: ASbGncvGi4DbyN2InwKDMx3Th7bZNqTMBjMed5ES0I+iZHx/OfNcp1JTmVKIQH4xyyA
	5JeMU4fUuYQAXBKiyaBDTUL4/746i+9eTRy+qfLJDLqm98roDtgt7aKHTuyD+1Y6jbZsBpFvVXJ
	zt4WTapDMaHM2YEJQNLKxBi8ZZqvneR+dC0mOCF0Nnsqnx5kGf8shOXTENHCSHya5jI/wYVPwME
	c7dR6qGxIsUjuOKaVDsO4R0FSY988qJCZYa+WOljc9ubEBth5+mDsqf6+EG528R2nfGxllo6dY6
	ZmLFJbSr7PLwXaChv+FrEVAh4iybzhLkjKR99NGiEhmuCr12UJTiAhowEml/g7bDpPemhOU0tYK
	zCTkG4jJhDMppXOb4jWGKiBq0iUr3xVugLkmsFmcaQw==
X-Google-Smtp-Source: AGHT+IFFm9zky0SxbktFrrzQ+NTv6G8i6eERwaMpUiFW2QYSxbmEiN7oSr8vkltvo3nUOZWrxX7dIw==
X-Received: by 2002:a05:600c:8114:b0:456:23aa:8c8 with SMTP id 5b1f17b1804b1-45892b9e4bcmr69774445e9.13.1753969140187;
        Thu, 31 Jul 2025 06:39:00 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4534b3sm2409107f8f.47.2025.07.31.06.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 06:38:59 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:38:57 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <fq3wlkkedbv6ijj7pgc7haopgafoovd7qem7myccqg2ot43kzk@dui4war55ufk>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2gxvsfqre7jriys5"
Content-Disposition: inline
In-Reply-To: <20250721203624.3807041-14-kuniyu@google.com>
X-Rspamd-Queue-Id: BB2261C000C
X-Stat-Signature: 4uio3dpz9z568ieyege5y5ub6rag1dcr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753969141-293382
X-HE-Meta: U2FsdGVkX18mAXtpDYpzAhkMShH/Pa2EwM5CLhcCbwIl+w9MtJZgOgLfX9uFBTxm7t6kmFvcC5f02xbjjmRJ/7Wtz4G2tPhwKaRfgs7yIi1Nclfio7EuzoDVBBFxUdJjZmheIJGACubTcur5ZV4ol2ZxfOKWFahdBASTeN/5VCe1K9am+cM4CcCegbUBVfLNj4EoVTaRrsfvgt9Ertoem+HRrEfr4bJc1OWD8SrTx+9IdMQ/IIW6BzNEgLXkAF2jY7H+lezWbGZNmE9y9gBv6NDZfhkojTJffS/TbnIU6RXR+xrM4dzxFHQlvA9qZZhdJKbsSNQR/lbTzDvC9PAlIA7vE19rVOyNvhmzoqMcE5KqEXiUioalY92uVr1QBACaIuqGkocjTzpHL3rz5/WdH3sA1+CFeKx95p/WAIFRm+oLw6P7fN0ZetriPZTHDBu4bqo/dEjQgqX4piFkE2oMBxO48UsPn0RkI9F+AbbR6cRGFeyEVIRu25NhbOPyPNO4WlrUvQbNSFJ05qEDX8SydltARywUyXzk6vCraUB9wf50pTBhQtCg/7u6wWr3/fTD34tEEbK1QKy7HlWZJbVbypkJTkcv58oUGle+IWZXeShVnocOrn1xxtQaJ2O86vESaTBNcocv/0vBpEHQ7ztRd2rgJPwZbrlzUfyZ7XHNoVYDUBnItoyX0a6kRFBudpjgpfHDr6TA4gFpCNTtQPUmdiWAPq0WTnV4t/ZA3SCa3hTgXXZ2WpbUiLcBq7lhuvwaOQ+iBa7XvPtycUveZn+s0MqggkOc4vl7vNsqMlRauhdfL6TVoj2mWRI+SG6tKUF4e5nQkJnHqa71NKH3Vf8O3IWAofTgTwi1ejif3iFqR2ZowhvuJaUN0+40YydmlAlwYjoTZwEU+1wIx4XfrPOJAscF3i6RqcuG7AG0twFgfaKvZpT8Apy2Wq45LxVxTzCcREzI3yWoxVKNH29lIT3
 WdS4cPQx
 q1S4hZgXf4K3UsPZINUGiFsXYDzIZb8V/s+MXSrNR/DnXCHV0xavO3Lik7D0EoZ0S10CaNLUZUEGLtPfS8ssfT+rnAFm82PGGsIkmj8NdFMtPUjTziQX6nQv2Q4/EvKajM2ORmDzh9fiIKMlRpIl3ZnrUoUcAAQuyzI/LHMxtXOcD7qo7eYSuha5X0VOtrIElyO0qJPkVMS3NtNxJGudQkNWewYxKyqhTR9ne3DYxqjbi0BbKIjWHvAGEUVhLV9cevGVamyn01Uir2AgoC8jS3v8OfjOkV3gJ7Kq+HTGjQSuOKmzF3v9DZ7y/JnN0Gu5KrwUTWKqA01Wi1HRtBa6oPxl1DZdtcl1L0aboU9mqmDuByw6axYzKf3gykXXyk3iOeYs8Pkw6GXWsxTKtu1oWzG5dB82tpjCqxvOn+4GIJx+7RO2ehi1BGUhTzZjYkf1QSeVWNBWKVIH2NoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2gxvsfqre7jriys5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
MIME-Version: 1.0

On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima <kuniyu@google.=
com> wrote:
> Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> buffers and charge memory to per-protocol global counters pointed to by
> sk->sk_proto->memory_allocated.
>=20
> When running under a non-root cgroup, this memory is also charged to the
> memcg as sock in memory.stat.
>=20
> Even when memory usage is controlled by memcg, sockets using such protoco=
ls
> are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).

IIUC the envisioned use case is that some cgroups feed from global
resource and some from their own limit.
It means the admin knows both:
  a) how to configure individual cgroup,
  b) how to configure global limit (for the rest).
So why cannot they stick to a single model only?

> This makes it difficult to accurately estimate and configure appropriate
> global limits, especially in multi-tenant environments.
>=20
> If all workloads were guaranteed to be controlled under memcg, the issue
> could be worked around by setting tcp_mem[0~2] to UINT_MAX.
>=20
> In reality, this assumption does not always hold, and a single workload
> that opts out of memcg can consume memory up to the global limit,
> becoming a noisy neighbour.

That doesn't like a good idea to remove limits from possibly noisy
units.

> Let's decouple memcg from the global per-protocol memory accounting.
>=20
> This simplifies memcg configuration while keeping the global limits
> within a reasonable range.

I think this is a configuration issue only, i.e. instead of preserving
the global limit because of _some_ memcgs, the configuration management
could have a default memcg limit that is substituted to those memcgs so
that there's no risk of runaways even in absence of global limit.

Regards,
Michal

--2gxvsfqre7jriys5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaItx7wAKCRB+PQLnlNv4
COjkAP0UcZBWkhc+vB0FfA1p+pH/BzzZDKA27tR3sA4T4P3PBQEAyknqdHl6GIJ5
yIxBX8DBx92ijoCOGSF1vaocgD203AQ=
=iTKX
-----END PGP SIGNATURE-----

--2gxvsfqre7jriys5--

