Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9BCCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EAF8E0005; Fri,  7 Nov 2025 16:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D565A8E0002; Fri,  7 Nov 2025 16:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C453B8E0005; Fri,  7 Nov 2025 16:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADD1F8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EA2E1403DB
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:35 +0000 (UTC)
X-FDA: 84085042230.26.569767B
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6CEC82000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MuAjtdxJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549533; a=rsa-sha256;
	cv=none;
	b=E9h+0rDBqLgUbkZRpGxBiwclBvOcblM7hPqWgz3hNQqkDL/w16+sFP2yx4pR0zMIM7vA8R
	EkuVGIW8oTTEytMWvEPF/dMibyOX1Y/J6LPp6A1rcjd4MtUBRXk3B+rwjFb1To0gAII+LZ
	oqz979VkfeTSt13ZnbdwAnjPGVN0bQU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MuAjtdxJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j2X8vbQE5FBHQSyrNFjJFLZxDkCyXdmtNSWPzPf1VIY=;
	b=ZzZrODkxvea/eVSv4kQxqFSzJx9JncUk86Gq2xgaD9XtjvIBcjAB3PVqC0d3rRsyZ63IRA
	Ij5OH0M6I9Yp2GazHB4Kt816eJp+Vx30v3z5RV4YSbtQa+DVBxUowyIZ80Hmnr8cXxGGym
	LmiaFY1iKJNw3/kbkuwpM1cJN3Lh0hE=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787c9f90eccso11234337b3.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549532; x=1763154332; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=j2X8vbQE5FBHQSyrNFjJFLZxDkCyXdmtNSWPzPf1VIY=;
        b=MuAjtdxJ/5HGRZjjUhfG3xjKNXuAPGo7MxrIHK1VRYGmIlWT2dCVLO2hpRyvZrQEZh
         g+DpWZw+NqJxfyI8NIxT5yJpWzdd6u6aVR6pk013UnSTTGrSoFE+KlryWJjIFn2/EoR8
         1/nxHsPBfqzR1o3NKkGnwBqj+UJKjIHoJFQ3PnhxK/hYu50CnXvttNiMVReyu9XEaOnh
         KybFXEB/kaFFZfaGJ7/Dli7hSAUrG0eyY1AWQUTI8Op9K4svxXPcNA210XQP4BOaasTa
         2DkY0XbyRrajUkT+eSkVLKrFtzByi6i4PNYVcZc1HuNZ916pbhFijuR0nOypyECVrJ8w
         5CAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549532; x=1763154332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2X8vbQE5FBHQSyrNFjJFLZxDkCyXdmtNSWPzPf1VIY=;
        b=eSB41TNb27P3tBbZfv/GYvuXb3+lwT9N7nGkcJlk5VHDS/mYuVlcbvPYRC+DhCe6xn
         ceUB5PNTwc/jX8ce94Ger5Cv1GL4EXJzOQ2UkWy9JLYeifqXiMnPUP/6PipSt2HeMQ0F
         kTi1DtyHUzZzztfjbwcWNSe4v/E2BltYLOz+27PLhEr9kTla5uR24MWOm3vNXi5m8VLT
         D4g6bc4Y9GlkPmjNBOzduDp24cvJQDxrX7uvE5zzOlsu9yjrS1RfiTQdRLw7G8sJvzV4
         EQfLPwP0YTqNPLTPFghbsZp7TKj8BrO2gnpThponFg5deV3XJ1ptfhy91SexcEO/Xjnr
         cpTA==
X-Forwarded-Encrypted: i=1; AJvYcCXfcxARFxmXHf7hUja1W+OrttEwdKM/vDMUrH67g0U1s8c4rkiY8B4BOwhlM7Qe+fqDymkU5OYQ6w==@kvack.org
X-Gm-Message-State: AOJu0YzIlWE7IcHNMPQPabzHSc0XBwjp2edXzfs3GDuODlyIK0fcisKR
	riPpunTu2IRqbcJJbEJRY25EJnH3IBAoJl35mxPjnCiwkZbZ3KzdxZRIbJCa7vQbdqo=
X-Gm-Gg: ASbGncsx2bm/XGcDxvH0BLgam+hYWxjqJ22qUnjcHWoMuSVNJZIZKqWFI3iDVZWLpKg
	CGuY4qNahX/i3nlgm4nT41sNEFb6JSitV7Ej/xpqy4nICCKb1CgjSdzwANB+wClwjmp88fERUwZ
	Z43/cYZp/X2o1WbRud9seKAsPRkE+Dxksf2lNuFDUGXQL7+BaO4N559Q4eizB9ef9PiK60jOyRy
	Oy5S8d6ppRpfau/Dgjoc1W29SuzDEC7+wnuxzffYjlSgDaEMH3BbBIyhbhzVTnnyWy48G/dMtlw
	27NQ33rfpf1Uv+hfuVodZ1va/ce/72mnJyZEOuQzle7WhbDwWFfc9u+ZuJvia1iFiwTvjcvdYzk
	ltMIQ5dl4nvpHO9dCClEP23WNoIiTymY8ykIuuC6Ro+KHh3X26C3wZFGnqrvn8273EnxdLME5KG
	KSg6OFvQ0PdRtij29CpOPmGyp5+BklzYcyyrYHXWayUM19xOHJxOHo7SAylkujdkseX1f1VTiU9
	F+pF/aLpjU4
X-Google-Smtp-Source: AGHT+IHBoorb0zfo3zhMzO1yWrNtcnFyDIkGNuEmE/z/xxTd6FJYrUZbetqvBXhZSAgqADHjBrKu8A==
X-Received: by 2002:a05:690c:7603:b0:783:697a:5daa with SMTP id 00721157ae682-787d5399f2amr6178507b3.30.1762549532031;
        Fri, 07 Nov 2025 13:05:32 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:31 -0800 (PST)
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
Subject: [PATCH v5 00/22] Live Update Orchestrator
Date: Fri,  7 Nov 2025 16:02:58 -0500
Message-ID: <20251107210526.257742-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CEC82000B
X-Stat-Signature: eqzkgy7hc955ipiybtfeep8popubwo9r
X-HE-Tag: 1762549533-451695
X-HE-Meta: U2FsdGVkX1/x+LxMWwVnDSk6XTyJyDBiz8govD93Izb8VEr8K5K+nWVbOg4BP2lmVfcBb/M2x/EmAzi3AZlmBN6GvTPFVV2GMhSdTIchnZ8WGc2Z84IsqP2r3V87K5kIj0HufG/rSH/dafbnKdi85GLY9aky6Rj2YulcL8ube2kxofuSwvTncNWt9BZWp1KUhpserMwXKThWi6gcwE2RCY3xelZahSdKBQz3bXZg4/Ajd77+/1qB/Qw0i+3owi4FhM1SvoAM3YDCmsGpnOFB8TAEdD7S+7Xx3HMzY81hNr2tMGyg8mYlA4G6QuUPXucUue9J1pXzL9WscAcPhVpxSHo2k2qNUU3LQLyU0bn5oB209E+Nza2PX/+3e/nYRBzM4vmS2+G/TdCM+T3skr6En+SL+8CzePJpaB/5APx8qb0fPL2XsXvM/HxsUxYwIaZuLUm2o/qbEyhgnajQSHS1t5r/d06JK8bUBHgd5yTxtIgs9cTbOm33RHBoypEkQYQUXFgTwkZs6CG/yOUZE5uwbiCVqkDG6/N8Ad6/JR00THVAP8NecLrbGB7IYBXcv4tgBDWyssXKYmmZPwgIo5EDYIABFVN6g9C+thm/p+WnrP1B3cjdwwSVvppPcKhyh0IQNIlg+eSnN3Pm4qNl9HV+FHr+t5Zfv748XeYH1o04M4ZbQpPLnP084QCoaQ4lQpV4XkdHx6v4YmBRj0HJaRj7cn7lKvfV5mwWq/vGJsppV1APLlu+GOSo4+eMjGG56ymkC5cE8qBYoVze+yIrJ7hWYHbrVUgUtR+ATvDBuJJ4FQtbF3rk+Q3B9Dz4e4jEwnzxA5BMrFlRdglpXyV3RWD3+11e64QfLh+L2332s3RUVrlTSZ6qMRZ/CecjMJteBlsFymzdWyZvoOKcMG8W7FGgT9A2GRSEz4QMxNexR3VoARAJpQTKSWqbUmiDol5+y0R9AOdePo4bs2C5kmw5lc/
 F1AGoF/p
 I5gzK/vdtqQ1EcjjCrVB1fC9o91ixXtIVfsnhx4XjOp6pEYM8l34BKjWd43HKQlfUfYUCegZN3MU45ghapvzZmozOM1TRPVJQ/HNvVSPck4w9A1MpXwJ40NEo6D7uPDfNL0HYqHHoCH7CmaZtldzt7Nh23kS/h56vdqWXtbSIHHJxOM16/yGq+Q7q9cRy6taJ5WexaK0547/wq/vYT7U2apXcf68GTy0vqTGKwnkgRIwIMd7cD4K24VbW6/enDHTm1yyIwINLIq9ziSqCalpNc5HRxGgo7Ba+wd6p2d84yeTFuVcxpUyQRZjQb1cfRYBmkoCKTaxstqW0Ag3mAffl7hzKFHLQR+nMvP158d9WHd6ltZy9WjrjP+2JhF0iAitwXwQGtabbzsI/ljKKVFRTFqGFtIsqBvh/446s2wuUi78tIWTJF015C4YAzYqsFGyuuHlvmCSIfIiRhdmqdrxYEEm0SPGN+VhLutIWVADFvV/jC/DNZGKETqY4DssZFaD4FEwL7xQgLlMJ82rWb0jgghGqsc2MNCk9Nlm89URtkTD9duFgZd2+smk4OY103yZYl150CaTXkg4aA7wiVkmfDPExl28zQHSsP5Y45nHkI1lLUEVwPvEcTeNyPAsIxF/HGmGuDP3CL7f2bInXNy3m/40J3RhYKvhpEtXqMlHVJDkujhjm/ghQTWutyLtkLymAr/RyUTOGaHVZHcfDN6JEVhCwdA==
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

This series applies against linux-next tag: next-20251107, or use
github repo [4].

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
  future this step will also be removed once statelss KHO is merged [6].

- Userspace Interface
  Control is provided via ioctl commands on /dev/liveupdate for creating
  and retrieving sessions, as well as on session file descriptors for
  managing individual files.

- Testing
  The series includes a set of selftests, including userspace API
  validation, kexec-based lifecycle tests for various session and file
  scenarios, and a new in-kernel test module to validate the FLB logic.

Changelog since v4 [7]

The v5 series a significant refinement based on previous feedback
primarily form Jason Gunthorpe focusing on a more robust model for
managing shared dependencies and improving the overall structure.

- Rework KHO for LUO patches from the previous series, were separated
  out and are now linux-next to be merged in the next window [8]
- FLB Mechanism; The most significant change is the removal of the
  generic liveupdate_register_subsystem() API. It has been replaced by
  the File-Lifecycle-Bound mechanism. FLB provides a more robust,
  reference-counted model for managing global kernel state.
- Simplified Global State: The global LUO state machine has been removed
  in favor of a simpler, more robust model where state is managed on a
  per-session and per-file basis, driven directly by userspace actions
  and the final kexec call. This removes the PREPARE/FINISH/CANCEL
  global states.
- Formalized ABI: The ABI passed to the next kernel has been formalized
  with dedicated headers under include/linux/liveupdate/abi/, improving
  clarity, and maintainability.
- New can_finish() callback, that verifies whether all resources within
  a session can finish, or is there still work left to be done.
- memfd Preservation with vmalloc: The memfd handler now utilizes KHO's
  vmalloc preservation mechanism. This is a key improvement, removing
  the previous size limitation tied to contiguous page allocations and
  now allowing arbitrarily large memfd files to be preserved.

[1] https://lore.kernel.org/all/20251018000713.677779-1-vipinsh@google.com/
[2] https://lore.kernel.org/linux-iommu/20250928190624.3735830-1-skhawaja@google.com
[3] https://lore.kernel.org/linux-pci/20250916-luo-pci-v2-0-c494053c3c08@kernel.org
[4] https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v5
[5] https://tinyurl.com/luoddesign
[6] https://lore.kernel.org/all/20251020100306.2709352-1-jasonmiu@google.com
[7] https://lore.kernel.org/all/20250929010321.3462457-1-pasha.tatashin@soleen.com
[8] https://lore.kernel.org/all/20251101142325.1326536-1-pasha.tatashin@soleen.com

Pasha Tatashin (16):
  liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  reboot: call liveupdate_reboot() before kexec
  liveupdate: Kconfig: Make debugfs optional
  liveupdate: kho: when live update add KHO image during kexec load
  liveupdate: luo_session: add sessions support
  liveupdate: luo_ioctl: add user interface
  liveupdate: luo_file: implement file systems callbacks
  liveupdate: luo_session: Add ioctls for file preservation and state
    management
  liveupdate: luo_flb: Introduce File-Lifecycle-Bound global state
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry
  selftests/liveupdate: Add userspace API selftests
  selftests/liveupdate: Add kexec-based selftest for session lifecycle
  selftests/liveupdate: Add kexec test for multiple and empty sessions
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
 Documentation/mm/memfd_preservation.rst       | 138 +++
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  20 +
 MAINTAINERS                                   |  15 +
 include/linux/liveupdate.h                    | 273 ++++++
 include/linux/liveupdate/abi/luo.h            | 233 +++++
 include/linux/liveupdate/abi/memfd.h          |  88 ++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 217 +++++
 kernel/liveupdate/Kconfig                     |  28 +-
 kernel/liveupdate/Makefile                    |   9 +
 kernel/liveupdate/kexec_handover.c            |   3 +-
 kernel/liveupdate/luo_core.c                  | 341 +++++++
 kernel/liveupdate/luo_file.c                  | 901 ++++++++++++++++++
 kernel/liveupdate/luo_flb.c                   | 628 ++++++++++++
 kernel/liveupdate/luo_internal.h              | 101 ++
 kernel/liveupdate/luo_ioctl.c                 | 218 +++++
 kernel/liveupdate/luo_session.c               | 580 +++++++++++
 kernel/reboot.c                               |   4 +
 lib/Kconfig.debug                             |  23 +
 lib/tests/Makefile                            |   1 +
 lib/tests/liveupdate.c                        | 130 +++
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memfd_luo.c                                | 609 ++++++++++++
 mm/mm_init.c                                  |   4 +
 mm/shmem.c                                    |  51 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   3 +
 tools/testing/selftests/liveupdate/Makefile   |  40 +
 tools/testing/selftests/liveupdate/config     |   5 +
 .../testing/selftests/liveupdate/do_kexec.sh  |   6 +
 .../testing/selftests/liveupdate/liveupdate.c | 317 ++++++
 .../selftests/liveupdate/luo_kexec_simple.c   | 114 +++
 .../selftests/liveupdate/luo_multi_session.c  | 190 ++++
 .../selftests/liveupdate/luo_test_utils.c     | 168 ++++
 .../selftests/liveupdate/luo_test_utils.h     |  39 +
 41 files changed, 5583 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/linux/liveupdate/abi/luo.h
 create mode 100644 include/linux/liveupdate/abi/memfd.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_file.c
 create mode 100644 kernel/liveupdate/luo_flb.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_ioctl.c
 create mode 100644 kernel/liveupdate/luo_session.c
 create mode 100644 lib/tests/liveupdate.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h


base-commit: 9c0826a5d9aa4d52206dd89976858457a2a8a7ed
-- 
2.51.2.1041.gc1ab5b90ca-goog


