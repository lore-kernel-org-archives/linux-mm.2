Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E10C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=c4YI6jiN
Received: by kanga.kvack.org (Postfix)
	id 5D70D6B05B2; Wed, 28 Oct 2026 12:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B02D6B05B3; Wed, 28 Oct 2026 12:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAE96B05B4; Wed, 28 Oct 2026 12:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5F96B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:52:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9165D14019A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:52:24 +0000 (UTC)
X-FDA: 85372628208.16.5AA7DC9
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA74E140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:52:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=c4YI6jiN;
	spf=pass (imf23.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSZ/p9sni9dlI5eyNVwd3UwnEXwjdQ5OzLQCHA5zC4s=;
	b=FZBJ1Sd1+1mhXriQz7ttUtv9mlh9zYf/vDy8q386xAo1gEAvElY+aL3MSR4iISR4B2oeBv
	2Ie0lZsDexhD52/1sBBeQmlVjOq7ZJ3Quav9G2wrUtJ0VlcJCmG1QULWiEA+r3Nh2TLqdV
	w89Rq8r0tpzVG3aZvC8hpqf7KpLBJI8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206342;
	b=crY87JuK9jtIMDvyZU3GEnvXf+Unl9kJDbeKP402xIH6Cswm2tn2b1tfthAn4pfeM6DNmx
	QCA/z8aK0FdEBRlswYcnPdbaa372OlaDQvYinypfrlpsVCznCUJ/abK3sfvi1y3AuCGfQ7
	Juphu1HZySj1luWRF3E29dkqC3zTxWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=c4YI6jiN;
	spf=pass (imf23.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4jFD1H4MqVzMldZ;
	Wed, 28 Oct 2026 17:52:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793206339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kSZ/p9sni9dlI5eyNVwd3UwnEXwjdQ5OzLQCHA5zC4s=;
	b=c4YI6jiNA9MhxQQZCQBsb1ni2h0Iue1tzEE22yE0Ik1gue0bcVU2bldk3IDx7Vv2mSoopf
	7NhVbX6I9F2iD/hW//I6u8UR2J46NfEjcn3f/sq4dbTvQ0VficRtoEJPk12aUDPSJy8TTM
	Ja4L0iwGdZ/fDEDYTb8aJz/LISm/uTOgzhoP9mMSdpQq42aRl9RK+vDA3IWTe+OHM7PHca
	RNgdTW/o5XZ/OO9mIHuOlUiq/Q8sPDUs63yd3OQ3bA6lKtEqBL1b/GoYH13nJE53nv9v0R
	qhEz+uV9YB86IsLe5Md2vBurF8mELDpO/RTi2+iyPzXK/+b2+c1jpFXUCZRYRw==
Message-ID: <e68efe96e67c8b72047f2ab01c874026cecb025b.camel@mailbox.org>
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/reclaim: rewrite
 complex parts
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: corbet@lwn.net, damon@lists.linux.dev, jm5905938@gmail.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	rdunlap@infradead.org, skhan@linuxfoundation.org
Date: Wed, 28 Oct 2026 17:52:17 +0100
In-Reply-To: <20261028001916.157488-1-sj@kernel.org>
References: <20261028001916.157488-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: 7ta55qyrcan3bsd387ztgpp8hdim5cs8
X-MBO-RS-ID: 36aca95019600dc8a51
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA74E140002
X-Stat-Signature: ywidn1z3166bfd6z69s4yc4bi16hogxd
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793206342-327629
X-HE-Meta: U2FsdGVkX1+sMDeHZtAw556yUi10NNvHJmqRBP8zuNhpoU3UkCA4K2+Eth1TmuUANCfvc1IxzAnMnK1lI0chiQLfm+rDFno3G5z+81OobIQDD+f+/MjD5uuwTZsmsWGe/MPG/PD3M/tnFLx8jV0Nkm8uI3tK09uGl3ArhI5ZksLF4h3Blx3G5h8UfOIy79mrUK57WX3cQ5JhCFwK0tIQ9geM+/gaTkdY89wyrdd5FlpmyDpGeX7cH0nBPMl79WEZN8o13C2UOPGv2gj0DBOhUzV5e+cIB05jtKwBw/9zEiTIswJeoLuh0hTD7gBX9ekYdpgQmYt3Iv+a89LhgUB+QNX6is/9TCHxpMk+vzFJ843xlZMSgMIl4xZrzmK50QneZOkR5KYq4voQDQHzrXEknD48yFVlnPw2C9ntTK29+Eimznixk+PzyjwfEo5e/9JiHStUwUOOT7N6QsiEqSaWLglovZuNggXaypqcv53iAUYahDdQYpQV+9FA3bJO4ecVKjcP/A/sxlw97Y0jF0WYc0ET8eWp6CGgUoWjcxoDDqf/DASmTEUSMvSXtbUjreae6PbJu6KisXUtc5yVzXsqeZo2o9o5wPU9DIFuxzxYWUqAE1DydC0HhaW35IMqlVtYkao15MhLTlg47sUqM8QsHv6uat1X5DsgrauWqiibRuSxELUoS+CVbIjctNq3rePr5cnfxbL60jHhU9R5iwNCGo8MO6eQjtP4wPgeBaWMhxfMc43wXTjXHuM92PW0xPFiQIFqa1lEIaA0egjruZptwUz1dWw0eX8izCI8d4SfL4eKDCXmaurjqWPk5dn767nVXPkhHkB1iV4AjScNwEEALeoCB7nLgHzzclGMnxjMqbD1QKkX7tNxQ0HV+fWWtoZs8LmfVak6wKZjzaxvvXKpembUYYO9hejM/NEjHP6V4HQ4f2LDL1nHFaUcwlCFtqJE0Z5iepW5niOsbTpARuJ
 IcdZ1yfH
 cYMik9GOVH5+3M0vZSmaDNeM+W2JfHsQR4LS43AqVYVRiBP5/U/L/pKrH847KGyZEvxEtvyeV0EvxAvRjwuUj7XGuQ1DgTr7ySlY/9NWIh0+vaDERxtB/PVUMC+JL95evVjR7X81u7dqb2l8RpgNPs8vHWvp+IHRCz1MGi49A2BgFlAdOC1OgfjOx+chRxcn4SoX0r+cHEqmZQbI8Hyz/5a+beltP+FXXDraBha3nXA0tQWgBpaycvO4WTS3cB8BPGdSpA780+SpvLzdyQewavI9MiObFeV4El6zBP74N5/5MfRoDD11JrCqch4/F3Biz1MxEQJM9Ru+8d/zg4ALWiIqoBsIcqPjqDMLaIkOx1LUAjOJ00rbaP38tNKML0kQsb+BucltWa78voRBpX2oYwlHnGzAD6nfK1H0L6QDFHWkzNd52+20QcccY31ftVB39MljeJ6OQF6uWWhLOorA94mfIIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Tue, 2026-10-27 at 17:19 -0700, SJ Park wrote:
> Hello Manuel,
>=20
>=20
> On Tue, 27 Oct 2026 22:23:46 +0100 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > Rewrite complex sentences.
>=20
> Any special reason to keep this as a separated one?=C2=A0 I think it is o=
k to merge
> this into the first patch.

In this mail ( https://lore.kernel.org/all/20261016142921.126622-1-sj@kerne=
l.org/ )
> Let's do such rewriting with another patch.

I understood this as 'make it two patches'.

> > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> > Suggested-by: Aveline Noir <jm5905938@gmail.com>
> > ---
> > Two more minor changes
> > @ 31
> > /s/attempts to pages out those/attempts to page out those/
> > @ 126
> > + 'is' to fix grammar
> >=20
> > =C2=A0.../admin-guide/mm/damon/reclaim.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 19 ++++++++++---------
> > =C2=A01 file changed, 10 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documenta=
tion/admin-guide/mm/damon/reclaim.rst
> > index 0bab2299ea..033686f410 100644
> > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> > @@ -30,12 +30,13 @@ guests could mitigate this problem.
> > =C2=A0How It Works?
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =C2=A0
> > -DAMON_RECLAIM finds memory regions that weren't accessed for specific =
time
> > -duration and page out.=C2=A0 To avoid it consuming too much CPU for th=
e paging out
> > -operation, a speed limit can be configured.=C2=A0 Under the speed limi=
t, it pages
> > -out memory regions that weren't accessed longer time first.=C2=A0 Syst=
em
> > -administrators can also configure under what situation this scheme sho=
uld
> > -automatically be activated and deactivated with three memory pressure =
watermarks.
> > +DAMON_RECLAIM identifies memory regions that have not been accessed fo=
r a
> > +specified period and attempts to page out those.=C2=A0 To avoid it con=
suming
> > +too much CPU for the paging out operation, a speed limit can be config=
ured.
> > +Within the configured speed limit, it prioritizes regions that have be=
en
> > +idle longer for reclamation.=C2=A0 System administrators can also conf=
igure under
> > +what situation this scheme should automatically be activated and deact=
ivated
> > +with three memory pressure watermarks.
> > =C2=A0
> > =C2=A0Interface: Module Parameters
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > @@ -125,8 +126,8 @@ quota_reset_interval_ms
> > =C2=A0
> > =C2=A0The time/size quota charge reset interval in milliseconds.
> > =C2=A0
> > -The charge reset interval for the quota of time (quota_ms) and size
> > -(quota_sz).=C2=A0 That is, DAMON_RECLAIM does not try reclamation for =
more than
> > +The charge reset interval for the quota of time is quota_ms and for th=
e quota of
> > +size is quota_sz.=C2=A0 That is, DAMON_RECLAIM does not try reclamatio=
n for more than
> > =C2=A0quota_ms milliseconds or quota_sz bytes within quota_reset_interv=
al_ms
> > =C2=A0milliseconds.
>=20
> I think the original sentence was not that confusing.=C2=A0 Also, this ch=
anges the
> nuance of the sentence?=C2=A0 What the sentence is saying is
> "quota_reset_interval_ms is the charge reset interval for ...".=C2=A0 If =
this was
> really confusing, maybe we can add "quota_reset_interval_ms is " part.
>=20
> But, I start feeling we might trying too much polishing...?

I think the verb is missing or can you tell which the verb is? If you can
no fix is required.

>=20
> > =C2=A0
> > @@ -137,7 +138,7 @@ quota_mem_pressure_us
> > =C2=A0
> > =C2=A0Desired level of memory pressure-stall time in microseconds.
> > =C2=A0
> > -While keeping the caps that are set by other quotas, DAMON_RECLAIM aut=
omatically
> > +While respecting the limits imposed by other quotas, DAMON_RECLAIM aut=
omatically
> > =C2=A0increases and decreases the effective level of the quota aiming t=
his level of
> > =C2=A0memory pressure is incurred.=C2=A0 System-wide ``some`` memory PS=
I in microseconds
> > =C2=A0per quota reset interval (``quota_reset_interval_ms``) is collect=
ed and
>=20
> I'm not sure if the original sentence was really difficult to understand.
>=20
> I'd prefer dropping this change.

That's ok.

Will you handle the final edit or should I send a [v3]?

Thanks
 Manuel
>=20
>=20
> Thanks,
> SJ
>=20
> [...]

