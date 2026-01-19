Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BABC98315
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 00:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB736B00E0; Sun, 18 Jan 2026 19:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3256B00E1; Sun, 18 Jan 2026 19:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09166B00E2; Sun, 18 Jan 2026 19:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC73D6B00E0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:48:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45D041A0629
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:48:16 +0000 (UTC)
X-FDA: 84346876992.22.A8A68E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3E491C0004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:48:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=izuf+vwR;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768783694; a=rsa-sha256;
	cv=none;
	b=Qk/LWUZkUEOxN0Fc43pIhEscxL7ivjfXuIPLHhAJFign6IL9SPjLjpZ1ZuRBnCSeFFSWyc
	QgzjOYPZC3JUQ+bvK5CH2oEXN260zK/IdW6Ng+uN+y9z8ie3Tm/jYaU8GYRWkHCQJGGphK
	JHQ7V2ktF5UUyl51Fs8C2EQEaMkcNio=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=izuf+vwR;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768783694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sM5woLBxXaGwAa8CcGy0J5c58+qDh+8shI/JCC5Mgs=;
	b=tlxjwouRwI5cbYH65ANg4U/+9NWH49VH/Zjw1diVtZQPX7c0vvOvhrCymTFcMiT5PlttKP
	gk7gsOLfaM01yCn/zB6/T0kIPWp/evso+V0KjTAZzXCnMUCsQG46TyVjT/BnlyiI/jG4Yk
	9tuVCL0hplsZvlbhxLcw+ieQCAp2A5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DF0160010;
	Mon, 19 Jan 2026 00:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58127C116D0;
	Mon, 19 Jan 2026 00:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768783693;
	bh=L1cG9GUJU2VG1pKximsbwREpSTyPGuSKjzGBFyCymtI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=izuf+vwRKzywnW+D6nrCZpFYVxKMjSMYmWxOwMMzAgeFtoygz2PAVxF+RJ3t7zV51
	 2kaUV1Y7cr9er9EMPR9K1Higso5pgupl6cCPn4EcrlQmsV7Yh9/VhHZL4Ixtag21J1
	 QtkX2MCH/mD0jmwOGnbirG/wsATbtO15aN98BxeI=
Date: Sun, 18 Jan 2026 16:48:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Maciej =?UTF-8?B?xbtlbmN6?=
 =?UTF-8?B?eWtvd3NraQ==?= <maze@google.com>, Maciej Wieczor-Retman
 <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 joonki.min@samsung-slsi.corp-partner.google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
Message-Id: <20260118164812.411f8f4f76e3a8aeec5d4704@linux-foundation.org>
In-Reply-To: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
	<20260113191516.31015-1-ryabinin.a.a@gmail.com>
	<CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
	<10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com>
	<CA+fCnZeDaNG+hXq1kP2uEX1V4ZY=PNg_M8Ljfwoi9i+4qGSm6A@mail.gmail.com>
	<CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3E491C0004
X-Stat-Signature: kfpthux18q9umuzrf74n5qxwuusumjp6
X-Rspam-User: 
X-HE-Tag: 1768783694-219157
X-HE-Meta: U2FsdGVkX19J2GPjvXkdaRKeWqMRxbkogcjbvqmQ+HhrGnU3Fmxm+NXeiRTHDWcpBxk9WuWa4RyHHkDVk8DXxg0/Q3MyzsUt3x6UD3dW7daeYPBEk5g5rgER91WsH+vsVaymWPzyvHcM5JXayQFv7BbN3LsL10gt6OMxa9qbsm/j3c8W5Q0nE2S/kpJdO+pEpoCQnjzrHZoOVN4R93zUOX0x8gL0vztoRX95Tw2jEUYfQYBpPRgVrSplL94qq7LZ5Jc7ieow2bjGFNEQGMYUCwXxVaCmiV5oyNfAaF2pxHSeKFbvOLZF+MzIZO/m2tvH1y6cVO7M7m7bsx4Xtn21R1T0dPJuP8r56HD3gpEx+MhOUjARPpFJRaEyB8RYu2QJdCGCec3WkzXF/cpTXNyGhYtUgSXKHDK2u1q1e6DpAmowX2U6QkghNluX+Uxc7nB5yrMfEkBlLCzgkctG3PTlYB2gVKUL87HVC/3dempNTN8nmmp0d/UFImyT9g6LEkn/BpsfTUS8CD2fQPdrHyb7pn9V0EdhiGpSoYXNpFvMMPe+JNuOcGaRTcevIjtXRV9/xddAlAgS7JXcl31tNqbUGx4LdGVTBvm9Gy+hU1khzhlJJv4h5guTEtRxoCqsak0tjXZdFKM0rFUdaJ8g4vyRI/+vhU5E2ZcWjrfIp6GHsMMf5pOy7Oj94xCchjaNs0O/m6ND9Qv4bURdT9T7xU3YigNLrpYo9cZZrIS2PubbDQGld10JPVNoMI0NEMh+LPzNDBa5lycjN7cs3T5Cu35kRkdI4cxiiV8V6yZofRt5/secksZKDLeDDrdiNilU3AjrnzjwbUx66wrBFtEs8Ku8eHNf81you3ucljT7GTpOFgRP/XJ4mw/jDVbAhh8ZZVgTDzljZJKYqZ+RAdWGO/67vAtAce3o2ZnpsvPneBt3qTx0oBgN3detj4xk6fwMXPOVczzQk2aqxIbavHSqt5D
 BxlRJO0Z
 Ob91IBYQipBwffOGnj41xslyzAQnLLTl0HV+2wUSBPvmTguS/VwUEkMm4BJlRrUDIb8/Oqq0me52wMNiGqHRgmpsEwbSgJFALr82y5M8X6YVdgg4l8HWSVLgP5IcDQSn2l+XOMilKWZZ95kEq9schzHNzNRfyIJN5pwOdfRugDVDNgqtjYLnoZdwgV4ZMH6KWOn5nL6Jwd6+Q5vEE8W55lyLL7Lr+vJ2IIoIji7fC6yrLg28+KRL5ZUVgn5+iBztVfl6MoTVOMjzHsSYiBK5XwHBm5RDIjQgUKrIWdTzyEJ67/ueCrfLFF8IcN6FGdxSagLXiILPiat6haLcc4HRnnyO1drKjZAKY589D0bNHKC0pth/lRY1nnfPghg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Jan 2026 18:08:36 +0100 Andrey Konovalov <andreyknvl@gmail.com> wrote:

> On Sat, Jan 17, 2026 at 2:16 AM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > On Fri, Jan 16, 2026 at 2:26 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
> > >
> > > So something like bellow I guess.
> >
> > Yeah, looks good.
> >
> > > I think this would actually have the opposite effect and make the code harder to follow.
> > > Introducing an extra wrapper adds another layer of indirection and more boilerplate, which
> > > makes the control flow less obvious and the code harder to navigate and grep.
> > >
> > > And what's the benefit here? I don't clearly see it.
> >
> > One functional benefit is when HW_TAGS mode enabled in .config but
> > disabled via command-line, we avoid a function call into KASAN
> > runtime.
> 
> Ah, and I just realized than kasan_vrealloc should go into common.c -
> we also need it for HW_TAGS.

I think I'll send this cc:stable bugfix upstream as-is.

Can people please add these nice-to-have code-motion cleanup items to
their todo lists, to be attended to in the usual fashion?


