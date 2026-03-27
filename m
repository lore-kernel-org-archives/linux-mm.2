Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6187E10BA437
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E5F6B00B4; Fri, 27 Mar 2026 04:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F8A6B00B5; Fri, 27 Mar 2026 04:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35146B00BA; Fri, 27 Mar 2026 04:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A26E76B00B4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:04:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D99FBD691
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:04:03 +0000 (UTC)
X-FDA: 84591104766.18.EF6AD5D
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31F4814000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:04:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774598641; a=rsa-sha256;
	cv=none;
	b=P5dCwK2ElXfOsWrWPEc2/AKbWL/PN9os3N8t27w0qCwsFb12wv5YjkFIWXCFdSWNP0QSQ/
	/c1YQVwAPxpjr/Jx+cpC7IMeddZudbuEqhgy7PzUu+nWRdCBkRk5OdH1uBBxHt8sPLevox
	bupB/3StcClDjLQAEUgxHrK7Ixh9yTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJSO1Jy8gXJ3q0SyUcqZkfXUbxuRHoGqVtwy0Y1kZfY=;
	b=7icGAj+WYMYTDbeZNp4w2M2UJ5gwa+/j3Gpsh2LWzO2nIdSe6PFjUbyiX1waTnKh4ae3S/
	0NOv6iHGSKktSEHrm6zTEtKIrtcMYtz9icE9pmbToKiT19X4iBXvwo2K+ZZiZfa0Vj5TBA
	kaYK9esVzvSnCEkILmlKy9zWywVI+VU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4c383f2fcso1712889a34.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774598640; x=1775203440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qJSO1Jy8gXJ3q0SyUcqZkfXUbxuRHoGqVtwy0Y1kZfY=;
        b=NM8kN1uAVgSamJYGy9VzhIvGPbZ6HrdFPxcofaB6MXcoG/9ey4qgx//NSlGIF76fyd
         asFQLsXcrKaoKpZDQCr9ZRQPJIw2j0egM0bVllEEksKi6DZ4IPr5N2lqNCw1rpT+euph
         4elw/d6WoSPAhyHNl3/K1Nq6SWLhUIBiQPETpE1rlrgvVDAccZOws6fKbpASv0VBx5aO
         jsmTq6ugjAfxTT4CSaGiHK8BtsQeOUq3iWCYGrWkPUJ6X4ryAyV1N6N2wOvHVV0rEv9X
         eGWQD9bPkFGX6SwKfsEITsGbDtqHIugVOT7c1yDUXq6IuirbFkb31sH2XiEJnqox8YFt
         xQKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1AWNT+ik3R1ngWSCz8fgobgivu68obrZDa483Xa6S61mXVMJN4y3tWg0VlfVZY1xpqi7WZ2nlqQ==@kvack.org
X-Gm-Message-State: AOJu0Yzvsvms6d6HgRwvZ7tiTxcOVkBn+SkGfvdddigXgf+Y5ldzMaMI
	wDXGX45JTW/2cO6lDwjjzdH1RKgHdqRG24qwWLmBnj1ou9pPHGlNG3PQaNqHpE8Vwr0=
X-Gm-Gg: ATEYQzycKlLzWKFSuS3DMPTw1S8yKSd699r/QQvJJKelhYfR7iM3o+qLbXfy2922zr4
	PtMwYxqcrXkkgo7thZW92EjBYcCIJiOzzktA5r9QglEGyeGgQ/GOfpmHZctyhaIVjwMgm6JYNSg
	KNbPR9us+2wVgFrrb6CUfIlQJPMZVbQr55CpQe7Y/+g+R3H40e/uJmd2z/VebFZ+XOCjjOzL3RW
	xSmbgy71uM/Oq49jQKglMjd3sYopwV9njlg1HAoavb7B/Hd7Z2ZBOffR7FTUkbKL4sijAAxS9Gl
	fdcEJhohiUtC04DIvf30YeM4YttG/7bc1PrufX+LajYq9fIayroijF3Bhr15tvrrdIXi2fvUEiw
	MQZJSNoRzBtfUz926IZWmdZwxrA4VHOvDQ4e44jo/Xs1eFCS5k6Fjl8w12n05OnXhGMBKUwfzwO
	IKGVSYjR0mlH7+pQBf4GBuwCVByZ7UmhJu/sE959mr6pvLjomqbIZ3dKhSUV+xTMXV
X-Received: by 2002:a05:6830:6a12:b0:7d7:e565:a4f7 with SMTP id 46e09a7af769-7d9faee6b6bmr747944a34.18.1774598640026;
        Fri, 27 Mar 2026 01:04:00 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d9e6fddb47sm4138020a34.8.2026.03.27.01.03.59
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 01:03:59 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-467d9ca391cso775211b6e.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:03:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHcQOB17NLJR0/hZLG0w4y2zu0QAi5ex/uL757B6PpqEjk5o8Y7jPmkHgdxbDkZi97HVJnhQy/xA==@kvack.org
X-Received: by 2002:a05:6123:132:b0:56b:5e7e:d3fb with SMTP id
 71dfb90a1353d-56d4a619a98mr460290e0c.12.1774598183104; Fri, 27 Mar 2026
 00:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com> <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
In-Reply-To: <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 27 Mar 2026 08:56:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
X-Gm-Features: AQROBzCIA8XVkhuOJBqaPSt4vzM_veS-eZVPLLLcWDFZykO6P_Bu4uSiQhzQA0w
Message-ID: <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31F4814000F
X-Stat-Signature: qeyneuhz851mn1d3hw456y9pmr4ui4d4
X-HE-Tag: 1774598641-856432
X-HE-Meta: U2FsdGVkX1+7v5A6IL+VJdy7qtKmCJPjse6QkjeyBsQL4DDAYNS4Kb9iaXqXHQ5Ys71wZImSswzOniziSSmzun6Ee2gQ/tp996JsIhTnceVhNnasUgppmBuzqE0kfaDn0gKnBstxCwrAIRvrKMAIMRyoJ2RPmzUYxeF+pYE7KIcCTbaciZ4oLNgrN00mPbBHrO5l+hURbOGXuyO8lCLmdEUgQdYRAsyHzWTv3m+3TY9oGf9voORbb68bKt9UOTe7YPIfZh2sw+RLGJQ0ztXXIQCBL5VV5Fo9AEBHLUY5b63+JXQ8DsvWRL5+DSIJ8lZVD0sxg9sZbEGQ/AnmlEr+A7/FNlSL6c2KEdZE757wD6zROTI6UfZHr9prgoPze9NK4nDNY2u50RExmlQmaWwhatgHLaoe7xdFiS0dbS3P36Dk8AuueCIn9JjnB8PIfBrukgOkCNdJsuCOxDD90desJ1RwQt+9ld5aUdKhx89XFR5DVfV1+r0ZZxwib7ujonobol9bdFg73XmsOPH8Uqcph0rMHExYT2aLjM9NdT71G2QZHtMc9eOKlsXbzfoIFoHvKTpAe8QRrFS5GEMW74jLvMpNbiWPhcWvnrOenAZEJ7L8HRS4vCcesnLenvE2lV+hoLaJ99zN2v34dOelBOInUDBTBd5EnKWB8AW7mgGEWdWBpImu2DHNEXkbTsIUgYYJpsMQFw+ICMWO8naATydMt/Hd2be96xPWI0C7NZwBJsg+zkBBAGmMyV833xEZTaUD+GjU+6DxXufhyzEDlhmmI5vbltXp3OZ5oA225VKfWpjG60OtNF5ejc1Dfo+gyJR78jY/ezcBFCLd6KPgXqHYGKOSdbDr5/yQzuGgHoDsGPycMa5jD/FaV+7QPA2KPL8kJvdaujFyOoXAeCViVZ7RwscaRAQ10YisDLNll9dB87UNYUeboaHJHgb5TRY72LYkTePkEg4FPP/fzW1iFgi
 gu+hvQmT
 31+Nnsh7rLR2H79AYSIktEthq3pKEj0DGUyIVAWCAN4gZzIjyXfFCkykwc1CAOgj/Bj3FGPkQcqfojYTD5rvDFko+Xpf2csoZxlYHwczmRIGm8XbXF8eNF/hpo+BAFX7+tRhaQjDHUzH6Y4q3l0OuQvu1LrKt300YA9cj8CswYrWfLOIoYlczDZa1e+sQf5CirEVXLP8x+j8ZvB61MkpPFaAIwrkvv1Gx5BDzoeeFO/PTKorSPcKVaFfg3yLW9jH2Vu1RnDWqdFwLdVVhI1Z9rYr6BXbfQzNvgfxCyFhPzSNg+ktaUZiA/4XaFB+l21QQXIgk47I2iDtyRdUIq82WN7pEo2EZ1P5dxViTuPvgZpClNlDcZvqKMCZ9LRoFSjh6930tpso/pfVTBqCdkN0qP2HmlFE5LU0aby+kjllB0B0A4m6Yd9omWSxpIAJJ6sPP5tKE16f+WvcvgBUeI4IWgYwh36WSDX3TguVzpVR6vX2IG0OFmHlPUgSSCGr5BPXV0jBe87WxupH42fCjdRRV031yHeL+3EZWr3jHC7SuHcSmwauW8rQAsumYxnQICnT+aked16t56wTysLVUm1bnwJ/p+WLm8xD7bMik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Thu, 26 Mar 2026 at 22:34, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Mar 26, 2026, at 16:18, Russell King (Oracle) wrote:
> > On Thu, Mar 26, 2026 at 03:31:26PM +0100, Christian Schrefl wrote:
> >> On 3/26/26 2:47 PM, Miguel Ojeda wrote:
> >> > On Thu, Mar 26, 2026 at 11:10=E2=80=AFAM Alice Ryhl <aliceryhl@googl=
e.com> wrote:
> >
> > I'm not sure if this is still true, but I believe it used to be the cas=
e
> > that the -linux-gnueabi target has one behaviour for enums (fixed size)
> > whereas -none-eabi, the size of the type depends on the range of values
> > included in the enum.
>
> I checked Debian's arm-none-eabi-gcc, which indeed still has this behavio=
r:
>
> $ echo 'enum { A, B } x =3D sizeof(x);' | arm-none-eabi-gcc -xc - -O2 -o-=
 -S | grep -A1 x:
> x:
>         .byte   1
>
> and I see the same thing for the hexagon target in clang, but none
> of the other targets that Linux runs on. In particular, clang always
> behaves like linux-gnueabi even when targeting plain eabi.
>
> $ echo 'enum { A, B } x =3D sizeof(x);' | clang --target=3Darm-none-eabi =
-xc - -O2 -o- -S | grep -A1 x:
> x:
>         .long   4
>
> I noticed a similar issue with m68k-linux, which has a bitfield
> alignment different from anything else on gcc, but uses the normal
> behavior on clang.

Ugh, I wasn't aware of that. Adrian, did you know?

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

