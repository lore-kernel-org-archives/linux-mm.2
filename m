Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CD7606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uFmtjGzW
Received: by kanga.kvack.org (Postfix)
	id 9C5D36B05BF; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A5E6B05C0; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816366B05C1; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 531CE6B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B855CA0748
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:33 +0000 (UTC)
X-FDA: 85463179746.24.1A1ED59
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3599100008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uFmtjGzW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362331;
	b=tX7Ti2W288hWXwSCBS7LVXWYH3twayWttZ54i5hKvnYb6gc1m9hj/51G9vAzf3n96awHp0
	48BbJWBVTfSJz4ConoauRRF/AKsfkMgSbYJiyc1C+6P4rNXWKCdhaWS6Bmt2yfKn8gepia
	NrAVcZkTW/QwN63IkJDAP4hJBIEdPHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVY9Wj4Bi88UcgFUPGAWU4HWTtYjfgZmL2uHdSwjBm0=;
	b=427dNyDQ48ivHYcH6ajqYlj9D1uPAFZbwiHiueDQCHwpHrmiii23HAX+eoQx/ikAw1iaa6
	n+8jCwPtwwNPuY67u8Vqm0/wpg5w1FEvwhIQ0c5ro/5yplJd73BBdYHuKAlIE82tFaAHkj
	DdugLJaC8UxYHLyfNDyRKzY48nyLL14=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uFmtjGzW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b88b74e54eso2874642a12.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795362330; x=1795967130; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xVY9Wj4Bi88UcgFUPGAWU4HWTtYjfgZmL2uHdSwjBm0=;
        b=uFmtjGzWJmJfVGXAPfenyNltl1kfQFnirpI+dX5/FxSeCrjTa7VXd/tzvWYdlksA9L
         ApIg9bSQ6wfUISip8Jc4LznkwEEoJB359S4Macj2EUg7ABv3XHnn0g3tSnmqGqfqPaTM
         JaD7/RpyfijdxQ9cg9e3KT/kXUoSyQw6E6Z812zDHHgyEqWvMKFx9cvU+x7ynonOHZfQ
         Oye/ugtcgI1GwEWb1tk8LinvB0vrB0gRwuuFpJaNib9yoZutmrDjsZvgu8QCuhMhdVwa
         +/i8m6txcQcnLEpZ5DHLwD6ChM4HonS/lszD5wMVphB7tftnnarD6JCxM/OkU2OyFK2/
         +UTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362330; x=1795967130;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xVY9Wj4Bi88UcgFUPGAWU4HWTtYjfgZmL2uHdSwjBm0=;
        b=OAzU/FMI8Bq28TGhfTt6SImKqmlapkeuh5vBXzP2QkcHLPuajJz0R5yckJRIx+YI+Q
         JSPfURoRv0ygeFIM7lSNZ24kAdD9ePgMpoYuWpbVuX4T3NJpaJxgGyNslgZsjIRp3mFh
         6HFIKi49aTFE8fdb15z7K4OHRC6es2hHD3H9qTZezh4kHRY17e3dk1ouFdms+w5dILC2
         QYPMDQ1WvdtJYIw66GU34TOCU9fTsvKIcdaJ24WMIAdwlVIoSZKDT420TcZq1s+1yWfV
         7JKAy1xgnLKsgztLDmlO/nahO0qqL191TrX8TqgJx6hrHSnDSU4Y7DIkeE+XS7wkFyUO
         TG2A==
X-Forwarded-Encrypted: i=1; AL+hErH5BECJh+YxJ0SrLqyIrW0eULvbNdJwO0c+o4FBvt61bsCRBlr9ui08FZHFVa4k9hVX7AjqFRL3gQ==@kvack.org
X-Gm-Message-State: APuU4Z9tpu3tw0fs7CEEVD9gMSFHM1lkxAsWxbnUQYbGybglttAH8o0x
	tqtFTsUNn5CES4Pq4Q+pkQBG0fparNQsqeoTm0I6Gm43BxYZ1stx5bs7
X-Gm-Gg: AZFdTZdSpboBRUum9FtMf/GGeOBnRdW/PioNytjpWDriXVKN/dNxhuIMtV4oY4etCLK
	4IngEn63cvf5QgGqp/jS8B3eN2OlGZcEO9h7IkJ6GzZ5E/8YivCN73aXfpvAkpL2O4Q4vRiFGnu
	6lgYD/RXKUMMWaj6r24o60kNxHb1IsdOjWZorkPwnHV5JZZdsBQX73CL9JjUtTMITz6GusVtEgv
	aNusrRcT80RA4AXzg6uj7QeR5vztJ4y7BqqKuI3QhFAqZuaORmCC+m/11iC40Ydal3g0iud+Y8D
	BUT8xH1B989/XhF6gfFx76ZzRMHDnei8mLcvPws9EWi2r0htGOLJYuH0Ham3OXJYcHRYgGkPJV1
	UATVCznRqa2OufQdC/ivklYOxdETrTCZiUvW62/LigcmN0kqx3ir0lEQYbK5fIhHunbZ38Yy6Ol
	iHG+f/NFwUjoXOIIzf0HPbJw7KuAcj3eHDBIpYPTcQrmVwi+r9bRX7P/n5wqME3tR5H0gRlRPQi
	SfE1BKDflOUhyQa1nXEvwQ5SBSeTtdO6n3JjarR6KDIZDnu4CgwI2TvhKygEvjvxglkdA==
X-Received: by 2002:a17:907:ba01:b0:c50:521f:13de with SMTP id a640c23a62f3a-c513a897601mr692846566b.35.1795362330344;
        Sun, 22 Nov 2026 07:45:30 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ad01ae8sm339135866b.9.2026.11.22.07.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:45:30 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 22 Nov 2026 16:45:27 +0100
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: vbabka@kernel.org, harry@kernel.org, urezki@gmail.com,
	paulmck@kernel.org, qiang.zhang@linux.dev,
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <awMOF_uE3cpV9dCn@milan>
References: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
 <20261120083707.296481-2-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120083707.296481-2-zhanxusheng1024@gmail.com>
X-Stat-Signature: qqu5y8j78yzt66acefj1tnzh7g59rpwo
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3599100008
X-HE-Tag: 1795362331-253042
X-HE-Meta: U2FsdGVkX19aVtWfjZlLQhJraKxFknv41/sMhuAuGtVhVEDrPjzUPJjVHjvDCPPSOmf4+o1LZ/taZFvf3Qv9oAr3k7YJmXIVOduclKY9Nj446hKHr00jxHgnVQmCReR6RS1Nk5Y6LuKI/GR0PfCwcZChIwrW+WUtbZdMdeNzjpUm8OCshBhUEO873e8FpvjduvroS3CBZ5xnVcKgyMf3sAHLiV2QkQkkdOTsuH4Bo1IPrgIFVs00P3EBT6zYIYeLUpFfBfH/ijp4HG0dGp1sC3Y3PTRzjcAeGokoRf9RerFAYY9OT89PUMHV9IoHo73v/uGd5RlCM0Qz8FsDnvQ2q5wIIc+UuwXt/fy0dhIpL3fn0GJHj2k7/GDOa/B5s+/8Vm9G7tTMrciM8jNs0py+ku57vc1S2TnaTUyuBsk8N93Y9dYOhbNntIjR2DaO9ffKtwNgqV9IwInbAB4LvgL53h0oy4lPeoXvNeii2k58YBLLlrT4WFL7xqKIpjccaWjQ26bxGLhsFM5MlGLoAwxDqHFcUdpUzdOPoqs57rjUvkOOP7PE0H8cmzO7RDLm6UFw/2O3rBtafxrAJwi8t0Tuwm3RhIZxTCf25lTzouYPC9GTSFfh4TryF4y0mJIturyjgrvpOUzSSRWpj2sLDISvD4VskpGwecWIa/LI5OQLyzhsR8gEwYJwkfqu0oIruSFozWg5gdm1Ti9xh/Pp36C8QUBCjPmdDrukfqmdmKV+jw5LQrfsonaIF4iwakg58qOZzRPdX0R0ipG+w0wSeCtpyQVRlMq6N9DUT9Oz8ePoVzkqcPl1AjrVLrwUQftUihnW3Q9pDAf2NKxWpIVFHZU39rmLaphWg+7GyKwAuynG9iDfXKjJeLx0n083/iPcYaQ7usH3Uo5pLONmEWTuf27l+Dk09yO6CHBXGgWitutzRmrRWns1vMRbo7BWTAdno9CkSU9/xbc9iGzC3Gav4No
 jadOt0ES
 Hnt/C5NM+EB3H7CV+ULo2XjC5XrI0r09axGtmzB4m+CZjlqd4zip2RcDSj4kmBT78FxNcuuSiu/3lCCOgx9MU7gB8+atnwPbrXYCy7vKyIuNl1kdaQUIEuB62oCSZ/TmwV6O/gSOicBtdSMTiYOhQH7Djjsj7H5AqMZiK+wQMZ8OP0cNV8mduHNhsiwVnQ4i2koeMGV3vJYnm0CQExhgDnXYo64oXecy7TP6pS36cgpsYT657FiMsQn0xoxXooab9Sghc8YSH5UzJhr9PcPkn/k/AtX/bsPVB3D1nLiT8BXORsI+wp8AQuyqMLa/+B2yOZlOwX00+psyeQpk5Nv5nRn0tQM9cCrhOH5pZT8ew+Xm1pek9EcVxhurekhnA/Sst1XWKvldJJkvL2klgmqRIiSXhETDYqkgO5OPXvjstj9JrfaC4UKQye0eRQPqxXw8nw+WRBXr8Xfdi52GgDgLUW65OsAJeEnYPynCoozhM9PsVP6ueM9j5xcU4Nown/pgwIzM3nbcjbl/xqX48/d/K34hVuGR1YS62xHnE2Fzir8k+LAR9ZFCIvlo0mZggHruywEpUYbyzbK8a31numYP1Y6INjkMy6fh3ZBleWCAHBv73HpbtTs58Kab7PUdatt4Mirs5q8bfwGu47Y+WlUP7mtOVjn1QtTOeCPSORd61CKDOmtRRGbirIM6BX26/kKFtFUv3wyFFUmU3lFE/27OgV36PFGsAZT+mwqzs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 04:37:07PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
> clean context") deferred page allocations to a workqueue. To avoid
> deadlocks with the scheduler, it used hrtimer to queue the work instead
> of queueing it directly.
> 
> Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
> pressure") later added a backoff mechanism under memory pressure, but
> did not consider that queue_delayed_work() with delay = 0 immediately
> queues the work and introduced the deadlock commit 56292e8609e3 tried to
> avoid.
> 
> run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> callers that may hold more, such as set_cpus_allowed_force() under
> pi_lock, so it kicks the refill work from an hrtimer. Under memory
> pressure it instead queues the work with a delay of
> rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> queues it at once, taking pool->lock under krcp->lock.
> 
> With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> pi_lock after a drop_caches makes lockdep report:
> 
>   Chain exists of:
>     &pool->lock --> &p->pi_lock --> krc.lock
> 
> A zero delay also defeats the backoff, which is there to defer the
> refill under memory pressure.  Clamp the delay to [1:100000] ms, so that
> queue_delayed_work() always arms a timer, and update the documented
> range.
> 
> Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
> v2: clamp the delay to [1:100000] ms instead of using the hrtimer for a
> zero delay (Uladzislau).  The changelog is Harry's version from
> slab/for-next-fixes, with the last paragraph rewritten.  The
> Reviewed-by tags of Vlastimil and Hao on v1 are not carried over, as
> the code changed.
> 
> Tested in a VM on v7.4-rc1 with lockdep: with
> rcutree.rcu_delay_page_cache_fill_msec=0, patch 1 alone reports the
> circular dependency above; with this patch the boot log says "Adjusting
> rcutree.rcu_delay_page_cache_fill_msec to 1 ms." and lockdep stays
> quiet.
> 
> v1: https://lore.kernel.org/all/20261028134647.3176080-1-zhanxusheng1024@gmail.com/
> 
>  Documentation/admin-guide/kernel-parameters.txt | 2 +-
>  mm/slab_common.c                                | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0b3c140babd9..0d1d76a6af70 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5763,7 +5763,7 @@ Kernel parameters
>  	rcutree.rcu_delay_page_cache_fill_msec= [KNL]
>  			Set the page-cache refill delay (in milliseconds)
>  			in response to low-memory conditions.  The range
> -			of permitted values is in the range 0:100000.
> +			of permitted values is in the range 1:100000.
>  
>  	rcutree.rcu_divisor= [KNL]
>  			Set the shift-right count to use to compute
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 41dea01a8c1f..6fb453118641 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2262,12 +2262,12 @@ void __init kvfree_rcu_init(void)
>  			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
>  	WARN_ON(!rcu_reclaim_wq);
>  
> -	/* Clamp it to [0:100] seconds interval. */
> -	if (rcu_delay_page_cache_fill_msec < 0 ||
> +	/* Clamp it to [1:100000] milliseconds interval. */
> +	if (rcu_delay_page_cache_fill_msec < 1 ||
>  		rcu_delay_page_cache_fill_msec > 100 * MSEC_PER_SEC) {
>  
>  		rcu_delay_page_cache_fill_msec =
> -			clamp(rcu_delay_page_cache_fill_msec, 0,
> +			clamp(rcu_delay_page_cache_fill_msec, 1,
>  				(int) (100 * MSEC_PER_SEC));
>  
>  		pr_info("Adjusting rcutree.rcu_delay_page_cache_fill_msec to %d ms.\n",
> -- 
> 2.43.0
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Thank you!

--
Uladzislau Rezki

