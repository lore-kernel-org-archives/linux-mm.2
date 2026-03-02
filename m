Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2A6EA4E3F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885256B0089; Mon,  2 Mar 2026 12:00:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F4C6B0092; Mon,  2 Mar 2026 12:00:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A6F6B0093; Mon,  2 Mar 2026 12:00:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62C226B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:00:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F02031A0246
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:00:50 +0000 (UTC)
X-FDA: 84501737460.26.686B30C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E84BFC0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:00:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDoP0+CE;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772470849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFRoqhnmMzkDkStjfJqprhs8pJt4vdfTfatvjuDvfhE=;
	b=cU5QFYZgzH89mnHCLZuoRiNot7/gv9+gBSnzNqPOyg6fK5V3hBJoDKYLSsL+UJpODsivgd
	pmydxp2wFtrakkqORpG4dP0D24mp7fVEIWWpLbZ5l2nHiqDiz+Kfgg9vl3Jh9IYrLLWDYw
	lac79W/n/2SeWrteuKw2RBweKdmIMO4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDoP0+CE;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772470849; a=rsa-sha256;
	cv=none;
	b=m0PdZre5ppxHVQ7mCaMV0CtS84skzBWThrM8/g3pHBYjWlvtF2axjLxycMxdwgEX8FwMUo
	A/LFjYVjuuVYiZDw1Yl01g+qRJofUmkEoy1mYTuatM58nXYYfWgeb+a54UuTfWjCQ8nTRH
	pwC6F66JsfYP+gGH9oTpMoHwfKPZr2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CF1040C56;
	Mon,  2 Mar 2026 17:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C15C19423;
	Mon,  2 Mar 2026 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772470847;
	bh=QCdY811EmmsP3apQf8BEVmaMY6l4D1uOlOulXDgboHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GDoP0+CEsRvUiXX65+UDGZjacGoq7XRserXFGYBVD0SKLI1UzT2hYV6cmxQdPmaZs
	 uXtQuPs6NJcJIn9urMucWTGm6EsH9hbiSQFedGBhU8FoOyyrBH1HRbyI3EpjpLnqom
	 F45tYCTEqsDUGeGeihKakRjzIs6FZAzR+o/00BGx5tRrUplhSFSq14E8EupW1nVAnt
	 V/G/uVdB3CB5OWG/N09IRq4OaQS7jaUTkPMA8BbIMxvh716Yn/lPgKj1rTsKe+/6Pm
	 kKstDrZf3EXqJne5LOuotzKT3Ah/CB8PYsGuWgGquht+DOaCTMbL4cgxWpltWYS3of
	 CBFRkbABwWQbg==
Message-ID: <05e134d8-f600-4ee6-9ce5-4b2ef199b075@kernel.org>
Date: Mon, 2 Mar 2026 18:00:43 +0100
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
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E84BFC0003
X-Stat-Signature: rierwpw6hiuexdff53694rjh7w5eg4eg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772470848-260716
X-HE-Meta: U2FsdGVkX18P3LfFeqWVVXsbqrc+GbuFnQTwsKPVcs8fTx4ZoxdDO+ftW1CixIVt+uzNYq+Gjo8FYuxGi9i84sTCp6nJ2csbydo/gpRgpjjFx2H4UXsm1NBbDaGpvtj+LMt9Ab+cy+0TxjQEHaIzYXg0Dtx+2FgoMKs0nJXD0doK/K17nyUEAmCRRhMICSfcQ5LDb3XqrqP3Ol2GoDhZYx+Yxx3Kq1yzYaEJ9eUxetKGtlC51HUx3hqbe41jBX4c4G0yyee5VemHxJsSVw0NORp+D+YMtFbjaR0yi95Jj4/o2H8M+FtaKd1tHMLr2H/utKfZfBj4TK6e5+b7ZyKG0bYq7bi5CowVbDSXhQacRvKXvey/Th0e35nO+GxmUqOtOxJ+p9YV5cqdsd+0I7MofjRluqS99SsNnBMC3lF3ePEZ1lKKWBrtJIyJ/kYvZ4p5M1seyvJ1MVEFgiy7hMGQnUN8X7aag4bInmWlniso9VVLv+2iKnG6Cu6lm4ROOSUCLvn5g8tFlCFZy/3Y+nns4R9cQslssZ1lam6g4u0XuRHLaC06uGwFc8o8GuYIu+5+D+zaCduiokS1ddBsqFiAsJiV1Cw8vX136bpyA2YpW7VyRFkd+bNxvsLuxNg8OqPJoHloeEHQWWk2Hv+pv+Femgq6e3W5/zkQ0Rzvi4Y8srgGg87l54wr5wGQ/tNMN1gQv9+oYfhGOvVdVkTvS9anmDVlxwuzxTnl/A5CLFxsXuW5ImJc8FnkLAlyX6gAl9k+Fo9xFaIX+wzUJM3tRsPZUjHtw9EkUz+VBxDEzEAnweNh1WRJpQTAiyyIUVcDhPEePZ2DWE9/Qa3yxV1QOqw63FGbqsuu7h7IY9kvC0TAjXVqEic5K4iJnPK0TpeqeZG9nT9T5Fuosnn3x4XQUz6A0hEOYl9OP2ceKlFo2/jPfF4KwoVI925oxtSsshxhgRWgnW+1SULcL5wgPiXfUaL
 aHmNU0SA
 zrvB2cTS6J08x0Zu5BMsO2o7+AkOi+YpAwAa1oqj1iPYWr9YxjGlY9QDmx0PoQ0hu516L70d7i+RkgxkX9Twz+x/2OhaGWwmJgi3NhoWaPtdUqQANcBJx9eUoMX9FWImHPqaayqPBYvo+ZEsG9a2wmaOLKDoeH4SWJGJJm+9vNQYpA297f20P0QJ6DDrFzUwDYU5LgYr94uy/3niyzuqoKhWU3ohU2AQIXYtHDjAagiKFpVMCcwmAz1aGzRte55lWvMOOFmW/k79iipHw3fVMKiYUZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/**
> + * ampress_notify - dispatch a memory pressure event to all subscribers
> + * @urgency:      AMPRESS_URGENCY_* level
> + * @numa_node:    NUMA node of the pressure source (0xFF = system-wide)
> + * @requested_kb: Suggested reclaim target in KiB (0 = unspecified)
> + *
> + * Must be safe to call from any context including IRQ / reclaim paths:
> + *   - no sleeping allocations
> + *   - only spin_lock_irqsave and wake_up_interruptible
> + */
> +void ampress_notify(int urgency, int numa_node, unsigned long requested_kb)
> +{
> +    struct ampress_subscriber *sub;
> +    unsigned long rflags, flags;
> +    int notified = 0;
> +
> +    /*
> +     * Use irqsave variants: ampress_notify() may be called from a context
> +     * where interrupts are disabled (e.g. a future direct-reclaim hook).
> +     */
> +    read_lock_irqsave(&ampress_subscribers_lock, rflags);
> +    list_for_each_entry(sub, &ampress_subscribers, list) {
> +        if (!sub->subscribed)
> +            continue;
> +
> +        /*
> +         * Check if the urgency meets or exceeds the subscriber's
> +         * configured threshold for this urgency level.
> +         *
> +         * Default config has all thresholds at 0, meaning any
> +         * urgency >= 0 passes — i.e. everything is delivered.
> +         */
> +        spin_lock_irqsave(&sub->lock, flags);
> +        sub->pending_event.urgency     = (__u8)urgency;
> +        sub->pending_event.numa_node   = (__u8)(numa_node & 0xFF);
> +        sub->pending_event.reserved    = 0;
> +        sub->pending_event.requested_kb =
> +            (__u32)min_t(unsigned long, requested_kb, U32_MAX);

I didn't take a detailed look, but this one confused me while skimming
over some bits: Which value does exposing requested_kb really have if
there are multiply subscribers to notify? Doesn't quite make sense to
even expose that.

Assume it's 2 MiB and you notify 1024 processes. Are you suddenly
getting 2 GiB back?

On a bigger picture, I don't think the whole idea of having multiple
subscribers is really thought through.

What are some arbitrary processes supposed to do if the receive one of
the notifications? How much memory are they supposed to reclaim (given
that requested_kb is questionable)? How are they supposed to reclaim the
memory (MADV_DONTNEED? MADV_PAGEOUT? or what else?). There is a lot of
information missing from the patch description to understand the bigger
picture.

If apps have droppable caches, a better solution might be to use
something like MAP_DROPPABLE where possible, still leaving the kernel in
charge of when and how much memory to reclaim.

-- 
Cheers,

David

