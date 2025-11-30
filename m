Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F215ECFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DD56B000A; Sun, 30 Nov 2025 06:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7B46B000C; Sun, 30 Nov 2025 06:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB15B6B000D; Sun, 30 Nov 2025 06:18:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3E306B000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:18:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 778A1132541
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:23 +0000 (UTC)
X-FDA: 84167024886.22.AC06B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 219B7140014
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUtziVFw;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i7R8+9qMl8wh0X5wU6czbvLNsq7fHz+lMo4qPQRav9A=;
	b=PGEb4GVyh1oRB2qu9la4X4hp69ReFMsIGttl2NpSsLRldT2XtaeIEx3DxXOKX4vxGP+MaN
	vvSAQOKz3R0csTW2ZW/W01eF/DnyF0iiNTLxuBkJutt+r3yJtXJ2Ov7jL/m2kVbL2TJ8ns
	CsdYD6y4G9tcl0jcg/aa/0Ju+ncXZPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501502; a=rsa-sha256;
	cv=none;
	b=mB5o52sJweGofuaAA94tkHF+h/TyOlU5VK9vTINX58M1LowvDxBZiD3OfeLCEqxBXjUgCW
	6u6YdzboYf5+O2vlmCi00hzkvhqKNVEMJafOMthwrmZ0kXV99Q8qswDANjSUKbquZaBFye
	6eCrSttyyrP12SqJE0IRMBF225Er3q0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUtziVFw;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 362C260127;
	Sun, 30 Nov 2025 11:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9E7C4CEF8;
	Sun, 30 Nov 2025 11:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764501500;
	bh=QWyCUWNr5EiAGbEinbC1SqyvrF+pTj5s8nlr0+kSaV4=;
	h=From:To:Cc:Subject:Date:From;
	b=XUtziVFwxT+NlKvaS6WSYT+hiz0mrSRU2i7WVNjkPJridMQi1gJVaxfwESV5hKMLG
	 BN3/0ZxZ/2DXLu6KtyIAMR3OGP+BuHSB7mPzKRRbzKyPqJR8YmW7n/weFmExIqYmtd
	 7S3JsaPSzIUgMK9FlfeSl9MJQo32lLw65KrX4tiLtUyULE/RclDDkSu7WAu6Tv55J3
	 gf46siqJ5aWDVA7l8SrR6snvp0GwbHKUcRBMPamwN8p8iGNLcKkG/4XQ1p0ZejStcH
	 jf9uLE+kQcOwTjd9m8m1xzWcw4fqekafIhmzyolIu/YVxYX02l2rPQaNJa9U1vNIoc
	 pL0mfDDnUxd0A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 0/5] mm, kvm: add guest_memfd support for uffd minor faults
Date: Sun, 30 Nov 2025 13:18:07 +0200
Message-ID: <20251130111812.699259-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 219B7140014
X-Stat-Signature: 6o9pzk7qw9bp4cfiy9cr5xdi5stbxjeh
X-Rspam-User: 
X-HE-Tag: 1764501501-781517
X-HE-Meta: U2FsdGVkX1/EZb7sIdKScsN3WaJhCxDdCxoVoOZgDZOHxDK6F5IGTafx9/+o3jybbWx3/txJNYDE6UbPik4XKpD+BRyrXVDXj+YUItTwoodaML7h+0ZFPSW1lS7qtYSz9DaxYQPN0aSk8LVE1m17jzLosXPmub1h2ZLBNKU3ehaG8HiyZrL8+/Of6FgK/H8/aMTb4PEGMQenBowiO65M0sGFYvp325tvq+coIH2BwOi6Ryn8IA3ynvLBVxshE4ET4zQDFAzxd2mO+m3nhjTS1yOVKF+KSS0X30d/JXe3yWvGqIo96XuzZXrs0phGyuJwinW+awXZtpvLeAlH/KozI+uOWy7VYBWtgiR/HEqIrsFq77kG0dIBaGF+emmJlBFiAiUu3Gc7J92Klzyg4P8HDz32V59oE8tUSd+sM/UtdEB8YOU8niJ2QQCdNhD6oM/JRuS+8ecJud3YnrEiznXDWTTgmIPzN2N35pqM7D9X0zDJ7nF2R3P2+xMttVcuCg+D3G84p28MQncPa147X2Bu8dsJqBYi64VP9yrbPU0Jq7TBtRGmq6n+jUvAEl2T9CGE+6sPAKzqhpyB+KlbfDV57G1U8bY1tyqzGj/VzA9eRh+3DSibsWY0KEjGNUK9PBfgUyQ7WKqQWkF2lmHNAMv2HCjecKEiyLPBtm3uHT2QMdnW8/fR2iaBlTPuOAUm1kp+lvj8KEljtHRuldpYu7Rh6AGL47KcCamIxIaS+ecrQdS3d8SmxKHevjDlW5h59mV46OEMDAUvKF2eN+pauAbNUD9yawQ6R6RjejqHRBWk+XU8ZXBPg297pSWLUCpGpP4NWYYS7JsLiTdcaTxclYNDvRU16T4LaKQ7YfkRREIduqbrFbRI3LVpSPuZSFYRkn4641bmKOtjxAtIdDfEHGUjtk3PkwfA01slO8yF79LS0YhQgEN3SJ162bzjfciwPhosU91FLx6tNlmc2Cyk6T2
 GhU9V7vX
 1oXqh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches allow guest_memfd to notify userspace about minor page
faults using userfaultfd and let userspace to resolve these page faults
using UFFDIO_CONTINUE.

To allow UFFDIO_CONTINUE outside of the core mm I added a
get_folio_noalloc() callback to vm_ops that allows an address space
backing a VMA to return a folio that exists in it's page cache (patch 2)

In order for guest_memfd to notify userspace about page faults, there is a
new VM_FAULT_UFFD_MINOR that a ->fault() handler can return to inform the
page fault handler that it needs to call handle_userfault() to complete the
fault (patch 3).
 
Patch 4 plumbs these new goodies into guest_memfd.

This series is the minimal change I've been able to come up with to allow
integration of guest_memfd with uffd and while refactoring uffd and making
mfill_atomic() flow more linear would have been a nice improvement, it's
way out of the scope of enabling uffd with guest_memfd.

v3 changes:
* rename ->get_folio() to ->get_folio_noalloc()
* fix build errors reported by kbuild
* pull handling of UFFD_MINOR out of hotpath in __do_fault()
* update guest_memfs changes so its ->fault() and ->get_folio_noalloc()
  follow the same semantics as shmem and hugetlb.
* s/MISSING/MINOR/g in changelogs
* added review tags

v2: https://lore.kernel.org/all/20251125183840.2368510-1-rppt@kernel.org
* rename ->get_shared_folio() to ->get_folio()
* hardwire VM_FAULF_UFFD_MINOR to 0 when CONFIG_USERFAULTFD=n

v1: https://patch.msgid.link/20251123102707.559422-1-rppt@kernel.org
* Introduce VM_FAULF_UFFD_MINOR to avoid exporting handle_userfault()
* Simplify vma_can_mfill_atomic()
* Rename get_pagecache_folio() to get_shared_folio() and use inode
  instead of vma as its argument

rfc: https://patch.msgid.link/20251117114631.2029447-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  userfaultfd: move vma_can_userfault out of line
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  mm: introduce VM_FAULT_UFFD_MINOR fault reason
  guest_memfd: add support for userfaultfd minor mode

Nikita Kalyazin (1):
  KVM: selftests: test userfaultfd minor for guest_memfd

 include/linux/mm.h                            |  9 ++
 include/linux/mm_types.h                      | 10 +-
 include/linux/userfaultfd_k.h                 | 36 +------
 mm/memory.c                                   |  5 +-
 mm/shmem.c                                    | 20 +++-
 mm/userfaultfd.c                              | 80 ++++++++++++---
 .../testing/selftests/kvm/guest_memfd_test.c  | 97 +++++++++++++++++++
 virt/kvm/guest_memfd.c                        | 33 ++++++-
 8 files changed, 236 insertions(+), 54 deletions(-)


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
-- 
2.51.0


