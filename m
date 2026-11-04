Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49536606A855
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xp8gsT8H
Received: by kanga.kvack.org (Postfix)
	id 5C2D16B05B1; Wed,  4 Nov 2026 16:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E2A6B05B5; Wed,  4 Nov 2026 16:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413076B05B8; Wed,  4 Nov 2026 16:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1CE6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:21:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 967561C4233
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:21:07 +0000 (UTC)
X-FDA: 85398706974.03.0E2EF03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C727020006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:21:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp8gsT8H;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827265;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/TQid8xV0gnNZwKjqPwPCN/5lXjmaw1KYMmzJ7ir1E=;
	b=Ph6d5Lhb15+iooan+7Wicw/qPh66Uab6LaBlXZFApBqsH48888FfgV7e8hY3JOlaKB2D2k
	1EUFasLVWlsqUnVf5VPK/spF/ttr9islt4kPRkifucNAcgdhfmO8F2SB2zTLVgeZSu7Cn7
	tV5O+qCqtDwqoRlkWnSdXl2i0/5wheE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp8gsT8H;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793827265;
	b=fb+Cag7Vm/fCtIzhT3p+SPBP4FsBbKYIKtuw8nfJLJaacRqR8HTAMRh1Ib1WR2ts3YMYim
	VgdMaLdlhsQWdCaaAOUDC5Cd38CZ/IjvKSecmJPRb3+jomKQqRjr3UXOY/c0qVOHIvRfQM
	kJT9Jt4Rv5Eqo21gIZHkh6qv4Hs7Ou0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F12B142E22;
	Wed,  4 Nov 2026 21:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A801F0093A;
	Wed,  4 Nov 2026 21:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793827264;
	bh=q/TQid8xV0gnNZwKjqPwPCN/5lXjmaw1KYMmzJ7ir1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xp8gsT8HcoMSBeFcmF0bitRukER/yTYImU/cHZ8dD1ToVX0HcndNBHqyOI17t4Iin
	 JD8+QOT9iafOWKWL0O3L99ViP9fMB84lGmXflaD5MBKqQ+NBS3wmS6Ll1CZ+hkGxSH
	 AQPh/CJ7otlSE//KK6hgXqmoUy0S+cfJQ1tzf5RPjXC5b62n/Z5I/BldKwhuzrQVM9
	 VJw8mcoju5E54pZGvpfFlhgIHtdJH/pcbLh7dYuRxtiuGN7fyPs5q2s1qXQZtxXs1q
	 z3O65Zv3GZYYIsM9kCdNS9pz3I2TXVUKx4Nw4pMOQ910vH75oBes9DQQbo4xboshGL
	 Pxan721smZTAA==
Message-ID: <sashiko-outbox-198104@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
In-Reply-To: <20261103212004.1356327-5-joannelkoong@gmail.com>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:21:03 +0000
X-Stat-Signature: 4tc3za1cxh6nji8xy3wipx8eyjpgke38
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C727020006
X-HE-Tag: 1793827265-179238
X-HE-Meta: U2FsdGVkX1/dS/Hkw7/o6isYl/uA1i25S9Gqnzanmky7HhtUD3Lvv+bnXrwhT5V8WsF7dCdltjpIjpixElWc46qAaO0DDoKG+YkGq5x3jKtabsnerL+/8kQdSdVauZZchj+8ufu2+ku4UZp2mBV+8NhnJPI/njAlvYXH99kX1X8obgjmtJ85v7MH1vwtNN0OKAHgEg8/uI2X2JMR8WK3UpmBkJUPltfTmKxOySalnlhUq4k/OZ7xN1qqXujUvwoPK77AZhWfUzv+A7MyZiNeL+0kU9s2r6m872ONT4mnQpjcg89Of8NJzEUZBixcjlGjBZYgaWXYyLFBfGK6+9+uNSI/JbdKJoe2aHLTwnNb1on9vRA5yaX4xmE1EZ9Cyx99rE6/XIe8m22ns6xMDUCTJqV3/pN4SzRZMfz0Kp6qJP+k8T5ZzAn+p4cqLMnd73yC8pA0lBl85nmFReFX0hUrjuIb0iOIymmwZVhsb9cVhqPFEU3yxWUJe0256s7Jed87xr85V82D4wtrfie0HMi59+//UDbXb91SjWeoH/uX2UZpBOWefQVR0MSm/m7Ab2Hu8U7iGW/yqwZ/of1XSIReP6t6NgaaHyy89fkvswHzHtbLI/nnJPGTAqwTFMP9KLkIAmDWMZoZUp2ewMBea5LYzaVn5Aq+MiZLgGvBDwrAiygryoBj4HunDPWe+C1zLldwM9rErVZbRSYFWTbwjdCAB/5JDs6E34kGqqp4b9vnUt1ne24dPDV7lmelCQ3hurXcPxCxtLpwlJtzRHAjQj4YOWkSdQpfcZxP2SahCey9YO/TbpW817fQj0LP5pD3oPF2cyzVT231mZsACS18NXH2hrrcs4vXYX3RANLOGY9y1UHT7V59W+jmayy4sLYm50nr/Th1d7VdjYbkw5gIUAqwuFIg4L4Cbv6XGaZ+Ba3E98DLBBNrej8SpBbu00REGYUfhttxq4OoLct1nPz364j
 2aYZlx+j
 z1qLK7hbyFfwhZdxmZKUDvVi0t88jBpt0dxp2yTwhmk2LE8Wnk/0WTlm4bvZIirhsqlM0olLjHweD3tRTZ9TtsthZjVFHvdwGamHdPFktWCDkbinTnWp5lcmGG6W1BQeBQrF74v9A6V8aCTOYGxHtxHAxrSmP/nVLZ92kPDyQlLY5SIIhenO58fZZrB5I1qmu738+Hf6WJYad95MFfzxrZDK9TnYV+gRvDZ0lXRGfUgB+IXrsp5vmR90YSMfGN9r0v8ulo2o8ne1obCYHu2B9rlurfJtNFFnwPD6ESWzof8vGiJ6l1QFJo81Q2UvOvcWinkUvgLfEy7BzB/CYMQf0+jjtbPd6YAf0Uy9q2twpw+khTi/02WL2G/v3hzbHtc3KLhjr7Jj58XFabFnH0nDh/GBwrwIWCzvfC1SBWSJP76FNMI8TKxOlhCExtLQWrkca8TDIuPXOnc+iNbAe9Ka12tXQnUVFVCRvgAr33PlQiMNIZu+W+rkqPXlp2egpDhczJ9AmAFm4m/fCD2MrPDy7JTCAtzUKo6co8dG5pTCEuZop1pPdu/CpsBlLjVtbWw5TA6cd8c6vKZYR5RvNd+BPp4wwGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: try_to_migrate_one() triggers deferred_split_folio() on underu=
sed mTHP
--

commit 82b7b7063b986d802fe52e75e17211e58f3f420c
Author: Joanne Koong <joannelkoong@gmail.com>

mm: add anonymous mTHP folios to the deferred split list

This commit queues newly mapped anonymous mTHP folios of at least 2M onto t=
he
deferred split list in map_anon_folio_pte_nopf() so that underused mTHP fol=
ios
can be split by the deferred split shrinker under memory pressure.

> diff --git a/mm/memory.c b/mm/memory.c
> index 0c9ed04528d88..44376321180b5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, p=
te_t *pte,
>  	folio_add_lru_vma(folio, vma);
>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +	if (folio_test_large(folio))
> +		deferred_split_folio(folio, false);
>  }

[Severity: High]
When deferred_split_scan() splits an underused PTE-mapped mTHP folio queued
here with PG_partially_mapped left clear, doesn't unmap_folio() trigger a
false-positive deferred_split_folio(folio, true) transition during the spli=
t?

In deferred_split_scan(), the folio is first removed from the local dispose
list while PG_partially_mapped is still false:

mm/huge_memory.c:deferred_split_scan()
	list_del_init(&folio->_deferred_list);

	if (!folio_test_partially_mapped(folio)) {
		if (folio_test_mlocked(folio))
			goto next;
		underused =3D thp_underused(folio);
		if (!underused)
			goto next;
	}
	if (!folio_trylock(folio))
		goto requeue;
	if (!split_folio(folio)) {

split_folio() then calls __folio_split() -> __folio_freeze_split_anon(), wh=
ich
unmaps the folio before freezing its refcount:

mm/huge_memory.c:__folio_freeze_split_anon()
	if (folio_mapped(folio)) {
		anon_vma =3D folio_get_anon_vma(folio);
		if (!anon_vma)
			return -EBUSY;
		anon_vma_lock_write(anon_vma);
		ret =3D unmap_folio(folio);
		if (ret)
			goto out_unlock;
	}

	local_irq_disable();

	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
		ret =3D -EAGAIN;
		goto out_no_split;
	}

Unlike a PMD-mapped THP (where split_huge_pmd_locked() with freeze=3Dtrue
removes the entire PMD rmap in one folio_remove_rmap_pmd() call), an mTHP
folio is PTE-mapped, so unmap_folio() -> try_to_migrate() ->
try_to_migrate_one() removes its PTEs one subpage at a time via
folio_remove_rmap_pte().

On the first subpage unmapped while the remaining subpages are still mapped,
__folio_remove_rmap() sees partially_mapped =3D=3D true and
!folio_test_partially_mapped(folio) =3D=3D true:

mm/rmap.c:__folio_remove_rmap()
	if (partially_mapped && folio_test_anon(folio) &&
	    !folio_test_partially_mapped(folio) &&
	    !folio_is_device_private(folio))
		deferred_split_folio(folio, true);

Because folio->_deferred_list was emptied by list_del_init() in
deferred_split_scan() and the folio refcount is not frozen yet,
deferred_split_folio(folio, true) sets PG_partially_mapped, increments
MTHP_STAT_SPLIT_DEFERRED and MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, and re-adds
folio->_deferred_list onto deferred_split_lru.

Could this cause three problems?

1. Even when folio_ref_freeze() succeeds and __folio_freeze_split_anon()
   subsequently unqueues the folio and resets PG_partially_mapped, every
   underused mTHP split will also increment MTHP_STAT_SPLIT_DEFERRED in
   addition to MTHP_STAT_SPLIT_UNDERUSED.

2. If folio_ref_freeze() fails (for example due to a concurrent GUP pin, or
   because a second CPU running deferred_split_scan() isolated the re-queued
   folio via folio_try_get() while the remaining PTEs were still being
   unmapped), __folio_freeze_split_anon() jumps to out_no_split and remaps =
all
   PTEs via remap_anon_folio() without unqueueing the folio or clearing
   PG_partially_mapped. That leaves a fully mapped folio permanently marked
   PG_partially_mapped with MTHP_STAT_NR_ANON_PARTIALLY_MAPPED leaked.

3. If a second CPU running deferred_split_scan() isolates the re-queued fol=
io
   onto its local dispose list while unmap_folio() is still in progress, th=
at
   extra refcount causes folio_ref_freeze() on the first CPU to fail. When =
the
   first CPU returns to deferred_split_scan(), it sees !did_split &&
   folio_test_partially_mapped(folio) =3D=3D true and calls list_lru_add_ir=
q() on
   folio->_deferred_list while the folio is on the second CPU's unlocked
   dispose list, corrupting the list.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103212004.1356=
327-1-joannelkoong@gmail.com?part=3D4

