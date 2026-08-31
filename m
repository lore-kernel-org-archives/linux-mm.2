Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96114C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2A36B0095; Mon, 31 Aug 2026 16:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7746C6B0096; Mon, 31 Aug 2026 16:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6135D6B0098; Mon, 31 Aug 2026 16:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC3E6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:31:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86BB4801F9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:09 +0000 (UTC)
X-FDA: 85162709058.09.DEF9876
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD12D18000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DdoULDwo;
	spf=pass (imf06.hostedemail.com: domain of 3iuSVagYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3iuSVagYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJ7fafUlBPjfr1KwszEslsPjbtrF6UKljnaxbzPgF8k=;
	b=6ucgCIY8MEPbIHDQJjSaxjVkReY/6pfo5cMAa6/ats/6rgo0PbKJJF9Jg2Cp/GtD6dFrJc
	N6BOGuYvUmz+wMG6jpvWYQCyd9yyB2W1lB9IzPCvLiWYGducA6L2aOOe+NHCTTRZgeUa1m
	u2LkSFT9767JDhpbCoYuvBcaAyDzb8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788208267;
	b=CGdSlTX49hnH3FOkYq06/vyttMtrBxeVG+//EN3uQ2kY8B9Hs42oN9gXym/ngfIC/YHQzg
	VBtorWbaPG/snQNyfFFHrAP71uZ+Byr1acYRKm2bwFoj5w0uj7/+xmJD5svFYdx2DzXalz
	/2DnvwqaDGbt1wIhzhZVuT8dNQ5btmU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DdoULDwo;
	spf=pass (imf06.hostedemail.com: domain of 3iuSVagYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3iuSVagYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398ba5404d2so3068669a91.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208266; x=1788813066; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PJ7fafUlBPjfr1KwszEslsPjbtrF6UKljnaxbzPgF8k=;
        b=DdoULDwovj65frkrBqrJo+ZA1Mnx3QnXUJJsm2O+aTEUb3ts+RWEDq4LBEBYKvtVqu
         CbnJLppj+RRS2s9QjHr8gwNi/Aerz5NImATaFkNgEY/0beGDocLzP3k4Wrf6hU1IhnSP
         kfZmTCG4tBgA051oTNrBAdc8LJw/zxF6lvCs0esbYSnUYkwt6mhsHVZEROmJvU03kvsU
         1aBvGWrSULUe1on3PJwhi8lzGqxr/cDoBS3k7faN0rjfvr+PEEnc+5VoZ9MKKOuT2Etu
         ZsvjK43mQmTrpW5wnHbs5VyKMbafpI5xUclkQpIXZ/4be5Tzt8YmRgjRAnyzWPYkJbWX
         qZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208266; x=1788813066;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJ7fafUlBPjfr1KwszEslsPjbtrF6UKljnaxbzPgF8k=;
        b=Z5YgLjVC2pNg7RGtu5dBfH6xH8yepJ9A/A4Yu62gGw4d0y0SqspMRVEcDL59u7wshB
         Dmn8yOvdACPHF3tLf+tmv67mgKuPYFhdjtk3+KoC32wynUK2QxYfoS81f7bgQzOnBJiI
         PuBS1pFJzm7xWLtziCJHyFTHo6xaCVna1qknj6Fiz0D3uGrEEnnWzkrmMn8o+syYA4oU
         fYxQwukFpWynE73eWDQG3QCV62DVgAHRqnGA5Yp4m4WGCFLS4yPP/MUVuhgrobaULBiN
         hhV0JOfMz0MtidSwErfVTPXKSRJr7qBqpzvVYl1rqehMjp2QvOLsDh5UExmG5ZHJeFK6
         74aw==
X-Forwarded-Encrypted: i=1; AKwUvBx+WegYtyMZIbAgPnnU1cIHH8D/IsxbNkbgEtPLnZwLqD3AAPmtkY+O5qjuASmYCFkvWfjrmprZow==@kvack.org
X-Gm-Message-State: AFuF++nrx9JB/LYYx33uKrSu4bYb0dR+7v15y3c0HRuIIb56wIoYvtI/
	6kS4Ty26obI5K10Qb0dh9t3T+gMnyJdrW30lvUyM/SNSgbPgh31gI+Df6EHcxPfObK/u7wgBDEE
	HenPmMQ==
X-Received: from dlboy1.prod.google.com ([2002:a05:7022:1281:b0:141:5392:d9c1])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d446:b0:398:9be6:f998
 with SMTP id 98e67ed59e1d1-39907e15804mr4310486a91.23.1788208266284; Mon, 31
 Aug 2026 13:31:06 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:30:53 -0700
In-Reply-To: <20260831203056.838265-1-surenb@google.com>
Mime-Version: 1.0
References: <20260831203056.838265-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260831203056.838265-3-surenb@google.com>
Subject: [PATCH v7 2/5] binder: Make shrinker rely solely on per-VMA lock
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
X-Stat-Signature: u7enjoabqycx8cipqn5sd4zjzbe4rhip
X-Rspamd-Queue-Id: BD12D18000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788208267-78876
X-HE-Meta: U2FsdGVkX1+Eq0fbzsDrx0AtwTydjmQFZQCTL6XxukDV+cldW95KtYNnuLsklFNbODRjJ4IY50chnOWbKUV+Yh7ubcrubjaZVxlo+yTbe02JlWOCrawBM43UFnyDrseoF1UIOjNbvFT+gb9mFRGz8kV9upZM74c5xNwZpOuEEvuaPQpzdgKoItrbbdZRPZQT9kN15FtLSedx9ROtbHiBwLLCTyOthWxodKs2VcYc6QUVY1GJFY5dVwaInsDALZ9t7D8KCDicd/AgcBA8CvFnB/5j0uBmPeY8aEhP52qm0DNtUmNRTmZS2YSeAvTn/JlGdjgl54wtCccKc0+zosEX0dBgjDxzAtm42vwg3eN/cY7Fe9t7dCVzpKmZ0nfQIgjv1DtvzIjb6EUaP3/hgz1JTgSvHdmwmQR/8NTPCgPJ0linKhdU7A9lwPK/11Nw1Cg3pLPyqS2gHTSpqn/r0APN82u4fnoExAcf0G9kv5SfPdcdnsPtzK2rZX1+rSs64MInB1BFQ4uTxYu5u/mcaEq9CscbKDOtqrsoE2L2sS7EvrmdaBIyavmcbzokWAMfN1utoNXvYmIgmuQzvPPNuDunjQpzsDIrqKD/Z4QAY1u6OkK/eONP31w8cciN/VIcP7oH7kniY5MiRtIEA4Fgv2JvvUBRZGrcJ1rxJiHCehQEb6b+4zChB70ei2dx2lK3M01guVC3bNcmulHtcbfOJYBBh7ooAsNVQ4JQiwk91HvyeV1ls1wpcoc1eXJvT/H99TeDZ/SIiN5O02Lcml0QAzboJCmssxpgtWopBfs3oIa/JLLYD6guo8ES9/QHw/PBJvJu2etUufGGbSoAZ8D8Zy6I53e8FlD8A091cJeTn/lFlPBA9muIUpdWk6kYdEm95VhhD+u/cmmPu/DldMn1lLsRKtqMQhOIeUOtetfDgLNzI/Oc61QMjrapY4vsyamKJj3JOCGHK4KDoi+Lcsc5nb+
 TacMSrZG
 FClt3LO3NDgFKFr/SpZJfuy1GkAvPD5R7KBo7IUGOr05Ru6gorEYnZhCtD9k053faZHPYDLSwB2dsUvvTYlQUfvZekn+NzExgYYpsHWUYdw1hps/1wcfFTkpNCZV2/Gaz0UGeyKa6eeyHx7n3JhGqCIlUcoLH/iMieSi3J44dnLMgaF+IP32ZF8y7NUKY49Z+FxEncAaaqoebnkgbkkttvAr0CN8GJq7Lh7S/iPcELaLzY24WwN8B3UqktQd/DIT0p58BJBC84mDqIrs6hE65apq3AhbTZ5z+RLorxdZmrLHNipJWbxmIuEMDeZ9hgq0XsRPSV/PY5gQI7g78nUz/QnJ3xsdkcbiswM4pp+wei5Fj/mVtgI/H0fxyqgaVVOiavaRywXeZ767kfK99+mHfWzTiHBvOY2tZaGvQzZ/swMRhrMwpjpvHLLPnOCtO+u6prVxS68ymjjYZ8knm43RGmUtnYDEmB+uPIl2CihWArppQ912/sthGVauFl9qGvlyMWdqp0dx8VPf4NrjVzc7Y+IXjpxBlXgTD9sRYVTZhinnC0WT1o1a49kO6Hc4071JXuUjJ6dgUbs6VWs/uGaDdOU3/WLsv/+tXjbxRWozmyrgqndWLokv20mbyJNVPAEt/3KFVa8tVN0YhbxVTW0P8B+Dqx8THA8aQsC/TzdSACgDs+euuTqUu1rkOWEr9AGi4SVPnBN/msFwMs4ilJuIAjuruiDkOJ97NYYeimZt9of2GG7ZvEEMJ5ZR+fUCGVZQGtDJ0OW7RK9mHPiNcOjmbpKns1MGn4Kwns4DI1+ZH1Gcl3gu31pJoMuKs1QKQDTk6spmKjdQj+iF9ckoYLPMfKoj4MbQ5kWMk+LjuG8MTfRg0qdP8AnpxhMr8pd904NUUF+/IzKXXUQCfrvO9GQwbaaxgf2YCcVc/pelnz4suBIdYIjR40gzZWfgzb7vpn83HqhzS
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
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Carlos Llamas <cmllamas@google.com>
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
2.55.0.966.g6673acef38-goog


