Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D3610F3DE7
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 13:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D226B0095; Sat, 28 Mar 2026 09:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD1A6B0096; Sat, 28 Mar 2026 09:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA1C6B0098; Sat, 28 Mar 2026 09:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F185A6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:32:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7365A140119
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:32:20 +0000 (UTC)
X-FDA: 84595560840.22.07E14FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CCA69C0002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:32:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YhO2hofa;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774704738; a=rsa-sha256;
	cv=none;
	b=xe5McEsWTBJZlgALlsvkJZ9cXBrkDyWhUNjN21m+Yp54YnBbLSgxTKYuYHfZ5u75/8u1ee
	waXyuuoCtWdsqeEF84k9KsHy7nKq5gsdGdCZRqwqqxPkSHBTaa8cJCprjbZaczqOplXmo4
	eK/I2JpO4CBDnKILSnvhyw1k5K9XGjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774704738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Avs2GkRw+KfC0HwQxGzSbzFTFQrzdk5NreHxllFholo=;
	b=km3Z9ODur/gDu80gMngsDuGWqRh34QBz1QE0XlXbbhV/YbTHQcF62N9MrmpRViYAE0BeuR
	kEKDI9ndFItWDhJ2R5+RRgBzG2yxs9lg/o5Xb0hRMnazC9NW2iKHMYbpGXPOpm71XfQx51
	PnW5yMaDthamsCi1SljgMTDWCi6/cpc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YhO2hofa;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21F2560018;
	Sat, 28 Mar 2026 13:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92405C4CEF7;
	Sat, 28 Mar 2026 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774704737;
	bh=iN2nAOvFgHdRaJFroDhcaD9ZuEASjAVpYmSsSO7MG1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhO2hofa6+3lYiZaEde0HHBPhe9ZGHPsQ2LSq1Kn3ukb2SYQeegyR5A9GjBjd7fKU
	 vpre8iK+afxqBfvUW7JEvRnX2gmjkuvP7GEccQFoiE/TF1JBAhx2ZhN9YKNyzOP291
	 tnUAIF6YwHG2RKzwSBVPdWRmiunsRvKMM7oupl1iJfYVyzlo9E3kfA60D5T7+MQhXK
	 2HNitmVZNcRcsDwioM062afplwo5NgcQ9IqHbppt24U9TV+ZLratI9Fyz05PNK/SsQ
	 rYq/P7WrHV6WOV/ob8zg383A0oTB75/dUb+/1clv5K9fDWDvDT/Bf1qCRTDQCwCcUo
	 OUkB11T8nA24Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Sat, 28 Mar 2026 06:32:15 -0700
Message-ID: <20260328133216.9697-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328022956.8415-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCA69C0002
X-Stat-Signature: 46d856xia4ngozzus1uk6y6m516hasia
X-HE-Tag: 1774704738-428854
X-HE-Meta: U2FsdGVkX1814Yp/8RDfIqLvsJFeUgyiVhTqx/wey2DhKlT7hFxnRplA85DMH0cId5UwIuJRkzZnB8TsgQx3CLlsK60+NafYk6CRrmApq7aACFFAgBEC6cAyVIBb8EsvsMkmnjLcy5wZSwdXfPupiwnavSRwmQGPPGZvL+YXPM0XGPn9yNQvh3RoRvpl236KlWlGd1E4lcp6TFas8QMXrr4xBeX4QQdr6D4keDhuMqhFAx2sy5w0Yp0cH06pKI2bDDM8av4CCoVd16PRb0FP/JceFgTsmUXUS3/pbMeC3CY5PKetGOMusPKX8uUiGGYZ4j3fX87/gjzGlEnG9ZiQHrYZ3IoP6OsTVOfbSwb7uuk/v5MFZWzIV+FZlLWsq9PW9tNsqZf6Bng1uQ69nYgs5B7tw8OulhQZr98lKj2OVqN1J5KajpegcXdH6dUTM6YXa+j0BRhpq5xstrxPUQyUB5WYOBdf0z6Z0RzlaZiYTEQ/QSLaIT8BYUCynlSVHjaTe3HG4PNGKR/SeWCyk/JPP2k+goNcIPCmEt4B4ItbgF1qDp+wYC2t3OxO6hfAawX8evRZ+EjHpvFJjsYjQs0y4ZHWqGmN3Bt/HX1Uv6HmQkkIQImkZgc2SHojxnI3hcLMHx0XO66RTjxDkS6XKQT7zkJKrRgMvjOtOFTlZ/u//6w3n47/yj+F3kCzq7csNKQ/Fcfj9dskDqY72nXH/024+IAwLw9DTL+gt+P6LpxtJChjtk6ZUxD6tlmTdVJrzfEizy/yLRC+FtC4DKBI0igJsbBBtejm5bxSge2C2I/K4fRd957c3U1FdLsVNEfC0SyEXi3zWZcmxpxi52PeGAdEfss0pyfpOjE9XkFSkzq8LWcJu6ShsTzICA4vYc5pXfO1EJLzyF8rS4vQWjFw7S0BuNqdjJDjoH9QImcZjTaYsXRvmPJkpCTLU+6LWfVPLZa/BVqBIu8vLWmNxINatde
 mUf/Kr0k
 pG4faxkHN/vg8QurTla4/ahvysTSqG14bAhwePPDfEgkh+Bu4/s4EE3cLNHJitS0+YGmfJDtuuYqFZKElh3JsHOcUUWRzgB44IleSIQRbVcssA9ZF9pbpvu+bDz//AD/8Be5VVBocfm8xg7iHFjzWUtGkNT8QgHKbc5eZEzilqooOAWN+wCpHlh0zyQXoPe78HUU93jyCROEDUn0dNVigAI6wtkjLVGj5IM+vBAEQHrooXwVmEKWY6Ss15Hvrd88beN0CQ2hdWSazaTUGKzbfMi/ZSKmZeUw3XM/EmQrSTenoC1UtNdk1rbEfxV/fXovmpmsnWfEDAsgFm94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: good catch but orthogonal to this patch.

On Fri, 27 Mar 2026 19:29:55 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260328005412.7606-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit add63112781ae04626ae6cb9bce55a85234f6e49
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
> 
> This commit adds validation for the given memory node id to prevent out of
> bounds access when calculating node memory metrics. If an invalid node id
> is provided, it defaults to returning 0% used or 100% free memory.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2239,12 +2239,24 @@ static inline u64 damos_get_some_mem_psi_total(void)
> >  static __kernel_ulong_t damos_get_node_mem_bp(
> >  		struct damos_quota_goal *goal)
> >  {
> >  	struct sysinfo i;
> >  	__kernel_ulong_t numerator;
> >  
> > +	if (invalid_mem_node(goal->nid)) {
> > +		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> > +			return 0;
> > +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> > +			return 10000;
> > +	}
> > +
> >  	si_meminfo_node(&i, goal->nid);
> >  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> >  		numerator = i.totalram - i.freeram;
> >  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> >  		numerator = i.freeram;
> >  	return mult_frac(numerator, 10000, i.totalram);
> 
> Could this result in a division by zero panic?
> 
> While invalid_mem_node() checks node_state(nid, N_MEMORY) to ensure the
> node has present memory pages, si_meminfo_node() sets i.totalram based
> solely on managed pages. If all memory on the node is reserved, i.totalram
> could be 0.
> 
> Additionally, since the node_state() check is lockless, memory could be
> concurrently offlined after invalid_mem_node() but before si_meminfo_node(),
> also resulting in i.totalram being 0.
> 
> Would it be safer to explicitly verify i.totalram is greater than 0 before
> calling mult_frac()?

I'm not very sure if totalram becoming zero is available, but seems making
sense.  But orthogonal to this patch.  I will work on this with another patch.


Thanks,
SJ

[...]

