Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52ABBEC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999A46B0089; Thu,  5 Feb 2026 08:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D8C6B0092; Thu,  5 Feb 2026 08:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2716B0093; Thu,  5 Feb 2026 08:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 704156B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:20:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23F32C1F6C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:20:49 +0000 (UTC)
X-FDA: 84410463018.02.9F91462
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C63918000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:20:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfnXmlW1;
	spf=pass (imf06.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770297647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yssZIsXWUN6PnkHH/mDQHLZZItlVW1CLuerw2MW2wgc=;
	b=RN/f6uE0k8ju9atrH5kRiDDTkxIr6fv7yw7Zn9uMcfwIg8Mk0+Vo7448CkmU34QZP4t3XI
	P1LnFUvWAvhl5LOBozD4Y86BlR4nxd/OBjmVxXCdkkhiNqqzwOZu14Rikz+b6s+57ek6wr
	43t/GxeXNwuH47xRGtdJ00aNGJIstYY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfnXmlW1;
	spf=pass (imf06.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770297647; a=rsa-sha256;
	cv=pass;
	b=m/6hwHO6Tr0L9iKCvAdbc+dcUNEU5G5uk/D8Pk9IIyVkGR+Vc2zVX8aBHPAeaH8b/vG6C1
	P+ePEeunRlGTRnSUZ/boX8F5xkhLrSYPejbEvylpVCVo9nrK0QvFdbw3vKRGIc97yf//Kp
	oLrrGaCfv42QjL/1UYIAnhJ2WMXDU0E=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59de38466c2so1307436e87.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 05:20:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770297645; cv=none;
        d=google.com; s=arc-20240605;
        b=kpAmslcvK5pBKJKy3AmSDJ6yklNhdlmA1B+F6Qdrs3rqvQu1tHsG1+5uMGAx4wLKb2
         USzSeQBNhTVfrvp8JJYePMrTLn6DjHlGhQhu/sOo2dJKWLHfZCiYkn/xl6SPrVd3qn88
         14VdekeUP/mRJBd0U38DtNlHKGL6J/m+JUSG3akdtUWnX7wmps2niHKyqsfYMt5juiG7
         JP/fXYuYKV4gma0XAZ4UQPOkWg+DYeDWMRvoxM4JVnaH+nWP6dEgM8CBKRPX2c5JCDpJ
         LrtnQy+ffaGYmtHCziQHtc1sGPZItwPIHe0xkAUTUqD/fPAKh3RXHSqp2dGI+hJf6p7r
         IIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yssZIsXWUN6PnkHH/mDQHLZZItlVW1CLuerw2MW2wgc=;
        fh=ZQe1qyefdrnXaA8U5dFotXo6s7dEBF58Oj5jNukPaFI=;
        b=g876ePttpvEiPvZqfQJO3IROYoHLMsm7CmPfaccYfnsl29Jzn4IkFpCUhqBRLL9Gyt
         5LCBHCL7eAtIXPpHi5RdF6Ye0HZ9WWwoEauwT/B9/stqrkCiWvsDhN4AOFieKeT+SiWI
         EC6cCeXWvli88CsEqRqGe0bxMy+VAAVNRGGMrw3cCOqvb38tKSg16+C781sQNWMTsPaA
         r0qXVUrMr5VdgPtf9fi25WXRTNDxexc7R5IS/afHUOpLeur+UQtHRbxo6eNE8yeYvYBB
         ZEc3QLnTzzZfdIqZVgVq6OfmKT5HRmlfKOXbM+Yr3l/AMTg55d3XSs1f6nS+NX42Jd49
         sK/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770297645; x=1770902445; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yssZIsXWUN6PnkHH/mDQHLZZItlVW1CLuerw2MW2wgc=;
        b=CfnXmlW1ndSwrxGNj89ZZnRIHOgovPixqoRjptT1TuQA8+KUcvmOvSU4aWeeZE6buk
         eMPDoMXvg7f9dnwCZOM9x6x6UoFOBjhTWCBSOO8jAMT8ma2sDAtPiGyoQcnS9hV28RFz
         jKWMH8aesTdeg4HMStV0dUa2c+1OBX0l2SEN6IBJqLwRGeB7JmpJNsiPyqYPg9t3YJc4
         llnTt73PVmccQg6g7gKpFJuRh66awapntt7vN0Q4NaY5VHEySYDE5izbIw363E4pVbdC
         w/Zt8dlfnKeN2z5PzBS+wcCLR6+VwqFEPJmCu1034M7/5dTlf6m76y6iXkawN3o8Ni9v
         okaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770297645; x=1770902445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yssZIsXWUN6PnkHH/mDQHLZZItlVW1CLuerw2MW2wgc=;
        b=ZwzAaefzcZkH36aETDPlrMyZsrep6IwxiGTG6UYpL5jmUNQIZdZILxIq7v7LONaNa3
         VrES35nSt7Jvw2x3TXsykPQSfM5Dgp8YDWvxwTp64GkT0mS4OUlMNhay3zvy13zJxLaF
         nCtj9YisEzQDp9z9svzwtCHfIUlHiU1evAWVXwePU7ObkeR9HIjuAkEDRH1fSE1lcLys
         v4L3vwAJogIlrZdOiK8vaqBKjcZrfMoijykRVVZ5ghpQvhXIdQk1ylNFN8OuAyNtqFYx
         KQmNiqRxUNQLxapTv7H7IGKXXroUexsBOG0jrOoCZ9Rl0tpEX0o7mmpO5YXjHH/pfEgD
         nw6w==
X-Gm-Message-State: AOJu0Yxcy9lu6f/fMy/MpGXUUqq9EQ94vPgVBOYewZFxhrWjd7F5Y+ws
	Seb2BGnUJdCnNjbxxKS9V7s7y67PTrqZH+P1OYyXw+WUF2U1Z1zM9+3FyIcTk5tkcuWiJp4QApH
	2aG8CVJLqVmJxtKlvULyBpdH9k5D/mDE=
X-Gm-Gg: AZuq6aJ2BbhqjyxDZ3vJddH4fJiplLrWmS3grspUDI7CVEwkz751TZMtWJTcsCvgkIg
	6L7zd5j/M6bJqhzviYmFHsFGaB36wN1S5qUTz2nmSK1/uQJqk9uH161/XJUTE/XSdLiJrB/+dTp
	vdOWAkuhVI2LP069XekK9VJPNZZGRbslrGK8S23sDiDCRHxE//PchT8t6O2DcjwX+pQGKHqpyMA
	LSVjm96UwiTgLu9qswPL6nlxCx6j0R+sy+WhLqvJn5B6wnlMk2XRv3FBGHi/eVRvGZoMDrCaR/J
	53LsDu7zhCEk8POjnYLSkuZ0GtfZZqynNt9pOD83ceayTCcwMmUqd32gOnji/FgvrtGogTYHXGu
	jW5j2zWcKBupG
X-Received: by 2002:a05:6512:b0f:b0:59b:7c03:f2ec with SMTP id
 2adb3069b0e04-59e38c4111cmr2290016e87.41.1770297644820; Thu, 05 Feb 2026
 05:20:44 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org> <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
In-Reply-To: <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Thu, 5 Feb 2026 14:20:32 +0100
X-Gm-Features: AZwV_QgID9RHwkof0y9P5DyZEqMgfoHb9jybO8L3UEKcPCBz1qeKo_5lA8fFvC4
Message-ID: <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
Content-Type: multipart/alternative; boundary="000000000000442f1e064a138a43"
X-Rspamd-Server: rspam11
X-Stat-Signature: 7tfusjnbnpsf531fqj48xrrjk9hqbtuo
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C63918000E
X-HE-Tag: 1770297646-806707
X-HE-Meta: U2FsdGVkX1+25Gobt9wAOP43yzu7GImgUX+GeB+vSb9hgiOf37CiuWgxrCEhsgbvMt1VIFQeexNQeT3ti/mMehWaT0WLvduL6CcC0NTevcWJ7/u5VgV3pdf9qiSe7QIclgpfs8ZisD42EwIT1E8Y68dQy7QNPGljzr7VyDsaCXB7o7OCdm4yV1aGYC2x8MZLVIe/gvM27yfM39YiSxbTOvwowOwWrir1W/OsCjhs4fCdIX8cK2pm43du8BStj28RuJXjgyq/YPebx67VQuar76O+aAOhYUxw0+PfAZyuNptW8MnTsSr10RRXMON8cDAiZr/3ojHJ3U689t7ijVF6HtdMKT4Y5SMj9gS+aEWG+3bLFCpDXOfdK69nMurMsDm9ZjeBGNHYWwvrLuimiYCJeYbteOX9ZV4Efw477xhSF6C1NEd52cRNo5nxQE+OYSMEsUldByGBg52h3IqNYRPGg92NGMim6I6Rv1j2QI7yhUXPZrw+28BHzvus3qpVCb47dY4DtMboELpaD6rQPf3nrP+j+QqTdhKtvU6plqBOl0hN1vFNDw6x1gWHNAmTrkHGpJn0f0QdZY6FgqHTjSWfwBy4cmy3nVqgGK/EbcmuVxsC/Md0PlMbrNOhoav750oyQVg/cPFecTZXJW2Uh1ZsKwWsApVywnBs1Vy/JzYLXhKdjEyE37qRCkA0h/u7JHfKAiMC+5t1DPS+pFHsG7PU/rsEYpc8GJbfFMYXxIqeQ4udOSUQGOmSWK83Yf8t03fvjX+QeO/t4afkL96vS2L3etzoXh1KCKz+KIUJo0pskRqO93/Y5t4Lt5WY0AX7fR1LcionFvyhi6KTGXA9XF/RGBRaggiSWp/nXCbeTrRV8eWieFZ6bclQSw5WNrhvpZn8VXtlcfBj9CuwJY40J32sQGn9wDMbzwAp1lygRQ043RQz7539MUI4acb+nEpe9tK/P7IRWAn9qXTrh4QWoIS
 1HEes2UO
 TSW3O0lx1e8LyUrYIEYI0i00WpFgI3A/J4Y9yKoV0Pjq81LESSGqGAf95hZqy79nRqzgtNZZebYGFiibL6BV5gqTKoXMLc/AlKAY+gSkZp9qa0wljE1lqyw/ER6sNZpkIm8iyN5Ie4xz+Dv/t+n/Ih0VQ8sG9kCUDZkEcr0u22J81/f6mwfwIV8nnufaSCx+hHadf3phUUaiLOWRiGZn+NpvWzAQIPR/2HsM01iu+SyjTw+WnKaUIc0oAbdkt9LkznFFrml6abfWJJxI8J5zF5HFbOV3A39hciTSpohjNqvadqxGKA2zCAH0q9SOb+0bktDd3sRp4dWypU7+0Iafznp//9Flh05qU4lYHO/UcyWgtiB8oj95HKYabMM1h8l7R35b3nAG1EW/R/l1kGtDZnomEC6y1FJRJYdUmtJJUL81IwP4+SbR2lC6O1s/XSp2rMp2JeMvhFJUsL9ohJDnsDpliFKAgd+LXbmbDggAJOjy2HmQGNVOKD1xsilfTdNfzWIMO82A8taAAc5FcLfXmmj/pwxV+ca722FkTgJz9yHoEiVaQllRcFDtyLfojeDhI3ayc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.104876, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000442f1e064a138a43
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

All my clients are renting GPUs so i can passthrough but i have no idea
what they are doing there and it is not instant crash. it can work for few
days under heavy load and then it happens. So even if i would di cpu only,
i dont think it would give us anything.

--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


czw., 5 lut 2026 o 13:57 David Hildenbrand (Arm) <david@kernel.org>
napisa=C5=82(a):

> On 2/5/26 13:46, Tytus Rogalewski wrote:
> > Hehe, i cant. I dont have any CPU only servers :)
>
> But you can just not passthrough a GPU to the VM?
> --
> Cheers,
>
> David
>

--000000000000442f1e064a138a43
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>All my clients are renting GPUs so i can passthrough =
but i have no idea what they are doing there and it is not instant crash. i=
t can work for few days under heavy load and then it happens. So even if i =
would di cpu only, i dont think it would give us anything.</div><div><br></=
div><div><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail=
_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"=
ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">czw., 5 lut 2026 o 13=
:57=C2=A0David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">da=
vid@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 2/5/26 13:46, Tytus Rogalewski wrote:<br>
&gt; Hehe, i cant. I dont have any CPU only servers :)<br>
<br>
But you can just not passthrough a GPU to the VM?<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000442f1e064a138a43--

