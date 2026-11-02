Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142FA606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n0k3Hqlr
Received: by kanga.kvack.org (Postfix)
	id ED7D56B05B1; Sun,  1 Nov 2026 22:11:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E890A6B05B2; Sun,  1 Nov 2026 22:11:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77CD6B05B3; Sun,  1 Nov 2026 22:11:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9AAF6B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:11:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 053F4160651
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:11:11 +0000 (UTC)
X-FDA: 85388702784.22.692310D
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9B2C140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:11:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n0k3Hqlr;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDhZoiU2k7hzH5EQ8QltiF8pnal5BaZYHkxarnC+U5E=;
	b=VJ/LPVYi4C744SJwzP8ZMxlx75njo8F/F2l9187c0GivdSoxvbIFBhLC+s7foRtOXmKofH
	A6NXEjrQ26p/oucrdh3Ur8EwcPieo+f6KFXfRRU6y3zD+sHb/PAQjc6itDSgZffKj+9twC
	PlekZpsqtYa5r43sYpyz3VpNGeDaQMs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n0k3Hqlr;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589070;
	b=opyBoN56VgTDtbxyKXKGYHm6qtqTaEXy+We2dKJcZ3TsYwAAQsf4JPPkFbE4gvxwidMtTZ
	8TmMC9jFLH1/J/BHrbxSEQ2i0bJI8aKwtPW1pcexHFxGSo0VjD8WmXfuqCCr0Kxlma9fNz
	ZYbZf+wltV1/ohD8BM+ppEoKUK51stc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2ep7chL4yiYBSxOtKkATYD7E9Kan5MnJyt74PbsbY2s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793589067; v=1; x=1794193867;
 b=n0k3HqlrjwV2Tsu/afxxjlV4pD44YtWJfaVfNxqkf9f5BRb34TxDBhYIPNPv3UVWsbdtWpzv
 nDY1ZRbtXmCXX/EiHWE91drrqkdYXLA1t2WmPrqsfw75Lx6z5Vd+3cOAqiCXrqIBDsAChjqAXdA
 0N4xoivwgBDZlGU5lKOUjChM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 13887cf09f90baa8;
	Mon, 02 Nov 2026 03:11:07 +0000
X-Mizu-Trace-ID: 13887cf09f90baa8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
Date: Mon, 2 Nov 2026 11:10:47 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mani Tofigh <mt4022@columbia.edu>,
 Zi Yan <ziy@nvidia.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Chris Down <chris@chrisdown.name>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <80F17A68-8C3B-4BA5-9E70-838846BFAAB2@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9B2C140005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4dbz6wjkxq4dxknc4wmhmfp9xirj46pf
X-HE-Tag: 1793589069-786012
X-HE-Meta: U2FsdGVkX1+MTSEKAmN0nI84fHXKMxF/aPjUh208bJtufHuAfQX5/HQ0dAK3FSPch/jKyJnr77Gmio2+SYCAeml738QUZellHsn2sa0rrtR59SVf3FmlYaSwzfY0AacZU/sP/Hclvpvxb7c0V4MKLI8ynZr/qFf2bjmPY/GXl5F18KQlzzBj+Yij0ElhbOAdgzNqMGo9sXZHX/DhK3JqgDqYklnzR8ry1QALblxvgZxDDTxLxgEAHolOjhFwd70Ao/+1FMq+4pLhCNxUH3bNxbPoJG3+NOV4n337K5KSpIznuATSYUiQMCT0c8P7WJTjlEPNnmMKpZbSM8ZRp1sAnhgmnnaH0xpauTaFjZHhKWJn+e2+phKBcBTvQpdWv+oYj4ljJ62771Wk4ch4i5RgXNEIIq7u40ugFpQPilUKDyCG+Mc5oTP605/xj5BpgDwsx9dPPSwNfCE8rTcbcb8C4j8pufhlaM1S+0ztVaEOLgHYdGlHqaww9hiLFHQuexeXkdcFAcHOkV4rYx+zUWIr9bzYn5FdZXr72RuU5oymEV4/Yc4L2SVPHXAveeDwv1GkyYhKklZFM34UscYUi+fyMbY1KYD5xkusv34iK+PUFgaD2Q8iBRMlcEuEQuQrMsbth7Zib7t+Gy0nwg97poLgp4ne84UYBIAKHxeRePVXUwQTgzKSI2ba157t/89qCXnryCkijus2EMokr67et6ksf8frGV3D/ae1ULcKw5F1tCYJcU0SPvKKVi0W/AfENVHpRtRmGz8rlom3qFNiGQsfXZdPq4tj/7h/WIt0grRpenS8AG5XCZAKsnLITOQto3O6Ls8wiH89BUybRGYOg9QV4SvzwyP1MO3EGgN2CD1PhudX8e3sRrXEhj5iXO+t8ETMqOnvHcKxC1NKx/CgdssnAXWTpw/xMmmsOanjc7auTOTKJ/r5lI2b1LGJHblf1HV/tbSQ7Tl9pXzVqHFixql
 BfeLAYma
 E2ITYrrMZgLcb+0RJKhXsSO80DLXT5NWea6ggpYJDPb1rcXBoG1kmTg4507RD3Az/clOXQysS/gYTiPJoqrITGzBktJla1vN58xEbB0jbBFbtGO5Row+tp7FeCRhkwxAFENvaTUMVM/HDnjyY0UDrA1AihG7n7lv1neeecUqjlOqOakJ9U6TeYLnLsQGnqkl9vBfoldwaIJv+UzaAJ+hpbmNCnpnMTohJ3m1REwHtK5s3boyxYO2b1xz5vKh4XNVLL9he3Aul4pCVHQL0QKJedVotF4WCqpTUoR/zLYGcL/REEYb0+qocXxmhmbkZXkouIWmzbO+sRDinyAF9j38amaH02MeMC1NvN6BpCGx3agW8zaeEGFZfpdG+quS3tGjgLTICWNat79FK/HLiQbqly7HPUB+NU3/0X+TjEQpgGoTsbczZa9f8NxgRt/0/lDxZLEej
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 2, 2026, at 10:49, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the =
rollback.
>=20
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are =
unknown,
> undermining the checks that prevent freeing or unpoisoning such =
folios.
>=20
> Preserve the existing flags instead of resetting folio->private. =
Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in =
free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap =
restore
> does not leave that flag set on a folio returned as surplus.
>=20
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
>=20
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism =
of raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA =
areas")
> Closes: =
https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

But,

> ---
> mm/hugetlb.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a008afaedf9..931ca3a30773 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
>=20
> 	lockdep_assert_held(&hugetlb_lock);
>=20
> +	/* Callers must clear transient flags before returning to the =
pool. */
> +	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
> +			     ~(BIT(HPG_vmemmap_optimized) |

It looks like the parameters aren't aligned. A space missing before "~"?

Thanks.

> +			       BIT(HPG_raw_hwp_unreliable) |
> +			       BIT(HPG_cma)), folio);
> +
> 	INIT_LIST_HEAD(&folio->lru);
> 	h->nr_huge_pages++;
> 	h->nr_huge_pages_node[nid]++;
> @@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
> 	}
>=20
> 	__folio_set_hugetlb(folio);
> -	/* Clear all folio->private flags except =
hugetlb_vmemmap_optimized. */
> -	folio->private =3D NULL;
> -	folio_set_hugetlb_vmemmap_optimized(folio);
>=20
> 	arch_clear_hugetlb_flags(folio);
> 	enqueue_hugetlb_folio(h, folio);
> @@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio)
> 		h->resv_huge_pages++;
>=20
> 	if (folio_test_hugetlb_temporary(folio)) {
> +		folio_clear_hugetlb_temporary(folio);
> 		remove_hugetlb_folio(h, folio, false);
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> 		update_and_free_hugetlb_folio(h, folio, true);
> --=20
> 2.54.0 (Apple Git-157)
>=20


