Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E049C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB946B008C; Thu, 30 Jul 2026 07:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C716B0096; Thu, 30 Jul 2026 07:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1E76B0098; Thu, 30 Jul 2026 07:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A23C6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:21:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8A5BA08DA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:21:31 +0000 (UTC)
X-FDA: 85045202382.04.16D91B7
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf18.hostedemail.com (Postfix) with ESMTP id 369861C0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:21:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+8Ns1tjeiVw62TmXTCblrxJO367Nd9SfrrC+RLSFCGk=;
	b=8bVEaEEPTiMhdJHo35y8BwB7O/HmAnnw8Sq5/J4wFWx5EHnjOWklTRvIo38t6p2lByLbHH
	7Ubi4YTQr4byBjJhtKPsvlMAK5zOuEeo0z1p0JQDhcypx/ITOQ/amr0sqmvFGq5fPOR6vl
	92flVgOKZpTUv4KSk1tc1obQPsRLHAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785410490;
	b=xjeOVuvURGCMRdy9cNEyEHNa9SJdWkeLd0pw2kjz4tCTzY8r8PDRxgWM0G9HwOtBPpeV5/
	MQWZNSiG57J4+f4emKa8YFLvcG91esFCjo4r4MPPftl3Q9J5inYqVJLj34C9YyIdAZ0sPZ
	BZLqdcxik0xAVi99lPjZGuF6JBmW2dY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h9mx11HjMz8XrrM;
	Thu, 30 Jul 2026 19:21:25 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 66UBLG7H073757;
	Thu, 30 Jul 2026 19:21:16 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 30 Jul 2026 19:21:19 +0800 (CST)
X-Zmail-TransId: 2afc6a6b33af5fd-db3e7
X-Mailer: Zmail v1.0
Message-ID: <20260730192119586UvhYMv4xrNqaZLKIJH9X0@zte.com.cn>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-3-a28cdcda9673@kernel.org>
References: 20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org,20260729-kfree_rcu_nolock-v5-3-a28cdcda9673@kernel.org
Date: Thu, 30 Jul 2026 19:21:19 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <ast@kernel.org>, <andrii@kernel.org>, <puranjay@kernel.org>,
        <ameryhung@gmail.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <neeraj.upadhyay@kernel.org>, <joelagnelf@nvidia.com>,
        <josh@joshtriplett.org>, <boqun@kernel.org>, <urezki@gmail.com>,
        <mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
        <qiang.zhang@linux.dev>, <pfalcato@suse.de>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>, <rcu@vger.kernel.org>,
        <bpf@vger.kernel.org>, <harry@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NSAzLzhdIG1tL3NsYWI6IHVzZSBjYWxsX3JjdSgpIGluIHVua25vd24gY29udGV4dCBpZiBpcnFzIGFyZSBlbmFibGVk?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66UBLG7H073757
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 30 Jul 2026 19:21:25 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A6B33B5.000/4h9mx11HjMz8XrrM
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 369861C0002
X-Stat-Signature: sbr4gg4rscpbn4pp81ycgh8nk7wd3sy8
X-HE-Tag: 1785410489-68112
X-HE-Meta: U2FsdGVkX1+YPt3GwBtp31lN8ejWRqHQt38f2Y2GaNagd+nt2HyXgnhqRK9EIWQpG1/EB1Wv5T4KaFFOePuMdx6MMFkc7HFHvsBdgdIrKioYYIyY3pY19c6wAXO1oZtIxRcsSdQ9UC5/qATZigGIwM5JF/+2WA0RQKE/0GJMHo3a1O/jTgBG9anJz978wbu9sjHytb4CEGzWLp+/4gSB9Rvge0feBP65uwenZrdxKucpbborInNDtZ+4PIL8LxNpghGl98iTrWhz3/AIwLclXlkBucFj1vaHhP41dVN94TzkAAt7WzzLENsubsRyzptZNKOf9CdsZ49/dWQHYxBXN6GrEW5xvdK2Adzo1W3SSNEgtOZFxuPtH9me1C1d7u9hVjs5e6NjTu5X1YoYJOGBfvhye8ug0o9J0P6c3zUWRWyetCDbzAX1cdhI2zYrE5Rz9rr6ppi1BMdsM4mUUJB+2d+LvSJFYiRlFKfG5EPgDKLwVLxD2yDp19phc+32wzgqCPDhjWk5wd4le/Cq7cFcNbC7YifpMAKKX8XP9YXeTqYKoJGWcnglx6KEBYRMK8ZJcN1/y+fLM4yPp5hDtcAlL+TEMkaC/Fb3WW/qojcovKbBvZA16eHCFBPaMqeXwC/M1R5WJHsEkM8ZjR3fqjRXlxmLLCtzQlOO4q2DYe/93rZc3iOyLTjWFA34/wH/HHwCs7xmDrUKw6mJTLoC4QaAKnbgPSSpC74DYD4lgc4hFp1f11gIIM+LBCMeRAyQGrosvhrWzs4P3dUjNr77pBlPv6VQVJdp77VGbcBwrCD3iX5iQ9OCy1mTrfIM8geagW587lMlDcIb1/Kg4PYLX5d90pNNb+EKax/p0/4ZA8gA8FkmHJjIxBoKKbYgoNcqxZprf4kwwk/7ru+SI+NwK2YYNF5HpZWj56HfxWoAONoyJRBIz2s6BphnDRGWLSDoyto5+TCKy0JUfd8sczl2v/6
 KQULNRjk
 uJCjgRGXwGvj4PRGXDI19+ULB9SdwSRUMNEItdD98GQoz8h2qIiLj8HB2EJ1BFRRo5x+rkVt1p4HPw9okEjaGEDlG1CoGsFc7ujoClhtzFDfheh2l5oRJBZ7zyCy/jL5IiJtBaULLysFaW5BefUBeWiQNGZiePywuTOkQkJ4JhRwOPLYMO0y1J1QqQDwPZE4PlijmEST3HAOWyo/6dp1GHfOqmqpyG0sWU39XkV1WoJ/6g5g5sgplaUf9KS4iTb1HTVsGgXHr/+vggTW3twap9EaYYfLgJ7JhIPcJOs7eC+JZ+TbD+D8wyEp/SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
> data structures. Therefore, if IRQs are not disabled, they cannot be
> corrupted by reentrance into call_rcu(). So fall back to the deferred
> path only when !allow_spin && irqs_disabled().
> 
> The RCU subsystem does not guarantee this contractually, and this
> optimization relies on RCU's implementation details. Ideally, it should
> be removed once call_rcu_nolock() is supported by the RCU subsystem.
> 
> Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2c5ba8c326e7..bb0f2975c95b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6157,8 +6157,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>          rcu_sheaf = NULL;
>      } else {
> -        if (unlikely(!allow_spin)) {
> -            /* call_rcu() cannot be called in an unknown context */
> +        /*
> +         * With !allow_spin, we might have interrupted call_rcu()'s
> +         * IRQ-disabled critical section. If IRQs are not disabled,
> +         * we know that's not the case.
> +         */
> +        if (unlikely(!allow_spin && irqs_disabled())) {

LGTM!
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

I initially wondered whether in_nmi() should also be checked here.
However, irqs_disabled() already covers the relevant reentrancy case,
since call_rcu() disables IRQs while modifying its per-CPU data.

The reasoning looks sound to me  : )

--
With Best Regards,
Shengming

