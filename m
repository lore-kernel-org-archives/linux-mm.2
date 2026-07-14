Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA969C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59F36B0095; Tue, 14 Jul 2026 06:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C332F6B0096; Tue, 14 Jul 2026 06:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A536B0098; Tue, 14 Jul 2026 06:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87BE66B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:54:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB1401A035C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:54:23 +0000 (UTC)
X-FDA: 84987073206.04.AD0BE8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F1AF12000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:54:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHm1Td1r;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026462;
	b=gqyq+DJBaGDDKBpDZosa7VXEipJdO7m1NXwaiQZfrn+X8AI6QFACDY6IvFquazZeUPl0b2
	KxZUHx/EMT2aVG4L7eLD5iyV1dAtf071umk+XHh+/bxgTZi3S/gHyhmJFrgfAz5D7g7rcl
	uJk1FuXY39CE9cdk/25mEhFQVKaoBwA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHm1Td1r;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMpVtaWlfMhMEV83r6KXcc/9zGUoXbNewrSrXtzotb4=;
	b=x83nGN9WjFhl53Zq4iQUASOBwvMRnQoiNXFxIuydfpTw3VOCTI0u8stkrQ/GniWJ6Z3aKj
	rIGd0UgC25sXhbVxFKLII0UeBUKKn3AI4e63obRtj/Ns2gaPhzF25Rer6DKaLs5Jh0KGO2
	rARkRKfsF6FYdOv/BLFgZyP6yo7iy2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7CCC60120;
	Tue, 14 Jul 2026 10:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A21F000E9;
	Tue, 14 Jul 2026 10:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784026461;
	bh=wMpVtaWlfMhMEV83r6KXcc/9zGUoXbNewrSrXtzotb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nHm1Td1rOz2dbi5zyg/MSbrv/ONV7kCR0SkN8ZJQLOqydK7XNUIMxK/k+oPpZZEup
	 LZ1FEgRVzVPUZsqiDS0qpDbDLD00YbqsWFg6KPelmOQhM31b0RIS1tfZjWZq179cue
	 Bk89rn7RJ9mqAcoMWsUqfrvq5qXbH9ljv1tU+WQkKVrXXPd77La3ul4nCzAGb8wrn4
	 ECOWIXRlDDcTgbCocjNxrt2XpLE0Y8keeyUZT214Evi+0ghlPoD7jATa8ZyY4RSnf0
	 p0lQyHlzfOTkLXfl2HC1Bk6vSF2WWLDl2rBtDWebP6RAeKM0W5Lu7sGwJop5qkfSAP
	 CAANSqydU4e0Q==
Date: Tue, 14 Jul 2026 11:54:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH v2] mm: huge_memory: Fix kobject cleanup in
 thpsize_create error
Message-ID: <alYU423yLkWZlO6a@lucifer>
References: <20260713054154.120915-1-zenghongling@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713054154.120915-1-zenghongling@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F1AF12000D
X-Stat-Signature: rbqumjnehbgyb5zxtnjp44hz3nyg5ypa
X-HE-Tag: 1784026462-633967
X-HE-Meta: U2FsdGVkX192oEksjEYZznMHdpUVErcw0D8uC4TH6a+Tm1SJuu6nzblTlTynrE4caph1CRwKYZF+53fMA5J9LEEGDPuEUKoCtKL8+wyozveHpJwsS4cAcU9XVqpafCSWeLzO3Q+uICILhmbdGAGzTXGAb9fya0xZ2aFLRJUYolR6bynvpTPDPaNwP7gFZ0qqj9o7MPg/KH8jcwYI6hYBMO3sC4arvDqYhCxwydhvWYxIbnBAM7MvRSBh3ILJ8NreDb/H3NmzqmXnW26+WObYsYKjlnrB8bwasm/pWrbuJYgRe1WRP/vnH2+3RU4S+xFG6zqE8J+rF7JJDKHAAOWgUWAMDnDXI4hCgwl97ub/4ydO3OyJF+KoFvzSjAigTbx9q7rXS1v98lc6MadoMNF4u3rECWoNAD8cgoXJAtAMOnxlNkGvmOgZBX9ctfpKkJ0QIfsNlPJabS+rD7KMecXxtklUxDG+7cQVmOoX030t6/y8Lxr53v9Had8xKmXkEcb/kDpCdPN7QDw6LxI7q2RchDfJROi6L47xjdpmwW6zsG1djwqjPR8Vtu/MZxM8EqgXVAbHZa7n6XlNINMFV1S1PEftKmTpJh+dh6p38Jer2kVsHGBX8Rz47zICR85F1AWPkB/g644a/jxA4u1eUhrvFilM42R4hYhcgwmYXHxJWG9UvfqefIj1ldJe/WQcYx10hS58fuR5l9LveT8S5ooSizwf5LKHmchcLFNpiSzN2jheegYgmS48tbeWU+mz9hguDVGUHgrjoZmmc1wJRKjn6i/fR2v7nXXuwty5FauLz6O1Ntg0L4d41SJ6+ivjrIMBSkY4WlV9PG32GJNdz3Ni+nO8I3kTYGXqQ+utfO3pxMlIJCBRsEBw/hECeCG11HNWf70NQ8dYdDpXTqL5qUEuecoGz68+EBpS276vfycT0mgC7A0uT3is+LBitzTxa9h7iRP4iqYh+uNt+Bs4T7y
 oFzmpXI3
 kgDUVoD6f3TAEbUXHb+CqtWEE1zMnRZZ9RDyS50d1kRFRknrlfEGp0CBOkq2ygJkpQOKU8z6h+7n7KMnNwlP1glXL/HWDX5Rbx23tKnfYWI1mEqZiexYlBboFFyJw5+AxRZ8eS+q+S2PHsuGnStB+zYRPzw5m/ABKT05NIkKN2JzMmuKcD0JB8fvS3RRdXv3AnSw048Mmhw/r6/tUMjHaEX/ixrlvWBzJ0uvx+rKnYIzjSR4jwMgLKLwa8CO6C9Y1i+rL2ulV6zNnZl3t+zGO8Z+8eqe7n4PWMoFifaxjksWhLw/nH2c05c056bNJDYMJ+mK5LEkSjGMg17vskppv/qqmnM4dkRyaTTapmaaFcPu+8z+F5wD9XRF0ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 01:41:54PM +0800, Hongling Zeng wrote:
> When kobject_init_and_add() fails, the kobject API requires calling
> kobject_put() to properly clean up the memory, not direct kfree().
>
> According to the kobject API documentation, kobject_init_and_add()
> calls kobject_init() internally. If the subsequent kobject_add()
> fails, the kobject has still been initialized and must be cleaned up
> via the reference count mechanism (kobject_put), not direct kfree().
>
> Direct kfree() leaves the kobject's internal state (including the
> reference count and kset membership) uncleaned, which can cause:
>  - Memory leaks of kobject internal structures
>  - Potential use-after-free if there are pending references
>  - Inconsistent state with the rest of the error handling code
>
> This fix matches the pattern used elsewhere in the kernel and in the
> same function (err_put label) which correctly uses kobject_put().
>
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> ---
>  Change in v2:
>  - Use goto err_put instead of kobject_put() + goto err for consistency
>  - Add suggested
> ---
>  mm/huge_memory.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..589f7bf1f19d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -818,10 +818,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>
>  	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>  				   "hugepages-%lukB", size);
> -	if (ret) {
> -		kfree(thpsize);
> -		goto err;
> -	}
> +	if (ret)
> +		goto err_put;
>
>
>  	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
> --
> 2.25.1
>

Cheers, Lorenzo

