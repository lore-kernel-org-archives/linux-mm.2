Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073AECEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478908E000A; Sat, 15 Nov 2025 18:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4290A8E0007; Sat, 15 Nov 2025 18:34:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318008E000A; Sat, 15 Nov 2025 18:34:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158988E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90AE0C0853
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:17 +0000 (UTC)
X-FDA: 84114447354.22.2AAC760
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE4472000C
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OecFU5dW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249655; a=rsa-sha256;
	cv=none;
	b=H/vAO6SekuHw9EQLAxu0pNV6vHHZlkcWXaSdV5LMkkKp/x0WGuMMomIOmBmIEZD+AlaAyx
	fRbL7nFWH03zm+Bbgckr/1EqEVnGhFJbc00ioR6ta7ZqgsTaEQTGu0q6IoUbITcRT7qW3v
	HEDp0mmUJFVPUf8W88SYN+0Pu8xZBAk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OecFU5dW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ee7lz4Om+GPES8DwWVPvUGgIK1alarn+M6wiUgt8ct8=;
	b=k389puPP9k8yiqyE6bIEivDMXuxHBbDXQUKzAyOuKgnjk6TzWSoy4dClt/UhLR541L3God
	0hHL8gVsbUVAddSqlQuBp/g0cyz1sM376/4nfUtKUiVHFwRulvrB/CJa3GqYOSCSQt0bAj
	BYu8Zmr9W1m0WBWA8ztxiUZcTBZzTEI=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787da30c53dso28687407b3.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249655; x=1763854455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ee7lz4Om+GPES8DwWVPvUGgIK1alarn+M6wiUgt8ct8=;
        b=OecFU5dW50rPMmjuuoGtWOjgkmSU0yKaPM/mAg41DicRd95mtXyqMZanAnVGtZzbO5
         bblTS9gZ2bTMMGm5s18IFEB+ykH+OvtooS79GiRDtzN8An4q9aMNE7IhyBXl8eKCrACz
         qOg89xH3TBfC5EM2H/sfrSq9KGK9ej842NMHOo4MzxyrHNC2e5TWfzNaNmTBzN9JxE+k
         hcBfPoxmn5ePCWizXhjEeUXgkp8keHi+yy2srSyP0kiwA9zeGT5w3To0JNLdQJeY1zxd
         +8J7qk/bgn6DL21dz9XHBn7y+T6tOjASG0Us298ijy0Wy9BecxeK/0zNiuOphV/8XaB7
         puHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249655; x=1763854455;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ee7lz4Om+GPES8DwWVPvUGgIK1alarn+M6wiUgt8ct8=;
        b=btzgCwqEshxWxr89xu4mTLVhgooGqhbxM8oDuRFq8z2Y/hHGCgrafm8FICLyzn/iHJ
         PhsIBk/2eBoPRsrNmt4zVdYJbrQy17wA4fsLBSaos6oDqMMmr1ZnUkN/llx24xOyI6hC
         bhGaxb8cDzj498jJr4y64fAvHoQjl3sr/dW5GzQohAx0FjeJvZFmHfRHFKDAmufYldZt
         EuhIpFM/4RhyjZdiQVgBAM4Ued3FXTtV4j0AnqUn696lUvdc3EZQDPohuBgqTjpby/Mc
         S6gZ5gk35SI1t1T/ZVLTWlGo88vWKH80VfUGfWIvym15m0+xFL5Mh27O5cRXHfZbOjsn
         hk8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwbITbkwENYq4SLkkjc0Rvu4+FSIVLrugCnqc+zIuf3puFMadrm0uKgpqRgQhzt1Oxxg4MwQi6sw==@kvack.org
X-Gm-Message-State: AOJu0YzGdWnUL1DiXlmlYwRV1lBNTO6a76GkEfJSH31yGk/cJJA1i3hZ
	gx109MNMeKIe8JjbTuBaN6xSBVdBOnUCOIckD5QsaquQ1AyscHc1u5IJyxA484qXN1Y=
X-Gm-Gg: ASbGncvyiDCm1BeuDFEh5pf0jTb1NtZauOCDFrfk6yeFJB8TMLv8Jar3kha/eyfx+x6
	3Iw5XMx0iycFunE/Pun+f/2PvNe/4G0gPrqlZ4Pq+W/W0lhFOkT6qzhsd4SFSElsLCO5+QUPoZA
	+a5tSnzhmAykmx6ao4sr8PLrpQtzacx0rgWK4hDxt6jzsse+trA8+O7LNgBrYhrU0GfJ26qKAiJ
	3/GkfIa9E+Dc+bXqIMs0ltjKcED1UYGe5R4j2QzJ3z1kUxPgLIRHjoxPHvie/EH6s4qF626VVpm
	oJnAbWTnrRp2qk1sEtXpusTkuU7jSm/ENJMgpksPX+HuquIQI6E/AUU7DFQkQWgx/HoHKZJ4RJH
	1lAU3n6jVCtmE00ZkFM/z+HcRp/NaRPSch+FqLeVPhVIdia0EaU247NB8Bvg0Yk0uObUHQFevqJ
	YuFpChLDuPcWq3rcuZPxgBTKRzqdRhxbrVsCOX1j27g19+hYnrIWuWbtmuCLkOhiOy4vCx8ryW7
	Kn0V9mubTcxr8N+Aw==
X-Google-Smtp-Source: AGHT+IHY/9H7Rzp2eriASzkL5MJ3Zatp1dgl1eRotDeTufMXyR7gZWjPaOKAzBcpPxEOBX631v43uw==
X-Received: by 2002:a05:690c:b98:b0:787:f72d:2a57 with SMTP id 00721157ae682-78929e23b6cmr69035687b3.15.1763249654638;
        Sat, 15 Nov 2025 15:34:14 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:14 -0800 (PST)
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
Subject: [PATCH v6 00/20] Live Update Orchestrator
Date: Sat, 15 Nov 2025 18:33:46 -0500
Message-ID: <20251115233409.768044-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE4472000C
X-Rspamd-Server: rspam07
X-Stat-Signature: o9jydo3n9pkcm5qjp8dkyqabauddm4ew
X-Rspam-User: 
X-HE-Tag: 1763249655-251194
X-HE-Meta: U2FsdGVkX1+XrWTR9081Aw6jTkfFb5gD1IxNSP21ESMMM188WCPlQv1s8otnoA5z6xAOVKnbCCUHx2PIL5tv0NodX9b0R6Eqy28XGoKjGSXy/i25hOIeKQz0/V8Riwfs073kq4QQcCqpoOPi0JIWtGgpc+nnc80VejQiRzg8oiDkfDMSBr3CAtes4q99yv73lRFbnLFxQpwdufK8Q1KxZNKEjLk4fOVt1uU61sXkzI6zfnvdnNGDI2SaEneCw+/svm2T+XuUqY8WJrn9h2ZBNAbNEUWcwva5G1BFtLTe5Gi1VCrtf4bJKpPT8jnuqmrSsftdAnSOrmk8G84kPcArszeX/mMpDbHCrX9WfmIuFqZrer97FY61wdtaztphOJgDcImqkB4R3x7K4o3E+L5mlQiN4TK1lKxmBa6wqbkBn+Bo7Z+MJ+B4aympwIc0bP3lCM7JKGm6hDS+CNPfzb/sBKd2yZuvW1nx2RdDheQi1t2PXsFnJIaftFeVRGs2M3759D07qCk3TEgsipwKyHaGM7qnbGafxCaXW82jCafvlHYqCyrYidU6ovaG8Qc3TihY7oQaTHlbwUIJCBv2DNWNwtGMS1Fslx8T20EZkyv5tmu/gds3bLx2BHR8DaVesldkOy6UxSGzNy1iVZvzy6Vl1ewU99olm6fZO1JzGwmeppH5W3t6riYld8opefb1aX2EL36owkVsm7RjLM9Wi/q73mIaWbH4Gc1UKUDV+Ok/h36JdZ74waIqa++qoQS+c2Q/bvyrPp1wmQy0ACptS6mRB0GPMOwMGrw6nsIpr7hIKXvMPUNHqk3vUJsYAVYumi1ytuxzmOBb9p2AxpLqdW6zIuszBwJxnSzT6vwcEnAkN/MLbi30Fv11KYPuH+/CDRPEhxhVso6E5okhH5eIPtvmGnMd23FjT4fEpNQR8VkuWmDqk0C11GRf9KyEuvRyKQb+bFWGS/Js8uwgTZNg2nn
 I1KKH+Z1
 ApVIOWLIYU01mrDF03tiS/atAmFGiKwkJ2fKQC9jSJOQs3lumONHzBASG89Y9VokUpqnsRAHa8yK37CHAnPdzNVtdMuVpzzdVM5p5btRFgBJ7Frbo3HlsOq0Uo2fig57dwLxINMT+yXT/sOycZss4jZUl5McZaAbB1jfBo52IwV6PtJzJ14qMSQ45X2KmxMMGRISStAzomAR8zhb/EnDodDsVEtTeITYAjzDUNPBXYGSYfuxYO1KLO1DD6alXmACAo5tmcgCRmozOFbIxK9gaUz3Bdr61v54KS8wu84vD9DdkFkR2TpQCkXkkSrQHwQD3uRd/DnUh4cM6XyCjEqpPnB/++1uO6xTF+Ot9TFVBv1Y37+tS6KRew86uh3A7hDRx4rFrgdvogRZlqXfRyQ9aujonSGS3v6doHIxNAWtN1yQIDkqg3Oh5+dz59RDWuy+/haN11CRdmlCU0fPqFcU4XWBbVM9tNqNSnQw29D4GHbZEpF2kiMyeKv06wHGpFZ3+nhgeb5QjUIB7lGy+QnxmS3X9LNgTtOInphLWyrH+5mpO6QsI+xiVsM2/6b1jYGOPLgX4DO5C/EYPqd2fvLput+8RkDQJfbAf1LjEVKQsDfM3AEfWfyACczGuw/igHGlOEbP3t+S9u3CuS8yepiKJySJcI6875YGyz+Pu9BBFAkrUoTEq922PH8oRvagma2LZCvTDiHx/eMNtHAWnZmhNFPNWbQ==
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

Changelog since v5 [7]

- Moved internal luo_alloc/free_* memory helpers to generic
  kho_alloc/free_* APIs, and submitted as a separate KHO series [8].

- Moved the liveupdate_reboot() invocation from kernel/reboot.c to
  kernel_kexec() in kernel/kexec_core.c.

- Moved generic KHO enabling patches (debugfs, kimage logic) out of this
  series and into the base KHO series.

- Feedback: Addressed review comments from Mike Rapoport and Pratyush
  Yadav.

[1] https://lore.kernel.org/all/20251018000713.677779-1-vipinsh@google.com/
[2] https://lore.kernel.org/linux-iommu/20250928190624.3735830-1-skhawaja@google.com
[3] https://lore.kernel.org/linux-pci/20250916-luo-pci-v2-0-c494053c3c08@kernel.org
[4] https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v6
[5] https://tinyurl.com/luoddesign
[6] https://lore.kernel.org/all/20251020100306.2709352-1-jasonmiu@google.com
[7] https://lore.kernel.org/all/20251107210526.257742-1-pasha.tatashin@soleen.com
[8] https://lore.kernel.org/all/20251114190002.3311679-1-pasha.tatashin@soleen.com

Pasha Tatashin (14):
  liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  kexec: call liveupdate_reboot() before kexec
  liveupdate: luo_session: add sessions support
  liveupdate: luo_ioctl: add user interface
  liveupdate: luo_file: implement file systems callbacks
  liveupdate: luo_session: Add ioctls for file preservation
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
 Documentation/mm/memfd_preservation.rst       |  23 +
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  20 +
 MAINTAINERS                                   |  15 +
 include/linux/liveupdate.h                    | 265 +++++
 include/linux/liveupdate/abi/luo.h            | 238 +++++
 include/linux/liveupdate/abi/memfd.h          |  88 ++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 216 +++++
 kernel/kexec_core.c                           |   5 +
 kernel/liveupdate/Kconfig                     |  27 +
 kernel/liveupdate/Makefile                    |   9 +
 kernel/liveupdate/luo_core.c                  | 252 +++++
 kernel/liveupdate/luo_file.c                  | 906 ++++++++++++++++++
 kernel/liveupdate/luo_flb.c                   | 658 +++++++++++++
 kernel/liveupdate/luo_internal.h              |  95 ++
 kernel/liveupdate/luo_ioctl.c                 | 223 +++++
 kernel/liveupdate/luo_session.c               | 600 ++++++++++++
 lib/Kconfig.debug                             |  23 +
 lib/tests/Makefile                            |   1 +
 lib/tests/liveupdate.c                        | 143 +++
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memfd_luo.c                                | 671 +++++++++++++
 mm/shmem.c                                    |  50 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   3 +
 tools/testing/selftests/liveupdate/Makefile   |  40 +
 tools/testing/selftests/liveupdate/config     |   5 +
 .../testing/selftests/liveupdate/do_kexec.sh  |  16 +
 .../testing/selftests/liveupdate/liveupdate.c | 348 +++++++
 .../selftests/liveupdate/luo_kexec_simple.c   | 114 +++
 .../selftests/liveupdate/luo_multi_session.c  | 190 ++++
 .../selftests/liveupdate/luo_test_utils.c     | 168 ++++
 .../selftests/liveupdate/luo_test_utils.h     |  39 +
 39 files changed, 5539 insertions(+), 19 deletions(-)
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

-- 
2.52.0.rc1.455.g30608eb744-goog


