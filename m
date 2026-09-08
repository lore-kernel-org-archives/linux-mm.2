Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21074C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205DE6B008A; Tue,  8 Sep 2026 07:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6886B009F; Tue,  8 Sep 2026 07:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6586B00A0; Tue,  8 Sep 2026 07:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF5656B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:30:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D39441C2578
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:30:11 +0000 (UTC)
X-FDA: 85190376222.16.AED0B9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2E1A8120009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:30:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BbzZ3F73;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788867010;
	b=wDqqUcwrNGWAocBXtD9OtxXtR1AgedbwfuEY07iCI6itfbN5Mmtg0m3zeGA74wyomB9wAS
	qXdvKxVy84hhCkhBy26V/vSZT9+RvHKBJqvZ6sjm/tXW7pi9gKdaQQA7k7KU7pm+us5f+p
	0HERrRhNl9oaTTuclrU+sGL5SwuMvYM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BbzZ3F73;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788867010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB8nfc2dyoUj8MneI5XtqKUJWAX+H2A9jp3sF5M1qbA=;
	b=cBQQAN5Lf8gj8Cr8Q1ZYsnEY3I1mri9xJZGSQGhizEipXhtuf1Mp2GBZSb8DYRvlX1i3LF
	OGunV2BxqeYEowreS3aE5ZpO11OBUZ79zegZxIlojHhrcXxLPQ9Idtpsj9jbmJWnM4QG7N
	Cmsjg9GebHHs0ROBdQtU5qK7OgxbnEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74F4D43C1E;
	Tue,  8 Sep 2026 11:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CBD1F00A3A;
	Tue,  8 Sep 2026 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788867009;
	bh=mB8nfc2dyoUj8MneI5XtqKUJWAX+H2A9jp3sF5M1qbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BbzZ3F73x9vlPWvAcrfnuEIBJXW3qsffsRXzmqRI35CWZGCBYksgG+FZ6D4aufx7+
	 sEVq9yImHXZGqNWFVp5OCg/tUPoqmbCnXM4gOVpEztvlmpfzA1qGnFHu5hqumBWzdY
	 N5H85H7ubmL/KpLoi3BPX0MUJ8xr61MTWOAacXoR48MSTMJ0Wfiiqe1Y/y4kuLcp+l
	 khOBR7+6+n4ltCTDSLtuvWLW78S/WOu2iBGYFFag5m3jqVXrl0QqQoIKHO1R75ph5X
	 Qb1cRBjIYoRUQrLjUPvWxDGa1pvp8BiecTbRNMlM0odqliUSIGX+UuU4BPhFAXN8b9
	 dTjdPKOeABgjg==
Date: Tue, 8 Sep 2026 12:29:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
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
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <ap_xj3W3SjsnRBXv@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
 <apbUpMDJglS99_yK@thinkstation>
 <apbfzUwBQyxe3P9R@gremlin>
 <apcH74QsR5I-DIbL@thinkstation>
 <apcJhtvnd45EkjJI@gremlin>
 <CAJuCfpH_v4YU+hsQDU_yQ4HZDf-2C6DuiJU5PGL+uVAsTwkZug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH_v4YU+hsQDU_yQ4HZDf-2C6DuiJU5PGL+uVAsTwkZug@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E1A8120009
X-Stat-Signature: zuajxodqqf5wkbftqroy1x83dxtrkr1s
X-HE-Tag: 1788867010-46680
X-HE-Meta: U2FsdGVkX19oNJ2huAQaKLp/YvOrgjLKg8vaezWcAk9lDssP4tENdnygxaN/r031j6l/kqe9hv78KeNnt+hzHnhoU0gGjzJbC4nDyAsrtf7HyyoEYIodUEHmtO9T8Z1asvYsfg0Qii6vVKfdaJrPQjzrZzGcR7tcPrrJH+QxxpAJUHECFn1lEQPbXEVwkKL00AHUtQyMtHbSMCAi2+dlsM8xqIe8VRE4+vzAHzt0u8eYUBEoMpsCoAqurLVOP0aNI6QUE5XrK82dxXe2dX1/1npONOHkR75lX7R09zxwrcHjHLTnPlCAYCBtKH8LR/Ejj8He7w+5wnCpuKkA12GxT7Gk2OQAAtLctfuZdfrBGbk6uEC2PFYdQ8oZIC5acJiev8QWmbokw0GR1jFyV5KEiuvGW+j7Jg27Ca3bXCl8zJ5c51Kv0nMH0FmuGWPbfljr9WcvNwPRlwyBGObXS7zBLnF63L/7nn3gN0M2u09QkftTzTgvkUlR2fLnPemTPI1Rv6jNljdx9jceDT75Vy0GzWoZ8GId1DucSKADkwZwvXMHV6r2AThV8o9qxccQyDWrK3LheHVnBgnZA1I/9vA2bh9GzeFugEaFFZLKCO8AmpX3vrw439KVevZN3Jvcz34utTQ+vqZsWELgAnWsPz2F0EAheKqao6hfQXU/EyeHo4bx17PyfGnTYzZ0G6hWTzL5OT4XGO+HlCp9JXbajq2k2j1H9P+0TkemSGnQMy5C8iOcXutNg/wVepOhjaI8CzB1nLw/rVohmjAg48OHEjJWQgUnrAadaJqy9eBOGmboqGnRDyugBMFLVkvsGEcXcCyWYb0miE/XwR/J/dB8P/qFh+5mJdItgpswmqu5XBUdPKVjUlwkXSju4jwwrKrCYCGwf75SBBTLJ7tHyiY45RkLs/ab1K42xItfSBbwg40kEhDSANX7o6kXqLvJq2fwSJYe8WlLUwkB3EIFIrqDWFb
 nLyzukI4
 AR/OPDhzaNp/IZBNjNvL21nuOJnkusLJJ6THaGEqu3ooafocQbeJ4EGn6jjA92L3TfOMr/Hy8wFiAYxv7S5seK7J4nIH3KZd11TuOL4zfeFJoFVdqT8c3UR5A/JM0EPaUow7Sty1nV+idk6+T6CA9LHpGjC3twtWHyYaO1ts5hdiZ0MnLbLwaDGOy3eM1jUGjurzBVJoVZRnG/nyI+QIReKg50kGsb85DzoeH/y5zcZtw9eQNAvxEDZTG9iWvO8Oy2zh5hUcaDDnXnqH3dbuU1Nr9fme3zqFNNa8xnj7H0rAE5byIN0IH1xDmtYsqP2DEYaBxn9CxzTLP6EtPhxI3vWb3987sL1RGfPB7pyR0j+cSZNrAMd4gvBspwr6sh03DJ7sfPhA7VfYOafBI6lANb+JxWsd6hfceliE6pk8F0TQ39PY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 09:53:43AM -0700, Suren Baghdasaryan wrote:
> On Tue, Sep 1, 2026 at 10:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > So, maybe something like:
> > > >
> > > >  * Note that free_pgtables(), used after unampping detached vmas, or when
> > > >  * exiting the whoel mm, does not take a page table lock before freeing a page
> > > >  * table.
> > > >  *
> > > >  * As page table freeing itself is RCU-safe, page table readers can safely run
> > > >  * concurrently with page table teardown. However, writers cannot, as without
> > > >  * a lock nothing prevents concurrent teardown.
> > > >  */
> > > >
> > > > Instead? What do you think?
> > >
> > > s/whoel/whole/
> >
> > Haha yup the inevitable typo...
>
> Also s/unampping/unmapping please.

Ack will fix on respin! I am the typo master ;)

--
Cheers, Lorenzo

