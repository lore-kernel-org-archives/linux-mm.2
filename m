Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96D4109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B75D6B0005; Wed, 25 Mar 2026 11:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068606B0089; Wed, 25 Mar 2026 11:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0856B008A; Wed, 25 Mar 2026 11:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCF936B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:48:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92AD813BA0F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:48:33 +0000 (UTC)
X-FDA: 84585017706.09.36D7B95
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5007120004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:48:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AdDDPQfS;
	spf=pass (imf29.hostedemail.com: domain of 3zQPEaQYKCDojkcegdckkcha.Ykihejqt-iigrWYg.knc@flex--nogikh.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3zQPEaQYKCDojkcegdckkcha.Ykihejqt-iigrWYg.knc@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774453712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M/sO4V9/AfamlzvH6Yz1izySgX6li4ODe+c+dOZMt3Y=;
	b=L/LlIZVPJnoHKorSHUoaVjn630okYhojRtQ+hWymNeTe69x6CwKp8/NtboXSNBQXQVpaeI
	IENJ8GyqpQuey3BPZ4fE3LE/YsUbnLEg/sKtaQ3LRs3xYSlCeMN1ahq+vEqh6wUkHrilXc
	ParB4xEazMzc50ZS9M1S7kHOQ/MjYIw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AdDDPQfS;
	spf=pass (imf29.hostedemail.com: domain of 3zQPEaQYKCDojkcegdckkcha.Ykihejqt-iigrWYg.knc@flex--nogikh.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3zQPEaQYKCDojkcegdckkcha.Ykihejqt-iigrWYg.knc@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774453712; a=rsa-sha256;
	cv=none;
	b=IA1r9Jp3CWy0h4ffq+wmxyycrHyMBa81PbUUyckuP+C9xDN0UoszJ9HsJW+F16/BXoT/9i
	71TwbyGQY4lsJBvlg4HUDQO1phlazOZ4JT2ccOaUSJZUfbSmtgsxHGnEYTLdUqfgpxGNRl
	j8npU0UdNzn4A+l5yPZ4x56CowByhkk=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8fbe7a6f41so220420366b.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774453710; x=1775058510; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M/sO4V9/AfamlzvH6Yz1izySgX6li4ODe+c+dOZMt3Y=;
        b=AdDDPQfSLtpgmNav3gZ/uHkoJMqd5Ee7jnX+TeGnUWxLgrpUo0UF18xKD3DhPPZ5fR
         r7OxbpCBp5HAFc267Eo9VBUEXX6RLKltMkD9MKLEtPCqHI7P5Q/GEIB+s6h5A+6XQTu6
         RXtwE8U2TV2X+UsYU8SxtcMFj6glB1tCtWVigg3bfXzc8J3tPH3Ob/us+JGwPVziZbIr
         RUfL8ZKNiOD34iVyIFq7I9B2LkPk0d8a1f8Ck1zBp5phB0Rarjq6eZ3RTEIU0VSyet70
         OoooX/xiZm/12vR+9Jv/3v0PisGmRV1m4+vn2SbPCaYQim6CR4CnV+QLAEiryW/Ohc7K
         OObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774453710; x=1775058510;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/sO4V9/AfamlzvH6Yz1izySgX6li4ODe+c+dOZMt3Y=;
        b=GzBlZcnvB6j1LqfHcbRcKAKgUZGlJSEMCasugy0wlRGvWGqT5oDReZZ5ZIv15EaLEz
         Rh6ibpb9IPVtI4vowx5KjZKISjxJhrppk/c58CJgvZr3xh+O6pOwu8OBoiIcUZpQH6pB
         7pMctSL3OB/CeWKN3PpMZav0oTC/NbGzqq/jWwWG0uoavjqvVY+6uiR7tVBnzeg7u4WD
         vz93JGKcSBEDXcsrcdQ/mY0yWdkFrl/0+OJ9tk1B3AtRQ89DKMhohYDhUi9iCtQl55n9
         bE5/DHIPVny99WIveBrJogLavkezoqCVfldyT3rpit9ghS8rJTuM82C/OWsGyriZ4zAe
         +jDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbmhpZ6JF3LEP2uSj8xtK8rc01BplgO3ovUXNT2UPodF0p5Dy464Uq2ywFqK2g6FQFszbu0Fqy9w==@kvack.org
X-Gm-Message-State: AOJu0YzUn/gNo2Du8rGodqNVQm3W+d7sKJoEHYh2FdhSgSVWfOoVvsd+
	oO0TQwLF5AOPD3ioNGVF7Idu3RhpjyDSQGG8jURC9DdJw/AavWeHo4bfDlCuzwnI+M0EQDDwAnM
	GTJ+ZPg==
X-Received: from ejwi18.prod.google.com ([2002:a17:906:4fd2:b0:b98:b1fa:13b4])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c20:b0:b8e:d1f3:4744
 with SMTP id a640c23a62f3a-b9a546a0ba0mr275814266b.55.1774453709696; Wed, 25
 Mar 2026 08:48:29 -0700 (PDT)
Date: Wed, 25 Mar 2026 16:48:24 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260325154825.551191-1-nogikh@google.com>
Subject: [PATCH v3] x86/kexec: Disable KCOV instrumentation after load_segments()
From: Aleksandr Nogikh <nogikh@google.com>
To: bp@alien8.de, tglx@kernel.org, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Aleksandr Nogikh <nogikh@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: nd3yti5715un5wb7atdxax54mkhwux3g
X-Rspamd-Queue-Id: D5007120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774453711-409113
X-HE-Meta: U2FsdGVkX18IByyHVHNVSEpb9koAiJDC2WuI6aBjguuMXYYQrliiExG6aVWi/0klHJ9WaHSUAWsnOQHAM1GDNugHEbn8o9aeVt+J8tRez3CfVJ94xk9UeUrM8V6/GWDiiniY9O6FyOykNCxUg3dF3tt2t9NlQNFJSqr54ztWDYTm2uUeGeBxKCtCR0C81ZMuVIphuzlG1YISg4SaVeLohlS8HGvBHwQmW8Bc9k6oDPfQQ1nW3KVUTaSMKMNFywhFfZ5qn5lBPd0xUGMwtyG3xIX6h/semg/+b27WTNha+7OqYVYTTQDRdYI8+z+osP/FgJ8MuEEGVFXRIj7raZ/3eES/KzebZLITNm/TTUk2TTvuBh4476+qN25a52zXWxKXM1fqDxXyQ9oEGQzotJ21wi+/p7qRSQYKXv2b0s+dSkjkeu1mwIiMEDO6fjxKb9U7hHW2srG3lCA/YHvyb8iGmxkNbBuiVK7ogSNKLtPSyTmIfFCqz2NxTONDbPx3Kc10uWBJOfd2D4gjxfvxsLrZSFpGSCOXKEF72GMX2SPv7q6RdkcEQeSUEzd/nhkzfIJg3iXJPfBUjloWIPLKEmq8wjvF/iCZCWoiCl49OfViVd8WPmdFXJty/oXMm2z3Rb2ydJ5onTiE/1PuOeesWnDsKwF7ZjygphDPVVaOhrBWQ7rw14SB1+COCb0xJjGwNeXhpUhpGv/yhBSaJNAgNo7e8zWhCOroWEBSrjUlt0ogdLVB6qIyDT1lrRmytIcKB/J128duDtD+XT9T2VmkyxyTSAKQEkIYBp+bSVkY01Gh4UEf4o889G3ca1CfcEoRlH+uLCUPDJ3FVOjZ0SZv/B/7IE/eXBLo9jtHaCDDOBcUeP81/7WURIw/Mj/0P5tPTF0btTPr9uDNqLWZ3zwbsCuR90amNkZmbe4JV5hk8jVBdflIkJFp/RXu0KCX7q4cbqPh/Fq3gQLalPk7qO3km5q
 QPsnNA16
 u/eHCOQ8q58vjyZ14YiNMrKTENmvfwj6+3nci0P/qXU7beCLH//GCWf/VyiO93REwE1ZKADccJ8BFIcjTB22hK31JAwXh63Ytv+hQGsUuxclBH+n8R37ZFHCCzGggAr8hZDK8egOY+eq7x0mxU44mHJysxsg2AcFyYWsFm4QgqpPqtTY1IBD1xU8wwPrktXyACeTnn5UDvB/uJ6T1wYTWh29PQUfNTpGdxAY5iaLXacC2d0qq1pF/TBpbtJrcQepmZWKgomIMJiLIHvi8rWb1Uy9n3azLHEk867gdB55gxaTVh3Uo2Y5YGu1FfJp22ADTLpcQYJjPKpq97TtmIqYYs2IYyoenA4psBjkNbRRpHzqjBwgrhgJCJY3zEKKhm8DitQDPBhzBS32Ti+FNVk71dvCjI0YCYpGVD2w2jT/JMoDOAYetkhlNGHrYoe+NPlK8NQ+xiAVRfKyznoqeFu7BrpZpMDEPAg1F1EpyLNTfdjFwKhhpAq9KsA7Sex7dEMl237unarlnOYsxe6lgS0XXkkWDx6m4OGdRrk+u5picTDwzE0t3WZjKgr9CEyChPozbXQte3zlXFPMJNCxWYJLDJJooKVd5SDwWlaA6bX7++59iImnjPrquUUfVyjEccsu+sKUBRLTZPCOsU4pwH97DGNLB5bITv+bmWdeeqmU4QI6CG6rI0PVnOFY/EjyvvHENaEa0
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
fragile, so disable KCOV instrumentation for the entire
machine_kexec_64.c and physaddr.c. If coverage-guided fuzzing ever
needs these components in the future, other approaches should be
considered.

The problem is not relevant for 32 bit kernels as CONFIG_KCOV is not
supported there.

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Fixes: 0d345996e4cb ("x86/kernel: increase kcov coverage under arch/x86/kernel folder")
Cc: stable@vger.kernel.org
---
v3:
Changed the wording of the commit description and the comments.
Added a Fixes tag.

v2:
https://lore.kernel.org/all/20260317220319.788561-1-nogikh@google.com/

Updated the comments to explain the underlying context.

v1:
https://lore.kernel.org/all/20260216173716.2279847-1-nogikh@google.com/
---
 arch/x86/kernel/Makefile | 11 +++++++++++
 arch/x86/mm/Makefile     |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e9aeeeafad173..febf6f49207b3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -43,6 +43,17 @@ KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
 KCOV_INSTRUMENT_unwind_orc.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
+# Disable KCOV to prevent crashes during kexec: load_segments() invalidates
+# the GS base, which KCOV relies on for per-CPU data.
+# As KCOV && KEXEC compatibility should be preserved (e.g. syzkaller is
+# using it to collect crash dumps during kernel fuzzing), disabling
+# KCOV for KEXEC kernels is not an option. Selectively disabling KCOV
+# instrumentation for individual affected functions can be fragile, while
+# adding more checks to KCOV would slow it down.
+# As a compromise solution, disable KCOV instrumentation for the whole
+# source code file. If its coverage is ever needed, other approaches
+# should be considered.
+KCOV_INSTRUMENT_machine_kexec_64.o			:= n
 
 CFLAGS_head32.o := -fno-stack-protector
 CFLAGS_head64.o := -fno-stack-protector
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcfd..3a5364853eab8 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -4,6 +4,8 @@ KCOV_INSTRUMENT_tlb.o			:= n
 KCOV_INSTRUMENT_mem_encrypt.o		:= n
 KCOV_INSTRUMENT_mem_encrypt_amd.o	:= n
 KCOV_INSTRUMENT_pgprot.o		:= n
+# See the "Disable KCOV" comment in arch/x86/kernel/Makefile.
+KCOV_INSTRUMENT_physaddr.o		:= n
 
 KASAN_SANITIZE_mem_encrypt.o		:= n
 KASAN_SANITIZE_mem_encrypt_amd.o	:= n

base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0.1018.g2bb0e51243-goog


