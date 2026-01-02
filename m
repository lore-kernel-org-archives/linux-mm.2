Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC30FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9896B0089; Fri,  2 Jan 2026 13:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE1F6B008A; Fri,  2 Jan 2026 13:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2336B008C; Fri,  2 Jan 2026 13:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF1136B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:04:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDAFEC2D07
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:04:35 +0000 (UTC)
X-FDA: 84287798910.01.15D0F38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3AB2318000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:04:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=m4LVIjF3;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767377074; a=rsa-sha256;
	cv=none;
	b=ZDFyswgeMu+jhjD1ou3pJo+LrsQyKzb2VwLIClRjoJKF5qsRMOkuY9E25vV0187bAViZxx
	cl9bRUidLFFGV9P2H51R7aDdR69bUfp+E1LkkmoyuNOkdoXZmopqr9IfDEImOBpbsZA/QP
	wFVnL68l/BMjKI3VmA5XQn+haBPH0do=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=m4LVIjF3;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767377074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WK/bgpNIq35gMtTCTtjcDTohaC0NThBM9ONBNETbhsU=;
	b=fotNml7tg9l5pI/gRQFl7JRz5bv23Av1ZS+DP715DEzhhRTDug1bZs7FDdzAaEKz9Od2H4
	mdEvhwCE16mVHlx69l0PtRNFz6Hel7Id3OudzwY+JDklUc/6oqlUiO0Pgr0OPsMiRfcs/6
	Awr5gNVOcseqY7L0Jyy18Lmre88PYrg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F6A16013C;
	Fri,  2 Jan 2026 18:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEB7C116B1;
	Fri,  2 Jan 2026 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767377072;
	bh=9Q3BCyqOSN+oJgFNTsghHD+u6iamA25tuC/5QoeUzQI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m4LVIjF3/x1+uJPkmzdQVneFBhdr/tNflWJvzon2aAKXFzapOWWp8T9zfIUe6d3Fu
	 /gElMshb/CMy7xVVdFVFtfq0zPQL7Po74BU1gTpXa7kMFv+gt7F6M9I77NtH9DPO1l
	 PeYULVm06wYXARz/UnbL6bNqJludz4ddsr/It9s4=
Date: Fri, 2 Jan 2026 10:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, Dinh
 Nguyen <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge
 Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
 <corbet@lwn.net>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Magnus Lindholm <linmag7@gmail.com>,
 Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Michal Simek <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, Pratyush
 Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, Russell
 King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, Suren
 Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily
 Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH 00/28] arch, mm: consolidate hugetlb early reservation
Message-Id: <20260102100430.623bc1d19b867588bc64f890@linux-foundation.org>
In-Reply-To: <aVdswNM9PUN6Kr8Q@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
	<20251231172714.a7fe44e856c14fdc8fe1cb43@linux-foundation.org>
	<aVdswNM9PUN6Kr8Q@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3AB2318000E
X-Stat-Signature: j8k9a4jgiygor1erf9q5m5981j69pp94
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767377074-611252
X-HE-Meta: U2FsdGVkX19kLXGSBGqGxTKXaC+qhgnLXLAUKVFuCeWW5RCpBn/nWZZQJdfkYHjzYCl6ZKLhRrCL20eF5sJPwhvyJDhi1gAKVEvm5kDeEoFXFJekjVfHJzUksoeY9G0tYAi7CqcHDxwA9UyQq67IRe3llOXQTveqXbozgn+IT1NkeaMaWANbbBv6pHFjUUlLqd+cQI5m1fppXBGmlmXEBDIG2AgVxlQMXVVxdlyrxe+UK/dTh9iuLyO1toJESWPSUzd46kRUFNfZi1LFC5Z6cCoJg3RjmWZ5GeNIHM5g/Jd9q3CUvmIJqqqE4fty+dGM7ZzJRRJ/mgEvkN0lfGLzwBQl+rssu1kDchwWyHEw2VBFQNP9iJ8DwFnIC7roHW/CDfuxLiYVKmIJr+L1qc6JC5qe+FFvAR7fLkdHsW3hiYM2F+o6WevtdR7KARbOCPnDWVjehBWrDdSFeh+Sf7WzFvBtXPkv0T8Al8o+zXV6+puxcJulzMaI9T3BR2mKiXcBga4n76nxNajcnTa3hPiFCrdKBC7ao1zEStPJyTXcb5PGadR6OijZDu3UI+WKaXkcobGkEJiq/Blk8OFr7YhEPUM4KbMzPV33K9HRT++A/2T6W1hRTKQpRLQ7RnbrA7hM78uVwbiTMEC41GjwtvDvC/WEz8pmXZs7qXbb7EoEicjxd33i1QRSPEJ0NSVTGG1zds2Er3GVjXTQAy0jjBQLZaNxTcSe7rOUPr8M06wURbCJwTIzszwhmIklbeDk0WwUhDbg3JWdC4fJFnhei6wKOulwgciV2KenFUDrBJNykvsqGwhgtkIyXSDzvjr++wvB9f7p6RE/rzA5dhtUgw4C6qKAC/ZTl4/CGrxxobRFO3Mn7xxaaO+wgJdi5z6JnJ/HYhnqAKIa8aqDPOje1+zmD6D/K9eJE6xZnGqmwihauZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2 Jan 2026 08:59:12 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> > > I tried to trim the distribution list and although it's still quite long
> > > if you feel that someone was wrongly excluded please add them back.
> > 
> > I'll add these to mm.git's mm-new branch for some testing.  I'll
> > suppress the usual email storm because 41 * 28 is a lot of emails ;)
> 
> kbuild reported failures on some configurations so I'm anyway going to send
> a lot of emails for v2 :)

Cool, I grabbed v2.

