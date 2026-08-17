Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA07C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FDE6B00BB; Mon, 17 Aug 2026 08:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD05C6B00F5; Mon, 17 Aug 2026 08:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5C76B0106; Mon, 17 Aug 2026 08:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F74F6B00BB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:22:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D67C06D0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:22:06 +0000 (UTC)
X-FDA: 85110673452.29.A268B5B
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf01.hostedemail.com (Postfix) with ESMTP id F40564000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:22:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XkldS3CH;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786969324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ksysbh4dcTuDtSNajt7R605hngUF6zYW8EyMCk1D+1g=;
	b=EAktfeq7cRP9kci2pWU7EwoDYkZKQ0q9HhEtLA5KpVDh7jZUbtYgM5IFyP52NvJ5uQzeLh
	T9gSAPst/9IBJlK7hy3P/4l6lnFeFj2ymKI8kiCUhWgXNvsJoyeGRH85PXRvQtkaPGquCT
	4Dfj4M1p7h8HwV1cPVMi/sthtn7Lyhs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XkldS3CH;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786969324;
	b=esfs9vie6QCgqwofcqxJr+ig4UWC92kQaD8Ulnk+b/QQbXYW0FFqr8tlUsUrAHdoPmENnk
	QKwlU7UCdEX3rFkHu4JzBY9hHPOKV/HNlW2uiZjozfgqIUwW1jDkJu5x7+aWJZAxj1KL1e
	sM3OHFsXvjWapbsKCO+NayQvFYal1Rg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XUz20HjX88HKc3zhTmA9XIj0WBNTBdnuMyd7s0rygf4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786969322; v=1; x=1787574122;
 b=XkldS3CHg9hCBivEOhkQQzkmUhdPITkRmMuNYQi3cCkftCjtJWWLDRiDP/+pw18b1esq4lNP
 slbcZxty0whFStgDGAoQnHGUK2wfA2IpllM//lyHcu35MfQ6dkOPY6w42V/iiNp8rSh+jXtT66Q
 Gkbjx9DvRnQfiagSi2bv5dsQ=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (185.201.63.253)
	by smtp.migadu.com with ESMTPS id ac101bf52cfc1249;
	Mon, 17 Aug 2026 12:22:02 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 14:21:41 +0200
Message-Id: <DKR7R0BECQXX.2FCNF36EFETS8@linux.dev>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, "Albert Ou"
 <aou@eecs.berkeley.edu>, "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andy Lutomirski" <luto@kernel.org>,
 "Borislav Petkov" <bp@alien8.de>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko Carstens"
 <hca@linux.ibm.com>, "Huacai Chen" <chenhuacai@kernel.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Len Brown" <lenb@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>, "Pavel Machek"
 <pavel@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Sven Schnelle" <svens@linux.ibm.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "WANG Xuerui" <kernel@xen0n.name>,
 "Will Deacon" <will@kernel.org>, <x86@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <loongarch@lists.linux.dev>
Subject: Re: [PATCH 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org> <20260816-execmem-set-vm-perms-v0-2-v1-4-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-4-90944a3ad43f@kernel.org>
X-Stat-Signature: i3ojiufcb9tb11ozzgn3afd5g7cbsxtr
X-Rspamd-Queue-Id: F40564000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786969323-212444
X-HE-Meta: U2FsdGVkX1/ADZhfKVDo9ZxE37gAl0cq32YBSU4QWL/wi8ZcM8F8uWzNrXaWoKiUZxZ3FgtHF9tFx7Eopi2spryp3PNBlYeaSSxIEC9aOnxVjzGoS5NAxqovuYk7RHpp6axhy9ucWMXFe7x9OwPKqGJ9M5FKQ2hjifLKBINnxlFuO7c6yUyRW10P2oKh/eb1jbR6fAzc9yZ4GynWmUFNp1D0xfJwJraXt0Oa5Ikt6bLTKvdc6AZhIC1uEBVOBe4R75OAJR9Tyrydw+S0lDJ8V4AUItaoD7K20lh63aPIoWB1E8zzHn6elqF9ZF7LsJRwQ9vJlbzYOWMn6Qe8vJyTjmw6GdAQhVMfjpxiMXvHU8pfyNCobuDP9ESWuoyy9w14c+CMu7ILQL8yyoicPEjUgog+J9ngtjxjjhNY82GmLiMhVUer83F6ZMlZ7RJ+WQO85HWdo5gtjqcYiuOvVmS0fa+YGNN7dmCatc3sNSr8PlXxsi8KDvcgV8dQewZ63emmJO0sfe5WaOgeW9nKYUEM1W//U/TaIaSJaI8TcD76IiUtGkv2Qika0yRSfZtB6BtN58cNGYEPCvkZ0If/NwqvLKMhSUu1HVuzlgERfR4sxhJSKaGwsiI08bSNEIRRt3JZdYlTM4InooLXxmnVIwdX3n3Py1GedxXVSIhBhDrpdyWjPXHzpLVvOF10XnjDTruAoTkQ0EvQVKR3i1ulVF9X47MK7OgkJr1DGWvkhX2VkQX01qiENNHmkY+yLBAhfXyJe+ar6Abzcp7WfAx9rEwNqD5lWydUwcR+Kj8o9aB99sqGCpLsgZz8rcx0JiAtYiaW5ZwkGQgZQ3BOxuUYlCitbe4/2N2D3lnS9m4LkxAq8dqI0xhzeHft4JGPnCYa98MN0aNQJOqzsVf4gj4mvWhgGcS8XRG2WzkCwfxI8n0FjAQyNY3MK3WiU+D8S/tIIJX71t4+QFiKJDTDoGkBs2d
 OBlqFVTN
 WbdnG7/Z+tsTs/nZuzdGBdvcOOR/BPwnKjcbuSvyYzZr3Z8nbjZwBkgDhDKDQKSFFo4Vz3xeE17b6+Lvh1J7z1Gg6FYxmYJJT5sDa4t2tgtj9DnFjV+QI43CC9ttxPL7PKZZpRPms05l/mLk3rMdZcV8Up1yTATqkVR//tXZBcx6rsVEmgIszPMjHe7dckW+KqkD8djwbgLZO2MtGXgP6pmy+cSOV21YUcmnsJE09ixeQEa8GZEW3DUCOz7Kh3hEq+MMFywBmx12TV5U9jfrCgwbZMhJD6Mxz4T+0oGeW+uHA6l9bvSTYakkjBhjqDakSr5NxXstBfRHV6HnMUsQzichdycxQTmyZzGUMU4QC6TlxubxRiUCTEPiBrgtmt5zV/FCO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> set_area_direct_map() always updates direct map alias permissions in
> single page increments.
>
> For HUGE_VMAP areas it's suboptimal. Not only the loop in
> set_area_direct_map() needlessly has more iterations (e.g times 512 on
> x86), but it also causes fragmentation of the direct map that could be
> avoided for the HUGE_VMAP areas populated with large pages.
>
> All pages in an area are always of the same order: either same-order
> large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> cleared or when huge pages allocation fails and fallback path is taken.
>
> Instead of updating the direct map permissions for every order-0 page in
> an area, use the area's page_order as the loop increment and update the
> large pages in one call to set_direct_map_{invalid,default}_noflush().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/vmalloc.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fc7993db4152..11170d1ee5be 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3361,12 +3361,15 @@ static inline void set_area_direct_map(const stru=
ct vm_struct *area,
>  				       int (*set_direct_map)(struct page *page,
>  							     unsigned int nr))
>  {
> -	unsigned long i;
> +	unsigned int nr =3D (1U << vm_area_page_order(area));
> +
> +	for (unsigned long i =3D 0; i < area->nr_pages; i +=3D nr) {
> +		if (page_address(area->pages[i])) {
> +			int err =3D set_direct_map(area->pages[i], nr);
> =20
> -	/* HUGE_VMALLOC passes small pages to set_direct_map */
> -	for (i =3D 0; i < area->nr_pages; i++)
> -		if (page_address(area->pages[i]))
> -			set_direct_map(area->pages[i], 1);
> +			WARN_ON_ONCE(err);

Nit: Maybe worth a comment on why this is expected to always succeed?
I.e. I think we are assuming the only failure mode is allocation but=20
because we know vm_area_page_order() there shouldn't be any allocation?

