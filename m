Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6BFC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA926B00BC; Mon,  6 Jul 2026 07:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74426B00CE; Mon,  6 Jul 2026 07:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64B36B00CF; Mon,  6 Jul 2026 07:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 649F36B00BC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:51:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E95E81C2D8B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:51:50 +0000 (UTC)
X-FDA: 84958187580.03.232BFC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E3F640006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:51:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbPXWlFl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338709;
	b=rZi/wpZqcPODvH4uGcUrp/P0zxaY0LNvgnVTYCLQmbLHvlw1dcO1LC86tF4DTrLN5Iukaj
	1BDvtQL7tt6mNvBpUc8cFZjrooguzvgQE+/k1rGPvOi5uKQVOeudvhAxYHau8VORbvSlkC
	FLal2zdzQsn9dD1yJ75OFIjiWy8/XFo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbPXWlFl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eo0rbpMQEXSItLlYOrO8ragIAkZwB1eTIcTQaoCN0NU=;
	b=vg06FKmsQTvzPuO1xVSH7ndtct/0uTc1E87it/HH2kf37tslVrWlexX1YLCJLdJN7WsljS
	Hac6XYX1p9jz6mEYvtQRl2wlEjbBDXK5izw0kQgfKu2IOeK+pjVtfJC5u752ikopn3JD5D
	DWlZOLZ2owrLWaZGO23CP0qpTYy8eyQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32DA9405BF;
	Mon,  6 Jul 2026 11:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3261F000E9;
	Mon,  6 Jul 2026 11:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783338708;
	bh=eo0rbpMQEXSItLlYOrO8ragIAkZwB1eTIcTQaoCN0NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbPXWlFlsLnZCin+8sNLUCfKnxGBRnmJ4zwRem2uK0f8ZEFC1ZMRhDNiQb8y5gLCt
	 BlQjp/i8mDwgoarSO5j8A9SVOeDNhUnjKkkDl4hZCWBS0c1YGntrJuWsJb03LApK46
	 Ke4H65pf50dyMTGkBcVPZeRTNRZPN1vTUxmW3K0x1u3VjYcNbobY6yDVVA2ejuW9uS
	 ZNFx0P5cQQCDtr+P5hvl91JXOAs4IFsbYo3mA8ZX7KbSLqPCEl7n75tKPZCKxSsGvL
	 vzF1XNJvWdKAt5vDr7pB4CsbXAXY6s4fr9yjfz5Ft9qwpOPvRyDyqgFKWf4OOogxal
	 GNjxzYIB8Cc5g==
Date: Mon, 6 Jul 2026 12:51:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hajime Tazaki <thehajime@gmail.com>, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
Message-ID: <akuS-6zegY2XBa3f@lucifer>
References: <20260702012546.665383-1-thehajime@gmail.com>
 <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
 <aksn5J8Nr0JIsVpQ@casper.infradead.org>
 <20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
 <CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E3F640006
X-Stat-Signature: wp7j3usqgztupo8uhoa677zzaxghf84u
X-HE-Tag: 1783338709-233186
X-HE-Meta: U2FsdGVkX1944TR4+MVh/uiAc7xypyrnHUQE8pzpVuQTMAe/JdNSSDcoyxL7C6BXyZPN7IY+xFBhhZvd5LaBd8pq/AHXqTinG6dT1KutizOdbXkFCYUzhb5pRaTglO5nJ3ANWJgcuZv++v0ZGMEgwK0Jfgf+6/VyXqOLEkIYf+Vj8TqgAUbEbScqYKQPnQMjEThbVn+C+XAQKCLyMqDAyvjqbiDz/8+mfp1igVBNb8KIk9USBNSe29GyWn652ja1nErCrrEpCu5ZLPHC1fEqn91a7GSNHLiXoaNCx/PJnxiksgzqJjzERRSqTx4Yf2HyUr7Cz06/ju2lcfqlrXp346UiK3tMnBIbfBZS0S/ooYtJ2iRgpGVYgZcSx8rjRsirICT+wJHG0n0E8lHAGDE8gbMeHatO7wv1RI9MngffyQlcg7x5stXmdkZ3JIHXyu222/cweF0YUEwJJUK7thVbBkVZgBZWgFTo87HD+EIckipJr8DI1RFErYPDKj1m5yD1RdyhAwHyXtjB7/D94hXQrZ1Ig59fiS44avBFrnzUaNEiZoxrq3mRFHIa2x+M+ZeEcq3apRnlTBdAywyTwENBI7TLY57eaqmR3ZkhzHDEgVGtUTSRmNotWlz7K8cU7zv9OjPC+Z8s3n+5cV9TJsVc8fvpOHQNklli2qWRM9QBrHSpbFRLbVhqnZS2NDF7q+lzkErS9d+gEVd6ecB2vL7ewWfnHSQDzUFEJtondOvTF2l1DcdOXNb3iejspYFzgs+4TZ3Dve8GDy/9iJa1M1/qoqggstFW8xy//6YCJ+vfpXqFBwYgEAEmmcDRadvllRntBhn/arH61fnB2puzLAkffNzPqvy1W4vpU6MIstmcp1lbk8e2zGU0cJWibxaALrDtq2ZhXUD1Ncvv93In1X/72pOcwCQBpYjOWlxuwUZeHvz+shwShhJHADhpRyna3ScQ/L97/uG2qXnIszxud76
 wxIp/Sqf
 1Hz8frvhfL/rZHtQKDUvfmhcuyIpZYsp35oF3sAr9iq4MKmaaG3YDq3CqrA1Y8/NTVyHrpY2nCtu9I9gfmH18ln/j1jeqdWpsgnGkBzrxoZ5m9JmrpFH/FeeX6hexW/x8x+HOMXWNCGCm6zO8prRqRHfzPBiBClZrOAzzhco/KtXKtyFRnxSyED2axsMk50CuCn1zXg9KUvInnelN/hcjcsxNCxWRHb5XcyVkyODYSpRwWJyGHVZAle6Z1l9PfVwItBgFMpoN4rufshZ/lyCbhdPLw72o/YzTU6vbVXXX7AJch1Vbf7Zlvp5ItWjPSsFEmfOnj3zDvY+KeDAb+Tf9ol/gRDyegFCA0gp2i8RbrdhzJjZldILftm0ZobaXqAggjKbhpQkhVBGjzSvhR7IknCpvyAhBa0n9PXWATAl7Dn9BAcXW/SsR52KTWdL/P3+h1XS8vA+OiI14VNWU4NvwXhkEdnSy2Z780CBaPtPuBRzL4ypP4ssUWdZ3VHu+cpwRZ6G/7FfsXY8aCF3ksxOwS5ie9gwr1J/m8GRjsQhxzpgsh0iPHPlZbaezuuaax1rT4igqQDVhuKYYrRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:27:43AM +0200, Geert Uytterhoeven wrote:
> Hi Andrew,
>
> On Mon, 6 Jul 2026 at 07:23, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 6 Jul 2026 04:58:28 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > > On Sun, Jul 05, 2026 at 03:27:08PM -0700, Andrew Morton wrote:
> > > > Thanks.  Unfortunately we aren't very diligent about the nommu code
> > > > (are we?).   Perhaps appropriately - clearly this code doesn't get used a
> > > > lot.
> > >
> > > Should we delete support for NOMMU?  As you say, it doesn't get much
> > > testing, or presumably usage.  I have this quote from #m68k a couple of
> > > years ago...
> >
> > Greg is busily developing kernel code.
> >
> > > : I looked at nommu very briefly when I had my 68000 board on the bench
> > > : but didn’t get anywhere. Also didn’t try particularly hard. I think
> > > : you are better off with fuzix or OS9 if you want something unixy.
> > >
> > > (i suspect Zephyr would also be good, but it doesn't support m68k, just
> > > arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and xtensa)
> >
> > Greg, how mush use is NOMMU Linux seeing nowadays?
>
> Nommu (SH-compatible J-Core ASIC) is used in actual products, running
> modern kernels.  The rationale is low interrupt latency without using
> a much more costly app CPU core + RT CPU core split.
>
> Please watch the recording of the "32bit and-or noMMU Linux BoF"[1]
> at LPC2025 for more info.

This crops up now and again and people point to uses, but fails to address the
real issue here.

Nobody (aside from Hajime - thank you!) who uses nommu maintains or contributes
to it, or _even tests_ it as far as I can tell.

We broken nommu for a year I think it was? And there wasn't one report.

The last time I raised this, I was admonished and told there are critical arm32
nommu devices that absolutely _must_ have the latest kernel and this is
perfectly working code.

And riscv also introduced (and I'm so very surprised Linus allowed it) a brand
new nommu architecture (!!)

And yet...

If this is really so important, can those who care perhaps help out a bit? At
least with testing?

I'm a bit fed up of it really.

As far as hobbyist retro stuff and upstream goes, I am sympathetic, I came from
being a hobbyist (though not retro), and would be one again if I couldn't do it
as a job.

But retro people do NOT need the latest kernel. As far as I'm concerned, museum
piece support should be ripped out, and those who care run downstream kernels.

As for the 'critical products' that must use nommu - PLEASE start
contributing. Please start testing. Anything.

Again thank you Hajime for doing the one thing that really counts here -
contributing to the nommu code.

Anyway, as to what Matthew said - 100% I am for us ripping it out.

But it's not up to me, and unfortunately I think we'll get a clammer of voices
saying how important it is, and silence again when it comes to do any of the
work.

>
> [1] https://lpc.events/event/19/contributions/2097/
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

Thanks, Lorenzo

