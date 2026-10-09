Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE71CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 01:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36FB6B0095; Thu,  8 Oct 2026 21:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43F06B0096; Thu,  8 Oct 2026 21:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A656B0098; Thu,  8 Oct 2026 21:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934A06B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:27:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E86C1C1D6A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:56 +0000 (UTC)
X-FDA: 85301351352.23.328A826
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0ED10180005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ncdaZH26;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791509274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/opHJx4qRSwMK+i1zECXdalsN36AHiT0JEBUBFDQwI=;
	b=TN6RgmuZofXv8m06/cMdu6RvoKkGjYGRS3acOfdbna8dl/Z2yg5Sxel9asW7J59VIFzPjL
	uXtfIVpDIReH0PUBb/uAtys5yE/0aDZOErtDGJanC2I/aKsPsV8+a1W0lZ688rNt9R44BY
	CqgROyYCnS8ycqUoUJ1KBTxmDIC0Rh0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ncdaZH26;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791509274;
	b=eQ3iphMCubtnVwuh2pCtpt3dOqalnSzoj0vrZOeu0PAXd4skQz/gddOt8J3xvXzpzhM9uA
	34oy1kQdva8KANjLyi4hfxOlt3tIvAEjCQxQx4F6+myVKx/kigskdTO61ozIrThW2g45qT
	GhWhy3G0JVz14mlnLJEN4HYH+fuWlUo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5792175D;
	Thu,  8 Oct 2026 18:27:49 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90BB43F8C6;
	Thu,  8 Oct 2026 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791509273; bh=BW4kltP6qsGC0wjesYshCGa9/T+akVq8hlsP2xOsRGI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ncdaZH263eQQpKoPp+9vY77MP1zD6+8LZnmJQSva/40XRIR0Z3+m5zmPTBRyJNJrr
	 +S933lE/Uh743ldsoDN3KIMzQY5f1a/xBv9jI94BLBZrDBzat2Px/HjKIbQN2uqML4
	 iHZk7QVbpt3w4KhaD4p31/lid8nL3ONyyBvgBUlw=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Fri, 09 Oct 2026 02:27:34 +0100
Subject: [PATCH v5 3/3] kselftest: mm: introduce size_to_shift() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=BW4kltP6qsGC0wjesYshCGa9/T+akVq8hlsP2xOsRGI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqyEMJkxuAyamllnil5Dcw8F4xoHUrxiEbWhjSc
 O38qC/mMyOJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCashDCQAKCRBt1cPRWsUx
 M8bmC/9KLjWP7sj7aB73kK9gXumDcMHmbkTe4jg10tXLQdfS4O4oZKH5hZDix5sKKY8o3NmB0DF
 zL/p5ZuiBX6Irad0kSqZax6XfhaIX0bDE5qs1oIYnOJWUEt/zL1m4i17msMeRk68z8AcsIY8QHa
 AHQMzhtvGIWfJ3i+QwuF7SZMkQo/ss4d4ENXEJpsi38cmB0Rm2DBWQ5wfbHLyZLLzQcrj0hUicC
 QUSH4ZJ1Np3HK/NUjZjn4mMSccb7PW6REjLxq+p31F7CyIsA1384J61uOc0w8ERqncCzEvWAz6f
 O4YRoyNPBTf7I/HeQP+7OoLAg0rQBnCbUo/SUzGN92ptt5ypzH4ZlaW68538/H/+O8Osc6bWXd0
 a3IBnn295tkzDEvmJZQ6bm0euzUc3WzKnxmhVBnSFj/DwL4pVmbjNhSqksUsXGIUWwZskylcYlX
 ZKWqW2LDZ1ynxcF1qPYHx74HhNZ9Uczm1ak4e9TS0CVKuSTaGjX1SNwomvGPOx3XkQkFk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0ED10180005
X-Rspam-User: 
X-Stat-Signature: q63jem8sej4q5ce9c9mshtk1wt9hwie3
X-HE-Tag: 1791509273-76821
X-HE-Meta: U2FsdGVkX1/2M53Z/F/W4v4IHbCJ7dCNJdyh1BqBSLvVudgr72XLJNQoW1HqIQvlH0ddbeL4dH6GUmhM1L8k7KX4RKN1t5j2pu0fKbDQ5YWoKSvaiz4UDEBDorb3E7irnffPepTmFFecI0WKYXLY6Q1DFbA5NV0y/ftMC6Uzb2hWFYwO2VL1xnQKyTX6bw/iMfKIDnh4k3/AOIPCDcX6EjSFerRtcfvEO4jx4j74Al8m9TZMUCFh9VxMs4NCYduGPHcofq1gRGSsqGQWygToR0zQlphTllYPPUrsjU2Oo03kugzhxv7QBCVg5HpccKfxnUXOMLGjq3SyU39gM5uCGFDlR4UXRGyAsaGcV7nL5ybKmfcYs919aa04bQtdWeGjRZxkmnRH5CInv6usEENbsDPKuuitONnOtRi1uA8J6Wg5WkSfJ5RceLu1Z0vhzRmqa6Tm8AS77RPGT21vBbnSCz2Q8jBS47/Wnm3IjHhGQ49nbeYAVNFxuptDicMxYW/oM6Qs2ESRggITArCI3BMK+hnAUrrMwOBX3zGVm2T2e1XJIKzOrVphjo7j80CTr33ebNFV+105NBv7WMJ2Km+x4GOrc0AE4E6Go6GbIGr33nd7om7uvs+Z6uVoS7T6kySlL91LDkP0GcWVAJv6KjxZbA7atp6ISTZMM+ywSxKDRC//+mx6btjc0z91z+j1foyRzpWoqAalSLrhhWft/AOMa9zejTOHY7b+fnRqDkD+bETgBov3Oh6RtoUs0DftjCOLnlKlI6HMg5DpQE+yuhADC3LI+jlGjvlHycFOwTC8kiwDxeTy/9lxFYXfL+EYnhWrYnB9z3InR0QNRJa8DS7kAw99JnilcxWaKfdcFEEfc/ZDMQnAzTmOwLOlr7o5CE9d6Ioy2G8E4fBeKHgmBqerlqvdg1WcRQ8W1S4lz5z24Dai/V8h4r6xbHu254qdXozloePLCjaKYOtr/1+VYKa
 8mVYWcGl
 iClx6OMXJLh5y4NPagSh1dQgJAYHMK3LShcRmfDttnKRNgx776GNZp2CRYEtKEq+3vighIiv23J8mSVbHPYR7yXE3tCAJL9P4WvTNXCMBMlq18HX1cSFZH3RvoDzpIGMylfjcpnAkjDLOUyjoAYi8Jtgg8WI3uUjAIEX03NjKCAXHjfTjlc3ag+YmC/4Ah6hqHO6xh69I582xZLiP5L5OgdiPfyUjQmt9GOUElqncvoMWLr9LJOBCW2LOpMkM9vXYsI3xhRTzIy8gpODEOg2SEwOTjHhXMHiX1oEh4Xg2jXXBik4s6Lo6plga7o0MApcRhNnb3cwVEGQ3DuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c |  2 +-
 tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index efd99298be135..7175ac8bfdaa3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,7 +194,7 @@ uint64_t pmd_pshift(void)
 	if (__pmd_psize != -1ull)
 		__pmd_psize = pmd_psize();
 
-	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ff51c61636505..67ff4bba5707a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -159,6 +159,18 @@ static inline int sz2ord(size_t size, size_t pagesize)
 	return __builtin_ctzll(size / pagesize);
 }
 
+static inline uint64_t size_to_shift(uint64_t size)
+{
+	/*
+	 * The function returns the corresponding shift only when the size
+	 * is a power of two; otherwise, it returns 0.
+	 */
+	if (!size || (size & (size - 1)))
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 

-- 
2.43.0


