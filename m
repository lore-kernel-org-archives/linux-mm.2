Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D234CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923B96B008A; Thu, 21 May 2026 09:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBF76B0093; Thu, 21 May 2026 09:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838C16B0095; Thu, 21 May 2026 09:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 727936B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:47:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2821E40566
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:47:35 +0000 (UTC)
X-FDA: 84791554470.13.3F1C592
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5995D100005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:47:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JvHvMHUv;
	spf=pass (imf05.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779371253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXj32I55bWmtT0XwdpfkCPw1jMJbMSf4hLniENsiCes=;
	b=l1FSxM1Gv8B+ioAj5FkDDMiWo6Q40WoLs3WAimJp96YIUiORTMYcsl36MpsB5BSB1ZXIAE
	XhEBYFUXVZa2J3QD8uHfUx48Csx5Wa6s/eAUIESAXih02G96Vg+9gduOCFgK6g0zZZboCA
	3M5U53a48a+hYf+n9aZTEWrngtIzHjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779371253; a=rsa-sha256;
	cv=none;
	b=izCMdEA6ukLcGpGBYdP6GLaa6uRKvmevQMLScF8bWEzokxscSiYLS87qR8DK5rluVaOhtQ
	u8c/UuDxE3xpritvZbHGX0bUMvs7ideAO2aFl8dN2OA9mU0Rmcu1Q7X7HQg5gWNHrIxREp
	f2G/JsTozhuIoLWM5dKbfP7zDa9ZENM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JvHvMHUv;
	spf=pass (imf05.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 21 May 2026 15:47:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779371251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lXj32I55bWmtT0XwdpfkCPw1jMJbMSf4hLniENsiCes=;
	b=JvHvMHUvTP5iSDiOj3NmWHnaT83RnAK19Alv9f7afp4sZ0NXK0L2jmVkmDKuPmJFXmiYm+
	casCmMD030Nvz5zbTIFfYiRBv1/NN36btEreqFXPs6c5htGbxoD22i2x9xOaAxik1NwnYv
	r06SIwnQ3hzHMppGpoY04xaurC26kRo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] string: use offset_in_page() in sized_strscpy()
Message-ID: <ag8M7UVI6M_0KPC5@linux.dev>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-6-thorsten.blum@linux.dev>
 <ag7pg__Dzs-tKfGw@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag7pg__Dzs-tKfGw@lucifer>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5995D100005
X-Stat-Signature: ofw661qebgy1iedozpfxjfuc1tfej915
X-Rspamd-Server: rspam06
X-HE-Tag: 1779371253-675126
X-HE-Meta: U2FsdGVkX19QLSYbsUjPRE4qQb/69mCEMj5FleoRycQH65Woo6gvoEb4cp2qtiuJqUjLFuFyDG8ZNwEQ0/83z70LhkbjxExhFH0PlvmVzcJLinpslgOeEQEp1wUFLgp8ZtzVo7qbABpjG793gcUi0PUjVrJk20JYOVhekm4+wJuZVOeWBzX532XWhJFWLDdBMwrvseq5A8dV3unV4HOA0HYQ09teRjO9ideMia5f7InDB6iCJvIS4M3f3oG59s/kNEKPXjQce8d4otXSpLJRSh/hyatXezXZvXLBNWvVTx59GDAImOe5FmvVdYAqtbG685pIX1rzJJI9KTmmLozWMcaz7GIL8c57on72Rq3Y1nvGuzSdhMcFiSVhYqlKaeuzHyGusSKPglONX2IBZZack8eNllqjqLeImXmcNHeAgYLePTn72RIX7i6qI5gIxy+ZAcvk5xk4OlM64pW5zkq0H2zHlml72iTWy6oVN472HZ3FQRQCH0+CETetsND4aJAE9j+0VVSqL758W2uhiD98GYgT5b3FcWgXxsAGtxkPPKGCopOYWqQMRdmuJ/2CsM6MRwreFHAZHNzQmv0OIMQCoyubFrjfIOWicsheFis9tUSpA03frdc48PL7AhBFZJUgdzE3zQReL7mzgmJd+CZz1S/EJOjAyyNub7EuYzS3TwwOt52NvPc2a7bgREIBmJ5buMkUv5j3DYRPk71bbM8wqfWsxY3N1opIIXnTQjh3PiGXtjDj3XXbhNEI9+n9AZrDIad0JTHQy9QcTtjDUh22KBfx+WdotydeIKE6GwjKK8VWwkrE9kD+fINMynVkKzNwQF19FEiPQgptGL7lMUonzyoC85Kho4bW75PesAdrnXj+oSuD+ZscvqNLZYln+F+jXoaDjBZUGWJ2eLeD1BcIOLENwZVIkPAjSqZX8UlOuObY0lYjj9Bb/9I4Bw3YKjkcZ8XAEUP5BbKv8M07l5g
 8ZIHiVDb
 yftytbkdIBAP8c8RTu3OpkN+e8Myz62wt8gjnwT5NseX8jA3WHP6NBQNXEHgOuUJKhS74gk1IQGdc7Vb9n8sR6hqfkdfnJbKTZSx6d3iCpvd0k1cIoLz1xG1gn6AoIFVXC6wMUJpgEben8m519oEt6NEhGWDt0Gp6QH3gFwKTKK9UrLqX75Rhnecc5zBV8J0x0jm1qz0/wtLafIVgpVSGwYMtKo2G5J87gxiLdDt0dcQ+AtAIk8hsdcv+BeGDNyaVMFgrQCwmobSlSio1N5OF2qh8vhAjcYVMZrUsOi3frpiH62dx8+MMYIWJt4oJf+DHf4ZWXvRaU1kz/VhUKqDLhDrWV3x6m3FRs6AZMZ+uIW+pmIlrLUrvU7+9Mu0AjiP/FK6Ovai8JNcM21B3Xz7/Qby749TtRr3U5cTS+XElH+pZWdYDIzgnr+mwvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 12:31:25PM +0100, Lorenzo Stoakes wrote:
> On Thu, May 21, 2026 at 11:06:58AM +0200, Thorsten Blum wrote:
> > Replace the open-coded implementation with offset_in_page() to simplify
> > sized_strscpy().
> >
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> 
> I feel this patch actually makes sized_strscpy() more difficult to understand
> unfortunately, so not really in favour of us taking it.
> 
> > ---
> >  lib/string.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/string.c b/lib/string.c
> > index 1f9297e9776a..7c72adc7377c 100644
> > --- a/lib/string.c
> > +++ b/lib/string.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/stddef.h>
> >  #include <linux/string.h>
> >  #include <linux/types.h>
> > +#include <vdso/page.h>
> >
> >  #include <asm/page.h>
> >  #include <asm/rwonce.h>
> > @@ -127,7 +128,7 @@ ssize_t sized_strscpy(char *dest, const char *src, size_t count)
> >  	 * since we don't know if the next page is mapped.
> >  	 */
> >  	if ((long)src & (sizeof(long) - 1))
> > -		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
> > +		max = min(PAGE_SIZE - offset_in_page(src), max);
> 
> This isn't strictly the same code, offset_in_page() is:
> 
> #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> 
> So this is now, effectively:
> 
> -		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
> +		max = min(PAGE_SIZE - ((unsigned long)src & (PAGE_SIZE -1)), max);
> 
> So there could be some issues here with type conversions at least in theory.

I think this should have used unsigned long from the start, as long
seems a bit odd for a pointer, and PAGE_SIZE - offset_in_page() is a
common kernel idiom for this exact calculation.

Andrew also commented [1] on this line recently.

> But in any case you're now making the logic inconsistent (the next line uses
> bitwise operations directly).

Agreed, maybe there are other helpers we can use here too, but that
should probably be a follow-up patch.

> So I'd rather we didn't make this change.

FWIW, using offset_in_page() in lib/string.c (as suggested by Andy [2])
was the initial motivation for moving it out of mm.h, so I'd prefer to
keep the use-site in this series if possible.

Thanks,
Thorsten

[1] https://lore.kernel.org/lkml/20260519123740.458d905f958f39d41cb130fd@linux-foundation.org/
[2] https://lore.kernel.org/lkml/CAHp75VfQNkqEYsO4Uup0c-uiYuVyAWit=tmCz2BsYLp-sjXsZw@mail.gmail.com/

