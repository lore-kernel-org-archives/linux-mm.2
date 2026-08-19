Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E50C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2714C6B00B9; Wed, 19 Aug 2026 19:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248DA6B00BA; Wed, 19 Aug 2026 19:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EFD6B00BB; Wed, 19 Aug 2026 19:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3CBB6B00B9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75533C0678
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:36 +0000 (UTC)
X-FDA: 85119567792.11.747187D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B84B72000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/gkZ57m";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72gFO+JEMFm/mE5KyMl3szngZahRJUcU2+ZTWkuKUzQ=;
	b=GedaPn+TmD0AugApaeu5vYWywfno2UVUcKgLmsxVixsLXwlWbnxtncIKBIYMcIMxDMi2fD
	RDla1/5s8DbR1c7MeDlsiU7Fw5H6idp0KDY/HdW7+OEajbQtTd76I92JLRTONrKBi2JYzt
	mJ0NFzpWHWpI+baQ1AmZbP9iikgmI0w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/gkZ57m";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181094;
	b=UXY/sA4MhLOtv2+cLglAJQuiv/TStZotZECmky1bBs4uQh54F9UVF0Gwj6fYcrTrSr0XEb
	A6wqfI2TFphZk34m1tSE9lLN8qKkBc25Eit8QGr5veCq32ujxm6HLWGJR9eg0sGKroQKmg
	wBVVDptgLtwwtVYzgguBaq+ZQRlF+Qs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D7B661899;
	Wed, 19 Aug 2026 23:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3351F000E9;
	Wed, 19 Aug 2026 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181094;
	bh=72gFO+JEMFm/mE5KyMl3szngZahRJUcU2+ZTWkuKUzQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l/gkZ57m6x0MVqexlIB/w3JhkEQ/mTP5nyLhU30ic1zHxAyQpA+y+AVskrHJNhiWL
	 SI2jlxBw1EjdpadUcI/2A7P8ClVic3G3yU1pobKVs/z5WXqAjKd4IdFfkSWWCM6h6Q
	 gABt5r1yAPuoRGCmxDtpQ/1Y4zl4lgYSUaQBbpMdeMQiTN/zx4rXCp1j6VuKKU73Go
	 bomiUP0HgV4440yO+vYhzrgBbGT2GMZE+iJhtzEq0RnQoCRguvwdYV2qkC58iZfyZ1
	 NxsO7LrU+v7+V4jutQEHM5GJ/MMyOXp4cjQg6nVnOrDFHGiB7iIIkE6sktM2WpceL3
	 Y4sF9a5Hopcog==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:34 +0200
Subject: [PATCH v2 17/22] coredump: describe the holes when COREDUMP_SPARSE
 is negotiated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-17-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4977; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SaaeoMeiN9Mzcytct1cOKja7m2Y3FzATAK/meN2hUkQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+PdVFZciP6KiOziPLkjCPrt4aY2OkX5d9iajx34
 WHpM9v0jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInMWM/I8Ko0T+d2zco97zmF
 vm1mDJ1xNqjz4AbuFR6Feh1RpamLORkZVrqnlC9Qy/36LDrokmhKV7HBSe1XSXxH/U5vuqau7ri
 UCQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: d4zkrss9t17u6tj4pncfqdmtt1y67sxr
X-Rspamd-Queue-Id: B84B72000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787181094-672188
X-HE-Meta: U2FsdGVkX18/ZPZ9ug5Z37U+QwWnZwXyakBPsiLc5yQyK+jZlz3E1w6CyVbFhhTu/MUsw/zjacWf3HN3Pt152jfL8mEbR9lctMBCdHoJ88bo8h1bVplkg3JasvkB8wYIe5ATcGNnwNj02M0LVmCP6aaa1ACnT21MvsFw7r4LvOHOA03DNctmT5v43xYI+IY0qa+OIzwtYVxddrmgiBn4DmHEGCbqlZtUae1xNVtwtQNez2FVM68d+Ny2HlyTinu6j0qvS7/5zj/o9coW8JcEVRUi1mmpJF+VwA8b2nwy3y0cTu2dVkSAg+x/jpYTIO/+28Rt1gh6npH3WGmZwVMUl1WHvWEhVMKtepeEkR5ROL6YwYb8S+f59d94pkX92xpE22J1InOATar8h5fgR7sPkMgi9YRQfwdknVOULQeM/26FOM4s4V6yl7bevcdqm1QDRn2Q5eblSYIkxe9ehksMhLXx+lqKtT1OaGg69tOayK8+Yc2fgtvXW6FAjYLPzSgZ7+R5FTP6AsqDvGGBC8Df5VmxvBwIYcLVKV0RROJ/EqqQpM3QfB91aySreUpC/yY2QmG+pLrf0TmJfPkg+J9CUnG9meV8moQ+LMPnTNdhhtpHrXNIyhPQ/YIWAw7HuUJTlYYIrdkokNIFdbpfe9tVTCF5rxBesShM8k9fySw4ttaKyJS1bD3GwHTGDaeTKvHR1ZfE2ITsHrRPN4RlojKT08lzfu9qMAXEMDwl4LY4w0JJoEz+enk6FVgwDekvYMGSCRSelCKs8Og3V9jdnn6C2G77MOMLOMV9XvF86nDuK2qjfLIWV53HawkeOxBLX9NMuRoHYL3YDMxRFUeXOSSGY1Dp7rzkQGoKpHngWgXctFAmwDtIaexCCcDkDvfITKsP/GwAS2JwvtQKIeBOqJvm0jJxLaZJx4iYyOnDwRV2nPt9mbsvln73dkwwG10OoOYnNtUoaIY90fPm1aCVbPY
 bLsSVwOS
 N6RSIV8FHgK/wiHl+b/RufgdolZTvysK1bKzz9ON/175+/tRTnH+2IuJ4GD8jXxtBXhL/DgqLc+oTWpcp4aVMpO3TvnQAp5vQW2cjc5nSZr38HVISM1JuGfim0nk+faUDEnsI1nLHVXVPOraT8UI0dSSSkdlm9bsiAh64fXqDYDGtJBgLRnB+bdIb5L1sBkwB4pOm0EAOB81TVtUxn+65jsyuNvBORS6yz5VaSecGGZs1q7+Rv6fKnVnU60mEB9K7lIgSK95ktEBfB3IdZTQiGB5leLIUpLnBiyHn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of COREDUMP_SPARSE. Refuse it without COREDUMP_RECORDS.

Actual holes are sent as a record with length indicating how much zero
data there was.

coredump_write() flushes a trailing hole if the coredump is done.
Instead of writing the actual byte for pipes and sockets, collapse it.
This stops wasting a header with coredump records for a single byte. So
we now only write it when the coredump can be seeked. TL;DR a trailing
hole is a zero record like any other and the records still cover the
whole coredump.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c                                      | 41 +++++++++++++++++-----
 .../selftests/coredump/coredump_test_helpers.c     |  3 +-
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index b1679930094c..7b568d25887c 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -68,6 +68,7 @@
 static bool dump_vma_snapshot(struct coredump_params *cprm);
 static void free_vma_snapshot(struct coredump_params *cprm);
 static void dump_end_record(struct coredump_params *cprm);
+static bool dump_flush_skip(struct coredump_params *cprm);
 
 #define CORE_FILE_NOTE_SIZE_DEFAULT (4*1024*1024)
 /* Define a reasonable max cap */
@@ -806,7 +807,7 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		.size		= sizeof(struct coredump_req),
 		.mask		= COREDUMP_KERNEL | COREDUMP_USERSPACE |
 				  COREDUMP_REJECT | COREDUMP_WAIT |
-				  COREDUMP_RECORDS,
+				  COREDUMP_RECORDS | COREDUMP_SPARSE,
 		.size_ack	= sizeof(struct coredump_ack),
 	};
 	struct coredump_ack ack = {};
@@ -866,6 +867,12 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		return false;
 	}
 
+	/* Zero records only exist inside a record stream. */
+	if ((ack.mask & COREDUMP_SPARSE) && !(ack.mask & COREDUMP_RECORDS)) {
+		coredump_sock_mark(cprm->file, COREDUMP_MARK_CONFLICTING);
+		return false;
+	}
+
 	/* Record header scratch; a bvec can't point at the stack. */
 	if (ack.mask & COREDUMP_RECORDS) {
 		cprm->record_hdr = kmalloc_obj(*cprm->record_hdr);
@@ -1076,15 +1083,21 @@ static bool coredump_write(struct coredump_params *cprm,
 	if (!binfmt->core_dump(cprm))
 		cprm->state |= COREDUMP_STATE_TRUNCATED;
 	/*
-	 * Ensures that file size is big enough to contain the current
-	 * file position. This prevents gdb from complaining about
-	 * a truncated file if the last "write" to the file was
-	 * dump_skip. A record stream relies on it too: the flush
-	 * emits the records that cover a trailing hole.
+	 * A trailing hole still has to land in the coredump. Seeking over
+	 * it doesn't grow the file, so the last byte of it is written
+	 * instead and gdb doesn't see a truncated file. Everything else
+	 * puts the hole on the wire as it flushes it.
 	 */
 	if (cprm->to_skip) {
-		cprm->to_skip--;
-		if (!dump_emit(cprm, "", 1))
+		bool flushed;
+
+		if (cprm->file->f_mode & FMODE_LSEEK) {
+			cprm->to_skip--;
+			flushed = dump_emit(cprm, "", 1);
+		} else {
+			flushed = dump_flush_skip(cprm);
+		}
+		if (!flushed)
 			cprm->state |= COREDUMP_STATE_TRUNCATED;
 	}
 	dump_end_record(cprm);
@@ -1241,6 +1254,11 @@ static bool dump_records(const struct coredump_params *cprm)
 	return cprm->mask & COREDUMP_RECORDS;
 }
 
+static bool dump_sparse(const struct coredump_params *cprm)
+{
+	return cprm->mask & COREDUMP_SPARSE;
+}
+
 /* Describe the next @len bytes of the coredump. Returns the header size. */
 static size_t dump_record_init(struct coredump_params *cprm,
 			       enum coredump_record_type type, u64 flags,
@@ -1357,6 +1375,13 @@ static bool __dump_skip(struct coredump_params *cprm, size_t nr)
 	static char zeroes[PAGE_SIZE];
 	struct file *file = cprm->file;
 
+	if (dump_sparse(cprm)) {
+		/* Hand the server the length of the hole instead of the hole itself. */
+		if (dump_interrupted())
+			return false;
+		return dump_emit_record(cprm, COREDUMP_RECORD_ZERO, 0, nr);
+	}
+
 	if (file->f_mode & FMODE_LSEEK) {
 		if (dump_interrupted() || vfs_llseek(file, nr, SEEK_CUR) < 0)
 			return false;
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 1c8658f35735..a5b9cde47239 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -275,7 +275,8 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 /* Every option the kernel is expected to advertise in coredump_req->mask. */
 #define TEST_REQ_MASK_ALL					\
 	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
-	 COREDUMP_REJECT | COREDUMP_WAIT | COREDUMP_RECORDS)
+	 COREDUMP_REJECT | COREDUMP_WAIT |			\
+	 COREDUMP_RECORDS | COREDUMP_SPARSE)
 
 bool check_coredump_req(const struct coredump_req *req)
 {

-- 
2.53.0


