Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718B4C5DF66
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAE76B04EB; Thu, 13 Aug 2026 09:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B636B04EC; Thu, 13 Aug 2026 09:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3796A6B04ED; Thu, 13 Aug 2026 09:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 014DB6B04EB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:30:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63BA9C013E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:30:01 +0000 (UTC)
X-FDA: 85096329402.20.FEE4245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDF1240008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:29:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjdfiP4p;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786627799;
	b=zw4v3kbX2+9yUwO7CPA7SQRSopDFzdhjtxvItWcHkiJosQfu+4Wk/yLPAF4iv9AdOp0M5E
	NGpfkCXsB8LWJXlg/SZqk4zmQUsdewzhHEnRtalNBEb8rpo1oVvbjpvQxUUxpJn8EilGZr
	12o/eLWHxehEusQbaAVmLTDROBjxIak=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjdfiP4p;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786627799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnj6l11DOGe2FFvkb9OwsGJ2XNY4AlAJ9yRSdpoEkMQ=;
	b=ImnCdwRpdgjUo5yPFUV/ScTa4a5qedmN5sgsgF3V4/veqxmx5iqxRE1QhKnalnDdzWHQUn
	PONnPsuRGZMxDhvyEySERupjmBXj9ZnR9aD0ll/+zl9B/rFIRwrDaY+0CaN0sXoGQb3lUd
	rIB40OAnl8Cpyrp1vDAjo1cHEVJAPeM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F7C60A72;
	Thu, 13 Aug 2026 13:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C331F00A3A;
	Thu, 13 Aug 2026 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786627798;
	bh=hnj6l11DOGe2FFvkb9OwsGJ2XNY4AlAJ9yRSdpoEkMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjdfiP4pElG6O8LByz2BX6u3wmZjkW7AsFndE2/slClzbpHkNNutcG/RtJaxbpcPn
	 tDOsq8gSItTRf3ZhgK+OZqhMOb1PVbeSDC88nqPNWJXCWBVftPfUsGfMmKF8C8lN8J
	 P1P/Rs7xJLisicCaSyXn6r1rbRG9TpOoS7EdSX80lQbQN+IK784vH31NMUYjciqVPG
	 wLXdDQ+GUOcBj1ELtDEHUxmeVY++0qzJCU4LmQRv9HBA/fQoaW9PW6I1MV49Pbbl6V
	 PVJ2NNBdjSWAkaeiGmNCYXkYK9tPGNftAngAeNIarP/FuVLX4TB+Hct4U1VBIvQ4w3
	 +u6SMLpswsTlQ==
Date: Thu, 13 Aug 2026 14:29:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, geert@linux-m68k.org, 
	Arnd Bergmann <arnd@arndb.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3COKVbgQKdY52d@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
X-Rspamd-Queue-Id: BDF1240008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k9p1kt1ox7imo5th9sb6zhp36sa8x6a8
X-HE-Tag: 1786627799-845669
X-HE-Meta: U2FsdGVkX1/gdoph/g1iGR1BGgNfCeO/fh7xc5hgPVbyhQddE2GH2qnQvm8xHnFWvtKDzGxigQ/rfgoh51Lwms+sMXKCLxgWxLJGEoVwIWfCI+ZcBASrijXO4NruGhkboFiJarEC1CRS51sblFVj206NJ7IWxa8+nuR0ATO43WTgeaYLx3SVMmm2sSy/WNf3/WkKj7ktu/8J1z/wmXs0M/7974kv5qw4AJYosoohAjV7iRBGxxs9owlguFZ6p5vEg27CS9rwQGiXkaWdxKxkNDbUTRm9WrqCpYCp5+mpKwpi6yDDM0QoxqcURIR4SOlSH2InA2iHBTVfx7QUC2g+M/R5rvS5AL/T4hZ17+dHqfhVpaJQu9jC6BJMrBITQjmOWVh4pGr2CpRCqEQ2y7wNdBe0oXHlzz+EkgU/EwwgTP1sE0HV8niZoYX81lAkGT6VHeCz+vk60w9FD3LhbQgs1MERCRHXFsTMZ8WJdAOgzuqPYxy/PmySpL7xxXhSSCmgkkUl2kdEcD6wb5AOYLFZcocSy0EeyxfCv8tlhThgKprpwrkqcD5PgL46yRXYsn72OwvNoOPgCI5/LFLtNM8mIQ6BOEVR0o1Yc+xq94PkY7Ja0Mm7IdGW1DBbBkdeSY49Zz4AYLWyxrPp5MmMqjeQnSTa8sgLEYm/dMDmdfH0lQkRRysFy+UEpqu8ZfcMOBgJRgnljAe8FEadDaahMBOKFuOxAvZb76JspRFL1gX0fV703oqZx3y4Lviyfu5w+mEyJZRWl2of0Dqc1kxpHr83Ll8JMrP5gztjLtLaBAbhLmK8ml9U3iSI03f9lCAOp7qNlEKUzVpbBBpfjtO4nRm6AGLb8A0275lwk+Lpjh+Ndnk+GLjs1Msnsz9kPDIxtzl2Qpb3xi/sbNVJOQO2JQfp6LdMLd4LDVqt8twRuNnczo4v7tpjG4slgQUCx5g3k9UJ7/NI2dmqY+azKIr67lM
 xtCs0qF0
 PH9hoaXfN0n3Ulbpe1CUFZBmvXUckpRZfG9rYXeIw5+SU9jh9rkt4uJ2e7YSTY6PZqyPKcshn3d8Jy0G0fcSpnfoeno87bjZRHBBL4HstIa9bJyhV+MCvZoDDwaVc2DZTfhAe+KQFvNkoXGOAShNbR8UjjPwiyHyDU5g3owWIg4iGmVKGOK9NYnRhP9bmaDLOounQZbUt1U3BPQcIM/lqc7f7TTcGh7DQfZGBnhhjngoAU0m8EYNa3fBrwzIpU2gL0uLXwB20JEDJX13Ai2K4lbekce6TiaduJHP4d53JaEdse7s1GJJonNktcWBZVg9+gPn1xOR8xHuKbpst3e5B6OSAhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> Hi Greg,
>
> On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>
> > Given the age of this issue, I don't think anyone uses no-mmu systems
> > anymore :(
>
> There are a few of us using it for hobby stuff[0][1] and there are
> apparently people using it for actual commercial stuff.
> There was a session about this at LPC 2025...
>
> One of the big problems for nommu seems to be that everyone is
> convinced it is completely unused and totally broken. :)

No, the issue is that nobody seems to do any testing or contribute any code
aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
I am missing people's names here!)

There's been situtions where nommu has been broken for a year and _nobody
noticed_.

And yet whenever nommu comes up people always seem to pop up and say how
important it is, then mention a talk etc.

Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
code. Any or all of it :)

Meanwhile we in mm have to _constantly_ fix stuff up in nommu because it's a
total mess and has real maintenance overhead.

Having to account for legacy systems that make no sense in 2026 when you're
trying to make improvements to systems people use, or not being able to do
certain things, really grates after a while.

I mean if you don't believe me git log mm/nommu.c. This overhead reason is why I
now co-maintain it.

So I'm honestly a bit tired of people popping up when the whole 'why nommu'
thing comes up, then disappearing when there's work to be done.

In general - it's not really for those not doing the work to dictate terms to
those who do, IMO.

So while I appreciate you confirming there are users (yes we know :) frankly
that's not the question. The question is - why isn't a downstream kernel enough
for you?

Last time I brought this up I basically got radio silence, a couple times before
that I was told 'nommu has no maintenance overhead and is perfectly good code
and we have products' by somebody who contributes little to nothing in terms of
code and nothing no testing.

So bah humbug.

AFAIC it needs to go and we should never have allowed risc v to add a new nommu
arch.

>
> Cheers,
>
> Daniel
>
> 0 - Really good example(s) of the 68000 port
> https://github.com/crmaykish/mackerel-68k
> 1 - https://github.com/LinuxMD/linuxmd my version of the 68000 code
> with devicetree like those fancy ARM things running on a sega
> megadrive.

--
Cheers, Lorenzo

