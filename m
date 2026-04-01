Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2873D35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332536B0005; Wed,  1 Apr 2026 07:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2C46B0088; Wed,  1 Apr 2026 07:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D17E6B0089; Wed,  1 Apr 2026 07:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0765E6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:05:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C848F160827
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:05:46 +0000 (UTC)
X-FDA: 84609706692.03.5B53D08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE5E018000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:05:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VuHMapRR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775041545; a=rsa-sha256;
	cv=none;
	b=tYSZQd4kYXUsbXJwxtvnLQZOUtxaYkFdxyhqptGwGAnmIwIDUiYHovaBEu6ZpkxH0D9VhV
	4w5hCoa1X+VAFcglmlqBpwZgaYfjmITKrpw1551Tz6tI997wMc3AjEExM9gp7z/AynutC5
	dOME66mV5gPkYCb+/185kbDOwFurtHI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VuHMapRR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775041545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2lPtimPmQkkXNmuzgtBX2qZ0+CUFIjd5DSbsVAJgA8=;
	b=X76qZizkoAGulVRGi8nr/of5WdpRB3pCDM8euIJfmEO2kil7afSrVNRjASvkohE8SJGdym
	pi35ZvvOv3fX2gLn7FAn9dBn5Vgtz/gtDjT0aKvkkn0eEF3F6xcB0JIK1fwBDewlbuJN13
	1EJDYC5o2RHU7znj/M7qLLZBBG/ywQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D709840882;
	Wed,  1 Apr 2026 11:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC9DC4CEF7;
	Wed,  1 Apr 2026 11:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775041543;
	bh=1W8+dv317eOsKjSSy7HgGqEJKVTnHGlpluDtimbO0rY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VuHMapRR71+J3DlcJFKc9P8Xga9VPkyYA3xDODcUmkHZppM1f7vrFLx9TfqB4nsfa
	 zcJRZUR0/leUE9Hlu8V1oFMF8Jges1BU3/Ut7ip5Gd9A0tVoVnrvnyoZz0ob+QERqY
	 sCDDxqmzDC5B6JAV6UiILDNM/TISWWkyd0OqRYheRlCNLvtZYytI1Y2scLGVxyMuLA
	 Q7HY5yYrnoYb4L6gpIeFWvF5APaSUBv9Vig3bre8nb6VJfBTgdYrUp/8cg96MSXYBL
	 YZb2MbPl4y17XP+zhjdoNfax3le4qTyY8Uo4c0Nk5pLOWGF6eZElJyqTyaKLjOQ2TQ
	 W/J4qw5K1dJjg==
Message-ID: <d5cdcb88-c7ca-4a29-9b8e-3abb7c37726c@kernel.org>
Date: Wed, 1 Apr 2026 13:05:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Muchun Song <muchun.song@linux.dev>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
 Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, cgroups@vger.kernel.org
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: acfuupecdz4azqhdkk63esywyfpoubph
X-Rspamd-Queue-Id: DE5E018000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775041544-442186
X-HE-Meta: U2FsdGVkX1+G6E5ZS8Zj84L1xYxGpqHPxb3A5LExjPK05LwQj3kma/SYGGlOg7sqKwscrM23AMkPUqYPAsoVE3Xw9vJ0Opz5JKOn1bMbtcY1wKiZJz2PJOuNTDuG7Om6YuLELVm8AFpnTnIGje/+ZmrcKsXK08XpEIXuo0+zoUgsPnzae6XWBZ52riveiuKJ71UQHXaUa99w0o2NhcpKPUQYAOO8zw+QIXFzYBYATj3gdYJYzdPzPB0YkTIq1cneDspgJSxFyp9V4tbjkSuwhkoNZ34hgA3B68A0PxdQ4W8PhsdOBnWLHeaVq0aUDQgG4lJDKfL5zk7BCjLwwO8csG3UdE4lAqmOkS3rotQIH1KLoWb4XlsrIgd+Y5q3vderjQzYcT5TiNQxY0LQMX2GwBkv3vJRnlztJ+jsFVk6teaHio2h8U5zwBKwSFDp6Cg+z0USFYbSmTj/ydIwqXg8rodTSZf7KQTU7NeFpnTNYvjhf68peNA3arjYvdT/Tekp/l2i0tQhtYo1aVh4NyALp9whzKJuuEB3ms4Jho8EcZhgVckoupkCpDuFqSQ67NcWL7Wvfds1F75nuafOfqkBlQ5GvFNaVhFls6GwJmMbkGiikKAuOZhaGbvdtsJqr8SSi8KIK+J7mmBeWRKdg4lvp9n1eNyF2SDVEErGtq1G3N2wGzaHyMIk7wh3Q46qrNf+iIX+8sNolNoZRxh2eQllnz1kQ5NFL9BSp/b0XfW9q8IztdKEZ7FnuFgFAwtoV0VtFY6DLckraxBAosyj+wbsJaKL7vu0rT3lNSE2ICsQ8HX0S1GqaRBzleTHl7bxti+gfnHKZ/AU/6YAZCj8Q7aPJxff076bswkFVidgD3uAZo3+1CQflhC28CsTQEnZkkhDMq+Mo6dm27fFE52pr73J2Glsi1AP2hRc9e6HzJ4d4r95nHvHvwJkDz1T6FOUg0L3CkFDQwx0JIp4awPkiuR
 4AEfRKJr
 YSJL9JvcTLVa5VZ6AbOhLIPTC1GG5+eAYNHb6SZLnyrWIPeX9fUOFHuAzx5bi4O1RzXrM7DSJ3+RsPTxuRCHPE6ve46prpfIKV9QOM4PKRoJIBZqdFt/3WMe5ToLqULZ78kebrJQCbeJ0Jp1AzdPM0680WqEjVIkOUca/7oA4Cqw+beYipm6gZpMp2bp1078TVqUKEVLnrttYgk62Tu7XcXoyqlmcUxVunxf14eTvkk6duAEdVk4TO4LQRi0ukuOLQkEVO4Vn/3GOJEtPbi3FXVuOtOkwP4S8VgrYzIAokSAAgIpvKxamaofqVE1RW+XCs84fqJcnvbnxlIC204QcMbfu2ZgLG7OUVymdzOQNwbIM0OQniNRcRCOa1R4QHfMQXQvILRbXBWHcmrW2EVSwzZ+wYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 12:59, Vlastimil Babka (SUSE) wrote:
> The boot-time enabled per-cache debugging has served us well in the
> past, but it's time for it to go, for the following reasons.
> 
> - It's a debugging feature. However, thanks to the advent of LLM-based
>   reviews, we are not adding bugs to the kernel anymore, so it's
>   unnecessary now.

Right, and probably LLM review would find many of bugs in the existing
SLUB_DEBUG code.

> 
> - KASAN is more powerful anyway for the classes of bugs that SLUB_DEBUG
>   can catch. But I suspect KASAN is likely to be removed soon too, see
>   above.

Of course.

> 
> - SLAB never had no such dynamic debugging functionality. With the
>   introduction of sheaves percpu caching, we have turned SLUB back into
>   SLAB partially, so this just follows that direction.
> 
> - It's removing ~2500 lines of code and I want to keep my overal
>   diffstats negative. This adds a nice margin.

Personal stats clearly matter more than anything else.

> 
> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.
> 
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  lib/Kconfig.debug      |   12 -
>  lib/Kconfig.kasan      |    2 -
>  lib/tests/Makefile     |    1 -
>  lib/tests/slub_kunit.c |  329 --------
>  mm/Kconfig.debug       |   60 --
>  mm/dmapool.c           |    4 -
>  mm/memcontrol-v1.c     |   17 -
>  mm/mempool.c           |  105 ---
>  mm/slab.h              |   34 -
>  mm/slub.c              | 2074 +-----------------------------------------------

slab.h vs. slub.c is annoying.

Can you just rename that to sheaf.c / sheaf.h now while at it?

-- 
Cheers,

David

