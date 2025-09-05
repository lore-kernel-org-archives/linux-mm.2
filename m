Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB6FCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAB18E0006; Fri,  5 Sep 2025 14:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A5B8E0001; Fri,  5 Sep 2025 14:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A9E8E0006; Fri,  5 Sep 2025 14:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1618E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:02:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 333E91DCB60
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:18 +0000 (UTC)
X-FDA: 83855965956.25.21192E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9302D140077
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2UfK7QX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757095336; a=rsa-sha256;
	cv=none;
	b=bzLWSn8v/7wlOLtoqbJYhcjiitTyP1LbZVFaBDxhbNCezG0XrQrEuSs1dI/aNnDnEmBi40
	YXsOYN+ZnI/xTQ34xMS9pdBJtu2pMZYZViJcATARvV5h+vl6s9jcnZ1qQviAOwJFI2OoLE
	nfdj4HoqE62By2CwbS4k9y5K0JEReOo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2UfK7QX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757095336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uP+hAxOOeRY1nTJKzvH2YNrXS6I7J/OZjb4bFE68/Nw=;
	b=Yqqzeu3AR6K8dFroRrAMGcz5wM306qAIl/BELGZkqw17uFjxllA1hHqdLR4NZVMGl2G5HV
	6JVFfL9gNjruLpVCbtQ6+vmrY/aT0hgK2Clv2DSu+UAltW+ztsgT4Phyb3p67NO7MYXYr7
	IRUNs7ewqDHDAze+ZwQyoCdtJS0zv50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B32D601AF;
	Fri,  5 Sep 2025 18:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B25FC4CEF1;
	Fri,  5 Sep 2025 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757095335;
	bh=6+8JIJLbwNB4qZrpYNsQtnjhJwAgVff1bSa/FYZHBKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2UfK7QXsPOsR4h1I7z4w80D4OJq0HUKhdxFzTJJXPQW76a/ymHqdFoShZGHOri27
	 hUIngdSefZ9zAz6kgALIQOXKls+JFAxBrOXQedFuF7/bNjOAbdIegQQN9UkAogzIZt
	 4gerN3GoA1WzegyqmRCTqiO1IDM/9DXScs+5qcWmY+XZ0TepXdr7Z1a4iQPgmIiZXi
	 Ffdcaqr3SGeT60JfLFJKVvACXiy8LazmUV1LMvVCMeC1pigzw/GvLKEk5o3eZYnZes
	 YQe+hO4MjJv5mDsPcaflz0Gi2b4mDfo5x8sKYIZATaXoMww/La75/NoUQPKIOb33Hk
	 DmJ9FMbs7OwfA==
Date: Fri, 5 Sep 2025 19:02:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
	riel@surriel.com, laoar.shao@gmail.com, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Message-ID: <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
 <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UFcG+34rk9hn3RB3"
Content-Disposition: inline
In-Reply-To: <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
X-Cookie: He who laughs, lasts.
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9302D140077
X-Stat-Signature: o1gbrd5g9jtib3mmyxth7t88y14q7ufe
X-HE-Tag: 1757095336-483933
X-HE-Meta: U2FsdGVkX19MHnpvfCvjJkMlos/qhr1ltRzUmGueNmq+bclbeMeoJGiK4xE77TSihfFwZyexnE9oG3RVieb9RiFa/4Dx2dJ0cPqxZTolfHPYSamBzjbK2sS6Zya0E3JkiBCdDj4a8Wcein+6hpqS+w2WUBFOZKfHYjczGoJws4/sobcD5RtTow8Vgj6Oib7nT2oGtgoN17OI5uGnL0V32aRaAPPy29DCzh5Bz25hxYU4KIB2UKR67nYOb4l6CeLe2BYeeEKCZ9SUWUfmoxXGfukWwvB6K64jM+B3ijtgZkr0HeO8ytxGKeqV3vX/W92DrJd0AF4sdUaHj4rJdkUpN80YejCki66yfACutMi8RlT9S4yu5Nnwy+6a+Z29go+iqv+VVOu+T9PKqJmoLF/+TlUb2bQPBSER7/XK2BDOZcRhHvAOfo7CWs9ZAA9J8tO6AVMauqNsFmZww3xiuoyPALdlbsSz2s+Dp2su4seFsOVIWajBDKwze67maqpIXnJ6TdUQtHHmeRqMZzvIqaadLGgCqwV9p5v4ao/0Iev+1BRMq2wNfTvWK/ClICsD2B5BZiiW6WLtDkS6NQ3y0UVpn6JFi/Q6tKTWHO4kIkZTvKeeQFfKW8Hy/m3a/7E8HG9+nYLfcSGILRK8Lc6EGf/ZMOC8Pw389rRwTqcu/uS5amP8Nb5XYFrZos9VDISPv9/uLvk4F5OV+zR7xOilAk/EdpBarTA4D1njQWPR930lk4QzxhPhQeCC8AGDBcX74iZhVbie00//pVW6HX9xvS3yTG2dt7Pt7BaMVG2u0LxLdbgyE5izOB4XfAVhXuKT9j1lfYFCBNJxZbl3Kv6CldBfSMQlPh+uXCu4vpBeiSMZuPXHxbaV8s6gML3MW74h7gLK8o+T4Dbgsmqncgk2Y1ZLZxHB4m6jYfN8yqCgefb1bg6e1n03rR1MJNzApyRaJ4vzJ57h08nqHz66y4OVn7s
 XeTcAdk8
 KYg2jRWgCm8N/jZw/yHFo66FFFOVipjIiqtz/gBFOizRGE46V0aTOmvdiRXdF+cqV6hWUwhvI23mXqj9msyG3gkeONPVCkGg5sis6lJZu1mm63ezMYs5IOknokjBWBUpfs+FnMl68yQcb2CFsjeT6EInexHxRi5jougv2eGSFEz1C5ULCeUJXU/60Fft+bGHcfftv37fnFdcmtCOgjb5ZEojyJKro1nmsAhzzg+aajlffzJxbHqBOD0EEklcpkTO5oZjycm3Zdd9HMLFR8kLN8J3TE4/ZMexSroD2uU9bpWS3Cy6vxcOFSuZT34Rwsr9eLGqWXqaDjwkeOZT/FGEtRrSrhQMBeLDv0/+jPoVDkHlbimZJ8z8vZ//4/nvMlSwAnn8F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--UFcG+34rk9hn3RB3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2025 at 01:55:53PM -0400, Zi Yan wrote:
> On 5 Sep 2025, at 13:43, Mark Brown wrote:

> > but the header there is getting ignored AFAICT.  Probably the problem is
> > fairly obvious and I'm just being slow - I'm not quite 100% at the
> > minute.

> prctl_thp_disable.c uses =E2=80=9C#include <sys/mman.h>=E2=80=9D but asm-=
generic/mman-common.h
> is included in asm/mman.h. And sys/mman.h gets MADV_COLLAPSE from
> bits/mman-linux.h. Maybe that is why?

Ah, of course - if glibc is reproducing the kernel definitions rather
than including the kernel headers to get them then that'd do it.
Probably the test needs to locally define the new MADV_COLLAPSE for
glibc compatibility, IME trying to directly include the kernel headers
when glibc doesn't normally use them tends to blow up on you sooner or
later.

I knew it'd be something simple, thanks.

--UFcG+34rk9hn3RB3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi7JZwACgkQJNaLcl1U
h9CXKQf8CLPDpCThx982MKFSA+6kIQN173w+JjtervyO0xBauOFpYhofXBOJ0T5F
gBBx9/nVvRfBb2qz+9/c6b4AhAZU2soqeZMDTjDJ//eBUYiNlFLbsOMuFPg/s06w
pWU765APcweYpKI8xj2QmAlP6HTEYcAIBhFGv1taQ7bVwS86HL0Rkl+4IUB5KtC+
dyCYUXNJ0TIlxNXvHLzk/t/35IZ3IbphnAk7TcUpcxV2pKnztlzFtQLk66Mgr31j
Af+RATFuHuhGnDOMbg3pUsVUMl2wZ1JfF3FoDs5oyNCUN+isKcmQFiaJMWR8BlzT
/K7wOXmcgx0SuUXmECqvydHaxCcLXw==
=A8qN
-----END PGP SIGNATURE-----

--UFcG+34rk9hn3RB3--

