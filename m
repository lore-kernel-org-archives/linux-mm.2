Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D16E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qsZFiTQz
Received: by kanga.kvack.org (Postfix)
	id 8D12D6B05BD; Wed, 11 Nov 2026 21:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9486B05BE; Wed, 11 Nov 2026 21:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFAB6B05BF; Wed, 11 Nov 2026 21:59:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8256B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:59:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36DAFA8033
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:59:30 +0000 (UTC)
X-FDA: 85424961300.14.FF09012
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE779180005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:59:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsZFiTQz;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794452368;
	b=N+FywD1jCg/j4I9mI5zHLfUIERW7vk7bTGjUQGeJnKZJQXWWSex1KXqDTCJg3751VaP6RT
	m17VJmy2awEAAar85QHYwGuNmKHkHe6CpltjC2Q0KgZlZpzOdVn5oJ3K3FmEqJ/1cZwtGn
	psYoMRnnbpYCtuMX/3EBZTU8jmKqwZU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsZFiTQz;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794452368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J11tLi8SfFmSWAqFUDP4HJVX5c9ZbamsLUfA0GsiEY=;
	b=3MJzmSLITKLqJYoZgaKkM6QUOmAyLDonZW5o8QaZUOXrLz2dOk9HJi/Oigu4gQChTPteVB
	neRriCItqZ7kpzJKfYVXDhTy6E2YcgPmgPtwyIs/1vV6TUHAuKkeuwvg3GYXIjTFBeqDgf
	TTGNPyQX+5kRQVPjqPkJMmn4naozzRo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WMBj19dOUDYdPyz+QJ76elqBaDh3uyu1qhcDOGOiJYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794452366; v=1; x=1795057166;
 b=qsZFiTQzAvIE5Syb/Uv58dNdA2ZLlSwSeK6iY6+DhavGovhmFqnemAAiK8laTM/rygbVGn4U
 o6pN+ZGqoNylSGBmdLpqTvKUk6faDpcYlztbOBMFWSy1B/OdS7/STUtGdVr4uHC5ECWasVo/NVP
 zudpxAhHYjH2ejh9Zp6zsk98=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 50165d57d30e2034;
	Thu, 12 Nov 2026 02:59:26 +0000
X-Mizu-Trace-ID: 50165d57d30e2034
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state during
 optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-209812@kernel.org>
Date: Thu, 12 Nov 2026 10:59:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1E848BF4-4AB4-4656-8523-FAC6DD8FDAEA@linux.dev>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
 <20261111093747.50048-2-songmuchun@bytedance.com>
 <sashiko-outbox-209812@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE779180005
X-Stat-Signature: iswxcxz6qcs9tpydyk6xd651641bbmmt
X-Rspam-User: 
X-HE-Tag: 1794452367-103043
X-HE-Meta: U2FsdGVkX18tYOLDMuvsljXZpnpYNsMD645tXby6bAmjTt0pztJ+x7bklAB/frF9w67xWN4+iTy/mvKQdiGTz1gZFvX/5YLwfnmWCQB6zRWxTGYG3pjwKAxuALE96e9RWLWLjBnxRUmhxcz7FKyh4HR/zXGDymL90D8ExGDKo24tkKsd3RIxHB0DfHF/irlMRXQISe9wvyMLjNkbLPeo9VyUX6M+etUUrhCles1MgeaHMmU48aR6lsUyRgI5G/RixByY+MvGPSVnCr/Z9gFsnWbC0KnF7XapvmoyqzH2oNm27qcSNO1banodiI8RzAXocz573BqDEZpyavjpWKbrqdKdR7rivieuiAybI9CvRL2PB0UfKN3nVkhkiAfJ4idCsSjJcSnon8h1mAUGD+2Dj2eQPGSgeBx/xo1lChB9WO5dwJQdopVDTn8vH7YtndLdUvm70OEW1znDsQCMcX63U5M3UQQHfjynliNmP7tyXDKHwv/MyEcezMAYXTyuLKRUP2cDQ+VnmPiadc2mlRlk7KpMy3RA4nXY9/j2jyGFPxIbSaUUJdy3nv7A8t++fHfREuGpce7doqN4gVdz2CyhevWRZOTfQmPMgaLS92j38zO9HzWJuqAn7fwLB/nv4RoZbtMMjQtGPUtUJPU4HAckH3TWaoIRJT56KEsZfrOWn6colaLyNSCnZNd9jRzF4I6hv3xU0K7+2ifTJ7QG2tbXgRSyiODxWex5ez+gzDjiL8Nn4yoBnNZUiTGmEKaf8sVd46+RYdITXcF0vEawzNvL07ldG4XCK/0cKVcDba51ocxIkycuh7ZZ/cGXBrMOeIZ3ECzGikaYxi5uHrOg8k+26yERnHubfZKOIcCFibJNk2MdGRwdigDIDt7u3wKi3sZ89pEoMa0D39jBJAUVrTwDwGlusTDjq4enRNvVfB0TdyzuZ7RJ0LNpwDQ7WwfEAtqx/6pySqVG4IA4a2YSp9j
 mmNk9RRr
 2h5O+MfqkqZJ08VS8SxTB32P64DB+vkc7ltWgikPQFADjXMIucbD3uJp4m7Bs/ZEywUMlufLJ1BBre7DVO7n6pS4di0nxxx9Ju0tq6t95mCR5YID9HMzaMEibZaZqaq5HUOIh5ufpkkgtTM65rzjBY+3N2FYj2oO5H6J87wzXNVgShhMn/WpkaoP5QdIYVxOlSa8uVLS1tY/Tai8rV8t2JlVizAOk0fxoRf6d+zRR0fn4AHSQjx483xUWqzBp5lHNVBwln3h9C7fS5G75kNoUPMr8NURirngKJkmFO7T+NhQJV2J3beQYsUYaMK5I0kaTxSdwIrs0ljlVvshv0oh3b31xd8X0TrtUhZpWrPwz82vUn/ZQE/4YxaFYGk7Uwjih12BWQBcLVl/IWNVOqt09mHWkRKNJ9eEoQhNo/obZtNi885dCI9Ewfe+Tr43CEEtUwBEhDm+6xb2n8o928AoIU24qwLg5gJUmd0M9TU/dpGbOvEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 12, 2026, at 06:38, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/memory-failure: unserialized unpoison_memory() races =
with
>  HVO head remap
> --
>=20
> commit c0c1b7e9976626bf636152889fd9f5d88944d78b
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb_vmemmap: fix lost HWPoison state during optimization
>=20
> This commit introduces vmemmap_remap_rwsem to serialize HVO head page
> remapping against HWPoison state updates in =
get_huge_page_for_hwpoison().
>=20
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 78f0a13349cb3..164a02866fd59 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>=20
> [ ... ]
>=20
>> @@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned =
long pfn, int flags,
>> 	bool count_increased =3D false;
>> 	int ret, rc;
>>=20
>> +	guard(vmemmap_remap)();
>> 	spin_lock_irq(&hugetlb_lock);
>> 	folio =3D page_folio(page);
>> 	if (!folio_test_hugetlb(folio)) {
>=20
> [Severity: Medium]
> Does unpoison_memory() also need vmemmap_remap_rwsem when clearing
> PG_hwpoison and freeing folio->_hugetlb_hwpoison?

I think the following diff will fix this.

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 164a02866fd5..abe92db14fbc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2814,6 +2814,7 @@ int unpoison_memory(unsigned long pfn)

        ghp =3D get_hwpoison_page(p, MF_UNPOISON);
        if (!ghp) {
+               guard(vmemmap_remap)();
                if (folio_test_hugetlb(folio)) {
                        huge =3D true;
                        count =3D folio_free_raw_hwp(folio, false);
@@ -2830,6 +2831,7 @@ int unpoison_memory(unsigned long pfn)
                                         pfn, &unpoison_rs);
                }
        } else {
+               guard(vmemmap_remap)();
                if (folio_test_hugetlb(folio)) {
                        huge =3D true;
                        count =3D folio_free_raw_hwp(folio, false);

>=20
> If a newly initialized hugetlb folio is poisoned by a =
software-simulated
> memory failure before HVO acquires vmemmap_remap_rwsem, =
unpoison_memory()
> can race with the head page remap:
>=20
> CPU0                                CPU1
> hugetlb_vmemmap_optimize_folio()
>  down_read(&vmemmap_remap_rwsem)
>  ...
>    vmemmap_optimize_pte()
>      vmemmap_dup_page_from_list(old_head, ...)
>                                    unpoison_memory()
>                                      get_hwpoison_page(..., =
MF_UNPOISON)
>                                      folio_free_raw_hwp(old_head, =
false)
>                                      =
folio_test_clear_hwpoison(old_head)
>      set_pte_at(..., new_head)
>      flush_tlb_all()
>                                    /* new_head retains PG_hwpoison and
>                                     * freed _hugetlb_hwpoison pointer =
*/
>=20
> In get_hwpoison_hugetlb_folio(), passing unpoison =3D=3D true takes =
the
> folio_try_get(folio) branch even when =
!folio_test_hugetlb_migratable(folio),
> returning 0 on the frozen folio instead of -EBUSY:
>=20
> mm/hugetlb.c:get_hwpoison_hugetlb_folio() {
>    ...
> 		if (folio_test_hugetlb_freed(folio))
> 			ret =3D 0;
> 		else if (folio_test_hugetlb_migratable(folio) || =
unpoison)
> 			ret =3D folio_try_get(folio);
> 		else
> 			ret =3D -EBUSY;
>    ...
> }
>=20
> unpoison_memory() then sees ghp =3D=3D 0 and calls =
folio_free_raw_hwp(folio,
> false), which skips the folio_test_hugetlb_vmemmap_optimized(folio) =
check
> used when move_flag is true and frees the struct raw_hwp_page entries =
from
> old_head.  Once CPU0 installs new_head and flushes the TLB, the folio =
still
> has PG_hwpoison set and folio->_hugetlb_hwpoison pointing to freed =
memory,
> leading to a use-after-free or double free when the list is later =
walked or
> freed.
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261111093747.50048-1-songmuchun@bytedance=
.com?part=3D1


