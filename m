Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2C9606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcubKSVw
Received: by kanga.kvack.org (Postfix)
	id 3C4336B05B2; Mon, 26 Oct 2026 22:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375476B05B3; Mon, 26 Oct 2026 22:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DBD6B05B4; Mon, 26 Oct 2026 22:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04E836B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E602C0840
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:15 +0000 (UTC)
X-FDA: 85366892310.05.2F8BBBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCA47A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcubKSVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069774;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mtzORFgRbV/SuDBU42/JLx41iu5mnXbwCtrTfiMv3Q=;
	b=TqGfzkkVPrB9uO0oAFKyPwpIEsHrjTrBSWPSVgWgw92OkM5DLx59gYwDKSy+mCqFrJi+qc
	DVDroyJBOaWQoST5myoEWEgRKm6HMs5DED+Sy2HO0DXeLuezDeEwowQFgnRSaSobAl2jUV
	le+2tU93irtSUKv6DC3I7nXTRFD0rB0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcubKSVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069774;
	b=FU6otOqdNl+NkEEK43IHmY/lhO7Q+mi2BJgTxBt53sm951EqpxqUEio2d+hhQd6Dp1IYAJ
	1LYvYfwnqPaA9XZFBUxjdQniek1EYgDvkSkSk2vMuuV8yqjWsBTMEwEaionNByndifWrC9
	QVk019W6pf9yGQV0zOc+yj8njIiPTyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F27CE43218;
	Tue, 27 Oct 2026 02:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327051F01829;
	Tue, 27 Oct 2026 02:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793069772;
	bh=8mtzORFgRbV/SuDBU42/JLx41iu5mnXbwCtrTfiMv3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WcubKSVwTY76Ze+tRH2AcDmfF3XA3rcgoutYCeOCLqdpkqUxKYzEyOGU84j7uJEwX
	 st9yLs9fmylMkpaLNNS208i2mABzybsdB92AeDOk/e3RJHpyd8u/KsukKdL9/4SKBI
	 NUD+dRn3vClE1obDl9TyiKUyIQTQr2g9Wa3orME5AY1Fh7lDbhnQ/wHoN2IhTBitMC
	 N1PNYEcL4b6PQif18xuaNpflw9Fu30xIGilkdIG+v7W+VJaZk9P3M+UUEdgFsQDKW/
	 wFjQfpcLmVRLUWvEXsMXWO4WQWznZYHm+UlwZABTLI0mkUYMxQZB1fYmRPlitK2eMs
	 E9S/wUSckVAUw==
Message-ID: <sashiko-outbox-186035@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] mm/migrate: refuse to migrate folios containing
 hwpoisoned pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuanhe Shu" <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: david@kernel.org, =?utf-8?b?SHVhbmcsIFlpbmc=?= <ying.huang@linux.alibaba.com>, "Kaitao
 Cheng" <kaitao.cheng@linux.dev>, vbabka@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com, tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org
In-Reply-To: <20261026025552.1427901-3-xiangzao@linux.alibaba.com>
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
 <20261026025552.1427901-3-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:56:11 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCA47A0006
X-Stat-Signature: 1hihowbjzehr7nzph9aqa3rucesut974
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069773-955571
X-HE-Meta: U2FsdGVkX18NKih52V19JZCw41gKydpvWKxsSteiSsaVn95bEBqpGh+UuhCMn4C6sH61oiRXtZd09hljWsSH14wUAd9vsofIP/tOjkWYvQ8nR/tSEz10no6K6CJLnJNX8IdXNAPDow1aoHwbsuAph6HoTvMV19sx5+sRgUlpVY6RGLS9ICjqi4VpqtIPS1GyL72w7zyUm7ROpjnviZkpfum7l4jdUmhWO03KOpPMgN8KG66MI98vWj0Rh6EDOMedkQ6WAoWulqu236KdY6kx0NHyAWU+fVJcDsH5V4MVA33evSSOjuPDkxZE+kVg7jWFAoGa/LkRpPITo3cTY2p+XulJ6nQGT83huUaU20NtIYRn6qP8MuuHsm2zwxoi54tQm3XWvk9YYK2btgo4pghqm1KV9k9B5LlahmjWn+DTc/VgtQ8M4Dk0iIxk+OL0vGr2xSD3nm9tYNqz33UBqvujpGjIklftZr0PwrY47xv8v/H8EwYe9z5HbTpSw15bB8tL9/IakvEXglHgeQKy6Wgfl6Vnu7ZVTYY04100Z44ttcW4YQF31XvX00AdQmkEeh6cEGMjUr1M+g3WqUrpunX3grK9z4vOdsKRM6OgzeABHfA1QWSWv+e8xpZVUqibBOsT/Ne/cm80beir0cPnrh3p/4xUQ61BoCkSBzKq27J9Nf5YHAiWSgYqc46EyNqEjYOa4Xp+WMzQXaaVWz5i7lEkMOv1K96br0WvRCeGSG4s0d/5Wg2jGTPeYcRc8omNp7TDNTtzDvQbXoW5Tsg0hwef1EvPJN0P0TTJXc2Dc5z+970BdPoyXf0Q+jKYYUvAd07j2ajygZbaKxm6+rd2KqhMm6THor9zkjAJ5BCsIGCeqBvFkeshwWnVFMF86O8S0Il7JB9CfuMFpphGnAI5Fei+a7w03u0yEGV5s3cgjIflivKHenMHjwDoxlXN6yZFWSoawKtmtVSdp/iVB6o0yfI
 ydZhVLiW
 /3cDquQ2nxNmPdHdc1mNmYMXvR3ARla00JLCvYT1ebjS5bevDjXSwntfrRcHL15eh1GQf4NbC4eZCFSg5gei2U5ognID2zCdklhN7rx1FPP4Y3RX8QajAl9+ycVzpYzjC+OlUfWbXlY8L4UVkG3vxw3sM89+Y9XkDQJnLLFCcSONeoJJ9wgay0njdhSLFR+MFlR6chG94Oq+VY9YQRu7iHgW+dYsf3XgHVOAaDxVtyU25+evflNnISEFPw4XGOM4A3juPp9fZ54HKz+t/aI8RM1WhFqxEopK0zRBuz/6c3aJWHVV9iciqhHWrQ8uMurYaajof4kp4AMmLrNdmQYdMJKRTDjbNUd2prxX4ehXoCMMXTkRG1mjnriudX4N09e6q9sQ+02BO6lhA3dZlMO/fgB5mXfsbCnV1OP6On0JqvXhutH8d0Z44YOcdRYYwWgGZeKodc/fRV0twhP4i+sgesbE22ukkvgCE4EmY0tTc+WnBrzfn6d3Srdf9jrwwNG+QliP3a9/7K5nD71vSBttN17hMFQJZttE7Dsh1u+xCXdu0FZMHD77iCwfLRXnpag8nZPH0zisDT/D80Idz4+fQS9PCbr5Rp2BtMzAUANF3WDCw2vQ5gCMFJO0hT3fyGx0SrChnuoJScJouqrniYQmQJIRDsLoFdPMZgxvoJJCa1VszQOKkkgxCPplRflTVbKyBzEoJEbJcHmsLWNsSqSMszI/ZeJClzx5m1JpC
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
- [High] mm/migrate: folio_contain_hwpoisoned_page() misses poisoned large =
folio tails
- [High] mm/migrate: hugetlb -EHWPOISON putback sets HPG_migratable and ski=
ps unmap
--

commit acde5bc8e89d5c66775184576ff11220f73371d5
Author: Yuanhe Shu <xiangzao@linux.alibaba.com>

mm/migrate: refuse to migrate folios containing hwpoisoned pages

This patch adds folio_contain_hwpoisoned_page() checks at entry, before cop=
y,
and after copy in the standard and hugetlb folio migration paths so that
folios raced by memory_failure() fail migration with -EHWPOISON instead of
copying corrupted data into a fresh destination folio.

Link: https://lore.kernel.org/r/20260707090136.52904-1-kaitao.cheng@linux.d=
ev/

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa7..208a3991ca061 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c

[ ... ]

> @@ -881,6 +889,14 @@ static int __migrate_folio(struct address_space *map=
ping, struct folio *dst,
>  	if (unlikely(rc))
>  		return rc;
> =20
> +	/*
> +	 * Recheck after the copy: an injector can set the flag while the
> +	 * copy is in progress.  The mapping has not been transferred yet,
> +	 * so failing here is the same unwinding as a copy failure.
> +	 */
> +	if (unlikely(folio_contain_hwpoisoned_page(src)))
> +		return -EHWPOISON;

[Severity: High]
Does folio_contain_hwpoisoned_page(src) here (and in migrate_folio_unmap()
and migrate_folio_move() below) catch a race where memory_failure() hits a
tail subpage of an isolated non-hugetlb large folio (THP or mTHP)?

In include/linux/page-flags.h, folio_contain_hwpoisoned_page() only checks
PG_hwpoison on the head page and PG_has_hwpoisoned on the folio:

static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
{
	return folio_test_hwpoison(folio) ||
	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
}

When a large folio src has already been isolated from the LRU by migration
(clearing PG_lru) and memory_failure() runs on a tail page p (p !=3D &src->=
page),
memory_failure() sets PG_hwpoison on that specific tail page via
TestSetPageHWPoison(p) (which has PF_ANY policy) and then calls
get_hwpoison_page(p, flags) -> get_any_page(p, flags). Because PG_lru is
clear on src, HWPoisonHandlable() returns false, get_hwpoison_page() fails
(even when MF_COUNT_INCREASED is set, after dropping the reference and
retrying), and memory_failure() exits with MF_IGNORED before reaching
folio_set_has_hwpoisoned(folio):

mm/memory-failure.c:memory_failure() {
	if (TestSetPageHWPoison(p)) {
		...
	}
	...
	res =3D get_hwpoison_page(p, flags);
	switch (res) {
	...
	default:
		res =3D action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
		goto unlock_mutex;
	}
	...
	if (folio_test_large(folio)) {
		...
		folio_set_has_hwpoisoned(folio);
}

Similarly, if get_hwpoison_page() succeeded before PG_lru was cleared or via
debugfs corrupt-pfn while migration already holds folio_lock(src),
memory_failure() blocks on folio_lock(folio) before setting
PG_has_hwpoisoned.

Because neither the head page's PG_hwpoison nor the folio's
PG_has_hwpoisoned is set in this window, all three
folio_contain_hwpoisoned_page(src) checks in migrate_folio_unmap(),
migrate_folio_move(), and __migrate_folio() return false, and folio_mc_copy=
()
copies each subpage without checking PageHWPoison(folio_page(src, i)). Won't
migration still copy the poisoned tail page into dst without a poison marker
and free src back to the page allocator with PG_hwpoison left set on its ta=
il
page?

[ ... ]

> @@ -1521,6 +1555,12 @@ static int unmap_and_move_hugetlb_folio(new_folio_=
t get_new_folio,
>  		goto out_unlock;
>  	}
> =20
> +	if (unlikely(folio_contain_hwpoisoned_page(src))) {
> +		/* Same reasoning as in migrate_folio_unmap(). */
> +		rc =3D -EHWPOISON;
> +		goto out_unlock;
> +	}
> +
>  	if (folio_test_anon(src))
>  		anon_vma =3D folio_get_anon_vma(src);
> =20
> @@ -1546,8 +1586,13 @@ static int unmap_and_move_hugetlb_folio(new_folio_=
t get_new_folio,
>  		was_mapped =3D 1;
>  	}
> =20
> -	if (!folio_mapped(src))
> -		rc =3D move_to_new_folio(dst, src, mode);
> +	if (!folio_mapped(src)) {
> +		/* Same reasoning as in migrate_folio_move(). */
> +		if (unlikely(folio_contain_hwpoisoned_page(src)))
> +			rc =3D -EHWPOISON;
> +		else
> +			rc =3D move_to_new_folio(dst, src, mode);
> +	}

[Severity: High]
What happens to a hugetlb folio when unmap_and_move_hugetlb_folio() (or
migrate_huge_page_move_mapping()) fails with -EHWPOISON and puts src on the
ret list for putback_movable_pages()?

When src was isolated via folio_isolate_hugetlb(), HPG_migratable was clear=
ed.
If memory_failure() races during isolation (for example without
MF_COUNT_INCREASED via hardware MCE or corrupt-pfn),
try_memory_failure_hugetlb() -> get_huge_page_for_hwpoison() calls
hugetlb_update_hwpoison(src, page), which sets PG_hwpoison on src, and then
returns MF_HUGETLB_RETRY so memory_failure() gives up with MF_IGNORED witho=
ut
unmapping src.

When unmap_and_move_hugetlb_folio() then returns -EHWPOISON (after restoring
migration PTEs to src if it was mapped), putback_movable_pages() calls
folio_putback_hugetlb(src), which unconditionally sets HPG_migratable back =
on
the poisoned hugetlb folio:

mm/hugetlb.c:folio_putback_hugetlb() {
	spin_lock_irq(&hugetlb_lock);
	folio_set_hugetlb_migratable(folio);
	list_move_tail(&folio->lru, &(folio_hstate(folio))->hugepage_activelist);
	spin_unlock_irq(&hugetlb_lock);
	folio_put(folio);
}

Doesn't this cause two problems for hugetlb folios?

First, hugetlb folios are not reclaimed by vmscan, and any later
memory_failure() call on src sees PG_hwpoison already set in
hugetlb_update_hwpoison(), returning MF_HUGETLB_PAGE_PRE_POISONED or
MF_HUGETLB_FOLIO_PRE_POISONED so get_huge_page_for_hwpoison() exits early
with -EHWPOISON without ever unmapping src or clearing HPG_migratable.

Second, get_huge_page_for_hwpoison() explicitly clears HPG_migratable on
hwpoisoned hugepages to prevent memory hotremove from trying to migrate the=
m:

mm/memory-failure.c:get_huge_page_for_hwpoison() {
	rc =3D hugetlb_update_hwpoison(folio, page);
	if (rc >=3D MF_HUGETLB_FOLIO_PRE_POISONED) {
		ret =3D rc;
		goto out_unlock;
	}

	/*
	 * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
	 * from being migrated by memory hotremove.
	 */
	if (count_increased && folio_test_hugetlb_migratable(folio)) {
		folio_clear_hugetlb_migratable(folio);
		*migratable_cleared =3D true;
	}
}

With HPG_migratable re-enabled by folio_putback_hugetlb(src) on a PG_hwpois=
on
hugetlb folio, won't offline_pages() loop indefinitely because
scan_movable_pages() keeps reporting folio_test_hugetlb_migratable(folio) as
movable while do_migrate_range() skips it due to
folio_contain_hwpoisoned_page(folio) without clearing HPG_migratable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026025552.1427=
901-1-xiangzao@linux.alibaba.com?part=3D2

