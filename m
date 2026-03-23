Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB2FF4610B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DEA6B0089; Mon, 23 Mar 2026 09:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954486B008C; Mon, 23 Mar 2026 09:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A7F6B0092; Mon, 23 Mar 2026 09:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79EAA6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:14:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 121D71A0B6D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:14:26 +0000 (UTC)
X-FDA: 84577371732.09.B4FE007
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38D764000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:14:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVqSSS4i;
	spf=pass (imf17.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774271664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBYCnrWUYKFuRRnPBj94PpkY2ZwRFNgR7IvcxQJbGJ4=;
	b=2WUihjI/1yL/+iPAgXZoldp9yL4BmPLRVEN8uO6TKtGHtZjVymLA/qMRhna1gRTMN+8syz
	RVOwIpmnD08icY3WJ7+lyOXR8D+lIDZUD4OUCQLB0yGGsCAUoG79X/Beg4QjYQEtJeE6YJ
	d8DifJoyBRwRXvkAykWzT/ry3FDT0es=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVqSSS4i;
	spf=pass (imf17.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774271664; a=rsa-sha256;
	cv=pass;
	b=BGk9QaKuEGHitIbdowqx8yn4olt0u13D4+352DR5oX0Jw7oXm2SrjZcthtNX+JKpRNj+Kf
	IouLDRqrBa9d5PcxVRI0I12znJ2LLD7SnXe1pl79sK9d6w0IxuL/8G1WodCVWS6XKdLNF4
	im35tkuV2lUtF/nOMVgbsO/0xjVYRyk=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12a70b4de9bso170110c88.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:14:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774271663; cv=none;
        d=google.com; s=arc-20240605;
        b=TZsGOTDj/qaVuwESv1sdLEHMCi37g96tAoSB9dTOK3wxHWALzbqbSrsBPzFUXBKB6E
         aAB5zGgU9aMJfTrdrwRZk+g113Zs5teIBQvOVUy/peC6V0J7sw4cHE99SWWl9chiEmcf
         7OIxXRkU/4aAMXn8fAgmfCA7oo1hClU5WUMPc4+cEwD+Rm5wmFNbqJTGOOXYHURekwf8
         xIPXhOeRL6NEGT4iHkprRA14C/OZCit2WflheF69aDjF/K9SibPgkTNDIG9IaQqteVZF
         FQB1+Z+DVScGu4Mj1Vu2fpvKm2dDFeZ3NfIOHjH/th2w7Qv7/4hSv7CA+C6EaT5fIn3G
         FgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BBYCnrWUYKFuRRnPBj94PpkY2ZwRFNgR7IvcxQJbGJ4=;
        fh=UVVV7a6+sa+A2AmR1l66tfQGkvBdI02sNe6iO40xLRg=;
        b=FEKah3XW2dEqg3E2sXMuu40l1oeIZBeCv2DBiPcpDlV6cPGqfD3fAq/rDwrkY9pi9y
         sXRVXapK2gMrwFDqNbbW8ii1yiJEUJG7smUphTHP13HWqGiMaqwxWIWRQPZ9bflUVA5l
         tYrnpSVgFT9mMued4Ih5o2XeWeqg9qVUIRHCxYRhq+aAC63r5FKGU/1JVs46snYWjxgK
         XHiZ9OnQbBf+IVg3tDZJ3UAcOWoyb0Im/3qiCo6sB86mQyNU1bVCna3/xFm37ZWfhX/f
         6I2roB2xAOe2VuKJ4pLQ9MZJKF0uPhT6As65inJk4+LopgQGIsYIed2TxxztfuvhMUA+
         0xWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774271663; x=1774876463; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBYCnrWUYKFuRRnPBj94PpkY2ZwRFNgR7IvcxQJbGJ4=;
        b=PVqSSS4iBtEZx8WAitm1a+jW8Gfs6ax4T8uyqV/qCBV/DL3etPk4Fu8jZPV+jAT9b2
         R1IqKOrN6ZB0RnTyudYOdEqTRB0EmFRVoJbzYi9EKBO+Qi/GgQumCDoA1S7rTDFjVgq1
         klCuFOnLa+qjfAyXf6XGo0bC0+TEg7IMYcBGBWTalNyvaApfzhv8544Cr3ckC5dSi/fo
         MxM5CN3IYAOjcWR4rqsx7cDk3tobQJjjUPCW1/KMg9zDIwXg6T6ihVrmfp+PaVMtnvva
         739ltRVjckwJwH1t3z5ww/Wcy8lkS/JwLirCKlRJusjlAyH0w3Lc89Dip9UGFFBQG36c
         N40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774271663; x=1774876463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BBYCnrWUYKFuRRnPBj94PpkY2ZwRFNgR7IvcxQJbGJ4=;
        b=myelaosoV5px43dGGrGrree9Z3keiUFvo+uKc9DxCP9OlKgZUsRLsESy5Wd2AiiCtz
         BN2k9KINvl7s+dPpzwSwbbDwHgxr8E5oT30X1/WC1FA1T8vrVrffti52LLloC9k65GpB
         NDd59uFhXImbvl3Mo3fqR4V33fB3Wt/vGDFNurIo9yad5oJpMTrfJEZFqs9fLrsUoeGb
         1htJEsRSkZTNtRDAvQtWEf9Kda5hxGvhrMMHW4PdkfgP5sx3gcwgKbR1OMVVVTGIrHsw
         95CHURCSAx8MU7Oz5yu3CqtkKhEGalCMqJCUKjbkudAq5IqAwIyzzchH5k8bg8ZCHABn
         kosg==
X-Forwarded-Encrypted: i=1; AJvYcCVC/20/4VVB3LND5F6s+32yvNnLuXydKWA/CIjMHH4uK2k5PJif0P+5rhllkQlrkDZr5B2vqQJ00Q==@kvack.org
X-Gm-Message-State: AOJu0YwSREg0+CGByx2C4SjTDB0shCJ40iMZ0P3jqOQVSj1ZVfqnQyFm
	f3DdmcSD0CefnhRAJ5ywc9LKJtzbQmZl0bp6HgD6nYwE/FYRm31o7m7O54TNALv/i0TrFtrWGIA
	xPK1UWKQFHhKp81DUt242nLICBH2xYLw=
X-Gm-Gg: ATEYQzwNSkp48raNldRO96wywQjFwr7lfCq621ioH8Y7AbRN4QZV19Z+xdEKhjNV0en
	wj23Bbc1EfhMCCNIacouRQAz+8BZOaqHNhpIRviGv9Yg3TZRp/7iO7HA0kinhz0dOD1x1HvemJd
	a3w437cNyxiPKqEbQPWpGFOE112HQUPQyZky/dQRjgESgD+IlumqnkvKKgL8ZlFxBch/bS5Fqjs
	QQNCiV8r3Vl4r2lHoYECx5UCXGuY4UBQdf6MfbkZZoKjQkAGwqhHRaFuG0/LS1tskCcgbL2A39/
	+E9cJkDzNRayU2jHgu+0VhPAnWIjNENJDo/DZ4vz8lvCM/a+QJ8YmjtpispYIxn7PxmrrjW0eIm
	p/dHG4z5vt952HHnoiHJYjCI=
X-Received: by 2002:a05:7022:f8d:b0:11e:332:1e01 with SMTP id
 a92af1059eb24-12a726a9b6amr2560622c88.3.1774271662774; Mon, 23 Mar 2026
 06:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch> <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
 <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
In-Reply-To: <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 14:14:10 +0100
X-Gm-Features: AQROBzCU6xTHp3fepOJZJySC8VZYOKbiHafZdHuv7S9AawfpKcVFscMWOGjChLE
Message-ID: <CANiq72kbp6cDnNsKb+rPHiEJzOa-EnvR2HHthM-VtT2GMukY-A@mail.gmail.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 38D764000B
X-Rspamd-Server: rspam08
X-Stat-Signature: utjisyb5ew4tyxw5c96yxnr3p83ddga8
X-HE-Tag: 1774271664-854680
X-HE-Meta: U2FsdGVkX1+L5FasJ1ST7/uIPsmwTx55TdVsAEzZvgBhumhI1bRTlO7TvJu82UOIvGWgD58S++T2FCK4VpwQ4P92wp6zfRU79ryXhaxDsoYY6UIErLYdeKCAngUGvp0SiVsPU79+uu6jBDO95rf91N4uwDtzGtzsOkODBRhLevGz0TeP5kWI2D/LZ0Obvjkh4V8ydH4NSg8o9SDfXoxnhX+3EW2c6Draw/dFjq0am8IkdDkxWu250qHMst9ChMpIQhPetHsq2TInPFt0+evR2vAQdwU2Gk18OexhdnMxia0jikqaBjxYQusCZADT8HASsEnd8WDJSnNbQDNj5o5kVROE7uj4YPbia8zr+qr5M9LDBoz6TSn8bqJTyyLAueFg52Mj9/C0pSIGk2r9UPc3jPn3vfKVcg6i+KzjmiXh+WbHFExprlY3V1Z66EfO8IF99BqhfBk+BAadQGWIQHuRLTNaUiVV+zuhXZ9vzG2GDHuuKrxK5RJDR5STKeJOXZv/ubdwWXw4Erd0QZG++AiEBfm0z3cVIcCQkxHfqS/LGpt6Y3jpXFdOHaafhZNPmJaJL4W+Nz15n6+N/gqqL7iLe6KwbYe/Ck3QZKMgTnmtovBoJQ1uEXoFBSBr9Pc5YwPwOXRny8Gpk1HxdHY3jgZSrw7VzVpPh/X3eKL6RsFLH2a7c7hI101+2fldhpFmoU54ZthloTHFBL+p/V2chtaAgj51saRdRflJUDBfzIMacXsNyRVaxA7YpTYqKmRHvqA3LyY+6NYJFlFuVpzC3TraA0lFVl/JkY+PnB6h+Vj3y1xnAy6qlUzeNOvgTObUWOjtr1afJ3u29oqPtGcZH5yfnwqxLErxjxdSWsxjxjuOIFvaisTEjN96dW1LCKHmeUCjchtxzsjPFo8lsQ2oPdHvRDiyAwsXNVe0yBFAF4W4GmwqlLGCFw1JjAM33eiiwpnJoux09HI6KZEaGy+vJP3
 9fXHt4Sv
 EyPsq4eke5WE4ofrTST1nH16b6jr0YB9gmbY1wRAdM05mrp49Vw3sXthCdNB7+m4PAl5yqW6HLEdf4F4VxoA5miur8tjroh8DXVEu/9DEsfo5cH06m7eXmsTQGf5Hya8v9cHmhNFr5yaKXRZ4JrV1cgeQ446TM0c1qCXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 1:55=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> The current proposed code for netlink needs this feature, because it
> needs access to inline C functions. Is the implication, following a
> chain of dependencies, that netlink would only build on x86_64 and
> arm64?
>
> If you want netlink on um, arm32, riscv, loongarch you would need a
> different implementation of the binding?

I still don't follow -- this new mode is opt-in, and only a couple
architectures (or whoever decides to support it) would be able to
opt-in. Nothing else changes.

> And a completely different question. Are there other work in progress
> solutions to allow the use of inline C functions? For networking, in
> particularly MAC and protocol code, anything which needs to access a
> struct sk_buf, a solution to this problem will be required. Do you see
> this "fairly exotic approach" as just a sort term bridge until some
> other "boring approach" is ready?

This series is really just a way to increase performance, i.e. it
doesn't really change what we can do.

Cheers,
Miguel

