Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD55CC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67AD6B00B6; Wed,  6 Aug 2025 21:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17E96B00B7; Wed,  6 Aug 2025 21:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFA66B00B8; Wed,  6 Aug 2025 21:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B10F6B00B6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 560311DD5AC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:28 +0000 (UTC)
X-FDA: 83748269136.10.5DF3CCA
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCDBC40006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Tw/3QH0q";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeT2iJHyifY4gFOC9716oziuoen1egRU2pBc2ZJ5N/k=;
	b=UlHsW4Nx4c34urBXn/o8GxU3/IekNsJzUv8TFEBRziN8Zsp1sJw1clRjQXJl540PHV5gyw
	WznoU8AK1eRMXOvdNCh3j3pkEp8IRgLFCxvvjomYf3JEkhx/yw7LbKwix0D699S28LsiEZ
	S8l9oh04Ev8J8G4vw7vxFFEf/k62g6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531126; a=rsa-sha256;
	cv=none;
	b=Qmusc8PZYT+gepmzzVw8E8rr0f/CGsXj7le4XRpVa9AQ43YAjM9c7jp4k3Hb7kWwIR4u/N
	6xiy17U2JKhNtu2mm3iQzR3ML9sIuzZ8ztINm9A/DTbTdyhi4KC8PSlcQQGdPdRaewSkjl
	Jb9ga3InEtmUkIpUkHCf5mnxXEwsVMo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Tw/3QH0q";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-70749d4c598so5104976d6.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531126; x=1755135926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XeT2iJHyifY4gFOC9716oziuoen1egRU2pBc2ZJ5N/k=;
        b=Tw/3QH0qOwr4x27wEQmTJYK8e514e+3Ymb6XnWk5PFdtoWPAEUFXB7haJMAMeW0Hxk
         17MOjN/lwFbee8UpuB7mpYCQEjnpYoSWyi2LcUGyQNVhpQ4NMn+pAUQc9MZ6YHrWd078
         O02vh8NPJfQ/dS/dqga1aXQy227vefNzr9Jcp2Din4inlI6/8WXz/B7CTd4wXZ+pBAd/
         6Re3/hThsT6ikC0GoHQLYRPoXbqWVMLhiuL9KVUkWe+wquX6iukVTF06FxN6dZ5qEQFj
         TdImx4uKqtDMe+VXDDoOITYvRBgUSXFpTVAOwi1dGONt6xP22rRp/zZwRKY16Fk6pU9z
         9pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531126; x=1755135926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeT2iJHyifY4gFOC9716oziuoen1egRU2pBc2ZJ5N/k=;
        b=n16gKsdiXpxSJM+jAsTSyHjtrdwW/xZVs696RlHsU/S/RKCkatR7Euae0t2f46hLaj
         Yj+abybcnXVGD37OUUt2+wZqhLb9KT4QoFRSCHAMjQFYA0gpQhtXLFXuHFucHfObOEJ2
         vq8Le7cZ34OoN9uZb3DO+uzUXcJmpN0W+NFvNpNsbgna+fqM0+Pq957OAUJI3yAYAEQ2
         D9MYi3acZ9cj/r6rkV1CsKefl8tWdaHt81PIhL3c7xkD/XEvUYXI04+H/R87fN4KM4Q7
         KSYg/o6+ni09R7A8I7OueymgIqmNp0rkZVVhHFyrdM/66QHjuOGAZjgBDFJxSbPPVTRK
         R19A==
X-Forwarded-Encrypted: i=1; AJvYcCXiQmAn9C/QJ3tm7XbVHSgzEsUL0Q9ezWMg9shFj61CQJ8TdOIlbW7haaTVSgl1dzsZnC5nLH8YKg==@kvack.org
X-Gm-Message-State: AOJu0Ywlkf2sjgo0OOJnUQgzJ3YtNInNUkxmbMOzfP+NqJa015/GuaG8
	uWjy9RhSkyxvYClQg1JvtIbCFVaH0/0Qvlq4v28D6q49nife9ZqvnsN/56Phe9H+V0Y=
X-Gm-Gg: ASbGnctHuvLSaJV3o6IdERuunnNJJdSxbj9pw5biRhAcfPaIYsrmyCXjZhvn+cYOqjm
	70v1W2As+NWOPUqH7vu5nXS5b49ZV/Q0w8pdyn9FC6yFDYG4luSnQBZpss7XQfo/qYGK99X7tFH
	OYPG3BCaFhIECtEYpL5C5oirTVwGTxqwI8cON25PvTmKbECf0YxeFjp1URer0Jw/Blu6YezqwQH
	VJGas0Mo+CDrewGjPOyiKxyWJtzH9urQ0UkKsS0KY7Pqa7srX4kgXBlUD85f4G+7ZK/F84pbXjo
	kohZTmTpF01xef3zS1IJJYRVDwckqYtVCq21GSWuIJPxch5uCDNlIpDcSuBZp5oe8fPhdW+pC3Z
	SrjDVGgq1S0ZvJ8fl+Phk9IUfCDYPFTIUT2bwE1qv94m2nTHihQnUvIYKMRH5poXOBROOQqM9n7
	uDgjNRMw1uUlYY
X-Google-Smtp-Source: AGHT+IHk0tb1uB19BidWcJjqq6Q8qaHf0qnKstZyA8KJ/vdb4dYPPaNrNMTJmHZnrPtb3+FE1z9qUg==
X-Received: by 2002:a05:6214:5099:b0:707:61a9:8bdf with SMTP id 6a1803df08f44-709795809c9mr79245396d6.22.1754531125709;
        Wed, 06 Aug 2025 18:45:25 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:25 -0700 (PDT)
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
Subject: [PATCH v3 26/30] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Thu,  7 Aug 2025 01:44:32 +0000
Message-ID: <20250807014442.3829950-27-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCDBC40006
X-Stat-Signature: io45k5itre4jg8qu8qmty8t7s4mpi74s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531126-668373
X-HE-Meta: U2FsdGVkX19f33noyTCe2Cql8FIE4WXBUOmJ2Fx4CYeLXR2XeFXA0/1jKI26Nvhh9ZDB8dOJiAzN2JJtoEE/cBT8Dk2Vx+qtDQ7orBbKusJ8ShpJSX/kR1XsV96fxDkB84/LevVXyZUsK8hlwtMzhASekBewwr4hNMoBTEouDYidv8Ts/DRMH5KFnP70xMTHRBLIWQ6mFpSLoyXWTyBZzILw3dMBaLvZJJAmzwOaRMmggQqCk96pPp5vtvopWTCAeBVk1C2Qd4ngsIWX31CKsGIZ0TNlgy0PUCjVjdvHUKr4+ye5mmi5XdmAStQkc8dAtR81+2kxFuzinSAgDYOKg23a0Ndv3BRQ8wO652jIyw6G1iD2VdXXsYOfCljEp7T5EeJbHmdjUxetww15eHj6s2riYhq8TdFKtyOvdoF1zNMmbZFI2u5Ux1xtmmpQs4ElcB9K1nrmZdBzeIfA3kQ/6Gdn00/e3dq6FV22z5XdFnuEbGa9LvlRpO0z4tM8+YrHFErjW4HDXOtJhFOu11kw32VENE1ew259r2Kg9KEAeP53VqDlNJ4ryxC4Sg4xaZR3pY6Tn6NW8c2eDa/4TrshcWCvKXpRFnD02HcTm+B5fI5NERiPss/WbGuRlLgjAQ3Vt85tC0SK/+15z6lrGKTUK9NFdNFOF2eaxDdfgajbXvuQnnrzApYfQnKdGwR3yN2HJpfccd7k11rfpgQf0TJQK06HA+WYY4htFm6sl6w5/nLam3XpkRVLuN1/SiM8TO0rpiprHsjo6CklZP3PRoKXrJtlFfuVeh39JmmfAxr5r7rHmCgZTbDJre4l2IatDXAx2eeSA1SQeHrmUe8DHXcbC0J2IkjD61dOM86fNyFFLuGv0oVGfeJfzuH9CSXbtcO/VlmbjEhzLiAReamYaW5boJ35wQBsr2R27/EWFQr1gcDv57JLMmBKLIYD/Rj6v4NW9uGHWNqjHwO5nvdYa2Z
 2erqDL8/
 qtOgQ5zo3cTBtSuNHSseX/mZ4ZuwB92BFaj2nr8vygTkVodg6f5jxdao+WambdlR4c4o1MX821aTplGnAltlnxvc4ktXZEcWXSTT7ruEHvuvJuXdi6TEh5ArGsPDTf6eEMnwV5K9Iepj3A9I=
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
index 6d0f9c599ff7..923f0da5f6c4 100644
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
index e2c76a30802b..8e6b3f003da5 100644
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
 
@@ -1588,7 +1588,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	int nr_pages;
 	bool split = false;
 
-	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
+	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
 	if (!total_swap_pages)
@@ -2971,15 +2971,15 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
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
@@ -3123,7 +3123,9 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
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
@@ -5862,8 +5864,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 /* common code */
 
 static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
-			loff_t size, unsigned long flags, unsigned int i_flags)
+				       loff_t size, unsigned long vm_flags,
+				       unsigned int i_flags)
 {
+	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
@@ -5880,7 +5884,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 		return ERR_PTR(-ENOMEM);
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
-				S_IFREG | S_IRWXUGO, 0, flags);
+				S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
-- 
2.50.1.565.gc32cd1483b-goog


