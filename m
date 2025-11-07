Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F547CCFA19
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20C48E001D; Fri,  7 Nov 2025 16:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0CB8E001A; Fri,  7 Nov 2025 16:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98E78E001D; Fri,  7 Nov 2025 16:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9E38E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 498C11402A2
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:08 +0000 (UTC)
X-FDA: 84085043616.22.6DD9F6A
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5805714001C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="V/vtdMV6";
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09YtFNBuBcrdwWRDfQe183nmO/j9JR0mycDV+z3OXls=;
	b=vYpSFnoB34C8L4w3iiIHGEqmFHvxc0ElrQsXOclCyJ7Q+6WQN4xeasW3TlWHemyCtujCqa
	m25bVX3nVTwM/MGrMn1ohD0sBgl9hO1ObrqGKafCXn+KeVdqh6vdu5mD1L5u6xYcuElRic
	YCRzh1C6Ch9ddKOwH/w382oDXHnc1Cg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549566; a=rsa-sha256;
	cv=none;
	b=LEeoztVYElC2e0l6/TPI9stndnB6JEKnswS8pbp1lpKYI4mcJdKBtCIS644SsHcM1UlR8o
	ta4gJpuLjH2MGg7r2/x44EChGbNzeXEhMpB4/OBHPIGbPd9RRMrso00b3j2S1uTGLEMEdX
	B3TRAY+R5i3Gzm+Mn01wbjfzsg2XO4Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="V/vtdMV6";
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63f9beb27b9so1111512d50.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549565; x=1763154365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09YtFNBuBcrdwWRDfQe183nmO/j9JR0mycDV+z3OXls=;
        b=V/vtdMV66QseDKTcjVb6nSyQnIne9uaem11TSxzrUZo7l8yDugMOOoEFM9CAlpKXCo
         uXmS3stc7LlqGV+lko51h+N6BLspOeyk7P87tUi8bO/dQdxDydQZ37YtiYGvp9/dE6z8
         CZWbpvSCLr4iANkdSB2qKDNXnqWEzl0pr+oYppk77FoNrRmcUbNaKyE9LRS0c0hA/rXF
         6K8s5I4/7bBKZje0hSTMJKs3Wr9i7Xgw39AuhoAYFk57LyDYXi9sLUgqaP1B3yRPG6rZ
         cVcL5DtC0KLJbzbm9hnvxJeehLgACq/NISQveOz7qftsGgXKl9tDm66yZN5vtJZu/uua
         4GEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549565; x=1763154365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=09YtFNBuBcrdwWRDfQe183nmO/j9JR0mycDV+z3OXls=;
        b=RLp5zhMCviQOorrL3wU8uNXnaUxUoWeQZTaHa8q9TJ6sivK4dDjXpf1WUNnJe06vs+
         AoAw8cmOocl3tp8aBuAeJEqw+kkn8jBpM1oM6rL5A564fOrHSrZKK71DnqvoeFxZQ6Zg
         fpdp3sWnvHAnXy/sUvUYiYbOYO4xKq6EV576yU0shcW6MciUP+4TS9gQTGGh6cUxO98y
         hujQ8WiP4a9VVUzfCqDo/Rfam3VUl0RkiIXndHxdL5xzePJaRIL0q4D05EFytha1dcb2
         5E9ORWtVhvPfa0q5A0Q0GJqFGNBGt3LKVWFkXOphDazvtB68u/+LacPIKFEM9HHJ7LdG
         LefA==
X-Forwarded-Encrypted: i=1; AJvYcCWOeLRAKA2wRTVWu4o+aJQ8VFGIRSt2ZRP47xA0QF8489V7rhEIqFfMSa5wmP9p49KBmR9UcAoXEg==@kvack.org
X-Gm-Message-State: AOJu0YyzNOnLEghCslK+XWhzLzZLM0rib0wGV08Cm/cqQJAQWdva6sr7
	8eTpKGmM4Q9Rl0SEP0fwslnMnqcOLhTYEXmNNwvbARslcITFWBSE21NUhiF6SbiqSbc=
X-Gm-Gg: ASbGncv2YUBOJWXUbdqAzCsJw2QaeQrxENPGe5698S2N8g9TlKNAN8mIxP1w0cBJAJf
	ArbcM2MvJy/eZCSKdTOW2MdHirf1iNpYe9VcWnw3wSVVdLZTrL24UQgjLWlSRLb4G6uAKRAmLyt
	GLxP7K6tn2IgmNV5BCnd3F9F/wTLMPSHsHEgqPQwdI36ZB9C9ab9NJpftDfC/EknKVOnFSV6ne4
	+EESR3Eh9fu2HB7L25LKILURCx56Pl4sACXwsnUTOOMTemeVdORUi/3ZpO0u1pJ3EZCJr/9YJU9
	U3lftgHeTf1xIQkvMB3yXiIAK4wIwUXjBcgbGBGQCRTenSrcA3+1zb+ljZxMxR3wO9weZGMOJku
	6NLJT1boIkWzTb7MXhvHQLgecLCuocvBVDpntNBKw/v6/oPwN/1KfofvVTI7l3n31H1X9ZVuhdf
	IGOxxLEfQWIDSlVgzOvEp8/EPQyIQn3tTdR89WPgBXJ6Y/qUa+Ozi7D4YuzAeB65w5sKC6g/zGt
	Q==
X-Google-Smtp-Source: AGHT+IFsnvJKTM+35vwbspipp4TGFGs25ZYPlOLbrN33R++DlcW3HXwiogWfPX3LSZ/C792wt/YuwA==
X-Received: by 2002:a05:690e:42c8:b0:63b:6e65:ba27 with SMTP id 956f58d0204a3-640d45eeacemr331165d50.50.1762549565168;
        Fri, 07 Nov 2025 13:06:05 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:04 -0800 (PST)
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
	zhangguopeng@kylinos.cn,
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
Subject: [PATCH v5 17/22] mm: memfd_luo: allow preserving memfd
Date: Fri,  7 Nov 2025 16:03:15 -0500
Message-ID: <20251107210526.257742-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sk9d8bntqkp65mmwngwicj1d9webbgpk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5805714001C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762549566-646555
X-HE-Meta: U2FsdGVkX1+aFpEsxZ/0ZBm1q4lCLKPZTtkCpjlsiCFvYkpHl5mdtfuy53RLH+jm81L2qsv7LpNxBSzm5e5HvwIXuQ/x1/MqEMJPDPq5aKGuF5VJs0+QuG9wmhvcdWsRILUn0XVJcFieRLDwhSLqyCi2SEw1npGgk9U4XSbh8q7XVjQ8AzBObj6LWBddel/8oakuQ/5teMoM2lbhybAkC82AqicA19XIqHWEmHBqiJPpsNgCYn66kV+ykR8ntGNUKz0ClD9udVaYGWHkyOQ8aauU2RBRNnpnc5BTTPrKhfq00LLMnjSNaq/atKNF83hg/fgoLsuCM6EhMKDs16m8rjp07KNMH1v4lLTtjq6Do25M+6CRe8hW+2JEVc9Fds2wDYaAKTQgAir5alyhFJg68inXJj6OGRYT97Mcs5G7SHIsMofTYxpl2kOnKkSG1nmuNQ7YJomFnQxd5rGors2uv09R1Vmco0h7VPF2/SlZ9NVspPhZQjHIdi7abzMr+hkfSYYbmCYhN9WCkMAmHRLxtPY5hWoavlH1Gj0Rv64i870Vjk7iPT1VZ1i4qkpe06K8MlPC+pytUwsDw7aeu3FE0WdhmpF9IassuIalhjNzbbogsQJK7t3pxkQREdkPImTXBXMGmBIRM1gRUyo/3WzvXrPaAtORbLAAKZ1u714AAo4vi4f7cfeiD3aU2ZNKcrrz0e5ydbZjH5wqO68HSBeaqxv8ihd/B7nEWsc6EkLnUM05E01tq8/c+gIsxAOqpmy3vpHugddx8ZTQkL1tP5WBMd1zYRKC0bJHvrjzVhMi9uddlVnXwfFreZksyo1r4nrMqnnqvQotmHkw9msaJH9s1d1NKByLH8vfPFxXX2qYvWdUujd1Dxgh+3+1LrIJliA7dkeS70WTr9xljemyEOtRK2bfBTyedMKMIzDUB3smJ02wopRPLW3mIr4HLCLQXW/8N3rbZskt7wHt+5wPlNn
 5chqlY2d
 elEN7TuNkKP4X5h7sNbvmDnf8h4yJU2S8qWNNhTCbDJ+RD3aYs3kwIljm+PnWghvnYZ9/A735WW4bfk7SqVritNZJEN38+bMYdMirPt59NVOKkYbKQHxdtFj7avGnQ627GgbuxMdyqy7Q3YCDA6yKVctPpXi9007tk73Xffgj84q/AePdUHJePn+ARJ0KoJ3I6EojGO3F1RKfVk5ZO8tYzsMGW5JqG3/H/KmHxfBJAoi3efEVujZiXJTW41SWBsn7g0JgzMXP6q7lwr5A56WHqfOpqz++NCw3sBHmFZkGMsVKe82qfxSJ8YbpB8iyXEBc4UyJlRaAejCteYfEW1PuFtPRyfH3IyALcoeQn1YxHc1SUHVU+MtTzYQ6Fl+peiUmIQxYX9c90JdUT6/6DuyWMa1TWL/eUQ1xT6PKd1gG9dszqHWBzJ/piwmP4DFP9SCpHOSL70mXfOQ3wKVi8SUxC+4s9XSXSsGVCJNGjiRdDHawFzU=
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

After LUO is in prepared state, the file cannot grow or shrink, and all
its pages are pinned to avoid migrations and swapping. The file can
still be read from or written to.

Use vmalloc to get the buffer to hold the folios, and preserve
it using kho_preserve_vmalloc(). This doesn't have the size limit.

Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---
 MAINTAINERS                          |   2 +
 include/linux/liveupdate/abi/memfd.h |  88 ++++
 mm/Makefile                          |   1 +
 mm/memfd_luo.c                       | 609 +++++++++++++++++++++++++++
 4 files changed, 700 insertions(+)
 create mode 100644 include/linux/liveupdate/abi/memfd.h
 create mode 100644 mm/memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 11b546168fb1..3497354b7fbb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14514,6 +14514,7 @@ F:	tools/testing/selftests/livepatch/
 
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
@@ -14522,6 +14523,7 @@ F:	include/linux/liveupdate.h
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
index 000000000000..e366de627264
--- /dev/null
+++ b/mm/memfd_luo.c
@@ -0,0 +1,609 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/file.h>
+#include <linux/io.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/liveupdate/abi/memfd.h>
+#include <linux/kexec_handover.h>
+#include <linux/shmem_fs.h>
+#include <linux/bits.h>
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
+		WARN_ON_ONCE(kho_unpreserve_folio(folios[i]));
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
+		WARN_ON_ONCE(kho_unpreserve_folio(folio));
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
+	int err;
+
+	err = liveupdate_register_file_handler(&memfd_luo_handler);
+	if (err)
+		pr_err("Could not register luo filesystem handler: %d\n", err);
+
+	return err;
+}
+late_initcall(memfd_luo_init);
-- 
2.51.2.1041.gc1ab5b90ca-goog


