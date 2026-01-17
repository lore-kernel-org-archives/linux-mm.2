Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209CBC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7208C6B0005; Sat, 17 Jan 2026 12:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4076B0088; Sat, 17 Jan 2026 12:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B08E6B0089; Sat, 17 Jan 2026 12:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476A26B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:08:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA195D1D11
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:08:50 +0000 (UTC)
X-FDA: 84342090420.23.94D8F60
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC93C10000B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:08:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XffctvBF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768669729; a=rsa-sha256;
	cv=none;
	b=5c4KnWhDTCs4i2zbOIcAh73fWYrSRZQaIMsFkUN7yGWaLuot7UbnoJmb7Pm7oxb5KoO6cV
	kqE1ETn77NxQUSyhqUoq/r/iMFbYPle9+IQ8CdFBYU6uUJQI9WEDNWL3staftVzecvnD28
	IrMncBoHiDMEGk1sZfCh6mdnyAss/Uo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XffctvBF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768669729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEphG+uJA/ZTSP7N9fDLUX1nKXTIImKyAsN5fw6sI/U=;
	b=ZT3Jcu8IrGhRkKzdyv3QDy58nVGFnNwwOqs/0VNUBTGZZJOV+GraYObyfDSDVJARYhP/4Z
	iAOMnGosm96wIppS91757eAOhs+oKCmvC0mvWuKvIvyEIqSAq5vjqnHlVqf64YtRlaYC24
	NUHkr/qJAcaIQUqMZ6x5xknOERQ9F6k=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fbad1fa90so2714621f8f.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768669727; x=1769274527; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEphG+uJA/ZTSP7N9fDLUX1nKXTIImKyAsN5fw6sI/U=;
        b=XffctvBFRHubHfc0khvWNU6nMtlQ03AM9jv8mfizo9/Kbs/XYQgYrHxMmquObR6zbh
         pe4ogeKdNYBoUAXn674YHUbZfJl6Fc0lDcFS3zV/W5rFZL2FjGtPJOhkqTFE3mMD4Lmf
         gUDYHKOUzsBP9Awdh9wZaGd6eZKF47fFx9PZQ0uRnlw0Z7mbvcbyEttK2mUwF/TcWRce
         o6k9I6t6EHXAHTwXAZlxiDZBxH0b1RjOB/ThCqS5QUnr0MgbJEROeyPplUjKOxevnFF/
         i0YwMZRxVIjQ2Dj7i+hGub4q6/n57GGTcZJUrita323OlHxHLxO+gpG4JPqI/OkNW160
         yPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768669727; x=1769274527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aEphG+uJA/ZTSP7N9fDLUX1nKXTIImKyAsN5fw6sI/U=;
        b=rY6WDdVViP1/0zKB+KRdMmmqyAXMN3HrmmCHuCvGCPGrLVHLlohg8UL/YEykZsJycO
         iCIs8DOyLpjIeNaMIB9tyVi6MmbRW6rpnHCj0YjQauFg+NJY0APk+BM47hkOJfDnjMBN
         pc4qXEpW80IufCaMZdRdS7YW2ZPzQWEHJ04/YxVFwiveaxTs9GV7cWhDXAs6hQeMa2nu
         cCukS5VUz4EjVbloXy0TOilBaArLqul5kzTq8xAct4h8GPYdbINjUky0FE0cJEbVxzp7
         126W99W3gkor0EuOl3PH0zSIlJZ6++7gDOD40mgmjDk+2gbIJKvO6UGGqpeQnRfnWoa/
         eYLA==
X-Forwarded-Encrypted: i=1; AJvYcCUkQi/7NErqAMnm+1lbBVEn4Y+hZj2VEx1b1i1qkBQ0VkvJn2D5n4Kzs9Bcyz+egyTbM+jFtv3Lcg==@kvack.org
X-Gm-Message-State: AOJu0Yx6gsVmwQ2VFQRaJtF80dixHVucaU1LuHBr7E/6+YgpcxIYK/sB
	cGRYMmynb6EyfLaCCRerjSeqEYSKUX5l/48eO9utywEfLMz8/l5jMexa39IlQpPl5ZsIKdZRsV4
	gz1MQ50LD7jG7KI5ZPJOCytvf54jx4dQ=
X-Gm-Gg: AY/fxX7XsFRzeaZ7RbVWuIxuMOkx0sx6LgFUaBJ70Gia612GSxS4BDLn+xECYFCjRky
	cD/FInxnN1CZ44TqgGMdEB2HWgCYf1DIC8KMYmffrSDKagpnu+74REhGKlhFK2rdxkBT1Q+87g5
	CI+tf2ZrjNJr3nN1W7BEv86mPoxS2WfxL84vFESBMAmL/uKEq8XjFMLd06qw/X5j5OLqi2zt6Hx
	tzTcetLdumf8eahzahRk+f1u0eO4NtH0dJbCuhZ/Vu3KFKr9pjgOBEny4TLxcyjuZ+W+6f0p0ct
	52jy6sJpilwH0dp5gxe8Wocf4j4P6Q==
X-Received: by 2002:a05:6000:2910:b0:42f:b3b9:874d with SMTP id
 ffacd0b85a97d-43569bc4a81mr7718897f8f.37.1768669727114; Sat, 17 Jan 2026
 09:08:47 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com> <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
 <10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com> <CA+fCnZeDaNG+hXq1kP2uEX1V4ZY=PNg_M8Ljfwoi9i+4qGSm6A@mail.gmail.com>
In-Reply-To: <CA+fCnZeDaNG+hXq1kP2uEX1V4ZY=PNg_M8Ljfwoi9i+4qGSm6A@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 17 Jan 2026 18:08:36 +0100
X-Gm-Features: AZwV_QhGpsGfhcwUuOSjH1-DI0GRyW2mW52xb_iVw_QKkxgQTpbCVoSbyZvTIyw
Message-ID: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: cufhbr4z1wprf9i3ucgdpbc9qw7d7ekh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC93C10000B
X-HE-Tag: 1768669728-639378
X-HE-Meta: U2FsdGVkX1/bp5G0M/jMCdCvQIMPRTqNTHhyOHxRnIRNhSfh4NCCPvxqO73O2dpp9f7MBZIlnP16NQ5S1RGS7vjekIPGmh0OVxH+HK/vr/Y0TGaFvo9qBYEs7K++Jjhwt+h62NR7Sw/HhBUnsQZDus9Y5vz9zEQCK+UgqoN0AK2H+iUg9n8zBoN+itPdZNrRTdK0glIiGf/3og1cI34z/pgFRg16421AjXgULez38S6CLyQS87TLLB6XxXMpPIqhvSloAcElEjtE2hnak8qjthabRLfbxxoFpdLDNaMNeTFeXoMKFET9zfdY9yI7FYq9dfRHq0CiBYM2O88jcl3oeaT5HTx2AwsMOp0y4ITnwJNNV6NPmUc/8FL2ljXzH9wJiMWK8Ca+VGC1E+f8bVHdPY9tLmGpgfftX3nSPGeDyetiAlFSc+JeKtjVGaTwqAWWPDh1v4W/gq27AYo8n2C7H0Pq+UOhtpmHUlL2GEHnOAR7lhNbehwLHWcC4qU0aIOYVYzhgi84XvpY7M7tevo18dbfHgVTwQ2DzqVYToQKadTKAtUEtw48o8KXluOCsxO+DQuzt7YSwqN6bLGIa8Fuhku7tVWHRZXvZn0xdU0pMGxIjyAhyp8r9/j8Klx1sAJJ6gJZI1DeBQeOLUt+XFLLQLnR2fYD2bzgZ6hWCCPqfBidQmgEFSp/2FczTqBp9nkTkI/rDK/8BAbG6/wb4mYvQJV8AgEuObbsbh2UKg5rvJA4PY4yoU40A+JPpvHVGHWpfDCK0N2hkcRSaxR0wdAzWWyWtE8K+f0i1M6NVzVqAbea57lPADvBoawIxi6jndAtFRwfOM3vCcgFdT7AxlapeJyI7IGt8R9NPXHgk/7aPxPtergGbJv1oOLiseHQ74iujGVv4K+WQlZBmcEEqXUCIAYsdEHzM/A/IoTbyYvlJkG55vK9g2q7qIDV4vKRaMgmBcjwftV3bV0ywS7+JED
 wZjt++Ud
 NMtCFRtr/M6KE2udkBZSlXuw7FuJSSHEfSned9nOOTp8iuZoqwFj/p7u5XNeZpMamuinNSzI/9EBtrEGIDc8TBjq4BDd9AbCzgS8LnJnsNIOKL6rnjAGVDHqIXFK4ObAk+JDlfmhNPqJdYXD4fQlC8zrFheyA5nA9zQ5amTkAs1vkaIRrp29HE9tjjXtyIBGx+hSQuNklAiDrJi4oeDntcbc7dgKQElNNIjbN531xGh/CZM1eeok7towdtXcF4oxGjvlE97uXgqSd76wc4K0XovVEm3wBW85I+B3zle7AKpF3XyIW+9o+kNRwqDnLzAF20Fmoe2kiz6qtu46f2BPUH3lN4bxEBQDeIwhDzmF28nAvQCOS5ZxmHzi22SuAEEX0giMtFOYlkfQ9Vg/n4widfmP4Ams9/JwZGUaV+dIB1K++YbblnC6hq7oAXzMrihf35PU1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 2:16=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Fri, Jan 16, 2026 at 2:26=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gma=
il.com> wrote:
> >
> > So something like bellow I guess.
>
> Yeah, looks good.
>
> > I think this would actually have the opposite effect and make the code =
harder to follow.
> > Introducing an extra wrapper adds another layer of indirection and more=
 boilerplate, which
> > makes the control flow less obvious and the code harder to navigate and=
 grep.
> >
> > And what's the benefit here? I don't clearly see it.
>
> One functional benefit is when HW_TAGS mode enabled in .config but
> disabled via command-line, we avoid a function call into KASAN
> runtime.

Ah, and I just realized than kasan_vrealloc should go into common.c -
we also need it for HW_TAGS.


>
> From the readability perspective, what we had before the recent
> clean-up was an assortment of kasan_enabled/kasan_arch_ready checks in
> lower-level KASAN functions, which made it hard to figure out what
> actually happens when KASAN is not enabled. And these high-level
> checks make it more clear. At least in my opinion.

