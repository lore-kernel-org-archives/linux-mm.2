Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C4ACAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD6B8E000C; Wed, 24 Sep 2025 11:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94C68E0007; Wed, 24 Sep 2025 11:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9F88E000C; Wed, 24 Sep 2025 11:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 891188E0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:11:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B20E5B82E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:33 +0000 (UTC)
X-FDA: 83924482866.25.CA3FA35
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	by imf13.hostedemail.com (Postfix) with ESMTP id B4AFC20019
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b=HxQEGW2Q;
	spf=pass (imf13.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T6LxtLsJSjh5VFaqIEo/5wr5RrqvMX416qBvYTVfg0E=;
	b=uX3EJ1d25sfJmZfj3ZZD6AfMX7EdWX586UVtDl9qa66NjXUCi4v4STInQjVSFVbXhDdkBs
	W2BPMG52579jpLDjwktT/x95o4yef47f57iiI6LZt6b5iqjskRXf4lw7MhdaMsxnOe7TlC
	0zky/TNy0lw1lhQf0JKbpLNhurxbbh8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b=HxQEGW2Q;
	spf=pass (imf13.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726691; a=rsa-sha256;
	cv=none;
	b=wfCJE/kiZongsWqOOa52CQcwMViUeJvkdon82BDJaXWciZK7DNuI/tATtj+RCWAX8IgzvF
	1eCsmKQCtFK5HaxPQrAZKI3Mq8AvvKp8CbH8A2KFBfgnD4gA2Z2hn1O/R20qFGZMyrOw5B
	4R7wEnASCDo1GjBiNaECjerUOn5A6yM=
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4cX0fy3XKnzyTM;
	Wed, 24 Sep 2025 17:11:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=
	lm-postout21; i=@campus.lmu.de; t=1758726681; bh=T6LxtLsJSjh5VFa
	qIEo/5wr5RrqvMX416qBvYTVfg0E=; b=HxQEGW2QLMQxARGwSZU1TNXRNbiDlou
	BMJUwogj9SQS+zAwVFesU+rm6J8ESrh5EeQb8FBQenIY3bu5DTO6JKqOyT9QT7oe
	qE0uVSVfDHNlHPRF0cEqwhQIZ+q6CQc14tIb0t3gUZUvCGMT4voVbA7OTed58ZVQ
	Fp7eMjDT1tZPZda+E2TBcGOZatLAYcCYmVqmKrnab+3B5t+QAK4LMD2QJRboE0eN
	z8BGvqbGKfXfsZrfVv9wyzvaAwKUaiKNE2Gwir3zQLPYBd3x3XjwH276/NO8/IjR
	rA8M46iav7Dn7yNPKX1XTaZ8lp6Gh7wTu+F3GTcn8f0k6MkbGN5w2vw==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id w1gLyyBlciFZ; Wed, 24 Sep 2025 17:11:21 +0200 (CEST)
Received: from spacestation.cable.virginm.net (oxfd-27-b2-v4wan-164230-cust474.vm42.cable.virginm.net [86.22.133.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4cX0fr09PgzyS8;
	Wed, 24 Sep 2025 17:11:15 +0200 (CEST)
From: Patrick Roy <patrick.roy@campus.lmu.de>
To: 
Cc: Patrick Roy <roypat@amazon.co.uk>,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	jannh@google.com,
	pfalcato@suse.de,
	shuah@kernel.org,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.co.uk,
	derekmn@amazon.co.uk,
	tabba@google.com,
	ackerleytng@google.com
Subject: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Date: Wed, 24 Sep 2025 16:10:40 +0100
Message-ID: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B4AFC20019
X-Rspamd-Server: rspam05
X-Stat-Signature: pwe7sdjh144ughbixqt98ybrridtdczi
X-Rspam-User: 
X-HE-Tag: 1758726690-301592
X-HE-Meta: U2FsdGVkX18HDg/hy9n6OfRbt4i9WzXed+CGpoXTwvLzPExTVeKpZp7cGXAD4jjh1Z/wBbmAEHozo3C4k9oHowcDBORAL9ljUlmgG03ZEIyZfUyHjUXffq0OYkM4NMTcPVobdFE59pD7emntayLt2IX2+9tC8A93/UeZacN9WCh8CGQ6HvMxhc2Hcku32zhX+98K46UuNIfAURBY0pj5nkvAu4KzH7OVIa6LG+G5tFMOSx6fe1Al/krdpIH8Qmqu4tAHN3MXl1g+6d286zdg4XbmxRtZ6oFk0aUN1ifvAM6U81f6NvjgKx670UCcpsaIVGVu1iEuqWmCfly3U2Vr8VvmeT74fJGiDPuzKHgdWpBC3+4+kRR56iHYl2CGlSm6hkcz17H1VdIXjBodgeVfg2S3D0dS5CgaREs4gkylrYy6duRl+RFqdcFlpbXee3Um0ak02KoNSSq8KKLpBzTGc1PDmDzuPmC6/2LjCBppwg/P5pGKk5ZtorAWsVRPguYt2hXQ37TU1AoDWR+gZHvUA1VoT7pzFxFH/s2cVr8DPF5nvqmlv9SfnQq6a2e817gN7rbFNsDA/8Jcg/iCStgspyiTe25C+pfCkxJuts3G3j4cq/TyqenaPIHoaaJrhs/1PWG/xUpubQlrWICnW8ughagOq5xE/BsYQd39aqH07w3pk2RaloFzr7jwYGqdsDcjZYc50wZBlaHKasdz81k7jrW0RCgb4vvf0V3w0fzdPpbnF8gGScXzlH53zLgltwBHoKn90QKDZcm5/o0KkRlkUvG6SmClKtCAJECJTspA1Snk+PWe6gsNj25Aju6N7JZkDKbMkW+rMC2oeUkSncQe8RhIDJeXFnHzxgXfkaeftspBBJvzAZOY6vxAgk7ndtaQL6e6HFyaucnmimZvB6j7/Bbc8fdvvZZ860iVCJkNTDR0TVfUO7aJNBK1lrEu28I0l56T/+EdNH93PkEtUUB
 fuuMDbGx
 nDcpKMP3/NfFpSz51+OxaiWJyFee1OuYw69lZOGtHT6B2cBl0JbNGFvzckWEvkJlDeKnbLO5E4SSMGC/W5HU9uv2+4oV1ZcW7eD7wtJbkKlr+u6n3uk5kRO8LXgtG+R0+70GSCkX8kdU81wV1FlVvZahiAXvxmM5WCJ239lRFYlV8EVPvqBwDM3c4BVaSxmMR5EXYgB2Gek6jnZlBJQwXEmXU+2h2uRQw3k4mVwW9I4cSD9eLiHA/xxGbzoTmtsVZIKpq0f0JUKNznqtpTwVjPe30r4UVrWHR9rhujkmFV4wExt7mzYihVZiTFjvcJJxykDr+o45yWtwSGBr4JB0psHs0qM2Y+TCzH8qX8m+m1C2h+Fcw03HlpGYyh+urHssOtCXrGkkC0lAK3E0FS07Z08uaKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <roypat@amazon.co.uk>

[ based on kvm/next ]

Unmapping virtual machine guest memory from the host kernel's direct map is a
successful mitigation against Spectre-style transient execution issues: If the
kernel page tables do not contain entries pointing to guest memory, then any
attempted speculative read through the direct map will necessarily be blocked
by the MMU before any observable microarchitectural side-effects happen. This
means that Spectre-gadgets and similar cannot be used to target virtual machine
memory. Roughly 60% of speculative execution issues fall into this category [1,
Table 1].

This patch series extends guest_memfd with the ability to remove its memory
from the host kernel's direct map, to be able to attain the above protection
for KVM guests running inside guest_memfd.

Additionally, a Firecracker branch with support for these VMs can be found on
GitHub [2].

For more details, please refer to the v5 cover letter [v5]. No
substantial changes in design have taken place since.

=== Changes Since v6 ===

- Drop patch for passing struct address_space to ->free_folio(), due to
  possible races with freeing of the address_space. (Hugh)
- Stop using PG_uptodate / gmem preparedness tracking to keep track of
  direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
- Do direct map removal when establishing mapping of gmem folio instead
  of at allocation time, due to impossibility of handling direct map
  removal errors in kvm_gmem_populate(). (Patrick)
- Do TLB flushes after direct map removal, and provide a module
  parameter to opt out from them, and a new patch to export
  flush_tlb_kernel_range() to KVM. (Will)

[1]: https://download.vusec.net/papers/quarantine_raid23.pdf
[2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[RFCv1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/
[RFCv2]: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon.co.uk/
[RFCv3]: https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.co.uk/
[v4]: https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co.uk/
[v5]: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.uk/
[v6]: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk/


Patrick Roy (12):
  arch: export set_direct_map_valid_noflush to KVM module
  x86/tlb: export flush_tlb_kernel_range to KVM module
  mm: introduce AS_NO_DIRECT_MAP
  KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate
  KVM: guest_memfd: Add flag to remove from direct map
  KVM: guest_memfd: add module param for disabling TLB flushing
  KVM: selftests: load elf via bounce buffer
  KVM: selftests: set KVM_MEM_GUEST_MEMFD in vm_mem_add() if guest_memfd
    != -1
  KVM: selftests: Add guest_memfd based vm_mem_backing_src_types
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing
    selftests
  KVM: selftests: stuff vm_mem_backing_src_type into vm_shape
  KVM: selftests: Test guest execution from direct map removed gmem

 Documentation/virt/kvm/api.rst                |  5 ++
 arch/arm64/include/asm/kvm_host.h             | 12 ++++
 arch/arm64/mm/pageattr.c                      |  1 +
 arch/loongarch/mm/pageattr.c                  |  1 +
 arch/riscv/mm/pageattr.c                      |  1 +
 arch/s390/mm/pageattr.c                       |  1 +
 arch/x86/include/asm/tlbflush.h               |  3 +-
 arch/x86/mm/pat/set_memory.c                  |  1 +
 arch/x86/mm/tlb.c                             |  1 +
 include/linux/kvm_host.h                      |  9 +++
 include/linux/pagemap.h                       | 16 +++++
 include/linux/secretmem.h                     | 18 -----
 include/uapi/linux/kvm.h                      |  2 +
 lib/buildid.c                                 |  4 +-
 mm/gup.c                                      | 19 ++----
 mm/mlock.c                                    |  2 +-
 mm/secretmem.c                                |  8 +--
 .../testing/selftests/kvm/guest_memfd_test.c  |  2 +
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++++---
 .../testing/selftests/kvm/include/test_util.h |  8 +++
 tools/testing/selftests/kvm/lib/elf.c         |  8 +--
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 61 +++++++++--------
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +
 .../selftests/kvm/set_memory_region_test.c    | 50 ++++++++++++--
 .../kvm/x86/private_mem_conversions_test.c    |  7 +-
 virt/kvm/guest_memfd.c                        | 66 +++++++++++++++++--
 virt/kvm/kvm_main.c                           |  8 +++
 30 files changed, 290 insertions(+), 94 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.51.0


