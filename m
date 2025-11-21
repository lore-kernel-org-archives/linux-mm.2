Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C74CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76ADE6B0008; Fri, 21 Nov 2025 15:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743016B000D; Fri, 21 Nov 2025 15:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6589A6B0032; Fri, 21 Nov 2025 15:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 521FE6B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:44:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05B0DBA759
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:44:58 +0000 (UTC)
X-FDA: 84135793476.20.0C27996
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37EF740018
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:44:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ljyVDtvp;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763757896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=G5wp9H+gkOwYhxrXttQvgTqcPoG+HfRTTZ0X5VV4ybQ=;
	b=nKBmZOe6mjwJZyiC62QxJVzkhXNhT+aty2Zq7C9SMwtROxZXKftS+ayjE0KWQfkMgrKzIJ
	C/YPQ5pWKGKB7QJVLVt5dbgSMOAVvj7vrD4NxvSD8wRUmYM5Mwv9rAs9yjMbLVURU34bcW
	0fDqVAM630dr0kChYuQGTGZysb2CdZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763757896; a=rsa-sha256;
	cv=none;
	b=6poBKd1A6ur2NgjApjeGIjot7w5Nhlua3F8IGYjZcYp8GTLJk/ZtKZFrhqiiUCqDQ7IRnP
	eJaeiRWcxeHLulJfAKQlm5+aN3azgWqTgbsYkPFQ9PPS07omjlbiHDqVfge2MvIuBAfnk7
	DQhPQGw6+uc0Hg3INYf/2WcHvhWio2g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ljyVDtvp;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78a6c7ac3caso26547637b3.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763757895; x=1764362695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G5wp9H+gkOwYhxrXttQvgTqcPoG+HfRTTZ0X5VV4ybQ=;
        b=ljyVDtvpbBJqOVXLTezHVGZ1AoDypZhnWi1Hv5nd+mqH3wZTQciUwuFUHcj0a4zI79
         7XFHhM4e2gHb+U7usy78fR0kqgJB59kcgtqCiN6Vn9Mm/1sxfVEbK5q/3QY6mHy+BzpX
         CRlQo0HYgEiRxkX4muhZESUeYARxMZVmDLf6rOlB8XfCPQukzcXMZ8cgN7L8tpkPFV9a
         geSCzckuvKmPa2jab87hxyOnWqdRuLXACIR+iKL2hHe1bIM4dH6rLyNT207YpqWaOKQh
         ICvklHCId1favQvh5gBPqsqqEfr2miSkctb3VnT0sN97ZIpG2OeVd6EXIP36rZ7BqZhd
         Jbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763757895; x=1764362695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5wp9H+gkOwYhxrXttQvgTqcPoG+HfRTTZ0X5VV4ybQ=;
        b=iT/7oKgQMcQftvLFkW1eub3FxBN79lTudGkPwvDs2+bbrz21qwZ24oI2MctaNieoMD
         F83UXGF35rGSfcYIb1CwHIMPuC4mu070Q21YdNLjAStGeaJ1OfOhkyXtbqXev7iWYWt+
         YIGeqX/ovUKsc4Ib1QvCmC6vY6ihcDEhAI3jLZOQoTD7Ptno9sM/s3y1QQLQQOsvPTBZ
         aSSbL0So0Vuql+PyB8YMdzYUt5uZG08+oSjyQgTkM/Aod5JnBawUk6IgMZlizvcda8Ui
         B6to8Nc8AI6umTqYGzibZbOaVtEBelWTAQ12sawTS0bhZcaJ4bYS4FQutpSKYIsbpVyz
         LLEw==
X-Forwarded-Encrypted: i=1; AJvYcCWMQ0RU8tjzovDAEcRPb/w+FmNb/HRkLSpdk9JhNnRr/DKRxvZ9C3Rb+2+iKHN+BGHLMp2/2htd6g==@kvack.org
X-Gm-Message-State: AOJu0YyMKvotXZxiufowg1LRqzpekJ9oFRvr5YoeL+xPqW1B+OTG8mES
	CmN9yy36x62EBiPp665RmFFciSU2lEpPgeI/J+Tlgel5UMdWiLzcDhnx
X-Gm-Gg: ASbGncsNHTDxw3FkzrRxJxJSWA+MYbVeC/1TBmXxH3YiuoI5ryFfdJo2JDtnZ3C8nsz
	ZthmMPMn1pI6QIM5uOzS61FcioD0EDk24bKu575b4Anx55XlngcByocKTTI/9xhCYyL5Zq2ewyE
	DRarvrOcxgG8X76O2l92wsyC7yxj5AEl9TdfcdtC/MDTn6DAyYs+nbE2ZgJW2+c8wXIi1rEub1I
	jkGh8YlUJrQSTuE1wGXN9BMvcF0JNBK4s6F02dpoNYpXxN/pz5YmSCh8jV23voAyz+hc8G0akTv
	QWcacC2OH87unGUzbAC8Qfa6mmRCDOExwQ0mOmDiXTAF0f+bzBqNsjdiS5wuKT6Aasfg+Mv6ttP
	NyVsxwR1gSrxsSjFMe3o4z8nBTISYinjKtX8SWsJ2rSaVowkqEzCGPIhS3oGi6cTkW0xOJdYsXT
	sUEEoGjGLOe4qEdmmdkowPOLk3wdplLm5r
X-Google-Smtp-Source: AGHT+IGaqIR7f+2H7xHmcO8kHAIXw+JiIkMTEiVL2GY29wSzV07+huW7wTcth/A1Zautr+buxa7Wqw==
X-Received: by 2002:a05:690e:848:b0:63f:b590:2e5 with SMTP id 956f58d0204a3-64302a7cb9emr1935211d50.22.1763757895163;
        Fri, 21 Nov 2025 12:44:55 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:71::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a7995a738sm18600027b3.57.2025.11.21.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 12:44:54 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH] mm/mm_init: Pull CONFIG_DEBUG_CHECK_PAGES out of CONFIG_DEBUG_VM
Date: Fri, 21 Nov 2025 12:44:52 -0800
Message-ID: <20251121204454.2090245-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37EF740018
X-Stat-Signature: qrxion9shrmjuymsp4wrcmr4fd7z8cay
X-Rspam-User: 
X-HE-Tag: 1763757896-829138
X-HE-Meta: U2FsdGVkX1+6KCjczF0biZO2oruuNUhHGj0UcgHxQ4QNAZTxb5ROf5CDbctSTXfPxIXrhcDwwKLHdEkL2dGqGSqKvK/4MuPrILJz+B20hcCMWVKnv6Dl1LKLDHgk7G1HGWuunmY7UrEWedCvfKAFDryIL6pSTjQX9aAsKO0VJtrNf2VtTdk2lyLKcZ+txJaNei2sTH9b7J8FFuww9ZwDcKtnNX//QS/xWR8MsZ6nI3xI21qdpVqP5Iwdod0hZ/0HTxQmcR0w3b1geF7rc/543w2KKZcYe5PvPuXgguVa73V7OAnwG5APS1XrwORJ6ZcaGiWm7hJKsJQNJHWLqfeijQoKRXkGhAscy/mcFnufbPny477/yheNSseAmV39xUcLhkkTJwJI2dezihrAGnYkXxU5E2DJpMYVaf9xRWT6Eao/B0aBAVVpyq7+H7kUgI6F4wiCyee3qbZFh1EP92U6CbS1QJPEpYHYTfhQ1G6tUb3ZqtDu7lXdZ+6qx3ppFxkImpX6cI5imL//vqhnkUqA4vSicY7nYP001UmRqVxKjCycO1pLiMhGqG4HLGFCM7WUS68gCR5DFITxHWYsSOLcEMBik2k3cFtrmEAXDdN3gjs3AUoCQX4CoNTEnqJDBRzguMCtlBeSYvx3H41KZuM+ZbiYikInPKi52ofuRF2e1OpwwDMLjHvVpHq2N5XIlDTKiLC2dQEIa6kxF+Yz1NVSei0IdV6WuMCMTiIFsuAkFDRJ3kiE1NXCBK09m5lTQHdUsEGN4LJioiuh5qO5eVxJmWgElauHWYxh8Z3pX9GMOUGtZOwFEuzsIfWanWmrpUJJdMpTof2+1UERnX7Wlq6yNMSE52xiNPOsifP3f4Wpl8fnpHTKaja+uxYHJzBfUb2Gzw/i8LpE09FhI1yk1SbYGikkQdVoCFkFnX6TexikaYSVuIzVYlnGgMooppbLF+gwb8Fley/PHWhiX9VCdDR
 /HYxxeTs
 YTwcr9ijPFlS7fgOUtiYgmgZ5e4MuAYSfUeCQpUtFpPnv2bH3s0RfNCWm5KSZcwa70dVMhhp4UXjjcs2U6VVQr76UE9PPtXukigODZg1Qohd3q+RUEHxk1RdoJE3SARlehrQWpSwKs3ERhOoPFDCk9pFvClx4VEiNla7owISS4kS6uBlsCwVDofpR5RE8TMPuLvgBtOeYDsslse+OkWcDLDKynitoiOxMXyIOMruWiKMN5G1XHgRLMw7GKzSYNUNMVMe+H1ekgkKRZhD0DiSWn0YX/91KuZr3FINANn3uPmexWa0VzoYBzUmBiTjiLifFGv8Svopr/HI/t0bSuZHO8r5eF3fgdZ8OD74l4uUFyJ6kTCvCcel4o/ZrGeSaUIQEIc2AZw0NzJVns0Jfeq0df/6IHFLvguYlBNmQkd3Bal2H3RDdAsrc3FUgRkuamE95xEr9GtZOgeJN+ZN/+pSDiE88/5UV1y9kiA0aurI1L7xb2nD3Rc4SCcHD64Czmm2LCrs7mm3lRagnH3mb8dwzv9FUxNlYPom0ertmefdDA2EkgKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use-after-free and double-free bugs can be very difficult to track down.
The kernel is good at tracking these and preventing bad pages from being
used/created through simple checks gated behind "check_pages_enabled".

Currently, the only ways to enable this flag is by building with
CONFIG_DEBUG_VM, or as a side effect of other checks such as
init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
These solutions are powerful, but may often be too coarse in balancing
the performance vs. safety that a user may want, particularly in
latency-sensitie production environments.

Introduce CONFIG_DEBUG_CHECK_PAGES, which sets is_check_pages_enabled
with no other side effects. Setting CONFIG_DEBUG_VM automatically
enables this as well as to have backwards compatibility.

Developed on top of 7f1dae318f81e508ef59835bc82bdf33e4cb1021 "mm: swap:
remove scan_swap_map_slots() references from comments" of mm-new.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/Kconfig.debug | 12 ++++++++++++
 mm/internal.h    |  2 +-
 mm/mm_init.c     |  8 ++++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..366abde25026 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -45,6 +45,18 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 	  Enable debug page memory allocations by default? This value
 	  can be overridden by debug_pagealloc=off|on.
 
+config DEBUG_CHECK_PAGES
+	bool "Debug VM page allocation/free sanity checks"
+	depends on DEBUG_KERNEL
+	default y if DEBUG_VM
+	help
+	  Enable sanity checking of pages after allocations / before freeing.
+	  This adds checks to catch double-frees, use-after-frees, and other
+	  sources of page corruption by inspecting page internals (flags,
+	  mapcount/refcount, memcg_data, etc.).
+
+	  This is automatically enabled if CONFIG_DEBUG_VM is set.
+
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EXPERT
diff --git a/mm/internal.h b/mm/internal.h
index 04c307ee33ae..b8decdfc0930 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -562,7 +562,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 extern char * const zone_names[MAX_NR_ZONES];
 
 /* perform sanity checks on struct pages being allocated or freed */
-DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_CHECK_PAGES, check_pages_enabled);
 
 extern int min_free_kbytes;
 extern int defrag_mode;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c6812b4dbb2e..7f47b22864dd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2523,7 +2523,7 @@ static int __init early_init_on_free(char *buf)
 }
 early_param("init_on_free", early_init_on_free);
 
-DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_CHECK_PAGES, check_pages_enabled);
 
 /*
  * Enable static keys related to various memory debugging and hardening options.
@@ -2588,10 +2588,10 @@ static void __init mem_debugging_and_hardening_init(void)
 
 	/*
 	 * Any page debugging or hardening option also enables sanity checking
-	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
-	 * enabled already.
+	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM or
+	 * CONFIG_DEBUG_CHECK_PAGES it's enabled already.
 	 */
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
+	if (!IS_ENABLED(CONFIG_DEBUG_CHECK_PAGES) && want_check_pages)
 		static_branch_enable(&check_pages_enabled);
 }
 

base-commit: 7f1dae318f81e508ef59835bc82bdf33e4cb1021
-- 
2.47.3

