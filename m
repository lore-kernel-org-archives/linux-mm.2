Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B577EC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC176B008C; Fri, 18 Sep 2026 17:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F3D6B0093; Fri, 18 Sep 2026 17:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2056B0095; Fri, 18 Sep 2026 17:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814096B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:41:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08ED180311
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:41:42 +0000 (UTC)
X-FDA: 85228205244.06.B3AD6A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 40EA840007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:41:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oj2p/kVF";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789767700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeNqrRYaLm5sJCyL+8qRVNEQneIa27x2hQRJJB+Kd7I=;
	b=nSobekxqViioXwJY1E0fxLZcbflQkrGimEPKl0KFCBoIUFcZTSYxaFHFppHpy7DnQVnew0
	OO4G0Lu40RLbR6EpSRiUazxIg5T/Ym+n+OHZeCRIdDrpeN+GnuJL2czGn0wb6wrase5yTr
	m/UFpP7/s6qr4vvkLaOuA9jBkcgVmlQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oj2p/kVF";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789767700;
	b=FL8YJHUx91+O2RJdyTNgffI7lsvOSvnYsDQK0aduYSgF6yL//Q3QS2TMH2frc2j++J33t4
	LfQOXiVlKaHoiTTD8/+mvlauim6dCED0kC8+sarSrrTztSrln8C7rm7NliO3VmownKYN/Q
	+32V3Gc7eHJ8PS4sxeIsnmvmWAr7pOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD2C06053B;
	Fri, 18 Sep 2026 21:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808B91F000FF;
	Fri, 18 Sep 2026 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789767699;
	bh=PeNqrRYaLm5sJCyL+8qRVNEQneIa27x2hQRJJB+Kd7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Oj2p/kVFBTo4rNCg3ja/p7FHen560WeDm0VQ17VhhVE627tVA3a9rcWf8FwWkDiBx
	 YZ0PVffkg7aIdn73zU4yaQPxj5enoT9s9f4KDiHEFELBjXFdNAogRv09ocbsYhFSV/
	 9YVro2p1s0S/yIlmNWCjL3EG32QmyfClqu6EOHG0zy/Ma8sOcnq0n3PNrQpzCR0M4k
	 GZ26ZGZ6eQW9pmGjZijM3MwMbWe30oX5T2Ziexnq5FrL0BCjcLmI9mEDqby0vI4mLN
	 +P+SCP52qV7tqYPC3e3Ht3QOeSS1EkBBrGKTfDHHrja/Zi9IkgYK8CzuYZ6jInsIQS
	 y7q+sxyLIn9kQ==
Message-ID: <92d0078e-afdc-422a-b624-0a3ca9aa307c@kernel.org>
Date: Fri, 18 Sep 2026 23:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 06/29] s390: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-7-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-7-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40EA840007
X-Stat-Signature: 56idf96a5pzu6wno89myacqgrqw597ui
X-Rspam-User: 
X-HE-Tag: 1789767700-664887
X-HE-Meta: U2FsdGVkX1+uS3lf/+QGZpkM4RcvCyoWvk9U1YLcB4M7C2C+hvwwzqzKyvYpdfftnNaEvlYkZR+Aje6QmZA37Qn8tFhI8LrOqL1YA+BZQRu1xSEdh7T9vMJjpUg8EXJeB43CPYgCckMuwcV6onJSyciCgD/K2sGvBoeFyPEEqzC6++dJ9TstmaBUVG/Z1iq8/bDbJ4ISr2yCJb1bPrq0fVjQtqxG8f7q1taWikD9Zx+IodqvWxyKlsD1t6xCJWOvG4/2r/9W2ksMsaLzdhD7zWLfrKgQmiKehwbgCly0K5ABv1F71Iw+fwNWpHt0GIbRwv0geODkZk3zZZ5cvJl1YKB8BYysq77jogtPY02ly9iDCEb8G+w/oWKTucHTkSRKlEkpJeKY7o8GbcqyedUygxSjbi8SvXTI+aPG7dRLLjBtQU75EH3ZON9oLsMsTdVXx3l5pQLizXLUItpmi5cO5o4xHZ28GEQ5KcdHu+JanCTXpv4wUradgCE58zU1WO7RvC3zzbtSrAWrB7r7K2GxoY2ptDxAYrWHN4kLwkUKIPcKlB9NKweLcv3BGoW1TfHFiLUGdk/TJw/HoMbdHf4U2B0aKZhNf0MuuoIHpoTtYuZhFQ00QLb0iWGIUOObIx88MyfqiWfJgCBhHBdqs08pSCBjeF+jqGRfqMY5XvS+LTCj/mNYsHal8bJBtMIih1r6vN/wXUKeIgzgDnCc51AEekai2HIlwy/jvYv+omNtDM5SDIvE0clTlyZdDyunGP+cHcOuxw+mIJ7P7jQdxOll5NskALJSxfIgSQZbKqmJi5d0ffqGrxqJPyjVetWEVRySur01KH9aiI5+JxXl/ZYSZWUTa2YfUxGRuptWvK/4W1MRALfNkbpMqq3kHpWt4ucfpZoY1g+D4CLKS4vTYLBt1tWEkWSjToqdE7vv4gBIKhGVHtFWUuKRBVNrhaNmdXmEc6bvXJk4A42nkyxMG8L
 FMKd/I/J
 q0kIGRlGCzX4Bvi0YV/VN9+QUQMPU8ulLy6ks6rg3jE71FKn8g5LeyYUvMOxyU1y7MNyoApKsM+LV3DCDv5pnGOBtKuvOKu8sDCl3G9Lp92qVG7asPrAJskJL4bhzzQM7yYwZKZMa3YbX1hBDNglHjG+jIx7TV9rmU7NXH+tFH0OQiTs79Pm8IWFF8tRxYtFr10BxtQFPXtgswSN40LfbtF9YyVQ4OWkMYTYnOYMOT07GbXojZm28cmsCLaVLsSBSt6182jq8q3o3ePo83w4v211C2lvalRziFI4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> s390 is the one architecture where a swap PMD is not a swap PTE in
> disguise: it is an RSTE with its own layout, converted to a fake PTE swap
> entry for the common code. Give it its own exclusive bit rather than
> borrowing the PTE-format macro. The two happen to have the same value, but
> that is a coincidence. Bit 52 was documented as unused; document what it
> is now.
> 
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/s390/include/asm/pgtable.h | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 2d5c2ab06de98..0790a0884cfab 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -333,6 +333,7 @@ void setup_protection_map(void);
>  /* Common bits in region and segment table entries, for swap entries */
>  #define _RST_ENTRY_COMM		0x0010	/* Common-Region/Segment, marks swap entry */
>  #define _RST_ENTRY_INVALID	0x0020	/* invalid region/segment table entry */
> +#define _RST_ENTRY_SWP_EXCLUSIVE 0x0800	/* SW exclusive swap bit, see mk_swap_rste() */
>  
>  #define _CRST_ENTRIES	2048	/* number of region/segment table entries */
>  #define _PAGE_ENTRIES	256	/* number of page table entries	*/
> @@ -859,6 +860,28 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +/*
> + * A PMD swap entry is an RSTE, not a PTE, so it needs its own exclusive bit
> + * rather than the PTE-format _PAGE_SWP_EXCLUSIVE.  The two happen to have the
> + * same value; see the RSTE swap layout above mk_swap_rste().
> + */

I'm not sure the documentation here is warranted. It's all documented above
above __SWP_OFFSET_MASK_RSTE, no? I'd just extend the documentation there and
keep it away from these helpers that just use the bit.

The fact that they use the same bit doesn't really matter.

> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return set_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pmd_val(pmd) & _RST_ENTRY_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return clear_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
> +}
> +#endif

I guess we could move it above the pmd_swp_soft_dirty() stuff in the same
CONFIG_ARCH_HAS_PMD_SOFTLEAVES block.

> +
>  static inline int pte_soft_dirty(pte_t pte)
>  {
>  	return pte_val(pte) & _PAGE_SOFT_DIRTY;
> @@ -1900,15 +1923,16 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
>   * Bits 59 and 63 are used to indicate the swap entry. Bit 58 marks the rste
>   * as invalid.
>   * A swap entry is indicated by bit pattern (rste & 0x011) == 0x010
> - * |			  offset			|Xtype |11TT|S0|
> + * |			  offset			|Etype |11TT|S0|
>   * |0000000000111111111122222222223333333333444444444455|555555|5566|66|
>   * |0123456789012345678901234567890123456789012345678901|234567|8901|23|
>   *
>   * Bits 0-51 store the offset.
> + * Bit 52 (E) is used to remember PG_anon_exclusive
> + * (_RST_ENTRY_SWP_EXCLUSIVE), mirroring bit 52 of a swap pte.
>   * Bits 53-57 store the type.
>   * Bit 62 (S) is used for softdirty tracking.
>   * Bits 60-61 (TT) indicate the table type: 0x01 for REGION3 and 0x00 for SEGMENT.
> - * Bit 52 (X) is unused.
>   */
>  
>  #define __SWP_OFFSET_MASK_RSTE	((1UL << 52) - 1)

IIRC, __pmd_to_swp_entry() and __swp_entry_to_pmd() will lose the flag, which is
the right thing to do.

So conceptually LGTM.

-- 
Cheers,

David

