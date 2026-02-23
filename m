Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BFFEC112B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0713A6B0005; Mon, 23 Feb 2026 15:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01EF16B0089; Mon, 23 Feb 2026 15:11:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39506B008A; Mon, 23 Feb 2026 15:11:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD0786B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:11:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DD7858438
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:06 +0000 (UTC)
X-FDA: 84476815332.07.9CE66A6
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04FFA180016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2McHbbekT1Exl3RCb98ZJCbdPdByiz2m/YVqx9oKgpA=;
	b=XFnM5az4wYXilFbgF9ALQn7vCKPlfTSNrOXO4jznTKRUOcE+D+Gq7HPpMRIfeHJsCkdDmh
	jcmAYHnbkqnt1PsTZvaSwaMHwA35fDLNBiEqXou9TI0SXQhTKbFpS33qhgx5PqQW5icDMV
	/+JFH7WT4c+MzSE1yoWTLueRHe+oeDc=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1771877464; a=rsa-sha256;
	cv=pass;
	b=J/8zdLyzOvG+qvTFcra7MGvGPv2pU9sJaeKLGpB02A3UGI2hXfhg9z0FapyrIr5K5wyECn
	0iwPyipUtBzuRyapSE42ajiZVZL5ufaD7/0U2GipuIYQ2mCpqhu8i7JrdIx6o6cj5Bpyyt
	8lN7S2ybeL4nE+f6FPwKMOOkCHmxkjA=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EC9C1A0159
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:03 +0000 (UTC)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A3A4B7EA0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:03 +0000 (UTC)
X-FDA: 84476815206.05.18179BD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64ED110000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:01 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2McHbbekT1Exl3RCb98ZJCbdPdByiz2m/YVqx9oKgpA=;
	b=nJwu7hNoERMQMnr0sw07wLDnOodTQwPJ2UFSWpr7uvDz+Lg9h/L11XprHrYD2LdZ3zU4D1
	bPoxvrM5yZ5sUjVETJ6XvgkI8GZiFoRBA692PGFW37gOISh3dABH6NpV2Hg62F7cgMbe6J
	6IIAkw2oPPxuyzzA7kre0oyvO/WDgU4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RJ12l/O8";
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771877461; a=rsa-sha256;
	cv=pass;
	b=j2p7pkr5RKTLjsb3jfV4X1ItAb8kYnY/o27+PYGYk7hIFD+vR3640OVEtyfcvEZUzRrqB1
	GN5+5eYDlKl0l2dZbOdqvK/vNRL5Db5EO+GIvUjd9WnNn/b/nhhqYS0EGQmeY6Q+U40hYX
	77ZmCU/Sc3thcJOY1uGV0Y3DtdFk01c=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8ca01dc7d40so461015885a.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:11:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771877460; cv=none;
        d=google.com; s=arc-20240605;
        b=WSyL71vqlrvRb6a+AXWxe5OXlJiCwVdjgAgH4S5JIAGZij0TamxzjQjz0Mv0pb/ECu
         JpJP1vcnWAAwsoNI/XgYVXUy0+/bXJp32EFpEC3cS3rfwTaVwKqfceFfjUJQV7l0rRPD
         Jx6pj23ygAaviXeV4fSK8rRL/6mwI3MbVArhmJ3Gv5AWjNNS51wzKDoZFFb5vqrEh9Mf
         qyQX0/4/4GWO9g5awFo86f6tFHDYzoiyZJk67yFCnxysLEji0OFy6Vny4imsblmZknBI
         KphAOIuY0Iow11PNis/Hcp4AOOjePOhnquPAlN1Txzxw1r3gBTGwQ6Ba/NQ73qwjohre
         KtMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2McHbbekT1Exl3RCb98ZJCbdPdByiz2m/YVqx9oKgpA=;
        fh=s1wFQYHB5pczfs/WW/kP57HICiG+qZ6kPqbihLrxU0E=;
        b=eM79cjNB+t8cjiIRG1C5gp+9KH39CMJzyUrDjv1fo7tw1xK5VLjbCFGcReY+iDsEcF
         maqlM5ydYlu+B8nzDGMXo/xFPBL0q8YVBXttEF21H1850koZSkb63dOGi1GLv9Q+Tk3E
         F3MoPr1Rj2jBf0uAI01OfptDJHuPAGY0vG3ab6zCEZY/AO5GvEt9sG5tmjo4crnHiK5Z
         xrURgoawM9+y8/4VCAEKsnUY3NBNcAiq79CDiJ9URWw4fa7aKxv83KHkNOX8DssCj+lp
         0AzZXsYsRf61LmTs9IMaBuFj7hNMWMjqu8ihpmm66/C/mj+r2Jv5Xc4LzxiCNwgzkOur
         EZjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771877460; x=1772482260; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2McHbbekT1Exl3RCb98ZJCbdPdByiz2m/YVqx9oKgpA=;
        b=RJ12l/O8pdTSR/3n1DmsLOpE7OfgVh7a1ySdoWFYmVoG871KnDhxijBq5AbiTzdmWP
         nV1hKBfDm51lczh4TZ75dz2uRQJ/wJQhy2LyXGp50ZQtRmY1zld7Xu35+JRwENwKpI3K
         Tvun/C8fvQvNP+Pb7GVcsRsU4D98/qbeT8Gw9Sd6T24H8KX6MsV2K5v7mJHvi7Ji95F5
         d167AvoLVdlEwrrVavOx/c802An8LWA9q9UnYooGYyTlVozM1v3bPkkfSmr72rT/BIfS
         cp/oT3pEInzUAvKZW/OcI5cUcd83P/s0kSp96CJLq2cn8ofmJwywcTpJyiSDR+zGV/9V
         2KdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771877460; x=1772482260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2McHbbekT1Exl3RCb98ZJCbdPdByiz2m/YVqx9oKgpA=;
        b=Yf/QhhG/X+JMc/qDOCmE1ZGkymPNGvYGd/cEzXsnCClMXvvxQEjrHFfpu2Y3XCyK22
         mxQjcKy/1f18XRDngpTs6EXVJuIsbQWczn3W0SCiq9EDZo3PtX6qBG/6FXVOs169gAPG
         MrzOupsixZydWR5yuaqZP/PVRCjCc7UTH4LoUea8qxi11ne65SNTUiSOBbqzBea5irIs
         LK3iJMQuVQ2BtjdNJtIXUj3kwl4jVJZ0OndEI4mJiTy1mJFQQu3JVPdkggB6ABekOqbs
         elE3uqZy0r+/leKhZ7vNFbKUVuUoL/xGIfCGjPy2TIAfUqiB3U00zeypuvuExeMVxXDt
         mCJA==
X-Forwarded-Encrypted: i=1; AJvYcCU5GOY7gBJfHb9MYwUGCldfSHJQ8GXGQsSwM9nhEs8tHgDaqMwC2B2/X9IiKFdv+CCUOfhuGpRaQQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/W4vybiBWLoLPIygiNgLx9VWdjZqggk1tml86vIsLPEQ0PPPA
	RIDfx/7GZgH6/hXSTUTJNSXerc0C9EpDz36TpgD/SVUGiogwn7GqGJ4mGPhvbycL4lU4eV1KgLg
	V9mt11LLa/vCDErflhqfi9/UHTJYPnZg=
X-Gm-Gg: AZuq6aLhcXaPVevcqE/fIodxClKrr5Odppol7PBDPCTZ7nWmkG6yC2VUJyRMA6I25g7
	MHob/TvSW14RfzSgeS0ROCcUWFK6uWT3vL6DxUH127Z4HxwKsh8rwz87u5A3x/469KGM3XRQW2h
	uogccvsooISwbPDZbalADbZsyJZ842fJbITDzGtYZB2XKlTyBCIl6vM5EiXlAH2OaAKP2ALOYDO
	fJ18epGEAToAVQDyrAoCDZovpk87XfAnVzYAgC/R0Surbufmq9neOuIQeld/o+8m/XFUqFXVi09
	sHjQQQ==
X-Received: by 2002:a05:620a:25cf:b0:8b9:d540:5365 with SMTP id
 af79cd13be357-8cb8ca67534mr1003746185a.39.1771877460143; Mon, 23 Feb 2026
 12:11:00 -0800 (PST)
MIME-Version: 1.0
References: <20260221093918.1456187-1-vernon2gm@gmail.com> <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com> <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
In-Reply-To: <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 24 Feb 2026 04:10:47 +0800
X-Gm-Features: AaiRm51lMvgsh7oDD5pQgGtSV5Y_M7Clbu2jPHQRGC9KNFInsWHaPcK8fDzJr0g
Message-ID: <CAGsJ_4ycodbcWHxFRacpzbxx4evQRJbuqJy3gfweAdHOtJg1Og@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX1934Pi5JkmRpWOYh4qXC/nUPhyVOgEGUBfVIqV/S+xPpJpxWFwbUQ23j/acJ2mPVa3rlr+M9cQIZnx2tPUD7PsT4lKzKysOb5VvNzVxQx31FdTCvSljz9Ts6casCk71qoEZv8NuqhBbeCo/p2MBCg6Hh/Iq26ZEZ3EFNiUAuKwxfP+dJW6PpyvI6/Y0BIUxxPUTu+raGtjwQFVyRK9dAhO2EcECukY12FIngPId2U5pR04iICpxvE7QIguAdCJ+YMW0ZhMMYEiYuBYUHLSl204V4Ig8X1VpNxTzi4xqSE+aPSTnbcdWXpHlfpedwQfz/6PZt3KucuuVJYRwAeYMKkMIA7elAPjtAl8M4jNpbe8SFjLVpKc/2+An1+45jQcMrMcktLcIXkKK98HVxRt02E+joZf1lXlninxByhhK4K3a4r3iqqCeOvfbXy3W/+b5nXWhYkmODG6FsdHh3U1If5WU6nYZLhz6Gf0BRHAZhVGX70zLsvp0gjdKV3E3f69IYBJ6Xfx7LSoipKNGgFqTkVbasgrJwnGNxV038wjb+wHWLq7Aa0Rr0eYH+t4+NIqJ/P+rokueGWPalS2lZxUacf148kWQn0R+cs//qSzwLD32OaguDT1mIMsEM+/zy/PhN/C4aveHkHAwLtoCEWC4kHMJS1aG/VDk3uWKkmpWxYy0/Iu/omjzU9NqJHyd845yMq47oH2joWmI29WHwzEcnJY9ChXVbUenbHfCUqTSLRJ5PCUwju99ALG6uxscT4VIKqdLeY5A7hGwALf6/iIJFmQ/xEFgKAdq04SkX1sdFM5Hgz8XhjcV8Jb5lYZc+3T0uzk8GBsOjjsAciXpqw4+Lv5M+BtFE341WTXqL8ReFI9RVWqEbwNEVg+bjEeG/qdxJhz11+ko4UTKo/6zvNdjnnVf/i2kN2xDWCJZL3VyQdlwN8M6OyfM156sv08cjBgh7m/BkFtqysD
 0e4uDClp
 UhuVnGguQeoSe38/0Ki/eNAZEhgkqguJt/Mp1+cZfV6ZoxER27nuO+qokOG9nBCawSj7Flkzx1qVH11mbICjY00WXff0Dp+dS/4YmicPLHVZIhXymijPfRQt0lr++x0g8hzxRq5xHIXumZPWN6OQPD1y+yH3kBtfaQ390HD3yHrhF/JGIEBVF0Df4ZXfy5jp6xBvyWVo84NswwAY1FSsgHxXhO8LJvSHS4SvzNivRobaO+OfD1xnbxkc1TvnaTvcYCGQL+VXITyVEEmv09sk5ZqxXSVKFj/+AXxmL2BqQoKy+HBpoH++n/hAFeVoZNEyoS+PpFmxEPaZrjTlVXo6anm+4F7gq8KwfCtAyhQSz4T+2CZZ+b3eP9vXcKIkTVfawyoE+8O+v9ozy1kjuG893xiSyI7VHFmuVX9EKJU7z8mTXqPw=
X-Rspamd-Queue-Id: 04FFA180016
X-Stat-Signature: 83usfqazjgzut4kcg65kf4c9o7awbewy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag-Orig: 1771877461-490113
X-HE-Tag: 1771877463-816224
X-HE-Meta: U2FsdGVkX1/Jzw5p98qGJmKsuiPOlaoTe8oLonEkgnAf6CuSsKGN2+I++no27eb8c4IDso0a8pbAJC9tx+bVG2Lu0ySic4GnA2LhrSew4VvvFYRJsoFk0intHcG+ltqy21TsC0NHejMjb+Ricl3GH5LgwQ+Ff0Dc0hzUZAxXro28ZJboUml/BLmooQSuiW93Iz2tzC8gePF4oAQv226FbLaP6v8n4/tJLcoQRdQ/i0eXTLhlrqnz7IV3s5r5XHNXE2ZAQ/KJLyePHQyG8WtgtJBCuNMRYnG9wBYC3y8zDigTuR49DHDr5vE4esxQg/CrM/oszAfEAHuw0d6fymqgg34lIsKDnaEi+9mfqKyq5v3HwNWn/d0mj+bdYE/5EGYwkpsgRMAbhsaUJ+OjBUPUiwGaqWq6n1LnhvFo1xBw5veuD0RKP+jX40ciKrw3hQvPpmWk+jFsPq4wzelj2yaEMUuoFxglZdydAXd02sQrzbPpIRtaBs94iwNwym7a++lcpBl+TwggMiAz+CX2sxTJT2GgaBszWKibR1CduKQocd96eDwZjARwpsmHK+Do/GUSiemVMAaTjPzDIAB4XoqvedMvdw2W+3g1JgclMHlhx7covMP5iBpCGAsYUJlRS7v6lPslDx6eBTMJyEVyhdpr2FP5HHdbPCn4/h4DgVNN3zgibgSgsOKFx6aXKLsMWkTe70EMh8D4PSeuYbKW5z7yZdrSKGMLeDDRVVoBYhSGB40ACs8+bnqcjK9s1Rw0sVdyUKwyf9ZVl/+kWE4nNt98d2w8RC51Z8kxwYq9GtEL1M0CAY4TN6L3ucqHLS3MaukngHJYpSo7wXxbmI8qt7wFgs7HzZalL7h+3Dt6naMljvhbgHQX4jKqcGXY2kx+TmeMmCYvOA/sh/ovSH2lVzZYAy0DV1Av9drl/yAaocBkLR5sMkmKtXfbFKH44IyKhQxI0Wgl7P+Pcoa86ycOF8/
 Kf6Ctfry
 Wocge+thN0DYYhWoJH91x6PoDZ4s51M17ZOwvfY5bewjZi0uaENuq5J8gP5ISl/6hy92axiDUWEeVzclYL6TGepF7g5Mwzc7WwEi7NcDc6li6/QXptUAznwRpRIMoS83fiI4lMCs78VN6KvtCPJdnvP/+iGQNqxGyX26YSHAurwgePo7YDIShdTfKlG4RjiI8sSZ34JWA8+E6bmreuGYsjVTC3GtS4LE1EDXwMaOisBcAbl/d3DM03cAew/43ZZ92SGNt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 9:39=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> On Sat, Feb 21, 2026 at 06:27:36PM +0800, Barry Song wrote:
> > On Sat, Feb 21, 2026 at 5:40=E2=80=AFPM Vernon Yang <vernon2gm@gmail.co=
m> wrote:
> > >
> > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > >
> > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > continuously access 128 MB memory, while the cold task only accesses
> > > its memory briefly and then call madvise(MADV_FREE). However, khugepa=
ged
> > > still prioritizes scanning the cold task and only scans the hot2 task
> > > after completing the scan of the cold task.
> > >
> > > And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
> > > that property, so we can just collapse and memory pressure in the fut=
ure
> >
> > I don=E2=80=99t think this is accurate. A VMA without VM_DROPPABLE
> > can still have all folios marked as lazyfree. Therefore, having
> > all folios lazyfree is not the reason why collapsing preserves
> > the property.
>
> In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
> attribute, which is the root reason why Collapsing maintains that propert=
y.
> The above commit log clearly states "all folios in VM_DROPPABLE are lazyf=
ree"
>                                                 ^^^^^^^^^^^^^^^
> (the "if" is redundant and should be removed), not "all folios are lazyfr=
ee".

Yes, we should remove the if; otherwise, it=E2=80=99s misleading.

[...]

> >
> > I would prefer to add a comment about VM_DROPPABLE here
> > rather than only mentioning it in the changelog.
>
> Is the following comment clear?
>
> /*
>  * If the vma has the VM_DROPPABLE flag, the collapse will
>  * preserve the lazyfree property without needing to skip.
>  */

Looks good to me.

Best Regards
Barry


