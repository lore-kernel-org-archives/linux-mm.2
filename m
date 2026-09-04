Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6838EC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4995A6B0088; Thu,  3 Sep 2026 20:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AE26B008A; Thu,  3 Sep 2026 20:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360A06B008C; Thu,  3 Sep 2026 20:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2756B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:22:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B115A4524
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:22:52 +0000 (UTC)
X-FDA: 85174179384.23.0FF2882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BFD511C0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:22:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gicqvsBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788481370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2BAzD5wHFMDI0Tdchm9F35oeS9pHKExb3hvTSPu/hc=;
	b=js+FEvpcB+7M0S4+aFeVCZgyAwQCWYVoo2tT1qriL2ZArJr6X9XPTWq5mMHxwRz/1aILA9
	vfcuxjfrQT7lA3xbTSvQQOZKIX2RyuaiXkQnAbh8qs52sGUHYQuUtePzJAGMZYV+pgtg3e
	4VL0JJwPVY6fUx4tdzn4o01Sp5B1Dgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788481370;
	b=XQmvm+2cU69gWd8zTLn/qE0HTVvWdKn0VCNczUAOVSrV2PjGecKxDyFSFP7Ki02nqAUt34
	wFBQoJwz2JBvo5SkBZ+ypWQxgd9Z+N+GlT4cItJiQcy4MaNghH5k6ngnQTBbTFUURS6D5j
	IcACOEa605MzjoGVe9jcXQyJQ9iJYcY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gicqvsBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 967D1402BD;
	Fri,  4 Sep 2026 00:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B7B1F000E9;
	Fri,  4 Sep 2026 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481369;
	bh=y2BAzD5wHFMDI0Tdchm9F35oeS9pHKExb3hvTSPu/hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gicqvsBymTvjdLcjuS1ruinp8U4tujPXFLCOwmT4AVkN1uVesOw6xKE3DeWiorxrY
	 VZ8U9LWPIvHU6ZIPH5I9drRjGboN+okakuA3rcJks41cdgbB8uCoTjIDf7zkNzPNxR
	 WgaMG41cZAraxhybtzI4zcT8J7B6VqrpJ3zhJVWFbSKe5e4zoHfiXrKJdkR1lLVXxa
	 LIyK4NnyzV0Rx9+M7Oh3Y5pxd3LTB2OcnJdYZfZQ2Ttg8FD/mm7X6NTb8Gi8XhBN51
	 X1s7SCEMnxqG7XoSMl0bMJCtZYYjQ0/ESwVVmNcCJJ98QIfyTEPJAPDyolmquxhBlg
	 EZ6avSmxjLR2A==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in zap_vma_range_batched()
Date: Thu,  3 Sep 2026 17:22:35 -0700
Message-ID: <20260904002237.114959-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904000028.149656-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFD511C0006
X-Stat-Signature: kspseii5t97f47kj79a4xdk5t8nf6ssu
X-Rspam-User: 
X-HE-Tag: 1788481370-302443
X-HE-Meta: U2FsdGVkX18uJt2hv+yDZrXw68BGkVH1/fQSBZcNjl0Takj0X4iJKIky45tnVyjRJt0Oi3+iXIlO/DuDLSl8MPPmjeBzn5kM6fcgUFLAHDbHCHjdwjpF9DrfDf5zmQweMlV8stpFBI72i2eeYY5sKAWD8DAcBA22SlrwqBwFKWfJlRMOd9qX+MMG2nMQfjPeXsBhAEYD63jWi9rdQbvGBcsCXDKt3E+gFxw/JjA96ordBltQy0qcvB34S6i9ohghVl8Y9J9z95B4qR+PWjDG00r7GumPCNltW3s3sdNBpO0ABlD89ei1zO/ro7jekIakvrlEmeWSFSLv8g7ItFbquHKahIvXdG5pvDUP5bhJ6FSAUnuoveKNnJVvjcRpYzhvjFwSTwHYtHfMBv+sDKUyDQIiUX9ABnNtU3OXswjXEWPinPhLIiRzQON1vdJ5NR0hulS3765aT+IRsvmKs+qzkco0B61e/62FAAd2y9SEXrgC4eUlzJJxh3zRrb4pejvWYMeYlPIuIH2ikaedRu/GG1vtB1s45GJY7xF3xk/0+iaDMDay2UGEIzWHfaT7yY0seb1MzmBbCYr3nJaNcTmNaF1L6hfDSm5/AKMctR5KTwE6IsfP676cZgp6tSR4qjfYLI72lP6l+eE+ddsz0XxJ0ubYq3DOSCHSwta4n3PBLWnV97h1kWzNm/K3QVBQwMb/yJmpTA69nmAUOa1oYiSqfjx3HaedqaVSaMJHCPsDVQJApXTR49Sn39+o0j1eiaSFODwPSAVuoKJETfRZeCJAyohZNUhJpVSSQr0fGAkx8k7U+ri6+poteakej1Ku7xrpeQz5kZX2snROGEk1s1RUO14j9ND7FiIq+izcHrbWS0+dgebHPPLG/3MMZs3WPJtPP28EAL/p4aeXjYJrQCPzLqSuzCnti/SOn3FGT7ns/sGfWqtelvYufaWtU7U9Iw4BwxG3Yf4gBoX3CMLpd5D
 ZIbNAfEa
 87svlWmEyB6Z+XdtxAtzEDNB2sXvyllUx4pA01VciUsVHrfU7r7jSUeQnJ06ZQK+yPvSElkLzNIwlelBKBbtl2s/V10pxcS/bLNjEJW7GI3iFtjbjW4CbmGWL/MqArg2Lrd9GSZ/P1GQIz/XDRS/U+neNqAaia5Jky89aj8xlj7VqhzpbQVXEI7VgqQ+r0STDFlFf985estLoTPCC4KCppzkUHP1ogyPL8SCpl9GR5TIGsGpM75NT0MeVd1YjDdFQiGCLJAcX6SIKbliAZs4MH/gaGPwUnAdr3+ft9hbuP7RlP6MDMH9PSpbcJ0P2lH7xASI39rOW14VflH8eSLsCtOcPu8KwecW4u2hebh7hHfguMsKZJps478StdMeuNovgiCHT8sJ2Pcs1rhJDWxHgaAoDU3AnEUK6ei7t0bjMCAJFaA/sU02+cgVSW82g3vtysLklZ5PfYeFIYAUR3tcaF8YBkdtIjs2dz5NEzmhuW4d4jdc3+Ynth9PqBbDSzIaFt4R6MKHuWZPHphyWsh3naOf6G23DHNLY+B3F9BT1qp47sa0FWcxfmVOg2A/y+xUaxSxX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:

> Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
> final unmap") added zap_details parameter to hugetlb_zap_begin().  But
> the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
> As a result, build fails as below.  Fix it.
> 
>   CC      mm/memory.o
> .../mm/memory.c: In function ‘zap_vma_range_batched’:
> .../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
>  2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
>       |         ^~~~~~~~~~~~~~~~~
> In file included from .../mm/memory.c:48:
> .../include/linux/hugetlb.h:253:20: note: declared here
>   253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
>       |                    ^~~~~~~~~~~~~~~~~
> 
> /* TODO: move below to commentary */
> 
> I didn't read the broken commit in depth.  This fix is only
> build-tested.  I wanted to report the issue with this as a temporal fix,
> but the broken commit doesn't have Link: tag.  So directly posting this
> temporal and not very well verified fix first.
> 
> Fixes: Fixes: f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during final unmap")
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index fcf893f4b55e2..151a1bf512e00 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2305,7 +2305,7 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
>  
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>  				address, end);
> -	hugetlb_zap_begin(vma, &range.start, &range.end);
> +	hugetlb_zap_begin(vma, &range.start, &range.end, details);
>  	update_hiwater_rss(vma->vm_mm);
>  	mmu_notifier_invalidate_range_start(&range);
>  	/*

And this is not enough for some configs.

# /home/lkhack/linux/mm/memory.c: In function 'unmap_vmas':
# /home/lkhack/linux/mm/memory.c:2272:3: error: too many arguments to function 'hugetlb_zap_begin'
#  2272 |   hugetlb_zap_begin(vma, &start, &end, &details);
#       |   ^~~~~~~~~~~~~~~~~
# In file included from /home/lkhack/linux/mm/memory.c:48:
# /home/lkhack/linux/include/linux/hugetlb.h:322:20: note: declared here
#   322 | static inline void hugetlb_zap_begin(

Below change fixes the build on the config, too.

'''
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 63c85f2540c9f..0cdccafb83983 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -321,7 +321,8 @@ static inline void adjust_range_if_pmd_sharing_possible(

 static inline void hugetlb_zap_begin(
                                struct vm_area_struct *vma,
-                               unsigned long *start, unsigned long *end)
+                               unsigned long *start, unsigned long *end,
+                               struct zap_details *details)
 {
 }

'''

So more complete version of the patch would look like below.  Forgive me
posting v2 as a reply for this case.  I think this doesn't deserve a new
thread.


Thanks,
SJ

=== >8 ===
From hackermail Thu Jan  1 00:00:00 1970
From: SJ Park <sj@kernel.org>
Date: Thu, 3 Sep 2026 16:52:06 -0700
Subject: [PATCH v2] mm/memory: fix hugetlb_zap_begin() call in zap_vma_range_batched()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
final unmap") added zap_details parameter to hugetlb_zap_begin().  But
the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
As a result, build fails as below.

  CC      mm/memory.o
.../mm/memory.c: In function ‘zap_vma_range_batched’:
.../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
 2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
      |         ^~~~~~~~~~~~~~~~~
In file included from .../mm/memory.c:48:
.../include/linux/hugetlb.h:253:20: note: declared here
  253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
      |                    ^~~~~~~~~~~~~~~~~

It also fails on !CONFIG_HUGETLB_PAGE config.

    .../mm/memory.c: In function 'unmap_vmas':
    .../mm/memory.c:2272:3: error: too many arguments to function 'hugetlb_zap_begin'
     2272 |   hugetlb_zap_begin(vma, &start, &end, &details);
          |   ^~~~~~~~~~~~~~~~~
    In file included from .../mm/memory.c:48:
    .../include/linux/hugetlb.h:322:20: note: declared here
     322 | static inline void hugetlb_zap_begin(

Fixes: Fixes: f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during final unmap")
Signed-off-by: SJ Park <sj@kernel.org>
---
I didn't read the broken commit in depth.  This fix is only
build-tested.  I wanted to report the issue with this as a temporal fix,
but the broken commit doesn't have Link: tag.  So directly posting this
temporal and not very well verified fix first.

Changes from v1
- v1: https://lore.kernel.org/20260904000028.149656-1-sj@kernel.org
- Fix !CONFIG_HUGETLB_PAGE build.

 include/linux/hugetlb.h | 3 ++-
 mm/memory.c             | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 63c85f2540c9f..0cdccafb83983 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -321,7 +321,8 @@ static inline void adjust_range_if_pmd_sharing_possible(
 
 static inline void hugetlb_zap_begin(
 				struct vm_area_struct *vma,
-				unsigned long *start, unsigned long *end)
+				unsigned long *start, unsigned long *end,
+				struct zap_details *details)
 {
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index fcf893f4b55e2..151a1bf512e00 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2305,7 +2305,7 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
-	hugetlb_zap_begin(vma, &range.start, &range.end);
+	hugetlb_zap_begin(vma, &range.start, &range.end, details);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
 	/*

base-commit: 2d1388907095f676b59fe6dd22f244abc08408cf
-- 
2.47.3

