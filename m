Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656C3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kn0KKHTG
Received: by kanga.kvack.org (Postfix)
	id 0B0336B05B8; Wed, 28 Oct 2026 23:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039CF6B05C2; Wed, 28 Oct 2026 23:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90FD6B05C3; Wed, 28 Oct 2026 23:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE60D6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:06:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30503802AD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:07 +0000 (UTC)
X-FDA: 85374174774.16.C43D6AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A301C40003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kn0KKHTG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243165;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsQzxyMenJds2tGUJsHplWFmap7Qi4tvdnzR8ntWQ/U=;
	b=tPz1flNUJLNt9M9iXHoKgx3pzIEyGsfvIh8A2MumVMHeAdt3BQA9Ge+Y0hstvAWQ/gysn7
	VaWK3l4LVdkaXJiZVLLqwrIhbVfJJOgGNBUdr2/c47hVE8Ex5NgpHj0fJfn47tg1ybrrI4
	gtvqago4f6UmFzjsjgbM9pQyJt8XcM4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kn0KKHTG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243165;
	b=7pLWpaOYD2c5RAWJIA8/5dSaJBAB5VQqhVD9Qf6zJhss+V8wTDOGpH5m3Hlu4TvqXLeISJ
	6jOmujQNJrnwMtCScXN+6y3/tVxDdbe6Boa57NP7tCijnh3KMOqf1mXpB4aJJCb7/1/N52
	YB7MGYZsV7FIiY/9LPcwnvZqzs1Wck0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C484601F8;
	Thu, 29 Oct 2026 03:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63E11F01828;
	Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243164;
	bh=DsQzxyMenJds2tGUJsHplWFmap7Qi4tvdnzR8ntWQ/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kn0KKHTGAOzoTr530I4hGNyjDPLzk4IVpEbDXSW/90FmsEQyv5jVO7hh+K20Ldksc
	 7vLshdi2lOXs7rsnMjwKQCqhLdlsQU6f5Z1mUVVNLHQAFo+q/rv2S+pzycIB4YbfFx
	 3xTWifBCalaxWGn6ydsIGRw3J0isGYzcxIxrYOS+dux+eYHKBQkuRDjVYUGi2aAzyg
	 CH1GKuEVlgTTOljNMI5JcRwkDAnUyK+4gS1NsRJybvmHXsVXseBPStqZ+bbnQEwSxN
	 bYl6VLIDUb0kNZBmaEu3W5sXp0pcnH07YfqNlcrIEDHsvDfHZzZPGjHLqoYL6WfPlJ
	 3XyKqXdBcc9GQ==
Message-ID: <sashiko-outbox-188658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:03 +0000
X-Rspamd-Queue-Id: A301C40003
X-Stat-Signature: bg9jzdbgst4jcgw1jz4eokgcxwgio1s1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793243165-446706
X-HE-Meta: U2FsdGVkX1+gE7c/qYUUaK4GOWPxL2EuGUhmxohh6cx8Gjgy3PmkHVusKgrWXcEaEknDfF9QACGcsWLxSCLDiJdx4e54gQ//jeCqDD1yEvXKn62J8wz1xoArUTAp/dqdf7ludsGxwpdNWw0HqhUdHRZWx2afStC5zc2APSwq1h3NGZDu1F1vP7h+8NxHCczPkestUuHyZ7W1BY8+8CyjurkHC4sWfSS2hNvAsvw0OYB51kprYVef5hGdFsPx+Y+gRfh9Yk+AadH4nD+4FoUGqq0nVQ7yKYhL1pkIGKAAPTo+xPvalyBXk1w+xpFP5zm37BDDyQ1ZXgWbszcYONwI6cKeBE3EcoBpKAO5Dnsj9YsasixVM89W6Y6MjMz8+G4SCtE6P8jlqoR2IKhm/xwRyZWAILVUYz/ZIrG8+cfAInclpdvb2dH5qLpW64nnAl0VF2pQ/lOiBmU9Wab3usmlt/YOVmDKGcIDW46IRuRG+dMYb0ZC4UdjsxQ+3WhxoV4Ngs1UnQFB2qoP4HAk2n33bsKNt3q5ZHVvUzd1eYtn48LaX2N7TqjLstUVU2V7F++FLpnmP0cWPhBca/2RPoUApTqGDxQQ8fU+T8MMWh8VzJVCSVIGm8YGbeqtEYJ3NgIQI0YcR9EZx3jGh5g8nT/zwWssY/emTVNBYiFN3qzd1GtYlJR6VwMp3Sr/1+51Y8LozMQ7WN+ZJbFrY/rQG4xT4omYhygpmoDwxHQWnrC9WTeFse/u7ufdp0KT2lGTiq8Hhh6OVg3mbjI4GpfwRmU7GftsuawkG4BEFZy/Lgce4wakh0BeGM7jyoySiDqr+ndr8+/SLxVcuOrnPCrPfkr22wySGffAquE9WOaOHgD63+HCaMWbDnKqB7p72UKtBMQ5nhowr5OtI1gi9Xsy1zb2gewhS1L66WcIGFtwwHEzmYUTVX2CfmVM5NyW9vLhgjl7QOMb9DqV5suan+6DnCp
 QWoemJ3g
 IAKBuVtUUMH5Bl9cZuWMFfvDquEJsyb2FAIM512nF9WaVwoCIbOx+xXAy+aBNngFUoSutg0Ur9ulwr+dBU8dQLgobBeSP7lmPsDVyZMVZ/tGjOGHYLJfoQC5Qdux/esAbT4YiB/3t03MHnuC9hYBUdVyRHUwjcQD4am+i5lRzNl39XNtlANpDZVCSAAFpo1mXw6LhOkoTnYbh+Yi/a+nQBtUbwXT451hDacjbaHJ/pc/X67ceFJ8wHCHev6bSsIJMdpGz02a8Lx7ky1QaSk7eOk7L7uCaUdK5op7YyN03AEiK8xmHwEZi/+G7i022PJOVQDddecAbaA5qZFiM8vS/7J9JBbexXsGidmLwnkFubKKgXelf56Kpp2+3NsOsa075LJXQF26O7jD3ng9daWwBHHNHuhdLRvoy/OMbaD7ZOeDG+sFDZHTmHIMEF5sPLd5nd1PM4RdY46UpMkUrzqs+1j5/9g9kTBZhdq4LOVcndE7hSPn4O5czfGeG0qtoqMobkJgV5ImCpNAoXUxBSe91mwjW0EYcHTzrk3JmH0J0djoC5olC4AFES72AULFHAbNzzwXk5GwroSGpLkCutMDK642oFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: zswap: fix error return on buffer alloc failure in zswap_cpu_c=
omp_prepare()
- [Medium] mm: zswap: unsynchronized write to pool->compr_batch_size on CPU=
 hotplug
--

commit 13a7e2ffeb93e24e6a8f400496ff51f01ce0c408
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store large folios in batches.

This commit introduces batching when storing large folios in zswap, allocat=
ing
multiple per-CPU compression destination buffers when supported by the
compressor and batch-allocating zswap entries from the slab cache. It also
caches the memcg writeback setting and folio NUMA node ID in a store context
and reorganizes struct zswap_pool for cacheline locality.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 19b7d60bc7d2a..c8890e8a9b836 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -866,10 +922,28 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  		goto fail;
>  	}
> =20
> +	/*
> +	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +	 * compressor supports batching.
> +	 */
> +	pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +				     crypto_acomp_batch_size(acomp_ctx->acomp));

[Severity: Medium]
Can updating pool->compr_batch_size inside the per-CPU hotplug callback race
with concurrent readers or cause a buffer count mismatch across CPUs?

In zswap_pool_create(), cpuhp_state_add_instance() runs zswap_cpu_comp_prep=
are()
only on currently online CPUs. If an offline CPU is brought online later wh=
ile
the pool is active, zswap_cpu_comp_prepare() writes to pool->compr_batch_si=
ze
without synchronization while zswap_store() concurrently reads it:

    store_batch_size =3D (pool->compr_batch_size > 1) ?
                        pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;

Additionally, because each CPU independently calls crypto_alloc_acomp_node()
when brought online, if a higher-priority acomp implementation for
pool->tfm_name with a different batch_size is registered before a CPU comes
online, pool->compr_batch_size will be overwritten with the new value. When
zswap_pool_destroy() later frees each CPU's buffers using the single
pool->compr_batch_size:

    for_each_possible_cpu(cpu)
        acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
                       pool->compr_batch_size);

acomp_ctx_free() would iterate past the end of acomp_ctx->comp.buffers (or
leak buffers) for CPUs that were initialized with the earlier batch size.

> +
>  	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
>  	if (ret)
>  		goto req_fail;
> =20
> +	acomp_ctx->comp.buffers =3D kcalloc_node(pool->compr_batch_size, sizeof=
(u8 *),
> +					       GFP_KERNEL, nid);
> +	if (!acomp_ctx->comp.buffers)
> +		goto req_fail;
> +
> +	for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +		acomp_ctx->comp.buffers[i] =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid=
);
> +		if (!acomp_ctx->comp.buffers[i])
> +			goto req_fail;
> +	}
> +
>  	/* Skip the per-CPU request when decompression can use the stack. */
>  	if (acomp_is_async(acomp_ctx->acomp)) {
>  		ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
> @@ -882,12 +956,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  req_fail:
>  	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
>  fail:
> -	acomp_ctx_free(acomp_ctx);
> +	acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
>  	return ret;
>  }

[Severity: High]
Does zswap_cpu_comp_prepare() return 0 (success) if kcalloc_node() or
kmalloc_node() fails when allocating acomp_ctx->comp.buffers?

Earlier in zswap_cpu_comp_prepare(), ret is initialized to -ENOMEM, but then
zswap_acomp_req_init() is called:

    ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
    if (ret)
        goto req_fail;

When zswap_acomp_req_init() succeeds, ret is 0. If the subsequent
kcalloc_node() for acomp_ctx->comp.buffers or kmalloc_node() for
acomp_ctx->comp.buffers[i] fails and jumps to req_fail, ret is still 0.

At req_fail, acomp_ctx_free() frees the acomp state and sets
acomp_ctx->comp.buffers, acomp_ctx->comp.areq.req, and acomp_ctx->acomp to
NULL, and zswap_cpu_comp_prepare() returns 0 to the CPU hotplug core.
Subsequent calls to zswap_compress() on that CPU will then dereference NULL=
 at
dst =3D comp_ctx->buffers[0].

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D6

