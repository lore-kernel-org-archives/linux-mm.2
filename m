Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E63E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JwHCiaU6
Received: by kanga.kvack.org (Postfix)
	id 890D56B05B1; Wed, 28 Oct 2026 23:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A436B05B2; Wed, 28 Oct 2026 23:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E26B6B05B3; Wed, 28 Oct 2026 23:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADAB6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:39:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB1A11A0301
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:39:52 +0000 (UTC)
X-FDA: 85374259824.01.1198AE7
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1FCD100006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:39:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JwHCiaU6;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHYJzejo29azPzDNOxZ+tmpvvDu3XTTv89JLTyFVqd4=;
	b=VuzJpdtI6PAQVf9Jl14b3jXDG+nSbzz04eXeBmrOxxoiq31/4ZKTGic6M5BgW2S+5EII5K
	iZaON+RrR9FdDZKDKZKLbmYr4hmaM9OVVz82PQ6XFiA2BpBPULlD9djLILGR+GK2NU7pUv
	+8MBDfxhCMUEPSl2UgDvnHJoovB+hgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245191;
	b=0P2nyXYJA1KMS831+v/fh/SccOTLDHocZrWcfFD/kaYWqDGeqEGFqCPGpfcWWDGmprdX4v
	1Iix9eydyx2g1H18H97DDvlXn/dB9Byay42Lz8nF90yDF4m4mPQGtbK9OmkuLzW+O7IZLm
	EK1arVt9paLpFWvBcAih+Mq63ad0NPQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JwHCiaU6;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R50k7qXAG33bbhagggBhqvchCPQ52saBCXt3awMCb6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793245189; v=1; x=1793849989;
 b=JwHCiaU6wNlgkZwersY6AMgWtViVtjskMcecd/6+Od2qPv/mWGKr7rlSGPwoiVQjWtSEquTl
 jz8ubRhsB/Dyc/RqHacrPomgc4WK1uts7m7DL8ZDejrhXjpDsM5Zh945kHdyhP94x2zIdgWwum6
 47kzoRxtALGbiybFTOALoFVw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5ac0218b5b613cc1;
	Thu, 29 Oct 2026 03:39:48 +0000
X-Mizu-Trace-ID: 5ac0218b5b613cc1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 02/15] mm/hugetlb: compare against persistent count when
 freeing lowmem folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-2-a0a033db180f@kernel.org>
Date: Thu, 29 Oct 2026 11:39:27 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 stable@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <68EFA1E5-4898-4278-8718-06B1A010DFFD@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-2-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1FCD100006
X-Stat-Signature: 98z6zb6iybqaowz5n9xysa5sh4ad5dsz
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793245190-649558
X-HE-Meta: U2FsdGVkX1+s2Yi1Wl0CeFeqF5Ci0675J4/5HH1PGERpvo6d6MZ6WN7Msrza7UNbsuJ21SD3Y1EYIZVKiuAShqM+rxACpdSTsZxPqfo9bOYSOQBLAtAwBc7TGx7wc9hwth0gjzVTw4l+wMA37U++9tfwPz+CGOMiYg03VNplZxDEXoAlzbZ70TWuUQp34EZbwyt4hOODaOXiRLL6v5pQPt8si/KKt8uaULRSTrhh4ykQO5+A0BZr87i6Zj8pncbtkjgR7HKWDBwBhBDJPKaV/ybauspPaYO+ceTZq7vs4GJFLE1MB6IbtBEEAqchJvlvx0pbcfaheBZdRt95TaZ4A60D93tDvod+ZCubpK/CGUIv4M7yR+LB/Sl+DYn3DQnS0MXMfV6XBLFDPqlhHeD7tC1KTxkn/x5TD4O10hNBsTvU42rSdXXjxV8Mp3Io3zbyyQkWBIF+uYcB4TQ0yLE55vRn4G2PC/rV3QhgpJDPFEYYiB9ZXKw/3wHrd+Tj0v9E679umES/G3xhJP9FztG2e0Nx9A4VqYjpeeVzQ+2fugs4NG12+vi395vnCLjuRhqmtNsMYg2iihXY1fguP5cVCz5aM/G0cJfGVXAbn+Ihy6NFZQoMF16uMNWo0Sbu+NkVrJp3cw5Ys1CCnN5qiPnUMyr+tlwYERXrPvIOcOLuV99/yOjl7H0sLkQisk9pFQLw5i7P7V/3WlRDfr+NNch0/4a5IgBk9tDEpQshLzTHgH0PtgWwf5GEDS+jI1pQSuydS7NyAnD9hs3dsuSWKMeKQJG5AxJbIw0CQ3wYHluLH1vqA9+O0HohVe74ceg7aRlEWIJMg+VMtF3ly8Alhq7ey/w5iSBAv9BnBDOaY/Cl3YtqVgwvLhJYZbeES7WP2SMoFMwgC0uYLK4K7iufxxeEB3XnLs3wYAEfHQnchZgyQlKDFlAuvg1ZzOa4mz7RUBJ4hOG80CF63WqZstigxIh
 gl38J4If
 +BfTdnezDxErHVMHcgVtY81OLiCRtTdTgK36KJsypG2f5bXWchQRae8vTkKsqXauZCkmpFFIZw6CzRnEOX19WR1DXsJo5yIqq+y7bcp2Yq0lAo2lF+xNqsV+J/KRlO3IXkngjPmXa9iLG3V+7pUFgIp8b6rr2VMslmNWV7J4CIvy3bDgJqIeGwa6WBDuD0GDOjTq4spwJbtqcube521R6vGcKrgHsWoXfj1ypYFeeiK5zwyVCYklDCfqvcoyw4mNbF5XAfBfEumgQK9NKQGGXzT9M0qRgEaJO7wdQgd9XlOnS0TMMU6IxNbPz+g07QCVOLMlR4/98IXCoGEuLyxGQl8Qq4zsPi/RWdbDfb6CAGHuYI90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> try_to_free_low() gets a target number of persistent folios, but
> compares it with "nr_huge_pages", which includes surplus folios. As a
> result, it can free lowmem folios below that target.
>=20
> For example, with two persistent folios and one surplus folio, a =
target
> of two can still end up freeing one persistent folio.
>=20
> Compare against persistent_huge_pages() instead. Convert the macro to =
a
> helper function and place it before try_to_free_low().
>=20
> Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for =
MAP_PRIVATE mappings")
> Cc: stable@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

One nit bellow.

> ---
> mm/hugetlb.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da5d04edf7c1..3a94ea1c9457 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1335,6 +1335,11 @@ static unsigned long =
available_huge_pages(struct hstate *h)
> 	return h->free_huge_pages - h->resv_huge_pages;
> }
>=20
> +static unsigned long persistent_huge_pages(struct hstate *h)

Better to make *h const?

Thanks.

> +{
> +	return h->nr_huge_pages - h->surplus_huge_pages;
> +}
> +
> static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t =
gfp_mask,
> 					   struct mempolicy_interpreted =
*mpoli)
> {
> @@ -3719,7 +3724,7 @@ static void try_to_free_low(struct hstate *h, =
unsigned long count,
> 		struct folio *folio, *next;
> 		struct list_head *freel =3D &h->hugepage_freelists[i];
> 		list_for_each_entry_safe(folio, next, freel, lru) {
> -			if (count >=3D h->nr_huge_pages)
> +			if (count >=3D persistent_huge_pages(h))
> 				goto out;
> 			if (folio_test_highmem(folio))
> 				continue;
> @@ -3773,7 +3778,6 @@ static int adjust_pool_surplus(struct hstate *h, =
nodemask_t *nodes_allowed,
> 	return 1;
> }
>=20
> -#define persistent_huge_pages(h) (h->nr_huge_pages - =
h->surplus_huge_pages)
> static int set_max_huge_pages(struct hstate *h, unsigned long count, =
int nid,
> 			      nodemask_t *nodes_allowed)
> {
>=20
> --=20
> 2.43.0
>=20


