Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0B0CDB462
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D348E000D; Thu, 13 Nov 2025 18:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D72A8E0002; Thu, 13 Nov 2025 18:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19ED08E000D; Thu, 13 Nov 2025 18:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08B488E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:47:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1FE21601C4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:47:33 +0000 (UTC)
X-FDA: 84107223186.06.15AA53C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6426B1C0005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:47:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWrykRig;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763077652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50zTCKY9mXOYH+V0hxkxUPJ13z23m/hLgMpOeKyQKJg=;
	b=WKqmOTPxi9G5h6IQlpllqNFC4BxQ+pn7C0EPD3EQ9uHketsoGdBQmRyFvzfjDvKhEZY5MV
	PLEH5qwuJEWCsnMJpfgyXHyx3+1/kbsthCSLv8wgIvI4prmXPI2QU3VqZuEY5BMe4rsIH+
	3ba7rdQ7ygaVmlMwiI9FGpOrptFq0hM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWrykRig;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763077652; a=rsa-sha256;
	cv=none;
	b=YczQ5p1C4gvhtm8lEzYrc6ie7EPdKlQ7Z3QRK+aAGPrTzG1hi7P1v0Ia65gakN6geMIXuW
	TOs6fXWCHcEPIQCb77ao6EwbuM5xFhaGgWQVYyg6d6NHvQydTnei92hTzwW2bM4+9FD94g
	DDXgFZMoV/l59i2sJuMq8Qn212fKW6E=
Date: Thu, 13 Nov 2025 15:47:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763077648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50zTCKY9mXOYH+V0hxkxUPJ13z23m/hLgMpOeKyQKJg=;
	b=XWrykRigyyr6vrW9l+zaS+D4oHmXaqZUR40pFrw9eNiXDNVi6P6aUgiDrDVih6xOax4D2F
	ijfTUMKtebk9YTlFVnhF+CYcJINhXPJ+yBhozfU5TxbGthgqApaNerO3c2MmJWTcZGXFAw
	qS6tl3BCH+JTgBlIEJlGCiemwIRnpg4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <lqcwz26ajddhoaq3gfuyt3mzwfn7waeqksoz6k55jrtn32u42z@pdf3dor7ntb6>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251024022711.382238-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6426B1C0005
X-Stat-Signature: ij1517kmf49hn7qc7ekj1suwpietqr71
X-Rspam-User: 
X-HE-Tag: 1763077650-774068
X-HE-Meta: U2FsdGVkX1/dEZFg8hIrclMAZBge5kxfHbF8T378lpkAlLXBPWo+7Q9E5eH+e16jMqMlNBf4ol2MjbcPR/qZYXHk70SqKeAmgSEpocHxVaXmHFK8rVK/rmgCETo4BBEK4KkJuPaGIrpG/oukEQFWFlZ9WahbXU8mmYhT2EV5ngrodIiRfDu8NZtyXEkbtehIsQ+3obRKAdnxTgWo2nVvLZhvWd6dRaylKUn1f52d414aD0scHDYD+dV7ntSUqHz9AeDDG1lPjRx0MxEH+hof+dyI3YQ5icMS2DTRkUWfSjjDthXlzyt7lQGCRDb+rmWVzWsZpmj+5PC4HS+SFtgNAPMBDr09xTC0LXU41TukEEHxAp4ci4c1/qgMyaH3BC8nKt3bDX0c+Lunph503Szc0iddKFzbEN/YHO1utbnMg0s9ViQNvWyWWO6QFzLvjq9Um6OP6X1kwmO1pw5JsTG3NYj/hRZJvDbO54FQWHxWsls5UeTD7RLuWe9mxOQkNGX4uVu2FL+4XvPhCEHr5otdTRBm7DYpD+/yYc5vOs2pQHm9T54vrnqSVZ4vGf3aA4KDUHeCHHn2/F9mpuPR1USq03zdQysDL3QZ47MjQzCg9Ocw9ku5BDVYZtFmfkgsBD4eeZ3XCNfJ14BTLazpjKYOqHh3ZPs6GwgviPJhFYuwd8xF5XAP/LK6w+ng8dmmLu2F1Epf22/WQOtbO9S9RDS4Sx73qwi1fo8SITFMffJ7g4Mhyxbk83zZnUXqJAPbfvzc599/EZXz21hyV+CUyc42/ZmVZw+5Z7euethVOiS9rbenf/wgVrOz3d3UZkQkbqrCzkz8TOpFUnronjdsfkxKbz+XWBt9JvgR8XJd36sHRc60jEzVytn7SJMQAmAAgqvxAkSAdCYGQeZXqLJk+c9nFjVlsxwOI4B7TNrKFMTuov7HX6szo/y3nugQ16Y6n8VestKxMKM+3Rk/pkFVQoD
 MenC3ypS
 JHEDFHMQ0EieidbWtx6mIU+LzndTeZhR2PS7haNUyouWorzKxZnBAcvK3Y+vGzG79zXuILWCbVu0A2VUQlAXYG0F6lUN9zRY/tVE8Neq+KqpH03cAhHNv6xHG37zRazhrXz3dQFUhKLjumH0F89GJ1P1+yLcqE2XJ0H5dZ/hn2dzHqEO5MCUX6kowhk1dwDvSHLTau+kbs8s5wLA+iZGknrZ0ARPmbZH8WeBzbzkyiZKSWzua/Cmt9H3TQyDRvJRKZN3FXPdh3+pooAf18wGkidkByQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:27:11AM +0800, Jiayuan Chen wrote:
> We encountered a scenario where direct memory reclaim was triggered,
> leading to increased system latency:
> 
> 1. The memory.low values set on host pods are actually quite large, some
>    pods are set to 10GB, others to 20GB, etc.
> 2. Since most pods have memory protection configured, each time kswapd is
>    woken up, if a pod's memory usage hasn't exceeded its own memory.low,
>    its memory won't be reclaimed.
> 3. When applications start up, rapidly consume memory, or experience
>    network traffic bursts, the kernel reaches steal_suitable_fallback(),
>    which sets watermark_boost and subsequently wakes kswapd.
> 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
>    triggered by watermark_boost, the maximum priority is 10. Higher
>    priority values mean less aggressive LRU scanning, which can result in
>    no pages being reclaimed during a single scan cycle:
> 
> if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
>     raise_priority = false;
> 
> 5. This eventually causes pgdat->kswapd_failures to continuously
>    accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops
>    working. At this point, the system's available memory is still
>    significantly above the high watermark — it's inappropriate for kswapd
>    to stop under these conditions.
> 
> The final observable issue is that a brief period of rapid memory
> allocation causes kswapd to stop running, ultimately triggering direct
> reclaim and making the applications unresponsive.
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Please resolve Andrew's comment and add couple of lines on boosted
watermark increasing the chances of kswapd failures and the patch only
targets that particular scenario, the general solution TBD in the commit
message.

With that, you can add:

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>


