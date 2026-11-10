Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9975606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNsA/n+w
Received: by kanga.kvack.org (Postfix)
	id 99A896B05B3; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969586B05B7; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A506B05B5; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8436B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1BD2140182
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:09 +0000 (UTC)
X-FDA: 85420759578.07.9515FF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E57710000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cNsA/n+w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352328;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdGec8nrF15EvFKbUNYpTBIPT3Urp16hy6sBV/1EUaQ=;
	b=aa0vBu7KhMMFtkT/se5yqxN9pmgBLleLXXyJlIVMtY4qgs3eRpuzs15/UC2qDErpI7d1z/
	ZD95XXr9XeOwPuRH50eVbf9p489L/Xni1Mjvm3Bddm56KXhgB9D00k+cwCRUk0CzIaFgIL
	o/at8vmkYHeaEdDVO1S7GL8Tk2pNLSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352328;
	b=4Z4jQ7cXZK2cy2SQ9iO7Z4DdfzHN2e7Xa5tVacckUNOkUsXSrpLqNh1wxywcJe0z/qxrxT
	jrkhUZWAF61XaYxgtE4hWPRANawTNA00Fy0/mCBoINt5vIWK4jL95q7cGOrQ2A6N8pN2fZ
	iLrAbOmfx1s8UTXWXYhN7iteQA3U0K4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cNsA/n+w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A835A61255;
	Tue, 10 Nov 2026 23:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1F91F0093C;
	Tue, 10 Nov 2026 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352327;
	bh=NdGec8nrF15EvFKbUNYpTBIPT3Urp16hy6sBV/1EUaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cNsA/n+wBRw6iUVOExILT9Xrbemzu1913g9WRu7fjMQMp9yMQRL6qmSKSzo7ACh09
	 XQAuxUiJN+Nl3o42PKMeTfCY2deRtAtKjNbYxhfGFg3Je2lUi1Gnadbtj5/G/NlwqR
	 9Q2PhHKegfwLa8X+k1WJI3Bcr2i7nIXrYeoPEnkUsGVzB6z05JITCFtxU1rnJPWG1b
	 wtIFNdCaiAmwVGSVhhiP0qA53gWukp6lYPeq3ybdVBv4UVg5bmX5oNomRL9tAMFN/O
	 3kMjg0pbn1yRTsnJvj6HlXCHmKXZfkz0OfLS/ulXSuSV2O+vEy5KQT2krcLczYEgXq
	 QYbcXdDpZHXjA==
Message-ID: <sashiko-outbox-207858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 03/25] iommu/dma: Add per-NUMA-node PISA page
 reservoir
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-4-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-4-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:05 +0000
X-Stat-Signature: sr34jf63p8hhrgwy33xi7ccjb1ucf18i
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E57710000D
X-HE-Tag: 1794352328-966481
X-HE-Meta: U2FsdGVkX18MNMO236DYeNYs+7AYBpC6VN5sIOOnoa3yTD/RxJOYfacKxnpVKbEjvdJKl03Y5OTmsSe5vPSGg07xpx3VZcH9lgy3rFzI797RncxTlO72vw+ji3gJKij1diUF39b1MuZStGgPJG7n9m+SAe1ctEySbrNr7T70ODfxNCJoXuTZEYHtp6qx2bgYzxj5McnyqARdTnTLGAd0LayIJixpnfsb73zcRYKBpBQT9bh1PxRbtt5aExm9FsEoXRM4ntvdCUbmLURnOkhja4FjbZ2sXt+YkuTmItq2WSZFl0C7Pgrz5zxslJ11355HE5gjVqemTSfhE6uNtOjViUYTCBEJtckWI6NfQLoun6DjGvhcP+Xfuj/cn0V6jVNoeoGyCUIZQz2H7CmOZDxCaqbeIBFSVyx/F8GBNrRVRrdgkTFNrENEDHVWV8E4aN/EREv/XbX7goDvBuM9Z6MTd+yhqX03t0mSxPGhhdvKuku1Phv0rIJcp1bSsvjPNczJhOJIRNL6WwmPmW+cERfgUnhLR0rYb9AdclPAfhvkivFWtkdz+NqGASFOnAGjGH7z+3dRePYIdbnpDRIBo/KuCF+raESipZeswbyxZiZiCII31uPgP2arVZrlQ0aSe1pg5YvzvKLZeRxnQbVNqJ18nKLgChrbKFLVr/CcHQnNaKB8UCPjiZ0iZeB52CfJ7W8a/cpYmJnlwYCe5VS57w3I7zpt2Fvo3ewnJwATxFquPdhy5CuDcTqgZMeo3dViKSUixeeUbI6OWHvAVUIpjIsbDX51qSwOclpBVXFeqwflKJzq7kWgpkeT59y70DUPX6VRG7xgdiwuhJpPjnlFxDvusyp94zVaAy9fzYzYw1zg1l0JYj5pgxWz7DjDE+X87Y+q27DAQ8BurohTyPKXhGjRqy/UObEqYdDTs+kaMZ1MDM3ZZSzQMpLTCXYS4AhIDliK8ooatwCUgXBoE3kseAP
 SrdRETVU
 2IqV0Vbc2Vpi+0aVQ9vM0W2FMqCwZ4fOZqY+OyGVMqSdxuv+9yJGjX5EJbSzvTTWMN10YXo02tQWOsy3M20NFPciY9HYuzWEz2YEXDJquDyIrK46sdrNHyDlQUHY6opTMyNjj4hOfKtRiMa4+oEoRZPk1wE9DAyHtj28IGMzsfoGNv4yZEBeHDBPIvaYHautBVZ9QdH6oqRXq+bsxZXMMjxos4hu08MR4kOGd1945hdtM6vPuQ2SHepyYeE5Q75Ou75TDXGQercugY6ffUPIarH7acKssrVSeDlQLbA5+GPkLAjUVGFsEPAEV+eHS1grXBUd/1UeilA0aXje500aXRKg6tP8cKS/aeVLdZ5ZrNpawBLr3S8dIaFyNZBffuYnc14FNrAIYRztTSsB8OuoF6at3/9ZAvmt8jlGR1VUxncoMHpZo2OdKp+dORVkPyxy/KS82Bb+mFCN2GiMUCI7JFqnhMxl0hhrREjq5lC48Zlkxi64yyXLT5tpyWTe3bd1CHbcpUwkNrtXoyQlM7UaqTzNbQ1ZQq+w8dPA0Lj//6IgCo6Y9Z7oYzcPyufzrz/PINuzZk8fNrkR3o5XuhAJSqvdFBbqAFDS3p1sNJLG+/+naYOBchyrpCTpoPmdi1sxxQPktxvucOvRLC3/h2rZhjAmyoArNtX9lVW08
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
- [Medium] iommu/dma: pisa_reservoir_pop() schedules refill worker
  before backoff check
- [Medium] iommu/dma: fs_reclaim lock inversion on pisa_meta_mutex in
  __pisa_page_alloc()
--

commit 6907cf09179e9a96def9072a9cbbe4eddf0cc46c
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Add per-NUMA-node PISA page reservoir

This commit adds a per-NUMA-node reservoir of pre-allocated PISA pages to
serve non-blocking allocations, refilled and trimmed asynchronously by
per-node work items.

> diff --git a/drivers/iommu/pisa-node.c b/drivers/iommu/pisa-node.c
> new file mode 100644
> index 0000000000000..524f0d4457ad7
> --- /dev/null
> +++ b/drivers/iommu/pisa-node.c
[ ... ]
> +/* Allocate a PISA page from the buddy allocator and initialize its meta=
data. */
> +static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_=
block,
> +					   bool *clean)
> +{
> +	struct pisa_meta *meta;
> +	unsigned int memflags;
> +	struct page *page;
> +
> +	if (unlikely(!static_branch_unlikely(&pisa_key))) {
> +		if (!can_block || (gfp & (__GFP_FS | __GFP_IO)) !=3D (__GFP_FS | __GFP=
_IO) ||
> +		    pisa_meta_init())
> +			return ERR_PTR(-EAGAIN);
> +	}
> +
> +	/*
> +	 * Long-lived active pages must be unmovable, lowmem, non-compound, and
> +	 * must not dip into emergency reserves or trigger OOM/warnings.
> +	 */
> +	gfp &=3D ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE);
> +	gfp |=3D __GFP_NOWARN | __GFP_NOMEMALLOC | (can_block ? __GFP_RETRY_MAY=
FAIL : __GFP_NORETRY);
> +
> +	if (can_block)
> +		memflags =3D pisa_memalloc_save(gfp);
> +	page =3D alloc_pages_node(nid, gfp, PISA_ORDER);
> +	if (!page) {
> +		if (can_block)
> +			memalloc_flags_restore(memflags);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* Ensure the metadata chunk for this PFN is populated. */
> +	if (unlikely(pisa_meta_ensure_pfn(page_to_pfn(page), can_block))) {

[Severity: Medium]
Can this invert the lock order between pisa_meta_mutex and fs_reclaim when
called under GFP_NOFS, GFP_NOIO, or a memalloc_nofs_save() /
memalloc_noio_save() scope?

pisa_meta_init(), pisa_meta_memory_cb(), and GFP_KERNEL calls to
pisa_meta_ensure_pfn() perform GFP_KERNEL allocations while holding
pisa_meta_mutex, establishing pisa_meta_mutex -> fs_reclaim.

Here, can_block is gfpflags_allow_blocking(gfp), which is true for GFP_NOFS
and GFP_NOIO.  Although pisa_memalloc_save(gfp) sets PF_MEMALLOC_NOFS or
PF_MEMALLOC_NOIO, __pisa_page_alloc() still passes can_block =3D true to
pisa_meta_ensure_pfn(), which acquires pisa_meta_mutex when the metadata
page table is not yet populated:

drivers/iommu/pisa-meta.c:pisa_meta_ensure_pfn() {
    ...
	if (can_block && !pisa_meta_pte((unsigned long)pisa_meta_array + (idx << P=
AGE_SHIFT))) {
		int err;

		mutex_lock(&pisa_meta_mutex);
		err =3D pisa_meta_prealloc(pisa_meta_array, pisa_meta_nframes, pfn, pfn +=
 1);
		mutex_unlock(&pisa_meta_mutex);
    ...
}

In addition, the pisa_meta_init() check above tests raw gfp rather than
current_gfp_context(gfp), so a caller inside a memalloc_nofs_save() or
memalloc_noio_save() scope passing GFP_KERNEL will also take pisa_meta_mute=
x:

CPU0                              CPU1
----                              ----
lock(fs_reclaim)
                                  mutex_lock(&pisa_meta_mutex)
mutex_lock(&pisa_meta_mutex)
                                  lock(fs_reclaim)

 *** DEADLOCK ***

CPU0: fs/io path (holding lock waited on by reclaim) -> pisa_reservoir_pop()
      -> __pisa_page_alloc() -> pisa_meta_ensure_pfn() / pisa_meta_init()
CPU1: pisa_node_work_fn() -> pisa_meta_init() -> kvcalloc(..., GFP_KERNEL)

Passing current_gfp_context(gfp) into gfp at entry and only allowing the
mutex-taking paths when (gfp & (__GFP_FS | __GFP_IO)) =3D=3D (__GFP_FS | __=
GFP_IO)
would avoid this lock inversion.

[ ... ]
> +/* Refill node @nid's reservoir up to pisa_reservoir_max pre-zeroed PISA=
 pages. */
> +static void pisa_reservoir_refill_node(int nid)
> +{
> +	struct pisa_node *res =3D &pisa_nodes[nid];
> +
> +	while (res->nr_pages < READ_ONCE(pisa_reservoir_max)) {
> +		struct pisa_meta *meta;
> +		unsigned long flags;
> +		bool clean;
> +
> +		meta =3D __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true, &cl=
ean);
> +		if (IS_ERR(meta))
> +			break;
[ ... ]
> +struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
> +{
> +	bool can_block =3D gfpflags_allow_blocking(gfp);
> +	unsigned int max =3D READ_ONCE(pisa_reservoir_max);
> +	struct pisa_meta *meta;
> +
> +	nid =3D pisa_sanitize_nid(nid);
> +	if (max) {
> +		meta =3D pisa_reservoir_pop_node(nid, max);
> +		if (meta) {
> +			*clean =3D true;
> +			return meta;
> +		}
> +		/* Empty: pop_node() only schedules after a successful pop. */
> +		pisa_schedule_reservoir_node(nid);
> +	}
> +
> +	/* Back off briefly on GFP_ATOMIC if previous allocation on @nid failed=
. */
> +	if (!can_block && time_before(jiffies, READ_ONCE(pisa_nodes[nid].next_a=
lloc)))
> +		return ERR_PTR(-EAGAIN);

[Severity: Medium]
Does calling pisa_schedule_reservoir_node(nid) before checking
pisa_nodes[nid].next_alloc defeat the backoff for the refill work item when
the reservoir is empty?

When order-9 allocations on nid are failing under memory pressure or
fragmentation, a GFP_ATOMIC miss sets pisa_nodes[nid].next_alloc to back off
for 10ms.  However, every subsequent GFP_ATOMIC call to pisa_reservoir_pop()
during that backoff window still queues pisa_nodes[nid].work before hitting
the next_alloc check, and pisa_reservoir_refill_node() immediately breaks
out on __pisa_page_alloc() failure, allowing softirq callers to continuously
re-queue the worker and trigger repeated GFP_KERNEL | __GFP_RETRY_MAYFAIL
compaction attempts.

Checking next_alloc before pisa_schedule_reservoir_node(nid) (or having
refill failure also update next_alloc) would keep the worker from thrashing
during backoff.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D3

