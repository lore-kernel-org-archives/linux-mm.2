Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C768FC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81DB6B0088; Mon, 14 Sep 2026 09:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34356B008C; Mon, 14 Sep 2026 09:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9212D6B0092; Mon, 14 Sep 2026 09:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 674A16B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:01:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F142340339
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:01:21 +0000 (UTC)
X-FDA: 85212378762.17.C903B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 150231A000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:01:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoH0+TMT;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789390880;
	b=sbzYPVlJ2gnKXf+jIbHjsL+VHcUzZhuHqIcCH1LHRWXodDS24847lhEVKFLDiIU+MfFn/t
	fTKaRCNmqzex0PQeCmRQHDarDy+6s9ZM9gcfSwblhE6iikaLwDK50ATuEYpZl9F688iILR
	dyr2uR43u2lcj8ayoivrqPpOuQXohSs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoH0+TMT;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789390880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTxOWHtdetJx/95rlR2nGzcvHcLHxMN8zOI12K/ZULk=;
	b=I4cbi9nzG8SeVQ94wiKb5T4gaRJWnH9wG1EWX5QM5+7EuiRLSBvHSjEgngSCjJyFQ+cIyJ
	JAyXwxzslx43YyDuEf2C5IkicmEMnaVuyjuQsGD+REPtCTclahbXZVH4tlTb+gwe4YkQG0
	Iwz5KVTVDmB6UrNZTBtuzNhapySL7ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68180408B4;
	Mon, 14 Sep 2026 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2441F000FF;
	Mon, 14 Sep 2026 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390878;
	bh=QTxOWHtdetJx/95rlR2nGzcvHcLHxMN8zOI12K/ZULk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UoH0+TMTNEwzjFFuk2dIioCyJLxtquA2GG8VP/0KQZAu/xDsiswfXkrSArd59wnjn
	 TKHhcGNsR4lopHSgoPpVKXS9tjs0G06ptEnqlPJEw01uFnOBPqlX/2rPT8Buy1m69O
	 fVDKjNlSujTyL4rLrSkYRVij5Z+788pMFE/g+ISnz4GuepRiAtpIqr4WVqgNEshtxQ
	 CxsLZaOn/PutiY9INH/H2Chwt9hLcr3zK5e7xm+S/WFaazHVLm/uHEei9wGzK+9RRQ
	 B6gPthda58OHkaMRWg6uHMTHnxbRJFb1FUQuJk+JOfP3vqFU76ut1sN3TUrMhLJy3k
	 NEs9sDj7BZkmA==
Message-ID: <b932c690-7ab0-4521-a7d2-5ed5130379b8@kernel.org>
Date: Mon, 14 Sep 2026 15:01:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: apply per-task GFP context in bulk
 allocator
Content-Language: en-US
To: Qiqi Liu <liuqiqi@kylinos.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260914080451.294896-1-liuqiqi@kylinos.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260914080451.294896-1-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 150231A000A
X-Stat-Signature: 64czsop9afmntrbxbbn74i5qjd1y87is
X-HE-Tag: 1789390879-973498
X-HE-Meta: U2FsdGVkX19m2crV+xU2gkuNqMPBYmKGX2ztUeA2Y7LU8UNA3dDqVfdLzUr8i0ZzCFzprFoGVd8yLt16NXcH0XBc8Ke4PspGjr0mQFedn7ybkMAWl9ndY7daeJXxz0TYieUMTwmuYb/h2HAwnvzOOWtfVyn1WNJIaatw8VXQxHN7+1OfYarInCxnd9bMz8MvZpS5BL5yPz5F1YHbEYPm4wn0w/g+TGNtcOktmQHZWmTonYakGD2p0h0cm/7m68jyYrwcxyqu5YY6KVdediYHimcGKat37NsFlgfEHPEdcHoUIu45afgcgv3MMO967hiLsEpC/vCITis3NMxZ/bHRWVC1jRXYDz5I+Pzs66nKLWyzPU0C9eeEGti5xvC9I5/CqUiiJ6jmP+23356dIdEEVgHud0DEYeHjqJ4cYLOS9Ng8cCqbZlKtqskbP4SIdjhbOQVQ7jh50U8lkcZfajpriI80UaxvFDYaYg5CnHCwZO22eILYfG7OP7vBhNAfQnrF6WhJ3v9fZIO2d4LTJa7wwn+wwD4B5HPfMsRSVXpAkZ/8SSExMUzjGjhXI3xd0lOkNyQOzQ1mnldpIOK7oEdzxEjBnR/zt8uDR+HFRqfvcWmAe5K7X0+3VzAcWx6MJD9cemAqC+x+FnhLLqEmlVkrBaILh38TzJLWedzhrsfq/4yvSo5FnLGjbkKvmWBRYph4dXmzE5nofZC6CqZQoNxN2aAD0QmIlxhVn0VDgYtDc5Fo+60BthVlV6RejU4VKgedgohiU7HZ4JzZI+AGDt8dAyY9FagIjaB4wTzyFU/3J6rGVR0f8cl5bTU4bbmIQhcPh3uBMQLPc+97CrfhhHRfi2q0u60r+3atxjRX/IkMUK+1QU8P0sbSkqzVLlo0thCqu8hfToxvOEQYXln6PdyI7NIgm1FXvzv532EfZzsVQHaVGaTP2MIV7dZVNffaBGr7Ru2wB9onC6W0m1RSM5V
 KanMN4/H
 Tyt1movOhm152pZQx3x5ck9OGL5wT7NvYWTbFGjYMWbwQ2nJ5mkXNbfRvdmTlwxlEv1kzvdUyjEyPLjU+ZpRafHmEig0hrsE6ksj/kPkLYGI89Uwz0iHkfMW7yop/pdyK6M6Y+NICvsxzvL4pAnhH7Zeh0BztVWFH8hnoAbBYrT9rD5XYawmPynf/RNmhYi3OQLu6gMR2ZOJPHLJCmBgGfgh0CWjZAc1UJihvMpQNiWS2B5QQHJ+hjAxlOeJrIIwanQV2Y916oBcI063U4dU6T8tX78xjqS8yGzBx2Dsxy9x7didyNnp5RMIGGzQGwa9SvUrExMQjpfF8Kq3cKoK9mVCgcaw+eXrwb84qtBDM8PwMz8aW+H8YjN7ny3kDIouYPJvfNeL+WqHZxy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 10:04, Qiqi Liu wrote:
> alloc_pages_bulk_noprof() does not call current_gfp_context(), so
> per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
> PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk fast
> path.
> 
> The most direct consequence is PF_MEMALLOC_PIN: without clearing

I'd say ignoring PF_MEMALLOC_NOFS/PF_MEMALLOC_NOIO also can have a direct
consequence?

Let's replace the line above with:

By ignoring PF_MEMALLOC_NOIO and PF_MEMALLOC_NOFS, the allocation can
theoretically result in a deadlock.

Ignoring PF_MEMALLOC_PIN also has consequences: without clearing ...

> __GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for
> the PCP list, and a task with PF_MEMALLOC_PIN set receives movable
> pages from the bulk allocator.  Once pinned, these pages can no
> longer be migrated but remain in MOVABLE pageblocks, violating the
> mobility contract.  This can increase fragmentation and interfere
> with compaction or contiguous-memory allocations, eventually
> surfacing as higher allocation latency or allocation failures under
> memory pressure.
> 
> Found via review of the bulk allocation tracepoint hooks [1].
> 
> [1] https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/
> Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>

LGTM.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..3be7288a1aa7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5207,6 +5207,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
>  	gfp &= gfp_allowed_mask;
> +	gfp = current_gfp_context(gfp);
>  	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
>  		goto out;
>  


