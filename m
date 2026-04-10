Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E40ECF459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3286B00A7; Fri, 10 Apr 2026 11:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580176B00AA; Fri, 10 Apr 2026 11:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F046B00C9; Fri, 10 Apr 2026 11:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 379496B00A7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:32:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3339E3272
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:32:14 +0000 (UTC)
X-FDA: 84643037388.06.E160B67
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52E071C0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:32:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=KvdeKf88;
	spf=pass (imf21.hostedemail.com: domain of daniel@0x0f.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775835132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
	b=Ro45PA/0fHbnix1vyeGm2ktA5UIpQhurVU7cIm1VfDQrhNljG9iYwi0lBoJTqdQjZRBBdI
	3zuVcehodU+c9ztjXhyeUX7RmVN5PcAaW7D8X6x5Kn55Hbvo93wMy2i5bzVZSGcGJtsxhZ
	E4oCu5cdUXnz3bD5u7fX0mY0gmkSH5M=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=KvdeKf88;
	spf=pass (imf21.hostedemail.com: domain of daniel@0x0f.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775835132; a=rsa-sha256;
	cv=pass;
	b=v0VyeAe38nri5KEGQ6wrzpnIONS3PcVTeW2CNfKh2Tf1jD9r9/HvjM9TENVeNAisj4oC1f
	joxFuHg4auZXGTeL9glpdoDpoguKsc4Lk7sSqkj1Evb1OGEO+sDsQPUt8DIWnpZikI8J+B
	aHc1EwmyiauNUxeLJxeEUtjk1dDXSg0=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1271257ae53so9590769c88.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775835131; cv=none;
        d=google.com; s=arc-20240605;
        b=FpM6pJhdbEF41tu5TeCDIgGv+xzcjz9iXn3mo+pfY7NqgTV5EnetFpO4Eq85RJdkf/
         RY7nh8HOsUhZPCvuLv+Ecmkbp7NgeLeLTu98oI/oqt4xazWtAJwazqlUCjNuRSzMSjl2
         ELr6hqsU/L09fRY2VW0S4hTOzZ4hiUJI/eTqFj4Gkwa5aSkQqcXmg0fWv0wwOF+JV6uL
         10SVrypxgs0fYviui/6FMduDwGe7UGL1PX/aceDybzHj0x4AuvSst0Dqx3Q8/JvxnX00
         wq78ld1YUM1jFt0/qTG8V8E0B0XxaAMZq+Cc0Zm4OD/R6qZcJFg+3m1J0mA3UkYPLE5F
         cvRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        fh=i4x6rUHlhL5m9PhdYD4lCU9TKSqFDI/ESpdeveFo1VE=;
        b=WLnJLNUBKtvTqeuGU87qeK0Uyl6pQSi6wY7ilzwsdHyyt0ComlhQv0hEJnf4Y8PZgS
         LqLyqnRzkbNZ0pylgTYX2X6f58BFsiU1qoHGlJ5Elwslk3NWHa4o6PGY86KN4CeX6l69
         J6boDI9jtdbP3CestbajGGCCnojKs4lNpC3Cu6L1CHU2Ucm2nvQlHt+FplfirZvt7oEi
         OS8gJFCxzlu64U4/yVVe+iSJX40aI5tH8jw87nAT8c4+T24XFz+XsOt/uu9VMOI6Uaqj
         gmBPtr4hhzNsiYnhr+Y0jVrBiaSKWHETrl19VIOLBWQ0Z9Y6ylxTi5ofTnntMeyqy7Mh
         m7sw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1775835131; x=1776439931; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=KvdeKf88dSFEF1m8H9xJ3rME50rxyM6pohNRv9BV5iaRzMGvTn+cVDexvf6EIWkjnO
         eC77g3kq09qpvfZng2ZdcKwlRer+UGWXxwxEauCXAjWCdcho6t5EDqf8q7XKpwvu6l37
         XVRV0cmvvsfoW1oAtRbx07BE94+vfTKQziSSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775835131; x=1776439931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=ds3szU4GgLckFa9mDY09ScB7eN07oaCiOYyue/HDnT01Nkwzrm8edZMQhr81DbuW10
         T99qEPcbCSTrRjiZ1AN/h22DNZwzfG/lUUUn6tlFry8HHkk68Dd5PKpRhBwqiOzEDgNP
         n7odJKbJkSq0CegzbfVAm6Z4UlPixN3x7H8dafhsdeqw4KBrJ5d/gen6vmy0VBWnuCjG
         MSlOMcTwubNA1O2OKDQyieNBbt40QV6WPwwDLNtjrqDpl/sDGGErvRhwkysbktCR41k1
         qivn9Knl+ViiTPQGpdiqLtt969vTbrHW9fgwE6KfTTxJEtZJV/T86HdG0SSZhi0sUlzT
         gTIg==
X-Forwarded-Encrypted: i=1; AJvYcCXlotcPCcoH2DwYF/mC9loEw/Nkv9Lceg7jhT+kGjarRAOC0WWY/c2YyDVn1TG5CTkcocinlUSzDQ==@kvack.org
X-Gm-Message-State: AOJu0YyxXLMMoBeiVrDwhXLlTubf5gwaEbgiXcHxidSHmHyYoNvulzvy
	LmrTd31JtwvCWu7xS6aQ6slZsUPp3UcLH2oTvhu2ZodATKsn0cYOQV4OieySF6ky6dSmmMofxBr
	wMmo3O+VGgCe3akrhvIUm8c+XZftB/7y0ZFemb0NJwA==
X-Gm-Gg: AeBDievAoW6+PI2p7VtFK/6s1hQGOfocDCK3oim5GBwYHGlYMgWabbMd0/y0YOBat4s
	HjKrlFZOhwAHVbuTIREI6g1x25u1taP+pSPR5LNDn1F+rpBSXuTPas9Q/5yJfCaIUDBj94dd/Zk
	fKiZdX8nYlJXXsqZPFn5QTwsFGpZeXJRDlj7PJFA5hs2c7d/w5ecJekCIYRb0hSAD0lRxEKiRC9
	iAL/B4xX4G3jKoSNAslB8wUb3KHcVddyD4j2XxH5/ZFzJnrtVCuudEhnwYMyV9x/+noYBdM+PPK
	1c5s
X-Received: by 2002:a05:7022:6097:b0:128:ccb7:7fa3 with SMTP id
 a92af1059eb24-12c34f069f8mr2159203c88.34.1775835130696; Fri, 10 Apr 2026
 08:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Sat, 11 Apr 2026 00:31:59 +0900
X-Gm-Features: AQROBzAnX-XEClLFV-qWYFUzCuq4P43sNZviESiWFI1yCPXm2VtVZ2QkaUGJoPY
Message-ID: <CAFr9PXk7qK8-2JWrrfgXHoS9JWTRL+WobLjmAesyCE9VLL8ZyQ@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
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
	loongarch@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 52E071C0005
X-Stat-Signature: qd3chr3cwapyz7xghrekb69thgnt1h6o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775835132-355728
X-HE-Meta: U2FsdGVkX18JO97djDNfTtluVJf5tzkT8QxCV/t60k2mq3DrBxNSEWSK7sEme/Xf2F/Z+z4fNcORDSnSnSx6dsPclBGWv1Dnb3ObFCAwvscK3YtVzQEnMqSR1SRJp1Rqa/w2doBnSl69rpLDzTwohAfpVWxSq4ENd+SA0dOSEiBtkc3SryLdY6TEuXcVN264AV+26m9haIguNuhsTFUmGDryhIGbb5gIZ9OC3gLZIzPZAyw88RdLV7OgTPmsPqWK1v0miVj2e4zZX7rAJa4zNrVGsKvYtpulgd3cIOQ452ZS0kBR3qJg/oL2HX40mvwuH6ZAajAlJW6WaM2d3WNf3gl1QNf87iU8QBJ+N0Xa/DUjPsTzs0CnRoJ5nFMXaYxFi1pzkhUTrAl6D8DKL9pfUb0gLVidASB6sgLl21Aa5Ju90jwAseQVege5G99jWx+Aza5ivgJI1ePB1pxOgs4LjZLVhe8+3x900jaMb3jGbtrgZ4La7cpNLcKWPfLsj/yXBLeK9qeL89ezKWcW3NxeWfJyzDr6hdjoDNxuZD1DExrWs0kEB6YEsf5HZk+dP/mKpUXkPVbfqPBnaUxA5rTDurHV8XLwBp/mZ/WJxEElVi9k4M7crqGzCadd0ZC5eiX7Jz0lqyLsfjO8xKnGbz/r/4wO5NzASSC56yh/RPQpY+P2GPLsuZiVEZINTbk0WJwLMinKbbcjZnJQZHdnI7di8zhN9TCQVowDqtO3H8OccKORItPIxdl8VDylrdfGnAMEO34qFJKAtJPWBSRErhV3P1GuabhrIXjsCI/1vIm/Mg+tYdiTsp80sVmHpBtQJJmkxW7tfVznQ3/6K6+wlStj3LoIJ+UkJZCjTKWz9DU0YA+UR0yCfsBRHA2b4l4Z+sWhj66QQKyQR7+yfei/v8snL1Iv++ELgTXK6dYvjcKpIGU9R9ktZkaHnVtTV61BXJ5o08+uUKq5va4YBIvvD2U
 kz3/Mnv8
 pEj2PvBTNMVjDRED622IH9lJEbOgqwANAxe85yhIbnnSWdB1txszwM4WOhkH2pqeKxsEiM5CnNcFZ6AOiz3VVDdvxBMDvuZPp+1gqGisma2qV2kSMzLe3DA3dXDaqoTJ4yfTgr7Ko/vzfXJ6rwrSQM/NEp+CWI/4Usq1SdDn6hSYjz1uuzZ7zr8rb6XBjz+0mlzgrdhJ9c2VAL7XPfxM3Dojb8bZ+7CcKtvM9y0/0/tgsB8jSMQ8VnlAvw55pPMqdCmfbQ/0l60n1uxliaYUG3f/AlWqTZ8isqftJT2cTnthpWZX+YSDlXlKMBxM2ZBNTVdnqVPJ5GOF/8ROob6vtBUY4Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Fri, 10 Apr 2026 at 21:39, Thomas Gleixner <tglx@kernel.org> wrote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.

I have built and booted this on my Amiga 4000 and it apparently still
works so FWIW:

Tested-by: Daniel Palmer <daniel@thingy.jp>

