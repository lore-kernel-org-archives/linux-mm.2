Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEFDD58E7E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF1A6B0005; Mon,  2 Mar 2026 03:53:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399FC6B0089; Mon,  2 Mar 2026 03:53:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285F56B008A; Mon,  2 Mar 2026 03:53:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 137906B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:53:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB8571A0A60
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:53:03 +0000 (UTC)
X-FDA: 84500508246.28.2EBB43A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D79B340007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:53:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHzAQTxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772441582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHSFGoWIrWu1j7v7ylfu156j8t9bW0LdBmpzsMkozEs=;
	b=LQHpGRWiZ7pnnWPQlxPsx0i9k6OPmIAzQc9sniyDDHETGKFLRz0MF8LyZqiSoNTXYyJ4RN
	odDh/5RRNoEeH8EVGVOYgCj7DgHwFIBXe7QDeONRc5UA67f/8q1F7A6n9+oAF44d9NZGpy
	DwYHgL9lRT+4ZqjQ1XkJCDwbVNUhPGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772441582; a=rsa-sha256;
	cv=none;
	b=OR62gv49vOF9iEA890Kfo9HZ3pZpcawPkZRqIczKKU7LIH0Ldwiamkx+QeRaVFsD9EWft2
	VzUa5Ccu3Cr2tKha69BPkDjHyrAV7UNfBLujqEU4LC5y6H2bOl/7d/lzMvp7xNHPRkMu+G
	euGpKHOtI46m94lZBHLbg+PhggGd9d8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHzAQTxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A35E4408B4;
	Mon,  2 Mar 2026 08:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D5CC19423;
	Mon,  2 Mar 2026 08:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772441580;
	bh=FIYd8/Pi0AsvNSlLb6TS2+ZMscAv4Rz2Wbjspc/3L0k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IHzAQTxEzZjfnpsSIqAAD4fPesFDb3+Zx7cbefp+ZKkpbBelTRXZv7Q/s8qIJvXsh
	 ivmojcdkTW5ri8U34lOS1edOIvsqMkJxNqok/USQBLXU09hQR57dSR4N2ZFYPV1n2d
	 iPfVdjA7ak5SpL7tp9O1xTISPO3LV/IENkzEdnRxfvoVWumq2xnNwKnRxgSxexW+KN
	 7NGpry0Ka0TafkQCwNN+KJx6QpPoOgLWnGyUmA9Ph/bS33cDPcU0GjRg9azm2gX5n/
	 B3+PQgOYM83dPUDnZOQJtBmOXLluCr54oD1N7cArc66bnd9zRolHvxZqqAsK/zspwJ
	 PvbHN0Nl+tErQ==
Message-ID: <3b16e616-5104-4559-95d4-2942173561e8@kernel.org>
Date: Mon, 2 Mar 2026 09:52:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
To: Andre Ramos <acastroramos1987@gmail.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, rostedt@goodmis.org
References: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D79B340007
X-Stat-Signature: 65zm4pzik1eshkb7btxixe9biarcnohd
X-Rspam-User: 
X-HE-Tag: 1772441581-890231
X-HE-Meta: U2FsdGVkX1+gYMRA+TX9dD92nclUGwJX8gSMDZo+aZ6vKVsBSefiBd5Wk1T9KLH2aBRNL4S4X3zCYZtUviN1BnvNeApFM9O+lMw3IRiWVHW7EDXXP4aPvvqZtqCI+j2kUJ25I/cCng2Gg5fLiuOYWw7Pv9IjPcAuZs6KaeNRD1AZJsbSFqpCQUD1lw8wC5CkGibHeVbzga+4JMiq/8McYlG537t0VJax1jDxaGumSsQ1PDQSIQv0WAkXxk1vlVWTH01N2DKyVQGN6BxsRYx1/KHmoqgn/jsvBRD57d1Hdh1RaF/OrMky3hgwbqiYC1jEVfJDSuQoaNa3ojVNyr4JM8wCTt859e/E90mtHdZ/ak1dEhzuldSvSnx78KUAXgO/ujRdCFoXM8niGla5RbGDC/+Q7y7EMgZ+U70eI/4j6O+YB/UET0sKjxiA4g0FGSXiShKmfrVTL+5Kl4BLGCnn+6AYz3wFgngXvEmn5s3zkp0ltAhKpUzDZeLukMdkwExinnliFeVfFUZUHRxPiOMyeYLTYogtyhvzCqiUix6UQdXAkAt9N5shE3Dj5Kl4xFeS7WMBsC5TAqrNkIEOvxiu1IV/HISn1ocTi7BBliGyEXFzOXT7ZtJzEzPrlor/17YEQWpdWJs59K2L6hQ9xZZwouUHNcsqGkVCk6y0dw1kkyoazRDzOj1JMTC4zmbYLMCJHiEz90mGd64a2wPk0YYWeC45zt3flOPToHmYSPMzy9gtDtjXTbNrqM6joM5R3K7hjDFtbJo717Wu3Z6qQ+bsgiXEH46FNz0lRcHe5uwNt14epI4fy5Q25sXHmdPONwL4LtnqhA8Gxt0/ay4CO8xVaBGyXfrOd7oXtRa+eqAqtzZgV0W6uaYxQeySzLx6oDZf++IIfgIsrFEObl4IWj20505Wl0LLDWuAY/wopmlPd/T4w2DE/M44axnSlFQAzsFmB1y2/s3OyEoEUH6Z7Dh
 Ypxb8Iua
 ZY/C5TUiY+1WO8f9Jj38+zHX4gKVYLMelM3bjAGIZyKN4BpF3DXUL2ft+co7J0WoqYD8l0VimBHXheYdXAchT4CRclrFf5r/7KAlmjnkqjK39FHDAoy1Dwpu3jCXWH4D91a2jWpn/Wp7s1T/zXK17jBl3Mf663G/YWrISjp5QhOlp1gv8XMlzZ2Eed2T9+NEYLjJ+YH5uXlPhegFQoY2wocXkxH+e6txkGA9tfIdXEMhNZZicoyNDYR67b7uoXxAzL61HPX2OebZO0hkhXcOYSjc/KYTQEboQco08LSe0VNjItSfjnP1ypCLd57vmuLeCI3rBC0sxZ3vQP6GSQ/nknad++Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 04:45, Andre Ramos wrote:
> Introduce /dev/ampress, a bidirectional fd-based interface for
> cooperative memory reclaim between the kernel and userspace.

I'm very sure this should be tagged as RFC.

> 
> Userspace processes open /dev/ampress and block on read() to receive
> struct ampress_event notifications carrying a graduated urgency level
> (LOW/MEDIUM/HIGH/FATAL), the NUMA node of the pressure source, and a
> suggested reclaim target in KiB. After freeing memory the process
> issues AMPRESS_IOC_ACK to close the feedback loop.
> 
> The feature hooks into balance_pgdat() in mm/vmscan.c, mapping the
> kswapd scan priority to urgency bands:
>   priority 10-12 -> LOW
>   priority  7-9  -> MEDIUM
>   priority  4-6  -> HIGH
>   priority  1-3  -> FATAL
> 
> ampress_notify() is IRQ-safe (read_lock_irqsave + spin_lock_irqsave,
> no allocations) so it can be called from any reclaim context.
> Per-subscriber events overwrite without queuing to prevent unbounded
> backlog. A debugfs trigger at /sys/kernel/debug/ampress/inject allows
> testing without real memory pressure.


[...]

> 
> +ADAPTIVE MEMORY PRESSURE SIGNALING (AMPRESS)
> +M:    Darabat <playbadly1@gmail.com>
> +L:    linux-mm@kvack.org
> +S:    Maintained
> +F:    include/linux/ampress.h
> +F:    include/trace/events/ampress.h
> +F:    include/uapi/linux/ampress.h
> +F:    mm/ampress.c
> +F:    mm/ampress_test.c
> +F:    tools/testing/ampress/

We generally don't make new kernel contributors MM maintainers.

But what sticks out more is the inconsistency between your name+mail and
"Darabat <playbadly1@gmail.com>".

-- 
Cheers,

David

