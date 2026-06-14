Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE07CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 10:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212EB6B00A9; Sun, 14 Jun 2026 06:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4256B00AA; Sun, 14 Jun 2026 06:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9A66B00AB; Sun, 14 Jun 2026 06:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE8906B00A9
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:33:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8072C1C3F1A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:33:56 +0000 (UTC)
X-FDA: 84878157672.30.53FCC97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5FDD14000A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:33:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4O033mF;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781433234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNZGt5jAdvGJ9FE8m2dMOVkQl0H6oyUWqUmCHO4bEDo=;
	b=lrTVE2mVaTgOYi9XQZreRQQ622dn2gU888ZNunuV+c1Y7yDWfU8PrgaX2IA8Jm0AbjZiqi
	61uIJmoW2ciU1JjgyHgR10XJEzGo47tJ6S1jfPQbyck4YG9q+h1iK97eLQLYvAPb1C6q4R
	W5eBbEraA+II42lBDvWesoheeqvmbqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781433234;
	b=Uflmjeh6J/Efym9OgpUYj9/JtpfUWgo5Us8hL8IOf5s+0YbXSp59BSZhmd5vec7h3qW/25
	s8sLIwvlPvtFdtVKxWpKVtAZz8PJ9+tYJMG5UliYepUKHv2SHICN0QImkpsU5YM9JjGnPO
	jKjjUX3C+KSyO/Fb9cGysN4cDu9pM/o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4O033mF;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD40C4374D;
	Sun, 14 Jun 2026 10:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AD01F000E9;
	Sun, 14 Jun 2026 10:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781433233;
	bh=fNZGt5jAdvGJ9FE8m2dMOVkQl0H6oyUWqUmCHO4bEDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D4O033mFlKeba1PLOGOiRmaKT0HE5hCywAb2SmHaWTLg7Si9bZXSFsGSHQ2W5zmqQ
	 ys03YqOtdxF4fiW61Q7KcV8HbOnyBKxBgn95LV/qvejr8YcPGFLfykFMYKao9DmxIh
	 QSmkssstKxU22KEdn6XIPYm8omxvYWxxIVeh31P5IMP6p93MOWrlHgBD/00hQSuS+4
	 8u/nCwXfb4s7Lr/quIEefgn3MuMlBtPNP57E34hRse3Dzti0yLPt/ngnQOhg+UDG+w
	 zT5HCGNe7QMMaCdgWcJRrG6ut0rmGxAbJds9ctsWLOSmxhHdR+0u0H4buLOVBx3nkg
	 mMyv6PUIGqE2g==
Date: Sun, 14 Jun 2026 13:33:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <ai6Diz0UgSGccbhY@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
 <agr7XvoWn_-axX1-@kernel.org>
 <adb1db8d1fbb9d219fa041776ae863aa2fc09270.camel@physik.fu-berlin.de>
 <aiBI_QEmeVSBb2HY@kernel.org>
 <865aaa7aa64ab69ca9020d64d86baa8d9b700bcb.camel@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865aaa7aa64ab69ca9020d64d86baa8d9b700bcb.camel@physik.fu-berlin.de>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5FDD14000A
X-Stat-Signature: 1ic9a7xufidr1epcp9w9xur7rezuei7j
X-HE-Tag: 1781433234-747279
X-HE-Meta: U2FsdGVkX1+1DVQ1RVkhPtDQRgfAv2z6BL26wTdLGfjIi7mv9naJ+RJfPEp402T8E8ApT1pNw+wmNEv3x4acstPwr0A/bcZRlmmBPB8GTk5kdGs7VIblJtjkhok+VeUdH96WKopiCtV4WZf2wVwe2/vCMYsSMl9jeKvct/F8+WrM6k0VvItiFG4fEAuoqwdwOJQlmZ95ZsFkZ78ztz3kJwynXoBbVclNZaLCyXr4X3UWWkRCE2V0zX14QuytUto4Mz1RxUvU7AL3svGt3QLnE45eRH9UmnUVgG9T7AXQ6LXLo6TfhsarTfz7UGizHqUx+XsTk8kTneAu/c7lqM4z4hesapvofxbJAOQCv4L3oAADYlQkkBnAT2Wpf4C8+1hXjOEocKpnVdRbu3x7K/gbOsjyQ9MfuNuSaqPho46XgbCEyV9zJQ5Nd4uBkwU566jkT96M/jCi2jkuuXu9rSTZB4lxhyMUG1CXHi6Haz7pwOYqz1GW32LR7EvciUb6ghvqrkKhKY3Krq+Pjx+75wlhStuVezptYuV4D1SrsnaodKVSAXaQfa9STMJ9RGRKxfyRZVIKpVOjrlFemKjcFrMVAat3gaiEEZJi3wb4MeZ9Ws80a21jItJkBKUhUsnBwLOx65sFhwmfe4N+bQuz+hndS6sTd6tgUveMU7m9kFtirVa07CfMYZrm/pJc2H3WwYDnJd/wXWKoYMtXsCS77Cbh+L8crqmy6YJcc4ftinVAY3GPZN+mIs5k+aEFFKAKHSRcMsxg1pvm+mwX67R6nvQYjwT+mTmvYzXMNyy8hRxY0ZXU9qxpmfEA6EYy9hGAH9hvB2OBy37F4xOsfGolc/1/3yLfcXqxghi4NUumvnySXQPAxDlYkTFU7cLs/Gf5Lu/ZNQY3mV/EqBySwxgodsgccrOM3qAm8ZWDaXhUb8393T8AmN0CUNIwrvuypp7fEqP/mMIa2JVqiNr2g1Vn3o6
 Vp9Nw67b
 1X2DzzxizyH2TYH2nUZUVEDyBgM1AnABnFUTTCAL7QrVONleXM7dKaAZEIVWFgsBdIpxfMPpu5GnIcXMz9AsonKBXBtcjWx8khCTSdNVnDG7Ylc9NVDhxW75DA1RAWpWFrzELLQAsMeYEWSG0CH1eC5ZYOQkNH0ROvU6WcF4/IRw+UGCADFmFhC3VDTKVv4mfV1Lj6Gwv7MXeVYxWm8quReLQbX2nQrpfTf+otkz1BnzLxsydKDR5VBGtAFL/eQdDTHp2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Tue, Jun 09, 2026 at 09:21:37AM +0200, John Paul Adrian Glaubitz wrote:
> Hi Mike,
> 
> On Wed, 2026-06-03 at 18:32 +0300, Mike Rapoport wrote:
> > On Mon, May 18, 2026 at 02:05:39PM +0200, John Paul Adrian Glaubitz wrote:
> > > Hi Mike,
> > > 
> > > On Mon, 2026-05-18 at 14:43 +0300, Mike Rapoport wrote:
> > > > Gentle ping?
> > > 
> > > It's on my TODO list for this week!
> > 
> > It's sad to see this being dragged since mid April (if we count v1 and
> > there were really minor changes in v2).
> 
> I apologize. I am doing the maintenance as a hobby in my free time, it's
> not my primary job and it can sometimes take me a bit longer to take up
> changes.
>
> > If you don't have time to take care of that, just say so and we'll take
> > this via one of the mm trees in the next cycle.
> 
> It should be better this week. I've been recently busy with CVE fixes during
> my dayjob and the workload was extremely high.
> 
> I am not going to let this slip, don't worry. It's just been a bit too much
> stress the past weeks due to the AI CVE reporting.

I understand that this is a hobby for you and there are a day job and other
obligations and you don't have time for timely responses for arch/sh
patches.
 
I just don't understand why do you insist on taking this via sh tree given
you don't have the resources to timely deal with the patches.

This set can perfectly go via mm tree as it cleanups a memory management
feature that should not have been added to sh at the first place.
 
> Adrian

-- 
Sincerely yours,
Mike.

