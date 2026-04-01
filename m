Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0320210F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA136B0089; Tue, 31 Mar 2026 22:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A18E6B008A; Tue, 31 Mar 2026 22:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE866B0092; Tue, 31 Mar 2026 22:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8986B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:38:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE97EB9C39
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:38:50 +0000 (UTC)
X-FDA: 84608429220.27.FD5A10E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1FFA380004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:38:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uj8tPH4E;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atriZJFr46Myib7CdkfsgoATvdJh0lyt6fPnkAWbosc=;
	b=lScpx2JnaQ3QHOBozjx/C9ZX+mHoaEoghvDiqGxI1re3YxSnqJcBmoFlRZK0UOHQZemxMA
	7kV/j2vucRUC1NukYGlN/O13tDiiChPsYVLRBmDKsaDPp4VCylC31GhyY7bNfH3k0g/Yy3
	ydByg0MpFw2ExK11Xm45Hh1odi2N2Po=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011129; a=rsa-sha256;
	cv=none;
	b=azzeiBzcOqvQ6TyNjF1M8c6y00GJwx6+OoQEo4GRtcw57Q+Txz9SCahZDmZd5Pe1BzCsXg
	aP7G4cUPioZkeyT8Pj7V3eqQx6Q8uHLT+utXOIdZvAAv9tDTho3HGiNG7cv8DRcxpjiRfb
	lM3bggCmUj+AnfGZVV1K1Q79XvEf/rA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uj8tPH4E;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D62E443A5B;
	Wed,  1 Apr 2026 02:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D806C19423;
	Wed,  1 Apr 2026 02:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775011127;
	bh=nUUu7l1xK87MHgb+obB6Qi0cxCVs6kWFc4Wh3VJ0FBA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Uj8tPH4EzbxuS+eMTIZZmhJq2UCqS9O02dswC4MgLakfc86HqCh4rSadfQhfNxs81
	 UiM6AP+jaxDML8d4U/O/y/vT47/ofQ2P5x5JkM5hCEd1YM684ENbBumvm5aXVNLP0N
	 ki1pr6CWdD4rFg9tdX77Xcqylgrx8Vwt9Qn5JWio=
Date: Tue, 31 Mar 2026 19:38:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/alloc_tag: clear codetag for pages allocated
 before page_ext initialization
Message-Id: <20260331193846.1822055eac7f8555fbb5ebdd@linux-foundation.org>
In-Reply-To: <20260331081312.123719-1-hao.ge@linux.dev>
References: <20260331081312.123719-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1FFA380004
X-Stat-Signature: 3mua5j1byapwshezdufq86cyo9pgf7bb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775011128-972249
X-HE-Meta: U2FsdGVkX18dX9CoppkH+zuOtIzhP7qTKrREEGCfw2MImsFxllCi+Qh8Shm4OAWj4UMBZ9fQ9r3MdhR9gg476RbRB5ACcZmXhH64MaHWF833SiOuSGv2NdD/aX7d6NSWBYX8RgDXs0h0eK7JXpq0aHpPKeikiDRihVuMKvNpQpjUWq00fe4R5VmDIK567OJWv6jgkix3UaA66nMLL8ZjchcnK9E7e5H68LBHxwYHAx++OVejWxDSduM2XYuwp890Wn/eMv8/WT4grkdIIOk/7trk43tiJBb0y5bOxf059KlH9iHgF8rHsG9/3JBPm5Mtuua5Z/GBnMTZlCw3YRF3owKaceqcqHvpQNvaEIQPCEC4VyGkR0mmtjcz1bQYQQKwT+XxHVt+qtgGa9Y4v/GpHTMhm6gIHxBmETcvMeSN5iBe6W7XbI7HzPRRwnHlyZaw7ypodpD0ZVeNYB2i3SAbCxwE4lEG/Be12ZjmlLtM+tY4FxQM5ukckTO0Hk258xXQCGFrKYIy6oE0zPXjRBOlh1RHl1LcD/j5EQ89ten9V4L4HJn+UHet9vlawDQUZrVM/FvO+G2dEKEgslxmLCnrXFvh0BJX5w+SlSBu/dkxRED+syAdXV59d9lZl6xIQv6XV/i5N44ydo3afqVFv9XIBeQCXOLCgbqUzEiKxhv5xM5wsxosiOufJ6sjQ+/YGWaS4ZSvzZS8HxqB26IZYHgj9DS+x1tvVNsAZ0LSvWkqAN7KdqtnqSvZWVkfaWYF/gLn+9kwU1uMt/ql9/sCuyN1TZakV7EAXgEdm1wv+c3hZ8baqcfiYhYALzEbNY0c5aZiNL5uSfSCnVETaoYxYLwsn4lYFjy7zWK1QwCZgj5j+muWkBKNJGQ9GRyxAfpyVd3X6J+59xuUNuHBQZj6HzkNC5JRW/rPv+QbixTjc1aXfe1zWRjehCpca6k9jBUKbfPtxRdb16AHjHWKWtAh/aQ
 rgOAt3OK
 zpqTY8KZTaqL7L/9Av8KfSmDqZVzZZxUwYSRwlA8VQdG8RTBlYez4lZhrYewpKM1swlqpNn5V8vOGxWKyaEScXZN+bHJG3QL18mITs5OxvyXgt3cUY89jq8KtDI3aBHwbsAto3yCCgjORFJEwYWW7a2p6vMcFmiXYRLq/m2jYrDwH5Q+rzNrYGnMD0rshMp8rSwwFvySsWfR+YsPoIGYjUbmoVcgyn1bS4ifediLgjQIA+7Gq0jd40/do4HRYEpwOXs51dD/aOLj6Bbz/ohGvenYr2mm7JyZnmiu2/Yk31+xONn6iBRw0xOu8s7xChU6Sw/x7oQit3+SNnuu7wwOLhEnRUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 16:13:12 +0800 Hao Ge <hao.ge@linux.dev> wrote:

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
> This warning is only observed with CONFIG_MEM_ALLOC_PROFILING_DEBUG=Y
> and mem_profiling_compressed disabled:
> 
> [    9.582133] ------------[ cut here ]------------
> [    9.582137] alloc_tag was not set
>
> ...
>

Thanks.

> v4: Fix sparse warnings by changing the typedef from a function pointer
>     type to a function type, and placing __rcu before the pointer
>     declarator. Use RCU_INITIALIZER() for static initialization.
>     Closes: https://lore.kernel.org/oe-kbuild-all/202603291211.YhY0R0se-lkp@intel.com/

fwiw, here's the delta relative to v3:


--- a/lib/alloc_tag.c~mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization-v4
+++ a/lib/alloc_tag.c
@@ -800,13 +800,13 @@ static void __init __alloc_tag_add_early
 	early_pfns[old_idx] = pfn;
 }
 
-typedef void (*alloc_tag_add_func)(unsigned long pfn);
-static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =
-		__alloc_tag_add_early_pfn;
+typedef void alloc_tag_add_func(unsigned long pfn);
+static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
+	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
 void alloc_tag_add_early_pfn(unsigned long pfn)
 {
-	alloc_tag_add_func alloc_tag_add;
+	alloc_tag_add_func *alloc_tag_add;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
_


