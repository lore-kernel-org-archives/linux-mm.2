Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3DFCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593406B0005; Thu, 11 Jun 2026 23:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544046B0088; Thu, 11 Jun 2026 23:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431A06B008C; Thu, 11 Jun 2026 23:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32F616B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:49:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B801C2652
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:49:53 +0000 (UTC)
X-FDA: 84869881866.04.3DC2A3C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22707C0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:49:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/MyNDrW";
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixiQyVcnY3YM6U4Uy1f3lDFZTErmkQjeBnlfx6n7LgU=;
	b=1HCEeb5zVUIxEe5kC3cjNv925IPhiTw+olWrnS/HxIlevhjl5Ose6RsUCbdD9G5BZHA01f
	fq3IZUgYDgUbzUbCMxp3FaO5xN3tZpzNTJJmBvBi6as7JffGbtoeh4L1S7dBcC6/Fl5esn
	eTw/99Gm1/z3lUgVaAvZJSN1T3gNB0Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/MyNDrW";
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236192;
	b=WC10NPAoaAJCUSlEqem0k2d+DvuIS4Km4NvTcqJ37IXBEHPbAFQaVhcVasxWvrqwBmf/g9
	4Im1PWXJ3KHRFAgOJwEfH+ftDwFoqimXbnNI67i3x2JNlQaHF+Toaro0EchVrImn/PzkPb
	tKxtGuQHS7eE3HtSXE494qpBbUwWeVM=
Date: Fri, 12 Jun 2026 11:49:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ixiQyVcnY3YM6U4Uy1f3lDFZTErmkQjeBnlfx6n7LgU=;
	b=s/MyNDrWb1pU/BXD6bpLz0rJoAePBgxJvUr6QVez9L3LkBGjOQInrcL1rqRUUrwq3Dpu6M
	omIbmFHhMYnzSMKHvjT5i05ejKg/w8VIo6UYiHOCH7GhESGXUnE4o1Ra1kmlNRB1G+jhYn
	id4UwS6u815FUDzrY1XJRFiEYFa0R/8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
Message-ID: <aiuBoDbQc0N-l7e-@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 22707C0002
X-Stat-Signature: qndoztx3dpwekznjre9jkmpuzkdpcbok
X-Rspam-User: 
X-HE-Tag: 1781236192-454796
X-HE-Meta: U2FsdGVkX18cOVtD4SqgakOsIAKTDOQNZWa3unOCMn8/Ru0WzaQyt+jD79kxj5YmKXR/e0HGknamerGlEfS2CtXGjqpR4Wrq2lJR57HoybRaDU20G8eAiRK/eS5111iMuAZ8UzBD5IRUy+QzmTbvWpfarDZAYyxGflQQe1pV6nMzyK5At9opJptApsNE51jRg88+IfkuSnNSV3HWumPrv5VkoaGokO3HfXvdFm9rHFHCpwz+ZZBLyx3GqFxog8yX20Uik9KlMHJjSZ/Sm4Ji+lta7YlWz3QPRwwPOiFtsUIomrOL3nBnzXKGHxijkO2agvN45+NT8FRLuTZ7lVcFx8ORtLf6tFSLsKj+2IZs/uMEgZI2Fxh+oqeURvMkFpTLn+X6u/LP2cR4Aa54V1fa734g/fGbTZW4oYioeEi5efMWOxiwpNAKleo/Kulg3nOHWanej7r6j+tZS6zR6b1xsFJXRHVgLdB3Ob6E0MmrqckCpHta6TYPfzIb05Xc3PNUJ8hqMWDY1v5QowCyZRnrATBfJg951ajklJHGwi3xl3swHiTb1JT2JIqwblh1iKykWE3Co22blgy07vGoJabuKPKHgwb4n591UQE95XwoQ3zR+eILfdSDBGaHSxGn8EmopK7z9nOj9G2lbY7WpVqOji5ZLmdHZS1pyH9eEUZTczovow4pjxjFCiAIIhOYqiKLZlUrKQw9YGG6dKmLII8HJedvV4owsy8HEmlUsikZFtQczzKW7PAEa26isA+wkXLAlvWcQ+Abs6AQr+P9xAfnkPSvu5ttTjvY4KEuiDu/DfHvd5wuPQDtNXf+GmZYt+fOaDjlBrZ+2CYT0fX2gjlgrAQnYVTfzbnt+baK7j9pxmFRyDDLo/R7EW9tlMBZxzjMXbOA0ICa2/QcgbmfczzQG73HydPauzh16QmGjiawIaaEl0J6HjxCws3XCC8JoyjPSI9IanQk6rMFRyXOuMU
 UV6EyarH
 t/S1lSQ1NAnCzlFsZtjpritcxuZ3EIyxDga73PkqrWGbginQohGyEJo39kvlbBUpwATzJyaH8k6kM9s83S+EQdlYq+Ij3TnHt09KkvFcrNMaT5noGjCVXHPkUPUXhJ+4PMbBnBl17C6YNUafEOZ4L2jqxRqr57tpdXWUCrZeW4NeILBtWTFCFwraYviQ6F5LmHhb5vPRk1Y021yfCOTWtAVKWuwSejueOPP+53Z3jJvlNUCBUlSMfv961Wgw/NV2NPV0hxh9EgB1I8GWkv+t9oTaX+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:07PM +0200, Vlastimil Babka (SUSE) wrote:
> Similarly to the page allocators, introduce slab-allocator specific
> alloc flags that internally control allocation behavior in addition to
> gfp_flags, without occupying the limited gfp flags space.
> 
> Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
> page allocator's ALLOC_TRYLOCK and will be used to reimplement
> kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
> gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM flags,
> importantly __GFP_KSWAPD_RECLAIM. This can give false-positive results
> e.g. in early boot with a restricted gfp_allowed_mask.
> 
> Also introduce alloc_flags_allow_spinning() to replace the usage of
> gfpflags_allow_spinning().
> 
> Start using alloc_flags and the new check first in alloc_from_pcs() and
> __pcs_replace_empty_main(). This means some slab allocations that were
> falsely treated as kmalloc_nolock() due to their gfp flags will now have
> higher chances of succeed, and this will further increase with followup
> changes.
> 
> Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to
> reach it from a slab allocation that's not _nolock() and yet lacks
> __GFP_KSWAPD_RECLAIM for other reasons.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

