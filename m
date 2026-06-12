Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1921ACD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E51C6B009F; Fri, 12 Jun 2026 12:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795F36B00A0; Fri, 12 Jun 2026 12:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD026B00A2; Fri, 12 Jun 2026 12:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8BA6B009F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:33:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF0DF8AB58
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:33:57 +0000 (UTC)
X-FDA: 84871807314.19.41C20F7
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84D3312000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:33:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lu2hz0Qa;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781282036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaALrUtMzS13T301LDMZjCtTFcOTia8kl+f7FBSPKoE=;
	b=Wifd3Zkb8ZrkjEQbTNXqCR3fW7rwlhBBb0eiDiXtxiDZKjxKSo05koNoFR2osSOdmGFg5r
	jAAKJ+BnREoUo7JEr2w3IsPxqVkT/u3akP2OWwXJmKsXLqZmmexEk0swRZplnmVPSSo0V0
	FgEfD/IG9anHW3FE/rX55KY2edO5kF8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lu2hz0Qa;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781282036;
	b=gsPiQHMOk6ZuAJZwWrp54DjsZjBeLBfCC3PHT661NGrUUUpyRYDkwM9hXq21j3GQGZfytP
	Sz/T9Gp6BLnQPecsmixO+rD0k9XiT+24tqh28nnxHRMmJqg8blQA4YWx4VgI6QLe+KN8lf
	xnrTl7ctZjaKWV9TpYrG/Bfu5rvluPo=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-517907feed0so23803071cf.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781282034; x=1781886834; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gaALrUtMzS13T301LDMZjCtTFcOTia8kl+f7FBSPKoE=;
        b=lu2hz0QaDr3JFF1alCSnSTtXPYYgATSEkeJoFxWHKaxmXzXYJBnciVr/igRk04Om7t
         6NxzUtLl3gynPU1Dkv8kAEnXpohLhTsRgj/n9UVD0ljaFh1Gm/vAndi3kxlIReaR/6tF
         KL0He900vfC3IGMvTaKZeb1as8TF3EMQNbVkXdW8PNnXSk3guuxHtZZlPlvoTaiAFEb6
         NF1IjB8nG9dD6vKBzkLXGMj2ETg0aPdGrIjBwPjos01eSj2IL5GZEINZ786TLVb6BwWa
         kGNaDc/1a10hrfB0Zy756BJ0FKROgrLH7+o+XTQnBHzYcgTvuops3Eue8yyY2swp4SKk
         Zm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781282034; x=1781886834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaALrUtMzS13T301LDMZjCtTFcOTia8kl+f7FBSPKoE=;
        b=SJ1z9HruzxqbKK4DGOE+FxV3AG8VkTw4M84xQ4f9B+wqTRcqHvqvO8IdsGK87BtRwn
         E8wLacA4UcDP334qV/hVc6Wl6BFt2R5WMS7FKJdB+FVovBj8wOZE88B1DD6UzAtX/xk/
         1D3nM9rNFhbVYMauCReId8JmJrFuCI7PiDISaYru/G8tSEugp0PAZMKCxnTJP8dcPgF3
         4siK6yMFi/fFxfY5lMATgQc/DWHNLyOMTfLtP3g58o6XayCIdGMPKxGU8reV1cFNQ5zc
         YNKYlNweZPHsP+YXkWxIKvpnL2qvMNuUXap73tw+UvFj/9Bj0u9uF+/yi2U1tl9O0SPk
         VHjQ==
X-Forwarded-Encrypted: i=1; AFNElJ8MP/zcTxCnz0VzbdlLhN25MCL046GL2QPr1xS4CJT2t6Q3lQiVGyoDExYD+k6rCTTNpc8IKJCmkQ==@kvack.org
X-Gm-Message-State: AOJu0Yx2MpP0jjjdslrIb+GWjfl7cqLtn9b7J4E7cx475AVnvDtpZViV
	rTdTJ80+7BktfhS3mKb+r8iYMSHDKTeSX+XWfdgRapaIiU+VJX1DCEjwQGZqaGK2wmE=
X-Gm-Gg: Acq92OFfrguJVeqQsQfRUxdtFWx3y7KwyujQr+jDkGl6DMGzWIUjFhtkckYQ1H/NxXg
	V3Z1zmzUr7PIWNb5pX5IW6zl2ORqUOW8JnA2kf2JUB2wrXe1b2G7GtEV84k2/0sxb6k13mPnQh6
	NMYgWch+pQn07g4YYc2oUneWXF0J4VE7Q+I6zFKOnVR4FZUgKhvclduYpKHn9f1T8CULpl0QqOq
	duFN/+mxggfykcWO9/4/jzlNr6t1TBf/85cKkR+jmU+j2pUoHKyQVmXVxhBcYk1HVjgXbdRK04I
	HKz4WPOsP/3mS48ARnYiLkRI6pVXT2QQfHmZXCs6Idt3MzBmT6MIcwzCm0E5qPUkzVVFgAM44SO
	kAy2TLbXoiY07/cMvE4EwsGBX411TgsbIQgmwyeTE6Lsr1Xs19XKu5s34Yc6pKXqmq7YGhQdxI+
	0lz/d3P1GdvF+lSEc6AuGIlA==
X-Received: by 2002:a05:622a:60e:b0:517:74f2:e578 with SMTP id d75a77b69052e-517fbcb0132mr51491051cf.12.1781282034506;
        Fri, 12 Jun 2026 09:33:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb642541sm25722601cf.10.2026.06.12.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 09:33:53 -0700 (PDT)
Date: Fri, 12 Jun 2026 12:33:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
Message-ID: <aiw08Iy6BYCPX9am@cmpxchg.org>
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: hyx8t1q9mss1495fdb4ba1adxi8caqqq
X-Rspamd-Queue-Id: 84D3312000A
X-HE-Tag: 1781282035-351996
X-HE-Meta: U2FsdGVkX18ABpQIu3Yljm7S38I3YeOkMrnIwktKMIWcH75qiTMhA/qvj33EYeg+PxaQU6oY76a0plmtkEHVZUBqtNoM7crd2vptg68fY6xdnlrbp6U1JOwI8W01wLT5VfIMEu1GeO6OPXLdSqENAEk6pg0t9yORtLNX6Md2e9Nz4URKpXJoWazoPs61/Oso/uMxccxo39uQzwbvupx3i0YV7dtPG7DMOD3hwOY8tDGl1EmdhqjC/xs79Fp4t6vjcVU/yD42YT0W6Wwe9YKUCMyVyo3pyyNeUKkIx6rMRkKXmxBAJ7n41PmycSEeasG5TYNEdMznaHZslVZJYEET0/lwoF6BJi5yWLZ0CqJPTTVWuRI9QP4ucu74AwuYpNoBCSZ5Q8CT7XGSZ+NtgU7vngqGaQcPiCi6OPbqi91Wh+tYtgUxgT+1/TKU9Ft0jNsaHeyT3uPVScLoN8n4yXlS4wh6QDQ4e7jyS7ECYb3CMRMXADMHp0R+W6bIkwjr/kG6jITP8zRUJc/DTsBpql7WrceK0C1QFveaAHaBkTPBOxGexYmgd3k8fNsMOxgGiMc+Jb0rpvL9yD6twnetIBSuWkKy9i2AAlpDep13QmDKX/FjHTKn2ncmuQwT1I0pjRFyJWYJ25uyEBSteZMJ8kRhMDlg5672C5optn26VHfRp7dJp88OLY28nKCE7mipHrVwG3JaFfHRBzIaI11vcogkFJ+FiXDCflphngh2dX4pnyHwSASJ94C2LYB+siVjZ0Os0ANL15dn62c0ki1f7T5k/b/5faOn0mPAW4Q4dm5x9zkC5OoSkNP4DLe+KjCNAhPZlk4nR1GNODsAPqCOIbVrpMqa+8SQa4fzYtaKk8WOHypL+jNiM2V0QRhWY9IVeODJBONi+TQ5ypoRU5NmRAMVOdUndZuoE6t5Idm+SZRLdgPcYe60jLh+LOtGUHnerYQxkk8lDV1TvHanAXjlCv5
 gq5gDnLl
 urrHI7v8N/0G3IMbpJtpGDfGUIOxMCwh46z8+o/7HYVtnBOrhErHUtrkvg6X/DBl+JxO64SbH/gyKiGZc12u5m3Z/d5WLAfvrl3sSAcav3crMABogXK9bUj6tYWRtkAHLrx6lp7xpw3L4tbyTfalGaG7lbHNhh9rYukPZGVGDOb8AEzlARmc95WkY16/t9lvUwgN17QBR6u93iSyWp5NLIUWacxz8E/5IY1VB+0jnqHwMeSPtvJmMl+9auMTFUhsaT0AqJgoOJfdo1aN+tAzOfm64UsIRsi8y7Wvc8ujjc2xUqd6mdAI0vDJb6GNCBRBdaMlKHd7OQlHNhtOXqpGtvGsnocSlUMmVJPdNR1VzkQrkvP87pB6hZN/T3jXikvEoW/d8/dNiuFODqNrHiE+0mtzAeC8t99/NAA7OjBRFU8YS8zfr6I5hqZdoVN3OACbamAIn9ZwPfOXGsWZSWmdHaFdxPX8FCEsQgMSIHczuYwT0mTzjXoeHaSPzw9LMMlyR3skqte7aiyy9CUxBNOdWLZ6ILpHBUbpkCXyFMIm2EHTaUhbV1jGG41p9vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 02:15:44PM +0000, Brendan Jackman wrote:
> This code uses flag equivalences to try to optimise conversion from
> GFP_ to ALLOC_ but there's no clear reason to believe it makes things
> faster. Even if it gets rid of conditional branches, it just trades them
> for a data dependency.
> 
> CPUs are pretty good at conditional branches. But, in my GCC x86 build
> it doesn't look like there are any branches anyway, the compiler found
> some conditional instruction tricks. (Caveat: This was extracted &
> annotated by Gemini AI, I did not actually read the disasm myself)
> 
> Old code:
> 
>         ae50:    8b 04 24                 mov    (%rsp),%eax           # Load gfp_mask
>         ...
>         ae5d:    41 89 c4                 mov    %eax,%r12d
>         ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          # Mask both flags at once
>         ...
>         ae6f:    44 89 e1                 mov    %r12d,%ecx
>         ae77:    83 c9 40                 or     $0x40,%ecx            # OR with ALLOC_CPUSET (0x40)
>         ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       # Store to alloc_flags
> 
> New code:
> 
>   For  __GFP_HIGH  ( 0x20 ):
>   It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the base  0x40  ( ALLOC_CPUSET ) flag:
> 
>         ae63:    83 e0 20                 and    $0x20,%eax            # Test __GFP_HIGH
>         ...
>         ae6a:    83 f8 01                 cmp    $0x1,%eax             # Set carry flag if 0
>         ae6f:    45 19 e4                 sbb    %r12d,%r12d           # %r12d = (gfp & 0x20) ? 0 : -1
>         ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     # %r12d = (gfp & 0x20) ? 0 : -32
>         ae87:    41 83 c4 60              add    $0x60,%r12d           # %r12d = (gfp & 0x20) ? 0x60 : 0x40
> 
>   For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
>   It uses a conditional move ( cmov ) later in the function to set the  ALLOC_KSWAPD  ( 0x800 ) bit:
> 
>         ae72:    25 00 08 00 00           and    $0x800,%eax           # Test __GFP_KSWAPD_RECLAIM
>         ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       # Store result
>         ...
>         af2c:    80 cf 08                 or     $0x8,%bh              # Set ALLOC_KSWAPD (0x800) in temp reg
>         af2f:    45 85 c9                 test   %r9d,%r9d             # Check if __GFP_KSWAPD_RECLAIM was set
>         af32:    0f 44 d8                 cmove  %eax,%ebx             # If not, revert to flags without it
> 
> Testing with a modified version[0] of lib/free_pages_test.c (adding
> printks with timing)...
> 
> [0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e106e99e19bd3b98/page-alloc-test/page-alloc-test.c
> 
> Old results from a Sapphire Rapids consumer CPU:
> 
> [   67.157118] page_alloc_test: Testing with GFP_KERNEL
> [   67.157122] page_alloc_test: Starting 1,000,000 allocations...
> [   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.00 ns per alloc+free loop)
> [   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   70.704460] page_alloc_test: Starting 1,000,000 allocations...
> [   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98 ns per alloc+free loop)
> [   70.944675] page_alloc_test: Test completed
> 
> New results:
> 
> [   70.079015] page_alloc_test: Testing with GFP_KERNEL
> [   70.079020] page_alloc_test: Starting 1,000,000 allocations...
> [   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.95 ns per alloc+free loop)
> [   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   73.669405] page_alloc_test: Starting 1,000,000 allocations...
> [   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49 ns per alloc+free loop)
> [   73.905086] page_alloc_test: Test completed
> 
> Seems like a wash.
> 
> So, drop the flag value coupling here and let the compiler and CPU do
> their job. Superscalar CPUs are pretty neat after all.
> 
> (Used AI for the disasm but the rest is all manual).
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Nice. With the _nofragment() bits folded:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

