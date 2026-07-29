Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08168C54FD4
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 20:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE4C6B0088; Wed, 29 Jul 2026 16:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F306B008A; Wed, 29 Jul 2026 16:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DE26B008C; Wed, 29 Jul 2026 16:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3856B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:27:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 801A5160617
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:27:50 +0000 (UTC)
X-FDA: 85042950300.29.75896CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59602100006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:27:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pmxruMJ1;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785356868;
	b=Iv4fNVDc5AKYXTi/AujDe+lD2jNS6RfOB/AIuN1syvAdwQl9nnZOaQ7vEGWeomC5wxrjzY
	VG1bq5G7t88mGxFwT5vGmXGfV7nsDhCzMg7N4G/VTfYKGjKE45l4POwxLJaJfw1P8+QRue
	+DmSPw0jmEX7P7/3Hh+aHSg8Z59gueI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pmxruMJ1;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785356868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppvXWw17La6VOhnrUygWlQUgfnpDHFiES+LHiGhQI9o=;
	b=Fn8MvCZZoCNel8ZX1V+64mnDgvMmNh9ZslffmO6m8U8O5kSNs1hcYZriruRgzFudL9dp4z
	xbfaD4NBMpoBk5nZ0hg8J6g8WmUtyl5vgOWsvJ8WC1tdAaAYQ8JduO5yF7nuDrQW9lhiHF
	/kOGb4PcDfoT5VDNynTDwv9Ix5NGDMQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D2A240A83;
	Wed, 29 Jul 2026 20:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E271F000E9;
	Wed, 29 Jul 2026 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785356866;
	bh=ppvXWw17La6VOhnrUygWlQUgfnpDHFiES+LHiGhQI9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pmxruMJ1yZLHx156OsbBp5gSVtDIshq8dIJXFa0BYpRSUQMI0R9ZN9xgqRInVpm+M
	 blUfS8rXikZOjCy7G6aFkQwC8FOE4J6NolSJaMupWS+16a0l/XZNdel0ZvkErIJ22V
	 H3EHiCuOk7dtzRJDq9pAccwcW/qReTxBpkmPW3VE=
Date: Wed, 29 Jul 2026 13:27:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mm_init: remove unnecessary initialization of
 pgdat->per_cpu_nodestats
Message-Id: <20260729132745.9d42a13e614be2e18c5988ba@linux-foundation.org>
In-Reply-To: <20260729155143.177790-1-ekffu200098@gmail.com>
References: <20260729155143.177790-1-ekffu200098@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59602100006
X-Stat-Signature: eq4dt8wzkkqad9e5em1k6ckgat57abm8
X-Rspam-User: 
X-HE-Tag: 1785356868-430274
X-HE-Meta: U2FsdGVkX1+H5wTtLEeXJD1eDQl54SF7RWzH5C50c4oDZYggI+iIFM733JSpKoFB1+9u04HCfOqf4hCDgdti2WyOyHT64L/kt3M6EP0UOTzJ5VrsdF4wKmVN30yR0Hyx5zgKQgd47XNuKliii7Hq4GzEK8tJ82z4oQZ90TZXL77t8FLXgNwvntKAR0JPNtb/N2I9Z2P1866Ht0l3YlnGr7vDScKZg9ewIt/KLSZJdVCTUeQLi3JtnpSA4Vp1BBINdTZrJ0N8edT72V4hrNMB/C5YJRLLEknvE2DGVzv3KFLTxGbrv3NbSLgQfB4035vG6HWfB3arQWq5GiPCkOPJILvCqYxNhu/6QOPpL+SBzecwGF3yoLlSTIK9nkctJKdJotvs0ZD7mkYvA99YdI2E0GuB3bBcJwpLwxXob583t3pyV7GH4YDK7dfUvJK17yH1oVVOJJOrI2AUWP9NLnjF+16JamLHOfIO0HWVJDvoABX6Mk0KYVNQEZac4CLVDwXgOX1Om/fmwPvP5DZhH9D65c7gmopELbMXXUmvBvynWpNOKjxgAobWS96BFH/upDedDS6ig2c4fv1EXB0yDgSNYpFmBFkfjq3rwjNXDb+aEyirfYjhTnPYJqia7Nz4YXh7hwu4fSZE9ARcJqAIZ81glIhKZ2N55OWrVvdahA6QrJkj5y+2jCznaiyMJuaSDDZ+zwWTiyzCFNCh7oBdrxPTZnmmvFvLzQQB6JOFTKAi4LS/cDHsVuhGTFPxjR+9x02rbhSw/p+d6+0iNA5r8zA3Ei8q2HV2xwTR0hK4+PNUIy3vZF7SfpAN50qNjEnYLvP+4e9TVqfX2BgN+bhWQYky/wyWNrMhg2Bpzgw67G3fvndleL+6sKP9x1Tdi+VYfA5f4yp5WVZQB2/He6mhJfl4Pa15pajHdcd25CXeT5MixA/Du7VydmB4xIq6kZrzxrwB3C67DDP87XpMSOrdl/V
 MRep2x4t
 xSHW62n9ZGtbU+/5XMVUjX1YOCJgiwS8P9jnVL4+DvZiNrQJ71YSkEjHhIebz5zD7xAGCONX0RAQRn1P3bXWyboeRgGOOyYomv5pAFykvEWFSslzbPFF6w+P/TUM/IIB2Rs6w6X/WRZLTi8/zr5T1SFRxp2plGR85qPJE8CaxSffM9ranYbTnHswDk8sPOT5PLM/eY+aeyVUtdvie2QwjW9bRzk9cFPZJJJrxZrQmA6tMzb4Yey0ppQDCc96OpQ43Cv6ZNYk7ehDkfzusHRddvhj/BVnT4SK8Rwfqel1/oNJclgG2ibeA/cxDVjijQHXECq+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 00:51:15 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> free_area_init_node() sets pgdat->per_cpu_nodestats to NULL and later
> calls free_area_init_core(), which unconditionally overwrites it with
> &boot_nodestats. Nothing reads the field in between, so the store has
> no effect.
> 
> Remove unnecessary initialization. No functional change.
> 
> ...
>
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1722,7 +1722,6 @@ static void __init free_area_init_node(int nid)
>  
>  	pgdat->node_id = nid;
>  	pgdat->node_start_pfn = start_pfn;
> -	pgdat->per_cpu_nodestats = NULL;
>  
>  	if (start_pfn != end_pfn) {
>  		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,

Looks OK, thanks.  Although this statement is "free" in __init code and
its removal does make the code that bit harder to follow.

Possibly *pgdat was zeroed out anyway, I got bored figuring that out. 
The memblock_alloc_range_nid() kerneldoc is silent on the state of the
returned memory but I spy a kzalloc_node() in there.

