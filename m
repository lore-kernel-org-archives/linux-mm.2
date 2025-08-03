Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8BCC87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 05:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5D46B0088; Sun,  3 Aug 2025 01:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556F16B0089; Sun,  3 Aug 2025 01:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C866B008A; Sun,  3 Aug 2025 01:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 374B06B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 01:28:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 781851606A7
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:28:42 +0000 (UTC)
X-FDA: 83734316484.17.F85E337
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3557140002
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:28:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk;
	dmarc=pass (policy=none) header.from=iodev.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754198921; a=rsa-sha256;
	cv=none;
	b=iqnDj0ozGbSD0WgAlw9dthQmr41ANm4Tz831SRql97FKnnwQj0iql/vjZDlwK3oXIzxPTX
	WTvHQz4/ea/vv2Kldb9pGhkFlWI1hqUG1mRCrtsaBHs7r+4p/Vgfgj1tcQItVE+2n5vVn7
	FIF9K5wXFPVMizB9AWPYzdbW/k3FXKI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk;
	dmarc=pass (policy=none) header.from=iodev.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754198921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zzAIbei4VwYcADA0Wqwf+rr5aZ0Ef0aFi1JN1mTVvjg=;
	b=fIGuRE+Ev8PKw4c/adxmOqKbW/K3zQcIWcL91sAfIWSMUIyvKj2Pmdv5iqMGZFArj72ZUJ
	cTmTITagABv6BWOg/JFQnMnFD7S4YhRKNVvgkdTDhoYQxadd/UQAbgYbwAoGpG9+wU6cHb
	7Ad8AwNd4DdS/NdufgaCfIwsLZMOQkI=
Received: from pirotess (112.red-83-45-208.dynamicip.rima-tde.net [83.45.208.112])
	by iodev.co.uk (Postfix) with ESMTPSA id 5B7DF4547CD;
	Sun, 03 Aug 2025 07:28:39 +0200 (CEST)
Date: Sun, 3 Aug 2025 07:28:37 +0200
From: Ismael Luceno <ismael@iodev.co.uk>
To: Kees Cook <kees@kernel.org>
Cc: YinFengwei <fengwei_yin@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	zhourundong.zrd@linux.alibaba.com
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
Message-ID: <aI7zDXb2VpuaHHYi@pirotess>
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess>
 <202508021029.7CC8B334@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508021029.7CC8B334@keescook>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3557140002
X-Stat-Signature: rjyqx18h9mxtfwn6794odq4geuax6i9s
X-Rspam-User: 
X-HE-Tag: 1754198920-73916
X-HE-Meta: U2FsdGVkX1/6bvBUbmHJl7xmBQQgVSN6JARJC6zmVTGE7Dl3bjBwRsWBTCgxo+US2HC47qFZnVdYKBw6cKJHOwUw9E33ic5MXfBw04na5haSCYTALoZoNwvKj8SWhjRQthr9IM7ZMXuNqwZUSLU9ylRp5b61Wpyzva1bgmTdCGRxhcEAeAepzL9okULnQq6TZdLRdycVMDnnX4hnxs+Y4zMktlCZmLs/m9Lh17+AGZaSWaw9bPSMUlUhTQMa6OQayOGPmcYyc7ZtWURJbV+ed8oxK/ttUo4nBpE5PMiBzI6rgociotQEThMK3kL4W/AwfN/VB5d/jkxuJ/D8E2R95ABDZD6nN9kdm0otoUCz7t5sNmfuQSGrFVVEjydeb4D82TL5w92lB66X4guprBJ7nfRDmq6mapGMGXHqR2MUexFARro3ropKNTW9FpE7qb8t8gc7ZOYpMDc3tJp/tTn+rsZgJoPlj6bkQUCJ6pO7AxqCqnU2zpqW1QiYR8c/H43Jm0JURSVIbxRxIxNBmlNdAQ3yTumPwpvPo9AZgXkzlZDsKfySW2y/oJ8l+tln11fDwqpSvv5xuyizKqih1S+VZf6uyAc8nKuOpDgv2jpA04Onnfl/+AfkVx/KqZlKyMbJufg+O03PYKJpaUC3Z45zdRjyaVPp4jv2pAZchDRvMvkFTuXKbTsuKJLRccdW71NGic5jnaEj3Bbs8ile2U0LHsfoWtbEhFJ0cBKlfUI4/ubNTsV8HSsJnT3NThftAtM5ek9AxhJYcy7JhANdFw/XpuFD/QjJapFOpi3dK1nrjHK3ZHUzIT6nT4JNMIlxgU9yt+mkv5zP7CDbaAOeUCgy/WMs84ByVRMyRh/L9LlPUx8aALIk24seWHqtRE03QPD/vlroPLry99W0c7NNDeFStgiGBUDJ5sdK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/Aug/2025 10:29, Kees Cook wrote:
> On Sat, Aug 02, 2025 at 05:47:13AM +0200, Ismael Luceno wrote:
> > On Sat, Jul 19, 2025 at 17:17:09 +0800, YinFengwei wrote:
> > > On Thu, Jul 17, 2025 at 04:31:50PM +0800, Kees Cook wrote:
> > > > On Thu, 17 Jul 2025 19:01:08 +0800, fengwei_yin@linux.alibaba.com wrote:
> > > > > We have assembly code generated by a script. GCC successfully compiles
> > > > > it. However, the kernel cannot load it on an ARM64 platform with a 4K
> > > > > page size. In contrast, the same ELF file loads correctly on the same
> > > > > platform with a 64K page size.
> > > > > 
> > > > > The root cause is the Linux kernel's ELF_MIN_ALIGN limitation on the
> > > > > program headers of ELF files. The ELF file contains 78 program headers
> > > > > (the script inserts many holes when generating the assembly code). On
> > > > > ARM64 with a 4K page size, the ELF_MIN_ALLIGN enforces a maximum of 74
> > > > > program headers, causing the ELF file to fail. However, with a 64K page
> > > > > size, the ELF_MIN_ALIGN is relaxed to over 1,184 program headers, allowing
> > > > > the file to run correctly.
> > > > > 
> > > > > [...]
> > > > 
> > > > Applied to for-next/execve, thanks!
> > > Cook, thanks a lot.
> > > 
> > > Regards
> > > Yin, Fengwei
> > > 
> > > > 
> > > > [1/1] binfmt_elf: remove the 4k limitation of program header size
> > > >       https://git.kernel.org/kees/c/8030790477e8
> > > > 
> > > > Take care,
> > 
> > Hi,
> > 
> > I noticed this removal and wonder whether it could be a problem on
> > smaller platforms.
> > 
> > IIRC that code has been there since ELF support was added in one
> > form or another; and the idea behind it was to simplify the code
> > by ensuring no cross-page reads could happen, as these could cause
> > undefined behaviours or read abort exceptions.
> 
> I didn't see a place where that would happen -- the reads aren't done on
> a single page. If you see something that I missed, please let me know!

The offset to the phdrs can point anywhere and the entries are
arbitrarily sized, thus it can be unaligned, so we can be potentially
reading at an entry right between two pages.

