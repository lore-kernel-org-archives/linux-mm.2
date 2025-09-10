Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6471ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FD08E002E; Wed, 10 Sep 2025 12:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19668E0005; Wed, 10 Sep 2025 12:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1BA8E002E; Wed, 10 Sep 2025 12:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 876108E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DFAB1A0163
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:34 +0000 (UTC)
X-FDA: 83873825868.09.F574CED
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E45EC0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbPq1hfa;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=griGxIh9GEE3HF6pE5uHZRdQ9DQCWTXYvIepBVp/qTo=;
	b=NFUKutFJCJCcbX1BkRrTs+/oJcEJiOppHlk6aEH81MAUvDuN4pxQO7dRe2M6r362p9adM2
	oZnI6g4nCPrNTIsY4s+uTpmSyKRzt6DnEOoJcSJDZ+zMva0S2aRre1jDGa0vto4NBDtV1g
	8yb6QvabAgOzoh2GcakM2m1mlBnoiI0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbPq1hfa;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520572; a=rsa-sha256;
	cv=none;
	b=gMF85EkU5pbDjsp/M8ByetA+ZyyXrFPAjzMXwpAU+j9egLyk3BtP51wTGjj0azxa8kRQZB
	D3OP03IlOlE4eenty5rXAJh9fIB57l/1L69a3fETpXUGeHKidqNdyIAFVZuRtod2VpOXcL
	CRBW87QcObgKqPjB25jxyeRg+hC4SMY=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso6017420b3a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520571; x=1758125371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=griGxIh9GEE3HF6pE5uHZRdQ9DQCWTXYvIepBVp/qTo=;
        b=VbPq1hfa4s8cqup0s7HVhLd9OcT0qfxkkuNhldc0pSwRV0Ij5P4SetaDZNy2F0wThh
         aFEaCdX1FLOzu+2vcI/ui/OwGub3/VFETx5ek5AXbn7/mIadBAQbG8e2tgZ6ZDUD5cpU
         TBH6NnvLF5/QKAV4MW+frbTVjZuUrifd+pOmXHs/zN2UY2g/+UlRrys7iGUsRlOJgh8T
         tMYOca3PHXKQ8TRbyiM622YgfTo5431Z78UHIkRvd7u9BI70N7zhSD+4mqbZwkcFp2bG
         F6pIqr0sVeKGtqJ+7q4CxKC2b+k7rxodRbPoSsxYbF8PovF0x1D44Zuutzv1GxVG8clY
         s3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520571; x=1758125371;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=griGxIh9GEE3HF6pE5uHZRdQ9DQCWTXYvIepBVp/qTo=;
        b=G4emAMA78G+93LmXABeuBvTfpwEhhVHawx5dY7V/42lIGmw7kfg0i8a25+W1tnaeik
         B5qQy1DAE617in6IsQL64DBgE2RKlrjjyKxQeKXj48u7NCp1H/yMHapfixgzskqDlR69
         NfIjZFiaiEQ91ZArZMtg2zeTahTIXEfIefTlxCAaqs4SkKgiyVgESOFijTEhgtoAJkV1
         0DJpD24PW7VsNRnomxOExltzx0qJxbBvBgtYCGRTJB69ngj4aYIwPYhLfvmcXXDI6S1I
         zEqjXA9pp0Nabp/OJU7MVSct7qy8ckZ7XOF3G7c/PI7xx/qpLpxjZO8kR1ZMw0sPDHnv
         EGwQ==
X-Gm-Message-State: AOJu0YywifT8F8lBTT4Y+vxcVBXaJjLmZCX7I/L+Vs+eiD/dhKslWwnR
	yIFaoIIXsajli/eroFeKYLTG5LBtJ6iV0qybgkMv6xZyPmXL437p9n8lmnud9TZ03Fc=
X-Gm-Gg: ASbGnct6vmFgC1Xtgc40IvDpCgF1BhvA/0fsqXn81+OfAmgzDey7qSzmdAlp04gDe8O
	03sZGPTkLT43B8HvjEFBEXI/tDiax+KpfaeTM1e1uSAfHb+1Jpq/WLMc/wehnqnfIKcKrCJYFjA
	6kcD8NzJOyXbh4LKBtCI7dK/g0ZGiHU+ssMc7GTQLW1v9p//PY/eFO4WlE7DjCMiyDFzU94FFft
	qaI8dahBRNENTNzx5WwQ8U8YC4u2A2pkK7nX4M16YNp7E8xPrJukzli74E48p2/PzkXtZYp6D0j
	9u+u6BwoKwd699wEC5cFlWcLU15LaFVcea0GLCmQBVHeKT8sn088Uq+EofantYkM6Hu10OaO2hI
	uJGfe7s9u7znKN/xMBRwcmewihQ9jfMsJVBJk5jKOH989P54=
X-Google-Smtp-Source: AGHT+IF79Trm+wcbzKOddKHrBqAVQp9c3H0wicsNS7W5K+jd07nVhIvIvzw66BfjwtQW3jqIqjmWZQ==
X-Received: by 2002:a05:6a20:7484:b0:250:9175:96df with SMTP id adf61e73a8af0-25344415c9bmr25513067637.48.1757520570590;
        Wed, 10 Sep 2025 09:09:30 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:30 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 09/15] mm/shmem, swap: remove redundant error handling for replacing folio
Date: Thu, 11 Sep 2025 00:08:27 +0800
Message-ID: <20250910160833.3464-10-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E45EC0009
X-Stat-Signature: daofu634qcch5xkzf4qs7xhb4om3z3f5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757520572-600708
X-HE-Meta: U2FsdGVkX1/dWuXivA3LuQvBQxLEGXTOvuD7aG2RZrg2bqTO7zBmkS/FebiORzltKz8Ls/CqooQXxiw3PMK73p2FptjC1UJKTDyMEx3zYQ+iWEyiDC6rG9MR1++WJ6nWZdbjJ55NwDo5beE8b/6NuJlRLc1Zni4RL5AyHF2seQlv3xvIbx1kmU2S6SzZhY9cXj5D0do5VEOekQjVd3y+1CYYi2eU//76at5uMZu7Ia7vJNR0dxfn3izAepe7wwDfVHausBleKDnRhcqVcDaDuyTaG55dl9BtHRm2LJNJI1ZICdbcQOepvsH9kf+Ypb10ENsxEyNWM0bvdzgOQBCOa9wltXegbL1oVOVonjqFYMgjXqG5sN0JaZxZ+fdc6mZf/km+af7HLlHjPPHSuuJ5VWjcqrnaDBZyT33vT0ZSNrmBsGRc+ZE6+d1AMIFhp2kslif7hd6Urca/24I75EoXeX/fOJ0isWo+FpYrusjGwoRd1K1cwh/U5LbWTOHASj1TQ243UI7j4YRFqwsmpi/33ejb8/zkyygC2WFd0lpbGoluceUgAXOR57AmYQSnaxLANyiaypcUbtpOlsUsSrv+VSA0s1Co6dnF6Rc+rW+gy5TShyuO7s4nCbDzUdD9kGSWW93CU6/hzWsIMsrup0L4e2ZeDeGoddKTUe3NseREpGAs1nKIofG4twYfIuT2Es2IrkuFaCZ4j6hEgPaeFvuQBObSnhNI/BtAOVepUux8+1I+n1eUbsjpR2fMYcjlyS/b79t2DeUZ2ItaVR+Zzot8NYzfWG5XzvlxD4jgWFSQSEAGsLiBejMeN04sqL+u6wRj5BYtbKD85SsnJhxC4NehiPVjYYki+CLQ0eV90s/FJZ0iBgoCU7aE6J6bIb9os9h7L0zzFacFrxZDduzx0WTzbs+mcBBjZi+tjon4W9rwaA76ZM8uIxsVH/s4Z+0xPc5rlSIoLGlre8mPDghyr02
 2P/SIr/k
 07FrrZl3RdQ8XoVhsW3Dla9NlWoQiEO9PpLVwtySq530YsP75uOgwlmRSxhT9ZwUPz5BOtje1QefNAsvuls0y6hvL4IH+zNRlNr0ja0ugD2WJkZf5BDyN8eHvAf1yxW+HwQAnmuqmoMq/R0q67XtgOqRNtB2Wx1/SYR4EB4u7ZcoDYlAFZYSaNhreqV/EFQuJynrPQt8zXkkM+jTRtXtpu2Hb9cU8yXzEuCsj2mtvje1L8bm/gqca8J7CibNfRiZngny2Fo13vm9LDET4LRVG2JRNlwfdg4NmteLHVhmQfP0hJ0EK7S1h6PLTMl8H8NK6NOwYho9FIcE+q28FEFl9zCbIwWN4ZuoD7b10ozEiPITomeRGXyAoP7ZqemoEKHJzv4CjSrzJI3DZsGu/iVVZTgcREND/HGl54c659pXztxvXq8brmgNowDACzUrvCOZNOWh0XwW03lLWhqNTdIx5ph8QuztUdaixAyebTPw3jLxo3LmWePsBeLRc1q5nZAvnzZCs0PSvNQt+2EWRH9pGVJengn/03b1uW9TXmOV56cfB/reX27OSckeLSnuMuwOpSNwZ7BXzNTMkmUJki+yxsdwbfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem may replace a folio in the swap cache if the cached one doesn't
fit the swapin's GFP zone. When doing so, shmem has already double
checked that the swap cache folio is locked, still has the swap cache
flag set, and contains the wanted swap entry. So it is impossible to
fail due to an XArray mismatch. There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead:
if that happened, something has broken the basic principle of how the
swap cache works, we should catch and fix that.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 mm/shmem.c | 42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 410f27bc4752..5f395fab489c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1661,13 +1661,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		}
 
 		/*
-		 * The delete_from_swap_cache() below could be left for
+		 * The swap_cache_del_folio() below could be left for
 		 * shrink_folio_list()'s folio_free_swap() to dispose of;
 		 * but I'm a little nervous about letting this folio out of
 		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
 		 * e.g. folio_mapping(folio) might give an unexpected answer.
 		 */
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		goto redirty;
 	}
 	if (nr_pages > 1)
@@ -2045,7 +2045,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	new->swap = entry;
 
 	memcg1_swapin(entry, nr_pages);
-	shadow = get_shadow_from_swap_cache(entry);
+	shadow = swap_cache_get_shadow(entry);
 	if (shadow)
 		workingset_refault(new, shadow);
 	folio_add_lru(new);
@@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
 	for (i = 0; i < nr_pages; i++) {
-		void *item = xas_load(&xas);
-
-		if (item != old) {
-			error = -ENOENT;
-			break;
-		}
-
-		xas_store(&xas, new);
+		WARN_ON_ONCE(xas_store(&xas, new));
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
-	if (unlikely(error)) {
-		/*
-		 * Is this possible?  I think not, now that our callers
-		 * check both the swapcache flag and folio->private
-		 * after getting the folio lock; but be defensive.
-		 * Reverse old to newpage for clear and free.
-		 */
-		old = new;
-	} else {
-		folio_add_lru(new);
-		*foliop = new;
-	}
+	mem_cgroup_replace_folio(old, new);
+	shmem_update_stats(new, nr_pages);
+	shmem_update_stats(old, -nr_pages);
+
+	folio_add_lru(new);
+	*foliop = new;
 
 	folio_clear_swapcache(old);
 	old->private = NULL;
@@ -2183,7 +2165,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	if (!skip_swapcache)
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2422,7 +2404,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		folio->swap.val = 0;
 		swapcache_clear(si, swap, nr_pages);
 	} else {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
-- 
2.51.0


