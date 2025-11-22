Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59107CFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870CA6B0088; Sat, 22 Nov 2025 17:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9646B0089; Sat, 22 Nov 2025 17:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D086B008A; Sat, 22 Nov 2025 17:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50E246B0088
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD27E140A4E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:19 +0000 (UTC)
X-FDA: 84139672638.08.36D4A79
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1ABF6180007
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FiesWuys;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850258; a=rsa-sha256;
	cv=none;
	b=Hhz8VLqE1ve+1yBDT7SnZOO0X5cvM2akSbvGEQJ23Y9pZeSOqjWCJvlxoUumIkOlMzpl6S
	cYHjOnPZsAV6OOjQoxFZo7Lxn+pzLoEEELvX0/QaVFxdmLY4WRfMEJ8XlAS9v299rpWpbS
	bATTbpj6n0jCKL0d6R12dEViR3me91Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FiesWuys;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3SsEWcfoC9wTWzpyUGqKCgnql8plxpKqJFH67bD/ic=;
	b=fT5iiY4KueRQgVrgVXk7X4vBz99ITpnh3ZfDlRA61ml8gTZOdxDapZjCcv/8DkyUWc5yiR
	myW5Auq4Fk9LRtx1j2HBdSh86AVN6iHjeUAGOm+W4LpEzl4sbM2xIM5hm1iJC3wXhpUIdV
	niUx4IFmzpatgC6TI82JTgfQvS6VA70=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6420dc2e5feso2469977d50.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850257; x=1764455057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3SsEWcfoC9wTWzpyUGqKCgnql8plxpKqJFH67bD/ic=;
        b=FiesWuysFZZI7GE726FPEzOmFretIBLmdw1PCgM7Iejj3i5Zk28lufuHoQI2ub24gB
         wTCe5ZJ5UOh47w/O4en88IQKhOZxeucbmtfWHIQeEC+JmI4KdcSM6Gh87GcIoyJK9OmB
         P9nRM7vQ7Y8Q+9eofc4YIiZFRGBWuKVtYQvkvKp9Vxev3lyK1TnGSFqBo61oeGjW/tHv
         rTZFEMbN8yt4ce03HbI3jUerDoegEl/89N0oKN6mCCML8Y3jAVoetdaw0qa3EpeG9CFg
         nknARTfQjcKWPpVGUvD1ohXN4UhN7dLsQ8vyKvmJZ11+ARsH4JHKzCiORSTwzR5/iruK
         TjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850257; x=1764455057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U3SsEWcfoC9wTWzpyUGqKCgnql8plxpKqJFH67bD/ic=;
        b=sJOvfUI1TsvbAhgFd461rF37Xy+Q5Gho8KCpB3KalV4m/2ig0lMcvAe6bqOTv+zq6X
         tZXsF567KtAsKzYRhQ9bEp0SOKHkiKAlyL6RihVBxdsqIvxtIvY/4YF/Cnufsn4tNR7S
         9rhUmoZXpPh1n68IJJJvLCPP9/p+KipHR3f8Hu+aabUh6pduLtr4DiK5NhcCUnnDCyTH
         gnsmE03vVrwIHrS5SIpX+eB21E8RpFS08qb8c5JiJFAo6+gQ3ksEG/LyVr+SX4WBYpA6
         vnAD9EV/bMozWd2eBS9K1UuOuP+Q4y0tCx/k7MvRUSPpjelN++W1ISQjKHMV5lxzEORd
         H77g==
X-Forwarded-Encrypted: i=1; AJvYcCVHw/K65KjuGzYCKip6l2eAx3CecOIblbqFoPxgPW+Te9fli+uIB6fQxSaMre3UbsasmMZjLlzFFw==@kvack.org
X-Gm-Message-State: AOJu0YxuOqCc3kAMDowicqngrAtCZZC7nneP7hH+ByXGVI+3PrrkeQ2Y
	9HyJ2eavMjpEZnTqFg0m5HKN7ZPeye/Pg35DN7a5neM5GcA0hWJWbPsI9cBMsToHkWo=
X-Gm-Gg: ASbGncuTyX3YCKI4beBsFDPNOrVvW6s8BzuOoTa3aeIgEZGsT7f4Ln0sEqii0rb4S5X
	uy/emNbsVB4fNWtCdklDUT/e+HTYkpYp5QPRqs1HT73dQWGPzUaVMx/gpRTg2a1FOrPixrIcmzY
	CIIGKw5lAr78QeUE3zGaG/yWxw/4LaiZRluseegZ3kLsswSFSLSFBsRyQo+pGt3EEt46oYSpfZN
	Ri1lTLomBart9ayfr8+hft092/hKSqZwXYRxSpR8BgNK11rjhBvtnOVaK91GQBY4MubLf1AmA9g
	5mLUndS9WRQ1QBcdPzrzUBVUZDejizqzksIV0RzOkz+t44rue23KfSwV6CKNLZbC3x9BJ5/zWOu
	s4a9/UfE+gkWTlBk1S6/v/krjJ5DWhRWIME4QK2oSQzpLd65VGuT2W3jKpFdvaLdilgJvHFV5Eh
	Dm8FsN8c8CYO1ecvkgcbAH0OwFBiwJ1/XSwr6UbHfFTWPPhrdjaIihpYVb98N2Rw6C/ZDbWlKRP
	+QjUwU=
X-Google-Smtp-Source: AGHT+IGN8V9s1y7QiOXXSQkfpg2Me3ul34/5J4KwUo57XUBRpeUqmFQ1wvJ0i+/kbCzYrwZ02S+fug==
X-Received: by 2002:a05:690e:148f:b0:63f:b8d0:7e2c with SMTP id 956f58d0204a3-64302a2fe8dmr5068390d50.2.1763850257000;
        Sat, 22 Nov 2025 14:24:17 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:16 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v7 10/22] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Sat, 22 Nov 2025 17:23:37 -0500
Message-ID: <20251122222351.1059049-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1ABF6180007
X-Stat-Signature: ckwccbxqfjydznouubp75zwcrq4ubm9n
X-HE-Tag: 1763850257-122125
X-HE-Meta: U2FsdGVkX1+ZTAmIqfA4dJ+zaLYcK7baqGwDAW1VA8QsaiL2tYFtVFMl7wSeKNltL7rBDxFMQ2RcqgrpHSQIwu+8uPF0rocvay8cAflAymoC4FtT8Oo+FEiBlsTDwTCYOP80jT7p2aMdAAupFAimzlitaRIkw+zJXCpDGdAIHfFrnyv58K8LPPM9/52Rw5C5MZc7DJmSjwRxZGGWL3G/5bnYhyGM4O8LT4JpywCRoWwBumR+w0tF5ic/+d9YAZ9RX46So+mmgmGWfBdjJ77c3S2Rt8AcfCZh10KgqrOV40S6bZPLQf1s+uOIfNvE5CQ2mLYdjoEscrxo06Vi3rLqHGP9zUJNwOP6U3/zcO88XHYlP2YWCbeyxezsOYeCZtAALvfDD3/aS5tGkcBwa8s/7ZafRENZVJD+pvu9i5XmITw5HcHcx37Q26rZ/pTbi7BL5xaThujem6GHjoXK+KHslABzDuFQWCe9y4a3FKBt6XigDsgh1kYzjgBrIvNNT+AvhaNj+RgMk1DvOWtYEUBBonrR6Fl4sCqQAl0rojD+Oc/t0uIcWxobHo/WvIcv6tG/EKtiSss/w7wh5MKkMauATc2QFM1OUB/JR1QAZ6Ri71nAgFFoDXK1WYvVA9VH4xnKSo0SFWFldWKU251lFhzuFUHjK31ihO3ewP2vRACbH1xH4T4xcttdZNMk8tCyEv95lTposwx8qtViu8lW1NUqhyDfclQ2SSItfDP/cFEJNKnKyTjk6tEGbvAaSt0BcgxSKTjCzeelnctTvs0jqSMDGI2wiyVAa2QrQ83w34BZBZ0BCibM5iaJgEk19PIYhjoFu3T4rjweI+5zXNGBKNYeojVz+W9QqECv0N5e6DB4y3H0eAul871/y8TFyYIImywa8jEXEeKWswCJJE9kRSqHrXJQoNyxNWE4zvzoCY8mPApY5sPJ7HwFqmkePTHz5gwGgafA9xw25f/QSFbwOHX
 ZrSAaqSz
 PtgOU3rpUwWtgwNb5tFUDxOtz2NOMMkh3EWwQepVhEoVwqNuxHogwXrK20kE6QCJvdOd8yC/PMBvbTnguOSsakTZhs8vsw9bj9s9seGBltiPugiPw6+P6n1dOjr/sLTe776I0FduTS9iLgrDucs+R5x9nfMg0EOH3WjTw+BV8FUvAx1fOqfndFaK4R5MX/mr+a3qmolXAcuUZmUYkRe2tmGFYnGdsoLMTvu7MV6I+NAgjhwMXRPkyD49bvLa+XvSeX+up6HH7zb1q5P/MvYNnMHry4MoHxNa5V+mnp/PvRnero9FeLoIOL8cZhfC02axYrI9tBZM7y321PoZ0K4t+Cx589CFMcnGJCd4LaelSMjmY8N2m6JKmrMDYVKQzlaMDUNPeMgeQM3rrdwmtUEE+5zP2WB7z8ds7zT+DDAs4M3WZPwz2i3W+NfTV6djbS18pXRL7XGL+sTJcYfu6IKzjwaIjvhljiv/ej3nFMLy+n9q/02kQmbWIZ0NlJw==
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/shmem_fs.h |  6 ++++++
 mm/shmem.c               | 28 +++++++++++++++-------------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 0e47465ef0fd..650874b400b5 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -10,6 +10,7 @@
 #include <linux/xattr.h>
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/bits.h>
 
 struct swap_iocb;
 
@@ -19,6 +20,11 @@ struct swap_iocb;
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
index 58701d14dd96..1d5036dec08a 100644
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
 
@@ -1551,7 +1551,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	int nr_pages;
 	bool split = false;
 
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
@@ -3062,7 +3062,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = flags & VM_NORESERVE;
+	info->flags = (flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
 		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
@@ -5804,8 +5804,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 /* common code */
 
 static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
-			loff_t size, unsigned long flags, unsigned int i_flags)
+				       loff_t size, unsigned long vm_flags,
+				       unsigned int i_flags)
 {
+	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
@@ -5822,7 +5824,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 		return ERR_PTR(-ENOMEM);
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
-				S_IFREG | S_IRWXUGO, 0, flags);
+				S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
-- 
2.52.0.rc2.455.g230fcf2819-goog


