Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E27ED35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C5E6B0089; Wed,  1 Apr 2026 07:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6636B008A; Wed,  1 Apr 2026 07:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE056B0092; Wed,  1 Apr 2026 07:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8674B6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:19:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2268E160847
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:19:19 +0000 (UTC)
X-FDA: 84609740838.18.C0FA47E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79DF91C000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:19:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3T1INlz;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775042357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4rIOdL4hDW/Y6phoK2Qqh4ggQ5XNBvZZDrtqgZzdUU=;
	b=PPygbsm/61rdQZK9aqmdWqsnL2ZWLR+Zc62YACgzDoVTBPEIBRIfOwXeozAmdzLb7IhYXh
	RKf5BAV6KLIj8iAQwYVB20OKIEiv+jAlIKr4hkaUDGCs2a93SMk8RT/KQ/x6M+bmD880/h
	wCW/zQMujV9GPiapF6Dt0NKGNJTT8mU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775042357; a=rsa-sha256;
	cv=none;
	b=j5KrpYS+UFixjrIELRF+1lesxH2DNM92ZJYMgHG59Yj3XDjxNvXsQFKXht7GCYBX4g1sh+
	Vn+fiMZ+sNU4dbLShZoy9JtXaosSCBUZyqeOkuwQB+NSsKoIynaY2RCi+kFURIb782TuMD
	8PMYvUAHjIWL9IBQfVMurZLay5+eM78=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3T1INlz;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDBE860131;
	Wed,  1 Apr 2026 11:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C6BC4CEF7;
	Wed,  1 Apr 2026 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775042356;
	bh=xpFWMh9MkdSBc1hJn+/AhQ/w65T3zgOUU+VStizxE4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3T1INlz224JnvHd+iI/XTnAO57Xnl3aK9ePNoq/6qIJSX5mgLV+QHeUTpHeQXZhS
	 AOKIshDblweICaHv7+3y7gpoNJnSgXUUyvsP0J3BJQ5MHIAZnntCiKjPetRiIIu2s0
	 kP+fEhUtZMfMWv0qy/qUs5yjQkZpOKcP49EYUHiAq2HFx3AYfQgNDwa7Gdhg9HJMIj
	 BHE4QbHE805rQ7ISCK28qG/Dn83fdR3bU8IHdZVCrNdXtAKqLu+kNIaX3LifW6wK0n
	 /HZOJGHGkpF7y8srBH7x6egrSN350zRfrcNr8Kj9Nkb3EMxdkzFtsJ8eibqndNsMwA
	 FkLH/NxvGiYew==
Date: Wed, 1 Apr 2026 12:19:09 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-ID: <a2b60504-5971-4cff-bb0d-2005e2a216f6@lucifer.local>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
 <d5cdcb88-c7ca-4a29-9b8e-3abb7c37726c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5cdcb88-c7ca-4a29-9b8e-3abb7c37726c@kernel.org>
X-Rspamd-Queue-Id: 79DF91C000F
X-Stat-Signature: qunt535sps83am5foinegh7m8t94uzjp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775042357-817425
X-HE-Meta: U2FsdGVkX19C9g91tCvAypjmc9X+c4XRiR9TeZc5X2GWwcUXHGgsv8P3Wg/ny+kc1CnQ8E/5mGF+dCNPXPKKJqQGYJ+Fud5A3AdeSPPe9pfzE6kDRbAMQlwiYwyFmT9EjM8k3jGyszugl9zWLcmh/sG29347yHmHZ9GANIsBRRlj2X0x5jAwaObp4LPC4QgYZFKpI616qfe4sb/T2ArPZdNQlStQRxQwy7fnnOzqE8AmyONUiO9SdZr2VWJcNcq+V9hYyZCWUOhyMXQr/UVP3UpB/C5naRXL3VyX8KI2M3dDkSZ6FYpsB1D9opqc+vbiodsuni1YgkSX75qBuA26KA/8lEqmyWMH7+FaE0N6hvfbjqeP0dQuqrPA70dpxWLXw2JDBlQ/9wJM8jSpd7OgOhBc70DnTinjYvM9TsBBUENA15V1y5SxO/J4zVTRVwg/4x4qusARCn7PzEMFTJeGWZkG9oBqVF+RMDbNTkSN/Kg/8VtHGsf7/rMho4snC9qytB7sBNgLdIPCiOEWqJy77RqY7Q53pCYfWj6sYssNqrVr6ghJgm8aNaqyGDG+lEiwoz9mqLpXvd1YPfZVCUEroTHOWkHacpvaP7b7UkEPmiSOYue6ucSJQcOX33h46XRdRMjqGnqm6c5xR+BE4SKEHmx3E4Gr4MfvXEQ7mN1kh5zcfzVWXD4gHFcki3uK0DHgguRyDahQxxzPSkiPvZdRRSZYvxoGDARqf4sKFyYJ8HMUIffqRYi8iqvXyMcuE/ImFBRnjhKRC5kUtOeGDowiua2kupa6AqxuN2FYJC/CrjaT5vGUUUdDNRW7OF8Vf04ZtcZF7yiR/fRUy3pRxMVfpI3G0LaSbd7uwUFX3H7O/EqXshp8dnRrqGzdSPm7lrNdL+KO4AVOR9akO0TF6Y+GdGiL59FwRf9SMwazFrem2MbT2TSYQA9vbZM9WZZ3fWP9pEpyDvKlNPXfvLAsOtR
 J9UJzmG2
 HoOdsMmWp4YW38T0C6gdoZVajt0A60I5dyLqC8zc+GdB0jFM3hKAGVGE70HasOyqmKZ4RQiMI1BRh4zS2wHU7F2hObeE7Mmt2u47Fu4RbCdaCVQL/5QabJp3VvgNaxUs1eUhsEoXfqDv565+f4q3PiWviCzhGgqNpbI38hWaYGdKoVxlwmmyeT9FcljxYbo5Lrt0dJI2bfD+1AGPuLESKbRnHnJpssD/m6U36a8KJeEf6pjEBwWtJqjKH+VrWqR2qHXgOT4udi5g/u72yavukyiBT2Oxnm06SMr5Q8bNOTZ+yaLmkXShDdsjGEniW+IZVTkLhWrOdTvqrO5Y7A+5Sjo886mZRBTBxAwiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:05:34PM +0200, David Hildenbrand (Arm) wrote:
> On 4/1/26 12:59, Vlastimil Babka (SUSE) wrote:
> > The boot-time enabled per-cache debugging has served us well in the
> > past, but it's time for it to go, for the following reasons.
> >
> > - It's a debugging feature. However, thanks to the advent of LLM-based
> >   reviews, we are not adding bugs to the kernel anymore, so it's
> >   unnecessary now.
>
> Right, and probably LLM review would find many of bugs in the existing
> SLUB_DEBUG code.
>
> >
> > - KASAN is more powerful anyway for the classes of bugs that SLUB_DEBUG
> >   can catch. But I suspect KASAN is likely to be removed soon too, see
> >   above.
>
> Of course.
>
> >
> > - SLAB never had no such dynamic debugging functionality. With the
> >   introduction of sheaves percpu caching, we have turned SLUB back into
> >   SLAB partially, so this just follows that direction.
> >
> > - It's removing ~2500 lines of code and I want to keep my overal
> >   diffstats negative. This adds a nice margin.
>
> Personal stats clearly matter more than anything else.
>
> >
> > Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> > a big loss, see the first point above.
> >
> > Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> >  lib/Kconfig.debug      |   12 -
> >  lib/Kconfig.kasan      |    2 -
> >  lib/tests/Makefile     |    1 -
> >  lib/tests/slub_kunit.c |  329 --------
> >  mm/Kconfig.debug       |   60 --
> >  mm/dmapool.c           |    4 -
> >  mm/memcontrol-v1.c     |   17 -
> >  mm/mempool.c           |  105 ---
> >  mm/slab.h              |   34 -
> >  mm/slub.c              | 2074 +-----------------------------------------------
>
> slab.h vs. slub.c is annoying.
>
> Can you just rename that to sheaf.c / sheaf.h now while at it?

I'd prefer sheav.es.c, but naturally all comments in that file would need to be
translated to Spanish.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

