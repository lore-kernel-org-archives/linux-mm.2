Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0AD606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=grVuyKYj
Received: by kanga.kvack.org (Postfix)
	id ED9556B05B0; Fri, 27 Nov 2026 08:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0F26B05B1; Fri, 27 Nov 2026 08:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6676B05B2; Fri, 27 Nov 2026 08:56:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 780926B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:56:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12B381A02F9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:56:42 +0000 (UTC)
X-FDA: 85481049444.11.C50E623
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DC82C0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:56:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grVuyKYj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795787800;
	b=jgDIh2tv3dH273KBK86SgQLQ6j/GcfEFbhowN6GvmGzBsVm9eRNKDtBEYyvKg72s0GaYjv
	xzJLSqYjdc6a9juXVuKN+QCUH0mkWHpQMwFblCZ+kumErzgfxyHW2IYlH9uWYIFxb3yxQn
	5nmAPbO+VRbQY1xOpH/BRaZwnT0ZVRs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795787800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDHZFcc4v4kqFFQEYuRlrYilSomjPNjJYmAG/IBsVQA=;
	b=3szlRC44RBg+u6CQO/NmaVQWY5h+hO5YJVVuiml4DzLPq5yksG9boWQZfvcmm8XjbI3aWG
	tRh2ycHgjUdWEoAhfu2nbGdSZiBNODiFWGilHd8UhGY4+aNwN9tOOTJniPJpEW6KyTyHo3
	aMWbz+RMwCqGVDVpWU44i7jXrjsxOMc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grVuyKYj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F7CC61FAD;
	Fri, 27 Nov 2026 13:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56721F00898;
	Fri, 27 Nov 2026 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795787799;
	bh=mDHZFcc4v4kqFFQEYuRlrYilSomjPNjJYmAG/IBsVQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=grVuyKYjKbiS1ihwdqXTmbKMjYlt3hKKSiZ6KB2oCL8luv27rt0HzarRUbDKzOxj1
	 HPsz162Ar1YxMaPCfZXxyhOStJ6PVBiXvFPMkwz8yrfC37t0kpzn8WzKSpEkSXiMHY
	 Erzy9zU5o49jWDf5Hhtq7VJUk8wDNjeUOwG0yEdPaxthQaTasFgEgagGAH8YRvBgRt
	 N1KBH3dbzZlQ9FIWujAYqk3hHIFDAV6HQRK1JSCMevdxyZ9A86mcIG1WCX9a1RCjNo
	 4d3QygwOtZ4gNdYeveGhrX6pLChjGzcxHH6CVnF0S0FgQCrjZW9XpyaIvHRzQQQ4mh
	 1r99LL31/6AnQ==
Date: Fri, 27 Nov 2026 13:56:37 +0000
From: Harry Yoo <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab: add own entry points for
 kmem_buckets_alloc() family
Message-ID: <awmJTJc9o51igzad@thinkstation>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
 <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
 <awg-2hrOmY5U3vzS@thinkstation>
 <4cb6e0ea-5e6c-4ecd-b673-70b42864c694@kernel.org>
 <CANpmjNM8K=2qGb2qWGj-AnuGSRbT5KwPdu9z6e5i2JfH8_+7kg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNM8K=2qGb2qWGj-AnuGSRbT5KwPdu9z6e5i2JfH8_+7kg@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DC82C0007
X-Stat-Signature: 9zxjekj1zhqq5d7d3o5gznrytdkeixyj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795787800-369323
X-HE-Meta: U2FsdGVkX1/SeqMfAMaUdaCT+DIOx9jCS5iXRbFyqsZOlfWYVgGOOmoPs54FbmyHWSYXnZ9F+NfA0XCI0CnFftvQIzZtqPPaDy4MkCl0hLhuZf/7ykLuS3yJAaSYvWZbGUm827nbe99JTZkubNOsWEZoZfIkqjx6HzYVE6JDjqLYDWgHTEUDpJxI4jG4mBJ7VZ8PqkSDYHB+GqTbRwA0e2L/WIfdjxD1bGvRZOeitFz/kt2yvm9Xk9Q6TjBQe6k0YPdkDgw2D/c2uCzgTa4OEES6WKJGYdvDJJZje7pThB7sD6a8tyE1imKyTNJqCbGrVnS/81dUd1//HCzxEtDkv7y8FoTvVlG9bQhJzyvbD5fwrleZ5QbpSkEwYDuT1dldbA4tncgCsaWophFadc/HEWQhuxZEqStqAUtgSJDT8QsA4D/sRrjHbe5EfAiGFSOI8yol0Mgkr/NzO/Rg8ad55+6WI52mDuSUzosGi7DqdtMOJv98kTbCHRex0nvkkfTFIrk2saPl7CjV4rASsDnKErBdjNhnBaH2/wKr0rmlSNxhRX36UbqH+K9UxO5O6GRYU1PmJ5O1ZV1+sugrTsuKwVEbF31+tmGd6Zh7yQdZHk5D3m3669pbdmpD96XXozzO/UAHTJxk859q1BBuUQ/Soh4qO+zIrDcXZsw4Jw4CKXkzj8qX3jjAUJ+PrZVr7uEF+oycjJk0/WOStIe3sbJv6j7YPN59NvvzksmuAwuenewlHsGJCXx+qi2KbPFoRIcXOBqsNhH87Efj3bpGwftpaRM1ZjUeI7MYzIiM2bkVckQ8knmlLC6dQj/q3Rk7MtGH2NJj9RMZeQQeMXqyn1q1P3/07XTnbjVcmFcW/nz0V4IWWb0oTinPV1sNRIK9YGKK6pOInTD2nwC7oJZBrfNcuNn1/eiIfGXIrkFgg+Xbl4f05bsKDY0AC74I3YilHednOPRm0EMjCxCCAbN1iGZ
 wSqScNXg
 NbrEGEMHRuzIZMN89vkiGJXFjC1+r1vOg4R1yd9p+3u8qpIOLAEtRni3ILl25Uu+PSsYbpAa49tCpME13dYxsdf8G6V6ztAXC9LnrgwP6Xp8zyu2AZoIcxjTLgZGQtDT4k2oVA8THhRqAOLwgCn7gcpjJWxCtfYE1BQ0PhKAD7dqSefD8zJW4wAtd+Y30hBXUqL3tlm00Y3UiEpTOEzY1ujBn8fo31z95r7tNhIFFkVyQa4BPEY8b/G/NkX8KzpXIKFXyT6JsHSpIPHWSWO2of1d4jSbvqg9jO1oZJ1wIQomusJBmGcHL5owuyaiu1GUkr5ii1tF529JS7JM45eFTcF0aXKaTiGkDfD9ofPxGCKV35qjirbIUOJttFfa+5gyppXSurN/a04o9rqomlww8T8kXKcblsrvTQImToqnzCLrXNzJR7FEU4O0z5HZyR6Pnoa/8Hnnuyrfn0DLW6BL5JzCiNzID+21h80buBmCu2KHI/6+YBb0UrIe9BVmroBNhAYQZgWk04nmbgZg6/Q/i+WWOhj9VLhTBvJuDzkyuPFOV2po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 08:59:23PM +0100, Marco Elver wrote:
> On Thu, 26 Nov 2026 at 20:04, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
> >
> > On 11/26/26 15:22, Harry Yoo wrote:
> > > On Tue, Nov 24, 2026 at 05:30:03PM +0100, Vlastimil Babka (SUSE) wrote:
> > >> The way buckets have been implemented was to extend
> > >> __kmalloc_node_noprof() and two more functions with the kmem_buckets
> > >> pointer parameter, which means all kmalloc_node() callers now have to
> > >> pass NULL. To avoid this extra parameter with CONFIG_SLAB_BUCKETS=n,
> > >> we added macros for parameter declaring and passing.
> > >>
> > >> This can be avoided by creating own entry points for kmem_buckets
> > >> allocations and not using the kmalloc ones. They all end up performing
> > >> __do_kmalloc_node() internally.
> > >>
> > >> Since it's just 3 functions with few callers, do not try to do anything
> > >> special to eliminate code with CONFIG_SLAB_BUCKETS=n. Only make sure the
> > >> bucket parameter is changed to NULL in that case because it would be
> > >> ZERO_SIZE_PTR otherwise.
> > >>
> > >> The removal of the now-unnecessary parameter macros is done separately
> > >> next.
> > >>
> > >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > >> ---
> > >>  include/linux/slab.h |  16 +++++++--
> > >>  mm/slub.c            | 100 +++++++++++++++++++++++++++++++++++++++++----------
> > >>  2 files changed, 94 insertions(+), 22 deletions(-)
> > >>
> > >> diff --git a/mm/slub.c b/mm/slub.c
> > >> index 70df0a2e3876..6674caabbb6e 100644
> > >> --- a/mm/slub.c
> > >> +++ b/mm/slub.c
> > >> @@ -5732,6 +5732,34 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
> > >>      }
> > >>  }
> > >>
> > >> +void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
> > >> +{
> > >> +    const struct slab_alloc_context ac = {
> > >> +            .caller_addr = _RET_IP_,
> > >> +            .orig_size = size,
> > >> +            .alloc_flags = SLAB_ALLOC_DEFAULT,
> > >> +    };
> > >> +
> > >> +    if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
> > >> +            b = NULL;
> > >> +
> > >> +    return __do_kmalloc_node(b, flags, NUMA_NO_NODE, (kmalloc_token_t){}, &ac);
> > >
> > > No type-based or random kmalloc partitioning w/o SLAB_BUCKETS?
> >
> > Hm that's right, that excludes it. I didn't realize that,

> > but also I wonder
> > if anyone would really choose to have partitioning enabled but buckets
> > disabled.

Dunno :)

> > It should be straigtforward to add it though.

> > But as long as
> > buckets are not disabled, the token parameter will be effectively unused. Kees?

That's fine as buckets provide its own isolation.

> This falls back to normal kmalloc caches, right?

Yeah.

> If so, if
> partitioning is enabled, it should choose one of the partitions just
> like normal kmalloc.

So we need to pass proper token

-- 
Cheers,
Harry / Hyeonggon

