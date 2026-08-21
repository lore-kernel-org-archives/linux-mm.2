Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E19C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0349B6B0092; Fri, 21 Aug 2026 15:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27266B009B; Fri, 21 Aug 2026 15:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E6B6B009D; Fri, 21 Aug 2026 15:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B71086B0092
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:18:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47C67A025E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:18:47 +0000 (UTC)
X-FDA: 85126238694.02.74E9B7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9663C1A000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:18:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSP3N6On;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787339925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7EQwwPAnKK4q8enDsZaq/QP/VU09oRuTvIZgOemLOg=;
	b=BcBQWZKH9PZLC3pIXTa5oXdjZEj7oQiZ7Tly6i8EUXQdkW1qdUPM7cco+VgQCD2Zpj2yC9
	nCYil5s/0idupjr2UjHaS88GW8RwSEXMVX3JuyXwKw6EUmDqJngG9klp1YCacP1aYeoD6T
	HMGAqXtRnQQil3XxmX2XqnQilz+kTN8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSP3N6On;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787339925;
	b=iWPKU/nArBeltgjLRjRjBGBhAgpdbwvJJ2FpYKcFI5r2BpSBq1WhCJZAz4cXdNgnHOvC5o
	+ebNDUTrfVVFLaCOzkGvjprn6pfGhyvKAfNGYmKxrBeZ/QV8pcTtrQ9pTmzlRGBhb8lsVV
	KekTj2pPB1Ekt/7dbo7VPhon83jqRkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFD694004A;
	Fri, 21 Aug 2026 19:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C6B1F00A3A;
	Fri, 21 Aug 2026 19:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787339924;
	bh=A7EQwwPAnKK4q8enDsZaq/QP/VU09oRuTvIZgOemLOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OSP3N6OnFOMNhcH624P0dAupyoQ36T9SMi18isQoZ2T2H9c2kTKzVA5MZHwmFxfIj
	 oH1Uk59SThYcIqFox/PhnHA/aYvL+QTZmXia/ENAGLuO3d3zvrJEYO89xEKzOCGbjN
	 qvL0ChNSKVHltC4r6giprL7AMSDpJvJOW/R1C90ZOnKvN+ACvDkLhtmoWqirmqTT+w
	 KwpP0mkS0GlQpr9HodQgZwfAScXRWzxwhyY+wQH5y38FlMxUGRcqOCK0ok1vepNAaV
	 PkXbsBBTUffsvPe5548y9Lw4O2Q3vOReOsyWc5jaTgylhLSsC20JZdsOhcbsEa55Fk
	 5CofarYyRYTOw==
Date: Fri, 21 Aug 2026 20:18:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD
 split
Message-ID: <aoicRY6aG6I2ZAvg@gremlin>
References: <20260821150912.183976-1-gourry@gourry.net>
 <aoiWZjgcitp0nSk0@gremlin>
 <aoiap-yBdPaM_YQG@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoiap-yBdPaM_YQG@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9663C1A000A
X-Stat-Signature: 1cju46c84zkssiquo4jd4wfxqj5hadsr
X-Rspam-User: 
X-HE-Tag: 1787339925-38120
X-HE-Meta: U2FsdGVkX18r8UmUmbhWWnnSQtRU+p6kgM4b7NsBfZ8kS2TsWwh7OReY4/KZkmC/NPKmFt/0wEUA/iHyXRcf096AzWVRCUEjZTnkzW9Kylg+kuRk1eZnSwvJKkImoSVLqjg7GWxq/jW6sJ1tw7IYaSCwz9bphMzEUUge5/Dwj824Pj1MOdT7RL0cwgKGLeco9MXniOnsfqLupKV+YycbaMoaz2+7aMzRvvc6YTNEPgusUvfGNOpnZ8IF8ZPk/QCwAn6Bwuz8cn0OzFqL+kgTDi20jRby5fU7XLMrWY9jLXgxV1NncV/AAJXvlYtjpRe9peCnmD4rAoP+7JrFmQr6dprTWw8qrYrflbp2Xhx8YPnDsNQxMGzsZ+VIkLS9bh7BFwRQysW7I6PreUipTN5L6csViUMBq6SF9XeuRFhE6w/+MWfHhYX6Xbth0m8Y36cgxmlZqKdpBcFoTOLgvsJ/TDmdH3aKGzaKe3HVLxfB1UAUU76wwrkcZnA2M+wrcmHqxxCPSJfpzb7ZjWQj3AtJTz4By97/vcDGZI4KftTsfMgD+eijqrYKwQZdxVX2Kmf4iF2fJoNnK/+Ht01FMp5TQwtKel96Ly1QaGYh9oubSKQPx5KuVrIh0SyzuEA+lyMr7miWOnwuQ+ZoREtLCqU925QzIfZQoVd918RknhyOlFCAkTZeyGfMISTu3GM4jhNZB/vme8NuRur+0hn1+uzwEyBx4HlUEsN3lY3ZdJprCWt+naZzNKputCHR/Etdr3ji5sOeUljTO/d5zMspNEE3Ey+miLBA6nbcUMsWL02W2skz1DKPOyk37B0X7uptzKaWS86TKNwY5j9ANx+RzyjvCtAvwQvZ78JSvYrWIMMtGnorRtOYiy71jq2vYiv7/cuYNUX8ahgejGrIsCKWjw21xFC4EfZXI+16MsADWklz5dM+BQU0zezDaBBtJSJ/LSJAEMe6JRbBa7uzmvPUe1x
 xjjRAJ3Q
 L9vj9jSkwx7kZg3pGFXd5MVUEWibBtkookw+I9u8pCfe46SN4yWI2eT6RVx9uIMOr3aoBONL6hcNzRgvyMLeq9fS/eawv+qzNe1mWAYObhbXxtB8v0RahvTZ21yvuQJtzC5Akyf0DCdGWGKnufOBN90cM+xTGgK36Tvd3emU+9MhXLn0+bHEnx8xcOJHArlFgJMbrYC652iJ7iKI1ueoy2UczxLhEcRpxpnctd/ABEkW+mnuDjCXgHfZZLEGSi/06Cm+GsbnrMgJufEEtt52H/rPHUeX+QwDbD745lE3tXOu6WBmMVTKj2Oywa4tjjPQNQUHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:42:01PM -0400, Gregory Price wrote:
> On Fri, Aug 21, 2026 at 07:23:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Aug 21, 2026 at 11:09:12AM -0400, Gregory Price wrote:
> >
> > I am _so_ glad to see an actual reproducer used in a sashiko bug fix. THANKS. :)
> >
>
> fwiw i try to produce reproducers on all my sashiko submitted fixes,
> i've just been dumb about including them in the changelog.  Trying to
> fix that from now on.
>
> > > +			if (!folio_trylock(folio))
> > > +				goto huge_unlock;
> >
> > Doesn't this violate lock ordering?
> >
> > From rmap.c:
> >
> >        folio_lock
> > 	  ...
> >                  mm->page_table_lock or pte_lock
> >
> > So now you hold the ptl lock _before_ you obtain the folio lock?
> >
> > I'm not sure if it being a trylock gets us out of that particular situation? And
> > I'd be reticent for us to violate it... unless I'm missing something :)
> >
>
> This was the thing i was least sure about, but the deadlock condition
> should only happen if we tried to spin on the folio lock right?
>
> It does look weird, so it would be wrong of me to say i'm 100%
> confident this is the best change.

Hmm yeah. I worry about subtleties here.

I suppose you are avoiding what you'd obviously worry about with a PTL
lock/folio lock inversion causing a deadlock.

madvise_free_pte_range() seems to 'violate' this also with a trlock, seems
it's not an uncommon pattern.

I suppose the question is - what else is likely to lock this?

It does seem likely to be the race you flag in general.

So probably this is fine then.

And the window is relatively small also...

This kind of stuff gives me the heebie-jeebies :) I know that's not exactly
technical but there we go.

I guess there's just no other way of resolving this either.

That with the reproducer suggests this is fine then!

Since it scares me I think A-b rather than R-b ;)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> ~Gregory

--
Cheers, Lorenzo

