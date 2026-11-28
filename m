Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CEA606A323
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vtft9r7o
Received: by kanga.kvack.org (Postfix)
	id A3CC36B05B0; Sat, 28 Nov 2026 07:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE6C6B05B1; Sat, 28 Nov 2026 07:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6616B05B2; Sat, 28 Nov 2026 07:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0F06B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:09:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2877A8250
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:09:33 +0000 (UTC)
X-FDA: 85484408226.17.614B79C
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3C45918000C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:09:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vtft9r7o;
	spf=pass (imf24.hostedemail.com: domain of pocj8ur4in@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795867772;
	b=4sXj9rEKmJ6ARK54/tMG35ngDq7NbGtAakThoOFwbr/AFmKLrQEdq41GZrAKgSaYJbXO0l
	mhxXd58iC+Ed9ys3zDizUoTPdi+A2iNUT2JjmiIhR4qtNnkpk4y1oSzckVjK5zj5utHZuc
	gztMISVi//T2zUQEqkK3/I8soVqbMdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795867772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=8Jiv9ZXJd4/e6+6mw3fXtRxAM/JyvESKbOC/jJ1aZtE=;
	b=uVbTnwagnjtq1U6TZH7dJWfFDV/iEqipANX/ckdR+hu/9ERpQKs6tu35CW4EkrFd9iYaDY
	+sNa6RGdz4DaQZBHfmqlnwVi+N4FPgXZ2YkbfzzLnaHIW7hFimLL9OlaTvmD+Jbkc0/6v6
	M4VvMUQFkHvgQ+6R8Irehm35CRuXGWc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vtft9r7o;
	spf=pass (imf24.hostedemail.com: domain of pocj8ur4in@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso12328845c88.1
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795867771; x=1796472571; darn=kvack.org;
        h=subject:cc:to:from:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Jiv9ZXJd4/e6+6mw3fXtRxAM/JyvESKbOC/jJ1aZtE=;
        b=Vtft9r7ouvjGw03EO4lfJWb/4S/uWCuTPlJbaSbXucM3XXgF5i8K5IpT9YNW36TK42
         aDzMB8OAJt8XBocIaZkGCgvLJ3NGEoSKJLrleyQKcwoyzZFOMAKF6G293hII/GkZVxsD
         8so3Ew6VAq0QPIaWhxwNn7sIV+z1j1YUc7Z5vHt64gcujyArObiCyi1gGzEcSgMeAfg9
         qVc+uD2UfZd+juwR5rITEekoXMU8vrMNqmPT5acGtRz5WhAQK82Ft2QMFul96ZpB9VBF
         jZwOYQV/wukjL2uGXXF4A3UzndNzsKkjcwLfl3ZkAZi4We8gqKSXJZ9C7yqFTJBjbTBk
         1lJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795867771; x=1796472571;
        h=subject:cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Jiv9ZXJd4/e6+6mw3fXtRxAM/JyvESKbOC/jJ1aZtE=;
        b=Ui05XT6oLFDsKIc6KfLNzL9g+FVgdWSugAgW4EmCFGVIpzY0VTwP3Ign0SJ7Uf60sH
         yRH2nvK5Rr1pFAzKoeIn6mRDNXnttsvXseDEH0p+qaBJXVCBEJiqX92Zh9eAaNF35JLS
         DbwSqJFGGM6imnU7oMe96tgsZq887McdSeHuQxRuhVBA8xTNcsrxonSgFiE8TDZMsAoa
         tJ8ACg/hMsccL47HbyagpsHcYfHBJTyN3No6S6XamhQarO4/E27PDmEH+3kcbZ5208rJ
         z5Q5fiY9TFhnPlD51tZm21greVtbsUVZ0RMhWaR6lyNvuYvK++YJk9++0RO9PKlyclUA
         INBA==
X-Forwarded-Encrypted: i=1; AL+hErFKIrzEp0p24bIB2715H42YLcsk7R5CErVz+vcnNfCecGFKqONVF6OAztv6QPFrT//XW0FLeCZk0w==@kvack.org
X-Gm-Message-State: APuU4Z9FHJmlAOEKBTQCla0z6i8nukO/Tz4aJ5VNRN5ZlxEqRxvnpAiU
	MI5DTnZzJFrsn0PPRcQGPYGKDlo0oViMcE4ZI457PWnyvjVFBnAjKfkd
X-Gm-Gg: AZFdTZcSyjrbEJN/20WM6UNmbNIl90unKSqaV7dGHmVshRHaopptLgpgrTCl4AzvkPy
	e/FZ9AMsmLj2wcTOEqnf0hCEKsVmkWmwrObT5gXPSgTk8dmw/J3t6DbynkkPCAaIBC1rCIz9kho
	ZysTJw/2wp3QLWJ8JU+ichRNPfESS1l7h/NQmazdIX6KsA5CunDdnnmHkKssAjxUkOwIAfXfodQ
	DwZM7ZGajIna0sJCw6qyWx1VCORlfIca3RpEK5rzyXIwNeTthNxA6TozU8l2jcG+e48az+MIDSL
	DTuzT9Oq2QYqbLv9HPFJG6bnZufV+wG+OMZFYL2eaYeXvU8Dhnui0dXjGhDwVypbvZMsHBwdpXh
	wX5x1ysZczP7fCGIgUJ2iy7q52LDYZdxseCFW8HKneRsf5gDiYNfgyPDz4nU9af1H8K5S+I1EX9
	fkgIjA9IewAtZv3Nf3RKdfayUC1NYX/VMu38f6GPJBYWRwPqPXDpF1+abeg6S/pB8nz8rxti01L
	nKVPAcLfvcwpCgsfm694ieGUssmvxrqSN9T7AtbmacPkCazBz3E5bQKIBEY3JuC16OE6ARNjjGl
	2Hipk+fUxfyr/lQ+l6g4pThqfYdjOazLJsE=
X-Received: by 2002:a05:701b:2901:b0:1b5:5fe5:78d1 with SMTP id a92af1059eb24-1b55fe57b02mr24641685c88.11.1795867770728;
        Sat, 28 Nov 2026 04:09:30 -0800 (PST)
Received: from [192.168.45.62] ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55684c85fsm96587180c88.14.2026.11.28.04.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 04:09:30 -0800 (PST)
Date: Sat, 28 Nov 2026 21:09:28 +0900
Message-ID: <179586776810.146060.16432032400935006500.c113-v3@gmail.com>
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/secretmem: Keep locked memory accounting until inode eviction
X-Rspam-User:
X-Rspamd-Queue-Id: 3C45918000C
X-Stat-Signature: cutxcymm7o9y8ajh34zq963d8rnahscr
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795867772-551549
X-HE-Meta: U2FsdGVkX18UD8uMQevoWn7WmFhIo8NaWqxkMaLhb3Wc9kUTTd2Vu8+btYFsM8MPzXVqQ4RqnPyI+OJFQOZkd9JalkEg43zVbySaHTVvjl4lZOx4u/SFvR58U1H1W2TgJP9EqoWLyS96ccHEcohM346BHh7sNBMlMLUDDudTF9oIzR5hxPWgTU57HQRuAE9w+yVgp47CNe3krqP0pwdGAonOY73fU1Zv8wYgOiJ3BUJEvxpIqqNpzOkq3EuWJ/lNrXRpuuIufXekQ4qQ8x/v7x8+OfRWOd1CJ8isQASeKA2pj8RL3TK9ov1f+EVOIr0XEpKoWZVm2XauHT4gQsD9DIBhuN4UalwJlTBejUHcvNxwOXmtw1SjWVIvU8+ho/I/qOU5H9vmbCnOWImWx5HWVRQ8aKxdjVs1DP9c+zR2TMSWxYVhmEGHGqtTBK2+l5yh70GI8ivXggwACT4u8J4amVW135iN2mxF/ISj9tlyXcqQvC7BQyO7pMbty89IFRZVWcxw4fVigZMk41otDGkVfLHeu1/1W/BxeTWKlT7eJFwg7CZpFMmuFmVkxasOw1lr9+s+cexwq9QXX2UskndZYDEHG7jeqBtNipzqxmel/ycBFyHcUTKjS20+8eJALkOyF7WOwsqTPcNFKoyPzPRoC/b512T4Ig2F3Ng1qF9ZWesloRxiProtV6rwhU2fSIq+TBxZhaZ5g2aagzZNebq0TZHfywqiVVtBbLEEjQf29qEdL2cqZtdg/evBoNmv0OjdwZ8AMHuqDmrz63vOPZnQjwB8rGdi1TdD1yTAT/evJ2gMs6VroiW8FodqSXZQ8Wa8ulzzFveLVeXGFhBE56LX465UsT9zEx1S6qoYNesjakv+jiKEX0fZCx/WWPEvjCyU3NfjtfHO/Z+h4ylmvpwCrzrKrXqab48RL5jlNorNiFfCSid3bXINxsfjG1OxKRcRaW47nqR+Ef82d2FR4CY
 zoJ8Jiwa
 DmETZkksQa7qHLH0IrCq2C6h4OfCatQD5u+TjogvAuLsTjYEMgM2ExOhtPyV7i76XRvmmEVrgv5hW2VVelUMFCG0mccralNc7WX8eWKlRtRcIuUAoUimPa3CGxVcmbATqDe99J3Mf7SEym/Vt1eZyRLz/bxkMW4SaSyhmKO9E1MsAtT3WZPu1k5+Fya08KESRrTYIpPrKZ2pur5UYEtwplfF75HYsar8JqfULsuSkWtQbFssdCNnRiK++gxeDxjyPV0t5h/SDS1eYW5lSdWBsJRxUsTU6sOJJK0g0fTPvr85t5rASWPhY824kEiaaso0OOb9ju067NLlZwgflkXo5x4nyX64b5zhTPfsU1B0GXNM3Urzfvh2WlOwT1NuZP3Z6rIWXphpIiGm7BdGq32fPYI0uVoBEelIeXI3dxvfM9RKsSjw0vpdGyUpSzROO2LBFPB71zPRf+Jbo7U66kTSLwOEs8Sua4xjrJSdWr8Vfn+K3wMDa8PtYYYqmlsAYGZU/uhQ47iwax14i4yqyGtKLv3smiEBZAInac7dAo2fumWQ3q6xlHNNKePx/tXM0PNLl/IEFhxwbGQ/LikioJ8h/+9ig9PgbUHJ+b6lYo53m6neYwTDxjCu0N/JN58yh6gxLhoSKDT59KBLAHoTbF9gXxjUhI4mzq3io0W76qs+P9dVqgnJ1dyoZNhevEKVQpKAZQAdE8qrl35sZKFlXvFb1Qem1Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

A secretmem inode can outlive its original file. An O_PATH descriptor
opened through /proc/self/fd keeps the inode and its unevictable folios
alive after the mapping and original descriptor are closed. The file
release path nevertheless drops the locked-memory charge, allowing the
same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.

Move private-state and locked-memory accounting cleanup to inode eviction,
after truncating the page cache. Keep secretmem_users active over the same
lifetime so that the hibernation guard covers retained secret pages.

Allocate private state before inode creation. If the secure-inode helper
fails, release that unattached state and its user reference at a dedicated
error label. Once attached, an alloc_file_pseudo() failure drops the inode
with iput(); secretmem_evict_inode() then frees the state and user
reference.
An LSM denial inside the helper can evict an inode before i_private is set,
so eviction skips private cleanup for such inodes.

In an arm64 QEMU/KVM guest with an 8 KiB RLIMIT_MEMLOCK, the
baseline allowed an additional 4 KiB secretmem fault while O_PATH
retained two pages. With this change, that fault raises SIGBUS until
the last O_PATH reference closes.

Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
Changes in v3:
  - Move cleanup of state allocated before inode creation to a goto label.

Link to v2: https://lore-kernel.gnuweeb.org/linux-mm/20261121164020.1465498-1-pocj8ur4in@gmail.com/

If alloc_path_pseudo() fails, the caller keeps its inode reference. If
alloc_file() fails after d_instantiate(), alloc_file_pseudo() takes
another inode reference with ihold(inode) before path_put() releases the
dentry. In both cases, the caller's iput(inode) drops the remaining
reference. On eviction, secretmem_evict_inode() calls
secretmem_destroy_inode_priv() to release state->user. Calling that
destructor after iput() could dereference a freed inode.

Tests in v3:
  - On arm64 QEMU/KVM, the baseline allowed an extra fault while O_PATH
    retained two secretmem pages. V2 and v3 rejected it until the last
    O_PATH close, then allowed it.
  - Injected secure-inode helper failure returned EACCES after
    NULL-state eviction and err_free_state cleanup. Injected file
    allocation failure returned ENOMEM; inode eviction ran free_uid().
  - In the product Image, /sys/power/state listed "disk" before
    secretmem use, omitted it while O_PATH alone retained a populated
    inode, and listed it again after the last O_PATH close.
  - The product Image built and booted after removing the test hooks.
    W=1 used KCFLAGS=-Wno-error for unrelated GCC 16 warnings;
    mm/secretmem.c had none. checkpatch.pl --strict reported no issues.
  - KASAN, lockdep, a full hibernation cycle and long-running
    concurrency were not tested.


 mm/secretmem.c | 63 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index b3f79ad56790..433d31392379 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -189,14 +189,7 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
 	free_uid(state->user);
 	kfree(state);
 	inode->i_private = NULL;
-}
-
-static int secretmem_release(struct inode *inode, struct file *file)
-{
 	atomic_dec(&secretmem_users);
-	secretmem_destroy_inode_priv(inode);
-
-	return 0;
 }
 
 static int secretmem_mmap_prepare(struct vm_area_desc *desc)
@@ -216,7 +209,6 @@ bool vma_is_secretmem(struct vm_area_struct *vma)
 }
 
 static const struct file_operations secretmem_fops = {
-	.release	= secretmem_release,
 	.mmap_prepare	= secretmem_mmap_prepare,
 };
 
@@ -264,39 +256,33 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
-static int secretmem_init_inode_priv(struct inode *inode)
-{
-	struct secretmem_inode_state *state;
-
-	state = kzalloc_obj(*state);
-	if (!state)
-		return -ENOMEM;
-
-	state->user = get_uid(current_user());
-	inode->i_private = state;
-	return 0;
-}
-
 static struct file *secretmem_file_create(unsigned long flags)
 {
+	struct secretmem_inode_state *state;
 	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
 	int err;
 
+	state = kzalloc_obj(*state);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+	state->user = get_uid(current_user());
+
 	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_free_state;
+	}
 
-	err = secretmem_init_inode_priv(inode);
-	if (err)
-		goto err_free_inode;
+	inode->i_private = state;
+	atomic_inc(&secretmem_users);
 
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR | O_LARGEFILE, &secretmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
-		goto err_free_priv;
+		goto err_free_inode;
 	}
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
@@ -309,14 +295,14 @@ static struct file *secretmem_file_create(unsigned long flags)
 	inode->i_mode |= S_IFREG;
 	inode->i_size = 0;
 
-	atomic_inc(&secretmem_users);
-
 	return file;
-err_free_priv:
-	secretmem_destroy_inode_priv(inode);
 err_free_inode:
 	iput(inode);
 	return ERR_PTR(err);
+err_free_state:
+	free_uid(state->user);
+	kfree(state);
+	return ERR_PTR(err);
 }
 
 SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
@@ -335,6 +321,20 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
 	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
 }
 
+static void secretmem_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+	/* The filesystem root and failed secure inodes have no private state. */
+	if (inode->i_private)
+		secretmem_destroy_inode_priv(inode);
+}
+
+static const struct super_operations secretmem_super_ops = {
+	.statfs		= simple_statfs,
+	.evict_inode	= secretmem_evict_inode,
+};
+
 static int secretmem_init_fs_context(struct fs_context *fc)
 {
 	struct pseudo_fs_context *ctx;
@@ -342,6 +342,7 @@ static int secretmem_init_fs_context(struct fs_context *fc)
 	ctx = init_pseudo(fc, SECRETMEM_MAGIC);
 	if (!ctx)
 		return -ENOMEM;
+	ctx->ops = &secretmem_super_ops;
 
 	return 0;
 }
-- 
2.55.0


