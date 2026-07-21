Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B11DC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1166B007B; Tue, 21 Jul 2026 07:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471F36B008A; Tue, 21 Jul 2026 07:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363366B008C; Tue, 21 Jul 2026 07:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F24026B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:06:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 709BAA0CB8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:06:14 +0000 (UTC)
X-FDA: 85012504668.19.82E76C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A5FFEA0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:06:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TM9BOLXU;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784631972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaVZvxNKUlS8V5YFdO52ViXqG34PCKTpK+eQer0gTnI=;
	b=D197X6lPGacOrMsPviEI32VqnUETLhwsRywpO0zluZ5eWwS+mFicaxipLmsz3YP3EUHo2i
	XFbyXB8wknQOdC91oR8TDhZ33ezyfE7jAslcbVeenqr4w9wT0yFpsOxeq6g33FCkrzmwMu
	RoYHWUYxfy5a3u/XhbcbV59UMAxQ+YY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784631972;
	b=F/hqOMVGfwD4S6c75siyzbjHMbXzEFuLMd4ddUjWuoC5xe/+Ty/FT3l/QeoWh40arz6vxv
	THjXrBiwmkWmBY0S9kvqN3dJKHSIIsjgaGg+qqBj2Gx1obQnbudMnQPhXTx0nBU/FZ+F0I
	Aw+QN42dkvJFUyM01mexSN+SMwY5D7g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TM9BOLXU;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED2416001A;
	Tue, 21 Jul 2026 11:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057C1F000E9;
	Tue, 21 Jul 2026 11:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784631971;
	bh=LaVZvxNKUlS8V5YFdO52ViXqG34PCKTpK+eQer0gTnI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TM9BOLXUbZv8axude7fnH0r8XrDLOI8/x4LVPjAPG823eqYIStGZxvrdJkC9sdotq
	 SBHMq+1to+F+pV2rXsEE+y/SL3hR+P5QfvhMGN55BSQHAgoUgGOVASH4J0A4s6PdB6
	 +sTBRPbfwA8vHdjNpB/t5TNmnlbbLcCJ9iamgnXqqt9OTiNFkPedPs3MFjCSNLFplk
	 SYRByFhF/e1L0rg+ADBPrH3PVf1MIN/HvJX4BZKbzLG9u3b9/cD81fCxJgeXrQQv5H
	 TxCewVYgMAegtT6YCaXeCw7KM3G1Ge64txCm6X7Q2apiTlaMdPv4IYHcFzvjCE73kF
	 jZoH0SKUa8C5g==
Message-ID: <cd11b015-7c59-4ce4-8eb0-8040fbb2cdfc@kernel.org>
Date: Tue, 21 Jul 2026 13:06:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 6/8] mm/slab: introduce struct
 kvfree_rcu_head for kvfree_rcu batching
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-6-964e03c41a4e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260720-kfree_rcu_nolock-v4-6-964e03c41a4e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5FFEA0007
X-Stat-Signature: 9731xecbxajst11kquqxtbx8satd3ptf
X-Rspam-User: 
X-HE-Tag: 1784631972-691892
X-HE-Meta: U2FsdGVkX1/wVsTSffk6Bj10bn7+JRUh7y/McsLkGbCDCPxwquKjTiIxRQhQxcvUpMKTU9mKLPp7pm5WcFaY8EnFi+W7RaXxiPnKSnTDO9SRzHuhbZ2qNPYXAERHxYelGBbZjqfWTQHCWAjY550BxJBonifkWZ5OSNSU/RuUopA3vOVxKCvV05r9+fPaolVnKJWgyTeAjoTksxqXg1bCxYPhZtB61HsgysUztG4B/byCsBwIqvpul1zw8d6deF9SOCfw0i78St0oSwMCEDCq2fZhV9zoQMA7MdscA51kSE9LmYEI/wBFFOPPlCW5fqCf/MkRAm43uNPd08EKcFRazhXnJxmidd42oQiJ3iGapTqdd9qB2jt0RpCXMDpAcVX+D5hL+3FJ7gjVD8HteAK9etZhteSRf6g7WoWt4a9kJveixTs+C5kdNQr3gTjxZ5n9YG1PthJF1rCsFc6GgMAv2N+equW0MXeDnpiOZnf8eAFn9b8uyE3RwHkh2/LsJNgUIskJiwdA1w1gAuDa2emkg09a1pjJ6DhOspCvYczY8sAQ6n9RZaXTZJxt8TU64YLw3aVDmJu6uLHji3FJtPnpFVIgi80FLJnceo9RvLz2ydAiK6FTON3AuPchrqcuCeJYzU0/ukuVVK8ArBP+Za7+hxwjo56ELCCWk51TqbZp4bcN3omG2khXhKljdBCZYJvoLpSYOK7wD5y7Kt2N40UzRCBNDss29M8j759H/Y8IdUazVfFDPRUWFDfSs8d57UsRdWjb1AerrDAdTnwMxbApC3hYgcnuNynEK2gZJmwHiLubLaBe4MJjitCuUwWyL+6/pfSLWA/wEfcTmFTztQEayvHu3qunVc1t1SVp+CvbtzUgcX3d6cTuK5jFlNq+fPa0u6oXF/b9WQh8gDNgDOWyR17bWOyTt/gOUEOJiavzdFPVFrJGaIjjzBeQn4Q+7v7GXW6GM07WMy/qrV/4MHL
 8S6Ymm9w
 jR58Iz/EB4H/8698HWLL4MzsuXzjatlq7g4iohb0uy99Hg+D6nxFEUmNf9t892ihKZ3pAfxuHLnOFIqy7KzDpqEkq7hNeASfVTMyxsz8SJozbtejgrcj6JAsiQPT6/mfqxLkEC0RQ38iGUjbSiFM8nE9n5bQpd55KLuqKAEYjF93CoKydJLxoOk5hWWGEfD6/UQLYGuWe84sJU/wSFAvlWuGt7QA30hwQa7bdQJnVuwhuC6hwS33txrUbfyvTFkCy5Zpgbse2v88E3KqLpm73LTXAm5nA1lHHMA30brSDabb0h8z4yVvYVk05XSHYq70n6IrqeTpROj8PnmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
> rcu_head is overkill for kvfree_rcu() because the callback
> function is always either kfree(), vfree(), or free_large_kmalloc(),
> and thus there is no need for a function pointer.
> 
> kvfree_rcu batching reuses the field to store the start address
> of an object, however, this is not strictly needed because we can
> calculate the start address in the slowpath. For the purpose of
> kvfree_rcu batching, it is sufficient to implement a linked list using
> a single pointer.
> 
> Introduce a new struct called kvfree_rcu_head (the name was suggested
> by Vlastimil Babka), which is similar to rcu_head but is only a single
> pointer to build a linked list, without a function pointer, when
> CONFIG_KVFREE_RCU_BATCHED=y.
> 
> When kvfree_rcu is not batched, kvfree_rcu_head is the same size
> as rcu_head. Note that shrinking struct kvfree_rcu_head on
> CONFIG_KVFREE_RCU_BATCHED=n kernels would inevitably require additional
> complexity and also some sort of batching (which defeats the purpose of
> the config option) because it cannot fall back to call_rcu().
> 
> For now there are no user-visible changes to the API. k[v]free_rcu()
> simply casts rcu_head to kvfree_rcu_head. While this does not affect
> the API, it allows kfree_rcu_nolock() to reuse kvfree_rcu batching
> as a fallback when trylock or sheaf allocation fails.
> 
> Stop storing the object pointer in rcu_head.func and instead calculate
> the object's start address in kvfree_rcu_list(). Factor out the existing
> logic to calculate the start address from kvfree_rcu_cb() to
> kvmalloc_obj_start_addr().
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Nice.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -351,6 +351,33 @@ static inline int objs_per_slab(const struct kmem_cache *cache,
>  	return slab->objects;
>  }
>  
> +/* kvfree_rcu_head offset can be only less than page size */
> +static inline void *kvmalloc_obj_start_addr(void *head)
> +{
> +	void *obj = head;
> +
> +	if (unlikely(is_vmalloc_addr(obj))) {
> +		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
> +	} else {
> +		struct page *page = virt_to_page(obj);
> +		struct slab *slab = page_slab(page);

Can use virt_to_slab().

> +
> +		if (!slab) {
> +			obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
> +		} else if (is_kfence_address(obj)) {
> +			obj = kfence_object_start(obj);
> +		} else {
> +			struct kmem_cache *s = slab->slab_cache;
> +			unsigned int idx = __obj_to_index(s, slab_address(slab), obj);
> +
> +			obj = slab_address(slab) + s->size * idx;
> +			obj = fixup_red_left(s, obj);
> +		}
> +	}
> +
> +	return obj;
> +}
> +
>  /*
>   * State of the slab allocator.
>   *

