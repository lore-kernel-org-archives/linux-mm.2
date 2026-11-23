Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762EB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b8CCq/Qj
Received: by kanga.kvack.org (Postfix)
	id 955036B05B3; Mon, 23 Nov 2026 03:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C9E6B05B4; Mon, 23 Nov 2026 03:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B5B6B05B5; Mon, 23 Nov 2026 03:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8536B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:54:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E70D080667
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:54:26 +0000 (UTC)
X-FDA: 85465772532.28.E1084AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D44A6180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:54:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="b8CCq/Qj";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424065;
	b=4Py3I2lkTKoqfV18lmqa2zVL3Q+oV+A4UYPlVUZH3nGmDGW2n41hymBpUqF0mE6OWWptu8
	GPoloGWGbWzGQ7tyrlBI+q3GZ650/pS7CfAXsJhjb6cDZz/kQVl1hgZ6LVsyDmNB7w54/7
	kdYqs0GxjxTp/g/EPWTTCAe9cOQAEfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l2+EYB5IAhRg1PJ4Js44zono8mAKRvWJrn0noFOBos=;
	b=5KQtv9+EI7LVy+/gzkyfqbPdVgBYr191Hj8TvVCDudcaxjQvhYK9W/rvbhU9tWptgaLnUH
	P2qlu5bdV+EWoNxsAdO+31o3wgIIgNRC+JpYF1ShzbNs7yIHomlm6SnH5r9wjtmFPFar2K
	evDHt6mnuvb40s9WtuKxHbtCJ800wgI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="b8CCq/Qj";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABFAD175D;
	Mon, 23 Nov 2026 00:54:20 -0800 (PST)
Received: from [10.57.91.245] (unknown [10.57.91.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EDE83F882;
	Mon, 23 Nov 2026 00:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795424063; bh=ykI/c43VekHLh4s+DX69UMu73TIR/+eRfarVxHM0qgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b8CCq/QjFlgDBE/HQ51/le1Tvx6bIj3ok6U20/6tBMHepTzBZ0epejSL7lohPcGE5
	 TccmXxaTX1nOgvhWwz/yDQDmKLfY9hIOwx+ymd8SYuvACzj45XaT4fYDvGJ38LAJvQ
	 3Ws6uekPCDvBC0r165mQR+Op1SCVMfoJdRpjUC4I=
Message-ID: <d7dae0fd-a4bd-404b-954e-99236dfca560@arm.com>
Date: Mon, 23 Nov 2026 08:54:11 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Ian Rickards <ian.rickards@arm.com>,
 Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>,
 Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20261123033111.2349160-1-jeffxu@chromium.org>
 <20261123033111.2349160-2-jeffxu@chromium.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261123033111.2349160-2-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: usqsemt1he94e9sqdyoafk88rbor5ufs
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D44A6180003
X-HE-Tag: 1795424064-341865
X-HE-Meta: U2FsdGVkX1+yljcfKQLikFog6K5+AXq2h/3/eNKD/HOpQno6PTZcDNHV6OH6w37KUgQaQK5XqhsgTCWxzHxAcGb+UXDOOxPBmbXYQJTQGU/u2llcpRbea0/J0gVCTw/twhYy4yEwL19RRN+4JO0VjPhRd0VJNp4GAs/TjFLjejNG8s5Uc7XucZTFu3qctEafYID9Dg9Zco/b1Z54H04Lqi0XeZSYTx8JyZqDSzZ/b25aHC7YXZyAFcoeH6QOYLd350mlNuiEzGj+Ix83vIeHSGT4JzdJxIVzf2Yb2wlvZNd97x2fbeTXQVgE4lfzRw5+9J2H3BMnUMmiNPfBA/xW1uQ4/TInitwYvMeln0FzZwp8dyANDpfveZYpDo/rlsoc+ebJk6qLdf7OD12Am1B91dhFuIFO+bFPuGQd2gFJehJ7cxhtkbEKFFVRtUrO2VQSxIRgL8gAXHxMhhLdA8s71+vzpHoSqClNiO/qbNv7fydQvxQzRqxHGED+pWwHWEIjdrrrZ6aQsHcDSkJrcAPpa9/eGpuX4RSIp5Agx13OdjiaqnPap904yVMy7Y80w7uYweKTA9DXU/nbr8ejknb3vqeCUkJgGNUIl1tHTxhBg0JVDo+3CXAunJaziH3LykTVFD8Kp2NFc9rkTZ+2nd69UkFdIEJHhg3IGJaXOOBDLIIEUWukeUiP/1QXSFzuGLTrQVI5Ol87znJd7LTaX5kOamuZxxeiwq8p6f7qnaHULFwjpgMv8Zaf7rLhNAPwps9W6nJt6cO5EiZVCOpgLSZtWq0JtRUg4ap64OCRV1SEkmjb6vPmkTQhIb+B71sZuFZXKTOxl1cXU5iwpoL0zmwPy54c7z/IWhe7ZxK8ilbf+blJlvf3IogPsa8pLAeNwt0tZwORn8/oRCN85WekzmEsnockGeRUsJtAW329VFMX1UKapKRXD/kUZIsACAn46OD6jnWgKydVeiZbISvGmhE
 nI8jakzr
 H+Xatk3KkifW4C/f8YPvK3VyWgkS0NWhKXcBrmeeJ9i3H0ZpMf/co0NXZvULjiyKsrdCtoMRdkCx3ydvWlSdyo+VQe2YI85Pk7cyDsVXy4lgJbBHzMW0R8olSLz3aWn7k8Po0jbcD8MZrSEWvb6G5MQ1rGnVJFMzDCk1KdKOiU6gkBmIhb6HLV6NlzlQv3e6Mu7IzU71d0WtPma/i+Ae0J9kZ1MqycTNtHln3wET5vHid7UqiTG8SrGe1FcD27MbLq5Ei4gx3hIKKn6ue/j+L0vPRBVnoS6yaF//Z6E2nad7opYs9ZQ+t8nmwJP5HF/oIOcVXhVT6MeTl1rOKk/mnKY5E6fL/jdECtczce0QQ9JeaikK8Z+6jmUzBdgPLLSQUMt5CcDtdBEHuG3Cp9TcB4nzxmXPURP6deIueg1hGIuca2tS3S9N4zQMNGTXPjd3rqjBQ/gk+FYFLqCL26umVOmryXhrqaYnN0xJvQs3d/MI2CaxoJQ4D9msLMShDyd9AMIQUiRT1c2Ll0dKBsVBtNvsRhwUzOCnpHnLymDloGzB80SCLDRsD67OKVRKEmhNcTGfw07/SwVw/Ha5Uahp0w518MYUexJZHX2xrppQ+zYGcZW3PEtcyjnegaO7mw7cpzsg+r/blID/jx4CqkpWU87X3R/koXWBv3k+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 23/11/2026 03:31, Jeff Xu wrote:
> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so
> non-movable userspace page allocations also skip KASAN tagging on
> allocation and poisoning on free under CONFIG_KASAN_HW_TAGS.
> 
> GFP_HIGHUSER_MOVABLE already skips KASAN because user pages do not hold
> kernel data structures and tagging every 16-byte MTE granule on
> allocation and free is expensive. GFP_HIGHUSER has the same contract and
> differs only in being non-movable, used mainly by DMA-BUF, DRM/GPU
> buffers, and non-movable HugeTLB.
> 
> On an Armv9.2-A device (6.12 kernel, kasan.mode=sync), this reduces
> 32 MB /dev/dma_heap/system alloc+free latency by ~80% (~59% alloc, ~98%
> close) and improves an app-loading OpenGL benchmark by 15-23%.
> 
> Callers that access GFP_HIGHUSER pages through kmap_local_page() or
> page_address() (such as ramfs, pipe/FUSE buffers, kexec, and RDS) lose
> HW_TAGS checking on those pages. None of them store kernel structs
> there; this matches the trade-off already made for GFP_HIGHUSER_MOVABLE.
> Generic and SW_TAGS KASAN are unaffected.
> 
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

LGTM; I agree with your assessment of the risk.

We have seen poisoning pages at free-time being a performance bottleneck because
the tags are kept inline with data in the cache, and setting the tags therefore
causes hot data to be evicted to bring in the cold data just to set the tags. We
had been experimenting with the concept of "elide poison on free" for "in-kernel
MTE enabled in production" use cases to solve this. But the security analysis is
a bit complex.

I anticipate that your change is probably solving most of the same performance
cost in a much more straightforward manner. I'm guessing these DMA/DRM/GPU
buffers are the largest in-kernel memory allocators for the Android app start
use case.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/linux/gfp_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index c1331bf0b239..bb54c7abfb02 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -376,8 +376,8 @@ enum {
>  #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
>  #define GFP_DMA		__GFP_DMA
>  #define GFP_DMA32	__GFP_DMA32
> -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>  #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
>  			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
>  #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
> 
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859


