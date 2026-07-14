Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7837C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821196B00E2; Tue, 14 Jul 2026 11:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9606B00E3; Tue, 14 Jul 2026 11:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1FB6B00E4; Tue, 14 Jul 2026 11:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48AE16B00E2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:05:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1FC01A0433
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:05:16 +0000 (UTC)
X-FDA: 84987705432.20.CFFB19C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 462BFC0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:05:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crOD2NmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYjyETDBZwm0j/cPjjIgSYujcuHtX92Lh9M1By4BrMc=;
	b=f7cGbrSNMC6hcboIL4oZwn+JqqgXbTF3lGUnLfCnU5YtCtYBeCoH0EDG5bPJqgGNX/fBrM
	n8rDUigk1YyOryj7KEAT/h/NAscv8minljmeY2+5nBVx8wauZy+3J/r2UhO/Cx2TyhxAKT
	l/mCQIXj2pQwYfD8vyjKzO1np17XEV4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crOD2NmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041515;
	b=2bq4ocplKdzOKt0Ly71TAFLL4Zy6A1TYt8SjjnsmcphDF0LDvvRhUAvk412zzREo1WlALp
	o1DXUyAxeN5OTqIF2svTt0bBGYWYfpJ/4nduIITX6xEf/vpob47yrdKu/jjIwY98qzFWLV
	8p+i8lO6kjc1ULmOfWTOX8U+T6eqACU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B803C60103;
	Tue, 14 Jul 2026 15:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA51F000E9;
	Tue, 14 Jul 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784041514;
	bh=AYjyETDBZwm0j/cPjjIgSYujcuHtX92Lh9M1By4BrMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=crOD2NmJDWob7tNH4b0nB1FiZnokFnKZDkP0Ght7V6I9Wl8zmC+0pmKCW+kuXLlLH
	 OdZHmkh/T/9BB42ZvoZwp60T/mYLQwb+uOSlwDUb+jGK/rXpggWk3voCs1+1oCHlIy
	 LXTlYETzj3M++Bh5NzIk2buDSGg3fmS7KG1J0rfl/O/1fHossnuwmJ7LiswfHs+0P0
	 ffWQo61tvdjoVoC7hXSzokGWOo+sPo7j+/6Jfs2msT1jdScy1yBzSMh3QvyUVNtNcz
	 99aBb5YGUL9jfl1vNkXPGp7NC4uErRwi1ismiMLOqmhMcboruizzYkE3vXwJGQsEgm
	 RUE53xPNgB+iQ==
Date: Tue, 14 Jul 2026 16:04:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-arm-kernel@lists.infradead.org, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	sparclinux@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-um@lists.infradead.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ning Sun <ning.sun@intel.com>, x86@kernel.org, tboot-devel@lists.sourceforge.net, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-efi@vger.kernel.org, Vishal Moola <vishal.moola@gmail.com>, 
	Alistair Popple <apopple@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
Message-ID: <alZOs30ziqa7l_Lq@lucifer>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
 <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com>
X-Stat-Signature: mjkeyn11j7cu89uhtgxik1rbetwhge7j
X-Rspamd-Queue-Id: 462BFC0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784041515-57756
X-HE-Meta: U2FsdGVkX19bYbyiS/8BltugN3YzmPsYnOOovr8ZJwrQ/MK9kIFSE109cUKD9YGLl8KxS0tzf7BxJBCKfQ1yHGsMr15V6fx4GdzU8vKoxSJ3bmbDfWHf8vQb+J9GHJdtC2C0xp+UhLD78D/Gmvm9PZvr4kBZCaFJWGMDpP7cHTYnL66ZvbdWqRlDLIsMZIewCk0MQq4fvVS10e6oDw4zEI3xxcmAs6pT2sw241wW2uDDxA+X2OLqK5MEJ49K53H1ga7Chp/o5zKHa7TEoVvPj18iXLDkLQF3KzRqS+vhEQ83ETlrryN819SC48+w+NnEMtf5W31EFwgSuVlAtUKGvjywn3HeoQNay1zDdGMtYza+q0vhaq83+id2HOyx5gaBIt3BBWNpvDv7wXxAHzHlBgc6bV+Y/WAHk5Hh/fE5axIUzXx5gyhOChpZlYgU4sbG03Ht5owWAzyOXFIwROOrk2AxyOFqehKlgfQMso3JpKTf6yiWQP0PBnThVKo7of1ApMxQEe1YPd+wpjbDBwXklUo1IfwdMBcOpQeyRA220LfL++rgevachtZSmoNB8V9Rrksexmv+SiioJ2X370yQjafzjpRQunK5pHMFrmxIpc5vUzmIfsRIj87ruUKyfp6Q3Dm909Fx1OlG42G8aoLOvBKjJ5GR7C0s2Eg4uBZIrSMNgvzvW63IfQ7rY7JnVYGgUwVDj48b3SCXuubiyNDvKvB6Zw4N4qhIvBpSkFwpeLMyoNwHGi4IQLPvgI0YRnJ9h67zGON6KPBTv20HQrSBTB0OqlAsZSHdHiD3729fARHrbzsjeY+PrfAfG2lfchLr1OVMXaMvMA+CHal/a0vj16P9jhMx2GJ+ajNdln7LU5SaFNXK+J4877nOrht2wqLdazDfDHYc8FkKHQJ/9ZEsde4NXY0DVs5wuZVCYyk5/Uh4L8kAn7WU8BslXsmTyk0kGr3JWGYZ57e3ZCV4UkA
 hrzeQM1a
 Nq3nS80K4+3qVB+LkdeB2TqnucbiK2cyS1NCItS7fvv144HICWNjL/8cufWTcOcqgkcPzUpf26WAVUtwhmwH27FfgsAOt3AdOCMfVgLjSCZ4Z1XxkJ4LBaHQ6+GdTKJhk3rBLhnTVq8ewpZiroTFhsnsWtyqCJA+jr4MltBSC4YhYgpCgf8wHDrYE2XfxnOJ+TrPAUfodOwIKI6GA27WDq8ibKLHm2XX58ix6MpU0YssHk4l7/hd00YP+77s6vnvwHcenU9dDnSu/qjwHoVSAunX8cog++4/8+9KwAcDrtjho4pEHXdk70827A5mWXCm2mhLn/k6CVR2qXUeZCgVicH9OMAHbjES6iD6PehykdCadHW/CJtK0FiSmpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:47:43AM -0700, Dave Hansen wrote:
> On 7/14/26 07:03, Kevin Brodsky wrote:
> > +static inline bool mm_is_kernel(const struct mm_struct *mm)
> > +{
> > +	return mm && mm_flags_test(MMF_KERNEL, mm);
> > +}
>
> Could we give this some nice comments explaining what a kernel mm is,
> please? Part of the problem with the init_mm checks is that they're
> magic and it's not always clear what's special about init_mm.
>
> Maybe start with this list?
>
> 1. There's only one of them.
> 2. All kernel threads share it. tsk->mm is the same for all kernel
>    threads.
> 3. It holds the reference copy of the kernel page tables
> 4. Userspace can't be entered when it is the current mm
> 5. It has different TLB flushing rules than userspace mms
>
> I _think_ those are universal across all architectures.

Well point 1 isn't true of efimm or tboot_mm so we possibly need a better
name :)

"Special" is overloaded too much already. I quite like "eternal" so:

	static inline bool mm_is_eternal(const struct mm_struct *mm)
	{
		return mm && mm_flags_test(MMF_ETERNAL, mm);
	}

:)

Cheers, Lorenzo

