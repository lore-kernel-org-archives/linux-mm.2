Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6A7CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BE68E001D; Sun, 28 Sep 2025 21:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5C48E0006; Sun, 28 Sep 2025 21:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735248E001D; Sun, 28 Sep 2025 21:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55D3E8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B3BAB7460
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:46 +0000 (UTC)
X-FDA: 83940492972.27.8B5AC74
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5311180006
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ESXbm+2X;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3orCdZcM4OnRmQqZSjpp/rFEAME7J/Ll0MOwDMAGFw=;
	b=W/gJGcXKE5eO0tczWLb+vMvu8fuTxoNP0PFzuki3+ShFl8YEDbJ4qd4FWPX2407FZHQS2X
	KYyBm957uuLtBXhZpD2TuTNt1/hnghiIt5uDNvZ3RNT3VfTln9f3uumbKha3fcevLmGrQG
	SFbNelG6Jz13ytk+CBO04anBdwlHtzI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107884; a=rsa-sha256;
	cv=none;
	b=vCuPAc+d+bYGfPUNOfFVPxjrJgGV/8B8hl4rRLDlONZunHVIBvncDeywCey2HYW5gsbN9P
	Z+osHLVzhglCB273gXSEgGA3iB7amfH0EMevixnj0/Wnx1n5qpT1Q45VsvcEBOdVfixRjO
	EXfvZKcup2kTiIXzzPwO3e7QJXuWqvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ESXbm+2X;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-816ac9f9507so524295285a.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107883; x=1759712683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3orCdZcM4OnRmQqZSjpp/rFEAME7J/Ll0MOwDMAGFw=;
        b=ESXbm+2XaRGhTpvsvOyqI4qHIqf0vqxz0mklSSnImS8Yb2tOnEnZc+OkSJeqJj93fm
         qpwt//S3cvOnVe+FAf280NMhi1KbNrj48kVnoitiYgWvWoopJvzgvsHWhP8q9l2aj59O
         ih+InRZAGwFvbOzltj8bARNNQ2wepizMFa3vZmV8GvJbmHMdq5LfwD0F4zVtnqClvIek
         4pSom6sOhpHCs4K1jZpKO1h0X8A+/wMN+EuDOk3xgWiDTGZHGbA1hAZhsndzuNuuHQvk
         BmrhcnGeG6Zj1Xyk5o7RdruZ5mZGhSRyaxeptOkY31GE+ue9YiZulknHpqOyPRHF6Kw7
         dFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107883; x=1759712683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H3orCdZcM4OnRmQqZSjpp/rFEAME7J/Ll0MOwDMAGFw=;
        b=e2XJOlt+hh3yMxjYFWPoT5p0CkVJvGfip/fnjfRRec0C2aG93C0bC3nNyxbuhwsYGK
         WBMAS2zUIQZlblSJv0zMX/cS1/y6TYT554CxbTJkiwTKgW0JbLYbbpebsbOxm5p8hA5F
         SfjpIo2kNCnpGHQH3lwNpoL1+6KDDenRtwEIb8I92eZe3g9515AAm8oBNbJDCfSFGJeY
         3Hxa0h/2VsAPfyJS4QDlS8nlQja73OR1irbNigO/Cuz9Of14WQHj8OVWkmz5Qy9Sq7Fn
         Pe537dzcVDxm1vp3u1+p5o5WOoJIu0oJ9yDqGabO5xD2qORWxoTkUmm7s6Wac3MA0orW
         IAdw==
X-Forwarded-Encrypted: i=1; AJvYcCX3pbRH450TJy+whBmuyRDLJdNdd0wiYFgOqvOBmB104assXiXg9YMDfj9cyoMGkJR5ciucNzxUvw==@kvack.org
X-Gm-Message-State: AOJu0YwQCYfyH5V9YnDVVMVjK4UIqCwss8jy9J4BD+x+SaG58mZb5bJ/
	IdbmoS8Z1MAapa30atpRoQpx9z4H1sTHToB86POZiEwnISuAHxrOvoAXw84f3RYLV/k=
X-Gm-Gg: ASbGnctxLH6FkIS72ODudJJfCl8DbvteHk97pguc9SYxLRkRnMxQMJiDKs+MuHP24Pj
	ywAjtRVlCXdV6P3lvO81ekfkZKioqNyDqix8BFhvrXNIb+iGkmOQxWm1/LBOBWJQIQUGUGOn/HG
	y5Z2n8jl/CKeaDiczMSwCQzwoyT1C4pXtq/tCUMb84zg5epPoMtgmD+wiwGnT1RKW/wkOeASWlH
	v473cjgsmYwIx17XM6MVjCnuBFYlUkQTj8WmrgxZazXwO+2zd2B4atoBMw/zFChXGwDuiUiEIJ7
	T/K16cffcSCSj2DxM7IY9lJpBJJHBBFW7y6NA+vjr6mPKBrQfhzR+HjXd5Cz7ghkXB/39AWCphL
	4N5Q/zs6chzjx3XLeUEsslNWk+EEVUosr5Oq5pDMCjby7HXtNGtyGJuFQ3ENgLAGmPN/PjaHv3C
	ckNnDXXJ0/pF72n6VFKg==
X-Google-Smtp-Source: AGHT+IGJx0yEjs9NdTtup483rQFUUHbu23+HQshPBoJHcCouKPKah+/aB6Qgtrmj1NCU6W09m2WUMQ==
X-Received: by 2002:a05:620a:172a:b0:7e7:fd49:b0c7 with SMTP id af79cd13be357-8645c15e564mr910943285a.7.1759107883275;
        Sun, 28 Sep 2025 18:04:43 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:42 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 21/30] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Mon, 29 Sep 2025 01:03:12 +0000
Message-ID: <20250929010321.3462457-22-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5311180006
X-Stat-Signature: 5fit95pep6hcuinype57erfmb3zdpetb
X-Rspam-User: 
X-HE-Tag: 1759107884-491375
X-HE-Meta: U2FsdGVkX1/7BiKjHE4clq1sUFv5ESJfLjvr/9r8/w5uxByHTTd/l0w9oz+YVtlKCvUulU7pRyUk5W4NQ07LPgGRiET1Z75zdU80kUXJ6bPx5oBLAcYkQIc3hkSyfKfc9ThjU+6pwfgvBHLZohkxm30WjDOWC6GmFQ9iV4Se7xXjo2SWM7i40hYERppBXeurl1xKktH8XIKXstV+3zy/CFoQ1xXBZfyNm08bMyECLeolz0yWxeUBomxgxCx0fcvw9AwMSqPLsEhA9sE+m6qJaAWOVbAPcEW35Sb8o7eVzpdG7Wn8wL9zFH7KWAXnWo5d4flT3wjnQK3+tIw1nX75dTMouIF6P1q4djSLbnilx/Ze7yyq4KyNOwhufPJWbHxkm9pmXKJIi2vslY2uFB/38+r8uRBvgGoMQF6Wzu4cvIclbq5ARzTYyprBCAGhQ33WM8olF8UHTXObM/WrQFsZzbnf7Rj2JIeZtVexKqXShGLPaEdihKjj27RHbmY1bWa4OythN60EXYKZYgEJxbaTn2x/ySnznueEcXRVppyRYaCZEg88RZuio61d06kGu4+2U9QOvWGvq5y1VGiSudFWaklI/Ctwa22uAeSpfJKYGs0xQjWXuqE8cEFCEuBl1ye664SER3JvwBQxxAqFqc9DbHEtaEJdnYSPRrjp6EJAYY+Vks6zdkR6kwyTfLKpp1wIDr6J2cteFbkT5npy8Io/JCc9Do0LJ7NhmEU8OvbyJVKwZiy/6sCV34bsBkzaBsx1Ak4yOop+1em4m+k9s9demQByQc8qYRScvE0phNbj1/KiuaBu6G8pZAxuS9GYb/1CINcf1Ut3uuvuNlu6Olr9sE8RtBDSqX3s269hxg4q/HiZaf43M5YLgqANlJoknVjYaorpcA7i/g86XZWwOW9yZfc5+7jQ5/fA/AzCrCWlYTRibbTogBrJeL0rvuz2AEkeEWH8ZHsKLF3BgHscJK3
 5bOtIxpS
 ISlQh/xOgmbXzb1Uwlq7l5ZncHkbWqJa5IxIuQj4gZjKjZU0Ppht26ITpihI42Rh9OPW49foKPwGr0XuVyQ77DYDyRbV6SbO8bDRT15CnjBDXDJpBHXVwbozp+kXPUIavSqXzDRvyZnOemBYeP5xzrlvfL71ClrDwPhMPgT4LT2NjXj832XZSph5q+nVayCFaG8jBPbMX6AUOah/7TO+5ugV/K4dvqcOVpUKbyGarj4l288ddKkM2eBT70E9bAFM8rnB8QX3g5FE/aCgQh+H2MEBDrk5SxgKnu+QQb1jkUIPTcDcP13rpLuidb/XK28X1QIe61Z0KIoKGbmEqDoNybYQT9VUjlxKLdiq0SS9jh2UqkZI5k9bJrAIsl3ypYTUZEjovNn4w+M3x3imm4bgissnIA8VgZyeJgrPvEvjN0GrvAcGWXhX/T69nwVZ7CFjYtQCz
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
 mm/shmem.c               | 29 ++++++++++++++++-------------
 2 files changed, 22 insertions(+), 13 deletions(-)

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
index b9081b817d28..ce3b912f62da 100644
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
@@ -2907,15 +2907,15 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
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
@@ -3059,7 +3059,8 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = flags & VM_NORESERVE;
+	if (flags & VM_NORESERVE)
+		info->flags = SHMEM_F_NORESERVE;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
 		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
@@ -5801,8 +5802,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 /* common code */
 
 static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
-			loff_t size, unsigned long flags, unsigned int i_flags)
+				       loff_t size, unsigned long vm_flags,
+				       unsigned int i_flags)
 {
+	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
@@ -5819,7 +5822,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 		return ERR_PTR(-ENOMEM);
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
-				S_IFREG | S_IRWXUGO, 0, flags);
+				S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
-- 
2.51.0.536.g15c5d4f767-goog


