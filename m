Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0698D10AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705516B00B2; Thu, 26 Mar 2026 19:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC976B00B3; Thu, 26 Mar 2026 19:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2C26B00B4; Thu, 26 Mar 2026 19:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1496B00B2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AD3C5DA2B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:04 +0000 (UTC)
X-FDA: 84589827168.29.A7F880D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53397C0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GSADn2fN;
	spf=pass (imf10.hostedemail.com: domain of 3HMPFaQsKCA8przt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HMPFaQsKCA8przt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDbojp2aZv00FIsDRORjdXTSkhyjR06hadNHaz3T5HI=;
	b=42GmUzZGxRqCHh0taMGc/Vkw61z4hj9OaqjmHEgPNHiami545Jt7ZY+hTIHDey3wmO5+eG
	NtA5I08oOipUWVm4MoBNrugbSs+Z3SgNMLYl4boT/2+r4SL0JB9OQhRn8wPcyt5tGxNznc
	+6eBexZvVS6xDg3d3AJbLgzVOQaTifE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GSADn2fN;
	spf=pass (imf10.hostedemail.com: domain of 3HMPFaQsKCA8przt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HMPFaQsKCA8przt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568222; a=rsa-sha256;
	cv=none;
	b=6JJMX2HeUwptMEq7txUtZrF+W/e5KyVaJ6tAe3ulS5uaFx7M/dvV8yqyKeQEsIXNej6jmr
	vT5bfnGO5aoPWo5Mia+e7IPkViXguwCw4xU/WaruPsR+qLSDtcDXl9QTu+nLc2YFl6demR
	CEopO4Vmt67AQdBksADZnVn8E8uPYPk=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c714cb65eso1240041b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568221; x=1775173021; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDbojp2aZv00FIsDRORjdXTSkhyjR06hadNHaz3T5HI=;
        b=GSADn2fN+tGOJTFRkQYDyX4z1IWBTUShB5SrvL1yPrYWSFuP8BiemTdkBWtFZwJvw7
         CBMMBeaXO7bN4yeBGpoeJvILnlwqyDx+DOYq6FWbJazTaqT/RKaJnWH2fThTheBH4V46
         TLHA+o/7/iBx9gRo2lQuX1z2avuc756tewakChQVGk+0X0Qw7EBNcxyULXFtWwvKUc8o
         4rA+UIJmviG5mXd5dL/W62tQIpD8gZqkHzGLV73p0qM1eNHf6Ca7fq1835lLNLXG8i6B
         kpTA9e8TEDUyTFyk3XMufQ+20fswBiJ7q+hN/Ck8ef9GtoOSIW20XzYNPne2TVKWDfZt
         Qn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568221; x=1775173021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDbojp2aZv00FIsDRORjdXTSkhyjR06hadNHaz3T5HI=;
        b=Udl+N8KLW7UDNJIDD6SfMhj28B/Ta46mqflvvZsgqKLUv87JnYIJI5o0oQefaHKS57
         x3Pw1cM6BLZH4KM205c+o9yelHeKwXka+1UptdZqwCfd88d4JbyPg26RqJnae06V3U+f
         QGldVKpYP3WuQOBP6hNrS4JyZzS0LKftQ1jt4nqTI+NwrFz/0XTEd7KCwMSAcpez+jkZ
         vKArTwLNlFWJjd46APDcZgnzUrHvAMDHypcexiFRrONgDX66gpDOeX80SuOgAvORVD7I
         vc1dFOA/GTbEbTUvxsIUiNosDZwy0bQjuCjxB5MN9X+yf5aCq4BunAGumh+V9yI8sW3U
         w0ng==
X-Forwarded-Encrypted: i=1; AJvYcCXJSSRlG33COW2OOdxWzdhYV0nKINjB4Q0njdfKtCWkQbvroQcB3+5NYMiazarxxGfMJdVvMbmLGw==@kvack.org
X-Gm-Message-State: AOJu0YzRwWHKs531dMPiAiccHncBzVjFQalD9Ynh8s8znJy2tz8QjxFO
	wakY09m9UspjN4uHnvfnhgr5u4URqTcX3XOPd8DB38zmvgVwUcDQk7NXDPUBiw0ZnFnexrk/3W7
	nm5pKFhkmj7hgoQYYpDKEWKMzPA==
X-Received: from pfnj5.prod.google.com ([2002:aa7:83c5:0:b0:82c:649d:baf4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9090:b0:82c:6cbe:7935 with SMTP id d2e1a72fcca58-82c95ee4b93mr291131b3a.28.1774568220675;
 Thu, 26 Mar 2026 16:37:00 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:39 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <5f3dc762b9f08c1c398027e2ff4863ab46c3c04d.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 1/6] KVM: selftests: Initialize guest_memfd with INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com, Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 53397C0002
X-Stat-Signature: u6d8pp793gqqyk3ggxibm1z6fnqrxkbt
X-Rspamd-Server: rspam06
X-HE-Tag: 1774568222-773975
X-HE-Meta: U2FsdGVkX1/ud3KMLx+zz17cmvtjLalVrkhspy4rfVK0P5+Anz+E3Ic7Or0PnE0W0KwJVyWIoTevgTiPt2I/C4AcSvAN1pv72Ijsa7rTuTfYRd5eWt2Axid/YkpepZXuZ+iDoc4TOv+HnwnbaMPnAA9zi/0uFcQprilNGdxZKwfzMLN80IhP4vLL2A1hww7Nku1dHZtzXjnvAAuZ5+OHuBi3+Poo+UhuHTWRcOw+Inwt1IqUpNmpocAPDEkwsql3GaawdGxxV9eScOIV7PZM8cvipm0Sts9vx18P6slEGE6kVNjWSdULJlq+eQ7z/vwSzdC6+xXj6KU1YDUc1MFdXPNPwRJmvGILuQ9ZI3CqJzJyiZNpah1fiMZnwuHitUIKJ9KUxH4cS/M8EDuBvTqYd/xK6STUzkJvM09ntPPiS36S0fpEKXd3wiRjiuGqNfqnsfC1+Kg/6WyoeYp6l6eGOUr4qiqRaPXVsoi+GnZBcUwiUrOWde10SOe551Pa6Qx7e1gcYRAsdBSnNXW+iek4WIFYtLys3hTJI19eBbGdhVdzybvibm7aLEkc0mWJXXxCpUKTrgysi9l/gd7pj14A+RDvsfpFbr/MVXVrcbJc3zHOCvw7vJz7fj+1i/9hCh/r8uEnpnxglAvHOdSjqQZDhyiBO7kdRrqzX50mKEhbp/HWFt4vMD1MTw6wYPE5O2mxkm3mKKfN+RD1Sssxon4X1OrXM0fHRGAgG8ubN1QsInQbIDSnMBPuNSF5D+PUc72YRs9F8vHEeNR8EI8Sxiroit7ndGZGVmOl3/xMh+yIKoG5IG6seway8xum0sX7ulPY4yv+cHcWhrjaZiREwo7+0Fn3Won1mt94ldcNDRmFLgO4xKEbu706P+zfBQ1mH3RHbMMlHSsmT1T3rstwk0b29fZ5PP1gwODclWGtpPoOs4tU5/B2tZpFRWxP6Ie8cfIhJS9SNBvF88f1dthwgx0
 EAq4mMUK
 6l0Z2g56+8nFMbOs3ys3Fd2tzzsSzx3NVgGlWYYdd1mYOFdlh8vDb1uK3enpN684nhgkkt/SvBC/5ESXHtehCtM9U5GfVqBc/hdfQBy42huEcWtrYr9gAk0LS0cW76IkCZfLzG4Cg9PuRz+LkS2PnjmM6axJCMkPpDxJdq2DWlON/dKJdUdTunP8R/A7JpBMs7sqkweZsZoTzPWmzrzmsAs6nmn32G61Lz7uZzkntf99EVn0pYXIi3ejAmETU4Gs2RaHsknqkCwi6Vh7B3kAu0mn7Ufp44SMwjm6giqO345SmJvBvSutSheIVCDwkc8Y58TfNo0s0qH+CrksL/WXpoW6L6g4qAFpqgo+PC1mJZQlBzLYneyRz9Clq9E9P00ghqbGRmeKy4Io4z9/5DKd8idWVDckjWMWU0G6PvJKEqh/FsPzVs9dUrTCoLr0TR5IDRPAsLFORvnoH1DwcaQUjWGUT0fZ/FN9/BNxvPOspuijt7ANNSEoicO42mXRoScbQJshg4iEW6wkJgDNJDF56jEEVchtksBHJ3DJpMRk6iHwltNOEEa0UpMCTnyptan8KIVQiIfmSg5i5ZA+jfLLpiuUJ5Mz0LIca4dqcZQFXF5pn6gFtYgCT0UVNRr32xce09blD1fvy9RSlSm94LVYaYOsVX8OC798sfTw/Mim8eJSN53n4oIUObN3OQEw5R+8ghd9D2j2eeAjBbfIjl1ji+rxNow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize guest_memfd with INIT_SHARED for VM types that require
guest_memfd.

Memory in the first memslot is used by the selftest framework to load
code, page tables, interrupt descriptor tables, and basically everything
the selftest needs to run. The selftest framework sets all of these up
assuming that the memory in the memslot can be written to from the
host. Align with that behavior by initializing guest_memfd as shared so
that all the writes from the host are permitted.

guest_memfd memory can later be marked private if necessary by CoCo
platform-specific initialization functions.

Suggested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index eaa5a1afa1d9b..68241e458807a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -483,8 +483,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 {
 	uint64_t nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	enum vm_mem_backing_src_type src_type;
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int i, flags;
 
 	kvm_set_files_rlimit(nr_runnable_vcpus);
@@ -502,7 +504,15 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	if (is_guest_memfd_required(shape))
 		flags |= KVM_MEM_GUEST_MEMFD;
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, flags);
+	gmem_flags = 0;
+	src_type = VM_MEM_SRC_ANONYMOUS;
+	if (is_guest_memfd_required(shape) && kvm_has_gmem_attributes) {
+		src_type = VM_MEM_SRC_SHMEM;
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	}
+
+	vm_mem_add(vm, src_type, 0, 0, nr_pages, flags, -1, 0, gmem_flags);
+
 	for (i = 0; i < NR_MEM_REGIONS; i++)
 		vm->memslots[i] = 0;
 
-- 
2.53.0.1018.g2bb0e51243-goog


