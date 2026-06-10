Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAE3CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CA36B008C; Wed, 10 Jun 2026 19:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252AA6B0092; Wed, 10 Jun 2026 19:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191B26B0093; Wed, 10 Jun 2026 19:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F22506B0092
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA3C51C2936
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:16 +0000 (UTC)
X-FDA: 84865533312.21.B972928
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D327140010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ERTAsX17;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132654;
	b=QZDiR1Fb9ouNxSooAvoUgVFNcY+juAhA3vfjBx9uvx6ANreF11AKH5VkwAm7CBrwgERiTb
	zg/Dqvbl0cy4xBfTehDlFpFbIseYRTI9bZSTmhrDLbVgfte4DUmIbwwmlBhjmaLzZSw7Nt
	FKeLFguhSEgV8Q3Z24ph8rM9r2iXx+s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ERTAsX17;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=lxYg1yOYbOPEDww1HFkCBQX/HCVLw+E+Y93nZmk4owE=;
	b=5wtbq8y55t5Li3Jx632QN4yrvdUgqguUI4TMaNg9U3NaNGOYvf357etZ4MIU5/8+BhKMzl
	BOkzNC/wMvgF3gGfAgMbjXYBWjAEROtB3ywk+M2WNQ4RpaJUhAoMBG8Klz1cxMWVyQuCX/
	qg2Ry0xzLT3OxlvEJWU7g5ETgIxbU8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132655; x=1812668655;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=bGrO4j/lpP7M6LZSDYm0KbIMb33OWQa142k1+jPLkOg=;
  b=ERTAsX17FyBAZ2CrQJAZ27iJiA3YqniNIlgdpdpsl85kOtNC4nKNokn/
   +FVuNlxdlmIW9Z9P8pLuGy76ZnII2MLYwpUwz6mphNQzwsb4rfLB2Ln+H
   QlwkGyBag4FQv9yH4CzSqT4YHT9+OZP2mI25ieshdKf/1TS++iTfr8Kkh
   Y8QjkLzmGiC0L7JuFY7s1Su2bwKnObOA21k2ncpKf00iQp2ZYgng44pZS
   hy2tVrmJxn49TYNqd8CgWOBIncsgbu5ncys0kJ+a9mXpUZlfI4CT4SRED
   yfpQ6+/n8dbfTNprxtdDZX5DwT9FAlZi1W2OVN226MUlExX+eH4t+RlHy
   g==;
X-CSE-ConnectionGUID: bq4NPujHRluShGvNk4zbqw==
X-CSE-MsgGUID: m9iA2hONRZW48oJU8+53tA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="104603441"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="104603441"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:14 -0700
X-CSE-ConnectionGUID: AMr6fb/URwe10q+BucvLUg==
X-CSE-MsgGUID: QxSHOM1hSKuX8djjKlIzxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251409772"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 10 Jun 2026 16:04:13 -0700
Subject: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:13 -0700
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
Message-Id: <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
X-Rspamd-Queue-Id: 7D327140010
X-Stat-Signature: s673qg61tzez7bhhym5j3bkjfuw6wzd5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781132654-702786
X-HE-Meta: U2FsdGVkX18epFsiokSdp3kWw19i7yViwKaPl+HHrRL2b+8cIlT1D15mbgLEjFbxEhJeUuJCqSSxwDmbsRQXHwlAFf4YhCZfLD+pYkeOYvNTmoPq28w2tGTa8kEvfjmKaEi2DP6sNG6UPHWJ+iPGONl878whR1p0Xd504MsbGQw+X9+tkwwfq9pIWwG4Fw9o/Ui9DNWgY24GgNystgMozZAmnP6KGWImZ+eNn4y63ifOVHQqHtc6/15+mIMRrr08rBlBG3XFU7HNRfqMvy4iwBM4psFXIgO1fo8Whe8uNkfV1RLUlFnHdIZORPP9gWeOSwX6xx05wRQX5JNuVX7AsRGpAlPMfk4HBM5ZcXVsm9U4glGZQr69MTH7x/dvwc2gct+2v+ObPwLGh9hRyCWDtsrUsraqzArvfyRcxwxjtrXLQb2xRCOBpspYUFCHtmrsBO+fJB5wMHWEH+ZLHchXRQBnk7IDuew1V6jcCL7HzEFBsbY/TPL2Ko1wZ+uxPGuZwSc1ZOSIAl6glDXcFZdsVBW/lda/igE9CLHXvWIYp47kZ8ZGUU0lvZqYhd+8W84xs0yK84inSFJp7tefNPcAMjCTcZBT2X7pgEb5bvhidsN6lf2fByvIN+4TXzW/n2me37p1vnN0jeNBl/ZzPEEP5L94EgkxKj1nwwC+a3Rd454QXVJaVt/KZgQOi4Fi58fqJdk1TxhAlAmDOrsathpNvIrl+GbavArUch52HmEjIKH7RfwpwC/3MhAMLL86CzKgDPlaAIMlpfaGQJzu83pxoZPDFbtFKYM6RIlwHRunvqIeZnGTqrhCIEe7oFBZ97XaErJ0iniTtiV1RV7qkbdpc0OxbQQqlao0KpANx8fpEHQ2R0QBCq4AYikbjXMFgLX7Ln5YpXhqiGGflCfbBbcgOS3ltHV3e220J2xfU1W62fQgiQjp7qxzLXcikBaCR6o9SttrBahk3Q4nFVP979y
 FzCQr8U5
 pSm7POck4tmdrhs2jOSyaiEqj7U/A0II8RCaB4oRkw38J0JyAsdngfOsGWmZE3G7ibZkMEaGdR0zhZgMcdeqQ+h9wCcK94NyyHW72m/HtWmCw7mljQAryeOwxVt+BrayFCrDXnxoOMTUQUKMU5nsmAdlRMZ4McYAwp2iCiPLua7t4gImYl8zUKcp5Yc7RUnkiof+j9a/LpYUFOeW/FSSZVAo2opXF2G0gEyylW4J6j8SAyBmUCk8G3DODEJTBKsy9oH0uwNL/GBZ2nWsMhhM+v7dGFzC/sbieD+gZSgVvyrnhPOkJMExvkX+s2bm4scPa9QR967U3mtxXIi5llPLwK72S7oRTUzVvFfB14xrU1k+DF4Ir8j6iSZ9EIuYXIciv6ntkSNwiCzwLbGkjIs+KXWWWWt5nag5rl2Tie0qqjJzovmuIVAWZqQqAb26kusUtQ+sTzgOC46Unxrls8RzIgfJgR90RMUAs7s1NX6FANcLvxNH6l/8Q2RphSIouWkFwaEk0JVNHiqJErwL2MYaU5hEQc/LMH4ai5DrcUOg3FV7QnIXl9lpJcjQ8u7Ia/nEB0ck1/c1zSnx0oWpt+aZC4QTewWRr9w/Gs3Ij2wf9yS+yuwb+c2XTHAR7tqYQlnaIvM8HGPhdnR6iFmcvMkuHdK5zHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
it and mmap_read_trylock().

Long Version:

== Background ==

Historically, binder used an mmap_read_trylock() in its shrinker code.
This ensures that reclaim is not blocked on an mmap_lock. Commit
95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
support for the per-VMA lock, but left mmap_read_trylock() as a
fallback.

This was presumably because the per-VMA locking can fail for several
reasons and most (all?) lock_vma_under_rcu() callers have a fallback
to mmap_read_trylock().

== Problem ==

The fallback is not worth the complexity here. lock_vma_under_rcu() is
essentially already a non-blocking trylock. The main reason it fails
is also the reason mmap_read_trylock() fails: something is holding
mmap_write_lock().

The only remedy for a collision with mmap_write_lock() is to wait,
which this code can not do. So the "fallback" after
lock_vma_under_rcu() failure is not really a fallback: it is really
likely to just be retrying in vain. That retry in an of itself isn't
horrible. But it adds complexity.

== Solution ==

Now that per-VMA locks are universally available, lock_vma_under_rcu()
will not persistently fail. Rely on it alone and simplify the code.

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics. Claude caught this in a review and suggested the
approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
I guess.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

--

Changes from v1:
 * Move forward even if 'vma' is NULL in binder_alloc_free_page().
   This can happen if the VMA is unmapped (Sashiko).
 * Rename goto label to be more accurate for new lock scheme


---

 b/drivers/android/binder_alloc.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/android/binder_alloc.c
--- a/drivers/android/binder_alloc.c~binder-try-vma-lock	2026-06-10 15:57:55.274412018 -0700
+++ b/drivers/android/binder_alloc.c	2026-06-10 15:57:55.277412124 -0700
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked = 0;
 	size_t index;
 
 	if (!mmget_not_zero(mm))
@@ -1151,15 +1150,12 @@ enum lru_status binder_alloc_free_page(s
 	index = mdata->page_index;
 	page_addr = alloc->vm_start + index * PAGE_SIZE;
 
-	/* attempt per-vma lock first */
+	/*
+	 * Attempt per-vma lock. This is essentially a
+	 * "trylock". It can fail even if the VMA exists
+	 * for 'page_addr'.
+	 */
 	vma = lock_vma_under_rcu(mm, page_addr);
-	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked = 1;
-		vma = vma_lookup(mm, page_addr);
-	}
 
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
@@ -1188,13 +1184,11 @@ enum lru_status binder_alloc_free_page(s
 		zap_vma_range(vma, page_addr, PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
+
+		vma_end_read(vma);
 	}
 
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
-		vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
 
@@ -1203,11 +1197,9 @@ enum lru_status binder_alloc_free_page(s
 err_invalid_vma:
 	mutex_unlock(&alloc->mutex);
 err_get_alloc_mutex_failed:
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
-err_mmap_read_lock_failed:
+err_vma_lock_failed:
 	mmput_async(mm);
 err_mmget:
 	return LRU_SKIP;
_

