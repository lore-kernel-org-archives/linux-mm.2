Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BBF6606A326
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=YxiLjZkD
Received: by kanga.kvack.org (Postfix)
	id 682F66B05B4; Wed, 28 Oct 2026 17:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6337C6B05B5; Wed, 28 Oct 2026 17:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521D06B05B6; Wed, 28 Oct 2026 17:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25A826B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:10:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3CFA40224
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:10:25 +0000 (UTC)
X-FDA: 85373278410.12.A950575
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CBD6100008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:10:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YxiLjZkD;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793221823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yeuwwk7tF/cWkQUi8sGp6aOSUkSEkLoVE/SS46FQgj4=;
	b=knxQ/aKwLZymkxxfWvvp9eY0nAFaw9c5KtEBcycmBNLWFvyDapFyJvF8QcqqLBS6HrbnmY
	2qR+ag97GHX9h8kImYc3dDklfAkatnFgkjDu4bzE3qjxZZP73ZXiHHQju1uAkWxbDBEKyl
	KK4ryqfmv7fLXpo+RkDZx8Uf0vgBdjw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YxiLjZkD;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793221823;
	b=x0j/dyU41Zh/Dl32ZtpFCo6WKOQbksS3lUCHu7vpcRP59NlIcZVUdRhJgUYJfAYAFovYg1
	BCQNjURxthVIhARRf6OxT3LuUuFOsY26i7iTOBcSclcymd2xwAvdnZWJUK8UjpA170bAQk
	6zaqLnKnyKL7pJTw2Yy4z/Z0zilnVh8=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ab432273c5so14740977b3.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793221822; x=1793826622; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yeuwwk7tF/cWkQUi8sGp6aOSUkSEkLoVE/SS46FQgj4=;
        b=YxiLjZkDrXNAB7U6VibXjgjCF2XfsUBn3yJMUoVvQnKFykz6kk45uxlyQXmIwtR+M1
         518kyU/OaifWnwMZ/ixdIGLyvkF2BV2yc2Jc6h+jFO5nJYjZ/r0gshZFVN/TqhaORUkG
         O4H+qGzDNgoy3TNpXxWDZr/tSq5V9vTmyvBys+4UZY9OIUjQrDwXKwiUlE+pIDyUqzc0
         lFMXDLsOlWSQQRvWhof6D0S2i4DsOLRjkld98oHOEf5yyV8ITNAfV0XeIaFJboxmMYVn
         hNA20b+x9l7sRZbTLTdtFoVEBScgB2Od5o0x6FGcsdXQZ369MRU6oVmqvwtb+FaShyhm
         pZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221822; x=1793826622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yeuwwk7tF/cWkQUi8sGp6aOSUkSEkLoVE/SS46FQgj4=;
        b=r18rA0of5toTS1HWpkIYlYP++xFfXSlxalQgzzACc3BUKaRJZrJf/lVOxtoa9s69bk
         go+HPFuTWHNj23v8SYYZAQmAaQx6+hELxWPxknSDhUbnoB0lJ7oX7vpaajNfadvES4xZ
         aNQ9pthz5p8wpfcnzX92n2qH1zGqxGWXG6i0VwdRWG6Ild3G0MtD2/8zkte4Nr6liq0V
         tfrlklHm2JWngiU/psK3IyO1a02vI9ukhGtzHtqtMVPvyK6W5rDfn1vm8aoyykKZsy/P
         itoU1xKi2St0nQhNgO/wJWDZC0l5qOZ0lN+dg2PA04iXhC1TzdgMCxLsZlOwGeIqasdO
         8JnA==
X-Forwarded-Encrypted: i=1; AKwUvBxDfEEjVkLpmk5TL/EgAk1fhLroTgUWNa0rXGf72ByBJOYePUdO+v7qd4PrOcrWp7yE5rkLMnnCRw==@kvack.org
X-Gm-Message-State: AFq9FYJ2EwMIJG0eVoO5dbaleV0wWWyBsihd+bUabU+hT072qdt2fUfK
	choBcBv5XtZcr2kwHq58dY5dESJY0JveGehGH+SL30oED0kjZ5C3JBzT7ALG/V8zQ4s=
X-Gm-Gg: AYBFou2pnL2vQWkswPHAH2hFm23thzn5lflfxZg0866N701mLoad5oXFNEbw1yUDbTA
	eQ8qgtNcSc0xq2MZFp/fOinNhY+Zplb7BUMytPAsM/hboHvZ/nI/Y6RyVI6QipiC0Rd91POYIG4
	QiWidb3y1hx4yqoEaoWvyblVpi86covdmUXzh8ugslV+9Eh3jZOJvH1nZsRjMAHsgRoNuPKXjjH
	J3dXB1XhkoYBIq3usRx4VjnkIRHWO+KCVN/EKYwoFTakqaU4alcyQbQqSlNwDDxp+sbuFiUUXyw
	dxdREKGmTpSd/x3l1nFOR0ZAFdOhwmgY+q9G1Pto/BwObn4M0U+gFY4dx1k0L2XvtXYsSrs6cKm
	mpZKb48rdETnrxQCSsCP50acP58OTIXyuWIx66fMcaaRTC3GIzlZbeCYU4xwzN4RMhMj6lhCeT0
	7XDdVbf5QNAVU4v/I4T31TxaBuNyLsBkDjK8oCnb5KBt4aQ946JG6rIKlJ4JfyKfcVPQeBhQEPO
	g7Uwc9ldq8Tb8avIfeQScdhcOgU2Y28ZAFiEIcBGy8eJsI1zhO/5fimudK/EyQamDrcjfp+xGfX
	ewWxrAx16kiG5qWFtVLNeq833KX/
X-Received: by 2002:a05:690c:87:b0:8b1:7072:a61b with SMTP id 00721157ae682-8b1b5c1bb37mr34067887b3.22.1793221822309;
        Wed, 28 Oct 2026 14:10:22 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e61d044sm35031947b3.39.2026.10.28.14.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:10:21 -0700 (PDT)
Date: Wed, 28 Oct 2026 17:10:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
Message-ID: <auJkvb-Lq0M5Enkz@cmpxchg.org>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CBD6100008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rw8pbpbo8k7fsk3kwc4zc6nr9hyyf9t4
X-HE-Tag: 1793221823-22287
X-HE-Meta: U2FsdGVkX18p7ko+S6/VtBhwQ5xlB1PHuWSGOB454ywUsfKg3J5oMEj6PFpU2/L+JB3+CCxg2NhtzQ5fV4SIjuYfN75OxMb0LNXIHvcjEqEQzwnpW81X+aO9NPAgeU4Tm7eERmOlO6pkWlMo1WuMFe0WlF4y3+G092oGJ5MMasMEAikHTpL4ogHf6jzq20Fqt0eC3JmOFPt6VZLPhscSiIKL71mLjGZCrfpBwor7H+H1yGD5cX4Hs8RVbyzdWlHOBWKtXLZHRgK5mdIri0+CLdM3jobNlKf5L4FTkUQu0JmPPrLP4qrDPUQcIVi+H+ig6FfbUAyaDtBQzp44I09zl8n8K5CIv4IDWgcO3wXQcTThV9rPENMi7exFTjOGW/hCKb8UfQjsqr07ywUdETc5BzQUS9z7yeywycAK7/sMH5c7krCdMmqtBqSxFXvJtHwQaBCv//v4HZ7SHw5VD4iD9p6ePCydEm4+rIB0Zm0bKbpVwhfhCaDs9VIcwM9v+jrfaZlBjzTRJmJob6vwRPMrid6yFgGfzqyOKdmc/C5N1Bfn9K0j4ABs8wOCkNyhU82ODl6LJRmzHo4JZf0Iv1WFqM0sdBeDHle16ovLfipQ0tJlKDaZtdZH8cr5vDZUyITjJHfCB85VADN2EQ6ZR6VLWy3ZVkGUWLoA6G52qoWlQE1jvG7hhtzuvUvX1LRlYwAVP93YCLlMgVOklIm7WM29dONKQFmUVzF+fsiMOaZMN5mhStK6/hXo/nUP9Le9Ycv/c8/SwMUq+rDd85EG7T6X+fbi5a/MqltD9fFTURmLLOtJsydhtwGIKuH75jA1t/eDONuSDT4mQIWyV5v4ADzjpfqRZkOhF4dFioNt/K1ALz0DJ2osFA+gD/+ETKkjqUK0Wt6AON8zdbOBYjHhT4oSrLsK/GiOAC1dIkiC9moz9mRdiozMTYNqA9WR7JMXT5AhmyFUu4yka6UhyAXfxZc
 wmPTqz35
 XVYZ3XMp5Csr/mE8uAh0G9Z3/dDvj1wpftvjaViq+I0iCNJx/Es04ovsUqJEq7TLP9xdvE4Fn/pZNS7KA7ZRSMcj37/m8RiHmXTXBx8SglMOCX3mLELPI4JjnPtaYZRqyiRfGXF/n/OgjrYfseBlUdkTQZiZIo95zklld/jluOiL8QShZerIgtE8yiphQsMgJ0JXVu7GWIu5gBTx/Ok97alUL3WVMN3TJrjSOhxGaoOs0NkjHA2BKqRwzEYjoc8NC5r6T4fYkzrFt8FvQpSG6hF9fzqoe9l4rLFsl5P+m9MSrVNKrb0ZZiBTBUkzWF1QOqg8ULymlk9fAa5iqhQ7ZKvzG6OTMTKI6KeBRjfgYEUJ0V4RWwnSabddxiln5jzIC0l6GbTEkZG9k6hwqfXxJ8tnWGsryW80eKYmVsLe3VMTGngyYYECTLstj4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> >
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >
> > Successful writeback calls zswap_entry_free(), which removes the entry
> > from the LRU and decrements both the sublist and node item counts.
> > shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> > to decrement the node count again.
> 
> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
> LRU_DELETED instead to simply avoid the decrement.

It bugs me that it's the walker, not the callback, that adjusts the
count. That composes poorly with the normal list manipulation API.

How about pushing the accounting into the isolation callback, which
can then simply use __list_lru_del()?

The tradeoff is that more things need to be passed into the isolation
callback, but that seems reasonable. It does make the change noisy,
however, and we might want something like Kaitao's change as a
backportable fix first regardless.

Thoughts?

---

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index b0c797523bc2..157256e52dd0 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -24,7 +24,7 @@
 use kernel::{
     bindings,
     error::Result,
-    ffi::{c_ulong, c_void},
+    ffi::{c_int, c_ulong, c_void},
     mm::{virt, Mm, MmWithUser},
     new_mutex, new_spinlock,
     page::{Page, PAGE_SHIFT, PAGE_SIZE},
@@ -684,8 +684,10 @@ fn drop(self: Pin<&mut Self>) {
 /// Called by the shrinker.
 #[no_mangle]
 unsafe extern "C" fn rust_shrink_free_page(
+    lru: *mut bindings::list_lru,
+    l: *mut bindings::list_lru_one,
     item: *mut bindings::list_head,
-    lru: *mut bindings::list_lru_one,
+    nid: c_int,
     _cb_arg: *mut c_void,
 ) -> bindings::lru_status {
     // Fields that should survive after unlocking the lru lock.
@@ -728,7 +730,7 @@ fn drop(self: Pin<&mut Self>) {
         };
 
         // SAFETY: The item is in this lru list, so it's okay to remove it.
-        unsafe { bindings::list_lru_isolate(lru, item) };
+        unsafe { bindings::__list_lru_del(lru, l, item, nid) };
 
         // SAFETY: Both pointers are in bounds of the same allocation.
         page_index = unsafe { info.offset_from(inner.pages) } as usize;
@@ -746,7 +748,7 @@ fn drop(self: Pin<&mut Self>) {
     }
 
     // SAFETY: The lru lock is locked when this method is called.
-    unsafe { bindings::spin_unlock(&raw mut (*lru).lock) };
+    unsafe { bindings::spin_unlock(&raw mut (*l).lock) };
 
     if let Some(vma) = check_vma(&vma_read, range_ptr) {
         let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 1bf37023fed6..2e858c05e30b 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -345,13 +345,14 @@ static void ttm_pool_type_give(struct ttm_pool_type *pt, struct page *p)
 	mod_lruvec_page_state(p, NR_GPU_RECLAIM, num_pages);
 }
 
-static enum lru_status take_one_from_lru(struct list_head *item,
-					 struct list_lru_one *list,
+static enum lru_status take_one_from_lru(struct list_lru *lru,
+					 struct list_lru_one *l,
+					 struct list_head *item, int nid,
 					 void *cb_arg)
 {
 	struct page **out_page = cb_arg;
 	struct page *p = container_of(item, struct page, lru);
-	list_lru_isolate(list, item);
+	__list_lru_del(lru, l, item, nid);
 
 	*out_page = p;
 	return LRU_REMOVED;
@@ -387,13 +388,14 @@ static void ttm_pool_type_init(struct ttm_pool_type *pt, struct ttm_pool *pool,
 	spin_unlock(&shrinker_lock);
 }
 
-static enum lru_status pool_move_to_dispose_list(struct list_head *item,
-						 struct list_lru_one *list,
+static enum lru_status pool_move_to_dispose_list(struct list_lru *lru,
+						 struct list_lru_one *l,
+						 struct list_head *item, int nid,
 						 void *cb_arg)
 {
 	struct list_head *dispose = cb_arg;
 
-	list_lru_isolate_move(list, item, dispose);
+	__list_lru_move(lru, l, item, nid, dispose);
 
 	return LRU_REMOVED;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 37d021d22a7d..ce8063c2f5a6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -556,24 +556,26 @@ static void d_shrink_add(struct dentry *dentry, struct list_head *list)
  * LRU lists entirely, while shrink_move moves it to the indicated
  * private list.
  */
-static void d_lru_isolate(struct list_lru_one *lru, struct dentry *dentry)
+static void d_lru_isolate(struct list_lru *lru, struct list_lru_one *l,
+			  struct dentry *dentry, int nid)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags &= ~DCACHE_LRU_LIST;
 	this_cpu_dec(nr_dentry_unused);
 	if (d_is_negative(dentry))
 		this_cpu_dec(nr_dentry_negative);
-	list_lru_isolate(lru, &dentry->d_lru);
+	__list_lru_del(lru, l, &dentry->d_lru, nid);
 }
 
-static void d_lru_shrink_move(struct list_lru_one *lru, struct dentry *dentry,
+static void d_lru_shrink_move(struct list_lru *lru, struct list_lru_one *l,
+			      struct dentry *dentry, int nid,
 			      struct list_head *list)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags |= DCACHE_SHRINK_LIST;
 	if (d_is_negative(dentry))
 		this_cpu_dec(nr_dentry_negative);
-	list_lru_isolate_move(lru, &dentry->d_lru, list);
+	__list_lru_move(lru, l, &dentry->d_lru, nid, list);
 }
 
 static void ___d_drop(struct dentry *dentry)
@@ -1308,8 +1310,8 @@ void shrink_dentry_list(struct list_head *list)
 }
 EXPORT_SYMBOL(shrink_dentry_list);
 
-static enum lru_status dentry_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+static enum lru_status dentry_lru_isolate(struct list_lru *lru,
+		struct list_lru_one *l, struct list_head *item, int nid, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -1329,7 +1331,7 @@ static enum lru_status dentry_lru_isolate(struct list_head *item,
 	 * another pass through the LRU.
 	 */
 	if (dentry->d_lockref.count) {
-		d_lru_isolate(lru, dentry);
+		d_lru_isolate(lru, l, dentry, nid);
 		spin_unlock(&dentry->d_lock);
 		return LRU_REMOVED;
 	}
@@ -1360,7 +1362,7 @@ static enum lru_status dentry_lru_isolate(struct list_head *item,
 		return LRU_ROTATE;
 	}
 
-	d_lru_shrink_move(lru, dentry, freeable);
+	d_lru_shrink_move(lru, l, dentry, nid, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
@@ -1389,8 +1391,8 @@ long prune_dcache_sb(struct super_block *sb, struct shrink_control *sc)
 	return freed;
 }
 
-static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+static enum lru_status dentry_lru_isolate_shrink(struct list_lru *lru,
+		struct list_lru_one *l, struct list_head *item, int nid, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -1403,7 +1405,7 @@ static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
 	if (!spin_trylock(&dentry->d_lock))
 		return LRU_SKIP;
 
-	d_lru_shrink_move(lru, dentry, freeable);
+	d_lru_shrink_move(lru, l, dentry, nid, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b2984fb7b35c..c8afe8236805 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -148,8 +148,8 @@ static void gfs2_qd_list_dispose(struct list_head *list)
 }
 
 
-static enum lru_status gfs2_qd_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+static enum lru_status gfs2_qd_isolate(struct list_lru *lru,
+		struct list_lru_one *l, struct list_head *item, int nid, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct gfs2_quota_data *qd =
@@ -162,7 +162,7 @@ static enum lru_status gfs2_qd_isolate(struct list_head *item,
 	status = LRU_SKIP;
 	if (qd->qd_lockref.count == 0) {
 		lockref_mark_dead(&qd->qd_lockref);
-		list_lru_isolate_move(lru, &qd->qd_lru, dispose);
+		__list_lru_move(lru, l, &qd->qd_lru, nid, dispose);
 		status = LRU_REMOVED;
 	}
 
diff --git a/fs/inode.c b/fs/inode.c
index 1cb6293b237a..675f4a8b9d95 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -929,8 +929,8 @@ EXPORT_SYMBOL_GPL(evict_inodes);
  * LRU does not have strict ordering. Hence we don't want to reclaim inodes
  * with this flag set because they are the inodes that are out of order.
  */
-static enum lru_status inode_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, void *arg)
+static enum lru_status inode_lru_isolate(struct list_lru *lru,
+		struct list_lru_one *l, struct list_head *item, int nid, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
@@ -951,7 +951,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (icount_read(inode) ||
 	    (inode_state_read(inode) & ~I_REFERENCED) ||
 	    !mapping_shrinkable(&inode->i_data)) {
-		list_lru_isolate(lru, &inode->i_lru);
+		__list_lru_del(lru, l, &inode->i_lru, nid);
 		spin_unlock(&inode->i_lock);
 		this_cpu_dec(nr_unused);
 		return LRU_REMOVED;
@@ -974,7 +974,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&lru->lock);
+		spin_unlock(&l->lock);
 		reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
 		if (current_is_kswapd())
 			__count_vm_events(KSWAPD_INODESTEAL, reap);
@@ -987,7 +987,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 	WARN_ON(inode_state_read(inode) & I_NEW);
 	inode_state_set(inode, I_FREEING);
-	list_lru_isolate_move(lru, &inode->i_lru, freeable);
+	__list_lru_move(lru, l, &inode->i_lru, nid, freeable);
 	spin_unlock(&inode->i_lock);
 
 	this_cpu_dec(nr_unused);
diff --git a/fs/nfs/nfs42xattr.c b/fs/nfs/nfs42xattr.c
index 37d79400e5f4..17eb14b40830 100644
--- a/fs/nfs/nfs42xattr.c
+++ b/fs/nfs/nfs42xattr.c
@@ -801,8 +801,8 @@ static struct shrinker *nfs4_xattr_entry_shrinker;
 static struct shrinker *nfs4_xattr_large_entry_shrinker;
 
 static enum lru_status
-cache_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, void *arg)
+cache_lru_isolate(struct list_lru *lru, struct list_lru_one *l,
+	struct list_head *item, int nid, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct inode *inode;
@@ -827,7 +827,7 @@ cache_lru_isolate(struct list_head *item,
 	cache->inode = NULL;
 	NFS_I(inode)->xattr_cache = NULL;
 	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_XATTR;
-	list_lru_isolate(lru, &cache->lru);
+	__list_lru_del(lru, l, &cache->lru, nid);
 
 	spin_unlock(&inode->i_lock);
 
@@ -866,8 +866,8 @@ nfs4_xattr_cache_count(struct shrinker *shrink, struct shrink_control *sc)
 }
 
 static enum lru_status
-entry_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, void *arg)
+entry_lru_isolate(struct list_lru *lru, struct list_lru_one *l,
+	struct list_head *item, int nid, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct nfs4_xattr_bucket *bucket;
@@ -896,7 +896,7 @@ entry_lru_isolate(struct list_head *item,
 
 		hlist_del_init(&entry->hnode);
 		atomic_long_dec(&cache->nent);
-		list_lru_isolate(lru, &entry->lru);
+		__list_lru_del(lru, l, &entry->lru, nid);
 
 		spin_unlock(&bucket->lock);
 	} else {
@@ -907,7 +907,7 @@ entry_lru_isolate(struct list_head *item,
 		kref_get(&entry->ref);
 
 		cache->listxattr = NULL;
-		list_lru_isolate(lru, &entry->lru);
+		__list_lru_del(lru, l, &entry->lru, nid);
 
 		spin_unlock(&cache->listxattr_lock);
 	}
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 17a94e6fcb15..6b9165e5c3c5 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -509,8 +509,10 @@ void nfsd_file_net_dispose(struct nfsd_net *nn)
 
 /**
  * nfsd_file_lru_cb - Examine an entry on the LRU list
- * @item: LRU entry to examine
  * @lru: controlling LRU
+ * @l: locked sublist of @lru that holds @item
+ * @item: LRU entry to examine
+ * @nid: node id of @l
  * @arg: dispose list
  *
  * Return values:
@@ -519,8 +521,8 @@ void nfsd_file_net_dispose(struct nfsd_net *nn)
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
-nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
-		 void *arg)
+nfsd_file_lru_cb(struct list_lru *lru, struct list_lru_one *l,
+		 struct list_head *item, int nid, void *arg)
 {
 	struct list_head *head = arg;
 	struct nfsd_file *nf = list_entry(item, struct nfsd_file, nf_lru);
@@ -554,7 +556,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	/* Refcount went to zero. Unhash it and queue it to the dispose list */
 	nfsd_file_unhash(nf);
-	list_lru_isolate(lru, &nf->nf_lru);
+	__list_lru_del(lru, l, &nf->nf_lru, nid);
 	list_add(&nf->nf_gc, head);
 	this_cpu_inc(nfsd_file_evictions);
 	trace_nfsd_file_gc_disposed(nf);
@@ -562,8 +564,8 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 }
 
 static enum lru_status
-nfsd_file_gc_cb(struct list_head *item, struct list_lru_one *lru,
-		 void *arg)
+nfsd_file_gc_cb(struct list_lru *lru, struct list_lru_one *l,
+		 struct list_head *item, int nid, void *arg)
 {
 	struct nfsd_file *nf = list_entry(item, struct nfsd_file, nf_lru);
 
@@ -576,7 +578,7 @@ nfsd_file_gc_cb(struct list_head *item, struct list_lru_one *lru,
 		trace_nfsd_file_gc_aged(nf);
 		return LRU_ROTATE;
 	}
-	return nfsd_file_lru_cb(item, lru, arg);
+	return nfsd_file_lru_cb(lru, l, item, nid, arg);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629c..436aca8f6619 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1467,8 +1467,10 @@ __xfs_buf_mark_corrupt(
  */
 static enum lru_status
 xfs_buftarg_drain_rele(
+	struct list_lru		*lru,
+	struct list_lru_one	*l,
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	int			nid,
 	void			*arg)
 
 {
@@ -1485,7 +1487,7 @@ xfs_buftarg_drain_rele(
 	}
 
 	xfs_buf_kill(bp);
-	list_lru_isolate_move(lru, item, dispose);
+	__list_lru_move(lru, l, item, nid, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
@@ -1560,8 +1562,10 @@ xfs_buftarg_drain(
 
 static enum lru_status
 xfs_buftarg_isolate(
+	struct list_lru		*lru,
+	struct list_lru_one	*l,
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	int			nid,
 	void			*arg)
 {
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
@@ -1581,7 +1585,7 @@ xfs_buftarg_isolate(
 	 * yet.
 	 */
 	if (bp->b_lockref.count > 0) {
-		list_lru_isolate(lru, &bp->b_lru);
+		__list_lru_del(lru, l, &bp->b_lru, nid);
 		spin_unlock(&bp->b_lockref.lock);
 		return LRU_REMOVED;
 	}
@@ -1597,7 +1601,7 @@ xfs_buftarg_isolate(
 	}
 
 	xfs_buf_kill(bp);
-	list_lru_isolate_move(lru, item, dispose);
+	__list_lru_move(lru, l, item, nid, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dd5011f578a6..3933dd222509 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -411,10 +411,12 @@ struct xfs_qm_isolate {
 
 static enum lru_status
 xfs_qm_dquot_isolate(
+	struct list_lru		*lru,
+	struct list_lru_one	*l,
 	struct list_head	*item,
-	struct list_lru_one	*lru,
+	int			nid,
 	void			*arg)
-		__releases(&lru->lock) __acquires(&lru->lock)
+		__releases(&l->lock) __acquires(&l->lock)
 {
 	struct xfs_dquot	*dqp = container_of(item,
 						struct xfs_dquot, q_lru);
@@ -450,7 +452,7 @@ xfs_qm_dquot_isolate(
 		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
-		list_lru_isolate(lru, &dqp->q_lru);
+		__list_lru_del(lru, l, &dqp->q_lru, nid);
 		XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 		return LRU_REMOVED;
 	}
@@ -473,7 +475,7 @@ xfs_qm_dquot_isolate(
 	lockref_mark_dead(&dqp->q_lockref);
 	spin_unlock(&dqp->q_lockref.lock);
 
-	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
+	__list_lru_move(lru, l, &dqp->q_lru, nid, &isol->dispose);
 	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index a450fffe1550..f6d94474a4c7 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -150,6 +150,15 @@ bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
 bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
 		struct list_head *item, int nid);
 
+/* Take @item off the locked sublist @l and put it on a private list @head */
+static inline void __list_lru_move(struct list_lru *lru, struct list_lru_one *l,
+				   struct list_head *item, int nid,
+				   struct list_head *head)
+{
+	__list_lru_del(lru, l, item, nid);
+	list_add(item, head);
+}
+
 /**
  * list_lru_add: add an element to the lru list's tail
  * @lru: the lru pointer
@@ -271,12 +280,9 @@ static inline unsigned long list_lru_count(struct list_lru *lru)
 	return count;
 }
 
-void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
-void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
-			   struct list_head *head);
-
-typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
-		struct list_lru_one *list, void *cb_arg);
+typedef enum lru_status (*list_lru_walk_cb)(struct list_lru *lru,
+		struct list_lru_one *l, struct list_head *item, int nid,
+		void *cb_arg);
 
 /**
  * list_lru_walk_one: walk a @lru, isolating and disposing freeable items.
@@ -289,11 +295,14 @@ typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
  * @nr_to_walk: how many items to scan.
  *
  * This function will scan all elements in a particular @lru, calling the
- * @isolate callback for each of those items, along with the current list
- * spinlock and a caller-provided opaque. The @isolate callback can choose to
+ * @isolate callback for each of those items, along with the locked sublist
+ * and a caller-provided opaque. The @isolate callback can choose to
  * drop the lock internally, but *must* return with the lock held. The callback
  * will return an enum lru_status telling the @lru infrastructure what to
- * do with the object being scanned.
+ * do with the object being scanned. A callback that takes the item off
+ * the lru does so with __list_lru_del() or __list_lru_move(), or with
+ * list_lru_del() once it has dropped the lock, and returns LRU_REMOVED
+ * or LRU_REMOVED_RETRY.
  *
  * Please note that @nr_to_walk does not mean how many objects will be freed,
  * just how many objects will be scanned.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..87722e1a7eee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4638,8 +4638,9 @@ static bool thp_underused(struct folio *folio)
 	return false;
 }
 
-static enum lru_status deferred_split_isolate(struct list_head *item,
-					      struct list_lru_one *lru,
+static enum lru_status deferred_split_isolate(struct list_lru *lru,
+					      struct list_lru_one *l,
+					      struct list_head *item, int nid,
 					      void *cb_arg)
 {
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
@@ -4649,7 +4650,7 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	if (!folio_try_get(folio))
 		return LRU_SKIP;
 
-	list_lru_isolate_move(lru, item, freeable);
+	__list_lru_move(lru, l, item, nid, freeable);
 	return LRU_REMOVED;
 }
 
diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..9469117aa424 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -218,6 +218,7 @@ bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(__list_lru_del);
 
 /* The caller must ensure the memcg lifetime. */
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
@@ -291,21 +292,6 @@ bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 }
 EXPORT_SYMBOL_GPL(list_lru_del_obj);
 
-void list_lru_isolate(struct list_lru_one *list, struct list_head *item)
-{
-	list_del_init(item);
-	list->nr_items--;
-}
-EXPORT_SYMBOL_GPL(list_lru_isolate);
-
-void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
-			   struct list_head *head)
-{
-	list_move(item, head);
-	list->nr_items--;
-}
-EXPORT_SYMBOL_GPL(list_lru_isolate_move);
-
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg)
 {
@@ -338,7 +324,6 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		    list_lru_walk_cb isolate, void *cb_arg,
 		    unsigned long *nr_to_walk, bool irq_off)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l = NULL;
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
@@ -359,7 +344,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			break;
 		--*nr_to_walk;
 
-		ret = isolate(item, l, cb_arg);
+		ret = isolate(lru, l, item, nid, cb_arg);
 		switch (ret) {
 		/*
 		 * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop the lru
@@ -371,7 +356,6 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			fallthrough;
 		case LRU_REMOVED:
 			isolated++;
-			atomic_long_dec(&nlru->nr_items);
 			if (ret == LRU_REMOVED_RETRY)
 				goto restart;
 			break;
diff --git a/mm/shmem.c b/mm/shmem.c
index 3c0c7edd2020..e4c1d9dfcfa2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -852,8 +852,9 @@ struct shmem_unused_huge_scan {
 	struct shrink_control *sc;
 };
 
-static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
-						 struct list_lru_one *lru,
+static enum lru_status shmem_unused_huge_isolate(struct list_lru *lru,
+						 struct list_lru_one *l,
+						 struct list_head *item, int nid,
 						 void *arg)
 {
 	struct shmem_unused_huge_scan *scan = arg;
@@ -874,14 +875,14 @@ static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
 	inode = igrab(&info->vfs_inode);
 	/* inode is about to be evicted */
 	if (!inode) {
-		list_lru_isolate(lru, item);
+		__list_lru_del(lru, l, item, nid);
 		objcg = shmem_get_and_clear_objcg(info);
 		spin_unlock(&info->lock);
 		obj_cgroup_put(objcg);
 		return LRU_REMOVED;
 	}
 
-	list_lru_isolate(lru, item);
+	__list_lru_del(lru, l, item, nid);
 	objcg = shmem_get_and_clear_objcg(info);
 	set_shmem_unused_huge_isolated(info);
 	list_add_tail(&info->shrinklist, &scan->list);
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..c5d5690bda9f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -706,9 +706,10 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 	return nodes - max_nodes;
 }
 
-static enum lru_status shadow_lru_isolate(struct list_head *item,
-					  struct list_lru_one *lru,
-					  void *arg) __must_hold(lru->lock)
+static enum lru_status shadow_lru_isolate(struct list_lru *lru,
+					  struct list_lru_one *l,
+					  struct list_head *item, int nid,
+					  void *arg) __must_hold(l->lock)
 {
 	struct xa_node *node = container_of(item, struct xa_node, private_list);
 	struct address_space *mapping;
@@ -717,20 +718,20 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 	/*
 	 * Page cache insertions and deletions synchronously maintain
 	 * the shadow node LRU under the i_pages lock and the
-	 * &lru->lock. Because the page cache tree is emptied before
-	 * the inode can be destroyed, holding the &lru->lock pins any
+	 * &l->lock. Because the page cache tree is emptied before
+	 * the inode can be destroyed, holding the &l->lock pins any
 	 * address_space that has nodes on the LRU.
 	 *
 	 * We can then safely transition to the i_pages lock to
 	 * pin only the address_space of the particular node we want
-	 * to reclaim, take the node off-LRU, and drop the &lru->lock.
+	 * to reclaim, take the node off-LRU, and drop the &l->lock.
 	 */
 
 	mapping = container_of(node->array, struct address_space, i_pages);
 
 	/* Coming from the list, invert the lock order */
 	if (!xa_trylock(&mapping->i_pages)) {
-		spin_unlock_irq(&lru->lock);
+		spin_unlock_irq(&l->lock);
 		ret = LRU_RETRY;
 		goto out;
 	}
@@ -739,16 +740,16 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 	if (mapping->host != NULL) {
 		if (!spin_trylock(&mapping->host->i_lock)) {
 			xa_unlock(&mapping->i_pages);
-			spin_unlock_irq(&lru->lock);
+			spin_unlock_irq(&l->lock);
 			ret = LRU_RETRY;
 			goto out;
 		}
 	}
 
-	list_lru_isolate(lru, item);
+	__list_lru_del(lru, l, item, nid);
 	__dec_node_page_state(virt_to_page(node), WORKINGSET_NODES);
 
-	spin_unlock(&lru->lock);
+	spin_unlock(&l->lock);
 
 	/*
 	 * The nodes should only contain one or more shadow entries,
diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..72eae0745b62 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1177,8 +1177,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  *    can expect from writeback. We scale down the number of objects available
  *    for reclaim by this ratio.
  */
-static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
-				       void *arg)
+static enum lru_status shrink_memcg_cb(struct list_lru *lru, struct list_lru_one *l,
+				       struct list_head *item, int nid, void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
 	bool *encountered_page_in_swapcache = (bool *)arg;
-- 
2.56.0

