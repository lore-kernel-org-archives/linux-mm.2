Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29BEC9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3FF6B0096; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8C96B0099; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83E96B009D; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2256B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82F91A6EA6
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
X-FDA: 85254083628.15.D0979A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70B59A0004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aS9QC8D+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uYq0gTCJ9yuXVxTzv9i2zsBlbPGb8cej/iNdoEEkWJI=;
	b=SiauVhqDTqn7hHBvwEWt1nBaBLcFW31wpMP4RfvjH7s/Hg08bh3P22KzMuad1MZQT4dkZR
	JkaO9fVE9rMnl2FROqjYYJxHlVqVU71fTFXx2RzBCFBbz3GFdyBO58bNJX+P20/oKoA7H1
	qKLvaQqyEzTUbPmOnusod1bOZB8AVmA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aS9QC8D+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383852;
	b=jCadHwczyCmGb0M//8cESP8vshJEGzvX0V1UOP/j2IMyGUIlmlhBPpblORaUANCxDq6C8M
	UTB88D+siGtuDfqYf7h1KjuyEZDHwLb9utb9mvsckeHSjiWdoHHu83ZPVtIMOihZFSn1ee
	xKqEtesueF04dpOhsPGbWuhagGeCvj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EED642DC7;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3621FC2BCF4;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=uDkfCcxCODk5XvmjtQcG8AagV+2UQjKDO7MxHp1FCvA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=aS9QC8D+QjlQmLBuc+m2khblnzkahdyset+uyNAzvR0v9D5XDbyJar7q6jnuw68A4
	 SgprNbEDu9s3KZQVOBZZz/61RjHIeuGCMDAR8q9zIrpa1Ek2z8FJOrCuYIVCoolShX
	 exBWcMlS2j/MprH6gsn76wsXv2xKfqEP+zR3R8BJQDyFCDTfNE8jbtZbg1cDxNHfIQ
	 b4RN0YnQpOybIDOethq4+yEFXKB3l/XvM/VQMg6yAjhqg++YJsFlgCJc98ytc6jk+r
	 3Dd6W2jLVt+SG7tAH2DBY129GwvkiqOIFG/9Bs+9Rvq0oaLPWG7Kr4HMRbHIICMdAC
	 DqsxyQkTv5dOQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCDDC9832A;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH RFC 00/17] Allow guest_memfd to be created using a resource
 (pool) fd
Date: Fri, 25 Sep 2026 17:50:47 -0700
Message-Id: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOcWt2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDSyMT3fTc1FzdktyCtGLdpMTk7NS8FF0Dc9NUS0sDI0uTREMloMaCotS
 0zAqwodFKQW7OSrEQweLSpKzU5BKQcUq1tQA6Z2lUewAAAA==
X-Change-ID: 20260924-gmem-tmpfs-backend-075e990294a1
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383849; l=7712;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=uDkfCcxCODk5XvmjtQcG8AagV+2UQjKDO7MxHp1FCvA=;
 b=HwKKmE/PN2ll9X17SLMOv4txXTvmNEnD2EVCoqTAPOmsD+X4sgo+/1WErfxlEe+t8gIo8N0Ao
 2Y8GyT/R98vBSrtXrTWVcOHH9UnZotpnD8s8Yfln4MDD2Q9dfhmQc5+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 7tca41uoz8acn3gtfmnt5bccfb4qaenz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70B59A0004
X-HE-Tag: 1790383852-609484
X-HE-Meta: U2FsdGVkX19iuAoWK11F7Je2f2Y421gcwfnxUvRt+ih8yT6lUpeBE77Pw8JmwezqwsEm6eeJ5Fl6czpiQYQ90EkZ1Yx9uSRbrulYVSL3HsTZLMFJoswSVfuj7gzbqLbkHrXwfQ84mEs+7Xo4EJzr4qmWqyfkolaJlhG+0XXcYFbnNSHXT1fGAoGyz5c8u1/h3D5agj/uR75kzPtMl8/CE3GbFE1W+fg0tm7NWIJTsA81e0veO/4Hu34+7rfO3jZEFYsVErXtky6oFFUQ/jcVwSXAlQurQYomJSQ8L1EUbDJ42qUVgJUbCjz1caB6UodFwbT+AHy4Mokj8Zkiwlv9t7ZAo8x78j6UhKeW50/2lhQ3QcThM9Q4LVmXj5p50FwtgKinpuaJhmZaVE8c2SUmtsZjr1AgwdToawZ5bpk3xGjjY0UzOgoV3C7mvPHvvH0b3OOGeR60KvGK8SXlzONo48Wjrvk7j8ryAPYU6lV1vjXBJlSnrxmJwY5yA+6ZpNnsmskVeW6cdsp/bDZ+dPlaywha7rJha/5LtbKxTigezbmouGt8q5Sh+9a4xxnhz2uSxZT2I5xrNjXWRG+tUldz+jjMYUsPSafFqXr/+QGI+4nQYhvWDFjaIs7bSKiUee82GR7c/OAiF7f50u1WzWiWjxCO9r5YQ1K46q8itfpsx0PDNJsUt8w+2cw4BY3EoioXswePbVm6WCkFVdu/vH2DW6MTfn0tVljezj1w+SCs9dgG1A8E2jV90/TXkfWq/bmzKvQ2Qjx3Qz7/qDXSDFZtzdt2AUi4EVBhmBaZoRk3pAM4WeXIHmn2W6igxRkW2c5ko1ktQL0yhuSMTxh7vGPYbfSCU/VffurVTXcPMrX2a/kDJ4Okyf09D4tYJAYQeKdLQBFrYAduOiytikP5xj5zXh/I0y1fp2hFopZgC5tRc+9jQvt48xUMgvRN77O53bTprEV+Qj+8lZxGdfQ1k87
 KLxtmfoV
 te/RGsiuHU9QS5OUEvwMZRZvNtWao0IfHxrQlmkd/LuCAYhtfZ9Epz8fPfhLv0eP+YgXdO0REKvfFMsv1KcEBRuvAMNnVn7+UR8KovgNfKF4kr8gMipDHz+Xjq300Bo20zBm8DCgcDVoq8WXeCeal5+r0VT7720tLckH9DtxRGBNcqJAPR7tKOXUgfynns8yJub4oPIsaBxqql+NpLHanVqKloI9FYCFDE3h8XlhwN+NO/QemV7Ym0o0EnM3SCscKr8PQ+GcsCluqyFOnjhDWGbvuLmRylGn1mrLDTdgJCMEtCXyF7DR2iRtW1Y7A+i/eR2ySTnAGYAwAcq9T56SnejKcLLUJbNnux3/n9k4tSjNzmoXTPQ87nfXNG1HVeVizDb6odFWuEwRFUEjz3/C572g7rhAjsvgKRk2Pa6i2LOCc3I23QliEP+PUTaW6DgyL+xYdMh6JPg3zEuef3ZM4UUEQYqQBJVR8eqOpEkEDZYfOAzksjz7CPKF+T6+S7Aud5njM9TXHBkJSiEqt68s67pVVxxtOpAIV5erHMAbB9lY6ifbZY1bg/0dSbkIKRiYz97h5/p0DlsAqMZ/g8ke+8+incZoEZPBkmASPzzhAgiBKv6ShcAXMrKtDDczKZGS9H8BvZ4r8D2c/EjX5E/L9Gsz/ptxo/2HuoYEc52FRpiQLjeurl5vygyWNEwx/xXvPmcntgem6TfLljNNH2Q5h7tW+shraD61xNL+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

== Motivation

guest_memfd is KVM's guest-first memory provider that was created for
CoCo VMs and will support all VMs.

Today, guest_memfd only supports the equivalent of anonymous
PAGE_SIZE-d memfd memory, and has a lot to catch up to (HugeTLBfs,
tmpfs, DAX, etc) since almost anything can be mmap()-ed and handed to
KVM in a memslot.

I'd like to find a generic interface that would fit different
providers.

== Overview

Think of guest_memfd as a permissions (shared/private) and
KVM-know-how layer wrapping memory allocated from some provider.

This RFC illustrates how a resource pool fd can be handed to
guest_memfd to describe how it should allocate memory.

I believe this is extensible to many different kinds of memory
providers. :)

I'd like to discuss this at LPC 2026's KVM MC [1]. See y'all there!

== How userspace will use this feature

Do one of these,

  resource_fd = fsmount();
  resource_fd = open("/root/of/mount");

Then hand it to KVM_CREATE_GUEST_MEMFD,

  gmem_fd = ioctl(KVM_CREATE_GUEST_MEMFD,
                  GUEST_MEMFD_FLAG_USE_RESOURCE, resource_fd);

And then use gmem_fd as before.

== How to become a provider?

Implement this in the provider's struct super_operations,

  struct guest_memfd_provider_operations {
          void *(*attach)(struct file *resource_file);
          void (*release)(void *provider);
          struct folio *(*alloc_folio)(void *provider, pgoff_t index,
                                       struct mempolicy *mpol);
          void (*invalidate_folio)(void *provider, struct folio *folio);
  };

And the existence of these ops when guest_memfd accesses resource_fd
will determine if the provider is supported.

One requirement of this design is to allow new providers at runtime.

== Questions you might have

=== Why implement in struct super_operations?

It's one of the options to allow guest_memfd to find ops, and for an
RFC I think this requires the least new code and makes a simpler
illustration.

We would progressively add support for kernel-internal providers by
implementing guest_memfd_provider_operations, and loadable filesystem
modules can also implement the ops and be picked up at runtime.

Another option would be to have some kind of registry. Please see
changelog of patch 1 for discussion of options.

=== What if my provider doesn't deal with pages?

Frank and David Woodhouse [2] have use cases for providers that use
PFNs, and this is definitely something a generic interface must
support.

Here are some options I can think of:

1. Don't define .alloc_folio(), instead define .alloc_pfn()
2. Refactor .alloc_folio() to .alloc_pfn()

Either way, I think guest_memfd should still be the primary manager of
the memory.

=== Why have guest_memfd be the primary manager of the memory?

==== For folio-based providers

I propose we allocate the folios based on how the allocator was
configured:

+ e.g. for tmpfs,
    + Use mount page size.
    + Respect mount size limits.
    + Use guest_memfd mpol and fall back to mount mpol.
        + Gregory, now you can set mpol upfront on a mount! [3])
+ Use all the config that your provider has for allocation, reuse all
  those interfaces that your provider already has to do the config so
  guest_memfd doesn't have to reinvent those.

Once allocated, follow guest_memfd's rules on:

+ Tracking number of allocated bytes for this guest_memfd
+ memcg charging
+ Mapping into stage 2 page tables
+ Shared/private conversions
+ memory failure handling
+ etc

For the above split, I had the provider allocate, and then insert the
folio into guest_memfd's filemap.

I think of guest_memfd as the primary manager in the sense that
folio->mapping points to guest_memfd's filemap, which will allow
guest_memfd to handle memory failure by guest_memfd's rules.

Memory failure handling by guest_memfd's rules is something core to
guest_memfd. When guest_memfd supports huge pages, we'd like to be
able to split and only unmap the very page with a memory failure from
stage 2, which will keep guests running longer.

The provider can perform more handling of memory failure; we could
work out the ordering between guest_memfd and the provider.

Other than memory failure, there are other users that use
folio->mapping to determine what action to take. For now AFAICT
guest_memfd doesn't support those, but maybe it will need to in
future.

==== For PFN-based providers

For PFN-based providers, guest_memfd can be taught to store PFNs in
the xarray (like DAX does, perhaps?).

=== But my provider must be able to revoke memory from the guest!

I think that can be achieved with a bidirectional .attach(), where the
provider saves a pointer to the guest_memfd instance.

When memory must be revoked, it can tell the guest_memfd instance to
invalidate the page from everywhere. This has the nice benefit that
guest_memfd already respects the KVM MMU invalidation protocol, so the
provider doesn't have to learn the protocol.

== About this RFC

I chose tmpfs because I think it's the closest provider to the
existing anonymous PAGE_SIZE folios that guest_memfd supports.

The patches in this RFC was written with the help of AI and with many
edits from me.

This was built on top of Sean's kvm-x86 coco branch.

[1] https://lpc.events/event/20/contributions/2551/
[2] https://lore.kernel.org/all/20260720111259.122911-1-dwmw2@infradead.org/
[3] https://lore.kernel.org/all/20260902194657.79075-1-gourry@gourry.net/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (17):
      mm: shmem: Implement guest_memfd provider operations for tmpfs
      KVM: guest_memfd: Support provider folio allocation
      KVM: guest_memfd: Support provider folio invalidation
      KVM: guest_memfd: Add helper to attach resource provider file
      KVM: selftests: Add helper to create guest_memfd with a resource file
      KVM: selftests: Test negative validation of resource_fd argument
      KVM: selftests: Test rejection of unsupported filesystem for resource_fd
      KVM: selftests: Test rejection of tmpfs file for resource_fd
      KVM: selftests: Test rejection of swap tmpfs mounts
      KVM: selftests: Test rejection of hugepage tmpfs mounts
      KVM: selftests: Test guest_memfd with anonymous fsmount() tmpfs pool
      KVM: selftests: Test guest_memfd with mounted tmpfs root directory
      KVM: selftests: Test guest_memfd resource pool sharing across instances
      KVM: selftests: Test memory allocation against shared tmpfs resource pool
      KVM: selftests: Test that shared tmpfs resource pool size limit is respected
      KVM: selftests: Test guest execution with tmpfs-backed guest_memfd
      KVM: selftests: Document testing TODOs

 Documentation/virt/kvm/api.rst                 |  28 +-
 include/linux/fs/super_types.h                 |   4 +
 include/linux/guest_memfd.h                    |  29 ++
 include/linux/kvm_host.h                       |   2 +-
 include/uapi/linux/kvm.h                       |   5 +-
 mm/shmem.c                                     | 112 +++++++
 tools/include/uapi/linux/kvm.h                 |   5 +-
 tools/testing/selftests/kvm/guest_memfd_test.c | 404 +++++++++++++++++++++++--
 tools/testing/selftests/kvm/include/kvm_util.h |  23 +-
 virt/kvm/guest_memfd.c                         | 118 +++++++-
 10 files changed, 673 insertions(+), 57 deletions(-)
---
base-commit: 37e0791600e5f1e2837a270c885296a172f5825e
change-id: 20260924-gmem-tmpfs-backend-075e990294a1

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>



