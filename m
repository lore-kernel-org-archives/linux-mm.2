Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E6CCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12A88E012D; Thu, 18 Sep 2025 18:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA8E8E0068; Thu, 18 Sep 2025 18:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27138E012D; Thu, 18 Sep 2025 18:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B26B88E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DCC38608F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:23 +0000 (UTC)
X-FDA: 83903805846.06.C3F8A43
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DB40C0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ipW/uqhC";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DbEPHi/FBJoBntQoKxRmObfSjuVxaXboS80M9e4IQLM=;
	b=ocyvs0cucnILH08BFbqsA2OJu/wf2y+mQM9ISOGQcNc1QPSWKi22WwM71NRX4C6hmp3x/F
	MomYIK1rdtY1P4PwLUVzUZXBOLoV2jekQ/pjMIX6aJ25f8fbwsC3bSx1CpleAmXIyWwID9
	6/vDMIYsqloeIibQNn5AFJqY0Yif054=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234381; a=rsa-sha256;
	cv=none;
	b=pCHIZdlw57+duTwn83/ZtdxqZjRyRvLSJTv7yI2K/dhj/fRJBB0aKq/AxvuQYbQcKqKxBS
	cUIbA8XH82DyGQt6TIAtmOjS2tSgyG1vfMw5OwqVBtOrC6vB5DNMDaZZg2/eHX4L/KTuSi
	YuAeFro2grbtX20u720GvVTohhIZrl4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ipW/uqhC";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so1528903b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234380; x=1758839180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DbEPHi/FBJoBntQoKxRmObfSjuVxaXboS80M9e4IQLM=;
        b=ipW/uqhCNaVPcUFO7owTVkNzHdxpsScfAm5CHW7noNDrxwp2+JCO4U3+5jYJm9B4A8
         Cj5826fzk8LkKI10QgVynuJj0P1Q31Sd2SwvDvI1jpRRGeTp5fuOTx7H2LyT1slYiDjE
         4ZGURHLGKSklTdLS49uc12dJjQAaS1PjEu8d8rY0YK2Y6yuI/jxlRCw5SP+wj7cU9HZZ
         PAceGMNi5WzyqTnhcD2EE6kacNcdyOQeBVlreXmcJ39ZOCbhM18kCBNx+XrWq6RExD4x
         3OoyW1krYk4SElEmbD5kLLtukFerdK+UPd4QVRU3L66xC5EWf74mtr0Q4aZjeSuIUVDL
         RqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234380; x=1758839180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DbEPHi/FBJoBntQoKxRmObfSjuVxaXboS80M9e4IQLM=;
        b=HXzhnbQVUsQXEKx6msUMSLs8JerOKi1nZi3X+0aO1t/zWw/EUefIU9UQ0ybPpUok9i
         r2O35huyHH6VyNpaqJNcOTWGoLaboQ7nszJvQAhMgS68fd9ySDxO0K9CS7a8hLP8+NN+
         rlhN21kWkQH9spJhrs3rnD2gCnOi8WcYYem6wcvQk0MBOP4UOmHh+WfhrUO1Wki2fU0v
         rSMgLmFY3MVMuGeJ9bgjXk8WtvOrWKKLd6wx0hPRd336DPGzrEjvgWgZ8rfM97EmcAu2
         z9qN1akbd6WcEgKxSp22rzWpue7AyvzUSIl9wkIuPVUaW62m/5R1WO8Cr2JNVxJ77BkN
         CbgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZmrlub4X8cJ4Bd8npQWqYxR5Nd4idxG9pUtyLIVg2ow3qXsdSPvyaPQ5vS53WGDflzAss38Q8ew==@kvack.org
X-Gm-Message-State: AOJu0Ywk4FCbD9Nktn8LL4Ll2S0PlSYtc+JGrG7j46lK7yfkID8ef4EB
	mrqJCr8bo31RM3fDNdxH+ZAARJSCadR7vZSwEdKI0lf4MePBbH7WXIcg
X-Gm-Gg: ASbGncuP+LjTLlZZcDfY1XLTJCbdayuK/FxA0Adyx6pJZFXlgvUx03r9cVMsfWU+lLN
	17x8UyA8n2mZeuK6JB8s8zsRl/eJQWmORW4msKLsNX6oeDpNqg/lkG4+s/njV8GvzlMsHBXXggP
	PslZX4joURlwOdD2VtGR3FxdHP5qc6zcGmejFlOxif3HqVunokCanXJTrHrGBrBy9x2yPxqg0qH
	arOCvZtLocS1NIxEgucXf8/JWZ8rf6hShUttQSyc6o7vJTlYHjHD1PSqFbphccBIRd1rAIs9ggS
	lV5hTEVip+uftR7iFRu9MmiaeUrRbzi7sqVMUtaTe7mThINWEz09lxDFzNzSrBXTbLtVesH2rii
	dvubhpzFnpWo/UUW1D2CLFT60ySro5fO/Nmgm+tRWWK/tKFw=
X-Google-Smtp-Source: AGHT+IG6nLv83h+1eeTVl7MZ7TPHJ+9naz9tMMEQEalz0Qo1qnLahXUNQcADDPcryvTTLERYOekvXA==
X-Received: by 2002:a05:6a00:190a:b0:76b:ec81:bcc9 with SMTP id d2e1a72fcca58-77e4eaad25amr1209704b3a.21.1758234379999;
        Thu, 18 Sep 2025 15:26:19 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:19 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
Date: Thu, 18 Sep 2025 15:25:59 -0700
Message-Id: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z5b1c4cy67grrqffruidgficcgnf74mn
X-Rspamd-Queue-Id: 4DB40C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758234381-146076
X-HE-Meta: U2FsdGVkX19yKEMsgEbZvuVUXp9OR9sXUfQZO0/0nRFTLU2w73PCZLqbw3LYmwV4pFWWbbe89Ep7T/AAKuxO0gW6DjUFgfkYem2CmUivGwEoxNGVNgAHRsEEDfGzFQsujtNdzrXeqeyJ6CTVQWon/yP5xAsUkUm85753lJM/sjCqIHJ3IT+uh9/MljJilaGzJSbY6AvfdCYTwrBle3fla95fQoPF6j2NNRkXls/RSedOeZS0WCOkfo7o4HvSfMAsGnNxioQnlm3owtGVUqsr4vbmSMlUTyMSb94snIIrcobAxwYap1Q3rJ1yeBLqWOf6dgVL86+v5wBvARPQ+r7PGaxEQPlCf4kkjqx5KSQ2mvQRJLfLauVjwmxvlnKuZUuLYfkCpzEuVmyB+Q2hFu1SJkrmP4qvsunN7Gsbh1zNvrORKnyjWLuybWUQMkeia0Fbs3JmFDgmihZEojP4/bChkk1/d3sM35xkZL6wCbfArBAOAXPnvB+9NrqflWmwilYuElkZPnQp3ics1tz73xY6pjKFWxXsjOSjci2/HGvzYzgwCMn88pD4uxrBgtLpgDSaYGj1j4e+XqTuU7O3jUurLcIn5+v+z0qSAd1aDarkAcFuSYDU6C2Z0j6RRA0MwQcgMj7DK8aQjtIex/a9lZTZIPbLmt3KX6g7f01Wcf41Jm9DCLd9kWXhtYaAJvfjj7F1I2IM8IUrt7qVR0h8n3SlpFiruBA1wK1wKVSLDERIz2bvpFDlyhLV6TloSrFckZZ7WdBv3HMVMr7iwKNHu22UTevB0ffs8lv5u4ZT6SnqtACYsF0OwKi4DcUw3pxN0y536lGZI7gMdKyFgIkg05cCOvI3JAczDE52a9ni0oPlKdOFfn1I5pDCVEyKfJB3BnOU4Be+qciO3o9UvRF//IE88zELhuRFmiH6fS6kmoj6U0WBH0ryrLn3301B8zl4N+4slSeHhVbVYLJLg6GptBM
 fXAOUASN
 ZaTjCRpVBHdELM7iY5oVRC5NF7y84rBAT4p0fA75Qub+2sJb6wtqQwlYm+segqUT0bLC0Ms2HHtNt7rJjxjskUY05R7pZX7CCuh9YbIdG12S1tengeU4ZeFgXx6c0q5UQDm4Drne3gnwlyBnQb3Hc568Pl0J8lxeo/Uxm2QOfcBxk9s3eqogYLrwYOu7GyuPQ6Bm82eeo7Piid4oc65zIxD2BbVwHdzbhy3fijeIJS9f5EESTDaSb9YMq7vqHQ8uC7FeFKHOkP8834X0qyT2wDQ6QcuU8Gjck8lrU3vRZ9hbvQ0/2HkhloNOQKE/TCn9W8t+/TJj+LgautvyNT9RVsPUVsPgXsmzzq73D0ZIr0TjAEBXgk6ktI7NdAXYJ3/dgUJiisqjIlUXEMez5XxCXTn3O2VR42S7ctf5QV5i4sdpdZMVBBKoEmjwD05tSqrXdrnN4GdpkKPywt4KILOWCFBJrtRMKh1jYDe92u3CEjAujxF7nP5o8DrmWEPwPGEI7jiePEtW9o3NOm19y6Mih2sieXCJlLkkc2xhs
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
- Improved fault isolation between different workloads
- Enhanced security through kernel-level separation
- Better resource utilization than traditional VM (KVM, Xen etc.)
- Potential zero-down kernel update with KHO (Kernel Hand Over)

Architecture Overview:
The implementation leverages kexec infrastructure to load and manage
multiple kernel images, with each kernel instance assigned to specific
CPU cores. Inter-kernel communication is facilitated through a dedicated
IPI framework that allows kernels to coordinate and share information
when necessary.

Key Components:
1. Enhanced kexec subsystem with dynamic kimage tracking
2. Generic IPI communication framework for inter-kernel messaging
3. Architecture-specific CPU bootstrap mechanisms (only x86 so far)
4. Proc interface for monitoring loaded kernel instances

Patch Summary:

Patch 1/7: Introduces basic multikernel support via kexec, allowing
           multiple kernel images to be loaded simultaneously.

Patch 2/7: Adds x86-specific SMP INIT trampoline for bootstrapping
           CPUs with different kernel instances.

Patch 3/7: Introduces dedicated MULTIKERNEL_VECTOR for x86 inter-kernel
           communication.

Patch 4/7: Implements generic multikernel IPI communication framework
           for cross-kernel messaging and coordination.

Patch 5/7: Adds arch_cpu_physical_id() function to obtain physical CPU
           identifiers for proper CPU management.

Patch 6/7: Replaces static kimage globals with dynamic linked list
           infrastructure to support multiple kernel images.

Patch 7/7: Adds /proc/multikernel interface for monitoring and debugging
           loaded kernel instances.

The implementation maintains full backward compatibility with existing
kexec functionality while adding the new multikernel capabilities.

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

This work enables new use cases such as running real-time kernels
alongside general-purpose kernels, isolating security-critical
applications, and providing dedicated kernel instances for specific
workloads etc..

Signed-off-by: Cong Wang <cwang@multikernel.io>

---

Cong Wang (7):
  kexec: Introduce multikernel support via kexec
  x86: Introduce SMP INIT trampoline for multikernel CPU bootstrap
  x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
  kernel: Introduce generic multikernel IPI communication framework
  x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
  kexec: Implement dynamic kimage tracking
  kexec: Add /proc/multikernel interface for kimage tracking

 arch/powerpc/kexec/crash.c          |   8 +-
 arch/x86/include/asm/idtentry.h     |   1 +
 arch/x86/include/asm/irq_vectors.h  |   1 +
 arch/x86/include/asm/smp.h          |   7 +
 arch/x86/kernel/Makefile            |   1 +
 arch/x86/kernel/crash.c             |   4 +-
 arch/x86/kernel/head64.c            |   5 +
 arch/x86/kernel/idt.c               |   1 +
 arch/x86/kernel/setup.c             |   3 +
 arch/x86/kernel/smp.c               |  15 ++
 arch/x86/kernel/smpboot.c           | 161 +++++++++++++
 arch/x86/kernel/trampoline_64_bsp.S | 288 ++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S       |   6 +
 include/linux/kexec.h               |  22 +-
 include/linux/multikernel.h         |  81 +++++++
 include/uapi/linux/kexec.h          |   1 +
 include/uapi/linux/reboot.h         |   2 +-
 init/main.c                         |   2 +
 kernel/Makefile                     |   2 +-
 kernel/kexec.c                      | 103 +++++++-
 kernel/kexec_core.c                 | 359 ++++++++++++++++++++++++++++
 kernel/kexec_file.c                 |  33 ++-
 kernel/multikernel.c                | 314 ++++++++++++++++++++++++
 kernel/reboot.c                     |  10 +
 24 files changed, 1411 insertions(+), 19 deletions(-)
 create mode 100644 arch/x86/kernel/trampoline_64_bsp.S
 create mode 100644 include/linux/multikernel.h
 create mode 100644 kernel/multikernel.c

-- 
2.34.1


