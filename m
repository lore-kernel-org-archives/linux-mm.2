Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67373C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFAB6B008C; Fri, 28 Aug 2026 21:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7566B0092; Fri, 28 Aug 2026 21:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303AD6B0095; Fri, 28 Aug 2026 21:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1256B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:29:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94669A060E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:29:37 +0000 (UTC)
X-FDA: 85152574794.27.BD82FD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BFC6714000B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:29:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HiX3f7UE;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787966975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=As5WzZ21e2lE9qQzcY6pB/XU8R4yuk56z+VgIeeRdPw=;
	b=d9kw17DN/NrKG2cOSwQscz+ygVYpEQ9YzkkRfgaQo+GROspb16Q3LWNUmZnWCjQ4yhOlek
	wJIdoL7nwM51B8i0ng/B9uniLYd1VX5K4x1hAAuCYMjw5qNGC2KlRRKj/NuvGrk3IwEqyn
	PrHgokw2pgAAYUEBPTmt/QMF/qZC9lA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HiX3f7UE;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787966975;
	b=ArFbsqIx4O4/f1C8eJwjhgYMpw5MEmDy8Q1R1IDbss2AULPc/jcH3aLnI5atHtMKR0DHyc
	nhHkJqRPHyNtRd/hTh5ytiWQ948GK4idX7H7cruZ/dJLCVLPCxB9P32tIJRBxc+YhvIScr
	NXDw990L6qyfAsZN+sCygzH1nEuXrec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1275D44792;
	Sat, 29 Aug 2026 01:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473A21F000E9;
	Sat, 29 Aug 2026 01:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787966973;
	bh=As5WzZ21e2lE9qQzcY6pB/XU8R4yuk56z+VgIeeRdPw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HiX3f7UEQ6C8SnqLgz+pze4w+flhncZZJ+hrrW1e2fhGWobXBunQRoT5Ze0cPRwpH
	 /9Xvu0b5vTlF16HB2AVvL2GEySXbbh+Q/7oRcfp7o32NWpobNyUyajlq4nZeO7GTlf
	 QQxuO5cU0J8QywTc4nEPLFIibz+xSKHwaqbPODKQ=
Date: Fri, 28 Aug 2026 18:29:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, liam@infradead.org, Nico Pache
 <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com,
 hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
Message-Id: <20260828182932.96529e36e992740eb8132185@linux-foundation.org>
In-Reply-To: <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
References: <20260828222640.1638457-1-jthoughton@google.com>
	<20260828173302.29778f1bf802a1db932778ad@linux-foundation.org>
	<CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qhg5j89i3thcyqco3e7phf5p53416dcs
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BFC6714000B
X-Rspam-User: 
X-HE-Tag: 1787966975-680395
X-HE-Meta: U2FsdGVkX1+KZh7jdpIa6kUY4ulikxz5BoWZaLQ7KIA4Ry62dy6N3wbLIGOhBnRq2EN2s75HQBJkhPGHRKLDIgYjAgJdJ/9lRyAuxU3o4j7T3DGxmvV+zx7rI3HGUtwkI1dW1YPvN3QqgbUf+8KU0Y/6OeC2afqochfLzey8yYHrSpAMubEvZD8aB9Oa/whhzUsIm1NuMXpa7O/UjX+LF2K9eLrZK8srLAAJP/i8DNkUA35IcPU6ZX219D5tmGv/NzDnlIG7rd3c/s16R4rooNTrx3zgQod/pSw3qZAppNKa/z5x8wbIkLQGUZVgeFjOxmdKo87Lm+wDxV2wQp7uKWfknQ61/+mMd6Un57urMdP/Jc1woyK+kGkVYV52044zB/XG3PmMYfaiC33YkYQRQ3I57E8D5omXN7RYYCPY18Jr9DuL+T9uaOgwv5n9VEwCU4oudjUSN8aGjUspg2OeUQpYmKo8S8FltpVYEU9NH7Fdnch9Z+IHtDY2ISuhCcltP/wDkp2ygqe+KwgcSm2ZsPULkVhLO4sSJ1pAmrtMXulpcgBReiP/plIDoetuvO4Y1OS2GqTBwjKyB36RlclNGa8U9AocsMWC820uqhkg8huLc6KlyI5SbY+sSeAKYCNeorpt16SHKeSs4iHSjAlpEJvcR6RFjvN4mCAEk+t5SNbo4JpHZbMhn3I6htNXhbNVJDsVYYejbWSoAxM7mOr2l57eT9pE9Pm6i0SxqiKFTzx80+qbrkx/MDHgSQ15ntSIdXw7mtp7xzrBWlogK4KnvlIWv7NEsJxXiahi+NwlHjeNACNQ7wwQqK6KJR76BD9KfYqLJl/lH6pTJToaKr/qDlXCdzcYNZTAi1EsDGhLQqtIjJX9LZYQigh1azuYnVU44d5/EhN6hI4ztJva9oQ8Ylg+BJkwT5WvDrTXqrO7Vx2dpAjFh0R4ZlbpFkvXSaXOiKQsCDiTMCY7UvEMEOi
 wKezjHCX
 aRvfoOS3yV8JjeCT8jcBfHN3z9uA/TMI627sqox/K3w6qaeCI7OxsQ474ve6baDRrlKRnxCXP+xsdc+UlXUWasCggHaBQM7fPIrLg15s8lz9pa6fovpY4MyaX7xNYrJxIvXXAFSE4TIpANqKa2ihPRIa5NHBi4Cs7q9tIclGUueynYXM2uz8T0x6+eMfBTJviow3yKJhV0x+bPdPqfPFmkUl3+Pl3YMayos73MGBCl6zXNrvijeptyjjYZQXjSIMuvl6fBadeUEEKwmbG7LHE7XEiFGfVNLmUxS9OBtdjDOxCXVyQydsJjOiRCH2G14RdFJ4mllYANXuu1N+ptCkivh/6sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 18:09:39 -0700 James Houghton <jthoughton@google.com> wrote:

> [lots of good stuff]
>

OK, thanks.

> >
> > > Suggested-by: Lance Yang <lance.yang@linux.dev>
> > > Tested-by: Lance Yang <lance.yang@linux.dev>
> >
> > Wondering what Lance tested.  Was he able to reproduce the bug?
> 
> I assume he just re-ran my repro, but yeah I'm not sure, heh. Lance,
> what did you test?

Wait, there was a reproducer?

Oh yeah, found it.  You changed the patch Subject: between versions,
dangnabbit.

I asked Gemini to write me a reproducer and it basically said "sorry
andrew, I can't do that".  ChatGPT was much more accommodating but
after a few iterations it was still pretty mind-bending.  I came away
thinking "nobody has ever hit this".

But that's not the point.  Now that it's out there and known about,
Black Hats might be working away to find and utilize a reproducer, so
yes, we backport it.

> > Sashiko might have found another race in there:
> >
> >         https://sashiko.dev/#/patchset/20260828222640.1638457-1-jthoughton@google.com
> 
> Let me get back to you on this. Best case, I'll send another
> (separate) patch. :)

Great, another patch ;)

