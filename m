Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45C3606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GH3/5Rdq
Received: by kanga.kvack.org (Postfix)
	id D9DFF6B00EF; Tue,  3 Nov 2026 22:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B096B05B1; Tue,  3 Nov 2026 22:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16246B05B2; Tue,  3 Nov 2026 22:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95DFE6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:28:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95ECEC0644
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:28:08 +0000 (UTC)
X-FDA: 85396003056.22.1D849AA
Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 48DC91C0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:28:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GH3/5Rdq";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793762886;
	b=lp0Okb9xj5xbMaR9mVhHNao6nQ3mGbunPhK0+at1rcegRJkWgSOrc4VQVLorqcqTASPwuZ
	DOVrFJyhzxmzHtPJBJ2GEGXvateEHa0jbNS44Q3i+hTe3/ehJAG6WcMs8bumIeWjLVIcFZ
	lB9m5D5Xf9VASLf+NSRASkpaYkZOqq4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GH3/5Rdq";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793762886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j371QPGtCFPV+Osbl1SGKaUOxa6Nr78TllBqJLarcOY=;
	b=rCpji1LuiqQepZbyeGKBlrWth5spuUZdc7P/PktEyp+J7lvdJdT+g/P9C9inRYM1THMnc+
	PLPekCXuPBKWXd+5RREXlargViQzezmbxOilgUivOP2pTVajDeYA+XDhZOKL7DMWxgZmT0
	meS/ZzWgmRVqZO0dZAqeEYS7aPq1EN8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GqvAQHYdWiYyT2aaCpv6yjKE3M/YhdWdm4Wb8nulwQ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793762885; v=1; x=1794367685;
 b=GH3/5Rdqw2twps5UKA5/nQBLEGOlXJwRbpFzL2sc0jprsLwog/p2LnuitbVMmOcF+CJxXoCS
 21SciKaEuno2FSI6O/BUzvSIU1T5RD4CPedSDelDDyxqA3taVK3prRVx3tI+E+s+T67bfxLJCnq
 61S11zOHNu1fsSMZCplZFCFQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aafce94ffd4739ab;
	Wed, 04 Nov 2026 03:28:04 +0000
X-Mizu-Trace-ID: aafce94ffd4739ab
X-Migadu-Flow: FLOW_OUT
Message-ID: <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
Date: Wed, 4 Nov 2026 11:27:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org, azpijr@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
 <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 17g8ff4a4zymd6hsaq8g5za9i858gr64
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48DC91C0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793762886-646509
X-HE-Meta: U2FsdGVkX1+jLI1EM7ggjKceyBnvQSnIwFI8//b/a93zMbcMJ2TcEAk+EwP9EWOfU+yF1joWax5n21M+5z1t41wE7jr+9XUmmjL5Oma8mW5tq2gY/pwVJfGqh0tihJS09XUdw/jbG5Ckawcvr8jp26SWtBzTNSEkXtBeAfEHL5YP6rk9ooARGbrjcQWhoqGNfw+zASzR7T2o25AyvdFzKlftP0WTj5NYM3MPG7RD+jUvOEbSr5yQouJMnL7W725XvEfRQ1oc6IyVgc4MUkxepq5tgB2GFc6wKntyThwOWGg7dHNXxCEGqXj4GeaQmJ45+4K17MDCZ0WZWcfi0bLrXIV4cIE7WC5+zDgphD5d0ZxaMAh0/doMSaTG1d94dqxqy6WtXnUHgrITgXEJwYIZB2021wEPSq22ONL7ApGRt/QRfGuU2FLNvrn0LP6m2TN+INkBkNe9Di0slvCbh3nLUjo/ymt40YzaLL68NUdY2c7lhEMaq7T9Ub30GNTon2ihpiCtRTyTyZEU7DjMhKanvRHumvNnV8EbfcCyPCLuZhL33l7oxo5Qzaz/EGLHoOZ5qXFZ11dsTC/HS4A+6XDnXcS22QJwLdfLlKXtqD9pfY4sRN1sud3rDB53XmiuaeSDMpde9onKetAeAW5ak4Eu/j/NYxFDef8kxzR/qf88xfVBgD35wiF6TWEIKHR/fAKmdvaqCypBkXFPI7V7vLIZQqmoe4sHuvk56OkXtHqE2mS62XUfmpPHRmnwmYKY2QJLaFPWppvP99uuX4h8aQtOumBEJytEoq7aJCNdJXkqEx3IBl5Wy5FEYukxOZSLf2QTpvtZk7XScG/O9m3cQRsJ7mV9CQzncJHAeFeKdmOkSjHK8p59KVgFyl+9aQD7/hb6xSpjmbQt1YCo+OQruABK/B+ctnIbM1TtG3AETZo7jT0IW5Fqjkx0XgITQQ7EK7NiVUSonatSYovXJVzw4kq
 tTd524IM
 jhpIMyhgx3qeTP4jJOV+hmdBOr9cZVdBiQ6D0hR/7UoLzvS/7Y4nmY5gLN+XlRWGOzmyDcwZxG7W32dBwxxPvNwj7CQrvVp40N5BjLvAxmqM42vlGEAGjwuYurx1GO55WQQtc3ECzh1MA7oOz2nkObVh4Yby7jUbXSCTgVVp5QOM5Lx73IJEdDyx7PTjtPqWVN6X4y6VCd2ZTv546uBTDm9MD1llgLn3+5cD9+5EOLUasVU77tt9CaDzyKhkECMUpik82XLAYXXpAZBKxMlPSzd/Mgr7dRpnNjvEN/BvHpE9lsNbwlTgFWi/rM5fKvr42PfqiX8MP4y5er6DsGv3+LpF04NsiQzcsFkCZEzmD5HAxJ4/7Mbf2Cp96cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

On 11/3/26 6:56 PM, Muchun Song wrote:
> 
> 
>> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> With gigantic overcommit enabled, a fault during long-term pinning
>> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
>>
>> The folio must then be migrated before it can be pinned. However,
>> fresh gigantic migration targets are not supported, so pinning fails
>> when the HugeTLB pool has no suitable target, even if the original
>> fault could have allocated pinnable memory outside CMA.
>>
>> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
>> try the non-CMA fallback, or fail when allocation is restricted to CMA.
> 
> Wait... I think my Acked-by got ahead of me here. :)
> 
> There seems to be a rather odd distinction that GUP is missing.
> 
> The usual reason long-term GUP must migrate a page out of a
> MIGRATE_CMA pageblock is that the page was only borrowed from CMA by the
> normal page allocator.  The corresponding CMA bitmap range is still
> available, so a future CMA allocation relies on being able to migrate
> that page away.  A long-term pin would prevent that.
> 
> However, a HugeTLB folio returned by
> hugetlb_cma_alloc_frozen_folio() is different.  It is the actual CMA
> allocation, not merely a movable page that happens to reside in a
> MIGRATE_CMA pageblock.  Its range has already been marked allocated in
> the hugetlb CMA bitmap.
> 
> Therefore, CMA cannot allocate that range again until the HugeTLB folio
> is freed anyway.  Long-term pinning the folio does not seem to make the
> CMA area any less available than keeping the HugeTLB folio mapped for
> the same amount of time.
> 
> folio_is_longterm_pinnable() currently only sees MIGRATE_CMA and does
> not distinguish these two cases.  In that light, rejecting
> PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() looks like working
> around an overly broad GUP classification.  It also means that
> hugetlb_cma_only users will fail the fault, while other users may consume
> a gigantic contiguous range outside the dedicated hugetlb CMA area even
> when that area has free space.
> 
> Would it make more sense to fix the long-term GUP check instead, so that
> an explicitly CMA-allocated HugeTLB folio is considered pinnable, while
> ordinary pages merely borrowed from MIGRATE_CMA pageblocks remain unpinnable?

Make sense!

I'll replace this patch with an exception for HPG_cma folios in the
MIGRATE_CMA check. This also lets the HugeTLB allocator select preallocated
CMA folios during long-term pinning. MIGRATE_ISOLATE and ZONE_MOVABLE
remain restricted.

Fresh CMA allocations under PF_MEMALLOC_PIN also need to skip ranges
in ZONE_MOVABLE. Returning -EBUSY here lets CMA try its remaining ranges.

The incremental diff against this patch is below.

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..7fd1b6e65b58 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -21,11 +21,13 @@
  #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)

  struct cma;
+struct folio;

  extern unsigned long totalcma_pages;
  extern phys_addr_t cma_get_base(const struct cma *cma);
  extern unsigned long cma_get_size(const struct cma *cma);
  extern const char *cma_get_name(const struct cma *cma);
+bool cma_folio_is_pinnable(struct folio *folio);

  extern int __init cma_declare_contiguous_nid(phys_addr_t base,
  			phys_addr_t size, phys_addr_t limit,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index cb993a1d0728..d15810be7d96 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3,6 +3,7 @@
  #define _LINUX_MM_H

  #include <linux/args.h>
+#include <linux/cma.h>
  #include <linux/errno.h>
  #include <linux/mmdebug.h>
  #include <linux/gfp.h>
@@ -2975,14 +2976,16 @@ static inline bool is_zero_folio(const struct 
folio *folio)
  	return is_zero_page(&folio->page);
  }

-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
+/* Borrowed CMA pages and ZONE_MOVABLE folios cannot be pinned long 
term. */
  #ifdef CONFIG_MIGRATION
  static inline bool folio_is_longterm_pinnable(struct folio *folio)
  {
  #ifdef CONFIG_CMA
  	int mt = folio_migratetype(folio);

-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+	if (mt == MIGRATE_ISOLATE)
+		return false;
+	if (mt == MIGRATE_CMA && !cma_folio_is_pinnable(folio))
  		return false;
  #endif
  	/* The zero page can be "pinned" but gets special handling. */
diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..c2814f54f86a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -27,6 +27,7 @@
  #include <linux/log2.h>
  #include <linux/cma.h>
  #include <linux/highmem.h>
+#include <linux/hugetlb.h>
  #include <linux/io.h>
  #include <linux/kmemleak.h>
  #include <trace/events/cma.h>
@@ -55,6 +56,12 @@ const char *cma_get_name(const struct cma *cma)
  }
  EXPORT_SYMBOL_GPL(cma_get_name);

+bool cma_folio_is_pinnable(struct folio *folio)
+{
+	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
+	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
+}
+
  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
  					     unsigned int align_order)
  {
@@ -792,6 +799,11 @@ static int cma_range_alloc(struct cma *cma, struct 
cma_memrange *cmr,
  	int ret = -EBUSY;
  	struct page *page = NULL;

+	/* Each range lies within one zone; try other ranges if needed. */
+	if ((current->flags & PF_MEMALLOC_PIN) &&
+	    is_zone_movable_page(pfn_to_page(cmr->base_pfn)))
+		return -EBUSY;
+
  	mask = cma_bitmap_aligned_mask(cma, align);
  	offset = cma_bitmap_aligned_offset(cma, cmr, align);
  	bitmap_maxno = cma_bitmap_maxno(cma, cmr);
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index dde1c866406f..95fd2d190f0d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -62,9 +62,6 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
order, gfp_t gfp_mask,
  	if (!hugetlb_cma_size)
  		return NULL;

-	if (current->flags & PF_MEMALLOC_PIN)
-		return NULL;
-
  retry_cpuset:
  	if (!nodemask) {
  		cpuset_mems_cookie = read_mems_allowed_begin();

Thanks,
Qi

> 
> Thanks,
> Muchun
> 
>>
>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> mm/hugetlb_cma.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index 95fd2d190f0d2..dde1c866406fb 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -62,6 +62,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>> 	if (!hugetlb_cma_size)
>> 		return NULL;
>>
>> +	if (current->flags & PF_MEMALLOC_PIN)
>> +		return NULL;
>> +
>> retry_cpuset:
>> 	if (!nodemask) {
>> 		cpuset_mems_cookie = read_mems_allowed_begin();
>> -- 
>> 2.54.0
>>
> 


