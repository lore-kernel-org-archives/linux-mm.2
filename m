Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F78606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=IFbGQTj4
Received: by kanga.kvack.org (Postfix)
	id 550DA6B05B9; Mon,  9 Nov 2026 04:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5014F6B05C6; Mon,  9 Nov 2026 04:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4174B6B05C7; Mon,  9 Nov 2026 04:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 131836B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AB64140616
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:22 +0000 (UTC)
X-FDA: 85415130444.20.04E4265
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 995E940008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IFbGQTj4;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218300;
	b=4EHQsH7NEA9JVcSCJ9e0mzJKrmh5neTsKCxS0C9O9NtNP3gJi/7Yy8EZY3F2Er9KU3G7GE
	9RaDV8b/tp1yuBhDXseenbLEkqj/fJPLE/V0lZchAOGF/d2UbwOOEQoL3w0N4VXZvBJvl5
	8MWvWoYepW/RSMXK5g/jKet6+1rxwPo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IFbGQTj4;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kh6WS4JV09X5bkn+ckuHPEH2lqGAS0Kwa0bbH5KEGyg=;
	b=OvI4swrCFPT9mUiTugTcoSX2Ffs7FyBlwAI8NoXLUJ6bG5tmdaqO31D0Eq9QKET0bpkI12
	5n+30Q+t5b65nPGas57RbXkk1cRR1pA7D2G/ORxEoRV/G+xHN/BLwWjR6Ni/Yx2VPIoPoD
	TPgWtm4yIQin3TlfEFY44olja7Kqht4=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15ea896ddc8so1283885c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218297; x=1794823097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kh6WS4JV09X5bkn+ckuHPEH2lqGAS0Kwa0bbH5KEGyg=;
        b=IFbGQTj4jV7aGAY1w0fPaVw+S9gxMWLOIe+xHO8727mRSb7hWQD7pYDhHqnBnushsU
         Oo8iLljQogUJAM4u751MLz9jCeQS9uS1Wt6wiv19mw1TnWj8vNTx67M5kxm/OueCNQxi
         H9I7dU7XyPu1nSHuZMZbnsRyCzZC7HFOcdL1rCN0e5PIuQeR1+FO6VgOwNl4F6dFbOI0
         qcPTFUn5G6wLaLAkta3jP6HSgm2AVsetfqs9CZm1Lwd0OL1ZDJv2ao2CvI4fdZLlQ8EE
         kMlOpKrKLTLGaurLj79xYtBrPaMnohz3tJ8xcWc3jn0y4TefucEletd0jr9B9A8oJmdD
         ZcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218297; x=1794823097;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kh6WS4JV09X5bkn+ckuHPEH2lqGAS0Kwa0bbH5KEGyg=;
        b=269lv+nFYasMwNlBvQS+VHqRjWhFRI2d/gr7E5LwaGQSeozn+2mKLpoiULcG3Vv2gN
         SKxy1cqYcWhQk5pseEScLVyaZbuwxaoxr9QGa+hcShOasZS2XX4FtOFa2VRLkcDfpOSQ
         ZgK44oAS03EK4Six8pVd3v6iKxKLaeRu9LXLG/jWG+0MQgaE0FIwl3cA3Fvw/drGoy/n
         HcarjuZ2I88s/iu7y9GNeqN5fizwjzEAcrv1ximJlwMgS/aaVFbbHAypCqMmuq0wMo8p
         9N6tT7+qDzAmcKDdL0jpZy8Vo7TnGuMrE2lYRAFDiMam+B6/5ODiwjEGTHoJgAtBgqgB
         wJ5Q==
X-Forwarded-Encrypted: i=1; AL+hErGZQ189bTskVOspG6oE+EgBixawH5znpTU7rqWU7J5FMGj5th8wLNhovvEmxS+tA3LwpUGe8YK2cA==@kvack.org
X-Gm-Message-State: APuU4Z+cR/cZsT+eYIc1BVr/1szv5Aq5dHsrXxS6vytJ/8pn9ciSESy0
	X5YWcbPTeLJvI6eCMGAmDNPUAjHdvaZ2S76JDnWUnSk91QpLHxUqLpu9l871/gNhcm8=
X-Gm-Gg: AYBFou2esGNLG1Qxv47Bl+3U9o5qxRsFSDTPP8IbSb/XhCnh4LJOzazY+We+z+0qVGn
	DNIN73rguyK81GJVJxi3xtfTmwL7AJohIMgo9YPoXtuwMDhV00pQjY9okhBS2QVmkNfXsZ2Na8y
	AkcDiEmXKF/l4JHwIAFiAEPyiTprZqD9yfW+5fXO9jSf4kxaQBPaTDdPadAYVcRWOoMIXrgGQLF
	4JonfClPqnd+lIVScp8R/CF8Gpqxt7g1xyRbGeycOpcoxBcTdXVD+LC24czt54tEEP3RSkkLt9h
	ldQEJHF4v30gqNx6hAWmTNV/m97Y0tpek/QJR7IZSiMk7iM94DkzSw5HbpGIJAjZWh/YxfIaYPw
	s6tDcy49YsXCwPJWawSFpfipdOAnzFdiXfgUbO7CiMg+mSaCkXPoHBjvpuloJ0TeaQukdOQmuGw
	gcRcTd+RBcI4zHAMpyz5KU/K8UO3WrjRYL6vyBRzVEVp3XcZD5QsXEf+NrAPVoeyLZYF3deumLZ
	6ERfA1Ks9dkYvZAVOOgYAzh1IBRpu5IBjy5sLZGMzbA3RCCcJgA5VHBsjxxBPTTTxdT9yZmC0bg
	3pUiizQFYbd1hF7/fiyJLXZiPic+xfV5NAWTE0PQa3nZIU4nzQ1UDjqt2SR9/hRedC5foBAWv5f
	n/Hm5bPE=
X-Received: by 2002:a05:7023:884:b0:196:bf5f:8bb with SMTP id a92af1059eb24-1b39fecb7a4mr5891979c88.45.1794218296778;
        Mon, 09 Nov 2026 01:58:16 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:16 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 00/11] mm: Unify memmap initialization for compound pages
Date: Mon,  9 Nov 2026 17:57:55 +0800
Message-ID: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mazuqpdyegcx1my34mgab6uegzr8u4o8
X-Rspamd-Queue-Id: 995E940008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794218298-164154
X-HE-Meta: U2FsdGVkX19zxo384mIJ66lc/2KOpxsB6x8olDRKA+5ZJztcXqDRTU/GW5hbIzEM6Yuq5+obNPPoHGtJvndBmcgDVNBkScW1slMOCxtxrq8WChnyh9+ApLKnn1wIS1XDqY6ZdlZ9qwPFDHFoghSGqfjrA2goW/+yhmNztC/soZroognHIlbjsj+M9mcgF/604FG9G3AhhjqSj1grQ70MhQ0EshooXVAvj90S6vlLK8pqwE8V0JcE+DgZ/cLab1xjL2UZ0QVdrYw2Gqb5yFN2dffFsel4QTsxjz3ANA0z+50e/6qSZzL093h00lyaGAv0abJu6Da/iTqFm8Zd8abisQ6GuQtfg6byhREedsoCvDoWB9ToJ3+AL8zN6L+E5ICGq9D8jxgKt6MZhixMo+a1c9sdeKcgghr+Viqwqlu6HCQQslboSH2wC0+fOyWjzzvZYUsfmJ8UhaBJSm7VkHn3brYH1mz188Gh1pMfc5QyS3A31PVwisETLkDxOneYUNV552YG/QuoFTEH1i31zP7jzoy/g7n9UCp/4H+5+dXVfeSMiEju02I87Kyx8KAkWqLt3YSaKwZUKEkMjo/G3NpNJT85fgJksP7GmMhT9TEqG0MHVTsSAL9OrzJp5WnA2IUr329v0gjBtRmzPqb4QeUJFdsh81MOqVgoaITjXxiC2E5IuaIVKMv0+3tC67y49uNacCcFY05g9cEEMAQTtIUu8U9AaxQ1+tNro7YC261dvPtFNAYPgxBYEj42oUnXmguFAtmBtiSYX67YLflxU/4a5G+HrQFtob/1gHQvu/uHg7r2mMlGc74RnJ2v2niE5DYISs4+PTjl3xT8ddgelsk3qgNtiB2WDRxBlFnCmh3EixBWbN2VVHr4+9s0m1fC4p7451T7hABRr/WCVpPi0ImbmvuDwBLm3zCQxRidy/dM0lf222Bt8PKpjafg/8p9YNLkgzR3oFlRCfJ2610X6xx
 8EDa5SWh
 X7Xb/F3f4JHy9eCQ9Q9Pgae2NIkRtk4QnYtlRVtQ7EIwd7V46myCaZaF9E/bQHJYGQ9yIb8EClLwW1KvRE7bL1mxeWrxG/M/HswjYFCaAhmNHeYwgFC1U3ZEMgS991c7pokJTlavurX0b0b5SpYvV3LHT1eQeqzEqEVC6Z2p4CiRozeZLVlMm2RiuwU99h1SEUgYnb2NLm2RQrx4Qz5ZtSNf43epNNOxUhDEbP6b26yqpul7oSQ6hvEP/vX1IJEq0YWmhQ2iMPUbZ2qfdDqvvKw5jhXA9qn2+0iV+rv7WyvCVDHsAhL1LsW25C9PIrKg3UmITYsYzpxAG8TQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This series is based on the mm-new branch at commit b95f8bb86713.

This series is split out from the earlier, larger series
"mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
generalized vmemmap optimization across HugeTLB and device DAX. One
remaining piece is the separate compound struct page initialization used
by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.

The prerequisite changes already let both users derive their HVO layout
from sparsemem section metadata and use the common sparse-vmemmap
population path. Their post-population initialization still differs,
however. memmap_init_zone_device() builds compound pages from reusable
templates, whereas boot-time HugeTLB retains separate HVO fallback,
compound-page, and pageblock migratetype handling.

This series consolidates those paths in three stages.

The first four patches make the generic memmap initialization code
suitable for sharing. They add zone-consistency verification to template
copies, factor the PFN-independent page state, simplify the ZONE_DEVICE
template setup, and introduce a helper for initializing frozen compound
pages.

The next four patches simplify boot-time gigantic HugeTLB initialization.
They make it rely solely on section-based HVO, mark the entire gigantic
allocation as noinit so HugeTLB owns its memmap setup, and switch the
retained struct pages to the common frozen compound-page helper. With the
last external user gone, __init_single_page() becomes local to mm_init.c.

The final three patches move initialization of early-reserved CMA
pageblocks into cma_activate_area() and localize the CMA helper. This
allows MIGRATE_MOVABLE initialization to move into the shared memmap
helpers. CMA later overrides those pageblocks to MIGRATE_CMA during
activation, while non-CMA HugeTLB and ZONE_DEVICE users retain the
default migratetype.

After this series, boot-time HugeTLB and compound ZONE_DEVICE ranges,
including device DAX, use the same helpers for frozen compound-page and
pageblock initialization.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (11):
  mm/mm_init: verify zones for template-initialized pages
  mm/mm_init: factor out common struct page initialization
  mm/mm_init: simplify zone device page initialization
  mm/mm_init: factor out frozen compound page initialization
  mm/hugetlb: drop boot-time HVO handling for gigantic folios
  mm/hugetlb: initialize all struct pages for bootmem hugepages
  mm/hugetlb: use common compound page initialization helper
  mm/mm_init: make __init_single_page() static
  mm/cma: centralize CMA pageblock initialization
  mm/cma: localize init_cma_pageblock() to cma.c
  mm/mm_init: move pageblock migratetype init to memmap helpers

 include/linux/mm.h   |   8 --
 mm/cma.c             |  24 +++--
 mm/hugetlb.c         | 111 ++-------------------
 mm/hugetlb_vmemmap.c |  17 +---
 mm/mm_init.c         | 232 ++++++++++++++++---------------------------
 mm/mm_init.h         |  14 +--
 mm/sparse-vmemmap.c  |   7 +-
 7 files changed, 120 insertions(+), 293 deletions(-)


base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.54.0


