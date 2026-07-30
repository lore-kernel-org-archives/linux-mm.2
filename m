Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB3AC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90C96B0092; Thu, 30 Jul 2026 07:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B685A6B0093; Thu, 30 Jul 2026 07:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7ECA6B0095; Thu, 30 Jul 2026 07:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 825806B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:40:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F426C0940
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:40:12 +0000 (UTC)
X-FDA: 85045249464.23.76848A3
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id AF221100010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:40:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndGdv9Br;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785411610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iB3gW7E5gBTJYv7yCW1pV41bx1pEZMVfRRS3zFR2cWM=;
	b=4wJhD8U+N0KX8/fxroTF9bgFxuIe7NuJdQf89niMM9/RrsvOHiQ786xeqVTFcoFoFdnxPM
	/2mWovr8vaqY1mc0o/V4J7hQetavrBPZcNZwNX8liWs8gqSk1YifXuVXgFoJuN01QCR7bO
	U8F6vYCUQBt2xpggW0SzGENqa4ByqJA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndGdv9Br;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785411610;
	b=G6q1KDv3ernyegiZSk6aE3wj2s74hKlJSGSmD0H0uHj/XytmcKbk+zRHcxP/axjEtlpVFA
	3qufuEBy8IBH/gIWXCo2hZ9KiKTvDN7fmH95omITONInVuKkppu6MkJU4bCHq17Lx+T345
	FYVb1DRqGDyUqAbNFS90lN/PjJ7JYGw=
Date: Thu, 30 Jul 2026 19:39:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785411601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iB3gW7E5gBTJYv7yCW1pV41bx1pEZMVfRRS3zFR2cWM=;
	b=ndGdv9Br3wEn10awUNRH8EYTM1ogNtakYjE886JQ9r8m3gtOpYEDANTxWibZ8zujBaSHNa
	xEcGwFsUDZorOi9EqfPpyO//+1Bw4P6kmTLnJ0crKclTNd/ZxfCcWR/ZOSouUA70qZ/iPS
	qMLaztAy/hXzH37oyrJM3PNZKIiXQ9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <ams30IqyBediM9kd@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AF221100010
X-Rspam-User: 
X-Stat-Signature: 4utdiuthzg15opui6d6rrobwusifhrqd
X-Rspamd-Server: rspam04
X-HE-Tag: 1785411608-444293
X-HE-Meta: U2FsdGVkX1+0vhsc2t7BuoaChCGuj5j+Vtc6qMwu6HWItFilTsHgwsANlgMiYfgFbCReq6TK9rBWbvoXh7NsXEjduuywET7PAjv1U5HXjYqgcwrhOC78H42G8RceAlaPuON2+reBYlZdX6Dj+hMYhe2g9U8VKXoZTjqsjvuOQJTCFl+/gjJu9Ryop4sBUrV96FNmxjYa21gBPgWa65c3dJnzy1wlBb7l5nZ4jl3Ravgi7G9/leYWTfGPqTPa+tA5tFUA8GV2L0ujNIdl9r9pesEoPw3xJ2PREuflSKnzOGm2sdhJUo0nCkl0Ugjhv1F7H6/UhLPyVCOmhKy/fhCqajfT15fXdLzVeDw+wBfzID2sDilfMqjNP39cTtg3SZc9+HWmlFcqT/9K6wPBRhb8UyaH/E/AaIrqdH+ods3zXrxRog4Oi+a8SvfeLIfQ+tBNvBz/QGMcRsWF/lB5t9+5jvLlx2MiX9C7JD+f7ggdCQoR0iiF95tbXkTX9+H58oCfBNlz1FH6wxOflSSrd5mjdAFs/mmK5nh1TJrlxeiPTzLernKs9b+jRiNW0yrQqdegrdyX027NG4oLFgcajEFTfFVs0502w2oT2+S9vkKYkTHZyhXreWe38x6rDKXi//beVxIMg85gxSwuOnP4NekJKqT+9CJwi5EN/WsM7UQvwyrG7iRC56v+/iK7V9QzkGybsdkE941kv7gtEyHrFwQuUh8Xmba+54OV1lifCiMl+slDzEqPO/2Kfq4GSy1lwXUjcCqXnwg2hkjDcyOYGOkz/7q1nOXC4DySzpwapLuWS9F36pY4EggZ6dt/fCtFS4z5CnLdUaPFwbL6BihaJHgwnDFq0sGsLHYdivCj1V1rd4zSPi5yr+n32JAyXwNnF9csELDTSbiCmA1XvG0n6nf0sxt7X7U7FRp2U2OqBwC8+MiOo3tPO8PHAcTXA1Io+vQ5Z0fIqjaZtEyj74+2vju
 V57Gper5
 eKV7AF7ZZ0cI2VBjZxWQO68CzY9uhxlZpR3SR36uaN9Jw/FRS2hoOKi0znbZ+9Ax07OjZlTOgN1igQsXRdIdx+StJwfrCEPK77PMOxMwexeYj0SQmvahW0Ex0f9dgzV3XnOP0S2RsxwrqFno5AEF8tOJlpOhXujckDymcgropyzAtjqXejdc48MvgS03wdfOA29tZVgTf+1ukAMNWU/5jYzb1kZUYWac3mweywrPP4ynUnVYtCEltw4QIYJgRjfiEYzJL6dDqKruDYzb0C4EY8y/r2qiNED9MBCcXyA32a7GlVFE=
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

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

