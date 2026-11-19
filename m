Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C557606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n19oJKMP
Received: by kanga.kvack.org (Postfix)
	id 348776B05D7; Thu, 19 Nov 2026 18:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9476B0619; Thu, 19 Nov 2026 18:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8326B05F7; Thu, 19 Nov 2026 18:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB4016B06F8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:48:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C04D980CFA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:48:32 +0000 (UTC)
X-FDA: 85453510464.19.A976B69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id 182FB140005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:48:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n19oJKMP;
	spf=pass (imf09.hostedemail.com: domain of 3zYr_agoKCEApknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3zYr_agoKCEApknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795132111;
	b=PmfJROwRYycu7ZH/VHxextbCRNxaxUn/zkxKDZrnqEcqviRibuJx0C0gNFhaA9yFdZwd76
	FtAllcDYOYuIrTvw+WPhPfWGnTT7iXKvL8VNvu+fgUJY96+enpOceTru213t1mrQifZrz9
	JBnvneOOiNpzCvWRcvscDdLsMP0pgT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795132111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YUybhKhz7iS/HEeHDZ9aby2NzinwtFQFRqsE5uPznD0=;
	b=pyPAmjKHpOP6YKpDITjQrHP17tXEP8pSo6nTEmNWd/ykuZRbpCpSK8XHCbeI5F/eGQFtZU
	MBP/En4SvrSZIUU/nA+jWx+1ZJIG6737qMjeF2WXK98cy/3ZydBB7gseH0MBBtVdlFKpr2
	nRt+j/ZIW+sEn3P8QffeUB9FbNbX6WQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n19oJKMP;
	spf=pass (imf09.hostedemail.com: domain of 3zYr_agoKCEApknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3zYr_agoKCEApknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1a5005fd0f8so700764c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795132110; x=1795736910; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YUybhKhz7iS/HEeHDZ9aby2NzinwtFQFRqsE5uPznD0=;
        b=n19oJKMPrkOhrQUw8i/zReWnjqi/2j0wLiWofSzvDDVMqJlr1hoOqxhAR8nop07qcB
         WATZB35wrY1f0UHpu/nAYrl2Ixj8NUTCi+xm0noOtYQg77BxgotCKXPCpFHE0pBEhwUM
         lPJUoZzjjgOZBG33dQEG3t/Tp4CjRsEwwpwfHRNQsZL0k0vfvWnfp78KMDOa08dEQyz1
         YLhp/8IvFJ88BojMAJ+kheOb0wxws/2y18V3XUFkuOhNQ1aZkQs1YYPnHGLsihzVRJgv
         H94TcWqSNXcb+MPDHUWnXCZR4lA8Z9UpEAjRwjykSKmjU3/C5aBYIUxPjsh2MGJJ6Quy
         gTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795132110; x=1795736910;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YUybhKhz7iS/HEeHDZ9aby2NzinwtFQFRqsE5uPznD0=;
        b=vqm8UuphKqXj23s0dwNnXWcAW6yG9HudNIJF1w1S3eN/AY2usTMZypadDgQGif1K0Y
         Adetw14FtiKCJcAssoMfEr4IeRaFeOfVB6a0qgBv7NSkksIzypvvCAEl5qiRDBso9S2o
         3HrlgxRkOizc+sINY7iPZ5G7ijTt66gyoSnHN9lAqibNhaKFb1P1b9Gfe0zv1aqyJvE8
         NSmPW16RhRHdHzsOHjsbN9qFknPIL8IgnM+iMhgxS73LBcYEFznS6fu1he2j2qXMX2+g
         w93QIaENZW0FPqxahOlfOMM6GfoE571rq02Dq/d8/DHjOldMKpr5MyWlsjgdI6tZU4nL
         kvhw==
X-Forwarded-Encrypted: i=1; AL+hErEjSZC71MUWLFwQcnpsHp6k8eksfj/8zVAgQmUSEGiURRhplx7uwIsRNjayb0h/3qhuDDycsMOoNw==@kvack.org
X-Gm-Message-State: APuU4Z+B+2TGs/9PBuVRcbcqthOWg/0Fr4r2830nr6L8gfcrahvUuZXy
	lAAk4d8he4v4XoyVKmdH9hPisKnk5ndAV2dACmECqnaMAvvHymIAyoUJC7F4xKskL4Z0U5PixiS
	Em6JCVm2bFg3Ze1uGpZV8fQ==
X-Received: from dlbsj7.prod.google.com ([2002:a05:7022:f907:b0:1ad:2ffe:151b])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4354:b0:17a:e684:b497 with SMTP id a92af1059eb24-1b55682369bmr1123328c88.5.1795132109309;
 Thu, 19 Nov 2026 15:48:29 -0800 (PST)
Date: Thu, 19 Nov 2026 15:48:04 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261119234804.1740734-1-nilayvaish@google.com>
Subject: [PATCH v2] mm/page_owner: fix double decrement of stack count on unpoison
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Oscar Salvador <osalvador@kernel.org>
Cc: "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Stat-Signature: 1oo5azkk1r61ze5ko8tosxwaxr3rrwzw
X-Rspamd-Queue-Id: 182FB140005
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795132110-514949
X-HE-Meta: U2FsdGVkX1+KZiQdNVeNx9W5V5u28kSzdbeJvwl3j25S1ytx6R2JcZXyrVlH22CYl5B+S2Cn8UN+aNAOpM+RmbpwOEEtaJMatGU5imEkFOkjSllF5h/fhIDWjJNjK2+AU7aakB0NNKwbwI1pfiY3hoeBKovmBrt69FL/EmUypfTGG2Of2rH9UJZj6pUbu2umnw8CveRGpFLf/r3znQhmz2iPJh5Zk4+e9NY16kt4V261BqzDNyBG5CLyls7jFy58UxpS2G1d3I+wOccUPqJfN+xIG49PBkCbJq9tvZiRlIh7hxKvyA64NA1WeXAZmzurMMpIKPHXkYBiKB2TYSFDkPSukkNNC3HrH/AYoAiinTXUjEqxgHuhbHk4PeJm0uk455NnXeV2lbELGEiI/akDR/CB7rxnOApb+Jdk2TlwToBnVVmVbxPu4zpuLmDj15IjWIzpwjefrne0KIh1hzYwnSM1yswmmFS9ZXU70ncTy+5xmreC3jifnVxs5Tk/60Llw8mseBUTSC73i0Qj8cIUVnzn6V0GxhadGf8mcWHq5XvNaibDE+IoKklSOVwAvIdf9yJ3G0ljgssaZu3x9kjp8gvtk1U6/vOJkV1kraE+XMhFzFsTJ1265P1X1bZGo0H9bxzH5Q2pzl+Lyy7wz7hdQkcPsscHEeLfUKcNHCgVSVUpyTtB5R+oTt1gUlNGbVdAh4klMdTpwP0y+VNi73BQ+rLcr7ldkDAsPVu9S8epxemCoMZpQbXx6pe8axgSUdDhXVcEJa+12327a/d0xaaY5o7a9jYselb91uf/lZoFKqYdI26R3wWJXJfvDSQGw7g1f3BHcnM4XWBirqwZiAqDZRqFPDYNkePI/efEpK3brQJtwN5kiPJvkdJp2CqAJyQK63bYsZVDKF2VQb9tZaEnfR2i+EWiy23C6ZwD1S1C5irGx3y+roUogDWG8gvg7rnwg1SpBT1EVqcAOxVPtET
 vf2L9eur
 Qim9KuD5r0Nz3TUkrRCrCQMKdxbKT8zePj2mtTjvs4uZ98vEubkKrmz9V6fzuI27f9UIOW6qsp9C/NQk8R6xwWdQbA8U3NFYA0LryiAzIaVVVvT/KARCenR22uB3HpqytRl0YCrxZDgZ21CEUg9fEbnAA4mdY+BFs2y3yNadkxja4C3Z29ClQIBlRCdyU2JahUqy2RKELiJLfTYWlsSAZ2eyyXmDP6LEVCXm8y/Vc7NKC/XRwh/2LUFCjxpxLMzbeo0m6su4E0oL11gWqyLPqlnf0ZDjd/08OAuasobpUsMhklO1JcJ1sYyywhytQlqU8pIDse2Y5tMj66d4r3+Z82/Ks238NxQKHWJRmgirvDjSvJbVjRZF3hh/st52B2Oo+hoMgfc/+jFjepZauuf7OraLOtI86qqqsanDixC2327JtgFsdhCrrWdFNPoQBTlE03HAzFGO2kwuG9HoXPRvzElF3+/m2Y262wrxyNRepeioYUzzgS5Kf7uOG9CDPF1HLfDKCllBX9c+pJOajbFNlFjKGaM6F7G2JgwUsWif/MxVM+8d/vPx8hIfhm3xv+p2iAy0LI8ZIlk6/vhlRosYejWHoJ6ivepzybZJjtCHf0amFg8+xXIAz25FHt5rM5QxC7lcr/iji3MqJcKUc6hh+NYrjPJw/s4YOAdm0jt2ybNlnQVWU3zFQtxKb3oLAantHYpnB7LmZWY2Uit5Gx79ummwlitKskc0rbp+Zs+ETo9+MAJj49mUFtPvTsEaMqOdr473jz90dyMMcVyv77cchO0rZ4MBV61AbpQE1zMDBa2QndmtmpPBx/ApHsKlcWZpTDVdgdcK6cPAhMmJJ+qY079Q2N4Gubuy7twOLkD4o1/l+/Z91mgvzCx0tmd1ndZ0Acne+0rEvbw+ktK+eOXG9lVImweIfr0EyTt/wftgVR0vNXSpw+e3jyoIuZlG53RXNh/6HXhU+Dt9PSt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_owner counts, for each allocation stack, how many pages allocated
from that stack are still in use. The count is incremented when a page
is allocated and decremented in __reset_page_owner() when it is freed.

A page that is hwpoisoned while in use and later unpoisoned passes
through free_pages_prepare() twice:

  1. On poisoning, the last reference is dropped. free_pages_prepare()
     calls reset_page_owner() but, because the page is PageHWPoison(),
     keeps it off the free lists.

  2. On unpoisoning, unpoison_memory() drops the poison reference and
     free_pages_prepare() calls reset_page_owner() again, this time
     really freeing the page.

__reset_page_owner() decrements the stack count both times, although
the page was allocated only once. The first call clears
PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.

If this drives the count to zero while the stack is still in use,
stackdepot treats the record as freed and warns on every later
allocation or free that uses the same stack:

  dec_stack_record_count: refcount went to 0 for 92274844 handle
  WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
  Call Trace:
   __set_page_owner+0x110/0x290
   get_page_from_freelist+0x1225/0x1440
   __alloc_frozen_pages_noprof+0x1fc/0x1b00
   __folio_alloc_noprof+0x12/0xa0
   alloc_migration_target+0x81/0x1e0
   migrate_pages_batch+0x1f2/0x14c0
   migrate_pages+0x9c3/0xca0
   soft_offline_page+0x189/0x570

A single soft offline followed by an unpoison is enough to trigger it,
because the migration-target stack that the offlined page is accounted
to usually has very few pages.

Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
was still set, i.e. only the first time the page is freed.

To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch
the first cycle prints the message above and 2200 cycles produce 6597
warnings. With it, the same run is clean and all stack counts return
to their initial values.

Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
v2:
- Expand the comment in __reset_page_owner() to explain the allocated
  check (Oscar)
- Collect Reviewed-by tags from Jose and Oscar

v1: https://lore.kernel.org/linux-mm/20261118212819.403059-1-nilayvaish@google.com/

 mm/page_owner.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 02bb304b53cf..09a3c2958079 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -320,11 +320,13 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	depot_stack_handle_t alloc_handle;
 	struct page_owner *page_owner;
 	u64 free_ts_nsec = local_clock();
+	bool allocated;
 
 	page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
 		return;
 
+	allocated = test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 	page_owner = get_page_owner(page_ext);
 	alloc_handle = page_owner->handle;
 	page_ext_put(page_ext);
@@ -339,8 +341,15 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	__update_page_owner_free_handle(page, handle, order, current->pid,
 					current->tgid, free_ts_nsec);
 
-	if (alloc_handle != early_handle)
+	if (allocated && alloc_handle != early_handle) {
 		/*
+		 * Not every page that gets here is still accounted as
+		 * allocated: a hwpoisoned page that is later unpoisoned is
+		 * freed twice, and the first free already cleared
+		 * PAGE_EXT_OWNER_ALLOCATED and dropped the count. Only
+		 * decrement the allocation stack's count if the page was
+		 * still marked as allocated.
+		 *
 		 * early_handle is being set as a handle for all those
 		 * early allocated pages. See init_pages_in_zone().
 		 * Since their refcount is not being incremented because
@@ -348,6 +357,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
 		 * their refcount either.
 		 */
 		dec_stack_record_count(alloc_handle, 1 << order);
+	}
 }
 
 noinline void __set_page_owner(struct page *page, unsigned short order,
-- 
2.56.1.750.gf70dc682cf-goog


