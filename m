Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB2EDCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED2B8E00A0; Fri, 17 Oct 2025 16:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E358E0092; Fri, 17 Oct 2025 16:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FCF8E00A0; Fri, 17 Oct 2025 16:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98A488E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6180413A76B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:30 +0000 (UTC)
X-FDA: 84008706180.20.9BB033C
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 898FE1C0004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cvfogACY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Z6PyaAsKCMYmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Z6PyaAsKCMYmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732008; a=rsa-sha256;
	cv=none;
	b=TLUoEeMgLEFMm83PA9p62kIWASgC4txlPsV+dsd/9m+ug9v6FrCdlR7KNyHWRI4uIJxDqA
	xC36+9XBz4z2Tt7p3DAWll9YRPJusoqFnmwHVXQeNrATw+9eKlXD8iJRdUliAt8YPQsbHl
	kW8A3lEWQ7uIrFqook/rHmueN4OYcmo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cvfogACY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Z6PyaAsKCMYmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Z6PyaAsKCMYmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzgK6COwXxwuR6mHkO/eruasOK9Vha2WZDtBxyLasHc=;
	b=ZlHMhs+pqwJRL2bioefx5qwaZOzLO6L3rzlqlvP+qoyChYVtGF+FjoowH28Qq7e/DQuUmo
	jNWuAAn/aEz+8tRVcYmE7lvVEwa7YP5hiE+adGTlSLXiHHh2jhge1OTYcBW5pRAcN4F+Qo
	5jI7GFj+VRI0TatRRYmmqWAENnM5h4I=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630753cc38so3600568a12.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732007; x=1761336807; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YzgK6COwXxwuR6mHkO/eruasOK9Vha2WZDtBxyLasHc=;
        b=cvfogACY/e1qG/Iq3ZPT4Q4UDNx6Xt0L8GQzlEkrcpJ0mc+ccK+lRm7VVVRvU0TD7r
         li+O0d0nxkoyyTG7RubiXSTn4i4nZxLPE6Spw3lWfl+gsnzYebzagKhnLOPIyLcGxiL5
         W+jaaWmgme62rq1IreHoEul0sHu4ckebN9xNyIyyZh9x1nxWPLwj43JsUbOhEPPHAlEr
         rjfbUtW50gItn333LiEHXnP6X0MBxdDw3kIf9aBUEViyYm5xocvudQ5DrFB4lmmbyVO1
         lnJWQaXUUOie5RJmEel/Nh4XMmvg2277lPdkj23QlkThLIfqozu4vrmrv/ot2RVynmun
         LzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732007; x=1761336807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzgK6COwXxwuR6mHkO/eruasOK9Vha2WZDtBxyLasHc=;
        b=BrlcMcUdlYS9gn90t+THPI3bHcZ3pgaesik5fwiYWON38L4wRy3Gc8ZJkuZM3eYWZV
         8nfIE/N0xloW7IfP+NFynjs1geTIBYDionw1RoemtBHFbyXH129ftb06g3pBFyGvpd8A
         v+a34s49h42vrumr0xA0xiZdSDymt81tkw9Sbxk2IuEtiD7ZTdVTRgpcbAIOLe/3cB0s
         xYRqMyMUxToGuz0bPVVvJpdgcumm8CfAP3k1UbIMNjED6l+h1VpEM9ckzT81N1Cs7tUI
         0v0IHetHhX7EqCdX+dcHXxi2MoHCepJJRB+9Jj8naKgVPeyWPuw6LTGLI62FiC5fuowD
         0p+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV2ia2/qiZXzhWPdI1ub7pdS7dwXBBCbY4RSsuVDHi90VBw5Hvr6V2uNLrqRk4FUYV001VsI3AwMQ==@kvack.org
X-Gm-Message-State: AOJu0YxYPZsmOwavyJ8EUbwYFGpT4cN8I109KoEjkxtb9bFvk9BWzFxc
	3bvlr539lDXKRxTkYs4EOECZTIUJi1iEP8Y1fAnjFcK5TBH3+hpzkv1eOkqzgmFKaGxrf6kNJeL
	wc/Pn4rZ+sLdFoMASd3Jf59Dn2A==
X-Google-Smtp-Source: AGHT+IFNzBy4Dam1f3BpOkFlbzCEecrwBUddmzLCsmOoaaTEsa8+5gND5yEQLFxm84fuelz2mmjzrymU0o0/N3s+mA==
X-Received: from pjbsv12.prod.google.com ([2002:a17:90b:538c:b0:33b:9921:8e9a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:e291:b0:307:a015:37ef with SMTP id adf61e73a8af0-334a84da469mr6804101637.20.1760732007289;
 Fri, 17 Oct 2025 13:13:27 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:16 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <e51298f79233cc44a14ff2d3659b20cc3767e6bb.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 35/37] KVM: selftests: Add script to exercise private_mem_conversions_test
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 898FE1C0004
X-Stat-Signature: a6ax3z3iyhkngwqedm8rjtghgbkdhu9n
X-HE-Tag: 1760732008-671494
X-HE-Meta: U2FsdGVkX1/4H2TtfEVDcX/0rWuf5tAYLBz74ByRR2bhZrKrfgmJ5UVfGcEeuOdf0qtriPd9LbSfkwBmQI/soNhJfxZ7Ab0+uJ13ru77yGWXsHR5oLWkC5QDsUNbA496JxT/MJRc9haDUG4LYViYKg14XJDQ1ewPy2GS1Zye+w321T4WKKW0SvutQGhI94v8wN8ZpTP36grhuFi+NeRV+HDRMyb6JlUcLkowmJYUZmG4qiuFvbGz/Rw0aS9klQIlibEJBuiL1viWlLt/3vFzOjEsIQxdTg+N5gwMkUp+j7iWY7mZLe74gzD9d4rMs/tbWDbKNAAWq4Chb9DP8FNRxY2mVmWpB196oqae5yB535f3BTZjelFDzuQ7XH7OxjH+J2lUQSa8odWRb2vQ5wKxyHqvsRKhAqWS4khJdUrwKulrFgxz+TuNgZX87zKurDWEbL+UZBQI21kMjwqGBkiTZqu27gy6QEyOfAB5WG5Ofpg7vDSsFI9WAPndQHz6wig/ZOohtXwtloTmg7KzJCH1feV7htNRytGOyziaT1ghcKJay4vmZ+Pd6ZtMX969jRMeVumnfD9xHu9AR5YGYfsLfXluXIqvXaqNbJVLPPc3h4+2HoEzVTARCRe3Xsx4hLBh8cbBp7HZk/ozz0kkR+WBXbY/zZpY75G9uNnIfGlAk1sMNvWBN5FmhZ2o8r9ohtc0a2uPAIuy+Bffya/bWdOvi1sET8HYftO+bLInOhnd8jvXtEe44HFf6TYujxtnRnlpzwwz8kX2AxB2Nh9fqGlHz6Hg9c2d+zDIE/axnojePX32MKEPA+Q4bd6T/hVoR4b59IWj6y7p/JKgUrQOe22whJ7eh7EXSmBhF2cltaNXaAb5/DsOMukBXJVzGayitFqmYV8HBAnK3mBvSFOS+OCuG8LwyjlhwGVhEIi3Hhzc0kDxzJYc7/S4C1zrxQr1rrBEGS8jkbbB5x0nJakySvf
 j6HbRGA0
 eSVsRUzDtIu61KkVx0yMSI+Bl8a4sXgBimj8sej29t/PfwW/cHfY4YUDdsNDupHGjMdCcU1E4tUONqBndm4aaukfzUiAvx/rVi+VY+4kDwH/UgusRp/SseAvQWqfaA0fkUIpv3IJG/znTfPFOB7oHDg0KNAaKWAaZa3XDx8Y65JWmXSqjNC8UCs5rq+fG0Kboc6UI0ZyIbkQ4SjWw+dBSOrejKS5HBReYB0BR1/TVf2hVMix+OSarcQapKlxqxHR9gQ3c6e2YXos7Dp4+Typ+04oIB+dPodqBGgUUDZMDFlt+7v77VKJHIZ6umRGGDnmF5RHmItBjh2+PsO93gF6XLOTGiRPYdz0L4qv6soTj2jDJyvJc+dm7AniADXSzOsHFQMl3LXU3aXs+brjjB9Er4B6G1xdv6//nY7dpHHGZLC0cTuhDdGtUX4tz4T2obHj9IyfNdB/1SZcJItE5bTyr40eFMGoX7mEFWo0qVNhS03is3AwyZxI+8ZlK1Vrj7I68dHTGJeJkC2408SzpAKJQAnRTTp+dhXN7lQuaYR16I8ounEh3LO5maQwAlTdWo+pneNRt7enMkQBJUj5X9q+psSyPS80Z0T6jNFqBP3tDpOA6uPk2jeuuXCE3ZdnFNO9d0c6Gcge37WG8R8ERB9bTRhuYYhFBHhEJBrG1Dvkk9ZCTief5uSDAxKGIZ7o0llCwOGmW5/bFQCpaDPs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a wrapper script to simplify running the private_mem_conversions_test
with a variety of configurations. Manually invoking the test for all
supported memory backing source types is tedious.

The script automatically detects the availability of 2MB and 1GB hugepages
and builds a list of source types to test. It then iterates through the
list, running the test for each type with both a single memslot and
multiple memslots.

This makes it easier to get comprehensive test coverage across different
memory configurations.

Use python to be able to issue an ioctl to /dev/kvm.

Update .gitignore to allowlist python scripts.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 .../kvm/x86/private_mem_conversions_test.py   | 159 ++++++++++++++++++
 2 files changed, 160 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.py

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1d41a046a7bfd..d7e9c1d97e376 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 !*.c
 !*.h
 !*.S
+!*.py
 !*.sh
 !.gitignore
 !config
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py
new file mode 100755
index 0000000000000..32421ae824d64
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py
@@ -0,0 +1,159 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wrapper script which runs different test setups of
+# private_mem_conversions_test.
+#
+# Copyright (C) 2025, Google LLC.
+
+import os
+import fcntl
+import sys
+import subprocess
+
+
+NUM_VCPUS_TO_TEST = 4
+NUM_MEMSLOTS_TO_TEST = NUM_VCPUS_TO_TEST
+
+# Required pages are based on the test setup in the C code.
+# These static requirements are set to the maximum required for
+# NUM_VCPUS_TO_TEST, over all the hugetlb-related tests
+REQUIRED_NUM_2M_HUGEPAGES = 1024 * NUM_VCPUS_TO_TEST
+REQUIRED_NUM_1G_HUGEPAGES = 2 * NUM_VCPUS_TO_TEST
+
+
+def get_hugepage_count(page_size_kb: int) -> int:
+    """Reads the current number of hugepages available for a given size."""
+    try:
+        path = f"/sys/kernel/mm/hugepages/hugepages-{page_size_kb}kB/nr_hugepages"
+        with open(path, 'r') as f:
+            return int(f.read().strip())
+    except (FileNotFoundError, ValueError):
+        return 0
+
+
+def get_default_hugepage_size_in_kb():
+    """Reads the default hugepage size from /proc/meminfo."""
+    try:
+        with open("/proc/meminfo", 'r') as f:
+            for line in f:
+                if line.startswith("Hugepagesize:"):
+                    parts = line.split()
+                    if len(parts) >= 2 and parts[1].isdigit():
+                        return int(parts[1])
+    except FileNotFoundError:
+        return None
+
+
+def run_tests(executable_path: str, src_type: str, num_memslots: int, num_vcpus: int) -> None:
+    """Runs the test executable with different arguments."""
+    print(f"Running tests for backing source type: {src_type}")
+
+    command1 = [executable_path, "-s", src_type, "-m", str(num_memslots)]
+    print(" ".join(command1))
+    _ = subprocess.run(command1, check=True)
+
+    command2 = [executable_path, "-s", src_type, "-m", str(num_memslots), "-n", str(num_vcpus)]
+    print(" ".join(command2))
+    _ = subprocess.run(command2, check=True)
+
+
+def kvm_check_cap(capability: int) -> int:
+    KVM_CHECK_EXTENSION = 0xAE03
+    KVM_DEVICE = '/dev/kvm'
+
+    if not os.path.exists(KVM_DEVICE):
+        print(f"Error: KVM device not found at {KVM_DEVICE}. Is the 'kvm' module loaded?")
+        return -1
+
+    try:
+        fd = os.open(KVM_DEVICE, os.O_RDWR)
+
+        # Issue the ioctl: fcntl.ioctl(fd, request, arg)
+        # request is KVM_CHECK_EXTENSION (0xAE03)
+        # arg is the capability constant (e.g., KVM_CAP_COALESCED_MMIO)
+        result = fcntl.ioctl(fd, KVM_CHECK_EXTENSION, capability)
+
+        os.close(fd)
+        return result
+    except OSError as e:
+        print(f"Error issuing KVM ioctl on {KVM_DEVICE}: {e}", file=sys.stderr)
+        if fd > 0:
+            os.close(fd)
+        return -1
+
+
+def kvm_has_gmem_attributes() -> bool:
+    KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES = 245
+
+    return kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0
+
+
+def get_backing_source_types() -> list[str]:
+    hugepage_2mb_count = get_hugepage_count(2048)
+    hugepage_2mb_enabled = hugepage_2mb_count >= REQUIRED_NUM_2M_HUGEPAGES
+    hugepage_1gb_count = get_hugepage_count(1048576)
+    hugepage_1gb_enabled = hugepage_1gb_count >= REQUIRED_NUM_1G_HUGEPAGES
+
+    default_hugepage_size_kb = get_default_hugepage_size_in_kb()
+    hugepage_default_enabled = False
+    if default_hugepage_size_kb == 2048:
+        hugepage_default_enabled = hugepage_2mb_enabled
+    elif default_hugepage_size_kb == 1048576:
+        hugepage_default_enabled = hugepage_1gb_enabled
+
+    backing_src_types: list[str] = ["anonymous", "anonymous_thp"]
+
+    if hugepage_default_enabled:
+        backing_src_types.append("anonymous_hugetlb")
+    else:
+        print("skipping anonymous_hugetlb backing source type")
+
+    if hugepage_2mb_enabled:
+        backing_src_types.append("anonymous_hugetlb_2mb")
+    else:
+        print("skipping anonymous_hugetlb_2mb backing source type")
+
+    if hugepage_1gb_enabled:
+        backing_src_types.append("anonymous_hugetlb_1gb")
+    else:
+        print("skipping anonymous_hugetlb_1gb backing source type")
+
+    backing_src_types.append("shmem")
+
+    if hugepage_default_enabled:
+        backing_src_types.append("shared_hugetlb")
+    else:
+        print("skipping shared_hugetlb backing source type")
+
+    return backing_src_types
+
+
+def main():
+    script_dir = os.path.dirname(os.path.abspath(__file__))
+    test_executable = os.path.join(script_dir, "private_mem_conversions_test")
+
+    if not os.path.exists(test_executable):
+        print(f"Error: Test executable not found at '{test_executable}'", file=sys.stderr)
+        sys.exit(1)
+
+    return_code = 0
+
+    backing_src_types = ["shmem"] if kvm_has_gmem_attributes() else get_backing_source_types()
+    try:
+        for i, src_type in enumerate(backing_src_types):
+            if i > 0:
+                print()
+            run_tests(test_executable, src_type, NUM_MEMSLOTS_TO_TEST, NUM_VCPUS_TO_TEST)
+    except subprocess.CalledProcessError as e:
+        print(f"Test failed for source type '{src_type}'. Command: {' '.join(e.cmd)}", file=sys.stderr)
+        return_code = e.returncode
+    except Exception as e:
+        print(f"An unexpected error occurred: {e}", file=sys.stderr)
+        return_code = 1
+
+    sys.exit(return_code)
+
+
+if __name__ == "__main__":
+    main()
-- 
2.51.0.858.gf9c4a03a3a-goog


