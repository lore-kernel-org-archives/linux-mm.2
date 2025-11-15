Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA70CEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F8D8E001F; Sat, 15 Nov 2025 18:34:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933798E0007; Sat, 15 Nov 2025 18:34:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE358E001F; Sat, 15 Nov 2025 18:34:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B80E8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23E0B1A0861
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:44 +0000 (UTC)
X-FDA: 84114448488.16.8299AB4
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5643840003
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OsQSLEuP;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQfGBV3CSsV2YD3qXZ/zQArJZQqVNJTRetihMrpqxA8=;
	b=4PyQq9UjxJYpQyVsqU2Dj/BfhQD1EvKLEOdijJ52u8EjOOXI6xnrUY811UWwLba0BlqW7X
	hxu4wv0MvkxX1sRfdqfGCC15+TnB2V140VEt3CwN4KvVa3OlDfaCpwyY7960UPU1olykt2
	wlr/ObUlDOAf+dlY3xMNRk3o2z8DvXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249682; a=rsa-sha256;
	cv=none;
	b=DMjXoEgbHefiXJbvWKwH6eWyS0RhgsFXw/DQXecRB2tRqi6SuDuwEEa5bmlb642yL/EAt3
	kwOUqt25adDelRxdZ8zI0pQdiEGB0lI70iZn2t8tXMj622sQF66UlLc4IJaP+lg8iO83J2
	OGyipi9McMNC2Xq2IiyHrd+7Gm64Cx4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OsQSLEuP;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-640f88b8613so2731135d50.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249681; x=1763854481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQfGBV3CSsV2YD3qXZ/zQArJZQqVNJTRetihMrpqxA8=;
        b=OsQSLEuPIi0/v6Gq5CbRfL7erARAQpgNYlu8+A/U/BAuPh2q53wiyjTrO9YANyCpB4
         7IuqHeNXsVEUdVyd5ZE8io+rNx/UoclxQJWZNkPzrR1KGfmZboBdEDeGFScx7qg7jP9D
         i5FpkHxLjt+n//dYF/lApWCp6jdP56fPeP+ezpOuQAlZXgJ+7tHwizz7N7tPwxmSvExo
         RBClsl+XWjlPOqklXPjHXxMjcpPgMk68kDuot0+Bof4VuoFZnJS72E6mq4WQZybUK6VC
         46i8UFiPjz1LQbQX5VIMaSRsL3uE6EivlWGcm0ksoMv3VWfqSlFhrScMkLU6ib2HPVNl
         UQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249681; x=1763854481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jQfGBV3CSsV2YD3qXZ/zQArJZQqVNJTRetihMrpqxA8=;
        b=wMFvn6dxgTQ3Wul67Gzod21U/p6L2Ph2jb7hODLcbJ1f1X5UGmJ/wnzOxqCrlh60R8
         nCIMa8kqnFSKUqWh3hiwSMGJjlZkAl4p6PSzRJdbtKJEOgVZcSt8NCpnVU0ZEd1JGzyO
         WmC41j3XAROVLPUMXwSw9QeGrXlFzgeMwuNRAWTmWfzUbZPX3aUwTk7Gj02w9aQIVnMo
         31h3XAAM8Ho2Dl8zx3tok6xBfba0zt+nUcwTl2V1K8BpNynyt+bZEE3QyhU8HNsA5qO1
         Yuo7+XrwLjFabFOcMYT5bOsfHmuH7zNgEdXRxzdV5WYqtSe1Gz3UPlK6kGmaZvlvMORU
         hCJw==
X-Forwarded-Encrypted: i=1; AJvYcCVx9kXxzv0CeuO7aEtygS2OQFKvRkVgXqI15iJQ3fGOxMmLZFwl/tdpp0RU5ikxBsnXreH3Azzrug==@kvack.org
X-Gm-Message-State: AOJu0YyHDAvMwAqI6fG8384LXJgd+tASvLWs/U4YDqrcHvAZM2QplbWY
	tXi3bxYgw24soXiYLdniUjWh36+b++rQch5Fuxe348CtceBRBOOv0EtbnHXdYo228e0=
X-Gm-Gg: ASbGncvkG0jcOsJDBkx4UmpvsW1IedRfigiA2+qoLgWnpDvonPFdi4/CAD6uYGcJ8Il
	kl861xKOdzlMjFFGr0knV443dJoaWHRJyl2vywxQBPY1mO54nxfkSF8AO8RJu+ykXf7kQz8Zs5E
	nprh1jTANDiob9ItO7uExvZTVC1QeHZzUC9wqDnpTESBzHrlnZcLNwy+Exs8AdJqhiuwNllZb7b
	TIW1ULYVZSLV6fVi46Y48DNa/Q/0eNA/BrySixuXpiRvLjN8uNvk04T5qdchw0fnHQGxTFHRNxy
	8Zaytew9eMfL9H00bAdQgl3nQijXVGFuD8VV/BerbQNCTYAxcrAqYVxHZuRbhjTqwrrZ7+gGcGz
	Ud3s3geKqdWgLNX7o48aSgST4Ex11H0AVQyTiW6X38r16CQoXtDcP92ZUhzEfbQM0obbTIw3k8Q
	7j5mV31gi1GRRSQQgcojh/BscS8yvekVzzgsyVRInfF0p7q/xOqUba98h5NrVUkJZIQId/y4kdo
	MZ/eKY=
X-Google-Smtp-Source: AGHT+IHeAL+DcR07qAd9Iq2m/6xSEhl2MNEGDRSNqvjmNRLE9j5J2Un3wjkpsAn+QXmHZ/aaiqTk0Q==
X-Received: by 2002:a05:690e:148b:b0:63f:9f5c:d96a with SMTP id 956f58d0204a3-641e75ba074mr6023031d50.27.1763249681206;
        Sat, 15 Nov 2025 15:34:41 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:40 -0800 (PST)
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
Subject: [PATCH v6 11/20] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
Date: Sat, 15 Nov 2025 18:33:57 -0500
Message-ID: <20251115233409.768044-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5643840003
X-Stat-Signature: o6ta9bysp75yhc7prj8ihkcuxwkyagcf
X-Rspam-User: 
X-HE-Tag: 1763249682-155674
X-HE-Meta: U2FsdGVkX187uDkNAM8qIzQK7rMstdGDlVHdAfBEv8OqNCJIg1AMYVQoqXFXeuZYvHa9wHrb6o6EGBj9fE8X2ACL/RukxeU1Cze1uu3fMFRXSselWNL2t5C2uwFIF+gpI3FBN9jNujdWiVcwhga9q/kh1iuiFxBYrwIaEXeZ82gn54mo8K/GkTIUcqBFciIEC+MvAq+/+KBh2Og2MKJp/2RFW6no20T3LBPZ0RLdrYEmR9RZ/CbHHpX/bXWtfrixx9fJmT6kyLjUn5UDPKpIBiybJzNTYYO5JinAM1REYoOOaqXXZtxcndt2gdEhKa264v4qY10tRBUtWRLbZudK0R0vCfnylOtC2+dPmYRwS+7P0SJfPikG+cI7aHlTmsw/DavyOD9fr4pn+vXemaxCgZjDR28kGpQDKk2NG5FHDotRPeq8nZEk5GRriKtt60fZwhGxwls7GWJYdfpGEiWcUxvb+rKIf8gUlZMHsMWg3petnmBjRF4ix/9dP34JrHPKZAMtW6fwVvnOjjvm38AVDw0SMGAfOl4Ck0bwc4wHpBlYTDUhvQCxIN/h9ZAcXzvLdqYURX6hx22T6pLdT4bzYNpIXWisxasKMpMzJt0tM1H3Hb22EmXxbYtmnbQT5FijnuRL1P/7Q9/ugAJCrI8bC06gC4V+Ot5KLKm1N5T5GmqhIsQLd/w4HQHYC+9xeyiRwKi0XuwkV1AHHQ7ZL+4xP/y+++H6bNPb2uo8yLcbG1s/NWPk3V4qQOwTkhRf/RIwOfNcsEZm5EtIwXm6HgCIF4gdPYn4Tl44OAApoNBLCbMfYrnUpALS/wwwrtudO83tsk8BCRdG2Cgtayyd4v8tSsKX8bTol7uR3/9pNnYpEBWjoB5XH1o684WM81c2U7jUmOzZiHdIr4lvfQb01ue/IQvF9ah7/ib/nnvkCJxgy5ejiZ1LdeAcNPWCuZUNjgBGjy0npuXrpZ3c3aZMTOx
 GGvdNmkT
 s1v4R0yFNRbnvDG6xlWMxIZxNidtGDlxw4W07rwOi0Wu7Ttx7vriBlxNI95taUunEHxdT3IsAWfMe/Z9Yvi19nCVfWQ4sy8+fn30P4+4D9KoKI4FYoDQoeil0upB0bz/EERMudkCz0KaNdV/6CvBH6CnKHJuSKNBTWecx0QA3v4MCtUrZmN0fkzyDStZnIlSfCBVs4iwGVZOoOBi6TtrNbbdMnbJRPkFpl2XhKRkDLP1GWXBgKwODmmuijrW8z9PXa0zzuQYmLjN3/Vgyxlm8adv29D6+doD0mcWp7XaH0xDIO4bfzkCS5591NbnCV9+YOmnUWYXTXtY9sf/zD0Dx61lIK6MZ/vJBIlolJh/qAakUfeqOEuBV/ADXePuK0gNeaRfm8VVCAP/QYrSxi4xb8FZnZkZecEZAzu+k7cJSOhJSofR1sXuK51tdl7S8FEaJgnH0JRWUlonaDpuV39XwqGzpu4eI2B06mBRF
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
2.52.0.rc1.455.g30608eb744-goog


