Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B89F34C59
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185BA6B0089; Mon, 13 Apr 2026 10:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C0F6B008A; Mon, 13 Apr 2026 10:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B2D6B0092; Mon, 13 Apr 2026 10:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8DAF6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97945140187
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:47:16 +0000 (UTC)
X-FDA: 84653810472.13.74B27F4
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8ABDB4000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:47:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=LmjozJUZ;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="P 0Pt1Fm";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776091634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8U2X4bSWSk5VTnZUgN69eu5y1WQZmUIaZ0lY5fFNYs=;
	b=PEGOY9zUEDuASiikU1oTtV9yVmOTruIVGsl6+WnxwZ2PkxuamT8hzhI3NAOzzG35OIAZKG
	aPLbSXTnrQjfGBjQ0mNc7kuledbrc5kvIr4TGVSM/gogqoT9UWCc0jP25FB1bAHsg6UIQ7
	mx03FiZ+gDXP1FuAzjGve6cR39NuABI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=LmjozJUZ;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="P 0Pt1Fm";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776091634; a=rsa-sha256;
	cv=none;
	b=mPwstOLnie+2ctnesChCCX7xbAs0U51CfPlAoDNUGkeK9Ymlxd0IEJ7jMwvOsmrD0fzn3V
	DbLGgFv6dixGqX3/ltX2hIBi2UNum7Qi7o2v/a1coJf6BeznUZD+Cm/Er9iblpUZ07MJrm
	6aynM7kEjzKHJ6lokC/WX3YUzLf+jNw=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 9D38D1300479;
	Mon, 13 Apr 2026 10:47:12 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 10:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776091632;
	 x=1776098832; bh=W8U2X4bSWSk5VTnZUgN69eu5y1WQZmUIaZ0lY5fFNYs=; b=
	LmjozJUZ3Jo4aDvRnxjNH6xr8327RRDJ6AyS2k2jkDl2R8fkH9iYi8hT1huSnuvC
	fDXAO9TCtk28z5Z0YRzjvQVLbECztWiZU5NNtbQMRNzTIEQrOcdJnQGPD479uwHR
	1Q8ok3Usz/sph0Zc33WNDHZ2vRiLAUdkasmWlryN5Yu1+0d+T5ZkgPdaZcIJ9UoD
	LUtaK6rfdZx/q8xdekwLUdfJgdU2tYY2BZBNb9nIAqnbcU5rOmuWMelD9Mi0vAHq
	QCAxCp3Z9MPSmP03naZuWjoQXnxN4zfhCwznV9CiO4R52VmIdP6Rcnf+zUDjPDtN
	UXIkYMXlY1W1R8FqtfdOMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776091632; x=
	1776098832; bh=W8U2X4bSWSk5VTnZUgN69eu5y1WQZmUIaZ0lY5fFNYs=; b=P
	0Pt1FmZA3nT0gW/fGFJhGWUXdXBIcnOnTz8lnGNEggRDBNRkkIRZZ0rbNBev1XVe
	zzRDGJ8xdI8n86dT020680Fi59i8OYpo55O8jaokE2rcHortABYU2ULGblyCdcE3
	N7NLqkhP0h69s0MdHh8xGt/qaV3yIfjS2nWfiqQJrucaxHGogEVfeVOAY1wEf+xi
	uch3DjI8PEGZovPDIghE3cw7CjHIO63YZV2H2BcC52PGMn1wht6rI8JJJxiiCxXU
	UkCntruu9nNGBjU41kcYr9A+IW1YiAyNflF4aBilp4WdS700qNhK6R4AGl4ZTHZ/
	zTr464QHWbqiGWfEZOjQw==
X-ME-Sender: <xms:8AHdaV4EBY4AfwcF1maxWFQ-UReN_owOou9m4dD7NbRoLveor065LQ>
    <xme:8AHdadsjRmCe9WprTyyNQkCK8SO45WF8KHRoafxkQdvsEV90LRX-MaXp0aVyJYDZ6
    EmCfA1Y7H0u_e3mR0Jcw_jjFYyaDaWXBKlPB5CHolc71f6zGRLy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepthdrshgrihhlvghrsegrlhhumhhnihdrvghthhiirdgthhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegurghvvghmse
    gurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhi
    ugdrrghupdhrtghpthhtoheprhihrggsihhnihhnrdgrrdgrsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggvlhhl
    vghrsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprg
    hnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:8AHdaaT0cMKbTafw58cG7wQ0Qv82m8qZTRYyny1dj-38kCZwa83j9Q>
    <xmx:8AHdaeqogwjtF2ldxXkdqczEsPcfDM_1nEYFfwCk0UufLkJUoruyNA>
    <xmx:8AHdaYOz_3J7HsqPIEODLkY5cvhuJsZCBlh7QMGV8E4tu7K29uhBUw>
    <xmx:8AHdabApMPQo1X_BPzpLf70mTWvAAr9UgFJYBxC3fw_K7vhbYwNivw>
    <xmx:8AHdaZoXgvLSsnx7srnkGqW8Du6l-JaiK78sBGKrQgfs5kgyjB9M2EbT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E812C700065; Mon, 13 Apr 2026 10:47:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A4mZ2Su1YSkV
Date: Mon, 13 Apr 2026 16:46:30 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thomas Gleixner" <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 x86@kernel.org, "Baolu Lu" <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev, "Michael Grzeschik" <m.grzeschik@pengutronix.de>,
 Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Bernie Thompson" <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 kasan-dev@googlegroups.com, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Thomas Sailer" <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, "Dinh Nguyen" <dinguyen@kernel.org>,
 "Jonas Bonn" <jonas@southpole.se>,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "Helge Deller" <deller@gmx.de>, linux-parisc@vger.kernel.org,
 "Michael Ellerman" <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 "Paul Walmsley" <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Message-Id: <90a889aa-f204-4ea8-8642-6752aa1955d8@app.fastmail.com>
In-Reply-To: <20260410120318.727211419@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.727211419@kernel.org>
Subject: Re: [patch 17/38] ext4: Replace get_cycles() usage with ktime_get()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 67ibzuajjgkyxug5npx89m93wggg9ptu
X-Rspamd-Queue-Id: 8ABDB4000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1776091634-877297
X-HE-Meta: U2FsdGVkX1+h/k6YTtuQOsczSL7J00JRgwRNdWPxXK74T0a+x1W0no6rOXxWKnWX+tvBr/oPKKN1gWMPlFgJME8PrsT63/7sCYVSgPy4yP77NEZZrL8D3WrEWY8wpFgZptAgZRESBV1PWSUA2jkGP1nLwn0RDbc0lduI2LIbicSsAtdswYoWzKt6VaxtLleFcrxjQBDOlgAe+6TcZM4905ES0SflcDlPq7+S59ZoHeGQNNSmjlJwFk45YC1440BIqIkkxFjWPPXXX5iibEBNfKW6FLwLdhWgGght4seQB7EEOPzYMDia6hUnwE8B3ayFI0+bjzlIXYBZ3Hm92deGQ1X2CwkkNN6XVoZOTP0DySnUI1ELp7AeHMyCBI0sydxjMF+VmIwbceeEiH46eRWx2cArhal2z9+Sg9YxaRbXjataEZANONo14unVJqHR70YFo08V9SBH7Nl1Hi0IK20p/3vrRyLXuOi0lurmo89/+hSgSBzd/IUKjM9ibeIm4BTp8ZH/zMFLXtYvciGKZFIcnXIjWdrW+ooDWHxXwNhS096+3i1AAJMz2nF0QPc9g2pbV5ZJl/jPAb+VDjwGW5q37hfWFu2DQZneTSlwg8zx7S33HfIn3VzAQUy7khS0rU9Ka8lRm6rj84nY89yQIUdvAWTNvSpijE9oIjOG+X/xQCVD58W+P6aRtYfvJBjxbs/fiZGF2RKQZypZSlP8Vw78prJpbjFz3CZWzfbEUkPqNOwEhssggJZH4oS5dFPXNsZNDaMYqQqEPjXYJwKXYXzq3iaQp5Lf5qvJcMSQrWNx6FIKlFKhsZ45WL7jHgcW7/c1MGGeYMm6t6vvmHVBSi/Xq5Pqwl+t4IrLwm0x0/5fANfNPnU+BSRUOhydFNikfr89SSDd3O0u95asWhqE3raf8G+yv4h+3xRPfzroPIT82JYCaCF3kEmiHKhjqP+P6aqhIQrX/BSolRs9GOg4vMi
 JvJ2+GQi
 ybUFZ7/EfZwkqUjnZPfmhTQOFwF8oCcXXGp+Fl4SrN6Bq5OPWsFKzM9avMCRvXQ5SCJPYmiZKrES3Y0EJ2uHDU8UsXyYmWr/Cu7SruVvvA4XGq0MPi7Izrr8qH2U4eJWb0BlZLI6XeK2aZmvuPhmG7DMUu0KzkNvp0gIN/n7m5eKNXXvAppxsTSEicl5hLIlRY/5ITF6OXHT5aLC5IhyBb66BlbwJ+64msTh+JURWXuyr3d8cPQQsEE5nzpq1PowrasAwP4oTZoEBIuQJleS6FOhptQehZWOUz6t4Q5Dhmbe3h78fRPHtrij6HKvnlQJZfxeiYeY/r1dsHJ2YkZx6/S9QXo0NjCR9LPj4E6fSH7ANb+I1U62VHqBNh9ax4Cem2PA+OUMCuET/RSs4zCCC3qNVXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026, at 14:19, Thomas Gleixner wrote:
> get_cycles() is not guaranteed to be functional on all systems/platforms
> and the values returned are unitless and not easy to map to something
> useful.
>
> Use ktime_get() instead, which provides nanosecond timestamps and is
> functional everywhere.
>
> This is part of a larger effort to limit get_cycles() usage to low level
> architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org

I think this is technically an ABI chance, since the time
difference gets exported through procfs, but the new version
is clearly the right thing to do since it replaces a hardware
specific value with a portable one.

       Arnd

