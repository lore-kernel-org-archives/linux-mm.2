Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC81CCD1AB
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B338E0006; Sun, 19 Oct 2025 02:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBFB8E0002; Sun, 19 Oct 2025 02:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA808E0006; Sun, 19 Oct 2025 02:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC648E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:16:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97D4647F53
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:51 +0000 (UTC)
X-FDA: 84013855422.28.59DE2B6
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id C3FFB180005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MBdId/UL";
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZRMP2OfxaTGj9Ba3u31wGuIf4ugyC10QC83Sd0wi7Ek=;
	b=H2poXLYbBmwHErXudHFECnAvYJapHTEk/AXGuDC9rD5sh/JhkND8dD9bn09J7FVJ87jbF4
	GV67FYooFR8NBmVt3a2wWJasUU0f5wg3Xw9J+KYGSGkL9MbhNIYDopdMu77C++cH9bUZii
	yQ6ZBPiYXkMowNjUCM/zb27Of6M+Zq8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MBdId/UL";
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854609; a=rsa-sha256;
	cv=none;
	b=P2/nIGxdrP8nmrltGEP/5AT/Cw9aScLKH1S/Tq6YlsSbUXwfS5fhawJk+MjKGQ6bL9Xxia
	fQ/Bbfe9y7kgXiTZGz5S/103tDiBTgCUx0dRSDMZ/DjEaQNR3Fk4smmgpnZ2to6fNAmC4y
	vOC6Feq7uj0OL579Yt23kEvHcfiziM4=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7811fa91774so2881956b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854608; x=1761459408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRMP2OfxaTGj9Ba3u31wGuIf4ugyC10QC83Sd0wi7Ek=;
        b=MBdId/ULOXIotsB2LBzqrFE2L2M8xarngSbilQDwKSVG1VfeZdllm6lPt/4PZ5XDX9
         YdTtj7Chei7UUJz8Mk/B5tg6Z2m+Qg7W1zo4LNcRB1N5QiiABSwC9nfgPdqZq2J4Zqq2
         aFudGKqq3bxWj+moyc2Kt1ZPkI4b0el6Lb1rEJ5CmBUVnRwBA0ddZfHI7MEF3mU9J+JC
         ryMDoHmV2MDOKzRnoPKTpRqMcTbvey9ccnTyIbNrgSnPyf8w9Y1zxdWM7O3QeXQI2J6L
         I4unE2M+tbkWVlHHXJMEjbpCDY+yJNVZVjlgnQYPdDK9CW/8sq3k+X6oYTqLaPN/ZMMq
         X1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854608; x=1761459408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRMP2OfxaTGj9Ba3u31wGuIf4ugyC10QC83Sd0wi7Ek=;
        b=MCxCNUPlnPNw+cANYy19bQ3u1oZSoycUeN2y8/0zPIuytJEPvRFBffKYXwf42P6E15
         jfIrit/6pkQKL9Xg9D4xoUS40j1c4E5G8B3/lysu16ozm1VLV8zC2eoOD7ArCQWFpY+7
         nQ3KqWijJl/cqEFohRD19eOsU3SjnWgkNB5zXOL/p1+RJnVe49PbEk/M3UZ9rYVi2G5M
         PvacuR1dx1bbWXQFjU7dWcXupI1hxep/PvWlVgWHvaIyl0HKmA1CWpjdoO2RiHUC7PIK
         UUmiHC1jvNYIJ5XHWcFbv6LmyGtIAA4BvrWwhV05E38Ys8pkfw/uPJ3LWn1YegvZBYWk
         8wmg==
X-Forwarded-Encrypted: i=1; AJvYcCWAS3GD6ZbESp1cQVlYkYY6/FtIsGHzz1HZ+zs1OunHzUem+Wf2RWp88h00xr8Z9rPAWyu1pp8+rg==@kvack.org
X-Gm-Message-State: AOJu0Yw7QXPKoY8HRTBMyLJL1Z4qH1Zgdup0OWSqHBEUYIxKR+iduHeo
	FlulbU8Qq/9vZ9ljairZJ7jSAsbFyYq15UieBn/veAg2AcR4QMyZhfbo
X-Gm-Gg: ASbGncsdtCmKOVz5xsizvYUDDnXOhhDI4cTlB0iDectAnR5ulPVqkgq3eYjIOFX44i3
	aKSvn15/ldLRN7T1Vo+vs8XNjLXEDqbxlVXcrogUt7kkiCXnbDNTBb9t32zM0IWWj3tyhfDFJGI
	fhYsAmxMPpgRp98VkIjTCwVfldnEpTgwYEZ1THztP6UZZLmyygrVh1jYd1gDmRf39973poMV9Y8
	lLSi8E1YYp9cXaNnOAb7SkQ3yMTJVHgAvv+CQ2TRwYRZoaPAazEfspjM3dJbZaFMpoTj+fzLMXE
	OvLMy/80ypWfqfFFqKHqwZf2oHMHaupm7h81OwRhJt0kGAtEv/Hsu2leTZtIlsZxCCWLh48DD18
	+Xwk9cKVo3mWAvKYk+z7w8hFJ0dMCz2/NU7eK6ngls/5bgvcO8d+1BEYaxWHfPVhKH4IC6Nw5f3
	dlsbwk
X-Google-Smtp-Source: AGHT+IGp4+Ph5e3LiXV7d0GmlI+i90WYkt6QaEte4wvTDN2FV/GISN5U6pAGNJ2hvtEGZmBPXg14lg==
X-Received: by 2002:a05:6a20:6a1e:b0:334:9b5d:3873 with SMTP id adf61e73a8af0-334a85d9eedmr11700112637.31.1760854608328;
        Sat, 18 Oct 2025 23:16:48 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:16:47 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 00/16] kernel: Introduce multikernel architecture support
Date: Sat, 18 Oct 2025 23:16:14 -0700
Message-Id: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3FFB180005
X-Stat-Signature: jxznt81k46y6jp3gi8ayoxot8z3exi5m
X-Rspam-User: 
X-HE-Tag: 1760854609-298015
X-HE-Meta: U2FsdGVkX18MipRIKO5oXwQZ43t4sNRvMKlqXuzaDkJ/9SOdLEeTp1HRtcrOWwauJmGxnBjNNWlCFHn66DK9vvBEK31NYXzuBUnjV6p3U9MpOC8yJwTb7iO122eXMXslJChnrssiCysyv1DV+fzH4o2iLowALr3/C3QiKL1tQlBCNQiX+ephPkx3iy4xGFtCtZ+1Jt49/HZrw9a5E9W9cS8/c8tUK+UK+NRZSmCk4Q1H15Yk7zZNYhrdyMf51sdMHFyRo8lgyRurdRANzp6eqimPBvocHeyGD6zv0z4BQIGDx2dsW9dpeZM2AZHVMUcrfY+OsrYg3D6KKS8MR3yVZOyDSUuGyOTRkeb/itXUaenhnC4UuCBRJMJRwDQy9x0JGrsBct9QvfiJZvoFYe3ge7hlRBFFYQ6OFFr0gp6RmxqB3ONcKIFSxUb3Iupghejf6CkXC5MV84U26U1x6/vrqjcHyPsHEnOlkRo3PsSo/Vqp/suM6WFZwKEgHxmLui9mlQ8F9rSwXqWYDmpqoprdwRcjMZkAfjB3DhKV99tnzbcBp1K/jXc0WYe10KZ6IbNVGaR1CeuQfb8MBvlZcjquW0zSW2vXHt/DzsGogfxWdbCYlEAhTcNYYYZBHxVtTQ6GRDMAfjS9pPi036je4VraPEnFuX+04vW7qn8EyV3bFu7I5vJwTnjhHvRpQYV75FQZROqh3aSp8Q00XQigC++vP1wR04Kz8me3RkCODtSTLFRYiHd5b4kRUbRtnATbSEKbd2u+sycbCJQJA47JQ60aTE/7xzjhg/+yHn5+B9kYevPiB5Z1/i9peCLb4kQuQQ6Mmm5Y/cDeUpBFKur9IVhx3wZ2f3Qbcv6FIJTXecoGtaUDximdnQ6Sy+3V+QDlfeQXin4kp9xcnHvs575MU63ecrXkXVoj/3SIKLLXhrWNhIjSxRoAD03K/NmgUrFlIAd8ysM4mvb2H1AIalJWWnQ
 K05yK1ph
 jCTHG/WduMsb2qI4+Ku0EkkdZjhUvLQWG5jksLJcgantPFTC4howfb5MFmqGeJa1cghSVPqT/jF+cUaTmmA1ZBT7G4YRR5Wo3Q9R2r22KfTCDo6bjMsuqeuoS+IM9ClmPiYhzK/sX6pWF74UmuY5Tvhzl+om+hBbmOj+yks6wWrBz/cwBEwWG5I+ImKhTgzZNS4/oMV/ma2U/k4fxKZ1ReKU/LGiZwaOM2YqGxaopA6QJhMmjqNWU4bpkQ/289tBYqTMhIBtcRGY+/o2F3eVyaKkq0DLcL9uZsHHPbWID0YP/rsEMJNCM5kyLShskcH/gjLjd1tb2U/MluIw5YFkqhnTzZcQEceCuULP6uRD2HOar6dA/PIARVK3gtVhMZlHPy1yxr/LVhW5kgK35S9cam6wFTKzHthZco/mcQUoZ7/K4YLhqJKqECR9JyjIgr398eQGcPn7dzPzGRHTtUDbcZ2bzg0jfxoUyA4XX3Ng1vyACuvt5guT6jsd9ETmrs7XkvHWF9LoRbqzTMh8Q6kWATI7h0JgcZqIGnmuZgt5URuLt76pj01KgOQchFoOpIyRHmtJF22IL3jdYz6gpbgd1ZTabgMAUxDjQ4KWp/p7SV/i2lf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces multikernel architecture support, enabling
multiple independent kernel instances to coexist and communicate on a
single physical machine. Each kernel instance can run on dedicated CPU
cores while sharing the underlying hardware resources.

The multikernel architecture provides several key benefits:
- Better resource utilization than traditional VM (KVM, Xen etc.)
- Better performance than containers without noisy neighbor issues
- Improved fault isolation between different kernels
- Potential zero-down kernel update with KHO (Kernel HandOver)

Architecture Overview:
The implementation leverages kexec infrastructure to load and manage
multiple kernel images, with each kernel instance assigned to specific
CPU cores. Inter-kernel communication is facilitated through a dedicated
IPI framework that allows kernels to coordinate and share information
when necessary.

Key Components:
1. Enhanced kexec subsystem with dynamic kimage tracking
2. Generic physical memory allocation for multikernel and kernel
   instances
3. Multikernel-specific kernfs for managing kernel instances
4. Device-tree based mechanism for static resource allocation
5. Device-tree overlay based mechanism for dynamic resource allation
6. KHO based mechanism for device-tree sharing between kernels
7. Generic IPI communication framework for inter-kernel messaging
8. Proc interface (/proc/kimage) for monitoring loaded kernel images

The implementation maintains full backward compatibility with existing
kexec functionality while adding the new multikernel capabilities.

For the complete roadmap, please see:
https://docs.google.com/document/d/1yneO6O6C_z0Lh3A2QyT8XsH7ZrQ7-naGQT-rpdjWa_g/

For the Proof-of-Concept demo (prior to device-tree), please see:
https://www.youtube.com/watch?v=bmC4JRTSDKE

For user-space components, especially device-tree specification, please check
kerf project: https://github.com/multikernel/kerf


IMPORTANT NOTES:

1) This is a Request for Comments (RFC) submission. While the core
   architecture is functional, there are numerous implementation details
   that need improvement. The primary goal is to gather feedback on the
   high-level design and overall approach rather than focus on specific
   coding details at this stage.

2) This patch series represents only the foundational framework for
   multikernel support. It establishes the basic infrastructure and
   communication mechanisms. We welcome the community to build upon
   this foundation and develop their own solutions based on this
   framework.

3) Testing has been limited to the author's development machine using
   hard-coded boot parameters and specific hardware configurations.
   Community testing across different hardware platforms, configurations,
   and use cases would be greatly appreciated to identify potential
   issues and improve robustness. Obviously, don't use this code beyond
   testing.

Signed-off-by: Cong Wang <cwang@multikernel.io>

Changes since RFC V1:
- Switched from kexec_load() to kexec_file_load()
- Introduced generic multikernel physical memory allocation and per-instance
  virtual memory allocation
- Introduced kernfs interface for managing kernel instances
- Introduced device-tree and KHO framework for resource management and
  sharing
- Introduced messaging over IPI framework, preparing for dynamic
  resource allocation and zero-downtime upgrade
- Grouped multikernel code in the kernel/multikernel/ directory
- Reorganized and rebased all the patches

---

Cong Wang (16):
  kexec: Introduce multikernel support via kexec
  x86: Introduce SMP INIT trampoline for multikernel CPU bootstrap
  multikernel: Introduce basic multikernel subsystem infrastructure
  x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
  x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
  multikernel: Introduce physical memory reservation and allocation
  kexec: Implement dynamic kimage tracking
  multikernel: Introduce device-tree based kernfs interface
  kexec: Integrate multikernel instance management with kexec subsystem
  Documentation: Add multikernel usage
  kexec: Add /proc/kimage interface for kimage tracking
  multikernel: Introduce per-instance memory allocation interface
  kernel: Introduce generic multikernel IPI communication framework
  multikernel: Add messaging layer for inter-kernel communication
  kexec: Integrate multikernel support with kexec_file_load()
  multikernel: Integrate Kexec HandOver framework for DTB preservation

 Documentation/multikernel/usage.rst | 215 ++++++++
 arch/powerpc/kexec/crash.c          |   8 +-
 arch/x86/include/asm/idtentry.h     |   3 +
 arch/x86/include/asm/irq_vectors.h  |   1 +
 arch/x86/include/asm/smp.h          |   7 +
 arch/x86/kernel/Makefile            |   1 +
 arch/x86/kernel/crash.c             |   4 +-
 arch/x86/kernel/head64.c            |   5 +
 arch/x86/kernel/idt.c               |   3 +
 arch/x86/kernel/kexec-bzimage64.c   |  16 +-
 arch/x86/kernel/setup.c             |  11 +-
 arch/x86/kernel/smp.c               |  17 +
 arch/x86/kernel/smpboot.c           | 159 ++++++
 arch/x86/kernel/trampoline_64_bsp.S | 288 +++++++++++
 arch/x86/kernel/vmlinux.lds.S       |   6 +
 drivers/of/kexec.c                  |  20 +-
 include/linux/kexec.h               |  30 +-
 include/linux/kexec_handover.h      |  40 ++
 include/linux/multikernel.h         | 659 ++++++++++++++++++++++++
 include/uapi/linux/kexec.h          |   5 +
 include/uapi/linux/reboot.h         |   2 +-
 kernel/Kconfig.kexec                |   2 +
 kernel/Makefile                     |   1 +
 kernel/kexec.c                      |  60 ++-
 kernel/kexec_core.c                 | 384 ++++++++++++++
 kernel/kexec_file.c                 | 158 +++++-
 kernel/kexec_handover.c             | 197 ++++++-
 kernel/multikernel/Kconfig          |  26 +
 kernel/multikernel/Makefile         |   9 +
 kernel/multikernel/core.c           | 532 +++++++++++++++++++
 kernel/multikernel/dts.c            | 466 +++++++++++++++++
 kernel/multikernel/internal.h       |   4 +
 kernel/multikernel/ipi.c            | 471 +++++++++++++++++
 kernel/multikernel/kernfs.c         | 772 ++++++++++++++++++++++++++++
 kernel/multikernel/kho.c            | 356 +++++++++++++
 kernel/multikernel/mem.c            | 376 ++++++++++++++
 kernel/multikernel/messaging.c      | 278 ++++++++++
 kernel/reboot.c                     |  10 +
 38 files changed, 5572 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/multikernel/usage.rst
 create mode 100644 arch/x86/kernel/trampoline_64_bsp.S
 create mode 100644 include/linux/multikernel.h
 create mode 100644 kernel/multikernel/Kconfig
 create mode 100644 kernel/multikernel/Makefile
 create mode 100644 kernel/multikernel/core.c
 create mode 100644 kernel/multikernel/dts.c
 create mode 100644 kernel/multikernel/internal.h
 create mode 100644 kernel/multikernel/ipi.c
 create mode 100644 kernel/multikernel/kernfs.c
 create mode 100644 kernel/multikernel/kho.c
 create mode 100644 kernel/multikernel/mem.c
 create mode 100644 kernel/multikernel/messaging.c

-- 
2.34.1


