Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910E760A263E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GGIGpB3B
Received: by kanga.kvack.org (Postfix)
	id AEEBD6B05B7; Tue, 10 Nov 2026 00:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A756B05B8; Tue, 10 Nov 2026 00:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968076B05B9; Tue, 10 Nov 2026 00:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C39C6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC8FB1A08AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:08 +0000 (UTC)
X-FDA: 85418012736.25.2C3EBE9
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AB291C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GGIGpB3B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TaXyagkKCMAzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3TaXyagkKCMAzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
	b=B56e5h6Irf7p4OdWuDEu0Ey6Z+eaMWMETS1zhtTtdPtbpwJGhwlaP9Os1rIjDkwoPxQnXg
	6/EYI9rfE8CNUrDRxKm63iNS8FHeQ8krCt4sC2sEPB3eCIjiDXSGBRUyX4BzaXmxuq9UbF
	iy82sj9ZiCdcIzAjZT8QTaXBi4bPYuE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GGIGpB3B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TaXyagkKCMAzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3TaXyagkKCMAzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286927;
	b=0I4SAgHDBz60HmJN9DkzybzZZ887HzC7hIoc6VHkeqrJR86fCwzykEkIcayNMaRq0arD2P
	ecyPXjtL3ogxUCubE4o3oyWTaVKY3dEP1PtUZ7JrFopfNERvzAXkClmhB7oaKWWISxsDvx
	pzhvOXToHA2167ImJr5YKUzYUuPkXuQ=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c49df8fe86eso118458466b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286926; x=1794891726; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
        b=GGIGpB3BNZexDjuhEx1jdco0avjquxuY8SgT5sYI39XtSWxd7PktmzVBSxzkIxsGgS
         5399gh4EQJUpKuhJOs6svcuQrx9I4yS5ObOBBSgghiFvAbfTRPDSKfAyhgTPYx9o7mhk
         0Nl8uZGMV3t4SkiEvAxOfDuipBGx7fqwZ1V9BDoqDS/R3T10Mg+RgKRhlFfCLHAeeagE
         ZULGQ8VTEj+M+M/y68ZNr8vClbHa426vqusTv+hCwAmyvS0tr8JIvPrmRdVPviqt9egn
         DVxzknI3n9xkJCD7R3TR9kfBrG/rQr/2NIJNhWTHw153FFuvPr1EaHPnblioaFnOLliF
         StsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286926; x=1794891726;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
        b=vfRZmsDycEd/9FS4JCANEAyKWREjvAy7qmVMTX+uLVthG/5tktq8CoMr9RkZ1A1HEo
         lYj6J6fBQg0VtTg9mLfDeqzC+pUY5dGaXPoqGLoIKVrXT4bzYcbAbIR22ajKdPAwQeD7
         G6S8e2Mr7/9efzUBdn6xSm1pM3pWPJOHxS2daVoanSdzOQ40vOKcZXRsZLGDqHh7IMfM
         3f4nIPmNCTY+Itr7TxIb5V6TeZlu+Gui67qmvpTaMncUAS7tac2bhK1UBmQx5s4lm5pi
         7auwyqB/jxU9YwIkPMxEzxUnqbAv0wohf5vcaMZXhhZ1Z6d7u57SIKSvYMMk3zoGuhL1
         nnCg==
X-Forwarded-Encrypted: i=1; AL+hErHzPHadE/Qm9GAyJtQ4/adbrnPUaHr/yf9kuh1LEErxXvgLTrR9dP4Z1vH+wPjI1SC9x4mXmirhew==@kvack.org
X-Gm-Message-State: APuU4Z+eK/TcTTO7bKCtgXiJN30wHm+3arJjcILQMv6fWxUx9bkTAZSf
	GvII6I3Da9ZjDfOjme2mIF4idnn+yEw9iXlM72smBoOmps7eC3LqGwhjbw6bYtR2GKZioqXO14I
	lde3BVURay1IdSlxDCg==
X-Received: from ejai3.prod.google.com ([2002:a17:906:1143:b0:c3f:6b4b:bcf8])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f58d:b0:c41:7e99:c6c2 with SMTP id a640c23a62f3a-c5049656cbamr129203766b.44.1794286925434;
 Mon, 09 Nov 2026 21:02:05 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:43 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-1-tarunsahu@google.com>
Subject: [PATCH v4 00/19] kho, liveupdate: Add feature header for fine-grained
 ABI compatibility
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3AB291C0004
X-Stat-Signature: tzp3kq4sw8oqsdqjw4agck8o8epw1pjx
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794286927-812852
X-HE-Meta: U2FsdGVkX1/OKjZSD7zD9duwJ2h2oUBGkUmK/n41VsFEAdejjHfMCot7sjeq6Zbl4+h+J5GA6gBlDxeGAYf/lghElbTb6YxEx5ysOAWXMtioJ0wtNBUKuLVFxL1jBNTAJdpJkA0N2qVHttGQEh5G/KkTPjF+HIL6J0gjSlHZJNeykJ73Z3n2vWK1ERJ8ZnTmWl7UJfzSt6cV19qhOPE9rbU7LjBKZ7C4VFpv0SA+kH9d2xYYcXvrwh3EVcoTEAD5jOKjnSgBgzuR2WT8Qx7IN1SP8cj2xKaXP0V1+slJLAbDGRJigYj/VxtJVkBaSZ45FC240Gg/lz6WQXX6Iu43DbMcMGOurkHbNqp3Sz1lcaMoWXWGyhI31t8sqq/+elxU/EOIkQ8zQ1Zt2+jWGZx9zfY3hnhTRu2P9SzDG2B+7Q4Yrn5yG+3GKKzbLSE9LS3Zw02LYibO7yIY+6PvBai541FdnyXDcfvEi7Mwwb5+yUoojH4i1ZkHlj45eILExvGxN4uWUGL/GLh8x02qsg8bZFM8T/X+C0my8nQQ/LnmFZqbWnyO7DmscHHA+X3E8uWo19FWDpw5OtepJhYCWXOdAiNAZO5txdjWa+KVXj4nJtc9EXutc9fhmoZ6JvBFLQTgkOu9/SS6gpmeY9c3fw86Dh4aN89Kfv2CP6MHIopORDVtM4SJNKqZ4lr1E1eoHCjjyTNK1pTOnJiG5+hSgBaVgUiKruXnENgqxUz2isLhjDw4q3yD72TsZ/db1W0UMhWiIqhYg2EJbD5J2kBk4tfbDkbLcFLNKznqUPC8+k/Jp34lWoCuzB+BKUAZzziL4Vm+bwX58NCBYquIZCsv5zWdmFCq29qRhEdrDKKfCXi5A62BxjtXG7mfMlVapxU7/Ru0XGyM1A/QnpRD53zn/C5/5NiVUXL25pjrtd/r8mrJZ7XaPkWSycj6kvBppueWiqlUSRSmgFmHwfM+QQFR+2F
 zhZC9Q2C
 toGvRHWMlxxF0dAAZD29ziHSHRW5R8paAeh+bmmT618picIEvPXtGN4Ru4gEprgtDfjb8p3aqoZoE5lMHXZT22fFmMEQ7S335CCRv4EZJYVmlbCXVzct+l5GIBk6+ZjWnU4OuOx8Rca9fRpU6SMhWzNkhty3HiPtZg0YfNBttSeRWdy7lIDgS8D1GqsueB806AnxnUO5GoQN1VCPWzBamwJsb8qa8coqkaNlsEkeTTAzxznNsnn7NSIyq1w8xHrL5Kcqxwa1tOvTCzDxdJ4sPmtX/Vayf/Np1zKvehCRhA3QIZqZrM97bY40YMrGkbh7OMHwvk35qW7OMuWJQZ2pjWD/m1cjSO0qxk+Qhl5RUyNyNpP+2UPeD7TvwbuFVrfAl5yRf3/ld48SjOjRua6BgBdwd9ej9n0kxjm7VVM211Vkp4M2x7D/SOkVM0Wwn6MJgMxi8oO3TpV7qkbhZNl8UR9W966GKUTldfZQ8jsGE3BQTrcaYY8BECKp6AanTqp91r8+ZZpzmcvavGhMnYOSGLr+yTYpEcsOg/aGXGRTSj+ky7YZOJTNhh7gyocokEJ3ssN9vsOw/QUmAyHAELP8f00dOymnfpODxfubopQbFIu7t04lA4Hoa9ChJMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This v4 of feature flags support for LUO and KHO is no longer an RFC.
This has gone through multiple design changes over the past few months,
and I thank everyone for providing their suggestions and reviewing it
promptly. Below I talk briefly about the evolution of this series to set
context and try to make it easy for everyone to review.

Initially, Logan proposed the feature flags in RFC v1 [1], which tried
to solve the problem of dependency on the compatible string. Feature
flags introduced finer-grained compatibility. This series had three
fields: active, supported, and required. The number of flags was limited
and didn't have flexibility, which reduced the complexity of the patch,
but put a limitation on the extensibility of the features.

After LPC and a few design discussions, I proposed RFC v2 [2], which
changed the flags to optional and required and converted the encoding to
2 bits per feature instead of having two separate variables. But This still
has the number of flags limited and fixed the feature header size to
128 bytes. Though each serialized structure is being allocated in
multiples of PAGE_SIZE (folio order = 0, 1, 2...), where 128 bytes is
not a problem, it still carries two fundamental issues: limited feature
flags, and a fixed 128-byte memory overhead for each preserved file. In
the future, as there are plans for moving to KHO slab, the allocation
for serialized structures can be significantly reduced and this 128-byte
size will be a problem again.

Based on the RFC v2 discussion, this v4 (v3 [3] was intentionally ignored)
moves to extensible feature flags with a variable-length flags[] array,
avoiding the fixed 128-byte overhead and feature-count limit.

Along with this, as discussed on RFC v2, v4 uses separate bit ranges for
required and optional flags (1 bit per feature). It builds on the
consideration that a feature in its lifetime will either be required or
optional; it can't be toggled into the other. In the future, if such a
need arises, a new feature flag can be introduced to replicate the
feature as optional or required, opposite to its ancestor flag.

This new layout and encoding in memory is as follows:

struct kho_ser_hdr {
	u32 size;
	u16 nr_required;
	u16 nr_optional;
	u64 flags[];
}

where,
	flags[i] = (BIT_MAP(optional_features) << nr_required) |
		   BIT_MAP(required_features)

This series introduces the feature header in the KHO subsystem, and it
is used by serialized structures across KHO and LUO. A few of the
serialized structures embed other serialized structures directly. To
keep the relative offsets of fields to be same across kernels, we cannot
have an embedded serialized structure's size changed; otherwise, direct
casting will not be possible. To solve this, this series converts those
embedded structures to KHOSER_PTR, which points to the memory just after
the parent serialized structure, and allocation and preservation happen
for the total memory (parent_ser_size + embedded_ser_size).

<Iamparent>_ser {
	u64 a;
	u64 b;
	struct <Iamembedded>_ser e_ser;
	u64 d;
}
	CONVERTS TO ===>

<Iamparent>_ser {
	u64 a;
	u64 b;
	DECLARE_KHOSER_PTR(e_ser, <Iamembedded>_ser);
	u64 d;
}

There are only two such instances: kho_vmalloc and luo_file_set_ser.

This series introduces kho_ser_hdr for the following structures:

  - struct kho_kexec_metadata
  - struct kho_vmalloc
  - struct kho_block_header_ser
  - struct luo_ser
  - struct luo_session_ser
  - struct luo_file_set_ser
  - struct luo_file_ser
  - struct luo_flb_header_ser
  - struct luo_flb_ser
  - struct pci_ser
  - struct pci_dev_ser
  - struct memfd_luo_ser
  - struct memfd_luo_folio_ser

If you notice, this also includes the PCI ser structures. PCI LUO
support is merged in liveupdate/next, and this series is developed on
top of it.

Each serialized structure is preceded in memory by struct kho_ser_hdr
and registered via DECLARE_KHO_SER(name, payload_size, nr_required,
nr_optional). Both struct kho_kexec_metadata and struct pci_dev_ser are
explicitly marked with __aligned(8) because their largest member is a
32-bit integer, and 8-byte alignment is required by DECLARE_KHO_SER() so
trailing feature payloads remain 8-byte aligned across 32-bit and 64-bit
kernels.

Also, Introduce DECLARE_KHO_SER_HDR(ser_name, fhdr) which is just the
wrapper for struct kho_ser_hdr fhdr, This makes it clear
To which ser_name, this fhdr belongs to.


Series structure:
  - Patch 1 removes __packed from KHO, LUO, and memfd ABI structures and
    asserts their natural size and 8-byte alignment under CONFIG_64BIT.
  - Patch 2 records entry_size in struct kho_block_header_ser so the
    incoming kernel derives the entry stride from the block header.
  - Patch 3 converts callers that embedded struct kho_vmalloc by value
    (memfd_luo and test_kho) to reference it via DECLARE_KHOSER_PTR so
    struct kho_vmalloc can grow independently.
  - Patch 4 converts struct luo_session_ser to reference
    struct luo_file_set_ser via DECLARE_KHOSER_PTR instead of embedding
    it by value so both structures can grow independently.
  - Patch 5 introduces struct kho_ser_hdr, DECLARE_KHO_SER(),
    DECLARE_KHO_SER_HDR(), and the serialization/validation helpers in
    include/linux/kho/abi/feature.h.
  - Patches 6-18 add the feature header to each of the 13 KHO, LUO, PCI,
    and memfd serialized structures in independent patches.
  - Patch 19 adds a KUnit test suite (kho_feature) covering the feature
    header helpers.

[1] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/
[2] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.com/
[3] https://lore.kernel.org/all/20261026174217.603114-1-tarunsahu@google.com/

Tarun Sahu (19):
  liveupdate, kho: Remove __packed from KHO, LUO and memfd ABI
    structures
  kho: block: Record the entry size in the block header
  kho, memfd_luo: Reference struct kho_vmalloc via serialized pointer
  liveupdate: Reference struct luo_file_set_ser via serialized pointer
  kho: Add feature header for fine-grained ABI compatibility
  kho: kexec_metadata: Add the feature header
  kho: vmalloc: Add the feature header
  kho: block: Add the feature header to blocks
  liveupdate: Add feature header to struct luo_ser
  liveupdate: Add feature header to struct luo_session_ser
  liveupdate: Add feature header to struct luo_file_set_ser
  liveupdate: Add feature header to struct luo_file_ser
  liveupdate: Add feature header to struct luo_flb_header_ser
  liveupdate: Add feature header to struct luo_flb_ser
  PCI: liveupdate: Add feature header to struct pci_ser
  PCI: liveupdate: Add feature header to struct pci_dev_ser
  mm: memfd_luo: Add feature header to struct memfd_luo_ser
  mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser
  kho: Add KUnit test for the feature header helpers

 MAINTAINERS                            |   1 +
 drivers/pci/liveupdate.c               |  99 +++----
 include/linux/kexec_handover.h         |  15 +-
 include/linux/kho/abi/block.h          |  21 +-
 include/linux/kho/abi/feature.h        | 372 +++++++++++++++++++++++++
 include/linux/kho/abi/kexec_handover.h |  11 +-
 include/linux/kho/abi/kexec_metadata.h |  17 +-
 include/linux/kho/abi/luo.h            | 102 ++++---
 include/linux/kho/abi/memfd.h          |  27 +-
 include/linux/kho/abi/pci.h            |  66 ++---
 include/linux/kho_block.h              |   8 +-
 kernel/liveupdate/kexec_handover.c     |  98 ++++---
 kernel/liveupdate/kho_block.c          | 172 +++++++++---
 kernel/liveupdate/luo_core.c           |  43 +--
 kernel/liveupdate/luo_file.c           |  58 ++--
 kernel/liveupdate/luo_flb.c            |  69 +++--
 kernel/liveupdate/luo_internal.h       |   9 +-
 kernel/liveupdate/luo_session.c        |  55 +++-
 lib/Kconfig.debug                      |  13 +
 lib/test_kho.c                         |  38 ++-
 lib/tests/Makefile                     |   1 +
 lib/tests/kho_feature_kunit.c          | 184 ++++++++++++
 mm/memfd_luo.c                         | 183 ++++++++----
 23 files changed, 1271 insertions(+), 391 deletions(-)
 create mode 100644 include/linux/kho/abi/feature.h
 create mode 100644 lib/tests/kho_feature_kunit.c

-- 
2.56.0.506.g506a7eabc5-goog


