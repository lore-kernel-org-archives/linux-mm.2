Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29664E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7EF6B0088; Fri, 19 Dec 2025 14:44:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7924A6B0092; Fri, 19 Dec 2025 14:44:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABAC6B0093; Fri, 19 Dec 2025 14:44:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58E5D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 245C513ABE7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:39 +0000 (UTC)
X-FDA: 84237247878.02.E516329
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F2F440007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Znxh9sQv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173477; a=rsa-sha256;
	cv=none;
	b=HLFPCYZ5TZZjqPi5P0Z9vl9P7BCVcx9Up26uPZu1/B4S/9oAOHjljDt9pKGkQC2jb0ZyL7
	VBTokD9PDAZ6s/Bgn4HWQRNS/anwWtGlawGDZebluv+ietBml5fBo1PPW9KdEto0VnQE1S
	XpqpHAZCiFiLSBOwXZpcJsFGgMvnC6U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Znxh9sQv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NNw4+sQJUy6FxM6FuaAbQJwTnt74msvVl4/Z/6MR8I=;
	b=Wn2hfZib/gXfgKUGsqon+mIQuiQE1rfNgFf6Xy4XngyHClPqCD1Zg9SYcEYAs31r6li3N0
	IxCXTCIsVdQl/8y9wwod6hYw95DhDWL/HdOKYaydxuduGxZV3obCqQiNLG7T6uzCWvHpVt
	gFDpn/s6ca+NryvTMeTpO8N3vqvDWLk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0bae9aca3so30002615ad.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173476; x=1766778276; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NNw4+sQJUy6FxM6FuaAbQJwTnt74msvVl4/Z/6MR8I=;
        b=Znxh9sQvtUjvth0hgceVqPziumwjEP+EBB1jUyjkCkbxL38yjUEIWQHxeRGm6s33zl
         PLlGvzzjdJiPRaxJ9ulnKbMYGEcUMJBMcugyAhWUVLR1AW5obYMmuFMk3cRCpgxOWG5r
         8mYBMS4uJ3gsuKmFUIa4rvRSDSbU5hz/F4cOxAwZtEtUsKdkoRx+Ojyqv1euhrs81+C6
         JF10tXAPEft000Siae1n0kfueh7rNoEt8OYBO74NTHqxAjol62QpUNEwgs0jnOFF2Mwm
         H7wFPcvitbCC8Ij7LkrapLNfAA2q+z+8bBYJB1n3edwu+6LTKaxKk2nQocOO1zh5zHSc
         Tysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173476; x=1766778276;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6NNw4+sQJUy6FxM6FuaAbQJwTnt74msvVl4/Z/6MR8I=;
        b=nJQKn6GY7TQ5naJr6bRq39OmQ7eJrVBpzXsnUW8NY3GgaZFWhygrQlsD+o5NfPl6VQ
         MDj5rhCO3BhFa12DkqBrlkyeDdPGfN+G4Ku3TMXy38iy0/oZcMtl+pGkoWXGkVP/sml5
         tbmltAQBaK+oj1Uw/8tiVLjh8560b61w8d5VjMUFovSz95g7TI3DYr4ApsTzXNGSP5t+
         LOErnJT648t36P33kaQSCouMaVdD1eRUdDbjeLgPxaoBeZpxBNBpUHF26I8Q0h/TLhLN
         wN+euIVhGIJ0F76fACsgF1fwdgWuMTFAwKbtxFLOn/Zu0dZ47UROfq2IB0qjY8KahU+w
         dNeA==
X-Gm-Message-State: AOJu0YzZkpiea9ZBxq/2yad8bjkszxmQHHw7yD2tJEu+hD4d04DJgVP8
	zujD/d3J5gaHGCxVs1c+mh5O11lgKlCK1WpN6lyO8D2rV3SW/lkWcab5
X-Gm-Gg: AY/fxX5Gr6ytn/VoQhcqOmp0RZOlKSpNgw6l9+s1yVqUouaQPgAWEofpCIeEIdrxmMN
	A5BmnWaFNPMUReTfF3L6UVsd1fcuhws3GMBOm6dQaoX5u4FqYDUKW9MxV15o9d23qCoMAeCZGRD
	tCYi51x6pQIvpZ3mnAyvoLKxfOgVgXverj0unfTIr7odGjr62Ohkx5O+6F3XDxH4uqV/ca/ewQc
	pfGSZ6zeMqiu01rDjNqdhG3OQYMMF00JRp1Cek5BYx/ZDOx6zGc9ZxM9am9zom5djvMdsWRpaUL
	mz+gEkh7mJ+soFnXcgank8cB+jG+/3JGpEvh20tMzSnI3yIQ91e8/uTVnjFPbdsUOzw/piWU1WS
	c/QRpsS9812IozANeElLj5lo90xyFxfGRpT5p7LEbdnlGSQ7ZN3q7ieixUlOc4gvLg0skykmRzA
	61MvB19+9uaXA+fbcnN4Xle25JUVq2/n0rXVIVy8YSK3eX1LybX7aq
X-Google-Smtp-Source: AGHT+IEr+/1945zEk9Px6JXX2rL02mT5MvIoMEZ8htEYgKPpP4r46YR5Xun01SYV0wEmq0Q8Ko+l8Q==
X-Received: by 2002:a17:902:e847:b0:297:f2f1:6711 with SMTP id d9443c01a7336-2a2f2a4a39bmr39141335ad.56.1766173475908;
        Fri, 19 Dec 2025 11:44:35 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:35 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:33 +0800
Subject: [PATCH v5 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-4-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=3125;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=wbdKOMibaBwyIgmlPxN8UtIMUziDUOOWTYBMRYu4e/E=;
 b=eXcqEZFNRxR2JEG8FVKf7rUS7y3LiCM9aj7WW7itUSsaEJbdRHEPX2jqg7xRwE4VRDRq+9Gcg
 x+3noyQuBwHDUVTvk8IBJ1ogPI7uex41kCJqTvbOJKuyICojksDxhAK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F2F440007
X-Stat-Signature: y3rfx3tpc1f3i54t9q18w6pdyjn1azrp
X-Rspam-User: 
X-HE-Tag: 1766173476-376660
X-HE-Meta: U2FsdGVkX18yyVRHs5qhkzgAvbWOmrMqdfmrWc8GUQO/ajmOLTEap0Y7CQUdtBw2+cZas+/QiO7V4vyWKRI1FkiLPiBce0PBYMrSeJKhTBFAfadYfWJ768ZDF1d+xcPWpR7TLY8NZ2oMsonBwTQ4CHTSyTEN85T7/FGxwx7p8LhxP331IAVTSJ4bXMpkkY4NXmxo2pP/O+PHh/Wjm20a2UyifsX4LPyI+hN/Kj1rBoucQiMg6kH185Pcu6cKvxUTL6WycSVyo0CjHa8zugBTr+bGBWxd4iqi9+jNjvuWzgyY+faC654hPf0it2/+jXHQlezvcYZaBhfwgN/bDnEBsspcjoCcpUZljdgCf1uPGRbajJv9Edwc9zmCfKDr3hV5SnizxE18TyGlbx/3+E4G6x9ZJAnBr+O95O9vFBpIalHTmAR1zdLMyeOpwcjmOKU2/urYTt1YbEux1aV5xO9YpIybq5GeyqkZ/ZpK5Xxisg26qZ6knam6BNEdNN+vLap2gbY7w7Hy6sMjaUVOLJSTium74aHBLNggK9yXMdsXiK8l/lQJzfKxyH2O31vMgmtTYiQK3nKgOjWwvhcGuU8JLn2vg5BzGUd5JCkhBRVUqYGyV1q8NPojABvnm7UahyB//93VFh4+eW2uv6e0vei8FuDc7W14plQX160odeAgQdvwMLnSM1xmMhf1YE1JUJiVg9d52AkLQSifYW9eMssC2vR7/TGoaKkHGp2WCnlROtBQLfS4hZwGjfJM7TR+DEg4ikveHVrrPBoBWvOK/fHDa0bfJOtczVVDmb1ZG1BrHop7V9EP8Cb6WY+CekyNEiYvro38F32jR8SfqWmBrc2pVfUvHAf1hG7BychM/XOYzQ+W10aS0g7ZEMfo9/QdqKCneud021a2XIZCmPRiDpLEvvMFT1cG5+up1TWDqjX8wcnDnEpew64XNMCM6jEDNypGeQMDoifARgktIYhcEC7
 V6+BS8mL
 uBKydemtUTffj7D5IMXUz7iza2Zki2h0IIGhrEy/AXt3b/xX+Ch/Elp3JVM+WIvBv8fke/sFRF9M3wJAXy+A7ISSS6/XbADt9i1C/vrWViPG3Jay+Zs86UA++5Rdc99AzDPT3hGIfzWiwN1nnlt/jLIx2+VYIVkhUeE6FQOpUbQLLsFYU9fB1DcglXkGehUZEUX6h/tSUHJEwwANAFYM+xtq9CCHTdR1R0xw9lwTS/jcX9OH7WcGWuQurhSwWsCXMwR/kMjuVBi25moFZpwQeElYC9ZGCIIMGDEf9vtAEVRUKFnfVcI6AXfjigRMl+UP9iZAJCmiwAh9IuzZSXcTvMYyFiRj3btuY356s+IAcBWiXNfbO3UxNfM4E3E+ER1kBXZGaZGbEN4Mfpwao6pNcmN5qHPn+oR+bSzzmf1y/6vgdLZRxj++zwq6DOEMLiIlA/EjuRLLCFnIA0YgnKVgRRKTE23f/MqXzsXTnZCibCr4qHYQfEn6ou8PBKno1ugIhq4hg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
effect is that a folio may stay in swap cache for a longer time due to
lazy freeing (vm_swap_full()). This can help save some CPU / IO if folios
are being swapped out very frequently right after swapin, hence improving
the performance. But the long pinning of swap slots also increases the
fragmentation rate of the swap device significantly, and currently,
all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
causes the backing memory to be pinned, increasing the memory pressure.

So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices after
swapin finishes. Swap cache has served its role as a synchronization
layer to prevent any parallel swap-in from wasting CPU or memory
allocation, and the redundant IO is not a major concern for
SWP_SYNCHRONOUS_IO devices.

Worth noting, without this patch, this series so far can provide a ~30%
performance gain for certain workloads like MySQL or kernel compilation,
but causes significant regression or OOM when under extreme global
pressure. With this patch, we still have a nice performance gain for
most workloads, and without introducing any observable regressions. This
is a hint that further optimization can be done based on the new unified
swapin with swap cache, but for now, just keep the behaviour consistent
with before.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3d6ab2689b5e..9e391a283946 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4354,12 +4354,26 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	return 0;
 }
 
-static inline bool should_try_to_free_swap(struct folio *folio,
+/*
+ * Check if we should call folio_free_swap to free the swap cache.
+ * folio_free_swap only frees the swap cache to release the slot if swap
+ * count is zero, so we don't need to check the swap count here.
+ */
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
 					   struct vm_area_struct *vma,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
 		return false;
+	/*
+	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * cache can help save some IO or memory overhead, but these devices
+	 * are fast, and meanwhile, swap cache pinning the slot deferring the
+	 * release of metadata or fragmentation is a more critical issue.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4931,7 +4945,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);

-- 
2.52.0


