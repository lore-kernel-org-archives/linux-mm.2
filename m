Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9436FC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2866B0088; Mon, 31 Aug 2026 03:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5744F6B008A; Mon, 31 Aug 2026 03:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461976B008C; Mon, 31 Aug 2026 03:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17DD66B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16B801603BB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:31 +0000 (UTC)
X-FDA: 85160802342.30.1FDDB18
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E9F7A0005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hphiiMn8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TXPCi3Qy+Dn1DAAHVgNjvUWIuwmWO5YrhOqB0jfLte0=;
	b=6rpbtmRMWn1MQK0H3Oyr45pEehtXYt6DKuVkd32CSovi84tsPZ0zyTp3litU0+j2iK2CU4
	n5irvS8uHs+khbDmd4lkX4BI2dy42SXjXPCIe6vRFODT9NG2+/PtVZ3DXfjHN2cLoJeBrR
	WbCDlEPZC9z7RxTONVsbO2rOxmnRUSE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hphiiMn8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162869;
	b=t9vqniV7uJjNSEowkj7reEIfOXLT9or9eo4fKlV+YlPKtsGjxFD7jI84mwoTaJLwU+RN+T
	RXqntjKj5C+ms1N7C7gWIhicKqpgKvsrLqlEI7no/waCcLIK5M+FnE9LGtQaLoFehPd1N7
	u2ZgFVsWiren76BhyniFQWQhDlQ+ruc=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8568e3ed034so1991588b3a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162867; x=1788767667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TXPCi3Qy+Dn1DAAHVgNjvUWIuwmWO5YrhOqB0jfLte0=;
        b=hphiiMn8T7zed9SZAVMs+IH6B4J4KQQ1Yk2aSzDv2KFrn08jVxbemcp48AnGF83yUq
         RDmVDFxc1Df/JWx1rG5338xgSg7G3fzmbVdkoGsLCzkyAPrRESCC5mhYjDRyck05BcPa
         5ALxCYJCpcr2Sg+53stfUgoSAk00FzOe5Q1se5YyhM0Ab9G44NRnXyFKtplayzVjX4gT
         icsBtUMJ0643EDAObFSfUmePkrScXLlB+W+gMY7sQNodb3MMJXlHGx7uAuqX7k0smYIs
         JBTEqUKO1DK46duv3WMEO0+mK3nbkddxyZ3Uv3ccora9lnARe4ZkSPB5eFCxuBzdig54
         1sqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162867; x=1788767667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXPCi3Qy+Dn1DAAHVgNjvUWIuwmWO5YrhOqB0jfLte0=;
        b=Td8ygMdyzg0YejQDWFmaeBWnZKqldxeTRkRzrjPHRFEjxJfJktoYPUmoYfd01X4v9R
         jBSWvlcbiHSKopPUoKpeYcLYMLeESYcguxqhx2fVVbztsYdK+5MlW4Nqsd4NqUm86CBm
         ruvs0l8YQbM4Jj3I/fXO2wh2b+0CXu3xQh+QWCQHXcps8b/KDCYwRH1TcgD6IjFMzMe2
         aiOWziJVLjdzPsGUCrt/ukNWMXCreqynGnpUIHPBaKo9VVNcgocZb8Nqmov3HbpoAIJt
         wg9/BrEZGuRGOOOJUCSWF9LtheiCEFyF0fo7xTuKfJWoKz40wFZrETOacO9Cy9CGVflt
         1vYg==
X-Gm-Message-State: AFuF++kjPF6ArEUrnaTvhhzFK6eW6lLiXj2Qbngmqpg/MJnfRZc9e1aE
	Bznb4KJ6fwgvNJV2yLtHkHec98pD0fvNtYADlPKfy9VHP60xKBPw+v6vOsaqE0QsaPc=
X-Gm-Gg: AR+sD12fExPd5y+P8URpLmuedz5sk5vD8nBLeMzo7Y/6bHer9Nnjjhu4iS7ourQ3heT
	Dro/xHxkrdR1yNmx5+7Ppy98JHy4VcycOf6cHnm0GCg31ORoPisLjx1Ck+KzQshpwsynvgj6DOW
	8cVtr+EyEa5pNHN2lBRKJRz2hqfrCnJFOKhBmDeK4aGZztdzhj5oKWloH2lQvvrBnDcgghGsOav
	xXQ8ZH58a4ahEZS5iky09zvUtbBrSwRnwGx+DiresJs0iJeMfm76AdOv4xkSi7LuElzq9Z6Ycvr
	fyItB9y+C0UMCUbkojb4rq/40BXhwoYmB3UxRzNg2KzJxnfRsnCY4l6OhR+KnetWuafsP/NWYDt
	AiHOMI+DvgRQL1iETqkUzp/81RccrzMV4oOwm43krQq3z7V1jVtSRsyu78Yyie4zmukwyWb5TFQ
	DuVswImEOu2foUn0N9ENpMEUikQdy+c1jcZEbnjSUS8TNp/6O0Dph2/FwVz6uqPxUKkv3Lja4DF
	MjenrumFnRjYRZ/j/1XTva05DkkP9vjXyw=
X-Received: by 2002:a05:6a21:e081:b0:3d3:b00b:26e8 with SMTP id adf61e73a8af0-3d3b00b6d9dmr18107787637.28.1788162867110;
        Mon, 31 Aug 2026 00:54:27 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 00/11] mm: Switch device DAX to section-based vmemmap optimization
Date: Mon, 31 Aug 2026 15:53:31 +0800
Message-ID: <20260831075342.57563-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E9F7A0005
X-Stat-Signature: y9egkwkq3adzbsuynccef6bj3fehrsyx
X-Rspam-User: 
X-HE-Tag: 1788162868-58378
X-HE-Meta: U2FsdGVkX19fll0BBcFzaztGdUv5NXryG4v3rMMQO9lpO7TeVjwmeFbyCz5HkAyhZQ9N23U74gC7S0i5DcnrA31TVsIgctQttjUU2uJxBlreayIBZpOh4qKb52NLa9GvYxq3SoUlYHW0zCec+c3bmYAFcXNHgPbHzH1MuCcwHmML7WuWhwP9ivnMUo9eUT/q0L2zG75Qdxij0eEr96k9VEfCORoXqxB2GiqQmPIxc9DGGXfkOAgCDlsg/86Osrc8rwAhTvGvVoIdbdhU247AxBuEmovTfJG99tXZ4DpVXAEXBTJ+NktY75/4Ivd6mR/F6boDSjEnB5U72+A+a8as8G30CBCmaOGGUmXb+NavGwkBedENLfOvSLiMGpdCynguZQFYCghU+zhWnRrblByKCK0vN+M6PVlvQJV8HgHD5k86SGc7CnVhh+JgZ+qAanMDl/juqS+FdDGvCBsT6zAWzuHWD0175ZE37gps77rJB/IiGJ8rUsuVEyiWDbZos3/C09NU3oVwrjmoyXAE+IcejNJpW3mhJ52mlT/36UhqoJ1I4ZFIHqnmO9WH8O30VWsXomOCx9DrE9xIItHRXj6X1a8miiAQvxvDMaLRGE5zv2bbeB1JshcbMXaoPaDYVeIVGu/B5wIG41/MVuF7SSJhYA1UljZQ/SNiVpjysGaPPcyKBRU2nfdLva/r4MBrWGcEcPX+3ra1Ln0InzuoUOPiQus6J05ohsjvAToBBpSKanizXD7pQc2mAUMXsZdKdscCDcGldeb/ux6HX56Z53rDOlQG+YJUArVrNAEvFgm6FvP6oI1r8UZr6Li/SVcrGecVSDq9/GB9niqwEgEOOqOtWts9I+MskBdedZXadrD0ZFL/PItMprVTGovf2n12bsgXXOtCWYyq7Roaw4MsiT/+RHTxgJmTjAZRY9EOmI5ndlz7ukZK8YPkKvFSUIb5u23/iigzeX3f4KelnFQl3tF
 zSOXlG1Z
 bUI+icZtmWaqSiUWn2UJWyWCFhJpq78xciQZ72j5GCINp1YOt3CEexjUTmY+B6AKki0EgYOn2j6avM6/R03qBvV+hxyP/PtUVAPpk23tz5yI1pkIMo7EGResDA3KijFL1i2CMexoj6q7h/+VX4Mc1ORAKQfg7OkE0auLXAYrEIN3cL86SBW7RMUjBFj4zlaRaupyclAElhA6uCox5ZZUVbdhZwAllUC2H1mjRUTRMQGTq/NWbt4CPcIXAtPfp5CIXDVYQQH1NqrkYjclhdaTgxo/0X22Pbh5Ylmer/Fw0Ct3Sbe4KSp0vSzczrLkGOCIPl6xuTh2Xs14cc/x6Phx9cRYwDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: switching device DAX to the section-based
sparse-vmemmap optimization infrastructure introduced for HugeTLB.

After the HugeTLB conversion, optimized vmemmap state is described by
the memory section and the sparse-vmemmap population path can allocate or
reuse shared tail vmemmap pages based on that metadata. Device DAX still
uses the older DAX-specific population model, including a separate tail
vmemmap page reservation and architecture-specific logic to locate or
populate reusable tail pages.

This series makes device DAX use the same section-based model. Device DAX
sets the section order from pgmap->vmemmap_shift before vmemmap
population, uses the common per-zone shared tail vmemmap page, and drops
the extra reserved tail page. The powerpc radix path is updated to use
the same shared tail-page helper, so the generic and powerpc DAX paths
follow the same reservation model.

The first patches prepare the shared infrastructure by introducing a
generic CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION symbol, factoring out
shared tail-page allocation, and keeping the special shared-tail struct
page initialization local to sparse-vmemmap.

The middle patches move device DAX onto that infrastructure by recording
the device DAX compound page order in the memory section, using that
section metadata to back generic device DAX mappings with the common
per-zone shared tail page, exposing the shared helpers so the powerpc
radix path can use the same model, and then dropping the extra DAX-only
tail page reservation, and the now-unused section accounting arguments
can be removed.

The final patch updates the documentation for the new DAX layout.

This is intended to be the third smaller step toward the broader HVO
generalization. The wider HVO consolidation between HugeTLB and device
DAX is left for follow-up series.

[1] https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (11):
  mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
  mm/sparse-vmemmap: open-code init_compound_tail()
  mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
  mm/sparse-vmemmap: set section order for device DAX
  mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: move HVO helpers to a public header
  powerpc/mm: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: drop the extra tail page from device DAX
    reservation
  mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
  Documentation/mm: update DAX vmemmap deduplication docs

 Documentation/arch/powerpc/vmemmap_dedup.rst  |  90 ++-------
 Documentation/mm/vmemmap_dedup.rst            |  32 +--
 MAINTAINERS                                   |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 124 +-----------
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +-
 drivers/dax/Kconfig                           |   1 +
 fs/Kconfig                                    |   1 +
 include/linux/mm.h                            |   6 +-
 include/linux/mmzone.h                        |  23 ++-
 include/linux/page-flags.h                    |   5 +-
 include/linux/vmemmap-optimization.h          |  88 +++++++++
 mm/Kconfig                                    |   3 +
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_vmemmap.c                          |  30 +--
 mm/internal.h                                 |   9 -
 mm/memory_hotplug.c                           |   6 +-
 mm/mm_init.c                                  |  15 +-
 mm/sparse-vmemmap.c                           | 184 ++++++++----------
 mm/sparse.c                                   |   3 +-
 mm/sparse.h                                   |  78 +-------
 20 files changed, 244 insertions(+), 459 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h


base-commit: da6c37ed8beb273e3308e42d4bca3ce11b4432fa
-- 
2.54.0


