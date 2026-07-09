Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6212AC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C896B0092; Thu,  9 Jul 2026 04:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDA06B0093; Thu,  9 Jul 2026 04:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3D36B0095; Thu,  9 Jul 2026 04:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F14386B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:06:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77783C2803
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:06:30 +0000 (UTC)
X-FDA: 84968506140.02.D13DA66
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 871E5140004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:06:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584388;
	b=2HGTL+4HePCNjJQFfiK+1+bYL0RZ2PYjFBSRhkYn1QF1ui3nxQzevKlKtnqn4bAfUr1ZV8
	xCgXV8Qa2FTDZkQtshLJRkLpav/gtRWredJ5Sb0Ra3GdDKuUlGS6F84mjkfXV9zTW83cOn
	0U1vMUtSKx3eledZ0LIFcsPVMnhU8JM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YkvlVZCIdLN8XjZvxxlYwK/+A+2hPQX0zLp+4m2M0g=;
	b=UhbgpNfNcokxmUtMh63Sm9bJCPafF7enJDnlfY//LuwbyzbrVOGeT6+ipnR/H8e4mKN8vp
	AAAAvceeF1MBIaL0CmpaIAsN6XGOBQPsTaTKUiwrlWdBChHqOFjFOW1qCF85UiwkvxwFWp
	xCriRDSRNb3dwOdJO5HqWZDet4mgSHc=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5bdcbb1f3f2so836312e0c.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783584388; x=1784189188;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7YkvlVZCIdLN8XjZvxxlYwK/+A+2hPQX0zLp+4m2M0g=;
        b=Ib/KcBN0qHncyd/EZNkuJJAGenypABSStU6giJ34HSmkpVYdAggf5SGftZupKNzgtz
         plKgNR6nmBYpSpI2eGKMaKsYVQiEMEBd1It+O2TS0Ee1MijS8WsrU2BoMhjeT2UuR/hz
         Brv1xKL5gRKP03j2ojTIhxVNfOzkBd+cwIoqF9GcpEjG9WukhgaHf1+dNww3p/OR5db/
         SiS+cesncIT6HNQWwoDWwX2+4Rb1mg6OMMmaouNeYe3tMffPuM1Bwd/frMqa3y39/JL/
         Rnl6yq7nP/PUvSJlQgboDR49bgCVKuUR87Wnb4IemhWq0lzfNSLXynWiMww13mrd1cLZ
         rsDg==
X-Forwarded-Encrypted: i=1; AHgh+RrqjpS+zOfZD07uflzcKaovJG0T+HWmaOQRNKcy9wTgnenT7nwTVGPzQRo2dDTIHmeH2tKgSzFMdw==@kvack.org
X-Gm-Message-State: AOJu0YwRFd0m3A2LgBamW8xs9Q289PTCaPCBALt2vdZLJ1rSNzt9XvOu
	Yd2yz3eTj1b3zd0BAZKQfm2Agk22XnWBkARsDq3OsfN16oEjgGdYpK8uGFBE/Hnkzh0=
X-Gm-Gg: AfdE7ckfcCGcuvg15RpHO7R2VP4zviBlH5T5LUFB4l2P8R3UYNkdxZk6ClHpfCSg86Y
	6PQ5cyxojmjcQBayqWH4Cetwsk+8tMgg8tA2HY+YUvaFDl3wkgUSbsqDO15hBFj+eNR8pVRNP2B
	pFRfhg85fqYnbJ4fcpO/UhAAfWI4OkOQpVbjIjy3F8akQUqSwa4A3sxiZTNnFTVOJPuW/6Z7AKx
	8llCeC6WRi3sZUjR5Psv502tmQTztArrQtLvxif1EGCCPRvZ0h7TrA3Mzt2E+ssaXYqdxHhDAee
	NKTDVNT3dMlPkxP0A+gvyGZalGmMlvlI6kzKXxFkCch5QF8xIyEdxrvg+SSzEdkZqjNv9NMphTN
	98QXjF9KmGwmIt3+Sln81mafb+bnjlkRskR5wq3MmKlnvt9GDSm7QqTg7+/0fGmVktpoMyZavOL
	eeRmfag+wb7FUBJg1bbprZBG9zKJ33HAySq9u3Ro3W7I5s1hi7vQ==
X-Received: by 2002:a05:6122:8b88:b0:5bd:fc23:c9d1 with SMTP id 71dfb90a1353d-5bf75dafb69mr3601429e0c.6.1783584387723;
        Thu, 09 Jul 2026 01:06:27 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bf6f8f4283sm2951448e0c.17.2026.07.09.01.06.27
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 01:06:27 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-738a5cc517eso1048244137.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:06:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp6qXfVs/R2sp3P2WELRR+hWkxIdwQ81EFPan+hlmqspiGvItfbAer6hO2uMMhO5uKZ5On50NHvMw==@kvack.org
X-Received: by 2002:a05:6102:c47:b0:737:bfe6:3b02 with SMTP id
 ada2fe7eead31-744e0369abemr3833351137.18.1783584387167; Thu, 09 Jul 2026
 01:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org> <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
 <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com> <CAMuHMdXbT_hPnf1msm4exUoEMxRPvU5gmQbzi74b9rk0EopRqg@mail.gmail.com>
In-Reply-To: <CAMuHMdXbT_hPnf1msm4exUoEMxRPvU5gmQbzi74b9rk0EopRqg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 9 Jul 2026 10:06:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXF-DcLjbJjwmZo+pbLQeO9gs+2-+pCnw_DNvS=tZ=4iQ@mail.gmail.com>
X-Gm-Features: AUfX_mxhmsnKVXeQFzsMIkLR_dcANzAHBWL7Y9bbVqeFbQAcvhyyWgbcWozADO8
Message-ID: <CAMuHMdXF-DcLjbJjwmZo+pbLQeO9gs+2-+pCnw_DNvS=tZ=4iQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] tty: amiserial: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 871E5140004
X-Rspam-User: 
X-Stat-Signature: 1agx49dweqgawfqz11i4h8ek9puzzt3a
X-Rspamd-Server: rspam03
X-HE-Tag: 1783584388-605918
X-HE-Meta: U2FsdGVkX1/+bVTjUZCn2T8fpYST7tZeVV13S71NedDnlatsX8ZwznJu1jUFXwtTAqFgD3GGx9rO9B8loQfZu7N7MtXTiNBJbv1hWknigfZi0ZmZY9hf9GZp6zdaUyMLKCRMfGo7K/J+3ekmGIIq51SlR+7s0AcN4h9iqd4gnnp2mlqzoNbmo6vSan12774DoyHDS36A16ic3Oyrn232FShfg7aiOO602KohmK+okinpwxTtPM77LB9gbJoKs0lsrmsqPA4+R7EJ91KIf7056H8FCFdNPmaSRqHWBz3sNO1QYDE/kh1RhzaMad9UUYHPIxSxQ1HXNhrQERxrv0rtH3FRHrRnhCE2YI6siyD4kkfGqJPe+v4Xg+IaGViKs+5oJyx1aWjzPZX81C7WHdFrYnnQcMqfXtq0AYaXdQ22jQ/nCfRMSl/BPjmJblbZCaaIi2UkhCbW1jhWMoQYh8bSPQsrk7EnSMzhCrCZxFccOU4lSx3lKTxV2EXrCs2zPGXyG8wvkZn0pJBWD0CDq68okskTbeEo20zMX8Yu32rU4oxHZ3TkcSK/kYxaSaGEIKzXvQkdZPZUChxTjxZG9O2osilgMnxNdPkntDxaeZjIzXmQSCKRA3YD5CCWlVBHsD43QFJy7y4wHTh60eJr1xwj7XjIilqqkFnKAmesolbYTor8JOgm1KhahSiR1cHJo0CzA9Kdv6bpQVM/K4c0TQIpfPUHlFz0+UvIL8nI40vlm60rVqNOvEpV66Z/eq/9Gfyoh06e35E/pBknFcOUrEaUOvuy8czPqd4ryTDsdVdQ16a+dWBaSI3LOJ2w0dwmv+IbVTmYaLVA8KLC8yyaT49x+U175ICAJXITrSxIngRJNk3RixPjp6W2nHECxZXFOrDV++a4ARBNl6q4G6F+c+njE0kpXa9ygzRLJXfnAsPwAV56F54IifHA1TKWc2MNAi+k8BRvCvZTrU8gEhmRvzo
 N9ISU5lr
 9XbYQm+CgPFnjeAoeW+LtjzRyzKqYpyxJE5m9PRexr8U0zh4hrfV8pg81/NrlXhZgBhRQq7l8+GyApMz6C4Myyp1xGLiyB+W4ycNI+yE7O2vNq31KEvbiX1Q4g/Asx9AQxHBfL8QYjcVFHLonnN19g+VZWMB4p9nf48nvtIhGC6NpScEJDHto2ol1eCLmrCaPiOzhDyiO47xqKnwooYaF6HontoioJp9XCFs2xz9k/wEyVSAxjDOBvluJOCvNK2Bl93ftGnO4hEsC/EWHYLNF7f/0cPEivD6wAWhg407O3CE/vbv1QPG3g0SgaLOMaRvbQ9U+OP6Mxu0P2LNrHOJoWwcpYxyH94r5yeeKnOGYSvFNSLCSniwOpyWX03NlOuwp1puT7aJl4gRFOPOVeTEnnltIPvsvZSwy3W9y824ppnI1H4zKFZmI7RN/ZaXEwwWbLZ/woDQBP4mSl9tpq/M4WtkfcFh7KbnCGjJ6s/01YaZyKz4Pr6zxixviSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 at 10:05, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, 9 Jul 2026 at 10:03, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, 31 May 2026 at 09:04, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> > > rs_startup() allocates a transmit ring buffer that is used to buffer reads
> > > and writes from/to serial data register.
> > >
> > > This buffer can be allocated with kmalloc() as there's nothing special
> > > about it to go directly to the page allocator.
> > >
> > > kmalloc() provides a better API that does not require ugly casts and
> > > kfree() does not need to know the size of the freed object.
> > >
> > > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > > kfree().
> > >
> > > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >
> > Thanks for your patch, which is now commit d26ed502d0c7c05c ("tty:
> > amiserial: replace get_zeroed_page() with kzalloc()") in tty/tty-next
>
> Sorry, I replied to the work version: the applied patch is not this
> v2, or the even newer v3, but v1?

s/work/wrong/, where is my morning coffee?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

