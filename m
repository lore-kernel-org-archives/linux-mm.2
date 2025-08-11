Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6CAC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCC58E0057; Mon, 11 Aug 2025 09:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4508E0045; Mon, 11 Aug 2025 09:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33978E0057; Mon, 11 Aug 2025 09:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1B8D8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:38:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 868F1569FF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:38:47 +0000 (UTC)
X-FDA: 83764581894.06.C16BC6D
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B9F94000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:38:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J4guHVzq;
	spf=pass (imf04.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754919525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBCgH1jXbD8cQk7vL0lpvlc3a5C92LMaThlyJ1yPJn8=;
	b=fSIlvmtm92FqnrYOjX/CRDA6euyUXk3Dz3zqlh6jD8idiDXgiTg+ZVRZnehFaIv8/tCweM
	tvIzZeHp9oLXas8Vrqq6pnnm27YIWYG+6RdkbpZLWTua9T5bEfTKCRJ4Hp22kUPl8pCTP4
	6f48EAAWZnGB9oj4N0pY4+Sj3dyU2Yk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754919525; a=rsa-sha256;
	cv=none;
	b=Y8CgqV38L0wHedFrn4uOy3AyCttU/MeGk3Hq0eT6ejKPaWV8t4Y5GmTMSBc39czy3jlB/+
	Nl6SNjR5chkfdzWNpPE/xpHu1pj6QLSujiA4rJb8AS+Ddvm/iM0C8ipZCDf3/lR/cUwO/2
	5jPCVvIQ0D89m1BvsH0gDRYNzDbWR84=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J4guHVzq;
	spf=pass (imf04.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b7910123a0so4043627f8f.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754919524; x=1755524324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBCgH1jXbD8cQk7vL0lpvlc3a5C92LMaThlyJ1yPJn8=;
        b=J4guHVzqBShG5/4jlKGi8VEp4Kgnnp4MjvNpRhS6/u9YZf5149NMSLv9hJid6IC4/U
         EBKlAR8on72LZ0F1E6zANsCxfmE4hdcIlOIJNSiClufLfsiyiyXCu/x4JKMyfLU/rKgs
         lkQ1asALYTruW5boyT2b35UeI6jLUBixVeJif2YB1VxThWA/YWX5bP1tUdqdKJeyO51+
         WuLHO+hHTFo/Wft9iBqOCoBIFsgBc817aLr16gWk6rmzT58iYwiQ3sOQ9u8SelMuWPeE
         FLzSE9mg4how+Txd3qjXTQPHz+oERZ7RU+aFFeTeHIkt3jH2CDM/BV3rfdFbybqG9ajx
         CFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754919524; x=1755524324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBCgH1jXbD8cQk7vL0lpvlc3a5C92LMaThlyJ1yPJn8=;
        b=R7vLTQt/1nXJvXQJ/JNmKucR5tIj5zpfm8FrGYj4oMGiQFaIWP4pGlxlj0f0CFDr8E
         WUubxOixHtlHd54xBdfX/QDox37i8DrgeCWOhiupfK1avTAArZcI79yh4Qo51x2atB9z
         9y9X1oSLp4lkhKfKMQ08pNzr4LzUcrJRi+3Z5iKjKvJlT3GAsnILosLB9tLGHPPPNAlI
         toPWBV5lzU8j78cCB9cgxirGxPOmHjGzJandnrBCi8ojHgVt9JAoUwUEDImCHa4LvVRD
         ZVfg+wze3W97NWY1ZrMdnUwSdwhAbfZmO2lOcHy0WI2INKNWIp3zBT+TJsJhTs9Ybkmg
         sdPw==
X-Forwarded-Encrypted: i=1; AJvYcCX16/KoYEuBH+bRlna7UWPm7RFhSXypthf2j7KrUWYYTI02tMi8+drwaiYiAY/5ZdjdLBGRLwOa7w==@kvack.org
X-Gm-Message-State: AOJu0YyDYpnAsbQVE6CSZ+o7GlFqPymaoT2fOJgsdqPmHqJhbVRGUSgI
	19ptTHNLF/qDBXGLN8J4SZ5ss97n8/MB4YAS5JSHnmFxC3AEJ9dvMl26EhxsZH0dJ+iMAonYjej
	OyXonvnjprLgG3B58mtRBBjCZNiMR7RU=
X-Gm-Gg: ASbGnctYIFilOZl7ifLxeQzTtzx3aE85vClYEghzHFJfVrFea1u9db3QpHOn3QueHBW
	hWwzOMH8shDIXAYGV0V33VtxbTAVlOFdVDzgAFvk9EBGwvhNUJGHXkpvVdRkEJMAzw50zqkBPi5
	/gxtkUWmIHMhLEkrSxitxQ05lkoXarM/Cd1LgBzrUXSIU8Mi4b6wJQ9/DjAJjm+JDFS3Xyb+e3F
	Eb+OIQV4tCV7CIg
X-Google-Smtp-Source: AGHT+IGxUMxKS3K7mls/h9vXG26wkyVH1sxQQWEW7+ny6/XvX40fc1DRmX5UXk1P2ba82JVPojlxTCApE8OfHIL95wg=
X-Received: by 2002:a5d:5889:0:b0:3b7:90f3:cd8a with SMTP id
 ffacd0b85a97d-3b900b83c9bmr10624691f8f.49.1754919523921; Mon, 11 Aug 2025
 06:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250811034257.154862-1-zhao.xichao@vivo.com>
In-Reply-To: <20250811034257.154862-1-zhao.xichao@vivo.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 11 Aug 2025 15:38:30 +0200
X-Gm-Features: Ac12FXx7kQl8MpZMBlEL69UNklwxkty7tb561BkfRgxFfLERdIDidFrWBBBiqgk
Message-ID: <CA+fCnZf8XVydjMNRfR3JDeE=3i_0p+w0gTP8ep43LVU8k2Tsxw@mail.gmail.com>
Subject: Re: [PATCH] mm: remove unnecessary pointer variables
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9B9F94000B
X-Stat-Signature: 4rshpzefo5qb1iyhyoqk19tuskuz967y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754919525-564469
X-HE-Meta: U2FsdGVkX19fb7ABaio+cDrHoiU2V6QlI2Tzfom1FsbHid7KHZ8Cu83irCeX6kcN2AHhzVMZhymRbE0/KAU86ac2toC4iJ4Zd6p2bKKQwTR1ZxxEdln4Gwuqxcg2gocmET6VMLyHDJq0lVbtCtp7k89viEBM7ebhK98Gvls9D9hxxe67jKrW1O451Kk9euCpaJcnB232lckQN+VfjXj3nLCteCGrA4zRs5OtytvCoX4WIs3XS+ctnQ+mbWb4QuV9fVXzgUjYgFmlvr1P4aHAJSZXCuLnrH5L8OMLYwWAHpNZXerChZW7Mypg3cfUV+typkbHi0q0saMhZLQ0dkCAMzByk0rkqPnTPzNFfnefdfx+UJdqxjMlU2IxUuniXFF3TxVikxpFGkexueDnnrYS8n5BvAMHFz9osAyCFWDg5sxHn2qnqSE2EvdrLEkJB/Pj7/XlNXdlCRdQxL2WoeA/ge/ZJA/2ANcSln3yTCiGGMw+mFdE4Cxf+USglNyn0Zo54oQm0SuivGTClqto05JLgRMK/W3OZiCq97Y5fT9beT+Avi8yd9qKmLPVwwxH1hFZqc+WjGr3d3wLy8lmxKM4SkfSMz5adwS9eDnFmbomTfnHSyXCcDYpb6XkfcQMXpU5O9Rk+hfitWJaEWjqyOQrf+rkSt1V4BPieyQB2IQoMAFYgRFx68f/PKj5Rc9wcHp0/489zBkdCnVuBZQ7D03ugZkatgmET/SXKEOFG0vKWiOFZ9ldjXJniJwUQkdR37mcsPreRfcbeiAJJIJD+lNHeG4rEqgVjpL6eC/yNCzfmtpoj2Po6Aq0hus/xB+VhDJAy+I5voPDoTLA/+BdSGFhoxZgqstsbQgfYMRpZ7YlvT7RlGMQhxkluJExsiAx0zFQ+97UBIX5rp1zimRnnEzp5vBHjDxFCdWHZ2ngUio0R0BLHBveYQK3n/iLeb6Lknaef+7rjPr9jZLY2gSV+z4
 xVHzx+Dm
 YUSdiu2VjAon0vzcOPAe7Ym07hcBcluVpsbA6whOEiOcQpVjA9ew2ed+4mYpLTzX6tTiT6ChCjjptJ4oFbzELP3bYRGQ1lKWkXCBMGV1W36lsT1lCuEtNuIlsE7WCr6uPyXmk4F4OYyT+FU+7QicBQi8gfcQTof3kLtJKEw3yAS6Cr/oioAbrYHOQHS9xfzQBy1k/A3X8tCFkWzHY6xp+oWU/tUtDXWeqdAQ/qdow+qMLCIGej7vgskt8m5/e60WsDB9O//hX/G1BFUw6Nv17ALdnj5CE/duJ42CwobkcCMqfgyZgn7KTbDUHRidc0kNgrQalrmsAXg0f55UaKFF1itoGrjFmD0AdPVbyx4dFVcerCl/aUfqej4j7WHyWqWJ2RTnT/Fy9GlyQzFpPK/MfpBrF23UDF+MgMNDtcgQ9PNCEe8kQlpVYgMxK/epgHEBbBmgtQvdGVd2pnlRis5EIUgjWwP7qrjIYwc0W8wDothRb5gHN64FpkSqCgUz4/C4zNhCG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 5:43=E2=80=AFAM Xichao Zhao <zhao.xichao@vivo.com> =
wrote:
>
> Simplify the code to enhance readability and maintain a consistent
> coding style.
>
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  mm/kasan/init.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index ced6b29fcf76..e5810134813c 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -266,11 +266,9 @@ int __ref kasan_populate_early_shadow(const void *sh=
adow_start,
>                 }
>
>                 if (pgd_none(*pgd)) {
> -                       p4d_t *p;
>
>                         if (slab_is_available()) {
> -                               p =3D p4d_alloc(&init_mm, pgd, addr);
> -                               if (!p)
> +                               if (!p4d_alloc(&init_mm, pgd, addr))
>                                         return -ENOMEM;
>                         } else {
>                                 pgd_populate(&init_mm, pgd,
> --
> 2.34.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

