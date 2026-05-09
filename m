Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6ABCCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 03:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91B66B02F2; Fri,  8 May 2026 23:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A689C6B02F3; Fri,  8 May 2026 23:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5A26B02F4; Fri,  8 May 2026 23:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA246B02F2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:22:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0924416049A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:22:18 +0000 (UTC)
X-FDA: 84746433156.16.92CBF65
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05663100002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:22:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j4p+fPm1;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778296936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as0dpPJQQ5oemmKaoTTdoATFZeTUPthXq79B4CZ58js=;
	b=KmQ3Z3UhcOr0a4/H+ZBlImR9gI9P+Z3zMdd+vLHwvTpLbla3iqIwD3xCPwTsEA2vyL6bcy
	FXknar6GmK6A6/8pcibKU0tKIDTF8jW7Qb2rANalynWetXK+Ui5AeNM2RwK2so8ICPOfOj
	SDiX5j6ZM/5DJDFHZ3oRNY2bzfj7HaY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j4p+fPm1;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778296936; a=rsa-sha256;
	cv=none;
	b=ECdDaxbL3L1Mmuo3znpwf9CAOAmfvu/4v4kUJrSDua6zXqwPUjHMtxyiybh3tux0JgnLaA
	yc+Kwy95ZL512JnLteMC8yGqy9KEn5y/BrUd1Itf80VxcRuCr+kI266a6/OSfLot32dHoo
	BrNsXBxblcV5qzbwy7y9eouZu6zK/aY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778296933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=as0dpPJQQ5oemmKaoTTdoATFZeTUPthXq79B4CZ58js=;
	b=j4p+fPm1gorWRtfE+RjS8Wv5Dv6UTceWxNhHJPw0BFaeO992R9+te/rFVvo5aBsCf++Cre
	p6bLCtuO6Q9No6raywS8SCwHUC47ho0SSQ9Vnzmzofis3x3vPcCc6XJuDI5AVFyKJ/pXHn
	hAhrtLYCNJ1n+dP08rwYCyomVWjYtpQ=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	lance.yang@linux.dev,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Sat,  9 May 2026 11:21:57 +0800
Message-Id: <20260509032157.61333-1-lance.yang@linux.dev>
In-Reply-To: <20260508170509.640851-1-npache@redhat.com>
References: <20260508170509.640851-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05663100002
X-Stat-Signature: ob5bgdmhz6wm5qjqt9i3zsp9nsy9j5md
X-HE-Tag: 1778296935-377143
X-HE-Meta: U2FsdGVkX18hIbPIhs7uRr3NrPI1ww5xogfzHT3iMQ6tHiHcNI1lYXd81J4fqEFjdwid6/IRDesujg9LGmibVvz8Hyh4jZDttBTyResamZbNjgi3H/3sVRLBO5Gix9042g+OcPh+AyI8EmYVZhQ1Ly1tSH6bUEeRVRfiMKAnQfakJ2rM3rQcqukJVj6lDfQar9VJV1HnSJ33LnOep2oV14sD2BNesHht+uE0stg1sux1f9kBKqd/NQTYtKUm/E+HHqc3IpmlDYkuiq7nxTYaI0Lb9bcKGCjnwoZq2mXBXGLnFgUkYs6tUbeDHz8utAmmZaFIpDo8E+G+5vFMr+HsAuzYWQncNNv8FswAfBxbIje45GxY6nM/30/3KzCdfjnQlJvHAqi5EH/sFIvkdp9BweibQbKmL8vbipLuYM3QpG0W5hidm4gjxevjCy9PxTndIeSAXoedjW0x3KvFbu7U3iC+mcDAH7up4K/pOY/pwnC7saGogJikYf/t/9uPiiNmUvOImuDR8wGpCP4+0MggKiM4bR2qpxayIzjtEj43NQFt/LPHwWq237ULJsv3Ih5YEnR5D3cqjsvKUF9NPLDPM8A5l0RL8LZDHyHWX7xnhfnGcG+v2VlKZLM14diI83AIuqJGUrcxII2czrd1Hy/L+if+FJeo34ccpSNFbCp3C1U8Cif1QEIV0kkKB7IlsztdJbrmKQWMeVXEDd113enTPfOqg9b/ZmWDa5+z/hcpoThovvuP5N1UWuAM15HVuaKN0thTl8X2Gd9c2TT0+zldtYaeyYt7YIM8PpZG0IUJGEbriRdCiJsjorIUAga2FrdQ7+lzya2tgBwcjYIG0+JgxOuap5SRV2NOvNEZzT9SVz8/3S9B7xslIkQIFOyJ95lkn7+YahKN2Nk9+3sGak9QIxePknLz0xOiVoDxZjYzp3g/h+/hCAV17nLBKk5UMRFE9tn4a39Duf3ecR0C3ET
 RxXsqhBy
 yDAXAmY+XNRhiEjZEDylJhvvKbOFheW6xcwMZQASHu+EbDAj6hiqmKD7xYgpPWylD/ydjW6wRxMll3JAZd0CEUa6qjt0WCd95kzvjeXa94b8ul5fxSDm3pgl0hqcwUOaZVq25wEMNuRW4IUHRx4wLRiq7/nxPbz7VIhF84Khoio5J4wcN6Og/BleW798dZa9ZFAclLzT/zclmJM8nfyG3DbhUt1TtXgibDLCKrw417cMZin8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 11:05:09AM -0600, Nico Pache wrote:
>Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>when splitting isolated thp"), splitting an anonymous THP remaps all
>zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>This flag is set unconditionally for every anonymous folio split,
>including splits triggered by KSM.
>
>When KSM is enabled with THP=always, this causes two regressions:
>
>1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>   split_huge_page(). The split remaps all 512 zero-filled subpages to
>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
>   intended to process a single 4KB page. This bypasses KSM's
>   pages_to_scan rate limiting, causing ~1GB to be freed almost
>   instantly.
>
>2. use_zero_pages=0: The same split side-effect occurs through the
>   stable/unstable tree merge paths. Each pages_to_scan iteration
>   triggers an expensive split_huge_page() that silently frees 2MB,
>   while the scanner wastes cycles on tree searches for zero-filled
>   pages that were already freed as a side-effect.
>
>Fix this by restricting TTU_USE_SHARED_ZEROPAGE to only the deferred
>split shrinker path (deferred_split_scan), which is the only caller that
>intentionally splits underused THPs to reclaim zero-filled subpages.
>Introduce folio_split_underused() as a dedicated entry point that
>passes is_underused_thp=true through __folio_split(), and use it from
>deferred_split_scan(). All other split callers (KSM, compaction, etc.)
>no longer get the zero-page remapping side-effect.
>
>Reviewers notes: this patch is one of two potential approaches. This patch
>turns off the zero-page freeing that has been done since the noted commit,
>in all the other callers, only leaving the underused shrinker to do such
>behavior. We can also take the opposite approach of with something like
>split_huge_page_no_zeropage() and call this within KSM.
>
>Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> include/linux/huge_mm.h |  2 +-
> mm/huge_memory.c        | 17 ++++++++++++-----
> 2 files changed, 13 insertions(+), 6 deletions(-)
>
>diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>index 2949e5acff35..4ae1b52d7411 100644
>--- a/include/linux/huge_mm.h
>+++ b/include/linux/huge_mm.h
>@@ -378,7 +378,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
> 			   enum split_type split_type);
> int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
> 		struct list_head *list);
>-
>+int folio_split_underused(struct folio *folio);
> static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> 		unsigned int new_order)
> {
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 970e077019b7..91f7fad72c8a 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4045,7 +4045,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  */
> static int __folio_split(struct folio *folio, unsigned int new_order,
> 		struct page *split_at, struct page *lock_at,
>-		struct list_head *list, enum split_type split_type)
>+		struct list_head *list, enum split_type split_type,
>+		bool is_underused_thp)
> {
> 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> 	struct folio *end_folio = folio_next(folio);
>@@ -4174,7 +4175,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	if (nr_shmem_dropped)
> 		shmem_uncharge(mapping->host, nr_shmem_dropped);
> 
>-	if (!ret && is_anon && !folio_is_device_private(folio))
>+	if (!ret && is_anon && !folio_is_device_private(folio) && is_underused_thp)
> 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
> 
> 	remap_page(folio, 1 << old_order, ttu_flags);
>@@ -4309,7 +4310,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
> 	struct folio *folio = page_folio(page);
> 
> 	return __folio_split(folio, new_order, &folio->page, page, list,
>-			     SPLIT_TYPE_UNIFORM);
>+			     SPLIT_TYPE_UNIFORM, false);
> }
> 
> /**
>@@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int new_order,
> 		struct page *split_at, struct list_head *list)
> {
> 	return __folio_split(folio, new_order, split_at, &folio->page, list,
>-			     SPLIT_TYPE_NON_UNIFORM);
>+			     SPLIT_TYPE_NON_UNIFORM, false);
>+}
>+
>+int folio_split_underused(struct folio *folio)
>+{
>+	return __folio_split(folio, 0, &folio->page, &folio->page,
>+			     NULL, SPLIT_TYPE_NON_UNIFORM, true);

IIUC, it should be SPLIT_TYPE_UNIFORM, not SPLIT_TYPE_NON_UNIFORM ...

deferred_split_scan() used split_folio(), so for the underused case it
split the whole THP uniformly down to order-0 pages. The shared zeropage
remapping happens later, via remove_migration_ptes(), after the split.

With SPLIT_TYPE_NON_UNIFORM and split_at == &folio->page, most of an
order-9 THP can stays as larger folios.

Then try_to_map_unused_to_zeropage() rejects those folios:

	if (PageCompound(page) || PageHWPoison(page))
		return false;

So the underused shrinker would no longer remap/free many zero-filled
subpages ...

> }
> 
> /**
>@@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> 		}
> 		if (!folio_trylock(folio))
> 			goto requeue;
>-		if (!split_folio(folio)) {
>+		if (!folio_split_underused(folio)) {
> 			did_split = true;
> 			if (underused)
> 				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
>-- 
>2.54.0
>
>

