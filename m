Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2A2606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kjrWhHwc
Received: by kanga.kvack.org (Postfix)
	id 70C266B05CC; Mon,  2 Nov 2026 20:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695506B05CD; Mon,  2 Nov 2026 20:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F256B05CE; Mon,  2 Nov 2026 20:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1279D6B05CC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88601A695C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:35 +0000 (UTC)
X-FDA: 85392007470.22.A42C9AF
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id CE3361C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kjrWhHwc;
	spf=pass (imf18.hostedemail.com: domain of 3qDLpaggKCBEu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3qDLpaggKCBEu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7I0mAJcE66JF6RmNkJWZGa5rIBu7EHzJOM3NkpUE8Fo=;
	b=UKqFISc/qwuwMRZySob/GEjI+ujLXZTD3Xg/qGa380dBlmpbFYaTSZ3NRwPmLpECeTVFH5
	CZFi16zUPnnn4SvOzaMaaQ4JQoQgilzstqJe90Zfz4EoDX3yO3Tpz0R+Z02SyR+vlrEOmo
	D8AJgX/udRG45VNfO1B1OugGvFaeJBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667753;
	b=AvDBlPftL1tG4iqUDqr9i/S3HGObh+qDt1J3mV1F+OH/OLDGdkqbF3Hg/dllTkFr/q+dGA
	OFKiTyhnukf70qSARQYSkgnV1kQ4AFFjV8XMMpU5DxnNT/xxkejF4M8af3tiZ5LBaen+5T
	SglVzW2QMaIvInYjn755aPvy4aBbXEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kjrWhHwc;
	spf=pass (imf18.hostedemail.com: domain of 3qDLpaggKCBEu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3qDLpaggKCBEu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e8e16d22d8so54544595ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667753; x=1794272553; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7I0mAJcE66JF6RmNkJWZGa5rIBu7EHzJOM3NkpUE8Fo=;
        b=kjrWhHwcIsSQ7/aB9+yzvCEtZa64IYLggHPUhlW+8jbO54tUaCY+XAhh9icFk8dUBJ
         sdORn0N3o8VAD40BwVuKZFGhmngh/rY31CtLD0RAua8ILvpYERYfhknfz8jIrZvKUWht
         nZ9WyXqxwZjI7k+vykTkvGJbP64mLB5M5S2FD37Cr7baUeq3qsCO5I6iqDYs3EJ1hGAf
         Ut2WfkHCTf2BXgqkpBwDrrRlrLpCBEvADGmCxua2w6SJ7P+VIWBwIY80JDEnSyX6gGMH
         7UYzRfxI/o3JiGiRZXWnGrVzLtoy//FsGbYTG+FO6kNH1LAFQ3v6SH5CRgNAGoVYXN9r
         UhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667753; x=1794272553;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7I0mAJcE66JF6RmNkJWZGa5rIBu7EHzJOM3NkpUE8Fo=;
        b=Y6eoJOK+EXjs+PPQ8B4PDjcZZWlGIbSozuGwpGNXAlRiVve2MEDlSDNc5OKCrovuPZ
         X8JheI8/56IWJdJ+NsDGMS2We1+oF0NCE9cBd5IjhvkEoZlpM0Sq3Pww3asx1Cm0Coa5
         uUYwe5eBAIQbe4xuSWfjdsMHcy4WWymn+Bt21qH9v4KWZDjolucx9ttv/WhVzFuUSdwy
         9mMQkuWJ2SbumQaMDBZzhWpQYfTmwVkjN8//88jnNsM7RfQF9g+0ym5Ck6+7EZzlzugY
         21lov7vnUJdr4ushgS6/QNAe9i7smEBNuC1yfQbVyJFNtBAyX9CNogASLh4O5UMOEYy7
         kJFQ==
X-Forwarded-Encrypted: i=1; AKwUvBznQmSNUDsNLZA5lyNT4LfZZy8aVCyOF1+ZcTRp9CeYxeH06ypjaIYwYj4zNNrNa1gS45/zSVG4yg==@kvack.org
X-Gm-Message-State: APuU4Z9A+Ss816genflhvLtbkXE04NPGXF+KajM0mSHA5hQ2dTBe5bp7
	RHTmmY/LuOudcYyAqqLzMefRYdwRtAeSRGuY8Oe1w0KQmZRHYMDSm9u+/2c3+F2HN/eDHZjkEiq
	rZW6irPV+4qt/Mg==
X-Received: from plil13.prod.google.com ([2002:a17:903:17cd:b0:2eb:515:b000])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e74a:b0:2e7:4a2f:68e6 with SMTP id d9443c01a7336-2eb364d1882mr123516745ad.39.1793667752259;
 Mon, 02 Nov 2026 17:02:32 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:15 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-10-dmatlack@google.com>
Subject: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files with O_RDONLY
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n8ncqrsyzqssywcdcfgx6kgohyqdjskp
X-Rspamd-Queue-Id: CE3361C0006
X-Rspam-User: 
X-HE-Tag: 1793667753-840093
X-HE-Meta: U2FsdGVkX1/CRAkOZbykc9fuw2TlodnTJxjwZBy2nRcmF2MULdjXouyI366fuK6YNjkTh0Uavl09vtn9/gwlg9l+U+XWtt+h/pk3HBAIw2oaazTPvClxYjZ5fXkvX8jDfWP11xirlTj8fUcYQocpv3ftZKTHbZVEtIlDWA48CTURd8IkJfwPFDWrMV0m45/ehv2ZJSwPcH0ezxf8PcHy7V965wma17/pu+XqPhweo6pZfmvnxECs0jHKITSX5XhjF2T+whBKXzWqdQUOHP2lHkisDxtaGqcRcXisyXcHvyVJqc7RsktDaGoNghD2Exo05KRCmMSctrWkG0LuOhD2YLT3wxgWlqX4n0GBopWkmGQmhb+WR99MoYEP2j/zNF7lWt0KdO3D6PnCaFTbHky811cUuQdW6gkASqHR96gKM8SNE2X8USsKkioZeC/rXbIZexLHWGxFg1gZWeAA/4MpjHWNkbFiGPJTBNB3XT8NzzDAMq+FtHXiZrPZvSPzotGxnyNl45OVhwHx+MsHaVntBYmmg/B/IpNRPdR2l6fjfsiSC46UrNyXVFNfPTbVYno7BahLy5W9tRgzNdJTb3izQqE6VAkFufMkjNT1ulGvJBQZOpH/k4vI0zqHIrgeu7ooc2HN1y38djooxHRwPsxvg6kOZN0F6EtmR8WhZqrTL0al06P+o0uc6sDGguKFnGozv1Q1QzIgYa6BNz8g6ar9gYUmL1wrWpIQj/XNlyjXayUnZQTD2bQCHQzcpOlbHm0OOFkpPsU0f9wpP2JlBRyOwnFVDNcQPcg87tZ91Twa4ewpofUipID2sGpEDfIcYvJzxMMkXvNCqB87YmEDgWW5LJYu33xvAAocXBFyVpPs2ln1R/ko4V9a/p6mw/EmPPoWQ7MXoNX+nmnRl2O+Ctj3OdLKfe681AXuFalhKT6dxVZBrjvnqrOOHSa31p5g0vvUCyTy8gOE/ZEa8HNBnRT
 JrPQ1Ra1
 bxgWy3lUaoXaZxBUxTZTpD/dYy7+TVDg7fB2AR1hIkWUo2CZzmZ+5wst9V0+oz0WrJlbezt7bdCzgtwJu5RfLuvQ/UbEmIxXp2lLDY9HZ+4lr2x6S9/oQhiFi8TC0Fb245ynpkBeDrk8aseTMSMzetwlEEBoTlvPNRwdirjXxCrWeNp8cEGhbAAuomXJw6dG4dW6zbt0zTn2RVqqKzXDq4Y1dZTsyfBHRWHmg0ssT3fJkNTkVluDiMlOk8wwdgGqZpstDRC72lQcg413Tsz4XkEgLyhrKvmirLUvkx8AU1sbh+vpuOOvXoY4vXWwXjGKZ7e8j0CoGqMQdEvgJz3hjDgUX0QgKfrtovRXEEaRDmOHRSN0gj9EKT8r3wwkOOo8vfXKkObEWtwR3eIS6jbGoL7zqZjZBeyxCpNBFS0aB68JSJ/VVpH5HZ63eADsBXUp3DuT/ZN24xGhNzzL7a+oEgqgg+5tv2AmSC+YjortSJSldqqJ+DjkuXu4P2XrqHgiBozzU0sw4lDO2AZMUZRQQ4542sI3aE5LEQ2t+Fi2cTe24QNmAvp+kJMuvQPuUsBW1TmDtTHMw7zXB0oX1fVt2aPkxQpyfn4mIdAAeE8iMeiiTaBQPZmrpwQOLMHOz0OQk0iffJJ3IrrL72/4=
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
like before, then reopen it read-only with dentry_open() using the flags
of the writable file, which file_open_root() normalized, and drop the
writable file. Like open(), which grants the requested access to a new
file regardless of its mode, don't check permission for the read-only
open.

Retrieving a file read-only allows a restored binary to be executed
before the session is finished. LUO keeps the retrieved file open until
then, and executing a binary that is open for writing fails with
-ETXTBSY. Being able to execute restored binaries right away matters
when they are needed to finish restoring the system, e.g. to bring up
the services that retrieve and finish the remaining sessions.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/uapi/linux/liveupdate.h |  6 +++---
 mm/shmem_luo.c                  | 34 ++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 10 deletions(-)

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
index 0c012f242fc5..c669416a8a59 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -113,9 +113,10 @@
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
@@ -661,7 +662,9 @@ static struct file *shmem_luo_create_memfd(const struct liveupdate_shmem_retriev
 static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_retrieve_arg *arg,
 						unsigned int seals)
 {
-	struct file *file;
+	struct file *file, *ro_file;
+	bool rdonly;
+	int flags;
 	int err;
 
 	if (!arg)
@@ -685,10 +688,16 @@ static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_re
 
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
 
@@ -706,7 +715,18 @@ static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_re
 	}
 	SHMEM_I(file_inode(file))->seals = seals;
 
-	return file;
+	if (!rdonly)
+		return file;
+
+	/*
+	 * Reopen the file with the flags of the writable file, which
+	 * file_open_root() normalized, e.g. by dropping O_CLOEXEC.
+	 */
+	ro_file = dentry_open(&file->f_path,
+			      (file->f_flags & ~O_ACCMODE) | O_RDONLY,
+			      current_cred());
+	fput(file);
+	return ro_file;
 }
 
 static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
-- 
2.56.0.385.gac671c819a-goog


