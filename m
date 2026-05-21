Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3365CCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568876B008A; Thu, 21 May 2026 10:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F2A6B0093; Thu, 21 May 2026 10:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C5A6B00AC; Thu, 21 May 2026 10:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330836B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:54:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF29B16115F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:54:07 +0000 (UTC)
X-FDA: 84791722134.27.99E4D52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 209AF40003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:54:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NG8vu/Xs";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375246; a=rsa-sha256;
	cv=none;
	b=NPANWiRwrwD7tlJRXN0GtWs2bTEKo/fS+5JVbt7mHKLA/i74tY62oKFjCAoNZYbLAxXxbR
	HDrPORpnb5Uv0FA202Ec41g86rnc3wuT57c5hPgS6e4+bIMlXl4DlZ3QbKSPF0qBU5TkBn
	EAbqTtrf7v1OdwxzbLhVKe+Zsmze2Mc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NG8vu/Xs";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZo8ckPnFvPQyJdHWs7MYZ7908EuicBWVqEq3mObAuA=;
	b=ov3dEWsL6vCHOv7uLSFbO3RI+GfT7Mp/ODIzGUNZB8w8Xmci+sQiqf7TTg4TqX1S0H8TvV
	RqbqE9sauTjUZwRW+NAZ/fsEpnzm5ptgFR7+lQ6ijkOgMO4L1DkSCTZiQfw88CB6znPNvt
	Si7+1yhUITBtpu36Xv8sDXzeDCYegWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 336ED441F2;
	Thu, 21 May 2026 14:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84D81F000E9;
	Thu, 21 May 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779375245;
	bh=UZo8ckPnFvPQyJdHWs7MYZ7908EuicBWVqEq3mObAuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NG8vu/Xs9DPqW2P52N7VKEN526es7gFqS2foZuknV4N8AV7EEg3JdRxuzKHQ+TLqU
	 ytZah9/qmQ1pyZD0n++JQJkgPUXPzZnRkKjGSBaV/CnTmR+9bkWqQH+oJrWUB9JhDM
	 f07OHwDRuelSltFL+Vps2YtlQCN8bpJ5dg/8tkhvgoHRVzNTz1t9+vse8eFv05TpZ9
	 c9LLc5/VgSzMPk63RJLJG65f4xJ+511c3h4rQGd+AzzDnuyM4NOp8z/c0H4/jRUR3/
	 FUT7z5DJNlwvA9qeA8C55omXjw/xxK8Jp35BIsfF/ktj86SER0PG0BMGH/bSjUVBMp
	 DSwWU4z9G0dmw==
Date: Thu, 21 May 2026 15:53:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] string: use offset_in_page() in sized_strscpy()
Message-ID: <ag8ZwfKSBbhIwDUk@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-6-thorsten.blum@linux.dev>
 <ag7pg__Dzs-tKfGw@lucifer>
 <ag8M7UVI6M_0KPC5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag8M7UVI6M_0KPC5@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 209AF40003
X-Rspamd-Server: rspam03
X-Stat-Signature: 3egde6p4cbobf5md8aftnhepu8kzdjir
X-HE-Tag: 1779375245-402428
X-HE-Meta: U2FsdGVkX18SkBL5cKb1kpIFGUUDmB2aAs4syIVji9lWMZE6GB7U0mfGMVLxrW1fcWMBJa3eVgnH8mR1HHbV4OBpfoOJ2/cIuVkokB26e2rkuglRTcUe4byfr0C3Ol7sPnCGTU5oFxDZcZeesiHvbD8z7H+Fx8vt+DOGsVuOfDNUutYWCoKZsHo00Iti4Mlide/uxmuSrzelShRRt/dfDJhdTtUAQhRVj/nrx2kb98XgEZ7GyVoI1oh5DC/7E3+eXCj60sH7NPo6qphi1WYoVjMtJntur+pXPyJ4A/lpgobc50c4BbHqahhWDZeCGVkEwMN+8uT/a7ptlaqGWN1JcPYqIZCXzHFijD/2/IS0/izxSWSmYp+ISnPcwCbKtgloBcpyX0jq8vWlAH3LczoniMev1wr1JLuaET2QkKLR8CiFlLqQvfg1QaHGgC8XQvBdCHxxIjC3U+fi+sV/G2lW0f26vOoRahxka7rDqJlAUXK2WeDbyz4SLwRCeHERZPp9XgzmgM2DLtj1nNWPbYhGQKhl/iDlvSBy6Ps7Vz59nqOShvvo1UKHzdd1LFoV/Z0Vbz3ScsioXRilcjQg4D2QuJL3EK10RfRqZCoBEHaLpAZjEuNzvQs5EnPDSRr4UPkKs5l73fwSRVEJE2pPiYNHOJf8txiVq27HkbW9h+TFUTa8l8uugndRJWwpQT7wmTmgGQf9DsL8BUYGAv8PYLZX5klz1c3W2dQdgaxTxcCVU19LcI7flJCGmU0ShaPAdWplGp27rVvk2ikgDkP5UT3dgNlBl2KqDB8HPgmDqytRA/PEiH1iixS2ePP5k9G76LC2G0nVsDoiLlsJGVQBRewwBGRDLuc1O/eM2sHanZPECQ/M91UH4AHgyl9qrdvhUeqWF3LsAmgN8dAOJdOqwbxe5zQZlfhdEOEW59frz5J2whQpE/sYte+JNs86d3Y1pNENR7nEwBk6Pbrq/7UKSki
 0Pu9D+PO
 YMn0DX5+G9jdSyjsyTeGArTJyKu7V7ap5mE2GfJw5ymtFTR9bnWrUMXeKdQ5aNUqSro3c/+m80u1G0zRnVIcKyCr6TrU0zh6GAG9Nl0BFXs0iRqBRqH+Pqb4H1eABgHK7ZcSRwvmlCk+dIyIYleMwQmrhNwddcapwQVoOyA4tXhnm7r1HVfnyPVriGce2bOLK7K6AsDvsFW/qWj3zS9/9Wk1lE5z9lLkrBKu7JW8YpyWWMuXjJ1eq9xpzBCRd47KQU6oaOUsRIkvdIXxVzXLBIz+wATM0pVGPA+mOcWsTD4+6IDCNVx8/yGwq+x8i4buoGKNC3xafuxUljrfApzZTKGiHL1BD+4TKdHwYYwpwvrb9kLHsg3yB52QDfrvzpwGbtpbwH+O8wcntRnZme5bA4ekHkI9oFkwS4iozXEZcWOmeStwnJrNo9lXZxlMA1nT1VBDzjNncpEHe/fTc0/WZfNld/ULkTY8X2PZv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

I guess I wasn't clear before :)

On Thu, May 21, 2026 at 03:47:25PM +0200, Thorsten Blum wrote:
> On Thu, May 21, 2026 at 12:31:25PM +0100, Lorenzo Stoakes wrote:
> > On Thu, May 21, 2026 at 11:06:58AM +0200, Thorsten Blum wrote:
> > > Replace the open-coded implementation with offset_in_page() to simplify
> > > sized_strscpy().
> > >
> > > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >
> > I feel this patch actually makes sized_strscpy() more difficult to understand
> > unfortunately, so not really in favour of us taking it.
> >
> > > ---
> > >  lib/string.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/lib/string.c b/lib/string.c
> > > index 1f9297e9776a..7c72adc7377c 100644
> > > --- a/lib/string.c
> > > +++ b/lib/string.c
> > > @@ -25,6 +25,7 @@
> > >  #include <linux/stddef.h>
> > >  #include <linux/string.h>
> > >  #include <linux/types.h>
> > > +#include <vdso/page.h>
> > >
> > >  #include <asm/page.h>
> > >  #include <asm/rwonce.h>
> > > @@ -127,7 +128,7 @@ ssize_t sized_strscpy(char *dest, const char *src, size_t count)
> > >  	 * since we don't know if the next page is mapped.
> > >  	 */
> > >  	if ((long)src & (sizeof(long) - 1))
> > > -		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
> > > +		max = min(PAGE_SIZE - offset_in_page(src), max);
> >
> > This isn't strictly the same code, offset_in_page() is:
> >
> > #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> >
> > So this is now, effectively:
> >
> > -		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
> > +		max = min(PAGE_SIZE - ((unsigned long)src & (PAGE_SIZE -1)), max);
> >
> > So there could be some issues here with type conversions at least in theory.
>
> I think this should have used unsigned long from the start, as long
> seems a bit odd for a pointer, and PAGE_SIZE - offset_in_page() is a
> common kernel idiom for this exact calculation.
>
> Andrew also commented [1] on this line recently.

Yup, but it makes no sense as a singular change, it actively worsens the
code.

Hypotheticals about what should or should not be with you not changing
anything isn't useful.

>
> > But in any case you're now making the logic inconsistent (the next line uses
> > bitwise operations directly).
>
> Agreed, maybe there are other helpers we can use here too, but that
> should probably be a follow-up patch.

No, this patch is bad, we're not taking it.

>
> > So I'd rather we didn't make this change.
>
> FWIW, using offset_in_page() in lib/string.c (as suggested by Andy [2])
> was the initial motivation for moving it out of mm.h, so I'd prefer to
> keep the use-site in this series if possible.

Nope.

>
> Thanks,
> Thorsten
>
> [1] https://lore.kernel.org/lkml/20260519123740.458d905f958f39d41cb130fd@linux-foundation.org/
> [2] https://lore.kernel.org/lkml/CAHp75VfQNkqEYsO4Uup0c-uiYuVyAWit=tmCz2BsYLp-sjXsZw@mail.gmail.com/

Thanks, Lorenzo

