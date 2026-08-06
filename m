Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A085DC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872DF6B00A3; Thu,  6 Aug 2026 16:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823126B00A4; Thu,  6 Aug 2026 16:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EABC6B00A5; Thu,  6 Aug 2026 16:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 454866B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:06:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7412C0226
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:00 +0000 (UTC)
X-FDA: 85071925680.08.9CB6CA2
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id 062A31A0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=msBpLfGX;
	spf=pass (imf19.hostedemail.com: domain of 3Jel0agYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3Jel0agYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxdxEYaVQTOzSX1A2H67ZbXWMmNc4RyRDurH1LCMnVo=;
	b=XcjB+PQraIQBhzJ6kUwt7HHQ4iO4058YF+JxL9kGdOOmlWWWVXJZhK4prcxVaZ9fmOPvaS
	B0D8tNPahX/tPw9Gbj9feReJYfIyQWzo9him4MC3MAlKNuMcz8zmamVQL795qqn2+MIQkA
	aR3XuFQQK6QSCnyrNFuVlCQzCuUsb7A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046759;
	b=R244ntbHMYQu2TRaw4/IR87Q+f8XZJTV/ZJ4gnRB4q6A+watWPlo/c3nhC5lo/p/Dpl2PZ
	9Xxq6EOnBb3KXiYgMzy45st8Vl22prJNXtmbLw4808s2dyaZltsJASMXlGK2gTH1w+4qSV
	sQwPpr/a1aPqa6emZNtWWywACWtdCOQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=msBpLfGX;
	spf=pass (imf19.hostedemail.com: domain of 3Jel0agYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3Jel0agYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb6433e9d4so3209553a12.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 13:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786046758; x=1786651558; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WxdxEYaVQTOzSX1A2H67ZbXWMmNc4RyRDurH1LCMnVo=;
        b=msBpLfGXWQz2+DcTtBSeMeiuwXTyZB/wQfHpRqQtuKBxCccFnHu0VtgKeJI3Du7EWy
         Qo699h9Z8CFdddTu84Z/jKI7SUxiXws0buVPxAIJQHJxYfM3dY8kgrlUgisiZdvhsYhy
         MpDkGY3nZ9Hk+TUpzwRmrzd3DLYDDohI/iqhwF8Z39ySFEWSd98EkpSugWGe1PiK5reK
         uFrSRtqQfw4WMyw9+o6vuYeOxESwUV7KFDaVayl5MdW7x6XyMLqniCiS0fsi8BmSvgT9
         OovT6zX9ldUt33WFaHpma1Se2rVgntWdK9hV6ncECiYHLUE/dRqpXqWrpBRDPj6iMu91
         Tcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786046758; x=1786651558;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WxdxEYaVQTOzSX1A2H67ZbXWMmNc4RyRDurH1LCMnVo=;
        b=e1nB9isXhlePjVwlc6q1B6hiL/dyAUf2JfzPizbmA9rjlpxgQDAFeAWucrVJvzcUGZ
         XzMo5VtPhywbumZEi0FGow6byEMjITeuKDqc9fhSCzv0WITP+VFECR75cI1YVlA40I0+
         g3YBvwVjbAOuMNc41PSALl2P9JbR6C8A16fvvsJ8PbpNHTFwjl8toYuo5aeJ83Cb9y5E
         rPlOIyQkgcOH5qpBldS1zG+k2S6pipUqBTMNv9bCrWSyp5z0RbUTacwNQIJcZHRCqCPk
         2uvwHthSb/PYnIuqmwsZXydEK2Mowoer/dIYxvUab5S0m0CuR8l2JUS4Q7qJwce8JU9h
         Z3lA==
X-Forwarded-Encrypted: i=1; AHgh+RqwAP4g5p3hZLrTbDRhMy70qyyqvzLKLBhfaX2JCmp/tt6wX1JbSo5GYpGco76MMZdg5jlr8QThlA==@kvack.org
X-Gm-Message-State: AOJu0YyPDsEDbCXlmHvkAQS0wsEnx3wHU7WI5wWfK33zqhtXdPVf0KeQ
	HlNoN8+rW4UmjW8K0LGlNpdf6uP9dP9Zr497ZxOOas0uDevMKiOnZnERRXTGt1aW4M3FLXXqDYQ
	Z49L/VQ==
X-Received: from dybgk24.prod.google.com ([2002:a05:7301:198:b0:313:cf3c:796])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a03:b0:398:8870:b58f
 with SMTP id adf61e73a8af0-3cb85de7ddbmr20267974637.14.1786046757653; Thu, 06
 Aug 2026 13:05:57 -0700 (PDT)
Date: Thu,  6 Aug 2026 13:05:46 -0700
In-Reply-To: <20260806200548.3124802-1-surenb@google.com>
Mime-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806200548.3124802-4-surenb@google.com>
Subject: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cc3h81qmy7dugjuyaf7jqtie78ejp8o8
X-Rspamd-Queue-Id: 062A31A0003
X-HE-Tag: 1786046758-550663
X-HE-Meta: U2FsdGVkX1+NF6+a52zdy5f14Y94ANOQ+zWW8hWEMg2CNDNvJf9cTvt5xwYGMYjkRPql48VRaKRKTOXtQsmLoPcgpfVLZXwmmlr+H9kn+JcwQsgaM6x6iKJFW2pfc9ItOHnKolyIp0tBZ71+A4p3nfRjaK8aMag2er1GGydB16eogfdiIpbdq4nJcaqeu2ZmCuVL4t9tTs0ttiuJmt4SErgF7vCIDlJ8NskDC55KYaDBpCAIPYz+dVWM9lXMABKMmy/f8WEUx2GoqUomJ9hkdItZ+frcm3Dd+fcUi6HAXzqUdXs12G2CzuqYjfwmC8xOzkFiff04zxkou2TlzIRg2L8Y1GwH2cQB3IrfFbjaCtjbq/6P661cbxfzEwMaJMe4/logXbyr1H5B8B+8cBY8HpdfIqwejYsf+wq3PklUB5INYKBTntB4lBMRIFCrooKYPzjA0uREVTFQE1bvdUwIxEigBw3ggE8UTSUE9M2+kjyLiYdA1UsWsvQEyBHBF37YGwwuFKzh2Gj+BiaxBjFU0BjImkG9wsCPyJrPIwASRo7j9DDp5IwoQ750ow712IJuTwSphfUcnAWxF3uygFLoaOxsgT+ZpgQuWz1EdAthDywHD91tpKSD9Ve/el9QYtHSbZXZp42RuA15K47ERtLVJBf2LrQyOPE/28/b7FsRHWfiMKG9B7LlGSY313TuAlkXJkPKvmyIjicVK4Tbsnpxq1nlEHBFhHjQrQt/2jxqv+vZ1T2yxn7BcOD5Ek0vCiYnlHSAtsPI9ruf4B2TkX5jQ87+5mL5WKBDZdmHPdOuQ0ALAiyPf2M3flm4lk0qhpFW2xuPFS8yJMZGdvxCI+bFDb5gd55zzGwhYkVraU8Tvv/HpXLTjKl53E7lTuDZCz8I0b4YPBmQJXBz+83OBV9bhiWpNGqlSlBIFJOwWDg30hTtsL5J8kceI111BweHPCon3ULLWC9lUqGCI7mZpgB
 Y6kNpSSt
 e9RN5jmBD26AYYueTeszrPy7L/ATcBdNd2YHap6d9ASAMlUwJBgzA6KWmv+3OJBVg/aHmu2SgijA+uwCMlcXOdbyB0BVoCwIZ51k/I6aPOhb7rLP7KJwkE99JuogUj4sQwSPOPuh1eoZ6PlaTdMR5LgTyba9/2NMpUFTxYF2Dk58vESfnYXgNuLxIf9xxrufYGGhjJwDaGMbXHBYsWLnhsEhQOhpjMHZ7Yca8T1wiw5ASrvEWnA2KEnmH/MngyPdGuuctUCvnqwbYCc9moCF9LlTo/7AxoHAuX1Hut2PaaXlRshhnq6ehtA5PYlIDsxKQTQNYI5pvHrL+Amxd8HSvfEuWXEJlnWnAk0xZAtpsVYHpXcEuuTyzTebMxLl2eDfz9v/FGMFx+sPRb7vG9kQLeFVu9C5i9jBtvjiB9rYjflYiMJYa8eeEUcJRlX6IVIyAn7AA60JDWtONMIk48m6ZSEzAwG8htQkqYHVso0heXOtUig2xc1Wptrj6SXKFINCWWtL7cECjWrazTalNfVvJrS5/NYLnEeKmHZKNAeux4apiOUAciGCM03Cz9FGahxvp9OiLCJdFboX6tjTQyf4pvsilW65BuMfZBy7yFiV1nI18AlDwoAkVx/ks4GZP5QeOdvb3TxU3A8hVJMkVqeFYrf0fWzNRfov2/66MhwQdLs4RSIEZ2kgibwu997xxJZjwmRwSaDn429ehJUTqS7NeMKj3d74mnLyskXoQvHfdCznqMS90Dqh8f1pp1A8fIJNcOSBCh1ZTUIXqjPrHWrGs9kaLVwQnMWigyh/Nd01IvZIs4oZSV9x846+Pfr5tCXX2beKJOhk92g4T5wHPyOUThYPzCJqV+2eT4b2+XKPQ/zBoswocoF6xj87vsgTbNQMRcADWDgm9qLqk525TanSga8J2U6znEjMBjuPbk6MNjSnk/8BTEn3i1ly3tUcNnVeUs178
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

=3D=3D Background =3D=3D

There are basically two parallel ways to look up a VMA: the
traditional way, which is protected by mmap_read_lock, and the RCU-based
per-VMA lock way which is based on RCU and refcounts.

=3D=3D Problem =3D=3D

The mmap_lock one is more straightforward to use but it has a big
disadvantage in that it can not be mixed with page faults since those
can take mmap_lock for read, which can deadlock when mixed with nested
page faults and parallel writers.
For example:

	mmap_read_lock(mm);
	// Another thread does mmap_write_lock().
	// New mmap_lock readers are blocked.
	vma =3D vma_lookup(mm, address);
	// This deadlocks on mmap_read_lock() if it faults:
	copy_from_user(address);
	mmap_read_unlock(mm);

The per-VMA lock can be mixed with faults, but they can fail and need to
be able to fall back to the traditional way.

=3D=3D Solution =3D=3D

Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
waits for writers. This is basically the same as the existing RCU-based
lookup, but on a failure to lock it temporarily takes mmap_lock for read
and waits for writers to finish before locking the VMA, dropping the
mmap_lock and returning the locked VMA. This has some advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. It can be used in contexts where page faults can happen because
    it can take the mmap_lock for read but never *holds* it.
 3. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster
*and* simpler code.

While at it, fix the comments for vma_start_read_locked(),
vma_start_read_locked_nested(), and uffd_lock_vma().

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/linux/mmap_lock.h | 19 +++++++++++++++----
 mm/mmap_lock.c            | 35 +++++++++++++++++++++++++++++++++++
 mm/userfaultfd.c          |  6 ++++--
 3 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 7b2bbb09a952..a23fe6cbe301 100644
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
index e20d01e8d38f..1c4902131e98 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -338,6 +338,41 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_st=
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
index edd90892f8cc..c3a0c38a3dc3 100644
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
2.55.0.654.g21b8a5bc05-goog


