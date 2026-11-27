Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784F0606A334
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wSBlN8+6
Received: by kanga.kvack.org (Postfix)
	id EA5726B05B0; Fri, 27 Nov 2026 11:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56806B05B1; Fri, 27 Nov 2026 11:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93C56B05B2; Fri, 27 Nov 2026 11:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3C846B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:27:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1ED828046E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:27:48 +0000 (UTC)
X-FDA: 85481430216.18.D1851E3
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	by imf22.hostedemail.com (Postfix) with ESMTP id D40A2C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:27:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSBlN8+6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795796866;
	b=cYLTE6sfREagEAj5PRfXpmNd1vgcLIK53DdbwHv0ybVO3HmumA66ACMKOTbUDYvawaAD/U
	lKsDkg1bEfG/UZ/zv3EG9ZAPaRHzELofME3x1rbkywLEpf+RFmKoGTE53Ia7kY0Ry/7Sxv
	biNgJPUYobx+58LZI0HZGk6CK6nhoNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795796866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaEAs2JpnZX/wCopgOCtsrHcdnJ8AK5BNMT03LjZSPs=;
	b=kNTPTLcpG99btud0FxuSqsgy7L7/XMRjQCLuDGUkCX+vtiBG8UxVVGJHgQ5g6OSJ1OybRW
	g5WqOjrFjZX1oIDm3odPTqCcUQDO2s/nhMTzx4eCS6otSjbQr14/7YAeE01M8MknXj0Cxx
	K6Uhls1lIlXfbkTnHYcb1OfQZc/wrDw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSBlN8+6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rf/MCpoYMsHhZVqN9YRHgJpiVwU0YEKm9+BlNtnxvdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795796864; v=1; x=1796401664;
 b=wSBlN8+6CURYpQ1D0VQIh2YyHNh83TwUAONbJyBL5tUf1D7B2KBBvHws1ZV575NwoYlEn3lG
 rcLT/nJTaB55wTpY1F+/Lm8lYPYBZnF12QmL4oYT9wxhUHqB+fVbI8cxF/reUV5nX3xy3OZ0zp0
 G1N6LI8y5fMd4Juj1SJOERsQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 40760d7bb28af9f0;
	Fri, 27 Nov 2026 16:27:44 +0000
X-Mizu-Trace-ID: 40760d7bb28af9f0
X-Migadu-Flow: FLOW_OUT
Message-ID: <63e62346-fabf-4426-88a3-056e1d909fab@linux.dev>
Date: Fri, 27 Nov 2026 16:27:39 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for 7.4-rc2+ 1/7] powerpc/book3s64/mm: don't count
 invalidated PMDs in page table check
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Kyle Zeng <kylebot@openai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
 <20261015-anon_vma_uaf_fix-v1-1-7b977303b42b@nvidia.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-1-7b977303b42b@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D40A2C0003
X-Stat-Signature: 7d1mr1qrtt5d9tqjwcxhattzbicpsfjs
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795796865-757045
X-HE-Meta: U2FsdGVkX18qyw/0zGY1duNeodWwEg2p9lQ8MkcKZ7LvZY2JRkQLZG0cWeYsSxsxL7WHIJZnr2di6R7aQYlaGtDtXFK+eFJmwYvWXOzTkAQVra+95sC+4KyA4cKpWIsEZevKvSwQQyCk1uEBzHxTJLZKjqMkEuSeXOD86mF9f/DT8xXAOGslrKEFHuNcU+DPLDoliyMd1GGrUcaS6YJSn8cS6AbeMyWmMiOimng31IwUPKyUATqJnIrNyI3gbPD1jxvIYkjuQIdk6ClpNDik9eIqjangAzFaeIZj2EqTfH0+xAJY21gx4E1w9H6QWpNG1WaeEvMrGA+7VyfTxKdIyUVfAUi5Mg4osIthA1gnnyyQ8+z4cU6T51jR/641L87bQA3yYLnUzg7oYlwXON+OnpwoUWqqCRWrGdSL+l84dGV/6O3jkIMUNgnn/UPsvRjTkm6CpJN5Bj+D6DO+JmAZWJYA+mfWJv/cA2waemy4KJXTHsanjZSerKUagZfwH2U0pgILBhpKshtAPzoqX1GdiWiCOElDnLCGgcWKhhskx4S7gaJxL9fYYhBU84aP3OuMcrXEdEnvpLvh+4+QWQRSv+e5rw5S0izlyp+o2JVu8UPgpa06VOZBKQ9JmiQN2mzukr2gD0neeMCPi+erJ7+wg3B2ombjIHp0pmqVkw4vWtKzBbGuKqx8nMcnElxw+xRB23bcWfC6BOFNCefoiSepJMILY96FbEIEGYqBE//moIl6olfp18aU9hadGlFui9KJKnMNkvnoKPyeoeKOEUxSq1A1UZnLgXFPt5Yn57wEpooF/sRS3Dxoc6njHncB23BARehe0Feqr4e91aKH10IYAZKKI3tN7dofF9TgqNzI3iEzejqFwN6NE+IScmw1RDV3UlBhXz0ffoOq8/q7OKC5DXr4V9s9C+eAr7DN5XE3Xyp1/PT7P9CunZyezYHCwsuGklDPm8vs+66BIn0v6Bo
 rJeqLVL6
 TLkJWga3qFWh3IWHBjjmzZzw9xuPWENbFnTL36QnDsmz4Ao+ZsRU+2j/5A0Per9XpMc1vykvnSRotlOzvF1K2CVoa+u9H0aJhBqcfWhQ28iHXY9D05vICbXADean//7JC6v7jpbzW52jefRaXZF4FHmEpxy2LqQFri1HWU/r2QiehR7YzPRysAn9eRtLxUrN4u3D73sYY4WDAdQ3qOGaS1RjREjW6uYvwArwFZ++fL8Rx/QoP+jjCGQQH53Kt7cVtbvbRCIUDywK2nXUA3eAGf66x3Q5r2VkKYEcR+4ojKSmpK7XuRuDcnlaEVrPQdTbuQra2+PkA0oqRQ+KLbvKPiCDmlMGvtsSr8VdbtOiPtqCymN2lYhiM6YXqO7GhYalLDum1RBceoXl9UzpTS/QO5ScRLyNEBlROmdLC1DIusqvfDVmAD3UL3NBm4LLgSIqcfV1D9NDUF92QRSSRJZbqjWB0m9lBMuvAP8qvO47F+/fQTIhMzCKYvYy2doolLsqaD4aj0GlyOHUyZFKV5CHQuHYIrHYcVXmk5nGQrIz1vbhnqfr7whI4MMfVF93lJXHmKAIl2Pxyd70w6OdIwPHZkMUgpcWI0I19p3voWz8UTE5+/nxBUBvnQqJnnas7AkcvFjMez/PBptliZ0MivM4CPgUrlCZpIoBWKMMs1lOF4G00l+Llh3/iKsnJI9AK5w75AiU97PJTiwvfFhGculZJGUGP2wC+NtXABuxYsHdCrr1xHvr4QsbxxvpWmOlAnMRGYo6LCybLkj8qJ1GBMnYoq7Vx9PDeU3/wk1uIWTUeRiHmMc4A6L9T3f3SNsAZHjSbkdRgFe7z1GMu0YI2qa/NJcKiaxH3MyjB3BDjz9hGoQDi7UNvAwiuTvVNFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 15/10/2026 11:13, Zi Yan wrote:
> pmdp_invalidate() replaces a huge PMD with an invalidated one
> (_PAGE_PRESENT cleared and _PAGE_INVALID set) and calls
> page_table_check_pmd_clear() on the old entry. This decreases the page
> table check map count. When the invalidated entry is later replaced with
> set_pmd_at(), as MADV_COLD, page_mkclean_one() and change_huge_pmd() do,
> page_table_check_pmds_set() in set_pmd_at() clears it a second time and
> decreases the map count because pmd_user_accessible_page() still counts it
> as a live user mapping. The same happens when it is cleared with
> pmdp_huge_get_and_clear(). Then the map count underflows and hits BUG_ON()
> in page_table_check_clear().
> 
> Found by code inspection and confirmed in QEMU (pseries, POWER9, 64K
> pages, CONFIG_PAGE_TABLE_CHECK_ENFORCED=y): MADV_COLD or mprotect() on
> an anonymous THP hits the BUG_ON() with both the radix and the hash MMU.
> 
> Fix it by only counting entries that are hardware valid, so an
> invalidated entry is skipped, as the patch "riscv: mm: exclude invalid
> THP PMDs from page table check" did for riscv.
> 
> Fixes: 641d47d4c963 ("powerpc/mm: support page table check")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Madhavan Srinivasan <maddy@linux.ibm.com>
> To: Andrew Donnellan <andrew+kernel@donnellan.id.au>
> To: Rohan McLure <rmclure@linux.ibm.com>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index dff8790a047db..392474972777c 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1091,7 +1091,8 @@ static inline bool pmd_access_permitted(pmd_t pmd, bool write)
>  #define pmd_user_accessible_page pmd_user_accessible_page
>  static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
>  {
> -	return pmd_leaf(pmd) && pte_user_accessible_page(mm, addr, pmd_pte(pmd));
> +	return pmd_leaf(pmd) && pte_hw_valid(pmd_pte(pmd)) &&
> +	       pte_user_accessible_page(mm, addr, pmd_pte(pmd));
>  }
>  

LGTM.

It fixes the double decrement in the page-table checker
and preserves how kernel walkers recognize the temporarily
invalid PMD.

Acked-by: Usama Arif <usama.arif@linux.dev>


>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 


