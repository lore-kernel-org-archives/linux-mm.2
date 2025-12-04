Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0ACD2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F176B00A9; Thu,  4 Dec 2025 10:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF4D6B00BC; Thu,  4 Dec 2025 10:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEEB6B00BD; Thu,  4 Dec 2025 10:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA9E6B00A9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:07:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C30EC131F88
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:07:32 +0000 (UTC)
X-FDA: 84182117544.14.4921FCF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95E13180008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:07:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Gv+BU8v0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LV+NgISCgSwq4CsmAo0crFfEsNkEPc+BvKvvHIanIM=;
	b=DPXo/rt4Yokr1xVjiDzR9RcWewvgTX+R30x/WsSM/GZFMoiDfUfyZdwtpOdI6ThrSythVB
	KsmQnSAkoL1uaBEWo4UaFnuwt2Xz1wsnVeDBTm7uEgZBd0mFAcfoeK7Nxcu9WJSwzVhoAJ
	+zzB5THejcbXdFOdklpzkkPc0cKiLjA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Gv+BU8v0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860850; a=rsa-sha256;
	cv=none;
	b=dTRgh+w9wlk866PHEBzXatTbypCPtIAnvT0VMEG/BpSsGH3odD9Gg81xOAyA0ypvB1pKBo
	exdYrnBK59G6NUNmVeS9zBD/tJhdFlUZRwgSSzhWbIHkcbj6y9hezU+CfSrvJ0PkdigBQH
	1B9f/Li6VCsy9eNeXWn6nGOPwp4PJsU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso8588075e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764860849; x=1765465649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4LV+NgISCgSwq4CsmAo0crFfEsNkEPc+BvKvvHIanIM=;
        b=Gv+BU8v0aCEJ97yG6W00qo4uNMlG2QXiHb5IudEgZQQGuyUHt9QLZUoUHSPEdNqoBt
         a+Yi3sBng35Xt6OGK9lFV3wPgSEdoTHxXFjxRj3ZKA13K1aZf9kgBZh1G8saDFvzYXM3
         J/acii+eMNgbqipkQAPppyWeqQO2UEhk4ybcWnCYJBVWJgbmRStrP8xSt1IHqDvj4+HP
         dKMYB5k4Zr7alGwz6f+gtD8vnXCHEUXtsRORoTpAiL0HtqGfdoYWidnjCIto0AgAX8QK
         Qgys+/kzlrgvHqWDKXluRW7uQizm2vIU7kr1bdKekDG4RXIzxwd6Qht3kIJJjzlgBPMf
         BfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860849; x=1765465649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LV+NgISCgSwq4CsmAo0crFfEsNkEPc+BvKvvHIanIM=;
        b=E07n3XJ1l/alO44iNibIF4q7pyCIeHjXqdh+kPKu0wJtDhL2aoxPyuTgzMUeyCRJVU
         f8y+fejrVuPMZVnjZYgXIJhpJjIcaMLRAb1dmsqfFoahjNV6kU4xA8+uNV6WXHc8Y5VY
         F9o4gGsRveXe6g+k3hKVGAiFlWXDoOif2XrukTQlQjuZ6QGkfN6jPCKfhhKRjlNMleqj
         ljeurTVidsoFUNZg0QBAy+pMEl8L8UKnfex500Wt4uwFeW/kyHlGsLJxLRc+qKOMdbEJ
         sao6MZqsRW5vB4XFFl04SAPHC3zj+wi3pwyYw/xphGbWPXb0HkGV7UZXe3VyG0Z6JQnz
         mwTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIXRoSEgz77BKSXU8NjaAaz2hFYUguefFm3CYMSwGG/DBMWHQgG9haTCQWo9piFDn2Pxae7uyjKw==@kvack.org
X-Gm-Message-State: AOJu0YyyvrolYNPxxZTyVjSWBU/ERv6CG4zFegZ647CymFDurB/yRqG5
	HO/Qd6BKj6eZwq5ZHCEEqo9EJJPSh00P72lo13MdEB8jnUgLd+Fb6LT7vAgffzonggk=
X-Gm-Gg: ASbGncvhUjejm9Ev4hJqcVHXEaNC/jei0vAV/C+2T7gcgGaE66dT02RFlHEhwWk2KgN
	bvlyf9/Uvinh60mLUZVbxHwpodMOXM2RodWZB0iL/nJL0+0nC2XaVQkxcYnC7CClhMg0NcM1KZc
	RMek04t/gMpnykfAAkpZ75oPHABVgRL5w0UPIYNdRXLTRpn7TyUGtIQEeSNWZr5kBom6/uszwcn
	Bhjagf4sASR+jJLJ53tlosIXdjq3t4+tChsGhNQfvD8LEK8OTAmdxh+MCz1dBrhZrnH+UYc+BM6
	a9Eeo5xkfTZGhodcy6KPwyxbgt/FrDpnwdmPtS1RV/GOD5HXOVHmPIdj+m/waIoJRMx2SXbRpfh
	ZoFc+zQ825PBUxEYAgJWhgwa+vmeMvNLnN2Z61e1S4LcfO6KqKD6us9Wwu/QAmg1kX9Yh3tiQet
	l1RDy94r5yH2xXLgJ6yvc8KnEeMV1bjzk=
X-Google-Smtp-Source: AGHT+IEgegdBeJe5UDZpUgbKF1HYqW837uojM+NO07aLzwRyc14WjPBXJbR8fQgrSzPjg7+ikvCL3w==
X-Received: by 2002:a05:600c:46c4:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-4792af1b19dmr68170455e9.18.1764860849081;
        Thu, 04 Dec 2025 07:07:29 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479311ee44csm34364715e9.14.2025.12.04.07.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:07:28 -0800 (PST)
Date: Thu, 4 Dec 2025 16:07:27 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
Message-ID: <tjs4ai55xpqmmq3t7drwor44xz2vdcsjrpfbl2lnddxwnkqw6b@i5f3vknfxeg4>
References: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
 <p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2>
 <f7553219-e19d-4172-90da-a2077cb574cc@kylinos.cn>
 <440f6a44-5d1a-44d6-b776-ec58e6c79f37@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iitwagde47fsnofu"
Content-Disposition: inline
In-Reply-To: <440f6a44-5d1a-44d6-b776-ec58e6c79f37@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 95E13180008
X-Rspamd-Server: rspam11
X-Stat-Signature: jn7szztckowj7xcg5qjgr3yq3q34xuwi
X-HE-Tag: 1764860850-831366
X-HE-Meta: U2FsdGVkX1+YqI6NZFs7LgJ/o4FsBsDipaoSn2GprPNKiyY07rFMDMSIYdocapezRvzSGZDHLv6+NClXl/RY+N6Gu4LE8iEx5GmUVSeaeUYmqmYQIU1O5w43qBMiMJmVpKaGhJ3089FmrgAjZrRCCeyVNp1HyTrlxNxYEvCwhDjewuPXok7BW9dcWd6oT/0jYXuZuZjoKoMbPKcpGKcDXI3KQxlqip8ZGIYgMbsMi+bQ7eP1zc+NU44tMyNMfNPryN+zlMVcVJ5W7KMLpZJcLKwt3/KeOehQlxu15xuv2xYlRehbhA/ge90nK41AW7M48e4HMVJyvh2/FYePnp+7OlBd06lzemxzLk5LuCJzBjhDmoDCEVUalIhANDObb5zoDfxTlg/MGtH3RStiazvtJwUvPs/SNF1A9rlUr/fIcw46Jau1KjxO9Ew2KYX6aOGIXXOqnY73AB1S76VRQsvch8v3yF/JDpeT4i7MVENQPfFg0S94lVViqXxYypyosPdSoPV9pHlBjDIHNh9VR7JA297ytPYLekzxRDuY5ZSaIqVAeXHKPcWcNA38TzU05cZ9heqf+9xwiKElRJkH0qeBWqsC5iggdSyAx51Zx4y6mjoS8IPymQYPEWz5nfN/vD8+Wp09Cb9tSwIWoyBxC9/GfUM7dzqkXF4+7WXVm3j3gGQr3FQ0mxuq1FZ1x+hcVVY42JaD1JwJu6zZFfvea08bvN/pMpqwE73PfZ2LG8ce6cGxp+r3otMqAi+chPXFBdatzcacB7OKojWL3J4xHtW+tUb3e/9XTjeSis6OibCg9O9m3h7glrT5FeW8KSGgYgRooaIAPFB5DLhlcLhspfZv4rz+v5SHc+GQN+ABHP2zVmpB91J2k8vIIeKk6ehy7i1HAOBorrVGhTjd6IzlX0sKcE6RtyRKPLkTmTVPz3vx3M+lZKjoYRuEvaVHG4ASpFFsaAgL6jKq9Epof52djOy
 Fg8OPWwU
 sYDSCZ1OTbEN15mzRRZcOYzvw6U34JCpR43JjEFiUYhgSKjh/G8Eh4EVMGFHjnB6r0REx4iqY6sH6//1EcRKPAEQj4IwFMjE1I7OASNXfVk752/SUfH7/OthLWBtuaO3yy1G9RBNUPzkzjGQHMPApPgJl9kEbpYGgiw32kkBy98s5NRs5fmp0xZKOAE2gKy8wFU2b2aExMC1jXFUn1pDGvw7+A2Xko/G1DGb/9c1wik8hW92+28D3qGc6IPJlWUDx8FKgf7Fbjznbdz5WLpuYtqrW9rMFw8ryn0Dre9oeR/ioxop03tMydztXMKh4Rtj0EpymkPGC5QEKMJs87m0JnXlodHzZnMsRjlQnA/42exlFgTXDzleuFqNv7uaBTofecMgOjj1a2ues85j+8Zo7SGyLL8HZ8DbekZFOpPC6YlzQ38Faxwnrw2U5BOexmVUwV4Ig/mG1gvnAlOggURo4/rzsB0HKBGzS2so4/MnGhxBk911+1rLnnTFViX+ksx4992pj+nVQjZI0hpSFNGwjdMa7BL6Ixph+DyVgy0cPI58VNKwLIXkYocdVTKTZp9rCuKev2nZc5FToKJ8WyjNROZ3xUOgmQwWgLWzc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--iitwagde47fsnofu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
MIME-Version: 1.0

On Wed, Dec 03, 2025 at 07:59:46PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> In v5 I tried to follow that direction by introducing a generic helper
> function:
>=20
>     cg_read_key_long_poll()
>=20
> in cgroup_util.[ch]. This helper encapsulates the "poll with retries"
> logic and returns the final value, while leaving the actual assertion
> to the callers. Tests like test_memcg_sock() and test_kmem_dead_cgroups()
> then decide what condition they want to check (e.g. =3D=3D 0, > 0, etc.),
> which seemed a bit more flexible and reusable for other cgroup stats.
>=20
> Please let me know if you think this direction makes sense or if you have
> any further suggestions.

Thanks, I think this is ideal for the current tests. (I skimmed through
the v5 and I have no more remarks.)

Michal

--iitwagde47fsnofu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTGjrRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AgQ3AEAsJsktpUy+qq0NNw0kbSh
vDI4eyB0KxjD+vhI9+63j70BAPdrUD/EGfHNf7Dpruu+CFaGuoHmujIDaazi+7dv
FigO
=MDvm
-----END PGP SIGNATURE-----

--iitwagde47fsnofu--

