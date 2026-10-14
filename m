Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3F2CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2B36B008A; Wed, 14 Oct 2026 08:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53306B008C; Wed, 14 Oct 2026 08:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68E06B0092; Wed, 14 Oct 2026 08:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5536B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:35:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C754A120508
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:35:06 +0000 (UTC)
X-FDA: 85321176612.15.23AEA0C
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D6D81C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:35:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=PEsyjnDv;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791981305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deI6tRQ3FBGqgf5VLrNCIzeDLo8uR0T/R2GhdiHbgig=;
	b=xiu7NcfINeYUx63faqh+QKtYDE4gPh4v20hquIEKv+TRGUEpv0YJd1Reoafh/ie4kBa4UI
	H/xxnpHhHh4TAcoK1q10EA0jtCEVjRLLVGnoKTmEgndmWUIq+CI8NzjqxOKuv4aTJ74iYB
	jYrdTZYY5errnxq4J5QXzAlD2AIxLnA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=PEsyjnDv;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791981305;
	b=ACjbrjX5tDbYmmXhH7Nc33ehd4vccJDQmgn30ZK/P6ddqhWy/nT3zJfBkJ3S9G3hzfVoNt
	y/8xCaH6wZ16ZBuKDnOH7P37y6joPujBX3qJiqznQ+AsY5mXfwKjlibIl5whFeQWtm6rwO
	FmvfSX68LdHpD/ofTwtHKaIWZmtwM0c=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4j4Vyr23mFzMlTH;
	Wed, 14 Oct 2026 14:35:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1791981300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=deI6tRQ3FBGqgf5VLrNCIzeDLo8uR0T/R2GhdiHbgig=;
	b=PEsyjnDveHgEGz6sTplxOjMmvpcUgyxRYPtDZ0CtqKD1uV4YZIv/jEDDqTeOT8w/DRqJmj
	1iw6VDB3vWUPqBbhJ3C27sf33T97t74lvpyqZ7sEAE57IkAOUXB9EjILmBLyAXb/RSCirM
	fBbCbwn9eSNoAViH48ZdNCnSp1M0V0rySxXNHSnA5v4kiiHmVesC8/7DGTgLPmr6cyoGxt
	AX3KvQtnWgJwq6/qn/RzTC4YSByjbSg0O9P+IQA5iTvSCxvyNBATujaosmwO3iiCmWKQqS
	B2n1gO3y+RWhSMaI9A9m2RhGynCe7RK0HcVPPbLtZMUwkmRyANXV/k2KuFVt+w==
Message-ID: <dfa05908286b5e5684ea0002dde1ee99627154a4.camel@mailbox.org>
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/lru_sort: fix grammar and
 stlye
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 14 Oct 2026 14:34:51 +0200
In-Reply-To: <20261014003258.142926-1-sj@kernel.org>
References: <20261014003258.142926-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-META: ko86gy8rzxz8iyf6ysb7mp1kfuurbwa6
X-MBO-RS-ID: 94973415d2ae5663d4b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D6D81C0004
X-Stat-Signature: sdwo3yjkiee48w311i1ykefwqz8paojc
X-HE-Tag: 1791981304-768025
X-HE-Meta: U2FsdGVkX1+4jgf9xY4RDnGmoCpFcHk2me8wQSpV+IdP4zMpgczsRAdogmtdRmCQRfoMzG7SAMBbcTpId3Rb8ueUiIOF0l6sL/t38RCwlwtMsVpqFRVL8KLl1rJuK7rwEo6LjDy6dmq2CcakU+SQyRLhne5T18YnYvoN8GoQ3oM9FTK01aRHNlzvzASrUO8gtNSnbAo8mUxWnDDLn65GxQLlf6xgRFq51haQVqPYg+JU2bw6yEd9N0R9HclUWXFRSpYdLtn5ECy3IXwoCZaUANW83qfvMyWIUOFGbfwxs9MDJDEZnlgNLLKTCdRaLx6xz1Pgmvzc3ZXD3tGeFF1PhJ/j8oxWC98BpXnXSW1ImiXh1y4OeWgd4+uCuaaGSjC9KIZLzJleWhZtfNssUX4uG8eUo7ABJgHTtw1soXjoILxl0sGP0afIhQrJM58g2A1bv7KeCuta74coEbNxNnnovF8sLyp/ROzI+kD8LUOIS2rsSik025x+pweuM5GxtQOxzacTOzZamWkFNYSApxQJeOqdWu4JM2muhaeNCBgKgmNRTJPOdIpUkHLRPZhORBArwW5YXUI0Q+y03z/nAthtD4L1bEO1Sbk2z+eTAdZIvTZwRH7mZ+voqGKovszf1UWwBuRmOVfD7yzmKehax+uUpyqxUoiFzLPVGHM9PZmTfO7rU/MFdotCp0Oyfrjd/fiN2lUKrlnJN0Ows702fvSGIP6cDGK3d6+ZpiookzlldyNltMu8dp1nYxHas8nhOIg/1PEOeVi+IEjbrZjr4+yomCLT1nBQp9jB4v6MzDGmdIojA8XTHxWQT02GkxpFj4cqIEi9BVtFRmUkuEfUWb02RVZZy1gZ+RjVmfge819a9heFvW3t4HqrQIWgyxQcBps0Bmji55fbAIlAi9NyR+ipg98bhNIp4QCpt6z3kh3ImFX/PSSYHA41LHaL4MLZhOZyBWhZsDClJcpLggEeCJi
 KFmSgfuR
 +FmmoKDhe4AuSPdMYmLeYmBuC5wqZedz6bZtIqV3ye25TOaYK1aXqwnjdDnhgr9UtpcZ0ohUivj5ETck2ST4oeGBsZcfqnke+2XDteuc0LuuCb+428a8n3koVx/+4C3NRKlXE26I5XRglQKVMNzW6gh6viAZQVF0YnghC2STfx0FrgdTpN7nmrBPJKje1k0mWfXSF7sn5jim8/as0G31Z+BShNm0Xd6q4pRiCdm3pZ84bsZjT8CaOqiprYmxGDTaOF7hWBjIPQ7QiZsve+GE0ZOU2RUra0uL0llEQ6NjcZ0E47n8uvEEwbEKk0NgCGzu4K+ITvphgQW6uPChiubT5CqukeQnVV2dqqE3PuPZ0bBXwasewdJDSgrqOOTExNX1Ke9Yr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Tue, 2026-10-13 at 17:32 -0700, SJ Park wrote:
> Hi Manuel,
>=20
> On Tue, 13 Oct 2026 21:13:27 +0200 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > mention 'least-recently-used' AKA lru at the beginning
>=20
> I think the readers would know what LRU means, and therefore
> 'least-recently-used' is not needed.

I'm probably one of the few that doesn't know. I didn't think of the whole =
picture.
You are right.

>=20
> > set as -> set to
>=20
> This commit message is using incomplete sentences and describing only a f=
ew of
> changes.=C2=A0 Please make it to use complete sentences and cover all cha=
nges.

Will do.

>=20
> >=20
> > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> > ---
> > =C2=A0.../admin-guide/mm/damon/lru_sort.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 51 ++++++++++---------
> > =C2=A01 file changed, 26 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Document=
ation/admin-guide/mm/damon/lru_sort.rst
> > index 0c04d238ed..3b6d122887 100644
> > --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> > +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> > @@ -4,8 +4,9 @@
> > =C2=A0DAMON-based LRU-lists Sorting
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > =C2=A0
> > -DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel modu=
le that
> > -aimed to be used for proactive and lightweight data access pattern bas=
ed
> > +DAMON-based least-recently-used-lists (short LRU-lists) Sorting
> > +(DAMON_LRU_SORT) is a static kernel module that aims to be used
> > +for proactive and lightweight data access pattern based
>=20
> As I mentioned above, I don't think the above change is needed.

K

> > =C2=A0(de)prioritization of pages on their LRU-lists for making LRU-lis=
ts a more
> > =C2=A0trustworthy data access pattern source.
> > =C2=A0
> > @@ -17,7 +18,7 @@ systems, LRU lists are normally not proactively sorte=
d but partially and
> >  As page-granularity access checking overhead could be significant on h=
uge

Is this huge as in big or huge pages. For the latter I would put it: ``huge=
 page``-systems
or `huge page`-systems.

> >  systems, LRU lists are normally not proactively sorted but partially a=
nd
> > =C2=A0reactively sorted for special events including specific user requ=
ests, system
> > =C2=A0calls and memory pressure.=C2=A0 As a result, LRU lists are somet=
imes not so
> > =C2=A0perfectly prepared to be used as a trustworthy access pattern sou=
rce for some
> > -situations including reclamation target pages selection under sudden m=
emory
> > +situations including reclamation of target pages selection under sudde=
n memory
> > =C2=A0pressure.
>=20
> I cannot find what's wrong with the original sentence.=C2=A0 Could you ex=
palin?
> Also, I think the updated sentence is rather easier to misread.

It's two long sentences, thus (I think) hard to understand. I _rewrote_ it =
this way:

As page-granularity access checking overhead could be significant on huge s=
ystems,
LRU lists are normally not fully nor proactively sorted but rather partiall=
y=20
and reactively sorted for special events.  These events include specific us=
er requests,
system calls and memory pressure.  As a result, LRU lists are sometimes not
suitable to be used as a trustworthy access pattern source. These situation=
s=C2=A0
including reclamation target page selection under sudden memory pressure.

Please note:
  target pages selection
->target page selection

> > =C2=A0
> > =C2=A0Because DAMON can identify access patterns of best-effort accurac=
y while
> > @@ -28,9 +29,9 @@ pattern source with low and controlled overhead.
> > =C2=A0How It Works?
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =C2=A0
> > -DAMON_LRU_SORT finds hot pages (pages of memory regions that showing a=
ccess
> > +DAMON_LRU_SORT finds hot pages (pages of memory regions that show acce=
ss
> > =C2=A0rates that higher than a user-specified threshold) and cold pages=
 (pages of
>=20
> rates that "are" higher?
... that show access rates that are higher ...
and=20

>=20
> > -memory regions that showing no access for a time that longer than a
> > +memory regions that show no access for a time that longer than a

... show no access for a duration that is longer than a=20

Then ack.

> > =C2=A0user-specified threshold) using DAMON, and prioritizes hot pages =
while
> > =C2=A0deprioritizing cold pages on their LRU-lists.=C2=A0 To avoid it c=
onsuming too much
> > =C2=A0CPU for the prioritizations, a CPU time usage limit can be config=
ured.=C2=A0 Under
> > @@ -63,10 +64,10 @@ enabled
> > =C2=A0
> > =C2=A0Enable or disable DAMON_LRU_SORT.
> > =C2=A0
> > -You can enable DAMON_LRU_SORT by setting the value of this parameter a=
s ``Y``.
> > -Setting it as ``N`` disables DAMON_LRU_SORT.=C2=A0 Note that DAMON_LRU=
_SORT could do
> > +You can enable DAMON_LRU_SORT by setting the value of this parameter t=
o ``Y``.
> > +Setting it to ``N`` disables DAMON_LRU_SORT.=C2=A0 Note that DAMON_LRU=
_SORT could do
> > =C2=A0no real monitoring and LRU-lists sorting due to the watermarks-ba=
sed activation
> > -condition.=C2=A0 Refer to below descriptions for the watermarks parame=
ter for this.
> > +condition.=C2=A0 Refer to below descriptions of the watermarks paramet=
er for this.
> > =C2=A0
> > =C2=A0commit_inputs
> > =C2=A0-------------
> > @@ -74,9 +75,9 @@ commit_inputs
> > =C2=A0Make DAMON_LRU_SORT reads the input parameters again, except ``en=
abled``.
> > =C2=A0
> > =C2=A0Input parameters that updated while DAMON_LRU_SORT is running are=
 not applied
> > -by default.=C2=A0 Once this parameter is set as ``Y``, DAMON_LRU_SORT =
reads values
> > +by default.=C2=A0 Once this parameter is set to ``Y``, DAMON_LRU_SORT =
reads values
> > =C2=A0of parameters except ``enabled`` again.=C2=A0 Once the re-reading=
 is done, this
> > -parameter is set as ``N``.=C2=A0 If invalid parameters are found while=
 the
> > +parameter is set to ``N``.=C2=A0 If invalid parameters are found while=
 the
> > =C2=A0re-reading, DAMON_LRU_SORT will be disabled.
> > =C2=A0
> > =C2=A0Once ``Y`` is written to this parameter, the user must not write =
to any
> > @@ -86,37 +87,37 @@ violate this rule, the kernel may exhibit undefined=
 behavior.
> > =C2=A0active_mem_bp
> > =C2=A0-------------
> > =C2=A0
> > -Desired active to [in]active memory ratio in bp (1/10,000).
> > +Desired active to (in)active memory ratio in bp (1/10,000).
>=20
> I think use of brackets is also fine.=C2=A0 Let me know if I'm missing so=
mething.

There is 2x (de)prioritization, 6x [de]prioritizations, 2x[in]active and a =
few more in the
file. They are all fine by themself, but not mixed. [] or ()?

>=20
> > =C2=A0
> > =C2=A0While keeping the caps that set by other quotas, DAMON_LRU_SORT a=
utomatically
> > =C2=A0increases and decreases the effective level of the quota aiming t=
he LRU
> > -[de]prioritizations of the hot and cold memory resulting in this activ=
e to
> > -[in]active memory ratio.=C2=A0 Value zero means disabling this auto-tu=
ning feature.
> > +(de)prioritizations of the hot and cold memory resulting in this activ=
e to
> > +(in)active memory ratio.=C2=A0 Value zero means disabling this auto-tu=
ning feature.
>=20
> Ditto.
>=20
> > =C2=A0
> > =C2=A0Disabled by default.
> > =C2=A0
> > =C2=A0autotune_monitoring_intervals
> > =C2=A0-----------------------------
> > =C2=A0
> > -If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes =
DAMON's
> > +If this parameter is set to ``Y``, DAMON_LRU_SORT automatically tunes =
DAMON's
> > =C2=A0sampling and aggregation intervals.=C2=A0 The auto-tuning aims to=
 capture meaningful
> > =C2=A0amount of access events in each DAMON-snapshot, while keeping the=
 sampling
> > -interval 5 milliseconds in minimum, and 10 seconds in maximum.=C2=A0 S=
etting this as
> > -``N`` disables the auto-tuning.
> > +interval to 5 milliseconds in minimum, and to 10 seconds in maximum.=
=C2=A0 Setting this
> > +to ``N`` disables the auto-tuning.
> > =C2=A0
> > =C2=A0Disabled by default.
> > =C2=A0
> > =C2=A0filter_young_pages
> > =C2=A0------------------
> > =C2=A0
> > -Filter [non-]young pages accordingly for LRU [de]prioritizations.
> > +Filter (non-)young pages accordingly for LRU (de)prioritizations.
>=20
> Ditto.
>=20
> > =C2=A0
> > =C2=A0If this is set, check page level access (youngness) once again be=
fore each
> > -LRU [de]prioritization operation.=C2=A0 LRU prioritization operation i=
s skipped
> > +LRU (de)prioritization operation.=C2=A0 LRU prioritization operation i=
s skipped
>=20
> Ditto.
>=20
> > =C2=A0if the page has not accessed since the last check (not young).=C2=
=A0 LRU
> > =C2=A0deprioritization operation is skipped if the page has accessed si=
nce the
> > =C2=A0last check (young).=C2=A0 The feature is enabled or disabled if t=
his parameter is
> > -set as ``Y`` or ``N``, respectively.
> > +set to ``Y`` or ``N``, respectively.
> > =C2=A0
> > =C2=A0Disabled by default.
> > =C2=A0
> > @@ -235,7 +236,7 @@ max_nr_regions
> > =C2=A0Maximum number of monitoring regions.
> > =C2=A0
> > =C2=A0The maximum number of monitoring regions of DAMON for the cold me=
mory
> > -monitoring.=C2=A0 This can be used to set upper-bound of the monitorin=
g overhead.
> > +monitoring.=C2=A0 This can be used to set the upper-bound of the monit=
oring overhead.
> > =C2=A0However, setting this too low could result in bad monitoring qual=
ity.=C2=A0 Please
> > =C2=A0refer to the DAMON documentation (:doc:`usage`) for more detail.=
=C2=A0 1000 by
> > =C2=A0defaults.
> > @@ -268,7 +269,7 @@ This parameter is for setting and getting the :ref:=
`address unit
> > =C2=A0
> > =C2=A0``monitor_region_start`` and ``monitor_region_end`` should be pro=
vided in this
> > =C2=A0unit.=C2=A0 For example, let's suppose ``addr_unit``, ``monitor_r=
egion_start`` and
> > -``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respecti=
vely.
> > +``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respecti=
vely.
> > =C2=A0Then DAMON_LRU_SORT will work for 10 KiB length of physical addre=
ss range that
> > =C2=A0starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
> > =C2=A0
> > @@ -291,22 +292,22 @@ If DAMON_LRU_SORT is enabled, this becomes the PI=
D of the worker thread.=C2=A0 Else,
> > =C2=A0nr_lru_sort_tried_hot_regions
> > =C2=A0-----------------------------
> > =C2=A0
> > -Number of hot memory regions that tried to be LRU-sorted.
> > +Number of hot memory regions that try to be LRU-sorted.
>=20
> that were tried to be ?

Ack. Now I know why it's in the past.

> > =C2=A0
> > =C2=A0bytes_lru_sort_tried_hot_regions
> > =C2=A0--------------------------------
> > =C2=A0
> > -Total bytes of hot memory regions that tried to be LRU-sorted.
> > +Total bytes of hot memory regions that try to be LRU-sorted.
>=20
> that were tried to be ?

Ack.

>=20
> > =C2=A0
> > =C2=A0nr_lru_sorted_hot_regions
> > =C2=A0-------------------------
> > =C2=A0
> > -Number of hot memory regions that successfully be LRU-sorted.
> > +Number of hot memory regions that are successfully LRU-sorted.
>=20
> that were ?

Ack.

>=20
> > =C2=A0
> > =C2=A0bytes_lru_sorted_hot_regions
> > =C2=A0----------------------------
> > =C2=A0
> > -Total bytes of hot memory regions that successfully be LRU-sorted.
> > +Total bytes of hot memory regions that are successfully LRU-sorted.
>=20
> that were ?

Ack.

>=20
> > =C2=A0
> > =C2=A0nr_hot_quota_exceeds
> > =C2=A0--------------------
> > --=20
> > 2.55.0
>=20
>=20
> Thanks,
> SJ

Thanks for the feedback
 Manuel

