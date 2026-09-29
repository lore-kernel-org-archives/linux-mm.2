Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A37CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EB56B008A; Tue, 29 Sep 2026 17:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EF76B008C; Tue, 29 Sep 2026 17:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A109D6B0092; Tue, 29 Sep 2026 17:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7063A6B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59FF316065F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:16 +0000 (UTC)
X-FDA: 85268151192.22.D5CD806
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C3CD40007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=chM3BYZX;
	spf=pass (imf01.hostedemail.com: domain of 3SDO8agoKCPsqlod1ydlvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--nilayvaish.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3SDO8agoKCPsqlod1ydlvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8S1L9thUbDBOo5IvvqirVWz8KUgkebaENmH325jJXM=;
	b=Jqdjd5Nbsqd+Yagupqyzvv44v96D7brpd3pZEvyIv/PkS8oZIm8HCjxNXitADLd+YnnWCt
	euNSvVQrawMK25NAAiL9oNrMfawwh5PLQnlb435G0VXdanY0lj20Rxx6Mol0nggTMG/jl4
	4d1cyJtVhhQCFcBqMcao0JiCkpLAuYk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=chM3BYZX;
	spf=pass (imf01.hostedemail.com: domain of 3SDO8agoKCPsqlod1ydlvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--nilayvaish.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3SDO8agoKCPsqlod1ydlvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718794;
	b=FNELwE69En45pStsmNPfd5v5UDu76F5fAy6V+z3l+TijHzVNqhlQHNsQaXJWSBZDgnIgub
	GRN5otQxVLFIinqkoQ6eCzaYMK1CJlkjVh0eT18iSbZBdTM4wIzyJllb3nhArd06eogALq
	LG5CDdCwrJhDQJwr8yzqJ4o+qEteBO4=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so4825038eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718793; x=1791323593; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O8S1L9thUbDBOo5IvvqirVWz8KUgkebaENmH325jJXM=;
        b=chM3BYZXOBI10iAcoxIzvajP1qUDLNAil7FuYQ7gwqIGC9RLyj6ST5DPjNOb1CXzyY
         s3l76qtWm/m3gxCl3U9hFyd79TZi/oowzkQxzoLB9mvu9apNlj2q4V1NlmO26U9PMupM
         iwRmJRfHNNSZ1lEf7QkGXj73Q8MY8PEhXVn05OKn+Sv64aMuzbTonGFE9wr384L52MOB
         4OIwYTSuuWKd0uj0KslVEZbcYMthewZm/fHrQwp47IgypdERH42fFL91CyXvIZDSW4Qq
         TfSfZNb8kVA+oi0M4euKz621sxUfM+jcJx2U94Mp5uzurZUGiQbtj7MJ4sV7doz7jzYl
         /GXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718793; x=1791323593;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O8S1L9thUbDBOo5IvvqirVWz8KUgkebaENmH325jJXM=;
        b=A4RRMBW+L/f8qIii8zbzGMCmZkAH2BqsfyEsnlMxhQlXRvGJx5xpQiBP5WnUzzjD4w
         bWLOF1BMID0t/79zTTVizIXxdlFr/ewjcaneQABAqi3dtLDISpuyHzQmDFKy2hxaoB4H
         BQC8/cNY0cxGT5mu0DEKHbzGgPGkNl0sUGzNCiEB6ufLAaepOuOBd860958LOW/t6NPH
         xM9nI2iO4tkrRe+2Aqt1PEp0tcXDvaRohmSA8sW6gfH0QwXeqUdkEhTzFa64n8gqPxRB
         SReiAbz3rxWoVjT8312ND30YSeXHMuS4px5eq0ZFB/Qrz4v57tUBg+yIRqQ5r5au9Bic
         Hp7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzoaRcNlPTJVvNUPdLQzMvnkMDzCiCz9AVKbsp8kYXMvHupK827ukg6qvE2uQsFX53MukdHZh6fBw==@kvack.org
X-Gm-Message-State: AFuF++mdlrfBcvUsZtyF5h4FWCy2f3nD/hxYzQXgrngCr62Qh8qdKGzv
	f4QSDJWWkexnabYV599AQj6c/7/mw1v4SWfzePX8ZRI6cKipdKE3A2Qr7GY8Xn7rjb8IfXhb0sR
	LcXmK2U38s2rTFYIZdoZ3yA==
X-Received: from dlx9.prod.google.com ([2002:a05:7022:89:b0:144:d025:68b5])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:2706:b0:146:6755:ff08 with SMTP id a92af1059eb24-14c9d60e402mr605303c88.9.1790718792863;
 Tue, 29 Sep 2026 14:53:12 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:52 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-2-nilayvaish@google.com>
Subject: [PATCH 01/15] mm/khugepaged: drop redundant page parameter from set_huge_pmd()
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i5znrfx86ywr5g5ut1yqjcj35krgt6m6
X-Rspamd-Queue-Id: 8C3CD40007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790718794-544312
X-HE-Meta: U2FsdGVkX1/HgvOk9ndacQtTDK/MmkPIlkV2WN9UwRlva1iRzvIXsvfUaJMKUEkJKX7OYjzE2nxvyQRnRW/jf7+VyzJqPdvnYOA2LGc3U5DOWJSoLS1ef/KkxB94TMtV98+SOPXC+SelGYKtF2qegP8wQdyrjEbeWDIZUYLChhZaPyDffz7LUtg046OFfHTosMH7xYBlBuTfF9WBeO8UDF4QD/sGCCMd7AXmgKUkS7Ut9M3SjueGKIhhVyQesbknrnQnW2LDQC0bgbIVkBxXR9C75LpcXGI+eSiSxxKONkyQzptCjneXhc/b/GT+0d4ddIbMHfSHe7JbFRi8Qm37SL9FswNz1NcgCXcdpqlUz+Q5cpr4uplRPPecug7b+jU7m4c6H+xEfbcQEdlCR6f+t2C8ChmtnjyMjrbRFxHL7Qw4jX2KKg/JtpWhpOC9NwZA6vBPUtMyFuEh5yj6dCJ/lHdnk7rQWASBUVzl4XrAlOMm7l5kieLfrwQXf3V/lUDXCPT2446f7aQYRVwoUkU1sGgbXA17xKoNxD3ksu0nGuvX5KW5om9+AAkbpkBj8B5buSVZGvx2yiZ14dLivt6GDAaltojvr/ui/YwIgeLvK4JY7/NrzUJPZe+qmD76XgYE+T0Tl9W7p7nUGodInvK6LSwhY50WaqMr4/Ds7Osvvy9jNp+etYfucRTI1gpQu5dmCwtiSiXZo62OsOQHFxvC7grgKUgHsG6tclGWI3tbzGzxSrzR9Nv+1gnoK8kJ3Jc/emnkwBqG7xw/1CHTcSlYEYCnOor6+WJh3MVVL5FlUHnL6NC39x3JIpC1RD3mkfdwcFP82DdlNUDPmhRScyHlrM9I0wb0qf+jC6JLPRXOqm6dzxRm9OsuFGbPz1+M3W3s9QOcuvFNdO/QAIO28VUaF5N2MAD8fGLf7j5Zq0BL5o/Jibuql2drb7i4Wk267ai1HJoS5YfifAhAQlXgxVy
 I8f9mlLf
 +gS942Ch+FayILVyxyii2qv6kSHOL8xVDI2Qelfknv823M4Ev09iUtfpCs5AvtWeJwISrqhuOqTrqKCKDU6vvfB2LbK8+oXxsNl/CRtdIKKCYApyIpqpmEocQBdpY90h4QGQsTrrk3Gy/bWdIphXoIPpCryAjIvQa2hmTogt/UPSj84yqqFlB6S+IQYm7/sWgA2n18kSNFgFS94qH0Xcdurvdg0G8UdIgn25xKDCgYBuS5v7xwn7dAJskRowmL1ZqpUp5d9qN5umkH4XV4iblI4pu2aDAptyUnCdQaR2wgHCT4mPI0o8qFqrNdvpwR20st+gLZYJiIY85B/MMtpdSDlO8rE59yf9sdpcDJQ08AQasrS+jwjM46rr3NxXp5O6+SFrsSHmBhzeZtu/ymxRvtMZhxcSU46Uhw/Hd/XS8HDAHrygTI4SvTm457RBjYMcUmUOmk9ffztlKg/1FCO4W2Mx0FbZGHjzSfnkjhUx0vwp/UHCU7f3o2eMg5VpB+qTvm8iI2ymIkNmoSL0ZgA9gt+nTHuRaGPACRuznaawIjGoBuvEG+KdVx87EUh5ZCBIctdXkwRW6hZmc0NQJuND2boXT7wruL0PaWX98ZDMHN8NUvgDw8e6zGG9GE8vlXmOrI5bNWETClRWLC38bPHwDK35ETw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

set_huge_pmd() is a static helper with a single caller that passes both
'folio' and '&folio->page'. Drop the redundant struct page parameter and
pass folio_page(folio, 0) to do_set_pmd() so khugepaged no longer
references folio->page directly.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 913086eaf17b..63acb13f24eb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1793,7 +1793,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 /* folio must be locked, and mmap_lock must be held */
 static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmdp, struct folio *folio, struct page *page)
+		pmd_t *pmdp, struct folio *folio)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1821,7 +1821,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	}
 
 	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
+	if (do_set_pmd(&vmf, folio, folio_page(folio, 0)))
 		return SCAN_FAIL;
 
 	folio_get(folio);
@@ -2032,7 +2032,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			? set_huge_pmd(vma, haddr, pmd, folio)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


