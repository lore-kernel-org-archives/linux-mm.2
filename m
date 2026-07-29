Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEF3C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EE86B0093; Wed, 29 Jul 2026 10:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447E36B0096; Wed, 29 Jul 2026 10:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3848F6B0099; Wed, 29 Jul 2026 10:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19DEF6B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:14:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EF89A1776
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:15:29 +0000 (UTC)
X-FDA: 85041104778.24.CD43280
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 749A9140005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:15:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfvD3uwx;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785312927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XIP2yu70drfefACMoCE5CbO7PlTPuDv9WLOEtpk9bY=;
	b=lG+1irlFnanBXO8ezJI4ClagcYba+NHHUNjrEMU1rP0AqNSFUjBK1cvBDUlzigd4Jt9S7P
	U9o5TsvSKkkKSpqqzQRxCQaXVdltt4pzN8LHo+x9mumqZcnfmG/a4UktNoHJVGqvazja9C
	8CIX3mD6nQdgt3bZ+zw5p2GKMzQmmSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785312927;
	b=EeBAnybcguy9kZZ/t5cY4AFuU7UCiZOy1spERNOkgGyMBwjMWuAT3qWOwVoOVnhwNkq64w
	nisc1j89Ur8OeDcl8IXrhjPx34NgsIsL8bfwkqeUsJd88PXOL6sa4bq8iBzJlqNiv19vlp
	2ZFCw5yAvb3w8HFX8ht1YCx+1kOu/so=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfvD3uwx;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03CA660A65;
	Wed, 29 Jul 2026 08:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715E31F000E9;
	Wed, 29 Jul 2026 08:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785312926;
	bh=3XIP2yu70drfefACMoCE5CbO7PlTPuDv9WLOEtpk9bY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SfvD3uwxSqDewmJgHYlh9uh4Q6cetVYI0ulIbG+Bh81LWKPxJdqA1cDVhiuzPZRQk
	 aCMUvsGtw3wg8cAIcYTcOU4oUrLFRlSlBNgzoMOzqN6hDYxLB6JQoanDJySNc/8XMb
	 k0m3USzDhQIh0vG9W3asTyq0UKrH5J6kja3dMZguzhhmc1rrkDunNEj0ZfPA5itbjs
	 NtUHqFacqVkWRR1EayQqwHboYx2ERqLzRa1MOHkjMZZqLg+dL0h5Utr5/KpW6OGck7
	 tBzH6Y6ZclXubhFHI298wrrn7o0ea+aChF1dONHJiMyrI0pb5ju/hO+3MDSdDChE3r
	 tZiXm7dc5Ixcw==
Date: Wed, 29 Jul 2026 09:15:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 0/2] mm/huge_memory: fix huge_zero_pfn race
Message-ID: <amm2GOFablLbBC4H@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <f0e39f91-8dd1-4d9d-8d4e-da5d608a7148@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e39f91-8dd1-4d9d-8d4e-da5d608a7148@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 749A9140005
X-Stat-Signature: nssxwumxarq6rcksnbwdsqz5sidyrdyt
X-HE-Tag: 1785312927-308164
X-HE-Meta: U2FsdGVkX18ZZIPCoUp2oA+3mNNe4N1NccsRsXv8L3Le9XUMuwXFPa/NERttyTdc8bUnq4jvvO6DAqIuyGycssfBda5+qAeXHvxrLzSQJ93wsTAg1mH4e5Rcd+etDg8UAPwLcv1Y/yfbf3EW7RiYhKVR7BgbwAt6BYTYECh9x+lLu/dFxvd0SwKiOTPqv6AaakZULygmybWjQuuAcdVZdEf6MoAps/5YjMOdr8sKFN0eYdMPtv6MPvBQtdDzINKfr/mvPDoPXYwBgqD84Jl+faWgW9fwX66ixuV3cxM0OSkn16+xpLHLAzzQxV+NbtY97DJNcRn/bNbabaHpek1Fj9OF3HQqk0gvV97mIp/pCNvPJTRC251PB87ucvjvUk9Xx2QpYsfCO76H5lqekiWdIwGhHb6j2K06X0GTPizWJyDYaY1AK9EhEcIzCqzTVep6m/Mga1FXtKol5g/VdbqF1SVs97qpPA980UJkC1Uqpb2UINhwyR47CYwM+bZU19fEftZPqktfm6IyHj4KmK73lKkJyAZ9Yqp0X0QsszzN09M4WDbQ+JECePiXc26KCwkb8o20x4xwoWru54FADPXzUgF0YwaSYVR/VRYnDPlNXQeqx2BZGfajSR3REPsLcBfAUng61rhFDRlI0ZpbhCWbr90/+PfbIu/MAyqB8bwV0UWSjnuhd9FxQjnFq4IAmKHTnU8egrneLE4RzrCmpy8elaEW+mEnExDPq7c5qcivJ8eBBVnsN/DlKxeXPxzSKqkaYnL9U5QToHMfRibN3+LWe2seTXO1o94HaElmYi18pPfC5j4y8nKp6bTZ8//wIfTawvi7Mk88tf+TgP03V3b11yAZH0dGnrQM2oGNTQTnpmlWpz+tqsUgWmliCn+n5/O7SYqasVRgnXQwoD47in1cVh6/sh01atx+Kov+sL2Wov3N+z+94QqIMJZtyzYlvpL3tHdwGQhdaBn6Y5OpD3S
 SKWpBcyN
 1SayyULtiwjWSiNJQGoqGTAZMpQWhOo9ygKK9F4M0M0GIknkKghuw/gT5lDrbCZGhhyhcV1vgLE2FVnAu7obcrnGi4VTBM2ri+D5X7aDrxDEXZ9oPYm1L6wlSVDk3OrGxtz/96JN8h1UKm/aFbwvrvX7QVrWJEGdJWwPxLxO+sp55PTPBqap8g0MXoPsAkE+exx3H6yz12IwI/dVXBMGeI1BKiCE+FJy7wfynLX/dMVFlOl8GNx57MzGP1SPWzybAz37R3C1gjI0s5o5l/M30ccQJKzqy3aB5oE4nZg8ONKnuQw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:02:57PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 14:05, Lorenzo Stoakes (ARM) wrote:
> > There is a subtle race in the reference-counted huge_zero_folio
> > implementation.
> >
> > The fast path atomic logic fails to account for the fact that the
> > shrinker (which drops the final huge_zero_refcount pin) can overwrite
> > huge_zero_pfn with the ~0UL sentinel value in shrink_huge_zero_folio_scan()
> > after a racing get_huge_zero_folio() installed a valid value there.
> >
> > This results in huge_zero_folio being correctly set but huge_zero_pfn being
> > set incorrectly and thus is_huge_zero_pfn() and consequently
> > is_huge_zero_pmd() will misidentify the huge zero folio as being an
> > ordinary THP folio.
> >
> > This can result in the huge zero folio being split and otherwise treated
> > incorrectly.
> >
> > The solution to this is very subtle as there is an atomic fast path, and
> > thus ordering in weakly ordered architectures has to be treated very
> > carefully.
> >
> > As a result, this series first reworks the
> > CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic so it is separated from the
> > refcounted code in order to make the subsequent fix reasonably
> > understandable.
>
> For at least somewhat easier backports, can we reverse the order?

Since I'm going to be doing the backports can we keep it the same? :)

>
> The spinlock+proper ordering should be possible without #1, or am I missing
> something important?

It's possible but this way it's a lot easier to deal with and I'd rather keep
things consistent for stable kernels.

I can figure things out for < persistent huge stable kernels. It'll be manual
work either way.

(It'd be good to get some review on the actual changes also :)

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

