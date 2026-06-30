Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA67C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5936B00A6; Tue, 30 Jun 2026 12:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCC06B00C1; Tue, 30 Jun 2026 12:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD3B6B00C4; Tue, 30 Jun 2026 12:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166B96B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:22:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4161405B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:22:13 +0000 (UTC)
X-FDA: 84937096146.01.681234A
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id D31A120011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:22:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CEl4rS3z;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836531;
	b=vg5mRcp+qdlluOD0Iwj4+eacyytRzEEv9+Y/0oJAlZp+VT3ABVFFkvSP5lGDucCxKWI2/J
	uaCCuFzgUrBs4Kj4RbTN2hQ4ZHpLxJcvuFTe+9+9eERRMMdtoSywUSwsN1WXDWFR2AuRUU
	+9SUIHvti85y2xcBz6LcdQQbZg70IvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acv2p4BFA8gRpGMf2Eyfsq9WFKOfOwtHU816xigiBjE=;
	b=oyRgrLqXmOBhfR8lXGCV6rRs7hEFgXx+mlhZrJ43CuJPF7LugODVQ9t82fU6xAI2lQFWYr
	dQDVIQaVjrxVI+OkWqdU0IyRuJc+CaGXyTvKcsZaLoJTTeInxZOaAkAsf+qhUNomk6G23m
	zwedqqNVwCf/6DW+/dfTuLk45vSJdrI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CEl4rS3z;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6a168dc590cso1487856eaf.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782836531; x=1783441331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acv2p4BFA8gRpGMf2Eyfsq9WFKOfOwtHU816xigiBjE=;
        b=CEl4rS3zHqnub+LDXfOeWu9PU1FihDOAVkpGQ0hAvsxoAPX6N+tzVMYF5xqYecRMVl
         uG1LHPXgxz+HNn2mzKBwzcDr7Xhz4bIkXyXEWE1n0DAiOIusc/KI4ht6P1aOYohZnMCS
         NZ0ym0Omyfue5jywqZZE6yJXKsIGphv1W1GercPv4runI6Ewq+j4X+PuBUi4TWnS7DFV
         ThgboTfQRX8sSr3LHVMJ/udR2Nf2BmFZDwoHkUSVQzrEbmrdWoup5vYBfek3I22f/Kub
         EbU9c/Lcv5MCzaGKQRCkxiCg1c5Nn6bN44YB27PDdJWeRBwcTFZXGJCPslQtJ9l3v7Wh
         /fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782836531; x=1783441331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=acv2p4BFA8gRpGMf2Eyfsq9WFKOfOwtHU816xigiBjE=;
        b=ZZnVBZdglFDm6eqrFipnf6uIjwmqvKB4agUjG9Fkr/hTw2LimYp4PZMvuzto9yR6bn
         NvjxzNMbPZWgOmOwU5WsLtnS7Z4E2lum+hgIsXTVzyo0XyUFPGiAy6DCx2n/5hlePOiy
         LLmQDnQkHC9peOGr1ALqzQehg2xOzjjY3J83tWGr6NnAmyXzrDESd8S5mUvlgU0/K1c2
         XSal76rdFJdR9Ju7nCACWyrQ/4mDw7qapMUBw5pLA3xn0QxKK+DOQTiy1SZ2jHxfmdk2
         /+SgjFRl+RuQe5liApUb04NRZFABofmcTscsbmgiJgznOp/3kRJUnSTsxDW528GNXVUN
         sGsw==
X-Forwarded-Encrypted: i=1; AFNElJ9Sr8PZbjsCv+K9BlzdMlKyrUbAytICF1oi6kdIWhKcrfUAt7z0LuEtPamEseSMuRvGOkinkoz6dQ==@kvack.org
X-Gm-Message-State: AOJu0YyethTl0xOnyFjCHxhDFZU9yAlxwtDKzO+E6ePlm0RRdUqP6qaY
	WU7hN03DF6wZm3jtxXIxhME+16e/j70hgrgoM9G8XEBekHNWft01ltVB
X-Gm-Gg: AfdE7cnIjtah/0KTHeLA4vRLXYhj3+XqGooSoKVd35CEMKm5rn3FtzniyEoYXL4vqLd
	HjdmOIHPgAJHtQ3VaBkYyCBPx7T1hC1so/qTQ9HCLbXvZogYKkP4wgymXXvj2EMoJyAnYpCusSF
	68ABXn4xKLSPc7fSpSl1dByVty3lW1fbu5BFyrPzKrwjBD+XUwCj6uD6gAkBMHXlsvkFC3Z36fN
	KcmO7TsTAWlzdYTPUXFv5aCgrB56jTTqSQnHSDVsa/9SdGh2hL+TXA5Vg+QZjN9HNfqNuECcRrY
	i5Yol8Z69zefVckNAkhhwnFntYWJwF/wMJDF8X4wEwBPGT7w2lCn/5NRFf/adg9iFo/+hvLTYkm
	TThmota1b1k75X+0j+i9jDEriCVOyLvvWC2pA/d6quH9FeX9wNq9zQBIjxSZrduVH3eqrxYXvH3
	9Z655E6joo2tfDssW0qaDxTXrUbol6tGtnBPRO2/mHBfE=
X-Received: by 2002:a4a:d2e1:0:b0:6a1:154c:8199 with SMTP id 006d021491bc7-6a1891d3bdemr2567738eaf.40.1782836530787;
        Tue, 30 Jun 2026 09:22:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:13::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a189493f93sm2155547eaf.14.2026.06.30.09.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:22:10 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RESEND PATCH v2] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Tue, 30 Jun 2026 09:22:07 -0700
Message-ID: <20260630162208.1159952-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630070004.470181-1-hui.zhu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwco77n9cq3mw4sbmout1uinyg4otszj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D31A120011
X-HE-Tag: 1782836531-987017
X-HE-Meta: U2FsdGVkX1/QPOy1U4sudss7bnG0heZDN4MbEUq1jpc5mwzyN/7RB0Lfs0Qk64kEZsvPVd/uW5KB8FxN3bpgB7JyTHgsHTYa9U9FmkIcJUI8iLkCk3V+x7zwJQdKP+mGB9KwFW8wb2ApHRiUwwRmCOLn/43gjG34kzPeBdWqBfel/xl2DO8hC9BBWVBcNcc1yi31s4Ek70bCib+RpGsRVnvkUBRXvGF1nNOv4L4wIPqfHwlLkCVxRH/EWvJW5WYi6PR3AJBC+9YRbzxN5N89nwWxUh5Fl+fdsONyzFZNVZf05YAi/LWylAAZfzqWlrJFOcqDq1/BPGqy2VdjA3UAvHeevzvUB/syXLqj33tbGzHJ3G3tAS0luuzxPfrVQp5Xy3GvKmJT6kgplDo6sbdgdQMctbUsZhURNLTxUCmx7R65tLfbSnIWWhvkh3UnNrQBYPdlpccAxDe2AGwT8gkBmBIdUD4TNceyRU2VxrfTAvkczg53BZNF6lrB2OgiBj0rL+Tf9oV4+lva6B+ZUoXLlDAQPOMG9r2JViwllF7fStSkt/YjxSJm6VG9O9PpSu08RuMtdxBXyOEMZznk+fdR8RHZ6W8IUQEn71YBgaM33VrBHBOrxUJb3mdBPSshW/275dJJ7+illCWTmLAKOfx3CUvLnnTCEpzEPIaczJsYZWj1EhuP/on2NZFZQAsz1EWQNaRc50C4h/f0lqdvbszNvvwJEHQAGXWUhlQ2aW2ry64oFkJn+lkEGmyVtP/+sbjvflTeKDd/XZHS44o0dVKQR0q6iyIvwMw6oFKpdYnyU/SZSnPLfLosS7FnvWz1s3kY3ASCbaIetrcZ6+YEV+GZAyJsK9ggZE3Q5IKCqzKSzIHE5HoHH2WJTe0IiKpctGI0sj3e/VeBulzBlwr6xSfKRhae6aoKMcwT3hI/0hv0IjrzibiO9G0FUb2Y4X7wE0uEJnmVqMBxObpVSSOyBBM
 Sd4t6NBU
 cw6mR05IdYhCdFE0aN+0V8dhpVBCswMxS8fFibRt3qGF16blGCwxgDZXNPKUESB455rLvSJNbhxjFEGEeg0d07yw0JyBqCjLVEYg1GLdMCbViiAt8KRSR89cxyi7Aw3Vdh8/BINbONwhkewErMebsPAdil81wugnkw6ehZ2Q77y2dscJ3ijPjrOZ/xbzkYPdGKrSVIDjvytSkzzCKUYIZe92qdOKVD7cIwyFvBhyqGDo2eyDWBlRdQLnIOHEdHS2Idg8pWeEa9IpxXWG6HEHWAp968l1WzpM7ti+8fjQHI/gBTWDnE144KNwrGFjgvL74kXBidcPXncTzzXiwEqByXSR37MXytK+0H1h0/TVahWjWFTZuCDjEwgU6eE1b/va85s4vs8u3pddWRRfEPVDZ+0+ZZMBq/ihoN4+K1xZ8wt/GP+vs7EHt9QZ7geIXemTAIZe71VDgZGTRxZ0MgnRjc16aNBclgY3TnruIO2B08PbI/dA0lfu/1AQ3m4se3H0NyCYbDlEhnak3depGielXbEHsgobp6DgeDYecNzL7PmmtB1dg+s+bL64xBg9E15WQpKqUw+/hqpTuhzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:00:04 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

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

Hello Hui,

I hope you're doing well! Thank you for the patch. I've also been
thinking about memcg stock and specifically on how the flushing happens.

I haven't been thinking about the issue of isolated work taking a long
time, but I have been reworking memcg stock by getting rid of it and
pushing it down to the page_counter level [1].

I think that this patch is still important because of the obj_stock
portion, which my series doens't touch. I just wanted to bring this
to your attention! I don't think there should be any other problems.

Thank you again, have a great day!
Joshua

[1] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/

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
> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v2:
> According to the comments of Waiman Long, updated fixes.
> 
>  mm/memcontrol.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..2e66b4a2c25d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2256,7 +2256,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static void
> +schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
>  {
>  	/*
>  	 * Protect housekeeping cpumask read and work enqueue together
> @@ -2264,9 +2265,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>  	 * partition update only need to wait for an RCU GP and flush the
>  	 * pending work on newly isolated CPUs.
>  	 */
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
>  }
>  
>  /*
> @@ -2299,7 +2313,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  			if (cpu == curcpu)
>  				drain_local_memcg_stock(&memcg_st->work);
>  			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +				schedule_drain_work(cpu, &memcg_st->work,
> +						    &memcg_st->flags);
>  		}
>  
>  		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2309,7 +2324,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  			if (cpu == curcpu)
>  				drain_local_obj_stock(&obj_st->work);
>  			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +				schedule_drain_work(cpu, &obj_st->work,
> +						    &obj_st->flags);
>  		}
>  	}
>  	migrate_enable();
> -- 
> 2.43.0

