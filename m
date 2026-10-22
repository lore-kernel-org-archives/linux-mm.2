Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1B6606A336
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DuOvJVJx
Received: by kanga.kvack.org (Postfix)
	id DB4876B0A14; Thu, 22 Oct 2026 18:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D935D6B0A15; Thu, 22 Oct 2026 18:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C4A6B0A15; Thu, 22 Oct 2026 18:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0B36B0A12
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:51:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 783B94027D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:51:00 +0000 (UTC)
X-FDA: 85351759080.03.7C65F1A
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf15.hostedemail.com (Postfix) with ESMTP id C45CFA0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DuOvJVJx;
	spf=pass (imf15.hostedemail.com: domain of 3UZPaaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3UZPaaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8wkRoJDHKCl2H3ues/+67+xXGDD9mtv8dtHSiakNgQ=;
	b=wPEZMkgJhsWXpGVo762B5oGJPWorPnjAHTjLblYfZmG6Wf7YTjGYj7K/icxefXmsRCMINR
	MXtAAGxIyvgMvUukwfq7Am/AcwqRuQzkbb0m1XC9Vmt+wnHm2Lcw3ZDjO4I8b38oA0HhOo
	bOjXDqWZJ35RnRyis9avd6z1BgJD/IY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709458;
	b=W3TIxzI+sVe2KC+aP+En3uA4wRMtEGJijctrEwJsUdQ10AC1IhcIMOrbivdMae0M39MpFG
	gdh2vZWOIJwa96RIdcBef4SH6qJC5rYDQpA/eFxoYA5Wa65s8fVqVng7Up5MufgFD8BWei
	xe/UZt3E0/k3211VywCe/8jTrBrJe3A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DuOvJVJx;
	spf=pass (imf15.hostedemail.com: domain of 3UZPaaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3UZPaaggKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd65070d3feso113869a12.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709458; x=1793314258; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M8wkRoJDHKCl2H3ues/+67+xXGDD9mtv8dtHSiakNgQ=;
        b=DuOvJVJxeubp7e/Ir3+fMr4k93skebrWhi88IPRDdtZf3oAdSqcUfuMBWq40rvHPuC
         2YAp9TpEJD42p+/WcfCV6Zs7jkE/9uBuUlyBD1kLntH5ZKLKsQ17ARKmlZEoCrM7WIFU
         eJjrR2asIe5qC/IK/RokgjcCFBlgaBrsACvhUbV8BW5QqU/bOAA6W+x6qRTe55+zQ3WM
         C98D+5esatJWuZVDyL3bsyxt7MxJDy/PuDkXtHdBWnDJbgV61ymfvB12gk0Bm4XTrGSY
         cmah6YLDllQ+TgQp+J7ogJs/bngmGgFc/z0G5/dU790e41KGi1nKXJjoOH7IbVc0rNiq
         w3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709458; x=1793314258;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8wkRoJDHKCl2H3ues/+67+xXGDD9mtv8dtHSiakNgQ=;
        b=kIwuDdb5k9yg7FfMS5Qss5B80eVA5XmZOi4f7DlEmJQL1sm11Fs3sKU4jYM9ryLV2W
         bK/fQRrGAllouwasdQVkJikz4Xdovcg9yDtnISwvW+UXR2Qr2AeHgvg7YRcqJyY8RUto
         Mn6s9Tgvh8nVeBI1xQ0zf+qVZkJodOR0MhtfsM4GjdcR+T0DvvR7DkiRo4xkfaFzFuw6
         2uo8nLOJeq4WUfO6annSAEWcr8XRtBVvYOKUS+zAQzfVViTeJwp2Tb4LuZEW8XmUVZaY
         7fZ2WiAl5v1rNtHRRXx/uCqIRGa54/t6Agi+Z+R/5umtgUx0kem/GTPuHKPcYOtOGwrP
         KOew==
X-Forwarded-Encrypted: i=1; AKwUvByagqJuS0PFN+QNIRnxxLZUoGMa/qSo37zmAWwOfwm0FH03YBkrrNW3/wAqwVvB6M94XrgzukP6eg==@kvack.org
X-Gm-Message-State: AFq9FYJl8+K3VpBoznu7G/BP2as5njZAC0YQf3t4BQubjzlyyWc5U1DF
	JCUejA0N8TNeZLRNPS5El1O1QbDS6VcGU9+V2z6nM07CiaZDhvDR3VWFs7YCLAW2NL383cRIMBQ
	zUh9Ra57H9nD0AQ==
X-Received: from pgbm22-n2.prod.google.com ([2002:a05:6a02:6196:20b0:cd6:a6ae:1ba0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:8001:b0:3e2:78bf:63d6 with SMTP id adf61e73a8af0-3e2a0c4a3a0mr1802376637.46.1792709457482;
 Thu, 22 Oct 2026 15:50:57 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:33 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-9-dmatlack@google.com>
Subject: [PATCH v2 08/10] mm/shmem_luo: Allow preserving tmpfs files that are
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C45CFA0007
X-Stat-Signature: sqxhcus6y7z66hs3i94hohfarajhg4sb
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792709458-91407
X-HE-Meta: U2FsdGVkX1+KTMvCBKdpRcCTYEtaNmzGInfWQzxpYKUYvEl8h/hBXQQlh0AuB2QpDbQ7WzAxa1XQOPLJAI4yNwjZtmIOpeg0CDbiYI/redgNpLDy0EfQhAMqWbmYBcXA9clg39ViCLblB2LcfTvGdhlHCtgzYJAOWwhEW3WAKA/ZqjISFebxFmcvnJDuLrRtSLY4SAnCKcclYP+s9v9EwNlOGR59Tn3mCa4PQST+lvDPVSvOyNlKc5N9IKsTo9u5e1H5VBPxTp0R6n5Y8/8cFc9T+KVFEpbAderMNPk60m4ccXs7NVsCwk3WCYXhs4Pc4uEwILJEpfFxIhRaLizReiLujPYsGiBC5ThLfnWv1ucINHPC06AmUObb4DfQ9xhkUpDWU0oG5xd6OwyRraG7ifqVyad2ds3T51x9gqfQrvFBBmCVu0QnraChrHxVOjggdl9jcotNW2ynovlHQxOqKvQGdjcWPCdGolejH+qaQcPX/f2ayTFyBRG352qdP4NMnfAV5S2IuFnK3KuqYTnHoi4mIH749KhxvT3s8GkFKQX8JlFcBx/0Shw+vu6Ns3UwaQlX7MsiIdYpb0N60BbaH4uBsRm+6duilMbMmgGG5oXvfSxjRvnwnDOse56tMmXk4sCvnekYTt9PkjTCtbGLRtOab4F41MINWJJ8rEslK4eoSnpeTR0OwMalmfunxoKMdT5Il06ykvbq4BA7NWChXnth7K2I1/7czpaiA6C/GLw4HOF4GRgh04/w8vuCD5fbzObMOBGxO2/QeQYos0HZCfoDeFViBdF9m6R85gZliYNuo4cmSyMiURLBQTk4EKD8grPSU6Xgj8tTRYrg+J2IlJzDXJ97Ft6LnwnOpd+1n4hW/g+Pfptn7FSzVM3+XJj+A4amJqu4z7Ja0eGDw5fB9UkSwBdKhR8e/MTPG7sf1QCsG6ezbgCGUyNUrn3EEOwy7mqOKkAAwuzkjfkb1q/
 JHF6gB7/
 feTK2kfKvi3pMxTNYjRGHHoaV2XNCYcl8z8nQPZllhkJ4sYaBDIgpRQ4zuKtnkoUlSh8M4DqHhALQNHSmylvnGJxS+83CW9/8CL3mIND71ixZa9IYy7pZSbhC79YUcu9rsRbf5wDWpmtpFI8IVLTvNBqRCS2dI5CdMVCJWJIf2N6B1MtLe0xqdKiwlCTvoyIQcF/ZxOe/yIKBwIwrIYPRLQRC4tt+WYGlHFLLz6cqB8tVrSt4vmgpaMYBgLKyED40JdHszoTV9rVa/+HW53OTTVaNR+b/oM6L43Q/jw8TAgpP8Ru+83GtwGyaLR4ykQIzImQERQSAQM8so9XCPOWpraUpqm43hmUoN+qOMUYU610VzZgaNhKnN1fI0E3Ix+Lob5yNvJlwguWu9UKZOF0R52wAEeTILtRDsQsvhMk69jfXzaC7BskRDhjZyMFeBNKlAvivrUHK8jbkG4zGYL3/FlrfCIAyvz2UNvXvY4a7Lz1bGllTAmJreFTdgsxnOjYplP4vZpNBfeCb4JcfO3ci2CvKBuVKVK2Qh0l9NuduGFPk/LMipgrHwO+/Pa+IzP3Q5CSDjrQYwnC1VsTItWgEAOL3TXiR5jZMiA43th5peLtJwvmYdm84aIk4Fe/tpYPIlfhOi7NhbnIfo0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_luo already accepts any shmem file without links, which includes
unlinked tmpfs files and files created with O_TMPFILE. Also accept tmpfs
files that are still linked, so that userspace doesn't have to unlink
files to preserve them and can keep using them by path until the live
update.

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
executed can still be preserved through read-only fds, nor a writable
mount. If the size of the file can't change anyway, because it is
immutable or on a read-only superblock, also let its owner preserve it.
Don't let others do that, since the size could change again once the
file is made writable.

Preserving a file also fills its holes, but don't require any permission
for that. Anyone who can read a tmpfs file can already fill its holes by
faulting them in through a read-only mapping, also on read-only mounts
and for immutable files.

Document the frozen size and the permission requirement.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/shmem_luo.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index ecbeb37d33a8..aba2bc1f18c5 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -28,6 +28,23 @@
  * the file are preserved. All others are reset to default. The preserved
  * properties are described below.
  *
+ * A tmpfs file can be preserved even if it is linked, but its path is not
+ * preserved. Userspace chooses where to put the file when retrieving it, as
+ * described in "Retrieving Tmpfs Files" below.
+ *
+ * Preserving a file requires permission to write to it, since preserving it
+ * affects all of its users, as described below. But the file doesn't need to
+ * be opened for writing. For example, a binary that is being executed can be
+ * preserved through a read-only file descriptor. The owner of a file whose
+ * size can't change anyway, because it is immutable or on a read-only
+ * superblock, may also preserve it. The file can be preserved through a
+ * read-only mount.
+ *
+ * While a file is preserved, its size can't change and no holes can be punched
+ * into it. Truncating the file, ``fallocate()`` and writes past the end of the
+ * file fail with ``-EPERM``. This applies to all users of the file, including
+ * users that open it by its path.
+ *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
  *    or tmpfs file are also not stable and are subject to backwards
@@ -298,6 +315,34 @@ static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	vfree(folios_ser);
 }
 
+/*
+ * Check whether the caller may preserve @file. Preserving the file freezes its
+ * size until it is unpreserved, for all users of the file, so require
+ * permission to write to the file. Like FS_IOC_ENABLE_VERITY, don't require a
+ * file opened for writing, so that e.g. a binary that is being executed can be
+ * preserved, nor a writable mount. If the size of the file can't change
+ * anyway, because it is on a read-only superblock or immutable, its owner may
+ * also preserve it. The size could only change again after the file is made
+ * writable, which is up to the owner or root.
+ *
+ * Preserving the file also fills its holes, but that doesn't need any
+ * permission: Anyone who can read the file can fill its holes by faulting
+ * them in through a read-only mapping.
+ */
+static int shmem_luo_may_preserve(struct file *file)
+{
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
+	struct inode *inode = file_inode(file);
+	int err;
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
@@ -307,6 +352,11 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	int err = 0, seals;
 
 	inode_lock(inode);
+
+	err = shmem_luo_may_preserve(args->file);
+	if (err)
+		goto err_unlock_inode;
+
 	shmem_freeze(inode, true);
 
 	/* Allocate the main serialization structure in preserved memory */
@@ -362,6 +412,7 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 	kho_unpreserve_free(ser);
 err_unlock:
 	shmem_freeze(inode, false);
+err_unlock_inode:
 	inode_unlock(inode);
 	return err;
 }
@@ -710,9 +761,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
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
2.56.0.257.gf7497c7d27-goog


