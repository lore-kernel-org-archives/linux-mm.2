Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B378ECA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620836B0088; Tue, 29 Sep 2026 01:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1BB6B008A; Tue, 29 Sep 2026 01:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7496B008C; Tue, 29 Sep 2026 01:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DAF66B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C89011A03E6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:10 +0000 (UTC)
X-FDA: 85265681340.07.990A842
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5711E40006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PkLJ81Wc;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790659989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=utwCr7dhiJhH+7zfFzlq+sGzsmDUrkDOgCiJgBfnXiw=;
	b=pXwLdLoqx095spslI0K6FmJDDG7WpJ9LSSXUjXrMx+cT8YtaEu1ygWrlwoP0vA98/1sxcK
	i+2Sjzq7ekk/e24+djIdyCV5whD1Shk2LKSYMTJ4t8chXyEflWyNeRpVMVoLL1cnMJ9kxF
	rPpM6icjOnn7mNV6hD0fTfStP8+g8kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790659989;
	b=oo48h9zW5gwOHVhIkz4+rnsz9y1JFfESDwlKFSYCTRqBfOn4LdxT4zjbRXuO/cjwVml6rl
	8bO9RPsbEYutjHotbDcIXaVjbDvVnjcsdvRzWRcxQgQug7MC1Sy4JRy9NAn9z+J45PlIMt
	CGGb/pmZbux1Y2jJ5TIqn3vDPqchZwY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PkLJ81Wc;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df9754484aso18284325ad.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790659987; x=1791264787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=utwCr7dhiJhH+7zfFzlq+sGzsmDUrkDOgCiJgBfnXiw=;
        b=PkLJ81WcbtDvmvYTIWQUdvH5JPCmBV6gYDCA05BIyMDh16T/QfhvSVlbdSPbARJwyb
         O3ESSVWm1PkkfClM9BkE4aGw9kyBL9tomM6KqCl/ePZwQffQWlmy4/zFzU8nlt8jnthX
         baWRPoxllNV04XgRvtZ7363S/WKgDv2IiPu0ci+UrMJcain3pesdXUfm0qzrsKC7i3sS
         oC4YMVD4jE4yAuqYBMdYLck1bqhIgHnVHic3s+9DrPhVVoIk6T7EbOHGiEzyG5Lny7WS
         BXJUNXdPfLwer0G9oypRPsD35xlF0VYbjAxH0zzi90+eR0b7z/KCnkZJ2Pb/UUDLusZi
         0npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790659987; x=1791264787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utwCr7dhiJhH+7zfFzlq+sGzsmDUrkDOgCiJgBfnXiw=;
        b=jgbKX3qoSxkUh29nxuV4Hz7ih5bMQtYqFE9eBRzUzGyDsxfipyOV65cb9UIXn9Go9G
         NeVjp7PCXxSfZ08LmOKfknAEahUmd3pUXhobO+6aSKhAwcAuhB0WCnnFTaIM+imjq3Ch
         tE92uF0Vk8YjkeClCJdvK1slCcoKIr2PBIZBt+YxZAJIqF7//ZSS6R/Efrqj+n37qcZh
         3A5QskTjjig5t0CvNoTq5hgE7u5K/RiGK1rS9ypbJr5CAdeZg9EeI7xo6594FQEVPrvO
         OqVKnHd9ON2PWLIvHALVNLi7GS/0wfphg/KO/quFTdsAfVYmQCHPom6uwjoptOc0rCcU
         GBqg==
X-Forwarded-Encrypted: i=1; AKwUvBx6BJUNgVL11OqT9Ap3oFqaGBQuiTeZHV+xTCvbmNzVn/FAn/fykJQSZFeU7qidML3qMVeL76E/ow==@kvack.org
X-Gm-Message-State: AFq9FYLplNyLcQF1rNUdBYmcriVUtMhW4yZEZ4JQ4L1+u8fypeXORQEM
	yDVxlS4W8R6tF6zQYKW7iNlz70jMq7o/B5sV1lAFBHZD8E838fYCfYeO9O8u1Z12Kxo=
X-Gm-Gg: AYBFou16yUU1/Yzb0y/SE8MPOKiMMUuLNfS6XsSSNtzcihZQyhYTwwOP48aVj1HUpDN
	jzfC+lp2IWDCn6MJeAqYrVvD3Bv+EaZA1aVfo+kLGrdXahuJzCHTg+nELvxZOjg1NGCaHAaU68H
	ZYneJnUGFf8nAakV1iGBGxJzHgSha89qfmbLIbK7+JkxACiDIyPglrjbb9SVX99eQQXTd4+NmkJ
	H4LXtZ6wM+B5d7i3MJ94Eu7rI66r9jgtYMBeiagLVJ8j3dpFjgKbex3Q6cvX0W7B9LMrvxnpbRs
	72sOcS3Va79EeSQYpOFDHauUtXfytAUgemY95T/61upB1ye3sbm80D3WpQkh0uxfVeeCOD0D7LK
	/fpdWeuKw4akA5sdr15meJG1n+Xa1GcQerSE+bETKB6SsWEwW3xUL35P+8j9DT5te5fVwWJEsc9
	yRwjdUe7O+HoQfP9i2VNK4XO+Fj94YJwsIaJkilrtezt75WCSocWTc8+3PrtUD+WwQDeAaUudVp
	j/GtN9g2RnX85sMNWY=
X-Received: by 2002:a17:903:1447:b0:2dd:c0ff:e737 with SMTP id d9443c01a7336-2df7e11e8d9mr118705625ad.73.1790659986929;
        Mon, 28 Sep 2026 22:33:06 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.32.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v3 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
Date: Tue, 29 Sep 2026 13:32:25 +0800
Message-ID: <20260929053231.66085-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5711E40006
X-Stat-Signature: am7ofywipyfy7pksdqw19kiu4uq9jgfd
X-HE-Tag: 1790659988-478902
X-HE-Meta: U2FsdGVkX1/s/87h+D1EGRANG2rKXfmneTfOIp/Jc5FTqZeAWQgM9IGfHx4v4MkggYeoKocXw385qPGBCm1/m52+t3udfDkbIpQ0+TerLMh61pgk3pkJimtWoxMzRY7YnWMiIgMSEnQHEzk2qzF0oqrRE2o9a/TGDNCHjG5z+abwFWoaxHUfm6y2mbL5NdAdO0pkL/iZuhEVsohpo1Zbe0fNFUK2KwuyTfzpMGZrrZjcW66RTqvrbdI6tffxx3YKQcuaeBgsN1gAQ75Xp+T3W2loHCB10mwwRF2XrIxCtABLVkIj58vJRfn9qIJuiOpIw6dlbdEO+05zdfA2/LGI860WpuZly4tS+0hJ1DEzawacTsO9/gMv5aJgEWUdiVqcJdX1QqGcht1DPFaRzy8OUCkoOEpg6ub4NLV4BM158d7eceZHzLzJzL8TgHWngdhLmzPvfpdk3qmkrVkzOEJqJf/SQBy+U+FGWT8O9Jw+4kM/OjCIlBIAOcSNsLbhidD5xGAN+E1BTaXs0IgxM/8fa32TCl+SDaa5Sc8XfidyIBNn13KNep6QXW2Vq8O/bIvDBR5HNIYuwOndKZHfnwxbzaMHn5WfLX43A8LaBsGkA7ntkhzv5OMwtgMkoWtahirb7x9zefZkekFJUot9oR6rO/2gGnKs6jniMOws9myH6DknbgRDWQ1NS6WRZGN/AtzCVWvK8f3RnKqIzz2d+zdyGdaQRXC63/bN5sOICoW1Xa5I2XmApUB69vv2o3ap5dOFE5Gedw0ksOfZUmqmoEiUnCCRWlwxsQC+doL/gnSILU3mWTwEiVZh6b+iAY/CF6O5mZreXeOcc8aBjc8puQLhScMHY1199lGkC7iQ6rhM+45LYb5nvadnq50ijz+h4yn7PUZvAohBu/rigwa653pb3+Nx2egxK8UeO/4ofEzQLoAzMFtIynpdlIPaiLThEdhrQreWsN2BkN4Sf38zA4t
 QDYG29bP
 t0P45tqqfkananuQaJYBTZ1ruBFs8A5dY5e8DOkBmqMU/PWyFbMZe/Lj9fCdGNPO+UNDHUkggzgVFrjQhL4GpwKf38C/TdLNk9bMAV9d9nodDZ2LU7rtxlr0gkXibc5JIwBKnt+Mxq+zcWgpnH6CSKdJ209XYUwHyfmImShazaHuLkaDkfWr5fP8a6LS4bMtfpVBJBHeF8hvq4GhombrOIPDHDcGx6sH7MdokJf1w47roAYryLSkXeGNhH+6aTxGUt+lz7t57BpEmke9hG11WMDnaqhJKI7DFv/YUeXtqmsK4zOb9fJ8dA2ouhpn2NYcsRaKnBhw+SGmC8ld5lUlF9pXl4EZbqYRwMljjLD3UWZHx29Ceisvs23u4gzAA9jTND+nyOJi3kpEWI2xyGdcJq+KzzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This v3 is based on mm-new commit 2ddb90ee544a, which contains v5 of
"mm: Switch device DAX to section-based vmemmap optimization" [1].

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [2]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: unifying their vmemmap population paths.

After the preceding Device DAX conversion, both HugeTLB and Device DAX
describe optimized vmemmap mappings through memory-section metadata and
use per-zone shared tail vmemmap pages. The generic code, however, still
carries a Device DAX-specific population flag and compound-page population
path, along with arguments and helpers needed only by that path.

This series first removes VMEMMAP_POPULATE_DAX and moves selection and
reference handling for the shared tail page into the common vmemmap
population path. It then removes the generic Device DAX-specific
compound-page population path and routes section vmemmap population
through vmemmap_populate(). The powerpc radix path continues to use its
architecture-specific compound-page population implementation for
optimizable sections.

The remaining patches remove the unused ptpfn argument, open-code
vmemmap_populate_address() now that no caller needs its returned PTE, and
add a warning for inconsistent zone initialization of shared tail vmemmap
pages.

This is the fourth smaller step toward the broader HVO generalization.
After this series, HugeTLB and Device DAX use the same population model
instead of parallel generic paths, while powerpc keeps its
architecture-specific implementation.

[1] https://lore.kernel.org/20260927025441.741633-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

v3:
- Rebase onto mm-new commit 2ddb90ee544a, which contains v5 of the Device
  DAX section-based vmemmap series.
- Document the exact dependency order as suggested by David Hildenbrand
  and Ritesh Harjani.
- Use the public order-based optimization predicate in the powerpc path.
- Collect Acked-by tags from Qi Zheng.

v2: https://lore.kernel.org/20260924075259.2013039-1-songmuchun@bytedance.com/
- Expand the comments around the slab initialization boundary as suggested
  by Qi Zheng.
- Collect Acked-by tags from Qi Zheng.
- Defer the patch making vmemmap_populate_compound_pages() static to a
  follow-up series that cleans up the powerpc vmemmap population code.
- Add a new patch to warn about mismatched zone IDs between a page and its
  shared tail vmemmap page.

v1: https://lore.kernel.org/20260913083734.86802-1-songmuchun@bytedance.com/

Muchun Song (6):
  mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
  mm/sparse-vmemmap: support device DAX in common vmemmap path
  mm/sparse-vmemmap: drop Device DAX-specific population path
  mm/sparse-vmemmap: remove the unused ptpfn argument
  mm/sparse-vmemmap: open-code vmemmap_populate_address()
  mm/mm_init: add zone mismatch warning during page init

 arch/powerpc/mm/book3s64/radix_pgtable.c |   3 +
 mm/mm_init.c                             |   5 +-
 mm/sparse-vmemmap.c                      | 208 ++++++-----------------
 3 files changed, 63 insertions(+), 153 deletions(-)


base-commit: 2ddb90ee544ae97215afc4698dc223293997cc43
-- 
2.54.0


