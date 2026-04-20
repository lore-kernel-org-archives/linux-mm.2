Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9733F5A8A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB976B0088; Mon, 20 Apr 2026 14:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA5C6B008A; Mon, 20 Apr 2026 14:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B916B008C; Mon, 20 Apr 2026 14:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94756B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:11:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 937361B90C4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:11:41 +0000 (UTC)
X-FDA: 84679727202.04.042B782
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA1AE8000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:11:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhuGBP9n;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776708699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/59XhzYLd4tl2wZRJGM/xzTaIZvDgGZoFDmHGkV2iTc=;
	b=CQ3j7mOY8EO62G+mtBCj0gpFYojgL3yEzdQfX8Gu0CQxdpjG/FYDU6empyOtmSnYn6AElE
	0vwQom0a2LqIG15kI607xECuZfetudEXrce/yzGrCsT1RoGnRVajZVbIF1SKGn+X8ZXCjn
	PBBRRe+s3XjpO0NhOzLxKeTNQj+rU/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776708699; a=rsa-sha256;
	cv=none;
	b=7BbKjqbFpUkxLy17jA8ou1vYUsCtdQm3C+UWh04flsbXFiU0H8m5FRG5K2OT65NJn/cGCU
	A4XNhXJL33njxspdedtgzURS0ZRbgMeYMD9QHllaja4DJordktQVCkwBLEfJ/vksNb27ra
	AZLU0h1nmnhdAKfdcYO1IHGumv17MCg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhuGBP9n;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F0CB40946;
	Mon, 20 Apr 2026 18:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9165CC19425;
	Mon, 20 Apr 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776708698;
	bh=qLOLoMBkDkZ0pB+x3H6AU8n/Y9slQg4Fo0juZWlHZyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhuGBP9n4ebMzQyH46grk6GgVPBNJnYB2pFgplgMMwsLHJyX4v4bVgdT9+q7zw0Jd
	 i0MOqo1AQfBTbZqghe+Mh6TR3Usiv4vnKRhRaDNwWGsosoBF7l2RY7uHPzw8+4LjX+
	 6pAfORz6M93b6E6KdsiBnDHmORyZQoXLjxgILuTTRozTuCvB3oE45+i3stCnaTzfKx
	 O9EiEJAhGirEBvmNkFpQnqpzj9uEd1Yvkt5wemo38rTRsFTsfxYQk1QcRBG52WqSL+
	 vMf6d3wC6fVudUowFIHYDqadS2ZwWVhgd9FQITKIHT+rhVGuSDPxhblLFXA9q5Pm3V
	 tiVL1Jd5lQBjQ==
Date: Mon, 20 Apr 2026 19:11:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 19/53] selftests/mm: va_high_addr_switch: use
 kselftest framework
Message-ID: <2abd2a19-08cd-4d6b-800f-24e42a66f00d@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-20-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGaPlC4M7Ms405kW"
Content-Disposition: inline
In-Reply-To: <20260418105539.1261536-20-rppt@kernel.org>
X-Cookie: Sales tax applies.
X-Rspamd-Queue-Id: BA1AE8000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 8zqr9rksn9r1zg8oqo5gsi7o8cinpguz
X-Rspam-User: 
X-HE-Tag: 1776708699-926165
X-HE-Meta: U2FsdGVkX1/PJ2qPpJe3bt2DoiQauPBSkdvyCO4sIzHr44NboyNq5QhP0Ac9O/dCXGtTNlJ/H31ibkEVwS1pcND630Tv/eCo6CZbvkJQCy/DnkYd08mKcafrpNIv8BOnYoegp1ItdZn05bLaji2SpgGTjpFAwxpGivJxN0XjyMIopvfQr/fOAl14KdDMOm+mX8t1QPzBRNCvzUS0WSmuovTgUTQkjirxL0yoe6Eo+LRfzYpqe83BLvzmFg8mSm90xVy+H8Z8Qznj6fynrw9fdeQR7oMEC+1l9iMctnxsKlO9FBTYfocsMQQ49JmZPugbgjVm1gY4VKitGc9knQO1h5fv4g+JTqeoTy6rxF+l6BDpsu5U9D/ujbRWV2rvUvkXGY9yJUrdOQ4IcL6plM1LN/iseAiTpsnH32NGfNq/bqcMn/jM6ynTwDswHfwmrn4PnvTpX52frwyUumlgEAtk+l4q6LRWwTKmNEsY4595yQ4rBWBp8Kwiweb1yQ5zn83Ts9GTx+ai1/ec0PprW4QpycO/GxYXQuAM7zyLAEwkh1PD0fOJVpFsKMaUhzhhcacxYwL62yNB6A/pdrl277AcxSPqqJBQbW+NQwLgoYo4rKdLt+qYmW9D1yU8GyTCG9sxYEU9Pkdatkfr6Zev/xoBAOqyC7O9YUpztloBzaGlA6ZjXFeYgHWJ19WRbTgTue/3scSuUg8gQZPWjnb1euVPAmrNMqGa4ZNroc9jFeI56flhqv3atDSU1QE2oM17CZYJKWf7L4c0AU61hdpGCo5KeawVGZtFaVGdH3wM4119ZE5ssGEB5NaOzID6KwyvMUY3o1OcOZpd7iFPn2iqLgH7hC/MM8zLsoWwYZPFRUvOgWHu2y8/aJurfzhw5RbFjI7HUh4CNpEbqKZGvbUFhStnir7caLzC1aMUPXru00PEflmbc7W2BYohmBHXX4tblyQ77UQbSUcR2f4PlOl7yW0
 fxHWMcKz
 5s+XTbAr4HE0+Zd19JguJMpPUYDIAx8YviReJ+bukXH9zAD8eY5t5T90KHUB9cYT9MFpozaUoidOXfZXnBCFWo57snZ7lzDtyYkfvz737RBloPPM+YOmlCEVUMbNjz8nz632+DCuzMIrGeRLWc9/GTTVkn2TdBYvsgQkWYEEouAb4WdxrhuzeVwh1lkMVq/jeR1DkguTUyjFs17p1oXVuTv5qFKmLGR84cE/TlDeSWoBboEeNNen6CH9vgPZm+c/V/hyT6DdgJBLjU9C0YlHKm94rfhaiTMduL/l0gFg0v24PRwXfqtQfiMU5sQO/Qqxw2Fe2iu4xkC0j+SvJdrwrnmbWhLn+tOIvufOH99RQKAbY0HI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--MGaPlC4M7Ms405kW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 01:55:04PM +0300, Mike Rapoport wrote:

>  		if (p =3D=3D MAP_FAILED) {
> -			printf("FAILED\n");
> -			ret =3D KSFT_FAIL;
> +			ksft_test_result_fail("%s: MAP_FAILED\n", t->msg);
>  			continue;
>  		}
> =20
>  		if (t->low_addr_required && p >=3D (void *)(switch_hint)) {
> -			printf("FAILED\n");
> -			ret =3D KSFT_FAIL;
> +			ksft_test_result_fail("%s: %p not below switch hint\n", t->msg, p);

The test result reports should use a consistent name for each test and
log any diagnostic information about the source of failure in separate
prints.

--MGaPlC4M7Ms405kW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnmbFIACgkQJNaLcl1U
h9Ac7Qf/YbGFkjLXCtCkUkv5NeqyfgkSPz1aVQhRjEfjzZTckZXlnW3Ike7z2Faw
qJCnzwwp6++nRGTUvo7CnGugOrtXoRfvK86V0rhJ/XpTehOijvxXk97KzKLT6M/P
iIE8JxxdLpJLVxsGHq51+zl1/wJ/FXQVt6knRVS9g3wy6PRQylMVY3hrxvFmd7pk
GaZ0sjBt0RC9m6wQVZJtG+aZ4fe5oyTmyhdjecfFKk/ogC28HI6CiizJRMSSNs/W
n1QQvdv6H1AP/4rMeTRjFe2hyOakCLlHPzI1atxVoXhcmAR7GxrwlszGle8CZIcI
DewtaLgGJzg7bct+d1fLtNy2RV88DA==
=5NEU
-----END PGP SIGNATURE-----

--MGaPlC4M7Ms405kW--

