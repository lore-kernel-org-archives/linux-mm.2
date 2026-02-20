Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527BDC5AD58
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AE16B008C; Fri, 20 Feb 2026 14:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CCB6B0093; Fri, 20 Feb 2026 14:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BCA6B008C; Fri, 20 Feb 2026 14:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 405BB6B008C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:10:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1A305837D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:40 +0000 (UTC)
X-FDA: 84465776640.17.A7982B2
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27A59100015
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Of67YNWJ;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771614639; a=rsa-sha256;
	cv=none;
	b=r8zqzuYjKpbtMEpBvX08hlRsCAA+7l0owt6ik/EuBVrTUfDPP6F7aF85+0PBGuqsRRwpx7
	0McSCV2O5/S/5RKOJrQuW/NpKyArV8DfRkmSp6CnMGgXBHuMBiecfe1Y/mmBXfqjMe9LvV
	2cKiwB1eQr3opDO2r//nm216LPiS+34=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Of67YNWJ;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRgCQhFlEEQQz8iVKpR/+XrwMVRXcKNbXIMlR69ixQE=;
	b=h86w5xxN+DxCZvOXDuCfP8Q0vKZ9Fkc2C15x2Ja0G7VSzdtxbVCZnWibYEZKR5VUExkmbW
	z1yJ0bnRc1CXJiPwkE6GkzH6vFAOR+fmhbVJ/LfUYGTZHlQ/12UHCm5YS/7EgYvAwfMGA8
	ksrlmzsiTYNcBqEtm4NjEK/yrXSNn4g=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8947e17968eso27244256d6.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771614638; x=1772219438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRgCQhFlEEQQz8iVKpR/+XrwMVRXcKNbXIMlR69ixQE=;
        b=Of67YNWJ9kj2sSkIsa0fcyy3sqv2QLveyCX+oc1OLytD4TdgrM1+I4C53Dz4n2A2kK
         0I/UmDUO6LzgYvHKRQDTk8YZ7+xHHSHrZKAGfmGJIGyWJd3F89eLkijLVrh/s2oJ1j74
         guTIbLofAF8bo2aQBWAY+3KzZNh7PG4BQX4+lpzqytRW/HJIZdPHhJLgT13M5DwRINSZ
         1/83Va3qMQBo0x9de7ILeqO8LrWVOIwg+WS9q4hmRp1yYfvrXlHb+adr6g84hpKqSZ1v
         PngYCPhaJ2qlWwq7Na4Q56sgMCLwZRLNP8dnwRFUpc2+8krqM2Lv8a0lahj/JBo/4o/u
         YRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614638; x=1772219438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zRgCQhFlEEQQz8iVKpR/+XrwMVRXcKNbXIMlR69ixQE=;
        b=SOlrrofOM2Glrc9yOhn7wU58wFlXL/02HnyIqJoc81DXNSL6tiFszJKoVWO/uFkpAj
         1pwShyzhp7OH3bZ+84r+8DZaIF3ALxvQPKiqaUgtmaNpXrR0zfbeq3J/7drqUYaZTYQz
         RTIhAOEW/UyD985t3C6W7f2ac2VXZGQk7VpwHd0l2cku31n3NkBUQ3oAYYCKM7w0V4QO
         iXolU+FsHWsmUtDGzBM2j6R1oZJiRndiT0S7UFxa+xHLD59m78dGlTA3xxA3V6LUjyNC
         o4WhH3x2ooReaejAh6BfenVKrpHhc7Xuq+Pe+1Ul75MI4JTpH5Q4Z2FFTNDNlJFRTJUu
         sSfg==
X-Forwarded-Encrypted: i=1; AJvYcCWd31coxjNk1Qw0+/FQkHWM0eijUEOFC2tP7yRWcuoXeyi1JE6i33wM2bMmfJo6zGunkGDZ2KiQSQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9FnpwVluNOi/9VVLD71lwLyjzcQpcpOID+3KaXnkRJjUWPD4S
	X89aP+P53TjEqY047lbvaGtdR8tsrPzva2F6labeksUVsFBJygsMlCItJtIx90y2/JJbDmjJCec
	ThXL6
X-Gm-Gg: AZuq6aLqHkcJ7/icp5pa2KI1/wz0ZB7ag+jLxWLpWY3uI7G5IhbmLG37aIxDW+Taf/5
	ev+ywiWIx7HtdVv1QyBTi72MPs4cwuEwEc7Wm+JZqcx0kxpdzVZLuloUrjXam1FEpP8/Px3QXn9
	qHaU/HKfrXK+S/1LBcFK+iVE83iuGmV9O9cQnzsYQxcaYJ9SmceAy1hyp3ErGgMpUM0L59BTRfa
	h2kMaPAG+MSp5tDqnJnO90aXSrMZM1LUHOS8cfAQ0kxYVz2TpqmC7HlN7xR+74Hgo6cY1xABor3
	jEvmWZt2xYbdKa6/7AYh3RDD6LNjifSBl2PTJfdw6K+TI3iQvYEHvqpBtVzXfYB6RZgIFMf7ET7
	0mrqNj+L71Au8iCPgMZVUsJ8uW9FTWZJeaXzT55oy0lcvq11VD4qFCmVBNWcbvc5hE5SDHXNz7K
	DiAqMFn6EUF5i2Rqy+lPx/Mw==
X-Received: by 2002:ad4:5c6e:0:b0:894:562d:c0b9 with SMTP id 6a1803df08f44-89979d45c79mr15844316d6.0.1771614638028;
        Fri, 20 Feb 2026 11:10:38 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d1013fesm18977785a.36.2026.02.20.11.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 11:10:37 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: memcontrol: switch to native NR_VMALLOC vmstat counter
Date: Fri, 20 Feb 2026 14:10:35 -0500
Message-ID: <20260220191035.3703800-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260220191035.3703800-1-hannes@cmpxchg.org>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27A59100015
X-Stat-Signature: enwe4yubsbn8kwq76fkfsjf69berfqyb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771614638-340767
X-HE-Meta: U2FsdGVkX180XbGLQgoleCTsuh6FM4OtKIGMCDKlVP/I0z4j6V+ws2WuwrgJageD2EB+UzvN5LpX+X6eVQJ0rnSmWMcKQNwzjRfHeqTXlOT/Z97JBW/+9wX2VsXGtO0FOlzmPf0JdzfrbnlwxTbt6FWqVxE7SPPb+6UV959VuQD7I/ixEeU2mBk1EG9Y+cubVwdl927piHK14GVeLYx97+OEANLkAr0imfls33jqnXCdkRPil221YED1zYjw/Q/0lefgle7I+hwUFbOkNped2NMNkXa7R76FgioK8vY0rW2nBcpnqBfi4xgDPpbL/jVpRO4AT0/SEPWU6hnoBHg9i5MJD6jd+talu/HfGjEaB6uizTZLDalJ9boC7Gr9DIMG9WKvmG8xiDUu0F9NU0RuUJacV0DXsFPkZer/aEx2Jc7GyyKnFkrWNk9e6hoa6tmWsphJO2dR2CmkFiEqpYgaYy75wmDpD1KPRK5v3jytxnGgCv/z51VLw8EZ+TvRlBnIi+edNpviWFohnaax5tBLtQIZJyVVb0cN1EjCgcVmOe7xVdnLjPl7fOtfC34SViGf6dlKrgJmbf1qKCvNv9iK/1HX3Y5oekq9AB2Wyc39B5XiSfS8Y5DK3AmLOpt5QzVYvF6ricxYsO8XfO83UyxqAUq6AxhoYeWZyM8NetRQybaMiOufZxj7YdtZ9m8jvgeiTGZV6Xeoa+LL3IiKpyDhUmWSwfqbCJNYIdnC6Sok6ECcSoDU+gizSumSLMJ7ZBuLYvEv8TG7VODePYMADTHuLIxzgociogkeYALGF5TVAFZJ+Zpwhc7estlFLkkkm/FnDuBxcsI8+P/FfX8e8HNXIYIMtuGWW1oxdnLTWo709h20f10nw/SOLsu5Tgezu2zLY5hBGMlb5FxMrmSFjkzjgt4p7bI315OIa9D48KRlGmU5OgXkSLK1rvINPFWkOMofwlpJ70fSjTzIj2HL4dw
 bflQFs+i
 vZ8CFVWTn9QOG2cUgMuej4mABn57mvsqivi+zYnFRjkKiQ1Bix8c7og6nyBQIwEoJeqGmqRCTkRAsi8n9aaLTXLB204mFFMqG5OGg4P7gB4OLwhsWZ4pWGK5pZ/jgDMaKPH5iVUip6/O1zBZIswZHz/swUmF4QKenfbOeVEeXRYVG1iFEtvfAHFxuv9R+gjkdEcBptky+xq+urrOItRPRda615YRZgqRx2VJQPLrphaqfwL+Y16tvXs0Hmhk755FpOUN3ekqCjz0qOVCkl8RP8DjS0tzRSp7jHt0fARCpbtXoDaIm5FCNp59wwOYWAiexlyxu0l53sHTQidW/8qzGMe7O0OWFzESdkLCdgvVG7Cis4wDxhiFKN+UpHelToTd2J6s2HEdHO66ZHvbFQ3hCnpzQqiOTXz3Ts8aFmGIfLDn0hpaXTNAoR+yJdpFzXZUFEi7w58Z//9tg0kY5Rq8/x4VIg1eyX7P4efLBRUXGCIk6bNeV1ROhq3tCMITI2EFJ+o8G0p+HEFAz0wT5ucEQ6x4eo5+7drwgELW6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eliminates the custom memcg counter and results in a single,
consolidated accounting call in vmalloc code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h |  1 -
 mm/memcontrol.c            |  4 ++--
 mm/vmalloc.c               | 16 ++++------------
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 67f154de10bc..c7cc4e50e59a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -35,7 +35,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 129eed3ff5bb..fef5bdd887e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -317,6 +317,7 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_SHMEM_THPS,
 	NR_FILE_THPS,
 	NR_ANON_THPS,
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,
 	NR_PAGETABLE,
 	NR_SECONDARY_PAGETABLE,
@@ -339,7 +340,6 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -1359,7 +1359,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
-	{ "vmalloc",			MEMCG_VMALLOC			},
+	{ "vmalloc",			NR_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a49a46de9c4f..8773bc0c4734 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3446,9 +3446,6 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
-		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
@@ -3458,7 +3455,7 @@ void vfree(const void *addr)
 		 * can be freed as an array of order-0 allocations
 		 */
 		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			dec_node_page_state(page, NR_VMALLOC);
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
 		__free_page(page);
 		cond_resched();
 	}
@@ -3649,7 +3646,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			continue;
 		}
 
-		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << large_order);
 
 		split_page(page, large_order);
 		for (i = 0; i < (1U << large_order); i++)
@@ -3696,7 +3693,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			for (i = nr_allocated; i < nr_allocated + nr; i++)
-				inc_node_page_state(pages[i], NR_VMALLOC);
+				mod_lruvec_page_state(pages[i], NR_VMALLOC, 1);
 
 			nr_allocated += nr;
 
@@ -3722,7 +3719,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		if (unlikely(!page))
 			break;
 
-		mod_node_page_state(page, NR_VMALLOC, 1 << order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << order);
 
 		/*
 		 * High-order allocations must be able to be treated as
@@ -3866,11 +3863,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
 			page_order, nr_small_pages, area->pages);
 
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
-		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
-				     area->nr_pages);
-
 	/*
 	 * If not enough pages were obtained to accomplish an
 	 * allocation request, free them via vfree() if any.
-- 
2.53.0


