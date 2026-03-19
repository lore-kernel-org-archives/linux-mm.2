Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C85109025A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1AB6B0005; Thu, 19 Mar 2026 13:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799486B0089; Thu, 19 Mar 2026 13:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6446B008A; Thu, 19 Mar 2026 13:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC296B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:03:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29C985A17B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:03:41 +0000 (UTC)
X-FDA: 84563434242.15.2FD7D50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16E6F40019
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:03:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwHVmLew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773939819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnOJgTRX92Ith+tBmxgQWroAb4JQM3Dusnkzle3TvVs=;
	b=UucjDu6dSbYYIrRY5+wDaw3kQq1Ozsmp/kr7aIz6FNDYo5fDRsjlmmAegbTl2G+o0AnfZo
	BLwKnom+h7jBxVnhSjtUEzgdgVN7y6AEsWHNhaCfU+aiw+J104/PuhuZOsLw7rCxT+FUcI
	L9M4JUD46/dQ/8qzr0bnx0QHUSwqWME=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwHVmLew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773939819; a=rsa-sha256;
	cv=none;
	b=ODSaWjmGSHdm/3/3dHLglrK7ClFfWsn1tqQr6tbO0+Bd4zAhWT37Af34I0vzR7vL8ez0M1
	MuRVzL6zF93mGkSdNPv21TV7oU5Ry4tE+bNrqc/mPHCztkPM58YIyn2wt0d11PF4IljQZ7
	pLpGoGyC/8oKav3/KlpbsSRIGklQW40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2E054449C;
	Thu, 19 Mar 2026 17:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510C3C2BCAF;
	Thu, 19 Mar 2026 17:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939817;
	bh=zhgENmoC3CJmwU0Ib1ROwyOlGYhPQDzEhDRfGXZjPZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dwHVmLew4A+G9r3Ag7Matgm/2aSbLT9tZKzaslblBADpH1YYS1QiyBQ5m2Fqg7Pgy
	 YFUFoXT9rDzfvzJnKpCOKRelum/vtha9WXEfiQLuKWtZ/sUrycZwLx8aKy8D7qtjlX
	 KDzA4xN2aXkcTANEua6MixLNFuiKPpUdgjXK8Wp/SOnotHq9rC9sbFEiUERDjmV53Z
	 65OjhmIKs9AAn+INbW+7Cb2LSnD4ULZXuzfLQHNXd0UkORrjDYouiNm19F7D8cHUrD
	 DjFNpMkJfZNHuOBeg7erxulj5PBN6kDziMvbDHN6mCaGkdaNvUuwIJ5Dq96XydWgS7
	 OLyaemLVplRZw==
Message-ID: <215517e5-a49b-4eb7-824c-8c42e4db046e@kernel.org>
Date: Thu, 19 Mar 2026 18:03:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16E6F40019
X-Stat-Signature: 85tt1biemouqsx3m9i78eqduj7do519y
X-Rspam-User: 
X-HE-Tag: 1773939818-962536
X-HE-Meta: U2FsdGVkX19lUtHYMxdHctF/h7hkj4AU/bcyNdQTWM2Kxna1aH2bxe8ExbHIq2qAttvtLDl+stQLlTBkHMbG4swsNvCgtzqiowMXtqTAzL9xw7TU4c1Rq7SeZY80qxcxFg36yk5xVAzgh/OAks3IvQFEXEOwA8vKJ2/SygaJLo7ilGskEbX60okdisZ/djpsTDXG6BvGICb7lfcYnNpghBbfX61jn8D3+F9uG5vep+QyAoYU74PE3o/3VDqyGXk5Qrj5AnM5ef7Hwrh8vwG+brLBxd8XVToPf+aLjqtpj6LItTXuWduXyM7SzblSJDDb+ga8/GWLM74SGCxtwiuJFEE9OdaBrSdstaRja2bj3Zi6GBO4N3j5g+1c8hFPh5PusTvT6AF+husK6Zz1KKiKhSzOqRNy/wO+EoRsePd0TSRsTbabuBR+Z1Vk1e8z1cCikuMIQ1ZSZTy7ReZdyhpc+nShLrmghsfZjqAg86bvcZNYToWUpaIh6aN7X/UHhOWzWI5KTTDrTFXvGUMM1f74IMQhreBx2f43EpmUB3/7eJTOfdPI5Vf1AnbzL6gUJy+Il36nOsWFg+v5O0Lh0VikHZN2VXo8KRRHG7m7Cpn0wFD3BSl/lkPZsn1w0wU2oUpTKpXunXAh2XNjjgcNy6LVkvwrCGmZC9cO6Js6YOuOFAYjh7QwjW5opxsG4LpiYw/ibVW+79+Iy0QFJTije4PUPLMUf4UZ1b9jSMdlMUHZLn2IdPBdNjd1iZH0ZexXj0lsbWHVjLLSEfRqjutDjYqX3S0bfoaXOv+jbxBq/DjXyIuSevWBPugaVh6T6kKVQYR6AJaMyN7U05zqwdOf0RS/0rzVYulokIWAJoQMO0IOiroOW449gfq8GXdXlv50ELjDzj6G0m2p0pjyXOmuyDyYibSAC8VFZ5b/q8AKXSb49mjYqA0j5i2bCfgGSaKVYXf/DvYvxDY30SC5382JxoQ
 oq0aOOeZ
 eysSfUCwXPtoYZ0M9cSYXc/9l4WTC0uN7BdWwnyPVJhHDZlkGa0gKoVSovFDz4d9+HegQx9zVwMo5tcqU4QgfR8kpH+ir08bU1ZkQDXaDrhF1HORfIVtHDebzMSVczWYPC9bIS0wMsi6AoSA8oP8xVJKwWXxY+yEMndGCSNOn+FcAPuR84ZEYlOA4yBKlx0+L9LHd08+Y9cnHJYEzKXgnht/dQzpT45sO03ggWVrXpiWTk74lBHuN4kgOqkaxGd3SRhz9nuTGT8nceDU7sKEH6hEQrNjpwkL8eTTbUiKg4hbftbISD2Jfo9YwYjGGFPbgrnsvFKDtW6ngbpVHt/Bm1YGJ8tWgeuhYHdPb3oa7bXpK6w/ZdOZpUA8pfkmBc6FXYNNzqU//cC95MQZPX3JmmtosLU4Fs3kHbdLsgsAbavZxoDiknZeTDJLo4cgjwN3CgZonp/pxxD5s2p4a0UHqw5DWexv5jHOpjKnknlpRvDQ6AXmF/82B3AKRXkwJ05HGAIYLqx5gSraJY9fstsSgovvdfXuK2RhGTpG19s/XyJFSKqPCUeW2SurOKkRkCbDm4OH2Lz9NZn+737NeDLBtAatvz7DXctJNVnAFC9I6mF2P2Bc+zvYpYOWasF9Cie7dsQLnwtOt76IwDFtj7rsegmcuf9fHueITSTaexzIY7Mqtt9vf1pTdD5dKflXtsYkebnidEyp+Y8zJLl0uT8raOdJctWwZICCSh+tUoFUurQfTlWb16lNYxjpJjHyGvIKybn7141VORjDtCmgM5gJL8Hz3vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 17:03, Brendan Jackman wrote:
> As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
> probably not needed for 32-bit. This offers a way out of the GFP flag
> scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
> machines, while leaving it 32-bit on 32-bit machines.

Thanks for tackling this! But now I'm wondering, if we decide to change it,
would it be worth trying to add some type safety too? To help with cases
like the recent kmalloc_objs() footgun discussed in this comment thread
https://lwn.net/Articles/1063356/

> For mm-internal code that prints raw GFP flags as hex, this just updates
> the format specifier to %lx. Presumably developers have a reason for
> wanting to see the whole flags word as a number in the log. For printks
> outside of mm/, I assume they are only using %x because the authors
> didn't know about %pGg, so they are converted to the latter as prep
> patches.
> 
> Stuff I've done to try and find issues with this:
> 
> - Built x86 allmodconfig and arm64 defconfig. Hopefully the 0-day bot
>   will alert me to the important builds I'm missing (I briefly tried to
>   build s390 and sparc64 but ran into tooling issues and gave up).
> 
> - Ran some selftests on a x86 VM.
> 
> - Poked around at stuff that refers to ___GFP_LAST_BIT to see if
>   anything looks wrong.
> 
> - Ran this Coccinelle script to look for explicit casts to plain int:
> 
> ---
> virtual report
> 
> @r@
> gfp_t x;
> position p;
> @@
> 
> (
>   (unsigned int)x@p
> |
>   (int)x@p
> )
> 
> @script:python depends on report@
> p << r.p;
> @@
> msg = "WARNING: Explicit integer cast of gfp_t"
> coccilib.report.print_report(p[0], msg)
> ---
> 
> Obviously this series doesn't "do anything" so maybe it doesn't make
> sense to merge it unless it goes in alongside __GFP_UNMAPPED, but it
> does seem to make sense to review it independently so I'm posting it as
> a separate series.
> 
> [0] https://lore.kernel.org/all/6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org/
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Michal Hocko <mhocko@suse.com>
> To: David Rientjes <rientjes@google.com>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Brendan Jackman <jackmanb@google.com>
> To: Johannes Weiner <hannes@cmpxchg.org>
> To: Zi Yan <ziy@nvidia.com>
> To: Harry Yoo <harry.yoo@oracle.com>
> To: Hao Li <hao.li@linux.dev>
> To: Christoph Lameter <cl@gentwo.org>
> To: Roman Gushchin <roman.gushchin@linux.dev>
> To: Uladzislau Rezki <urezki@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> ---
> Brendan Jackman (5):
>       drm/managed: Use special gfp_t format specifier
>       iwlegacy: 3945-mac: Use special gfp_t format specifier
>       mm/kfence: Use special gfp_t format specifier
>       net/rds: Use special gfp_t format specifier
>       mm: Change gfp_t to unsigned long
> 
>  drivers/gpu/drm/drm_managed.c                  | 4 ++--
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
>  include/linux/types.h                          | 2 +-
>  lib/test_lockup.c                              | 2 +-
>  mm/kfence/kfence_test.c                        | 2 +-
>  mm/oom_kill.c                                  | 2 +-
>  mm/page_alloc.c                                | 5 ++++-
>  mm/page_owner.c                                | 4 ++--
>  mm/slab_common.c                               | 2 +-
>  mm/slub.c                                      | 2 +-
>  mm/vmalloc.c                                   | 2 +-
>  net/rds/tcp_recv.c                             | 2 +-
>  12 files changed, 18 insertions(+), 15 deletions(-)
> ---
> base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
> change-id: 20260319-gfp64-7a970a80ba4e
> 
> Best regards,


