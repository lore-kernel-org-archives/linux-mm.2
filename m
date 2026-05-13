Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31F1CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624046B0005; Wed, 13 May 2026 04:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE2D6B008A; Wed, 13 May 2026 04:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475BF6B009D; Wed, 13 May 2026 04:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3231A6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:53:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED2031C06A7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:53:32 +0000 (UTC)
X-FDA: 84761783064.05.D584EE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 158BB1C0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:53:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFLSeyIK;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2zm1YLpEK/K6NLs3kxOMAiwgi/0XR4he6JT6xLecSg=;
	b=EuPAyiwC2PBUmdQOQGSwUXSKKQwNyP24gmvykhHQ5MOO3iYxg8lZjWMjTZUpOYChz8jGRi
	Min5d0jE1WIDoW1ALXH3zQg+ri1hM3iQLEVG46Z5WzM0EaIsiyxCFeO1ojPr4MNbHIgsQ3
	ZWFDzX00gU89T2iiIdViPrQigZjZs6Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFLSeyIK;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662411; a=rsa-sha256;
	cv=none;
	b=yh5rKgplD2HM8r86Fc17fOxqjbMZUTxUHaMV3SRG2MKjqSyDKU4bj8FkgstL5nagg0oOx4
	uEzBkjTjk8Smslln6nVXPyhaDprSuHeL9yJw5fA6I3NnahI6yb5zCv06WNr/X9KI491A6Y
	e0bnWMikPIIe4Di9VeXdshmA+qoJRes=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A98760120;
	Wed, 13 May 2026 08:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B51CC4AF0B;
	Wed, 13 May 2026 08:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778662410;
	bh=udpx4tAi5cV12nowkKiduLaSTNB4aDhgn4UtaDGhwjc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=TFLSeyIKM3nO5KtQ25NMjtAqXdTDDHhcEDTl0JmX2fDFXUxiCSzFjgYW4hiJ/kdcV
	 lTDx/Ur8cMtHJ4JFYAQvhMOO5KjjYHESzsEDcwNaq2J7nDhOPoP4ojQsW5vNM72UEP
	 mSQTuwPI7Fs3wlBcE61I1YJn+xY4ldHtMdPmBckiv7is2Kmg6c8O7hSuVMu1rB2vuE
	 pE/6n1M1+DuTGrrs5kf83NnfBMkzELv4K5v2TFLDhj9XAtvZxyIxFDyyEKgYogjBxm
	 kS1RhUgCVTGwUvMU/pFugdJ7qzcGeMbCHk8Le9p7IlVZIfKD2/87R1IWJ3VVpNDqyX
	 4V4Ck5iZaoTSQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7CDE2F40085;
	Wed, 13 May 2026 04:53:28 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-01.internal (MEProxy); Wed, 13 May 2026 04:53:28 -0400
X-ME-Sender: <xms:CDwEakOyH6OqlreTlGvvT2Crs3Oc2Zreu7-Y5q5ti18GeFTbRP4siw>
    <xme:CDwEalzs-Tm8WR_tpsIrmFwaojRXZTlrvddgPEBnyrn7qd9Oa-XmzW17Ajb5W1rsm
    ENwQdTzAdrLZQPEASmu0GifNfjvpqY9OP_ABNVIbFtnP35Hd7w8YX0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdegvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefhefgtefgkefhgfdvffdukeejheeuvedthfdtiefhleejhfefjeffieeu
    jeefteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    udejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhshhhumhgrnhdrkhhhrg
    hnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgr
    shesrghrmhdrtghomhdprhgtphhtthhopehmrghrkhdrrhhuthhlrghnugesrghrmhdrtg
    homhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtohepjhgrnhhnhh
    esghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhiiihprhhutghkrgesghhoohhglhgv
    rdgtohhmpdhrtghpthhtohepshgvthhhjhgvnhhkihhnshesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:CDwEanu0ZxvdrKWQDcCPlWGRQUZs_3Zu2ihfUq1ao8QuBRliJl_ZJA>
    <xmx:CDwEakwkNJDN5jK8LR56K91k_tsmxmY540V_2TCcSC26-5LgRKOeqA>
    <xmx:CDwEasZe1VaZQUnuPI0TcP3cnwXPrIei1cw3PCWgTVdElaZhAV0cuA>
    <xmx:CDwEajX9ywcTlL_5nyroUU_gaoxjHhgQTX7qic9mAwdpmvWY8RlFgA>
    <xmx:CDwEatEJFr18fZzdaekmfSF2cVsV5T1A9rG4sRBjctmlK2Mk6iEtPuAb>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 58AEAC4006E; Wed, 13 May 2026 04:53:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 13 May 2026 10:53:08 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Ard Biesheuvel" <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Will Deacon" <will@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <49d30ffe-b7e1-4b05-89e0-c3fe01348bb6@app.fastmail.com>
In-Reply-To: <agQ7RMAw51RlNUOj@kernel.org>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
 <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
 <fb5749bb-bc87-4f0b-9ec9-8a1eb7ded3b5@app.fastmail.com>
 <agQ7RMAw51RlNUOj@kernel.org>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ahpee78h3i7nbroo5ojqszinmebr5crt
X-Rspamd-Queue-Id: 158BB1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778662410-840487
X-HE-Meta: U2FsdGVkX18b0IKdYM5hikgR/bCEMGhsfy2r8KxIcFSRb6IokhAeCDt0ljk4dAS51NQDncLtL2m49PlkCT9TrBHFY9rN1QC6Qpy51cH21BhvUJAE+1WXb6+yeBqoTdlBk2mEZKC1VrsRQ10Jrn8mnw7rEezPdDV9TcezdPM8Txo/qp1UZ0ULMvhuLfhnl+W/560hrUySuyRFlIKEknoizZ/wjs9bEKeNJQe5H9N94FYKozBpcr0NVIB00K7VjAjG2/5Mk7n6NsOGH8/6/PXDhcO//t03NDxyHbdX4xzTF8Ea4idYXSP4qexOreJZ110mI6PQSVtYtf4+h7mJaFJhFsuHZouJ5BgCXtCOazhF0FF/bajh5yh3ebl07bvACpr63wzbdteC/yGiJxGF5FmJRxz5rIqlFLfFQZ+bpA0n8NYk5UOJO7dWw3Cg3DwZRucesuNp74HuTVte/6YaK5OqcXHvfBbhKOjRnIYFMf3HvvPabr0jbo+jn+newajpQ211H9hQCfwOtFtFwpoDWEmg75XB/oP1Y4yWwf6LeiX7wxUoMeoLa1lOEttk87Ms0chYbKxSdbMpWvzB4Vfwy9zTlPAGkCVmchaiAI89fDl3sfjJujwP/Y0yI5/HkVAo4+d3VUJIfc+zqoJGEthQYIhs7CkKHdXOY9tHgB2VUh01zmHDmv0Onoz/wFkWgTyEOin97PIyagLZ0JCbJZxMgsnsVpTGwIdDq95b/FiFC1ZGDpu9zoP74mRF5H8UzFZXMj/2iyg38IO3iXy5BNnbWDoITULYKa2yCCX8d9dVA3hvF14x74zqMnqt5UCIaalE7NbkhiaRWoFZffqywaZUw558OGQ40DWwby9g9PBYpVY3EZ05BegT43i1J6xwFghDznlMWgKIhyzSK/H6ni7FJ1q6W12F3zut1m4mA9DrEeijC2xv8iR+xIAth6F5/REjBerflG7GXQTQ2g245S+7M+A
 6lL0ibDN
 LgBDVc05TdIXS4+dGg0W0uYVYww2dO9cEUW9wq1SWad/bLMkvzGlh3j48A1Euw+gx7lNKpRwJuH5NhF5YLd+SszUSnaUo6i1JZjlbh5vaQYclmdm6Ex7InkiAXCMvXdVGNl3rH4+ALQQdAkQTzFOy2FvQ9mAWTqhs3MkWohg8FzgfwwDQdMvjeuj/XsyqIuRSMjFyook6/7F9vU+AnRLeeYp7Fp9zVzTKIiOnODkc3XBxo2O1pp9eesPZEidW3VCnCdbAvvUc9J7OTN2tbZmF2ahMkRp81ZbxeP9725wRdHNqluRLlytsfGJKKoAxoacCkcMY/8RKWx4F0lBmIvfmXwFK+JQLj9Mh0lSSiCUIezr+IcxZjOeYUp+KL+HHNriMx5DmspKkAK4Nc+sFB0P5/SQJMrLr6uewhd/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 13 May 2026, at 10:50, Mike Rapoport wrote:
> On Tue, May 12, 2026 at 02:56:16PM +0200, Ard Biesheuvel wrote:
>> On Mon, 11 May 2026, at 16:40, Jann Horn wrote:
>> > On Mon, May 11, 2026 at 10:59=E2=80=AFAM Ard Biesheuvel <ardb@kerne=
l.org> wrote:
>> >> I think we should simply do something along the lines of the below,
>> >> considering that the size of a data object tends to correlate with
>> >> its minimum alignment.
>> >>
>> >> I do find it rather puzzling that the compiler emits empty_zero_pa=
ge
>> >> *after* zero_page_pfn - ideally, we'd combine the below with
>> >> -fdata-sections so that the linker sees all individual objects, but
>> >> I suspect that would create some problems elsewhere.
>> >>
>> >>
>> >> --- a/include/asm-generic/vmlinux.lds.h
>> >> +++ b/include/asm-generic/vmlinux.lds.h
>> >> @@ -452,7 +452,7 @@
>> >>  #define RO_AFTER_INIT_DATA                                   \
>> >>         . =3D ALIGN(8);                                         \
>> >>         __start_ro_after_init =3D .;                            \
>> >> -       *(.data..ro_after_init)                               \
>> >> +       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \
>> >
>> > Oh, neat, I didn't realize that's possible. That seems like a nicer
>> > approach...
>>=20
>> Neat but rather ineffective, unfortunately. (I don't see a size
>> difference with the arm64 defconfig kernel)
>>=20
>> Given that empty_zero_page only ever gets its address taken, we
>> might just move it into the linker script if that requires tweaking
>> anyway. We can just place it at the start of .rodata, which is
>> already page aligned on most architectures (and will become page
>> aligned unless EMPTY_ZERO_PAGE is #define'd by the arch linker
>> script to something else)
>>=20
>>=20
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -472,6 +472,17 @@
>>  #endif
>>  #endif
>> =20
>> +#ifndef EMPTY_ZERO_PAGE
>> +#ifndef __HAVE_COLOR_ZERO_PAGE
>
> I don't think we want let architectures that don't use colored zero pa=
ges
> redefine it.
> If it will be really required we can add the ability to redefine
> EMPTY_ZERO_PAGE later.
>

I was actually intending to add use this for arm64 in the next patch. It
already has a reserved_pg_dir in .rodata which is page-sized (i.e., up
to 64k in size) and guaranteed to remain all zeroes, so empty_zero_page
could actually be an alias for that. This is what I had in a previous
revision, before you turned the empty_zero_page definition into common
code:

https://lore.kernel.org/all/20260320145934.2349881-16-ardb+git@google.co=
m/




