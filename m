Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D860606A880
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vbv6Njp2
Received: by kanga.kvack.org (Postfix)
	id 6B1666B00EF; Mon, 16 Nov 2026 15:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689756B05B1; Mon, 16 Nov 2026 15:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577F16B05B2; Mon, 16 Nov 2026 15:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21AA76B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:32:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A46078021F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:32:20 +0000 (UTC)
X-FDA: 85442129640.10.9F1E4D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1F96C000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:32:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vbv6Njp2;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794861138;
	b=tJq29ibxsIpPycM5KLmXIg6zx9EMP2tqWFeIUnrfmpkz3LR6jiLj6lvKPB3Z5n55MU3CTu
	yxYXlUSOgN9mT0iVFaNKpuux++bGHfNp3kE101C4bHUljlprs6BOU0Pk1telj0YGNg8+tz
	hfwWlhyQuBj6b+vJUwgVbvdIfNrqBOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794861138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSymAHtSTg9MrbbuavNs8edEjM4tR6Glt6TgXdMzi/A=;
	b=Mzvpa8Vo1U+NYrs5+Pm4Wf086FK1M7FKtmuHVrCgiOxhK0E8tmLLP2HMkxTFOCvSjNW2ig
	ezQlsPTueS4+tLRrOvvJ8VFu54NuIH2+UURmTy2q78uiBn9DJr2NZiBaFgVRaRGo35P6c3
	Tcz1KLXyJ/JPRyMQQP8ZQ05cB3x3e2A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vbv6Njp2;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00CF74080B;
	Mon, 16 Nov 2026 20:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E0F1F000C4;
	Mon, 16 Nov 2026 20:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794861137;
	bh=cSymAHtSTg9MrbbuavNs8edEjM4tR6Glt6TgXdMzi/A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vbv6Njp2KLEJHIydFEEfCotyeJuqayD9Sy+dYVwcC9Qj/OoLscJ0W+s8Iy26p3DDA
	 6KFtMZhtKJC8zGtC3E+gUdJ403cN81FSz4W65tr/Jv6q6xbEXGWaggjYEv+/r9vXnM
	 NMi2QPIv0uUu5p+fiORRAgn5DugWKFefEAzh852mRS439hc9djnHcPPeTgGRZDlPqe
	 HTNxMLSvKgKLZzTq9/xtQhPrJ357+1dLguwZXVZwbF+S9QUFLn2dd8ClOxmziRgPOW
	 Jz77F5RiulDKG5if0VtPTDOn4pNyHMLMKVLYKeVTBXzP+9h2gs2mIQ09w7wnxg2ZmI
	 Os+woIRAQQW2g==
Message-ID: <19f00f83-070c-44b0-a842-dc2fa6dd668e@kernel.org>
Date: Mon, 16 Nov 2026 21:32:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm/huge_memory: build the moved huge zero PMD from
 the destination VMA
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-6-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-6-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1F96C000F
X-Rspam-User:
X-Stat-Signature: 1au8ouj19hhtinggiwit8pqhana4zujc
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794861138-279220
X-HE-Meta: U2FsdGVkX18ezacI1Dgck4D0QyHj3+CxU0jQn6x2vO7rZoSaUq7P5kSQoq/L3NwXGzbM5HKtcWItGFl7wJZ8u3y5uhumC7cNgdh/2WSP3r2qa4O1YrcmT9SP2DOwipXSQw3DHOeilgWhFISp6eaYBSMVSNeikUP6+Jvc4frTbUPHBa+W+fE3f8KMwolLN+BzwGe/WBn2NkiXvNVQV+ZSdqKyN9sLD32UgnqAwX0Tt7DLe8eKr07+c62oVrRuaki6U/dG8GshqW6COAItQseWtWupKmnRxBoOziVTlanTtpzNIeaQwumVr245aUP0uH0xMoAYSpV1pyC1VnDF/IIPEOwQknowpNwgPQOT/PyHTP+mSbfIoDmYq8LwJQZoT6I4KNOme7Nw8lHeenEe3lEZ63C0J2PEs2gpuVDUE+c5fvwwvcq34/YHEDSN0hj/YpTb4vtAhNszUz4DK251ulJPvK5PWCL9Sxqs3kObjBW0GYdBtF/v3W3KwhtNFCNNtUR6/gGf4j7yXOsX6ZW5f83Wf0MDSoigGdQtTWzJhmzyVRxlpOKVI72fiJ5EW6gd1so7503FXtvoTFqmUlNwtITFui2yZFcbgd0tlHuWNz5ZaAIoHIVv2TJQiDSQ5aibPSgzxx9N2Tx2OPcIcZuHP0qbOYbxBbJZB8g2fJWJnz3fs5M2vAfgpUljA8qf6tMyZ2l3hvnJ3vZ2eWz27jtQa/G0T9RgG6PKrD9c5JNFVjChPnoHFQVm9yISNWcF6mRC0oJpEJdPe5iM3UCoTOQQgdmNpyAFF+qfzzzUGHr71twCg3T6eqtRE8/LOh2fU6k/s+fimSLQqM2Fs0XJ6rusQ3UwisADjFDQ/wQ+V+HLoSVrQSqXXqokuHQkimVPoILMn+CODg+vfr5ZBOqDhJXHM5th5Dm+cVpoIaK1XZ6wGiZIem9tRBOiPrdcxnSgWv0D7fnGY1jIwoa1ONL6H8Bbsmi
 iOp8jQQM
 rP1fOeKDEFUYeej5R8U0mOl3p+sWyT8EhlJuJzL2ta6G5MqlblOKGB1Oi6RNde/JYgr4A9pxeSHRzERgQWPxrINRWlF6bcEgUp0BfeFGJjfpESrpzFGQS5QYC4OkroAUt1Odae3cI2/S+Ie8HYduoQiyXSRi1WQcHmKVnDoNtBfTEhfzMp2gNQDHhNx/ORKYfOFsZ1OXizjqjPTwJieQK+uu6sq1+KRvJJDiKU2w7JI6QdoAl16/2XsleqVOHQ4o3op3I4ynKyut2J+24RWpXoNaedTLsu6Ofr5Fb6+cAMp1zU8ybCQw18Pzf96h53bp7ZSXdA+zDWiDC8breMmcxZkiNwqB8qihkNFxlNTlkDF8LcT7IA8gVCPjCZUj82NX+hZvKy1AHhUhP1Tvqhuz9pDGMpDN2h+woF+DcmBO3GfJlxLdTENRFrkHPcrOBx00547PAG3Ja7jsN+jcECPDP+diwSkfPgBZxO8tnN9VyvHm79VDyQBdDdxXJYCXYXML+sMXNDrjni4hRdKeSS3MayuDullYVd3Tk1Sb9FPACBnwWy1K8OzvVPNv7Zgn/5rKdISHqN77EnFfo0rU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> move_pages_huge_pmd() builds the destination PMD for the huge zero page
> by copying the source PMD and clearing its uffd bit, so the destination
> keeps the protection of the source.
> 
> A source VMA registered for RWP can map the huge zero page with a
> PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
> registered. The destination then gets a PAGE_NONE PMD without the uffd
> bit, although nothing asked for that in the destination VMA.
> 
> The next access fixes it up through the NUMA hinting fault path. Until
> then, the first access to the destination takes a spurious fault and GUP
> has to take the fault path. The impact on userspace is small.
> 
> The moved entry must have the protection of the destination VMA. To fix
> it, build the entry from the vm_page_prot of the destination VMA, as
> move_zeropage_pte() does for the small zero page, and keep marking it
> soft-dirty. A destination VMA registered for RWP still gets its PMD
> re-armed afterwards.
> 
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5e2629602221..a2b1ac11e7dd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3003,9 +3003,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  		/* Follow mremap() behavior and treat the entry dirty after the move */
>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
> -		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
> -		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
> +		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> +		_dst_pmd = folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
> +		_dst_pmd = move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));

Yeah, mostly what we do in set_huge_zero_folio().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

