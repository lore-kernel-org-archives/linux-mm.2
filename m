Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2016FB44C8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1DF6B0005; Fri, 24 Apr 2026 04:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2E46B008A; Fri, 24 Apr 2026 04:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B919C6B008C; Fri, 24 Apr 2026 04:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A02786B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:32:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 308EE1B89C2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:32:32 +0000 (UTC)
X-FDA: 84692782944.25.289C840
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32DA3120013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:32:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MYBlm7kB;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777019550; a=rsa-sha256;
	cv=none;
	b=0tuxb4qcl8ev/Zn4gNxi4oo3n6nn0AI2J5fJh13MOnCUPgwjKESaNvx2YEmSzYaE+LUIPO
	jkJozzokfJBEI5QL9hbMXDQmHj2J+q7U/2yUqx8GJQRckYjscMtXJIjBD589M2jC42Uyjw
	VA1oexzDdEuVIg2cpXvPZhhnA1YpSr0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MYBlm7kB;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777019550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbmRHYLI2JvjB0fNkS2GOjThn1ey/TEZLRlkVqf1iUk=;
	b=wM3GIhWGLjcY5EZCXwT6T+o/6fuCyj8nBrUiBzWa5TjPEGY5ez7/xG+oFfdd5BYcjwj8sx
	CNLcN9PPJ1hxHRVqQj1dFp+5BPx8yprXzN47nyzipFGnscpzUJALz0+nMrA8XR9H7FP8WN
	ylJOatIAY/67BUFgbpuM8LvCicwcCAs=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so6851015f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777019549; x=1777624349; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DbmRHYLI2JvjB0fNkS2GOjThn1ey/TEZLRlkVqf1iUk=;
        b=MYBlm7kBWgN7s1qWr61pVs6FZqs/HLEcpVBxW8BXkSxZkUh5xHzaEybDQ0o3QD53yv
         6kIlEDyOw5znHbjVHmzM3/sj6xCJcHP/HgutqU2jfkaofSzRYgKWRpcj2sqYo9AG92xP
         WaHnpHk8fvqnUh/K5JcMg5RHt9AuK+3oP8ClBpD+MhjXUY2fDJhGQXP2knVhm8hvRB7u
         ZF+k6ffZcL2AOD5dpEV+9FLfqpFFL0AYKn8KYdnP1tSGP8raSmc+hfdhbItyFxBxVPMA
         F1GkV3PKX4k4F2qMm7AKdhZcq8+XBz2Srg/DFd+yQqDIivx2poafEnoe16N1kKcpXlJ1
         ZAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777019549; x=1777624349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbmRHYLI2JvjB0fNkS2GOjThn1ey/TEZLRlkVqf1iUk=;
        b=R04tKWLpjvz6x+RHs1JaKyJ5s+ut3fIaAxGkm7wNQbIcsqWlkCDWQGoXmX4CZVF437
         klVBjarmnBeMlGeFmBWCsUsxyPXDyJ7w00yNbNa93XVRcfRG5EAk1B8k2OEhc3vmKOkb
         9H526VJKoicNJyVsVzaIlwgFcH0t38BK/G8s98Q+eQlL0xd2Fa3rPFFgTkUeUqzkJ8aG
         d+wsSHP/5SK0IksbhLqAlv4DAEoR12sVd4uJKXF5X39t3uQqvalxGddfUAN6LrRhfqmH
         I/DCyW8svr2SjNVnk9dJzaIgGDUzMxmhJPcDhbN4j/O49wRILBIsUujxu+LVtPHhHS5d
         mDkg==
X-Gm-Message-State: AOJu0YwIB75UNQb1s7NqvW98L+p3vErDyWbUsRLjxpx5wGJhkoImxUs6
	Yq7MEINlhKjuz+KyApMvzX2crRAeaMuoHeXtMhgZos0d+IhjjOsdmnclyO0rXRJDLCw=
X-Gm-Gg: AeBDieuONuSuqbkrEV72Qtuc1WT3krC4gO3yv3viW5VwSFRQFXjJmHsbJRC/bdKdf9e
	0lxflHto9fO9I9v5GTPnCvAEELX1k3iEAFccTc8MeT7h8eHqL1SMJhBR/4dkDbOSS/sts0/tfqf
	SeMqPG9ygZ00lqL5zIzhGEueKoQOCjy8+YGjJUH69VwVMQDliR5GIuwmKjYVhdP8EROjHqHIe1Z
	khrHc6d+xtFFobPl9ky70T8AQccXpBfGXQ3byyHDA38aUdk7W64D/69YqivmS4SQnz2+wX0LkOq
	zUgZVm7dActfTkKQecgD7O3a3yXQZOUiBajQuP/7wdbUtvuw0YiucWq9UG/qncN8pHTla2XOk5M
	EWMApj3Gf4FUajWG2OWgCxjdgf9sW+9VRbL/7oAVJpiVWgJRnsBTk/MVT6K6SRszF7AJwoNO9tU
	GZ6BkGoK6BNy19KTZ2JmAttrjdEpG/YztOXub/Osy9lKJQQmM=
X-Received: by 2002:a5d:64e4:0:b0:43c:f7e5:817a with SMTP id ffacd0b85a97d-43fe3dd4b72mr47569477f8f.19.1777019548492;
        Fri, 24 Apr 2026 01:32:28 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46898sm62350600f8f.27.2026.04.24.01.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 01:32:28 -0700 (PDT)
Date: Fri, 24 Apr 2026 10:32:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
	willy@infradead.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
	riel@surriel.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aesqm1S6otma3c11@tiehlicka>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423164307.29805-1-jp.kobryn@linux.dev>
X-Rspamd-Server: rspam10
X-Stat-Signature: 3ixik8ja3b9dsk8pj44uafnxejtuafwg
X-Rspam-User: 
X-Rspamd-Queue-Id: 32DA3120013
X-HE-Tag: 1777019549-120574
X-HE-Meta: U2FsdGVkX1/WFqKVeKDJBxU97wI1tD//xZx3rR7p81QvuylzZmaE87599oca6l42YQ8yrPLD1J82Jn/okWuMN/3THTQqasDR4F2brGZ0KKkAoHwYbySWk81Eq6/0tqHUiqdD+vCwmwAXCDp5zg5HRP9kDxgYaYyu8DN75ETMR6Rqz40d+CtdVbGrIXEm+fvTToloqgzs7SZiZfTYDYLKfb1ESatpZOpkiyDIlJD+eydY/IIcVgZxyTmALkTWO2XGfuyI2UZVuN4WypE4Ix4FJIu5TEM+xgaV+IWshTsu2vRw5QHdmZZEOV6SUNqSMPcYai5AvHxYAI2FImIJHTxuflTy/M7ltBzvd7s5jXa8c6+bdTuAKfnwGSXlqysWXs+7GzfV4KnDoK6kyV+jNwqYgLDNt0/8y5t4qA51YmgxZbIKPMW2fz1/IxehQLYbMxH6CY5wrlIFQS9m5HxEie4pLBRImuaJId/hZ3itW/ZOkTpuKjYVCFPqrwEtdOqxJFVvEn3eTd2TG8n6OZUf6JKaE0/K6d4HxanKCYH/hbIPcLZf/AGoR5AEk2QUtK/icJNxMKKx+phjUdQN+fSr/MHkt3ibHD5Xp8ANwdxl1Q+PGElBKTy0fcXj9bgItUdUUe9TgJ7Xfu8exea4a3M003netfLUJiCzvJsMXEzhNPePCihVnad7TjfOpdap7Xza7Mi/OFTL5Sjbrdf2CDesmkHbxBjqNwAsgR9udk6CRf3zKn2TPhBEJsBhEZZdg0swnnVVN+SE0ameeHQ90qaWWIkXPCuUacQbQe6OVTH12tEjogoGXEbipYtBzx2PWFxhWWlMkVcjpB4e96EPRT1yT9REIs56JGOEFY/xTMVBZjrf5Jcalx7Gz85+tE4rFVaM8cTCQY3ZW3bbhrjq38EzCKKG9CX/8tlRpJUes98RiFFushFfGbyblRmFzdWnCbhm8zVeMp3YiMA6/WnxTuctb2J
 yBSk7/u3
 xEhizADh6xc6xWxYPQVMrMq79bH3nuf3kY8MyE2FcM40+0YRxHZZh9o7BWoy9LjiSw4Y5pLMLiOMYwZcUo3PoDsdnHoIExLPmFo3T2LwWj+a+F7KHkNUP8YJ0FXeJ6ICtdej7aUYX7+lxu5W/0R3aq1iJD3Gv9eJp225Tl+40yWYg/ImAzStapRkhX8PjcETdAK2rrU7rEK0k5QJxpXthAJhV/0LTZ+mhCxH6Ju0FV5RHMZKcjYBW2MWCHr8r99zo99lwq0A+vJTOFRVt863omVfDczAqkdq8Y7AAJh1p3YM7PGQ9aiUPmWSNNxE1/Ll4S+BVwqROhAqt8ah1GwBa4r8gYXLthVLt8kqpRNWTJSuEbftRXVHgMVJR1AwlIvDzY+8ibCJ1mxNvP8NTlz4K+F/1lnL+GkkjiPlrxHVUBsPWMKBSHBjVhDb2LH7kSHTVYF4PgN8Hr6qKvcapGfApQ04Vog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-04-26 09:43:07, JP Kobryn (Meta) wrote:
> Of all observable lruvec lock contention in our fleet, we find that ~24%
> occurs when dead folios are present in lru_add batches at drain time. This
> is wasteful in the sense that the folio is added to the LRU just to be
> immediately removed via folios_put_refs(), incurring two unnecessary lock
> acquisitions.
> 
> Eliminate this overhead by preemptively cleaning up dead folios before they
> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> remaining refcount is the batch ref. When dead folios are found, move them
> off the add batch and onto a temporary batch to be freed.
> 
> During A/B testing on one of our prod instagram workloads (high-frequency
> short-lived requests), the patch intercepted almost all dead folios before
> they entered the LRU. Data collected using the mm_lru_insertion tracepoint
> shows the effectiveness of the patch:
> 
> Per-host LRU add averages at 95% CPU load
> (60 hosts each side, 3 x 60s intervals)
> 
>             dead folios/min  total folios/min   dead %
> unpatched:        1,297,785        19,341,986  6.7097%
> patched:                 14        19,039,996  0.0001%
> 
> Within this workload, we save ~2.6M lock acquisitions per minute per host
> as a result.
> 
> System-wide memory stats improved on the patched side also at 95% CPU load:
>  - direct reclaim scanning reduced 7%
>  - allocation stalls reduced 5.2%
>  - compaction stalls reduced 12.3%
>  - page frees reduced 4.9%
> 
> No regressions were observed in requests served per second or request tail
> latency (p99). Both metrics showed directional improvement at higher CPU
> utilization (comparing 85% to 95%).
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/swap.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de9877..71607b0ce3d18 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -160,13 +160,36 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
>  	int i;
>  	struct lruvec *lruvec = NULL;
>  	unsigned long flags = 0;
> +	struct folio_batch free_fbatch;
> +	bool is_lru_add = (move_fn == lru_add);
> +
> +	/*
> +	 * If we're adding to the LRU, preemptively filter dead folios. Use
> +	 * this dedicated folio batch for temp storage and deferred cleanup.
> +	 */
> +	if (is_lru_add)
> +		folio_batch_init(&free_fbatch);
>  
>  	for (i = 0; i < folio_batch_count(fbatch); i++) {
>  		struct folio *folio = fbatch->folios[i];
>  
>  		/* block memcg migration while the folio moves between lru */
> -		if (move_fn != lru_add && !folio_test_clear_lru(folio))
> +		if (!is_lru_add && !folio_test_clear_lru(folio))
> +			continue;
> +
> +		/*
> +		 * Filter dead folios by moving them from the add batch to the temp
> +		 * batch for freeing after this loop.
> +		 *
> +		 * Since the folio may be part of a huge page, unqueue from
> +		 * deferred split list to avoid a dangling list entry.
> +		 */
> +		if (is_lru_add && folio_ref_freeze(folio, 1)) {
> +			folio_unqueue_deferred_split(folio);
> +			fbatch->folios[i] = NULL;
> +			folio_batch_add(&free_fbatch, folio);
>  			continue;
> +		}
>  
>  		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
>  		move_fn(lruvec, folio);
> @@ -176,6 +199,13 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
>  
>  	if (lruvec)
>  		lruvec_unlock_irqrestore(lruvec, flags);
> +
> +	/* Cleanup filtered dead folios. */
> +	if (is_lru_add) {
> +		mem_cgroup_uncharge_folios(&free_fbatch);
> +		free_unref_folios(&free_fbatch);
> +	}
> +
>  	folios_put(fbatch);
>  }
>  
> @@ -964,6 +994,10 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
>  		struct folio *folio = folios->folios[i];
>  		unsigned int nr_refs = refs ? refs[i] : 1;
>  
> +		/* Folio batch entry may have been preemptively removed during drain. */
> +		if (!folio)
> +			continue;
> +
>  		if (is_huge_zero_folio(folio))
>  			continue;
>  
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

