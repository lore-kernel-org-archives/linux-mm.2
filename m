Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AC9C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5404B6B0092; Tue, 22 Sep 2026 13:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518FE6B0095; Tue, 22 Sep 2026 13:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1116B0098; Tue, 22 Sep 2026 13:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1E56B0092
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:22:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 958AF1A0563
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:22:41 +0000 (UTC)
X-FDA: 85242067722.07.D0247A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E310340007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:22:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F9l/h2sg";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNh8IajC2C7W4xAVN/5A4Te3DbNvUnFRUUUmja4mmRU=;
	b=TPQ3psGKA/P6fakKxvR6thLwisXJjMvVGt9Vd++QpW6WT9NjzXxviOMeXEdY5KxRPZJaNw
	pa5SxnLtn5slV1oG00hdtxJS5VpATyc0d9CuOwul2zw54yPap3KCq60m2dSW9yLC6OWX3r
	JYCO9nc64oN6+i8lki0rm+z5edv1jTw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F9l/h2sg";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097759;
	b=yhdIN8ECIolK2hQdh7YeiPeuNBPn/hmCJOzYtVPXRp+pDwxuqy8FqItrwkxclZeeNh0NUP
	wvjnFmVmH/tD/DkX4EIW1OPmejCrEKkhDltJh2fLqWe+QXbEfIuACmCTfSUR5KfM5MQ+Xg
	F4fyLd1cMESe9XLE6QRlMXpAK8P5C6g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EC096022B;
	Tue, 22 Sep 2026 17:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DCD1F000FF;
	Tue, 22 Sep 2026 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790097759;
	bh=UNh8IajC2C7W4xAVN/5A4Te3DbNvUnFRUUUmja4mmRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9l/h2sgeG6pItIpsl4UOUD5LPuOPYalAOj3lX7iN1SKQRQx/7vSe8Y8wJYuJaFa9
	 tegjTwQVFA9hXGIt+1oJvFwKspvEmTZEeRl/rL3Z+1/vMB7N90Y9ljH8EiqVFiWGMa
	 llb7G+u8p4G82Y3NfZpa4T6VyMnit/o1genoOGjAzyku0OZj1fvAIP0nPa5BRjaZ1s
	 0LsiYA1bWAjQ698sUHV9gBhPhcHOkUs5jCvX2Aqi8QkSHyLlAciZyH7C9FEowKSWF8
	 GvrRJLzG6nhqL2FhCQxRW0vNDBGCdIskECu8iSBeB5zhpcl0fRPI9Q5+bVasWrDLde
	 t0gfKdsjFaNOA==
Date: Tue, 22 Sep 2026 18:22:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <arK4XnDTuFpwPV38@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <arKv4qbF04KB2WxQ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKv4qbF04KB2WxQ@casper.infradead.org>
X-Stat-Signature: e39zbxrp7g8joyjtw7rnnau7mc4wzrey
X-Rspamd-Queue-Id: E310340007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790097759-917956
X-HE-Meta: U2FsdGVkX18ZxRecSd4BODPqeQcpeLa79emz0kHdrGkvgQsIl/smwuxPuoy3MHsXEaZP8KJdPBmjuilmxZoOF+bR+kbHP8dRv2LnfBoso/0s8rlTGci567qYLdjumIDQH/FO9fr6SXBkxqzlib+b7zZd6vY/nMxJsYUNKtWeIE6MNJ8VbVaNUheO1yHpqdWNZjkpNY7lTMJMMwF+OgCxBppwB83ccaD26nEocNU9416dwV7CT9ZlI+q4I2gP5aVDljgAEK1rQdWnDQozUM9T7vXczKRjCT4S0pDbjJUDzMMjUagE+FpRmiHYkrN1h+1B/DR2S/+ugwzTw5EfevPAPGSplDwSpD0FuBWy2OKQAtfdE4tHNfJfRoOhoz7uXBaAIKrkDGjezCkkfjYTo9WFqxwvA/jsY+EDjhzJMW8SozWRhTnmmS1k+6wYizq5HsjjAFcKZJXe0vP2b5UEI7P4cDmns74cd58aj9u5zJ2Pa1VwnkSL9isPgapuHqB7HasWYiC4h4KFxS3LBoLBTvNKdYkjChv4DBJksUqvACa61QYK84ONzHHMLyQ+Df/xz1oyV6xWlVT9JIVeBCQNNDr5u/Sk/dphd5pdItCcdkTaV9WYvFqwSRQApAHYl3AhDtKB7T4DiCiZjmYTbyZurAUQvGfZQupvKK1V9uaur5vwSOneVqnRXz7TovESt9hI7/FbmP1uxVP8tk2HoWSLgiqtdXc/lLHFz/weoDZXb+XycEKNWa8GL75QzsO1oXMk2bgAIsn3ww5sOVf5ggp9RyqeR9FEwVtp/pkdf1MFI/G2NzdeDuldbk0SRF8zXoCZq8QTHNvS7epVJw7j1O1f1/3JI+He7Ny/NQL0RQu05GJ4r3fOhw+aqPwbcTMAi4UtrkK+7rF2SX0e7quzYSmSqtdP0sLny6skPlQmIrmzfuMj2ivTZeNFt3b5NHXrSnEJRxfrpFs4O9KqHGI9KIrDmzH
 qzyJ+w3x
 O0npjSmnT/HTcbvTv0loshEEZKp9LEzeXTi3fdumFBDEMQaokLuF/9VP/QCbMJap/GKQdsQjViXlwqECDdZ34mi5fLxCVxYcAfqaSv9cEVf+qg9WwpjEMByiVnQZ7tk599kLYp65ISVm3K4IvAMzGeuMp6ZknLRo7BjP8IVv1M1m5Pdv9wqBIVOyDufac8g/quTPAZdDMUi/riWlU0AqXUT2U2949r+cW2MCtOQAQ53x2BzoxbKi4f/MPgLI2ccJHpwn2hRhJDOKB3WemgehdhaWkLFIVE9ItQ3OPDbNN4mEoB1Vo2LfCEC+ntBwK3l1Xy5CKRkQsaJRs/Mw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:42:10PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 22, 2026 at 04:35:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> > m68k-motorola required the biggest change - since RCU page table freeing
> > uses call_rcu(), this means page table freeing can arise from softirq
> > context.
> >
> > This was fixed with an IRQ-safe spin lock used in both get_pointer_table()
> > and free_pointer_table().
>
> You don't need to use an irq-safe spinlock for softirqs.  It does work,
> but it's overkill since it disables hardirqs.  If you use spin_lock_bh(),
> only softirqs are prevented from running (and it's safe to call
> spin_lock_bh() when in softirq context, just like it's safe to call
> spin_lock_irqsave() in hardirq or softirq context).

Right yup, I know _bh() is fine for softirq, I think this was being overly
cautious (for sparc32 you do actually need irq saving).

But this is m68k :) functionally there's really not that much difference, and
it's over very few instrucitons so the delta here is likely to be functionally
little to nothing.

If I need to respin again I'll fix it up!

--
Cheers, Lorenzo

