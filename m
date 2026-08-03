Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A1FC55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416E66B0088; Mon,  3 Aug 2026 02:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FE76B008A; Mon,  3 Aug 2026 02:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243FB6B0092; Mon,  3 Aug 2026 02:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB0826B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:34:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D5501605F9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:34:39 +0000 (UTC)
X-FDA: 85058994678.16.44201FE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88CAA4000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:34:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GmtggV4T;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785738877;
	b=MFMGQ5+HufwRSkUbpJptsUVba2v7Oa4VrV1LJZ5QisWniKDvF7SP/T4kHCfve5ZmUGZukJ
	Rh0krDu5oRpbNGnhDW5qJ+Jb0A3hU7UGRyhjotdISTyKfz+wIiqld3T8MpOFmLT5IZ7Huw
	2bpScanXKDI9bglji6rVDpATpz5qk9I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GmtggV4T;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F1oQGuofg8Bs6Kuu5rlugX4pqZD+nld29FuWkWFcM4=;
	b=e14uvxoo/B2OMKHhagxr/cOAXvAhtOaYZgseR+YzHUzIQxq8XecKQASgqgW+SVVqXaacNt
	Q7xaIhak/qfRr7Pluu4H3vjKcYNe5bib7jfeDwpTLEqK1M2+BojSPgJn2xjsP7TT9oGimX
	UbEXCSKsfxZefg2ObLbFr9Qk7vPoWrU=
Date: Mon, 3 Aug 2026 14:34:12 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785738875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8F1oQGuofg8Bs6Kuu5rlugX4pqZD+nld29FuWkWFcM4=;
	b=GmtggV4T/zXlj/aw4XfIWtjA0VjHzg9Bguf43nZfd67JDi8aylqNjnp+M2rYrdHuLBKKg9
	0wktZvSVsfALZo7igJ+ctBM3dA9lpELnSql0xS+X5fCxWslwSz4XkWHnEhp0lEGTXe5kcQ
	pnPpKwfJEFnGZ/7tdcsy1g55elkNP0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not warn on -ENOMEM from va_alloc()
Message-ID: <anA2ZInokBWZI5yK@MiWiFi-R3L-srv>
References: <20260802104627.63892-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802104627.63892-1-urezki@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: k8wahiy3joir8kqud5z98o7nhndr6wxd
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88CAA4000D
X-Rspam-User: 
X-HE-Tag: 1785738877-964976
X-HE-Meta: U2FsdGVkX1/V91MHnvA+rhgqCshzIDXD/BWi8zS3xmmLuLDwXARp1KuTcmHpkUWIsEzW9IkUDHtiNzWWB5xrnlb01jypZFVZkmVcui86rC40jdwH/JAyKLK4ubJ7RiC4h0ZRDkXJUX1lHtWmbAb+WA1Dp0gp2oXYdYIGTZplIQyryFrOx8kGQs1FrJkh+EBt+oIRPgqJhXjDoe0IGqOYYRlj6pLfi7tvMP7IWamYGBHkIJyFbjQucP/iaWvvGG5gHunh3ZC3XFcALWbyPq9QLf5tQqznc2OPPEzVh3eTKOAC7ih9+I1wTMwmXZjV/481QtQZXkPLfVdCsINFXjgMtyKnHmouPC/4LjqkyXF9HJd+soPNaJCdd+9deoYg6eboVer94fV1uaazLSFVBHKsSp5KxLQr1AIvKRlDt4pRXl5oL1l9M3rkOq7MLZAexWpanrBWPML5aBwUw2bFZsZV9FU4GkwoYLfG48ehfqORsyl+AOKGnZxZIWGBPN8QkhR1XiblnvsbnpBxxmJqpvpwm7SFWjFwHsLnNwcEmtcH4lpi/JBW/6VRrsdxfkKVIGEYpVNmRFtssmjUbv7x4J9gGZTiUrJ5e7eK4qor6vaIhIyLStiEz0CIt9owxrlQdF+mFXnSFpV91lOV7oSVZxuaLwZq6kjxaeAk4fiNR4TakICA71pKrZT65S33Z2qG/IrGq13nPJ6c71c34WelVkTar6Z29qDwlt1odnNigSO81vxpt2LeNTUVvhfoXFnqDvHHKY12zWr6q2Sib9/BZ3zR8nR6Q3CK1BspPpwdp4CqABT0WPzKP+Zjr15EVU6m40rmUeqxqX2DqUy0RXTerXF1wLIlhal+1o7I3fO6ZioGJFgVog7KyGKbNeKN3a/lq9DYj4vDIzuFojb0yzMrqWHdI8Op9sAAwuDzmCc6gqFlckW/DvVkUwxM1TsGGU6TMwAMYDVBj7hIi0CGu4ASp8b
 Va6xErYo
 DlPCZpSpjxvtMfV73UcQxrFrwh1nXjbwJ9d0UkGEIq2w2Zd3QITaohAFVvfSx+6JlrxD3rX5IyY0fGaOwk1t1vTrK7f2SY1GuOXCyljvJjvA7JlYburKdu0HilsQt2IfTyNBYFmEVkkCbrZHJPsFvTTdw9KMr/CEjdYzqOZ3faPJNjRMVMGJ7t2YbkP0vXh6IxGoUj5OzZ5YZt4+biPSwkmVs3maOt36oFyd4absfQ5XvH0N8kSb8oVD+iGOV+urgI429CZVbpRcBPU044oMIJuUci6SgVdKEoUsgofpZG9d/v9jTI4aa1O9bM2KCUeJpWJbsYQL+PBBo7DceGORbnwBE8UD/Evf7BqJRbbhdqKb2Lt1HL+tEEeI0wJMVSxzlqeqbws0H3JMMZOw/xJ8QzrxuU13HcL2dkA8d+u3tweOJspoBPfudaB3tBgPSkkbWfhZauZ/dIl7R+qGkdN/XeL32M6rCzYTLsYtovsgKaWP/Z5a1QYpVXnzemsd8oArpOVA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/02/26 at 12:46pm, Uladzislau Rezki (Sony) wrote:
> Since vmalloc() accepts non-blocking GFP flags, allocation
> requests may fail when callers pass restrictive GFP masks.
> 
> va_clip() may return -ENOMEM when its GFP_NOWAIT fallback
> allocation fails during NE_FIT_TYPE splitting. This is an
> expected failure, so va_alloc() should return the error
> without triggering a kernel splat.
> 
> Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..7a0cbba3d29d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1817,8 +1817,10 @@ va_alloc(struct vmap_area *va,
>  
>  	/* Update the free vmap_area. */
>  	ret = va_clip(root, head, va, nva_start_addr, size);
> -	if (WARN_ON_ONCE(ret))
> +	if (ret) {
> +		WARN_ON_ONCE(ret != -ENOMEM);
>  		return ret;
> +	}
>  
>  	return nva_start_addr;
>  }
> @@ -1891,12 +1893,9 @@ preload_this_cpu_lock(spinlock_t *lock, gfp_t gfp_mask, int node)
>  
>  	/*
>  	 * Preload this CPU with one extra vmap_area object. It is used
> -	 * when fit type of free area is NE_FIT_TYPE. It guarantees that
> -	 * a CPU that does an allocation is preloaded.
> -	 *
> -	 * We do it in non-atomic context, thus it allows us to use more
> -	 * permissive allocation masks to be more stable under low memory
> -	 * condition and high memory pressure.
> +	 * when fit type of free area is NE_FIT_TYPE. It is best effort
> +	 * pre-loading. If it fails va_clip() may return -ENOMEM from its
> +	 * GFP_NOWAIT fallback.
>  	 */
>  	if (!this_cpu_read(ne_fit_preload_node))
>  		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


