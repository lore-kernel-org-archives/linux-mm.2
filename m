Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073DC60A2618
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=RXQd8DV1
Received: by kanga.kvack.org (Postfix)
	id 8D64F6B05B0; Tue, 27 Oct 2026 00:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860366B05B5; Tue, 27 Oct 2026 00:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74ED46B05B6; Tue, 27 Oct 2026 00:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9526B05B0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC674A8430
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:23 +0000 (UTC)
X-FDA: 85367109366.11.A7CB5C4
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C1C11A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RXQd8DV1;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYR0kjWyeHwovzI94J0HLudxjoqlHJ5bLaQ4w5OVpbo=;
	b=R7R7o6M8t8/MOsSMhIFfhnwZP1Z9vOhqZjLdOvZMmdKNRst+rrqePmwr7G7dPx+feB+pnU
	oJpkJN6qubj9tarjQgIsb/6kP8nOwLYiLbp0KMEmsSc9SJOotH2TrS3hn5MBjmX+HZiiZp
	ghR8AdGUIzi00kX8CJUnkz5oG0q3mRA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RXQd8DV1;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074942;
	b=LIAxkM2qvsDwF7fDpAjvzoGpNpzvWdf4QNC4gHBBmW7AHUNIuYsNL5R8G/Mb0v9S+DFptw
	t7mV/hQhHRTWRuqXTJNpMRBG3nVMkc0XVqPgGxBALftdLAmA0Ku1Vb6wGRtNyA2AME7yTj
	pHrKx5bEGOYnVA4gRh2cQQ3/ONKPyiY=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2f2edb19so333763385a.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074941; x=1793679741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JYR0kjWyeHwovzI94J0HLudxjoqlHJ5bLaQ4w5OVpbo=;
        b=RXQd8DV1IBL6PJL3zmNXmRETuNR0L/aeoluZnKF40lILSR7rC2Tic3YHgntPMQvw9E
         Z8lUtafy3HzXIkyeRMgPOsLyUexRFBTxHQUx1WVFGlMDHxld9zgemGYxR8GHjjEXP+BH
         Tdkgt7QEPkQu5VlWUXDFR4vsMYMMkMHOeLOHIpomJ0ML+uBon4AFZmemOMD+NfT031IE
         Xes7UWaJF9PW2NkqBPYCPDXbUMU0hUXDtf4+VylgXwb5DOXegNdnb4vZoa04Uhzrejh6
         j6RmcHoHA6Kfr8F6xhtg3qRo+s0Ih9wph2lrC00nfmr/orerTZasLXHSgE6BzLgBcVAB
         GtvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074941; x=1793679741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JYR0kjWyeHwovzI94J0HLudxjoqlHJ5bLaQ4w5OVpbo=;
        b=LeDvBVvy9+0b/+XZpR82iNDhKof1GIREUMcoHvuh0JDpI2juv6Jdv+ob6tWpjohPth
         hYyMQo1pDogZjRm3ljAHXlzNmpB+q+S0y+uDROcgbw0pl7r7eGq60F1h5SecjH8HJ6ks
         JdAAm4oTn+20qSaEClc4zBJJ2/vAVKVsw4TW/gIwflMNA/IERko/WV9DoNNoL/DmKbQ8
         s4+ivuuRW6qm95+3UMlH60Zyjgd9cg4Oh2usXzKfk1cLznJrlqXZTCY0IpvRINAnRCPt
         udYLeEAwYp9oqrfdXwlFDKXZzvSStEK1zJGIaUQNxYbnXevLAEi13WXV4x0PA9qb+wva
         pRcQ==
X-Gm-Message-State: AFq9FYIV/XZfwi0+amM5SBsS4a44e/5dufOp3FgVf3jqaPw7gKl+L7TK
	ikKhM1m9WmsoYWk9ZhFHRv8RwKtPAX0bEEbpa/HFqwSMRaqynD9spYXuWOpeVNOKuC1O5VXEAuj
	2wHzJxQA=
X-Gm-Gg: AYBFou27035ERda3sVW+nHTLigQ3fHsE5QZdzlpD3nnfT5pWqMnz0F9+NK/IKv/C0iO
	N2EY4PXec02MWIP0Juz0n3ncbqYE6LCrBwOOXA4UmoiIVd4UAkb8RPDqBYYS5q3uljhm8g3+GKl
	UUMMsuKvnz11P0aAZMnsg/TdCc67/6GoLVnK+AuUQmUo+0h85Q0bTV/yzs841NcriapdXeni1mI
	psLv2U99Ieesptzs9NmuMjhdo8dFu4bLcE0Lmc2YkeEND9pv8rwkdej3SRmdi0LHKrR8+MTKySM
	kgVBSdfaMQgYdMT5YmUbyw4RSxuupdvJWC+pzYyAgxskAb6ZYd+sSZeijN9q4X/N0Mdb2IqW+OU
	VW2m2YdqL+Tq6BejYHPdX3+ElICe1/5vWe9qYjBxbdqeNbdrkskVlc4N8r1SCWgIsz+t+SaXHWO
	n4tSDQBT1ATGUmeD7yzIQVffPCwGXAAC14MLwRPeA6Jwys8XAD9NQa4yWel1PwFCFw8cy52v744
	7yb3WgjHUZ3BBHYKpQ19EOYqAMjAvNsi5PVrWH+BMnN8495N/gX+rJSdnYq9khBU4Qmy4s/8aYV
	kTd0yJsCb4ke/AmQgS3p0NHg4Qs7RVGMsXDt/Q45FA==
X-Received: by 2002:a05:620a:440b:b0:93f:6375:aa97 with SMTP id af79cd13be357-940ef9df9damr1400486085a.83.1793074941325;
        Mon, 26 Oct 2026 21:22:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:19 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 3/6] mm/memory-failure: keep the page online while handling it
Date: Tue, 27 Oct 2026 00:22:01 -0400
Message-ID: <20261027042204.3741307-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C1C11A0006
X-Stat-Signature: ncs5errjwmt4zbhb4frkpkbsfsdo41kr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793074941-665723
X-HE-Meta: U2FsdGVkX18rKuRBbDfX8VjfIf22+wBObo8nk4ekhLlsxAiOhZOpyG1hFs07vM2qw1RbOeYJ3RJZw21bH9VeMeC/LyRataXd0sA9kQAHpXv/zRN+Y00jBjHv0XSACnr9W/9KaizQ9kF985VjQGnRZ+7cFS8rMatWQXrHW3YedQiMAELwf16ETK4+Tgrvq+aT+JjYYxRizCR+RQLIuo7WeAL4DhLx/mA8hUibl1/oeU9LHq3kNePGN2EQlOqCDpsaYLCzhvPNM6FI2zaIu9um7G6W+v+vKDIQ/1CAmkkZh/5BPUkipKGKcvtXuXViR9wBmRu20uirxhN7AMHSSn129Mzd9DZaqfi4FlImlK0f55TWu+Nwc+R8mRcfOtnPYurfh+X6cZIoyXEASLNtpfiXYp0exuyLk8/+XqeRqYQ40HvZlTyP19HD0LHPiY7LSkxZXHzd22JumK/uuJg5b905kdFg9ydEZxqq8+wSYUv4qdaAeU+DsraaJ5Nu5QvW6w2KGDIFffeyFe0XUx4gdDFGsPzKNUInrYLThhF75CMob87ew9VNoAPZV3fSADuRXAQudfnJlCU8aA7ROCfKhtkKXHtQ0ZInB5Aw3os4XKYnqwWyZZd/YpRVAY3gnOZ89evSoZTWJ+LJWwfDbd6pkdlRjX2beCpIgoLrTxbTCEIbtvuBlqRwrPCiwM5nSsNBqfu+YkHzSlOG4kfIZUOeDeajmPL/aMk1qSY7GYZyCzCk+3SzmLjbVO/wNcMpn/g7NTJudbReynF4IrGYifz9/BRPU0ATZA12a1bLiH8VRUlG3Boa4bLMJW2KOv2H7ZjZ9gS6q+ymYlT30Fit0P37JXBAaqHrQIlCrdyDGsvi4lTlXeYuxV0wXAjlb/IB33ZSqTggcJAVyXekQGv5RCGfIBk8OftNU1QHplL7XAkKkADaZYf9HR1lIxDbrAGc1ApFEIcXr2DcvWY2qbfeIvmPvuH
 MyljfOXD
 MJuLO/V1z0w7A9zcaLYCbooGKnHQZjNZPmbZUK76kCrFaGumnId1pNHn89c28yZC6BSVy+vdtBJt5z1LJTUNoFd99jJTmOrV/oT0QJIFLuzZylVHuSTEDzAcVXDUA1vAvqMRbBDVyR7gEU9YpiL6UUx13F6WxacnFKmJDC96RD5xDfOXMY5s0MsNEbzV6qkmSE/AukXmMMzjWkytSUd+EzHnRxBHfwibanhggORI/7SCg/gkgzBMODkqDe2ghfC4J/2dXbRp/y1Ggw5+Vt9Cpfyen+xZS3eq2nNmIewY9QgB3TyRdmYCLacfgmeAXLRBkfG9THFi/pi1+W1DBIOw7IMLUCXaL+n0P++SNVeNzUHhBfgY6AiopeNAXc+wu+F8aYPsak0LW3YyYssXmuN51kCL1pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memory_failure(), soft_offline_page() and unpoison_memory() check that a
pfn is online, then sleep on mf_mutex before using its page.  If the
block goes offline meanwhile, a DEBUG_VM kernel faults on the poisoned
memmap, and removal frees it on any kernel:

  CPU 1 (soft_offline_page)           CPU 2 (offline_pages)
  pfn_to_online_page()
    page is online
  mutex_lock(&mf_mutex)
                                      offline_mem_sections()
                                      remove_pfn_range_from_zone()
                                        page_init_poison()
  get_hwpoison_page()
    zone_pcp_disable(page_zone(page))
      zone of a poisoned page

  Oops: general protection fault, probably for non-canonical address 0xdffffc000000069e: 0000 [#1] SMP KASAN
  RIP: 0010:__zone_set_pageset_high_and_batch+0x89/0x270
   zone_pcp_disable+0x28/0x40
   get_hwpoison_page+0xc2/0x1160
   soft_offline_page.part.0+0xe7/0xbf0

memory_failure() faults the same way.  unpoison_memory() does not fault,
but it clears flags on the poisoned page and returns success.

Hold get_online_mems() from before the online check to the last use of
the page.  soft_offline_page() took it only around get_hwpoison_page();
it now takes it once, earlier.

With a kprobe parking each entry point across the offline, base faults,
or for unpoison_memory() succeeds, in 3 of 3 runs each.  With this patch
all 9 runs wait and fail with -EIO or -ENXIO, and lockdep stays clean
over offline/online cycles mixed with error injection.

Fixes: 96c804a6ae8c ("mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()")
Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
Fixes: d613f53c83ec ("mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory-failure.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0c96eb5119976..cdae2a1988bb8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2394,6 +2394,8 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
+	/* Keep the page online from the check below until we are done */
+	get_online_mems();
 	mutex_lock(&mf_mutex);
 
 	if (!(flags & MF_SW_SIMULATED))
@@ -2608,11 +2610,13 @@ int memory_failure(unsigned long pfn, int flags)
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
 	mutex_unlock(&mf_mutex);
+	put_online_mems();
 	return res;
 unlock_page:
 	folio_unlock(folio);
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
+	put_online_mems();
 	return res;
 }
 EXPORT_SYMBOL_GPL(memory_failure);
@@ -2742,9 +2746,12 @@ int unpoison_memory(unsigned long pfn)
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
+	get_online_mems();
 	p = pfn_to_online_page(pfn);
-	if (!p)
+	if (!p) {
+		put_online_mems();
 		return -EIO;
+	}
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
@@ -2833,6 +2840,7 @@ int unpoison_memory(unsigned long pfn)
 		unpoison_pr_info("%#lx: software-unpoisoned page\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
+	put_online_mems();
 	return ret;
 }
 EXPORT_SYMBOL(unpoison_memory);
@@ -2974,38 +2982,42 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -ENXIO;
 	}
 
+	if (!sysctl_enable_soft_offline) {
+		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
+		put_ref_page(pfn, flags);
+		return -EOPNOTSUPP;
+	}
+
+	/* Keep the page online from the check below until we are done */
+	get_online_mems();
+
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
 	if (!page) {
+		put_online_mems();
 		put_ref_page(pfn, flags);
 		return -EIO;
 	}
 
-	if (!sysctl_enable_soft_offline) {
-		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
-		put_ref_page(pfn, flags);
-		return -EOPNOTSUPP;
-	}
-
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
 		pr_info("%#lx: page already poisoned\n", pfn);
 		put_ref_page(pfn, flags);
 		mutex_unlock(&mf_mutex);
+		put_online_mems();
 		return 0;
 	}
 
 retry:
-	get_online_mems();
 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
-	put_online_mems();
 
 	if (hwpoison_filter(page)) {
 		if (ret > 0)
 			put_page(page);
 
 		mutex_unlock(&mf_mutex);
+		put_online_mems();
 		return -EOPNOTSUPP;
 	}
 
@@ -3023,6 +3035,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 	}
 
 	mutex_unlock(&mf_mutex);
+	put_online_mems();
 
 	return ret;
 }
-- 
2.53.0-Meta


