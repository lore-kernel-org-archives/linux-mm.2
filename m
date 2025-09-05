Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899CBCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 08:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BD68E0009; Fri,  5 Sep 2025 04:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3718E0001; Fri,  5 Sep 2025 04:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8C08E0009; Fri,  5 Sep 2025 04:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 697B98E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:46:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA4331A05FD
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:46:26 +0000 (UTC)
X-FDA: 83854565172.29.AD2C84C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id E79451A0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:46:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a+GoP7tf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757061985; a=rsa-sha256;
	cv=none;
	b=bB9+7DYRhRRjfcmOI67dJIqQ5fpVjcEeLt7SMfDLAoC+vByFEYM2TzByVbgo83fDT1AaGB
	tsEKx94Mqk8XyUCrsN0vi3e28lw8bCwo/VtbQeOaFHJmL1W/TnII5041TlAzFvl8y0np3P
	QA2g3Iid3LyrBpIlycVZxnG7Nt7xxyQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a+GoP7tf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757061985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/3us9q7SO3a7mU0skwVqh5PccHM5efYByNeek2KuIo=;
	b=50GrFnQHdWC8a5cmJ+7tjYD58m/bPlrI9TI5m1jHWVypXFqh8GD5aMIQkBSyoM8zdIoFTa
	NqMiuXYKbomaWKl16dxwtMr55QZLFNNadnjHe6i6fhgJeDY6yRLC4vhOqVH/DOgYQuY9Kl
	VskURxpP+f56IWiJZ8J0tithxAplbPA=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4d118e13a1so1274115a12.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 01:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757061984; x=1757666784; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/3us9q7SO3a7mU0skwVqh5PccHM5efYByNeek2KuIo=;
        b=a+GoP7tfi6lW/dsgXyxgM4Cdc9UA43cESbFBZcq4OpyRiWXym4a26FHvwkOmo+OvuK
         Esh5qR72HjJXxaCI+p7Cj1BazgfhC3hQiGbmrmy0eyhwSYFQSAtCPoltPlwX0Q88yf5D
         6WdAEZaxksc65UQM7Qc2LRfSJ4Tn8ltU3PhWmek3XqT1AdRjLm/iE2hPlhmBKGds5brg
         I4rDCVsljTkzWdyVwr4XGBGCTRBMFkcoaYuTX1wsZ/3F8BtzsADHFlsMXqaHyiXOvH/D
         7Z79lLGRAyJx+LnCXTZTKHOQbUYyabfB1iZB4q/lHhoWUEY+m0avs3ZEw30T3pvPno7g
         MU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757061984; x=1757666784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/3us9q7SO3a7mU0skwVqh5PccHM5efYByNeek2KuIo=;
        b=EglTHQKUVU/FfN8QWEW6lptByudsrV9I8w+4pYAuJFmSd4pWiH4kWnxpGqvdTHJyKi
         9+VPTBkovS3w9heOwiJo8fb88CJIKZBa1zPhh/f0X0eKIdhA6QNWiMXzuqPRZSTRIL+w
         ea8fN/ODhX1z4X65RPZFC0cQnW+onz0Gf1a78lrJ1BnMUNLrNLmkU7PaA+LTV1oTe3ky
         MxjghJU/EQSuZFOLGl5Ihj/P21v8K25XPsPLTZUfSyF+u+wMitfTYoiYy4DuhMDawZym
         /Q1xct0bU3Mu+zs63ObiptlDV595yKmSbwsfkrYNf++Lsgf89e3MSz+S8s0wxSIu1vUQ
         9t5A==
X-Forwarded-Encrypted: i=1; AJvYcCXHUOwGYvNkp83oRc5sVMUWMQi6e3uuTNzJCuddsPrvFarjDHRS8N7or7P+JLevlTu0bATdCcMKEg==@kvack.org
X-Gm-Message-State: AOJu0YxnQHmkjLdh3wAwW704Sc6Og8Mxcz8G8K64u4nnjgJ48fj1aVeR
	4+ydlSAEr3eVbbVgJhPU1O8AW3Kn44AESk6m1CgMersfEdlCGV/dv8xtNh1jFCaHUGuiWEPho70
	+1jdSAvWZws1xu9vo44taYj5+C1R9hcw=
X-Gm-Gg: ASbGncvAOVhaN3F7tUTeLCO0m5TYPxJLSViTERbXnmtHDvB3CJTe2lpAo4+YeRqWe7u
	39wHSwDjipWHB6os7l8xkNCCOK9DL2T35+dQYlis8C5LRfjU+z8Taty5PdaXpqXt7wJKBzeqabK
	EvGywVrsUh9HamN6miJXBAT1orGVycxZ1YHDMhhXHtUaGjDw9VYAZAOv6v9yMgRXAzjh4yLvDKA
	n9vLeK47hxwFfAOWmDmXIc5tFiCus2CHbK7vg==
X-Google-Smtp-Source: AGHT+IEgZ3Eftrkppq1vXGap76yLwC8VeWEdDVcer7sGUvlg3ifsdfCIykIdtTSslNhI1Xh7L4rf7v+2AN+/xauuHq8=
X-Received: by 2002:a17:903:19e5:b0:249:11c3:2db9 with SMTP id
 d9443c01a7336-24944b498a8mr331935075ad.46.1757061983557; Fri, 05 Sep 2025
 01:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
 <20250901164212.460229-2-ethan.w.s.graham@gmail.com> <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
In-Reply-To: <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 5 Sep 2025 10:46:11 +0200
X-Gm-Features: Ac12FXzjiY59pui3__MIUUA0N5euXw0YDQBMc9KrPXFvKz93QZm3lShTvhMy6Y4
Message-ID: <CANgxf6wziVLi5F5ZoF2nwGhoCyLhk5YJ_MBtHaCaGtuzFky_Vw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
To: Alexander Potapenko <glider@google.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E79451A0008
X-Stat-Signature: immbd1puapiwtxbtimo3eaud7c3og3kq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757061984-303419
X-HE-Meta: U2FsdGVkX186Xf5/5e7c84rigkgE+ee/ZZJXPubgSKUvoC2Q2FhE0rmjJf/IVghU4efnzpVsoaDhLEqVTJ7NHINM2Qq6RZ6RbFmWwIddrVsbZC7UVTN6pi1iq8txJFVpgofCLBRxJ7ELz0cLsg7XPNO+wQOKEFLyE+715XPN9yci1ZnW9U4PAq5I0rS58HF/KqBCUSRk/3xuqNWYQ/92XY/p4hZwj5Si9v5330IEI6JRKSsRx2HTOiJeCI75d2daDA7Misnm05Ogyv4/5DJsWzqod9wkbhBXpB2zPKvcbtRAnOx2u8gnM42tzCMyC053zMvIec6sPqxc2lXV0PiAKD52uGuIrWTQnceEh/LOY7YVP8yz5JXMu7tkX5OBFulqv9YiFqP3n2owbYivqx4MFcutZ8HGSVpAToBnwuta3CyCz+ximyxipW7UzM46fppe89naPITnosByd31jPZ3s0HZLZGdg/orN7gIMefN0L/GEVQgxLAvCRhpgz8Mqfu0DF8eutPkMzYRlWmvd7AtFDYQ4MHKRC+ZzKVSK+k2ODAuBJvaF3XRswX7Ya0u5QnlTBLFpq34o2UYXIvfZQXxfDOHUzeXNYPDNmzXT64r6fNa0nUwwe+C+n+EWDca9sMaYkRti83K9CLxathx/mP/MaItcgUiy0ZlUe9o66rqcmw5R1rilTxKSGWykpcAy5iAkm0wLG12TCR5ivUEuNDC8TxLEe6MwXutcv/faH+AZ2w3lPbGh28oZLEuVgvxusHo1rlLjFr9drLk+ipihXBS6nEKbz45iExNwbGzYIi+xIts5JCVeVtm6eUk2iVd/rgmNylaD3pCeGcVjgbM9CWOGNESB4UvahqHmsyMkaQOpVz8I5QlkqouyvLRIE4xdpzeHxXOXC/e42wQeIJVcTXIlsmKWyfOPwYuFQfw4iN3U+LmJ8ePkyGQzK6pA4t0/peqdGcV4/b1IlkfzRwIG3mz
 Xfacno+L
 Bp5oy7UlmJkhfzJZ0fcTRD8dZLf2ygoV2hrg+NhDx4kPbij3+c3rInSL4VlYXvXmVvle3ozSyOm+QEel2YP9S5/SxaxfCDs7BtKZaP5TwzCWTD9QvHTafkcAtdszAAP/2REfRTVI9sYLqczojrnYin34x2EzooFj7nHOUOCoEhaGSIIXV456HXNwYusFrFBx99CrpSxvwiC8YtgwUj8m1TC7qI7ICFU0Jd6+MOD2owx7V75V+zNwUjLzgm93X6std12qPNH2OqSubqS83pb27QDlWyataCL7jB8ETwcPKLmSv/gY8cTHv9LZnb6YlyiVh5AffqZjT0A+ykRfjydj93G9T113JuCR+KC44/NZnz5OsFLrxJng3BPkB4bHTgBJbrjd0CCmxap6INA66fXt4+DJnwbj925lsyoOmMn3ql7+r0KgQKSQ1iGF0RQB2Cf6EvIPzN7rXh0p9TsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 10:33=E2=80=AFAM Alexander Potapenko <glider@google.=
com> wrote:
> > + * - The poisoning of the range only extends up to the last full granu=
le before
> > + *     the end of the range. Any remaining bytes in a final partial gr=
anule are
> > + *     ignored.
>
> Maybe we should require that the end of the range is aligned, as we do
> for e.g. kasan_unpoison()?
> Are there cases in which we want to call it for non-aligned addresses?

It's possible in the current KFuzzTest input format. For example you have
an 8 byte struct with a pointer to a 35-byte string. This results in a payl=
oad:
struct [0: 8), padding [8: 16), string: [16: 51), padding: [51: 59). The
framework will poison the unaligned region [51, 59).

We could enforce that the size of the payload (including all padding) is
a multiple of KASAN_GRANULE_SIZE, thus resulting in padding [51, 64)
at the end of the payload. It makes encoding a bit more complex, but it
may be a good idea to push that complexity up to the user space encoder.

What do you think?

