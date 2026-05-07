Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E74ACD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05A26B0088; Thu,  7 May 2026 07:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7136B008A; Thu,  7 May 2026 07:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5656B008C; Thu,  7 May 2026 07:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79BCB6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:07:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 271BC1C101E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:07:58 +0000 (UTC)
X-FDA: 84740349036.05.A3C26DC
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D84740002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:07:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pytT4sv6;
	spf=pass (imf27.hostedemail.com: domain of 3inL8aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3inL8aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778152076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=96wqgdzB1qNP9htR3bQ5evm1FwspyJ/v2h/BJXWKmQY=;
	b=vFb8/VM7lo27y7ZOhzi54gHX5WxRWpTHIPOEbjgbi9N+sWCVNfiQnLQPsTEut2Uvq/Gi7x
	ZBzwqOmvkykB5vjjnz4tmuLyB+93OrMibjaKu9smi9kebPjjxzaa0LSIq9rNcq/miqeTTs
	U1Ofr6Zovc/1hEOZ2yEMGuJ9uG8Fr5s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pytT4sv6;
	spf=pass (imf27.hostedemail.com: domain of 3inL8aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3inL8aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778152076; a=rsa-sha256;
	cv=none;
	b=fDUkUQCAY33BMY26ZOc4cJzMgGdlsU+E5IoOS3UoJYtmthMeOHESmFO2L3FgNY7p4pycLc
	qUZfpb4SqrwXzHCWh88S9U9pnedCKkIkLf2btcA6qMkUmIeJabEsJac+TTG46BcgDVWLkQ
	uyqg0X9Wyd5ELCOl0grsglARrKUHEEk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48d0889c1ecso5094875e9.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 04:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778152074; x=1778756874; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=96wqgdzB1qNP9htR3bQ5evm1FwspyJ/v2h/BJXWKmQY=;
        b=pytT4sv6YEZ7gsqNyJygYdyjKYwbY/209vTupcLtERRaFySqb4PyKLX1HqO980Ms4P
         1b83+sBmuHMZcVdj44QXS63Z9M9St1CNfFukgeAvhF39strCYHhXFQtTMcxI3pNl1qpT
         G25Mv6nqBr36biASykphCCIE21f2FRPwliSLpLg1k8xBCbalOTNTXVuEii/csY3W9GEF
         LryhNrGXbLRfqyrKkF951CDNX/+2sJyQCJHWnaIVIu44gh7uFWr0wCVLlXXcPLQtqyrv
         BP1A/7R/KgKBJwc+rrAq3qB7+f00z8YsxDkAe17VMrMVZElJfdo/omZFYeq5NnGwU4Si
         KK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778152074; x=1778756874;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=96wqgdzB1qNP9htR3bQ5evm1FwspyJ/v2h/BJXWKmQY=;
        b=eNGzfjgQSQH2XpdK88Xv6MSaJLbS+VdIM3fQMaWoW0NmHLkgHMGAcreOqJ5jUaNKEC
         oiSP7FS8HTJFLdfdkeMCTPjMv47vmwZrkIVwG3X+JIopv0cze0GbnP4OB9cEP/0VMiWg
         yjlm8MGeDW8ce/he0M+gwdLJ4+im5l/WAfEDSbAFVUzcltcL88Vt1Vjp+aoSht0ByJNR
         OhlZwM67tJPVtDKjjEOlfGaBtW7HwStUq067eWs5dDxQr9sEfk/c7dM8IRfCpuVwWdzS
         O8Mk0Ob1j1QrAhSNrBr7y0zCpsSvndEqBe4xrASnRKTSfdLUeA1gG3Rk9ghsMWp4Lrv6
         EbXA==
X-Forwarded-Encrypted: i=1; AFNElJ9qDsI4j/sscdtWZxI/Z2sSfHXbUAr4NfL+ydBIoyn4+cFYV4+Zc0NBmjLiMsU4+LD9gB4CXA2ARQ==@kvack.org
X-Gm-Message-State: AOJu0YwIW5KoU/hDHPUER4n7gOIRju/05eSwvNyqlWELIPcfRUJkSgaW
	jinSw/YSrSiZaPVQPySHq20BsZRI1zJk2DBnx3ctCN0tnvWPP2As07eUcSz2xQWUpO0VJJKclHq
	MGiXBB3e89UlpCMfdXw==
X-Received: from wmaz10.prod.google.com ([2002:a05:600c:6d8a:b0:489:1b01:386f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8485:b0:48d:5c1:bc47 with SMTP id 5b1f17b1804b1-48e51f32a6fmr129081145e9.15.1778152074296;
 Thu, 07 May 2026 04:07:54 -0700 (PDT)
Date: Thu, 07 May 2026 11:07:47 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAIJy/GkC/x2MQQqAIBAAvxJ7TlDBgr4SHUzXWiyNFSKQ/p50m
 znMVCjIhAWmrgLjTYVyaqL6Dtxu04aCfHPQUg/SyFGslDyyKDtTig2O7OJ9WmFUCKMftAraQKs vxkDPf56X9/0Ag2ZN3GkAAAA=
X-Change-Id: 20260507-binder-shrinker-lockvma-51ff7d621f25
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3217; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=c8/thFJDN/UgryeDScJ+escZtWjAhYIGhui0hzCl4Qc=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBp/HKELVKJZIjusH/kk1vQC1NcJVmdZ8s6fmPcu
 OEyVzE1beyJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCafxyhAAKCRAEWL7uWMY5
 RnCCEACYCaPfKVvg5gzG3Q4VoJsQAu1S2L4JqdBScEi2ciEe4pE9vp8uMSz+GvnwHeVuIOyqkFg
 v/eMglNqpsug6KWSTWjfCWmOActM7ybDr4JfaOBcTRGagIbSgcXx1dvndyFVXlxXzeWa6gMtH2c
 RjO3M5pe1mPm0zqv3G8cu+EVYiyB9H2o26KQUyEiZHflhckqwZfiVgVkdUO+t6/ZFXlPtMLQ8HE
 77Mx8s/4UkqZPB/h0sI7G5Il4vBp2m1h4klVJ7cJklDWxoNbhWw3CO0ea+3sQLmr4sl9T1ttU8j
 tYlF5piXfINjJXZmm/n8wBpUhLQLKXtdyd3PleXOQl7VA+0h1ubS414cxk4IJY7UKiiuPy45KD7
 MV+BsfUC9mSVja1X58IRiU3tfNpwTo1PkaJO4Q5DwlPJdgAcCB1ZlOlH9rkK1GlD38k6y+BGOwc
 W3mNi1BR/yqNAAQg+n2GqH0JLJuhT7I5NrbmWttYM0RLTdg4sjt3wVzd3OGjVS52DQnLSKRySw0
 fGYT0ktBi2w/iOvi+ffNogGy/rtfnWXCELXSxO8E+093xpYiNp2lDPqVO04qPaYhaWTJBpc+qgP
 9X+jxkq8AyyI2ltQsjBCFKosJAn1STFd/jmriwHVwuQUiw6A+AK6P8ammOB12d7RUxzh04W1GqC pwTYc0kivMysqhA==
X-Mailer: b4 0.14.3
Message-ID: <20260507-binder-shrinker-lockvma-v1-1-76e3406bbfa6@google.com>
Subject: [PATCH] rust_binder: use lock_vma_under_rcu() in shrinker
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D84740002
X-Rspam-User: 
X-Stat-Signature: n3dkk7giyzudgydhkc5a5isqiryn56zn
X-HE-Tag: 1778152075-895510
X-HE-Meta: U2FsdGVkX19C/eSyFCh8ajiEQeo1Fszs+z89SX6v+sjMFliF7iwhOqMG86DAaw5wFOAsrDXiej2281XwOUFCVGP8u4rksfIwL5oMrCPpXV1EGNNPIhD3TepGyiLNnpmiQcZHS89edldUVsJwLvNdIVQlcwjsfCt0FvZYun0jhhiLaHzuuZJEa4ZFagjOvK1K4SmWJlP2RYbCIXLBD7c4nif98djQc0iQ5ORMnEeVgslbX2AnZM9NkRZJNh7+XF1sFo8YkVkSIukgon3mZeOU7ivv4v5/5QlhtBf8waQ1pCqWOIDft8vAeLnfWxWTX/06rc1bq7PZwPMmo4AJFP9XAMXCFZMIPSCA5m56d8YbiDoPCWcUaqyaxh5IaW1IaJ3/7ohagx9vyJQdWRfKRnJbXN1Jjnl2yFT+DpK9Fk2XjWNejrQJ7387HjI0vd4f051R00RzJBE6nvqx2LseCXZVFNsUIzU2HcMvAAv/rz9cr2b5Y9KX6nEQZzX4/+wNV3iGs/weuwNIIIfLlKXL8P+1a1sf4IxZeYJhzwE5z29MlzWv36nio1eP31KsW+mvh7cf97sxJ6xcY2NNW5rGi4KhvfQwOtm7HIRl7u6FymCs/CfoRJPxc8kBP51rrzxuD/4Z/ZB1Rr//rqEB6r1oYlnZ38LWgg5Kd/3/OZ/O3jGG3hrsDU/llw3JY5p5yhYyriSd0R7wjvSZXkuKmVscOetzCy4zQ9s+FWNSl/nXPLEDx8g/ZLbBghOdYalw8+CzwN582uHufaYK84u05A5GRI/i0Wm25hWha6e/5ExT2MPgd97D2Cq/Q5lR5B5wkHhQCvdbV8Yc/46j32Cc1sBLyJavwqwe8PQXzr8DtseT3mBUM6UUu3BmJhRK4AihXdsa9yZBmh7DqqXyJQdKaK0BdOZEFvCIOldPhNsXYAQYBNvVV+QyakVv4D21ecbe6+RIyfzFsWjvY/OpzzZxhcw+Bjc
 F1RVWtsy
 pd/l3OWwqveHz5w9naG0rH4IAWj2866YlYmUPwxQj9qLIxAzGHUYYVnqdlsVxatbXXZ6lRBDM+MyDvc/HLN5RRDmLcEuNTC+Bs2hSQHihy6S3y91EAyerjtzjtKNKbVvKYPS/TximnG1ZeH5wfohIzYuQ4ednF++2yXGVCf114f/wWgNfk3tbpvF3+GyHNtWQrhLmkou3i3Ih6SuiHQ1AbwgdzEin7vyjPWkqAq/kPU6Dyi/oCdasxhCwzjeB0QHVFysmrtX2buXDZgXhx7w3EK3JpTVOtVvdtz2RBNX0gMtU7HJUqUAnJIr9DZg5iCSM2QXXPDRQTLdnUflcVEohKCIDCXbdpbT/wIND+3lQ7vRBQaaobgpAJ5CL6azxt4ReaUF3bRZexETTDCvkVKdTvRMHw0Ddc4saauxzuDouYjF5ZnfPgXVZY5A8YIDThyHupL417mPUl0YJ91CZUbhLcAyL8kRi6RQs+kauiUfN2yTEpq9d2Ei7LJT6sJsTinIcYRkABnNoiteMCxEtAPnG7ScoffqmNnDyfDai2SKd/qZWaqaJSPlEZZbrzX1L8mLNXxEH1fe5jBfMk1e8ckRLZXrKTT8+WnUGlVgB4qLCBh3UiuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shrinker callback currently uses the mmap read trylock operation to
attempt to access the vma, but it's generally better to only lock the
vma instead of the whole mmap when you can.

When lock_vma_under_rcu() fails, there is no reason to lock the mmap
lock instead because it's already a trylock operation that is allowed to
fail.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index e54a90e62402..e82a5523804f 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -705,7 +705,7 @@ fn drop(self: Pin<&mut Self>) {
     let page;
     let page_index;
     let mm;
-    let mmap_read;
+    let vma_read;
     let mm_mutex;
     let vma_addr;
     let range_ptr;
@@ -728,17 +728,18 @@ fn drop(self: Pin<&mut Self>) {
             None => return LRU_SKIP,
         };
 
-        mmap_read = match mm.mmap_read_trylock() {
-            Some(guard) => guard,
-            None => return LRU_SKIP,
-        };
-
         // We can't lock it normally here, since we hold the lru lock.
         let inner = match range.lock.try_lock() {
             Some(inner) => inner,
             None => return LRU_SKIP,
         };
 
+        vma_addr = inner.vma_addr;
+        vma_read = match mm.lock_vma_under_rcu(vma_addr) {
+            Some(guard) => guard,
+            None => return LRU_SKIP,
+        };
+
         // SAFETY: The item is in this lru list, so it's okay to remove it.
         unsafe { bindings::list_lru_isolate(lru, item) };
 
@@ -751,7 +752,6 @@ fn drop(self: Pin<&mut Self>) {
         // `zap_page_range` before we release the mmap lock, so `use_page_slow` will not be able to
         // insert a new page until after our call to `zap_page_range`.
         page = unsafe { PageInfo::take_page(info) };
-        vma_addr = inner.vma_addr;
 
         // From this point on, we don't access this PageInfo or ShrinkablePageRange again, because
         // they can be freed at any point after we unlock `lru_lock`. This is with the exception of
@@ -761,14 +761,12 @@ fn drop(self: Pin<&mut Self>) {
     // SAFETY: The lru lock is locked when this method is called.
     unsafe { bindings::spin_unlock(&raw mut (*lru).lock) };
 
-    if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
-        if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
-            let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
-            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
-        }
+    if let Some(vma) = check_vma(&vma_read, range_ptr) {
+        let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
+        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
     }
 
-    drop(mmap_read);
+    drop(vma_read);
     drop(mm_mutex);
     drop(mm);
     drop(page);

---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20260507-binder-shrinker-lockvma-51ff7d621f25

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


