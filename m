Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36657FF6E8C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 22:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461356B0099; Tue, 17 Mar 2026 18:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412B76B009B; Tue, 17 Mar 2026 18:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328066B009D; Tue, 17 Mar 2026 18:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2206A6B0099
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:03:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6066139983
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:03:27 +0000 (UTC)
X-FDA: 84556932054.07.D555DB2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4AEAFC000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:03:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jvymggxD;
	spf=pass (imf10.hostedemail.com: domain of 3rM-5aQYKCIcyzrtvsrzzrwp.nzxwty58-xxv6lnv.z2r@flex--nogikh.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rM-5aQYKCIcyzrtvsrzzrwp.nzxwty58-xxv6lnv.z2r@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773785006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a5ROHSj5Kev7hvsbjDyb4mWRpxoAV8o5zFiVg3Mbgk4=;
	b=bfWCltkboCm8kmCTffRIPvyiiU1rwTRb2lnntXmZ1bFB/cGtjPApvJvrbAILhSyzA1ZCp7
	zHmJUmarXG/TneH3WSzYi6kVmivR0rQSK9gJbM1CFnZl8cAPG/+OUeOVwdSBTXZUtQNSXF
	/HYnT9xLEH1Hure1Hjj/CgDqeX4//ac=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jvymggxD;
	spf=pass (imf10.hostedemail.com: domain of 3rM-5aQYKCIcyzrtvsrzzrwp.nzxwty58-xxv6lnv.z2r@flex--nogikh.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rM-5aQYKCIcyzrtvsrzzrwp.nzxwty58-xxv6lnv.z2r@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773785006; a=rsa-sha256;
	cv=none;
	b=Pl+vC6aOoI/fhjSiEmEEjyjr8O19LHs1aBN1ZlnmySMXcYZU4a6Mn43m6vNN4TxL4KLwiv
	mPCtCGEO5NEziwU+TbHQV8ff077THLdn2inwaB63s/sPYpLTHntDHuc2rx/KlYjjiVz61W
	WRdTOMYLjYsemYHOV+onXJLKKBmFeuY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4868e691614so7461355e9.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773785005; x=1774389805; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a5ROHSj5Kev7hvsbjDyb4mWRpxoAV8o5zFiVg3Mbgk4=;
        b=jvymggxDTlFAT7b/EsCICSirVTibq0nx+ac9Legi5pmgclZLv/oibIptKM3t9P45m7
         n8Vix4LP7Fpmsfn561swRIcbByGhZTAfjiJYFpjE6HsArQI0DJb1bJmXdib7qcQoBp2t
         p8zEVwJ4KebtoNtNAd5owSQkSgqZTbnT5tO0OohvXPMoOVHQ9OGj3jYQ6x3IGehKarxA
         yax2TdWzbrrpg6xurh4E0CdwO6BlV9LXUIw7odNotxy4D42uMBGxS7AK1tUUy3KZcUUs
         x2KPB4VM/PNmYv6RiZibZY9UcBX4FF8/PoYy5lUEwDaPXwd6lUZRlYuVU9m2GZWUB8nO
         U3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773785005; x=1774389805;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5ROHSj5Kev7hvsbjDyb4mWRpxoAV8o5zFiVg3Mbgk4=;
        b=o86gINp99yhW97tjmN6fcbZJajOz+xhXAmUr6EqpoczydwYovJGt15h2qbMDvnKHeA
         Mtwrp9zishQ9L7wp6dsjt/lk+XhTu+KT5i8fo99j/UB88DQ1u2iKzDfpK4Tj7SVtPMuB
         JWBIDEf+JBaQEdnmT2QOBu7tq/hbyDLjG8N759tZ2YbaPjO1NcC8JSuq0FJifSd5dQJn
         gEdZw1N7RSE4d9K6H77aV8h/Wk9iqKjx73eEc8LwyzGEGvavsPkVyRlHdDDktjmR7gJv
         Nb3D0MCQiD+Eo99KiRutewBDgfI7EZD24/mM2kUt6aXXOhA8urXD0KyFCjqqS7zZ+ozz
         s20A==
X-Forwarded-Encrypted: i=1; AJvYcCVdZpagE9yr794WLcl31gXIoNuyK1W2TdunRfRbGUt+iL2LXCzToZFBs8QK7gw00L2Jl7CXqosA2g==@kvack.org
X-Gm-Message-State: AOJu0YycEZborn6JFTc4+XJEpVIzrlUtPa30T7pOhKUR1/kxytjdLHII
	SdRDNMe4oZoZEPMAuPfGAuyM8uiEl8CpucBvfjREmdLGPwKdnFEb37A5RKTihFFwkz+gLzNlrFA
	rIEvw8g==
X-Received: from wmpo21.prod.google.com ([2002:a05:600c:3395:b0:483:b1c6:5b34])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3514:b0:485:3a03:ced1
 with SMTP id 5b1f17b1804b1-486f458107fmr19079455e9.28.1773785004419; Tue, 17
 Mar 2026 15:03:24 -0700 (PDT)
Date: Tue, 17 Mar 2026 23:03:19 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260317220319.788561-1-nogikh@google.com>
Subject: [PATCH v2] x86/kexec: Disable KCOV instrumentation after load_segments()
From: Aleksandr Nogikh <nogikh@google.com>
To: bp@alien8.de, tglx@kernel.org, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Aleksandr Nogikh <nogikh@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4AEAFC000E
X-Stat-Signature: kmseokpcc6xiuyedchhikisd1g8d79en
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773785006-235059
X-HE-Meta: U2FsdGVkX1+aDGmkoN+s8Gs6tx9f+QKcVM5dARGiSbFjZtsNTwOZx3+r0ePRjRPVMc1yBPOWHqdexlGWNWbO70lOjb+4fFx3mcCnRJW7NQIrpNhavmejYZDm7eH7/ygzjWsypkDhWHgtcSRRCBzo/marSB49LKP9UG6xFpx5ujzYFN5AvgmxhG2GfS9AoDcEUnXxx0IFbfVOczQFbc/UbZbjnfatrqREwC2PgLTqUt+8Eu5p3dDlgt0PYLr6qisHG0i1VmdvObj+Qdl3g/tRjQ6SdclUKKkhqa6MydfcC62hZnlNEls9RiZYyIhDq0Ut6bUIBIDG7FoLqg41AXmIOtCUUDPeA3FZFPMKism21fRp4v7CGfSewxHdwhArsQlU6Nnws0LrnFqcUTATglrF9uu3mktDuDqqJs8uTtnU0e8hT2BfPtKdKXCh4PttoPYJLP8LMpa56O5IJbSwrqK0IjwUvI4E/OuI8MFxaBCg/auVfIrqdCFN3bq4kt4eTZCshTowOZV7ndCIfbkY7XcIEo7bgpVzHGGwa2c+CNXVgxcfwue/mFeepfKKAtVV2RfYfJ2BpLUgStStOUnZFTxzTLmty9ttL/4pRrNuVfq1tdTEo/eFHlzeBY9/BDV5k3kIETfrE473hFH7vNNAQkL7aBqPx2S016sGdklbeLkPvrFC4FtPQUyx0rjvCTbpe6S5LfOWBFhDxyON798AzbK7Fy+ttGLN68vJqv8bQ4rGfV5RxqbIADFBP7hyoVTCOg4arD61QigBsRbq13/g+9HeacSMbpePWBPyMzx6P2rzMUVixbAQIu7s2eszOp90NIOEL3X3U3LZL5gVb/BTy7IZqoqj9oVhVGd5/4MfNT1rhEm6apYrBA9bKJsbKBh175Rq5+Ipkqvl1TM2cCGWQCH84RCtih7oTgqIOld2hCDw03L6T0OpbmcSDmr4RFza2Fiib5XwVrQB41xthT568Ty
 LyDKL0G7
 8VFn5s41/t6B0yaQfHYG1Vj50sgd0WBlRDn2CK3nh0TgQbOk7XnNkx1844ZInTPGpMBMOFYMPs2U5fcD4MoP7CIGHyCEv43/1zmM6TSpgyzba46TqXV4PbIYcgX7v+W5TIMUnn2sJaUsOmA/YnoFmXVKLd6AiCMc04K5CZv5dhUJvHfmqAYK8ae2KEd6HAhuTE+QLNDCTNCB0zMInmwImLcnqxeklSMhV4Am4u5uwdbwdZ3mDmP6M8H80mJllEzO4aRusX9tMbLp8ATzKh0UtRbH2HRB3heTqppv1UYY93Fk40VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The load_segments() function changes segment registers, invalidating
GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
enabled, any subsequent instrumented C code call (e.g.
native_gdt_invalidate()) begins crashing the kernel in an endless
loop.

To reproduce the problem, it's sufficient to do kexec on a
KCOV-instrumented kernel:
$ kexec -l /boot/otherKernel
$ kexec -e

The real-world context for this problem is enabling crash dump
collection in syzkaller. For this, the tool loads a panic kernel
before fuzzing and then calls makedumpfile after the panic. This
workflow requires both CONFIG_KEXEC and CONFIG_KCOV to be enabled
simultaneously.

Adding safeguards directly to the KCOV fast-path
(__sanitizer_cov_trace_pc()) is also undesirable as it would
introduce an extra performance overhead.

Disabling instrumentation for the individual functions would be too
fragile, so let's fix the bug by disabling KCOV instrumentation for
the entire machine_kexec_64.c and physaddr.c. If coverage-guided
fuzzing ever needs these components in the future, we should consider
other approaches.

The problem is not relevant for 32 bit kernels as CONFIG_KCOV is not
supported there.

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Cc: stable@vger.kernel.org
---
v2:
Updated the comments to explain the underlying context.

v1:
https://lore.kernel.org/all/20260216173716.2279847-1-nogikh@google.com/
---
 arch/x86/kernel/Makefile | 10 ++++++++++
 arch/x86/mm/Makefile     | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e9aeeeafad173..41b1333907ded 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -43,6 +43,16 @@ KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
 KCOV_INSTRUMENT_unwind_orc.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
+# Disable KCOV to prevent crashes during kexec: load_segments() invalidates
+# the GS base, which KCOV relies on for per-CPU data.
+# As KCOV && KEXEC compatibility should be preserved (e.g. syzkaller is
+# using it to collect crash dumps during kernel fuzzing), we could either
+# selectively disable KCOV instrumentation, which can be fragile, or add
+# more checks to KCOV, which would slow it down.
+# As a compromise solution, let's disable KCOV instrumentation for the
+# whole file. If its coverage is ever needed, we should consider other
+# approaches.
+KCOV_INSTRUMENT_machine_kexec_64.o			:= n
 
 CFLAGS_head32.o := -fno-stack-protector
 CFLAGS_head64.o := -fno-stack-protector
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcfd..ea3a31b54e49e 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -4,6 +4,16 @@ KCOV_INSTRUMENT_tlb.o			:= n
 KCOV_INSTRUMENT_mem_encrypt.o		:= n
 KCOV_INSTRUMENT_mem_encrypt_amd.o	:= n
 KCOV_INSTRUMENT_pgprot.o		:= n
+# Disable KCOV to prevent crashes during kexec: load_segments() invalidates
+# the GS base, which KCOV relies on for per-CPU data.
+# As KCOV && KEXEC compatibility should be preserved (e.g. syzkaller is
+# using it to collect crash dumps during kernel fuzzing), we could either
+# selectively disable KCOV instrumentation, which can be fragile, or add
+# more checks to KCOV, which would slow it down.
+# As a compromise solution, let's disable KCOV instrumentation for the
+# whole file. If its coverage is ever needed, we should consider other
+# approaches.
+KCOV_INSTRUMENT_physaddr.o		:= n
 
 KASAN_SANITIZE_mem_encrypt.o		:= n
 KASAN_SANITIZE_mem_encrypt_amd.o	:= n

base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.53.0.959.g497ff81fa9-goog


