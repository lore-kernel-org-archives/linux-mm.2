Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C83CD342C
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4315C6B0088; Mon,  4 May 2026 20:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409396B008A; Mon,  4 May 2026 20:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346756B008C; Mon,  4 May 2026 20:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2232D6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:27:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4BF614032D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:41 +0000 (UTC)
X-FDA: 84731477922.22.7B2D34C
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 093D5A0003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahhqgxSo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3ejn5aQgKCCkXPMFbFOFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ejn5aQgKCCkXPMFbFOFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940860; a=rsa-sha256;
	cv=none;
	b=bP0GPS4kJ66Ytvk4SC63gQfrxhqH5nPMaV8ekrvPBajqdjZYtF4E9gRaIgaJAtTlLeQknR
	y0urT9MObuJ18eI8E+LJUes3QoulXLl1Jm2JHOxD7Lvo3HxYp9bmTEAhHZguvANPjauUhm
	h0ufY+2Dz2QDIgNo34sNSVIK1u6GQ/o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahhqgxSo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3ejn5aQgKCCkXPMFbFOFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ejn5aQgKCCkXPMFbFOFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Obu+hjMmt2gyOfNoZeJMdjxX5bs05kcQmj8x3MdMggE=;
	b=jzL7h+J9QzodqRWR8m1XuYlSj6byJ6K9bYHlvZyUCd1bagl4lX7ZBR0xrwNen14WVVGeFC
	Q1Xa0dWLoJ52Rjob/kCeO5uK+lTViehjfTdCW+6IqeX2690O7kBg4OuL5TwwFcu1A61XWX
	6HOUVS2T5Cz0fD/v5pkzaSu20ChRIi0=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-837d43e9ff3so948457b3a.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940859; x=1778545659; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Obu+hjMmt2gyOfNoZeJMdjxX5bs05kcQmj8x3MdMggE=;
        b=ahhqgxSocvcW4XNhOBdxo/ua+xMztXip1dpfEO7CHGm7rlJNsUqRfXIHMbeWM8JrpE
         1yAv6BNdAk6bMWdlimGi3WpbSxbomiJ00BymHyrV6+BVfRD1y7SlTWKoVQfNLG7kuZP+
         3W5aD3w+QN8eVW2QVoziVqcaMHFFgGQrhfRFE4ZiQObS5PCGPhR1QUCs1JVYDJEvG7nV
         kqUcmBXpxbKJ84qAAISCAPIcEe/xp7mz4/VV0HBeybafLd+/1ElZhRDvV1G/yNa7nikZ
         tOwHRJV/UJpvPYKj8ot3srgQOd8rNbal/4uiOyEWNyEw0ZnqKQaNV8lx4FOaJ8nPOIgE
         5CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940859; x=1778545659;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Obu+hjMmt2gyOfNoZeJMdjxX5bs05kcQmj8x3MdMggE=;
        b=sXY50t2tHDmal9oWu7u3oKbvmlLwQrm0q4x+eJKp4to1Q2ukhh9d7W7YPIfNHlEdm/
         +sdAWzcAIUOewGto9+2w36BEHvnT3vQATVijK3BBgSU8UUWoB+ZEL+AWk7xaaImq12Dv
         EfKHRPqOs1KN+M43GryzOd/xi/NL5y967PZsiy4fUJnUQzebv53nE111JZ7tU3Gk5YCY
         puAl9H9pCGAeeGJsZwrqHKIkHsURTCfWGjIlUXhojhsOjQikZrDvSsJqrvl5NGGRGO29
         xKk9C7/E/7Fk4v6RRjBblvb4XIjbzxoYEGLlTECxARNMR3Scz81f3G9h8JpLY7HxTFw9
         4apA==
X-Forwarded-Encrypted: i=1; AFNElJ8GMcRry85Ifepg4qw9lD5rIFszfzaxFRGGrGzSv5JBavOz/AMlDxNifRILPd2om2Q6+iUAOfcZkg==@kvack.org
X-Gm-Message-State: AOJu0YyX9pH1wTPi1J8L1ltjdjZ6BJfKNkidFRq0/KqM/LKMEVKPpfYf
	iZ1BJFB1RfGmhzaEj2Y9jb0nFyDVJZfliL1t8mzquy+JTW94NrsU3/nEPPsNMbh0GGj26QIpF3d
	6lmfCwTVFGQUeRg==
X-Received: from pfbhh11.prod.google.com ([2002:a05:6a00:868b:b0:82f:a959:4a7f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4188:b0:834:e5a2:d089 with SMTP id d2e1a72fcca58-8352d29abeamr10788662b3a.33.1777940858612;
 Mon, 04 May 2026 17:27:38 -0700 (PDT)
Date: Tue,  5 May 2026 00:27:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002737.2213734-1-skhawaja@google.com>
Subject: [RFC PATCH 0/4] dma-mapping: Add preservation of direct allocations
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tb3448xczp11h3y37xf9ni4dx6rw4ind
X-Rspam-User: 
X-Rspamd-Queue-Id: 093D5A0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777940859-826173
X-HE-Meta: U2FsdGVkX19d6pAcP5IMxYt80FarNbY7OOz8qZ+woYyXNcStd1moTkFWitNw0MFkA9wAnXEEhE2qpRU/jmQd2I9a4Kdaqe71Jz9KlH2lURP9KKVLYuy5bDlK9VIPsCwf/6byB9Ix1JmbXEV47MBF5ZXNVQ4Rd5JNv1AEQfj5M03z1XtjuLMbeQ2qzzMj5SL69/niP5Ih91YliLtvIzdmMEla6x+JI/o/okBTJ8TeIyUAhyl15GwGa/1Cg6HIAxyQ2ACCviBqn95wnujmhLny/LTSGuAOxt5TBIxkzH6TCduQqDikudw0HUqfq1YzgIWmolPLj/+cmUCR2wESjGMbMbrHJty3T0oGheDcdC4L7kBxt/aHbdGmKA1kra15v8IyJmINtGR+SZfhu236Eq7CNfvSgZUNk8TUdPQJmbHfwgZrcuLGcDSuxXtcmX4Fct6igBLzTar+SNlKWrdz5xQY15Kfznn3LEOjeYgUPug5OEvQps7UPgIyjTMSGAIjmbnK36E2iMK/cJ69J0pWSHSX0zztleOfi5QJWYQLS07j4AmHQXRYyRyt9UcEQfPoEdHoxMUtHfDET81q1USXPE+UpQ3Q8VbMWNsa7GUXgnnCIr9RhAn0M1cArKzg3NXIwDQ03YaOsy24a3Ov1mafoPSiPeammBc6gvuMrz6da2qMbtH7a8NA68deIdbwuDx8cJiPFB6M3OjiU3aR7MlzTCxQBw3/ksKo+9UbE9PspvjFbAibNtuaM04GKkhZo3Vayoo7sktLN/x8bqAudg7bDGK0wGPAaF/hUNluWSyIirch1jYSUqo/KbG8k19zymfpQxcUlb++Bk8LXBWuMjVgD9UoYZaa0GRfpUCJ+wrua65wSMrc+4qIUNQrHkzZrdls5WbfKyKrMAo+G47smMBn3dqfVvOklkMZbJF9gb4hNLEYZYeNQzaGyzRboPEboVurl8PvbOSfq79TSwX3G4+NXnb
 7k2B3KZ5
 Y41/VFmpeA7n9q5hEIhTI/yahQJMHcj/sTxiXNJpERWGimMx4neIYeXxfJgaYRtSbXJMDtlkpK82ejhyj/Yi3cHnRbzY4cRiOLbJCP/DccoxT7uB3fYsEunjBumm8Er7rHMKGwjPj3Tfud2m2h63GMUG+tJ37ksgiRVWD+JYLtLXT0WDbEZZKXSbmAedcTbPsvv/eLJWhRCMYsFwZyApbh4tllCG2Lo0dLnD/wSMeblBlrkhMgCXzcstMwr0weyTx9aET5ngZdtHfd5VsEadJN0gFIk0Ogk1IlWgn73CqmZgzHGYH/IR9cpmZ34EFHHp8UDcKG87HWv5TzsUxrvHbVUw2nQLqIOuCsdiRla/OP3hg25nplPyOiNiM/mea0s5wbTZTIWUgZmGZrl+4qHww9jzExMsUxAyeDkVBvSri2XKhEZuhkBvCdh2jGciDseiu1bZheecGKhzwndMLY773FNEaenOZ6H1qq3egbRjPLqGbyJylICD+Y9iVpDcn+TP7JtlgtS6gMY+5mMI7ucgHaMarapECidjwNf146DvmU4G9NQ435gJKNNeSIwpHe8V2NRTxSGr+I7wd7OH5lwAevsDqQIQtz7TOOKQ2C9f/j2SRej5jKPYjtce9+58Ba13A8Vib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC to discuss the preservation of DMA allocations for
devices that are using direct allocation mode. Note preservation here
means preservation of physical memory only using KHO. IOVAs and IOMMU
mappings are out of scope.

The complexity and need of this was discussed in the thread mentioned
below. It was proposed to allow preservation of only a subset of
allocations with minimum support.

https://lore.kernel.org/all/aepfYzkI7NsVGCF0@google.com/
https://lore.kernel.org/all/aepRy7Gp7Ng85Zr7@willie-the-truck/

Note DMA allocation allows allocation from various allocators in various
configurations. This RFC supports preservation with,

- Direct Allocation Only.
- Pages allocated through alloc_page (Buddy allocator).
- No CMA support.
- No DMA allocators.

The changes are also pushed here:
https://github.com/samikhawaja/linux/tree/dma-alloc-preserve-direct

Looking forward to your feedback on this.

Thanks

Samiullah Khawaja (4):
  dma: Add DMA allocation preservation KHO ABI
  dma/pool: Add an API to check if DMA allocation is from pool
  dma-direct: Add API to preserve/restore allocations
  dma-mapping: Add API to preserve/restore DMA allocation

 include/linux/dma-direct.h        |  29 ++++++
 include/linux/dma-map-ops.h       |   1 +
 include/linux/dma-mapping.h       |  50 +++++++++
 include/linux/kho/abi/dma_alloc.h |  30 ++++++
 kernel/dma/Kconfig                |   3 +
 kernel/dma/direct.c               | 163 ++++++++++++++++++++++++++++++
 kernel/dma/mapping.c              |  52 ++++++++++
 kernel/dma/pool.c                 |  13 +++
 8 files changed, 341 insertions(+)
 create mode 100644 include/linux/kho/abi/dma_alloc.h


base-commit: 9974969c14031a097d6b45bcb7a06bb4aa525c40
-- 
2.54.0.545.g6539524ca2-goog


