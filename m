Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C78CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4936B008C; Mon, 22 Jun 2026 09:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E653A6B0095; Mon, 22 Jun 2026 09:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55A96B0096; Mon, 22 Jun 2026 09:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A634C6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:09:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49522A016F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:09:09 +0000 (UTC)
X-FDA: 84907579218.15.E3A3C93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF58620014
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:09:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUM9v+wL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZFdRQ3GzBV1ICnHazzOEay0tG4QdLrRZcdMJ9xFc38=;
	b=DWB4KrNTRCTIWVK36t13/nJw9X0Sk+WglbLhX7ny8gTgSy8Q/z6dPs3fBhNCAY5ooFsnYs
	RRPEmA6TpKNAlyShCshXEhTg1KMgjvAabzHTUoBLBZLwbk3pyU1ogWumvlUchsyLTV43zg
	SA3uQIeDvVJPbxGNTJEnL0IBI5hPsgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782133747;
	b=DuruMmfudcZXw1uU/0dlP2WmuhY017QSs0K+vbCp7jjoizndfJddufnhCL0K4hGFkkQ3QC
	wSxHXGTrKVzB4eryOMp6Bl5hp3+xZ+UTvTmSwCzoSGr1UaV/aEBWYoUAy+FgafPYPu5PrY
	7blK80qOIeyhBn0jlMSTaqVbVT9tVZc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUM9v+wL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47C1C601F0;
	Mon, 22 Jun 2026 13:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34141F00A3A;
	Mon, 22 Jun 2026 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782133747;
	bh=gZFdRQ3GzBV1ICnHazzOEay0tG4QdLrRZcdMJ9xFc38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KUM9v+wLZQO1enI+613wmnzT5egxmMhGsrEkuqN+eZP9WGyAxxpH7mgEw3iPsFslR
	 YiaYDYjhOFRElWICPJ+JqrqiOmq4erOBWjVa5gyD4vd4lDqQ3jdB6TduZ+6VveFBWT
	 erzp5pR4Jmekf/pM3TbZ42h/1XVll872BDQWM2+tQ7gRSDA0JUtLXYwQItTlf5JR+8
	 2twS2Intb0BHBaKE8gx2QRKXwOCaST7ZNwWkuDGfDQispoVoItGORL02yUVxD/lVkT
	 TAA9GEK5WxOg7ftjS59xgVbEkvODv/RHUhPIL1ISoP1N8/IiWxqyJXsWZ2tQTHg1gK
	 Et44PH7BYtLvA==
Date: Mon, 22 Jun 2026 14:08:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dimitris Michailidis <dmichail@fungible.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 00/13] mm: Some cleanups for page allocator APIs
Message-ID: <ajkzGElCGxJt-s84@lucifer>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: e7c857m31wgcx38gs3atqds8kz1h3w3s
X-Rspamd-Queue-Id: AF58620014
X-Rspam-User: 
X-HE-Tag: 1782133747-864821
X-HE-Meta: U2FsdGVkX18XtDRmSB5VxS0Ap/nlqSk8L+XvW25qDRYviMbqu62NmcI5icGeuqQdIlPUZyivJVRJnUoK2g++VP7a4bNR05HsHdfjdLbGFmqlIqvu6R7tnNriTZpnFt2VNm3dxWbkAYOIE1bk975545uanL+/4nXKSibTmxL1ZCx5Bs0WA28uiN52Bb+mdvtpEnWPndbcNsWkczk7J+HwQXZTFyvZ7bMmE8Yw3nUFjvYSXrTOGpg1tVG5F2RKpkDDdEOvSuB3Vrd74j/zVqvH0ZzZShHfxVr1mjIC3v/8ZXskEjdzI31+krzPRtT+3Eu95EM56J2qZEhAv7AH6SnU+A+zTSj1BU6dYxPQLtSE0XucnpSzj3K51NyPaMPoNXF1jaDlXl2ipjDvqjIpfn1J13lR5/BPq4YsLIesv+j/CQSQHT2Ecjm8niWjwjG3MFDDb9aftPfEfsz6MLkCs2vLdUY53zcS4XCKn5b1oEbK2pm7ICPYRZ7UqwFHde2n+Q/rnov2Mcn95PoHig732Iv8AFLQMuPkfKQpYzfluDz10pOmebvtKhVF4+R/tVDgfwWIJX5F8H1bZbEeYAgIHhzeZbKmLRQH+ZZjjHLwHocQ5GtPxSCNLV+g9nVS3/SzFtGa32rI5HIXzF3WftxUS1ET5W2O0hgRjQadlzryWuj6uIDAT3hz1JaSVK9dDa3ZUtOccDo0WTnIfPXvhepKn8ndLh7nK7KaU9jgXNfsxZh546DVCFedgpuKCW2KmTUPyWGG/gKb6v2y/ruFNkK03sM2kRxRLNEnPNUe+yqaBAxqtkImBDXhRjsSEnaQtMRib7GGPUe3X4hwawlTqUtnyrWtMN/7yggSpvvd3xGO9PWO6f62Yr6/5JardtvF17XOo9tHxqmz8+e+ib2dXa4NZYQf6AoF+jCRCep+nwt6knm+fH5mE2nkiBtpvZUxaGIqMMNGThGaMgUtruojflhI20G
 MqMzwTgu
 021dYpahAwdoM78gBqpAD+LAkYIaL/QRYZoJ8CpwHXmBaNRqnV6Jj0RRJcxw/fq1Dp79fiaAdV7/JKzZrs1BRLCAYIEzM0Z6XvydHn8W9D3pOftBkpXOLqynwPNsHujeob+fC/DzCLY6GFbxnpv9Xg5J8zHo3zTviTWyu/qOB7itZktmzQ2aX0/28MAXQR3Z23SEL98WZEgSj56Zg2M/1z3B0w7O7ARU8bSxM5NiUaUdcQvxuP7A1s9pA2SbBk/Uqnp8pslfv0xUWV3a7dbNzQzCWt0YlOX7FkC+juj9qO5YupZz1jjmbPpNfWceEo8IjHjC8mnm9yC2ZnG+HXbU/bdAVVhrm+qKY071upwCa8DO5wk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the series (cleanups are always welcome :) but just a gentle,
annoying, note to say it's week 2 of the merge window soooo we're not taking
anything at the moment as it's a quiet period (mm-unstable taking only fixes
AFAICT).

Though, it's potentially good to get stuff in front of people early, just an FYI
that we're trying to move towards keeping the merge window preview/RFC-only
going forwards.

I'm not sure if that'll fix the impossible review load problem (TM), but it at
least helps keep us sane re: what's actually landing/not.

So Andrew will expect you to resend this after 7.2-rc1 appears!

Thanks, Lorenzo

