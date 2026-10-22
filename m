Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0986606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NMzsbRoz
Received: by kanga.kvack.org (Postfix)
	id 290A06B0A12; Thu, 22 Oct 2026 18:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241056B0A15; Thu, 22 Oct 2026 18:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F106B0A17; Thu, 22 Oct 2026 18:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58E66B0A12
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:51:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41F6A1402FB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:51:01 +0000 (UTC)
X-FDA: 85351759122.12.BF169EC
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id 874DE80007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NMzsbRoz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3UpPaaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3UpPaaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tveVWO7bpJoIkcGyu5OICWvMrLDi2sKmFxgN2k+RxPA=;
	b=OSuG36P12D7lRifl1pjP63iD57kvvT/CHVwj2zEnZ899092LI8nPlsH21dm2zDg53SvNDY
	PCywaJrjamvAYiyj3TCsYsEfpr5L3LqjJsBgNJhV1cV+02zZZmhWG+gJHtfh0R+kKzKt0j
	Ww8PGGZjDnHv6OhqY4mf17Az14suw9s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NMzsbRoz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3UpPaaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3UpPaaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709459;
	b=JYKWAW+3GC22Mbsd3CUXdpanPOVA++47vesh2A6TJB/FRYIAiQYUE4wj2Xju6GGflYhcrj
	0QxeomLIdlNcELRZr4QRKZl0gs6U2hKEZlaBM9sgOz3ubagJRZ1ViHz7dvdg8PD7T0dovB
	e25cPDAX0JBNaeSIJKZnQGAuBZ6fRg0=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so289611a12.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709458; x=1793314258; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tveVWO7bpJoIkcGyu5OICWvMrLDi2sKmFxgN2k+RxPA=;
        b=NMzsbRoznB7EYl7CeEpE3CcmX+DwdcCuvBEVuEmC/F4CM9S0J5ov2inusiyMmeJABw
         VABElUsA13Jo/OLJNnqIUq9u6sBnDuatUKbHRcr3CrBi9GJfG4Ab7CdcxezaA/BkfFWn
         uubftsN3TOQiiF+HNFib6qoMvt9pXcQqmHGIsuvADdqMdxZUmIkCoU/NpGP5t0F54dUG
         Vs8o/UWXThRB4Ek5X2zFjhv6xLNjWAOe3PRHxBlI86EuJIBE/77FVbbOhX5vo7OrHhm6
         qdy4S+JL92CzqTJ983qxWljsZ995rM9hOM1zzvo+KJ9HswZpvCe5jkRTtTipEDNdvJtD
         nfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709458; x=1793314258;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tveVWO7bpJoIkcGyu5OICWvMrLDi2sKmFxgN2k+RxPA=;
        b=Lu4astbdpZGQIIBw2cl1PofDBANFQB+l56QFC35tGx/Oy/n48YDyKkK40aG098ii9R
         j+QT9vDYY0bUYTnT5Vf62CTrXIdbes8lalIUWNic7KlUj1kZT2JvE1eymUcGfux7SX2m
         DPUdQ/PDqm+p45vaTAfWBXu5Z0WEC0SWwLVq3DxkhIeJftPAXeyjbPe6h/mIkALSvW06
         IezLSyTd9f3USr1K2HIKgKPbH4z8YTdBYHDh9EBazVXIKERf3Akl+KAEEGb2F8lZH2Cn
         nG6vqMus4J5LFjGPp6xz9K3cuzQ71XBsnTTfpWWiOGx4fMAEp00hhyvXftX0Zuylp5/E
         1Klg==
X-Forwarded-Encrypted: i=1; AKwUvBwG56KFlp8GXxQUtAVgxYaHxGS0PvalQHcnuIpysyMJar0nDKMrAwu8WN+krTgAeS7TP2G+hf14tA==@kvack.org
X-Gm-Message-State: AFq9FYIwi9QfrUoWxJJka8i3I5qCpK+Tu5UO5ENVZJIh6Q05kJtLL4Sv
	IqI66U6XlhjqSMN7MgqRV2H/jNeGp8CQNT0GTGO0xrdvfKrURXs+k36t9monQb6X2Wsdj8RFLat
	idnP98jmGAxJDPw==
X-Received: from pgww26-n1.prod.google.com ([2002:a05:6a02:2c9a:10b0:cd6:1195:61cb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:8a0e:b0:3e2:335b:1a5d with SMTP id adf61e73a8af0-3e3767c3067mr249935637.71.1792709458271;
 Thu, 22 Oct 2026 15:50:58 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:34 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-10-dmatlack@google.com>
Subject: [PATCH v2 09/10] mm/shmem_luo: Allow retrieving tmpfs files with O_RDONLY
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
X-Rspamd-Queue-Id: 874DE80007
X-Rspam-User: 
X-Stat-Signature: yjgkf5bpuky9x8hfjbg7g4bzugjo5pai
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792709459-336876
X-HE-Meta: U2FsdGVkX18sSMXIF5TLLQHeaiOj+EqfzENLs0vaE6o1ZbjvdVuqXrgFHo0AWnGPwMvHbTIDTOhwYVy63+7QDYQchJS1s4ozy3ymOp2O745T4Cg/EomYM0bJWQ9bys8aE9P/qLvDAAIBEmMfOBaFcnAAJL7CXj8qefparxA3rzmKZ3WnrNwtQQCtVa3QW0g33hvtIslKRcHfJcDiNTGtammq9l7w/8ZfS2r9oJvub6g/fOIa17q6DKUZQTR6jXlyNK9UsR8+k7p1+tubA6aLI4dg8+JPEhCuSj/Wk6X55fTgSlOKjr2egpPQpqLooI8rV7ACDXxZGwG9wErFGC8pQ8tmDDH/62FPbe8OPL6POunxvqpkpYVZpVZtv+6mXb2KQgKeb3M+phlwhAvSX/cENNaqsqKtHGUxBTmnB8EcArnL98LA06mTsxcBZKbW9nqXOQbjDrjeDn6qUTwwiFCkJL6vK0CPZaJ8nMJfmW++etSLgN7zuDf5j9V9NeCEYqWemD61zr/Evu16PLd9kr6n09TBQdArjC2IO9dgbTd5cyglsNLfxPRdIaw5yJazAEVEC7IitDybrR2adudCEw6xR+4VCtVWyKfuDeOZaKiomJMSrGH/KK7X6rtQnzusQYccmoHYI3izxL4PGK4p7p7fAfrkeAfv9Cz5kvMYTjgM15Rc4sqjI6ArUT0dBDG33YzHLWcqRizX3yfzwCtixrksBY1RdYxX61FfSvaHx9ifBsMADpGNPzOBRIuM4yYJBavwA0SflnMNIwcY9KqKHdtlK8YpByX/MiYlO+zNv+fz53chnmOQBOUHmxQBnZaQokZwdxGfeFYvCdx0W3BKeIbV9TxAwN6XHflE/8cLUXvOSgGV2Su7HTwoHCAOwTeuiviI7BamIea/9miyE4Sy1if6LewpAdiaUCqKZuUaFoyjqu4uxMThjwIImw3AW3XBaUlecq/cVIkOCbaNhvdBaDn
 KILiJXmt
 +cdEEo1Fcerr/rAGzmIorLTdUFDqBOLrWfBMC5OojUxkIN/JHY4/97QLV44P86pSY1IBBMz9CuzxveaVamVHcU5zY0v2nd1h9GLBhCEtRCAWcbjOGYtmp9UmuDDG5LJy/S8+cnEDnX2Nx9hkDDQfQT8BEnUzRm+juFyMjjlqtkYIt3ejDyp3UysAK+WMIJ5vY00ylyAixhzmmbVLKwca52/8sR5s8JhxDMHZhFS3MfcOvST9N/atxStm9wZDdfxAEl/gwy33fU5LacpuSW+2tzvPVgtXx9mP8X0TjYUmxudtXO83grmNDY+U+vUjZm7kRf0g48jZ0zY3CaYedRnVDwgKJ8iCPZwERHqS9UnPXhZYCFdDjYU8Mz1UpNWEGju/O6jRl4EUeahJvu7y1l40XynmyMYk8ILREK4oG9PIRll+KVhXdX3q2ck+xgRh096CytonucYYbCwQLuXDovAvd4uQ4hUuxBVuCKQb5xs89kIU+TQbMn/v9Cgf7aGISzO+QKvdNCCwCgWiE0PD5XKBa7BvTp7irYB18X+BU3fcuCYvPY/VN/eWrL8zgC5bCnWhg50RpOQ+oA7qC698/ybBiYxN4/VjmgxH9bW3R6SthL8uHwBRPrdHczwVwvYLFkcfbxvSxEjg2Vsvx/VA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow userspace to pass O_RDONLY in struct liveupdate_shmem_retrieve_arg
to retrieve a tmpfs file read-only.

open() requires write access for O_TMPFILE, so create the file writable
like before, then reopen it read-only with dentry_open() using the same
flags, and drop the writable file. Like open(), which grants the
requested access to a new file regardless of its mode, don't check
permission for the read-only open.

Retrieving a file read-only allows a restored binary to be executed
before the session is finished. LUO keeps the retrieved file open until
then, and executing a binary that is open for writing fails with
-ETXTBSY. Being able to execute restored binaries right away matters
when they are needed to finish restoring the system, e.g. to bring up
the services that retrieve and finish the remaining sessions.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/uapi/linux/liveupdate.h |  6 +++---
 mm/shmem_luo.c                  | 28 +++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index a9dcc4fcc87b..790742a247e8 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -265,9 +265,9 @@ struct liveupdate_session_get_name {
  *
  * The kernel creates a new file as if by openat(@dirfd, ".", O_TMPFILE |
  * @flags, @mode), fills it with the preserved contents, and returns it in
- * &struct liveupdate_session_retrieve_fd.fd. Like any O_TMPFILE file, the file
- * is not linked into the filesystem. Userspace can link it with linkat(),
- * unless @flags contains O_EXCL.
+ * &struct liveupdate_session_retrieve_fd.fd. Unlike open(), O_RDONLY is
+ * allowed. Like any O_TMPFILE file, the file is not linked into the filesystem.
+ * Userspace can link it with linkat(), unless @flags contains O_EXCL.
  *
  * If @flags contains unknown flags or O_PATH, if @mode contains unknown mode
  * bits, or if @dirfd is not on a tmpfs mount, the retrieve fails with -EINVAL.
diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index aba2bc1f18c5..0b4a9d6e2968 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -112,9 +112,10 @@
  *
  * Like any ``O_TMPFILE`` file, the new file is not linked into the filesystem.
  * Userspace can link it at the path it wants with ``linkat()``, unless it asked
- * for ``O_EXCL``. Like with ``open()``, the file must be opened for writing.
- * LUO keeps the file open until the session is finished, so a retrieved binary
- * can't be executed until then.
+ * for ``O_EXCL``. Unlike ``open()``, the file can be retrieved with
+ * ``O_RDONLY``. LUO keeps the file open until the session is finished, so a
+ * binary retrieved with ``O_RDWR`` or ``O_WRONLY`` can't be executed until
+ * then.
  *
  * The blocks of the file are charged to the target mount, so the size limit
  * and quotas of the mount apply. If the file doesn't fit, the retrieve fails
@@ -649,7 +650,9 @@ static struct file *shmem_luo_create_memfd(const struct liveupdate_shmem_retriev
 static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_retrieve_arg *arg,
 						unsigned int seals)
 {
-	struct file *file;
+	struct file *file, *ro_file;
+	bool rdonly;
+	int flags;
 	int err;
 
 	if (!arg)
@@ -673,10 +676,16 @@ static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_re
 
 	/*
 	 * Create the file like open(O_TMPFILE) does, so that it gets the same
-	 * flag checks, permission checks, owner and security labels.
+	 * flag checks, permission checks, owner and security labels. open()
+	 * requires write access for O_TMPFILE, so create the file writable and
+	 * reopen it read-only below if that is what userspace asked for. LUO
+	 * keeps the file until the session is finished, and a file opened for
+	 * writing couldn't be executed until then.
 	 */
+	flags = O_TMPFILE | O_LARGEFILE | arg->flags;
+	rdonly = (flags & O_ACCMODE) == O_RDONLY;
 	file = file_open_root(&fd_file(dir)->f_path, ".",
-			      O_TMPFILE | O_LARGEFILE | arg->flags, arg->mode);
+			      flags | (rdonly ? O_RDWR : 0), arg->mode);
 	if (IS_ERR(file))
 		return file;
 
@@ -694,7 +703,12 @@ static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_re
 	}
 	SHMEM_I(file_inode(file))->seals = seals;
 
-	return file;
+	if (!rdonly)
+		return file;
+
+	ro_file = dentry_open(&file->f_path, flags, current_cred());
+	fput(file);
+	return ro_file;
 }
 
 static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
-- 
2.56.0.257.gf7497c7d27-goog


