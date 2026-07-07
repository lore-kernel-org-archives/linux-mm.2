Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFAFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E907E6B00A1; Tue,  7 Jul 2026 11:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68656B00A2; Tue,  7 Jul 2026 11:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7EE86B00A3; Tue,  7 Jul 2026 11:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B15276B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:22:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B3838E676
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:22:32 +0000 (UTC)
X-FDA: 84962347344.04.36EFAC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89C461C000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:22:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=YkMkHYeF;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783437750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWbGKIL+LCjf4g0k1cYsV7MRDHagLBOBJIKEk+njlqM=;
	b=4wRg5XpQ/DzrbFQwotnwDtzGqMfYTmi0QgHryHvbpbiXgahvNc5RiizlLpAFdTak3H7pdT
	DLRmIi52bvP2YiJE7Gj7oogODMy6P3R2o/BpPF/nOqbDVojIBBS6K3JtAjsJ0chzQdgO1D
	EKSPC6sktINYZRG7O/KGn+gJYnF0N/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=YkMkHYeF;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783437750;
	b=HwbNcAsWG3ezVuzWqYR0VHxDsJ5Z+VVbCD5hhJM/M8ZiFC6UsjH9eHxAqG6jD82aF7lIXM
	VoJXnLE6NMbTi5p3I3SPtmSl7g8UTX9jhp80Aej57GPqdnb6nWQRM+W2JkCZbR2GH4NTLB
	UaIGFd97mDCjxpv1ijpQMrvfM0Y/1kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE6542BA3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB711F000E9;
	Tue,  7 Jul 2026 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783437749;
	bh=BWbGKIL+LCjf4g0k1cYsV7MRDHagLBOBJIKEk+njlqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YkMkHYeFcGxlVekoZBIAd9nQJVKRwUVhcLNQFhDleC+BpBzir5PbuNpnfKlIyEOSJ
	 y5oGJTr8VPl7V5r7pEM/BVWAcEmg4lW2AFyHE36iGHmW4pLMCy+uHsyOVK0MyKoiSA
	 dJMmEB8WTcad6+dw5YwiBhkSOxDfnlKhtpqx9gMc=
Date: Tue, 7 Jul 2026 17:22:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: serial: men_z135_uart: replace
 __get_free_page() with kmalloc()
Message-ID: <2026070717-elixir-pointy-c698@gregkh>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
 <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
 <18bb4a45-c26b-4a89-b598-a844d3aadafa@kernel.org>
 <ahlRqd3e94ojSfWE@kernel.org>
 <98ebf7d1-244f-4fbc-afc4-3e8940df5422@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98ebf7d1-244f-4fbc-afc4-3e8940df5422@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89C461C000A
X-Stat-Signature: f93kej7m1zx7d81gqr7fsmxuyjndr1sy
X-HE-Tag: 1783437750-999375
X-HE-Meta: U2FsdGVkX19oVE+4tddPSXeP7uy0ZcfZz2VcQFuOlbuob2XFDIxBZt/11il1ur4UGWTN3z+m9u4XNCERZsnxY3XBDobOEQSwnfjW06KcvbHUf98i3rCiFNfIteTRoYBZ4iP4yLnSMeyg5dDwTa3hJTXzpDwbwDhpWKfq8fhMxATypHnm4wLvJyhQmJ0XXTNhzB8mehDXPR7Ymp6U5N9rmjKxNYbc3F1k3c5ty6E5SO1lRpTDG6PEkXHi2pXV0zyLsNJfveztjmi35WRrYZOxMV7apjwC3yboh67BNa4K1mzvfpAGWD1/THA3nLpZdOBpUYLRvj6O7EYvp2zE9L6vKPAXoaWTUIKJyuaF1A4g/WkF+nWqzAuISj7Tbt4mgxz0Hl0qjolcYvfqAkuGD59tbYmOqkD+oKIxohY0oKplN2ZMqf9Q6ut/CdCq74e/Nnh8hntMrFJVqSxealu0ZDY3ZRuY77Xv3ftV+PsuVENcO/CSHpKm6J6YvFgwiFisZzbBcB7bfECZghjpcjsvPDhrf8ETak7z8PGwcU1A56O9neKiDOEWF9iUKa1S/jyEoXELad/JTbbDg0e9wWz8CHTFR5+LTSeu747b3x+X53J/joKVrrWWupLUu4bEXDMQYxgFv3yJjvjlAcq7qfIEp89p/SPtIzN1Ez9G5lVZ9eGUzqgC6wND5J/3JEXBcyQ0OtdnsVZNVrVVVB8rs/JQdJraJpQ4ZcEzQZjeggZJMrlJuFvr6h16m5v/jz8RR4xcgHWosGolEvPRVqi0ByZRRQ/TMuGXhDaBSvupzQ8BA7MCkXVue9yH8fT/L9pgdEkUY8gZfd2o/nNaMXroKGIB9z8kbsm6uSon9FrobcIXyGS7zdamrC7d9rwied5OQinL9vpa4TRVRty0tED+M/tEyLdfckYqx0fhX4X9+yzjLa2vdewoeW5oPCbbkPYmALtVQOPfKy8fhueMfVEFdb4u6oa
 lbYMHN+C
 hxSTLuwcOq3Zdw2CZhxcsq+qRcYzNcmho13yDO58pLWFoL9kLNi5moO7nfbVICKQJuYscXjMshQsFCYg0RJBObN0CvfJ9M7snSDb0CbhGik51TFQprks9jmaeekKPyOh3ORWXMaOHJ2KrO/6efpHnLLvTnBg4eocnVrChHgb3+Lk42gMvs7eePBO6p0c9qDwZuzFSQF3ZrkpNJ5nA+1C/L+Flq6UWWOBbsU64BP14dUee5j5MKmP/L3xr4CMdtNiCYpAUumm6Vj4w/GvUAUvi7QEij+dc/MKWzAWVQE/1dWBS1xXPrXAc0LsmEvR7awnD2iixZ61dKZnG9xno0rVyxyhd/zBsRunMuFfeP/hOCUloP7fg6GdTZxGNoPTz5ILQ08fRxpuopTmf4lm5ikfDOIUWvTimAaghe59V6QVjwXMeBnkRuKQd5aZ/YAuU1JiMoWpGJuP9//s7+oY8kQXI8nZCp3ZawtA/rfpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 10:52:49AM +0200, Jiri Slaby wrote:
> On 29. 05. 26, 10:43, Mike Rapoport wrote:
> > On Fri, May 29, 2026 at 09:47:33AM +0200, Jiri Slaby wrote:
> > > On 28. 05. 26, 12:24, Mike Rapoport (Microsoft) wrote:
> > > > men_z135_probe() allocates a receive staging buffer filled by the
> > > > CPU via memcpy_fromio() from the device MMIO region.
> > > > 
> > > > This buffer can be allocated with kmalloc() as there's nothing special
> > > > about it to go directly to the page allocator.
> > > > 
> > > > kmalloc() provides a better API that does not require ugly casts and
> > > > kfree() does not need to know the size of the freed object.
> > > > 
> > > > Replace use of __get_free_page() with kmalloc() and free_page() with
> > > > kfree().
> > > > 
> > > > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > > ---
> > > >    drivers/tty/serial/men_z135_uart.c | 7 ++++---
> > > >    1 file changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
> > > > index 6fad57fee912..9c32b01edc9e 100644
> > > > --- a/drivers/tty/serial/men_z135_uart.c
> > > > +++ b/drivers/tty/serial/men_z135_uart.c
> > > > @@ -17,6 +17,7 @@
> > > >    #include <linux/bitops.h>
> > > >    #include <linux/mcb.h>
> > > > +#include <linux/slab.h>
> > > >    #define MEN_Z135_MAX_PORTS		12
> > > 
> > > This one is misplaced.
> > 
> > Do you mean an empty line is missing? Or there's particular order of
> > includes here?
> 
> You added it after an empty line -- along to #defines. You should had added
> it along #includes instead -- before the empty line.

I've fixed it up when applying it, thanks.

greg k-h

