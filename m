Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC1FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E332C6B00CF; Fri,  3 Jul 2026 10:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B036B00D0; Fri,  3 Jul 2026 10:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48136B00D1; Fri,  3 Jul 2026 10:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBC16B00CF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:48:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26FC81A0132
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:48:35 +0000 (UTC)
X-FDA: 84947746590.01.6BD37C3
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80346120007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:48:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lLhsSD9P;
	spf=pass (imf29.hostedemail.com: domain of 3v8tHaggKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3v8tHaggKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783090113;
	b=5PnJV6Ua352soLaCpQJIpU7PtHkO0kXRmsGSwUGGYiPAzCDYKygffgk+C/yLSk4z6nOtEv
	hVJx4eTaalKeZf17HgP+wiLCu6KNjAsnL/2ipojJGFFHnUkbsEGZs0V9LxjODBlkae0cty
	M+K6x5FX/c5jVOcJRKa/j8hbCqkYi0U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FA+aJY22ICn5BB3vWx6DuJp5j1iC2aa98uELpr+1DAY=;
	b=gLtx+P1ZHzWbXwJBbcGw6b0uD/LlBsx8geowFi9dGyA8OOx9JjdcFUpWtqQhoDqZ/2rdR4
	nZxOdiml7VY00GytcP/gkcGcOWKHzzz+UDHD5/wLwka8YO2oA4Oduo6C3+DKh11ff96w6w
	e/yBXj4Bnx3Vm4pg0+0Tbx1/UGIVhGo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lLhsSD9P;
	spf=pass (imf29.hostedemail.com: domain of 3v8tHaggKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3v8tHaggKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493a7fa8481so12944185e9.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 07:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783090112; x=1783694912; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FA+aJY22ICn5BB3vWx6DuJp5j1iC2aa98uELpr+1DAY=;
        b=lLhsSD9PTqoZu9zVphtB3IfMcLdbBn0CchXCqnqMIX0fuWKzErYCkwyAtggrYMzss5
         oRTAAe3vjmhyTH+8IoknU45Hb2xJajWA5nhmSPOzH8r2bwIrlWvQ6r4QQjsMzx7GJO4G
         ezU6dRKEcH0/GvfQ48mDRD3YIp5l8LklMu4qqCVZr4s2A5aHYcZIpd9dezHBktf/DFLU
         XyYkUjTFhkT827gKAw29R18b1OrZ8nAgUP2sW+0eaujr8ERe8/OXgmrgVsaAbD8EH6HF
         vHzF3jp89+jhBBQ/aoNL6upxwBb9yvtYCdlSOLphM7Jt7GOlMGgAQUboqjaBOQIRkBiS
         y9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783090112; x=1783694912;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FA+aJY22ICn5BB3vWx6DuJp5j1iC2aa98uELpr+1DAY=;
        b=Ak2h3zfIxzpktasMZX8Bn67XDEhWOYZ6Yd6j5TO7Q5kKZG/w37hPrnq0JpeQ/Bh5hv
         hbDCyP455kQ9wuwZK/Ezs122SqfCsQeBwaXisS3AkitfQTlRlQ5UrxhQdKbn51RBzZei
         irKUvm+XzYUpxnOdrgb6ybddtQhGHVqsMOWY4ikFOiI/JM8MuGTm7M5XZG9U/KfKzxIX
         06ZY+R/9QC33MLelzZt8O51VDBo+JqdjvN7TxWUzJzJLgZho0K/a4cLUX14+g8Oa+l8B
         MY3bT+mOVLMTHPghlh0sU7fis/yuuPyS99Ej+XHpP521fDbvCzwI+DD4F5I7MY/k7wHE
         KntQ==
X-Gm-Message-State: AOJu0YxKAI8jSbxdFLh/gm+tWCZonnCfCaJo1ENhgnY8gG6tV8NKjw91
	xEirBQsVDVHjhzZRMy+tVP/OBXMTky0xk4oJ3n+Fjl7EyV0ufVNb5v3qbP+55jNI6EhCfy/Wnqy
	CoSh8KzM3QTAzoQ==
X-Received: from wmbhb6.prod.google.com ([2002:a05:600c:8686:b0:493:b080:8b95])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:4448:20b0:492:3fb5:3a17 with SMTP id 5b1f17b1804b1-493c9b44882mr44220215e9.2.1783090111878;
 Fri, 03 Jul 2026 07:48:31 -0700 (PDT)
Date: Fri, 03 Jul 2026 14:48:26 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIALnLR2oC/yXMwQqDMBCE4VeRPTcQY1Dpq0gPmkzMClrJ2iKI7
 25sT8N3mP8gQWIIPYuDEr4s/F4yykdBLvbLCMU+m4w2tW50pQQuYZsxq8hjvNdaDNYE31dlS/m 3JgTef83u9bd8hgluu0N0nhfpboN9dQAAAA==
X-Change-Id: 20260703-secretmem-highmem-44eb42fda318
X-Mailer: b4 0.16-dev
Message-ID: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
Subject: [PATCH] mm/secretmem: disable under HIGHMEM
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: msom7synob44gb5kn1ucxjc3yhw6b1ik
X-Rspamd-Queue-Id: 80346120007
X-HE-Tag: 1783090113-384653
X-HE-Meta: U2FsdGVkX19ZDPv8K2+KMVOMKhskbfiM7ElpAbIpWNluoPTFh/t5H/HpRllOxLoNpvJTGXtFVXXt5VdFd7nNddtUNpRGLpQnMFAZsTgMzNu1mc23tsd27JqvTErDnGXGn2OI6ORtY4cvyBNtpFlgvg/btvOhI1oKL8XTe8eUdqei9wkY0dmMnkmSVxm3k5lv1T7IcmGQjHB/JR8CLTHKkDMTmxr/R/cWzCQjWc8GyIJA1fyoOsjkj9Xr9s7HVhmeFOzWyEA21OnOigT85Uo1TbyPANgpYHfKrWIrggCCyZsjVck2/igncqoJNQaxgrDV4UEFnKZj3HyVKD58f3ILznmC0+nrFEOjrZaBT47CDWWuIckYd27MhjBWMB6iAEneDkD/E2RJehWiWh5iSMaq15jhLS1Eg1yyTHO56tHkLg4am6iAXRLY03xTKLKZoonV/aHhnBLZOCr2xoSEiPrgoHBNjh1HMPQYjYgBaCH/0KYHkLEexu0gsknvUM4Av3jmcs/eAEntZOefoIupSJbyPSWzJcFV2nNZM7Be7oqK1yf5ilKMYaV1ba7ZkcyoTN36UOQLQCmuZLiJmgqUeC4jdCeqDwchl+RrXYOVA1cFKy7AM3DPHlbzGeUpOXnJaPLlkw0q7SaMEUuI1ritjQS6HInJwZWag9QXb2pSvNlONmwC+tvK9wDlF/nh9LuIrgBAvLPqHKzuwg3n+DFiDRZJuyhbA2WDT8G4XnXbKgLdw8v0hDru+tbws1q/jHJPd1CbfYfTYcWiWm1lWLk0LDxa+gesVKkJdC3Ubvz4c6fu7MNc0y6CF3QEvZqBWadsKIjN6HVMcG3ung/NN+FnoP1SG8u2xN422h8lQGUYeZ0p+0otlnlrlVSQZNpxDXndC629QRy/EwcSKR8hu4BMY8toLIIFK3kPtjpf1rv2i9C2jG/KaCm9fhz7pv5Mi8cDhPXr+5zsBu1f+DNImANSK21
 qip0dTrA
 FHYkynoIRyvMsj0gGV0TNz7/oOkk+BBpcO7F8OxGo9NxG5R3Bb7MbFVl9TmChFM3y4wt9hm30G/Jz7SB7gEQKIodzOyW/j3TbQnSmx7kKFEPyDD8EWWhFaGN2RdzpxlnFG5sQszujKsD1ZmdNOousCanJvR+1INmzB0PsFG0q2lDE80OYFtOUmLWcpI17qfIeXgMl2a3cqSnJcKQNSYbAG1o6yKmYRccMED04FMRHp3SVJ1qmy8e4/+6PwqM5QhU6drovTQO1cDQti1EbHB3d3C1wfBuk87z6MHDTI/O2RK8aGmtdm7TxFG/3T3Ajhpf9xk0I1kild0PoErLtWhmKBft5HWZannzs16JCYnO8aazJifDLX/AclVImB0Erb0ZpfyqiRkHEoZM+B5l/GMbt/3fmhMRtFV6T7Nj6rIw1lmkWMNdrO8FRbpLGaLPix/hXXNRlSRvMd8jxSqUQWQmjBZ/0kO67CcU7qSmfSnEGl7LqzrEWrOZDFL+nMJOCb8xlzHFxN54YrTiE0bzaFY8CCwDNkh0bJoJurQwYB2siIizmQrfTJ4S1pN8Efn6ezvrNy1oTo4MxEwuNxsNaG95fKyT0agrPjzcQoCeJmO8sk2yBMH+/PiX/psC2Dbs4kIb60Tq8DLWMqRSnNfjeIPj+hIemJilPyeMcOKQvaLc7PUH8lJSWhrcXrKZivw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
set_direct_map_valid_noflush() without checking folio_test_highmem().
This causes a warning and process crash (vibe-coded reproducer in Link
below):

Su[   30.071284] ------------[ cut here ]------------
ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
Populating memor[   30.074614] CPA: called for zero pte. vaddr = 0 cpa->vaddr = 0
y...
[   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_fault+0x34d/0x360, CPU#5: allocate_secret/570
[   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
[   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   30.097543] EIP: __cpa_process_fault+0x34d/0x360
[   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b 00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7
a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
[   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
[   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
[   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010246
[   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
[   30.127010] Call Trace:
[   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
[   30.132275]  ? console_unlock+0x99/0x130
[   30.135069]  ? irq_work_queue+0x36/0x70
[   30.137853]  ? page_address+0xd3/0xf0
[   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
[   30.143782]  secretmem_fault+0x128/0x210
[   30.146560]  __do_fault+0x25/0x90
[   30.149053]  handle_mm_fault+0x6d1/0xcb0
[   30.151759]  exc_page_fault+0x135/0x3b0
[   30.154487]  ? doublefault_shim+0x150/0x150
[   30.157416]  handle_exception+0x130/0x130
[   30.160137] EIP: 0x804d29f
[   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 0
0 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
[   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
[   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
[   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
[   30.185161]  ? doublefault_shim+0x150/0x150
[   30.187979] ---[ end trace 0000000000000000 ]---
Bus error                  (core dumped) ./allocate_secret_i686 2000M

The equivalent bug was pointed out by a local Sashiko instance on
https://lore.kernel.org/all/20260410151746.61150-3-kalyazin@amazon.com/

This hasn't been reproduced it on older kernel versions but from code
inspection the bug seems to go back to the original introduction in
commit 1507f51255c9f ("mm: introduce memfd_secret system call to create
"secret" memory areas"). If this configuration has always been broken,
dropping support is not really a regression, so do that.

Link: https://github.com/bjackman/limmat-kernel-nix/commit/7b2acba2d3a5ef01400d493a155beb1d135b6bb5
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Note this was found by Sashiko but in a local instance, so I can't
provide a link to the report and I guess it's technically inaccurate to
mention sashiko-bot@kernel.org.
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 04fe5171bb8c8..17c3b77b21a6a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1356,7 +1356,7 @@ config MEMFD_CREATE
 config SECRETMEM
 	default y
 	bool "Enable memfd_secret() system call" if EXPERT
-	depends on ARCH_HAS_SET_DIRECT_MAP
+	depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM
 	help
 	  Enable the memfd_secret() system call with the ability to create
 	  memory areas visible only in the context of the owning process and

---
base-commit: 0efcf9df728408cdc9f78868f1753ec0c5319f7c
change-id: 20260703-secretmem-highmem-44eb42fda318

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


