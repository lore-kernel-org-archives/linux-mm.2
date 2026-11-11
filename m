Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82654606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H5il369I
Received: by kanga.kvack.org (Postfix)
	id 70F1E6B05BF; Tue, 10 Nov 2026 19:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6AA6B05C0; Tue, 10 Nov 2026 19:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEC76B05C1; Tue, 10 Nov 2026 19:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2508A6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6439A74E9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:25 +0000 (UTC)
X-FDA: 85420941690.09.4674029
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id DB80A4000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H5il369I;
	spf=pass (imf04.hostedemail.com: domain of 3trXzaggKCE8u3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3trXzaggKCE8u3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c9g0kwowB6nA8To7UzohEIkcTSHt64w98Bk7xlNAWM=;
	b=brimKX1uWUjhifuH8UYmDmWqJr25XsFWZOSX45z/4NP0PmoOdOwM2iDNTZYftXfdZwQWUb
	Fif94hOPpDxrfxLgR5t/2+11wwW2cdz26YKwXXlEEi73/vRuAQNBbThVqJWVoTUlHEdFQv
	4QtIGoi6lRIN89EDDgrvw9Vmh8uL9pA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356664;
	b=z1mqIVCWML6UyvMFsDH6N7zd68UN+2oyXqHg8ISrb1qf8oQD+v68tpht1spxx8v3X2kEW6
	MCqxd/1hkzp93lVz/IOAUDJzSeTbTB2S1c1499lvkr9cm2i52VB3Bka0arAf5XOKfFkFaf
	b0DNfV7bQERCN+HhEprQ14cLq7EFXL8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H5il369I;
	spf=pass (imf04.hostedemail.com: domain of 3trXzaggKCE8u3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3trXzaggKCE8u3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4c55ba309c2so3202314b6e.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356663; x=1794961463; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4c9g0kwowB6nA8To7UzohEIkcTSHt64w98Bk7xlNAWM=;
        b=H5il369IPwhRKu19F2pL/bX0S8d1msFviRKdmv3GCP9++Zx/bGyI7gbGBjmK1LOvOz
         pnFGIV5sP8gTT7o8jc2pu76p3ihB6sFga+ZNM6FlyrWcxXj3LHY7b1rxRxaBm1X+uZLH
         9EVM3CDqUjhQ8Nu6QDe1p6Rd4uEWFi5lCTNjqxQp4dzgzzNivT6WedxkHkzx1kx/T6QG
         YAxcVog+wvHS1xItZ5A9rABs7L+mk+S0fAo+vfeZR+O9I/68u2eD8I1IfQIEp/A0TLbP
         37IwdBDhkfuWJZ5RI2uz+lpljeqfWrWBy9eikWTRW1kiYsRJr3e4ibs6jVfy4WmoVyad
         gBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356663; x=1794961463;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4c9g0kwowB6nA8To7UzohEIkcTSHt64w98Bk7xlNAWM=;
        b=vsZnX5qijQel+4Zf58ToNd+1Or5S6LGFams0LNkfSIrIIl/Q5uloO17paFunoGL40j
         Bi3vmn4xiWEkrZMUsArkH+DvIXCg1fEcBBCo4E2Zs4U1vfCmtpwY08L9vti7TflISohd
         3NNYVZqs1Oc0XhXyL9nyZVjHhb6VeifODhr7vU9ZU66avj32LOJ5frc0fnL7ralM+0p9
         1/DFT+RzesNBiAPkUUyBLqoXy+FOyeO4tSldGxrAuTbxM4v0W4ukcpGD5FS8UYj611/a
         FKVnBs92s88ihNVekAzeBfsjFukEXbaO4pUsaSJfrKyRM6Yn1doDP5PgagPN89ywpGZe
         /wIA==
X-Forwarded-Encrypted: i=1; AL+hErEQcDqQFSLcPSeqZDvXaQ/Ofs5dmjl4812IHgvxdLaak/3uWy41d7jvz+N2sh9p8of41eHkeBYpwA==@kvack.org
X-Gm-Message-State: APuU4Z8hx+0kH03T24r80vQXwfFGRyoI8VWg1A0gJTwfu90Kjj4vrUt/
	gL2x+l0EZzrHzrGh7T5c4+nl/oC6vsr6uX6JfWknt1WFD87MwmhYSkTKq4KE87R8JkBNqvKM+5L
	nY0uqxjgdgQUF3w==
X-Received: from iobmr5-n2.prod.google.com ([2002:a05:6602:a545:20b0:9c7:6818:3175])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c234:b0:539:ad19:d0ca with SMTP id 5614622812f47-56b9770e3cfmr641599b6e.39.1794356662612;
 Tue, 10 Nov 2026 16:24:22 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:50 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-13-dmatlack@google.com>
Subject: [PATCH v4 12/19] mm/shmem_luo: Retrieve tmpfs files into a file
 created by userspace
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DB80A4000F
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: s77sksccbkwkej8yk8id41sbk6e9ygmz
X-Rspam-User: 
X-HE-Tag: 1794356663-541233
X-HE-Meta: U2FsdGVkX19KMqYZG45XwNYyNcSKTVfE0N2QF4DU3oa+P5ieH6C1hXXruomPHWD4Z2kjy4JzO1Xfg0nK/kfImsHT1Eov8AjdVySs8K+dpUgngHNlza+bUKg1si5jO96qROZstw0ew+X5VqKYQTwkYMMsz79VH8iHsMkaO7MWg4DtGgzhH4aNOR0jSoE0vrwUdQs58Mr9auKYwE95037jHH4UB5quetzVXvQKF8Am7pngcOnDeSVxxoZ3gGZFhtvYmPFI6xD7h4EJWLHxD7etxr2PmhPvpUlpKFJcUKg/PNnxOPDplwkToUZFhF263MxADQGAJdO/4ytVqp6qymWplxdxYkObo6DMZSqZVeVJA7vHGJd37pAKdcd+iigux2Chc8KrOVzPRVgkNuAEpjGB5GT0i46ZZi5BlD4Cu5w/6M1fyD1KctzSblOWVc5/CkvbS6PYpM/02NmaP/B1qdO2pORQOHyHp5N49YcugxkLbOAwCxDl8fTtpUmFI1pnz8xalr/w+rgYUrrFhxiKTgE9ec8xMOgb7PS8nymzbQSfDNkWTQCM0bLySbFvziSdsNZsFCrDJrsnuw05KLWm0mHgCgcvPfZRRRtSoyvTqK2Y6zYCW3NGyVrDLp2IT5th3jEUzrYIDzTTJSiqZ8qUOJvWy2gaAkhlMmJrwGPnNopLsml+lL887FmefpqlUau6DBD98+lfyUZvj7y8Q3Ui5DusAGH2RPy7GHxWH+x9uI95E3ZxQ/6QnF6jF3EeNr8x0Ht0ZLi0s+V+tdoW3SC/YmnyNuVLQqvB38dZC90ReuUH3fJG2JTgPBG47To9CIbQp0l+5copVszJ8c+767tBpwwfff2LGa/pHtINdxiZNHfzNen7l6ZBpRex6D1u5lOQlVs6b3iQLWXpoXeFUIrJDFj/Vk/qKuXuTDsU5dqrVgwmnKWYzidMSLuLiCF6n0cos0TUHjMNi1Majf5AHdEYf+s
 qnvyuknT
 m8cUWTsDd6VDGWx8rV/e/xLY9YLq3Mz+aBESfjVlcyzAhSQNb36QrL7LPWnI7gRi5n5yaXKoi2r9axFLSoeJWa4tFGCQef+VOn1ucxB7Y3r2TdYmOf6aQktMyKNBDJ9cYN2A1d3fjAsbbCP5MKgU7BIqbQbSvDN1uSZu7tQcR332nxUmBHyr8YrumLwpbwZEDZ78qToAUldL2h73tYBYMnKNqOYZO8cXAVyIL/hl4/loK4aIyiBYqw+OG3hF1yYeLZoiT/ujIfVs//Bw0+qoHWPQ/SuYsznTlO05ZUvrCUhMmj3ssMiCIf9aVIxWuTFWKkp/+UUY24azzE1ybWdxxIgPiIFJFLujGwEA1598R8VnxZQtCnR3qbPmujvoeqsJndSwaJBQyTGzfuljCexWNbBW06MUEq9gFYtdlP8b1YuXH5Mba/45nVrJTLKSEdtPqMndRV7VOJkvDX6O0Qz6jFTZQiQ2nN93zhnLqlD1iwQO+PsS040BVS21flaxF8lni04OAFLYVo/q3bNYF1V4Yw865bjPr8zbKgDC6r/TJJGOIl2V2o0Yt/slls2psNQxTdq56JxSHIAHaqKbMtUrNFoUuaiPF41/M9SUufkrxOt1n7fSpbfeE8ibNt11NI4/ZynsJyxYh2rNkcLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add support for retrieving files that were preserved from a tmpfs mount
by restoring them into a file that userspace created on a tmpfs mount.
Add struct liveupdate_shmem_retrieve_arg, which userspace passes as the
retrieve argument of LIVEUPDATE_SESSION_RETRIEVE_FD with a file
descriptor for that file, and record which files were on a tmpfs mount
with a new SHMEM_LUO_FLAG_TMPFS flag in struct shmem_luo_ser. The next
commit allows preserving tmpfs files.

The mount a tmpfs file was on doesn't exist in the new kernel, and the
path, owner, mode, extended attributes and other metadata of the file
are not preserved. Userspace knows what they should be, so let it create
the file, e.g. with O_TMPFILE, and only restore the contents and size of
the preserved file into it. Userspace can then link the file at the path
it wants. LIVEUPDATE_SESSION_RETRIEVE_FD returns the file descriptor of
the file instead of a new one.

This also fixes a bug: shmem_luo_can_preserve() is meant to only accept
memfds, but it only checks that the file has no links, so it accepts
unlinked tmpfs files by mistake. They are then retrieved as memfds,
which moves them off their mount and out from under the size limit and
quotas of the mount. Retrieving such a file without an argument now
fails with -EINVAL if it was preserved by a kernel with this commit. The
new flag uses an existing field that is zero otherwise, so a kernel
without this commit ignores it, and still retrieves tmpfs files as
memfds.

The target must be an empty regular file on a tmpfs mount, opened for
writing. Like the preserved file, it must be on a tmpfs mount, so that
memfds stay memfds and tmpfs files stay tmpfs files. Files on tmpfs
mounts always have exactly F_SEAL_SEAL, so there are no seals to
restore. The file position isn't restored either, since the open file
belongs to userspace.

A preserved file with unknown flags or seals, or a tmpfs file with
seals other than F_SEAL_SEAL, can't be restored, so fail its retrieve
permanently.

Fill the target like a write does: with write access to the superblock
and the inode lock held, calling file_modified() before and
fsnotify_modify() after. Add the folios while i_size is still 0, and set
i_size last. Reads, page faults and memfd_pin_folios() don't look past
i_size, so nothing sees the folios until the file is complete, and if
adding them fails, they can be removed again to leave the target empty.

Claim the target with liveupdate_claim_file() before modifying it, so
that a file that LUO already manages is rejected, e.g. a file that is
preserved in an outgoing session and whose size is frozen.

Like the other failures before the folios are restored, problems with
the argument and the target can be retried.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/mm/shmem_preservation.rst |  12 +-
 include/linux/kho/abi/shmem.h           |  22 +++-
 include/uapi/linux/liveupdate.h         |  37 ++++++
 kernel/liveupdate/Kconfig               |   6 +-
 mm/internal.h                           |   1 +
 mm/shmem.c                              |   9 ++
 mm/shmem_luo.c                          | 152 +++++++++++++++++++++---
 7 files changed, 210 insertions(+), 29 deletions(-)

diff --git a/Documentation/mm/shmem_preservation.rst b/Documentation/mm/shmem_preservation.rst
index e79bf8afaa9e..193c044ca637 100644
--- a/Documentation/mm/shmem_preservation.rst
+++ b/Documentation/mm/shmem_preservation.rst
@@ -1,14 +1,14 @@
 .. SPDX-License-Identifier: GPL-2.0-or-later
 
-==========================
-Memfd Preservation via LUO
-==========================
+====================================
+Memfd and Tmpfs Preservation via LUO
+====================================
 
 .. kernel-doc:: mm/shmem_luo.c
-   :doc: Memfd Preservation via LUO
+   :doc: Memfd and Tmpfs Preservation via LUO
 
-Memfd Preservation ABI
-======================
+Memfd and Tmpfs Preservation ABI
+================================
 
 .. kernel-doc:: include/linux/kho/abi/shmem.h
    :doc: shmem Live Update ABI
diff --git a/include/linux/kho/abi/shmem.h b/include/linux/kho/abi/shmem.h
index b61687e358a2..ec4f7594a7b6 100644
--- a/include/linux/kho/abi/shmem.h
+++ b/include/linux/kho/abi/shmem.h
@@ -18,8 +18,8 @@
  * DOC: shmem Live Update ABI
  *
  * The shmem file handler, which preserves memfds created without
- * ``MFD_HUGETLB``, uses the ABI defined below for preserving their state across
- * a kexec reboot using the LUO.
+ * ``MFD_HUGETLB`` and tmpfs files, uses the ABI defined below for preserving
+ * their state across a kexec reboot using the LUO.
  *
  * The state is serialized into a packed structure `struct shmem_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
@@ -69,12 +69,24 @@ struct shmem_luo_folio_ser {
 			     F_SEAL_EXEC)
 
 /**
- * struct shmem_luo_ser - Main serialization structure for a memfd.
+ * SHMEM_LUO_FLAG_TMPFS - The file was on a tmpfs mount.
+ *
+ * Set for files on a user-visible tmpfs mount. Such files can only be retrieved
+ * into a file on a tmpfs mount, and never as a memfd.
+ */
+#define SHMEM_LUO_FLAG_TMPFS		BIT(0)
+
+/* The set of flags this version supports. */
+#define SHMEM_LUO_ALL_FLAGS		SHMEM_LUO_FLAG_TMPFS
+
+/**
+ * struct shmem_luo_ser - Serialized state of a memfd or tmpfs file.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
- * @seals:     The seals present on the memfd. The seals are uABI so it is safe
+ * @seals:     The seals of the file. The seals are uABI so it is safe
  *             to directly use them in the ABI.
- * @flags:     Flags for the file. Unused flag bits must be set to 0.
+ * @flags:     Flags for the file (SHMEM_LUO_FLAG_*). Unused flag bits must be
+ *             set to 0.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct shmem_luo_folio_ser.
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 4ebbd578d2d5..8e86891d5a62 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -250,4 +250,41 @@ struct liveupdate_session_get_name {
 #define LIVEUPDATE_SESSION_GET_NAME					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
 
+/**
+ * struct liveupdate_shmem_retrieve_arg - Argument to retrieve a tmpfs file
+ * @size: Input; sizeof(struct liveupdate_shmem_retrieve_arg)
+ * @fd:   Input; The file to restore the preserved file into.
+ *
+ * Passed via &struct liveupdate_session_retrieve_fd.arg to retrieve a file that
+ * was preserved from a tmpfs mount. Such files can only be retrieved with this
+ * argument, and memfds can only be retrieved without it. Otherwise, the
+ * retrieve fails with -EINVAL.
+ *
+ * The kernel restores the contents and size of the preserved file into @fd,
+ * which must be an empty regular file on a tmpfs mount, opened for writing,
+ * and returns @fd in &struct liveupdate_session_retrieve_fd.fd, instead of a
+ * new file descriptor. Everything else about the file, e.g. its path, owner,
+ * mode and file status flags, is up to userspace, which creates the file. To
+ * keep anyone from accessing the file before it is complete, userspace can
+ * create it with O_TMPFILE and link it with linkat() after the retrieve. The
+ * blocks of the file are charged to the mount of @fd.
+ *
+ * LUO keeps a reference to the file until the session is finished. Since the
+ * file is open for writing, it can't be executed until then (execve() fails
+ * with -ETXTBSY).
+ *
+ * If @fd is not a file descriptor opened for writing, the retrieve fails with
+ * -EBADF. If it isn't an empty regular file on a tmpfs mount, the retrieve
+ * fails with -EINVAL, and if it is immutable, with -EPERM. If LUO already
+ * manages @fd, e.g. because it is preserved in an outgoing session, the
+ * retrieve fails with -EBUSY. These errors can be retried with another file.
+ * Errors while restoring the contents, e.g. -ENOMEM, or -ENOSPC if the
+ * contents don't fit on the mount, are permanent, and retrieving the token
+ * again returns the same error. @fd is left empty in that case.
+ */
+struct liveupdate_shmem_retrieve_arg {
+	__u32	size;
+	__s32	fd;
+};
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 79fbf4aa4842..98373af5fcd8 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -76,9 +76,9 @@ config LIVEUPDATE_SHMEM
 	depends on SHMEM
 	default LIVEUPDATE
 	help
-	  Enable live update support for shmem files, i.e. memfds created
-	  without MFD_HUGETLB. This allows preserving memfd-backed memory
-	  across kernel live updates.
+	  Enable live update support for shmem files: memfds created without
+	  MFD_HUGETLB and files on tmpfs mounts. This allows preserving their
+	  contents across kernel live updates.
 
 	  This can be used to back VM memory with memfds, allowing the guest
 	  memory to persist, or for other user workloads needing to preserve
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..6cacbf1f5c7d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1432,6 +1432,7 @@ int shmem_add_to_page_cache(struct folio *folio,
 			    pgoff_t index, void *expected, gfp_t gfp);
 int shmem_inode_acct_blocks(struct inode *inode, long pages);
 bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+bool shmem_inode_on_internal_mount(const struct inode *inode);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f..ad6beb328553 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -468,6 +468,15 @@ bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 	return first_swapped;
 }
 
+/*
+ * Whether @inode is on the internal shmem mount, which is used by
+ * shmem_file_setup() and thus by memfd_create().
+ */
+bool shmem_inode_on_internal_mount(const struct inode *inode)
+{
+	return inode->i_sb == shm_mnt->mnt_sb;
+}
+
 bool shmem_charge(struct inode *inode, long pages)
 {
 	struct address_space *mapping = inode->i_mapping;
diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index bdf90aac5820..7242664ee4ae 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -9,19 +9,20 @@
  */
 
 /**
- * DOC: Memfd Preservation via LUO
+ * DOC: Memfd and Tmpfs Preservation via LUO
  *
  * Overview
  * ========
  *
- * Memory file descriptors (memfd) can be preserved over a kexec using the Live
- * Update Orchestrator (LUO) file preservation. This allows userspace to
- * transfer its memory contents to the next kernel after a kexec.
+ * Memory file descriptors (memfd) and tmpfs files can be preserved over a kexec
+ * using the Live Update Orchestrator (LUO) file preservation. This allows
+ * userspace to transfer its memory contents to the next kernel after a kexec.
  *
  * In this document, "memfd" means a memfd created without ``MFD_HUGETLB``, i.e.
- * a shmem file on the kernel's internal shmem mount. Memfds created with
- * ``MFD_HUGETLB`` are hugetlbfs files, which this file handler doesn't
- * preserve. Preserving them fails with ``-ENOENT``.
+ * a shmem file on the kernel's internal shmem mount, and "tmpfs file" means a
+ * file on any other tmpfs mount. Memfds created with ``MFD_HUGETLB`` and other
+ * files on hugetlbfs are not shmem files, and this file handler doesn't
+ * preserve them. Preserving them fails with ``-ENOENT``.
  *
  * The preservation is not intended to be transparent. Only select properties of
  * the file are preserved. All others are reset to default. The preserved
@@ -37,13 +38,14 @@
  * file fail with ``-EPERM``. This applies to all users of the file.
  *
  * .. note::
- *    The LUO API is not stabilized yet, so the preserved properties of a memfd
- *    are also not stable and are subject to backwards incompatible changes.
+ *    The serialization format is not stabilized yet, so the preserved
+ *    properties of a memfd or tmpfs file are also not stable and are subject
+ *    to backwards incompatible changes.
  *
  * Preserved Properties
  * ====================
  *
- * The following properties of the memfd are preserved across kexec:
+ * The following properties of the file are preserved across kexec:
  *
  * File Contents
  *   All data stored in the file is preserved.
@@ -53,17 +55,21 @@
  *   allocating pages for them during preservation.
  *
  * File Position
- *   The current file position is preserved, allowing applications to continue
- *   reading/writing from their last position.
+ *   The current file position of a memfd is preserved, allowing applications to
+ *   continue reading/writing from their last position. The position of a tmpfs
+ *   file is not restored, since it is retrieved into a file that userspace
+ *   opened, as described in "Retrieving Tmpfs Files" below.
  *
  * File Status Flags
  *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
- *   is maintained.
+ *   is maintained. The file status flags of tmpfs files are not preserved.
+ *   They are those of the file that userspace retrieves them into.
  *
  * Seals
- *   File seals set on the memfd are preserved and re-applied on restore.
+ *   The seals of a memfd are preserved and re-applied on restore.
  *   Only seals known to this LUO version (see ``SHMEM_LUO_ALL_SEALS``) may
- *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
+ *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise. Files on
+ *   tmpfs mounts always have exactly ``F_SEAL_SEAL``.
  *
  * Non-Preserved Properties
  * ========================
@@ -76,13 +82,31 @@
  *   A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
  *   ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set
  *   again after restore via ``fcntl()``.
+ *
+ * Inode Attributes
+ *   The name, path, owner, mode, timestamps and extended attributes of the
+ *   file are not preserved.
+ *
+ * Retrieving Tmpfs Files
+ * ======================
+ *
+ * A tmpfs file is retrieved into an empty file that userspace creates on a
+ * tmpfs mount of its choice, and passes in ``struct
+ * liveupdate_shmem_retrieve_arg`` to ``LIVEUPDATE_SESSION_RETRIEVE_FD`` (see
+ * its documentation). The kernel only restores the contents and size of the
+ * preserved file. Userspace decides everything else about the file, e.g. its
+ * path, owner and mode. The blocks of the file are charged to that mount, so
+ * its size limit and quotas apply.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bits.h>
 #include <linux/err.h>
+#include <linux/fcntl.h>
 #include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/shmem.h>
@@ -337,6 +361,8 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 
 	ser->size = inode_size;
 	ser->seals = seals;
+	if (!shmem_inode_on_internal_mount(inode))
+		ser->flags |= SHMEM_LUO_FLAG_TMPFS;
 
 	err = shmem_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -577,6 +603,86 @@ static int shmem_luo_restore_folios(struct file *file,
 	return err;
 }
 
+/*
+ * Restore a preserved tmpfs file into the file that userspace passed in the
+ * retrieve argument.
+ */
+static int shmem_luo_retrieve_into(struct liveupdate_file_op_args *args,
+				   struct shmem_luo_ser *ser)
+{
+	const struct liveupdate_shmem_retrieve_arg *arg = args->arg;
+	struct inode *inode;
+	struct file *file;
+	int err;
+
+	if (!arg)
+		return -EINVAL;
+
+	CLASS(fd, target)(arg->fd);
+	if (fd_empty(target))
+		return -EBADF;
+
+	file = fd_file(target);
+	inode = file_inode(file);
+
+	/* Like the preserved file, the file must be on a tmpfs mount. */
+	if (!shmem_file(file) || shmem_inode_on_internal_mount(inode))
+		return -EINVAL;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	/* Fill the file like a write, which also takes these locks. */
+	file_start_write(file);
+	inode_lock(inode);
+
+	err = -EPERM;
+	if (IS_IMMUTABLE(inode))
+		goto unlock;
+
+	err = -EINVAL;
+	if (i_size_read(inode) || !mapping_empty(inode->i_mapping))
+		goto unlock;
+
+	err = liveupdate_claim_file(args, file);
+	if (err)
+		goto unlock;
+
+	err = file_modified(file);
+	if (err)
+		goto unclaim;
+
+	/* The preserved state is consumed from here on. */
+	args->retryable = false;
+
+	/*
+	 * The folios are past the end of the file until i_size is set below,
+	 * so reads, page faults and memfd_pin_folios() don't see them, and
+	 * they can be removed again if adding one fails.
+	 */
+	err = shmem_luo_restore_folios(file, ser);
+	if (err) {
+		shmem_truncate_range(inode, 0, (uoff_t)-1);
+		goto unclaim;
+	}
+
+	i_size_write(inode, ser->size);
+	inode_unlock(inode);
+	file_end_write(file);
+	fsnotify_modify(file);
+
+	args->file = get_file(file);
+	args->fd = arg->fd;
+	return 0;
+
+unclaim:
+	liveupdate_unclaim_file(args, file);
+unlock:
+	inode_unlock(inode);
+	file_end_write(file);
+	return err;
+}
+
 static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct shmem_luo_ser *ser;
@@ -587,6 +693,14 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	/* Make sure the file only has flags this version supports. */
+	if (ser->flags & ~SHMEM_LUO_ALL_FLAGS)
+		return -EOPNOTSUPP;
+
+	/* Files on tmpfs mounts can only have F_SEAL_SEAL. */
+	if ((ser->flags & SHMEM_LUO_FLAG_TMPFS) && ser->seals != F_SEAL_SEAL)
+		return -EINVAL;
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
 		return -EOPNOTSUPP;
@@ -599,6 +713,13 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	 */
 	args->retryable = true;
 
+	if (ser->flags & SHMEM_LUO_FLAG_TMPFS)
+		return shmem_luo_retrieve_into(args, ser);
+
+	/* Memfds are restored into a new memfd, so they take no argument. */
+	if (args->arg)
+		return -EINVAL;
+
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
 	 * later.
@@ -654,6 +775,7 @@ static const struct liveupdate_file_ops shmem_luo_file_ops = {
 	.unpreserve = shmem_luo_unpreserve,
 	.can_preserve = shmem_luo_can_preserve,
 	.get_id = shmem_luo_get_id,
+	.rarg = LIVEUPDATE_ARG(struct liveupdate_shmem_retrieve_arg, fd),
 	.owner = THIS_MODULE,
 };
 
-- 
2.56.0.542.g3ef89b7020-goog


