Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8395D1CDAB
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 00:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78E86B0012; Wed,  3 Dec 2025 19:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50E46B0023; Wed,  3 Dec 2025 19:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DC36B0024; Wed,  3 Dec 2025 19:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7B86B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:43:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 692571A0893
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:43:51 +0000 (UTC)
X-FDA: 84179941062.25.006F26F
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8668E14000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:43:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H1oPJ7QP;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764809029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSZR0s81uMpFgx5g0GkJVL+/X7Q/NOvMK5/MCFI0OA8=;
	b=Qn8b9EMJUQH5IvN1y9gLFFWTlp2VPjZsXGjUMWKBKKN0nLWiScXh6vbI9zszE+DspEKzwg
	o2G7k3VlZWH2sY8+cmiYzY5npros/okersYz0zT/x0WtKpgunoSaGgoqUq9eQyGvPa4kLt
	za6HsQnN+8k5Jw2fi2kgu81rGvpEcwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764809029; a=rsa-sha256;
	cv=none;
	b=gq5lsID+oAtgjWSCaK2wIidXI78iO9nq0Hw4eVlW8zHqog4eepOMt5VpL2VSGNizsvd75q
	mAscp/RwlNX98rZBe3yOAYAElJok5QxD+Hb1g+uj4EF1B6sTHCMAvLeApZ77jtds8PxuTE
	6wKb2U0PcpUcHaiTsYpSV7uP0BsGOgc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H1oPJ7QP;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso2546645e9.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 16:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764809028; x=1765413828; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSZR0s81uMpFgx5g0GkJVL+/X7Q/NOvMK5/MCFI0OA8=;
        b=H1oPJ7QPAimOD+qTeshlpbKhlwFLdu/pgsriky1vZbyL/OMBpPbp/Ii/oKnCqGlIWh
         /1XQXdJBfAu4QH1JV7WTGWZ+6OsUzHToap2S9ApHzYkiZ4mNXA9jXBM7kUKAB5sSv4Ue
         Emxg0f26owSZnYM8CbRQ+bDrMJyzmK4VjNFLiTOL6ZpBKaRjdLRvw2L9FefjktV8GRB2
         GwOEnbJIiOJ3BdNoJakTm/KmoSKuMxbh4l8O0hofblkBjPD9QQkJN9mQR6PLmRw7O4bh
         KOE5oucu6WE2TcjlyfJZFtkMSGwx/gO0dYO5dqgRWOOJ+IY0c7NFFyeft+usR2rrFbji
         zZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764809028; x=1765413828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fSZR0s81uMpFgx5g0GkJVL+/X7Q/NOvMK5/MCFI0OA8=;
        b=VdfSuKtQLrTa9ugJ0iBXtLR67NelcqnJDj1xOk2ID37iaIi7Vkq0nlK+z60I79uFHr
         Z1hQMMj2ic6FA48nUXuFWnm2Vmy+rQ6DxxMghRZ9ss2TEFH4CpE1z+PLQtmGfp3Tzs2d
         iViK5y1jm5WOLYod5Sbkt4S92EGBG66lOiyP5NJ+GB9kcTnPwV+qEXWnq61p8R5XMCbh
         rQpGILy8OKjCmT95v9gDYCxTdtL5I9Y8WGK4LWUPdqodjaB1wkNwZrTnwquLa2lK1jpv
         NBfbFy5ubXeIEYhJCuGQpoGf0uvtDZxUOBjK2j/09T+exulc9zJPzl+nYAJXodYoYDmH
         5/6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVWWHwNyBikPD8El5r0j5bXSvLf53zauOTTWR4wnMDLHj43ni/AWsXrVFwrSI+GmMkLq8XhLBHcVw==@kvack.org
X-Gm-Message-State: AOJu0YxhsKpfmW/PoALyGjlYt63ob9S4TjGge39BPDWwBYjfqcYNmyN9
	nbvqaQejO/yw2d4j8NZlLge9Vb0JE/l8EpPqFNRzxtuLrKvhZXgbU34tQ3GDg6JXsbLZ8hntO2E
	Ufp77P0OPBfJyBl4vwWfXvJ08LT/t4yM=
X-Gm-Gg: ASbGncv6iheEcaA/bgYvehtXIEXcJd80J7y0k67Zn03LgvIWGk7qOykOXDWFmKioqck
	REx/3BgX5AqWNLXTioGh2/2ZZi0ru6WJMvl+nLOn2P4Y4AK9U1qU3BUkv6JH4zcw3Pnvxok30eZ
	lmZ3UT0xMDzbfKKeNzMeX+6v5tSV7n85io6nfbDgjiLU8F95D32o446IOkZZntz4JLJIvLNVJB2
	FOdr9m2vZKb00xHF6mCmnTsXvZfskBAaKoY25Ga/m/p8/xQmbSlhJGI6oEQ8Vpm2DGXayv1mZuP
	NpwSUHRcrTPyBHoPy1nDGrXkpEw1RPcKnmlLUG/PwJYN
X-Google-Smtp-Source: AGHT+IEsyIO5w16AGkEcxeFY0A0Rl0517V7+ZhktBGwPg6whYXFZrhXBqYK/iiw0zMLWkYGo/S9OeTwQvGtAxGcTeSQ=
X-Received: by 2002:a05:600c:3152:b0:477:6d96:b3c8 with SMTP id
 5b1f17b1804b1-4792af3d888mr39174785e9.23.1764809027713; Wed, 03 Dec 2025
 16:43:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764685296.git.m.wieczorretman@pm.me> <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me>
 <CA+fCnZdzBdC4hdjOLa5U_9g=MhhBfNW24n+gHpYNqW8taY_Vzg@mail.gmail.com> <phrugqbctcakjmy2jhea56k5kwqszuua646cxfj4afrj5wk4wg@gdji4pf7kzhz>
In-Reply-To: <phrugqbctcakjmy2jhea56k5kwqszuua646cxfj4afrj5wk4wg@gdji4pf7kzhz>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 01:43:36 +0100
X-Gm-Features: AWmQ_bl7ZVunvhyvED5tOqclCssm6-frqSDnocWXgYLBUJsGZUA2QPhZVEy1VsU
Message-ID: <CA+fCnZeCayQN3448h6zWy55wc4SpDZ30Xr8WVYW7KQSrxNxhFw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kasan: Unpoison vms[area] addresses with a common tag
To: =?UTF-8?Q?Maciej_Wiecz=C3=B3r=2DRetman?= <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8668E14000B
X-Stat-Signature: x1qcu8r3y7q77tdqcj3un6ew7ebabxzs
X-Rspam-User: 
X-HE-Tag: 1764809029-629691
X-HE-Meta: U2FsdGVkX1+/fjahLj6UWi8CBKQkh9mmlfuw4DgkxjtRIHFC1/WQQo1HZMfQ4bT7wKoBNnibqRDJ8jB9iJ3QATx/cfT28fj2grH5t6Z4AgNX0QSPyT9KfsUZhA5q4VA5iw6TC+JDYKVXrQg/8LHUJps6B7fnAyv7UrBT4Pe4QLqZHtMJNcU5AZ9oEMjkPjIlK5jhnRB8V3Wz+Vho3vwzZwQ3AHXtrSFcf3oumY/rcUKTb6PLAuLcB32wlOH5bjsxVorKjMVAQ8Q8aXP4X0HnR9y6izYg8SP+QZvBnTCidKQ+RocqW/xhDNz0SXUS+QvF0xncvNNk03Drc+3Ou5cNGUuOTKq1irbnUt324dPYNk5oxTcZeeTtbezzypQ/PakdOVMgDooyBthCidP3UBaPOyzkbZ4fEoaWAZ2R099bcKKpE9uXY1DwpxyiilkjbU71JfiFgDWdX07Usni9UaKt5WVaP4o/wvZZAaTnnRz+IDdE6t9PSfsEW6yuSZ88kRW6oimUttteNnRy2zmtmtH7j0rIA+4DZm9YouURwKyXQY0bkZ/VwPT6bJ3mYOyxTSSE8/fZ4qgBFhY4qvCTF3JOXG+ztP3aLtkP+sN1XYk0Zq0pj6tyOro9Y193OiJNX6Wm9C27xTPMtu0uI4Wnp2X5Zz+jvuRbEk965kTUhw38BHDobSJ40YlcKgtUGn/ij1fRup+T5/x/iffnU0wneq1eNjNFaywYvp3Gzn0rxJQEukTrUeYkFYBvnNHC9GZBBtHXHvRVtg3j5jciWGO+ZgfqlIFVSGcnOfPmY8wAJWRiqT14zivklenE0SLBMExp7m40khT3nhOUfH1KFk/7gCy65ogCtVf6Zkmzmp48VvDlslt8NY8GuC2xp/alT/Xcz6LqB8PUVLKENNuNLzQ4ROPQ0twJzgteiT6Bgdowf+AuqvpxwKnXiTspEZ1L8Wsgfwxysferd6rghEf8ghg9hbf
 nTBqKCR5
 Qorz4cVdoR6klDEC4r8iNTfKXfUU6s9sT39X1AsyiQxjTwoH9Wkkd8aCGdVN4zUhrlcVcZFQb2Bblf5fmVMhVNQrsKK1RBoUcMUr7Lwr5GsmLVvRQ8d94eM9bLXLyIFG6/bJB8N350YEdDpkHO+FlMFcOZdXRVi/VKPRzY4AD47Bs388yfDaE58dE4ERxq9/PIYSYLqd3ENBSYO98Cb1m5OqyZWVMw2o3AjCCUubeT4aekjRTRs7Tk80YDAQRmdNz301eH+AR9zdZNjjpDaWj0w0/64n59YLwl1urxiw0NJAtEhzYQCR7ASDBiRvASVTic8UXj2ofvm72zIVgk0A8M17/86CP40Cw9EEKfOy2X9F3zNednIqggxy93DMA/cJ7FO9nHxgizcWcNBK2KSPEFFeOh58+T/pYw/pxWJCT/mg+IcCW4UYRl4pFsD8C48jnZVbnYcrZ9326NOT8O1zD6zBJBIK2CMqILqzTECx6finK5u2AeNr+eMhaCnsHo0AhtNR4icLVleQbyWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 5:24=E2=80=AFPM Maciej Wiecz=C3=B3r-Retman
<m.wieczorretman@pm.me> wrote:
>
> >I'm thinking what you can do here is:
> >
> >vms[area]->addr =3D set_tag(addr, tag);
> >__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
>
>
> I noticed that something like this wouldn't work once I started trying
> to rebase my work onto Jiayuan's. The line:
> +       u8 tag =3D get_tag(vms[0]->addr);
> is wrong and should be
> +       u8 tag =3D kasan_random_tag();

Ah, right.

> I was sure the vms[0]->addr was already tagged (I recall checking this
> so I'm not sure if something changed or my previous check was wrong) but
> the problem here is that vms[0]->addr, vms[1]->addr ... were unpoisoned
> with random addresses, specifically different random addresses. So then
> later in the pcpu chunk code vms[1] related pointers would get the tag
> from vms[0]->addr.
>
> So I think we still need a separate way to do __kasan_unpoison_vmalloc
> with a specific tag.

Why?

Assuming KASAN_VMALLOC_KEEP_TAG takes the tag from the pointer, just do:

tag =3D kasan_random_tag();
for (area =3D 0; ...) {
    vms[area]->addr =3D set_tag(vms[area]->addr, tag);
    __kasan_unpoison_vmalloc(vms[area]->addr, vms[area]->size, flags |
KASAN_VMALLOC_KEEP_TAG);
}

Or maybe even better:

vms[0]->addr =3D __kasan_unpoison_vmalloc(vms[0]->addr, vms[0]->size, flags=
);
tag =3D get_tag(vms[0]->addr);
for (area =3D 1; ...) {
    vms[area]->addr =3D set_tag(vms[area]->addr, tag);
    __kasan_unpoison_vmalloc(vms[area]->addr, vms[area]->size, flags |
KASAN_VMALLOC_KEEP_TAG);
}

This way we won't assign a random tag unless it's actually needed
(i.e. when KASAN_VMALLOC_PROT_NORMAL is not provided; assuming we care
to support that case).

