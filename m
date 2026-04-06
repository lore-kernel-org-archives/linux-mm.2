Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE76F46C44
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759DF6B0100; Mon,  6 Apr 2026 10:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3686B0101; Mon,  6 Apr 2026 10:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1B06B0102; Mon,  6 Apr 2026 10:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 478DB6B0100
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:28:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C322E1629
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:28:06 +0000 (UTC)
X-FDA: 84628360572.11.D99E1C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9447E1C0009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:28:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQD9n4RC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485684; a=rsa-sha256;
	cv=none;
	b=SQDbSMcwJg0+1ODmrcXzBF2jcI7iSmG6u4JtQoXC9x1QcsgyDLaeJtpOsIfjc31i5wnK4i
	H51Yuq5EE2kj1l/kQ7SmOJl62TnIObZ/kaaSfUrU12TMGVN0TMnE+Lam83hb6o+NlWhNF4
	79D2h8NVt0kY6PsRE/65Yz7qS2NhV5g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQD9n4RC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8Xi4s8iXLizZRK/r1OTp+Fx4n1QNttYePV16IrhLCk=;
	b=1S4q+j033GR5Zdf5npSBFaG+JUEvuUnyG7nqWFSrBd2xYiFEa/i5wEb8y9gZFQANwpjDMc
	BWTtTDGg0j8Smq5fgNHDO8p9TKM1Wrb1ZYw7Pp5HjFd2kKOs7uYMSzrjX82zHmgyfRcqIK
	5I83WXE/EIUL/+6lPcjogPnA7xvW1tc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9786943C3F;
	Mon,  6 Apr 2026 14:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C2C4CEF7;
	Mon,  6 Apr 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485683;
	bh=Jgs8OcyaNYF6N+1kAZCcYjNNqypzJ8NmBV0NzOlPQYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pQD9n4RCELRdVba2kMQkSyXgQDtf++kFban9FsTWhEPNtWk8XBv4Hv50YyIcWXKWW
	 k2aUlrPJnRh4ZF+1BMORV5+PsSEP5dWJQMxr0WmBDQndC/ElOpccsR9PwABv4MQoDq
	 Gr+h0KW2woti0uV8U2vwJ0Jep6d1dQNRafoAJkmTQz+xI3+MlRqDZOurUJ/rk45PX8
	 Y3HaZWKAbHNPFzDvwniINwiVeZfjj6eI3ANDOws8+pK1Uw+/HdZQu0Xvcf2m5Gswwc
	 ii2tTWBzTdVpGt0EoJA9MAeLAaImt7LaydMRExvFqAOPFhwMRNvjT4xLXmo1Tk1sa0
	 26eTuce+7N0Jw==
Date: Mon, 6 Apr 2026 15:27:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 07/53] selftests/mm: hugetlb-shm: use kselftest framework
Message-ID: <8fac53c1-f7c3-43dc-9389-07cb60fbbda5@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-8-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1MwePQTqQaQ8/AtX"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-8-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspamd-Queue-Id: 9447E1C0009
X-Stat-Signature: 33mipia9qybmpcq6w9p8omxsfccb3t1z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775485684-437434
X-HE-Meta: U2FsdGVkX1/B2zEG+mSDHj/tdxirnA9hYqXeepQkDZQ3fYDB6uY+E9BPHePKGIS/zaTh+yOtPkHOhxRsvfR1N33YqPl3cyM/zAolq1izNIYJof0pRaBhD+iLPMWHuNiVpKhLMBADAvIoIjVFWcwD6GKT8KXtKLq+UWHSn9peqUseUpQk/IbXpdu0SuC7RkwpmrT0EmKA956lS7ud+GrR4GK1xOyqCC3yyL7kHTXFgWNs+IbjG0Fnb6gSU7+cyiSxnvhtbhG2KLZVI1WuxI4cKFNqFYhPq/3iUXX5Yjnm64h2zH7Sw9WW7fU/aKPMGApC7Bes5PFX9UiADkhdAsKv49v2T2cqYURPXqS+6wfqBJFgra5Dlvx/VnAEnu3Eb0OkGF6lYQz1dv+PqPumZHvqMWjlWZ5P8hc/rAGtMdq80iPvH+ONdYbR9saEYS6mKLjc8SQfAo7ETpaYt93T3vBZ9i497ZeuK53ywQ0bLpvsuH114V6IwqwKMJWMFn/1SAtlMk9G9pcDToH26HdkDPaE3I5FwQ2gKH86JgzBvs8cPyQUmYW4HYM9q9js3WTISLC4FgIxfV8xpvzgl3clW+6yPhEJUq/+VhQhhbXHAKzo9PBp7v67w0oBbp02jS79AziX1EhqonjOlpmXBSaA6u0GKE5S4tZqKPRzZh+GFGqvBDuGnCE9JXi0e7p5vCRZQT/ZKEFMv8TICEUbHZ32bejVbG8d/gphNxvB9T4/tNFcJtUoAdSYZCJdsAVRYoQ0K5SU2GaaIl5aR4htn8mUqgCQL1zXIlD/HLcwQj8dTerG//0rd8Q0XZTBanaD+vustJDcoh/ezWEhk/FgBLT9nWnSiCYUAE+vJvTbZCVOnS3eyMRFP1NvUbWF2VIYibJ5K2qi31QthNAntVY3/Z9I+Lunu2BKgEO0otHh3SFjZLJxZzrhxl0vVyQRllVrt3BXE8pxgGLEpnbDJIvDCKrKsel
 pWjj+EXW
 5jckk+TsOA9YE2qOGqiGQcjU7Kav0x7ZUL/DsdD+Ykn98Ak9fjqwxkguE+hW8WXizGF8nI3FGvf1+gOzE5nIz80h/BBOOROnpsrQeoLhemtdtgSyV3To6l1qImjxPFEwU2gmqbANlMjPtFyzBn2pdB8kbx8HNahPE4SUvJSa6UIQ5As/If6LLWv27iS0D99STxMSleS+plJ48KKct+xrFw1Dck+7S0RYTMHs6ge1RGDAR4Lu7SzhZQxLPs4XidrwwpKMbzQOb6zHBQ3G0HmeDeI2ZWj0y52rZeeZZmbpGqoIwcB2guDSroJ0eEmID6RgFMkQYcerQ+KaNnpd9Kou0aVUciA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--1MwePQTqQaQ8/AtX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 06, 2026 at 05:16:49PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert hugetlb-shm test to use kselftest framework for reporting and
> tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +	ksft_print_header();
> +	ksft_set_plan(1);
> +

There's not a huge advantage where it's only one test but still, good
practice.

--1MwePQTqQaQ8/AtX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnTwuUACgkQJNaLcl1U
h9CBbQf8Cl2vPXTZJB8sRNcTWsB0R9qT/5VUc3ynOeQWV3/yZvAfG+ztF2cfIzyq
kxxdAgubXGfwFxee+9gr09hJLBTBFEt2y7yWxL+xSM6BeDqt0NA4xjeYW1ECUg+3
5STEM/g3eJiuxNOAYnjbquFE9GcKf9AyvHpPKGMnvADpNbDfYnYIrZ4u5Frkqh3H
6HqnaJ/a9xUSw7tNV3PbLdIekE4Ttw0SGpvO3TXha86ix8PW2GXXvrq3Qll6u7cF
KunndEVCG2GKjcgdtnBukVJA1BfIVhjQdBNW2yGoYZnxBuMVuRvLyYar7Dmg8T8z
dCCxEtiq3xGNm0mHEMHJPETv/pwAow==
=bzJF
-----END PGP SIGNATURE-----

--1MwePQTqQaQ8/AtX--

