Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFADC5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41886B0092; Tue, 11 Aug 2026 21:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A156B0093; Tue, 11 Aug 2026 21:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57126B0095; Tue, 11 Aug 2026 21:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79E186B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:11:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDEECA2482
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:10 +0000 (UTC)
X-FDA: 85090838700.16.438635E
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F99F100003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WfijjHVT;
	spf=pass (imf14.hostedemail.com: domain of 3K8h7agYKCAYy0xkthmuumrk.iusrot03-ssq1giq.uxm@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3K8h7agYKCAYy0xkthmuumrk.iusrot03-ssq1giq.uxm@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
	b=Hbw2Bx1yaaSWsNswZya+MwJbwwvYc1vU/cMH9dnHkzdVJyVur404Aij6CZUgsYGCi/2Ykl
	xi93o2urFm584s7o3y4hoC7+9Kx6EHI+VwC6onuCr0dDc+tfrqYdHXfbFVQZ9+25vW9WfY
	TGZ0J1tSZPXoEpH7grxpPhzQj8+HO9o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WfijjHVT;
	spf=pass (imf14.hostedemail.com: domain of 3K8h7agYKCAYy0xkthmuumrk.iusrot03-ssq1giq.uxm@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3K8h7agYKCAYy0xkthmuumrk.iusrot03-ssq1giq.uxm@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497069;
	b=6nL3bRI1Rqoc2MwhilvDKQBjd56NTmTOXMvH+3/U0lSCoLWtKm/wYz7xOjvck3rA00r39k
	Mr32gnXCWSsOHIJK9F+URLj8mbsuCnUkgm9BM4oo60X2GctR/hGQLfFCQTyVeBqm22Ct4o
	a2dy0O0AGRo7UNNhwAx4SlNVf8kE48E=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso530667a91.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786497068; x=1787101868; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
        b=WfijjHVTfzunrdo9xED3no9HQlczoMPKaSEMnISYo35XkUHeLqLj+H9aj4mUHPiNC/
         2HH7hozdgel0OgPq1g74wPmi8HZuXFESNaB2EO/+rjs1Q9IHxR/NuYHu4d5V915Yc2Ca
         kTGzAZD1y4w2mUbgSXQPW1qNYDQb1PSDOAMuqpCh4yG3GoANJyR8Nd2FaBujf/OCFTfn
         mQ2JFyjWF3iCAO595/ziUuPuq+N+fTMzioy99M2TpI5mW5tcmFD6hw4r3owBkwVkDPk6
         uBetvKl/8I70LFLFDZJde0ky3x7LsUD6SGuNkL5bwoqW+taMvG3f6AXD8kW8Qt27+PZB
         FX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497068; x=1787101868;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
        b=B8ojTa0tDLqS4ZA99Nt3pHIhT+TqiPQZysqcONv1sAZW3F8YtBpdfi/DvvvRVuJSnt
         brmJZQ6+2kmgKiLc8cb7lanVhtZ/5wvss1tJyQYiW3mbxPm16Ew8uqOCeCNvTuCA/vH7
         XEdtFfrcS3Q2c7FP4RCvwNZePIPd1K0pQMLgQpgxgzptht0Q+oiS2zcS+tRy571j9I/9
         bG17OVPw97R6z6r27WMhFe+Ar/vR7B53xOk1OoHfZt7o7BF4QFeqDp5JRHCwhkb23TpN
         Kxbh9FTh/IjBV3qszex6JlwuaROG3d9IJqD3KNkFCB9KpbNxknYJlUDPnDvbapXlIqyJ
         G1Hg==
X-Forwarded-Encrypted: i=1; AHgh+RoyaFXOKueI9LLQlYpELlYmaBzY6Ctt7tdOurv550OkhUp8IJ7zDRchd3jVZCfVW+C8439BYCoVOw==@kvack.org
X-Gm-Message-State: AOJu0YxlBJSKc2UxKOedtcQIqPAlasiXmVBulIZceBPcxnKjxLjfvop2
	lXXV9ffdbYpFkWYXUmPiJVtn5PkBlV07NR7bjSXSpPVEv8qfJ92ZxVnG7GOMx23RQjJ0FS1ohgc
	xS0qjlQ==
X-Received: from dlbcm37.prod.google.com ([2002:a05:7022:68a5:b0:13b:801f:924c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4a:b0:37f:a915:1c29
 with SMTP id 98e67ed59e1d1-3930167c7c7mr1130828a91.19.1786497067658; Tue, 11
 Aug 2026 18:11:07 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:10:53 -0700
In-Reply-To: <20260812011056.902771-1-surenb@google.com>
Mime-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260812011056.902771-4-surenb@google.com>
Subject: [PATCH v5 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F99F100003
X-Stat-Signature: uftsftanwx9s1h5z4x1bwrhk9mw3w188
X-Rspam-User: 
X-HE-Tag: 1786497069-903586
X-HE-Meta: U2FsdGVkX1/9AkdSMdET7cklm5rZbRtKWVNFmBykpRlQmnk1Dduvryv4ujtCoIpawtztVmOSh6X+DmX4F3E+ITItIurC4hnQH2CAfBKD3kg4UbfSOfKhaD85k548WsRObswHzOSHNsnDkf7MjO1dpAIx/ojfhXClWZRTOnjEG2wzf4zWVP65sERmQqamAjlffDQKSF1yDFvb3KxVRsSEjWwJBLGjPRChdEJK67x9L1fGvdhrZKD1k1MfxjjTvs69NRe0NA3IQfQsaSWpLCa4OG7atx24SWs8KkkqeQSK/mmg5NQe38eD/JdIWfy7zMBl6/s3kRKwwGEulyDj8GH22DAmZRdBMW1M6uKgpTQbHIYP5+loWiKCVFKRvN+RMYN9rt7U04XBFaPPNnaJivULcRmNaaBFZszS29CJ3SVuGr3+23LbJzC/8RkeJm/ZsXXghZhsytm2JNDBhdLKJr4tDHGYxhJelnvWulmI9bQEklIPFVVFQSM5bthg2uvzjTMOzXYCLeQFuYfMZwOSuKCAy1bS0+T7W+uQcdBBynd8zkWGi0AFhAbZDjZNFy02xwGsNNd6KIKFzGHH0bUV8eIyB8q9zJOlmwtfetZo1NWYDzvQD5HKdlZpa3ZTTlWabyv8yaTZaPaX+H5ntY9BCCSliC3VMjJYBcgFMgFJWgsavJl/FiQ2ailwzBSDuNi3K6AN2wzRXLq7/DfaEp8an9CZj/wUoL6ZMgO8TR/BOGlnRkiDVHe1CgWGgpjlvatBrrkdY37ptbAlf/fXZ99oB5H2aLwxFKwI235HRtwK+sU9FJCVcKYEx/c+2K1v1KWUAriXxGtq8wEGyv/g1ad2MenO8gbJ5Oeajr+wJ/lOZgyA1TjLl8tNNDZrODD5N4cq+SPMR7bHJ/bEyzJbZNVcWk+chgeH9AMvHYL+gNyGh79k+OrqcZz3ZiUBDRdALkutVLe4HzqNIZlM9XRu4cgpTxy
 UfwBEb14
 2NEcdLomrpZ4waxatL4T5dBvdRyRu0Ov+rPc4W7GY+/KPJenUDUq849zAXDI2OCvcdcP0C6LCsQT6T+olr4EcHN1036KoD1iHTmAslxpwnrIaiDj1X63FrJbccc7iKUNMNf/zu3UcWPhZABT9U2G7lfkRh4ayHEFs5p/dcoUcqJU0M5tkT+pFWhY0sWaVKva2p4yAcJyEblBYOJK+Z4mQOqv4BgrXTBOOFso0HSKaBV8hHDcxTiOd2ETmFb0Rt8cfGKE+vtrFAVwrtIbLrCnauRqhhrKzJOVoPbL8ksN0P0lcHVP2gDkh581BirwZWPjHlgaCuMpSRu/KyzrZbd1dCmuKrdqmpSCavWQ+btIX50sX9kettze2YZXcduInHSQ5YjP56kRaAQk6SfGsB86aD+Xy2fodul+RoBDcDw946XVVRx2W41pFDDdwKQEUCOqcIwGPwKR+h063DjojiCVjfl3UIYpsxK2C/AH8TbFRnwKDhHr3ccu8rPLhL04v/RQJ+2vdqA4JKdOUAX+JN3vyG7oL8KgggjiIvL2iR/aj7h9xczR+RPzkqdD7AYpGfCk2MH9KCue4YI37Xh5TYmbW1VpS2DsLo3SxjPZhG6fkIGfGIx4yUnDHgOHCbXohuZXpoyPfP3yhJ5hpl+5Pt7iE+t6u4YShcvedgF+5Yofxrv8DRm7aM6ABrB0pdCF58plwQq9WQDuL7y2BlJut5yZbfHXLzL3RJISrzcxyZJ7VbLHsZ8fNoG3UpWLseEEAjmJlAev26qj+I6N4LjP5nzVo7Fb7J0vkWRdQ29sxe4t8K4Mq7ebQ2A+gJW+PudDs/METn9QBIts8Bn10a0DPZiw2jvtDCzMfeWasq/0cgIPXHoRoBXzUmrxpps1bZKUC7Q+V6z90Qt6AmlfBF7yKWQSPktPuE1ILBrRmF/4lmxVF6fBrltT7oiEbqZ2q8RdazLh620E/
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
index db2dbf84943c..5a3626dd0c18 100644
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
index 0b279b82eaa6..d17ca4d2bb39 100644
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
2.55.0.691.gc56d675ccc-goog


