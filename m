Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8A710AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1E76B00E5; Thu, 26 Mar 2026 18:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A636B00E7; Thu, 26 Mar 2026 18:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561EF6B00E8; Thu, 26 Mar 2026 18:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EADF6B00E5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 096D9140D12
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:56 +0000 (UTC)
X-FDA: 84589647912.20.481D09A
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 34B0240010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uGrFFeTT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3cLLFaQsKCEEdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cLLFaQsKCEEdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5T3ttFXBFTFqoigTPXjqr+RtWpyGmHMkCotHkIzhdo=;
	b=46FMB31psjjf5ls23lGWrb5AegymRAu3CtGkw1YHNH2Yus8WWhjNNkFhIolOxhp9S2Y6Ar
	O/UzVzaSBHrkFHPBabQzBtUlGzt9KidiPjs9HtHvC6nEyMTCVFYUoCepROc714Bw0g2DUL
	8olOMCjqzFfU36vf7TqmoIRIjyYZ+LA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563954; a=rsa-sha256;
	cv=none;
	b=yoMEJjHA1ruLKZdepq3USoa1sbduZ5kTlsCXyDHf3uxEzlZkdq2Hcan2hAyUp8orruHFeg
	UaFAKqkTUqsLmi+0SV31Cq/wQnK6uVqvBtzRu8r4qllwqA66Tjhntv1kg9mzFMFHe98LkW
	8k7/wL34YVAOPZvJcyq0puA/mxgrhsE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uGrFFeTT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3cLLFaQsKCEEdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cLLFaQsKCEEdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35c2dc274bdso313607a91.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563953; x=1775168753; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K5T3ttFXBFTFqoigTPXjqr+RtWpyGmHMkCotHkIzhdo=;
        b=uGrFFeTTkxWk3JbetlswEJ07JnCPrm49ZgZFMAGOKOOAERLsvs1GPbzwK0Ncfj95b4
         +zVR4xKL56LYaPXzg9MEmU0AcbJrFBsvLt0FSxnOa4KuRBHr+/0JXXBo/kuRSRlbr9Oh
         X/BXFhOQnoLZH6z98qR+Sf1nEE21D4FdZ7IGTV0CyYEO5QXiqZyu8H+9ijdj9CaMIWGt
         IxYtPVMGWzF6a2zSxI4hsaYrhjYLTRwdd+Ki1KJUUFUPIqkIMvXfcs7YX4dAXcSWC4Yk
         MPfhUZeanSGlmGSnP1hMq6hnLscnk8vmQlzDPf/mURdlkAbsRX5jTagtRvzPO0BvaNdP
         D0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563953; x=1775168753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5T3ttFXBFTFqoigTPXjqr+RtWpyGmHMkCotHkIzhdo=;
        b=LiVdRUBn6yMXpKcOoK6Cgix/G+BZWwNRLpAr8WOx3UTzpbbMvpUxZ2BDsG8HHUq3GB
         f7x/ADhSSfPHNLZ0RskysF6a9jrAaZQ3regBo4AQqaJkBn3DfCgN/McZVopoWIknekR6
         lzDXfl2o+zgvc+4VOdiszeVgmdlVk0Pp3wkJxL/DOJbRgdZZ3Si8Yr/VAFJ5SH/tuKFj
         Q2xoZ++yAei0UXNSeHwVd56kK/fjjKYDzr8hLJrGI8Y5dXEpTEo9V8IyJO8Asdjc35du
         smTk2P8ASyJiaHJ/rWxFj9I4kXjQ4bNAjtHUro97+pitG0KEkIW3/E1DWuvWXo7UsLvC
         gtGA==
X-Forwarded-Encrypted: i=1; AJvYcCVk2XcV/Cb5WKenzADXn2VK5f8LEvk+cw4wga3b9pEhoRhjaowktt5RRz3+TpGCS66kLnojGG4u6Q==@kvack.org
X-Gm-Message-State: AOJu0YxGwNn73nz53I+Mb1d1V77kxs0iePgmSnOuZ5CTBB3EHECFHMbV
	GdC5k3Hv6OF6e1BDThsAJYn/Pvk2AY01Yrcl1QQaEO9m8aESw+XYeUf2b5ZuirsjS/Tm2CRbY4I
	0LPUuIuGPBtWKqMWuSWm2l2CUOQ==
X-Received: from pgac11.prod.google.com ([2002:a05:6a02:294b:b0:c6d:c043:2cb4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4e88:b0:35b:a7be:ae47 with SMTP id 98e67ed59e1d1-35c30056d6dmr246000a91.21.1774563952777;
 Thu, 26 Mar 2026 15:25:52 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:52 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1225;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/YIcGPcW7wZJhSlI+0RZdLWi/pX7t9Ru6z34+pKDs+U=; b=nilaAfO0iV6blJ3/Lyvhk7nxY4Fc9srAhxHYkSRRNw5e5PdyvPo5CFKL2qtZRMYmb7vAg9rSY
 2VuzYa5m/+5CmT3FIb6yGX1IS4Jrr+PUe0wpNjgsMrimNMuC1aNLWIo
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-43-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 43/44] KVM: selftests: Update pre-fault test to work
 with per-guest_memfd attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 34B0240010
X-Stat-Signature: 47cobjkn49hkb3uurr1obox93rqed9jo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774563954-92126
X-HE-Meta: U2FsdGVkX1/P0Gk95a3LIPBNgzOJWcGnSO2+xueUWCiWtC34uEDQMNpUfV4WFg87b9okVx/UEZfc/yQPGf9tnPjV6kzwXX66Ov+BNw6geZYJqvXUiUuFCqp1hoRv3N7pi4qaI/yRMaFlm4xNN//Qaf98e2BFuGwHS94jP6a0bgTnAPhv2vYojrNo36GW/zXFNAE9/pUtoTgGILq6EwZV9qup9g+laaO+RG1jxzOwWwGI8J19Gw3J1StFOqG6ciBfuv8ysJ0f6gmhTl5KMoEUioPePpNgIR8XustEbxgkdONiKp4UZ20cKaXt5F1p+yFHScvz/aQnSyiPoCHQf9r9IhKxlaqOJtDkVFdPlpg60AV7GJQQ+wUAx4jcFiPCcFo+Fyq1fJ84ulFYZgnQQuWQf2I8FA3SwH1Y1Cz4scQnK0W9t7t/lY2W5G/bElCM6ZTaS0Ms8Idx6SNb0Bv8WjymhvbN3zmuCA1JAOvyrIzoJ29ESCJKGHPzVNJgoXVjND91vXBtvpfu9ykJhWBHtF86dCzf0ltalBTJnzA1+aJRFwdfeWR+4e2yxGIdusBbdGZDLsP+qYzyX9j2caHZX8JwVna0F2NMvP/38lIjvzc5JbHteNccc8YucAFLUHb3sMOYoH7aPeP5Ts2kChM+7UlmMqgxZYgoMti+MMnaD6or049dOv+Jcbx48dCJtBsp5ipc4R6AV8hJWx4BcNtWtrR9Fzt+D6qCKFhvWH7t9Z1zHX/oqVKowUXOVSSbZFwGCrkRM/9ec2Hw27u33tauFBwoBI0q/NgH0RaCzKOWuvOCHPEAfs7x8kpGaWt0On5/wbUlQNfE7N2cZJN9rwfhlgrgFsBWTmOgAmZFl01zE49JppU8i5gnF8j7Y++LOgKJQVyQM9fXs/Hg58P+dR5i59kDxkW9O+TkGpsmSIwJtbJbQevwk7IzHf888y2q92A66ZxT/+HM2n0HQ9fp3hiAoXm
 ZWyykHuk
 5TBzGwVEvtWlvIwW//DNDx7hgKoMTuP3GknpkDeRYOS3h7bxPvCjO3Tc5E00lJj2PPUGf7A9nztwTiZGwRvmKv3hiwyfPTnUyZ/gHbiCJxZ40/2qoxHQo6mgxYwEc7qBmG3SERrkTypkqgFtKuchx34mhRDxyLf5oAyHdi7VCXHOAvbgfF9bUYrQo12xq442A3WWnjPdGYL3KGTMB7OuNAX69GNDOpo8YQbGVHMGwNF63sQO8vsVSI6W99pvHSwT3xQ3L5fs81idRgztNEqYW0x+BgqQTUWCDJsDcccl4Bh6hOnZkgAJUT0CzHCIhmCSf/ZrumOm8ZfCmLj7wZVyI7JB2IYRDNKUVI729ZLoC4Bn6bBKPUZaiSDYhO6zwhSoq9CkyH3aYyX3KtirCbAr4QpJiqeZg/qt/s01qJ0nb+Za7O+w69YfyJW6SQLCKxWq4zF52XQ97z8P3iEczzLwF32I9CD2eKEIUgDbPPZcYaTGPw0TvZO7L0QdjOpmb1P2PpVyQWqF3tx1uPeZD+x1DCxcnQxSioWS+YJmqT+Ub22O75u59Bd5G8fJF1yFOa5+SuZucAiq6+Bk9or6rvvCFR9aRF4MxxgtqdhN/KGCtUiU4yIuliZCZydUYqwppBnQ0gK3Yy4fvjGs+9jZSv+R9vgoFKMq0rtcMD2xPkypHRuYRn/yG27e9D0OPPSI9+4+kmLnG1q1msSHT6ZzBB7wFbSvDVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the pre-fault memory test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/pre_fault_memory_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 3b2c4179d42ee..7b7352487fe12 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -187,7 +187,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 				    TEST_NPAGES, private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
-	if (private)
+	if (!kvm_has_gmem_attributes && private)
 		vm_mem_set_private(vm, gpa, TEST_SIZE, 0);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);

-- 
2.53.0.1018.g2bb0e51243-goog


