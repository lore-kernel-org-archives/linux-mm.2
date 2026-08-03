Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C9DC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF896B008A; Mon,  3 Aug 2026 03:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F946B0092; Mon,  3 Aug 2026 03:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FC16B0093; Mon,  3 Aug 2026 03:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C48F46B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:59:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B8468060C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:59:51 +0000 (UTC)
X-FDA: 85059209382.27.E05F7E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60D5E180007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:59:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6x89Ii5;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785743989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsn1KsK/5eC7jnlXNMG0EcugFZK3YL3Y70CXScw+FU4=;
	b=8dGLfre0+u38V51zyGADsGUm+Jep3AxXZbmpTwMOJJU6mOF/ugmRdbb/mGJo1hltFXP/ap
	zaBT+c9WponFttH1eN/rjW6cJJHVR7TvEuB9ebCb/af45NkDZ1zR7K7xtsvA7oMvcL6GlP
	OVApSiNfo38kB/6dUzpKmdG2rk3odMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785743989;
	b=XyXhkxvvPLUPGMSW5f6YC8jrsH509c7nnNgYzAmuCYBhNXr07Afxc+WR8IKloTPUCzRcwt
	ETdO7FrHXqtRzEVtJL2PCbMZjQJDTXyKTiWJpodFwobgoFS3RjDo01d4vkDos+X6gZmhMZ
	bXNa4Px4xveKMs03syfTRsL2yJmRxQw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6x89Ii5;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 633EE410C4;
	Mon,  3 Aug 2026 07:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302A71F000E9;
	Mon,  3 Aug 2026 07:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785743988;
	bh=hsn1KsK/5eC7jnlXNMG0EcugFZK3YL3Y70CXScw+FU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l6x89Ii55cOr7kXhH1CEmN2arHvrvbHSmgwQiU7piZMOxpHd/Rx7qORHW1zMZfGfo
	 NWkUjQ6e7z1fEWkg39ucRETA5UNetU1PRoMiDaQeiVNIwVsbKcTiH2f5CD1ShbYKWO
	 FnP/ViZw92rYOX4LyrSwHo9AzfppQLkmPOJBfVuz76xn3zhqbZ/ClSUR3upCT74n9c
	 L8wX+mdcqB6FAq359hULhW25YH0xjkPEbtIqk0CEDiakc+U2ZmpoI67AIvOP9fVPu7
	 RtxPsarKoxsIJOuiVT6hscNjpNFqkGsE/dclzlwoI8R9FJJ9/Q0G2KRiHCfcmLOuLD
	 021lURTb0sZug==
Message-ID: <c4057657-7246-48ce-80d0-123e351a921b@kernel.org>
Date: Mon, 3 Aug 2026 09:59:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
To: paulmck@kernel.org
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
 <d2cd0e92-930f-44e4-96e5-67b751419a1c@paulmck-laptop>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <d2cd0e92-930f-44e4-96e5-67b751419a1c@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6bh9jad5nacwo37o9k5hwufpzwmxow4f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 60D5E180007
X-HE-Tag: 1785743989-425595
X-HE-Meta: U2FsdGVkX1/tFHbo9JKo3axYRDWhjbtMJWmx66z2Hjb8CGFrbbLvbz+4I2/ZgLJsoa3JO9FTztZbFPqL1Ap7LeaPGPQrwdkqEoNt5LVcbvojyb6pw6fFxmyKTkzDl0UdfTk/39V+W1uKUVm2gUlnmnjTc/3kdFI86Ayzf++PKEdaOdTzHRMn3GUTlJQ6CVstf4UXJFUJv8LjY82D2xorPvj4YZ3zkyQRm19onWt4LoJ/866u+RI/fdDCWrehgVCnCc9tTe39hFwGTIywhFMzkgpqqrVgWAB7XViocuOwIyv9FQqsYE2kfKY0UOuxcCi6NMBM9FPXZDUwQz1jaOvthLOCzQeWP/Uiyc31klaYxdeJM2ZL1F2dWI+ssK7dMG7qqk96/L2o6VW0jb7J3HDXOp2NPzUDKLFDNLr3mZr0biMFDnEldNsPNGcX4G8QCnNO4u4gQbYzDOewyMquRPp9zG8DQac+pGH0WboZLbsTafeWdgn2T/UFF2MTFoJ87dKzHS+2bKV6dQv/K8uUmK5r3ZxggCE8I1+A843bf/VRu+SlU/ROOX3GahrNqCGcGEFfZ5oeibhT5NuT6GN96I0ri9cgQMGI/58EAsZr14f+CmB/wVNs+kBqA5eYbQIsYZT46dtDWvw/EgN2lmNkmThlxm3FwhxFUGgvZDNEwf35jler8DYiTW93FX8dBxJ252XwuoPfOm1/k0fOkYjoTE8H9jjQiVKNtJAmkqHU9y+8WltVO0huB/r/YU4xZCJP+mqjgAAYtoFM5g5xdi80FThtMRkpFPEbAhT8xa9yxKThcnFvna1QKw5C/cr82kmAEVmxJUFIKyVodI6qNQRARZT1akRV3mp17jfGDVKXKZlo3ZuAz5Z3BgoGwNmsjc+qO2ZzarMhDfe7eJNoebykfDt5iBDoJr6f2u2tOCjChppC7SS+Hkluk3VahBKaZHuUBY8FW50g2KxaroMd8Fyk7bI
 FFTb/QDQ
 uPeV3hcX5i9Vl+Vnlqxsg6ogzJkeoXor2ptVYS738FutgUuffQssED5j+WqGvcllebf+/UJ28Pn9wAyUKnNjoYgOjir2xrNTmPe7EvxtU9cb2RbFsXbKncP3MMyJLJHyRwom1tR29ctjZU8WYwWi5bc9aeVyxlphvaFGExdMxVHW74XiWVoyPLDeyyH7jmZPAK4SS+rvAVEsSuGmZ9jzpDpztaKjCkSCNDk/NcrBLiu+cXoOoJNXXjNCnMDk/9YxCqI/olqKO1SAsIcNDkOeUbusL4AG3rwkuL2PSBHqQdNkUIhhyciZOPRiO8QNrGFPeGnlHDrVZ6PiLApM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 22:59, Paul E. McKenney wrote:
> On Thu, Jul 30, 2026 at 04:32:46PM +0200, Vlastimil Babka (SUSE) wrote:
>> No module code calls these functions directly. Seems it was always the
>> case. Remove the exports.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>

Thanks!

> Which reminds me...  Are you guys interested in taking the kfree_rcu()
> test code from kernel/rcu/rcuscale.c?  See for example the kfree_rcu_test
> module parameter.

Hmm, we have a slub kunit test, but I think no such torture/scaling test
infra. Maybe once we have that? What do you think, Harry?



> 							Thanx, Paul
> 
>> ---
>> Based on slab/for-7.3/kfree_rcu_nolock
>> ---
>>  mm/slab_common.c | 4 ----
>>  1 file changed, 4 deletions(-)
>> 
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 6750dfa27367..cd155ffc2762 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1329,14 +1329,12 @@ void kvfree_rcu_barrier(void)
>>  	deferred_work_barrier();
>>  	rcu_barrier();
>>  }
>> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>>  
>>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>>  {
>>  	deferred_work_barrier();
>>  	rcu_barrier();
>>  }
>> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>>  
>>  void __init kvfree_rcu_init(void)
>>  {
>> @@ -2163,7 +2161,6 @@ void kvfree_rcu_barrier(void)
>>  	flush_all_rcu_sheaves();
>>  	__kvfree_rcu_barrier();
>>  }
>> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>>  
>>  /**
>>   * kvfree_rcu_barrier_on_cache - Wait for in-flight kvfree_rcu() calls on a
>> @@ -2186,7 +2183,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>>  	rcu_barrier();
>>  	__kvfree_rcu_barrier();
>>  }
>> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>>  
>>  static unsigned long
>>  kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>> 
>> ---
>> base-commit: b01f6ed9ff0c4581fc669044fa5b82a93b4ef144
>> change-id: 20260730-unexport-barriers-439b3f69f791
>> 
>> 


