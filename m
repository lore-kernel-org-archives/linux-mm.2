Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC3DCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799F56B00AB; Thu, 25 Jun 2026 05:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722DA6B00AD; Thu, 25 Jun 2026 05:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB0E6B00AE; Thu, 25 Jun 2026 05:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32AF76B00AB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:31:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F50DC2A83
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:31:32 +0000 (UTC)
X-FDA: 84917917224.27.700990D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8319C4000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:31:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VsYM/5f9";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0eBLQUrl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=E6c4Pc2b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tqlubKtT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782379890;
	b=kDA8HpG98mi5qVhq/Mb0YpIJ4BWamg/glbq4V9YrjUuPBpEzP4D+FL4wUKgdzeDi2n0yRQ
	tXzGDozvhxGi2cvgTtKTCvh7aSno/dRZLA+Dqoc8CnB9WEkzYOR31WFb1Iw4Yxi9PDCZCi
	zN6XAKKdcwcWVVzVhnXobfapIk5S1aE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782379890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94hiD9d2NnJ31ei1N1NiQfwNES0m5KtvpFc7BqgKwu8=;
	b=H7WPFXKs4R6qa2jgCRuXyZJffQJTZU+80EFmt+Y+DB5iCEES8GDJQfg5eFYJBrIPcJUMjd
	w2SjSqWQRySWcoA7aIlZR6UevB9BbJDQuarDj7S8xMiBbpUG/NmxOkcekQPn38KTszPPLc
	jKd4hKbWvG64spfPbRbnHG9GiKezOhk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VsYM/5f9";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0eBLQUrl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=E6c4Pc2b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tqlubKtT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F37EF719E9;
	Thu, 25 Jun 2026 09:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782379889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94hiD9d2NnJ31ei1N1NiQfwNES0m5KtvpFc7BqgKwu8=;
	b=VsYM/5f9VB+jp2qmMFx0NZtc6n4KIkwB4xQaSqPWfNnfwf7hCmMY+86JiumHgGGhgf7idI
	aKGK7Qz4gZ062kQzk3f95bG4U2f3RkRv8Syebwav3RAlmdiJd09qpaEM49AIEpbeJXgqQ7
	VFqiqKO5EG72TaF3S4mfxqPpP4A+eaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782379889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94hiD9d2NnJ31ei1N1NiQfwNES0m5KtvpFc7BqgKwu8=;
	b=0eBLQUrla28s68U2rcaeuoxTfoURQlKvLOWQT8Fc/Zi3ghjSKFfVBkl0ZL/5fQN40H0AJN
	3K+GKP7bJnUS4YCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782379888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94hiD9d2NnJ31ei1N1NiQfwNES0m5KtvpFc7BqgKwu8=;
	b=E6c4Pc2beWve9l24by2fDSAz2ofzvp1dURuA+vTP4DOGeB0l2uo8b5UEoxk4ilAmcKaBpv
	iqId3jvsClJPA0GnLur7TB4Iu+6W9+DN8brqrTTCwm7LI5iJF4wiTnEV9IUVF4J9l2nvaK
	9yxjbNea1cP5fM0BhByhGPSbHb+XNro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782379888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94hiD9d2NnJ31ei1N1NiQfwNES0m5KtvpFc7BqgKwu8=;
	b=tqlubKtTxOPI3bbc223oR0p4/BTXcuaHxI3E3dH9sT7nf0UhvK4VO7Ag8C769SShDtMjPM
	qmpqGWugwzqGf9Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A5B7779A8;
	Thu, 25 Jun 2026 09:31:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iyAMB271PGpodwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 25 Jun 2026 09:31:26 +0000
Date: Thu, 25 Jun 2026 10:31:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: annotate data-race in cpu_needs_drain() and
 need_mlock_drain()
Message-ID: <ajz0pjJpxsTNwI8F@pedro-suse.lan>
References: <20260625065153.1581419-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625065153.1581419-1-wangxuewen@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8319C4000C
X-Stat-Signature: nd61hr9por7s87sf1jk7oddxnnqhbz7u
X-HE-Tag: 1782379890-881485
X-HE-Meta: U2FsdGVkX1/7gXHyzsFdB8SHgv/E0gvwlghL12BwCGULMvXN11gL5cfNm5vCyogPqJEMxUpd/rSHhDZLq53j8wOZ30ZQmh/JfXiOJL38bj33ZcvgmbxbDp9WtVL6SxjrSEVi8Oxq63pXo3bun2E1+dECkEYScy55cv3qBg1vRgzjIdzWBmIQzYMsy0i3IchkZugtauOfZ0PgN/TCLUGgNia1fda5w/0LNt/Hf6qp0i/hxqjGqTwupCx6ODFBIr8RPCkRJRZUDAT8U8QQMpgrCcNh348wToa2YNF7iqnbyUHxsoZpnP9Hq+APKw5ZU4EvaO530AOhNUl21TKUyLtWISoO7QO4xm1SnNFiBRhF27r54NlojQ3jGbFMUxlHW31VwzQlqlHTR5lDOrnZ/X0kk23S2QM/bgkl1OqRYDmefw8ktjsJdE0Z0OrCswIW65C/FX59Xq8JXjpe8+3/xORZUUv+/sod/VUpjBRPr5GJibPAPCodI2V/FqVAY5CUNM7nWjAMgaLPCqB0NkXrzW3NBqSREisaPTbo8xZXiLHIgulHgW6XAjcRJHGZ2+Dp6Ly1PuO36uKd/K4K/kxIxWIPzhzgdnlDxcraS5No1iASfguYiBeZClrseWMg0wh+Asj3SpZThBAkTT/ooUlOCukkHQAvtJDIznJarz2R/8LqQnrOpUfbWqgI20iiFSpphJZpLifu/y/x8+YkMWTKF1aLJ1uR3irIP6Q5sz8g96BgQTORMYEMRmoJV1qy+IO2vXkD7Idw4hpX34oBok44O3FARtHtThD4jpc7tj7watv2LVYpp6l5rkxAMxoZAPTvjK6Ag5rW8Q1IAvpTDV8N7QH0Au3bVNhqYD+Be7vT2Yd107impuNP4sStkbSyagS9lHm3svG38mX5BdK/vLuE0/jikBiNSHUq+n7Su4eL/l7roX3vOvKi6TYpVlkBB/rSfxfYUFR3YjLWUTcWQGxgZWS
 8iMfRMEe
 7pXikM0+rd/7/ak02OmQynLC7NO+bt0EyXP5Lcb599b4z4wbtqsNrpTdQCRvJ21odl1E/AkGCz1QW03/TVRaoo559jisNdE8J09rx/88Qj8Wmd7bkVhEVjykE+OxbXjfrLYOflkrMdqZ7lAn1TmiGBfQe9KzUvs+lZMATnB+6u9wti3htfVCf0Qcy47J1+D0qINrErT+VAeu2t0xlwio6DMhA7EMFQbtNYEWyPZp0BueNvz7W4J2isXAIxfLWZdP5tj2m1yZhwpMT6upYNvy/satsWXwbxQtQVrDg6rgw5E5lLDhaoXG4z1nuk/m5WDX5wDK5uAwwMp/ob9hbQMMDUPWJGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 02:51:53PM +0800, Xuewen Wang wrote:
> KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> per-cpu folio_batch->nr without locking, while the owning CPU writes
> to it via folio_batch_add(). The same race exists in need_mlock_drain()
> which is called from cpu_needs_drain().
> 
> Reading a slightly stale value is harmless -- cpu_needs_drain() only
> decides whether to schedule a drain, and the next iteration of
> __lru_add_drain_all() will re-check.
> 
> All other callers of folio_batch_count() either use stack variables or
> access their own CPU's per-cpu data where no race exists, so
> data_race() is added at the call sites rather than in
> folio_batch_count() itself to avoid suppressing KCSAN warnings for
> future callers that may have real bugs.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
> Changes in v2:
> - Use data_race() instead of READ_ONCE() in folio_batch_count(), as
>   suggested by Lorenzo. READ_ONCE() is unnecessary for a single-byte
>   read and imposes overhead on all callers, most of which have no race.
> - Move the annotation from folio_batch_count() to the actual call sites
>   (cpu_needs_drain() and need_mlock_drain()) where the cross-CPU race
>   occurs, rather than affecting all callers.
> - Add need_mlock_drain() which has the same cross-CPU race.
> - Add comments explaining why the data race is safe.
> v1:
>   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> ---
>  mm/mlock.c |  2 +-
>  mm/swap.c  | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 8c227fefa2df..fbdb5018e2c3 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -232,7 +232,7 @@ void mlock_drain_remote(int cpu)
>  
>  bool need_mlock_drain(int cpu)
>  {
> -	return folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu));
> +	return data_race(folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu)));
>  }
>  
>  /**
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..d046428caed6 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -828,12 +828,12 @@ static bool cpu_needs_drain(unsigned int cpu)
>  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>  
>  	/* Check these in order of likelihood that they're not zero */
> -	return folio_batch_count(&fbatches->lru_add) ||
> -		folio_batch_count(&fbatches->lru_move_tail) ||
> -		folio_batch_count(&fbatches->lru_deactivate_file) ||
> -		folio_batch_count(&fbatches->lru_deactivate) ||
> -		folio_batch_count(&fbatches->lru_lazyfree) ||
> -		folio_batch_count(&fbatches->lru_activate) ||
> +	return data_race(folio_batch_count(&fbatches->lru_add)) ||
> +		data_race(folio_batch_count(&fbatches->lru_move_tail)) ||
> +		data_race(folio_batch_count(&fbatches->lru_deactivate_file)) ||
> +		data_race(folio_batch_count(&fbatches->lru_deactivate)) ||
> +		data_race(folio_batch_count(&fbatches->lru_lazyfree)) ||
> +		data_race(folio_batch_count(&fbatches->lru_activate)) ||
>  		need_mlock_drain(cpu) ||
>  		has_bh_in_lru(cpu, NULL);
>  }

eww.

How about:

static bool cpu_needs_drain(unsigned int cpu)
{
        struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);

        /* Check these in order of likelihood that they're not zero */
        return data_race(
		folio_batch_count(&fbatches->lru_add) ||
                folio_batch_count(&fbatches->lru_move_tail) ||
                folio_batch_count(&fbatches->lru_deactivate_file) ||
                folio_batch_count(&fbatches->lru_deactivate) ||
                folio_batch_count(&fbatches->lru_lazyfree) ||
                folio_batch_count(&fbatches->lru_activate) ||
                need_mlock_drain(cpu)) ||
                has_bh_in_lru(cpu, NULL);
}

this should work equally well, while being far more aesthetically pleasing :)

> -- 
> 2.25.1
> 

-- 
Pedro

