Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B09ACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF9E8E0008; Tue, 16 Sep 2025 17:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7428E0001; Tue, 16 Sep 2025 17:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314288E0008; Tue, 16 Sep 2025 17:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22A198E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:24:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D02B0160306
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:24:05 +0000 (UTC)
X-FDA: 83896391250.19.8CC7FF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C111C0010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:24:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qyml6Vna;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057844; a=rsa-sha256;
	cv=none;
	b=hUgSwMmlE2NX2BXD4g6vi0N4vE33eTPcd88oFIaAuUD2VvbR1SPBuSNz96E9OXOYEVuw0+
	f9e5bHj23sxVvkp8zwTTkePRMx9oPeiKTMDxwDbB8TCz0OPrOvlRzZWluUVtN4YTHg6q8g
	mztc3ozHe11rynHltF4/W8iw6yQD0V8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qyml6Vna;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrK6H5TeIHD81mFHQs75Jltr0eszG6u3DdurAUYQRw8=;
	b=xALh+Vu06hEYHZMGsiIZl19sbVSeRK5RsWidrGd0nVRZLj5dXeR5l5ElypV8TNn8pI4oyW
	xlrKNxVYABxwueR9wq0OniegV2YnQ58wXZE3N85mOuH7maSxhwKkXCSJHmU3TtwnaJrzkx
	5y25a8qlWRAQ2jbUusvfz6Z3DuvZ6Sw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE09A41928;
	Tue, 16 Sep 2025 21:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7D9C4CEEB;
	Tue, 16 Sep 2025 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758057842;
	bh=Bsn4ypPMfuiV5NKNpmlXvY24AALUkCPIKhmhGYho/EQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qyml6Vna2GlmWkaHpV2CzqTk/TiBPjZFisqocFlAqeSVjcfs9QIL2KzoA2KrY5pth
	 b7MhxxY7U5YhZNnxStCjrINja9Rv8OsCLHAjxZEYv5tOw0bmp30+g9oKjw02QZIG+6
	 mkHMJpbEAVYH3laODVT6tYnMxROLMQDMQ252ByfrlVf/HnMeJqzvTO9vXw7TDhY9bn
	 rQo5KY91IqevgCelioj87QElpShoX32TVqKGe5FU68bOYlLZm/o2FzLy19YpqJWfaW
	 OXGbe76phmRsRCy/t3kTfprp4UeQQd6ea5WaxuMFsTEZ2SdWulXiPZH852bB7Mj7KU
	 Yu5AuBqGksktg==
Date: Tue, 16 Sep 2025 22:23:54 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aMnVarvAvQuJCWXy@willie-the-truck>
References: <20250903150020.1131840-1-yeoreum.yun@arm.com>
 <20250903150020.1131840-2-yeoreum.yun@arm.com>
 <aMm69C3IGuDHF248@willie-the-truck>
 <aMnGUr9zeutyPpAg@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMnGUr9zeutyPpAg@e129823.arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C111C0010
X-Stat-Signature: mgo9uducu93k98tuphjkkm8itjriyn3s
X-Rspam-User: 
X-HE-Tag: 1758057843-709808
X-HE-Meta: U2FsdGVkX1+hHm1owLZTQG/iYJS0XMNqeEQqeZClQErYyaIPM25koAWz7IzHBjv19y3gyC+XNOkj0kK5v44jPwxib5LO3laUZKLInx0udRHtLdqkIf963Hozn1ZjopclrpckYSp8tnztfCMmmRMvXOsy4GkCLZczyRN6h01uQP7DdJe/srN1H/Sqd31WuQBEefHX2EfVGdJWXvhWwqc4HD/KoOhXZabqPO+3yvRy+S3jYm+jlF5iVYK1mno/FfKT4TKqiW6uBrnPYG05PJT9JtDgP7A6pWE3MIxpEng/GjVgjHhjTD2VKz/btYz4z/PElWzcnfWDNjgKE+3QkDffZDWEZDOH3IAbzx8/yLZcpBlKG3Dakuxt5FW51UAz3LTjBUxGZYZcuLjE0X0o1CtCVoybDffnI0c5JclYTwfzN6MZCrNENMwmN+2u0TgbefnBGBByVSbufSNsb6XFuIHovpwaBBVAlLgSGXSm0CvNaaq7uGKN/QoLH0xNtE0j/kovtBySjflsoFnFa9iMsJ+qyDOtOZKCxHq+0FvOTDtiHpybp65C7+2JXJsYbW5xvMYOyUtv/XVU2lu8xPgW2rhMPC87qgD8yQuMYcql2+dxA3e7caFZgfWCADJh+YdHp6M2gRbOju+ejU8arRQsy2P6h+RAhdNQmjkeUMph68U834TIocaJSUBsrPZMBaKMpheVeKvOwaf//zIhT5b/go+Lz7ZhRdzaMDQfb/8v9uPYWfl1+MpijP89dIp3ofAX7+XjguWEF2xq6yqIRMQovDfFKQV+ZL78I9RZSkx/+sJuaP91cAPvrvQhO0nXUF3Jh/pm0wmgvb8yjCY2IlKzrbKNHaPAOV03Cw8H/BQ1Db318kKCaE3f0u30w0ES0aK8x/I5UlfJ01X1P/rzN8MsJAIar5/RpqSVUn/GxWHpfaNfUwgL2xVtXaYjcHkGUOg0pzj/QANApN7O84MvPs4Nt56
 RgiLiwQV
 fTlRwenrkyPHBq8Zq2+ZY+vlcYDfgE2ZhYlI0zBCed3B2caSwq9ccfgdEs0sazqwvmJ91dK2RpTvXealtEL0a1YSie4OgR1BU+y/91s7aL2Qcyq0JuwwV67YtWpAQm6oGUYXBMhjai3FC72Ol0emZ+xBMpM0CFaEv9NmQAsPBzGMJhxX3mfAITnWwatAx00ixDkcvo3IhTYQeWtFAK6TVMtTgx0n1dRIm84G5iWWba5Yht/yFgQEg4gNbBmxY+lp34ds5IF0yx3zDQKnAXTzr2BcDJt44rtjGk6ZJVz6GIMu6o2r8TbaF2xa5kUyfpOoZCHUchlgKoUAHj7/wr0YlwlKKwJgn+62sQKPbSncwtI+l9pUKFj7+joJswg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 09:19:30PM +0100, Yeoreum Yun wrote:
> > On Wed, Sep 03, 2025 at 04:00:19PM +0100, Yeoreum Yun wrote:
> > > +	switch (kasan_arg_write_only) {
> > > +	case KASAN_ARG_WRITE_ONLY_DEFAULT:
> > > +		/* Default is specified by kasan_flag_write_only definition. */
> > > +		break;
> > > +	case KASAN_ARG_WRITE_ONLY_OFF:
> > > +		kasan_flag_write_only = false;
> > > +		break;
> > > +	case KASAN_ARG_WRITE_ONLY_ON:
> > > +		kasan_flag_write_only = true;
> > > +		break;
> > > +	}
> > > +
> > >  	kasan_init_tags();
> >
> > I'm probably missing something here, but why have 'enum
> > kasan_arg_write_only' at all? What stops you from setting
> > 'kasan_flag_write_only' directly from early_kasan_flag_write_only()?
> >
> > This all looks weirdly over-engineered, as though 'kasan_flag_write_only'
> > is expected to be statically initialised to something other than 'false'.
> 
> For the conherent pattern for other options.
> Since other options manage arg value and internal state separately,
> I just followed former ancestor.

I'm not sure it's the best option to blindly follow the existing code
here. To pick another kasan "mode" at random, 'kasan_flag_vmalloc' is
initialised differently depending on CONFIG_KASAN_VMALLOC and so
allowing for the default value to differ based on the kernel
configuration makes sense.

But that doesn't apply here.

I'd recommend starting simple and just having the 'flag', especially as
you already made a small mistake because of mixing up the 'flag' with
the 'arg'.

Will

