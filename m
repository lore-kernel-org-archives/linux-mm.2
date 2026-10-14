Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA51BCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E34D6B0088; Wed, 14 Oct 2026 07:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9FE6B0092; Wed, 14 Oct 2026 07:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA2C6B0095; Wed, 14 Oct 2026 07:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3666C6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:29:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4DE9404DC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:29:32 +0000 (UTC)
X-FDA: 85321011384.07.693FAAA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id DD415A0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:29:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Y/li3cnx";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791977371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0ksxRT6rJjcKFpO4Cy8B4p8cW2Dk868nlYmS4mFCYs=;
	b=gEG8KfnNOl+1p7/EvoCqco1BHEVNYn7HTkK6ukQpBap8kqo8LoLhOuRtn35j4Dgs48sO2u
	mk+ouFMF4jZYV6GDEgvuJOGRqqii3W+YpF8U5JkZT4Fk7kfaAUpz8Z/97CWkHIIY6+yqKz
	1WBRFIgYh0ML7tSxyd8rUWPlAFPFCH0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Y/li3cnx";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791977371;
	b=m1FGg2KcK+IUYsV+ODtfY4K+K1vLImHsYQKFXw/mOHvERVGijMzOAq/MDoeP7V2utsSHOg
	z3diCkCXAOLmXI3h1+mBDMnIImPG/2Sz48Gzi5XLpL89SFCKKUmngwWs+eu88ryNHVOM7F
	FldgSy/VBo/fHq/CbUWz0RuTdyWYCII=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso37364305e9.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791977369; x=1792582169; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u0ksxRT6rJjcKFpO4Cy8B4p8cW2Dk868nlYmS4mFCYs=;
        b=Y/li3cnxzhu4vlvSPB3A9fg1o2mAZojMQYDH3ETXmtKaQ1j0JQSIwbW6PN4Cb1Nt1H
         lLq66icw1slRnQexzpl+QaJHUFhmSl0/1i46Tc5tl/saMjN/84oBnndpdYXzdXCSs0jY
         GeFuijJEx3xwF/RW+c1s4R+p8c818uhbM6wNFEKV6JCLxzxlg+cFs5bWcBdcE/L/I5Bx
         A0joQ6w3hR7YvqoxZUxwE9v7mkKu24UPsusQ8ETKmQ5UUXr4Tqqr3+Td3BPrbLZi2CY2
         LInEupuTkO5mjq6eXk6S+ybXqZ4vnHBclS8Eotvt+VddtAGwbhlcGS+WBZLFqv4W/CLl
         4XQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791977369; x=1792582169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u0ksxRT6rJjcKFpO4Cy8B4p8cW2Dk868nlYmS4mFCYs=;
        b=hfy6Ka1h7OVvKGkcRRxjrC9dgO8rBAQ0w7W+R67mkJy9U3uq2anGApdlf4v/B/LLNO
         1vBT2LvRm/CZksQeguvlAdlVl/U0d3s9qt8PotMls//OdO7SmfsjsfCCdsZY0c5a6pDd
         1950Hu0ap4hnReCCCkS4MLnyjNYI+VnI7CuOSpz47hCY8fgUCoRffd+YUCSA4FLTgQFQ
         G/7yCH+9aXi9g2Mokp7Q+r0kbtjo/wDzbBQxCKVs3HWvYRWBimn0f8ExL4nWDMbDF4/T
         h+32zMqcyZEpfu0FSDz/ZynRw5NYt7sbVMLaKbn/xS1t6BXybbGTJAgDGphYnAPN8YrB
         /+lw==
X-Forwarded-Encrypted: i=1; AKwUvBxCmXcDTRhkrG6knK5ZrLG9DK/PWkxW9nqCs/YWt6v8yk9PWjVlsyP+3gIrrz/7otMoll7UW10EqQ==@kvack.org
X-Gm-Message-State: AFq9FYJ9kdfH8xiao1hZeMclYa7dxMH8KBWLLCfttmyGyoZRF626cXR2
	aKV0q9UA/w3CHQQt1oElWJ0qRteU/DTVQ4ypmTlECE2jUQAdx9Lb+HF5IpTWzGFG4rb1OTGyZSg
	kN5OfvJc=
X-Gm-Gg: AYBFou1D+wtjSNOiDMTGVMaEvBVSdS7pZqbfJmWTkl6sGCsdPdJUFLsv6y4YeyFsoPS
	z7CKuvXXjBLsbaL2eB28JwPwkSbBvQucRlXz+acEQcWzSLth/fKqyVQHeLqYXw5xj1Vs3pspoek
	aJd0HDLq8dvQ7fLC1+o3cIGn+QtxNoHntxDpqdODau9BCQrs8P7VaG16DemZG3k2Q5z7m+Z0oFX
	Hl7J+ydTP112Q0pcgiTiMJzZAOPp2WOtJHevsaCAlijUbKa28DIhhkm9K44DNjmWVLUZrHuQDxy
	eYNpeXH8TgcE4P6zepNYineM6k6D4AzlyTRv3CEJJ/o1BIbUgLbKdqao2hKp2s9eUwzyOY+QXYp
	bNh4ohadC5jUdqhUM7bzVrL+LXDiQ8km0vR0F4JO92ZO8wouYkUdvPY5zfacZuFz0Fx02ZYwh6w
	j10X9C23HRLUr5WOic4vWbhyEiORhMyTtb+gQc0tW2kCoZyhj1nQiLOjbT2LtrEXtzANg/0mJec
	4GQ2znUnXH5
X-Received: by 2002:a05:600c:4594:b0:49d:1fa8:b266 with SMTP id 5b1f17b1804b1-4a18e4d6ac3mr305650505e9.26.1791977369510;
        Wed, 14 Oct 2026 04:29:29 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf214a1sm499703195e9.7.2026.10.14.04.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:29:28 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:29:26 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 3/5] memcg: use high_work for remote charges
Message-ID: <as9nlkBxzFZSLd5K@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-4-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-4-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: DD415A0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 56tqpdesiecgzs1ddbkud4bu9sgzszk8
X-HE-Tag: 1791977370-276599
X-HE-Meta: U2FsdGVkX19quwaROShIn+dcS1j9+ou47alh9+LCcyBWJRVQWkC5TkPELQnv2saZxbf/bB7czQanXyrcXONC+wDpXMJpGfICfd56+qrPktZrZjaKZVJrTp220D470atXfSCWTApQ+URyFvwPJ3Nrr21YGi9F/i1xWWE0dW6tmdEHBsdhnGUhs9KbF2vAZa6eIx9l9/xiTqfafpbesuyOHwemOR4fyLsMxoSZ+wrDGA09vsfsxbpuTr36VXUxF2kNRTrxdR3ovPqpuRGcegAckyj4fIZUzJMzlJOLGyWcqoJfkO8CiI20jBXxD+z0A12XFAAvMkZybmb0S1yBX1GNLoq9H8huUHk2g5MYNL8YlbDG89XV4G20BTfb7tpMVH4+vyguf4wDHMxq6TaunZ90E5r+bLRjia8rtfTKdpyAdTyQWTg1/TYCCT3FUzuVepumBX/4aN9YGBwkgRXjssa08MUCejtkCH6ueK8tMr4tCAXkQmF0UVeALYjJGu4OvZAJ9AREpY0YucINrCbQRYJkElzyHF5cQRP2R7NiF4/RuuPw9/z/SmElTO94h0L7S0DQ63Yc0EdVyc7ZmthQ5tRnLPYNuJa8uoO0P3oW2COf1gkcCA+gu7PsE9jS2YO3FSDpUX65V8yoMcXOcpW6PxjDJT9KO32D5cShxg3cfg7/5hmUbq/U+GkbOpqxDxIQGGHRgY9RRFFf3g9M0H9z+vwhinfvULbjbCQqxqvi2Y6YKFS5U0PqUJvt9IaeAz5+IFZ3QzH9OS49YNctsDONS8WimHE7fJkkvsJsPZ6byz1CNac8Ude29OPA+l8MuB/YV+a9yi84VoP7VNIUAIRLwxCDQHljhFi1BpdatrksUQ3lvR54mqk7ZyH03mh6oGWjxPwfHZm0eQnWflvVx0gWWt0Kh1nytuinNe4R6ebGjeWG5oqUwyzcnGJykQK7WNAh6JM0wNAhKY/8lCkWH22AGxv
 FbktHUrB
 s2Xxto0t7mblZB9jRVGIRJqtWX3QpTMpJAOs7dI5sl6/4UhgM5z0XBUM/m4FRuIw2cSKXouicS5/V8xDDIBSMYVL/m+dmTAtxmcIuT3j2BvxgMDpXBlPhfvHl7EExgD38qJnRJsUu7P7y3wsBfXUlkbVSANR8U0Ul93HPO2jT0QZfskejpkegtTuRqgAScBxBjwu726A1SHgqbFVGNQToFqXjd4WJp48cq4F4tOZb2QCijfTz5z2waQ6UrPlUWEKMHB/IQ3OgeJBjekpPmKGu5qzYkp6TS9kM1TGBQltrH2XvLaYgedc1tmioNQnszrMVasaoHZaBYifAMFdAhFOjJFaEPBCDhEoRg52APTEEScH1YnSbLrcuIyOG9ofa2CVSTzkmCSbGgdLmq0rwaZTy9CDNNQ6wv6/qWzWn0hcY1BVzeUksP+EmwiphXcPRl9Y4jRJxvc2c/kVAcqHB9VY6f0eIE9kdKCgq2s1a1HVc0/i3Um8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-10-26 14:09:55, Shakeel Butt wrote:
> Some charges go to a cgroup outside the current mm's cgroup and its
> ancestors. The high handler uses current->mm, so it cannot handle these
> overages. Filesystem notifications and remote page faults can take
> this path.

Hmm, you made me look at other places in the charge path where we are
assuming current->memcg == memcg. We have reclaim recursion and oom
checks. The former makes sense, for the latter it is likely not
harmful.

> Use mm_match_cgroup() before checking the high limits. If it does not
> match, use high_work instead of recording task overage or doing
> synchronous reclaim and throttling. Charges to the same cgroup or an
> ancestor keep their current handling. Tasks without an mm also use the
> worker.
> 
> Like kernel threads, remote chargers skip memory.swap.high throttling
> and its high-event reporting, and a fast allocator can outrun the worker.
> The memory.max and memory.swap.max checks stay the same.

Makes sense.

> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8116fce6ab96..3456960cbe68 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2705,7 +2705,8 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  			       gfp_t gfp_mask)
>  {
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> -	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
> +	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
> +		!current->mm || !mm_match_cgroup(current->mm, memcg);
>  
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
> @@ -2728,6 +2729,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		 * Don't make an unrelated interrupted task handle this charge.
>  		 * Kernel threads may be working for other tasks, so let a worker
>  		 * reclaim instead.
> +		 * Remote charges need reclaim from their charged hierarchy.
>  		 */
>  		if (use_worker) {
>  			if (mem_high) {
> @@ -2756,7 +2758,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  
> -	/* Interrupts and kernel threads stop here. */
> +	/* Interrupts, kernel threads, and remote chargers stop here. */
>  	if (use_worker)
>  		return;
>  
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

