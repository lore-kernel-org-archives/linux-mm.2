Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF873FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F486B0111; Tue, 28 Apr 2026 19:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637826B0112; Tue, 28 Apr 2026 19:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DE36B0113; Tue, 28 Apr 2026 19:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 403EB6B0111
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:40:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 877071C16B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:34 +0000 (UTC)
X-FDA: 84709568748.29.4F49FB8
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9021A8000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a561psrK;
	spf=pass (imf30.hostedemail.com: domain of 3ykPxaQsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ykPxaQsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clSh7OBsCI0JhKUCKzkprD+sDtva2OSfrDX8pAze+SM=;
	b=wFOuDkQIrg+l21UQJzGpAdkGJntYD0fvvA5qY2MBqxvh+PG8Z7sKFB4p1bng1iBJLwj7eg
	lykGLNKctTSff5Vh0wGv87Twm44arA5KgUcE//bOGR2sfz6zo4R0Gqs+ZGli56P4iahCWD
	NUL6IJJD1Ynl6zAZmOv2Q/07oNnOqKo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a561psrK;
	spf=pass (imf30.hostedemail.com: domain of 3ykPxaQsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ykPxaQsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419212; a=rsa-sha256;
	cv=none;
	b=XYmQMMqjzl6SQ4z6wiHV7nAJGUAjAOvlNcsIftgXIC1RpEj2iDSFfjBjhNi3lrEQevZPfY
	3pltHWys7b3y2jFIPZRta6CWlIAaUO0QGWvjIjc0hgR3w4w2l2LVDM5RHEdSpMWVPLwwbv
	EQIZF1lG5r+lDJ4BxKQfPsNBfm4DGxg=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b79f4b35b7so61073415ad.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419211; x=1778024011; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clSh7OBsCI0JhKUCKzkprD+sDtva2OSfrDX8pAze+SM=;
        b=a561psrK8wZ6mQvFwg2U5kuawxDTPVqs+m8xf11/SsQ+sc5nESsP0EETPZakIGX+1A
         hI6+ZBqGMczBV8CfpJAG9/B2Q0XnG2Omevxz81e1v1fki96wFbyheSbTnshSiA9dnc1o
         r4/v/7dwWezby5sqbZsVd7j0PxOQWJicSl063QQ8a1qVh3LR71WIFSNdCzQnVLe2fykc
         twZcxTDFVQLxlYZy+MP4Z8/Y8mDYxtILtsMsxKn7t4rp0DZMQQphxWl1L4nPwVoDtSOQ
         5uw7O4xbOcZcKbjx82QYKLDKdL+UKi167ux/jS8hcHfXtJbS/DG2cz/S8zSt3s0BUF0N
         nv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419211; x=1778024011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clSh7OBsCI0JhKUCKzkprD+sDtva2OSfrDX8pAze+SM=;
        b=MSIzVWemhMIuKpO4rggFlIOxbyK5dy+kou9YkfR0DmvLcx2lIvfCptatefg4+C4nHC
         Bp/IBmfgkMaG5BBNsMaY0Wt7+NrDPdrp5faugJLXLZuHQTdGUHzn7MdDckIfIrfQ1lQr
         Sw2otZk6ImTKpMXXUlv4WaLfX9b4VBJFtwAPVeMP79ShESxsmSb3lV0aPIa6CGyjxlKU
         GPQbBtMWQz+iFudosf/CQVdj2DoV9xI6SETxHJRllyDlaGXgZ+5HhchQ5BTJ1sTjlLBu
         +RdWwief7kJOce7CHtL0FLapxsBXxgkW/FZ3m4sNNtapNnXNFmy6WUI0VCGEbOwV2tlJ
         hjxw==
X-Forwarded-Encrypted: i=1; AFNElJ/HLSzyqtQKfxVdSOVq0HcQqIendp5/3+tSOORoxKh5UY9/Di5ITbY7Df1n3++RB/65b7JwGXaBJg==@kvack.org
X-Gm-Message-State: AOJu0Ywml0cebZp75nGkNPm5HKEWqS4X1vaQwBVIkaKt5Kpwleq+TS2D
	siwxJoqz0DWvfzmIcs1XAN1caQ/lc4ipWADtRoTcuhRa//Y0MmIBU1pUBWMEXFK1Hp0VgGMy4Xv
	MF6/zMaaGTu2UMnoWThWnL1O9VQ==
X-Received: from plpn20.prod.google.com ([2002:a17:902:9694:b0:2b2:ec1e:c943])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c2f:b0:2b9:6453:389a with SMTP id d9443c01a7336-2b97c3cc0b3mr49885595ad.8.1777419210821;
 Tue, 28 Apr 2026 16:33:30 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:21 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <94c9e342215e6c88988d7aa62f3ba627eda34e94.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 1/6] KVM: selftests: Initialize guest_memfd with INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9021A8000B
X-Stat-Signature: gsx4zj6yb73epcmn1njuoa579b4r3xij
X-HE-Tag: 1777419212-841329
X-HE-Meta: U2FsdGVkX1+vKFfgBWXISfopysOjB/BemCQMiY7z27mAdQqjjcaRJXuVXq+YTuvv7fNxHmp1V5X6QhGRNfgzFyKmTqFC6CtncQgXtuW2tKL+HIo10dTiWttJsZcWcxhPWiZBd+XjwJPZzGRoyTPdBLMmrTftWDBY6YHK2O9Zm9KUtad7kMLNIpYrYUx1n4F0xm3KDXWc8ninguKpHyMBktLGZsnWh8j++1/iDjOX5wUUS051bho2Xwydek7QRdr2kqko/bG2MMCKWf81oI9vYesHHBIviCo7sIPpvZfk27xAsaElq5Tb7bK1kBYeh4CnGvDFUQiV+MzVBRuutMGoHpAERfnubPPsWWjaK/X6h+X2cOGh2dx1quGcRbVYSDnKR5zLWyPmgl/i2Sp81rw+XwF9T0n/fm+sdmXBOzJk9hQK438m142uJcV70ffgYRFeFmPAFssfpZvinBN3TFQFBJo3NQ9UfgD7QLakv8Ltst4rtVV59bXjzPrYV55HmsVS1q4+/RUVILAlo3+DgRAhfZ+FJDvgKUpof5s2BnG9IBu42StN14VVmq07diuVeS3Jc6aL47RaNEqlejIIPJOLZ8FVpjooE06r86MdVgpYu4eGsj6yUpK5oXwmZ9JYbDUnk5S5kXyf/UsT4/Z/RNerc3+8lXUs/5Pl+nPt4IjJUOiVZ8Nd3mDCK2GSNcjDJ1iYq5MOnj7xRv8GuF4VhX97k3lp4yal5Gj0Xs24QLGKjoWxftbBwZKax4m9yuq6mMXLoP58njzC1MTllyXxyb0QN6B9anqUjzufl4wV3MENWHwC9k0kzgsLRsrRfcIMKmaKFSjQp3HtsCrv4S4PORCwM/P0zxg2gEjP2fRerXnBWhoZpY7hnnFl3kD2StoktntiKNwSo/vA3htJ73pl4spym9itaLHIH+aGnMT6eP4A6RMN8p8ABjbv8tXJ/KUh7FC8AuPy0XQQYlBPgjQ//4A
 r6+egJVQ
 hTegGl7qFndY9q/heI2AsvKg/MuBTH3A//iwdp+4PwHoOKEGvHeY0bbcAHnRXe8y3BkdYDWtrauzZcYFFmo03kACjbM2q1es3Thdm7l9VjSFgihieqnQ+Xt0PcZDZMgKZGvRd0q80n3NodbEDG4s+n4ikC+/YVGOmVkFol+yB2YnHpkngxZ1WA7D66ppVkwoKAnu9N4yAR50SpT3rYsIBexB6DJMx1WcIEmk2T2giM6TMLgI7iWT713dbvsriZ+FNkXvBxDGTl0oCcsqWUkqM4UW+hwIS+Zac0g+4OsP8mw6rVxPRwFF/U3SHfDriwXKy9EhQ1NBdSNcxg7Oc1V+X0uUdGagXJgKMvdthzeEt0pA1e/gbu0FS6KIrpfx8ckj44eGJt7ulEi9OA7McAWFaNRMMuDnNCOzLNPECg1FY1hMCouMVtf5ByRkOTlNJ4nA+W1xQsIW9Ar8QHh1XoALewomxNLHzKKYBhHLCkXGoGrj5319PZVRR0Ino2J2knYW+7a4dLQUTl3s7O41UKF45Cmdy+l8q5IvxBejp5iihtbF1XykLNJMPupllbVHc7DjXXF0Fj1eyY3/fub2JzEXaffqkzFNOWraeVP7Btvov9Kr7pSwzSU9xaXtiqG2wfywzuVVY8eIzpJHshw0yG+y+wVh8pV3TG5fibaU7gl5N9IOcEsB/nixIhXg4oOxio64fijapdRBQe+DikVPibD+R//TT3hjbasNqOVmmb1z0rLTB6yhMQ0hMM1vRZdybNbgIUXQJ1+h6EaOXKFDRHVkMSswZvEyDlsVTFANTA0f/knRUxEP7czPbRsWBhQ==
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
index 216d6e037153c..3811aef8c98cd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -483,8 +483,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 {
 	u64 nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	enum vm_mem_backing_src_type src_type;
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int i, flags;
 
 	kvm_set_files_rlimit(nr_runnable_vcpus);
@@ -502,7 +504,15 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
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
2.54.0.545.g6539524ca2-goog


