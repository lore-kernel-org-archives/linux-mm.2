Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C476C79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6056B0093; Wed,  9 Sep 2026 07:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E3E6B0095; Wed,  9 Sep 2026 07:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC436B0096; Wed,  9 Sep 2026 07:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03DD6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:08:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2420BA3AFE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:08:20 +0000 (UTC)
X-FDA: 85193949960.05.F252FB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D86E160002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:08:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaTpJ5ov;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788952098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4mPQZ86gp5FDwQ4tHqlyfsOtYqdqNDLvVyVaC4A/Fo=;
	b=M5f8tkqoLYKx1ESD8LIytWRL5OYyQFdLolFZlmfHZXjq8HOq6bsV8myJarI0VrDqFLya6B
	xAxWi7dSHEuPRrX1bCqrGvX0LoyS1RmT0NoMldvZxs/ElGAdcuQHZaKg5PB+wIVQpsrabY
	B/sFL+jAQlHtLQTgFWBSbAjJpUsUJ/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788952098;
	b=yHitUqL5InRlV5dPt/M6lgu4aJkZOdBpX5vvYGr5osElzmli1xl9KZbh67+3fB2H8H4Rcx
	efbYqih7ANQDhDGtDP0lIUmmP7m4Q0HxMhEPuakdBqtEDOAA2djM09dwzIIR7Z9qFCBxBE
	O7vX7G/by/4Ho2LhB/ioj5Tby/SJIrU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaTpJ5ov;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6D7601FD;
	Wed,  9 Sep 2026 11:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F9D1F00AC4;
	Wed,  9 Sep 2026 11:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788952097;
	bh=n4mPQZ86gp5FDwQ4tHqlyfsOtYqdqNDLvVyVaC4A/Fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QaTpJ5ovoTiEG+gXq4D4QRjJgrK/QkDaAvE4t9yf2p1CDXfWR+kPkM4RvUM0qdfPJ
	 YQ3u5ytOfaVK2InZ/CGWXhSaMh2xZGgB5cMzAuvnJWAkL0XnASM+7IEN4Mh5mQR/v/
	 23xVaM73u8uzFcGxU4t1Ngaq+BDhm428o54Sxl6mcGruZx3hwkdRUas8xhLW+8np6o
	 1FCSepWEU5Qtr1gN3/1lPqwwWSfxlmy6GHgFq4rT9aBoF8CazzfpBWEzsvaBIQ/txk
	 czLEOp1wjtukmiYmMeK+KJpQGgy7iNAEV7FZIokob8wTGUUDEcjvf9Oxi9V03vXvLr
	 Iqy39qtZl8jxA==
Date: Wed, 9 Sep 2026 12:07:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <aqE-ABWDmw26OGK2@gremlin>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
 <aqEl9zv8M_o1yW62@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqEl9zv8M_o1yW62@thinkstation>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D86E160002
X-Stat-Signature: g4hyfa3o6gp6x83f5pw4emmh8gs5wh1u
X-Rspam-User: 
X-HE-Tag: 1788952098-169762
X-HE-Meta: U2FsdGVkX1+ZQoFfLUW1qty7fSJifVOzR7M+uY0do9jZN2+ydQTbka6fQDHE6dznkKXZC87qI8oB93LQRwHlk7NVQf2nLh8gn1/6Aj+2XTynPvFxPKBmZGiUiVh4gTPCoPFnwL0z9/xtOWsBsgGSuIJ94jMFQSmSpUU48V0DWioXCc6Q7cRWknEGpwT6q/fGhzJ03pAhO448WMvjjNUcc11Cx69LE7Xh4+CvWMloDN+4aJYBEDQowYqvNaR7Zl3YkH72zAeDksW9jZsUU0Yepj7vazIqLiUJKP0wsqtucrkFo+3AIbA3Q2Uqkd5vpEMKsFMv80c37/7TsbbGFBMLqvkHnG+bBJq45rNvGRoFz2iVdNuaZoSSWh55J/IxGs4hwSHl7RC8U81iTj2mmjg5CnynAlUKdCA6QLBiT2lxs30bOQ1bQb/Hc5YX3+WjcHWpSV0U8XhB4jtf466l3RgaDfrT+XNhbQ/CReE89MDus9Y2TQpzOj+J2lG3LDPz0PXQuuEpaGOuxQ+Snx1ZJCyavCFSi4B8Onb4P27An5rvQl9H2ObNElTX/9FDdSHFUxTr7RsNOXftbAowV+qtteOakuxGI/NTA4qTmPgcyWYseL6CLuIrCeJq9PDyPdGgyzR732KTDflJobqB3z+0yH/ytpgqvKrI8ltzB2VeUSI4NonwjOWKld47RAl8ojLRoR1dyJi2zOPAHX647/omm7/IyeeWuNusvT2+IPyMmmkWtVuOWAjtnqXoeH0cXMDz4V/Gs/JtAVYAjPsEKKUrGooFsPedSfJfsFxTXD/McblR1XfsJ/R0VcXrp+yXs6mjD/YcBApdd2ynr/6RIbOiNWaJ17TwCctGGy6MGNck0WU8sbUP/Pt9k0Whw8ssjzvTZc6PsLA4YBEF0MoHUAZD33ZYxF+gHusk3RQgt0mHjekL9sN68JH4ioRYH3bH89AJidii15ss8k5vBNoEAbvwYrC
 gQW7HaR7
 u7PINh4XuFxfZdwfJ7ZLQMArXWByuIjjhIFDU3L58UYWbFYxDSZD3dKe40ThOxhaTKzLLHXf5+5sFOz5UCnEd3Dsn1b7zE6jGmlxHy95x9asOkqKrxzVh9+1dvvBjhP5E2RoxRGNJCZrTph009G8xbxoO3BB5RxgW0FmSsAvMeOXLPRFMWHl6Sqc8IS0wB1gqNjpMXYutK25kYokYelCYqpgH16m3KSIt2LAVTU8zpQmp9WwiKHLsPd6Pzo6PbJnqUMEUe8G6S9ryEf9evfkMGpK7CQjSbfB0iGQhcwzK+ab+O/0CoJVEzKOsy6TCapBRQTRr/qbtiFRmZBl9I34z7NEXk0Ugx7RJAcZ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:26:03AM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 08, 2026 at 01:32:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> > The majority of architectures in the kernel defer page table freeing until
> > an RCU grace period has elapsed, this series converts all remaining
> > architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > altogether.
>
> Apart from few nitpicks, the patchset looks good to me:
>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks! :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

