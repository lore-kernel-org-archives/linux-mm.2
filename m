Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE81CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1456B0092; Wed,  3 Jun 2026 08:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EB36B0095; Wed,  3 Jun 2026 08:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9848C6B0096; Wed,  3 Jun 2026 08:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7F66B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:47:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03F521A037D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:47:15 +0000 (UTC)
X-FDA: 84838576872.04.60051BE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5425020009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:47:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=WNx+PRJX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7lHgIyR0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf31.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJYS40BF5p4gKtpyUwmLgEs6O937x1vRUuroAyGoJDA=;
	b=hCyiUEvANnUt1uoqkvpvDAEaWhYubQg6dXz+rfHcI8NhifJJa8z9KF0Rz0BRZU8qHMRfvP
	h9aBst3TMdQn66h1JhhqvvNwcfG0CRJ+6dJXUG4oT6fsu35N3MTsVRv7KI6lNtd/j0GxH4
	lOTw4fMlNIu1Tln8dxrEi9dEU3+VGIY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=WNx+PRJX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7lHgIyR0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf31.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490834;
	b=YHV0faoVzmlRX3DRSGYS5YbV91fBa16I5kOw42G5uCo/znvPOIHlizy0ZIYkXHBp38sabV
	AuYZBKDgMGuHs/YRYzKjTxSwJZzYAyTKC72/RIcxxxe388/ZNL54ZAV4/NmjAnUSOXLa67
	O0pc4ijehWRXt1gZpKB0dzGZL9U6YcY=
Date: Wed, 3 Jun 2026 14:47:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1780490832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJYS40BF5p4gKtpyUwmLgEs6O937x1vRUuroAyGoJDA=;
	b=WNx+PRJXN+NoUx7HcoaWTSD5Svn727DpFWpOSDbXCaxfiVtExaVZ0LQYYISjYgdsQbXHRJ
	8A+GQBLXjhgkVe+sZCdCy9nRQ5xtHJUJ4J8v7L5uVXRydYyJePf8VV7GLcjqqOWgOTkbUm
	ozi2sXGbvD+qMUzxlWWQXX+jigjhJ2214AeVswrmgDKj8z4QJaHQu4pEXkCSwCvk+eYuQJ
	fsxaKjO6abeDXIW8jrWtP62/USKtM6OjxULvaBqEFVyuFvdvBZtsceLZ5176StpDeLuNkI
	0uD3Z6lUIz3yoMvojgRxV4n5iuMTD/9JiCmYC3zCzjFsX4kK2k5NRVFP4A1Uog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1780490832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJYS40BF5p4gKtpyUwmLgEs6O937x1vRUuroAyGoJDA=;
	b=7lHgIyR0ZJFeyDzWOt98sfoOm4cVsh1LX1k3k64UCMFSi0rzzRt2ITOLGAoisbEOwk66by
	vtQ7+N6hpb69SZBg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Frederic Weisbecker <frederic@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Nam Cao <namcao@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
Message-ID: <20260603144357-464a54b4-4569-4b49-b7ea-77dc0af730e5@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
 <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
 <20260603114217-9eaaa386-a766-4336-8930-250c2ff91d19@linutronix.de>
 <10274d6e-0af2-4f9c-9788-2896065ec16a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10274d6e-0af2-4f9c-9788-2896065ec16a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5425020009
X-Stat-Signature: sorure79u4i49pzbaj9jem4uz41eenz4
X-HE-Tag: 1780490834-126827
X-HE-Meta: U2FsdGVkX1/QcuS0Nk4/wB62QeeSszz5c+s76S+ibQH85NNAFbHYiIKv2FTSbpSJAc7bFz58gzKA9u4cruqfxy3/at/j2ZeMH72ec0fn45lW/t4m7EwNsZEX2cUwV/TwTi1nQAOvKgYm9JVUUdy473lOjIa8DoHg7OnW110JUlTT6NGOYzDHA+b4lVxu9rdqAK/g21j5bB+vYICIomemdZpZSDFqa1YaihP8rSRlBkng8vVJHvtTs4+ufThzKRqHDkf1+7NgbMLxeDK+Q3dzziDaX5W+kGzdIx++Q649YWFsWLSdcXpfhGRV8t6Vc02RHKH/Q0PVoze+eVbigtntN9iATM6pWp0RbCbSTp6Da9d+H6vKSc1hUkohXgcPYqxHqgLJj0GP8tkXthOnThqkWiSwn0Eo8uCIDtwK8r+u8vy7pHrVWHTR4MY+SGsipNXHIykrnA08WG6GXZXmm0qagDOr2rW9IYGWt75q160jeNyNE2eI5lXBiHbPvxjUXTHo/3KlPi466sGGXpK+0fWy3/Xrg6Lbph3GVYV0Bqlw4wUGbMzX4r1n3xj/ab91sZM92DE1HwIJ0fHHs4SPm0uPhctzr+p/iZ5FvOWhTp+yOiQJgHMc0bzKJK2xkV+Mt0LSAFgwPtPbayzZ7E3O+RQ7ga6vUB/jC1O9ifQq5gQUHxtfB1LP4saIS6FlAXyYj6vZAlQxtxGr2ltPKu0eYExgs1HJsERjrmbHbMoP3L0GafCoPmHr885Vr9YXMjff/ih5DUWs0zMZXGTR9XVNF0KeObzQsIbzagi/CfsctTnm6tEncTULVG5UvFU1h14rHgQHXFh75AHFuhfbs7mYzt6s0RH0Ug0dKvnKHxt0pGJ5BokYTz7qNpmvPB41xA7wJM41WHXcB3EzJIAmvvecrZyWM6E20mcVMlmDcsMTvMJqdtnKngy723slIDer5cXrZ+pv1ymgP5JIcoT0n5AuAne
 lLAqQ2NY
 hS2w9pFCXg9VTn8wYFN283ikimGDEncUohuthdbNBZnXsjXtjBomyyun4GQl7HyayANZJJ88UEgORKsqZOOob0mntFUvieK8YRDbc0MSZlSFLBp267Raqrl/qxSgRgfWkf7IPt93J9LBxypX+CbpNHG3DW1B3pJARQyw39/RvyW/FdylDPhCAVV2749T9t9EdNx3l9nmWU5E6s+/1gOvteAUdbBGPy02bjCgor8CRpSyicVwI6aQGgADwnsaBfqC9YHGskd/gQKcKpdTByDnCqdC4QmnNUWNAnSdrinCQymhpZ2SjEnHtfub7kj0DEjr2x5qafpQT1vkP0YR+Anm8T/9mYYeymox7Ee2d1UMlieu4rC5CmrDLoglvPMrVyHmwwT0+KXduEtjM1tr3H1xLf0IRpejTj4j3dCKfFRNQ+zschv8Kq7mzpWMk7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 01:35:19PM +0200, David Hildenbrand (Arm) wrote:
> On 6/3/26 12:10, Thomas Weißschuh wrote:
> > On Tue, Jun 02, 2026 at 08:41:31PM +0200, David Hildenbrand (Arm) wrote:
> >> On 5/18/26 11:49, Thomas Weißschuh wrote:

(...)

> >> IIRC, we want to disallow read/write access that could have side effects through
> >> ptrace, including process_vm_*(). For memory-mapped I/O that might certainly the
> >> case.
> > 
> > There are no side-effects, this is just global shared memory.
> > (But as mentioned before, writes can not be allowed)
> > Accesses from other tasks need to be prevented, which is what
> > patch 4 tries to do based on FAULT_FLAG_REMOTE.
> > 
> > The only data in these pages which is not globally shared and accessible
> > are the time namespace offsets. But /proc/$PID/timens_offsets is
> > world-readable anyways.
> > 
> >> With your change, you'd also unlock get_dump_page() on vdso pages.
> > 
> > We use VM_DONTDUMP on the VMA, shouldn't that prevent dumping?
> > Dumping these pages is not a (security) issue, just pointless.
> 
> Ah, right.
> 
> So we still have
> 
> VM_READ | VM_MAYREAD | VM_DONTDUMP | VM_MIXEDMAP ...
> 
> So even FOLL_FORCE cannot write to it.
> 
> It might be good to document the change (pages can not be GUP'ed, including
> being read by ptrace etc). But I agree that it should likely be fine.

Should this "not" have been a "now"?

I'll extend the descriptions and will resend the patches next cycle.

Thanks for taking a look!


Thomas

