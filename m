Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45295C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 08:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0206B0093; Mon,  3 Aug 2026 04:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70396B0095; Mon,  3 Aug 2026 04:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A376D6B0096; Mon,  3 Aug 2026 04:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66FA36B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:01:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD88FA063A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:01:47 +0000 (UTC)
X-FDA: 85059214254.29.C5E83DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3267AC0005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:01:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnfJtzwz;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785744106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Na/aANYMDUehsOMBe0MMj5OUvwi9UUXCwO4pWcm1pcM=;
	b=C6GLy2pK8BpWXIoBb2Kd43UO5QfTt8zgajD15OWlDUxsYGcItic9zt1bf4x9ATKX9QiMkD
	97/agBvMsJED+Om71AJWt0hsJi064h+i5KV2IDJ3ewkh5UtzZO21uEmjEe6eo2Y3vacpzy
	lnzqyQTmr88UXnB16CbGK3dXunwwozo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnfJtzwz;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785744106;
	b=C52DWAsOKZU1Mpx9qx+AaMRsa2tT0JuIr5uPREN5Z7Qj3D/LTHjo1CjP6CX9iSCxgm3Zl/
	3wIn/MyD9Q/dTj8aEjtjNa6VmV2r7a0sj2uXU3/ds2DWCCIUyOPvZYzQacBIYiU7L6TVJl
	iKcFAcleb2C/9rbBNlD403W+YXUE26E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7265600FF;
	Mon,  3 Aug 2026 08:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663331F000E9;
	Mon,  3 Aug 2026 08:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785744105;
	bh=Na/aANYMDUehsOMBe0MMj5OUvwi9UUXCwO4pWcm1pcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jnfJtzwzy2+6HusmPCYxjmVTUBa3VmnP/4od7x6hqMpnI6SxwPX9auaDwxAh3r1JC
	 9UufHYlFNa1Zj4AuSdWjB/5h1F5PHWvUvcgN/zVkDzqhJ/Z6edPs/aisUiKIYcYf3Y
	 umHi0Uu59w7lQdAkPpDLhYEPOzRPQg74Qi0V4rAmrJtuYSZdnL7Vp5etvtn3XDoKzc
	 Dwey7+NkW1ci4nxmtZVk8gGZn6VUxa78OQ2WK9uV/Fv8UFeG6GHyvV7Mj+VgZaNB5u
	 77XBNaiQ7Ctbh2sDbu1fVpvlfxe4ng2gOnGWqXR3/nnBqp5DoBdWP6XwDjYbkQH8nM
	 fqVKcwqBBzrAQ==
Message-ID: <50432ae2-1d2e-4f76-aea4-28b16874f472@kernel.org>
Date: Mon, 3 Aug 2026 10:01:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3267AC0005
X-Rspam-User: 
X-Stat-Signature: q7bdkd37dt9is5qr54si33jtrchyuawc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785744106-542594
X-HE-Meta: U2FsdGVkX19Al6vcailyls7Af8uXF6zJQecUvxAtXR9PJx8Ml5RDn2TIh8LKkU0zMX83i2CUn9HnB2cSGdjm5Xu6l/60EfYXyIaqrUnFusyfQr0iwiuySMsmU4nQusl0UXE7+Vf0TScwH+gNAb5qk8Ys9u5+PTR61aBEHt9LLo3VTYC5G+nbk8fb9Uza3MIWaxAoBM0gzB48OahSR5WFt8XyPrWuyb9WG3NQDYuCvIFc5HFlLTpXwdcBl8MW+fR4vP1tvZVxxEjEGvQ5ldgEkEOMTXOqqjlfOWuZxM5Kj874w51839wi7eGzdywwxx5o2czCdyH1bl1/7w1nIXjYLOwiXVQDve1yKU9n7O5Tt3v+kXgw65nameHY67giaveKRyb4e/O0HjoK42ltfNWGI9dA217aa0lSlmQtN73Z3Lh0t/vYm/4CeTVsOJhqUZvKRj0Y6k7k5JFN4oKxse0y7ENs4BCjjnM/ODZTNNh1SFP8Izp6/YHC+KlS89X6+3vc5xs73GdCV4EhusTr8XtuspHzcYTmjN6WZ9WvzcJqUS/f9oyqW0Dmtga8X+dFI87gB/aYBsY7pL97R6/d2SKxleEqr5ILq8XkRoZLmNaxGzJxaxVdNaB7TCl+6wuy6eLIkOtLCetUXP2Yv8YjrCeP+BgtPOKLRoHg8uNSq+Xan9wJhuZ/1M25Y04gL4mR2BYnodYL0GHsnoMonVBJB9kCeyRAoxT83jGBKdsbjrxUNGVVe194tC9W0DpeIiYUeNPF5iHbyIiN4nde/xk7klQbW8I0o/5liZoyIZaZyv/bLkDJKdO7S9tyEy3U06Xqp0U2umHAKWkTS9nYweJL0liOAR/LBbxiHF5Xcx9dvm4pFoeMOE4YLOhbyKgK1Js1pzJ26QXaSTk1cW12hQV4Pknb4jJp45wSaKabybjQO4ViW+crrd3m/yLqVKygowgQF4vdpaRGs3yNao+pBEl6IZy
 D+AYkkXZ
 t9KFxtbZWelWCNgy6GyQuC1rUaCaJmxxitHzHerDHwktLQpr5wPOd1plk91j8Io3gNGAu0KvsYxx63STgjYt0E7eA1UdZK2LwMQOYAM1QUoVi7tfdNLu7z1R9T9OTA9eYxtR9G8gYn15kBxb7CpGBi9f+1xPYI4D+lmdyOL1ZZPhxw7hLG87CLX3m72qeJGY/4hVVAxgdHnWDt1RPdUU4WQLimwQcC7MaoUbFBivCC168Oiy+k3rGCfqGC4A6iYE2Ua6dsuj6SyvsviIBkRgnkSZxrorqZyw9FV7TmvgGDhHdNZQopi3gYwII7J2VXYkp21fexiBi7WPLWyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 16:32, Vlastimil Babka (SUSE) wrote:
> No module code calls these functions directly. Seems it was always the
> case. Remove the exports.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Based on slab/for-7.3/kfree_rcu_nolock

Applied to that branch and slab/for-next

> ---
>  mm/slab_common.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 6750dfa27367..cd155ffc2762 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1329,14 +1329,12 @@ void kvfree_rcu_barrier(void)
>  	deferred_work_barrier();
>  	rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
>  	deferred_work_barrier();
>  	rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>  
>  void __init kvfree_rcu_init(void)
>  {
> @@ -2163,7 +2161,6 @@ void kvfree_rcu_barrier(void)
>  	flush_all_rcu_sheaves();
>  	__kvfree_rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  
>  /**
>   * kvfree_rcu_barrier_on_cache - Wait for in-flight kvfree_rcu() calls on a
> @@ -2186,7 +2183,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  	rcu_barrier();
>  	__kvfree_rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>  
>  static unsigned long
>  kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> 
> ---
> base-commit: b01f6ed9ff0c4581fc669044fa5b82a93b4ef144
> change-id: 20260730-unexport-barriers-439b3f69f791
> 


