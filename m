Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F96C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F326B008C; Tue, 21 Jul 2026 08:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36D96B0092; Tue, 21 Jul 2026 08:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EED6B0093; Tue, 21 Jul 2026 08:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 982116B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:30:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05FBE140114
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:30:43 +0000 (UTC)
X-FDA: 85012717566.05.8D07C82
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id E10A5C0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:30:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KNoaSjtF;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vw+R7y8hfT7A4z5+X72bXa8COEHFqKBWa6qMTipwJ+w=;
	b=ejqmHRMzjSDnGF3PZSJjBjXGsVnNAdkYE672DNb+5qtOASq55at6i4U90Db0wh7NagJzNS
	VvfxcnXhzT25tqBCh7gAZJY8mJd64dK6RgbKmkcOBMvVG2ah7vE8a5ObG81trjrKcyvBTh
	6wRblzIswICYJpyYMsoVtLbkFKbdgsM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KNoaSjtF;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637041;
	b=ekf2Nq75XGsV4RxGdd3MdnCAPfeqwLz4w+ljya1/gx/9tZaQcdHzLwKCQwa7+K+CwVm20W
	wg/+NHAC7pn5yiNG9Kc8H9yJ+pevYLtqvmv/W1UwXM0nCVXvZe6wXDWd4249+T6QReQQ/+
	bQACXqVvI5IKrite4euh+PMrJMEStxE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so53834675e9.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784637039; x=1785241839; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vw+R7y8hfT7A4z5+X72bXa8COEHFqKBWa6qMTipwJ+w=;
        b=KNoaSjtFdDPTmYbxUxj1zez7yEeDB/E9joi75e/MiT7qSKIk0b4FVP942tL0bCqWfH
         8mZznS8wRKmfqSqHRA5lnfVBPcN+XjwvabSQJy0U3m4SqQ13AdKWnhXJpnn5s+ZDk6yh
         Q0wr8owGDWG1GkgxG+rnpEAiqHEbjobZPbCPMbgeMJGVOwD/p6EmjeNI8cfpvpj6bHie
         cBzjtZ6eo45iwwK6253sXvlz2DDXjpqY2qUA0baw05lqfH33z2UGfJk6UT21nicK9kNV
         1/dra8pL8Db6TbhxqxnM0ksT/8VRUJjC0OfgCRRX4WmYs51pUoZzpI31jH2cZWWXmKcT
         5jbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784637039; x=1785241839;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Vw+R7y8hfT7A4z5+X72bXa8COEHFqKBWa6qMTipwJ+w=;
        b=hTMpA6kpCVXsPJdGRwdVduvNIDKFkOYev6d8j7pt7ptlYEgBbXJ7hhOkY3OG4HX18x
         V0Ex1cnTosw7ITlNqT0brr6/XDb1InmO9kzk86nRHmlc6OPU8QHmBiea03Qu8yPYm8/s
         c9mUqdmpH4APEt9gHo9TZey2ARq9bHtTE3IKRleHUyN4+Eialicy2YGCm35YdKVwrSqL
         kMI8gIwEegT2QZc/hw1JmhMiUhVmVlV79cieQsdoNJuTkSAQxcxD85L/TKsKaz6XwrAd
         rW1boxyxPOQe5RGhl7pZAvdh9/ATZY7N8ALBnRMbdifeZpudmuIgspvzMXQl2HKgyzBo
         CKhg==
X-Forwarded-Encrypted: i=1; AHgh+Rqo8FMtUJFBUXK9Mn5HWVhoA1ZrKPXVIHKfzXmB5eff/uQGFWEHbI4yTXcpDLHcv6ONLZeN8ALGjA==@kvack.org
X-Gm-Message-State: AOJu0Yyvj0AlWiBzHUr5lMcTtLoigARTfv+Ybnxz0lUhemyoSIjgyPEd
	4Uwsm2wKmxA7d0KY565JsoEbDcPc4g9yb4z49JlhtmlJN28jN4CrY6lzHGoRg5epRXw=
X-Gm-Gg: AfdE7cm8hyNLMPN8I2Nli2BT7KWAoCgZn0jli6SFvZ6GD1hj3cRu4d9nobA75ZoZCph
	ui67Bn6Ld5mfi3amwrQ+AeEk2gZY2x7EzrirJu9pj9yon4Hk9IBira2tp3ANB2l0eENHGtQ1wgI
	t/FrQkmjWS+fRl/pf/6+WorAYHtcagvAToDmH92ZsQ00nOKWsrqpIY6KN3WZAXSXIEKBkhn7xBz
	UieWgiYHRzlsQhzdyH6e3GnyXLXVEfGr1qZhHK2vjbIUW3LcU6PGdfmX8gl6ufUccM1ktstlmT6
	8VwA3D1aUATg+hAMSlXcIj3zL7Vh/H1n+Y8BfD2dBvnBZQ3Eo7X2sPImfiz5rpk7xPzrG9KPoih
	iOi3JiFJNXVvDw+BqYQ+Ka34UcHguh73qzBG5cg6Wg7qjz0Fx/jwTOGgiV6naZ6fE/Gdx1uN1IK
	Cb5aj49Y6/+pIu
X-Received: by 2002:a05:600c:6dc1:b0:493:b967:178d with SMTP id 5b1f17b1804b1-4954a402dd9mr129364835e9.19.1784637039238;
        Tue, 21 Jul 2026 05:30:39 -0700 (PDT)
Received: from localhost (109-81-80-79.rct.o2.cz. [109.81.80.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ed1911sm41461110f8f.22.2026.07.21.05.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 05:30:38 -0700 (PDT)
Date: Tue, 21 Jul 2026 14:30:37 +0200
From: Michal Hocko <mhocko@suse.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <al9mbf00nCx9gWS2@tiehlicka>
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
 <20260720044103.905191-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720044103.905191-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E10A5C0003
X-Rspamd-Server: rspam01
X-Stat-Signature: 4au9rcufcutmny8x5fjqdm16bbt131m5
X-HE-Tag: 1784637040-705976
X-HE-Meta: U2FsdGVkX1/4HKJuasIOh37AGaYLNFIqxfErwOXZRHIHtx6xV6JQcth3lnW7Nm9jLxvvHRXIe3XDT1Y4GgULjsgn+SIO0D3gcWPZ4zY9kNYP4u61pjqK3QLC93y21TnjOtVxXiYTHtRl4hgv1LIrrkT4T4FH7eE3I8ILi5vYbhYA+K9zSzoNmibRbsRwFbJKcqmmVkQ0FfuJmdzc82cu6O/9iSJ4VOcsKiBUCBr8ko8ybY3yG+jzAiLISjgPPsnOmvKELgj3H0qbgjy4flmE4ITZ0Q5Htq7Zq+l8XTPZN59LaYxs+4GGxwMxM8Nv9ufJyw4CiYUxY4WAw0K+nRGfz4Hw79l7lWYXUaewE5t8U/PE9kaC7y5CP0RPCBb46Gokxa5sF2wVbOEfrGaWUEBgu+DP2pOoid1zcGXxNjDBuhTuQdQDsll2QMYI2YonFl9rQ/wKVejQNp7ZtGIwWq/TAd7lMRwBzUVamo8OAiL4RDly5M+CMRiJ0VkBn4Uv1sbCpyXidPh3t7cDYrPMsm8L1SEnI0va89GBykmuqtePCY2md5cuOAB17yiopsnWmVfzhhKMvWhJIJoUAuQZBTOzBPuUIx7zKj8U8baJXDlmS8yXgKPxNoKAdXj1aEgLarQJQreBCCD08oKRCGLg9bolovRkxXT1Sk63QyK27aKjijF/GM6b520gZm3JWapA2qAbfgDcZ3gilBEHyuH3fo84TCE/MZKIGqn9YCVakz4quojVSpdvl8OS75Tfo7JvOxfNuqCjlNmj97l84qWHNSnOK6G49Nr62Y1YUSiP1mzIpivktNwPDm2fD7sMFNUE172ak4N3/TGYqvamIYFMt0zyCb48P+q2uMMB/bgCgcClhXWK4vSdW8alqwB2Fg08lUPAjivy3LejvL87h0qKKS82XILwnmfEkxuiGLkpy+BDJp6ECspMxRHBS1zXQrirCZ3CKJQFomE8NMiEBXSYW1S
 h02LIuJb
 l9npi4zmDqxG9sGioa6Zog4KhwE8q9t+SmYHOIuTqmtdFYdW7zF2m8yLIIELocxAI17koYTTq7/dE2sI5FynJqCGN/7H0geOr+LA9j8rceOPWDTMc8t4uUi4oooxrYAwpFGwq9QT0mf3PQ31I9U5Ci5t9so81qtLEPUCDjay48DsjVg9tTUqkfugMidlEs0rCQaSb/JRXIFHoxKFttshSuWGC9ZG5NhMEX6iRDl8LhaAMOetTiFA5KM9bzMcsfXXEEP4lReCTDEyvauuRIlc6xdJRnSW4u8Fb5z5gGe/ZLevE+XmcLz22yMBhd++tLSMqwFKsUs9koFRafsMSQWayFMuCCfJGR5j7YIff9OlmRxFFINIIHJlacanZsb+rWEP3WS9C++nONAG8bxNtqwEVJcvPYlcgdv2taBbaOsQts23D0zGdMQe+zGdb1LB8F1w9xxKJf9LmSLNkVd45cLKd55M0yfnEiAOu3Cse+u5zGQYHTzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-07-26 04:41:03, Richard Chang wrote:
> Proactive reclaim (triggered via memory.reclaim or node sysfs) checks
> for pending signals in its outer loop in user_proactive_reclaim().
> However, the inner reclaim loops—specifically scanning cgroups in
> shrink_many() and evicting/aging folios in try_to_shrink_lruvec()—can
> run for a long time before returning to the outer loop, especially on
> systems with many cgroups or large memory sizes.
> 
> During system suspend, the PM freezer attempts to freeze all tasks by
> sending fake signals (setting TIF_SIGPENDING). Because the inner loops
> do not check for pending signals, the proactive reclaim task can remain
> stuck in kernel space for seconds, failing to enter the refrigerator in
> a timely manner. This leads to suspend failures due to freeze timeouts,
> a behavior observed on Android devices.
> 
> This latency issue is specific to proactive reclaim because of its
> large, user-defined reclaim targets (could be gigabytes). Since commit
> 287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
> proactive reclaim uses larger decaying batch sizes (starting at 1/4 of
> the remaining target) to maintain throughput. This keeps the task in
> the inner reclaim loop for extended periods. In contrast, reactive
> reclaim (global/memcg) uses small targets (SWAP_CLUSTER_MAX, typically
> 32 pages), allowing it to return to the outer loop and check signals
> frequently.
> 
> To fix this, add a signal_pending() check to should_abort_scan() for
> proactive reclaim paths. Since should_abort_scan() is called within
> the inner scanning and eviction loops, this allows proactive reclaim to
> abort early and return to the outer loop in user_proactive_reclaim().
> 
> Additionally, return -ERESTARTSYS instead of -EINTR in
> user_proactive_reclaim(). When interrupted by system suspend, returning
> -ERESTARTSYS allows the task to enter the refrigerator and automatically
> restart the syscall upon resume, making the freezer transparent to
> userspace. For real signals, the signal layer will either restart the
> syscall (if SA_RESTART is set) or return -EINTR to userspace.
> 
> This fix specifically targets Multi-Gen LRU (MGLRU). Classic LRU's scan
> targets per iteration are strictly bounded by get_scan_count(), which
> ensures it returns to the outer loop more frequently.
> 
> The check in should_abort_scan() is limited to proactive reclaim
> (sc->proactive) to avoid inadvertently affecting reactive reclaim paths,
> and is wrapped in unlikely() as it is a slow path.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Richard Chang <richardycc@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
> v2: Update the commit message
> v3: Return -ERESTARTSYS instead of -EINTR in user_proactive_reclaim
> v4: Clarify -ERESTARTSYS vs SA_RESTART behavior
> 
>  mm/vmscan.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..5aa4becacb7f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> +	if (unlikely(sc->proactive && signal_pending(current)))
> +		return true;
> +
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> @@ -7909,8 +7912,15 @@ int user_proactive_reclaim(char *buf,
>  		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
>  		unsigned long reclaimed;
>  
> +		/*
> +		 * Return -ERESTARTSYS to allow the freezer to interrupt the
> +		 * task. The syscall will be transparently restarted upon
> +		 * resume. For real signals, it either restarts the syscall
> +		 * (if SA_RESTART is set) or is converted to -EINTR by the
> +		 * signal layer.
> +		 */
>  		if (signal_pending(current))
> -			return -EINTR;
> +			return -ERESTARTSYS;
>  
>  		/*
>  		 * This is the final attempt, drain percpu lru caches in the
> -- 
> 2.55.0.229.g6434b31f56-goog

-- 
Michal Hocko
SUSE Labs

