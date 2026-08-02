Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0725C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE076B0095; Sun,  2 Aug 2026 17:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47726B0096; Sun,  2 Aug 2026 17:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35E26B0098; Sun,  2 Aug 2026 17:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFB96B0095
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4907F120572
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:11 +0000 (UTC)
X-FDA: 85057685622.29.A49B231
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79F451C0006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ANp3+X/O";
	spf=pass (imf18.hostedemail.com: domain of 3vLxvagYKCE89B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3vLxvagYKCE89B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G37mEYyNGIkcVcWDIKuo53Q1LK9xSdA30i8azc+FTGc=;
	b=a8zyj662jGb8AnZey2Vf1NDYCI0SW2T358RElX9ElNCunjm0m8iFU2F0v9L934FNWfBiaO
	W9wLqRGH8CLCN2FnmcfKY6tLr6QFLIlv0zsB0eIkCohV9WskUDjWdLksE6bzx9cqSfO+dr
	f6ayKYYJVF05mBm2YWPDEU4mMIRM06c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ANp3+X/O";
	spf=pass (imf18.hostedemail.com: domain of 3vLxvagYKCE89B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3vLxvagYKCE89B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707709;
	b=oDfznqfgjyQ9HKTMlQRSpAEys5LzvtiR6n3yhJKLqg3L1nculXmZrhIaRFMubHVGovhjEs
	hYJ1hiwRcOITXUj8ga/nEnj1lCVDFL5kwXV4HPOcJKwrhfpsBrf9em8Szg57GTrsNhWSWK
	zbUBoIYh6FNtxR2RyREsD4wGFPcEC2E=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so5100576a12.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707708; x=1786312508; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=G37mEYyNGIkcVcWDIKuo53Q1LK9xSdA30i8azc+FTGc=;
        b=ANp3+X/OFLtQdk5djaPd0/UqK8i46S8R9XsT2A/EKZf+WzC0xaDSyWCAkCGvZjXpZf
         qyKd+HvZVZb5qK+wZ5mFwxVLX6KQkely5efK19lVlN+Fil8iIh+GlfrBy989EnPVeE8z
         CxPmyZJ5P+Guyj5bd6SGjL6fe+4b3jmge245kbW6LnfSxCyQxvAfyzPFZVRMT/tN8s5d
         Kc/Af1soZuch+wG67MfzJnCmYNSpsPYDWbTEtEXPaKNXplDOCgt12qT24ymlgePLexfj
         DnRTAJW9jn6i3tqrVt9uHgO/27MRMOb0g4ojfECylSak3x5eZkuGyp5jH7u8gP9strnl
         w7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707708; x=1786312508;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G37mEYyNGIkcVcWDIKuo53Q1LK9xSdA30i8azc+FTGc=;
        b=UxCvdNioZz5ZIHHR+Z1y9M0gsTfzeMH9v3drld4JfYINgzi5VIPR4A7ByEIyw3l1Nb
         UCDBRGw+VL5FgguzvPylJMy6KHKo+IldmF+b0WIbxxWgNJtROhdqkkSX48MxRF/jXoxx
         5xRosvwbTvBSpgdVG7IPZch1etMZlBiN/Wx4HOyQ4VIZZ21PpV8WjOEUVmr8ipeSfzYa
         I8cQVDfT7lyYqGwXToz0GGgtV4ZDQR603lkutIfuWZjDJofMel3H2dsnJwe+DAvuouj6
         MKkC2TmWgwsr0Gk3414gdkCOxJnV//VIT9Ri0jPFTvO4yiggHBimMhHzbpCzt7KTUB8M
         APRw==
X-Forwarded-Encrypted: i=1; AHgh+RrPfXQZ8GkPLCiLm500O9krGFY0yd3FqkJObryFPP4bB8Kh0kB3yOWFyDBuW8Gl7lxCmPQ8fIrpCA==@kvack.org
X-Gm-Message-State: AOJu0YzviQuGxzhQuoSJ361Qf3/MRGEL6//KQifY3rL4c9dW3rvOMM5O
	NJzmngVKmWw5I4Vs1mvrwiWwbkWabRChGXKEIpTMZoJ22WvAZGPo/e8d5DFpMpqUqKA09ajsCxj
	Xt410Eg==
X-Received: from dlag2.prod.google.com ([2002:a05:701b:2502:b0:139:b9a8:f222])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6f15:b0:3c4:1493:6822
 with SMTP id adf61e73a8af0-3c92a59aca9mr7723441637.18.1785707708099; Sun, 02
 Aug 2026 14:55:08 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:56 -0700
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-3-surenb@google.com>
Subject: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
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
X-Rspamd-Queue-Id: 79F451C0006
X-Rspamd-Server: rspam01
X-Stat-Signature: uksqobwwmrifygoenoc863bzh7q53mxu
X-HE-Tag: 1785707709-605198
X-HE-Meta: U2FsdGVkX192fmrFgnYv29SEH4bDtgf0yYSBxQqVVOVPYJdyCKQOUZV8nY+5o/6sb8SCMt3/9sa8uK1hfoxI/cTykxkJYKDjN4vOvlZGFTrFf+4C/hoiEnAwjWhCsIRJi5gtysJPeZhvLJDhQV1jrZuPZnavXWXyw8LW47g+I7KlAZAnKX1T7uAL+qN/d/NggZbpVDpWKfJBo5w2nMNrJY7mumZFOBx2EjJ2uXDGkww3wIdGJ+rx1SsCnHKt0Wwu5rvnEGSvboExhAKb5vdQvPytpLNCKNwDTVcXoiQt2qlSDKNrUX+aX2yf1VFrPFJNutsLVg7M9KSgRj0V7JkCy8zGSgiUpI2hAPWemFwWWpOZqPSNvTZyR4RP1MTdm+cJXLrS0EIGQvhhjYQ0eokwsFRFgFiNGWwWFqd8TFDAyIwvrKuWymUiGsFvmedN/8W1aE6dD4KSsrLF0xWrZf2rPs1sm2ZrM7FatOFPk9+fHbLZ0CnNrk+EdrSvuaW3kH17Bb9Uou5pUukJhdAxQlRik/UcD+RCBUvq+5qOglLl9TqV1S/cej9UrPkaGpIVwafqjIz7b3RY0m6JcNNrFkDvVy76LcifLRFCl1njQ3Gh+JAP53EZQU2Q3BDD2j5EknkjMLpyAtZOpKap6qnyxk1GxLOj0PYW1flOEyNQUVvYUREnHAXn4UlrVW1Tfjc+4IAoTqeXJesYIuqSZjgpNSwfN586vqI4S49Mpeifn0e+qTR1FlFtaIeC2G7vnVbkx08MXwOqwzA4+CZ2mmPTFfDkBKOfDmVLei9oZAl0NfynmeOgDT2O7GGYXOOMzgnzVtqth6ZnAuPhpWMrsERvtAgOf2j3I+S3SnoPNzLgK23gvK8jjSQuWDcqXVVSPHIj66m7lw0df+7pCgCC6MPbJM1XZ/dLHauUeCOjH/fIY+1/C7Pb26C9KFQznhiJxTnQkxzN2BugJSyUxG12CtNBE+o
 hmAO6Yui
 kxYMbzqU/tzwljeVIwWSgX0tJKsBXzV7d9I5YwLdMa/BVJP2Hq0eLy/0ywO0xL1XUImUWZJ8bLA/EIC6CPENkv1kO8N9DlbJKajcbx4/EMiz/6yggxImuqn+kvcALPbTbv8gRmj4mcneqYdWTQRGb8HYpjfsw2DsmA9xBhUAPG/+0VsBS5Te8bn1SyjoFRz330QUAvPhWsv51RmZLswO4mmQZhGw7f9ug37CcFe9AKbpTVOhwGRnexpjylezbIJ5EB9BXpXWSngRL4rhMJRPyuPCfETb6qVrJ2dHXvDr6F52wwSEh4dfRoJqag5sNdTRiLtn01C4+fxsXKtxNR6Y+toUbscJrJ8CGmeraZlQbwL/Pda6JK2psVKXnULwP1pueSIM6MHo22V1wFjKCjmwPjDoNdk5VW9+0WO4HiplWBQm+C7k/vEFUPXmgKL1QTsRrIzYZa0t9GyqoD1J6XHwGNpRFGRSzcHh+nN7SlVpeoDVgjh6rtxkkt78VIdCBT7v7/Z92MRinMeiiu8/m9RFyMRjVx+QRt1oFpnHKT2OOoPAXGKHr67q+J7Mv+7qU1sRAkm7Yzns3amKSMac6HhPn4EfYZMkGTllNkpdWiK4BGyLSge6dwU127ObXYqeOIINTExzqK5vz+kcAjBncC2bW5jPgWyVyc9s7fErhxJm9tyTWybjhVx7LPdH9s7lT1ui2n6uaWRoaupvx1qoxn/43M0SJ/yEMuovmYhvIN8SqtJt8NAvVv9gsyhEmxUCGFwtRH/6SdW2vDMheivKOL5evNx+kpLLg6pRDlHXZr+7b6YrAxD3fmgUWlxydKbns+wSPzLNwfA3FB93JKfQ15xHE9mpWz+p5wyFmKG1GYQRhQNV+YjY7WVrofb/SuZJEpK50srFfNnYJTO4gDeY69Peu0VzqFXNyxAqCNTzYpf8Bx4q3YcmhEgtcAWoI2grBTUWJoH6J
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
 drivers/android/binder_alloc.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.=
c
index e4488ad86a65..84104ba04e30 100644
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
@@ -1151,14 +1150,20 @@ enum lru_status binder_alloc_free_page(struct list_=
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
@@ -1191,9 +1196,7 @@ enum lru_status binder_alloc_free_page(struct list_he=
ad *item,
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
@@ -1203,11 +1206,9 @@ enum lru_status binder_alloc_free_page(struct list_h=
ead *item,
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
--=20
2.55.0.508.g3f0d502094-goog


