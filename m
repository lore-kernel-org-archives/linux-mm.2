Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462BAFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5B76B0005; Wed, 29 Apr 2026 01:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD326B008A; Wed, 29 Apr 2026 01:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2D06B008C; Wed, 29 Apr 2026 01:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB266B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:55:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB1261604EA
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:55:13 +0000 (UTC)
X-FDA: 84710530506.20.4449936
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id E07BBC0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:55:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hJQf34fO;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777442112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pq9ltivsZppH22kMe9SkiYKYPDVBbnNZTvNi+j5XUZA=;
	b=gvA/kO2SC1oV05aldxqL6grY4JPdLnfZMbALXHlqaCj2SCBkM0fIMhMMVWkrdErjTnSpX3
	BBl/nqsASWG6tRgwm4+kyoRj8vF8uqkHfIauPwxPc8EdyJHI4tqnvx5HrEHIDDdxxzkOhP
	zfPsw0nbSMfzN61nZ4HeocNvIBJo600=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hJQf34fO;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777442112; a=rsa-sha256;
	cv=none;
	b=b6bmFxlgzlLU94NrcbLSMYkasnPxRkfkm/rIwxvATdlTkaDBR7Ru3innbt9hboqkYuCzhp
	8ltc5NU5BZxOprn/PBKhMjnRSwmNLJv+ibyUcihlZbIFRRBf+Pavmh5+33ntVLAEXT8kI6
	/bRAl6czBhV7qmaL16CWiTz0+RnKcjI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777442109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pq9ltivsZppH22kMe9SkiYKYPDVBbnNZTvNi+j5XUZA=;
	b=hJQf34fORZxJi3Ay6BjtJJuIHZ2tkCBmo8bGB0RTOW+SvOrD4gg3JTk4Nivgvt0j5p9EZ8
	uXdxg6fXiW2clQPuY6YrHN3rP/XDefUDPL1yc2DC/uPODWvPA5bOQ5wkcAdY7orkjBEHUe
	7xLPJ9o6UagHW8OpCenQh4RSJU7Mflc=
From: Lance Yang <lance.yang@linux.dev>
To: hughd@google.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam.howlett@oracle.com,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	npache@redhat.com,
	zhengqi.arch@bytedance.com,
	ryan.roberts@arm.com,
	surenb@google.com,
	ziy@nvidia.com,
	linux-mm@kvack.org
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe huge_zero
Date: Wed, 29 Apr 2026 13:54:47 +0800
Message-Id: <20260429055447.9220-1-lance.yang@linux.dev>
In-Reply-To: <74a75b59-2e13-3985-ee99-d5521f39df2a@google.com>
References: <74a75b59-2e13-3985-ee99-d5521f39df2a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E07BBC0008
X-Rspamd-Server: rspam06
X-Stat-Signature: npde46yw5r3wfhfxzbrr3zd3kwhapy5z
X-HE-Tag: 1777442111-890873
X-HE-Meta: U2FsdGVkX1/2jS3ClRK0/Kzur0R3rvm15XObVansGKwsDHtDctmfQ8+GEYLmryCUZbUEpmhnxANguM1TkthuA9gG+j00zsSgLIsbzRTqq6Xwz6l8pV9ntM2vlLQlOYCP7QXqOuJ2JSl3nw7NPf15G+IEz+RiORWEsX/mUf2EdU2KyfiuJENmFJmlLHi8UoNo7lrPiZO4oIilTmYmA70Cr855erZE7UWeHBsr3An8/gNVg96i5iMCHdE3VL0dp7P2lumoKwu5i+aRCeyc18rdJ9/m4yyl9aYSgOFgrhexnykh0ui2cdQ/9d3HRAT3VICOwZVF0pbiLyXs/hnKIAjrbombIOYMt7QDiTojhYpVDKJlt6fJtYsLhCDLbdOI76yuDbL9w1yTx+qQtuh33pCu9xKr2WblBvvy4lJQlMh/r/QdU+fEKQU15edL+orED97NVBMTEACJwZ+4fsy/BPWi1KeHHuMG8INBRxGkR/2tjp21B8D9hF9rAuCT8Ld0fTmH7yvSmcLWosv0ra2dbWwBaaDdK/FENM+/kcvwHyw0y9Fn45mvRLhKi/E2XpZYakxH45XBWOE5HOyPs4Wu8Sxq0oja1kmaUupKcNqfb4NcQquwZq5WprCdagDCrya+4NBtmb3j8vUfb9l4UzDzBVuRsLcR+iCXaJI3UaA8jdWs7bDco3KYQl2Q7LpwhilMhc6hL1Ma4dCCRzzi0+/m+aZZMfzGoPdioMKxRIc389gEfj+QyI+nvLcEfqPOsA8BSopTh4pYOD46gSMrpMIa6dOqbyccbOKV/0p2ec/CGlfPOJVvoaGVjzqx3AhK5i8Sip8Ij1gyWMOAL+g76ixnj/c+i22VaEngere7FKiHuHMNpDEpWAp1R90vOS0lTU9l/R6Ha4Su/Fq/lP5GnIn3IzHpcyU7b3kQlcojP3ELHuJYBrK0/TsPuUiZWGMKe3Kg76Z0bgfScTnQZiMHCynWsVK
 Ah1/r70Z
 ufUg02dtPEHuyQcYalGSGGbOmulgb4g4JyTgJrBhRc/OuixomwTVBgN3HeYcJRcfVGzZtNqoozpuI55UMuXqUqFHVfwHEXQKRfAnqRhoaahhIbhWcVv62anlo+dFdtHnFEbV1lmaU4FAKiqYbO7EFBnK7DCziUNJPUTsEglpBUUqy/mJpoRatXE+QXyS6Fm7X9IZRAy6D6uQ2UOL43PtajVC1dFQdjap57j+Cb4dDdKpZx7u7nu3a2MrG7hlTy3rwSO+kmMkumhKN9eIzNiRtIdipHbsDfvFzqjfrewJBt1mGFaDacgdrat1UGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 28, 2026 at 10:08:37PM -0700, Hugh Dickins wrote:
>On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
>"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
>VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
>by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
>when reclaim gets to call shrink_huge_zero_folio_scan().

Good catch!

>It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
>and indeed, whereas pte_special() and pte_mkspecial() are subject to a
>dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
>are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
>on any 32-bit architecture.
>
>Add CONFIG_ARCH_HAS_PMD_SPECIAL?  Perhaps; but I think it's better just
>to observe the huge_zero pmd in the fallback version of pmd_special().
>
>Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
>Signed-off-by: Hugh Dickins <hughd@google.com>
>---
> include/linux/mm.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 0b776907152e..3b02ac43bcb7 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -3422,7 +3422,7 @@ static inline pte_t pte_mkspecial(pte_t pte)
> #ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> static inline bool pmd_special(pmd_t pmd)
> {
>-	return false;
>+	return is_huge_zero_pmd(pmd);
> }

Emm ... feels a bit odd to me ...

On these configs pmd_mkspecial() is still a no-op, so pmd_special()
would no longer really mean that the PMD was made special :)

Could we handle the huge zero PMD in vm_normal_page_pmd() instead?

---8<---
diff --git a/mm/memory.c b/mm/memory.c
index 199214f8de08..3d9ed41a46b8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -793,6 +793,9 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
                                pmd_t pmd)
 {
+       if (is_huge_zero_pmd(pmd))
+               return NULL;
+
        return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
                                pmd_val(pmd), PGTABLE_LEVEL_PMD);
 }
--

zap_huge_pmd()
  -> normal_or_softleaf_folio_pmd()
      -> vm_normal_folio_pmd()
          -> vm_normal_page_pmd()
              -> is_huge_zero_pmd(pmd)
              -> return NULL
          -> return NULL

That's where we ask whether the PMD maps a normal page, and for the huge
zero PMD the answer is simply "no".

  -> has_deposited_pgtable()
      -> is_huge_zero_pmd(pmd)
      -> true
  -> zap_deposited_table()
  -> skip zap_huge_pmd_folio()

Then zap_huge_pmd() would still withdraw the deposited pgtable (except
for DAX huge zero PMDs), but skip zap_huge_pmd_folio() - no normal folio
rmap/RSS accounting.

Just a thought :)

Thanks,
Lance

