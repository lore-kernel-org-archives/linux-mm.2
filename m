Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1416ACC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA5C6B009B; Wed, 14 Oct 2026 09:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D56E6B009D; Wed, 14 Oct 2026 09:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F236B009E; Wed, 14 Oct 2026 09:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48B56B009B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:19:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D036C054B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:19:58 +0000 (UTC)
X-FDA: 85321289676.21.D87DE7C
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id 236644000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:19:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRRCaIoJ;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRnoPDx1VLkNEQVq70EOdlXp9yd6QG+3d9WMxF4yYts=;
	b=F27Ggk/EhBw4eaL3T/n4l5yL5JHRintsAPprAj+exh7dxtuVe8g9x7cZzXC7GqO8FKTPRc
	8S8dWjG6HM/WmUvKymuMKeQS4ktZtqNl2Te1Qpy9sfuFGv4ZgjVNyquE8DgQT8VqFbUf3p
	slOcvtzIdIOrtXE12Ws/DVoEc5YAWOk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRRCaIoJ;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983996;
	b=T/UqDX4Prvv/Wg/GLwnZvRmRmtUOUov2JczDwMFpKlOp0Wgp6NOXXO1ycQgNauusfS5QvY
	e0TIDCz1Eu7Nv5epcoRBLOJLVqLOiAmbHBvrrkS0dGNJEvmOYVFw5nrK0ZYAWEhmPyIYCi
	ZVYqtFVWn9Q/7qUwV1b1YCcSxbEEZTE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m7HcPUAMizid1DX3lRG9Tzw1zddlCTzU8zWnOAtnnRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791983994; v=1; x=1792588794;
 b=kRRCaIoJw0sJTJ/tOBQljz6AT/gufciBi0m1KrH8rJZGBnpa3mkxfjwGQPb+ELUw7hsBdCVU
 mmxqIxcLYn0+K+Zux9JnBzXzRsy69peQpfNnW2jSJ4q0+GnbK8U14BbNpbbi8550m/0hof2d0ZT
 ASh7FEPzd7j6QUveg7i6TzX0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b774b44408666da9;
	Wed, 14 Oct 2026 13:19:54 +0000
X-Mizu-Trace-ID: b774b44408666da9
X-Migadu-Flow: FLOW_OUT
Message-ID: <58e8d79b-f7c3-4ded-9272-07c309917055@linux.dev>
Date: Wed, 14 Oct 2026 21:19:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: recheck a special PMD under the lock in
 copy_huge_pmd()
Content-Language: en-US
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Alex Williamson <alex@shazbot.org>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Nico Pache <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, dri-devel@lists.freedesktop.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, Peter Xu
 <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 236644000D
X-Stat-Signature: ohf6ipmuffpxhhmdbib1bs8ki5mcpyxi
X-HE-Tag: 1791983995-306769
X-HE-Meta: U2FsdGVkX18tS5gVwSWyISjPDLFDS+N+xPq4/gMsnMwEY+abuXw+X/dS91XWOOxxSzYtPS30QCY+fl/hG2SvmCkqOBVdzdhd8iAdahISf0sQPCQ+qo2Qauzzkpj6HNS1y23uDxMNnbOHTJO7m5PMba2IQXlu8IKZxN1nQRT1KDEgXHJBMPEvqT5jRwxSQHuuJcg3tzQMmZz4R4FqYF2Q9Shfe1Gr5pBRnNAHIAjnk7N2kEDyuUDuZjB8oI/3d03B07UJ8p8Pl8VKdSZ8rqtYf6WHDAPGr2x5UvDb1TRRkS2WfkcGCxaFW8ABXdJl2XfPhq4ok6N3JmsOValLfcw2VTABB2mhTv8lBiPWWHIVARA3jBl870tjGu+o/ysXFf6lRNfe6QDYh0ECG0fcIx8b3Zf4klnruhGZOg8pkul3WNb4Xyq2CG6bquPhV/0gWD209yo8EPbybry4MpNb3OzJHianuH27zKn3k26FuvH6Fu2RoVz5ajiZ3a1rHPzWv66ziwkFJuN9ng0Fs0QCCc0E61SVObX5DlrUH8kGL9hJA96U1sRNpe4Nd8M74LcBjf8OUAWH7MgnGaiwmZLAri27eaqlP3aqiyi+0MR/eGQgLOpAmkzCQCPwzJiqzxl0I8+ViyghslaKi5N8Cuz27Yx0pXpw1y6N2oMnghJJLgY8/PiwYHOdKvarHlcunDVRiSRvvtpJ7zkX2f7lMqeFDW5wRlWiWGrO8cuJrqkQ9f4MWAPFE/Fh8BbXF0qF+EU7E4955TqcRVSel6z97RKS/VhQQB39H4sAdeO/h5Eqgs+1IO7JRshT0ckrIfpJYD4tZ/Z+Qshmgx9J3DhbZNlEqhZLH9AZFb6U+E6o5ZxKZ2vglN1hGMOnxlBGOpaZOmxz+SucnPFPlsELUPegNRIsZHvKLWNBvQW/TstuvSRqM3vEB7Sev72zGsBy5+Dfk22nKwy2BfygrP9F/OfmpPTyngV
 /08tBudq
 i9kAo2rs6MCZbyWx4inGB2JHJqpDGG9jWrI9PO40hM4BwZNAFkLsEggB8uDUf2MT76BwjVHTF1Mfno+7eP08N5W8LkLot0XDlmZ/cSm9rGfEDw+xWbdrDEA0KKeWShGK/Ay3B3oqgnHXWEi/7RmpajV7VCcptoTu5g0wH0MgDHJ5ziib4GOTgx/gLipueGUlRL/CNJyct/7DcJ+xXizP1Jp+YCmjuNy2lGIPsLNXO1uTajOwaLHUndQ0QiJpL03dZaqAtpaLv2jFD9+m+RDOS08PGvERohfZYrXqKpIqjeOIRyQfEmQjfAlSjK2yanHjOHy9hQpQHPup886lYY37/0c+JDbWBEnw04H5+EnLDUxPn40GqnmndGTXKDG+iL/fYcQ13EZgEt+kpknDp8+qZoCuyu9S8l7SClWqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 19:57, Konstantin Khorenko wrote:
[...]
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5d68acf62a5..fcea98f0d8865 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1965,13 +1965,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   		src_ptl = pmd_lockptr(src_mm, src_pmd);
>   		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>   		/*
> -		 * No need to recheck the pmd, it can't change with write
> -		 * mmap lock held here.
> -		 *
> -		 * Meanwhile, making sure it's not a CoW VMA with writable
> -		 * mapping, otherwise it means either the anon page wrongly
> -		 * applied special bit, or we made the PRIVATE mapping be
> -		 * able to wrongly write to the backend MMIO.
> +		 * The mmap and VMA write locks of the source keep faults
> +		 * out, but unmap_mapping_range() does not take the mmap
> +		 * lock and may have cleared the pmd since the lockless
> +		 * read. Let copy_pmd_range() skip it then.
> +		 */
> +		pmd = pmdp_get(src_pmd);
> +		if (unlikely(!pmd_present(pmd) || !pmd_special(pmd))) {

Why not just check pmd_none(pmd) here? We're holding the source mmap/VMA
write locks, so the PMD either stays special or gets cleared, right?

Cheers, Lance

> +			spin_unlock(src_ptl);
> +			spin_unlock(dst_ptl);
> +			return -EAGAIN;
> +		}
> +		/*
> +		 * Make sure it's not a CoW VMA with writable mapping,
> +		 * otherwise it means either the anon page wrongly applied
> +		 * special bit, or we made the PRIVATE mapping be able to
> +		 * wrongly write to the backend MMIO.
>   		 */
>   		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
>   		goto set_pmd;
> 
> ---
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> change-id: 20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-bdf7efb612c2
> 
> Best regards,
> --
> Konstantin Khorenko <khorenko@virtuozzo.com>
> 


