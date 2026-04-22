Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AF9F9EDE8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C776B008C; Wed, 22 Apr 2026 10:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713BC6B009B; Wed, 22 Apr 2026 10:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6296F6B009D; Wed, 22 Apr 2026 10:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F61D6B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:41:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4E5B56D49
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:41:27 +0000 (UTC)
X-FDA: 84686455014.04.A91817A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DF568000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:41:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQgta47K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Nth3ockCftt2QPgRoNICuh5oG90oerc7fjgMlDtXgA=;
	b=T+ESNDV83tT6czcTh4h+ObNxONoU0KuWERpt4GCKQGT8lwHDqyu3TV3veazpEazjptbyQR
	qdKmil9fLJaYJWg/ksDMOGZJmLdeA5iVxExSwB1qHd7QvGynBWUbEkyyk7i3lWiXIwGcto
	PV84R2t5F4qW4upbQgD1lA82vEfcUp4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQgta47K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868886; a=rsa-sha256;
	cv=none;
	b=BCxUsldYGvr+y6STTo7YG5mukLDoiVujG36aB3UsXkQf9cev1zAhhDOQ8H+04vXZdW18qJ
	JjUfXqsnKyodPFm+WMNKENTzeU88NYQYXco+L1aYk47AtJcxop21kaMn8zTANUUbubgS0L
	ype9+ZgvG8nZ4C0g8FTpnVp4dsLP0fQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADED36091C;
	Wed, 22 Apr 2026 14:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DA1C2BCB7;
	Wed, 22 Apr 2026 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868885;
	bh=sBZkncgimPUsAy5Xxrwc3HtnSUuzhD/pRnZRRpvSt1s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CQgta47KOpcVfZ8dy283/Lp6ixHiNUQH+BmGB4A+Atnyn81bVCZ7G5i2ronKUv9k1
	 gruA+0U3wVxM4Qfs54lJMo1c+joC70nhY1n4RdejDFbnaXiUisQ5aYW2HhrGQsKP9D
	 Jv9OjP9Ugr6xZ6swXPalrB4qAGA6S1ZbEMSVjQjwjLacIvaEzNyB6WWdXsou9weC/s
	 BRlXxFHZWrxIul2fIbS7a091ttgsiV9zSIHlGAttVwIw+2sLK8GcGvmdmKpnBMgpWc
	 mlOoiOF3a0myqj8JlcDPCtxwIYXUjhqEBPimuhGhRAjjE9Rq241mfv05QI/vM16A86
	 jNrwMEppT+/Mg==
Message-ID: <baa235a3-59c4-420e-8f1e-40c8526f3bf2@kernel.org>
Date: Wed, 22 Apr 2026 16:41:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-2-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-2-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DF568000B
X-Stat-Signature: gu6s4zn191a3ph5yc7sx9zf7or6k633n
X-HE-Tag: 1776868886-428286
X-HE-Meta: U2FsdGVkX1/FaaQKWcZSHCqtxMu5uO0KM6U3PFLt9GMlyjdDv/hA1BzRKZgNGeVqNxEocR+33DEyUgth2g3hb0ywgTbSOrTbO45s9qCx/IPadeyEU3bqhGXrudvcWNlLEdH2oK2f1hM836/NoWxyjxA+Nj3PTQgV/Jhxc8qsN7mERNintt8g46VRf8fWXqwYvoTgTDw9sy0Lq7SqKiF+HfWIQYIabnnfeyoRyuXnZXsdXIcn4ibP2vSVEN4LqXb6UMGjUaBXd5916mklMM34v0Zaagxp7YgxlnP7XvA26NB0jKQ+bY6HudriwFFaewW9zDmnrYXDR9kV7nkja61F6DhArnV4w5ssavRaQ0RIqxJJgX9KjjmAHWPl3RSNDjZmftdgbrgE/9f5jeO1D9jGeRdNZFaPvpDRqb2ura3cGxEEkVEi6JD3/5cPEFkzk9YCQqOO+AqPdFHpZNq77cQDKwu+Dj6nhYK/kgxnotrLyUK3fsNry4oY0iHgSIXFnj018HqYtcipDdZiQCl6cK7XhGBwVxy2XOqjwWx5h3PZdCCe+dAoY+3uOybUnILN7adych/dfgzKD300qxaEaFZ5T/od6fDvJ0K6cpzgoeA5JL4YwgFw6Tq2w1zojK3p7q7oUZD+U2ZsqnxkoiMIhlkTV3GZTQWyGDXPBpzUNlRyxtT1U4W+R99dwm1bWogVCjnP5RRy0CShdTWxnO2FV57G5DOsiEUyGh4kxPUOhoiPR9YvU+4WQuGB6J1MZ7/7mbv+BFvil+KJhGhh8ANHhy90TiAxGZ3KEVh5x3R6DedY4LgJwQ5ckw9u89O0LZkUA3tsFbOhrqbv6W7N5kbFTgmuFU27udi+ihMF45J7H0L4wGenjF4UEFr6WUpodNDPYoC+Z/ZUuq7lvQLn8AZXT4q1cRxH6TbZzEMBRQtpIs0E5TjkmbkfWZZlMvH/BhZxl9hWZk5vrfdJWfZBDTWXv8x
 rs0aW+bC
 X7aYYMrhWtlIWgBLDYQ8EPE7KdAFLlf6RCTD8/Y2cMKoz736CaqLPjJmEYOJWh/sWr/bJSUqTMTq/qpIXEhHsC8NENumtg6JVUf6dTCTulLoQjXMsW8mIrsNynIXHcXScK9BijQRc8IhXY9/xDMN5oI9AQfOfgZcWf1aZ9nJdUA/ZuFiemmxGHxOMX3sBfDJ/fkZPwF8cr/fk9jHfIbWiz7cfYB/9N+6QPEwnGTqKWEjMrueeJgJzNlcrWceBKzorOkuFxfdUJcrlW5XSpS8aB3LqZmEHUMHdopqsVKpViGIHXHB26IO5z9n7xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> @@ -1523,18 +1522,34 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
>  }
>  
>  static void
> -kvfree_rcu_list(struct rcu_head *head)
> +kvfree_rcu_list(struct rcu_ptr *head)
>  {
> -	struct rcu_head *next;
> +	struct rcu_ptr *next;
>  
>  	for (; head; head = next) {
> -		void *ptr = (void *) head->func;
> -		unsigned long offset = (void *) head - ptr;
> +		void *ptr;
> +		unsigned long offset;
> +		struct slab *slab;
>  
> +		if (is_vmalloc_addr(head)) {
> +			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> +		} else {
> +			slab = virt_to_slab(head);
> +			if (!slab)
> +				ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> +			else if (is_kfence_address(head))
> +				ptr = kfence_object_start(head);
> +			else
> +				ptr = nearest_obj(slab->slab_cache, slab, head);
> +		}

It seems a bit wasteful to do this... (especially the virt_to_slab()) part.

> +
> +		offset = (void *)head - ptr;
>  		next = head->next;
>  		debug_rcu_head_unqueue((struct rcu_head *)ptr);
>  		rcu_lock_acquire(&rcu_callback_map);
> -		trace_rcu_invoke_kvfree_callback("slab", head, offset);
> +		trace_rcu_invoke_kvfree_callback("slab",
> +						(struct rcu_head *)head,
> +						offset);
>  
>  		kvfree(ptr);

... and then throw it all away and let kvfree(ptr) do it again. So maybe we
could then call something more internal and specific based on the result of
the above.



