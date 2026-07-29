Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9595C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFADA6B008A; Wed, 29 Jul 2026 09:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD20D6B008C; Wed, 29 Jul 2026 09:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F236B0092; Wed, 29 Jul 2026 09:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83CC86B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0018012017B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:03:06 +0000 (UTC)
X-FDA: 85041224814.23.FB5C9E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5EB4120013
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:03:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TY6fh0Vm;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785315785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk/wmzjRin7wzdv1xCpmqWE7MxHPtowEg27I7xdjRXU=;
	b=osgORY6ZVHjJw5bFVaBGXlm4kVGF1jZRtoNEB2aE503PgZOfTEZx8N6XY9ZhwkD/qFcQu2
	ebchW857cjhh+WESZKErXvHUsyN3j2X0N+wqauqG/HBH8Efy14gRwcpPshUft2/go4e4c7
	oHiUCqTQmXgJQcTAbXPHPnmrR4N9KUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TY6fh0Vm;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785315785;
	b=X15lSmEbkwpJm3XjkUSowlcI9WR0v7OjKTRcr00ZxmgpKS13OOhBLHkyGAOCxSF+CNngNj
	5CLzBKYo7AYFCAqWZDTvdHxDAJ3Meh4M1759OA4zAS2JyY5ozYBvBGfd4GZKhL+IDV4qXS
	r/61fdFvHqVlrBqUuuoOiSm+ygBB8hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5243640711;
	Wed, 29 Jul 2026 09:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119D1F000E9;
	Wed, 29 Jul 2026 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785315783;
	bh=Hk/wmzjRin7wzdv1xCpmqWE7MxHPtowEg27I7xdjRXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TY6fh0Vm6QKgQYYTN50HivvfDbEnYiqss8uAwCns6ZiK1ZrYS2G4S8O8Wg89ptNW/
	 1Sm2IEzvau6S6bDvvOMCCihghEtUDk5cPqIckytaeMbQ2WjaWpwJdt3zgRsytmXoe8
	 6CTVS/lSqjWfYES/NUbJu63q0hKVAHUTCN+I5JlLMEBcqpEQjDMbvAaGGuqBBHDgIi
	 kuFbIb/naGe1/y+UjD/F38chD3213P2dXgm33V4fh4nbuS9u6XHHacu8pNf8w5n7VZ
	 dZEkt0Sx2v+jz0gJkzRynTw7eOwZW1J3texZ4MFuLn6L+XyNdYne7OKiCz+HF6lUgD
	 6JEUpLNzTXGzg==
Date: Wed, 29 Jul 2026 18:03:00 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amm6Ke2U2J0RwW07@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EB4120013
X-Stat-Signature: coumdsz9p5s57azx3uq6s7q9iyzgzmnc
X-HE-Tag: 1785315785-92297
X-HE-Meta: U2FsdGVkX1+AhroUNjW4zLH7eQcL2jBeAE8UjoASoAGyr4Fg+uPU/Wo4sbnRwos3SA6e6yGs7RhzLpL+72dtqc/TIaOtfojlqS/YC6e+dt/aB/RVpWRSdlaci8axYlmMOOj9LvMQdMXNPc4tI0/62ogwDD5YPT8eBCx427LU1sRms4picz8eA7iRFniKFvjlQM9qkBTASZ7CDK8PIXPI/w8Kz/VuZvJt/LluY5w1xlOkNwvaJlzSm3apbRWsgRtd6XJhq9WLcxw8+8ytncMje32YvLarI0yJSrAkDKoHYMAEEsW6J/pdpB5M08Q54PSIZ5NfUF+PvBSP+9bszQxOQeJKofiPeqFrS2W5HvSMDutPggLhr57W9Vnv+UEvAjKLhhJk+FPcYyqEcgNn+W/1PlfbXcYjvM6KbZgeS/E/dPFGi6hqYCQj2/Udnekv1ZIgxUsoPqlf92vSKaOkBu8FmnI6+OXSWVwuiGU0nM+un88TQSO5Y6kQfRqoe2idxpUX0p9hBwc9UxgNMQs/3KLK/43cfSN5qPp5BbBZd4W+x8wXP1cKuarSeN8OGoWaVSFkpA6mfPtii7osFtUENshNL7MtSc9HuuUqFya7k7xOzXFyVEx9Yx5irCaAPKGKidrmfE+UeHa1MrAWODjVAZ0qcoEPZ1bDkLk6qnKV2FwM4hLBhTRG1433BFfTfgfJR4NfWo4sY2k811+sfLOSIhUPH4vSXw9I6ZHLBh20BS5QaFLDHX07d9hBUuZpsqGdiKiUIqYABWgbo0lIGFnl+XvPSlBrWnhe9bP5cpNau67XeRJSXVrkwbLqkGoKQzaNjqLj6a8XrWduBghb4f9GDbARyO0m65x5jNVlu/0lVdk4Z9zpkKHGlPAKSIY33V7cKzYftrlGwE4dUX6bMR2jomH6WRujluPH4Rna6xsbihQdoELlk3B+y5B3WdrrSH4cnGEbT+z17rFryS+28J8W6nj
 5xN3fa5Q
 6T/x8E9UVz7OFImbyp0Gek4KSlUDGvMlDpA4qg9XAZg9W4VKV2+X7serrt1jrqZFbvbkDf5LLReqza1kfr8zMDYeaAq1zKwf2Ia8jxH2a0DcSmaK5Qq3cnT57XXqy/N0xpEEZ6wjCOBeh5GkHuY1d5KTRCTdIjte2RY3Y96X+vcTHhRBKSj8A7Oh81dZyonvnGsrhfuKAAxm/WaQKkhexY+wg/7iSbzKwdCxEpu/GcLficCeHtB6yWrnfUyfZAXJXiurYN07sgbhlcYgMOanQMS1xdcCz2vaaH7U3TFLv28DWdgIYzgzMTIdHbHSsPTTXyfDViiZVcfQRb3Q2Vnb2kNcpD2OnU6hDYeVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:02PM +0200, Vlastimil Babka (SUSE) wrote:
> Currently, struct slabobj_ext can hold both objcg pointer and
> codetag_ref (when both are compile-enabled) and there is an array of as
> many slabobj_ext instances as there are objects in a slab.
> 
> This makes the layout fixed so even if codetag_ref is unused (because
> memory allocation profiling is disabled), the space for them is
> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> do not ever need objcg pointers, leading to wasted memory with memory
> allocation profiling enabled.
> 
> To make this more flexible, change the layout so that struct slabobj_ext
> becomes a union of objcg pointer and codetag_ref (to ensure uniform
> size; in practice both are the same size anyway). The slabobj_ext array
> then can have twice as many elements as before. For cache locality
> purposes, the effective memory layout is unchanged, so objcg and codetag
> ref for a given object are still adjacent.
> 
> cache_obj_ext_size() returns the effective size of (0-2) struct
> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
> both return a constant value derived from the config options, but will
> be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.
> 
> No functional change intended, the layout is still effectively static.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

