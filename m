Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC45FCAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F02F8E0021; Sun, 28 Sep 2025 21:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD7B8E0006; Sun, 28 Sep 2025 21:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A50C8E0021; Sun, 28 Sep 2025 21:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D091A8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB567C01FD
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:51 +0000 (UTC)
X-FDA: 83940493182.25.0BAA5A0
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id E54CF2000B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RxxFXmVk;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ45Fu6tAabGvmgrZwCPQgADOSMlHUCADrVKHKVQoCI=;
	b=tmlS5cYuBroZNpRe5oRK5cyhRrY7+rGeGr2pbrHHyyk0WP4ifRChoP6yzS2buVLv0hodgH
	4UHnUGptjrwyP4lrWKvuMPCz/HfYIST2u3el2CXBMNXhAw5l6mxNmv7cMY/9hIgcXwOqM0
	ooIP+k9ROD9sWqM1ifA7YtU4TgI3NMQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RxxFXmVk;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107889; a=rsa-sha256;
	cv=none;
	b=TtSHmcH6QYJGLh5NvYyoxGpdOe4QPBnZCxDjATZDzQMWTZIrMvSp66ysl+mcehWL7lsKVh
	D/NP4Z4SSSn3C7ISEAcPezEvpVngOopDVLfFmCZlqLaSmNqCKEc/Dg7GACrIGilhigkkoL
	0NECPsFDxFnWwKjozNFJmIh4sfcREYQ=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4db385e046dso34199651cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107889; x=1759712689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJ45Fu6tAabGvmgrZwCPQgADOSMlHUCADrVKHKVQoCI=;
        b=RxxFXmVkpDq0qAhRQ8tGDdoPnUdHh6VJr88H37YPqayZ3eLRrT6nPycxtEkXp8tVQJ
         yZsdQTCX1L7DwlIeFfVd13TbvTXEsYJ0AY/kAUVKOeMWHoir2Obj17u/THW6R0PjfH2p
         B4+oMSNF4l4SwkHudx+B+bL1+tXBdxHNH7+A9YNU8ym1CAFp1XQ8f2OU6UoWVhoin6hM
         RiVhDXOH6O3GV0gh/Nbx2mOPKsqQ0s0QlBhZifwZy8CB6ZuBdmYomvt3XBCLWkNoylCy
         gOJ5GmRrvRP4qgFoAThEBSTMoWaKl7n7B1V7oYQFAY6ZBKJPfKqrXc4NdhauRYQI5IG6
         qBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107889; x=1759712689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJ45Fu6tAabGvmgrZwCPQgADOSMlHUCADrVKHKVQoCI=;
        b=fgbxoixnt+5LfBiBTv3JMrQiPPBQ+qy4vhAo5V4f+EIMYiYu093XjQ8l3GJZvktKPB
         S7qzShghfbZJgz2l9g5Nxf/t7QWdFFfYBCvJnU1X8ishd555CSnINaU1Iyf+RMkkSzED
         QfYLr2j+8NEvhCSYSTYNpbRGLD9sfCK/vW5d9IP9fWmkdSY4+wyfY68LR3fIq+Mx/d/K
         0MoJiJyJyC+2TeImjj/5ViHgmpHaFKoMAoNf2Zm/RX8O62lbmoWbwrIYLzQG+ZPj3II3
         GCSKJi+ad9JYc56u3iRtA28jxBRHdgZRIVnorPFXPu6CgDxEwBzbtW86EE6Lqx10jGJM
         fFsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5XlsLhXEBvL8c5Lv67Q3JTEHT/YxSOHzUs2WukmTaVUyugoAXLdClaDjcqJiVi56XYW/UaEs4WQ==@kvack.org
X-Gm-Message-State: AOJu0YyIko6GzZkor0orFWiDD/Do5ctUB7CFEBbdXm8J85+9lqLfHQLh
	3Uzh0k/OCDtFmht5MoPQO0X1yKiBAIBp2ZmONJU07i61ngxyJeo3Tgi7nERuOsBlE8M=
X-Gm-Gg: ASbGnctz1cthd+z6YPjlAhL937eTlmu8BvAZbpAXrFndG9QAH5VmkEwo+FlusfIFYwb
	gaquTroKG3/1FyYHsf4PAXiekwANoX8cTFgySOh4qJ3iOf5ati5vHZ6AheJ4/zStaVyIJrxxcIJ
	mFwa1lrMFBos61tlPkA3Ot1NFOO/GV918H05PxLQR17tLoB8zqM+kOT71efvlt7wlvEb0CTbFot
	VLed6c3Aatjk3qJI/DjN9KugnnqSHvH7EFpyCZZ+NNsKRFRyGvdpjfnqNN6H/k4B8pjqxv+zgMr
	9Tj0YV5n2lANdANo5JBlgGqo0koFMqzLT6DiDD4uC/CK1d+kqo3QIEllJP7M0dLZcfIs+3DZ+Ol
	sqiPJZoJamZ2BtlYxRzqcRhhInXDui4U+K9GHa6Ges1w+IfK4EvoOrrV0v1XMrKWRdgFZipdjKC
	iJmjaeETBbXY6NnqFlPA==
X-Google-Smtp-Source: AGHT+IHY12mDEvSS4c6BYDbWBSp3AujLQ3K0TRMk1C+DYz/5jFy/PbxR43Ax3YllToE+repLGKruxQ==
X-Received: by 2002:a05:622a:5987:b0:4d9:5efc:2dce with SMTP id d75a77b69052e-4da47827704mr211866571cf.11.1759107888907;
        Sun, 28 Sep 2025 18:04:48 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 25/30] docs: add documentation for memfd preservation via LUO
Date: Mon, 29 Sep 2025 01:03:16 +0000
Message-ID: <20250929010321.3462457-26-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E54CF2000B
X-Stat-Signature: zmdd7cpj9o7tw438b9fcqs7z9u8jygni
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759107889-593905
X-HE-Meta: U2FsdGVkX1+Bnkndu+PHsSPrESVVxhwOmaK6/HULtgUtp59mJPGJp4oZeG5Gs+KmT3qrXecx8h3/I5HVNy30825NsX3MJRNN/x6HyQNAOg9qZn2SY2rJPNwgkJscO5RXO/mE9W8oj5vKCPeavpwCYreajdZ5X94B/94jABama0W7QipdT7wqwaSb+mzI52rbzwWWclPamxMGXCh6Wa6b/9ihU6Z2j+d+tThoTCY5kx5R+kOdWECewGYNqf2WtxPTKVU+rIQH0wS1CTTYOjkll50PKpGuDp0bWeudSTam0W+cNkStO9+fcEmeL8XU5sPdjAR0bt4TOet+lydAhO1QMLQrOGiMigYN5JIL7SqTgW63qLNtnl9eLfquw0BE0VptNuuaqZle9yvbcv5J9lFpZ77/Swokz5tYKpb7AtSAV3ZKRITMMoLpHJsHsM85ndq6ZVK0/C2r8k0jdRFXZkraF86rxmrP2KS6QkOmsgkqaUUp+kE0078K4FrPMitjq1nUEtgQNv4lgaEyt/+/GRe3wn/+W0wg7u1avT+azes/w2beiNYgUVtHmxj9d9Z9/tPZS0C4sxuDt2h9w0/Xf8XZdby8o54Dqxh0h9lqAGmzguskPVFqoA6czfvoicSCr0r0o8EogJOERzRg1ORbEj1IsuumAil59VQbx9NhMSxVpMDCLBj6v7ygokGcU+VtI6vZEtOlEf4X4hqjey7QFI5AzdX+r+s45GSkhZfIeEqxlyHSYLj6M5cIWBgPx732/vgKPWiRmwNhnkjmxHcsT6UR/f4wgb4NWzCP4/7GbvHTPa3A+5tCgoF/dgTTzctRVQYe+3zqW2joMglYsMwN5VM6yoVKrITblcFuzg0aQOvp8wPMb3nksk7JOG+FyUcB2OVtb4YGGGP0s1Ctl3iRq75TmPHUtZ0atfscCpDkpGMsLKSdyFKzh9xUx71llto5KFaKSboEFnJ/DWtVU3QQ+kV
 nNBIgiOW
 P1MtneH1bYY06X0zPwtSRqTyo8jlRwxMTY/xGCSE6/NgjfCvcTRIJJVPCUMlO00I0EBqCIMe8ilGVCBaDXQyvOjeYfSlIC5E4c8uD8rwGl8J6INInWr8okm4R2J/uKwWk+1QVFJWdxWVklh+0bz2RMZZTbUkbr+Ise9XN6yzaJdSKr00RFV/M4EhsrDVUZyoKnSU2mL9P3rpnFi0DmFrJaaWojAPmDwsufLwGizoRBdTxAI+R1xEBdcworyWdGsw60aEa9U8fAnfVZDxvR3taDF4Ch6Ah/JanASRfNO3l3N9JEttAS8l+LtZA/SilWduYTKJmGV8W1HoNxXvb6QYs52Hd60RS39CIviBYWoNPMRde8XyQcLFWc6u+W5Qu/gLOjTRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

Add the documentation under the "Preserving file descriptors" section of
LUO's documentation. The doc describes the properties preserved,
behaviour of the file under different LUO states, serialization format,
and current limitations.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/liveupdate.rst   |   7 ++
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/memfd_preservation.rst | 138 ++++++++++++++++++++++++
 MAINTAINERS                             |   1 +
 4 files changed, 147 insertions(+)
 create mode 100644 Documentation/mm/memfd_preservation.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 7c1c3af6f960..b44710d75088 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -23,6 +23,13 @@ LUO Preserving File Descriptors
 .. kernel-doc:: kernel/liveupdate/luo_file.c
    :doc: LUO file descriptors
 
+The following types of file descriptors can be preserved
+
+.. toctree::
+   :maxdepth: 1
+
+   ../mm/memfd_preservation
+
 Public API
 ==========
 .. kernel-doc:: include/linux/liveupdate.h
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index ba6a8872849b..7aa2a8886908 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -48,6 +48,7 @@ documentation, or deleted if it has served its purpose.
    hugetlbfs_reserv
    ksm
    memory-model
+   memfd_preservation
    mmu_notifier
    multigen_lru
    numa
diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
new file mode 100644
index 000000000000..3fc612e1288c
--- /dev/null
+++ b/Documentation/mm/memfd_preservation.rst
@@ -0,0 +1,138 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==========================
+Memfd Preservation via LUO
+==========================
+
+Overview
+========
+
+Memory file descriptors (memfd) can be preserved over a kexec using the Live
+Update Orchestrator (LUO) file preservation. This allows userspace to transfer
+its memory contents to the next kernel after a kexec.
+
+The preservation is not intended to be transparent. Only select properties of
+the file are preserved. All others are reset to default. The preserved
+properties are described below.
+
+.. note::
+   The LUO API is not stabilized yet, so the preserved properties of a memfd are
+   also not stable and are subject to backwards incompatible changes.
+
+.. note::
+   Currently a memfd backed by Hugetlb is not supported. Memfds created
+   with ``MFD_HUGETLB`` will be rejected.
+
+Preserved Properties
+====================
+
+The following properties of the memfd are preserved across kexec:
+
+File Contents
+  All data stored in the file is preserved.
+
+File Size
+  The size of the file is preserved. Holes in the file are filled by allocating
+  pages for them during preservation.
+
+File Position
+  The current file position is preserved, allowing applications to continue
+  reading/writing from their last position.
+
+File Status Flags
+  memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property is
+  maintained.
+
+Non-Preserved Properties
+========================
+
+All properties which are not preserved must be assumed to be reset to default.
+This section describes some of those properties which may be more of note.
+
+``FD_CLOEXEC`` flag
+  A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
+  ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set again
+  after restore via ``fcntl()``.
+
+Seals
+  File seals are not preserved. The file is unsealed on restore and if needed,
+  must be sealed again via ``fcntl()``.
+
+Behavior with LUO states
+========================
+
+This section described the behavior of the memfd in the different LUO states.
+
+Normal Phase
+  During the normal phase, the memfd can be marked for preservation using the
+  ``LIVEUPDATE_SESSION_PRESERVE_FD`` ioctl. The memfd acts as a regular memfd
+  during this phase with no additional restrictions.
+
+Prepared Phase
+  After LUO enters ``LIVEUPDATE_STATE_PREPARED``, the memfd is serialized and
+  prepared for the next kernel. During this phase, the below things happen:
+
+  - All the folios are pinned. If some folios reside in ``ZONE_MIGRATE``, they
+    are migrated out. This ensures none of the preserved folios land in KHO
+    scratch area.
+  - Pages in swap are swapped in. Currently, there is no way to pass pages in
+    swap over KHO, so all swapped out pages are swapped back in and pinned.
+  - The memfd goes into "frozen mapping" mode. The file can no longer grow or
+    shrink, or punch holes. This ensures the serialized mappings stay in sync.
+    The file can still be read from or written to or mmap-ed.
+
+Freeze Phase
+  Updates the current file position in the serialized data to capture any
+  changes that occurred between prepare and freeze phases. After this, the FD is
+  not allowed to be accessed.
+
+Restoration Phase
+  After being restored, the memfd is functional as normal with the properties
+  listed above restored.
+
+Cancellation
+  If the liveupdate is cancelled after going into prepared phase, the memfd
+  functions like in normal phase.
+
+Serialization format
+====================
+
+The state is serialized in an FDT with the following structure::
+
+  /dts-v1/;
+
+  / {
+      compatible = "memfd-v1";
+      pos = <current_file_position>;
+      size = <file_size_in_bytes>;
+      folios = <array_of_preserved_folio_descriptors>;
+  };
+
+Each folio descriptor contains:
+
+- PFN + flags (8 bytes)
+
+  - Physical frame number (PFN) of the preserved folio (bits 63:12).
+  - Folio flags (bits 11:0):
+
+    - ``PRESERVED_FLAG_DIRTY`` (bit 0)
+    - ``PRESERVED_FLAG_UPTODATE`` (bit 1)
+
+- Folio index within the file (8 bytes).
+
+Limitations
+===========
+
+The current implementation has the following limitations:
+
+Size
+  Currently the size of the file is limited by the size of the FDT. The FDT can
+  be at of most ``MAX_PAGE_ORDER`` order. By default this is 4 MiB with 4K
+  pages. Each page in the file is tracked using 16 bytes. This limits the
+  maximum size of the file to 1 GiB.
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
+- :doc:`/core-api/kho/concepts`
diff --git a/MAINTAINERS b/MAINTAINERS
index a17e4e077174..a9941e920ef6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14438,6 +14438,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
-- 
2.51.0.536.g15c5d4f767-goog


