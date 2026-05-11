Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D711BCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259B46B0098; Mon, 11 May 2026 07:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230E46B00B1; Mon, 11 May 2026 07:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E536B00B4; Mon, 11 May 2026 07:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08C8D6B0098
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:48:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8A6EC23AD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:48:05 +0000 (UTC)
X-FDA: 84754965330.14.902DFBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12AF1A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:48:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fe3xEr9A;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIIxopnv8C1lUGDURtYfvYK6BU81eY+4ThdK0hgccwA=;
	b=VxGsSDl05vYbiViF7RhxheBQVEuINa8QNACZlqrU7MUuPMyMGzJubrudG1Sx1w5ieCm+MV
	lwQFp18OZXhiEB9gHPZyYUtySwI8S0QyAtCokDidKXvK11PPBnhV0Ih195vyMcLOGt/DMF
	7YZdG/zIFJEMsONTqgI2t7cJUxs7HaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fe3xEr9A;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500084; a=rsa-sha256;
	cv=none;
	b=SRXN/BYkp+DVOyOtDvgyClUq1xP1AAGZNoEcq3N5MXZTvKuktTiAhjJu3zGMLL1yqySvvq
	Djb0JjcZb9M3f6fD/2IqntITKNYnWo0DjzX6oV5tp5gS5+7/KZEvJ6lNdfXLhsw24ozjwJ
	eljFFo70RN+BkJJQ9t9bAZ5ZPG9YbGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F4FB6001A;
	Mon, 11 May 2026 11:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3223C2BCB0;
	Mon, 11 May 2026 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500083;
	bh=a01/upDufgIp0Xjp/MMIPDmLlqZSzAcbtUi5lVWoWUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fe3xEr9AzWihxUV7USwOkIUobn90Uj3D56rO9BWkXhDrKfIyqOmm0JdMCPqImocM2
	 bSMxBsQ2CEs13+7MgRHrC9PvJroEkc9lTzgFUIOQnGmQE/d+a+Y2cc9dtQ2LtjYNqO
	 xUvVQFfwZxB8YLJDIy5vcdt+pnJ0M7kWsMOW+RXAtHf5m8KZgXFYUBJPXQPIb70kaZ
	 yP1baEh3GJ3HRLWtGgG4OIR1iBcC9AtA/5yY2/esmrs5SXiMKuw1mmfvvm3qQUqWWG
	 scRytITxa4q6GvG7pp3y1MvTMisYMf/NPl5QAUidcVOLRCa+B+QaLEWbrS5yYJjPXC
	 RzaNwP62qDUFQ==
Date: Mon, 11 May 2026 14:47:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kho: add a struct for radix callbacks
Message-ID: <agHB7HB-p_vkLS7R@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-4-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-4-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 12AF1A0008
X-Rspamd-Server: rspam06
X-Stat-Signature: fmfeyrf531r7esa8m56obciqdekewpb9
X-HE-Tag: 1778500083-855800
X-HE-Meta: U2FsdGVkX19wcDW4qZtjGxCES9xRj+F3bAy5NKKo0tX2/KCyVHY1PU2g8s7oTcRJSpV6xQ/yxGIV4fzHktHPnJueWDlB7rxHJ/NZPkzWF+cbe9sjV1SOqBskhvVeAOgN2RdoOATRX0SaQY3xpEwh6uKYDrbyYoX9UkIRTA8+ovUR2mo/ey9fOpZ2Rb0P5UB3Xy9f1kFcX13XJlCr7kEqWlTKE2aIK2gI9UVllAIu1/CckhetoKhDnpaU/EaHc2+Lvzl99BlwOKjxAtT/OZIja8saCPUfwdSA0cA7mXd4BjfenTjrhwsDZc2nDUiRZHpSRHuKtYNVGEy8cP/2bCR646KduWx4YDZ4K5WKSOY32D0NtXAZHWKGRBi6XRKNuw0A9ZPEvkDeCVWyxzvUClJ94rwoiCXnTfcUAUTW93F0G5kB3Bwvy8sIi3eFFEsL0WD1X1jBhdTKmhY+4js0yHwpx6EXr8FgbWoMw7KWcp+EIt1PyQC+TyGFm5RfdBeBn4tD48k++0dgr9azMwXEg2MZdc+Sb3i5TKzQViV8MK6f/Pg8WGMCORP9zi3iaOx4ZypC0FmoJgdJqZcckGQ37onOMhufk0mOmWFKuRTGr7+J/nakYFXKGpUUuUAspDBsAqWMcZBXpKf4jPaf9xQ4Tiht/LlQoPdyFWfrgksfQocd/lRwt0DBai3ViO5mq9wAjjziGOTwXnzEZ0yDJmVguBZSvXLSkqUUUjnHS00Or51fymDuvvKlxz3RHwLjc9VIZFeS7x3Rel7dJ2g4ex4523q/29kB5Lksj8cj3+YG84bVwgiRBMnlj7PHOwzndBDnxcaZw6X+4p3quWquxK8r48eiP/1CgwvjV5CbpGH+1E4biuTO0SA8RwpdbhBaPYsep8UzZ0pUpx9K0i2HCjQ1w9igGrRQL/PAcjMBJgMtuVRNR44+pXeoCC0ffqKnBMVZeUqRjG2QSagN/wSPblalpWA
 jalO9rOr
 tfJa9XGalE3ovhP2ayKbh9SnYJJz5xjiK3yHMwkPWjQGz8eiDG/Y4Xz1mo34ON3mwNRx+JfKRLGFtoaykHdMN0OsfwqyfnQmijA9HjFHrjXTZHr9ttn6Jh9huQ73js3zRvPrWzV2aVSDIXd+UpRlVPTRoSZi3WpRpyxTifnZ6lWRomhyOCPKcCwO6o8Mbh6ywQhXOZm2oRWBTjFctX+2UgxXUeY5NowHpBPZVvBmWR5OnHU+4CGxfq4pEJnW34J+2VY4wIQ1yINBRDERz0T2rp//gmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:05PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> A future commit will add more callbacks for the KHO radix tree. Add a
> struct for collecting the callbacks.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     | 15 ++++++++++++---
>  kernel/liveupdate/kexec_handover.c | 29 ++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index f368f3b9f923..030da6399d28 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -34,14 +34,23 @@ struct kho_radix_tree {
>  	struct mutex lock; /* protects the tree's structure and root pointer */
>  };
>  
> -typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
> +/**
> + * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
> + * @key:      Called on each present key in the radix tree.
> + *
> + * For each callback, a return value of 0 continues the walk and a non-zero
> + * return value is directly returned to the caller.
> + */
> +struct kho_radix_walk_cb {
> +	int (*key)(unsigned long key);
> +};
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  
>  int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
>  void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
>  int kho_radix_walk_tree(struct kho_radix_tree *tree,
> -			kho_radix_tree_walk_callback_t cb);
> +			const struct kho_radix_walk_cb *cb);
>  
>  #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
>  
> @@ -54,7 +63,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
>  				     unsigned long key) { }
>  
>  static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
> -				      kho_radix_tree_walk_callback_t cb)
> +				      const struct kho_radix_walk_cb *cb)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5758dc6fab5d..4a5d1b47799c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
>  
> -static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
> -			       unsigned long key,
> -			       kho_radix_tree_walk_callback_t cb)
> +static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
> +			       const struct kho_radix_walk_cb *cb)
>  {
>  	unsigned long *bitmap = (unsigned long *)leaf;
>  	unsigned int i;
>  	int err;
>  
> +	if (!cb->key)
> +		return 0;
> +
>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> -		err = cb(key | i);
> +		err = cb->key(key | i);

key(key) reads weird :)
Can't say I have a good name, maybe key_action()?

>  		if (err)
>  			return err;
>  	}

-- 
Sincerely yours,
Mike.

