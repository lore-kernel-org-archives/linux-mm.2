Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942C2CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF5F8E001E; Fri,  7 Nov 2025 16:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939018E001A; Fri,  7 Nov 2025 16:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF508E001E; Fri,  7 Nov 2025 16:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58D8B8E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2A9A13B46E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:09 +0000 (UTC)
X-FDA: 84085043658.21.A68EB44
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BD9B40014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lOFzmYbL;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsTES3jh+g2TZ5eZZXKIDmlAfD8Fsxtr8nl7dy6CsdM=;
	b=0wlsfNA6SKKTy0WiivchQmfnowebIW6ADIEGc/ruqUrs/PRwmKeLQRNZCo5/acUIcrCSWN
	G9eVrHtkix5E5BzDn3gpE/02xhqfa743EutPHXWiuEx75ko6hAXrzmxdorDqhHTbIYjcFF
	EV3S2WS/jqfb7QBp919KR3SBX0JaacI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549568; a=rsa-sha256;
	cv=none;
	b=aIQ5WRxHvpjKtqEi0E8zOhRZwut25x0V8SWLi0S5LPc1nUwhRRPu9vhW3DxpYDl/a7t45R
	gHBDlxsrDOrTSbH/DmLBJ7vYwqk7Res7ev6yVXBKQLRPflrz/xy4sVXCAtJ08sTYApgf5U
	p450Fd9pea/jYaXj3v3tXAJLw70xz48=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lOFzmYbL;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-633c1b740c5so1104152d50.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549567; x=1763154367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JsTES3jh+g2TZ5eZZXKIDmlAfD8Fsxtr8nl7dy6CsdM=;
        b=lOFzmYbLQrD96BpN52p5RjNYrOzsgPWhTcAJcwUMr6jDY3nWu65GIBZnHGlWItlAwQ
         iVvE+/lCagD/cyNyx0slBgmAJPXQ5CgMS3JWiUrFdSz/WCyOdy3P0RXab2UDzF9SWdri
         kB96o0OiRF6e02WSJeY9vihVSOW7YmFELTyaJveWberqDI2NMfGaoBv40qmOpZIvzFpV
         G8xbJqywZ9buBA4OgJbIngyYf8yBVXwXPfhwKGZJYIydOtI9zofJBteRJw58rZrKS1g3
         mKl/QQPTsZGlhLh+BB+2Cdq+P0nUtm3Y70Ot3HJMhZG4i+JS2jb1BSdvG9+AItwZrNPn
         JU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549567; x=1763154367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JsTES3jh+g2TZ5eZZXKIDmlAfD8Fsxtr8nl7dy6CsdM=;
        b=VNkbDrdotEHUX2g9gqppogy7T9IBy+VfTjYrU0rj0CM5nYySv3Av2V4ZnwvPIuG+Wa
         fU9SZp297yUhsLDccl3pEFi3aXZrVZ229OAN2M2Nv53WduHdA0PyTRg46rkFiS20s3h4
         6Jxnh/1yPYQ9muA1CjYeouM74kdpOgyaaVHcv6RtJ6l36IFgNJcjNGKpYe3ZFIVVOeLK
         GTvB+B6G5gGOu28r5CdBRUqYBg4oQIDYoqytIM5InRggo/LN+gFjCuevoYMCdHVZ0lhY
         Oz4ZNkEfRT+kIsWv4lsjjYrUbMUF3GEprR/MOqb1wt+L9wkVTiN6w+Pk6sXjiTG5BXVt
         XNwg==
X-Forwarded-Encrypted: i=1; AJvYcCU22k7rXVFWoQA7Eg+rb39/TKIq3pzHgiaoxzcKiofpKSApjHhERzinYgmgeAl0rmiHsYaSrJK6TA==@kvack.org
X-Gm-Message-State: AOJu0Yywv7vbIAx8ENbZvItpVw6LFk52rePD6CVC5NZTCxdDEOELCBZs
	JOq+2qioowahMyzdC6Kf2BzNYr0s41W/Xk5sogHnXXwvncIr1Rk2AabBpS+UOePpHy0=
X-Gm-Gg: ASbGncuTuZ7IKGh3wBka/p5CjAePECjBVNznK2qTv9doTHGhEymEtbdByRB1YWD398B
	1gH5MORTr81EBFxS13GCwZFQefxhWGU/PnrPlbtTcz5zDds/8PBNg1+GBqPv5WuEAhtdYvyWMsD
	qsGyu1N3WuIESbVWIJF4OeYkZ0eqKXuPLxvAtJnOkaN//MDSLm8ab230+X+cYlKhV2fc6eyDwYd
	EA8o80Jy61OKxRBp6XgQ5BK+1VuSs2JM9oPQC/shSNXpopaxBeFIfEuefP18NAMZhrKVG7F7Jks
	g2Zqb8Klq92MJzzNsylc4WhHeHFjbF6TVA4NFYqPjWmHUzP+HVwUFtXH9+PTZWzVeoSy/KrEUaW
	DBs9nCQliVfK7Ns2Qwmjtchsd31fRfqzDzFDtyTodJRGVZj506kk09icbyQ4shfuUHHiqLlUaXi
	bP6ZH72j82PqShaDILqv5QoZMb9UDD80K0KlK+dXOmTEhzb2nrGi03Tp9zTq2+HUiGtCDt9zJe0
	g==
X-Google-Smtp-Source: AGHT+IFYVLUYsoz4qqSx1jdSCSSHR6CFRDP48gNnoQOXCk0YbarCB32vquZ/fupTODYyB7YDg+0Eyw==
X-Received: by 2002:a05:690e:1604:b0:640:caa5:57bf with SMTP id 956f58d0204a3-640d454752emr376765d50.24.1762549567082;
        Fri, 07 Nov 2025 13:06:07 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:06 -0800 (PST)
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
Subject: [PATCH v5 18/22] docs: add documentation for memfd preservation via LUO
Date: Fri,  7 Nov 2025 16:03:16 -0500
Message-ID: <20251107210526.257742-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2BD9B40014
X-Stat-Signature: xp14mqnxhumrzd44ycch5e3mw468krjh
X-Rspam-User: 
X-HE-Tag: 1762549567-995030
X-HE-Meta: U2FsdGVkX19k1k//6ueYlORZH9sDzQarNwkS+rHN74irhoslniPa7UrmpEFkwdK4KW7C8gxFbt++CxP/pry4kBC9VrUJe7RBquB6SJ1r3JEdxSvcLnfKEmtetm3IGVbItwP5aBv3xXjRWiuTpVt2OtmAZgpmiU9vDKaiFMvFXa5JBa/mcZvD2pLJD4ZtL+RYaQr6NOiLLEErnZ/ZOE21rbEB/ZlAkDQGR5mxW5ByI1cbzSOiMerLpDPILrKILVfRmfsiwI3o5t0QNitGd82HskYp8kilLCKUmwb2JXKcw5AoUcA8evB78BTxAZzTgLfuaItVRYHd8UGY30brgOksWgiGEvZ1pzIpTWZ7emnaguyHFamFhwqkoN8YuPPGvaxU31jKi/tMf/UOLBoLwQFVL6NWvQ68jdsb3imxb0xsIk7y+xEyNhbrG65eJX2gnLEkovhzslUQfNjnJypgAjYOwgmey7oBrLPsEtRYHdl8Q/EE3rPFjRHla2vS6UJHDbUYhhHFQRFQ9vqFsBpTV/X/KEWScN7fGCQWJln+ydm2xZQmFelv6TOHm8jbPTneenKlhLrBs29g7SI3w8F2SkRCJipFEKPy9ydhvp+PXokgdLzCQbh7XIfaQsL7PR3eD4YdCW5JwmFRisIhTANO/aGWelD2c6zscEiaJGhng0v6Ii3w2N73a0QngSCICB55pklT+XAT51f9H1FnqTYfrXT6vLGr6d0rYpFtSLXRFgz0x3TeCtSQtPjw3iglc1Jtnn6DmW319EY6AYlW+xUSCWUpzPIg5Wp909B7UgiPy3kPCPcKeW2aUZn6ebOed8gKE4i+4+j02RijntbLVh8Yq/ZKQv9GI3OVNzaOG2ecotAEznNW91N0/OLyIILO6RtI0VqKvLC6U24ax1vABgaM+unJhNCl/KFbR6X8HzD4cqfCdn/i6JbryQmJeAdgJOyGEeH+dymnC0/JsNpnztHm20x
 PDjdCGFm
 VQrgAc0vUGJTLJHo0w3r23kI+YCVKTSbnetTOmiahIhD8Vem3g4s3/h/om+mqV4JrnScmhFnRzSkqlX4tyT2W76tQOwoBpdUogugLgqM2t4YfvX1l2+tGkTky8H1oE5zJMk0/bkkKKAEyKbFBFT+0YDvFljtRRztSo9IUBvavcC5FgMhcr8/b3d1eZ1q/Mq1MWa+eu82nG0m1INhIjMh+Ody+wBp93pvkoX7CbjKCzVszXIMldFqgDjkGg04r5fhXZNcUdmWzB298vZknSeN4rx5JzMbBi63WcG2dk6ynGD4wG86b5xFQqJte8zecvqjQtzTI0OFJ9p5HLTiTR+ym7pcm4N4zi2lfQksoh66SgIFulXLXNiQ3sP5AXCz/hd8iuz2PnFChtd6ejj0v4GQUtTbxGnbYLuieRLPk
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
index deacc098d024..384de79a2457 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -28,6 +28,13 @@ Live Update Orchestrator ABI
 .. kernel-doc:: include/linux/liveupdate/abi/luo.h
    :doc: Live Update Orchestrator ABI
 
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
index 3497354b7fbb..3ece47c552a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14518,6 +14518,7 @@ R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
-- 
2.51.2.1041.gc1ab5b90ca-goog


