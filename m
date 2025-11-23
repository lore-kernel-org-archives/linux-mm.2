Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7922FCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 20:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7426B002B; Sun, 23 Nov 2025 15:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7809D6B002C; Sun, 23 Nov 2025 15:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FBE6B002D; Sun, 23 Nov 2025 15:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 550A96B002B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:10:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9B65140128
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 20:10:08 +0000 (UTC)
X-FDA: 84142963296.12.F9FE750
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B77D4A0005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 20:10:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AzTXLzjb;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763928607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCNBLrjOr1foGs26XOE6a2gSNdqIv5bHIjwCsegLTIA=;
	b=tNC0pQv8SolMR0GakgTlDHQAKplRimIHgmHpIyzQfbZ9OkaMOnCqOmtHk9O7TGvwsxmzYW
	/m4oDoBBjlbAH577fSAo9RoKnCs734YAxHYpQ+Yrv74gimGuT8PAn0ei0FUdqRBw1hHovc
	xlii1/ZsdrF1HjnfQ9GwvGDfFkv2MiY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AzTXLzjb;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763928607; a=rsa-sha256;
	cv=none;
	b=KJBPNmMlglKmy1dJ4S+IRqhkLVbBqtzNIy1gzn10SunkubHeJw8cuwdm6XST+Lp2x/B9+z
	4lij24Xwp4FZheYQl7gnC0LX/0tP5XKQKV2rypoulW3cYvK9VJJexXKhdYw8B7l8nTNvt7
	7864O5PARS4MdndyjBj4ZoJv09qwbw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763928606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kCNBLrjOr1foGs26XOE6a2gSNdqIv5bHIjwCsegLTIA=;
	b=AzTXLzjbatT3fVpsVkpry2OJRiHaUJFfw0zNd6pedFFx6SgxVghvVnzhTHMhBnH1dGbuW5
	c6QDl3RH0hr9ON+im/aB3kQElrTGU3XaPO2hxmpv4V4QOs/yFfLe/Av8YA4zfNJvREmou2
	K59GfrBPbfYawPSOBVBMxBCB9QIfQUE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-hZe5QCUTOCOc5Rs5Q6zXug-1; Sun,
 23 Nov 2025 15:10:00 -0500
X-MC-Unique: hZe5QCUTOCOc5Rs5Q6zXug-1
X-Mimecast-MFC-AGG-ID: hZe5QCUTOCOc5Rs5Q6zXug_1763928599
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA10D195608A;
	Sun, 23 Nov 2025 20:09:58 +0000 (UTC)
Received: from fedora (unknown [10.45.224.57])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B7C091955F1B;
	Sun, 23 Nov 2025 20:09:56 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 23 Nov 2025 21:09:58 +0100 (CET)
Date: Sun, 23 Nov 2025 21:09:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] pid: only take pidmap_lock once on alloc
Message-ID: <aSNp-TDtv0ZoILJ3@redhat.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
 <20251123063054.3502938-4-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123063054.3502938-4-mjguzik@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B77D4A0005
X-Stat-Signature: ojqqzbsjff1mtawzz5f5manphiwecfuh
X-Rspam-User: 
X-HE-Tag: 1763928606-417467
X-HE-Meta: U2FsdGVkX1/9QmP16nhJUWZIIPezsrOf0rCOFetQhtKQ3OD2BMsPJUHi1UskRtVE1G8NEUNdCzYd+JVbpwqs2lA29eCpricu2E2bwjyCnsANVCLM1jhY85w+k/lCJwQqw9ZyrVTfK9A+m/umPoYJ3fS3y4g3y0oRUef3D4pgLouxWnwzBmpbdoTeK/bLPmHUuC0wnDgS1KhRsFHKUiEtTEXN0OUwfR8eYmAblBa82aHVf6exkHmwCBGjTL3H/khYMjVguOAz1FAP5AVuUkUN7I04lhHAg7ix0amCFv2fybCcdzJs9dINAHdbuQWgWvRdZSA73Rvi27QFiVF9011W+olMCBp6uNwyp0LOkhP2ZzcrPWVtHRd+zsqf2KDnFb8jHFnmNZrnDKZlVY+rGolYNvizzVvf38NLS+vbDBUoZrSPhu6fp+rdRaFIkijeMPSgotKQLm/LCcTGCujSXGo3FDHZO241b//J72OddksWsHNLo10YO77bL3YR2MCdtHOYNtCEtJOgizbWYGySsePxlPZ6XlGXdY1fj1UoxiE+cOxp5+QLHl43CRu+A4RcB8sImrChnppEwPd8xYmiz4j8EXOr7KzGieq1Vg5AH163xdWrcXiTZeTfaFM1CJc1A8acdU51JqT8gf3gxp7iliGC0PLbYLAXyysZVtWLqgD/1KDK2wCnaNgq68YvLe2yJGXUcniwNHzEbqLtDjV+p6ZWe+RI5uXJAheEW+0MP3+pXqpocwnYKowwnj3iHzfjDeWNflgNVZDzDQyBfOc7lVbh062rBf0U6Q34bfvblOu8HXXEII387VAN5nrQVR4CXfQ2GoXqmBDkC7pv26Kda9vbSkkgU4LCG8e4pJL4Vg1flqADzrnuHRllsY6rEYOQ+9XZ1wL69fWVl1w2rTvImTziyDEkT0Ax/CCdfUAkKpR01YzhQkX47krrm/rk3msa+tsB9etNOQlFHufxXZ8g9Jq
 cErkepAn
 juIkvRqzoJWaw7ZyqnF+Vk/B/K/ZPvX9HOdwkDCDQjT4ISBOWxHotvvbpK7v5uwOWGoA7CNsCqlPes6NnCyH01qkNTYDdZRKHAm/5NjxymV5Pxn+8Tra3WFQ3Q88vx7Rc7+rMFcdiy0NYC/137lAs5CgVbRw7bbg5iYvveu9tSSkz4eqM/wNopNHdCS/8F82VSkwGdTgNtOBeh2ib6ABnXY1djfH9GJX2oabMR2ipJW/57m2+aamQJipHb+A6hgzp7eDEMEZgcvmfBV76IB1sOresyjQFnmtxNeRlxepzmjZk0pq7Gzp9Fp76R0vJZfTaBW+OBo24bz0/OUJSVUvC8UcTsPaDSJd8dF7cj4IwLtRuXv7WF1V5M3Wt6xphRjvq62kNfW0oGzopUdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23, Mateusz Guzik wrote:
>
> This reduces contention on the lock during parallel clone/exit.
>
> It remains the primary bottleneck in such a case.
>
> While here tidy up the code.

Not sure I can review... But FWIW this patch looks good to me after the
very quick glance. I'll try to actually read it tomorrow.

But please find a couple of minor "can't resist" nits below.

> +	for (tmp = ns, i = ns->level; i >= 0; i--) {
> +		int tid = set_tid[ns->level - i];
>
>  		if (tid) {
>  			nr = idr_alloc(&tmp->idr, NULL, tid,
> @@ -235,10 +261,8 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
>  			 * a partially initialized PID (see below).
>  			 */
>  			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
> -					      pid_max, GFP_ATOMIC);
> +					      pid_max[ns->level - i], GFP_ATOMIC);
>  		}
> -		spin_unlock(&pidmap_lock);
> -		idr_preload_end();
>
>  		if (nr < 0) {
>  			retval = (nr == -ENOSPC) ? -EAGAIN : nr;

So. With or without this patch we have

	if (tid) {
		nr = idr_alloc(...);

		if (nr == -ENOSPC)
			nr = -EEXIST;
	} else {
		nr = idr_alloc_cyclic(...);
	}

	if (nr < 0) {
		retval = (nr == -ENOSPC) ? -EAGAIN : nr;
		goto out_free;
	}

and somehow this looks annoying to me... Perhaps it makes sense to make this
code more symmetric (and imo more readable) ?

	if (tid) {
		nr = idr_alloc(...);

		if (nr == -ENOSPC)
			nr = -EEXIST;
	} else {
		nr = idr_alloc_cyclic(...);

		if (nr == -ENOSPC)
			nr = -EAGAIN;
	}

	if (nr < 0)
		retval = nr;
		goto out_free;
	}

> -	idr_preload(GFP_KERNEL);
> -	spin_lock(&pidmap_lock);
> -	if (!(ns->pid_allocated & PIDNS_ADDING))
> -		goto out_unlock;
> +	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
> +		goto out_free;
>  	pidfs_add_pid(pid);
> -	for ( ; upid >= pid->numbers; --upid) {
> +	for (upid = pid->numbers + ns->level; upid >= pid->numbers; --upid) {
>  		/* Make the PID visible to find_pid_ns. */
>  		idr_replace(&upid->ns->idr, pid, upid->nr);
>  		upid->ns->pid_allocated++;

So.. unless I am totally confused the current code has another
idr_preload + idr_preload_end around pidfs_add_pid().

AFAICS, this makes no sense, and your patch removes it. But perhaps this
deserves a note in the changelog or even a separate patch?


And another stupid question... I don't understand fs/pidfs.c, but it looks
a bit strange to me that pidfs_add_pid() is called before the

	for (...)
		idr_replace(...);

loop. I don't see any problem, but to me it would look a bit better to do
pidfs_add_pid(pid) when this pid is fully initialized...

Oleg.


