Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD77CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD438E0023; Mon,  6 Oct 2025 16:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36D58E0002; Mon,  6 Oct 2025 16:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BCE8E0023; Mon,  6 Oct 2025 16:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 652B48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:03:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C4645A424
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:20 +0000 (UTC)
X-FDA: 83968763760.11.C19AFF7
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4CF5BC000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/XHv4Re";
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOUsOsGJd3wfEZwhNSB4DJHpM3wcqaShHziJPPLEM9s=;
	b=zSNhsskdUNSG4uYEbPLc4nxKWt4+swYP5sd0jE/oOivlpW3VxsAVm6f66+Nliw/H31WH3Q
	Iv22kRnxwIA0mGN3eY7BoCiuBn4IgS+KDur+lqRk6QfEP/8oFvgi/CQ1hDzd/1wZatK8zI
	0Jt/Gz1IYn0aLoQGJ2qu7YyNDfvenCw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/XHv4Re";
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780998; a=rsa-sha256;
	cv=none;
	b=PrMRfdO+o0sBARbLX5E//gwYQ8TTmQmDeqovWiczGL4I23rRLigtwrdz0R6vuBD6YTvFeo
	tkwhFqKr937KThgM2FXPRczc+WFgfhxK5U/9d/EpUM34CRe7lGUail5QRMCMcoIMmeZ8Nw
	SqqJQOhbPbNtkmvc05/fgII/1cG3R4E=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32eb76b9039so7078812a91.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759780997; x=1760385797; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOUsOsGJd3wfEZwhNSB4DJHpM3wcqaShHziJPPLEM9s=;
        b=l/XHv4ReuwMRBbb/zcVLUfCmvQ/XWIznT2uBaKvErZUVc0tz9dF8GEb4jT07TTMAsC
         4Cs1x4X0GQFkR+PviGnogqk1dPuWVv5gOLQFSVC7Jeojz94RpZ+b5wJZApp8hJhgsads
         hJlgnb7SNKhhaCA/2KEwPL4VcZNJtL8IEIaJ4ZzBQyXuPZ9svn1ycZ/VxwUpiTHEHpho
         E1bqb6ZvPuXvjYd3xTSQYCmzB/yGDivG7Q9QUHLFThomqSBpaKrsiazU9NRBq6AMOeLi
         UitTDVIal8fcj3foJbTcGh/5Uesw5c0D5FnhMfzMkeOODVjuqOBttjbPq0qGZ/wGJGLJ
         N+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780997; x=1760385797;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JOUsOsGJd3wfEZwhNSB4DJHpM3wcqaShHziJPPLEM9s=;
        b=YojNSNVZcsMfiZcCdLIjSNLYBDEAxT0TzTzvkD9WTMPbUYSTDXGrD3MKRYwtjAkFCq
         l162MonmZgj+GbO2ZP0GDR9VI7V93EN3E9Lsgr9wCg3jdX3mxYFD0t20rEtQ/Myfk5wu
         cT+WDoFc06P7eY2emYd7tco2Pk/K7RILdfdkCIrzyiFuQB647mNX4XI2neC0IirEEJx+
         bC6/aojThPotQQHpRKI+YTxcqTA+ljPBFKRLVbM4t53ntlBJQj3ohQwIgao3DXN5j0fs
         1AWk1++AXH7oCNKl4Qi81JqNsCJ1rTQCkfLltsasM4e44HPEGZmaReyHnl6U/jeYtf0s
         r/MQ==
X-Gm-Message-State: AOJu0YypNW7h77dK08QQfx/4kPOUTulRCpdDJTn670j1UvojOEHrLgR2
	HBbDPT2mGgjfHCRd8stRmLmZiKfOMagzyyOsBf154t3TuHv74jOY0Mw7GG7V3SlY
X-Gm-Gg: ASbGncuSDB10VbV8nnkWgsI8wAwUVTDc/7KLrOfQk9WCbRWuqrJ8blsiFR6q6hG8bSF
	+yrtGEdyGEhKw6H2YbPimOZ9npSJ1IuAo8/a/LzyP6t+Guj8sGedb5mfiBxgZvMkm3XcYMjtEIC
	VmrkxxCp0ahvyeOdQ2J0AMxoojkxQO/fpYjqezEqT25XVhjZsUH9G/27jVGAI20hGRHK8gBFxPq
	J0lRyR3t/LBX09v4/vbUVbBOx4/Y6tTSoz9s8WoaU874tekoZBydyPcYcrJc43PxPRjhlJ37zQu
	7yyZmI3zrUNsCN8qmOGPVxnDKkGCwQOUunOX9Vg1W/w1o0pMYBfmOKSOKkJZdp6woZi9s3kbsCL
	oYFdtXy2aEFJbDVvQD4hmvcvrTeXm7b1FX82uFAv0VpRrsLb5DDE+GF+Em5tR9qo=
X-Google-Smtp-Source: AGHT+IGtlcgIQ18cOW4NX8p8Ae8A6QlZc0kl78+mT+F6McwCAq86Egqg4BpOisoBrQ9R2ia0C29Faw==
X-Received: by 2002:a17:90b:1d10:b0:332:793e:c2d1 with SMTP id 98e67ed59e1d1-339c27d7865mr16524955a91.36.1759780996556;
        Mon, 06 Oct 2025 13:03:16 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee0ba20asm163148a91.4.2025.10.06.13.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:03:16 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 07 Oct 2025 04:02:35 +0800
Subject: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Stat-Signature: 8iaxdz3iindnurf5smzgqciw7khww48e
X-Rspamd-Queue-Id: 4CF5BC000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759780998-434650
X-HE-Meta: U2FsdGVkX1/p4CjTGWOL3HO/6hRNTAEsb/dRpYirbzfLr23TfNoLZAQ6AltfGtpZdWn/orfaixzq888zf2Tbv46PAIG+tTpKW2UKJ2K66f8Y3/UWocGdk9nbglfNC+SW+1TLoBCgymom8ix3I8IPFvnGv5hFh7pUYsDgIKPXWfzQLW88LQk3cOrvcOLlIty9qG2bK0p31z+bnC5mXCbNqL2cxbryjw3s28yaeGjR6E7n/bBMBs7Ir+xG3rXNMRC7kyHeliKeLwdAyen7h/Io80V+YyvwNC232LuUlgy301XMmPXkqLrFTZ//lg4wqUG7ZHpwZhlTTfdVqu96LErEvTMEhDrriiMcOeC6goVih/AMRgE7kzzmjfYbS4sB+uCopkBJqBgKFi/TekioJ4AZ86dtwpHE5ULH+o6FZh+LEk8z72V9gWpPbzM67d7MMnOgzwGQgpwbjaYv3itsOIL9kfHLtjQ6Se9gnF+OiNG2PSP3wdsZOaFy04pewxtKz+OsanXJD0lrnTR0xScRZe6tccI0IPv28Tut5mznIaNjAnWxxuU83i+KEZ5XO8E3g4ZroPJGYEgaV3Ag09sLR+3JPBN4GuaIs5pyjFzalYoxcoftu2xoQLZlT7MIOjeQ61QB5xgNEkHwU4jlRmJvTz9V7ou2WNJZp1kzeOlwCRhpiSSDMeoE1/NGtuKp3uqvlIGI5kYgLVPpCZU+PUY/bCztxIcWxvvbwxfXGgnvUfB9QdeiSls23PhhodnCjZM/TsN4JfczPaqr72Df/e/QTDVkn8hNaWusCjjH/fExBixSMWdjogCO7UxoCIUTHVuzRbeQxYOZsGeThdyqJEp1eAsNs3kn73QakXRMmz+mnLK91x8p5BovaTv2pD6mJoQXksWicQqPcsfIG6qTBkoqJPjjx/L2yNrFpGTghwhbF+JzJF4QsIue4xzfsf9PM83g7i7HBAxObDewTAT/vUdL4FV
 aOSrputi
 IzRook2AmEE2j7vZjzqfPqzl/okEVQUKZLrZT7ZKoFkO7fcDa2TcaM0PQ/qIC9Bmm2h6tGX6LB/wXcE9w/CTdxZRBAIrVBOS0b1eIOSnPrOiLD8bAEvckQhJMGvPWfVB+9mPXX0FfZgK+UhaU8Tc9wRMsdx/zvdRS8EGn7l9WGEPWDzZhZMuGpNxUFBrlrugeKzJrP/DOOpWMrf3dHvkXA9e750tRksA+yjDj6RL7MK02uLix4KwWM687YACsbTf6yObwFtTQGg3EepjWmbK+iJMb9of8ffO/nemVSWKp+QSaI6dVIqBZPMHHJmSXYtYRYZVJcBblcJ/Hc6SzuwaAyk78nQV9nobiGNzTne0PzZ9zKSsjU9fnOmb99MpkOR5QV8Op3XKoWSQdQriMpfSSfozkrGZelxtPOlKvidi723jwH/6WcyIGz5ZgHJsGR6aLWJSklquGtWBmjtFYkghtlaw+0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap:
use the swap table for the swap cache and switch API"). Before that
commit the GFP parameter is already almost identical for all callers, so
nothing changed by that commit. Swap table just moved the GFP to lower
layer and make it more defined and changes depend on atomic or sleep
allocation.

Now this parameter is no longer used, just remove it. No behavior
change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 4 ++--
 mm/shmem.c           | 2 +-
 mm/swapfile.c        | 2 +-
 mm/vmscan.c          | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index e818fbade1e2..a4b264817735 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
+int folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entry_t entry)
 	return 0;
 }
 
-static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
+static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 45f51745ad88..63092cc0b141 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1617,7 +1617,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 732e07c70ce9..534b21aeef5a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
  * Context: Caller needs to hold the folio lock.
  * Return: Whether the folio was added to the swap cache.
  */
-int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index aadbee50a851..c99f7d6d5dd9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1296,7 +1296,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
-				if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN)) {
+				if (folio_alloc_swap(folio)) {
 					int __maybe_unused order = folio_order(folio);
 
 					if (!folio_test_large(folio))
@@ -1312,7 +1312,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					}
 #endif
 					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN))
+					if (folio_alloc_swap(folio))
 						goto activate_locked_split;
 				}
 				/*

-- 
2.51.0


