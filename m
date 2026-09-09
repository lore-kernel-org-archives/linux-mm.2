Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D056C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8106B008C; Wed,  9 Sep 2026 10:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089696B0092; Wed,  9 Sep 2026 10:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9216B0095; Wed,  9 Sep 2026 10:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C797E6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:06:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5639D40208
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:06:48 +0000 (UTC)
X-FDA: 85194399696.04.F6AAF5B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA2821C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:06:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rcsC1nVJ;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962806;
	b=YTP4k/m/ROt3308irYdcR0nAPwJSYtaz3QwBiLlBWphHfAGrRX2NMXAVSj/ZJpZNYEZKXS
	Au+VDkrPJeacsz/twJJ7pxSSZX44QxYDh1VM0S3DDBH40hz9u/H5UAPb4nHJdB2uVZ/VfU
	xDTf0luhrVt69OnC+cEknW+n1cfMoY0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rcsC1nVJ;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARyHcdAb0HLmyx/eDFN86Rb81gJGVIXThCIEa265DUA=;
	b=DWlGXB7ibIwlXt37DrfFF4gyM/bC3BwrcJVJ5N7GtXttva5M/omYgQX2WMRR+5hImipn5Z
	B/dE75fUL+pcVFnCA59jsapAxmJkjVXm8NIUp7voAXngm/44YpLagePLqMk/gPCMGteVSt
	mq20ELUhtEqIdpOqkfrjISNQHNuSlpE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ARyHcdAb0HLmyx/eDFN86Rb81gJGVIXThCIEa265DUA=; b=rcsC1nVJ458PkGkasholnKxN6Y
	8410oN/kuEDXUbOFmM+71oC19ElLRGi06Vt5lELxPN2NRrvCvoeFrsuLjkPROFDyV4u3NzsHyF0Dw
	4EQKOZ0A4I5dZd4/wWWTiaK8hrAjVAFqM33pEkIiQi5D4RBK54/6Ywa0Ltduv+4JyaWasZgqS3bhm
	pPivoqW8OISS6nImyYN3ZxQ2g6tRDXdHf0LegFyAOOcbpFXay9V6Q3b6/OKIBV7i4y9Kf93r21acK
	b5ht4rH+nV412qx7B1mw5ATercq3FkeW0Sku5yJAxhNUuXQRReH+Ypx4/wZnjMY5NPNXqRIGMa9Ru
	AE5xkGuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Iw9-0036hX-08;
	Wed, 09 Sep 2026 14:06:05 +0000
Date: Wed, 9 Sep 2026 07:05:57 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-reviews@lists.linux.dev
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Michal Hocko <mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Borislav Petkov <bp@alien8.de>, Suren Baghdasaryan <surenb@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Zi Yan <ziy@nvidia.com>, Thomas Gleixner <tglx@kernel.org>, kernel-team@meta.com, 
	rmikey@meta.com, harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
Subject: Re: [PATCH v4 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Message-ID: <aqFm1ep0mIlJpA-d@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
 <20260909132128.AD4D01F00A3A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909132128.AD4D01F00A3A@smtp.kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA2821C0007
X-Stat-Signature: 65ugyayajb3zywnydnjdugot8qz578uq
X-Rspam-User: 
X-HE-Tag: 1788962806-524259
X-HE-Meta: U2FsdGVkX1+Tl+DtYIXz8HAYtcnTiwBgtlyyb40EQ/iQqWoWNHdAslxSS4Nh+by4kS4UyWD2vhtoRZ3zm4/SWlkvIgElNJUJAHKV4D4pPWd6pRHYvkMzhbbptHSiWzTi7cWkkxklT7USBKMO+xtW4dG9wyTLQgmVeoYRYxvdYz+UJDnYijndVd3XOs8hkUjx8CPp6CmgP58lt7xFzBuNZRvjf9g/7N87sAuKTLpPMsJq69fwrlkOWa8mCaSExgIxP9pi2tg8qSGNsWxJLJOHEKdhOtkyp5LUDFfzZEqtDn20O8gMC3A1LfMFxGaeTCKa2tiCGLAbPGchGLs1+Jlr5H+A/sCuQqv2D0VtoHjWHPdDtLdqUfq2QW0EfYP/ZFO/si3z3xoxnQ/C7CwNe9se/u1CRKR42QgFhAhmYqde8Wgsd18hrDGvb0bR4mbclVKDG9dIq1kGd6lwNNjP8dVAqhjxqcTpZmA9yiJm5UiYX0sIgUDEmiatQS4E/iWg+vF+W4mq0Okqkhe7kU8sb9ZlLZivrkhdhfi5snfNzQldr4pbT1VINNi6VqRDa3ncovRjgDnyHp3B+h66BD8ihSPpW/kwVMCibqbvlG9qgEsZo2mvyiNIYLqpYyGAOITNRE61f3TiXcKU88FMjYLip37RivqoghTC9aiyMxDMR/K9GQy1Xn+RUfYxYJMF5EECEBuBVqANLjoy48duU5pqt0uvcWDHn63OWIKG/L4S9jGdlOuCtu02jPxez18QwefOhe7BZZ0AvL7oxBx2z8ILio644prxOoJjMZ7l9VdLNkJe3obgq3hEjwkLhENQjMsBrWqm02MU6vhXY4jmo0LtbidB+gzDnl6MmXQtr7yAdFvx+IDyjcswNXAApPpkB0TUVVpk7kcIzfH2w32mW1HDFMunyiRsGkLkQRYeTFjxr8vSTEe2BUlo48rHy1RIEWkUYaQtJ6Q9QOWD1Rt5fd6kNjl
 W1ArwbRV
 /eP3ukGeWgg4ZYcrAAe+ADoV3H6jP993uY5bMPaneJfkyCFhxA1suesiMH3cONhv+wtfKi+Q1o8/TyWQ07KaYK2WzxlRJboWUsT+4eIIZEpNqmhBjtlUpXVeHOZxji1d2qm30pv5QRxcUQkrlM8brYot20KnveZFcz2IQapVs9jzJlp2mU1K/H2kcB5nahpwldZUqKWeah7GykA7H83z5Wkv7rm4Kak4Ny+12+U+36TUvNgvvfOrzLf8ZHhmaRn3p7oEhr5ojPxxTbQZEMCiPTHwKIJFgSApc02TvtJvPdHwoB1q4yavY+Fs9hhy8dOtzrFIuGIcRQUDg/xP/GBdorCZe8a3zBiVgpLn/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 01:21:28PM +0000, sashiko-bot@kernel.org wrote:
> > --- /dev/null
> > +++ b/drivers/firmware/efi/poison.c
> >
> > +	/* Whole words, and a bit count that can be taken without wrapping. */
> > +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> > +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> > +		return false;
> 
> [Severity: High]
> Does this validation fully protect against an excessively large pm->size?

I was clamping the table before, but we decided to drop it in the last
revision. See the discusion in here:

https://lore.kernel.org/all/apGWUWi5-RbhFHpe@thinkstation/

> > +	start = PAGE_ALIGN_DOWN(efi.poisoned_memory);
> > +	end = PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);
> 
> [Severity: High]
> Can this computation wrap around if pm->size is maliciously large?

Yes, but that means that someone was able to write to EFI memory to
update size?

I can definitely BUG_ON() on "large"  pm->size, but, I don't think this
is what we want here.

