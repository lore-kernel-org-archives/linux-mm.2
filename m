Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B0BFF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11A36B008C; Mon, 27 Apr 2026 09:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8266B0092; Mon, 27 Apr 2026 09:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925EA6B0093; Mon, 27 Apr 2026 09:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3BB6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:01:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E71F1A0117
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:01:45 +0000 (UTC)
X-FDA: 84704347770.13.91F82D2
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C72B14001F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:01:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YkX1Ll6C;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777294903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKk3ZzGqPoxad8o9BetIXz6fD01VB9XTvLwJqis+UP8=;
	b=kaNefpsdRikNl7tdWYpzB5p4vj5btUqHQa05jzp3axhIVfxPMyuDTIO0+3XhQ5IoqX7+Ch
	lOhu5AR5Ff8NfGqFpyhgh/pP6MvyFMRZpnJxQtbYyTRugSBfawUFodVNPpl3BAaK9hTTN2
	yWTJ5EcXyIFn1taGLMa3RJAe1YU1ZN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777294903; a=rsa-sha256;
	cv=none;
	b=YoX0RMkEUKWM8gRmt6RNDoksDxzlhMSvmJN1ElwQFt+DGzPM3WCAPQdbDvo9Y+wKtqNXKu
	yVsBVEzefOcAjWtzDTCrWA844G8X39X4IaPrtx27AWK6qWBIJhwFO+Zhjg5Tv6ZVthXN9s
	dJ6/lLayOJbRvAshwf2roaE1pfVGRh8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YkX1Ll6C;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b150559bso81191535e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777294902; x=1777899702; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qKk3ZzGqPoxad8o9BetIXz6fD01VB9XTvLwJqis+UP8=;
        b=YkX1Ll6C+HWCFCWgkVwN5T8yHq1WGBtL1iyzIv1+dGZF9RrTXGYGKqJcXJDiP1Gp/J
         jA5UVkPeeCNEjfwE8Ms+lEdYdfEgoIYN5mwJpkMs7bNHEss1FgxkE2rObXdnXDL1icfF
         HE48lCoXLqTuiP8nMweEVamAWUyiguMed5cxNfU79e1gqEHnXy/SferWkLrugSYEcvB2
         ZATWtTEHxtkwsE+z7J197Z7RwUa3Ryn3gv6V4eLkSNp5uwddfyH7K8hq5myzQaNTPsPD
         orC37tiCQ1k1Hx9yycbtCOVws9ClyD2kagI8OoiuMGulc3Ry7sdB+PGOTlPZtNBMZxEA
         syXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294902; x=1777899702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKk3ZzGqPoxad8o9BetIXz6fD01VB9XTvLwJqis+UP8=;
        b=qlo+uzE+cJ2IzquYB6+/py3dBcAM7OZ/PlnxEoXoq03uyGbq7M8IWvcnPIFAiVNtPk
         H/ADpeKDuUNzn5Gc7UTSDWQnljaIxkQqkZd+YRNNm4Q3ObFWpDrlYKnFsQf/kC/U37T7
         5CNzZ+1zRQiHFMwanm8n1xM3Uywjn8Zef75SMnblbxOMqCUyvNFd7RQ0wIB4ACSPtTfE
         DzUmVafuErXPLtKNiaZOUSf89uevN7Zk2tSit2qJ0Jf//JEzI3b9Iy0fEqe01ZYUPMtX
         pTQtCvJduxYhZtppy+TeSqJ7kpT5/jnr3rhAch39A0WSQ3zNdhCytrykrcAjNJe4yoOL
         pR/g==
X-Forwarded-Encrypted: i=1; AFNElJ+9phHeRCZPEZPkmYpvuu6Vuj9oppcq/agD5dasHJL/S1GLR6T8y7FifQWr4P5C3YGfSUsfme+Lrw==@kvack.org
X-Gm-Message-State: AOJu0YwyxCAbkVUwYyho+O+NjOLqy2L6uDOP4VtGxYHCLaC3hPeovs0k
	6/RWc9bz//woJxK3lwzs8Mho2wu1JVMEgkm0wMJGmf6OP287NkkSHGlHbR+VkfNNJew=
X-Gm-Gg: AeBDieuUYyXBsICW0KyvAcJZ0SMudiTZAmwD1004mlT532hlZMKih6ntHE+vDyI6JRP
	yYxEM3+ZrVtT5VvdgCISLyAzHsFLQMw7PAHKNb2LscfPWnln/wkkKSbbRoXyGbF8WnjZllIdwTB
	HfvtaWI4H61E9hKCf01RW6vFREoafyJbthbaQJI2s0wsTB0jsuLvvBO5HNhIMLZ99Q6NNE8CasP
	FZGCYlvuZeLiJM7llL/pYcXFxhUaGusFMTApLq3rMzDPa0jqSPbERMKmzvCITS58TkVm5VZUoSA
	JvzkLahi2iNztKEMf8AjYlpy9HFU+yXktW0+RHO7prglH89phoP6lzyZ742LuzgtqCHNb8AQVNQ
	d54VkAejtSMIEtCHy35U9O9fgKzHTZ+RWNFBms+5iZA9wRzVBett5d91dXvJdvlufAVd2zKxIqO
	SAEPZIQ4593JU3Qtgn6vActWKU224/GQeg+0RBI7cfMnHKvrM=
X-Received: by 2002:a05:600d:8408:b0:486:ff92:63e5 with SMTP id 5b1f17b1804b1-488fb73dc6fmr477069085e9.6.1777294901488;
        Mon, 27 Apr 2026 06:01:41 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm86264355f8f.6.2026.04.27.06.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 06:01:40 -0700 (PDT)
Date: Mon, 27 Apr 2026 15:01:33 +0200
From: Michal Hocko <mhocko@suse.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <ae9eLXK72grTV2wd@tiehlicka>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C72B14001F
X-Stat-Signature: ukss5odiydy74wcmrfkpek9q3by1sa4j
X-Rspam-User: 
X-HE-Tag: 1777294902-450142
X-HE-Meta: U2FsdGVkX19N5QsBXOSzTPT1mH9+zFaedTcfrCk362KDRCSb8O6P2ljucLOS/ZOjrA9Z+t47Li2ikCf/Foy5op7AaKsYB9FIrBpU0F/EiCflNSuNkdAG05GWXaCzGTySdp2vGBVrDcTdU01xHZS/JizFIsX+DK1Jwn2ZoILvmsaKdh2p732lNNlJP2HCDhrhz/g44+iczzIMwdHbKNWBaXkmkJMq9v17TYy4GDgq73NtaLcj7vfNk1F22xx2qsgnnxjBZsjxCFsqqPno3chcAXhT11tHeS2nBeVWJ5cK8iIp65y0kkERWxVN7mKg8kZ67VV+8sEMt9dirUCsCGXdB8Gwm7L8BI+FeidyWiy0JhFwCvZr8XQUJ/b8LN5+rtv4jK0V3JUv73p4wsFTDGfrlkpCTuzdHFkz23bbkGzlGbMiM8pQXZrRUFTzwodls5AzHMmUT5tjyNLOfeLd5K2FAz5/PjIU2KhOBkCPyb0iQHQkg01/h3an6AhbIKUrRn8kAIHZaLExLGbhmHySbmXRKW+I2RBNtLL2ozio56XpRQxuVSyyjQZvsngm75ybB0vmR8C6o4RsQQmo2fP95I5pYFWiJDfRnDJypt766KYSDZY2+hGCj1cUAiqq4D8YiM9+zr58y+Q3iMyoH8asXZ6t/ufQ/PYmUfrmJ1KwMbsh2/rHwKnV3AEpqU75E7AbSgWEt9KcfsvV8UDZeKC+LIkQvUqhxEurP/+s68DbJczCGGBFE+FcYH09E+zNfTH4KZjcIoS1uq96awuJslYT/MUYPmA9pYnPphyYT5rTpJsuwgZpygW8RO5L0joVX0o+ECx311QChm6s1fUBulXd9HS9oBPnBTJgP8BAuRMgGJkKvDQDCBs9AJ4F6YIOvs9UbYRdTuSs2zDqiJJeTZEfPkQ1tjeK0+kUxiwHDkk0alESnwuOqu8YrxF/Ufmfbu5B07aeM2yAQv5+5eBDn9BZSsT
 OusKrI7j
 AOf8Z59AbwImPzzVK8TugL5CkdaThBPIoiOcD6Q0iTfVG6U2eWQu3vUOrydgpSlyF51SfHmTh0WKU+oSwK0tC6njCnY1S38oCYUkUHgBajYL4AcJrRPcsiR9L5spd+Rmu18Or7b9SFlbn5PHq2M4bDhY85x3q7TXHOMfo2n6woPtBWDHJNnyFzrvUM/3n+TkFUH+X/rQJ79XX3GRX6KAgmFnU/SBhzAhNwsV6fJwnY8NmKmgtmS+v9Kq8TletkaJseizwMk7+WKJlKPLN5yQH10yAfocyfxtyUiaT3g2w5cXd5+UilV1SxHM301CBBsnU2Pdi+w1xGkknMmoMZkwDhTofxPZj9twi66ZKOYx5Agkd1WGY74JbTdJLsrMuE3kscPwRL1Qi2dheuBc0RbFa4BNQgShZNc9DlOWiya7pI6OcOf0hk/gHDrzmCGY6XBatZv7xgb5HbBukgQH/luy4mi5jDdLrCXbH8SwIol5jbkLzyzYdHjjG8CKzqPQTojZ0cMrmwNPZpNTkyo6BLjTbik6CgopR84RMd8cNUrWAZk8D2ti+OwEecJcj9SA2hR9M5ib1ybvldzI7QlNjeYaicKIkrc0bOehaHtjCgD+qeDmDb7QEEF39lsum00UyM6O0i8hFvKs8rnvh+feJ5dWrEyy4rTsDHhCR7yeB502Y8aT2iOUvlfGSs29QFwGHTPcMe6Uq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-04-26 13:09:57, Christian Brauner wrote:
> syzbot reported a possible circular locking dependency between
> &ht->mutex and fs_reclaim:
> 
>   CPU0 (kswapd0)                    CPU1 (kworker)
>   --------------                    --------------
>   fs_reclaim                        ht->mutex
>     shmem_evict_inode                 rhashtable_rehash_alloc
>       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
>         rhashtable_free_and_destroy       __kvmalloc_node
>           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> 
> The two halves of the splat refer to two different events on
> &ht->mutex.
> 
> The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> on the per-inode simple_xattrs rhashtable being torn down with the
> inode.
> 
> The previously-recorded ht->mutex -> fs_reclaim edge comes from
> rht_deferred_worker -> rhashtable_rehash_alloc ->
> bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> might_alloc -> fs_reclaim. That stack stops at generic library code:
> there is no subsystem-specific frame above rht_deferred_worker, so
> the splat does not identify which rhashtable's worker recorded the
> edge -- only that some rhashtable in the system did.
> 
> Whether or not that recording happened on the same simple_xattrs ht
> that is now being destroyed, the predicted deadlock cannot occur:
> rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> before taking ht->mutex, so the deferred worker cannot be running on
> the instance being torn down. If the recording was on a different
> rhashtable instance, the two ht->mutex acquisitions are on distinct
> mutex objects and cannot deadlock either.
> 
> Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> on a single source line in rhashtable_init_noprof(), so every
> ht->mutex in the kernel shares one static lockdep class. Lockdep
> matches by class, not by instance, and collapses all of these into
> one node.
> 
> Lift the lockdep key out of rhashtable_init_noprof() and into the
> caller. The user-visible rhashtable_init_noprof() /
> rhltable_init_noprof() identifiers become macros that declare a
> per-call-site static lock_class_key.
> 
> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
>  lib/rhashtable.c                 | 17 ++++++++++-------
>  2 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
> index 015c8298bebc..841021c67d3d 100644
> --- a/include/linux/rhashtable-types.h
> +++ b/include/linux/rhashtable-types.h
> @@ -131,12 +131,26 @@ struct rhashtable_iter {
>  	bool end_of_table;
>  };
>  
> -int rhashtable_init_noprof(struct rhashtable *ht,
> -		    const struct rhashtable_params *params);
> +int __rhashtable_init_noprof(struct rhashtable *ht,
> +		    const struct rhashtable_params *params,
> +		    struct lock_class_key *key);
> +#define rhashtable_init_noprof(ht, params)				\
> +({									\
> +	static struct lock_class_key __key;				\
> +									\
> +	__rhashtable_init_noprof(ht, params, &__key);			\
> +})
>  #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
>  
> -int rhltable_init_noprof(struct rhltable *hlt,
> -		  const struct rhashtable_params *params);
> +int __rhltable_init_noprof(struct rhltable *hlt,
> +		  const struct rhashtable_params *params,
> +		  struct lock_class_key *key);
> +#define rhltable_init_noprof(hlt, params)				\
> +({									\
> +	static struct lock_class_key __key;				\
> +									\
> +	__rhltable_init_noprof(hlt, params, &__key);			\
> +})
>  #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
>  
>  #endif /* _LINUX_RHASHTABLE_TYPES_H */
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 6074ed5f66f3..fb13749d824a 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -1025,8 +1025,9 @@ static u32 rhashtable_jhash2(const void *key, u32 length, u32 seed)
>   *	.obj_hashfn = my_hash_fn,
>   * };
>   */
> -int rhashtable_init_noprof(struct rhashtable *ht,
> -		    const struct rhashtable_params *params)
> +int __rhashtable_init_noprof(struct rhashtable *ht,
> +		    const struct rhashtable_params *params,
> +		    struct lock_class_key *key)
>  {
>  	struct bucket_table *tbl;
>  	size_t size;
> @@ -1036,7 +1037,7 @@ int rhashtable_init_noprof(struct rhashtable *ht,
>  		return -EINVAL;
>  
>  	memset(ht, 0, sizeof(*ht));
> -	mutex_init(&ht->mutex);
> +	mutex_init_with_key(&ht->mutex, key);
>  	spin_lock_init(&ht->lock);
>  	memcpy(&ht->p, params, sizeof(*params));
>  
> @@ -1087,7 +1088,7 @@ int rhashtable_init_noprof(struct rhashtable *ht,
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
> +EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
>  
>  /**
>   * rhltable_init - initialize a new hash list table
> @@ -1098,15 +1099,17 @@ EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
>   *
>   * See documentation for rhashtable_init.
>   */
> -int rhltable_init_noprof(struct rhltable *hlt, const struct rhashtable_params *params)
> +int __rhltable_init_noprof(struct rhltable *hlt,
> +			   const struct rhashtable_params *params,
> +			   struct lock_class_key *key)
>  {
>  	int err;
>  
> -	err = rhashtable_init_noprof(&hlt->ht, params);
> +	err = __rhashtable_init_noprof(&hlt->ht, params, key);
>  	hlt->ht.rhlist = true;
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(rhltable_init_noprof);
> +EXPORT_SYMBOL_GPL(__rhltable_init_noprof);
>  
>  static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
>  				void (*free_fn)(void *ptr, void *arg),
> 
> ---
> base-commit: 6596a02b207886e9e00bb0161c7fd59fea53c081
> change-id: 20260427-work-rhashtable-lockdep-cb0356367073

-- 
Michal Hocko
SUSE Labs

