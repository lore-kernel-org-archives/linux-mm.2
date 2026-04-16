Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16208F8D76E
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD9E6B00C4; Thu, 16 Apr 2026 15:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446A56B00C5; Thu, 16 Apr 2026 15:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E256B00C6; Thu, 16 Apr 2026 15:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACCD6B00C4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:11:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFD0F140954
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:11:01 +0000 (UTC)
X-FDA: 84665361522.22.0EC1F86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 035DB4000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:10:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdDG2SEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776366660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCzJlqeExE055w02JZJCNH/EJcfTFyU1SmLH+fDj4OI=;
	b=L5ug93PkuCXpMk0aKr+Tdt0aRoP34Gey8bLyeyxq5Hh+ZFxWZhuClI7Tb2l9l4e2FJCE1e
	wthpJibX3tn4GBDNmM8L2d84BsPsDqHat08mEJ7ITT0EwjwfX4xPUmDZk/Q8JZAGAW06Ma
	et0c8cjdGsrmYBK/0WKk+JVtO+kod3U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdDG2SEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776366660; a=rsa-sha256;
	cv=none;
	b=N/Mb3pDBJz6w1yHBXCc5HMuK8iJjuNYXHqOe6ytBWwsQLrVNno/UTmLno5txUF+on2Yoc0
	Jhd3Sw5TpfmacFGijVMHEr5PSC97/baQBoJKjwmvP4NFN27e1vvf0fCX6wGQjq+7PTly4s
	MeqhE3MWnVoyoRD8mJlkcDw+ew3s6bY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5ED240B2B;
	Thu, 16 Apr 2026 19:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0D5C2BCB0;
	Thu, 16 Apr 2026 19:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776366658;
	bh=CvSW1KMGTGHws0iC4zpjF+GxD72r6mU2H2BGcWbBFzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AdDG2SEq7V1073NS6t85buzovap8euRUdz2Esw+6qwP14aD3sGgTpoHPKqECwi0JF
	 cHReHR8B3J1Np6Plvx7s7cwFj7KhN952g1+qDbcsPr9Mzsb/kH85VGJzk5531JaK4u
	 cO75R2/LxszuxB0eKh8h+ifU2Ttw5MFcjcGCyAvIWO4VBWnF6hOr5IeE7uaB515fx6
	 Y2bP/5XuEpCmJhbMT+EGQPIaccJ43rP8xB2cV7tSQMD0KeezJfHWL5gpGwpSfU1eu9
	 vWMldU/LJlM6MyudCm0CEUnTI3+Rktap4uKv/dIR0GfkPZ3L05WM9v1Xyiy9Y+6vX+
	 DhwDW3YcUNljg==
Date: Thu, 16 Apr 2026 20:10:53 +0100
From: Mark Brown <broonie@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HEiFX0I1YfdPL4ri"
Content-Disposition: inline
In-Reply-To: <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
X-Cookie: Process promptly.
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 035DB4000D
X-Stat-Signature: j41zrnz4gfusqhdyxxctz18moapuyxt7
X-HE-Tag: 1776366659-325000
X-HE-Meta: U2FsdGVkX19h3C+g1k1FK/o94LxyXJ9dD9E8J858lIFRpehlc6TIu7Mwn2iZi7kMBNn22dDi9lzA6SUaeHvs1NkzF8EU1+PMvOBJdflAEVLbabl/kky4w/klmnRBhD5i3PMPRjmRebNQOFob3HxSdi31jLKqJ6ZvAhbsAYBsYPSdvpRsJ39b7KHeE5MQy/TJA2dMuwtCcxOibBJQVExI27nzve3A3BgQYvBOWqda+Yk+X+FBy7+6kqb+amo6+Ud/CLJ+ArTXQ2d8hAKYEVwTFfp8roZM24Tv/qtZXDNSvS/14ChWkNULMf3zeksU+3HYftZbfFp5dvufajFHwvvMp1Jp9VSv6aC6RWbvWr4K9I3zsH3ZhtwcPN2mXDN2vfFHpM1Qj1A2yT/beg781vUKC51hFc+e574YExmk1Xtrk6kLF0JjSJjGB9QKYBs69p2sTXuldJ+o8mV3qR8OL2a5ZLyryVHHVRsNZaYA71vbgdUznoq0NtPReeeXplYuSLIDHDV8L1/cJUM8rj1k4xUqz+Ej+QX3Lfh3UGV9nFOQDo7Ua+fLj90VtIPvxkXdOZ2pMrOK/dywDKmvoV6eZVAD+aQV9mqrDf8V4EOVZUB4knAcUrCHG1xxOrgjNvIUAwW7Kn9oLBMER/TkE6IeB1Hf7ANddMZnPHb6USysR09TpdmhNdKo1Im80iCJ4OPxN79XfHO4ng8PDNWpn5dziUsk+oOAQklxz8G/zfSt/dsJzfvWs9RYqN2wwIBDSel0Xno3RhbUPDHrINGTQFoK6aUNao9sjqhD4dGS06llxg4UaZjIZS5PtHLbspEgNVgiK5oWwh7QCvLJGgowjec2XXB4VKwHK/h/CiPiDulDzocLkXBwNh1I7dF/yt7AfeQiri8OF4MY0h45PX92BPYgZPqtyiihBFt/NKzrWj49AgeErVsJdKPzp/SZQMoj1+oy0I2EQLs4p2oNXZPRZJShYDu
 iNRdetqr
 AVMpEn4jxisdO/qZxcJ5t9/Gbd2KLYGCrB5924G6ZEuxuOzzfIbMJTJJqAr9GXXbhX4i+uzu6BEQOHF8178V7HVmzl29UJvInJyEFjbP5kXivyNVwUX/pEkXwbc6qC5P4wlQL9MIzBGwpK9Z4edKPkkZREE+8t6ieK2ONh5pz9h5KJ/QDjQ40EQZL0GFPWafNsPpDvaf4O6wOsaKxquCtIODrtr2OKjyo+IAV6GU9rNclpFJv2QelR3OGtjqCavihWLsPui/Lb2cgJoBQfur/YQaWMFgnTV8iUjgIqFONDLE5ZiUEmP8FNlR66TTGFfzfIx0fzFnYMnyXJtU7VQxhV76bXeAmciHqfjOJt/wnTKn6/YqacgsrX26fzJg2DjS5gGPs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--HEiFX0I1YfdPL4ri
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 16, 2026 at 09:05:11PM +0200, David Hildenbrand (Arm) wrote:
> On 4/16/26 20:40, Mark Brown wrote:

> > Several of the mm selftests made use of /proc/pid/mem as part of their
> > operation but we do not specify this in the config fragment for them, at
> > least mkdirty and ksm_functional_tests have this requirement.

> I guess we could teach most tests to SKIP if /proc/pid/mem is unusable.

That would be nicer, yes.  I imagine some of these will predate there
being a configuration option here at all, it's possible there's newer
tests that skip cleanly - I didn't look at the skips.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

--HEiFX0I1YfdPL4ri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnhNDwACgkQJNaLcl1U
h9CO5wf/ROdoUF0dztd3ovGRimBdfS51befOuahPx/FYaDWmtZQ6iCaEO2RaNiUV
Dy9zPJA/FtqH7R38JcoWWx1yORMifNLjPYn1lQLm2ZiIvoOt91vElmVBP/U1qidb
Khrp0gGkyCSA2umNehEbJD+iI86+WxdBsOOJmQX8kTB4f5I4w0vSAKNiAzg5VXnQ
+fbDnSTsAU5LS2b/weVz2bMTUOZjyHeMdYix+2FcIIo+3HLbZ8LqXD2i52W85dyT
utRCzoKjQ4G6BUzTHhm59qfIX1WRf6jfY3OG0Hq10Xj9CLjv3BLEdUuFYX+x6dzr
KsPvSE6cSmX6jp+ThYUUBH9J5smtqA==
=Z+Yj
-----END PGP SIGNATURE-----

--HEiFX0I1YfdPL4ri--

