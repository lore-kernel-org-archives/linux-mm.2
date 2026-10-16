Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADBBCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1BF6B0088; Fri, 16 Oct 2026 12:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A94B6B0092; Fri, 16 Oct 2026 12:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF566B0095; Fri, 16 Oct 2026 12:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D937C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:54:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 743DE1C274F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:54:38 +0000 (UTC)
X-FDA: 85329088236.15.262BFB2
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C09F14000E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:54:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YX9o41U3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792169676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNk+lPAYmreHNBvy4VSXM9whOEM/ui2VVdodl4iXdms=;
	b=JllHql5+Z+3gEN52xg+ENyMseK64f7+nKNJeO5NBnr3wBrHQB98Pz0auBSsI66bw9/01rS
	vNrd+m+bwCHkHDpo1VnS9iP7/M9+I0q3rGt0N1CL20LEO0H69KNycLAv5s2n/JeBDLXyj9
	gK200WwsrhdPHQBwyrxgxyaiRHUvL+M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792169676;
	b=oXCoWF1VvpX82LQYaDxIzbk46vgogSy4UEB93hgzMG/SPwdozdPy1MYknV/4tvl74g2359
	bDxcui1skTbpjsTPiRJgaqiug7ibZLugaztnCDWrGle0jB0qP4EV8iJNBwSB/OLT3v7rVQ
	rbHw7WITdFwB5t/Mf61Bh3b2x6rNpl8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YX9o41U3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3514b90bb89so187153eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:54:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792169675; cv=none;
        d=google.com; s=arc-20260327;
        b=gh6BqDYJt7MQGTEzla9oneYEFdIzSDR4vk6mRBbKvMCytoKtKvGEaF8Zh2KsRp05Db
         Yt44UjOaxMHfnZF2Xcc4Is5OfZ8rDnizGj6zyiyuBbiwa6CSP6iI2PKu6nkR1Pl/JJb0
         ZX6vJo+rKHrvSGGG5dkbqtNdfJ7vLzZyPEtaWyMsVAF5Rg2nOq2D4sFYERQpfkjZ+r8l
         O8BJA6fFaAy9Q1cz8mn3QgHKSHtbq8ULBpJgVZeOu9lXYYSsJ0wD6iZfAJZ2jqbWJdVi
         qqEry19RUez9shq4RomrsmJCwbPtIDJ442SfmKkUPsTPgYTTuHXCzpfUKErUOdcXYwyQ
         unVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KNk+lPAYmreHNBvy4VSXM9whOEM/ui2VVdodl4iXdms=;
        fh=+e093DU+vdqgSpT4/1mnlCJGIIfFRzfBerJ4WsVjwOM=;
        b=HSsgHoveOHB0i+7ms0KrQuDv5NH+fN/l1M37BvdddAVHJi8kULwcL33QFrbWvK6Ipq
         6f6RUwK9wOWyiN8yYTMhmGE79jsHAD4ENWfHxaZu7JTbeP1+m2suL+tyBzLGOamIjiSe
         lRTSADBgo3bDfh1yOsZi+tLTGwWArqJ+OGaAO2I1MHZsMA6PR+qK5+jz/SBokkO/iKoV
         /vnW27MFXyh2UzBFf2NjDJPyUML+kia57m1s785rLo7l886CqqH+SxWDFDRc4eTUmpxr
         XFcPcmoAh10rZ2hPR4ZibRst1Uol3a8deUzX3OpNxvR/iy7madssgJOBCVMiNHu80rQn
         zc6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792169675; x=1792774475; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KNk+lPAYmreHNBvy4VSXM9whOEM/ui2VVdodl4iXdms=;
        b=YX9o41U3MY3FZhISeQa87WDq5ERReCvRs+B706JLf4mbIvcyG4qPHMKMUoK/4lqbRQ
         UXCz6y6hfHhiWfIFMkSa1uXpAVdSOF3FOYcksWLs6O38+tSViJBeyCFPsz5tWcSqBfdn
         DyyGzhhu6nRitRRrSsePqM2H6nA0U72gGrGRaLIK2XRvD8WsF0bzkWz1xH987CREotjY
         Sc7/LpH5UpqgyTcZacfdFuxH2OhkrTJS7KikJcPcxd3JNkGOqrfLMr/HiWLLURsd+/bo
         LKRpmmz/5JIUcWNU+GSkQErpGmQ4DkwuYGF2FDwwdAzBwh03Db0SND8oAAnFUPE31nbg
         44dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792169675; x=1792774475;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KNk+lPAYmreHNBvy4VSXM9whOEM/ui2VVdodl4iXdms=;
        b=oI6RXZiATGzQHTr28Az280wsu0zUoSeRY6tmBbNN6sQPqX2Gw/eyV1oJXJVQVmoBNp
         OO8CA7P2246g+Ub+BUUXGAXqXfgZlGpr9PScQxNaLHQ+BhbKIP7NlaJHNX2fhjBjaxNq
         lJv7138NMq0geGkP6FxjiTyfzW12QZ0Uo6LYjx2MbHMx+fH4vjyB6MzjLH2jsTu81yld
         /HKxnIMNAeDk8hfG7w8LF8Rm5KIK503JRXDT1ElxghbHuqF65asy8IQJ91PQZcpUAaqJ
         n4hjSihk1CuCB9T1avUU/32FYznCAlX2Tj9zAkUE5JjMitLIZel5gi210uYdgBx5cRvL
         4VKQ==
X-Forwarded-Encrypted: i=1; AKwUvByZd8xG0KVU9wKcUwMB1u74wJvFxxG+bK7lnYGdWaL0t63TeOtqVSN1b6/aYO/VQv8Yw1qz7/3qjw==@kvack.org
X-Gm-Message-State: AFq9FYKXUDW/OAvZ6DliuXJQZeUyAmgczpljBAswyg5kObPAKoXhdWFy
	jxyqoklAwGe61pK7J6ZmMxFhqF/RVJ2jOKCXFWxT8X8rhwWdbc5Ok6ZfOh+7OAatDpXW63Ox3PZ
	36ObzOq4P4KcMhtD8kEXO9RA90iGpIRs5VmoaPrDn
X-Gm-Gg: AYBFou3nbT/OJ1TRs5Q2X7FW5qe9QSgxhyz/yZTrRxCbI/yxapytpZkd9njnk6DcgAc
	YdVX/svmfkaHXYMKHxATw52/2u0Pw5Pjm5i4airNdQaVXKIdJ6AmjGwtUhdCcf4tKVEPsZxanpy
	OSVjzWNOV+0F8kg2xbCKnKZTYdYhmp2Jfhqyyo/L3qDqtPegejJqZ8uUhVJkR9W44u1HlA1qEuE
	5lpHr7MtRRM64nZzGeDgxXp8uWVqG/6W0mdRDJ2KhFARJdhkpcgqVxHmSy02ihj+NTAzvNCsUSo
	Yd/O5UVOO+M8mjHIV16FPE7pKS0zxGDwralGRYHc442CmsKhOy9pj9Vp7LjzpLHOTUlZDKPoSCG
	H8BtpXEgZ9lo=
X-Received: by 2002:a05:7022:fa06:b0:181:8948:f017 with SMTP id
 a92af1059eb24-18513b9aed5mr734680c88.41.1792169674334; Fri, 16 Oct 2026
 09:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com> <20260908-stackdepot-trie-v2-1-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-1-1996d5cef732@cloudflare.com>
From: Marco Elver <elver@google.com>
Date: Fri, 16 Oct 2026 18:53:56 +0200
X-Gm-Features: AclHuK_WxF5EESzu0hGJdibTwB6wHoZiUHQsU4A86X5DIragIIphY4_fzhWq1Ec
Message-ID: <CANpmjNPGWC06f+gCu9gwjnBQfJigVyK94HOFOT=en4t3Pz2r9Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 01/11] stackdepot: stop preallocating after the
 final pool
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C09F14000E
X-Stat-Signature: 4g5qiz54jmk5gbua6qb7gojicq8zhafm
X-Rspam-User: 
X-HE-Tag: 1792169676-975549
X-HE-Meta: U2FsdGVkX19kdXKruO5QxMo+9lEpNxs15asW3U/xneIId9eY9sEsWlIpOXiWg7MvE/k9T8qWboFF6bcGNl4e5bAFKsauTQqGy7GRJ/zZT3ZUGtL4o68rwlFXE8I6rsrZ0dzma9o0dNgIHq+0iWbfAM7VNdWS3JdirGmK5U5InK28hY9qKbG+0ALmbGAUkmzoptu3Z4e4jOluLCAigPVX2hYWPwh0QCS64QyFOX8lnrndczFYgfl6pNB91zSu3/1PWr7kjR02jlrs9GKhOLmQ0lWfNJtS5BS1WbwfVS16YC0kWp7oDaqRiwX/4ySNUzpqUY3rA7VbynFNXcU6e/aSxKZ3aePdk9GzYj4Sk94VAt37fZB/tXD93Z9LMgHxb3cl0kD46de/R7RfQEauUWVmiJZJ0hqgPFL2ZxCxZ3ATmpzgMNL/CJgFnW6Gex5mQo7c3k1Rr1+Tuib6eXcNER7B7ZFjIFOP7IvdmhQKmzonXFL0hJOnqLK5isNRzeD1VrBseub1h4pv2ZqSx/3eEdr/MWnhWTb7U3hGodyEqUm2q2MZ6NPnZVJThzTgJuL9PpbqJ0klG01Jdm1jFhwkVrWEGaiUN9gyRUABosZMgp7GOWZFwu1JLrbfc+tvqJ3pL1+c8Ym3pgvaKgT1GtRy8czj0bbtFj/8q3YmlJwn5wh3+tvEKtN9qiwY17UEVb228zXskFAN5H6bdyN8+cMclF0qn9XpGdm5ezaCoftLR33ZRX1WUldIFAamOaOuiqge+kze7zAiMRxduKUXOAfI6f2lXEGaax/XxD7lymaZLINLUQ++MGrsOGeaPaoSPQpRXPdC8xYLQBYOUrJ3Anwa2q+phHJnXEHbUP1mPJBoAOyWsILYqh1w2YquE3a0dfZVZe/HseJg+0I5nYIWU610ww2rM4RXvRDRqApQWRXhMqKn1ns/WQB2h8vhcvRPOkDJuycbn4oCXj2pKJTXY4BNYoJ
 zLLm20LS
 tLM6kfOV2wQj9rarU8G0wnEOLQ5xkcu30P/rs1wOkntBn3en7mujBKZ03No3yw84iRjmVwpqeHZAsY6llAveta7gSVoEORhWynS8umZOwkcClH0fkzpHwIXFAKe26WzpL/batsrcu4DedWf8LuCSqNM/bsW3Yji89D4xczXLubX52aVf7YaIl1EFF/okgX1cIvJ7jVOY0spUTx9gNllH+kcYb75UoKKA9W4Gs2K0jJ6thYkWmXgCF7o2nrC3z5iq2gJlGSpEcazbs7+R1cHc71EO4HXTfw5Jd0gqk8bVnqXy3UV+qQ1YsheLYBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 8 Sept 2026 at 15:13, Caleb Kan <calebkan1106@gmail.com> wrote:
>
> From: Caleb Kan <ckan@cloudflare.com>
>
> depot_init_pool() decides whether another pool is needed before it
> increments pools_num. When it registers the last allowed pool, pools_num
> is still one below stack_max_pools, so the existing comparison clears
> new_pool.
>
> With new_pool cleared, stack_depot_save_flags() can allocate another
> order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
> in the global new_pool, so the allocation is not lost. However, pools_num
> has already reached stack_max_pools, and depot_init_pool() rejects every
> attempt to register the pool. It remains allocated and unusable until
> reboot. The non-NULL pointer prevents later saves from allocating more
> spare pools.
>
> Account for the pool being registered in the limit check so registering
> the final pool installs STACK_DEPOT_POISON and prevents the extra
> allocation.
>
> Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>

Reviewed-by: Marco Elver <elver@google.com>

Please send this separately.  I hope to find time next week to comment
on the rest of the series.

> ---
>  lib/stackdepot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index dd2717ff94bf..90c52f2e0d3f 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -323,7 +323,7 @@ static bool depot_init_pool(void **prealloc)
>          * NULL; do not reset to NULL if we have reached the maximum number of
>          * pools.
>          */
> -       if (pools_num < stack_max_pools)
> +       if (pools_num + 1 < stack_max_pools)
>                 WRITE_ONCE(new_pool, NULL);
>         else
>                 WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
>
> --
> Git-155)
>

