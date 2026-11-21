Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995AE606A6A1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlmBQKzx
Received: by kanga.kvack.org (Postfix)
	id 1BF066B05BB; Fri, 20 Nov 2026 20:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1719A6B05BC; Fri, 20 Nov 2026 20:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD746B05BD; Fri, 20 Nov 2026 20:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D81036B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62E51140281
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:29 +0000 (UTC)
X-FDA: 85457343258.02.9FF3FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B216B1A0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlmBQKzx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223367;
	b=rZD5XpvaNRtDX0Qel1MWi/+erfMI2PJUpzHzTmaBUXg+wzvAAD17+DDkXaIYW3fvvExdx9
	d/xoqDXGgftW6AWeuhRafWHyrmuGF9xwIN6qrOXajy6N22mUsR3/gU7dBa53lKaBLxfGpd
	DJ8+lO9nwJ47z/98bVVAg6jIwVCSPjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223367;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/1/PI4CSVbO07v5H41CHpHKGjqmCYFtcgDfhJaVu68=;
	b=pwayb4NrCibr/hyQO5fipIr9l4e6p84avhV8KzktJCzotVavR2bZG5poQrhoNPMkfr2xIi
	RJ4otc0Y3RmE0Cc+757DXNX2oiXDFPVcuGovQRmKOd4V5LshGRmqKGv9pqHKwCOB15nqi4
	v4QFbI73DytLyXdDTMShr7jZ7SppmRM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlmBQKzx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ADAD4157A;
	Sat, 21 Nov 2026 01:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D0E1F000D2;
	Sat, 21 Nov 2026 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223366;
	bh=e/1/PI4CSVbO07v5H41CHpHKGjqmCYFtcgDfhJaVu68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FlmBQKzx2VHQSI5mc9QcsGNrlmpc7DW1V+pZJCckhIplKEHEml5Z4SzUdBbpjtIf2
	 SO2f1W1jgzPSrgig7WLfT19OMWQBnzaQpzdV30ZKwvUwgKLY8RgPsCR376Fpp0a/sG
	 a3C069bjyuWMwJrZfpm69q45N6MMZOUfQKhyJLFpi9FsgfyRSOAwn6EkFPwqGaaiVa
	 krgA1OsVRhTnuKudvkOJ1G8+DJ5BvPPKvMGjjG7s6mFkN8YWV87FregBmKWzdsoh6R
	 ZX3EwAYwYrK3oTueiLF2jI8ttGHoodj1CYsMd+a+Q5PcgglzJsw9rBGL3xYC+qK8fp
	 VdkOwh+YDLrJw==
Message-ID: <sashiko-outbox-226473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 09/25] mm: Add per-CPU block caches to PISA
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
In-Reply-To: <20261120010655.467825-10-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-10-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:24 +0000
X-Stat-Signature: hpxrzpizt9wxddd63tgon8uk786ky535
X-Rspamd-Queue-Id: B216B1A0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795223367-431624
X-HE-Meta: U2FsdGVkX1+JR0kgongC+DYKs0AlquAIcoIPJ+1D2xJleeuONhxWPIhoTFa0RBZy3aHFPn/eQPOA26TTxmquxjlp2Este3TAwX0hhXgGkoKjk3vMc58ISYDg872zf8OTvqt93ZzYRq7Ko2A34BYUQyEmB89O4prxxdSlFJjv95/4IVtfmK9rdEzNQUHrY1YCZ41/gBKfJkdACNiHyNduej6N7uowlioBfbd4L/16UeRRBLPB3GgMvEA6/jQURs2Nrq+FjIb2EL9tumKAbEmzlbJdL+cf4wHIvomt5eXAFFOLmk1qgC8jQ2S04FtUpttErvUX0CG0OzYpxd62YOvVUyJlJHrWFUNZKJBHleKHlslG7AjDcI1SHqV6xb3UZLViW5CDT3pcwDuX6q3lq81+9bGJlPmAzS6zMVrtkrlNdrBjBhK81tlDeEpJp5i8TxLrHs0S0FZq7UGS2U9TbFGBwzamkAQDKVDymX0UXE4NED3ZLpiPWlMvoMfDRkfU94NYrdT4EidkkLd/wwPfpUW5HkscCpdGcVz2jtAmH4x7QMqX3v697OsXL+oGaJfJEdvyGaLt32R6xmwPOLEYNsiAtK3fNKjLTjRCnalnfJ20tpsqBhF/pNrcSLiwcsx5K0bDCmoO+PRsIJUc2nAWJyPfHyVQ7wbGr8+ZAgPrG+L9484XcD/5e6slwvb8CiArpQTZblq0ogzM/VGE4/bMNsBD4/CNg+fIEmirC4BmmYkVUTLu7+KdsBJnNek3ImngUQXBHq9kOV4AeQBe2sF5OfsNXA+aFw62g2LhLdWOIq0dEkY7C4gH8h7QmKe3yMSGTKgibK7WreAgJAvlMh/3HZHwIdVKHZcNLK9M4TY6ufsxK9eJaKvhMfRI7PaBEqO2yg2eSkDDxMfQNHJK70JO6lcKN/OFLw5mQVxD8qdy488OD3B61Wsv/mYaQ2IiPY219eNpjuuFnx3fG4eoDSQlHVn
 iwzT6cVe
 Lz3uhWI6Nw9kRK9odu5Tfe8dRCPKwvaPrfdrbqg9y0v8kuH2cdzlFiK+K12SFe2VnnCA98vbzdORQKSpOJS7LTNY7I2Y61IwfElvLjq9BUbuRijdWvFJToVlM/D9iL8cLwZQitAHeTDGNDoEcDJkpT4Ljj9gfrYLLHVVJQL6TwAuWhgHH/7rod5dWD9IzQw58Dam5oN53DgvnB1D8nCprzGyj+vJrq4p0DS0GI7WEH7rjiPhr7wbC7w08U0mQ1N9kkplUwCg8pIQdmQmhgMVmc9itLxS4Xb6/WM1qE9RPILwHqV9/yXqNeOfgXaHsADnC0HFGxiJin/e4/eGI6aSyxnGtC/Gf73I1ElljP/NdAXSBMXbEQaNSXxd5QaGgzR2kwxtiQ19uGc/amiSky7iIrBkD+Yfnp1ql8M8VJKtOuDqeCt0eeXNmf2Sj0pas3Eodaep68E6Dh/78LMHTAAr85EpvfKaxqIClFx05dATlAcLlnGp8QM5w0WH881b7cUuAKwMBwHfChWB7US2oG//uh6hH22Z5OgvDm4CWB3En0AOqMQ7lMhu7Ad13FHd1NqvCtUBlZmiNouKjHqzfoKjOdfrYDDKyedKbu46XceAc/2JVMRMRObJoIH0KQUxXKA1BQGEvIPh/ZptrbC3PQuGYe2mMUHD/6j0ycIRVxgwQ6H3BRMQ2ZRtDpqo8wL+VZT/pjXK01FUd0IR5N8bnntNRIeXpymYncJPPOkifKwE4cu+Kd0LdUbImSxT/sGUB5oO9BrUpfj6tYE+Bcks2KYStIKwqhOBqYysRz3m2AxYU0Hn1kykGewh/4my5VKKO88m/nCHd1zcIe5IJYVIeB/7Ny9dVhWHNeG6fK0CCLbtgg3IdseNJLbZXn466itcz7HuUIEMc8MVBxSEK/M0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm: quarantined PISA blocks cached and reused via per-CPU
  cache
- [Low] mm: migration race in pisa_pcp_push() strands blocks on remote
  or dead CPUs
--

commit 9051b3f49c794994e5d00217ac93ea632ab60aeb
Author: Luigi Rizzo <lrizzo@google.com>

mm: Add per-CPU block caches to PISA allocators

This commit adds an opt-in per-CPU block cache to PISA allocators, integrat=
ed
with the shrinker and CPU hotplug teardown, and enables it for per-node
order-0 RW and SKB_FRAG_PAGE_ORDER RO allocators.

> diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
> index eda12d475c9a7..896709303f258 100644
> --- a/mm/pisa-alloc.c
> +++ b/mm/pisa-alloc.c
[ ... ]
> @@ -324,13 +326,168 @@ static bool pisa_return_block_locked(struct pisa_a=
lloc *pa, struct page *block)
>  	return pisa_place_meta(meta);
>  }
[ ... ]
> +/* Cache @n blocks at refcount 0 on this CPU, @n <=3D PISA_PCP_BATCH. */
> +static void pisa_pcp_push(struct pisa_alloc *pa, unsigned int n, struct =
page **blocks)
> +{
> +	unsigned int batch =3D pisa_pcp_batch_order(pa);
> +	unsigned int high =3D max(2U, PISA_PCP_HIGH >> pa->order);
> +	struct pisa_pcp *pcp;
> +	unsigned long flags;
> +
> +	/* @pcp->lock protects the cache: migrating to another CPU here is harm=
less. */
> +	pcp =3D raw_cpu_ptr(pa->pcp);
> +	spin_lock_irqsave(&pcp->lock, flags);
> +	for (unsigned int i =3D 0; i < n; i++) {
> +		if (pcp->count >=3D high) {
> +			/* Keep the most recently freed, likely still in cache. */
> +			pisa_free_bulk(pa, batch, pcp->blocks);
> +			pcp->count -=3D batch;
> +			memmove(pcp->blocks, pcp->blocks + batch,
> +				pcp->count * sizeof(*pcp->blocks));
> +		}
> +		pcp->blocks[pcp->count++] =3D blocks[i];
> +	}
> +	spin_unlock_irqrestore(&pcp->lock, flags);
> +}

[Severity: Low]
Can preemption before spin_lock_irqsave() in pisa_pcp_push() strand freed
blocks on a remote-node or offlined CPU's cache?

Both pisa_pcp_alloc() and __pisa_free_page() check pa->nid =3D=3D numa_mem_=
id()
with preemption enabled before calling pisa_pcp_push(), and raw_cpu_ptr() is
evaluated before spin_lock_irqsave() disables preemption:

CPU0 (node 0)                     CPU1 (node 1)
__pisa_free_page()
  pa->nid =3D=3D numa_mem_id()
  <migrated to CPU1>
                                  pisa_pcp_push()
                                    pcp =3D raw_cpu_ptr(pa->pcp)
                                    spin_lock_irqsave(&pcp->lock, ...)
                                    pcp->blocks[pcp->count++] =3D ...
                                    spin_unlock_irqrestore(&pcp->lock, ...)

Similarly, if the task is preempted between raw_cpu_ptr(pa->pcp) and
spin_lock_irqsave() while CPU0 goes offline and runs pisa_cpu_dead(0), the
task will repopulate CPU0's cache after it has already been drained.

Because pisa_alloc_bulk() and __pisa_free_page() only access pa->pcp on onl=
ine
CPUs where pa->nid =3D=3D numa_mem_id(), blocks pushed onto a remote-node o=
r dead
CPU's cache will not be popped or flushed by normal allocations and frees,
keeping pa->blocks_in_use elevated and preventing the containing PISA page
from becoming idle until a shrinker scan or coherent DMA allocation drains =
all
CPUs.

[ ... ]
> @@ -911,6 +1130,16 @@ bool __pisa_free_page(struct page *page, unsigned i=
nt order)
>  	if (want_init_on_free())
>  		memset(page_address(page), 0, PAGE_SIZE << pa->order);
> =20
> +	/* Pairs with cmpxchg_release() in pisa_enable_pcp(). */
> +	if (smp_load_acquire(&pa->pcp) && pa->nid =3D=3D numa_mem_id() &&
> +	    page_to_nid(page) =3D=3D numa_mem_id()) {
> +		if (pisa_page_can_recycle(page)) {
> +			pisa_pcp_push(pa, 1, &page);
> +			return true;
> +		}
> +		pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
> +	}

[Severity: Medium]
Can blocks belonging to a quarantined PISA page be cached in pa->pcp and
reallocated instead of draining to retirement?

When an IOMMU unmap fails, pisa_quarantine_page() sets _PISA_QUARANTINED in
meta->flags so that no further blocks are handed out from that PISA page and
the page is retired once all in-use blocks return.  Here __pisa_free_page()
relies on pisa_page_can_recycle(page) to avoid pushing quarantined blocks i=
nto
pa->pcp:

include/linux/pisa.h:pisa_page_can_recycle() {
	return !static_branch_unlikely(&pisa_recycle_check_key) ||
	       __pisa_page_can_recycle(page);
}

pisa_recycle_check_key is only enabled when pisa.compact or
pisa.target_usage_percent is non-zero, and pisa_quarantine_page() does not
enable it.  Under default settings, pisa_page_can_recycle() returns true
without calling __pisa_page_can_recycle() -> pisa_meta_can_recycle() where
PISA_QUARANTINED is checked, so freed blocks of a quarantined page are push=
ed
into pa->pcp and reallocated to new callers.

Even when pisa_recycle_check_key is enabled, pisa_quarantine_page() does not
drain per-CPU caches across CPUs, __pisa_free_page() only drains the current
CPU, and pisa_pcp_alloc() only checks popped blocks for PageHWPoison() with=
out
checking whether their PISA page was quarantined while cached.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D9

