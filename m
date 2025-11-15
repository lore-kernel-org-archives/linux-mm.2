Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE72CCEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC038E0023; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CC28E0007; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F76B8E0023; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27E08E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E469160362
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:55 +0000 (UTC)
X-FDA: 84114448950.05.04DBAC2
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 996B6120007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YBIZj0TN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249692; a=rsa-sha256;
	cv=none;
	b=8DLxb6DZKJbKEv6FsAL7wWTRMMsgy3jThEsXonzy1qt+84SwrsJwm1LwHKgq/2Tqrog82S
	7AOakYRRzlAllnvW/Y3W6YDHgB7e2MLqVsQqL7TPx2iRIDGI4zj082yFFLt4cdjqxArJ85
	4no/8mkGOcacMWOTHHKGVKiEmqkEIOU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YBIZj0TN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3RLZovbFwtP/RQUp1nppbVtzQW85hwtf6RrGKSmtoo=;
	b=x6W+RajZ+QQeMkAm5GHhHzDjNHt0/Ut0Tak7ZgkEll5I8KcfWUNebHrNjtFEf1c4lDf+vf
	uLSNBx+URm0ztY+NORGbpSPhG4m7HNWbQiM2XfobWWh1YYWcs6ql3vPtLHOYbFUHIiJx5o
	oRxMmLbiSKf/19TknHVOPy321CDM760=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-786d1658793so28974367b3.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249692; x=1763854492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3RLZovbFwtP/RQUp1nppbVtzQW85hwtf6RrGKSmtoo=;
        b=YBIZj0TNFZpjHVatDSIqddeQX9Cije0WqdFaaEMmciTNi0Bep0d7KRvjZ+o5rEMmDj
         QxjkF1sqhbwa9b/0zGFPKYb5oGtfqyaRoQWBARJX844ZXPs91wnPsA06kQUxcoy72U11
         s93OuVBbkgX21OTr6JAeM19mTvoLz1ZICNzGWgYuqHSv9xkprtD5xSgBiA3CUVRM4sqq
         hihYTif/cYoH2teOXMjZCjxIAmUlbN5CxK35Ja3s2ul7oMg9JQqWX2Rp1pqF0dsJhUbY
         KtGxb848WBzZOQUr6+aoAK4gU9qz3iytXhEP+z6Iq8LXc0Guv2OOQxuCHkV7UeqlS0zF
         sXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249692; x=1763854492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z3RLZovbFwtP/RQUp1nppbVtzQW85hwtf6RrGKSmtoo=;
        b=PMhk7kxvsochxnxOYvxa7fB4DCcnsVa3SAflB0PhClwK0RcFjDVHR6K1sxeyDC3ABq
         gAprWFc+KiNMgzIx5A6MsWzx4/H4yPqmcxrsEJ7SVj/vVu12kWX3gHq2fXaJwiDrJjpu
         rl5t+px27Bu9SjEMcVYrXS605OHx0QLQOUoQlji9Pjy6c4N1oDBwKrj6dTOL1xVlw+kb
         WL7gs3qXa09e/UeaVerLjC6Z3iX50IkJ2awz5zGdQVNoTaiFR2bgGPS0ETEy8ku6KSJV
         Nz6ROu6UPEE8NKKZLaSa1e2h2qBO3NYYE5h9zLuX4XuE0UUf//RU7M1aJw+r4ATGVJb3
         B5Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXm36D0bEa4XR8J+SrLfkkygJTdVl0KJNzRB7Pve74O9usSjX1Yt3uy5Pk9gn9ekEYQQa7Sow9mCA==@kvack.org
X-Gm-Message-State: AOJu0YwAEGh/ZzUTBZBjnYoJUBgBqn7abt7pQ3pi57Q/BucelgdPhPBA
	ujdR/ujO0icBzft/Nold/tMaquGu2OwCeH065cmPXI/op4ls37hH3KXs8ID2eNTwp08=
X-Gm-Gg: ASbGncuefhsZNMQ1bzDgpwg3Kuw9IaEgLRbzOS9GPdw1DyA9fUkq4EU/b6F84wkzn8n
	tamlPIxAWb6Wt6Rfxv2ho/a2aDF04/ugZ7RhEPCILABziUnC2Xogrs7fIW5RGrVtXTAwvWvkcOV
	gQmgTAHJFC5SGj9n5Wu8J+4ttsOooRRYrxl+HYurMxA1WVQXqsaCrdKZ8fpxAfQHIM/n8vD7PhH
	j4Ekh2/Ccdlj6RVZx0IgRwDeD4GvszuUs/mGODkzhSvfyCnAY/6EbYTbatFL/7NpaAsZuEAzXUF
	YzY9t7jJVgzjvacXkJolnK0Lrj9OSBpRV6vQ2mraIUrjmxUG9VDOcsVul/p4rBFzDe3nm6bvD1C
	8wgLQqxcjNY1uNdeZQA3ypOzjU17OtDQMUM1uzm6MI1yZ+WniL5Ap4U1hl85z+M2Oldk2YtrDq4
	oetyqXh5SE+ske+uhmzMqXr3kaKLaDM/aAfvDmZ1J60pUrnOKhRc6yoP3MQVxYI9lyA0GCAmWaa
	MFm5Bg=
X-Google-Smtp-Source: AGHT+IEDxucBxDV7YhPudgcf2ZpiZXeOBbuMtqu2QzxZIMkFxtD61LYMfKmQVcLo/cvXLlT/NQ5m9g==
X-Received: by 2002:a05:690c:30f:b0:786:8331:6a02 with SMTP id 00721157ae682-78929f40ac0mr137517487b3.69.1763249691460;
        Sat, 15 Nov 2025 15:34:51 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:51 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v6 15/20] mm: memfd_luo: allow preserving memfd
Date: Sat, 15 Nov 2025 18:34:01 -0500
Message-ID: <20251115233409.768044-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 996B6120007
X-Stat-Signature: 8bx85ueia3ds6dgom8pqrqswiqdoe95a
X-Rspam-User: 
X-HE-Tag: 1763249692-480067
X-HE-Meta: U2FsdGVkX1/w6HkNpjJWcv69Iy97+o42U7/sU9QcoLZ5cvy58PZQSSUrM7fZRWLs1BQaZXsIw2MsQwVDEt3xuUKS8g3sJxG2I9NLIz11YrBqf9L35CmwMRFUkhzQF8FTIbz4F64xYdHqtLUSt+X/aIdI24cMthozKj4CtHBoNQtq2Sb2uwQt4w9bmi76rP0ysQ8h0e5HVRYNJyIiDNp8qsLlbJm47PVWitMqGsBbU5GVoFO+6kvQlhUEuSZ4w8ZcbrVzkMYF+fKTHtVFqyBvATi/+INoyy8yZlgnxMxTYFpokGiwR6k8SqFNOxg0EqnZuGfAWsJEPquQFlrv75pZeK09/ud3i8KbkjBtIN5yD76k5o7KfuUbrrgl9/9kpZqicLAzHAT/4qVwWI9TMjwJSl8pOkJ5qMussMeILhTb1KZCk0KafhFg+cZx4wLBbpmlF8gZ5LA/+JAtIIIg7z6fKSXN78NCLWTWNKXMqUot7MHClg3b9N9Z9Xdn8wLkVOn4VixkFTq7dnsw9qE7KawCTxdoUCTJLDZk4wwJZhSLarx6/BSByjs4GqZFE+uEDe0K70vvN9Eo/NT47TSifasuAt5JNAcO5l86SklRm9IpvqBEP6zcM+KmMr6LWzy6YXqAPGuEJrzP2Q80M75/A8yErh+izGhRC4LsONoO2ZNMq/7nNFpUiXbihqKeMU0VY8wiacMtW2F+hCgDjq1n2vAxz29L9xPCILaL6AWw1zkY7VjRreQifjtv85T/wnOG8riqi4eT/lTFGOTv0gtCzxbJq9rr5X5E08t0iX3nXnrTkhdOXhnNDTS+Kryg3+aUoVFOmNNyjMCKL3pMH/Ih4WQfAVy9/g2OqYanot8oeuvDJ1ysGz0PNrI5tD+QKkyJTKCqOENkBpBmB1DDGYBoP46I5fsvOlGfqNQbQ/FwAV2++encvdETqw7TeLXe7i/unSG9Rd8YGz5kNrulDkP+bTE
 gJxDf/vM
 fSx8ty4uXGUy2jBQUd+NC36KJi53+xD++b1fWdFsQQUTTI1OAGhokIPJTQHnJ2pdy6gh7gN7sbnABKaViOsoPTCTcQME6iMBZCMCfnDbe4nO75DuhjnUfHTLFxMY2J57GFiA7Kyh4rhflCBEnItm+1WHrbEygB+VnrifXZ+Y4GhlTBNytv3l8Xs/uo0HqG2znUkW0Ct3Xkilu/i7owKThHr71sR0SplD6Jy31aq7INm40gWi74BD2Pamb7lVXW+tdy4raLWf1M7g10Uomzi31XlLD/DPjpOHDTzZNeivDm/BSp9zi2i0SJIXg/8rzpK1juVsgXd3BdT1ppsPOH0GXJEfvEbIupvu8oNIt8cppsNfc5DJP16q2q28yaw5Re8nNSGC2+xriL8o7B3OhfUPb5Ubw5k+sjw/fjWEm05wTyr5QdCcUJ7sAlbbD68KtOVtY6q91gWLbQeLZJh/b8gwimFO2ukHC1UYDmEo/PNNNOGCcDAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

The ability to preserve a memfd allows userspace to use KHO and LUO to
transfer its memory contents to the next kernel. This is useful in many
ways. For one, it can be used with IOMMUFD as the backing store for
IOMMU page tables. Preserving IOMMUFD is essential for performing a
hypervisor live update with passthrough devices. memfd support provides
the first building block for making that possible.

For another, applications with a large amount of memory that takes time
to reconstruct, reboots to consume kernel upgrades can be very
expensive. memfd with LUO gives those applications reboot-persistent
memory that they can use to quickly save and reconstruct that state.

While memfd is backed by either hugetlbfs or shmem, currently only
support on shmem is added. To be more precise, support for anonymous
shmem files is added.

The handover to the next kernel is not transparent. All the properties
of the file are not preserved; only its memory contents, position, and
size. The recreated file gets the UID and GID of the task doing the
restore, and the task's cgroup gets charged with the memory.

Once preserved, the file cannot grow or shrink, and all its pages are
pinned to avoid migrations and swapping. The file can still be read from
or written to.

Use vmalloc to get the buffer to hold the folios, and preserve
it using kho_preserve_vmalloc(). This doesn't have the size limit.

Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---
 MAINTAINERS                          |   2 +
 include/linux/liveupdate/abi/memfd.h |  88 ++++
 mm/Makefile                          |   1 +
 mm/memfd_luo.c                       | 671 +++++++++++++++++++++++++++
 4 files changed, 762 insertions(+)
 create mode 100644 include/linux/liveupdate/abi/memfd.h
 create mode 100644 mm/memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bc9f5c6f0e80..ad9fee6dc605 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14466,6 +14466,7 @@ F:	tools/testing/selftests/livepatch/
 
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
@@ -14474,6 +14475,7 @@ F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	mm/memfd_luo.c
 
 LLC (802.2)
 L:	netdev@vger.kernel.org
diff --git a/include/linux/liveupdate/abi/memfd.h b/include/linux/liveupdate/abi/memfd.h
new file mode 100644
index 000000000000..bf848e5bd1de
--- /dev/null
+++ b/include/linux/liveupdate/abi/memfd.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+#ifndef _LINUX_LIVEUPDATE_ABI_MEMFD_H
+#define _LINUX_LIVEUPDATE_ABI_MEMFD_H
+
+/**
+ * DOC: memfd Live Update ABI
+ *
+ * This header defines the ABI for preserving the state of a memfd across a
+ * kexec reboot using the LUO.
+ *
+ * The state is serialized into a Flattened Device Tree which is then handed
+ * over to the next kernel via the KHO mechanism. The FDT is passed as the
+ * opaque `data` handle in the file handler callbacks.
+ *
+ * This interface is a contract. Any modification to the FDT structure,
+ * node properties, compatible string, or the layout of the serialization
+ * structures defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ *
+ * FDT Structure Overview:
+ *   The memfd state is contained within a single FDT with the following layout:
+ *
+ *   .. code-block:: none
+ *
+ *     / {
+ *         pos = <...>;
+ *         size = <...>;
+ *         nr_folios = <...>;
+ *         folios = < ... binary data ... >;
+ *     };
+ *
+ *   Node Properties:
+ *     - pos: u64
+ *       The file's current position (f_pos).
+ *     - size: u64
+ *       The total size of the file in bytes (i_size).
+ *     - nr_folios: u64
+ *       Number of folios in folios array. Only present when size > 0.
+ *     - folios: struct kho_vmalloc
+ *       KHO vmalloc preservation for an array of &struct memfd_luo_folio_ser,
+ *       one for each preserved folio from the original file's mapping. Only
+ *       present when size > 0.
+ */
+
+/**
+ * struct memfd_luo_folio_ser - Serialized state of a single folio.
+ * @foliodesc: A packed 64-bit value containing both the PFN and status flags of
+ *             the preserved folio. The upper 52 bits store the PFN, and the
+ *             lower 12 bits are reserved for flags (e.g., dirty, uptodate).
+ * @index:     The page offset (pgoff_t) of the folio within the original file's
+ *             address space. This is used to correctly position the folio
+ *             during restoration.
+ *
+ * This structure represents the minimal information required to restore a
+ * single folio in the new kernel. An array of these structs forms the binary
+ * data for the "folios" property in the handover FDT.
+ */
+struct memfd_luo_folio_ser {
+	u64 foliodesc;
+	u64 index;
+};
+
+/* The strings used for memfd KHO FDT sub-tree. */
+
+/* 64-bit pos value for the preserved memfd */
+#define MEMFD_FDT_POS		"pos"
+
+/* 64-bit size value of the preserved memfd */
+#define MEMFD_FDT_SIZE		"size"
+
+#define MEMFD_FDT_FOLIOS	"folios"
+
+/* Number of folios in the folios array. */
+#define MEMFD_FDT_NR_FOLIOS	"nr_folios"
+
+/* The compatibility string for memfd file handler */
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
+
+#endif /* _LINUX_LIVEUPDATE_ABI_MEMFD_H */
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..7738ec416f00 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
+obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
new file mode 100644
index 000000000000..4c1d16db2cff
--- /dev/null
+++ b/mm/memfd_luo.c
@@ -0,0 +1,671 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+/**
+ * DOC: Memfd Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * Memory file descriptors (memfd) can be preserved over a kexec using the Live
+ * Update Orchestrator (LUO) file preservation. This allows userspace to
+ * transfer its memory contents to the next kernel after a kexec.
+ *
+ * The preservation is not intended to be transparent. Only select properties of
+ * the file are preserved. All others are reset to default. The preserved
+ * properties are described below.
+ *
+ * .. note::
+ *    The LUO API is not stabilized yet, so the preserved properties of a memfd
+ *    are also not stable and are subject to backwards incompatible changes.
+ *
+ * .. note::
+ *    Currently a memfd backed by Hugetlb is not supported. Memfds created
+ *    with ``MFD_HUGETLB`` will be rejected.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of the memfd are preserved across kexec:
+ *
+ * File Contents
+ *   All data stored in the file is preserved.
+ *
+ * File Size
+ *   The size of the file is preserved. Holes in the file are filled by
+ *   allocating pages for them during preservation.
+ *
+ * File Position
+ *   The current file position is preserved, allowing applications to continue
+ *   reading/writing from their last position.
+ *
+ * File Status Flags
+ *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
+ *   is maintained.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * All properties which are not preserved must be assumed to be reset to
+ * default. This section describes some of those properties which may be more of
+ * note.
+ *
+ * ``FD_CLOEXEC`` flag
+ *   A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
+ *   ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set
+ *   again after restore via ``fcntl()``.
+ *
+ * Seals
+ *   File seals are not preserved. The file is unsealed on restore and if
+ *   needed, must be sealed again via ``fcntl()``.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/liveupdate/abi/memfd.h>
+#include <linux/shmem_fs.h>
+#include <linux/vmalloc.h>
+#include "internal.h"
+
+#define PRESERVED_PFN_MASK		GENMASK(63, 12)
+#define PRESERVED_PFN_SHIFT		12
+#define PRESERVED_FLAG_DIRTY		BIT(0)
+#define PRESERVED_FLAG_UPTODATE		BIT(1)
+
+#define PRESERVED_FOLIO_PFN(desc)	(((desc) & PRESERVED_PFN_MASK) >> PRESERVED_PFN_SHIFT)
+#define PRESERVED_FOLIO_FLAGS(desc)	((desc) & ~PRESERVED_PFN_MASK)
+#define PRESERVED_FOLIO_MKDESC(pfn, flags) (((pfn) << PRESERVED_PFN_SHIFT) | (flags))
+
+struct memfd_luo_private {
+	struct memfd_luo_folio_ser *pfolios;
+	u64 nr_folios;
+};
+
+static struct memfd_luo_folio_ser *memfd_luo_preserve_folios(struct file *file, void *fdt,
+							     u64 *nr_foliosp)
+{
+	struct inode *inode = file_inode(file);
+	struct memfd_luo_folio_ser *pfolios;
+	struct kho_vmalloc *kho_vmalloc;
+	unsigned int max_folios;
+	long i, size, nr_pinned;
+	struct folio **folios;
+	int err = -EINVAL;
+	pgoff_t offset;
+	u64 nr_folios;
+
+	size = i_size_read(inode);
+	/*
+	 * If the file has zero size, then the folios and nr_folios properties
+	 * are not set.
+	 */
+	if (!size) {
+		*nr_foliosp = 0;
+		return NULL;
+	}
+
+	/*
+	 * Guess the number of folios based on inode size. Real number might end
+	 * up being smaller if there are higher order folios.
+	 */
+	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
+	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);
+	if (!folios)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Pin the folios so they don't move around behind our back. This also
+	 * ensures none of the folios are in CMA -- which ensures they don't
+	 * fall in KHO scratch memory. It also moves swapped out folios back to
+	 * memory.
+	 *
+	 * A side effect of doing this is that it allocates a folio for all
+	 * indices in the file. This might waste memory on sparse memfds. If
+	 * that is really a problem in the future, we can have a
+	 * memfd_pin_folios() variant that does not allocate a page on empty
+	 * slots.
+	 */
+	nr_pinned = memfd_pin_folios(file, 0, size - 1, folios, max_folios,
+				     &offset);
+	if (nr_pinned < 0) {
+		err = nr_pinned;
+		pr_err("failed to pin folios: %d\n", err);
+		goto err_free_folios;
+	}
+	nr_folios = nr_pinned;
+
+	err = fdt_property(fdt, MEMFD_FDT_NR_FOLIOS, &nr_folios, sizeof(nr_folios));
+	if (err)
+		goto err_unpin;
+
+	err = fdt_property_placeholder(fdt, MEMFD_FDT_FOLIOS, sizeof(*kho_vmalloc),
+				       (void **)&kho_vmalloc);
+	if (err) {
+		pr_err("Failed to reserve '%s' property in FDT: %s\n",
+		       MEMFD_FDT_FOLIOS, fdt_strerror(err));
+		err = -ENOMEM;
+		goto err_unpin;
+	}
+
+	pfolios = vcalloc(nr_folios, sizeof(*pfolios));
+	if (!pfolios) {
+		err = -ENOMEM;
+		goto err_unpin;
+	}
+
+	for (i = 0; i < nr_folios; i++) {
+		struct memfd_luo_folio_ser *pfolio = &pfolios[i];
+		struct folio *folio = folios[i];
+		unsigned int flags = 0;
+		unsigned long pfn;
+
+		err = kho_preserve_folio(folio);
+		if (err)
+			goto err_unpreserve;
+
+		pfn = folio_pfn(folio);
+		if (folio_test_dirty(folio))
+			flags |= PRESERVED_FLAG_DIRTY;
+		if (folio_test_uptodate(folio))
+			flags |= PRESERVED_FLAG_UPTODATE;
+
+		pfolio->foliodesc = PRESERVED_FOLIO_MKDESC(pfn, flags);
+		pfolio->index = folio->index;
+	}
+
+	err = kho_preserve_vmalloc(pfolios, kho_vmalloc);
+	if (err)
+		goto err_unpreserve;
+
+	kvfree(folios);
+	*nr_foliosp = nr_folios;
+	return pfolios;
+
+err_unpreserve:
+	i--;
+	for (; i >= 0; i--)
+		kho_unpreserve_folio(folios[i]);
+	vfree(pfolios);
+err_unpin:
+	unpin_folios(folios, nr_folios);
+err_free_folios:
+	kvfree(folios);
+	return ERR_PTR(err);
+}
+
+static void memfd_luo_unpreserve_folios(void *fdt, struct memfd_luo_folio_ser *pfolios,
+					u64 nr_folios)
+{
+	struct kho_vmalloc *kho_vmalloc;
+	long i;
+
+	if (!nr_folios)
+		return;
+
+	kho_vmalloc = (struct kho_vmalloc *)fdt_getprop(fdt, 0, MEMFD_FDT_FOLIOS, NULL);
+	/* The FDT was created by this kernel so expect it to be sane. */
+	WARN_ON_ONCE(!kho_vmalloc);
+	kho_unpreserve_vmalloc(kho_vmalloc);
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &pfolios[i];
+		struct folio *folio;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+
+		kho_unpreserve_folio(folio);
+		unpin_folio(folio);
+	}
+
+	vfree(pfolios);
+}
+
+static struct memfd_luo_folio_ser *memfd_luo_fdt_folios(const void *fdt, u64 *nr_folios)
+{
+	const struct kho_vmalloc *kho_vmalloc;
+	struct memfd_luo_folio_ser *pfolios;
+	const u64 *nr;
+	int len;
+
+	nr = fdt_getprop(fdt, 0, MEMFD_FDT_NR_FOLIOS, &len);
+	if (!nr || len != sizeof(*nr)) {
+		pr_err("invalid '%s' property\n", MEMFD_FDT_NR_FOLIOS);
+		return NULL;
+	}
+
+	kho_vmalloc = fdt_getprop(fdt, 0, MEMFD_FDT_FOLIOS, &len);
+	if (!kho_vmalloc || len != sizeof(*kho_vmalloc)) {
+		pr_err("invalid '%s' property\n", MEMFD_FDT_FOLIOS);
+		return NULL;
+	}
+
+	pfolios = kho_restore_vmalloc(kho_vmalloc);
+	if (!pfolios)
+		return NULL;
+
+	*nr_folios = *nr;
+	return pfolios;
+}
+
+static void *memfd_luo_create_fdt(void)
+{
+	struct folio *fdt_folio;
+	int err = 0;
+	void *fdt;
+
+	/*
+	 * The FDT only contains a couple of properties and a kho_vmalloc
+	 * object. One page should be enough for that.
+	 */
+	fdt_folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!fdt_folio)
+		return NULL;
+
+	fdt = folio_address(fdt_folio);
+
+	err |= fdt_create(fdt, folio_size(fdt_folio));
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	if (err)
+		goto free;
+
+	return fdt;
+
+free:
+	folio_put(fdt_folio);
+	return NULL;
+}
+
+static int memfd_luo_finish_fdt(void *fdt)
+{
+	int err;
+
+	err = fdt_end_node(fdt);
+	if (err)
+		return err;
+
+	return fdt_finish(fdt);
+}
+
+static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+	struct memfd_luo_folio_ser *pfolios;
+	struct memfd_luo_private *private;
+	u64 pos, nr_folios;
+	int err = 0;
+	void *fdt;
+	long size;
+
+	private = kmalloc(sizeof(*private), GFP_KERNEL);
+	if (!private)
+		return -ENOMEM;
+
+	inode_lock(inode);
+	shmem_i_mapping_freeze(inode, true);
+
+	size = i_size_read(inode);
+
+	fdt = memfd_luo_create_fdt();
+	if (!fdt) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
+
+	pos = args->file->f_pos;
+	err = fdt_property(fdt, MEMFD_FDT_POS, &pos, sizeof(pos));
+	if (err)
+		goto err_free_fdt;
+
+	err = fdt_property(fdt, MEMFD_FDT_SIZE, &size, sizeof(size));
+	if (err)
+		goto err_free_fdt;
+
+	pfolios = memfd_luo_preserve_folios(args->file, fdt, &nr_folios);
+	if (IS_ERR(pfolios)) {
+		err = PTR_ERR(pfolios);
+		goto err_free_fdt;
+	}
+
+	err = memfd_luo_finish_fdt(fdt);
+	if (err)
+		goto err_unpreserve_folios;
+
+	err = kho_preserve_folio(virt_to_folio(fdt));
+	if (err)
+		goto err_unpreserve_folios;
+
+	inode_unlock(inode);
+
+	private->pfolios = pfolios;
+	private->nr_folios = nr_folios;
+	args->private_data = private;
+	args->serialized_data = virt_to_phys(fdt);
+	return 0;
+
+err_unpreserve_folios:
+	memfd_luo_unpreserve_folios(fdt, pfolios, nr_folios);
+err_free_fdt:
+	folio_put(virt_to_folio(fdt));
+err_unlock:
+	shmem_i_mapping_freeze(inode, false);
+	inode_unlock(inode);
+	kfree(private);
+	return err;
+}
+
+static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
+{
+	u64 pos = args->file->f_pos;
+	void *fdt;
+	int err;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	fdt = phys_to_virt(args->serialized_data);
+
+	/*
+	 * The pos might have changed since prepare. Everything else stays the
+	 * same.
+	 */
+	err = fdt_setprop(fdt, 0, "pos", &pos, sizeof(pos));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_private *private = args->private_data;
+	struct inode *inode = file_inode(args->file);
+	struct folio *fdt_folio;
+	void *fdt;
+
+	if (WARN_ON_ONCE(!args->serialized_data || !args->private_data))
+		return;
+
+	inode_lock(inode);
+	shmem_i_mapping_freeze(inode, false);
+
+	fdt = phys_to_virt(args->serialized_data);
+	fdt_folio = virt_to_folio(fdt);
+
+	memfd_luo_unpreserve_folios(fdt, private->pfolios, private->nr_folios);
+
+	kho_unpreserve_folio(fdt_folio);
+	folio_put(fdt_folio);
+	inode_unlock(inode);
+	kfree(private);
+}
+
+static struct folio *memfd_luo_get_fdt(u64 data)
+{
+	return kho_restore_folio((phys_addr_t)data);
+}
+
+static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *pfolios,
+				     long nr_folios)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &pfolios[i];
+		struct folio *folio;
+		phys_addr_t phys;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		phys = PFN_PHYS(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		folio = kho_restore_folio(phys);
+		if (!folio) {
+			pr_warn_ratelimited("Unable to restore folio at physical address: %llx\n",
+					    phys);
+			continue;
+		}
+
+		folio_put(folio);
+	}
+}
+
+static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+{
+	const struct memfd_luo_folio_ser *pfolios;
+	struct folio *fdt_folio;
+	const void *fdt;
+	u64 nr_folios;
+
+	if (args->retrieved)
+		return;
+
+	fdt_folio = memfd_luo_get_fdt(args->serialized_data);
+	if (!fdt_folio) {
+		pr_err("failed to restore memfd FDT\n");
+		return;
+	}
+
+	fdt = folio_address(fdt_folio);
+
+	pfolios = memfd_luo_fdt_folios(fdt, &nr_folios);
+	if (!pfolios)
+		goto out;
+
+	memfd_luo_discard_folios(pfolios, nr_folios);
+	vfree(pfolios);
+
+out:
+	folio_put(fdt_folio);
+}
+
+static int memfd_luo_retrieve_folios(struct file *file, const void *fdt)
+{
+	const struct memfd_luo_folio_ser *pfolios;
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping;
+	struct folio *folio;
+	u64 nr_folios;
+	long i = 0;
+	int err;
+
+	/* Careful: folios don't exist in FDT on zero-size files. */
+	if (!inode->i_size)
+		return 0;
+
+	pfolios = memfd_luo_fdt_folios(fdt, &nr_folios);
+	if (!pfolios) {
+		pr_err("failed to fetch preserved folio list\n");
+		return -EINVAL;
+	}
+
+	inode = file->f_inode;
+	mapping = inode->i_mapping;
+
+	for (; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &pfolios[i];
+		phys_addr_t phys;
+		u64 index;
+		int flags;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		phys = PFN_PHYS(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		folio = kho_restore_folio(phys);
+		if (!folio) {
+			pr_err("Unable to restore folio at physical address: %llx\n",
+			       phys);
+			goto put_folios;
+		}
+		index = pfolio->index;
+		flags = PRESERVED_FOLIO_FLAGS(pfolio->foliodesc);
+
+		/* Set up the folio for insertion. */
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+
+		err = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
+		if (err) {
+			pr_err("shmem: failed to charge folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
+					      mapping_gfp_mask(mapping));
+		if (err) {
+			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		if (flags & PRESERVED_FLAG_UPTODATE)
+			folio_mark_uptodate(folio);
+		if (flags & PRESERVED_FLAG_DIRTY)
+			folio_mark_dirty(folio);
+
+		err = shmem_inode_acct_blocks(inode, 1);
+		if (err) {
+			pr_err("shmem: failed to account folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		shmem_recalc_inode(inode, 1, 0);
+		folio_add_lru(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	vfree(pfolios);
+	return 0;
+
+unlock_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+	i++;
+put_folios:
+	/*
+	 * Note: don't free the folios already added to the file. They will be
+	 * freed when the file is freed. Free the ones not added yet here.
+	 */
+	for (; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &pfolios[i];
+
+		folio = kho_restore_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		if (folio)
+			folio_put(folio);
+	}
+
+	vfree(pfolios);
+	return err;
+}
+
+static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct folio *fdt_folio;
+	const u64 *pos, *size;
+	struct file *file;
+	int len, ret = 0;
+	const void *fdt;
+
+	fdt_folio = memfd_luo_get_fdt(args->serialized_data);
+	if (!fdt_folio)
+		return -ENOENT;
+
+	fdt = page_to_virt(folio_page(fdt_folio, 0));
+
+	size = fdt_getprop(fdt, 0, "size", &len);
+	if (!size || len != sizeof(u64)) {
+		pr_err("invalid 'size' property\n");
+		ret = -EINVAL;
+		goto put_fdt;
+	}
+
+	pos = fdt_getprop(fdt, 0, "pos", &len);
+	if (!pos || len != sizeof(u64)) {
+		pr_err("invalid 'pos' property\n");
+		ret = -EINVAL;
+		goto put_fdt;
+	}
+
+	file = shmem_file_setup("", 0, VM_NORESERVE);
+
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		pr_err("failed to setup file: %d\n", ret);
+		goto put_fdt;
+	}
+
+	vfs_setpos(file, *pos, MAX_LFS_FILESIZE);
+	file->f_inode->i_size = *size;
+
+	ret = memfd_luo_retrieve_folios(file, fdt);
+	if (ret)
+		goto put_file;
+
+	args->file = file;
+	folio_put(fdt_folio);
+	return 0;
+
+put_file:
+	fput(file);
+put_fdt:
+	folio_put(fdt_folio);
+	return ret;
+}
+
+static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
+				   struct file *file)
+{
+	struct inode *inode = file_inode(file);
+
+	return shmem_file(file) && !inode->i_nlink;
+}
+
+static const struct liveupdate_file_ops memfd_luo_file_ops = {
+	.freeze = memfd_luo_freeze,
+	.finish = memfd_luo_finish,
+	.retrieve = memfd_luo_retrieve,
+	.preserve = memfd_luo_preserve,
+	.unpreserve = memfd_luo_unpreserve,
+	.can_preserve = memfd_luo_can_preserve,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler memfd_luo_handler = {
+	.ops = &memfd_luo_file_ops,
+	.compatible = MEMFD_LUO_FH_COMPATIBLE,
+};
+
+static int __init memfd_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&memfd_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register luo filesystem handler: %pe\n", ERR_PTR(err));
+
+		return err;
+	}
+
+	return 0;
+}
+late_initcall(memfd_luo_init);
-- 
2.52.0.rc1.455.g30608eb744-goog


