Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDC0CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3F58E0019; Fri,  7 Nov 2025 16:06:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938A18E000D; Fri,  7 Nov 2025 16:06:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801F68E0019; Fri,  7 Nov 2025 16:06:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64FAE8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37E7D1A05F3
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:00 +0000 (UTC)
X-FDA: 84085043280.23.F32227E
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C4F31C000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LnIEN0YO;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hhpreoxnn+nlJNzkmlMtkdI0F+At6xhejoNztjrsnbs=;
	b=5Nz271AWFg8MsWqF5AJPy67+sO970oHoz7lP/LThrYQYTUODnbe1WzKtU85JeakEylTG4Q
	IDXB6kj5UIThTiW1NPvAz+jki6PL9SypEHgoZMOHkIKJfXv3xHQAqOSCd5OWaqg9ZLeF2g
	B1CQGtzZWYFIgZnjbiOsQ5doE1nYhaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549558; a=rsa-sha256;
	cv=none;
	b=BQNfl+15SYN6LQ60xcWsXa7E7A5BXfNuWccvUCv6hq2LQP3DGnhBbzUvTeeacfG/EEfnzC
	0InF95+GIkNkqpKfvGQchzdA1/bDVAn0Mhzk14nbKrs6TsnRkrFrdGgGeuHxFa9v8Pc/JO
	2NBYZrf4JH8Y0CkCkEX+hYnSn8v0tZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LnIEN0YO;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-640b4a05c1cso1164812d50.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549557; x=1763154357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hhpreoxnn+nlJNzkmlMtkdI0F+At6xhejoNztjrsnbs=;
        b=LnIEN0YOHu71Wamgso4OCwFn/yi21el8THbrfpvkNTjUb4bMtwuxDdBLgnnPCN7B2N
         lZV0SkrBIU5EmUDcvNIopv/n8i6Ch7rFkAW/tU5zXE2o+YwGIY7MCiwTPxhrrkXSGrpJ
         35ow1VosDDKDuc+y6Vcgmfl/zTuYZ/HcX5/4jJnJd+TdDN1A9rEeAtzsdnIP9mLwPb8z
         MF4QszVSYMKfG/TEv9fe5jzv1DRHGqwYNqJPqi/tsUzIs0NQKcDQmD0piRsTLfPmeGJt
         uTcTXvKZcXZN7ZhOsm0XS/46VRJgapYfDjHc2bXdnzjEQW5DQsmCfypTaU4Ku/ChgzKI
         Wx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549557; x=1763154357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hhpreoxnn+nlJNzkmlMtkdI0F+At6xhejoNztjrsnbs=;
        b=RCvXie5Iw/DF7c8qkRpGQ+t2bLgEYUXnxt8kK9Emp2OzEoArS9+Iqxv3qUBSLQRKTm
         wOvvw4EU8z8Vi00TDFTevEHuDiriqH8JPUT+3smTBQSVpFTYeexfQqJdKWFVjJkAsRTj
         qLLTURzIvis1XaorTJshHwv8FFPGaDK/gCbnQmKDvU5+ak69+2A3Ii3KoXOqFYq9Jh8y
         d25xy5+WCMKsXvS4KlwQq4nBOZCyMhQJzPCPd+PCy2fmtxkuJMuiJBmOa/XCDCe8YY9T
         o12ASjwo0HpbNgOfTBfCT0a5RGaFSmZpFKwujkNDd1tj7agY9Eakt6q3uvW7q8/ZjCh1
         im5A==
X-Forwarded-Encrypted: i=1; AJvYcCU98zRaWtVXsDk4zh9SWihXkaDTT2gThYuNE4eV7Htc7uLUszANGH7qMcBNClVglbcAaglAi8OdHA==@kvack.org
X-Gm-Message-State: AOJu0Yw33m9Fisn9SRavmCPwIE2jBH1/K/A+2Sy7ouJs5OWTvowMuNfC
	1m0+0KmLGNKot4JrkIuBqJ2dBk8TQ3gxeabdjyfH2gjKugnNE6TZIMa4sJHNoZ0+puw=
X-Gm-Gg: ASbGncuse54zIczppm+M9TLGMYZpPjWfGtXd7Izjp67Lqh3azNJBE1RARRUnjBCswk5
	SayK8m1s7A9J9B3hw5BRKBg1R+cwMkbvP5Rs7IdFW9z14ygcxSyIgXEr4yeNWv4E2bWuIY/lwex
	jnrfHfNzA+2EOjn/7dhgeLTtmXPagI0DaX+5HyxzJuz+C9O2Ml4zhOhZ0B4CkvsIwts/sP+Q7CN
	ag7mjakti1ESh9vd4yqrPwYROobo2TuZlt7axwFU2HDpNhzzR4W7tVEAqH2aVjY1Jdm5tqHd9en
	J3OpPnz/m8c5d8RNZ483yAvuUW+9VkMI4BkIRACJe91G4lCrsumPS+6+HU9FIkEhLHBH17kA5PI
	8SSf2w+AsqmJ8LGKGCkC2/utxsRTmMWuXHwgq4ceW9JhLInEOm65ElXIEpXOUWkXWQACdGlYjYk
	+lz8KP21a+hGx3RC+wd1XwvxwiE56QjsNoltNHIu6ltyMx6n1kaKe3J0AM2LxRtS0=
X-Google-Smtp-Source: AGHT+IHM85YUuXPyVoM2odrjHYP+mwyWLe1kB8N8z+ntfjkrejgyHe3L+oNXvJsvcedHEWGfvX9bBw==
X-Received: by 2002:a53:b113:0:b0:63f:31f7:b956 with SMTP id 956f58d0204a3-640d455a4b6mr353591d50.27.1762549557262;
        Fri, 07 Nov 2025 13:05:57 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:56 -0800 (PST)
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
	chrisl@kernel.org
Subject: [PATCH v5 13/22] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Fri,  7 Nov 2025 16:03:11 -0500
Message-ID: <20251107210526.257742-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C4F31C000E
X-Stat-Signature: 3os4fjt8746gdn94bh4z8ziw4npaz9x6
X-HE-Tag: 1762549558-227709
X-HE-Meta: U2FsdGVkX18P/Vx/WsY0DY5mHhvPGQVqBqJEHfBCtq3e0muBRcPDO1nc1YgBE4B18ZUZ6DFPy90mBNm/DSZfBoZzwUXHz9HBDPWRFKGMS4+P6B+a8lDvLc2sOz+jToamrsl2JaprKVJ4f83vk2H0aoIH87G63w9ksRz1twhjMoTGQE5phv97TEfhpuWeaKavAYEHeYcIIXrMvXdKh09DFayt7F1bWgl6Yhk6PVLsWdwC+iXtrLK3YLsfnVH0bogtu9cQzgutm9QERYs1xrjRuc6j7zoDiQViInNNVrcsVNTUKHUM4rqWSLxyzYfkJT8YLhYuhK5NmvvOY+2m2js+edz8hHWGSVwUab1BmQkYtHHtcDSmiM0co1piYLR3xWQFktjN5re20dml+fFC1LOg32/WX2T8qE6ltN9nsRqpWD2cyaIOJ9voMsbJIHn7y3CmoUEI9U2yHhkGtxS0cJQayY413qgo4M/fnH+aVnvvTTOvpolkL9R4m1IuYVZIpl2cVUYpM8HoxkCZD1bG8DXK2GFUvsI0CrqH/mks4W7KCdjWc2jv3Uw44lahiCXUxWKgaY/syqwSX0PoOe6DuIKmi0bGVU9I1eRDz6xCRVtNc0l3nb0EW1WCVLWruWan3Ce5WqrCZDm+TbI1KyuUo0vPNdVN+3tnUC1GScC7fmyp4zm2BmrikKD2OVW54M7nPIGzLeqRmoZqkGRt4rJ1Yq9IErZasjaEjD1eCKPQ7nMrgzHpgI2E45D8gbHk4CTSNkYGg4FuaP6R+RQ8rIIC7JYLHlg42ZY36eIehk3MIwycfr36KxlCYhgJzqnIfYRUSQnI3nkVqhRVeCHnIa/P5sPI5dDPF/nXsTQMmeMD+z/WqizBhLRXtTyT0JAXl2F95XQ7d/ZKTxUWF2HfIBWzeqIGzu8DzL/YXkWgR0piUZiImcy6iRVL0VDB1Y4ZsNzlHFGCRyEm+bn9aBO/J7J3cjh
 0yqumr1c
 ykm5/jae0SmGJcHGDtlY3C0XQuEqV+DnvrGRmGojBDsoYGGHjr9Raz99eYFmJPNX+kmt7FDOoQc6RujxeDAP+f6fmAteo3GGrDRzl9ytG6gcTeDSQPTonKf52nSjsWzFRH2IEPc0gFI8e72M3zRxcf1o/y+lKOaNyVze1tNBQGuuvIrwUL2wjZeoDd3WquvAZmCoBc6GFo+pYO5yj2tv9wyPs2MdXiRoWKeyzpmXWR1D4npG/0qMynP+A7lBLj+Y9by2NgcJqzOuyhSsXzcuPTllkYmPcVeLe0Xxs6ZpTTG4VZE6lOxY/ajSQd50K2Jku3ZwRlw1aZGtmwv6zQApkzkFapuWzQsADLJkwQFLawCBvdSLqdQTiHu9dUanT3WFRAKXtvEXCKTyZ1tMi8/F1ot7H2p2KC5tSgyu9U+sbog8suDqwnqf/G42rNEzcBvA+dxURmWiG+79vhhw/fWyt49+mUS2F8eTF5u5P
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
index 5b368f9549d6..710b1dd681bf 100644
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
index 5c07e2b57c34..19be8c575647 100644
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
 
@@ -1580,7 +1580,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	int nr_pages;
 	bool split = false;
 
-	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
+	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
 	if (!total_swap_pages)
@@ -2938,15 +2938,15 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
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
@@ -3091,7 +3091,8 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = flags & VM_NORESERVE;
+	if (flags & VM_NORESERVE)
+		info->flags = SHMEM_F_NORESERVE;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
 		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
@@ -5833,8 +5834,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 /* common code */
 
 static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
-			loff_t size, unsigned long flags, unsigned int i_flags)
+				       loff_t size, unsigned long vm_flags,
+				       unsigned int i_flags)
 {
+	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
@@ -5851,7 +5854,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 		return ERR_PTR(-ENOMEM);
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
-				S_IFREG | S_IRWXUGO, 0, flags);
+				S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
-- 
2.51.2.1041.gc1ab5b90ca-goog


