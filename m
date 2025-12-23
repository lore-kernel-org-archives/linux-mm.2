Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3355BE748EE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990E56B0005; Tue, 23 Dec 2025 16:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E8C6B0089; Tue, 23 Dec 2025 16:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816756B008A; Tue, 23 Dec 2025 16:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F58F6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:40:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07B381A04F3
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:40:48 +0000 (UTC)
X-FDA: 84252055776.04.6D6B6DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 781C9120015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:40:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDkGPeqQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766526046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9UQSTnAQmdo2rBSn0p2XTDDlxcVKLf9lYvxzUG9tYaw=;
	b=jILUWK+tJ1OujIjlqpfmc4w1zXptfs8Rw4BMPj4zKRhuGHDC8DPMHLMARe56Ax3dBVISkv
	WE3qM6lqtKrY5EFJcxthFlKclJfoiBQVQE4dajBit4tSjj/DfpSJ27Wx3zabxwXp+A77/C
	DEzLdQCiULBI1cfVTn8G1ONUkgk3aiE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDkGPeqQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766526046; a=rsa-sha256;
	cv=none;
	b=2lFXBdE7RwK0OKq45GZUwPYdd8Zk1kneQ63ncND3VFvAnc8E/JbDqBox+byatFockup3qt
	AHDwLeQwm+dgPrXheu/D/PHULr3hHY6VHstHYCI3kP4Kej8tXb0MOZ5wxDLqZ3TFGGQBAr
	ucHQTr8RW6eaJU9HgZneJ9RJA9nbMP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 521A940673;
	Tue, 23 Dec 2025 21:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E280EC113D0;
	Tue, 23 Dec 2025 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766526045;
	bh=OSmgCow6kpvrFchY2IvhiYI8wg7ZEpAnIjGaVk8vaSA=;
	h=From:To:Cc:Subject:Date:From;
	b=YDkGPeqQ/HlBu48bnfJVAqJWIOhh1xtYRDvtMD3ckc9CXs/YHVJDi8doMYiA4At0L
	 WvZui8n5NHT24lLTdnzpkmgmcf1vnVI4s21PG+s9Hg6GRdqYV6dz+c/eVplyrCPpat
	 AYklgbnX7QcU3BlzwR2VoXp+uh1twbYfTQpJ3Jvh94rM1xMe3SUVknHqLQTiDcK+XB
	 VbnLRuLHKL+Sa8mERhjgSI/RMe5PZOzIT+A+FkmUQ2vXysse0jE6NIFGmn9Zc3ETTN
	 O8oNMtMvByO5P84Z/6JFXWilEWJW5fDni+3on97DCSd89b08+tLMrXZexIVKZ4Fx/d
	 /XPGn6gukFpiw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Tue, 23 Dec 2025 22:40:33 +0100
Message-ID: <20251223214037.580860-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 781C9120015
X-Stat-Signature: e4c4ws3hm4m1wadn77xxsdcyp8qnmm5b
X-Rspam-User: 
X-HE-Tag: 1766526046-26559
X-HE-Meta: U2FsdGVkX18hdZffUA53k90GlvKrbfTA8kwRBRPlQekGw8Kw6mLIhYetZnvjwGg21DcvyfIeZ9IpmHuKK8RblEqsav08+O1vnqg/CgfTay2P26g2ZvtNgyZ1UjwN0OgAabTChAWjEutX227QO3CWp7A4pvdhuwDzq03SHR6qpSb24yzjjSdt4JT/OMF9jE6S7o1tKyCyvAmLPHlYp79G+AdqrcOPedYk22EwERZzMpkV0PQJzw6jqWNdvA+MqjMP8UvkRu19E0RE0fmlJDtw0zpX9W89VEco71wxJAPV07xuA3VEi3TkY67qYhrv+vUzgi+MoYv/9qMcgB23CcKOEAje1Jquy9rH5ejsP06hfN/Cn2ooACp/YE7K5x2DkFHjyYJy3JrbbSHdfT4Q5EjSlUsumy8RwVp7Xdb+y4quSjGx+W6sZ1uljvp8ws2zTOlGzvyj/vGJPIw/UR2iUXVyl7RYruNeUn5Cip62ACC5YvZQO1EGvq2fuXlyF1sY04LR6h7WrJyu19ZUtf+CNNQrisIFOvApWGbtP2gm8V7mcT5gPco9iPzc3dG23MwfykA4Jwi2j3a734NajHupH64VshYnUXAqLeXL8GzDsguWd2p7Lf20/TJNUw2PC3mxy4jXn+BZpxl+MJMavZ79TkLio1rKDubIaolgYRepZYhIn+ZQmwTHVBCav2ex6KPqpyasbeF+Rr3kz8JoMX+jPnMbimd+Wh94fvleTWDZfP0TmlJQOyL22S1lbHp+ajP7aJeDCs9iytSv1A+HXuZqvaj2Qf7rWoN/y61LJW3ACpV0dbtFnMjX96uyAjg7e9WFqi5SzRiDN3IN8+ClkJsODZi3PBDNa2DtaemGc7Lb09Ysf5u7KoX8qnJrGJ0+6RsTSm6h1MbahrAjWzZhEWoXz7PpwIfeGoBf/yL8U2NsJm+3wJSrAKz8CjTjwLGXzRmFKSeWIcZRh5vUDZJ3jJFJGWL
 3uabliJd
 YZtHr+xrtbQj1DxE26vTj/JJs+ArsrSr8VPa4SwSjdTul/+A6o7W9EZYnabUdbyGP5VrPrg2tB0Gq+Tc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

I added as much comments + description that I possibly could, and I am
hoping for review from Jann.

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Compile tested on plenty of architectures.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

[1] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
[2] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/

--

v2 -> v3:
* Rebased to 6.19-rc2 and retested on x86
* Changes on last patch:
 * Introduce and use tlb_gather_mmu_vma() for properly setting up mmu_gather
   for hugetlb -- thanks to Harry for pointing me once again at the nasty
   hugetlb integration in mmu_gather
 * Move tlb_remove_huge_tlb_entry() after move_huge_pte()
 * For consistency, always call tlb_gather_mmu_vma() after
   flush_cache_range()
 * Don't pass mmu_gather to hugetlb_change_protection(), simply use
   a local one for now. (avoids messing with tlb_start_vma() /
   tlb_start_end())
 * Dropped Lorenzo's RB due to the changes

v1 -> v2:
* Picked RB's/ACK's, hopefully I didn't miss any
* Added the initialization of fully_unshared_tables in __tlb_gather_mmu()
  (Thanks Nadav!)
* Refined some comments based on Lorenzo's feedback.

Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>

David Hildenbrand (Red Hat) (4):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

 include/asm-generic/tlb.h |  77 +++++++++++++++++++++-
 include/linux/hugetlb.h   |  17 +++--
 include/linux/mm_types.h  |   1 +
 mm/hugetlb.c              | 131 +++++++++++++++++++++-----------------
 mm/mmu_gather.c           |  33 ++++++++++
 mm/rmap.c                 |  45 ++++++-------
 6 files changed, 213 insertions(+), 91 deletions(-)


base-commit: b927546677c876e26eba308550207c2ddf812a43
-- 
2.52.0


