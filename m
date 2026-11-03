Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E04A606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kapuiqcm
Received: by kanga.kvack.org (Postfix)
	id 1DBEF6B05C9; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166066B05CA; Mon,  2 Nov 2026 20:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0058E6B05CB; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6396B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 085D0C02A7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:34 +0000 (UTC)
X-FDA: 85392007428.14.44059BC
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 371FE40009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kapuiqcm;
	spf=pass (imf01.hostedemail.com: domain of 3pjLpaggKCA8s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3pjLpaggKCA8s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NsfLvJ1nQvHHWQPsmLteoFiBjT0ZYUV2iS0Ocnxsxo=;
	b=CtTJ/DVQEfnm4VHUYSOJqVWbI4Qb+qsggQ+7RRoPbHY5LckdbtotvmURWM0oKW5ucF1Aox
	Mey6lNdbrmB/7fAG4eqmQ+adyhaD8jmNxu7Ronqq7F3OF4NlRJTi2+FbGlJvVFXtn+cMVo
	2Nuh1lmoa2A9z+e496f57F2ZLQB06kw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667752;
	b=lQA1bnWqJJ/EbGTFszY3GHh9WlpS8ov+Kh7Tgvww3b5CFXp0pkW5HbKGTT1bxkIaeGdhwv
	ey1Hy0VXlhvoREaRMOcT4g5N4/kbOz0wB7WtwMCGDJ5ClK5jh7p18pY5tf0OGfDHSmdVI+
	7n+lwgULMCrrL0mO4i4D9e6iD0381cc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kapuiqcm;
	spf=pass (imf01.hostedemail.com: domain of 3pjLpaggKCA8s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3pjLpaggKCA8s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd66551e02cso3631469a12.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667751; x=1794272551; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8NsfLvJ1nQvHHWQPsmLteoFiBjT0ZYUV2iS0Ocnxsxo=;
        b=kapuiqcm4p6L15RO9En+/gMtXuesgrAd4e+yc9tvuxqKRQ4xBAqjeYanOwmIGfeaz7
         dFxbjWFYXSA67ipoxvuwVL/mosThxvsGnK60uayvxJOEtAT8ZOPEh6uMDRP4r6483PS7
         FCzD+MeK8/qr1gJU2OR4pBgoPrBM6TUwRxym72eOI3sEOymVpW8poibWpS/3ZrOpv5Ce
         xRP2GD1LxxjtzmqTQz1g4dGFHYRNHXWsKxaATBMRkqsHWxmiF+iuZqz7B0GSV5mRxgT/
         5ppEN6rbZAK52PX+4M8PPsnOdNcyu8cw456237oh3bZ3e+SIE/INkYNPPe3GYPtYaAeO
         /hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667751; x=1794272551;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8NsfLvJ1nQvHHWQPsmLteoFiBjT0ZYUV2iS0Ocnxsxo=;
        b=PiQ9UMKMDW6NV5LsYkgg3rzuqkCVntZ38itwC/12akFrY71mMvT50sFNGppc4th5tK
         CtGCCmv9fcd10ilksWRaBWiKEVuAv7gAmdVfMAgpRlrM/OIBQDVfoxn1sbNhBmLIfEOA
         BWJbT+976MzDGRWbA5Ukb212JLhrxNmhiFuw8r7f/NOs/6T/e8zQfxYS5uVQF2miwjw5
         fXCL57Awccamwux9pkaY4seavczmNsDHUGGtSd9ZZESOtIMQ/rfUI9ZxOk6CQisAPavd
         Ozgy6BzUNhqqMW681hECFT7zIH17VyheLrSPQTOq1QrG5D0nlZqcQ1jruvvt4F5LHLnk
         Hm2A==
X-Forwarded-Encrypted: i=1; AKwUvBwl0JY5OcIKkBJ95MNbXn109UX+apbx9j/nd8N8KuYAyQiMikSFVquNExa8NvMKC5hSqODI11fQsw==@kvack.org
X-Gm-Message-State: AFq9FYJxYpX2v1Wqo3ZOrqE089XMpHNUtRmZXZ1NB/WlTOvb86p0CEOG
	q0d3JzYvSRt8nbXWDFtgCpD8mNhb/nucyB/ospEoWQ2F8Zfy4+sCtoqHDMt4cUgu+nuSECVp0qr
	3pzst9RzNAWXeGA==
X-Received: from pgjl14.prod.google.com ([2002:a63:da4e:0:b0:cc7:db17:7dd0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a0b:b0:3dd:85a9:55a4 with SMTP id adf61e73a8af0-3e92899ccfbmr11780127637.29.1793667750627;
 Mon, 02 Nov 2026 17:02:30 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:13 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-8-dmatlack@google.com>
Subject: [PATCH v3 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 371FE40009
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: zpxbpdjyjxus83o8ygiwp44q544tyw89
X-Rspam-User: 
X-HE-Tag: 1793667752-222977
X-HE-Meta: U2FsdGVkX1+YkCXGXHaI6JE84C8QNU5koSUqBw9XDUAKrR/nguX8AQLQ1lltLFtmYZRiuz3mXBsRQw14QBYpRIgtsphMkrtXEZNS4E+pOAm4aAiS5wNJDs7ERy3n5RUB0oevwEzHgH08Zemv4dNdzpD/u9WiE/6M1nO5pbsSmW491dKr+uNgyIhe8EAfL37fKWsul6568drBzf1IvWMy4i5D7CUzJBbTVpg65FY7i6YpWMm3Hpx0UfrdUxWgiefEdH993be4KuTMonxPlGXK/MQ0caG/DLCH8GWq54WA2kVgKsJqsnRs0JUE5sPDOsEu/SJA9FPHGWBHuuymQuMXw5fCtwQsDMwZuDpTkjSO+r593hUH8zKlBA1peQNzGonvBCYLzEw4TxtR1pFMTMR9GhT8UKc0A7CXCrKxA4f9TpDuaRVHpTZiU9rFeG86qggsBfs3KcyMdIJc8hy08piA/kAzaGZDSOdBZHhofxDE/RavxXqPTN+yBy2h4MT/HocBXJOUA/ajQXAQMk3jiKzGR+lhQYW1AcqRWLu6a8DCSl0Gq9Iljwr0SiB0G6MprN4pRb+Xx8plsjmUWc2MFjD+VRWgSDrYHIVht4d31z2l9me9/8JLey+15yw9jBMeNI3VqZRFgo10T2qSI/F/FrvfmxUdDGn6Jw2550f85/qfSiJ+dEjXu3rNYUAOO7QZLBMA2D6laskaLC5Poz0rSyZq2F/rFzt+q6V53BBPPXCiCBgN0A5S/ic19io9MY1wxTX1jUj6yFZ4KD4l+WuHIZrUFod4Bb4/ljWuWgSv+Z+9evdYOU4y06tye48iub/jOnNPcQ8TWBn4Z4K1itgc9tVllwoni3BsNZn2yVsymiE8BHhaYZOYPTpR7a2NR9kOa9qB6iI9vaBa3wwuu8918DSv0ek/w5Q26USUooIRsj41u1afsvuZbuF5Y6mLgiUUimV4nkeSJwKw7khPAXO1Zwm
 ZuaT0RY/
 KKhnzqKajZa557+cmPbhaSRPo/BIRpYpMTc7wZnkK4gXm4BXmlBApsHcw+dJn+WYe5By/GO/ofhgKBRNi881vQHF9t+xYseCq+goH8NFwNf/eYUsbhzJ+mkHeqIsguqKOGmaYOo2dq8HNg8aFUjtdNvFZTmAsMCTQIbEyQpPpAZFLbj6JRCeAUNjrxKJV0SxTNJbPl/YEXBwGjXX0lXFst3rulKdE3Iz9eb1gD9JwPzvIdDAks049ATi3YIvdelwPutazZEqNAgHwbF8UjydbZ9bqmmBECom0KUQmy/Y4OrIneHhKuQsdEJdO6MhI4hRuY/7y7nhaCZt3RpZ9vnVawViketQOItfki5asz4z+fc+xyOOdxAixkxbgQDqwr13a+MxTT2XO1jT8FN8yKsjntBe3kKIol7Ao+iZbqBuW0IikCevsffvECzSm6FMZmqKJyfGYruqZXrPXUG8LYc0VaDPeY3DKcGyP5fPHuf9CAoaZxwn1oPcjHn+OTwrJDFQqKlYGozAM+lmixvueQUGcdMSyBaJvF5rFtO/ApN2Q4JOU5bwzoPgbmeKhEfn4P2wuUhrmMuCmK7XQm70x/0DmYbe0IvHAUGU2YSOf6YA7Nz8WMhYnESqEadePQNx8EjGMMTMDNFvHLSAAUho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Retrieve files that were preserved from a tmpfs mount onto a tmpfs mount
chosen by userspace, instead of as memfds on the internal tmpfs mount.
Add struct liveupdate_shmem_retrieve_arg, which userspace passes as the
retrieve argument of LIVEUPDATE_SESSION_RETRIEVE_FD to choose the mount.
Record which mount a file was on with a new SHMEM_LUO_FLAG_TMPFS flag in
struct shmem_luo_ser, based on the superblock of the file.

shmem_luo already accepts unlinked tmpfs files, such as files created
with O_TMPFILE, and a following commit also accepts linked ones. The
mount such a file was on doesn't exist in the new kernel, and userspace
may want to put the file elsewhere anyway.

Model struct liveupdate_shmem_retrieve_arg on open(): The kernel creates
a new file as if by openat(dirfd, ".", O_TMPFILE | flags, mode), so the
file gets the owner, permission checks and security labels of any new
file in that directory, and is charged to that mount. The kernel then
fills the file with the preserved contents, size, position and seals
before returning it, so nothing else can access the file before it is
complete. Userspace links the file at the path it wants with linkat(),
or passes O_EXCL to keep it unlinked. Neither the path nor any other
inode attribute of the file is part of the preserved state, which keeps
them out of the KHO ABI.

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
index 897fa2b61346..9c67daa35d66 100644
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
2.56.0.385.gac671c819a-goog


