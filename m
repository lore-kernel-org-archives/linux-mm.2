Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7B3CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F195E6B0088; Thu, 15 Oct 2026 10:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA5C6B008A; Thu, 15 Oct 2026 10:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8BC6B008C; Thu, 15 Oct 2026 10:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3B9C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:37:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 312BFA0AA8
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:37:52 +0000 (UTC)
X-FDA: 85325114784.27.DDB21C0
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 843662000D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:37:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddbSipcR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wzlE60HTAGr+gfmDoDFGpsVbnSFEzyvSpQks7NPwYvU=;
	b=7z2RKs6N8jS9WOtXui5wxvh2drKkJnTbU5FjBaE9L2IHD3BZm8QbHB+1+l0B8HCoN89D/A
	9QIEAYBo++995DglGRI0BbpNaaJpbVugrWAmDwqOB0L/L0g/452UtEx0OUsC7cB1Ayaxbu
	Ztbfs1lZ9FQRsZZTrSAkqGQWtxGZBZE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddbSipcR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075070;
	b=HgJT/NK7z7qHghcN/fCJTSo83EmWpWFrTitT28d5KQ+k3ZdUckoK6sNeXohaOWi13fvrmj
	KlsGSThcvj//+iSbur/GuhufkgQ1oUvfwiigQax3h3nKbLSIqwbfmQoHz6OtvEAQSZSUHT
	2Rsz7W4UaCl++BaTUPLpseQidNI2OI4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so1442507a91.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792075069; x=1792679869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wzlE60HTAGr+gfmDoDFGpsVbnSFEzyvSpQks7NPwYvU=;
        b=ddbSipcRlRsZcvOVQ/7cWSvOeWfKQOiTJBVPk+CUVYh6N5F33YH584iSsCq+Z4qDYQ
         HIXIpsAMHuWatiwj0i7/XGHmnRwYM/YjWONKMNKvpnQgYnhzS6UCRxNyo04ixcPJvMAJ
         LrZiHY3x9Pt86DPGo18s3bsOsFDFGZMdA0UA9l4Bgofr/ekJjLKLBg0ePgX2LVatFe2T
         OOuFiooahmZqlShwo1WWHoT7kPvafHR0STnAUCare7Acen9QxF8dQry996AET91m5JA3
         uwjEk4GNk+5WszexP9TxvBwxIXMLFwr6Qi6zICjvNs2yD+5AjKW70qsES7dAgqL4Ipiy
         QJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075069; x=1792679869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wzlE60HTAGr+gfmDoDFGpsVbnSFEzyvSpQks7NPwYvU=;
        b=nZ+++sFT1mYFoWONi7rSD588x5v0L5MV/jN+9lM9NXm0/iW2oTO/M6YwSWv8rWEVmy
         IAYxwgCNpNA2h22VSm9AWoYBspiRsjhZvB9bTSE28OLLoafwuHGeQBCtJuT+PWgDGW1P
         /ARu6wEG8p5ChAAhlEtToX+W1YmQoGCQMfredYn9wu0aOsIKk+Q+Z4getpLPW/EQLRQa
         e5WkrgR+KVaHR3Y0kN/qZqj98vd6zLKV39e8VE6SzmJIKjBwLWUOGTPNDn68+7HYQDGD
         HuxBx/zMlKN3NeXmOzzzdMd8lV8px1I+5e0QvmvF42dxmslrdIqlZPYgbq93LEmHa3qy
         6UBA==
X-Forwarded-Encrypted: i=1; AKwUvBz7MmNGx6Uzdj8CRnQ7EC3Pp6UB/LrduUcTB9csdPHc+L4m1KaKNMSR8lj07hl+ZqMIzEvAzPFYAA==@kvack.org
X-Gm-Message-State: AFq9FYIvcbL8AdOPdftd5tcfwDwPSvaWTP0IzbzlHo2DES7lvhKfIegz
	fWwsC4v6uiMUjlY1Lrwn0jvtLcU8yWSNK3Gy5W6cEUQLZObiho6EiHT7
X-Gm-Gg: AYBFou2zwlRge/ZUkdP9tlsBG04vAjB8BkEi1efcreii41TASsMONspvmHqHAxqsAxx
	R1YppkJsAxAs8uffmHZsJjPp7xstvIieEVcLo43CyiEUZ4lihloJoqESzIfH9jHFzPUipZeiSi6
	amXLRFVIcekKIKbUXgbgNUvTABjMr8WWJxs7GvExjbWyZTCcHJLgHwW/zp7wCWvUnkbpcmLon1V
	36vC4s0zSrbvoNuY9uo4BJ6qHsHQRAQBMQO4DHwT3cnXJRJo20KwWdmNRf8NZfVamBIkaVtKhgx
	HtJ8OQtaimgGuUSxwPsivXPvrmhF/eXJXwiUd0pQbYsQWBo1XJnWUbhP2/Sbe1F6hEXmdyVKadw
	XagvqQ5w2yhmp9qoo/PlCPVi5ebxQ7gAtGfPUjbN93mgKNIBKCmfIUOFKDU9S8Amu5lvzcszzgE
	ASZsVNJMq8mgogofh0W0uBxMmCVLD92KDLYO/SRcKPUzKGCZldQg3VYgx776n2ekUPfXpZ5fDoi
	PgeDIiCn9w=
X-Received: by 2002:a17:90b:4acc:b0:3a0:e1f7:9b04 with SMTP id 98e67ed59e1d1-3ab3a60ac9amr17946112a91.12.1792075069046;
        Thu, 15 Oct 2026 07:37:49 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac936f89d1sm2729799a91.2.2026.10.15.07.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:37:48 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Jann Horn <jannh@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH] mm: prevent VMA generation reuse from skipping readers
Date: Thu, 15 Oct 2026 23:37:35 +0900
Message-ID: <20261015143735.1630957-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 843662000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 5yfjnyrywpqzqgqgtg1i5q3t8oeefwbd
X-HE-Tag: 1792075070-112846
X-HE-Meta: U2FsdGVkX19+7wbLqbwVjpIUHzl4NFshH9WGQMKkc4FUTdAo9I7McNzCD/nysXyxeVTiA55w+sji0OffuDvj/kYmVAkGw3+GhnQ0Y0Q7HWoMLEVxJI+Y8Nsc4dv32DI0EUnIyh70A1Q7Il1e2i6YQ4ovXs7IDRn8i4uhT2CMRB3VMRb2Uz3ChedKj4lTulMvFGJlNHNmuvAK/Xw2UEgU1I6yeraBCT0vTXbxiyUkoY40tOo0GkYHfMm2oof/l07ndME9whWgTtrQ2PwInYHEBKPhhLId9zRfjqwB8A6RsbFhdWCQrofakYNnshTuABjij1jVOYqqpTU+S/qvAOGHCA8W1WuZSAy/ZToiP93qJzDxFRTRCc4Yhob1UkhhnMmT+ofDr9RShmooccvKjUjoSq7PLVAMM0Un+rHypjQzAe/38OcFzdgDrqDVQzw//ZMoYf+sJqG1ebIWSYcamxoXSeYez/w93/Q4cLc3nLak3ntol9TlqWUwKTdVAuSPwtP78RjYoRezysJ47qA6eWiNiYSF8L1g1AwSEFDM5F2Afm6I+MypVDiEo+xPiVPRiP7JOteVob3rc0Qh10AKXfQ+ZSEtsoU1JsQcZ1hgIRYa2Ltt8SpIa6rFaW4Iwp2fvWdfkTXXWRQOLqANtHz/w6HeYvjSDLA9keWbLzlnXzOWe3zKc5hG02AYdhsI9fiAuVmoqrM4rfnMDMRba2hUq8NqhGyOWiyLRjGEGaXMeyLBbZt/cPGe3FLPTCvrFgJe4REF38PktcJCRJNRBbdcSIxa8QUqBeL5Tj9C2gDyNrOZGGLyaElPfOFqropj9pFD/DbSW0rC2lwDwmh78lWpREFqiRMUs5W94oTUaGkmw37j+p/nIk6y5cHTrWA3N+rw9JXYoJDNTfH76dR2bN4LFVc6IcKEMXthmTecBs+h4RlRx46u03iGoYRXxYFgZQxozww6f6kpJFBzJ7ewEwyl6Ss
 3Y/FX36E
 WmEIuf2eiPqyPN81UVzBGxOQEOasa+oJzdBF1UDKGWFtXLeTzbjBMmZfyz6pPMu7WrZ2waScGo5370uomkOwT9vB2V6DnztNLFKzfSpJ2qQKA1QTSzku4Ks7Izju3MPaTFtQxrjxajuMxl05kpPpllXeYgoFiJe+2ySW+ZzzPj8FlZ3n3eLQpFjWKbcES8a27cWw6/3/LqDDXnjaD4JGC3C8/x0MzLXDXvi7GIdsJY2PRsR6lj2IB9RKkTarvk/aYn1lYphImvuT6ZCIV9yRyZA6lqnMRnCY2kwTJnCRGKTg31ss4AhiJvcvS3IrZ0m2lvL65zINJAHR/ZubggazrtVbU40YAfxBo6xAksXQUQFyfNVqXAVIZiGMRzEElejvsnxnTBMST1QBRyDVAqTJTgqUdCaFvHayT0VaKO1ifLNYUdnVUJwG0rZf8Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Per-VMA write locking treats equality between vm_lock_seq and the current
mm_lock_seq as proof that the active mmap writer already excluded readers.

Both values are 32-bit. After 2^31 complete mmap write-lock acquisitions,
an old VMA stamp can alias the live odd generation. vma_start_write() then
returns without waiting for an existing reader.

A capability-free reproducer uses brk(0) to recycle the generation, then
races an anonymous fault with MREMAP_DONTUNMAP. The stale equality lets
mremap move and tear down a PMD table while the fault retains vmf->pmd.
Unmodified kernels panic in folio_add_new_anon_rmap(), while diagnostic
runs show a freed PMD access and a writable mapping created in another
PROT_NONE VMA.

Add an epoch that advances whenever mm_lock_seq wraps. Stamp it with the
sequence after excluding readers, and require both fields to match before a
writer takes the already-locked fast path. Reader checks remain unchanged;
reused sequence values only cause a pessimistic fallback there.

The fixed KASAN kernel completed the real-wrap THP schedule on three fresh
boots without KASAN, warnings, oopses or panics. Kernels before v6.15 use
the older rwsem-based per-VMA locking and need an adapted backport.

Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Link: https://lore.kernel.org/r/20241010205644.3831427-3-andrii@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 include/linux/mm_types.h        | 10 +++++++---
 include/linux/mmap_lock.h       | 14 +++++++++++---
 mm/mmap_lock.c                  |  2 ++
 tools/testing/vma/include/dup.h | 10 ++++++----
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f3e5a2fadbe5b7..309a278e552451 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -961,9 +961,9 @@ struct vm_area_struct {
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
-	 * This sequence counter is explicitly allowed to overflow; sequence
-	 * counter reuse can only lead to occasional unnecessary use of the
-	 * slowpath.
+	 * This sequence counter is explicitly allowed to overflow. Readers can
+	 * treat a reused value as a pessimistic false positive. Writers also
+	 * compare vm_lock_seq_epoch so reuse cannot skip reader exclusion.
 	 */
 	unsigned int vm_lock_seq;
 #endif
@@ -1004,6 +1004,8 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
+	/* Extends vm_lock_seq without moving the hot VMA header fields. */
+	unsigned int vm_lock_seq_epoch;
 	/*
 	 * Used to keep track of firstly, whether the VMA is attached, secondly,
 	 * if attached, how many read locks are taken, and thirdly, if the
@@ -1274,6 +1276,8 @@ struct mm_struct {
 		 * mmap_lock.
 		 */
 		seqcount_t mm_lock_seq;
+		/* Extends the VMA writer generation across sequence wrap. */
+		unsigned int mm_lock_seq_epoch;
 #endif
 		struct futex_mm_data	futex;
 
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b8a13b8d36a45b..27caf8818e0b75 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -118,6 +118,7 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
+	mm->mm_lock_seq_epoch = 0;
 }
 
 static inline void mm_lock_seqcount_begin(struct mm_struct *mm)
@@ -128,6 +129,8 @@ static inline void mm_lock_seqcount_begin(struct mm_struct *mm)
 static inline void mm_lock_seqcount_end(struct mm_struct *mm)
 {
 	ASSERT_EXCLUSIVE_WRITER(mm->mm_lock_seq);
+	if (unlikely(mm->mm_lock_seq.sequence == UINT_MAX))
+		mm->mm_lock_seq_epoch++;
 	do_raw_write_seqcount_end(&mm->mm_lock_seq);
 }
 
@@ -157,6 +160,7 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 	if (reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
 	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq_epoch = UINT_MAX;
 }
 
 /*
@@ -281,11 +285,15 @@ static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
  */
 static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
 {
+	const struct mm_struct *mm = vma->vm_mm;
+
 	/*
-	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
-	 * mm->mm_lock_seq can't be concurrently modified.
+	 * The current task holds mmap_write_lock, so neither generation can be
+	 * concurrently modified. The epoch prevents a wrapped sequence from
+	 * making an old VMA stamp look current to a writer.
 	 */
-	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
+	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma) &&
+		vma->vm_lock_seq_epoch == mm->mm_lock_seq_epoch;
 }
 
 int __vma_start_write(struct vm_area_struct *vma, int state);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 898c2ef1e95803..281659225b1dbb 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -139,6 +139,7 @@ static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)
 int __vma_start_write(struct vm_area_struct *vma, int state)
 {
 	const unsigned int mm_lock_seq = __vma_raw_mm_seqnum(vma);
+	const unsigned int mm_lock_seq_epoch = vma->vm_mm->mm_lock_seq_epoch;
 	struct vma_exclude_readers_state ves = {
 		.vma = vma,
 		.state = state,
@@ -158,6 +159,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
 	 * we should use WRITE_ONCE() for cleanliness and to keep KCSAN happy.
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
+	WRITE_ONCE(vma->vm_lock_seq_epoch, mm_lock_seq_epoch);
 
 	if (ves.exclusive) {
 		__vma_end_exclude_readers(&ves);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 4c58487b764e9d..211ffbf5850057 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -571,9 +571,9 @@ struct vm_area_struct {
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
-	 * This sequence counter is explicitly allowed to overflow; sequence
-	 * counter reuse can only lead to occasional unnecessary use of the
-	 * slowpath.
+	 * This sequence counter is explicitly allowed to overflow. Readers can
+	 * treat a reused value as a pessimistic false positive. Writers also
+	 * compare vm_lock_seq_epoch so reuse cannot skip reader exclusion.
 	 */
 	unsigned int vm_lock_seq;
 #endif
@@ -611,7 +611,8 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Unstable RCU readers are allowed to read this. */
+	/* Extends vm_lock_seq without moving the hot VMA header fields. */
+	unsigned int vm_lock_seq_epoch;
 	refcount_t vm_refcnt;
 #endif
 #ifdef CONFIG_64BIT
@@ -1230,6 +1231,7 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq_epoch = UINT_MAX;
 }
 
 /*

base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
-- 
2.55.0


