Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11D3F8A157
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345176B0005; Thu, 16 Apr 2026 07:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5186B0089; Thu, 16 Apr 2026 07:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BFD6B008A; Thu, 16 Apr 2026 07:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07D2F6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:07:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BFF41B8A95
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:03 +0000 (UTC)
X-FDA: 84664141926.17.B5D2580
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id D31664000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wKL2ASzP;
	spf=pass (imf11.hostedemail.com: domain of 31MLgaQoKCDMbRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=31MLgaQoKCDMbRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776337621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lKHwSeRo/ultSF+DvjG6BVyCb2GmqVTT5wmkO/QWglI=;
	b=QCqx8orCMHyOF9L10F5yZdyWunKgpgI2vyhfEVL9uf2bfsoTfMVLB0iJ48k/NStHemd1Ap
	OJulPREV+TVs+SsGmW+6PPpbViLXLtG4MaNOPDCRcXq4sXwF1xJ3zk8nybAFTgW54XhiA3
	JceYBlWUtcjCYmBOvZNQ6hqbtYsX2PE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wKL2ASzP;
	spf=pass (imf11.hostedemail.com: domain of 31MLgaQoKCDMbRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=31MLgaQoKCDMbRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776337621; a=rsa-sha256;
	cv=none;
	b=W1XTKyXCtTjcLOlsGUtnWgmLX0bsGbAM16uJBAtSZn0klS4lhFInJSUoW/rnGT7TCxUHEB
	tZzXbTYtwr4WfiG25duYkT+yoIqvvkYjUTqqbVJP9WQoNehb3lHN8zh6gydifzmocuTReD
	kvABH+sq2qQIj8GZMryO7UqIWNmyD0E=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-66f103b3141so5134181a12.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776337620; x=1776942420; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lKHwSeRo/ultSF+DvjG6BVyCb2GmqVTT5wmkO/QWglI=;
        b=wKL2ASzPkgjLXIxCY6p501sdTsNf+oNiTRiZiBoqYhR0p6fb+jZxQ7uR1jI4NSo//2
         Q3pTcnnPuP8+IKXTnbr0fABTj4gDuZOG5Qh3ylttIfQ63kW+CZAU28um6nd7Aw8X5Lzv
         K5HHydN9/mU7Zq7q2xo0lYzJ9ItQQNyMNKKoyUc/H5HNIsZmKbogCAzaxzaclErUZolc
         DKkjm3PKZ0cv+gJpEVzmkKKIFdUltdLywzdzKrw07jZGAks1xF7VbUDdBxjVhcQcfDPR
         QymP9s+aKKaSy7tyaGy2Uzlt6kolK9qAU8Bw/ZUqv+G4OYjrsBqza6j6VZxg60VES1Su
         prHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776337620; x=1776942420;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lKHwSeRo/ultSF+DvjG6BVyCb2GmqVTT5wmkO/QWglI=;
        b=jHTBV6AErMKzTSpUEtJtRftWk1TVjU3KIUN1V2S5/aTV4eC4r4Dssqcgxmdi+arcTB
         +feWElVwacpX38o9fTAPlAe7AWgJ3AoqvikreE1OwlOL/cwucnrWRlTmx2xT8YCHmtqR
         EEcC9szbBjqkJf37SyqVLlE0xc+XRhKJ6zVGzCT+3uSPgzkEXnvoldlvPM32rrxJh4Br
         j7XQFiKVEKDFqWRHucETCAMJL6pbXi9snatf15tYWkKU/Xp8syyvotQRteK9+fpMDPhW
         t3Oojtj0lr7ImgZkR5X0Ve8eJ+MLIMuk115cq0NuQ+bErZiBGAH7eEEN0wDXuN8ROuzf
         Yiww==
X-Forwarded-Encrypted: i=1; AFNElJ8c/R6BKTNXnvFQ2z99wjQP8DAytH8JSksSRC7zXHldr8xJX1gao2EOmApj0CK4cvqV94KGE+3DLQ==@kvack.org
X-Gm-Message-State: AOJu0YxZu0d1IQqJ2TTv+VjkcmuFClTatNDQeE13niBiNV5/t3Fezmq3
	CfY3K8NiomoNxRGmb4dtf7XBqTpPzPtPcnlHY7U+vScaAwAhXPdvI2Pj2EbkrGsbE7/Gvuqv3mP
	ZmAt0XussKJ2dlFjDqq4Y0w==
X-Received: from educ13.prod.google.com ([2002:a05:6402:100d:b0:66e:cdad:9d95])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2b99:b0:671:bc46:1b93 with SMTP id 4fb4d7f45d1cf-671bc461f4dmr6398522a12.18.1776337620197;
 Thu, 16 Apr 2026 04:07:00 -0700 (PDT)
Date: Thu, 16 Apr 2026 13:06:52 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260416110654.247398-1-mclapinski@google.com>
Subject: [PATCH v8 0/2] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: atk7kw4c87eccji63p7w6gwdwr5j4fxr
X-Rspamd-Queue-Id: D31664000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776337621-55194
X-HE-Meta: U2FsdGVkX18RqWyfOwilFE4dC9DfCOpE7mjT6GG6+Fk3Mom8khKUU/Jstzr7jDeElBP37ZJ0plvohX1Bml6FbOgMrwVXIY3kb5OP5q/qfCt1t3WAjmK0+j8TewKVEEB+uOUG8b+ADmGY/oa9NtC2BPxT2Y6c6bGHxd50dTYkau+JuruMIzDMgBgPg8hU+O4cUIicS5RBHjtYb/yqwRDIhGydxdsqRE6u/wf9pOF/fp2sRTtFa7zfDxuznbH8ikBY4MKVuIwBi9gsvFzmmaYjxW32E5jqyhRwWJ1ulHgZyHPc6tf0+3TzIUH3sgpvQFC7FFnA2vUgdLET56FqYyQ3mXgSoXCk0Bybm5UTVQGDtZX/ynZaFQVmEsDmhgmTTf01CbnLXa0MJhWBfihimyMfi+1PQ0i1hBojKPeikkRyLuO7nLeWkt3AcrNoyquRVWQ7lR0yyEZkOMdhdkaLWbtMrcz0ypM+9oajvDzj5y2AKbxWSud7g/jN/hP8Gg1y32HK/rH0sXYvJaS66OljvAi7rxe2UzSG9IZrL1ujQ0kTDhHy0iLO/q7M8TezDdUIahCum4lqZGsjT8Wocxs3sY7r0ShlugS51vbImK13S3RErf7AhrvyRvEpGKiX3BCWO+fyScsLlA0xV24sWTAOHDGWVP/DIPCfzPzdYg08ZYfq7nq0H0SE5ScUMEWAXk3DNAo1bLlzfw6jDdjJwNJhfQJqNkj105HIGz56EbwMj4lBAA0PoXe1xJdaB+hKCtWjYj6aA0VvSjS2ua4glLDUDg+aCDPQeTGXrF8/UdE8jRFjArvHlTFdfcZr/IQUbITb2sgFjlPSPTooKqt6bSAFmMbM9gUZTGNie/jBUQwg/ekPFHUp5epFhxWlID1EQmj0AxQk3WUKh7G5LabLo6FRHATYYXgcHblz4RtbZ9xKrPGQ6gNsX+4EzV+Wix6OyZj2MGMJUHnetyC3HyXDN/sCIKb
 Xsn2S3Qv
 /EEyhRWCx+NntIj3hUFVHloJNTh/1RhDpwSl3R7c8MtOiOGebyFRahTH6kxGiLZwVxU35mycMiTfeqmo09VtSbvTKYA4pIUX9zbv2WEAAcwjDdggDIF+nmTVEEbX6STiwNFOHcFB4BDpJTRLtNvkWZWwUkYtQdt2NeXzGK7P6qHAyQ/VeAEX/TA+sEnbrTM3maT4V+Wbn3d6412CKWLfndY4dsMfqAf+ai8FchG0TvTDQux+GK8GvaNGUE3pGYHZuB4mR8P29rQYK/0L+WJT8iYGnEl/+Es6VKwroUKZGLBPUtemQ30rc1wcSXk4LoyFEsUAZPt6VxPxBpaPGQ783/BYH1eWHltlm5x/8GNgmlOw7VpjMw2fnLPRSopAOCphQ/1vXuVMmWwiI/4RysQlMO/jbisg+skAiRtAnuAyV0NzwnjwB50E0bsVLTiJ612xXfYqhdxyIa2o6Qj1rRWT8mtQ3+/NlTFisDlWBokKvoVLYDO4+wdhQMXjCgdVCMgO6Mc0gu3FqF2Gcugdd7iAuCuaDbuS7gTtiU5RFgS0roJNtfg3/7ZtATyEF6KJsq8MpgmPzhAIdluoU0czij9480y410lMFs8VJMdqOjnK3WhvoLok8UF8U/5rMANP/zUR61QemOgveEZ1pPo/sVEGAgA1OK0RvF5KP9YyZbctz46ufF9jtV/itB1nI0tJg7BELIjBar2nOT+L1RC7D2nO4wgFgIf0dKqIY8Xlu2TBO1Osoz0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
initialization is deferred to parallel kthreads that run later in
the boot process.

Currently, KHO is incompatible with DEFERRED.
This series fixes that incompatibility.
---
v8:
- moved overriding the migratetype from init_pageblock_migratetype
  to callsites
v7:
- reimplemented the initialization of kho scratch again
v6:
- reimplemented the initialization of kho scratch
v5:
- rebased
v4:
- added a new commit to fix deferred init of kho scratch
- switched to ulong when refering to pfn
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

I took Evangelos's test code:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
and then modified it to this monster test that does 2 allocations:
at core_initcall (early) and at module_init (late). Then kexec, then
2 more allocations at these points, then restore the original 2, then
kexec, then restore the other 2. Basically I test preservation of early
and late allocation both on cold and on warm boot.
Tested it both with and without DEFERRED.

This patch probably doesn't apply onto anything currently.
It's based on mm-new with
"memblock: move reserve_bootmem_range() to memblock.c and make it static"
cherrypicked from rppt/memblock.

Evangelos Petrongonas (1):
  kho: make preserved pages compatible with deferred struct page init

Michal Clapinski (1):
  kho: fix deferred initialization of scratch areas

 include/linux/memblock.h           |  7 ++--
 kernel/liveupdate/Kconfig          |  2 --
 kernel/liveupdate/kexec_handover.c | 52 +++++++++++++++---------------
 mm/memblock.c                      | 41 +++++++++++------------
 mm/mm_init.c                       | 27 +++++++++++-----
 5 files changed, 69 insertions(+), 60 deletions(-)

-- 
2.54.0.rc1.555.g9c883467ad-goog


