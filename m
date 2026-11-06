Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0434606D80D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LGvYi3hL
Received: by kanga.kvack.org (Postfix)
	id 1F0616B05B3; Fri,  6 Nov 2026 03:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7F56B05B4; Fri,  6 Nov 2026 03:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105396B05B5; Fri,  6 Nov 2026 03:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E55156B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:00:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CE351A0D4B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:00:42 +0000 (UTC)
X-FDA: 85403947524.13.8FA4723
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id F3B9B4000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:00:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LGvYi3hL;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793952040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSAmRJxA26lVa9d8ef5jJKzg0pl+9P3AFrDuUmlmVQM=;
	b=x/GxJL3HvlrxgD1U2MC9Ez0NdP0Ti2oCdIzzFSqb72jPIe6B4SanqbX6jmIjtDb3BnOABd
	Z3Ok/biVV9vUIBjDB3664lceYcl0loRtD3FcC0+GeMNEdTj9J3RsY+nugCBh0WaHXbF63d
	jm/J+CTXZRP21ywEWdmw0qdtsGbuebI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793952040;
	b=tOj0fZLed2wiv5d/uYY2tvD7lLxYH06bAawDQNTs92mZwnmyfD7eePrG0vfGh5uJR7D2sw
	0yBGfaFSwauKJywCWCp0sqFK82y5R4n7fkTeCe0fwNGaeKTVD2EHqE3kZjiiV0KMAvsbEx
	dEV+XiZEAZ9xD4RfBcttlsOp02VniZw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LGvYi3hL;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VW9Si2+KVl36tjewGW8VX2mt2qPP953x9tJRVdyvaNg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793952038; v=1; x=1794556838;
 b=LGvYi3hLOxsmHxvPgvYUsw4MpiOqhAN+N52L4SG7wkmr+5vonjfqNsyf757Zzt/7RyTGp9ap
 zgkFgZhB13sP21GFEICGj9K7w6VlmrLbz7VHv17xxR+hSRoiN77C9IBgZCQxb3YoHX/yniq/enK
 st4tK9a3Et1Lr0EihTqVJq78=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9a35c9af166ee30d;
	Fri, 06 Nov 2026 08:00:38 +0000
X-Mizu-Trace-ID: 9a35c9af166ee30d
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 16:00:31 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org, 
	urezki@gmail.com, paulmck@kernel.org, qiang.zhang@linux.dev, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <au2JBV_Y0DJVwVVD@fedora>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <auifTNDwbBTJeu81@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auifTNDwbBTJeu81@thinkstation>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ed6s4znh9y596zqgzxrh8ugk7t8wuofb
X-Rspamd-Queue-Id: F3B9B4000D
X-Rspam-User: 
X-HE-Tag: 1793952039-160961
X-HE-Meta: U2FsdGVkX19dArUQzs8TFyeOk9EfcvLyX4aPC2C2xrbojSUb+WlRWPVjMPV3p8tlsX906/f3Ntpce0jz+eQ1HAb5Nu7K/TKIDB5C+gWz+Ham9miIMAR+3e5dXYq4bWsAR6CnUc/VG6Fq+M/JjJVgZ63dbOVNd8dXPg2Bpjls1OejcJ8ULaceWW/1z+jFhADz3nPSMgiaozx998qQBuCuRmfMxKpQ6yzNeWY5KRV5loFzupkPkxKCy9Gzuv+IVJEPzXAryNYOZB23bFpD2ylQr6Lyt8bV5iEbCDUzfEZNxZ7v7/2i9En0HymcJX+OtglILkoxjAyfidUeP6+w+oJKacyRQ7yTqs30ILzNNC0UBGT1yoIutchkLlLaamvvyydfcHJpoK1ttvt7tx5W4j+aIFZu/wutNriQDj+pdxRb+mi1U/7Apvw06ZDTaf4rbKf46IGbbtpOMvJebRJiWk1gvSS/VqudLaxp0zEnErnpCMHytrhDajG8C1sr7l2+2YiTZfthF2VQsmcp0R7K5GPDYhebSUGC02Wkw+8xak7KbJS15apD0zCou7M76omQpPTqbTDnqrfidQRLkQUUQLgi/lAMVc1Wb7J7oUAMDgR6+3LmIaq7VfIk3OMsMC96e6htRwiqjZhg1gMXXke6BMsfHeQcu+2BulaYspuSppeLd7XiAyj1+XgBh1xxWvYE0P0wwVe6X8iZTANoC6Q9W2PbTrK5Pwvk+7kvfn9SARqhefCKSUuG7X/3IuwCgH3i6thu4jYQK7NESZIMQ3xkL3kta6dLV3npROUfzLJ6ssQna7sUUbkrfdOOhQsZo6oqRdad3cxsKG4qnQu4XVZT+Wkz9HKdU5DParYTXU9q8sj0XGWD7h/5wLTeq3mfVskY43x+kC/kl69H6fqMPJO4N+lXYrZv3Vnv47UivZ4MJDVeTngW5Dp1fwXAOSUodOFtoExUKrA+SedP7YJV8PVX1mp
 SN5jWCIV
 o7Lk6MvJlT6XbbKThhvVKLKNf6RpiKRyZVa3kzShYmEpkClKupPtp45wAmUloWgJvjbQoeacexh7hnimsaKiUr211OMxLSG1uPFWIpBEgCSbwi6YLJdEYzx5dEvsQy1pl1RBF/kaKArkza64Ud2ckybp+/a8ugFKzSXM23NHZNjXWgjgxjha9mqpkvwYGPgLHUzdq+IblkDMrFC7OGdQxZJrBzmEX0/n5wQyh8iBrJtpfwvEW8qm0tp4WKiXI9fNVEPysxeZ/e0gskPYhFt9c3pK2vMrYEf+eQSdXr3WO1G0WOjKORi6+7ae6EvTtTAjWcwBF1pOcbVXCHAtkVO81g9f217NDSvqgSKhtXsvFlJTGJY6gLR7jLUkNnvQx2nQdoWyvTJb3QWextqIm8CB7vVtA9JRASYQdPHRjGfZYnVFnjPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 02:35:40PM +0000, Harry Yoo wrote:
> Here I added bit more context and adjusted comment. End result:
> 
> mm/slab: don't queue the page cache work under krcp->lock
> 
> Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
> clean context") deferred page allocations to a workqueue. To avoid
> deadlocks with the scheduler, it used hrtimer to queue the work instead
> of queueing it directly.
> 
> Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
> pressure") later added a backoff mechanism under memory pressure, but
> did not consider that queue_delayed_work() with delay = 0 immediately
> queues the work and introduced the deadlock commit 56292e8609e3 tried to
> avoid.
> 
> run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> callers that may hold more, such as set_cpus_allowed_force() under
> pi_lock, so it kicks the refill work from an hrtimer. Under memory
> pressure it instead queues the work with a delay of
> rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> queues it at once, taking pool->lock under krcp->lock.
> 
> With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> pi_lock after a drop_caches makes lockdep report:
> 
>   Chain exists of:
>     &pool->lock --> &p->pi_lock --> krc.lock
> 
> Use the hrtimer when the delay is 0.
> 
> Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Link: https://patch.msgid.link/20261028134647.3176080-2-zhanxusheng1024@gmail.com
> [ harry@kernel.org: add more context to changelog and adjust comment ]
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
>  mm/slab_common.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

