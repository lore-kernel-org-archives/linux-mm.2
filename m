Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9E3606A6AF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oxxOpZE5
Received: by kanga.kvack.org (Postfix)
	id 6FBC16B05B6; Mon, 23 Nov 2026 18:39:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3356B05B7; Mon, 23 Nov 2026 18:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573E36B05B8; Mon, 23 Nov 2026 18:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1758A6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83386C0884
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:38 +0000 (UTC)
X-FDA: 85468003236.30.5AC4196
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF34820002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oxxOpZE5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3t84EawgKCMYpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3t84EawgKCMYpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477176;
	b=A2JpBEumXl1F4OTNF8tpgWZ9Eur8KrlZJtwDRTaNfBGzqW2BlCLEgJ5jjxpemxhnpe47EH
	miWdrUU9kHj32gqOhag4eDBHkHl77ZbaK8VqfIZhfeH+z1nN2Ubhnv5Ui1ucDBHeTWbJc8
	koycg90bbDXsyAIh5WpLInHGF1uEqs0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8beWjy4hFtgyIKlP0nWINNKkgc8a6fDNrCjBZEqSR/o=;
	b=nY5lL8gnAdwneJ+dDSWorb5Ssvm1oDNWC/TCf6viv+WxSnwkm3T1gMd5Co7HWcuZHzJgn3
	POY06qbnQ5NF2RZJ0np3320O5ai7rr6azgGd646yjNQuiFEkCMbq/12CxO5W86n9MhpE2C
	NvWgXeowWTDrmbsZ93tEM2OK3D4ISDM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oxxOpZE5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3t84EawgKCMYpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3t84EawgKCMYpym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e937c5bd4fso3393197b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477176; x=1796081976; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8beWjy4hFtgyIKlP0nWINNKkgc8a6fDNrCjBZEqSR/o=;
        b=oxxOpZE5aobLccCGAVeXHmrcS5uwr0xUBlQq4yAe2LV4PxPJUVIdtvsjaS0CXy1LLN
         at38U/ttyTc1UfWlO/SmOIZJK6FVc/jVNzH8Ivb77CLo89PEbd5ehc8gHUgmBID5d4lA
         gy8OAxTWOZrMzj0Fs117qeQdyLZDTdExq98fMFRh+UPvvKmPQxoJBtIx1mL2EjvCgHAC
         8mUzvk0u4y1GsYIofd2JR+mDiTu1HnGT01X1f+LK4+tRIfSOPY1mtZ8ppCuyJfTqPWQ9
         9nJXEHtPM52LD56g7ooWuNEC35+ooQ7tIEAk65thqce4NtvijA52PiLWNwtV4Lp0kiNW
         wkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477176; x=1796081976;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8beWjy4hFtgyIKlP0nWINNKkgc8a6fDNrCjBZEqSR/o=;
        b=XmAvykZYomAjdnuNpYMliy162OLyDE+eqJYKuoizRbA1tyyGNcRqCtumYsheBbNYnw
         2Ij2gloM/SOY/zs8/XZMQrQNVP6or8/q9U7j4XuUsJ/4aDQQt/hBGK9UWVVV5+gwovAw
         G0qmLoa/AdRR4XbZpFVaU1IODse7f1Xwljag7XLtfIqGfhCDmZ4RYYXDOdYVW0UunHPN
         NEPYYcsXbfA3u/+5Zd5eVUlYXK445TFf8ZhWqcG0gjElmifjCn0ENl0h19aTrMr8IZkd
         lImxOHsZvkDZ++oO7jnAm4qXh1MAh4pbQeYfc9T9MSv8GRFXiUdgQPzK5PWf6pBE98eS
         Px/Q==
X-Forwarded-Encrypted: i=1; AL+hErHKmEOWPowwZ1IWQY3ttBIEAPivRHlL/SYLNBSHWGgla6axD3PAKaSD/eEEItsq3+lYP75ZLIFCRw==@kvack.org
X-Gm-Message-State: APuU4Z9XdXgKqucV7bo/117iukyohMSZxGcwP8TGkFTMmCcEgCy+I7C9
	uTiPPCwwwfM7/HwXIof0+ozbwaSPPEnqp1lErdBOnTdGcvtQMG4xYMQkn83JkfZsLOOD4+NVwCM
	xdWgJA8Vu4fgl+A==
X-Received: from oixo18-n1.prod.google.com ([2002:a05:6809:1d2:10b0:55e:c7d9:a271])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:660e:b0:4f4:b5ba:a241 with SMTP id 5614622812f47-57a0b048d65mr13584633b6e.39.1795477175429;
 Mon, 23 Nov 2026 15:39:35 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:10 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-6-dmatlack@google.com>
Subject: [PATCH v5 05/18] mm: Rename memfd_luo to shmem_luo
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
X-Rspam-User:
X-Rspamd-Queue-Id: BF34820002
X-Stat-Signature: xb58xon7qmraxa18wbbhw78thphp1m43
X-Spam-Status: No, score=-31.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795477176-48242
X-HE-Meta: U2FsdGVkX19AkSLjbVqSbRcxPc2Y95nWZHf0czlzpIFiDy5V06Qb9rWB8ChQC+4xDKj4j2sRNULo/XVkYIUEJ+NTVjFbCpRj13PcIi2blGwbJ+FAjzXmr/2Rtag41M+kPZAybjUFv25yeNSI5xjamgMw6l4s3Z+SEqzv+HBL6bUvY9R/8hRadh2efteRL97+yCv0a36tjwHnov4/96OuaPOqGdaOHge+/g8gRNusgN+en2Ya5aklWO3QsEsfgZUd/botTS95hcQOw7wjRcubJu8jN3rFOeiR/5cqbr3szkgWdOrnelkWrMmt6cG3Yg55LHExUOFrbz4glIJXMXIXg2YMYHkjlIUtDVEjbsQUHwKp8/tst+T+0KN5TF4VGpDbp8WUO5v8c4gEZj3Cepzu2Lp+IUtdbXvVsjPdo0t19Qw2qhjgU2d078hfsbbBaMbmOk1vChaOAnRtgtd0Mxj2QmLQU/rYOreb7OvbyOwGOrZdO6wLWHLzaAzqocC9r5QBNBvCecfsiEt6oXRHX2lXDpQM93XXnKjP8/HqwN7hP6G/BoWwuEQvszlek9xmQ6yik5S2b0CUphPu2xgdZoEQKgs5/+drPxqHgtOJ36vAl3pM0hJH+4imYWEiN9R5yT9vDzppMpqRw8VJ3XhC07K4+d7aGlc0tpcj5l7TRb3rKTTY+fVcvQO8duDLlCTJ6zxngSEuHiqRh/8qlB8UQD0nKgPPGwK6ab81BBflm8UeIkIpSswAAkgvmhmAjD8Yj136zv9xgjdMYbTv/VOgbfgNToOgaGscZBBrRZnNKYJ9pzpaEmBUHxAp+Kherg8EP8s26l1dtUqEQGBk7qoyaljrslmnpPOlVouqRuH+FGmNV3XS1WrRxDzKLCbXGcyeF0Ynbs+EKPzO21oSXzuAvGK5Fj6+/IaBH8BKo6wYAsXb6K99Gwh8ETZcTdR8amBjM/v6JqryQcwEbvfJnQeRhzO
 9ptwZlxA
 NWclOof1MA8TmC6SX9Z9Wmcl/a/5gTn6raxKBaclM+xB0icrvbRrD6y8fKt0uXvuNnmNvMpfr9vnaGaAICUzmIwP1CO8giJ8ukl4RfDC/IZZ1MeIvQIWBxJAVmXFMqfnTFoIiJa2S2Dhgnst5NWNv1ZerMU2qEjNSGSxisZKEtDaHA4zwCIO4BaPIOMYhGw2gMcyQE20BofIGjnf7xVNKW8bXLWX+qkNEBwI1IiL3JX7fJiOq0DA/nWVvaIjjdJoJZDTDS9/QLPxxLgiYXuToG6uiYqW/AoA8E+ib+ddFFEArjcjgnYgt4ZFV5hTurT/Khn9jhHXvEYMUayWfMBMcQQDp26yhn94v3ckBgY9hgh36XnBCrvQBLwZr01qnJH9MsAk9DdmtNw6/Q7PstBRazIsV81q/359Ggku8ahUKSEJ54SsipM93U1ePlMrd+QClWipMy7UKeEcXV7x6Vgh8QunF71i+2K3GJFJvYIMxEP3JG4Hjy4bNzXZa5ZJA22mum6V/ce5Gm072WnWzUzOQ4FimMr2oQmlDsU1K17F3sv0iWi8AiIuIVkWJ9hEzsfYhOx0mNCm0VCSv4Fkq94Io2Ho0QogRXDAc5QWFfHGRNPHLpmyQ7LWLMIIre3j1/5x6l7lDXHzsJ2Tsni+RXHoJyWWgPbcjcdAYcZWFwzq5+aYmU32iYvPZ1lgpkZuC6kvP/ooidlWsV/7GSjmsfCNa2Pni2uqNqQBueIyvlHTXFrcRD/MNlolBZSehMytqf5awaQer5DmTdwsiMIjhL70pIZJQ/d23/zzvDhLSaw0FE5p2gMD+Pi7n7AcROAb++MRHMOs+EAOlPBIf9mDCUw8LYndJxmLs+qxB7avQ/SneYQIZxkdFAecOQMqUrLgbYFTQ9Ug7oF8aLWAjqlmTp5KG8rrXAP2i3r/1cJDaxe9bLw3h+5Uf4Jl4+vBfAni2dHN4R40Vd47ae9SkIE3myqRaPVlN7w==
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
name is confusing. Memfds created with MFD_HUGETLB are hugetlbfs files
and would need a separate handler, so name this one after its backing
filesystem instead.

Don't change the compatible string of the handler, "memfd-v2". It is
matched against the preserved state from the previous kernel, so
changing it would break live updates from kernels that use the old
name. The serialized format doesn't change either.

Also clarify in the documentation that memfd means a memfd created
without MFD_HUGETLB, and name the ABI documentation after the handler.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/core-api/liveupdate.rst         |   2 +-
 Documentation/mm/index.rst                    |   2 +-
 ...reservation.rst => shmem_preservation.rst} |   8 +-
 MAINTAINERS                                   |   4 +-
 include/linux/kho/abi/{memfd.h => shmem.h}    |  41 ++++---
 kernel/liveupdate/Kconfig                     |   9 +-
 mm/Makefile                                   |   2 +-
 mm/{memfd_luo.c => shmem_luo.c}               | 115 +++++++++---------
 8 files changed, 93 insertions(+), 90 deletions(-)
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
index e9ae5cd82163..ce167d41c5cc 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -62,7 +62,7 @@ documentation, or deleted if it has served its purpose.
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
index 1572f6c905aa..4c97aee1f17a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15524,14 +15524,14 @@ L:	linux-kernel@vger.kernel.org
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
index f50daee8eff0..79fbf4aa4842 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -69,15 +69,16 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
-config LIVEUPDATE_MEMFD
-	bool "Live update support for memfd"
+config LIVEUPDATE_SHMEM
+	bool "Live update support for shmem files"
 	depends on LIVEUPDATE
 	depends on MEMFD_CREATE
 	depends on SHMEM
 	default LIVEUPDATE
 	help
-	  Enable live update support for memfd regions. This allows preserving
-	  memfd-backed memory across kernel live updates.
+	  Enable live update support for shmem files, i.e. memfds created
+	  without MFD_HUGETLB. This allows preserving memfd-backed memory
+	  across kernel live updates.
 
 	  This can be used to back VM memory with memfds, allowing the guest
 	  memory to persist, or for other user workloads needing to preserve
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..1b1aed389af7 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -101,7 +101,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
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
index 6b68220275eb..e747a0442295 100644
--- a/mm/memfd_luo.c
+++ b/mm/shmem_luo.c
@@ -18,6 +18,11 @@
  * Update Orchestrator (LUO) file preservation. This allows userspace to
  * transfer its memory contents to the next kernel after a kexec.
  *
+ * In this document, "memfd" means a memfd created without ``MFD_HUGETLB``, i.e.
+ * a shmem file on the kernel's internal shmem mount. Memfds created with
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
2.56.1.809.ga0b61035b5-goog


