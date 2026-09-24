Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CBEC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C356B0088; Thu, 24 Sep 2026 10:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EE36B008A; Thu, 24 Sep 2026 10:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930576B008C; Thu, 24 Sep 2026 10:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61DB46B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:48:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E645A1C280B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:46 +0000 (UTC)
X-FDA: 85248937452.01.5CB2ADA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4DFF880008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZSBkP/4L";
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790261325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Jt4EEpI7zfY01he2CxmwKfXEUhv3Y/sSQk7vJfi7HA=;
	b=F/qnCL41WIFVeFV9x22cDoqsN2wlsKmjUlZO9YhoOURcqeu/eU6ykv4nuuTyueh5TZMrMj
	wu+yf9y3PHQoQOkC3+KP6Tli6LMwzT0xL9TYSzbtgxYmPqf+VD//3G+bLfYxzvLtR9wW0I
	Msiv3hjZrnisG9suijWz2ErElJTxONg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZSBkP/4L";
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790261325;
	b=idKhwMmGRe4kWMFFVnyfZ6ss5Hr3wRXkvIm9DIFSsdPCwMOLzgoebEMZRKDBvsbErZCRE/
	luG59AGSKKH2ZPFU0v5NJUAElnlko6QZ2CG1iZ+KxBdmHiT85WzHf8XKcYKIUu+1qdOfJ3
	tX3QiyGB1/uAsWJdT2WJMBmbVbPcMrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D41CA601DE;
	Thu, 24 Sep 2026 14:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1897F1F000FF;
	Thu, 24 Sep 2026 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790261323;
	bh=3Jt4EEpI7zfY01he2CxmwKfXEUhv3Y/sSQk7vJfi7HA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZSBkP/4LvrZ78metoR/UbWOjYRCWgY14tvosTodt4mMPTUUi0UKQ0Xbh/m82yIw9n
	 /Nj6LJjb09A2xPuccqoLkxMyn9qkxZkdQzc6J8lsX1TbL69bHNDWXEO4W8yCoEjSC+
	 lXcvukPxCjIx8iVBWZPIMhyWVjYS2FsJDunqIZJHCB904P5dXatE60a65R3EJXM/PK
	 JvAWJU3Z+xFXnJ0xsPKd2nQBXuBe4G1bxi/H1zdyfF456T+mU1yBRaUwkNYL6NBujn
	 RYATiQu0zXhtiCaToJapXCXZdMTcnyWdeHnyH4Vqq5URr0M/XD8Fs3/0FicNNdGCXk
	 16sZVqZWwQSOA==
Date: Thu, 24 Sep 2026 15:48:41 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
	Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH RFC 2/8] mm, slab: introduce slab_debug=N
Message-ID: <arUx56ee_nkxYP_f@thinkstation>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
 <20260923-slub_tiny_rework-v1-2-a0e66d536eb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-slub_tiny_rework-v1-2-a0e66d536eb5@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4DFF880008
X-Rspam-User: 
X-Stat-Signature: yxzx9psxtyhfij3t19633aayx55r9jj9
X-HE-Tag: 1790261325-245561
X-HE-Meta: U2FsdGVkX19i5DzwlUnjeoPDhu8+eZ1i5iWx0vwSAhCO/jbsHmzUhpZK49DIYYkZFt06PDii/0ajy80atdpUOq/n9Up7ARHU7lOs4VaB941a5fqJq1ekVo1aLCrUssVPIw6ELGOshYZBw8bJUYE/hfRZ1ynbY10Y6q9eWjb1mE7pRkxH2a2wlV1yXKo/xLxacVB1hfZmpLE4fQ1cy2AYF95zTV3rqCXShiKQSR+5Pgc4QSvdkvVbV1KW2G3IZx+pShkrR/7qSmtYZNy7M5CqkFwzI7IRW/lMzncFPVdQh8F1Bc0N93jHhgTwpgtb78wG7Qb4YDysMrN/ZaXxCLByTvxxWfJX7n7ol4Rd4hS2NVja1LqrzDOhG75fmMOBbeXN+HJ/eyj/MmcaeWtGDJMsBXBqc03J4Py8mszIb0Gl7KX3/o4pStN6niNyR/A9ZlaS0qPSINJYILTuf8p6CJxi2GhsNL9mtTXrerkzLqtKwtKsrA3ke6m83LRSjrWADfLgRqjqIb1b9VND7EHhHcMm6YgoxryAXK03hJ/FPsADUV2ZDhQmgQx7AWpZLG6eNwoi4b+iaPFNbmEeQh0xxVGEK2BA5Gzn6lzHz6AHQEb3oUfP813CP3+p5Fpm8TZU2Y3dq/syXR4NkYkrrxQ5kQonl3QUNT6hK0yWo+JnWOdVuMjzNDZtLdCh0E/eEz4yXtJsSXmR8D7IdQa/8mKCZquUai81GdS5kzutR1CE8YPyJoJ/9Lew0dhcH0oLQsUNJfesVyn9um5kEyQ0fAQy4YqZqpsjR1QuSuSQo0t5EeEmo75chH92CzOtMciXXvUxDy0pFV0gYt8PRo2+I0r2isK5/iS2EqX7w8dQoZPtMhB/JIXndJ9UL4Bd2x+MrRAHtBHiQXfBgRy5lzmRlbcYE5ZDAczJvjG12X8stnUF7JyPhSKrkpjOeGvajGr92DneQbkUlxTB6wEYfNrK4fMPxoZ
 N3RT8QgT
 UlzQExwZ2JqcgKcPXwqhqGjQE5q4nhzkq4cFLYNjic2B+KgoKHeCKlLX7ED5Q8Im8XFrLoLB5KfrXhcuj9v3Ix3lWzir0nU2UM8FvsmvnF2D4Zt+hIzP6Nq2lYjpb2HCm9aHBTyBXTecEMdIZYbPvpGVo+SNDFdtlWZiKZ0PD4o1hwJvpxlUoPD5z5SHdTOJf0Mc/FzYJ9OHNaH301RV41R/hx9X2QqihlBO7Snc0U/xF7yuDaVAc2HoWIMOAYgLRtHfjAU9lmwBUITD1I14hgZzApgdZ0ICYly63cWsGhPh7levCFUntDlJHYwIE6wGhbwAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:45:07PM +0200, Vlastimil Babka (SUSE) wrote:
> Enabling slab_debug has the side-effect of disabling all percpu caching
> of objects (now via sheaves), which can be sometimes useful for saving
> memory for e.g. kdump kernels. To make this possible without the
> overhead (CPU or memory) of actual debugging options such as poisoning,
> introduce a No-op debug option that only forces the debugging slow paths
> and zero sheaf capacity.

Just to clarify, the intended behavior of slab_debug=- still
does not change, right? (the name "No-op" could be confusing here I
guess)

And My LLM flagged an issue here (that I reviewed)

Implementing it as debug flag has a few side effects:

  - pointer hashing will be disabled unless hash_pointers=always is
    specified. [+Cc: Kees]

  - Disable slab merging. Since this does not affect object metadata
    layout, this could be excluded.

-- 
Cheers,
Harry / Hyeonggon

> This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
> option.
> 
> While documenting the new N option, remove obsolete SLAB references from
> the F option description.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/admin-guide/mm/slab.rst | 13 +++++++++++--
>  include/linux/slab.h                  |  5 ++++-
>  mm/slab.h                             |  2 +-
>  mm/slub.c                             |  3 +++
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
> index 14429ab90611..0beeae71d472 100644
> --- a/Documentation/admin-guide/mm/slab.rst
> +++ b/Documentation/admin-guide/mm/slab.rst
> @@ -45,12 +45,12 @@ of the first "select slabs" blocks that matches the slab's name are applied.
>  
>  Possible debug options are::
>  
> -	F		Sanity checks on (enables SLAB_DEBUG_CONSISTENCY_CHECKS
> -			Sorry SLAB legacy issues)
> +	F		Sanity (slab consistency) checks on alloc and free
>  	Z		Red zoning
>  	P		Poisoning (object and padding)
>  	U		User tracking (free and alloc)
>  	T		Trace (please only use on single slabs)
> +	N		No-op (force debugging slowpaths without any checks)
>  	A		Enable failslab filter mark for the cache
>  	O		Switch debugging off for caches that would have
>  			caused higher minimum slab orders
> @@ -85,6 +85,15 @@ in low memory situations or if there's high fragmentation of memory.  To
>  
>  	slab_debug=O
>  
> +The No-op option can be useful to minimize slab memory overhead by forcing slab
> +debugging slowpaths, which disables percpu object caching. This reduces SMP
> +scalability significantly, but does not impose the extra cpu or memory overhead
> +of debugging options that actually perform checks. This can be useful for e.g.
> +kdump kernels where scalability is not a concern, but memory has to be
> +pre-reserved from the production kernel. So for a kdump kernel you can use::
> +
> +	slab_debug=N
> +
>  You can apply different options to different list of slab names, using blocks
>  of options. This will enable red zoning for dentry and user tracking for
>  kmalloc. All other slabs will not get any debugging enabled::
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index cda126def67a..ed949e8522be 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -35,6 +35,7 @@ enum _slab_flag_bits {
>  	_SLAB_PANIC,
>  	_SLAB_TYPESAFE_BY_RCU,
>  	_SLAB_TRACE,
> +	_SLAB_DEBUG_NOOP,
>  #ifdef CONFIG_DEBUG_OBJECTS
>  	_SLAB_DEBUG_OBJECTS,
>  #endif
> @@ -166,8 +167,10 @@ enum _slab_flag_bits {
>   * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
>   */
>  #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
> -/* Trace allocations and frees */
> +/* DEBUG: Trace allocations and frees */
>  #define SLAB_TRACE		__SLAB_FLAG_BIT(_SLAB_TRACE)
> +/* DEBUG: Force the debug slowpaths without actually doing anything */
> +#define SLAB_DEBUG_NOOP		__SLAB_FLAG_BIT(_SLAB_DEBUG_NOOP)
>  
>  /* Flag to prevent checks on free */
>  #ifdef CONFIG_DEBUG_OBJECTS
> diff --git a/mm/slab.h b/mm/slab.h
> index 8fd6835e4235..77fcbf99b7b4 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -490,7 +490,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>  			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
>  
>  #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> -			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
> +			  SLAB_TRACE | SLAB_DEBUG_NOOP | SLAB_CONSISTENCY_CHECKS)
>  
>  #define SLAB_FLAGS_PERMITTED (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS)
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index a107a111c75e..bc593f0078c0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1897,6 +1897,9 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
>  		case 't':
>  			*flags |= SLAB_TRACE;
>  			break;
> +		case 'n':
> +			*flags |= SLAB_DEBUG_NOOP;
> +			break;
>  		case 'a':
>  			*flags |= SLAB_FAILSLAB;
>  			break;
> 
> -- 
> 2.55.0


