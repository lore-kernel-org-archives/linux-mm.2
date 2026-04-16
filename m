Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF345F8A15D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A2E6B0005; Thu, 16 Apr 2026 07:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221866B0089; Thu, 16 Apr 2026 07:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1384C6B008A; Thu, 16 Apr 2026 07:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02B9C6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:22:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91E26C2A46
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:22:17 +0000 (UTC)
X-FDA: 84664180314.11.545B5ED
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8704640003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:22:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776338535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AptjVPQ97g683jPGYCmYUacoTRTAG/3/TQY5t1TSdkk=;
	b=tmG5xtlB9lC8MRGBlCbH4gfbGXrpJn23Z1WEINdbN1xJihA0JosR6IqCEIYNtu8tR8Eky2
	TruN6Hp6XziH2HnMMQbdyu6veMdHb97M2FJrMC2pRmhLVUl305p2GII6NwtYgmEp6r0BtT
	3YaQYkXfsQyY64a2pVh7pAdjmVitRKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776338535; a=rsa-sha256;
	cv=none;
	b=fvg9azDY/u41hS8ETanDUJhD1vQ6Tux0QxY6mlYCGn+jjGAavdDEbWGHtJSrFUN1ALP50T
	X/znDC/jF2WvIJ7QKZXhtQ925KF9QYUJgqrWYgFa1CW7vFtwY9ff6bitYM7ItZ403HADWv
	zHoo2Voop7K44jF7ifJDNBz4ZcYBlT8=
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-956948531a1so1257792241.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338534; x=1776943334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AptjVPQ97g683jPGYCmYUacoTRTAG/3/TQY5t1TSdkk=;
        b=U/MQZ/YIFgKp5dKkC9Yutnr5DRabW31QQMrDCy0u0Scb0tarrUnNAPDrFpzZPo+Laf
         jmlyHyBwbEC/rOdnRoagE118rGbWrFtCseZ2OLmiIOMmThsRWEiEE/8xgLZjGeSWLBq1
         2iY1ZBvY2XqH9dm6QoT2jKyY8OcDbmrCbvKAri/Ky6GD7Ac400kyBQ3JFqGSSaAHHjeH
         Dwx5Umj/RANnlCx7g3ZsgKVtnP9dXuHxaVUyd7PnsFBRM2tnCf8EFvhfFaOSXBBXLLu3
         +CqnJIgiQLL0h48+Ar3toesLEDz2zFKLHnbJTt7G3x5cOZHkD8f0mJQZvbgI9XRNmofH
         u26Q==
X-Forwarded-Encrypted: i=1; AFNElJ/zBqUmKQHktHSYiKjenoSzqVY60JttiWzOGqjev9xmTv3NmUWhUymOJpD2/hbhtcFBXeolES+iXA==@kvack.org
X-Gm-Message-State: AOJu0YyuAjnqsJLpglm/fEbl20mkJgmMvXV2u7K1gILr0eVH+ptbqHpM
	fzs4y30W7F1y3NOZCZK0H0rC/briV6i5EIFsLLwmqJP0Up10n46h2VVGrIFgZsXr
X-Gm-Gg: AeBDiev1pwXCqVf8B12B1IT9Qwn/Rl8Kln9VNcm1x93YFk5GWCOVri9lZhVBXhQnP9J
	BLg1+8gdld9v89VuWxMivmie2lAOMo0NIbrp/PitH/SSjX8fV9iMrlg/i342MmW3X0T3K0GqX1s
	HemLI/n+cUzF0CkGvz71LEoXs/94dnJG5VMXygyL4VU397GR37yZIIPreL+yshzOZIB27MRzuFz
	Y/wySdi9xMTXRAd5Vd+relvVgrwcd0JbSeR7dQk6gx1+qPRMlURH8tATZGdGpZVxC2/2Sc2DJyI
	evdUzuHtJiMnDZQdLRI/vgDG2Dh9+B62Q/Ls5fEB1gUPM8i23994lVkPwDSoSNQy+eUe0JEfdyX
	T5tLDGYCwsxOZ6XhiyO+IwaCaV8hH/wWI8xUvNJq9/XjqLiBJtq1MPQHrY/WcDi6gTuNuxLX3tY
	l6+EbwXSqZyuT43VyhXFm7Ag9wuseHB35IyxKR+gmUhzSQ7pOrX3QzEUKlEUMYVMF2uP9cGOHwp
	VsF0JG7gW2ydA==
X-Received: by 2002:a05:6102:1512:b0:608:a960:c858 with SMTP id ada2fe7eead31-609ff0c0bbamr9516353137.8.1776338534478;
        Thu, 16 Apr 2026 04:22:14 -0700 (PDT)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com. [209.85.221.179])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-612c9c349bdsm2339155137.0.2026.04.16.04.22.13
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:22:13 -0700 (PDT)
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56a857578a8so3049419e0c.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8lTZUCbI766rrflMSrieKsnGrbQ1ztx9hnKTRbHvp7jkskvSsP6WbxdDwTmAVpkmWrVPnd7VoClQ==@kvack.org
X-Received: by 2002:a05:6122:788:b0:56f:1ed6:1d29 with SMTP id
 71dfb90a1353d-56f3bca6059mr11244615e0c.9.1776338533353; Thu, 16 Apr 2026
 04:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120317.910770161@kernel.org>
In-Reply-To: <20260410120317.910770161@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
X-Gm-Features: AQROBzBwwjc8yd10cT00Tu5Dl2qrCYQStWr3Lcobhh8coMrpPeCH9vhBSNokYJk
Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
Subject: Re: [patch 05/38] treewide: Remove CLOCK_TICK_RATE
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8704640003
X-Stat-Signature: z6ikagahrmta8k7xu6ne951gf3hccupg
X-Rspam-User: 
X-HE-Tag: 1776338535-956561
X-HE-Meta: U2FsdGVkX19Gm/feMU1tnBFOV454+lZ4DbO/5itdtI2WtXBcmuiF/MkvsBtCLystYqG7FqSMUdqlDOhRjAho8D1RqgErrk2b335gR//tTZz/ilDdN/bht//ux60WSRCQbLGW4wG/LavYJv41rMh5cRND5+Vexy3UtLTkYI2K+t4EfIZcNtc94L383vZpYyLVDt1jXVf8iPDVMG2i878gu+GKp5v60LHXDjiJ/JUV+J8Bck7oed0s5wQ7yWX0/23mZE3T6YVJcrCAbFneovYz6/lBUwy0WpiWKJkyqFqOraQizNwW2NTc6dEwd6NMFRA8tWgL1ZirAhLLFDIxPJxtxG+gBesCj/y7TZSeF4HtjOAGu2SD3hgcg6aJW8tZBXKOD6frykwa9aZyat4Bw6S3QpVq2+2Qx9LayPURh4Hz6yFJgaFm/sYAkX8Tol7sv5Cb44YYow7ijMMmUuneBVB2JakX9KBE6puh6euyppRrNaiR2hnDo7+G71LV0vf7fPF0h+I8GgF8xSfxHd35+ffve6pXcVWzV30FW4sZeCVpI6ZfTJGVj4FHdE/3DLQDVSWyOt/IpF101bkp7iFo64T1Oab0DOpiI+VJ1CjIp4GIjpbdhNZx9rQPHFE4AITBx8mCajpV4KTB1eXylP5/GI4q0p6DxR9QsN5R8aF8oD8WUDkymvX6F+o4ogD+oZ/ewGvYcHMOw+tHpjovb9llMavwL41jU8FoYw9FnQ0tHSc4b1R/OJF1yyKYHnNfWcbcU5uv8PHVRFKczdl3ZeiA+L52UnkOYs502CqBsRWD3q6Ri7w/h9VPwUTYz4y+U9O/wOuqRR9ZZazQdzT1fCYY2oVzR1B6uRq3Dj6eg1LhHE59sHR4aPEWI/LJln3NGXNbC6CCcFxMJegJRvNJXIsmLf0SpgpodTjSUDNdjkGVsAP/7ckLWwnsg9P28kiS98SKXrdQIlf1E1X1SEz/VlbQzRz
 xN3Ium/v
 ih5tXa9Lk1AMJLJJDpcUVtFYpdQRuUabezVWrIt/HP/6Twu65HKqXNjiq+z1UcEOG02VlA1ve1LPbzyRk2K2kO5alDVuWieOwRFG9egm+UWDvfHI/XOSVbZehdyHeMpYRq57PgCm8WQ7CG8UmzU3K/5/LuEDWood9TNAL1iOc0fkgnlCLU+hnQHzcTK6fXAE+HKYkaYGmPMu1WnrF/Ic1kRPiQLCu2PexAv3QpS6/kTLDtQlFlHGwW2jlF7phbWQ+jrw9QfMgiOuOd9wQt+gnjxj4bzcOiX1yiugu4UjNn2vU4aCTTZfLiXvnM84Xa439r2NgJkazN2RBqFLbriYkMijn5hOZM+N+SRrm68DAKjkao0t5aDQehu2MTjEySOo9N7UZEJnHR5qq1xDOJIUv5c2pYAiTGQyUwOPLz8ydN2mQuYG3TXaAldO+nSekxVNKXweYvAteMlxyO81TUi2s9cwjJ/7KkDANOuV1AnOTNRQhpILmF/1ZOznsj2StzIGWbue8rOgm1A9RWb+ZGqX9pM+4v/JkM8FYXxoHvV3wkbh2Dtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 at 14:18, Thomas Gleixner <tglx@kernel.org> wrote:
> This has been scheduled for removal more than a decade ago and the comments
> related to it have been dutifully ignored. The last dependencies are gone.
>
> Remove it along with various now empty asm/timex.h files.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h       |   15 ---------------

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

