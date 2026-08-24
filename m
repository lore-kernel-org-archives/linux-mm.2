Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD77C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AF8E6B009F; Mon, 24 Aug 2026 08:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286D76B00A0; Mon, 24 Aug 2026 08:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175896B00A1; Mon, 24 Aug 2026 08:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E66FC6B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:28:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CB031C0089
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:28:04 +0000 (UTC)
X-FDA: 85136090088.11.909B00D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E096240002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:28:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qeu+Vvyl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cy9l3lM1kbxMRijBR1/D17zWRjBciAMYYTfa6ENsams=;
	b=C4vZPkyfmHYIgK46/MTZ+aP4QXoIKvkaD9i5FaIxq1eWHzVyg6tKYF9fgrhalOjmBF4Sqa
	qiiu4zQfPwjQ/dxQEtNflCR7g7ozkHvVkQk+z6LzLwimOuRWSguCb+G0M5xVrbwm1qmYOw
	la4DSMMWqpBUCG5Cx1V+KfKvGvXaCwc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qeu+Vvyl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574482;
	b=sHuKdNeYG//7v5rqmjKxGKgzcqr612+Lmwd3fq7kl9dOWih65IrUzeL+mSlcYsZbMOfkwP
	T02vlGGqwnD/kTYd8l9QP7CLTeaZKjBvtg2nmPMGNzHoG+0DLIOVx/GTuPbc/h3z3WmDG8
	hTGamuZ3YY9SNuip6Ll1C9fr6ycaK/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EC8E600C8;
	Mon, 24 Aug 2026 12:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B331F00A3A;
	Mon, 24 Aug 2026 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574482;
	bh=cy9l3lM1kbxMRijBR1/D17zWRjBciAMYYTfa6ENsams=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qeu+Vvyl5pqKuxqyyx4Gc3d089MMKlyjZ/CtOWRI3ygeOSM7l/Fwu0dbBlvCT9xud
	 YtPHE/mtb8o5oTLNr3mFMsZEXb85zNmH8jQXUzjMh1REb1AnJyZZfiHwb9gEZ+2WG8
	 4Ws52jpWtZtRiWoABAgc49LoyV8BblkN13xh2s+JomZ2elDWej86iFataMPjm2PYyH
	 EhLEp9zUqAS38xxkSJgNu2Dbm0T3khDIIkgXVSeXVjl91TK9lztvXhcZ9gKy1m0ZP6
	 LTIP8Pxg/MpPAdtcXhTJmczUHiyes38YXhA1lXX+lP7n+4a+dczYAgv4eh4QisTvT/
	 wMRpkBRc7iDpA==
Date: Mon, 24 Aug 2026 13:27:54 +0100
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
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
Message-ID: <e4f8031e-20ea-46d1-914d-005595243f31@sirena.org.uk>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
 <75738049-24f9-4056-98c8-b4075552ab78@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L/9r1vqM2aKkt3uH"
Content-Disposition: inline
In-Reply-To: <75738049-24f9-4056-98c8-b4075552ab78@kernel.org>
X-Cookie: Accuracy, n.:
X-Rspam-User: 
X-Rspamd-Queue-Id: E096240002
X-Rspamd-Server: rspam07
X-Stat-Signature: gtodsojuxzwixs53yq3j3hi8dezs4jtr
X-HE-Tag: 1787574482-139848
X-HE-Meta: U2FsdGVkX1+6/Il/FjHt2lBPTitCvzGAu+rTrNIxP8dTtHEsn4sSl33tAYL+vX1c06XJGL/qmqnnyBSR1Ca3oWdkgpe9AxCKBnSfal5s1IiGkPBp4QMEgHK0ovHBv5DbUFpdjL0ZAfV5NIvbUdjIE1axUHy4He42HkVSePqNZPs8pGfSFK8DkG3s+XW7MYsilSeRdSUH3b+wnkQBGm4tq8GoqOs9Hk7yLTDTDQr4RoMyj4yT9ZdqO0KhslDEZ4m48PBzQxdu9hZ9B758shTUqQXVZ6VylfJJqzbF8mjtZc8QB0OeFMd7T2ntAlZ3vYmLjauEkl/nDy9MqMchrlEc2DVw8kGqkANlj4cMahoCwBDMNkta9tEAj/jvaxPBtgZmh6KiQMJisJTHTzPy6BkKNHrLBTlK4iHLYvic2NXDs848VBSd0EZoDf91P2c4eEy+7Yi+Qdpi15q8mJ+1VKI758efHFttrH76xrpb/JJXgCbe++pq/mEpC6HKTpMTchBgV0f5pCdW5uYzw4EjzgfqHVQuCA15EHY4warBaCpA0wJ5Pq+DFgDss6umGFNBVXCoOnhmJBptSXLxD+4UGnPBS9EX8+tA2hOlAheAEn4eLMT6254+tu+Pqegd6lSnHQMNScl8WKad4sXN02HMgV+hiEv0Lh7j6QtthoMof/Xq0dq1jMK/kSYyJ+mvzZvMAA6EUlcd8DxSO+b4h2QzQwr10BIYcSMjyuPPuQmyMTIB0Qzb72zjzjvDxgz5V9rwUIZtJRtZA+j/muq66ZfEq9XHcZMh+3fk5CZCqqFrri1noj5Agw1a/iGx4sB5RtpKcOkIrDAoJ6j9lss597Eubr+4qW0AvqI8MXBBfVCrTDvPMlAj7kFRqdByANLNIwfMed9jAbtywz20ki3VLTmsbbMVKivnQKPJ3eVxil/cRSZ70ZtpacqnT6ici8bpQf3DQiXPmjpLnvdO2oftoPLfpT5
 b+Y/TGh+
 T0ecMR8iXnGnU4WHTha8y7BVCXNVCSXjsw0WrMZ+o/eVUmobChA05xyJjPGEwOh3vnsMef0bQMceYAqfADnDeV4Z0XkRNlui9YW7ZP5rQhfmZZ9KeM3poDCncKn8pGpQfPa2rLZzmjVRxg0LgNJSWPSLG3xL+oUWXGwR3L9bOtxqcIrVGmDYD38wBrBncozYnHl2oo1IvW7Whs2e9m86t7AWeqFvMw4OQ4E7FErSz5rLhfFKgkag4ZGOIAUwFz2o6S2v/fUiy3VUPCsRs98AY2gZbw5Xz8jFHGUAkIP466KYzJaF8W88UlNXc1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--L/9r1vqM2aKkt3uH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 24, 2026 at 02:17:03PM +0200, David Hildenbrand (Arm) wrote:
> On 8/13/26 20:12, Sarthak Sharma wrote:

> > +	if (buf[0] < '0' || buf[0] > '9')
> > +		return -EINVAL;

> This is to reject any negative or hexadecimal numbers I assume?

That won't reject hexidecimal - 0xNNNN matches the above.

--L/9r1vqM2aKkt3uH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqMOMkACgkQJNaLcl1U
h9CvGgf+O6xziDN2tC2WVmqshJiIPV2RTp+I6jL7UYGbu0/4SqXrGYtjV/06GpXL
XnqCVPhTbDWZdjCLVIxYvyIokjMuaRzRVVl6xGkwA6ynuBLRzkOv6vG9V1Vpz5mc
ZQ05N0r/DC1kHmSjwfi299fi5eHv6QCin3RDNMxG0NDXztSnw6A9tuKMH+dsZgdw
YHrYneZTcZUzGVopqKJijMvoUwXSi0U1PbVygYjM6wBrk1WhCBIUiR3SNjrb/XiK
XvzUl+tqMHROsxEik7UN7+NuH8jdQyYVXDnkU3LvBfFQmGnnDn2TO3KcxZQQZXJI
LvabEh4JA37rsghLhdN22otZ7sYftA==
=pTvz
-----END PGP SIGNATURE-----

--L/9r1vqM2aKkt3uH--

