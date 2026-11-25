Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8D5606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TKIcPLRi
Received: by kanga.kvack.org (Postfix)
	id 8A5E26B08CD; Tue, 24 Nov 2026 21:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856EF6B08CF; Tue, 24 Nov 2026 21:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F136B08D0; Tue, 24 Nov 2026 21:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 274586B08CD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:13:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 804C340DFE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:13:55 +0000 (UTC)
X-FDA: 85472020830.12.4FF2AEF
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64E96180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:13:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TKIcPLRi;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795572833;
	b=Pd60RmCGVv0tDe8az6JhljCp8UgO5vHMDXqdX8ibMdW1qAsbab0OMlEc5GjmNqbM1g7W0Q
	QW1rSc7xe6ig6xVmVukwHq8kT+hjbT7VNJ5ns4oKDri3IjmE9xjua0+OrKdmbODdwrP5vR
	ReQCAckmyuNCQ7oDv+Bfxp+E2VbDjrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795572833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mR75b2s1mWNZlecKjEzTGrzm1QNi2Di7hyQA/N1UDPw=;
	b=dQv/Je78LBKZyRClMzeGOHG31WgtRm2+xc8QhtZUd3sQo7LWJjCduX5usQJNDFihdlyIg4
	vEGFkFkW6EPKiaKM90TXnOC/qKxemKecyISc6cgMF4oK4Z0WeqKTiS2GMbihy5GKqI1aQU
	3rVMIYxRuVmQgDvxhefv3suC5uRnEtc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TKIcPLRi;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/wCihSMxaGc1SlzGU4LTrs2HdI1tRtEU07xbfbw90YY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795572831; v=1; x=1796177631;
 b=TKIcPLRiQdBI9FOqQuNoL62zEIKv2eSYJB9lJzAomqVZWkeQcJJj+51U7ZfxlxK8/+Mo/Lox
 T42BrOC8MwsE4CzTw0AMVd2TokR+3uxTve4ftGrV4dlcO2jWgKAO3SNtfg7hFr7i5803ww12k/d
 C9LHUAMz2KRxAIp9ZMkC2Pqw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 59fdfd6286176d23;
	Wed, 25 Nov 2026 02:13:51 +0000
X-Mizu-Trace-ID: 59fdfd6286176d23
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: nico.pache@linux.dev
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	usamaarif642@gmail.com,
	xu.xin@linux.dev,
	ying.huang@linux.alibaba.com,
	yuzhao@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v3] mm/ksm: prevent zero-page remapping during ksmd-triggered THP splits
Date: Wed, 25 Nov 2026 10:13:30 +0800
Message-Id: <20261125021330.54446-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
References: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64E96180006
X-Stat-Signature: joc3w5d8bp7fi7x9je8dedy56z7y4was
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795572833-305970
X-HE-Meta: U2FsdGVkX1/x7FaM0NnziflrerIsAqtNtdjZDwzmhm2hBWoVj1WiIJQTNPpXN6JNlzwB1MS+Poeguuk/dPcEWQtQB/AiU83EEUG/SAsivkA2FhR+7hXM45TrkQjDP2BUp1RffsR51eVr2CWof0dExGQvCn1CuKkr9qm68NYl7Ph9l+721FjkUdsWMzlyn03Pb0uVHmD8Fp6bChQ21GwdXMet2RcqvIVdCtolB1RV5waQFvEGyXQf83mJJYUudEC7346yHRFNMWGYCzLA1j5UIuT/KNFyZHtTFm8z/XM6E0VKVQbLLtw23kkHarO3DIpEtOX27MC/cBa2It4f2AFo4X5nKHv8He9CUadAVFpQshZLFl90ACzVEm2L+0vX5W952XVyiDPM5cCrmcrDNvj4DNa8aVAc0UcNYDkRHCQblfv3dP0IlmRUfM6gRAW/Ritmyo7QedQ60NPilPb5uTVV8HL4+VoEWDZ51As2mqIjJwcER1wCgOJ1ReoYmKcXOpS8uV6wHABPgHjbTzDP3la7ob/ukEmBgUrmGNdXB4ulp9X8Dj3uJsqyK3eaujaRZMWsxpDpQwbmeAvh8PrND7Jxt+UfO6nF+2yzfYLwlEaifvRcb110W46KwOwACBtYX1ffr/NIQUWmYaCIDHux6VLYCU+zm2MxvD5IwP2+efx17eOOTPKNY1YxsyKD7qr8vZaBidFCWsemEJT4er1Fso/R4oUnWTe1BZQAFByCih1AXZ6RgyHKWhB8UngTZZvEEihPHRsa9D3F/8sCSeSQ9drFnZgU+76zIs/f7MzquljYrQcN7lGJeqW6NvX6kN6KlXVQPQMdFxVDPUHxH2uNPpjeUL4TzSXEzWQqfh6Fko8DBXSNi+BPBj+fcgcLdXFl3jhHbIeG4h+28zqdKgqoWEwRi7+qgW/01WUzm9y+wQFuOWI9n068wdNQKPyf2WhSa34+UVF7XaKd7xkHsDu7gZG
 H1bcS/zv
 Wj9jkwfRIpe7kC2UU0FHt2yC+YLo0OYOEnD9YTranb6PArtE4dgx2Psf5Jian25hkc3d9SpgLWk+Tu70Hd+g/Lj+WgXY72EBOLvFookcPFfhxUCVuMkiXmVo2sQN0GOUtp7APU/tIyMGzKD0gtEd3x9ixCw2kanlRL9IcXB0uu+B2606bYfvSVC2kcU60SyM5G9jsfUwdMSlQDvrnH1dFtZfkKFU63exyuKaMf42ofujmeotLdYF8MLLlJbFyN7tPDb7SqnVpp5QrZP/mzihwj2q+GK23X30TqLclKOa3wEcT6yz6iqd2r5KoIuQR6DdO6/t63WAlMUfyNN56CvfvyxbMqK5iRAFxGORCg7ncvnzpBVEzd05w+bHk4Cos4Sfsz9tD4TGiVPtN6Wu1qkRijHhCTOnhXBGcot8hJoWAbuUMiRjAdbZUxSpOloRbwyZVHZvXj61qAy5j7B/LvYNtN8u2JkkHYzPTJ3z89kT2vpr7lp6A4Xh4jbsfz8Nt2+xq2nUDr21BYd8MvtbRGDThSGUBtFihY4OJaqTU2qSVnWwGY9Q+b/pBdSfpyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> when splitting isolated thp"), splitting an anonymous THP remaps all
> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> This flag is set unconditionally for every anonymous folio split,
> including splits triggered by KSM.
> 
> When KSM is enabled with THP=always, this causes two regressions:
> 
> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>    split_huge_page(). The split remaps all 512 zero-filled subpages to
>    the shared zeropage at once, freeing the entire 2MB THP when KSM only
>    intended to process a single 4KB page. This bypasses KSM's
>    pages_to_scan rate limiting, causing ~1GB to be freed almost
>    instantly.
> 
> 2. use_zero_pages=0: The same split side-effect occurs through the
>    stable/unstable tree merge paths. Each pages_to_scan iteration
>    triggers an expensive split_huge_page() that silently frees 2MB,
>    while the scanner wastes cycles on tree searches for zero-filled
>    pages that were already freed as a side-effect.
> 
> Introduce current_is_ksmd(), to check if the current task is the KSM
> thread. Use it in try_to_map_unused_to_zeropage() to skip zero-page
> remapping when the split is triggered by ksmd. Allow remapping during
> reclaim running in ksmd's context.
> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
> This patch fixes a bug in KSM where the pages_to_scan limit is
> bypassed and the policy (use_zero_pages) is ignored.
> 
> Commit b1f202060afe ("mm: remap unused subpages to shared zeropage when
> splitting isolated thp") added zero-page remapping when an anonymous
> folio is split, including splits triggered by KSM.
> 
> Skip zero-page remapping when ksmd triggers the split, while allowing
> remapping during reclaim running in ksmd's context.
> 
> Changes in v3:
> - Drop the patch gating zero-page remapping on shrink_underused.
> - Allow zero-page remapping during reclaim running in ksmd's context
> - Add a comment explaining the ksmd check (David Hildenbrand).
> 
> V2: https://lore.kernel.org/all/20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev
> V1: https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/
> RFC: https://lore.kernel.org/all/20260508170509.640851-1-npache@redhat.com/
> ---
>  include/linux/ksm.h | 6 ++++++
>  mm/ksm.c            | 5 +++++
>  mm/migrate.c        | 8 ++++++++
>  3 files changed, 19 insertions(+)

LGTM, so

Acked-by: Xu Xin (vivo) <xu.xin@linux.dev>

> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index a0d358a1feb6..23c8e9f60118 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -17,6 +17,7 @@
>  #ifdef CONFIG_KSM
>  int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  		unsigned long end, int advice, vm_flags_t *vm_flags);
> +bool current_is_ksmd(void);
>  vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
>  			  vma_flags_t vma_flags);
>  int ksm_enable_merge_any(struct mm_struct *mm);
> @@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  	return 0;
>  }
>  
> +static inline bool current_is_ksmd(void)
> +{
> +	return false;
> +}
> +
>  static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
>  		struct page *page, struct vm_area_struct *vma, unsigned long addr)
>  {
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d24b129932bf..60656b05419a 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2873,6 +2873,11 @@ static int ksm_scan_thread(void *nothing)
>  	return 0;
>  }
>  
> +bool current_is_ksmd(void)
> +{
> +	return kthread_func(current) == ksm_scan_thread;
> +}
> +
>  static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
>  {
>  	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 65869b8acec5..b0949f43ed5c 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -305,6 +305,14 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  	if (PageCompound(page) || PageHWPoison(page))
>  		return false;
>  
> +	/*
> +	 * When a split is triggered by KSM, let KSM take care of scanning for
> +	 * and deduplicating the shared zeropage. Reclaim in the ksmd context
> +	 * should still be able to reclaim zero-filled pages.
> +	 */
> +	if (current_is_ksmd() && !current->reclaim_state)
> +		return false;
> +

