Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EC9606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=qWvyQKeQ
Received: by kanga.kvack.org (Postfix)
	id BE3376B05B2; Thu, 26 Nov 2026 14:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C7D6B05B3; Thu, 26 Nov 2026 14:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33B76B05B4; Thu, 26 Nov 2026 14:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81EC36B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:35:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164C51A04C5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:35:04 +0000 (UTC)
X-FDA: 85478273328.22.41E7555
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8B90C000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:34:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795721687;
	b=4YWpUNTgipehWJdmjr1PJVJCmQAnq6INoXZYJTSOe76yW+z7ED3UhQtlGeymV+yU/3hcYv
	wPfr3Oi0SOtkKZxg2MCZlTiFyYPO0dSGVISAoHlY/9XtuSKKCz7winGAXzsmejQrtM/IiT
	UggmWWOIchfh4GCzY4K2pUuz+J/MWQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795721687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcH6oOCLJBBWhqHrt9WVxq1zAIk+ultz0SBaXp1cDE4=;
	b=rtJXHL0j35xCWEOcLdetLM8P+w9ysLSNHBCF4GAvUQGYVRaiQesMSlAnb+/34Trc94HlNu
	AonSC//xJE7ZnbiZ5zpfWODe7NQJ18nc2djCbNbT5dSVIMkbEyiZqvPWBrWM8o15YSI9jH
	+ZeYDMA1xjXbqBXSF7i+kYtSyXp3WQY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qWvyQKeQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CcH6oOCLJBBWhqHrt9WVxq1zAIk+ultz0SBaXp1cDE4=; b=qWvyQKeQwbC/z1BY2GkLz0UzOD
	XegLn6T94yjcn2nVjUdWRaaleQjLq1RjmxthJWdvlonwNaGWtM/NlFaCfIf3PshccI/ejRHJ+5K7Q
	zgp/wX2KR/OGQpPRIZPoj0A2rCRY04RxqlCzcWekLcUSyGLdu2etxwu5ZtT/TWshE9UvBu4D6c4Q9
	+uAI0Th7ZElX6+eO9BNVIl9Lp14WC/FOnZ9aILkUAOaZ0ajIysojz2zDaD6tQEXBv7hLLLb4gTlRJ
	LWjiQjH1F5FX5RJUAt4QSIqMy+u3pby41I0dX7mWeqPmf3x9fZ9YeJpPC19Ts1zmD7pq7pTyVnFC5
	GydaSJzQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWfEr-0000000ELfa-2nqt;
	Thu, 26 Nov 2026 19:34:37 +0000
Date: Thu, 26 Nov 2026 14:34:30 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Amir Goldstein <amir73il@gmail.com>, Casey Schaufler <casey@schaufler-ca.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Eric Dumazet <edumazet@kernel.org>, 
	maple-tree@lists.infradead.org
Subject: Re: [PATCH slab/for-next v2 02/14] lib/maple_tree: specify
 SLAB_MAY_ACCOUNT for maple_node cache
Message-ID: <baf4kjajb6c6xndnmizgp7uujbleuiuzcv77z3nvn7mpgidls4@rruuv76wtgdq>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
 <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-2-7c680f02a734@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-2-7c680f02a734@kernel.org>
X-HE-Tag: 1795721686-762920
X-HE-Meta: U2FsdGVkX1+76hPXeRKzOFpg6MA1T3VmVwj8l8f6L7ZNU26e1LP8AMZL49s5L74GbAcSEUkRxTBjlsn1rTwnHC0nPXoSvv+WaV8FWC4yQFwJ8hn3qhC5x1r3IIdMLp2cf55CGaX2nWJFC6gpptkux5gKP1Fo41wDKzbCWBWyHM9JHn2UF7/rH0Eaqd+a2vtz8dXVXzjpEVQRy8r+6scplD+XMMR4Mgwz/DmV3Y7H2B3avFF0x/odkSYwCST52isyOMAD/DKfMzqK1YiVZPKifC3KzRnGMgzvBxsXoYY0BhmgGzrg0daEsf5HqfSle9pfUScp8xusGPt3DKh6wnMW4cda5+GRnhgYoLeykQxOQQUlRHM/s+MUMWoJGJb47TUELpOP/iXPY+/kPQY0MM1MpEt0BrRVPB32sntplVzXR1Ghbq0JjjqC1UVTqV7GoGaADjV6JOh50qnJwQpwp+vRyeV0pSsbXAZjRoarEDj6a7rKA1wXszYCNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/25 09:37PM, Harry Yoo (Meta) wrote:
> Maple tree users can pass accounted gfp flags down to node allocations
> (e.g. arm64 KVM's smccc_filter uses GFP_KERNEL_ACCOUNT). Specify
> SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.
> 
> Path: mtree_insert_range(GFP_KERNEL_ACCOUNT) -> mas_nomem()
>   -> mas_alloc_nodes() -> kmem_cache_alloc(maple_node_cache)
> 
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andrew Ballance <andrewjballance@gmail.com>
> Cc: maple-tree@lists.infradead.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  lib/maple_tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index f7f51f1b40d9..5ff176f1a021 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5815,7 +5815,7 @@ void __init maple_tree_init(void)
>  
>  	maple_node_cache = kmem_cache_create("maple_node",
>  			sizeof(struct maple_node), &args,
> -			SLAB_PANIC);
> +			SLAB_PANIC | SLAB_MAY_ACCOUNT);
>  }
>  
>  /**
> 
> -- 
> 2.54.0
> 

