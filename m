Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD3B606A330
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XMmkvF29
Received: by kanga.kvack.org (Postfix)
	id 939976B05B3; Mon, 26 Oct 2026 12:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912A46B05B6; Mon, 26 Oct 2026 12:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827346B05B7; Mon, 26 Oct 2026 12:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 655FA6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:04:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00D904079D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:04:24 +0000 (UTC)
X-FDA: 85365249690.13.6FFD46F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3589610000F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:04:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMmkvF29;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOLHKlto0pXJF6loPpjpa0OycjxvrBLzXBWdK09FWNI=;
	b=OhSwpQTGxBiuQNRhhXEjyxEpyKJnB3VZD4LlikQ2zNxS73/wU9S8kEjhsJwTH0UHQf0jxA
	vspZ4EmOXlo3r0UImFCUlo0oskzJA6n71hzI3WOcrVVbUnJ8vUuTeI+SuomAbeqp3bSUh4
	0QYVbBKVnZYj3yNkvGUa911ZQ1GBsTw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMmkvF29;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030663;
	b=4BqlJMXmrCK0P5uMeVy/xAIYx+bnqdRMVJKXP61s6r3LxukPVTynyeKeLOBRELNiDnvxTI
	ul0wug3VLcURG92xSNql0rHKGJHkDxe+7Bd1CfLy1NC+yfn/wiPz5mA5uTsibaYS0ZnqO8
	jEOdqQV4P2JY6wMY5Zpl+MAdL64ShzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A39D3601FE;
	Mon, 26 Oct 2026 16:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E541F01828;
	Mon, 26 Oct 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793030662;
	bh=ZOLHKlto0pXJF6loPpjpa0OycjxvrBLzXBWdK09FWNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XMmkvF293u0Pe0kiXpCN0KSKP9el8rfDin08+YvXxK9dubjg35ZPnvU5agpBBaYTE
	 /ncryhCA7ppNhpCL8zjTuawEGahS+R6IVuTFWuua/vS3zNAjzPvhwyr7P5Y5Al9iQZ
	 4zTfx7NlZyvVeCNpgvhpcLInRQFtHN2zQZuC4Jgw=
Date: Mon, 26 Oct 2026 09:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <baoquan.he@linux.dev>, LKML
 <linux-kernel@vger.kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Message-Id: <20261026090421.e4bd83f3e20fb82852abec4e@linux-foundation.org>
In-Reply-To: <20261026102503.30860-1-urezki@gmail.com>
References: <20261026102503.30860-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3589610000F
X-Stat-Signature: z5ek5ux58x15mktyaqseji98sepdhcx9
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793030663-391610
X-HE-Meta: U2FsdGVkX19y38uRWdQL3BpEjDPjF0FkVyC1XMRowlOSvjLEUZ9XR0Fq9TdnNss+b3YhZkvhcHvtsp2F4OS3WVu0qbOgwu/8l4z2aofEQSps7mxBXMuEBa1fdQhxOabmkGs8X9a3JSq2jz7YwO0eh1vTNKhB7LL7n3yWakSYbSHLxFQ3z7Bs4+3WcO1OIphQXO6R4+XATWjPfw0LT1oiElBvuFzZS9SupPD23lZ1pizmOsvOEQztNfYHhsZd1dXuC/fQHoakBlfj1SOj3KxXme29IkmuTfEEJYySCURaRfjTNqvOyYCAYbgje7ISr2PJLO9AsiR+YCZZmTnIklQQcIK+4FvWX3Mcgh+yU0ppsx8mQyIZSBbFTPopDAfzglfrBdww+loPY1Yv5usF5aste1rxQz4+UnciFGut5yoLKy2gvXGsF7aazbjSZCdhkmBsTVzAuzl2yMwz4VDnQZSKoSHHzGXMu1YO+Rdw1pdSG1bJa1hHYCucg3eX+tPEhrNgpgNHAw2uEQV5rTGP7aBVrbjMwqa86hfhbDRrM8Q57a8jUbfm5Xh9yA7cSmrLR55mGZZ0gXjmFA4IC9BFfeOG1R9ItApuFYaoCtQq7l1o/Ug1laLU2ZBQLlPtvSWAKmWflEHtgDPRMzTU82pbtNAqWxO9OZQL/Yz9le2RwY6n8+lZysr52fBlT07zDAQOdCVZOP4u7k1H4zMlovnt9t1ImkGB63bAq3OL/cXKo0fzAkgXsrC1nmirlC5UNuG/9OF/8ziQkKYqm6dKKToBX0mLM1JU43MX0Z0WjssNT7cqV4b77J4gW2xoJFYMYZ9QVwOEzWhzq/PS7A1bMjAKt8o9KMko0aNO5VmbjTxWItqIChei92qQAE+omVLzPHYdXw3VZQvsSB5RRZVb+wBHG68nxfv9nJGx6nLtHsQqGZmSZnq+Zf0o8m1i/YAI1kb/PP84uD6bk75wBsJF3sqYAe9
 Al+B97iG
 5/T/apL5t+6EmUAfG7kuUk17otQqE6U32MHVOJ8O8AUZCn9441We8wIgPszoLSOd7FU/9IZvmz8AvQQFPpyIslNKNrLd/7bW9DdJV+0gSjF4SpVCr99nbudV6jjlhlAHabBeGLyY66E6VZ2Z1CW+cIoflm6VjbCXOWwzpHVaecufPl8ugf/sLkXT4RRSXhs9N8KQTg7ua2d+zoed4Z9MQsU7rasaq6nB7I66Nbt7aoYdZTDV8/+8jC6LYyJAzLDnmaJhNa1w8SCYqZHXbiHJf8I9Qv93emfsJLV7/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 11:25:03 +0100 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> vmalloc() is not allowed to be invoked from the NMI,
> hard-irq and softirq contexts because doing so may
> deadlock on internal locks.
> 
> Commit 04aa71da5f35 ("mm/vmalloc: do not trigger BUG()
> on BH disabled context") replaced the deprecated in_interrupt()
> macro with explicit in_nmi() and in_hardirq() checks, but
> unintentionally dropped the softirq context check.
> 
> Example:
> 
> <snip>
> vzalloc() in a task
>  spin_lock(&vn->busy.lock)
>   <------ Hard irq
>    irq_exit()
>     process softirq on the same CPU
>      vmalloc()
>       spin_lock(&vn->busy.lock)
>        spins forever
> <snip>
> 
> Restore the check by checking the caller's context with
> the in_serving_softirq() helper. Note that, it is still
> allowed to invoke vmalloc() with disabled bottom halves.
> 
> Replace BUG_ON() with WARN_ON_ONCE() for in_nmi() and
> in_hardirq() case.
> 
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled context")

Sounds like a cc:stable is needed?

> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7521b9b3bfd2..36e6e3be6ba4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3252,7 +3252,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>  	struct vm_struct *area;
>  	unsigned long requested_size = size;
>  
> -	BUG_ON(in_nmi() || in_hardirq());
> +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> +	if (in_serving_softirq())
> +		return NULL;
> +
> +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> +		return NULL;

WARN does a lot of stuff and I rather doubt that it's all nmi-safe.  I
don't think this matters much - it'll probably work out and as long as
*something* gets printed, it did its job.

>  	size = ALIGN(size, 1ul << shift);
>  	if (unlikely(!size))
>  		return NULL;
> -- 
> 2.47.3

