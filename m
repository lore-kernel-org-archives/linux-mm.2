Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B18C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9676B042A; Thu, 13 Aug 2026 05:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1086B042B; Thu, 13 Aug 2026 05:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0416B042C; Thu, 13 Aug 2026 05:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B02F6B042A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:01:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21D7D405EB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:43 +0000 (UTC)
X-FDA: 85095653286.13.A866F00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75EAB10000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsbqgX3p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TeOxiJEUoJt9ta7d0802hJ6XT8ew33Za02S/dYKxQzE=;
	b=Jkww0BWfPt7AApnaldAUISOf6WLW5tVey6C8o0PC8ZoyKEyJzVg2F0xm/DuSXSyo9A7dEN
	MiASmkcz5nEqZrz8CV1yKa4ZZpxbpbnrRy9fyV6ET1th5ZJDdxAg39Sxp2qFQ/BmwqU0xI
	aqZf+/2YYotERPCmvAbJACRL7zCkfZw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsbqgX3p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611701;
	b=7B+wA7OOas0e3L5RhIrRrv4CxQV+XY0uFXnaAVXRWjwGWV5iN0NCvhpk3hQX5oQRXZ8Kze
	Mj3RxYukbo/g4MIGszsu1RPrDfxf8M2JwWWbFFOSvOBmvVs0hm46wmBzbRF1YVh+7kj2tU
	PyfomC3fhIJ3ZFpTB5rOMNpbTzCBFaw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA0E8600AD;
	Thu, 13 Aug 2026 09:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2104E1F00A3A;
	Thu, 13 Aug 2026 09:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611700;
	bh=TeOxiJEUoJt9ta7d0802hJ6XT8ew33Za02S/dYKxQzE=;
	h=From:Subject:Date:To:Cc;
	b=QsbqgX3pco4IttYrm2WPSSzVQc3us8bd0J/04fo2HISthgSft/f/U+Vt4mA4VLmQG
	 kevvRNCb8JBMdIti0BOAJVlTJTZ9413L2W1qC8tWHp9FiyLiVG9YHbfhh5jkwV/8It
	 iQTcwbyy1RuDsq2RZJxD2f84SSpFhE1dPPSPf/eyNZbrNRlgImYqkXpuG2+wNlibSt
	 r9ZNWv1nhmLOvO9P2INYKLukrtPvhPdcStrvJR5mu+txjIhGXSai65FRF3DdRGhnQz
	 eQt9BMRMD5VS+joclkejrvcjSfRhjjteVCMiIHQGSVJvuCS9osJhU757cYwQ55q/jh
	 spV//z95QabQw==
From: Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v2 0/5] x86/mm/pat: CPA fixes
Date: Thu, 13 Aug 2026 12:01:23 +0300
Message-Id: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02OQQ6CMBBFr0JmbbVMAyWuvIdh0ZYRqlJIiwRDu
 LstxsTlm//y/6wQyFsKcM5W8DTbYAcXAQ8ZmE65lphtIgNyLLlEycyo2M0uFFgjjBSGy6KUCNE
 fPe1B1K/1l8NL38lMqSAZWgVi2itnunSa7HhaqvLU9ynsbJgG/94/mfNU8hut/kbnnHGG1KAoU
 HCuxeVB3tHzOPgW6m3bPvkuFLbSAAAA
X-Change-ID: 20260727-cpa-fixes-d3c73c075672
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>, Mike Rapoport <rppt@kernel.org>, 
 Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Steffen Dirkwinkel <lists@steffen.cc>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 75EAB10000A
X-Stat-Signature: 1g7dnfzkdbqgnefm6h9tbehfc53dwfb4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786611701-492489
X-HE-Meta: U2FsdGVkX19dt+IFMPDssAthappdMbW+uumkbPE14dJDlY3a0cBBwi5mNF3cv03I+er+RYbHQ0autYGBkuN3nEiVHOpjXoQ0c1GascN4s66IScV7A8+jgwf5xPFF9h0JTHSaW5gzF1Qb2f+ipcMsEMkY6nofH6xM8imr73p+VEXsJOjv7VoRQcEPRrNvKlAH84AIrhohAuRBaW3gHgTGARWrfZGW5PCwPpk4436x/4wSLTSPtxElojEMDvWHeEYAvVYHh42n22hzl5BHnd+mFsblmAnEPkWBoKZ4detWUE1kjvncTjQiPj0O1xoHm/Wdo1Zbdb9OeZ/axqeJgUHf125W7/kcMV98x9Yrj2uHGzJfGlzuorpyIbXiWOInLTnrzZpLn/ooITi9RPaueZHXf+1giQIbM5Gt0Fn2Lo2VNXSoZ0OZyFjvdcINpaWKWT+0Nxq6UEylyz6+OP3Eo07c29CCNGn9cap95PtSehbElLDpKELywz3EJ9RIq0u3A9eqwgjHE+42v+cpW47mDX/c48o+djpy8xYHpXFyG64/SzaCKoSu1IaSd7WAS7nOBR9+TH2Dy5DzhSO+pjOTzn9HHOzv5T7vXJXqQCzUPZjgi8tC9Fb8B9SqO6JPl6hT+m52VMaC90KbsZIN28lM1BZ2PAuGRab8ZiPtqIHqUIpBijCMeI7Mf/Uy86g5ZKr/wIvEPG/WK9q36X09LpjK0yguvkhx53c0WXw4nD2m8M5UPWYEaU1/3jVgqLaDpIvazjw2+u6Z1/jBu4cI+xuwg6vaJMtsM1NFewHeeLxqwhFdqKAjmvqkrjwjH0+FFkLGLkp81p6h0PU7CRTISltYzZGm6JJApG4kswSjtIGQQb2SZ32ZqJf3Aj8FJ3Bc3Q51k9YLDGvKOy0xaJMnKo9MnMYoHl2MBRv5tu3KiKWbVqVNuUEK9ifOUCTIjci4adeIXUERDz/NVXNLV52MR3pnF5N
 +id1XeJ6
 RXUBkYXHd++uwVTTTw6EQCCPrisCbmsp1Xos0N27lzrhxhcZkYTSZdtgzvSWvODsXxlvzhMGEvSP940ZiyJ0kHHkpyL6w/EtRoN9Rw7eQ9KAYDKnnMMkfCktqO/tnR6wRlKdfg+RboOW8tzc0b3+ulTO4qNRKSgn/b9IO7B9r2gLBz/A/WsmqhmAn0hxhWHQRb2ky8ZitNm9KC3plmTnkTL/jBB7Kvftn4qzk9A3t+RdSZx/1QaXPe5VrzM/kmcB6HeLghP+PQ0gxtthyxwmA35n8PpaiI/C78NDsg7B8duhVP4TXKgbryVQPw0GfphH0xFuFcByQ4mp1bT6OIHVIUuJClHttB6Np2ncIFWdphuqbZF7smZBrgnIDAz68+xV3/e/rsTx71PVCEPAeG64qmRBTRlcwl7Nn7lDEoyvS2rpnv5UjB+p8YgUO/F4dh1RQRy3BYXkyvLWPsftFfLzJmUsKoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first three patches are urgent, the third patch fixes BUG() reported
y several people and it depends on the first two.

There were no bug reports that the last two patches fix because bug
manifestations won't yell at users.

TL;DR version:

There are a couple of CPA fixes floating around:

Denis Lunev fixed races between split and collapse of the large mappings:

https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org

Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:

https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org

and an issue with stale page tables in IOMMU:

https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org

Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr()
used for the verification of RWX:

https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org

Pedro Falcato closed a race between text poking and collapse of large
pages:

https://lore.kernel.org/all/anCK3eWFMwZqq5ka@pedro-suse

Some of the fixes got merged into x86 tree, some of them got merged into mm
tree and some are still hanging in the air.

The changes here are collected from all these fixes into a single coherent
set on top of tip/x86/mm:
 
* fix for races between CPA and ptdump causing UAF
* update to the fix of the race between split and collapse of large
  mappings
* fix for races between CPA and vmalloc_to_page() in text poking
* fix for stale page tables in IOMMU
* fix for effective RW computation in lookup_address_in_pgd_attr()

---
v2 changes:
* rebased on the current tip/x86/mm that includes peterz's changes for
  DEBUG_PAGEALLOC
* added fix for CPA vs text poking race

v1: https://patch.msgid.link/20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org

---
Lorenzo Stoakes (ARM) (3):
      x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
      x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
      x86/mm/pat: allocate split page tables as kernel page tables

Mike Rapoport (Microsoft) (1):
      x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()

Pedro Falcato (1):
      x86/alternative: exclude text poking against change_page_attr()

 arch/x86/kernel/alternative.c | 39 ++++++++++++++++++++++++---
 arch/x86/mm/pat/set_memory.c  | 61 +++++++++++++++++++++++++++++++------------
 include/linux/mmap_lock.h     |  2 ++
 3 files changed, 83 insertions(+), 19 deletions(-)
---
base-commit: 7da514d819a0afb148634aac92b3d190f34947c3
change-id: 20260727-cpa-fixes-d3c73c075672

--
Sincerely yours,
Mike.


