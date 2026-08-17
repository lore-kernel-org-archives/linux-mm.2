Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D33C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 18:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B076B088E; Mon, 17 Aug 2026 14:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C1D6B0892; Mon, 17 Aug 2026 14:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3C56B0894; Mon, 17 Aug 2026 14:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0769F6B088E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:17:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAFC4A33B4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:17:55 +0000 (UTC)
X-FDA: 85111570110.25.E1FAF29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 215BE140005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:17:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A87kljH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786990674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lox5beP3DWjOeR55v0A2q5EwAzNvW2GMNuP3wFJiXQY=;
	b=zOYMX62Qbtud5lLTU4KHUVBwq8fO2j+V7d2ACtRpYrPXWorsunxdbVkeTzWb3xbcGDRmSS
	cDxkqMxg23rgydJKMj5o/tzYpB5v7052gnfIBzWycBmVzxPtWSoyxHRVGqcBTd8URO3sCg
	xrPSM/Ic9E7+7rOqAIZX2Pp9I0iSSUo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A87kljH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786990674;
	b=IRaHjqh6LTCz6/Jj4l9bzwTyKKsS+eJpso8FPZg348yoWg1MfYvT1Zxsr9CtWfN2GxfGot
	pl33Jwd9JSGTx1yK9ZOo0hVUD3lFvyrHxUB1OgJtXqODG9RdXNoWAvqGwj8VteCC3krSxq
	OpCe35F/i8TEHlFPDCOJ5Op+SYAUaFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28CDB43A0A;
	Mon, 17 Aug 2026 18:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170771F000E9;
	Mon, 17 Aug 2026 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786990673;
	bh=Lox5beP3DWjOeR55v0A2q5EwAzNvW2GMNuP3wFJiXQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A87kljH6QMe1mfh+7tKpGwq/QvZDIPvgAdindrhBg5loAuQSdi4lJBo/TJEm8/rCD
	 Hq9TK538xQfBYmvp+U4qA+iLRQsNk3U8jCmAGKDw4668yAX1hddzQPiEyFv9dx/qOu
	 Kx+9FHDm7gLxQ5BHJbme0EZKN3G9iT6obOWoVZ2axosUzXy5TVbznsLJ6Y7DL8QGcS
	 2Ig1pfPDWN1ZQqLzOxaYT4aStDZIex2Vz2QaV/aStvDrUoh9tPfndeUQhRoAn9Um83
	 RTnvJV6cxo/gRIHAfRibgz2V10L9BO0qCAOa5ZoL3oA+i0xVcaag0tFXzxNvNmKmEg
	 tY3UV22I8wDCw==
Message-ID: <85302865-4181-43d4-9c38-eb6ac57e3aa7@kernel.org>
Date: Mon, 17 Aug 2026 20:17:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] lib/folio_pool: Direct-Map Large Folio Pool &
 Scratchpad bump allocators
To: jim.cromie@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 John Fastabend <john.fastabend@gmail.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Alice Ryhl <aliceryhl@google.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Boqun Feng <boqun@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 215BE140005
X-Rspamd-Server: rspam07
X-Stat-Signature: ihcheq547dsqcr7y8dd3ozdba8xu17d3
X-HE-Tag: 1786990673-636894
X-HE-Meta: U2FsdGVkX19xGQbfquW7dSSUQXRM8adYNKdLwKawNMCjWb0yb8zCwX56syvafy0S5bMgQHwhhXWnsjQ8GTrNyT4g7sdoIL5uiQHl7lDY1g0xrWwv0NVe910DzUZGgrOm0Aq2Xk/8QuXmeYN+jZwtSOsLtptPivHoL1bJJH607vqm5EcN7EXUg+xbr4hCdbuFmY/9fHpaxYwWVPZ1UJyuvwdSH2AS82r/yMhwhvjft6tLTDtVf/VRpgATSnzXlOzECuMIqurz2DZ34IVScTgV2pN298cr9GPG8K5bowsgp8UufKGXRD16Gy4GJy1R3IPUU9ajpHLSycRMz2ZbpkU4Hp26ph+/NmadkGFEsEE18/PKRgIvCz6CZf9hUUct818HU7IqLxkMlUVZhe5TMK8CjXp47JSN4REu/hC2zHL2jMF9iWXGTRdHJW38kmAIN++TzrODxTWRnXtX2EoYpkyJ6VHpspKPF70MRpz+Y5ecN7E+j3NyhMvlAbaAmDX6+rs2r4UVRqBPFoVQ4n0Oo7oGk+dCxJpitwekZ+Moh1Ea7uTW3heeVupFW7n+s7gg/7jlsQhP1Wp2JCBgC83jo0xHKIMqq6uh9ZOLFflx2IV8gX8OUHuRzXCFMYAbXIySg/w7/iWXdna2eqPmNf6WT//T0v9Y+MiYY/Z6YVFScFMq4Phjh62+bhhaOQ8NNleJbkcOtYAvB2p+ypGsYMZ1n5wOyWlbFdxL438tR7cmT/QnsOvNR1XRg9UoyMFr+SkHUmqD/LUnHFYnKky/VwKf8iNPUA1WrcVKQMgtsOIt6Rgw8rJJzQ4gJlFvrjhU4y8ZKbQ2Im9s+ZdpHZQtBNl2IrL9pRzt35x4oJs5MGVKy6UxgGoF2LimubKPhs+wG7xKGjbJKelj5lsOqk9h8G8G/WNzxrkxcBtcLxd9/5Kj0zDYJ2CalvGAXlQZZqADqLmsm9fRjpVGp9i06y2uVUiUu6l
 QN/eWNw8
 YB7wvpl/GUmngkZM60VuAdK3cuyCLZ69esph0Ylsih+Putgs+VCuDfwp6midDvRBt3IFIceBJI9lnK74NCSCon9QldFmMXOiY7gL/Ky4Ta5esqn/WOZeWN2dkxVTNZytMW/w4r5121WQyKlukx0b9RlCzyzaELdD+GHFAWuIrAG4MfRaNGZ89adBFeQyVPKlM+ImCX067tFkDOzlihdjuzqE52VpVB7YtSotuvvpf9C6HpnPXn1eLhKnhcU61//uI7njS96Bgv0Fi6nwF6JKencVJLu3kURyDGqo1spqs4uqyFJOQEGFtD7flmUBd+5yWGY0+uqCKfQCierc9KxF+1pE6SsPmK7/jKmaEcvTx61AuluyQoWYKrzEOnm92TNM6ScRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 19:22, Jim Cromie via B4 Relay wrote:
> Introduce two light-weight bump allocators backed directly by compound
> folio pages from the buddy allocator (skipping SLUB metadata overhead):

We are running into a bit of a naming problem here: folios are really supposed
to describe things that we will map to user space, whereby we have to track
mapping/index/mapcount etc. That's really just anon + pagecache memory.

Right now that naming difference doesn't matter, because each compound page
really is a folio.

But once we start decoupling folios from the rest (memdescs), we really only
expect anon+pagecache to resemble "folios".

There will be other compound page types (similar to slab pages), and things like
page_folio() will fail for them (like slab pages). And we are actually working
on making page_folio() fail earlier for anything that didn't go through
page_rmappable_folio() as part of the (folio) allocation.

So, does what you do here fit the definition of folios, or is it really just
some kind of compound pages?

-- 
Cheers,

David

