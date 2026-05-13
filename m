Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA94CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D3B6B0099; Wed, 13 May 2026 09:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444826B009B; Wed, 13 May 2026 09:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B1A6B009D; Wed, 13 May 2026 09:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 239006B0099
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9F05A065F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:14 +0000 (UTC)
X-FDA: 84762424908.12.5780718
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id E5A2E80008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z87zQLaf;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UyK7iOrAjDiLiKTgZmma+Goz9i15/Iarg4XyDf9KyI=;
	b=Um21fGkYmhILuYSrKlGfDr01BgDf3gKiIqH0dILqYI20YFiA+YijfgGHpsQ90iqftpe36n
	wNrAwSIQke/mc7SW8K2HglGtbxLv9p8rToVZpexxJ3/sOnVd1Ng2lkd5njt8BeQcINpuH8
	NQeygBjsDdSZoRo3TtI+ct8qgVzJQ60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677693; a=rsa-sha256;
	cv=none;
	b=WjrRA38iBR3sH3M9rJ3tsD9oli/4pG9DqWwWqifM6qo89ppBHGeOoLt2ALkiYU1d64vg++
	HrD0SvH7kUCq5izvAVirm9owZQ4AOq/goOv1KBbOha9pY4xvPT+fWjOZPDvW8WPT1cvqha
	/gU9G90BPktIIKncC66Nr0OsdpdhHoI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z87zQLaf;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b941cd869cso42525025ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677692; x=1779282492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UyK7iOrAjDiLiKTgZmma+Goz9i15/Iarg4XyDf9KyI=;
        b=Z87zQLafM8y6wyDbH3I/69w9JLsRGp2Nb+QK0UcQYeubpY/V+OcAM/9YuGkAe0AwoM
         0jftTTJhE146odHbMq+2c/hpqSBU828n+/xB2gj/mjLDKvAzD/0t+1g1INHnNvGbQ85T
         cDt+xNac7rYGJE5QCRz7hLimTCW1FNu721bMEmRscz2cK5k4OByCYSt1Lf2b9WbjtXy/
         sh0qhQJf1j54+H+0B/BpodIPXO8uRXadwuBBALX/lZ9lVwox+Qy5mhiMxtTpXYAgJWnO
         lTKzCGKcfbiDV+qUBqX75TxiY38zJvxvfCjY6eeSdhU6ggGRPZ0qE1F8OtjSXLRo3QJ6
         Ih9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677692; x=1779282492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5UyK7iOrAjDiLiKTgZmma+Goz9i15/Iarg4XyDf9KyI=;
        b=YVfIYIHy4CjguZ/UHcVJN60jIk+gPC0RNjg77/AArY66cH/IR9CtWKqNbV+iEMvX9d
         lFkwDT0Z2r4Y5gz04JMlUV4V0T7tCb4pOe87OhtkSCaNEzNCz/6nP3L8FZ0R1HwFKQQa
         63bBmIzsSXVyrJx3yC1+kHtRbw63Km0X2Tp7ITS/QyCLMb7ygAbyTl4x9L56XZTC6aRk
         bDQu67zmtf9PG5JCeWJRxP5UB2J7huguDVW0Dpr63/52a2N7MlmtNEBiN9s68SBqHNEj
         WvDS4cBi60XRpG8Fd88tvjyhbToxTNVQyafdyoGtvLc6pXzN4Y3Ch4pekh5RHTgZhOcj
         o2jA==
X-Forwarded-Encrypted: i=1; AFNElJ8a3v81tBEpYvy6zW3J7TWtBShFty69ErOlQCb1mPxP1tup48/gQLYx3ndSZNr5eeSKdJ9iTWB7SA==@kvack.org
X-Gm-Message-State: AOJu0YwCxtGpupV/72qa8/pxhKdv2FBsKA0sHnp9gZXOYBfxnsgAUXzZ
	CtqvcECgtLWY8Eg7D8eccv5TKrIRLrOqKbO1AUpPBMiJQy8SuFn3dbr0p041ZkRHYKw=
X-Gm-Gg: Acq92OGH6amgSig62Kk7Ke05vyJECEvceI/ghjq9UqJRrgXdgOWq7c03GLYKZYVo8bB
	0l83UdxZbVQOV4R2KJV3Qk+Ow3oI7nSIZu9l0tkn/jiQsU5jtS+I+lyS/oPFsavojXwbgRiNXUh
	IPK0tVOed+/GhgQmdJp40qRBy+UixA2QPkoczFMwORh4Ln+1b3Wi4HlMW2PxkfdIt/rAtjcwxRz
	OOb6VfvyEOEGonRkG/EqL1GqgwmYXq1R5PT48yp6qanGr+uwjZnOTaOHhCTvt5/NML+DHo4Ak7g
	5eV1WLQGyoIbOFH43L/DCP27oJAwM28ZNCyjHncR/3yT4LHiIagJyQbdfyfScJxu7sQaA7aTIcf
	DQWlGQQ5Q4YjIBOUVIkXeeC5zjcbLNGPYxSQ2mkHEDxUZ0n24ivGDEVveAgsSuD2YI5BaMk9Zuw
	u5a5bze2AOsrArrLNOJV1WNavwQDckh3RA3ZIo19qubv97qnuKCstmDRZOr/8=
X-Received: by 2002:a17:903:290f:b0:2b2:539b:d2b1 with SMTP id d9443c01a7336-2bd2f6071femr19430235ad.16.1778677691580;
        Wed, 13 May 2026 06:08:11 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:11 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 07/69] mm/sparse: Move subsection_map_init() into sparse_init()
Date: Wed, 13 May 2026 21:04:35 +0800
Message-ID: <20260513130542.35604-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5A2E80008
X-Rspam-User: 
X-Stat-Signature: gw438mhp868ccqyx9w7tgoxjeo5zmxj3
X-HE-Tag: 1778677692-300301
X-HE-Meta: U2FsdGVkX18fGZMyNktF/KlTx0yCzFJWPCYgop0O4KkqHXylJ6MKeemcFArrHbJmW++RuUPxLYy+FvYl9OXzKZHzkU3wDTbIRC1riifNYJI80qHby7aCc9RwyxrJ4mYiTHRqvbFHg6D0NxVHtB9MDZ+cino+k79QUW5K0JJIJjO882O71vBbuZr1xANdiKKrj5RePWc+aEkb9ySosIfGE8zFdl1siiufRuJibAvj18rjfzMaDpp3Dul4uZHUJdeULLrzBAIeHkuVHgCAkQW3nJEjzJR6XwVLJU987mSi3mqiQYETlxdt2VV7E2AGpkkLfB8PeuhOeedjefzwh4trDRlMU8BFmajSXQ0jdlqigxXjT+SZvthXTgENGLYi3CBEqAtt3RsjWeHy55bD4VWu3Z1YMEGRWL9T1w5+98TcFozKNPVwQ+p3/MfTwPBvpGSGWRNQHudDsgchuLcyoSGJ2IPB43kMSjgXinNHdJW0YLufuNy3R86fgo3L0rrgLln7YfCPeLx6++55hwZlX99ync8wRH3OWCVy4WcrsE+ed1/iBurUXXEaza7sAr1isLVVWXonXClOU6oeKuUbLdOGDwTzDi0d7GoNmuW7/w/KPQwFIu9GVMS0krtPEfPdgMFRYey9TMUeNFKkRcoqaj2WDCGPeNllNq7Gj07rukNCQjTEfILcRlCftgNTofXgjbAvYviJmPs6x9VeYQKGUeqpNBeECagPtIZvJyytH9EtKoUdxGDqApiZ3+xZLWB2NrDi80q6TiARDOXqpjM9md71YNNpx3kE4NyhBuqvMrcVa8DGvFRzokvYZhfTBG0G2jETVaEElxvOo+T9iVdaz+jEAiR4PmXkWGciAtc7EW2IEDC65W1tKP7rfKIOV/kHwAvqZsRcvzvU6yWREJHJkDZUXRbniz9jRfwpfbiAzBBRygVDIsUdsjjYN37Yc9j436pyce0L1oywJ6WgMbD2hkf
 qdTfZiyD
 h7v51kua9dDFFvlbG3bGCbBEE5caTzwyMi17COVO63pVMmJCVEYBRaG0EeI6ekFIA7zcbEO3TeDfkUZRZcgg21O+CYalUEhVWVFPkTjU57/tvCOnsvTIlLgrMvPA5zxXcW5YAMR2RQGh1slNlVEoc56ONKaetxswNt0dkWFt7oepwy/EOL6wjaQJgJY9tV6PnvQ2EC+IfTwqvBSI4LOHRZ6wzqVOm5tDo6nqIybe2r+9MSTGAqqlfVwcP3paeueoA9xJDWGaIeGbhOCSmN2id3RpW5eErxgLYeu+nMVypp0OsPYzYriunikTYXgLMb8OuKaR+fGY1uFCUdvYGB4SQb52fNX3WJLBz+HjjfHuoJReHdEEydWOUofL+DKHM6/mfR6zgNh7Bi6HYwaG+8nsQLBX1QEjWzzPlj6kZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

subsection_map_init() is part of sparse memory initialization, but it is
currently called from free_area_init().

Move it into sparse_init() so the sparse-specific setup stays together
instead of being split across the generic free_area_init() path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v1->v2:
- Add Acked-by from Mike Rapoport
---
 mm/internal.h       |  5 ++---
 mm/mm_init.c        | 10 ++--------
 mm/sparse-vmemmap.c | 11 ++++++++++-
 mm/sparse.c         |  1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..28d179cbc451 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1003,10 +1003,9 @@ static inline void sparse_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+void sparse_init_subsection_map(void);
 #else
-static inline void sparse_init_subsection_map(unsigned long pfn,
-		unsigned long nr_pages)
+static inline void sparse_init_subsection_map(void)
 {
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 96e0f2d8c3ea..12fe21c4e26c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1876,18 +1876,12 @@ static void __init free_area_init(void)
 			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/*
-	 * Print out the early node map, and initialize the
-	 * subsection-map relative to active online memory ranges to
-	 * enable future "sub-section" extensions of the memory map.
-	 */
+	/* Print out the early node map. */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
-	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 112ccf9c71ca..fcf0ce5212f1 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -596,7 +596,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -619,6 +619,15 @@ void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages
 	}
 }
 
+void __init sparse_init_subsection_map(void)
+{
+	int i, nid;
+	unsigned long start, end;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		sparse_init_subsection_map_range(start, end - start);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
diff --git a/mm/sparse.c b/mm/sparse.c
index c92bbc3f3aa3..85557ef387c7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -361,5 +361,6 @@ void __init sparse_init(void)
 	}
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
-- 
2.54.0


