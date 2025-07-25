Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1793C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1646B0095; Fri, 25 Jul 2025 12:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499086B0096; Fri, 25 Jul 2025 12:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5A56B0098; Fri, 25 Jul 2025 12:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3506B0095
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:21:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DDEB80818
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:21:30 +0000 (UTC)
X-FDA: 83703302340.02.E70F607
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8B051C000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:21:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k+zHubRF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVzrieIwdnPi6sN8Ubq0Mmy1cHqqcphNnLkLj3BPLVU=;
	b=xcIj23kd2DnBCAx29vQSxtn/5sYDRH3NDffjuqZD7pDFmyblsxtk+/BOFh5k833LutwImY
	/KuU1QF89KI7Pu760+5nQzKU2300bC0l7GZhaP79c6Vpxe6/RInrJXbzljFmF3a9jyae6f
	f1Qp2V18arS1NMPqAWbu66LBoYpJgBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460488; a=rsa-sha256;
	cv=none;
	b=tCBTV2rAHrq6SOPJHIiiow7dcPqeXuET/BiFpyiPhdbWlSKw0PXYy6vqs80oyqJd+FmpZ0
	jYpwhVPUiSd8/OhpAUlV3XkN9sDeLZzp7yTc/JydttLTuuMH7zqevo6zj+NnQo5YROtYbE
	Px+6jkV/YgnGfAm9JS/t9FG/FEpFeP4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k+zHubRF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2cc9045bae9so193278fac.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753460487; x=1754065287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVzrieIwdnPi6sN8Ubq0Mmy1cHqqcphNnLkLj3BPLVU=;
        b=k+zHubRF3S/1zfcMGa7onSKJrHbTolN8yQC1/gFIr7CFW0BTf6ANIC1CeXu3ojPcD9
         /sdtwvFewjTd1Yw08XEE94iV3IcOvLeBGUp1CAI6IsnHXirgZn5H86EvNbPagPmaj9Xe
         bFItlwgzfmn5OgTOF32YHFsr6174mC2yOXLYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460487; x=1754065287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVzrieIwdnPi6sN8Ubq0Mmy1cHqqcphNnLkLj3BPLVU=;
        b=ZI/AJz+RMTp+hPipjJY175Ee53FqG5hBlJMfX6YPt5sx/XPYQxY6CEOaAt8CmtewI2
         h8Gunsv5/9KZZtpmPsJVEqaKI7aE/2fe1Hfo7qV9w9aP7OdghN9BBo80Qdd5FVccQcpQ
         3pRG6NPoxmd0bZcZqIY5VIWttMBomI0NATi/v1xGs3UJhw9ObIYyiwcfOu3Ttwya3t7G
         2wn9kKnridKoRNxpMZRlhLs6N2rSbwfRI/crU0DZERAHufhCtMublr2/z+LIFvaez3ZP
         Kxm2X6zl/e4L3SXwIx+nbed0ta6Wl72/vyq+s8Wc47eb6fGZWITzBqhtTwLYA3NMgrZP
         d52w==
X-Forwarded-Encrypted: i=1; AJvYcCV9N9rtqHmgG3hki70ZdPYofSjr5y3fE1Vz3kHeR0k31WAxKMRPlGsrXh+nCyR7Ghou0ugPcjZ3lA==@kvack.org
X-Gm-Message-State: AOJu0YyS7/Q12jK68lU4DkQK7z2orSyYMHjgeOmd1qxfCsGSGX04pcL9
	M0M6eqAhDJa78X2M3vypihGZPGN0bcROqcE7dEykvdnkcymMWTk4K+DO6TR3QRAU4B9Zb6h8o/d
	6G5t4efYRyB3HrGEYy0YUHevNEEeWlEKlgvMbbLT1
X-Gm-Gg: ASbGncs7GstSL04YjiJ5yjnhyUMOdxz98OPGp4RJLq4ODruGvCduTpMo9/PNvuRkw6W
	sPNlWzcC6xSzG+QDFHUNI7qUDkvmiX5QXeT8a1gEGWY9KH1XXazNNG7efdMbh1Ohwwnw3smtLc9
	P3Sdfk+jsqwS9L7mo2MQNGSUOA6PhwSiyEZgeiHH0db3qIOLI5mcOinookUXf7ms5dS404rKXTs
	ugk5csZ9lsThKl3Ah1TyIWD/ZrfKI05FIO2LQ==
X-Google-Smtp-Source: AGHT+IEPyhNtBJv6l3iiA2DfeR4DXSweFw1h+Ay3otH4M/e2Ztm3RdN6/cXav9yGbayFwPQTfZ8UNLVyy46HelNqwHc=
X-Received: by 2002:a05:6870:a103:b0:2cf:c478:190d with SMTP id
 586e51a60fabf-30701d36839mr516981fac.9.1753460487544; Fri, 25 Jul 2025
 09:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
In-Reply-To: <202507241352.22634450C9@keescook>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 09:21:15 -0700
X-Gm-Features: Ac12FXws9vKUmPauXE3BL2RflRgVyk9FnCEdjyJy-p3LV82aBv-BEdrFMBvPZNE
Message-ID: <CABi2SkVV-V1jk+nB8_+6roG1-giM1DzhFP+V0RnT0UMF9qjuJg@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B8B051C000F
X-Stat-Signature: xt4ke6jksqzyyf83bifn3atyzmzuhtog
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753460488-707436
X-HE-Meta: U2FsdGVkX19HEzGVdatV/gOgyYqBvjBtloiCkl5SioxA67Zgx+X/mDdYfOyGkfBcbPR+ekFvFTpveiYmhv2SWsX2My4+rxiYjNebCb0b+ejyX3rqhbSf3FlqfaOLeoLEVc0Vk8O7Dl8TdSysahJV6mSpsUYoQU26eUaBlyeh2NbU4ZwLPQfazg7MmkHpq+vHAkbs1GjrZ8aXOnGY15DjEgNmMVxLKJQH+HNwJ/AT056E5STyEI2q3VKH839qtnrL17wTzfksi9vqtHTkiN5L3rdmoI/c9EH0Yrc9ehT9F4sPw3e/6HcUIIKtBGEfwQVLxFTD18L4WT3FpNETbN16lsJtR5+tXIt7ZZMkn9sTwWCn4IrDnxhWK2VOBnjh2gCke97lfbQHy/kRdZriGRDyIoOUtpb8a/KbuGbT9J3wg+6PAjHtYxCksy+PaTd0vdR5QuB9HPd3keHs499xyPLNAk8Fvot56JnOAmJFVT/FGC4DuJL3EwJkqXQj7YVim1qrVyyeqtNSn8mJlNjoyoCl/IOo3PffT9DGCxhFoP0MiQbDY8Ere9CqfRm+i+f/k+Gy/aLklt9X4k9s3ghJZiqQ9WZOArEOGMTQKwgEmyaPkiA3R1Sjhft9V49Z+hlldVNP4Mw2ll7klE1LiOUYyNgv4OQ1p3W7RKj9GaoJbAlxrxGe0XPChiH7jfBUCnIUEXJVxjds+UdxvbDZEr11ZAjRnhWZBJkoFfol3YoqsPI1hZhgpMznlU+MwBFEabJW44t4ntyeZjdeDuMGTFTVjxCSJ1Uxl6/8IcrqaqSWGQmbyxB1Gaq2aq2WsKgbFFgtby+Ho/f9pBnT54PLnmAeEHJJHmbBgdFbi8Y+oe8tXjxlUT2knKvT7P+3gOl3clh73uxjCMtN4ta3R/2B+5/z3AC2xfubU67RvCwU7Iri/FoaYWOXQG9r3bvihdCgae3ZKbNp0ss7jGP+fxFpe4jlPvE
 Wxgf/crz
 dyYBnFKhjqHB0H9TW09X+dKqHbtV1ScgiaSA7giqnQsOwGnYA1GUBqwow6AFolZ0b7uwg3ta1ZKCgaM1snnsQOaI5/EjOiE8hUbMYHrPkrYOQxKxWVxo+CwMYh6pl4NkKoRznkIhnWXZvbZAXp9uF6Aw2g5IDciFHLaRLabmNSuCSb5P8fpLSi8frqvIi3sn3/+olXwq58PQfa0L54zuAIlmXKqh5k+10w5Vt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 2:15=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> On Wed, Jul 16, 2025 at 06:38:03PM +0100, Lorenzo Stoakes wrote:
> > We make a change to the logic here to correct a mistake - we must disal=
low
> > discard of read-only MAP_PRIVATE file-backed mappings, which previously=
 we
> > were not.
> > The justification for this change is to account for the case where:
> >
> > 1. A MAP_PRIVATE R/W file-backed mapping is established.
> > 2. The mapping is written to, which backs it with anonymous memory.
> > 3. The mapping is mprotect()'d read-only.
> > 4. The mapping is mseal()'d.
> >
> > If we were to now allow discard of this data, it would mean mseal() wou=
ld
> > not prevent the unrecoverable discarding of data and it was thus violat=
e
> > the semantics of sealed VMAs.
>
> I want to make sure I'm understanding this right:
>
> Was the old behavior to allow discard? (If so, that seems like it wasn't
> doing what Linus asked for[1], but it's not clear to me if that was
> the behavior Chrome wanted.)
Chrome V8 JIT engine only cares about  anonymous mapping, not file backed.
I'm not sure about all of Chrome though.

> The test doesn't appear to validate which
> contents end up being visible after the discard, only whether or not
> madvise() succeeds.
>
Agree the test can be improved to validate the read-back after discard.

