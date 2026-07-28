Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0177C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507E66B00A6; Tue, 28 Jul 2026 08:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B80C6B00A7; Tue, 28 Jul 2026 08:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE486B00A9; Tue, 28 Jul 2026 08:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F03366B00A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64A05C0320
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:55 +0000 (UTC)
X-FDA: 85038071790.18.F54132F
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id A60C1100005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pX2YsiTt;
	spf=pass (imf14.hostedemail.com: domain of 3h5xoagkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3h5xoagkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARgzZjHeTdBuB8exqJqKuaM+KX+IhgDD0EDGHp8wJgQ=;
	b=z0qjzG/TtXC/URvNRM5DbwhkREEEjvz9uWzifNrZog4hd1CU+1z4ZnUdZjKU4fsnmB4oYw
	81WVBurSZmsMr/msAb1buY9ri4AK5m3L6bcDBSMto9AMxGv9XFpaEA46bBTRlVEnScWkjw
	lRomwKmmz0LRmCeZHx5rFgJSatU4+jI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pX2YsiTt;
	spf=pass (imf14.hostedemail.com: domain of 3h5xoagkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3h5xoagkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240713;
	b=T2ezIFAS2UUNqifIESVfy/ZXlfQCZsqbaPZtSywTslU1PNS/vc56G7rJzGx0NWgWSwvZBn
	+58vH0ULy7/Ooo+ccxNjtPQB+P9PGojfhkLk+ynl6XOkiq5gs+ib3YLg68RKZl4HC2roP5
	bgRcZmLUAC+a1qbnUNxPvvWgrbwkFdw=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15e82278cbso185753766b.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240712; x=1785845512; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARgzZjHeTdBuB8exqJqKuaM+KX+IhgDD0EDGHp8wJgQ=;
        b=pX2YsiTt1FqA/8ij3L+9JOalg/xl+Ls3ro8BbS/UBhsLpcIMcsImBBrcoqggYhk9Nx
         28f+Jdq/Fi+xZnYjTfZRsNprAQbQszdKYbOvVQnwaRhwpdiu426t7lytc5Yb+w9CIJuI
         Gc/af0Z5xBONk+YHqOUbin/ea9C9+xpLhKdS426dZJ2z9T/iHE/pY0wuLBivf9BLfJEI
         T5YabYKFxsMPq9bpKNvUWbBPc58AOrlt9aPdQ+bpK229Nglfr3iBWm5gueMHPHiKJGyc
         n3oVwZmz5D7Uyt48v1dYHQxcGfJV/aQjWPcMP1B2pOlnBga4MnX7UzMwT5/a2zp3vlxO
         e+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240712; x=1785845512;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ARgzZjHeTdBuB8exqJqKuaM+KX+IhgDD0EDGHp8wJgQ=;
        b=cssaJ2K2Nio4rp+1h4CTmDaWVwJXzfduGG9yNYVvjYNSVY464F+FuBW2Nr8Yh8bWAt
         JrEXo9K2lb71gCDseTGhWbIGsP54hs2KrSlfrPfbqz+OuvQXQ9Je9IdReAN6JoDRQQQG
         lKODpU/eKXfx3olSC8ReAFkAmY8DARESzAlfcaAR4Kcrb5ytWl9luZfxfbzO3Xp0vB/j
         pFlJlK0muZNjCAatBJILGks3Y/kPzO4mxY9RWF5e4MQQhbnuVw5JhWY8KAEIqFYVMaDx
         MmHFCcab/0BBpX/s/FgIllsQRsOZXUppahDsYGieanlCiV3qxApavZT3xqz9J12CUTB1
         zTig==
X-Forwarded-Encrypted: i=1; AHgh+RoTZmxjis4l1YciLbASkY6O5wY7xFOcJEQ8UNkhBQb5fsmC06z17ZEkgvdGw8gk5goSPL7fPNz82A==@kvack.org
X-Gm-Message-State: AOJu0YwLqJ+y2jinY6TqRRD3cIJv3H+fHS+4pUgt/xidbwBpVdVSW3ph
	R/L+pf/VgZ63zfHdO+HbEwp1ShnzsUkopAIr2+C/Ozd5DV0CDTySh6miX0BmC9BcXHH9zTxUihZ
	QWO2DawYpCmat2TgaTw==
X-Received: from ejjj6-n1.prod.google.com ([2002:a05:6938:a086:10b0:c15:be99:e164])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6938:a087:20b0:c16:3187:997e with SMTP id a640c23a62f3a-c1f71d61504mr70847266b.7.1785240711384;
 Tue, 28 Jul 2026 05:11:51 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:36 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-10-tarunsahu@google.com>
Subject: [PATCH v4 09/11] docs: liveupdate: Add documentation for VM and
 guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A60C1100005
X-Rspam-User: 
X-Stat-Signature: cgtda9u8op73ey4ec4oqaqpiaaskba93
X-Rspamd-Server: rspam04
X-HE-Tag: 1785240713-335736
X-HE-Meta: U2FsdGVkX1+zZzn62LKN7LiYWbquba7cSOCz/qX5ithMXgXUALzKMMSqizsPvh0wyIpyDXXb/8Wssv7x/DmrtoEAZDv9ouGygyCV5pOshSrc6SONlAmf53UP697zQ82gXhZx33nkNLeXOhx49gScxhaB5ofSfsdEchAr8NIJiU/ljrJdxkca3tt1aeZ7zbhT+Ne5eTlx93yVCJfbbjcoMtiDUiGpBGGzyp0SJi8PvydU8KT8jvGAR3ifPz1APZzzqJOcEKQmpLcc/72Qi5QQs+RmU0R536PtRtHUJDBEqyGl9qC1oS/kRvnYDrwf3I/LHtZXMrXv0nIwqAW7XnCDuNGXcTZ9hVbTYPf1pp2RkqFTBQ1xNRvKtNL2UiiO3ml0tWcvWH849p4TX7ftxoeSmwSh4uwcG5DXHAvVy3DY0+gPzJ0Wu7j7ggR9gXrLy0Uo5rsuCPB/GiKhzkjC/3qjU2UrII1oBKATGwshRlYrT71qKbTmy4mgs2/vSy+WLpue4yU8D8pD/qcuGEB3SK002RKw/BNrJ68tOAN/fcvxX4iA3oP0nOimRgfmX2lDzeteYQrONZ2cBhiee6awyiehyfnRJYoQXbvgwNyGsgNZizxntAlb0xkadi1K7iakVQS30SZPmUlMZW/xGXGPB/BAyVoabNrcsXtprLiYdgp3BVIUxEtnsjYAk/1SHqtbj2zey6I9XCFMIcq9a0+VTO0ecCY9KmrhhJRU8ohOYjivHakihd8xClk6jhb6DPjXfpft+N8Ptb/7b8gRnTTE9xah4M80SkimBPZAK6n8ciCNJlXN1zaFpZ1QTLi5rmm9T+143xGJ7Oxuc6FM4huJIQaRmfR0ts4WSyDezGR7hyySCKxch9suBggcBmwoBtEROmaX/Kse0MVXIAmnCK5uNR9eSnfO9OUS5Qu/Hh5DhTPeuqtioJjyso6i93tV2qWhIpIqfNhb8K7n/5H1Cl316Zg
 Cx5Ymxuz
 1JnK1iJ3fKrTZC0tWyzQNt/tqK0QJIynY4K3I1Wd0IMr8jBV982aJNHdEyLqNthmK9C6d7AtS5kphbKgm7ls3/gqhQZYC4UWRyYWGscyE2VcF9zGsRACSe0IOEEOgInN3HnAMraJGps+GOgcHUc8pRJp4bB/1SXg+bCziBmO/YzsNzt4rO+fJmKYp9PaEk0U1U8YOCqAf9zCD1M2AgbnTwUdydm1uHygScVT2gVCMvpciWwAC99y8dLd8m5Vr/qJIfDXNK0/8w/7Qu1Dueix1PbdztHvSIB800SxI/5sBuBWmZ9AMgyDxulN9jeGRGjJu8UJiKrWGJOLod9DCdLwBho8/Jqe+WiFWPc+9EeYZdjLGbOFjQ2q5YDPmrgFKgm7//2bVLu6dsKeebQKFwSMFKJHEVSkKPzOv0NBLSQ+acChY6Sxfg6jnOkfDZpJXIjroORqGE/ZAAPhswLnplbVw/u4kbw6EJzAsyaqYnVsRNS16c/kmm7eB/vM1+Dz2H+UmCcJaqDHp6DHchrGzcnbaBU//Fwoucofqgu32khvjwliZnUtV5AykgB2BLXqW7aZmLmkHobETV9MktGW6HcCAEl7xlWbwquMuS1i4VZf5NgX4rS/amthOSZHVBv6W4E6vDN0itdltYZo4YWDC8i5a+3FVERnNGhToro0jT8Hw7dK4bRGyvSd2mcoPOjPDPA7QMUvBSV6EfZkreOh7CWVm/Uuxjf2abqR5iDE0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Documentation/liveupdate/vmm.rst detailing VMM requirements, scope,
ordering constraints, and kernel-doc inclusions for KVM VM and
guest_memfd preservation via Live Update Orchestrator (LUO).

Also update Documentation/core-api/liveupdate.rst and MAINTAINERS.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 Documentation/core-api/liveupdate.rst |   1 +
 Documentation/liveupdate/vmm.rst      | 107 ++++++++++++++++++++++++++
 MAINTAINERS                           |   1 +
 3 files changed, 109 insertions(+)
 create mode 100644 Documentation/liveupdate/vmm.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..bac58a363151 100644
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
index 000000000000..b8e8fb2b63c2
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
+   At this time only fully shared guest_memfd is supported. Any system that
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
+NOTE: Before Initiating the preservation/retrieval, it is necessary to make
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
index 8db8bb448b23..c032f9a0451b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14548,6 +14548,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/liveupdate/vmm.rst
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
-- 
2.55.0.229.g6434b31f56-goog


