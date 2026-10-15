Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51A2CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306706B009B; Thu, 15 Oct 2026 05:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFBE6B009D; Thu, 15 Oct 2026 05:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B436B009E; Thu, 15 Oct 2026 05:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA4676B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6103CA864A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:38 +0000 (UTC)
X-FDA: 85324360716.11.A92CA1C
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 983F540002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iN8hkYfA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nt5koYeNjqdzKeqQpmJI32L3fCUQ2SB26pb7zJ3MlRw=;
	b=FYbEgwczE9u4nfBa2xl0EFLsYrZXz55hUaopzO+8qVTHj26ZK02MOVfofXVcgjRN6KS+41
	CFvGPy4WjXY7Oa2QDNf9m//C5ro+o0LAJuGFbrZUF55RT61CoOi6v4rgnFSoPZDJZhWxkv
	Bmcbj1KulZv9x/GVuZRFepue1hiDVyw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iN8hkYfA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057116;
	b=il8yFo1nNcqNvyUFkgyrSc2XXgjfDbhLccgezvU4XMVf1WVbeB6SB82NIU/4QYk3FGGgIW
	+824NYs72AYEekP7YmMFo0vrw3tsWJh0QPQdKMtQBwEXrNiiSv2gCraceEjvTxOJYZNZod
	r/7KvLx3HQYJUJvGF5H7lgUXruIxjyk=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-74ab6c88052so467961137.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057116; x=1792661916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Nt5koYeNjqdzKeqQpmJI32L3fCUQ2SB26pb7zJ3MlRw=;
        b=iN8hkYfAorLz5nRW1yx9hegGsLFMlcTYfmkf7b4fEY+sRyjPsede+StMHp3ms0RVYm
         sXRlnyk9ia92T42k2Qjuu5dzMgYylE4XJPzuuUAia5zgyCmrZjMv6KYbFNxi3xjColO9
         Wxk4Z3K7TtHoN06vjGfKWId6uDxhPCd2D02Y31Hp6E1rJ85cNJ7TG81d7TR4eUzpL82n
         ln18Wv2G0/rODAJ0I0RcK4NSb3/fu+ro58j31uXFpW9i+a5wkbKKIc5Ldfb9RmjtfWvA
         ttsF1Dv8FocgmvgkgUSLYuGxoVEgsP/XxHnWOdfgREhOPJbUStzNcEly3tFuCxnF09r4
         gt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057116; x=1792661916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Nt5koYeNjqdzKeqQpmJI32L3fCUQ2SB26pb7zJ3MlRw=;
        b=jkfdPHzAQzVwfLtJbh4FC3X+Ka/FgZ1vwqR+tNtQJ33Y5US8V+GAZCJ1J2di84j3DZ
         4xEcEeos/EhE1Q+BESgoAd9Ob6Ae5mW1TiuOVUFKhdTCuWgcUSbfmu+6D7GcMciboVOP
         o22yu1Q6bIzBZ/fhAPCZ/JwkklgF1reXAYChWnS5TBJrA0jSfsTpotPbqDfsPyuF9qJn
         DP3sc9VIUHmScAyiG0MgrycWWhNoiwSmJof+rrtYR94ySDPNuRvw/oNQplh8dZirLwh9
         pxGDuZ3c1RtNCw7lQv+0P4STlCOsc6WbvMSfqAZ9PhmimoVyUGrCB2Uy0IuBTI5zyHJN
         fqKg==
X-Forwarded-Encrypted: i=1; AKwUvByPzmiwCC/yc3f3k2lvA9l90kxlbIlHzwSa5bveVWbL75FnNlOfmynSLN9PG8k9XwARALn/i+3hxQ==@kvack.org
X-Gm-Message-State: AFq9FYK6Uoj/AqLXwvm2zCTpopqGFLq2qEQi/MUAZPXemJDHL2CmRiCy
	XKjr73e7Cwk+LrcG/Lu3nxnVoTmlJiF4NVL2hdRFtWdKWSq0B2ANuQzJaX4lyM6d8HI=
X-Gm-Gg: AYBFou2IbMkiUMPx+6mTi8bx1xjgfu07y3oW7XkNxn/K01tI8Hz+hGAoQNzQJyy3GK3
	IfcBUBlu49JKZT+9e0Pvl3K39F3gZIqmAV/R5eNpLTnK7CyyyhbEEWDDqmqqwWYSsXncCRaZdVZ
	hTAA4D+GAMxAnDIXIkNj36n53OwcpJxjdGbAcPe0S7qA1dwm18FCGA0tkILZMagn1oNcehzwchq
	toBs8UyRjPnl0uDtef8k6qnMejMC/clx8VldEkJ/5sxrtaDw/kSXgyoi2sELr7yMBDsUVAI6DwJ
	E/0Ob+jdIyO/HqkH3J1i9Q6upy4xbZ8Sx4+a9RE0DV7d4a2zk+8jD3me8tDL4jU1d/zndwVF7Co
	oMHOkicq/3j35BYjxZxdJwOqRPnjx+DU66gVhujBuiabqj77oM74Q7STBP6ZWf+6iYsrrT7fV7r
	90jvrGPJG2negiV7Ryct/0UEx0r48v2qbWrJvdeFmheNj39olD52SoCVIE3Us4TGmrSPSEATSr6
	GeNO7qQMsFAh8MqPrj1ovBUKCuVMucOe/HmzqxEDWoUvvFksjkLm5a8iIxIPnUjqKX360Au9W/n
	pYALJalEF3QDxrFCY84=
X-Received: by 2002:a05:6102:448c:b0:7c3:1d7:f234 with SMTP id ada2fe7eead31-7cb36788160mr4679901137.2.1792057115645;
        Thu, 15 Oct 2026 02:38:35 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 6/7] mm/memfd_luo: Support tmpfs preservation and retrieval
Date: Thu, 15 Oct 2026 05:38:15 -0400
Message-ID: <20261015093816.2438942-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 983F540002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: z5ihwarxqsdkw8d77y95p14piqzr9x8c
X-HE-Tag: 1792057116-641508
X-HE-Meta: U2FsdGVkX19jyoO4XC3gL61GToTjUCIh3kawOk2xCzkH6XZoML+Tdsu7veFI7+kV9G3qtqPEQhS2SklTPW6IRb35gTMBGIChvdMpkJv+c/RYFVN159Idc06+LZ0BKj89HCJuuN5qz++Bk+3mwvKg1tO3CWrV5YMFoThmksRftKojVYNovVmrU+hghiFn7JS6JWckBKfgDQfqHWLDvLL3dv6hygs2VuLlpxd8iHtGax5acx1WrvMFNwyajiBIe6bklfSeiPN+ioITOMCvj372HLYcXnDP9uE4tcow/4XN0EvDUmSoSB4WMZLvUyaqUYW7qfm/HN4hF/aMMAIsZsYV+/ajX7elXtCfez/dvgmWt4B8XBNH512pBcZPmq0B7Sx/5eqtTAXYsI4LdTPH1j7eT0EpSFfuu7tKcIiv41cr/pYg17RnK2b4xqgaG3pce7eIqHx22X2et19IrGnqYWGUta676fS2JnBtFYRxvFsjJti3jeQDAqLTE/NvZ3hQ3GyBXWucrgKar17prqnblaULxNpNIB1jzN7/aDl0aAuc4u50u9DoGezoTkj1rj3QvxQqOEdwrEoSAZ07K5ZuFy8Mk3VVGaUG7CKnQ6M4qWFXqfmmALuFz2y5NJBCCxP0/QorqFcKCa4PDsR6Htqkn1qwpVwG53SvwYsCFZVbqGdDvJbmhDwXYHW1XGkhgllcOqOIW7O6Vn1seiKQQkhXn2jnV4tnT8CVISzNFmZ6XFxFtyIUH/jukEjpZ2RQy55D22GkfTkuX1nbczz3z0vJ0K1NyU0tG3wV8qfpv5VZ9JRCuzUFvJmTV+1LM06ThhNdEFpRHN4GB8ru51iIm+fv+XyGY2zIREMnEVzitt5OLbPDmYJnlOdwy9Haq5KtW5HBSXEEqj7gKN2Tvkh90dCFhdDIGhiQEc6VFJ8kkycVNzUbVMSs7ugqCS7bvy3l9Bym9Dvw3EYck8/4rIpIQ9aTi9c
 A6rJCY5g
 KU7PnxeG2Lw3UFCE0ezJzhjcCe//vZIUoWRBZ881Z2dEWocW587IoVX1G547/tPstuWQGwZATJLnAGOSTooWdwnk6GHL2zgm+Z4Zf1tbzJfPa6XomEjumyu++1J0ZIAFr8Ovt1W+oMlUvXIkZ7rBom8CfOCzvxpgkJYBcABDgaJL46wpCnQWiw602/U70A+taKhQc7QRigioQ/fq8kKLCk9NcFg5pCLfEA3d5RUeOLwYbbpXZ04ziIWmdqf0bvnlIXfrl/UB7VoqdiVE08brG+o/AkBkBCFLF5K7OzQ1kORWKBLOKjACNnPrxn9RPmtjYqfOVH9DqL2g3Q5cbSCu/iOL5isMN1fyIlyNrxOVuPZCgTwlQn7Rii+lOsQUeQeAAcw+YWQwEO5PjTsnWtf6ebYcpuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Relax memfd_luo_can_preserve() to allow general shmem-backed files beyond
unlinked memfd pseudofiles, enabling userspace to preserve standard
tmpfs files across kexec.

Record MEMFD_LUO_FLAG_TMPFS in struct memfd_luo_ser.flags when a linked
tmpfs file is preserved so that tmpfs files must be retrieved as tmpfs
files and anonymous memfd files must be retrieved as memfd files.

To support restoring preserved tmpfs folios to a newly created tmpfs
file on the post-kexec filesystem, introduce struct
liveupdate_memfd_retrieve_arg in the UAPI and wire it up via .rarg on
memfd_luo_file_ops. When retrieving a preserved tmpfs file,
memfd_luo_retrieve() requires this argument, validates that the
specified file descriptor is a writable, empty, linked tmpfs file not
already claimed by LUO, locks its inode, and populates its address space
with the preserved folios. Validation failures on the user-provided
retrieve argument are marked retryable so userspace can retry
LIVEUPDATE_SESSION_RETRIEVE_FD without losing the preserved state.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/memfd.h   |  13 ++-
 include/uapi/linux/liveupdate.h |  21 +++++
 mm/memfd_luo.c                  | 139 +++++++++++++++++++++++++-------
 3 files changed, 141 insertions(+), 32 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc8..47ff5ab967501 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -68,7 +68,18 @@ struct memfd_luo_folio_ser {
 			     F_SEAL_EXEC)
 
 /**
- * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * MEMFD_LUO_FLAG_TMPFS - The preserved file is a tmpfs file.
+ *
+ * Indicates the file was preserved from a linked tmpfs file rather than an
+ * anonymous memfd, and must be retrieved to an empty tmpfs file.
+ */
+#define MEMFD_LUO_FLAG_TMPFS		BIT(0)
+
+/* The set of flags this version supports preserving. */
+#define MEMFD_LUO_ALL_FLAGS		MEMFD_LUO_FLAG_TMPFS
+
+/**
+ * struct memfd_luo_ser - Main serialization structure for a memfd or tmpfs file.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 0ab28fd58fa5f..24e938d91392c 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -268,4 +268,25 @@ struct liveupdate_session_freeze {
 #define LIVEUPDATE_SESSION_FREEZE					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FREEZE)
 
+/**
+ * struct liveupdate_memfd_retrieve_arg - Argument for tmpfs file retrieval
+ * @size: Input; sizeof(struct liveupdate_memfd_retrieve_arg)
+ * @fd:   Input; Writable, empty, linked tmpfs file descriptor to restore into.
+ *
+ * Passed via &struct liveupdate_session_retrieve_fd.arg on
+ * %LIVEUPDATE_SESSION_RETRIEVE_FD. This argument is required when retrieving
+ * a preserved linked tmpfs file and is rejected with -EINVAL when retrieving
+ * an anonymous memfd.
+ *
+ * @fd must refer to a writable, empty, linked tmpfs file that is not already
+ * claimed by LUO. On success, the file is populated with the preserved folios,
+ * its size and f_pos are restored, and the file descriptor returned in
+ * &struct liveupdate_session_retrieve_fd.fd references the same underlying open
+ * file description as @fd.
+ */
+struct liveupdate_memfd_retrieve_arg {
+	__u32		size;
+	__s32		fd;
+};
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 26929495786e0..9d18f01191c07 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -9,14 +9,14 @@
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
+ * Memory file descriptors and generic tmpfs files can be preserved over a
+ * kexec using the LUO file preservation. This allows userspace to transfer its
+ * memory contents to the next kernel after a kexec.
  *
  * The preservation is not intended to be transparent. Only select properties of
  * the file are preserved. All others are reset to default. The preserved
@@ -24,16 +24,17 @@
  *
  * .. note::
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
- *    are also not stable and are subject to backwards incompatible changes.
+ *    or tmpfs file are also not stable and are subject to backwards
+ *    incompatible changes.
  *
  * .. note::
- *    Currently a memfd backed by Hugetlb is not supported. Memfds created
+ *    Currently a file backed by Hugetlb is not supported. Memfds created
  *    with ``MFD_HUGETLB`` will be rejected.
  *
  * Preserved Properties
  * ====================
  *
- * The following properties of the memfd are preserved across kexec:
+ * The following properties of the memfd/tmpfs file are preserved across kexec:
  *
  * File Contents
  *   All data stored in the file is preserved.
@@ -300,6 +301,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 
 	ser->size = inode_size;
 	ser->seals = seals;
+	if (inode->i_nlink)
+		ser->flags |= MEMFD_LUO_FLAG_TMPFS;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -516,10 +519,60 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	return err;
 }
 
+static struct file *memfd_luo_get_tmpfs_file(struct liveupdate_file_op_args *args)
+{
+	const struct liveupdate_memfd_retrieve_arg *rarg = args->arg;
+	struct inode *inode;
+	struct file *file;
+	int err;
+
+	if (!rarg)
+		return ERR_PTR(-EINVAL);
+
+	file = fget(rarg->fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (!(file->f_mode & FMODE_WRITE)) {
+		err = -EACCES;
+		goto put_file;
+	}
+
+	if (!shmem_file(file)) {
+		err = -EINVAL;
+		goto put_file;
+	}
+
+	inode = file_inode(file);
+	inode_lock(inode);
+	if (!inode->i_nlink) {
+		err = -EINVAL;
+		goto unlock_inode;
+	}
+
+	if (i_size_read(inode) != 0 || !mapping_empty(inode->i_mapping)) {
+		err = -EBUSY;
+		goto unlock_inode;
+	}
+
+	err = liveupdate_claim_file(args->handler, file);
+	if (err)
+		goto unlock_inode;
+
+	return file;
+
+unlock_inode:
+	inode_unlock(inode);
+put_file:
+	fput(file);
+	return ERR_PTR(err);
+}
+
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
+	struct inode *inode;
 	struct file *file;
 	int err;
 
@@ -527,50 +580,75 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
-	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+	/* Make sure the file only has seals and flags supported by this version. */
+	if ((ser->seals & ~MEMFD_LUO_ALL_SEALS) ||
+	    (ser->flags & ~MEMFD_LUO_ALL_FLAGS)) {
 		err = -EOPNOTSUPP;
 		goto free_ser;
 	}
 
-	/*
-	 * The seals are preserved. Allow sealing here so they can be added
-	 * later.
-	 */
-	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
-	if (IS_ERR(file)) {
-		pr_err("failed to setup file: %pe\n", file);
-		err = PTR_ERR(file);
-		goto free_ser;
-	}
+	if (ser->flags & MEMFD_LUO_FLAG_TMPFS) {
+		file = memfd_luo_get_tmpfs_file(args);
+		if (IS_ERR(file)) {
+			args->retryable = true;
+			return PTR_ERR(file);
+		}
+		inode = file_inode(file);
+	} else {
+		if (args->arg) {
+			args->retryable = true;
+			return -EINVAL;
+		}
 
-	err = memfd_add_seals(file, ser->seals);
-	if (err) {
-		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
-		goto put_file;
-	}
+		/*
+		 * The seals are preserved. Allow sealing here so they can be
+		 * added later.
+		 */
+		file = memfd_alloc_file("", MFD_ALLOW_SEALING);
+		if (IS_ERR(file)) {
+			pr_err("failed to setup file: %pe\n", file);
+			err = PTR_ERR(file);
+			goto free_ser;
+		}
 
-	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	i_size_write(file_inode(file), ser->size);
+		err = memfd_add_seals(file, ser->seals);
+		if (err) {
+			pr_err("failed to add seals: %pe\n", ERR_PTR(err));
+			goto put_file;
+		}
+
+		inode = file_inode(file);
+		inode_lock(inode);
+	}
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
 			err = -EINVAL;
-			goto put_file;
+			goto unclaim_file;
 		}
 
 		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
 		vfree(folios_ser);
 		if (err)
-			goto put_file;
+			goto unclaim_file;
 	}
 
+	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
+	i_size_write(inode, ser->size);
+	inode_unlock(inode);
+
 	args->file = file;
 	kho_restore_free(ser);
 
 	return 0;
 
+unclaim_file:
+	if (ser->flags & MEMFD_LUO_FLAG_TMPFS) {
+		shmem_truncate_range(inode, 0, (loff_t)-1);
+		liveupdate_unclaim_file(args->handler, file);
+	}
+	inode_unlock(inode);
 put_file:
 	fput(file);
 free_ser:
@@ -581,9 +659,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
-	struct inode *inode = file_inode(file);
-
-	return shmem_file(file) && !inode->i_nlink;
+	return shmem_file(file);
 }
 
 static unsigned long memfd_luo_get_id(struct file *file)
@@ -599,6 +675,7 @@ static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.unpreserve = memfd_luo_unpreserve,
 	.can_preserve = memfd_luo_can_preserve,
 	.get_id = memfd_luo_get_id,
+	.rarg = LIVEUPDATE_ARG(struct liveupdate_memfd_retrieve_arg, fd),
 	.owner = THIS_MODULE,
 };
 
-- 
2.56.0.385.gd3acb90ef8-goog


