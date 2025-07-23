Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2401EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1F96B0126; Wed, 23 Jul 2025 10:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653516B0128; Wed, 23 Jul 2025 10:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4166B0129; Wed, 23 Jul 2025 10:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C38B6B0126
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D8B8BAE46
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:44 +0000 (UTC)
X-FDA: 83695808448.20.39D2C83
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 629AE40012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=HDNvWHtC;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282062; a=rsa-sha256;
	cv=none;
	b=Vwm6hWCWLWJYQeJ/CwSwH35PyF2SqM5nOwee/lQXxhPs6AhvrxDxb+ZhWKJvv0c7L3LTFV
	LY/JF6IhFirNJwQH08KFhgvLO2Z8/Yzf8O/dMcHtD9WoNH4+ySNhWgSR9L0TMnMTyvpOEU
	4K7AxYA2fnaW6VVu747v451rCoGT4sU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=HDNvWHtC;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NC1ayEHkvN6ijinKURZBxrM3hNqjaSgPk5qZ/n3J1rM=;
	b=oO7iwuGZGBILw+FkOIkQf5hgIdU3Mwy/TednGROXiLv+GDci92aozq2V/bqLNhe3x+B4v8
	foWn2zycsuZNl1a+yo4zXQMb4tNm9bXwpjtkp+Y8NtpqjOI3ct0GqPERe79WMYiKVi6WPR
	YXbDSlboJQdhjvVL5Kkz4KF/KXIkanA=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7183dae670dso62723507b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282061; x=1753886861; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NC1ayEHkvN6ijinKURZBxrM3hNqjaSgPk5qZ/n3J1rM=;
        b=HDNvWHtCieg2BZoJ7rjl7mXYBh/deUvxeJ1usNlXTUDwcPmKwI4pcevgA85ewgx8pG
         rkGymPibqwaaftXY//5ZFAb7282Gh3flWO6876lD3oZSLuSA7MFGK0s62AoBesa3pyBc
         ESBg40ZMeQulDMVCU5zbo+C96pOQ5G5Lrt9gPjIe1lnm8H6f4v29OAgB6d+nrokqRXnT
         jMYUNnYYxvpNcG7hVva6EVgKSsydiW0RM+LcdlaBr5nvjmT/phoA4buj35UyCQMMdGEI
         NbWPDhlAlreA//FrvUxXr5GdjxpAdbVPMNSe8ObbdWQMUwJ5yyH3CgnY08zqJDa1naX0
         4H+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282061; x=1753886861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NC1ayEHkvN6ijinKURZBxrM3hNqjaSgPk5qZ/n3J1rM=;
        b=GIfAdMXw8MQknnkXG3jDAOQAtfKBOuObgAUlmqR3byffEMwFEAZ6TH7Gf4jxSH+OSu
         5jx2+8Cr5Jye5oLC2QDLvNdavm5ZOUARKM46zTf79E/sRAUNgo0cGPyhGcYOIgxFDedM
         WKOLj/9t1ihYvzgF/vDPwBjBMKoZszc25jZIWf1kiTnU6CE038ghCjlQ4TI2rTUFhJfc
         eCm4nt3mH4id8ee3AR+de6cR80UUcC0Ame1r8EW1xz9oaQkoHunQrvX2arNXno97PqQ8
         5sDvwO64+1AkEZCmJqC+v+f6EGxJ2OVUVqo/6L6OnkDvxZugfG6a7Fd8Y/Dx+uIvznIs
         RfVA==
X-Forwarded-Encrypted: i=1; AJvYcCX3xwoieKsOTss00Rh1IPxqT14iR0QKDhI/cYfmKVif8lf6G4cpa4drPDd5BNAMzTEEoHujUheKCw==@kvack.org
X-Gm-Message-State: AOJu0YyDdsE8BqiTKWDW+fbdSJBwpSxlYkr0KLCg4IisH8lpx0SiSvr6
	AMfwg2bJ6T6l6kF3A8oOdMaeC5G0XS9QISbdpnvYSjIv8yhTvi73bfL+Zye7uqheOKk=
X-Gm-Gg: ASbGncvXql0Hz32nfM5sEPBsdyTZiJH1KhP7EVljPSM9Fm+Eu/iLKs2NJmGBmIkXjF6
	io6O6f+NaklWJm7b46sKpYPr0HFNxFWiQkWmNo5rVLAm+emQ9N/7ZkvBnfISDqAq9dxlNStE06a
	YrOTH3gFP/zN97dykFtatFmx6DdsuhXHUSS5/ykqZUrYa6fbgE9JU6PSmBAqq5CVfy2QTRMVH8S
	HkHF3dVCp6bz5d3GFqVQb+lUT5WUdo2nmTGS5wYhWP/J4nSNKgmX7byfIqlcwQSM9LI0FPY8chE
	ZJV3Re2SjxevNxgKw2etoTjwfnp58+8CeBW+WDiNRJcDqMPMA8T6VVY8tSIldux3JrPkLPvNHqb
	B0T5+JHNX/vLJ5GF7co/z0CUL/lnxkZtIR9DsgF5gEgnNc5gkcGQJaBMVges7qubSc36OUQs0mQ
	82EvHZF9HqS3Mzuxi7PSCvx27N
X-Google-Smtp-Source: AGHT+IHtTYkgbLD8Z9PD3xbOoYfvfKs4NkwGaH86Xh5bYMAIlsFdLVYPN6ZxosRwBh+RGdz+VhmZwQ==
X-Received: by 2002:a05:690c:9681:b0:718:4511:e173 with SMTP id 00721157ae682-719b4185000mr42897137b3.12.1753282061377;
        Wed, 23 Jul 2025 07:47:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:40 -0700 (PDT)
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
Subject: [PATCH v2 23/32] docs: add luo documentation
Date: Wed, 23 Jul 2025 14:46:36 +0000
Message-ID: <20250723144649.1696299-24-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 629AE40012
X-Stat-Signature: gg41tqdqnp4f5kn1g88cut1zqa7etsi9
X-HE-Tag: 1753282062-698120
X-HE-Meta: U2FsdGVkX19s4h6vvtc5U27SJCLngIANcdGrwabjphWBmmtW3ZykMvPzBLFpGW9VaFzg8JINzsOxXF8YPm4vyV0E8stO9z28vFUieuhBTV+uxHUn0gXURuStVV0LL6hMxUIHXX4rb3XayTV/+qGUQJvvhGrWBStWO6MrnBvP32pNIHremEj+vC7/G6i2mdvteIoFM8UclBo8kIlrbGq2OD0azdyzef3mSjj4/N9S+jw7dtoRsdd+kS9v0RBSfFreWNlbIQGo9QAAS239IddKfS8OHewLdSXUagzBFud4MiMSZ+P1hh1bZE0sHv4ApmtmwvvW4CE5YnLRzma0nhNsxzX8XkWAnp8JC80ICL7wbHhnh3ovyOfpzOBeZvfjm7YYXseOnCzAFKFrw7a1BaFrtb9vbOtUpyqCCfHBbku6KFq0Ub7F5Mx58ql1XREtqHUAxUXWpFkjkwLBi++84tjOygWLw0EdK2N2lqCpR7egy77OPGZKUhqt9+szCOSmOOoFAtX3cHJT6nBSCUTnHEtbiJcC4pF16kRZFTJkug1z84R+upY1UFZBSB1bt/UyqrpbYOkQGMYPe07dbSjRuKdnpVxqekT7/zwRHHmP36PWVf6jLNIDLXUg3TXlxfvBqpExWsga9Uz39rKUADiARf9fgSRJohunfNae1oXo5btVf++XRZnppO8gojMR/jBoUJGbHi2F3KwqB61/x0jTKVTfXjJYgaZnUvsQWXxdbForXYi/wUfIC0xpFhIhOQWw1uEft+c+fuIHtMezlZ88gIa9XZ6MAP7sXPtBCyjuHwj1wN/6uFOBN+Sr8HwEXWftOJrB8Zs+jqRlTL0SuFbf3xlmX0mvuSHwaxtQCqrt2Fu4NkIpT2TZz9WohT5Vg4592NxQPK1Uhj343GnVtNUbMB61DVykEltbGTsHbUSZ9s6//xjuWm9pR9Yl7idNyCf2kco227gQScWnc5BYilYsE4y
 HxxS8wxX
 OgvJSGY6MWKZsXEKPRprM9blf+8IZRBHTwKsIcRdwZFyrfBEd1dgstClyfVWiAlHH4pvKwwjyWMzIKIa7GZfeJCciHzb5yACZu1q+cNP02w9jGLsp9q0kCHFh7JbuPQoyvZ6/QhojcuNBZjOsOkGn6o4j9zAA0Rr19EfYy5uSMQ1mcdgsBCTPqr1uM1s+qrLa7FDM
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
index 7a4ca18ca6e2..a79d806f2c8e 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -136,6 +136,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
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
2.50.0.727.gbf7dc18ff4-goog


