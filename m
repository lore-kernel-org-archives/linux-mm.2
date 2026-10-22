Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB98606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DxGXy5OT
Received: by kanga.kvack.org (Postfix)
	id 5294B6B0A18; Thu, 22 Oct 2026 18:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5072E6B0A1A; Thu, 22 Oct 2026 18:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A16C6B0A1B; Thu, 22 Oct 2026 18:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E758D6B0A18
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:51:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39925402C7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:51:06 +0000 (UTC)
X-FDA: 85351759332.13.73A2895
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 751E44000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:51:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DxGXy5OT;
	spf=pass (imf11.hostedemail.com: domain of 3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709464;
	b=yEdNvUpkir6WIQxY+ucgYf2wMnrLkCxfoL1EF8CZFHgf03rUa/Qk1aX/Xnyh+HEqtz+J4/
	3epkFwjEA6ZVIcmfBeGPlOu3G5E9Y5bSvjJKVxXDEzPcu9nhGUHc2QXdppWtYUF9HWCuSy
	qWtLxHxcf8eXxr8uHtSaZU8DYiv4QHo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DxGXy5OT;
	spf=pass (imf11.hostedemail.com: domain of 3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO5t0V2jsj+CxrhWEBQkHtrORwRHcZ0GIJSmut4DRF4=;
	b=cRajNnMJ3RfzWiESXTN/RFGSy0r+MuS+SkQ+4nWXlyLjppta0U0QC1owwCpTIO7AcHo3T9
	jziPNz0lF04D3VJ4ns8RrPe8xN/uXU9QQ7nGRjc6e7isdEtTFUv3fSJGqisgmokTEiOF3l
	dGpnLuMPyhezSqyeNM7iKinP3aDu37k=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3adbc9a47fbso262987a91.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709463; x=1793314263; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DO5t0V2jsj+CxrhWEBQkHtrORwRHcZ0GIJSmut4DRF4=;
        b=DxGXy5OTFo61cFIetgGwWwOK4tEVhaRUGGGjUMwkTbKuGDS1eiqz9+lUWBvrQKik5E
         G+bSU9zIPrnCa7tBON3f3GGg6BAZDHLAmdfwpaHrIOimwz28AtjIvZ807X9mwPG38eB3
         6sCvS6QZc9B8kj2dJrGL+TC/n2q8l7i5SCKmAyz13qTTkTKJp2Hm6kMpTBwhwhwYQKIL
         bcWc+d2E5W+GjbKuAIbwvL6pvw8CT/WTqQnABCPk6KhE7rf8LTmiYzRJsezN8NxlnCmd
         s2q94EqE1HebXH3qb5BhmQHph9cQ5xVGtY+ELnLdUNbnNcHOcMsB1enDF4v9G88f8dRa
         As8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709463; x=1793314263;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DO5t0V2jsj+CxrhWEBQkHtrORwRHcZ0GIJSmut4DRF4=;
        b=s0SVhCNvoGxvtVOlw8HYnRo2mvazrB/rF1Bw4bea3+amwPPhWhxlpZTwD2i9CrI9/y
         CsZspxg+9z7gQRNaL/0YsyrLuuVZ535WcV3Ks+WyaT7L93ke6OHbYmQi57oCbW4MsD7V
         15vh4Qff0NV+1WnYzMnUOkNFQyY4jr1NmCWQrX31WZKDWGDs5Z5350zs15uNdFY2egN7
         fiu9Yr3rn20zZABhiD04/M6q8+7/gzqeglCWCmv1Qu8UNE82JHZVs6QoExF031AjmliF
         DasIpK73hkoP27Ki5W35VADvtK3L6R5JZnYsUHCjI8i/roRpiNJfB8pnvIHydKcwfDjH
         MJ+w==
X-Forwarded-Encrypted: i=1; AKwUvBzli2V0U70/07lEagPiQlRyfz24isQKhDDJWelGV5+/o6aNDwZmKEFlOh0BwPIfNvPkZycyfVaB7w==@kvack.org
X-Gm-Message-State: AFq9FYJow/ATg0mcMI9Zcmdh7mURwByWp26UxbKS56vSLB4G0Ck+IKD8
	NWWvZuK8fauAHDX79dB+SjZkYAu+nYUUTZ30eJzrVE6dGU2gTxylUZgOwlY8rlTCJzXfbrl8HWW
	phStj31XsJjMJ6A==
X-Received: from pgvz23.prod.google.com ([2002:a65:6657:0:b0:cc7:e02e:9f0d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5868:b0:3ab:e588:c295 with SMTP id 98e67ed59e1d1-3adce779f51mr204030a91.42.1792709443849;
 Thu, 22 Oct 2026 15:50:43 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:32 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-8-dmatlack@google.com>
Subject: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 751E44000B
X-Stat-Signature: b4refsuchk6qgcdu95hidxayboj8xbdo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792709464-924578
X-HE-Meta: U2FsdGVkX19mQbOzcyaSA+Ee1mrSkv6npXdAYgdJM/f45J0EKo/hIKqgLLKZngnkgYzX5SpkTO6qnXU1roIUm3VDRygXhx+Nswy9ew8P3yFKWJCLadYIOxjoKyEUg7eyfZuyBx009SFB2x4npgR56Gx9hOsqkEiQJ+yT+dptW1pyjW3nPJfnjBjlqORhr3G+2PDvpBwlHqiZMS9RXFQ2LO2QQYmykeG5mZCko/ehhDOZRAPr84CBRHSlOwgMaF9HkORt0QlwCj4imaDUXGBg/VAX/sYoZpL8blTpAqSQRrzvTShAKAa7YE02l3dJgFXU/xiH8YKS5WKpKG+SHEzwQlifchCkWYAxznmfkLbjsfF4zYfU8FvaE07DkHts8auRRoWedIF4yqTIgom0fhE4u/70plVGrKvPKMr0437F4++q2Jp0MpCY7+SDMDVD4DJRof53ucn+2G305xOuZ1oU+cLtZPtCzwJ0SqZu8jm5wGUJKUcNr2Qu0qKGd2dGtimA/6LrhmzGIAlcpahBYq5C394MN/i65umO08eV6NGXA9Fo4FSqH0eKNG6EWwiORgyrDdq+lSUpKG3RkrBJC9w9tzhpdLWUySGm8vDfS81pd0oW3OEybRnBGxMEp7aH3QHPN0oYf3jeoAzMVELF0+nA13X3DZ1cfQqG1syXL1xQUmFzLUmNLKe6ux9tguw7Q4YRwCWlQQw4mtQ2Sht8zXhBZUgM9rN7kNPF1fFfrkbKEvxQ6P6gnQnNXM7lIoHXCW1URD7kgslp3y7qmkNvNo0Drt4K9ACMTYaDC+/isRvKO2uy2/PTBU/K51yG0f7OT5mqXuElZ8VfH94dLBr44ClXuwPHs/rlM6DK8ll4zXiEhZcco0XHWK1sW2cIbYgrQyUxGDWk5z+DHu6WEZkbAF03UfNwbwSKYxpZ7rpNpB+y5evSYa0tq/Wh/7gNlTRrqvTD7/kWmnbGBBds/bNG3pV
 A7mNjBxz
 sWokWI4Ug1bTtRl99b6OsQ0P1hDifcj5uEYCStSZZmm+tKXxqGQO5zSi+caMJKmOlRkhMC40ywZAtEcxt8BaTiNWq+h6SXe7DbAjkrAvCuzRWXTGeFs5mLd3Jkk04HtGBtAgVOmR83ix38nQJucAFCPV4Nc1LAHLt1uUIutqybuBr1swPZbESxeoOcH05jUm0b3fHz/X9joHNQsIvAj7d6MNbIznvusurvOAsMcRT2R5GVs2Jas0tywrEwcWTXLmE+BxwDAp1DuHVwKUmqvX49t4W8KxfE6yNe8hyviZN7v1EP8lukP+9JDwObX5e0m150BqbwZp9isYjxEYbdEmOaIwH6QVDbNF4HAfwF2Ii3L3/s/K5gq8HTR7Prk4Dy0aOKDp+CHh/q+OVL7fX92I54QEwffbk7PIVzGx38QtbgbQzpdN0n8/IaAPkLH6tUJyJvnUJ0X2RWRdVKUgYLTFI5oX+lMayibfTouLos12p5Ryxc5wB9QedygztUq1sFnzPPakjLQ3s7lI9LOccuybzrPDDsP3mjOENz1h0H1nuPUxsGqaprVMMTAhX0mDllC3Sle/RiV/4qQBv0jP5CTPc4qkdIUASiUXNbZViqpK/V6PWfoG6W0xH7koaTvgNaQ8oWXIiErTlUSYWuD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Retrieve files that were preserved from a tmpfs mount onto a tmpfs mount
chosen by userspace, instead of as memfds on the internal tmpfs mount.
Record which mount a file was on with a new SHMEM_LUO_FLAG_TMPFS flag in
struct shmem_luo_ser, based on the superblock of the file. shmem_luo
already accepts unlinked tmpfs files, such as files created with
O_TMPFILE, and a following commit also accepts linked ones.

The mount a tmpfs file was on doesn't exist in the new kernel, and
userspace may want to put the file elsewhere anyway. So add struct
liveupdate_shmem_retrieve_arg, which userspace passes as the retrieve
argument of LIVEUPDATE_SESSION_RETRIEVE_FD. It is modeled on open(): The
kernel creates a new file as if by openat(dirfd, ".", O_TMPFILE | flags,
mode), so the file gets the owner, permission checks and security labels
of any new file in that directory, and is charged to that mount. The
kernel then fills the file with the preserved contents, size, position
and seals before returning it, so nothing else can access the file
before it is complete. Userspace links the file at the path it wants
with linkat(), or passes O_EXCL to keep it unlinked. Neither the path
nor any other inode attribute of the file is part of the preserved
state, which keeps them out of the KHO ABI.

Pass the flags from userspace to file_open_root(), so that the VFS
checks them like for open(). file_open_root() silently ignores unknown
flags and mode bits, so reject those like openat2() does. Also reject
O_PATH, with which file_open_root() would ignore O_TMPFILE and open the
directory.

Keep the type of the file: memfds can only be retrieved as memfds, and
files on tmpfs mounts only onto tmpfs mounts, so that e.g. a file
can't be moved off the mount whose size limit and quotas it was subject
to. Passing the argument when retrieving a memfd, or not passing it when
retrieving a file from a tmpfs mount, fails with -EINVAL. Unlinked tmpfs
files were retrieved as memfds until now, but nothing relies on that, as
the LUO uAPI is not stable yet.

Like the other failures before the folios are restored, problems with
the argument and with creating the file can be retried.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/mm/shmem_preservation.rst |   8 +-
 include/linux/kho/abi/shmem.h           |  21 ++-
 include/uapi/linux/liveupdate.h         |  35 +++++
 kernel/liveupdate/Kconfig               |   6 +-
 mm/internal.h                           |   1 +
 mm/shmem.c                              |   9 ++
 mm/shmem_luo.c                          | 180 ++++++++++++++++++++----
 7 files changed, 221 insertions(+), 39 deletions(-)

diff --git a/Documentation/mm/shmem_preservation.rst b/Documentation/mm/shmem_preservation.rst
index e79bf8afaa9e..030a8f18680c 100644
--- a/Documentation/mm/shmem_preservation.rst
+++ b/Documentation/mm/shmem_preservation.rst
@@ -1,11 +1,11 @@
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
 
 Memfd Preservation ABI
 ======================
diff --git a/include/linux/kho/abi/shmem.h b/include/linux/kho/abi/shmem.h
index b61687e358a2..88ef7d49b5f3 100644
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
@@ -69,12 +69,25 @@ struct shmem_luo_folio_ser {
 			     F_SEAL_EXEC)
 
 /**
- * struct shmem_luo_ser - Main serialization structure for a memfd.
+ * SHMEM_LUO_FLAG_TMPFS - The file was on a tmpfs mount.
+ *
+ * Set for files that were not on the internal shmem mount that memfds are
+ * created on. Such a file is retrieved onto a tmpfs mount chosen by userspace,
+ * instead of as a memfd.
+ */
+#define SHMEM_LUO_FLAG_TMPFS		BIT(0)
+
+/* The set of flags this version supports. */
+#define SHMEM_LUO_ALL_FLAGS		SHMEM_LUO_FLAG_TMPFS
+
+/**
+ * struct shmem_luo_ser - Main serialization structure for a memfd or tmpfs file.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
  *             to directly use them in the ABI.
- * @flags:     Flags for the file. Unused flag bits must be set to 0.
+ * @flags:     Flags for the file (SHMEM_LUO_FLAG_*). Unused flag bits must be
+ *             set to 0.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct shmem_luo_folio_ser.
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 953ffe0823be..a9dcc4fcc87b 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -247,4 +247,39 @@ struct liveupdate_session_get_name {
 #define LIVEUPDATE_SESSION_GET_NAME					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
 
+/**
+ * struct liveupdate_shmem_retrieve_arg - Argument to retrieve a tmpfs file
+ * @size:  Input; sizeof(struct liveupdate_shmem_retrieve_arg)
+ * @dirfd: Input; A file descriptor for a directory on the tmpfs mount to create
+ *         the file on.
+ * @flags: Input; The flags of the file, like the flags argument of open(),
+ *         except for O_TMPFILE, which is implied, and O_PATH, which is not
+ *         allowed.
+ * @mode:  Input; The mode of the file, like the mode argument of open().
+ *
+ * Passed via &struct liveupdate_session_retrieve_fd.arg to retrieve a file that
+ * was preserved from a tmpfs mount. Such files can only be retrieved with this
+ * argument, and memfds, i.e. files that were preserved from the kernel's
+ * internal shmem mount, can only be retrieved without it. Otherwise, the
+ * retrieve fails with -EINVAL.
+ *
+ * The kernel creates a new file as if by openat(@dirfd, ".", O_TMPFILE |
+ * @flags, @mode), fills it with the preserved contents, and returns it in
+ * &struct liveupdate_session_retrieve_fd.fd. Like any O_TMPFILE file, the file
+ * is not linked into the filesystem. Userspace can link it with linkat(),
+ * unless @flags contains O_EXCL.
+ *
+ * If @flags contains unknown flags or O_PATH, if @mode contains unknown mode
+ * bits, or if @dirfd is not on a tmpfs mount, the retrieve fails with -EINVAL.
+ * If the file can't be created, the retrieve fails with the same errors as
+ * open(). A retrieve that fails before the preserved contents are restored can
+ * be retried.
+ */
+struct liveupdate_shmem_retrieve_arg {
+	__u32		size;
+	__s32		dirfd;
+	__aligned_u64	flags;
+	__aligned_u64	mode;
+};
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 9a1c49e2e0c4..61d01f5a336e 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -70,14 +70,14 @@ config LIVEUPDATE
 	  If unsure, say N.
 
 config LIVEUPDATE_SHMEM
-	bool "Live update support for memfd"
+	bool "Live update support for memfd and tmpfs files"
 	depends on LIVEUPDATE
 	depends on MEMFD_CREATE
 	depends on SHMEM
 	default LIVEUPDATE
 	help
-	  Enable live update support for memfd regions. This allows preserving
-	  memfd-backed memory across kernel live updates.
+	  Enable live update support for memfds and tmpfs files. This allows
+	  preserving their contents across kernel live updates.
 
 	  This can be used to back VM memory with memfds, allowing the guest
 	  memory to persist, or for other user workloads needing to preserve
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..630ae0297dd5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,7 @@ int shmem_add_to_page_cache(struct folio *folio,
 			    pgoff_t index, void *expected, gfp_t gfp);
 int shmem_inode_acct_blocks(struct inode *inode, long pages);
 bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+bool shmem_inode_on_internal_mount(const struct inode *inode);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..fe2be9300ae7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5860,6 +5860,15 @@ struct file *shmem_kernel_file_setup(const char *name, loff_t size,
 }
 EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
 
+/*
+ * Whether @inode is on the internal shmem mount, which is used by
+ * shmem_file_setup() and thus by memfd_create().
+ */
+bool shmem_inode_on_internal_mount(const struct inode *inode)
+{
+	return inode->i_sb == shm_mnt->mnt_sb;
+}
+
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps)
diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index bcac1bbb3db3..ecbeb37d33a8 100644
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
  * Here, a memfd is a memfd created without ``MFD_HUGETLB``, which is a shmem
- * file on the kernel's internal shmem mount. Memfds created with
- * ``MFD_HUGETLB`` are hugetlbfs files, which this file handler doesn't
- * preserve. Preserving them fails with ``-ENOENT``.
+ * file on the kernel's internal shmem mount, and a tmpfs file is a file on any
+ * other tmpfs mount. Memfds created with ``MFD_HUGETLB`` and other files on
+ * hugetlbfs are not shmem files, and this file handler doesn't preserve them.
+ * Preserving them fails with ``-ENOENT``.
  *
  * The preservation is not intended to be transparent. Only select properties of
  * the file are preserved. All others are reset to default. The preserved
@@ -29,12 +30,13 @@
  *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
- *    are also not stable and are subject to backwards incompatible changes.
+ *    or tmpfs file are also not stable and are subject to backwards
+ *    incompatible changes.
  *
  * Preserved Properties
  * ====================
  *
- * The following properties of the memfd are preserved across kexec:
+ * The following properties of the file are preserved across kexec:
  *
  * File Contents
  *   All data stored in the file is preserved.
@@ -49,10 +51,12 @@
  *
  * File Status Flags
  *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
- *   is maintained.
+ *   is maintained. The file status flags of tmpfs files are not preserved.
+ *   Userspace chooses the flags when retrieving them, as described in
+ *   "Retrieving Tmpfs Files" below.
  *
  * Seals
- *   File seals set on the memfd are preserved and re-applied on restore.
+ *   The seals of the file are preserved and re-applied on restore.
  *   Only seals known to this LUO version (see ``SHMEM_LUO_ALL_SEALS``) may
  *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
  *
@@ -67,12 +71,50 @@
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
+ * A tmpfs file can be retrieved onto any tmpfs mount that userspace chooses.
+ * The mount that the file was on doesn't exist in the new kernel, and userspace
+ * may want to put the file elsewhere anyway.
+ *
+ * To retrieve a tmpfs file, userspace passes a
+ * ``struct liveupdate_shmem_retrieve_arg`` to
+ * ``LIVEUPDATE_SESSION_RETRIEVE_FD``. The argument specifies a directory on the
+ * target mount, and the flags and mode of the new file. The kernel creates the
+ * file as if by ``openat(dirfd, ".", O_TMPFILE | flags, mode)``, so the file
+ * gets the same flags, owner, permission checks and security labels as any
+ * other new file in that directory. The kernel then fills the file with the
+ * preserved contents, size, position and seals before it returns the file, so
+ * nothing else can access the file before it is complete.
+ *
+ * Like any ``O_TMPFILE`` file, the new file is not linked into the filesystem.
+ * Userspace can link it at the path it wants with ``linkat()``, unless it asked
+ * for ``O_EXCL``. Like with ``open()``, the file must be opened for writing.
+ * LUO keeps the file open until the session is finished, so a retrieved binary
+ * can't be executed until then.
+ *
+ * The blocks of the file are charged to the target mount, so the size limit
+ * and quotas of the mount apply. If the file doesn't fit, the retrieve fails
+ * permanently, since the preserved contents have already been restored at that
+ * point. If the argument is invalid or the file can't be created, the retrieve
+ * fails before the preserved contents are restored, so it can be retried.
+ *
+ * memfds can only be retrieved as memfds, and files on tmpfs mounts can only be
+ * retrieved onto tmpfs mounts. Retrieving a memfd with the argument, or a tmpfs
+ * file without it, fails with ``-EINVAL``.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bits.h>
 #include <linux/err.h>
+#include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
@@ -81,6 +123,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/memfd.h>
+#include <uapi/linux/magic.h>
 #include <uapi/linux/memfd.h>
 
 #include "internal.h"
@@ -299,6 +342,8 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 
 	ser->size = inode_size;
 	ser->seals = seals;
+	if (!shmem_inode_on_internal_mount(inode))
+		ser->flags |= SHMEM_LUO_FLAG_TMPFS;
 
 	err = shmem_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -515,6 +560,92 @@ static int shmem_luo_retrieve_folios(struct file *file,
 	return err;
 }
 
+/* Create the memfd to retrieve a file from the internal shmem mount into. */
+static struct file *shmem_luo_create_memfd(const struct liveupdate_shmem_retrieve_arg *arg,
+					   unsigned int seals)
+{
+	struct file *file;
+	int err;
+
+	/* memfds are retrieved as memfds, so there is nothing to choose. */
+	if (arg)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * The seals are preserved. Allow sealing here so they can be added
+	 * later.
+	 */
+	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
+	if (IS_ERR(file)) {
+		pr_err("failed to setup file: %pe\n", file);
+		return file;
+	}
+
+	err = memfd_add_seals(file, seals);
+	if (err) {
+		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
+		fput(file);
+		return ERR_PTR(err);
+	}
+
+	return file;
+}
+
+/*
+ * Create the file to retrieve a file from a tmpfs mount into, on the tmpfs
+ * mount chosen by userspace.
+ */
+static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_retrieve_arg *arg,
+						unsigned int seals)
+{
+	struct file *file;
+	int err;
+
+	if (!arg)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Like openat2(), reject unknown flags and mode bits instead of
+	 * ignoring them. Also reject O_PATH, which would make file_open_root()
+	 * ignore O_TMPFILE and open the directory instead of creating a file.
+	 */
+	if (arg->flags & ~(u64)VALID_OPEN_FLAGS || arg->flags & O_PATH ||
+	    arg->mode & ~(u64)S_IALLUGO)
+		return ERR_PTR(-EINVAL);
+
+	CLASS(fd_raw, dir)(arg->dirfd);
+	if (fd_empty(dir))
+		return ERR_PTR(-EBADF);
+
+	if (fd_file(dir)->f_path.dentry->d_sb->s_magic != TMPFS_MAGIC)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Create the file like open(O_TMPFILE) does, so that it gets the same
+	 * flag checks, permission checks, owner and security labels.
+	 */
+	file = file_open_root(&fd_file(dir)->f_path, ".",
+			      O_TMPFILE | O_LARGEFILE | arg->flags, arg->mode);
+	if (IS_ERR(file))
+		return file;
+
+	/*
+	 * Nothing else can access the new file yet, so set the preserved seals
+	 * directly. memfd_add_seals() refuses to, since files on tmpfs mounts
+	 * are created with F_SEAL_SEAL.
+	 */
+	if (seals & F_SEAL_WRITE) {
+		err = mapping_deny_writable(file->f_mapping);
+		if (err) {
+			fput(file);
+			return ERR_PTR(err);
+		}
+	}
+	SHMEM_I(file_inode(file))->seals = seals;
+
+	return file;
+}
+
 static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct shmem_luo_folio_ser *folios_ser;
@@ -533,25 +664,18 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	 */
 	args->retryable = true;
 
-	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
+	/* Make sure the file only has seals and flags this version supports. */
+	if ((ser->seals & ~SHMEM_LUO_ALL_SEALS) ||
+	    (ser->flags & ~SHMEM_LUO_ALL_FLAGS))
 		return -EOPNOTSUPP;
 
-	/*
-	 * The seals are preserved. Allow sealing here so they can be added
-	 * later.
-	 */
-	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
-	if (IS_ERR(file)) {
-		pr_err("failed to setup file: %pe\n", file);
+	/* Retrieve memfds as memfds, and other files onto a tmpfs mount. */
+	if (ser->flags & SHMEM_LUO_FLAG_TMPFS)
+		file = shmem_luo_create_tmpfs_file(args->arg, ser->seals);
+	else
+		file = shmem_luo_create_memfd(args->arg, ser->seals);
+	if (IS_ERR(file))
 		return PTR_ERR(file);
-	}
-
-	err = memfd_add_seals(file, ser->seals);
-	if (err) {
-		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
-		goto put_file;
-	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
@@ -579,7 +703,6 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 
 free_ser:
 	kho_restore_free(ser);
-put_file:
 	fput(file);
 	return err;
 }
@@ -605,6 +728,7 @@ static const struct liveupdate_file_ops shmem_luo_file_ops = {
 	.unpreserve = shmem_luo_unpreserve,
 	.can_preserve = shmem_luo_can_preserve,
 	.get_id = shmem_luo_get_id,
+	.rarg = LIVEUPDATE_ARG(struct liveupdate_shmem_retrieve_arg, mode),
 	.owner = THIS_MODULE,
 };
 
-- 
2.56.0.257.gf7497c7d27-goog


