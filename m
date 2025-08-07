Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9986BC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A326B00B4; Wed,  6 Aug 2025 21:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA436B00B5; Wed,  6 Aug 2025 21:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B048E0002; Wed,  6 Aug 2025 21:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 068736B00B4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFE75140526
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:25 +0000 (UTC)
X-FDA: 83748269010.07.E797183
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFDBEA0003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UalhqKoR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531124; a=rsa-sha256;
	cv=none;
	b=rYK85NXaUVf3hgWEHcCsuKYxzOfNMmPkD03tPGW7AJFxzEdfNWrj4K9/JBQViEO1rxGxq2
	yb8aZ9dT9QboxfW3whefYC6OimAM4EL4n31iHPClVa0G2bIlYBnvImIjkZC53/CFAwhI3A
	t1A1zLCOIYIVCZHZ2c4Z7a1xksyDcmw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UalhqKoR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGzTQ+v+K/aDaHLB/ImuEc3dGBvilPrPVquoyLgmTGc=;
	b=h4zZ0jdpRmE6ZTfFVFMxsGnky+jcQd2jqdeLfzzDxauGfn6hHI7pnqbKy4ZQxc3ZjyWaKD
	VvqWukdkbD1cct54uqiEk54NVL2A6h+dBfVtsSLfr9QBVrYcP98vT1B/xplrVFqWTJcLZm
	lTqfAucC79QUFDoivUajSuEgT1JGCJc=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7074bad055eso3689356d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531123; x=1755135923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGzTQ+v+K/aDaHLB/ImuEc3dGBvilPrPVquoyLgmTGc=;
        b=UalhqKoROP6sapPwWkn0glrnwViJdTLEE7wa8WZPKz6ok98jJVukBJapeI1L3Xh5Lz
         ZQAkswFIrg4UKOiFTUVrL8ytQ30vubm3/KNeTwP6al9CccI+HqqZC0N+Rpv/qsWiuukL
         IabydfTbqcLW0BrFJ5RQudbEX9yXCpZ/Hpgua/OjZoevfp1Zu5hEOa17blskNXOENThR
         Cw9uqyqfA3PkyZUKEYiTGta6jNKGe98K4i5TeHRdnk5TGciVi8adlnA4vd39eygBKiK6
         NBzZa7BaPuM0z6yGexgUPu2z2uuBun81qPmc2cpJi3Z8M5/8B6kr99YDFlWPc29KLnI7
         PIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531123; x=1755135923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yGzTQ+v+K/aDaHLB/ImuEc3dGBvilPrPVquoyLgmTGc=;
        b=X6MTmCSOx+2pKDq52XWqNa6RGBsa/VnyODL1w/pS4VI2SCvRwANFpRwgtrRE2mFHSe
         nVbRcuslzqXlf1UJhb11fE2fW5qYCuWsYZ36EKfKMKPx2jVMtRlwRZfwRfuNojCUpmIW
         ct+e17ctgI2zMuByH5/zB9bEUohPcFLMslejeOG+IBRNutZ3fY7Bw5s75WLvKGm04q7Z
         o74s121yvcSMl0Vky6US8jZHx7bLOqXCls3u36PWzlrC980pWeKFsHrClYL5No6M/V2C
         yhMTzhuKl+QsmmzW82z/CKm4qrIJ815g7cdQ5JKyY/FqA9CetVVKAYY87Vnw0dOd9KE8
         Ne7A==
X-Forwarded-Encrypted: i=1; AJvYcCXw+/xI+6jfJWvDha4h6f5FuRboSoYhmpyDoUOw62ptLoQdJg5/FE0LdzuGhbcmgm/ifOEAV8AB+w==@kvack.org
X-Gm-Message-State: AOJu0YwTPdp05LBk6H8QteMnsgBseMrSLreDOgIZV/dS4AvgamUL3Rgb
	YLwMgV3BLxsJPfEpC9ZBPugjHaJgz/iG7Kky+asQKh4qnXukC7u+NnfxacRgEWgJuIM=
X-Gm-Gg: ASbGncvD/GCwblMGnz6wZI5rTlkJZiRXtJo30wN3AjKiekvJSUFw7giJuUUBw+SfAAc
	iA7IMEjTLyJA4BhmW05/FjZDW1IfX06g5ul61TYajfU68wzZWKF/V8J3NKkjbZOjumMxq76O0Kf
	VRpPVh+nS/rdihvvGKq/4kSDZky4UQfJKcwi4pD7K+boLrhYDwOOCU6JzRG333sNfw/uN5P35BR
	PMcfUqyequoc1Y/MsiDB1TYIExGSX103BPnD4FpmKmSqp21yjKpiUB6rdgZEhZ3BFSSzllbii2n
	c2wCWBtChuuNEHmYjlZ+3gL8yLYLQ4QzQ7ENmyT62XXFSx+534YC4VzsJMdn8vwvpAvxfur2Vx4
	KDOJcgqqzXIShmddfV1uKNEgCDaOw4EiwYM5KGlWV784pmnf++RZ28f7lJ6sYfWU43Q6d3SfDrT
	76Y/MoRiH4TktVLScSQ2Ow0pg=
X-Google-Smtp-Source: AGHT+IFHcYm7yT/4Xvuv4TWFZXCA+gfPfNAN3UieGuxKRFyW9+H99+FaVZtYe/cgGd4cOSeq4i1AXA==
X-Received: by 2002:a05:6214:2522:b0:707:5dac:be09 with SMTP id 6a1803df08f44-7097add7f30mr59186586d6.9.1754531122925;
        Wed, 06 Aug 2025 18:45:22 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:22 -0700 (PDT)
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
Subject: [PATCH v3 24/30] docs: add luo documentation
Date: Thu,  7 Aug 2025 01:44:30 +0000
Message-ID: <20250807014442.3829950-25-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFDBEA0003
X-Stat-Signature: yxcsrs7zgu63gthuisu5iwqgf6j6m4am
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754531123-984853
X-HE-Meta: U2FsdGVkX18CVShalboFRkQXdTz+HJQiUapGH+8iJfoYLTCxnfv9ziQE/sXPClo4Q/VACa7nyGG1tV4RD5yItEA30qqJu1GMKJEdJ8JWiAtpPHsfeEiBmTjrJp3mJUhyXFXiGbXR0a7wy+q8qea6MtH++eY6PUh873ua9prc28fOwJQiUEXI39t+TWfxW0duaYCjxgFDeMPXrELCCtB5G98GAyNYASFVvNMIqGR16s735int4PgRJjf/aM+SdBzrzd4JNx0PB8nkZEgcnY6XE/puMn4xcbI1ZGXBWgQYwnZAeDrMe23C0yEBJSBcnrn6OR7aSlllPiGjrRZAdSlcK+2fC+MgpObJaidzvVkCuq5PzsdWcpGE1r+zyft7N40JYfHybWJ8C+xYS1dS6RnXt39CT0dnuZ1bOGtOsRJrkS5Mx/2JYiZhtWHUgI1FgU34/O75teTNUm6ThhvmGq+J4ljtvnvuQFuvIFwS4I9XQLYUn8t6LtW2RLt64qsJSeZ8cu6OUmL39n//Zlz/XCqwQERSF8piMFgfRq6+IOq+M25Y7ynVDwuj04RvS/Z/Ev3IMTCTJz4w5sc5fdY3EaqJhLgDA01gAO+HSoB1AKbqy1FKjoeWknaieL0QBA3eLhgSEZTAfUyewHtkv0LOG3+Ev+krxRZa1wYaLfxNnY/35dDBpqDPbJJaxKvumBI88YXi1naKoaOzhMM+QdpabL3UmTF/SrLW6GC2r8QUkJBjPImLLMaZ7EtKI2vBsundBo1S9N0RE9C8pgWStVwJ5OIITyI+VyY8trQVOVPnkHNZ6mUyqIc/VFOdbPqO45QAJO2WHt/KInh5M624uYviGR08EaDzOvk1mq9kqeLUWXQmG4ZyFO0XEwo41rZpd2r2tQ935S9gHWKEWbVEo9RG2ca2r5e2e70ARxUroPj615SN9bXafQUdGNehWNRM1AUtURh6LEI5VO102AC7hDakGFB
 vlwJqUYU
 c/l8Ny0uhdaIrC++48G0njKn2de3b9Jkw2bgRoMdlte8B3Wuxa8ZppUDNhi9T07itMJWLkHLDrIwBBHR1qG2jH4gXMp2bKerjF10HxMKEmAWK1ZC3c55INhzvdFy8syTp7nYGG/8z0gpYLGX8aTp5w3O0EEv4oShs3dEVmvIliL68pSpR0DRuOWYMzDQX1G9LGGzweH+6R3MMezu94oOxK8+IteKBRyYgDSYWh9adag/d0TX/lmpOVitwWyyfwiSR7dX8BoWK4zJqJRdwKk68Ou6PPAFzwyTmElqvI9BwSumx+H4EtCSf7nBLyZECBOKq4ivmNq1bIi6LD1zfPJO1heCZ6EkaUltD6J94s2ILMgD7KF/JqC2tAqrJ7VxCJ5K9eAGRN+ezwX0MtsYzyf+EsIM9Ba5bRwxkz7q6BTWIjVkeOe97UzLkDt8e34oGmMtfoFQuuTRyGqwOGy2gwqMLiR5ulIDNrrTX88ZL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation files for the Live Update Orchestrator

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/admin-guide/index.rst        |  1 +
 Documentation/admin-guide/liveupdate.rst   | 16 +++++++
 Documentation/core-api/index.rst           |  1 +
 Documentation/core-api/liveupdate.rst      | 50 ++++++++++++++++++++++
 Documentation/userspace-api/index.rst      |  1 +
 Documentation/userspace-api/liveupdate.rst | 25 +++++++++++
 6 files changed, 94 insertions(+)
 create mode 100644 Documentation/admin-guide/liveupdate.rst
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst

diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index 259d79fbeb94..3f59ccf32760 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -95,6 +95,7 @@ likely to be of interest on almost any system.
    cgroup-v2
    cgroup-v1/index
    cpu-load
+   liveupdate
    mm/index
    module-signing
    namespaces/index
diff --git a/Documentation/admin-guide/liveupdate.rst b/Documentation/admin-guide/liveupdate.rst
new file mode 100644
index 000000000000..ff05cc1dd784
--- /dev/null
+++ b/Documentation/admin-guide/liveupdate.rst
@@ -0,0 +1,16 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Live Update sysfs
+=================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+LUO sysfs interface
+===================
+.. kernel-doc:: kernel/liveupdate/luo_sysfs.c
+   :doc: LUO sysfs interface
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index a03a99c2cac5..a8b7d1417f0a 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -137,6 +137,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
    :maxdepth: 1
 
    librs
+   liveupdate
    netlink
 
 .. only:: subproject and html
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
new file mode 100644
index 000000000000..41c4b76cd3ec
--- /dev/null
+++ b/Documentation/core-api/liveupdate.rst
@@ -0,0 +1,50 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================
+Live Update Orchestrator
+========================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :doc: Live Update Orchestrator (LUO)
+
+LUO Subsystems Participation
+============================
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
+   :doc: LUO Subsystems support
+
+LUO Preserving File Descriptors
+===============================
+.. kernel-doc:: kernel/liveupdate/luo_files.c
+   :doc: LUO file descriptors
+
+Public API
+==========
+.. kernel-doc:: include/linux/liveupdate.h
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_files.c
+   :export:
+
+Internal API
+============
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_files.c
+   :internal:
+
+See Also
+========
+
+- :doc:`Live Update uAPI </userspace-api/liveupdate>`
+- :doc:`Live Update SysFS </admin-guide/liveupdate>`
+- :doc:`/core-api/kho/concepts`
diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index b8c73be4fb11..ee8326932cb0 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -62,6 +62,7 @@ Everything else
 
    ELF
    netlink/index
+   liveupdate
    sysfs-platform_profile
    vduse
    futex2
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
new file mode 100644
index 000000000000..70b5017c0e3c
--- /dev/null
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Live Update uAPI
+================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+ioctl interface
+===============
+.. kernel-doc:: kernel/liveupdate/luo_ioctl.c
+   :doc: LUO ioctl Interface
+
+ioctl uAPI
+===========
+.. kernel-doc:: include/uapi/linux/liveupdate.h
+
+LUO selftests ioctl
+===================
+.. kernel-doc:: kernel/liveupdate/luo_selftests.c
+   :doc: LUO Selftests
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
-- 
2.50.1.565.gc32cd1483b-goog


