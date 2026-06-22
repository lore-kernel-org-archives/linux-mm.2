Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33707CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D806B0099; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4B16B009D; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21F06B009E; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2E56B0099
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E5134024F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:12 +0000 (UTC)
X-FDA: 84908436144.18.7AD99D2
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7667214000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rNVNg+nt;
	spf=pass (imf23.hostedemail.com: domain of 3pIM5agkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pIM5agkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154150;
	b=6g98kKauSfOA8qRDUqCgcDsXtPWPH/6DhKQE2nWSQ0KOUJlnUpcUhB7zCBo+JTG+u7Gjti
	kuWqt5Of3mWFtZHJdWBzST0XyeMLOGOA9LNDLOki801gMnvtTpaKqmW0rZk6Vf2AvoMlnb
	RcB54LTsbDkcX/P7qlB3TdewIr1oGfI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofu2helHDgwWpEtyPAHO+f27C99XXYOA9FQdc6q7UQo=;
	b=FtF4mRDUBtSFWH4WKRmY8Dj525z9z59Ji/o25whnOr42jCtTZ2AaYbgUfyPvwKTKetLlCr
	Kj2hz43Uft7pV7yuQSU2ogz/AGyz9Z1fWyywtcamRrV7dTzxV4NKEXMT6w1a0yUu9JOiqs
	dWuoV2ajhIUEj/GsWMChS9Py5te4JqM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rNVNg+nt;
	spf=pass (imf23.hostedemail.com: domain of 3pIM5agkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pIM5agkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6960fb32b73so4306083a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154149; x=1782758949; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ofu2helHDgwWpEtyPAHO+f27C99XXYOA9FQdc6q7UQo=;
        b=rNVNg+ntyvpFhNFqmcG4YlejrQRBZzG9hY7XVLoTEjddrMPgWytvChsFrKxmGfvyEh
         QFt0moDDbq1bInVSL6DPuHmFrqa9uFB7eterzVynrczgBKJNXMRv21Z4vlgtYOZ+mGkV
         2rzWWxg7AGJuAGQEF5rE9A8QfbxHChSajasv2LhO+ihoOt2Mv3upHYzQxE2EP2LA6JZE
         OQkAh8EdVjf78vRGfjM5xhFMA9SlLIfHRpGY0R3Re3RPSV/1oSjJW5tJ0Le7X4fKvrlw
         GP2kb7MZmVwF9PWYRQAqZNEdE3JtrlUwHkgJTPbHfePKpqHgY/9LCn3BluyKSFGkrb/D
         LNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154149; x=1782758949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ofu2helHDgwWpEtyPAHO+f27C99XXYOA9FQdc6q7UQo=;
        b=o0KWrHkmGRzoMU/krh2UdVJJrdk2mQN2jFIe2YI2+/LELm2X1YnCSBEFrxZzY8uCM6
         iSska+q3/MXdoJFA8qRQvTISBCSfI6PhANNsVrhZLTjZnOtLrgDZwMr01BYGPI1Wo+cv
         aqemoslff8riLfqDmpjyrkCUsVC+6B7qMXJ+nvKUMCDoxR3Xm38Wf2DDB+j9lgOjfiaS
         Dg+N/6fMKfmi8QWuuGXjEIkoov/krO2ZLh7UasbdovYxOqt/Zo7z90T3NJt4v5mIBiAl
         MqN8OMEWqxLqhhzu8DX3qM6ARLBedWv+zM6YjoAMT0DcsIMubdH3qrQgS6lLDq+ZV+Om
         3efA==
X-Forwarded-Encrypted: i=1; AFNElJ8N7ZUUzL/mkhfP63x0pycvG32rAtAbfWYY5SHU2N4+eU77KctPDAJCfbLADTgw32k8/Uzgrb9yoQ==@kvack.org
X-Gm-Message-State: AOJu0YxDQG3cRKnNUjMEf+gRRvm+Y713HFcnRPj1CkS3m/Lqn9K5a699
	HaKIL3Sv7q46uRUvL3sA0maiFcn+4hwGCcBKmKNpzhB64i9cOVHOBVomQmXKV+OLBOD5+RLXw0e
	apI0DqYM2PJx5vrpB9g==
X-Received: from edaa20.prod.google.com ([2002:a05:6402:24d4:b0:697:c28b:9d89])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:358e:b0:697:ad7f:58dc with SMTP id 4fb4d7f45d1cf-697ad7f5a8cmr2848079a12.17.1782154148645;
 Mon, 22 Jun 2026 11:49:08 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:49 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-8-tarunsahu@google.com>
Subject: [PATCH v3 7/9] docs: add documentation for guest_memfd preservation
 via LUO
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: h9yh9asx1fktkkib4n6g8j3sdakfxuun
X-Rspamd-Queue-Id: 7667214000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782154150-943057
X-HE-Meta: U2FsdGVkX186K3nytmc6FxgM04ejnfnEQ+YsWDjs2uNmbn9NZAnwBdA8Ur3qVhz6YQNGNxIDOs+t5kz7Mk1oXPVCGWvxjZGyQm1zJhPoIxj0lMM3V14ZfxvTo4UA/kf7Wxc77pQB88Tp2zy5EaEEnPmUm5PQyotYdR/VfhNNGDyayPVsZHalffm2uuIzuRLhs3GwGuJTasm4XhvbIgkJ0yfnJqiJBX+LD0dT4ypMze5a4F3fZpfAwGzLVvk4wJzoHJGT4q6R72TdkU4bUz3QHv1suuSVGamfGUbBVla3tJ2lj2fWElMZbmANVL3CEsgk0xVg7dvu/Q7pjETMLvUS0MoR7UyOJ2WD/vzwRCTdJqna8+4DwLndG8gmdIy77px5pDTGoSSErT+6n3CcsVuJlk8+MWm2FtKt3a/K8CePTWQD/ga6NydTVvIMdIwx0+ho6YzML/DHNRKEYqNb27QsjC79LW6+3ZelRTszmoeQXcmKWULZkTlMeLJQVMws+sd1JySXn1oqyKYc1GeXvOoNWYRkNeoi3TotWmV2lijZGdYM+VDD9w7rgXDpphvNPLZl1JurV220QktLR0A9W9iDQP/crqVRvV+mCFnOIaW60kT11todXK9qzfoQ4UdA8s4DJ7zdhloS7+TKJicTDZMLybmufcV1Xb14hmhXySeUtHFggeodiAKR52ZIcLe66APpPqEVUMkpsKDunE88EIaTY8Do5JtSvVZrJ1fc88ZD47pd1RJi/Rk+SJh+K7Z2zPZ1IyW++1bAwsjvT81iEfBOEijczIT67+GsnkcvilznFLZazAum+ZFSh/5v31NEj+7P9GaJrQUUXWFD6U4cEs8kTsICnsekYz4/O/5Q5o4Egip5zh5D/T94Y42fe+S5ZId7Ri6iAy24TsdztK2t5b+BJGtCnMStpIb8m92PHhigiLc3sVMNPTeW2KbPYWhkh8bnzlysEU5TfsTmXJwlqPP
 Lzk1+tts
 xJ2QjwO/7pcLoswEQcjn7L4KF2tO7+1EYhRDBCVFlG9x1wFjoRgFIotF/IcVXCZSO3noyqPba4d0KzmBECAot+HZJIHffziNFY+Xg+SwHapL+W2vV6y84bpSbv8BqzKaYDVcStJ7iedsyT7sfbTkx0/gQNvVL3zj/wteOIRzpy/p8gASZIHCYYRcNyczcIdmcde1xZYQ4Anh8K+R7sRGLmuydQJfaPufdGwRvKQDdutfWG7DoxkfU4ZREUVKkSKI0QfurMMMXG+MKf38C9tMl0MjxYzMcglUMDwW9P0Y0qJu1lPBNb5RyZ1UDL+Ed5AQZZErvp7UbGNtMCCbaIZfur6HQGg8f0i981pcIpOppwnLt6wd9jO/m9ddd1NEVoN0cx2Os9DtGtWxfOc68rKFEzskVuYzIHHsp8SPG4newj9sL2wivrDWNEgci52FgIJFDR6SdN5ylhMtrBtfKfNJP6tL7pS53GNtLVXkktFGdTbk874ayBgHFEM5Q8NnRNXXuoscUgLpMC1+D4xxUn/142bsgLDcBEHQPW5eZfmmMHtRyvgLzjphDnAW15vgi5AClocoq10vQuUU+05S5SaVtkt8CNIms1LLk05pzjUSkWueYA7c1Ue/DPnffhNmyTjlvFIqBtyon2j1w1Jgr7H7kX0aJy+K/N1JWgtF5YioeWQZ6sV5S5iqPm9Zb0/P1mQzg5cYA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation under the "Preserving file descriptors" section
of LUO's documentation.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 Documentation/core-api/liveupdate.rst |   1 +
 Documentation/liveupdate/vmm.rst      | 107 ++++++++++++++++++++++++++
 MAINTAINERS                           |   1 +
 virt/kvm/guest_memfd_luo.c            |   4 +-
 4 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/liveupdate/vmm.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0..bac58a3 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -34,6 +34,7 @@ The following types of file descriptors can be preserved
    :maxdepth: 1
 
    ../mm/memfd_preservation
+   ../liveupdate/vmm
 
 Public API
 ==========
diff --git a/Documentation/liveupdate/vmm.rst b/Documentation/liveupdate/vmm.rst
new file mode 100644
index 0000000..8353e23
--- /dev/null
+++ b/Documentation/liveupdate/vmm.rst
@@ -0,0 +1,107 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=============================
+VM & Guest_Memfd Preservation
+=============================
+
+.. kernel-doc:: virt/kvm/kvm_luo.c
+   :doc: KVM VM Preservation via LUO
+
+.. kernel-doc:: virt/kvm/guest_memfd_luo.c
+   :doc: Guest_Memfd Preservation via LUO
+
+VMM Instructions
+================
+
+This section describes the requirements, scope, conditions, and
+ordering constraints that a Virtual Machine Monitor (VMM) must adhere
+to for successful preservation and retrieval of guest_memfd files
+across a Live Update Orchestrator (LUO) sequence.
+
+Scope and Limitations
+---------------------
+
+At this stage, the scope of guest_memfd preservation is restricted to:
+
+1. **Fully Shared guest_memfd**:
+   This time only fully shared guest_memfd supported. Any system that
+   supports coco vm (which uses private guest_memfd), will not support
+   the preservation.
+
+2. **Standard Page Size**:
+   Only guest_memfd backed by standard page size (``PAGE_SIZE``,
+   order-0) pages is supported. Large/huge page backing (e.g.,
+   hugetlb guest_memfd) is not supported.
+
+Any Virtual Machine (VM) whose memory is fully backed by such
+guest_memfd files can be preserved across live update.
+
+VMM Actions and Conditions during Live Update
+---------------------------------------------
+
+During the live update sequence, the kernel introduces a *freezing*
+phase for the guest_memfd inode. Freezing prevents any modifications to
+the guest_memfd page cache. Specifically, once a guest_memfd mapping is
+frozen:
+
+- Any subsequent ``fallocate`` calls on the guest_memfd file descriptor
+  will fail and return ``-EPERM``.
+- Any new page faults (guest-side or host-userspace-side) that require
+  folio allocation will fail and return ``-EPERM``.
+
+To prevent vCPUs or VMM helper threads from failing due to these
+``-EPERM`` errors, the VMM must implement one of the following
+strategies:
+
+1. **Pause the VM (Recommended)**:
+   The VMM should pause/suspend all vCPUs before invoking the
+   preservation or freezing of the VM and guest_memfd files. This
+   ensures no new page faults or memory accesses can occur while the
+   guest_memfd is frozen.
+
+2. **Handle Fault Failures**:
+   If the VM is not paused, the VMM must be prepared to handle VM
+   exits or user page fault errors resulting from the ``-EPERM``
+   failures. The VMM must take appropriate action, such as
+   immediately pausing the VM, or aborting the live update sequence
+   (by tearing down or unpreserving the live update session).
+
+Preservation and Retrieval Ordering
+-----------------------------------
+
+Preservation Order
+~~~~~~~~~~~~~~~~~~
+
+There is no strict ordering requirement for initiating the
+preservation of the KVM VM file and the guest_memfd files; they are
+preserved independently. If kexec is triggered with guest_memfd
+preservation without preserving the vm file, kexec will fail.
+
+Retrieval Order
+~~~~~~~~~~~~~~~
+
+Similarly, there is no strict ordering required for retrieving the VM
+and guest_memfd files. Any file can be retrieved at any order.
+
+If guest_memfd file is retrieved and VM file is not retrieved, and
+luo_finish is called, then vm_file will be lost and guest_memfd file
+will be hanging around.
+
+NOTE: Before Initiating the preservation/retirval, it is necessary to make
+sure that the kvm module is loaded (/dev/kvm must be available).
+
+
+VM & Guest_Memfd Preservation ABI
+=================================
+
+.. kernel-doc:: include/linux/kho/abi/kvm.h
+   :doc: DOC: guest_memfd Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/kvm.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/userspace-api/liveupdate`
diff --git a/MAINTAINERS b/MAINTAINERS
index d1d699ce..e27b677 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14420,6 +14420,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/liveupdate/vmm.rst
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
diff --git a/virt/kvm/guest_memfd_luo.c b/virt/kvm/guest_memfd_luo.c
index c242b1d..8411fe8 100644
--- a/virt/kvm/guest_memfd_luo.c
+++ b/virt/kvm/guest_memfd_luo.c
@@ -119,11 +119,11 @@ static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, s
 	/*
 	 * Only Fully-shared guest_memfd preservation is supported
 	 */
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return 0;
 
 	/*
-	 * It makes sure that no memory can converted to private
+	 * It makes sure that no memory can be converted to private
 	 * even if it was initially fully shared (in-place conversions are
 	 * prevented).
 	 */
-- 
2.55.0.rc0.786.g65d90a0328-goog


