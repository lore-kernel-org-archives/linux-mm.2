Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF135606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FjOywHBV
Received: by kanga.kvack.org (Postfix)
	id E7C2E6B05B8; Wed, 28 Oct 2026 09:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53A86B05BB; Wed, 28 Oct 2026 09:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68AB6B05BC; Wed, 28 Oct 2026 09:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0B0E6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39D71406F2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:56:42 +0000 (UTC)
X-FDA: 85372185444.08.500A4DC
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id 166251C000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:56:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjOywHBV;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOy5rZipXXkhcaK0HM+VbL7SQtsFC89tD9F7riLKLfE=;
	b=xQQ9K10SQ23OQ/83Wdy5S6WGQg64TMDyQyrDnXIEMjqyLwHpawM9dJh2y4KJa6cOdez5cv
	oXG7bDOuVPWk+yHB7xnYC+E/mvnRmAEsLh9ybW5kPBHzyXwL3kd6dOrEFJY+K2Vd2cMRuR
	7ao102v/Lqj/GJXKuCCyJ17Eq38tyao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195800;
	b=XT2gIEG1knhTtrhKbwPNLMfvjn/r7ttL30Ew+0fmdjydj7mW/OUccngLQubQErpC5+DoKW
	tpN28F5m6eRmHywW9nhs62iszQFgIa28TlhkZ6m028Q9Lc7If6q9EpZ9gm8hfrqVxSF1P0
	i8G6iDy/ugEh6YXTmRTOOW5Lc7T4BTk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjOywHBV;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gr1tCLiWG+AKW5n0i5TvbesSC1XjxBlWg6zWvuFNVus=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793195798; v=1; x=1793800598;
 b=FjOywHBVm/r1Ws8hz8di1G6VXcyFBPKX3/ZbQXHGbvQYnNdmdsmw4W/23ya1cAPKMIWhh/vr
 z1IPtP1g5OxWDX1g4Y3MiF7YNoOsAKUWqDTulbhdpbgffDlOz2taSs9RzeUvnDtqyo4yGSEHwi5
 NxQz7fn62HZrS4DsgQ6OMmhY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id fb71a9c2f9e0e65d;
	Wed, 28 Oct 2026 13:56:38 +0000
X-Mizu-Trace-ID: fb71a9c2f9e0e65d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/3] mm/hugetlb: preserve CMA flag when returning folios
 to the pool
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028113319.38544-3-kaitao.cheng@linux.dev>
Date: Wed, 28 Oct 2026 21:56:09 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Frank van der Linden <fvdl@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0005A5C9-47ED-45EF-BEA8-2693DAA7C46E@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-3-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 166251C000E
X-Stat-Signature: 8spy9ukzqomzpeqi1cjuyiucy7wj7dmh
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793195799-436101
X-HE-Meta: U2FsdGVkX1/c3ggQ9e8EsyhC2DHrWopU5pDFZPEqsOEz+1bsTzfvCi0OH6LKts0OopyCYz1ZkK0M6iqAqWBKb3/pU3VHYpkCDr9C2J8T7MTWafaYGU+2HHiq5aoPpQIjalWcscb8Xb+nj6DqMZKypmQ8j/CQKbRjvSLeAcdRgw5it/v2405pIhNOI3V9g0mP5b7Q396hTpqgCCHK8oDqibyIXtR90BOL8iFz6XB4aU81aEq4+ZI0tklPYvaw82GfZ8meQR8ZumQorUXmKeD7DsZKsdadWDs0IxiL1mBCu4QDYdh+0xMvJac7vkAJiU7slKxca9wIzPhATaA1b6bzbyah0zq23a2ThugW/VUDRG4R8BYquwMH8vTQIPD3d5MwLIjQPv2dy4FuYJuRZvLFNOIflZn7Xdt1W6udNRjSZJeD3m7CP4NFiuiV38ZitwxAqdr9RA4ETkFBdytSiyuyiZ/9cmTEJZKPnKLjQnIn5xxiLk+9ctrQV3IvFkC459Id6lVmg0UQU67vvOOX4/wjK5MbMjSSB0nyIXRchgt59QRme3QDmic+20OseM3jaP/7bwjr4oDqTzdAFNpbFE8Mq+3hWcN+ZtwNCMxoei9zJzHoGbLo6znHjnrxrbAxLONs4J5ACLi8KGxDJjl3RAHGT5VF/9X8SqMhTeRc50JR/N80fhND0k+vmrbgzwCwM2aMm1vcTAcoFgDSGxj5jVP2yYyVCwkisRQDvknazkqo0w7uk7EQX2864hr6SDxlUKYkOvH+Yyj7mY38wg0yRdU5HpzwdavasqAG8YIQ9D5e/xcWbwHAPM/DU+QSJBsXLkNnvsCAYov4lMx2/2JF8Sbv87mogNPOwnoIip+QQi+BbqpnET27+FFL65UNPRS2eKk15ubrhO9HIhxDhe57Krv2eflQ3dNSz1R1FC3xg8IH+CiHU8v2xzb6rHm+HJ6MXJ82zViSdU+ddvQHKLMndIw
 7B9w5VgE
 Zdi+k2MKvT2id4l2Xl7EeaFEzhWJKXJe4ez9XRwfiZEvm45QQpWN5lbOOofKqjOVtAcRF9JM0B+FOrcJ8HvHlyPs0vfPaSdvfgcAMzx2DD/yHVB0RHJ6oLV3CNrPzEFn3pwovQxHJ/WW86jFS0VedWSX20neh//Neuf0wUYmNgz7LAyZsbSvveE4GJZPtS4a2I0YwbgHIsWsZzAmYVudPEbN+xAykZyCKu35W+gvUsxmW96l20HTMOy7uX5yHp0yFQcqKx3tjJQulRr7ekrfDsySwJ+zdFz7bEH05u7gX4++HoM5+nqo7ejrLy60MqA3dPe1XWCSkPGXOk32SGBQv9y9Hza5FX17QgpG6FtgMbBYPKBMo0Y6kkAQ5/PSZSPe5XXVf+Gcy4vReJiFBW7mZp4p9P/rDktalnGfbaMV+xmVj7Dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 28, 2026, at 19:33, Kaitao Cheng <kaitao.cheng@linux.dev> =
wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> When vmemmap restoration fails, add_hugetlb_folio() returns the folio
> to the hugetlb pool. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing HPG_cma on CMA-allocated folios.
>=20
> A later successful free then bypasses hugetlb_cma_free_frozen_folio()
> and returns the pages through free_frozen_pages(). The CMA allocation
> bitmap remains set, so the range is unavailable for future CMA
> allocations.
>=20
> Save the CMA flag before resetting folio->private and restore it along
> with the vmemmap optimization flag.

We already knew this issue. Cc Zi Yan. Seems he hasn't sent a fix.

But we want a different solution. See:

=
https://lore.kernel.org/linux-mm/A1A14368-7A43-40ED-B2AB-C2EC2C5FFB1D@linu=
x.dev/

Thanks,
Muchun

>=20
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA =
areas")
> Closes: =
https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> mm/hugetlb.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a008afaedf9..8da4bab676c9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1437,6 +1437,7 @@ void remove_hugetlb_folio(struct hstate *h, =
struct folio *folio,
> void add_hugetlb_folio(struct hstate *h, struct folio *folio,
> 		       bool adjust_surplus)
> {
> +	bool cma =3D folio_test_hugetlb_cma(folio);
> 	int nid =3D folio_nid(folio);
>=20
> 	VM_BUG_ON_FOLIO(!folio_test_hugetlb_vmemmap_optimized(folio), =
folio);
> @@ -1453,9 +1454,11 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
> 	}
>=20
> 	__folio_set_hugetlb(folio);
> -	/* Clear all folio->private flags except =
hugetlb_vmemmap_optimized. */
> +	/* Preserve the vmemmap optimization state and CMA allocation =
origin. */
> 	folio->private =3D NULL;
> 	folio_set_hugetlb_vmemmap_optimized(folio);
> +	if (cma)
> +		folio_set_hugetlb_cma(folio);
>=20
> 	arch_clear_hugetlb_flags(folio);
> 	enqueue_hugetlb_folio(h, folio);
> --=20
> 2.53.0
>=20


