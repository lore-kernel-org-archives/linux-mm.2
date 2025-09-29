Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15627CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 06:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60ABE8E0005; Mon, 29 Sep 2025 02:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB5E8E0002; Mon, 29 Sep 2025 02:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA368E0005; Mon, 29 Sep 2025 02:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 336028E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 02:21:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4E5D1193EB
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:21:07 +0000 (UTC)
X-FDA: 83941290174.16.B543715
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id D397C4000B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:21:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USfRMIGE;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759126866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPlcwctVJa17AvuiwxVh/6RW6wt+NjqgznwU1ySTOQ4=;
	b=zNH9dEItVnhpMjoPl3Ru7xlQq4v1GMIroAGB2dM7Tefj7hJgvCD47oRC+c4nwj7mbofKdk
	dHPV+HucoPNUX31CWouO1WTJY1rSElGl5cBnzpiOCxH3EZazicaMhDGPDi9RrvAzjzjomY
	N4s1SoAe4FR0abYh3jLZpH34G3WD7Yc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759126866; a=rsa-sha256;
	cv=none;
	b=8dMkjL6YIW6pL5BMFTUxxEgB2UVdHgpMpVfF0V7I1diL5lJTxloDuoBKrqZv6OpQj2VZn3
	/XUjfdUBTn5AVhkvfsyMdCmgpQBVsIFDri/qfTZaN1nwn9Rk+X2ArqMb+q2VQ53LgaD4g0
	bMs8atP+V4e09eMAAHAwAzuuKluUr94=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USfRMIGE;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759126863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPlcwctVJa17AvuiwxVh/6RW6wt+NjqgznwU1ySTOQ4=;
	b=USfRMIGEHmHCVGO6HIWoOwjk2Btbyv0LZIpc8bsGpLdUoKp4ZcO8+SPsZECt0H6GWMKSDv
	teaqjscf8gMtHDHIRdHCx/moLTh+HDHIHGgSNYqzkBM5kImeJTHv7mjX73HK67oHx4HhYM
	nwrCRiVlA2Y9b78r26l5VOrp7AA0WJI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v3 4/4] mm: thp: reparent the split queue during memcg
 offline
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
Date: Mon, 29 Sep 2025 14:20:16 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@redhat.com,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com,
 npache@redhat.com,
 ryan.roberts@arm.com,
 dev.jain@arm.com,
 baohua@kernel.org,
 lance.yang@linux.dev,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2EC0CBCD-73FD-400A-921A-EAB45B21ACB8@linux.dev>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
 <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D397C4000B
X-Stat-Signature: ddcg9f4fsrrpgg7668cpgpa5mdzi61nc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759126865-408854
X-HE-Meta: U2FsdGVkX19ayEmJAZvUeXwoMZ/cIiCXkPfKFmGYBl7kEg/EGjpRPQipqrp4REPENM6/DBGrx3FdKQwKBEdHovlWAfeeLV0lgpmHexJmcQHQOo9HvposlYS+vRZkVYMWYWjFp4Ja3lExSdXpdE/GwAI/BJbq33pPfY2/oMXdKf2E/wYJBzBG4wzmlIG/wbU91Z7ilYyU/a+xDm6rtwvfEvclJPlxkbWGMsadAU7WzVm4x8/ZONvM4BF3hRy0OldeP7gqlpTVLWMVi154yBuMUTFv1wz2jmKauGgebdr4GqUu0HjI5fpXwPMbtuCGDKQQ582Lm79PZGy1QcWEa4Ed0xSgxnIcQj/M9PsX8TJGaRi2lUi/E0/ou3RVlnbA8b42jszZW+4+rqPQXPbv55nQTj1it35uilxLqymcE2lvDsb+MR10ODW9LfQGbUSZQ7EVk7EGqmlisXEOQFtehCrimGlAG0YtJwXMtz/er/5cAA/5Y8e1t1uXGBikIvwj0wJPS9O+dcKHWsEZSFdYLXd6Jch8+HnuYPVTBUMClVEmRj2MwPtjqehdryL1z7qvLuhX8htW8QWjPWB8MGudhrGT8kkqQW8AiTnge8sGLeMbPh9Mz28ZdzwCjLQGlH17mT32vrPhTZMNQaHEcoi5xIAZtGcN6LdJfpQG9/0mv10x1mB3qHj8nim8PpxFhTuhg2eiOof76r2udnj/p5uoIno15oWYAY5PRDZWD2dKl48kODObmIUjwrUz9D7ICXJIjDzVrJ0p1i8yuF3GEtVhSKrj2E0fUFvdk0blNTL6xHfjYDrU/C0PUufk4CPm6u3gRNTdoKBaVISZtv77dE0BWUI1RxfvbSoX6mhIIDIS9800fSrx1K+JNsKnYyvmUyn9WoFcpinlPHDaJ39uRyAldoj/QY89CpjF91P/e90u2w5HbeueHTJOYodcrFpD2W15YTPFUAxXShqMvZuc6uNjkOH
 miA6x4Jd
 TcApVMwtLIbzWtl630HBca6bV+Hw+jqk+zyN765P/l39Cbhwb4FTN8VEEG65JpEkVbFcOx15g/jALmMsoORPKde+8NPi0e71JkQ6vYfGHzWbmczarpmWrutNpgB0Rib/1ZHTaAasLddxoZei+KnZ30yG9fSfJL9bsf48jKsvNQWMIDalpVtye7Q7rgTK2wwBjXplnxEsnOeAA2gmafdAKXoqeJxAxfef5l7OpboHWihSk8U9iKpN9StIDHgYCYJMW8dzhvBwFyFzkMAnEkK5x0XzUONFCAwDf6/4x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 28, 2025, at 19:45, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> Similar to list_lru, the split queue is relatively independent and =
does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the same mechanism as =
list_lru
> to reparent the split queue separately when memcg is offine.
>=20
> This is also a preparation for reparenting LRU folios.
>=20
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> include/linux/huge_mm.h |  4 ++++
> mm/huge_memory.c        | 46 +++++++++++++++++++++++++++++++++++++++++
> mm/memcontrol.c         |  1 +
> 3 files changed, 51 insertions(+)
>=20
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc9852..0c211dcbb0ec1 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page =
*page)
> 	return split_huge_page_to_list_to_order(page, NULL, ret);
> }
> void deferred_split_folio(struct folio *folio, bool partially_mapped);
> +#ifdef CONFIG_MEMCG
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> +#endif
>=20
> void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> 		unsigned long address, bool freeze);
> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio =
*folio, struct page *page,
> }
>=20
> static inline void deferred_split_folio(struct folio *folio, bool =
partially_mapped) {}
> +static inline void reparent_deferred_split_queue(struct mem_cgroup =
*memcg) {}
> #define split_huge_pmd(__vma, __pmd, __address) \
> 	do { } while (0)
>=20
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bb32091e3133e..5fc0caca71de0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1094,9 +1094,22 @@ static struct deferred_split =
*folio_split_queue_lock(struct folio *folio)
> 	struct deferred_split *queue;
>=20
> 	memcg =3D folio_memcg(folio);
> +retry:
> 	queue =3D memcg ? &memcg->deferred_split_queue :
> 			=
&NODE_DATA(folio_nid(folio))->deferred_split_queue;
> 	spin_lock(&queue->split_queue_lock);
> + 	/*
> +	 * Notice:
> +	 * 1. The memcg could be NULL if cgroup_disable=3Dmemory is set.
> +	 * 2. There is a period between setting CSS_DYING and =
reparenting
> +	 *    deferred split queue, and during this period the THPs in =
the
> +	 *    deferred split queue will be hidden from the shrinker =
side.
> +	 */
> + 	if (unlikely(memcg && css_is_dying(&memcg->css))) {
> + 		spin_unlock(&queue->split_queue_lock);
> + 		memcg =3D parent_mem_cgroup(memcg);
> + 		goto retry;
> + 	}
>=20
> 	return queue;
> }
> @@ -1108,9 +1121,15 @@ folio_split_queue_lock_irqsave(struct folio =
*folio, unsigned long *flags)
> 	struct deferred_split *queue;
>=20
> 	memcg =3D folio_memcg(folio);
> +retry:
> 	queue =3D memcg ? &memcg->deferred_split_queue :
> 			=
&NODE_DATA(folio_nid(folio))->deferred_split_queue;
> 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> + 		if (unlikely(memcg && css_is_dying(&memcg->css))) {
> + 		spin_unlock_irqrestore(&queue->split_queue_lock, =
*flags);
> + 		memcg =3D parent_mem_cgroup(memcg);
> + 		goto retry;
> + 	}
>=20
> 	return queue;
> }
> @@ -4275,6 +4294,33 @@ static unsigned long deferred_split_scan(struct =
shrinker *shrink,
> 	return split;
> }
>=20
> +#ifdef CONFIG_MEMCG
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
> +{
> + 	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
> + 	struct deferred_split *ds_queue =3D =
&memcg->deferred_split_queue;
> + 	struct deferred_split *parent_ds_queue =3D =
&parent->deferred_split_queue;
> + 	int nid;
> +
> + 	spin_lock_irq(&ds_queue->split_queue_lock);
> + 	spin_lock_nested(&parent_ds_queue->split_queue_lock, =
SINGLE_DEPTH_NESTING);
> +
> + 	if (!ds_queue->split_queue_len)
> + 		goto unlock;
> +
> + 	list_splice_tail_init(&ds_queue->split_queue, =
&parent_ds_queue->split_queue);
> + 	parent_ds_queue->split_queue_len +=3D ds_queue->split_queue_len;
> + 	ds_queue->split_queue_len =3D 0;
> +
> + 	for_each_node(nid)
> + 		set_shrinker_bit(parent, nid, =
shrinker_id(deferred_split_shrinker));
> +
> +unlock:
> + 	spin_unlock(&parent_ds_queue->split_queue_lock);
> + 	spin_unlock_irq(&ds_queue->split_queue_lock);
> +}
> +#endif
> +
> #ifdef CONFIG_DEBUG_FS
> static void split_huge_pages_all(void)
> {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e090f29eb03bd..d03da72e7585d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct =
cgroup_subsys_state *css)
> 	zswap_memcg_offline_cleanup(memcg);
>=20
> 	memcg_offline_kmem(memcg);
> + 	reparent_deferred_split_queue(memcg);

Since the dying flag of a memcg is not set under split_queue_lock,
two threads holding different split_queue_locks (e.g., one for the
parent memcg and one for the child) can concurrently manipulate the
same split-queue list of a folio. I think we should take the same
solution like list_lru does to fix this.

Muchun,
Thanks.


> 	reparent_shrinker_deferred(memcg);
> 	wb_memcg_offline(memcg);
> 	lru_gen_offline_memcg(memcg);
> --=20
> 2.20.1
>=20


