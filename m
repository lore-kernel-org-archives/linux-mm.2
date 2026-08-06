Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C687BC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804636B00A1; Thu,  6 Aug 2026 16:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF376B00A2; Thu,  6 Aug 2026 16:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677086B00A3; Thu,  6 Aug 2026 16:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 398FB6B00A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:05:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F8F4C0224
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:58 +0000 (UTC)
X-FDA: 85071925596.11.8E6D4AF
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id C04B2140014
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DDRoONMa;
	spf=pass (imf09.hostedemail.com: domain of 3I-l0agYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3I-l0agYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046756;
	b=EonuhyK0ILhNzqkxWiCHhsthuXA/fSbZrbxkJ31HFVFH+hQRUQFKUmRStrnEzjKbv/LyEj
	kTvlxELtm+FPWypOTFby4FV4bt/PtLYoAaBuT2sHrVxRELijDn/okek69eqBDDWtZdLVju
	gOm17AkRa4S+avOKB9vPJugOFG3dRRQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DDRoONMa;
	spf=pass (imf09.hostedemail.com: domain of 3I-l0agYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3I-l0agYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myw2oDUjCx3VpKcfHammnirgTkZxfVTM2uRSXVRFIyw=;
	b=wv/i0ZT4yAF6odkzSQmUDYFeqVg9ZB9kAo4bmdyA3P7Wjb7hSztm9yIYTrx6Mji8D0iMmN
	wPUivwbbhFAC7ezNU/zla4IeLUvxr+56i6PsPYD4B9br9JaWJuJWZK7pO+ASIqMlNH9sm2
	KYsBN54DoUJQ4kDsbv7gjumLISF0f1s=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so3045503a91.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 13:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786046756; x=1786651556; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=myw2oDUjCx3VpKcfHammnirgTkZxfVTM2uRSXVRFIyw=;
        b=DDRoONMaQZyKPDEW+koUzpTOl8cGbpSpXB6Ejpm0lcNknokPBSnsAcxetKAwPrYMYs
         6zhbay5w+C2wcbejR0IWJvimnd5qjiHBcefhb4Y0lJ4mHV31332gAPsTGiNblfo9BFLu
         wrpi1S7r3BjEYRiRiYa+dQox99ePK84OkuTSJRn0bEm4hWkgrAwe+F3df2Qh7dV9IGYV
         eIilgCkiXssktdHPj/M1/zqmVy5MRnH7qQ+Wlz4GpMeuv6qoLh3B8mnP6tgkhewkNxyp
         p1WHJSRzl8SCaIbzsqWvTmvCTvPb2BL+oIhsaiERwgFQBOfidFF+mvHBBy/nxFQzgpc/
         9OCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786046756; x=1786651556;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myw2oDUjCx3VpKcfHammnirgTkZxfVTM2uRSXVRFIyw=;
        b=T7vo3j58Z/17YHFFHlebccHxFOq1AvMXamsyrVaBCAcqirdsNq+3Oh/RDR02C/S+23
         lCQhbyB01Y98mV3a7mYHKXCILvWDujhrLR9ZIy21WekclKXVui07PRmsHyTnNHl5qd8Y
         KfqVgP4BqFHH3sCxFt9BGfQRH6O/MYvdDDeYcX66hMLyhroVibBSH3nPIa37aXZjTsmP
         23/I+ZmUz0DBFILvCaH5YHvBLBvhod1tfUfXLgKydcE30wFZMe7/XzpYU+IPXqxSPISf
         0FMmPTUoom9U0KRQB7J/K2XSs89BV6IvoxywQeR7g9uG9i3Ugyj+u2zriFR9u4q+r0kt
         7Txw==
X-Forwarded-Encrypted: i=1; AHgh+Rq1X3GPjSU2gmVNh9GVrl5mlgo1ufk12LF7KZCY8rwzv3bzT0GSrZQ+kf6H02asUzgZtyyDAX3WIA==@kvack.org
X-Gm-Message-State: AOJu0YyTI5yjOkF79FSWDYpwNYa6kR5+dYyTbOJw7OiBHGGMsF0DGRIi
	7RElO0Nc/lOllWBe26BDrkOFznzLadfxOlkB10JLlSoUT0GbYfHrTGvBCsi5bzp6owVjIcxDqrr
	YPrx8+Q==
X-Received: from dlam21-n2.prod.google.com ([2002:a05:701b:2095:20b0:13c:f3ec:de27])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d50:b0:380:f34a:6ff1
 with SMTP id 98e67ed59e1d1-3903c5e0213mr17427991a91.17.1786046755489; Thu, 06
 Aug 2026 13:05:55 -0700 (PDT)
Date: Thu,  6 Aug 2026 13:05:45 -0700
In-Reply-To: <20260806200548.3124802-1-surenb@google.com>
Mime-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806200548.3124802-3-surenb@google.com>
Subject: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C04B2140014
X-Stat-Signature: kb78k5zfnsc7a1h3o6jct6d9gw1ts37y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786046756-978458
X-HE-Meta: U2FsdGVkX187Jp6RIoLtgprOY4EhSxKwnD0ZsceiCY4Vv2PEgccjFhTkswmxkKZh0orrZU82+7aXzRzte1nXO65EB3dSpg5HJECVk0ZBpQqYfr+Y/S8it6QjfaSDrErC4xMFHTjC05QGPAmQ8wlbxSxQfu0+CDf8UloCRT/A5VYWJtYcy6gBbPZUKMQcB5xhOMZpOrwjScvp1i4allP8VqjBRvvKyOf8tELTsLeJEYIkQHEu869hSM6e98DYTP5lOQ5H+7M+WbAMKQyrI3ow7Sd/2DH/1eyxFLYUqofxnBUodZDomsys1N3UIUOAJG6x6o6LSw9O2HTO1TrRPS/NIKx0dYk4iBu8/JQe2XfTmxBkbSY+futLt/j+zsEe2qlmuhEKA0+iZ9tI8rrKvFVUSZjpfnjxSEay1T9rUgagrobuRNl7/97FMclv2KYmRvscuZUK4qbzjR7PNbm4FArNHj50KcZwf4CgR1Je5ySjzK9B4at0ODpqJuuF90evDXWi4UqSk4SU7W+0fWOctMwFtYrGTeWj5zOHR8000GGsmEDxY+mTDViMG9cUGcZjWa7D5qzcZ8t+UKk4CaZs/4pwEbp+2oNAky81PYUS+T/56WwvXbRbLrpm7ZbUpCy01KjzvIdPOEAUc0oGfhXB6ulqfbf5dFKrmzAa6APwlI0i2eIKSGoOMNm+vODHd+HoA0ePGZqcchqoicdEnnkjk289C7SQt2rsNFaLnSsv/RhZgS0DXmBVn2GTguB4ZNbOAKJJN9UEpiHa6o/UDq8fRBuBZH8TCW5FHh8NJw0kduknp+MyE0yblJAYHz1oBueOcwAI9E1W/GUcdaXCn8yZkxDNvs6E0jnRFymKebMok8SUY8fZBXb6pYzFSm//t6GA6KwmbBrXtpFUWd+fIEagAXGgpYMeMDO+/8BNnKXHdNukXuv2b9Rs/Al94mIF+MkXV5txG1kjLI8SO60s0OIRRzH
 PPG1RsXO
 n+f8P4pXKSnTYQ2+v9NmTu78LQTbZDAVH84H92puTOb/k7KYr4ixbjANURDvwA9Mdo02Tq66KgxkIhoaMXe0nJyNodkfr+g1slqwlW2yFl1mAalrPhGfRnwcJ5zaCi0OutkQ1n9r3zmff5guQtj+AaHTukoBtG9pTeG+Jne+rnpi4iPDs0VT19mfJfpaKhC/Zqcx14e+DcUkhVzp5LUbyGcK2sjfCPl2YisolRm+0JwKr0ZD1wMNgiED783IM1kaYom5bX1Atq/KI0eEu6XquQ5V9CMIU4Yq3atnEWjbIQND/08cp6d+m4Bp2snaeAsvPP7u9CYy6GUSVC2/F7adngV/CAdgT/lkq1C+QJJiitILIpT68A+J+zGlFxgRLioTcjiVr4lpFnVLYdbQ+Mmx4fqWYbGt29j2vS7pYB9l97sEklQFNhVN8DqzGsC6IGbhnnZqBkTr9BkdMp4UwXmrTCJdIcHFGa8HYqzagkCyhWiBmJ+mysO0bbi3wNl1x1hhdogHceVs17N1gfjyuY99o3XD3iJaWZAkUNBNutwOhp6arSGrsb4S1W8IZtmUKRh2j6b/xl5tOjQamPPz8lGig2/3raADAOCiv3HnvhlM5+6bymNtnvvHNyMNCPxfx1dh2EL2A7tm9MD1oV9YgmUUjeksQAIDt88RcS3bPPIXfMn/Uc5OClkRQyf+7QAUE8qg5W3L8hB77QC5/YVOrBmyMZvhAitxDZhEz+RqplyaXzYALPDcnfrTScjKTzkwGmJhyeR8zc3NwIPD4IWul3X9UFpG+IgIZ4X35OnDx+TJygqraDm/XmkYWVWurf/T4K/mI4VeCKJCVq47bWmi2tXlvzUA8nyjo7W061imaTkELThyuSpzpEqbDMCoZ03ied6Inh4+N7dWBrF6QfOEWVOzLpsKJKy28Czu7ClmYuZrKHQ08yW128n2MO4gySQAcnbp1KnR3
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

=3D=3D Background =3D=3D

Historically, binder used an mmap_read_trylock() in its shrinker code.
This ensures that reclaim is not blocked on an mmap_lock. Commit
95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
support for the per-VMA lock, but left mmap_read_trylock() as a
fallback.

This was presumably because the per-VMA locking can fail for several
reasons and most (all?) lock_vma_under_rcu() callers have a fallback
to mmap_read_trylock().

=3D=3D Problem =3D=3D

The fallback is not worth the complexity here. lock_vma_under_rcu() is
essentially already a non-blocking trylock. The main reason it fails
is also the reason mmap_read_trylock() fails: something is holding
mmap_write_lock().

The only remedy for a collision with mmap_write_lock() is to wait,
which this code can not do. So the "fallback" after
lock_vma_under_rcu() failure is not really a fallback: it is really
likely to just be retrying in vain. That retry in an of itself isn't
horrible. But it adds complexity.

=3D=3D Solution =3D=3D

Now that per-VMA locks are universally available, lock_vma_under_rcu()
will not persistently fail. Rely on it alone and simplify the code.
The removal of the fallback does not affect NOMMU case because binder
driver depends on CONFIG_MMU.

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics. Claude caught this in a review and suggested the
approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
I guess.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.=
c
index e4488ad86a65..c13a588c37de 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_he=
ad *item,
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked =3D 0;
 	size_t index;
=20
 	if (!mmget_not_zero(mm))
@@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct list_=
head *item,
 	index =3D mdata->page_index;
 	page_addr =3D alloc->vm_start + index * PAGE_SIZE;
=20
-	/* attempt per-vma lock first */
+	/*
+	 * Attempt per-vma lock. This is essentially a
+	 * "trylock". It can fail even if the VMA exists
+	 * for 'page_addr'.
+	 */
 	vma =3D lock_vma_under_rcu(mm, page_addr);
 	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked =3D 1;
-		vma =3D vma_lookup(mm, page_addr);
+		/*
+		 * If the vma exists, we can't continue because we cannot
+		 * remove the page from the vma. However, if the vma was
+		 * unmapped, it's okay to continue.
+		 */
+		if (binder_alloc_is_mapped(alloc))
+			goto err_vma_lock_failed;
 	}
=20
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
=20
-	/*
-	 * Since a binder_alloc can only be mapped once, we ensure
-	 * the vma corresponds to this mapping by checking whether
-	 * the binder_alloc is still mapped.
-	 */
-	if (vma && !binder_alloc_is_mapped(alloc))
-		goto err_invalid_vma;
-
 	trace_binder_unmap_kernel_start(alloc, index);
=20
 	page_to_free =3D alloc->pages[index];
@@ -1182,7 +1179,12 @@ enum lru_status binder_alloc_free_page(struct list_h=
ead *item,
 	list_lru_isolate(lru, item);
 	spin_unlock(&lru->lock);
=20
-	if (vma) {
+	/*
+	 * Since a binder_alloc can only be mapped once, we ensure
+	 * the vma corresponds to this mapping by checking whether
+	 * the binder_alloc is still mapped.
+	 */
+	if (vma && binder_alloc_is_mapped(alloc)) {
 		trace_binder_unmap_user_start(alloc, index);
=20
 		zap_vma_range(vma, page_addr, PAGE_SIZE);
@@ -1191,23 +1193,18 @@ enum lru_status binder_alloc_free_page(struct list_=
head *item,
 	}
=20
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
=20
 	return LRU_REMOVED_RETRY;
=20
-err_invalid_vma:
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
--=20
2.55.0.654.g21b8a5bc05-goog


