Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A363FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 20:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C72D6B0088; Wed, 29 Apr 2026 16:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578376B008A; Wed, 29 Apr 2026 16:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467726B008C; Wed, 29 Apr 2026 16:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32E7F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:58:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F11EA01C8
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:58:28 +0000 (UTC)
X-FDA: 84712806696.25.270A661
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6142E1C0009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:58:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VxIzY7fT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777496306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1NyF1QURy3vdICAxiB0jl9JGp6DuWbQaRj+rdabH/M=;
	b=d8qwl/iQS8ZiBwbpHzDaozn3F3Q/O+m5/IQ8UtaM7KMAoV425AEgeFix+cP5SPNUwd2hvI
	RwFMT1IrbSd+zsYWKJhZJl6wf7FRLbux4GZrdS365xkJVpYbsRFar12mmT/VhCH6veAznO
	hKHIeRPQDTI5Cj+ujwLMcMgu2NVKiDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777496306; a=rsa-sha256;
	cv=none;
	b=nh9pG9QILxUZKbo4AsaEXCVcGmARWVNcgbG9x+BSHCaapmCJhSR7gHsw8+agNbxdt7kv0v
	ayHzCbP9oeoCiMTlwbjLkEajhVvU8dZCKcApz89+v+fOo/W3Q6FXn8Io/t9qYWaJqvOXHQ
	jfW7kBQagUZRtJepHL81chn9JAK1zXQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VxIzY7fT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777496305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1NyF1QURy3vdICAxiB0jl9JGp6DuWbQaRj+rdabH/M=;
	b=VxIzY7fTq52dDKodSeIaa5hIDSt2feYo11HHRk7tsz1O1Y1+HfrM4wFq8zzgKPPcSZbYMu
	ht/10rbobjNImpvgvGJoXya0zle5vjhdA/eEHrcYrd3vf5s4/XZNGRBbDB2hOAbsxv/yLN
	p7o2iMgYnNinqyMNBFEWeGSpBtMW2/I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-rBBwcJqwPxeaG3FBplukoA-1; Wed,
 29 Apr 2026 16:58:18 -0400
X-MC-Unique: rBBwcJqwPxeaG3FBplukoA-1
X-Mimecast-MFC-AGG-ID: rBBwcJqwPxeaG3FBplukoA_1777496295
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D94C118002C0;
	Wed, 29 Apr 2026 20:58:13 +0000 (UTC)
Received: from [10.22.65.94] (unknown [10.22.65.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3F75300019F;
	Wed, 29 Apr 2026 20:58:10 +0000 (UTC)
Message-ID: <68ba05da-7052-406a-9ddd-b324a349ca80@redhat.com>
Date: Wed, 29 Apr 2026 16:58:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on
 isolated CPU
To: Hui Zhu <hui.zhu@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Frederic Weisbecker <frederic@kernel.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260429022723.133833-1-hui.zhu@linux.dev>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260429022723.133833-1-hui.zhu@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: QGAE2EX_biO6BT3kJ8Dt2aCZMCH9U3uk-5buOx2dmYU_1777496295
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6142E1C0009
X-Stat-Signature: camxw9yfjfhr9pabssdx5q3m4ka9s9yg
X-Rspam-User: 
X-HE-Tag: 1777496306-496908
X-HE-Meta: U2FsdGVkX1//lFGP9SjZN84gwUGhE80VN7kiJKMPP/daTjz65RrGTeFYWL3O7v5wkfRWDBaDnpF26jLzwaa6qicUElGOOwzE/aSUESYyj+BNTryQgSZMJlQ0VbNMPJ0SalpaU7OMsLDzNd5JGZeukLvD4xj0CoEK7zofCny9yD313EVR/xZY9Cg6uCoA7oFr6YfIqs5gKljnqu4XhFqZUBqyhg6kvzyLi8VJoQ4z5GL7n8QFr1ErxpiLa1BYlt+QGX1v2TVAnEPlOa6p67GDXzUqWpJtJ45JiQ7zx4hf8QmdUQSPFof2F2SjJKs31mVWUqo+uRCAgB3WTDZYZWavqkSPqI4RpFhw3yZetgIYNbBBG5ParBxd1F+oCDHYgQPk67/wo4laAu9mG8aXxOJZv4y9MDCG/gqTiCpDrQqnPcEt34Q1xD0VjaMoCaIAehE68wuOQFdmMGx5w8RDRe4dSJVwwxVq8l4T5s1WRX4r5RCz2oWth7g32hTOk2GIFFx1ykeUxQz/dIeMaKeo3P6cK0By6BduWfjfK5sxj8FpT/ainNGWSnAUI/ndf++BBbjoGR6egUzHfsTr2ur6zZ6wLlGKEWqdb6eLrr/tm8/XOPCSXRl11qCapBmMC5gsd2np0mLt97afWaX30yEOrOxBn92jF62gNbRMj6v5NolNUu8iCqosCon8FUIHw2qCdMhHvREe7pKI8uXaebfCXLuDRcvILF41VtNJaFYli38TlaPkVKZqS0nruV50Su9h+Aw11z32esP0Xcq55/5DY6YyLPkcoB7p2Ha9fLMm0NU/axALVvaxsB1d0YuLf/odfQfkdwnaAaAqFpgBDNYpEJmZLx9IBLyrrouIchICTIj86LcaFQpWjrGdh0tifIxM8r9ufK+P8RmwXWkWG7mOLnkbCgBFBhuzEa2oGwQzjBnaH/FjuAZGaN0yr4NWn6aIBGtyXGRG93VvTS8NYr53E8e
 l0UlAhDN
 /ycNo8Iuiu8/5m7d7LmjfRi6bCPUhW1fv03GxIxe0czb3LJcFn96XMQmsY+y7FPTtjDG3FGKhtjNLO3UxYgabyjQ/HbaXZnegBN0GULC1+geL1Vi1cPjO7vCOyndTHVgoTN/IRQavhH5P5Cq4uTkX9B+NA6Xt6sj1tlN0dOQoicVEfQDgEfinkBzoo6OCXT0O/D9F1TRXRjOJCD3pBjnFisvwnD+IKPYdJgruzyj14Y7mrzygpZjhn3YgEG0ABDHZuEklP4oayvZxZ53gWgql/xd95hTA1SDDQqYy6UCG1N0ZgF4LPz26yfzlHl95m36UYdCG2Q0XYZOiMDxu4sjc+Vbdj8JXyMlzS3vlEKtwVPYCLVmHkzTWUDbfSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 10:27 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> drain_all_stock() sets FLUSHING_CACHED_CHARGE before calling
> schedule_drain_work() to queue per-CPU drain work.  When the target
> CPU is isolated (cpu_is_isolated() == true), the work is silently
> not queued, but FLUSHING_CACHED_CHARGE stays set.  Every subsequent
> drain_all_stock() then sees the bit and skips this stock entirely,
> so the entry is effectively pinned until something else on that CPU
> runs drain_local_*_stock() and clears the bit -- which on a long-
> isolated CPU may never happen.
>
> The original idea was to actually perform the drain from the calling
> CPU on behalf of the isolated one, by adding a lock around the
> per-CPU stock so that a remote drainer could safely touch it.  In
> practice this turned out to be intrusive: the stock data structures
> and their fast paths (consume_stock(), refill_stock(), the obj_stock
> helpers) are deliberately designed around current-CPU-only access,
> and retrofitting cross-CPU serialisation onto them adds non-trivial
> locking and PREEMPT_RT concerns for very little gain.
>
> Looking at the actual amount of charge that can accumulate in a
> single per-CPU stock, it is bounded and small, so leaving an
> isolated CPU's stock undrained for a while is not a real problem.
> The only real bug is that the stuck FLUSHING_CACHED_CHARGE bit
> prevents future drain_all_stock() callers from re-attempting once
> the CPU is no longer isolated.
>
> Fix this minimally by clearing FLUSHING_CACHED_CHARGE when the work
> could not be queued because the target CPU is isolated.  The cached
> charge itself is left in place; it will be released the next time
> the CPU runs drain_local_*_stock() (e.g. after leaving isolation,
> or if the isolated CPU itself calls drain_all_stock() -- in that
> case cpu == curcpu causes drain_local_memcg_stock() to be invoked
> directly), and the next drain_all_stock() call is free to retry
> instead of skipping the stock forever.
>
> Fixes: 2d05068610a3 ("memcg: Prepare to protect against concurrent isolated cpuset change")

I don't think this is the right commit to blame as it didn't really 
change the logic other than adding RCU locking. I think commit 
6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated 
cpus") is the right one as this is the commit that adds the 
cpu_is_isolated() check first.

Other than that, the patch looks good to me as the list of isolated CPUs 
is runtime changeable.

Cheers,
Longman

> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   mm/memcontrol.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c3d98ab41f1f..cee77b0a95f5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2219,7 +2219,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>   	return flush;
>   }
>   
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static void
> +schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
>   {
>   	/*
>   	 * Protect housekeeping cpumask read and work enqueue together
> @@ -2227,9 +2228,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>   	 * partition update only need to wait for an RCU GP and flush the
>   	 * pending work on newly isolated CPUs.
>   	 */
> -	guard(rcu)();
> -	if (!cpu_is_isolated(cpu))
> -		queue_work_on(cpu, memcg_wq, work);
> +	scoped_guard(rcu) {
> +		if (!cpu_is_isolated(cpu)) {
> +			queue_work_on(cpu, memcg_wq, work);
> +			return;
> +		}
> +	}
> +
> +	/*
> +	 * The target CPU is isolated: the drain work was not queued.
> +	 * Clear FLUSHING_CACHED_CHARGE so that future drain_all_stock()
> +	 * callers can re-attempt instead of skipping this stock forever.
> +	 * The cached charge is left in place; it will be released the
> +	 * next time the CPU itself runs drain_local_*_stock() (e.g.
> +	 * after leaving isolation), or by a follow-up mechanism.
> +	 */
> +	clear_bit(FLUSHING_CACHED_CHARGE, flags);
>   }
>   
>   /*
> @@ -2262,7 +2276,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>   			if (cpu == curcpu)
>   				drain_local_memcg_stock(&memcg_st->work);
>   			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +				schedule_drain_work(cpu, &memcg_st->work,
> +						    &memcg_st->flags);
>   		}
>   
>   		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2272,7 +2287,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>   			if (cpu == curcpu)
>   				drain_local_obj_stock(&obj_st->work);
>   			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +				schedule_drain_work(cpu, &obj_st->work,
> +						    &obj_st->flags);
>   		}
>   	}
>   	migrate_enable();


