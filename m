Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC00DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798246B0005; Mon, 29 Jun 2026 03:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7225D6B0088; Mon, 29 Jun 2026 03:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9936B008A; Mon, 29 Jun 2026 03:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18EBB6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:26:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76D09405C1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:26:07 +0000 (UTC)
X-FDA: 84932116374.13.ECE6D4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4A8210000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:26:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782717965;
	b=7G2T57yFQCiH1BzTbJuLw8vCpM/EGBYRqORoBA4Nlsudz+gtKCh0S4y9GHjcT95jxEZION
	QNVapNXmFJiCWqBwSM8HIBEUBRvFZoPptBQz6YvekvdmWKhEJyjMh7Z+TbV2u5SB/huirK
	JpVmPfIP4hBtf0B9FCIY5edhPvnENXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782717965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0t5WKgX7491nnO1TWw1NvgfhMDEnzDCwVnx65iBvCrk=;
	b=2H7OTolCgwEJMWcLQljnUa1AaZ3yJtkbcxiYkjXOnd+Vv9uhBCI29zeRPX+e8pcbVWy4nG
	ID7dz/lN8VE4A3b9yRntJV96Ax6DDJiMtm+hLl+ta8Uv/iy6H/skqxdMabNQG1pWlCL0FC
	yq86rH3cwAntGZfHOxcvwreL8UUDuIE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 169F860052;
	Mon, 29 Jun 2026 07:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952701F000E9;
	Mon, 29 Jun 2026 07:25:53 +0000 (UTC)
Message-ID: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
Date: Mon, 29 Jun 2026 09:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
 <20260628054402.76978-1-lance.yang@linux.dev>
 <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
 <1d6d699e-62e5-424f-a147-b7a75b966957@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1d6d699e-62e5-424f-a147-b7a75b966957@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5mecfscq8fs13b55h5ygacm4wtw9mpm8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4A8210000A
X-HE-Tag: 1782717965-195290
X-HE-Meta: U2FsdGVkX1/Pf9sTc0yvLQj2RmOcRK1QCSLT1Fqc02Kc+D4SIrQorPd6B8iJBKGQk8xH8FKN6gXCjqb1OoUwpeIb2l+JSPYqIsw7FPJV6BDtCuOiY7RuBnfv7YTp0C51otYuMrcKpvBzK/RS40w6prtojGROqlBAHGpUhMeGiDmSGPaywlEIJKuQU5bbIps2UHz3qWh1gCpqrmJbd/J2dEqxf/PaUTL0Ay4IXseQ32Q2em6KqE0R6OqQoCCsulUuZZh29GZJkMz8pcxC5XjkMxbZCosNHMWdgtw8gVbHIOoLHkszql2U2JtXUPwV5SMambSsXZJPpqvPfjzEJfzV3JkLKg9L6J6XawEQuhdUu9NyvfigpWlHgekWx99r3dY14s7cXnn/Ptm/B7xFmadt+GMxkw9CE4qseu3ECH6csMNNjEgHnVa4H251iOWFLOBNCqb+s1YsEQZbKhX97v2HL6tX55aJ8xna9hABLeR4ljcslKNnxWZz3v0LxHgC031LgA7/cwOpNJY0n+WyUigixBMKLWLcM/jjasc+KBhIrlNqo/29lDfp+U9T6p8060n6Xwk2io+two+T4+nc8j+q3OWZuvxOwEaI820cVWzjQI46XFxLa5f0MGG6W5Wgbg2P6zxyOcg/ik9LEGliwObByP2kEgIDWw6+MTpUAmAiUerBznsAWPTKADh+ZQlk7K60dRBOgPENx2TzQf1Z0JMUs/ePHcNn80gs3vbU0BJNLUUkdXlY1LIGX7WRquGS3qxlFdNQ9GIEIz/us3fZA8PbHUSKtbgr0piWFq2gK1jbpAwIEKjXorI0m1okuXGrke2mfkY64WPTQx8Xqp+ws//YQqY6pCj9OxjFnkzOlxLZRjLuH1TC6fw5/2bVRzPezh9XQDuNh8Nim5ueQUkm/HDKe02ud8LbkC25/xW29VGcoCFSGzgFOi56AQEc5FrIKjDfmRLXRDae6cvB6OscYx8
 duriKRZs
 IuXGBFvfI2onOiKClbnSXjIRqgR3KRcqhoFgc+qym4ee4uqLmr4BmkfsNgCL3NFY6bav9wXPMvmBcWJxZev6aM1hH85k0GJ2M4YOXWErwTiw1J08ylfzCx0MCEeUbKq0JT28g8kA8U5Cl7+lQbbKwyXvrApy5IGr8rvBWoqx28sz2H6730YDLNeG6HU36CxKU/+ui9y+OlTQmxM9nW/u1Y2bQxa4EkNPp8/kOSROPhpwwLewJAPRFHIln+ntAh2Fdm/6SyXuR/Ezfpq9FW7uZDV7oeWNH5MGs9R74SNcStnrPATWdyioV6D1YWpO+FaOqzCwpHQx1szTECXDQ9/VL9+nfBgl/7ylGQwLk0q0wvrUmJjMXA2FPu1stY/zZYvhylKg5g+hpPn25JHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 08:48, Dev Jain wrote:
> 
> 
> On 29/06/26 12:09 pm, David Hildenbrand (Arm) wrote:
>> On 6/28/26 07:44, Lance Yang wrote:
>>>
>>> [...]
>>>
>>> Yes, that's what I had in mind :) thanks!
>>>
>>>
>>> Maybe worth spelling out the rule as well: 
>>>
>>> For arch helpers that use addr, huge_ptep_get() assumes addr is the
>>> address for the hugetlb entry ptep points to. arm64 already makes that
>>> assumption.
>>>
>>> Callers where addr may not be hugepage-aligned should use
>>> hugetlb_ptep_get() instead.
>>
>> Do we have any examples where code would do that? I would think that all code
>> must properly align addr ahead of times.
> 
> Sashiko notes other places:
> 
> https://sashiko.dev/#/patchset/20260625112955.3254283-1-dev.jain%40arm.com

Yeah, that looks shaky. We do seem to have a bunch of these cases, primarily
from pagewalk code (where some users like pagemap need the actual address).

I think we have two options

1) To prevent any (further) issues, make huge_ptep_get() always consume the
hstate, and let the arch code deal with aligning it. Invasive.

2) Make the arch code handle aligning without the hstate.

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 30772a909aea3..303a1b74796c9 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -126,6 +126,9 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
                return orig_pte;
 
        ncontig = find_num_contig(mm, addr, ptep, &pgsize);
+       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * ncontig);
+       orig_pte = __ptep_get(ptep);
+
        for (i = 0; i < ncontig; i++, ptep++) {
                pte_t pte = __ptep_get(ptep);
 
(nshift/order instead of ncontig might avoid a multiplication, but not sure if that matters in practice)

IIUC, that's similar to what huge_ptep_get() does on ppc.


static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
{
	if (ptep_is_8m_pmdp(mm, addr, ptep))
		ptep = pte_offset_kernel((pmd_t *)ptep, ALIGN_DOWN(addr, SZ_8M));
	return ptep_get(ptep);
}

I'd assume we could do the same on riscv. Besides that, I don't think any arch has cont
entries.


Interestingly, huge_pte_clear() / huge_ptep_get_and_clear() and friends would be all
wrong when the wrong address is passed. But that code really is called from hugetlb.c
where we should take better care of that. (e.g., partially zapping a hugetlb page is not
possible)

-- 
Cheers,

David

