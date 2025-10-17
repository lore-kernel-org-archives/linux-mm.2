Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC183CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C408E0009; Fri, 17 Oct 2025 16:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CCA8E0006; Fri, 17 Oct 2025 16:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60CB98E0009; Fri, 17 Oct 2025 16:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490708E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D41FA1DF6C3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:31 +0000 (UTC)
X-FDA: 84008703702.21.765B219
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 232884000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y2gbWbpd;
	spf=pass (imf04.hostedemail.com: domain of 3LKPyaAsKCIsprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LKPyaAsKCIsprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MvNEuSw58UwdjUzqQehycSdzJ+PYeq3LWgjQi3Vxd7A=;
	b=56zQOLZCA2G0gbbWtAv8ScepMuCyNdd0tLEjjHe4wK/8PV7HQL5DOz7VEM38JBE5J8VHNZ
	d6RzsTwW50O9eR/BbNmmxOLMCcM1NQLEdmOZ29NlmG87OquFkavDV8CPuL7iiKj9ttFIL0
	/xbq7m8HXbeI6NhN50Acxxe+g77S5no=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y2gbWbpd;
	spf=pass (imf04.hostedemail.com: domain of 3LKPyaAsKCIsprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LKPyaAsKCIsprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731950; a=rsa-sha256;
	cv=none;
	b=G3IlD18lP4HRYCK8qW0ZP3V9Dfjfn4b2RWWZTp8y+w11VYcry0UOu+qT7h7dd8SaKPmnz8
	hpH7jcndXW3+ELAv8D7XomoDHi52EkuaSCF8m+T7n5G9UuW3enGPxySzv0bXWVdm29EH70
	S/Q4TmM7K6b+pjhGHO2c5mqoaHmYppw=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bcb779733so1622182a91.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731949; x=1761336749; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MvNEuSw58UwdjUzqQehycSdzJ+PYeq3LWgjQi3Vxd7A=;
        b=y2gbWbpdMa4iSW2MiiFiLWUCStevSx90pQ7P8VIwTFJwQ6qx72T8/bpRxUxVJqXg5E
         Vy2yBS/cjavW4K47GJmAZTB7osMWy7tT1uSO0obsqDh3vjye5TjO4nO+kUhEcXEI6lMA
         5p4kOye3gaa8p6/G1bUsc1r/AA9pho3rwmjYLloAzSog0XYH9VwRsaJLgnhfQ22Q+Jq/
         zZUt0RF75wgBl4PTv0n7jlMsFshK8qoZCNTChSv+IIDD03xbUFkP7xXyiraImGJ3NjaN
         cuIOI9yJwa5K5QpaiOHzLY0zI9vBQjanT7GyWzxkVdpVjaC5OAgliaUV89CBLmtm3aOH
         Ugzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731949; x=1761336749;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MvNEuSw58UwdjUzqQehycSdzJ+PYeq3LWgjQi3Vxd7A=;
        b=JW2kh5G6EnHtzGtaV3BRD3m6yEVu0Acfj1b1AXyNu7gE+pQNlosazfNEo/dWudIZQp
         ywPxJIOte0rEoKRkELXpi3HCmuXQlnr49D6KT96x0as+Q2sObA6ENokqQUg+pFoZUNNG
         m+qCZTOh8vyAjJsIomTsmcvHFJGKt5cFZGqseWcxc3DYnGoU4QYwwFeFm05gb3av4zaR
         CT5QYZiSSlIIA/whQMmmKp4TEPiYwf9fqsz+LbkOrSbH8wefzHmnKyfNlLhVpfgkM0nE
         fJ+LExBNEa7ETL03T2MDAmIImqV9y4mTr0M0IHwt/S7Ig7QWo/LsksLJZG/7LY0YhpLT
         rP1g==
X-Forwarded-Encrypted: i=1; AJvYcCX3sY3P3dqN7Uxy/ZG/BrIk7yopubangBsupsY6PtN1s4GqtVILggt3ZyE6lP99ouB+BHyO4kUlHA==@kvack.org
X-Gm-Message-State: AOJu0Yz+QBFRwlCkCmRJ9783MBuCbff1cRkmhBsdoNW5G4/l6tH7c8lx
	UrxUcDvRenvK4p6/n4amtExZXQaUmWP2BO1uDqq0iJWuPtpkn+YEKoTE+64BeVL2Jsun8OnPT6I
	8sLcIcesioTnwiaZQa6oZADBsVA==
X-Google-Smtp-Source: AGHT+IGm0uDnlmmvVqLxeQbS/GkNVcVJ1vJxluasBXbGw+YdYIXcsi2a/48HhtEUh6v1e/OBtWieEkqS8C8YBg1I5A==
X-Received: from pjbpm17.prod.google.com ([2002:a17:90b:3c51:b0:33b:b692:47b0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c4e:b0:32e:6019:5d19 with SMTP id 98e67ed59e1d1-33bcf921526mr5690604a91.34.1760731948481;
 Fri, 17 Oct 2025 13:12:28 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:41 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <cover.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 00/37] guest_memfd: In-place conversion support
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1xx74nuz5tugowwx43ox83g1xeo8e4ak
X-Rspamd-Queue-Id: 232884000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760731949-844797
X-HE-Meta: U2FsdGVkX19nQwgR3NmLQYoZA8hLYxgpJwey4rLL5Qph0Pe3pI30iYhWsBzA+4J2Yhw9r4dedgXVYp1kRpZTN7ILKILey5BRcez4gw8oQu9eamcmPaXD0lDmsxvdRpdfBzw/nuJqq3tZ1xSKx7VEKOBLRJS2GRPVJwbbNZiMJFzslTz/sX+KgFBT4saiI5VO9lDom0l6AaRwEef0MifeJW+G33iIYReKDDbT5gl4658naaYLrzu31giJtstusxkkQ1ZhedxsVTa6OQ4zctBGtnF0hvxicP42afWFyXZ51lB1LoBs9BLWPhaFV1tHq0jcFMgKBujpoHfiiWiz9oKy/vCtOXlYqTTm19FFH0fvo7n6AAdMO3wJFAG2WoCVvD+Zow40LVhrwj6lYSZ9+gBgxH22LXVb+O1oJ5HpgG0Cp4yDHLqrG5T7Ap4AR37MGAV9IJ8rYC2lnKVnk2jC/eMyExLIl6atKMeQx/5gx7YNw3INdeVpwzEKCgn4XiPeWuBF93gkY2myHeuimeKHQG2yxFpqMSxvRrB30KlBqYEWUklOl6VgWqVA6llOpKWlJjmOyoifo6Ob7OnxeFUHAsT5A7hfxKV3DVCifQYJ5IwV96Y4U4dAHo2RvY2mYxaSEk7qonpikTeB1rCXYg9uCZPvwtpVfWC/P5Ab583uChLNRcfdNwpgPBX/HOV2DwQa1I9f2Kj4V6gpBFPH4YSWWoGCPYq1EFs6sQoTVZLnr4tVNJZn3zqOEbr1hVRd3iVDQetURZGIvrXFBNBxSAYO6ozy5hNnQFajNL3swYgqU0lpYvNTqGdkBBrm8PzWSNegTmZ9shS8n+1hhTMMQ5DcYoGokB88cC1XNGcZlTdZR5Y8x2SGe+hwVqLZCx2vOlbJ5UNfYkj7qIeskrFvQ/miIKiZMYlhXa9WHAdjoJavxhFK+lzl0PEK+qzsQW8Bd92Jn71co53W2TNJ0xv41WzKxiO
 Rip+yp8Q
 rJK2gWoT8icHCtqpkBm1Y9KaLLdXtHHMFgnJCH+/vfznVYVX+BXjXjb42KrGoGqqVKkaj+bH4lJGz9+0lkIHWFY5f8LFMscN4PyUovrbqFZyG4w3fwOwkUrzs+G/Ku6zJ5j+mDqaftvN6aVXSrCP383OGdyo8xAtg2nlcXAJeRjZY3ggWTkv/qMvyfqTP0ajmXjJo6y3tm7KgNmVwX+E09kIKyOPgVeODfZCxgN3jPyKTcuENhhTCnvR9CHODcj+Ty3ab1E4d8TqTi1Y7XggUUPtXDQ11ZoZ+ZQoxgSfarPY014ZELw3q9tDLBTtKASvUIityRuLMziD4jhNSftVhLHoJ9nSJv7VimAsBji9NYBjEClewW4FgtmNiJ+j/+QcaBlHP/5zQux47xDuGTD2bxP6x/VcPapL4c+JX0N7zXI707/sFyyuVAt+oSJl4ZeqSGzL7HYLqb/2V3ubocHUxj8aa5bEUMSUMEsnzzYKhvXXnXnIGRiwZYuizgT0q0efMlScDAX0Hbd2sbjja/BoMWO/iLizNDH5vYc3jQKb8SpLeAO/9pkIaWEdwUdSYqt1heASVJ2NTpXuNXADIl8HKczsH67ypx+MdRPQwBMvLqoH+fiKjcUIukA48pBYtAKC9eBoRLJjXCMR47ad53it/dM0iMBGN72N3qezmwj5DaOEon8T+0UsJAhV8XQnea5IZ1bepHzie36gAgrbYGWjKJ3CQPowQVuz2vlV65J9xJUayCYLmbcIk52VCCEJYTD8APrwnH8SW1DJCO7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

IIUC this is the first independent patch series for guest_memfd's in-place
conversion series! Happy to finally bring this out on its own.

Previous versions of this feature, part of other series, are available at
[1][2][3].

Many prior discussions have led up to these main features of this series, and
these are the main points I'd like feedback on.

1. Having private/shared status stored in a maple tree (Thanks Michael for your
   support of using maple trees over xarrays for performance! [4]).
2. Having a new guest_memfd ioctl (not a vm ioctl) that performs conversions.
3. Using ioctls/structs/input attribute similar to the existing vm ioctl
   KVM_SET_MEMORY_ATTRIBUTES to perform conversions.
4. Storing requested attributes directly in the maple tree.
5. Using a KVM module-wide param to toggle between setting memory attributes via
   vm and guest_memfd ioctls (making them mututally exclusive - a single loaded
   KVM module can only do one of the two.)
6. Skipping LRU in guest_memfd folios - make guest_memfd folios not participate
   in LRU to avoid LRU refcounts from interfering with conversions.

This series is based on kvm/next, followed by

+ v12 of NUMA mempolicy support patches [5]
+ 3 cleanup patches from Sean [6][7][8]

Everything is stitched together here for your convenience

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v1

Thank you all for helping with this series!

If I missed out your comment from a previous series, it's not intentional!
Please do raise it again.

TODOs:

+ There might be an issue with memory failure handling because when guest_memfd
  folios stop participating in LRU. From a preliminary analysis,
  HWPoisonHandlable() is only true if PageLRU() is true. This needs further
  investigation.

[1] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
[3] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
[4] https://lore.kernel.org/all/20250529054227.hh2f4jmyqf6igd3i@amd.com/
[5] https://lore.kernel.org/all/20251007221420.344669-1-seanjc@google.com/T/
[6] https://lore.kernel.org/all/20250924174255.2141847-1-seanjc@google.com/
[7] https://lore.kernel.org/all/20251007224515.374516-1-seanjc@google.com/
[8] https://lore.kernel.org/all/20251007223625.369939-1-seanjc@google.com/

Ackerley Tng (19):
  KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
  KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
  KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
  KVM: guest_memfd: Skip LRU for guest_memfd folios
  KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES
  KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
  KVM: selftests: guest_memfd: Test basic single-page conversion flow
  KVM: selftests: guest_memfd: Test conversion flow when INIT_SHARED
  KVM: selftests: guest_memfd: Test indexing in guest_memfd
  KVM: selftests: guest_memfd: Test conversion before allocation
  KVM: selftests: guest_memfd: Convert with allocated folios in
    different layouts
  KVM: selftests: guest_memfd: Test precision of conversion
  KVM: selftests: guest_memfd: Test that truncation does not change
    shared/private status
  KVM: selftests: guest_memfd: Test conversion with elevated page
    refcount
  KVM: selftests: Reset shared memory after hole-punching
  KVM: selftests: Provide function to look up guest_memfd details from
    gpa
  KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
  KVM: selftests: Update private_mem_conversions_test to mmap()
    guest_memfd
  KVM: selftests: Add script to exercise private_mem_conversions_test

Sean Christopherson (18):
  KVM: guest_memfd: Introduce per-gmem attributes, use to guard user
    mappings
  KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
  KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem
    is defined
  KVM: Stub in ability to disable per-VM memory attribute tracking
  KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem
    attributes
  KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
  KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
  KVM: Let userspace disable per-VM mem attributes, enable per-gmem
    attributes
  KVM: selftests: Create gmem fd before "regular" fd when adding memslot
  KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
  KVM: selftests: Add support for mmap() on guest_memfd in core library
  KVM: selftests: Add helpers for calling ioctls on guest_memfd
  KVM: selftests: guest_memfd: Test that shared/private status is
    consistent across processes
  KVM: selftests: Add selftests global for guest memory attributes
    capability
  KVM: selftests: Provide common function to set memory attributes
  KVM: selftests: Check fd/flags provided to mmap() when setting up
    memslot
  KVM: selftests: Update pre-fault test to work with per-guest_memfd
    attributes
  KVM: selftests: Update private memory exits test work with per-gmem
    attributes

 Documentation/virt/kvm/api.rst                |  72 ++-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/Kconfig                          |  15 +-
 arch/x86/kvm/mmu/mmu.c                        |   4 +-
 arch/x86/kvm/x86.c                            |  13 +-
 include/linux/kvm_host.h                      |  44 +-
 include/trace/events/kvm.h                    |   4 +-
 include/uapi/linux/kvm.h                      |  17 +
 mm/filemap.c                                  |   1 +
 mm/memcontrol.c                               |   2 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/guest_memfd_conversions_test.c        | 498 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  | 127 ++++-
 .../testing/selftests/kvm/include/test_util.h |  29 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 128 +++--
 tools/testing/selftests/kvm/lib/test_util.c   |   7 -
 .../selftests/kvm/pre_fault_memory_test.c     |   2 +-
 .../kvm/x86/private_mem_conversions_test.c    |  55 +-
 .../kvm/x86/private_mem_conversions_test.py   | 159 ++++++
 .../kvm/x86/private_mem_kvm_exits_test.c      |  36 +-
 virt/kvm/Kconfig                              |   4 +-
 virt/kvm/guest_memfd.c                        | 414 +++++++++++++--
 virt/kvm/kvm_main.c                           | 104 +++-
 24 files changed, 1554 insertions(+), 185 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_conversions_test.c
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.py

--
2.51.0.858.gf9c4a03a3a-goog

