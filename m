Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C72DCDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF60F6B0088; Wed, 24 Jun 2026 18:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDA56B008A; Wed, 24 Jun 2026 18:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE106B008C; Wed, 24 Jun 2026 18:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989FE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:39:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E1AC1C5E74
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:39:23 +0000 (UTC)
X-FDA: 84916273806.02.A996847
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32A9EC000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:39:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eU8vmVhS;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782340761;
	b=hXwRbA1LSaULR3S+Px2WK4qXU0LFvKSeX5FRVLg+wl52+IxglWW7Qyr0aCGYh3WfA3JxPe
	f5qwm3LjfgGqV5COGYVOuQKE4/tbiDb+13AY32hyxwi9ZEMwFcqieiFnZap3s4xyn9ELGW
	P+MGo6u60EMaFy0XPHEgKJOpOTLHgRE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782340761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0wPi8o/I6OFz3Aww1p1woK9R3a3nOBy9NB/pWziZek=;
	b=KKdRJad4jjN+2fsSoAHyChyM+cNyHIA3AiugazpWbUJf2DFa+oAFRr1CHaKoHrgUo8Y/23
	c1Vs9r7UJxYHHcQ6qzuLBSmfrC2VQVGkql0BK9cXZHsugNrR9rvDv6j2qPODj8Uqy1xpFs
	SciiBGauoF/b5KZRW63wxdi8NVIzVtI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eU8vmVhS;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4922244f7c7so14235375e9.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:39:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782340760; cv=none;
        d=google.com; s=arc-20240605;
        b=dH6uZbZtK+WqWwOMkVgRP7lBlMBIDBjBbwJZPPxLlb37Bnuif9tYLoTwlMP8j/YB4Y
         N4CVqlmHBDqvLz5XZZo98J7bklACEvDTbkyNlod8O2DuMGTIVekZjQxUdK+hwXyBy9be
         GqN0iIbeGvtrHnLeYYgHxzr/a5qTzO/3nh1AXvMJaJTiCUSz631slP90pbZs23ARa1FN
         Ufd7nQEV0+be+Qz6OqzB3wafvxVWmqa+xoyAYp046k1GaFB07J4sqie04HJYtflSwW0u
         i3coS6zwjmtMoaQhZCgCzjYufJlwXB8dYh/jnmM5s0IrCFoqEaapvS0axY8Jp63qeDW7
         rI8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m0wPi8o/I6OFz3Aww1p1woK9R3a3nOBy9NB/pWziZek=;
        fh=VAKL/34mEXiFsaBdE+m00ikQ7UKi6D0/pPUZgfBZLrk=;
        b=FVxy5KWTbjxd4F9agBolycxhsQexxBg/bg9eOgjs+8qbjE82dttf6doXSM4Ua6MEir
         ABPK0zERmcoM+Cp6NE5iyWyHDsA0H6Am8fWLxl2KBcWNubjipk2NvqrsbxpPPVtesnXM
         vSGGMHffZcHaMl3R69r1QA6nbIWfi3CmixEGPWZ5ZhKjXIzvv4PyaZcEEV8buo7nLT34
         xxCX7XORrykaEQcNvus0cUxF8zkhtuvxG00FAFtGRKNu2mZAFMzWHA+h4bYljE9mxMm2
         enBY4uQc2PcOrbAYDOKElnXNO7RGGQRwoXID9RmSAQ4vS55uk34jK+veEaaNcSwptJ22
         cb+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782340760; x=1782945560; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0wPi8o/I6OFz3Aww1p1woK9R3a3nOBy9NB/pWziZek=;
        b=eU8vmVhSUb8FPJQHO5R6RpDx9tWtLaSmSajlAQQJt/cbrw6CohNb7ywK1NVAvUUsxB
         w0t+7WPyoJn6h8kx1vunSSudV8CNERBG42RntTxCbC3x90W9gS/swT5HzmS9DN5Fhz44
         /Sj+kuEvH66QHIU6CP4VchPs4G/nByeFIFY7g5POVhOMoHAL7Ojz6Z4wUcLqJ8n9nSHf
         HwdnVf6it8lIr2x1IeOMKg1dDlIKUI62Hjd9+ZKbx6Gn5EmBD5/Rmn0oAlyCOcG68ZGH
         FKmzopapgefdSOj5BiEdYxeYclBChe+WEbJDHznbA6sOeKZHkbEkG38+hMp6xkzPeoE0
         NXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340760; x=1782945560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m0wPi8o/I6OFz3Aww1p1woK9R3a3nOBy9NB/pWziZek=;
        b=WdYlcBZjpXEroGsApaMKT/yj42GYdbO8ItUDKYm0apSh8YUbuhdUhSxAEhQObZ0tsv
         84YXWKAkUO7GmlL7c21jEimxcSZaMt+XoGyXtAoB6ugg9VKZOMt+OZV5ovBc9CYCfzjR
         GjKPlEcR3M0N2OmYzN/wU18GlZt2zJReKiCfrMu/DsXviIMhgyhtzOASl1HfO/c9REVq
         Q539yKQLnASK02b8+HQOO7AFQ07xzyarqHhYwOzMoDm/J1SP8+mNO7VN5G7egcvbFxzQ
         xdVKWQ7fUA7ZFQmDiVFJfgyt4ONyd8Q7Yjf393oQTdDlVqalJzrFU5deLonBfUjqmqYo
         U5cw==
X-Forwarded-Encrypted: i=1; AFNElJ8gmiItNWx8DYC1yQa5w2Rmcc3pc8ERjLLAEH7K8PMfXkeCKinm7DfwfOVivHKCFtPaEljyELOljQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2y7qGtAXTIp06hQcj3XLOxQBXUBGiRjRpkW3eLOSsn3tKlYIT
	C2XvqhXTWeoNV05JJHrnGaHmrPpvvZoUm6odYnJ5NjXPA8MPcP1hom3zSHT9iaN0rnmh9p7IRe9
	hFUErNtH4qU12qBEeWHHw8zfSziNvvv4=
X-Gm-Gg: AfdE7cmVUe9RUW6+LlYCkqe9pZ9lmdKnKqzySHeG/R1ZaDSyeQMsJNCHJGIOTTbmHF8
	ePxfT/idZq4M5+obs5OoCxMZDT9pgGco9Ay4zpgmwttRwq8ImxCwFPWQu72afqEKma6jzQ2Z+t7
	pTWHTqYQWUKh3DtGzxguhDcWDWVUMr4CHk2NOhaSa3QCTk4zBBhLMzb7Rn0mroQhvA9PlOUyUTv
	85fv7Gt8ExF8Mhj+GByo5zWX1xFofyiK6A2UA1oaxKvq4HTP1zJdZfGUiTFzh7kYuoPDCA/UFgd
	PyVaYP3RGJLyGo2EF0DMjP7JYNYW4lXVtrLmyC6mwcMH
X-Received: by 2002:a05:600c:8b4b:b0:492:4a56:690b with SMTP id
 5b1f17b1804b1-49260881747mr74223945e9.35.1782340759455; Wed, 24 Jun 2026
 15:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com>
 <20260616031309.3036234-3-haowenchao22@gmail.com> <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
 <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com> <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 15:39:07 -0700
X-Gm-Features: AVVi8Cd9DTQyoKAw2miKweC3fchYi-alMyJbPIEo2tmOTYkeElmUqRc6wCyu5lo
Message-ID: <CAKEwX=Og51dvN9PsH9dhVHTU=CQk5oRHwJTiu9mN9Bn8uLnx0Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Barry Song <baohua@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32A9EC000F
X-Rspam-User: 
X-Stat-Signature: 7maitn9awrqder7bbheityuwaj1z19zr
X-HE-Tag: 1782340761-851521
X-HE-Meta: U2FsdGVkX18gjZM96luYOFpvrHKFarYcbkrbsZXMIagCXssAIhLrdBIeIwh9i+hEvvifVMAhMgNxPjreZ9+RK+NqZzd36+A6y5vRA8cZafsNufc9rr8kR2N6ARRU+QT+DVFi7tdrH8Lubk4kPyhykisrSOsJBi0C3dwMT0dv7biyDK0nFFO5rgq6x+Q0gTeSvwAbW27z8XJ+e+cWnuJzHpx+NiN29I01HbhlpLhFu6UwWkB+7ybS129rz9+CZxlDZUAl4IumycDgXenxpfQdcW9Qa7GRTj2U/AuwYsLGbs4muD1lKa7my+OTsytWsR6oe7Il/dwvZ5VAE6V+FhmhzF2WBqZWPwlHZGuYu1AzT2s26YKSlcSg6FBWVYgVRj6JPcWK4mZ58qYKRlIeabKHSx/U7MIJTnieS0hPHefwDPCM3S/ygkI+H7Defpqv9rzmm9lXeoZ8cZ9W0WmucOEFOBgVzfV+TghVCAd38mzv9VHFwkkA73eOneRq7kooF3JEPUOobXRV/2ZjfaVXUbrD53JWKROv0N1epuUKbrN3344tMvyRLYHySOjZVbJQVzGvwmgpbOqEabCsVZEjjQMVkKet9NGxFYE1JsAkHmYK4iZinDij2NjpFZ+Zy6CiiZRYKweo+gNOpAkfjV75PeNnCWXaA49YSNjuVBEI9dZKRafDQEL+FcxLYPTUIMUovbEFa1BPdxnayeJfqoTVaYROVCRlTQmPHg4FCce2k6UneLnsnJ1CMYmtf2Sd58ie+V+1fqjGx5e7O9s+qf4lSbOh2/QCsb5pCxrY/IskfUqINl+POD5HEPNc0y7XGKt91FP95c/ZLysuPDhYkUwTXqTiAVK8jXd44aPesbE3EST09JhH0t1psU4d/YVRHQagT9s0xjbvIATPAKjOCm6pCparyQPT8iLZ/bFrUx/jOJcHzFKCvYb5Cw4vPc5+iZmUoZ0+xb3UEaRlrDwKPQluNpM
 Uspf+c6m
 oQLsQLeBi0Clb+2fkd5UP2WBcAaKenLcIih+Y/1W+/nJvVk8uOXduEOcXgCOnlNmx9Kk4J7alOo1hcDLSNh1OnTWSeEJRh229MRcx6hXBwEIv6ceG7x2+ge/UU31OfU/vIot3tKBkHcCcF/cG/WLP30T+CAD3z6WFtxYQTMKZ9qeAgGEgU2OiAJG28+wg0gaIxp83W6IuHL4Q5VxprjIHNfHLzPjN1qQxPJk3auedBh8oEiHsmdWH5d+XOOSG/1cg114SAzpvmMBplzGY1xRKdsZySkiOFbPHmftQSrx38i9eDUokDOHIvMivjkbE92Are8Nd93t4gthLJaOTv9570JX8imLbxyyc/FewODoUW1z9SGuYkkrA0E1y2fFVtyuuIBuQ+LfVIUsTbfFLXzOYWk3XY9PxYfmk22jasisLZ4TdOmczBTXQLJo3U3/Sn1xw4WZSlCmsnd6ZIRudFX73VHsWsttqDrSTBYxbY+L8s6VZxd+K184U8WNCbqimIerhOEo1Exxu1LdOdP7dm9gnof6bD33AFOnk+Fmtm0iqR8iMA4LTnnJmBBxqXLaxkywnnhvI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 2:57=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Jun 24, 2026 at 2:15=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > This name reflects the two key things the function does:
> > 1. Resolves obj -> class (via class_idx or zspage, depending on arch)
> > 2. Acquires and holds class->lock on return
> >
> > The "to_class" part captures the lookup/resolution, and "and_lock"
> > makes the locking responsibility explicit.
>
> I think obj_to_class_and_lock() is not a good fit.
>
> The issue is that class is a noun, while lock is a verb, so the
> name mixes a transformation (obj_to_class) with an action
> (and_lock) in an inconsistent way. It reads asymmetrically.
>
> maybe just your original name if we can't find a better one:-)
>
> There are only two hard things in Computer Science: cache
> invalidation and naming things.
>
> Best Regards
> Barry

get_and_lock_obj_class()? :)

or obj_class_get_and_lock()? - there's swap_cluster_get_and_lock() as
the precedent.

Anyway naming is hard.

