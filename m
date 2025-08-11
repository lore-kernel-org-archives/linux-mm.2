Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACA3CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653378E007E; Mon, 11 Aug 2025 13:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603AE8E0060; Mon, 11 Aug 2025 13:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2238E007E; Mon, 11 Aug 2025 13:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 410E28E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:21:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9BF8C0273
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:40 +0000 (UTC)
X-FDA: 83765143560.23.BE2B34D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA45B2000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VhdPcKep;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754932898;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeE8CaQ2K5i+oPH7GVC2aPBcfIXmZD81doSr56qB3l4=;
	b=66YaUcX9a74mNvCw4lY01dRy4jUu0PRw/nMHWcTqNiyrPgg+gHHnZePbRzVRhVgOh0oXGO
	PK0XPGyLYdq2iPf//UsXFmqsicT+gdyB1a2JtjSp8kHSslCK9j1dI1Zmqt+jKdR1QvZ6+j
	v/Dzm9pl8ARhAC9BUhxdVFr5FCpqDP8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VhdPcKep;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754932898; a=rsa-sha256;
	cv=none;
	b=me837gfYt9yUdzSQ8+G98r4Z3gB+sfMogxMsClyVcEOmxL9q6Eg60cNUk2mlsKfMX9u/K6
	LRf6qRySQ9bWaQ+vMD+EfXjyaiawSOvzE8LcecxhzE56Lm9Hp5eKF9ROMPQpZYKvIKgHEO
	6PaJv9z3+HlGFc7h6OCOsm+Av2XxPWs=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24099fade34so33042375ad.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754932897; x=1755537697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HeE8CaQ2K5i+oPH7GVC2aPBcfIXmZD81doSr56qB3l4=;
        b=VhdPcKepBsv+ah9WUdDRK/3ffeVCep2rQGExOoLOgYdBaqV5EIC1tHl+CxaF5/GFKY
         u9jp5VVQoK1DPccQpdwPJCot99gQ+w34aJxOhTuJVh6nEMXpYRqL8kG3EQomMJwvxHKh
         LIe+z9BYIk2I62Ix0Drm15cwtQbothJ/5bE424KFdc2uxFpft3P+82JufzE1U3XKkorl
         ENcI6bRPMNFoyYuV9XIvlFFoT/1kF2e/MQuItvsEuXWKikgeTHpitiimt/ZaYNIjFh/N
         sxKlRgMXZz7y3lN/Lf/qywpCoaI6i/JQhVYT6pzOI/Nz5oLhC7E9zUmp/knPOYIMLrFF
         +SJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932897; x=1755537697;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HeE8CaQ2K5i+oPH7GVC2aPBcfIXmZD81doSr56qB3l4=;
        b=W1Xnait9XOfILye8onre9zCF6RUNgR8CvJX8xS/sv+aEoeBnAW7ZwMk5SyCo63G4DK
         ASCwYfzuzK1It77nntHeyO3ziHimW97q9kO52CqBv3hgyC6Ip381z/NseaysJQVDx6MI
         BzzlkirY3eIHrAzn6k7ENeUSZzvB5BnynItp5CoKzuEZbGyW6P4F9/ewd4QSKs9KMo2v
         nYYwdESF9KLyd2/LbdfA9k3E0zIz+XeiCr9hxAMC2ZqxnCPUQ6MbAD5pjX8Ws6SYb8Tj
         0mIXnw76PZwSNC33zRPJlQGFUSgzq3mL1xPYNJN7kkIty1eM2XM/H+QONNVOJD4bQdSc
         MR1w==
X-Gm-Message-State: AOJu0YyMbMLHys3HotyVpOhzy16BZkVI5oCwdGBvVLWjRtgyI8j1aP8D
	UTZ3NFWhSwxXH/Ej+RqOiClCfLr98KurzJrelu75F8BZZewntajodtsyJGOpzbqNwfs=
X-Gm-Gg: ASbGnctlpndvAz5a8Q/z/eNNkw4+neqpJeMjQjjKElE7XOt2pYcSmOxEoe9M2nnwXHI
	S9wwFLh2BidC5hArW7pUDUKXvAX1uGHuRwkwrxPe58jQmRQgN5Ejn8g0OYy8pdJZxGUuSUV1c1s
	U/VBB5TRP9qSY3mbcOgBIX4rQ3y0P1B3dK34Usz+RxKTVhTjLUNYIedD4JADaNLT+Nmw5F/fRTQ
	+6BVZF3ubm4+lqqJcmLJQgGWXVJkSx9kVPZaJor4uXrE8XOq+Thh1+sSYpVwahIGn2BeQVy1rN2
	JkuR6B83muTteS2IBt1YpcXudp+nPM/aojI48uqU5KbcvLhFwT6WWIjHh0UkAx2twcQXiPzLyEw
	hBCqsvL/VBwcllraSPtoK7vHLKx6RGQ0uecxiVg==
X-Google-Smtp-Source: AGHT+IHTmczJxTiTIxYVNE4NIKjMSM7gIpUc+S8TfKU2hM8+fGSlcbq5rCYS33AqUl07gxT9R6woCA==
X-Received: by 2002:a17:902:dad1:b0:240:9f9:46a0 with SMTP id d9443c01a7336-242fc340439mr4695835ad.38.1754932897189;
        Mon, 11 Aug 2025 10:21:37 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89769fasm276685055ad.107.2025.08.11.10.21.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:21:36 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 2/2] mm/mincore: use a helper for checking the swap cache
Date: Tue, 12 Aug 2025 01:20:18 +0800
Message-ID: <20250811172018.48901-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811172018.48901-1-ryncsn@gmail.com>
References: <20250811172018.48901-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA45B2000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1ok1dmha1dtaqaw76uitsc5omusqp67j
X-HE-Tag: 1754932898-776559
X-HE-Meta: U2FsdGVkX1+UZMYlEsegN8Fr2GAFyoVNrJ3sANgnOF+j2snkRazTm5Mk/5YoE+iFA3yHRgBZz9zb+PEt7QivzRYZRUx/HaRzAyUO2F1zY/Z++0ssPXe2kRxE334kIofYgYt6Ao5+Kiy1sSAgqy7SRsH4yrahG8zxsNa/FrN7h405LfxKIBW95Cqv1QM9IE38SGf1jIBMSv/ogRyosihenJ5FUYDH7W/9ikr7JwKLbVDKPwrlbhwJGgVRFjf5Sgnn7IarmySrX9mZlME2FXVadBdTSTfZMWoTPKjagQNaAdQrmtYWBfJLE3Yrpfo0y8dugFSPonfWAqr7hBdcZrmye8JixXmLW6EmRubpZPIoa8ZPppi5WUBJt8bhuiVPYPFMYwC+YWz3QjMagsfHe1af8ILCzznly+LBJFips0R27csg+XxdPQ5MHyZjX97stMTQbUT9X7eWkp9SkYjiXmrVdMq9WscG2qfXRrZytrsb9/XAeschvONQUHf/362Q8ASvPBSreNJXSY4Kfa3Rn+8VCInNjPWBS5dXgkxzNVpNdVNC9bZ6TiyNJlmvm6tQhnv+8liVm/o1RTavdK8AhsUDZFwXYeXNE026gcGQfpgNfP3586zarJihSQljY+lbvMjX8V/MTk2CSQ2FOFZy8adHA1f09nlGhKUQD4DNUPt1WkbyXOEoH3aN+JvBQ7D8TmZ5nMYVpISkBR1hwgsy/WzCOWIgs/3/GtL/qxXwEFAdl8aVjt6fg77N2WmY6gRQpPlfRZaHCoS1vBougD3AKbOb8hFYpDUA4fJrxSsfr5n/2G9UZWPsQsb6qaQwpl+SNLnzQyEeHNlCypdDE2UKxlxnAvj6GvMNN7wQ9m3Q8OsuQrLHiqP68vubl5jOgDJNQWAi5tl5B9Iv4jIHXapc/rYV4Sa44N8wAWoSKx2EwIo3184J32vJIj+mARa7nQBVOh/rC8NOdIIQZuDLGAXWyVc
 s13qECve
 1GSCdBlk8iPOLt47oB4J2to0zztEHqF6KQROgd/lDbD9ReUL1sTESmLw0YvL6Lzk5xbrtnPyDC4yqCaAya5hX9Kq6o8Ngp5GliD/DVwZCZOZpIayhw9ds0a3JyDXRQVr+5itwjqGO8pjUEGlgSm/EJwCl1FX7SIE2xQZqXCrg5XIcA467RaQJryNGPSliCQiJYG0jI2ZEkdjeQlCia9KU2QhojVeHQBmbv3MaNtpgbAlzPntjOnwWT6i6csIyopZqhxJNsmhA6FptcPr2Hpsj+/CBYYgMHHoc44BXGVFu+9cb0MsEZbz53BAdlsicSRl91873u36k6dcIzFN23oYHves489sCjpP78xFg9t1NB9fFMEoSBittKtVL1gfdX4EPPWThyB8r9ku59BCiPjedhwGD7AvHRc4y56CAr0FQn/wcIt4RXmwlhItjwj8hQVhGLIPE1XPbd2+9RH5Cb+XVxN1gEGbL2HVqARZWwTtGbNH70QfIico0aaIQiZGIzq4R9IxBqaqu2M3gJW8yEFfL1iz+ea2P9+G33862ALqKgkeLN0e9ck1lMLuOHS6p5EgMx/5jinAahle9Ib3Bj8uP8AnFx48P05XYOgUe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Introduce a mincore_swap helper for checking swap entries. Move all
swap related logic and sanity debug check into it, and separate them
from page cache checking.

The performance is better after this commit. mincore_page is never
called on a swap cache space now, so the logic can be simpler.
The sanity check also covers more potential cases now, previously
the WARN_ON only catches potentially corrupted page table, now if
shmem contains a swap entry with !CONFIG_SWAP, a WARN will be triggered.
This changes the mincore value when the WARN is triggered, but this
shouldn't matter. The WARN_ON means the data is already corrupted
or something is very wrong, so it really should not happen.

Before this series:
mincore on a swaped out 16G anon mmap range:
Took 488220 us
mincore on 16G shmem mmap range:
Took 530272 us.

After this commit:
mincore on a swaped out 16G anon mmap range:
Took 446763 us
mincore on 16G shmem mmap range:
Took 460496 us.

About ~10% faster.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/mincore.c | 90 ++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 20fd0967d3cb..2f3e1816a30d 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -47,6 +47,48 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	return 0;
 }
 
+static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
+{
+	struct swap_info_struct *si;
+	struct folio *folio = NULL;
+	unsigned char present = 0;
+
+	if (!IS_ENABLED(CONFIG_SWAP)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	/*
+	 * Shmem mapping may contain swapin error entries, which are
+	 * absent. Page table may contain migration or hwpoison
+	 * entries which are always uptodate.
+	 */
+	if (non_swap_entry(entry))
+		return !shmem;
+
+	/*
+	 * Shmem mapping lookup is lockless, so we need to grab the swap
+	 * device. mincore page table walk locks the PTL, and the swap
+	 * device is stable, avoid touching the si for better performance.
+	 */
+	if (shmem) {
+		si = get_swap_device(entry);
+		if (!si)
+			return 0;
+	}
+	folio = filemap_get_entry(swap_address_space(entry),
+				  swap_cache_index(entry));
+	if (shmem)
+		put_swap_device(si);
+	/* The swap cache space contains either folio, shadow or NULL */
+	if (folio && !xa_is_value(folio)) {
+		present = folio_test_uptodate(folio);
+		folio_put(folio);
+	}
+
+	return present;
+}
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -64,33 +106,15 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
-		folio = filemap_get_entry(mapping, index);
-		/*
-		 * shmem/tmpfs may return swap: account for swapcache
-		 * page too.
-		 */
+	folio = filemap_get_entry(mapping, index);
+	if (folio) {
 		if (xa_is_value(folio)) {
-			struct swap_info_struct *si;
-			swp_entry_t swp = radix_to_swp_entry(folio);
-			/* There might be swapin error entries in shmem mapping. */
-			if (non_swap_entry(swp))
-				return 0;
-			/* Prevent swap device to being swapoff under us */
-			si = get_swap_device(swp);
-			if (si) {
-				folio = filemap_get_folio(swap_address_space(swp),
-							  swap_cache_index(swp));
-				put_swap_device(si);
-			} else {
+			if (shmem_mapping(mapping))
+				return mincore_swap(radix_to_swp_entry(folio),
+						    true);
+			else
 				return 0;
-			}
 		}
-	} else {
-		folio = filemap_get_folio(mapping, index);
-	}
-
-	if (!IS_ERR_OR_NULL(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
@@ -168,23 +192,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			for (i = 0; i < step; i++)
 				vec[i] = 1;
 		} else { /* pte is a swap entry */
-			swp_entry_t entry = pte_to_swp_entry(pte);
-
-			if (non_swap_entry(entry)) {
-				/*
-				 * migration or hwpoison entries are always
-				 * uptodate
-				 */
-				*vec = 1;
-			} else {
-#ifdef CONFIG_SWAP
-				*vec = mincore_page(swap_address_space(entry),
-						    swap_cache_index(entry));
-#else
-				WARN_ON(1);
-				*vec = 1;
-#endif
-			}
+			*vec = mincore_swap(pte_to_swp_entry(pte), false);
 		}
 		vec += step;
 	}
-- 
2.50.1


