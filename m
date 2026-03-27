Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE8510AB83B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD496B009E; Thu, 26 Mar 2026 21:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4370A6B009F; Thu, 26 Mar 2026 21:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325966B00A0; Thu, 26 Mar 2026 21:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 138146B009E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:11:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEBFF5DC76
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:11:48 +0000 (UTC)
X-FDA: 84590065896.15.E267B75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E148120007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:11:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sSeaQGEJ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774573907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SDYDAhWq3KmVTFRetPQVV7Ej6nw9k6kEweMHTiWM7k=;
	b=mkDZH4o3qpeTK2BBzKnEjKbEE2KTSqLD9xtWKc7vbAPsLJ7o2NDwh45OV0/Pj9Rh3ZBau0
	eYz09BXw1jXBbhKOz32UJmwwhuLIIi1CcERtpSi7kKGmrIFq7oJL6hS846bSNL/BoCaazV
	HWfGxOG7Yru4jKPu9sessKX9E/UlOgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774573907; a=rsa-sha256;
	cv=none;
	b=KOrGBTy+G0fKkjZYBjqMDPld2ipHEq6MZ0fLvqm1IFz77KzSayzRUHnwZYTOFNa+EM3Igg
	o0ki/8kUUdERTJwwhhp/80ccVhUgJbae18flyZg/kEJnOz7g/mpscJ5XiluKGIbceOV2Ps
	BDqJzyDFEhxpmV1ZrMTTuQjEMvmyEtY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sSeaQGEJ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA0C60054;
	Fri, 27 Mar 2026 01:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C7C116C6;
	Fri, 27 Mar 2026 01:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774573906;
	bh=Fe7KwUg/tq18as0rpB2EpsguFqezOlv+XwT4XQCuSCk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sSeaQGEJwkqd9JitOdQFLzky3an4qh0q0FMVSfd3D8kfehFwD5nIBDGu9/OFbqx/O
	 z7vPAdBc9SLY07B+kRL0FlRJ4DpTkUAewfokbv0WDffXY/pwcfgjm3iL0zQTmvHm7G
	 NCkD1v1tzZEdk7zXbZ3yFbfqNQff//o/960xXSxY=
Date: Thu, 26 Mar 2026 18:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated
 before page_ext initialization
Message-Id: <20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
In-Reply-To: <20260326140554.191996-1-hao.ge@linux.dev>
References: <20260326140554.191996-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E148120007
X-Stat-Signature: yhi8xfyzkdm3jy9e3c9xzqpb3sgor9os
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774573906-218691
X-HE-Meta: U2FsdGVkX18CwDESyBkSWzqBvCFizGWzogQBxHI0vrzDreyT+kehmLAzhsA2SQwIg/umvO0dQauu9RhpF33oeAoyrIO00SUC5iRdntLAJpFbDZiYWehX6ZKPEsgID8Kk3/CQt3gTzwlA0bByHPOqZZ4nrm+qp9wu4T7D0keBzASIfhZHxFkjaxUuX8nuigS65Q0R6pmIwhH6B0BYl+9wE5KQOIPf87P/KrAZMjwtckte6s6zVUFDdpM4HwzstLnaCu8bHkFzvkm5Io6AIqLydQm0xdKzKGA/mRce5t8r7sqAvMP+htvjv6FYcDdeabn5M8FEdGahBp0Pi3NOD+c5eIa0uUKVNK/2o/pxCFcwxeVcYcPBuWh75OHMvdQrKgLMutYFW3L2dAjt5VF4E9ptqosj6qB/R+DTvp8OJQWWVxf6UNxB2ZIMwVFQWJpNNjDVt3XmLWUQTUBqwK8S+AHJJWjUm4wK3a18tddXxYwksbKTB7qxumjvMaKg3s4GuVGjOzS+c5JfMmbU6pL5/mtaKYivA4SXd2ksrS2Lvb8OJAUpckH3GirKJQ04lzTftTuhM609qAX+vLBmOAn0Jui3ErthQr6PgcvsSHECUZj+DTmVrjmf4LpYoRjdn1iqs+2NVKXefNXAqOyz3SwvDJJ8iXwEz8cTF1lraL+7joEnAFIr5jsfxgEXBGd46RDjpCsVl2ygIA5NtSNzygL+wSlDiK42vkSLj5VGY++G26IbJZDczGAd9EA2AUmZfpH59YSgDEG5OUDWadXzIqHWjrtv9xaOzYjId7nt+DyoHGv0YfDedIBUOSkz3kNryBxthBvmQoMAvn9gfXPUELQRg1y6YRjwdryaoCn1BDDnKf6zD5TEVqHDKwYbCqAMOXrU+Et1sPl3dhtNRN4iEJr0vT3hlFhXeG3qWLaTnAspoh1ghSo0vUrHzeILIMftpHY6tETAI41fe0PVE+KKA3sm88k
 KcSxnL9v
 ZnjyLSegBha7tXdXpY/878ixADQ0e4w6G22b+FdcLOcJp6F86D6sQ5Ww5I9FNjMpuR290F6yuCOYmFBk8H8c/2Tc7GpXcznLoU1M/AoVtyB+zcXjyrBn34QCeK6WbebdjMNRGPuCvSmjWdkH3DpR423vsBCa0/pM4bKGHgao1F4RMQtv0BwhI6QafS5MWzILWJJheT2fAjJvI6wbtQzDSRxEhtsKkopNOegkLR2tcHNmzG3b4kGZkKt3FTyVpHfmxgka+gZIkUHIcJ1FDkZarE3dV+KAiPWTQHSoDqfbCUKxmNHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 22:05:54 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Due to initialization ordering, page_ext is allocated and initialized
> relatively late during boot. Some pages have already been allocated
> and freed before page_ext becomes available, leaving their codetag
> uninitialized.
> 
> A clear example is in init_section_page_ext(): alloc_page_ext() calls
> kmemleak_alloc(). If the slab cache has no free objects, it falls back
> to the buddy allocator to allocate memory. However, at this point page_ext
> is not yet fully initialized, so these newly allocated pages have no
> codetag set. These pages may later be reclaimed by KASAN, which causes
> the warning to trigger when they are freed because their codetag ref is
> still empty.
> 
> Use a global array to track pages allocated before page_ext is fully
> initialized. The array size is fixed at 8192 entries, and will emit
> a warning if this limit is exceeded. When page_ext initialization
> completes, set their codetag to empty to avoid warnings when they
> are freed later.
> 

Thanks.  I'll queue this for review and test.

But where will I queue it?

> 
> Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator")

A year ago, so a cc:stable might be needed.

> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG

otoh, it appears that the bug only hits with
CONFIG_MEM_ALLOC_PROFILING_DEBUG=y?  If so, I'll add that (important)
info to the changelog.

Do people use CONFIG_MEM_ALLOC_PROFILING_DEBUG much?  Is a backport
really needed?

Either way, it seems that this isn't a very urgent issue so I'm
inclined to add it to the 7.1-rc1 pile, perhaps with a cc:stable.

Please all share your thoughts with me, thanks.

