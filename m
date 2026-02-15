Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6576CEF586D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 08:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF796B0005; Sun, 15 Feb 2026 03:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D096B0088; Sun, 15 Feb 2026 03:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F026B008A; Sun, 15 Feb 2026 03:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F32036B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 03:56:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79F8C8CA6F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 08:56:40 +0000 (UTC)
X-FDA: 84446085360.08.9D5853B
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5455840007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 08:56:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=qffaANEn;
	spf=pass (imf27.hostedemail.com: domain of carstengrohmann@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=carstengrohmann@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771145798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5NI4vzKvemi7uGExDDi9A66Sh5Sy8fcwzGNLZ6Muk8=;
	b=IXk1CYHkFjq1XVhVSX4iks/kUds3dnX1HzlTclX4h0ldLt+yhfp5BxQFhY4LxhiGuHPpFN
	y2Q+X+76ghcHtVG6E5G1Sd0SYQaMmal3RxDFJ4V5ECGZu5BmwkjUjfjvDuchGUSE/Ddgfm
	smtjX0gPHWG3k4xOQ/xwEbG76NWb1cg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=qffaANEn;
	spf=pass (imf27.hostedemail.com: domain of carstengrohmann@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=carstengrohmann@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771145798; a=rsa-sha256;
	cv=none;
	b=H8J8tUSBCwVWRYgXvOj9jd4l7oAT01czEb8LSg+mWrCy90NsNVsyaTpQ1rkFG6xpaC463y
	rw1OVUs297TJvNBWhkmP8luLtKFZYvIj3jhrbNhSJc+QG8oEfFTGOi7Mh8xXaG0NVqSc0H
	gVVMDu1hNQPsQWvQBt9i41OCqUgVhLg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1771145787; x=1771750587; i=carstengrohmann@gmx.de;
	bh=b5NI4vzKvemi7uGExDDi9A66Sh5Sy8fcwzGNLZ6Muk8=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Message-ID:In-Reply-To:
	 References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qffaANEnQVNCxo5a8sLfjurrCrFuHxjqXkMbm5DxfdiWcuG0gSYYcmxzz/k1m4Fm
	 4agruU9bAjEY3T1/9OA7rQGrWgGnJC3FvT68LkE/dD+B/3NYxbAYW6cMlHDaLBZGN
	 OZIlMB13PDWn3Rfc35h/ijc4vw0fqKxJBNo2pHpfbUoj1gaGfX1Kx+uHNqRfbg3bD
	 8OSu4hdXV9zbqiynnCkPiCscwVIv7PMuOU/YOA+5I2TZRvitJ2bybHb2VACdRl2Wn
	 RPYdME7obaQMihVw4tWt57BBzTCFn4Mfd1BiDjg91cL33nl/VP1ylLuVvw74l6GEH
	 cWbTgbiVlJ+Kfn0I7w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([80.136.61.160]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWAOQ-1wGP7h0UGY-00U3iN; Sun, 15
 Feb 2026 09:56:27 +0100
Date: Sun, 15 Feb 2026 09:56:25 +0100
From: Carsten Grohmann <carstengrohmann@gmx.de>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org,
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org
Message-ID: <8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de>
In-Reply-To: <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
References: <bug-221055-27@https.bugzilla.kernel.org/> <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org> <aYt4RwxqH1W_zHez@KASONG-MC4> <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com> <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm, swap: remove swap slot cache")
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de>
X-Provags-ID: V03:K1:EJ8/HEb+jIL9AcOR0z/xLsuSx2lRvztUaYnSdE/gfxrp/amZcUB
 wJzdT6LS+qHElNRoTPXJLSUKljumqxBdVziApyQi591A+XhyywUaSaeVXb/GpNlH3m/ARwH
 VKIBjYK6ipfAd66dL1T0Rh/GsxGcwwR71JuN4c3+TnUxbriztBDu6ScljWNOg6Mqce2HBzP
 sVR2aXEYvY68s7O0lFo1A==
UI-OutboundReport: notjunk:1;M01:P0:3mWSmue9ICY=;qKJhrYMyiCoNPrdjPH6TpMIcXzP
 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
X-Stat-Signature: a9xrzwus5c1rdrr54zkud5mkxmxb7np6
X-Rspamd-Queue-Id: 5455840007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771145798-372334
X-HE-Meta: U2FsdGVkX1/ziwAHqGYcM9PLoa6tVpyEY3l0x1S0L2qctK+7dssSLAICI+c0IdGLse1STw5ajvIA2JHOiOLzeZGWR8pPpLcQfstnsBrILnGH3uacs/wksEKeXoLb3rgPB3mQc2QqWXPxgZ/EvQAuvI23LxT5IqnL98pOqx1+dFOOHQltxDkY0dCKW2et5PN56Z0F79eEvNorUmS4XOEQEH9p5aHMufD3HfpnUjbaygfRd9OMb8rqVbOA41YPXyWxbKdBkUNrALBT9SHcZu0dVfu6NEBvH1gIJAsry2yHOB6TidkI3EUu974Ip7glRwDo/pD8GEWbSgph0mhnfmn5PuwsqqYObrOYJEvkPsgwhlYDwCODjab3Ch9RaijluEaADe+K00P05UR6zSbK5vpw357U+b/dKtPBAyJ2MBCDOWpzcwJjpAQZpHvVnQWhOxEcurOYHJ9Roa+KfXRQCWnyG8kPn/bwCtP5cAIS1gBejL2roXNkzz3WLwUW3MBR4phNuBpbhOJqPpdSS0hCle+4RhvIt5lJtzV24Qwr2M1A7asAyH0Q8I/kJ9Kt5pKxyDMGTS7HrP7SxpVlPvxqasaeWUWfE2vuQapDyuy2y5NulMD8mVX6CKCW5YH6zVweHIwqexIB08BciBjBJmFAmRJTBdNkSFMLpnATP/dAQ4OrnSAEWH/fvip96JVhm9DJ9Eec9L8BBy/poYznv5PvQ1o7Q+DDIJe+lvBoezj403winm7EXDAEZf0uCZlp5MlLODjZ9S2K1vbKB7N6O8YKA9e2AACzI0iUX4nKILHzYnjY0h0RF4IbGrbo2Qg1xxUr4ILaUTRtYYt1Mf0VPSaQsKk8Ss6Y/6Q63M/qGoz8Oc/BwbZZNetD0EEOBoBt8XqukVzLd/NJqLowjSyjQ+83auOjniimbwlPYNaGn4Qtxfki2o0rJeZQTzw/IFKT4Ta6v/58AqWYz4N9hUPWzpywcjn
 WUUmrmwX
 D9fBmu6OKdAVo5uMXisigpBezn76MEyvP/kjSJyXFvwooFbiiLO73SX47yxydxDKovcxu0/5rERkbvIit7LiNOfmdMqIaT9QfAaVHg07xzuCRncf0np2dnrPERX4u4WyRVea1bvP/1o4iqLPKN1ohIIex/fyTkHTLZINTjMvUt1beDA5Bnfoqor757kKbTgc7nypuxeiqnUXwXewtuSeRKsJZQ8ZVbF0OqbBw89NZAKpGEZ5mR4nx1juYCJ8dQsuwyD10Ks3CEmPjcPdJieAAv8vLLKGlon1g6J8Jz+p5/ZUX0TVvVwO6w0ZhwSkFsiDdhAgsDBj4yYGyD7hKn4JK21IbsXUIh7IvcWc7n0AGl7L2tPAqqwNDu8NAIG0YB/ER40eZHMZZ+lWJVnZFxqOg3m2CzFJmJKuVmJG09eYRKnn14yIUjOTbcP6PGEJwPaNYy7iv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12.02.2026 21:37:04 Carsten Grohmann <carstengrohmann@gmx.de>:

> 12.02.2026 20:01:48 Kairui Song <ryncsn@gmail.com>:
>
>> And can anyone help verify this fix? I'll also try some other SSD=20
>> later
>> maybe that's only reproducible with SSD that have very poor 4K=20
>> performance.
> I'll try out your patch over the weekend.

I tested your patch with the current HEAD from git.kernel.org. The first=20
run is with your patch, the second without:

Date:=C2=A0=C2=A0=C2=A0=C2=A0 2026-02-15 08:29:33
Commit:=C2=A0=C2=A0 770aaedb461a (Merge tag 'bootconfig-v7.0' of=20
git://git.kernel.or)
Kernel:=C2=A0=C2=A0 6.19.0-20260214-153617-09922-g770aaedb461a-dirty
Duration: 35 Sekunden
Result:=C2=A0=C2=A0 good
----------------------------------------
Date:=C2=A0=C2=A0=C2=A0=C2=A0 2026-02-15 09:01:25
Commit:=C2=A0=C2=A0 770aaedb461a (Merge tag 'bootconfig-v7.0' of=20
git://git.kernel.or)
Kernel:=C2=A0=C2=A0 6.19.0-20260215-083120-09922-g770aaedb461a
Duration: 324 Sekunden
Result:=C2=A0=C2=A0 bad

With your patch, hibernation is fast again. It solves the problem I=20
reported.

Thank you very much for taking care of my annoying problem.

Regards,
Carsten

