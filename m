Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4AD0CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625C16B0031; Sat, 22 Nov 2025 17:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFFA6B0032; Sat, 22 Nov 2025 17:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4293B6B0062; Sat, 22 Nov 2025 17:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5DE6B0031
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E82D4130A72
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:15 +0000 (UTC)
X-FDA: 84139672470.04.61837B3
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 554304000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d2bwhr6H;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850254; a=rsa-sha256;
	cv=none;
	b=8Z9cPQpYN8RohwyzOOWQXGQ9eSvqYhUal/AXWJfbwjHQYLacvXlaF8gpbQQ1Gk53caJOwV
	PB+QnTfDC1qzy/purRKCWkVWLPBqwXvIt1XSCxQWc+AIAckzxeR6cHL+XC4NsQEFEkcwbR
	GKOW0DxsLegDttC8k76Un/pV8ZGZ5eM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d2bwhr6H;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9VyPKNhrn6KupO2JDxcjMrdrPrlD9k+PG4k0aWwewA=;
	b=ly67pIcemO5F+yz1Na4YwfZV6LNGjKAQ+OHpq3XwxsAe6D1ZAVPXbc9ImBBivEQhu8zDWt
	sMYzEn87sNO5a8iIOM9d7yrz3QThq4trxLTkYLTnjIFXtabIjc39Fngv5GXz4weSgM53Wn
	DPDhgGxNpTrBjAF8qQIGPmXp2PTt+0k=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-786a85a68c6so30684157b3.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850253; x=1764455053; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9VyPKNhrn6KupO2JDxcjMrdrPrlD9k+PG4k0aWwewA=;
        b=d2bwhr6HTpXN1D22WHBSirJ/OCJMFGBapwEBLjeyUDvEZ9IKry+vPnDad1XFdwoBpA
         eRimL9JdDGZBtqktqsC6ocvX/RymAyxz/7MX/wEo1EpmXcjsxfCP0W5bYCjBlxvjpBaS
         CZz/jRu9wdQ4Wm+XER5KjzVNzmzeE4ZPnGK1ox31HLKteXCjRvwYGOcB1kePYSYWJMRE
         DWUsjqI7UZFjXgxHkUQAQMcOlkxzJMG/LJWjZ2RrlH/s+tGlsOyCTF02traF4mSmy1I7
         jY7owKBL1UrgC4jWUyL5TujI0R9z1+Eohnxmc8X0TkUHuSBQn47TliGBDofxAQ4Aigkt
         SZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850253; x=1764455053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G9VyPKNhrn6KupO2JDxcjMrdrPrlD9k+PG4k0aWwewA=;
        b=RnKcF1bARmJMUu27Bjj/QL3M9MlkdM8BvAXzCP/FC7Adu+yD8ATuhSCb0gqA5yZbhO
         aLo2ldiBqbPASZMqRANuP/ppfExAeroiAIFi2zYQMNvt87j96BTTj/bNbUwQRG5AKVz6
         slq7QXOHLVbZyyPYVazsXkvjmYvXY+/capP8n2MHrEN7aD5KUbUQw9+giDv6vVHn34AK
         VohBWrvSiCPhsmxRVvJnjS1jRvzWMRle5Coud2HWP+1EV7tG8gK1ud0glp8O0PqEcFAw
         wsgOZofy+yEzlJmxVH1+SSIVmtEzq/iMiBcmO0wzjtXcvns6fJBAYJvkFhZtMgJJywZN
         6W1A==
X-Forwarded-Encrypted: i=1; AJvYcCVcQmliI7MNDkwiA5dWe7SfeLgsRyY11E1emTfmvktVPsnNWTfqmB32rDVoFuMh/hzEtvhiP6NXhw==@kvack.org
X-Gm-Message-State: AOJu0YwTFuiT8XWtKZdubiw4RxxsEflcxmb2f1XlcIgEOUAOOTsBTIOi
	lb6Wlx97cHoqmUup2bYid6dbPa3AtJ31UabJvurARcyF1IqpxFsykDkcFyBG18o1H8c=
X-Gm-Gg: ASbGncu+ep8JyqiJKyR1g+qsH1NEvTQD308iZGdW/Mrw6F29W4SXp/ZWCwqDZEV0sR0
	5/9giOXgoQwlXWDTG1nwcgKinw/cTZvO27AXJGd5N3u+zNxmcDbOaDAaxap3/WTbKXMalzAUK4J
	jcrxzCyv2V6HxQKbmAw+Dts3m3GkNTQIugkxyah7eN+waFQrRBm+9+jk9qJegfxk5V9zUIsDRcB
	frDrBbSZSQcdScg/StUHUa3pb3KFit0rvEA5fCCwgCQ1WoK7P6unFF6PZe6j9UIWknV/O6LGFc7
	3qZqosAI7JjsjcP5lr7ZbtUa/MaEsX0LZZv0uhLekQFZNMu4W71LYSvwXtG3tXJ5hRbhKN8J/Kh
	cRZ1mgbcG2kBknWnNHi9mFmZ4hSvJwKPnpKFk+Zo09srVscCw9SKDpv+IyLfRm2/RgoGyFbGr1C
	jnSTfKzbAeLQOG/zXFzDRiIvxoShDUZu1CcvlhQ+sf/R27u58q4ET62UbtnKAxuQcGoYwjQMU+s
	SGmENuRaRkOgAcKBg==
X-Google-Smtp-Source: AGHT+IHmRWFE7rOb/6+yLAu3Pk2al1IPioQp+ETOH2bTApyjFAeLipumKzaBW+6hLLJxhT3rh6iVOw==
X-Received: by 2002:a05:690c:d88:b0:786:a39e:e836 with SMTP id 00721157ae682-78a8b5672d2mr62717227b3.60.1763850253309;
        Sat, 22 Nov 2025 14:24:13 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:12 -0800 (PST)
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
Subject: [PATCH v7 08/22] docs: add luo documentation
Date: Sat, 22 Nov 2025 17:23:35 -0500
Message-ID: <20251122222351.1059049-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 554304000A
X-Stat-Signature: ftu7zy3ixg9ejkzax1xu75yntnrybqzd
X-HE-Tag: 1763850254-546056
X-HE-Meta: U2FsdGVkX19jij64+ll7Y8eu6E8AzDeMiDIxvev+UmaNVZLMClsrLcLm0lBlb8ob/CADNv7z1iDRKR6DegDoU01lKpBfCLAMzD1BKX809kHbqsBd7oQdHegaoZnVpY0WFVLXTyIM6WSCTvWDrtetw216RRFhx/12R0R5CNK+VtW/+7llNcKT71IDlvVGwy/G/fbShBCEuLGNlXbhl8GXTyuj37pq8vCyd7IYqo3T8VCAUM8MVJvTKuNok724lr0jd4lBPj+JLyIPiMXz+H3cOJzDhiZ65R4OyqZy3FcQveYm2HRbevmQLshpqDa/YBBQab/r+69jfOHNXrmBlc1EcmC3wl/2ftCJ2jyZVmS92cueH932OY5waUPwVrEI/Ln639PQa5Hx2a2sHmgawcKpYTfJv7OdnUrlZln9aKiPlhSrMQutbuS4qT/PATcJPaDfsE+RevyttgicdW19pirtyKw/DYr4ei7Ow6hv2C0yle1UvT+wiz0ZLYPxUFp/E3wYHpUtejAS7KVc3DhxJJQLR6dPw2GEnzZAhwHGFkxr5JH1FYVtiFDAJVdVJNXGTOccXb9UALv1c/cS9FYmjEMBlAmlZV89aTeAdO98R/nLsniMbqpIacXyKvZoffOZMgRawtU84/ERJIEDZ82Omiz4e/AVrcmwYYg8iwk8CiV+0AqdwwzA8a3c/7+Y9VaaG51Fz08RU8nFWyTNsz4RkEvgdR6r2qbVTPQ7dHqw2+1k4nwQ2sOFGX6txQrTCR6CamsxlLQezR9jy4MgUCsEfmLPyb7Tzd+/Ye8I8ct/7JVbwODRRh4KDzPeYmOCtjPZIDqpdVC6FoLhE0LT+PNwoLJQapW9OVzdKNKTDbQT2yMxWsPjWUcG4f1VvwNMRLyEniYuxhJfaHWm6aYhNTOkxvu3WrdkIhlfnv/zJ2dv2GTiSs1U+omCezk8AT4Zb8KUTkN2QsfcXOpl3BiWpDSC2sH
 5lPNaFso
 E5QfamYF/RzxNHGkx/z8Y44y4kI+XRRV1kn/Ib7QoFvDnhFjXG15OeQWD9Sao1w4U2hsLqlYLNvRVbI2+k2U26vPguQ==
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
 Documentation/core-api/index.rst           |  1 +
 Documentation/core-api/liveupdate.rst      | 53 ++++++++++++++++++++++
 Documentation/userspace-api/index.rst      |  1 +
 Documentation/userspace-api/liveupdate.rst | 20 ++++++++
 4 files changed, 75 insertions(+)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 6cbdcbfa79c3..5eb0fbbbc323 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -138,6 +138,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
    :maxdepth: 1
 
    librs
+   liveupdate
    netlink
 
 .. only:: subproject and html
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
new file mode 100644
index 000000000000..e1f0c13d5b4a
--- /dev/null
+++ b/Documentation/core-api/liveupdate.rst
@@ -0,0 +1,53 @@
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
+LUO Sessions
+============
+.. kernel-doc:: kernel/liveupdate/luo_session.c
+   :doc: LUO Sessions
+
+LUO Preserving File Descriptors
+===============================
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :doc: LUO File Descriptors
+
+Live Update Orchestrator ABI
+============================
+.. kernel-doc:: include/linux/kho/abi/luo.h
+   :doc: Live Update Orchestrator ABI
+
+Public API
+==========
+.. kernel-doc:: include/linux/liveupdate.h
+
+.. kernel-doc:: include/linux/kho/abi/luo.h
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :export:
+
+Internal API
+============
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_session.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :internal:
+
+See Also
+========
+
+- :doc:`Live Update uAPI </userspace-api/liveupdate>`
+- :doc:`/core-api/kho/concepts`
diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index b8c73be4fb11..8a61ac4c1bf1 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -61,6 +61,7 @@ Everything else
    :maxdepth: 1
 
    ELF
+   liveupdate
    netlink/index
    sysfs-platform_profile
    vduse
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
new file mode 100644
index 000000000000..41c0473e4f16
--- /dev/null
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Live Update uAPI
+================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+ioctl interface
+===============
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :doc: LUO ioctl Interface
+
+ioctl uAPI
+===========
+.. kernel-doc:: include/uapi/linux/liveupdate.h
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
-- 
2.52.0.rc2.455.g230fcf2819-goog


