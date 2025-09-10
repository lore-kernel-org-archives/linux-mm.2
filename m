Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601BBCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7588E000F; Wed, 10 Sep 2025 09:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEBE8E0003; Wed, 10 Sep 2025 09:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4768E000F; Wed, 10 Sep 2025 09:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9978B8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:10:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3774A1A08D1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:10:23 +0000 (UTC)
X-FDA: 83873374326.17.D07B227
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36848C0015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:10:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="uZI/wvQJ";
	spf=pass (imf10.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LsnFE1xI0qQhVi+l6O9JAbITiONruUrWb3tpAPA1P4=;
	b=rxsdIpe0db+U7O85k+1W9kkfXJX9rAgdz6J3g6UXNo7CGSoluaq+UsdC78GRLttSkyjlGd
	Vl6dzSFVJYZW7bs4LqqA+Vecd8OiPXu5iN0A4aqhyqY5I8pNLvUiCPfa9cnO1kPc5n2RQo
	YdIgAdmYClRQg0rwMh88L3U6ZlKOB1s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="uZI/wvQJ";
	spf=pass (imf10.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509821; a=rsa-sha256;
	cv=none;
	b=sucg3PfVtpmFU+3r8cwBhjBJtwkmwnVTjqNGKsHyPVkmM/gbiFH7syPW1oFMVPsq6PRtbG
	xNTlJGF0eABJFC9YrqFoMrqFpxqnjzpY37ASkINtHNxn8CeWAhECvUa/SWD9rjurUhIJNO
	dB6BRaTrc/tW1DcoMcqBhqVk42u+LZ8=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f74c6d316so4222164e87.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757509819; x=1758114619; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LsnFE1xI0qQhVi+l6O9JAbITiONruUrWb3tpAPA1P4=;
        b=uZI/wvQJlYJegfd5a6atyb0rZVsxBF4N4RnOSXiqiqcuQJXlA51iR0IaSN7CCHjWpA
         f59MSL/6gVDlYPemvFpOUUIqCEi42Zsri0EBBn1m30/194msz5yhsMYwNv4qm7b8Nkar
         1ylYibQbUnROBiUtWLRRmcTzpEsuaa/K/B8gtz5Hsp3HoX0MC0NjBOY0Bpezx4+2dGX6
         V+n9DJfo3d1stAoCrlid6tzzit6+HU2pps5pCQ+1GmfWrb5fhPEduq/NJtbCHRALYGZ0
         n0OrBnYaJCmoWbV746erk+86l0SP/6B7iYthGaNrw3yDqQiGK/MBLT6SLGpkVy0l3QGi
         GSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757509819; x=1758114619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LsnFE1xI0qQhVi+l6O9JAbITiONruUrWb3tpAPA1P4=;
        b=Rd4j+QgqhOLZqDeUjd1zZAXsEPl4P1ozJEKaW/RXTOmns3RJXHo0o+a6c4BkhNNgTy
         1RvJvMDpnMYtRCuzz+sYigxDceVSlWjtaunyRN5wYbhZWJw45H8jpNSeJ0FGGooH7+42
         N3nxddsNRLBnkPSXE48J1F15hsNM5BXFBhluYdT4i5W46QFqFp17An+Pnob28o+RgRdA
         GhRfgfVw0fcBzR4/fF9cDtLpymB1PIBmNkRILJbQMgRPh8uP/zEbpEgHrUouEh1jAPpb
         fO2TdKLkoYLqAfEXg4euZ1JNC1kndjCavTPDhBLhOGspC391Q33UQa+SMuXnDDbqgwxd
         /5qg==
X-Forwarded-Encrypted: i=1; AJvYcCW1Lf/B740EqvULO6LYhtmOaE11uk0v7472YRgVHAz3j8fUIdTAqtYMu5ibX0MzdpcMcLRHzX3Wnw==@kvack.org
X-Gm-Message-State: AOJu0Yx0LUrnW6ukxZIykQ5Z5UQbCGvfJ98fd+WgeDROIHtqcdNep9sI
	B5p3Lgjp9Xhbg8+R+nqv9g9fYGEIqjsiRfPTNVgpCnfzre7R8QxSoC32Liw6CkONEJFkPYwioA1
	BaOPu3BYbJGYXUGM+YIt+BIFt/FN0YQwF5/51hStLmA==
X-Gm-Gg: ASbGncvNipiDBKgxKWerKmXwf0Y0dm7ZX75kfqORpB+8TbXgEnlUAb1LXsm/Q6OCc6s
	W1yge1Wn1LlwmZQ5qcEwm8Dnyp+Fvf2RWGo8AsGf64UtoyqUXl86dlyvGgCeGA+VJWY+opfrqFF
	55RF/3VYBmLPxW9wDkJJ7dEdXocmMt33uXQy0teHRvi4+dESmmfh5na5GaDNg9Lp8PBiJ73sp4w
	pbCr9w=
X-Google-Smtp-Source: AGHT+IGgInBj1Ic/f5mZf9DHaSimxT6oABg1gWpLpcYCM/ousRHHwwGjp7S7ZCbmXiMiFXeqAGANnBbsml0uYfwnmj8=
X-Received: by 2002:a05:6512:39cc:b0:55f:47a9:7d33 with SMTP id
 2adb3069b0e04-5626425ccd6mr5952206e87.44.1757509818943; Wed, 10 Sep 2025
 06:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 10 Sep 2025 15:10:05 +0200
X-Gm-Features: Ac12FXx4fqtngzlb3aPI-q1c6xVbomqK3jaNECwBf_yyF7AQZ2ofNJeHmlxFUVw
Message-ID: <CACRpkdb=E-_6fZ+4mX5FJas9C5Njp3Gwrygs-cAfWNdbP594cw@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, 
	Lucas Stach <l.stach@pengutronix.de>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>, 
	=?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 36848C0015
X-Rspamd-Server: rspam05
X-Stat-Signature: hdncuhsjqw5egif7nis7eqsjusw4eata
X-Rspam-User: 
X-HE-Tag: 1757509820-819580
X-HE-Meta: U2FsdGVkX1/mPFZdlMriTF9NLiKXKB6q4wC+94N/LgXCAO8VYL5iQGfIUEjZUxLm/l5t1gzUYFkVD1GM8S0T3zkQIvkha2fVr5EfMy08xRRvV6uQzMPsWNgZ1Uv85F+QDz7bLLWuVigsFLd7MzZAM8jNntirhgygNI7x23wwck5B9F70lp8NaV3rpbLJZBA/2anb4HvB5FiodYjVYkGk9KcVCUqgTt5ttv0e10OHWhk1dkj2jfgrzUxpFfKvkzUZMSyX60FZS94Bav+B0wxEmm9YcAVxIJqwf15+h1RCFYyBCySLP+eDSWwjPlRTkZrYwywz5K9u89GbruKLncqxV/2caRxMFDxWfOpM7mwBl6uLsqv26jTQyUtnQFucOn27afpAHEmdLGpxAhmKNeBpGxapiSz1ky37BfivPujvHipPaGXRVtWStXOVIflB6XX8pgO2JfZ8H7ejOziqiWQC5zrQ6UaZsIzbw6VpgAYCeJ3w7s4iwxAKYPfJ+4MVccjgHmh++NMa2c+iq8e1K3HPnnRFkhn+R4WAtQw3Qb0z1Yq71qJtyZReIXLBCmlgqT7EuWkOqvb+cjPVJKVuu+qT7qg7919uFI5fiLVuJWQukofjA9mcwGo2D49O43j+bQDaI0LdmQxG51uJuFpFnuWGmyDcA1jknJ0l5QJO165GMqGVJrBmotazsDFSOfHHZ1WE+UP1ciS1ZkvlpckpLf/1y6XkE4S6j3NFwc/jYmGG1qQ9LdE4/SL6N0AUE5iG3WNvp5VrRSlDz873u3a/ZeelxmzhiKO/CPe+2GfGph2SzC/iURU2f2aq2RnWINwbrxNHEbxeeitmtGFyZnJ7v/TYqd1xm5sK6H+KLfZHERg2sSQnjHgAu0W8vHXror4ug9NjnIp+ftLCu246zBO3xdfoua6ikFN/eaTZpg8rSJFL1DFoOiqjOK9HN3ophDk64Ut+BCCmVD3VQQspVLPUnsZ
 WOgNqKzS
 pKG62rUYqMViBr3ifHsSxIcTkY1wfJITIJnGPk/3Y1U6HLR2ShZMy6xZia0g3XJXTEcq8lEypFwmJEuStW5uW0TdUbQQDQ3/K35pr/IYgVwsog8vwegoGqQB7r2+/CYItYvr+55hjfhQxy/HnLncNs51tZk7d8uvCu3XZZR+rnm4it6HqcRht+X5pOWHmu8KzZ4rmez5DIYATrU2CgWQCue9nUd9zXmprOsF9d00I2+jy/ys1ZsGjvtfsEffhkAecviph50y0XTUvNIgIXUSK64AenPlfXgmX+I8Oq9jNh6MJD8w5PNIDb+OwoR/l/nwnKatvE7R+iyx+H1i304RMRwj1eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 11:24=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:

> - ARMv7 machines with 4GB and more exist and keep getting
>   kernel upgrades, but to my knowledge are not in production any
>   more. These are mainly 2010-2015 era chips based on rare
>   out-of-order cores like A15, A17 or PJ4 that were designed for
>   low-end servers, chromebooks and network equipment but replaced
>   with 64-bit chips shortly after. We had planned to bring a
>   CONFIG_VMSPLIT_4G_4G option to ARMv7VE to keep supporting the full
>   memory at a performance penalty, but currently have no plan to
>   finish this (volunteers welcome).

I'll fill in on the details on that, because I tried, to the best of my
ability to prototype this but I failed, so far.

Here is what I managed to do:

1. Building on another rough prototype by Afzal Mohammed, I managed
to compile the ARM32 kernel into the VMALLOC area, this works
fine and here are the patches:
https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git=
/log/?h=3Dkernel-in-vmalloc-v6.10-rc1

This is is done so that we can unmap *most* of the kernel
memory but *keep* the VMALLOC area, so that e.g. exceptions
can still execute and save to stack when they occur, and we can
call into the kernel to execute said exceptions.

This in practice means the area 0xf1000000-0xffffffff
which also includes the high exception vectors that must for
natural reasons also be kept in the mapping.
What we have mapped today (all of the time) is
0xc0000000-0xffffffff.

A minimal 256 MB mapping from 0xf0000000-0xffffffff
should be able to cover this.

So when we are talking about a 4G/4G split we are talking
about (4G-256MB)/(4GB-256MB) split to be exact,
we would keep the bottom 256 MB.

2. On top of this I tried to decouple kernelspace and userspace
allocations, in essence making anything outside vmalloc invisible to
userspace by unmapping it using the fact that ARM32 (LPAE) has
two separate translation table base registers: one for kernelspace
and one for userspace.

Step 2 makes sense because we know the reverse can work:
PAN (privileged access never) makes userspace memory
inaccessible from kernelspace unless explicitly requested and
that works fine already, and we implemented it for LPAE
with similar trickery, see commit 7af5b901e847.

It's harder than it looks though and I never got it to fly, but
maybe I will try again. My patches is a mess but I am a bit
smarter now due to reoccurring MM-related work.

Yours,
Linus Walleij

