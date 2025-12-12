Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73B9D4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FFD6B0005; Fri, 12 Dec 2025 04:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10996B0006; Fri, 12 Dec 2025 04:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD87B6B0007; Fri, 12 Dec 2025 04:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2E76B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:52:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48468C04BE
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:52:31 +0000 (UTC)
X-FDA: 84210354102.14.34D7C89
Received: from mout.web.de (mout.web.de [212.227.15.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5930740013
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:52:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=odnWSBUf;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf12.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.14 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765533149; a=rsa-sha256;
	cv=none;
	b=13GjWI0lTk5JcHvAiAarCZtPziWlvIpfLmEAYnOGFTX26MgbcK3qkuKq8NZrP9WSHoAXog
	XItLGajYXEKbtCnbSko+udqFjibFQE4yqaGL715y7ZUezUAANPK7NbsbD3mYo7vqcWM8eR
	5k5n+dfpNcNGO46h2nFKBk6GPCE6CbI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=odnWSBUf;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf12.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.14 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765533149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dtv5YfVKWvqekBEDQEStEZlHajPn42BPyX8iEnS+i08=;
	b=CaaFH5rb7cr2bTud0ZPDpFnvF5ZWjpBt9DK1F6zvbINmuGO/C3zmrRWY5OnHEgSWJhl/K1
	kcs02T0gSDLnsCACr9EkgRWHRByCAhR/gYFG8Or7QMMRtQdQNZmAXcQHh6tacw51KhXoO6
	Mq37+a21O6KBTvrpe937sxIxw/D+l+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1765533095; x=1766137895; i=markus.elfring@web.de;
	bh=Dtv5YfVKWvqekBEDQEStEZlHajPn42BPyX8iEnS+i08=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=odnWSBUfgMRmsvInVSTnqxmiKv50/9tu1hWtc8/ESkw0BYHKSnH6UObMb/vUKEJ5
	 kHQLpkIKjLWiQt41jDI4uU5jGMCXdVzjgLCtNwjMW5ZlEOiQKnYe41RQ3wS7PM+n+
	 PHC/biHyKx5PZgn0GPOW0Zfxoirck9VzsTKQ0B2vntK9PPsb2TRaLOylJq9jQvnXd
	 5OoG+UTmgNpw0O68r/3L3SUX4mGKBD70myrF/lh752a9rRfaiPbXSdTu/nc6GrtpW
	 wgs/Lp8Z6hEpAvI7xiyI2GAczzAt/+t6/dr1JF+Mwf70wCe1KsrxlniJfS8z4+HzP
	 JeVrW0FR8l0oGtrxxg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.180]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MV2OY-1vdEx70kqM-00L8R7; Fri, 12
 Dec 2025 10:51:35 +0100
Message-ID: <b4023748-453c-433d-b3ce-45cf42d74889@web.de>
Date: Fri, 12 Dec 2025 10:51:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v5 4/4] coccinelle: Add kmalloc_objs conversion
 script
To: Kees Cook <kees@kernel.org>, cocci@inria.fr,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org
Cc: Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>, LKML <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bill Wendling <morbo@google.com>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Jakub Kicinski <kuba@kernel.org>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Justin Stitt <justinstitt@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Marco Elver <elver@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Pekka Enberg <penberg@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Randy Dunlap <rdunlap@infradead.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Sasha Levin <sashal@kernel.org>,
 Tony Ambardar <tony.ambardar@gmail.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Yafang Shao <laoar.shao@gmail.com>
References: <20251122014304.3417954-4-kees@kernel.org>
 <71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de>
 <202512111352.387A339CE@keescook>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <202512111352.387A339CE@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PhTgDphTssUyrodhgTCx7Tqtgufwo1sjpK9UJ5w9XqTxKWfOXaU
 O/cJ2ZnIYWd2plns2xNoLZ6Wu5a+3zBgF7aOQyD3Tl0erfE6h9xUo4DOItCvDl61epaLFQS
 RGlAqFD4gmTcyOD5b/81KM3BDkbHlK7xY5VE8ie6O6ZPc6tLhETNiLSaeX3GrZeV6DAenKL
 EiUOldJE6L0VHbBDRAIGw==
UI-OutboundReport: notjunk:1;M01:P0:fFhpdpeAcsw=;6MaFvpcyAnAkj21LKn1f+O6CLgf
 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
 jtBNOANA=
X-Rspamd-Queue-Id: 5930740013
X-Stat-Signature: xw3ka8hci1apqfnwj4qaspz4x681ss7g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765533149-809425
X-HE-Meta: U2FsdGVkX19Lo/6GtEjRFPKOokd3G1yaDnW4sTBrilj2GTVfgzIw7JKxFi/QN9zuF9RMYGD5sVwlM25KjNUuvrIFkutswPHgoClClymQyqzFdX5g9wHrWrLyuJ5IOcdznYWmO+U+fI0vkgyyqMh67uNubIFyNtEk3s8eQ9GZ779krWMOtvpn7P2VpUbAYMMFXYZG+EC8wC5J3qCwd5+Q9J3r6shfSI/8kqUKuOz2RTa9b9+ewY3SOkbZ86MVE2svlbjjtyi8e+sSXVbQ+QXlQj9yzK03/iiHYKUjeEg35YaJDrbaL5jd7e/GrwMa4hf+j0s9CP6GCChmqN7gcTveGzNYdYDm4/J82NplIC9vixNJK0x+dnJR9RKCBZRW1ndHSIAwt8mmGsd8W2YxpxgbFBi6nAqgH+TAu+03ZucUmW4/Pia1BTfwyL1OF+Ad/u4W9ftAavOSr5UAqfuSbFq5Z52CIZM6gJN7cxkaAx1BnHTPbNzoPWb3bMz/0xnMAvA2I+o07xG4PcYQEAcGJXXtI0qvV5d2rB4xfZKhniD1klII7wyA6vTQMl716hO58g4yCkNSazNINYkAHVZtB/zVCFMxjUH9rV9L/YlL85W5aYCPD4FT/vqvYJ5d5DhSwCOKox1u5hnNhJnpO6MJELHpRT79hHWpOr5QUsbkcED4IJQ0hCYn6S1O8ME2aAzrvqt5Kl/daH5kf8LCR9ZxWkTWuIf/V+3+PzDb3emkupwkPXsiz8cweius+9PO8s1uf2WCs0H89BdxV1cnkOqmz+SF0BCxT1T/6jmNLQqPlpzdXXsn+nw+1hDpOLfhFpZ6ilzWCewRRRQOxp4HgQzPpwIPwsBa2O+e0xXgjeqA5Ej6to+omOKOh807NvcT8x3dj8Ia45T5ZjJhpR1SNJga7QlaNP2VReakTASKiwQ6r9UoUdjvH+JtUcR8sovdw7RXlLxSlbvFcI4bxKlXvBN5C1P
 5Z5ZRAe2
 mczQmLRyEyXy0djsUf2TRmh5+53idQSDsVUOTuVsG9zgAAsmnJm7A12P4PoDm7GAHAl07teaKuA5czhikVerPAeN1S9Sq1y4XvSNd4cEwVpLK+r7j8d7CzUt3OGf9cfQ1gk4nzdLXvkfyb74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> See also:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv6.18-rc7#n94
>=20
> "Describe your changes in imperative mood"
>=20
> I guess I can try rewording this, =E2=80=A6

I became curious once more how another improved change descrition can look=
 like.


>>> +virtual patch
>>
>> Will additional operation modes become relevant after clarification of =
implementation details?
>=20
> I am not interested in other modes; if people want to contribute them,
> they are welcome. :)

Will development interests eventually grow accordingly?


>> =E2=80=A6
>>> +def alloc_array(name):
>>> +	func =3D "FAILED_RENAME"
>>> +	if name =3D=3D "kmalloc_array":
>>> +		func =3D "kmalloc_objs"
>> =E2=80=A6
>>
>> * I suggest to avoid duplicate variable assignments.
>>
>> * How do you think about to collaborate with the Python data structure =
=E2=80=9Cdictionary=E2=80=9D?
>=20
> I wanted the stderr warning when there was no match, but to return
> "FAILED_RENAME" in such a case.

Such a data processing result can be achieved also by a more appropriate a=
lgorithm,
can't it?


>                                 Using a dictionary was basically the
> same length as the elif stack. If you have an alternative, I'm happy to
> replace it with what you come up with.

Is there a need for further case distinctions?


>> =E2=80=A6
>>> +type TYPE;
>>> +TYPE *P;
>>> +TYPE INST;
>>> +expression VAR;
>>> +expression GFP;
>> =E2=80=A6
>>
>> Such repetition of SmPL key words can eventually be also avoided.
>=20
> That is true, but I like having them separated -- I find it more
> readable that way.

Under which circumstances would you become used also to more succinct SmPL=
 code?

Regards,
Markus

