Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEA2C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505696B008A; Thu, 17 Sep 2026 06:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490506B008C; Thu, 17 Sep 2026 06:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3583E6B0092; Thu, 17 Sep 2026 06:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9156B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:54:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03265C02CA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:54:47 +0000 (UTC)
X-FDA: 85222946256.11.9CDC373
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4261B40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:54:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JrNMbJz0;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789642486;
	b=v6SlMMDkVT9crWvhR9+ggbgussVntr9Te/lUnVTwhcGm5z9mh7ztJBof7nu2GoNqz5F+7f
	FTbOYk9EKrykOZREK4nA1znMWlduEZIa6lslFfc9BNcP4aoVrbOjmTGlb2DBwv3MOZgrMx
	2loZsc0Z95LVpI6QDNJ4vmwjY5mIb3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JrNMbJz0;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789642486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPEyYPDk8EE/aISYlZkkyB6RhrWT5mJK2Kdv46y7alY=;
	b=0jqgJQN4boQ4Smj9hvPFEv+SePZL6hpSgvrSK0tlTN1y9IVTgqEiiYkfOWhq53bOQwpLYj
	qX4dSMryS0vtwuUIP4YJldhLhXfWSazEN1miZAbivotogppACznJQH9zSe4mSbR9FldM3J
	O2qoga7QxbPRWKJVvLVmc1OIQFcvCwI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zPEyYPDk8EE/aISYlZkkyB6RhrWT5mJK2Kdv46y7alY=; b=JrNMbJz0FRUfJExTa9QX+PN6aX
	rhxoAQEs1iGB1gBE7OpxWvUIW8oaZJ+3qq36mNpM298qJUbpa6EV1l5ropOVv08fE6+gDxVbt6av4
	Hje1sXASq15UoTMM5biKhP59WUt5uM2mWizZ94hEA12cJeo+YKdwyq+FNA7cJwVDWzLzaLdEZ1Yn7
	bI4fAjT372GztJPzZsd7s8hbZJRyvaQhKvOYlC+Wbxp8OBHWPoY+w4qH7drvLUU9cVqE9vQmnJdT2
	we/GkdA4e8zC/Yrde1HYP1gljPaqZExfeBTOr8SiZVVolX2RERZBv5A/c7kAkxWLzR1xyVPxeBfsY
	xou5+GnA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x79kQ-005tLG-0g;
	Thu, 17 Sep 2026 10:53:46 +0000
Date: Thu, 17 Sep 2026 03:53:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, kexec@lists.infradead.org, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqvE5kO5x0UpRm9m@gmail.com>
References: <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
 <20260916153954.1054456-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916153954.1054456-1-usama.arif@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4261B40007
X-Rspam-User: 
X-Stat-Signature: 8wbqrhhd5an8wx5bxmdg73r39z4bjqz5
X-HE-Tag: 1789642486-924914
X-HE-Meta: U2FsdGVkX1+zutB0zdIvlMU79u6OIz//8BhRsMU8VZynmS4y+rplf8CeRiD99RwOeVckcJB+sazZLaSU8kXvUROtC8Memr+H1dTVhYqxLTuxYNdVFnquNaiY7kJRbr57+TuWRne7MqRmq6SncGD/OC+g9b1DE1NfwAMSLCazQzh91C/qDst3PKaafrOfPt3dHtQN0IKHC8CiwHdPeRCR4d9PbfuO/l4XWf59awJ5wu0AsDzX0uXV9D2OheZGznC1og6XCHC1r1nk/RtagaH6NsmPcdK7vLs4GOcqSYs3WTgYKSBEaICD8davKoeR40FqKBhsmcJggXpNC9/fA4AFsjNVs8yDAnxrefqrfDC6zEbcL/NIxoKodjLgIy8ylq/gIRSzNoEgn0ja/YjBQD1kWMhu1ry6/cK2FlVuAc6RYxQLxfXspWhkw6Z5NGPMWFOwZudrkBQbnz0BIbUbsRc6rKcPVhTfOptFdcH0bRX/BeKKEFbtGYqEAxTYTTCwmYR2a8hFWoGP3q2jqM5PoXB7h+/mBRcHYtON/GENZHAvBumev6OXRgF+s0NlUS9kz/bdsKP+fthNU7+Zxxd4XbBnZwaJ0cAgI1ZUaHTfSYY00K2msgHGhZo8XkYuQyCx85HPxAWgbDqanI6uhkD3BW81v8TITHF3VX378BJ3w749H2egzeeLAwAVr5OYiEkZU/ZoFOrM4q7U1M9TDUeLc6CFf2h3wDPWZkS2goxYUXUJUrbY/zU8IkJGLMvrrPfCxmxZnnI5Tea/028nsWiPNERz74Y3RiwhpuM5d2+SyGomNctKFFmE04BSTJ65PdY6EpGS6MJtb2oENUlKaB8fcGMY0hKXwk1HawQhAWMCsrtYuxvtTcrGXGC1I5+7M32XFJD6t8xUvqrz+lJ+TXer/aXwtszJPOVYrWb1Xat30UyNyuH/tIY+WIp0rn9tDtzIYoyX9uYyHt4xcJTiDcO2qiK
 iCkXEAI+
 mKeQVxD6CoVus6W9imfva8Yzo1/BArPnjzJ/soBt4xvcHYZ5jDfV9+SXcg2HI4elJiErBSkN3fNqPhoDvhyR2CIfHokGom5Tk0/dGQVVARz5aX4PWwfl6toil/WBoBQ34at3HSpDRnx8IAUbAMC7+oMc0HksEkXL5bzFnh671imCLUWV8czmo4qMefMLIcg1RlasU6da6zt4UT8LGf3X21H+thOLkijC7/T6X778ZpAOrTpPjclNocdBJ81bfWegzEcdnCLU/Dc64ylI6bCJ/z5Ddq/AUUVTR7foBgxJAAr3nykgNy7yaJ4HGpE0MAfY17GVSTajb8eVNcvfq6TtRyQuwqQcZel106xDJ5+YB+PuKnFrrHvvxXhv8zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Usama,

On Wed, Sep 16, 2026 at 08:39:53AM -0700, Usama Arif wrote:
> On Tue, 15 Sep 2026 05:53:37 -0700 Breno Leitao <leitao@debian.org> wrote:
> > +static efi_status_t efi_get_ram_range(u64 *base, u64 *top)
> > +{
> > +	struct efi_boot_memmap *map __free(efi_pool) = NULL;
> > +	u64 ram_base = ULLONG_MAX, ram_top = 0;
> > +	efi_status_t status;
> > +	int i, nr_desc;
> > +
> > +	status = efi_get_memory_map(&map, false);
> > +	if (status != EFI_SUCCESS)
> > +		return status;
> > +
> > +	nr_desc = map->map_size / map->desc_size;
> > +	for (i = 0; i < nr_desc; i++) {
> > +		efi_memory_desc_t *d;
> > +
> > +		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
> > +		if (!(d->attribute & EFI_MEMORY_WB) &&
> > +		    d->type != EFI_UNACCEPTED_MEMORY)
> > +			continue;
> > +		ram_base = min(ram_base, d->phys_addr);
> 
> Can this use the architecture's full RAM predicate?  On x86,
> setup_e820() maps EFI_LOADER_CODE, EFI_LOADER_DATA, both boot-services
> types, and EFI_CONVENTIONAL_MEMORY as E820_TYPE_RAM without requiring
> EFI_MEMORY_WB.
> 
> If a non-WB descriptor is at either end of RAM, this code omits it
> from the bitmap span.  efi_hwpoison_record_pfn() then rejects a
> poisoned PFN there, so the next kernel can allocate the bad frame.
> 
> One possible way to preserve the x86 behavior before applying the WB rule is:
> 
>     if (IS_ENABLED(CONFIG_X86) &&
>         (d->type == EFI_LOADER_CODE ||
>          d->type == EFI_LOADER_DATA ||
>          d->type == EFI_BOOT_SERVICES_CODE ||
>          d->type == EFI_BOOT_SERVICES_DATA ||
>          d->type == EFI_CONVENTIONAL_MEMORY))
>             goto include;
>     if (!(d->attribute & EFI_MEMORY_WB) &&
>         d->type != EFI_UNACCEPTED_MEMORY)
>             continue;
> include:
>     ram_base = min(ram_base, 

Sure, I had something similar in v2, but the feedback there was to
simplify this and go coarser, since the real cost is only a few extra
bits in the bitmap, so it wasn't worth the added complexity.

Happy to bring it back if saving those bits is worthwhile.

See the discussion here:
https://lore.kernel.org/all/aogvGXKH2u7JsJiS@thinkstation/

Thanks for the review,
--breno

