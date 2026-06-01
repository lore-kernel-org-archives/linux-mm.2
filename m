Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46341CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A512E6B0429; Mon,  1 Jun 2026 11:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01456B042B; Mon,  1 Jun 2026 11:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F10D6B042C; Mon,  1 Jun 2026 11:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9626B0429
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:40:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41F6612064E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:40:44 +0000 (UTC)
X-FDA: 84831756408.24.97E0270
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02832100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:40:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AuT2zfDz;
	spf=pass (imf14.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780328442;
	b=1GVBz79a8ScSUU6QgpNZUOPf8dZzrQ9YfUFjbEGSL61zanX+ZaoJRu6pMdkaPkIdmVJM/I
	VSF3SDUKliyVoA/XC1fyXrBWaNyV7Jl5q88ytdRMTH0OOLILtNKbUonl5u2cUPF2dMVCNk
	lKMHCQOlMiNSJ9EP5S9tDStG6Qmlq5U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AuT2zfDz;
	spf=pass (imf14.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGitNDR3suWUnLziWsrEM4RRTJi0DQuBElG4O41DuOM=;
	b=7zWnYf8JwB9GMrk/UNKE5esy9eqO4CXtRCLo1aUahj5+RgBf++UO3qS/c1L9q8xSnUXfqe
	NZlgiajU+X+/nTX/2+Ndyn+xXJmlL6zlWX2DkZeg5/K2GXosd24QwfH/0Af336CTEsl9dI
	AQaxzAp7hBgPCBO2uB0/IR3MUrY/tjA=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-687ed9aabb3so6356147a12.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780328440; cv=none;
        d=google.com; s=arc-20240605;
        b=fyy+TRV7hE2CwerjHQotpmFtiLwcoyZ5O3w49lH3ApfTZLseFjZmhFGKMA6g8cgFBk
         Stp+3yiabY9wPIY55eYJ/lYjqiwpiGRSVk4rJN2lm103RRoiVvEYluQMFVVM859vIjwH
         Q5f8BuyeVz05BPB1SksJXnJQS58epH+jnCt3Vg7ARBLuMjCRv1dB3/I6hGajdXNmYRpe
         deFMvTbtIHzonPI4j3jVl2caikrd9J1ctFoFMl6l/1UaIobNoND+h50cSQSQzSv+cDJp
         H72T6YSbaS8Aod5YFcnfcUePACNljdFlrsV3tPWIeiXrZ3eOCIFD+bFIqeOFdMgLjmFq
         KXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yGitNDR3suWUnLziWsrEM4RRTJi0DQuBElG4O41DuOM=;
        fh=u5HHfJB5IP9mAKrEGEK0yNhhJbmTXSPLiKWetAcAOrY=;
        b=XhrRjLoSAyWNyCaGuH4+6VMuicpWb7VQ7H8fXTWyh48vx2+8lResr+NQXdejFCID0o
         /5EGOFwNGZwHkBR9t7JLcIW369sJy+Mms880cMZSrkmWEv1CFRs6X9Eg3Sf9fK7pA/dl
         R5Pgr0kdS/WPp9xcbrUVrhch6B3dlwCVOVB+3rdvNEGYx0gJc3u6hGeIkS+LsE4GF4LW
         D5Mxkc5r/3iziRnYM6dnOvTyawV89f4LqLLS3G9HzwR/moCvMu0wJ7kxAxIkFFGQqU7t
         pk64yZ2BhPzZmvpAgxyMYhQOVp58gMN7yh2CfqWtCs7OpVumETgJSe1lF/B9J1g3OBZU
         nHRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780328440; x=1780933240; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGitNDR3suWUnLziWsrEM4RRTJi0DQuBElG4O41DuOM=;
        b=AuT2zfDzfiOOzI5iigs/GJgGJos++m45Nk3U8kLnuHPhT6Cb2F9SBTi64QId5wxd/J
         0HVLijNN58ZeUsW7cXC3wLgcPGTRXL494Eybd7NBT3F7Hh/ipe6ZoNSPh/yH4igU0LZm
         O4t7z8QAeuSPpv6TceE3C8PhLGwOL+hVo6Y2MBsJv2qEGihLGFgTD/jVDyvMplvKT9Q0
         bBwvuzDTvIPVYjs4fbYoWDHErjVYenTIFMAauQS5sBw3T9RXjsu3knOL3CDzm2XZxit0
         iHHjUMfhMzSBKBWhU37ebh1ZKF8GPvVFKSgd44y8rpTy285VZJ07akuT3Gk283sMo6aX
         jwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780328440; x=1780933240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yGitNDR3suWUnLziWsrEM4RRTJi0DQuBElG4O41DuOM=;
        b=bYKuTylsZl3yqkn4xj9LZwdDfx8UDgElvyGwiWogcnXMUIIUXgsb5o6xP7cR91FWSG
         No0vf9gppq26MoboXlUQjRy0wq0YUgpYeh9RyWavev+gfig80GZEWTxS3tETsBJsy7Rd
         XLE2331Jmatg69ePkaUx3wpJp0XlwZdkRXYlHQn3P48/DDzlPC3ka4rdJYRP1+6BCcth
         4qWaQg5vENswfuyYCiE7JI5cz/PUrKiEBR6WLyfFstlD7G3Y5wZ43Naf4myWrtstv9ga
         Ljxd+gFgUNzEZIwiKWjCZfUBV+k1UbjZoA1t3ooNTgVv56cq/8m+nQEDLX1mSU2fjKUn
         JwBg==
X-Forwarded-Encrypted: i=1; AFNElJ9tlCbYnB0PdYpeQkxq72vAFUXQbTipkdKJpp2761HkcDyKvW2a6O3EAdpYOO8+7fnX3pwnFrrbyg==@kvack.org
X-Gm-Message-State: AOJu0YyWCcE4kVaK4oNxiwGHpJglASTvb1prGOiDnHU0v8iXLz3aXp+i
	xbL9P/5Ut4OcCGmDIWvDLEKgzIQQBVIz/l6ej3vP6qyPChmFExYyvnWVQXP1F7fcz9vb8zF0tRN
	ZctNaV7fcc8IlVhVP5hSDNRgXqNkiP6Q=
X-Gm-Gg: Acq92OHuD15PvKbfzLRh6l9PKU9i3LdfTbfdTZU6IC9bB0fGyvQrJ+7Ma9H57Wtwmfm
	n8VQGPNmlE/vUEIAnw23zZ77F3jing5T8SCwA+NQAlZqrCwfssGV1AGUP80B0YOuzYvwIPYAs+r
	K+/cB+EajyjO/aBOqxUJInZKP7ILWpi8tTNhKeSwJoFTzVViLgPOXSGg7ra5lKeRHnsD5SJ5QNU
	5yVZj/ZuOvgbZZGiLpq7ncJFInOgcgSyAa2gPfYnXaOhBkCnLOgB2lkL4z839yWxXyjDbRfSF7e
	ghEQphTjlb2FH70LDfEjOnxLVnWYQEUiBxTtlBukpNtK0FgqUw==
X-Received: by 2002:a05:6402:321a:b0:67d:6c95:9c8e with SMTP id
 4fb4d7f45d1cf-68c8a27c185mr6210712a12.14.1780328440036; Mon, 01 Jun 2026
 08:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260601055704.167436-1-chizhiling@163.com> <20260601055704.167436-4-chizhiling@163.com>
 <ah2HfH3jJZDiNAQc@casper.infradead.org> <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
 <ah2hszECv05z_Dt7@casper.infradead.org>
In-Reply-To: <ah2hszECv05z_Dt7@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 1 Jun 2026 17:40:28 +0200
X-Gm-Features: AVHnY4IAVx_z6D9Ie4Ky2gR3nWAWMzRl5n77v-Nt4Fr4Nr63r96xqtPbPHht5aY
Message-ID: <CAGudoHFcWFcrJ=Q8XhxzmnYhorka8jXJXMX5RthsAz1Kd_jthA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large zeroing
To: Matthew Wilcox <willy@infradead.org>
Cc: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chi Zhiling <chizhiling@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 02832100009
X-Stat-Signature: htazuy6jq8gx5kpu8eyimfuf895npuqr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780328441-588417
X-HE-Meta: U2FsdGVkX18XzkPUJi6v8SyAuo8JEdStGnPNDsi4lEPgCiP5ymlk+jqIue3WmprxULgcPb037PFQH9vfMzyaFQlXg3l6h+dHqJushaIKC3QDmEdtBUS8J8CUq3NBaZP5pc9XNh8rOeLMIYLion+4ifUnBiVPWHmo+gCzN7rkccFxPt5QgZv5fne8+WF+SpJ4eGbY/3kTcB/5B+en4ZFR0HdtUIsVvHdXs0kvcirRBhM5Oo7hy9SbjL19mdqJUjdb/rnG9aCG+fBigq9iZHYDxIBnmTfwazBG1Vo5pPKHj9McJ0mw9r4Q4O2AUwvERy+Cdo+pzc20AiXcqPo5XFFI5zG59fpXAGZ8o3jlg6MZ3THvnGTzV/BTphZITpwjdNNWI0XkjiTKKX2RTL7bC26nrUX0ROzjsh3EplsSdfJbbQQtPwc+lQAnUrHfbcD0Gq3i4bJ8UUH84fxoMrzSKl62pW+Yrpwrb8hAIonUrqUBU/ks8S0wmp3UDSDv93hc3MzelISbEElOCq3Ze7LXctLQ0r2OKnUXZMcUMG+6Kkjb/O2eyrTU0U/4yOYVU+KHkZKy6dkTDdwyHsHDdqZsp1gjmZonvCcJTTZuly9UQN3guIXRlCIAU+mInBF/YgkA3dJgwtOaxNPaEk1ZVLaTpncHNIG7S51XRR4+vW7Sp5lng6HT909lYbtDzJGfZTc8im+7r5qEbRv2oEYJQCFh2tKQiWOUfWLWbf0mA0lXSUJSmObzSAsRqwv0UVIZDCd5W3JwxBN3gDHZmq6CvyRk6IOceEkE4LkXHKZ7lAeUx5rFxZWqTDpaxul+M8A95BNFCqdy7UKiTz5lDaJOfxMohHVWd/XJrNN4Y+ej3FvZfiGXbSo/WekqBoabytX0z8Ogor9Kru89NJMRm3pmfQbEViVrFH/bRbwKon6qXAC8rTHK6U4wYXb7OKQdbG5hZ/wuZRWxcnaPt07uNkiZKjMmq/V
 DfjX0p4w
 JvXZp+7S9CSHvFKS3DDZKKzc12iIDf8xcdUBZ3CyJTEo04frkAVofQZuMLnk/l2Wjrt7Nfwoza0OmuAoSP/2GKbfJ2jIAc8JRQk74x6sbG0OyKh/vKJEnd67J95p2dsh8vC52lQ69tlZFYL55FCKzcON9mxGTz2SU51yA3arYMY/1bThRILkjFrntn8wXilGPg3dOa6t/eeYBg3qJgB3DnzMbczF0XXS/nIawfYeP13WrmbpSxtH3rLOrjyovDvlEyxPEZOTNvuogJBZjjdlhr4EmOGUjzaDxBlkjTtA2sbikmry45jPN+W1rg6oDZ28xe70LNLN4yKZRA3TEkkRiW6secaNR1RxB5TMbPxy/s5YCQVNw5RYlDWmHppMhkqeGuERMdGWPf2pjoRM48PdDILeBDmEqQREVuehLyJwYTBVubg8MFgLu29xIpct3xLnRI/nBhnOzfm4stIgvESGXFlmYZswx/zYbT1+rYJQRFb7vmyJl8kKTehOrGVhgybGCuBHN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 5:14=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Mon, Jun 01, 2026 at 05:02:01PM +0200, Mateusz Guzik wrote:
> > On Mon, Jun 01, 2026 at 02:22:04PM +0100, Matthew Wilcox wrote:
> > On amd64 some archeology shows the following:
> > 1. 0db7058e8e23e6bb ("x86/clear_user: Make it faster")
> >
> > 2022 vintage, replaces thoroughly terrible 8-byte per-iteration write
> > with rep stos usage
>
> That's a good candidate for fixing this problem.  56a8c8eb1eaf is from
> March 2022 and mentions the slowness of clear_user() on x86.  So a
> commit from May 2022 might have fixed the problem without anyone going
> back to measure and remove the workaround.
>

Ok in that case that's basically settled I think.

> I'd be delighted if somebody tested just this patch.  I'm not really set
> up for performance testing here.
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..112cae9f9e4f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3427,19 +3427,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *=
iocb, struct iov_iter *to)
>                         else
>                                 ret =3D copy_page_to_iter(page, offset, n=
r, to);
>                         folio_put(folio);
> -               } else if (user_backed_iter(to)) {
> -                       /*
> -                        * Copy to user tends to be so well optimized, bu=
t
> -                        * clear_user() not so much, that it is noticeabl=
y
> -                        * faster to copy the zero page instead of cleari=
ng.
> -                        */
> -                       ret =3D copy_page_to_iter(ZERO_PAGE(0), offset, n=
r, to);
>                 } else {
> -                       /*
> -                        * But submitting the same page twice in a row to
> -                        * splice() - or others? - can result in confusio=
n:
> -                        * so don't attempt that optimization on pipes et=
c.
> -                        */
>                         ret =3D iov_iter_zero(nr, to);
>                 }
>

I'm not in position to test myself at the moment. But should someone
be interested and try this on amd64, either make sure you have FSRS or
in the worst case apply this hack which forces rep stosb:

diff --git a/arch/x86/include/asm/uaccess_64.h
b/arch/x86/include/asm/uaccess_64.h
index 20de34cc9aa6..552d1b883579 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -189,8 +189,7 @@ static __always_inline __must_check unsigned long
__clear_user(void __user *addr
         */
        asm volatile(
                "1:\n\t"
-               ALTERNATIVE("rep stosb",
-                           "call rep_stos_alternative",
ALT_NOT(X86_FEATURE_FSRS))
+               "rep stosb\n"
                "2:\n"
               _ASM_EXTABLE_UA(1b, 2b)
               : "+c" (size), "+D" (addr), ASM_CALL_CONSTRAINT

It is always fine to use it from correctness pov. It would cause a
slowdown for any size on old yellers predating Sandy Bridge (that's 14
years now I think?) or for small sizes on CPUs without FSRS. Given
something like 4K I/O that's not a concern.

