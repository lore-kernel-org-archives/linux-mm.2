Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7855BC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BAC6B05B1; Thu, 13 Aug 2026 15:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAEC6B05B3; Thu, 13 Aug 2026 15:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537866B05B4; Thu, 13 Aug 2026 15:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00D4F6B05B1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:35:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCE2D12025D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:49 +0000 (UTC)
X-FDA: 85097248698.22.5797F05
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CC2240005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RVOAcMBG;
	spf=pass (imf17.hostedemail.com: domain of 3Vhx-agYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3Vhx-agYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649688;
	b=O485gdVL7Mv/B1vRrthmaR9dawwib4Dh0XKBvo2EEsBPWxurTbnbU8iNiVyIZeoGszmIA2
	6cBPgvTf7MPXX344yxMZZvqrXR/ATmOMPJKlxOazFTUAKDTNMKbM42sqllQ4yAjw9L7AkF
	pB84YZ02Q2bpbyWRy0Z5P4+AXPUG8zs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RVOAcMBG;
	spf=pass (imf17.hostedemail.com: domain of 3Vhx-agYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3Vhx-agYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
	b=BneULKTbYGnZC3DarXjhvwh93XTtbGZQmJHor97ydnwdPW7UxTmhUyHd75+SvSA9XUtjua
	ph4KS7FdiZRMCiu7a+j83kd/XJsLeUNnW5gz/cWDZqlYXdlZGQOVy27iIThvqVDADvpWo2
	T/yoUe4+V2ENQxGrF0GsjI3vrmWSBOI=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8488ac68185so297655b3a.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649687; x=1787254487; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
        b=RVOAcMBGJ1xyiOc4mdxy+sRlORELvcmHHaojEmWOownXfXaB7JSMJxE0dAaYJf3VD+
         npGc4kGyCVIeTijOrIOZiBqQRO+/8UNBFgPBaX67yxLe4wUtYCQvP3JdT+CXTq53ZCdr
         SKQr2IDUoA6dgqBuaAZXx+Y2nL7bYFyxLUcxpj6dX7FUnuDAJkNlt1f/z4WJSYxPCmsq
         JGdW+nVAsp2OTr3PufeUOOwoAaVx6kJjVsLdo0LGUytHL+UHEXq33liBVZ3hGoYexb2h
         Sq0pV+T/lvYtH8SRH4AzJ872lltWNmQ9WVRTZIZO23xcIpTzSSb7/8kSAQ23RoloIV1S
         oKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649687; x=1787254487;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPcWv3lIZQHmlL4xVWCaljaB1PQXpS1s6XfJcGGVLeI=;
        b=P/0UAjMi5+rMr2VtGzY/CrROsbbPQUUOo3DbnNmzBGNGUtUDvZrJgN1aMioAoC4WBO
         bi0z+p4tFfQfxwb3e9nwLLWOH2orFOOTeaTZAFr+rkGx3zpCSuD6RawrYx+ekNb5vUCf
         AvMtxxaYwBSfVKVPIVqO2nE5cbOvLnDckGzR7GaC6EO4Eu6yEJRa2H0amqTZvJ5tcjV2
         oClgeFb7jaEwvzTw8diyNUT46QlL3jRRr5Q+CK7TgqqSdnYnsOYtVRd26Gd6bsJtcJ5b
         819xJRjWAyV+c7GxJUEcZZ69XwRUWKNosjdUIIrgaGKAFG/xNF+uSyPvE7AR26WMqo8/
         QpTg==
X-Forwarded-Encrypted: i=1; AHgh+Rp81qsjtR1uLl8p5aXpp6kRfxch3L7BI41pD2Kv0in5oObl4Lz7FwZtlE2Fp3hKaObkkzUPjX1e5w==@kvack.org
X-Gm-Message-State: AOJu0Yx3CJVjGI+P4SldReaz4BN/ZvR5kgGV9k5+eGTzCuOYL0DXHtGM
	H7An6KoKQn9D75Vn9CbE8elK52gngPpjxTBur++3ru2OAuwMR3CZTEHsl6RnLm6N0VLedfBIqmL
	KOkPfcg==
X-Received: from dlbbo7.prod.google.com ([2002:a05:7022:4387:b0:13b:a040:bbf1])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9183:b0:3cb:b6af:e3a6
 with SMTP id adf61e73a8af0-3cc71ddaa9emr62561637.27.1786649686699; Thu, 13
 Aug 2026 12:34:46 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:31 -0700
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-4-surenb@google.com>
Subject: [PATCH v6 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
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
X-Rspamd-Queue-Id: 0CC2240005
X-Rspam-User: 
X-Stat-Signature: 1egyxgoimfz1gjdch77e18hco47ghjp5
X-Rspamd-Server: rspam06
X-HE-Tag: 1786649687-548955
X-HE-Meta: U2FsdGVkX18fxd4QaGz3Vl4i1lfOAE4AGjMN7Ah2oAeGEAK8ieKlk3ouuZFdmV4CuKkvmpPdN9bvFwiO4ZPi4nTW/jBCm3NBMw/4ImT3+NxNm4XVIER0RNj3AY85hocQslsJv9EF9yzdS5teMOwO3L+pQlNExT2X/qdA2zRFfPgNaLNoSnsRzYfbpDsM7bVVemc3POjfYxFgRjLTrHiCXpuu5HSYRpz8pLaV+wGmxnX9CNlSE1cpBMbn1WsfrtK3LI4YarrFM96TDL9m8eMP2mr2SKe6UopmJVsTXj595adm1t688ofB3brKXxY8w+JzL/tuBk1opbpffiqDty7vD3LxfyqD2WOY18laBT1TMqi0SLQD76afVaHjDZbX+O0quh+DCU2g/2/RgG1Xgqh1Fqb7SMwNU891oecaCTuB75b5SJabLenXRk1evJEhSIhXglfUFKtiuLv+zY+8ihI4gJebBKwObTNPZ4PCRLlv+2tK1z2h3avqukyMxZIiIG8fvLabMWWBVqM0Uz/MHOaOGL5K+FdBILBZkyXGc7KFRYdHOr9KXd+amDhCC0a706jio77LaTQwssS9m0+53iJB2pvuNspRvz86ZEhQy5tfwSuPBIAAm/JUCbWl37HAVjA+m7rjnHv3rsSNObKGWVQlVDXkSRBcexEvBUbhb8/NWOWikFmlJeIcjf9QVVV47aNoxPJnKsCJenamIXXSna1WHL7lmLU6od+bVgsPaSlWX1q29UqmcQbk7Q10JfhlgVn5HyfWN0XgUjRehRuBYJ50CIeX0No8+BKFFlAK0oviORIDxAwguJTz3mcBdqm3z25djuYmsCUltOH24d2Y+DY0ibLIkk2gw8Ew3pkyqSNmnyKM3dmT1dp3PpCo3S37/59BZk3KSZcgtTVvSHm4FFREe2JYxc3oa5vHfohvMbnbGmfbf+eFU3ZBH3RfPPZBca8rEYF4FaGbJMC1IvMbCRo
 ay0PjHMB
 FpfYlXxmKufgpDdAdHCnyf4W+WrvOz/367er13h0GKCsk63zFw4hpalfv0HV/AuhlTnqdmzOjUHhYTq8S2gPz4Rn8IBjcaAUuMgvihwdd8oFbtXH44TPnvHaVdH45d8K9+SwnHPJjRsMoayCPX5+tzPNe44kbFhsGmiu8k5dTbu8hLYyF6rhCWpcI8mT3776s1Tf3jmUqKA81kGLUBSilFAsCSPSzi8cX3TIu53WnuCUKTzYwe+CwEQBOB4aWBrO201eFGssbdN60ilAlpUPiFBcjQDJOKdlednIbbSMayaV0vUTBCJn1h6+Xse5nwSphUb6TAAMA/t0xD30YIXXBIxCZzbWluP2+DVE6HRTBBKv1Np7ppjHF42hPbhpB3jCRh1BbKO8T6ews7tBWXiVF3P1ImjzCKEuXxm2/n8VOku6Bnm92B2pc6eJLiq0yX5HFAo2IJkq/EyT/8ZiWzOlM1FYUpJjqsINDDoZL+/HZVS6w2sHERT5DjZfh+L507MNApz6FO+35fx7g5Hci2n6FcjSl+p2O4zIipcl1A9qLi4YWu5Uhfe/qhcBtwSqI/flprE7x4X5dEAo5op8oUQYrF+bNkGuHfywj36Zqg/37tZ9D6j9C7cj7J3S4HcRLHwuzzk24esW4x5TNJeUgnS+pu7+oiwSAlBPGMgHJSeJd/zQ0KfOg9i+QoBep4wkCLrehue/Xj0SAmmHka/WyrLsG8E+GDghzmKFfOIAve45TiZLVPhyHgZ+Xm/zqE81B00luQOBCXAiFQ2yshxxeW6qkXueLYg0I5o87nup/1goYtgcU/m3qeGe44LPJ6Gk0y+pDhuOLXAe76oc+/lf2Oj7wye5xFKSIlHTgPsyXO0h2atGFPNq6S5gnV8pZX57VYMEvWkgXS64IrIycmvBL0Iv3fH7YjwN5bvt/p7Gh6ZT/2WdeWzAjWX21qvYeSjy2agUHhmHf
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


