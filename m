Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10367606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=vfM+xgkT
Received: by kanga.kvack.org (Postfix)
	id 2FD2B6B05B0; Mon, 26 Oct 2026 13:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEE66B05B7; Mon, 26 Oct 2026 13:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4426B05B9; Mon, 26 Oct 2026 13:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAF2F6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:51:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D76D14077E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:51:47 +0000 (UTC)
X-FDA: 85365520254.05.DE6BBF7
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6373640007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:51:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=vfM+xgkT;
	spf=pass (imf17.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zE9kVNs5C7sYZHMxAgpjn8fTZT69NqSWFunM32ji+Q=;
	b=c9MlAP/KhNHduHOGA6oDd8Al7c8EhnQ1EzY4zZaEuuDtM0r1Oy49cd5qwCLy+6slijHvtK
	VDiUKQp2d89YJrBs0fwAP2n+9+bKKXrljvmkk/44i+yEeF09JrmgQBPy3Xl/UMbO6DSWIu
	NRvnfiMK6eV5g68Uok2M1p6Gw0qQ9GY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=vfM+xgkT;
	spf=pass (imf17.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037105;
	b=kuxktTb8lLq0Qyy4h6YMmm6UGwjpLXg4zjMjn5a1VmDXEGgy7pYHVhfmpYzmicavpP98Bx
	WDNfsvGjffVoT8JqDdexql0LkhGi1sToSJ6yZACvrqxSsPxHOtaFrqfMTEgvtMNiZ+ceZa
	JlfFuQjF0fuCHQDLITrAGQi4f4FTvDE=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jD1Ql1YcdzKp50;
	Mon, 26 Oct 2026 18:51:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793037103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+zE9kVNs5C7sYZHMxAgpjn8fTZT69NqSWFunM32ji+Q=;
	b=vfM+xgkTeSHFp0dpRFW5mvDxLWynvaYYd1UZ+0M8/RjdK3Y/o+kfyc5kjAwpXTIZsr9Eu6
	iExYX6fI/vZP81wbfVGzOl1iJoKCqxBJmoBTf7rDmFgc7GkX9+CIvi72yb/ZgfofHKatWm
	CEhmHoyYhPPpDYIG2BX/PYZg6euQ1DnaSJdvglOUm5V7jnR3pJMr3adsVPyyWfe80IThes
	PV1MfXTDdgA2dDMotzgnU6/3lFKeT8b0eHT0SY7mfG9tZzTHCgiEdq+PwAAqfMMCzCGB+q
	5PjQz2AM722OC6zZ3Ral0YnsHFgnv2G3dPDeGPmex+WvUtmaIsXIBJ5iXOlHYg==
Message-ID: <72437017a038310cad48a5ff488377a9f8eb89f1.camel@mailbox.org>
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aveline Noir <jm5905938@gmail.com>
Date: Mon, 26 Oct 2026 18:51:40 +0100
In-Reply-To: <20261017162706.103996-1-sj@kernel.org>
References: <20261017162706.103996-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: 5bdyhnnc1mx585ghi5jiq6o1fnqt5y33
X-MBO-RS-ID: 6365762b24dbd342937
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6373640007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 49qx4swbmm9yanpgszf79kzdu1idyoaz
X-HE-Tag: 1793037105-324049
X-HE-Meta: U2FsdGVkX1/EhxuvL/2fzIVYZtz9QGpl1UwloO06gvO1qJ9fx3MuEujpsKAvzTNh8c156RDZZU5OFJs1wydFNg9Sszi9aHo2jpOQJ3dEV0k2mkBufFHAuAljhp8jBSoi5B/WGQplhxmzwGdMpMEDn+nntPQhNpSb7pbe/yHYQoncuOFFx40ipLdnWecfPZvtoMSnBdVtwMf5U+rUS+WZTgeU0C3uv01P0GVCqHqspXm97JdECiHQyTMK7fVidQuGFEPUfNMgzIdPVg/aoqrRWs09n+tWmRemyFc9+6oTo9MvnwsdU1n702pBUWiqVFGlWzAUywcEaiSh67ul+XcLW3CJtLYaTSIkfF26EIHb32Epeepil6Rtvb+J22rgi2/Gt7dL0rZpC/b9H7EXr9Sf/6JkgNOrkkk3s0SQhg2uGVyN747AJbXhginakpCsVLZE5MRGXu26OPtKH8rv3UNX5uxoeJRvjhT5h8zRimqGtr1a5JHDL8TKrXVPIKUdu8GEyn+DIDi3zs+t/iquFWVaoujx01/RAEoeyYKEqj6yLCXnByfTYcZRRLiMeUx2TLY5QDCjxtuS1ve7nB2rCjVXJnTqXrjsJGGFNxfr4ewcK0SJ65FH3GrrP/mnd8fD89IP7B1erVhB9kIXh2QHkHFszz8Fyu9976/hd+eUQ/mC24I2Hs6JLmyzPNI3Cvk/iWWyT8MPOg+uSPibKJLd7oBIQ2QsrwtuLNLS8FqL1Iqf/41d9A/W9oPpK4xpXFunrVe4nOkmOwBbUh64SM126mDBmhq8SnwpM/vXoRyrpgFlmqaEZqugFnb+xjYy1IpNoZtFm8nuUfVksfjaQPBaKMBp44b/H5IzQm/4YE5Cv7FvJLiLlU2Xq7chnYL6POE9uO/d3enGJUtU497lKCyi+myA0yIFgI9MVLD8E53nQ0s4LJ7tFzbth9n0RnwnaaCCpURFHqkvE94qOygayi/ujnp
 chRWAC3a
 8XjmBegFJMDDOwj+MdOzuL0vg1EGKZu3SozBnH7PxMRPUYO/5F2zRvTsOxPzmKZJNTj+t9y8eQURhIjLPE13qmaweIwqwH63KQajpEDIcnM58NXAV8d1oxSKldgTOBOVvrM2l0Ia7OjNKgvdz+t7kB4CvWg8AKdBqW+Vr9z1EE4kA7R++ZjGsUPpnlFloNGpDEE0ZOm1I/qT4egjpkvwBq/bcn5TNBHYFEcrxmzk79xf212DcE/3robt2Gg5j4YqgOXOa2cqt8ogk4G2tIxBFy2EHJy9hM0lz/qkfqa99QJSA7ZMnQwdxugCW6q2b/cGcRHuHbly1469mSaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

took me some time to respond because of the procrastinations.

On Sat, 2026-10-17 at 09:27 -0700, SJ Park wrote:
> On Sat, 17 Oct 2026 11:18:34 +0200 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > Hi SJ,
> >=20
> > On Thu, 2026-10-15 at 07:01 -0700, SJ Park wrote:
> > > On Thu, 15 Oct 2026 10:06:23 +0200 Manuel Ebner <manuelebnerli@mailbo=
x.org> wrote:
> > >=20
> > > > Fix tenses. Replace 'set as' with 'set to'.
> > > > Rewrite complex sentences.
> > >=20
> > > Let's put two sentences in one line, while breaking it for the 75 col=
umn limit.
> >=20
> > Will do.
> > >=20
> > > [...]
> > > > @@ -113,8 +113,8 @@ quota_sz
> > > > =C2=A0
> > > > =C2=A0Limit of size of memory for the reclamation in bytes.
> > > > =C2=A0
> > > > -DAMON_RECLAIM charges amount of memory which it tried to reclaim w=
ithin a time
> > > > -window (quota_reset_interval_ms) and makes no more than this limit=
 is tried.
> > > > +DAMON_RECLAIM recordes the amount of memory which it tried to recl=
aim within a time
> > >=20
> > > s/recordes/charges/=C2=A0 or s/recordes/records/ ?
> >=20
> > For me charge is such a weird word exepct in 'charge a battery' or 'cha=
rge a fee'. And
> > 'recordes' is a typo. Does this work:
>=20
> 'charge' in this sentence is somewhat like 'charge a fee'.=C2=A0 I person=
ally don't
> feel it is weird.=C2=A0 But 'record' also work for me.

I will keep 'charge' at the later mention in the file.

>=20
> > DAMON_RECLAIM records the amount of memory which it tried to reclaim wi=
thin a time
>=20
> So this looks good to me, too.

Will do.

>=20
> >=20
> > I could do this in a second patch aswell.
> >=20
> > >=20
> > > I'd prefer charges, but my English is definitely bad, so looking for =
your
> > > suggestion.
> > >=20
> > > > +window (quota_reset_interval_ms) and stops when this memory limit =
is reached.
> > >=20
> > > I feel like readers might wonder what is stopped.=C2=A0 How about "st=
ops trying
> > > reclaiming memory when ..." ?
> >=20
> > window (quota_reset_interval_ms) and stops trying to reclaim memory whe=
n this limit is reached.
>=20
> Looks good.

Ack.

>=20
> >=20
> > >=20
> > > > =C2=A0This can be used for limiting consumption of CPU and IO.=C2=
=A0 If this value is
> > > > =C2=A0zero, the limit is disabled.
> > > > =C2=A0
> > > > @@ -125,19 +125,19 @@ quota_reset_interval_ms
> > > > =C2=A0
> > > > =C2=A0The time/size quota charge reset interval in milliseconds.
> > > > =C2=A0
> > > > -The charge reset interval for the quota of time (quota_ms) and siz=
e
> > > > -(quota_sz).=C2=A0 That is, DAMON_RECLAIM does not try reclamation =
for more than
> > > > +The quota reset interval of time is quota_ms and of size is
> > > > +quota_sz.=C2=A0 That is, DAMON_RECLAIM does not try reclamation fo=
r more than
> > >=20
> > > I think this change is just wrong?=C2=A0 quota_ms is not quota reset =
interval of
> > > time.=C2=A0 Which part of the original sentence was difficult to read=
?
> >=20
> > 'charge' again, and I think there is the verb is missing.
>=20
> If use of the term 'charge' is really making reading difficult, we could =
add a
> short definition of 'charge' as a separate patch.

I think it's not necessary, it's probably me.=20
>=20
> E.g.,=20
>=20
> '''
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -695,7 +695,9 @@ dynamic.
> =C2=A0To mitigate that situation, DAMOS provides an upper-bound overhead =
control
> =C2=A0feature called quotas.=C2=A0 It lets users specify an upper limit o=
f time that DAMOS
> =C2=A0can use for applying the action, and/or a maximum bytes of memory r=
egions that
> -the action can be applied within a user-specified time duration.
> +the action can be applied within a user-specified time duration.=C2=A0 D=
AMOS tracks
> +(charge) the amount of memory that the action is applied, and stops appl=
ying
> +the action once the limit is reached.
>=20
> =C2=A0To know how user-space can set the basic quotas via :ref:`DAMON sys=
fs interface
> =C2=A0<sysfs_interface>`, refer to :ref:`quotas <sysfs_quotas>` part of t=
he
> '''
>=20
> Please let me know if you'd like to send such a patch.

No need.

>=20
> >=20
> > >=20
> > > > =C2=A0quota_ms milliseconds or quota_sz bytes within quota_reset_in=
terval_ms
> > > > =C2=A0milliseconds.
> > > > =C2=A0
> > > > -1 second by default.
> > > > +1000 (1 second) by default.
> > >=20
> > > Isn't this (1 second in milliseconds is 1,000) easy enough to infer f=
or
> > > readers?
> >=20
> > Ok.
> >=20
> > > > =C2=A0
> > > > =C2=A0quota_mem_pressure_us
> > > > =C2=A0---------------------
> > > > =C2=A0
> > > > =C2=A0Desired level of memory pressure-stall time in microseconds.
> > > > =C2=A0
> > > > -While keeping the caps that set by other quotas, DAMON_RECLAIM aut=
omatically
> > > > +While keeping the caps set by other quotas, DAMON_RECLAIM automati=
cally
> > >=20
> > > How about "caps that are set by ..." ?
> >=20
> > Yes, this was my second choice.
> >=20
> > >=20
> > > > =C2=A0increases and decreases the effective level of the quota aimi=
ng this level of
> > > > =C2=A0memory pressure is incurred.=C2=A0 System-wide ``some`` memor=
y PSI in microseconds
> > > > =C2=A0per quota reset interval (``quota_reset_interval_ms``) is col=
lected and
> > >=20
> > >=20
> > > Thanks,
> > > SJ
> >=20
> > I messed up the subject line, should be:
> > Docs/admin-guide/mm/damon/reclaim: improve grammar and style
> >=20
> > I'll follow up with a [v2], including Aveline suggestions.
>=20
> Sounds good.=C2=A0 But let's finish the discussion about use of the term,=
 'charge'
> before posting v2.

Then I'll head to [v2] and make it a 2 part series.

>=20
>=20
> Thanks,
> SJ

Thanks
 Manuel=20
>=20
> [...]

