Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EA6EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3566B0005; Wed,  4 Feb 2026 15:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991D56B0089; Wed,  4 Feb 2026 15:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873406B0092; Wed,  4 Feb 2026 15:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 751AC6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:42:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2479D1C1AD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:42:01 +0000 (UTC)
X-FDA: 84407946042.27.260323F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0562614000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:41:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=geLl1kB1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770237719; a=rsa-sha256;
	cv=pass;
	b=tQ7P4pdmdapue0V2HGOluQQf6Z38dFUBIhdCZjjbDyN7Z3BttREBQ0tQuupOal7Zlh1bwd
	Sl+broCxxxplF6LTqEGimE+vHIJWTUmu9glO+WZfuwBT0RibXh8Fz65to7V9i5c/r//8q+
	h78+ZEaZ4qJxupuMke1nFK36WfsROG4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=geLl1kB1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770237719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7i4rHjRK5f1TGPWpwxiWByuZAhcxb34AQFkGtKhCa8=;
	b=JCQO90hX3kRMfDLx/wY0buCHCTVfJj6NQdqyyCQ1Zr8yCZu9dZ5z/XPv9KCvCE2DBh+e1j
	Ox+hQIt8aYgJgccaBhEqEDxXPlCk4wp82SFvtX2myzLilcCxXSl9DWoZzYJx02ALw50EpY
	iwnezmf47fLzJH07zlTdFIkpdsQk0FY=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b883c8dfb00so32100766b.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 12:41:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770237717; cv=none;
        d=google.com; s=arc-20240605;
        b=RwsU8ujpsjDAC+FXj1iffiNZqxiPRTPJ+waZwjmXof3/0091WVtMXZrSezwHPG7LUo
         ++xPdWmktQnS+vzyWbu0JCprhvvITZoOdh6Sh9Lo0DmVajEmR+hO4/ptKVxEgSo8OZjV
         Z2HBpoY8xisoCNEuOhmocnqBzh5pTNMY3SG//QCIZ4NAr0K9Iimj+eon19dKiT62tHuV
         VBgI+1wu/4E3Yr8fEvESJ42q3dHpB5yrhJuMXz3aYUm2hTRnanKfox1JRa/HabRldTaL
         ByRzTMbPqGgzhHx3+B9XIHjkE6LO/jl7HorEMtVD6/OGQ/chqMdDBEifdq2dYIvZX5PT
         11nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X7i4rHjRK5f1TGPWpwxiWByuZAhcxb34AQFkGtKhCa8=;
        fh=BpzAbLI+Apf1J663HrNR0l1Wp6CmJaVKC2BzkIzPTGA=;
        b=CLWItuN6ZhI3ybBTowUBskwpk8fVwc/U8Z6xFw5Ytv17nooAZR3ImVCiXH6Vjk6Nec
         7Q/h1e5sE/qJ2hPjIhh67GyuVlomFVAoycsOEonuJeOxLuF4DETq8/EvY8euVMoxgJjn
         R0M3j/O+3cFtgMUPMtS3+2ff9wGh6VRoFkxWPbMcPUMFOzNWTFq1rZkgbJSzv5VvXalo
         oPDk0ojcdvmLvCZg+bVLk56CRRuktClrm07op5MtGHkfRAz5fcbxQMWqVys27lteWsDj
         WMpa8a+Is9DRqMpBPfgUxV2qceilpGTUmW/8h9Ans4ja253ACSoZWh5ODy/DujXS8+5S
         Rbvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770237717; x=1770842517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7i4rHjRK5f1TGPWpwxiWByuZAhcxb34AQFkGtKhCa8=;
        b=geLl1kB1UzAkkH7cQ+73r20D6s1c80THjPrvXDqoQMnyc+gPI7R8W4qQ/ZmRJsQbH1
         yitnyE5IdtYn3M6kVipjzib7FHXQ29qA1UoxPfig3UMz/iwx4EXN/J3zUYkTqabrMOpM
         w/VHPaIEkfke4Uu3QMpBKbj6917vYheNPtupi8rLDyKfnkXlSkrcj2ETXEbS5ho8/jUf
         V9TVYa9Ei52LAYo7wsXwFtXY/tpeTFPqUYjfHiIkyscK7SBYlELNRXIQlQjaGX220n1a
         bobmf7qbsOLXExBkSkQ4LJZVsIqvEmDiPu8ROo8lfIa4cm1qYAVFS/ocf3fU312+fj8w
         ImoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770237717; x=1770842517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7i4rHjRK5f1TGPWpwxiWByuZAhcxb34AQFkGtKhCa8=;
        b=WlfK5W2GNejJqGt+/+AMyWQ4wqIMHG4Z1O4CP16SCT2N1hQLyyBVVmh69fhggIMrUs
         m1JUbBUllH77NQCKhMEQz0gcw5XDt066RjUSBqX/n0joUni5uxU8lkkKLA83BTUcExhu
         +ybqpvdwtqwH3SvPprcKm72rbqOunQjwqka+5iX/sFWUi0THTbK0Nb2iNUCweuRXgUuF
         Ix1Q+WCeZqMgWQl1sgfkQY9rVko5Hu1qsthqAP5AhUaj8Z2IOKnQh7q6dnPwZ6/MEWI4
         skAwrmwX8rGfyiOVVddA25EFs534fyF1YDW65E3Kz+901QXzKklRdIikLeCOba64XzLO
         Uziw==
X-Forwarded-Encrypted: i=1; AJvYcCWL5gv3sG8RlDDdwir0A1O/DShlOF0bE5JL2yhnLVi/eaqTIJ57AUGOjAkBiz66av0iK1y/TnMzyw==@kvack.org
X-Gm-Message-State: AOJu0YyUlkn9eQGB3+ulT4q6H8MfBwkTh/cEUC61ZFmxVi4QhRAnX/R5
	PwO6OtbxHcHwWMexFigrb75qUkGGFq5uaa0lwp/22rdVr/BD6uqYbbAe+PsUO2KMBVs0NGXn9bX
	C8Y08vISnIU10ZFQulI9WM0ZqYItJR+M=
X-Gm-Gg: AZuq6aI33eVKFzjc3ZiWSPc6WuVr+hguYRRy+u9EVniG9+ywaOeXfhZ8dPMJbSeYkCt
	2V3CXKtbEZNWgWLaBjvoCOL6nRL+a3ShFVMUMsEC24cX5kIVrtRDFmghNOBaB8+nZdOGggqzBJT
	BtNQmnB2rfpxCoyOKfFlZ86bPSuNK0nK3R5GtoJ+CtSSzWZaxFak0q1BRnEX96NMCrW9sU1qg5f
	HL4pHk5s1beljpvnc9mRmU6CYeBPFNqyu88c5hHkfPEoCwqXayv0ybsifRJaQ41o30EktIh
X-Received: by 2002:a17:907:1b0e:b0:b76:74b6:da78 with SMTP id
 a640c23a62f3a-b8e9f3c9e6cmr300739666b.35.1770237717258; Wed, 04 Feb 2026
 12:41:57 -0800 (PST)
MIME-Version: 1.0
References: <20251222141817.13335-1-klourencodev@gmail.com>
 <961095cd-59d2-454a-9b97-493d12f296a1@kernel.org> <CAFveykO9tAhGnKCnSD-2_wt3QxMTNF3sW20NGwnPK-3yMd__yA@mail.gmail.com>
 <1690da61-412a-457a-9bb4-1135838135da@kernel.org> <20260131164310.048caf9636063986a8b517e6@linux-foundation.org>
In-Reply-To: <20260131164310.048caf9636063986a8b517e6@linux-foundation.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Wed, 4 Feb 2026 21:41:46 +0100
X-Gm-Features: AZwV_QguiseWw9_68e_bSDO4lY6LVsI_xbr3CLOEH86uGTUQ0YP9nKFW3Cca7rk
Message-ID: <CAFveykMPrkb=VYwQAjCEARsC_WAGfQXMz_gf8Q0CTHWHooNHVA@mail.gmail.com>
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org, 
	Kevin Lourenco <k.lourenco@criteo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0562614000C
X-Stat-Signature: enimypih1ekmir5kquernt459fgufjfo
X-HE-Tag: 1770237718-6493
X-HE-Meta: U2FsdGVkX183eaq7LphWSkyoLzLz+9PAPXcdZ5jQEE83iv/izVTzS6gDu9lMCNrC5mCAl8AMogBbd1i0blUw0yFCft42EIUAlqvJmPoPeXSV93HRS/MRfEEueqkMaZldTBj7ek4gKsvNbEveAqMUHOMR7FVxyPExbUXp79SsxXX+i/0NpyVqqzay3+aak+PHxVw0Nn9RgizWrwChSkYgh1oU4akhLi5ozMSoh2zjah/tC0jcNhJHcRPZIct50Zs8qMEHN5CYPPllLZtbZkR/Xg+eeW9aNaQD3YdMr/B21rSXCEbxhSCrT2V6q7FlgcP90oget02FQrhn/Eehhmb7y+JOoaZMEPMSnrISSPrfvLoTUBa1ls+Oi/T36/F4UApJfcuml2aIPfP9wEPnu0aIXZ5FmqfBpPgWsEAVGhYDU+CWLT9Z/7HFCrIO9jhs8fRT+Naznj1GYlaEVJNuCm5armNX+AE2rBAV+bZubrsJLSoXT85GLpeprSUIad5o2WLpj5UmZGtEKgTMf8814dQ/OHAVCwZ6wAxijCMu4BEZC6yqYiBbhvJ03n52UwG0bF8RjGiDORblUFSJ4oeXbtS+Su3RNKD6Fw80pblykIb1/GOAW97PO1HR8l1+ntgQvEz8NkDAYtnkdu1tNvDipbUfYuc60smUmUT+8fbV4i3H8/xLXWZWx/Lfc9nKCQcx4oG+lEWe3e0ZfkndYtTlZFeMRIP2n83bh5VbQP2hUT0zv0sCA9CrSWXseD7tHOw4YoHOlsrnvy5cWcCkJXjjHC+eth33/r1xXiIbQiJgWnp/Uev2yf7rZiofoxICYuldLJFOrFxXHh6xbY5t4OzwCTtQowuPxQ9iGyrrOXZIYchXwv+mHHuvCd8s9YRJ43Q50BrntmkuRNx87zBhafGIa2F6wO1bG+6sW9UplKSvw/4MBVHZ9mOA6iJGnyp6QSmnvICtEy2DcY5y5NOsBVBJ+sZ
 EoGlHwSf
 nGAO+zQIHRsxeUR46XReU/lQKhwhQe4zRTBLAbQGZ52oiGxexg8o56RuirIC7QAf2X1I3kbgMaYriKQAQiT5KpNDjvYMHLznx2Q2vrJaYMGE0TsUcT7TkvTbjsmy5q0RmJpbiyln5oRkYjqgPini7wwwsCaCGq8mCsceceu+JV5JYNeq/Cn7/XO3S9owpq6oNOe4nCLM6vShNPBn07HVEbGq5T9zquTjqVbS+UH4NhwAf9Ga55uiLDDbjvW5vgWuwDQ6X2yY6bdHjlOSwmxhT4kHCfvM07cNM8MVtcj/30itB4orcPf0N4JVgKXWHGovP2zZSmTnUKRVK5zCsyePMCaqEPp7ZMfdm4tKq3xyraZW4oLzj3XBMT1nE1qAsNbpZkJExSVc4nw6DtwqO0uePtXlJ+WEvdYqAX/8Gb+Q5rDpoWpCXJM1/OenUvoBljqEQmB9Y5IBrAPLvggh4JHjYIIGCo9Bip0pdQB/KgVP0gXctnDTpbWi275xJM0Q7euqpWwFHk3NNJtOM1XWXydgmJ7U6WW7phd4wV++rGaFCV6rCnNMAbd0CPieA4pohJUetpmnS35n2u3H9U4crSpdRF0Fc8V0pqlqZi1kiNy1+Wyi8OyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000013, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

H i Andrew !

Sorry for the late reply, I=E2=80=99m a bit short on time right now, but I=
=E2=80=99ll
try to send an updated changelog this week.

Le dim. 1 f=C3=A9vr. 2026 =C3=A0 01:43, Andrew Morton
<akpm@linux-foundation.org> a =C3=A9crit :
>
> On Tue, 6 Jan 2026 20:46:14 +0100 "David Hildenbrand (Red Hat)" <david@ke=
rnel.org> wrote:
>
> > > Since I think nobody intentionally passes negative values and since
> > > that makes no sense semantically speaking, I think we can consider it
> >
> > Well, then why document negative length? ;) We should be as clear as
> > possible in the documentation.
> >
> > If POSIX would have been clearer we wouldn't have this discussion :)
> >
> > > unnecessary to update the man page right now and only think about it
> > > in the future if a negative offset gains a new meaning, for example.
> > >
> > > Wdyt?
> >
> > Likely we should really update the man page to reflect reality.
> > "Starting with Linux v7.0, posix_fadvise() will fail with ...".
> >
> > Given that FreeBSD rejects negative offsets I guess we are good.
>
> I'm still not sure what to do with this.
>
> Kevin, would you have time to update the changelog with the additional
> things we've discussed: linux manpages, POSIX, freebsd etc?  Then
> please resend, cc'ing linux-fsdevel, Jan Kara and anyone else we can
> think of ;)
>
> Thanks.

