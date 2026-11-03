Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BA8606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GXwD0i7o
Received: by kanga.kvack.org (Postfix)
	id 92F746B05CA; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFE96B05CB; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6E36B05CC; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4469E6B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B62D5402F1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:34 +0000 (UTC)
X-FDA: 85392007428.03.DDB55A8
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0DD2180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GXwD0i7o;
	spf=pass (imf02.hostedemail.com: domain of 3pzLpaggKCBAt2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pzLpaggKCBAt2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7jy8MubX3hGHk5TxpJrbkUXvzo9K2tHVQ0bkJ4pbKo=;
	b=A1/8b28fOzFp+w7hXZFDgLqwbJaziySyIM4qGWV5F28ClsBJ1boKc8M7sYbPf2TQZW+GgC
	ufUfMZgPy0x47KFLDTH9hTMgP74yXEfN+/ni6+izUzrHZqa2KuiEJcgO79PULLojCKlK1f
	hcLwHhgx41OpTBhSw4EkdnS0oUu0Ujg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667753;
	b=jmpwi3sXEUa2EIq3TcL8TnchFh/4MBIq8h5e0idGzE0cGd+rjWQpWwvJ0qAubUBk84yQjq
	6X/+jjF6P7ISaWHv7F4iNT2Q+0wpz8Lvy4C4+Qewgo7rgndFyJ9MuS0P2X6AbFUytOO9lu
	/OOMbnZbpuMxYTL5uB1l3P5eliwasRY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GXwD0i7o;
	spf=pass (imf02.hostedemail.com: domain of 3pzLpaggKCBAt2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pzLpaggKCBAt2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d5dbso2758109a91.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667752; x=1794272552; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7jy8MubX3hGHk5TxpJrbkUXvzo9K2tHVQ0bkJ4pbKo=;
        b=GXwD0i7ox6o5dtBWepmJiIijgFU23y4q74+5muIlzMZ5Ir6xXrDFQ3Y5jEtly6SXsy
         438Z+AJK3oe6QuhG5r6YtMN2G7dXrQ/oau523khPpHIOoCMbXST4m72/YdfFn36ubkLV
         cAUAx9V5AVrj6mccdfmNTQ6wkMipz8Apbt94mGi8LMT4aCYNIw4a58lCL4RQWbgjDGaO
         Ij4DfvzUi4UQNZMo7BsmlgCA0xLV7nfc7M8iLgizYaJ0TDBG3hypR/iqgV7QaAnLvQ2U
         SsdAPNXHKhBcAklfYgNuQAIa3bIyc73AJ78ZxwWaD1Z5uSfrycmautLom784cNaIXcEO
         pspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667752; x=1794272552;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7jy8MubX3hGHk5TxpJrbkUXvzo9K2tHVQ0bkJ4pbKo=;
        b=DrWEWnMFnJqiFI/kweCZPcvUCp8pYzRnWr4oLNioRwAFleb3/gFfkFYaANcw4dIUKW
         hAscv0XE0LtgT0PRN1nNL2SOo7OfjXbv37pMg/MFJrT7tmg50A+XeWqP6Cmvge2gegFK
         tuJLu5ri1ExShoeuGMOTXmMJrLgiNyfNaxxlxirjPdtyWRTBpfMowSfEYFq6B1jkoOCj
         RBS1cWua80jnBTIzOdYfRTOsodMRIACG/it15O04FySSTZNpDVA61+vvvc7Noe+yzQpS
         g5ppAB7qqbSa+lL9+6lR00DkoWb2QGvE5bvqKXUZunYjxnz2ljfB6/W2UW2RYIYi20yv
         YWRQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8etIQnNCDfhNIXY225BNgrtD6Upk9O0JkGICFZEiA/d1BsxG6PdWZlyoy8k8aIXw5khRi/DJcmA==@kvack.org
X-Gm-Message-State: APuU4Z9T5fxPD7kH2A7tundxCqovTSH4WsSuRUfIeD2a+CnGp1bVx21c
	W1lW+ZMY0qZYQQCOWGPH5FmJZUPUhqQJWaJ8QDbxy327KLPB0tuaeuXzA7corZSXEqpwewekmLj
	t8JD+N+cADERQVw==
X-Received: from pjqg15.prod.google.com ([2002:a17:90a:a80f:b0:3aa:f38e:cb2d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8b:b0:3ac:9e76:aa76 with SMTP id 98e67ed59e1d1-3ae8970fd9dmr9928947a91.13.1793667751455;
 Mon, 02 Nov 2026 17:02:31 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:14 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-9-dmatlack@google.com>
Subject: [PATCH v3 08/10] mm/shmem_luo: Allow preserving tmpfs files that are
 still linked
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qdhsd744751fxuhpgrratp8sp6t7hxcp
X-Rspamd-Queue-Id: 0DD2180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793667752-142876
X-HE-Meta: U2FsdGVkX1//NUSD/PngMya0MxseXOzN/GYgbQo9zX1zdYL/PYzbceuPQ7tkX6nTA3nE6NRzNUKrSZ0DdOm7Rj4wQJ5Bg4x1r4QzlHiJANLDADnac2CaQ5SGYdkDeZZZZRHoEjfRDUkpMwopOGFMfYlqR79lvE2mQOVqXlTNTi3MwnHFhFpLgVqFfWZ9BzaESAkK4HphWIjYAxgbjBS3mkfMglnFTE04TXyZq0O4+o6DbeyvKKoBDTYDmzVao2C23KXtL5LNK3zECH/7YmmqDj2HLkLerjEHSN8GWxdJk0D5hj2XAsAfqR5r0qZpJxy0rlhY+MQP6uLlp1pKB3JcTeRoa33GdUnTt/wAObAdiOcRd7dIjUictDrH/ifcfmz1GmfFJ1vbNFi4JgA51ElnVMw6GK5zg1o+j3nEKbCBiKsmONerD4qiKlXR8GHQlZP5aPeidub9q6VhdmlbThHo7/8/Foiup1XM3Nhgk5ba5qrRuxg3tZStUM3WBIEeRoxe+Nrh3D0SCf1ZUTm3wmErqnf1nU2XZ2tGmtyVyO8ZNdbjeqQKZyHwfbCC5t8bcF5qjAhmq7OnwdVQnpAD+MpPqWQVTl1KhLNXh5HjV/tPzmOrgjH9rDnb9UH5ZPzmaEAaUtMKhH/VV5h06XCtLgz6vuBOFTx3cF6cPAQkKdMqeBFnHbmjSQDhCtzTm39/aLIuH2qKQUxoU/WHqQr5qk5a0vPJOQLrBhklkDtb6/86x7z6sRkQm1PG0uXN4VLpnSrnz6DXI7Ugg9QTQU3RO6yeuWTsjCW2q2LSp8iplA1uEeayBrNOG57s8shAWMCiK23Xtv383nNzxDpmqburlCzzCEDUWcAUxVDx3T297a5cAS7cMt0fUADwR2I50+aqGNUtFyTPQHWo/sz82OinjzkSO4Sg4EjG2nRzPB+N3tRQmwJuyuX+OWXcUioS3yhM4F7icT6DwetxPLpYMXGstWw
 f8nKDuDw
 QSWiojrrhcoM84EN3Wkyv3JxnrjhMg9/IbpeHrecgYXIlpwkHlp+Y79JQpUD/tY4n+LEhG9ktwqvqYfS4O3hs1UKxMentMkuAf8AjHAwNdxQfd3ms+8NBbbdBdkv4W9rENjQU0wOlddLqmCaGzTLrIvws5CC6TpAXR25aFAvdgi9tdirg93orojVdw3C2EqnfFbs/GCsJpoxvtuAzXvd3dxZ9vEj01DmCWENphN3m66IIhPn8tUKgvZ0sIgz1EUP3jPDI0unIVWM+Sbwjb7SRpIewFUu8rE65nV1YkCiu4tZoXaE1IdZ8tkevuPXaJBoEpBmg4D4zGDrj7wraU11WGiAOCndfwpcId5CH6strfhXPc969vwAy1Ai235yDQXEmxXQHxetyAFH3VckysspLTVwRKQlB2GKzX2ZARIkW4HF0CokwZO05Op5oEyPkcyD64oDQF4w5T6DYym2rDP8JW2FktaMC+a0/Vqo7oi7M3URszvwqQdjU4Ga7vq8gKptW4bqIZWKgGrHwGkYqEPIk9ceXD/NFFbYcrXbiI11geb1lcPmPV+PJjNQaX0YKP5nW/G8smWUtTZihleYhfG2oEcN8Uk/P1RYJrR9Ump0a1dJWjCSEnVguYV3wmD1pe+iEU/IExDAm2TQUd9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow preserving tmpfs files that are still linked. To preserve any
file, require permission to write to it and the file to be opened for
reading, and reject append-only files.

shmem_luo already accepts any shmem file without links, which includes
unlinked tmpfs files and files created with O_TMPFILE. Accepting linked
files means that userspace doesn't have to unlink files to preserve them
and can keep using them by path until the live update.

The path of the file isn't preserved. Like other files from tmpfs
mounts, a linked file is retrieved onto a tmpfs mount chosen by
userspace, which can then link it at the path it wants.

While a file is preserved, its size is frozen, so truncating it,
fallocate() and writes past its end fail with -EPERM. For a linked file,
this affects everyone who opens the file by its path, so a caller that
can only read the file, e.g. a world-readable file in /dev/shm, could
use it to break the owner of the file. So require permission to write to
the file to preserve it, for all files. Like FS_IOC_ENABLE_VERITY, don't
require a file opened for writing, so that binaries that are being
executed can still be preserved through read-only fds. Also don't
require a writable mount, since preserving a file doesn't write to the
filesystem. If the size of the file can't change anyway, because it is
immutable or on a read-only superblock, also let its owner preserve it.
Don't let others do that, since the size could change again once the
file is made writable. Like FS_IOC_ENABLE_VERITY, reject append-only
files, since their writers can only append to them, and freezing their
size would stop all appends.

Also like FS_IOC_ENABLE_VERITY, require the file to be opened for
reading. The retrieved file can be read, so otherwise a caller that can
only write to a file could preserve it to read its contents.

Preserving a file also fills its holes, but don't require any permission
for that. Anyone who can read a tmpfs file can already fill its holes by
faulting them in through a read-only mapping, also on read-only mounts
and for immutable files.

Document the frozen size and the permission requirements.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/shmem_luo.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index ecbeb37d33a8..0c012f242fc5 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -28,6 +28,24 @@
  * the file are preserved. All others are reset to default. The preserved
  * properties are described below.
  *
+ * A tmpfs file can be preserved even if it is linked, but its path is not
+ * preserved. Userspace chooses where to put the file when retrieving it, as
+ * described in "Retrieving Tmpfs Files" below.
+ *
+ * Preserving a file requires it to be opened for reading, since the retrieved
+ * file can be read. It also requires permission to write to the file, since
+ * preserving it affects all of its users, as described below. But the file
+ * doesn't need to be opened for writing. For example, a binary that is being
+ * executed can be preserved through a read-only file descriptor. The owner of
+ * a file whose size can't change anyway, because it is immutable or on a
+ * read-only superblock, may also preserve it. The file can be preserved
+ * through a read-only mount. Append-only files can't be preserved.
+ *
+ * While a file is preserved, its size can't change and no holes can be punched
+ * into it. Truncating the file, ``fallocate()`` and writes past the end of the
+ * file fail with ``-EPERM``. This applies to all users of the file, including
+ * users that open it by its path.
+ *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
  *    or tmpfs file are also not stable and are subject to backwards
@@ -298,6 +316,45 @@ static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	vfree(folios_ser);
 }
 
+/*
+ * Check whether the caller may preserve @file. The retrieved file can be read,
+ * so require @file to be opened for reading, like FS_IOC_ENABLE_VERITY does.
+ *
+ * Preserving the file freezes its size until it is unpreserved, for all users
+ * of the file, so require permission to write to the file. Like
+ * FS_IOC_ENABLE_VERITY, don't require a file opened for writing, so that e.g.
+ * a binary that is being executed can be preserved. Also don't require a
+ * writable mount, since preserving the file doesn't write to the filesystem.
+ * If the size of the file can't change anyway, because it is on a read-only
+ * superblock or immutable, its owner may also preserve it. The size could only
+ * change again after the file is made writable, which is up to the owner or
+ * root. Reject append-only files: Their writers can only append to them, and
+ * freezing the size would stop all appends.
+ *
+ * Preserving the file also fills its holes, but that doesn't need any more
+ * permission: Anyone who can read the file can fill its holes by faulting
+ * them in through a read-only mapping.
+ */
+static int shmem_luo_may_preserve(struct file *file)
+{
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
+	struct inode *inode = file_inode(file);
+	int err;
+
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
+	if (IS_APPEND(inode))
+		return -EPERM;
+
+	err = inode_permission(idmap, inode, MAY_WRITE);
+	if (err && (sb_rdonly(inode->i_sb) || IS_IMMUTABLE(inode)) &&
+	    inode_owner_or_capable(idmap, inode))
+		return 0;
+
+	return err;
+}
+
 static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
@@ -307,6 +364,11 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	int err = 0, seals;
 
 	inode_lock(inode);
+
+	err = shmem_luo_may_preserve(args->file);
+	if (err)
+		goto err_unlock_inode;
+
 	shmem_freeze(inode, true);
 
 	/* Allocate the main serialization structure in preserved memory */
@@ -362,6 +424,7 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	kho_unpreserve_free(ser);
 err_unlock:
 	shmem_freeze(inode, false);
+err_unlock_inode:
 	inode_unlock(inode);
 	return err;
 }
@@ -710,9 +773,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
-	struct inode *inode = file_inode(file);
-
-	return shmem_file(file) && !inode->i_nlink;
+	return shmem_file(file);
 }
 
 static unsigned long shmem_luo_get_id(struct file *file)
-- 
2.56.0.385.gac671c819a-goog


