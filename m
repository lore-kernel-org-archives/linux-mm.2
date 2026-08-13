Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A19C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B546B043C; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C506B043D; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A196B043E; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C146B043C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 655F3A223B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:24:24 +0000 (UTC)
X-FDA: 85095710448.17.D742F54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B7C3740004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:24:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omdXoTrc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9U0BwCwOlA2q71JSGR94TVR71so4Y5WWmqxkhrxnts=;
	b=dzjgkHhVo+L7eryrdG25dsRr2FKKJZ/fqIlFh8Rofky6vmWf2e3uvaZFhccMZ55If8zJ6W
	8qjif2n7T2Zt41nzrAxU+keY2KxN9aU9/eSjm6PAY1MRCF8vBA0nQ/ubKeDgAfeCPMtFXu
	jVZiX+oNMzRQK5ZD5Ae/We5AOCqZ5Q0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omdXoTrc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613062;
	b=2EnlL+5v66gnBd612qaa89dDwtA6mxGB18pmrVUed5Xpos4MwedtsLzHBtKJGjtHsuAsXm
	In+lnPYAvVGQh6wpX0B0LOgFwPKJgfrAivHVZ370mbcNN7cqziSpsN18P9qgsuJwOxP8Fu
	JrVsjrgf4eInE69fcmoizygASkEnbuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43205600AF;
	Thu, 13 Aug 2026 09:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4211F000E9;
	Thu, 13 Aug 2026 09:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613062;
	bh=M9U0BwCwOlA2q71JSGR94TVR71so4Y5WWmqxkhrxnts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omdXoTrcdHsNFbdpmr+nH8KapdBZLg20P32XW68CN35Qw/yi47HqzWe7UnaEo09F7
	 DjBX+0/SEXz8rEJiffc/BKCLjU+IK6cMW+8SN8F+ApLdfhGShIciGVTJ2RMzbj0oeQ
	 /yZuCV2V4cJVCNOJeunr8tweiTSIDm3lQfwUOCV6pCMTXXlkLAESrBVeKM4iHUeBwa
	 t2lQwQcO/fDNi4wiUIYYb+nIqZV9QSZjdtNGWwHzLkx6tRZwp6b1DerpmcwK2D+UtF
	 6zAfWcF4HAj+WKRIcF76jj00LjO2mDgOiWVNxqJHpiLW5CZc4f+LHcgFy7KGh2T/am
	 HrLl8ZAGFcBDQ==
Date: Thu, 13 Aug 2026 10:23:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Nikunj A Dadhania <nikunj@amd.com>, akpm@linux-foundation.org, 
	baolu.lu@linux.intel.com, bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
	den@openvz.org, devnexen@gmail.com, hpa@zytor.com, iommu@lists.linux.dev, 
	jgg@ziepe.ca, jgross@suse.com, jirislaby@kernel.org, kas@kernel.org, 
	kevin.tian@intel.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lists@steffen.cc, luto@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, pfalcato@suse.de, shakeel.butt@linux.dev, stable@vger.kernel.org, 
	surenb@google.com, syzbot@syzkaller.appspotmail.com, tglx@kernel.org, 
	toshi.kani@hpe.com, vbabka@kernel.org, vishal.moola@gmail.com, will@kernel.org, 
	x86@kernel.org, bharata@amd.com, Ananth.Narayan@amd.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <an2KYgqMIoy6VloV@lucifer>
References: <anXvODEvV4f_Taj7@lucifer>
 <20260813055544.25567-1-nikunj@amd.com>
 <an2FdPPOWT50lLD4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2FdPPOWT50lLD4@kernel.org>
X-Rspamd-Queue-Id: B7C3740004
X-Stat-Signature: z86zrqrhi8mu85hc4cqd1j5dqxcrh555
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786613062-132329
X-HE-Meta: U2FsdGVkX1//wesp1dzsTUHQtV8Id3AW0UUz6OfQcyz0cOqY3w4j+DBOzzn+yknG41nuFjl11jSaRnUvmiAfHllvlu40YSnSvbpV4fFqSlMFOfDVbKKfKufPtiBRt8z/y98R6Z2p6aEmuoIv1eGTLhc1v3ldcIypd+5akkG9lLOiJyy6tg83V9t74n1kslFr9nywB5nwE+YbjiDv7e99Bro4OokH0Cq+q2/NiuKJJdxGqjBOqsdMvhWTiGabVlbD+4NKMMcdyC3ydFsb1YM4JuJWzHvhUOYhNQm/++CKP5mJ06tJg+bRmWk0cxhPeE2T14sXoA1hjGF5eYu3v/MtMXBBB7vmnons3pWkEDk/ehii3e/WEfjoyPPXpYTLD/+WS9S04y3K0n3TCoAGLRWe3RDfVognql3rzuLsUQH3C5MKVMEeORmOw7l73Ln5UtOZYMaNoqv3Z/j2E0Tz8JI5JQhA4cWO0F/H7LRw+m7LZf4zduUSvysIha8tQJs9W7zR6SWjhCBmw2oXlSO2XTrmdwD2te4zmYwX6ivwYuOwx3+Qz5yZawuGgP78h6L9VerBe27Sgjp8dK4vdj2Afry7krYZ3HQ4w9qMjSIgHQ7JTqng+f90g5tgG4inRAR0CS+vQNKggXo2923xmGJtePpyPwOcNj8z/TumcJ2bXjVqBAzBi/Mq9tw9WlnxT3k1yz8Y67uLv+eKFLJTJMpFd0zUue+oks4h+b8vsLGcqERlA8I2Mz8gcAA3OVqC07JKlJY6vLf42uzG94wsYr6Z6PaN7Lkjnrnubt8pzKq9BoDu1G5J0qY18/BRlTyiTbSq0TZ9n9huSncZIn1QcrMkOwl5D+MeA9fcnwQjYvZ5hcXXBl6sYbMppTBvyKv4OwjXsRCh4B2dSuyVZ8loNsuzEAfytKuyV5z43JXZ99mQZNXtTMd1/+YGoAySHkKirRHkSWXYUL7PaFouvtzr4Nk7ooe
 2tFosJff
 BGn13m54WfC3yB/S0egeLW7d/9f18M9BZhbcdS8oxVx7qt0m8mx7OhmfCfUcNkDHOdRYClvGB/JLUEP7whG9bg3ND2nm3Ov5e4nxFzK/g8QXDzt9EqZucjHlYt/9mxQItNhXVDDXEpndOgFCTPc05edsQWrWaHB6gtH7U8JeUrNg2gZJDmT4ehEn+E567f29+wMsuvVASqUFTfxqrkNA8sc+/h0IZq5tX+dGrQIdntepzUgKRkAuscXKUynQcS/I26D73oK+D5SScDUkVBzDjnf7P4tV3fWvdW5nJYO1B7Ql1gc3BHNhBkkhAvicTyc4UagSEAUWx5vYjpEm89HA6ymaD16RykdSkvbE+uA5fGtWSh8n+6Wa/p81FiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:51:00AM +0300, Mike Rapoport wrote:
> On Thu, Aug 13, 2026 at 05:55:44AM +0000, Nikunj A Dadhania wrote:
> > On Fri, Aug 07, 2026 at 04:36:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > +static void poke_vmalloc_pages_safe(struct page **pages, void *addr,
> > > +				    bool cross_page_boundary)
> > > +{
> > > +	guard(mmap_read_lock)(&init_mm);
> > > +	poke_vmalloc_pages(pages, addr, cross_page_boundary);
> > > +}
> >
> > Tested just the proposed patch from this email (without the rest of the
> > CPA fixes series) on the 512-guest concurrent boot harness (details in
>
> For this fix to actually fix anything, the patches that add locking of
> mmap_lock to CPA are needed still.

And just in time the fully respun series (based on tip tree x86/mm) is in:

https://lore.kernel.org/all/20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org/

Please do try with the full series applied.

>
> > [1]) and still see the memcmp BUG, I havent hit the first BUG though:
> >
> >   kernel BUG at arch/x86/kernel/alternative.c:2727!
> >   Oops: invalid opcode: 0000 [#1] SMP NOPTI
> >   CPU: 1 UID: 0 PID: 485 Comm: (udev-worker) Not tainted 7.2.0-rc5-pokesafe+ #42 PREEMPT(full)
> >   RIP: 0010:__text_poke.cold+0xdb/0x2af
> >
> > The instrumentation captured the following before the memcmp BUG:
> >
> >   SMP alternatives: __text_poke: memcmp failed at addr=ffffffffc06ce1bb len=4
> >   SMP alternatives: __text_poke: expected (src): 2e 2e 31 c0
> >   SMP alternatives: __text_poke: found    (dst): f9 b8 9b d3
> >   SMP alternatives: __text_poke: pfn at poke time (vmalloc_to_page): 8ece
> >   SMP alternatives: __text_poke: pfn at readback time (vmalloc_to_page): c6ce
> >   SMP alternatives: __text_poke: page table dump for addr:
> >     PGD 2f042067  P4D 2f043067  PUD 2f045067  PMD c6001a1
> >
> > pfn acquired at the start of __text_poke() (0x8ece) differs from pfn
> > at readback time (0xc6ce) in the instrumentaion.
> >
> > [1] https://lore.kernel.org/all/20260812063316.21371-1-nikunj@amd.com/
> >
> > Regards,
> > Nikunj
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

