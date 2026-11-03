Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB3C606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IIfGSmgY
Received: by kanga.kvack.org (Postfix)
	id D4E976B05C5; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D053D6B05C6; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77756B05C7; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717286B05C5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02823A7C76
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:30 +0000 (UTC)
X-FDA: 85392007302.15.268D950
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4347A140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IIfGSmgY;
	spf=pass (imf09.hostedemail.com: domain of 3ozLpaggKCAwpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3ozLpaggKCAwpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667749;
	b=zJihB0TZiP8J+B2KLAEBndTkgcorPkMJZWPo62zM9nTPXEsjoehKDG5eg4/+PGiFNoB/MH
	Y+6EHk+XNmAmXNUJ8Oo8TxgJqS/cW3jEtBr5IudNZ3TsPP7pSdeYP0msAUef1n5deq/9ew
	hFwYDmkTOQBuhb+ofbmUYCdN+0A4+iE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IIfGSmgY;
	spf=pass (imf09.hostedemail.com: domain of 3ozLpaggKCAwpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3ozLpaggKCAwpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7dtpoDrnbOF8pPCwQW4elN2AdPDmTdqzG4LNV6q0TY=;
	b=Af2SH/uRunUiNkKfuxNYZrGz07YHclKhj0u6x1tvuhnAj7cJuD7UaXiJl2Sl2jz4KCs3GP
	xY2ouy3w5H3bnKljc9eyP9PW1Odv922BdRJjZ2ddLHupMTPggj1gdOALGppy1xIvG+2uh8
	jsiQ3ZBr06KGUk9BpP5m/o0536TRyoE=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ea785a4decso2113815ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667748; x=1794272548; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O7dtpoDrnbOF8pPCwQW4elN2AdPDmTdqzG4LNV6q0TY=;
        b=IIfGSmgYoJalDHG/ShdRoxB0zzynyORDsMQH69zfM2BkDbswXBN5GoqVG6680XptPB
         DjsctAxTZNHBKQ/6sxE4FMCUBhUeOALLtKbtxyOPcj15oYldMEHhj/YXhbfhzvvhUsIw
         LFeZeTAl9Y5Syy414/1f6bgA5lzysLTrtiZKK8KD3jUiXrLVhJrCtY9+sPwgUANJAqfH
         lMLPdCPXeQ8cD9QXRYdWuaNqNgYv6oNu5os3eAL0QZTjdfRdLx5RldVx9kk4Ehhub16r
         deEHBzEppzEuxNW4U4hhT3JYfN/0MQgyIJbfPp9msj47QV2stmX/MSo/lTD/qlhehO7o
         Ckhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667748; x=1794272548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O7dtpoDrnbOF8pPCwQW4elN2AdPDmTdqzG4LNV6q0TY=;
        b=u1qTwz+WGNOlAEnvrBPXtuE7gR/cE5MrqRvCIH/AzYf1b2/UvQR88lvUVJ4m12t2ow
         JXYlGYH7cx9yJyRJlzr4b2WSc1kNw31q04u7KAojaZ0fPJfZtDDRLqlmEC44LYy7S7nj
         KytFxIqhX4ZnEggZ9gCj8VX4utIFM1n/1M1WJlovuR0guNMLH4jXpht2mqCcDpNkXp21
         ysgGmpby4omFOOG3lbdBZg5d7Sr9GaLvqOGPVWRDCILo4p/Vb3rSEF8gdVin2/9R4rId
         FlHuXikO3Z61DWfURmQcIz2j4etuL9QnPOct1X4SLtc11wvLluG/QZaaEL/8d3QCScPh
         Qxeg==
X-Forwarded-Encrypted: i=1; AKwUvBy/p2vot36xWfnehLjvBSYIVjGvWgbuH4Og7deHbm+IWGHeV/qEH6M+OkuRoWNeEzJSwRfQTeK6Xg==@kvack.org
X-Gm-Message-State: APuU4Z/tZcQQnbIClzbMAZmjhu7urISbu7RRN8nzWYyLin7WzLnb1s2n
	AxpmP278kEJ5vA9P3R9bXqzXShsKOH6s58AFeJuf1F5hENUyZ0vH/ocDYzn7BTmkQXK4xOhnKRl
	pupwf/UfrAjWEDA==
X-Received: from plth3.prod.google.com ([2002:a17:902:7043:b0:2e2:ec03:928c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:320a:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2eb3640f62emr81045335ad.3.1793667747712;
 Mon, 02 Nov 2026 17:02:27 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:10 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-5-dmatlack@google.com>
Subject: [PATCH v3 04/10] mm: Rename memfd_luo to shmem_luo
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
X-Stat-Signature: r6nhei6mqnpya5m6wmrohut8j5cs6u9d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4347A140007
X-Spam-Status: No, score=-31.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793667749-766364
X-HE-Meta: U2FsdGVkX19vomsLP3RPfIrnPWU3lVPLyWYjqc7gCI7wNGJcfvFvzRnVCDa9i+mCVZH7VtijCrLSkqsShvtgalq4gOyVbkfvLcVQIG8NXq+VJJG4pSglraRUMy3UERzUIJoO/ID3FIE3GsvGdWZsE/8TuPLshuCct5N1q2NRTdpfv+SlXeuLsEyBWlfVoQGmMwHn0oUN9JhH+mWVMpQUzuN3Kq/qTPhnM8nlOoiD0Sp5HYigRLrmoJNf0unnm2FLIcm0H3SeXRN/B56/B4zOl5NXQ0D7se3iEucl5Fh9Z/Lv9ucqsbWkNGuAqRXv5UE+Iq+AhXmbxzbqhDIP9vtfd4wEQLQh0AhrrIbQj/auAdBx3qqNkVhGjfr90adp1qLY7ZkiJ1Hpj9AFSrUE36SA3xU1OCN2SBwypjW2X6IAvlWq4ani8tngzHaYyF64ygghJO6hsYr7p7xnWVa29ogTQy4O6kJx8bGvzydDGDOi5XBAeO3bmQCO3K2rZ/TrqEmHWiMkFTj9cuLU7wQ7PkoFKw6Bf0qqhJrYpcsNYpv86Hfky9rF9xaeGPjCaGxrfrQEtzkh9rv7DTHBhucHMVxKssoEBlKwlwooCCi4vsyBArBfXV5X0MzouMi8/9pRrjbV7Aoih+/1InMfeMmqH5gFrOULkUoWuQ9XWFMXlMHmEO5DxINcZbq1tYSrcf6AgIi4I5ncuphmh4osdgW9UIGsuouylH3lml2jphsd4kG8Me6B2oZNwKbkuvFRDat6p33bYtSv/YrJOd/vhsV3niMWo7zZjn4gyaz5NhrmCRVjMRxGDB7KcxZuHGo+ELy4rAVCjnZ+r/6QAGcruW9h7XTwWQvi44NwuI6JFglsgChsUyKQzV4xjy9ARWbHjEs0l/zk+rsLBIk61jhMTYcgDGHkcaWq3bSOdQQukBjTXLJZrv01cyrrczOTPEPv2KC3PGXFjaa3JUiTfOVD9B1tbfz
 gkPHKgt6
 KaK3k3434L49E2iYo5TSHFOa9xFLyFHpM/EwgOj+nxYWWyINBqR6eFX+NSWvA2bSOKb6Q0+8UMTX6vdFUfKL9GFxPAlAindvpic0L30C0gicMTUy3eTcPYijnPeAVVpAdlw6YoO/+h9vm19b9NtXxMueWN4vg6cOn9KQytZUp/R/faEiGc/gf66hFmzAhydZfCRUM681QW/71kynrqzXJqeHWhGwo9otfABWLKzpU1anO+7NDjhjhh0iT/uAiPjRtCK18Au7zpUF2BJruAoJUOPNYFhWd6LM4tMrjmnn2tDHvD+cfuLu6cI0pMucXf0p3MZnqr6764iD6jubKhUCUPa+oc4+gRor6NEZc+sGED2aq1epeW8C7LtT5uT24hwM6CsWlkQ5HdElxXzrW4bdKyKLa0dau+VfZRzSoK/d0otolqkimXsnrfPKWQ834BrlobgaRFF5DymoLOMN+FJFfKjtYbF7U7HD2gPzNjUksVxIpwWApT/LQ/AERy7pELwI/uBxT7imQTLL5kjjRenoaZZlkkIbY4a25O/dXPOmB7wiwLB1DpWFQ/jAhnQdTvxCFMCMUmpd9esM1gH7m24/W2ajxVK67JO/RYp/v1ZNwQrVsfQ2dagcCzB/nchepx0lofQFL5BQWFnvDwIxLUvTN+MoxvmZz6lfUUe4MZhiIxu0Xm62vsXuNzzUrOCEbrPXX0ePpYXjSTcaT5ycxbqefL2Q/bP9N+ICgczog
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rename the memfd Live Update file handler from memfd_luo to shmem_luo,
including the source file, its KHO ABI header, its documentation and its
Kconfig option (CONFIG_LIVEUPDATE_MEMFD to CONFIG_LIVEUPDATE_SHMEM).

The handler preserves shmem files. Today those are memfds, but following
commits extend it to other files on tmpfs mounts, for which the memfd
name is confusing. Preserving memfds created with MFD_HUGETLB, which are
hugetlbfs files, will need a separate handler, so naming the handler
after the filesystem that backs the files also avoids having to rename
it again then.

Don't change the compatible string of the handler, "memfd-v2". It is
matched against the preserved state from the previous kernel, so
changing it would break live updates from kernels that use the old
name. The serialized format doesn't change either.

Also clarify in the documentation that memfd means a memfd created
without MFD_HUGETLB, and name the ABI documentation after the handler.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/liveupdate.rst         |   2 +-
 Documentation/mm/index.rst                    |   2 +-
 ...reservation.rst => shmem_preservation.rst} |   8 +-
 MAINTAINERS                                   |   4 +-
 include/linux/kho/abi/{memfd.h => shmem.h}    |  41 ++++---
 kernel/liveupdate/Kconfig                     |   2 +-
 mm/Makefile                                   |   2 +-
 mm/{memfd_luo.c => shmem_luo.c}               | 115 +++++++++---------
 8 files changed, 89 insertions(+), 87 deletions(-)
 rename Documentation/mm/{memfd_preservation.rst => shmem_preservation.rst} (66%)
 rename include/linux/kho/abi/{memfd.h => shmem.h} (65%)
 rename mm/{memfd_luo.c => shmem_luo.c} (81%)

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 2bce2644eba2..669722002440 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -37,7 +37,7 @@ The following types of file descriptors can be preserved
 .. toctree::
    :maxdepth: 1
 
-   ../mm/memfd_preservation
+   ../mm/shmem_preservation
 
 Public API
 ==========
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c..b8ab2f89002d 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -61,7 +61,7 @@ documentation, or deleted if it has served its purpose.
    hugetlbfs_reserv
    ksm
    memory-model
-   memfd_preservation
+   shmem_preservation
    mmu_notifier
    multigen_lru
    numa
diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/shmem_preservation.rst
similarity index 66%
rename from Documentation/mm/memfd_preservation.rst
rename to Documentation/mm/shmem_preservation.rst
index c908a12dffa7..e79bf8afaa9e 100644
--- a/Documentation/mm/memfd_preservation.rst
+++ b/Documentation/mm/shmem_preservation.rst
@@ -4,16 +4,16 @@
 Memfd Preservation via LUO
 ==========================
 
-.. kernel-doc:: mm/memfd_luo.c
+.. kernel-doc:: mm/shmem_luo.c
    :doc: Memfd Preservation via LUO
 
 Memfd Preservation ABI
 ======================
 
-.. kernel-doc:: include/linux/kho/abi/memfd.h
-   :doc: memfd Live Update ABI
+.. kernel-doc:: include/linux/kho/abi/shmem.h
+   :doc: shmem Live Update ABI
 
-.. kernel-doc:: include/linux/kho/abi/memfd.h
+.. kernel-doc:: include/linux/kho/abi/shmem.h
    :internal:
 
 See Also
diff --git a/MAINTAINERS b/MAINTAINERS
index 5d1b58271989..742cdce14cf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15184,14 +15184,14 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/core-api/liveupdate.rst
-F:	Documentation/mm/memfd_preservation.rst
+F:	Documentation/mm/shmem_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
-F:	mm/memfd_luo.c
+F:	mm/shmem_luo.c
 F:	tools/testing/selftests/liveupdate/
 
 LLC (802.2)
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/shmem.h
similarity index 65%
rename from include/linux/kho/abi/memfd.h
rename to include/linux/kho/abi/shmem.h
index 08b10fea2afc..b61687e358a2 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/shmem.h
@@ -8,49 +8,50 @@
  * Pratyush Yadav <ptyadav@amazon.de>
  */
 
-#ifndef _LINUX_KHO_ABI_MEMFD_H
-#define _LINUX_KHO_ABI_MEMFD_H
+#ifndef _LINUX_KHO_ABI_SHMEM_H
+#define _LINUX_KHO_ABI_SHMEM_H
 
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
 
 /**
- * DOC: memfd Live Update ABI
+ * DOC: shmem Live Update ABI
  *
- * memfd uses the ABI defined below for preserving its state across a kexec
- * reboot using the LUO.
+ * The shmem file handler, which preserves memfds created without
+ * ``MFD_HUGETLB``, uses the ABI defined below for preserving their state across
+ * a kexec reboot using the LUO.
  *
- * The state is serialized into a packed structure `struct memfd_luo_ser`
+ * The state is serialized into a packed structure `struct shmem_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
  *
  * This interface is a contract. Any modification to the structure layout
  * constitutes a breaking change. Such changes require incrementing the
- * version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ * version number in the SHMEM_LUO_FH_COMPATIBLE string.
  */
 
 /**
- * MEMFD_LUO_FOLIO_DIRTY - The folio is dirty.
+ * SHMEM_LUO_FOLIO_DIRTY - The folio is dirty.
  *
  * This flag indicates the folio contains data from user. A non-dirty folio is
  * one that was allocated (say using fallocate(2)) but not written to.
  */
-#define MEMFD_LUO_FOLIO_DIRTY		BIT(0)
+#define SHMEM_LUO_FOLIO_DIRTY		BIT(0)
 
 /**
- * MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
+ * SHMEM_LUO_FOLIO_UPTODATE - The folio is up-to-date.
  *
  * An up-to-date folio has been zeroed out. shmem zeroes out folios on first
  * use. This flag tracks which folios need zeroing.
  */
-#define MEMFD_LUO_FOLIO_UPTODATE	BIT(1)
+#define SHMEM_LUO_FOLIO_UPTODATE	BIT(1)
 
 /**
- * struct memfd_luo_folio_ser - Serialized state of a single folio.
+ * struct shmem_luo_folio_ser - Serialized state of a single folio.
  * @pfn:       The page frame number of the folio.
  * @flags:     Flags to describe the state of the folio.
  * @index:     The page offset (pgoff_t) of the folio within the original file.
  */
-struct memfd_luo_folio_ser {
+struct shmem_luo_folio_ser {
 	u64 pfn:52;
 	u64 flags:12;
 	u64 index;
@@ -60,7 +61,7 @@ struct memfd_luo_folio_ser {
  * The set of seals this version supports preserving. If support for any new
  * seals is needed, add it here and bump version.
  */
-#define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
+#define SHMEM_LUO_ALL_SEALS (F_SEAL_SEAL | \
 			     F_SEAL_SHRINK | \
 			     F_SEAL_GROW | \
 			     F_SEAL_WRITE | \
@@ -68,7 +69,7 @@ struct memfd_luo_folio_ser {
 			     F_SEAL_EXEC)
 
 /**
- * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * struct shmem_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
@@ -76,9 +77,9 @@ struct memfd_luo_folio_ser {
  * @flags:     Flags for the file. Unused flag bits must be set to 0.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
- *             struct memfd_luo_folio_ser.
+ *             struct shmem_luo_folio_ser.
  */
-struct memfd_luo_ser {
+struct shmem_luo_ser {
 	u64 pos;
 	u64 size;
 	u32 seals;
@@ -87,7 +88,7 @@ struct memfd_luo_ser {
 	struct kho_vmalloc folios;
 } __packed;
 
-/* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+/* The compatibility string for the shmem file handler */
+#define SHMEM_LUO_FH_COMPATIBLE	"memfd-v2"
 
-#endif /* _LINUX_KHO_ABI_MEMFD_H */
+#endif /* _LINUX_KHO_ABI_SHMEM_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index f50daee8eff0..9a1c49e2e0c4 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -69,7 +69,7 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
-config LIVEUPDATE_MEMFD
+config LIVEUPDATE_SHMEM
 	bool "Live update support for memfd"
 	depends on LIVEUPDATE
 	depends on MEMFD_CREATE
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..cbdcc2c6b296 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_SHMEM) += shmem_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_BPF_SYSCALL
diff --git a/mm/memfd_luo.c b/mm/shmem_luo.c
similarity index 81%
rename from mm/memfd_luo.c
rename to mm/shmem_luo.c
index 6b68220275eb..b8d86055912d 100644
--- a/mm/memfd_luo.c
+++ b/mm/shmem_luo.c
@@ -18,6 +18,11 @@
  * Update Orchestrator (LUO) file preservation. This allows userspace to
  * transfer its memory contents to the next kernel after a kexec.
  *
+ * Here, a memfd is a memfd created without ``MFD_HUGETLB``, which is a shmem
+ * file on the kernel's internal shmem mount. Memfds created with
+ * ``MFD_HUGETLB`` are hugetlbfs files, which this file handler doesn't
+ * preserve. Preserving them fails with ``-ENOENT``.
+ *
  * The preservation is not intended to be transparent. Only select properties of
  * the file are preserved. All others are reset to default. The preserved
  * properties are described below.
@@ -26,10 +31,6 @@
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
  *    are also not stable and are subject to backwards incompatible changes.
  *
- * .. note::
- *    Currently a memfd backed by Hugetlb is not supported. Memfds created
- *    with ``MFD_HUGETLB`` will be rejected.
- *
  * Preserved Properties
  * ====================
  *
@@ -52,7 +53,7 @@
  *
  * Seals
  *   File seals set on the memfd are preserved and re-applied on restore.
- *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
+ *   Only seals known to this LUO version (see ``SHMEM_LUO_ALL_SEALS``) may
  *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
  *
  * Non-Preserved Properties
@@ -75,7 +76,7 @@
 #include <linux/file.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
-#include <linux/kho/abi/memfd.h>
+#include <linux/kho/abi/shmem.h>
 #include <linux/liveupdate.h>
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
@@ -84,13 +85,13 @@
 
 #include "internal.h"
 
-static int memfd_luo_preserve_folios(struct file *file,
+static int shmem_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
-				     struct memfd_luo_folio_ser **out_folios_ser,
+				     struct shmem_luo_folio_ser **out_folios_ser,
 				     u64 *nr_foliosp)
 {
 	struct inode *inode = file_inode(file);
-	struct memfd_luo_folio_ser *folios_ser;
+	struct shmem_luo_folio_ser *folios_ser;
 	unsigned int max_folios;
 	long i, size, nr_pinned;
 	struct folio **folios;
@@ -145,7 +146,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 	}
 
 	for (i = 0; i < nr_folios; i++) {
-		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio = folios[i];
 
 		err = kho_preserve_folio(folio);
@@ -196,7 +197,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
-		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
+		pfolio->flags = SHMEM_LUO_FOLIO_DIRTY | SHMEM_LUO_FOLIO_UPTODATE;
 		pfolio->index = folio->index;
 	}
 
@@ -227,8 +228,8 @@ static int memfd_luo_preserve_folios(struct file *file,
 	return err;
 }
 
-static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
-					struct memfd_luo_folio_ser *folios_ser,
+static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
+					struct shmem_luo_folio_ser *folios_ser,
 					u64 nr_folios)
 {
 	long i;
@@ -239,7 +240,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	kho_unpreserve_vmalloc(kho_vmalloc);
 
 	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio;
 
 		if (!pfolio->pfn)
@@ -254,11 +255,11 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	vfree(folios_ser);
 }
 
-static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
+static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
-	struct memfd_luo_folio_ser *folios_ser;
-	struct memfd_luo_ser *ser;
+	struct shmem_luo_folio_ser *folios_ser;
+	struct shmem_luo_ser *ser;
 	u64 nr_folios, inode_size;
 	int err = 0, seals;
 
@@ -279,7 +280,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	}
 
 	/* Make sure the file only has the seals supported by this version. */
-	if (seals & ~MEMFD_LUO_ALL_SEALS) {
+	if (seals & ~SHMEM_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
 		goto err_free_ser;
 	}
@@ -299,7 +300,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	ser->size = inode_size;
 	ser->seals = seals;
 
-	err = memfd_luo_preserve_folios(args->file, &ser->folios,
+	err = shmem_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
 	if (err)
 		goto err_free_ser;
@@ -320,9 +321,9 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	return err;
 }
 
-static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
+static int shmem_luo_freeze(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_ser *ser;
+	struct shmem_luo_ser *ser;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
@@ -338,10 +339,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 	return 0;
 }
 
-static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
+static void shmem_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
-	struct memfd_luo_ser *ser;
+	struct shmem_luo_ser *ser;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return;
@@ -351,20 +352,20 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 
-	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
+	shmem_luo_unpreserve_folios(&ser->folios, args->private_data,
 				    ser->nr_folios);
 
 	kho_unpreserve_free(ser);
 	inode_unlock(inode);
 }
 
-static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_ser,
+static void shmem_luo_discard_folios(const struct shmem_luo_folio_ser *folios_ser,
 				     u64 nr_folios)
 {
 	u64 i;
 
 	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio;
 		phys_addr_t phys;
 
@@ -383,10 +384,10 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 	}
 }
 
-static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+static void shmem_luo_finish(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
-	struct memfd_luo_ser *ser;
+	struct shmem_luo_folio_ser *folios_ser;
+	struct shmem_luo_ser *ser;
 
 	/*
 	 * If retrieve was successful, nothing to do. If it failed, retrieve()
@@ -405,7 +406,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 		if (!folios_ser)
 			goto out;
 
-		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+		shmem_luo_discard_folios(folios_ser, ser->nr_folios);
 		vfree(folios_ser);
 	}
 
@@ -413,8 +414,8 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	kho_restore_free(ser);
 }
 
-static int memfd_luo_retrieve_folios(struct file *file,
-				     struct memfd_luo_folio_ser *folios_ser,
+static int shmem_luo_retrieve_folios(struct file *file,
+				     struct shmem_luo_folio_ser *folios_ser,
 				     u64 nr_folios)
 {
 	struct inode *inode = file_inode(file);
@@ -425,7 +426,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	long i;
 
 	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
 		phys_addr_t phys;
 		u64 index;
 		int flags;
@@ -463,9 +464,9 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			goto unlock_folio;
 		}
 
-		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
+		if (flags & SHMEM_LUO_FOLIO_UPTODATE)
 			folio_mark_uptodate(folio);
-		if (flags & MEMFD_LUO_FOLIO_DIRTY)
+		if (flags & SHMEM_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
 		npages = folio_nr_pages(folio);
@@ -497,7 +498,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	 * freed when the file is freed. Free the ones not added yet here.
 	 */
 	for (long j = i + 1; j < nr_folios; j++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+		const struct shmem_luo_folio_ser *pfolio = &folios_ser[j];
 		phys_addr_t phys;
 
 		if (!pfolio->pfn)
@@ -514,10 +515,10 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	return err;
 }
 
-static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
+static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
-	struct memfd_luo_ser *ser;
+	struct shmem_luo_folio_ser *folios_ser;
+	struct shmem_luo_ser *ser;
 	struct file *file;
 	int err;
 
@@ -526,7 +527,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 		return -EINVAL;
 
 	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
 		goto free_ser;
 	}
@@ -558,7 +559,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 			goto put_file;
 		}
 
-		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
+		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
 		vfree(folios_ser);
 		if (err)
 			goto put_file;
@@ -576,7 +577,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	return err;
 }
 
-static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
+static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
 	struct inode *inode = file_inode(file);
@@ -584,30 +585,30 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 	return shmem_file(file) && !inode->i_nlink;
 }
 
-static unsigned long memfd_luo_get_id(struct file *file)
+static unsigned long shmem_luo_get_id(struct file *file)
 {
 	return (unsigned long)file_inode(file);
 }
 
-static const struct liveupdate_file_ops memfd_luo_file_ops = {
-	.freeze = memfd_luo_freeze,
-	.finish = memfd_luo_finish,
-	.retrieve = memfd_luo_retrieve,
-	.preserve = memfd_luo_preserve,
-	.unpreserve = memfd_luo_unpreserve,
-	.can_preserve = memfd_luo_can_preserve,
-	.get_id = memfd_luo_get_id,
+static const struct liveupdate_file_ops shmem_luo_file_ops = {
+	.freeze = shmem_luo_freeze,
+	.finish = shmem_luo_finish,
+	.retrieve = shmem_luo_retrieve,
+	.preserve = shmem_luo_preserve,
+	.unpreserve = shmem_luo_unpreserve,
+	.can_preserve = shmem_luo_can_preserve,
+	.get_id = shmem_luo_get_id,
 	.owner = THIS_MODULE,
 };
 
-static struct liveupdate_file_handler memfd_luo_handler = {
-	.ops = &memfd_luo_file_ops,
-	.compatible = MEMFD_LUO_FH_COMPATIBLE,
+static struct liveupdate_file_handler shmem_luo_handler = {
+	.ops = &shmem_luo_file_ops,
+	.compatible = SHMEM_LUO_FH_COMPATIBLE,
 };
 
-static int __init memfd_luo_init(void)
+static int __init shmem_luo_init(void)
 {
-	int err = liveupdate_register_file_handler(&memfd_luo_handler);
+	int err = liveupdate_register_file_handler(&shmem_luo_handler);
 
 	if (err && err != -EOPNOTSUPP) {
 		pr_err("Could not register luo filesystem handler: %pe\n",
@@ -618,4 +619,4 @@ static int __init memfd_luo_init(void)
 
 	return 0;
 }
-late_initcall(memfd_luo_init);
+late_initcall(shmem_luo_init);
-- 
2.56.0.385.gac671c819a-goog


