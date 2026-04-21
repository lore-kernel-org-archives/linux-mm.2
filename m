Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1619EF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F846B0089; Mon, 20 Apr 2026 22:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6BC6B008A; Mon, 20 Apr 2026 22:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723A06B008C; Mon, 20 Apr 2026 22:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64FD06B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 083BF1A0BA8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:17 +0000 (UTC)
X-FDA: 84680960994.24.7B8CC91
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33329180002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a7tNoJVD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFMUe4eU96PwNZ4hmEg9N6ajvO6DYLBIUThz3MnM+0w=;
	b=dTPymX1EELQ4y/9qjmtZ83qMY3X7RDP3oRQvKu+eCN0M5Nl7N/MYfHY95kqz5gTIXJMhoE
	Xz9UAGutP8s+XOE/70D+7i44reLqXNMYthy/R0+phwjstNDubnZP6rTZ7B5gOsKE9QRNLp
	MN7D4kMmKhdjMWHnZlIv9/Ad/Zfj8Gs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a7tNoJVD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738075; a=rsa-sha256;
	cv=none;
	b=kg9LnP4RBMvObqfzuHcEMNdSQspMyxOHhXTXyYdKumGpRKar7u4+8cuHvnH28Ta2/G8CRn
	kTF4j4BHeROzkVzaBspQ6r7FQqc7ckaunCCtIsBjg0/VaIjbQyEU9pesWvtmf3d3m+1kMP
	vXh8/rpuhuNsc7nNPjZmwRPdaPLPzx0=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82fb2d0c5d1so1090604b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776738074; x=1777342874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFMUe4eU96PwNZ4hmEg9N6ajvO6DYLBIUThz3MnM+0w=;
        b=a7tNoJVD/iKaY/GnaQRuL6x69A0nNAWG3oLCGm1fY8rkfkmV/VzDsnhRmxRqrVJl/z
         fUR2AGKX68MatazG27JV6QI50qSDItDANDZs1o3gXeJ080UF3dPjPyswGoi4lBg5pM26
         G3Fd5NCXolCD4LcZxi74eoU++dhG8KZwNfLinSPuoqExxICWRSk5pw8UNs9BTkJomdO+
         xECXPSb1vVMGL6C/CPqrCHVbM49InIdUUzis7Wlv5BjENrxmQXqQBRwi9oqehvdLW4or
         endNAmcTIUYomCS4C++oJYxNWXuHW2qnm+XpS3RqjSvCdMq765vQdfH1mvAk1an1qqr1
         JAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738074; x=1777342874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mFMUe4eU96PwNZ4hmEg9N6ajvO6DYLBIUThz3MnM+0w=;
        b=R1PhTafEx3DazbGXJYsHMJxt71UKzMhdA/XcpgREmBXhXj9p36Cw0kzHmsy+5KxGoi
         g5IVfnh9qnA8dUai2Ib/RsLKwNdnqB2STO9gCY7gcC8/4O3ukcd2ahCo5Q/E6cfTyOJi
         qTqkvOvO42gvQ2DpjO1KJCbj3/aH/c5pCIh+F48i8Twv7/XlWK5GgalZnnEO+V6RIDJD
         6XOqj5+cbMj3PAb6fZx5dMkL/FnKkEhJWfGuuB8L4zLxIVLrGsw1cnsGZqSaWY+OIwT8
         5kNWCS3+pvCpj6IW0pf8HpXtQaMEzISXwUIjIsIdXrrJGAAn4bWwpt6TZbxsfF6Rn+jZ
         sZ4g==
X-Forwarded-Encrypted: i=1; AFNElJ/Qm9beBtq/t+6BMLVffuSvcvN5828VLo/SxOb/lxcX/wAAyUDCapBctrnFh6aPyjxK1KFqEuA4Kw==@kvack.org
X-Gm-Message-State: AOJu0YwyMvefs/M11lQgaLnkwgp2/nKDG48xs2cWZlh7N+Lqruc7eZSb
	MeS565R1xj4i7jqXABZUm2ijGhOKIlFl5/igmIJ3e4NaHExTBsJ2RKTVt+KZ1ulAjjA=
X-Gm-Gg: AeBDietPJmkbrWNQuQLjPvaVfKO05Xzg1MPBtyQx94jlwjS74SMQu2+EkDBvf1ZUCXO
	LlIKoOvaOnZDPrjrrUaNqUHX0CILWpOf1HltwRbmNGgjGdagUyBC8Ain+GbnmdDqVemVU8YQ1NV
	QKhgmCk0T9hYpHKkTcL1CvCDnmKss9bRWiB+akTgatR2F2OIFEQF7d76qZumkmCb4evxFe3q7dp
	Z/NlsEDs2SWO38hqj8nv1kVsPaVywGNOrzaomueQv2Qp47D8azPScmuimoadI2/FKhCbXq4WpC2
	Nh14gbYDy1HEPyU8OQ+jWw91X+0BnrCJto2bqJw64csTf9b0v+7EfRJ1BAKqQ025r5vjqYJQ7hO
	m8lBpAJEMb0uCxbp9Yw0O1kVSAVavhzFiwEQk8W88gKq2FnW4Gw0oQ7ZO8b7zK6z1cC4ZLsaEcg
	vnchn8IMAyYXmH3jDa+FnglymadiET
X-Received: by 2002:a05:6a00:992:b0:82f:2aaa:c14c with SMTP id d2e1a72fcca58-82f8b5060f2mr13376259b3a.16.1776738073875;
        Mon, 20 Apr 2026 19:21:13 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::340])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f932dabd4sm11538780b3a.51.2026.04.20.19.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Tue, 21 Apr 2026 10:20:41 +0800
Message-Id: <20260421022044.1217503-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260421022044.1217503-1-songmuchun@bytedance.com>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33329180002
X-Stat-Signature: hnmezmy9c6ip1x17kam7juhh839chzqc
X-HE-Tag: 1776738075-683457
X-HE-Meta: U2FsdGVkX19S7ww4TjsagAhIkFzncm8cAe41dtrr9bjPXbf3dPfnls6NcGOxr5seFQUtdyYx2HKw84pwpoAQfhwF6BxHerpBERRRycrmIG3mY7zqi3633RO4/b92rM44QX/nNNdd7DK0UGmmn1ExepOJ7DVGFzUU9akg1wv1iO1T6d+uVPXPvOPmpXkFON6BOfc2gjRIwO+94Z3Tz2TL7GyqTkhQiK4oT8xFFkrPD3/gw5qbm0a4M0UglZ2kpO996FuGQqEWJeoIChMMo5Om7+tG1+o57ycf+amaETQg/gYtPhgF8h9BIoj9eQIhWdzT43CpRfgJwAvRhP5rb0szQdrdBjWlNCJ9FNUfzxCME/sZL0PSD54Fiu9PE2WJxVE4Mmd4hG9r4H8wjenIESzdk6rJSnQctLlfEtZ2JQpXBYmqguzfdKFI86u7QXnvwoFuS61Aw8UjbYxFStUJjxYdwqflOmc2/dDLtrKeE5utObFEJNQrvXMeg3C5EK9vvX38+iEcybutVkv7hbSWaUkGlmkDe8WZzhNV0HP201wycZ3OvhWdH3BVacow/G5V4Ibm4w13x7c5yJXi7Wx5entzeC/sxm7RkSJ6x9Q2cNzOAde/9StDDAVmXuMoutXYhDHoCnxVKxX7Ce34KxVfMTKau1WjdIxFIZIhMSnwgQZiAfHK1m7PdmimIf0AHjT4vc6SLWA46wUs15Lu2to9f7EMP/ucDLJxhJE3hio6WTijtRn9DVYYgEYscAi9N+XnAPm87futAC30T6zlnFv/2kKaMRx58kKqWmXmCspgc704HDtdGvBK4W2/imTqchrm/05XTC/YbJNOH86MLqRuvktKcUfwbKUXBeNGsgcSjSlbFyjGelGBRqsg5bdKOSr0UPt7yD93xkFuhkKrdAIzG160HoCgIodMu/H3gjCRgd88TJlP7aUiawxkM3jbMuXSm3xkISyl6Ikj+C0PiOLOrzZ
 vXJHKX9j
 u+gv/QN1O7FUdK3xTrkf1JrgBRyy2yllgj5KJZMtWDuimpClxwBvDKUBqWDNRXLEhLKhQ/S3aPUrAflmqjT6vfdfz8KXi4UMLc3TvEot8YbHBbZYQeEzKdUwM2aIwukxXqCFLeL/BJQKMUXC+J1NEmpZx1lHy4dYREiGCxlZG+ZQYNjDJ0iFFq8rEZEN8UsziQa0erLQG68D6bRU73fx0YDVkN4S8AhQxvGC87Lw2lzigd7P9PXZu0DDkk9RnBvS5tHPMTqmEwmxXSypd8H0Cs+PjOe/XB2RVWn260QtJWSux/ugak8OVhmQmDDsH6V9aSgQIMbdwyIfJiezK136J1rM7dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


