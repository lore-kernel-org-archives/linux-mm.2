Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121EBC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6A68E0003; Wed,  6 Aug 2025 21:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A77A8E0002; Wed,  6 Aug 2025 21:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9298E0003; Wed,  6 Aug 2025 21:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5909F8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 294B8116226
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:34 +0000 (UTC)
X-FDA: 83748269388.02.C99F3F2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C780C0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bceWW1lC;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxqnvx2r4Si9BOyfm56lPsflUxyGmt3u+0J7FV+KfwI=;
	b=hlq6OR4aKRZrob5ZY0DaW4T6Trf5e1Sg4FfHfrVDBD3k/FMNQiu7Pz6pKNCuwacXuNd5EA
	qHw1EvtylJvbkRsAytiqDRxbGZUFToJ6IhBRoYoWXRmPE08Biykwa2Pm+5earHmoiMsBuH
	2KaDfVQX8J5clNF4/TaD3Yd/BF1m0fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531132; a=rsa-sha256;
	cv=none;
	b=v1tzqOGY7AM5Mw6F+nC8+qjqbhcqKTeY615IpcEPal1gGCMOEkQtcnIa7gsXXycUPUm0Cl
	LhBUKXSmq5o3ae8Jm1qM3oNoF3FID7bV+1Ayjh/PhE8LJD6d8TJW5yB3pekyTRGdcFBUAu
	MGM5zeyeCWebkHWviIDqjl82N0iJ6c8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bceWW1lC;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b0a13bb0b7so5082421cf.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531131; x=1755135931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxqnvx2r4Si9BOyfm56lPsflUxyGmt3u+0J7FV+KfwI=;
        b=bceWW1lCbc7O2vU93lq/S54j3Z/hX8OTqV5A9xoqHZkVJpZVEsiCvuq7frozfQkAWD
         qTN3TXt5G+dc4FLDRsa5oCLIggkOeDDIeJLxa+AFkbHj9TwuDXUyADFq30NjXQYvA9dk
         hjN0LuYuypqp/PJN/tFX1wJAy23jLIAbtJZwaT63os/DEaY85WzSiWzMgwFhNwB56yGL
         CnjPn6OkgK0NSa0ztiYQIpcy4susWUlc3446dbvRq6EMEE6/nZXHwexvQnk1+yjMwZN4
         JEOJOB5ELMkUwAYc7djUGmIscp/h4NmKHSnI51cFPOOIe3ml5p6CcRE8A290/qrFrUKw
         8Uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531131; x=1755135931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxqnvx2r4Si9BOyfm56lPsflUxyGmt3u+0J7FV+KfwI=;
        b=dxgsA48AA1W2MUuMS1HZKwlJJM3F+gMdfnx3hLEWmuri4yT7FdGbLDVJ1aZ7J0CYAk
         7e9dJYPOlcpv/SUJ/hqh1gHHsxwyonvZMP65gcGfi4O2V6X052DzA3eYX0ajGqZUUMIt
         IgwNOEKp6ACQnXnbbKJqkY5tFumCHzPijEB2JfHldLxj74dHSlB7xc/f6x6TbR4Wgn5B
         zdBwmYKfJChPLx+zBv+gTl0XITGnix5oEUeHfSnW7eeFAGZPviYH36ESXJZVoetry3Gm
         eKt8rJA/u28f5tUDS0Wp0n0ImiTNwjwJ1SNHXkRvVsYx19qkXgWduBN78knywuHwm8Tj
         ewJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRysa1d/g5bhn4uBAzIQU/3o2BFJov2CWcdL8dngqkWvCq+mazjUjhA8/tUO84Zp+m5ik/E2+01w==@kvack.org
X-Gm-Message-State: AOJu0YxN1XZbEibqsOqAuCEfgNuB5Q3jcFhwkqhYnqPKryTGTNIDPyyJ
	tZQ7C6FdBuK85SV71ZQhieBu8/+hGUX+YJPE5V3QWBoPaaH5YccGOfVGcywV0a7t8/o=
X-Gm-Gg: ASbGnctyI/z7/Trc4wBJGEY1UcOCMzLD235JDzYq7Og47tJfdiYzIWNal0l9dSuCjME
	AUXpaz/ieDmjbVDQAC4680UsSkVf9d2TH5LAB9UlXh3QUluVLTub4E/47WG65UquLlpq0ejHO2Z
	Py+5u+OsCb5RR64saxVr4TVO2Ti8HEEnh4sbVnBp7Gnw6HxUQi4nZhwRD32HBA41d3urx5ttV36
	U4q/iMq4TxeGE7ajrl8UtdFzzT1BNgI+N5Wxr9hSzpOOEwMX4q9verrnHryveu4MNl/nd718N/h
	VaJ+ZTdRmIegHtUh4ToDSfMUCuEMLNgBMGvQXM0OyQUST8f9iF80PyOq8ySM0JNJBeM3PXoExgN
	ye2IVjRnu/IKuasy0fh5A67R3LYVvNJNUG2ipgzPY8H7gkHDNqdoLvck0DrjotbWbrHETA2azp6
	TZMYHtHtIF+ZLh
X-Google-Smtp-Source: AGHT+IE25uuFedh62vClwjbUoKXlfnK11WcIRsY3uExXHXg77BXrLNoq560jJFcvmuXwL7CnS28NTA==
X-Received: by 2002:a05:622a:1a13:b0:4ab:76bd:ec51 with SMTP id d75a77b69052e-4b0912f603cmr60022211cf.3.1754531131249;
        Wed, 06 Aug 2025 18:45:31 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:30 -0700 (PDT)
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
	witu@nvidia.com
Subject: [PATCH v3 30/30] docs: add documentation for memfd preservation via LUO
Date: Thu,  7 Aug 2025 01:44:36 +0000
Message-ID: <20250807014442.3829950-31-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C780C0005
X-Stat-Signature: nabyxc7sfpbnq6np96g5nijratakj4zg
X-Rspam-User: 
X-HE-Tag: 1754531132-636868
X-HE-Meta: U2FsdGVkX19MDvAAar6Z4ZlcIwHAdlCNeLd0ZVwXb92S4ncKjCnfIfPrXblPwJ0P7L99i5jiJZzJJgWOHhGfxIesglkknGcw04IxL2n2bXxNax+IHcB1ql8R3W8zkRr99tyjm+L8tHhypA+BN6o3NzQeVIGrU3AplmlrKS3SzWobAbhcv5UXimmIkukZnbAfYIMVbUYw7vuq9WGuN4RrBx9Sy5UvroFUW9VN7DRSsbOxJ9REyIgPNfz6dDX1gqg7ZnfYGbQbyvPSFtQDM+1LgA0buZTAFxfWDHT0nr2jc13w1bkEIXtTWOSoGr3HJGOc/YPHYXucckX72N9Z1zKTJ5G7BfE/SznNVihbFkOXDzG3pwgm4vWKAEI9yvXw8ER7pxNl7Yx66A8EsFyY8WzXcueGou+qrHx4oR/FX17LSBCeWOFPZnsOjV+DchSclhb+Uu2sEOKGd5ssl5rB4Xbpbm9J5SZx2NuJWMSAyjoYpmYAUcVqPxpFdue1LJN1xYxG/o9lElHuqoZ8WUkyt8i57oX+ZsFTrwfRSCWRc5arqF/x1XORYCYapXQ1ehvvFS1DSZwVVHQR7YMLkA46wUQuUSRhDX7ajCkiLo8LdfA6FPTA6sTxe2W83uSPJ3ElDg36qjd+uya9tQdYsP0w7gfHA9OBRwcV7tUGddUelWBcTETFN9EDT5HKM4UuSMEJ4rIuGwpdSU+cg9+1hW5uA/TtI+OPPLMSCWbPpZpkwebGdBpm8vj31MqxOVrE4URF1qiLUGpYkuoos4l2chqD7x7Vxg3JPQ97xW/f+KRoyYW34GpSdA3iQyyWvveKXhJdzBmKymv/mXmSJP9VvzoH6Sbhc/2WP7NGio1jKpJJcKSxThfBoH2qHIKa7psm5n4dcvypfBtcRaaI1+QExQSsJewq/YeLy6bA3roJUnIKp1w/y6zD6FkGYe78CXjHf43jennUTkQm/gHAia/kBHwmOxO
 BDKAb1tb
 PwEc8vFH4wTRqoY50PJUYtI5PhDHsz3eziqflrFjgsG2QkQQ/Gf8oFfJVEEHChbnSVeXkwA80KRCUh98kzSpCmI6NZLTRgaXLktU1+0ce3zMWkFMfhIpq7C+ZPBmlAUdWDmX1d7xFKGdZqrUSn+GEBD72hR/+/W+slx+Rfju+iwCxvG/0MEDNorpsd8wpMNSHVUoo3OBo7v48OrlQ/iXY2Ha0igjluUvRJkQ6RK8E/toHEyDE3bjZVHjiaejYDn+gFnnWcMkE7Sigj25X7/5tU9UXf1gl0iDLn7u1qqfq6WkRkt3MQ8+kFal8jKtfDSEMR6EoCiPEBGj0oPOqfzpmv7Fs0c4dYYx5x/CI5v+dTKP8GKsvpnOzt1ea+cWhJbyM1j6i722CVpUZbq0nvR6mdmuEbQ==
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
index 41c4b76cd3ec..232d5f623992 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -18,6 +18,13 @@ LUO Preserving File Descriptors
 .. kernel-doc:: kernel/liveupdate/luo_files.c
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
index fb45acba16ac..c504156149a0 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -47,6 +47,7 @@ documentation, or deleted if it has served its purpose.
    hugetlbfs_reserv
    ksm
    memory-model
+   memfd_preservation
    mmu_notifier
    multigen_lru
    numa
diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
new file mode 100644
index 000000000000..416cd1dafc97
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
+  ``LIVEUPDATE_IOCTL_FD_PRESERVE`` ioctl. The memfd acts as a regular memfd
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
+  If the liveupdate is canceled after going into prepared phase, the memfd
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
+- :doc:`Live Update Orchestrator </admin-guide/liveupdate>`
+- :doc:`/core-api/kho/concepts`
diff --git a/MAINTAINERS b/MAINTAINERS
index 7421d21672f3..50482363c9d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14215,6 +14215,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
 F:	Documentation/admin-guide/liveupdate.rst
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
-- 
2.50.1.565.gc32cd1483b-goog


