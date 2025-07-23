Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C43C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988A56B012B; Wed, 23 Jul 2025 10:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938956B012D; Wed, 23 Jul 2025 10:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8012D6B012E; Wed, 23 Jul 2025 10:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6206B012B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49E2EC0720
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:48 +0000 (UTC)
X-FDA: 83695808616.11.7AA4A0F
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 874AC40005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=gbY4FXcG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282066; a=rsa-sha256;
	cv=none;
	b=77lyB2uumVQYS7+zEiV+XOiUtzMZpVaIre9CfH7dyBZCKRyZQ2r15wN9Fl7A66D1BSyLdI
	p7XwUBpIGap8WJM8JIhwuFSt4c4VjiXvjYcF+RmaLuKezLgHB62/z9nyGGrQsChpVhnemH
	ChLTIhSJYjfMquoTsHoJf35huLz1ySU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=gbY4FXcG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4VVvtVDYrPoMJ5697caghWAOTwp7h+e9BDkNCujjMk=;
	b=RQW2VCj+lVgMdKmRkHjsU44k25ZB0eJQfm62fmFoNKSP8OHgvTmIqgQMvhiMmoMTKgi0oO
	cS64sfOi9kKmOBCVrLl/0yfyvjl9QikPoCqY/yKNBed/J2TdiTxBI0/OwGXnuRfTlc3/sP
	DFAzppjLcaMVfmGv07gwqgQBnKaxGLI=
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e8d96ff2dfaso3534051276.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282066; x=1753886866; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p4VVvtVDYrPoMJ5697caghWAOTwp7h+e9BDkNCujjMk=;
        b=gbY4FXcGJwq28vPVlAQZ8/szIjU05ZoAy3+2weW2I490Fwik+Ym6mvLo03aHBiN5F1
         fMWoQUZ8O9WVR8nBoTEOUVI7wVEP14Mf0SN2ac2lA97kWwmQjrjmopwrSxrIjzfTla7g
         oEPOXWBymbQBDuukVm+sfEu8Bn9ne+wVJrB3F+u7X2HrfJAiT5mUYUTfeDCcYdKIoHCw
         5jnbJMedGKTFtxiLV/7ZMyt7KhN86/Vb58Fa5+szS2/duK+BF+IH2zduaNcRnnbdLWfg
         0HMZpzzZOb+i+WFPZTmrM6RCk1EbNsCdX6aH0pNB3Vn82S/JlShmiBNtaReKWNYXk+y4
         kx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282066; x=1753886866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4VVvtVDYrPoMJ5697caghWAOTwp7h+e9BDkNCujjMk=;
        b=Zze6bNkoKuu/d7LSOtbsnQId1k2UmC1rx+SgNz25KLOeWStsQ/KerCfPt+t/fSq0Ez
         52kTdYDk4ja8OzXRSVdK2jErWEzUo1cWN9Cy6B5hiO5GQQSJeUiJIoN/tyq3r3vWldx6
         WJGA8T3W9uVJHmdFjctQh4nfZhlnfTQX5GqRgmUEtoRWC2+NES0RXS9rkaC2s5TCpn9Y
         NjFZpO3Sfy4s0bgXjOFuBovHWMyNYtmdqUQ4SC/aBPTAWVKaxg4+h4HJUl/L669J/VVq
         IvbRAV9so6oLswPHENCesnwdwce1uOQn3yYgj/0rUE7rUsh9B3n3XIeWvTSklJZCHQmP
         o0FA==
X-Forwarded-Encrypted: i=1; AJvYcCWENBv0hKNUvf5mqt7NDIPEO76CIVGvL1ySB3JBcAINtdxhiwmCNjR2XSaV36bOaycMAlVwfAWrLg==@kvack.org
X-Gm-Message-State: AOJu0Yyjb9uJMeqvOQCR6OJX2COCUnySaBu9Yy4MaZ/c0MslM1/pqdgm
	RV2xzAn07yptrc78Bbv+DwCYgCRdntoYmiqHwI0Mxfhj1IuWcEZCX27kh+QQZEUCjEg=
X-Gm-Gg: ASbGnctmqmXuof+oM+Iy+ZbjfrKmilWUK/K0mhs0dX2JFrxJuET3MT7BjN0fHGat2wE
	Ii4ahdr2EgiW7LVjgSxXHvi+kHoRBPCq6fy6gn4MT39tnFDXkoY0bpW1eawtjx1nAvNGwjd0GoD
	z1RCE4smYTlA+sDt2DFLuRfaVVOoQrjyhQRVPolWwKsro5j4Ue4u9DacI0PlYQI9lthG3t1OwLI
	sYWrZ6KG2/FkYW0+Vjh6dUekify+velrY0ay2QpMW1euLmfWjbFvY148pqiqjsNuTyrA4nlGgrd
	EYeCV1QkuBMKea+LCVeeSslgR93QVuSQBTzRDYq0xwB+b8tUg9WlNNcR9pw/QH0sjHpq8xam6Fg
	Kj+MYASClSQsABworZRB7z3G5LGMzJ8/m2/Ejj23uXL3SxsDvq8E8FVMoeRC6ncSTgqf4AoWHGF
	W2c49dY3aZNSQKhmWjWD/K7aSz
X-Google-Smtp-Source: AGHT+IElamuRa8AIfKQOvI7xwmAtMtuuPebAeCpy0BgVpmPLxZTObJATbGExKCbAoZbplohPzmoJHw==
X-Received: by 2002:a05:690c:25c1:b0:718:85f1:76d with SMTP id 00721157ae682-719b42932damr39674127b3.26.1753282065581;
        Wed, 23 Jul 2025 07:47:45 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:45 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 25/32] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Wed, 23 Jul 2025 14:46:38 +0000
Message-ID: <20250723144649.1696299-26-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yruaesr4c6w7kpzkhi5j9qn6zgkmo3k6
X-Rspam-User: 
X-Rspamd-Queue-Id: 874AC40005
X-Rspamd-Server: rspam02
X-HE-Tag: 1753282066-695277
X-HE-Meta: U2FsdGVkX182ZfvEWOjl0GUWIidVH/pMOahmnRAjdgjNU9M5reMKLeAvgGpjoV9KCCkZGlwX8N/UFe+5VVwHx1c6t38QezcWIPHvAQb1QNz0/CwbKlnKoTda1wXvkO47hGX5PitUxdiAYjLlwtdXRyXzoK0fWLn9DOOxDRQcvsPfbFKyV+BnMWwpQdhLFntTh8gM7A/gKrDwmvq8Oseo6ln1T6EEgQLa/WaRTWLr+5Luh8E/HDwXPIH8BMiEs0rTVHPg//1itr5gPycRkTE1lqtdt2F6DCHBepkJBEpd2qgMktEsip4O0eOL9Ce41/ee75cvr5YqJUKgCuEWepQ5Tcb9OVYeOhjzEt36MbsjH4x3vP5SSaaekuLc7a4kvwfAwCyDjJfY+6M+wocogYXDyew+HryJRyYbohoaqEw9G+HgUGJ2D5TOGgmtL7/rwPZa/pR2E5Ifqt/33zffaCIO0BFaWtuqYygL7IRVIR7pkKnwOWdRMWye5ofZ0cAONIgfax+1k67yOGd673gvGC86or+OEKH7Wz0sRkeyqOvVUiBTzG+7KUMMMUGgwcbFT8evB48+wKf8n0Q8tM3bTZLBwnnh/ZqRB4iHwSyejkpd9XZEzQ0xdum3B9f/GiBo9ZYQcwX8BgA5NiATegp5A0tbgnWH0gYFYDnd9AAqt2u5SD/7DK1ToNcCRolvnkAJ9WD+/7LXn1Z1gbcknsmsF27vXCACm89i1GQh7EtpRLxS5odyQh7NhfrBGVngBxMD3lGojGZguqpbff3rX98U4O5zjGtR+Y6tHcAtI/vqgDGqHqQgjFZGwCYRsryarraWcLL0XeC7WKIYYis6miC2utylZXKbOaMbah8SAAd/x2JjgHLl3bFWlHmRbxlZWKGSafD2iUcIrKlD0WD5+KcnrRFKmF0NuQMy5dxWVe80BppizXv5UJja3kG/k9HZoG/3Vh6kE22RdlaRNiTz2xo+aep
 pRzgzWI9
 ySvDk3yeiXPJsucrsmP9/CDqShJyw2ezSikkPHKI/FUDxIIWeLprrejVPzHrVb/tF0TUK6J24EjjRhYVjgc2ShI2qejvYVV3s7AtqUTt2iD4p4glu3K96sXKXPFfZIVrT7ibBVOD0k5UTocNFW/1+VTLEPfFpTjrp5QayNlNvKDWxED9Hb7C8Gw7EY4k7CvjXbqpdhiYXKBAWvh9x+UmMsfghzS4J6HLtK3s66FAIPL1y+P6jy/cAroA8fMoQpDjSQo6hfL7DNji2jPko9WTsuc19EvvQ/wlzQCqhrzF5Gq+hd1tI2OBJ7r+uUKOpUn7jRwZBNnlsXLp8d/K0vQttczNK0OHR1XgjiqrLht16TPilgaRS9gtW3gEBnkpdf7JGxZSZfXQ0uLcx1oRolLRj8X2RFM2AjpqfkNl35RgAJQwjV6mKY3LFcCVotGl8BlI6nSqVbNBaVdXWSciZQtpuf2ijpgi+38jYiABcfHOiIJ5wNd6lmLH3e0TCGcwrHnU9MVmyNjoQwf/TiYQdJsSFRr3AevHRi4lASWojYm5Pm2GhWl3qdkvBwIFCz83WEuR5TZY0aUXRiXrxQOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_info::flags can have the VM flags VM_NORESERVE and
VM_LOCKED. These are used to suppress pre-accounting or to lock the
pages in the inode respectively. Using the VM flags directly makes it
difficult to add shmem-specific flags that are unrelated to VM behavior
since one would need to find a VM flag not used by shmem and re-purpose
it.

Introduce SHMEM_F_NORESERVE and SHMEM_F_LOCKED which represent the same
information, but their bits are independent of the VM flags. Callers can
still pass VM_NORESERVE to shmem_get_inode(), but it gets transformed to
the shmem-specific flag internally.

No functional changes intended.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/shmem_fs.h |  6 ++++++
 mm/shmem.c               | 30 +++++++++++++++++-------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5f03a39a26f7..578a5f3d1935 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -10,6 +10,7 @@
 #include <linux/xattr.h>
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/bits.h>
 
 /* inode in-kernel data */
 
@@ -17,6 +18,11 @@
 #define SHMEM_MAXQUOTAS 2
 #endif
 
+/* Suppress pre-accounting of the entire object size. */
+#define SHMEM_F_NORESERVE	BIT(0)
+/* Disallow swapping. */
+#define SHMEM_F_LOCKED		BIT(1)
+
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned int		seals;		/* shmem seals */
diff --git a/mm/shmem.c b/mm/shmem.c
index 3a5a65b1f41a..6eded368d17a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -175,20 +175,20 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_NORESERVE) ?
+	return (flags & SHMEM_F_NORESERVE) ?
 		0 : security_vm_enough_memory_mm(current->mm, VM_ACCT(size));
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
 {
-	if (!(flags & VM_NORESERVE))
+	if (!(flags & SHMEM_F_NORESERVE))
 		vm_unacct_memory(VM_ACCT(size));
 }
 
 static inline int shmem_reacct_size(unsigned long flags,
 		loff_t oldsize, loff_t newsize)
 {
-	if (!(flags & VM_NORESERVE)) {
+	if (!(flags & SHMEM_F_NORESERVE)) {
 		if (VM_ACCT(newsize) > VM_ACCT(oldsize))
 			return security_vm_enough_memory_mm(current->mm,
 					VM_ACCT(newsize) - VM_ACCT(oldsize));
@@ -206,7 +206,7 @@ static inline int shmem_reacct_size(unsigned long flags,
  */
 static inline int shmem_acct_blocks(unsigned long flags, long pages)
 {
-	if (!(flags & VM_NORESERVE))
+	if (!(flags & SHMEM_F_NORESERVE))
 		return 0;
 
 	return security_vm_enough_memory_mm(current->mm,
@@ -215,7 +215,7 @@ static inline int shmem_acct_blocks(unsigned long flags, long pages)
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 {
-	if (flags & VM_NORESERVE)
+	if (flags & SHMEM_F_NORESERVE)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
@@ -1557,7 +1557,7 @@ int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
 	if (WARN_ON_ONCE(!wbc->for_reclaim))
 		goto redirty;
 
-	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
+	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
 	if (!total_swap_pages)
@@ -2910,15 +2910,15 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
 	 * ipc_lock_object() when called from shmctl_do_lock(),
 	 * no serialization needed when called from shm_destroy().
 	 */
-	if (lock && !(info->flags & VM_LOCKED)) {
+	if (lock && !(info->flags & SHMEM_F_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, ucounts))
 			goto out_nomem;
-		info->flags |= VM_LOCKED;
+		info->flags |= SHMEM_F_LOCKED;
 		mapping_set_unevictable(file->f_mapping);
 	}
-	if (!lock && (info->flags & VM_LOCKED) && ucounts) {
+	if (!lock && (info->flags & SHMEM_F_LOCKED) && ucounts) {
 		user_shm_unlock(inode->i_size, ucounts);
-		info->flags &= ~VM_LOCKED;
+		info->flags &= ~SHMEM_F_LOCKED;
 		mapping_clear_unevictable(file->f_mapping);
 	}
 	retval = 0;
@@ -3062,7 +3062,9 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = flags & VM_NORESERVE;
+	info->flags = 0;
+	if (flags & VM_NORESERVE)
+		info->flags |= SHMEM_F_NORESERVE;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
 		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
@@ -5801,8 +5803,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 /* common code */
 
 static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
-			loff_t size, unsigned long flags, unsigned int i_flags)
+				       loff_t size, unsigned long vm_flags,
+				       unsigned int i_flags)
 {
+	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
@@ -5819,7 +5823,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 		return ERR_PTR(-ENOMEM);
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
-				S_IFREG | S_IRWXUGO, 0, flags);
+				S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
-- 
2.50.0.727.gbf7dc18ff4-goog


