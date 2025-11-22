Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC282CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F08E6B0024; Sat, 22 Nov 2025 17:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2156B0026; Sat, 22 Nov 2025 17:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169B66B0027; Sat, 22 Nov 2025 17:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 011216B0024
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:23:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A102C13B7F1
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:23:59 +0000 (UTC)
X-FDA: 84139671798.07.BCBFDBD
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DD4FC0002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:23:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jpEonCe2;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MMVLPogxr4xn7qzv+KlhBxAlOABfTn1sftdMF1VGngg=;
	b=vC8nFX9hy2+I/A8yo34c5USUzGRceA9jIxcSgkGsLJB1U010VVL7QLTe0wyTy/kN6R88IG
	N3nLpp7EeBPtFxucYi1ximxzZwrPpMNZOUVY7ZDYe6DADChAHiJgFB4qJwGhnXWrl+9Ymb
	9w0a39mrn8FXYhSeDLHXhuq9944EdiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jpEonCe2;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850238; a=rsa-sha256;
	cv=none;
	b=Cr1DBcHyCRUD8uAsL4T5d2dA3/d5fYe+jTzjwnoD9BheBxjtjd+G3CKQxwHZuL8QCrb8B8
	j2wH1VcB53R8s4/JMKS7SlhO8Pr0GHz/UVO/uKgK7MXNzdQ8KqMMMXJGevVlLS/GMkuXOq
	oYu3ogJIz0bRIofLuaoa8hQ47EK/lOU=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-787e84ceaf7so32791967b3.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850237; x=1764455037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MMVLPogxr4xn7qzv+KlhBxAlOABfTn1sftdMF1VGngg=;
        b=jpEonCe2LpEnmLXkdzlCNCRszdH7/yApOOiik/7QclLKH00BDanOs+zX0aSPgem7DF
         vGTRnfr9YZ1aA5NxuBZEpJNHbKx7RmMKDGQqZIidAjg5Z1Kzhfz4kry/0gNodAjPT++G
         JrLjUrSDwLHuerWHL/MC3Knb4UztCNDjgx3NBMRErHPoSgDZ/tjBTiaftYMpQ7yBdQfa
         vhBssl+8qvMrjzfr6s+k5BPuDGaCq6tBCDU/sWvgZhiOHvsXCklLxEOu62FgHRXUPD/G
         H9avHcsFwSdMYRCHxF7VkAm/8z5czwEZN4o2PlI+VznSAc8gLM9li9rSj1Ph5grweOUk
         3OrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850237; x=1764455037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMVLPogxr4xn7qzv+KlhBxAlOABfTn1sftdMF1VGngg=;
        b=KtYj+Hv+RyjPcFUZsM1v7PfMwf9BvZE3bm3alI8Zry0stRs/K9mE3+YcWiBoIDRqq6
         t0As19kdcUYa6nQy/IdNz14e/mwFSNwasOj5stGDaPN9uovcy2U/mv7IIIGQonc5u8Pk
         yD61KWVJQ3sI+m2XtUu0J1g1CAkfn9Ly1GIYd+dd+XB8zNtTVDydIDJcn41nZa06SZ28
         j/m4nO5D342oiGXBtglAy4HxmB8/380FLmc5UzP5OY5fWpoVPjQZxVRDGUkffxb1WPCw
         Bs/5DwZk9Eh0JuWh9ip4RormUkfR6rNRGwVuTHbsLqdID55bodKZuxzD3luPlN1R6bNs
         AwmA==
X-Forwarded-Encrypted: i=1; AJvYcCU9cB/H+6HHfuE8cfzmRfLGsZEU3CB1GnoXp3VK3HYIRwVz2+HfW0Bq/4P9gNxq/emG0dTaTYmZPA==@kvack.org
X-Gm-Message-State: AOJu0Yw4bkqMkukvTtXy7lbIZr73LLUU60vdDdmNAZA17bOvLJPtY9D9
	784p2S6jwnutJSlQaraTZcQExyCuC+foGff+N+0ek2zxETMvcqTGBjRbvJwOK6oR77g=
X-Gm-Gg: ASbGncvpPYP6H7inucWy8i1rV0Cn8f9/BBbRh0wFFN0oCMKfMRGHlZ2gW3oTIzfSjYu
	njhqf1lEFkKX4tJUSTMfvkYmbjG+QqbfFph9YMG+BwNcUCeDUvIHmROJN4+AKah1WITebjUScbc
	aNtxFra2ZbGI2+L3fm6/j8023MkTo8oIhgUD5Ji6LDpsCagPHch/AkA8w8p+OfEK3Aaep7HJRTK
	FpKLk0W0XQmFqF/uENKrrNZNVMHXko4AI4SwZ9jaCyXlNw948HWAGmJKn4aheIilIQ8QUp65kLO
	TKwO81SG9a6YIFOkc/2HLMgJQv+FZpshGD7MN5Eb/WtVjdsQCcFOO8DGi9fX67q8Gz+7ided+Cm
	r7xRh2SLdTHePEf/WmTpxcz74hYNohOXJGsEXnUaitooDOkklIG9WKK2TQBvN6iyFfPyc+ds8RQ
	gYF0PGQqYzXWiaEMFSDF9Jkoeop1/7Y/WfLQ0ajKM1qOIz3J5FK3IbPaMOboTQOHqql5Ve3L+pH
	Sj+fdU=
X-Google-Smtp-Source: AGHT+IGXeP0hGbAFwfk3jugXNxMQcj4PmGg4Arhaop1PdEogmVGxKFjSmLggGBZBxrIKW7TxTkSmcQ==
X-Received: by 2002:a05:690c:e3cf:b0:78a:8516:e863 with SMTP id 00721157ae682-78a8b472025mr63326207b3.16.1763850236895;
        Sat, 22 Nov 2025 14:23:56 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:23:56 -0800 (PST)
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
Subject: [PATCH v7 00/22] Live Update Orchestrator
Date: Sat, 22 Nov 2025 17:23:27 -0500
Message-ID: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DD4FC0002
X-Stat-Signature: hctnqo49d8oxcekm7gtpswifotuxmtmz
X-Rspam-User: 
X-HE-Tag: 1763850237-239312
X-HE-Meta: U2FsdGVkX1+2gopCFPNRBGk21/tGCtMG7oqRXempDyqExloVDTwI7hoeHMmr1nAp3O8XoGtWAr85ItLvNRX8Wi6YuoJkqzEWS/KMgE93VNoCJHMVJXi/Xpu3ZFJjC1+D+4y177aMa6walGcEyKWI0sYm0tip8GvMkROL4JC9QyN2jkg0Ps08TMT5ZZbykTggFRevviPqboQln3hVbi5Bp6n+XVz5A2TZvF4dvtDphz32Ka6RxezMhvSYIZ2iij5hmwoX8G1FCjNP3nU19vgWQD40eMpcVXWf+oACXK8j4CtCcJIFLpYhyoIAg5OmEX1VRh3gvX2qi+EUn7tKo2uWaXEDjbqNbkdHyqZtLuEhw0i7ZmZ06A8yLAnNUpgdjdYkZf+zvVogj6S/t2f04m7+GvnJZK4JhUhgb1/I3hn5pubON+B4AfvZNr4Ezqtbs1BEqTKFyvIXY2pJnd4UtaxCVbBztHg+FM6KKVEViqTO7eIACVz09j/AnfqZuYGYrQeG5CIe0MW+jBOLuXU1UDX0gnVAMPcaMQzLQ7fF2OHD/1p9oV6t0GBETxwFGj9oIVFaZMG/ZG96B650O5mw42iCBL536ZSVvD8uB9Cn8fG8BL50rBdrGobMoIqtjyH+z8tcPdHSnUReUWnayPLfOpBQlOs0rm6mNtBjNsQEENv1yHDmZuJGnyXHVZc8NUkAPrbYgczNFsJpX9zzxds5Utssx0pyJrQP4hIeTvi0Y3Vr7mHYwe+YyrcgqWlTjdREn5VHNJ5fWtn5r5aVQub0P0agr/xJVJ9RSL45sVv+HPGkbW47QeJIllQPYxybp09pGzTsVZHNZMgzWIfiy2lzeEqWsMpw1rUWQh6aQmVYiI7tjOHUuGYMQwpmbPyKKal+ejY9/mwgCtlH56KK5gtJnBpAgrS/UdJBMMP7Y83y2XlnwkoElO4ORDH5rWl3nAVdjvSMSI3CYZK6bhdcUgGrxX5
 iYsFMClM
 PY7PAwEDeWQyMLMzzUWrTp454ovvh7y+sbRMtRuaH34xT/ABikmL7joqvWbpQ79zKNgWiqX22QIoA70bgTzrcEtcaj349nTPkYF1PHhPW/H6Pu0TbTHkbJAB3C1ihuLk61rEuFz1gMm90ZLKgaHLYLAyVoNq0/PNhGMr2AYcPG/GuaEB3p4mBHj1GmFH3FlAMQq/qzUsxN7msXRg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the Live Update Orchestrator, a kernel subsystem
designed to facilitate live kernel updates using a kexec-based reboot.
This capability is critical for cloud environments, allowing hypervisors
to be updated with minimal downtime for running virtual machines. LUO
achieves this by preserving the state of selected resources, such as
memory, devices and their dependencies, across the kernel transition.

As a key feature, this series includes support for preserving memfd file
descriptors, which allows critical in-memory data, such as guest RAM or
any other large memory region, to be maintained in RAM across the kexec
reboot.

The other series that use LUO, are VFIO [1], IOMMU [2], and PCI [3]
preservations.

Github repo of this series [4].

The core of LUO is a framework for managing the lifecycle of preserved
resources through a userspace-driven interface. Key features include:

- Session Management
  Userspace agent (i.e. luod [5]) creates named sessions, each
  represented by a file descriptor (via centralized agent that controls
  /dev/liveupdate). The lifecycle of all preserved resources within a
  session is tied to this FD, ensuring automatic kernel cleanup if the
  controlling userspace agent crashes or exits unexpectedly.

- File Preservation
  A handler-based framework allows specific file types (demonstrated
  here with memfd) to be preserved. Handlers manage the serialization,
  restoration, and lifecycle of their specific file types.

- File-Lifecycle-Bound State
  A new mechanism for managing shared global state whose lifecycle is
  tied to the preservation of one or more files. This is crucial for
  subsystems like IOMMU or HugeTLB, where multiple file descriptors may
  depend on a single, shared underlying resource that must be preserved
  only once.

- KHO Integration
  LUO drives the Kexec Handover framework programmatically to pass its
  serialized metadata to the next kernel. The LUO state is finalized and
  added to the kexec image just before the reboot is triggered. In the
  future this step will also be removed once stateless KHO is
  merged [6].

- Userspace Interface
  Control is provided via ioctl commands on /dev/liveupdate for creating
  and retrieving sessions, as well as on session file descriptors for
  managing individual files.

- Testing
  The series includes a set of selftests, including userspace API
  validation, kexec-based lifecycle tests for various session and file
  scenarios, and a new in-kernel test module to validate the FLB logic.

Changelog since v6 [7]
- Collected Reviewed-by tags from Mike Rapoport,
  Pratyush Yadav, and Zhu Yanjun. Addressed all outstanding comments.
- Moved ABI headers from include/linux/liveupdate/abi/ to
  include/linux/kho/abi/ to align with other future users of KHO and KHO
  itself.
- Separated internal APIs to allow kernel subsystems to preserve file
  objects programmatically.
- Introduced struct luo_file_set to manage groups of preserved files,
  decoupling this logic from the luo_session structure. This simplifies
  internal management and serialization.
- Implemented luo_session_quiesce() and luo_session_resume() mechanisms.
  These ensure that file handlers and FLBs can be safely unregistered
  (liveupdate_unregister_file_handler, liveupdate_unregister_flb) by
  preventing new operations while unregistration is in progress.
- Added a comprehensive test orchestration framework. This includes a
  custom init process (init.c) and scripts (luo_test.sh, run.sh) to
  automate kexec testing within QEMU environments across x86_64 and
  arm64.
 
[1] https://lore.kernel.org/all/20251018000713.677779-1-vipinsh@google.com/
[2] https://lore.kernel.org/linux-iommu/20250928190624.3735830-1-skhawaja@google.com
[3] https://lore.kernel.org/linux-pci/20250916-luo-pci-v2-0-c494053c3c08@kernel.org
[4] https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v7
[5] https://tinyurl.com/luoddesign
[6] https://lore.kernel.org/all/20251020100306.2709352-1-jasonmiu@google.com
[7] https://lore.kernel.org/all/20251115233409.768044-1-pasha.tatashin@soleen.com

Pasha Tatashin (16):
  liveupdate: luo_core: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  kexec: call liveupdate_reboot() before kexec
  liveupdate: luo_session: add sessions support
  liveupdate: luo_core: add user interface
  liveupdate: luo_file: implement file systems callbacks
  liveupdate: luo_session: Add ioctls for file preservation
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry
  selftests/liveupdate: Add userspace API selftests
  selftests/liveupdate: Add kexec-based selftest for
  selftests/liveupdate: Add kexec test for multiple and empty sessions
  selftests/liveupdate: add test infrastructure and scripts
  liveupdate: luo_file: Add internal APIs for file preservation
  liveupdate: luo_flb: Introduce File-Lifecycle-Bound global state
  tests/liveupdate: Add in-kernel liveupdate test

Pratyush Yadav (6):
  mm: shmem: use SHMEM_F_* flags instead of VM_* flags
  mm: shmem: allow freezing inode mapping
  mm: shmem: export some functions to internal.h
  liveupdate: luo_file: add private argument to store runtime state
  mm: memfd_luo: allow preserving memfd
  docs: add documentation for memfd preservation via LUO

 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/liveupdate.rst         |  71 ++
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/memfd_preservation.rst       |  23 +
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  20 +
 MAINTAINERS                                   |  16 +
 include/linux/kho/abi/luo.h                   | 243 +++++
 include/linux/kho/abi/memfd.h                 |  77 ++
 include/linux/liveupdate.h                    | 311 ++++++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 216 ++++
 kernel/kexec_core.c                           |   5 +
 kernel/liveupdate/Kconfig                     |  27 +
 kernel/liveupdate/Makefile                    |   8 +
 kernel/liveupdate/luo_core.c                  | 454 ++++++++
 kernel/liveupdate/luo_file.c                  | 987 ++++++++++++++++++
 kernel/liveupdate/luo_flb.c                   | 701 +++++++++++++
 kernel/liveupdate/luo_internal.h              | 141 +++
 kernel/liveupdate/luo_session.c               | 645 ++++++++++++
 lib/Kconfig.debug                             |  23 +
 lib/tests/Makefile                            |   1 +
 lib/tests/liveupdate.c                        | 160 +++
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memfd_luo.c                                | 517 +++++++++
 mm/shmem.c                                    |  57 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   9 +
 tools/testing/selftests/liveupdate/Makefile   |  34 +
 tools/testing/selftests/liveupdate/config     |  11 +
 .../testing/selftests/liveupdate/do_kexec.sh  |  16 +
 tools/testing/selftests/liveupdate/init.c     | 174 +++
 .../testing/selftests/liveupdate/liveupdate.c | 348 ++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  89 ++
 .../selftests/liveupdate/luo_multi_session.c  | 162 +++
 .../testing/selftests/liveupdate/luo_test.sh  | 296 ++++++
 .../selftests/liveupdate/luo_test_utils.c     | 266 +++++
 .../selftests/liveupdate/luo_test_utils.h     |  44 +
 tools/testing/selftests/liveupdate/run.sh     |  68 ++
 41 files changed, 6235 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/kho/abi/luo.h
 create mode 100644 include/linux/kho/abi/memfd.h
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_file.c
 create mode 100644 kernel/liveupdate/luo_flb.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_session.c
 create mode 100644 lib/tests/liveupdate.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c
 create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h
 create mode 100755 tools/testing/selftests/liveupdate/run.sh


base-commit: 2cb7e27ffe3e3e1d8a837026462ebca22cba3b4f
-- 
2.52.0.rc2.455.g230fcf2819-goog


