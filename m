Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA74CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D2C6B008C; Mon, 11 May 2026 04:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDB66B0092; Mon, 11 May 2026 04:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC766B0096; Mon, 11 May 2026 04:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7F646B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:21:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74DC4160676
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:21:23 +0000 (UTC)
X-FDA: 84754444446.14.DEA3539
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6913A0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:21:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D4gYe2xc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOJUdM251vkSGUiOD9YVqihxji9ikwYuHwsYs8QDHu8=;
	b=hIISQ7OWIwmXPFfQ65k134XJF1cx+w1TpY0wT7qek+ojsUUYVWKXT1HAh+w5La8PJg5Q9Y
	mtXyKaXIl6wzxVsVQyWuqNlU1fy7ZILs0zbvXhMTSeiBt7WMJyP8GQJK1YryBzBVNBJHi2
	qqXmiP2clHpBHxHvXG5sgWHiqnxeH2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487681; a=rsa-sha256;
	cv=none;
	b=d8IJz1x5HjvJZaE09qdkW+lY3DtM94hQjA33VhOlFugv1uXrznZBEyq8RUlhVVcnNQb6/e
	7mjCah6t3c4BF9XS/2ViRTalgFDDozUGubY+wE8QrlcYgkNG1TBrhdgdAJs4NPKwqObY7b
	f/Uv5SYhBcIBUj0RWxl0aEmSL86F8Vk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D4gYe2xc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60E5F1713;
	Mon, 11 May 2026 01:21:15 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE5FE3F7B4;
	Mon, 11 May 2026 01:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778487680; bh=bg8M6thrZ7uAmdqkDBj1hRGcR/Z9WWcS5pXtDoLvg8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D4gYe2xc8RbmU80Upl1ZO7tExuL3ccH2s/qYgHplfbFO7pvkE8ir6P1yRhAlqMtIk
	 +B2lfjp/kRoJVoCLNEZi2+FicXeaH0Sw0bNNxKmXpqEJsrtGV4P5/HSDyVUKUSSS0U
	 xwxEDcHN/QT9bF1Wf3W4QvTGJz1IgrMQBUjDuTb8=
Date: Mon, 11 May 2026 09:21:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	elver@google.com, Dmitry Vyukov <dvyukov@google.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	syzbot+cdcfd55737fe43eeb3a3@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v1] entry: Fix KMSAN false positives in IRQ and NMI exit
 code
Message-ID: <agGRd-XZx6MqCwN5@J2N7QTR9R3>
References: <20260508124315.2526312-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508124315.2526312-1-glider@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6913A0009
X-Rspamd-Server: rspam04
X-Stat-Signature: gu3q7u9fh9jmy97s4eb3aefrntmfjafz
X-HE-Tag: 1778487681-572716
X-HE-Meta: U2FsdGVkX19lwedShxHYa59pRtapgdSUHFles64DCOIkvui/3Uslco1vG6d3ibtM8oKaXksvD3sn2Ncy6cmc8WS1v5IdoZo1C+8BZLZKijSyZfbrnvEJihDKBqoVlcZ0CcIksVDiU3ZJWbDHBweU7RpgHQTnAgHcBbGOdYvHjtKbmU7vg/DMhxQuxCHGRoH+vd6xH1EOzBEPzF+wztqH8ABrWTLUp9zAE4uqx2wOLomjovf1UCyuAh4GGTxHHy3U9tMenBv6lBIDx/nyMSGhGp4y58QPnHgjYpfcpuWHhEqA9dAWF4yR2c/zxrTKHtIR3zTKEPh05afWgkC3jOa4TICEVbXxfsXuNW1JCySSdiNgANMN/N/KINEp9LgAAj+eTNvKP4EPpKWO99uFR2BzBb4TCx8B0kAQjr3nLRgKRRhZNO789f6hyXwcjv2ZG47WqIdGjtKxCNnJrqclipoX+ScSQLisQlDMrJNBXvBPaBNrgNYoUke66y9QB+iLh0NN8sAvRbGI+/z5NlUxhDBS1woAJXVR0yJ586SSee2agzCPnZxIIXGzcMAwzWAgW9M0dD6XtuwjeE3/6oHppa7jq6g15pyKTKXlIBe1calAxYnGQr9GcyY5aC7CwN9hZt3kY7ezSEprMe7kmKl6tyAYw/ZUJlk94HihpA7vV1CKkxIbn8xXv2NMT3stX362uTQsTwvYqAjM3SG4FqMOnK5xeJHhOzg13pzUnqmpdCIEhcABVauO0Naz4XNeSReeNYh5nxFGlRf9fu0IK8zl+Wc53AT4lEzaSJUY4Gvu3mF258hyhrzakqoLEOEWHxFmntNDVrBJqYINIytg60U98mBmn3rH0rbs0SlfHT1GahCe84Fhv+bWad6Dp1anjntaMvgCP11BF0od0TMDgWMmpGdUd333cGGWtvuUReoJShbFl4wszKdhltbbLHrvPcAdddGVHRzw8UIKKhTjUetdSo6
 8X4q/Nzz
 qj3h26QgiBVqLYoPAQhUEhf9X8GwXUVh0nGqvWGmUNlEnUMWnJdpunxcOY0vOvVsufLkZcj9y87m476F3s3r8dP2pg1cZu7eCqW/PrtjD9aeRo0emRZNh+o7DkbzJf82jctHuM9UVJlW1VoHlyfMNusO0aStSmPlyALcMi3emzZv7xJlgCWQ5B0p/6o8pX+8f+9218atLeLL+GFp4DpQps02CJpGbBM8RSjv6ELvMC4D4dOnTqV/VFU4IWpKCMtP3HHoOOgfsCRCKUGmMcDIE6m6SWcqFs+EluyMuep22YMHBYmSicS9IZ2UKYLYlpLKFV9XU7IAkwn2wyeBtZngSa8GbqtMR4Sqtti+pjOeCQh+Z6i9f4GTJjL7y8PuwaX5nF1cFjYNo3fJIdySuy9ZMkvn7yn4IyWRo2coJhKkizkNDWJaYos811hqnGrT5nj+qRo/1bSPoFVR75Le8qqPkZ0A/+ZroC7JpDEA5+5cuDglqv7D5ufHx8JSn6i1D7UZ9/UOKL423a/ZTvNVJG3ihmnZYK7Xs1bIuOUdi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For some reason, the entry maintainers (Thomas, Peter, Andy) weren't on
Cc. I've added them now, but given the various subtle concerns in this
code, please make sure that they are Cc'd in future.

There are a some entry fixes scheduled to go through the tip tree in the
near future, so this should probably be picked up with those and go via
the tip tree.

Minor comments below.

On Fri, May 08, 2026 at 02:43:15PM +0200, Alexander Potapenko wrote:
> syzbot reported a KMSAN uninit-value warning in
> irqentry_exit_to_kernel_mode_preempt(). This is a false positive caused
> by the initialization of `ret` in irqentry_enter_from_kernel_mode()
> occurring in uninstrumented (noinstr) code. Because the initialization
> is untracked, KMSAN considers the state variable uninitialized when it
> is later passed into the instrumented code of
> irqentry_exit_to_kernel_mode_preempt().
> 
> The same issue exists in irqentry_nmi_enter(), where `irq_state` is
> initialized in noinstr code and later passed to the instrumented
> irqentry_nmi_exit().
> 
> Fix this by explicitly calling kmsan_unpoison_memory() on the `ret`
> and `irq_state` objects inside the instrumentation_begin() blocks of
> irqentry_enter_from_kernel_mode() and irqentry_nmi_enter(), respectively,
> immediately alongside the kmsan_unpoison_entry_regs() calls.
> 
> Fixes: c5538d0141b3 ("entry: Split kernel mode logic from irqentry_{enter,exit}()")

Surely that should be:

  041aa7a85390 ("entry: Split preemption from irqentry_exit_to_kernel_mode()")

... ?

That's the commit which adds irqentry_exit_to_kernel_mode_preempt().

The commit which split the logic kept everything as noinstr (or
__always_inline only called from noinstr), so I don't think that commit
alone introduced any breakage, but maybe I'm missing something? Did a
bisect finger that?

Other than the above, the patch below looks right to me.

Mark.

> Fixes: 6cae637fa26d ("entry: kmsan: introduce kmsan_unpoison_entry_regs()")
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Jinjie Ruan <ruanjinjie@huawei.com>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: syzbot+cdcfd55737fe43eeb3a3@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69e7ee1f.a00a0220.17a17.001d.GAE@google.com/T/
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>  include/linux/irq-entry-common.h | 2 ++
>  kernel/entry/common.c            | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
> index 167fba7dbf04..be47d430d521 100644
> --- a/include/linux/irq-entry-common.h
> +++ b/include/linux/irq-entry-common.h
> @@ -427,6 +427,7 @@ static __always_inline irqentry_state_t irqentry_enter_from_kernel_mode(struct p
>  		ct_irq_enter();
>  		instrumentation_begin();
>  		kmsan_unpoison_entry_regs(regs);
> +		kmsan_unpoison_memory(&ret, sizeof(ret));
>  		trace_hardirqs_off_finish();
>  		instrumentation_end();
>  
> @@ -443,6 +444,7 @@ static __always_inline irqentry_state_t irqentry_enter_from_kernel_mode(struct p
>  	lockdep_hardirqs_off(CALLER_ADDR0);
>  	instrumentation_begin();
>  	kmsan_unpoison_entry_regs(regs);
> +	kmsan_unpoison_memory(&ret, sizeof(ret));
>  	rcu_irq_enter_check_tick();
>  	trace_hardirqs_off_finish();
>  	instrumentation_end();
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index 19d2244a9fef..390364943f92 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -177,6 +177,7 @@ irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
>  
>  	instrumentation_begin();
>  	kmsan_unpoison_entry_regs(regs);
> +	kmsan_unpoison_memory(&irq_state, sizeof(irq_state));
>  	trace_hardirqs_off_finish();
>  	ftrace_nmi_enter();
>  	instrumentation_end();
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

