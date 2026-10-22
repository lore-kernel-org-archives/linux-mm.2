Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5E5606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=hgC3wTTV
Received: by kanga.kvack.org (Postfix)
	id 901196B08D1; Thu, 22 Oct 2026 04:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B18B6B08D2; Thu, 22 Oct 2026 04:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6FC6B08D3; Thu, 22 Oct 2026 04:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4666B08D1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:20:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF1D61A0759
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:20:42 +0000 (UTC)
X-FDA: 85349565924.12.AFBFA4F
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18ED640005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:20:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=hgC3wTTV;
	spf=pass (imf01.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792657241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2otPSQyOzqjKfgmJ37i5ezI5QcKI3c1tok4QLLHQ5dU=;
	b=0hZJs3+BVX+57UZqW9QJFbOsZgKkxxq7N0yOvU8LpZpN3uXMfuJaMkw4AzV80A0DsfTEmz
	m5oAqoljjbXZzY3hkoTGOi4Ho4+juK2wUZzbXMdqFta2KxSnBP+hhdJbbdC3l9oaQGVarY
	16qNQu6FcM34AOthXk2CTGiBkjEbxgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792657241;
	b=nuLPtDiqCGN1Yo6zmTKvki+9gzCz/9X3nLb/DRYgka+8hAwsDVZXtYKrYtvLGf2jnCOLaD
	rqCdDXfiTSVnCxxOocFL4iK+ekJo7qhUcnd8XsDJGdnLTMRLB1/ms3yaRHYFTGGoEeXBla
	FYZ1rWoSAMXYwA1ZHwzIwQpqK4xz19I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=hgC3wTTV;
	spf=pass (imf01.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
Message-ID: <bfad4b87359161304015b04cc88f15cf07a055e5.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792657238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2otPSQyOzqjKfgmJ37i5ezI5QcKI3c1tok4QLLHQ5dU=;
	b=hgC3wTTVZl6b2UOCDz/hk0hOx81kefMFmcpfutss1tbAMk0W/Rze7xH3pX6mY2N7uRk4Rx
	GGMzUfyEm7FBn+ccwvijPYUvCWry+ypljW/yfDLcnuM1X7abswRJNX9Je1sNr5t3nIIDby
	VShSW3p7I1lVg7UZqPaf+fmtxTiHB9Y=
Subject: Re: [PATCH v3 0/4] sparc64: D-cache alias flushing fixes
From: Stian Halseth <stian@itx.no>
To: Imre Kaloz <kaloz@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 22 Oct 2026 10:20:37 +0200
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QxkUFBLgW99UfyzqZm2/"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18ED640005
X-Stat-Signature: zszo5iaw8dpz174ako8bi9r35jaugs1m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792657240-533782
X-HE-Meta: U2FsdGVkX1+j+9Pg8IGHiiMCX4K7Dm3pJMzkq5up5NvYvM43rigvWrAs8Qu/6B6BflfePhQ/q2bqj7cf0CFhRt/JNq9R1sYEEWlpVT1peXAfYNDxo8PKvyntUSgM3Li2xQt3+RSxruoZIFXsOYHZzbLW4yGYfzjgXniU5UHz/B+qSlDdcSi5ws2TU1jdAeFmOgW80HG64yks4AApQWHuoAm843BU4YR0yc2847ABDGnZjfMH77TRJGgP3dM+ik5pd9aJcP2AwhKHiL6UmJwLVAWVrTV6/AeTsp7bjCUiamM6YMlAZubl4B9OgzacMLB31RfDkc4glGF7Qs1IQqMbQ85Kqb8Xr3rZRjhqfKWsrT0jyPiGuWJNYnrnkMk7OTh5F0+mqPzwos+RWj+WtfFi0z+UFXNQWdiF4RobFt5ajaArQGi0zfheR5MVLdd/72NDHeVrePb6GItgmyWv9RPOzYdP0DmApgyyotnQMUOAFVhKPGGDUlEPKE7UY65dg9VD1TQDVoTXuXlxDBhyIRExmqyMshJdPt2lWZDWbK4xLxcawUOvwFrnhe3S4m1/vhrD2S3keLGJUVTF6Pp7PPSFAvMRrOeDks4Ex5DyhBEA25Enb9gyJelBCDd21gDamWPLtSf4UtaqaqpCX334LoGxNctT7Pi6hrN17cCgVmALpF1rDNJfuFCR5J9DGE8w3E+E2nq1q79HBFR8f3HlozyZY9c35p+DxOhmV5A9jlERwfmzuMVKMn+z/tYQ2ycSvR+hV/IK5VXXDOjSsBOMplAMYB8qcsOBsx0io3tHrzOIqms6C1PPL41R5z4Q6zs3UXiPSqS81V7HydLJ5nv1FGKozrETEgqoaTNvc4E8JhQDbmo0Y4qZLhB7fU4qhTmJJFAAjlHc1K+/YiPyghrX3WyvOUe8TO1NFa8c9B9sycZnhsUXOqdVaivz4MIOBvIb3OlfPOUKUOaFeEGyh+UWHf+
 Mccq46s0
 m1bkN9/PUDtQhHXSNwzBnoUi8j/YmYunp+GE/zXk1QArEH7kpE6ckVnDaS4fJYEFnM9hxyozVktrPhafsesMwBIRpc0LLaEpb0p6qyD0fW7dPehCl7ozZVN9Ky0anW59iNxOwHeSq8yDlLfwvWM0ZFNzz4aSV6ikZPx0tmjBF2PgQVR2lQ3T8b6xP1mZpgRAYmeY2grwShFVe44+498qPFoFiME4ndTNPGJfKG4+Lgruv/yWcNuL7EJlN+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--=-QxkUFBLgW99UfyzqZm2/
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Imre,

On Thu, 2026-10-22 at 01:33 +0200, Imre Kaloz wrote:
> These fix D-cache alias flushing on sparc64 CPUs with a virtually
> indexed L1 D-cache (Spitfire and Cheetah).
>=20

Tested on top of Andreas' for-next on my V240 (sun4u, 2xUltraSPARC
IIIi), against the same for-next without the series, both with THP
enabled. The stale reads through a reused vmalloc address are gone, and
moving an 8 MB THP to the other colour now takes milliseconds instead
of seven seconds.

I also checked 1/4 on its own by booting with the vmemmap check in 3/4
disabled. The four cross calls from sparse_init() still reach
xcall_deliver(), but physical address 0 is now left untouched.

4/4 can't really be tested on sparc64, since move_ptes() never
batches, but it builds and nothing changes. Each patch builds
cleanly for SMP and UP.

Tested-by: Stian Halseth <stian@itx.no> # Sun Fire V240

/Stian

--=-QxkUFBLgW99UfyzqZm2/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCatnHVQAKCRDoeAEuJe36
VnVCAQD276eDVP9yACZ0pHZnP6jdzf1PGdWYtFTac8LQemBX7AD/Qz1ugQwMouHM
/gljtdjKe4FbEKl+8N+lDB+fTRVFSww=
=yzu4
-----END PGP SIGNATURE-----

--=-QxkUFBLgW99UfyzqZm2/--

