Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC3FCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CEA6B0005; Wed, 10 Jun 2026 17:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4D16B0088; Wed, 10 Jun 2026 17:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB576B008C; Wed, 10 Jun 2026 17:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC9E6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:13:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 495F71C228D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:13:45 +0000 (UTC)
X-FDA: 84865254810.27.D0257B8
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3EBD2A0002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:13:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWaWX5SH;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781126023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ikb65W1PWX9LtR2B41SaPI3vlwLCYLSMOuFtg/4KXzM=;
	b=C89w/1GbcVZQdGdKHA8B2cvNliomjkKNp0ghCa0xp3BC7Rgk4WSnhvs4U5cWK/4tzKTDmk
	WBSdchOmuTU8Mh+AoSiBQ7IQSPvoHiWLQhDa+FYrw8+YR/+dxlGLQQO9FgfcBolhmiD/yT
	IHWqQDDSYeL14y+fq3Emg2ateMqP8CU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781126023;
	b=wRVC/E2Tu1rXeXcPIke/V7jNHx19apFMKn0IVGx29JTsJWNVCeb/NHQPewGkdEy+33Lwz2
	4BYirTk8eW9Y/XJDps5FapKDSsAbZF37H3rllGhZGmKIGIB5LH17M0cgLQDnxGzgeeJiY/
	DGuM9bIrwAYcq8J+KwrtRuPkqm9bJ3I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWaWX5SH;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 10 Jun 2026 14:13:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781126021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ikb65W1PWX9LtR2B41SaPI3vlwLCYLSMOuFtg/4KXzM=;
	b=CWaWX5SHnj4MeHYvyjLwqG5gpN0qCRGwdE0LwQN6mGH74LHMXirPPvjtFwbczwgnK9L/n1
	XSdDKKg3WO9zfFIbCzSYpN1Rdj+LucRTFK1dRZH6wEGOyWvzQxRlvOVKiZhv2iquSdnRhQ
	qF0a9zi0T9fxV7vIHc4jDyTFFisDsNc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, usama.arif@linux.dev, 
	akpm@linux-foundation.org, vbabka@kernel.org, mhocko@suse.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kasong@tencent.com, 
	qi.zheng@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
Message-ID: <ainTWlyb7SIiYdeC@linux.dev>
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610195220.12403-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3EBD2A0002
X-Rspam-User: 
X-Stat-Signature: 1szgocm9sz5wzq7yhz1tsxxwnpb99ia7
X-Rspamd-Server: rspam08
X-HE-Tag: 1781126023-108592
X-HE-Meta: U2FsdGVkX1+/2C7bvu05xBKYh2KRU4j3K65UPWhero0M5XWAqfgWR5BemSfShCWIOCjqaPC0nNnFJ89FzNuTXsImdJHygKqpTDHnom/d6JFsTXWWA1AmWycTuMDdNvxW7eXOFZMjhPsEqaVBDq8E66GYkhUo06wVQHVpLPzwYvcqSmExBupA8QAsEt7CaGDm0kNpHGeIcsqTpnsXj6X0pmdPUz1zlXS2dXJ694z6PNJfc7TwO7GX/77vZUaWnnw922pp0ZcocaCOTnA0GbcLIfd4yyaA2ZmrrfwWbAcnwBSTdEz3rw+9GEr1OE5pUHu55H6Sq1hQvwDXiZB+VEycyzWQf06DEcRi4AqeFwYDsD1FMk/9B1WxsTmzmdnE6WtxeRjil/rdGtQ1ChHm6FH/mKoHjmVBdufN93+Iq6uI+gQMa/9BmgyT0wp5giEEWc/fuJEueKpi2FjZeFE6XfhNq4GCNcIH4rL8d3IX8v+Wj4TmIMG2jW94C1sLyrusA8k301qy3dXF8GgQNth7kyBaF+6akyS2unZZgsRNggMWMl0xp6x5wQw99YMPhKGN61HJgqspXtR341acDMFxSEn6XWsWOVIJ+yhGngrVGqPHC/ExmsGAwVdSZ14bDf2qWyIqu+H77g8pA8Tf5/XeXVPae0xrbWp/945k5ZIkffgOQFMgwrY74ezgl96/PfcG/Qv08ZD26RIWYQx3ddFX69cEtQgXcsKwf35xVluIUUbiTP/h6TOl3Eashw5X0TFm32FyJvgKoNQHDANmZuyJcofLZ2E3beESns8AxcxkgVTNKsJfTpUxbE2L4m+Y08t9jxiJqrGxzDDFK/Pz6yWfvRiaU0KCahjzvTHPavX4aNzWYrLaxFPPuO46H/D1ceE9U1FH9OFk6qgGRA9ESZxV0+38VSBx8ZX1DrAJ9Vgi3n3CK6NUj66CPsaK+LKm+0vqLnxOzVFo/QbRvsghod9gf4i
 qB1lfLwK
 RPdxjH1VkU5cNEquTF1OXslHSKbANJQ+sU6i2MoIB5gkjzTHAXwj0SbDvftuYrOV6pHCq0Fvoo8qbZBUaGgQlUfqhQrtwf7QnxUvvPy6kUYdau9ImOmMnDK6MpukIfR8k7moMlmnt911WMAd8TZ4rY90RS/OmFQMVBNmFTjtbSci7F4eeDvZa7fuSmswgwqEfYRmuJmNrM+ZFUQ5kaPKNc67+bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 12:52:20PM -0700, JP Kobryn wrote:
> LRU add batches can be drained before they reach capacity. This can be a
> source of LRU lock contention, but it is not currently possible to
> attribute these drains to callers with existing tracepoints.
> 
> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
> lru_add batch is drained. This allows tracing to distinguish full drains
> from partial drains and attribute them to the calling stack.
> 
> Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
> whether they set the force flag for all CPUs. The tracepoint resembles
> the signature of the enclosing function, but is needed because of
> potential inlining.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


