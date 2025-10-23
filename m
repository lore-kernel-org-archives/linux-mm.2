Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9564ECCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35A48E0017; Thu, 23 Oct 2025 14:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6AC8E0007; Thu, 23 Oct 2025 14:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23F38E0017; Thu, 23 Oct 2025 14:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D36478E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:02:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9ABD112988D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:02:02 +0000 (UTC)
X-FDA: 84030147684.07.C5B440B
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA2F7120004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:02:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N6QvkmBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8OOEgLIxH1NP/inV/C2VhgTfQW+nHNY1mF4Le01HUg=;
	b=ioCkHUm1Bl3vyIeNxE5Tf6FfVDdYAA/Dzk5MM2s6oPuNLOjdmVN1fyF6WGww52trMI9oyH
	EgX+7AVOFnTjPdrjcRCRK55Xks/OzMxmjbKcdaJCS03p0unbIDKglwAy8ZL8efbDK7+e9k
	5/ot/8OsXupse+bg0D8Ew5ZvqDiTUV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242520; a=rsa-sha256;
	cv=none;
	b=3pwoMIBOx9wuiiM49fIvELGq/gufUrtjfMRQugf0fzNzw9HBd0iQaEu3hR1c02nG/WA3pn
	Q3VnnjWPQozzOGXHxflSG28ajtQ/yMbAOrn2vSSNarx2m4vAYh5x9rrX/EFdy+nxDrZrnE
	2oT/I35TTcBZbyx191M+jNCrXgQNJzE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N6QvkmBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-791c287c10dso851358b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761242519; x=1761847319; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B8OOEgLIxH1NP/inV/C2VhgTfQW+nHNY1mF4Le01HUg=;
        b=N6QvkmBDHR0itXaTOcnOFq1VDBkcbeGowvwQnSn51Ftfrw2KfFGWCf8JHrnwA3LZy+
         JoNZ2wMMZ2KHK5YTyJJIJWrERYyhh+eTVgC2M8vvq0MvFObfGPpFPnEIKIENvs9rTVnF
         dbE11Q30RnZegbbqJPWZi2LxmGq3kWWoCR14t0hwYc7TU/kvDsGHD6BL5BUJvkTx+jGJ
         DLDEa1iqPCDItlkX+LUxxEmifyluiUliNeng39ic+BX1FQ9aQWG5JDIylpAIr1QO1j0o
         gjbIDld3pQ8+wCeB79ZY7ylhV2Zcx28tlNntWRnxVU5ZG9OT859r+z4uVwRSuZXUmTcx
         2wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761242519; x=1761847319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8OOEgLIxH1NP/inV/C2VhgTfQW+nHNY1mF4Le01HUg=;
        b=gsQwdplBFZNENLkl146ppwgq6qPAfv2UJfQtlm1rzgym9UihgoIH4wUpW5kF7jQDpB
         d6e6A0cTCbTkcGdeJ31fPTdLLzFR08InCuyYXRWNn4MrhGyMLHe5tSSjZNSuT7RBdv6q
         M0znWMF+Kg/0xpj9xHjeYQVwgTD9CXTyHgjg9mEjCaAKFG93sOs4wtBl9uHVZ+L9ju47
         h5phZg8a1LVJH1BTnIGZjeu9J06CCpAlB6QtPCi1R81PoluO5BnIzU+VmcGAS+1PRnjz
         ZhxDW4+iw1UOIMlWeJG7uCO0y315hNY7H6cVskO025cfvT7SdVO3qkfzTlj1txl3ydEN
         v7ww==
X-Gm-Message-State: AOJu0YxHmZxN9A+h8t3zuD7xmxkISgPLqrZuCoA6AW/5MVLTINYMi4bz
	NSIv/jGeayPAVI+v7Zh47PtWZ0phE1h2jJWcmx0uJwCuEdU8xkwdk5Hz
X-Gm-Gg: ASbGnctXJgQkPOZSEwbstqhoyr7j1O+8spLjdytYydAlJZDiYCk8Ut+qsrYVIn7nJKZ
	StLzO+/EhhHhPwE4bkOgQNUowDVFMcO95TtTxGut8ejVJzMMKaBqjn+oCoVYWx9B9IMELQCN8wH
	khk3vFHOkwFJMuknvwVZYbP2q+x60+bBUtyI4p0Z/MdJtTKOaqLB08fgVVSX2276/wfntAdLAVf
	MM2uhAMnwwhRg/mRxZzAXnePM9j5G9xZZnstTUjABdgEuCYNEcjSs1QKRR8UNQbbcE8rhMv5ovS
	lgctHpaXIwK9T7I3wYHTCpnqvJk2jnSdCPyoJbWpSkHyTeC0Ikmsz0951nV4C58qv+WLYQhQu1g
	EwPlRPYLmPnEixIPjXAg3MvzvIKiYkVbW3vAuJRCj/8gOhapLIpd5Xz/jBPUjHdy5AjG01C1BTN
	k8Som1U+Pis6biSjXT
X-Google-Smtp-Source: AGHT+IGJ4P1IHhrkZ11jp4ofxibE3zNJrn7WkMQs8xkK7LYMPI1X94S1q0ADRNnxQSfN5CffRahrAQ==
X-Received: by 2002:a05:6a21:998f:b0:334:a3fc:7998 with SMTP id adf61e73a8af0-334a85859c2mr32604097637.23.1761242519371;
        Thu, 23 Oct 2025 11:01:59 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c4d83dsm2734532a12.18.2025.10.23.11.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:01:56 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 02:00:42 +0800
Subject: [PATCH v2 4/5] mm/migrate, swap: drop usage of folio_index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-swap-clean-after-swap-table-p1-v2-4-a709469052e7@tencent.com>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: AA2F7120004
X-Rspamd-Server: rspam02
X-Stat-Signature: 9b3p7rexx5m96jmhoqkwaza5n1eihtzi
X-HE-Tag: 1761242520-84915
X-HE-Meta: U2FsdGVkX18RtDvWROOORo9o20ANfzZ4EyPdztQ6VIgFr0r3tAVW8hOd6WRbN5BLIXubulnNeLzVbk4t8TOo36POYlv2ZXkcfwdW9/25AFFYPLERI5Kv9RKWsBb+LxPdInelLjrR7IautxTZIIF3RT5d/xH2aDuncTHFug9flcnB3uXY318Xy2GirsAV1XPMc3HDFPVeQCWLO3BVsveZ75qoXnAsYfQ5kx9rYJO/97a+djPFNe+j38+KXAqqTz0MzxHuT7XpKNzqk5x2n7zT8mCR+W1zf3eFaQtt4XVzGwZa7YXQ77xh+DxHdSfEc7i9qRLk56GsOGGHMzk0Sp3OhyIb3sMSNP/nrKcYwy6RuK8EXR90awGhft1Kdzuw64lDewH2vRfcmcOmGG8N6J/M6gPmXnN2a1XzmsJdRLypsOtuJheCeoyubruiWxAd4Kd+TEj0gYLt7qGYdDcgrkO3YCiqyefQDkidIYoC93jJqCB3V0TH0y2CoPXeCzf1CP5erKLObnW2Ir4UKmzSBeAPgy8stQxx9V8wQvzwX5UaFun6GRuDWqNP57K9OXTK32HlmDZ5lX99EgoWUf2+dT+PxWoXRErghIro5O8RNQ0ThGS2B6u18RGsGwByEVAwl6wkm2FbxP+snHD35qCVwTQGv/3piod8bqBX+s+Of2w3x+yjUm5Atm7gI01Q/eK70dAbiepSPHxcipXl/uCRgsUx4qIIRjyLTAZthKKOqCiwAKfjMlDel7TjpyM8QR1jFAxXJzq4DewmV4Vg93jh5AW1mh2BAm1PGJA9M2WBdLRHQvos0rRFQuY45xFt3Je3mJEwFbOWL4Csu/8a3OrutMLzrgIfbY8LbCbTH1bLNmh6Xxlw9UQCTq134MRj8u1Dy3HCuJVs3/irss5TGVHgK6XR6ItwFMZpN8roKSuURwcL/6TuSPthabL59xL3UKavkHHEzqhKLsLG59oL+Ci68A5
 W/keZ/Kt
 +G3KN0MrL3YklTGUAMI2feVC6J2iM1+H3+hUYw0UGOfAv7c2c373kSHmLCEFG8e/sP5WCcvRGK59ZuSamLyvCXSs+ITgIY65t1MKteWxAPWZQCBCdEASD+elxPh5z8kr1Dlcb5CpiOS5eD5gIi//RfZSSVR79xDsu38SMbLFVP8ekz9YUzgQMYwfL2ECbdcRhRstOn6qf9NFuTSu76LNbobWyYK8Aa36tDNdBvxp+6Hb2461ZorA5D2P8KzVT1cLT8ckejqz1akbdKtyKSjLBziQembHMUJG6goAreC1MDkFzSrBVFZuRsXwJJNtmhEZVvtq/yncmfbqN3IZL1Jm2h2KocVSN1pGy/jEUATaxSHtbQ+1vxCkgWW9g+HQWnaR9ErkjoQUy1FA5a2c1w67C0Ebzr5CY27jNXsC2wyUdF7PoN+/MwrLhOUcWVDH1+90VEVlW7zsZiRC0HDU8FSruosW0Mhnvk1Dysb8lHPZh3EtSt89rev6JuMOrpqBHtdTqbMn1i8sEekguhSM0Rwb+P+odc3P+T5B+oTkeKwev2y2QR7g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This helper was used when swap cache was mixed with page cache. Now they
are completely separate from each other, access to the swap cache is all
wrapped by the swap_cache_* helpers, which expect the folio's swap entry
as a parameter.

This helper is no longer used, remove the last redundant user and drop it.

Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/migrate.c |  4 ++--
 mm/swap.h    | 21 ---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 4324fc01bfce..ceee354ef215 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -563,7 +563,7 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 static int __folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int expected_count)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct swap_cluster_info *ci = NULL;
 	struct zone *oldzone, *newzone;
 	int dirty;
@@ -716,7 +716,7 @@ EXPORT_SYMBOL(folio_migrate_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct folio *dst, struct folio *src)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(src));
+	XA_STATE(xas, &mapping->i_pages, src->index);
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
 
 	if (folio_ref_count(src) != expected_count)
diff --git a/mm/swap.h b/mm/swap.h
index 8d8efdf1297a..d034c13d8dd2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -445,25 +445,4 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return 0;
 }
 #endif /* CONFIG_SWAP */
-
-/**
- * folio_index - File index of a folio.
- * @folio: The folio.
- *
- * For a folio which is either in the page cache or the swap cache,
- * return its index within the address_space it belongs to.  If you know
- * the folio is definitely in the page cache, you can look at the folio's
- * index directly.
- *
- * Return: The index (offset in units of pages) of a folio in its file.
- */
-static inline pgoff_t folio_index(struct folio *folio)
-{
-#ifdef CONFIG_SWAP
-	if (unlikely(folio_test_swapcache(folio)))
-		return swp_offset(folio->swap);
-#endif
-	return folio->index;
-}
-
 #endif /* _MM_SWAP_H */

-- 
2.51.0


