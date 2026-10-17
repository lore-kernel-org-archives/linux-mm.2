Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37262CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 09:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221C16B008C; Sat, 17 Oct 2026 05:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3366B0092; Sat, 17 Oct 2026 05:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1D46B0095; Sat, 17 Oct 2026 05:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D20FD6B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:18:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63F411C2532
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 09:18:43 +0000 (UTC)
X-FDA: 85331568126.07.78ACF0E
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B27B100007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 09:18:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=UqxkiEmf;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf14.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792228721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJNqfW0ioAwXAyHgrrMYr3i85p2JVBdKUXfKlT6Pido=;
	b=3ViLKLxJYaq010jnFaT0eyNqHoXBBcB80vJXlCpH1x1+xUN1MU5ZUMhaQT4ZVJC5z3uAYt
	3r/cdlBbjTp9IEled6joXRTr2/SAphZ4N9eHlxZhcD2yF7NpqrtcPXM7bDkYzyJt7Kc8bb
	4zQZgP6tpXjl1D3X9BxmdTIpUNa5hh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792228721;
	b=HmirN2Kt0KMM8PJ61owfzPFWO7qFngHWytmUAE2YsAajv9kG5vOWXGFnothJkD69iEeDKJ
	BA0P/d7G7ZzXJ1kSWCga/n98s0jKT1Y5MpfAmmRpqgxgbBsvwnFmo+fNCawBzltUBGUJO3
	y3qjCtXOexgvkZ8hMB29O0PkxK0akRo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=UqxkiEmf;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf14.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4j6GSs6Ct8zKnTY;
	Sat, 17 Oct 2026 11:18:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792228717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJNqfW0ioAwXAyHgrrMYr3i85p2JVBdKUXfKlT6Pido=;
	b=UqxkiEmf8ArLdQmOp8pJzr16B+51FF6wd4VGNwPO/FNzS9wMD4L7/Bw1W9+HrxX4DFJBCi
	KqL8s8ND8VeJOTdFwRlJFsG5Ixw6fkR9jChBnm7cE/8TwGKdjtyzWSJ2F5xskI94RkLHjJ
	DD942aHIEMFTwtPKU6CmFWoWSUvbQH/cBml5Ja36Nigncb2r92fmRxBQRlNl4+QwSPe8+G
	MK/DhOJEWw2tK3SL0FvP3hyxhKOSu+O20vHcHkEw+LrfF7hoW+K4KFha1rIHQpt0FHfmkk
	c3kRrkpvLs89UAhUewPF+EFadAunu790rbD7e9wWaNL5R7PWwZ7DR0zUGEPt2Q==
Message-ID: <c575314d3e52d5fcff3d6fc47d12dc118a24bd63.camel@mailbox.org>
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aveline Noir <jm5905938@gmail.com>
Date: Sat, 17 Oct 2026 11:18:34 +0200
In-Reply-To: <20261015140122.87808-1-sj@kernel.org>
References: <20261015140122.87808-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-META: 1hapjjy6635khx6ean1i9pxm4mypfzp9
X-MBO-RS-ID: 3cc1a3b206adc544abb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B27B100007
X-Stat-Signature: bnu9aedn88pn7dcpncipsujhhj78wogb
X-Rspam-User: 
X-HE-Tag: 1792228721-833836
X-HE-Meta: U2FsdGVkX1/sxL6zWF416kUtMf67HUEtG/R7LI0ppa4XQ4i+lXBMqiCGArSsu477f5CWjmdpxEIZZSO4ERVWyaT9+2LmCmICR5mQ+oLSxHWaRgc+Ll6Losx+rIzUyCIsD7drhSdaemZBYm6v8FH0xcXSY4N4KGk0twjurhI5NIQEtGAOt4xsJevLspreTENqzqZRpib1jv/a23yXheSLwzp/MNIuPB61SgywMzTTk85c6AySFpvA5YMib+JqOJJ9sis4g1U4r8/I1Rufl6HFwfRSV029ZUBJpGWrcTQ0v806m/bhrCz4nNaJosiSi/5rfTEWxLCAIlvweq3BBmfRzWlxbZIeegGz+wxyS5cOvMcTdzEvTqytKiMSJiTWsEj0BLpTiKS6pep5yHKEUjk/UR1cFGL/seJrL5khACiUjKi9Vjp8nH1VWXQok8vcwHmylhiTJM3e9Hn5xNh1HAzAH7SPHDDI1hx/RjuDKsyqcNDdyQsav7KneWxMhpxqZc1MJjhpaIHGtQz9g9EvnrkftXL8YkQl3345Nn8RyHftYGEvu08rjxliHu5MnMVGs7Om+hN1rnu9Fl6+OpK8SMYC2rxtSSWdqvMPZLEPazkAweVwBakb+uI2VwoeyrddL/P3djZbM053LgGKvWwGAYyDgoW+Zikfy/SxyU2cYTVMox2/BcIT5xootBhTHF7ihk4CrcUMDbZg6mKXH0V7JX4iNtkhrdiYc4O1KbipJLGTJVZVQ893SJeHW5P6lEY+iMrUjROq0dwGal0jB65zLoEm44kpK1vnhAu6us4Yt5KlwAIWOZ4Z5/RP2ML/gHwaFDsc99Nb5/+tBKW2lc2MYfdBmaKQCEj4fFasEWQ8m3AcSz7r5gi/XWayXKDXSdqJSG+Z1bRIWo8IJhejeDtfUSzl8AGqaUKGwik9DaCWAeCONrNjRW9HpcY4Tz8mgBs+AhvmDq8TuYHDpAy0lE9lz+p
 31Sab5KK
 Hhp5wyli+QYmDZDq4sR+PrdNXlttYHbGmsP24h00nc0n1Q1WCm7SPBP2TW2MUnaU9gouKMFo1TZ6qywg/PadjlqunDs8lFhuDcU+880hdHbHAs6aI5CimRJGiIHOYmkhb4zFDIiphWXnl1DnsUhXAJsI15xMipRq2uXZ5M9yFnND2y4DpsqCkcJUrQ9CN7rwhB9Ib/kS9A0rybKagOIJC89KBZ8yzjYGdY5D6mAAm/y4514WniNIa3OkTn0VkSuT6yvdhdkl1J0pfBNZ/7aYeHu/ADIruZNkUpVxyz5t9fCiypAR5wpnwrQR4LWDOsVXMl2seU5li+QkxWOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Thu, 2026-10-15 at 07:01 -0700, SJ Park wrote:
> On Thu, 15 Oct 2026 10:06:23 +0200 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > Fix tenses. Replace 'set as' with 'set to'.
> > Rewrite complex sentences.
>=20
> Let's put two sentences in one line, while breaking it for the 75 column =
limit.

Will do.
>=20
> [...]
> > @@ -113,8 +113,8 @@ quota_sz
> > =C2=A0
> > =C2=A0Limit of size of memory for the reclamation in bytes.
> > =C2=A0
> > -DAMON_RECLAIM charges amount of memory which it tried to reclaim withi=
n a time
> > -window (quota_reset_interval_ms) and makes no more than this limit is =
tried.
> > +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim =
within a time
>=20
> s/recordes/charges/=C2=A0 or s/recordes/records/ ?

For me charge is such a weird word exepct in 'charge a battery' or 'charge =
a fee'. And
'recordes' is a typo. Does this work:

DAMON_RECLAIM records the amount of memory which it tried to reclaim within=
 a time

I could do this in a second patch aswell.

>=20
> I'd prefer charges, but my English is definitely bad, so looking for your
> suggestion.
>=20
> > +window (quota_reset_interval_ms) and stops when this memory limit is r=
eached.
>=20
> I feel like readers might wonder what is stopped.=C2=A0 How about "stops =
trying
> reclaiming memory when ..." ?

window (quota_reset_interval_ms) and stops trying to reclaim memory when th=
is limit is reached.

>=20
> > =C2=A0This can be used for limiting consumption of CPU and IO.=C2=A0 If=
 this value is
> > =C2=A0zero, the limit is disabled.
> > =C2=A0
> > @@ -125,19 +125,19 @@ quota_reset_interval_ms
> > =C2=A0
> > =C2=A0The time/size quota charge reset interval in milliseconds.
> > =C2=A0
> > -The charge reset interval for the quota of time (quota_ms) and size
> > -(quota_sz).=C2=A0 That is, DAMON_RECLAIM does not try reclamation for =
more than
> > +The quota reset interval of time is quota_ms and of size is
> > +quota_sz.=C2=A0 That is, DAMON_RECLAIM does not try reclamation for mo=
re than
>=20
> I think this change is just wrong?=C2=A0 quota_ms is not quota reset inte=
rval of
> time.=C2=A0 Which part of the original sentence was difficult to read?

'charge' again, and I think there is the verb is missing.

>=20
> > =C2=A0quota_ms milliseconds or quota_sz bytes within quota_reset_interv=
al_ms
> > =C2=A0milliseconds.
> > =C2=A0
> > -1 second by default.
> > +1000 (1 second) by default.
>=20
> Isn't this (1 second in milliseconds is 1,000) easy enough to infer for
> readers?

Ok.

> > =C2=A0
> > =C2=A0quota_mem_pressure_us
> > =C2=A0---------------------
> > =C2=A0
> > =C2=A0Desired level of memory pressure-stall time in microseconds.
> > =C2=A0
> > -While keeping the caps that set by other quotas, DAMON_RECLAIM automat=
ically
> > +While keeping the caps set by other quotas, DAMON_RECLAIM automaticall=
y
>=20
> How about "caps that are set by ..." ?

Yes, this was my second choice.

>=20
> > =C2=A0increases and decreases the effective level of the quota aiming t=
his level of
> > =C2=A0memory pressure is incurred.=C2=A0 System-wide ``some`` memory PS=
I in microseconds
> > =C2=A0per quota reset interval (``quota_reset_interval_ms``) is collect=
ed and
>=20
>=20
> Thanks,
> SJ

I messed up the subject line, should be:
Docs/admin-guide/mm/damon/reclaim: improve grammar and style

I'll follow up with a [v2], including Aveline suggestions.

Thanks,
 Manuel
>=20
> [...]

