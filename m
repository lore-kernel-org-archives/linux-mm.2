Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A81CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EA96B0007; Fri,  5 Sep 2025 15:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F216B000C; Fri,  5 Sep 2025 15:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70436B000E; Fri,  5 Sep 2025 15:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8D26B0007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E0A116013B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:56 +0000 (UTC)
X-FDA: 83856148992.26.D2094DE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9361C000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J9WViZ/0";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099694;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox30d6DM6rDiHJuPv69STkw16eZZKgiB3gZs68VZQi4=;
	b=PQW14ITcb+wTtJVfW4IurAcws7LQ6yjJtO5ksxW8l8lzs8hrKtw3pRZswYt8J1GtBB/DXr
	Wap1AC3a6GbBaGP+l+UxKnJj6aZuVy4MbJVcDZe4xH2lMXIQwrf0/zOMB3It1Zfm8d3ByM
	37rWFkQpv3QyI44IlcdZbApLsfP4wqg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J9WViZ/0";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099694; a=rsa-sha256;
	cv=none;
	b=N47HfcIlVoyPex/VIxckyL4PJBFMyXP82i/ZY+cbZAftZ6NARcV7Wl7Gg9i2yR+Sqf8EYd
	xEBycBowktmxHyvq4xRr62hDUuTD7Dl/oU1b1ki5ZitAqcP7yx2CK6O3dd1oZ7w/IWU5Py
	Ch0q4jz7st+j8GG0RRe01A0cJPOEc9Y=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-772481b2329so2640559b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099693; x=1757704493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ox30d6DM6rDiHJuPv69STkw16eZZKgiB3gZs68VZQi4=;
        b=J9WViZ/0wJMIABl5D5XtwBv8Yz6IrLJu6ioiKUVwnrueaHtBYVWT/62/OmxwAF3gd4
         aeMwjG0gLfTDqA/dz/F9K/vXwE2VVkYD8JugCIdXb+iGbFUJih/aL1hgIG8jfduj35Ek
         KRkJ0FOIqbs8ZpYkNz6xDUd83/u1QxJvfvKNmyrQ/s2YVqUW/DRQtn5U7E6F8eU+JzhI
         ijzYfo6AkSvcESwVD3zx9zdYAgi5orFEIcuPfePqomguO7PDOHyJw1/CiKn09ruGpcAu
         KZ5gnPH+1ZnWYKqw7bbgBogvqlnJ+SHn/AuuGJ9cvRIWwaCuyfz3261PH/r2PWUSfG6Z
         7t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099693; x=1757704493;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ox30d6DM6rDiHJuPv69STkw16eZZKgiB3gZs68VZQi4=;
        b=vm0adYUDeKliEvy7SXTmJPjCBpzuJkB3SrRyL/ECU4ridNX3ogFpCFoHxwZACEPrkF
         VcO+uAhGUFNiIuBtr3HI3NMx/pk1hZCbvjNm39zxp2Jwau59n/gTWplykgZlfpCpjsl5
         0bdT7n+wGymwupdPeJhN66ZUuYHMYXPhlFEZfjjn04MswWnXRH4E40nVRnoiVNkXfoRL
         gqORPpG63ArJbfCBYBQFXySlyXstQmZDep730DSO/bxvcnXXsdPBnxW3318dgs8QgFey
         lITZHCH1j6HWQ6PIVhIfB1ZIFy4YEe32QM36fcfQJa5zxrlEcFXGLmMvW4G3vPLl7q1J
         Eoag==
X-Gm-Message-State: AOJu0YxRQL46WTJK9HMqODJf9tbTDXEicSs4xt99Ke+VnKrAZw6lqN6R
	dR2y+bz2zQvqbwE+7ATiCHNmB271XYoxonokmw02B2Uslq1TRStNt286tUpmoDT3+p4=
X-Gm-Gg: ASbGncv/7BAKr9rcVR0HjhHltSjJ7JrU5XGzg1cwP1Ygf4tNc90Ja6G4C+rngYjh95Y
	qeVKJLp9iOxBrJl4HLknQlSXsALXv6mMSLfOdW+jFZelwcfQlJm2ODxliIU8cLtUV2lgDl3A9XS
	Bv2JgKaqBJDUJjQb+E7nVZsRASEoVrqWH8K+I1Y4FvOZ8AIZTxBX4EQe5XRAfwyVqLczIegq8tR
	KbWSzdTgU9bEueRbp51XikSvGmV+Gas83DAqV/WIwoJ5b+koICpgoYTRODSIt5iazYkMCa0O6l+
	/wJ/LAvzU3NsK70Pq9Hvi/rLs3nhYt0a34TqNsAr7lBmsBdxLv1PD0iewzg83Kw7QEewlrnPMfV
	DpswZ+pnc50smKVU0s0bQR2m9XWL5kUuj27mKSBkFctnIxjE=
X-Google-Smtp-Source: AGHT+IHkfM1wQBbs4k5VXAzI/0q78S/BXsy7LEozPN1l6mv9TC/7dXb738MOmgCmXvDJRIWgub+l9A==
X-Received: by 2002:a05:6a00:10cd:b0:772:398a:7655 with SMTP id d2e1a72fcca58-7723e38ae13mr26648003b3a.23.1757099693154;
        Fri, 05 Sep 2025 12:14:53 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:52 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 08/15] mm/shmem, swap: remove redundant error handling for replacing folio
Date: Sat,  6 Sep 2025 03:13:50 +0800
Message-ID: <20250905191357.78298-9-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9361C000F
X-Stat-Signature: 4hfre115pgmas1y75m7p74txafc5oa66
X-Rspam-User: 
X-HE-Tag: 1757099694-413485
X-HE-Meta: U2FsdGVkX1+E2fW80W9lpn9PbXsqEOj0pBEYv5qPuQz+tJkIpQthAvd5VNuNt+4BwI2rmuU8LqC/A6MhKsA5EEtft12T2Y9IUl7znWxNz+Ry2qn9m65dbPZtTORXcECN+jl+8J6P1cwQEt9lJ/qo0XDjHHj+yfatz1VKkvx2IhiliC/AtkIOXM8JSDbMMKg9iF6MIFQ2/zyJ9cAhlUaahpj09mdNyBzIdvo5+31dv1n3S/yBcpntS2euMCekiDEkxmpeFelFakSXCda388AaydI8RKdEWfza59uXzWPsOm03YOPTYbOtiuN4wELh8Pgo3z3ho2R+9qIU0nIDthBgydbf/WLFBfw1UA9bY3B9sZF2RAdzuSIdNKDADQXnXTacBsY8E1Nh0XeTeq2oO73ijevH43XbdYlr/p5cwRyOxmCwrBiDjhVMZ0LCoySW3fKoBXDaBSUXjuCs4S/p8vQEPYaU8rL1WPUKZEJoXVyDey5tfbh5maIEy8ATjxrc+niL1n4DA20YXiAShKhaw/jtbyQxHqBYlKtUpgKSQaXomdQT6b/Pclmi3ipR97cFBNX4pn4Qm26pb0aeog1RPBc/jSEqP8rvFt9iM8Y2vChfHiS0+R+tPAHnr1xVQnban8QvMLbecqTOk2j5I9+twZIjNUHBhQ1xw84it/tRJN6JCoaHBrI8NhiA4qTTSXnodOLKY1qByPiP7ZITg7toLXBYBVuzso0sGrUlWEOtjKMPue+4xXDGudw2EHc+SU2/gwnHDw+mqtN0QTf10VSb+gg4wT4X1EmyjXlY8/jJOfmo1HjMCfA5QXwSdfZMkekyqg39Un6O2AuOpeGDGc5FjScITE98M3kRdE4N952pZEIEUzRYHJX2ndr0DnmV2MYifWyDO+GbPPaW4LU1AjaldNN/LcwfrymDNnSCDKmYchHlh4qpVIATR+aERWluCOzJNvD9tlNfzCsFnw09WMUTUJ9
 kQltTRAl
 YPNmSnMcudXyPlaU6maybrc//T1UdggRr6NhndE1lbiLYa7gbEGFnbgKqtYfhD2D/KRAIQX/1wvzWx0KHFdXgWAriftMgHf+/8sQBYwS7iLpENZZbh+f5rK8GQ8qbkH315VM8K3DcrnaFx3W8d/j16Jg1Z23aJHbdwKgckizRFMrgSjWWLnbOOsETdsPlWkayqDiRm08DjD9VoJdWUBROFTHD315K62mNyUBts4yizrVo4JZrSIVGmZNGl/mTZwAmDejhPOO9J8gZrm1HDG0FakCh+CM5WRVsgikBfH/kQmBsKnz8lNYiHWouVescPdmWbIt52omhjTKIGsPh2hwBFnPhXXVdjReo3PrDN9yoZvC30wEXMEJ2e55rurXf5ezYrHjF2IyTYkdWlsqiNuEysNawxwzWEbCXD52pExYGAeDTTo7dfvZyL4sqHLioC4cSRGHysFaTYkyoPCN1rww6lzs0UTuJ9FQCJfxLvurZOI3dpQjrvqeCkGzbNFo57ykPHLa6DLTW4vxuF3Rn4b1jvhe+miKfvAwrMxEVbyR7Zq0W7zSIR53SOqxB4ohbbiyNmISP7wW/LF3y/X+5iForuMBd45BA1pGQmDXs93t+SZUhsY2kDqvOv0ALS4JgpbSu0zsh
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
fail due to an Xarray mismatch. There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead:
if that happened, something has broken the basic principle of how the
swap cache works, we should catch and fix that.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 mm/shmem.c | 42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4e27e8e5da3b..cc6a0007c7a6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1698,13 +1698,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
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
@@ -2082,7 +2082,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	new->swap = entry;
 
 	memcg1_swapin(entry, nr_pages);
-	shadow = get_shadow_from_swap_cache(entry);
+	shadow = swap_cache_get_shadow(entry);
 	if (shadow)
 		workingset_refault(new, shadow);
 	folio_add_lru(new);
@@ -2158,35 +2158,17 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
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
@@ -2220,7 +2202,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	if (!skip_swapcache)
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2459,7 +2441,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
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


