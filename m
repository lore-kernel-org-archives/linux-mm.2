Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52458E81BCD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88B96B0095; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E3C6B0098; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C706B0096; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA56B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39682C047F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:53 +0000 (UTC)
X-FDA: 84425096826.25.2175CD8
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 25B581C0012
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qPCZqI93;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4FAjNkrLVn5/fJXGkDg2151qhgfQnv8ILOdH8RvokU=;
	b=bbSFvBXXPmFOYNitqFQYwDetIIHH6Q4udew3H1s6jt0hQt9T70MWdiwUv4UO5mK9K1mjd5
	uwIs53jg3A9CuVJXtE/7keEdnp597kPkQcMyHQriSwe9WMWkAuAnu6lw4CW5/RRcQy179S
	jrjqKEYR+fUFXPbNCmSw0ldP3/S32NY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qPCZqI93;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646071; a=rsa-sha256;
	cv=none;
	b=0Y8BQbfCdf7nLJxhvHVR9F9scVXMnW0p9hrZhcXwJIpX7s/5Bcnv/1l8FV3+K4B7m2Kjpl
	tGxIRTipWlw9Yl5spk1PuaolH0/ty479b88OpXArqAeoNmk6frWyUuz/+iO/1ehV6/qfXh
	5GTkHi7q1AW6vB9owNJUr4UJIsUe+fo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646064; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=R4FAjNkrLVn5/fJXGkDg2151qhgfQnv8ILOdH8RvokU=;
	b=qPCZqI93wdHRPv9OY2bM2s/3jFNAxXwP/f2EvKXZ3YsliQmWd2viHjbJZ47D4yPIFwJbyz5gUQbFWrGj1c6Vi3gEx3ODeRGpbv8KeeAC5ogh/Vq+WbYUo6OlIHL4+hUKn+EdRv7uCZVFJATZ495SFpjIO3EE0F+9H+khmeGXdoI=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyt1CAg_1770646062 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:43 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Mon,  9 Feb 2026 22:07:27 +0800
Message-ID: <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gmogkonj9m3iec17aq1pn4pfz91r7p59
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B581C0012
X-HE-Tag: 1770646069-37003
X-HE-Meta: U2FsdGVkX1/BPrxqIBRT+27sCekA/xSZ8713GpqGyEkgj1wwk+gorMOfPLyEZm7vl/WisogQ9bN8unmJGlgBvGA3C2ygEsjBm88+O1gWZfocHI9/JQmuUbgNE8XBv6bh1tx8IC0qPS5HYhyx4Gp1StnKTPBb++HPkpEEL/GFPOE6iKtnBbqcdIw53efKNz66dcWTCEP2ceTph8SIwDpaW8+5a/+vsmuAYgnWtYQcgfPW2gZKMtQebi9f/lBhLTJnN9AqdvwwFsm5/UbKOItLPwt1wXBlUp33t8ZTOEsvOu2HQcqRzZl4BYYExkwb1TSv9UDKXxs3WtSPx+WYIqSJ9SZMK5AUiNZzELJal/w6hFwNoLd+wtRMxnycKwtQwx2vBxGbOPXXiBhiltIZgntLqEyYlzobrQFf9OABE2Cp+uX3s35W4VvMO+KHo3UtJsqMY+DhXS5Jp+NRtMAiw8mGS5Lqby1kQy1dprs0+pTCVc/8I2eUWcUGi0mMPTH8wamXewAVGOJgJpAGwVk4aDHKEmEftxuznCMZAHmpCvKQ3UVpEVkdBZcdmoiwTMAalDl/dfX5g/itUlU/gW6QNG3MWmD+o8aubf5xl5BHnEUcJK6sggOlv7nu0SPMLxgk0Izfq/LOTYM3Nccb5fJis2rFRgYcyIl9TAlRGqs3ep+z8LpTBZSH+hZpVUmOO5Ws9j+b8MBwN45kYLK1APZjPTlmhxlq54Z0509SMiKbbX/EP98rYytiU/9eCfYUEqCtF9OWO/1ILmuaxzkqEWO9xL/23N0Qbd6YDyTKoQZRNfG17aI9DJSgJnphxORsEaFbp4mUhY8a8O22p25OwFXWrfcouUvcvU5p9HvxeYvWLfTbjoGSRTEaYkJaTnPM12wyQ/299Nz3ion1izCcGvTheQii7EqpJEGxMXN3L9k7qP50jFSk1gdIRjjMuZoxzbr2j7B3DFFtP47t+5uwSBI048p
 aXG0sh3Z
 RreoyahZBkHW+ynX8X/noJ9ihwrgicWPM10xOH5B1STtr7YWbH2ou65zepC4TKGAanE1YFjto82NHaX3OOOChMs2MB1OTvQ7U+4bU+j2nxPO/NE0TCE2HzwSLhiTN+aL1oSQEjLBXlgPOjteBungakTCWeV4XYeAR5e5dFaqDz722T5XoXK82KbZVEHcXl3/KZl+NkCofCcRVQuuimq2c0TEmpzx2EHnXVhCSnSZf64PGrPDNH6YIOhezWvADPnK7Z3l1r2CS5To7InLfR70OtnDHFJ0MhfjW1kmEIEIRJk9Qgh3sfAtWWYV9o2OTPzI/ZyyayFqewY1Hlr/sGQJJ8929P/ckqA0wwHa1ZDwqXzcQGrM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
batched checking of young flags and TLB flushing, improving performance during
large folio reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
33% performance improvement on my Arm64 32-core server (and 10%+ improvement
on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3dabf5ea17fa..a17eb8a76788 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
+}
+
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, unsigned int nr)
-- 
2.47.3


