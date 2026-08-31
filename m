Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936B1C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FA66B0096; Mon, 31 Aug 2026 16:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0316B0098; Mon, 31 Aug 2026 16:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292416B0099; Mon, 31 Aug 2026 16:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6F976B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:31:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52757120214
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:12 +0000 (UTC)
X-FDA: 85162709184.03.CD523AD
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7CBE11C000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M6sA4nIe;
	spf=pass (imf21.hostedemail.com: domain of 3jOSVagYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3jOSVagYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788208270;
	b=62iJuyguG8gjnYS4N3+Ot4D7w6qL1cJ0YAE2N6E21FvvC+drFXYpp24uFQkFL8JL9QxOrK
	2YaXCHfMKpZuaztaDvoyhRCHtwzpmOPyOtdxQ9G7XkVKJUrNTrXxfwV0fYMHJzFTnE0kDm
	iFGkJ9sEQNEzCtT0SWE9RjAJW0DPo6I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M6sA4nIe;
	spf=pass (imf21.hostedemail.com: domain of 3jOSVagYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3jOSVagYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2d63lXSBmx7NRIUq5ZJpOYybhygf0jA0W5buHn0/eWM=;
	b=Puj+yPM11yy4HZV5tzEWMfdq/BzPwt9y0oGZ0E0/1Tw79jk5vkhYmU7YJWPIKRZRzbwHzG
	jS/FZqNeQK5ax0V3UHH0WLl/rYLFkHMMvRKjsTErlhqA+8gvQaW36oLv5z7IJYHH5pj+bY
	Y/ThNZMIL9+Gam9+8pAoUAFE8eIHGpc=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398ba5404d2so3068734a91.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208269; x=1788813069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2d63lXSBmx7NRIUq5ZJpOYybhygf0jA0W5buHn0/eWM=;
        b=M6sA4nIe5NGrzOXHjIfTjfMJ4wUnUHzK6smM5il26ZlFYDWy4THEYR278QbPxE/X0m
         wTSRyZ3FhVJXOznOLn2PZbpevlKBGmfRdtNfhLJjXjMZlZi8FW/tGghyeFVCISzvsO8e
         c19uo6al6GncZW8aZppgTaVkgDyZVv1bFPu3MqMbbx24WKvdyFyo3I6wmtMPeGSUYLtq
         ZVSirHWxjAEFdpABuawp/s2/Yv0ibi+fK2MfOzYkag83EO0w0X0ozRsAsLL1JwWfsUN8
         H3xjG0/9TZThm5fyDYX+sLkvggUXwY+XCfVixOOuolxs+bKRnvOVLSzLSvl0JTKTAUSc
         pFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208269; x=1788813069;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2d63lXSBmx7NRIUq5ZJpOYybhygf0jA0W5buHn0/eWM=;
        b=VWOBXTD8AgKO6T85q5h2CPjj98Dfp6CZVphLmuXfUqAfyUdgHdFlVi8eruxTv/sklf
         nmaMGdKMx/M4QE2P6VFtU+5jNX1LY0/y5ofklH/voEgHAx3IFUzk3f+1+7QQOjIHCN0g
         b6Ib9Ct3eMMjLncre9HW40PM9LHDrbN3JqLfjQtjW51A8vwoIWzPOXxJx6DoXEv14eCE
         cKFMgOK/gAirEV51vGxmpvjo1FTjH2+0i4eqfTDzfxoZ107lGsSSBHtzwAAkNi9EIyXz
         lW7GpIdHj8t3JYUGPhlsrgGp2I+E32tlc7x/eDNr5gaG95ML35+c4NpdGJ1CqWln7Ns+
         DUXg==
X-Forwarded-Encrypted: i=1; AKwUvBzki+t2PKGReCO4H9Sdu7BCkhEYD5YDxjTWxiNGndNR9Jju95W13hzd+Wn000pEConcJpyEwE7tVg==@kvack.org
X-Gm-Message-State: AFuF++lbk6dCvW4dnzPwPAd1pCtZpsrFT/LOmYsFLAqRfX177SEEBoZw
	zsSbQ6XY6UyAbID0ix1NGPaxlThZKMLICYr65MkJx/42AaOz7DMGASiTMr6eVzGZpE1sUNqBAvu
	1bgle0A==
X-Received: from dlbeg32.prod.google.com ([2002:a05:7022:fa0:b0:141:4d1b:41b8])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17ca:b0:395:4de5:1054
 with SMTP id 98e67ed59e1d1-39907d65648mr3496744a91.16.1788208268999; Mon, 31
 Aug 2026 13:31:08 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:30:54 -0700
In-Reply-To: <20260831203056.838265-1-surenb@google.com>
Mime-Version: 1.0
References: <20260831203056.838265-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260831203056.838265-4-surenb@google.com>
Subject: [PATCH v7 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CBE11C000E
X-Stat-Signature: 8igff39rr8fsspu6t7axdqti1zwgmaaw
X-HE-Tag: 1788208270-896968
X-HE-Meta: U2FsdGVkX18VzaSSTKqOSwQYCAIdBHBX7LRukLeRbtaxH1Eda7lacRxeOdw3SERsBe1mZdNUr1uYLgao8R2iigNaSkWe1Paki0zVQhzAzgPUX76qk0vE298Cew4LBNdlOMQlDdskUiopUI8N7ubOt8El0Pm0bSK//ULdo3wXBTX1xeAE/VLB0vWyC48H+E2RmnpGZNW+AOCgHALxa2UMYaIp/jB7WMsWVN4dGDWqQH0uMIL7WHxRGXgpw3MIppLR0hcjtOAESSfSBhLZnW04UVXrkpCewlpjcTouMOyEp++fXIp5jlpbH4nSSrvA18jXMP9m5D3FFn6V31D2KMvweNgyrAp9gheHN5dcG74e8/RvBy5BmtSmD/ksPqeGFIOpL86SKFRgWBxkTEj4cJpyKLT0MSU71lDmIcpq2p4nVNzsypOLwcUER5p9UQai8yRni58Tah+e4GFNBsXm9P1biK38IRmx/c2N4yYCtZQC8kvkx4MRa73w3o/a2uU93wNRj4z9HEc3q2HDZJXsTZn7FF1JB6lNOMyQ2f+emhw2t8rvemGgs1rW4EueO2t5Rc9e+R0I2ImXa/qb3zAWcZFEQW5Cm/u8ilBRBSAK2SzGw2UYCydcgMkB1ayQhN5Lde5HzYvlJm1wMBvUyTMxvwr7VV1pGYZFQANeJ8JNdzl073DU2Rv+qBUuo/h+cWYzkTdM1L/kf9OlzN/kX3NwEeu1YpTIJ9VWrfdJproHw3uKufJHBBK55rY2ToxsyUMPfJQWA7xhWtqvpW68KNT0iTnZVCOJNpTZZ8cdj+iEnHqkxFs63cwinGCyeICdKtDWZrDxmqz3jCPXwtLAGCwITO3hwQlh17pqG49wl870B9ll9qSMNhVgiov7FwVh/NF4QzICz0xBKzf0obMky+cRw4JfTZwn+8Cw/7UzzV/RD0GwfFk3Bi5LfOcbpz6wgpQd2CpIQCVJVy1hRsDaMXdIoMj
 fld2Ak1D
 nU7e9q7mSN9KDnLfYwm99DhEmsqcDcIP832B5Y6N6be1tKffIhO2yc6jaPzI7PdZSOB9AjkP1bW50PugOixueno3C6Gi3nlHdsCmzRH7tFai4Dw8LpTmTZWnD895Lcmpx0uD45w3eOdqPhoHvTyzmntRvYdt1hJAU1KUoWVgfYFaJ6hDTAKnNeRWtwpsiIkh45O7MGeY6uodqWQVDPyc/cV9xmOSerIItlNxqEuiq03eDR8fePWfm7x/FlQEHDXi61+UuIdBUbgOV27Hn4fjrkzV2fD3J6G2qeOnk9ROtG5fdHGrIhgbeR6LzqB4B17CpXierwkaKhVtbWIHELy3yiDOqOtXFdo3oK0mctW8gMYfvLtdWznJYiyc3OWzT9rWq4haoeHvnrHOMxDRQJS9JSCJG5u7dJR6WWo7IuKIvgsVm1uYVsQVBleIgeyVGo2jwbiEuJ8f/Q70jZKkpWmhWMs2oc1U/RAs9ICaz1Qpks/NAhAfaIe4aesOp9ThuvKulzfAhLxzA/mTVEtMyLSvNheTmxlFujUWtxpTNPl2qJ/VpNCBR9li/6R9u9yoy+u5CHpkUGzKJLjc40tF8PL2nK+vQTVei04PAyPG+f58aGq2ANExQakaAkB5kjMp6oj0/tscFnNgZc9CsnQvzLUx2WYbeL95T3VjMD0Cq7AGtwF60Su0Wy3bRwI71+4AJWX35LsDAvDJ2+97B251LdJBJPzR+8nGQII5/btcRIJ+T6yx5Otn5jmj6DYMoR78hvLZ+8SfffBg+JQHV9kbFGhIRY07yk/kn6e5P7dbndhms4jy+Jp+90W6gOGIsnNZdqW40Du/G60DKMX+jCvCSlaZ3LriQEqdj8TpmXTZn3Wm6JOFuZ6iQJ95gEaNrjw4vAu8ABJVUV+Z0uGMBHlEvl4NTSSXhU3IV3aApbG8i/fJ13suf3JVD8N34yIj69JTO08Seh7XS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

There are basically two parallel ways to look up a VMA: the traditional
way, which is protected by mmap_read_lock, and the RCU-based per-VMA
lock way which is based on RCU and refcounts. However, per-VMA locks
will fail if the lock is help by a writer and therefore never waits.
In a number of places we need to wait for the lock and it's done by
falling back to mmap_read_lock, locking the VMA and releasing the
mmap_lock once VMA is locked.

Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
waits for writers. This is basically the same as the existing RCU-based
lookup, but on a failure to lock it temporarily takes mmap_lock for read
and waits for writers to finish before locking the VMA, dropping the
mmap_read_lock and returning the locked VMA. This has some advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster
*and* simpler code.

While at it, fix the comments for vma_start_read_locked(),
vma_start_read_locked_nested(), and uffd_lock_vma().

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/mmap_lock.h | 19 +++++++++++++++----
 mm/mmap_lock.c            | 35 +++++++++++++++++++++++++++++++++++
 mm/userfaultfd.c          |  6 ++++--
 3 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 27c00bac29f9..00eae65b74bd 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -228,10 +228,14 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
 }
=20
 /*
- * Use only while holding mmap read lock which guarantees that locking wil=
l not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() sho=
uld
+ * Use only while holding mmap read lock which guarantees that vma lock is=
 not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read(=
) should
  * not be used in such cases because it might fail due to mm_lock_seq over=
flow.
  * This functionality is used to obtain vma read lock and drop the mmap re=
ad lock.
+ *
+ * VMA can't be detached while we are holding mmap lock, therefore in prac=
tice this
+ * function can fail only when there are so many readers that vm_refcnt ov=
erflows.
+ * The failure case is very unlikely and is already annotated as such inte=
rnally.
  */
 static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma=
, int subclass)
 {
@@ -247,16 +251,23 @@ static inline bool vma_start_read_locked_nested(struc=
t vm_area_struct *vma, int
 }
=20
 /*
- * Use only while holding mmap read lock which guarantees that locking wil=
l not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() sho=
uld
+ * Use only while holding mmap read lock which guarantees that vma lock is=
 not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read(=
) should
  * not be used in such cases because it might fail due to mm_lock_seq over=
flow.
  * This functionality is used to obtain vma read lock and drop the mmap re=
ad lock.
+ *
+ * VMA can't be detached while we are holding mmap lock, therefore in prac=
tice this
+ * function can fail only when there are so many readers that vm_refcnt ov=
erflows.
+ * The failure case is very unlikely and is already annotated as such inte=
rnally.
  */
 static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 {
 	return vma_start_read_locked_nested(vma, 0);
 }
=20
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address);
+
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	vma_refcount_put(vma);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 272f9ac762b9..2f94ee0fdee2 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -340,6 +340,41 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_st=
ruct *mm,
 	return NULL;
 }
=20
+/**
+ * vma_start_read_unlocked() - Find the VMA covering 'address' and read-lo=
ck it.
+ * @mm: the mm_struct of the address space to search
+ * @address: address that the vma should contain
+ *
+ * The fast path does not take mmap_lock. Waits for writers to finish if t=
he
+ * VMA is being modified by taking mmap_lock.
+ * Use when mmap_lock is not held, otherwise use vma_start_read_locked().
+ * Nothing prevents VMAs being unmapped/mapped before or after the VMA is
+ * looked up, if a stronger guarantee is required, take an mmap_lock.
+ *
+ * Return: If a VMA exists which spans @address, return that VMA, read-loc=
ked.
+ * If no VMA is mapped there or, very unlikely, a reference count overflow
+ * occurred, return NULL.
+ */
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+	/* Fast path: return stable VMA covering 'address': */
+	vma =3D lock_vma_under_rcu(mm, address);
+	if (vma)
+		return vma;
+
+	/* Slow path: preclude VMA writers by temporarily getting mmap read lock.=
 */
+	mmap_read_lock(mm);
+	vma =3D vma_lookup(mm, address);
+	if (vma && !vma_start_read_locked(vma))
+		vma =3D NULL;
+	mmap_read_unlock(mm);
+
+	return vma;
+}
+
 static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_stru=
ct *mm,
 							    struct vma_iterator *vmi,
 							    unsigned long from_addr)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d157e15fc77c..6ee933a3803c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struc=
t mm_struct *mm,
  *
  * Should be called without holding mmap_lock.
  *
- * Return: A locked vma containing @address, -ENOENT if no vma is found, o=
r
- * -ENOMEM if anon_vma couldn't be allocated.
+ * Return: A locked vma containing @address, -ENOENT if no vma is found,
+ * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
+ * overflow happened due to high number of readers and the caller should
+ * retry later.
  */
 static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 				       unsigned long address)
--=20
2.55.0.966.g6673acef38-goog


