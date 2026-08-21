Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F48C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56DB6B0095; Fri, 21 Aug 2026 06:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07CA6B009B; Fri, 21 Aug 2026 06:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DD76B009D; Fri, 21 Aug 2026 06:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 754F36B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:44:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 791DBC03EB
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:44:41 +0000 (UTC)
X-FDA: 85124943162.29.C9FDCD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9EA4180009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:44:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fZcYv/iN";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787309079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEV1uuB0ujnXPKaY+Wk+sXi2Lz9xQB5FZ/QqRMb9zEE=;
	b=1/kD9hL8rHX2QS2N9962hb61vZxr2dxHWdcB8TCK2P0tatkAAMLplsmWc4ckO7Nn3p8e4K
	s44/QvfMAadbC7SdYyMOg14v2dkNM8ex14A1T4Bfvw7W9y3PJSBTN1t2cdUB+Bat2OzX52
	OXMp/Phk3cxehXr/4kT3CJk1iN80BJw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fZcYv/iN";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787309079;
	b=CToAP4sNm5U9hnYKWz2+ujl0US1NZfbnO6ywamG6QkSsvei6QLkxVaTCKOJxBZq+REm7X+
	lp8b/1f4J3Ni7QaGCtfNMl6IbuRG8bPNzj4l5sRiHejUQ6IPbruNvXWWrBNLfziFijyu01
	caT971m80k8FrwDEylz28V4AtE1aJf4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA50841659;
	Fri, 21 Aug 2026 10:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC2E1F000E9;
	Fri, 21 Aug 2026 10:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787309078;
	bh=OEV1uuB0ujnXPKaY+Wk+sXi2Lz9xQB5FZ/QqRMb9zEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fZcYv/iNpqmmH+eXzN1nlKAbp1671QSKAZLHzfydCp+CXLyRzutsB18WhFHNCJKXq
	 0w2cjHsawvgyRkYVvb+l3Nr7gofGMxxh8a4PAa0AtIucWl4l+mGuMsFuiML8kiu2i1
	 6SxcUq9zyGgn5sUOf28BjtENDZVSngJRHwHIYmA0e0KRndnvXUXCPFskUoYc1nvPqO
	 A1PdLfBTAnyQgRKrnl04YMB0b2ELcWkk7Rca7CAmOJze/P3hN1iGdertvDAlQT4Zj9
	 Xb30GgCCk0QAzjqAJdrlfVLcZUE8U8qSeusK5dpdk/paoZI+YDjx/qThpyLnQBrjYF
	 BW+ntHcWp9V7g==
Date: Fri, 21 Aug 2026 11:44:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] selftests: mm: introduce page allocation stall
 reproducer
Message-ID: <aogrd9knfBUGH885@gremlin>
References: <20260819070538.2404983-1-jasonmiu@google.com>
 <20260820170348.48f04ed654dce5193ca3a532@linux-foundation.org>
 <59525a3e-6003-4ab1-bd75-e0c7dcc8a257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59525a3e-6003-4ab1-bd75-e0c7dcc8a257@kernel.org>
X-Stat-Signature: mabaemqbxhmrr5spyzcccp68nzkcpk4o
X-Rspamd-Queue-Id: C9EA4180009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787309079-14612
X-HE-Meta: U2FsdGVkX1/oEaek9DiiSYvSgVZdB4vtoPi8oBVRN6ZaEIGxXueFj4db4XfnMkigVDzrsknqIreFdn1aqaOHYlkjouVnmfU9wP/rrq7c1us4EvN5t99WzXOeQhQJUe8KjveG7UhSeV3QMpjognQCFQgtk0y03SaM9m9Q3Ylk108K4IjGlhLIK34LrKrciMZD/AqZh9TPvUOgkP9aUu3FHHTB4MBJCg7MkatXnDDwbsD8BwInd+V9jl7CX6xCvH4W72nxZ9UX/vOdvp/EV/nOCzBcPdMuvuEGbOkI4js0TFAemnqVPYAlO/rUNp55lozVsRfMPfieHHtfudWSKk0EnhcskcI20IFcmygWx5TEpHevyVoKvVaT4kCNVC7vqnH84yVMbj6MJyo4wKX62n/faFmrdAs7xTjL41ftXHsIaxRRDZuV0E6cGB+mfSEdGLjr2BMY6z91mbmL0bFD8B3cba2X/h7UE0GqRadaLnmOWKn19HsI66Ux+Z0ONcDkE6wOLyBgFx7Jbm76VeLZLM/gPcEZmnONbS2fRbrBem5eyY4plLhnZ+bIjLe2/hZ9zS2Cq6t/yRFQ3gTK29NAzDk1yLUkrPgZCt/oPNTICjUtBnv90gB2sJuMgoRwsehIFC/DAqxXMRcwe6JTkp6vpOZ9P3hcQt16W5IC65XjVOywerB594UivE4JqRTozYgukR6nKRguB07e8RMuNU02llkXYWLl4DhO8sxqwWZYoWLv3gdpeaRck2etWdXdU0Os3vhOvxqvY63qwxQ+c0cNEzP6L5bct8oXVN/mbwmaYSX8Uy/oZiYLY5tjV1OrL7359FEpN59trYmPYXebDKQlyGYwvXW9zj1mg/DBviaw4guTEQUWI0GAwi/awjyHayEXt35QdoE2ErSy4EA+Loz8cv76FzFADInedssF15IQojQVXVFgdQs8byg4qV21TJI7QmaDpAW4VBECZ+egRJvBsr0
 4lF5zvti
 zLBqbbpkUL2mYxkqkVaJtb60KQ8GWpLs97uXDKYiS2dJxtfbTKbXjVVlpjK4txtk5k+Z7Bjg6ZDj2/szMvr1rTwqec+vXBinS40VlVQHBRAUanH6OFXFMUK5N+xAGv9xNb+eEcyuCFVsiLCnVTpJRfn7toIzDxi4t6fQhE/Nj6WutQ3Rfg7gx6Hm7xHKupahDHEzPTBi6qLeIZdgsQ/GOQcLp96wooWWZMidbZhswyfZ8UHt8+on42AQZDlkrKUYd62G+U2AxV3tN5SHQvOCKFEL22EE9NdDpBEF6GZefkEtNeE/2zDHp3fjl1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 11:53:57AM +0200, David Hildenbrand (Arm) wrote:
> On 8/21/26 02:03, Andrew Morton wrote:
> > On Wed, 19 Aug 2026 00:05:35 -0700 Jason Miu <jasonmiu@google.com> wrote:
> >
> >> Background
> >> ==========
> >> Under severe system memory pressure, system unresponsiveness often
> >> occurs due to page allocation stalls. In commit 94e0bcde055e ("mm,
> >> page_alloc: reintroduce page allocation stall warning"), David Rientjes
> >> introduced a warning mechanism to emit a kernel log when a page
> >> allocation takes longer than 10 seconds. This log is used to correlate
> >> a frozen system with the system memory state at the time of failure.
> >>
> >> To further debug and analyze these allocation stalls, we need a
> >> reproducible test case. This patch series introduces a new selftest
> >> designed to artificially mimic the severe memory pressure scenarios
> >> seen in production, allowing us to observe the resulting allocation
> >> stalls.
> >
> > Interesting.
> >
> >>  lib/Kconfig.debug                             |  11 +
> >>  lib/Makefile                                  |   1 +
> >>  lib/test_mempress_timer.c                     | 140 +++++++++++
> >>  .../testing/selftests/mm/page_alloc_stall.sh  |  80 ++++++
> >>  .../selftests/mm/page_alloc_stall_pressure.py | 235 ++++++++++++++++++
> >>  5 files changed, 467 insertions(+)
> >>  create mode 100644 lib/test_mempress_timer.c
> >>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall.sh
> >>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall_pressure.py
> >
> > Nothing fits very well, does it?
> >
>
> Why are we mixing python and sh?

Oh HELL no.

Only C in the selftests please.

And python is replete with 'getting it to run locally' issues. I have venv
PTSD...

>
> >
> >
> > selftests is for quick tests which are run by run_kselftest.sh.  You
> > had to place it in selftests because there isn't anywhere obvious for
> > it to live.
> >
> > So I suggest a brand new tools/testing/stresstests/mm.  If we create
> > this, people will jump on it and start adding things which presently
> > reside in their personal collections.
>
> There was recently a discussion around performance tests, and one thought was to
> not carry these in the kernel tree at all.
>
> Stresstests, not sure.
>
> So agreed, that this shouldn't be an ordinary selftests (nothing we would want
> to run autoamtically), but I am also not 100% sure about having performance /
> stress tests in the kernel tree. It's all stuff we have to maintain and drag along.

Agreed. Separate please.

Stress tests are just asking for flakes :) they are useful + important but
something different.

>
> >
> >
> >
> > I can't say I like "mempress".  Is "memory_pressure" too wordy?
> >
> >
> >
> > All of lib/test*.c shouldn't be in lib/.  lib/ is for library code!
> > Again, we put them there because people are shy about doing mkdir.
>
> There were recent discussions where I raised the same. I would prefer if testing
> kernel modules are somewhere in tools/testing/ if possible.

Yes.

>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

