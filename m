Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EC0108E1F7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B986B0492; Thu, 19 Mar 2026 07:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01A76B0494; Thu, 19 Mar 2026 07:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ED66B0495; Thu, 19 Mar 2026 07:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5B1C6B0492
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:50:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82097593E3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:20 +0000 (UTC)
X-FDA: 84562644600.26.28376F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id E21FE1C0011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cFTzhkZEuZGk5mdEmYKsgnsaUq2Bz1VYYLB6dpBYBk=;
	b=Vz0egKrE+EmXYO3r9Mlq3SZfTklQp+voQBc70CmgvxeQU+ZYwctNWl6DJQMaXg5Xl+ba9D
	lwMjFAKRM4a7M4hoIcRaFV2cmNMG+BJiwWVG9pKh11k7fvOfYiqXmsGl0A/1nFjjHIeAlc
	Jqz1v7g99u2zzDezBU80yxcNrWbRfU4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921019; a=rsa-sha256;
	cv=none;
	b=U4Dmo2FDGwxnI2R55Nv4V1SSqTEXmhTIvKJLQa4vRCOMNEAvgUaDBWyDtLKvUSnI5Nek1C
	yNIQBUw99muDGZ0jHNA1BhjxXiHD6w+BLRFauQIUxEjY5Evg+rsh+xSkCMpdL83V2GHlaz
	UnxpfoHhvw36QAF2okRBjGcKzkfDTwI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05AEE20E3;
	Thu, 19 Mar 2026 04:50:12 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C7B4A3F778;
	Thu, 19 Mar 2026 04:50:13 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 3/3] mm: SKIP KASAN for page table allocations
Date: Thu, 19 Mar 2026 11:49:46 +0000
Message-ID: <20260319114952.3241359-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319114952.3241359-1-usama.anjum@arm.com>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E21FE1C0011
X-Stat-Signature: 884cdiqmy389aspbnfg3yqr6m5j3tcnb
X-Rspam-User: 
X-HE-Tag: 1773921018-835929
X-HE-Meta: U2FsdGVkX1+iAzzyQOompObL9WBGb5copk+S1RsVzLvf+eRnLCe9piHrvkNx5GKRGfVDlq4NhIPMcUXAQoIzZbT0Ffp3SNIGiprNPNC/FZ/l2rGAkZcPLQMVRDw5ZB94D9GfTb5taZ80HcUOUN9nK4fqwLfj3OMTrbTVpzHO3WPGD4+nbd3aRHg8gQ3wfi1BF/aizEjJ2u2AomFSiMVQJtt3PSFAxzyVVJyo99XU78s4lSohp1NUcQhPrByVgrmfR6+cP7rdCzLXTnQMYf3HUWGRk97+Utecsmtxaf3SaGMYZmF2pA7WO5zJ48S1dCIjgyPDfHpiinh7qsxLhPPAMxwfvYaQ02MgtfPyOAitQpIWJDhH4AzkmBSVxYTU0kFzNtZqoFAIVX4Y7jzeRmcqOTn0goJKf0+vEKA8tFbzDFeeXSRnjUcWYQFKsxIXgkh/oz11b+yF4Tl2trLWXmncgfJv7/oPk85WC7F7JLgvXpJTJzOXBV+s1jpqVRHirWyhiUTEM2oOUQAT+PMPcuRNyjfUwGEC/GgUeMkgpf3PcvBNuhuErqT5ztz+bPxqXKrigX4xds1xAzY8w+dJPhtaeM6t81phhORFYl57JS5ZRI7ma8SYN0/iLgghdazE0+MTwQ3F0p4KmJpH1junKVJaCKPwuj2h8h/ySiEDYTz20H8tfAugp8Y958LusUMZcyEZjIB5kVUKm+SXHVV/nOjkqDBYpWTUmnma2fz33js6xcFrcg800HA9KrgkDTPPIifmsUGJfTLx5/Rb6AKDxaowyzTHXnPbsfbWswjTlBEpxZT9GboZE18QNWmTwFoRwVdqh7bPvkh+mSyU61Hpa52/Z8C+SS+mJNXk4lWPEWN/mILkjvvxKdV26xe5bzqlnSsLf3fYbOt6L5fWNyTwMrtEh6Y90Gq1YEDSy8Yw7mAewDRsVOecgx/56s8TWyAd/2WM8FQjhHh4UoTFNvehocV
 CAV0zIx+
 0fubrNp/L2slR4uY2ld9uQJXseeqaep8tFr8GT8KnoInq3bnc/hHWHfVLKkIqLpy2xcUgKZNi4v9Jr4HiPcKizR1oRQRH3rCabstmiXcqpD+ZGdWW0j2vgqJ9fb7VDZhyXMrI0HgBrGjjMRdwLirLUH9JDszuNFw15W222Qo4J2SkzLHQ2xJ3sANDSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page tables are always accessed via __va(phys) / phys_to_virt(phys).
With a match-all tag in the pointer, MTE never checks memory tags on
access. Therefore: KASAN HW tags are set during page table allocation
but never checked during use. KASAN poisoning on free provides no
value for these pages as well. Its pure overhead - both at allocation
time and free time. Hence, skip the tag setting for all page tables.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/asm-generic/pgalloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 57137d3ac1592..051aa1331051c 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
-- 
2.47.3


