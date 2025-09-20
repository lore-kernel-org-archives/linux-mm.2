Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B5ACAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 10:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0068E0005; Sat, 20 Sep 2025 06:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5877D8E0001; Sat, 20 Sep 2025 06:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C53F8E0005; Sat, 20 Sep 2025 06:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 393C48E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:54:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DA7A11B133
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:54:18 +0000 (UTC)
X-FDA: 83909319396.11.A1902A5
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id BB5AA40006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:54:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWbtf1L1;
	spf=pass (imf04.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758365656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHE/5/T0iACb/l6eEELV1mJgr9I92jnyUNEPbB0q1ns=;
	b=A5qE+y+unoS3UKiXHlVOhM68f/nahF0UQFl/9OhQ6vpUJA1tW3vfnIB5fU2kKGO8el/4BW
	eymp4+/vFvDKadJlrNSh92fuJHB6MINAaOYOnB4seHGTvaOF2Hlo5Ll2OMcvVyDfkhtW7h
	jBEkPisgLeQJRvDPpiFaqnK3+8hYDCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758365656; a=rsa-sha256;
	cv=none;
	b=A/d2xyj+rHLpvjPOVNCLWtwzqDJ5+BOFxIeYZVggTIiItHCh+h6LX1lvoMkjFxxlEsmEGS
	uznsfp3k1w6ken2Mvl8beR/sCGQsRdSHhYOBt3TWeUlFrXsj7gGVUljyY+gFy7AZ8iGZMM
	WpW0g6NtyAZusbrTrBnrQI77k51z74s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWbtf1L1;
	spf=pass (imf04.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62f0702ef0dso7506740a12.1
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758365655; x=1758970455; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHE/5/T0iACb/l6eEELV1mJgr9I92jnyUNEPbB0q1ns=;
        b=cWbtf1L1as06XQgm8OlX0aVnQ/PBlIHGV8Y6PORv9Ka/m1h/0v8OPxcLET5dkiaphK
         LSjz+G/clurGz4WJa+et9V/9nDXrTTw4WjSM8NXVxt9eYOBL6DiIuT+VVKkXozyO2bUz
         xJWIfQb7O/opzzCtRK1CeTQ4OgeaooaF2wii3dS/Ur6s2YE/KmCQwxQWM+/uSpmsh30r
         iZtT1DOHq5XYWzQ40qWwI4SePAuHV9D7eyRNh71YceAJbfYaqWnKKec/uOmB+b7lPgZM
         P7xiLSh9z4g7jGwXw8x2H1y3RE/PcUQm1W28ljyqksx/jj8xJuDaqvqQ1Jcg6ZJSXZ5M
         Iwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758365655; x=1758970455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHE/5/T0iACb/l6eEELV1mJgr9I92jnyUNEPbB0q1ns=;
        b=bMftsXmzcv4+UXAfeuoj/UN5S9QZ7kVtebqYCIqSQdHVTnyceUmhF2cnG5b2SIYVIj
         8Pi+BIePJ8qU+URDOyfWb5KbZ4nrTxdQkGXaacDiK0Neo4t5fxzzkBdkLp6dvM/Nsb8K
         1ITq70qCuRlqSsbyB4eobz+TE3C6+YWflM3EPyFR57i7OSuVkVqAjljWqVPjTnYEy9Gs
         2TWeY25NEk8Soh24/yWpqJh14BkVo2oYfNnYTvnR1pFe03V4ixbtWFBssfrATCWL0iKF
         cOk6w+0eGbpgAJBXtQW+ORW89mLnpXsujZ7vrEnTeopmVsd6ARZdPF19xtcDu7K47m60
         9dRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsfeOQFqiiFZddp/b6nBHZgHLWBqzzf8uJ7X5jxNEHzQPN1XZzSR3ojG32FMy1bUi6i7N+QroMGw==@kvack.org
X-Gm-Message-State: AOJu0YwDHIfYo5CkNgoNfIdgQ0quTwn4PuOF5RQtAyX2umajFLbEHCDK
	vlQPWcaaQ/ScWIF5yi1KUmi17kJllN2abgSyIDEjS4VjQ52aW12XDZTtDy9eDR3fjJZXaOdFu1N
	xhUFim6LZgfjsywseNTJ5BAKO0Bm2sf8=
X-Gm-Gg: ASbGnctBKp19KkVidlP+mI6T/G2NOZ3b4lYXMYb3GwjYA1LYyKopRNc/oKiLtam2hTj
	QiSSskhn5zh5604xOyH69nzJP4wMRCCXDKUVoJCh0GuPgAZEYsVmRPc5hKC0BUwPupgm0FfnntP
	um0xaFj31gf8km+HPfUm8UUHdSAGmbHMZfXEeUIILPPNe7QE7px59XLDAQIyCFHG4JTItiPDDoT
	ijBMgU=
X-Google-Smtp-Source: AGHT+IGfr30EQw906zNu1yy6601ap33zZGnK5nPnqrLlo4963KREDwt7ZGpP76S+LfDfmQjk0YyGSf5iFcJLL0/Cwgg=
X-Received: by 2002:a17:906:fe49:b0:b04:5888:7a7d with SMTP id
 a640c23a62f3a-b1fac7bfd56mr1024511066b.22.1758365654928; Sat, 20 Sep 2025
 03:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 20 Sep 2025 13:53:38 +0300
X-Gm-Features: AS18NWDpSLAbdVwTREnAeu_jIcCkH8hhst__Nu2pxxOR47JsAXWXDyIhGWC1eV8
Message-ID: <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wf5qygyo9zjd6uhs5koeagwbpgtmbmmg
X-Rspamd-Queue-Id: BB5AA40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758365656-274902
X-HE-Meta: U2FsdGVkX1/SGzGGIV5QI/7ugG5pBk3K/L24Fq5pOzHaIZ2ekxi87lQQooRNPBeMcD9oPFxfkVJ58K/t1su3LPR/rqd6nDISlyDirXLvb/UGZR7Sr3R7NUaCvmDjJ6WXeNpRtMCMhRguzDRNv3VLCpiqEJKakp1g0Zgbiaj8KN8XbEsXzP7GGnaKI3HGBc2kKl9DC2iRLVy4yE7FUthYlAI22f9xm4w7cCVA9OO3ubaZl2jqaxZbQx7KQR+rlJh8j0HYnvmgsiyJyJ5mPHoB3/lmC7LjwuahSWAtOnK54enVFxACR8CPTVoH2kQsVoGCnR+uNo7eGHnXQ5kCgwM20cn211TQ+VHjaJshH9tR032DvlFeQldgwg/PEB90GS1PO7nG+Tb1mZ09feTU/RHt/8hJYWQu0J4qFsrcPl5s5DJHJ+uxC52VrS9/1KXZn27shp1Ypu1hV0xRzx6xN+bUHXF1qdUPmOAMj6uSBBexfrDIiz6Oe1IHWwzmS86AkUmNnz/4ESYTTFtUc/REsFVtIf4CaMEW/0K77mTMMzWa6HrHH9BcnYFsGeVzzj3rmq78HpcY/x2615YLrFa8aIPxGyi+wUfmZfNcWMrYasFyH2JYu2Ej5/AvK9gRt1ELu9XwoBi7p8WPK5HFvH+lYwG9X52jPvN6+bK48jbt5bBDGkjql6ccclusOeIiuYhuo2sfns4p/Cr1z1Lixjfp5jOTcDrqm6KI2Pbn+A1B2S5ovhlpTPO1Pt6vqMsZ7LW91sPAkoVs2+6I21ily2WmR9PdH+MBnHLrsZwsfsxltVshSVQQgVSSNumVhYKlV/eOQQXw8omXkwvkWokkw2HpM7uf81SDod5SR3k5uPJCdi40HQwQ9YsNfhr5SV9Bqs8BKxvF2vP2ChlvTEuehgtWxcRYdRBFovXLjhOo4QPP2B30OGxsfAd7+QzlYoiAZrziMAYuDrE3syRQjMkjutJtxus
 BZpIFZeq
 4hkfXM86f7iiDtSvZuzRpWoAIxLzh0tn7S8AIoe0royzsfmLKhhpzuadrEJtYXdE429EyXGYJpHaN4aDGEoK/L6t00XKDIC0htNUgaFhWcSz5ffMwKtADXBdr9fACPNyqFNE8IDI5toaiFCm0QB/H8a72+FkCAp+kcbKIPmAj1+yrxWTRo0arnVwhW2Y+kAFP6PFU1zzdls7x2PBN8RjJ0myrNKFqyZ3sQsxffDoIu3djDyfUGwUhboyWiNvkM3qaloG6/O2/Ek7lvNkEizXYifNMi1RLseeo9c/cfsJaIrzRv8PL5J00fQV+5pu/nnxRWYF+S8wq6vBzyD2s5zuYN9oJ+6BE/MgcEhSf8mimnN+QIF5WaOVcvcilOUMBADfxQ2Zzk2E5rviqfrc8FENrlFzK/kb7NaeWIOBLlxNKxEoMAvAliiWd5252qvfvVoTTvhSV+0ch96Fzqn7tJrGRD6UiKiZq65wf+ZXbil/QvTD+IJOXCViyNDf9kmwuhpZBrcqzTRUqVRo5U3EptadpCTbOCADZh5+fLcXGMPt17xO+2Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 5:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.
>
> To validate the correctness and effectiveness of this KFuzzTest target,
> a bug was injected into parse_xy() like so:
>
> drivers/auxdisplay/charlcd.c:179
> - s =3D p;
> + s =3D p + 1;
>
> Although a simple off-by-one bug, it requires a specific input sequence
> in order to trigger it, thus demonstrating the power of pairing
> KFuzzTest with a coverage-guided fuzzer like syzkaller.

...

> --- a/drivers/auxdisplay/charlcd.c
> +++ b/drivers/auxdisplay/charlcd.c
> @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
>
>  MODULE_DESCRIPTION("Character LCD core support");
>  MODULE_LICENSE("GPL");
> +
> +/*
> + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to en=
sure
> + * that KFuzzTest targets are built.
> + */
> +#ifdef CONFIG_KFUZZTEST
> +#include "tests/charlcd_kfuzz.c"
> +#endif /* CONFIG_KFUZZTEST */

No, NAK. We don't want to see these in each and every module. Please,
make sure that nothing, except maybe Kconfig, is modified in this
folder (yet, you may add a _separate_ test module, as you already have
done in this patch).

--=20
With Best Regards,
Andy Shevchenko

