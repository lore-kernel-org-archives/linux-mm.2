Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787D8C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CFB6B008A; Tue, 21 Jul 2026 09:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DB86B008C; Tue, 21 Jul 2026 09:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D54E6B0092; Tue, 21 Jul 2026 09:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C929C6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:10:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 177E9120158
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:10:07 +0000 (UTC)
X-FDA: 85012816854.01.903179F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 42D7A20010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:10:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndYTPFQl;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784639405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=se6gqaDgEIcoWq2sYffaHDfDYwxn+PTKjFhdFrseKmA=;
	b=0Re9rRG/wxnrUR13ndUeugCSo3kXprErByfolTEXtO5paUtGHoGJXfG00hd0iinQGRUlKU
	6pIaIacOypQFjLK5+OkI5h8gsHy7UEswc4yTDDcpwj3uRlgRKkP2/9wIcZLhr7p+68qr5L
	NsvaxAdGWaLvZ5pF6Nq4zN4vjfMWRSo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndYTPFQl;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784639405;
	b=WR4PDD8xdugOQo7O7f+VkXoFdlUAn8J0525s7UEULVIlvdTNCM+vHWrkoFGSJ3HDxnBZ9i
	CaX8WpddxOY3z8dghqUH6rsSuURTvTDdmRjplN7mQSZ+3C6HwaYsOl+ghdtagboqWPEAT4
	b9NkKfYHCl36zHPpLiWj+4YaJ3rwDgs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F3C40BE3;
	Tue, 21 Jul 2026 13:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A6C1F000E9;
	Tue, 21 Jul 2026 13:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784639404;
	bh=se6gqaDgEIcoWq2sYffaHDfDYwxn+PTKjFhdFrseKmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ndYTPFQlYdMidK4292aWniSBa3XvUSwM1icCePULSd+7ZUwX9ATRPlBVRx/Dkyi3I
	 e0D0mjX4RuL6hndf4JYAiZltdfsKCavBJOHp2zPGKBDOJGS2MbbrfrOEfWniDFDRIl
	 gAtimU9BenOKbbwd+L/DwIabjsJivI14QoojzIaeAQlsj438o9i+Pdk99Wlnt0/O5z
	 Kau1jYbinm0F6qYROCIx5zsmjkSrB7DGpmhsRuzLB9XVVIY27L9jA5AQ1QNdGwBtdd
	 SNgjIastSfaPtdCWFTcRKJmmkSbMWJmJhZRWj8Z1UYdJTRS/6WPE/i53CMyU3JojCi
	 /IYAoBJFOBnFw==
Message-ID: <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>
Date: Tue, 21 Jul 2026 15:09:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 7/8] mm/slab: introduce
 kfree_rcu_nolock()
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
 <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42D7A20010
X-Stat-Signature: rpi1utrh9s6tyfcbfmcnwrmz1uof915o
X-HE-Tag: 1784639405-591711
X-HE-Meta: U2FsdGVkX19CdBztfCc/PFqIgyujN8T80K1Drx3dnBsiUv5/ZafshbVl00lVq/7t9sh4EVMrIdfIVb1/RWZs2xt6Su9ZEhmUGhL5ANZOTj1f/ji6yxC+pG69pKxejBkFGwNt+3TYYW+gz/td6/kRakxAa0FNmYJ7k0Tw4n8YikCtEHpjY5GhiRNLVqsGZov6ZF4/a1YB8OQ8DTKZA8hESIkIC5LcDDW65Gv29hMZD735/bkfLon0joBmSxvTMTQy5Y7LbZEDEmU+Vo+/qELJwjBxFpe97gUm316kw165ktAyn1s2PfKd47+bDmZBzyt+83OW7XviXAuQ4Eg5HJt9QQvdxFHd7pcN7dYYIWPnbEkGU1QxcVv6JiZQmRiAKuFNCUoDsPQ5/7buCYx6p4zyDg6T4ubujs5EYKfewH/GY3Y9QiZhBmQ9mp9inMjOOBu5ghx67suSjwAh8sKFq6zav3ltgbuBvU/s7jzN24D/3n//uB006CiVcKP1QRV+xLS/iZkGfijE6kAjSt6TeQJX1/RV30pKvnmqhLFFfXTnA5d4BBTEdogkJ99FWkZsSq4PNObx+i8e0p/5FMPsyp6Eomq6MPaMUavfv7QUYuXOkuKFeIBn7zcZ17qncGMzBNyJiDs+MvJIP3HCem9aAq7UVpSFAtasHbI8820ejh8UnGenuUGlRgVZ4swuCyGo4CaKu7z9OAvzvLo8t66YdxgCXhNJnc/hPofcSVU5tUDK++kyj+NkmWmz4Gnvv0fiGIzel+9X4Dhh2bwLwjp+YZJ8pM9hyVbhTDsuZgmkeg8YenCZthgK3DROJHDqxnJwIuSrTTakuE3TOANouLCM2kVPrsJnd5N/ZTPuTRaMOdEoFALSwlIAsCZh4EHs7sk6MSuaPG+OiK9dtjOWZMC1DaMoX8rjYYvUSjayMZKcfDBj+E4hurkhDo3nbmv65nIrnPCDVVPdBmiZadVqqvkN+lW
 zbkthztL
 H81PfoELsQEGLJng9u4un4Ryo93VASo4Ig3wiV5Efzn1XxdtAZiVriQ5gSXGmYUMkb/SJ+MNuvh9pyTHnrVKPsItI+UDTwP/oXDWVHFuGfCjbUBkOvrw4I1L8bUPXZmM8EFU9732WcaEVvD4sq2ZrfiVI9aZKA9O8T9YBgKCb+TXcc+Ubue1vrm7PICPa1bK1LlwA7ACykNpL+iuN+vHuFwxYcNZbaUmKzesEC3y33darXFJq+oZnQtyNh3V5BfaJo3niNHEZRgrNEn4tLP4ZeIQ4VFviT9MWbuYSiCxbyW526fRknTqXakLC91JGW+dv1Yq6sCuyAolweLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
> Currently, k[v]free_rcu() cannot be called in unknown context since
> it could lead to a deadlock when called in the middle of k[v]free_rcu().
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant,
> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
> __kfree_rcu_sheaf() handles unknown context.
> 
> kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
> path fails.

From the code I would say it falls back to defer_kfree_rcu(), which is an
irq_work that does kvfree_rcu batching? Otherwise the sentence would
contradict the following:

> In most cases, the sheaves path is expected to succeed
> and it's unnecessary to add complexity to the existing kvfree_rcu
> batching by teaching it how to handle unknown context.

This talks about trying to perform the batching immediately without defering.

> Since defer_kfree_rcu() can be called on caches without sheaves, move
> deferred_work_barrier() and rcu_barrier() outside the branch in
> kvfree_rcu_barrier_on_cache().
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Other than that and a comment correction below, LGTM.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/rcupdate.h | 19 +++++++++++++++++++
>  mm/slab_common.c         | 28 ++++++++++++++++++++++++++--
>  mm/slub.c                | 24 +++++++++++++++++++++++-
>  3 files changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index ef5bb6981133..ce0fd401352e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
>   * In mm/slab_common.c, no suitable header to include here.
>   */
>  void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
> +void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
>  
>  /*
>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
> @@ -1124,6 +1125,24 @@ do {								\
>  		kvfree_call_rcu(NULL, (void *) (___p));		\
>  } while (0)
>  
> +/**
> + * kfree_rcu_nolock() - a version of kfree_rcu() that can be called in any context.
> + * @ptr: pointer to kfree for double-argument invocations.
> + * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
> + *
> + * Objects that are not allocated via kmalloc_nolock() are not supported.

Is this true? If __kfree_rcu_sheaf() succeeds, rcu_sheaf is either flushed
normally (call_rcu with rcu_free_sheaf()) or via the irq_work doing the
same. The defer_kfree_rcu() fallback ends up doing a normal
kvfree_call_rcu(). I don't see any path that ends up doing kfree_nolock().
Am I missing something?

> + * kfree_rcu_nolock() supports 2-arg variant only.
> + */
> +#define kfree_rcu_nolock(ptr, kvrhf)						\
> +do {										\
> +	typeof (ptr) ___p = (ptr);						\
> +										\
> +	if (___p) {								\
> +		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >= 4096);		\
> +		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
> +	}									\
> +} while (0)
> +
>  /*
>   * Place this after a lock-acquisition primitive to guarantee that
>   * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies

