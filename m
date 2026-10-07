Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147B9CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 17:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C61A6B0088; Wed,  7 Oct 2026 13:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976EB6B008C; Wed,  7 Oct 2026 13:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C956B0092; Wed,  7 Oct 2026 13:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6747E6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:40:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12B80A0343
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:40:24 +0000 (UTC)
X-FDA: 85296544368.17.528D989
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C30E14000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:40:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8vwGyeh;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791394822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkQUHitjzzlvo38RimBkUzV/B8Ac4BuALErE/4c4/Cs=;
	b=lQNTN29/AWCKmCILsw2CrZwkKiM2PyAcPl0cWDKHF34PyrzhYR1TmZjp6L2EE12WzJXg2s
	WyHLye15813o/i8lrGoutw5XLG4Oyp6sXjZDhgw6/hMSTIdxX3H1RFa9DBRtYuZkY5kDfj
	QR3dm5FuBZs5LblPezVwG0ecSQHQ91A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8vwGyeh;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791394822;
	b=DUXYKTncsWuq5TzTWFcZggVlZ2rBHkg4h/kDw9LkkvMubBl9KYmA3U7qzzOtep2tU8FFGt
	LLlviMok+1K1b4leU/3ISZ5fxGJK3DzBknSEEy7Ts/ls6juGgQeO0iBUvRyKjvnrizi05Q
	rVukl1UhUIWmVW/3F1jJns3+MblmQlM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3372601FD;
	Wed,  7 Oct 2026 17:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C711F000FF;
	Wed,  7 Oct 2026 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791394821;
	bh=EkQUHitjzzlvo38RimBkUzV/B8Ac4BuALErE/4c4/Cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j8vwGyeh15j/C0j3QdVat9KunBD+RZBNpMIIUY+FlzKCCyu795O//KntARQ6+o5T4
	 IkjbWgfaRQd/I1N1B+SzruG6bYeeqoEJ2gxKfCuoGPoGGgXaslXXirvZk6nIYszTHm
	 vb6IRag2XLh5KFH/N/NiOWvWcXN9DI7zdEAEK7rdYNVSfLOBAQMoF5B00A/gbEvTEx
	 sAQLlwgNo9I/vj0ipvv59CFNMrdqSwDFt+Wqxj/EDFY2IsPXBCJ6OQhyrgv1wxAnGJ
	 JqEIcQNSP/SlznuJKtRD7aiKITMofq3QEx4g5+lpdgks0+i1CZjhCQhg0d4QMSHqLa
	 XGpvCiVJqOGbQ==
Date: Wed, 7 Oct 2026 19:40:17 +0200
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge
 failure
Message-ID: <asaAwg1KeZoEYd4K@thinkpad>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
 <20261001044056.75079-2-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001044056.75079-2-kmehltretter@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6C30E14000E
X-Stat-Signature: z7metnbnjkwxh6gn69rupq3p6m55uqg8
X-HE-Tag: 1791394822-818540
X-HE-Meta: U2FsdGVkX1/XC4AkQl3Yyel9Bw/OueaDwSHWU8sMHmo7xjr5A3JGxadv882AFtxmLiftKD4S+Xrz2yrvbsx3E3UKgikKxIdPhm3g+ljllJSL6p9qJ6tThH11FN3qQCyBgzmm4fjIF3xt1VkAnysJal4fyoxA1fxCTKPbBOA2mabuFiFxshgR6SJ9lAJvMM6vPesvVGuJGnGd3TgBZWtH6Qme5cP0O2fDNdq4FpMGgPLR+cWviJSWQjfrOU9pHcITnBo0ClxvwcmemJSp6g+bVZMMzvuR1C2+9gEfjwjhj3j55ReTUkrFhVK0z7qgz8HrNEKY45lp0Cj5xqZP+9pvW28Fl6SpbHQmA8xTXDHiDh3fpyhtlUd9nMjYdqGsGu0lBjjnI3SO8/LAZjh4VTrrUZlCHgRNwlZZXJthVGg4q4i7Ur9jEnUj8g0solGgYjogs1pRW0AbsUMVkmTuU1Y5E/y7IrIGj3qX3NI9c1uyrXqEqS7rZKqNOtg2k96jgjatuRA9Qo1PD96qQ4eebbSvlEZ2PWVCjnMADUeIj2nwm5IL1Vg2HImqGFWUlRJGCD634wMqtJ00TWXlWHmeOvnelsvxrEJ44eGGSQ5suizlOYra97ZK+C60noJ+HeaWH8aMEKb0AaJgwXpAhkXBaoqvxwRFVsq78SNbiV2jzti/IkkZ9disku9oVC2oo1Zml8X/dDBJgTVyU+7RQ8sdGiFgretDXMaEKXwUUs7ZOPIKvwP+lwhC1SjLHGDYedtMlSfq5HXiTNhNbzZKj+0YUUZ7GwBVOB51H7jKiQvTS49onrp1vsEL2YZ60qm9NjOc9VooNDUwQ4DnI+xjlhjUIzYwjuQ9/nn32OVUnlF5A4bOqyhI0BEn6s5oYwK8BUEQ/wbAv1RGRx+4A4C1hJ3bZHITW4YrifgktORPg0gqigkS4bF4MUaDbCpzCpI0kbxhFJyk3YmHdf8yN7jshkDAMjt
 EhvRRVht
 IgwZGpX8SW6NaMluHSOPxKebIMQcd03t+QEavvmYyw5jvHoTspvO4BbVXLkvWO7TXX3zc36gh2r7RmvB90a7WGCG0kzpUWfTIYuZQ/srZJK0C+7q1Yz49Fhyj8aqR+GHFadT/tbDMRumWA3q8UiHUcOkTt9RcayvoHvBk1tayzFCkViBk2j+MNLag3c9+VoSCj5UmMN91tjbzee4kC0sZHPYLfn52lQoPsXiiDwcOZ8rpwVq7soMUkjw/Kff22N2Grh0uL9DU2i37qZIcV4NtG6ndkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 06:40:55AM +0200, Karl Mehltretter wrote:
> kmalloc_nolock() can obtain an object before its memcg
> post-allocation charge fails.  For a single object,
> memcg_slab_post_alloc_hook() rolls the allocation back through
> memcg_alloc_abort_single().  That enters the regular SLUB free path,
> which can take a sleeping list_lock on PREEMPT_RT even though the caller
> selected a no-lock allocation.
> 
> Use kfree_nolock() when the allocation flags disallow spinning.  This
> keeps the SLUB object rollback on the no-lock free path.  The failed
> allocation continues to return NULL.

When this happens, the object is not charged by memcg.

The kernel should not invoke memcg_slab_free_hook() (called by
kfree_nolock()) for a slab object that is not charged by memcg.

> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/slub.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 54ec125033571..a1f08338102e2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2519,7 +2519,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
>  
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		if (alloc_flags_allow_spinning(ac->alloc_flags))
> +			memcg_alloc_abort_single(s, *p);
> +		else
> +			kfree_nolock(*p);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);
> -- 
> 2.53.0

-- 
Cheers,
Harry / Hyeonggon

