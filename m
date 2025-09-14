Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA3CBCAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 17:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C8C8E0006; Sun, 14 Sep 2025 13:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD5C8E0001; Sun, 14 Sep 2025 13:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB9C8E0006; Sun, 14 Sep 2025 13:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 052108E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:06:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96BAB1407CF
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 17:06:17 +0000 (UTC)
X-FDA: 83888483994.24.57BE47F
Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id C22BCC000A
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 17:06:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=manchmal.in-ulm.de;
	spf=pass (imf28.hostedemail.com: domain of linux-kernel.bfrz@manchmal.in-ulm.de designates 217.10.9.201 as permitted sender) smtp.mailfrom=linux-kernel.bfrz@manchmal.in-ulm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757869576; a=rsa-sha256;
	cv=none;
	b=G4ljWzAXchjvb88XaCYzrUedtC4YuVXnJAXqxC7z6Ym4NK80BIwbLoWMW92uszCaA+3RwL
	M6xJYrIzk6gyp1Xmzkp4SaVkx1ZRzYg96ia57+TVbcRU24m4ui6CzJEYmjITCkloN9D6kk
	NGgEOoWr3B52ui9ZdJFiJWqT+5wB1pE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=manchmal.in-ulm.de;
	spf=pass (imf28.hostedemail.com: domain of linux-kernel.bfrz@manchmal.in-ulm.de designates 217.10.9.201 as permitted sender) smtp.mailfrom=linux-kernel.bfrz@manchmal.in-ulm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757869576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mCY7CFjzHorofJ89F2uXcM9RFrcQISKb9+9Ln9zOgO8=;
	b=zijKNUmuQxZMKGbyHQgne2B6Tb6rAglWSrU3LjsdmBloZnMyOOrY7ysaNKWHJNS5X4cszm
	FTPKp4z5AraPEDkIeJYSQyvTrxzolI5p3KsJ8X1BCT3u00115scEgSQLiHmkiXZU5KJxo7
	OwdAiJwx4lLtuCimK8jJ3fNY8wey5RA=
Date: Sun, 14 Sep 2025 19:06:12 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Helge Deller <deller@kernel.org>
Cc: David Hildenbrand <david@redhat.com>,
	Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Memory Management List <linux-mm@kvack.org>,
	netdev@vger.kernel.org,
	Linux parisc List <linux-parisc@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
Message-ID: <1757869448@msgid.manchmal.in-ulm.de>
References: <aMSni79s6vCCVCFO@p100>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yGQQKzeyEZMtAyaE"
Content-Disposition: inline
In-Reply-To: <aMSni79s6vCCVCFO@p100>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C22BCC000A
X-Stat-Signature: yhd7uoi3uucy1z98s4t1fzqyomxag133
X-Rspam-User: 
X-HE-Tag: 1757869575-467663
X-HE-Meta: U2FsdGVkX1+ugfRA21maNdTpdHUlMe+dVLfGJENFWAyFgC2ywluKAW2HhaS6eJIgmC1UUH1++NI6/C7DXqyAgUwI8Sa4Lxz4EU5eeCMp0lgY2lVipPTleJm4ujWbMjA4pNbrf/n8afXOt+qmhCT7hnGXjvzSKzhEXzk2jwqLkN3mo8hfl3j4NaTz0ONwIid0Lh43+kFmGNAvfUgLyPYQg5tH02e9zygvoe2Mh9AemmwDG740TwFbfbK9z77Bh0sBxscIVMz4ybI/0wNw60rx7S7VCrXS651ptT+H0jqWqvQ3qkj5+pjf79BRENkd6BfMiZPmBvfhI0Xv6RyPOyJk2oH2ohrHyTXPlqaNX6EEWifRJkPF3lvivr4nP8RDWATK9EBF0S6n8h1+a7wyxwG2pP5QLYlEkjkxu/xk2L+m6G1Hk0/FRXtKqrjnhmkL+nVtAVSbCsji5v6v5UkTVhaMEWkm66GJjx0yVY0xJDG2wtI8mSZdBwL00vj3CoGVMEt53/Q34S1b9zi9WidUQHrBZrhPw3Lv0nL7vKQgNEmJ4XfBEWwlx4mnSTUfEZXyYtWk4SDH0wizq1trKw5H1WD5mmC3sSYz0nFnAuUOFQls6vLAfjDcWpXVIB/TaHOsFjAvvfjBAj41Lx6pEBcGLzQAEyk4xP2ePTXM1l8cfRsiXC8393bQsTkjL7Bif3nKsEt8vDaC4usuhl9qD+ECigCbffjjmoIePTVQIBl2z/WEHYsAC8IHAaTuF3TG72VZSq5aI0jvuF2rtKtlGqGFTFTaCMOT8JsfQSBDxwtRviDxMbakrJUCjMt1JLmlbfZ5/t2GnzQc1vjgcm3HCPyK9E9fu/MvCglCLrVz6cX/29f9jaWF0xnDFKrgZdRHD4sZRRknmpNZUaxWfMIFPhPYLagkMyIdMCEF4YACH2KMOnf3RDwz7PNhgKwrCrM2hviHvZwH0MELW7lHtKLPM8HQDr7
 vk9RsP3D
 pYemcSVM9f75WmX1tj9Xp6Do9RFsKy9eES3g3fK1+RMe+JgL2qlEIEnilfD4pIQvj+1eHmKAzJCXiiZQK2s9sVhIuvxcXYBn1ohQBBnscQcf1hEBlls/1gDpeQITlzVGSULa/jj2wj/yyHySfNRrj6HdKF63p0MdQ4iWyXKO+vL2JAziHhVCxezxEV3SKkHNb55KqyryRqKBoyTgLrDwkqYiYFpUOhhK4QVxr47M6lkU0oosjrX8D+dGVvFeTybNT9Wn8++VEhiy31Lk2rYol7KHGxwm5H/VNdNCQF6n+oFzJXsmukPKHvy3s3d9MYQUCBhpqLZmfgHt+0MduKfrVlLN4Hr6VppS4T6PI+32arCWQldcepYI78+LULOoKVwSvG05OVDJFlwNJrkdONgt7u6uNbz89EK8Uh66DQUToj2xmT2IMw3oPSFn+lZw8uPGlc+xJXuQewd3c14VbzcDexPPrsiZ3ia5KgOeIiR1dJcRwqiUnuHmQ5Ok40li093mgcajN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yGQQKzeyEZMtAyaE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Helge Deller wrote...

> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them wh=
en
> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c=
 on
> 32-bit platforms.
>=20
> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page p=
ool
> pages, but the remaining bits are not sufficient to unambiguously identify
> such pages any longer.
>=20
> So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
> pages and as such triggers a kernel BUG as it believes it found a page po=
ol
> leak.
>=20
> There are patches upcoming where page_pool_page_is_pp() will not depend on
> PP_MAGIC_MASK and instead use page flags to identify page pool pages. Unt=
il
> those patches are merged, the easiest temporary fix is to disable the che=
ck
> on 32-bit platforms.
>=20
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Linux Memory Management List <linux-mm@kvack.org>
> Cc: netdev@vger.kernel.org
> Cc: Linux parisc List <linux-parisc@vger.kernel.org>
> Cc: <stable@vger.kernel.org> # v6.15+
> Signed-off-by: Helge Deller <deller@gmx.de>
> Link: https://www.spinics.net/lists/kernel/msg5849623.html
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them wh=
en destroying the pool")

Tested-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>

--yGQQKzeyEZMtAyaE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAmjG9gAACgkQxCxY61kU
kv2OKg/+I5r7SmuFKfUeJR8lmfesg5+t/EObRKadkYWCImIHaUX2omjB2mblcKP8
3HrhbTGSJvEaqud7y12GGP62Q0elxTUxBQmjedaIibtL0oknVyPwiFrVGrKQ5nPR
Q9DQNFh6GEIiiME2uWh+gmc2lVz8mLnrxtZj/eTlNXYCRwKz9GgEgOVEeJDSrHNE
wcFJQH5Yvteb8n3C1opZNO2+uokGahlH0OCfEFZsGvaFdvusRgTAlyNyV9PXzAlM
okIqWJv8EABX3Zfl8+GA82FSTGT8Bn4sQRu5IrXarzM2POw/nlYnQP36RJrFe6M0
9tFkaLTcKaYWhWSZ8YxtfWjbGufGYNhikqgL5w9MSAeH3twAGGFbx03Q0dzUT8XC
xwq0gfQqGagnADmtvHXF40PTSjeb98El2QQ/Vz/fV/dfJcn6EbNjzYraKtMuMZuX
BlI6wxJEaj/PaGjpPeQ1FcMmuJYSbW/6TKEB8gD5Hgmh0ngbZQ5zJuM1AR0Oe/JZ
mhsio08zmXM8A0wIvWXFsrXsXzSV3hXn9I+sn4DAMz9gx3+O/Ek9/wbww9rcA4lH
DU/zroDnn050JvMJZr00pCFmYeBuvy8cWE3sh6tgN0kdSRUPb222KGLD4dZxfPag
3LuZXw/cgYGtMgw6RxtuiY6nfrouzsYLrQJBNoseZTYCn3VCxNE=
=Qki2
-----END PGP SIGNATURE-----

--yGQQKzeyEZMtAyaE--

