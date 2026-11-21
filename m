Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B6B606A685
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WY/4DSdZ
Received: by kanga.kvack.org (Postfix)
	id 395216B05C8; Fri, 20 Nov 2026 20:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D096B05C9; Fri, 20 Nov 2026 20:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2830F6B05CA; Fri, 20 Nov 2026 20:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E74CD6B05C8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85E1814026E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:56 +0000 (UTC)
X-FDA: 85457344392.18.0160588
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA5292000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WY/4DSdZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223395;
	b=5VlMsN3DAff3Y3xnrOfo/DnF0BAeFzLhzL1yyzL2KdUapF4y+GZgwH3ntgwc/UYrEJF2ag
	Fikect2wVixrjnql4Or7/Am3knv7d//Ptt/+EUNDqBJ8/K4M5VEqJYunxLgYqdtgh9nmxR
	I3cN57SUqRVGB2xiN7ahq38GXY1DIKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223395;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afGLq+ZMse05M8Dqc4CQXKGm/d7i5Q1YL61V7nB27Lk=;
	b=OWMZ70LY2Y6PcImOwZzt0jJM9hfU9PT92fnstuwhbANKJptcDW+9Ih5rnQRdszLayFhU46
	asTy5IGrZpgqD2HfJOx7CwHoPZme27pxiCllfLwodZXkFg40QquvAQPtRGvfR0iCnANOJ5
	YBSlGQVsWSfs1GDvwdt4tkaN2G4C6JY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WY/4DSdZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84BF5612FF;
	Sat, 21 Nov 2026 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4DD1F000EF;
	Sat, 21 Nov 2026 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223393;
	bh=afGLq+ZMse05M8Dqc4CQXKGm/d7i5Q1YL61V7nB27Lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WY/4DSdZ5duLaVdya0oE7sMmY5T+MDho8mn9ASt7wojTMrtthQ93IU8kFVYlEp1CO
	 KlEFS/Or9UP57/toHF9OEGYjep+kJHrRjUGxKPwk2gXxXgjBoQqbkgJJDKit583ZUX
	 9h17ZTmZ+BIVm+Y99HDx8MqWdMoD2MHWvkM237G6h/DkHDV+h0KFKoZKp83SyPzsJ5
	 3+fZrhmwBkQBBs3VjccEEA6c1DR+wlPPvKhYBIwNzQfnHVU1msdKnL9L4Bm/nFhKWD
	 LSHkyzki7jK4W2qUcBC7GCWImPV+aURGT8IE4qLq5YdPelSfjnKd8zHu12OPNCoRx7
	 nFjMWTX2Jgvzw==
Message-ID: <sashiko-outbox-226485@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 21/25] mm: Add PISA statistics and debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-22-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-22-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:51 +0000
X-Stat-Signature: c7za99w6rmj7qmzxwszx7r98wqm1br4f
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EA5292000B
X-HE-Tag: 1795223394-909786
X-HE-Meta: U2FsdGVkX1/b9iuAKcbr8S1RYzhFH95dw7HmGLkDjm0y6d7nqLoJwjngdOawGIAHxVWFNCVT3RQTRBvcznAWFxkJnL840qo6NH2youNM5sm/xPl8GS0bjfN/O0YfKDk0tRHt5q/DWCqMuW5d8aXTNkjN8Z9HvQApo3/WyJXNPPMFpFJfzjtqZltqlA8N7yLbYVW/ZCcvn85hShTO/rqXZ0gIeyx1pou6Uf/AD0TZ00sXmn5HYr5XQEjK+PU4i/HeCEg20ShowWcCSMUvxMVXOPHRcy8zcUcoU/1sLH7zCQbWjRYmKRfRqUC9kbB2SmUe+Fl9QjjF0IMQEs1uy/Vk6oSsbgFocH1C1qC2AkX5l7qrLkXWDQ+SEJb7a4uUD+p2BSsUSo6M1rWrXsHlLjtZUnaI5PCGk6uYrN9cKFQ3sw61BabCzcHKOd5EIcicA1j2OCNjB0oa4SsNbBNvoP499NhD5ZIcSLpagp1h5V6t7bmGtuMWdaQ6U5bRv4ze09+IqspsR+226MatVUeHv44z2EuO+Fjsg8e4NTgyJH2ADIHzZhEFU8Fsdixmlkuc8t5KUfDKNAaBYlueQoaDN93X294LIny1uutI1I8hO5MLyxvb2ozRMgMJFyiQBbFDGrT7YiqdusOzaXn4BRIc8YpK5vPsVb6wXiUBS8Z6sVhJE/QzMXDVBGqCCgygs2AwRilqE1xfPGODDmyx3cEpoiXHD297fiqWoQXt+ocMJr1fn9mxPQvWuzU5pHkebyDNP0rnxlinpdwbRoH+tMJ/+2GCmoMd/9MXkqi05LIlgaSkzoM3B3e/6913c7XtzGZH3S6unCywA6HV24qsVdYEWndZAq4Vb6nP3ww8XNnpapMdgPaVMdvydLF3lJg2086UkfzIDmOtNZgY9rJSZT5cfjckrT4/yVw8ZgPn4wyC+zqCTWkox94wpVnvfIpTiugVvUTjMpl1ZtpjVQu0AhX6cok
 d8MvqmlF
 56FA4TJxVBFvl9Gg1Dc3EzbvOmhNcozt8hKjIvVluL8TDjkSt63jeAR1pVjk0PK55Dr2AsvmMlSqdvNzP7Mf1QKoxGK+2g/IdPiudzTNHSZIXy4uF+YK7TJN5gTKUcp+AarO4ztpzNDeZRnKg4VthMDNCCOcp5DPCGwMr6OAmhNX6sixA5ggXKLa5CHb9UC4lCg+uF5hRa9HCP9Vl1QXBHjyewRFGqn/HcM7LmNae+kpdVomM285UTgSH/OJlm6Mf0Szfzp842oHrsbsnopvw2QDal/l+iG/ZbYCAfPD02LDIuYQESR6WvljKKMilitYhS0iQcMRPo/OQUX+scve9UviuwitZQnX8FgCS+dqh8trhbpzOZyfIh7wONDLlHRVgGTb2elW3yYD88v+/ID5H1gpmyQHCht2sa7R8dNTlu3wPTwUg+IY84GLYMZ3crAs9PNkUpDlkhv+H+kJ5/QTPbNNIl99oZsiFDxE27MYpSgBxlU+lp/hdBh0dsQ182KCZbUhU3CDR/lT/diAMbBnz8Im94bvsLzvwHWj2Mks4Nca6pUPh1A4uQSorFICM7kcD27/JUjqd1pyC2z1eOiiQGq+3R5P/2z5sT3FfbMUBOmPvd+4IF4K/DgUriuYEbSKCI+tEA9OJqYST0y9WqN+V46DfM48i8sirGv0GebJPs+esQ6pSGhXm4hO0tEqpRs/O0hSpDSBWRvprOAf3jwU9NNW/72U5XAizQCK5gtwrwnGYCZPfm2r6HYGRfAM+YKZQIEsY5ZjbVJpdHIA7+vWf4x8IpV7BCHqas5ZaxGDMJEoIMcj3GEuaEM2cZIMtvvd1JmclO7CRXW6++Paj9ErrQrdRVUrsrq88NvR+lT2B/y8YUvgfXs6l15NKKjEjajQbA9vq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: test_reservoir_and_scrubber() drains all blocks before
  scrubbing
--

commit ccfc0b438a0acbf15484d4c2bbaaca5a2185d2d6
Author: Luigi Rizzo <lrizzo@google.com>

mm: Add PISA statistics and debugfs

This commit adds per-allocator, per-node reservoir, user-page migration,
IOMMU domain, and reclaim statistics for PISA, and exposes them via
/sys/kernel/debug/pisa/allocs.

> diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
> index c195fdfdbd9fa..98f06a7f2db7f 100644
> --- a/mm/pisa-kunit.c
> +++ b/mm/pisa-kunit.c
[ ... ]
> @@ -711,9 +711,9 @@ static void test_reservoir_and_scrubber(struct kunit =
*test)
>  			WRITE_ONCE(pisa_scrub_max, 512);
>  			pisa_scrub_node(pa->nid);
>  			KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
> +			KUNIT_EXPECT_GE(test, pa->stats.block_scrub, 1ULL);
>  		}
>  	}

[Severity: Medium]
Will pisa_scrub_node() always skip meta in test_reservoir_and_scrubber()
when init_on_free is disabled?

The test allocates a single block p, frees it, and drains pa->pcp before
calling pisa_scrub_node().  Because every block of meta is now free,
pisa_place_meta() moves meta onto pa->idle.  However,
pisa_alloc_scrub_blocks() -> pisa_pick_dirty_meta() only searches
pa->partial_dirty and pa->partial, leaving pa->idle untouched:

mm/pisa-alloc.c:pisa_pick_dirty_meta() {
	meta =3D list_first_entry_or_null(&pa->partial_dirty, struct pisa_meta, li=
st);
	if (meta)
		return meta;

	list_for_each_entry(meta, &pa->partial, list) {
		if (meta->nr_dirty)
			return meta;
	}

	/* Idle pages are left alone: scrubbing one would restart its idle clock. =
*/
	return NULL;
}

As a result, pisa_alloc_scrub_blocks() clears pa->scrub_demand and returns
without scrubbing meta, causing both KUNIT_EXPECT_EQ(test, meta->nr_dirty,
0U) and KUNIT_EXPECT_GE(test, pa->stats.block_scrub, 1ULL) to fail.
Keeping a second block allocated from meta until after pisa_scrub_node()
runs would keep meta on pa->partial so the scrubber processes it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D21

