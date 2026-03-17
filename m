Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D39CFEDA00
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767336B009E; Tue, 17 Mar 2026 14:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717F16B009F; Tue, 17 Mar 2026 14:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606E96B00A0; Tue, 17 Mar 2026 14:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 507346B009E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:33:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC6278AF25
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:33:14 +0000 (UTC)
X-FDA: 84556402308.29.0A53E81
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id B821A40007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:33:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AJbzuzm9;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773772392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAyrQCfig5/LAfzcQvG2jZdrUVp32jaEbU5Laa9IgfY=;
	b=ISUFdYlgE5GPB5Z+vHP6w1Bw16rp3r13E9E5YxE012FdauFTDSRlpGzNlOj1gCD5qovHPz
	rcaGikQ/oTaV9+N+9Eg+pvDKObgQE3NKHKW/kmmJS51us12mTznbhnsnaPTKYrvC6RkFaN
	X6hbU/D7m+dY1yoLkTGWQs5jYOrWW7E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773772392; a=rsa-sha256;
	cv=pass;
	b=DR0LZRNxG2eVIB5QzOEN+D6gvExmBZJKs5UM7ok2rqYgalsUo8zlTiAZzDNhCBdEpyk8w0
	MBlU28G4jlN7e6dSE/nzrfNxuBQqVy1TQAOaV4kjD3Vr/lWTzk/eLFR5Em+kIM1WtLVzrT
	eR9rqHB1heJeeDg+f7RijjcWRL0vbJ8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AJbzuzm9;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-666ee394529so2612113a12.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:33:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773772391; cv=none;
        d=google.com; s=arc-20240605;
        b=W36kxFdhpQ5CFb2UAvQgDZXqt9PBiTL59OgcEQt9LJC5MN/Jh26zGgaZrOb7QIhOZj
         IZfyY/25U9R8uR6MFFl/hfp/P7GFtOuFdbOYh2oiYu2aIeQdbTrl96Xw1QYogio2m4Bi
         4PRuT4MlQxFxCe07UE8TOOhpijtfaZj7jAsaIYC+ULosKvccoS7zghHbYSz2VALndMiO
         fzXzSlRmO8Q2w9SewErxS3tI0vLMWU30CTKu/g0jxdxEmaQuOogeLoPdH8sumj4MwluN
         A5mAAEREq3HwcF9UIm4YfDqVMQMfA2li7tGhe9+5sKAjaEqaTh+Yl+cNP+uLrVnQusre
         81ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tAyrQCfig5/LAfzcQvG2jZdrUVp32jaEbU5Laa9IgfY=;
        fh=s0DGekMxj6tFBI+WwE5lql5kQ5+fOxRtsHWOSsNkdoQ=;
        b=Jy3+QSYXT4HHy3uDxw8enIKHajGx+CTTTaz1D9ohzyBNxETO7Wa7N6ZYsypsq2mGoG
         1YRPqD21agja8q7EI9jcSR5Fkk0hsNjR0x6C2PB10ulknfJ60AY8ZVmNiMMLJRkylBpN
         6aecwqevHcbSa1dWhJ6m0euWDl9LRQeLsQGUJdC4iaUT82kuvpmxrPed4nPulj2e3vuq
         CnTtTuACb9jdJUfVLFiktAx/Wg7/RWNCxY3Bt349/yi3uDT7w9g17KRA00eMNS+vOqal
         ayDmOSMPxCbQGHM6lW7kqYKPTzpPg/9xIGr1Sj6u641+lTpGLCNL37NOFnk7Gw587TVc
         mb5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773772391; x=1774377191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAyrQCfig5/LAfzcQvG2jZdrUVp32jaEbU5Laa9IgfY=;
        b=AJbzuzm9zPiv095WcCKFeCUWyNrSqE6POeBmmxblknNwSjuqTjyg61qlKgu53yS7p/
         9AtaR62YsEng4sy+8lAsPr5raO92yBKP5WR5SyCJYfPKk0PAc/bwqFBUVYOimbIO7M8g
         0+oSNoaqCf26wcOtaHYrmMwDVkHsBQTGFxLR1jUtR8NUS3A9ONMmIGAVYdR0BLrW/+CS
         nYeplajMdpUW2nVUkP4tdMvxIQN06JGlX9GMf5wtrwDaGtS1hojRqfGmfS2B8ezET+kO
         M7s6iOUIQOIhh6FkwhpIzztG7/Z4XVRxvTSoYbcIlZrseJK8TyGr476yBzkdBgM+5yBm
         KPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773772391; x=1774377191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tAyrQCfig5/LAfzcQvG2jZdrUVp32jaEbU5Laa9IgfY=;
        b=mXt/1e59umVhmlTJbQTggreM/Nyt4oCRq0QMsBuRaDbtn9OLccI7MlxWt2zacwSskb
         3cykvPob/W72PiaK6UjPrs1Ykf3RFhoBeQRhnyIIptCYcgk2/j09QYkbUegfnK4NJCOT
         GsEC1bfMlK5UkET+yggY8J8WzSxi6VjZgsdtKbuRM9r2Zm6zyFJGU4pCoGGsqjLju5Y1
         fje74+0kIWGkmOQAP0FGpWmv3QVfk8h0Nq1by8NZ0McOUEr9mFVpgyWNtAeLGc5r7k1a
         VM7+8EcDlAGpm7CcZJpoWff00dOq3HNpDk9v0WzViVv6g0B4KtQEBY7Wqu2qCjpmwHbn
         AqeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbBcZbIdPDm0bKWfPLWIf2fpxjPp6Ges15TgMZxOubmt5WyVFhr28c1vVroxGtVokipxkhMusejQ==@kvack.org
X-Gm-Message-State: AOJu0YxJSNqHuMpEBWsN7ZmJxFe4meTXlXDw2Dqoob/aK06LiUwv2mNp
	ea4aLBJaCj7BnInDVzpL5pN9tj37ccE6ieDjW67BZsDfO3gN/Sh5zytCVfhSl+y+gXhu+wWFlmO
	IEcps1txVrBJ3Utpd6xMJwnl7CYInNim0Yw+/HGQlxQ==
X-Gm-Gg: ATEYQzxfM3rwXs7ym3Xfw0yLZyHj9UYUci5FeUtpvFnaXVaioMVtY8+ygrlK3u2/zR7
	WKSsGWosHhsI1eQq1/X1QFhnnk/4b9xXlKbGSeNZJXdgJcbD7sVe1he9kbwaQo32cznVXbl4DyF
	ouU/7wSjC1LefnW2uKSGsEYBzvlQstUcTxKpoTWTKhfVrI1XFC0TOpPZU/IIsPAHSTUn9vRB6Gs
	Bxj9Nzs7ol0e9b5xvoKQCxjwAYLa5TS1g78yjL6DetbhJj0/ZdIOeEzeP0kcZdtgYNeXhPrA/Q0
	ebOy1z0Y3b8rDr1XcCEh9rmKB5LlMyRda3V6GXAf17udHtb2
X-Received: by 2002:a05:6402:2346:b0:667:6073:fbab with SMTP id
 4fb4d7f45d1cf-667b1980f07mr556889a12.7.1773772390936; Tue, 17 Mar 2026
 11:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
 <20260317025049.494931-4-pasha.tatashin@soleen.com> <CALzav=cY4G-1MrEv1zNbqjdu3eXYnFLUK4xgo0r=DrbSdsXPLQ@mail.gmail.com>
In-Reply-To: <CALzav=cY4G-1MrEv1zNbqjdu3eXYnFLUK4xgo0r=DrbSdsXPLQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 17 Mar 2026 14:32:34 -0400
X-Gm-Features: AaiRm52fq7oKmnbeu_WHYpCRKUQbscba7gVOBfphGRHbk0R5kyda8GX57LwnRgE
Message-ID: <CA+CK2bCtYMoXfXdaOhvpQ5YUL-407qeCWqry92UZ0qKdEBv+4w@mail.gmail.com>
Subject: Re: [PATCH 3/6] liveupdate: Defer file handler module refcounting to
 active sessions
To: David Matlack <dmatlack@google.com>
Cc: rppt@kernel.org, pratyush@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n6p1ejgakngkqjoz6w9k96h4tnhwh1r6
X-Rspam-User: 
X-Rspamd-Queue-Id: B821A40007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773772392-388848
X-HE-Meta: U2FsdGVkX1+5c3a7p8sDF45XtpVtJtIhByRQUvFwUYQpkC8N5glJC1Zwbyc4w7KmmyIkpyyhDqV2ckDvw88zZBkowMeTqsfrjkyOzxVHKjtswMVyKDVZBrIAqt2r1ST9ugnBTi3XiL1677xmXziPM9J42ngL7xA/9rbxptIK82MvE5cH8zDnEOMkjhGgo9iJleZPmtGm5Es8Lgc2iRALfcLWz19GQCpybtHYMWcOFcy2s0o9S/m4+25uYzBPxifNREnh5Tsz8FfAruK5h2EoAivEpcOgnrdz3DE0d8oMZA7vW+XS3zcLSaZQT9Ym4mGgCXpVbZLkTw/Fmt0fH3dJ07C6ctlocnBfql3z5fLxKugZGgTqM/t5b0qI5OO1ouQ/6ZPkePPhJMq401WGegwF9qUWZ4i3I9KF3B2ru53sdpnqWhAHqT4OZYADF/faH3N48jJdwXyDGTM26TGM8FMhpViDkz/R44NxFhHoRIxGwMZ8GbT+Hvh3oyK9Tk3anChqzNhHuK9Yb5qXmuVoHywxq8u9pkW6K30Olku9704bhc2MezT4FtoPBIb1xcxFKDdrPOQjJsF2v//Kyi2gGGXuIYlBsEpt7cr0jhnz6DLTHeI/kjlcMP1q6h1K1+dfoxxqMF0aI2SGjt0aPlDWMd/2gTPRM+MY6ebmuEOH/g58tCB+oRgbBQYFbrq2Wp9umZBwG6eu/r/Pu69+wBUCCWH1JwJVxTkuQCDJip5pbU2uCFygmOkUR0Uhizm++JMkNFRQ8kFIhHumyzykuuvXKp3K1u1Hw6pb1wECuFOsOym1rqvNFqwmgxKlH7hWWtjP21ixM9d8h0G4/fHl3TQWh8QnGDKvMuYHoqJSWiomTYAnqbYRVQKaziCf7++DWNZB1qW0m76/Vc1rXIXV/ZinSYbCx7nmcKyhrdqf6agz1YwS+kylQOHSm14ZbUilyql5/7Jn3IUsbICjpi7VRVy1VtK
 NahFGsqE
 sVhB9ojwgESDmN7ofhQXNHummM4Cgazu0qqEalYYvpHnhMiAghMB2+7Mf+vlDuzpcXOT1bXkff2fRdi6/iMiVydsx8eBQGGkvD8pyemZdEn1kaScoADBDh/UqYy0kfM9cF5Jlhud4u9+0U3i0NXu9Tw2KARizkuPW4AWo0a8GfiCAkQKFdUl1y4puP0laOjdO2qd20Cv+qWO1L789mATxv4+mXgFD5l1k6Ugt4S21+I8A2ppSgT9MvRNq48WIBM58EWrjcBL1G53VvDEjltsyDvfLDbRivs4rv17vgsidotSHxcr2/Z/m4JL3WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:39=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Mon, Mar 16, 2026 at 7:50=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > @@ -281,7 +282,10 @@ int luo_preserve_file(struct luo_file_set *file_se=
t, u64 token, int fd)
> >         scoped_guard(rwsem_read, &luo_file_handler_lock) {
> >                 list_private_for_each_entry(fh, &luo_file_handler_list,=
 list) {
> >                         if (fh->ops->can_preserve(fh, file)) {
> > -                               err =3D 0;
> > +                               if (try_module_get(fh->ops->owner))
> > +                                       err =3D 0;
> > +                               else
> > +                                       err =3D -ENODEV;
> >                                 break;
> >                         }
> >                 }
>
> Does LUO even need to take a reference to the file handler owner?
>
> LUO already takes a reference to the file, and the file should already
> be holding a reference to the file's owner, which should (must?) be
> the same as the file handler's owner.

Hi David,

Thanks for review. This is a very good point. I will remove taking
file handler reference entirely.

>
> For FLB it makes more sense since the FLB's owner is likely not the
> same as the file's owner.

+1.

Pasha

