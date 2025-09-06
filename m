Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1C3CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 13:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A1F6B0005; Sat,  6 Sep 2025 09:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2323A6B0006; Sat,  6 Sep 2025 09:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126908E0002; Sat,  6 Sep 2025 09:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFEA66B0005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 09:25:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65F4013A984
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:25:30 +0000 (UTC)
X-FDA: 83858897220.25.E997CDD
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C38FA0010
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:25:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S6SNW2MC;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757165128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VE+Mx/TU7aQIVb363hbvW+WQvMnqT6BMcQeprM6OFYE=;
	b=8g/Ld7/Ths6lFBWOyVlg4V99IctQTSQdMRhGCC7x+mXbYGTqmZCHFtkmiOraSMUbszn2E3
	uAAngbR/cUbpC9sugKRqPIzKVLcPSFDF+eX1wKzIz+3e6LzYCOIIolmC5krJSnbigs1fuk
	olwfic5vjSP+lElnvGQH3r1zedXV4bI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S6SNW2MC;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757165128; a=rsa-sha256;
	cv=none;
	b=VnCDKM0+7DFXDlkYvSUoPVXvMpvKPU0dVKGjWZNIr1gAMIDV8YEh1n/CqWI1oy/76Ap5Tz
	hHkZQMRLBD7hrs4OdcD0PJCQM/HL1kYLODHVNvW2rQjVZkIVnmuokGj4PHrf5Y0mxXJElm
	zxVfJKpTNM0HX81+P29IbQVxncDbdI0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dde353b47so1487215e9.3
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 06:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757165127; x=1757769927; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VE+Mx/TU7aQIVb363hbvW+WQvMnqT6BMcQeprM6OFYE=;
        b=S6SNW2MCQSux5/4P8r9UDy+I3QR5N2iBzh9+OQX51ZB8XBNpASf4OKq3iGHZa5qjFl
         +wbqeRwUUaG1X0WPuDYn+XOLN7izYzJaW65AIwRR42Ntis18ywfJf/RarCowQKuqh486
         nJ/15zveCx8/Kx0l41BrGkeGuNXSXeYTARPwmLDPXCKM797uwPWeB2pJkId2GQGGWGPC
         lnHJlpoYfDbdEwz9o8uIBfBPmwzbttmFjvaBIZpBAc9DuhSyJjBK3ruPHMPES4qoXn5o
         dkZJ22UP/l45rW6KrIt5Nr2OILyeC//oYiZA+E2PKNcqKWHZhopITKeyKMCrLDrc+ixk
         6p4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757165127; x=1757769927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VE+Mx/TU7aQIVb363hbvW+WQvMnqT6BMcQeprM6OFYE=;
        b=FqvyW8luTf6FdkITbXgnxFpQWr00nlztiy+fZX/L/vSerKUeEiL7WtG8Pc/jl52c1P
         oYDIVHlHVArsI0+vIJzvEmbxCR44N4oEOm86X/rfY9d8W9fYe1D7rkSUUUU8s7dNMk9Z
         P71eVFTEE1Dwg5psiiYWw9XqftSGa59dt2I/aikQ17VBK9uMqLYJJVanXNcYoIC/I4xr
         CurSYHRS4i7EdcX0UIMqTV+U/sswBaz5VQIhtidU2l+fVKvHQdJ8FErlxV7dZuihdg58
         83q3f65q76R59wuHBkwERsjBbkE04631lV3CpU1DPjKvqBculp9WxkIrIxpN6xGDeoDQ
         aO1g==
X-Forwarded-Encrypted: i=1; AJvYcCXkW7OIWdiqmbsQnUjNPd5DfoQJ9FgTfUe55imG8mHEnSn1y+C2izy8+7GFP5Fc3QBoOJXpkzVFPg==@kvack.org
X-Gm-Message-State: AOJu0Yyp2zWBUA7JFBiK6gfjdPTyl0oxWIKn4VgQh1xfEDNwVHHy5MpR
	P1sa0SyoraLvcdn/VpZVJl945TwNZaL1VoTpddd6V2aOC7PrWPOUOjkwogBXvKdoz3vlqyqVCtG
	zNQuNQ/W8jtHFyxXxRi4FaH6Qr3n6VfA=
X-Gm-Gg: ASbGncv8AJLbBgsz1ghM1SBioUHAdgYORZRWJd8sfS8arSsKVz8LRZ821Pb9ayLSL57
	p1uN0/20mqmuPShjQ4o3z4Zdo0aT8m5cBkpkV/VxygHI0KjpbXgluWGW385Xm+5Utihy/j0HGQH
	ufmhyIUMB48tiitn6//yuamr+8fSs5nJ0F8gKvVBp2LU36R9GrTzP/tW2fElCCcJ2o6nVI+ZdjM
	CIoUBRn
X-Google-Smtp-Source: AGHT+IH7xxFltspr8zCiYexkZxI5yiQn/I8vOs80sqSulDOmiRjBylXmYFVNrCaFsedsn3UnPzIuoip5fBxmKpv09wE=
X-Received: by 2002:a5d:5887:0:b0:3d1:6d7a:ab24 with SMTP id
 ffacd0b85a97d-3e641a6095cmr1198571f8f.17.1757165126529; Sat, 06 Sep 2025
 06:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com> <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
In-Reply-To: <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 15:25:15 +0200
X-Gm-Features: AS18NWDtWolEoXZVKCJMBulXUlUwGez_rwjXq9tKdDHHBjrrgE8FIXbdfmCaUgk
Message-ID: <CA+fCnZf0z526E31AN_NUM-ioaGm+YF2kn02NwGU6-fmki-tkCg@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: glider@google.com, dvyukov@google.com, elver@google.com, 
	linux-mm@kvack.org, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu, Andrey Ryabinin <ryabinin.a.a@gmail.com>, snovitoll@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C38FA0010
X-Stat-Signature: 8aafqedhsjhmow13y67b717guwqomd3d
X-Rspam-User: 
X-HE-Tag: 1757165128-892199
X-HE-Meta: U2FsdGVkX19Epr6f+hkZ6dSDgwY7V0k4YKzbuno6UVYRZ+0qri/QOPMvTqTtZKu9BFxXoejMde2WKrElutBniIRPAGGevepl095YCwWivLdHKJHLk0SEwObJUu9IjaErNSqmYPrWEz9q+PKTWh0+XTlkWkGnxCfI5FK3QIdZ+668DWIRjRct0jrQclHGhZQQUR0tTvJ8/MU7Nr1Rd9rlrG3bJXFnjPelkt+WKA+HNA49bryagr2LbFbMCExF6GGMClQdapibA14XJPiMefi2Nn5JpI8QJeu4SfSR93XtV6zlSt8nmLhQzUN9Fjg2/QGE8fa/wAp/v5eDTqDwSYsaOMAUEhNK55ntWHm/TpoF/zwpIq3WwA0zXgeGF4AOyrq9bZWNwEMu6+/EKex3czEGpgdt2pAvLkppclw9TgR15jbSkx7UPC1YSjtTeHG+RimWGwu3C/gwTC83isqedAX51EySIiyV3MzeIj9cuWBJRxwOMXYBMpALkwBOvfJ9BJFcyA5/nW8WEVSt+IVAC8KKUcqMcwwvpCrNOEcyt5haY1SUo1fV8Emd7wKDytvVrdcPBnwIL9WMb6NqhCQaTYHqOq0VKk7QgastGWUsCq611CTB627tECbtW2giXjSuNmnq92PSbMa6pnWAtKD0VkKObiqrvQPWIPqx9d8yH7igxD1XHFlvVVy4OXm21WZl4Uxs55abRkMXtB2pSOx4HgtrdlYPHUVPKUCCX9c278izxnK7lS1EuKXc4/7RtpqbqtFe/MajPEkWmSJJ6K1DLWd2JLmzTlihYVzVA00OpHD9MQ+dZwagadsBHPaSZ2+mwL/3l/FVGqVUk+gkt5vfUYBsZISQckMH1qRWvU570It3LFn3yL7oABcAioNojfcQ2OyJoyLoyFQWN2ZUHosI/9bBjTB+snuTMSlLs1xsLWOx9HWAr/mGzha6s8uGWrvaH1fx8I3Qu/WL/Rsghp51vt5
 Y/t0A8oA
 8wCX6s43PflrJVVlWL1PrMeXv97WFHPoUDnj6t0Hkrh0ISg1lbtYBOBbL2vl+FwmsjTjE6EdqJLXVhDsFhWXQ+1nS+pPf6TqLCkz1yL5oZbwozzolHV2vnmwoPrqvia83DzBJUOrAXENJh0Q/GbqXlcfCPKXKBZA1aLE8SnYj4Om6AUuiO1yB1jONIPOOm9JPRER6SFKHJMxt4Y4s+D4Sb3owMpnTm6SD76GKOegdX/JOE6rqNwbc4VkIJRJNQ3FTh47DvgR6mY84cj5eqDSpGfNxjdesKel8zLrQn0LC3FX4SBUSneW/oQjWCdrrdEnkcujJE2QFKDETgMk0ribgFC5+ZplyMRcRB8E4oMVTfYGPrl/qW8a55aax2D2HJYHFhxBX0rFakQ5fGW1UcCFlkMvszuFB8J9ilVxut4TsqsN4HhM2mqrXo0IkhqaAUb7pFw8D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 10:34=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> Baoquan, I'd be in favor of implementing kasan.vmalloc=3Doff instead of
> kasan=3Doff. This seems to both (almost) solve the RAM overhead problem
> you're having (AFAIU) and also seems like a useful feature on its own
> (similar to CONFIG_KASAN_VMALLOC=3Dn but via command-line). The patches
> to support kasan.vmalloc=3Doff should also be orthogonal to the
> Sabyrzhan's series.
>
> If you feel strongly that the ~1/8th RAM overhead (coming from the
> physmap shadow and the slab redzones) is still unacceptable for your
> use case (noting that the performance overhead (and the constant
> silent detection of false-positive bugs) would still be there), I
> think you can proceed with your series (unless someone else is
> against).

Hm, just realized that kasan.vmalloc=3Doff would probably break if
CONFIG_VMAP_STACK is enabled: read-only shadow for vmalloc =3D>
read-only shadow for stacks =3D> stack instrumentation will try writing
into read-only shadow and crash.

So I wonder if there's a way to avoid the lazy vmap freeing to deal
with the RAM overhead.

