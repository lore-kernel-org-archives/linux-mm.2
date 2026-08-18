Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E49BC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58266B085C; Mon, 17 Aug 2026 20:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C085F6B0866; Mon, 17 Aug 2026 20:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF986B0868; Mon, 17 Aug 2026 20:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86FE76B085C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:35:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA4701206BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:35:19 +0000 (UTC)
X-FDA: 85112521158.22.03647AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 658DC40004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:35:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7lhpOz2;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787013318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6o/Mjguy0kTftlgmBYSy4gaJDB68wNIKzA6Vj3TLJI=;
	b=4M89mLTmh32B0oMUTRk7vB+zOWmTFrbdSoXz1FNo+2tL1w04fqF4qAS4YDGneunFwFnSao
	XPx+VZh37XFdg/OaeYRTBeQvVug20W8XxC/lnP2qwDNMHBMzSfYkCyiG5tT2j8IN3+X0IW
	ksix7J2s/KVTNN7Sfae8prCF5AkjEe4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7lhpOz2;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787013318;
	b=O9H8CDDINWg+bO8q7D0PA1Jn74NLU0oWR+wK28cMT3c8v5nxyszY3NXzte3VeIX73WsDHf
	qqW1cE3DbjhqZ8WfEl7XY0gTZmBd8f0s9WyWfjjxEM/Dazkw/W8nLuoPVrkgyapa/9JuZx
	aWHWA53fGCCpn79Vq8vBCITSwsMegkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C13CE601DE;
	Tue, 18 Aug 2026 00:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746451F000E9;
	Tue, 18 Aug 2026 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787013317;
	bh=D6o/Mjguy0kTftlgmBYSy4gaJDB68wNIKzA6Vj3TLJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U7lhpOz2V9rjd0zWT8krD+LZt3v1GQPuKmCukHl/7x7wY9DvYezxlkpiTF8vcsjzF
	 ha+2mMxkmKc7BvRPbSCjlCdQbgwj7ZmXXeflh2but+bff51Dj1LQA0rf6z48ad6qbH
	 uu0tjJ8c+sXQ95Pv62HTCo70d9TlC3u0c9+SFFtviD5Kgiq0xou+dXp91DZxVAdWUo
	 1ZaO0OfzoMtupVa40r9H/TLiR+e/uOG67SzaGkO91E1zQUDXs6K+tgrlUu9rvowIgE
	 DXFVdukK+HWqV6vIvLiJ5nG/v3xnPjwHC5uTyn3k34tjomvJu4F7j7OvDGmhg5goqD
	 OBphIxoXc5pnw==
Date: Tue, 18 Aug 2026 00:35:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
Message-ID: <aoOomzh1ErtSeKFb@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
 <anJmOMqCVugycC9x@google.com>
 <DKOLND2TRB15.2Y8DKB3ZKEYAY@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKOLND2TRB15.2Y8DKB3ZKEYAY@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 658DC40004
X-Stat-Signature: bu6i8t8yyko8owhytzjkexeqgs1f3nu4
X-Rspam-User: 
X-HE-Tag: 1787013318-251161
X-HE-Meta: U2FsdGVkX1/lAZ4jsPZInzZVDOqV8XbDfOdxy5ZgqJcAU8njhfdCqHBXySkyt2XFLnawFAt0drThXqY6w/7L8TM++/xKOWXzgl40+kbEzmTWow6qU6NIbhtvu8l0a+zo8eJxLDlSuc1MOxAr2hmN0Auk9mFqthPoRof6PY2sUI3iR3ZhfMfgKUL9Ly1qTqXnTlcVRT6cJUO60iukFh3C1/Al9OC1nfK66vLcwwJbcy3TjDELB+ch/zcJcagzPcibz/uxaxGaour2V17DKr0rtMf946qELazJwGjrvbA1QFswQ54aBiJSlLzsiDpWcO2RvQFskrxAgFe75aL38+itLd2QrKecRFnwx4tzWKgQelyPyTLxd5Tu4dmD/Ah1+565Fn8RzKx09aTZ5Fxxg6BA4gjmfJhYbPIX+dXj6V4JujrR1lNEiDPmfnFSJqEPaa8+Pasr2fRrNBojdpDu4SC/d5T3JacXp15TaWkULo/UjJjH2pPIX0aAeTjZheog00hYd3f2niwCA6kSEA6va7evwT5BvMmjYjMSiXOLClUmJrqLUTtA6fiqLfBRz+JXlu+HRJ78VLu1BP2dYqyDdWOH9j+/+0uXNf4663Tw30osMV/P4s7TIPD5dITOi9/2EMN9UGhjc/lCMwKXx9jmAnnTPWIgOAj/Oqpo2+5cIOrxBVyOyAZzlFlImwHqebaVOklgGlAxjIEW8eua8fXtmBZh2333nlww3R58PfK4LB2rM+2tk1ClWmBvKcwY0xsXI0s7GVpb2xo4R27lcVAAwJ6+q1feLDvBBGe1W0vovKHXENwdHb7ENKpJDLQSNOQCpjnl4IZP2WpNQ2idtNfDvhEMOmfMPtrdz7R6sF+uO3HWFVTGZo1tKRQJJyJwPQxs2Cz4rhhhv7XAEFgMfNW8SYJ4vAXUcvdfkGDwWsEFrMYWsvc+cGX6FuH9jPhpqPdyvVzXtsErlcyArgSPApJUVpI
 WowfKmyV
 oH1uLU6POVoeYLhvPBrvtfnapBdXA0n4zudalHdxoLMRv26I/bhP/MJqcFrIwa/SMjncQ1bITpCm5iuVhnfv+jiIYEs/J8SX2oiDgWHi2MmYnkQhXxCDheotoGmWrrlVH58atFpQWpe2poxpacvGVLbBtpzowVqXH3PyCxWohjP77m756QrnA8UiL524kyqTQGgBX39rsokHQJ6wwNeoCSS32MIvT7y0hbMni3CttoUvRfXBNV7kwjxPLtC4f5XQLYPm3QXyGM7ThvNRivYTWOefEYKXpaWOPwspKRq3B6bHlgruCkFz+SXO8fPP+uXeSGiBg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> +static inline
> >> +struct list_head *free_area_list(struct free_area *area, freetype_t type)
> >> +{
> >> +	int idx = freetype_idx(type);
> >> +
> >> +	VM_WARN_ON(idx < 0);
> >> +	return &area->free_list[idx];
> >
> > Should we return NULL here if idx < 0 instead of an out of bounds
> > access?
> 
> TBH my descending order of preference is:
> 
> 1.
> 
> BUG_ON(idx < 0);
> return &area->free_list[idx];
> 
> 2.
> 
> if (WARN_ON(idx < 0)) // OR VM_WARN_ON
>   return NULL;
> return &area->free_list[idx];
> 
> 3.
> 
> VM_WARN_ON(idx < 0);
> return &area->free_list[idx];
> 
> 4. 
> 
> return &area->free_list[idx];
> 
> But I suspect[0] Vlastimil (and Linus) would order it the exact opposite
> way.
> 
> [0]: https://lore.kernel.org/all/bd36e972-8900-4476-a66b-4dc218b21a4d@kernel.org/
> 
> And I care more about making Vlastimil (and Linus) happy than this tiny
> detail of the code, so I'll defer to him. The current style is a
> compromise, but maybe it's just a compromise that makes nobody happy.

I think I prefer #2 (regardless of whether it's WARN_ON() or
VM_WARN_ON()), let's see if anyone disagrees.

