Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7BE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lGrGSJZM
Received: by kanga.kvack.org (Postfix)
	id 866596B05BE; Wed, 11 Nov 2026 04:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8160C6B05C1; Wed, 11 Nov 2026 04:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B7D6B05E2; Wed, 11 Nov 2026 04:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0146B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8AD21A022F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:55 +0000 (UTC)
X-FDA: 85422339030.19.3A9B37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1AB03180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGrGSJZM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fY7y3DvJR+ThhW1hxlai7deN/WqRZ83gAUMd110UE4=;
	b=o7+WlhSD0OR2nMCiBDPBZWCH468UDejKYjBhuy2lRi7ZWNBoCaiuXyjbHOnPQT5fW3BNp6
	zw+HzJyYf6VIrUUJRIFkrbXtSWv/rlNF64wHBQyfQYgQmpUjeDNqtHkFrmHCBP/HApyKZ+
	YVBlB1X145c25VudoNsmpF9YdrpZ0yg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389934;
	b=Y5JuVomGgizCut//OM8iYhcd1f4EzG/IhEiqLyHf0l+bkzH8l/V4tYPEJ3EzLk1RLSxwBi
	3K2btBb0YGUUvbpYU//JsdBTR01pcXDwxP/2eZ50NJggUUv+KKzhRVC8bITv+FJSAba9r6
	MooIKmmik0pZfqEiylldDyla2tn+uzU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGrGSJZM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B42F3611A1;
	Wed, 11 Nov 2026 09:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C81F00A05;
	Wed, 11 Nov 2026 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389933;
	bh=4fY7y3DvJR+ThhW1hxlai7deN/WqRZ83gAUMd110UE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lGrGSJZM6doF9c4EAvbkk9cqMFO7Gn7ruLcFXqhlf4encNqTGsoqGX9buFQ0zRlpw
	 NnXtS2mxNbFa7hkwUwejUlJlZD5jjvirnlbAlBnX/ZISdFXT5eOtBruYRdFbD3JAN6
	 EcnSuekavKbwk6fW9eWdP114V4TdTQWBrfn9hW+dSDJwD2jCJNSERk+igooNZ2x/JE
	 PejkO/XZgVXQkrbGN2bxVkDWFlYoUsi1m1aBJ7s715aF1hh5ccGLlg3UQIx616sgGZ
	 U8W0nU7rElxqtvLPd6FFGG7DGeZzdcduNpYe5Q1Wh/5AW+f9LrSABNF5wJCjYlYyrY
	 u3di+tCaoeRTg==
Message-ID: <0069b6c6-a2d4-4a3b-b723-71c96509a3f2@kernel.org>
Date: Wed, 11 Nov 2026 10:38:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in
 VMA lock code
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uzqwbn8k48uhnc5djno1czm7qjix74qc
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AB03180006
X-HE-Tag: 1794389933-761147
X-HE-Meta: U2FsdGVkX1+ZUA1XHW+givgLPj9lj8DrvQlgw8B0BT3TDrr/i7l4n6giWvfMh3s5HtjSEjF0CtYMb9ai8H+GJew68xazCdFtQmfdKwCLWCPHlGYRdwImNr1VCPJrZDoOfotY8vuE5TrLpRVzyw0pLY2c3ICRvT9vfuOEAVLmkxKrvuBFQCgKwp3t9gK/mh1XqFzBmns4P3XmVcl1oP76leTnoNbJSwVT6auieemubGcBMb8nhfiSYFhlgzVXnH87bJvMwxNqiKwsMuW17LBcTlAsF5rOXIEuP6gioRlgTRxV185syuxPJ5HAOBC+fbhk0SXS0wqgg5F+56y+O1gcp8CfwYZhQiEBbCLvMUZjW/4EGsjHh0yPxxzJ30n1891j7E4WGDxd+ScoTFiLIXb2RXPFq6xeYQJ8pY4D8tgUeeCfG/93+nfjD4YzDweczRtTnFSWHrAq20hQRH0RbcbR17rMbTn1gPGOl6bmGqWEXIITzBCyBAl3gx0+MbmYrYDti+I4IrM6LbGn8kKCc0vXR7k8B3D2dWRcLDtJkJvUYxGfiWULJnVhHULqc/6JjCEevQYBa/+brITfobm4kHzRug6bgNWa6g4yP9p1cag9uJBEjjNN1OTHhg30dS0DYF3R1CAGMsmOjMqe6jJJqpo/fHAuprCpTcfkTUqRZkIBxMq8CmWVGdM74Su1cFQpjBi9qJ+SX3KJGRIcuVv72OPhYAPXcTR5mEyzlfAXqcXSo4rRTUISbTzddfW4GbUHslrpEhu8/Yhb7lpljTtBySVGfKlB92Qo6yurGglzygug0pSIr//uWkJaJndD8ycEAdqs5iqSerIKnf58fKeULSDFimaRPP7UyvyW2q0bR1w58qp4CE50T4md2LUD3aJzro3v58D3mqJrLwDUW4CcxWV+Ijs0hUoT0MLr9HFa/dKNvAzuKqzMasx58z/JBi0m6J2pPBT4kSSde0lIa/g6TVm
 EWCsErzv
 u1KF3ZtZouudgtAw2C2M/7RwuTDiHa71mMFq8QoW2YiIvE+EIOH1unZGQJH8ERiWkhEHhWoaUcaBE01f/XEbC1sZnb/qlDbQa5x7/sDNHqoakVkgM2Fw9vkoYEDPYpzjdkla3vWofegpQnK3kTZTmE8RlHKG6G4XVLFZCOebmc+dOUocMXdlmjw3u3WdKI1LRt4mGtTksTa1p7+uiAHA5Hh96h1O2Q9GrCY69b2jj3pYIYBe7fLNq2NVbQB0ii7hwPbJeVvXmJxk22Ti5wfOAGrgrUaEHZvl4I4zah5fKGcOv884YqsJ8e2x6GrNPd0KPSSEQjhRZOwQjF2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 17:57, Lorenzo Stoakes (ARM) wrote:
> Now that VMA assertions are predicated on CONFIG_DEBUG_VM, it makes sense
> to convert existing unconditional WARN_ON_ONCE()'s in VMA lock code to
> VM_WARN_ON_ONCE()'s.
> 
> These are asserting programmatic invariants which are in most other cases
> asserted using VM_WARN_ON_ONCE(), and there is simply no need for these to
> be unconditionally checked, so no longer do so.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/mmap_lock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 834bbf86e004..073c5125b424 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -146,7 +146,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
>  
>  	err = __vma_start_exclude_readers(&ves);
>  	if (err) {
> -		WARN_ON_ONCE(ves.detached);
> +		VM_WARN_ON_ONCE(ves.detached);
>  		return err;
>  	}
>  
> @@ -161,7 +161,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
>  	if (ves.exclusive) {
>  		__vma_end_exclude_readers(&ves);
>  		/* VMA should remain attached. */
> -		WARN_ON_ONCE(ves.detached);
> +		VM_WARN_ON_ONCE(ves.detached);
>  	}
>  
>  	return 0;
> @@ -193,7 +193,7 @@ void __vma_exclude_readers_for_detach(struct vm_area_struct *vma)
>  		__vma_end_exclude_readers(&ves);
>  	}
>  	/* If an error arose but we were detached anyway, we don't care. */
> -	WARN_ON_ONCE(!ves.detached);
> +	VM_WARN_ON_ONCE(!ves.detached);
>  }
>  
>  /* Do the VMA, mm seqcounts indicate the VMA is write locked? */
> 


