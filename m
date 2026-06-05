Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EC0CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6476B00A2; Fri,  5 Jun 2026 13:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60856B00A3; Fri,  5 Jun 2026 13:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9D16B00A4; Fri,  5 Jun 2026 13:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 840846B00A2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3639A16109B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:54 +0000 (UTC)
X-FDA: 84846493788.27.A87043E
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A3D0100004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8lX2vt7;
	spf=pass (imf14.hostedemail.com: domain of 3ogIjagkKCIs8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3ogIjagkKCIs8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBqu7gqATn/ePsgOW55ydXsXkiRj2gt82F6mXc6KPbw=;
	b=2RfEWL08dnnJal0/bsMjx7s/d8r29fb8Sk3dDjApyB4Rl2vu3kyQi6PolHNhRFDxfoUX6y
	GIUD7vZjsdpTlTy78VDt+hPM2Vp7dRnshi2nqcvPFs4ci+1RPjhi8JAYXTBim+7clnQ9NP
	27iAKa4kjjXr5kaNqnJfwaDRy6LD4CY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8lX2vt7;
	spf=pass (imf14.hostedemail.com: domain of 3ogIjagkKCIs8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3ogIjagkKCIs8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679332;
	b=K7HO/3VUNJ6Lze6Xa9WhrsCRCFQpbXLK4trfUgPl4LT0iX339O2i+T6benMooCjS+rtVqv
	fN1LBwWKkd76gV2DCoJTk+gTMHlmKYwuQHmZ81gEW0Q9d98DcWGph8+lTU8SbTFVxrZQSx
	Ij4UV01FZfpW5wzjHnJGoqAL17cBmYk=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-beba94353acso222693766b.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679331; x=1781284131; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wBqu7gqATn/ePsgOW55ydXsXkiRj2gt82F6mXc6KPbw=;
        b=d8lX2vt7cxyCHPxalXUyrm7CggRxnKhfNTpP5ibzuvWzazvNk/9EFpn4aU94GqFDYH
         OJvKsbqdM25atWbWAv0bjfnM/ELc5Z7/duvhAopINQon+QXrXrMTOjgt6vBmPVvGlKso
         iLpSN3TWG/3VsCWVYloZLy9Am2qKXkw4zpW1qOiOCidVEmu1F31WshCs+AnOtS0L5vQM
         JAfCPwmxQUTwQXeeybD254+hHr6bXOUAKADOMDbDNyg1cRPMZ8Aea1C4lqPeW8UrfRJ1
         RFPYPoJVERKzRKYqpMtLYsKaWlU4ycnvkZ/SRZVIJuwtj+o9ASlhKmEkr8mljvrq4wim
         zlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679331; x=1781284131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBqu7gqATn/ePsgOW55ydXsXkiRj2gt82F6mXc6KPbw=;
        b=Qyvt4xaO2is+zJfFWk4E6/QZERH+shgl6t/haEG0fdX2OK6Ni4x+lVoT2cHaz/SLqq
         BiC+QytPaprmMAfyN1PtZPvaNqp6hZKWZ2ewCez7OV5koFUJvoruBo709PxvBPc1K4A1
         Tg66Z8pyR+6ojmkZVvEQ4JiZzLdJuXwtO+NYJyJuHMy2Lsy9Z7duXwDpXwPO7OG8VEes
         Si/V9lj3IDta2Chwmp5QPtnAiyw2qr4o38ilZgvILr1+SUZsmwl7mgC963VeGTcFzWoR
         hbiTAjnTea1bh1tBikIsXQwtUScFAFMzqaWK+O5EvB7kACnRFWP87wBWiXvKUPEhFzuL
         Xyug==
X-Forwarded-Encrypted: i=1; AFNElJ/yRRBI7c7sN28Yqb5SQ4g+/3HgAruTEtGCrGhooxT328kW7RPsMqEQeSkJd90PvLbfzfayonHqSA==@kvack.org
X-Gm-Message-State: AOJu0YwVyV9Uk+OiLmeN/WPK1oKijPea/OZEG+t5pYZrysfsVetnS9X5
	opFxiAJDUzF5tgx8aTWrO/Hz6+tlPrxMQjtsmLzTr069MpPmxonbz4ivNo1a9Srh6ZoWTwHmwY5
	WF8qn26DWlwQU1zmE2A==
X-Received: from edpu11.prod.google.com ([2002:a50:eacb:0:b0:686:db44:c93])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e20:b0:bd9:2b46:99b0 with SMTP id a640c23a62f3a-bf37330647dmr249281566b.49.1780679330530;
 Fri, 05 Jun 2026 10:08:50 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:33 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <f9430aa65709131d89d9d6be8b6e8aff4185bd63.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 08/10] docs: add documentation for guest_memfd
 preservation via LUO
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A3D0100004
X-Stat-Signature: j8btj46sopphsh4bed98artq9emjdbsz
X-Rspam-User: 
X-HE-Tag: 1780679332-406957
X-HE-Meta: U2FsdGVkX19GziyIq0HHGEbNzUPEzmbJIHXb/q5IxTVm+3q55V45GHRB2jgEF4hN5W5JDuvYxKJdpmYX+z/WWuuzBc9R9dtkrwa+kDnHXNTmK//dsKLMJW2eXP9KRWBQm264ROcioOPxL9CfyN9j0EdUpq7KdhZ5k1x0eqZR62fIIjKtSj3J/CoWcGR2IIiqpUoFCHSqHVIr7T5ub9N7tafEwVmel+wentSZv6GjJ5MQN7pG1lLtxGeC1lIWoqCq6ZaSrmbi/Q1o19EmzqHLdpUJAm2aQEbkpyppWVHTpt1WG5lBWmeoLe6o3e2B1y4CY7btBHF0C/CCxpDdAAX3yOw7ufyDei3Qv05qHretNw4yoMpcpUH5sAoRVSDKOfjj++rdpL69mD39YGIIolkkCwZlC5rg9RDNS5a2VEkTw8/fF5Pse8Msz5ztjiT4VD8lnvExphm/zdAWkLY6zGiBAysa125nT9AazJbr10Yf+15xXT7KBrGqlSoT2YLV37ZVeAy1CxkYj9nQ98fHH73pVyzPetkUIUMSw4kv2GtINBOxpA7CrMriRAfpXewEQpSPNgu3eaAYrj5KKuGufWny3M1i2WrrFeARfK0SHuFgpgYxFXhoareZ/T2ZqPjZxw8bTJefzTSHpd6yKObDq+Cp9qh6+OOH0Oi45fHShA0WtwPBJ7VygzqfyR0laOM+23mURjALVTuIEC+8iFCtToFEDbQSsIptl1rhRzetAGdyHHPNLoZWxUv0dwJoyyz1gdRQ6cUXWeg9Ta4VzBvZiFKPLB8T3tHNu2B6kD1QxDAMWZajzYKwSHjwQB1qC/aTpyKYblzIvT2Trpc60o7OIjz4aoEk+Rxykam7jutffY15uRaGsD9evCqRhjcW0z/j/N4J9QUQGN25mblSo7oHEHN0C2e/RWy6FB1qFptEgaZlSLim8PivPOD8yJSnlAsgny/T2JzHwzhd8NsWNk+eOHk
 vrFHX1DX
 dMHymF6MpfO09yP9uYiNNVc/NEmcCqGVBh2lsSZyNaLVWBi+EDva+WebmlAEhPmrzG6HicHSOlN/Q29jrr43iFF5tGl+rJM3Umib4FikE1gwWtK8WAZNaIT1mGNjoQF53koSbRtAp3uUOvahs7m3UCvADvKNnqeFWRZLAyQYynopxNT5tWCyenygZaANh8x9ipHLOTQSSyt5+sSVdilKgcIENEh7Go9/0wYP2BplLY8oKyr8fOxE4bmvYCKq2No5aX0Y20M20kLBX9KXY8GRZLhMItceTRTG9gJwtBdVGosmvnpyRDClILiRG8/ewUXZYk00amPOnb9bgM7P5XS6+O12KJS19aNW8Isn07kOJ8E1CDTp4qDV5VGo3nqE7YNsRNNk3IuHaugNUe96QqOQAQdXg2hGyjxqHHCsC++IATYGKA0RNSqH8USYYyZTgnnr+H0s3yuxSRKqWXJDasE+M3BKPjvpkrecopsfX9M/KAZjlZb2VzVUZfrmXsnPlg+DY8zMs8GUtMfY5AGxlwkG39FBSKVWMC3JtN02uRk++JyYQozhp+LQ49g7F9+hBCJ0ALVfICSkCFvE4BDKoaz1DKIeSFcFiXLNChW7Jewkg2nDjkpdbcG93DB4cFpNfdorMil5UeFcOv6XKXJPoipgvyJERhpkjCi2kqcVnG7W/zgZZG8IHghfFq0eIgnNevMtzvyzD
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
 Documentation/liveupdate/vmm.rst      | 103 ++++++++++++++++++++++++++
 MAINTAINERS                           |   1 +
 3 files changed, 105 insertions(+)
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
index 000000000000..0cd487a0e1a6
--- /dev/null
+++ b/Documentation/liveupdate/vmm.rst
@@ -0,0 +1,103 @@
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
index 16cba790a84d..ca459d032712 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14418,6 +14418,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/liveupdate/vmm.rst
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
-- 
2.54.0.1032.g2f8565e1d1-goog


