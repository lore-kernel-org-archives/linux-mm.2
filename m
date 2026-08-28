Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED42C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31466B0088; Fri, 28 Aug 2026 10:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE13A6B008A; Fri, 28 Aug 2026 10:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFDA6B008C; Fri, 28 Aug 2026 10:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAE096B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:56:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51A8D402BC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:56:31 +0000 (UTC)
X-FDA: 85150979382.13.9FDBDFB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B997100004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:56:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Z9+c10 C";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787928989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNN1FbraT595Q11XA02C0sYLaM9WhKZgaK9e6slIEqQ=;
	b=GlwggTCEYZk4izynWnfda0zW8uzt5V6LRFzgkmgBnsbppMa754pdgik1pa2C+kScNp5/tX
	jFS/BXetNQwd0Oi6ritzFe60eVY1knUlmlchDIzoXSlFYz14YMCRNlB7vuevDx4ty4LOom
	DYHHIxB8EdBsN29RJPcfP+djSDx0hHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787928989;
	b=FN4fJz8g5zsaictsbT6xToPDFomwaPkawtBu6WdD5hlZ6vq2qqTKt6WVIzwRw/827Voam+
	2cNHyKLaBSvObUru1AtUQT88/MS4hakoXH7DBtoBFHpU8t6UDeGCLY6m48ecW250LPzWbN
	8m9T8BSagKKAPPieG/OPtVZvbGIa4m0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Z9+c10 C";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=QNN1FbraT595Q11XA02C0sYLaM9WhKZgaK9e6slIEqQ=; b=Z9+c10
	CHQsAIKPsu5BTOt4bT7Ut38E38KJiwuY6T/cR9LP2p40WiLdIpCOR26xZFl1I7f2p/SkgQ9lHcWai
	INvQZJLMwANHdk4tDfu6MyXTAMJOssfXST8+fCGAtTbiD/RCqp9yuRlPwpIdE7yidzm/PYCxj0v/l
	W1ZtAa0K9iS6sS+uFmylrTojppcwNpQ8f/jn1Z6w8Aqohdn1/ll8feeITbwi4X4lxYe7o8ws4TICk
	fIsZ8qFYRpOFVUfTQjqj4qBvp9N/cEwWYySyCkr0ZqS8xNyDWTVeTru4W7Z0DDkmQbDDdNGHGnOP3
	2HgMI/nS3sQDYFiiyfYweZjivRsg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzy0A-000000090vY-2pUQ;
	Fri, 28 Aug 2026 14:56:18 +0000
Message-ID: <34c252862494db8432c702efec4543daa11ff392.camel@surriel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song	 <muchun.song@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, 	cgroups@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, 	stable@vger.kernel.org
Date: Fri, 28 Aug 2026 10:56:17 -0400
In-Reply-To: <apGaZdxAPH68kkCc@tiehlicka>
References: <cover.1787890328.git.riel@surriel.com>
	 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
	 <apGaZdxAPH68kkCc@tiehlicka>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B997100004
X-Stat-Signature: t3y558bzrbzhjd1n6pdwb9fsoter667r
X-HE-Tag: 1787928989-268690
X-HE-Meta: U2FsdGVkX1+omqxp+9kAEInDVlB+5s+cRme1SwpycR5FvsSkKClAQJNH7SJmr2kdgiYxkFLeYvcvSSzaiJc80rPqm309KKaTAshGodZBDvRsfQk0pqK9y4AK/QSvY+TrF0dbmjwnQavK08HXOV6WRZuY+wrYGdHZUQMdFnTAAa4XiCUW/4czv2YOlKz529bLe73JTPuRVU61YbRT6uMp4zK/KiSZhvQFgavv5yiQMosf7ZV/9jHS0/gECngoB4Sm6XUGJkQNMoxV8Iwvmf4zzkvfVhbKc799i1Z7woGks0zHvQ0eIvo9c0zitpneHK4OhE8XlZEGIhByUZegBK4QCA46lS7F9sauWm03RStYtFe7J+PXR0S3t5kdVNzPdlxOoXntLvvTfIG+NSO/e7jatVfVLNa5HE/JxE7iMbndL/JCcI1u3+b/V4lmi72vfH48nOcE/oiEuNZskXhd+U0AOVGEnnl+s6pfRITMwBWcK6IlhPj3mFJZsqVjsf/PxbGafCwyBwb2HqfTe65Etg2ytFgYaQRoNjemeN7Gu8hLXl3YtVlaIo4jrfdSmh10/JT+BqtPcTDUkpI6xb+CV5oW10kcEsXhHv+rKHGKCV/3Im5MiUd/Y5XRygAHTwtj5stza8OhEYe4OXgPis2nHqi6XHjQZaKTNkullngmUtzDvutaqn9ythUZy36Wjjm2LeGe3k4IzVd6e1Es6LWrA3PiH64ALcs2OPdrPsbc7cIgT0yubJRp3/UwCNWV2ydrKWYE55efSPqVQFHLgjnEdIQQCnl3kBpiZZpezK5n7hFrWTzIV9zDh+kVv/6E/c4+3FEC9rtzjVyKW5YE20q9+e4EQMl1Gozh54ZC5jXJ5YhaEWZF2QGQelGOmnKn4R7mwXBDYu9rNKp4L8wRUdyfDGNZFCQjL75lDN6Rt0XLx54iTE454F9XcnptFsEzpVTzEG5xfrWX6qffRjrsb1fDRE0
 VoIrBl0G
 A6jPF4p9F1sUAG5JSrsr7h8n/NWij1SIn+p4ZkFJc1pGj5kB8pAd/geS/D0rP93z8zT+OgQ5VEDKoqaN5PirMKn/iL+UO3RNpXNAt6jgHcu4hLaezIQnArhviFSljEUO634mqJ7wCXxE3BLtiJiew1svLSK6j0d9pn+fw8PLeCVVRd2AuYVEdSOOAeqVOwUHIvtQyV8AnfYdgE0scwYMhq2FGN2HBPKga4PlFNZwmYeALccBvu9ulNF423hbKI/c10NwXmHCQHKe8ln+HVTNiPs/K4E3q86xv5ow3ZtDcFBzCfvgq7i/HeEc777pYlI5spSyXJIlOy2QAXq9zUaveBWDM7rKZ5Z8OW55q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-28 at 16:25 +0200, Michal Hocko wrote:
> On Fri 28-08-26 09:46:21, Rik van Riel wrote:
> > drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
> > work is dropped.=C2=A0 It sets the bit before checking isolation and
> > schedule_drain_work() checks isolation and queues in a separate RCU
> > critical section, so housekeeping_update()'s synchronize_rcu() can
> > race the second check.
> >=20
> > drain_local_stock() only clears the bit for work that ran, so the
> > bit
> > remains set and the stock is never drained again.
> >=20
> > Reorganize the drain_all_stock() loop, reducing nesting, splitting
> > out local vs remote cpu handling, and skipping everything on
> > isolated
> > cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.
>=20
> Is there any reason why we cannot simply clear the flag if the work
> is
> not scheduled?
>=20
That should work, too.

I'm fine with whatever variant people prefer.

--=20
All Rights Reversed.

