Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BC2CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911D96B00A8; Fri, 26 Jun 2026 05:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E81B6B00AB; Fri, 26 Jun 2026 05:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800376B00AE; Fri, 26 Jun 2026 05:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E786B00A8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:26:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D22291C264C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:26:33 +0000 (UTC)
X-FDA: 84921533466.17.DF46F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 33FF04000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:26:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+gGMaTD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465992;
	b=hynIsDvkIOQokMYQCRIVVk9OVgxxus5pJqYAl4NF4rOkJ5pk0QrQ0UdXTmGhx/tnL4OlxS
	t9jE3hXvfCp1N1TEgaxy9+zgljZXrD232Ch0UDakCkNbOwpeM6B78zW2Xs3lOErDhCCQzP
	IgvwJcjjGOCWcBwG8DBLDiflr8o2Hgk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01m3+JrV7x8mtVic+JScx8nYqoYaBvDNEk9FDqRBYl8=;
	b=5LyriijzlbL5bUkVnSp1QtI2fiLfw933G2tGbcocAQY5a/brMVbcjDi+NRK2NOqquJty4P
	w3OpHemSpjgdqFhvmy7srucFL5r3XdZlYy/zAWHV9PMy8XYLyVlP/v8W6CZ4E0nraynF5B
	75jUNJVrJv9TVIoNrBH5ASffCQMbALE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+gGMaTD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADCDC60098;
	Fri, 26 Jun 2026 09:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA81F00A3A;
	Fri, 26 Jun 2026 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465991;
	bh=01m3+JrV7x8mtVic+JScx8nYqoYaBvDNEk9FDqRBYl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l+gGMaTDDsAyWw3kZpPgLMz4/yZwTquI7bXU9gw4LfXHQ28YVHfaFS1gFU2uAn/jS
	 T4QdliSEZSnYYgj2xEjgU5PPvYpNuHkCfgsChMBgJNyUsHINgcONm9HssLBa+DNMQp
	 yRtolTqFvsMYqalXl7HEmPbpseO6qlxZfrtArOdavz9GdCTS8Bm4PPYQmNAv0Aws7e
	 yAHPD6O3TNIehS5Lb1AywYH4akW6d/StxRESlJNr4ABjPxHAMPpGVY3N9LgQUu794a
	 0YHpou7lmPlAgZmY1icXHGqUgWtrPlMvwNOo5oGIa0QybpV4dUmjLttN15iY0Nz7/V
	 22hLBL0uriinQ==
Message-ID: <99b492bc-52fe-418c-88da-4e86bd7adce6@kernel.org>
Date: Fri, 26 Jun 2026 18:26:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev,
 jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gE6xfyk5b3YJWqjJKRgr36tT"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33FF04000D
X-Rspam-User: 
X-Stat-Signature: kwadwdy3juippsh56fajknbgyirpqjxf
X-HE-Tag: 1782465992-227393
X-HE-Meta: U2FsdGVkX19LrA1Jjo8vvYpFEA3oAr6swIzPfN2umdS68uQ96shRDG34QL64dA+byO8M2IFoWhzxxNGuMH8EPUjjsCDAs4eeBJAx3haR8jRdWGAHnnte11kEoRI9xE0ZYIzUAfVlsJCXsluAaGnOpFKgyO0TMIjeIBvAjdP2CxyaTFXJ1oPfk+PHtaIa1kPhAuwPgbDm+DaMcIWICD7UGYF52E3TAalJu09VMeiYzVwYz/yNBRr0mdW6b6VnaVu4mnX5recnRq6WLMaPkzXMIYNNzNiaDJiPwlQ+ESUmc1YVrMVDdjc78293Caq+s53YE4dUKpnBB0n1fhfalocFpdAx8ltiYRJ0MLkgMmlUb/5C2RToFPU6SkPY/MddWg9W5tPmsSNuFWU7axCyYuTFPI+H4n9/yqehNPZ6M0Rjwtbfwqyi3PEjyN2VSkg5+tN8bfgSjGAgqWVu6IP+XYIVJKvzR4uI5WjPCk+0BMDzYHJQgokpCo6lpwOQ/blP7Us21OKDKaiEbaN/7MBSzbuH6py0c2h+GXKHmcXiPLn9pHQCqH2+Sox2OGkCH/ukkrb5DbfEXO8YeFtztl3vu/i4p76oVPwmckShkFfBst/7+13j6tC/dE/pvhq09TAtndKAxk0N+RSNEiSE7z8ZrDLLsZ+BSOOIW3PqFQUK+4bVuwKtsHohvS51devbk+SR1FC15Vtf6juwNCbDCZwJfP7a0r7d1C89e68kn+TYr6c4ciDeQ7ZE+H16nuUGJ+m2mjv30CY+EguB9sHnzdSvkasoES1MGyM4fslPMdJ4MZdzyfsR+YbI6D9hmJ6iw78QzKGD5G+QscS/1sNHDCP/s33VtKvky8T/Crklf5QE6jlM11XriCXlxHKQ+VBe0xxm99k9XVMrqxdi04d3wV0WY+7611iHJgiUhy9tuDy8o3XtlIvi8Y/lYp586wgBpqtb55snm1KoAjaQO+TYPl0hs+5
 kt+HA5Aj
 rIFXjs3keF2Av9Jq5dSTJvsVyAgPcu3XojAHN0C5jn1JOg6dqbtyHLwg5oh9mMO9rxf+tkjAn3wYWBwQeDvKnx1Ixcftj0Cl9g70ywyPNnxfIM/WWMjQ7UU5eVQoJpeyikZovGhGYScLRTfr7vdd/GA6kVdCOTBU3SCfnuebPHONdF/eitpKG1FfykOXr/hjDonmFq77/BtZb3IsBbQ+UMaXASKdWo94R3Hl+ce/E0jm7pc6y9cMQjlqbkjlM1OjAwnhHcLfOPtQts0sugfO8FKVt67ZMUJGa7MPxDVbz2LjEWms6dvn/AB7F2n21LAnbwmseFttYwZKuttfPO2NJAJOigYKDG2g6c5iATb+es4VvUEQJjL78XAr8cj1U461sQk2A+Xh6llEKvJEgXeQ16cliBhGHlD8zFETYmGJLrXd+vg+zojg3ZxDOXFbVEa/ujFddW3HE2ytIHenmCnTPWdLdLENh+YnsQITt3GoTLz0doWJj89qxq47deQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gE6xfyk5b3YJWqjJKRgr36tT
Content-Type: multipart/mixed; boundary="------------xgyUie7mXHuSqSafgvREO57l";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev,
 jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <99b492bc-52fe-418c-88da-4e86bd7adce6@kernel.org>
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>

--------------xgyUie7mXHuSqSafgvREO57l
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/26/26 3:48 AM, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
>=20
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm=
/
> and additionally update the MAINTAINERS entry to place it within memory=

> management and port over the Kconfig and Makefile code to mm.
>=20
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------xgyUie7mXHuSqSafgvREO57l--

--------------gE6xfyk5b3YJWqjJKRgr36tT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj5FwwAKCRCGXBN6rc5S
1im+AQDJ/4/3Q05RgEx2et2igvt2pYusJSrt8UvfyTtiEE3C8gEAygxikW7+fgcA
1w/YWzNHmxD+MDrA8YEnpgpmdHKPvAQ=
=r1yp
-----END PGP SIGNATURE-----

--------------gE6xfyk5b3YJWqjJKRgr36tT--

