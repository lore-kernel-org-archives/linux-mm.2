Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7271FD88CB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 22:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950076B0088; Tue, 10 Mar 2026 18:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D45F6B0089; Tue, 10 Mar 2026 18:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF1B6B008A; Tue, 10 Mar 2026 18:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDAD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:59:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13C0C13A89F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:59:19 +0000 (UTC)
X-FDA: 84531671238.30.ADA94B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 39AAC140010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:59:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KxsWv8r2;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773183557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhDOTYiDs2KpPYBkzaSW3VCvGJaNHJSp/UfpAFE3c3o=;
	b=jEIs9WDTG7l31wpf1mSCGKarD+HT2gXpv2sfiXNnwHHoFLqJK/zp3sZZXpm6+qZYhb/J3b
	SE1qhdOifRUKAuv6nK15bXisDXIZNOq79w7FikHf1jL/W6bgimUszKKEehIKn9t5jaHVlC
	DXXgsogwou2BUjHD6vd3byVVazPprb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773183557; a=rsa-sha256;
	cv=none;
	b=yzKGVRooNp0rBNozB86HhnBGtCMB90GmwtTlAf+NB/pzt3g9S8tCYGQC6xO6vXLIfdJaGx
	gI2NJh9Ed2GR1DkLUWMbdE8v1uJozvQ0IPsxRwmZfFILvMD7wxtziphyWDgy/SXw+4zUF0
	idkIc+4nICzbocDjT6h2TGwvpC6ncdQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KxsWv8r2;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10F9F42A7E;
	Tue, 10 Mar 2026 22:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49DDC19423;
	Tue, 10 Mar 2026 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773183555;
	bh=BjqkdCeMdNOKbxIQrGEVaJbY6EsiwMruzUZiA45PG3o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KxsWv8r20VHoztPpkKSLzm6o1hyzAjDLMCFIAjVIRZ+mrKX+t98XMM0JGrfJFILmV
	 itBDuqYDyTdXlI+YE3Z9KphQ8sOPA5hUOFG+dgq/SxKylpZKcvR8Jxhet9ZoHu1A+H
	 PEZAzZhIoa5NJI0b70dgfpakeebcNCeLrhQI6bMk=
Date: Tue, 10 Mar 2026 15:59:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Uladzislau Rezki (Sony)"
 <urezki@gmail.com>, linux-mm@kvack.org, Vishal Moola
 <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Message-Id: <20260310155914.9c03a9f4cc2f433fc741e222@linux-foundation.org>
In-Reply-To: <aaXcLRdhq0IyoNIG@tiehlicka>
References: <20260302114740.2668450-1-urezki@gmail.com>
	<20260302114740.2668450-2-urezki@gmail.com>
	<a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
	<aaXcLRdhq0IyoNIG@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39AAC140010
X-Stat-Signature: h1wbeb3oakgyniadwiq8okxhn38ksm5f
X-HE-Tag: 1773183557-351269
X-HE-Meta: U2FsdGVkX1+XafoJb15XuFpS474BDbMU91dvi6vdDSfZZGmog9ccbVmZ9zi/2IpZyWBVhCOY8EBmomv6ZzuaZNV7U7N+QmdMf5ftqkOzIPN03lTzIpeih+5w1anI09gZhwsZ3Em4k5C367OGP2GCi74RDqp9tICQwxPL03rUhhic3PLw2mna5lsYVo2LK6Bs4WaPNjOH/YlEyavF4SNUUKYFI2dT2LbrXXWB5RlIVSYH9xgFxJoAlY9pdXpb3H+5CE8jm63ZMdT6cPVO550Grn2bi3Y/ESwsK0RvFard/+17RJ/CJ3xcjSzIHdi31lqJDoHEwuwEB/ocyrZffEh9Z6jdg+V3TNrINqZGWTLpXDhJOq3Ds0B1gRXEMtnmMZHsT9IZVxJKfLQNuNpSEZMLPbwLsDE4s+jed1FikCbfJTLnteSW/0mJoS7Txlwh1BkUQ9JDGEXRQdSK2gEaNf5ZMXBXovntJwq+8e7Rjgrw8cRvCuFaq2Hfvokc1CWuOrB3VGEvR0KyDFR+nNr7yc8/nOI2ncTaTODmagyrOb4jPXC4P87Wi8sNOH+V3FnDafcIR1cLIwVVomrzQmydSPMSuOsdk3gzt9NwdKCkg2MfKbklkDcpcAX2gChKU9O/CATdOYfuo1PIeArUxawR8/S3lD4JNT5JIzIwYVR1hkbisFmkAdexE1u20KnOZT2J8he89EC7BxTyCqH++CD7lv7UG/n+vUD+N8HXdsLcPSubTZBrXUgjInam4+2/r4a0Y4d4Psz/fniIwUuwSPhxSM/SmhfxYfIt29wb3bxV8CCTZCu+s4LVCfRGodlc8EPur2U3tw8cKYGeqcjmJct/Iv24dZMxQV6yHtPj9gIdfGSPQYhm2iU9ffKV0aOTLcM1wzF6DO0B96kk4sXfK8MuqSoohczixwja8b28aXwHLNUMjUzzPNY+gWkGnF0iy0oZL6ulFjXAtHQv70VK0qYdhxL
 E4M7/NeP
 VDrCVjfd/MEoYfyQ1YZxa2fzt/gXH0I5r12ugscIopyQcR16GO1Fi9T2Y21n3wrXvwQrOQZ+L8zEhIkTasLxKsUmQqCDbRmcvdPDXEqSduWWos/iY3lvo+QbYgLus6GVUBt7io7krP+5Qw6KxFKt7abGfWv4xKapzApUHqC9btF4s4tqhPH/7EUWle9TRf6Dbz7st2Fuh4MaMz/wouYgaf7h5bz/1Oy+idbu8Tx9FB+DC+Hk3Fh5vQLGthjZVj9nLWxl4hgahd6MEM7Pyj75lkIYJdxO6P/9FsNrMTivoSzonD2yA8yzBhdymJGh6NwIHi6xFH304pVbgFzMgO65BVYU2jHtZwBJI8S1dT4xrmpjj2qLl6IXYpHiKVxyaryJCdJe+mzIsift0VYvsFlO3sSg3XT6FXmD1GntmMmdKQ5pafidTEzd8m2s5lJSPLud0fkjCMIZpomM1LJo8MkjkjGxWuoTKwHC708U7LgQ9PFEps+9eL90MUVwwr4i2gqXs1rI8e0PdKAndjfjcpeHFhY3B5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Mar 2026 19:51:25 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > I wouldn't do this because:
> > 
> > 1. it makes the __GFP_RETRY_MAYFAIL allocations unreliable.
> 
> __GFP_RETRY_MAYFAIL doesn't provide any reliability. It just promisses
> to not OOM while trying hard. I believe this implementation doesn't
> break that promise.
> 
> > 2. The comment at memalloc_noreclaim_save says that it may deplete memory 
> > reserves: "This should only be used when the caller guarantees the 
> > allocation will allow more memory to be freed very shortly, i.e. it needs 
> > to allocate some memory in the process of freeing memory, and cannot 
> > reclaim due to potential recursion."
> 
> yes, this allocation clearly doesn't guaratee to free more memory. That
> comment is rather dated. Anyway, the crux is to make sure that the
> allocation is not unbound. The idea behind this decision is that the
> page tables are only a tiny fraction of the resulting memory allocated.
> Moreover this virtually allocated space is recycled so over time there
> should be less and less of page tables allocated as well.
>  
> > I think that the cleanest solution to this problem would be to get rid of 
> > PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO and instead introduce two per-thread 
> > variables "gfp_t set_flags" and "gfp_t clear_flags" and set and clear gfp 
> > flags according to them in the allocator: "gfp = (gfp | 
> > current->set_flags) & ~current->clear_flags";
> 
> We've been through discussions like this one way too many times and the
> conclusion is that, no this will not work. The gfp space we have and
> need to support without rewriting a large part of the kernel is simply
> incompatible with a more sane interface. Yeah, I hate that as well but
> here we are. We need to be creative to keep sensible and not introduce
> even more weirdness to the interface.

Was that an ack?

I'm still sitting on Mikulas's "mm: allow __GFP_RETRY_MAYFAIL in
vmalloc", which has

	Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
	Acked-by: SeongJae Park <sj@kernel.org>
	Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

I'm unsure how to proceed here?

