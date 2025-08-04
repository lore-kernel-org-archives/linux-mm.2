Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC72C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734CD6B0092; Mon,  4 Aug 2025 03:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C7E6B0093; Mon,  4 Aug 2025 03:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622526B0095; Mon,  4 Aug 2025 03:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50BC86B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:19:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AB861A0E41
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:19:45 +0000 (UTC)
X-FDA: 83738225130.06.0447020
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49ED410000A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:19:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk;
	dmarc=pass (policy=none) header.from=iodev.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754291983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0tpIcMqNS8CAho42gT8f+EzD6ZyeoDEP1wpfyW5bbA=;
	b=0jAbS1GZhs5C6WyIioC5ClMAI/du1S1+bnMV4sWRRnwMUVAse58oVzlK5YqMPh3qO8gwlM
	ErVj64ywZMTo5THC/rkrxWLqUgbdZoFoMTVxUIzSVGi3axnPyhKFDf589FybNhv164YNn2
	80A01y3KqhcwyoneE2o01FR+L4Fmy4o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk;
	dmarc=pass (policy=none) header.from=iodev.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754291983; a=rsa-sha256;
	cv=none;
	b=R+r6RFgNfGt8dk1e4uJk1k7Y7bCtADYoxz/NGt2Lkf3V2j904Ej9tyGb9zqeB1zHQKaytr
	A/QfyPEzVuG9XytjXXXq7qEloNe5r8Z0cFskZ2AXgU822JoLq1vrUn76ztxpat6A0ThZfB
	xu3/ZZRudJ2o30I5GVK69Fi0cQp+v7g=
Received: from pirotess (112.red-83-45-208.dynamicip.rima-tde.net [83.45.208.112])
	by iodev.co.uk (Postfix) with ESMTPSA id C8D7F4552BC;
	Mon, 04 Aug 2025 09:19:41 +0200 (CEST)
Date: Mon, 4 Aug 2025 09:19:40 +0200
From: Ismael Luceno <ismael@iodev.co.uk>
To: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, zhourundong.zrd@linux.alibaba.com
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
Message-ID: <aJBfDKr1-7L7GGgH@pirotess>
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess>
 <202508021029.7CC8B334@keescook>
 <aI7zDXb2VpuaHHYi@pirotess>
 <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 49ED410000A
X-Rspamd-Server: rspam06
X-Stat-Signature: ewgw9e3sjsg9mdp8got5xqmg3yge6aog
X-HE-Tag: 1754291983-546801
X-HE-Meta: U2FsdGVkX19CQNwhtsx/VsCddNMU6LK5r46LZ0YlqJxQq9lD9MqAOylXHAa9afgARt5uCwygKAgijFFNw1anr9tjpKoj4seXnnxat3gsztdGNFioJgKe6rBEWlPCLj8OWCO5QjPE5x1SvTHSAdletB+FaDRokaN5nuF/k8RDjWT6Yhel7JfZWe8J9G21QbSgEt798TNycB268knz5PCzQObBpy0Q3RAXpxYQVB3k5GR+nFtyD2kP2uctCp6J5XXXGoXutQrXnRNWwKtjh1MOZzeaExT0JTzkuHLaZ/HVJBDjyGp993tSiJLYA5cG//NgNZBETekjNFBgM6S/uzbMczkI6RJ/9BlL14p5LuzuZ1nomJl/Q2/0mOYTPJrgpl14+C44uyJvEYRSMxmRGe3qCpsENvygVnGZ3+4MqVmvSJ881enbSPJToEVJO4pLAS+UcNdoqrPNyHSntaLdNe/1PU2GNfPU4MT2/p1mEuc8wEtoRMCnoKoRrHeR2JrWHLdrR3iSBgz8/d/KpU53yi1Z1uzJSLA3ii/ApoWVdvOOWhHqFZTKoc9sEVORWKKJ/3yxLNOZappPaTwDCfx2CzWWLLKQO+vq+Flkoswf0sKQRU54bQS7+oNICYJHIWNgYjiTGF/qYNVSwWtu3uMyGJd8mCOV5QGM2/UB/33URVf/oIbMsjoiPgQt9fPLJrXWeweOQcmnbwJku7XyrZ7TRNOq02CMHgUzrDEwrluBSDG4ZlbwVHpMpS56B5jr6Dvg5ZiG+jVZLxI38Xv6aAnLIr3kZpdh6e3xH67WCiMsUGwQbfOYk8VShqvnvIqai2SbQKhDBWc6GnqtYDz/B69bxr545J42V0sBvTKEMphOgZdlVsBdN4eMPPuzTC7IIVZ5ikYB/ReHYCLtgWhOXkOqG5Adt4qzjFRFZtWt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/Aug/2025 10:12, Yin Fengwei wrote:
> 
> 
> 在 2025/8/3 13:28, Ismael Luceno 写道:
> > On 02/Aug/2025 10:29, Kees Cook wrote:
> > > On Sat, Aug 02, 2025 at 05:47:13AM +0200, Ismael Luceno wrote:
> > > > On Sat, Jul 19, 2025 at 17:17:09 +0800, YinFengwei wrote:
> > > > > On Thu, Jul 17, 2025 at 04:31:50PM +0800, Kees Cook wrote:
> > > > > > On Thu, 17 Jul 2025 19:01:08 +0800, fengwei_yin@linux.alibaba.com wrote:
> > > > > > > We have assembly code generated by a script. GCC successfully compiles
> > > > > > > it. However, the kernel cannot load it on an ARM64 platform with a 4K
> > > > > > > page size. In contrast, the same ELF file loads correctly on the same
> > > > > > > platform with a 64K page size.
> > > > > > > 
> > > > > > > The root cause is the Linux kernel's ELF_MIN_ALIGN limitation on the
> > > > > > > program headers of ELF files. The ELF file contains 78 program headers
> > > > > > > (the script inserts many holes when generating the assembly code). On
> > > > > > > ARM64 with a 4K page size, the ELF_MIN_ALLIGN enforces a maximum of 74
> > > > > > > program headers, causing the ELF file to fail. However, with a 64K page
> > > > > > > size, the ELF_MIN_ALIGN is relaxed to over 1,184 program headers, allowing
> > > > > > > the file to run correctly.
> > > > > > > 
> > > > > > > [...]
> > > > > > 
> > > > > > Applied to for-next/execve, thanks!
> > > > > Cook, thanks a lot.
> > > > > 
> > > > > Regards
> > > > > Yin, Fengwei
> > > > > 
> > > > > > 
> > > > > > [1/1] binfmt_elf: remove the 4k limitation of program header size
> > > > > >        https://git.kernel.org/kees/c/8030790477e8
> > > > > > 
> > > > > > Take care,
> > > > 
> > > > Hi,
> > > > 
> > > > I noticed this removal and wonder whether it could be a problem on
> > > > smaller platforms.
> > > > 
> > > > IIRC that code has been there since ELF support was added in one
> > > > form or another; and the idea behind it was to simplify the code
> > > > by ensuring no cross-page reads could happen, as these could cause
> > > > undefined behaviours or read abort exceptions.
> > > 
> > > I didn't see a place where that would happen -- the reads aren't done on
> > > a single page. If you see something that I missed, please let me know!
> > 
> > The offset to the phdrs can point anywhere and the entries are
> > arbitrarily sized, thus it can be unaligned, so we can be potentially
> > reading at an entry right between two pages.
> 
> The read buffer are managed in kernel. Why cross-page read can cause
> undefined behaviors or read abort?
> 
> Does smaller platforms have special behavior in this situation? Like
> can't do cross-page read against the buffer allocated by kmalloc?

Pretty much anything MMU-less will fault at cross-page multi-byte reads.

I'm not aware of any system with an MMU doing that but, I think on
RISC-V it's implementation-defined.

