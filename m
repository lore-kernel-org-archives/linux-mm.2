Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01042606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUzV4Hv2
Received: by kanga.kvack.org (Postfix)
	id 18DE96B00EF; Wed,  4 Nov 2026 06:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F706B05B1; Wed,  4 Nov 2026 06:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DA76B05B2; Wed,  4 Nov 2026 06:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA7C6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:03:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6333C140694
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:03:03 +0000 (UTC)
X-FDA: 85397149446.20.67DFE67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73B0A180009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:03:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUzV4Hv2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790181;
	b=GJGA2/Cj8f8VKWuylGuIIL7WDq5PKarWP0vrrpIUYCkKiXXCXlPZW2zOHY1DrB/yfS2GXR
	snbNvbSt218ivy2BaftfdoYU2xpl8gRyacOr5Kgp+adlduMzstiqRKMLQUCLWugrZ/RQ7y
	5YsnlHC4UUBSQAEdrwEt7CC5GV+c/xY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUzV4Hv2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmAAu5i6ADNm9DWcT6htUpjVYsuBgc5FPA1Ofa2D4uU=;
	b=TgsLxg0tKvNILVd8cXgPQO2HJU976q5RYJriw2tyzLJofvPTGmw7jiGbZ5P1MKOkrlNCId
	TEhMAQ2ZL7cd40y49rCkgWQn2WYZox6Z1j5cjObPNDFY6NAMk/L8oAelQzefrxosgSEXAX
	yrsXDWrj+hKOKGG4JI11tN6dyCv+Nto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4FF260F22;
	Wed,  4 Nov 2026 11:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98D11F000C1;
	Wed,  4 Nov 2026 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793790180;
	bh=MmAAu5i6ADNm9DWcT6htUpjVYsuBgc5FPA1Ofa2D4uU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SUzV4Hv2uoryb9Q24Qln7PLzOfILm3kcqdwfobU3M4CtRlVN+xvpdBz65WTxlF/gG
	 8zP5EQSJRfHEWirYplJxgwJ29EazRs1Mtzvxmn9j/5BRuUCriKNjEQ6vWa85IZ7zvE
	 WuILPXj4mRjIbJhGR3aqB1qDZw9j/RFjbb8AafNxTetksy2ejxRbqHLTQ4RvqYD9jb
	 O6hf0LTX03ok0deyQOvKIkyVnEJ0dhPdL49nmq+b6ZSKK7ln/bUJ6qWmoIrk5VacIF
	 naGDLX+xTp/LHq6a1qbMWKniZntZ//3XK//oLTIAOMcf6eoMlnZhva7GG2ft0UJFOs
	 uJq1G/yQE/gmg==
Message-ID: <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>
Date: Wed, 4 Nov 2026 12:02:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y9d65yjf6jqggnm3x4wxo1det6iya4sc
X-Rspamd-Queue-Id: 73B0A180009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793790181-413199
X-HE-Meta: U2FsdGVkX1/VfHClHkbNeF/xIfL60JLTdJTq3gTqrYiL6JGUWPjeRnLUsGNZCuNg/TFuSk8k2wHgar1GuC+AQVLaILDy0CJ/qsozuP5+yjWRSwmr6yGltxDQLMNLTDmaS7BMsmW3Vl7j/D9PJzHn7Uq20CyVs5Rg4luh5OyClDtg526xKBUAN1Ax25qUZnAC8IimNSyi4ZlK8/HFcD4c9oNQLKdvNweSFQaULbCbCYQmd+Y0jWEEc9vz3LNqcGTqdjpoxHw8HMf7w2lYLoRCU6fmlhzeHS3nW7tBvQMLN2hdC4Qyf314f4L5dx+dtG4XE5DrEqxrs0A68FDGWNoOCbxqrUWNhFJGeiTiFdGh54lubTolYzqIvKSUUxP1hKf0/diIHvKYB6pMQEzQby8uwdP6cjYSR4TZRVNWVnL3BXActzNhYGFJhHArAieXHeXWNDtqlgqNC0NkGvxBMWz7UtOC45LyAXpoLjIsv/tJPlcSqGg7pPCwCaBwHp51i+oj4C45p/QeppCTNn0P1M0kSaySeGPcpBYxy87jnpb9lQIRZeA+FUxCVrPTLXLeudg+gpKjlFibGV8jSxoaw3oJgHtxVWK1PcYzX35ISIDFlBRZBBi+Qa8TzfXi+bk0xFCkO/BMFJsZHhG9V6QN6AgbUpFl+D9/mG9dTDZRGViPUKAqPKyFDtZBg7/NMhB196TYemOiUDPzhjm9DyS1KD1X7n+qEpbOZ2OYzmoDon2RLI9l1698BRz4Q5twGPcdj5othVYylz6oQD2VdNzsjTvKI26KSYMNeP8+TLZT6BNNqRYANb0SAqTIqP7X2GPt2h3KrHRl1pnDIraSC/YE3LziOsP6UxciCwV1chwGKdRLr+J6+r+Y09vqOg3qmdD22nsQtp4zluQCHSRa7BUlXk/7WwmpSzouVdP4ALn7bTX9ChMw7/AYtcABKvf9vSyunN3UJEIu0l9N/3TyWJ+XgSp
 sXRqUpFE
 rU8kKw9r3f5SujEF74Zaa16Z3n4WJrM5Be/LtOdIj7A08WNPG0BSMX/G5dus6JwCPd4sFeC/5qckMdOksxaMnUvYtCthpyW3du0ztDACvLw/zYiq0uLUUTaPMrwOLaWLbsSSryUvZHhpHDTWRHSOPwCfVpGVvj73EIvroEYjTvizAE20kJgeOxYPZAD40E6UzhWvYoU52jCjzGhQlEnMJM6icbDXu98Zww29t1M9obBoriMPkKNJtXf5kKaFlndIDPjnEH2x4TXl9Xb8nxYUSPREanMrDZjm9v44rFAnt5s/y+vm4/NNciYunSPFXB53XJaymNSyPM5BrO/+q06rWKdcCVppgbLXbj5tO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> obj_cgroup_put() can be called from any context.
> __memcg_slab_free_hook() puts a per-object reference on
> every accounted free, and draining a per-cpu objcg stock slot puts
> the cached reference. When it drops the last reference,
> obj_cgroup_release() takes objcg_lock, frees percpu memory
> (pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
> these can deadlock when the current context interrupted a holder of
> the respective lock.
> 
> Defer the release to irq_work. llist_add() and irq_work_queue() are
> NMI-safe, and the irq_work runs in a context where acquiring a
> spinlock is allowed.
> 
> Add a separate llist_node instead of reusing the list/rcu union
> because the list stays linked until the deferred release. struct
> obj_cgroup grows from 56 to 64 bytes, but both are served from
> kmalloc-64, so no memory is additionally consumed.
> 
> Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

I guess releasing objcg isn't too frequent, so it won't matter that we make
all cases use the defered work instead of somehow trying to do that only in
contexts that would really need it.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

since memcg tree will be used from the next cycle, we can just keep this as
part of the series in the slab tree?

> ---
>  include/linux/memcontrol.h |  2 ++
>  mm/memcontrol.c            | 27 ++++++++++++++++++++++++---
>  2 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..4d5c634daef8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -185,6 +185,8 @@ struct obj_cgroup {
>  		struct list_head list; /* protected by objcg_lock */
>  		struct rcu_head rcu;
>  	};
> +	/* Used to defer obj_cgroup_release() to irq_work */
> +	struct llist_node release_node;
>  	bool is_root;
>  };
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..c53147a88580 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -147,9 +147,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
>  		memcg_uncharge(memcg, nr_pages);
>  }
>  
> -static void obj_cgroup_release(struct percpu_ref *ref)
> +static void __obj_cgroup_release(struct obj_cgroup *objcg)
>  {
> -	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
>  	unsigned int nr_bytes;
>  	unsigned int nr_pages;
>  	unsigned long flags;
> @@ -190,10 +189,32 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>  	list_del(&objcg->list);
>  	spin_unlock_irqrestore(&objcg_lock, flags);
>  
> -	percpu_ref_exit(ref);
> +	percpu_ref_exit(&objcg->refcnt);
>  	kfree_rcu(objcg, rcu);
>  }
>  
> +static LLIST_HEAD(objcg_release_llist);
> +
> +static void objcg_release_workfn(struct irq_work *work)
> +{
> +	struct llist_node *head = llist_del_all(&objcg_release_llist);
> +	struct obj_cgroup *objcg, *tmp;
> +
> +	llist_for_each_entry_safe(objcg, tmp, head, release_node)
> +		__obj_cgroup_release(objcg);
> +}
> +
> +static DEFINE_IRQ_WORK(objcg_release_work, objcg_release_workfn);
> +
> +static void obj_cgroup_release(struct percpu_ref *ref)
> +{
> +	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
> +
> +	/* The last put may come from a context that cannot take spinlocks */
> +	if (llist_add(&objcg->release_node, &objcg_release_llist))
> +		irq_work_queue(&objcg_release_work);
> +}
> +
>  static struct obj_cgroup *obj_cgroup_alloc(void)
>  {
>  	struct obj_cgroup *objcg;
> 


