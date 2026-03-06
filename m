Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F3BF0182B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8D96B0092; Fri,  6 Mar 2026 07:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2964C6B0095; Fri,  6 Mar 2026 07:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF9C6B0096; Fri,  6 Mar 2026 07:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA036B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:00:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEF4159449
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:00:23 +0000 (UTC)
X-FDA: 84515495526.13.7EFEAC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 276FD1A0012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:00:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M1ANHXAr;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772798422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnWOE+XZBpUSqf2xhU4RSOY7Gql70gbc8lLkBnZiWgg=;
	b=6B1XalUBY3PTTfE7Dw+R3n3Mb3uyfwzrCmpfBVjlPAxZJV5u8fXpQeR9bEh7BTYHI7hiXY
	0hew0kW+fZqqPNs6ywBzqznkvNAh7ZAvgm35FrNra4EBuKd8dVidZiaMbd5zifrABDHaNY
	8jdzx/7eQLc6DRinJmS9f7pTCtE4ZWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772798422; a=rsa-sha256;
	cv=none;
	b=rWtJcETic/H83n/CaAAzq3M2GUmuzBIDLIDWJP6MkgftaVpbQOQbefL38hMv07H3vezUML
	twHckNzdDKMFFc9HHS/q4KS0E6XJ80pXndrRhIoYKaWxAFX6oxGkSwOBoLpzEBOF1054O/
	KD4rKHpsUIscEd54ORWtJ8jSf5XgRA0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M1ANHXAr;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A073660130;
	Fri,  6 Mar 2026 12:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C275EC4CEF7;
	Fri,  6 Mar 2026 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772798421;
	bh=sZnQlxpGWa7kZTMgWVtzvZw/bOt/U7meNE4gmvLg9qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M1ANHXArxO2sQq5tNNQ1rLi17V4s4Vnm+e+xwA3n0uiVKuz0nGt5FAxK+anO9p96L
	 lk/4mH57iTuTPtNn/OEbxy2N0xTkXgGdHcgEAmasXaemklUHMdLuElF1SDklbyOFrA
	 DJHA7MgtTv0qSXhQzIpcxINi18SjxddDoIimt1PgXWd66ZxAT5+qOu5PduyQapz7Pj
	 Ty0B0UK7bIdxge6zeF+kna1/vc4uAHzWNu/VsdhhZqelnheUCEBI7+VE7l+9gffhML
	 MaQr8kBTDaBE4wQAEFp4jUaVPip+NyEfOKi7dbskvb6l3Zao0ccIKBZJsWEzvZS0Fc
	 lBJanlZagz4Og==
Date: Fri, 6 Mar 2026 12:00:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Linus Walleij <linusw@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
Message-ID: <12c53268-b5a4-4725-b376-b7795bc4057c@lucifer.local>
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 276FD1A0012
X-Stat-Signature: 3awqpd5yjatttw1fjemhtf53n6d9ixxg
X-HE-Tag: 1772798422-529184
X-HE-Meta: U2FsdGVkX1/OCLXWqYI2IB0rQ4TmzRsotOSD5knsjtjXGsEKHbw8817bwWVk08JK4XhAk5Lu/kmCgtEXU/YDo0xwIvjlf3ZXcw3QG2tYj2l1GPa1jroNOIRFixYhtAxgRGw+B8ij1MGp1Kx0J1GcnyUN/1LuHUJFLU2E8M+I95K8GZioSkqW16P9I0MEKPpbuAiyHQtlc+pOY/ywoHtWjwPNXVUAr9X0LW3is7E6QtgfuHkSdJezRHS6brTomVdn7KCBHBOK1lZlx1RFSExJvJiz+GqQUeb6ga9AgcvJXVy88LDHs2zv3+Fi0pM/lqCHpiys0WOZNZI1pRnQC1Z2bE8e6mKtCqX4Z2OSFamlZaNpKUQzqh2WnEXgU0wLGUlr7jKrKery9OymT+e6g/PEiBETPgTsHSD6kSYgt29Z9AFJHuojLCOGce4L2c9oMfEJJj+Emr4tFrdAjOMuaUM7iBAm86AFbNYMsYAdLui9L016qnhqn1KGbdMT12MUCVfflswyC7nYZ6xyI2dy6BCxdB3ZmYJjEgYrdOQbdxM3Eo7s1lKwQHIMlDg3uVsPgBJQLpFgYZzLLU4TBD0j93ee/p7oWdjQGiALSVRux6WM+KvIAX1LaDmbc0eQ5diPg/+1GBF4xw064B6VRyMRyp3XKM82NeBfLHK0RJRDX0LsHMZMOaJpQoCPjn7pGVH02ciszpzfsXhA+r/3Cd94vxfhYvvfrAbRmTia+3V2J9cDvI6X9lHO1thIbFrGCcHHViDujwHV06X2cnsLJ8xSixXR7B55VNL5QPviRVC5AtqozTtG5fvAOrUJbDjIY5kvh7QBYSjiGSFRxrih7HCryLTzzKaKvgY5s71MyQY/MJxAmJcrz62rclasY1gZEV2NPfCfhWE+pP3F5EaSURkpUID2elo3bCsrafOUpdp+vMYE2DMrGjasLsxMNchq2dVKMYYVJ+362YjFbAbfAwyTkzh
 WHPzb0QC
 T9X35nPupeWBTxFEqXSf/tK5g4S1ZB3GXY+FvFcDi1KNKQefQdyv3OTlCwkNZs7KW9CgfPZ6YSwLoOaCHbC6RCqWcUGFpttNW1E+7QepllvIoL57pBXTr4lwsopoDWkI3allUnn9zd2o4ZDTF05EWOXeMaiU1+YyZ2WqKUnguk8ybJ3NrdaYiZg2CpVpRXD+XBUPvte67brWO++EG9ZCR9pqQWcr8m9TNtvIhl/oBvYXkYVf8QAGJF2KsVNPjx9YjVPBJ61EgyBD+tDWc/S1S08faPeOZHjxZwUH55U2CEJ0xxN163pbiFm9DT5ZRVDgLKv6I/SgwvS0xnCGEYBUfDvd5eqng6zXeiDSwHP6y2W+b7VJ0BowgGbppfG12zLG3J1QRhAwgYYosvQGpgCPAUw+Azg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:26:32AM +0100, Linus Walleij wrote:
> After the introduction of clear_pages() we exploit the
> fact that the process vm_area is allocated in contiguous
> pages to just clear them all in one swift operation.
>
> Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
> Link: https://lore.kernel.org/linux-mm/dpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3@2bnjjavjrepe/
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/20240311164638.2015063-7-pasha.tatashin@soleen.com
> Signed-off-by: Linus Walleij <linusw@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e832da9d15a4..88d78ccef245 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		stack = kasan_reset_tag(vm_area->addr);
>
>  		/* Clear stale pointers from reused stack. */
> -		memset(stack, 0, THREAD_SIZE);
> +		clear_pages(vm_area->addr, vm_area->nr_pages);
>
>  		tsk->stack_vm_area = vm_area;
>  		tsk->stack = stack;
>
> ---
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> change-id: 20260224-mm-fork-clear-pages-ae7c52d12a93
>
> Best regards,
> --
> Linus Walleij <linusw@kernel.org>
>
>

