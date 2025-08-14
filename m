Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB37CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8F690014F; Thu, 14 Aug 2025 08:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA73900023; Thu, 14 Aug 2025 08:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F292790014F; Thu, 14 Aug 2025 08:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF64E900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:09:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A01AB1605DF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:09:37 +0000 (UTC)
X-FDA: 83775243594.30.3BFEDD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 089DE40010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:09:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=peuKMqOU;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755173376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xI3tuETXrdzqL2LBVjFzxf+uycnTvDjpHkxWgbpphj4=;
	b=M6pTlt9ZO7BanvMRI+hGbse5R+N9vnsh+8Pc+iYhs4VxV88siJ5cIKQauhhXn/izRufqFe
	Eo/qXhsvwAuMnB5EQSD3fM28Jrz0yJnUMmOVYh1wK+XboNpPmkre01TgMhCpGRwei2Ezon
	nN/ZdG1ArU37bKBPE2dhgdD6hJ+6RG8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=peuKMqOU;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755173376; a=rsa-sha256;
	cv=none;
	b=C87dphLtaBlq7yO0KwDe+4oq+TRMRHx2lHRUxFJakL0h7GqB5PSrlF8nASP3Yt9Bqz7drQ
	IHoO+p0d43KGPC/0qIUQSqmbnVXBv1WFCqgCXJqZ13Fo+3XawjD3n34NGInEMXN2UhTYou
	9M+49gWha6t+MF6G0dSoM0TrAfv/7Tg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58CBB601DF;
	Thu, 14 Aug 2025 12:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1021BC4CEED;
	Thu, 14 Aug 2025 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755173375;
	bh=gpnex3Vd8qVIbIJY0F+J1N3ucXel3F/WTFMjzzOmJyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=peuKMqOUACl5UuhoepTx5K9KNtA4V6LwnSzzEQyrFwwHzANVvJ3u3yXnOxbjqblcm
	 ufMGKIIlHSTgJQcdEJ30saGaXUb0vs6aXwA4cOjFAmxwPfRO7Dc87JwZdW8VPUwFFg
	 7LQtN2U8wXq/UYg3jJ5yGK34gZDADjUo2aL5g2NmWqysZeqB420yvaiD5TWZ/YoSjy
	 EgdZnSjMQeAhXebV/ayiBuKBfNsDaNltMwkuU5v4NCWdl/B+D/6NStPhH9PnWLJc9C
	 hBrGbGkv4R/eGxHxVsjMMCzFGME24nsaPUBiHDEN+Ryp0Y/jDnUZC85s4PUXnKYRr2
	 cJx/nlSF3Vxzg==
Date: Thu, 14 Aug 2025 13:09:26 +0100
From: Mark Brown <broonie@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
	baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
	ziy@nvidia.com, laoar.shao@gmail.com, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
Message-ID: <47e98636-aace-4a42-b6a4-3c63880f394b@sirena.org.uk>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
 <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
 <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GHi46nNQCVWNJMJH"
Content-Disposition: inline
In-Reply-To: <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
X-Cookie: This sentence no verb.
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 089DE40010
X-Stat-Signature: 4obqfex748dg68focuaptriocxyri7qq
X-Rspam-User: 
X-HE-Tag: 1755173375-450050
X-HE-Meta: U2FsdGVkX19x3DC+Xkj4ggu2cnm+RxNTnLY8gQfdfex+1nnUKfzZXcP62NINEL02S8DSI8Hd1ehjBo5JZAEasdiKbrnJ5ISwwZWyiFemhjsJaXz83B41ZNq40vUzYMXDhWMNrrb3Mx7qBIUXhqA8aKhs9MAJUN1OwVqf7rhPF761grR+PlIyyAoNOFOuJcmN5jQUvkEtaYUgmUIA0kD0ATeeev4ibLIAsFjVoCUO2yjIaYp8SgroaDhm2lmKIuU1cXe671kHqCUooZ27uX//53HnpR4qBEmRUWxNHVhXI0WOnEXp7sUsLh21PebMEQbNxopGpGMJuSZuZ0FLf4eqVSo9H0WD5Lcy+m99O/6m4KcCl4tktN/YO782zGdTeDgP6H5k51n/xVWNK+I/A5uKG6ztBwc0WhLCisGvIC+Xhs9YZkkVrIwcK9z+nLxRbAizk0XMKyzVj/zJG4/+Npwh61RpIxEYLS1WvmtsRT7tan9bMIhwDI1g2LGJ3t9cpPc8ZaToEjYUgHVtMNuj6f0tVkwGj7oU08FZ3yamOEsg7cIJnmtDLC94t2ap8rQY4y0oFnw7nFhH3v6pPvg4hdhEnDGa34d495RTG0H/iUH0Ge+xAMry3YZkgcn5BjsK4g/V5IATJi381P8DNxw9WWfteQaX9Yib3CVKwNbzE19zYNRTmsCVBCqScdK3JF03ohZa+QJ17w1OPtreXbkDz6Q2vGsjHg7NdpavfD9My7EjL/CduONSK4XAzEb0LD5TPMaDXC/azwHfNZKNu9kH56SyASt+0swTMALrthUTUmKHbm1SeIIe2V+GT4K/WNLDvS5PT+FrIiQWbE1TA5uexvfCejF+HY7hiJc2PyGx/4kZVe7mfDhCwccwqLa3bDF9ekJMaczxDyKtXoC7tiOT9ynsghvJdM8KjtBulsYitRDhCEgiYFn/40jjpWov9welHFd3TJ+OnRPyGfHNH+IIbnS
 poCMbJeO
 4hItz36bpCo6iZ1BvMpFk+fVWPSaaTwX9+pQSoVtPtKNUVr2A+UOIct/miYFPZFjMRRb2FEZqj/KmtFeamYsUrKBsbTqw8V8ZzG1FhtGmzMyKy0unWWvTU4Y1313jjypcvHTy7ERsKVwu7wxTT/XqSOyzT4eNhZADulQ5k1DZ5j+MlNHqcrDZ/aFX19De94wTj0lc50pR+hRAZl80AwC/RfGyBHihrX1wPwt8j5FiA3+THQ02mY3zswgz+8mv8mcI8BIfag1Bn115uV13VSarkt0I3weD84wq2QR17vKUY60QxHBUbcEbt71qehZIIm1Z1dpZWwL7Za/Uz+WXj/U+WLIfwG51H9nFZsEXuZ6hp/OrcSCQG+sN0/WZC1qmXLtRsZNQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--GHi46nNQCVWNJMJH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2025 at 02:00:27PM +0200, David Hildenbrand wrote:

> Some people (hello :) ) run tests against distro kernels ... shame that
> prctl just knows one sort of "EINVAL" so we cannot distinguish :(

> But yeah, maybe one has to be more careful of filtering these failures out
> then.

Perhaps this is something that needs considering in the ABI, so
userspace can reasonably figure out if it failed to configure whatever
is being configured due to a missing feature (in which case it should
fall back to not using that feature somehow) or due to it messing
something else up?  We might be happy with the tests being version
specific but general userspace should be able to be a bit more robust.

--GHi46nNQCVWNJMJH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmid0fYACgkQJNaLcl1U
h9C9EAf/aEPUAni8qteBGzYVxbP+2fWh24gpZRUzIwMgipxQm2thCmcg68/+dFq4
dstImKXyE21x8t30rJinOCW+RpwSzA1V3b9ZHm6cjQPe2ZDB16BP01neXpXNU4um
v9RalcxQY8+Pfdy++yS1rfUKx6/D9Shag9pDvu4iOyrOv4xeH/MkKD/23OvyB7fE
Ukwx3wKDnx7NAHX/kfqg3P+OQwn7AWGZRhL1hQt2rZqDok7vUEN2lyQQnMsV8L1u
lB4FldRiC0ODiUV+A+BZ4qc/QYvHGz3Lys1VcRcQEVCzODOYyCxsfvQRXdopcULf
wxyiXZpWXsqfM//MSw9F0h7ihG9rnQ==
=O/vD
-----END PGP SIGNATURE-----

--GHi46nNQCVWNJMJH--

