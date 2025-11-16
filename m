Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AFDCEBF88
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F238F8E002D; Sat, 15 Nov 2025 20:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD1B8E0005; Sat, 15 Nov 2025 20:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8618E002D; Sat, 15 Nov 2025 20:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0DEE8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:32:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A818BBC84
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:34 +0000 (UTC)
X-FDA: 84114745428.26.67AF4BA
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEDDE180004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ALecb8Nx;
	spf=pass (imf24.hostedemail.com: domain of 3rykZaQgKCLYfeWmeuWjckkcha.Ykihejqt-iigrWYg.knc@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3rykZaQgKCLYfeWmeuWjckkcha.Ykihejqt-iigrWYg.knc@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763256752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os6SZTaeXY813tjI0MktjS9EkkNR7SCiBq4bw5IkwZI=;
	b=SqchLdQ0QfvFnAbFAwjn1E7PDNtiam18eO4ITUnUuf4irJDrZECjij1De0loJ+tUS1s3hX
	HHsy+7ARbqLqXVdnDESyVFtRYoAKf96ewIPFzDPQNOeRFK/aeYmwGnaOx7TlDDxx9hoEwg
	hupkOwKI2Qxu2TXkhhw1pXylNIJBZ6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763256752; a=rsa-sha256;
	cv=none;
	b=DpTKUVYM437Tpy60nXCNg5I7aR2ahsa4evX438JNGgXQWI78aOYa7sL4K8L8Zv7H2cGY8P
	Jb/yjhgT8Ck5TnOQSc55xXLvOqELO3npzCac9STDip3aCKydn/kpXrSu2qF/y+v4TK7r1K
	n6Gj8afM8F4vB759n9frQU2wFU16cJU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ALecb8Nx;
	spf=pass (imf24.hostedemail.com: domain of 3rykZaQgKCLYfeWmeuWjckkcha.Ykihejqt-iigrWYg.knc@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3rykZaQgKCLYfeWmeuWjckkcha.Ykihejqt-iigrWYg.knc@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so7723981a91.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763256752; x=1763861552; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=os6SZTaeXY813tjI0MktjS9EkkNR7SCiBq4bw5IkwZI=;
        b=ALecb8NxoHgHtDmQYq93tiHZibhh24730jAHoCzwuEP5EKPbpbHs3jeF4VjiHjC9j7
         fSP8A20gPj6FUIXvoDn3qQfPbsISqKFfDiwoboWoXemOT8H83WT2MpdpC1B5GuRJ7d6U
         dAIkSx33Q87jIyC5tShFrf29Brij+jy1OnuYuVjgjhDKKyfteezaQ5JTDWbSdGVXU6uL
         rsN2g3OR1ZDmv22yav05BHIPsdFtLbhy9swF8O0qDLU0D/1a99q6/dw4JA3epSNoh0Fx
         tyoTrXoxnzQmLikyxisRqMCGI6poToiMXShIMPyKwu8PsRUA5gov9TnWLrQGn4a8ZBUn
         umJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763256752; x=1763861552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=os6SZTaeXY813tjI0MktjS9EkkNR7SCiBq4bw5IkwZI=;
        b=JyCbiaySVFqnguKOuFdmlP3UEstMYq1crIL/DtIdg8YouUBM6nJES++logY8+Tg9qY
         nISLqXpaPlU6QXq5T8s00GtVGg6l+xtZMWPqIyofKxdVmVOE/Rp+UAajVfsmnp9cQp1/
         EE3p7uCAAq4i5bgLmOngW/dMZqAAwU+4OdzTX1oJoL3G40mwMWMfTc+wnRIdin/aJNdA
         LSqnYmtWtmyP8IA/ShtLluOAdkCLa5Lrko6j1MAoNgWSjXVTbPSHy9Uu0bpZn1+Z7Yoh
         RKoOORBIMnGe52/5J56n8NqPRlaZa5lg4XHbNPzaP5RDmahRtKV7CRloJoLYUtooDZnk
         m0vg==
X-Forwarded-Encrypted: i=1; AJvYcCWaGjvzh64aUOLj5c63yvLsAEdB4ufs62iEOxP8vmksnFWCGPYUaVpMepuVdWkCg2J9d/j9jBaJPQ==@kvack.org
X-Gm-Message-State: AOJu0YwYwqjRkQrZgMVHG5bX1LjXAVT3vhEkkC5V9+WLTsx4nOCXoZJm
	7Kq0y4lBpkrgocQzyUWmT90KAz2m5l+onp/2vzqX0ZQzNu692aKnNcoDaSqI6GVKTy8M/QlcNLA
	qAZ3CdMlhWPgKGA==
X-Google-Smtp-Source: AGHT+IFF1NojknbOkMkJx3nkb9BpNu1qDh2+jUJDNFtUK5ivMNc7tNHbVDIZXIiwRMoOI2BvT/E7mg7MjaIhSg==
X-Received: from pjpq7.prod.google.com ([2002:a17:90a:a007:b0:332:7fae:e138])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3a46:b0:32b:9506:1780 with SMTP id 98e67ed59e1d1-343fa0d72aemr8132252a91.9.1763256751712;
 Sat, 15 Nov 2025 17:32:31 -0800 (PST)
Date: Sun, 16 Nov 2025 01:32:23 +0000
In-Reply-To: <20251116013223.1557158-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251116013223.1557158-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116013223.1557158-4-jiaqiyan@google.com>
Subject: [PATCH v2 3/3] Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, william.roche@oracle.com, 
	harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEDDE180004
X-Stat-Signature: x1ddfpbbebh15xcbxrbj11nybmx68nz4
X-Rspam-User: 
X-HE-Tag: 1763256752-349387
X-HE-Meta: U2FsdGVkX1/CrbpfmUVYONYT86ZlLRJ1fXJJmgZ7Igl/v7n50ZQOyXyfB488BH/QWICjGMt4pWbWxSRWExI1xiDIa69IsldnvRmSghqLVCl8VzG+ufVr5QpUyERswdJtrUEKOgu8OWYxklJUYPXDCgoYSXIRYhdzxAA1WKHLgamypGbicQ5+Wezna0o6ZTciPUEzclWAWM/gvbbxCl9bsepKPDMQU8tFDR0Hzekxcydt+qcg26dnWbYGVx1oroN37bdvbJBbMiarH/dFKLA7p3nSp8EXaI1qeKuGNMmSfc2GKtqOwxizglVUJ7s1NQx4GWYBLabFGqSte0QuSMI2VheZum8/T0YImZvlIE9O0fnvZfsodkY0y70FLcKEEOR1a+7UMnxd8V9hehu0Zma1ZSznoIyUTYtRcGhBPpI246XvHjvmJNY8/HmVzHdVm5F/uhvumKjqpexQfxZVnWabjpcjMDhEjRdxi6+vwDvOO+E0Z918+N6yVBDa+odyqr+m03ksxV+ZWvcXEsUg1gwHgbyptfkXEN+OokUOw4uNvMinSTcESxk4ruWIOMzDPZ79xgJuSqOm+p3gYGF4t3FuOUPYh55t5t63RLtn6TmQ4gvnEsdTEWmNkd+jJukl0xHJwZXrOSkZ0nzYDn1yvHs466SHLlr4CruHlYVv9Xccy7wVXdjiN7JWchehRCPWRUaUrMUIi00od92Qts39pC2kjGVJuleLgTGYMj1K5cVdMACMRxcA9uif2UCf4GvAPcY2DW8FKbiO18Mzo+htCcbtI1DsOKSXhf+h1YpiamLRyV85pFhF8WmzA4QOwZqBAGdVXvWNQETnA2/oN9ND1Z/w9IhSY4jKa4PCSn3ujGkiLTrc3cVCpUXg/6+qc+1ALvMkJeMjXRm/odHW4m9zHhD0o2H7a1jAJBwUmMs0yC0YaPiProMkEkPOg0o149fBtEJ3dHxFqmx8wjQg1bWximM
 NTO9yNV+
 Fxx/v4MaBkjT1IVQtCKpSH/Y8+xmDblfgBXLLbn45CilKyhr5LZL0NHi88sqxDN59k75Xya0ybqbsEJW85YP9L08vAEZeCoohFeyrP9lPzjRsNRi7A5anoMZ3zibpjppbTMAmxtE7wnYAed+NI3WMiiwMe84WxRh135b0zuuariWDnneH9JfdkQl+f7P7ndoauUsXaDeUEUF5u46ZvUv/trW9SmncS467YxfoyZat+mwkC30pWJHAG8EFnD8wVu5Ve1cxoQ91fjDWElX2OJ8tJWpRilJuGaOyYs8Y3RgNJKXaNsliwEmvAeX0HBDPgSfQeZ+Y0MLRJnDXOKwAOzqU0dhqKRwG5wNA5qxYO8siSKqRr0vVQZygofgWf42BZdllC7p9ciExL+SmMPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document its motivation, userspace API, behaviors, and limitations.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/mfd_mfr_policy.rst          | 60 +++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index b8c73be4fb112..d8c6977d9e67a 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -67,6 +67,7 @@ Everything else
    futex2
    perf_ring_buffer
    ntsync
+   mfd_mfr_policy
 
 .. only::  subproject and html
 
diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
new file mode 100644
index 0000000000000..c5a25df39791a
--- /dev/null
+++ b/Documentation/userspace-api/mfd_mfr_policy.rst
@@ -0,0 +1,60 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================================
+Userspace Memory Failure Recovery Policy via memfd
+==================================================
+
+:Author:
+    Jiaqi Yan <jiaqiyan@google.com>
+
+
+Motivation
+==========
+
+When a userspace process is able to recover from memory failures (MF)
+caused by uncorrected memory error (UE) in the DIMM, especially when it is
+able to avoid consuming known UEs, keeping the memory page mapped and
+accessible is benifical to the owning process for a couple of reasons:
+
+- The memory pages affected by UE have a large smallest granularity, for
+  example 1G hugepage, but the actual corrupted amount of the page is only
+  several cachlines. Losing the entire hugepage of data is unacceptable to
+  the application.
+
+- In addition to keeping the data accessible, the application still wants
+  to access with a large page size for the fastest virtual-to-physical
+  translations.
+
+Memory failure recovery for 1G or larger HugeTLB is a good example. With
+memfd userspace process can control whether the kernel hard offlines its
+hugepages that backs the in-RAM file created by memfd.
+
+
+User API
+========
+
+``int memfd_create(const char *name, unsigned int flags)``
+
+``MFD_MF_KEEP_UE_MAPPED``
+
+	When ``MFD_MF_KEEP_UE_MAPPED`` bit is set in ``flags``, MF recovery
+	in the kernel does not hard offline memory due to UE until the
+	returned ``memfd`` is released. IOW, the HWPoison-ed memory remains
+	accessible via the returned ``memfd`` or the memory mapping created
+	with the returned ``memfd``. Note the affected memory will be
+	immediately isolated and prevented from future use once the memfd
+	is closed. By default ``MFD_MF_KEEP_UE_MAPPED`` is not set, and
+	kernel hard offlines memory having UEs.
+
+Notes about the behavior and limitations
+
+- Even if the page affected by UE is kept, a portion of the (huge)page is
+  already lost due to hardware corruption, and the size of the portion
+  is the smallest page size that kernel uses to manages memory on the
+  architecture, i.e. PAGESIZE. Accessing a virtual address within any of
+  these parts results in a SIGBUS; accessing virtual address outside these
+  parts are good until it is corrupted by new memory error.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
+  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
+  Otherwise ``memfd_create`` returns EINVAL.
-- 
2.52.0.rc1.455.g30608eb744-goog


