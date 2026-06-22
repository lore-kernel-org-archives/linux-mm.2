Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EA2CDB476
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F056B0088; Mon, 22 Jun 2026 04:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836866B0093; Mon, 22 Jun 2026 04:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDEF6B0095; Mon, 22 Jun 2026 04:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C386B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:42:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7D751A05F3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:42:48 +0000 (UTC)
X-FDA: 84906908016.13.B931F58
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA4BC1A000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:42:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gz+qjixe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782117766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFnA4MB3rhX4hW9kwKpEDdWQh6n3FEg0cpZAkJWsmhQ=;
	b=1C7rgYwjTjSKDCGEvoePUu8zJixOolIbYt2BBf4Nce5RoFCxsOJm3+iQBapTwuFqlWeoe8
	e2A3H/fsl+0iUS1R4IWPbLHZZEqLnAeTcnpiqWgeZPwLsPjufhMRCVikTOJpj8q3rqtBOZ
	fwWKpCZ3xvooTYqBwxhh0VBKQvBtdtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782117766;
	b=Fnxdi6PbRKmlOXOBwbmpK9Zl1M55nujbaomEqRVuL2YFphkfQPuDq6rj1hTAtd9rQ7KCPK
	MytOt0vH53SSya0hRe+WYzE9Jijbtq90aW4PxyT9VWof53DVrOXGKoodGEtbQM9Ln5YcJ/
	sykaLHBJLsX18oU3OtOQGc50oGyLpN8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gz+qjixe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-464192ab2e1so2533349f8f.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782117765; x=1782722565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFnA4MB3rhX4hW9kwKpEDdWQh6n3FEg0cpZAkJWsmhQ=;
        b=Gz+qjixem/jDbQp4qC0sJrX2ZwxLG48BX0QqxH17IK9H5VIenNA+CaVCZRJXFiL++N
         GYMzCpB/r5317UhpPdQHDBaRS1hK88cIx3hNwypGV3/mfY02TIOnwedFtjC8/DSVXiZo
         M7mfdFtm6fbkTURPHZmtXOSpxuXWQxjipvt/2uAgbsc19riSzj+mq6uWx413QBM2z3eY
         hSyahrXHEbS7RNddJMzviSEOPRI6Mkrpm1NMloCXEtlmKxGDT0DF7f/tBozPYhiniBiE
         iYP8u6KIMhssj5NzV6ob4yYtDOKE51mTpC+Ry6Rt9LBvW40G/44fTj9PQSptw0QQXv7G
         HmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782117765; x=1782722565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bFnA4MB3rhX4hW9kwKpEDdWQh6n3FEg0cpZAkJWsmhQ=;
        b=VWpHTpqaWC/uWUGpOtZpF8A685Q2Ycgc711QgnIqhnfEkjydldxXKqTKiyamKEX/Nd
         ugDnxCTPfSDtPymoE/MK1BQ7CQjrFQoFLr9sby9aUASxKkTQ/X2Hf6nCQmXrBeWqqSMR
         zAOLPJamGnRBcXkAfNhU/r8vvtJfKboZhvexzDwGl7tkodSnso/n4E9WvdLnbehQejRA
         ksftWR7wdp0TBPGOlMdWShGy/CsXfwjx3jl+18znZ9fj1wMD4iY2yom8hmOxkok9N/vI
         4Wak6WhMLVOmlXcq8lIMdXiIDSMWM9XMRMEW4Hk7iSG8PxId30PezL4Slysd3xaFH7X6
         baUg==
X-Forwarded-Encrypted: i=1; AHgh+RpoByN2FGZd9p6sjvRF4LuNT8AMjU1nYXcUNbwyKyjqvvEUCk3EbaLRvhJN5g90094KW0HWauZYAA==@kvack.org
X-Gm-Message-State: AOJu0YzH7LNhE2u16NSWuFyMLhW81aJ6i9+aTEtTxGGs335oqQ4TyUl+
	6Xk6o3l912/JFRbs6zDPpsz/z4yBf6eRlVIQkc1mHSJp6nww9PFNL5BC
X-Gm-Gg: AfdE7ckgMeIn0gX17A3UzCbO1spLm5M+WO5ynqU9NGMdMVPOwLq1iaTlfJSt1R6zDJP
	62Qu7LqFn8Z6AqQCo046M7fT3Hosr/KBc5DRWScymvozcs30+g0RucmHn3iDnNKrPO7Z2Blocxv
	ULD8Yw0wWLUndAzwfF7lWdZ2Z+wuVHxd+unhVnthREf177pkQ0qjwYm5ro9/E7sgyUbGtQyvYEJ
	tJ9SHLoac8J4I/r4XKWtfHnB5rhFEg5zpbQ/1/wNB6/3deiurFwqXEtjAk6k6W5U6EAvuQaO+q0
	pqBgUFf1+c8mvoW4ocBOgJ1beT1qmStknzG9MwKX+rQreKs8eaklYT45FWtYqJLk3mjaTPuJR8M
	03M69JqYAl2AsihB1iSMAHLDpKcYIbRJeg07WO8LDKzr4VnpW4xfMkjl5Y+bdStoB3y7ZNm4WKr
	87wdW+JigqUbtYCPkgfE9UGYqGvK6G/l2nIH3bxKFK/LxgT7DAxjPAOnGjTAA5
X-Received: by 2002:a05:6000:2006:b0:460:1e5a:2267 with SMTP id ffacd0b85a97d-4650090b736mr21019711f8f.17.1782117764761;
        Mon, 22 Jun 2026 01:42:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm24839972f8f.29.2026.06.22.01.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:42:44 -0700 (PDT)
Date: Mon, 22 Jun 2026 09:42:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo
 <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Paul Moore <paul@paul-moore.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Howells
 <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>, Philipp
 Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
Message-ID: <20260622094242.64531b9a@pumpkin>
In-Reply-To: <20260622040533.29824-2-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
	<20260622040533.29824-2-kaitao.cheng@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA4BC1A000A
X-Rspam-User: 
X-Stat-Signature: xxsi4fm165hu4r1f4ibfogxzzk6epq7s
X-HE-Tag: 1782117766-905109
X-HE-Meta: U2FsdGVkX185/ZF2f17d0ciPBuq9y1hAjRruc7Vmqs6uTivUZRSDOC8dLQmXqiTn0mp1VWYKeGqG5WwtwL4bIp3pzrDhtUYGDGpxaSFV93OrrH1jpsUAZ5EKUljPqYdKjdEhOo7uI5LlHk1Ew8BDmZb8UxSSYFCg9Da4g9rY0TZ1LZA9/uXUbA9kod9JJ3CkowuwkQXo+4fz8KdDx7onIbvnOKvEsnnKSKEhAygBlJC3vX/6w0TyiVVS2HeAgDnbzo9NN2jC2WolC1UJ7Vrq75H2ZpPas1BSsz5lAJCOkTkbe1vBn+JLivqwA0jJadkWiecE2+oiYR2MysdX7rNYUuF1VJYBuF17CQVslEsihV90twXyVWDGIJ564BNZyWL69z+4wuLmnhXC8eQ3oMxB7Jmz4ZHPWUiveeCBlXD24YwTX9asUeQTo4BjcZ3Tv4ndNkejK40y/NU8gaUFnaE6ghxlkn6TY1l6rJBVZ3uSzJrRv2UxNkiE+x6yIrFtefBvkoylzAn7Ok2KZk8PaO1qDUNBmMRLHakr92eruO5M9rGQXNFoNeaDvkQB8/iQv+YlBe6zXbHR/pdS1ruRUVt61wUd6YgpYdR9YwP1oj2iCQM8dyLuUT8AI8gcmlA37VasLeaBHRhVHwWUrluf3ou+8yUmuuv/vNY5rX0FcDORtr4L3O9i8mrtSYl0HMr9ArV2+b/4vxZ2+DzXk3YiMT0zTZ8VPkQXveE3PQ7Pa6SOfz3kQfeHVeTgLBaCEzWRrmVa7ODALtlr8Zn4E2h9JoMLbLDltlxCuX4DN/KJdOOzq65pQPwDBoqKW1EFnHlpMIozg8GRhmYSCjZIxkxAfYaKzGyvba5OHgqLQaJGdj8Rzzv5On7C7cxiFyYqGMOHC+mPBMY3ncRYKUoVbCPhwIYcekSpMQ5OBMvwV1CXnro4j3ILGGUEXhA1dBF+g1gUoiHFrg4QCV2cetHZjiw3BRs
 uR6/Ggci
 j8OF17vsl/AlbFc+Pg/eMdRzg9KPc5JwyMpAN7LQ6N7NuL1J30ZhiLwWXSDrz6IlPH8sFnxullZnS2gHisSorIx6y//PAIlrZLHao0XIBzOx+/dIVbi3eFxNiFFLu4UNmmuBbivRt+biZnmzNqaIADPkurcwrIQIy4nwJKxXkCdle8iATMFWgkC+SB8a51TG30s//cu/kus0NNiB5wfxjZYT4qt7uQ+Y+57qe2lhPujXoiMehxm6hW5+R913OaoLkyrbmeArDqEmGqgSS995RmObu7VTCrkd0ETGfsP79Csjf2Jab69Y197wxYFGk3jZVrwoHLL7y33R9sTSYvguBvXwD8kU8jjJ50hoQMlWzPw1HBs58G8r9TXWSaeYuMUeATansfIhO/l3q48m9fowkOdw50SY55Syg7x7HLOMIdDZZWrP7a79yVqaS4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 12:05:31 +0800
Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The list_for_each*_safe() helpers are used when the loop body may
> remove the current entry.  Their API exposes the temporary cursor at
> every call site, even though most users only need it for the iterator
> implementation and never reference it in the loop body.
> 
> Add *_mutable() variants for list and hlist iteration.  The new helpers
> support both forms: callers may keep passing an explicit temporary cursor
> when they need to inspect or reset it, or omit it and let the helper use
> a unique internal cursor.

I'm not really sure 'mutable' means anything either.
It is possible to make it valid for the loop body (or even other threads)
to delete arbitrary list items - but that needs significant extra overheads.

It might be worth doing something that doesn't need the extra variable,
but there is little point doing all the churn just to rename things.

> 
> This makes call sites that only mutate the list through the current entry
> less noisy, while keeping the existing *_safe() helpers available for
> compatibility.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 231 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 09d979976b3b..1081def7cea9 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -7,6 +7,7 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/const.h>
> +#include <linux/args.h>
>  
>  #include <asm/barrier.h>
>  
> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_for_each_prev(pos, head) \
>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>  
> -/**
> - * list_for_each_safe - iterate over a list safe against removal of list entry
> - * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> +/*
> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>   */
>  #define list_for_each_safe(pos, n, head) \
>  	for (pos = (head)->next, n = pos->next; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->next)
>  
> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\

Use auto

> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->next)
> +
> +#define __list_for_each_mutable1(pos, head)				\
> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __list_for_each_mutable2(pos, next, head)			\
> +	list_for_each_safe(pos, next, head)
> +
>  /**
> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
> + * list_for_each_mutable - iterate over a list safe against entry removal
>   * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_mutable(pos, ...)					\
> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)

The variable argument count logic really just slows down compilation.
Maybe there aren't enough copies of this code to make that significant.
But just because you can do it doesn't mean it is a gooD idea.
I'm also not sure it really adds anything to the readability.

And, it you are going to make the middle argument optional there is
no need to change the macro name.

	David



