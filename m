Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35680606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nmu/QP69
Received: by kanga.kvack.org (Postfix)
	id 2BAF66B05B1; Tue, 10 Nov 2026 21:41:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BFC6B05B2; Tue, 10 Nov 2026 21:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184006B05B3; Tue, 10 Nov 2026 21:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8E936B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:41:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22600A01EE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:41:53 +0000 (UTC)
X-FDA: 85421288106.25.5D94EA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66FB0100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:41:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nmu/QP69";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794364911;
	b=LweSPH9mhXV7ZA+rcq3vTrAfm4HrCW4XbHVCUwz0PImtwSCnKrF4fp78kViV0wkEF0B+EX
	ChPAYi3TdOFOuwUwiUCgw+LsubOU9dsWVDYTUDipKjrLMng02hac/4vP39uSgDbf8Nu7f3
	0vje9P8yBpCSeRmvYtwPUGJ7K7zEZtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794364911;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95hXCrcZmE/WUVa4aoCK/ZoD63AwIy0CF7l5eRB1f60=;
	b=2yJcIQJgsZu9HH1B4RrG34rzYeTfWcxSMWP/oTGFcxb+WSS85uNxshOQK0U0xhhCaKO/wx
	TbxGu4MOfafF4md3+QDO8JY3PxKegyPmFOAkP/IXqd6xq2hAFhXVFELr5oqP0XV3L+YSJn
	RTPU6CD0FG7c2RmkMpmFXfBKZgirE78=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nmu/QP69";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D012741905;
	Wed, 11 Nov 2026 02:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3D51F0089F;
	Wed, 11 Nov 2026 02:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794364909;
	bh=95hXCrcZmE/WUVa4aoCK/ZoD63AwIy0CF7l5eRB1f60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nmu/QP69iQcqGFVQAz7hgdusoYdKepNkF3edTowwJDX2Cpjjx7IILMIGqles/b4zf
	 b/XdXr0Gdn0zD3KENdMgZSB1G4Bdwge2IF9uei0yw23WlVOCkemhHW9XGv9EUEV5yf
	 n/XL9sqOH2HvZtbZAcRi3nfRhoNAj4HYz9OL+qK4bafP75aRKn/wYFvD3R3BBik5po
	 KnS2bCDxEw16nOwbNTF/tndxH9Vk3NcnMtBG1GG/l+rd1LnR81VnKqNH9Bx3oNDVeS
	 P2EqyKjFlL7mksZZNWeEsULNwhxAcMd8Y23fNRN3e+74/iQkjhByJJXs6xLv46vtpf
	 DwtE9qt1d+R5w==
Message-ID: <sashiko-outbox-208107@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 18/25] iommu/dma: Migrate user pages into PISA
 for TX zerocopy
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
In-Reply-To: <20261109182533.3594984-19-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-19-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 02:41:47 +0000
X-Rspamd-Queue-Id: 66FB0100005
X-Rspamd-Server: rspam12
X-Stat-Signature: bm45i8am4aufa3kds8rnmuh7i3w7f7ai
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794364911-497812
X-HE-Meta: U2FsdGVkX1/znIKhnRa7PqnUwEJsrHww9IA+wP2WLFSFXppdZaPfJp/NwaQ4gsr/YyVvOodbRnc0SaxlzXu7IWxuIKG2+J2tXw+RQwzysSm1sokIhzc/EEQuBhrIMcL14XF/KdTi8K+VbLW49jErf4x1/rJQybgAPuPZTJkMFlamsjlAhCy1Et+b4quQ2Uw5djltIidqP+wpPlpgJI+1Kjg07jULSJukWP5J5BAQjk5GJycxRbUusz9OP1mPtmOS+EmMjGCmUoSYVnUhUVycWctnEzkwRk60ullcpscM4jCzAA6iHOd4p5WqK0Hn2dZVdeBrDKT1lTkHHJkEAn13o8YendzdLMyq+l6thgeSNgfkw/6QKfUaBi9bGr3XxFFL+eBYS4z0pLfMMKu9bkTgjfEvB/80lhKgQ0JbOYg2EtDFGH1GSn1CkuJmhmkktLDFPoYCUvyTKMJXjPvuN1DQ1f5qagxlxavNUMgHTlyj1rPhG9m4+2Lw9B0JlCprNI8KlrogWk9+RtdjE4hpEgAfYO7sHE2EXw6x193S2vbDdIA9fNUJWxG9nrPPsJbe49yTcODpqmVxGlHijckuOo+nxApizyKacAspYbEXfNFcvwz+CXoQijjeSDd0aygpFdXmjlkG/T4VFVzDWfuLs4kkO71Dsd5n9HCMv1t7HAfXHcRafXeOOV4ZbrAFSejmAmphsfjt4IstBHk2ODhp+icyddnRM58b64efJBO4R48A0aJoCivyazHoEip9XYUke+fJotQ3PBbB4KT23iJbHdn4HDs1P9Oil7TTmCnyELV5JHAh8mJPOkfFyIquD/jfJxJ58NDjtpQA+PnhEyNeWzWmthGkkM0YE/ML6nxbXldkZGnzrN0pvSeJ1pLY6AJoWfAJ0Hspv3FXYt2USopHX2CeLp+GEky23le4R9PSc9408au2vckKwIaQQ2IcW23DauFD+Q2jR6/Rmol41m5W+/J
 M/l5VKZc
 S4rw3yxkFENLQepf6JAJyuu5p8nuzj66P9g3Si+VDb6dKstvRHnFaaGlpAWkmxa9CUwA73zAhZBBX1SDR6NEWuto8ktlpy4BGNSWyYxsa00oLkBtTafKZQvTTSpwUod6e3ffmlQQ6yrNIU4kugIT+CkOanUZ3qD9mcbjlbSyN7p78lC2Z/E7E54plsLszu8EgOLUaaqaSjAdxXbcNyr9h0Zn/yWQaRs2W1IimrKMlLYv31MuvhEIV0d/4yjfCM55yaFmMwP6DEMzu72ccOCgkJJYC2c6KcMe3VWRe4s1GxKBRk/GWGFDCuYkdhCnKnaOPBpWAY4EVUZsqQ7tFvI6ZZYNPOO4lNMxO0KCCGeOPuQJZODqV3yd0yN3G+QsDzTS5JlvC4B4zYZUw0NQ8U5MCe/tmiYm/sm7MUpw1G56wBQtjB+3IGtH0O/uhG4FmVIOB2zZvAnZtvlLcTK18itFwFyO77xjP4IcyexCbz7SStmWH/iDQlym3otHgLmWTdA/u/CnkE0W2ffIE91I3WSr104XOvuamEh636OBS9/YXyVAg+viQBIpZ3TO2IdEkr7YoSWjeHEwU9BpTV3Zu0v6ePUVMZdjQgh/+JUlWBp/VuRWc+8NsngN8GJrPrhP5zH+6Sea0Ve9e55yQBjl28qVoXKJPIfaqeXcaFaiMgzzx0gaeRU/A0/3ZeB3pZQTcmi2zq1VzI+uh+CULB0qkOCZmmBr3elxnZKEeWj8EENhTzEd9BOE3/E5yIFSBd87arlHLjCcsr2ce/hzT6Rew01988jI9/9OmCr4nc6quosutlkDx1t7oFtsfNKzCZIX7cGZPxoRP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] iommu/pisa: unkillable PAGE_SIZE walk under mmap_read_lock in
  pisa_madvise()
- [High] mm/madvise: missing MADV_PISA definitions on alpha, mips,
  parisc, and xtensa
- [Medium] iommu/pisa: alloc_tag corruption via pgalloc_tag_swap() in
  pisa_user_migrate()
- [Medium] iommu/pisa: pisa_user_max_4k_pages not restored on error in
  pisa_user_max_set()
- [Medium] net: pisa_zc_iter() migrates user pages before checking
  dst_tx_pisa_ok()
--

commit e8400c9a631094526a61a414ed9c1bc933634c72
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Migrate user pages into PISA for TX zerocopy

This commit adds support for migrating private anonymous order-0 user pages
into per-node PISA allocators via madvise(MADV_PISA / MADV_NOPISA) and
automatically during MSG_ZEROCOPY transmissions.

> diff --git a/drivers/iommu/pisa-user.c b/drivers/iommu/pisa-user.c
> new file mode 100644
> index 0000000000000..a16909d429aca
> --- /dev/null
> +++ b/drivers/iommu/pisa-user.c
> @@ -0,0 +1,278 @@

[ ... ]

> +static int pisa_user_max_set(const char *val, const struct kernel_param =
*kp)
> +{
> +	unsigned long max_pages;
> +	int ret;
> +
> +	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +		return -EOPNOTSUPP;
> +	ret =3D kstrtoul(val, 0, &max_pages);
> +	if (ret)
> +		return ret;
> +	WRITE_ONCE(pisa_user_max_4k_pages, max_pages);
> +	if (max_pages) {
> +		if (!pisa_nodes[first_memory_node].pa[0][0])
> +			return 0;
> +		if (!pisa_user_init())
> +			return -ENOMEM;
> +		static_branch_enable(&pisa_user_key);
> +	} else {
> +		static_branch_disable(&pisa_user_key);
> +	}
> +	return 0;
> +}

[Severity: Medium]
Does this leave pisa_user_max_4k_pages updated if pisa_user_init() fails and
returns -ENOMEM?  Sysfs will report the new non-zero limit after the write
failed, and a later madvise(MADV_PISA) call can then succeed in
pisa_user_init() while pisa_user_key remains disabled.

[ ... ]

> +/* new_folio_t for migration into PISA memory. */
> +static struct folio *pisa_user_new_folio(struct folio *src, unsigned lon=
g private)
> +{
> +	struct pisa_user_mtc *mtc =3D (void *)private;
> +	int nid =3D folio_nid(src);
> +	struct page *page;
> +
> +	if (mtc->budget <=3D 0)
> +		return NULL;
> +	page =3D pisa_alloc(pisa_nodes[nid].user_pa, mtc->gfp);
> +	if (!page)
> +		return NULL;
> +	if (pisa_meta_of_pfn(page_to_pfn(page))->flags & PISA_DECRYPTED) {
> +		put_page(page);
> +		mtc->budget =3D 0;
> +		return NULL;
> +	}
> +	mtc->budget--;
> +	return page_folio(page);
> +}
> +
> +/* new_folio_t for migration out of PISA memory: allocators never serve =
these. */
> +static struct folio *pisa_user_old_folio(struct folio *src, unsigned lon=
g private)
> +{
> +	return __folio_alloc_node(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN, 0, folio=
_nid(src));
> +}
> +
> +/* Migrate the isolated folios on @list; failures are put back. */
> +static void pisa_user_migrate(struct list_head *list, bool to_pisa, gfp_=
t gfp)
> +{
> +	struct pisa_user_mtc mtc =3D { .gfp =3D gfp, .budget =3D LONG_MAX };
> +	enum migrate_mode mode =3D MIGRATE_SYNC;
> +
> +	if (list_empty(list))
> +		return;
> +	if (to_pisa) {
> +		mtc.budget =3D pisa_user_budget();
> +		if (!gfpflags_allow_blocking(gfp))
> +			mode =3D MIGRATE_ASYNC;
> +	}
> +	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_f=
olio,
> +			  NULL, (unsigned long)&mtc, mode, MR_SYSCALL, NULL))
> +		putback_movable_pages(list);
> +}

[Severity: Medium]
Does migrate_pages() corrupt page allocation profiling counters when
CONFIG_MEM_ALLOC_PROFILING is enabled?

When a 2MB PISA page is allocated in __pisa_page_alloc() and split in
split_page_compound(), pgalloc_tag_split() assigns __pisa_page_alloc()'s
alloc_tag to all 512 blocks, and __pisa_free_page() recycles individual
blocks without calling pgalloc_tag_sub().  However, migrate_pages() calls
folio_migrate_flags() -> pgalloc_tag_swap(dst, src).  Migrating a user folio
into a PISA block swaps __pisa_page_alloc()'s tag onto the old buddy folio
(which is immediately freed, decrementing __pisa_page_alloc()'s tag while
the PISA block is still allocated) and places the user folio's tag onto the
PISA block, where it is never decremented when __pisa_free_page() recycles
the block.  Migrating out via MADV_NOPISA similarly leaves
pisa_user_old_folio()'s tag stranded on the recycled PISA block.

[ ... ]

> +int pisa_madvise(struct vm_area_struct *vma, unsigned long start, unsign=
ed long end, bool to_pisa)
> +{
> +	gfp_t gfp =3D GFP_USER | __GFP_NOWARN;
> +	struct folio_walk fw;
> +	unsigned long addr;
> +	unsigned int n =3D 0;
> +	LIST_HEAD(list);
> +
> +	if (vma->vm_flags & (VM_SHARED | VM_IO | VM_PFNMAP | VM_HUGETLB))
> +		return -EINVAL;
> +	if (to_pisa && !pisa_user_init())
> +		return -EOPNOTSUPP;
> +	lru_add_drain();
> +	for (addr =3D start; addr < end; addr +=3D PAGE_SIZE) {
> +		struct folio *folio =3D folio_walk_start(&fw, vma, addr, 0);
> +
> +		if (folio) {
> +			if (pisa_user_want(folio, to_pisa) && !pisa_user_busy(folio, 0) &&
> +			    isolate_folio_to_list(folio, &list))
> +				n++;
> +			folio_walk_end(&fw, vma);
> +		}
> +		if (n =3D=3D PISA_USER_BATCH) {
> +			pisa_user_migrate(&list, to_pisa, gfp);
> +			n =3D 0;
> +		}
> +		cond_resched();
> +	}
> +	pisa_user_migrate(&list, to_pisa, gfp);
> +	return 0;
> +}

[Severity: High]
Can an unprivileged user stall a task in an unkillable loop holding
mmap_read_lock by calling madvise(MADV_NOPISA) or madvise(MADV_PISA) on a
multi-terabyte unpopulated anonymous mapping?

Unlike walk_page_range_vma(), which skips empty PGD, P4D, PUD, and PMD
entries at once, this loop steps by PAGE_SIZE across the entire [start, end)
range and calls folio_walk_start() on every 4KB address without checking
fatal_signal_pending(), and MADV_NOPISA reaches it even when
pisa.user_max_4K_pages is 0.  Using walk_page_range_vma() or checking
pisa_user_enabled() and fatal_signal_pending() would avoid walking empty
page table levels and allow SIGKILL to abort the walk.

> diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-ge=
neric/mman-common.h
> index ef1c27fa3c570..c4332db8e56ff 100644
> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -81,6 +81,8 @@
> =20
>  #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
>  #define MADV_GUARD_REMOVE 103		/* unguard range */
> +#define MADV_PISA		210	/* move pages into PISA memory */
> +#define MADV_NOPISA		211	/* move pages out of PISA memory */

[Severity: High]
Does mm/madvise.c fail to build on alpha, mips, parisc, and xtensa?

Those four architectures do not include asm-generic/mman-common.h in their
arch/*/include/uapi/asm/mman.h headers, while mm/madvise.c references
MADV_PISA and MADV_NOPISA unconditionally.

> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index ecc30a6f83023..40f20d0faa859 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c

[ ... ]

> +static bool pisa_zc_iter(int *ret, struct sk_buff *skb, struct iov_iter =
*from, size_t *length,
> +			 const struct sock *sk, struct page **pages, int max_pages,
> +			 unsigned int orig_len, size_t *start, ssize_t *copied)
> +{
> +	unsigned int i, nr;
> +	ssize_t keep;
> +
> +	if (!pisa_user_enabled() || !user_backed_iter(from))
> +		return false;
> +
> +	/* Move user pages into PISA memory, then look them up again. */
> +	if (pisa_upgrade_user_pages(pages, DIV_ROUND_UP(*start + *copied, PAGE_=
SIZE))) {
> +		iov_iter_revert(from, *copied);
> +		*copied =3D iov_iter_get_pages2(from, pages, *length, max_pages, start=
);
> +		if (*copied < 0) {
> +			*ret =3D -EFAULT;
> +			return true;
> +		}
> +	}
> +
> +	/* Only TCP (which sets skb->sk at transmit time) handles short appends=
/-EXDEV. */
> +	if (!sk || skb->sk)
> +		return false;
> +
> +	/* Only plain MSG_ZEROCOPY ubufs (not io_uring/vhost/devmem). */
> +	if (skb_zcopy(skb) && skb_zcopy(skb)->ops !=3D &msg_zerocopy_ubuf_ops)
> +		return false;
> +
> +	/* Egress device must have pisa_tx_bufs enabled so the copy uses a PISA=
 page_frag. */
> +	if (!dst_tx_pisa_ok(__sk_dst_get(sk)))
> +		return false;

[Severity: Medium]
Should pisa_zc_iter() check sk and dst_tx_pisa_ok(__sk_dst_get(sk)) before
calling pisa_upgrade_user_pages()?

Calling pisa_upgrade_user_pages() first migrates user pages into PISA even
when the egress device has pisa_tx_bufs disabled, when sending over
loopback or virtual devices, or when the socket is routed over IPsec
(where __dst_tx_pisa_ok() excludes dst_xfrm(dst) to keep plaintext out of
shared 2MB PISA pages).  Because __iommu_dma_map() checks is_pisa_phys()
rather than dev->pisa_tx_bufs, migrating pages on a device with
pisa_tx_bufs disabled also causes pisa_map_phys() to install 2MB PISA IOMMU
mappings on that device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D18

