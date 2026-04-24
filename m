Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384A8F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A306D6B009F; Thu, 23 Apr 2026 22:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E09E6B00A2; Thu, 23 Apr 2026 22:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0166B00A0; Thu, 23 Apr 2026 22:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7125C6B009E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39A5E1A0B34
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:00 +0000 (UTC)
X-FDA: 84691934880.20.9A218E7
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id E45F440008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:55:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BSqZHUzH;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VibxaiS1l+eDrVhbcfHr3+QWAZVT1Pa0QhMNfP1+esY=;
	b=GoaCaKocRStQ3+Di4VlFd1D86LnIHApOcJCpL+X9t44/RsDTl9hACh9jjRygZF9pxvnmWc
	bkqBbHblthnqFWMjnM1HHlPdwVdi81awMD48ZNt3YGbuZpMiRr3LSB5F9af1PZkfVGYaAO
	67u0SlF/avkV9MZa258NDzyUN+WA/hg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BSqZHUzH;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999358; a=rsa-sha256;
	cv=none;
	b=1mT4SGyvJ7O1QUj9iHlp47ah8/zDJuILphy/3Oc2oFnJAqOJbehcAr+Qw31mzDf3SAq/jG
	9+rbL3Rf6onJnpauoORWcG4zr4MDFN9YuH9J4wWNx75mxeJ7KmnaX1Y+aAR9GlkHVrDEVJ
	ZYYX97ooj5V98+cmQXebg9S/gBCyPps=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ab232cc803so35763535ad.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999356; x=1777604156; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VibxaiS1l+eDrVhbcfHr3+QWAZVT1Pa0QhMNfP1+esY=;
        b=BSqZHUzHBGuUpZJI1NBzNRMimc5T2vxfHofH1jq+C8eWh/QII/ABBSq8m6RErzm7UD
         y71W2cLWQEarErCgPVbnPz+pU2mOUqDAnBXGiREnrtR5QkOI5io08JjaNuWJ1vl7a8/M
         w6a7KATK/uoYRMph2kuiV3Ddwg+XEWKCT5H4RFdHKuqaNlJ1oDOqEIJ1ARZAwoiPWby9
         YG3PZ30isWaI6mTRIfqGljK7O38MIbymJ0Eqcx2gsLqdyYbEnnETb4Ay9FGajT3n++98
         L1YPLjp6ShvBErMtyNK5cjBiX0QMb7KBG4FyybnO9i7X1r0nm9Q6EICcjJuf1VndHE+t
         fCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999356; x=1777604156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VibxaiS1l+eDrVhbcfHr3+QWAZVT1Pa0QhMNfP1+esY=;
        b=gFL7vBALjiUOPP/ZW1+RyNrJCfjcg4Y8eC7JjMR+OewE4nd/eEIcC0cvI29squW8Rj
         ivefAhvNmjgOkLjwvf+04yjA/ZvvDrAQK1Y5PVhTT77zwNWsULZBNhN9cATIS4wJs8DJ
         KrCFxRE/9h2P9K2La0wIfB8p4qLa7goDiJFe3zvXPTCvJH6fWJvYkUQVV2BVVBhGpenu
         d4ZurItOpBqcJmAUNH5mq7dCyuBkPWDzH8mv9+zRAZTb60hYaBL4dvpnTggtP+XIyMGc
         qwMwhWz8nx98QT5AjhuOYBi0xraLJXjqqwMkfCl0RDrwM4wRsHUJS7yQRGxYv8RuXcbB
         4tmA==
X-Forwarded-Encrypted: i=1; AFNElJ8n52aaEjiHU98fjzKkGT3k9Cmw5HNN38wrCuknEKtdUu0mC7SxPrVvmwp8YWde5hlfcP5y/kbBAw==@kvack.org
X-Gm-Message-State: AOJu0YySwR4RZ34Z6s6dVRsI/gC6Xi6j0oPYB1jVFDwfJSOlIhm4xdd6
	yQo/Y7feGOd8lE7hinWTFt2fHgs8q1DI+HHuQsL8aeYNAqb1HrdUAfG4v0rcY12Zknw=
X-Gm-Gg: AeBDieuSZV88MW2lri58/k69VVR2dcWyvac85vTRyAyxlJwOgOFQkL8JApdEinpuWsK
	ljTD0iv8is+fBXD2GHFuo3fsxG0qjaJpcW/vaRJHIe1KyBc9TmyThKu6LkjA9m/X7Ih4Kf3pMf8
	oovlVICHKJIlP9EjDuAvdVIWphhiCJ380jeKughgA0h7l0JHYWPT3+apkg/rxQUo52GkdM08dat
	rqezBggyghswH7H3babyTuf7gnRGenPZxmccZ64DOmziBDQRjbaRyp6TAZvCCrM+ib5KzBweqq9
	ODyxOyIJxKGeqqdOuvzc8FHeUn9MF4mSYBsy4wps9/ZYCMw4djg5Ri5FsYTXwRnioaXU51n+acJ
	p95mw4G6wOCJuuqmXg2jlQGUlPNZoS/+zCOEgCtPl2FAkQORQH3UKB1cut0mXeO4CAmpj6lexd7
	hwewIzfowaMG/7XSKqEWCbrz+4OlN6bLj1/78USvBcMnf7VWE/JFO5Yvc=
X-Received: by 2002:a17:903:17cf:b0:2b2:4d78:eec2 with SMTP id d9443c01a7336-2b5f9f1ab12mr304233705ad.18.1776999356343;
        Thu, 23 Apr 2026 19:55:56 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:55:55 -0700 (PDT)
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
Subject: [PATCH v6 0/7] mm: fix vmemmap optimization accounting and initialization
Date: Fri, 24 Apr 2026 10:55:40 +0800
Message-Id: <20260424025547.3806072-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E45F440008
X-Stat-Signature: mb5o9u17pw81ufdd7pzzji4dbiq5je3s
X-Rspam-User: 
X-HE-Tag: 1776999357-256532
X-HE-Meta: U2FsdGVkX18mAQx/P9iIGcJHefL2ev8R272hR4Z0CXC9zA3fq2Kzwsjt5AsWIxqBZZ5OJV3wGDRYQ93yakHb2Wdn7wl4WqUHTjP7ri3mPGPcMs98wEus/2rQzRYqJYqfEXLtvUoWbwE2w5zuuWu067BO1nrTMa330ApAY3dY2ZTXbFd0WZRNNNTShqIMZq8ezxu9ZY9q+HNFzhNmCF1yC/W7DIaXjytoR76aZlmM00pe29G/gUpSTIT0hFXSkrCES9BsA3rXqlH5CPKHzdHHdV/67VnP/X/APt3lddWcoXEBiHgVZJrcAMTjPMXhlV6jMKC4tweXMPNBp4fjZiUG5C17dJpQO7L726WghepdhkLYn0x3cdH9AENBHsaAHn2PR5xo5BnP7zUQo4wLCu+IHgJOdwCFK+RTqj6EZIbDLYLLsNMNEEBLj191SV/hnzLYkbY1eJV9YESojqCXOHnZpu7pvzNMGnNOaXuQdzsTimvZ8OxpbZOK2YoWQUhtSsJSo3AbzYj6nIXu3sqslb0o+nu9HIhSIKl4hXDfjeRfoaiohspX4j18+F918hH3pMvyMwK4FAkIq/XkqL/KUQ9b98fONLjRvBaGTzxjh9+E0AV3H6WKQxHQ06z4VlC61g/QAIm9n8/Py19ioXQ8aBLUNcnB1M+PWWcvDCubJUXa1983R8zdMsif51toKvlCfTyoUKj1qqnAOOf19g1GfnT19g4iCHLgpnF2VNcHL2Qzm3OC7GJx8WftbTte490pe4apnk558ppqmF581/kjyzpk2iNFarZlcRVEAMom/FQXfhm7SJsW8L3y+lUCyLtxlA0enzVpdZ+I1loCtbZKmz7lSqrJXyD3brrfqShN2mOr9pttOZznGXjMih5NA5P9p/hPnppHTBF6zmCC5ZyBrbf32zieA35F5N1G43RkLT4NO/vBBXmWmMdkTrs1tcuYszo0WhynAOJXE9/3NnG47rx
 xGCId24l
 vazdcC8TTwZnkrzsA2g1zohadYJQWZ1slBOB/xDAQLITS+xs4fUjxpWS9FglXOZCaiY9g5qSAAMVeHF5d8lMBGRqIpjnHbMx43BVcO9PSwgaTMx2XTHXOFk/fnKQb0h3y9fPn7GceVxIbzEvvGtYFQToG8BDeqLx1kwprUXXvKuzFmwAqsuZ9Wo4AePDuen2pOwLcWlS0ERpGuagG0MDctYf1Kr9lJfXhhx6P0FcggVhxW2b596PUpvihOQZTEZVPYQcTW3KD6KQvD5z82gtRu8xq2ojt5HRwGPzLowF9q4rDhXWpW9AsbRTuAQ==
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

The first four patches fix vmemmap accounting issues. The first patch
fixes an accounting underflow in the section activation failure path.
The second patch fixes incorrect altmap passing in the error path.
The third patch passes pgmap through memory deactivation paths so the
teardown side can determine whether vmemmap optimization was in effect.
The fourth patch uses that information to account the optimized DAX
vmemmap size correctly.

The last three patches handle follow-up initialization and cleanup
issues. Patches 5 and 6 fix initialization issues in mm/mm_init. One
makes sure all pageblocks in ZONE_DEVICE compound pages get their
migratetype initialized. The other fixes a case where DAX memory
hotplug reuses an unoptimized early-section memmap while
compound_nr_pages() still assumes vmemmap optimization, leaving tail
struct pages uninitialized. The last patch factors out the altmap free
and verification logic into a helper.

Changelog:
v5 -> v6:
- Add Cc: stable@vger.kernel.org to bugfix patches.
- mm/sparse-vmemmap: Relax the alignment warning in
  section_nr_vmemmap_pages() for sub-section callers.
- mm/memory_hotplug: Factor out altmap free/check handling into a final
  standalone patch suggested-by from David Hildenbrand.
- Collect Acked-by tags from David.

Muchun Song (7):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/memory_hotplug: Fix incorrect altmap passing in error path
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
  mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
  mm/memory_hotplug: Factor out altmap freeing checks

 arch/arm64/mm/mmu.c            |  5 ++--
 arch/loongarch/mm/init.c       |  5 ++--
 arch/powerpc/mm/mem.c          |  5 ++--
 arch/riscv/mm/init.c           |  5 ++--
 arch/s390/mm/init.c            |  5 ++--
 arch/x86/mm/init_64.c          |  5 ++--
 include/linux/memory_hotplug.h |  8 +++--
 mm/memory_hotplug.c            | 29 ++++++++++--------
 mm/memremap.c                  |  4 +--
 mm/mm_init.c                   | 47 ++++++++++++++++++-----------
 mm/sparse-vmemmap.c            | 55 +++++++++++++++++++++++++---------
 11 files changed, 111 insertions(+), 62 deletions(-)

-- 
2.20.1


