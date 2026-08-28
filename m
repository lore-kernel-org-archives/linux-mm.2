Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359B7C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048086B008A; Fri, 28 Aug 2026 03:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A5D6B008C; Fri, 28 Aug 2026 03:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50456B0092; Fri, 28 Aug 2026 03:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C45F36B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:06:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE25E1C1B56
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:06:31 +0000 (UTC)
X-FDA: 85149794982.26.46CA6FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 274DE140007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:06:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T8KDsOFl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787900790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My7joSDz2Ka+qwaJkxbQwVtYYsCHnHrEPDsE1x4YmfU=;
	b=Qrdnd1rYU95UhqVmudhG6sFfXvC3BTsP21JuFr5qWVpMUxQGMK60usFBmE8LPvFdaZJywA
	FGblc/ZOcntlPiMWbW7C+idg0xztA8kyoGHz2aq83d090eqdwUCweR4CzZ2TMtorjk1BMO
	YYt/awRb+0hBOXRg1lrcUnR0m0EISLY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T8KDsOFl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787900790;
	b=luy3OgCou4x6Ulrqg3XBFwGwfHCppvSV7G4crWeIx7jXCal/rGrhXUwfVwBjodn2Yx0osL
	K2cSPoAGn/xbbpIqQUWCAdj4YO6cu+kxTduaZQA0Y1Jcc3q6m3/s1+0zCohEU1YA+lXk3o
	mQsoJao0yDnlTvQ8QCqShNVmkr6ecl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 021BD41344;
	Fri, 28 Aug 2026 07:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF41F000E9;
	Fri, 28 Aug 2026 07:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787900788;
	bh=My7joSDz2Ka+qwaJkxbQwVtYYsCHnHrEPDsE1x4YmfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T8KDsOFlA+dTcPNq7bkKzLFIYt/lQkONpAHMQJNLpFoByDRuPH1wgWULvCijkonM9
	 4JyhIqOI+YtF0gdXLsv+ez/CxeF/U16VVbZ/eDp74ZxLwHfFVeSZqoMRHLnl/ckFJv
	 M2DyItv9e3C2GdhzSTPGl4crHVtUR7t6A0LOkL6dmA/sqPHJT55DPP7wyWTlot8cPZ
	 a5CuPFR5HjNeF5kktKiEn7gM2ugr6P2JgWW/OqETnDpb8QloTcEMFzGWDwNlxcNJvh
	 GR7xc1nMA9r0u9y3eIum9upZjkCrHyoQcCUkTKT0BbwYzkUaPpv98w6RHqxLyIbObT
	 ck0mGEaFIO9mQ==
Date: Fri, 28 Aug 2026 08:06:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apEzYdLWx0508hBH@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
 <4836208f-a84a-42ca-aa74-bede23d7de41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4836208f-a84a-42ca-aa74-bede23d7de41@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 274DE140007
X-Stat-Signature: sw45pnaoe1xhx3bke9gee7metztud4sx
X-Rspam-User: 
X-HE-Tag: 1787900789-462813
X-HE-Meta: U2FsdGVkX195vUD30wHPeTdisVKsBiX7+AfY8fvw8JCijoFrz1v2IQ3xNdLFLq6xuksBsTIctOS4SZRp2unsHWVjifV8Ak4uNZ4xmsdJGtc+S9qCS+35u/phsmgDmxEknh7XObHz0NizJgLtvZo886U50u5f4UoiJ70Y0w4uy4mwrscLguEUZjMRjjq8sAMfWcb9vNSJJ9ldRNfQVcloYHiA9Szoef2y83BOdt5Y9OaCkzEUeuzlIMcWW3fyzs2n+S5pRyODT3wyPJMcJWsGfBEQZIb6vL/M9NduU1T61O6Oguy0c+n4NwfQUXvPiZZ26iybCs7dRI+kK+q/eBIGU7hZEjlgzbVVVl7MNKw5SzHPbk0y1NxhU7ud6HUtUP//uhnaM18VLtVTLh5b3S3dzL0NG0u0Gh4fhxk9q2mSt3E9541y2pi/32kKta8KL/I6suAgGfnwY854ZyfwepRL8mpZYrfQIkgJEjBJi+sP7QnMfd70ukv8b4WBgkrGAqx6AEDn4MOj8fYGSYHfhsdo8t/JRh9MfTcQSshicWGXN1vD7n+tARDQsBv85rW/SA9xditJNmtDSv4PfNs6zBYlPvR8lIkVUW2urpq6BaqI4ybi7AB+t/4HIpxvvUQhlrv/Uqu/ETHqTFDVroHa72Alf7oWY9S8ZfbjCCWCRjy7tFbWgm2K28BTVmwUGAhDEk+2jTWYl4bPf17i4G+wKO8Ac1B/F97Ne3GOoLnriopK+FTCCqMiACTzzrk7KZkvzHzSMrzDOJEgUW33GvHj4OfsLXw0Jq5shtsLGwHcjhQFu6jNMw7EzMmSOU5nUDvghGukfB75S5mRo9vIr3LCe/y13JN6egYKD5i+SDur4acn+WjoxN+aRYwYGcxSIWqYocltsUxA/ksvbhspZvBblfOWZUir66e0RobJQKV76IYBKbybe7KIT2XlLodiI4jM3lNZOVFLgjQdpIgtyIAfwJo
 AfA2Wqsv
 7JyNmFO2ekIpH1GfZmIcvKUvGGf9dcZkydqXUUN7WdWVvI+KXZ3atv07/x7QBRU/qWdpC5sdzQNY0yqvKk/5oQaKiIUvPBoEZwKbSVY2h02RCIlyDzTPpXH6ioggrAtxJwDausz5eN4cU4U5sPGob3CIRRn2JlHYSQ+l9THlWZgypmHPvUSygexMQ0UGKN1FH1ecBftPHXGqXuE3omBrRgzSSLQbJeU9U/yXP2pLslw0SihClVNsLNKnkgUL+61E3DxW5A1yNCGPdSvHjB2fu3zLFBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 02:34:31PM +0800, Vernon Yang wrote:
> On Wed, Aug 26, 2026 at 12:31:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> >
> > 	~107,000 words of review across 948 emails (in 279 distinct
> > 	threads), counting only prose you actually wrote — quoted text,
> > 	signatures and attribution lines stripped. That's a full novel's
> > 	worth of review commentary.
> >
> > 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> > 	and your longest single review was 2,404 words (mTHP collapse
> > 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> > 	of your top-10 longest reviews).
> >
> > 	Estimated review time: roughly 300–500 hours, centred around ~400
> > 	(i.e. ~7 hours/week for 14 months).
> >
> > 	1,615 THP-related emails in the window: 948 reviews of others'
> > 	work, 278 replies on your own THP-touching series threads (~31k
> > 	more words responding to review), 382 patch emails, and a handful
> > 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> > 	emails), June 2026 (113), August 2026 (111); quietest was December
> > 	2025 (5).
> >
> > Think I can be happy with that!
>
> Thank you very much for your hard work. Over the past two years, THP has
> been extremely busy, especially with the addition of mTHP-related
> features, which required a great deal of time and effort from the
> maintainer. In my main role at my company, I am also responsible for THP
> and memory reclaim functionality, so I fully understand how demanding
> your work has been. Once again, thank you for all your hard work.

Thanks very much :)

--
Cheers, Lorenzo

