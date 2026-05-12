Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC5ACD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3046B0088; Tue, 12 May 2026 13:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053A86B008C; Tue, 12 May 2026 13:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC376B0092; Tue, 12 May 2026 13:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBA856B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:14:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F7D41C13E9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:14:16 +0000 (UTC)
X-FDA: 84759416112.04.4E7EC07
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89F6B8000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:14:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bEqfJY8c;
	spf=pass (imf02.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778606054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YO8UEa79yuXhPeuCXmMbzlsDI56cE8B63Go0mISNV9A=;
	b=Z89j/pfjimcpMKiW68xBrauTs/o9aX6Tqw6IXK3ziL3QDriQLjya3xBfWzaKCf/XMQxgdD
	Qt9mtRGFDywQ3HvUuCRSTp8uWncumWjogGgcp0iXU4NZojtAp5i62x7X+LwJHXv1XSWCgR
	xObV7Wi9mCIR6y1VPU1xe9lpTCSlARs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778606054; a=rsa-sha256;
	cv=pass;
	b=rESzEQL/6y1NHC30j9S8gTcX7Kek5bqqQV8B4ZsAXlrKT4hQGoP7o4AZtQIEww+2TBBeTv
	Z5pwnThaukGcAdoM/WI5yDW/0QSlhagbRFCkkNmNRbKUr8l0JkxJm6gATJwNejFEVmC3Xn
	wjmgfgW3fZ1MWyqlVXHnX5Ig07oKPHs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bEqfJY8c;
	spf=pass (imf02.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67e43a8996fso6434375a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 10:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778606053; cv=none;
        d=google.com; s=arc-20240605;
        b=JiYCqEj5yNw4FBfHZEXBc1SOyywM4SimGd7hCYUGHd6W1j+uhwT6qcQvXVDGzoa6IE
         wIJ1u3qBQFui1prIpgFlUoMI9zw21HIKe3RFKLGHzphIoLl8kgdR7ja4U49xMd+iRh1N
         cn92ln1iJ9/utGcG/wXLf0YkBEiGv/epSjqeq460Pj04pvzj8gf4HCXy80xHyWW++71R
         UPMErxoqJwvQiWXR9aNN2GY0cAZ9i+wS7ob1OO78cnBZ95XjFtQm+xUevKtIl2qHn1jG
         cAQWf3t0X7oLHyzB5an7fuCmhkSV3MjIA3xBixaBhCJiyEpZ9P/aE4RpRH+SyUfxcN5l
         GLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YO8UEa79yuXhPeuCXmMbzlsDI56cE8B63Go0mISNV9A=;
        fh=QSqEm7zhCf7Mvli8gvjYjLy+7u77GzA3ZtStLpX2O1M=;
        b=De74ot7EE3HDheT122ppGYDK3d8i6Sx4TNXZoekF6J6L+HlBEOGAqBGymmD499r4/7
         MCntc1cCjwtfbtLpjJty1hqxePpHYszNoW4oNSnzfPpv7hbKVwJmparqgfa9BzKwugDj
         q/Cugl/39gu9/tEXguB1pwT5y4H5Ir9k1+qSUiEWagAaBPHqxeGajWk7UTcFFvlJ1vVC
         MH9OsSVyElF8CgoGKX4bX6iNG5edi4hs57BNexeq917d/RGGY0BPIiuZ8KMimaktAfyP
         l5wiOmgbO0xY76sNa1ZcMlgrN66hkn4DWUJR8mKS9DV9zWAN4notOFTCtU94HyUjI0UC
         AhCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778606053; x=1779210853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YO8UEa79yuXhPeuCXmMbzlsDI56cE8B63Go0mISNV9A=;
        b=bEqfJY8cJC/dDn2tih9IgIXoYQwK+ToAY6ioEl6X2HJPxOAU1zMpZqDQVlet/eL4gG
         Tg5dSNJZRbTULovE2SO1OLwF9/bzdtL+omN6BtUMY7Kf/W/bgfKkb9QPkg6umyWifLiY
         IJrRI6qlrUn/q5gjZlAOXulBf2dVBGZEBcP4m0MO0OO/ua2EXuxs34ju96R0g/AWCQ5k
         hl8ISV2C5isaZacKNeUpA+hyPKbR05Trakl4WSIcvYeH71TRmzLUreXnjjDBzvOlrv22
         3MzfT8LU4vS1T7tEuM7RAvBHFz6nfZ1tTWp+piQThwJZoz/zKZ9JcjK8U8UDSygMlEYR
         XnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778606053; x=1779210853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YO8UEa79yuXhPeuCXmMbzlsDI56cE8B63Go0mISNV9A=;
        b=oErm0p33Xy7/9HX60WQxxI7Ff/P6eW/QPIk8cOMevbScNilfZYwBOohC5sEby0ZyLk
         528epXS7IlAVBHGWkb0h1jd3dPx4uN9s7bcNRX+I4XAEYliggANqKfROMx5pV0iE0LEB
         6+cS3/SHZJiJwqBxAXypRR4XWp7lUBE0Hz+3dNc2DNjxB8kaH+z2KR+cYkhFQVO/z141
         9Mb20fgZWmtXmobhSfSIVLR/GJ0tEYRA7AiFIT7+MEC96sIDROs2dGmJNAMOW7Aj+aov
         XwHKaHMbWpGFx2HJUsnSUvvDEX7xp4hIvkw3MbzNwg2wxIUXPf7yyZgritHWLmgjNLiB
         PMLw==
X-Forwarded-Encrypted: i=1; AFNElJ9btan4CyUxZvk7Kx6M9SLh5SEMqlyq8CIBOFxvU9u/hzVzF9RufJxuobk6xOQFV6lH1G9AMx+gbQ==@kvack.org
X-Gm-Message-State: AOJu0Yyt0jnyFa/t2GJAB57PwujgyXcaiMiNbC9/RTbdr90zWdqNnJEI
	bxTY1yoUqCgIQmweGJLU0XUrQuFkfqAnQhs7qgEllGi1LLdaHHViL250RrBNSEBszOJ3B5w87mn
	zU7WDMzO/0+HIpwJHEkkSISCqYfN6nNg=
X-Gm-Gg: Acq92OF90ROvKe10icWO5NTT0K80KLQYU5qtydauEtgnNTEAkIWR3y+y8FfRF0o3ZJn
	CUSwcx1LsYfKEdsj/Vm6Op0EVRWWhp2TLayUR2j8xI3qqDSGuhCTFU5Aajs8Kp6FjrQ6HD2AEw2
	dK1ALrzI/HJIgQs4d3KIQISySRtRQT9yjuo4QkFaYkCaENNfctwWm4Tzk2NiXiIj9/pgYYQp7Bi
	wKRdkUusjHAbajtSllf10LbyMWPU4ccXwFfc+eHUBeS3X3vDyU+dANC6XeTc729OcHjzPa5sGEt
	tI8=
X-Received: by 2002:a05:6402:3817:b0:679:4b89:d348 with SMTP id
 4fb4d7f45d1cf-67f714ed4a4mr7111570a12.24.1778606052319; Tue, 12 May 2026
 10:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2ed44M=-qsZO7gwcz5L2njdRdk54d47jEg48MhWTkaew@mail.gmail.com>
 <20260512023129.44966-1-lance.yang@linux.dev> <CAG48ez1xdO1wkqS+eAcnAV9QJ25=t1o0-Qz4qTZdg1Mo+en2QA@mail.gmail.com>
In-Reply-To: <CAG48ez1xdO1wkqS+eAcnAV9QJ25=t1o0-Qz4qTZdg1Mo+en2QA@mail.gmail.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 12 May 2026 10:14:01 -0700
X-Gm-Features: AVHnY4JPV4nvI-vVDAMS4jJQpRRQJB_SbZAL6xKOyji_fdKj1jAiWLxEmrrsjQc
Message-ID: <CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com>
Subject: Re: [PATCH] mm: make zeropage read-only
To: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, rppt@kernel.org, akpm@linux-foundation.org, 
	arnd@arndb.de, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	ardb@kernel.org, sethjenkins@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89F6B8000E
X-Rspam-User: 
X-Stat-Signature: wncm4utnu8bnj6r64r6jam41wcgg7gn5
X-HE-Tag: 1778606054-841738
X-HE-Meta: U2FsdGVkX18piHl4afCkdD5i7xYJVTdoJVF7ZUwDvcRAulc8LfDL+re+2ANYBTRGvYyA5IugvRvMD6bUUOOOMed1NVdhKLXKxy5U+wE3TcfbJiqwYSccbu+a9OemqR5MdEdCWNK6ZBX26ihzJEen7BkJoal11xx15dUzdQYMhikvO4duWjClyYCSLtd+P8eFq6Ry3zXXdIcbuw14+lrk48MrWyc7/MdF7A9+zT7xyTlvxPVcQyuhC3Gf1jXrlkrlq35bHxrirBmIRQlQ021scMjhhyEIOiDpsOmg7dGlGKBPQ3VeS6rEm5fc6r7AwK0EN/JxVs+WxhJAdeCH3jhbTSLCoeWz3Eq+UrVM8mFreFJv5nDTCQ1vbmnESUBGPRpohnem7oXAr7JlhBn1uZwgyEJOEB8UzdtNCBh3pb2ST86IqEwarSHlnPAJ73HOA0Pb5m9zNHJ9exgHB02tgVLVHB65B1mhgY02QGKOsUFOrDg0+myqoPpOECoBZaWLsCpeQy6WD+K5VfzfxKqD54Scx3VcrqcUvbR9YigQ3M6voy+UOqc+GktrhmwFpPgEWur/aZBNObtfvPhJzJZczaHJWOpl9HIEXbHnEpxjEcPTxUEF98K97+AFESyzan1QVKxRqfWo4HiR5p9PxSYJAeGskkQQb6P9dMgn8z9YQtzOtqzeu7e3jUGHwm795V90msIviq2GBLyv7EHAU1iUiGnJC6Mu/1BMvB8MUbK/uNwJOytv4mK7u9rRNaHAZ7OH5LlxIFg8q4ksT62uGcWQXKWEgqlVBpMYqou3jZ5xf7t4CN4zO5qLxBmWfCcf7SvlZSSshwwFN2yd59lxZM+44lvLJlX8HWrJ0f+INOVq9Fiot750niETvF/2ROh2SBWGsgZIalOaGq2/pEFSbbBE+skZD69Irym4PztibBEaimw2XEaN5ZzkG8BJID9/Ltom/Dt5YhbHkSjnTpKGvAAdpit
 HmlKx0Zt
 9bkDqbAbjeA6FtKIJq/TdYUCjz0CYqT/lxk+06mZTZiezVYFCxYtyDqkIULJHyWem6UQogB0lBEsSMEarZlC9c8PInzp7HoAQgMklOFpQqe32+HUwBVNf3c0RqvE5YLjOoiFHueO9/pQb4Klr7FKWwjgM8O8OU/hcmktLx5Aeu3Yb2OKlGWGLuS6z+4CnrQTO8/0d2l6Zvy0weHUS3cyT5YPFXGFi9zOj6Hay4L20u5BLoI4+oFxMnw87L83hDyJaiEVxHQDwaeHmmGjaALqozClFh4bR3fM5DmAkK2I876NlmbiZWya1FGxp5nhRQOMtmHTwhqSTJeVywIXJNb0J/BbmW/yDb+X4ly+EIie3zMTJIZRokzTy39hGc0QZNVOtwQWhclFxJic4l6SVtNO2yFGs24OIHlFQOD+/lLnPI7kU2zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 6:48=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Tue, May 12, 2026 at 4:31=E2=80=AFAM Lance Yang <lance.yang@linux.dev>=
 wrote:
> > Would it makes sense to apply a similar treatment to huge_zero_folio
> > as well?
> >
> > with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=3Dy, it is allocated at boot and
> > never freed, so it should never be written after initialization either =
:)
>
> Oh, neat, I didn't realize that that feature exists.
>
> I guess there are two aspects of making the huge zero folio RO that
> could be problematic:
>
> 1. If the huge zero folio comes from the page allocator, making it
> read-only might require splitting a huge PUD, which could have
> performance implications.
> 2. I vaguely remember arm64 has rules about how PUD/PMD entries in the
> linear mapping can't be split at runtime at all depending on hardware
> capabilities, meaning the entire linear mapping may need to be mapped
> without any huge PUD/PMD entries - IDK if thp_shrinker_init() runs
> early enough to be excepted from that. See can_set_direct_map() and
> force_pte_mapping() in arch/arm64/.

Yes. First of all, this relies rodata mode. If rodata=3Don (used to be
called full), the linear mapping may be mapped by PUD/PMD if the
hardware can support BBML2_NOABORT, otherwise it is mapped at PTE
level all the time. But how huge zero folio is mapped in linear
mapping should not matter, you just need to change the linear mapping
permission to RO anyway.

If the rodata mode is off or noalias (used to be called on), the
linear mapping may be mapped by PUD/PMD, but basically changing linear
mapping permission is not expected by kernel.

Thanks,
Yang

>
> So making the huge zero folio RO in the linear map would probably
> require adding a new config flag, connecting that to
> ARCH_HAS_SET_DIRECT_MAP, and changing one or two places in arm64
> memory management.
>

