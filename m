Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1ACFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2CA6B008A; Tue, 28 Apr 2026 04:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763186B008C; Tue, 28 Apr 2026 04:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678CA6B0092; Tue, 28 Apr 2026 04:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4776B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 253A21A051A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:08 +0000 (UTC)
X-FDA: 84707264376.24.E30788E
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8E5F04000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ia0M3bXL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hoqV22eVCAsRVRHya4lFbLghj59bHdoGO9txDqRFMfw=;
	b=nIa5YZVxNKyrf+zqvK8ANlC0QOl/bewXPTuQB23oAp93lGC5cylwSXrY4IKnqk7fv3Wg/c
	vgyyS4XNHTKmvot2HBsulWAJCM28Rdi1HXWH7k4Z9J4PkMDB+WFhdQybRmrnVeYEFt2X90
	i+nAxrdr93e/FJYjjDM/5C67Kiz0zj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364346; a=rsa-sha256;
	cv=none;
	b=Z5SAkzaFdGUorfpXSNGPLXTfAWhRZZJoGOInUx45uXX8hmgeUe0MRWi6nEXPlFsTY27yGW
	CYKTJnFfpd160jHtjXfrbNiNUhpOuFkIr8T88azhz25VfXFehejsjgls9Ibl4QWBSG47kp
	WAjDEY169eMJfP6Tfh/u0sZSLaQTpQ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ia0M3bXL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so9000970a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364344; x=1777969144; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hoqV22eVCAsRVRHya4lFbLghj59bHdoGO9txDqRFMfw=;
        b=Ia0M3bXLjMeo44nACTYIOPn6lbKCs1skGQvViCElCucAukEp12jAbEtsOdmOELJEYg
         hi1BzInK0n7j2nW8qFJnxMUUoMYKNd7UssUKawNJZWRBh/U/x/b7Yflwkjtt+eLJH4M7
         ScAJi2+QsQmh91NsS5W4XQzp/O12zfLkRujXG/0yJxRPJ0YwFmaajVJdzIeiZ64UiGV+
         nPA1tWxi4TOaERCC9ixOmE+5BXYwk0LchXt1xFEeUcQKNZNd2V9dftrngDGUKs/If2vN
         rTXIiVtkrtAdN0niICjXbNkrDq3FvbWIBI/Ht21Xf8XC3kI4qyUxLi3G7Bvn7AVw3Nnn
         Esyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364344; x=1777969144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hoqV22eVCAsRVRHya4lFbLghj59bHdoGO9txDqRFMfw=;
        b=XWTQXyiTcEsGzWX0popINsUU7XWMCh4S6g4hbaXNUomJ1uW8GY7pGHbGpuSUJDuus/
         EvZcI/RyqU/ifyUS+KWSDveF8xzSEb5uSJ7il0XZ0UPYOm/F9nbPnq116jJwziQ0AkHe
         Juxj9CmfhplUJEYMuANIWgDyamjd8X9V2xRe+V10M9nTDg7IcRcKZcteWq5KhEgAYLKA
         JtCj3J+7S9Zp2Pubz2nlUab21ypnBy/xTJ1M9xa1eKPLM5Jf9K+FQiJrSC2URCnBURKt
         6Ugtb8cSvFtpr0DHvJza9lxujQAXMm4KtoJrH4utqYmg8eGj6F/ldBhwu78nvrUI7Y3m
         qKpw==
X-Forwarded-Encrypted: i=1; AFNElJ8LjJfrV5KSOyW1bnlYc3H5gPVev5t5WfPeEOHFVQodd6k+N8idtI4JnLNoPN2SpE0ug2lDA4hNVQ==@kvack.org
X-Gm-Message-State: AOJu0YxLmvcoxefLU4/fF1Rl3JhgdiSL41M39eGFmW+eLxLwMq0npkhF
	ItwhgOhW5P7AKRt2G2HfRTZxAouMnP6oNYq2sQzNBH3usYaNVuGUz7+bt1mB4P2Eehs=
X-Gm-Gg: AeBDieus+6ROy6SsFN6vb7h28ENYyUBhWS742luO7sJyiEf+tGfOZE4KzwviNo5Ngif
	qOVY9UqGZn2s6etS702jAkRrXiAVJEpTJJC59X2q/07m2615gMYUqfJkrFJQsqAv9mZqAA/YwMI
	Bn5hXReq1SaBVdhXBNIW6zCBwvh0PKy4wHy5BeUB57rUMzMjcvLv+B6p4ik7Xg/2yfeANbkQEpQ
	QSz+OE49zsrdriiiyE1c4zntpd9T/Qcs6s1kObx257JxtZx4gCbSyvQNFzBrRAu9PN/Rf94hcUS
	Ny1toyjPo6oKEsilIsq2WvC/4oqKrbfhMQXF5KKrhgm2/gCNjeL3UIYIYxi38g5dS6gWu50YJop
	NBCQ4bjIjOOrWbImPLJoLHdaFqtZad9fKy6oWGCGvoIg5SXCxSHPbbpzo7ycgxHlXf1/TtDLPLe
	VM8oouz3sHuH8Qj3gGfpAiwFduNorP0vn709qm4IRMWVVWJVXkuwUM2wo=
X-Received: by 2002:a17:90a:d88f:b0:35b:8d89:719b with SMTP id 98e67ed59e1d1-36491fad396mr2247144a91.1.1777364343972;
        Tue, 28 Apr 2026 01:19:03 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v8 0/6] mm: Fix vmemmap optimization accounting and initialization
Date: Tue, 28 Apr 2026 16:18:49 +0800
Message-Id: <20260428081855.1249045-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E5F04000D
X-Rspamd-Server: rspam04
X-Stat-Signature: h9a91e87wbmw9mee19ie9wy4az8puya9
X-HE-Tag: 1777364345-190299
X-HE-Meta: U2FsdGVkX1/zWiDN0BS4Q9yIpEZU4cHP6W1OdPky2NIMjDYTnbXSBLT4SCggvSkNNnAU3w+gN7rF6h3p19ZD/EyfSXESJrHavGw7Paj7vH6A8pFgix4RbYRadUyZwJNzxQVcjbJHAkj5kCKJ4L4jDe93OGNhN6DqmrqZvyVaV2nFjxASh1VohuiIS0YWXUqQMRk3ps/fp57ikiJzHOyozpm3Jb91OSmPcSzaxF4Dko/FFQo7PbdKNE8QtUrLoZ1npnuUQulsXh8E+++sYCr3KbyecP7dDnwCbibkckYpo2+KjSjUbdtQxIAKW/y4WpAZSfhHl9KxfTnQ2OP0zhnW7SXoC8WLd0H5VqzUGztxPtouSe0HYDMzn9LXqD+Tj7BOi67A1otJSsMR7C9Cm5buPXYqH2ojONpDtQcQsE/uydEBD7uUt0QubICE9rY/RVIsNwhPV1rkLKy9/ISRzpnvBeNcPn8tJzqdpwg7EvI7SGXlgk+XTF3MZ1qMrw1B7WeOIMxnLpTBMzho0atI2hQR2RHU80IycuhivyZAI6O30mTI0OZLes80RN83J4NgXWMp1ThEnpl8Iak1cL60Fn62bsbCOt7eix1plXBwH/6oXQ9meutYBXaaFddJyjCyf320iIA8mnbYh3LKxs5d5Ld/HWgMqkAYwQcHzQDSEcPJHljl2Fxd87onOrOgsk4aIAJ7/88v3PlxSxKUGQR8UUDFZ9pEIXMAiYYyNX/FUWaPUhhxnCioaL4+3hE4eL+rdViCK9gioObQmTlWr9nVmg70OUJu3lumw+iaNbKESzTAan4SZpaW1uTE2+7vGEug6NjeCkwXQ+3AKxNbvt8d46PiLwiaBoymzM+aEbuxyYOsjMpQ/TNgia9r1RSr4aVqN/ZWcjbEwkEOZQdhtuT9buC/0vPhh92ert2k4TZNYqQiWQTTRZq9yysqhSIc6UPWsCoODkUY98IVgYbWn/mAFN1
 7zDOEIGe
 jpJ+Un7t2jp0GmMWHG3fZcWWI1WiRdtIEYRYQPu3STXYw4U10f552foQviSiWkvt+I0bPq1UV4uoScnXo7W4vtvVuB4QcVGO/1SxBdUxxDtO/vp4C/apaYOshbrVCgTBiWrqeqKY8r3qAC8c9pnkg9PyZAb91Uw4AxGpIv/9ucVlGh7/3vu24iLoW871dC1qFs5cWGUQc7/O80sg6uBgL7pXQ9MQX27vjy3mgMbtP2xgjoSNhaFuFuuQixYkV90DklnpErkPtQqdwKvTxQYjOhev9Ae0EioZJag4Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths. It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

Patches 1-4 fix vmemmap accounting issues. Patch 1 fixes an accounting
underflow in the section activation failure path by moving vmemmap page
accounting into the lower-level allocation and freeing helpers. Patch 2
fixes incorrect altmap passing in the memory hotplug error path. Patch 3
passes pgmap through memory deactivation paths so the teardown side can
determine whether vmemmap optimization was in effect. Patch 4 uses that
information to account the optimized DAX vmemmap size correctly.

Patches 5-6 fix initialization issues in mm/mm_init. One makes sure all
pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized. The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.

Changes in v8:
- In patch 4, move VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION) to the
  top of section_nr_vmemmap_pages().
- In patch 4, add Acked-by from David Hildenbrand.

Muchun Song (6):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/memory_hotplug: Fix incorrect altmap passing in error path
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
  mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE

 arch/arm64/mm/mmu.c            |  5 +--
 arch/loongarch/mm/init.c       |  5 +--
 arch/powerpc/mm/mem.c          |  5 +--
 arch/riscv/mm/init.c           |  5 +--
 arch/s390/mm/init.c            |  5 +--
 arch/x86/mm/init_64.c          |  5 +--
 include/linux/memory_hotplug.h |  8 +++--
 mm/memory_hotplug.c            | 13 ++++----
 mm/memremap.c                  |  4 +--
 mm/mm_init.c                   | 47 ++++++++++++++++-----------
 mm/sparse-vmemmap.c            | 58 ++++++++++++++++++++++++++--------
 11 files changed, 105 insertions(+), 55 deletions(-)


base-commit: 39704f00f747aba3144289870b5fd8ac230a9aaf
-- 
2.20.1


