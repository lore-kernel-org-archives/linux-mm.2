Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6839C61DB4
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51246B0092; Mon, 24 Aug 2026 09:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01D66B0095; Mon, 24 Aug 2026 09:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17986B0096; Mon, 24 Aug 2026 09:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7166B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:42:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 276D940141
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:42:12 +0000 (UTC)
X-FDA: 85136276904.25.305D259
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4567D80002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:42:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Iqrf/pAt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of sef1548@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sef1548@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787578930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HsIc5oa7SfTjXn5HfpWF7pds//yxw1/dVq8mya+hGA=;
	b=3BG8urtjAn3mCMjx2pckyHlwTx/Qmpj2v7PiNUpl4Jxha1iLKHgNBFPcqeqQlELtnVIAX+
	ZZ7XGSlnvdE+DbyydlTTb3FmVbiaPeWDb4HAuGfu1Zpgw5S/QKla4C32qL+0mgbfebPta9
	eJzCzUt+kHAChzIJZDf5OINrKMMXbM8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Iqrf/pAt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of sef1548@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sef1548@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787578930;
	b=A9YzSkM4Vrr0Ko+ei34Su8Wq6J44twaE9mT/QgdDXr5viU24siMl+FC3507oBBGmTIyYkc
	qusMtXOaCHi7Z5cJhiSaLzS3fh9A9yOeq6XT95eZDQGS2W/qeANSoM8m0NKvHlf7MsfPYo
	mGCwS4AcjmZgK+F3mKVaAjLC4aMGtDs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce7d2adef4so45923905ad.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787578929; x=1788183729; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3HsIc5oa7SfTjXn5HfpWF7pds//yxw1/dVq8mya+hGA=;
        b=Iqrf/pAtVopSqe8AtXl1a5467PDI1YHMMCgw5BrOL99R0WrJVAHlYyqvbjfl+TLUQV
         e6mXGOnLKxNFm3D1oHh4hf/TqRYjM5jcIzDmGDYgj/OI49NwFPMrdcmRKAfJmU6AJAxQ
         6kr5u6eidQW2lF+shk6yS2tvZJitRUogRWtwvKIotxvkfVoTksfSC1tJbXw30wOHd2UU
         MbFBt5ChMzGGAdp6IEQWYXjsE+rPlP3wgcrt9QD6AKQxy3fIro9Ot7zgeE2CcPginCPB
         pbujRjzuKn8PqU6PLwOOIZUGU6WMcYiJ7b+0VhlGJj5J79F8PEHVs4+7bgrhgf2a1ct1
         nFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787578929; x=1788183729;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3HsIc5oa7SfTjXn5HfpWF7pds//yxw1/dVq8mya+hGA=;
        b=d2Dv8R+9Ohjvg9R6Eavj9wztqixGQ1yLLvugL98v1UMelF2inTmKHecev3Muwrdaea
         P9/sDzCsAWjMbsq4i5pXBmHeSLxPQqKEpazrX0tdHlvBYAa0y08cacbDAwABVDpwAHrQ
         hPi7TT7Liq4VLL4gEjLq3XH3InbiEdemI8VeI1BoNcHOOL/HoYQlSKd5k6lIgJSIr30k
         1RHT+wOL5NqVLTBuaYxQie8vXsRItH0hIPHI5S+t6eD3+5W1XlW70QATw8CfiqXRjUZU
         YBgROG2JFs4yO1Kv1IJz4AIma5ZZBSuI6OUI1bKUxc1p4SaCo9k3RI+uWGHaCJThVXHy
         Ropg==
X-Forwarded-Encrypted: i=1; AHgh+RoCeDy3u/6J75R59k6SyWFNB01dotAX+o5v+bD1V7lR1EVP1EyIxVcGfLQa9rUeAvQqGdBZsDDhkA==@kvack.org
X-Gm-Message-State: AFuF++m3iKN8bE1oV1sh1oN7yDXRf/PLSL9qIVr6qR8+PxXt3cGk8HZE
	d4JRzCWmfMtf2bKeVe6tqIfkOQuCW0ZY51aEvIaI3AVsnU3ytLyykDS+
X-Gm-Gg: AR+sD11YQgIFi9fZDKoGV+vdX09uhWxc9cHuRQ2BcclIyn2umWNmQ/4rxmo2sltYoqK
	0ppKr7ao4KBAjfupBk29xG0b52ARQM5WkFPRjlhY8W8Pa/WHSHVQQ/gzgJLPA+wb2Ag/IlBRusL
	HUcVI2mIjU57zK7hEZs9/W2IMOoXiNOXZx0KfUJXi9Ua+eMeA69ZlLiHhPj493pJF1uUfGP9d2H
	8TBwDDuBrzTr65FVg6pPXWrWSkmIvh8tfsYjWXuOIVlCrgk2vZpbY5yclTaCkj4bZz+aTVHKQ/1
	+lU6c6nd8KYwFfjWK5PKDq9ZzP9tX28GWGek4Y425NqbZyiKUxC8NOzlJ2p+sLc7RvE2LRz/2YO
	BWumFZgqAAcQcgx1MrSFA4oowAfraob8OiPKEWsS34vdK2M7OHMdFEMdIwh8xUNclsqjGEfvmtN
	y9WhAXPM03kTARFBLTEOFDm0ojc/akSKsChnq6MrlF9ysogWiMSZX9YIX4YGr9P5BWu3d57cn1C
	Yp+QEJuFkZOMMPh17Agqj63knhxRWu7DHZEJ/WFLWgAq+UeXbabUqUDgTJdXQw+1263DOJFVpBd
	SFW3sphmQfLE
X-Received: by 2002:a17:903:19cd:b0:2ca:a03a:29b2 with SMTP id d9443c01a7336-2d64affe4b4mr509346545ad.8.1787578928941;
        Mon, 24 Aug 2026 06:42:08 -0700 (PDT)
Received: from nickhuang (2001-b400-e2a6-81a4-7c3d-29c5-dd1d-e725.emome-ip6.hinet.net. [2001:b400:e2a6:81a4:7c3d:29c5:dd1d:e725])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6768dc09asm18001275ad.76.2026.08.24.06.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:42:08 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:42:01 +0000
From: Nick Huang <sef1548@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
Message-ID: <aoxKKXjs3o6jUanE@nickhuang>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: t73tohtn617qtd79s5s1pkkwhqgr64qm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4567D80002
X-HE-Tag: 1787578930-259242
X-HE-Meta: U2FsdGVkX19yHFj5SuqghAah+d2UYBHFOtATiaNHh41DjjDawaEm1W3XlprHyisSE0tHomqL2efFFGe806RRsths02lf5HCoKTkA1i3c4niDxOIP0nZqVM7KRW1WYPN3o0i+khLFKBlz4cMm1+sQidWFt98edJ7XTKqolwIsE3gyf8nmr41dT5gEl66a3BwProtZn8unf7H/A2LVVb6Ly5Z2lOZnZiCjNts0sybVyuxuo9ft7w9+/mFrhlFnwzfjdZRQfc6HI0ZBYxERUoSknzSsV2RCifEM12Fy1mHaQIsAhQMPSmpUGFmAcuWckMv9oG2429cIdNbXNFDxrH+NAhyL434lOH8e2TBxWujW8UwSxOiPcPAYx4Tlw5cvIskbbMoQ/9/UDTOIh4+jS+fXltZinYfGm1fiwDSClfNfAARGc2OsgtzyqzrhTmLNLhh3ByBXa6JmC/Fup6W+1p6bRcVsRi9dTEqFYux6QlXh7742RtMsfT4DX03CUtNI/wNt+1uy5uvQqmK0Q0bz1qm0dEbPF/cLsu37po8fsnrITlKQaLNJ+uEAgkFzdhEjuEgHXOyQgb2cswkAqYPNeEIitgrmsMHgWcYjG+x6FA/OQMs8W14dt790MU/nfbFI3/pkKZO4q2I/slChtzgNpcK4zJa00PIg+4dDykpTpQpZX01sF4iBiSO2oNTsGG8xLwM4TegDb1zmthJREuLjVrhhpEv6AUQAa1xz6ZG7DXYgm/h/YRJZgBkcv0htS3YuCW9Y8BNEj8eb6rON4wPy+iAy2nQZD8rcSneFLme0+MKnyVTDEv0psi6lq/mqDY11UtlV5sxCSAnnTgNhs8CbGa7l5Tfsu+FsGJZztfsZbOpGwOxP9IW+Ysp0H2BTeDbK3P3aCk7OCln6zAxUAk7D0m7Na3osejCoVmc8RIDhsox0CPDlaFnCXAg31tO/gpu33cKvO4cam//hiJ8HC6NuZaJ
 WLQxnluK
 174FFHa3byYW66/WbuoYvNmJR1lZwfvp+SCp8gFWXP8pc+JGOZkNJ2cnerddcC5fRD/w1GUCcihHyzGa9uMBuHKx/Eod+Vh8SX1Oeuy391PvOr9vVyVIzPBECszt5wJ8/9pWX4ioER7sNGQJh7iFR4rqDHEaSWKe8nZWotXydud/hlVI7tUjcf/EOOnz64lhB2GIkXTXOMLcLTaqFLqcppL+w7C609uRLU0/vJ88/IFnb8eMy4595x4ueuSr0sPmcDaDphXoQcLB0ewxydTHAqeYFpfcBPScvePXkhiW9Wx0PLiHMoqlBYwpvhIg9x1qH5m6Rs7VovD2VrwLdTxK0rOMbFKg4IopLgT+dOanofp7oTc9M6UJvqjHxCWBID97qgGHO7XAQsLwMN7VH8v+/JuRyVCB87F0ewl28kPKLfsOZTHiMAQShroeCa+Fy1c6ZxSVNsrC8yS+rkYu96cvfbsqr5Yfk/p3tn+6FrJCl2Fv5v9yzcByi2bKizjOQ6ETbqjXEVU2Lm0sTOxev5fzcWDIBOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 04:20:48PM -0700, Shakeel Butt wrote:
> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
> 
>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>   RCU nest depth: 1, expected: 0
>    css_rstat_flush
>    mem_cgroup_flush_stats
>    zswap_shrinker_count
>    shrinker_debugfs_count_show
> 
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
> 
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
> 
> Drop the rcu_read_lock()/rcu_read_unlock().
> 
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/shrinker_debug.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> index affa64437302..cda4e86428c8 100644
> --- a/mm/shrinker_debug.c
> +++ b/mm/shrinker_debug.c
> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>  	if (!count_per_node)
>  		return -ENOMEM;
>  
> -	rcu_read_lock();
> -
>  	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
>  
>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>  		}
>  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>  
> -	rcu_read_unlock();
> -
>  	kfree(count_per_node);
>  	return ret;
>  }
> -- 
> 2.53.0-Meta
>
Reviewed-by: Nick Huang <sef1548@gmail.com>

