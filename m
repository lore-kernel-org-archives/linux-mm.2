Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A8ACA5FB9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A846B0472; Tue, 20 Jan 2026 12:46:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6716B0474; Tue, 20 Jan 2026 12:46:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFB96B0475; Tue, 20 Jan 2026 12:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE706B0472
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:46:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A02FA1406C3
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:28 +0000 (UTC)
X-FDA: 84353071656.16.ED9C500
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC285A0015
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNhRKUeB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768931187; a=rsa-sha256;
	cv=none;
	b=EBWkHUr2mEJSGT8P+AUxKPceYI75F9W0i0P0nyn7xY3a8l0ofEWuRmJi7bjYBLlvdI8e6Z
	W/FjuwP2NJwYJ/XicBUIY9KG4z2qEAIa1NmbSyZakCGUShZZRsfYKEUKvXyRKPexl0Av82
	oJOXUm2t/ct1vSwUf0XveTq8Q5/HCko=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNhRKUeB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5H4DaA+BVtjixlH8iyAw/Zu0Kz11wPIolxdn5hMZ8I=;
	b=C/sQbobPnfYB6KLn7bHmlSESar16F9y0Q/q8uTGZBVdNhE9IdUSS7wlOF7LW86N8yHuVDX
	bxCh4wraqiLMaqLohJ+LnBxIh9lkEgY/QRcPx2WuccQXfSc9VpX62AB5mVDwV4jzN4K0WL
	1b1z1Q9Q3uX6XNEnjTYG0Dq2+TzDkvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0545143509;
	Tue, 20 Jan 2026 17:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C96C19425;
	Tue, 20 Jan 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931185;
	bh=TBRtgmjrWAjuHKUcUNVVb7dFeVlm8K/wDFyukeuO4yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNhRKUeBDn7HI+Rf4DnqVFcGEjTt+0wEI6/IYeAJiUCBHmIWokXFrZn66wnsDkvH3
	 vfYVkodq5FbsVrJ0N8kngkIzwi820ZViMbFcmgdPlWGCmuNsnIjU4Uz9QMSV3T8/9V
	 s1V2Ap5zlzr41jcOI39ugYO52ab0iWLECdqHdeXLAbbSQbwQBP9STm6fSJauGBK1Lf
	 LS3ZJ8EEwYSD8oJ+6OIIyrNA3KsQ2xqBoWOirw1+32T7EFXzfv9X0i7qBoGeQD6w1v
	 Q1mjvhDfWv1z92xh7JgnHoLxjSrIGM7vsnQuFgcbg1+Osn4AR28QiDXkIPdYf3LybR
	 xV4p94jQcpeGA==
Date: Tue, 20 Jan 2026 17:46:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	nao.horiguchi@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] selftests/mm: add memory failure anonymous page
 test
Message-ID: <737310eb-05e5-4234-af67-9118b3f395ab@sirena.org.uk>
References: <20260120123239.909882-1-linmiaohe@huawei.com>
 <20260120123239.909882-2-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ObFgKhUWYWaLUrs4"
Content-Disposition: inline
In-Reply-To: <20260120123239.909882-2-linmiaohe@huawei.com>
X-Cookie: Leveraging always beats prototyping.
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC285A0015
X-Stat-Signature: ccd7p7r9h5txnmq9nfnxbisw77yca8pq
X-Rspam-User: 
X-HE-Tag: 1768931186-768548
X-HE-Meta: U2FsdGVkX1++nHwOVUOVJXQfZwuzko3VyCZpLkrVr7Vd52mqbfaFsYhrjZp6tzh8uhdsKwcAaVfD2S1v5o7p3Vpu8HLI7NKO4EKyDUC0q1xHHS8NS2hNQmSGaL7moNL8nEkIaRBEulG5eEgNeHNAME/RPjnm5YWNb+7ogWfQZrTdYp3sN0KK/QtQnheIXd2KlaNYSaS41TDupLw9r4VQ0L++qi+7wUgpfX0SrfmQ23ow7vzinFphPBTe3xm8Mrf3YcQqAvCeSHy2wbjvD7iIeNr3TrGBP8D8iTvzwXbbOZ5xJ1YHlssPjVoAdbVg3W2Tn70QrUUZNzuFiGdj2nRtxCGIBtINsSQ3MdqC39nAyX691eqQUjA0tBDqeJjm10h90urzXq0A9hSrVhLuWtXuTrYQ/pHZwYoXYWB1pLDhMdH/A90DnzGBxpCUV/RrNfERR1xtzs/cDeHzKY5nrPTbta9zWp6QlYsGV0PUPBT6dtFS8M9/rJOwmBIQ0gCh+lQbNeJr+wQjHXGpCtkt1ytzrkgLfTdmigFni/h3eg8KtajUbbwJbOeqXPzoIORp4LWCZxAKB5olkem18mXnBHgbB9PL4rSJ21ey53B5bOvNzuxdlrVkuZ9XzT0GxoH1tDemIzAeA+jWud2cwW+g7dj3v1Bmf6CBNTxft3vjzsXJ2NW0+Bz2Q8I1ggSb4amUq01N24bp6gz4uMvL32iuvOYX+2OWztbnVGIep3cTRQPsDbOQ94EzGL3A8YGSAvpSQRE0Y5PABs8KP3O2tJiqAKWjBY9lKvuUxBwMmvSCQEITktSOSTLVVHlZ064sUF2wvwF1JCi6MCYNU5iy35i3HKhkev/vFUTHHn4/fthfCPTsV5eDmqGJ9Z19H1wZCn+Aj+iEWBMtSp8vEjJ7OhKC047GRhiFL4OEFZo8Qy4nIuxFt0GnFl9FW1B4PMyp5l7xGOcRz4ZeqSz0u4MttDdseMR
 OtHMG7of
 RLBW0teXEkvoq3troL3mtunp5rSsWIE1hVpMn9YtSRhNc3qG8xAt5Lo59WWJDPcrkBJiH0qz2GasviMkD8RKG6iCUWISeqVgx5G3Nzkw5OqcKmVzXERPnWZ86iG0uBWI1ViEJihnz4XzS5v6u3YglekztkNAQZG/hJu5wmZiksnVdMA2y0xG9HDCEy+iKkgPYVDrsKWfvQrvikCtf5Oe86C1LGYIF+sLCGI5kR274jPOFgnCRFtn8/t2UEe9+dLOkvw1ZaGc5n3220xvSI7MZqY8JZ5tK362KQCLumfXNAayfO6ot4jKrKyDYxuOtBq/jf1lTXZAH/yfkLcCxHbzp4r/L89OuN1eNr7NYi4BVwCuGWX5Q7KFEi1bNDy/ftBETIMWj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ObFgKhUWYWaLUrs4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2026 at 08:32:37PM +0800, Miaohe Lin wrote:

> +# Try to load hwpoison_inject if not present.
> +HWPOISON_DIR=/sys/kernel/debug/hwpoison/
> +if [ ! -d "$HWPOISON_DIR" ]; then
> +	if ! modprobe -q -R hwpoison_inject; then
> +		echo "Module hwpoison_inject not found, skipping..."
> +	else
> +		modprobe hwpoison_inject > /dev/null 2>&1
> +		LOADED_MOD=1
> +	fi
> +fi

You should also add HWPOISION_INJECT and likely also MEMORY_FAILURE
(which it depends on) to the config fragment in

   tools/testing/selftests/mm/config

so people and tools know the config options are needed to get all the
tests running.

--ObFgKhUWYWaLUrs4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlvv2sACgkQJNaLcl1U
h9AeOgf/TpiwY5cSu8LPqhvpbJnimocDBJ2K+sADzVszT6mIF7B4Un4ISFwMtoN5
1LFLpWadwOpWZm+fAu6aj9z6pm4gXV/h3wvKE4rhgvCmLopMxaYZs/ZPyppookNb
wwh9UsnigPV07m6pqg5BFpwzdNj2QqOKJP+HWCNjCwvOw5FgDMhOFUhdnzCswd1B
Yn0kHmRW4RGceobzLmMN2CoYk4zs4gk97NjX2dNAUUwtSTLftMVQswUX0CnEaUoS
wRPA//UIgzYgIl0yTmaSwRMlCeGlE8wZz8cDX96cEOXBLH5dTPZUzs9KXgwGX8E6
rEt6r2ADfzxEDWkdX92JQvkkjIBlRw==
=wRVM
-----END PGP SIGNATURE-----

--ObFgKhUWYWaLUrs4--

