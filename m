Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379B71075273
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BAE6B043D; Thu, 19 Mar 2026 04:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC8B6B043E; Thu, 19 Mar 2026 04:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5290A6B043F; Thu, 19 Mar 2026 04:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC7C6B043D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:47:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB28D160422
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:47:37 +0000 (UTC)
X-FDA: 84562184154.04.D0888CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 271DB140006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:47:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QDGvhwgE;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfanbqxR+HQ8nv2uowsANH0YHLTtZx7bJohdK38qMoM=;
	b=SSlVq72nO75tU9UAdhKghJRa5qz1YtsQ6/WlO+dladsR18HWxWVwbBMB3RrkBJWEW/KUGB
	0SPwYjEZCzeaxUrVAgZkL1vtDSYV4ouc6cPs7PeqNHJAjKTPfhR7MZYHTtp/RRMjIxjire
	Apsy+y+85JGeUS47z3Nk9Str6Db0lrw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QDGvhwgE;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910056; a=rsa-sha256;
	cv=none;
	b=C02S/Ee4Cq2hTOc/c//PM/nskLjQpYBx3O6VcszVQLaGIxmVRSziLpPG4xNf4P68xalebv
	xZ0FbZbWgVwe7p+pcObU7D5cJ9DgONRSa5/v2v3f4zZqiP3sBjv0McZTSWGYqN4t0YOD2t
	aBdPGTl+a7lpVBiRM+UzGGXYWiZdW0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E50E44395F;
	Thu, 19 Mar 2026 08:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B52C19424;
	Thu, 19 Mar 2026 08:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910054;
	bh=Nqr7vJ2IkEZgCrytTt+nk08H0Nhl6m3l0yrCTDwteoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QDGvhwgEukyMVeAzviczVkWIfQk6Vc+iDzWS/Y88bIDbDBqRdlR7QNnMrhqUgAiWH
	 6Qdg3RyxpfXEWq7l97soydy+ZHHTrOCDcMdKsHZ2pIsFNilD66sIC7eoT6ivGSsEx4
	 gsYF+DV9oGrcMdxGwhvSgN1FtTsQZJ0nVDjgKuXSSQuhFaPRTnvZgv8ulVhJVZTn4p
	 zVhPCQOmCpp949dpD9QpgH7wgGaXLbWS21qaHClDmffgg7w/pLPl9ENi91ZyLDrUyY
	 OOTO0R89d10hUbrn5iu64jRCGbtDyguzn7X+6bb0SXHM9mzbmtIn5a5cZvpMCAKRUV
	 reeIfmkqkPl9A==
Date: Thu, 19 Mar 2026 08:47:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
Message-ID: <06625acf-ee08-45ee-bdbf-5a3157df0468@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
 <absnshL4E4iXSC1y@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <absnshL4E4iXSC1y@cmpxchg.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 271DB140006
X-Stat-Signature: d31znqyekkmwoetbzgzu39z7mq9uo8ku
X-Rspam-User: 
X-HE-Tag: 1773910055-631759
X-HE-Meta: U2FsdGVkX18vH03JiK5rvbCtOrfyt591/LBPcbUclNNuvxcxZZQsi85A/QFNpmn/VbE7wunOFHeJ5UksDvC8c5Rpt/AqVuoysOxMFPlgW+o09Jn+d9MK6OEVJaR9NbbWuifwSGBJMpjQRI3ymLGgja50z/apwCArDU/+oZi4+5tzcfiLBx3CYoUfPvOY/+VSf8FDo5vN2mmL7nDmBrVdP578eBycHDhpZwwyCJRTjlQ6apvwP3jlWdyFm4wp8ZMMyAFQ/0RN9AP+kwOMWkkpSd37mEq2l44jGfNssHmMBel+8eVNY6S7Ym+PWeGKtxXh8mp/o6yKP2gUTvfZustwurGsC3TFpbmkyL0LTwFgI5aJ6d83NbDr4G5+RUkWEOehbIJDhA7qYkg56UUWX21EAI/cfnXgnaQbYErwaL48poTQJdaW5tIx5HgRlVB7yyiD+wdyt2nt1uCwC61Q2FJUCA9jh7GxbdyQZPRlIJl6zb5S5mga9nEzrIu5AIcstKg2b9esWZs+hs1259tejEa65V8wgXcwuMkpNrNE/5hk30QQVLNFaSb5jbUEsPbOExph0jRqEnqxgJ4g357ZpR2KsA8mYG+gnpUcPYdM0ltiSHNr2R0It9nlimZXFLSi7qx+tGrBQ+ZuLtGl3dxdGI2BU/9ssAA4kzPPSWLuNCHpML2/7irQZm6BCKJJ3PiK4v/GSrdVxPJF+d1aa4Bif5XIaYAVyzH/SpBQhc6K4mVVoknGO379WFXBzTgv0kEJS/M4Tb/iSaDhzGvdTJQAJw1FyAo+jM0bkTceSHXNM5ksj4eWoSbukw0KGFg8CF6wuyl6lnzx7YnpBNSCh4eLrts/fVXeAnb/WYzUWVdGiRQo7v9g3ASJa8DVVb694Q2LXqCa45www+WgCJiBatc8gjJcpVa9HVdT+miysKQpQ+seCIukJk2C2AYMhxGNISRhIcpPnOFL87YYCxX1lxyf1TM
 Lm8Vn4C8
 F+2F7/EJYQBjoaRwYLczoOWCCS8KNDemlL07wvLYhC5oqsxeDbefYDIJI8gcokCmIFMDXM5sYNrRRNbgXXwB22ybGykwo4C6Voe/PzPuYB2oyvpzjaQEPybKiQQwBKzlb94B7W8sWe5dk0iZw9ZJTZTWREopsmgOy7iJUUjHcHq6Kqgf/QGMl5vqXz0XkTC/y8NojBmkW3jb/5J5eqh0K2ufYyvoUGhdEuOnG0X7AOlbX4Yk2YTEb+87xfKsYdxMZTrKU3Uuruh7cwc7GMfSFKXivvPDRApzg+YjeswUV3zD5+oucJoH+c+FJoIYqQ2TUGDdsKxRaz4kWG8UhLubD0pSDd76IZXtWNf/OloN06ne1r5QJIFM1NQuKHbMwBPwbuUzp5v1vSH1J08p8lok1OLFMQaa1lbZrVMNigeELed1tEd0sIQrI9Bwz7bXYm1sR4qhw4nW8FS0/5i7D284uJ9UOeSvKUiPV6NSmCbagRpr/PmmpX4fjH17vig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 06:31:14PM -0400, Johannes Weiner wrote:
> On Wed, Mar 18, 2026 at 09:00:57PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Hi Joannes,
> >
> > This is at v3 and you've not cc'd the majority of THP people:
> >
> > MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> > M:	Andrew Morton <akpm@linux-foundation.org>
> > M:	David Hildenbrand <david@kernel.org>
> > M:	Lorenzo Stoakes <ljs@kernel.org>            <--- (!)
> > R:	Zi Yan <ziy@nvidia.com>
> > R:	Baolin Wang <baolin.wang@linux.alibaba.com> <---
> > R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> > R:	Nico Pache <npache@redhat.com>              <---
> > R:	Ryan Roberts <ryan.roberts@arm.com>         <---
> > R:	Dev Jain <dev.jain@arm.com>                 <---
> > R:	Barry Song <baohua@kernel.org>              <---
> > R:	Lance Yang <lance.yang@linux.dev>           <---
> >
> > I'd assume it was an oversight but you're an mm sub-maintainer yourself so
> > I'm a little surprised...
> >
> > Anyway could you please make sure to do that going forward?
> >
> > I'd like to rely on lei's file-tracking stuff to catch cases like this, but
> > I just haven't got new mail tracking working properly in that environment
> > and it's really too slow.
> >
> > It sucks to rely on people cc-ing but email development is what it is :)
> >
> > Thanks, Lorenzo
>
> I apologize, there was no ill intent here at all. get_maintainers.pl
> gave me 27 addresses for this series and I honestly thought that was
> too aggrandizing and self-important for what these patches are lol.

Thanks, yeah email for development is a complete pain to be honest!

I wouldn't say that the cc list in any way would be perceived as
self-aggrandizing, I mean some of the trivial stuff I've sent to larger cc
lists :P

But I get your point, it's a kind of impossible balancing act :)

>
> So what you're looking at is a (poor) attempt at trimming down the CC
> list based on who I had talked to about these patches at the THP
> meeting and who I remember had worked on shrinkers & cgroups.
>
> I can CC everybody going forward, not a problem. Personally I don't
> mind getting CCd generously, but my understanding is that some people
> do...

Yeah I have often sent series where the list felt... egregiously huge, but
I _generally_ treat it as - people are used to getting tonnes of mail - so
some more shouldn't hurt.

I mean in [0] for example I really cringed at sending a 23 patch series
that is super super mm-centric and really just updating how we manage VMA
flags (trying to get away from system word size flags) - to a trillion
people.

TL;DR - anyway, I think get_maintainer.pl --nogit (and trim anyone who
isn't listed as a maintainer or reviewer) is the right balance to take -
maintainers with screwed up email set ups (*cough* naming no names
beginning with L and ending with orenzo) and reviewers who have signed up
for lots of mail I think are totally fine to always send to.

And of course +cc anybody else you feel appropriate.

The 'git' maintainers entries can absolutely be dropped though, unless
you're explicitly say radically changing something somebody contributed and
it makes sense to include them though all that's subjective!

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/cover.1773846935.git.ljs@kernel.org/

