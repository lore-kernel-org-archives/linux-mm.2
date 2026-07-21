Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C7CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA29E6B007B; Tue, 21 Jul 2026 09:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C529B6B008A; Tue, 21 Jul 2026 09:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41BE6B008C; Tue, 21 Jul 2026 09:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7576B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:48:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AF2BA009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:11 +0000 (UTC)
X-FDA: 85012912782.19.3C66B31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 60867100012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlgzPEfX;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784641689;
	b=4JwFoBuJS1FPVssb8yhWmujnOP/3k7VymvKkhMlahuC+2hidl64YnjDERYVr7aFMks5H5U
	9zH2YiXjbQ3ApRlGxBtYflD/DpgxiJLhw2nEKXLXD+FyahrDMw8McGgauyUzSu9YbyvycA
	mRwHQygfqTKzQ7mIvfSQ4LZGrAMWY9M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlgzPEfX;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784641689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5BIL8GcU7PIu2AZvJVGpBFeKZjfYIY1PBCsqrQF8aU=;
	b=tKqYr1SXRJBrZ0raHkDMfNJZZ13shNi6JdDvCRWebD7d+fJxXjiKIjT/kU5T1xT0Naclez
	EJqOoTAs5cQWLKXe77NvhKYNFNhrMh9bNFmtQF3HIqroTSG83W/kixyg2Djlty+XccSAPK
	xW+GkvCERcVnnrLODape3EQEKhgqjEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86FA040B58;
	Tue, 21 Jul 2026 13:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925D31F00A3A;
	Tue, 21 Jul 2026 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784641688;
	bh=j5BIL8GcU7PIu2AZvJVGpBFeKZjfYIY1PBCsqrQF8aU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZlgzPEfXRe/kF/voTjPInaLpADpX44VTagXe+XdlnbQv1d4jBBApC35FXzHiyKPrz
	 RE/DEtL/jQFkSyJdLuv22nEWkRmaFffNM83Nsc2olsPt/zDYWsFNr9BfKZL2YV/UBn
	 1tCpcLRePHkyanLcZkYk64I+wJ7Eakrockij/+n6RhWz+iW72UXmj+VMQEwWDg9GXD
	 UOiB1g5BZAZ/XsK6j0/Zlh5mIDIvsZ3kQ7eRXTXw3lmCaZp7aOCgkPGoEwMGowcL6Y
	 AYnf2HTLg5c0y1bIdP3erIs/Fsy2d0lOSOki9+YcRF/Z1WA+0sh3m1YWwIE5Gqsrl8
	 Ycp6uIL4gVxlA==
Date: Tue, 21 Jul 2026 14:48:01 +0100
From: Mark Brown <broonie@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
Message-ID: <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
 <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="l4q+CPIb5QJ3JgXm"
Content-Disposition: inline
In-Reply-To: <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
X-Cookie: Love America -- or give it back.
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60867100012
X-Stat-Signature: bmncztnuiwoqq8andqn11g3nyr9mn34r
X-Rspam-User: 
X-HE-Tag: 1784641689-195953
X-HE-Meta: U2FsdGVkX19uQ1wB6To9OrrenNZUwbgSH14X1dpkpaFCbl6UapNA6ktxMhT8Gf9MZM6jX4YDNS2lX956ET+q2Lh8lc7LCIZ0dzH5j1RamdgYYf9et8w/PR5dbZS9A87AvC+n2//hyIhZ1CfJ6IYUEvlfNgRAVlFGnVwT5dRYRKXVAXy6D4URrHtAt9FZbnPcvftrnjBfIChAbp6ob0m2XSQwCLsVq5dTsBXKSgStN0ipZDItK67r7AAFrl1iqc46Zla3vf2Hd/aIAp0VwlvO3rKAB4K/Gm7+qB5fSWfsVe1xI3MA12kYI9Ja3h30bH0o6skqRTRS5hviUUUrPTEAXTcQ1SNsNovbXQJ8U6mYXOnxvey9blgCCx6UArN3blzcOTEyaWarQEHTRR83MW2k6vU4Ig5YwGjZQtq4mfLzoQzhWEA4ox/KCsu9yKtSYNY2RWOwnRVRdUvVCm0I8mvarG8andWnOgk1dfsnDyB6KwIY7EJyr74V+3RtSk+1WwDAc6E/IjxHSnAEmPJypdbAS28H2mIf+cKM6JxXONL7K8OzjHukD8S75+kTeXYb8PAzq0xOFIUFlge2Y/j0EL4CmP8e2pSYWAS6nIE1WCt4ocF24TBBWFW+94/xY7qdXXqGT1z7KY6L7ecZcfbTaXYyahb+CCHU1MxFWubMqsr5YAvYNDnAmKcWGfzOjGQpR5W85ivk5MXfdaVm0KVETJo4I9ytsXrK//ImYe0VU7zxzy2Dd7dmjRLFGqBxGUw3j/yCLE16r0ma0U9jBvIVEh45lGP3+1Y4kK7wRdfIfEgBTayPh5cN+gr6hN+9zOnHt0mKh/Q6GThiE51t9Cvx7tGPrvFV/cRAKKdamWcn8S7LWcogSvAN3hsAIQo5lSvK1Fz5ZrOnWQwlHllBzgiuE5mryghSICqWdjIP3Po9c7OFfOkuA5JavYigUAKYdshdW0gjES1ri+kXhRBLc12iW7F
 hDpYRGCh
 pwDB6HHU9LoOFkGJt+CWLbLppKbEBHIhQX1rmZvICI5UCgaLrbUuKxNQbfF2Sr/TCMLUaAGETSLSYeiLLoU2ZCY9akJ+9fP+yOnZw7WopX42dWQgaLFV9uuz3/iJBmGlX8r2OEavqu4shT7fE2XIO4hp9fYL+yg9kgUyE0vDY1vXsRo09a70KOOi65w2x0sQisK/NAG8cn2GxjfW+UJ/WZWe9nXFvcl/5PLnQIZk16IQy9hvdOPduU/bWrkObx5J7/udEAxPXTebfa6ZIPY/kLcq20LmD/QoEt8JkwBPF3UQ5BN2lzToh9Z7TLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--l4q+CPIb5QJ3JgXm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 21, 2026 at 03:39:09PM +0200, David Hildenbrand (Arm) wrote:
> On 7/16/26 14:32, Sarthak Sharma wrote:

> >  	fd = open(path, O_RDONLY);
> > -	if (fd == -1)
> > -		return 0;
> > +	if (fd == -1) {
> > +		int err = errno;
> > +
> > +		printf("# %s: %s (%d)\n", path, strerror(err), err);

> Shouldn't we be using

> ksft_print_msg()

> That does the magic "# " for us.

Or ksft_perror().

--l4q+CPIb5QJ3JgXm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpfeJAACgkQJNaLcl1U
h9AAKgf/W2P3L6gxIJBRCaru02ROmZfAkRbbWouq52Dr8KqswGFqUwYVsaxjUZ/i
nQmWqBmLX8PrZxIizVYUZZxouuxbOoMIZ7mwboSXE8uGNnJ6CFxo6KLWOlcLP/Xg
akDd/juu/5coCFmz83G9Cd55h7RhRJeYjtqiNa0lE8Dg1BfqWPdKgCNDBOYMXvEW
Vzr9istUMQbKxMkwaOQjd0bbnDCnFn4mU8Fyz8rWvYe3AyOhEDnns5FUbqxgOf5s
hVWS0dTEuAj5JPN936nNldLO+rB2X/ixuPgfQAE8BEzTIkXdUkRxXWoiUrXb+432
hYB8m91tLzFurVsSIOCzhEQyLwhrTw==
=aOKi
-----END PGP SIGNATURE-----

--l4q+CPIb5QJ3JgXm--

