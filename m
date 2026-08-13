Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409DCC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C356B0279; Thu, 13 Aug 2026 09:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10ED66B027B; Thu, 13 Aug 2026 09:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F191C6B027C; Thu, 13 Aug 2026 09:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3AC16B0279
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:32:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6613F40170
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:32:44 +0000 (UTC)
X-FDA: 85096336248.29.D0D8EFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB2D640010
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:32:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVpa2g4O;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786627962;
	b=3KMNtMWDiMcsrbkexznI1Uz+QUA3EoQuW59jqmwF3AJN+oi6zdAxSnaccRdeeDVPZS0y/M
	MkVQVGwf648xlur7kqp4qjibmaHcxBbH2CCuH3FNIddQyYwrjYLo5bDDqz6HYQIHc9uUrf
	Ixxy9MIufluXw2+nqxjZbI63jlhSFk4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVpa2g4O;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786627962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3t8Xb0YXKt1FxrUR+ySkGbvszp55d2Yp5AkViZUiMxw=;
	b=ftihtJqNa9F4mbI8IbEwsWcpRKVdHrORiDhDAxPmglYoAM6HIXVThK8NRZOiR/g1IAZvYV
	7KRQEIPKR4Ls6Bs7DHruLMPU7C3pAGuvZOPU0itMgglKSRhE+Eh+obhOnzJ2ze7zyw23IK
	mC34GiSXw1rNfFdzs40LbCfdxamiFwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B7E442A33;
	Thu, 13 Aug 2026 13:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4783C1F000E9;
	Thu, 13 Aug 2026 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786627961;
	bh=3t8Xb0YXKt1FxrUR+ySkGbvszp55d2Yp5AkViZUiMxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QVpa2g4OKNlEH0QzM5QgDjzW71l6ULJ1n6Xb4TfJx94YM8fCdRj/Bc2ADDk2jToCC
	 7SoEas0nc0i7WpbTMC4Wc4xpi5BBP5AlDog5epFFAFzDeoPgyYwXzGzlDv3XEIN543
	 AfkLcxL8dbYfEptYvjkLNv4dZRxrTQzIS/zR6LtSqZ++1Zfbn/NHqSqblznZR1jnPL
	 YWaLSQBi+d8vtO5dWgDRXkMFCB77C3bFVq6zSNQ3zofToMzCItN8wfQAnHTXyOhYDN
	 pSAkm4FS6Eb/zCVAk8gEqNUodPZ5+4GcpNkPx52ZuxlQ53pL/ar0NXa+NO4b+lmUjx
	 AujhvRFyXjlcg==
Date: Thu, 13 Aug 2026 14:32:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3G24JX-ZE9Obbt@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <an3E-5BuWLgwzrd-@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3E-5BuWLgwzrd-@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB2D640010
X-Stat-Signature: 4hig86ngb5gj8yh7g1ahr7796tkz5hpp
X-HE-Tag: 1786627962-494549
X-HE-Meta: U2FsdGVkX1+Kw8YLy/mbFy6O+vMs1ARXMUr51DxwfOVICO4FuTtfse3WaNo5b/PdtxndJS8tQBxKfidVqdw2H3rgmcLf1LWUw4cPYzGEU8EbNqM3mCDO0Q6w6+veq41o48hmRxlzOmBJQl5zYO7QNMADggj2ctvlz+3UFYNXsHZU1c9RUlNCsRw2QlEML5Df1POxOVBZsAVFtg0NJBzKjY18bzTzNNlBEnEUHVwASes2UEF9K6AmJrOjNHGUt9PWPENy94lBiXm7U0qp4hzjYkG6Zx8/G+FKLWF1el62zAzNB8TWjzYtYvGF6xsVUx0gAuTk2qmmrZNWGMA/575FprVVaQGzp3JKJOUR5nWTmqKgVdHpk7wUQb3WKBRZuj/DOwQEAc6S1++5sMQobmX8iaii7qviFK3p61Cz1NqSj8MoqeAtVDUsEWEguyMsuqWIBhGEbo8YsS+NChuD2LPF9oNR+Uxv0wqyqSrKjg6tbxZY03RHpz0k6l7o7ZJwZrjERW8cuW1MtA7zDhdZX+uJxCGRJs14SjFgCMcqq9YOwVu0SDjeyW1+5M3KtA+vx905PvxMe0Eb6Lv8KRe0eL64S7BDta8++6ffcb41qGkAlqyOBH/tP8Qk/bgt7eiiaN7dKhK9u0GALB/WUw9a5Sd1pTjW/9B4mKU4F0MkMtD5niLzPKWM+vQ6K7qETcfAEne2/sphdE8wpI0v33hw0lWBigDxpitNB6dK4iCrS+Wnt1s8PO+dHBqY753rEF9OTE1igen22Ly62NuJr1V1NR/xXmTzUlqqS+J2P65Jdiy7FnhXX8R7kL7AKMdeiwlYexDphwwBZMUHZbWYRT5IDTbCor2wyWK2zEzvEU+dzXuxgpDgYcLJLjTy5+x+JDcVUXRfvogC/umN0quCbvZ0OnBmxWwcUWmyauCEOCZHl81/i7qU/jkhp6kYwIuL/hbPn/wmaxQL6gmGLO75VPTscGF
 FJPpmda2
 tX4mmuY2pr/eTszoNvC2QhOfNLDljQSvMllGVTzKsTYqKOHompBvXXsfQrbMkl+wP8ztTBu03OAx4gmpp0uxouXmMyPsKUyQIvT+NEliIvRQ+NAgy6gvTZr1aBypP4ahkFXzNzNX44HEFYBRLu6PDaICe8pULhz+PXYhf1z44ojf/px9YCLGoDDPUgH5qQCAZ/EVm4BBoLnqxMAajqGSpVedPPo/kTjBdTFhug1iRt1cDTSPAqlN+KUCMOMkh9MAImtxzxx3w35aZkXb1aQVLM+yZOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 02:22:03PM +0100, Matthew Wilcox wrote:
> On Thu, Aug 13, 2026 at 09:19:47PM +0900, Greg Kroah-Hartman wrote:
> > On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> > > Upon a private file mapping request to /dev/zero, it calls
> > > kernel_read() in do_mmap_private(), getting a failure with the message
> > > like: "kernel reads not supported for file /dev/zero", which is because
> > > zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> > > definitions.
> >
> > Do you actually use a no-mmu system?
>
> If you look at Hajime's contributions, you'll see they're far from an AI
> slopper.
>
> https://lore.kernel.org/linux-mm/?q=hajime+tazaki
>
> > > @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
> > >
> > >  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
> > >
> > > -	if (!file) {
> > > +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> > > +	 * and /dev/zero is marked by them at .mmap_prepare,
> > > +	 * which should be _before_ this point.
> > > +	 */
> >
> > Wrong coding style for the comment, which is very typical of
> > LLM-generated stuff.  Always rewrite the output of these tools to
> > actually be sane.
>
> A lot of humans write comments like this too.  Indeed, it used to be
> the preferred style for net/

Yeah Hajime is one of the good guys and I don't think he's a schlopper.

(I do want to review his series, as usual time is against me :)

I do agree with Greg however that nommu is something we should get rid of. See
my other reply here.

Am frankly fed up with people telling us that nommu really matters and giving
talks at conferences but contributing nothing (apart from Hajime, who deserves
respect for walking the walk on that!)

If nommu can be broken for a year with nobody noticing, then maybe it's time to
see if anybody notices us removing it too.

Sadly I think Linus won't share this opinion but as co-maintainer of mm/nommu.c
this is my perspective ;)

--
Cheers, Lorenzo

