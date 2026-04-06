Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8AFF46C5A
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD4D6B0118; Mon,  6 Apr 2026 12:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DFB6B0119; Mon,  6 Apr 2026 12:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3744C6B011A; Mon,  6 Apr 2026 12:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24B836B0118
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:51:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4FE1E035C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:51:43 +0000 (UTC)
X-FDA: 84628722486.10.7247134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14D25120009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:51:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1wCQEax;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775494302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpQ+nF1UYQoeBL/LLUra4z3jUi1UpdwVgKThzgblpnM=;
	b=yQbNAe9FIQ16sjmLNNUR/lc10NydwjXRJzfjLT/IZjtaplMz9mCGEmSb2sLhmh4lWIGhO3
	kC/e0WZncVVdNjPU7ke69i2wptbAMaf8/xk6LyBP5q+461VvnhnQbDmOn2yrB9+HR4d8if
	p/6tjRTQhYu2lteGgB4vId80EvyCezI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1wCQEax;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775494302; a=rsa-sha256;
	cv=none;
	b=w2fZRqvrg8mKrkhCy7Y+BcpvMjhGEKqT4QBzAs6eC9VQO5cSRFZ4K+RQrAJPbSjSZh0nCi
	1BCHEz3leRzN8E3wTxPPsI8GRY5dvN3gh9HurJXHfPl1r99+3Mblk/uaiPDY4ywVVnaevj
	+ANILXfTDZpKd9IucZDRFL0CMCuRDIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F21260126;
	Mon,  6 Apr 2026 16:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D004AC4CEF7;
	Mon,  6 Apr 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775494301;
	bh=KpQ+nF1UYQoeBL/LLUra4z3jUi1UpdwVgKThzgblpnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1wCQEaxYvxJ4UK8hMu3A5e9XOD11z7L8jfBp8/tan2Li6rM6NvH0t5Aj9PAWpFJH
	 o6xlVdL9G5YMPKGS6/3ff5PSyRqiuk/0EiNYnxdgaDNJi28H2WypqBuo8mDiK+IsMX
	 RZorqq1Mk/ATutfg1BWZvfKqzbIFBNc6d7eYzmKbINNwafQ03gCTveql4k2gNsNOiW
	 K+BQr7hBIDbUdfsJFScblbllMAPWyoSEPpulN+ELyiKDLBhlOAzGE03Ujtpfr+M+XV
	 ldB2cWD+Um4CEMzuP+8QpVI/bI7/Uy+4+x04Vg3ih1TLiFmsZwvCVzsaf9teDNpo8Q
	 ZZYqlm8CRgmJw==
Date: Mon, 6 Apr 2026 17:51:34 +0100
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
Subject: Re: [PATCH 15/53] selftests/mm: protection_keys: use descriptive
 test names in TAP output
Message-ID: <274d9c8c-ebad-4fea-a9ce-a4e7f1bc4f2b@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-16-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ap2wh4yXxp1Kxaml"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-16-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14D25120009
X-Stat-Signature: fopcm5c3qyrhce3iptnj36mk3zjhppi8
X-Rspam-User: 
X-HE-Tag: 1775494301-669371
X-HE-Meta: U2FsdGVkX1+AXk7zjBXE5VT3MBNZ2Vv4W/xS87LKhWSk6S7zNnL4FL59ik4lLpusDIHGo+uus4w0EE9gmu9l/8stEadqcsjYy4Br8tI0LWGx4cY9/uqc1vAv+6rXJHH9PFiQryi3v7+K0ZgA7Ki1XmgsFsi12YQxLMJOhVB+2z7Xw+FlqEsLDB+dx3au+V+/ZWSW6mHmhuYmdHNSW/oo/vKQXY+qVnr7uDiOsiS+cTeTLDm96k9FZHVNgq6w4N6QZ+n4I62A4HwWGDB6oqZDXKxuUKpfPFNkQjE5jMYLyIo5BfNAfBDXxG5hYQ004JLkHKirgaPmV8vB6U+MykCpcPe7bE0peug+qM3czOu9k9smsiLjYhuxSyd3OSmuXs/e32L7jjkQcLM2YizM9rZq+9i8v+9bxFsmbgd41L+vvcVHYJRUOOXQte7mxhgc7vkYmK3YztbOLqw/BmOBbw7TOKGynfHF1TsRe7wt9wMVcKqDtzK12+k47eHwmOyQQhdgVT8Ou1NEy97ccPlYGio5oQphUiauzPqnvXIqtkvGvuWZkPjJQAjD7eg1yVEpb/saOfrYIFRqblDXLdDfEDMEuDgW22DbBkFVzsf4fuc2AuaAgZGHsa58XMAkyU+hpOOrsLzOHDZeZx6qywWSMBECLEsSqGc0C35ENmEaujnPcpq4VFH24XLTm0TvXo23lPejS6WqI99/qutupeXN6ycAZA7wd8oHBb72a3F/rHp5C7S2nnxD3BBmj3egAWsR//bGe5oPAOombSFxqtZJ0sGi+Dw/+QkFi23/cxpVaHiGDd128teCB2Lzoh+XKKQR1JXw5vBeRmP1Ab5UxbQTU43CSOqWHFYxC0NQi41TZU0y28klY/NvBKBNVGJGMPfT5/CwmAEqvEmTlKFUK9P/LmL/wlprhQsLSg3TaIfwBO/Usnw69Yw5zsoIO7eNDoPtAz8Lwj+9nNWqKH3NtlVAmJR
 f9gWdiCb
 TTj1b5fGilNdEEeRP14izUlFr2Wm7fqSvaPtENQs0vGXbQVLq/aeFeNrSVmhI3baItzeiJFM3zhBf3QWt+vBFamhxw1JbpH8NoY3jXGtj+CnCKyGJi+Eyusa0GTj/pTdEcfLFS4KVU+Cl97OlOoLPXbSD9nNQEuUmPHjBUxrlYo4IOlbjCK3wrQm2ZI461smCuHkhk4eFNlBzDyYVyLu8gEpWF4x+wNA7D74HeBhp9rv4dGBx4K/EI435UImDTP6T9eXLlt89XNRfpRcU6kOISPACvo09W9wck+BtZGdIIE4h2ITLjc+F3zYKZXGhAqzmBE6BzvwTpC6coXgnd/ZzJkBD0t3J4aNy0NpSndmNlXPQLJn+NlG8uWa+uk8q3XuJ4KCR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ap2wh4yXxp1Kxaml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 06, 2026 at 05:16:57PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Replace the numeric test index in TAP output with the actual test
> function name.

This isn't TAP yet!

> Use a structure containing function pointer and its name rather than
> only the function pointer in the pkey_tests array.

Definitely a win though

Reviewed-by: Mark Brown <broonie@kernel.org>

--ap2wh4yXxp1Kxaml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnT5JUACgkQJNaLcl1U
h9DURAf/d5nVR2wkPpv96T/T/nObvpCeUkM4FI6CupWcpktcsVqzEeRU4N5kk1Bj
s4AtAPdskn0GcPKBlHKmYVK4M8xHfZvbGKQwFniMpCMuZ0POUciHyHpt+rDAw6iR
ISKMqeWjAHEX7TU9Krg2m7HDx9DDgumwDQzKmpSJ5wqeiR+OQIaU+G93bbwhkRmD
teK4DpxKNsTX9LFNgxatffnBtQmAyv1WmMO8Y7/h0eeY2OjQCg9vvPAsbgtZSCmH
hMC0hKAGNjQ7OlYM9AOfZ8tdFAODEKajDPXJUQOz4WeDtTy7MDqYhQwImHnDIFbP
btDe5BYqPoDoDydXals14k72h9Dx0g==
=4t+F
-----END PGP SIGNATURE-----

--ap2wh4yXxp1Kxaml--

