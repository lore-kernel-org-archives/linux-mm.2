Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DC9C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C1D6B0142; Mon,  5 Jan 2026 07:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604FC6B0145; Mon,  5 Jan 2026 07:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9FC6B0146; Mon,  5 Jan 2026 07:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8536B0142
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:42:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCB89141A02
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:57 +0000 (UTC)
X-FDA: 84297874794.18.2C37314
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id E4A5D20003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fajAuBKo;
	spf=pass (imf03.hostedemail.com: domain of 3zrFbaQkKCPETebVXkraeZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zrFbaQkKCPETebVXkraeZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767616976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7HijWvoQg86kFapHPJ6xmOixNwXXnFawvbJlN+o/VM=;
	b=5lU2yEecftupw5ICq6wuKtBoSKE2smNNMvO5c0pRF2lXN944Lo9l9lnJU2HpamLfhXuEx2
	80lspEruELOuLeJYNnoyCpC9+cL0vL7ytApM4ah7oU6mgtJj8+GPmRF8MkblnNZn3lstjQ
	QzQFhaciYHaFME2iPJ7khUpe+EiY9Ro=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fajAuBKo;
	spf=pass (imf03.hostedemail.com: domain of 3zrFbaQkKCPETebVXkraeZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zrFbaQkKCPETebVXkraeZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767616976; a=rsa-sha256;
	cv=none;
	b=hgWzv8xF3qLg0QOLd8Cuu4BgcTLS08OXDnv++LUiqBZwyg97o5RtOmsnmcnTwUavUQLg5k
	33wK+JIjiG+rcmUayQps5nS30CxHLBlulh2hwY26GoRL3QWWcCZZGlXomoj7tZHvNzK9rm
	Uog8R+V9YVaSWPFthSe0TQrB1MuSiiA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477964c22e0so16229235e9.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767616974; x=1768221774; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s7HijWvoQg86kFapHPJ6xmOixNwXXnFawvbJlN+o/VM=;
        b=fajAuBKomSmTwp/s1pWP7TDur0RiCqCWNd9ed4zsClP6VPBZfG8WynZMMoUhYmNeGa
         Gq/WKZQ/RsRZrwaCsgJRxaROfdQxnkj5RDzHTAH7ME2UluvojeNseUE6xe0Z7hpsquUI
         C6sNnqVvG+G1DQT0/hgR9y5GVMnTBZCWds3Jxx2BxmsRpKNs0zl1UoYvEAVcQ94Oqp6E
         Xe3WdA/m0Fs1nc2EQN9ktFXQcVIjIi5xoLE+fnUlmQsb0BNKG4l8a2LNlZa+CO/r9oEa
         vJwbHmD626FdHmVlsqW/t38XdfqAh80RhrbWHQU3zYYd42PyY5yaSxPaFhy4PE34/hrg
         hdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616974; x=1768221774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s7HijWvoQg86kFapHPJ6xmOixNwXXnFawvbJlN+o/VM=;
        b=igJArTSH/KtBXzZXdLgZHMO5ZUeDjmegTm7LxlRfeP5hy7X3VARnU4+A89HqiXLB+b
         3E565a2Parf4pd1v664I1uoxDZikRlby7uz1eTAZW1CToVDfCktSWG/eZJgziXZnrFp9
         uBgRA1pSCIJsOzKmHMBzuoKJMwR6OHs8QmGbTfC0c9NOH9Rt9aayUJj+IgV2wbvhCuMx
         qaPcSc0oMZ3Vrf2P7ISGD+raJeT9lqK00eNe2tuw2CORHO2+NeZqCGbdKkccmS5fIfxw
         WKPlpQ1QbTqsEq5crT5E/DX2oOE06LXyGA7ManXg+NCg7JQf2XQX3Dh+LpXo0XPmdSuN
         Zzug==
X-Forwarded-Encrypted: i=1; AJvYcCU1Xyf3Tj2B2SHC59q7j6QKsTgVxq7yW/bqmDi3Ohc3hGkTTxlLLKc3/c4bniDaiZ1yQrMzdHOH1g==@kvack.org
X-Gm-Message-State: AOJu0YzKsUY79z9w9OTKrwmz2gbvtD67wvTomjHgyMOYozIFZ8t9bcFw
	Jp0zdIQIt6/4qNR0HQfPGoRU6rvdjJWo/dIOCODkWrs6TyVVSJX2kJuqmKrl3NgiJXBSZN94Y6P
	ARIAMal6COS5jYJzJiQ==
X-Google-Smtp-Source: AGHT+IGQAETQokUV/JmEC/jSfhuRPZE6uXyBIWU2Q87B+4EDRlagPdgjl1xTSF6npIccNEDFpslVc7TtC9mw1sQ=
X-Received: from wmmu7.prod.google.com ([2002:a05:600c:c7:b0:47d:1e65:e8bb])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6011:b0:477:a2f7:74de with SMTP id 5b1f17b1804b1-47d6ba7ab7dmr77941665e9.3.1767616974459;
 Mon, 05 Jan 2026 04:42:54 -0800 (PST)
Date: Mon, 05 Jan 2026 12:42:24 +0000
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
Mime-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3941; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=3/t+NkFQ/sfvXAgi16TNI6nieZ3WONZSXYBl7iU98Ls=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpW7G7Ch1In0wVFnxCsygufoE0Pqht57tzU6qB1
 YHQ1MVnmXuJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaVuxuwAKCRAEWL7uWMY5
 RvnCEACWTL2Y1XjPP/ZChNHZ14zqsEgGtEQdS94TPAkB19ro+4h8Vy0tsm/BkDEvSOXN6sWS/mP
 a4bNvB8id4ZNHcxQn8csjhzb72Oc5XH71W8k3tuDRM7FwTXPWLgifYc9XG5sAsJ8K/1uI56sYue
 vqpW6aXViP/AlaqktQ2iDHbU9BW3z+r4jL01UxG4UcwQM+kPy4MwgfmOr5UPAWqpq8FbR5vZof1
 bALG3Nwpm6v4KmG/bloFL0Tqpig2QsUyBgR3qk7eiUpyI7hspT3HU/Bkw6HlsAJ8N5hxuaSub9F
 qhYsUJCx517xFWAxLx73L6tDT3Wng5Uz8VxRWqMwO6aZcbSs/ifGbRPx2esospC7LHVsiGveDTC
 lZzfvx4x+AM4cvk7Mo5LStJdmR5/hxClL8zXlMFxtDLK+6Liq9rqKCw953jdnqtdgARjGVwMUFx
 eCY8ni1buXBWyeBjln2bmTPpx9oX/C1E4G3o1jsH9X7SNuQF7uFoovwFkf+rWywe6GZ57qu/pB4
 HbBMBxM9LFQf8cCmTX7Ay3squ/yQV6R+3RcbXakjX48exAQoE7ke8JgOwcAP+AvrCTzcADXXNdK
 YpwIRtLbq5E4+WfLTZmdztA2OlI+A6gC3Y2Wr6vRcPsnINEXlrjw/YwOyRcmC3lSZTFgvUkM5N9 dsPoRy3lSvPxVIQ==
X-Mailer: b4 0.14.2
Message-ID: <20260105-define-rust-helper-v2-11-51da5f454a67@google.com>
Subject: [PATCH v2 11/27] rust: mm: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4A5D20003
X-Stat-Signature: 8rqxercqscaw7ic6n1k9b8nyogqc8ubh
X-HE-Tag: 1767616975-6531
X-HE-Meta: U2FsdGVkX1/M10g6kJj4gktXmXCAI0iLE8z9618oY5pwBf0VO8cbgiKap5KK3i5e3Td3uuxznTWbSytPH3lVtj83+vWnqvhWaI5KeylC5XHqvmq7UVEuM8Z4TSIygne48jrdn7Xg/4FA7yfnE2lKNZthpwfRLlQfApNM+GycgR3k/1fPLIEBryHXzTC3Kr+XRa8hkDMvc/vDIE2d9KJd/+apy70+xy8xKgMgdZn4+u6o0GP6Tsl3vbhequ53eL//A4rrreLGW//U2LvcN7HLADwNcOq+GadSfEyXceqeTL01h3aI/4S9SqobfzxNzQGlheUOEMKnousrp+L6zbEXo+ZT5kxnLkimqhrjPdAtBmvF6Y/2E0xMErTqb9DRGO7kZLqzvbOp+D0rnSbK73nmy63EGS4l0mEfRlA2KVBkAgSsA1jZrVlKK11XO7oBzt3mR3IJ4IbNwdhRm+/6MktjUP7XmaA9H715gXWw3SeUnStfoajCTazLNlTtdj3qmbpPO3YXprxGv07OaiZNN+dfflZNV4oBe6U37jPRFfMAKXbU2/gNr9ELVnuOYGW/C4eB2QatlIK+kbJDzvogzHxaprPbQpKE6m/o2kWg9O/1ytHbTo4r4naUkTMsvccgdBFCgQ9F5MOyEjYxU52oMIxbNjYeQM9y95Qj2BiwquMRb+vdeeLK9WosympHZcpsS2wY7xaTs0N/sLgH1Iy/mtgKAc4egsMcMcibFOCuicnmAXJnQP/0ScjDGkuOGtr253m6DvlF6bldZLQGOt95TuB/yauuHMs5HXrHesbDRr9skPa7l6RFpfyG1jgKUStfw1pw0hnuQNhX0iK/tWzyL2Y/9OIrcgDC+kMR/VbdFnK08W4qVhAEAcCskt1z7VAWH1LFrA4VdQs5o93CqEfw7/VpD5kwNUuPMW+w8M08z9idUWj9hkVD6bNceffSEK6Zom0Vt1zdUWEKQeLbCf5QViM
 +8dizIkz
 8OdyZBWnkDHj4CPw7S/Ocl/gb3Ir/QtenCXBOMYMeuW6vHe3rcaIHCrdl+ZedZsTlRM7K6sN5xKhYh501UGuQlSNIzYqQlAhja/qgK4k/Ap31MFuiHXsREUisNDf2Nl8wbniWBaZMz/jmz9/aUUWrb6biy7UAuyJ21skJzm/wZZ5bSb0B5R4/LCfVDqoczcrjERWErj7h+KE399WfjB5BLfiWKIEqpJVMXoMxEg+GdpKXNMjd7KZ3UNjAmh7OufDMyvR50nYUMfbXrFEZX5XSU8d8mO615wr1JJi2Va5dAYuc04AFqUYt1t5EtOUsfFI/smJ9EdZN26O8XhXtdNLZ6P1xZ/4cpEOj6mS6OzGIbmevE5hWFozYA/oqogF31EUstbOCVTDjz5jwZqyY9//ZpNem9/x6BcXItPi3Y4ch4r9GCAyjfNYPlQDnigraYshqdzb2Dz+F3rNT2RsmjtoeiYbEAAczVYdN+yIO7ZzxXi0yX8E+n7J8+4avKfLAIqJKJ6wmcwQ+1tDEeGTw3ryD7cFKyxfJfhaisE/5z9QB7/gOcmbfvMR3TSE/w0l6yolWcAft/g8fgH6k3ucX5OUvk29891e3g9HtsOzc8E3tGNk8ImpvTGTCQa0cT6emUTy/sX/JYGUzxeLtWUUocBs/d8E7lm/WlIrb3Z0R6H4mPVaLrj4VGy4KtYh9HB5daDTaz6LnST3CR/4xweeAGAoui5ffpdhe9tyAA1XG4VTEVQij91mIgPIPmpRxfE1dexfRaeGmo8XBq3UZ3+ZVqN+wHtx1dSUX9SZDZ+WBpSCJcZ7KWIDStPcGJhWhHMjaI+TUkcqhhZBinpgJvDIrso8wS3qDCH1nZcP6ewntsxFtLXfmvuRFS4vqa4MmiW5SNmJuWEpCzZVlmOQncPgo6X4VuFEzT6KcyoeUm1ETpW7kvbYGVTCfb2T+/SFHOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
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
 rust/helpers/vmalloc.c |  2 +-
 3 files changed, 16 insertions(+), 15 deletions(-)

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
index 7d7f7336b3d2f5a32e6a2b6cf8407da37775cfd9..326b030487a2b2199283b64b3b427e57cf5fb14a 100644
--- a/rust/helpers/vmalloc.c
+++ b/rust/helpers/vmalloc.c
@@ -2,7 +2,7 @@
 
 #include <linux/vmalloc.h>
 
-void * __must_check __realloc_size(2)
+__rust_helper void *__must_check __realloc_size(2)
 rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
 				gfp_t flags, int node)
 {

-- 
2.52.0.351.gbe84eed79e-goog


