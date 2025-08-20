Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9ABCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F246B00F1; Wed, 20 Aug 2025 19:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF856B00F2; Wed, 20 Aug 2025 19:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6736B00F3; Wed, 20 Aug 2025 19:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6DE66B00F1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:37:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2BF0B6A78
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:37:42 +0000 (UTC)
X-FDA: 83798750364.12.669C4F8
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf11.hostedemail.com (Postfix) with ESMTP id E960140006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:37:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="N3/pVvEw";
	spf=pass (imf11.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755733061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLwi8LXnx9/ZQtRzLmGUonBfO8LO71fIHYZ0kPxCQFo=;
	b=XbYJBCHulo8uxCJzfuyIFLHLVvArUoKC7RA9SJ/osJvjuMxpMEdgPleX7fXw8z4T6hH9EI
	1BaJMzV0HWs26vN9OxyV1b2vcGw+l0spivaZwcxtUTvkhXod+r4LRiOwcW5J3YDFV/I8wo
	e9a4nK0N9UQs5SK89Ll8IrHU+DPoIEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755733061; a=rsa-sha256;
	cv=none;
	b=qOLdYY6Op20CPaFz39XN1T+CKgCKn4gD8Arv1aZqu2M9TJdfYa/g6+XhgtOBudqKHJGUzJ
	4ueW7S+r9m9IJV83Wljms9oCiLNKfLH0yDnwhQ8EiWXGYZVgdR++fnIZPA8SsbkCICqlop
	6SVmIwQ6W9aqAi4rP+uiDOzIpLSBiYM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="N3/pVvEw";
	spf=pass (imf11.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1755732405;
	bh=XCs0VqFMLGNvQBFfHYDkcYu1cR0YZLv0EaV6HUuJL2s=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=N3/pVvEw5VXa8QdhAwM7HVfsSjcYmdRrJhvocdcN8UCejCGDhF62uLjAXytcrnHu6
	 5bildu1OCOXqaorSaUHO3HLKwcq6j6TDr66DrZxk3rgbrakV5SxgV4ZVa+CaSWiuvj
	 A/oSWIgOzgb/9v2BIAstrZsYZTI8wsP/Bt6eAXvo=
Received: by gentwo.org (Postfix, from userid 1003)
	id B433B40195; Wed, 20 Aug 2025 16:26:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B3610400CA;
	Wed, 20 Aug 2025 16:26:45 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:26:45 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
cc: yury.norov@gmail.com, linux@rasmusvillemoes.dk, paul.walmsley@sifive.com, 
    palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
    linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
    dennis@kernel.org, tj@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] riscv: introduce percpu.h into include/asm
In-Reply-To: <20250819135007.85646-3-cuiyunhui@bytedance.com>
Message-ID: <e7653089-5c57-ee61-ed01-0b3245e10d82@gentwo.org>
References: <20250819135007.85646-1-cuiyunhui@bytedance.com> <20250819135007.85646-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E960140006
X-Stat-Signature: hq3qufax4q4jasgk96dm6xrqx5h8qyg5
X-Rspam-User: 
X-HE-Tag: 1755733060-723663
X-HE-Meta: U2FsdGVkX1+qqpu+P/aebK5B5HkKcRyqCMqDGUD1vcQ+c3CcEDpxKZDghWrziV1jmWGJp+JQtYd6UNZkO5k3x+jW+uUif+JAjpM3BRc8bMeHqw9UTq9jFXL0DCU0bf0qdAH8khQ6CNGqrs087BmXOWOF9sA48IZUotjmB9iWvxTI8XSj4DNrDV0vjFm7miHZmB/4DBYF3FqYlzq67MPCiA+ftGpp3qAomOC2BtrW4M+ldDnzOsOlS6BR4j0xJgZGWbYKks9vyd95YGz4xYmN5ovEsYh3eKEGSCRRlb10+OGNgilyUILTb526isUsBuM/cdeWf606bpf6Ye4xzxPcRU36dvz7yG6lt4UUxt+4oimTU4joyrEXREeswbQnpSMa5LJwmtCais6dHsJYqZr/XMy24nKZecuFBJ9mAjaTb4t7doTwm0sIIpD9951cauzlieO+YihLo/Y9BnNBMVmjXZomGhTVXVCeJUxl0ZYYyTRaWxeLBbOUhrxodvgYuU/xltgrD5dLPNmoOfBxbiYOTxxPEDe1zmJUwqX9iyHXSqElEWxtA/jJDqED1dw11myQFqOQ6Xd8phRkHWIkbBwZeFXqfn4Mr1kSm3UdBH72fpyM32yQeOTHfu9wl1njPWD7/BoqDedi/AKMbi9YyEa/CzG2Uj5gOJcXXZRVuRGvsCCB7Owe9eXnW1HYk657/HmbKxaDEEwa0UAug3JdiGqHuQjbDN4iTDyIJrDfXnDTnMskZ9E22ROIbU5TNhOE8Bj0XmOxTog6o/LnueNSGYPlPcBsBX7cuQciC4WpNeyuWQYvvP1LoUt36oG0GUO6dTjEnWu4W+To1quEEhK0UvleStSD0MhMzY0GV63lnIZ0oGZGkgvx8Q//YBd8Tm3zarlXI3rEB3xe+KUDqkff+yOBSMe90U98HFc5Ou4n+p/lJqaXkBhQ+SXpa7RTvVQ0TzBSXy3YwirUWS702l9Crv3
 +0VjutM5
 jYNHMtk7IDb/jY4oQ3bXcyqEhDo3mCig+ELGVMgI8xql5S6RDIY6YRG/9LTHYF6fcXuK+ffw+GTnMvOZqctoRkq0T3hxR6NIU02oijtfhk/w2SFp3wj7YWeQI1XzlntowFtkglbIz6R2RqIPlGq/h9Y/u5wtNjSit77lg+Co9Vf+kdW9epX7NPm7739VyYkGspTG+csRiKvkqVS7dpAPGL4o5JKxBT2pq34GyYFa4KznpKI5QcZS/xEGNqzmfRAxY70awyM62dLq8P4iwNQhBuex6RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025, Yunhui Cui wrote:

> +#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
> +static inline void							\
> +__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
> +{									\
> +	asm volatile (							\
> +		"amo" #amo_insn #sfx " zero, %[val], %[ptr]"		\
> +		: [ptr] "+A" (*(u##sz *)ptr)				\
> +		: [val] "r" ((u##sz)(val))				\
> +		: "memory");						\
> +}

AMO creates a single instruction that performs the operation?

> +#define _pcp_protect(op, pcp, ...)					\
> +({									\
> +	preempt_disable_notrace();					\
> +	op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);				\
> +	preempt_enable_notrace();					\
> +})

Is "op" a single instruction? If so then preempt disable / endable would
not be needed if there is no other instruction created.

But raw_cpu_ptr performs a SHIFT_PERCPU_PTR which performs an addition.
So you need the disabling of preemption to protect the add.

Is there a way on RISC V to embedd the pointer arithmetic in the "AMO"
instruction? Or can you use relative addressing to a register that
contains the cpu offset. I believe RISC V has a thread pointer?

If you can do this then a lot of preempt_enable/disable points can be
removed from the core kernel and the instruction may be as scalable as x86
which can do the per cpu operations with a single instruction.

> +
> +#define _pcp_protect_return(op, pcp, args...)				\
> +({									\
> +	typeof(pcp) __retval;						\
> +	preempt_disable_notrace();					\
> +	__retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
> +	preempt_enable_notrace();					\
> +	__retval;							\
> +})

Same here.


