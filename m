Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C80C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E696B0095; Thu, 10 Sep 2026 04:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217796B0096; Thu, 10 Sep 2026 04:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105C16B0098; Thu, 10 Sep 2026 04:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFD0D6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:33:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E1B31C2328
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:33:16 +0000 (UTC)
X-FDA: 85197187992.14.2065DEB
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	by imf07.hostedemail.com (Postfix) with ESMTP id 298AE40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:33:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=THkswX8z;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789029194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i91EWrMepTZXh/G+Sgm1TjnhlAhP3K0merfKLkHgMv8=;
	b=Al512UQHxARX63EToocenNsLs14gL4gHw4dvCYWAsi7fNmf9DAsHDczV+tG2uTtQwqWInX
	oyAJgw2Ii52jmXVFNj7AyPniVEKZNimKaUGwdQ/lIT4/ONDYEK5jgVZawCRQTcV3Kq35O1
	J2zvkOuFfW9e0KlgcZLM5Mp1AM3uUzI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=THkswX8z;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789029194;
	b=jIYHfcQtxcrGQG2rNsZ6s9xWCgVsRYjxVlyMVKGGW4A6aB4xrEhJ7fRRX52chtfJ7mLZDg
	p5dYG13T/tGpNVvA2RKGruZ3We2EenrmAKY3hz398n4WFuom71wg6M9++ZRP+SB+7M8m6k
	CiCfCrdd8zAoknQg2euvfXhUl6FvfyU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3Q0TgDX5uuy2JzuGxiyBfj3XV6sc+FicZjZ2PsgT9iA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789029190; v=1; x=1789633990;
 b=THkswX8z6Oj7KnJ6FLOMBAqlYPi/J8Wf9v85JOGAcQb+yPv/YPVxKkmAv2c4PrKih1WDLEre
 ROyrzB2U2i+kakBo+b4FEJoYcqF+ylLGTuJUXi4H7wxCKeC5waL0WWHVZG8Fm1xVBjMtM38ByJr
 BxhQX5OVNpNiIzxJ5iuA2dtc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d2b225be2d1f5814;
	Thu, 10 Sep 2026 08:33:10 +0000
X-Mizu-Trace-ID: d2b225be2d1f5814
X-Migadu-Flow: FLOW_OUT
Message-ID: <db978d02-2d5d-4d9c-994a-8791de7afa30@linux.dev>
Date: Thu, 10 Sep 2026 16:33:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
 lirongqing <lirongqing@baidu.com>
References: <20260905152717.11711-1-urezki@gmail.com>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260905152717.11711-1-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 298AE40006
X-Stat-Signature: kp4oijd5i7i6bnqc9uta93isiwndaf5h
X-Rspam-User: 
X-HE-Tag: 1789029191-182868
X-HE-Meta: U2FsdGVkX19lGp14omyHkp6g7n2Rr4+tN1c2S6IuaUApcOfGhuiIM6FWVkukMpbZlAT0bO/TGAMNH/lml/rq/zlK+K5YNbewJW1XVBoiy2XrC70HhY7fGZjvj5tewgWtg1b7av3QeiNbCLtXGq8S1acySip6/R4zLtQNweco6G6d0vv3RSwmul7Dy2yjDXt8q25xHYFZ7LkG3Iu0uYJaaoId9ZyLBjvW3+Zup8NH/gVkBGRnakwFxVS3xacPRjuqTlBs728tNwEBbecLtKBT2ZNGFR4QRB7YAE1RHQRbY8lMKqjqErFxi63UC7++sqcemmi4ZX0yFAaEfCBpNH8fpcBkYC1aR5sv29HXqIhj+SFgf1+TsIcMmVECGu0dFbgb8ZyJsYfgH+8yitiZ34B8f6O6Xy7Xvja7zpQ+U7ZH1mGNTp2dqQR8WvGVYakCY6Bp30BFU320XAmR50MzclyMJdvHRq9axVzovq4bS4NvEzLw/jo2J0Lhjl/S2aWoyp08dwAmKuCc/Nv+flsCe06Lm1uWQTFealPx/41ArSwmSQ9ZWEyzRkWNga3kUaBsA2FRDvMUPDZFbmfRrU05Z2NWOBL1rXNzGH+SUlhzKlV+GX3cDWgG/BKy1iJtjNshO3+2L0FwpcEsHkUuKN+3z0W6PfwW0ULyWo/w5pz5MV0JnpQ2LqwZPBcTWBJTn4c12n53u9Oqk10qmq7/vSUkd37fcVd8VBFNkUmbuMaIryiTtYV1epmnTNrHaFc/1baxDP4JssnTgQnzNxi5+zvJdl7eySmcidyGcmTvEOuAxT5zsXdEWImx0sCqYilEAFYxT3e6VKqyxcTKo0SkO7UEAKfzvjD9YSH/U8232TVS++ylP7QA5yhaMmzgP3dNBwnomtqS7C5aeAKJul3CJppTEIOmPI/xrMi5o4V6bifhhI+Chzn7XRzXpjnKOj+DPYW8yXXTU8rhGl2WM4BlzTS8fmn
 VInDwrQW
 r30g4U4IjQmxkCZIFLFVoXq8pr7FPf5SBzQGo5lojQJYnxJ1tIDjcBxM5wJuBA8Vec/h9OOoS/vFVJCs8glpydZeNKImkU+u7jP+S7c/nVTueqIWQAVQq4JQfiVIRIhc6SM5+9wxZlSh88rvErEv7txgGaDk31NNmhpu+C57GyntowqLwJh2evobGCuLsKUFRycadcec4qcMHMELkBWEFRtsbp6n3gD/OudCft4QrQerrpwHRoyv+/FbuQBTGqCI1gGcXwsPxMcYfL63LqBEih/jmwurRQt5uLJiMgWr44nenLZ4sCRm2R7YnWvKxO0MsHM7cunp3gTJlUPLUroZGlpelktRPY0W3LTI4+zd8Kbcrbav5LwKEnsh+MJMXfkveVmFZ90jnmGWM5jSCHEeptaWQAKJ6mfzsnQ6wMmX+SvDRhMKzRkgrrM5o/GlSdeS/iI+Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/5 23:27, Uladzislau Rezki (Sony) 写道:
> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
> 
> Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> workqueue. This allows drain_vmap_work to wait for helpers
> completion without creating dependency on the same rescuer
> thread and avoid a potential parent/child deadlock.
> 
> Simplify purge helper scheduling by removing cpumask-based
> iteration to iterating directly over vmap nodes checking
> work_queued state.
> 
> Cc: stable@vger.kernel.org
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Ye Liu <ye.liu@linux.dev>
> Cc: lirongqing <lirongqing@baidu.com>
> Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
> Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> Reviewed-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Reviewed-by: Ye Liu <liuye@kylinos.cn>

-- 
Thanks,
Ye Liu


