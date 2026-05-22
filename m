Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C37CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F676B00BE; Fri, 22 May 2026 11:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427436B00BF; Fri, 22 May 2026 11:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365046B00C3; Fri, 22 May 2026 11:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280366B00BE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:56:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF1E114094B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:56:10 +0000 (UTC)
X-FDA: 84795507300.26.A389A58
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id DEC75140013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:56:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DLLwgfn3;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPSb2CFFD2Mx/U8TkBhKdYznfpouLwmrB1wpwkrvRlU=;
	b=QnuV/RfCw7JKBFEVuucGFViEDKzFZy9ISL9sS4m/iaZoYz/wlvSKrJOYrmPiDh+rYcwsnB
	csjmGhsgkkq/uffW5lRrJ21bTW/zFxR/sRG5UzUoRd1XlEoKcJ4/3IKtZcGWvvSozyU8FS
	uclye38r3BjqNcC8lOJvJeyVI61y7AY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DLLwgfn3;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465369; a=rsa-sha256;
	cv=none;
	b=Ju/ArjpAyAgrwTqk0pYpj61CmycGlL3mFcYl3LVUYQd50OBgERysIDbBwwQOIo6w1wnO07
	0/epV2q4lYqtRQy4/R1RuZDUjbo75ksP+sF08g+qHCcCMOWKQ7TMEydE53IoolELYtpSSy
	iO6jhf7xKxX87a25WJAlV/u6XwjnRYk=
Date: Fri, 22 May 2026 08:55:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779465367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPSb2CFFD2Mx/U8TkBhKdYznfpouLwmrB1wpwkrvRlU=;
	b=DLLwgfn3zamt0KOTjOJsQrjCumqI5g0pw3M+sc1H23Reczm/g6BnVx6n82nqbHGNdQcw+9
	mQ6g1ovyGU9uguzlNk8c6ewC0+hWaPbb+fqRFQui1CP4pwOxfebWERMoBeUAyKOkipNQkc
	RdOJlqwu/CiIyhBmejVUjbyGNOi6Yb4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
Message-ID: <ahB8OhgdPgOkzuS9@linux.dev>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
 <ahB7pCu_G4vuswc0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahB7pCu_G4vuswc0@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEC75140013
X-Stat-Signature: qer85ekb7z65i4b5gq6odm5wyfgarycy
X-HE-Tag: 1779465368-270028
X-HE-Meta: U2FsdGVkX18eicDFtg7bKrpGuh+9412blh80xgY4MCZynZXCTmy4pzf3JrZD2H2wEcfHTxEGL5WohZI56hjjywtSqV/70Xm4BANGkFzqHd8uw7fWfApCd6/OHkK0Yqwq7l90g6PMaa4LYs7vePLpRtkmdXrT58DeNfsKwGsAsQtTgg4Cq4LS0vv8/eS0ZOlgfrHJwuHqfPQmGvY9uDp32X6SHE+DrVrCwGqtcDE7J5/qHMCghh1KVBNODM5LHOdn/73CTSJmNvd7psQOxZ0gvR05exSkWI4w0MW+UkJLqak3iC1ffu+aZrx3IV76cshlMcaNW9YQ/tr1aygRB81x6L9qVexrK5TKQykXd/0O3rwv156JnI4L9SkClCtLSJcBwS4uZrwVBebOBG5Nn3plsaxw537TRwUdH7LowINpVLeKe1yDqJ1YOc5m3c8iFWU0OpUscDPreNQzDw/oUE7FVkfXfYiMBEUbEiSsjP/BG2vGI9QkGATwD8G0Bnqn7IW12ZnG1i2K3IRUjX71wWUJAKT/wQJdCXWHwIIOZJF2LqJtkOGXRhlwI9jWehZAYl2uyPeCwC1buBhaBusa+CV7+3TjlfkPLXjkarQt4d55dgHFlWEs+LCc8Xs6050+cF9B6+siSuGGLAYlK0Ahk3mwXtWWkOuBDVnsp27Gf6T3ReM9g7dwtlCTRHkHyE7yZOGBIccYL6PIwIQuT7a/RktHF/u5xu1GoLM9U1TqXU1fqUVt94IBJsdaG7+w3DfZYxcj/c2RVrjZADTrIXMdIPsb9cAy3u5hMBhliWL4EiPsqKvdZJZDvdJt4diLpFkoeq6N+2j15GH8t6tg8FT/gJnckET2RRvxUULr/rDQ1RgxoCno84GJ6s5FO7BDsNY53LLauqo6EaVgFC5puI1rY0jH3PYhOGnsrJD9Y8yeoTqVC+Pi9hBvxvUGxoNEf8p+H5piaWb1yPN3r0AiU4Fgdpf
 cfzAp4m6
 f+bC2Mtl8AzpFWPYxVVCKUI8Q70q1b5hxbrszeNMF8wCL6RmT3RotbkOoWzQgeBqhqSyYuo+eB08JpCCcXR8ont/bNDJuU9CNSz0YZ2DaK8Dz8WJU/owpoAurnePwMJZZYMaeHqoHK3cJig6TPt08T6iArvE1JQsqEuDnHLcz5DURodiSviktwq8N+mJdW4nHy6fhe4mgkXob1U2R0mQ2hxbP+pkG/PbCdP5WqdgKbicgyLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:53:10AM -0700, Shakeel Butt wrote:
> On Tue, May 19, 2026 at 11:59:01AM -0400, Eric Chanudet wrote:
> > Add mem_cgroup_dmem_charge() and mem_cgroup_dmem_uncharge() to allow
> > dmem pool allocations to optionally be double-charged against the memory
> > controller. Take the struct cgroup from the dmem pool's css as there is
> > no convenient object exported to represent these allocations. These will
> > resolve the effective memory css from that cgroup and perform the
> > charge.
> > 
> > Introduce a MEMCG_DMEM stat counter to memory.stat to make the cgroup's
> > dmem charge visible.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> >  include/linux/memcontrol.h | 16 ++++++++++++
> >  mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index dc3fa687759b45748b2acee6d7f43da325eb50c1..8e1d49b87fb64e6114f3eb920293e14920290fe7 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -39,6 +39,7 @@ enum memcg_stat_item {
> >  	MEMCG_ZSWAP_B,
> >  	MEMCG_ZSWAPPED,
> >  	MEMCG_ZSWAP_INCOMP,
> > +	MEMCG_DMEM,
> >  	MEMCG_NR_STAT,
> >  };
> >  
> > @@ -1872,6 +1873,21 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
> >  }
> >  #endif
> >  
> > +#if defined(CONFIG_MEMCG) && defined(CONFIG_CGROUP_DMEM)
> > +bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
> > +			    gfp_t gfp_mask);
> > +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages);
> > +#else
> > +static inline bool mem_cgroup_dmem_charge(struct cgroup *cgrp,
> > +					  unsigned int nr_pages, gfp_t gfp_mask)
> 
> Please follow Johannes's request to pass the actually memory object instead of
> naked numbers.
> 

Also what exactly is the backing memory here? Is it system memory? If yes, then
you need to pass struct page. For non-system memory, I am not sure memcg is the
right place to charge such memory.

