Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E46E0CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1F96B0011; Fri,  5 Sep 2025 16:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E826B0012; Fri,  5 Sep 2025 16:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC356B0022; Fri,  5 Sep 2025 16:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15D566B0011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:34:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB41785AEB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:34:40 +0000 (UTC)
X-FDA: 83856349920.06.00EB096
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id E51261C0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:34:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqEI3ZRR;
	spf=pass (imf21.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757104479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfAilJ2gxaTlTEXjw4cUYBqev2DLfb4NtdyYplV2cLk=;
	b=S67jFvRNvO+hD85eYvkGo3EGn/idolJ77W14vLhE+U1aPgzydgMTj1k5ikBVclCOIqv/kC
	lIjG+rOgAzsYBwdDOgQA/ycwO3sbVie0iK0qnYIK1jKkbSAaQ8SKAzHy+dv7EuatXWnzd7
	Xt8mvgd9k7VIC6FLSmDbtw0HohKaGNs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757104479; a=rsa-sha256;
	cv=none;
	b=O7c0X1E66pFw/aU1crtWSaIgLuGDeExvGxfHwyTUpYYG2IsRsMNAXq/M5Gg86joEZyuakO
	Tx3t8MUBnLRsguK5WN5vodQiQip/m1B+tC692JW/21i9lBKdo4DyF0pTjXONpH21eNhR3R
	CYaOirnNkYPg83NKLCvYVV5nxzOfpo8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqEI3ZRR;
	spf=pass (imf21.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b9c35bc0aso22483635e9.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 13:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757104477; x=1757709277; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfAilJ2gxaTlTEXjw4cUYBqev2DLfb4NtdyYplV2cLk=;
        b=AqEI3ZRRUeBYe31yTHE7S9y9fpbNPXYgybRGkLia4iGskEk9suSDOnSkH5gzQFSW7K
         vnvbilu2MaTBDVlDNSPXH9upn5nMUh3biPvHJGp2betH0zTksdHt/bvI1Id7NC8MzMQO
         kLPCaNTDbbHYCCSQBw2Anr/5ADp2vDF4tx9BxI3O7dNbpPVTKb+FGeUfLu62v45dqFSh
         jhrq4DC5/CYYViTzC3ugxrK3+uii2Md80pDoXrtakKg4A/XRqHekjHRXUdnalIYgwfcq
         cYfP5Yim1NRLU5o296XJ1bUuuPDOjmLcABynXu8wF5iUiEJdiYrLobVPbAiMpztC/ZmY
         klwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757104477; x=1757709277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfAilJ2gxaTlTEXjw4cUYBqev2DLfb4NtdyYplV2cLk=;
        b=hKmUCmIO5GYQZnP1w5CWDLQKtWokL7fmIluGlj9Qh1XezImQBBctG5NvRzYI8S2B8c
         TO7mQ1qs3uToA3xpB4M5BbxcIKLTKPYhsKPCC2J6DBgujV47DGHp/7DL5BjxBjhYmUjs
         77gmebAEA0UdYEwOX+MNamoUEJdCmQlnXy6UzywqolgzR66/HEtkbm51Cd3FRrflCMVB
         h9dK7ucnlbNA334/jc80vM/IEEm9hQQkkq5nU7Tg+e1DEPTiQKPTQXpWS65DskB6f+Bm
         KFJRUIb5dpY4AkExdVYIyzWWKqGLAloF3YPDFbm5Ju9QknFQfuiPOAUboHY4ZYndaf1n
         nhww==
X-Forwarded-Encrypted: i=1; AJvYcCVDhf5Z7XW5e2wVPhBZh/5C7KAhYI2vpR7n6d+566pB0oX8+yIUKC3Nc8g12Gymd4wFnvepMbDrBw==@kvack.org
X-Gm-Message-State: AOJu0YyEq5uRV0HpHdUN0x+r8/+f4+OSsn2KdsFmpnUwZ5u389QGEVZR
	6chXnApGsjh0QJlN1bmiX/y66OnGISn0JqIbF7ihohkQy43av9VZ7nGg22BYXuJ4NTFSipJDD5a
	+lAPB+YkL5jl7or6vTgFOAD2LtKD6/04=
X-Gm-Gg: ASbGncvpMJnPp9fQbgwXAcmEYVts9lyvEVohJAKVO0VvX+zHw+zDPwlZF8jF4JZAtCh
	jQAdTFw/c5+Yk8kBZyXT6XQLrKj3iVLZV/qDceYkLkvd7NHshkxzoD7a6Z2qaMVD4mMUTxvti4T
	pEhEYbnXA8h6+zPDOahQgQdp4xT4ZK4A9MowYVZwd+9XZgb/5UqzD/9honI64R0K4Z6RV1t0TJz
	YRFUBw=
X-Google-Smtp-Source: AGHT+IHAHVwclBpybbHsJm/2lJguUcGowceRU+Er1bB8qLNDR1sjTRVlcevgD13lm8TELeXUorSoWEH8Q8YTbd86dPY=
X-Received: by 2002:a05:600c:1991:b0:45d:d6fc:24ec with SMTP id
 5b1f17b1804b1-45ddde8a579mr1347145e9.1.1757104477218; Fri, 05 Sep 2025
 13:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
In-Reply-To: <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Sep 2025 22:34:26 +0200
X-Gm-Features: Ac12FXx365TCqrnAMDPozsjaxIlbZS7cS1EckX64FuOxYCiii9Ap4uOCa5qcCQw
Message-ID: <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Baoquan He <bhe@redhat.com>, snovitoll@gmail.com
Cc: glider@google.com, dvyukov@google.com, elver@google.com, 
	linux-mm@kvack.org, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E51261C0008
X-Stat-Signature: 65bnjan3spu3g9poh6xnew16kb6ed3cz
X-HE-Tag: 1757104478-806056
X-HE-Meta: U2FsdGVkX18PnT2ra2KbPbaaAW2B8rL1dZtH4hPubE5yUaHdkUw2BDeW/m463qMrjSQwDgv7atg3xTah/ujClL15jpjwAjGOYCIzjmB2fnP7m8lhv7soH/E/SHix3Or7zZlHtt3nGKsoGd4337m23awtmAfnxFDlS8dpFBeAQl+Occ6dVtWi7O7+LxivNVdmBNXJ+2zh/4GD0ABdS8g4HnQxM4a+EjOtIxvGYY50X3XwzCnXAsQWAZIJjYg02UWfiHUM99nO7lfftcgzIeYwHrBoecNgT4KTCVDHIB58M7Dnnue3oWYL33roOgp0yErZ3Ig8GKAojqktlt8u2Ae5H+4VJCVpYWL3cZb8bnxGB6uBBU1Ls/cDprXeGr2uZjNbEg2St1qSBPbN/PFmy1IDDcN8cRs3+5o/LFdopiEpZkaGImdwYv3gAy9d3O37SYo0ILveCckokSedY5ZrCWBMZ0jUpkMhu8JRcdxIMnhMeN7PqpEPYFfx34DrhgKKEzczRXITec1+5KHDdfHY1l2IMDMo1MuwjqjOjtTWMpJFmFTNkjzWt16v0fOUyCaQJwdVetHQBSNvT7HrM+PPQxuMwjuZiq35lhiIQFZngXsFA8oNKR15tSHzIkPywFf+IeUoJB7ExPYMweiXEcEpN+VSyX6kAbBbTyj4dZxY+wi/nHgYvOVe/Dvk6X7Zn8Ec3/73gmygScWKrlsOH4+jHWlwLbHvnUfxPaw8f+cxusqc+uMNt3xfkxjkdnGQCqvDrI7YzbFlXcjkC/ZDMSdHkLSPRfNDLsOU6a4Y6vRmNdIChGqi0Irt00oXJOlyB6qokMRH6kLKKz8dAfTiPsVjQ2jnUgYYrUWMKxazCaHGMMzh3xOnj7tNWCkKQsIuSUqspjxG0C2Nk2iHk3kuZWJ81Xq4pBkDNNvaDo3STFe5YiSLNCAfjXdJ2j7fTEqeigiSrgjXM3IRNMCTskUKmRPDf3+
 UoxFFnRI
 UGnjNc3kxxpXQZkbiu3+teuhj8co2cDcOmn1H52FY0G0zRIz5JAoL5XPA9ov6Df4i5sQcAxfwjYpDEJLVKMgfvfwhDpv0g+sYDxrI7/4wRAQExyhDLrqegP2QfTJlE2TlYrHL+ValFtrCQU0M7fl+CCGhv7jybX6SCiNDhNfZUQ7M8Zu5TDMiE6LmNZLkusw7WWEg6UV1fg05y25V9m5l61ld3RleIap9wNpLXAgalM3ZFdgMy/ULC2TBoYKojwK4idMAAhwPiZihBy3yMg/OplnZXA/KwqFFySaIdLUCdzUv3YuS7lMNl2aZdeQ8MuudK7mc7NDrds/364+mR/jlKGJ81S1GpztK72ZfjmtIYbVgIwijun2/lr5qP19oACet2m9/67xQ/9MkaRdwO4I2evKg8F3hCot927ZNRbNsPq83cQMiJTpL9SwtFS+d13Bllbeb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 7:12=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail.=
com> wrote:
>
> > But have you tried running kasan=3Doff + CONFIG_KASAN_STACK=3Dy +
> > CONFIG_VMAP_STACK=3Dy (+ CONFIG_KASAN_VMALLOC=3Dy)? I would expect this
> > should causes crashes, as the early shadow is mapped as read-only and
> > the inline stack instrumentation will try writing into it (or do the
> > writes into the early shadow somehow get ignored?..).
>
> It's not read-only, otherwise we would crash very early before full shado=
w
> setup and won't be able to boot at all. So writes still happen, and shado=
w
> checked, but reports are disabled.
>
> So the patchset should work, but it's a little bit odd feature. With kasa=
n=3Doff we still
> pay x2-x3 performance penalty of compiler instrumentation and get nothing=
 in return.
> So the usecase for this is if you don't want to compile and manage additi=
onal kernel binary
> (with CONFIG_KASAN=3Dn) and don't care about performance at all.

Ack. So kasan=3Doff would work but it's only benefit would be to avoid
the RAM overhead.

Baoquan, I'd be in favor of implementing kasan.vmalloc=3Doff instead of
kasan=3Doff. This seems to both (almost) solve the RAM overhead problem
you're having (AFAIU) and also seems like a useful feature on its own
(similar to CONFIG_KASAN_VMALLOC=3Dn but via command-line). The patches
to support kasan.vmalloc=3Doff should also be orthogonal to the
Sabyrzhan's series.

If you feel strongly that the ~1/8th RAM overhead (coming from the
physmap shadow and the slab redzones) is still unacceptable for your
use case (noting that the performance overhead (and the constant
silent detection of false-positive bugs) would still be there), I
think you can proceed with your series (unless someone else is
against).

I also now get what you meant that with your patches for the kasan=3Doff
support, Sabyrzhan's CONFIG_ARCH_DEFER_KASAN would not be required
anymore: as every architecture would need a kasan_enabled() check,
every architecture would effectively need the CONFIG_ARCH_DEFER_KASAN
functionality (i.e. the static key to switch off KASAN).

Nevertheless, I still like the unification of the static keys usage
and the KASAN initialization calls that the Sabyrzhan's series
introduces, so I would propose to rebase your patches on top of his
(even though you would remove CONFIG_ARCH_DEFER_KASAN, but that seems
like a simple change) or pick out the related parts from his patches
(but this might not be the best approach in case someone discovers a
reason why kasan=3Doff is a bad idea and we need to abandon the
kasan=3Doff series).

