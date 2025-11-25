Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD3FD0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB376B0030; Tue, 25 Nov 2025 11:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83D06B0031; Tue, 25 Nov 2025 11:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72346B0032; Tue, 25 Nov 2025 11:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C644D6B0030
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93273B8123
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:29 +0000 (UTC)
X-FDA: 84149740458.23.F87812B
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEB5C18000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jmbmP214;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089967; a=rsa-sha256;
	cv=none;
	b=55GWFCA29kcIXIYkse2p5F9kdfsRDkL2vNv9Xy7Az1BwFsfBxQ37MpLx/XcbDcH4IEJlLN
	T8FhFGD3E8dUVPrIH3L977+K4wB2SwJJTh72lX/1gPKEXK2TIIZzHeanp/u0TOkBGBbM9+
	jiIKxydxkJeXKqH9pVDaszDlJQYk/94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jmbmP214;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfc1qJ15XMNkzBnOIVsDqUunQIJaXY9mGIdNtvrgttY=;
	b=USLYr/HQ1NrXgeVFgLJAjREtKsmG6Lpg1AvziHZAb8zKujMRfHmyT3OKGe2kRS3At4bLKL
	7dmkVFomN1npwpoHf8WsaIyW3Oz1foVFjjgA3+Fl3TKMXgT6UhbrTBo1BgZRN6IVb4vj1N
	nAHHhuX7Kg+/suNkVonVUeGKMtgOSEY=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-787e84ceaf7so58960377b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089967; x=1764694767; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nfc1qJ15XMNkzBnOIVsDqUunQIJaXY9mGIdNtvrgttY=;
        b=jmbmP214nV7R/1sf1f3joJwfnJAcK6iBViu6uPKEByjeu2M0UEcf5ddleoPXsdqKoN
         cC/sPZ1jMNi78O+ZrRwWVN/+skdYfcHkGmKZpW8bAelqWu7M2dqVezxfNzMHtUJyuOFv
         YhsOLv1nT4cAZwnobbh3pRPrq4/Lsrgj2V8i5TEXAFEgn5iEg7pIS4N+pG2r8miMhgjM
         RBZ2YGEAPYaPzmv31MbYzIY4FRpUmjij3MwW2lAy10zMqBoBXBMmnG38i4zruv25zgM0
         ztqj+vPlSiRGRy2msfa/2wErs9SajY0uT0ZgFAug1DBhARLey3a1+o1/PSDuXNHyKNL3
         ZmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089967; x=1764694767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nfc1qJ15XMNkzBnOIVsDqUunQIJaXY9mGIdNtvrgttY=;
        b=kPsFUiwnqGHOrKfjScIQfBEezQ6Wo9h970uVw0U6droPbKOSZ/0W3tQTJN6B484gIV
         V+uvSkY1f0jKL9hG1eRxETPsjxIeOtG6jv1jCniW/JHf2IY8MINpnnf8Ss7YgqgjtANS
         uh7iw4dCb8JERDNzpKj/XBsUOKJwVMHTxdriwuAqC8M8re1x4vCyC5vOmBFY6UipfHZ1
         /tUbDo/rNsMFd8WJ5ocKDl2nMYub2Vl9vips3H/DzRcO8dlcX0t1Os9GmMpHZv8w2djK
         wQVa5YLnSrMasTVvqK4U1dzHR7sbE8nV90yU/jd9brSzBECA9+0zkaIvcCW3x4CY3bmU
         BxYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5VN5UcroEBy6LwS2uP6AFK5lXD6Hjv5P5IL6DYBBTcN4TEd5l1atF7NkCqBMcjYxgT4sj0TbsVA==@kvack.org
X-Gm-Message-State: AOJu0Yy9iFY0KWBQ8pLFuvldNDqT0uq3+EF9DbIRKY7FxLFN4jJEoWXf
	pTRiuyBGizeHfhLTo28uYXmA8GSdKRqqxEqoqBwpUWEJxfIseMqkDRJH/+N3NRxhLmg=
X-Gm-Gg: ASbGncsLIPD5xl5B9mHBSGyY1EY45kxkq558/69lmw5JGyPv6vzVJ3FV7zHVLo/nsF6
	JJK8sxcyFKuTs6FYsv5cmy3YhjzFrBXCbIe1IFYRKhk+c5kex258M9DpViEEzcQDqpprxLLSwWR
	EhV//F5EYhcWUP1THCFmTALFDP2OnKiYcYI05moI+d7YlMu+MZga6x6rRNfRuTQct+ykMBKN7X1
	AmH5qSTRunNeypBIsLvLhRtxf+Gv9Y1SFniWfnpJGpINja01Ir+Q8N/5KDzfKfzGoq23mu2o/9z
	1njkdNCaT6RdyE+VNmP11bH6veJeVG1nJR5FkrTnRVIgEHxiHPJBytF/6++ZywILK9zZsmFxuEY
	FKNg2AQlPLMCA4OR2RyDBx8wLe/SFn/FiNPkjWTSqmem8OJiL2qZ73SJh7XQYRjyI6NPLNOlrVI
	fVoX1BSczC7SqC6OUKn3YPDWGuvlawQsQaAcWtz5X+cuobiekffnf0qdFGtWokzZNR
X-Google-Smtp-Source: AGHT+IF5jBi+6cZ6abg5wWWkMVh+/fFfNNV00PFFZKtXm2L1YcP9KpDzV5NTX/aunBS8G3bL9Na65Q==
X-Received: by 2002:a05:690c:4807:b0:786:5f42:5ac8 with SMTP id 00721157ae682-78a8b4720d7mr142868507b3.15.1764089966707;
        Tue, 25 Nov 2025 08:59:26 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:16 -0800 (PST)
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
Subject: [PATCH v8 10/18] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Tue, 25 Nov 2025 11:58:40 -0500
Message-ID: <20251125165850.3389713-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEB5C18000C
X-Stat-Signature: 4xowj9rb4z37dwfxghxpjzbtsasqcu51
X-Rspam-User: 
X-HE-Tag: 1764089967-192891
X-HE-Meta: U2FsdGVkX1/NV92IhqAhBmlT3KkLx6ikRvtGKfvaXxHXy4mNg99j8zm5ZC3JQxFfX2yuHW7KcBL4IHTQV7/6dLO8IMzmkbb0DxujMYDjbmds/gHW8qwo5HtAeaaPAIxAYkixlNcNUTe99A6gId4ylvhmr9oQwmTGxCrYkbD4hmNRK6BwIUuK+AsfEttVNKN6iYBhPnCBkTZjgBb6xnQHra4bixJJxeNEOTw2JHyANKlnHSaVJb2wrUFTenrkPm0caOv2QXFTPMBXIkmsrGQGQEXScDL707vH6I/SZliGsex25IPWKsC3TZcZHVIzTD/rFGQF606pGUn5zDWQDo05zwyBkiVAFD34eGBZOZv03f913iPjub4jtB0TPDPfEGlK6ZyfUMhqGYVFIwzf80pXQ+lVdmsa8K+jvDa/3ox9UUrneT13N1jKyD1/cM67PQmAU2zroOz4HjoiK2+i5JZLzTIfveAieRLIF5nalPXtwd69LdLCqAkDRNsfnbAIB9kiB7tv4rv4NIXegKhtGgd+sARewupvw5cTxAh+BsqCCHEEIV2fsCMuoop+aQQBWLS3hz0jpns86kY2HRISAys3HIfCPUEbHgx03crO8DZsvS9VbLEa83Ovcivq79fsn8sbIABHx/96DperRuyGpPIszN469M4av7lf5fmyDqN2Q7ok1BT/wwgig3k1WZ4LTS+g1JN3eOxyjfEonPmQXe3w0rBlK0LTAedkUYOR+DlrMsn65NFDCtGkWeA16wCnf0VrCATzMLwejhKHjPBlTf8VsXO8/dr+oo4W28guRiC9YRX9IsJ2MO4UD8rctG4g2SZquVgNURT3Lt0oGoLu+fMBJK8eKxiLDqT29xW7eN7OHTu34qty3QhErkNdM+DY91crMZL/Nsd1enRUCQr0qZ/otrWKJIeduSwJWw0sAPbF2jZboAnOpMJimmTNJw6DKEXFif7+iCCxuQob9bwTYiW
 +tfoeR6B
 E4kycUC7xBWs+0wk+c0LrJ9bQVcHqbhSirzpMYJ+fkJ2Kr1CZoXBIoqxsqjK/MAMdf5IlZNinILbkbBFJhEv/wWHbyBqpkKVak7BP7cSCgTeN0aT4bUcJ7WWu121VheO3DNRh2bAQiKI7D4QTPtX5OkOugHSA4NcNTY9ewebBqTR5Z9AqpojxlhDpIFlqtKhaLNcqFDl1+WfpToLhkxTYdO3oKIr/INJWk65UlOF0Kq3a/4U9j/nm46JI9+bKEXnwwtWMS8h42V5mkpX8qozn5+oEi/mtViKVPCTyU7V2jrWVvL5hinlqVqrlm0qeec0ZpbhJ5IvMcPrw257w1K3Baryao+FDo7kmfZWYZjxxQtsN0CNx3nprmf/g5cwCoXzsPJX3lvBaqxvPNjOMhTXHD4HFPbW1zAO+TGb6ndrmh0lZvzC7XYkU3fgSSU8+GWMXgfRc4Fpxr7yLnGEiDkUmJ3TvWQpxE6iwDuofhavkAX0qa4US1nZlM5FLd4TGL+YdajdA
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
2.52.0.460.gd25c4c69ec-goog


