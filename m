Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD9F606A322
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YmVt5hF5
Received: by kanga.kvack.org (Postfix)
	id 414E76B05BE; Mon, 23 Nov 2026 18:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7F06B05BF; Mon, 23 Nov 2026 18:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE4D6B05C0; Mon, 23 Nov 2026 18:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CECCE6B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 347F91A093D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:47 +0000 (UTC)
X-FDA: 85468003614.27.61EB382
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7106A180007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YmVt5hF5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3wM4EawgKCM8y7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3wM4EawgKCM8y7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477185;
	b=Rc3YqNg1upJNj0dKEihg5xRfYejtna1peux024Sg56eiisCy3TiOD1x5ObIE7izdQuRv8e
	OlQzGZNDT15z2znnM5p/+2hDyUWwKTZWhQdj6HaxGlnysJN4H9NaSwxv9IQCllJ9p5L+cB
	RavtGoRLdYg2un4sjKfPDnnSiDNkcBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ytNBCR2jYlgllUMHRB50Dw2nGY412Q9kFnUKp8ufOE=;
	b=X5fPIbvVgb67LqUlgOy/RFxQoAJw2AJIjwROp1pC42KvwQ65V7kKRHXJLuLUK99DfyVx3b
	V8slyyT3zoLn2on0iltpeh9Bt5qpB+iXm9v9gs/idYwoqjtdjMNV/GAnG5dcD24Y+RCwRO
	99AV0nNPXYAVm4oqSSr/brTPSC68B4k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YmVt5hF5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3wM4EawgKCM8y7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3wM4EawgKCM8y7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e778acdbc6so4876435b6e.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477184; x=1796081984; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ytNBCR2jYlgllUMHRB50Dw2nGY412Q9kFnUKp8ufOE=;
        b=YmVt5hF5VClE3NsWVSi7IKeS4j9JV8Zblk7eckEIQFiBjT+cFWFyUTUJJqwMaxHUBk
         1KDVQn0DFfdH/U73MJAqysUWqOgTieuYdpgVxIVBE1I9HYgg9bTl+4CYU6FvQ/zIYaWK
         LPa0p5kNIxjKXrOBIP30Pllqk/h5ip2cKaGldLNqYGPlyBXYXai0I3+z82XdpFSN2yBb
         iYVz6/o7nOOARAcUwTB8s0JCEX4qJDah0ZnVcqlWcfhT+Ai+LFa5O3taHLiLitL+7Lvu
         bGQ1rnVsmnRI7HHmasZfII9j72k6GkrTbhft389QWHDPm6gSh5nQCSf5Bx2PO0wY9q1b
         sZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477184; x=1796081984;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ytNBCR2jYlgllUMHRB50Dw2nGY412Q9kFnUKp8ufOE=;
        b=NgFHORyJrMFOJsHHBAqiI5oxUoxKEj5Ecy9fhuWg666fHWv3HfdN7B9Vu8VWvw4qS9
         5UXlkF86dxzUQqloipMgih+AKZ4EKZ/FMtvIwR16eJIe/AFVzNZx0d1GAJPZDvccFOBo
         c1ruSguJYDPowH3bNlVSOxibdLrEM2/Ol3OLTR0Z9HhvpT54w2uAw3tHoHxDkQDUUu+x
         FZ3b938Y6NACascaUl4qmIa6EexXvTNmb6cz8TiHvG5EIsypFdYk2LAqCYCxalD9zfOM
         Oy5jAzjID/NpJhoQYSGNf1H5yy7JiBVk+DQlmJyz46QvyymcnYarCQe4r3tfjA/F/0TT
         qsqQ==
X-Forwarded-Encrypted: i=1; AL+hErEdUC5GofrwhI8OpnkZuWCzbINV9SjA8j9ihPj76gzpbi0RpIHQ3yc9FhMrbXBHAdH7mtv8V8MetA==@kvack.org
X-Gm-Message-State: APuU4Z+10Ut0s2JgPWmctEb3QGYuo/W2kK+L37jFVijfh/PlQF0fsGAO
	A3/GCAzInhXPxKIkqO3N7kBQ6LfoN5bVUj3HEhcCMf+Mv7Cl90WZFCnACTquqj12zWbInlPjSaE
	KTzGcsvmD7rSGkQ==
X-Received: from ila23-n1.prod.google.com ([2002:a05:6e02:5217:10b0:542:fc1f:755f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:13d3:b0:531:7f68:842e with SMTP id 5614622812f47-57a06d1a865mr14280931b6e.8.1795477184113;
 Mon, 23 Nov 2026 15:39:44 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:16 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-12-dmatlack@google.com>
Subject: [PATCH v5 11/18] mm/shmem_luo: Retrieve tmpfs files into a file
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
X-Rspamd-Queue-Id: 7106A180007
X-Stat-Signature: m163u1d4byishpqeudzo94oi11fm715u
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795477185-132548
X-HE-Meta: U2FsdGVkX196M2UDMh6xx72E1N6eNnUEv6cNy7DnZM6L56jjV20mwTIvDjZT0zQq5te8sU3V3yZwJjOjHmCZzgJeIg3nkB6P7c56z/m74XbPMD4qrsm03GupjZSjkXhEAtJ3IN5ihKAShAbsf/nvtZ90opcw3uvOflp5wa60Jxdri+9+1we3+klr96wQqWSNJUhI1d2eLl/1bEqxbLHY6zodj01MPh9hwH7lXpqkGfwOajrxSd2Ab0+0hu3BmJ75ZecvWbmQZdwb4A3Z5Q5kZDWIyZqMXy8j0evBaInDzEY0CWz9YZZ68iQHZquAbQsPs6RTalmtEaoJjavJySIK4jqhVrTDc8jEqDJZQwZtR3EvbLoDgZQNnbd7KVeCflgYT5BLxvoM+5C7ogCUXpcdOsa89Aitpq7Yop5pHRdBNKh9IaEvZTr0SXIKEwPg8wTbtgz9+m/fDEOepdV7FiBuhc3QyQC9k6VPw7LGXerKNqyVsHt1q1ukISYp1SdqIKJ9v19vmY7Gau/6/NV9UU+WD+ayMOjAS7GW8ccAUSjfNNEKVX/k6SS4fjtkb6rBNFLnbvBaAoK7j12txi+AfJHa5fa3a/Q+hvkPGovJ4xmf+qDZQvup1xGJFqMyYkyHApe51JmEh1XYi7sny+6D/1mI/a6M0dcOFZE4TJbVULibLespl9yzKMI4FkUh71DxJr2xsCyJFi6rBbg85uvOe4pmid+PgegXy8hrKjEVlmyL3ojOpk5+MTwuw43ePUw5jW9wz8aVAclsChLk77rCjLb2/sxPANB/N0kN5wQoJL16T5i2Gi0gRIxXaYm6fRJA7cgZN+ItSmUsNDiaSftIt1c/hswgt4jnAWmhdGN0ChkIpgG4nuULR/T6jiKoiayQskkierVqH+hSVpmaaIbGGpAeZXTTpdV8VfgZ5nWryw89K9jykXNJqBWDbm7OqGWu7ptyhfirOQpitz8QWeLNUV9
 qs7EpB6B
 jdtV1xIxpCQgUxWvS7oMpl4VjjE6c9RLv5Uvjp41TwQDlPGWGtYVXM/5D8QkqlTVzNH0EQVigwxI7ytnw26SYQbQxZeNzV8UA/+sfoWMPMEWv5p7cfYTmyT/rx6APbm3jEnlHQfD2OAWD2eHHq/050Cgg8FDqrbbOU8afg9flIm1gmFlKVmdABzFOSFb3Bfe7Ao05uggCZM2AAQ5rh1KGNkMc1pYo3xZ2X4NpCb1kTTDD2g5n7Sa7yG53baxbNGAmUWikECKT53KiGTocsKNKa3gd2VA2sC4Bx15DhclEUlnv7cnLWhA+Riiy/y8aVmXxIhBXMps5tAIG5fCnUvuAVB2XNZrTuXN4pxwp1/mRCTc/cosS+cjYCTBDh0xvmK9ZeXotctwLb/nCiroa+0YlIxWUWuluU+y1geq2iOZIBdc050OX5WQDoo0sUTexTPgZ7vh2bZ7hDtG3gYqyu4B1jQU8r4tunqGxbLiU088i8xxAlyfoqKJRAyH2Qx6XJ1VLWGc6iYpRFOSkz5LaWtXVPNyHZyYAn2j9Msy/uEp2zoBxTj06sFJPUIGA2VmoZ7rFgMZtNufDDSvecptU8JMiGIPOD9wLhVZcZvJQOCpsnxQ7cXWNhxxS5rumKMl1VEJJS0soJONm3CVG2N9kRfdGUpvVT/GjL8pVcY3OPMkFQBXo+Y8bo5u2MqNLmvAw98oBPvy3DQcBWPWsm/8BJNKUo1Wk6LJlt7PvX51qD7u6Sh9T0El+EN8XzpV3APMLTGHgmpTPhggzPVC6b1YXF/4+hgIWWlu7IX/j5trSaav74fJD0jwVtawSaso+/U3TYLS1Not+0HuZMuULdFfwKWZrt+T8luyWymUYlkPp9Bz84fJWVVgDxszHcvsHYL+yPC0MpYQM
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
it wants. Like for any other retrieve, LIVEUPDATE_SESSION_RETRIEVE_FD
returns a new file descriptor for the file.

This also fixes a bug: shmem_luo_can_preserve() is meant to only accept
memfds, but it only checks that the file has no links, so it accepts
unlinked tmpfs files by mistake. They are then retrieved as memfds,
which moves them off their mount and out from under the size limit and
quotas of the mount. Retrieving such a file without an argument now
fails with -EINVAL if it was preserved by a kernel with this commit. The
new flag uses an existing field that is zero otherwise, so an older
kernel that this kernel live updates to ignores it, and still retrieves
tmpfs files as memfds.

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
i_size, so they don't see the folios until the file is complete, and if
adding them fails, the folios can be removed again to leave the target
empty. Like fallocate(), raise fallocend while adding the folios, so
that splitting a large folio doesn't drop its pages past i_size.

Userspace must not use the target until the retrieve returns. For
example, MADV_COLLAPSE on a mapping of the target could change its page
cache while the folios are added, and make the restore fail. Document
that, instead of trying to reject every such use. Userspace that creates
the target with O_TMPFILE controls who can access it.

Claim the target with liveupdate_claim_file() before modifying it, so
that a file that LUO already manages is rejected, e.g. a file that is
preserved in an outgoing session and whose size is frozen.

Like the other failures before the folios are restored, problems with
the argument and the target can be retried.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/mm/shmem_preservation.rst |  12 +-
 include/linux/kho/abi/shmem.h           |  22 ++-
 include/uapi/linux/liveupdate.h         |  48 +++++++
 kernel/liveupdate/Kconfig               |   6 +-
 mm/internal.h                           |   1 +
 mm/shmem.c                              |   9 ++
 mm/shmem_luo.c                          | 178 ++++++++++++++++++++++--
 7 files changed, 247 insertions(+), 29 deletions(-)

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
index b61687e358a2..30fac9a9234b 100644
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
+ * struct shmem_luo_ser - Serialized state of a shmem file.
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
index 38ba1cf23d2c..5ebd62e0d294 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -252,4 +252,52 @@ struct liveupdate_session_get_name {
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
+ * which must be an empty regular file on a tmpfs mount, opened for writing, and
+ * returns a new file descriptor for the same open file as @fd in &struct
+ * liveupdate_session_retrieve_fd.fd. Userspace creates the file, and its path,
+ * owner, mode and file status flags are left unchanged. To keep anyone from
+ * accessing the file before it is complete, userspace can create it with
+ * O_TMPFILE and link it with linkat() after the retrieve. The blocks of the
+ * file are charged to the mount of @fd, and its memory to the memory cgroup of
+ * the caller.
+ *
+ * Userspace must not use the file, e.g. map it, until the retrieve returns.
+ * Otherwise, the retrieve can fail permanently.
+ *
+ * LUO keeps a reference to the file until the session is finished. Since the
+ * file is open for writing, it can't be executed until then (execve() fails
+ * with -ETXTBSY).
+ *
+ * The following errors can be retried, e.g. with another file:
+ *
+ * - EBADF: @fd is not a file descriptor opened for writing.
+ * - EINVAL: @fd is not an empty regular file on a tmpfs mount.
+ * - EPERM: @fd is immutable.
+ * - EBUSY: LUO already manages @fd, e.g. because it is preserved in an
+ *   outgoing session.
+ *
+ * The following errors happen while restoring the contents, or because this
+ * kernel can't restore the preserved file. They are permanent, and retrieving
+ * the token again returns the same error. @fd is left empty.
+ *
+ * - ENOMEM: Out of memory.
+ * - ENOSPC: The contents don't fit on the mount of @fd.
+ * - EOPNOTSUPP, EINVAL: This kernel can't restore the preserved file.
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
index 566cbd2dce48..609e09f60309 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1432,6 +1432,7 @@ int shmem_add_to_page_cache(struct folio *folio,
 			    pgoff_t index, void *expected, gfp_t gfp);
 int shmem_inode_acct_blocks(struct inode *inode, long pages);
 bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+bool shmem_inode_internal(const struct inode *inode);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f..48bd144e7f00 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -468,6 +468,15 @@ bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 	return first_swapped;
 }
 
+/*
+ * Whether @inode is on the internal shmem mount, which is used by
+ * shmem_file_setup() and thus by memfd_create().
+ */
+bool shmem_inode_internal(const struct inode *inode)
+{
+	return inode->i_sb == shm_mnt->mnt_sb;
+}
+
 bool shmem_charge(struct inode *inode, long pages)
 {
 	struct address_space *mapping = inode->i_mapping;
diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index 854a49cd0aaa..2ea161fb00fc 100644
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
+	if (!shmem_inode_internal(inode))
+		ser->flags |= SHMEM_LUO_FLAG_TMPFS;
 
 	err = shmem_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -554,6 +580,108 @@ static int shmem_luo_retrieve_folios(struct file *file,
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
+	struct shmem_luo_folio_ser *folios_ser;
+	struct shmem_inode_info *info;
+	pgoff_t fallocend;
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
+	info = SHMEM_I(inode);
+
+	/* Like the preserved file, the file must be on a tmpfs mount. */
+	if (!shmem_file(file) || shmem_inode_internal(inode))
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
+	fallocend = info->fallocend;
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			err = -EINVAL;
+			goto free_ser;
+		}
+
+		/*
+		 * The folios are past the end of the file until i_size is set
+		 * below, so reads, page faults and memfd_pin_folios() don't see
+		 * them, and they can be removed again if adding one fails. Like
+		 * fallocate(), raise fallocend meanwhile, so that splitting a
+		 * large folio doesn't drop its pages past i_size.
+		 */
+		info->fallocend = ULONG_MAX;
+		err = shmem_luo_retrieve_folios(file, folios_ser,
+						ser->nr_folios);
+		vfree(folios_ser);
+		if (err)
+			goto truncate;
+	}
+
+	i_size_write(inode, ser->size);
+	info->fallocend = fallocend;
+	inode_unlock(inode);
+	file_end_write(file);
+	fsnotify_modify(file);
+
+	args->file = get_file(file);
+	kho_restore_free(ser);
+	return 0;
+
+truncate:
+	shmem_truncate_range(inode, 0, (uoff_t)-1);
+	info->fallocend = fallocend;
+free_ser:
+	kho_restore_free(ser);
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
 	struct shmem_luo_folio_ser *folios_ser;
@@ -565,6 +693,18 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	/* Make sure the file only has flags this version supports. */
+	if (ser->flags & ~SHMEM_LUO_ALL_FLAGS) {
+		err = -EOPNOTSUPP;
+		goto free_ser;
+	}
+
+	/* Files on tmpfs mounts can only have F_SEAL_SEAL. */
+	if ((ser->flags & SHMEM_LUO_FLAG_TMPFS) && ser->seals != F_SEAL_SEAL) {
+		err = -EINVAL;
+		goto free_ser;
+	}
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
@@ -579,6 +719,13 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
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
@@ -648,6 +795,7 @@ static const struct liveupdate_file_ops shmem_luo_file_ops = {
 	.unpreserve = shmem_luo_unpreserve,
 	.can_preserve = shmem_luo_can_preserve,
 	.get_id = shmem_luo_get_id,
+	.rarg = LIVEUPDATE_ARG(struct liveupdate_shmem_retrieve_arg, fd),
 	.owner = THIS_MODULE,
 };
 
-- 
2.56.1.809.ga0b61035b5-goog


