Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F315AD72379
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D179C6B04B1; Fri, 23 Jan 2026 07:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02106B04B2; Fri, 23 Jan 2026 07:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEF96B04B3; Fri, 23 Jan 2026 07:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8DD16B04B1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:03:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0AD56838
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:03:08 +0000 (UTC)
X-FDA: 84363092856.02.4D92856
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74444100014
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:03:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=a2TXmIgH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=LWu1kPfD;
	spf=pass (imf14.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769169786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/X5EsI0mvP/S5uf20Pvy9T65z0CIjEe5oCCyfrYy4k=;
	b=H81jbbHuid5af80fgZRjLaV4OQnyWvvWTD6xAG4pOXoMpEYcJ0y5u60/KL2qCMwKUKIrR6
	C6ePlA7hqDTV4R3GcJBSgSTrLIKCKVPE9LBIBFQveztedisrIVNHZwxKunXaWqp3eY6w2b
	nkBm4/Gfl1RfyKyDSv4aOYFY+lqeP/g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=a2TXmIgH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=LWu1kPfD;
	spf=pass (imf14.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769169786; a=rsa-sha256;
	cv=none;
	b=uHgaTDZuo2/8gM6it5R4E43q1frVV3fo3MBAPr/tGWY1baUnhhckAT9Krt8+K+UYNcsSo7
	V33psmn9KM1BQVIONIdwep6CPs+d+O5FcOWbxVIjCqoMRiTVOU5Ase6h0am3OuIroy7onA
	3YmOrZuEQJ71rWYPLmQZ8zjGZLm0uvI=
Date: Fri, 23 Jan 2026 13:03:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769169784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/X5EsI0mvP/S5uf20Pvy9T65z0CIjEe5oCCyfrYy4k=;
	b=a2TXmIgHE5csJ7d3yjab3MQF2OzNvARYue91SHvMZtiYkscH5h3i/iPwuYxBhtq5ss2Z7g
	OWiOuvRRMR3HWqKIFLIzwayeWIjRhquhTvAi53s0CE87H1xyrUV6uC9uDq/16Etmet9U9o
	rGZo4gUwgYgMlA1aChYnYhgf0eCSUoFrrfupJ0YZkzT3spI4FpNrT26Td90MtrM67h5Bbc
	zUl8yquLCrwWKdaNjoJ6hUbUzI0UslyY7+BZ1W+fuZAIt6qoqR1oQ3PQfy6FuFLb2QrBF2
	qKeWbCQm0kYj1EKwDeLsRLMhGYnCzHZrWlkMhkiQu/OAoVye0CNA/kzGPA0Q8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769169784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/X5EsI0mvP/S5uf20Pvy9T65z0CIjEe5oCCyfrYy4k=;
	b=LWu1kPfDeQQ9VCICNNdwrVE1s6nQxcJqf2a0hPTg4+/K5d776xHUVR0Kpka3InbF5u6jp9
	KmKxHfVUWlAqrqBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 02/22] mm/slab: fix false lockdep warning in
 __kfree_rcu_sheaf()
Message-ID: <20260123120302.TsiVMAQb@linutronix.de>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-2-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260123-sheaves-for-all-v4-2-041323d506f7@suse.cz>
X-Stat-Signature: tsu85ezurc55pyserezpcbdnca1t55dt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 74444100014
X-HE-Tag: 1769169786-327971
X-HE-Meta: U2FsdGVkX1/iLSPrGXHn+QmuwxDBib+jr32jILu6T6WS9c0Wv4AjXjB4Ag8nuxi6jxYSckNU5YPcr9eiuyRqQu4afywIDLEJGCBPCZVByOk4xOagnuvkm0y1BYYiqkOmnKH/kPdUDagiyEQCLcXLNeZd6gkjU/aB2ee5k7nGopQtCrUo6IChUt+7ThHbnXB8PdphWfrkWjYjxi1IS1voQVKoavHdyYDuKg70vg8Tx8Ru7fFrkIlrlnmQxg8N6HhZXVRC5/pAtQCzXc9+x0uxpU76kyJYpscmt8rdk7gSSZoDx44L8zHQHEHTVuX3Ydg8y/pmR49Eg12usvKrb028pQhxhDw6ztu60f2ybhuvm6MEZSSK0z551c8DtTePEsTD0zckis14+D3Kwsm3cf0va1dNC+Cbkhfg/RakHScm8Hs0hhG99BLnGC0TD16HDyC24eI55AoeH0gXtA/jxQQzrqs9rcMdnS75oN8qbL2/7N4ZeELe8m0IyiasQBmvBIWklsx6feNXKtDt18x2qferkJQtTtzxVv8FBv6DDPBrZssR7JjS/cAGtO3ffA8G2qmMOit8VX+iutk0UYdgs0clEdWm0KD2yE85iR7OEN3ZwDu/ZoRYTWykunp6x8skNOXUU2nqwf5hv/8WNJFvkF8hic3EHvLYN7KLvUbU10xt5yVxKv42uFEkSpfJxQ+N0Ocbo6SWJ0je1TRl72FGNBgOr9QYJfW1VpdtQ5EVVjPLTQ9uCDZ3ZBumCESEwSWoHQoyOPW/KgHJHW6byxnSPRximzQNEHbCIy1akoDulbQK8U3YI6mK55JlQ9lCu2BmiHbpX8dT5AToBh10zm8vdpbvwTXjbIgxXwPZplV9bONg/dIZVj72dqHQlMT8AoOqGNR6gt/FuOHGUcyizdBDKpgTjBO1oEb+Q2KMSGyVN/vtdUf7HEcYikQEaeLOJDvISYTZ9MkxOhx5O+XShC3AT3G
 6yj26EPh
 Kn4dZUA/SlJsv1PAZ7iRHvto+kfyknSndciAhEKY5oZja+KhGCa3kUeoZTNrf7JuooLbtwN83o9YMHe0PSJHeTEiAsT6/hdEaJBKEbuwhdSe7JGSh+eCy3SO/GCBIzQ0Eno+iI4ZxCRNlwSoAvJ15MRcDc/alhIC4x52TLpfVn+rRbOY4leCPK4IplB2vQAShshojxeAuVEADxhWc7YuvfdZ1bsHBZvhXJcQw6BVNDckv8yyTS4ose3IYCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-23 07:52:40 [+0100], Vlastimil Babka wrote:
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6268,11 +6268,26 @@ static void rcu_free_sheaf(struct rcu_head *head)
=E2=80=A6
> +static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
> +
>  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slab_sheaf *rcu_sheaf;

Would it work to have here something like
	BUG_ON(IS_ENABLED(CONFIG_PREEMPT_RT));

or WARN_ON+return? The way the code is now it relies on the check in
kvfree_call_rcu() and tells lockdep to be quiet. And since it gets
optimized away=E2=80=A6

> +	lock_map_acquire_try(&kfree_rcu_sheaf_map);
> +

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

