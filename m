Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA66DE8FDA2
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF71D6B0092; Fri, 26 Dec 2025 01:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCA16B0093; Fri, 26 Dec 2025 01:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42006B0095; Fri, 26 Dec 2025 01:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 921B86B0092
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 451B41397D2
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:18 +0000 (UTC)
X-FDA: 84260592276.15.48A20C3
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf22.hostedemail.com (Postfix) with ESMTP id E85AAC0006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UkMBrbfi;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnRd4EJWYs/9sCTzmmaNbKrgHdbTp0fWSzYOWQAfVac=;
	b=H/YwN1jeXjkxyQGwFbJqrX8IZYp/Uw7sXUT+DPrjxdz2fyyi0dzO3upfyvasggwbJL1sPS
	bEAdnSyJFX/C4Qceamap8h8baFIuigwAbwlmFNHUMatEjUVJVuDDQKV01xxD7OfqUhAT5y
	x9rqfgBEg2guOhDdNQeQw0vwvcaDToY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UkMBrbfi;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729296; a=rsa-sha256;
	cv=none;
	b=R95c5P0ZvEJ4hdU4kDiNI4rl/dEWaVPTNntLN9GnPhGe4ty1JDUnYUK5xEIvQPM+gTMujN
	1bKu4LITPoaxuP03/mGg7GF517ApU5Tmw540In0EL2LyAWnHDRpZroPUs/EEcyJ/eDTqDv
	4TRZBkXsU1BhZIiYlMwULpXnZmPUt3w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729293; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BnRd4EJWYs/9sCTzmmaNbKrgHdbTp0fWSzYOWQAfVac=;
	b=UkMBrbfiWLuBuE8qp2LNTK9TMx710LZqMHCKrG5PpV2l2/KAE9FDelkE3Yqzd+df2o6Sbsr0T7yQtACjEUmjHBzpygbmwu1059ioOEwTVmvCPaprCVx5y6Ffgvx9WDbDH8FE4MLuKDj7YjqlkUEi3jRAsrFMBzdY6qHTx/EBf40=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvgaV6i_1766729291 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:12 +0800
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
Subject: [PATCH v5 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Fri, 26 Dec 2025 14:07:58 +0800
Message-ID: <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8qu1hr85oum4ufg7tbxg4pedkdnofy7a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E85AAC0006
X-HE-Tag: 1766729295-967672
X-HE-Meta: U2FsdGVkX19itVhl7/EG187g0J4IOag54x8oI0aG7ciYGBFGQH4+8s8+F0IDkc7eLek+8oXZpm1Q192Bh+1EjA0jPs/arls8umyKVOEwaLHlaDfGuxa+Lu6JDgm4HYfOjgtUzAbn3dC9wWFvU1pyTEKO/8z32PLnLqDPX/Xt72J/hTv4FR6k0+cJYD0a/sHa9Wpfzi8ogLgi3ro3yHdreC4BYqL7qtCyZmnfGiKUITFfRSfWAJTsUJ1LGRnJsS/0fAB2foXFcK6edNz+HjYRHOFnzRc7MsttPToU8ogtzu7fzeDtQqYMY1p7mFruiux/q9OyXUAtsfNMAtO5leW+giZ1SmbBpS+rnoPPcM4b8LXLoDVMXooHW3UjwYMMzoZdZccx68iP24WnZFAaKzu5JN97qIJl3ZWQMp1lHTri4ruQHcXC/0pDIaRTx85DmPxZiUyhbgImPYobat/xy1Z9+9fABZE1I3H9mCBD2L50I/z5/iOwvVSnXryjAtKDl412EYa2FzZy8Zyh90UDCmpB5I4G1vLA3q/GPeq1z3KiZXFbr16SgtTFYtL7t6G6+uUCIkC/jv7lLhLs3GOZn+9tuq3yBrtH3mpYMkcthHd9FP9R9mA7dxxUx3yGuP9/IbTpSDOmxGdbDtBTHWLzfucOq6F5pOSK80/OhQ1tIl/iZq1yXFeNYSG2fUGMLt/jxIefBMXZ9WpF8hY8oXqsfYEJ8ySGEiDn3hnYdtt6bZAz0hapGvLLaZU8hbqRlK8/5RbWgzIt7AnByK4EmCYI0nmfv0aATTAcIB+bCP0wa3s+YHIp8lw4tEvlzGdGwHRc4wJZUhVX6Up7QUq4c7fp75rK7HkEaEGLfRqwMvyd5IkrxLSMtRtcaHNzZr3pzmW+AnhBB0F0LcHlmv+nj3h+JVbXr7XlKWw8D1sF2IhIP+Ka4crgIm215k/RNTsxtWTFpiTgrZlwDPeIAtXKCAQrvnC
 /3hnrI25
 20027eByeW8dAAWdH5KwQYUT1u08Nzjif0zNPDYFRnJ5RVvA1hS6HiykQ6U2zW4BiWa2RAD5B55xDZBpxMsjjPMR+NyElF5Desw5tVFu54/Ou9lYsbf7116w9w7sow4abmVSQNvba8PvVYx+4k9JmREXL+Uz58SgIR7TPJuUXS296k70F7VsCw1EHSLnYn1j9RRtYW8N0z1KMRqPWZQLryAKViAizUe627NdzR7zu04nA7IFmp8w7TK1wd6ry1xCzR96Uesc8yADBrXQkuIaN54whFHBRGOpBpRslZxxGTaF4a8/oLueBNt/HuyYO9UpAhme3JVOfHNJ/ZSz10+x2HeeJr8RL6Mku4ySYXriDz46w2W0=
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
index 5e9ff16146c3..aa8f642f1260 100644
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


