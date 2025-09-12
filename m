Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F2BCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 19:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495EB6B0011; Fri, 12 Sep 2025 15:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BBD6B0029; Fri, 12 Sep 2025 15:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8636B00A4; Fri, 12 Sep 2025 15:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289AB6B0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:27:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C29C6140924
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:27:45 +0000 (UTC)
X-FDA: 83881582890.02.8359AF7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4526180007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:27:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o4c6cVOO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757705264; a=rsa-sha256;
	cv=none;
	b=XUYdh5X6RysLmfAy41URPPwoTYlbKZDZs/K0YbsloAZEee+k0QPmd8/8W7q8/90dpHmoPY
	91WizMzUbPVV2Vj06yDh/yoykw/B7fCmXYLGgSkghSAck+nuXt8gvr86SW6CqVA2f2+I+l
	bK5xGRC2ejU57H53g+P1jmH8KRWfsUA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o4c6cVOO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757705264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExXevDn+7ykaskoO7a8ZpNNYaKFfGSwxcpOAezuUCvI=;
	b=JDQk7238HSDZbFy3oYZExJaUZDcAT4IfatToXs93o0nxVRexdc5mGZaFxt+3SScZCnpgI0
	os9vqId44h+Z7Q8n+SI5jiysZyp2xKZ4eOkOa456ts4I0mHSTe3hCaV8h9KQ3gZyDHUwo5
	FS76hb+xyFudcd1WF/kjkmFJ9cd/G4s=
Date: Fri, 12 Sep 2025 12:27:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757705261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExXevDn+7ykaskoO7a8ZpNNYaKFfGSwxcpOAezuUCvI=;
	b=o4c6cVOO96AdX8Fjafc3zvAlboi73GPkU2UPTpPb0+c7R79fSvoO7fbF4tXTlRlgRso/9Q
	k/57cS6gIvTBhLNdSI5qr2BXMsK+OzcVrGYP6IiaYY4KtSlUEUsy7z/MQXuvq9ewQEGJQW
	MYP1JzIqQdKf5gT1ijxwjA4HnQHIers=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, 
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org, 
	rostedt@goodmis.org, hannes@cmpxchg.org, surenb@google.com, roman.gushchin@linux.dev
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4526180007
X-Stat-Signature: k3kboih6agfkn8ud8s6juid88eaetr86
X-Rspam-User: 
X-HE-Tag: 1757705263-724513
X-HE-Meta: U2FsdGVkX19G6Z5spAAjZYmQ1ICGVHCGjZ2lJQPlps5XYsM07o2N+6SnyEJmvqr7NAEtBM6H+6nyZaGwMdZziEgDOKpkAFA6LD0ObZOkTgKDWw0ItprjDvto8Xlohu6tRYAXdpSXpeIRlfPdHn6B0V5jk7X/V0/Qt4tLQLm80hgw/fwDElu2qnBhAQLip0g1Nd4xYShd0b0Kajvjp2wJaTEDzZu8fcr7lUZwS/RXxHTuimlWmHt5C5gBhtUeI37pZ8xnR+qnn9pYudlJd9u8JGz/PdkFz17cKXePeyVBLirCq1mdaHE1ck09Z1hrHLSRkGisg5AcH4BDxPaSFwCbFXLpcSm0SkYQ2AnsjpEZkIrVQiA2u0KOjFCyLsevj8rVgur+FVHZ5a+3pa7wrjxhQ8b6ZBhc6WgtB5fFAnjI8+Sr7hhNIenNvnHTysuingn7Eu8SMJwOqmRbnhythU35ZtdEsuZPLmoV5SqfRRC7FYCJfWYJN4aVtmNf4yRqn0nIV/ycLis09AUmtp2Sww9ZsfVCnX0IP9kKLfGL9bV10Mf41erR/U4Kte8YgGWBn4jcS/xRjQf7u6NCsZhflEVdy+FhQgMf7ifwAdjP38kvG+tlNTZvCqOMzD/sLSfSUXcXy5eSgZkHqK0i+jLv14TCHC3Uy7zvf1wpGc/7fOZb3amNiaCF04yCwOyMDZ9whfb3mtwqWF5KNMrWabMXrzVh/eO5u32DjUVLvaRPPJhvemkrZT1met3GoVbzAmgBfQwlvV//Ah4JCUlpzNKf+G55E/vuc7wAw9oIcDqjlq0FbBQJ44GweUpjbWv/UCNy4xykRoW04yKF9x+IWi9f8ue1CN1QVZCzaZMjSMUrf5t+34mZNM7g8KPEsx/hI71t/zXYoj96D0YfOTEBFzTWSjseq2AoLCjNDY0hDpDRK2+M5ivgS6O3yicthaqZEvpD8gVMyBB2DnylM7MphAiv2EU
 oRrXBMGE
 3MqUWTMhQSCo2D4M6ToSlTFXBKbpT1vScL6dV9bPqXKTJ8tf1yVc3JaEdjREvaT43zZWGzhYpg0Hd4aKUGsgm+GcE1zOSefSgwQnz3uD319hqc/2JqR6eed/u780NFhRzYF0zT1tvo6iXVYSNN119bYXNAQKaBDwDFWRAb8pd8T3rGK/KnJxN+/xsa7+1dX25o/MkZ5C3MppkWmo5L1d3Tqk3lIatWww99Xy92E2yYy5cDP3lJ4HkuC/tRlzTz+14Rv46v6wt/xL5TdaCHVWNrN02Zi/v5OOsmrR3CA4QbhgBrWO4e2sBxj3XRSz1Edq2RTm9VgkzCYO3BqyMsXVrj8XHDuKZbfip1Bbn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Suren, Roman

On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Since the combination of valid upper bits in slab->obj_exts with
> OBJEXTS_ALLOC_FAIL bit can never happen,
> use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> instead of (1ull << 2) to free up bit 2.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Are we low on bits that we need to do this or is this good to have
optimization but not required?

I do have some questions on the state of slab->obj_exts even before this
patch for Suren, Roman, Vlastimil and others:

Suppose we newly allocate struct slab for a SLAB_ACCOUNT cache and tried
to allocate obj_exts for it which failed. The kernel will set
OBJEXTS_ALLOC_FAIL in slab->obj_exts (Note that this can only be set for
new slab allocation and only for SLAB_ACCOUNT caches i.e. vec allocation
failure for memory profiling does not set this flag).

Now in the post alloc hook, either through memory profiling or through
memcg charging, we will try again to allocate the vec and before that we
will call slab_obj_exts() on the slab which has:

	unsigned long obj_exts = READ_ONCE(slab->obj_exts);

	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS), slab_page(slab));

It seems like the above VM_BUG_ON_PAGE() will trigger because obj_exts
will have OBJEXTS_ALLOC_FAIL but it should not, right? Or am I missing
something? After the following patch we will aliasing be MEMCG_DATA_OBJEXTS
and OBJEXTS_ALLOC_FAIL and will avoid this trigger though which also
seems unintended.

Next question: OBJEXTS_ALLOC_FAIL is for memory profiling and we never
set it when memcg is disabled and memory profiling is enabled or even
with both memcg and memory profiling are enabled but cache does not have
SLAB_ACCOUNT. This seems unintentional as well, right?

Also I think slab_obj_exts() needs to handle OBJEXTS_ALLOC_FAIL explicitly.


> ---
>  include/linux/memcontrol.h | 10 ++++++++--
>  mm/slub.c                  |  2 +-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 785173aa0739..d254c0b96d0d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -341,17 +341,23 @@ enum page_memcg_data_flags {
>  	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
>  };
>  
> +#define __OBJEXTS_ALLOC_FAIL	MEMCG_DATA_OBJEXTS
>  #define __FIRST_OBJEXT_FLAG	__NR_MEMCG_DATA_FLAGS
>  
>  #else /* CONFIG_MEMCG */
>  
> +#define __OBJEXTS_ALLOC_FAIL	(1UL << 0)
>  #define __FIRST_OBJEXT_FLAG	(1UL << 0)
>  
>  #endif /* CONFIG_MEMCG */
>  
>  enum objext_flags {
> -	/* slabobj_ext vector failed to allocate */
> -	OBJEXTS_ALLOC_FAIL = __FIRST_OBJEXT_FLAG,
> +	/*
> +	 * Use bit 0 with zero other bits to signal that slabobj_ext vector
> +	 * failed to allocate. The same bit 0 with valid upper bits means
> +	 * MEMCG_DATA_OBJEXTS.
> +	 */
> +	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
>  	/* the next bit after the last actual flag */
>  	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
>  };
> diff --git a/mm/slub.c b/mm/slub.c
> index 212161dc0f29..61841ba72120 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2051,7 +2051,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>  	 * objects with no tag reference. Mark all references in this
>  	 * vector as empty to avoid warnings later on.
>  	 */
> -	if (obj_exts & OBJEXTS_ALLOC_FAIL) {
> +	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
>  		unsigned int i;
>  
>  		for (i = 0; i < objects; i++)
> -- 
> 2.47.3
> 

