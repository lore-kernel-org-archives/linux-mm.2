Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2884DD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917916B008A; Thu, 29 Jan 2026 17:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFA56B0092; Thu, 29 Jan 2026 17:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A016B0093; Thu, 29 Jan 2026 17:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67C7E6B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:11:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A98614053D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:54 +0000 (UTC)
X-FDA: 84386399748.13.C40D72E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D3DF4000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Igm6//iy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0svptTBL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Igm6//iy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0svptTBL;
	spf=pass (imf01.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769724712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qtt0RdYPXv4g2o/M0kODeSloFfnDP7yUms1Q6RRBJ9I=;
	b=stuwh0FhsLT4pMlLoh1BRoM4C6NyFT1e/MjHBWhGKYWUeRFl5W/8kH1AF5zfpdXbfg/U5c
	63xwIQxP4hevR3udkkTPzyEFZyWG48X3pZv3WLtYBNlRTUEB+Y0chGxicUe5TD1tZrqui9
	hMP6e4og/vd70Dq8wTHZFlmkTqR95s8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769724712; a=rsa-sha256;
	cv=none;
	b=ZDB0p2/bFkwvQoYN1PArYRwmVHtMPcuvCt8wOZY3UyDbcELbWhj0Rz4fbzHe4AJpTKJfkz
	Las5+Qj4PlTtFJSzBlzhpbgX0kGkM0QDax40WQnYmicUlZqBRIxNluzIlFMDU+dnPgnPda
	q2dlbM1/MxtUjy1d6U3XskQ51pz2+ro=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Igm6//iy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0svptTBL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Igm6//iy";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0svptTBL;
	spf=pass (imf01.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 847CC34361;
	Thu, 29 Jan 2026 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qtt0RdYPXv4g2o/M0kODeSloFfnDP7yUms1Q6RRBJ9I=;
	b=Igm6//iyoDM4BQGBK/1y6++GdTrO9mAJZl1Dj/NnWRaHi1tKlCMSKmhKXt1zvUX3sSNpM3
	ltzgjljpHSMs2PjnOt7Y45x3dSdF5kwbn2qmzkjD1hCfiANoclAzbU4Dq2I0GDzbB+YGn8
	x5Gm25uaV/FCgGCpLfxAOHCnLMTKrOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qtt0RdYPXv4g2o/M0kODeSloFfnDP7yUms1Q6RRBJ9I=;
	b=0svptTBL2nDaPprStpVHVVW7UMrgA5kztPgLMSSmp/2slSW+zII+kdvMt5Frmn/Iurz3mb
	lro1Mxmr54ioxKAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qtt0RdYPXv4g2o/M0kODeSloFfnDP7yUms1Q6RRBJ9I=;
	b=Igm6//iyoDM4BQGBK/1y6++GdTrO9mAJZl1Dj/NnWRaHi1tKlCMSKmhKXt1zvUX3sSNpM3
	ltzgjljpHSMs2PjnOt7Y45x3dSdF5kwbn2qmzkjD1hCfiANoclAzbU4Dq2I0GDzbB+YGn8
	x5Gm25uaV/FCgGCpLfxAOHCnLMTKrOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qtt0RdYPXv4g2o/M0kODeSloFfnDP7yUms1Q6RRBJ9I=;
	b=0svptTBL2nDaPprStpVHVVW7UMrgA5kztPgLMSSmp/2slSW+zII+kdvMt5Frmn/Iurz3mb
	lro1Mxmr54ioxKAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 299FE3EA61;
	Thu, 29 Jan 2026 22:11:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 48eUOSXbe2kMbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:11:49 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
Date: Thu, 29 Jan 2026 17:11:38 -0500
Message-ID: <20260129221138.897715-3-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129221138.897715-1-krisman@suse.de>
References: <20260129221138.897715-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D3DF4000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kse4ikxrzk9n9a9phw3ch3gs5m96n9sq
X-HE-Tag: 1769724711-113923
X-HE-Meta: U2FsdGVkX18zZ04ZEqC9/yQOMOalfoluSemFApS7ovwEQyasFEul9VKNA8Spuux7GvuBh6nw3LI+VBpYixX1SXXCVHSptm6sYCZKJll1mwdz/lpoKM62lWsY1wPDykY2kX9tICQEEq6uUcpyJ+r9P8iXGxXlNELpsEILhX9DTm0IXnWKenUk0+Ju15zMLBXmEyFLaFaCdS89i8SbxI5HjjCAjqj/qYAIxkBSlh/jRdO19R0FvcOnZ6SkdiIKoGo7WvNBfzAlJ5V6l6d0/8QkC2GEYKQ+eh8d7z7x40YmaBKVAfx3+KXCkFzWJjo19LVf65CjRIFPl4YYw8vjATmghOUfdHidsYrdWTPScCQZqzgA97UHjDlZuNfDFFcGhG4o7QF6YzYoAvKzgHRhR8HL+R3O/09JfypuKN8H/ZKT3hww4tx7eiwlvbHQXGDDYWQbk0O90WYcPmEmayTXwAGrlncZZUHntJJMxugf4Exd2NFcuUV6Y0qbQIG+yCm8VJuqcHNeZn6jqX3s7BZ803gaaV0FXPqI9viE6FbMZ+5/wyKnOPWPqvA+rJSPMhsiKu1kGZ16LptnLVUGPzONfRVfKmnCARZGSX9N10jSazl1pDmQZeJjPrYzZIfmdqdR1+57wKApJ+RKOCtxh+cx0k2GsxMcDczfR+kjpVARKSL4EHDp/hlsSlR73pcMgp5MdICBYIbTdWkQ+kNSs/WY1Z88yRARz69o0+JbqE09FKhMQOWZVC4ko4iNxfFtr8Tg58XPR2E6bCROGKzXXPHqArHeHQK7wM9jKsUaZ5fGtcmNAjXTb4HswUVRbpnzEAsIsL0VgeoWi8fvWhCCWdBCBwQvLngKycHjhs/693cBHyASDONIxt2Ys0ZOvYMnhPRSBIfuHUPJ5X3E9953acLXdn3HnbwLd9jpsQp7AF33CK6nNBblzeUZ7grUNkMyzOkafLl1qRA9bH9OdIWudrQEyBK
 L0kN3mtw
 ZJ+zsmG2bfbmUxxB05xX3RurabqH+yARUStzlumSWZ6mKilWEBC1oMo0z8i1D5hiwV8l8RdciBLbnGYnz7OAujjeeTXev7FTh5ujsAR3ZT0Pm+uNdwTI0/a7Yc5JdV89+rvB04sEa+TfWsMPhSXR5Rqz4sAutD5hvyyMEspBcvReFNDGaBWky59QzYZMh3NtZIEyKnBPNrBpd6MzWZr7vrl2KrssTjjBv/XUPHFoBEr6ZSXpLk7YBFcfc4DEk0Y9Kgrc4X4m5lqzvKA0cINusAxD8ay4PRL30jWrE+qs8X9atTV36nSWUsTwhxRH9Q4eNiANw6pvwP0eL6QMGQ3axGaWTG66dHrjDCOQqe8dSquHyay15tqH8aCvvloTJjQTyEhh67iuKE2SUd4G/9hqWEDh/l4y4ZsjOkeLEVjrF4Cbwtk9gG3o4/pyqFppR0dV5jeRjvq3tyfmBRDXuXobDCIhuqmYIHRm7grf4/4TpwS75kuJaKMDvpnK62w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This enables mmap(2) over io_uring.  The interesting part is allowing
the mapping of multiple regions with different parameters in a single
operation. This is not explored in this patch, but coalescing multiple
operations can enable batching deeper in the MM layer.

The SQE provides an array of memory descriptors to be mapped backed by
fd, or to anonymous memory if fd == -1. All descriptors are mapped against
the same file, but protections and flags can vary.

The API also tries to be very clear about what failed in case of an
error. The number of maps that succeeded is returned on the CQE, and the
error code of the first failed map is passed back via the descriptor
structure (which must live until completion).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |  10 +++
 io_uring/Makefile             |   2 +-
 io_uring/mmap.c               | 147 ++++++++++++++++++++++++++++++++++
 io_uring/mmap.h               |   4 +
 io_uring/opdef.c              |   9 +++
 5 files changed, 171 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/mmap.c
 create mode 100644 io_uring/mmap.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..e24fe3b00059 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		mmap_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -303,6 +304,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_MMAP,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -1113,6 +1115,14 @@ struct zcrx_ctrl {
 	};
 };
 
+struct io_uring_mmap_desc {
+	void __user *addr;
+	unsigned long len;
+	unsigned long pgoff;
+	unsigned int prot;
+	unsigned int flags;
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..be0fa605f87d 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					statx.o timeout.o cancel.o \
 					waitid.o register.o truncate.o \
-					memmap.o alloc_cache.o query.o
+					memmap.o mmap.o alloc_cache.o query.o
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/mmap.c b/io_uring/mmap.c
new file mode 100644
index 000000000000..14b960707bb2
--- /dev/null
+++ b/io_uring/mmap.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/io_uring.h>
+#include <linux/hugetlb.h>
+#include <linux/mm.h>
+#include <linux/mm_inline.h>
+#include <linux/shm.h>
+#include <linux/mman.h>
+#include <linux/audit.h>
+#include "../mm/internal.h"
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "mmap.h"
+#include "rsrc.h"
+
+struct io_mmap_data {
+	struct file *file;
+	unsigned long flags;
+	struct io_uring_mmap_desc __user *uaddr;
+};
+struct io_mmap_async {
+	int nr_maps;
+	struct io_uring_mmap_desc maps[] __counted_by(nr_maps);
+};
+
+#define MMAP_MAX_BATCH 1024
+
+int io_mmap_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
+	struct io_mmap_async *maps;
+	int nr_maps;
+
+	mmap->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mmap->flags = READ_ONCE(sqe->mmap_flags);
+	nr_maps = READ_ONCE(sqe->len);
+
+	if (mmap->flags & MAP_ANONYMOUS && req->cqe.fd != -1)
+		return -EINVAL;
+	if (nr_maps < 0 || nr_maps > MMAP_MAX_BATCH)
+		return -EINVAL;
+	if (!access_ok(mmap->uaddr, nr_maps*sizeof(struct io_uring_mmap_desc)))
+		return -EFAULT;
+
+	maps = kzalloc(struct_size_t(struct io_mmap_async, maps, nr_maps),
+		       GFP_KERNEL);
+	if (!maps)
+		return -ENOMEM;
+	maps->nr_maps = nr_maps;
+
+	req->flags |= REQ_F_ASYNC_DATA;
+	req->async_data = maps;
+	return 0;
+}
+
+static int io_prep_mmap_hugetlb(struct file **filp, unsigned long *len,
+				int flags)
+{
+	if (*filp) {
+		*len = ALIGN(*len, huge_page_size(hstate_file(*filp)));
+	} else {
+		struct hstate *hs;
+		unsigned long nlen = *len;
+
+		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+		if (!hs)
+			return -EINVAL;
+		nlen = ALIGN(nlen, huge_page_size(hs));
+		*filp = hugetlb_file_setup(HUGETLB_ANON_FILE, nlen,
+					   VM_NORESERVE,
+					   HUGETLB_ANONHUGE_INODE,
+				   (flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+
+		if (IS_ERR(*filp))
+			return PTR_ERR(*filp);
+		*len = nlen;
+	}
+	return 0;
+}
+
+int io_mmap(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
+	struct io_mmap_async *data = (struct io_mmap_async *) req->async_data;
+	int i, mapped, ret;
+
+	if (unlikely(mmap->flags & MAP_HUGETLB && req->file &&
+		     !is_file_hugepages(req->file))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < data->nr_maps; i++) {
+		struct io_uring_mmap_desc *desc = &data->maps[i];
+
+		if (copy_from_user(desc, &mmap->uaddr[i], sizeof(*desc))) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+
+	mapped = 0;
+	while (mapped < data->nr_maps) {
+		struct io_uring_mmap_desc *desc = &data->maps[mapped++];
+		unsigned long flags = (mmap->flags | desc->flags);
+		unsigned long len = desc->len;
+		struct file *file = req->file;
+
+		/* These cannot be mixed and matched.  need to be passed
+		 * on the SQE.
+		 */
+		if (unlikely(desc->flags & (MAP_ANONYMOUS|MAP_HUGETLB))) {
+			desc->addr = ERR_PTR(-EINVAL);
+			break;
+		}
+		if (!(flags & MAP_ANONYMOUS))
+			audit_mmap_fd(req->cqe.fd, flags);
+
+		if (unlikely(flags & MAP_HUGETLB)) {
+			ret = io_prep_mmap_hugetlb(&file, &len, flags);
+			if (ret) {
+				desc->addr = ERR_PTR(-ret);
+				break;
+			}
+		}
+
+		desc->addr = (void *) vm_mmap_pgoff(file,
+					   (unsigned long) desc->addr,
+					   len, desc->prot, flags, desc->pgoff);
+		if (IS_ERR_OR_NULL(desc->addr))
+			break;
+	}
+
+	if (copy_to_user(mmap->uaddr, data->maps,
+			 sizeof(struct io_uring_mmap_desc)*mapped))
+		ret = -EFAULT;
+
+	ret = mapped;
+out:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
diff --git a/io_uring/mmap.h b/io_uring/mmap.h
new file mode 100644
index 000000000000..acddf6db76e7
--- /dev/null
+++ b/io_uring/mmap.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+int io_mmap_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_mmap(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index df52d760240e..679e413d2395 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -29,6 +29,7 @@
 #include "epoll.h"
 #include "statx.h"
 #include "net.h"
+#include "mmap.h"
 #include "msg_ring.h"
 #include "timeout.h"
 #include "poll.h"
@@ -593,6 +594,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_MMAP] = {
+		.prep			= io_mmap_prep,
+		.issue			= io_mmap,
+		.opt_file		= 1,
+	}
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -851,6 +857,9 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_MMAP] = {
+		.name			= "MMAP",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.52.0


