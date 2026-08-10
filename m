Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBCDC5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 19:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB5C6B008C; Mon, 10 Aug 2026 15:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B0D6B0092; Mon, 10 Aug 2026 15:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659B26B0093; Mon, 10 Aug 2026 15:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 392306B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:09:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE259C0271
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:09:28 +0000 (UTC)
X-FDA: 85086298416.25.41312D5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id B000780002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:09:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dpne0sNI;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786388967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85QqMALH7INEGXTtVF1giRIfVxPtGVRsSvUojxcJqt0=;
	b=5gWIB4PJ2+9H47EoAOPhmO56twF4q8wTZqDjw4GsSXjg1bB0N4BnVM/t8GmLW+OgiFvIp1
	Va/9kWu241UQSO7l9gQRP2gmVQBptZCvYr6VKWMa9YbeXASqNVAgTJOfXmtxbP5gT8dvMK
	H56luEmSt0KSHTjPA44K3ZLLVSUSgXQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786388967;
	b=xQhU+9Rpc3EGZg/9qGVlC+EpOs4YyI8/SgbM9hM94JNBJE99kfTqa2MtJ7AJjSUKyWt+cA
	jeSTOh089mZYJ1e1oLCPqIaANyijtoaGR6zOkVrpgv3pDvZjB6UVrpNNYeKdxO91m77efx
	Fcyd9luRM7I9UcFGUp0P+UqaXyCPO8o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dpne0sNI;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c04bf4711so22016111cf.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786388965; x=1786993765; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=85QqMALH7INEGXTtVF1giRIfVxPtGVRsSvUojxcJqt0=;
        b=dpne0sNIFNo2CiBhpViAtYmQlJ8leJLvAOIOn/g9M9v6PKecBOapyboi/026r/zqqg
         J+VXPsnGvHP3GcAbDOLqz/K0lUDVhWrw3Xu/RI8zidEFQRJGaPfNHnh19xzw8ek1KRT8
         rSntEG2x7y/SR9K7ACOlb3ZmHlplDsfx/W07nIEqUOfFU5VrpGVa5l2tKjyUBPgsURXd
         1FaNDWD+EtNFwmOsE+R54nwDRnQ0yWHmJfYyE4dbmjmPAocn1+UKyFayx8esv2sveeoI
         grh+a+Hvi87opGbF86rGC6AD2QS2eC+MOgngNFiL6iRDDH5CRwf8l87gpZdewPujlg4e
         j5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786388965; x=1786993765;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=85QqMALH7INEGXTtVF1giRIfVxPtGVRsSvUojxcJqt0=;
        b=dC22V3K47YIqUmgvumlY/PQpwvNBqOASwjve3fJ4YXKtx/oa3kAe2Vz9dnKPk5WClX
         CMmRlEevArfYcoZHBmcJVPTqcEURrMdIFQdN0qgpqqFCuYyu0KAsIXuMi2HNwLlCn3pZ
         q0CCc48Q0hmhojPIl4h4NYb4o7fplNdOZq33LdfXuT79UGto/H6xhCXzSzXMwOftLkzG
         4vueVnOa9L2AyEjgXtebJHPFHdf5QnuN3jDLTK1FF535I2NTM2X50B4MTJttpFxJBtcb
         66XS1hzFAI5K2rOfEZdRKg7lNWUoCbWbcg52GLfhMfMHXg7FbHC/kDqlvC2uOF4RX39u
         Krxg==
X-Forwarded-Encrypted: i=1; AHgh+RqSGLSEAHOvwajmD9xJdLxJ96uRQc5zTxFHAnfJQojmW5NMPIkUDO+q/uR/JYGdFg4RLAEkaDF7yw==@kvack.org
X-Gm-Message-State: AOJu0Yza9OZ/AewBJCUlmOZRzCqyMT9GIQ1o3m+ErSCty+NPXC92ulOM
	KhEiKxiEWx8ykhErQJbEkbFjDYXJjySbH9LWqYR9dsem0udxrInPtn/SJ580ACDE7R4=
X-Gm-Gg: AR+sD13qvlPjGWSigBpofGp4BxYqMFnbN6Wvr6BcfKTCm6xY277E9WkdtdixalkxgAv
	rEAytvg//UEXBhO4GIAqXMlNUt8LNyPf5lwH44aETu4ZX6uJmuLC3P2u1+ZdSi515L9SmsGXptp
	It5m3FI7A/15kqRRkmhO1Yexh30iEGwQ83Mn+MzqRRQ1V+9dWJPNKa7kvqroyF1irlYjy1fIy3G
	/nNXAz1G/9Q9dKplQJZDPVYovyoulrqboR81vT8LbhMx8d6AbaJctCFM01fDSjH1nU9Ix6QuV6R
	4/Q+pbFePAwB0CyQhRB8gZsIr021XKRV7sy4aBAV29HhTpyUwYILHxqfb/W3IFLL9oPEhkH5uXj
	tRlCHjr7sQ42XiFEUw9BVU6JZEBkQ0XNEq6lqJNu+ZkUCMhLuxELw70kPIHsCeIY65ps+ftmFK2
	UB8xVJgj6gmMRGZiQeo1B3HPlzjJhUcPYzg2cjWtv8w/tgub890Q9lXYaMBlRvhp22H9RKEitpd
	Y27UwjZlw==
X-Received: by 2002:a05:622a:4811:b0:52d:3352:f7ac with SMTP id d75a77b69052e-52d4bc69744mr47975431cf.28.1786388965496;
        Mon, 10 Aug 2026 12:09:25 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16337589sm78043431cf.6.2026.08.10.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 12:09:24 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:09:24 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-ID: <anoh5K01Qcn2t1Xh@cmpxchg.org>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810074247.52747-1-guopeng.zhang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B000780002
X-Rspam-User: 
X-Stat-Signature: oky941j4h11d5mfk1q8k5bpdakgs9ay5
X-HE-Tag: 1786388966-188764
X-HE-Meta: U2FsdGVkX19ZcFzEBhgcU8asFCnSIwLypT5KA+jP1Ki4O62plZA4OWVxeE3u0vx1WJupZBW8vm9PiMqv9bvkkr7FymTscVejOqn1bvCsXQOn5vSmfERITyniCN3yR+ohHne8OGFie8piJ7PMQi/N3a8VGcyOOF55euNt+rWedxqqwZKVMBhbUolceRsQusRsR7CsskrOPGXsUi0h/wYGo3w6QUJmbd8k7RM5+/Ae1Qf/RGJNVMG8lGga/ca5mN5MZgu7TzZ7djpyWlqA8mFCYTnGA9V9JURuohM9HNWt7QjkcSHYu0UQ0MbRjUl1KA5rU7Emj1lVhTNaq35zqhjjR7KYQfJTGAyUKS2ZJDSklGySOnC7WKPAcmO/Xe1Hx7JS8RalJWmJwgWjgyk3GgV5wPzF+Dt521iM2dj2NKqFSCRLV2YnwsgqRGM5GNrfDZWDL8Ob6gB63bBz9ln0yfs3sFsqir3c7WhFjBcpmhPhijWcExnsbzTJXXR0l+Z1ngsfU/wB8SSC2XSs9GYghSv2p1f51+XPjN2faKAMi2sIXw56kauW+VXtlWAGrX1yoQi/vVXmUbOmDAOItYCbqOPvqdbkekNEt6wN4IHUQxyNEVv61zC89elVb+RhjH7ObY4t3QhVfuFvu4sCGsT+qj3rbiSCgm0GIQV+OkduBJBtdSiJSLc1pX9lqbgaRMrWUPBPqiOV/keaiEY3k9q+kjSTCf6JQr2dImbJEUBpAoygdaDAfnU8FcrdYa3O1iz12VSVbP+TN4AHhlOwW+riA6lzF9yhen0XyCX+F0By/NgCJUxb/nKIiwr134nabl8qVSnJ75yUc/TR1234fAbvQ30QO1DtFE1nL8bQsV75uX9n1rzMnleATJTlI18t8ooGxxvpFXvcXSO3kyNn4pLHzZOCJiBXZK4J7JcTeIwGwTQklrMfe/20GEdDoKtAddCwRt1iHSj1LBUkuPp7RGKlkQf
 J9pYDtBX
 5QZk8z3K7zsxsa8Y1fM7pY3gWKvj5Es6fcbF6mgR7c0y2J5j/hWUmAi1nH0PBuARG442a0U1Zu4DPEEzK6jVJBffrEmIVFXVwTc78S2ZFD5DChcS9AnlAaz9NF+XOpC0+fdEqXk8XHRkCucgZvsyOal+c0JYi4vVjQ8Btw/XE9fZ0v0cHDPuuMGqC449PA1M0MWANy2e7FqqjXvmK7x/U1QC0MvVKyoAlCctqb1M6fFn0ajB7NFAJsJrr/ZSs+5qOUL9ZYVMmXdP6WTk5JYSKGaZ5Xc2XjGXJ4Bfs0iJSKXsyAJnNWuXvKZz1Aw+BytUQlz5WCwdjK/CCRVkgctzdE5hxL6ToGqMQcn3i1k4qZnDENbjLuje5xF9PuUaCyeiMK25h6uwKKA/K0xEgEZGw0X8h+TOqWr5h0DKT68aNqnV8ztY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 03:42:47PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. Enable failcnt accounting for the v1 memsw counter.
> 
> Reproducer:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Sashiko raises a valid point. kmem.tcp.limit_in_bytes is deprecated
and will warn if set, but the functionality is still there for the
time being. No need to leave it broken until it's removed.

Could you add

		memcg->tcpmem.track_failcnt = !memcg_on_dfl;

as well?

> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6939a4fbb991..4ffe5b3733d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #ifdef CONFIG_MEMCG_V1
>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);

