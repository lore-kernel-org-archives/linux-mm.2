Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9148EC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FA96B0088; Tue, 15 Sep 2026 17:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA7B6B008C; Tue, 15 Sep 2026 17:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770E26B0092; Tue, 15 Sep 2026 17:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47C166B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:37:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFD92140392
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:37:35 +0000 (UTC)
X-FDA: 85217308470.01.8A0AD3D
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5C84180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:37:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="O+1Ub/Ct";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789508253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzDB3zl6ECoCJWFAzT7KlDMa3X+/5EYs8hOVz4qQG+s=;
	b=2JN9R/m6oCxInd5OFXeCvoD8/rAttPw1H+GSUB3Iaa4fvETasyPOY5ovS5efZmo2DJ8ZBE
	FvZc3ARiSQTdfY2cOVVwwV7a5Qgiwecuzeq2r9HltCMDZMkfyQdowb2HHz//OMOBqQVwAC
	qentcBNDVJuGnXU+irBg9wE+AAA/c1Y=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="O+1Ub/Ct";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789508253;
	b=y9voPVxZMO1xkgJ4UDeHau+SauevHXi4zNVofzZ839aNqJYIPCqZKflhRAb+teky/xoZvj
	o3x3mtQ8wYxeTB0FxOVChCjjsw3yC7+kOmu+LCCrqL7ycRnv00+ZVXTY/hu4g4sXoMiWtc
	tvqzR8q5AhOTyDMeDrUmQi8MAhT5d5Q=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so35501cf.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789508253; cv=none;
        d=google.com; s=arc-20260327;
        b=oZ+3BWlpMwWaOWx/Fn/E6a3Sn6wiaF1ACxCjgAcyIxPgRfvQ6nhBt9xv+2a4E+OzXf
         JeyG1/Gxbs1g8XWB3rDMrC55T4HOnAUiAQIqqxUvnNi1ZW79+jR0yWyoivKf3Cpce22/
         iJ7XTFiI5BtQHUlc6XcRPOAU4US0mrgOQfj6tQ/a81UezFd0JO5NwI1unB7kdMKf8NFu
         ffBAHwRwVtCQ7542r57Kv0uDZxSmQUM2fJFixS15CnkmbNH/r0of2YLae7rcZMwvVkMi
         wqbmkoLmfLTzxOdcpat8loJmif6xsueg8QLDop8lnfS3/y/LzxySuID0YAHdvvNiZiwO
         /gOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CzDB3zl6ECoCJWFAzT7KlDMa3X+/5EYs8hOVz4qQG+s=;
        fh=Xe6VtCjA8eVZi2QX7x4UG/nfeqnPT+dLggbewDTV6dc=;
        b=OzC9tUGhHtfloqsXpjOdVsqPQwKx6P7QtKIS9zihOI/eWYvYzLjwhDjgIQM6w45Hbt
         BoynGhFmuB+6I1sB5lDJDmBr6Zwxtc69weHWz4xT2AeuGeLXUmnDf/zPRRLV8FqeyWPy
         Xo1xRWtVM8CBQt9aq4iTG6ng2bNsN/x/LxC61jQdper+uoS76YXCsI+S+amen8ntk69x
         WKZ6V3MrBSV530W/Y1oMSV9E388EhlIjxij0glWX8NbcWKI2tLod4WtLy5/wtB2Fv37T
         xgCW5vH8vFPy/oZiHDd0d6wRnYwbGpnOrVOk1lxgXl+sJEZPGnbfeidzJjyUYtonzTPg
         i4vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789508253; x=1790113053; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CzDB3zl6ECoCJWFAzT7KlDMa3X+/5EYs8hOVz4qQG+s=;
        b=O+1Ub/CtoLxEWCmU7TMiWq/5eIKe+ZIeBhi+MjNESHKlA9CLtykL1Dl8+/zfNM6xj9
         BPJsZJrpUSukt9fy6biW8uzuFtVLdxxY104O2bsSA4WU0RWPYX3g2rJSDa+ia/yBbzck
         f8EvIrNnsR7Dq0SHIsJqIOeZh11sQz6Yim0DDcYSJZQIO6WnpMsBOmlkk+WzKgWAwOAC
         sW0gIJYBw0d5Zts3TuZOIYZ3Dp0hrCUItcN0G+BDY3WkyjouJiiFHHpLNoptatqtySSm
         PJ0t3F3ParLHRTEPvHk3u2a12ExEkKF5J5q4uOwfahPRWJyzHt1ABTx7jD6SmW+Ef4Gm
         xcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789508253; x=1790113053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzDB3zl6ECoCJWFAzT7KlDMa3X+/5EYs8hOVz4qQG+s=;
        b=cuxWSrmjhIW8wcppUdS1AXa7rthWrGGltiWPPFkblLzlTf09Y9RhurLZkcJACu83h0
         DjKUBo+C/WrMAZsSOGsLohSYEZzPSKFa35oS8B/V/qoDthdMe3pAHslI2EaqfD/SsRtE
         o9gbV3kbnczHs4Xd0/CjD7/bRB3XJIo9JtqhXfhqbaqWj8LKtiPudScAgBPj9XKZB39T
         M6yHdsuR/2YJGdwsSjdng2OjwJwc2KqMhePvWtjsJd1DV9NuTpPIeOCMxpzft7NTcfWG
         R0p3nR6vjQVNVa4rpVeAxSQmlNDSa71mfRiAVQX9DI+8hDOC1YZ/O+zB+IJ94qAprg0C
         P/iw==
X-Forwarded-Encrypted: i=1; AKwUvBwX8KQMGTVpltaABkChGwws7UAVWANf0wneF7ydHhxwwMcvJrHdQDTTZpZ8JJ5Df13FGtPgHTeWCA==@kvack.org
X-Gm-Message-State: AFuF++lDfyV0ojhOX51Jj/nGNhRGmaNCo5xtwnQIVwJhjPQOlaWqbSgp
	wGBH3n7tep6MEvnsTuCDJFXzSBv+m228+vEalIf8SDaEWCTfQ8cm5XxylYEC72Z3XHpmXgUbeT7
	EZDGuvLy/EbFIeH+jv5wely7zoGOIV7T4XhMs7nuG
X-Gm-Gg: AYBFou1FScbhb0O4YUhYoDPXzsOWgWcNFF4qYt2c/o8BmnBzIU7TcnkOW8dpkdVuihW
	RXypp3Adzw+5X+ZFkmnKL15r9QRZlXy1LdBorLCpAm+PYSV2BizGEGDXbTAxdETu4syjD7IFgCb
	S+yXeWu0g4m5RCPDiC3z0HD//Etb6bJ1A0b4zK6W90IMeM0jE+obXzkjiuQtU++OW2XqcyHn0eb
	+KfBNY28pwVw8qvQ71Ovvvb7RECnBTvBhRWYA5YsGBUX+donlb2cuvgV8Y9RS5k1NAEVfwih6It
	9dnPp2uyVc9TD9ze3s71Bq0qnz2kvWN39Swqw5Ov8KWv76R+568Vgy/lnwfUc73yk63k4Zh6et2
	uxdz1fbA6Hw==
X-Received: by 2002:a05:622a:1486:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-5324676bdaemr4921571cf.0.1789508252359; Tue, 15 Sep 2026
 14:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260915202404.3568029-1-arnd@kernel.org>
In-Reply-To: <20260915202404.3568029-1-arnd@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 15 Sep 2026 14:37:20 -0700
X-Gm-Features: AcwNN1XQSkg9pE7_xSfbHj0OA8OaBxEwDSWKpD4m_jf9jMzfVYG-cGVZ4qCDltU
Message-ID: <CAJuCfpHmPis4_B8MJWmJ89E-23d6hK2_yXqHqAXizA1coFdOCw@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: avoid implicit padding in uapi
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	Abhishek Bapat <abhishekbapat@google.com>, Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5C84180002
X-Stat-Signature: nocpi3puz3pax99twby53d4u3q6rx3ca
X-Rspam-User: 
X-HE-Tag: 1789508253-796747
X-HE-Meta: U2FsdGVkX1++vn/cK4cF9cHyH/nUA49F9tRizuJvmQbOXEADH2yLZhPN4HkgoA9mEKsR7Eyh/cTZ93PkLLp0qHbHWVcPEHz1gVHinLMuS10uMCs92ts7ZZiaS6bmjLaI1LfXeBzlEUgAFiKBtW8Iluuq5A3Mjd+n1FxP0z5/gOPPQ6V2ywnbF8wByd8NkA+l/FX21cPaMQRpt0hhtxqI6lWIhIb8wer1aJ4fazGdYtvq1R25ekbvM3widosH+H1mQ8jQeoyaWK8cWUnw7Kx5POdPb1SgzU5QcgBpErM+bAg66qo4qkDZZdi6qJYujqtk0phrVtperQnn9J+gvrDoxa7MkLMJBrtIhc3hAv4BxCYB9a8jGOc/YmFpL+/V7+DAMBA1KyfvzaQEE2CroeEOKdChJe2Q/nPPKeJodwlzfwrz8EnWNpudiiMyeJNeoKU4DfxLp4yE+p1tBUNITZILyKbAU5vQ21Ca8zMMQL1igZNb6iB+ZEbSCnsXsJth7P0BFUbFAmO03uSE9g9tUvvhmNnxofSWXyKr4nXsOPZai0e0eci1BdMyTBMDYu3jEu80yANDiY6lPA7CyZb+VZWt0nHE/OZs0Mlb6ciOYUhtU8QwH7Xkl2FMl1W5owPb4QXPrl51PqwnLYFb/MbW8wnjf5gu7qFXd6+OML7jm1f0xXFcfTO2/j6vMsuxWnnkL4TnUAFUynftwaEZ77jj9du1Q0HYYJn5my1gN/9EtFwRZiimrawu0lpQlQbtSIrYGuHlDk8YNyTEXY10P/MvvCq0rws4ZOsjH8xPlZhjfrcJ4twrF5ajdgNthClX3ZOUpdJ4o2hKq2daojMQF7JgE+JlzdRnC6Uo9rxju1ujGJfKpS4B9YYPSeXPM5uQXHD3bVlt8H1yPFMN+4I9Iwz+surwdSef80yFolvRSxPyXJJOzfMSLNqSu9UghC7AICPCowbk2Cef1SwBEyFFAJdHQTL
 zrzYN5Zr
 tHMIuW6pQtNkujTIMtL5D/3DnknLJLqcDp2NH4xsRdCNtQMfqmqUMVI5x/Ge2VR3ZAcQOJ+TO7zBZu5PaztneUaHcndx2jREpzN86lfNgNCim9t5A9SNHxOI2Ah7mPdVHpsIn/siNn6t9eFkGif2qNji9+Rt0boG3BnPdfYnnIaNa5Nlcqfjyc5qIrTEAgRjLYpxo08ESLtFPL47vJzKcFTDQ8hzidB2FP1cVbr1TRK/+ZMgKzM7rdyMzmMNwAJw9bNfJtSYvUtyCg3RVOVHQRgzeJNZeoFKJ6yDrNOKOKxadUMhj0Lyzez2xEJwiIT9v/y0Nv2oavLmUkCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:24=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The impliied padding causes a harmless warning when testing the uapi
> headers with -Wpadded that could in theory indicate incompatibilies or
> data leaks:
>
> ./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to align=
ment boundary with 7 bytes [-Werror=3Dpadded]
>
> The code here is fine, but it's better to make the padding explicit
> and avoid the warning here.
>
> Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

> ---
>  include/uapi/linux/alloc_tag.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index e3ad94444864..7d4618bea043 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,6 +38,7 @@ struct allocinfo_counter {
>         __u64 bytes;
>         __u64 calls;
>         __u8 accurate;
> +       __u8 pad[7];
>  } __attribute__((aligned(8)));
>
>  struct allocinfo_tag_data {
> --
> 2.53.0
>

