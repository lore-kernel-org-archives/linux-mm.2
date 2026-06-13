Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F3BCD8CA8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 10:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2486B0005; Sat, 13 Jun 2026 06:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153736B008A; Sat, 13 Jun 2026 06:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068E66B008C; Sat, 13 Jun 2026 06:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB9BF6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:45:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 817168D838
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:45:35 +0000 (UTC)
X-FDA: 84874558230.05.EDE7AB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5610320003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:45:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XG1hBZab;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781347533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0Rdn7ZGItclRk/+njrMNwKPmYdf4WznHl68jVY8zfQ=;
	b=FELw6ORwJEZYQIkK4B14ANtT8iAIF7hg6eAzCWcIjX+6G2ytpo8CbFRqVIyg1Uvraqazin
	shuF4Bw2W/g0Gurf9r/bMeD/1rzXivrpte7X7ggIRieZJQMXc2q+LusfkbBc0BafvOPdV/
	axO6RwVcSeGfqINCzlLgXTY/KPRABkw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XG1hBZab;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781347533;
	b=aAv7fXjqh0hHWxAr1NOOjyCHr+BpdJvKzf7CGREIRPsW9+XWAA1VaU/bYLqAhzKXSm5M8t
	nZ3DRbf2A+7b6RJ+NlwleZLjFX4KWy/FrTVmVH9MXE34fhkq8FsO7ILDThQGbvBVgrw93u
	FyV92CmoNMEdg9zukslCgCNz98gY5gw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781347532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t0Rdn7ZGItclRk/+njrMNwKPmYdf4WznHl68jVY8zfQ=;
	b=XG1hBZabBIkpL36bh+g4EvuvOFm4yjvsfFicNrPrWms7ju6SDWd/FnmjpLmYty5ldgnVtw
	ZLvoND3Ms26x1E5gvlwN2d4dST8btCG7dJJ0yCwmYz2daI0k5lfN3T/hrXXMx4kp1ndAxt
	u9Ggt9OqOTgRIul6fbeaqDNbtOxl6jo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-1KrHt5iEPg-CfOpTqeYkSw-1; Sat,
 13 Jun 2026 06:45:26 -0400
X-MC-Unique: 1KrHt5iEPg-CfOpTqeYkSw-1
X-Mimecast-MFC-AGG-ID: 1KrHt5iEPg-CfOpTqeYkSw_1781347525
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33E3719540C3;
	Sat, 13 Jun 2026 10:45:25 +0000 (UTC)
Received: from fedora (unknown [10.22.88.101])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D834D180049F;
	Sat, 13 Jun 2026 10:45:21 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat, 13 Jun 2026 12:45:24 +0200 (CEST)
Date: Sat, 13 Jun 2026 12:45:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>, Qian Cai <cai@lca.pw>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <ai00wD4ICs1nk4zf@redhat.com>
References: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
MIME-Version: 1.0
In-Reply-To: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: RDG3v8HKLRsdDlFHnfpd6AcPmCgYduCi3uSQSbszlKY_1781347525
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f43x4o8gcqu3gqc4moz3tkey67iu835u
X-Rspamd-Queue-Id: 5610320003
X-HE-Tag: 1781347533-424086
X-HE-Meta: U2FsdGVkX189C+J6wmFGgKvr/d3S1CJcdXayf4DJ75AgVAWJgkVtPTPwQW4GNKfvkBWqlDVODKzKbzf5a18hayymMEkzZ4HFGwzanXEXRIYsrPdLtyRAkAUqEfsvI43qTQmmj6C+Pu9mvA0edLt5NrDZzPFyRUxUytTB7T40IyEml7shRvBuuRWCmYEqM0QEvdRbkfpUL1MLZPcZKK+9fN/Qj+03CucTOd02Mrnt1D/RcXgh9Psuw8EowJi8hCuI7BaV8s3EhNegDtYpRS2NHBKbmlKHkGLSHBnfEE2NS9/0zA9mQnF3UGQT71Tb4MGTET6Kho6go0O5uPS7I/HZmazba9nTgJAruofWFtP2d16tV2djQgMaQcvODSAdL6PmcAtg1RRttzIObfVHKFkMojOwaIBrOHvfG1kvw4HOrWNTP3/SebYJ5YpDPA89BeZEGBS1895cTH9IXUG+cEAMzfQzKRogsRkOb8naGe+2IC/MXwZFUqr8/uWfjfbLyLrsbyOac5tFJ8xXikgzdj1w2IbDhhp2NRQ6rSI5ZA/Zz+/vx2aLQVN+grLU8PUOsSzv+dAA3Yybbq0PiJOKC/OU0YlWY28lvAtO2/ZUMuA+AftswixLil7Tr+/Wpi/dYpwFGg0B9bofPjqZhyL2c3ozlYYIUdoQIEd8MlkTiboWcFeF2Flp/TYLTBeM6zZzbFwic0TPZndbZaeax7Cwe/R2uYw1fMcRfz+1JbcG3ebVS1LFTavd9N+DyBmkuZNmtEywk/FtBSJ3BVsi/INU1XMjWaSKxJwXRvJ0OJ8Y1tvnOGuJJUKoNO7CHbcrPj62UDFmkCVClJmJfls8AgeCxF38bM9+OR4pkQgkwNlreToUzjeWkK3Yr6uYF44b4h6TNLMuSmStU3Tt2ekjlo+JuOKo4QCa1XIU0Fo45GlzsSr2hHzwx9Q8FJltliy1d4EXS/3w6bX1awG1+cNQAkkaREU
 0tR+Ld6n
 CNFWOFurvU7Upu5TWi8gtthvj5rELI4NDK521l+KcGhIkZtNLdKratxb3xqPzYIQEaHFVso91OTGZJkSqiqN4rGxvj6rwRfJOTKqq2V0lw2HA9pmP/1aKRqo58hOZBjDxMdfdJMTQ8kxD/luibqn/CFIKdd5djrjo6Z2mSV26OtADbDCLB9bfrWLfBbOtmZJUrxRmKztHmiyXjQZD3nUGaj/vwSlXQx964yM8p0LLb38cY9ZYfG5H6cWxMNKB5wt+yV27HvdK2+CWmq2X1GM7rPivI2ief7tXsetZRsyHHYth1Vdn+dXXfn7HkV0hhflnr5EMI4h1Du45MkHJC5EY5hRhirqht4Cc4k8k1Jw1yKhwPv1Cla47apUKBRdIj5DWREVi5rg7WFrTkIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid the confusion, I see nothing wrong in this patch, but see
the question at the end.

On 06/12, Breno Leitao wrote:
>
> +/*
> + * Briefly drop the RCU read lock to reschedule during the task stack scan.
> + * Both cursors are pinned across the gap; return false if either one was
> + * unhashed meanwhile, so the caller stops this round instead of walking a
> + * stale list.
> + */
> +static bool kmemleak_stack_scan_break(struct task_struct *g,
> +				      struct task_struct *p)
> +{
> +	bool can_cont;
> +
> +	get_task_struct(g);
> +	get_task_struct(p);
> +
> +	rcu_read_unlock();
> +	cond_resched();
> +	rcu_read_lock();
> +
> +	can_cont = pid_alive(g) && pid_alive(p);
> +
> +	put_task_struct(p);
> +	put_task_struct(g);
> +
> +	return can_cont;
> +}

Perhaps we can rename and export rcu_lock_break() to avoid the duplication...

And, this is slightly off-topic, please ignore, but this reminds me about
[PATCH 1/2] introduce for_each_process_thread_break() and for_each_process_thread_continue()
https://lore.kernel.org/all/20180912163335.GA18748@redhat.com/

> @@ -1890,11 +1917,21 @@ static void kmemleak_scan(void)
>  		rcu_read_lock();
>  		for_each_process_thread(g, p) {
>  			void *stack = try_get_task_stack(p);
> +
>  			if (stack) {
>  				scan_block(stack, stack + THREAD_SIZE, NULL);
>  				put_task_stack(p);
>  			}
> +			/*
> +			 * This is an expensive loop, we must to call the
> +			 * scheduler to avoid lockups
> +			 */
> +			if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
> +				aborted = true;
> +				goto unlock;

Can this need_resched() check actually help if CONFIG_PREEMPTION &&
CONFIG_PREEMPT_RCU ?

In this case (lets ignore PREEMPT_DYNAMIC to simplify) rcu_read_lock()
doesn't disable preemption and cond_resched() is nop, need_resched() is
(almost) never true. Right?

I guess even in this case it makes sense to not abuse rcu_read_lock()
"too much", but perhaps we need something more clever than need_resched() ?

Note that check_hung_uninterruptible_tasks() uses time_after()...

Oleg.


