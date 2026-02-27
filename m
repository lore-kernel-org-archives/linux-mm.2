Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1EDFD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1776B0254; Thu, 26 Feb 2026 20:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D988C6B0278; Thu, 26 Feb 2026 20:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECE26B028D; Thu, 26 Feb 2026 20:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5CFB6B0254
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:01:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40C41C1B76
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:01:43 +0000 (UTC)
X-FDA: 84488434086.04.F203FAA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id 043DF40013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:01:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oDi5sO2u;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772154101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlJB5kvuqCF53/lXF2sDltcN60w2q3Z8arXeZA7jEjU=;
	b=YnP3syEhy+sybkFdNVRhWlSeCon9MsZv21V8pcY2ShMNkqtKM7rDauMqehkk4ZWrrD7O+V
	nX4fNArsdHJAQeY4SyiW3GI/HC56SuPDuQy9UHp7KrKiqa9M2RgrUrCGRJRpEHgF7hs0SH
	2CpQVRbo9q+XSY7IEq9rgJyhYLxYGUk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oDi5sO2u;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772154101; a=rsa-sha256;
	cv=none;
	b=LnCrHZ/p2WdVlpTiVLstnn5Xvam0Vg8LBvOsvKydxztt1YHc0ZNI894pWA7uJdmPFs5n9E
	y5vHaqgR5KuFeuRUpdUJFzmsoesnnWHUtWTyZe6bFgk9Dxlk+jGgIpWVjiOy4AP4mKvGle
	MdgEJV0DWIQkkSyjuLXTQiQDgXYMhAk=
Date: Fri, 27 Feb 2026 09:01:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772154095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlJB5kvuqCF53/lXF2sDltcN60w2q3Z8arXeZA7jEjU=;
	b=oDi5sO2uB64YCfPb7Avp4YSvjX6rcfbfiOv+UeqPjNP4kYWcIYo4aJZzojd2g4k/jxL2Xs
	OCLaIp2gLbRNDo/Ky6PRDU1sS3R4CG3u61su74QUaLfvQERFtHoXjCOynjQBDD8BYBagFi
	8CKE37DHaLsCVwliA2serNe26J6eoUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
References: <20260226115145.62903-1-hao.li@linux.dev>
 <aaBM0fN8fqER7Avf@linux.dev>
 <e759dd9b-0857-4155-b570-cd002155f123@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e759dd9b-0857-4155-b570-cd002155f123@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 043DF40013
X-Stat-Signature: 1cw8bcghxfp57m5mn73u1kgibnudiwhu
X-Rspam-User: 
X-HE-Tag: 1772154100-868071
X-HE-Meta: U2FsdGVkX1/xdOEu8TEAfGLXGWK3hT0L4QdDMMPRkBn5zbbpYfzqEwspHy2ctKzGgphsXvHwW+Fuv5TbX2ncldexag0Vb0VP1a7lxYNRqvo2XQ9VqmNvV7Jo40TD5JKqfYQzPsjUkEiZlJ3ztD7M6vATkQz0bVi8hEQb7ABO2sdQdgb3OdS5U/BsNGYRCNPlzQK0TZDth4NMkHH55kmHZ8kw4sY5ajaethCVU+tglvY5PLt1dXiytZY4GHeuh9Xk99nDK+YWImW5IpdLvKg2HmpLW8IPm2DB4/GrTjSRYaPKORG+R5fDg5tP584E+iO/m/k0z2vAaKsVeIqPo2slYJ8rAf1v47iZ4yQ3tl7+BqoUxwltVOa8innE22tBooqgH/Vy2lJNnbX6COJ/l3cSmocMdjhOzzgbvITtaVJFVxUjyyuUpviv+YoSg9iDmTxKl2JPKBwKSjmNbjTbQTxBCDLxI4wHkd7yIYbaevFZ9CvDV7zMjvQcoXlnlhVK8VCywmNOnDP6/AqtEichZNu+qBRsvTDnVTtO/3cnLx+q9lO/Giu5TA9Ja+/CZI9wjzH8vU7MkYvK1/lrcAsdYfPaALiFydGLifNv2NHYUz/WVH3kJMVmLMDn4ShfqBhNdZDRlYE2wGp2gXMOTrN2cjLonD8E5kLrtIlTncvhMB/chyXjkPjy9PUO/mJrkJVzoczZaoj/qSMQkNRCcvu6WX/3ZU3bTqXWuqKYGyZf6r+cqMyNai/tsGYhb6Pz11Qcyhafq0iygU71bZae7xATdhY2nzBQcM/WzAdsN8ekgmOJGEOee8VE75FjWeiZo25rBMdgIM9wVcLaWxc6I1bLBMcc9ZUaDMRl36jaxepxHkkRUgxbZc4ORsAcr45WULuls0S3AU6FPxpKCp7fTP+1nP/pD+LFiX24QRjy2jSFa4i/cUwqHmUjNkJ/W6qdFJhQV6owauX6ipDZxUWoi3hLQ9L
 BGO0TqNQ
 el2ryAtdOgek6qxI/fs0YTcOjL7W0WML45BVlriil7963u5b/NsUyEGgS5M7hgOVZOiBECqpqsnmJBMlTyYDAeYHtXBfEQItmw6P6Grc8Ec5beaYFBFd0DAw/JZVTUjGEN50BEu6aR6YAeYIR1SCffnaQ1QErZvD/WhoyJPHUslYTiSkpsfXKnCPBbRB+QisQKi/XS2S32M0p4jL1j8A/fwc9xolzd2A6c2vDH+WgxYfc7sl3rVoK11P2eexgyvPYlhazmQdzuJTbZeU/rbOjJGD0vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 02:44:02PM +0100, Vlastimil Babka wrote:
> On 2/26/26 14:39, Shakeel Butt wrote:
> > On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> >> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> >> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> >> than nr_bytes.
> >> 
> >> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> > 
> > Thanks for the fix.
> > 
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> What are the user-visible effects of the bug?

The user-visible impact is that the NR_SLAB_RECLAIMABLE_B and
NR_SLAB_UNRECLAIMABLE_B stats can end up being incorrect.

For example, if a user allocates a 6144-byte object, then before this fix
refill_obj_stock() calls mod_objcg_mlstate(..., nr_bytes=2048), even though it
should account for 6144 bytes (i.e., nr_acct).

When the user later frees the same object with kfree(), refill_obj_stock() calls
mod_objcg_mlstate(..., nr_bytes=6144). This ends up adding 6144 to the stats,
but it should be applying -6144 (i.e., nr_acct) since the object is being
freed.

-- 
Thanks,
Hao

