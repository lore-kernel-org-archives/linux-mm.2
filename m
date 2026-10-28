Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5E7606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=uUL+AdTg
Received: by kanga.kvack.org (Postfix)
	id B2CC96B05B0; Wed, 28 Oct 2026 12:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDA06B05B1; Wed, 28 Oct 2026 12:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F45D6B05B2; Wed, 28 Oct 2026 12:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79F656B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:52:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D000160197
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:52:09 +0000 (UTC)
X-FDA: 85372627578.26.6AA3886
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B50E40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:52:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=uUL+AdTg;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf07.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YA1pnK2XncY5lqNVKOymhfOhZgmGZ7s1l1eW83JveE=;
	b=nLQmHoYEAyaWu3oNyXw8wxAMxLKrlv2FUwqSaBhbPkPPcBFzkfBAPirkZGibxlgRNr8F77
	qPEG1T0uGUcixsmhnSX2PGnR3SLIg9u9xDVs4/BmhUkdoKHeWxr2tbq8ctC6wO44Wwkyho
	sCdwMeoOPHJlTvC14kdaqsVTdeGxsQw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=uUL+AdTg;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf07.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206327;
	b=8HMiBxIdTEqSAy/XPYeK0imWdKoZya0m8GZ3O6oVxmbgAQCPdPD/83raA+JstLYAtfJDm5
	ctXDziIqg0FAn2+nR6Z06yH+P9ikMun7tdRaprvEDlPOqqWmSJjiVPDDt401KSki2w/7UP
	mco1ghJBhsKJ1tYfq2iemVuo5FdqWSQ=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4jFD102sZ8zMllN;
	Wed, 28 Oct 2026 17:52:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793206324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YA1pnK2XncY5lqNVKOymhfOhZgmGZ7s1l1eW83JveE=;
	b=uUL+AdTgjM/9MiitX0whRTqEsijLx4C6KdxAhwRCKa0kb4eF0Sce7/FRtdiqf2XOzEBkdj
	p1g/KbhveW0qdGPfM04WDSHoIs6eUPJr3gwrhbkhffZmV6urAxgFaSb8zXDRRn491Bcj73
	1998YgkwZ3sEs2iPBApCD92oTVrYT701g8LIV4FO2QCQTaayhbVZVh35FT2/3fkzfEpN+w
	FBgPKyoMFdUPE56H6PeN7wv4KhcWdo584HvmGg5rAfhUCgDP0WpxW7h0HyytreXRGViHIl
	dHX1AlkEA1X54Ld0YUEkrKli/q4bDzbC600FPJIx8B4dE/bMkQX99lk9cuzWOA==
Message-ID: <1303b843e41498612cce4acdbb47941c054bcf7d.camel@mailbox.org>
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/mm/damon/reclaim: improve
 grammar and style
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: corbet@lwn.net, damon@lists.linux.dev, jm5905938@gmail.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	rdunlap@infradead.org, skhan@linuxfoundation.org
Date: Wed, 28 Oct 2026 17:52:01 +0100
In-Reply-To: <20261028000637.157110-1-sj@kernel.org>
References: <20261028000637.157110-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: jjn9q5xi6rqow5uypb9g11hnxcsctzaq
X-MBO-RS-ID: 7eb96ce423f99d218cd
X-Rspamd-Queue-Id: 4B50E40002
X-Rspam-User: 
X-Stat-Signature: nbccjbexpgydf4wqrr3tzjxqaurh7xx5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793206327-357160
X-HE-Meta: U2FsdGVkX18uT56CUBZHjQhx+ZWEHlloB2QQ3ZDybpXg9FCedY5WacfN2/ZPe2AsrBYJKV0wkjPEK9tb4xReM2D24y3iK6nEizyivwqbLi/REwXFNR2XZlbzg7OcnkyFmGxXEl+e7RhWduQvwOk69ReBNhs1KlxTbeeNkpInsfQHwfSczO7Z4yGZwGshxK4kzHlEuCEDYolkaiA2WvjJaljTejBu9zZSfB6PSmfYbUnnXHWP2SWk+IDg77UyZ+qTr19AfYNgxBJnvysr3WBjtqXt3K8wjJ3Q7LB/J62l9epGEPVRdU5I5mnyp8Sim9jXxzedyzm3aMHjMbrpdL5W3FJYfJdvvvFtfQIbE3D5vc27U9JuPMkaTGRZ/Zr2Oh6uODp5rL4LuJppp9e4NFqfc82UKaiLCi4pfkjrY5a0uQNy0rVyXXrl2eeFSnFb1dcB1yLVpIKt2vQg55OejZElptJtQzvl2RGOTh3He9poMDblPA3j58hCYebA7urwzD3+971Z+c3oTkV5EjOkbATIiEp7ZsYC7lhmm7gGOnWwRsC+IajcuFLM4+YmsvxWGpZn6fLb+9byVoH3DVwmtoXfPl+NjrSeI00/l1nAzQ3pnTCdVDnccodqNSK98ZSDWLBH/LWlLp6kra6qrWPgPP5vrvoirH+yKUqgPZtMfomx1QwariFUrgBF/xHtJ8HYN1Cc/o8wcyBe7Ydnj9rjt1l0bwud3CD4bDW8JOYJNSHFSH0YO8dwrw3ECEWljv2c2JoFx8MH0JpKPV+5o9inwqDUjvyV699xem+4NedYkt9SxjT3hrp61uU+2Rqx1iZQePCKZfVUf5VRFvIwsGmBHgU+G7MVCHLtaqAuWUWOQBbdXIEJ79Rui2kHz6V3M8qVQthdrLGwbID2MO8GX+b3le8WW9xNA111mvSASgI521zTkt5zQGl2MuAdX5OT/ym0QaWLsM/IupDgpppSXCVxBKX
 FmrbPwxx
 N32aDAJxFR/ukUtv0/6IDstQCO/1ZXl7/+dGOgm2ARoEAYLtyf/F3RY2Tbn3W+GJ5+cXtNXgUoyZPexkA2MTyAGTABph/9R8tmcIz6YQuas/Y9xshpUKG0Fhm/5kvSevqMoRK4bjuUpUPa4w+YUZn3L+GKCMpsT7WcRyu/irFSHlH5TgGEywk0utewy9ugLNCEIvHvLDUk6OYbeXwd8SJQRfbUxvciY8IVD2806PlZd4k3j0FW4aCK2ZKij89ZsFnZyqjNmmNjUVvyzTbA6Vfq5h7bTNXCa4xw61kAwRL8ab6MbS3IINOOBypHD8crQDGYgkzOb9IYneDt5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Tue, 2026-10-27 at 17:06 -0700, SJ Park wrote:
> On Tue, 27 Oct 2026 20:05:04 +0100 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > Fix upper case. Fix tenses. Replace 'set as' with 'set to'. Add space a=
fter
> > sentence to make it double space.
> >=20
> > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> > CC: Aveline Noir <jm5905938@gmail.com>
> > ---
> > @ -113,8 +113,8
> > Choose as you wish.

I will refer to this below.

> >=20
> > @ 20
> > should be:
> > -Free Pages Reporting [3]_ based
> > +Free pages reporting [3]_ based
> > or
> > +'*Free Pages Reporting'* [3]_ based
> > * the right kind of quoting/ kernel-doc highlighting.
> > Choose as you wish.
> > ---
> > =C2=A0.../admin-guide/mm/damon/reclaim.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 36 +++++++++----------
> > =C2=A01 file changed, 18 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documenta=
tion/admin-guide/mm/damon/reclaim.rst
> > index e4e2ffa52e..0bab2299ea 100644
> > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> [...]
> > @@ -30,12 +30,12 @@ guests could mitigate this problem.
> > =C2=A0How It Works?
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =C2=A0
> > -DAMON_RECLAIM finds memory regions that didn't accessed for specific t=
ime
> > +DAMON_RECLAIM finds memory regions that weren't accessed for specific =
time
> > =C2=A0duration and page out.=C2=A0 To avoid it consuming too much CPU f=
or the paging out
> > =C2=A0operation, a speed limit can be configured.=C2=A0 Under the speed=
 limit, it pages
> > -out memory regions that didn't accessed longer time first.=C2=A0 Syste=
m
> > +out memory regions that weren't accessed longer time first.=C2=A0 Syst=
em
> > =C2=A0administrators can also configure under what situation this schem=
e should
> > -automatically activated and deactivated with three memory pressure wat=
ermarks.
> > +automatically be activated and deactivated with three memory pressure =
watermarks.
>=20
> Let's keep 80 columns limit.=C2=A0 Same for below.

Okay.

> [...]
> > @@ -113,10 +113,10 @@ quota_sz
> > =C2=A0
> > =C2=A0Limit of size of memory for the reclamation in bytes.
> > =C2=A0
> > -DAMON_RECLAIM charges amount of memory which it tried to reclaim withi=
n a time
> > -window (quota_reset_interval_ms) and makes no more than this limit is =
tried.
> > -This can be used for limiting consumption of CPU and IO.=C2=A0 If this=
 value is
> > -zero, the limit is disabled.
> > +DAMON_RECLAIM records the amount of memory which it tried to reclaim w=
ithin a time
>=20
> Didn't we agree to keep use "charge" ?

I thought we agreed to "records' but I sensed a misunderstanding. That's wh=
y I wrote
> > @ -113,8 +113,8
> > Choose as you wish.
above. Should i have been more explicit?

Thanks
 Manuel
>=20
> Other than the above two things, looks good to me.
>=20
>=20
> Thanks,
> SJ
>=20
> [...]

