Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C04CCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A806B00E0; Thu,  7 May 2026 16:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A466B00E4; Thu,  7 May 2026 16:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F696B00E5; Thu,  7 May 2026 16:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFD426B00E0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5F48160654
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:39 +0000 (UTC)
X-FDA: 84741777078.10.DFABBF3
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id F188A18000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RJqI0C5O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3XPf8aQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3XPf8aQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Yn9j42pFWCYKkGf1K9Y/HlYS2+Vlbg3y86z46RrWQ8=;
	b=TR7EmMQmvbfMfCq3d7aMwM6PESSRHUOuXcbL3F3eJ7/Cls+XH9mkpnHnvepb1EhEv/e1Zk
	aOHWkpfxNKTMYyGUqB79W3xwNObW0JFSc/rAdCx25Vv8bOsDBwVdmJxYYksATgNgQGfe/c
	KZay28EgUGzkO3eqVmSvtp17Yj/wddk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186078; a=rsa-sha256;
	cv=none;
	b=JTx1HnNqWlufiZ/we4frQZBgFQMbvZuztv9zo5ZlU3Tz3hSREnTPDmrBsc7qUUgaiZjE2G
	SW2+E3hRC/D3S0rWa/+++tDi1PHjkzpPE2W2+8FO/NmKqbH1YJwLjW3N4OMrE5SR1xzKex
	d5pvy9gF3fohFJ5stynk2rdQ3wrf6KA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RJqI0C5O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3XPf8aQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3XPf8aQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so1394601a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186077; x=1778790877; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Yn9j42pFWCYKkGf1K9Y/HlYS2+Vlbg3y86z46RrWQ8=;
        b=RJqI0C5OSccZS3FGzs5HOGLSkkPmCvaL0cRQNCDcEeRPtxNpLCJ0oAAP1/hG9V6LeK
         oYbFiEPTMzitIf/F7cPshXTODG3d8Kla63TW/LxCIVFIdLvb9TMDk1oejO+HQKoW7pYw
         vrYu0yuN6etfDyqhJXISq5klteM+3n5y0wUtWPjJvyORgEpBgLTonEr2K+ETzPG8O4u4
         Uu9rIu9A2PBn+XGTN2B3uqcRdATzSjQrRZ2oJUCzQZSVGxfL5DS8EwYS2e7kceEg4zAh
         N85RTih4nSfuZctYcDcUr4VqQs4pLn/xXh67N50CVUQntV8D5v7OKcZkZWEeL5Hljti7
         NhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186077; x=1778790877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Yn9j42pFWCYKkGf1K9Y/HlYS2+Vlbg3y86z46RrWQ8=;
        b=RTMmjTfMSoG4WmxyoeablO/1vWviCcQoKKJomrxgSfFMAr0DM9sOvVhYVGRNtvd1iA
         XYr3SeDW+aIq5OKPOnUknUwhe4S6y62qafosdp+Y9X6WYSOLfNP82Sdqb6vgQMygZSIG
         NmucPMoAFzeEDB9Oa9Dz8jx6nRLwvOf3LLnrfwq+jJZL2fVzvHGBl+JlF+MZS/GkACgs
         26gm8zGycXZAas97qwdt7JaK11XllTOJSGhTSUiGlscyCTBcORSsW73bvo2R6iH6zKyj
         jztuO+yEDrIOue/s8JGasIHNHOeYWrN2u9PaetUR7Y7zKLydAILoS8UNjoxAlUI8mpbl
         tAKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Me4sVKMWXwVOIyv9flHB4+6tVfYt5JuuVSYqdp33jQsdrlCyyPZ9+H28cF8YPdMdasao6r7lJkQ==@kvack.org
X-Gm-Message-State: AOJu0YwlaN+rXj4VuSbUX5YMyzX3CQkygPnYRnuiR2y7f2mI7Vq6Q8iE
	XMrYcQU6isLz7jayOGmmPU+4CXFCSZeIJxqGC2iYTqJj26KzRpCWKgigca3tl1jkHQ4UuT1YmjD
	tw+2IiIxzAzKfj3/FMnDB1sBVQw==
X-Received: from pgbfy18.prod.google.com ([2002:a05:6a02:2a92:b0:c79:26bb:5541])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a08:b0:3a0:9052:c005 with SMTP id adf61e73a8af0-3aa8be1f13cmr3709118637.3.1778186076252;
 Thu, 07 May 2026 13:34:36 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:23 -0700
In-Reply-To: <cover.1778185936.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <cover.1778185936.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <b1ec34e503cc08fa20121e542db3c1582e86286c.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 2/5] KVM: selftests: Use guest_memfd memory contents
 in-place for SNP launch update
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, liam@infradead.org, 
	linux-coco@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F188A18000E
X-Stat-Signature: yrykodanmobmi1j6b54d4cbupgxmfawh
X-Rspam-User: 
X-HE-Tag: 1778186077-899944
X-HE-Meta: U2FsdGVkX19hDYIxeRUwdZ7ptqhtTD5MuJUrUkE2DVHAIOyo7WsCas4YRNlzY+51Hh4eDiC7OTKZmWviamydFq2u/yHoaU3rUTbtGPHgsXSv8ULMtDlj/5aEQpk//ar1NXHocDZIhuCmC1XbOTqXgHm98YJGwTUM5QatXtBQ6tzWYdY6DlJZ4MrBkf/QZcyjHGiqAKnfjgeb+BhLezNu3fsqdd9amcgTRA6wG8Oa/IkgtNRfHK7r3vD7TKC3Owdef2Si6pzbxOPWjbMCKXFHV82WAP4FGZ5kod7kMX8HLZ2hJ7F8nqugqi1SucauhKVnjk3gW1WHTEDefxwhu5w1WmX64VhvpcKz2DzZmzblPxau8ixLbFIBaAXxC4SkVCCskKnSEYz+2KTY3bYfyAFvIweJbQOehBocSIOMZTS0haQR/M2/T8wqXqa0PXy9e5QJhzsvGVHYiRoOTGO3/A93+Xvysxk/iUyggUXPdZqX4FxQQnsbo5QEPiwaAQP6cpRwvXCiWe4Gr0B3u+gfVGSLWBSpCQkISHxMAHbjnGWbEUrXPdlAv3yW/jaLB3JUnfgrR+ei9J06LDQ3gB4GJCutM2fpIgmO+Ye6udDfaVH6DJbPiiiC1EZAtYJmGNQN93bQeeX1QMnsOSYi5XNGhjPc1iLKxgA1GMUPRT56X/0Ma1Mf0yg/f/sUV3q6T1nHXWmrEhz9NY3aJs210AKd9A4Ns9X3oRn+V0oRCIhF4ahO7Hh6j9BXi+rfQ+eQyMlXt0+1NGsU63zFemlZpQhQJLeyLBC4c8TwRHHjW1fVJ7W5qLUP2JX07ihpEldYK8oNJpBLCYpHq8yjJ/NegN2hoTxMrJkeP/3uyJDN1tNO4cy1MIljLdjjio4WX26+EaYdHNUmFlYdanbN0KIxTgSHo5bQupp1zIG/YD6nEmYM0SvsNgUt7pR3T6oqC9v5PFU2977CY4kGGeSIChX/V8RtWAi
 pgXFH34M
 cYLgBP80L2RUvV/o2DKL5/rU+i7b714fm/4H29URU2LTAB1Fa75hiDFAuiJ6dmgYGurxoYUSFzOVTLDGIU9lZadspOnbotbn5Kmp3du0c65644quPfnU0xpeF+LB/TXwITyxBfnL2zUatrY0h2RY7+RiLHv7z+uxtkVPItqdgJoBNu+caqPlP0fyBR1/9Mn8dcUvkZwDfC07AS75CmYV6sDtBQWdFtCRr9SqT5NNCoUqAticH3Zqt4KPBOfhBFRjNAEXR+tIyJQUT7gXJKuJLmVkiJaP/lX5OCnjyuIoD95mOsSAEdKQFqPd0BCpKDuo6PrEmlLd6Op6bH1sETDemhxZcIF7bQ6CilLXDcjtWoM6keJ8z38HEN/ajakl7uzhni7UkAVL28pDh9wjQWGzfTfE/G9z0qNHE31Q066+Z8o4SX1MYr9W44N92wW8bhDqCmZkIfAMVy1V+DASEAR+LMz5nxkKkge4/ZOW0rIU0xoGyyOmSuONBfXGLxcmxbs52jawXTtpRaVdEPSW6VMyuwhfE5D39Dbo9/9H/foPD1Rxui9THnobKpxYT0f6Lws81FcWbdhNfv7oVyFy29aE8Ms0eI78YyNo3dgAvnHtCxKvxgpyq27aog5OuRgp6kV2+O+/+GsW3InY5hnBTdeR+xZt4H3RdIJLOFxoCd+/EPjTGU8TKkD4uoLTX75wP5lQ/a/7uEKR5fT3NFBi/Ks5OI4xvMiInBVx20+vG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the SEV-SNP launch update flow to utilize guest_memfd in-place
conversion.

Include the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE flag when setting memory
attributes to private. This is permitted before the SNP VM is finalized.

In snp_launch_update_data, pass 0 as the host virtual address. This
instructs the kernel to perform the launch update using the guest_memfd
backing the guest physical address rather than a userspace-provided
buffer.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/x86/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index 93f9169034617..074ab0eff1e27 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -37,8 +37,7 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 
 		if (is_sev_snp_vm(vm))
 			snp_launch_update_data(vm, gpa_base + offset,
-					       (u64)addr_gpa2hva(vm, gpa_base + offset),
-					       size, page_type);
+					       0, size, page_type);
 		else
 			sev_launch_update_data(vm, gpa_base + offset, size);
 
-- 
2.54.0.563.g4f69b47b94-goog


