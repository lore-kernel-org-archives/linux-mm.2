Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A1F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qc/c94To
Received: by kanga.kvack.org (Postfix)
	id ED2D26B05B3; Thu, 26 Nov 2026 09:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83FB6B05B8; Thu, 26 Nov 2026 09:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99076B05B9; Thu, 26 Nov 2026 09:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6EFD6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:22:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0040FC0484
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:22:14 +0000 (UTC)
X-FDA: 85477485030.17.F179227
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5D21C80002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:22:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qc/c94To";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795702933;
	b=TC2kb0n/zaLdZpLkPpOo28F5Puc4NX30vnha4nCukAHeSlT0EWoDgDD76CzHe2xwROA1aK
	K8lnyshbucnFV+JUBHTMxTGD87nKdmoHjoyfzruG1OixpVo++v0QV6NXrD2sPe+MOiiSB7
	OPkUt6gFerbhc9qQz/loyPl6ykdK/xw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795702933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTNZD+C+JP9EsvqOZ/gFA821fXkXQWgJjDmWwsH0f1M=;
	b=L37XJmPh101wFyjiUFkuFNSmc8/P4L0wDHiotRdueTbE6SBSikXll0QNNnr6SaY2/CrKEq
	xVj40I8X88z5EuX7tsApDagO+qEz+yNueu5k9GVZdC4cg83MaVwtIiAF2P/hndK6QmaOev
	r4LWKC0Ung9fq4kNiZ6jJxufltHFqbE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qc/c94To";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 893C046096;
	Thu, 26 Nov 2026 14:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D780E1F000C0;
	Thu, 26 Nov 2026 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795702932;
	bh=KTNZD+C+JP9EsvqOZ/gFA821fXkXQWgJjDmWwsH0f1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qc/c94TovmFQ5bTftQRsaRCNS2h5YrVVa4k4mgUnRsYuhxlkxha7yCFnO58CjPiRh
	 FrXtjcd9N15R285sJqrpDxBXL0XtPu7HUF8+1HCzwAJOas5okHWT2gY+C00KqrN7As
	 imcMlTuwq1UK8v+I3hothENHuEDx31a9Q2eVuS+6kTrcvldPojIpYeXMmRTw54vAyB
	 pgpvdWvbxpkh86D8/Rcfal3iI5k1pnFOQCZ6tf5fFKxOIV+e0bO07IBtNq3VeYBnYT
	 fcde8WCtC6qqB1FupFXqG18wzejg3gk/THHw/RIZ8/q/6/M5bcYBVqZ1JyAfY3AgCS
	 +zLRRjl7m+rJg==
Date: Thu, 26 Nov 2026 14:22:10 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>
Subject: Re: [PATCH 2/3] mm/slab: add own entry points for
 kmem_buckets_alloc() family
Message-ID: <awg-2hrOmY5U3vzS@thinkstation>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
 <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D21C80002
X-Stat-Signature: x5gk7c81ohqtorrr466hm1b1bgnfhith
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795702933-394666
X-HE-Meta: U2FsdGVkX1+eYF1ZrE8Ft3ln6U4Az1GLjQwsOpNC3bKnwH8ChN/I076EFwTJ58SDDdRihWFNz/ioF/No8yyXcP/+YSfxP5+xFiOeIsMybWDGbxYeAUyyjmUCnKgS2wnZ/xFvx7PuqKUrXm110/Nif8G6xDI5HF0OG2dRW+eCYi85BqSzJzxf7d8MmSkWPnYUj/T42o3dmikJjGvFAfPo72C2Tem5/plqJaHwq90ZIjjGSvMhXxVNrhrTWkcXUUi+G+5L/accY+VuQFqzwey9LzOe9cHoDCkepVulD9EFARzl84sFsTGqFEmQQeLtjjYDNM+lRlTGAZyY97CGnDLBk7dIu7BDE263AqMs2uMXS956mygAueN81Uft7RzD5TNyTexvlNv5JqGIuvz/DpsRZVMP/Thhk2f7cqW+b9rpOj2JLPMY+zqVHTbf/7qi2QPePaIP4/H3vDVhiQQdxmXg93Fw/spo5WZfIL4zP7uKhICWPuyBl76JrZQ92liJAyfW5TjXViJVkuUrCxbooOFNDgur4OdmeVDOip/663+PMTqtEsA0sLMntqih1kzJn876hy33ROqPopLaho5j6uWfMMdrwhrugrhfUpod8+tjpPGkrZHjjcRHK9O/m+zlAtm3COQWTwPwf5faiGSbMxn2nUbIbEMocoNeb/IxwYozvCgLHSNB7Fj4EwQEa31rPDHILbTLswDnOZ3904oaU1uQSTlHNg3QPIdJ42+dACSK7ER5YNa+/pHBrTuh45WcCtGDo+P07QTnV26GBH3kwl7Iw5YY5oWy/KFQhydK5eZtDd1PgWvg6dA2tURTIcJZoZsYmbhttvyN+qbN1eNy+aoJbA5VuTAphTeA64x8CX8oBcd87TNmp3Py8COQc9GUdSusLjhQwHBkjTobpkTd/0kQ8aBuLkYzQRCKsJFciQPaWAsLngQYGIi3zI+MeaXGw/Axp2HmERjl+KP9R0Dl1UC
 SaC/+eW/
 e8sV7VFAInzaiMWRkYtDNS0SFvypWLFj2h9g3HPzJcdvHxM7pESybM5AVqBnFCBSaGHEbmlHvCF9a6jXyhSvHsT7qkLG+vxF1mkjSdjMHM20IYNDAtUxb0lKX8pRSSueXGLKnHKEIBxvVdIdMYH9j0ziA3JyQwfbeh9fIn7J0faC0G8Sk1kSDxFcL04d1doNK2LJWaEB1Ks/bsHe5vm2Z59cKc3fLf+wrGgh1RmCX2nkzZjpxYFZslReKYpbqd+WfIZC5FUPBhq7X7MdTJLvtKaMxE3VeBX6KJ6EH9pO5ZWbIfubqC9Gyt4LEC8TJS4iS6MgxoUPZvpAMcy3lPwNf4DMqIDVgabChM5grTXMA2jjW7jL+AeROKwxSD4FPbsrL6Uo9Raeg4oLh24Tw64ZqpK77mDswpWrhXeq4Oz0CH2998HUsiO/9ZMFUtiLfLs0kCZVJqKPTeLp3VwUIhwIFQ238bfyAtn+T1YgR3Q1M1TXE8ibIykkIlvzZTiS8yb7pHhkgx5dcuMSCzlJCq/utbzfhVShLTpeZcOoxW0f0hawJ46E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 05:30:03PM +0100, Vlastimil Babka (SUSE) wrote:
> The way buckets have been implemented was to extend
> __kmalloc_node_noprof() and two more functions with the kmem_buckets
> pointer parameter, which means all kmalloc_node() callers now have to
> pass NULL. To avoid this extra parameter with CONFIG_SLAB_BUCKETS=n,
> we added macros for parameter declaring and passing.
> 
> This can be avoided by creating own entry points for kmem_buckets
> allocations and not using the kmalloc ones. They all end up performing
> __do_kmalloc_node() internally.
> 
> Since it's just 3 functions with few callers, do not try to do anything
> special to eliminate code with CONFIG_SLAB_BUCKETS=n. Only make sure the
> bucket parameter is changed to NULL in that case because it would be
> ZERO_SIZE_PTR otherwise.
> 
> The removal of the now-unnecessary parameter macros is done separately
> next.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/slab.h |  16 +++++++--
>  mm/slub.c            | 100 +++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 94 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 70df0a2e3876..6674caabbb6e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5732,6 +5732,34 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
>  	}
>  }
>  
> +void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
> +{
> +	const struct slab_alloc_context ac = {
> +		.caller_addr = _RET_IP_,
> +		.orig_size = size,
> +		.alloc_flags = SLAB_ALLOC_DEFAULT,
> +	};
> +
> +	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
> +		b = NULL;
> +
> +	return __do_kmalloc_node(b, flags, NUMA_NO_NODE, (kmalloc_token_t){}, &ac);

No type-based or random kmalloc partitioning w/o SLAB_BUCKETS?

-- 
Cheers,
Harry / Hyeonggon

