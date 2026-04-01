Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84993D35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDDF6B0005; Wed,  1 Apr 2026 04:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC49B6B0088; Wed,  1 Apr 2026 04:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D4B6B0089; Wed,  1 Apr 2026 04:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C311F6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:25:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 752E0C3DB1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:25:49 +0000 (UTC)
X-FDA: 84609303618.13.D3011D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F2D110000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:25:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMKvmMny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+pKXelxWiWpD7jmCsiUqArQrp+t05USfqZkU0HEFGc=;
	b=OGJTbPGlNwXu90WvZfhZ4KqHcjBdOcIngimgbDqngulHdimTEYW9nam9BT466MEy6fFgXO
	jiWNZtCsQ1gT4Dfp0KJiTREaimAPMdnMyvatlODQkZytJSjKe2D7R9Zbj+NLavisAd4/O4
	A8dj77Fl9uyKyPumjTqldj9RGJvUx0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031947; a=rsa-sha256;
	cv=none;
	b=s7+YGKn3odJieacpho79SHSju6OHaSaHUAUDxpN4IhJDCZk+OE7m0QPMM0T3UWPf3XJauI
	OrypqdbYfyJam7GphC+0HFT3WCBSgSTHGL3jr5Yi2bUSBnhIIN+ZP9FFI+rh500E6bHG0K
	ZdcXT0SD0aix3r28gub1R6VBwAtNpr8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMKvmMny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F41F40668;
	Wed,  1 Apr 2026 08:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D04C4CEF7;
	Wed,  1 Apr 2026 08:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775031945;
	bh=r/C9soS5TZMQI1KNMaWSWN1EAoSN0dpH3ZmB/W5rHbs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZMKvmMnyT2WkS1dLsktEnU16EouIBOmCj9jbYMuAOULwAoit7Z9QMntGhy3NlIk10
	 8v24TAiyycndZKF/1RYJd938bADLMEZlSHuSDyW0r5/dM0UtH5KoFiB7qz0Fx2INyi
	 RaVJy1GDYz2+xlPVrHRadfiWG5akn8NIUPfUCqGBoFj43ejfColFHsp+aTbU36mZy1
	 J/0TdPRbC+LpBpI2lWaouR1COCV9MhJKC0UPb2tQ+u/7wu6gKL+CnSlP6Gshb6hFW1
	 DzVWdE21oY0RRQxz3qcgd001Sri8GHIceCQKhZeaLFdRrr6oX0lAZ3z/0wX6pvFGDE
	 VsNbr6I6UOthA==
Message-ID: <bb40b9b5-d71e-4968-8c14-86af46e33fee@kernel.org>
Date: Wed, 1 Apr 2026 10:25:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
To: Andrew Morton <akpm@linux-foundation.org>, Luke Yang <luyang@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Nico Pache <npache@redhat.com>
References: <20260324154342.156640-1-pfalcato@suse.de>
 <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
 <20260330130635.1d8bf3f1f9dfcafc0317f5e7@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260330130635.1d8bf3f1f9dfcafc0317f5e7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7F2D110000C
X-Stat-Signature: 33qzdf9849cua6h1sxx16zs3owe3389y
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775031947-378953
X-HE-Meta: U2FsdGVkX1/2xrwn7s1VVvvRSnEYvYV7C7KWG5BQKPhZg/zs2LwiuLZKLx0Y3GojleB/OSmuWq7BUbFRx7/CWzLjEZff+zdkQgfDOEApRGhw3F3Nrm0qul1sc+NnO31Ba5DEp0/wfAnvpiVCw5i3TdcoHX73V7ItTZdK7VZnoE6rp4ijWuupnZ8Y2E5Dr3P1306V10JcQv1+JJHVt3REIOrKwsJ/CCY0gfws/37bXcCzJcYsgBVTrRHegKltjYUvceE+O3UAU57SbaVPrOj0PPvGyUdPpFveZi+8CzJ1VZXJqImMTXtjBrnK+Mo3b67j6z9n5+q5YjADllxoiHB/r/Y2eh5OfGLB8uJSNwyNrBcAG3kYivWtagHOEaLIOUWCrxqgOWCW59lpCk31gC580mY2+KU4bRtJaGbghWmEhVhkq5k6cXSCH877Jbim7H1Z1futFZqqDwvhDgsgpTvrHb6+9IFyMkdY/w3ccwkx5ojLyck+8LWrgiVoEOE4p7CBJ73A2IB0n5QweN9Bl3yK30pRCzhkilROm3I1H3Bo1SpmBkVtXUSqKB5y3tTH5VKsqYlLc7cxGr6dmA3Tej5crf41dFpog18CbYwt19LgPi0BdE/3TiHYj7gRsT5nFeWfTHVEAA3KJynH9tWZZlEMGIt2vXlUtoYTx2y3GLXlI132+fDFSpLGjHv82ptbQ57EcmYHtASAls7FAGpwSjkCRfC+BXHBV35eX/u6/4egLbMgSgIqIQzVS9Uts7i0toTZJiSMEWUpBagvVowvrkTtseW1b8dclsSgHz4X1+4veo6j6FNheSEx39CqJtT0YzbZIAr0vjh16YkuhyCUD2RGXwy70vrvdsv7tOax2G+yuvNyz+OO9bcSui75wgC2LxbvrEeMnOzX5KDtwhAZZxiIIME2QZTyyLvbcEWNh/VFUzNzaru4PtvbVntDoUfFncbJ52lUUPDEfbLpHBKQkBs
 J+WujDpC
 3fak0yME+0m9iBNGfGUoWaYjIEqPWQxbkXOh8t3JoknRhlFDR6tc2a08j/fCzvTZVqB+tWtxsLIqaeszw9sRHscAm4IEU2n4DfhF1yzUrXNUW8KdI+TGSraJHI53vEo/B6YPIJRWJr5/Vaf7z8KZAuYOWnF1f7NUwI26npV41hgqGCPAJg8cGrgsseK/rdQWO4C6I61duPpDrd1mBcZxZvspeNOVQhaNnDmmePHWDA2H5dD4m1U5sU1VChbMK3O6KzoWKrIyL+pqWdC0A3SF/7jSVESjzFNCPSI+qyolieevqK+d+XSGpmBYLOmW+cxJjW8UcNsxbn0+y/5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 22:06, Andrew Morton wrote:
> On Mon, 30 Mar 2026 15:55:51 -0400 Luke Yang <luyang@redhat.com> wrote:
> 
>> Thanks for working on this. I just wanted to share that we've created a
>> test kernel with your patches and tested on the following CPUs:
>>
>> --- aarch64 ---
>> Ampere Altra
>> Ampere Altra Max
>>
>> --- x86_64 ---
>> AMD EPYC 7713
>> AMD EPYC 7351
>> AMD EPYC 7542
>> AMD EPYC 7573X
>> AMD EPYC 7702
>> AMD EPYC 9754
>> Intel Xeon Gold 6126
>> Into Xeon Gold 6330
>> Intel Xeon Gold 6530
>> Intel Xeon Platinum 8351N
>> Intel Core i7-6820HQ
>>
>> --- ppc64le ---
>> IBM Power 10
>>
>> On average, we see improvements ranging from a minimum of 5% to a
>> maximum of 55%, with most improvements showing around a 25% speed up in
>> the libmicro/mprot_tw4m micro benchmark.
> 
> Thanks, that's nice.  I've added some of the above into the changelog
> and I took the liberty of adding your Tested-by: to both patches.
> 
> fyi, regarding [2/2]: it's unclear to me whether the discussion with
> David will result in any alterations.  If there's something I need to
> it always helps to lmk ;)

I think we want to get a better understanding of which exact __always_inline
is really helpful in patch #2, and where to apply the nr_ptes==1 forced
optimization.

I updated my microbenchmark I use for fork+unmap etc to measure
mprotect as well

	https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/pte-mapped-folio-benchmarks.c?ref_type=heads

Running some simple tests with order-0 on 1 GiB of memory:


Upstream Linus:

./pte-mapped-folio-benchmarks 0 write-protect 5
0.005779
...
./pte-mapped-folio-benchmarks 0 write-unprotect 5
0.009113
...


With Pedro's patch #2:
$ ./pte-mapped-folio-benchmarks 0 write-protect 5
0.003941
...
$ ./pte-mapped-folio-benchmarks 0 write-unprotect 5
0.006163
...


With the patch below:

$ ./pte-mapped-folio-benchmarks 0 write-protect 5
0.003364

$ ./pte-mapped-folio-benchmarks 0 write-unprotect 5
0.005729


So patch #2 might be improved. And the forced inlining of
mprotect_folio_pte_batch() should likely not go into the same patch.


---

From cf1a2a4a6ef95ed541947f2fd9d8351bef664426 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 1 Apr 2026 08:15:44 +0000
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mprotect.c | 79 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 31 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..8d14c05a11a2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -117,7 +117,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
                pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
                int idx, bool set_write, struct mmu_gather *tlb)
 {
@@ -143,7 +143,7 @@ static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long add
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
                struct page *first_page, bool expected_anon_exclusive)
 {
        int idx;
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
                struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
                pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -188,7 +188,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
        }
 }
 
-static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
+static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
                struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
                pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -211,6 +211,41 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
        commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
+static __always_inline void change_present_ptes(struct mmu_gather *tlb,
+               struct vm_area_struct *vma, unsigned long addr,
+               pgprot_t newprot, unsigned long cp_flags,
+               struct folio *folio, struct page *page, pte_t *pte,
+               unsigned int nr_ptes)
+{
+       bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+       bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+       pte_t oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
+       pte_t ptent = pte_modify(oldpte, newprot);
+
+       if (uffd_wp)
+               ptent = pte_mkuffd_wp(ptent);
+       else if (uffd_wp_resolve)
+               ptent = pte_clear_uffd_wp(ptent);
+
+       /*
+        * In some writable, shared mappings, we might want to catch actual
+        * write access -- see vma_wants_writenotify().
+        *
+        * In all writable, private mappings, we have to properly handle COW.
+        *
+        * In both cases, we can sometimes still change PTEs writable and avoid
+        * the write-fault handler, for example, if a PTE is already dirty and
+        * no other COW or special handling is required.
+        */
+       if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
+            !pte_write(ptent))
+               set_write_prot_commit_flush_ptes(vma, folio, page, addr, pte,
+                                                oldpte, ptent, nr_ptes, tlb);
+       else
+               prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
+                       nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
                struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
                unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -242,7 +277,6 @@ static long change_pte_range(struct mmu_gather *tlb,
                        int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
                        struct folio *folio = NULL;
                        struct page *page;
-                       pte_t ptent;
 
                        /* Already in the desired state. */
                        if (prot_numa && pte_protnone(oldpte))
@@ -268,34 +302,17 @@ static long change_pte_range(struct mmu_gather *tlb,
 
                        nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
-                       oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
-                       ptent = pte_modify(oldpte, newprot);
-
-                       if (uffd_wp)
-                               ptent = pte_mkuffd_wp(ptent);
-                       else if (uffd_wp_resolve)
-                               ptent = pte_clear_uffd_wp(ptent);
-
                        /*
-                        * In some writable, shared mappings, we might want
-                        * to catch actual write access -- see
-                        * vma_wants_writenotify().
-                        *
-                        * In all writable, private mappings, we have to
-                        * properly handle COW.
-                        *
-                        * In both cases, we can sometimes still change PTEs
-                        * writable and avoid the write-fault handler, for
-                        * example, if a PTE is already dirty and no other
-                        * COW or special handling is required.
+                        * Optimize for order-0 folios by optimizing out all
+                        * loops.
                         */
-                       if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-                            !pte_write(ptent))
-                               set_write_prot_commit_flush_ptes(vma, folio, page,
-                               addr, pte, oldpte, ptent, nr_ptes, tlb);
-                       else
-                               prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-                                       nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+                       if (nr_ptes == 1) {
+                               change_present_ptes(tlb, vma, addr, newprot,
+                                                   cp_flags, folio, page, pte, 1);
+                       } else {
+                               change_present_ptes(tlb, vma, addr, newprot,
+                                                   cp_flags, folio, page, pte, nr_ptes);
+                       }
                        pages += nr_ptes;
                } else if (pte_none(oldpte)) {
                        /*
-- 
2.53.0


-- 
Cheers,

David

