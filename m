Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7C2CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1786B009B; Tue, 13 Oct 2026 11:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2256B00A9; Tue, 13 Oct 2026 11:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0256B00AA; Tue, 13 Oct 2026 11:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB0116B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:34:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 429C8A0D0F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:34:37 +0000 (UTC)
X-FDA: 85318000194.13.2E93488
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98231A000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:34:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=i4lCGBCA;
	spf=pass (imf15.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj0AoQXsnwESrz0SIkRB1YQ+B5vPXZ5e7HQiPxgYXXc=;
	b=Dl90FUrlhasAnkonokVC3MGcFAUlI/5IWVUrRTbnavChmTJDsBWwyZOZsaLYUu6x9ONpqy
	PxIRaSmpmSxye46FthnPEVFMms3sOTcwcWCUXZHrfRkAZm6y0VCpwJivgip7i7zZNb2PLy
	mZ2w9g1V4pvVgppqfnBVBDGV6pTpa9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905675;
	b=DKLoDCQW6ufOj4ZtUwBo4sQcoRC1IhvN+yxMabKdD8WG7U5AHOM+QukFSYanz/4705X+Ab
	NYvp+mDsU+U5xZg5tNbg/F+efHk7LKkxH73mirVZWmrELjpyHzmjAbio8eR1ZmeS/eQnQg
	7UU9Nb/V/9Dti2gfDJxmrJEltSq5g6M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=i4lCGBCA;
	spf=pass (imf15.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
Message-ID: <8443cc78cb8307716989bb462c1c948ae481d151.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791905673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sj0AoQXsnwESrz0SIkRB1YQ+B5vPXZ5e7HQiPxgYXXc=;
	b=i4lCGBCAqvr/zQc3OWo+5P8VT5gKoGiG5xUyTH2CqkDmb4KoDt4l1yfh+QDYfFbdlvr1pX
	wpUeqpF8Hl7axbHUf9VHzmvBVDeI3n7/aBGRC6jD+1LhR23b4eIwHIuy6trlNu3xZRPSrt
	k6ZZO7nn/Si+MF6E22xyQ+mqIP44kq4=
Subject: Re: [PATCH v3] fs/proc/task_mmu: fix lost maps entries above 2^63
From: Stian Halseth <stian@itx.no>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann
 Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Andreas Larsson
 <andreas@gaisler.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Tue, 13 Oct 2026 17:34:32 +0200
In-Reply-To: <as5M1BSWcPDHjEWt@gremlin>
References: <20261013152106.1834364-1-stian@itx.no>
	 <as5M1BSWcPDHjEWt@gremlin>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9BCL4Kf7PADg3yYOBgFJ"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 98231A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wksuxusfmdsjdoqxm97exuxktn7k4q5z
X-HE-Tag: 1791905675-867544
X-HE-Meta: U2FsdGVkX1/47GHJrjNxKKrzNbc8fzy0QrK6g1fNqyZSs5GkE3wRclxcsoTjnJVNissnGSmuWPNFShefFhmJuI2V31PJJMVKy8dwi6IxcgAvho+byfFH8EeOfViY0FMnB9+nzDCVtvfJRr9EhWz1LKkBUtQ3CABijaU5scSRWsyeJYnYXQOo5exCmpMCcLxcGv/Wiqb4WyH9LQokcgk4g+HyosDBl1Wh4edMFz/gY0CXilFc3spxJLQb1B87r2aCFHeLZV5AEb8Ctmgiw2pBP/Mwdmu+GQhaR5Nium7HdssLdUzrkwkvfcmprHW0tQ0Zah1W+nLfrU4v4dT+PkJ53yPTJ1+2eWrpatAGx5YAAsV39H+HQ7txTVDq12LNMCwFg9uBsd4IKLJK1DnleNOhEKWgpTv0POM8J8uqL6F57F9xG7QgYt9oB/2iz6okUvmj3fvO3oDIy7T4aquqq/xXwJI6ns96tIvSmA9fDlNefFfDl3J4lBuY2KbNwJGyIMborI5n6s/lbiltZjAlR/sUzPobkuk6FEhc7PSvOdczS7LV7cPRL5oc71AcPDFE6htOH7VgmkobUQRoBFkCAvKM05p5v8B1PLipChPspanPVzKUizpXUXI1Xl+z940xiZ8spL/LzQRPxNd7swT7fwO+eFiSHsupEOb3dJKth8OBy+FeXQ3C3vgAvETXI/dKwswz0deXFNrb0AlCkTCjxh2tMDe3icPU5hk6/x/s5kepoz5d47Nx07cbzcWKDPQ1vYW2wFqHf2AJ9aoi0BI2R5uNtHzdksglpcIDvd+Zil/gC/aeBLvR8v7TrjFpWDdynJe93co0W+kEVo5U+Z8oMmqPwKx+9YvR1n38amHgcLETOi+EwkgK+SaZyIg3M6vcUIKY4QmhXhdTBWImZ9mm1cC+7cmDszVou/sWraBNtorB2PdFs2vZiUXtvJMACxDh1AmuJwG5kDEn96a68LKtSGb
 6/xixXeh
 zTVdVimPK8HlFqNenojua/OjrlBwC1GcCzCmJkXXsZIQD2yYJfoHdRDQDoN+PwQrfGIrsqgZUSAHflnp7QLRZ7tuH0tNdybC0LLxtS8XbTvU0JMUSKVxZfFjr2D8RKXW1diKUGfQ5WjiHi9eI3Da6xC23ly32a3rTMrNM5srXalIQ6QaB5E2J6YDL0lvNYYPwiW1pxQlaAsI6LsOfpLbM8pJbRNVQVZkqgkF0yknTbEL0lH91FnDmgrbPT+21yypOHWVNcsCqhb7lZZL9dNLAdYYy20VQOwMoRSIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-9BCL4Kf7PADg3yYOBgFJ
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-10-13 at 16:28 +0100, Lorenzo Stoakes (ARM) wrote:
>=20
> Please stop respinning so fast thanks :)
>=20
> We generally want a ~week between respins for newer contributors. At
> least a day.

Noted, sorry for the noise. I'll fix the commit message as you suggest
and wait for Suren before sending anything else.


Thanks for the ack,
Stian

--=-9BCL4Kf7PADg3yYOBgFJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCas5PiAAKCRDoeAEuJe36
VkQVAPoCUzG8mmDrCFMN5Ein59AyWLtRlQ007GcgYwRGOrF9IQEAukcMXEHtB4NJ
oRJaaT7GOIwA2fTpfvtsLVydHjjb9g4=
=5ilD
-----END PGP SIGNATURE-----

--=-9BCL4Kf7PADg3yYOBgFJ--

