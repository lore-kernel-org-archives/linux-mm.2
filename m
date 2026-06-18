Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCB3CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B0A6B008C; Thu, 18 Jun 2026 12:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBE76B0092; Thu, 18 Jun 2026 12:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D040D6B0093; Thu, 18 Jun 2026 12:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB60F6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:21:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 238131A0159
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:21:03 +0000 (UTC)
X-FDA: 84893547606.06.4483C12
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C9EE2000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:21:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tZJCnIuq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781799661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0TqgCvzrxOigKV5Uh4y3eBAfwHwTb6Ism6AMx0v3Pc=;
	b=MAiYZgidcX0jQdcbsbknRr4oGi6vKvkRsQwSrpdSeNuIhgAPoSvgMtAykqxAdfmReFrKZL
	VM1FvaV0EX57w9MloorwW15Txl3sDzL8vBSP79JhnKKxq2RT1EYbnxaXaNGCcWLJecBkMd
	8U2hs1fedZ6ZTx6YDWJepDYDtaDGoHQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781799661;
	b=t7ZBySpphucI+3EhtGMq9Y1jTlFkvZt/KAshA/ZSYOVN9qZHsov00RbHmegelPa8qSIdPO
	o0pJ51R2uOlBK4B11XAE2s90/dMw//YVDcHUQVrZuUa9KNaDOWNx0joArfTZKwjTXP06Ed
	/bZZ60Hefm5soid0wA+n9X6Ytf3TNqc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tZJCnIuq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-517907feed0so23462741cf.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781799660; x=1782404460; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q0TqgCvzrxOigKV5Uh4y3eBAfwHwTb6Ism6AMx0v3Pc=;
        b=tZJCnIuqaoFNGBrNoUpO2P2DFMMFj6MbiDmOJkDkpi0x+wYmjE4nPLk/KjlCkVr10t
         KNYP1EPW5cwCjr0nz1d8Y0U3OmdDJStcciSXnCVvuo/PHR2AkL+Lvhg4mqFH5ALRfa0C
         c4rS/ui0rMsU7qEjVAXhyA2VdJ16qYSX9Hqu5gkPbpRvqF/hH9uPVNpZmzq49xGOJX1a
         h6kTOKJg7ycyAazSYIjv53DOqns+OLJUmVAEOT70t/mfz/WEqr/SzdV7icsiKu942Mp8
         e7dMx5li/wALLbrERK4PBM7qbH6uQEAqsZ+sVOOh2kCSg9uq0Km4BcUbMth40tU95K84
         kzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781799660; x=1782404460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0TqgCvzrxOigKV5Uh4y3eBAfwHwTb6Ism6AMx0v3Pc=;
        b=Sp4zEYA1a7zMofKOZ9L7p+fJrrv5VsfXiDIHceG4mhbs7bhIO1p9ih3DNJ6hG8ge+c
         eI+wAEACHVcsU9sfkc8+xbioR04bbBSkQIY8w3ei4R9W0TVBZS8AQejBAxJblKZugGsX
         FHLT8V70oq21migyWox7Dl1vrwgZUQVkMv5atGR93FSFqK7jhjovQVfsYgJdZ9/YxErF
         XcXreEVMVQcrZfK1G2giJPK8PGMzoJGYJULd1Eow0fcUcX/x3ctey9c6NaRyBewQZ2qP
         WZjlBOpA5Q8UH05Aud/65uIxi+L9KClk14HQPzGT0a2AI+5buOpvx53tQoUQoZj4dp26
         Wd2Q==
X-Forwarded-Encrypted: i=1; AFNElJ9r5cqcgbfJSzVRlNXXpkH0rs0G9s4JaHOrVeU6Rnth3Uj+fDvh9A9zlMSWf0p3//YbPIZCzaUYqw==@kvack.org
X-Gm-Message-State: AOJu0Yy0YzBveE9UIJ2P0JQalzxyrsMGZodZZ+AayX1MiOSBa1ei3FJl
	+P9MjslotYtSIVCcnFZejeL4Hq4nv9BvljbsnVLMutZQqIu47mSCp7caeMwljpb6MhQ=
X-Gm-Gg: AfdE7cl1yM9ijrmH4mLw7pi5oj3e9O79qOu7bWD4m8LqXUvQwhRjp/oVSMpRWyiChRA
	ZNfMOp+PYKUUIWCR2RzSWS0zUL3i2MYg4pfiLeLRRpFf1xo+qMO7o0ILN7JkTlO8I+I4GKj46Re
	tXiKH3nx1K+MKCRI55rm7SLBv8lAvXxXvwwADjsz32ftEsC0SJse6pBwT8SrDlLS52+pj/PkXKK
	MMKX42zN6p9exXE6pBZr3KmQJPcHCRgck7sNsKo1rjlxU/pBRkQq3HC9CDfoK/GIOk0RHXJCsAs
	5kT7af2ATqbzfAemoDrxfGUon+Vu7HvrW0+LQwTMMuTnoOa0RyihpScr29UBMI1Cs5POsdzr2XI
	c+hgkzW/njtRt/JkvtVxOyjkGetYyY5LnsowjN9hjmhijZnqXgAX/ZA71/kPbQk9k2J4bLPhed8
	KD6/AqgQEDve4=
X-Received: by 2002:ac8:5d47:0:b0:517:5f04:f23f with SMTP id d75a77b69052e-519c4bc1118mr52834051cf.4.1781799659683;
        Thu, 18 Jun 2026 09:20:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-519e1d06ed6sm2389031cf.14.2026.06.18.09.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 09:20:58 -0700 (PDT)
Date: Thu, 18 Jun 2026 12:20:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	linux-mm@kvack.org, bsegall@google.com, dietmar.eggemann@arm.com,
	juri.lelli@redhat.com, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
	peterz@infradead.org, rostedt@goodmis.org, surenb@google.com,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	shakeel.butt@linux.dev, riel@surriel.com, kernel-team@meta.com,
	Chengming Zhou <chengming.zhou@linux.dev>
Subject: Re: [PATCH 1/1] sched/psi: skip irqtime accounting when no new irq
 time has elapsed
Message-ID: <ajQa56F2aOtfVzlo@cmpxchg.org>
References: <20260617175219.2494857-1-usama.arif@linux.dev>
 <20260617175219.2494857-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617175219.2494857-2-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 0C9EE2000D
X-Stat-Signature: nt1uwzsoncm51wnkhw87ejdayp3ziyas
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781799660-51433
X-HE-Meta: U2FsdGVkX1+CG8LaHfr6S8xZ9QyeR8g5tY8U8j94Ea6IEB6lVZ9Q3yHtkF+M9gCABwzHOwgl+ctvSBEGvlWZRmNKkhSaRmHhl3M+02+LRKA3cSinYN8CwqQID6y8y69NVekwWVEE75uIpC90CUTnV7JhsXv/qXgxpucz/2gwc/v/6IiOV/yULK8NDBQAcqe00foszDHnl8alKLfROIV8y3XldhLoE5rg+bNlz4FraUuGjnV7S1y1yKFUHEKOyP8UZn0G49F154KpHlRX77megfgj1/ZeILLDSK5t1fBr/V9Bpvkk0eWyIuvVnPN55qB0xD2kCLjPLgMisx9hMTb6ykSG69NdzHq0uV9kFKnw0S05tsWl/jAbLFYzHwehGONGgLwH2csQ1zUeMrJWRdZEWpQC2cYtZz4TTWOFqYLXGS9BYJIKUdzpEErFE2/KSK1ANoXxxUg0UFezRjmUw/YUpBDJQH8F6U8lu2y9iRYYKiBIPRAVYGdSagb+nrWvUaTZqqmHJkirT94EhofPPbiD6EtRNqDX/j9VhkjF163lyry/D8+io+VNrbxPGjGGFXQvMsLAtK3P1sedlkZ6m5CYDodyrkNaKR8A8VzAeFN/302kEYRn6MIUFyiu2tyaxYhVGR36Oemeyd+QsvPVFZPoGXNtHtBfW6IkDeQ+iHn5iZnaFENllbaSG4iVxbl1PoKxjfZ+rr2IJaETXKYVwM5hjdUYUl6YRdOFR5FDf1yZE6Yh2KSyHQyMbL7MyHV2une/ZLSrKDASHOdXmy/PC/6FvvTqTm7eyTnzGZGss85GaSWZ+rv6dc4wQIxvgzQrgGfSCR5NxUjB22OvYB2JQK5r7PBQO5Av5opXtChYJ2aO7/qI5hs0V2OU/YXxLcUR9cSaLvJJXfaXkUTb/nMx/h6IEQzZcXIcnuPwqiE/GyYbz7S6cv4mvIeFEjTpvGrNczgiiy09L62/kKT7l7Sjx7w
 uunP1pNV
 A21ENGoMTLmj8pVcP1geuO2oSfN5jsJFP+ZrN8mCCdB2n93dnnRkPlacMYOyMeW0zZXPKuZQ+WYfqiL4ciLrDf93reI5P3vi7AVwrKZmbRdcg+7OdNhmwPUxsL8yRlPOdYrLHxNwHpzHMYGkdgT8/n7vrkDX8Q5ZF5T96YfyyAR4Ou/hzP2UgG63L1P5/ifuOGPmeLxKIRdWbaGd8CoXjLthGHhOKkrFQTXd2haoWVYuIhLRpiqPw/IfBNMWr576KGs0DTowvH+dPzwZU0h2CFzFp3OU6ddGaF3BXCrEWXaCxeHMpYGtlYDqIe2xIYuDEv5fMRGGOg1jUaRx7kKKngGWnc7MiWXrowuduP9tSd/BpAkcwChhCggUYiBtfXd1exYDSm/ahtxY0A1b4Cq9ptj/HUv9LBK+8TZuDC5115BcqUBnFxobPnpWwhuayZwF3WVorPexCv2vAGVYREDD+b/Rnsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 10:50:06AM -0700, Usama Arif wrote:
> psi_account_irqtime() reads irq_time_read() into a per-rq cumulative
> counter and only bails out when the delta vs. the previously accounted
> amount is negative.  A delta of exactly zero is treated as "do the
> work": psi_write_begin() is taken, cpu_clock(cpu) is read (which on
> x86 ends up in native_sched_clock() / rdtsc) and the cgroup ancestor
> chain is walked to add zero to every group's PSI_IRQ_FULL bucket.
> 
> The zero-delta case is common in practice -- it fires every time a
> context switch crosses a PSI group boundary on a CPU that hasn't
> serviced an interrupt between the two switches.
> 
> Measured on a 176-thread AMD EPYC 9D64 server running a compute
> intensive production workload, instrumented with bpftrace over a 30s
> window (irq_time_read() read directly from the per-CPU cpu_irqtime so
> that delta == 0 and delta < 0 could be separated):
> 
>   @total              17,229,311    (100.0%)
>   @ret_curr_swapper    7,864,195    ( 45.6%)  curr->pid == 0
>   @ret_samegrp           323,299    (  1.9%)  same cgroup as prev
>   @reached_delta       9,041,817    ( 52.5%)
>     @delta_positive    6,358,192    ( 36.9%)  real work
>     @delta_zero        2,683,625    ( 15.6%)  work wasted (this patch)
>     @delta_negative          (0)    (  0.0%)  monotonic clock
> 
> So 15.6 % of all psi_account_irqtime() calls - and 29.7 % of the
> calls that get past the early returns - hit the delta == 0 case;
> delta < 0 did not occur once in the 30 s window.  Under the current
> code each of those ~89 k calls per second performs the full seqcount
> write + cpu_clock() read + cgroup-chain walk just to add 0 to every
> group's PSI_IRQ_FULL counter.
> 
> Extend the early-return to also cover delta == 0.  rq->psi_irq_time
> does not need updating in that case (it would store the same value
> back) and no PSI bucket would change.  The existing behaviour for
> delta > 0 is untouched.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

CCing Chengming as well, quote untrimmed.

> ---
>  kernel/sched/psi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index d9c9d9480a45..848955f8893d 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -1023,7 +1023,7 @@ void psi_account_irqtime(struct rq *rq, struct task_struct *curr, struct task_st
>  
>  	irq = irq_time_read(cpu);
>  	delta = (s64)(irq - rq->psi_irq_time);
> -	if (delta < 0)
> +	if (delta <= 0)
>  		return;
>  	rq->psi_irq_time = irq;
>  
> -- 
> 2.53.0-Meta
> 

