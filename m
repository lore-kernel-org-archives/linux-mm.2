Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0835D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 20:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCB86B0005; Sun, 22 Mar 2026 16:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD44A6B0088; Sun, 22 Mar 2026 16:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11746B0089; Sun, 22 Mar 2026 16:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A20CB6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:28:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E94488C662
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:28:47 +0000 (UTC)
X-FDA: 84574837494.14.7B5EAB5
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2DB84160004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:28:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KarD8AeK;
	spf=pass (imf08.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774211326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1PdHQE6n/XEgS/aLzCs8JE23f7fC+5Lz7QhgSafyz4=;
	b=8YAeEGEn0Ez/3KQwn/oJ9/G14TsKJiY1eK4YKK3vIZ/3Rn3NkJ+lh/ETdMAuOk7GQuCRgR
	YH8aKXKCUTj/w2LG1sUE0jKKBqK/NsLGnS0vYoncvMicN+i1oCWxfOuDKbckpElpRSB3Fg
	1hfqK/AFhHR6RuJdQFy3jkBBLwFcNig=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KarD8AeK;
	spf=pass (imf08.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774211326; a=rsa-sha256;
	cv=none;
	b=w5YyPMbMorQxn6wtnSpknU3F41u0L758R4W1w/nrDO1bx/4yNCL7ssz+4tv4qNNtnXYxTv
	nNyQu4Q/1c1bIj2wjtKiQXQPHVL3mVBA2DgHLjX5e7ilcjWvm5caDSOFuyheJsj35ffRSd
	C9p90tCYM/YN3WuzEBXYvSh9ZV7MJj4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b052ec7176so111125ad.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774211325; x=1774816125; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1PdHQE6n/XEgS/aLzCs8JE23f7fC+5Lz7QhgSafyz4=;
        b=KarD8AeKKQ71XN47GXdrq0WDPbPx6oESxSuf7SWSQBys94935KtBkOaQJCVKm6owk9
         hcBBklB/fk3kg83gSoTVaZ1MyHuN0G2qwU6CsyldCIvPfQYxA1Q++V2EcIXLQVeUvTUl
         XH1ogtyMSZdev53tESgeu7BR4U/bROjIwRHNg+ITJULwTEeu0qK4we+MKcZ1qtvr/7GC
         1XafJH2PjhGb4cv+QZ3W2DVce1bZIwceMIJRJ4OqtMmJvlm1FKipi8pCDNlRNa1LmO/T
         oH1cEtRiCpqapBLE2wG9vxPuoRiRhi/l7uHf1cZe0/l2CG1SyP34kOtpyUQmxiTzodsQ
         CNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774211325; x=1774816125;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J1PdHQE6n/XEgS/aLzCs8JE23f7fC+5Lz7QhgSafyz4=;
        b=fiDwX/YwoxtxfXSpwoHTWV+c252xPCR+tRSdvh/ZiczOGt+pXCcJMgiSahFhBQUhVz
         WRuYtTCrmp85tiv5h7FGN08VrMLpyQM/y7cU3XqcQX7pIa2heLrxFEcNSVJSXr+MRlcP
         2uR/UGUMqPBLoDRf/BSX7j1I322UKhf2Lr4D2ctOrBEC8zo4ERpznlPOZnu+92n+lo4L
         g3PFRyFRUaRu716IfcHl+xLe5nR/YjXvR23LHvJGYzhOyk4QndzadBDRUL5jirQgeZQq
         FGbxCNU3MGfLd3IZH0HhmZCzh2tyxTi3bqT6oV8XecvhOtTkznMwHtGWdCwdDunUCfnD
         4OwA==
X-Forwarded-Encrypted: i=1; AJvYcCUFS4yZKEYbNwyrQ6YCPdEVZBZBipT1D8VAKoF/9xk0tUzBZ6g33TmmNF7qYvmWZXht/oO5SRrZkg==@kvack.org
X-Gm-Message-State: AOJu0YwyzjPfZPldleSdFgD2HHAOVS9SHVC8YHMZBnpMGeQnSE1kWB8Q
	irzbFtYOK9P2KJ14tMHMDmw8WpXO7AmfoGMpsnwjABwQL3rdbxFZBiJSTdi7ClKZ0g==
X-Gm-Gg: ATEYQzxRPwkmATzCtPH4jRUQJ0LkjEjL67Db+56oKRsfaixaihCJSjVEyVxrFXMvOKz
	jylDPEGgokWJzEtm5hdRjqVqz8DW0iBR21ZF62IKuoVZ3CFjtk1c4g+fETztoLhF25eRN9IWCLR
	gVtSfGiU63UEJRFrf5rdRCPpqSabi75WAa8bSk0xerQZQhRSsqqCUFgHvLU3Xe171nWpO7C0x6B
	1BSKI4K3V9HMy0vBNIsU0fHws9Eolb3mGUjIdaQLcgpsWqC6PQFfwAa+9S4I4QMIPK1aBbZOA10
	ygfaUyRkOJDtw8KNl8yLiww1r6Je8Pz0TQAvDgkv7Me46j/YEZhjo5CsXgY0QpARORqqoCm98n5
	WwMzrECEqI7Pien+xAqiAMXK7l3SMJkbsOWkQMqiuJV+dXmcQEPNspDim0w4Lj5ih6neHtvQeUs
	MUi5p5g+LbyrLeaTYAwv3OaaqKNX617HgCciqFIYya9YKlUtduoNNfBEBj0qdQyk8QZTstdO7n+
	b87sOJTWgBV8QbkMXHEOi7aejGXqsgbBBHFvAGbQ5P9XnWFh4kwCQ==
X-Received: by 2002:a17:903:988:b0:2ae:bf32:20e8 with SMTP id d9443c01a7336-2b08b4c7412mr3343155ad.18.1774211324484;
        Sun, 22 Mar 2026 13:28:44 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:57c1:f40f:db28:455d] ([2a00:79e0:2eb0:8:57c1:f40f:db28:455d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655474sm108495885ad.48.2026.03.22.13.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 13:28:43 -0700 (PDT)
Date: Sun, 22 Mar 2026 13:28:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
Message-ID: <a96fe8ff-06c8-3cb2-8ec1-b21ed9b75f9e@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: tf7qj3wuksxhkyqk65kh6cnh9kgtt1xo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DB84160004
X-HE-Tag: 1774211325-815844
X-HE-Meta: U2FsdGVkX18MVRVq+G1N+Vbh7OSsNV4c6zQlH1d2v02ykezdyHkz24RXbRTUUPqhArGRBhl9hllqMJfbr1U5cCWDwH72qBW3EFB7/mHlgifIEt3R+2ZE18zB706pJ4b4l0JFSMExdjpGdJCQOybsQO06Sv2qI4b4lrzOlDYpBjmeuJoEefrSOUUFHPm9/kB5qFW44Byo0P0ioIz3J7tvxfOCu75hckI8n4aGlfS6Q8i1X3R4cpQS4dLh4DDDguP+dys0dtkhLqR0UT5CsHheGZERjpXlftboqtToxhSM7VgrJ3u6MgndwAgH49PeYLawvwvRX1YdH3IdWhgDd+8wDhLOwKzybDHlYDz1SKvTMoUoSGKMP2uwrWOF1oBve2QcwfXZzn3jk5CayUZ/STOzcrGPZZaTPT++T9YfI/VbYabKV3msswuQ3d3zDrssi8jIIl62j/LR001WCImBQoUEJDG52hkaRqSQ9kW/EpRCLBu5puCneffBmDXFrLZtFYWvWBqG4ecVPs6wFT7Bv10259k1onB9ybUh+5YcyDgpzP+348422Nj//W+09z8TOiDorWvya/8bRQ+IViq+Vppx+l8F3kS2/uO2hP7k2BcBWmJzwAjY9wanircH+qMb4kynyawbMVTTXAf5STLLPdAPqqjkNRh9F1RMoZAi637ktrAWpRZnIHbGTl2TBYVm/ZcPFpQmKA1k9/v0g3OmjCZKbX1xp4GvSZiGGr3DUqzrM4a5jSrlcrZof872XCFqAcilZ/8ft9GFKd7M3zPgDQoSL3tXeZcFzjvk2ByCuynPvzsVNmMz1PBSY2ajkM5vtD3IB/ZnLvD6h2vyPKMglQK8bdRMfesUDTbyJAXRulmE1tLEqDvJGtys8eYGxYh23uXoGkLW6MZ/UMGsC6iDDoKkJLmnW5KgZqu9V0LFw6PCQcTVXJxXjunovKsWdKgsvZLKiAIyApJSE/EWVbcDNqG
 mfGNNhnN
 0AvT3Xs0g3C8rFB/JLG3t3gKdZyZGConXx/JRWIc/G4YIk64nt73rz88b0N5PiDhvod6oolt2J33qL63zGYfabH3IvEQmaX4vFhCjPeXGYzdWr70m3HlZ3mPHUELfq6DqffU8xLZ3Icy0LiahfM6WfuH+MFFpR1JDIR5zFr9H361d4KM94QLWDpHXf6WwY9AW/v7xBUzEybKlRkOqtM5qUMA1t2d76OJvWcpDTG8zc+VYNXo8EePzoE2+UzjjoAzuBl+Pp6aqh5padz3UoxwK4QFeHLYmE9dlVoeQ9dCL6ph73v4FSP3TM0FWMF048kHftGVlfJN7cbsXsWmzBmD52GgRoBoP01I3cRwpo+5g9ANzJGm0jvDiibQ2QIqZVRe6C2rDqkPVhVnTQp4hE8JCwR4e6Btcamm0iYqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026, David Rientjes wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4706,6 +4706,36 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>  
> +static unsigned long max_alloc_stall_warn_msecs = 10 * 1000L;
> +
> +static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +				   unsigned int order, unsigned long alloc_start_time)
> +{
> +	static DEFINE_SPINLOCK(max_alloc_stall_lock);
> +	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
> +	unsigned long flags;
> +
> +	if (likely(stall_msecs <= READ_ONCE(max_alloc_stall_warn_msecs)))
> +		return;
> +	if (gfp_mask & __GFP_NOWARN)
> +		return;
> +
> +	spin_lock_irqsave(&max_alloc_stall_lock, flags);
> +	if (stall_msecs > max_alloc_stall_warn_msecs) {
> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
> +			nodemask_pr_args(nodemask));
> +		cpuset_print_current_mems_allowed();
> +		pr_cont("\n");
> +		dump_stack();
> +		warn_alloc_show_mem(gfp_mask, nodemask);
> +
> +		/* Only print future stalls that are more than a second longer */
> +		WRITE_ONCE(max_alloc_stall_warn_msecs, stall_msecs + MSEC_PER_SEC);
> +	}
> +	spin_unlock_irqrestore(&max_alloc_stall_lock, flags);
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
> @@ -4726,6 +4756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  	bool compact_first = false;
>  	bool can_retry_reserves = true;
> +	unsigned long alloc_start_time = jiffies;
>  
>  	if (unlikely(nofail)) {
>  		/*
> @@ -4990,6 +5021,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
>  	return page;
>  }
>  
> 

Another option here if we're concerned about calling 
check_alloc_stall_warn() on every slowpath allocation is to check this 
right after calling into should_reclaim_retry().  We'd normally be looping 
in the page allocator if a single call is taking >10s.  That could output 
multiple stall warnings for a single page allocation, though, so in this 
case we'd probably want to (1) increase the amount of time between one 
warning and another beyond one second and (2) cap the output when some 
time duration is reached like 60 seconds.

