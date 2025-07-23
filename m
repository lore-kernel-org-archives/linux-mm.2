Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C68C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347996B0135; Wed, 23 Jul 2025 10:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EC36B0137; Wed, 23 Jul 2025 10:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E63E6B0138; Wed, 23 Jul 2025 10:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6486B0135
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF286C0714
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:56 +0000 (UTC)
X-FDA: 83695808952.02.B810176
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id E691E180010
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=XqX6fjGe;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgvqzDIiRiBX+3t66TRkd0Ymp5/wa/ERt/pQr69clFU=;
	b=I6AXhonv8zzgdmRbI2pBj0qVu4OJifX0p7T4gB+Y7XA9CaxKPsgYuY8jwxiIDE2B3r2gfs
	T8iXAF75MRaPDiM9m4ss+8zLoN0fQFULM3mMcHAg4SQUpa76p8I8/hyWiLTMPJ4g4olIdr
	RjnRalOblok91gQi+VDwZHN5t+f4iDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282075; a=rsa-sha256;
	cv=none;
	b=wN8AfmgkwsLkmPrN+jGbSq/uob/uuZYyddMrV9DBACoF1G0s7n/38b9N1Go4Jyyl/S197n
	fZYoF84TQZ/50V1SmM/mpFopFMhgaFoD518moGjkxbaNTgAxJE+BZvYZFdRKJCNLtbR0tS
	51H2D4bXxWbyE7e4ukEV5fXT3TgZ3Nw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=XqX6fjGe;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7183d264e55so67251817b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282074; x=1753886874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgvqzDIiRiBX+3t66TRkd0Ymp5/wa/ERt/pQr69clFU=;
        b=XqX6fjGecpsh9WnHc563KORx6GDJg1pU342R2GRXzUpnPpK8JmTndovPnVsFU7O2ly
         cBLBtvt6Dzj/OfLH3NZJLwwJmm+OSry8VEz+1Sp2C4d9UVEvMpjsv9cats1E4AxwsBmy
         adQZWl3eDL7a8chYzHRf9c4hgokPtPKOeCdxnuy3HeafHOfgIQFvidafwtkkLBy3RI+F
         Ook+oODjtmNKOo4Fd1qBr+z0gA+/EZLWRQRX4y+g1OqYuynxDg6asxlAaNdqDf5agepo
         WYnFqwzS66V0zvBj4wk58SL6DeALf5wV/KwAk9mi7HAfQxMW1IiFrJfZx8KYUkBNUHIt
         4TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282074; x=1753886874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JgvqzDIiRiBX+3t66TRkd0Ymp5/wa/ERt/pQr69clFU=;
        b=EeQziOgNh86xMzBlIO6eokxubWhBNj5cjWtRU8AGUsOuZd7elNcJ4H7j1dLdyJ7bY9
         0IaMU9/AbgukQt4Qu7qOolXi7x13ZWM7alpLwtwMNaN85ifrdxxnLiw/7zczXhSLXsVB
         2jXwYQVhY9be9GCdkLdkYWlnUePXTZcgo+XAfzkp+7hRUDNHlYznI2nKAGFNygxX2JdS
         dcgDkzhpE0BvOmELvwt00yrdCtK4YYvMKUSRNuQtNWYmrFldFCiudsCAnf4CpqKAkSQH
         9Rl7tkculuMAXyIahJ223Lz47pRvuYF5YtDmpvg41M0kRhR92M2uuBAxztGSJLAIpXTn
         Pnjw==
X-Forwarded-Encrypted: i=1; AJvYcCW3ZWAE/Cug6IegWVmU/0GyssQ0F/dUt9ceKS/mnVt0xuHH2ed35e/JegrMmerkEqMfbGRRF9sT4A==@kvack.org
X-Gm-Message-State: AOJu0YyrdRMjRE4L4pgbYtW6j5QmXMFXXEUU6q32YNkBjrZfmEhm8L6w
	7H5pCyKcfl5kmZDkWCsVEqWUOh7ptlMPE8vkMAurRUuQaAlr5PZlput1lG48NjJmAvE=
X-Gm-Gg: ASbGncty3BVCPKTgv/Dfm0qBS8JMrMWTvLD2ZyvS5TEV9OdA081P8UaFTUlhKPHnppD
	cO+8s9waahHeAmC1ODa3ehaGf1hHSDW4BorazWGRZT04AUe+qQyErZwkqDszQMD4jUGTfpZr/A9
	b3tjBuhD9F7u0fxjJdiU/XmuqeB5AJx639zW2clg0Yjst8AKAnCPHCd2oOGu+IHmkIR2tryftkM
	zSLcqfkxQwQ1G+jSaZkJz+W69dhgBGdEAWQTuEkaVFdVSdDOvrQQS/L6Z0xpqTEBrvv7UohffJ1
	Ad5e8n3Rho1eQC3R98y8rLcXZNXLRQIil7l6xLKwfkP/+d7urZ0mW3U943cqru8OVA/LVMjQ2Z8
	e7OLlV0aaksNJfVAB2/haxUxCprndBtjqONpiHJom+S3/OCerWlXTMjvjvThrsv4QAuy8osjeRY
	xxhsLebBJRstcNVw==
X-Google-Smtp-Source: AGHT+IGGfx7z148fU3GfejgZgpbPyTfIvTW82LKz4E+3FHtFbrw8wPq+9rOHj4lG5MqVILJufgSXww==
X-Received: by 2002:a05:690c:358a:b0:70c:a57c:94ba with SMTP id 00721157ae682-719b4166f53mr47129757b3.17.1753282073888;
        Wed, 23 Jul 2025 07:47:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:53 -0700 (PDT)
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
Subject: [PATCH v2 29/32] docs: add documentation for memfd preservation via LUO
Date: Wed, 23 Jul 2025 14:46:42 +0000
Message-ID: <20250723144649.1696299-30-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E691E180010
X-Stat-Signature: dju81frn3rp64ktn3w7qhjte6zau6xy9
X-Rspam-User: 
X-HE-Tag: 1753282074-769951
X-HE-Meta: U2FsdGVkX19RprnuW5di3d5TRGj18TyHDyW4qTGGvrAolx1ZMyDDQ+OEfCCenlWJvRMEvaHfeZb9aeaTQMQtrmdV7alPEpiGr0uEOZoCMuHXqodxjRzJYP+xBfPTitDQeLikWN1d+M8bVtWemOdzqn9wQCR3PyuQ26mEeMSRf4dwbhzhVUtYAxdyzlfJPd9TE4tgF5hEaic2axo0GvEni3Y0N2g5eZjWjTFGhXbvrh+NoojHUUvSl6JvPnZDhuuZRRQhX1nfM14FJgDfZ6BlGYX9Fi2tV7FXx0j9AkjylbbAVIMvxelUOWwH2Z4EE0g11prNpX/m0gHCw2Yb0Q005kBtS5c6iGUU0AviNhdV6chHlVvexS5cJgRDzMeTxm0qQ3COT7QS8y6cfDGsfHKIuqHGQdvRxLEcYmB66cRXf5nJqvLtCmslnZKT/v0O/Z1VX+MWQvPyB2szt4O16LK+wJ6g6hC3RYpTV3P+mysgyWcCbAGmCU0X8TPWw2KWwXSaBaRooi/10nNHC//wtQpxd5shxe9gollCzedQYyc66GGuPf1N89KOuXT/4EotbCbhffVrD23W3vk5hc5HjOsP6yrjxZsNcNqyykQBkMtuRHPy1PO60i4ePcCVRszUrSEqLo/GxhmjTCeSErsh+iFPR1GyIorEeCtaYbxDoTcAm5WV48PP7FLIA96WMYCOF7awe4r4ySRclQYl2DjlCD1vhgcaL7lpNLuvZogn7us1j4OT44Lp/Ke4umDWLfmlZ0Xp+196uT1OC4xxik+YCq9SUtL5OC94alaDr7Suzy0a7GiADE3wHOqMRtt/vemdouBdY9ku39n7mty5c8IViSo+OTazOyooOHSGN1KiiZYrYxCTrhtw0/Rp40/k73b9kIcpejHgUmkPlInODGzBV438mvN3znsIvXyA5Dzq6Cq4Hq2giuT0YHd0lMyX6AxDq9uRIvugrjFMmiVycHDz8St
 d7LhBJHj
 ZymOq4E8YaEydzzA5zEjgBK40cT8AUQAFLXMkY06uFFaUgC1Wk6TgYsTd6LV9iJMQgWWMaPDt7Z1mETBlyNtEIem3NrRAsAu70CYAkBD4xKHtL5hn6pgPorsGJrJXNswJPcwRx1wwroN0UEKzE5WTBORjzh7IDIvLTnVarWbXWwilke9XEJBa3uhbmK70fD0ML3tNihYb1kIhI7QLUtbdkcKB1DRa9a7lGZMt7lmoMEKeOQs9IAKM9wm9uNJH77oDGPEE+vpU9R/V4BzvgcTHCtYdARk7MnMuKtMsrMtxsnl2N+IvTj1hkaK9D+JjpOK2CsfIdq8xtlA1fYp9VsaZR/B5Pp0SWKnuWLzK9kempH4w2gWKgKhWjxyBRPUYzgP/IjTd95V/5aCSEFnLxW5QdkQIRxKqKf4GsPlyA1gD3ZVi415HhKb8852G49SnwlqUeLEAkwj2fM1K+amTxo92lhfQxaDLKbN7/dAZhcPvnJm3EZju+yOKs4y3WUjvpFVLCfLByQKxyN5dl2RSoaGkOgO+IQ==
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
index d3ada3e45e10..97267567ef80 100644
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
index 361032f23876..b4fde9f62e9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14020,6 +14020,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
 F:	Documentation/admin-guide/liveupdate.rst
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
-- 
2.50.0.727.gbf7dc18ff4-goog


