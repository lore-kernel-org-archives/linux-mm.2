Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B89FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4736B0092; Tue,  7 Apr 2026 08:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7844F6B0095; Tue,  7 Apr 2026 08:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C6A6B0099; Tue,  7 Apr 2026 08:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD726B0092
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:40:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D913313B9E0
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:40:13 +0000 (UTC)
X-FDA: 84631717506.18.2C6BF3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 195FCA0013
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:40:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmrTNmWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775565612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fB5zjQ5HmgJZyt2ixB3nQDPnP47N4L+svW25scgncUo=;
	b=nC8WBvIGATeD4pjAJmiIpV3kF9AZ7rI4KonI+hnB/w/NF8TjvtXmCq2d85DVOqDh3lQZf+
	e2uzvKumVaqg1MYBADKQpQxlJci2Sp7c5zPB+/e3izs1uH0o0lF4o1z8Z7Fnlguk7zFW6f
	5xzD48DywuIqq8CUTASC1q+fJh+L9kY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775565612; a=rsa-sha256;
	cv=none;
	b=qUmHTuab/nmkyFwQW9n1Xgz4U7VeO3H723x6UGbCxSUmYlBYeNokzgeQ+fTtWjwX5C+qeg
	D1NxAjpWvoKNHmhjJe27ayn4vUVTbz1TZEij1SYYbRFLRjlWdCp5n1fpWAiFHGFOPF3Gau
	L4sdg4gL5IehHlAkEVMMw6O0FZUu4WY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmrTNmWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B74943F04;
	Tue,  7 Apr 2026 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF03C116C6;
	Tue,  7 Apr 2026 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775565610;
	bh=MjKTZvgcsa+0D+fv/ckBA0TQ+h5FwjHVyuFzDvvnDd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XmrTNmWAF7+UGEO0+jM/dWHCTDewiOoYwE6o1rhI5tRqI7Rooar+ZAL5QK1X2pRJS
	 j5gLDOpMV19Gd9oNijz+jgr4PzEaaIO+KsTvHtX6zh9Tj02kYoyhZAvJjNC0/dPqOU
	 nt56lsPzrOFtu2jvy/etLQwO/wjfHZrrCRNZG0m2QeIszrI2F0JoMkjGE6i5LqbjAB
	 UDM+N3/Rf5XLphUNElSB7FTiiH0fC+Ar6lVrBYieKSUJbuLfe3f67OPKs3YuRFcAdm
	 DIiBtpfB16dwGdfsZoGM+UqpS4XzG23N5MH1jXZxwbgZNBi7waEZ4si3ckPYiOnMyR
	 kwPn+cqE8oy8Q==
Message-ID: <d013f96a-370a-4f1e-8002-3a5876ea44ac@kernel.org>
Date: Tue, 7 Apr 2026 14:40:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] slub: clarify kmem_cache_refill_sheaf() comments
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260407120018.42692-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260407120018.42692-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 195FCA0013
X-Stat-Signature: m3fugs9shxo6zksctrj5n59y7ps536oo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775565611-85331
X-HE-Meta: U2FsdGVkX19XuXZVFbWUB2Ljbz2xcdLjWSxGckWIb4pr/SwxQHHlv2qrSFebhihHpjgm12kTjTWH1pATu7VxscpLeBErLXs5p8BoBPfPvf0EZiQpOb/tv5XuOdIT5kAFPZXv8P6rPB0y17Nqul4IYmuRM7gVQZBJDx3ieywYqBpvSlm5Xnd9njkLqWIUER0fMGHO0X8DRJSztRMkSHi0L3IpU0bTw6qGe/w/kAwEhSTWBs08F50wSJSaQN3vjETovVg+M752xt9/yYxJTe1c68MIzelnLEfW5KEB6fLlCQccp6AFQsZP247S0gUgHHLLR11ROukYO8qxwesrbqOa92YgtM5LzvF9mFaTSQZ4N+qcZDP/Fm2gjUSS8jKy4pgPfNrHQ7ogQ7rlyz1T7pHMAWGFOA9c3KLT/ORGNs3xkqyJH3gqG/2MEQsi+c3E0N7NUmezeAxQn/eQAWl4ECZUd8z2e2yLKMZPR8Rb4qvm+scq4WBwD0g+7ohY3LGm9DNxTbVd/jOUEDv6ckakyvlo1NSv0YeUrJUlbMfQRVkeKQ4DbsnsihmNlzt6pVkUBfyfd+eJe15EI6eG4QOcDb/8KlH/jf4kCgoCz844evd7wpqgWRq0FdFLprilPQMcdOUAUlOyYx08+kmnKfD1jdmNHNPC8ATcLppX2AKLemVlUIwU2uuyRqBFPpnaNUlNE/rCK0lKzUyJcERQ8DIjO61FlGGrAIgTIxqWvsIMiPoLJL35Vb+NXlCZcLSc7ROw0JRJfOWWXmaFfnzOnkf5Z7FQNvOUST7YSb1ASeMcUM6h6HtUElzL729LRszsWCUpd38SPE4LV1RjfgzYMONUNX7nh26DWAlki4MBIL5Leq8Raswx4WunCnHbVf/ajRWDcfFa4S3qvIDkh1MHskPP4i8Y31okjb5ixSHlxWz8oltWjvluvV6CwzNWgqn3+6zOEayQPTLmwlLlOWgS/zixRR1
 UV92swJz
 ELHDBsTetptE8ZYe+QGgOMfmKr2110oO2jOVt6gdl8lixjjNkjc0wYFLAWYkDo4VUK1OevlNcus7XTxjI3GdsSZ9/nZ5DQfUhQHcV3TJk9YKnOVf+dF1Uratb7lIDVdWtpU+fn0iC+AVXsvzuzef5jSz4aXrcWdnWYaONppn/AY4AciiRA+uTNFNlJ5hmk8Q4Y/gKUznbkfX5Tv5d16RTM6ktTon4M0bDqaGOG3j3eJDR8gKZDAKMzD4TD1lTLPCJSBHNDaeNwh6I2290FF0TRo/BseXPBT80AVmouENiiJns0tGKbVShDz8ZGUPrP5A+O/CG6XhJbJN7Vu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 13:59, Hao Li wrote:
> In the in-place refill case, some objects may already have been added
> before the function returns -ENOMEM.
> Clarify this behavior and polish the rest of the comment for readability.
> 
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Thanks Harry for good suggestion!

Thanks! Added to slab/for-next

> ---
>  mm/slub.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4927407c9699..92362eeb13e5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5120,12 +5120,15 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  }
>  
>  /*
> - * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> - * the given size
> + * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> + * the given size.
>   *
> - * the sheaf might be replaced by a new one when requesting more than
> - * s->sheaf_capacity objects if such replacement is necessary, but the refill
> - * fails (returning -ENOMEM), the existing sheaf is left intact
> + * Return: 0 on success. The sheaf will contain at least @size objects.
> + * The sheaf might have been replaced with a new one if more than
> + * sheaf->capacity objects are requested.
> + *
> + * Return: -ENOMEM on failure. Some objects might have been added to the sheaf
> + * but the sheaf will not be replaced.
>   *
>   * In practice we always refill to full sheaf's capacity.
>   */


