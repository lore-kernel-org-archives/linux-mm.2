Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EFEE7E0B9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116C76B0005; Mon,  9 Feb 2026 04:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4DF6B0088; Mon,  9 Feb 2026 04:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE5E6B0089; Mon,  9 Feb 2026 04:54:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC06F6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:54:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 716BA1A0727
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:54:41 +0000 (UTC)
X-FDA: 84424458762.09.0A1AE93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C175FA0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:54:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArfQZAoc;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770630879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrDoYLyiC3yn1nM6rKNC2iEmkXxrMHxQFeD9sl87gjA=;
	b=pSeYnRY4b5jwiFl+bU4B/29kiTlgZvtHw5QsAIHBXgfh7yR1Mq51mNr5bdGHlQGEWdeJeT
	JBPOF8BS+QjYU2hrMaL83DO5GVXpYcIvXaX4cbJDjGL1+gHwD8HTIxJ027bVlNsYvpc8qr
	oPRx4HSGDqn+FNeH9NEkPmiwIZ9joa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770630879; a=rsa-sha256;
	cv=none;
	b=5N2n8JJiNin6ISTurs18rW5P9Uj9pLFsz6J3XxNKpRK8+2fucV102TW0qUjca0M97StUTO
	y4ubf0X+Jvcu1oZIRU/ZhQa9gCrxwKgBHrvGv481rddbL/8uedfqJnGefceBVKIxDovIQm
	M80gcp/g7qhpzzuiLlSELHoAgYygQlc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArfQZAoc;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E94B600B0;
	Mon,  9 Feb 2026 09:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E69C116C6;
	Mon,  9 Feb 2026 09:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770630878;
	bh=3tBHDDvBJjbjVnORXt//tsMxH53+PSsCsTP84KGDkeY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ArfQZAocn3bNOTGiysPVyOMe587mUPIZxvyXEE2Xhmcgglt7QoDFMi/M9Nnt6wohk
	 NZz+f8NBf1if+1TK9UQz0R+uY005AH8rYmZJ1LVKkvfd3l1qkxuPW78axr7gpZDBFH
	 unUm/P6Pn1tIvbeUobFDZLSk0Na8iGT96+hqTFrtI81ETKk24v5akjOiN5K/0AjD5x
	 rI5UN5k8mVbb6/owKbo4OdpIsSyd/dpXw9HnhaVopbDBBZqI93jE3ObIL9nkmGkUsC
	 AZbFx67KRYSxPSVl7oipYgkgroohTjeJP63MEAOZHaaK1Pgn601KvrBFay8s6kkfU2
	 Z28pnDyucyYaw==
Message-ID: <e5175f66-56fd-437b-a183-b2ccc3f54f94@kernel.org>
Date: Mon, 9 Feb 2026 10:54:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: rmap: skip batched unmapping for UFFD vmas
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, harry.yoo@oracle.com,
 jannh@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, riel@surriel.com,
 rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz,
 will@kernel.org, willy@infradead.org
References: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260116162652.176054-1-baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260116162652.176054-1-baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C175FA0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wjjsbhy5xy39rdh1th3judztkuukifxz
X-HE-Tag: 1770630879-529705
X-HE-Meta: U2FsdGVkX18qBzHl6CrkScbbGs/Ghck83DJacKv3pJvXvpD1SuJM5E90ZqJQ84zY0zYQQJOL0SdxyR9AI9xPqah8Ti2AH6bgrMXm7lHQIT/curg+2O1T9fq46AT+Dmr7kXd6WaeUQpZYRx2zpW8xGnkskxGuv37vOE2OlELPmPNPLF5iWMOwTNojeA9fpb1N5DeRgXuRs8ihJSvt4IG9tNf1BDtEHqDiV4CL8EYRVFlIapSoaMw2C0yjehNYyyBn9qCYTaRYR0CB48a3nwsPAkhrfHSy3yl0XQP+nvshckrnvshaL4iTx2XmczeOtcJE0XEKshySohvkGqz0l3GHA96ILYbtzZm/XSfT1wpVQS22JDThPWnsEFvEDXxFaWGiwVFOkMBZ8loeOJyJzqbCeBzx/S1in+RjibfXDxTsB7XWxESqPAcdY/nycHh2OT6r7ObvIGUSfZlDvvtDcQgCeQF69B+hqmUm+74QzcDtsPYE3EoaSv35aXPgKem/vRs5Zc7Cxfma9pdL6W0+Emo4UmF4IufnXfrIoae3qpVffhDxw91ITnrFnvO0yPQ0mLD49Jjo9zbUv8aDpFn4gO9AnCt8yeHcWqtEp18CPQuQB2fmkAjntSHzz6GFMf3nmYyn9E2YY2OP4jFdoHTp5nZohzsud/kx24xdzmY2aKZq9ADxcI3YHoAme/DIwZySHQyi5PxYuH8uj8S8MRDTLk8BXNfxU4UMIsUAuph1+CoN4/mmxsyIAosEyyrnQigr/QelC/+GX2p413Lr5f3wpDvHyjOOodX+QHl/BCFy9fS/FoOofc6JLSq4pqs1q0cMnNumH4p2HZgapEJgafVNRqWoixdMHV/eU5MN3gTus8CQeKveD/v43ScUEkEaoFvnI4m7qVkg7nCYZYoGJhRYbG8RihdVa9tg5gfH8i5vBTZy81MDM8XLWJmXczwn/0j5kPPuDOr5bw564ogSKbohuJV
 rISlq2EL
 kJ5TNjGJnRALyppD07ezFGDWp66/mV+ambwUV3dCXw8FI5K3OeHqk5lFfMhs+tbfTUYN/z9v1w7yMTVBJLnT9xoxIr6B/69O7YV+sqV6Zs9JmsD3wnEOlEf2mj/fCX4bcIKFL8MSIoQGTh2PXjs1HisjhZN2nV8vI/JxLj3QdfgRss0XXotZfzkFro9afJnH5NoTc6J1qoYx8EPa2tNqH6eElnUTjN8ojAHUnn7XC3BV+OEIEdGa3QkvQYR3pi/5NHXsxNyO6e9UzDDzWmYRZbyaYrg5+iXLJpzt/wNrtXPNZyQiZIcFWeLjEGTntMpcmgQbo99XmwZJWepcHrJY0et4g7rE4DNzmGD3B+MJE+mE3gKXUsMJo7td8d+muICZqeHbvtjJbKJyXcZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 17:26, Baolin Wang wrote:
> As Dev reported[1], it's not ready to support batched unmapping for uffd case.
> Let's still fallback to per-page unmapping for the uffd case.
> 
> [1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/
> Reported-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/rmap.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f13480cb9f2e..172643092dcf 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>   	if (pte_unused(pte))
>   		return 1;
>   
> +	if (userfaultfd_wp(vma))
> +		return 1;
> +

Interesting. I was just wondering why we didn't run into that with lazyfree folios.

Staring at pte_install_uffd_wp_if_needed(), we never set the marker for
anonymous VMAs.

So, yeah, if one sets lazyfree on a uffd-wp PTE, the uffd-wp bit will just get
zapped alongside. Just like MADV_DONTNEED.


I'm fine with that temporary fix. But I guess the non-hacky way to handle this would be:


 From 53d016d6e6f624425dbdbc2fb1dec7c91fbef15c Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 9 Feb 2026 10:52:59 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
  include/linux/mm_inline.h | 15 ++++++---------
  mm/memory.c               | 21 +--------------------
  mm/rmap.c                 |  2 +-
  3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..8a9a2c5f5ee3 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -566,9 +566,8 @@ static inline pte_marker copy_pte_marker(
   *
   * Returns true if an uffd-wp pte was installed, false otherwise.
   */
-static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+static inline bool install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *pte, unsigned int nr, pte_t pteval)
  {
  	bool arm_uffd_pte = false;
  
@@ -598,13 +597,11 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
  	if (unlikely(pte_swp_uffd_wp_any(pteval)))
  		arm_uffd_pte = true;
  
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
+	if (likely(!arm_uffd_pte))
+		return false;
  
-	return false;
+	set_ptes(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_WP), nr);
+	return true;
  }
  
  static inline bool vma_has_recency(const struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..0a87d02a9a69 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1592,29 +1592,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
  			      unsigned long addr, pte_t *pte, int nr,
  			      struct zap_details *details, pte_t pteval)
  {
-	bool was_installed = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* Zap on anonymous always means dropping everything */
-	if (vma_is_anonymous(vma))
-		return false;
-
  	if (zap_drop_markers(details))
  		return false;
  
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return install_uffd_wp_ptes_if_needed(vma, addr, pte, nr, pteval);
  }
  
  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index 7b9879ef442d..f71aacf35925 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2061,7 +2061,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
  		 * we may want to replace a none pte with a marker pte if
  		 * it's file-backed, so we don't lose the tracking info.
  		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, nr_pages, pteval);
  
  		/* Update high watermark before we lower rss */
  		update_hiwater_rss(mm);
-- 
2.43.0



Does somebody have time to look into that? We should also adjust the doc of pte_install_uffd_wp_if_needed()
and turn it into some proper kerneldoc.

-- 
Cheers,

David

