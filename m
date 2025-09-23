Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60700CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CC38E0015; Tue, 23 Sep 2025 13:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DF48E0001; Tue, 23 Sep 2025 13:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5ED8E0015; Tue, 23 Sep 2025 13:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53CF98E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 263EE58DBA
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:56 +0000 (UTC)
X-FDA: 83921253192.05.E456200
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19183140002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DNezt5lb;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0kx1rTugh76QptF0xZZo2hW1gYb0dlnX+yVu1KHk1w=;
	b=spTCeu+SfA4m2QSaw98x54FFQtTQ89uoK+dfb66XGlRKToHUnsTwxxEdXITYsR5kIVkceJ
	+zVPhSdgGy5rOZ9PUxNeodzj5Eey3sGckAwZZy5k7VXEUA+EYeIs/jAkcoIYmzksaw04YH
	NzPEbBanKt5K3Zs6ufsyT8A5hsjPGBA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DNezt5lb;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758649794; a=rsa-sha256;
	cv=none;
	b=HwEkaqcvx23HBXMzSqnHKwzHRNxWClKgOefcNGHaArNAb1j5Vk+FECCVIPQK5abiMmQDzm
	JN6aZ+WE2nQg6HrzVzn6GiFVayT6Z7kvmfM4LWTEJkLRz+R7tmC9XkTJ5Vye9IBG4/Uv4c
	b1wHQ6u9BXkRr1LMgbohb8JTwIbOtC4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so2928211f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758649793; x=1759254593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0kx1rTugh76QptF0xZZo2hW1gYb0dlnX+yVu1KHk1w=;
        b=DNezt5lb/TKd6ZSFL6EzdQJHAgQrVyY6lIXSNqr9+G5qNyba492oaA95CEvw2os2j0
         2Gpp3GhMdUHtbB1qL15Mghuks3674Rx6o97Xe04Y3A7hDzMD+Fogs2ATeSuf0+mVNNus
         iMUm9PgQUZ96sytvRZbh4uh/K+jf0lkaViHLSm613O7pVFjuCkRy9LYA0H4jqnyMZeVh
         rXe0X+Ott9GDzj+rjeCOavess9/MfwOhqd9FK6zYL4cF4hgzbYw01Xay15yH+viUj9u7
         9GmcAuwx8FbDtkTSz5QKSudURbZwCxm/eRPhRyJRDL1T53gsZXCAp1mzsrxwVsv324iK
         zlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758649793; x=1759254593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O0kx1rTugh76QptF0xZZo2hW1gYb0dlnX+yVu1KHk1w=;
        b=Ho9xFJt0fFqxYc3ddPORMqCHqwCR02BuecGI++noBT54P/HG9kwt3s+Fh9xtltYxaY
         2zKjZpHiAg0OlLYcUi72jyP9zjtt0ywydaso8j6FF39ngeH9vHaNrcBNDMTCMWRVw2KT
         G3uIIYITgYnp8Mcod1aSAMAsyN7XXX6PbAv6gOjiWTz4EC242NI60Hb1Pvo+ZNrULL/9
         UUxAKmHv0EnDoSzuzHid1CEpLWSDoI4EdhMOsKRALbm0viMva8QENRz2dOwu/Uf9ilrK
         gwxtAhODIO+o3Kg8cZT2KXxASohwN8IHl6KLo/Zuo7Z5pp0BOH06OQrIn4PbwhO832ml
         Hpeg==
X-Forwarded-Encrypted: i=1; AJvYcCUdzvmMeEOqbDCRZEKC8XJG48vf6TUAeaVp+DcFj48BuVP+4EEMzUR6QmOP+jRuGn9Q/0Wu8ddpaQ==@kvack.org
X-Gm-Message-State: AOJu0Yxd2TBL4J5o75nOscmoiNQK4xNQD/plRz2YJoQEADuYkLcRV8fH
	JtAmxn00LI4w/hv32tCSXFU2Ef2vRG+fNVjJ0Oj1mGIry3RfRdbgoGB2MIXvYTAPJgrZdfhBktg
	tZ2Qcfdy1mdKL2QAfB/bBUoVCjIxWlnU=
X-Gm-Gg: ASbGncs5H1fW8CnS2B8xG6Q3BaLdq/DbDS2JXV7sKpkhmhSUJhDRGim/QetbSS+m6i0
	DBqq7hmI7R1mhzsakbsS1g0Rn75/ZWi8bO5EPNG7ot4yHyNg3yRL6z9SogVTNApqCuL/1k6vUM6
	EU8dxcn5889Nba6+umeFaaE807igna8fUzSNm6HoXY9kQeEr/1OFLZHB7o0XCBgdjpzEJWkaQup
	CtV0ulCwg==
X-Google-Smtp-Source: AGHT+IFDnIr9jURW/iDdf33QbVpq9yGIdz78c5cWwu6hkoK/t2n+HhwmdlTT8qcq2NE/YdgFwsyWNimpCK8U1Bj/+yE=
X-Received: by 2002:a05:6000:200e:b0:3ec:7583:3b76 with SMTP id
 ffacd0b85a97d-405c6847528mr2568370f8f.22.1758649792481; Tue, 23 Sep 2025
 10:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com> <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
In-Reply-To: <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 23 Sep 2025 19:49:40 +0200
X-Gm-Features: AS18NWAnwGHtT4NaZMiBj4LqaLnQFy6R4R90e3R6j2xRpw7zcnqFbVZB-WdaVnM
Message-ID: <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, snovitoll@gmail.com, glider@google.com, 
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 19183140002
X-Stat-Signature: 9z795jnax81no8bti7g9kf3xcj6ybmih
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758649793-863027
X-HE-Meta: U2FsdGVkX18APfVxzWBoZXCApcVkrN39cMt61oEv0/EkkjQDThtZfwdUj5rlCJHNOvOmSZqWGiqiHbXyYKx4zj76da7r/oF8tb4WqXsTPTlDSE/Dpz6jnu4/ohUx1fXfb7oLRK5pLfAXU9/PJGTjxs1u8ZH1FgXQsvSI6DvmNLhbLk6JK6zxSlXWztNdCrWWrdN4TfYMZHDeRpM1GJlo1Hf5lcuHmalk5HYLiCZm1KDLlUxSrM2umfCjq/7leF89AsohuJrFjEBBlRdMrmTYeHvZt8fb77cB7yCnhSVhK1mGY0/soDyGrr3Egaz46ZJrcydnYl3huTVoaQbh6uST1GxknVb51zxIParqhcxgJ1jpLxPehkpYPtKIUspuPq64GODfI0CaOdl14sARHfuWZAMcvpdpG+RtR6WMIMNdj1RRcreUiWOg33yMUaAw2YffiajAegiUButOTsdJL8Ey5F7dV8+Oz5+oBLhWKbX4n9Hh1xtVTXNk2ZIjpT2kf/+IbXxiCpBJBppmd5cC2VeDjfCQL36YPxNbPdYPkJsvcoxc2+L3OSJ1VfHQh6238hb1tal5S8f+n9CkYjduGISgcNyEljyESFjbUxZ+bNZGLlbDtkiY/Gslm7NlVLgmHzCJxh37jwXk76c4KQVvCuqhqjsDh/ZWvZi3vSc9Z2ZD90Y32ECCJEf2+bhxTWGWarwCJmicfU8Yhk13cFZXber60pqIwFHkIK8Iwht3X5gZ6tXagxYL2pBwZvmZ1nS3TRCR2Qkbl3fH9snrD12PL5KieSyQp7BkeIMjrXmK2HT3WJu1LyQVkKVRpZng5pLkt/D9LeFe7jEe3Bq2o3Wk4HQNIHoeL+WnjynYbmGjVjc6+cun5lx3O/U7eO3njs7BN+iqsDbHqL7ohkheDnLg5w2oUWN5bhNP7br9Sded7tYnB0T5Sf4Sadw8cW1fuN1EsILz5m5KTKHWKFM8Nq/OysD
 2fsLs8Vs
 z9QZSb2b5monfwcUIdXM2ZFFkpRlM4HQtKucIZWGo7OegTJRatrLaXSHeLg+CKR8NguApSP7ijRyvQZGVPJf6Aecv7D6qPLzmI7xpB1PKKLhOkactQpQPtPlsZzfSxoQcZz9w4NKO4KTdSv0pfjAUXJkEi+P0o9E6GHQsYb66Q7KCAGJgdWArsGxIuGRGnQErNiLlQ+dCs+v4x9mwcsml8fmd7Corx6yIX7TukWVtKVLyVvg8Ey7ieCdtVGhNVnAAGyhtRjo1xIwO0n9dCoUDdI0lX/gEdwksoLoeB5LKEBRUi2eiFPy7cvdJueoNpodLXj/B7T+O0Mwf8Zy8AgZ4jMwGB6HOY7Myl2BNQNGKzFDEqUQcv3DYApvi9Mk6ua7sVLielOQuzQZsmBpTQbWfWKKR1nEovTXsA8GdmlWjr8h3SVFb6V7tgAW6MukmN+wJDfGvbPkl6+Sbfk/eXEjaodEZIZNbeDlhn716
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:05=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> > If you feel strongly that the ~1/8th RAM overhead (coming from the
> > physmap shadow and the slab redzones) is still unacceptable for your
> > use case (noting that the performance overhead (and the constant
> > silent detection of false-positive bugs) would still be there), I
> > think you can proceed with your series (unless someone else is
> > against).
>
> Yeah, that would be great if we can also avoid any not needed memory
> consumption for kdump.

Ack. Let's add support for kasan=3Doff then.

But please describe it in detail in the KASAN documentation.

[...]

> When I made patch and posted, I didn't see Sabyrzhan's patches because I
> usually don't go through mm mailing list. If I saw his patch earlier, I
> would have suggested him to solve this at the same time.
>
> About Sabyrzhan's patch sereis, I have picked up part of his patches and
> credit the author to Sabyrzhan in below patchset.
>
> [PATCH 0/4] mm/kasan: remove kasan_arch_is_ready()
> https://lore.kernel.org/all/20250812130933.71593-1-bhe@redhat.com/T/#u
>
> About reposting of this series, do you think which one is preferred:
>
> 1) Firstly merge Sabyrzhan's patch series, I reverted them and apply for
>    my patchset.
>
> 2) Credit the author of patch 1,2,3 of this patch series to Sabyrzhan
>    too as below, because Sabyrzhan do the unification of the static keys
>    usage and the KASAN initialization calls earlier:

Since the Sabyrzhan's patches are already in mm-stable (and I assume
will be merged during the next merge window), just rebase your changes
on top.

But also note that Sabyrzhan is planning to move out the
kasan_enabled() checks into include/linux/kasan.h (which is a clean-up
I would have also asked you to do with the kasan=3Doff patches), so
maybe you should sync up with him wrt these changes.

Thanks!

