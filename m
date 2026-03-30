Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F0710D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03DB6B0092; Mon, 30 Mar 2026 08:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0FF6B0095; Mon, 30 Mar 2026 08:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1766B0096; Mon, 30 Mar 2026 08:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADEDF6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:23:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61C3013BB14
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:23:39 +0000 (UTC)
X-FDA: 84602645358.12.DF215EE
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F55EA0013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:23:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774873417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=woUempTeRL+MJtlKxpfNaT94H+rNPuTZjIMDTveSMCs=;
	b=mmHcB7BO8WLruYFcsDnpWQZtPRm53B+NHYp3s7OeUEcocMrdbzuWRguRe6c1C8Vrh8rrq9
	Pz+r/e+IcjsR/wv/1gWOAzCMT+aqwO9TF0F47mgyoPBKnxfiQELkwBdqzFoOLYJHVW7nGM
	h0TYrbZjUernSpI+4q7iWEFrlKplxWI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774873417; a=rsa-sha256;
	cv=none;
	b=EMGutX9EBzKIDuz6Nd/4/rFstJmKQotfuHIn1Ipvlh3I2kv1NhkY8uW0C/mFtuJ1X2AF2B
	LqhoF6D/wjSboJif7V2ZgVu3vKa4s3xN63N9ypE3vmXIEFPJ6O7rQl7ATx+/oME/7uYNND
	7SnkDfVwpJvM5azMqJeF96tOkJOrveM=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40974bf7781so4325816fac.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774873416; x=1775478216;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woUempTeRL+MJtlKxpfNaT94H+rNPuTZjIMDTveSMCs=;
        b=r617xnczQF5wbSPghNihMFoVw1ApUcL6NAOXe/y1GrjbKc+2f9NDWaoxmtooUJ0K/5
         eiEOZXyrdxR07hiQ2Z4NwCvRlKkRXj0kTvsAzwRNc6KgBGRMOA5Y1kTjKqSpFpyPFI5W
         NfNOAGxDRsSOTlzfTZoD4KiClIY8lPPzt9x36ideJngM6EvGrvQYKOjkm2U919zCAAZh
         mAOJ2OirDyF6NNgCCcTKrlS1EkyhdU+RVe9wA8ntM2u7GzFuwzkVbBbEJue3CuQSapNH
         ODsRBj3rBEaR7O4vlTTXkQVseW2wlWtSQqyEtJo/ffP6I2jMdcSkRPKtje1FJD2BTgTq
         op3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCAXaO4iqtAt+tsRfsYMgLd1+k/4JrYAX8lqTs3AhbiUafgHMrKzHafrnJK9wOfiKyU1Az0toORQ==@kvack.org
X-Gm-Message-State: AOJu0YwYOfGnHtbLyQ0qKUYpwpTGwdVTm35yj6dNdLZ8P7Ax/nnPo13e
	8YUyv4ygiFvAiKUbF4wzGIfybyA3HblW0sTAnh8IRWbQftRwLwt17kJVFhj5tQ==
X-Gm-Gg: ATEYQzyzxooJchkcqlDbGGi682nPPjL4ftOBWr9BnofdaU7Bt7ef9fWWKjm02PeH/tc
	9Hkt75+2z2n5SGV+WBGD0pUk+m8GxR/v+E3Hyvg2FhCf8+3ImD+PEgONIQcTXpGMZj6BcowpbEQ
	0nxFWYfFbswJ0KUt8czQ//C5CNJa28EjuQYy4fHM4mKWkhSsXlfSlRUEDtJ6Lwm1cOYmFtlCPUZ
	WK0Wp6nyZpysO+dZ8TQPFC+M+SaUH7pdeU7lQErSGS8uR1uBGiAcz560HK7SvHyFszzIKR/hp0N
	Sf2yZvXHCtF7VBOTeDYK12iurJ4bG9/CR+d0jNxiepl2JJZeutzO9YEoRS1czX8yijs/HZry4Ab
	hGxqr22nmvyvio5HQ5jeOmlPGEVpGCBKUEYbnJOMsSPgTh2bKtr/zfncKlDuDfiGBGpxZu53AVk
	8rQzi2kxS/LcX62p/j+QNwixN+m1lmYB2fzpRcpj58UgPCURt1vRCQNeXUHzETI5/rt0EBgpKlq
	bo=
X-Received: by 2002:a05:6870:3d91:b0:417:1f77:7606 with SMTP id 586e51a60fabf-41cd7dd3a7cmr7295145fac.24.1774873416210;
        Mon, 30 Mar 2026 05:23:36 -0700 (PDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d04cf9e03sm4545853fac.14.2026.03.30.05.23.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 05:23:36 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-467161c4ba7so2560097b6e.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:23:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWYUwsDZbXbEb5jbIrhwOkulwkMIw82Na/Sy/DQ+RVSN7f6BYJlofLwMuT+zPXBYuGh5phO662J8A==@kvack.org
X-Received: by 2002:a05:6102:4498:b0:602:896a:84ba with SMTP id
 ada2fe7eead31-604e4df3704mr5271926137.17.1774873037674; Mon, 30 Mar 2026
 05:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com> <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com> <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
 <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com> <CAMuHMdU-+dm83TVttfarT7QxE5ySpQ2LJ_k6oFKMWRcbaWcCdA@mail.gmail.com>
 <26d690ab-d68f-401f-ae2d-7aa4de081bce@app.fastmail.com>
In-Reply-To: <26d690ab-d68f-401f-ae2d-7aa4de081bce@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Mar 2026 14:17:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWDy9mNuzDaYfE6r+P8MSTBEGsyRzisLF_d_FWX+6qCVQ@mail.gmail.com>
X-Gm-Features: AQROBzD1En3iKQ5LsAPqOXpbj6O32MjUPo3QPwr0lgIQkMqaR2Lx1_ZSwol-K3A
Message-ID: <CAMuHMdWDy9mNuzDaYfE6r+P8MSTBEGsyRzisLF_d_FWX+6qCVQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>, Christian Schrefl <chrisi.schrefl@gmail.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Alice Ryhl <aliceryhl@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, acourbot@nvidia.com, 
	Andrew Morton <akpm@linux-foundation.org>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Danilo Krummrich <dakr@kernel.org>, David Gow <david@davidgow.net>, 
	Gary Guo <gary@garyguo.net>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Stitt <justinstitt@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, llvm@lists.linux.dev, 
	Benno Lossin <lossin@kernel.org>, Mark Rutland <mark.rutland@arm.com>, mmaurer@google.com, 
	Bill Wendling <morbo@google.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Nicolas Schier <nsc@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Richard Weinberger <richard@nod.at>, rust-for-linux@vger.kernel.org, 
	Trevor Gross <tmgross@umich.edu>, "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4F55EA0013
X-Stat-Signature: kcexd5yr7oecmmsqgmuoxg7te8knn5aa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774873417-335288
X-HE-Meta: U2FsdGVkX1+RhWqRjtjn/hU/h1zMbNGKjhQzJeP1SDb05yyVsruUHaEr90meoHL8QUzR3nRPUgAyJFklghl9epeWK8lXNbQWyJiz2slsrn9EO/rJnPjHyFxqPxoYRcWL/NPskdKi6Rz7aDwiy/6TGy3p9B2NR1QTvEZL8iYsHFb2ZGGACikmjwY4Oqg1lt8V7DAUim/q93ugW17jEtQzVTjfIKlmV12gyYH6LM9EE58JEANlXS9yBZE0SDN/FnqC3z7CRaIYWrnJ9xzepI7gYrXK3uxTR4nPXuFD+D/H9J64SeWqnFFHdTfg4cjXbGe5KeJT0ake6IcYaoSmR4xHuhVpB3HayR5qYbLDwxP/HjXQWk0bRQV2xhviGkOzYzIgLlMQhr2vQQIYEnepSagyXxK/BnKXIRFmxb7xZGb3lBzb4ajfZScQFYiminrLGEdcb03nXpHlCW27t+vdgNz3eDOd4KGM7ltNrvK/mwSTiAtCuIUj3uzjRcQxSqmTgd/VypvMPcozjnsf9iaWQpmR1tzHUZGpfrJ0YhjLhjr1aXSagvyVzB7r5WD3a/GNrViZJRxGQEZVwa8lD9z87z5u3bAalTIJjYsfIpqJ1fdFn+Y+ii1BwLzQgBntoBbOJJqPgW++sSvd4X5lS0HsRMhJYwKeLNcVm4OuBGJsqibPv7MAl3hZMZH+PpmFIwhR1EC4W96DicFR7BSKASF1OOIC4rnG2JrSV1uxKyN+yStbP5rWPnZ9yBebfkdG19IyjVsvFlfrYfJzBy3Va+Hq7fwuHE1YH1dqMIVuO6iYdu7JO7zvyCS8fzvdttVuHy0d3nQnVSDiwv+wZRuy+hRd8LbBnyXLfRzrsWqUBOWx9spUJfV1pXLawhrpkDkoZbhQ+wp72iOZhUDr22AhpnCESubAuG4CqkRf5vW4zoS/iGRkPJJjCzin+cOdHQ/MSNkhsmadGtLuRFp4tYyhDGwM/EO
 TphRra9w
 bHXXLHWQrUQ7R3bnF4QvbWNJyvfHQHzYUxLHm5fy6qAdLBfTBv1qvxl3Q4jCOSy7h9zo9uEX7Y5tSglq6YKvVOlwpH+futbPZqsGLTUTFBF8VyOsN2fB9y6Wh0k7U8BxB4sWzHoS5gWrhS7J6Rz5i67ZR4ovkD44KorQ1puUZVzl827CeP8kvyTK1qn92k6D46pqwJ2B3gRCHAqYJTW8843RBrT+4rB4wtfqcx57J+Ij/7eYjsW2SPRbyOLDYu+lnmMyPZTW4/6f9zw2RUQG0zZq2TcY2G7GAjsTXwi9z/3pyiYDkEY5gGVn2LrmxpWWRkKRvEloNqE8XYg00II3ibrRqk7ZJeg+mOP44R3FXyxbh6aImBAb5vSmtJRWGFb3JCONTszTvJjWVIXOOPxQDqDCgRwOZsAkgslt/IoixEtTE2zMRaJHyMtimodB+zBTyC2kDAXf2ca9nVgBI6niL+yKKMrdnU5usfGUPneHwaVZWRdNxd7nHZWNv5SmNS7c07LlyqxkAUSMVy6bbbcUQCGyLiekgAYF83j8jF9GYPORKxHZuSi7jp3mcvAC4TWQIzubuAnU9jGORnpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Mon, 30 Mar 2026 at 14:14, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Mar 30, 2026, at 14:03, Geert Uytterhoeven wrote:
> > On Fri, 27 Mar 2026 at 10:02, Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> echo 'struct { short a : 3; short b :15; short c :14; } x; int y = sizeof(x);' | m68k-linux-gcc -xc - -S -o-
> >>
> >> this produces '4' on m68k-linux-gcc, but '6' everywhere else. I originally
> >> thought this was related to this 2009 change in both compilers
> >
> > Oh, now I remember.  AFAIK (holding wood and a rabbit leg) we don't
> > have any bitfield members spanning multiple base type instances in
> > the kernel.
>
> There are certainly very few of those, but two example I found in
> UAPI are
>
> struct dvd_layer {
>         __u8 book_version       : 4;
>         __u8 book_type          : 4;
>
>         __u8 min_rate           : 4;
>         __u8 disc_size          : 4;
>
>         __u8 layer_type         : 4;
>         __u8 track_path         : 1;
>         __u8 nlayers            : 2;
>
>         __u8 track_density      : 4; // crosses u8 boundary
>         __u8 linear_density     : 4;
>         __u8 bca                : 1;
>         __u32 start_sector;
>         __u32 end_sector;
>         __u32 end_sector_l0;
> };
>
> struct usb_raw_ep_caps {
>         __u32   type_control    : 1;
>         __u32   type_iso        : 1;
>         __u32   type_bulk       : 1;
>         __u32   type_int        : 1;
>         __u32   dir_in          : 1;
>         __u32   dir_out         : 1;
>        // 2 bit padding on m68k, 26 bits elsewhere
> };

So we just need to make padding explicit? Sounds familiar ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

