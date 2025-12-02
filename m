Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC9AD1266C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8697A6B0022; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FE06B0028; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756096B002A; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 616996B0028
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B19012D78
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:22 +0000 (UTC)
X-FDA: 84175542444.20.A75EBF7
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8FA112000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EnJ03rr3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3KkAvaQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3KkAvaQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764704300; a=rsa-sha256;
	cv=none;
	b=Anp+U4Ff7AQX9T7goP2HsH50KH8279xEstnxKqzvmdzcqQDYDT71oiG/3eO7FivHVQrkwt
	tagzdxdGgaB0jv/oDo4C/jrjcNM0Me/od0svNIxz1jtbIGI9a8dY41kbDf/rwAvXWiiUet
	jO+xr6IVP1Dne/1d207R9YwtFDcogWA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EnJ03rr3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3KkAvaQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3KkAvaQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764704300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qMYBEWcYpIOM/tMAd0uS75dTnBdoaoIVwbOFkcZei8=;
	b=c59BuVkG8oJfxMytY8Temy6PMpC6tMs7X2NcAhQbw4bM6nhPGbeCSYKl9qwi6Wl0MI3OFA
	99SaXMU9GH5yjedKcAEriajksekeFYkYoIvgwCfbmQ3h4HjWgWA79ssWA4/JY6a4Q1UTa4
	TCesMWt8CRcKMfViQ/t35m6gMMsQnlQ=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2ad29140so2896959f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764704298; x=1765309098; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0qMYBEWcYpIOM/tMAd0uS75dTnBdoaoIVwbOFkcZei8=;
        b=EnJ03rr3DTL6bRJz78cAI9CL9uid5YmMTVeksw167M8dsApmlfORFPBoEcHOd2dw7C
         RUgCAKAZL1aUW51VGgsgl+3VnITuTwWTnL4MjWFrbONTrZsXMZR7O9rZAhoAmiK/i6GW
         CK2cB/dc9YREs/hjP8fCtRohb1iEpNw/YquWbjpgVH3o/VUZRS/pUTwjCTpU7kFRJgs3
         JSfMviKohXQ7akHs2Ak5sO1V3zHGvReBoviWxu6u5WifpLmGn7nsNmChOHgz1cZi+tRf
         6n02bCdFMF9zSBHapaDTbnB+2YtFEWK4lriLZWRkoaxNwnyh7ikjz12+yaJkvisc3rGt
         kvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764704298; x=1765309098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qMYBEWcYpIOM/tMAd0uS75dTnBdoaoIVwbOFkcZei8=;
        b=Z7Gwjw5ybORZcNlJIHBOmSNhVOKTLvEy3FE/i1bjMrx07qkDSbgXmw6oGbJtlm6qIa
         Vt0XQRJUeikPbdnLPb60gqq34kXqoJMQccR5c4X4qA9Wa576tIJf1XXYnfcgEwhRs010
         JeUgW5jt1A9y47j9789YZWVsv9rcryYrkEwfOKYwpLb78duUDi9xB9f8E671ET1zl8+f
         8U6SQXOl8IjRuoKiRicr+fW8DsCjp1NTNdTpB9pE6RU4N2pASexjIPsyG/QdOvSZkx6y
         j/AxYpqs4SDm4KM+iKcNoahTjR4RED6Yz/5x2KOZewgi979YTh18ANTa9vrgmw5sCK0/
         jmgw==
X-Forwarded-Encrypted: i=1; AJvYcCVfmyzGHt6ZRrb5JA7DpBmmXtEM6TfWbhxTy9DENanMoBfXU7roBEfnvC5/mfEnUnJEeziWJ9S5GA==@kvack.org
X-Gm-Message-State: AOJu0YzsDvopCrMMHRe+VJ8dg1ge6jmGEPxFxOGkI8jLtW+VOzGpnaUD
	JmKPaDrjvidAZjKff80DwPP81j7xxplSmo/KoUGDx696s70croKlTm5z0H7cKkErcbRR0dlLSaX
	SqXvyHJsb9cxWAgFAPg==
X-Google-Smtp-Source: AGHT+IF3Aj9rjblOcR3xPIzMTJeS1VxCNmkzb1lfjIl8FlvWxFuJ83OIWlXne2ViSMvh24ifU49i6uNyDCJKhgQ=
X-Received: from wrbdi3.prod.google.com ([2002:a05:6000:ac3:b0:42b:3346:5434])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:310f:b0:429:bce4:20bf with SMTP id ffacd0b85a97d-42cc1d194fdmr45269347f8f.55.1764704298588;
 Tue, 02 Dec 2025 11:38:18 -0800 (PST)
Date: Tue, 02 Dec 2025 19:37:48 +0000
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
Mime-Version: 1.0
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=4042; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=s5F849cKunCWhXEDw04RDI6ouvr7CQTpbwq+FWSvJxw=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0AJWR/fRnVCj+DsWwJtPSwRwrcDjpzyN8mfq
 0sOX8tn6DKJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9ACQAKCRAEWL7uWMY5
 RvZUD/4qk2bOPLDVVH6o1xUcG7fKDtuBkgkvoaYHvWDhZyyaKHD8OGY9owyeYUcmt0x2jXq7bqH
 EPkgKOcp+3Cw0AfukXcyx0o+uatdJultYdvh+OrKvhTVEBLmA0BJON86RPamY6m8AGpKPlf2NjT
 UyRL9U+voiZJXo0oBSw0cGHezDPy7vYIWpncqGphzipHTJ30X6ilRQFdkfhXulX+ElmXbUxvZUJ
 Am24xCt59rrJ9xE/WRBI9qf4jSVJFsbmJl0PRxsuBLTkRQmsHUhWLHCslAoFx9/6QcrwavEyPR8
 4h1GQG5bXrYNh2hXa9cX+0vroiDZ/HxAs6VzgVMc6N1idyZWwcAodb6uiyz3PCGUf4NPNE+1P8q
 WUvfZO24jxODhRZXzfvUHqrZ2rL05qBY5uzj9XPpB/7EOF3ALh2PRTa2ze8+q6lVrQBF8zThKNb
 D65FwQ7TvitYVjF2b7XPYnKHLOlJazGEx8NRmO+r3TKAD15fFqO78KZqjygtM+br0UeWHD5QyvP
 FI0vxWYerfITc94IYwV4sG47FHjRtyieKyrKXnj58n51wtj95YVr4IMNO4XTmTu/y7ok18iCzak
 X1Tn799NmNMmiOBUGzmsnHbx1oAI04dFiSaMXIfSvuvK+sEHy41PG2x+qznP/f4V9XUdqoEbx9s B+77XbIBao49Nvg==
X-Mailer: b4 0.14.2
Message-ID: <20251202-define-rust-helper-v1-24-a2e13cbc17a6@google.com>
Subject: [PATCH 24/46] rust: mm: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8FA112000C
X-Stat-Signature: byhya7f97ofzpqfubh5ouxkkhwq19ne5
X-Rspam-User: 
X-HE-Tag: 1764704299-923114
X-HE-Meta: U2FsdGVkX18hAo2guZzTiztVZYDskHrKbwUPxrlsstu3VkvfjCPAx7rbRTm0am15X7dndcv72MooQAl8TUW7EhUBYwaf9/iyZ903pu+NPBbcYwdm0uOmMeC8W8jK4PnR7ffs+SY/NNcMLhTWbpQk1412ku7MGo0rmAqmUPecy3ThC+RansKutoOwcG/FEER0UjwOjYkyM961B0yZW2ENIU9vrLpKnj4/UnEePRIIJfEABjVHlrSZH7iIX1aqhuzhwnAHlL6rET3onr/nPU9IDtMce8h27JbwlFHkUKcHwt48HkkpPOP7rEvOWjWLDevphVf3uXNy5r3AT6YQ3Up7JEdgop+h9ohHAVMrGUBIF1/Y+fQRqBZT6P/MCrzKKZjEK077x+0+85M02f1G/+ihKWL1VBA5mwRFKGJPwq+EMvHCZuzDEG/Y1RpGIDCJy2oXzRzrIt6acOOhzZ9A0urjxqPFGbZ9+c4tuj3jv4M5tluX/NBJvn8ngHyXffkvUzSjka5pH7Yp5Z63jZL5h9BmF1cLbTfTm/SsaAuzXUiQt0bU5uJz3G5TdA1F3q1mfVGI9y6Yb6B1LJiVANHo7FOMvJIJyIa5QZUsUIQVF71tnAFFf6c2fftJ4YOrbWjWH5DA2+/ZAbbjC18oq/9YM1s9AY8OWvj3moNaRoD5phnrtPVlXOQWpsQhA2Id3W0P2FPMRNK0SCbiEdUV1NxnsFh1gFnY182hUCiBbeI4XeUoCl/fwr9Q7Bt69cSsz0EnbihGjKYqbv3l3gXXHT27fHmqyZQYwEpS9Xit2+n8zemBL+QLk3mL+L/I/iaDOUxZpY4ajaZ1f+EO0hMghZUdGbwp/N7iI+dfJC2JdPYj+T9hkO9FvnChTJ5pwa+S7+GutZBm8/OtpFjdKOpmiVDzrGQo3HgIgHSkcvgWWvx/i0fmVkkPij+Lfm15iPlEdqYu0b/BKmmgqfSHU1h89gH9quv
 tuz8IUY9
 CWISrX8nD6BlFzCMeopi/wHIc8L1sBM1t7WuBesajUywyU4P7+r4Yexr69L06qgmziLs+zKZVLwgTbfelneIL/20oBFbdb/wC22PYTVKJIiTJorI+2q9FirXPtiHgTEvqzy92/P6CPaqyiFovKXhrz75g5x2GFn5R5Qi9wsmiIUoxSQjEucGqsAbx2Vjdq2qBzEnUxntZ5XH6AqjWDjnsZLCjJp9wi60tcMbGhj3gc0y5bCK4cqtljnKqT2wBnbiy7bSuigfUOXhmA6yQ6FrraSnCytsSG8CTMaAbslz2RcKqFOereuvW01i47bmMNoTaYf/6b/CVj09LDgDpDWvE63o5A9Y00Zavh8grOJOeSNmcAUa5v22G8V79Nj2xHYUu3YYGlf8sxvsBhRg5p4tg4Ns+IuphYjaYytjfOCqD4UgdLJydrpw2BcXPeCKaYSkJ9Qdu+wj4vkovnXQauFyfrHKbBDsNe0KR5JThRd8LSB9voJhKM4CFjBFHskXUDYpv8KSuDlkunYZy7y/i7pfn7jVbfNmdbGkhmMH31aaIMZIkdXyXZUPIQ74K90RSm081Mo6B2YYhkXTxrBnjipOIJVx7PcDyhdQdZ8HZMfITStx/qMpOvrFRtY+3tdth3sLHzUqDRKYapCYeBL1wcYqRYy8BRsS5oPs92jzta+zXonANVw/YALR4dWMR6P0mZkzZ+k53/tl/8xKtcXB2SV3gOPP/hlM167f1+7WsO6e+ZRZTOASq09mNv0HHX0W2Cltt4Ujfot+kUkY9iYQ7/473GiLXHlVvrZrXEu2ddHQs1kNYwGTdEFh2Q1+2Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org
---
 rust/helpers/mm.c      | 20 ++++++++++----------
 rust/helpers/page.c    |  9 +++++----
 rust/helpers/vmalloc.c |  7 ++++---
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index 81b510c96fd2692dcb7ab4705f790bd3a41a630e..b5540997bd20d4398e2838956ed70b2fb61c5661 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -3,48 +3,48 @@
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 
-void rust_helper_mmgrab(struct mm_struct *mm)
+__rust_helper void rust_helper_mmgrab(struct mm_struct *mm)
 {
 	mmgrab(mm);
 }
 
-void rust_helper_mmdrop(struct mm_struct *mm)
+__rust_helper void rust_helper_mmdrop(struct mm_struct *mm)
 {
 	mmdrop(mm);
 }
 
-void rust_helper_mmget(struct mm_struct *mm)
+__rust_helper void rust_helper_mmget(struct mm_struct *mm)
 {
 	mmget(mm);
 }
 
-bool rust_helper_mmget_not_zero(struct mm_struct *mm)
+__rust_helper bool rust_helper_mmget_not_zero(struct mm_struct *mm)
 {
 	return mmget_not_zero(mm);
 }
 
-void rust_helper_mmap_read_lock(struct mm_struct *mm)
+__rust_helper void rust_helper_mmap_read_lock(struct mm_struct *mm)
 {
 	mmap_read_lock(mm);
 }
 
-bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
+__rust_helper bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
 {
 	return mmap_read_trylock(mm);
 }
 
-void rust_helper_mmap_read_unlock(struct mm_struct *mm)
+__rust_helper void rust_helper_mmap_read_unlock(struct mm_struct *mm)
 {
 	mmap_read_unlock(mm);
 }
 
-struct vm_area_struct *rust_helper_vma_lookup(struct mm_struct *mm,
-					      unsigned long addr)
+__rust_helper struct vm_area_struct *
+rust_helper_vma_lookup(struct mm_struct *mm, unsigned long addr)
 {
 	return vma_lookup(mm, addr);
 }
 
-void rust_helper_vma_end_read(struct vm_area_struct *vma)
+__rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
 {
 	vma_end_read(vma);
 }
diff --git a/rust/helpers/page.c b/rust/helpers/page.c
index 7144de5a61dbdb3006a668961cd1b09440e74908..f8463fbed2a2670ddfd4c23dc922b46b0913c3a2 100644
--- a/rust/helpers/page.c
+++ b/rust/helpers/page.c
@@ -4,23 +4,24 @@
 #include <linux/highmem.h>
 #include <linux/mm.h>
 
-struct page *rust_helper_alloc_pages(gfp_t gfp_mask, unsigned int order)
+__rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
+						   unsigned int order)
 {
 	return alloc_pages(gfp_mask, order);
 }
 
-void *rust_helper_kmap_local_page(struct page *page)
+__rust_helper void *rust_helper_kmap_local_page(struct page *page)
 {
 	return kmap_local_page(page);
 }
 
-void rust_helper_kunmap_local(const void *addr)
+__rust_helper void rust_helper_kunmap_local(const void *addr)
 {
 	kunmap_local(addr);
 }
 
 #ifndef NODE_NOT_IN_PAGE_FLAGS
-int rust_helper_page_to_nid(const struct page *page)
+__rust_helper int rust_helper_page_to_nid(const struct page *page)
 {
 	return page_to_nid(page);
 }
diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
index 7d7f7336b3d2f5a32e6a2b6cf8407da37775cfd9..469ebf2f41c94744e2a2719d7c0eb7d4d7dc58ff 100644
--- a/rust/helpers/vmalloc.c
+++ b/rust/helpers/vmalloc.c
@@ -2,9 +2,10 @@
 
 #include <linux/vmalloc.h>
 
-void * __must_check __realloc_size(2)
-rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
-				gfp_t flags, int node)
+__rust_helper void *__must_check __realloc_size(2)
+	rust_helper_vrealloc_node_align(const void *p, size_t size,
+					unsigned long align, gfp_t flags,
+					int node)
 {
 	return vrealloc_node_align(p, size, align, flags, node);
 }

-- 
2.52.0.158.g65b55ccf14-goog


