Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A36CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869FA6B0005; Wed, 13 May 2026 04:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AB06B008A; Wed, 13 May 2026 04:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7305D6B008C; Wed, 13 May 2026 04:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65F2C6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:50:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB7AAC2869
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:50:24 +0000 (UTC)
X-FDA: 84761775168.07.8233CF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0FF401A0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:50:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3wsuP8z;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JvhGAcyjgC6oFuK4AIORPgrR/vLGV8tdI2S+krpUgk=;
	b=qGrd+h7h8XM5tIgHPhxPTlPsaFaojyzByZdF9/i7UEXxP7nwDePJ3q4mDQXfhovfZfRhNV
	lLRyu3+2vHGD5tYtBYrMdop2ORq6XbvIkkGyfQ6yUz9TJBCMlAyHr+uEqyL5Stj9KhP44R
	aItGbKxzuD07fjHJPlwe9C8j8yz9MZ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3wsuP8z;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662223; a=rsa-sha256;
	cv=none;
	b=XfJUgjZfMvh8Jze67yYFTEGUMQBfnkRyixecmIMIVw3ErVkAF3PobYDeZOi5tHGMxyaynP
	RXCdwSsxN1+CxxKtNyveTnrZv3siXSj7dQMI0GxynmKSgAZahVdgyFTIZaeRuBBurPI2GZ
	3n0UUWtRwXq0iCENc+tOU8kP5p49JMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D127C42A00;
	Wed, 13 May 2026 08:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449B8C2BCB7;
	Wed, 13 May 2026 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778662221;
	bh=N9P1iXvYrJqLgZmIOtPNBCWH68XujKCrRJM/d7OA1NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3wsuP8z+CNKLupx+n1E2LTwB0iywnD4fV4upd41SWJq+wzKRFN+6l5o/Oie0iFXu
	 QdpC0QzmJbU/K5OQ8IyHfr06kiJlM7LBMiHCJFHxnYf1+zAE/YVHre4MLSRYgTodzF
	 2UX6okTeCTJI9YtbbKEiw4HSykdkmljvjNwc9qLFqVNHKyLSJ8pz4UoB8aqnGx16Mp
	 VHM75dVMdLqFiKF4Iy17YKPz7rWAnLkaR7h7HrJRw1/Fb3kroXQylFyEBZbcz6n1t4
	 Rrku0nAKE7qsstQILa3ifLy6O3io+f5iV74vmoN5D63J7MlkItbWbq+4JnF0SFHtfr
	 lDHvYuOSl8IsA==
Date: Wed, 13 May 2026 11:50:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jann Horn <jannh@google.com>, Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <agQ7RMAw51RlNUOj@kernel.org>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
 <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
 <fb5749bb-bc87-4f0b-9ec9-8a1eb7ded3b5@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb5749bb-bc87-4f0b-9ec9-8a1eb7ded3b5@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0FF401A0004
X-Stat-Signature: qjiz81jdypea11z8gzx4otri16hbe1r1
X-HE-Tag: 1778662222-785134
X-HE-Meta: U2FsdGVkX1/vnke/uEAy+PoNNwFVwl+5b94ZGZSBWxg7OEsRRx0psnkMOc0votaXykeR4E0ZdjS980/xrZq0oyjJC6mL1peX43s8ExHtV6R5nbhMyzPWqVmw6zS3fOHbty0a6PFaygEVDzUNEZiI7/34EZY/zXovVxGCWNzQVn0HJ+QrGWq3CnPye9jQHbOz5RZhqbk7IX6QHqHOWz+TvFMAZD4Ui4w4mt+kMgj2yNVth6vbarSwNEkHfagcNmAME/jR3FPHPevBj4qhTB7u0e5+2yE7nCAtA7Lh0Qm0hY04lxYq2SVtlKia4Luryy7d2sk9rW9eE/dWhUS3gG6NA0xbVvUoOf6irG2tiGd4oXgb2oOsquBHL2LyP5F4gvJN9JFSzx4PIL8R0728DziGgeoqlKhEEBlSwwjPGmkvItF/OenFfSqeep+wXGD0MUrmWD0GYS6/uvh50hDMZtaIpw3iAqiPR7UsWpN7u1jUOLmSOKgZIvD4BBlxZeFaANz2h5SjSH54efLEsA/ir1YopgK+gmx+/UyfnKdAPDpn/c5+8aJQvU3vtp/mPyjeWqWIg195giYjN36QRHHscVRpEBxyqXmBOa+4uCA1DsZGW9koYBIaTeqVYhRVwnFNhoTnC5JbCD1TP/7QjHm+QD2nCeFkwS3DkjwA2tII4b2JOBm5vPADMdR+42YV0kGAIZ+bIDUNknz1xj+jAqxlMcCE6b7IC1uBAXBFhdSnzZLO+EH9E3FU5ENVLQUsqe95gfgQRz3pKaeXBDU3bcWHJiW9DM746OjTrLRJH2QfV4HEzmV0R5CshinpjgeyyBOI2A9YeOGBhlb3q4+K3mj0IhMntPa0rE+xOI9o7w7mCIaGrJvd10ZByjcux+WuNFrXAF/AQZeB5R5lZIRh3ljTjg6xXG7QUvGJLvFs/kbtTv93PzgLAH/J9+7h15Ci7f1aHve11f/7EnVgoN/KyH/GLsr
 As0pSMM4
 xGZ8Ed7l4miaZS0V09bXBg/cdYYDGDlsGhJf2M0X6VrAiJCwZw8IT+y0AtjUBSD6oIusa1gGeEhB4mox3eWZ0WNxZaTisca/QmN3ATJWY+714k80QxatZo5Sf764/3DXtxypwIjBaUNpIbzs1ijjjJx6gOqDzr6kjPxaSFT3AYM+NZnLITieapxfmLlWUcBZG0bb3JiftasgcQfvNDeLE90STD1wkVcRot9lJH3/+4AZAqS1duXhM/Ft1ttvDxS33QfUaYsVdgW3fv1twu4qXiQVd9AEDGNKWjyl3e+GMOQwVCrjp9tq8fhz7vkefO73q8X7yzIYKOurthHJ/SlvSt7YY9wBPIoxCMGgwnUy5KkJcHnitjxxABZBqlGiVijcoHicFe4cgfeyUYJHj78zs1Y1ULACqTRvkam2lav0JLSJH770=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 02:56:16PM +0200, Ard Biesheuvel wrote:
> On Mon, 11 May 2026, at 16:40, Jann Horn wrote:
> > On Mon, May 11, 2026 at 10:59 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >> I think we should simply do something along the lines of the below,
> >> considering that the size of a data object tends to correlate with
> >> its minimum alignment.
> >>
> >> I do find it rather puzzling that the compiler emits empty_zero_page
> >> *after* zero_page_pfn - ideally, we'd combine the below with
> >> -fdata-sections so that the linker sees all individual objects, but
> >> I suspect that would create some problems elsewhere.
> >>
> >>
> >> --- a/include/asm-generic/vmlinux.lds.h
> >> +++ b/include/asm-generic/vmlinux.lds.h
> >> @@ -452,7 +452,7 @@
> >>  #define RO_AFTER_INIT_DATA                                   \
> >>         . = ALIGN(8);                                         \
> >>         __start_ro_after_init = .;                            \
> >> -       *(.data..ro_after_init)                               \
> >> +       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \
> >
> > Oh, neat, I didn't realize that's possible. That seems like a nicer
> > approach...
> 
> Neat but rather ineffective, unfortunately. (I don't see a size
> difference with the arm64 defconfig kernel)
> 
> Given that empty_zero_page only ever gets its address taken, we
> might just move it into the linker script if that requires tweaking
> anyway. We can just place it at the start of .rodata, which is
> already page aligned on most architectures (and will become page
> aligned unless EMPTY_ZERO_PAGE is #define'd by the arch linker
> script to something else)
> 
> 
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -472,6 +472,17 @@
>  #endif
>  #endif
>  
> +#ifndef EMPTY_ZERO_PAGE
> +#ifndef __HAVE_COLOR_ZERO_PAGE

I don't think we want let architectures that don't use colored zero pages
redefine it.
If it will be really required we can add the ability to redefine
EMPTY_ZERO_PAGE later.

> +#define EMPTY_ZERO_PAGE                                        \
> +       . = ALIGN(PAGE_SIZE);                                   \
> +       empty_zero_page = .;                                    \
> +       . += PAGE_SIZE;
> +#else
> +#define EMPTY_ZERO_PAGE
> +#endif
> +#endif
> +
>  /*
>   * Read only Data
>   */
> @@ -479,6 +490,7 @@
>         . = ALIGN((align));                                     \
>         .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {   \
>                 __start_rodata = .;                             \
> +               EMPTY_ZERO_PAGE                                 \
>                 *(.rodata) *(.rodata.*) *(.data.rel.ro*)        \
>                 SCHED_DATA                                      \
> 

-- 
Sincerely yours,
Mike.

