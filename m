Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC195E92FD0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 18:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590176B0088; Mon, 29 Dec 2025 13:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E006B0089; Mon, 29 Dec 2025 13:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D226B008A; Mon, 29 Dec 2025 13:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 362116B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:37:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9EF21B180
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:37:01 +0000 (UTC)
X-FDA: 84273365442.20.94D62DA
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id B94E2120006
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:36:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=qGv7nP40;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf29.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.15.18 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767033420; a=rsa-sha256;
	cv=none;
	b=uflrfZQ5o6sjYzdROQCsBXSlXTpCklxUwx13NAgrZwUz+EkMCOlCfKs7appXFTnOJ96QIq
	Ls2z8fj312UdMwMtvkFpLb5MIjGZYOehiMEJZ52S0wjgKYI0eJy2WKxW+1NmffwLub7w6z
	1J5PDNamY0yXONCORdBT7w63p2mh7AA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=qGv7nP40;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf29.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.15.18 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767033420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=URjtqHeaui05gc/rDrFo1uhZTAhdYjFft5Eo/V+uxYo=;
	b=f6d3/vxp5rSJWgN1ZjfMZUMx+pnytYw9/CuVbGfCbFETrVPeQ0lqjD+Vbvea6fK0qTu37j
	7hgSPHpW0e8m2zrgo+HnoKzkG/qc+sVjBj08qM0KUdoEyvvsQlT+Oa8Ha4p7BdMI2KuoWN
	pt6clQ79l9fC8bLm48+8d0YZ2WCgu6w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767033418; x=1767638218;
	i=markus.stockhausen@gmx.de;
	bh=URjtqHeaui05gc/rDrFo1uhZTAhdYjFft5Eo/V+uxYo=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qGv7nP40v0O1hPEZlQ9uqDoDhYRhgecXE4loxqQM5DW1qBZh1iLyzTKw/dfd8l/I
	 U+IH6G+zep6dnx0C+IKtT2pxXrhn3vCLbTm0tiOStDE99kiwk7OPfu2BvnTLsNN2e
	 2TjjkhOkOr6KtR0+i7pLPUcde2Nw44NHDzkRAFF9OuH5OYNLnSSfCUeU+DsT91pDo
	 aFikubAqTEYVxJWg/VN5umuf6CXkML5QNIso3v9FYPw/PITUYusf026MeWBYqr7au
	 +Gz0gI4BoJCgFYbZb5aElVg8cQ/Y1pVO2yOmT++0krrmqJnqXDux3j7/K9bb8sE+0
	 TGQfuvTwNb/D+3LlpQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from colnote55 ([94.31.93.28]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N9dwd-1vxW2e3rDJ-010E1i; Mon, 29
 Dec 2025 19:36:57 +0100
From: <markus.stockhausen@gmx.de>
To: "'Mike Rapoport'" <rppt@kernel.org>
Cc: <tglx@linutronix.de>,
	<linux-mm@kvack.org>,
	<linux-mips@vger.kernel.org>,
	<jelonek.jonas@gmail.com>,
	"'Chris Packham'" <Chris.Packham@alliedtelesis.co.nz>,
	<hauke@hauke-m.de>
Subject: Re: HIGHMEM freeing patch breaks Realtek RTL930x builds
Date: Mon, 29 Dec 2025 19:36:52 +0100
Message-ID: <007d01dc78f2$1ca4bf90$55ee3eb0$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Adx48hcdDahVNvXoQ26KGNzE3orerA==
Content-Language: de
X-Provags-ID: V03:K1:fSzxluXg8AHSy0F5yQZw0nhgkmVJonn5M8eTIQWA7jMelYGyMMY
 R20s7bc0lpxBzyIj1LzUnb6+T5vdwt7Fp/P7UC5Xw8zilbuoAnnGpQR6pDySMSJxvwl60KE
 5WJyT458shMS5mpeNWNzlh2s0lnIFroI2YxsjTYqNe5VM7s85TzTGbk2bp0IsbI0WeiDOk/
 eKCcduI/udVlFLJ05a7Hw==
UI-OutboundReport: notjunk:1;M01:P0:T0z9hrjOBHI=;SCphqeT/iYanTIBlLVCojkdYvo0
 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
 WGDSNBERDZodn+60A=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B94E2120006
X-Stat-Signature: j9zw7xyq5hm1gh4yqs1ppripkg3pq3de
X-HE-Tag: 1767033419-554689
X-HE-Meta: U2FsdGVkX1/KIkMm//RNwuXW+E7d43h202A6XSAzXrIBsNL2UUjs8NgHtn+qwfao/vWV2lz3/Q+HpWc8+/VUxKgBCewb05ce7+Tp7I2XFVAyhEDv6zfeQEMy3xGIJnDlWP+jrwzRZBTdSX5yuz0dFCWq2zLyhrVt04BBcpP57TRWWQrwAKYs6koH1TMBkyD8hxlNSQ3bXKaJY8JJBnSlDF1u+ccj67WXPrPyTlPt3mRT7agIZPJKuweG43e9rRyS531/Um0ZklUnMFV910sJaBy9QmSVd4KYOoy+myqvvegDiCQUsMk/J60FYqgyA7SDPtpk7oiLZFFxSD31sT1fchGwSTOSQzPSXP2zYP1Z61Dx3ZfU5ryGeK+/wMAmhTyIx0RlA6dVOmGFvcqhve1ebGN1c1LNjmxCTnDbwlRMQhYsRFEioHdjOCd+0nrBBJ/w1clANSdWM345RAoyewxy3Co12dHJXsJJRGIvlnGn8SwIiHAbVl1hXfvljQ4zCVYz1xuWfYWkoYTmph+lRB+Mi7bXaNGqxKCFu+cPuJk9Ibcl3X3eVBcgd5+RgLAJtqFNwQICV8bfmRD9YI2Y8RggKtJtGkC/6UrTQx0z6lDXXGfro94rOP0jgzfGrsCU1uzx0M3Gi24174N9QVhuVE6JK18WJkrSv+C365WYfsboT11aLxkZ3mScmgAhps7tNJnToK8CLOeiCNAt6iBQeS8NPXUrVJ9p+i53d+9ZqlOGcg6XGF2XfBlH6vixkQxihO61nhqc0L+4+jo6xQniig1SemxRbYpesOYcuYaMygIc+Lr+jPHLNR10j3jE+aLpUMPyMdyDONQH19UkWpm5GvJuUBB3LXucfvQvfADI/HxH0acsmoIWFGLw9KVOw2S7yz0Fa4mOxpnE38XF/Tt7IdW+ihAN8nZH/syGztBodxv5r5caxMlvnClOWMcN1plHKpGkdP6kWuAccbIeKyz886k
 II2/iM6d
 xTjP8Jb7chmESGgk4cJ3tv2AQxTeQRJL91SVspHdCpvfnb1MM5AvL+dvUPcSki/qIjVmkVH8yABvAzxqdwzvWRGbXH512T5HFq0EF8Q4iseRO3zoP92M4/9uZAwd298Q23rsSC2h6aMO1PalC3W9w12AHRTd/vWq/jyhTAN5Q3RFaxrgXXfP5GGVzqqGhYgAbg8fyj7k8qIk9iJwdcf7BmhiKTl26zf/roUPpPLb6yThy/rQjhzFtAnOxrwV7fWxIBK7fcY+cAw86Kter3jSkx/nTc+XYIAsiRDeHjDWpp8rCXAQiOSShc9qVYIJfImYYZ2W8aSWf/15zEBCpiedgPDQJOETfxENjkFt7YXHk0QjuS3dVcdEHwpkQYlb9rufGwd/bDkUvycBK+T9Pm5ujbK8hxW3M2gQy9bZonKIVrrXp/S2W1XptMfWWAy11xHbJg1Zs8nXf7fk24SMCYU3VIoS61TRo2H3VD6Y3Ydnlh/o7dcJHN9ruFaJJwrtKZQD+JDXwliNg0xSwVTMbGyvmsXk42g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,=20

> Von: Mike Rapoport <rppt@kernel.org>=20
> Gesendet: Sonntag, 28. Dezember 2025 10:54
> Betreff: Re: HIGHMEM freeing patch breaks Realtek RTL930x builds
>=20
> Hi Markus,
>
> On Sat, Dec 20, 2025 at 09:57:40AM +0100, markus.stockhausen@gmx.de wrot=
e:
> > Hi,
> >=20
> > sorry for being late on this topic but downstream OpenWrt just started
> > kernel
> > conversion from 6.12 to 6.18 these days. During preparation of the PR
> > https://github.com/openwrt/openwrt/pull/21181 we noticed that Realtek=
=20
> > RTL930x soc based devices with more than 256MB (highmem) do not boot=
=20
> > any longer.=20
> >=20
> > These are MIPS 34k 32bit multithreaded SoC with layout=20
> > <0x00000000 0x10000000>, /* 256 MiB lowmem */
> > <0x20000000 0x10000000>; /* 256 MiB highmem */
> >=20
> > Bisecting the issue gave " arch, mm: streamline HIGHMEM freeing"=20
> >
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> > ?h=3Dv6.15-rc1&id=3D6faea3422e3b4e8de44a55aa3e6e843320da66d2
> > as the first bad commit. This is back from the 6.15 times.
> >=20
> > I have no real idea why removing mem_init_free_highmem() and letting
> > __free_memory_core() work on the whole memory range gives issues.
> >=20
> > We are aligning to upstream very slowly and are still in need of=20
> > downstream patches so here some additional info.
> >=20
> > - Until now we never cared about FLATMEM/SPARSEMEM configs
> >=20
> > - We are still using dedicated prom.c/setup.c for the devices
> > https://git.openwrt.org/?p=3Dopenwrt/openwrt.git;a=3Dtree;f=3Dtarget/l=
inux/
> > realtek/files-6.12/arch/mips/rtl838x;hb=3DHEAD
> >=20
> > Any idea or hint is appreciated.
>
> Can you please send logs from a working kernel and a failing kernel with
> "memblock=3Ddebug" added to the kernel command line?

Good hint. I've done that and collected all information in
https://github.com/openwrt/openwrt/issues/21323

> Another thing I think worth checking is will the system boot with a
partial
> revert of 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") for mips=
:

Will try this out next, update the issue and inform you here.

Thank you

Markus


