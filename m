Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4254606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFZKfKQl
Received: by kanga.kvack.org (Postfix)
	id E7DBB6B00EF; Wed, 18 Nov 2026 11:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06F76B05B1; Wed, 18 Nov 2026 11:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE846B05B3; Wed, 18 Nov 2026 11:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D06D6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:58:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30C2D407D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:58:31 +0000 (UTC)
X-FDA: 85448848422.20.351E461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6CA0120009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:58:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFZKfKQl;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSwhsJSNjnAtKDkFULTFwFmDhe+Yv9c61DRAS88DMuI=;
	b=tdGqJMIgLXzh1lliN1fWMD0CjC1+HL3pDUBJUNHjMjoCViDZgL1Zqamu3EyORkE3GPnvQZ
	80dr0aEiMWN+3wtdfDY5ForzG3Jj7UGrD6LyEV1XIeR0dG2kKk753SLH5+q22mL7zed82g
	ReSfUJ4qSoxaOdyPfvP5RqFRWc52FLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021109;
	b=C4CAUqKdohEtDWTWjTnoNjOosFtqQVyI2qk0kgAsJ01erxQluVcVtG92Uo7Oh89WIADFlJ
	JVSDKI/zdK3tlZCr2sdp+uECArhjlCB22Xd1xzsEI+L8LuxN0fz5uBwPh2Nye1VglYy5XS
	GNdXUFJif+uCt8bAusmMO7jgJkDzYHg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFZKfKQl;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E17D4612A7;
	Wed, 18 Nov 2026 16:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE41F000C4;
	Wed, 18 Nov 2026 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021108;
	bh=TSwhsJSNjnAtKDkFULTFwFmDhe+Yv9c61DRAS88DMuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oFZKfKQleOycQXAfqulsKeEapGKLGTey4/+kx9d5tDssB9lQtl8VnoLZYSunOwlFN
	 yKTCvk4zRFgTjUPQtxiIAiludCEsBREbUVdLyrkMoTWvXDqBRn/asPIuirMZXZl3jg
	 V7We/Q3VL0z5Iatc+kK4+7AuY9XnH2pS7xtJGdkWR6gcH3PRpi3AVuaY/lyNfDvjKX
	 wIpP3KgUpJqvlEudYzswYxye/f89Gnb/iGdIntHyaxOQLsqQoAUwM8zqxg2nBWxZJB
	 5vw9Z1rm/vWb0ymAND4jHc2hyhlWiEJ/pZRBorFcNVImYcIJQSHOixwPifNyZNn6Dk
	 hNxPvcK2Rfx7Q==
Message-ID: <2650b0d0-49a9-450c-af6a-df1aa129c3b7@kernel.org>
Date: Wed, 18 Nov 2026 17:58:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/7] mm/slab: call debug_locks and KCSAN
 checks in kfree_nolock()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-7-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-7-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CA0120009
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: zpbb4cgzshgh7mbigik5yyeitna5bc1t
X-HE-Tag: 1795021109-695315
X-HE-Meta: U2FsdGVkX199N+SPIphfR6L9KP/SC420iGV9pUABmeFCfgIkXlDX9rev7SZb7+hdaawBIsdARxRhYs//K2FUnXBOHGX8sVhvORs+7C2Y8XPCIS+Pd2ydNY039xkzXNlefRApNl2g8gR2iUsufDU7190xaJBtpXcbETRRW5nGR7HjGUk0SCuiBDV86ZOulixR6UyB/fjlOMbLzbpCnQp0I1Tufsh9YPjO5QMNhlnj9xh6jBuLgyu10mWEbsKkYm4HC30vC+yYrsf65aPFnOybbmyUrr3nnjqYgA/jRAZSMrMVXGy8y7zf6SLI1rEnA3g87q2UH0gOZmtwZ2w0bvuwakzg2l7v68OBNG8i9TcOY8RNeILojfHgRK9QCONAXU+woxHg6SU7bocmpMCBSjO6kMdrfTbOnxW1e3t79O4XQNntvx2TVg4AF9MCYrL03gQRknVdI65UjdsrnxVSZ/BztjGFTYlc2dOLsB5vOumwpLPDRFXcVQJbnwj2f0dwJV+/f7AGAGd4a9DIagTjNYfO2aSdn2KxR9BzXyyXmVIBNX+9tNfwK51UDyzI7hK7371jtxtT/+MISAOj1i6bLNv+0JdLEBdgU1l2036osC2HfoKcg77w5dEPC0KTi31Jnjet1afKKMcCo1hOxM3I9bdk6xIjKVCE/PRif4hx4ozVfaRQHFGSt2DPi4jNbaUy89HQp2Y6b1+4T2kny9jt8QwKgqg1HGyIyShwdfXYWq1QA2hWXCZ/AAJ+MkCmZtgUSbEQhboydvDqUSkXDEyk6dWKUufWsTx+UEfVrwI9Hjpy7RXG76qveD3gWxndyM/s0Ulm5tZt4ViPUnFU38fp2GOQnIkmeQwybDFfojPWzrYQItonYjSEwdj1QiZDg1ddNwBYr9SuKPxFyBkzzeE7P9OxMsLt3CcexbokoDsJd2/Z4uZ4c1aZKX1ygpnWCAF+FVDleezrbK7C0jdOArCBLMi
 FyYTghsy
 xUFRnAE32y+NvKujI2HOzRcz403fP+/0rApwXrUCdoVA6CRUNxpZu4HiSfvy5CqTLLHEUyAQ77zHKgvJmvW7PqBLII97TrcIB3j/C6EuE31ysgTE36i569E9gsLFGZoMYBY3mNw+xOZzpM7Dc/g9XTlKOxEohNHIf5L3rmcIcTUi0zNbnZJdL+L8hf8CMzBU+KVkgDcLrv29KWL+TTOKPh0Ul+fPXx+WZXRCVVPvUUFhqURrzTwFjPnvM/Q69MxPCXOELWuEm9Fx7KuSl6guX5yNsanUuqvw4Qopiu+VIRnjlp5BBwaogd1uEetbKJbkgCgo9mn7U4GDA9U0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> kfree_nolock() skips free hooks that may acquire spinlocks because it
> can be called from any context. debug_check_no_locks_freed() and
> __kcsan_check_access() are skipped as well.
> 
> However, they acquire a spinlock only when they report a bug.
> debug_check_no_locks_freed() disables interrupts and walks
> current->held_locks, and reaches printk only when a held lock is inside
> the freed object. KCSAN takes report_lock only when it observes a race.
> 
> Just like KASAN, take the risk of potential deadlock for bug reporting.
> Call debug_check_no_locks_freed() and __kcsan_check_access() regardless
> of allow_spin.
> 
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Seems fair.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slub.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fd3de3bee1de..fad19ec6af4b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2708,19 +2708,25 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
>  
>  	kmsan_slab_free(s, x);
>  
> +	/*
> +	 * debug_locks, KCSAN, KASAN may acquire a spinlock to report a bug,
> +	 * but otherwise cannot deadlock. Take the risk of deadlock for
> +	 * reporting.
> +	 */
> +	debug_check_no_locks_freed(x, s->object_size);
> +
> +	/* Use KCSAN to help debug racy use-after-free. */
> +	if (!still_accessible)
> +		__kcsan_check_access(x, s->object_size,
> +				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> +
>  	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
>  	if (likely(allow_spin)) {
>  		kmemleak_free_recursive(x, s->flags);
> -		debug_check_no_locks_freed(x, s->object_size);
>  
>  		if (!(s->flags & SLAB_DEBUG_OBJECTS))
>  			debug_check_no_obj_freed(x, s->object_size);
>  
> -		/* Use KCSAN to help debug racy use-after-free. */
> -		if (!still_accessible)
> -			__kcsan_check_access(x, s->object_size,
> -					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> -
>  		if (kfence_free(x))
>  			return false;
>  	}
> @@ -2728,13 +2734,6 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
>  	/*
>  	 * Give KASAN a chance to notice an invalid free operation before we
>  	 * modify the object.
> -	 *
> -	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
> -	 * will call raw_spin_lock_irqsave() which is technically unsafe from
> -	 * NMI, but take chance and report kernel bug. The sequence of
> -	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
> -	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
> -	 *  is double buggy and deserves to deadlock.
>  	 */
>  	if (kasan_slab_pre_free(s, x))
>  		return false;
> 


