Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764E2606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U1AQqdle
Received: by kanga.kvack.org (Postfix)
	id 4F4736B00EF; Mon,  9 Nov 2026 22:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A50C6B05B4; Mon,  9 Nov 2026 22:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E126B05B5; Mon,  9 Nov 2026 22:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E88536B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:17:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64D311606D6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:17:02 +0000 (UTC)
X-FDA: 85417747884.27.1CBA444
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf04.hostedemail.com (Postfix) with ESMTP id 60E0340004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:17:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U1AQqdle;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9M+59aJycwvDGVPdRUa9bBhiCb7/lm1Bh0m6F9EGyg=;
	b=DuqqOP+zwXCfJyXCGqdvHUXKT4PqeyVZnd10HXH7mPBQUhdVUQG19Xc93Fz0z4JPslyWCz
	DsS0UPeHCt58O3JULy486AfJOWCbqKSKp4R2KwccuNP69RYwp/kGLMJXX3jC/qH6ob/HQ0
	AceyIsu87emJUBxkr+tu3AQXwjbgAfw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U1AQqdle;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794280620;
	b=NO8550Xo8m8biEUFSGDh3WL2I3Qy9dOSH6CGzY7IY2NpROH7TtrDGhOWNxDjagtBYiZUTO
	Nww/zm9fr6qZO4PrDqv5srJ4x2bp6zX6zsIq9pgv7M20xGlVUxpLO9gwa6P1NpsmHrVGs7
	oA1DOGWFlaQ/2ZsXoGoNfgP2FJMX9kA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kgr+9iyrM1cxLzfU7kLaTKxlcTZDi3ushAYcoMpeJik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794280617; v=1; x=1794885417;
 b=U1AQqdleFer8Cpa+HpBvRL752oKSv9M+OpFO33gHWt+5EdZx9DCqHHUHqmjeQqsBQR6Ph0HN
 lc+umU3Ly7W5ZYGwBe6iR3SFrpfrtiFhUEyoA/ZuAUvs+PfXuFwQ4n8Bx4gAh5psHXzi6KKxv5I
 sDv7QOOWxygLwY7lAJ3NVRdw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9c1d7389bb465916;
	Tue, 10 Nov 2026 03:16:57 +0000
X-Mizu-Trace-ID: 9c1d7389bb465916
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 05/11] mm/hugetlb: drop boot-time HVO handling for
 gigantic folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-204839@kernel.org>
Date: Tue, 10 Nov 2026 11:16:43 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7EBF14BA-50E3-456C-A005-CE96CE148B5A@linux.dev>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-6-songmuchun@bytedance.com>
 <sashiko-outbox-204839@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 9fzdfqig89i6i9qmm1d9kkgt86uk3pi7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 60E0340004
X-HE-Tag: 1794280620-137354
X-HE-Meta: U2FsdGVkX19tlutLiTL0RyywDF6hGl0Jlgmj5wJBmXAFdt9oxododlAou7EEFeK0uTQtTmEt3K0uE9E/zzwnXS98FNO08XpG/ZPoIsjOc1NNei7/qvP30botuK8onN0euH97LNVnbbuLiSbJ3hmbpmOQMbXybl1MCecM9v3GT/qFeVThjaMnE95EAImdH7J7joWC3npr831WyIzw+1Sx179ofynbvpaSdnlE0x9ab1qgJvruZBhBfRW6ErbSt0PvOTARyQyvHOiCbSHsR+sP3QhnaxltRU3iNFTf6g3OApfa+bGxF8+COtyc0mpzXGYgQH1loqMuYCFBIYCAhlRox62nKCHjNE0xAkujq/USnbmnT1yx/9YIk4V6wevCDnY91ItVlxuBvhaY8aABCb/J+nBjTGREfx2lo4Rzh1D80uVt8CS3NRwtVWCg7UBnPcMNSODVfe1zEGNxo1vggk5tVdeiUbxDys/ZQ0aCZK6NV6aFplrYgZBbjBMiKqBCs6FXjVBeW9ljJxbWtMv3rBtSiiG4V6Sb0kwfaC+OI8D6VSKCM52hNVeSqsEtR8OY/lO78i42MP6X2P7bqqzyRh3CHbt7Yourx0sVy0kjZfUOYZ684Zu4oUKfiekHwiQBzcaNMZSKDrkbw5pybyKAcexBCB29gtlk1qO5v8DQ5i3vokL69HIjmqZYE16FZ+nLEgvGy/DsZWfUhEbVr8l75LRrVifBT+CJI1Tp8sE8lhb80/yk+kXYutajPxMG93GWX4LBiaWRaq5loUo5OPC/+4RRF726ZjGBqCHCx6J7eiFZ5ozZTn8RfH4+sRg7i/KKiEBjIFW8pOn52QNJ5yoAWf/DeDf1GsKySbCfbGJkpFjK3QAVIuaBYEVwIAPVGmlz8IvLhr/Wdo93avAdgUrqsa76Fh+b7tLB7C9vpVzlkVilclz2yeqW0INJhDaEiwk0mUGU3e0s3RXfVFA+iZjEgc9
 YSEGI+Fp
 cwKgiZWcsJ/ol1CiD7Y7Qxp5QEVY8ENh7fmnVTksaHi3nOucaR6U+wmiphXAPilJQbCTpZUc+MxYSxfENa7Sf5+Ueqmk7Z1WO+p2G/qgczj/5KXO8PG8ay78XZRa5hkbhOoZu6avakBxTGSAdncgC2MEKiBSgGdhX2y9HDXCwWBAyfIQKjsRZDoLljnil1fBissQphuqe0KIniGMFiL2CVQrrxCXnByRkKgN2CPqsOG1DQslY+kEK6alsw7nIMkq321iaRPzpH6A+mZbxgSsAvkDMsbguoPrJdLIdzQTF47u2u+F8l9r3flaz+C7o0YGS67ITxUAeGdJrZqJSgNvC+CqEoVmW6xpgryDIL4k3VBcMaepCRt+k9+MxeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 9, 2026, at 18:43, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 2 related pre-existing issues it does not
> introduce:
> - [High] mm/memory-failure: race between hugetlb_update_hwpoison() and
>  HVO head remap [1]
> - [Critical] mm/hugetlb_vmemmap: race between deferred PMD split flush
>  and PTE remap in vmemmap_split_pmd() [2]
> --

I will not fix both pre-existing problems in this series.

>=20
> commit da0d2d6e0b849f9a259d74fcb047aaceb9617411
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb: drop boot-time HVO handling for gigantic folios
>=20
> This commit removes the boot-time bulk vmemmap optimization call and =
tail
> page initialization fallback for gigantic folios, relying instead on =
the
> section-based vmemmap optimization infrastructure during bootmem =
gathering.
>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index ba8e11e399b24..d73ceeef392eb 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -552,7 +552,6 @@ static int hugetlb_vmemmap_pteify_folio(const =
struct hstate *h, struct folio *fo
>> void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct =
list_head *folio_list)
>> {
>> 	struct folio *folio;
>> -	unsigned long nr_to_optimize =3D 0;
>> 	LIST_HEAD(vmemmap_pages);
>> 	unsigned long flags =3D VMEMMAP_DEFER_TLB_FLUSH;
>=20
> [Severity: High]
> This problem wasn't introduced by this patch, but can a concurrent =
memory
> failure race with vmemmap optimization [1] and lose hardware poison
> state on a newly allocated hugetlb folio?
>=20
> After init_new_hugetlb_folio() sets the hugetlb flag on a fresh folio
> (for example in prep_and_add_allocated_folios()), both
> folio_test_hugetlb_freed() and folio_test_hugetlb_migratable() remain
> false while hugetlb_vmemmap_optimize_folios() remaps its vmemmap =
pages:
>=20
> CPU0                                  CPU1
> hugetlb_vmemmap_optimize_folios()
>  __hugetlb_vmemmap_optimize_folio()
>    vmemmap_optimize_folio()
>      vmemmap_optimize_pte()
>        vmemmap_dup_page_from_list()
>          copy_page(dst, src)
>                                      try_memory_failure_hugetlb()
>                                        get_huge_page_for_hwpoison()
>                                          // returns MF_HUGETLB_RETRY
>                                        // retries with MF_NO_RETRY:
>                                        get_huge_page_for_hwpoison()
>                                          spin_lock_irq(&hugetlb_lock)
>                                          hugetlb_update_hwpoison()
>                                            =
folio_test_set_hwpoison(folio)
>                                            llist_add(&raw_hwp->node, =
head)
>                                          =
spin_unlock_irq(&hugetlb_lock)
>        set_pte_at(..., dst, ...)
>  flush_tlb_all()
>  free_vmemmap_page_list()  <-- old head page freed, hwpoison lost
>=20
> Because vmemmap_optimize_pte() copies and remaps the head struct page
> without synchronizing with hugetlb_lock (and defers the TLB flush =
across
> the batch), hugetlb_update_hwpoison() can write PG_hwpoison and the
> raw_hwp_page list entry to the old head struct page after copy_page() =
has
> already finished.  Once the remap and TLB flush complete, the =
raw_hwp_page
> allocation is leaked and the poisoned hugepage is added to the pool
> unmarked.
>=20
>> @@ -560,18 +559,7 @@ void hugetlb_vmemmap_optimize_folios(struct =
hstate *h, struct list_head *folio_l
>> 		return;
>>=20
>> 	list_for_each_entry(folio, folio_list, lru) {
>> -		int ret;
>> -
>> -		/*
>> -		 * Bootmem gigantic folios may already be marked =
optimized when
>> -		 * their vmemmap layout was prepared earlier, so skip =
them here.
>> -		 */
>> -		if (folio_test_hugetlb_vmemmap_optimized(folio))
>> -			continue;
>> -
>> -		nr_to_optimize++;
>> -
>> -		ret =3D hugetlb_vmemmap_pteify_folio(h, folio, flags);
>> +		int ret =3D hugetlb_vmemmap_pteify_folio(h, folio, =
flags);
>>=20
>> 		/*
>> 		 * Splitting the PMD requires allocating a page, thus =
let's fail
>> @@ -583,9 +571,6 @@ void hugetlb_vmemmap_optimize_folios(struct =
hstate *h, struct list_head *folio_l
>> 			break;
>> 	}
>>=20
>> -	if (!nr_to_optimize)
>> -		return;
>> -
>> 	flush_tlb_all();
>=20
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can deferring the =
TLB
> flush across PMD splits here race with a concurrent single-folio =
vmemmap
> optimization [2] and remap PTEs before the 2MB PMD split is
> flushed from the TLB?

Right. I'll fix it later in a separate patch.

>=20
> A single 2MB vmemmap PMD covers 64 2MB folios.  While
> hugetlb_vmemmap_optimize_folios() splits PMDs with =
VMEMMAP_DEFER_TLB_FLUSH
> during bulk pool resize or demotion, a concurrent
> hugetlb_vmemmap_optimize_folio() (such as from
> alloc_surplus_hugetlb_folio()) can optimize another folio covered by =
the
> same vmemmap PMD:
>=20
> CPU0                                  CPU1
> hugetlb_vmemmap_optimize_folios()
>  hugetlb_vmemmap_pteify_folio()
>    ...
>      vmemmap_split_pmd()
>        pmd_populate_kernel()
>        // skips TLB flush
>                                      hugetlb_vmemmap_optimize_folio()
>                                        ...
>                                          vmemmap_pmd_entry()
>                                            // !pmd_leaf(*pmd), returns =
0
>                                          vmemmap_optimize_pte()
>                                            set_pte_at()
>                                        free_vmemmap_page_list()
>                                          <-- old vmemmap pages freed =
with
>                                              stale 2MB PMD TLB entry =
live
>  flush_tlb_all()
>=20
> Because CPU0 has already replaced the leaf PMD under
> init_mm.page_table_lock, CPU1 sees !pmd_leaf(*pmd) in =
vmemmap_pmd_entry()
> and proceeds directly to vmemmap_optimize_pte() without a PMD-range =
TLB
> flush.  CPU1 then installs 4KB PTEs pointing to different physical =
pages,
> flushes only its own folio's vmemmap range, and frees the displaced
> vmemmap pages while stale 2MB PMD TLB entries remain active, which can
> cause overlapping-TLB machine checks or use-after-free writes to the =
freed
> vmemmap pages.
>=20
> [1] =
https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
> [2] =
https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261109095807.41547-1-songmuchun@bytedance=
.com?part=3D5


