Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E54606A33F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=giIFEOCE
Received: by kanga.kvack.org (Postfix)
	id 9E0656B05B5; Thu,  5 Nov 2026 21:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992D26B05B7; Thu,  5 Nov 2026 21:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AAC6B05B8; Thu,  5 Nov 2026 21:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 503306B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:54:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB8F3120C41
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:54:33 +0000 (UTC)
X-FDA: 85403176026.18.DCFA1A4
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id 904A1120005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:54:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giIFEOCE;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zOtCFcE7RqUU0PBGSnDyGDe/moPxuMOnjuMw8Y5ppU=;
	b=C/k5Ov9eDrrW7t1WDqpMm1s5GzK++ruzcFvL+vY9QY/vIZqVUkXO7FTC+j/pCMVEHukzn/
	F5HTgt2PDBEGz+tOXpL3mK3Nnk5EcgFusk0KVyhSNPedDml+sLhlEPIzipEjF1+17aO4MD
	YCunue0Vlp0JBGxxgo82m9PqePiDaW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933672;
	b=6riKNjEHSmKsh5BgMO/9x4tE9QBJit5ySJq6r7q3tieq7rP/CZ97Omk2jeJErhVUs7ujxJ
	wgV88S0n1FoArZcIeDDeevhAHK8JlP3O4E+jkQa6H9xCg0PufNXkvUufj0Si8yi1NqP8BQ
	DtyaYfuwJNuDX9YftMkQ4yx3HvEeapc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giIFEOCE;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cq7ZuuC5w2lt71axYm7fgLbho4rWP3X1twp9z5xV2ZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793933670; v=1; x=1794538470;
 b=giIFEOCEQO1u+pkZHjbf8duu258+M6iZsrdqhnn9+VYR4/3OZzXw8ZI/g+VSbMVTTqZjG6G1
 x1oxJh5hwiSoUXVMel1yIo/JRiKQdNW9T2RMv/kgYfkuhWNPq1kO1LOkl5WZkyMWi5dt2CX8H3o
 exu6iY8JiNHZFZIGP3SbH09k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 58241d6b69efd81c;
	Fri, 06 Nov 2026 02:54:30 +0000
X-Mizu-Trace-ID: 58241d6b69efd81c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <39b7ecd4-e5a1-48d9-8d34-4bf8f8ad4ca2@linux.dev>
Date: Fri, 6 Nov 2026 10:54:10 +0800
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <ED3C9A78-9823-4F37-BF2B-0A8873001BF5@linux.dev>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
 <8F5F930D-A05E-4255-8E70-2567921A92A0@linux.dev>
 <39b7ecd4-e5a1-48d9-8d34-4bf8f8ad4ca2@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 904A1120005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: agof8ohgw375gzsyqqdkm843zo4mw9q3
X-Rspam-User: 
X-HE-Tag: 1793933671-99645
X-HE-Meta: U2FsdGVkX1/+H3CuP5xofwrRKz87IJBF7mZrJPELXnb8UeRdsWvlC0Zn07Q0f390yBAUCmeXLiw182AuhDejzPJzRNXNl1qHTpIb8OzTBTjapYtXQityxkb7EJdzfdlri94l8RlIq2yUP2SUfv6ztkzjpNoeT58QbpjYJhvHxsVN2nlwKMkrEMN/DG7uvHDFGZRvDGGedPs4J1q+yPMQoLvMAHJpJ808j5sBQ2vm3tgjeHLJLwN+38jqRB1Bsi7lv9lC8TYuO2mCnYicVia4bdxM44/44q0StxNDCzt19BpXxeMxTjQh4wwDKz/pv+pfcYTKIZBjqlMPQPJHjzOcRJX7nbcBMkoaM+EiRT4MX5aVxaDi6C3ENim/02tFEEp6XEdn+8SAYB4CLGmLubVgZh2U34gZ+9+cDdI//k/dkMcbPz1dlwP56HwsXCRYe7q+IdKGB39mwgxf2l8m4SFbWgyyhJa7kUb3kPP1BiIe38EaGqsurcA+A34Ym46oTUdZO0PBUx77iqfFd9E1irxPW1/e/giAroyuhm9ncPUTxMTN3Lq7byngkvWUhXGsqYTms1DoMSRC7KRiTCH7qMs7APg1u/GBkTEthDvZyOi9zyjJZmH0emhpfsTPepKFR4karNe0ikUzkIGg7RNlwTzTyVF84xRFRLaxDvkyigOuzd/ysOl+26Z437r+3orZfS6zTSi8cAefKY5Wp3KOq4yn8V1bHHWD916edv1yy/ltT271C1VTJAXDdQElIwxSGSiWtc2LuDYM8L62Dem1oS4wKnuKPq8Z9M3EJrAOK+tkDly2GYdFZVWGPWt4HRD+0dkaxIY5WUtOGLlPVvOqAnxpTyK8OIGYngKsSXkotE2YxVt6WbBV+t/RVA5NsqsiUyig9hk8OIVkbmNM2yhOQPMtJFAnAnVUeUUhgiTbFbRvb/M+BeiZMLJsG573P3tbPjMrB7xM8Az3HeMUNMojogU
 +to9hizd
 QidPAFxNfZlzNK8uzvARbw5TGHJ2VjnM5hRhFglmJSYqCYCLvHxb0A1ZdbuaiB9vMAb+Z8q9BXnPTdXd99Rak+Bfik3nLvCkV6K09KKl7rU/CQcq69p5q74VllDpRnBXOGFXUVxx0leZCDw8tUDCM9DK1N5HVt6QV0SAeIWuvIG4z69UpLYMbg0obH2ojRS0vozH0zfY3VJZ2GKh+rKZY8ZLa9PmJJOL0CKW0NU6Tw1sA54/mLBLrd9GOK9jzUcPGj+vTUMHDNKGIYWjE9kDvu6/18XLYuPzVchkipESL7rXczTooLMBUyodqMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 6, 2026, at 10:48, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 11/5/26 1:13 PM, Muchun Song wrote:
>>> On Nov 5, 2026, at 12:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>=20
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>>> unpinnable, causing unnecessary migration or pinning failures.
>>>=20
>>> These folios already own their CMA bitmap ranges, and memory blocks
>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>>=20
>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>=20
> Thanks.
>=20
>> But a nit bellow.
>>> ---
>>> include/linux/mm.h | 29 +----------------------------
>>> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>> 2 files changed, 32 insertions(+), 28 deletions(-)
>>>=20
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 2d0b8a4c9974f..75dd40265d3f4 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct =
folio *folio)
>>> return is_zero_page(&folio->page);
>>> }
>>>=20
>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>> #ifdef CONFIG_MIGRATION
>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>> -{
>>> -#ifdef CONFIG_CMA
>>> - 	int mt =3D folio_migratetype(folio);
>>> -
>>> - 	if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
>>> - 		return false;
>>> -#endif
>>> - 	/* The zero page can be "pinned" but gets special handling. */
>>> - 	if (is_zero_folio(folio))
>>> - 		return true;
>>> -
>>> - 	/* Coherent device memory must always allow eviction. */
>>> - 	if (folio_is_device_coherent(folio))
>>> - 		return false;
>>> -
>>> - 	/*
>>> - 	 * Filesystems can only tolerate transient delays to truncate =
and
>>> - 	 * hole-punch operations
>>> - 	 */
>>> - 	if (folio_is_fsdax(folio))
>>> - 		return false;
>>> -
>>> - 	/* Otherwise, non-movable zone folios can be pinned. */
>>> - 	return !folio_is_zone_movable(folio);
>>> -
>>> -}
>>> +bool folio_is_longterm_pinnable(struct folio *folio);
>>> #else
>>> static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>> {
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 2b405cce2ca5c..e8503141bb275 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long =
addr, int *locked)
>>>=20
>>> #ifdef CONFIG_MIGRATION
>>>=20
>>> +bool folio_is_longterm_pinnable(struct folio *folio)
>>> +{
>>> +#ifdef CONFIG_CMA
>>> + 	int mt =3D folio_migratetype(folio);
>>> +
>>> + 	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
>> The description of "bitmap ranges" is weird, making me think what's =
the meaning of
>> bitmap. Please use more generic description here.
>=20
> How about this:
>=20
> /* These HugeTLB folios own the CMA memory, so they can be long-term =
pinned. */
>=20

At least better than original.

Thanks,
Muchun

> Thanks,
> Qi



