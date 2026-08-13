Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CD0C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D93B6B05A9; Thu, 13 Aug 2026 15:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0F46B05AD; Thu, 13 Aug 2026 15:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F63A6B05A9; Thu, 13 Aug 2026 15:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6346B05A9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:34:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32F2880285
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:47 +0000 (UTC)
X-FDA: 85097248614.04.9BE96C9
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D5B740005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ADSpODqz;
	spf=pass (imf17.hostedemail.com: domain of 3VBx-agYKCN8TVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3VBx-agYKCN8TVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeW9TSc03FhuP/zh7xGvN3PHX+dTDVEZw2LsdDCY5ac=;
	b=62Qb+K69rQJZs7zDvjpufFvcwemIPRxxx/OQdB8G1rPABc6cnwW1GCwXVW5OLhgWy+pFaa
	MxZnGRWfyFv9N0QylOnjA3nPAc5ovouT6hq+upDVZbZg0rNVEJzG1ENySJejGjs4IoCcjC
	mRG8U/0Gwl15rvJtP1/gZIdHrjBzDeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649685;
	b=3gcopCArLAOByBJUzZpVQys+FwXmbj24TyGd2MULk68eFecCjjbFnP5lHS4IxRsCCX2g2b
	lpxr9jyGH3t8n6OXHIdYyaBWvGKsVDo19ctl+563qt80tWHFpxP88iCFD1OM1PDpdGTDKh
	LbgR4OFHwEglqk9JO3pseJ3Zd1eWRB0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ADSpODqz;
	spf=pass (imf17.hostedemail.com: domain of 3VBx-agYKCN8TVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3VBx-agYKCN8TVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so324312a91.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649684; x=1787254484; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UeW9TSc03FhuP/zh7xGvN3PHX+dTDVEZw2LsdDCY5ac=;
        b=ADSpODqzxt/dif60Ifm5pgG/tkSa72j3ETNYckmWbg6MDqr0uPALswF0tB+LDWR9ID
         7Fhz+LSZfzH8rBQQY5YxhHw8YAiaAnZ5nxlVZfwjX2dQamoKWFM1KP2e49Ul68LxIY/J
         xN8y3JiYkcwRWlKb7vjqNeOsInp5P1pN2v+a9+aUb8Z0sVkFSIB7HHBRl+vDHbjIYPUk
         NxGuf4qZogmN7gM9nOjy5N4Jb2CVMeeut6O3KHLd+cTbxCVtZ2qraA0RkugdQkS8EHDm
         9MQPK7VPLV1AX0NeStFu42Z62x+sWaHiy4mIQ4V3A0TEUyf1Ebk8WjvpiFKURs5XU4+d
         vcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649684; x=1787254484;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UeW9TSc03FhuP/zh7xGvN3PHX+dTDVEZw2LsdDCY5ac=;
        b=BaehJReZKiruzqIKqZ7u2DaeE/kPO1/xdle3LbvLNn9B1Db/Gnm/IjmPecCQWCY02V
         3J51i3dD5JIXc3yn76KZBM+Oz7x4yYDGIp6GvCly7V67cHz1U25KOtUE1LMXZPr+L7nb
         hEtZmPE7qKP99VjaUArgm/SYjAS8JBiSQKVW57Jce9tQCndjh/MfdkWZ0wiU5aoqpHx+
         1IJlc6x5wAK4pSbAdw4A+iUgKkGknmxRFoE0F5QL6Twixr1WxEiAgaPJR0WkMpEr+XY3
         Fwu2chphAIjIZZ8onnPg3GXdI44jLeN2W2ZICNgB3KjbSIJWZKQ1If19FJUiwDDl6MZP
         5uDg==
X-Forwarded-Encrypted: i=1; AHgh+Rp8N6JCmOF7q6tNMJV6GmI/NFrrjoBHuBH0OYKWnGaIpywpnPeg3kZQq++DNif9uoJMANIBd+izfg==@kvack.org
X-Gm-Message-State: AOJu0YxEhJYAveLo3LaxryAJumm/aZp+5UJCWm86LTE4JzyJB/oiDGoc
	AIlyF1NwCG2bWw5L6RXABbvLC4OprRHFFzZVYATOYlRrT44K7Gt6ru5JKf2H82gvv5K1ygEPh3S
	QCyaprA==
X-Received: from dysw24.prod.google.com ([2002:a05:693c:8918:b0:313:c1b8:bb51])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:184b:b0:37f:eafd:3505
 with SMTP id 98e67ed59e1d1-3933b74d94dmr438744a91.6.1786649684110; Thu, 13
 Aug 2026 12:34:44 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:30 -0700
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-3-surenb@google.com>
Subject: [PATCH v6 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6quaupzk15o9w9xa5tm7nfmnw9967861
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D5B740005
X-HE-Tag: 1786649685-553374
X-HE-Meta: U2FsdGVkX1/XoyaStAbeGpYp5W8V3ZRB9oZa+zIsTgj60aKniK2PdHQOLLXdkrjSvP/OxJF8LDhdP2zdcSokuJuaJq1njtTpCd42PUoFZEndM4bvrlGtuJuyt7W7F2/jKI0eB0HqqRCp1LJBe4it+0bIbe+sxOq7ak+MrpB9JFB7i6Dwkt8NL8ULOeHYzZn7RVBEx8VgpOiTGLsgZx8SePA250GdlQgvIYqxRc/s/GdpXCeExbtqqsALsxBJ+EvdjVhq9zWX2mgoo35cSHXki+Eyifm50/HR+VxXYRWYesUu52TxtUpxspctsbpttjz1NMo42Br15OWCyoUdqYsXqS/zDF0yd7NIzRcalmN6V0WremJB1pGnLFZPbu1i8eLU/J1r9H6XMO3Y5i4DrXERPs+RQRArBnYxPVlV8yX48oz3upVxiCVYftimwSFIOTJILzzTLPDG83Y7KvmBIY7oI838SnaqlBonuinQBMRHydhvv32LVFEYZbiRGl8YAUhAwPKgQKSTdgprp3HIPLlM+4SNQ/Q2UecewUXaTy+t9Kj9Qz51AuIz7/3UpBqV0AypsB1P3AZa6OLeXLpFpGDHwtIqfg6ggC3ckmjMl0Aj1xUuQGEraOX1XzGHUVrFEsQoiPqFIQCNQqqD02AMlsKngGo0MJJmh3ETA0mWLgcajp3+O+iejmL1oWiXmo1vh4atVFy224p1YSPBLXRuNZVMBoPRphLM5WEnSrMqlngbEjrGzdD3s4M55JAxgjGjkonxND+Ku601ja2LRMovXDbpV9gMvzaCNG4ekH0dyaW1RaW1kRPxj/kiMzTDwEvB1sIAQgt5zTToZVPXqUo9Cyt+ZawME9AiHDaN9Yv2Y8lCLGA3AxcybTi5w7mqYPyMgR0B7fs9ajj48pqNZuDDIWieqrOu6OI2nBEV+J/HOXfMQNQgxzGfYMT1Knk6YsKcn4OUGtGSpbXm5Yig35ZAlM+
 jk87aBj6
 fIceUnXHfpt/FjqbMYSoAeCr8GMSJmiG10ktMOO/K3olP1ysickGIJvPLA1k+ZfIotFo1qtKSLhA73lWrxkaVcqGGAqsEjRirKtdnEoz/OSIfn9RAqrh/IR3wZMuf/asWJODXrRYBRD7OQ/AGwZUOD5vMsEvu509vD4lusqEn2abEw5le/3aBBL+f1xIKxkNEJll25q4g0NZVoJhZGRvx7nkpOU1FToE0T8Ia98qXACc40PmJN7mAtdc572ZKH/x7ULUdzirq6A+xFKyBMmWIFtyytBtgDMd/zVxBSd4aQQg43LA245eCT7l2o6fY16RoKt3JzGjqgigeEw7DaAbci9R6rDeLzfFqgATGWdumW4NPJ0vL+uIObJPe+d3f0hyC7tI4/byTou7ESa2zXU5Z2nBdKCfDDE1e+rhBkdmB7W2oLoN7v2aEnXDKIi+P7Mn4uz1bBRcPs0E0JMIYvfO7rkcq5l4xAZ+GgAjQXYXge+gZPo4qFKCRki1r2N1qARtVhJggbklhIHgukpT514LVCmVUQ8gF9LL8VWfG6haeU0Sw6q4739YCekxNcp9Rw1/a9LXm+dwABtJmXAli4RMQCxUR6SiFcuHC1PtGmX/sW2LDyrtq4UFnfRQE8wSeqwHgK2/105AoLT8uDZQBpFk70LgrQYWH/cX39o+C0pqTDAe79fXOulMfzQwXcfqNWTVLs+j6vDrQt+HiVWgeVZomZq74WXZ59pKIDuBiXFja0pUa3vuCrMSdkmA2KDWwMC6gzOiqZIn6PIUeCpamys58IFGs+10PZUgZ+yvDh2pYTV2byeOD+krnmD/zAol35KEUAlrawZ8KOC985SpmctWEgbF5Y3YRTrcCoGBiJRg4DiHixmJZeKCsbR7kJc6qetj2UqsRsFBcstn2meWajpEDbbqZxu8v/rQ0QJPwALRGf+mMj7tFv7w8udk2va5lX2S6p0wt
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

While at it we also make the handling of the cases where the original
binder VMA is gone consistent. There are two cases to consider when
Binder VMA is gone:
1. there is no VMA at that location anymore.
2. there is now another unrelated VMA at that location.

Before this change we handle case 1 by having the shrinker proceed to
free the page, and just skip the zap_vma_range() call. And we handle
case 2 by having the shrinker return LRU_SKIP. While either behavior
is acceptable, we need to handle them in a consistent way. Handle both
cases by freeing the page without touching the VMA (skipping the
zap_vma_range()).

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics. Claude caught this in a review and suggested the
approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
I guess.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 drivers/android/binder_alloc.c | 46 ++++++++++++++++------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.=
c
index e4488ad86a65..fcb744088e77 100644
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
@@ -1191,23 +1193,17 @@ enum lru_status binder_alloc_free_page(struct list_=
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
-	mutex_unlock(&alloc->mutex);
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
2.55.0.691.gc56d675ccc-goog


