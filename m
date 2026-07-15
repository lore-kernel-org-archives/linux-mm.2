Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2B9C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF9E6B00D2; Wed, 15 Jul 2026 09:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F4F6B00D4; Wed, 15 Jul 2026 09:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956876B00D5; Wed, 15 Jul 2026 09:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4926B00D2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:37:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE89E1A01A4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:00:22 +0000 (UTC)
X-FDA: 84991019484.07.D316E84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E01F0100016
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:00:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALrAJdoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784120421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iawfAx9IUNsqiGi8BIPj1NgosIqnNR7z7NURj181n5E=;
	b=iM4n4bOWreRe7mDsAEbFO8FVKtEBZtihVo3M0mNtMNPePNhodyatJ90Aduy9nFT9dWRBDH
	AY3OFSYT8gnNJgNp5z1YsHyzk1G2f/o+4jG3GJa2Bx5iqihgytvurolYD80OexRUGZpeAS
	fS9I8c/wlY3Ss1l9a2QTS7MEaYCewbc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALrAJdoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784120421;
	b=uxA/HZvBL/PgXeuGpPxRbeZZZ4dX6751w31SwwO7ZlLZljNY1Y2Pyjp6NHlB5IwjYYRGRg
	dfurkTGx4g6DJgM9baG+xodJmbi3R8/VWRm+n6jRVU/FygO1BrvGxi+/6xZ6ISz/3hz8mg
	KyzfCm/m1MBLFnBvq2DX2aL346Yu+uY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2637640C52;
	Wed, 15 Jul 2026 13:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C971F000E9;
	Wed, 15 Jul 2026 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784120420;
	bh=iawfAx9IUNsqiGi8BIPj1NgosIqnNR7z7NURj181n5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ALrAJdoCITv2RWPJ1pYX8IATK1b7oeIRF8Z7ES+ZMs2LU5ho4Z90RaY7B/uloe2TZ
	 RNzHWSlRUToaosTnHHU8vdsvU1ikCVGi3uVTlWPvjzaUcCLDXI0TFwnLXOSRs/YUMf
	 i5J3g8fP5Ph7dVazeKBaXVevZo0/GJ8fpom49TSGdgUNxK/UfAfvlaxgmVYm6yeAZE
	 wztblW/ghKf6TSQmhlchQKCftszUm8k5yzSE7L1iw+FtDLo5CjIHI785kQHf9I8nPJ
	 O23KxUDP7r26Dj9JqExQ+2ep2EjoLgpqHNwhC9vtLxkvElDZKPVyQjt9kVhQaehIja
	 Dp8/8NaY/N0dA==
Message-ID: <3f96edc0-229c-45c5-a9a1-852eb2de80c3@kernel.org>
Date: Wed, 15 Jul 2026 15:00:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5pqewrowckewehx3zbc3sns5zk19mcmg
X-Rspamd-Queue-Id: E01F0100016
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784120420-240079
X-HE-Meta: U2FsdGVkX1/EsSNR6aGpXz+7a8jnxd6OBG4jbV+etvYioo6eM+0jwS2RWss9uTYZKJk0/84ruVY4Y3IaHk3tRraCY+JY8gmjOJNVkMJsJE+IAaBqI1KORX4goBoz61C25UmmepuPU1IJZcCvCyLnc+LIDvK0s1O6TdmKkmvvKgMT2FETIJnUsyIthNSpX3BtUkg9wW+Ude23BeY8299XiQwSzlJ+h9/4FVPXGwyLz5NM9drr+PY9Mz48NIzqEQu06+UIBJouScD5GwZO1fNHiGdxP4he1pt7qXgD5i/bdAx8Wxv0AKI0jHt2pTOQJVLnIZp1cGPAku+Bjs5Y08Q3gGFf/gMmutMBVEvnrfv3iJNPoWWgEUE4m3g0WU2oCnEAZ6JrKMI7jkXsAUrnDWtC1wVo+pEj9Sv6Z4RX4RnV+zGUc1KkZxccSAeO9SvHjyICMcEyIkHVP6qx35mFxdAsGBHtP+Ui3PNRsfyMCyJoO5AzfzjCKgoA0oMTqkRC/9hjRR31vUxj4dCrUjgvVf2r3s85AiougI+ApLAbUAuOSEclma7AV2+sHI5FxpnwsSmyY23gowe8yE7qdtiuwXOz7TuoNM+7jIp4iGN0XUrmrXmXh5Qlmf374s3xP5SfaPpvYFjucnmypRprLFxqxSNKNP27HgLapnmesGc0FhxLXmxJYGIYI3KRst3MHiycOMFVIW+a3H4tsuWhZvd8RWD0YCfcuDYnRjtdKg0pgGb1ObnYBcxmNdDafxILnw4a+dEoKAVMxQ6zwd7LjrQRYWM5Lxk6htATcrfSW3PKo4lTt42xW3ImM68A/dJ+qHGpBLBQtWmkbaqgpgkkojpra3xyVJYGnH7/lVOM7o9KGl4yLLithlM+GKKHshWr8s51Nm0GXoIIMIctDzddUQOdfI47aZbg2dVnVQuDaRhXQ3ZrYKO9tSfBMi0I2QUesNiub+iHrBZSJEo/57nuSX+S120
 jZw93TV2
 u2nSvWFCsLMXJpM/mgL3G3tqWgcypzUFIoBe0HjZ/pMktYMQO/YI3ULy4zWErgJo55N5SAgnu1Bjy3Mgky7YVDDqa9ljDEPgi68+GN4oLuZ6Z7ORyQh561aqwWxn2enIYt7upJP2NU68kD9IXCP3YXM+5jSRB1/FQvHgZmZung/tcIyO4Yc5sg52kjVliEsUjXpUw9K5bXE1rbdqSTSEUI/zBgGK3V31aoYrY6pbk1agyVaeZawFGDVzdwZmUL3KCafcpIirh0BtzhNxSwCcmgScW9LhyMsDqg/8/2J1AUHHR4jzO4aDP8AwE6YhRC3RhehZwfXC1DVnb/hi3rFiL0rqWsn5Js4Sg7gKYATNTXyScpzD6R6yRW5UuTjfUIl+Ci/3sh0McJYLgsEpJbRqjHi7QI3AjWyBR/IwI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 11:03, Brendan Jackman wrote:
> As noted in can_spin_trylock(), using this is unsafe in this context.
> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side
> but missed the free side.
> 
> Impact: If BPF programs using these features in NMI (probably tracing)
> are present on non-SMP builds this might crash the kernel and is
> probably exploitable by local attackers for privilege escalation.
> 
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=18

Should be "Closes:"?
(Andrew can fix up locally)

> Cc: stable@vger.kernel.org
> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index af63558391345..5f9873dfccc5a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  		migratetype = MIGRATE_MOVABLE;
>  	}
>  
> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
> -		     && (in_nmi() || in_hardirq()))) {
> +	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
>  		add_page_to_zone_llist(zone, page, order);
>  		return;
>  	}
> 


