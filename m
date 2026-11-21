Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B90606A6AD
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ6lTjMd
Received: by kanga.kvack.org (Postfix)
	id 060216B05BC; Fri, 20 Nov 2026 20:09:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0138F6B05BD; Fri, 20 Nov 2026 20:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E903A6B05BE; Fri, 20 Nov 2026 20:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5C7F6B05BC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 505D116028B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:32 +0000 (UTC)
X-FDA: 85457343384.18.E5C7BDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9195C0004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ6lTjMd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223370;
	b=uKQ4FDLriq9JTBNC9xLTGUNl/KzrUhIeQXRNV82m0eTBKGPIz5BiPdQ3VR1N8cYFoBY0lC
	1TCOhe/LVdZCBtvCbZIwOUTai82G2OkUnBeJTR/vzMk1hWtEcbqKh2pG8/uk6QGB47ARDv
	d0WDCr7nfoEGUKj7exH9gB0LIVE9S7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223370;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE7Fnxc0Ng4ZVygkuAYE6F7O5yzADR88DO+pmgTt7/I=;
	b=dyMgdLDR90DMlN8Pi4VnPtATf6Mk6HWhs27qEyY1An6We3TJNPZSfvSYOqTyhY4mwqhD/y
	uMPs4GvLws1E8p4tVTvq2bUFmT2mpWq8S9S/ZBWZtUmU64FjG3H1uuoIFa+X7eOCQjSmPh
	9/8gKa3tWgNDSKthoxHY2YZQ9BIBBm4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ6lTjMd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36AE86119F;
	Sat, 21 Nov 2026 01:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1831F000CA;
	Sat, 21 Nov 2026 01:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223369;
	bh=mE7Fnxc0Ng4ZVygkuAYE6F7O5yzADR88DO+pmgTt7/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AQ6lTjMdx2mitLIGyHGQQjy1nohrsMeLaQ1oPi511kcj+brL6PzjJPtiLRU5Lsn68
	 q2/zFFS2s1jJCPY08kO82xt0Z+HDR/spf00TXh5RIPRFccI0A6W6oExFaRXAe64Cmw
	 rkLD9thvHa+snOSefgoZBy6S4KcQAzTba6+hnBlIlEdu5hWO6o8vvUCManNdHQPQ1D
	 UBln6aquKyzFmde8blBpoCjJ2JZor6fkI2GPwtuIlLvCiH5QiIz4JazRrFlG8YSDqV
	 UUfCRvKl38Ff4weoHun7Tw/3idu5EhYnPtTy/XAW+lThZA+aH1AwIDql31rSNDES8A
	 uRNq3ZVqewRew==
Message-ID: <sashiko-outbox-226474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 10/25] mm: Add background page scrubber for PISA
 allocators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-11-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-11-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:27 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9195C0004
X-Stat-Signature: 9djury9b9gpsk3wjxcwmm36dx46cd3jj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795223370-572340
X-HE-Meta: U2FsdGVkX18B61DjH10MkE38yPbQKZYt7lXrYtRKlnXMrYfmenJAz5lM1HEIfLnTB9oAb8o9fVuBSf7ez2tWPlqBgxsF+734nGKBklGOji/xQ/lkHsj42dYiyVNCpwtTO/ZqaelgWZBMfZsLunCy7CTw5KQUyoadSjZH9REhIduDyhPXWbetX/6JDs2UMAwQv/5N/jxGfkjFEvFBaz6JP/eeTULbpk9wqrUGn7HIV7arq381A8ZkbGQrrggIVz1vjfOiXo5iBL1gvT6ZbihwJhYtI85tFTYQCTVFCr1y74YZCeXrI0933I8NP2U/ZYW5pgrPQ0ZmYRnKmDk7IAXLgYhvtiMEsTwGRHb/EiLrvRrYzQGx1HVZOtKt2JGi225Vg+eLbEKZ0vV9aULaFG/Y2nozcbT51bV7y8Bap/4sm71tzVRZne8VlChNQXL15x8qBpKx1cBrBrkhHMy1ocHJAtJMnedNTv0A8Rzc5q+QA/Bu8O36tproRfrjFZs/VF6CLmYKh+8AsULa2m8iwzToUKlKE5EH0Ru8gKWILla0e2XN8JYB90ClKpOPEo8j2xtaJp1db753kPNkLI2r1DfAOiO/+U6Kl2ZXdsJItl59gRp0Hu+5fQfQdOUs5O2JPtT0QP+KHhyKmDcp3ThKUgzuFEAfTQDE+/gPTKC8Z8ciw/mljJfUkds+TNAACD6rz2bsrEhOOlK+FK1F6FrqXCkwfOk3vYnPs5FHTajhbs74e9NNCWhWJ8roJGxCD3tVh9BDjjPjD/ar+623uAKRLm/jnsSjQEUH4dvkYgaKL80O5d2QiRKv3UAza903LvJhefW22QcmZBtbQ55Pbpyav0VCorlwiXI5i+buv9gzH60YKRZ7iGEZw8jOAmgFSlnfZWCTkri8hHSM7LtBwPqmQ2ekQ/oNSyZmi0IF/vKiBWvmr1vLnEpGRDsRyL4AFA9MR4Dl8uLB9OUw75XVW4T0AhX
 Z5okzoIG
 Cr9UgDT+dmO/ceB+0rQT56G8wwhT4Y1uO7X5edJM/Su0ndhazRD3XYG8kMQzyVEN8CvNRi9z9EQ6tGyXEklI6gEJVYyLF8JonnWcTJg06a6vD71duEgtcAMMOL3b7ioqr7M/w2rRahDT4M+K8wTMNaQpdaJl1IcA9kCEx5NmnHsaxLVdnq4HZwB0NmTpfBdr17lae+kjwOt8u8taGEH+7a6e7quJWXdzbv9tTF78zSgbVlPJLANvTyj6B2bmRXTb7EpzOCbFrQCW1wlcMNv+8ss92YWZvfYEHqUjN4p6enyT5UVREp6WOV2/kN1a323qvrAHh0q/rxmoU5iorKqlkckv7pEB0Au2E1g6xK6UQgAX2M5VlZE8pr5KJfRPg6PQFSTgYIbgCWzHQmK7FHZuMvumwxlX6oFKaaNxaBTltH+edR1u/m/aJfkc8is7RQ6cvEgdRWMENMxQ47diCAQdy4j8Hoolcw7YS8sXadTaSUCxogKVCGuignKVMO8TWL/Fi3qqlPzvgNCwaXUxWLt8KZ7gGhS60BEefaulbI4UC3a3GfnSw9HzdZlmEREpugPi4r4ugeQC41opfO3Jh9ALKuySGujTNWhSth/cXfurb/bIqbCbflpvf4BiMuABoUsvjIQPn7/YrBzkw1yz+JLDSwirm4lUfS1x+z5XU+waE5oPwVIN7V8kiNV5fsWHyozbIdrJAADKFIidc2EDmt7H0++SPLHtNjp+Fv8kfghBpJMbszPodNyd0yBLMV3dEiHZv9ksuElHWQbN8yVQ+juLlR5dFtksXa4fikXAzqF6oDTFn4ARhC2lcyHKR+SAOon1FgZ7wRx5Fy1+bpm2wIqFaOgffdlnZBTvRbybAcq6QHsK+xdAOd8X3bFoj6AAJDz5NArVu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: test_reservoir_and_scrubber() moves dirty page to idle
  before scrub
--

commit 70c7c1222c1db62795294daab0b4e4be086b26aa
Author: Luigi Rizzo <lrizzo@google.com>

mm: Add background page scrubber for PISA allocators

This commit adds an optional demand-driven background page scrubber for
PISA allocators that zeroes dirty blocks on the home NUMA node's work
item outside pa->lock and moves them to meta->clean_bitmap.

> diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
> index 0f8cc9baf5d28..4effbc8610079 100644
> --- a/mm/pisa-kunit.c
> +++ b/mm/pisa-kunit.c
> @@ -662,8 +662,57 @@ static void test_gfp_pisa(struct kunit *test)
> =20
>  static void test_reservoir_and_scrubber(struct kunit *test)
>  {
> +	unsigned int old_res =3D READ_ONCE(pisa_reservoir_max);
> +	unsigned int old_scrub =3D READ_ONCE(pisa_scrub_max);
> +	struct shrink_control sc =3D { .nr_to_scan =3D ULONG_MAX };
> +	struct pisa_meta *meta;
> +	struct pisa_alloc *pa;
> +	struct page *p;
> +	int nid;
> +
>  	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
> -	KUNIT_EXPECT_EQ(test, READ_ONCE(pisa_reservoir_max), 16U);
> +	pisa_shrink_scan(NULL, &sc);
> +
> +	/* Refill reservoir to 1 PISA page per memory node, then consume one. */
> +	WRITE_ONCE(pisa_reservoir_max, 1);
> +	pisa_schedule_reservoir();
> +	for_each_node_state(nid, N_MEMORY)
> +		flush_work(&pisa_nodes[nid].work);
> +	KUNIT_EXPECT_GE(test, pisa_reservoir_count(), 1UL);
> +
> +	pa =3D pisa_node_pa(first_memory_node, SKB_FRAG_PAGE_ORDER, true);
> +	KUNIT_ASSERT_NOT_NULL(test, pa);
> +	p =3D pisa_alloc(pa, GFP_KERNEL);
> +	if (p) {
> +		meta =3D pisa_meta_of_pfn(page_to_pfn(p));
> +		/* Reservoir pages come pre-zeroed (all remaining blocks clean). */
> +		KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
> +		__free_pages(p, SKB_FRAG_PAGE_ORDER);
> +		pisa_pcp_drain(pa);
> +		if (!want_init_on_free()) {
> +			KUNIT_EXPECT_GE(test, meta->nr_dirty, 1U);
> +
> +			/* Scrub the freed block and its PCP batch back into clean_bitmap. */
> +			pa->scrub_demand =3D meta->nr_dirty;
> +			WRITE_ONCE(pisa_scrub_max, 512);
> +			pisa_scrub_node(pa->nid);
> +			KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
> +		}
> +	}

[Severity: Medium]
Does freeing p and calling pisa_pcp_drain(pa) move meta onto pa->idle
before pisa_scrub_node() runs?

Because p was the only allocated block from meta, returning p and
draining the remaining PCP refill batch brings pisa_meta_avail(meta) back
to PISA_BLOCKS(pa->order), so pisa_place_meta() moves meta to pa->idle
(or pisa_free_list if pisa_idle_ms =3D=3D 0).  pisa_pick_dirty_meta() only
scans pa->partial_dirty and pa->partial and skips pa->idle, so
pisa_alloc_scrub_blocks() resets pa->scrub_demand to 0 without scrubbing
meta, and KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U) fails whenever
init_on_free is disabled.  Holding a second block from meta across
pisa_pcp_drain() and pisa_scrub_node() would keep meta on pa->partial so
the scrubber can pick it up.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D10

