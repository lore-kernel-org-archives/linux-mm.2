Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E803E937F6
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 18:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897B36B0088; Sun, 12 Apr 2026 14:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848D56B0089; Sun, 12 Apr 2026 14:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E836B0092; Sun, 12 Apr 2026 14:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 680566B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:35:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF811E3CC6
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:35:27 +0000 (UTC)
X-FDA: 84650756694.27.88CF651
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6134BA0015
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:35:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H8c866ev;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776018926; a=rsa-sha256;
	cv=none;
	b=e53xPZU1ZpQooDuqWXB+TI/cNpiQzOsZUjQRWF16xqNN4ZFcBJKK26dYVD8LHMsAiqdP3G
	JQZIq9DN83WlP8+FsvWE1HoPnLnPPR8Hyk5NojSTQXN612yntmnsEhPVv4YWbfK/LzZBqk
	S6QjevYq4PljQum66q2hh9VJexICO9Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776018926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoVnTwC7HXWJwY87QdqZmPoSnrvy+FHS+UHSZGtHS5s=;
	b=w53h6GLSDVZLVhLmAhaNHhre05SdJcZQuajhObfjasfq1VdNYu81+sclH/vg0z+Q8CPqcy
	iDyxzIhINHeAKz6sUWlx1d1yv0oYv9XYEPNkwiVwYuPEuVboony50zCYYyFjrBDzgXKKCU
	E9QJ5lr9PCO86eGbK9iL9VIZTofPLgM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H8c866ev;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B742860172;
	Sun, 12 Apr 2026 18:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A684C19424;
	Sun, 12 Apr 2026 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776018925;
	bh=So/3lxgYie/RFC6n3vqqdr/LETFNhsSstDNNMcIkf3Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H8c866evefI92Se05d+uNHgaZ0YwhuRVksrZmupUBpRLIui9yH3GbIJ4hhcQu5nYr
	 mPvFcAkyOhJSzNKEfb2lopgLsXI1BmMtU8sOHGQFmzRy39y2oXRUzU+uyQ1QKKtCJN
	 tSg4Ux6bB0v29wmUwTQ/DP97TArKYuh8sW1f/6/k=
Date: Sun, 12 Apr 2026 11:35:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: thp: Fix refcount leak in thpsize_create() error
 path
Message-Id: <20260412113518.af50cc58b0ac8635f7e9e086@linux-foundation.org>
In-Reply-To: <20260412175428.2613383-1-lgs201920130244@gmail.com>
References: <20260412175428.2613383-1-lgs201920130244@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6134BA0015
X-Stat-Signature: hssxmzq3cyu5g8j1bn3o96pofgnter8q
X-HE-Tag: 1776018926-2553
X-HE-Meta: U2FsdGVkX18wXulldYJbz7AW6iJe1xOeahw/EEfY4HITj0zDMZHA8jzJVRU+76dhyQD1jGy76Kk9i+pfyuYvTGNO0F6kM+h93tl0U4J0NLy03PtAsBxQ7bVAfgdnSnY8rTYRQCReegnP7iGhT5G1ktFQDI0mNN2m3lMf3OoYGEWwWKB7IouLsUS+7C4jTsAcVvA2j8oxg0Mkteh3XYTCIaxYeA9n/Ko1AWn7Wcu5xaWLw3gnkL4bhyTwdgXs5ZbpSxU5IdeyM+2njBbw2gI8U9Oc6zndIiq9GnF5jScXOT/Wdp+a702txIH4V+JxsIQWKU94ILbdl0mmgCOlavz8+h4NiZ3DrYpuT76z7rL2M6uvFQ1vgtcEYPPR2iibFxrDeIA/VbgMTVR0zhqerutGQTeG6+nfRhI14Y+IMza3n4+HXR4ltd5pbZR7EnfFODvdcYVHW2VxLbl1DIpZ3o9XOVxBjHclTsfNuHZ1s6KvS13OpfoO2NEUOfWXjxd9qN9nrQIsQvpVT+KuxT0T7+IWB9hCyT/scJvOnue+LPDNWzbmCJrFa/1QwjdK0qmN8kqv5V41WVs3p91fNH5pPghPKcOVVYtBBWaXTeXs87FCx9fTnpN0WoowcSkPvzBsM6cswRlFOryFy6G1Ax9rMNnp+/AvmpNUnPQ7kA5nrf/L8fY31vCX3HpzjmjrGX96c4pwbzlxfy7C5rw81W9a3J+U02SjiCCTBuRZJovmdm5/IB3fk3Ea9C8umRmlY/pLfYrtjdsPlMZDAVCL/01DfwbSY4PkVj1zEBKlPKQXOeRcH/2lIw9V2wp67Z5JOfp7SCdx3vht8dOQ7RxNTYA7qzfZ4MwRNydgyrgGLtKuN4MAvJboAHi4UavhCMwIjjNJs47OvQkd6QACvJJgppjYvFd5CBT0r5Jf0pnlOvSOl4ZctvSxW6BS4T2KXhKHLixHDw8a4rH2EGsoqJgKknEK9Er
 wypd0Ja5
 R+ZvUxxN6C3HV/k3zoUXJpS5vq+MiIT4YKRDfo2ccniIdH3cWLYdJfAX4rxD4PtRMeMiAmMLhDDqSw6AWNf2a4TCwpb2xjDSJG0pDhFRr0sXT4pkeu+7tJrjbAQcrKxjfY7QtKpxkqnDsOPKrwUHSkz89saoMCztv2cSnXHsssXLqwPvuhLx74QiZ5yrjS2sNGPnzA6Bj0xfbZYKGFc4ncH0ogIQrznBcD3KkzuW8BeA2EjynNPuQWEBxNdzP428LeBCYQjX4bu7AsFWeIf2E/yVwPYlwFblGJiLZE6NeaSY3FxEBbf2H90YSZCYIuGRXnocQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 01:54:28 +0800 Guangshuo Li <lgs201920130244@gmail.com> wrote:

> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
> 
> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> directly with kfree() rather than releasing the kobject reference with
> kobject_put(). This may leave the reference count of the embedded struct
> kobject unbalanced, resulting in a refcount leak.
> 
> Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> letting thpsize_release() handle the final cleanup.

OK...

> 
> ...
>
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -726,10 +726,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>  
>  	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>  				   "hugepages-%lukB", size);
> -	if (ret) {
> -		kfree(thpsize);
> +	if (ret)
>  		goto err;

So this should be goto err_put?

> -	}
>  
>  
>  	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
> -- 
> 2.43.0

