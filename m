Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B4CCCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 16:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B0F8E0063; Mon, 13 Oct 2025 12:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBEC8E0009; Mon, 13 Oct 2025 12:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC6F8E0063; Mon, 13 Oct 2025 12:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7E928E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:07:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79AE311A4D3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:07:16 +0000 (UTC)
X-FDA: 83993570472.19.EC05927
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D6BB180012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:07:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GJkmKCN5;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760371634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOeuZsdXIkLl0kniBUHtR87t7zPBM315DZT5nopWqFw=;
	b=EiuMI07/mWPpJbD/vhAq1muIykXHAvPj2+WfVcTNOYvKBXkERq637t83AeiqlOAxye/CDf
	FjcpoQx9bwZ0WYobUB7SYd7tMMDqYcaBQAPwcXBXVkivTloJawGkxQmAi9hSAyuek6zMOL
	rMGpUe9VgO78gDdLgFgTR/q0RPOT37U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760371634; a=rsa-sha256;
	cv=none;
	b=OOaW4HSyoEITcBdz4asVimUAWo+qvlGfMFhVx4jXGz7zP4nxCp7kmymlL8UXpPRKsn5sAV
	vbH7WXntGBxmbURa9Gtp8vMH30zSUkMyShLBR6A/ENYObHnLeuIgbpDwLaCsJAbfFul2b7
	L1Y07k6v5C7RyNbMbtaDYR+8ftKlH2A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GJkmKCN5;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3e9d633b78so807652666b.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760371632; x=1760976432; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hOeuZsdXIkLl0kniBUHtR87t7zPBM315DZT5nopWqFw=;
        b=GJkmKCN5cHVyn1+5W40YWotxF9lbcx1IcVmoZP6DaX1UBRV4fjleL66C8ONvWSDB8r
         zl+khdF9Rv4GvEWzxFyrXnmNUCSIdxgGhhs7PVqrfw2/ixmkVEDIBC3a1oVWVi7dy7Jw
         wwCb8Jq0oZtmf73+G13lsjn3WFPrLzSY+mQAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760371632; x=1760976432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOeuZsdXIkLl0kniBUHtR87t7zPBM315DZT5nopWqFw=;
        b=iUHpHbrb0NtBtv7NdhjIvhawJ/npUlVCab8SC8bwczQ9+W9vvdVLRFhXq4O8bFuw+b
         CFNOh63+YmeFYOfl6NKddrcI8X7fpekiuRVyA7gJaHf3WmDFvYgAx8D5pEFhDQv8sXac
         b1Dz3WPr1A3+pKiDI/MAp/gV3Q67k/SZMv0t2439Ccek7+rmmQIXOGlRYXkOGJPDm0H5
         jenO1Z6cHJQ/BoGjthi50VDVrKMpsU9HS5FHXehi3t8uYJUMPVtfjTpxLl506jnyC77E
         Vb/q2gpS1MWNGNlEs3OhqCp8U8r1HQBi+HJPca5PDkbcVh4BJBC1qs3jAHiNt26iEqpP
         G4PA==
X-Forwarded-Encrypted: i=1; AJvYcCUIBikJD/MwrM3RCtfAmLjV8um5o3OrBB4fXsD88B8bNw8SdsfxWxNVRLykEGT2ggbs+kZV7XjGZA==@kvack.org
X-Gm-Message-State: AOJu0YygFtGtSxJsZ3OH5YgCHu54iUPf7IHlldk+lIi5hEf6rASVZlSu
	GpieWMHt5e9j6V9bIocePigCWdkGEhWHPHsK89qpKqeU0VJwJERohYtDjzFKiNnyQ8gIRCE35Ci
	AJsPaOK4=
X-Gm-Gg: ASbGncthZ3sGXA8l0/0nf7WqkQhgqr5prG1zBD1seOrg+vasbwdSmVsb4njVohsDSM4
	p4fPK8crLPEXpoRcpkG1+q5fC5YKVOKovAYMO2F6Yc74S19IoKsaEa2ajDec933uMumZzbd9yyM
	XRTIgfLMmgTt0qSakvmWoj1UdjfVekSTlKND+TbogF9xieHM0OOTTl+KdzPk7vEtFYe1LXwWK9G
	jy33Q4RKYLeyorhpJ9FrVFBxWMpbLVNCL54aiVmwBwkZ5DzsceSr9nBEIzsMQ2lblRoBR+Il1Er
	8rpgulPFG8AjkvrRrq7++876fBqbws9qZo5+LkSRWTeAespiAYvnwAM831YuPGFeud5IpASS0fw
	1TrFGWH204kiWa3QC/ZDLLhreTMZrFEoX/Wq8E9yizjPV4n6lVpmGp2v3urfNCEr1JkhZNYTLCG
	eD3JIycuC/nDAQdC5RENyaJjNpBw==
X-Google-Smtp-Source: AGHT+IEIaVwMtZwbkDXlOKtSHXso9PFz5vxF5PgtjKWqnoUAr1OWKadUDy5g1dKioAcMjW0KP7u9cA==
X-Received: by 2002:a17:906:2689:b0:b4f:f1b9:b02e with SMTP id a640c23a62f3a-b4ff1b9e0e5mr2272110366b.31.1760371632278;
        Mon, 13 Oct 2025 09:07:12 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d9525bdesm958179666b.78.2025.10.13.09.07.11
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 09:07:11 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-631df7b2dffso1397884a12.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:07:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWFCxXEXXtR0DYMNCXr/Eq0oDd0qoCZNXO4toQcnFP9IwYVgOb7Z4aq02TPmtEH6ZrCD4FR236jdg==@kvack.org
X-Received: by 2002:aa7:d45a:0:b0:62f:8bad:76e5 with SMTP id
 4fb4d7f45d1cf-639baf07534mr17910768a12.5.1760371631299; Mon, 13 Oct 2025
 09:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com> <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
In-Reply-To: <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Oct 2025 09:06:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgBkLXAFwj6z_6LtSzP8EVJi53HDa9wvZqcp1kr7UWzKw@mail.gmail.com>
X-Gm-Features: AS18NWBfLjf3F5D1SH907b2VJtHoEseavJA7J2wgEzyIuzyFb1rK7aIuY2U6g6g
Message-ID: <CAHk-=wgBkLXAFwj6z_6LtSzP8EVJi53HDa9wvZqcp1kr7UWzKw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D6BB180012
X-Rspamd-Server: rspam02
X-Stat-Signature: 5xn34dortk94zwajgu1zk3ekgap7cbw6
X-HE-Tag: 1760371634-190651
X-HE-Meta: U2FsdGVkX1+0yTPolZPWrDkqdNmtYPvRmYJvoxgZrdQQ1/UAaufrRha7C0uSrnt+EOKDstsGxlBcBfacNfGjdW8UslzXWLtFrYD3rEOOzg8Kf4dQehPdjaVhDD4yiGYWQ6EbqlBuOTc4G9oS/mK41qMjT0K/7dF8xWt/WQBgD/3dF8zMPqTra4xlXRBx/RDuVL93zFBcuGemlkHkGxkBABTCVurHNuL458NjElUJC4YIGatxEY7ChEvcToosVhdrlf5W/WW9o/HtV0ldFZtgKkhnE6rG2Cgfzg7z1q6S1T3aGO/lXtsZTBzBbL5LDxc1aTXF8L4Ucii5tjg22mMaSsqcV0QOaT4pcNfNE5stnL6KN2UES3ebYw7PSGxaNzVX7ZyVFA4VJo1qwEv0zxn2q6ooc5aue3A+ySqiI/gHwjEwhil8XfLIvIq+AeV1FGiu4HnWd3jDNpY+zKT1K8fDyQ4Klnfmqeg20mYTbiRpjVp7wLWWS2qOsuAEDZKpt3nn3FGoDFITWsvjNgyry+/NPYvV1WiALT3D8Tm/L1sdVvszniStj/iBxPnCkDlzmKVnTrMHAEoUs4EH9BDjgDr1oj4j37LyIe4TmxQKKpu7bsq6kZT7FXTStYKORsTYsCOnU4cZFdobGTtSkb5fv9Yd+acDuqUiyOr3EXA80Gg5bFGaOAN+0bLhdAf3A6vobKdZ3fUBldVOqlXXRQUEllQw/k6NieWRm96KuBXX4pwMBCMcQ2kd7+36/fufEwsY98F8rDAmxBz3RgtAOySKNEPLgEPoiGX4283Y0xZ0ihSutm4h0n19XJJqWl93X5YIlLZp7ZDOo1/co8sIUh8YoX951zwPlzXAmg2jiYYHclrNI5OFpCrhBPMybPxVHn/4rWjLnynl3EsLZSrgmRBY33rmDvwIpFQ0sWm/sMq+KuaB+lnbomfNp2eEmoIkBqoqq1HqazrkoDdAJuXSbeP8JOH
 4eVg+wl4
 6fT0Zb0O6QKxwug7fNGf6G3PUXdFo7fqvGpwEpwF/wB02CD81isGPcgDwb5GzjpMinHDvk/o7oMivkkK80AzG6AYLpneUH+TkUWjzmjpnrDz+a5mEKtUOiIN1cZGtwXAiNGmqRtJ96tokl+Peee+0e0brZVe5S54JR7tlmoUnnkUTJOH8pAnrhEjtu+WjHQ329qFL8JKMAnSFtKzyTY5dcK3sgPi0z/0wEEgMFSCh6AjSyT1CLsgsVo6E1aMwTtu3tSi9+ujaYC6Qzr5gm2/GbF0zYNmzMFFRsQEuRk1BF92uEosFlOKgY/WUNMg6F+2oBueFNwgD7SWVLw491hyw7buobInnxFGBMT1OkGdlTK7t+oSD0zjzx/VfP7SVUHIcpq016mo6X30DS8+TZFNDdpY18A0EPxvp9BY55pUiyeF2jbf5Xgw1Av81AchONUauZzpLZ7WfU7uVly++eGoR9legNBVrDpwOgfTZhYrP9DB0X9oZMbcXuVF6ixGIy3AJY28BICgODu7L1jAp1lw7dmDhWUpxKI9SwAVS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025 at 08:35, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> The patch is below. Can I use your Signed-off-by for it?

Sure. But you can also just take ownership.

> Here's some numbers. I cannot explain some of this. Like, there should
> be zero changes for block size above 256, but...

I'd assume it's the usual "random cache/code placement" thing. The
numbers seem reasonably consistent, and guessing from your table you
did basically a "random file / random offset" thing.

And even if you go "but with random files and random offsets, cache
placement should be random too", that's not true for the I$ side.

So you could have some unlucky placement of the helper routines (like
the iov stuff) that hits one case but not the other.

> 16 threads, reads from 4k file(s), MiB/s
>
>  ---------------------------------------------------------
> | Block | Baseline  | Baseline   | Patched   |  Patched   |
> | size  | same file | diff files | same file | diff files |
>  ---------------------------------------------------------
> |     1 |      11.6 |       27.6 |      33.5 |       33.4 |
> |    32 |     375   |      880   |    1027   |     1028   |
> |   256 |    2940   |     6932   |    7872   |     7884   |
> |  1024 |   11500   |    26900   |   11400   |    28300   |
> |  4096 |   46500   |   103000   |   45700   |   108000   |

The high-level pattern is fairly clear, with the big improvement being
in the "small reads hitting same file", so at least the numbers don't
look crazy.

                    Linus

